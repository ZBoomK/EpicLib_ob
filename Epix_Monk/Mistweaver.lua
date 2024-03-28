local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((7454 - 3049) <= (2085 - (35 + 1064)))) then
			v6 = v0[v4];
			if (((2306 + 862) <= (7727 - 4115)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((3827 - (298 + 938)) > (1766 - (233 + 1026))) and (v5 == (1667 - (636 + 1030)))) then
			return v6(...);
		end
	end
end
v0["Epix_Monk_Mistweaver.lua"] = function(...)
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
	local v28 = GetNumGroupMembers;
	local v29;
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
	local v111 = 5681 + 5430;
	local v112 = 10853 + 258;
	local v113;
	local v114 = v18.Monk.Mistweaver;
	local v115 = v20.Monk.Mistweaver;
	local v116 = v25.Monk.Mistweaver;
	local v117 = {};
	local v118;
	local v119;
	local v120 = v22.Commons.Everyone;
	local v121 = v22.Commons.Monk;
	local function v122()
		if (((1332 + 3149) == (303 + 4178)) and v114.ImprovedDetox:IsAvailable()) then
			v120.DispellableDebuffs = v21.MergeTable(v120.DispellableMagicDebuffs, v120.DispellablePoisonDebuffs, v120.DispellableDiseaseDebuffs);
		else
			v120.DispellableDebuffs = v120.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123()
		local v138 = 221 - (55 + 166);
		while true do
			if (((1 + 0) == v138) or ((235 + 2093) < (2646 - 1953))) then
				if (((4625 - (36 + 261)) == (7568 - 3240)) and v114.ExpelHarm:IsCastable() and (v13:HealthPercentage() <= v55) and v54 and v13:BuffUp(v114.ChiHarmonyBuff)) then
					if (((2956 - (34 + 1334)) >= (513 + 819)) and v24(v114.ExpelHarm, nil)) then
						return "expel_harm defensives 3";
					end
				end
				if ((v115.Healthstone:IsReady() and v115.Healthstone:IsUsable() and v84 and (v13:HealthPercentage() <= v85)) or ((3244 + 930) > (5531 - (1035 + 248)))) then
					if (v24(v116.Healthstone) or ((4607 - (20 + 1)) <= (43 + 39))) then
						return "healthstone defensive 4";
					end
				end
				v138 = 321 - (134 + 185);
			end
			if (((4996 - (549 + 584)) == (4548 - (314 + 371))) and (v138 == (0 - 0))) then
				if ((v114.DampenHarm:IsCastable() and v13:BuffDown(v114.FortifyingBrew) and (v13:HealthPercentage() <= v42) and v41) or ((1250 - (478 + 490)) <= (23 + 19))) then
					if (((5781 - (786 + 386)) >= (2480 - 1714)) and v24(v114.DampenHarm, nil)) then
						return "dampen_harm defensives 1";
					end
				end
				if ((v114.FortifyingBrew:IsCastable() and v13:BuffDown(v114.DampenHarmBuff) and (v13:HealthPercentage() <= v40) and v39) or ((2531 - (1055 + 324)) == (3828 - (1093 + 247)))) then
					if (((3041 + 381) > (353 + 2997)) and v24(v114.FortifyingBrew, nil)) then
						return "fortifying_brew defensives 2";
					end
				end
				v138 = 3 - 2;
			end
			if (((2976 - 2099) > (1069 - 693)) and (v138 == (4 - 2))) then
				if ((v86 and (v13:HealthPercentage() <= v87)) or ((1110 + 2008) <= (7130 - 5279))) then
					local v237 = 0 - 0;
					while true do
						if ((v237 == (0 + 0)) or ((421 - 256) >= (4180 - (364 + 324)))) then
							if (((10825 - 6876) < (11652 - 6796)) and (v88 == "Refreshing Healing Potion")) then
								if ((v115.RefreshingHealingPotion:IsReady() and v115.RefreshingHealingPotion:IsUsable()) or ((1418 + 2858) < (12619 - 9603))) then
									if (((7511 - 2821) > (12528 - 8403)) and v24(v116.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 5";
									end
								end
							end
							if ((v88 == "Dreamwalker's Healing Potion") or ((1318 - (1249 + 19)) >= (809 + 87))) then
								if ((v115.DreamwalkersHealingPotion:IsReady() and v115.DreamwalkersHealingPotion:IsUsable()) or ((6671 - 4957) >= (4044 - (686 + 400)))) then
									if (v24(v116.RefreshingHealingPotion) or ((1170 + 321) < (873 - (73 + 156)))) then
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
		end
	end
	local function v124()
		local v139 = 0 + 0;
		while true do
			if (((1515 - (721 + 90)) < (12 + 975)) and (v139 == (0 - 0))) then
				if (((4188 - (224 + 246)) > (3087 - 1181)) and v102) then
					local v238 = 0 - 0;
					while true do
						if ((v238 == (0 + 0)) or ((23 + 935) > (2670 + 965))) then
							v29 = v120.HandleIncorporeal(v114.Paralysis, v116.ParalysisMouseover, 59 - 29, true);
							if (((11650 - 8149) <= (5005 - (203 + 310))) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (v101 or ((5435 - (1238 + 755)) < (179 + 2369))) then
					local v239 = 1534 - (709 + 825);
					while true do
						if (((5297 - 2422) >= (2132 - 668)) and (v239 == (865 - (196 + 668)))) then
							if (v114.Detox:CooldownRemains() or ((18939 - 14142) >= (10135 - 5242))) then
								v29 = v120.HandleAfflicted(v114.Vivify, v116.VivifyMouseover, 863 - (171 + 662));
								if (v29 or ((644 - (4 + 89)) > (7248 - 5180))) then
									return v29;
								end
							end
							break;
						end
						if (((770 + 1344) > (4146 - 3202)) and (v239 == (0 + 0))) then
							v29 = v120.HandleAfflicted(v114.Detox, v116.DetoxMouseover, 1516 - (35 + 1451));
							if (v29 or ((3715 - (28 + 1425)) >= (5089 - (941 + 1052)))) then
								return v29;
							end
							v239 = 1 + 0;
						end
					end
				end
				v139 = 1515 - (822 + 692);
			end
			if (((1 - 0) == v139) or ((1063 + 1192) >= (3834 - (45 + 252)))) then
				if (v103 or ((3797 + 40) < (450 + 856))) then
					local v240 = 0 - 0;
					while true do
						if (((3383 - (114 + 319)) == (4235 - 1285)) and (v240 == (0 - 0))) then
							v29 = v120.HandleChromie(v114.Riptide, v116.RiptideMouseover, 26 + 14);
							if (v29 or ((7036 - 2313) < (6909 - 3611))) then
								return v29;
							end
							v240 = 1964 - (556 + 1407);
						end
						if (((2342 - (741 + 465)) >= (619 - (170 + 295))) and (v240 == (1 + 0))) then
							v29 = v120.HandleChromie(v114.HealingSurge, v116.HealingSurgeMouseover, 37 + 3);
							if (v29 or ((667 - 396) > (3936 + 812))) then
								return v29;
							end
							break;
						end
					end
				end
				if (((3040 + 1700) >= (1785 + 1367)) and v104) then
					local v241 = 1230 - (957 + 273);
					while true do
						if ((v241 == (1 + 1)) or ((1033 + 1545) >= (12917 - 9527))) then
							v29 = v120.HandleCharredTreant(v114.Vivify, v116.VivifyMouseover, 105 - 65);
							if (((125 - 84) <= (8224 - 6563)) and v29) then
								return v29;
							end
							v241 = 1783 - (389 + 1391);
						end
						if (((378 + 223) < (371 + 3189)) and ((2 - 1) == v241)) then
							v29 = v120.HandleCharredTreant(v114.SoothingMist, v116.SoothingMistMouseover, 991 - (783 + 168));
							if (((788 - 553) < (676 + 11)) and v29) then
								return v29;
							end
							v241 = 313 - (309 + 2);
						end
						if (((13969 - 9420) > (2365 - (1090 + 122))) and ((0 + 0) == v241)) then
							v29 = v120.HandleCharredTreant(v114.RenewingMist, v116.RenewingMistMouseover, 134 - 94);
							if (v29 or ((3199 + 1475) < (5790 - (628 + 490)))) then
								return v29;
							end
							v241 = 1 + 0;
						end
						if (((9081 - 5413) < (20843 - 16282)) and (v241 == (777 - (431 + 343)))) then
							v29 = v120.HandleCharredTreant(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 80 - 40);
							if (v29 or ((1316 - 861) == (2848 + 757))) then
								return v29;
							end
							break;
						end
					end
				end
				v139 = 1 + 1;
			end
			if ((v139 == (1697 - (556 + 1139))) or ((2678 - (6 + 9)) == (607 + 2705))) then
				if (((2192 + 2085) <= (4644 - (28 + 141))) and v105) then
					local v242 = 0 + 0;
					while true do
						if ((v242 == (0 - 0)) or ((617 + 253) == (2506 - (486 + 831)))) then
							v29 = v120.HandleCharredBrambles(v114.RenewingMist, v116.RenewingMistMouseover, 104 - 64);
							if (((5467 - 3914) <= (593 + 2540)) and v29) then
								return v29;
							end
							v242 = 3 - 2;
						end
						if ((v242 == (1264 - (668 + 595))) or ((2013 + 224) >= (708 + 2803))) then
							v29 = v120.HandleCharredBrambles(v114.SoothingMist, v116.SoothingMistMouseover, 109 - 69);
							if (v29 or ((1614 - (23 + 267)) > (4964 - (1129 + 815)))) then
								return v29;
							end
							v242 = 389 - (371 + 16);
						end
						if ((v242 == (1753 - (1326 + 424))) or ((5666 - 2674) == (6873 - 4992))) then
							v29 = v120.HandleCharredBrambles(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 158 - (88 + 30));
							if (((3877 - (720 + 51)) > (3394 - 1868)) and v29) then
								return v29;
							end
							break;
						end
						if (((4799 - (421 + 1355)) < (6384 - 2514)) and (v242 == (1 + 1))) then
							v29 = v120.HandleCharredBrambles(v114.Vivify, v116.VivifyMouseover, 1123 - (286 + 797));
							if (((522 - 379) > (122 - 48)) and v29) then
								return v29;
							end
							v242 = 442 - (397 + 42);
						end
					end
				end
				if (((6 + 12) < (2912 - (24 + 776))) and v106) then
					local v243 = 0 - 0;
					while true do
						if (((1882 - (222 + 563)) <= (3586 - 1958)) and (v243 == (1 + 0))) then
							v29 = v120.HandleFyrakkNPC(v114.SoothingMist, v116.SoothingMistMouseover, 230 - (23 + 167));
							if (((6428 - (690 + 1108)) == (1671 + 2959)) and v29) then
								return v29;
							end
							v243 = 2 + 0;
						end
						if (((4388 - (40 + 808)) > (442 + 2241)) and (v243 == (7 - 5))) then
							v29 = v120.HandleFyrakkNPC(v114.Vivify, v116.VivifyMouseover, 39 + 1);
							if (((2537 + 2257) >= (1796 + 1479)) and v29) then
								return v29;
							end
							v243 = 574 - (47 + 524);
						end
						if (((964 + 520) == (4056 - 2572)) and (v243 == (4 - 1))) then
							v29 = v120.HandleFyrakkNPC(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 91 - 51);
							if (((3158 - (1165 + 561)) < (106 + 3449)) and v29) then
								return v29;
							end
							break;
						end
						if ((v243 == (0 - 0)) or ((407 + 658) > (4057 - (341 + 138)))) then
							v29 = v120.HandleFyrakkNPC(v114.RenewingMist, v116.RenewingMistMouseover, 11 + 29);
							if (v29 or ((9895 - 5100) < (1733 - (89 + 237)))) then
								return v29;
							end
							v243 = 3 - 2;
						end
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v140 = 0 - 0;
		while true do
			if (((2734 - (581 + 300)) < (6033 - (855 + 365))) and (v140 == (0 - 0))) then
				if ((v114.ChiBurst:IsCastable() and v50) or ((922 + 1899) < (3666 - (1030 + 205)))) then
					if (v24(v114.ChiBurst, not v15:IsInRange(38 + 2)) or ((2674 + 200) < (2467 - (156 + 130)))) then
						return "chi_burst precombat 4";
					end
				end
				if ((v114.SpinningCraneKick:IsCastable() and v46 and (v119 >= (4 - 2))) or ((4531 - 1842) <= (702 - 359))) then
					if (v24(v114.SpinningCraneKick, not v15:IsInMeleeRange(3 + 5)) or ((1090 + 779) == (2078 - (10 + 59)))) then
						return "spinning_crane_kick precombat 6";
					end
				end
				v140 = 1 + 0;
			end
			if ((v140 == (4 - 3)) or ((4709 - (671 + 492)) < (1849 + 473))) then
				if ((v114.TigerPalm:IsCastable() and v48) or ((3297 - (369 + 846)) == (1264 + 3509))) then
					if (((2769 + 475) > (3000 - (1036 + 909))) and v24(v114.TigerPalm, not v15:IsInMeleeRange(4 + 1))) then
						return "tiger_palm precombat 8";
					end
				end
				break;
			end
		end
	end
	local function v126()
		local v141 = 0 - 0;
		while true do
			if (((206 - (11 + 192)) == v141) or ((1675 + 1638) <= (1953 - (135 + 40)))) then
				if ((v114.TigerPalm:IsCastable() and v114.TeachingsoftheMonastery:IsAvailable() and (v114.BlackoutKick:CooldownRemains() > (0 - 0)) and v48 and (v119 >= (2 + 1))) or ((3130 - 1709) >= (3153 - 1049))) then
					if (((1988 - (50 + 126)) <= (9046 - 5797)) and v24(v114.TigerPalm, not v15:IsInMeleeRange(2 + 3))) then
						return "tiger_palm aoe 7";
					end
				end
				if (((3036 - (1233 + 180)) <= (2926 - (522 + 447))) and v114.SpinningCraneKick:IsCastable() and v46) then
					if (((5833 - (107 + 1314)) == (2048 + 2364)) and v24(v114.SpinningCraneKick, not v15:IsInMeleeRange(24 - 16))) then
						return "spinning_crane_kick aoe 8";
					end
				end
				break;
			end
			if (((744 + 1006) >= (1671 - 829)) and (v141 == (0 - 0))) then
				if (((6282 - (716 + 1194)) > (32 + 1818)) and v114.SummonWhiteTigerStatue:IsReady() and (v119 >= (1 + 2)) and v44) then
					if (((735 - (74 + 429)) < (1583 - 762)) and (v43 == "Player")) then
						if (((257 + 261) < (2064 - 1162)) and v24(v116.SummonWhiteTigerStatuePlayer, not v15:IsInRange(29 + 11))) then
							return "summon_white_tiger_statue aoe player 1";
						end
					elseif (((9230 - 6236) > (2121 - 1263)) and (v43 == "Cursor")) then
						if (v24(v116.SummonWhiteTigerStatueCursor, not v15:IsInRange(473 - (279 + 154))) or ((4533 - (454 + 324)) <= (720 + 195))) then
							return "summon_white_tiger_statue aoe cursor 1";
						end
					elseif (((3963 - (12 + 5)) > (2019 + 1724)) and (v43 == "Friendly under Cursor") and v16:Exists() and not v13:CanAttack(v16)) then
						if (v24(v116.SummonWhiteTigerStatueCursor, not v15:IsInRange(101 - 61)) or ((494 + 841) >= (4399 - (277 + 816)))) then
							return "summon_white_tiger_statue aoe cursor friendly 1";
						end
					elseif (((20698 - 15854) > (3436 - (1058 + 125))) and (v43 == "Enemy under Cursor") and v16:Exists() and v13:CanAttack(v16)) then
						if (((85 + 367) == (1427 - (815 + 160))) and v24(v116.SummonWhiteTigerStatueCursor, not v15:IsInRange(171 - 131))) then
							return "summon_white_tiger_statue aoe cursor enemy 1";
						end
					elseif ((v43 == "Confirmation") or ((10817 - 6260) < (498 + 1589))) then
						if (((11324 - 7450) == (5772 - (41 + 1857))) and v24(v116.SummonWhiteTigerStatue, not v15:IsInRange(1933 - (1222 + 671)))) then
							return "summon_white_tiger_statue aoe confirmation 1";
						end
					end
				end
				if ((v114.TouchofDeath:IsCastable() and v51) or ((5008 - 3070) > (7093 - 2158))) then
					if (v24(v114.TouchofDeath, not v15:IsInMeleeRange(1187 - (229 + 953))) or ((6029 - (1111 + 663)) < (5002 - (874 + 705)))) then
						return "touch_of_death aoe 2";
					end
				end
				v141 = 1 + 0;
			end
			if (((993 + 461) <= (5177 - 2686)) and ((1 + 0) == v141)) then
				if ((v114.JadefireStomp:IsReady() and v49) or ((4836 - (642 + 37)) <= (640 + 2163))) then
					if (((777 + 4076) >= (7486 - 4504)) and v24(v114.JadefireStomp, not v15:IsInMeleeRange(462 - (233 + 221)))) then
						return "JadefireStomp aoe3";
					end
				end
				if (((9559 - 5425) > (2955 + 402)) and v114.ChiBurst:IsCastable() and v50) then
					if (v24(v114.ChiBurst, not v15:IsInRange(1581 - (718 + 823))) or ((2151 + 1266) < (3339 - (266 + 539)))) then
						return "chi_burst aoe 4";
					end
				end
				v141 = 5 - 3;
			end
			if ((v141 == (1227 - (636 + 589))) or ((6461 - 3739) <= (338 - 174))) then
				if ((v114.SpinningCraneKick:IsCastable() and v46 and (v15:DebuffDown(v114.MysticTouchDebuff) or (v120.EnemiesWithDebuffCount(v114.MysticTouchDebuff) <= (v119 - (1 + 0)))) and v114.MysticTouch:IsAvailable()) or ((875 + 1533) < (3124 - (657 + 358)))) then
					if (v24(v114.SpinningCraneKick, not v15:IsInMeleeRange(21 - 13)) or ((75 - 42) == (2642 - (1151 + 36)))) then
						return "spinning_crane_kick aoe 5";
					end
				end
				if ((v114.BlackoutKick:IsCastable() and v114.AncientConcordance:IsAvailable() and v13:BuffUp(v114.JadefireStomp) and v45 and (v119 >= (3 + 0))) or ((117 + 326) >= (11990 - 7975))) then
					if (((5214 - (1552 + 280)) > (1000 - (64 + 770))) and v24(v114.BlackoutKick, not v15:IsInMeleeRange(4 + 1))) then
						return "blackout_kick aoe 6";
					end
				end
				v141 = 6 - 3;
			end
		end
	end
	local function v127()
		local v142 = 0 + 0;
		while true do
			if ((v142 == (1243 - (157 + 1086))) or ((560 - 280) == (13397 - 10338))) then
				if (((2885 - 1004) > (1763 - 470)) and v114.TouchofDeath:IsCastable() and v51) then
					if (((3176 - (599 + 220)) == (4693 - 2336)) and v24(v114.TouchofDeath, not v15:IsInMeleeRange(1936 - (1813 + 118)))) then
						return "touch_of_death st 1";
					end
				end
				if (((90 + 33) == (1340 - (841 + 376))) and v114.JadefireStomp:IsReady() and v49) then
					if (v24(v114.JadefireStomp, nil) or ((1478 - 422) >= (788 + 2604))) then
						return "JadefireStomp st 2";
					end
				end
				v142 = 2 - 1;
			end
			if ((v142 == (861 - (464 + 395))) or ((2774 - 1693) < (517 + 558))) then
				if ((v114.BlackoutKick:IsCastable() and (v13:BuffStack(v114.TeachingsoftheMonasteryBuff) >= (840 - (467 + 370))) and (v114.RisingSunKick:CooldownRemains() > v13:GCD()) and v45) or ((2167 - 1118) >= (3254 + 1178))) then
					if (v24(v114.BlackoutKick, not v15:IsInMeleeRange(17 - 12)) or ((744 + 4024) <= (1968 - 1122))) then
						return "blackout_kick st 5";
					end
				end
				if ((v114.TigerPalm:IsCastable() and ((v13:BuffStack(v114.TeachingsoftheMonasteryBuff) < (523 - (150 + 370))) or (v13:BuffRemains(v114.TeachingsoftheMonasteryBuff) < (1284 - (74 + 1208)))) and v48) or ((8259 - 4901) <= (6734 - 5314))) then
					if (v24(v114.TigerPalm, not v15:IsInMeleeRange(4 + 1)) or ((4129 - (14 + 376)) <= (5212 - 2207))) then
						return "tiger_palm st 6";
					end
				end
				break;
			end
			if ((v142 == (1 + 0)) or ((1458 + 201) >= (2036 + 98))) then
				if ((v114.RisingSunKick:IsReady() and v47) or ((9552 - 6292) < (1772 + 583))) then
					if (v24(v114.RisingSunKick, not v15:IsInMeleeRange(83 - (23 + 55))) or ((1585 - 916) == (2819 + 1404))) then
						return "rising_sun_kick st 3";
					end
				end
				if ((v114.ChiBurst:IsCastable() and v50) or ((1520 + 172) < (911 - 323))) then
					if (v24(v114.ChiBurst, not v15:IsInRange(13 + 27)) or ((5698 - (652 + 249)) < (9770 - 6119))) then
						return "chi_burst st 4";
					end
				end
				v142 = 1870 - (708 + 1160);
			end
		end
	end
	local function v128()
		local v143 = 0 - 0;
		while true do
			if ((v143 == (1 - 0)) or ((4204 - (10 + 17)) > (1090 + 3760))) then
				if ((v52 and v114.RenewingMist:IsReady() and v17:BuffDown(v114.RenewingMistBuff)) or ((2132 - (1400 + 332)) > (2130 - 1019))) then
					if (((4959 - (242 + 1666)) > (431 + 574)) and (v17:HealthPercentage() <= v53)) then
						if (((1354 + 2339) <= (3735 + 647)) and v24(v116.RenewingMistFocus, not v17:IsSpellInRange(v114.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if ((v56 and v114.Vivify:IsReady() and v13:BuffUp(v114.VivaciousVivificationBuff)) or ((4222 - (850 + 90)) > (7181 - 3081))) then
					if ((v17:HealthPercentage() <= v57) or ((4970 - (360 + 1030)) < (2517 + 327))) then
						if (((250 - 161) < (6177 - 1687)) and v24(v116.VivifyFocus, not v17:IsSpellInRange(v114.Vivify))) then
							return "Vivify instant healing st";
						end
					end
				end
				v143 = 1663 - (909 + 752);
			end
			if ((v143 == (1225 - (109 + 1114))) or ((9122 - 4139) < (704 + 1104))) then
				if (((4071 - (6 + 236)) > (2375 + 1394)) and v60 and v114.SoothingMist:IsReady() and v17:BuffDown(v114.SoothingMist)) then
					if (((1196 + 289) <= (6848 - 3944)) and (v17:HealthPercentage() <= v61)) then
						if (((7456 - 3187) == (5402 - (1076 + 57))) and v24(v116.SoothingMistFocus, not v17:IsSpellInRange(v114.SoothingMist))) then
							return "SoothingMist healing st";
						end
					end
				end
				break;
			end
			if (((64 + 323) <= (3471 - (579 + 110))) and ((0 + 0) == v143)) then
				if ((v52 and v114.RenewingMist:IsReady() and v17:BuffDown(v114.RenewingMistBuff) and (v114.RenewingMist:ChargesFractional() >= (1.8 + 0))) or ((1008 + 891) <= (1324 - (174 + 233)))) then
					if ((v17:HealthPercentage() <= v53) or ((12044 - 7732) <= (1537 - 661))) then
						if (((993 + 1239) <= (3770 - (663 + 511))) and v24(v116.RenewingMistFocus, not v17:IsSpellInRange(v114.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if (((1869 + 226) < (801 + 2885)) and v47 and v114.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.RenewingMistBuff, false, false, 77 - 52) > (1 + 0))) then
					if (v24(v114.RisingSunKick, not v15:IsInMeleeRange(11 - 6)) or ((3861 - 2266) >= (2135 + 2339))) then
						return "RisingSunKick healing st";
					end
				end
				v143 = 1 - 0;
			end
		end
	end
	local function v129()
		local v144 = 0 + 0;
		while true do
			if ((v144 == (1 + 0)) or ((5341 - (478 + 244)) < (3399 - (440 + 77)))) then
				if ((v67 and v114.ZenPulse:IsReady() and v120.AreUnitsBelowHealthPercentage(v69, v68, v114.EnvelopingMist)) or ((134 + 160) >= (17681 - 12850))) then
					if (((3585 - (655 + 901)) <= (572 + 2512)) and v24(v116.ZenPulseFocus, not v17:IsSpellInRange(v114.ZenPulse))) then
						return "ZenPulse healing aoe";
					end
				end
				if ((v70 and v114.SheilunsGift:IsReady() and v114.SheilunsGift:IsCastable() and v120.AreUnitsBelowHealthPercentage(v72, v71, v114.EnvelopingMist)) or ((1560 + 477) == (1635 + 785))) then
					if (((17959 - 13501) > (5349 - (695 + 750))) and v24(v114.SheilunsGift, nil)) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
			if (((1488 - 1052) >= (189 - 66)) and (v144 == (0 - 0))) then
				if (((851 - (285 + 66)) < (4232 - 2416)) and v47 and v114.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.RenewingMistBuff, false, false, 1335 - (682 + 628)) > (1 + 0))) then
					if (((3873 - (176 + 123)) == (1495 + 2079)) and v24(v114.RisingSunKick, not v15:IsInMeleeRange(4 + 1))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (((490 - (239 + 30)) < (107 + 283)) and v120.AreUnitsBelowHealthPercentage(v64, v63, v114.EnvelopingMist)) then
					local v244 = 0 + 0;
					while true do
						if ((v244 == (0 - 0)) or ((6903 - 4690) <= (1736 - (306 + 9)))) then
							if (((10671 - 7613) < (846 + 4014)) and v36 and (v13:BuffStack(v114.ManaTeaCharges) > v37) and v114.EssenceFont:IsReady() and v114.ManaTea:IsCastable()) then
								if (v24(v114.ManaTea, nil) or ((796 + 500) >= (2141 + 2305))) then
									return "EssenceFont healing aoe";
								end
							end
							if ((v38 and v114.ThunderFocusTea:IsReady() and (v114.EssenceFont:CooldownRemains() < v13:GCD())) or ((3983 - 2590) > (5864 - (1140 + 235)))) then
								if (v24(v114.ThunderFocusTea, nil) or ((2816 + 1608) < (25 + 2))) then
									return "ThunderFocusTea healing aoe";
								end
							end
							v244 = 1 + 0;
						end
						if ((v244 == (53 - (33 + 19))) or ((722 + 1275) > (11434 - 7619))) then
							if (((1527 + 1938) > (3751 - 1838)) and v62 and v114.EssenceFont:IsReady() and (v13:BuffUp(v114.ThunderFocusTea) or (v114.ThunderFocusTea:CooldownRemains() > (8 + 0)))) then
								if (((1422 - (586 + 103)) < (166 + 1653)) and v24(v114.EssenceFont, nil)) then
									return "EssenceFont healing aoe";
								end
							end
							if ((v62 and v114.EssenceFont:IsReady() and v114.AncientTeachings:IsAvailable() and v13:BuffDown(v114.EssenceFontBuff)) or ((13530 - 9135) == (6243 - (1309 + 179)))) then
								if (v24(v114.EssenceFont, nil) or ((6847 - 3054) < (1032 + 1337))) then
									return "EssenceFont healing aoe";
								end
							end
							break;
						end
					end
				end
				v144 = 2 - 1;
			end
		end
	end
	local function v130()
		if ((v58 and v114.EnvelopingMist:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.EnvelopingMist, false, false, 19 + 6) < (5 - 2))) or ((8137 - 4053) == (874 - (295 + 314)))) then
			local v155 = 0 - 0;
			while true do
				if (((6320 - (1300 + 662)) == (13684 - 9326)) and (v155 == (1756 - (1178 + 577)))) then
					if (v24(v116.EnvelopingMistFocus, not v17:IsSpellInRange(v114.EnvelopingMist)) or ((1630 + 1508) < (2935 - 1942))) then
						return "Enveloping Mist YuLon";
					end
					break;
				end
				if (((4735 - (851 + 554)) > (2055 + 268)) and (v155 == (0 - 0))) then
					v29 = v120.FocusUnitRefreshableBuff(v114.EnvelopingMist, 3 - 1, 342 - (115 + 187), nil, false, 20 + 5, v114.EnvelopingMist);
					if (v29 or ((3433 + 193) == (15719 - 11730))) then
						return v29;
					end
					v155 = 1162 - (160 + 1001);
				end
			end
		end
		if ((v47 and v114.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.EnvelopingMist, false, false, 22 + 3) > (2 + 0))) or ((1874 - 958) == (3029 - (237 + 121)))) then
			if (((1169 - (525 + 372)) == (515 - 243)) and v24(v114.RisingSunKick, not v15:IsInMeleeRange(16 - 11))) then
				return "Rising Sun Kick YuLon";
			end
		end
		if (((4391 - (96 + 46)) <= (5616 - (643 + 134))) and v60 and v114.SoothingMist:IsReady() and v17:BuffUp(v114.ChiHarmonyBuff) and v17:BuffDown(v114.SoothingMist)) then
			if (((1003 + 1774) < (7672 - 4472)) and v24(v116.SoothingMistFocus, not v17:IsSpellInRange(v114.SoothingMist))) then
				return "Soothing Mist YuLon";
			end
		end
	end
	local function v131()
		local v145 = 0 - 0;
		while true do
			if (((92 + 3) < (3840 - 1883)) and (v145 == (1 - 0))) then
				if (((1545 - (316 + 403)) < (1142 + 575)) and v47 and v114.RisingSunKick:IsReady()) then
					if (((3920 - 2494) >= (400 + 705)) and v24(v114.RisingSunKick, not v15:IsInMeleeRange(12 - 7))) then
						return "Rising Sun Kick ChiJi";
					end
				end
				if (((1952 + 802) <= (1089 + 2290)) and v58 and v114.EnvelopingMist:IsReady() and (v13:BuffStack(v114.InvokeChiJiBuff) >= (6 - 4))) then
					if ((v17:HealthPercentage() <= v59) or ((18754 - 14827) == (2935 - 1522))) then
						if (v24(v116.EnvelopingMistFocus, not v17:IsSpellInRange(v114.EnvelopingMist)) or ((67 + 1087) <= (1550 - 762))) then
							return "Enveloping Mist 2 Stacks ChiJi";
						end
					end
				end
				v145 = 1 + 1;
			end
			if ((v145 == (0 - 0)) or ((1660 - (12 + 5)) > (13123 - 9744))) then
				if ((v45 and v114.BlackoutKick:IsReady() and (v13:BuffStack(v114.TeachingsoftheMonastery) >= (5 - 2))) or ((5958 - 3155) > (11280 - 6731))) then
					if (v24(v114.BlackoutKick, not v15:IsInMeleeRange(2 + 3)) or ((2193 - (1656 + 317)) >= (2693 + 329))) then
						return "Blackout Kick ChiJi";
					end
				end
				if (((2262 + 560) == (7503 - 4681)) and v58 and v114.EnvelopingMist:IsReady() and (v13:BuffStack(v114.InvokeChiJiBuff) == (14 - 11))) then
					if ((v17:HealthPercentage() <= v59) or ((1415 - (5 + 349)) == (8820 - 6963))) then
						if (((4031 - (266 + 1005)) > (899 + 465)) and v24(v116.EnvelopingMistFocus, not v17:IsSpellInRange(v114.EnvelopingMist))) then
							return "Enveloping Mist 3 Stacks ChiJi";
						end
					end
				end
				v145 = 3 - 2;
			end
			if ((v145 == (2 - 0)) or ((6598 - (561 + 1135)) <= (4684 - 1089))) then
				if ((v62 and v114.EssenceFont:IsReady() and v114.AncientTeachings:IsAvailable() and v13:BuffDown(v114.AncientTeachings)) or ((12661 - 8809) == (1359 - (507 + 559)))) then
					if (v24(v114.EssenceFont, nil) or ((3911 - 2352) == (14189 - 9601))) then
						return "Essence Font ChiJi";
					end
				end
				break;
			end
		end
	end
	local function v132()
		local v146 = 388 - (212 + 176);
		while true do
			if ((v146 == (908 - (250 + 655))) or ((12227 - 7743) == (1376 - 588))) then
				if (((7146 - 2578) >= (5863 - (1869 + 87))) and (v114.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (86 - 61))) then
					local v245 = 1901 - (484 + 1417);
					while true do
						if (((2670 - 1424) < (5815 - 2345)) and (v245 == (773 - (48 + 725)))) then
							v29 = v131();
							if (((6645 - 2577) >= (2607 - 1635)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				break;
			end
			if (((287 + 206) < (10403 - 6510)) and ((1 + 0) == v146)) then
				if ((v81 and v114.Restoral:IsReady() and v114.Restoral:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v83, v82, v114.EnvelopingMist)) or ((430 + 1043) >= (4185 - (152 + 701)))) then
					if (v24(v114.Restoral, nil) or ((5362 - (430 + 881)) <= (444 + 713))) then
						return "Restoral CD";
					end
				end
				if (((1499 - (557 + 338)) < (852 + 2029)) and v73 and v114.InvokeYulonTheJadeSerpent:IsAvailable() and v114.InvokeYulonTheJadeSerpent:IsReady() and v120.AreUnitsBelowHealthPercentage(v75, v74, v114.EnvelopingMist)) then
					if ((v52 and v114.RenewingMist:IsReady() and (v114.RenewingMist:ChargesFractional() >= (2 - 1))) or ((3151 - 2251) == (8971 - 5594))) then
						local v252 = 0 - 0;
						while true do
							if (((5260 - (499 + 302)) > (1457 - (39 + 827))) and (v252 == (2 - 1))) then
								if (((7588 - 4190) >= (9512 - 7117)) and v24(v116.RenewingMistFocus, not v17:IsSpellInRange(v114.RenewingMist))) then
									return "Renewing Mist YuLon prep";
								end
								break;
							end
							if ((v252 == (0 - 0)) or ((187 + 1996) >= (8265 - 5441))) then
								v29 = v120.FocusUnitRefreshableBuff(v114.RenewingMistBuff, 1 + 5, 63 - 23, nil, false, 129 - (103 + 1), v114.EnvelopingMist);
								if (((2490 - (475 + 79)) == (4185 - 2249)) and v29) then
									return v29;
								end
								v252 = 3 - 2;
							end
						end
					end
					if ((v36 and v114.ManaTea:IsCastable() and (v13:BuffStack(v114.ManaTeaCharges) >= (1 + 2)) and v13:BuffDown(v114.ManaTeaBuff)) or ((4253 + 579) < (5816 - (1395 + 108)))) then
						if (((11895 - 7807) > (5078 - (7 + 1197))) and v24(v114.ManaTea, nil)) then
							return "ManaTea YuLon prep";
						end
					end
					if (((1889 + 2443) == (1512 + 2820)) and v70 and v114.SheilunsGift:IsReady() and (v114.SheilunsGift:TimeSinceLastCast() > (339 - (27 + 292)))) then
						if (((11718 - 7719) >= (3698 - 798)) and v24(v114.SheilunsGift, nil)) then
							return "Sheilun's Gift YuLon prep";
						end
					end
					if ((v114.InvokeYulonTheJadeSerpent:IsReady() and (v114.RenewingMist:ChargesFractional() < (4 - 3)) and v13:BuffUp(v114.ManaTeaBuff) and (v114.SheilunsGift:TimeSinceLastCast() < ((7 - 3) * v13:GCD()))) or ((4808 - 2283) > (4203 - (43 + 96)))) then
						if (((17829 - 13458) == (9882 - 5511)) and v24(v114.InvokeYulonTheJadeSerpent, nil)) then
							return "Invoke Yu'lon GO";
						end
					end
				end
				v146 = 2 + 0;
			end
			if ((v146 == (1 + 1)) or ((525 - 259) > (1911 + 3075))) then
				if (((3731 - 1740) >= (292 + 633)) and (v114.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (2 + 23))) then
					v29 = v130();
					if (((2206 - (1414 + 337)) < (3993 - (1642 + 298))) and v29) then
						return v29;
					end
				end
				if ((v76 and v114.InvokeChiJiTheRedCrane:IsReady() and v114.InvokeChiJiTheRedCrane:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v78, v77, v114.EnvelopingMist)) or ((2152 - 1326) == (13955 - 9104))) then
					local v246 = 0 - 0;
					while true do
						if (((61 + 122) == (143 + 40)) and (v246 == (973 - (357 + 615)))) then
							if (((814 + 345) <= (4387 - 2599)) and v114.InvokeChiJiTheRedCrane:IsReady() and (v114.RenewingMist:ChargesFractional() < (1 + 0)) and v13:BuffUp(v114.AncientTeachings) and (v13:BuffStack(v114.TeachingsoftheMonastery) == (6 - 3)) and (v114.SheilunsGift:TimeSinceLastCast() < ((4 + 0) * v13:GCD()))) then
								if (v24(v114.InvokeChiJiTheRedCrane, nil) or ((239 + 3268) > (2715 + 1603))) then
									return "Invoke Chi'ji GO";
								end
							end
							break;
						end
						if ((v246 == (1301 - (384 + 917))) or ((3772 - (128 + 569)) <= (4508 - (1407 + 136)))) then
							if (((3252 - (687 + 1200)) <= (3721 - (556 + 1154))) and v52 and v114.RenewingMist:IsReady() and (v114.RenewingMist:ChargesFractional() >= (3 - 2))) then
								local v254 = 95 - (9 + 86);
								while true do
									if ((v254 == (421 - (275 + 146))) or ((452 + 2324) > (3639 - (29 + 35)))) then
										v29 = v120.FocusUnitRefreshableBuff(v114.RenewingMistBuff, 26 - 20, 119 - 79, nil, false, 110 - 85, v114.EnvelopingMist);
										if (v29 or ((1664 + 890) == (5816 - (53 + 959)))) then
											return v29;
										end
										v254 = 409 - (312 + 96);
									end
									if (((4472 - 1895) == (2862 - (147 + 138))) and (v254 == (900 - (813 + 86)))) then
										if (v24(v116.RenewingMistFocus, not v17:IsSpellInRange(v114.RenewingMist)) or ((6 + 0) >= (3499 - 1610))) then
											return "Renewing Mist ChiJi prep";
										end
										break;
									end
								end
							end
							if (((998 - (18 + 474)) <= (639 + 1253)) and v70 and v114.SheilunsGift:IsReady() and (v114.SheilunsGift:TimeSinceLastCast() > (65 - 45))) then
								if (v24(v114.SheilunsGift, nil) or ((3094 - (860 + 226)) > (2521 - (121 + 182)))) then
									return "Sheilun's Gift ChiJi prep";
								end
							end
							v246 = 1 + 0;
						end
					end
				end
				v146 = 1243 - (988 + 252);
			end
			if (((43 + 336) <= (1299 + 2848)) and ((1970 - (49 + 1921)) == v146)) then
				if ((v79 and v114.LifeCocoon:IsReady() and (v17:HealthPercentage() <= v80)) or ((5404 - (223 + 667)) <= (1061 - (51 + 1)))) then
					if (v24(v116.LifeCocoonFocus, not v17:IsSpellInRange(v114.LifeCocoon)) or ((6016 - 2520) == (2552 - 1360))) then
						return "Life Cocoon CD";
					end
				end
				if ((v81 and v114.Revival:IsReady() and v114.Revival:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v83, v82, v114.EnvelopingMist)) or ((1333 - (146 + 979)) == (836 + 2123))) then
					if (((4882 - (311 + 294)) >= (3661 - 2348)) and v24(v114.Revival, nil)) then
						return "Revival CD";
					end
				end
				v146 = 1 + 0;
			end
		end
	end
	local function v133()
		local v147 = 1443 - (496 + 947);
		while true do
			if (((3945 - (1233 + 125)) < (1288 + 1886)) and (v147 == (1 + 0))) then
				v42 = EpicSettings.Settings['DampenHarmHP'];
				v43 = EpicSettings.Settings['WhiteTigerUsage'];
				v44 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
				v45 = EpicSettings.Settings['UseBlackoutKick'];
				v46 = EpicSettings.Settings['UseSpinningCraneKick'];
				v47 = EpicSettings.Settings['UseRisingSunKick'];
				v147 = 1 + 1;
			end
			if ((v147 == (1650 - (963 + 682))) or ((3439 + 681) <= (3702 - (504 + 1000)))) then
				v65 = EpicSettings.Settings['JadeSerpentUsage'];
				v67 = EpicSettings.Settings['UseZenPulse'];
				v69 = EpicSettings.Settings['ZenPulseHP'];
				v68 = EpicSettings.Settings['ZenPulseGroup'];
				v70 = EpicSettings.Settings['UseSheilunsGift'];
				v72 = EpicSettings.Settings['SheilunsGiftHP'];
				v147 = 5 + 1;
			end
			if ((v147 == (4 + 0)) or ((151 + 1445) == (1265 - 407))) then
				v60 = EpicSettings.Settings['UseSoothingMist'];
				v61 = EpicSettings.Settings['SoothingMistHP'];
				v62 = EpicSettings.Settings['UseEssenceFont'];
				v64 = EpicSettings.Settings['EssenceFontHP'];
				v63 = EpicSettings.Settings['EssenceFontGroup'];
				v66 = EpicSettings.Settings['UseJadeSerpent'];
				v147 = 5 + 0;
			end
			if (((1873 + 1347) == (3402 - (156 + 26))) and (v147 == (2 + 0))) then
				v48 = EpicSettings.Settings['UseTigerPalm'];
				v49 = EpicSettings.Settings['UseJadefireStomp'];
				v50 = EpicSettings.Settings['UseChiBurst'];
				v51 = EpicSettings.Settings['UseTouchOfDeath'];
				v52 = EpicSettings.Settings['UseRenewingMist'];
				v53 = EpicSettings.Settings['RenewingMistHP'];
				v147 = 3 - 0;
			end
			if ((v147 == (170 - (149 + 15))) or ((2362 - (890 + 70)) > (3737 - (39 + 78)))) then
				v71 = EpicSettings.Settings['SheilunsGiftGroup'];
				break;
			end
			if (((3056 - (14 + 468)) == (5659 - 3085)) and ((8 - 5) == v147)) then
				v54 = EpicSettings.Settings['UseExpelHarm'];
				v55 = EpicSettings.Settings['ExpelHarmHP'];
				v56 = EpicSettings.Settings['UseVivify'];
				v57 = EpicSettings.Settings['VivifyHP'];
				v58 = EpicSettings.Settings['UseEnvelopingMist'];
				v59 = EpicSettings.Settings['EnvelopingMistHP'];
				v147 = 3 + 1;
			end
			if (((1080 + 718) < (586 + 2171)) and (v147 == (0 + 0))) then
				v36 = EpicSettings.Settings['UseManaTea'];
				v37 = EpicSettings.Settings['ManaTeaStacks'];
				v38 = EpicSettings.Settings['UseThunderFocusTea'];
				v39 = EpicSettings.Settings['UseFortifyingBrew'];
				v40 = EpicSettings.Settings['FortifyingBrewHP'];
				v41 = EpicSettings.Settings['UseDampenHarm'];
				v147 = 1 + 0;
			end
		end
	end
	local function v134()
		local v148 = 0 - 0;
		while true do
			if ((v148 == (1 + 0)) or ((1324 - 947) > (66 + 2538))) then
				v100 = EpicSettings.Settings['useWeapon'];
				v89 = EpicSettings.Settings['dispelDebuffs'];
				v86 = EpicSettings.Settings['useHealingPotion'];
				v87 = EpicSettings.Settings['healingPotionHP'];
				v88 = EpicSettings.Settings['HealingPotionName'];
				v148 = 53 - (12 + 39);
			end
			if (((529 + 39) < (2819 - 1908)) and (v148 == (24 - 17))) then
				v81 = EpicSettings.Settings['UseRevival'];
				v83 = EpicSettings.Settings['RevivalHP'];
				v82 = EpicSettings.Settings['RevivalGroup'];
				break;
			end
			if (((974 + 2311) < (2226 + 2002)) and (v148 == (14 - 8))) then
				v76 = EpicSettings.Settings['UseInvokeChiJi'];
				v78 = EpicSettings.Settings['InvokeChiJiHP'];
				v77 = EpicSettings.Settings['InvokeChiJiGroup'];
				v79 = EpicSettings.Settings['UseLifeCocoon'];
				v80 = EpicSettings.Settings['LifeCocoonHP'];
				v148 = 5 + 2;
			end
			if (((18925 - 15009) > (5038 - (1596 + 114))) and (v148 == (0 - 0))) then
				v96 = EpicSettings.Settings['racialsWithCD'];
				v95 = EpicSettings.Settings['useRacials'];
				v98 = EpicSettings.Settings['trinketsWithCD'];
				v97 = EpicSettings.Settings['useTrinkets'];
				v99 = EpicSettings.Settings['fightRemainsCheck'];
				v148 = 714 - (164 + 549);
			end
			if (((3938 - (1059 + 379)) < (4766 - 927)) and (v148 == (2 + 0))) then
				v84 = EpicSettings.Settings['useHealthstone'];
				v85 = EpicSettings.Settings['healthstoneHP'];
				v107 = EpicSettings.Settings['useManaPotion'];
				v108 = EpicSettings.Settings['manaPotionSlider'];
				v109 = EpicSettings.Settings['RevivalBurstingGroup'];
				v148 = 1 + 2;
			end
			if (((899 - (145 + 247)) == (417 + 90)) and (v148 == (2 + 2))) then
				v94 = EpicSettings.Settings['useLegSweep'];
				v101 = EpicSettings.Settings['handleAfflicted'];
				v102 = EpicSettings.Settings['HandleIncorporeal'];
				v103 = EpicSettings.Settings['HandleChromie'];
				v105 = EpicSettings.Settings['HandleCharredBrambles'];
				v148 = 14 - 9;
			end
			if (((47 + 193) <= (2727 + 438)) and (v148 == (4 - 1))) then
				v110 = EpicSettings.Settings['RevivalBurstingStacks'];
				v92 = EpicSettings.Settings['InterruptThreshold'];
				v90 = EpicSettings.Settings['InterruptWithStun'];
				v91 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v93 = EpicSettings.Settings['useSpearHandStrike'];
				v148 = 724 - (254 + 466);
			end
			if (((1394 - (544 + 16)) >= (2558 - 1753)) and (v148 == (633 - (294 + 334)))) then
				v104 = EpicSettings.Settings['HandleCharredTreant'];
				v106 = EpicSettings.Settings['HandleFyrakkNPC'];
				v73 = EpicSettings.Settings['UseInvokeYulon'];
				v75 = EpicSettings.Settings['InvokeYulonHP'];
				v74 = EpicSettings.Settings['InvokeYulonGroup'];
				v148 = 259 - (236 + 17);
			end
		end
	end
	local v135 = 0 + 0;
	local function v136()
		local v149 = 0 + 0;
		while true do
			if ((v149 == (14 - 10)) or ((18047 - 14235) < (1193 + 1123))) then
				v29 = v124();
				if (v29 or ((2185 + 467) <= (2327 - (413 + 381)))) then
					return v29;
				end
				if (v13:AffectingCombat() or v30 or ((152 + 3446) < (3105 - 1645))) then
					local v247 = 0 - 0;
					local v248;
					while true do
						if ((v247 == (1970 - (582 + 1388))) or ((7012 - 2896) < (854 + 338))) then
							v248 = v89 and v114.Detox:IsReady() and v33;
							v29 = v120.FocusUnit(v248, nil, 404 - (326 + 38), nil, 73 - 48, v114.EnvelopingMist);
							v247 = 1 - 0;
						end
						if ((v247 == (621 - (47 + 573))) or ((1191 + 2186) <= (3834 - 2931))) then
							if (((6453 - 2477) >= (2103 - (1269 + 395))) and v29) then
								return v29;
							end
							if (((4244 - (76 + 416)) == (4195 - (319 + 124))) and v33 and v89) then
								local v255 = 0 - 0;
								while true do
									if (((5053 - (564 + 443)) > (7460 - 4765)) and (v255 == (458 - (337 + 121)))) then
										if ((v17 and v17:Exists() and v17:IsAPlayer() and (v120.UnitHasDispellableDebuffByPlayer(v17) or v120.DispellableFriendlyUnit(73 - 48))) or ((11808 - 8263) == (5108 - (1261 + 650)))) then
											if (((1013 + 1381) > (593 - 220)) and v114.Detox:IsCastable()) then
												local v261 = 1817 - (772 + 1045);
												while true do
													if (((587 + 3568) <= (4376 - (102 + 42))) and (v261 == (1844 - (1524 + 320)))) then
														if ((v135 == (1270 - (1049 + 221))) or ((3737 - (18 + 138)) == (8500 - 5027))) then
															v135 = GetTime();
														end
														if (((6097 - (67 + 1035)) > (3696 - (136 + 212))) and v120.Wait(2124 - 1624, v135)) then
															if (v24(v116.DetoxFocus, not v17:IsSpellInRange(v114.Detox)) or ((605 + 149) > (3433 + 291))) then
																return "detox dispel focus";
															end
															v135 = 1604 - (240 + 1364);
														end
														break;
													end
												end
											end
										end
										if (((1299 - (1050 + 32)) >= (203 - 146)) and v16 and v16:Exists() and not v13:CanAttack(v16) and v120.UnitHasDispellableDebuffByPlayer(v16)) then
											if (v114.Detox:IsCastable() or ((1225 + 845) >= (5092 - (331 + 724)))) then
												if (((219 + 2486) == (3349 - (269 + 375))) and v24(v116.DetoxMouseover, not v16:IsSpellInRange(v114.Detox))) then
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
				v149 = 730 - (267 + 458);
			end
			if (((19 + 42) == (117 - 56)) and (v149 == (824 - (667 + 151)))) then
				if (((v30 or v13:AffectingCombat()) and v120.TargetIsValid() and v13:CanAttack(v15)) or ((2196 - (1410 + 87)) >= (3193 - (1504 + 393)))) then
					local v249 = 0 - 0;
					while true do
						if ((v249 == (2 - 1)) or ((2579 - (461 + 335)) >= (463 + 3153))) then
							if ((v97 and ((v32 and v98) or not v98)) or ((5674 - (1730 + 31)) > (6194 - (728 + 939)))) then
								local v256 = 0 - 0;
								while true do
									if (((8875 - 4499) > (1871 - 1054)) and (v256 == (1069 - (138 + 930)))) then
										v29 = v120.HandleBottomTrinket(v117, v32, 37 + 3, nil);
										if (((3801 + 1060) > (707 + 117)) and v29) then
											return v29;
										end
										break;
									end
									if ((v256 == (0 - 0)) or ((3149 - (459 + 1307)) >= (4001 - (474 + 1396)))) then
										v29 = v120.HandleTopTrinket(v117, v32, 69 - 29, nil);
										if (v29 or ((1759 + 117) >= (9 + 2532))) then
											return v29;
										end
										v256 = 2 - 1;
									end
								end
							end
							if (((226 + 1556) <= (12591 - 8819)) and v35) then
								local v257 = 0 - 0;
								while true do
									if ((v257 == (591 - (562 + 29))) or ((4007 + 693) < (2232 - (374 + 1045)))) then
										if (((2532 + 667) < (12576 - 8526)) and v95 and ((v32 and v96) or not v96) and (v112 < (656 - (448 + 190)))) then
											if (v114.BloodFury:IsCastable() or ((1599 + 3352) < (2000 + 2430))) then
												if (((63 + 33) == (369 - 273)) and v24(v114.BloodFury, nil)) then
													return "blood_fury main 4";
												end
											end
											if (v114.Berserking:IsCastable() or ((8510 - 5771) > (5502 - (1307 + 187)))) then
												if (v24(v114.Berserking, nil) or ((91 - 68) == (2654 - 1520))) then
													return "berserking main 6";
												end
											end
											if (v114.LightsJudgment:IsCastable() or ((8257 - 5564) >= (4794 - (232 + 451)))) then
												if (v24(v114.LightsJudgment, not v15:IsInRange(39 + 1)) or ((3813 + 503) <= (2710 - (510 + 54)))) then
													return "lights_judgment main 8";
												end
											end
											if (v114.Fireblood:IsCastable() or ((7144 - 3598) <= (2845 - (13 + 23)))) then
												if (((9559 - 4655) > (3111 - 945)) and v24(v114.Fireblood, nil)) then
													return "fireblood main 10";
												end
											end
											if (((197 - 88) >= (1178 - (830 + 258))) and v114.AncestralCall:IsCastable()) then
												if (((17560 - 12582) > (1818 + 1087)) and v24(v114.AncestralCall, nil)) then
													return "ancestral_call main 12";
												end
											end
											if (v114.BagofTricks:IsCastable() or ((2575 + 451) <= (3721 - (860 + 581)))) then
												if (v24(v114.BagofTricks, not v15:IsInRange(147 - 107)) or ((1312 + 341) <= (1349 - (237 + 4)))) then
													return "bag_of_tricks main 14";
												end
											end
										end
										if (((6836 - 3927) > (6600 - 3991)) and v38 and v114.ThunderFocusTea:IsReady() and not v114.EssenceFont:IsAvailable() and (v114.RisingSunKick:CooldownRemains() < v13:GCD())) then
											if (((1434 - 677) > (159 + 35)) and v24(v114.ThunderFocusTea, nil)) then
												return "ThunderFocusTea main 16";
											end
										end
										v257 = 1 + 0;
									end
									if ((v257 == (3 - 2)) or ((14 + 17) >= (761 + 637))) then
										if (((4622 - (85 + 1341)) <= (8313 - 3441)) and (v119 >= (8 - 5)) and v31) then
											v29 = v126();
											if (((3698 - (45 + 327)) == (6275 - 2949)) and v29) then
												return v29;
											end
										end
										if (((1935 - (444 + 58)) <= (1686 + 2192)) and (v119 < (1 + 2))) then
											local v259 = 0 + 0;
											while true do
												if ((v259 == (0 - 0)) or ((3315 - (64 + 1668)) == (3708 - (1227 + 746)))) then
													v29 = v127();
													if (v29 or ((9162 - 6181) == (4361 - 2011))) then
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
							break;
						end
						if ((v249 == (494 - (415 + 79))) or ((115 + 4351) <= (984 - (142 + 349)))) then
							v29 = v123();
							if (v29 or ((1092 + 1455) <= (2731 - 744))) then
								return v29;
							end
							v249 = 1 + 0;
						end
					end
				end
				break;
			end
			if (((2087 + 874) > (7462 - 4722)) and (v149 == (1866 - (1710 + 154)))) then
				v34 = EpicSettings.Toggles['healing'];
				v35 = EpicSettings.Toggles['dps'];
				if (((4014 - (200 + 118)) >= (1432 + 2180)) and v13:IsDeadOrGhost()) then
					return;
				end
				v149 = 5 - 2;
			end
			if ((v149 == (7 - 2)) or ((2639 + 331) == (1858 + 20))) then
				if (not v13:AffectingCombat() or ((1982 + 1711) < (316 + 1661))) then
					if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((2014 - 1084) > (3351 - (363 + 887)))) then
						local v253 = v120.DeadFriendlyUnitsCount();
						if (((7251 - 3098) > (14688 - 11602)) and (v253 > (1 + 0))) then
							if (v24(v114.Reawaken, nil) or ((10889 - 6235) <= (2768 + 1282))) then
								return "reawaken";
							end
						elseif (v24(v116.ResuscitateMouseover, not v15:IsInRange(1704 - (674 + 990))) or ((746 + 1856) < (613 + 883))) then
							return "resuscitate";
						end
					end
				end
				if ((not v13:AffectingCombat() and v30) or ((1616 - 596) > (3343 - (507 + 548)))) then
					v29 = v125();
					if (((1165 - (289 + 548)) == (2146 - (821 + 997))) and v29) then
						return v29;
					end
				end
				if (((1766 - (195 + 60)) < (1024 + 2784)) and (v30 or v13:AffectingCombat())) then
					local v250 = 1501 - (251 + 1250);
					while true do
						if ((v250 == (2 - 1)) or ((1725 + 785) > (5951 - (809 + 223)))) then
							if (((6950 - 2187) == (14303 - 9540)) and (v13:DebuffStack(v114.Bursting) > (16 - 11))) then
								if (((3047 + 1090) > (968 + 880)) and v114.DiffuseMagic:IsReady() and v114.DiffuseMagic:IsAvailable()) then
									if (((3053 - (14 + 603)) <= (3263 - (118 + 11))) and v24(v114.DiffuseMagic, nil)) then
										return "Diffues Magic Bursting Player";
									end
								end
							end
							if (((603 + 3120) == (3101 + 622)) and (v114.Bursting:MaxDebuffStack() > v110) and (v114.Bursting:AuraActiveCount() > v109)) then
								if ((v81 and v114.Revival:IsReady() and v114.Revival:IsAvailable()) or ((11790 - 7744) >= (5265 - (551 + 398)))) then
									if (v24(v114.Revival, nil) or ((1269 + 739) < (687 + 1242))) then
										return "Revival Bursting";
									end
								end
							end
							v250 = 2 + 0;
						end
						if (((8866 - 6482) > (4089 - 2314)) and ((0 + 0) == v250)) then
							if ((v32 and v100 and (v115.Dreambinder:IsEquippedAndReady() or v115.Iridal:IsEquippedAndReady())) or ((18034 - 13491) <= (1209 + 3167))) then
								if (((817 - (40 + 49)) == (2772 - 2044)) and v24(v116.UseWeapon, nil)) then
									return "Using Weapon Macro";
								end
							end
							if ((v107 and v115.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v108)) or ((1566 - (99 + 391)) > (3864 + 807))) then
								if (((8136 - 6285) >= (935 - 557)) and v24(v116.ManaPotion, nil)) then
									return "Mana Potion main";
								end
							end
							v250 = 1 + 0;
						end
						if ((v250 == (5 - 3)) or ((3552 - (1032 + 572)) >= (3893 - (203 + 214)))) then
							if (((6611 - (568 + 1249)) >= (652 + 181)) and v34) then
								local v258 = 0 - 0;
								while true do
									if (((15797 - 11707) == (5396 - (913 + 393))) and (v258 == (0 - 0))) then
										if ((v114.SummonJadeSerpentStatue:IsReady() and v114.SummonJadeSerpentStatue:IsAvailable() and (v114.SummonJadeSerpentStatue:TimeSinceLastCast() > (127 - 37)) and v66) or ((4168 - (269 + 141)) == (5555 - 3057))) then
											if ((v65 == "Player") or ((4654 - (362 + 1619)) < (3200 - (950 + 675)))) then
												if (v24(v116.SummonJadeSerpentStatuePlayer, not v15:IsInRange(16 + 24)) or ((4900 - (216 + 963)) <= (2742 - (485 + 802)))) then
													return "jade serpent main player";
												end
											elseif (((1493 - (432 + 127)) < (3343 - (1065 + 8))) and (v65 == "Cursor")) then
												if (v24(v116.SummonJadeSerpentStatueCursor, not v15:IsInRange(23 + 17)) or ((3213 - (635 + 966)) == (903 + 352))) then
													return "jade serpent main cursor";
												end
											elseif ((v65 == "Confirmation") or ((4394 - (5 + 37)) < (10460 - 6254))) then
												if (v24(v114.SummonJadeSerpentStatue, not v15:IsInRange(17 + 23)) or ((4526 - 1666) <= (85 + 96))) then
													return "jade serpent main confirmation";
												end
											end
										end
										if (((6694 - 3472) >= (5789 - 4262)) and v52 and v114.RenewingMist:IsReady() and v15:BuffDown(v114.RenewingMistBuff) and not v13:CanAttack(v15)) then
											if (((2838 - 1333) <= (5070 - 2949)) and (v15:HealthPercentage() <= v53)) then
												if (((535 + 209) == (1273 - (318 + 211))) and v24(v114.RenewingMist, not v15:IsSpellInRange(v114.RenewingMist))) then
													return "RenewingMist main";
												end
											end
										end
										v258 = 4 - 3;
									end
									if ((v258 == (1589 - (963 + 624))) or ((846 + 1133) >= (3682 - (518 + 328)))) then
										if (((4272 - 2439) <= (4264 - 1596)) and (v112 > v99) and v32 and v13:AffectingCombat()) then
											local v260 = 317 - (301 + 16);
											while true do
												if (((10803 - 7117) == (10351 - 6665)) and (v260 == (0 - 0))) then
													v29 = v132();
													if (((3141 + 326) > (271 + 206)) and v29) then
														return v29;
													end
													break;
												end
											end
										end
										if (v31 or ((7019 - 3731) >= (2131 + 1410))) then
											v29 = v129();
											if (v29 or ((339 + 3218) == (14434 - 9894))) then
												return v29;
											end
										end
										v258 = 1 + 2;
									end
									if (((1022 - (829 + 190)) == v258) or ((931 - 670) > (1602 - 335))) then
										v29 = v128();
										if (((1757 - 485) < (9583 - 5725)) and v29) then
											return v29;
										end
										break;
									end
									if (((869 + 2795) == (1197 + 2467)) and ((2 - 1) == v258)) then
										if (((1832 + 109) >= (1063 - (520 + 93))) and v60 and v114.SoothingMist:IsReady() and v15:BuffDown(v114.SoothingMist) and not v13:CanAttack(v15)) then
											if ((v15:HealthPercentage() <= v61) or ((4922 - (259 + 17)) < (19 + 305))) then
												if (((1380 + 2453) == (12976 - 9143)) and v24(v114.SoothingMist, not v15:IsSpellInRange(v114.SoothingMist))) then
													return "SoothingMist main";
												end
											end
										end
										if ((v36 and (v13:BuffStack(v114.ManaTeaCharges) >= (609 - (396 + 195))) and v114.ManaTea:IsCastable()) or ((3597 - 2357) > (5131 - (440 + 1321)))) then
											if (v24(v114.ManaTea, nil) or ((4310 - (1059 + 770)) == (21650 - 16968))) then
												return "Mana Tea main avoid overcap";
											end
										end
										v258 = 547 - (424 + 121);
									end
								end
							end
							break;
						end
					end
				end
				v149 = 2 + 4;
			end
			if (((6074 - (641 + 706)) >= (83 + 125)) and (v149 == (440 - (249 + 191)))) then
				v133();
				v134();
				v30 = EpicSettings.Toggles['ooc'];
				v149 = 4 - 3;
			end
			if (((126 + 154) < (14842 - 10991)) and (v149 == (428 - (183 + 244)))) then
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v33 = EpicSettings.Toggles['dispel'];
				v149 = 1 + 1;
			end
			if ((v149 == (733 - (434 + 296))) or ((9595 - 6588) > (3706 - (169 + 343)))) then
				v118 = v13:GetEnemiesInMeleeRange(8 + 0);
				if (v31 or ((3757 - 1621) >= (8647 - 5701))) then
					v119 = #v118;
				else
					v119 = 1 + 0;
				end
				if (((6139 - 3974) <= (3644 - (651 + 472))) and (v120.TargetIsValid() or v13:AffectingCombat())) then
					local v251 = 0 + 0;
					while true do
						if (((1235 + 1626) > (806 - 145)) and (v251 == (483 - (397 + 86)))) then
							v113 = v13:GetEnemiesInRange(916 - (423 + 453));
							v111 = v10.BossFightRemains(nil, true);
							v251 = 1 + 0;
						end
						if (((597 + 3928) > (3946 + 573)) and (v251 == (1 + 0))) then
							v112 = v111;
							if (((2839 + 339) > (2162 - (50 + 1140))) and (v112 == (9605 + 1506))) then
								v112 = v10.FightRemains(v113, false);
							end
							break;
						end
					end
				end
				v149 = 3 + 1;
			end
		end
	end
	local function v137()
		local v150 = 0 + 0;
		while true do
			if (((6844 - 2078) == (3449 + 1317)) and (v150 == (596 - (157 + 439)))) then
				v122();
				v114.Bursting:RegisterAuraTracking();
				v150 = 1 - 0;
			end
			if ((v150 == (3 - 2)) or ((8119 - 5374) > (4046 - (782 + 136)))) then
				v22.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(1125 - (112 + 743), v136, v137);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

