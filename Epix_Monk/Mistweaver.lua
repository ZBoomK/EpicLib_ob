local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 51 - (49 + 2);
	local v6;
	while true do
		if ((v5 == (3 - 2)) or ((4121 - (364 + 97)) <= (10284 - 8219))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((14926 - 10816) > (1555 + 2821))) then
			v6 = v0[v4];
			if (not v6 or ((715 + 915) > (12457 - 8259))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
	local v36 = false;
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
	local v112 = 20435 - 9324;
	local v113 = 7346 + 3765;
	local v114;
	local v115 = v18.Monk.Mistweaver;
	local v116 = v20.Monk.Mistweaver;
	local v117 = v25.Monk.Mistweaver;
	local v118 = {};
	local v119;
	local v120;
	local v121 = v22.Commons.Everyone;
	local v122 = v22.Commons.Monk;
	local function v123()
		if (((587 + 467) == (758 + 296)) and v115.ImprovedDetox:IsAvailable()) then
			v121.DispellableDebuffs = v21.MergeTable(v121.DispellableMagicDebuffs, v121.DispellablePoisonDebuffs, v121.DispellableDiseaseDebuffs);
		else
			v121.DispellableDebuffs = v121.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v123();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v124()
		local v139 = 0 + 0;
		while true do
			if ((v139 == (0 + 0)) or ((1109 - (153 + 280)) >= (4741 - 3099))) then
				if (((3714 + 422) > (947 + 1450)) and v115.DampenHarm:IsCastable() and v13:BuffDown(v115.FortifyingBrew) and (v13:HealthPercentage() <= v43) and v42) then
					if (v24(v115.DampenHarm, nil) or ((2269 + 2065) == (3853 + 392))) then
						return "dampen_harm defensives 1";
					end
				end
				if ((v115.FortifyingBrew:IsCastable() and v13:BuffDown(v115.DampenHarmBuff) and (v13:HealthPercentage() <= v41) and v40) or ((3099 + 1177) <= (4614 - 1583))) then
					if (v24(v115.FortifyingBrew, nil) or ((2956 + 1826) <= (1866 - (89 + 578)))) then
						return "fortifying_brew defensives 2";
					end
				end
				v139 = 1 + 0;
			end
			if ((v139 == (1 - 0)) or ((5913 - (572 + 477)) < (257 + 1645))) then
				if (((2905 + 1934) >= (442 + 3258)) and v115.ExpelHarm:IsCastable() and (v13:HealthPercentage() <= v56) and v55 and v13:BuffUp(v115.ChiHarmonyBuff)) then
					if (v24(v115.ExpelHarm, nil) or ((1161 - (84 + 2)) > (3160 - 1242))) then
						return "expel_harm defensives 3";
					end
				end
				if (((286 + 110) <= (4646 - (497 + 345))) and v116.Healthstone:IsReady() and v116.Healthstone:IsUsable() and v85 and (v13:HealthPercentage() <= v86)) then
					if (v24(v117.Healthstone) or ((107 + 4062) == (370 + 1817))) then
						return "healthstone defensive 4";
					end
				end
				v139 = 1335 - (605 + 728);
			end
			if (((1004 + 402) == (3125 - 1719)) and (v139 == (1 + 1))) then
				if (((5660 - 4129) < (3851 + 420)) and v87 and (v13:HealthPercentage() <= v88)) then
					local v235 = 0 - 0;
					while true do
						if (((480 + 155) == (1124 - (457 + 32))) and (v235 == (0 + 0))) then
							if (((4775 - (832 + 570)) <= (3351 + 205)) and (v89 == "Refreshing Healing Potion")) then
								if ((v116.RefreshingHealingPotion:IsReady() and v116.RefreshingHealingPotion:IsUsable()) or ((859 + 2432) < (11607 - 8327))) then
									if (((2113 + 2273) >= (1669 - (588 + 208))) and v24(v117.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 5";
									end
								end
							end
							if (((2482 - 1561) <= (2902 - (884 + 916))) and (v89 == "Dreamwalker's Healing Potion")) then
								if (((9852 - 5146) >= (559 + 404)) and v116.DreamwalkersHealingPotion:IsReady() and v116.DreamwalkersHealingPotion:IsUsable()) then
									if (v24(v117.RefreshingHealingPotion) or ((1613 - (232 + 421)) <= (2765 - (1569 + 320)))) then
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
	local function v125()
		if (v103 or ((507 + 1559) == (178 + 754))) then
			local v185 = 0 - 0;
			while true do
				if (((5430 - (316 + 289)) < (12677 - 7834)) and (v185 == (0 + 0))) then
					v29 = v121.HandleIncorporeal(v115.Paralysis, v117.ParalysisMouseover, 1483 - (666 + 787), true);
					if (v29 or ((4302 - (360 + 65)) >= (4241 + 296))) then
						return v29;
					end
					break;
				end
			end
		end
		if (v102 or ((4569 - (79 + 175)) < (2721 - 995))) then
			local v186 = 0 + 0;
			while true do
				if ((v186 == (0 - 0)) or ((7084 - 3405) < (1524 - (503 + 396)))) then
					v29 = v121.HandleAfflicted(v115.Detox, v117.DetoxMouseover, 211 - (92 + 89));
					if (v29 or ((8971 - 4346) < (325 + 307))) then
						return v29;
					end
					v186 = 1 + 0;
				end
				if ((v186 == (3 - 2)) or ((12 + 71) > (4058 - 2278))) then
					if (((477 + 69) <= (515 + 562)) and v115.Detox:CooldownRemains()) then
						local v239 = 0 - 0;
						while true do
							if ((v239 == (0 + 0)) or ((1518 - 522) > (5545 - (485 + 759)))) then
								v29 = v121.HandleAfflicted(v115.Vivify, v117.VivifyMouseover, 69 - 39);
								if (((5259 - (442 + 747)) > (1822 - (832 + 303))) and v29) then
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
		if (v104 or ((1602 - (88 + 858)) >= (1015 + 2315))) then
			v29 = v121.HandleChromie(v115.Riptide, v117.RiptideMouseover, 34 + 6);
			if (v29 or ((103 + 2389) <= (1124 - (766 + 23)))) then
				return v29;
			end
			v29 = v121.HandleChromie(v115.HealingSurge, v117.HealingSurgeMouseover, 197 - 157);
			if (((5910 - 1588) >= (6749 - 4187)) and v29) then
				return v29;
			end
		end
		if (v105 or ((12343 - 8706) >= (4843 - (1036 + 37)))) then
			v29 = v121.HandleCharredTreant(v115.RenewingMist, v117.RenewingMistMouseover, 29 + 11);
			if (v29 or ((4632 - 2253) > (3602 + 976))) then
				return v29;
			end
			v29 = v121.HandleCharredTreant(v115.SoothingMist, v117.SoothingMistMouseover, 1520 - (641 + 839));
			if (v29 or ((1396 - (910 + 3)) > (1893 - 1150))) then
				return v29;
			end
			v29 = v121.HandleCharredTreant(v115.Vivify, v117.VivifyMouseover, 1724 - (1466 + 218));
			if (((1128 + 1326) > (1726 - (556 + 592))) and v29) then
				return v29;
			end
			v29 = v121.HandleCharredTreant(v115.EnvelopingMist, v117.EnvelopingMistMouseover, 15 + 25);
			if (((1738 - (329 + 479)) < (5312 - (174 + 680))) and v29) then
				return v29;
			end
		end
		if (((2274 - 1612) <= (2014 - 1042)) and v106) then
			v29 = v121.HandleCharredBrambles(v115.RenewingMist, v117.RenewingMistMouseover, 29 + 11);
			if (((5109 - (396 + 343)) == (387 + 3983)) and v29) then
				return v29;
			end
			v29 = v121.HandleCharredBrambles(v115.SoothingMist, v117.SoothingMistMouseover, 1517 - (29 + 1448));
			if (v29 or ((6151 - (135 + 1254)) <= (3243 - 2382))) then
				return v29;
			end
			v29 = v121.HandleCharredBrambles(v115.Vivify, v117.VivifyMouseover, 186 - 146);
			if (v29 or ((942 + 470) == (5791 - (389 + 1138)))) then
				return v29;
			end
			v29 = v121.HandleCharredBrambles(v115.EnvelopingMist, v117.EnvelopingMistMouseover, 614 - (102 + 472));
			if (v29 or ((2990 + 178) < (1194 + 959))) then
				return v29;
			end
		end
		if (v107 or ((4640 + 336) < (2877 - (320 + 1225)))) then
			local v187 = 0 - 0;
			while true do
				if (((2832 + 1796) == (6092 - (157 + 1307))) and (v187 == (1860 - (821 + 1038)))) then
					v29 = v121.HandleFyrakkNPC(v115.SoothingMist, v117.SoothingMistMouseover, 99 - 59);
					if (v29 or ((6 + 48) == (701 - 306))) then
						return v29;
					end
					v187 = 1 + 1;
				end
				if (((202 - 120) == (1108 - (834 + 192))) and ((1 + 2) == v187)) then
					v29 = v121.HandleFyrakkNPC(v115.EnvelopingMist, v117.EnvelopingMistMouseover, 11 + 29);
					if (v29 or ((13 + 568) < (436 - 154))) then
						return v29;
					end
					break;
				end
				if ((v187 == (304 - (300 + 4))) or ((1231 + 3378) < (6531 - 4036))) then
					v29 = v121.HandleFyrakkNPC(v115.RenewingMist, v117.RenewingMistMouseover, 402 - (112 + 250));
					if (((460 + 692) == (2885 - 1733)) and v29) then
						return v29;
					end
					v187 = 1 + 0;
				end
				if (((981 + 915) <= (2560 + 862)) and (v187 == (1 + 1))) then
					v29 = v121.HandleFyrakkNPC(v115.Vivify, v117.VivifyMouseover, 30 + 10);
					if (v29 or ((2404 - (1001 + 413)) > (3612 - 1992))) then
						return v29;
					end
					v187 = 885 - (244 + 638);
				end
			end
		end
	end
	local function v126()
		if ((v115.ChiBurst:IsCastable() and v51) or ((1570 - (627 + 66)) > (13989 - 9294))) then
			if (((3293 - (512 + 90)) >= (3757 - (1665 + 241))) and v24(v115.ChiBurst, not v15:IsInRange(757 - (373 + 344)))) then
				return "chi_burst precombat 4";
			end
		end
		if ((v115.SpinningCraneKick:IsCastable() and v47 and (v120 >= (1 + 1))) or ((790 + 2195) >= (12808 - 7952))) then
			if (((7235 - 2959) >= (2294 - (35 + 1064))) and v24(v115.SpinningCraneKick, not v15:IsInMeleeRange(6 + 2))) then
				return "spinning_crane_kick precombat 6";
			end
		end
		if (((6914 - 3682) <= (19 + 4671)) and v115.TigerPalm:IsCastable() and v49) then
			if (v24(v115.TigerPalm, not v15:IsInMeleeRange(1241 - (298 + 938))) or ((2155 - (233 + 1026)) >= (4812 - (636 + 1030)))) then
				return "tiger_palm precombat 8";
			end
		end
	end
	local function v127()
		if (((1565 + 1496) >= (2890 + 68)) and v115.SummonWhiteTigerStatue:IsReady() and (v120 >= (1 + 2)) and v45) then
			if (((216 + 2971) >= (865 - (55 + 166))) and (v44 == "Player")) then
				if (((125 + 519) <= (71 + 633)) and v24(v117.SummonWhiteTigerStatuePlayer, not v15:IsInRange(152 - 112))) then
					return "summon_white_tiger_statue aoe player 1";
				end
			elseif (((1255 - (36 + 261)) > (1656 - 709)) and (v44 == "Cursor")) then
				if (((5860 - (34 + 1334)) >= (1021 + 1633)) and v24(v117.SummonWhiteTigerStatueCursor, not v15:IsInRange(32 + 8))) then
					return "summon_white_tiger_statue aoe cursor 1";
				end
			elseif (((4725 - (1035 + 248)) >= (1524 - (20 + 1))) and (v44 == "Friendly under Cursor") and v16:Exists() and not v13:CanAttack(v16)) then
				if (v24(v117.SummonWhiteTigerStatueCursor, not v15:IsInRange(21 + 19)) or ((3489 - (134 + 185)) <= (2597 - (549 + 584)))) then
					return "summon_white_tiger_statue aoe cursor friendly 1";
				end
			elseif (((v44 == "Enemy under Cursor") and v16:Exists() and v13:CanAttack(v16)) or ((5482 - (314 + 371)) == (15063 - 10675))) then
				if (((1519 - (478 + 490)) <= (361 + 320)) and v24(v117.SummonWhiteTigerStatueCursor, not v15:IsInRange(1212 - (786 + 386)))) then
					return "summon_white_tiger_statue aoe cursor enemy 1";
				end
			elseif (((10614 - 7337) > (1786 - (1055 + 324))) and (v44 == "Confirmation")) then
				if (((6035 - (1093 + 247)) >= (1258 + 157)) and v24(v117.SummonWhiteTigerStatue, not v15:IsInRange(5 + 35))) then
					return "summon_white_tiger_statue aoe confirmation 1";
				end
			end
		end
		if ((v115.TouchofDeath:IsCastable() and v52) or ((12752 - 9540) <= (3203 - 2259))) then
			if (v24(v115.TouchofDeath, not v15:IsInMeleeRange(14 - 9)) or ((7779 - 4683) <= (640 + 1158))) then
				return "touch_of_death aoe 2";
			end
		end
		if (((13626 - 10089) == (12191 - 8654)) and v115.JadefireStomp:IsReady() and v50) then
			if (((2894 + 943) >= (4015 - 2445)) and v24(v115.JadefireStomp, not v15:IsInMeleeRange(696 - (364 + 324)))) then
				return "JadefireStomp aoe3";
			end
		end
		if ((v115.ChiBurst:IsCastable() and v51) or ((8087 - 5137) == (9147 - 5335))) then
			if (((1566 + 3157) >= (9699 - 7381)) and v24(v115.ChiBurst, not v15:IsInRange(64 - 24))) then
				return "chi_burst aoe 4";
			end
		end
		if ((v115.SpinningCraneKick:IsCastable() and v47 and (v15:DebuffDown(v115.MysticTouchDebuff) or (v121.EnemiesWithDebuffCount(v115.MysticTouchDebuff) <= (v120 - (2 - 1)))) and v115.MysticTouch:IsAvailable()) or ((3295 - (1249 + 19)) > (2575 + 277))) then
			if (v24(v115.SpinningCraneKick, not v15:IsInMeleeRange(31 - 23)) or ((2222 - (686 + 400)) > (3388 + 929))) then
				return "spinning_crane_kick aoe 5";
			end
		end
		if (((4977 - (73 + 156)) == (23 + 4725)) and v115.BlackoutKick:IsCastable() and v115.AncientConcordance:IsAvailable() and v13:BuffUp(v115.JadefireStomp) and v46 and (v120 >= (814 - (721 + 90)))) then
			if (((43 + 3693) <= (15390 - 10650)) and v24(v115.BlackoutKick, not v15:IsInMeleeRange(475 - (224 + 246)))) then
				return "blackout_kick aoe 6";
			end
		end
		if ((v115.BlackoutKick:IsCastable() and v115.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v115.TeachingsoftheMonasteryBuff) >= (2 - 0)) and v46) or ((6241 - 2851) <= (556 + 2504))) then
			if (v24(v115.BlackoutKick, not v15:IsInMeleeRange(1 + 4)) or ((734 + 265) > (5353 - 2660))) then
				return "blackout_kick aoe 8";
			end
		end
		if (((1540 - 1077) < (1114 - (203 + 310))) and v115.TigerPalm:IsCastable() and v115.TeachingsoftheMonastery:IsAvailable() and (v115.BlackoutKick:CooldownRemains() > (1993 - (1238 + 755))) and v49 and (v120 >= (1 + 2))) then
			if (v24(v115.TigerPalm, not v15:IsInMeleeRange(1539 - (709 + 825))) or ((4022 - 1839) < (1000 - 313))) then
				return "tiger_palm aoe 7";
			end
		end
		if (((5413 - (196 + 668)) == (17960 - 13411)) and v115.SpinningCraneKick:IsCastable() and v47) then
			if (((9677 - 5005) == (5505 - (171 + 662))) and v24(v115.SpinningCraneKick, not v15:IsInMeleeRange(101 - (4 + 89)))) then
				return "spinning_crane_kick aoe 8";
			end
		end
	end
	local function v128()
		local v140 = 0 - 0;
		while true do
			if ((v140 == (2 + 1)) or ((16110 - 12442) < (155 + 240))) then
				if ((v115.BlackoutKick:IsCastable() and not v115.TeachingsoftheMonastery:IsAvailable() and v46) or ((5652 - (35 + 1451)) == (1908 - (28 + 1425)))) then
					if (v24(v115.BlackoutKick, not v15:IsInMeleeRange(1998 - (941 + 1052))) or ((4266 + 183) == (4177 - (822 + 692)))) then
						return "blackout_kick st 7";
					end
				end
				if ((v115.TigerPalm:IsCastable() and v49) or ((6106 - 1829) < (1408 + 1581))) then
					if (v24(v115.TigerPalm, not v15:IsInMeleeRange(302 - (45 + 252))) or ((861 + 9) >= (1428 + 2721))) then
						return "tiger_palm st 8";
					end
				end
				break;
			end
			if (((5382 - 3170) < (3616 - (114 + 319))) and ((2 - 0) == v140)) then
				if (((5953 - 1307) > (1908 + 1084)) and v115.BlackoutKick:IsCastable() and (v13:BuffStack(v115.TeachingsoftheMonasteryBuff) >= (4 - 1)) and (v115.RisingSunKick:CooldownRemains() > v13:GCD()) and v46) then
					if (((3004 - 1570) < (5069 - (556 + 1407))) and v24(v115.BlackoutKick, not v15:IsInMeleeRange(1211 - (741 + 465)))) then
						return "blackout_kick st 5";
					end
				end
				if (((1251 - (170 + 295)) < (1593 + 1430)) and v115.TigerPalm:IsCastable() and ((v13:BuffStack(v115.TeachingsoftheMonasteryBuff) < (3 + 0)) or (v13:BuffRemains(v115.TeachingsoftheMonasteryBuff) < (4 - 2))) and v115.TeachingsoftheMonastery:IsAvailable() and v49) then
					if (v24(v115.TigerPalm, not v15:IsInMeleeRange(5 + 0)) or ((1567 + 875) < (42 + 32))) then
						return "tiger_palm st 6";
					end
				end
				v140 = 1233 - (957 + 273);
			end
			if (((1213 + 3322) == (1816 + 2719)) and (v140 == (3 - 2))) then
				if ((v115.RisingSunKick:IsReady() and v48) or ((7929 - 4920) <= (6429 - 4324))) then
					if (((9061 - 7231) < (5449 - (389 + 1391))) and v24(v115.RisingSunKick, not v15:IsInMeleeRange(4 + 1))) then
						return "rising_sun_kick st 3";
					end
				end
				if ((v115.ChiBurst:IsCastable() and v51) or ((149 + 1281) >= (8222 - 4610))) then
					if (((3634 - (783 + 168)) >= (8256 - 5796)) and v24(v115.ChiBurst, not v15:IsInRange(40 + 0))) then
						return "chi_burst st 4";
					end
				end
				v140 = 313 - (309 + 2);
			end
			if ((v140 == (0 - 0)) or ((3016 - (1090 + 122)) >= (1062 + 2213))) then
				if ((v115.TouchofDeath:IsCastable() and v52) or ((4758 - 3341) > (2484 + 1145))) then
					if (((5913 - (628 + 490)) > (73 + 329)) and v24(v115.TouchofDeath, not v15:IsInMeleeRange(12 - 7))) then
						return "touch_of_death st 1";
					end
				end
				if (((21995 - 17182) > (4339 - (431 + 343))) and v115.JadefireStomp:IsReady() and v50) then
					if (((7900 - 3988) == (11316 - 7404)) and v24(v115.JadefireStomp, nil)) then
						return "JadefireStomp st 2";
					end
				end
				v140 = 1 + 0;
			end
		end
	end
	local function v129()
		local v141 = 0 + 0;
		while true do
			if (((4516 - (556 + 1139)) <= (4839 - (6 + 9))) and (v141 == (0 + 0))) then
				if (((891 + 847) <= (2364 - (28 + 141))) and v53 and v115.RenewingMist:IsReady() and v17:BuffDown(v115.RenewingMistBuff) and (v115.RenewingMist:ChargesFractional() >= (1.8 + 0))) then
					if (((50 - 9) <= (2138 + 880)) and (v17:HealthPercentage() <= v54)) then
						if (((3462 - (486 + 831)) <= (10679 - 6575)) and v24(v117.RenewingMistFocus, not v17:IsSpellInRange(v115.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if (((9466 - 6777) < (916 + 3929)) and v48 and v115.RisingSunKick:IsReady() and (v121.FriendlyUnitsWithBuffCount(v115.RenewingMistBuff, false, false, 78 - 53) > (1264 - (668 + 595)))) then
					if (v24(v115.RisingSunKick, not v15:IsInMeleeRange(5 + 0)) or ((469 + 1853) > (7150 - 4528))) then
						return "RisingSunKick healing st";
					end
				end
				v141 = 291 - (23 + 267);
			end
			if ((v141 == (1946 - (1129 + 815))) or ((4921 - (371 + 16)) == (3832 - (1326 + 424)))) then
				if ((v61 and v115.SoothingMist:IsReady() and v17:BuffDown(v115.SoothingMist)) or ((2975 - 1404) > (6822 - 4955))) then
					if ((v17:HealthPercentage() <= v62) or ((2772 - (88 + 30)) >= (3767 - (720 + 51)))) then
						if (((8848 - 4870) > (3880 - (421 + 1355))) and v24(v117.SoothingMistFocus, not v17:IsSpellInRange(v115.SoothingMist))) then
							return "SoothingMist healing st";
						end
					end
				end
				break;
			end
			if (((4941 - 1946) > (757 + 784)) and (v141 == (1084 - (286 + 797)))) then
				if (((11877 - 8628) > (1577 - 624)) and v53 and v115.RenewingMist:IsReady() and v17:BuffDown(v115.RenewingMistBuff)) then
					if ((v17:HealthPercentage() <= v54) or ((3712 - (397 + 42)) > (1429 + 3144))) then
						if (v24(v117.RenewingMistFocus, not v17:IsSpellInRange(v115.RenewingMist)) or ((3951 - (24 + 776)) < (1977 - 693))) then
							return "RenewingMist healing st";
						end
					end
				end
				if ((v57 and v115.Vivify:IsReady() and v13:BuffUp(v115.VivaciousVivificationBuff)) or ((2635 - (222 + 563)) == (3368 - 1839))) then
					if (((592 + 229) < (2313 - (23 + 167))) and (v17:HealthPercentage() <= v58)) then
						if (((2700 - (690 + 1108)) < (839 + 1486)) and v24(v117.VivifyFocus, not v17:IsSpellInRange(v115.Vivify))) then
							return "Vivify instant healing st";
						end
					end
				end
				v141 = 2 + 0;
			end
		end
	end
	local function v130()
		if (((1706 - (40 + 808)) <= (488 + 2474)) and v48 and v115.RisingSunKick:IsReady() and (v121.FriendlyUnitsWithBuffCount(v115.RenewingMistBuff, false, false, 95 - 70) > (1 + 0))) then
			if (v24(v115.RisingSunKick, not v15:IsInMeleeRange(3 + 2)) or ((2164 + 1782) < (1859 - (47 + 524)))) then
				return "RisingSunKick healing aoe";
			end
		end
		if (v121.AreUnitsBelowHealthPercentage(v65, v64, v115.EnvelopingMist) or ((2104 + 1138) == (1549 - 982))) then
			local v188 = 0 - 0;
			while true do
				if ((v188 == (2 - 1)) or ((2573 - (1165 + 561)) >= (38 + 1225))) then
					if ((v63 and v115.EssenceFont:IsReady() and (v13:BuffUp(v115.ThunderFocusTea) or (v115.ThunderFocusTea:CooldownRemains() > (24 - 16)))) or ((860 + 1393) == (2330 - (341 + 138)))) then
						if (v24(v115.EssenceFont, nil) or ((564 + 1523) > (4894 - 2522))) then
							return "EssenceFont healing aoe";
						end
					end
					if ((v63 and v115.EssenceFont:IsReady() and v115.AncientTeachings:IsAvailable() and v13:BuffDown(v115.EssenceFontBuff)) or ((4771 - (89 + 237)) < (13347 - 9198))) then
						if (v24(v115.EssenceFont, nil) or ((3827 - 2009) == (966 - (581 + 300)))) then
							return "EssenceFont healing aoe";
						end
					end
					break;
				end
				if (((1850 - (855 + 365)) < (5052 - 2925)) and (v188 == (0 + 0))) then
					if ((v37 and (v13:BuffStack(v115.ManaTeaCharges) > v38) and v115.EssenceFont:IsReady() and v115.ManaTea:IsCastable() and not v121.AreUnitsBelowHealthPercentage(1315 - (1030 + 205), 3 + 0, v115.EnvelopingMist)) or ((1803 + 135) == (2800 - (156 + 130)))) then
						if (((9668 - 5413) >= (92 - 37)) and v24(v115.ManaTea, nil)) then
							return "EssenceFont healing aoe";
						end
					end
					if (((6141 - 3142) > (305 + 851)) and v39 and v115.ThunderFocusTea:IsReady() and (v115.EssenceFont:CooldownRemains() < v13:GCD())) then
						if (((1371 + 979) > (1224 - (10 + 59))) and v24(v115.ThunderFocusTea, nil)) then
							return "ThunderFocusTea healing aoe";
						end
					end
					v188 = 1 + 0;
				end
			end
		end
		if (((19841 - 15812) <= (6016 - (671 + 492))) and v68 and v115.ZenPulse:IsReady() and v121.AreUnitsBelowHealthPercentage(v70, v69, v115.EnvelopingMist)) then
			if (v24(v117.ZenPulseFocus, not v17:IsSpellInRange(v115.ZenPulse)) or ((411 + 105) > (4649 - (369 + 846)))) then
				return "ZenPulse healing aoe";
			end
		end
		if (((1072 + 2974) >= (2589 + 444)) and v71 and v115.SheilunsGift:IsReady() and v115.SheilunsGift:IsCastable() and v121.AreUnitsBelowHealthPercentage(v73, v72, v115.EnvelopingMist)) then
			if (v24(v115.SheilunsGift, nil) or ((4664 - (1036 + 909)) <= (1151 + 296))) then
				return "SheilunsGift healing aoe";
			end
		end
	end
	local function v131()
		if ((v59 and v115.EnvelopingMist:IsReady() and (v121.FriendlyUnitsWithBuffCount(v115.EnvelopingMist, false, false, 41 - 16) < (206 - (11 + 192)))) or ((2090 + 2044) < (4101 - (135 + 40)))) then
			v29 = v121.FocusUnitRefreshableBuff(v115.EnvelopingMist, 4 - 2, 25 + 15, nil, false, 54 - 29, v115.EnvelopingMist);
			if (v29 or ((245 - 81) >= (2961 - (50 + 126)))) then
				return v29;
			end
			if (v24(v117.EnvelopingMistFocus, not v17:IsSpellInRange(v115.EnvelopingMist)) or ((1461 - 936) == (467 + 1642))) then
				return "Enveloping Mist YuLon";
			end
		end
		if (((1446 - (1233 + 180)) == (1002 - (522 + 447))) and v48 and v115.RisingSunKick:IsReady() and (v121.FriendlyUnitsWithBuffCount(v115.EnvelopingMist, false, false, 1446 - (107 + 1314)) > (1 + 1))) then
			if (((9305 - 6251) <= (1706 + 2309)) and v24(v115.RisingSunKick, not v15:IsInMeleeRange(9 - 4))) then
				return "Rising Sun Kick YuLon";
			end
		end
		if (((7402 - 5531) < (5292 - (716 + 1194))) and v61 and v115.SoothingMist:IsReady() and v17:BuffUp(v115.ChiHarmonyBuff) and v17:BuffDown(v115.SoothingMist)) then
			if (((23 + 1270) <= (233 + 1933)) and v24(v117.SoothingMistFocus, not v17:IsSpellInRange(v115.SoothingMist))) then
				return "Soothing Mist YuLon";
			end
		end
	end
	local function v132()
		if ((v46 and v115.BlackoutKick:IsReady() and (v13:BuffStack(v115.TeachingsoftheMonastery) >= (506 - (74 + 429)))) or ((4974 - 2395) < (61 + 62))) then
			if (v24(v115.BlackoutKick, not v15:IsInMeleeRange(11 - 6)) or ((599 + 247) >= (7300 - 4932))) then
				return "Blackout Kick ChiJi";
			end
		end
		if ((v59 and v115.EnvelopingMist:IsReady() and (v13:BuffStack(v115.InvokeChiJiBuff) == (7 - 4))) or ((4445 - (279 + 154)) <= (4136 - (454 + 324)))) then
			if (((1176 + 318) <= (3022 - (12 + 5))) and (v17:HealthPercentage() <= v60)) then
				if (v24(v117.EnvelopingMistFocus, not v17:IsSpellInRange(v115.EnvelopingMist)) or ((1678 + 1433) == (5437 - 3303))) then
					return "Enveloping Mist 3 Stacks ChiJi";
				end
			end
		end
		if (((871 + 1484) == (3448 - (277 + 816))) and v48 and v115.RisingSunKick:IsReady()) then
			if (v24(v115.RisingSunKick, not v15:IsInMeleeRange(21 - 16)) or ((1771 - (1058 + 125)) <= (81 + 351))) then
				return "Rising Sun Kick ChiJi";
			end
		end
		if (((5772 - (815 + 160)) >= (16712 - 12817)) and v59 and v115.EnvelopingMist:IsReady() and (v13:BuffStack(v115.InvokeChiJiBuff) >= (4 - 2))) then
			if (((854 + 2723) == (10456 - 6879)) and (v17:HealthPercentage() <= v60)) then
				if (((5692 - (41 + 1857)) > (5586 - (1222 + 671))) and v24(v117.EnvelopingMistFocus, not v17:IsSpellInRange(v115.EnvelopingMist))) then
					return "Enveloping Mist 2 Stacks ChiJi";
				end
			end
		end
		if ((v63 and v115.EssenceFont:IsReady() and v115.AncientTeachings:IsAvailable() and v13:BuffDown(v115.AncientTeachings)) or ((3295 - 2020) == (5893 - 1793))) then
			if (v24(v115.EssenceFont, nil) or ((2773 - (229 + 953)) >= (5354 - (1111 + 663)))) then
				return "Essence Font ChiJi";
			end
		end
	end
	local function v133()
		if (((2562 - (874 + 705)) <= (254 + 1554)) and v80 and v115.LifeCocoon:IsReady() and (v17:HealthPercentage() <= v81)) then
			if (v24(v117.LifeCocoonFocus, not v17:IsSpellInRange(v115.LifeCocoon)) or ((1467 + 683) <= (2487 - 1290))) then
				return "Life Cocoon CD";
			end
		end
		if (((107 + 3662) >= (1852 - (642 + 37))) and v82 and v115.Revival:IsReady() and v115.Revival:IsAvailable() and v121.AreUnitsBelowHealthPercentage(v84, v83, v115.EnvelopingMist)) then
			if (((339 + 1146) == (238 + 1247)) and v24(v115.Revival, nil)) then
				return "Revival CD";
			end
		end
		if ((v82 and v115.Restoral:IsReady() and v115.Restoral:IsAvailable() and v121.AreUnitsBelowHealthPercentage(v84, v83, v115.EnvelopingMist)) or ((8323 - 5008) <= (3236 - (233 + 221)))) then
			if (v24(v115.Restoral, nil) or ((2025 - 1149) >= (2609 + 355))) then
				return "Restoral CD";
			end
		end
		if ((v74 and v115.InvokeYulonTheJadeSerpent:IsAvailable() and v115.InvokeYulonTheJadeSerpent:IsReady() and (v121.AreUnitsBelowHealthPercentage(v76, v75, v115.EnvelopingMist) or v36)) or ((3773 - (718 + 823)) > (1572 + 925))) then
			local v189 = 805 - (266 + 539);
			while true do
				if ((v189 == (0 - 0)) or ((3335 - (636 + 589)) <= (787 - 455))) then
					if (((7602 - 3916) > (2514 + 658)) and v37 and v115.ManaTea:IsCastable() and not v13:BuffUp(v115.ManaTeaBuff)) then
						if (v24(v115.ManaTea, nil) or ((1626 + 2848) < (1835 - (657 + 358)))) then
							return "Mana Tea CD";
						end
					end
					if (((11329 - 7050) >= (6565 - 3683)) and v115.InvokeYulonTheJadeSerpent:IsReady() and (v115.RenewingMist:ChargesFractional() < (1188 - (1151 + 36))) and v13:BuffUp(v115.ManaTeaBuff) and (v115.SheilunsGift:TimeSinceLastCast() < ((4 + 0) * v13:GCD()))) then
						if (v24(v115.InvokeYulonTheJadeSerpent, nil) or ((534 + 1495) >= (10515 - 6994))) then
							return "Invoke Yu'lon GO";
						end
					end
					break;
				end
			end
		end
		if ((v115.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (1857 - (1552 + 280))) or ((2871 - (64 + 770)) >= (3152 + 1490))) then
			v29 = v131();
			if (((3904 - 2184) < (792 + 3666)) and v29) then
				return v29;
			end
		end
		if ((v77 and v115.InvokeChiJiTheRedCrane:IsReady() and v115.InvokeChiJiTheRedCrane:IsAvailable() and (v121.AreUnitsBelowHealthPercentage(v79, v78, v115.EnvelopingMist) or v36)) or ((1679 - (157 + 1086)) > (6046 - 3025))) then
			if (((3122 - 2409) <= (1299 - 452)) and v115.InvokeChiJiTheRedCrane:IsReady() and (v115.RenewingMist:ChargesFractional() < (1 - 0)) and v13:BuffUp(v115.AncientTeachings) and (v13:BuffStack(v115.TeachingsoftheMonastery) == (822 - (599 + 220))) and (v115.SheilunsGift:TimeSinceLastCast() < ((7 - 3) * v13:GCD()))) then
				if (((4085 - (1813 + 118)) <= (2947 + 1084)) and v24(v115.InvokeChiJiTheRedCrane, nil)) then
					return "Invoke Chi'ji GO";
				end
			end
		end
		if (((5832 - (841 + 376)) == (6466 - 1851)) and (v115.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (6 + 19))) then
			v29 = v132();
			if (v29 or ((10344 - 6554) == (1359 - (464 + 395)))) then
				return v29;
			end
		end
	end
	local function v134()
		v37 = EpicSettings.Settings['UseManaTea'];
		v38 = EpicSettings.Settings['ManaTeaStacks'];
		v39 = EpicSettings.Settings['UseThunderFocusTea'];
		v40 = EpicSettings.Settings['UseFortifyingBrew'];
		v41 = EpicSettings.Settings['FortifyingBrewHP'];
		v42 = EpicSettings.Settings['UseDampenHarm'];
		v43 = EpicSettings.Settings['DampenHarmHP'];
		v44 = EpicSettings.Settings['WhiteTigerUsage'];
		v45 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
		v46 = EpicSettings.Settings['UseBlackoutKick'];
		v47 = EpicSettings.Settings['UseSpinningCraneKick'];
		v48 = EpicSettings.Settings['UseRisingSunKick'];
		v49 = EpicSettings.Settings['UseTigerPalm'];
		v50 = EpicSettings.Settings['UseJadefireStomp'];
		v51 = EpicSettings.Settings['UseChiBurst'];
		v52 = EpicSettings.Settings['UseTouchOfDeath'];
		v53 = EpicSettings.Settings['UseRenewingMist'];
		v54 = EpicSettings.Settings['RenewingMistHP'];
		v55 = EpicSettings.Settings['UseExpelHarm'];
		v56 = EpicSettings.Settings['ExpelHarmHP'];
		v57 = EpicSettings.Settings['UseVivify'];
		v58 = EpicSettings.Settings['VivifyHP'];
		v59 = EpicSettings.Settings['UseEnvelopingMist'];
		v60 = EpicSettings.Settings['EnvelopingMistHP'];
		v61 = EpicSettings.Settings['UseSoothingMist'];
		v62 = EpicSettings.Settings['SoothingMistHP'];
		v63 = EpicSettings.Settings['UseEssenceFont'];
		v65 = EpicSettings.Settings['EssenceFontHP'];
		v64 = EpicSettings.Settings['EssenceFontGroup'];
		v67 = EpicSettings.Settings['UseJadeSerpent'];
		v66 = EpicSettings.Settings['JadeSerpentUsage'];
		v68 = EpicSettings.Settings['UseZenPulse'];
		v70 = EpicSettings.Settings['ZenPulseHP'];
		v69 = EpicSettings.Settings['ZenPulseGroup'];
		v71 = EpicSettings.Settings['UseSheilunsGift'];
		v73 = EpicSettings.Settings['SheilunsGiftHP'];
		v72 = EpicSettings.Settings['SheilunsGiftGroup'];
	end
	local function v135()
		local v179 = 0 - 0;
		while true do
			if (((43 + 46) < (1058 - (467 + 370))) and (v179 == (11 - 5))) then
				v84 = EpicSettings.Settings['RevivalHP'];
				v83 = EpicSettings.Settings['RevivalGroup'];
				break;
			end
			if (((1508 + 546) >= (4871 - 3450)) and (v179 == (1 + 3))) then
				v106 = EpicSettings.Settings['HandleCharredBrambles'];
				v105 = EpicSettings.Settings['HandleCharredTreant'];
				v107 = EpicSettings.Settings['HandleFyrakkNPC'];
				v74 = EpicSettings.Settings['UseInvokeYulon'];
				v76 = EpicSettings.Settings['InvokeYulonHP'];
				v75 = EpicSettings.Settings['InvokeYulonGroup'];
				v179 = 11 - 6;
			end
			if (((1212 - (150 + 370)) < (4340 - (74 + 1208))) and (v179 == (4 - 2))) then
				v108 = EpicSettings.Settings['useManaPotion'];
				v109 = EpicSettings.Settings['manaPotionSlider'];
				v110 = EpicSettings.Settings['RevivalBurstingGroup'];
				v111 = EpicSettings.Settings['RevivalBurstingStacks'];
				v93 = EpicSettings.Settings['InterruptThreshold'];
				v91 = EpicSettings.Settings['InterruptWithStun'];
				v179 = 14 - 11;
			end
			if ((v179 == (0 + 0)) or ((3644 - (14 + 376)) == (2870 - 1215))) then
				v97 = EpicSettings.Settings['racialsWithCD'];
				v96 = EpicSettings.Settings['useRacials'];
				v99 = EpicSettings.Settings['trinketsWithCD'];
				v98 = EpicSettings.Settings['useTrinkets'];
				v100 = EpicSettings.Settings['fightRemainsCheck'];
				v101 = EpicSettings.Settings['useWeapon'];
				v179 = 1 + 0;
			end
			if (((5 + 0) == v179) or ((1237 + 59) == (14386 - 9476))) then
				v77 = EpicSettings.Settings['UseInvokeChiJi'];
				v79 = EpicSettings.Settings['InvokeChiJiHP'];
				v78 = EpicSettings.Settings['InvokeChiJiGroup'];
				v80 = EpicSettings.Settings['UseLifeCocoon'];
				v81 = EpicSettings.Settings['LifeCocoonHP'];
				v82 = EpicSettings.Settings['UseRevival'];
				v179 = 5 + 1;
			end
			if (((3446 - (23 + 55)) == (7981 - 4613)) and ((3 + 0) == v179)) then
				v92 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v94 = EpicSettings.Settings['useSpearHandStrike'];
				v95 = EpicSettings.Settings['useLegSweep'];
				v102 = EpicSettings.Settings['handleAfflicted'];
				v103 = EpicSettings.Settings['HandleIncorporeal'];
				v104 = EpicSettings.Settings['HandleChromie'];
				v179 = 4 + 0;
			end
			if (((4097 - 1454) < (1201 + 2614)) and (v179 == (902 - (652 + 249)))) then
				v90 = EpicSettings.Settings['dispelDebuffs'];
				v87 = EpicSettings.Settings['useHealingPotion'];
				v88 = EpicSettings.Settings['healingPotionHP'];
				v89 = EpicSettings.Settings['HealingPotionName'];
				v85 = EpicSettings.Settings['useHealthstone'];
				v86 = EpicSettings.Settings['healthstoneHP'];
				v179 = 5 - 3;
			end
		end
	end
	local v136 = 1868 - (708 + 1160);
	local function v137()
		local v180 = 0 - 0;
		while true do
			if (((3487 - 1574) > (520 - (10 + 17))) and (v180 == (1 + 2))) then
				if (((6487 - (1400 + 332)) > (6575 - 3147)) and v13:IsDeadOrGhost()) then
					return;
				end
				v119 = v13:GetEnemiesInMeleeRange(1916 - (242 + 1666));
				if (((591 + 790) <= (869 + 1500)) and v31) then
					v120 = #v119;
				else
					v120 = 1 + 0;
				end
				v180 = 944 - (850 + 90);
			end
			if (((1 - 0) == v180) or ((6233 - (360 + 1030)) == (3615 + 469))) then
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v33 = EpicSettings.Toggles['dispel'];
				v180 = 5 - 3;
			end
			if (((6423 - 1754) > (2024 - (909 + 752))) and (v180 == (1223 - (109 + 1114)))) then
				v134();
				v135();
				v30 = EpicSettings.Toggles['ooc'];
				v180 = 1 - 0;
			end
			if (((1 + 1) == v180) or ((2119 - (6 + 236)) >= (1978 + 1160))) then
				v34 = EpicSettings.Toggles['healing'];
				v35 = EpicSettings.Toggles['dps'];
				v36 = EpicSettings.Toggles['ramp'];
				v180 = 3 + 0;
			end
			if (((11182 - 6440) >= (6333 - 2707)) and ((1138 - (1076 + 57)) == v180)) then
				if (v13:AffectingCombat() or v30 or ((747 + 3793) == (1605 - (579 + 110)))) then
					local v236 = 0 + 0;
					local v237;
					while true do
						if ((v236 == (0 + 0)) or ((614 + 542) > (4752 - (174 + 233)))) then
							v237 = v90 and v115.Detox:IsReady() and v33;
							v29 = v121.FocusUnit(v237, nil, 111 - 71, nil, 43 - 18, v115.EnvelopingMist);
							v236 = 1 + 0;
						end
						if (((3411 - (663 + 511)) < (3791 + 458)) and (v236 == (1 + 0))) then
							if (v29 or ((8271 - 5588) < (14 + 9))) then
								return v29;
							end
							if (((1640 - 943) <= (1999 - 1173)) and v33 and v90) then
								if (((528 + 577) <= (2288 - 1112)) and v17 and v17:Exists() and v17:IsAPlayer() and (v121.UnitHasDispellableDebuffByPlayer(v17) or v121.DispellableFriendlyUnit(18 + 7) or v121.UnitHasMagicDebuff(v17) or (v115.ImprovedDetox:IsAvailable() and (v121.UnitHasDiseaseDebuff(v17) or v121.UnitHasPoisonDebuff(v17))))) then
									if (((309 + 3070) <= (4534 - (478 + 244))) and v115.Detox:IsCastable()) then
										local v245 = 517 - (440 + 77);
										while true do
											if (((0 + 0) == v245) or ((2883 - 2095) >= (3172 - (655 + 901)))) then
												if (((344 + 1510) <= (2587 + 792)) and (v136 == (0 + 0))) then
													v136 = GetTime();
												end
												if (((18326 - 13777) == (5994 - (695 + 750))) and v121.Wait(1707 - 1207, v136)) then
													if (v24(v117.DetoxFocus, not v17:IsSpellInRange(v115.Detox)) or ((4663 - 1641) >= (12161 - 9137))) then
														return "detox dispel focus";
													end
													v136 = 351 - (285 + 66);
												end
												break;
											end
										end
									end
								end
								if (((11235 - 6415) > (3508 - (682 + 628))) and v16 and v16:Exists() and not v13:CanAttack(v16) and (v121.UnitHasDispellableDebuffByPlayer(v16) or v121.UnitHasMagicDebuff(v16) or (v115.ImprovedDetox:IsAvailable() and (v121.UnitHasDiseaseDebuff(v16) or v121.UnitHasPoisonDebuff(v16))))) then
									if (v115.Detox:IsCastable() or ((172 + 889) >= (5190 - (176 + 123)))) then
										if (((571 + 793) <= (3245 + 1228)) and v24(v117.DetoxMouseover, not v16:IsSpellInRange(v115.Detox))) then
											return "detox dispel mouseover";
										end
									end
								end
							end
							break;
						end
					end
				end
				if (not v13:AffectingCombat() or ((3864 - (239 + 30)) <= (1 + 2))) then
					if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((4491 + 181) == (6817 - 2965))) then
						local v240 = 0 - 0;
						local v241;
						while true do
							if (((1874 - (306 + 9)) == (5440 - 3881)) and ((0 + 0) == v240)) then
								v241 = v121.DeadFriendlyUnitsCount();
								if ((v241 > (1 + 0)) or ((844 + 908) <= (2253 - 1465))) then
									if (v24(v115.Reawaken, nil) or ((5282 - (1140 + 235)) == (113 + 64))) then
										return "reawaken";
									end
								elseif (((3183 + 287) > (143 + 412)) and v24(v117.ResuscitateMouseover, not v15:IsInRange(92 - (33 + 19)))) then
									return "resuscitate";
								end
								break;
							end
						end
					end
				end
				if ((not v13:AffectingCombat() and v30) or ((351 + 621) == (1933 - 1288))) then
					v29 = v126();
					if (((1402 + 1780) >= (4147 - 2032)) and v29) then
						return v29;
					end
				end
				v180 = 6 + 0;
			end
			if (((4582 - (586 + 103)) < (404 + 4025)) and (v180 == (12 - 8))) then
				if (v121.TargetIsValid() or v13:AffectingCombat() or ((4355 - (1309 + 179)) < (3439 - 1534))) then
					v114 = v13:GetEnemiesInRange(18 + 22);
					v112 = v10.BossFightRemains(nil, true);
					v113 = v112;
					if ((v113 == (29839 - 18728)) or ((1357 + 439) >= (8606 - 4555))) then
						v113 = v10.FightRemains(v114, false);
					end
				end
				v29 = v125();
				if (((3225 - 1606) <= (4365 - (295 + 314))) and v29) then
					return v29;
				end
				v180 = 12 - 7;
			end
			if (((2566 - (1300 + 662)) == (1896 - 1292)) and (v180 == (1761 - (1178 + 577)))) then
				if (v30 or v13:AffectingCombat() or ((2329 + 2155) == (2660 - 1760))) then
					local v238 = 1405 - (851 + 554);
					while true do
						if ((v238 == (0 + 0)) or ((12366 - 7907) <= (2417 - 1304))) then
							if (((3934 - (115 + 187)) > (2603 + 795)) and v32 and v101 and (v116.Dreambinder:IsEquippedAndReady() or v116.Iridal:IsEquippedAndReady())) then
								if (((3865 + 217) <= (19376 - 14459)) and v24(v117.UseWeapon, nil)) then
									return "Using Weapon Macro";
								end
							end
							if (((5993 - (160 + 1001)) >= (1213 + 173)) and v108 and v116.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v109)) then
								if (((95 + 42) == (279 - 142)) and v24(v117.ManaPotion, nil)) then
									return "Mana Potion main";
								end
							end
							v238 = 359 - (237 + 121);
						end
						if ((v238 == (899 - (525 + 372))) or ((2976 - 1406) >= (14233 - 9901))) then
							if ((v33 and v90) or ((4206 - (96 + 46)) <= (2596 - (643 + 134)))) then
								if ((v115.TigersLust:IsReady() and v121.UnitHasDebuffFromList(v13, v121.DispellableRootDebuffs) and v13:CanAttack(v15)) or ((1800 + 3186) < (3774 - 2200))) then
									if (((16432 - 12006) > (165 + 7)) and v24(v115.TigersLust, nil)) then
										return "Tigers Lust Roots";
									end
								end
							end
							if (((1149 - 563) > (930 - 475)) and v34) then
								local v243 = 719 - (316 + 403);
								while true do
									if (((550 + 276) == (2270 - 1444)) and (v243 == (2 + 1))) then
										v29 = v129();
										if (v29 or ((10121 - 6102) > (3148 + 1293))) then
											return v29;
										end
										break;
									end
									if (((651 + 1366) < (14764 - 10503)) and ((0 - 0) == v243)) then
										if (((9797 - 5081) > (5 + 75)) and v115.SummonJadeSerpentStatue:IsReady() and v115.SummonJadeSerpentStatue:IsAvailable() and (v115.SummonJadeSerpentStatue:TimeSinceLastCast() > (177 - 87)) and v67) then
											if ((v66 == "Player") or ((172 + 3335) == (9626 - 6354))) then
												if (v24(v117.SummonJadeSerpentStatuePlayer, not v15:IsInRange(57 - (12 + 5))) or ((3402 - 2526) >= (6560 - 3485))) then
													return "jade serpent main player";
												end
											elseif (((9250 - 4898) > (6333 - 3779)) and (v66 == "Cursor")) then
												if (v24(v117.SummonJadeSerpentStatueCursor, not v15:IsInRange(9 + 31)) or ((6379 - (1656 + 317)) < (3603 + 440))) then
													return "jade serpent main cursor";
												end
											elseif ((v66 == "Confirmation") or ((1514 + 375) >= (8995 - 5612))) then
												if (((9311 - 7419) <= (3088 - (5 + 349))) and v24(v115.SummonJadeSerpentStatue, not v15:IsInRange(189 - 149))) then
													return "jade serpent main confirmation";
												end
											end
										end
										if (((3194 - (266 + 1005)) < (1462 + 756)) and v53 and v115.RenewingMist:IsReady() and v15:BuffDown(v115.RenewingMistBuff) and not v13:CanAttack(v15)) then
											if (((7414 - 5241) > (498 - 119)) and (v15:HealthPercentage() <= v54)) then
												if (v24(v115.RenewingMist, not v15:IsSpellInRange(v115.RenewingMist)) or ((4287 - (561 + 1135)) == (4441 - 1032))) then
													return "RenewingMist main";
												end
											end
										end
										v243 = 3 - 2;
									end
									if (((5580 - (507 + 559)) > (8340 - 5016)) and (v243 == (3 - 2))) then
										if ((v61 and v115.SoothingMist:IsReady() and v15:BuffDown(v115.SoothingMist) and not v13:CanAttack(v15)) or ((596 - (212 + 176)) >= (5733 - (250 + 655)))) then
											if ((v15:HealthPercentage() <= v62) or ((4316 - 2733) > (6232 - 2665))) then
												if (v24(v115.SoothingMist, not v15:IsSpellInRange(v115.SoothingMist)) or ((2053 - 740) == (2750 - (1869 + 87)))) then
													return "SoothingMist main";
												end
											end
										end
										if (((11008 - 7834) > (4803 - (484 + 1417))) and v37 and (v13:BuffStack(v115.ManaTeaCharges) >= (38 - 20)) and v115.ManaTea:IsCastable() and not v121.AreUnitsBelowHealthPercentage(142 - 57, 776 - (48 + 725), v115.EnvelopingMist)) then
											if (((6730 - 2610) <= (11429 - 7169)) and v24(v115.ManaTea, nil)) then
												return "Mana Tea main avoid overcap";
											end
										end
										v243 = 2 + 0;
									end
									if ((v243 == (4 - 2)) or ((248 + 635) > (1393 + 3385))) then
										if (((v113 > v100) and v32 and v13:AffectingCombat()) or ((4473 - (152 + 701)) >= (6202 - (430 + 881)))) then
											local v246 = 0 + 0;
											while true do
												if (((5153 - (557 + 338)) > (277 + 660)) and (v246 == (0 - 0))) then
													v29 = v133();
													if (v29 or ((17049 - 12180) < (2406 - 1500))) then
														return v29;
													end
													break;
												end
											end
										end
										if (v31 or ((2639 - 1414) > (5029 - (499 + 302)))) then
											local v247 = 866 - (39 + 827);
											while true do
												if (((9186 - 5858) > (4997 - 2759)) and (v247 == (0 - 0))) then
													v29 = v130();
													if (((5893 - 2054) > (121 + 1284)) and v29) then
														return v29;
													end
													break;
												end
											end
										end
										v243 = 8 - 5;
									end
								end
							end
							break;
						end
						if ((v238 == (1 + 0)) or ((2045 - 752) <= (611 - (103 + 1)))) then
							if ((v13:DebuffStack(v115.Bursting) > (559 - (475 + 79))) or ((6260 - 3364) < (2576 - 1771))) then
								if (((300 + 2016) == (2039 + 277)) and v115.DiffuseMagic:IsReady() and v115.DiffuseMagic:IsAvailable()) then
									if (v24(v115.DiffuseMagic, nil) or ((4073 - (1395 + 108)) == (4460 - 2927))) then
										return "Diffues Magic Bursting Player";
									end
								end
							end
							if (((v115.Bursting:MaxDebuffStack() > v111) and (v115.Bursting:AuraActiveCount() > v110)) or ((2087 - (7 + 1197)) == (637 + 823))) then
								if ((v82 and v115.Revival:IsReady() and v115.Revival:IsAvailable()) or ((1612 + 3007) <= (1318 - (27 + 292)))) then
									if (v24(v115.Revival, nil) or ((9992 - 6582) > (5248 - 1132))) then
										return "Revival Bursting";
									end
								end
							end
							v238 = 8 - 6;
						end
					end
				end
				if (((v30 or v13:AffectingCombat()) and v121.TargetIsValid() and v13:CanAttack(v15) and not v15:IsDeadOrGhost()) or ((1780 - 877) >= (5825 - 2766))) then
					v29 = v124();
					if (v29 or ((4115 - (43 + 96)) < (11653 - 8796))) then
						return v29;
					end
					if (((11146 - 6216) > (1915 + 392)) and v98 and ((v32 and v99) or not v99)) then
						v29 = v121.HandleTopTrinket(v118, v32, 12 + 28, nil);
						if (v29 or ((7996 - 3950) < (495 + 796))) then
							return v29;
						end
						v29 = v121.HandleBottomTrinket(v118, v32, 74 - 34, nil);
						if (v29 or ((1336 + 2905) == (260 + 3285))) then
							return v29;
						end
					end
					if (v35 or ((5799 - (1414 + 337)) > (6172 - (1642 + 298)))) then
						local v242 = 0 - 0;
						while true do
							if ((v242 == (2 - 1)) or ((5193 - 3443) >= (1143 + 2330))) then
								if (((2464 + 702) == (4138 - (357 + 615))) and (v120 >= (3 + 0)) and v31) then
									local v244 = 0 - 0;
									while true do
										if (((1511 + 252) < (7980 - 4256)) and (v244 == (0 + 0))) then
											v29 = v127();
											if (((4 + 53) <= (1712 + 1011)) and v29) then
												return v29;
											end
											break;
										end
									end
								end
								if ((v120 < (1304 - (384 + 917))) or ((2767 - (128 + 569)) == (1986 - (1407 + 136)))) then
									v29 = v128();
									if (v29 or ((4592 - (687 + 1200)) == (3103 - (556 + 1154)))) then
										return v29;
									end
								end
								break;
							end
							if ((v242 == (0 - 0)) or ((4696 - (9 + 86)) < (482 - (275 + 146)))) then
								if ((v96 and ((v32 and v97) or not v97) and (v113 < (3 + 15))) or ((1454 - (29 + 35)) >= (21025 - 16281))) then
									if (v115.BloodFury:IsCastable() or ((5982 - 3979) > (16925 - 13091))) then
										if (v24(v115.BloodFury, nil) or ((102 + 54) > (4925 - (53 + 959)))) then
											return "blood_fury main 4";
										end
									end
									if (((603 - (312 + 96)) == (338 - 143)) and v115.Berserking:IsCastable()) then
										if (((3390 - (147 + 138)) >= (2695 - (813 + 86))) and v24(v115.Berserking, nil)) then
											return "berserking main 6";
										end
									end
									if (((3958 + 421) >= (3948 - 1817)) and v115.LightsJudgment:IsCastable()) then
										if (((4336 - (18 + 474)) >= (690 + 1353)) and v24(v115.LightsJudgment, not v15:IsInRange(130 - 90))) then
											return "lights_judgment main 8";
										end
									end
									if (v115.Fireblood:IsCastable() or ((4318 - (860 + 226)) <= (3034 - (121 + 182)))) then
										if (((604 + 4301) == (6145 - (988 + 252))) and v24(v115.Fireblood, nil)) then
											return "fireblood main 10";
										end
									end
									if (v115.AncestralCall:IsCastable() or ((468 + 3668) >= (1382 + 3029))) then
										if (v24(v115.AncestralCall, nil) or ((4928 - (49 + 1921)) == (4907 - (223 + 667)))) then
											return "ancestral_call main 12";
										end
									end
									if (((1280 - (51 + 1)) >= (1399 - 586)) and v115.BagofTricks:IsCastable()) then
										if (v24(v115.BagofTricks, not v15:IsInRange(85 - 45)) or ((4580 - (146 + 979)) > (1144 + 2906))) then
											return "bag_of_tricks main 14";
										end
									end
								end
								if (((848 - (311 + 294)) == (677 - 434)) and v39 and v115.ThunderFocusTea:IsReady() and (not v115.EssenceFont:IsAvailable() or not v121.AreUnitsBelowHealthPercentage(v65, v64, v115.EnvelopingMist)) and (v115.RisingSunKick:CooldownRemains() < v13:GCD())) then
									if (v24(v115.ThunderFocusTea, nil) or ((115 + 156) > (3015 - (496 + 947)))) then
										return "ThunderFocusTea main 16";
									end
								end
								v242 = 1359 - (1233 + 125);
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v138()
		v123();
		v115.Bursting:RegisterAuraTracking();
		v22.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(110 + 160, v137, v138);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

