local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((11936 - 8563) <= (1713 + 1843)) and not v5) then
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
	local v104 = 11907 - (588 + 208);
	local v105 = 29946 - 18835;
	local v106;
	local v107 = v17.Monk.Mistweaver;
	local v108 = v19.Monk.Mistweaver;
	local v109 = v24.Monk.Mistweaver;
	local v110 = {};
	local v111;
	local v112;
	local v113 = {{v107.LegSweep,"Cast Leg Sweep (Stun)",function()
		return true;
	end},{v107.Paralysis,"Cast Paralysis (Stun)",function()
		return true;
	end}};
	local v114 = v21.Commons.Everyone;
	local v115 = v21.Commons.Monk;
	local function v116()
		if (v107.ImprovedDetox:IsAvailable() or ((3896 - (316 + 289)) < (8586 - 5306))) then
			v114.DispellableDebuffs = v20.MergeTable(v114.DispellableMagicDebuffs, v114.DispellablePoisonDebuffs, v114.DispellableDiseaseDebuffs);
		else
			v114.DispellableDebuffs = v114.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v116();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v117()
		if (((203 + 4183) >= (2326 - (666 + 787))) and v107.DampenHarm:IsCastable() and v12:BuffDown(v107.FortifyingBrew) and (v12:HealthPercentage() <= v41) and v40) then
			if (((1346 - (360 + 65)) <= (1030 + 72)) and v23(v107.DampenHarm, nil)) then
				return "dampen_harm defensives 1";
			end
		end
		if (((4960 - (79 + 175)) >= (1517 - 554)) and v107.FortifyingBrew:IsCastable() and v12:BuffDown(v107.DampenHarmBuff) and (v12:HealthPercentage() <= v39) and v38) then
			if (v23(v107.FortifyingBrew, nil) or ((750 + 210) <= (2684 - 1808))) then
				return "fortifying_brew defensives 2";
			end
		end
		if ((v107.ExpelHarm:IsCastable() and (v12:HealthPercentage() <= v54) and v53 and v12:BuffUp(v107.ChiHarmonyBuff)) or ((3978 - 1912) == (1831 - (503 + 396)))) then
			if (((5006 - (92 + 89)) < (9394 - 4551)) and v23(v107.ExpelHarm, nil)) then
				return "expel_harm defensives 3";
			end
		end
		if ((v108.Healthstone:IsReady() and v83 and (v12:HealthPercentage() <= v84)) or ((1989 + 1888) >= (2686 + 1851))) then
			if (v23(v109.Healthstone) or ((16898 - 12583) < (237 + 1489))) then
				return "healthstone defensive 4";
			end
		end
		if ((v85 and (v12:HealthPercentage() <= v86)) or ((8388 - 4709) < (546 + 79))) then
			local v145 = 0 + 0;
			while true do
				if ((v145 == (0 - 0)) or ((578 + 4047) < (963 - 331))) then
					if ((v87 == "Refreshing Healing Potion") or ((1327 - (485 + 759)) > (4118 - 2338))) then
						if (((1735 - (442 + 747)) <= (2212 - (832 + 303))) and v108.RefreshingHealingPotion:IsReady()) then
							if (v23(v109.RefreshingHealingPotion) or ((1942 - (88 + 858)) > (1311 + 2990))) then
								return "refreshing healing potion defensive 5";
							end
						end
					end
					if (((3369 + 701) > (29 + 658)) and (v87 == "Dreamwalker's Healing Potion")) then
						if (v108.DreamwalkersHealingPotion:IsReady() or ((1445 - (766 + 23)) >= (16439 - 13109))) then
							if (v23(v109.RefreshingHealingPotion) or ((3407 - 915) <= (882 - 547))) then
								return "dreamwalkers healing potion defensive 5";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v118()
		local v131 = 0 - 0;
		while true do
			if (((5395 - (1036 + 37)) >= (1817 + 745)) and (v131 == (1 - 0))) then
				if (v101 or ((2861 + 776) >= (5250 - (641 + 839)))) then
					local v224 = 913 - (910 + 3);
					while true do
						if (((4 - 2) == v224) or ((4063 - (1466 + 218)) > (2104 + 2474))) then
							v28 = v114.HandleCharredTreant(v107.Vivify, v109.VivifyMouseover, 1188 - (556 + 592));
							if (v28 or ((172 + 311) > (1551 - (329 + 479)))) then
								return v28;
							end
							v224 = 857 - (174 + 680);
						end
						if (((8432 - 5978) > (1197 - 619)) and (v224 == (3 + 0))) then
							v28 = v114.HandleCharredTreant(v107.EnvelopingMist, v109.EnvelopingMistMouseover, 779 - (396 + 343));
							if (((83 + 847) < (5935 - (29 + 1448))) and v28) then
								return v28;
							end
							break;
						end
						if (((2051 - (135 + 1254)) <= (3661 - 2689)) and (v224 == (0 - 0))) then
							v28 = v114.HandleCharredTreant(v107.RenewingMist, v109.RenewingMistMouseover, 27 + 13);
							if (((5897 - (389 + 1138)) == (4944 - (102 + 472))) and v28) then
								return v28;
							end
							v224 = 1 + 0;
						end
						if ((v224 == (1 + 0)) or ((4441 + 321) <= (2406 - (320 + 1225)))) then
							v28 = v114.HandleCharredTreant(v107.SoothingMist, v109.SoothingMistMouseover, 71 - 31);
							if (v28 or ((864 + 548) == (5728 - (157 + 1307)))) then
								return v28;
							end
							v224 = 1861 - (821 + 1038);
						end
					end
				end
				if (v102 or ((7904 - 4736) < (236 + 1917))) then
					local v225 = 0 - 0;
					while true do
						if (((1 + 1) == v225) or ((12333 - 7357) < (2358 - (834 + 192)))) then
							v28 = v114.HandleCharredBrambles(v107.Vivify, v109.VivifyMouseover, 3 + 37);
							if (((1188 + 3440) == (100 + 4528)) and v28) then
								return v28;
							end
							v225 = 4 - 1;
						end
						if (((307 - (300 + 4)) == v225) or ((15 + 39) == (1034 - 639))) then
							v28 = v114.HandleCharredBrambles(v107.EnvelopingMist, v109.EnvelopingMistMouseover, 402 - (112 + 250));
							if (((33 + 49) == (205 - 123)) and v28) then
								return v28;
							end
							break;
						end
						if ((v225 == (1 + 0)) or ((301 + 280) < (211 + 71))) then
							v28 = v114.HandleCharredBrambles(v107.SoothingMist, v109.SoothingMistMouseover, 20 + 20);
							if (v28 or ((3424 + 1185) < (3909 - (1001 + 413)))) then
								return v28;
							end
							v225 = 4 - 2;
						end
						if (((2034 - (244 + 638)) == (1845 - (627 + 66))) and (v225 == (0 - 0))) then
							v28 = v114.HandleCharredBrambles(v107.RenewingMist, v109.RenewingMistMouseover, 642 - (512 + 90));
							if (((3802 - (1665 + 241)) <= (4139 - (373 + 344))) and v28) then
								return v28;
							end
							v225 = 1 + 0;
						end
					end
				end
				v131 = 1 + 1;
			end
			if ((v131 == (0 - 0)) or ((1675 - 685) > (2719 - (35 + 1064)))) then
				if (v100 or ((639 + 238) > (10045 - 5350))) then
					v28 = v114.HandleIncorporeal(v107.Paralysis, v109.ParalysisMouseover, 1 + 29, true);
					if (((3927 - (298 + 938)) >= (3110 - (233 + 1026))) and v28) then
						return v28;
					end
				end
				if (v99 or ((4651 - (636 + 1030)) >= (2483 + 2373))) then
					local v226 = 0 + 0;
					while true do
						if (((1271 + 3005) >= (81 + 1114)) and (v226 == (221 - (55 + 166)))) then
							v28 = v114.HandleAfflicted(v107.Detox, v109.DetoxMouseover, 6 + 24);
							if (((326 + 2906) <= (17911 - 13221)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				v131 = 298 - (36 + 261);
			end
			if ((v131 == (3 - 1)) or ((2264 - (34 + 1334)) >= (1210 + 1936))) then
				if (((2379 + 682) >= (4241 - (1035 + 248))) and v103) then
					local v227 = 21 - (20 + 1);
					while true do
						if (((1661 + 1526) >= (963 - (134 + 185))) and ((1134 - (549 + 584)) == v227)) then
							v28 = v114.HandleFyrakkNPC(v107.SoothingMist, v109.SoothingMistMouseover, 725 - (314 + 371));
							if (((2210 - 1566) <= (1672 - (478 + 490))) and v28) then
								return v28;
							end
							v227 = 2 + 0;
						end
						if (((2130 - (786 + 386)) > (3067 - 2120)) and (v227 == (1381 - (1055 + 324)))) then
							v28 = v114.HandleFyrakkNPC(v107.Vivify, v109.VivifyMouseover, 1380 - (1093 + 247));
							if (((3992 + 500) >= (280 + 2374)) and v28) then
								return v28;
							end
							v227 = 11 - 8;
						end
						if (((11681 - 8239) >= (4276 - 2773)) and (v227 == (0 - 0))) then
							v28 = v114.HandleFyrakkNPC(v107.RenewingMist, v109.RenewingMistMouseover, 15 + 25);
							if (v28 or ((12212 - 9042) <= (5046 - 3582))) then
								return v28;
							end
							v227 = 1 + 0;
						end
						if ((v227 == (7 - 4)) or ((5485 - (364 + 324)) == (12028 - 7640))) then
							v28 = v114.HandleFyrakkNPC(v107.EnvelopingMist, v109.EnvelopingMistMouseover, 95 - 55);
							if (((183 + 368) <= (2849 - 2168)) and v28) then
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
	local function v119()
		local v132 = 0 - 0;
		while true do
			if (((9952 - 6675) > (1675 - (1249 + 19))) and (v132 == (0 + 0))) then
				if (((18275 - 13580) >= (2501 - (686 + 400))) and v107.ChiBurst:IsCastable() and v49) then
					if (v23(v107.ChiBurst, not v14:IsInRange(32 + 8)) or ((3441 - (73 + 156)) <= (5 + 939))) then
						return "chi_burst precombat 4";
					end
				end
				if ((v107.SpinningCraneKick:IsCastable() and v45 and (v112 >= (813 - (721 + 90)))) or ((35 + 3061) <= (5837 - 4039))) then
					if (((4007 - (224 + 246)) == (5729 - 2192)) and v23(v107.SpinningCraneKick, not v14:IsInMeleeRange(14 - 6))) then
						return "spinning_crane_kick precombat 6";
					end
				end
				v132 = 1 + 0;
			end
			if (((92 + 3745) >= (1154 + 416)) and (v132 == (1 - 0))) then
				if ((v107.TigerPalm:IsCastable() and v47) or ((9817 - 6867) == (4325 - (203 + 310)))) then
					if (((6716 - (1238 + 755)) >= (162 + 2156)) and v23(v107.TigerPalm, not v14:IsInMeleeRange(1539 - (709 + 825)))) then
						return "tiger_palm precombat 8";
					end
				end
				break;
			end
		end
	end
	local function v120()
		local v133 = 0 - 0;
		while true do
			if ((v133 == (3 - 0)) or ((2891 - (196 + 668)) > (11260 - 8408))) then
				if ((v107.TigerPalm:IsCastable() and v107.TeachingsoftheMonastery:IsAvailable() and (v107.BlackoutKick:CooldownRemains() > (0 - 0)) and v47 and (v112 >= (836 - (171 + 662)))) or ((1229 - (4 + 89)) > (15130 - 10813))) then
					if (((1729 + 3019) == (20854 - 16106)) and v23(v107.TigerPalm, not v14:IsInMeleeRange(2 + 3))) then
						return "tiger_palm aoe 7";
					end
				end
				if (((5222 - (35 + 1451)) <= (6193 - (28 + 1425))) and v107.SpinningCraneKick:IsCastable() and v45) then
					if (v23(v107.SpinningCraneKick, not v14:IsInMeleeRange(2001 - (941 + 1052))) or ((3251 + 139) <= (4574 - (822 + 692)))) then
						return "spinning_crane_kick aoe 8";
					end
				end
				break;
			end
			if ((v133 == (2 - 0)) or ((471 + 528) > (2990 - (45 + 252)))) then
				if (((459 + 4) < (207 + 394)) and v107.SpinningCraneKick:IsCastable() and v45 and v14:DebuffDown(v107.MysticTouchDebuff) and v107.MysticTouch:IsAvailable()) then
					if (v23(v107.SpinningCraneKick, not v14:IsInMeleeRange(19 - 11)) or ((2616 - (114 + 319)) < (986 - 299))) then
						return "spinning_crane_kick aoe 5";
					end
				end
				if (((5828 - 1279) == (2900 + 1649)) and v107.BlackoutKick:IsCastable() and v107.AncientConcordance:IsAvailable() and v12:BuffUp(v107.FaelineStomp) and v44 and (v112 >= (4 - 1))) then
					if (((9788 - 5116) == (6635 - (556 + 1407))) and v23(v107.BlackoutKick, not v14:IsInMeleeRange(1211 - (741 + 465)))) then
						return "blackout_kick aoe 6";
					end
				end
				v133 = 468 - (170 + 295);
			end
			if ((v133 == (1 + 0)) or ((3370 + 298) < (972 - 577))) then
				if ((v107.FaelineStomp:IsReady() and v48) or ((3454 + 712) == (292 + 163))) then
					if (v23(v107.FaelineStomp, nil) or ((2520 + 1929) == (3893 - (957 + 273)))) then
						return "FaelineStomp aoe3";
					end
				end
				if ((v107.ChiBurst:IsCastable() and v49) or ((1144 + 3133) < (1197 + 1792))) then
					if (v23(v107.ChiBurst, not v14:IsInRange(152 - 112)) or ((2292 - 1422) >= (12672 - 8523))) then
						return "chi_burst aoe 4";
					end
				end
				v133 = 9 - 7;
			end
			if (((3992 - (389 + 1391)) < (1998 + 1185)) and (v133 == (0 + 0))) then
				if (((10576 - 5930) > (3943 - (783 + 168))) and v107.SummonWhiteTigerStatue:IsReady() and (v112 >= (9 - 6)) and v43) then
					if (((1411 + 23) < (3417 - (309 + 2))) and (v42 == "Player")) then
						if (((2413 - 1627) < (4235 - (1090 + 122))) and v23(v109.SummonWhiteTigerStatuePlayer, not v14:IsInRange(13 + 27))) then
							return "summon_white_tiger_statue aoe player 1";
						end
					elseif ((v42 == "Cursor") or ((8201 - 5759) < (51 + 23))) then
						if (((5653 - (628 + 490)) == (814 + 3721)) and v23(v109.SummonWhiteTigerStatueCursor, not v14:IsInRange(99 - 59))) then
							return "summon_white_tiger_statue aoe cursor 1";
						end
					elseif (((v42 == "Friendly under Cursor") and v15:Exists() and not v12:CanAttack(v15)) or ((13751 - 10742) <= (2879 - (431 + 343)))) then
						if (((3695 - 1865) < (10613 - 6944)) and v23(v109.SummonWhiteTigerStatueCursor, not v14:IsInRange(32 + 8))) then
							return "summon_white_tiger_statue aoe cursor friendly 1";
						end
					elseif (((v42 == "Enemy under Cursor") and v15:Exists() and v12:CanAttack(v15)) or ((183 + 1247) >= (5307 - (556 + 1139)))) then
						if (((2698 - (6 + 9)) >= (451 + 2009)) and v23(v109.SummonWhiteTigerStatueCursor, not v14:IsInRange(21 + 19))) then
							return "summon_white_tiger_statue aoe cursor enemy 1";
						end
					elseif ((v42 == "Confirmation") or ((1973 - (28 + 141)) >= (1269 + 2006))) then
						if (v23(v109.SummonWhiteTigerStatue, not v14:IsInRange(49 - 9)) or ((1004 + 413) > (4946 - (486 + 831)))) then
							return "summon_white_tiger_statue aoe confirmation 1";
						end
					end
				end
				if (((12477 - 7682) > (1415 - 1013)) and v107.TouchofDeath:IsCastable() and v50) then
					if (((910 + 3903) > (11272 - 7707)) and v23(v107.TouchofDeath, not v14:IsInMeleeRange(1268 - (668 + 595)))) then
						return "touch_of_death aoe 2";
					end
				end
				v133 = 1 + 0;
			end
		end
	end
	local function v121()
		local v134 = 0 + 0;
		while true do
			if (((10668 - 6756) == (4202 - (23 + 267))) and (v134 == (1944 - (1129 + 815)))) then
				if (((3208 - (371 + 16)) <= (6574 - (1326 + 424))) and v107.TouchofDeath:IsCastable() and v50) then
					if (((3291 - 1553) <= (8021 - 5826)) and v23(v107.TouchofDeath, not v14:IsInMeleeRange(123 - (88 + 30)))) then
						return "touch_of_death st 1";
					end
				end
				if (((812 - (720 + 51)) <= (6713 - 3695)) and v107.FaelineStomp:IsReady() and v48) then
					if (((3921 - (421 + 1355)) <= (6770 - 2666)) and v23(v107.FaelineStomp, nil)) then
						return "FaelineStomp st 2";
					end
				end
				v134 = 1 + 0;
			end
			if (((3772 - (286 + 797)) < (17711 - 12866)) and (v134 == (2 - 0))) then
				if ((v107.BlackoutKick:IsCastable() and (v12:BuffStack(v107.TeachingsoftheMonasteryBuff) == (442 - (397 + 42))) and (v107.RisingSunKick:CooldownRemains() > v12:GCD()) and v44) or ((726 + 1596) > (3422 - (24 + 776)))) then
					if (v23(v107.BlackoutKick, not v14:IsInMeleeRange(7 - 2)) or ((5319 - (222 + 563)) == (4586 - 2504))) then
						return "blackout_kick st 5";
					end
				end
				if ((v107.TigerPalm:IsCastable() and ((v12:BuffStack(v107.TeachingsoftheMonasteryBuff) < (3 + 0)) or (v12:BuffRemains(v107.TeachingsoftheMonasteryBuff) < (192 - (23 + 167)))) and v47) or ((3369 - (690 + 1108)) > (674 + 1193))) then
					if (v23(v107.TigerPalm, not v14:IsInMeleeRange(5 + 0)) or ((3502 - (40 + 808)) >= (494 + 2502))) then
						return "tiger_palm st 6";
					end
				end
				break;
			end
			if (((15211 - 11233) > (2011 + 93)) and (v134 == (1 + 0))) then
				if (((1643 + 1352) > (2112 - (47 + 524))) and v107.RisingSunKick:IsReady() and v46) then
					if (((2109 + 1140) > (2604 - 1651)) and v23(v107.RisingSunKick, not v14:IsInMeleeRange(7 - 2))) then
						return "rising_sun_kick st 3";
					end
				end
				if ((v107.ChiBurst:IsCastable() and v49) or ((7464 - 4191) > (6299 - (1165 + 561)))) then
					if (v23(v107.ChiBurst, not v14:IsInRange(2 + 38)) or ((9759 - 6608) < (490 + 794))) then
						return "chi_burst st 4";
					end
				end
				v134 = 481 - (341 + 138);
			end
		end
	end
	local function v122()
		if ((v51 and v107.RenewingMist:IsReady() and v16:BuffDown(v107.RenewingMistBuff) and (v107.RenewingMist:ChargesFractional() >= (1.8 + 0))) or ((3817 - 1967) == (1855 - (89 + 237)))) then
			if (((2641 - 1820) < (4469 - 2346)) and (v16:HealthPercentage() <= v52)) then
				if (((1783 - (581 + 300)) < (3545 - (855 + 365))) and v23(v109.RenewingMistFocus, not v16:IsSpellInRange(v107.RenewingMist))) then
					return "RenewingMist healing st";
				end
			end
		end
		if (((2037 - 1179) <= (968 + 1994)) and v46 and v107.RisingSunKick:IsReady() and (v114.FriendlyUnitsWithBuffCount(v107.RenewingMistBuff, false, false, 1260 - (1030 + 205)) > (1 + 0))) then
			if (v23(v107.RisingSunKick, not v14:IsInMeleeRange(5 + 0)) or ((4232 - (156 + 130)) < (2926 - 1638))) then
				return "RisingSunKick healing st";
			end
		end
		if ((v51 and v107.RenewingMist:IsReady() and v16:BuffDown(v107.RenewingMistBuff)) or ((5463 - 2221) == (1160 - 593))) then
			if ((v16:HealthPercentage() <= v52) or ((224 + 623) >= (737 + 526))) then
				if (v23(v109.RenewingMistFocus, not v16:IsSpellInRange(v107.RenewingMist)) or ((2322 - (10 + 59)) == (524 + 1327))) then
					return "RenewingMist healing st";
				end
			end
		end
		if ((v55 and v107.Vivify:IsReady() and v12:BuffUp(v107.VivaciousVivificationBuff)) or ((10278 - 8191) > (3535 - (671 + 492)))) then
			if ((v16:HealthPercentage() <= v56) or ((3539 + 906) < (5364 - (369 + 846)))) then
				if (v23(v109.VivifyFocus, not v16:IsSpellInRange(v107.Vivify)) or ((482 + 1336) == (73 + 12))) then
					return "Vivify instant healing st";
				end
			end
		end
		if (((2575 - (1036 + 909)) < (1692 + 435)) and v59 and v107.SoothingMist:IsReady() and v16:BuffDown(v107.SoothingMist)) then
			if ((v16:HealthPercentage() <= v60) or ((3253 - 1315) == (2717 - (11 + 192)))) then
				if (((2151 + 2104) >= (230 - (135 + 40))) and v23(v109.SoothingMistFocus, not v16:IsSpellInRange(v107.SoothingMist))) then
					return "SoothingMist healing st";
				end
			end
		end
	end
	local function v123()
		local v135 = 0 - 0;
		while true do
			if (((1808 + 1191) > (2546 - 1390)) and (v135 == (1 - 0))) then
				if (((2526 - (50 + 126)) > (3216 - 2061)) and v61 and v107.EssenceFont:IsReady() and v107.AncientTeachings:IsAvailable() and v12:BuffDown(v107.EssenceFontBuff)) then
					if (((892 + 3137) <= (6266 - (1233 + 180))) and v23(v107.EssenceFont, nil)) then
						return "EssenceFont healing aoe";
					end
				end
				if ((v66 and v107.ZenPulse:IsReady() and v114.AreUnitsBelowHealthPercentage(v68, v67)) or ((1485 - (522 + 447)) > (4855 - (107 + 1314)))) then
					if (((1878 + 2168) >= (9241 - 6208)) and v23(v109.ZenPulseFocus, not v16:IsSpellInRange(v107.ZenPulse))) then
						return "ZenPulse healing aoe";
					end
				end
				v135 = 1 + 1;
			end
			if (((0 - 0) == v135) or ((10757 - 8038) <= (3357 - (716 + 1194)))) then
				if ((v46 and v107.RisingSunKick:IsReady() and (v114.FriendlyUnitsWithBuffCount(v107.RenewingMistBuff, false, false, 1 + 24) > (1 + 0))) or ((4637 - (74 + 429)) < (7573 - 3647))) then
					if (v23(v107.RisingSunKick, not v14:IsInMeleeRange(3 + 2)) or ((375 - 211) >= (1971 + 814))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (v114.AreUnitsBelowHealthPercentage(v63, v62) or ((1618 - 1093) == (5214 - 3105))) then
					if (((466 - (279 + 154)) == (811 - (454 + 324))) and v35 and (v12:BuffStack(v107.ManaTeaCharges) > v36) and v107.EssenceFont:IsReady() and v107.ManaTea:IsCastable()) then
						if (((2403 + 651) <= (4032 - (12 + 5))) and v23(v107.ManaTea, nil)) then
							return "EssenceFont healing aoe";
						end
					end
					if (((1009 + 862) < (8617 - 5235)) and v37 and v107.ThunderFocusTea:IsReady() and (v107.EssenceFont:CooldownRemains() < v12:GCD())) then
						if (((478 + 815) <= (3259 - (277 + 816))) and v23(v107.ThunderFocusTea, nil)) then
							return "ThunderFocusTea healing aoe";
						end
					end
					if ((v61 and v107.EssenceFont:IsReady() and (v12:BuffUp(v107.ThunderFocusTea) or (v107.ThunderFocusTea:CooldownRemains() > (34 - 26)))) or ((3762 - (1058 + 125)) < (24 + 99))) then
						if (v23(v107.EssenceFont, nil) or ((1821 - (815 + 160)) >= (10160 - 7792))) then
							return "EssenceFont healing aoe";
						end
					end
				end
				v135 = 2 - 1;
			end
			if ((v135 == (1 + 1)) or ((11727 - 7715) <= (5256 - (41 + 1857)))) then
				if (((3387 - (1222 + 671)) <= (7766 - 4761)) and v69 and v107.SheilunsGift:IsReady() and v107.SheilunsGift:IsCastable() and v114.AreUnitsBelowHealthPercentage(v71, v70)) then
					if (v23(v107.SheilunsGift, nil) or ((4471 - 1360) == (3316 - (229 + 953)))) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v136 = 1774 - (1111 + 663);
		while true do
			if (((3934 - (874 + 705)) == (330 + 2025)) and (v136 == (0 + 0))) then
				if ((v57 and v107.EnvelopingMist:IsReady() and (v114.FriendlyUnitsWithBuffCount(v107.EnvelopingMist, false, false, 51 - 26) < (1 + 2))) or ((1267 - (642 + 37)) <= (99 + 333))) then
					local v228 = 0 + 0;
					while true do
						if (((12044 - 7247) >= (4349 - (233 + 221))) and ((0 - 0) == v228)) then
							v28 = v114.FocusUnitRefreshableBuff(v107.EnvelopingMist, 2 + 0, 1581 - (718 + 823), nil, false, 16 + 9);
							if (((4382 - (266 + 539)) == (10127 - 6550)) and v28) then
								return v28;
							end
							v228 = 1226 - (636 + 589);
						end
						if (((9005 - 5211) > (7616 - 3923)) and (v228 == (1 + 0))) then
							if (v23(v109.EnvelopingMistFocus, not v16:IsSpellInRange(v107.EnvelopingMist)) or ((464 + 811) == (5115 - (657 + 358)))) then
								return "Enveloping Mist YuLon";
							end
							break;
						end
					end
				end
				if ((v46 and v107.RisingSunKick:IsReady() and (v114.FriendlyUnitsWithBuffCount(v107.EnvelopingMist, false, false, 66 - 41) > (4 - 2))) or ((2778 - (1151 + 36)) >= (3458 + 122))) then
					if (((259 + 724) <= (5399 - 3591)) and v23(v107.RisingSunKick, not v14:IsInMeleeRange(1837 - (1552 + 280)))) then
						return "Rising Sun Kick YuLon";
					end
				end
				v136 = 835 - (64 + 770);
			end
			if ((v136 == (1 + 0)) or ((4880 - 2730) <= (213 + 984))) then
				if (((5012 - (157 + 1086)) >= (2347 - 1174)) and v59 and v107.SoothingMist:IsReady() and v16:BuffUp(v107.ChiHarmonyBuff) and v16:BuffDown(v107.SoothingMist)) then
					if (((6503 - 5018) == (2277 - 792)) and v23(v109.SoothingMistFocus, not v16:IsSpellInRange(v107.SoothingMist))) then
						return "Soothing Mist YuLon";
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v137 = 0 - 0;
		while true do
			if (((821 - (599 + 220)) == v137) or ((6601 - 3286) <= (4713 - (1813 + 118)))) then
				if ((v61 and v107.EssenceFont:IsReady() and v107.AncientTeachings:IsAvailable() and v12:BuffDown(v107.AncientTeachings)) or ((641 + 235) >= (4181 - (841 + 376)))) then
					if (v23(v107.EssenceFont, nil) or ((3127 - 895) > (581 + 1916))) then
						return "Essence Font ChiJi";
					end
				end
				break;
			end
			if (((0 - 0) == v137) or ((2969 - (464 + 395)) <= (851 - 519))) then
				if (((1771 + 1915) > (4009 - (467 + 370))) and v44 and v107.BlackoutKick:IsReady() and (v12:BuffStack(v107.TeachingsoftheMonastery) >= (5 - 2))) then
					if (v23(v107.BlackoutKick, not v14:IsInMeleeRange(4 + 1)) or ((15336 - 10862) < (128 + 692))) then
						return "Blackout Kick ChiJi";
					end
				end
				if (((9954 - 5675) >= (3402 - (150 + 370))) and v57 and v107.EnvelopingMist:IsReady() and (v12:BuffStack(v107.InvokeChiJiBuff) == (1285 - (74 + 1208)))) then
					if ((v16:HealthPercentage() <= v58) or ((4990 - 2961) >= (16698 - 13177))) then
						if (v23(v109.EnvelopingMistFocus, not v16:IsSpellInRange(v107.EnvelopingMist)) or ((1450 + 587) >= (5032 - (14 + 376)))) then
							return "Enveloping Mist 3 Stacks ChiJi";
						end
					end
				end
				v137 = 1 - 0;
			end
			if (((1113 + 607) < (3917 + 541)) and ((1 + 0) == v137)) then
				if ((v46 and v107.RisingSunKick:IsReady()) or ((1277 - 841) > (2273 + 748))) then
					if (((791 - (23 + 55)) <= (2006 - 1159)) and v23(v107.RisingSunKick, not v14:IsInMeleeRange(4 + 1))) then
						return "Rising Sun Kick ChiJi";
					end
				end
				if (((1935 + 219) <= (6249 - 2218)) and v57 and v107.EnvelopingMist:IsReady() and (v12:BuffStack(v107.InvokeChiJiBuff) >= (1 + 1))) then
					if (((5516 - (652 + 249)) == (12350 - 7735)) and (v16:HealthPercentage() <= v58)) then
						if (v23(v109.EnvelopingMistFocus, not v16:IsSpellInRange(v107.EnvelopingMist)) or ((5658 - (708 + 1160)) == (1357 - 857))) then
							return "Enveloping Mist 2 Stacks ChiJi";
						end
					end
				end
				v137 = 3 - 1;
			end
		end
	end
	local function v126()
		if (((116 - (10 + 17)) < (50 + 171)) and v78 and v107.LifeCocoon:IsReady() and (v16:HealthPercentage() <= v79)) then
			if (((3786 - (1400 + 332)) >= (2725 - 1304)) and v23(v109.LifeCocoonFocus, not v16:IsSpellInRange(v107.LifeCocoon))) then
				return "Life Cocoon CD";
			end
		end
		if (((2600 - (242 + 1666)) < (1309 + 1749)) and v80 and v107.Revival:IsReady() and v107.Revival:IsAvailable() and v114.AreUnitsBelowHealthPercentage(v82, v81)) then
			if (v23(v107.Revival, nil) or ((1193 + 2061) == (1411 + 244))) then
				return "Revival CD";
			end
		end
		if ((v80 and v107.Restoral:IsReady() and v107.Restoral:IsAvailable() and v114.AreUnitsBelowHealthPercentage(v82, v81)) or ((2236 - (850 + 90)) == (8599 - 3689))) then
			if (((4758 - (360 + 1030)) == (2981 + 387)) and v23(v107.Restoral, nil)) then
				return "Restoral CD";
			end
		end
		if (((7459 - 4816) < (5248 - 1433)) and v72 and v107.InvokeYulonTheJadeSerpent:IsAvailable() and v107.InvokeYulonTheJadeSerpent:IsReady() and v114.AreUnitsBelowHealthPercentage(v74, v73)) then
			local v146 = 1661 - (909 + 752);
			while true do
				if (((3136 - (109 + 1114)) > (902 - 409)) and (v146 == (0 + 0))) then
					if (((4997 - (6 + 236)) > (2160 + 1268)) and v51 and v107.RenewingMist:IsReady() and (v107.RenewingMist:ChargesFractional() >= (1 + 0))) then
						local v232 = 0 - 0;
						while true do
							if (((2412 - 1031) <= (3502 - (1076 + 57))) and (v232 == (1 + 0))) then
								if (v23(v109.RenewingMistFocus, not v16:IsSpellInRange(v107.RenewingMist)) or ((5532 - (579 + 110)) == (323 + 3761))) then
									return "Renewing Mist YuLon prep";
								end
								break;
							end
							if (((4129 + 540) > (193 + 170)) and (v232 == (407 - (174 + 233)))) then
								v28 = v114.FocusUnitRefreshableBuff(v107.RenewingMistBuff, 16 - 10, 70 - 30, nil, false, 12 + 13);
								if (v28 or ((3051 - (663 + 511)) >= (2800 + 338))) then
									return v28;
								end
								v232 = 1 + 0;
							end
						end
					end
					if (((14619 - 9877) >= (2196 + 1430)) and v35 and v107.ManaTea:IsCastable() and (v12:BuffStack(v107.ManaTeaCharges) >= (6 - 3)) and v12:BuffDown(v107.ManaTeaBuff)) then
						if (v23(v107.ManaTea, nil) or ((10990 - 6450) == (438 + 478))) then
							return "ManaTea YuLon prep";
						end
					end
					v146 = 1 - 0;
				end
				if ((v146 == (1 + 0)) or ((106 + 1050) > (5067 - (478 + 244)))) then
					if (((2754 - (440 + 77)) < (1932 + 2317)) and v69 and v107.SheilunsGift:IsReady() and (v107.SheilunsGift:TimeSinceLastCast() > (73 - 53))) then
						if (v23(v107.SheilunsGift, nil) or ((4239 - (655 + 901)) < (5 + 18))) then
							return "Sheilun's Gift YuLon prep";
						end
					end
					if (((534 + 163) <= (558 + 268)) and v107.InvokeYulonTheJadeSerpent:IsReady() and (v107.RenewingMist:ChargesFractional() < (3 - 2)) and v12:BuffUp(v107.ManaTeaBuff) and (v107.SheilunsGift:TimeSinceLastCast() < ((1449 - (695 + 750)) * v12:GCD()))) then
						if (((3773 - 2668) <= (1814 - 638)) and v23(v107.InvokeYulonTheJadeSerpent, nil)) then
							return "Invoke Yu'lon GO";
						end
					end
					break;
				end
			end
		end
		if (((13589 - 10210) <= (4163 - (285 + 66))) and (v107.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (58 - 33))) then
			v28 = v124();
			if (v28 or ((2098 - (682 + 628)) >= (261 + 1355))) then
				return v28;
			end
		end
		if (((2153 - (176 + 123)) <= (1414 + 1965)) and v75 and v107.InvokeChiJiTheRedCrane:IsReady() and v107.InvokeChiJiTheRedCrane:IsAvailable() and v114.AreUnitsBelowHealthPercentage(v77, v76)) then
			local v147 = 0 + 0;
			while true do
				if (((4818 - (239 + 30)) == (1237 + 3312)) and (v147 == (1 + 0))) then
					if ((v107.InvokeChiJiTheRedCrane:IsReady() and (v107.RenewingMist:ChargesFractional() < (1 - 0)) and v12:BuffUp(v107.AncientTeachings) and (v12:BuffStack(v107.TeachingsoftheMonastery) == (8 - 5)) and (v107.SheilunsGift:TimeSinceLastCast() < ((319 - (306 + 9)) * v12:GCD()))) or ((10545 - 7523) >= (526 + 2498))) then
						if (((2958 + 1862) > (1058 + 1140)) and v23(v107.InvokeChiJiTheRedCrane, nil)) then
							return "Invoke Chi'ji GO";
						end
					end
					break;
				end
				if ((v147 == (0 - 0)) or ((2436 - (1140 + 235)) >= (3113 + 1778))) then
					if (((1251 + 113) <= (1148 + 3325)) and v51 and v107.RenewingMist:IsReady() and (v107.RenewingMist:ChargesFractional() >= (53 - (33 + 19)))) then
						v28 = v114.FocusUnitRefreshableBuff(v107.RenewingMistBuff, 3 + 3, 119 - 79, nil, false, 12 + 13);
						if (v28 or ((7049 - 3454) <= (3 + 0))) then
							return v28;
						end
						if (v23(v109.RenewingMistFocus, not v16:IsSpellInRange(v107.RenewingMist)) or ((5361 - (586 + 103)) == (351 + 3501))) then
							return "Renewing Mist ChiJi prep";
						end
					end
					if (((4799 - 3240) == (3047 - (1309 + 179))) and v69 and v107.SheilunsGift:IsReady() and (v107.SheilunsGift:TimeSinceLastCast() > (36 - 16))) then
						if (v23(v107.SheilunsGift, nil) or ((763 + 989) <= (2116 - 1328))) then
							return "Sheilun's Gift ChiJi prep";
						end
					end
					v147 = 1 + 0;
				end
			end
		end
		if ((v107.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (53 - 28)) or ((7784 - 3877) == (786 - (295 + 314)))) then
			local v148 = 0 - 0;
			while true do
				if (((5432 - (1300 + 662)) > (1742 - 1187)) and (v148 == (1755 - (1178 + 577)))) then
					v28 = v125();
					if (v28 or ((505 + 467) == (1906 - 1261))) then
						return v28;
					end
					break;
				end
			end
		end
	end
	local function v127()
		local v138 = 1405 - (851 + 554);
		while true do
			if (((2814 + 368) >= (5865 - 3750)) and (v138 == (3 - 1))) then
				v43 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
				v44 = EpicSettings.Settings['UseBlackoutKick'];
				v45 = EpicSettings.Settings['UseSpinningCraneKick'];
				v46 = EpicSettings.Settings['UseRisingSunKick'];
				v138 = 305 - (115 + 187);
			end
			if (((2982 + 911) < (4193 + 236)) and (v138 == (27 - 20))) then
				v62 = EpicSettings.Settings['EssenceFontGroup'];
				v65 = EpicSettings.Settings['UseJadeSerpent'];
				v64 = EpicSettings.Settings['JadeSerpentUsage'];
				v66 = EpicSettings.Settings['UseZenPulse'];
				v138 = 1169 - (160 + 1001);
			end
			if (((0 + 0) == v138) or ((1979 + 888) < (3899 - 1994))) then
				v35 = EpicSettings.Settings['UseManaTea'];
				v36 = EpicSettings.Settings['ManaTeaStacks'];
				v37 = EpicSettings.Settings['UseThunderFocusTea'];
				v38 = EpicSettings.Settings['UseFortifyingBrew'];
				v138 = 359 - (237 + 121);
			end
			if ((v138 == (901 - (525 + 372))) or ((3404 - 1608) >= (13309 - 9258))) then
				v51 = EpicSettings.Settings['UseRenewingMist'];
				v52 = EpicSettings.Settings['RenewingMistHP'];
				v53 = EpicSettings.Settings['UseExpelHarm'];
				v54 = EpicSettings.Settings['ExpelHarmHP'];
				v138 = 147 - (96 + 46);
			end
			if (((2396 - (643 + 134)) <= (1356 + 2400)) and (v138 == (21 - 12))) then
				v70 = EpicSettings.Settings['SheilunsGiftGroup'];
				break;
			end
			if (((2242 - 1638) == (580 + 24)) and (v138 == (15 - 7))) then
				v68 = EpicSettings.Settings['ZenPulseHP'];
				v67 = EpicSettings.Settings['ZenPulseGroup'];
				v69 = EpicSettings.Settings['UseSheilunsGift'];
				v71 = EpicSettings.Settings['SheilunsGiftHP'];
				v138 = 17 - 8;
			end
			if ((v138 == (720 - (316 + 403))) or ((2981 + 1503) == (2474 - 1574))) then
				v39 = EpicSettings.Settings['FortifyingBrewHP'];
				v40 = EpicSettings.Settings['UseDampenHarm'];
				v41 = EpicSettings.Settings['DampenHarmHP'];
				v42 = EpicSettings.Settings['WhiteTigerUsage'];
				v138 = 1 + 1;
			end
			if ((v138 == (7 - 4)) or ((3160 + 1299) <= (359 + 754))) then
				v47 = EpicSettings.Settings['UseTigerPalm'];
				v48 = EpicSettings.Settings['UseFaelineStomp'];
				v49 = EpicSettings.Settings['UseChiBurst'];
				v50 = EpicSettings.Settings['UseTouchOfDeath'];
				v138 = 13 - 9;
			end
			if (((17345 - 13713) > (7058 - 3660)) and (v138 == (1 + 5))) then
				v59 = EpicSettings.Settings['UseSoothingMist'];
				v60 = EpicSettings.Settings['SoothingMistHP'];
				v61 = EpicSettings.Settings['UseEssenceFont'];
				v63 = EpicSettings.Settings['EssenceFontHP'];
				v138 = 13 - 6;
			end
			if (((200 + 3882) <= (14466 - 9549)) and (v138 == (22 - (12 + 5)))) then
				v55 = EpicSettings.Settings['UseVivify'];
				v56 = EpicSettings.Settings['VivifyHP'];
				v57 = EpicSettings.Settings['UseEnvelopingMist'];
				v58 = EpicSettings.Settings['EnvelopingMistHP'];
				v138 = 23 - 17;
			end
		end
	end
	local function v128()
		local v139 = 0 - 0;
		while true do
			if (((10270 - 5438) >= (3436 - 2050)) and ((2 + 3) == v139)) then
				v82 = EpicSettings.Settings['RevivalHP'];
				v81 = EpicSettings.Settings['RevivalGroup'];
				break;
			end
			if (((2110 - (1656 + 317)) == (123 + 14)) and (v139 == (0 + 0))) then
				v95 = EpicSettings.Settings['racialsWithCD'];
				v94 = EpicSettings.Settings['useRacials'];
				v97 = EpicSettings.Settings['trinketsWithCD'];
				v96 = EpicSettings.Settings['useTrinkets'];
				v98 = EpicSettings.Settings['fightRemainsCheck'];
				v88 = EpicSettings.Settings['dispelDebuffs'];
				v139 = 2 - 1;
			end
			if ((v139 == (19 - 15)) or ((1924 - (5 + 349)) >= (20576 - 16244))) then
				v75 = EpicSettings.Settings['UseInvokeChiJi'];
				v77 = EpicSettings.Settings['InvokeChiJiHP'];
				v76 = EpicSettings.Settings['InvokeChiJiGroup'];
				v78 = EpicSettings.Settings['UseLifeCocoon'];
				v79 = EpicSettings.Settings['LifeCocoonHP'];
				v80 = EpicSettings.Settings['UseRevival'];
				v139 = 1276 - (266 + 1005);
			end
			if (((2 + 1) == v139) or ((13866 - 9802) <= (2394 - 575))) then
				v102 = EpicSettings.Settings['HandleCharredBrambles'];
				v101 = EpicSettings.Settings['HandleCharredTreant'];
				v103 = EpicSettings.Settings['HandleFyrakkNPC'];
				v72 = EpicSettings.Settings['UseInvokeYulon'];
				v74 = EpicSettings.Settings['InvokeYulonHP'];
				v73 = EpicSettings.Settings['InvokeYulonGroup'];
				v139 = 1700 - (561 + 1135);
			end
			if ((v139 == (2 - 0)) or ((16389 - 11403) < (2640 - (507 + 559)))) then
				v89 = EpicSettings.Settings['InterruptWithStun'];
				v90 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v92 = EpicSettings.Settings['useSpearHandStrike'];
				v93 = EpicSettings.Settings['useLegSweep'];
				v99 = EpicSettings.Settings['handleAfflicted'];
				v100 = EpicSettings.Settings['HandleIncorporeal'];
				v139 = 7 - 4;
			end
			if (((13688 - 9262) > (560 - (212 + 176))) and (v139 == (906 - (250 + 655)))) then
				v85 = EpicSettings.Settings['useHealingPotion'];
				v86 = EpicSettings.Settings['healingPotionHP'];
				v87 = EpicSettings.Settings['HealingPotionName'];
				v83 = EpicSettings.Settings['useHealthstone'];
				v84 = EpicSettings.Settings['healthstoneHP'];
				v91 = EpicSettings.Settings['InterruptThreshold'];
				v139 = 5 - 3;
			end
		end
	end
	local function v129()
		local v140 = 0 - 0;
		while true do
			if (((916 - 330) > (2411 - (1869 + 87))) and (v140 == (0 - 0))) then
				v127();
				v128();
				v29 = EpicSettings.Toggles['ooc'];
				v140 = 1902 - (484 + 1417);
			end
			if (((1770 - 944) == (1383 - 557)) and (v140 == (776 - (48 + 725)))) then
				v111 = v12:GetEnemiesInMeleeRange(12 - 4);
				if (v30 or ((10782 - 6763) > (2581 + 1860))) then
					v112 = #v111;
				else
					v112 = 2 - 1;
				end
				if (((565 + 1452) < (1242 + 3019)) and (v114.TargetIsValid() or v12:AffectingCombat())) then
					v106 = v12:GetEnemiesInRange(893 - (152 + 701));
					v104 = v9.BossFightRemains(nil, true);
					v105 = v104;
					if (((6027 - (430 + 881)) > (31 + 49)) and (v105 == (12006 - (557 + 338)))) then
						v105 = v9.FightRemains(v106, false);
					end
				end
				v140 = 2 + 2;
			end
			if ((v140 == (10 - 6)) or ((12280 - 8773) == (8692 - 5420))) then
				if (v12:AffectingCombat() or v29 or ((1887 - 1011) >= (3876 - (499 + 302)))) then
					local v229 = v88 and v107.Detox:IsReady() and v32;
					v28 = v114.FocusUnit(v229, nil, nil, nil);
					if (((5218 - (39 + 827)) > (7050 - 4496)) and v28) then
						return v28;
					end
					if ((v32 and v88) or ((9840 - 5434) < (16058 - 12015))) then
						if (v16 or ((2899 - 1010) >= (290 + 3093))) then
							if (((5537 - 3645) <= (438 + 2296)) and v107.Detox:IsCastable() and v114.DispellableFriendlyUnit(39 - 14)) then
								if (((2027 - (103 + 1)) < (2772 - (475 + 79))) and v23(v109.DetoxFocus, not v16:IsSpellInRange(v107.Detox))) then
									return "detox dispel focus";
								end
							end
						end
						if (((4697 - 2524) > (1212 - 833)) and v15 and v15:Exists() and v15:IsAPlayer() and v114.UnitHasDispellableDebuffByPlayer(v15)) then
							if (v107.Detox:IsCastable() or ((335 + 2256) == (3001 + 408))) then
								if (((6017 - (1395 + 108)) > (9672 - 6348)) and v23(v109.DetoxMouseover, not v15:IsSpellInRange(v107.Detox))) then
									return "detox dispel mouseover";
								end
							end
						end
					end
				end
				if (not v12:AffectingCombat() or ((1412 - (7 + 1197)) >= (2106 + 2722))) then
					if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) or ((553 + 1030) > (3886 - (27 + 292)))) then
						local v233 = 0 - 0;
						local v234;
						while true do
							if (((0 - 0) == v233) or ((5506 - 4193) == (1565 - 771))) then
								v234 = v114.DeadFriendlyUnitsCount();
								if (((6044 - 2870) > (3041 - (43 + 96))) and (v234 > (4 - 3))) then
									if (((9314 - 5194) <= (3535 + 725)) and v23(v107.Reawaken, nil)) then
										return "reawaken";
									end
								elseif (v23(v109.ResuscitateMouseover, not v14:IsInRange(12 + 28)) or ((1745 - 862) > (1832 + 2946))) then
									return "resuscitate";
								end
								break;
							end
						end
					end
				end
				if ((not v12:AffectingCombat() and v29) or ((6784 - 3164) >= (1540 + 3351))) then
					local v230 = 0 + 0;
					while true do
						if (((6009 - (1414 + 337)) > (2877 - (1642 + 298))) and (v230 == (0 - 0))) then
							v28 = v119();
							if (v28 or ((14007 - 9138) < (2688 - 1782))) then
								return v28;
							end
							break;
						end
					end
				end
				v140 = 2 + 3;
			end
			if ((v140 == (2 + 0)) or ((2197 - (357 + 615)) > (2968 + 1260))) then
				v33 = EpicSettings.Toggles['healing'];
				v34 = EpicSettings.Toggles['dps'];
				if (((8165 - 4837) > (1918 + 320)) and v12:IsDeadOrGhost()) then
					return;
				end
				v140 = 6 - 3;
			end
			if (((3071 + 768) > (96 + 1309)) and (v140 == (1 + 0))) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v140 = 1303 - (384 + 917);
			end
			if ((v140 == (702 - (128 + 569))) or ((2836 - (1407 + 136)) <= (2394 - (687 + 1200)))) then
				if (v29 or v12:AffectingCombat() or ((4606 - (556 + 1154)) < (2831 - 2026))) then
					local v231 = 95 - (9 + 86);
					while true do
						if (((2737 - (275 + 146)) == (377 + 1939)) and (v231 == (64 - (29 + 35)))) then
							v28 = v118();
							if (v28 or ((11390 - 8820) == (4578 - 3045))) then
								return v28;
							end
							v231 = 4 - 3;
						end
						if (((1 + 0) == v231) or ((1895 - (53 + 959)) == (1868 - (312 + 96)))) then
							if (v33 or ((8016 - 3397) <= (1284 - (147 + 138)))) then
								if ((v107.SummonJadeSerpentStatue:IsReady() and v107.SummonJadeSerpentStatue:IsAvailable() and (v107.SummonJadeSerpentStatue:TimeSinceLastCast() > (989 - (813 + 86))) and v65) or ((3082 + 328) > (7625 - 3509))) then
									if ((v64 == "Player") or ((1395 - (18 + 474)) >= (1032 + 2027))) then
										if (v23(v109.SummonJadeSerpentStatuePlayer, not v14:IsInRange(130 - 90)) or ((5062 - (860 + 226)) < (3160 - (121 + 182)))) then
											return "jade serpent main player";
										end
									elseif (((607 + 4323) > (3547 - (988 + 252))) and (v64 == "Cursor")) then
										if (v23(v109.SummonJadeSerpentStatueCursor, not v14:IsInRange(5 + 35)) or ((1268 + 2778) < (3261 - (49 + 1921)))) then
											return "jade serpent main cursor";
										end
									elseif ((v64 == "Confirmation") or ((5131 - (223 + 667)) == (3597 - (51 + 1)))) then
										if (v23(v107.SummonJadeSerpentStatue, not v14:IsInRange(68 - 28)) or ((8668 - 4620) > (5357 - (146 + 979)))) then
											return "jade serpent main confirmation";
										end
									end
								end
								if ((v35 and (v12:BuffStack(v107.ManaTeaCharges) >= (6 + 12)) and v107.ManaTea:IsCastable()) or ((2355 - (311 + 294)) >= (9685 - 6212))) then
									if (((1342 + 1824) == (4609 - (496 + 947))) and v23(v107.ManaTea, nil)) then
										return "Mana Tea main avoid overcap";
									end
								end
								if (((3121 - (1233 + 125)) < (1512 + 2212)) and (v105 > v98) and v31) then
									local v237 = 0 + 0;
									while true do
										if (((11 + 46) <= (4368 - (963 + 682))) and (v237 == (0 + 0))) then
											v28 = v126();
											if (v28 or ((3574 - (504 + 1000)) == (299 + 144))) then
												return v28;
											end
											break;
										end
									end
								end
								if (v30 or ((2464 + 241) == (132 + 1261))) then
									local v238 = 0 - 0;
									while true do
										if ((v238 == (0 + 0)) or ((2676 + 1925) < (243 - (156 + 26)))) then
											v28 = v123();
											if (v28 or ((801 + 589) >= (7422 - 2678))) then
												return v28;
											end
											break;
										end
									end
								end
								v28 = v122();
								if (v28 or ((2167 - (149 + 15)) > (4794 - (890 + 70)))) then
									return v28;
								end
							end
							break;
						end
					end
				end
				if (((v29 or v12:AffectingCombat()) and v114.TargetIsValid() and v12:CanAttack(v14)) or ((273 - (39 + 78)) > (4395 - (14 + 468)))) then
					v28 = v117();
					if (((428 - 233) == (545 - 350)) and v28) then
						return v28;
					end
					if (((1603 + 1502) >= (1079 + 717)) and v96 and ((v31 and v97) or not v97)) then
						local v235 = 0 + 0;
						while true do
							if (((1978 + 2401) >= (559 + 1572)) and (v235 == (0 - 0))) then
								v28 = v114.HandleTopTrinket(v110, v31, 40 + 0, nil);
								if (((13507 - 9663) >= (52 + 1991)) and v28) then
									return v28;
								end
								v235 = 52 - (12 + 39);
							end
							if ((v235 == (1 + 0)) or ((10003 - 6771) <= (9726 - 6995))) then
								v28 = v114.HandleBottomTrinket(v110, v31, 12 + 28, nil);
								if (((2582 + 2323) == (12437 - 7532)) and v28) then
									return v28;
								end
								break;
							end
						end
					end
					if (v34 or ((2755 + 1381) >= (21317 - 16906))) then
						local v236 = 1710 - (1596 + 114);
						while true do
							if ((v236 == (2 - 1)) or ((3671 - (164 + 549)) == (5455 - (1059 + 379)))) then
								if (((1524 - 296) >= (422 + 391)) and (v112 >= (1 + 2)) and v30) then
									local v239 = 392 - (145 + 247);
									while true do
										if ((v239 == (0 + 0)) or ((1597 + 1858) > (12007 - 7957))) then
											v28 = v120();
											if (((47 + 196) == (210 + 33)) and v28) then
												return v28;
											end
											break;
										end
									end
								end
								if ((v112 < (4 - 1)) or ((991 - (254 + 466)) > (2132 - (544 + 16)))) then
									local v240 = 0 - 0;
									while true do
										if (((3367 - (294 + 334)) < (3546 - (236 + 17))) and (v240 == (0 + 0))) then
											v28 = v121();
											if (v28 or ((3069 + 873) < (4270 - 3136))) then
												return v28;
											end
											break;
										end
									end
								end
								break;
							end
							if ((v236 == (0 - 0)) or ((1387 + 1306) == (4096 + 877))) then
								if (((2940 - (413 + 381)) == (91 + 2055)) and v94 and ((v31 and v95) or not v95) and (v105 < (38 - 20))) then
									local v241 = 0 - 0;
									while true do
										if ((v241 == (1970 - (582 + 1388))) or ((3823 - 1579) == (2308 + 916))) then
											if (v107.BloodFury:IsCastable() or ((5268 - (326 + 38)) <= (5667 - 3751))) then
												if (((128 - 38) <= (1685 - (47 + 573))) and v23(v107.BloodFury, nil)) then
													return "blood_fury main 4";
												end
											end
											if (((1693 + 3109) == (20394 - 15592)) and v107.Berserking:IsCastable()) then
												if (v23(v107.Berserking, nil) or ((3700 - 1420) <= (2175 - (1269 + 395)))) then
													return "berserking main 6";
												end
											end
											v241 = 493 - (76 + 416);
										end
										if (((444 - (319 + 124)) == v241) or ((3830 - 2154) <= (1470 - (564 + 443)))) then
											if (((10710 - 6841) == (4327 - (337 + 121))) and v107.LightsJudgment:IsCastable()) then
												if (((3392 - 2234) <= (8703 - 6090)) and v23(v107.LightsJudgment, not v14:IsInRange(1951 - (1261 + 650)))) then
													return "lights_judgment main 8";
												end
											end
											if (v107.Fireblood:IsCastable() or ((1001 + 1363) <= (3185 - 1186))) then
												if (v23(v107.Fireblood, nil) or ((6739 - (772 + 1045)) < (28 + 166))) then
													return "fireblood main 10";
												end
											end
											v241 = 146 - (102 + 42);
										end
										if ((v241 == (1846 - (1524 + 320))) or ((3361 - (1049 + 221)) < (187 - (18 + 138)))) then
											if (v107.AncestralCall:IsCastable() or ((5948 - 3518) >= (5974 - (67 + 1035)))) then
												if (v23(v107.AncestralCall, nil) or ((5118 - (136 + 212)) < (7372 - 5637))) then
													return "ancestral_call main 12";
												end
											end
											if (v107.BagofTricks:IsCastable() or ((3557 + 882) <= (2167 + 183))) then
												if (v23(v107.BagofTricks, not v14:IsInRange(1644 - (240 + 1364))) or ((5561 - (1050 + 32)) < (15946 - 11480))) then
													return "bag_of_tricks main 14";
												end
											end
											break;
										end
									end
								end
								if (((1507 + 1040) > (2280 - (331 + 724))) and v37 and v107.ThunderFocusTea:IsReady() and not v107.EssenceFont:IsAvailable() and (v107.RisingSunKick:CooldownRemains() < v12:GCD())) then
									if (((377 + 4294) > (3318 - (269 + 375))) and v23(v107.ThunderFocusTea, nil)) then
										return "ThunderFocusTea main 16";
									end
								end
								v236 = 726 - (267 + 458);
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v130()
		local v141 = 0 + 0;
		while true do
			if ((v141 == (0 - 0)) or ((4514 - (667 + 151)) < (4824 - (1410 + 87)))) then
				v116();
				v21.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(2167 - (1504 + 393), v129, v130);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

