local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((5460 - (234 + 768)) <= (2029 - (35 + 1064)))) then
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
	local v35 = false;
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
	local v111 = 8085 + 3026;
	local v112 = 23772 - 12661;
	local v113;
	local v114 = v17.Monk.Mistweaver;
	local v115 = v19.Monk.Mistweaver;
	local v116 = v24.Monk.Mistweaver;
	local v117 = {};
	local v118;
	local v119;
	local v120 = v21.Commons.Everyone;
	local v121 = v21.Commons.Monk;
	local function v122()
		if (((3 + 659) <= (2208 - (298 + 938))) and v114.ImprovedDetox:IsAvailable()) then
			v120.DispellableDebuffs = v20.MergeTable(v120.DispellableMagicDebuffs, v120.DispellablePoisonDebuffs, v120.DispellableDiseaseDebuffs);
		else
			v120.DispellableDebuffs = v120.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123()
		local v138 = 1259 - (233 + 1026);
		while true do
			if (((6036 - (636 + 1030)) == (2235 + 2135)) and (v138 == (2 + 0))) then
				if ((v86 and (v12:HealthPercentage() <= v87)) or ((1415 + 3347) <= (59 + 802))) then
					local v237 = 221 - (55 + 166);
					while true do
						if ((v237 == (0 + 0)) or ((142 + 1270) == (16284 - 12020))) then
							if ((v88 == "Refreshing Healing Potion") or ((3465 - (36 + 261)) < (3764 - 1611))) then
								if ((v115.RefreshingHealingPotion:IsReady() and v115.RefreshingHealingPotion:IsUsable()) or ((6344 - (34 + 1334)) < (513 + 819))) then
									if (((3596 + 1032) == (5911 - (1035 + 248))) and v23(v116.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 5";
									end
								end
							end
							if ((v88 == "Dreamwalker's Healing Potion") or ((75 - (20 + 1)) == (206 + 189))) then
								if (((401 - (134 + 185)) == (1215 - (549 + 584))) and v115.DreamwalkersHealingPotion:IsReady() and v115.DreamwalkersHealingPotion:IsUsable()) then
									if (v23(v116.RefreshingHealingPotion) or ((1266 - (314 + 371)) < (967 - 685))) then
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
			if (((969 - (478 + 490)) == v138) or ((2442 + 2167) < (3667 - (786 + 386)))) then
				if (((3731 - 2579) == (2531 - (1055 + 324))) and v114.ExpelHarm:IsCastable() and (v12:HealthPercentage() <= v55) and v54 and v12:BuffUp(v114.ChiHarmonyBuff)) then
					if (((3236 - (1093 + 247)) <= (3041 + 381)) and v23(v114.ExpelHarm, nil)) then
						return "expel_harm defensives 3";
					end
				end
				if ((v115.Healthstone:IsReady() and v115.Healthstone:IsUsable() and v84 and (v12:HealthPercentage() <= v85)) or ((105 + 885) > (6431 - 4811))) then
					if (v23(v116.Healthstone) or ((2976 - 2099) > (13359 - 8664))) then
						return "healthstone defensive 4";
					end
				end
				v138 = 4 - 2;
			end
			if (((958 + 1733) >= (7130 - 5279)) and (v138 == (0 - 0))) then
				if ((v114.DampenHarm:IsCastable() and v12:BuffDown(v114.FortifyingBrew) and (v12:HealthPercentage() <= v42) and v41) or ((2251 + 734) >= (12418 - 7562))) then
					if (((4964 - (364 + 324)) >= (3275 - 2080)) and v23(v114.DampenHarm, nil)) then
						return "dampen_harm defensives 1";
					end
				end
				if (((7755 - 4523) <= (1555 + 3135)) and v114.FortifyingBrew:IsCastable() and v12:BuffDown(v114.DampenHarmBuff) and (v12:HealthPercentage() <= v40) and v39) then
					if (v23(v114.FortifyingBrew, nil) or ((3748 - 2852) >= (5038 - 1892))) then
						return "fortifying_brew defensives 2";
					end
				end
				v138 = 2 - 1;
			end
		end
	end
	local function v124()
		local v139 = 1268 - (1249 + 19);
		while true do
			if (((2763 + 298) >= (11513 - 8555)) and (v139 == (1088 - (686 + 400)))) then
				if (((2501 + 686) >= (873 - (73 + 156))) and v105) then
					local v238 = 0 + 0;
					while true do
						if (((1455 - (721 + 90)) <= (8 + 696)) and (v238 == (6 - 4))) then
							v28 = v120.HandleCharredBrambles(v114.Vivify, v116.VivifyMouseover, 510 - (224 + 246));
							if (((1551 - 593) > (1743 - 796)) and v28) then
								return v28;
							end
							v238 = 1 + 2;
						end
						if (((107 + 4385) >= (1950 + 704)) and ((5 - 2) == v238)) then
							v28 = v120.HandleCharredBrambles(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 133 - 93);
							if (((3955 - (203 + 310)) >= (3496 - (1238 + 755))) and v28) then
								return v28;
							end
							break;
						end
						if ((v238 == (1 + 0)) or ((4704 - (709 + 825)) <= (2697 - 1233))) then
							v28 = v120.HandleCharredBrambles(v114.SoothingMist, v116.SoothingMistMouseover, 58 - 18);
							if (v28 or ((5661 - (196 + 668)) == (17324 - 12936))) then
								return v28;
							end
							v238 = 3 - 1;
						end
						if (((1384 - (171 + 662)) <= (774 - (4 + 89))) and (v238 == (0 - 0))) then
							v28 = v120.HandleCharredBrambles(v114.RenewingMist, v116.RenewingMistMouseover, 15 + 25);
							if (((14393 - 11116) > (160 + 247)) and v28) then
								return v28;
							end
							v238 = 1487 - (35 + 1451);
						end
					end
				end
				if (((6148 - (28 + 1425)) >= (3408 - (941 + 1052))) and v106) then
					local v239 = 0 + 0;
					while true do
						if ((v239 == (1516 - (822 + 692))) or ((4585 - 1373) <= (445 + 499))) then
							v28 = v120.HandleFyrakkNPC(v114.Vivify, v116.VivifyMouseover, 337 - (45 + 252));
							if (v28 or ((3064 + 32) <= (619 + 1179))) then
								return v28;
							end
							v239 = 7 - 4;
						end
						if (((3970 - (114 + 319)) == (5078 - 1541)) and (v239 == (1 - 0))) then
							v28 = v120.HandleFyrakkNPC(v114.SoothingMist, v116.SoothingMistMouseover, 26 + 14);
							if (((5715 - 1878) >= (3289 - 1719)) and v28) then
								return v28;
							end
							v239 = 1965 - (556 + 1407);
						end
						if ((v239 == (1209 - (741 + 465))) or ((3415 - (170 + 295)) == (2009 + 1803))) then
							v28 = v120.HandleFyrakkNPC(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 37 + 3);
							if (((11627 - 6904) >= (1922 + 396)) and v28) then
								return v28;
							end
							break;
						end
						if ((v239 == (0 + 0)) or ((1148 + 879) > (4082 - (957 + 273)))) then
							v28 = v120.HandleFyrakkNPC(v114.RenewingMist, v116.RenewingMistMouseover, 11 + 29);
							if (v28 or ((455 + 681) > (16449 - 12132))) then
								return v28;
							end
							v239 = 2 - 1;
						end
					end
				end
				break;
			end
			if (((14502 - 9754) == (23510 - 18762)) and (v139 == (1781 - (389 + 1391)))) then
				if (((2344 + 1392) <= (494 + 4246)) and v103) then
					local v240 = 0 - 0;
					while true do
						if ((v240 == (952 - (783 + 168))) or ((11377 - 7987) <= (3010 + 50))) then
							v28 = v120.HandleChromie(v114.HealingSurge, v116.HealingSurgeMouseover, 351 - (309 + 2));
							if (v28 or ((3067 - 2068) > (3905 - (1090 + 122)))) then
								return v28;
							end
							break;
						end
						if (((151 + 312) < (2018 - 1417)) and (v240 == (0 + 0))) then
							v28 = v120.HandleChromie(v114.Riptide, v116.RiptideMouseover, 1158 - (628 + 490));
							if (v28 or ((392 + 1791) < (1700 - 1013))) then
								return v28;
							end
							v240 = 4 - 3;
						end
					end
				end
				if (((5323 - (431 + 343)) == (9186 - 4637)) and v104) then
					local v241 = 0 - 0;
					while true do
						if (((3691 + 981) == (598 + 4074)) and (v241 == (1696 - (556 + 1139)))) then
							v28 = v120.HandleCharredTreant(v114.SoothingMist, v116.SoothingMistMouseover, 55 - (6 + 9));
							if (v28 or ((672 + 2996) < (203 + 192))) then
								return v28;
							end
							v241 = 171 - (28 + 141);
						end
						if ((v241 == (1 + 1)) or ((5142 - 976) == (323 + 132))) then
							v28 = v120.HandleCharredTreant(v114.Vivify, v116.VivifyMouseover, 1357 - (486 + 831));
							if (v28 or ((11577 - 7128) == (9375 - 6712))) then
								return v28;
							end
							v241 = 1 + 2;
						end
						if ((v241 == (0 - 0)) or ((5540 - (668 + 595)) < (2690 + 299))) then
							v28 = v120.HandleCharredTreant(v114.RenewingMist, v116.RenewingMistMouseover, 9 + 31);
							if (v28 or ((2372 - 1502) >= (4439 - (23 + 267)))) then
								return v28;
							end
							v241 = 1945 - (1129 + 815);
						end
						if (((2599 - (371 + 16)) < (4933 - (1326 + 424))) and (v241 == (5 - 2))) then
							v28 = v120.HandleCharredTreant(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 146 - 106);
							if (((4764 - (88 + 30)) > (3763 - (720 + 51))) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				v139 = 4 - 2;
			end
			if (((3210 - (421 + 1355)) < (5123 - 2017)) and (v139 == (0 + 0))) then
				if (((1869 - (286 + 797)) < (11050 - 8027)) and v102) then
					local v242 = 0 - 0;
					while true do
						if ((v242 == (439 - (397 + 42))) or ((763 + 1679) < (874 - (24 + 776)))) then
							v28 = v120.HandleIncorporeal(v114.Paralysis, v116.ParalysisMouseover, 46 - 16, true);
							if (((5320 - (222 + 563)) == (9992 - 5457)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (v101 or ((2167 + 842) <= (2295 - (23 + 167)))) then
					local v243 = 1798 - (690 + 1108);
					while true do
						if (((661 + 1169) < (3027 + 642)) and (v243 == (848 - (40 + 808)))) then
							v28 = v120.HandleAfflicted(v114.Detox, v116.DetoxMouseover, 5 + 25);
							if (v28 or ((5468 - 4038) >= (3453 + 159))) then
								return v28;
							end
							v243 = 1 + 0;
						end
						if (((1472 + 1211) >= (3031 - (47 + 524))) and ((1 + 0) == v243)) then
							if (v114.Detox:CooldownRemains() or ((4931 - 3127) >= (4897 - 1622))) then
								v28 = v120.HandleAfflicted(v114.Vivify, v116.VivifyMouseover, 68 - 38);
								if (v28 or ((3143 - (1165 + 561)) > (108 + 3521))) then
									return v28;
								end
							end
							break;
						end
					end
				end
				v139 = 3 - 2;
			end
		end
	end
	local function v125()
		local v140 = 0 + 0;
		while true do
			if (((5274 - (341 + 138)) > (109 + 293)) and (v140 == (0 - 0))) then
				if (((5139 - (89 + 237)) > (11468 - 7903)) and v114.ChiBurst:IsCastable() and v50) then
					if (((8235 - 4323) == (4793 - (581 + 300))) and v23(v114.ChiBurst, not v14:IsInRange(1260 - (855 + 365)))) then
						return "chi_burst precombat 4";
					end
				end
				if (((6700 - 3879) <= (1576 + 3248)) and v114.SpinningCraneKick:IsCastable() and v46 and (v119 >= (1237 - (1030 + 205)))) then
					if (((1632 + 106) <= (2042 + 153)) and v23(v114.SpinningCraneKick, not v14:IsInMeleeRange(294 - (156 + 130)))) then
						return "spinning_crane_kick precombat 6";
					end
				end
				v140 = 2 - 1;
			end
			if (((68 - 27) <= (6181 - 3163)) and (v140 == (1 + 0))) then
				if (((1251 + 894) <= (4173 - (10 + 59))) and v114.TigerPalm:IsCastable() and v48) then
					if (((761 + 1928) < (23860 - 19015)) and v23(v114.TigerPalm, not v14:IsInMeleeRange(1168 - (671 + 492)))) then
						return "tiger_palm precombat 8";
					end
				end
				break;
			end
		end
	end
	local function v126()
		local v141 = 0 + 0;
		while true do
			if (((1219 - (369 + 846)) == v141) or ((615 + 1707) > (2238 + 384))) then
				if ((v114.SpinningCraneKick:IsCastable() and v46) or ((6479 - (1036 + 909)) == (1656 + 426))) then
					if (v23(v114.SpinningCraneKick, not v14:IsInMeleeRange(13 - 5)) or ((1774 - (11 + 192)) > (944 + 923))) then
						return "spinning_crane_kick aoe 8";
					end
				end
				break;
			end
			if ((v141 == (175 - (135 + 40))) or ((6430 - 3776) >= (1806 + 1190))) then
				if (((8763 - 4785) > (3153 - 1049)) and v114.SummonWhiteTigerStatue:IsReady() and (v119 >= (179 - (50 + 126))) and v44) then
					if (((8339 - 5344) > (342 + 1199)) and (v43 == "Player")) then
						if (((4662 - (1233 + 180)) > (1922 - (522 + 447))) and v23(v116.SummonWhiteTigerStatuePlayer, not v14:IsInRange(1461 - (107 + 1314)))) then
							return "summon_white_tiger_statue aoe player 1";
						end
					elseif ((v43 == "Cursor") or ((1519 + 1754) > (13934 - 9361))) then
						if (v23(v116.SummonWhiteTigerStatueCursor, not v14:IsInRange(17 + 23)) or ((6257 - 3106) < (5080 - 3796))) then
							return "summon_white_tiger_statue aoe cursor 1";
						end
					elseif (((v43 == "Friendly under Cursor") and v15:Exists() and not v12:CanAttack(v15)) or ((3760 - (716 + 1194)) == (27 + 1502))) then
						if (((88 + 733) < (2626 - (74 + 429))) and v23(v116.SummonWhiteTigerStatueCursor, not v14:IsInRange(77 - 37))) then
							return "summon_white_tiger_statue aoe cursor friendly 1";
						end
					elseif (((448 + 454) < (5322 - 2997)) and (v43 == "Enemy under Cursor") and v15:Exists() and v12:CanAttack(v15)) then
						if (((608 + 250) <= (9131 - 6169)) and v23(v116.SummonWhiteTigerStatueCursor, not v14:IsInRange(98 - 58))) then
							return "summon_white_tiger_statue aoe cursor enemy 1";
						end
					elseif ((v43 == "Confirmation") or ((4379 - (279 + 154)) < (2066 - (454 + 324)))) then
						if (v23(v116.SummonWhiteTigerStatue, not v14:IsInRange(32 + 8)) or ((3259 - (12 + 5)) == (306 + 261))) then
							return "summon_white_tiger_statue aoe confirmation 1";
						end
					end
				end
				if ((v114.TouchofDeath:IsCastable() and v51) or ((2158 - 1311) >= (467 + 796))) then
					if (v23(v114.TouchofDeath, not v14:IsInMeleeRange(1098 - (277 + 816))) or ((9627 - 7374) == (3034 - (1058 + 125)))) then
						return "touch_of_death aoe 2";
					end
				end
				v141 = 1 + 0;
			end
			if ((v141 == (977 - (815 + 160))) or ((8954 - 6867) > (5630 - 3258))) then
				if ((v114.SpinningCraneKick:IsCastable() and v46 and (v14:DebuffDown(v114.MysticTouchDebuff) or (v120.EnemiesWithDebuffCount(v114.MysticTouchDebuff) <= (v119 - (1 + 0)))) and v114.MysticTouch:IsAvailable()) or ((12993 - 8548) < (6047 - (41 + 1857)))) then
					if (v23(v114.SpinningCraneKick, not v14:IsInMeleeRange(1901 - (1222 + 671))) or ((4698 - 2880) == (121 - 36))) then
						return "spinning_crane_kick aoe 5";
					end
				end
				if (((1812 - (229 + 953)) < (3901 - (1111 + 663))) and v114.BlackoutKick:IsCastable() and v114.AncientConcordance:IsAvailable() and v12:BuffUp(v114.JadefireStomp) and v45 and (v119 >= (1582 - (874 + 705)))) then
					if (v23(v114.BlackoutKick, not v14:IsInMeleeRange(1 + 4)) or ((1323 + 615) == (5225 - 2711))) then
						return "blackout_kick aoe 6";
					end
				end
				v141 = 1 + 2;
			end
			if (((4934 - (642 + 37)) >= (13 + 42)) and (v141 == (1 + 2))) then
				if (((7529 - 4530) > (1610 - (233 + 221))) and v114.BlackoutKick:IsCastable() and v114.TeachingsoftheMonastery:IsAvailable() and (v12:BuffStack(v114.TeachingsoftheMonasteryBuff) >= (4 - 2)) and v45) then
					if (((2069 + 281) > (2696 - (718 + 823))) and v23(v114.BlackoutKick, not v14:IsInMeleeRange(4 + 1))) then
						return "blackout_kick aoe 8";
					end
				end
				if (((4834 - (266 + 539)) <= (13739 - 8886)) and v114.TigerPalm:IsCastable() and v114.TeachingsoftheMonastery:IsAvailable() and (v114.BlackoutKick:CooldownRemains() > (1225 - (636 + 589))) and v48 and (v119 >= (6 - 3))) then
					if (v23(v114.TigerPalm, not v14:IsInMeleeRange(10 - 5)) or ((409 + 107) > (1248 + 2186))) then
						return "tiger_palm aoe 7";
					end
				end
				v141 = 1019 - (657 + 358);
			end
			if (((10712 - 6666) >= (6909 - 3876)) and (v141 == (1188 - (1151 + 36)))) then
				if ((v114.JadefireStomp:IsReady() and v49) or ((2626 + 93) <= (381 + 1066))) then
					if (v23(v114.JadefireStomp, not v14:IsInMeleeRange(23 - 15)) or ((5966 - (1552 + 280)) < (4760 - (64 + 770)))) then
						return "JadefireStomp aoe3";
					end
				end
				if ((v114.ChiBurst:IsCastable() and v50) or ((112 + 52) >= (6322 - 3537))) then
					if (v23(v114.ChiBurst, not v14:IsInRange(8 + 32)) or ((1768 - (157 + 1086)) == (4220 - 2111))) then
						return "chi_burst aoe 4";
					end
				end
				v141 = 8 - 6;
			end
		end
	end
	local function v127()
		local v142 = 0 - 0;
		while true do
			if (((44 - 11) == (852 - (599 + 220))) and (v142 == (0 - 0))) then
				if (((4985 - (1813 + 118)) <= (2935 + 1080)) and v114.TouchofDeath:IsCastable() and v51) then
					if (((3088 - (841 + 376)) < (4738 - 1356)) and v23(v114.TouchofDeath, not v14:IsInMeleeRange(2 + 3))) then
						return "touch_of_death st 1";
					end
				end
				if (((3529 - 2236) <= (3025 - (464 + 395))) and v114.JadefireStomp:IsReady() and v49) then
					if (v23(v114.JadefireStomp, nil) or ((6618 - 4039) < (60 + 63))) then
						return "JadefireStomp st 2";
					end
				end
				v142 = 838 - (467 + 370);
			end
			if ((v142 == (1 - 0)) or ((622 + 224) >= (8117 - 5749))) then
				if ((v114.RisingSunKick:IsReady() and v47) or ((626 + 3386) <= (7812 - 4454))) then
					if (((2014 - (150 + 370)) <= (4287 - (74 + 1208))) and v23(v114.RisingSunKick, not v14:IsInMeleeRange(12 - 7))) then
						return "rising_sun_kick st 3";
					end
				end
				if ((v114.ChiBurst:IsCastable() and v50) or ((14754 - 11643) == (1519 + 615))) then
					if (((2745 - (14 + 376)) == (4084 - 1729)) and v23(v114.ChiBurst, not v14:IsInRange(26 + 14))) then
						return "chi_burst st 4";
					end
				end
				v142 = 2 + 0;
			end
			if ((v142 == (3 + 0)) or ((1722 - 1134) <= (325 + 107))) then
				if (((4875 - (23 + 55)) >= (9230 - 5335)) and v114.BlackoutKick:IsCastable() and not v114.TeachingsoftheMonastery:IsAvailable() and v45) then
					if (((2387 + 1190) == (3213 + 364)) and v23(v114.BlackoutKick, not v14:IsInMeleeRange(7 - 2))) then
						return "blackout_kick st 7";
					end
				end
				if (((1194 + 2600) > (4594 - (652 + 249))) and v114.TigerPalm:IsCastable() and v48) then
					if (v23(v114.TigerPalm, not v14:IsInMeleeRange(13 - 8)) or ((3143 - (708 + 1160)) == (11129 - 7029))) then
						return "tiger_palm st 8";
					end
				end
				break;
			end
			if ((v142 == (3 - 1)) or ((1618 - (10 + 17)) >= (805 + 2775))) then
				if (((2715 - (1400 + 332)) <= (3467 - 1659)) and v114.BlackoutKick:IsCastable() and (v12:BuffStack(v114.TeachingsoftheMonasteryBuff) >= (1911 - (242 + 1666))) and (v114.RisingSunKick:CooldownRemains() > v12:GCD()) and v45) then
					if (v23(v114.BlackoutKick, not v14:IsInMeleeRange(3 + 2)) or ((788 + 1362) <= (1021 + 176))) then
						return "blackout_kick st 5";
					end
				end
				if (((4709 - (850 + 90)) >= (2053 - 880)) and v114.TigerPalm:IsCastable() and ((v12:BuffStack(v114.TeachingsoftheMonasteryBuff) < (1393 - (360 + 1030))) or (v12:BuffRemains(v114.TeachingsoftheMonasteryBuff) < (2 + 0))) and v114.TeachingsoftheMonastery:IsAvailable() and v48) then
					if (((4191 - 2706) == (2042 - 557)) and v23(v114.TigerPalm, not v14:IsInMeleeRange(1666 - (909 + 752)))) then
						return "tiger_palm st 6";
					end
				end
				v142 = 1226 - (109 + 1114);
			end
		end
	end
	local function v128()
		local v143 = 0 - 0;
		while true do
			if ((v143 == (1 + 0)) or ((3557 - (6 + 236)) <= (1753 + 1029))) then
				if ((v52 and v114.RenewingMist:IsReady() and v16:BuffDown(v114.RenewingMistBuff)) or ((706 + 170) >= (6989 - 4025))) then
					if ((v16:HealthPercentage() <= v53) or ((3898 - 1666) > (3630 - (1076 + 57)))) then
						if (v23(v116.RenewingMistFocus, not v16:IsSpellInRange(v114.RenewingMist)) or ((347 + 1763) <= (1021 - (579 + 110)))) then
							return "RenewingMist healing st";
						end
					end
				end
				if (((292 + 3394) > (2805 + 367)) and v56 and v114.Vivify:IsReady() and v12:BuffUp(v114.VivaciousVivificationBuff)) then
					if ((v16:HealthPercentage() <= v57) or ((2375 + 2099) < (1227 - (174 + 233)))) then
						if (((11952 - 7673) >= (5058 - 2176)) and v23(v116.VivifyFocus, not v16:IsSpellInRange(v114.Vivify))) then
							return "Vivify instant healing st";
						end
					end
				end
				v143 = 1 + 1;
			end
			if ((v143 == (1176 - (663 + 511))) or ((1811 + 218) >= (765 + 2756))) then
				if ((v60 and v114.SoothingMist:IsReady() and v16:BuffDown(v114.SoothingMist)) or ((6279 - 4242) >= (2811 + 1831))) then
					if (((4049 - 2329) < (10791 - 6333)) and (v16:HealthPercentage() <= v61)) then
						if (v23(v116.SoothingMistFocus, not v16:IsSpellInRange(v114.SoothingMist)) or ((209 + 227) > (5879 - 2858))) then
							return "SoothingMist healing st";
						end
					end
				end
				break;
			end
			if (((509 + 204) <= (78 + 769)) and (v143 == (722 - (478 + 244)))) then
				if (((2671 - (440 + 77)) <= (1833 + 2198)) and v52 and v114.RenewingMist:IsReady() and v16:BuffDown(v114.RenewingMistBuff) and (v114.RenewingMist:ChargesFractional() >= (3.8 - 2))) then
					if (((6171 - (655 + 901)) == (856 + 3759)) and (v16:HealthPercentage() <= v53)) then
						if (v23(v116.RenewingMistFocus, not v16:IsSpellInRange(v114.RenewingMist)) or ((2902 + 888) == (338 + 162))) then
							return "RenewingMist healing st";
						end
					end
				end
				if (((358 - 269) < (1666 - (695 + 750))) and v47 and v114.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.RenewingMistBuff, false, false, 85 - 60) > (1 - 0))) then
					if (((8260 - 6206) >= (1772 - (285 + 66))) and v23(v114.RisingSunKick, not v14:IsInMeleeRange(11 - 6))) then
						return "RisingSunKick healing st";
					end
				end
				v143 = 1311 - (682 + 628);
			end
		end
	end
	local function v129()
		local v144 = 0 + 0;
		while true do
			if (((991 - (176 + 123)) < (1280 + 1778)) and ((0 + 0) == v144)) then
				if ((v47 and v114.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.RenewingMistBuff, false, false, 294 - (239 + 30)) > (1 + 0))) or ((3128 + 126) == (2928 - 1273))) then
					if (v23(v114.RisingSunKick, not v14:IsInMeleeRange(15 - 10)) or ((1611 - (306 + 9)) == (17133 - 12223))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (((586 + 2782) == (2067 + 1301)) and v120.AreUnitsBelowHealthPercentage(v64, v63, v114.EnvelopingMist)) then
					local v244 = 0 + 0;
					while true do
						if (((7557 - 4914) < (5190 - (1140 + 235))) and (v244 == (1 + 0))) then
							if (((1755 + 158) > (127 + 366)) and v62 and v114.EssenceFont:IsReady() and (v12:BuffUp(v114.ThunderFocusTea) or (v114.ThunderFocusTea:CooldownRemains() > (60 - (33 + 19))))) then
								if (((1717 + 3038) > (10274 - 6846)) and v23(v114.EssenceFont, nil)) then
									return "EssenceFont healing aoe";
								end
							end
							if (((609 + 772) <= (4645 - 2276)) and v62 and v114.EssenceFont:IsReady() and v114.AncientTeachings:IsAvailable() and v12:BuffDown(v114.EssenceFontBuff)) then
								if (v23(v114.EssenceFont, nil) or ((4542 + 301) == (4773 - (586 + 103)))) then
									return "EssenceFont healing aoe";
								end
							end
							break;
						end
						if (((426 + 4243) > (1117 - 754)) and (v244 == (1488 - (1309 + 179)))) then
							if ((v36 and (v12:BuffStack(v114.ManaTeaCharges) > v37) and v114.EssenceFont:IsReady() and v114.ManaTea:IsCastable() and not v120.AreUnitsBelowHealthPercentage(144 - 64, 2 + 1, v114.EnvelopingMist)) or ((5040 - 3163) >= (2371 + 767))) then
								if (((10074 - 5332) >= (7225 - 3599)) and v23(v114.ManaTea, nil)) then
									return "EssenceFont healing aoe";
								end
							end
							if ((v38 and v114.ThunderFocusTea:IsReady() and (v114.EssenceFont:CooldownRemains() < v12:GCD())) or ((5149 - (295 + 314)) == (2249 - 1333))) then
								if (v23(v114.ThunderFocusTea, nil) or ((3118 - (1300 + 662)) > (13643 - 9298))) then
									return "ThunderFocusTea healing aoe";
								end
							end
							v244 = 1756 - (1178 + 577);
						end
					end
				end
				v144 = 1 + 0;
			end
			if (((6613 - 4376) < (5654 - (851 + 554))) and (v144 == (1 + 0))) then
				if ((v67 and v114.ZenPulse:IsReady() and v120.AreUnitsBelowHealthPercentage(v69, v68, v114.EnvelopingMist)) or ((7440 - 4757) < (49 - 26))) then
					if (((999 - (115 + 187)) <= (633 + 193)) and v23(v116.ZenPulseFocus, not v16:IsSpellInRange(v114.ZenPulse))) then
						return "ZenPulse healing aoe";
					end
				end
				if (((1047 + 58) <= (4634 - 3458)) and v70 and v114.SheilunsGift:IsReady() and v114.SheilunsGift:IsCastable() and v120.AreUnitsBelowHealthPercentage(v72, v71, v114.EnvelopingMist)) then
					if (((4540 - (160 + 1001)) <= (3335 + 477)) and v23(v114.SheilunsGift, nil)) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
		end
	end
	local function v130()
		local v145 = 0 + 0;
		while true do
			if ((v145 == (0 - 0)) or ((1146 - (237 + 121)) >= (2513 - (525 + 372)))) then
				if (((3514 - 1660) <= (11101 - 7722)) and v58 and v114.EnvelopingMist:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.EnvelopingMist, false, false, 167 - (96 + 46)) < (780 - (643 + 134)))) then
					local v245 = 0 + 0;
					while true do
						if (((10907 - 6358) == (16888 - 12339)) and (v245 == (0 + 0))) then
							v28 = v120.FocusUnitRefreshableBuff(v114.EnvelopingMist, 3 - 1, 81 - 41, nil, false, 744 - (316 + 403), v114.EnvelopingMist);
							if (v28 or ((2009 + 1013) >= (8314 - 5290))) then
								return v28;
							end
							v245 = 1 + 0;
						end
						if (((12138 - 7318) > (1558 + 640)) and ((1 + 0) == v245)) then
							if (v23(v116.EnvelopingMistFocus, not v16:IsSpellInRange(v114.EnvelopingMist)) or ((3676 - 2615) >= (23358 - 18467))) then
								return "Enveloping Mist YuLon";
							end
							break;
						end
					end
				end
				if (((2833 - 1469) <= (257 + 4216)) and v47 and v114.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.EnvelopingMist, false, false, 49 - 24) > (1 + 1))) then
					if (v23(v114.RisingSunKick, not v14:IsInMeleeRange(14 - 9)) or ((3612 - (12 + 5)) <= (11 - 8))) then
						return "Rising Sun Kick YuLon";
					end
				end
				v145 = 1 - 0;
			end
			if ((v145 == (1 - 0)) or ((11585 - 6913) == (782 + 3070))) then
				if (((3532 - (1656 + 317)) == (1390 + 169)) and v60 and v114.SoothingMist:IsReady() and v16:BuffUp(v114.ChiHarmonyBuff) and v16:BuffDown(v114.SoothingMist)) then
					if (v23(v116.SoothingMistFocus, not v16:IsSpellInRange(v114.SoothingMist)) or ((1404 + 348) <= (2095 - 1307))) then
						return "Soothing Mist YuLon";
					end
				end
				break;
			end
		end
	end
	local function v131()
		local v146 = 0 - 0;
		while true do
			if ((v146 == (355 - (5 + 349))) or ((18557 - 14650) == (1448 - (266 + 1005)))) then
				if (((2287 + 1183) > (1893 - 1338)) and v47 and v114.RisingSunKick:IsReady()) then
					if (v23(v114.RisingSunKick, not v14:IsInMeleeRange(6 - 1)) or ((2668 - (561 + 1135)) == (840 - 195))) then
						return "Rising Sun Kick ChiJi";
					end
				end
				if (((10459 - 7277) >= (3181 - (507 + 559))) and v58 and v114.EnvelopingMist:IsReady() and (v12:BuffStack(v114.InvokeChiJiBuff) >= (4 - 2))) then
					if (((12039 - 8146) < (4817 - (212 + 176))) and (v16:HealthPercentage() <= v59)) then
						if (v23(v116.EnvelopingMistFocus, not v16:IsSpellInRange(v114.EnvelopingMist)) or ((3772 - (250 + 655)) < (5194 - 3289))) then
							return "Enveloping Mist 2 Stacks ChiJi";
						end
					end
				end
				v146 = 2 - 0;
			end
			if ((v146 == (2 - 0)) or ((3752 - (1869 + 87)) >= (14050 - 9999))) then
				if (((3520 - (484 + 1417)) <= (8050 - 4294)) and v62 and v114.EssenceFont:IsReady() and v114.AncientTeachings:IsAvailable() and v12:BuffDown(v114.AncientTeachings)) then
					if (((1012 - 408) == (1377 - (48 + 725))) and v23(v114.EssenceFont, nil)) then
						return "Essence Font ChiJi";
					end
				end
				break;
			end
			if ((v146 == (0 - 0)) or ((12030 - 7546) == (524 + 376))) then
				if ((v45 and v114.BlackoutKick:IsReady() and (v12:BuffStack(v114.TeachingsoftheMonastery) >= (7 - 4))) or ((1248 + 3211) <= (325 + 788))) then
					if (((4485 - (152 + 701)) > (4709 - (430 + 881))) and v23(v114.BlackoutKick, not v14:IsInMeleeRange(2 + 3))) then
						return "Blackout Kick ChiJi";
					end
				end
				if (((4977 - (557 + 338)) <= (1454 + 3463)) and v58 and v114.EnvelopingMist:IsReady() and (v12:BuffStack(v114.InvokeChiJiBuff) == (8 - 5))) then
					if (((16920 - 12088) >= (3682 - 2296)) and (v16:HealthPercentage() <= v59)) then
						if (((295 - 158) == (938 - (499 + 302))) and v23(v116.EnvelopingMistFocus, not v16:IsSpellInRange(v114.EnvelopingMist))) then
							return "Enveloping Mist 3 Stacks ChiJi";
						end
					end
				end
				v146 = 867 - (39 + 827);
			end
		end
	end
	local function v132()
		if ((v79 and v114.LifeCocoon:IsReady() and (v16:HealthPercentage() <= v80)) or ((4334 - 2764) >= (9674 - 5342))) then
			if (v23(v116.LifeCocoonFocus, not v16:IsSpellInRange(v114.LifeCocoon)) or ((16141 - 12077) <= (2792 - 973))) then
				return "Life Cocoon CD";
			end
		end
		if ((v81 and v114.Revival:IsReady() and v114.Revival:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v83, v82, v114.EnvelopingMist)) or ((427 + 4559) < (4606 - 3032))) then
			if (((709 + 3717) > (271 - 99)) and v23(v114.Revival, nil)) then
				return "Revival CD";
			end
		end
		if (((690 - (103 + 1)) > (1009 - (475 + 79))) and v81 and v114.Restoral:IsReady() and v114.Restoral:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v83, v82, v114.EnvelopingMist)) then
			if (((1785 - 959) == (2643 - 1817)) and v23(v114.Restoral, nil)) then
				return "Restoral CD";
			end
		end
		if ((v73 and v114.InvokeYulonTheJadeSerpent:IsAvailable() and v114.InvokeYulonTheJadeSerpent:IsReady() and (v120.AreUnitsBelowHealthPercentage(v75, v74, v114.EnvelopingMist) or v35)) or ((520 + 3499) > (3909 + 532))) then
			if (((3520 - (1395 + 108)) < (12399 - 8138)) and v114.InvokeYulonTheJadeSerpent:IsReady() and (v114.RenewingMist:ChargesFractional() < (1205 - (7 + 1197))) and v12:BuffUp(v114.ManaTeaBuff) and (v114.SheilunsGift:TimeSinceLastCast() < ((2 + 2) * v12:GCD()))) then
				if (((1646 + 3070) > (399 - (27 + 292))) and v23(v114.InvokeYulonTheJadeSerpent, nil)) then
					return "Invoke Yu'lon GO";
				end
			end
		end
		if ((v114.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (72 - 47)) or ((4471 - 964) == (13722 - 10450))) then
			local v154 = 0 - 0;
			while true do
				if (((0 - 0) == v154) or ((1015 - (43 + 96)) >= (12543 - 9468))) then
					v28 = v130();
					if (((9838 - 5486) > (2120 + 434)) and v28) then
						return v28;
					end
					break;
				end
			end
		end
		if ((v76 and v114.InvokeChiJiTheRedCrane:IsReady() and v114.InvokeChiJiTheRedCrane:IsAvailable() and (v120.AreUnitsBelowHealthPercentage(v78, v77, v114.EnvelopingMist) or v35)) or ((1245 + 3161) < (7990 - 3947))) then
			if ((v114.InvokeChiJiTheRedCrane:IsReady() and (v114.RenewingMist:ChargesFractional() < (1 + 0)) and v12:BuffUp(v114.AncientTeachings) and (v12:BuffStack(v114.TeachingsoftheMonastery) == (5 - 2)) and (v114.SheilunsGift:TimeSinceLastCast() < ((2 + 2) * v12:GCD()))) or ((139 + 1750) >= (5134 - (1414 + 337)))) then
				if (((3832 - (1642 + 298)) <= (7127 - 4393)) and v23(v114.InvokeChiJiTheRedCrane, nil)) then
					return "Invoke Chi'ji GO";
				end
			end
		end
		if (((5531 - 3608) < (6581 - 4363)) and (v114.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (9 + 16))) then
			v28 = v131();
			if (((1691 + 482) > (1351 - (357 + 615))) and v28) then
				return v28;
			end
		end
	end
	local function v133()
		local v147 = 0 + 0;
		while true do
			if ((v147 == (17 - 10)) or ((2221 + 370) == (7305 - 3896))) then
				v72 = EpicSettings.Settings['SheilunsGiftHP'];
				v71 = EpicSettings.Settings['SheilunsGiftGroup'];
				break;
			end
			if (((3611 + 903) > (226 + 3098)) and ((2 + 1) == v147)) then
				v51 = EpicSettings.Settings['UseTouchOfDeath'];
				v52 = EpicSettings.Settings['UseRenewingMist'];
				v53 = EpicSettings.Settings['RenewingMistHP'];
				v54 = EpicSettings.Settings['UseExpelHarm'];
				v55 = EpicSettings.Settings['ExpelHarmHP'];
				v147 = 1305 - (384 + 917);
			end
			if ((v147 == (697 - (128 + 569))) or ((1751 - (1407 + 136)) >= (6715 - (687 + 1200)))) then
				v36 = EpicSettings.Settings['UseManaTea'];
				v37 = EpicSettings.Settings['ManaTeaStacks'];
				v38 = EpicSettings.Settings['UseThunderFocusTea'];
				v39 = EpicSettings.Settings['UseFortifyingBrew'];
				v40 = EpicSettings.Settings['FortifyingBrewHP'];
				v147 = 1711 - (556 + 1154);
			end
			if (((3 - 2) == v147) or ((1678 - (9 + 86)) > (3988 - (275 + 146)))) then
				v41 = EpicSettings.Settings['UseDampenHarm'];
				v42 = EpicSettings.Settings['DampenHarmHP'];
				v43 = EpicSettings.Settings['WhiteTigerUsage'];
				v44 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
				v45 = EpicSettings.Settings['UseBlackoutKick'];
				v147 = 1 + 1;
			end
			if (((66 - (29 + 35)) == v147) or ((5819 - 4506) == (2371 - 1577))) then
				v46 = EpicSettings.Settings['UseSpinningCraneKick'];
				v47 = EpicSettings.Settings['UseRisingSunKick'];
				v48 = EpicSettings.Settings['UseTigerPalm'];
				v49 = EpicSettings.Settings['UseJadefireStomp'];
				v50 = EpicSettings.Settings['UseChiBurst'];
				v147 = 13 - 10;
			end
			if (((2068 + 1106) > (3914 - (53 + 959))) and (v147 == (414 - (312 + 96)))) then
				v65 = EpicSettings.Settings['JadeSerpentUsage'];
				v67 = EpicSettings.Settings['UseZenPulse'];
				v69 = EpicSettings.Settings['ZenPulseHP'];
				v68 = EpicSettings.Settings['ZenPulseGroup'];
				v70 = EpicSettings.Settings['UseSheilunsGift'];
				v147 = 11 - 4;
			end
			if (((4405 - (147 + 138)) <= (5159 - (813 + 86))) and (v147 == (5 + 0))) then
				v61 = EpicSettings.Settings['SoothingMistHP'];
				v62 = EpicSettings.Settings['UseEssenceFont'];
				v64 = EpicSettings.Settings['EssenceFontHP'];
				v63 = EpicSettings.Settings['EssenceFontGroup'];
				v66 = EpicSettings.Settings['UseJadeSerpent'];
				v147 = 10 - 4;
			end
			if (((496 - (18 + 474)) == v147) or ((298 + 585) > (15594 - 10816))) then
				v56 = EpicSettings.Settings['UseVivify'];
				v57 = EpicSettings.Settings['VivifyHP'];
				v58 = EpicSettings.Settings['UseEnvelopingMist'];
				v59 = EpicSettings.Settings['EnvelopingMistHP'];
				v60 = EpicSettings.Settings['UseSoothingMist'];
				v147 = 1091 - (860 + 226);
			end
		end
	end
	local function v134()
		local v148 = 303 - (121 + 182);
		while true do
			if ((v148 == (1 + 5)) or ((4860 - (988 + 252)) >= (553 + 4338))) then
				v76 = EpicSettings.Settings['UseInvokeChiJi'];
				v78 = EpicSettings.Settings['InvokeChiJiHP'];
				v77 = EpicSettings.Settings['InvokeChiJiGroup'];
				v79 = EpicSettings.Settings['UseLifeCocoon'];
				v80 = EpicSettings.Settings['LifeCocoonHP'];
				v148 = 3 + 4;
			end
			if (((6228 - (49 + 1921)) > (1827 - (223 + 667))) and (v148 == (57 - (51 + 1)))) then
				v104 = EpicSettings.Settings['HandleCharredTreant'];
				v106 = EpicSettings.Settings['HandleFyrakkNPC'];
				v73 = EpicSettings.Settings['UseInvokeYulon'];
				v75 = EpicSettings.Settings['InvokeYulonHP'];
				v74 = EpicSettings.Settings['InvokeYulonGroup'];
				v148 = 10 - 4;
			end
			if (((14 - 7) == v148) or ((5994 - (146 + 979)) < (256 + 650))) then
				v81 = EpicSettings.Settings['UseRevival'];
				v83 = EpicSettings.Settings['RevivalHP'];
				v82 = EpicSettings.Settings['RevivalGroup'];
				break;
			end
			if ((v148 == (607 - (311 + 294))) or ((3416 - 2191) > (1791 + 2437))) then
				v84 = EpicSettings.Settings['useHealthstone'];
				v85 = EpicSettings.Settings['healthstoneHP'];
				v107 = EpicSettings.Settings['useManaPotion'];
				v108 = EpicSettings.Settings['manaPotionSlider'];
				v109 = EpicSettings.Settings['RevivalBurstingGroup'];
				v148 = 1446 - (496 + 947);
			end
			if (((4686 - (1233 + 125)) > (909 + 1329)) and (v148 == (1 + 0))) then
				v100 = EpicSettings.Settings['useWeapon'];
				v89 = EpicSettings.Settings['dispelDebuffs'];
				v86 = EpicSettings.Settings['useHealingPotion'];
				v87 = EpicSettings.Settings['healingPotionHP'];
				v88 = EpicSettings.Settings['HealingPotionName'];
				v148 = 1 + 1;
			end
			if (((5484 - (963 + 682)) > (1173 + 232)) and (v148 == (1508 - (504 + 1000)))) then
				v94 = EpicSettings.Settings['useLegSweep'];
				v101 = EpicSettings.Settings['handleAfflicted'];
				v102 = EpicSettings.Settings['HandleIncorporeal'];
				v103 = EpicSettings.Settings['HandleChromie'];
				v105 = EpicSettings.Settings['HandleCharredBrambles'];
				v148 = 4 + 1;
			end
			if (((0 + 0) == v148) or ((123 + 1170) <= (746 - 239))) then
				v96 = EpicSettings.Settings['racialsWithCD'];
				v95 = EpicSettings.Settings['useRacials'];
				v98 = EpicSettings.Settings['trinketsWithCD'];
				v97 = EpicSettings.Settings['useTrinkets'];
				v99 = EpicSettings.Settings['fightRemainsCheck'];
				v148 = 1 + 0;
			end
			if ((v148 == (2 + 1)) or ((3078 - (156 + 26)) < (464 + 341))) then
				v110 = EpicSettings.Settings['RevivalBurstingStacks'];
				v92 = EpicSettings.Settings['InterruptThreshold'];
				v90 = EpicSettings.Settings['InterruptWithStun'];
				v91 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v93 = EpicSettings.Settings['useSpearHandStrike'];
				v148 = 6 - 2;
			end
		end
	end
	local v135 = 164 - (149 + 15);
	local function v136()
		local v149 = 960 - (890 + 70);
		while true do
			if (((2433 - (39 + 78)) == (2798 - (14 + 468))) and (v149 == (6 - 3))) then
				if (v12:IsDeadOrGhost() or ((7183 - 4613) == (791 + 742))) then
					return;
				end
				v118 = v12:GetEnemiesInMeleeRange(5 + 3);
				if (v30 or ((188 + 695) == (660 + 800))) then
					v119 = #v118;
				else
					v119 = 1 + 0;
				end
				v149 = 7 - 3;
			end
			if ((v149 == (5 + 0)) or ((16230 - 11611) <= (26 + 973))) then
				if (v12:AffectingCombat() or v29 or ((3461 - (12 + 39)) > (3830 + 286))) then
					local v246 = 0 - 0;
					local v247;
					while true do
						if ((v246 == (0 - 0)) or ((268 + 635) >= (1611 + 1448))) then
							v247 = v89 and v114.Detox:IsReady() and v32;
							v28 = v120.FocusUnit(v247, nil, 101 - 61, nil, 17 + 8, v114.EnvelopingMist);
							v246 = 4 - 3;
						end
						if ((v246 == (1711 - (1596 + 114))) or ((10380 - 6404) < (3570 - (164 + 549)))) then
							if (((6368 - (1059 + 379)) > (2864 - 557)) and v28) then
								return v28;
							end
							if ((v32 and v89) or ((2097 + 1949) < (218 + 1073))) then
								local v254 = 392 - (145 + 247);
								while true do
									if ((v254 == (0 + 0)) or ((1960 + 2281) == (10509 - 6964))) then
										if ((v16 and v16:Exists() and v16:IsAPlayer() and (v120.UnitHasDispellableDebuffByPlayer(v16) or v120.DispellableFriendlyUnit(5 + 20) or v120.UnitHasMagicDebuff(v16) or (v114.ImprovedDetox:IsAvailable() and (v120.UnitHasDiseaseDebuff(v16) or v120.UnitHasPoisonDebuff(v16))))) or ((3487 + 561) > (6871 - 2639))) then
											if (v114.Detox:IsCastable() or ((2470 - (254 + 466)) >= (4033 - (544 + 16)))) then
												if (((10061 - 6895) == (3794 - (294 + 334))) and (v135 == (253 - (236 + 17)))) then
													v135 = GetTime();
												end
												if (((761 + 1002) < (2899 + 825)) and v120.Wait(1883 - 1383, v135)) then
													local v260 = 0 - 0;
													while true do
														if (((30 + 27) <= (2243 + 480)) and (v260 == (794 - (413 + 381)))) then
															if (v23(v116.DetoxFocus, not v16:IsSpellInRange(v114.Detox)) or ((88 + 1982) == (941 - 498))) then
																return "detox dispel focus";
															end
															v135 = 0 - 0;
															break;
														end
													end
												end
											end
										end
										if ((v15 and v15:Exists() and not v12:CanAttack(v15) and (v120.UnitHasDispellableDebuffByPlayer(v15) or v120.UnitHasMagicDebuff(v15) or (v114.ImprovedDetox:IsAvailable() and (v120.UnitHasDiseaseDebuff(v15) or v120.UnitHasPoisonDebuff(v15))))) or ((4675 - (582 + 1388)) == (2372 - 979))) then
											if (v114.Detox:IsCastable() or ((3294 + 1307) < (425 - (326 + 38)))) then
												if (v23(v116.DetoxMouseover, not v15:IsSpellInRange(v114.Detox)) or ((4111 - 2721) >= (6771 - 2027))) then
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
				if (not v12:AffectingCombat() or ((2623 - (47 + 573)) > (1352 + 2482))) then
					if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) or ((662 - 506) > (6350 - 2437))) then
						local v250 = 1664 - (1269 + 395);
						local v251;
						while true do
							if (((687 - (76 + 416)) == (638 - (319 + 124))) and (v250 == (0 - 0))) then
								v251 = v120.DeadFriendlyUnitsCount();
								if (((4112 - (564 + 443)) >= (4971 - 3175)) and (v251 > (459 - (337 + 121)))) then
									if (((12830 - 8451) >= (7098 - 4967)) and v23(v114.Reawaken, nil)) then
										return "reawaken";
									end
								elseif (((5755 - (1261 + 650)) >= (865 + 1178)) and v23(v116.ResuscitateMouseover, not v14:IsInRange(63 - 23))) then
									return "resuscitate";
								end
								break;
							end
						end
					end
				end
				if ((not v12:AffectingCombat() and v29) or ((5049 - (772 + 1045)) <= (386 + 2345))) then
					v28 = v125();
					if (((5049 - (102 + 42)) == (6749 - (1524 + 320))) and v28) then
						return v28;
					end
				end
				v149 = 1276 - (1049 + 221);
			end
			if ((v149 == (160 - (18 + 138))) or ((10123 - 5987) >= (5513 - (67 + 1035)))) then
				if (v120.TargetIsValid() or v12:AffectingCombat() or ((3306 - (136 + 212)) == (17069 - 13052))) then
					local v248 = 0 + 0;
					while true do
						if (((1133 + 95) >= (2417 - (240 + 1364))) and (v248 == (1083 - (1050 + 32)))) then
							v112 = v111;
							if ((v112 == (39672 - 28561)) or ((2044 + 1411) > (5105 - (331 + 724)))) then
								v112 = v9.FightRemains(v113, false);
							end
							break;
						end
						if (((20 + 223) == (887 - (269 + 375))) and (v248 == (725 - (267 + 458)))) then
							v113 = v12:GetEnemiesInRange(13 + 27);
							v111 = v9.BossFightRemains(nil, true);
							v248 = 1 - 0;
						end
					end
				end
				v28 = v124();
				if (v28 or ((1089 - (667 + 151)) > (3069 - (1410 + 87)))) then
					return v28;
				end
				v149 = 1902 - (1504 + 393);
			end
			if (((7403 - 4664) < (8543 - 5250)) and (v149 == (796 - (461 + 335)))) then
				v133();
				v134();
				v29 = EpicSettings.Toggles['ooc'];
				v149 = 1 + 0;
			end
			if ((v149 == (1763 - (1730 + 31))) or ((5609 - (728 + 939)) < (4016 - 2882))) then
				v33 = EpicSettings.Toggles['healing'];
				v34 = EpicSettings.Toggles['dps'];
				v35 = EpicSettings.Toggles['ramp'];
				v149 = 5 - 2;
			end
			if ((v149 == (13 - 7)) or ((3761 - (138 + 930)) == (4545 + 428))) then
				if (((1678 + 468) == (1840 + 306)) and (v29 or v12:AffectingCombat())) then
					local v249 = 0 - 0;
					while true do
						if ((v249 == (1767 - (459 + 1307))) or ((4114 - (474 + 1396)) == (5629 - 2405))) then
							if ((v12:DebuffStack(v114.Bursting) > (5 + 0)) or ((17 + 4887) <= (5488 - 3572))) then
								if (((12 + 78) <= (3555 - 2490)) and v114.DiffuseMagic:IsReady() and v114.DiffuseMagic:IsAvailable()) then
									if (((20942 - 16140) == (5393 - (562 + 29))) and v23(v114.DiffuseMagic, nil)) then
										return "Diffues Magic Bursting Player";
									end
								end
							end
							if (((v114.Bursting:MaxDebuffStack() > v110) and (v114.Bursting:AuraActiveCount() > v109)) or ((1944 + 336) <= (1930 - (374 + 1045)))) then
								if ((v81 and v114.Revival:IsReady() and v114.Revival:IsAvailable()) or ((1327 + 349) <= (1437 - 974))) then
									if (((4507 - (448 + 190)) == (1250 + 2619)) and v23(v114.Revival, nil)) then
										return "Revival Bursting";
									end
								end
							end
							v249 = 1 + 1;
						end
						if (((755 + 403) <= (10046 - 7433)) and (v249 == (5 - 3))) then
							if ((v32 and v89) or ((3858 - (1307 + 187)) <= (7927 - 5928))) then
								if ((v114.TigersLust:IsReady() and v120.UnitHasDebuffFromList(v12, v120.DispellableRootDebuffs) and v12:CanAttack(v14)) or ((11524 - 6602) < (594 - 400))) then
									if (v23(v114.TigersLust, nil) or ((2774 - (232 + 451)) < (30 + 1))) then
										return "Tigers Lust Roots";
									end
								end
							end
							if (v33 or ((2147 + 283) >= (5436 - (510 + 54)))) then
								local v255 = 0 - 0;
								while true do
									if ((v255 == (36 - (13 + 23))) or ((9298 - 4528) < (2492 - 757))) then
										if ((v114.SummonJadeSerpentStatue:IsReady() and v114.SummonJadeSerpentStatue:IsAvailable() and (v114.SummonJadeSerpentStatue:TimeSinceLastCast() > (163 - 73)) and v66) or ((5527 - (830 + 258)) <= (8289 - 5939))) then
											if ((v65 == "Player") or ((2803 + 1676) < (3800 + 666))) then
												if (((3988 - (860 + 581)) > (4518 - 3293)) and v23(v116.SummonJadeSerpentStatuePlayer, not v14:IsInRange(32 + 8))) then
													return "jade serpent main player";
												end
											elseif (((4912 - (237 + 4)) > (6284 - 3610)) and (v65 == "Cursor")) then
												if (v23(v116.SummonJadeSerpentStatueCursor, not v14:IsInRange(101 - 61)) or ((7007 - 3311) < (2724 + 603))) then
													return "jade serpent main cursor";
												end
											elseif ((v65 == "Confirmation") or ((2609 + 1933) == (11212 - 8242))) then
												if (((109 + 143) <= (1076 + 901)) and v23(v114.SummonJadeSerpentStatue, not v14:IsInRange(1466 - (85 + 1341)))) then
													return "jade serpent main confirmation";
												end
											end
										end
										if ((v52 and v114.RenewingMist:IsReady() and v14:BuffDown(v114.RenewingMistBuff) and not v12:CanAttack(v14)) or ((2450 - 1014) == (10661 - 6886))) then
											if ((v14:HealthPercentage() <= v53) or ((1990 - (45 + 327)) < (1754 - 824))) then
												if (((5225 - (444 + 58)) > (1805 + 2348)) and v23(v114.RenewingMist, not v14:IsSpellInRange(v114.RenewingMist))) then
													return "RenewingMist main";
												end
											end
										end
										v255 = 1 + 0;
									end
									if ((v255 == (2 + 1)) or ((10588 - 6934) >= (6386 - (64 + 1668)))) then
										v28 = v128();
										if (((2924 - (1227 + 746)) <= (4598 - 3102)) and v28) then
											return v28;
										end
										break;
									end
									if ((v255 == (3 - 1)) or ((2230 - (415 + 79)) == (15 + 556))) then
										if (((v112 > v99) and v31 and v12:AffectingCombat()) or ((1387 - (142 + 349)) > (2043 + 2726))) then
											local v258 = 0 - 0;
											while true do
												if (((0 + 0) == v258) or ((737 + 308) <= (2777 - 1757))) then
													v28 = v132();
													if (v28 or ((3024 - (1710 + 154)) <= (646 - (200 + 118)))) then
														return v28;
													end
													break;
												end
											end
										end
										if (((1509 + 2299) > (5111 - 2187)) and v30) then
											local v259 = 0 - 0;
											while true do
												if (((3458 + 433) < (4866 + 53)) and (v259 == (0 + 0))) then
													v28 = v129();
													if (v28 or ((357 + 1877) <= (3253 - 1751))) then
														return v28;
													end
													break;
												end
											end
										end
										v255 = 1253 - (363 + 887);
									end
									if ((v255 == (1 - 0)) or ((11956 - 9444) < (67 + 365))) then
										if ((v60 and v114.SoothingMist:IsReady() and v14:BuffDown(v114.SoothingMist) and not v12:CanAttack(v14)) or ((4323 - 2475) == (592 + 273))) then
											if ((v14:HealthPercentage() <= v61) or ((6346 - (674 + 990)) <= (1302 + 3239))) then
												if (v23(v114.SoothingMist, not v14:IsSpellInRange(v114.SoothingMist)) or ((1239 + 1787) >= (6412 - 2366))) then
													return "SoothingMist main";
												end
											end
										end
										if (((3063 - (507 + 548)) > (1475 - (289 + 548))) and v36 and (v12:BuffStack(v114.ManaTeaCharges) >= (1836 - (821 + 997))) and v114.ManaTea:IsCastable() and not v120.AreUnitsBelowHealthPercentage(335 - (195 + 60), 1 + 2, v114.EnvelopingMist)) then
											if (((3276 - (251 + 1250)) <= (9471 - 6238)) and v23(v114.ManaTea, nil)) then
												return "Mana Tea main avoid overcap";
											end
										end
										v255 = 2 + 0;
									end
								end
							end
							break;
						end
						if ((v249 == (1032 - (809 + 223))) or ((6629 - 2086) == (5997 - 4000))) then
							if ((v31 and v100 and (v115.Dreambinder:IsEquippedAndReady() or v115.Iridal:IsEquippedAndReady())) or ((10256 - 7154) < (537 + 191))) then
								if (((181 + 164) == (962 - (14 + 603))) and v23(v116.UseWeapon, nil)) then
									return "Using Weapon Macro";
								end
							end
							if ((v107 and v115.AeratedManaPotion:IsReady() and (v12:ManaPercentage() <= v108)) or ((2956 - (118 + 11)) < (62 + 316))) then
								if (v23(v116.ManaPotion, nil) or ((2896 + 580) < (7568 - 4971))) then
									return "Mana Potion main";
								end
							end
							v249 = 950 - (551 + 398);
						end
					end
				end
				if (((1946 + 1133) < (1706 + 3088)) and (v29 or v12:AffectingCombat()) and v120.TargetIsValid() and v12:CanAttack(v14) and not v14:IsDeadOrGhost()) then
					v28 = v123();
					if (((3945 + 909) > (16601 - 12137)) and v28) then
						return v28;
					end
					if ((v97 and ((v31 and v98) or not v98)) or ((11317 - 6405) == (1219 + 2539))) then
						local v252 = 0 - 0;
						while true do
							if (((35 + 91) <= (3571 - (40 + 49))) and ((3 - 2) == v252)) then
								v28 = v120.HandleBottomTrinket(v117, v31, 530 - (99 + 391), nil);
								if (v28 or ((1964 + 410) == (19227 - 14853))) then
									return v28;
								end
								break;
							end
							if (((3900 - 2325) == (1535 + 40)) and (v252 == (0 - 0))) then
								v28 = v120.HandleTopTrinket(v117, v31, 1644 - (1032 + 572), nil);
								if (v28 or ((2651 - (203 + 214)) == (3272 - (568 + 1249)))) then
									return v28;
								end
								v252 = 1 + 0;
							end
						end
					end
					if (v34 or ((2562 - 1495) > (6871 - 5092))) then
						local v253 = 1306 - (913 + 393);
						while true do
							if (((6102 - 3941) >= (1319 - 385)) and (v253 == (410 - (269 + 141)))) then
								if (((3585 - 1973) == (3593 - (362 + 1619))) and v95 and ((v31 and v96) or not v96) and (v112 < (1643 - (950 + 675)))) then
									local v256 = 0 + 0;
									while true do
										if (((5531 - (216 + 963)) >= (4120 - (485 + 802))) and (v256 == (559 - (432 + 127)))) then
											if (v114.BloodFury:IsCastable() or ((4295 - (1065 + 8)) < (1707 + 1366))) then
												if (((2345 - (635 + 966)) <= (2116 + 826)) and v23(v114.BloodFury, nil)) then
													return "blood_fury main 4";
												end
											end
											if (v114.Berserking:IsCastable() or ((1875 - (5 + 37)) <= (3287 - 1965))) then
												if (v23(v114.Berserking, nil) or ((1443 + 2024) <= (1669 - 614))) then
													return "berserking main 6";
												end
											end
											v256 = 1 + 0;
										end
										if (((7357 - 3816) == (13424 - 9883)) and (v256 == (1 - 0))) then
											if (v114.LightsJudgment:IsCastable() or ((8504 - 4947) >= (2879 + 1124))) then
												if (v23(v114.LightsJudgment, not v14:IsInRange(569 - (318 + 211))) or ((3232 - 2575) >= (3255 - (963 + 624)))) then
													return "lights_judgment main 8";
												end
											end
											if (v114.Fireblood:IsCastable() or ((439 + 588) > (4704 - (518 + 328)))) then
												if (v23(v114.Fireblood, nil) or ((8517 - 4863) < (719 - 269))) then
													return "fireblood main 10";
												end
											end
											v256 = 319 - (301 + 16);
										end
										if (((5542 - 3651) < (12505 - 8052)) and (v256 == (5 - 3))) then
											if (v114.AncestralCall:IsCastable() or ((2845 + 295) < (1209 + 920))) then
												if (v23(v114.AncestralCall, nil) or ((5454 - 2899) < (746 + 494))) then
													return "ancestral_call main 12";
												end
											end
											if (v114.BagofTricks:IsCastable() or ((450 + 4277) <= (15012 - 10290))) then
												if (((239 + 501) < (5956 - (829 + 190))) and v23(v114.BagofTricks, not v14:IsInRange(142 - 102))) then
													return "bag_of_tricks main 14";
												end
											end
											break;
										end
									end
								end
								if (((4628 - 970) >= (387 - 107)) and v38 and v114.ThunderFocusTea:IsReady() and (not v114.EssenceFont:IsAvailable() or not v120.AreUnitsBelowHealthPercentage(v64, v63, v114.EnvelopingMist)) and (v114.RisingSunKick:CooldownRemains() < v12:GCD())) then
									if (v23(v114.ThunderFocusTea, nil) or ((2198 - 1313) >= (245 + 786))) then
										return "ThunderFocusTea main 16";
									end
								end
								v253 = 1 + 0;
							end
							if (((10787 - 7233) >= (496 + 29)) and (v253 == (614 - (520 + 93)))) then
								if (((2690 - (259 + 17)) <= (172 + 2800)) and (v119 >= (2 + 1)) and v30) then
									local v257 = 0 - 0;
									while true do
										if (((4120 - (396 + 195)) <= (10264 - 6726)) and (v257 == (1761 - (440 + 1321)))) then
											v28 = v126();
											if (v28 or ((4690 - (1059 + 770)) < (2117 - 1659))) then
												return v28;
											end
											break;
										end
									end
								end
								if (((2262 - (424 + 121)) <= (825 + 3700)) and (v119 < (1350 - (641 + 706)))) then
									v28 = v127();
									if (v28 or ((1259 + 1919) <= (1964 - (249 + 191)))) then
										return v28;
									end
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((18531 - 14277) > (166 + 204)) and (v149 == (3 - 2))) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v149 = 429 - (183 + 244);
			end
		end
	end
	local function v137()
		local v150 = 0 + 0;
		while true do
			if (((730 - (434 + 296)) == v150) or ((5217 - 3582) == (2289 - (169 + 343)))) then
				v122();
				v114.Bursting:RegisterAuraTracking();
				v150 = 1 + 0;
			end
			if ((v150 == (1 - 0)) or ((9797 - 6459) >= (3272 + 721))) then
				v21.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(765 - 495, v136, v137);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

