local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (886 - (283 + 603))) or ((1060 + 543) <= (376 + 300))) then
			v6 = v0[v4];
			if (((2467 + 966) <= (3473 + 663)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((4678 - (153 + 280)) <= (13372 - 8741)) and (v5 == (1 + 0))) then
			return v6(...);
		end
	end
end
v0["Epix_Warrior_Arms.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Player;
	local v15 = v12.Target;
	local v16 = v12.TargetTarget;
	local v17 = v12.Focus;
	local v18 = v10.Spell;
	local v19 = v10.Item;
	local v20 = EpicLib;
	local v21 = v20.Bind;
	local v22 = v20.Cast;
	local v23 = v20.Macro;
	local v24 = v20.Press;
	local v25 = v20.Commons.Everyone.num;
	local v26 = v20.Commons.Everyone.bool;
	local v27;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31;
	local v32;
	local v33;
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
	local v93 = v10.Commons.Everyone;
	local v94 = v14:GetEquipment();
	local v95 = (v94[6 + 7] and v19(v94[7 + 6])) or v19(0 + 0);
	local v96 = (v94[11 + 3] and v19(v94[20 - 6])) or v19(0 + 0);
	local v97 = v18.Warrior.Arms;
	local v98 = v19.Warrior.Arms;
	local v99 = v23.Warrior.Arms;
	local v100 = {};
	local v101;
	local v102 = 11778 - (89 + 578);
	local v103 = 7938 + 3173;
	v10:RegisterForEvent(function()
		v102 = 23099 - 11988;
		v103 = 12160 - (572 + 477);
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v123 = 0 + 0;
		while true do
			if (((2567 + 1709) >= (468 + 3446)) and ((87 - (84 + 2)) == v123)) then
				v96 = (v94[22 - 8] and v19(v94[11 + 3])) or v19(842 - (497 + 345));
				break;
			end
			if (((6 + 192) <= (738 + 3627)) and (v123 == (1333 - (605 + 728)))) then
				v94 = v14:GetEquipment();
				v95 = (v94[10 + 3] and v19(v94[28 - 15])) or v19(0 + 0);
				v123 = 3 - 2;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v104;
	local v105;
	local function v106()
		local v124 = UnitGetTotalAbsorbs(v15:ID());
		if (((4311 + 471) > (12955 - 8279)) and (v124 > (0 + 0))) then
			return true;
		else
			return false;
		end
	end
	local function v107(v125)
		return (v125:HealthPercentage() > (509 - (457 + 32))) or (v97.Massacre:IsAvailable() and (v125:HealthPercentage() < (15 + 20)));
	end
	local function v108(v126)
		return (v126:DebuffStack(v97.ExecutionersPrecisionDebuff) == (1404 - (832 + 570))) or (v126:DebuffRemains(v97.DeepWoundsDebuff) <= v14:GCD()) or (v97.Dreadnaught:IsAvailable() and v97.Battlelord:IsAvailable() and (v105 <= (2 + 0)));
	end
	local function v109(v127)
		return v14:BuffUp(v97.SuddenDeathBuff) or ((v105 <= (1 + 1)) and ((v127:HealthPercentage() < (70 - 50)) or (v97.Massacre:IsAvailable() and (v127:HealthPercentage() < (17 + 18))))) or v14:BuffUp(v97.SweepingStrikes);
	end
	local function v110()
		local v128 = 796 - (588 + 208);
		while true do
			if (((13109 - 8245) > (3997 - (884 + 916))) and (v128 == (6 - 3))) then
				if ((v97.BattleStance:IsCastable() and v14:BuffDown(v97.BattleStance, true) and v68 and (v14:HealthPercentage() > v81)) or ((2146 + 1554) == (3160 - (232 + 421)))) then
					if (((6363 - (1569 + 320)) >= (68 + 206)) and v24(v97.BattleStance)) then
						return "battle_stance after defensive stance defensive";
					end
				end
				if ((v98.Healthstone:IsReady() and v69 and (v14:HealthPercentage() <= v79)) or ((360 + 1534) <= (4737 - 3331))) then
					if (((2177 - (316 + 289)) >= (4007 - 2476)) and v24(v99.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				v128 = 1 + 3;
			end
			if ((v128 == (1455 - (666 + 787))) or ((5112 - (360 + 65)) < (4245 + 297))) then
				if (((3545 - (79 + 175)) > (2628 - 961)) and v97.Intervene:IsCastable() and v67 and (v17:HealthPercentage() <= v77) and (v17:UnitName() ~= v14:UnitName())) then
					if (v24(v99.InterveneFocus) or ((682 + 191) == (6234 - 4200))) then
						return "intervene defensive";
					end
				end
				if ((v97.DefensiveStance:IsCastable() and v14:BuffDown(v97.DefensiveStance, true) and v68 and (v14:HealthPercentage() <= v78)) or ((5422 - 2606) < (910 - (503 + 396)))) then
					if (((3880 - (92 + 89)) < (9128 - 4422)) and v24(v97.DefensiveStance)) then
						return "defensive_stance defensive";
					end
				end
				v128 = 2 + 1;
			end
			if (((1567 + 1079) >= (3430 - 2554)) and (v128 == (0 + 0))) then
				if (((1399 - 785) <= (2779 + 405)) and v97.BitterImmunity:IsReady() and v63 and (v14:HealthPercentage() <= v72)) then
					if (((1494 + 1632) == (9520 - 6394)) and v24(v97.BitterImmunity)) then
						return "bitter_immunity defensive";
					end
				end
				if ((v97.DieByTheSword:IsCastable() and v64 and (v14:HealthPercentage() <= v73)) or ((273 + 1914) >= (7554 - 2600))) then
					if (v24(v97.DieByTheSword) or ((5121 - (485 + 759)) == (8272 - 4697))) then
						return "die_by_the_sword defensive";
					end
				end
				v128 = 1190 - (442 + 747);
			end
			if (((1842 - (832 + 303)) > (1578 - (88 + 858))) and ((2 + 2) == v128)) then
				if ((v70 and (v14:HealthPercentage() <= v80)) or ((452 + 94) >= (111 + 2573))) then
					local v188 = 789 - (766 + 23);
					while true do
						if (((7232 - 5767) <= (5882 - 1581)) and (v188 == (0 - 0))) then
							if (((5783 - 4079) > (2498 - (1036 + 37))) and (v86 == "Refreshing Healing Potion")) then
								if (v98.RefreshingHealingPotion:IsReady() or ((488 + 199) == (8244 - 4010))) then
									if (v24(v99.RefreshingHealingPotion) or ((2620 + 710) < (2909 - (641 + 839)))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((2060 - (910 + 3)) >= (854 - 519)) and (v86 == "Dreamwalker's Healing Potion")) then
								if (((5119 - (1466 + 218)) > (964 + 1133)) and v98.DreamwalkersHealingPotion:IsReady()) then
									if (v24(v99.RefreshingHealingPotion) or ((4918 - (556 + 592)) >= (1437 + 2604))) then
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
			if ((v128 == (809 - (329 + 479))) or ((4645 - (174 + 680)) <= (5535 - 3924))) then
				if ((v97.IgnorePain:IsCastable() and v65 and (v14:HealthPercentage() <= v74)) or ((9488 - 4910) <= (1434 + 574))) then
					if (((1864 - (396 + 343)) <= (184 + 1892)) and v24(v97.IgnorePain, nil, nil, true)) then
						return "ignore_pain defensive";
					end
				end
				if ((v97.RallyingCry:IsCastable() and v66 and v14:BuffDown(v97.AspectsFavorBuff) and v14:BuffDown(v97.RallyingCry) and (((v14:HealthPercentage() <= v75) and v93.IsSoloMode()) or v93.AreUnitsBelowHealthPercentage(v75, v76))) or ((2220 - (29 + 1448)) >= (5788 - (135 + 1254)))) then
					if (((4351 - 3196) < (7811 - 6138)) and v24(v97.RallyingCry)) then
						return "rallying_cry defensive";
					end
				end
				v128 = 2 + 0;
			end
		end
	end
	local function v111()
		local v129 = 1527 - (389 + 1138);
		while true do
			if ((v129 == (575 - (102 + 472))) or ((2194 + 130) <= (321 + 257))) then
				v27 = v93.HandleBottomTrinket(v100, v30, 38 + 2, nil);
				if (((5312 - (320 + 1225)) == (6705 - 2938)) and v27) then
					return v27;
				end
				break;
			end
			if (((2502 + 1587) == (5553 - (157 + 1307))) and ((1859 - (821 + 1038)) == v129)) then
				v27 = v93.HandleTopTrinket(v100, v30, 99 - 59, nil);
				if (((488 + 3970) >= (2973 - 1299)) and v27) then
					return v27;
				end
				v129 = 1 + 0;
			end
		end
	end
	local function v112()
		if (((2408 - 1436) <= (2444 - (834 + 192))) and v101) then
			local v137 = 0 + 0;
			while true do
				if ((v137 == (0 + 0)) or ((107 + 4831) < (7376 - 2614))) then
					if ((v97.Skullsplitter:IsCastable() and v44) or ((2808 - (300 + 4)) > (1139 + 3125))) then
						if (((5635 - 3482) == (2515 - (112 + 250))) and v24(v97.Skullsplitter)) then
							return "skullsplitter precombat";
						end
					end
					if (((v90 < v103) and v97.ColossusSmash:IsCastable() and v36 and ((v54 and v30) or not v54)) or ((203 + 304) >= (6490 - 3899))) then
						if (((2568 + 1913) == (2318 + 2163)) and v24(v97.ColossusSmash)) then
							return "colossus_smash precombat";
						end
					end
					v137 = 1 + 0;
				end
				if ((v137 == (1 + 0)) or ((1730 + 598) < (2107 - (1001 + 413)))) then
					if (((9651 - 5323) == (5210 - (244 + 638))) and (v90 < v103) and v97.Warbreaker:IsCastable() and v49 and ((v57 and v30) or not v57)) then
						if (((2281 - (627 + 66)) >= (3968 - 2636)) and v24(v97.Warbreaker)) then
							return "warbreaker precombat";
						end
					end
					if ((v97.Overpower:IsCastable() and v40) or ((4776 - (512 + 90)) > (6154 - (1665 + 241)))) then
						if (v24(v97.Overpower) or ((5303 - (373 + 344)) <= (37 + 45))) then
							return "overpower precombat";
						end
					end
					break;
				end
			end
		end
		if (((1023 + 2840) == (10189 - 6326)) and v34 and v97.Charge:IsCastable()) then
			if (v24(v97.Charge) or ((476 - 194) <= (1141 - (35 + 1064)))) then
				return "charge precombat";
			end
		end
	end
	local function v113()
		local v130 = 0 + 0;
		while true do
			if (((9860 - 5251) >= (4 + 762)) and (v130 == (1239 - (298 + 938)))) then
				if (((v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable() and (((v105 > (1260 - (233 + 1026))) and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or ((v105 > (1667 - (636 + 1030))) and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (0 + 0))))) or ((1126 + 26) == (740 + 1748))) then
					if (((232 + 3190) > (3571 - (55 + 166))) and v24(v97.Bladestorm, not v101)) then
						return "bladestorm hac 78";
					end
				end
				if (((170 + 707) > (38 + 338)) and v97.Cleave:IsReady() and v35 and ((v105 > (7 - 5)) or (not v97.Battlelord:IsAvailable() and v14:BuffUp(v97.MercilessBonegrinderBuff) and (v97.MortalStrike:CooldownRemains() > v14:GCD())))) then
					if (v24(v97.Cleave, not v101) or ((3415 - (36 + 261)) <= (3236 - 1385))) then
						return "cleave hac 79";
					end
				end
				if ((v97.Whirlwind:IsReady() and v50 and ((v105 > (1370 - (34 + 1334))) or (v97.StormofSwords:IsAvailable() and (v14:BuffUp(v97.MercilessBonegrinderBuff) or v14:BuffUp(v97.HurricaneBuff))))) or ((64 + 101) >= (2714 + 778))) then
					if (((5232 - (1035 + 248)) < (4877 - (20 + 1))) and v24(v97.Whirlwind, not v15:IsInMeleeRange(5 + 3))) then
						return "whirlwind hac 80";
					end
				end
				if ((v97.Skullsplitter:IsCastable() and v44 and ((v14:Rage() < (359 - (134 + 185))) or (v97.TideofBlood:IsAvailable() and (v15:DebuffRemains(v97.RendDebuff) > (1133 - (549 + 584))) and ((v14:BuffUp(v97.SweepingStrikes) and (v105 > (687 - (314 + 371)))) or v15:DebuffUp(v97.ColossusSmashDebuff) or v14:BuffUp(v97.TestofMightBuff))))) or ((14679 - 10403) < (3984 - (478 + 490)))) then
					if (((2485 + 2205) > (5297 - (786 + 386))) and v24(v97.Skullsplitter, not v15:IsInMeleeRange(25 - 17))) then
						return "sweeping_strikes execute 81";
					end
				end
				v130 = 1383 - (1055 + 324);
			end
			if ((v130 == (1347 - (1093 + 247))) or ((45 + 5) >= (95 + 801))) then
				if ((v97.Whirlwind:IsReady() and v50 and (v97.StormofSwords:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 > (3 - 2))))) or ((5816 - 4102) >= (8416 - 5458))) then
					if (v24(v97.Whirlwind, not v15:IsInMeleeRange(19 - 11)) or ((531 + 960) < (2480 - 1836))) then
						return "whirlwind hac 93";
					end
				end
				if (((2426 - 1722) < (745 + 242)) and v97.Cleave:IsReady() and v35 and not v97.CrushingForce:IsAvailable()) then
					if (((9508 - 5790) > (2594 - (364 + 324))) and v24(v97.Cleave, not v101)) then
						return "cleave hac 94";
					end
				end
				if ((v97.IgnorePain:IsReady() and v65 and v97.Battlelord:IsAvailable() and v97.AngerManagement:IsAvailable() and (v14:Rage() > (82 - 52)) and ((v15:HealthPercentage() < (47 - 27)) or (v97.Massacre:IsAvailable() and (v15:HealthPercentage() < (12 + 23))))) or ((4008 - 3050) > (5821 - 2186))) then
					if (((10632 - 7131) <= (5760 - (1249 + 19))) and v24(v97.IgnorePain, not v101)) then
						return "ignore_pain hac 95";
					end
				end
				if ((v97.Slam:IsReady() and v45 and v97.CrushingForce:IsAvailable() and (v14:Rage() > (28 + 2)) and ((v97.FervorofBattle:IsAvailable() and (v105 == (3 - 2))) or not v97.FervorofBattle:IsAvailable())) or ((4528 - (686 + 400)) < (2000 + 548))) then
					if (((3104 - (73 + 156)) >= (7 + 1457)) and v24(v97.Slam, not v101)) then
						return "slam hac 96";
					end
				end
				v130 = 819 - (721 + 90);
			end
			if ((v130 == (1 + 4)) or ((15575 - 10778) >= (5363 - (224 + 246)))) then
				if (((v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable()) or ((892 - 341) > (3807 - 1739))) then
					if (((384 + 1730) > (23 + 921)) and v24(v97.ThunderousRoar, not v15:IsInMeleeRange(6 + 2))) then
						return "thunderous_roar hac 85";
					end
				end
				if ((v97.Shockwave:IsCastable() and v43 and (v105 > (3 - 1)) and (v97.SonicBoom:IsAvailable() or v15:IsCasting())) or ((7527 - 5265) >= (3609 - (203 + 310)))) then
					if (v24(v97.Shockwave, not v15:IsInMeleeRange(2001 - (1238 + 755))) or ((158 + 2097) >= (5071 - (709 + 825)))) then
						return "shockwave hac 86";
					end
				end
				if ((v97.Overpower:IsCastable() and v40 and (v105 == (1 - 0)) and (((v97.Overpower:Charges() == (2 - 0)) and not v97.Battlelord:IsAvailable() and (v15:Debuffdown(v97.ColossusSmashDebuff) or (v14:RagePercentage() < (889 - (196 + 668))))) or v97.Battlelord:IsAvailable())) or ((15149 - 11312) < (2705 - 1399))) then
					if (((3783 - (171 + 662)) == (3043 - (4 + 89))) and v24(v97.Overpower, not v101)) then
						return "overpower hac 87";
					end
				end
				if ((v97.Slam:IsReady() and v45 and (v105 == (3 - 2)) and not v97.Battlelord:IsAvailable() and (v14:RagePercentage() > (26 + 44))) or ((20744 - 16021) < (1294 + 2004))) then
					if (((2622 - (35 + 1451)) >= (1607 - (28 + 1425))) and v24(v97.Slam, not v101)) then
						return "slam hac 88";
					end
				end
				v130 = 1999 - (941 + 1052);
			end
			if ((v130 == (4 + 0)) or ((1785 - (822 + 692)) > (6778 - 2030))) then
				if (((2233 + 2507) >= (3449 - (45 + 252))) and v97.MortalStrike:IsReady() and v39 and v14:BuffUp(v97.SweepingStrikes) and (v14:BuffStack(v97.CrushingAdvanceBuff) == (3 + 0))) then
					if (v24(v97.MortalStrike, not v101) or ((888 + 1690) >= (8250 - 4860))) then
						return "mortal_strike hac 81.5";
					end
				end
				if (((474 - (114 + 319)) <= (2384 - 723)) and v97.Overpower:IsCastable() and v40 and v14:BuffUp(v97.SweepingStrikes) and v97.Dreadnaught:IsAvailable()) then
					if (((769 - 168) < (2270 + 1290)) and v24(v97.Overpower, not v101)) then
						return "overpower hac 82";
					end
				end
				if (((350 - 115) < (1439 - 752)) and v97.MortalStrike:IsReady() and v39) then
					if (((6512 - (556 + 1407)) > (2359 - (741 + 465))) and v93.CastCycle(v97.MortalStrike, v104, v108, not v101)) then
						return "mortal_strike hac 83";
					end
					if (v24(v97.MortalStrike, not v101) or ((5139 - (170 + 295)) < (2462 + 2210))) then
						return "mortal_strike hac 83";
					end
				end
				if (((3370 + 298) < (11229 - 6668)) and v97.Execute:IsReady() and v37 and (v14:BuffUp(v97.SuddenDeathBuff) or ((v105 <= (2 + 0)) and ((v15:HealthPercentage() < (13 + 7)) or (v97.Massacre:IsAvailable() and (v15:HealthPercentage() < (20 + 15))))) or v14:BuffUp(v97.SweepingStrikes))) then
					local v189 = 1230 - (957 + 273);
					while true do
						if ((v189 == (0 + 0)) or ((183 + 272) == (13736 - 10131))) then
							if (v93.CastCycle(v97.Execute, v104, v109, not v101) or ((7017 - 4354) == (10116 - 6804))) then
								return "execute hac 84";
							end
							if (((21178 - 16901) <= (6255 - (389 + 1391))) and v24(v97.Execute, not v101)) then
								return "execute hac 84";
							end
							break;
						end
					end
				end
				v130 = 4 + 1;
			end
			if (((0 + 0) == v130) or ((1980 - 1110) == (2140 - (783 + 168)))) then
				if (((5211 - 3658) <= (3082 + 51)) and v97.Execute:IsReady() and v37 and v14:BuffUp(v97.JuggernautBuff) and (v14:BuffRemains(v97.JuggernautBuff) < v14:GCD())) then
					if (v24(v97.Execute, not v101) or ((2548 - (309 + 2)) >= (10781 - 7270))) then
						return "execute hac 67";
					end
				end
				if ((v97.ThunderClap:IsReady() and v47 and (v105 > (1214 - (1090 + 122))) and v97.BloodandThunder:IsAvailable() and v97.Rend:IsAvailable() and v15:DebuffRefreshable(v97.RendDebuff)) or ((430 + 894) > (10142 - 7122))) then
					if (v24(v97.ThunderClap, not v101) or ((2048 + 944) == (2999 - (628 + 490)))) then
						return "thunder_clap hac 68";
					end
				end
				if (((557 + 2549) > (3777 - 2251)) and v97.SweepingStrikes:IsCastable() and v46 and (v105 >= (9 - 7)) and ((v97.Bladestorm:CooldownRemains() > (789 - (431 + 343))) or not v97.Bladestorm:IsAvailable())) then
					if (((6105 - 3082) < (11195 - 7325)) and v24(v97.SweepingStrikes, not v15:IsInMeleeRange(7 + 1))) then
						return "sweeping_strikes hac 68";
					end
				end
				if (((19 + 124) > (1769 - (556 + 1139))) and ((v97.Rend:IsReady() and v41 and (v105 == (16 - (6 + 9))) and ((v15:HealthPercentage() > (4 + 16)) or (v97.Massacre:IsAvailable() and (v15:HealthPercentage() < (18 + 17))))) or (v97.TideofBlood:IsAvailable() and (v97.Skullsplitter:CooldownRemains() <= v14:GCD()) and ((v97.ColossusSmash:CooldownRemains() < v14:GCD()) or v15:DebuffUp(v97.ColossusSmashDebuff)) and (v15:DebuffRemains(v97.RendDebuff) < ((190 - (28 + 141)) * (0.85 + 0)))))) then
					if (((21 - 3) < (1496 + 616)) and v24(v97.Rend, not v101)) then
						return "rend hac 70";
					end
				end
				v130 = 1318 - (486 + 831);
			end
			if (((2854 - 1757) <= (5731 - 4103)) and (v130 == (2 + 4))) then
				if (((14639 - 10009) == (5893 - (668 + 595))) and v97.Overpower:IsCastable() and v40 and (((v97.Overpower:Charges() == (2 + 0)) and (not v97.TestofMight:IsAvailable() or (v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)) or v97.Battlelord:IsAvailable())) or (v14:Rage() < (15 + 55)))) then
					if (((9653 - 6113) > (2973 - (23 + 267))) and v24(v97.Overpower, not v101)) then
						return "overpower hac 89";
					end
				end
				if (((6738 - (1129 + 815)) >= (3662 - (371 + 16))) and v97.ThunderClap:IsReady() and v47 and (v105 > (1752 - (1326 + 424)))) then
					if (((2810 - 1326) == (5422 - 3938)) and v24(v97.ThunderClap, not v101)) then
						return "thunder_clap hac 90";
					end
				end
				if (((1550 - (88 + 30)) < (4326 - (720 + 51))) and v97.MortalStrike:IsReady() and v39) then
					if (v24(v97.MortalStrike, not v101) or ((2369 - 1304) > (5354 - (421 + 1355)))) then
						return "mortal_strike hac 91";
					end
				end
				if ((v97.Rend:IsReady() and v41 and (v105 == (1 - 0)) and v15:DebuffRefreshable(v97.RendDebuff)) or ((2356 + 2439) < (2490 - (286 + 797)))) then
					if (((6773 - 4920) < (7971 - 3158)) and v24(v97.Rend, not v101)) then
						return "rend hac 92";
					end
				end
				v130 = 446 - (397 + 42);
			end
			if ((v130 == (3 + 5)) or ((3621 - (24 + 776)) < (3744 - 1313))) then
				if ((v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable())) or ((3659 - (222 + 563)) < (4805 - 2624))) then
					if (v24(v97.Shockwave, not v15:IsInMeleeRange(6 + 2)) or ((2879 - (23 + 167)) <= (2141 - (690 + 1108)))) then
						return "shockwave hac 97";
					end
				end
				if ((v30 and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable()) or ((675 + 1194) == (1658 + 351))) then
					if (v24(v97.Bladestorm, not v101) or ((4394 - (40 + 808)) < (383 + 1939))) then
						return "bladestorm hac 98";
					end
				end
				break;
			end
			if ((v130 == (7 - 5)) or ((1990 + 92) == (2526 + 2247))) then
				if (((1779 + 1465) > (1626 - (47 + 524))) and (v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)) or ((v105 > (1 + 0)) and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (0 - 0))))) then
					if (v24(v97.ThunderousRoar, not v15:IsInMeleeRange(11 - 3)) or ((7555 - 4242) <= (3504 - (1165 + 561)))) then
						return "thunderous_roar hac 75";
					end
				end
				if (((v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "player") and v97.ChampionsSpear:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or ((43 + 1378) >= (6516 - 4412))) then
					if (((692 + 1120) <= (3728 - (341 + 138))) and v24(v99.ChampionsSpearPlayer, not v15:IsSpellInRange(v97.ChampionsSpear))) then
						return "spear_of_bastion hac 76";
					end
				end
				if (((439 + 1184) <= (4038 - 2081)) and (v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "cursor") and v97.ChampionsSpear:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) then
					if (((4738 - (89 + 237)) == (14193 - 9781)) and v24(v99.ChampionsSpearCursor, not v15:IsSpellInRange(v97.ChampionsSpear))) then
						return "spear_of_bastion hac 76";
					end
				end
				if (((3684 - 1934) >= (1723 - (581 + 300))) and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable() and v97.Unhinged:IsAvailable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) then
					if (((5592 - (855 + 365)) > (4394 - 2544)) and v24(v97.Bladestorm, not v101)) then
						return "bladestorm hac 77";
					end
				end
				v130 = 1 + 2;
			end
			if (((1467 - (1030 + 205)) < (771 + 50)) and (v130 == (1 + 0))) then
				if (((804 - (156 + 130)) < (2049 - 1147)) and (v90 < v103) and v31 and ((v52 and v30) or not v52) and v97.Avatar:IsCastable()) then
					if (((5045 - 2051) > (1757 - 899)) and v24(v97.Avatar, not v101)) then
						return "avatar hac 71";
					end
				end
				if (((v90 < v103) and v97.Warbreaker:IsCastable() and v49 and ((v57 and v30) or not v57) and (v105 > (1 + 0))) or ((2190 + 1565) <= (984 - (10 + 59)))) then
					if (((1117 + 2829) > (18433 - 14690)) and v24(v97.Warbreaker, not v101)) then
						return "warbreaker hac 72";
					end
				end
				if (((v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) or ((2498 - (671 + 492)) >= (2632 + 674))) then
					if (((6059 - (369 + 846)) > (597 + 1656)) and v93.CastCycle(v97.ColossusSmash, v104, v107, not v101)) then
						return "colossus_smash hac 73";
					end
					if (((386 + 66) == (2397 - (1036 + 909))) and v24(v97.ColossusSmash, not v101)) then
						return "colossus_smash hac 73";
					end
				end
				if (((v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) or ((3624 + 933) < (3503 - 1416))) then
					if (((4077 - (11 + 192)) == (1958 + 1916)) and v24(v97.ColossusSmash, not v101)) then
						return "colossus_smash hac 74";
					end
				end
				v130 = 177 - (135 + 40);
			end
		end
	end
	local function v114()
		if (((v90 < v103) and v46 and v97.SweepingStrikes:IsCastable() and (v105 > (2 - 1))) or ((1169 + 769) > (10871 - 5936))) then
			if (v24(v97.SweepingStrikes, not v15:IsInMeleeRange(11 - 3)) or ((4431 - (50 + 126)) < (9531 - 6108))) then
				return "sweeping_strikes execute 51";
			end
		end
		if (((322 + 1132) <= (3904 - (1233 + 180))) and v97.Rend:IsReady() and v41 and (v15:DebuffRemains(v97.RendDebuff) <= v14:GCD()) and not v97.Bloodletting:IsAvailable() and ((not v97.Warbreaker:IsAvailable() and (v97.ColossusSmash:CooldownRemains() < (973 - (522 + 447)))) or (v97.Warbreaker:IsAvailable() and (v97.Warbreaker:CooldownRemains() < (1425 - (107 + 1314))))) and (v15:TimeToDie() > (6 + 6))) then
			if (v24(v97.Rend, not v101) or ((12666 - 8509) <= (1191 + 1612))) then
				return "rend execute 52";
			end
		end
		if (((9637 - 4784) >= (11798 - 8816)) and (v90 < v103) and v31 and ((v52 and v30) or not v52) and v97.Avatar:IsCastable() and (v97.ColossusSmash:CooldownUp() or v15:DebuffUp(v97.ColossusSmashDebuff) or (v103 < (1930 - (716 + 1194))))) then
			if (((71 + 4063) > (360 + 2997)) and v24(v97.Avatar, not v101)) then
				return "avatar execute 53";
			end
		end
		if (((v90 < v103) and v49 and ((v57 and v30) or not v57) and v97.Warbreaker:IsCastable()) or ((3920 - (74 + 429)) < (4887 - 2353))) then
			if (v24(v97.Warbreaker, not v101) or ((1350 + 1372) <= (375 - 211))) then
				return "warbreaker execute 54";
			end
		end
		if (((v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) or ((1704 + 704) < (6501 - 4392))) then
			if (v24(v97.ColossusSmash, not v101) or ((81 - 48) == (1888 - (279 + 154)))) then
				return "colossus_smash execute 55";
			end
		end
		if ((v97.Execute:IsReady() and v37 and v14:BuffUp(v97.SuddenDeathBuff) and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (778 - (454 + 324)))) or ((349 + 94) >= (4032 - (12 + 5)))) then
			if (((1824 + 1558) > (422 - 256)) and v24(v97.Execute, not v101)) then
				return "execute execute 56";
			end
		end
		if ((v97.Skullsplitter:IsCastable() and v44 and ((v97.TestofMight:IsAvailable() and (v14:RagePercentage() <= (12 + 18))) or (not v97.TestofMight:IsAvailable() and (v15:DebuffUp(v97.ColossusSmashDebuff) or (v97.ColossusSmash:CooldownRemains() > (1098 - (277 + 816)))) and (v14:RagePercentage() <= (128 - 98))))) or ((1463 - (1058 + 125)) == (574 + 2485))) then
			if (((2856 - (815 + 160)) > (5547 - 4254)) and v24(v97.Skullsplitter, not v15:IsInMeleeRange(18 - 10))) then
				return "skullsplitter execute 57";
			end
		end
		if (((563 + 1794) == (6889 - 4532)) and (v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) then
			if (((2021 - (41 + 1857)) == (2016 - (1222 + 671))) and v24(v97.ThunderousRoar, not v15:IsInMeleeRange(20 - 12))) then
				return "thunderous_roar execute 57";
			end
		end
		if (((v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "player") and v97.ChampionsSpear:IsCastable() and (v15:DebuffUp(v97.ColossusSmashDebuff) or v14:BuffUp(v97.TestofMightBuff))) or ((1517 - 461) >= (4574 - (229 + 953)))) then
			if (v24(v99.ChampionsSpearPlayer, not v15:IsSpellInRange(v97.ChampionsSpear)) or ((2855 - (1111 + 663)) < (2654 - (874 + 705)))) then
				return "spear_of_bastion execute 57";
			end
		end
		if (((v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "cursor") and v97.ChampionsSpear:IsCastable() and (v15:DebuffUp(v97.ColossusSmashDebuff) or v14:BuffUp(v97.TestofMightBuff))) or ((147 + 902) >= (3024 + 1408))) then
			if (v24(v99.ChampionsSpearCursor, not v15:IsSpellInRange(v97.ChampionsSpear)) or ((9910 - 5142) <= (24 + 822))) then
				return "spear_of_bastion execute 57";
			end
		end
		if ((v97.Cleave:IsReady() and v35 and (v105 > (681 - (642 + 37))) and (v15:DebuffRemains(v97.DeepWoundsDebuff) < v14:GCD())) or ((766 + 2592) <= (228 + 1192))) then
			if (v24(v97.Cleave, not v101) or ((9387 - 5648) <= (3459 - (233 + 221)))) then
				return "cleave execute 58";
			end
		end
		if ((v97.MortalStrike:IsReady() and v39 and ((v15:DebuffStack(v97.ExecutionersPrecisionDebuff) == (4 - 2)) or (v15:DebuffRemains(v97.DeepWoundsDebuff) <= v14:GCD()))) or ((1461 + 198) >= (3675 - (718 + 823)))) then
			if (v24(v97.MortalStrike, not v101) or ((2052 + 1208) < (3160 - (266 + 539)))) then
				return "mortal_strike execute 59";
			end
		end
		if ((v97.Overpower:IsCastable() and v40 and (v14:Rage() < (113 - 73)) and (v14:BuffStack(v97.MartialProwessBuff) < (1227 - (636 + 589)))) or ((1587 - 918) == (8709 - 4486))) then
			if (v24(v97.Overpower, not v101) or ((1341 + 351) < (214 + 374))) then
				return "overpower execute 60";
			end
		end
		if ((v97.Execute:IsReady() and v37) or ((5812 - (657 + 358)) < (9666 - 6015))) then
			if (v24(v97.Execute, not v101) or ((9516 - 5339) > (6037 - (1151 + 36)))) then
				return "execute execute 62";
			end
		end
		if ((v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable() or v15:IsCasting())) or ((387 + 13) > (293 + 818))) then
			if (((9111 - 6060) > (2837 - (1552 + 280))) and v24(v97.Shockwave, not v15:IsInMeleeRange(842 - (64 + 770)))) then
				return "shockwave execute 63";
			end
		end
		if (((2508 + 1185) <= (9947 - 5565)) and v97.Overpower:IsCastable() and v40) then
			if (v24(v97.Overpower, not v101) or ((583 + 2699) > (5343 - (157 + 1086)))) then
				return "overpower execute 64";
			end
		end
		if (((v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable()) or ((7165 - 3585) < (12455 - 9611))) then
			if (((135 - 46) < (6128 - 1638)) and v24(v97.Bladestorm, not v101)) then
				return "bladestorm execute 65";
			end
		end
	end
	local function v115()
		if (((v90 < v103) and v46 and v97.SweepingStrikes:IsCastable() and (v105 > (820 - (599 + 220)))) or ((9922 - 4939) < (3739 - (1813 + 118)))) then
			if (((2799 + 1030) > (4986 - (841 + 376))) and v24(v97.SweepingStrikes, not v15:IsInMeleeRange(10 - 2))) then
				return "sweeping_strikes single_target 97";
			end
		end
		if (((345 + 1140) <= (7926 - 5022)) and v97.Execute:IsReady() and (v14:BuffUp(v97.SuddenDeathBuff))) then
			if (((5128 - (464 + 395)) == (10955 - 6686)) and v24(v97.Execute, not v101)) then
				return "execute single_target 98";
			end
		end
		if (((186 + 201) <= (3619 - (467 + 370))) and v97.MortalStrike:IsReady() and v39) then
			if (v24(v97.MortalStrike, not v101) or ((3923 - 2024) <= (674 + 243))) then
				return "mortal_strike single_target 99";
			end
		end
		if ((v97.Rend:IsReady() and v41 and ((v15:DebuffRemains(v97.RendDebuff) <= v14:GCD()) or (v97.TideofBlood:IsAvailable() and (v97.Skullsplitter:CooldownRemains() <= v14:GCD()) and ((v97.ColossusSmash:CooldownRemains() <= v14:GCD()) or v15:DebuffUp(v97.ColossusSmashDebuff)) and (v15:DebuffRemains(v97.RendDebuff) < (v97.RendDebuff:BaseDuration() * (0.85 - 0)))))) or ((673 + 3639) <= (2037 - 1161))) then
			if (((2752 - (150 + 370)) <= (3878 - (74 + 1208))) and v24(v97.Rend, not v101)) then
				return "rend single_target 100";
			end
		end
		if (((5152 - 3057) < (17481 - 13795)) and (v90 < v103) and v31 and ((v52 and v30) or not v52) and v97.Avatar:IsCastable() and ((v97.WarlordsTorment:IsAvailable() and (v14:RagePercentage() < (24 + 9)) and (v97.ColossusSmash:CooldownUp() or v15:DebuffUp(v97.ColossusSmashDebuff) or v14:BuffUp(v97.TestofMightBuff))) or (not v97.WarlordsTorment:IsAvailable() and (v97.ColossusSmash:CooldownUp() or v15:DebuffUp(v97.ColossusSmashDebuff))))) then
			if (v24(v97.Avatar, not v101) or ((1985 - (14 + 376)) >= (7759 - 3285))) then
				return "avatar single_target 101";
			end
		end
		if (((v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "player") and v97.ChampionsSpear:IsCastable() and ((v97.ColossusSmash:CooldownRemains() <= v14:GCD()) or (v97.Warbreaker:CooldownRemains() <= v14:GCD()))) or ((2989 + 1630) < (2532 + 350))) then
			if (v24(v99.ChampionsSpearPlayer, not v15:IsSpellInRange(v97.ChampionsSpear)) or ((281 + 13) >= (14155 - 9324))) then
				return "spear_of_bastion single_target 102";
			end
		end
		if (((1527 + 502) <= (3162 - (23 + 55))) and (v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "cursor") and v97.ChampionsSpear:IsCastable() and ((v97.ColossusSmash:CooldownRemains() <= v14:GCD()) or (v97.Warbreaker:CooldownRemains() <= v14:GCD()))) then
			if (v24(v99.ChampionsSpearCursor, not v15:IsSpellInRange(v97.ChampionsSpear)) or ((4827 - 2790) == (1615 + 805))) then
				return "spear_of_bastion single_target 102";
			end
		end
		if (((4004 + 454) > (6052 - 2148)) and (v90 < v103) and v49 and ((v57 and v30) or not v57) and v97.Warbreaker:IsCastable()) then
			if (((138 + 298) >= (1024 - (652 + 249))) and v24(v97.Warbreaker, not v15:IsInRange(21 - 13))) then
				return "warbreaker single_target 103";
			end
		end
		if (((2368 - (708 + 1160)) < (4929 - 3113)) and (v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) then
			if (((6515 - 2941) == (3601 - (10 + 17))) and v24(v97.ColossusSmash, not v101)) then
				return "colossus_smash single_target 104";
			end
		end
		if (((50 + 171) < (2122 - (1400 + 332))) and v97.Skullsplitter:IsCastable() and v44 and not v97.TestofMight:IsAvailable() and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (0 - 0)) and (v15:DebuffUp(v97.ColossusSmashDebuff) or (v97.ColossusSmash:CooldownRemains() > (1911 - (242 + 1666))))) then
			if (v24(v97.Skullsplitter, not v101) or ((947 + 1266) <= (521 + 900))) then
				return "skullsplitter single_target 105";
			end
		end
		if (((2607 + 451) < (5800 - (850 + 90))) and v97.Skullsplitter:IsCastable() and v44 and v97.TestofMight:IsAvailable() and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (0 - 0))) then
			if (v24(v97.Skullsplitter, not v101) or ((2686 - (360 + 1030)) >= (3935 + 511))) then
				return "skullsplitter single_target 106";
			end
		end
		if (((v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff) and (v14:RagePercentage() < (92 - 59))) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or ((1915 - 522) > (6150 - (909 + 752)))) then
			if (v24(v97.ThunderousRoar, not v15:IsInMeleeRange(1231 - (109 + 1114))) or ((8099 - 3675) < (11 + 16))) then
				return "thunderous_roar single_target 107";
			end
		end
		if ((v97.Whirlwind:IsReady() and v50 and v97.StormofSwords:IsAvailable() and v97.TestofMight:IsAvailable() and (v14:RagePercentage() > (322 - (6 + 236))) and v15:DebuffUp(v97.ColossusSmashDebuff)) or ((1259 + 738) > (3071 + 744))) then
			if (((8171 - 4706) > (3341 - 1428)) and v24(v97.Whirlwind, not v15:IsInMeleeRange(1141 - (1076 + 57)))) then
				return "whirlwind single_target 108";
			end
		end
		if (((121 + 612) < (2508 - (579 + 110))) and v97.ThunderClap:IsReady() and v47 and (v15:DebuffRemains(v97.RendDebuff) <= v14:GCD()) and not v97.TideofBlood:IsAvailable()) then
			if (v24(v97.ThunderClap, not v101) or ((347 + 4048) == (4205 + 550))) then
				return "thunder_clap single_target 109";
			end
		end
		if (((v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable() and ((v97.Hurricane:IsAvailable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or (v97.Unhinged:IsAvailable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))))) or ((2014 + 1779) < (2776 - (174 + 233)))) then
			if (v24(v97.Bladestorm, not v101) or ((11407 - 7323) == (465 - 200))) then
				return "bladestorm single_target 110";
			end
		end
		if (((1938 + 2420) == (5532 - (663 + 511))) and v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable() or v15:IsCasting())) then
			if (v24(v97.Shockwave, not v15:IsInMeleeRange(8 + 0)) or ((682 + 2456) < (3061 - 2068))) then
				return "shockwave single_target 111";
			end
		end
		if (((2017 + 1313) > (5468 - 3145)) and v97.Whirlwind:IsReady() and v50 and v97.StormofSwords:IsAvailable() and v97.TestofMight:IsAvailable() and (v97.ColossusSmash:CooldownRemains() > (v14:GCD() * (16 - 9)))) then
			if (v24(v97.Whirlwind, not v15:IsInMeleeRange(4 + 4)) or ((7057 - 3431) == (2843 + 1146))) then
				return "whirlwind single_target 113";
			end
		end
		if ((v97.Overpower:IsCastable() and v40 and (((v97.Overpower:Charges() == (1 + 1)) and not v97.Battlelord:IsAvailable() and (v15:DebuffUp(v97.ColossusSmashDebuff) or (v14:RagePercentage() < (747 - (478 + 244))))) or v97.Battlelord:IsAvailable())) or ((1433 - (440 + 77)) == (1215 + 1456))) then
			if (((995 - 723) == (1828 - (655 + 901))) and v24(v97.Overpower, not v101)) then
				return "overpower single_target 114";
			end
		end
		if (((788 + 3461) <= (3705 + 1134)) and v97.Slam:IsReady() and v45 and ((v97.CrushingForce:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff) and (v14:Rage() >= (41 + 19)) and v97.TestofMight:IsAvailable()) or v97.ImprovedSlam:IsAvailable()) and (not v97.FervorofBattle:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 == (3 - 2))))) then
			if (((4222 - (695 + 750)) < (10927 - 7727)) and v24(v97.Slam, not v101)) then
				return "slam single_target 115";
			end
		end
		if (((146 - 51) < (7870 - 5913)) and v97.Whirlwind:IsReady() and v50 and (v97.StormofSwords:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 > (352 - (285 + 66)))))) then
			if (((1925 - 1099) < (3027 - (682 + 628))) and v24(v97.Whirlwind, not v15:IsInMeleeRange(2 + 6))) then
				return "whirlwind single_target 116";
			end
		end
		if (((1725 - (176 + 123)) >= (463 + 642)) and v97.Slam:IsReady() and v45 and (v97.CrushingForce:IsAvailable() or (not v97.CrushingForce:IsAvailable() and (v14:Rage() >= (22 + 8)))) and (not v97.FervorofBattle:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 == (270 - (239 + 30)))))) then
			if (((749 + 2005) <= (3248 + 131)) and v24(v97.Slam, not v101)) then
				return "slam single_target 117";
			end
		end
		if ((v97.ThunderClap:IsReady() and v47 and v97.Battlelord:IsAvailable() and v97.BloodandThunder:IsAvailable()) or ((6950 - 3023) == (4407 - 2994))) then
			if (v24(v97.ThunderClap, not v101) or ((1469 - (306 + 9)) <= (2749 - 1961))) then
				return "thunder_clap single_target 118";
			end
		end
		if ((v97.Overpower:IsCastable() and v40 and ((v15:DebuffDown(v97.ColossusSmashDebuff) and (v14:RagePercentage() < (9 + 41)) and not v97.Battlelord:IsAvailable()) or (v14:RagePercentage() < (16 + 9)))) or ((791 + 852) > (9662 - 6283))) then
			if (v24(v97.Overpower, not v101) or ((4178 - (1140 + 235)) > (2895 + 1654))) then
				return "overpower single_target 119";
			end
		end
		if ((v97.Whirlwind:IsReady() and v50 and v14:BuffUp(v97.MercilessBonegrinderBuff)) or ((202 + 18) >= (776 + 2246))) then
			if (((2874 - (33 + 19)) == (1019 + 1803)) and v24(v97.Whirlwind, not v15:IsInRange(23 - 15))) then
				return "whirlwind single_target 120";
			end
		end
		if ((v97.Cleave:IsReady() and v35 and v14:HasTier(13 + 16, 3 - 1) and not v97.CrushingForce:IsAvailable()) or ((995 + 66) == (2546 - (586 + 103)))) then
			if (((252 + 2508) > (4199 - 2835)) and v24(v97.Cleave, not v101)) then
				return "cleave single_target 121";
			end
		end
		if (((v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable()) or ((6390 - (1309 + 179)) <= (6490 - 2895))) then
			if (v24(v97.Bladestorm, not v101) or ((1677 + 2175) == (786 - 493))) then
				return "bladestorm single_target 122";
			end
		end
		if ((v97.Cleave:IsReady() and v35) or ((1178 + 381) == (9747 - 5159))) then
			if (v24(v97.Cleave, not v101) or ((8934 - 4450) == (1397 - (295 + 314)))) then
				return "cleave single_target 123";
			end
		end
		if (((11219 - 6651) >= (5869 - (1300 + 662))) and v97.Rend:IsReady() and v41 and v15:DebuffRefreshable(v97.RendDebuff) and not v97.CrushingForce:IsAvailable()) then
			if (((3912 - 2666) < (5225 - (1178 + 577))) and v24(v97.Rend, not v101)) then
				return "rend single_target 124";
			end
		end
	end
	local function v116()
		if (((2113 + 1955) >= (2873 - 1901)) and not v14:AffectingCombat()) then
			if (((1898 - (851 + 554)) < (3443 + 450)) and v97.BattleStance:IsCastable() and v14:BuffDown(v97.BattleStance, true)) then
				if (v24(v97.BattleStance) or ((4085 - 2612) >= (7236 - 3904))) then
					return "battle_stance";
				end
			end
			if ((v97.BattleShout:IsCastable() and v32 and (v14:BuffDown(v97.BattleShoutBuff, true) or v93.GroupBuffMissing(v97.BattleShoutBuff))) or ((4353 - (115 + 187)) <= (887 + 270))) then
				if (((572 + 32) < (11353 - 8472)) and v24(v97.BattleShout)) then
					return "battle_shout precombat";
				end
			end
		end
		if ((v93.TargetIsValid() and v28) or ((2061 - (160 + 1001)) == (2955 + 422))) then
			if (((3077 + 1382) > (1209 - 618)) and not v14:AffectingCombat()) then
				v27 = v112();
				if (((3756 - (237 + 121)) >= (3292 - (525 + 372))) and v27) then
					return v27;
				end
			end
		end
	end
	local function v117()
		local v131 = 0 - 0;
		while true do
			if ((v131 == (0 - 0)) or ((2325 - (96 + 46)) >= (3601 - (643 + 134)))) then
				v27 = v110();
				if (((699 + 1237) == (4641 - 2705)) and v27) then
					return v27;
				end
				v131 = 3 - 2;
			end
			if (((1 + 0) == v131) or ((9482 - 4650) < (8815 - 4502))) then
				if (((4807 - (316 + 403)) > (2576 + 1298)) and v85) then
					local v190 = 0 - 0;
					while true do
						if (((1566 + 2766) == (10909 - 6577)) and (v190 == (0 + 0))) then
							v27 = v93.HandleIncorporeal(v97.StormBolt, v99.StormBoltMouseover, 7 + 13, true);
							if (((13856 - 9857) >= (13849 - 10949)) and v27) then
								return v27;
							end
							v190 = 1 - 0;
						end
						if ((v190 == (1 + 0)) or ((4970 - 2445) > (199 + 3865))) then
							v27 = v93.HandleIncorporeal(v97.IntimidatingShout, v99.IntimidatingShoutMouseover, 23 - 15, true);
							if (((4388 - (12 + 5)) == (16977 - 12606)) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				if (v93.TargetIsValid() or ((566 - 300) > (10598 - 5612))) then
					local v191 = 0 - 0;
					local v192;
					while true do
						if (((405 + 1586) >= (2898 - (1656 + 317))) and (v191 == (1 + 0))) then
							if (((365 + 90) < (5458 - 3405)) and (v90 < v103)) then
								if ((v92 and ((v30 and v58) or not v58)) or ((4065 - 3239) == (5205 - (5 + 349)))) then
									local v198 = 0 - 0;
									while true do
										if (((1454 - (266 + 1005)) == (121 + 62)) and (v198 == (0 - 0))) then
											v27 = v111();
											if (((1525 - 366) <= (3484 - (561 + 1135))) and v27) then
												return v27;
											end
											break;
										end
									end
								end
								if ((v30 and v98.FyralathTheDreamrender:IsEquippedAndReady()) or ((4570 - 1063) > (14193 - 9875))) then
									if (v24(v99.UseWeapon) or ((4141 - (507 + 559)) <= (7440 - 4475))) then
										return "Fyralath The Dreamrender used";
									end
								end
							end
							if (((4221 - 2856) <= (2399 - (212 + 176))) and v38 and v97.HeroicThrow:IsCastable() and not v15:IsInRange(930 - (250 + 655)) and v14:CanAttack(v15)) then
								if (v24(v97.HeroicThrow, not v15:IsSpellInRange(v97.HeroicThrow)) or ((7569 - 4793) > (6246 - 2671))) then
									return "heroic_throw main";
								end
							end
							if ((v97.WreckingThrow:IsCastable() and v51 and v106() and v14:CanAttack(v15)) or ((3995 - 1441) == (6760 - (1869 + 87)))) then
								if (((8938 - 6361) == (4478 - (484 + 1417))) and v24(v97.WreckingThrow, not v15:IsSpellInRange(v97.WreckingThrow))) then
									return "wrecking_throw main";
								end
							end
							if ((v29 and (v105 > (4 - 2))) or ((9 - 3) >= (2662 - (48 + 725)))) then
								local v197 = 0 - 0;
								while true do
									if (((1357 - 851) <= (1100 + 792)) and ((0 - 0) == v197)) then
										v27 = v113();
										if (v27 or ((562 + 1446) > (647 + 1571))) then
											return v27;
										end
										break;
									end
								end
							end
							v191 = 855 - (152 + 701);
						end
						if (((1690 - (430 + 881)) <= (1589 + 2558)) and (v191 == (895 - (557 + 338)))) then
							if ((v34 and v97.Charge:IsCastable() and not v101) or ((1335 + 3179) <= (2842 - 1833))) then
								if (v24(v97.Charge, not v15:IsSpellInRange(v97.Charge)) or ((12241 - 8745) == (3166 - 1974))) then
									return "charge main 34";
								end
							end
							v192 = v93.HandleDPSPotion(v15:DebuffUp(v97.ColossusSmashDebuff));
							if (v192 or ((448 - 240) == (3760 - (499 + 302)))) then
								return v192;
							end
							if (((5143 - (39 + 827)) >= (3624 - 2311)) and v101 and v91 and ((v59 and v30) or not v59) and (v90 < v103)) then
								if (((5777 - 3190) < (12606 - 9432)) and v97.BloodFury:IsCastable() and v15:DebuffUp(v97.ColossusSmashDebuff)) then
									if (v24(v97.BloodFury) or ((6325 - 2205) <= (189 + 2009))) then
										return "blood_fury main 39";
									end
								end
								if ((v97.Berserking:IsCastable() and (v15:DebuffRemains(v97.ColossusSmashDebuff) > (17 - 11))) or ((256 + 1340) == (1357 - 499))) then
									if (((3324 - (103 + 1)) == (3774 - (475 + 79))) and v24(v97.Berserking)) then
										return "berserking main 40";
									end
								end
								if ((v97.ArcaneTorrent:IsCastable() and (v97.MortalStrike:CooldownRemains() > (2.5 - 1)) and (v14:Rage() < (160 - 110))) or ((182 + 1220) > (3186 + 434))) then
									if (((4077 - (1395 + 108)) == (7489 - 4915)) and v24(v97.ArcaneTorrent, not v15:IsInRange(1212 - (7 + 1197)))) then
										return "arcane_torrent main 41";
									end
								end
								if (((784 + 1014) < (963 + 1794)) and v97.LightsJudgment:IsCastable() and v15:DebuffDown(v97.ColossusSmashDebuff) and not v97.MortalStrike:CooldownUp()) then
									if (v24(v97.LightsJudgment, not v15:IsSpellInRange(v97.LightsJudgment)) or ((696 - (27 + 292)) > (7630 - 5026))) then
										return "lights_judgment main 42";
									end
								end
								if (((723 - 155) < (3820 - 2909)) and v97.Fireblood:IsCastable() and (v15:DebuffUp(v97.ColossusSmashDebuff))) then
									if (((6477 - 3192) < (8051 - 3823)) and v24(v97.Fireblood)) then
										return "fireblood main 43";
									end
								end
								if (((4055 - (43 + 96)) > (13575 - 10247)) and v97.AncestralCall:IsCastable() and (v15:DebuffUp(v97.ColossusSmashDebuff))) then
									if (((5652 - 3152) < (3186 + 653)) and v24(v97.AncestralCall)) then
										return "ancestral_call main 44";
									end
								end
								if (((144 + 363) == (1001 - 494)) and v97.BagofTricks:IsCastable() and v15:DebuffDown(v97.ColossusSmashDebuff) and not v97.MortalStrike:CooldownUp()) then
									if (((92 + 148) <= (5931 - 2766)) and v24(v97.BagofTricks, not v15:IsSpellInRange(v97.BagofTricks))) then
										return "bag_of_tricks main 10";
									end
								end
							end
							v191 = 1 + 0;
						end
						if (((62 + 772) >= (2556 - (1414 + 337))) and (v191 == (1942 - (1642 + 298)))) then
							if ((v97.Massacre:IsAvailable() and (v15:HealthPercentage() < (90 - 55))) or (v15:HealthPercentage() < (57 - 37)) or ((11312 - 7500) < (763 + 1553))) then
								v27 = v114();
								if (v27 or ((2064 + 588) <= (2505 - (357 + 615)))) then
									return v27;
								end
							end
							v27 = v115();
							if (v27 or ((2526 + 1072) < (3582 - 2122))) then
								return v27;
							end
							if (v20.CastAnnotated(v97.Pool, false, "WAIT") or ((3527 + 589) < (2554 - 1362))) then
								return "Wait/Pool Resources";
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v118()
		local v132 = 0 + 0;
		while true do
			if ((v132 == (1 + 4)) or ((2123 + 1254) <= (2204 - (384 + 917)))) then
				v49 = EpicSettings.Settings['useWarbreaker'];
				v52 = EpicSettings.Settings['avatarWithCD'];
				v53 = EpicSettings.Settings['bladestormWithCD'];
				v54 = EpicSettings.Settings['colossusSmashWithCD'];
				v132 = 703 - (128 + 569);
			end
			if (((5519 - (1407 + 136)) >= (2326 - (687 + 1200))) and (v132 == (1712 - (556 + 1154)))) then
				v43 = EpicSettings.Settings['useShockwave'];
				v44 = EpicSettings.Settings['useSkullsplitter'];
				v45 = EpicSettings.Settings['useSlam'];
				v46 = EpicSettings.Settings['useSweepingStrikes'];
				v132 = 10 - 7;
			end
			if (((3847 - (9 + 86)) == (4173 - (275 + 146))) and (v132 == (1 + 2))) then
				v47 = EpicSettings.Settings['useThunderClap'];
				v50 = EpicSettings.Settings['useWhirlwind'];
				v51 = EpicSettings.Settings['useWreckingThrow'];
				v31 = EpicSettings.Settings['useAvatar'];
				v132 = 68 - (29 + 35);
			end
			if (((17931 - 13885) > (8049 - 5354)) and (v132 == (26 - 20))) then
				v55 = EpicSettings.Settings['championsSpearWithCD'];
				v56 = EpicSettings.Settings['thunderousRoarWithCD'];
				v57 = EpicSettings.Settings['warbreakerWithCD'];
				break;
			end
			if ((v132 == (1 + 0)) or ((4557 - (53 + 959)) == (3605 - (312 + 96)))) then
				v38 = EpicSettings.Settings['useHeroicThrow'];
				v39 = EpicSettings.Settings['useMortalStrike'];
				v40 = EpicSettings.Settings['useOverpower'];
				v41 = EpicSettings.Settings['useRend'];
				v132 = 3 - 1;
			end
			if (((2679 - (147 + 138)) > (1272 - (813 + 86))) and ((0 + 0) == v132)) then
				v32 = EpicSettings.Settings['useBattleShout'];
				v34 = EpicSettings.Settings['useCharge'];
				v35 = EpicSettings.Settings['useCleave'];
				v37 = EpicSettings.Settings['useExecute'];
				v132 = 1 - 0;
			end
			if (((4647 - (18 + 474)) <= (1428 + 2804)) and (v132 == (12 - 8))) then
				v33 = EpicSettings.Settings['useBladestorm'];
				v36 = EpicSettings.Settings['useColossusSmash'];
				v83 = EpicSettings.Settings['useChampionsSpear'];
				v48 = EpicSettings.Settings['useThunderousRoar'];
				v132 = 1091 - (860 + 226);
			end
		end
	end
	local function v119()
		local v133 = 303 - (121 + 182);
		while true do
			if ((v133 == (1 + 1)) or ((4821 - (988 + 252)) == (393 + 3080))) then
				v66 = EpicSettings.Settings['useRallyingCry'];
				v71 = EpicSettings.Settings['useVictoryRush'];
				v72 = EpicSettings.Settings['bitterImmunityHP'] or (0 + 0);
				v78 = EpicSettings.Settings['defensiveStanceHP'] or (1970 - (49 + 1921));
				v133 = 893 - (223 + 667);
			end
			if (((5047 - (51 + 1)) > (5762 - 2414)) and (v133 == (6 - 3))) then
				v81 = EpicSettings.Settings['unstanceHP'] or (1125 - (146 + 979));
				v73 = EpicSettings.Settings['dieByTheSwordHP'] or (0 + 0);
				v74 = EpicSettings.Settings['ignorePainHP'] or (605 - (311 + 294));
				v77 = EpicSettings.Settings['interveneHP'] or (0 - 0);
				v133 = 2 + 2;
			end
			if (((1443 - (496 + 947)) == v133) or ((2112 - (1233 + 125)) > (1512 + 2212))) then
				v60 = EpicSettings.Settings['usePummel'];
				v61 = EpicSettings.Settings['useStormBolt'];
				v62 = EpicSettings.Settings['useIntimidatingShout'];
				v63 = EpicSettings.Settings['useBitterImmunity'];
				v133 = 1 + 0;
			end
			if (((42 + 175) >= (1702 - (963 + 682))) and ((1 + 0) == v133)) then
				v68 = EpicSettings.Settings['useDefensiveStance'];
				v64 = EpicSettings.Settings['useDieByTheSword'];
				v65 = EpicSettings.Settings['useIgnorePain'];
				v67 = EpicSettings.Settings['useIntervene'];
				v133 = 1506 - (504 + 1000);
			end
			if ((v133 == (3 + 1)) or ((1886 + 184) >= (381 + 3656))) then
				v76 = EpicSettings.Settings['rallyingCryGroup'] or (0 - 0);
				v75 = EpicSettings.Settings['rallyingCryHP'] or (0 + 0);
				v82 = EpicSettings.Settings['victoryRushHP'] or (0 + 0);
				v84 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
		end
	end
	local function v120()
		local v134 = 182 - (156 + 26);
		while true do
			if (((1559 + 1146) == (4231 - 1526)) and (v134 == (166 - (149 + 15)))) then
				v69 = EpicSettings.Settings['useHealthstone'];
				v70 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (960 - (890 + 70));
				v80 = EpicSettings.Settings['healingPotionHP'] or (117 - (39 + 78));
				v134 = 485 - (14 + 468);
			end
			if (((134 - 73) == (170 - 109)) and (v134 == (1 + 0))) then
				v92 = EpicSettings.Settings['useTrinkets'];
				v91 = EpicSettings.Settings['useRacials'];
				v58 = EpicSettings.Settings['trinketsWithCD'];
				v59 = EpicSettings.Settings['racialsWithCD'];
				v134 = 2 + 0;
			end
			if ((v134 == (1 + 2)) or ((316 + 383) >= (340 + 956))) then
				v86 = EpicSettings.Settings['HealingPotionName'] or "";
				v85 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v134 == (0 - 0)) or ((1763 + 20) >= (12706 - 9090))) then
				v90 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v87 = EpicSettings.Settings['InterruptWithStun'];
				v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v89 = EpicSettings.Settings['InterruptThreshold'];
				v134 = 52 - (12 + 39);
			end
		end
	end
	local function v121()
		local v135 = 0 + 0;
		while true do
			if ((v135 == (5 - 3)) or ((13936 - 10023) > (1343 + 3184))) then
				v101 = v15:IsInMeleeRange(5 + 3);
				if (((11096 - 6720) > (545 + 272)) and (v93.TargetIsValid() or v14:AffectingCombat())) then
					local v193 = 0 - 0;
					while true do
						if (((6571 - (1596 + 114)) > (2151 - 1327)) and (v193 == (713 - (164 + 549)))) then
							v102 = v10.BossFightRemains(nil, true);
							v103 = v102;
							v193 = 1439 - (1059 + 379);
						end
						if (((1 - 0) == v193) or ((717 + 666) >= (360 + 1771))) then
							if ((v103 == (11503 - (145 + 247))) or ((1540 + 336) >= (1175 + 1366))) then
								v103 = v10.FightRemains(v104, false);
							end
							break;
						end
					end
				end
				if (((5282 - 3500) <= (724 + 3048)) and not v14:IsChanneling()) then
					if (v14:AffectingCombat() or ((4049 + 651) < (1319 - 506))) then
						local v195 = 720 - (254 + 466);
						while true do
							if (((3759 - (544 + 16)) < (12871 - 8821)) and (v195 == (628 - (294 + 334)))) then
								v27 = v117();
								if (v27 or ((5204 - (236 + 17)) < (1910 + 2520))) then
									return v27;
								end
								break;
							end
						end
					else
						local v196 = 0 + 0;
						while true do
							if (((361 - 265) == (454 - 358)) and (v196 == (0 + 0))) then
								v27 = v116();
								if (v27 or ((2256 + 483) > (4802 - (413 + 381)))) then
									return v27;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v135 == (0 + 0)) or ((48 - 25) == (2945 - 1811))) then
				v119();
				v118();
				v120();
				v28 = EpicSettings.Toggles['ooc'];
				v135 = 1971 - (582 + 1388);
			end
			if ((v135 == (1 - 0)) or ((1928 + 765) >= (4475 - (326 + 38)))) then
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				if (v14:IsDeadOrGhost() or ((12767 - 8451) <= (3063 - 917))) then
					return v27;
				end
				if (v29 or ((4166 - (47 + 573)) <= (991 + 1818))) then
					local v194 = 0 - 0;
					while true do
						if (((7958 - 3054) > (3830 - (1269 + 395))) and (v194 == (492 - (76 + 416)))) then
							v104 = v14:GetEnemiesInMeleeRange(451 - (319 + 124));
							v105 = #v104;
							break;
						end
					end
				else
					v105 = 2 - 1;
				end
				v135 = 1009 - (564 + 443);
			end
		end
	end
	local function v122()
		v20.Print("Arms Warrior by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(196 - 125, v121, v122);
end;
return v0["Epix_Warrior_Arms.lua"]();

