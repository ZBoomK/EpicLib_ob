local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((5715 - (922 + 87)) >= (2546 - 1583)) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((3445 - 2485) <= (1323 - 447))) then
			v6 = v0[v4];
			if (not v6 or ((1237 + 829) == (1610 - (356 + 322)))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
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
	local v95 = (v94[2 + 11] and v19(v94[19 - 6])) or v19(1244 - (485 + 759));
	local v96 = (v94[32 - 18] and v19(v94[1203 - (442 + 747)])) or v19(1135 - (832 + 303));
	local v97 = v18.Warrior.Arms;
	local v98 = v19.Warrior.Arms;
	local v99 = v23.Warrior.Arms;
	local v100 = {};
	local v101;
	local v102 = 12057 - (88 + 858);
	local v103 = 3387 + 7724;
	v10:RegisterForEvent(function()
		v102 = 9196 + 1915;
		v103 = 458 + 10653;
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v123 = 789 - (766 + 23);
		while true do
			if (((23819 - 18994) < (6622 - 1779)) and (v123 == (0 - 0))) then
				v94 = v14:GetEquipment();
				v95 = (v94[44 - 31] and v19(v94[1086 - (1036 + 37)])) or v19(0 + 0);
				v123 = 1 - 0;
			end
			if ((v123 == (1 + 0)) or ((5357 - (641 + 839)) >= (5450 - (910 + 3)))) then
				v96 = (v94[35 - 21] and v19(v94[1698 - (1466 + 218)])) or v19(0 + 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v104;
	local v105;
	local function v106()
		local v124 = UnitGetTotalAbsorbs(v15);
		if ((v124 > (1148 - (556 + 592))) or ((1535 + 2780) < (2534 - (329 + 479)))) then
			return true;
		else
			return false;
		end
	end
	local function v107(v125)
		return (v125:HealthPercentage() > (874 - (174 + 680))) or (v97.Massacre:IsAvailable() and (v125:HealthPercentage() < (120 - 85)));
	end
	local function v108(v126)
		return (v126:DebuffStack(v97.ExecutionersPrecisionDebuff) == (3 - 1)) or (v126:DebuffRemains(v97.DeepWoundsDebuff) <= v14:GCD()) or (v97.Dreadnaught:IsAvailable() and v97.Battlelord:IsAvailable() and (v105 <= (2 + 0)));
	end
	local function v109(v127)
		return v14:BuffUp(v97.SuddenDeathBuff) or ((v105 <= (741 - (396 + 343))) and ((v127:HealthPercentage() < (2 + 18)) or (v97.Massacre:IsAvailable() and (v127:HealthPercentage() < (1512 - (29 + 1448)))))) or v14:BuffUp(v97.SweepingStrikes);
	end
	local function v110()
		local v128 = 1389 - (135 + 1254);
		while true do
			if ((v128 == (11 - 8)) or ((17177 - 13498) < (417 + 208))) then
				if ((v97.BattleStance:IsCastable() and v14:BuffDown(v97.BattleStance, true) and v68 and (v14:HealthPercentage() > v81)) or ((6152 - (389 + 1138)) < (1206 - (102 + 472)))) then
					if (v24(v97.BattleStance) or ((79 + 4) > (988 + 792))) then
						return "battle_stance after defensive stance defensive";
					end
				end
				if (((510 + 36) <= (2622 - (320 + 1225))) and v98.Healthstone:IsReady() and v69 and (v14:HealthPercentage() <= v79)) then
					if (v24(v99.Healthstone) or ((1772 - 776) > (2632 + 1669))) then
						return "healthstone defensive 3";
					end
				end
				v128 = 1468 - (157 + 1307);
			end
			if (((5929 - (821 + 1038)) > (1713 - 1026)) and (v128 == (1 + 1))) then
				if ((v97.Intervene:IsCastable() and v67 and (v17:HealthPercentage() <= v77) and (v17:UnitName() ~= v14:UnitName())) or ((1164 - 508) >= (1239 + 2091))) then
					if (v24(v99.InterveneFocus) or ((6176 - 3684) <= (1361 - (834 + 192)))) then
						return "intervene defensive";
					end
				end
				if (((275 + 4047) >= (658 + 1904)) and v97.DefensiveStance:IsCastable() and v14:BuffDown(v97.DefensiveStance, true) and v68 and (v14:HealthPercentage() <= v78)) then
					if (v24(v97.DefensiveStance) or ((79 + 3558) >= (5840 - 2070))) then
						return "defensive_stance defensive";
					end
				end
				v128 = 307 - (300 + 4);
			end
			if ((v128 == (2 + 2)) or ((6227 - 3848) > (4940 - (112 + 250)))) then
				if ((v70 and (v14:HealthPercentage() <= v80)) or ((193 + 290) > (1861 - 1118))) then
					if (((1406 + 1048) > (299 + 279)) and (v86 == "Refreshing Healing Potion")) then
						if (((696 + 234) < (2211 + 2247)) and v98.RefreshingHealingPotion:IsReady()) then
							if (((492 + 170) <= (2386 - (1001 + 413))) and v24(v99.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((9745 - 5375) == (5252 - (244 + 638))) and (v86 == "Dreamwalker's Healing Potion")) then
						if (v98.DreamwalkersHealingPotion:IsReady() or ((5455 - (627 + 66)) <= (2565 - 1704))) then
							if (v24(v99.RefreshingHealingPotion) or ((2014 - (512 + 90)) == (6170 - (1665 + 241)))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((718 - (373 + 344)) == v128) or ((1429 + 1739) < (570 + 1583))) then
				if ((v97.IgnorePain:IsCastable() and v65 and (v14:HealthPercentage() <= v74)) or ((13125 - 8149) < (2253 - 921))) then
					if (((5727 - (35 + 1064)) == (3368 + 1260)) and v24(v97.IgnorePain, nil, nil, true)) then
						return "ignore_pain defensive";
					end
				end
				if ((v97.RallyingCry:IsCastable() and v66 and v14:BuffDown(v97.AspectsFavorBuff) and v14:BuffDown(v97.RallyingCry) and (((v14:HealthPercentage() <= v75) and v93.IsSoloMode()) or v93.AreUnitsBelowHealthPercentage(v75, v76))) or ((115 - 61) == (2 + 393))) then
					if (((1318 - (298 + 938)) == (1341 - (233 + 1026))) and v24(v97.RallyingCry)) then
						return "rallying_cry defensive";
					end
				end
				v128 = 1668 - (636 + 1030);
			end
			if ((v128 == (0 + 0)) or ((568 + 13) < (84 + 198))) then
				if ((v97.BitterImmunity:IsReady() and v63 and (v14:HealthPercentage() <= v72)) or ((312 + 4297) < (2716 - (55 + 166)))) then
					if (((224 + 928) == (116 + 1036)) and v24(v97.BitterImmunity)) then
						return "bitter_immunity defensive";
					end
				end
				if (((7240 - 5344) <= (3719 - (36 + 261))) and v97.DieByTheSword:IsCastable() and v64 and (v14:HealthPercentage() <= v73)) then
					if (v24(v97.DieByTheSword) or ((1731 - 741) > (2988 - (34 + 1334)))) then
						return "die_by_the_sword defensive";
					end
				end
				v128 = 1 + 0;
			end
		end
	end
	local function v111()
		v27 = v93.HandleTopTrinket(v100, v30, 32 + 8, nil);
		if (v27 or ((2160 - (1035 + 248)) > (4716 - (20 + 1)))) then
			return v27;
		end
		v27 = v93.HandleBottomTrinket(v100, v30, 21 + 19, nil);
		if (((3010 - (134 + 185)) >= (2984 - (549 + 584))) and v27) then
			return v27;
		end
	end
	local function v112()
		local v129 = 685 - (314 + 371);
		while true do
			if ((v129 == (0 - 0)) or ((3953 - (478 + 490)) >= (2573 + 2283))) then
				if (((5448 - (786 + 386)) >= (3870 - 2675)) and v101) then
					if (((4611 - (1055 + 324)) <= (6030 - (1093 + 247))) and v97.Skullsplitter:IsCastable() and v44) then
						if (v24(v97.Skullsplitter) or ((797 + 99) >= (331 + 2815))) then
							return "skullsplitter precombat";
						end
					end
					if (((12152 - 9091) >= (10038 - 7080)) and (v90 < v103) and v97.ColossusSmash:IsCastable() and v36 and ((v54 and v30) or not v54)) then
						if (((9068 - 5881) >= (1618 - 974)) and v24(v97.ColossusSmash)) then
							return "colossus_smash precombat";
						end
					end
					if (((230 + 414) <= (2712 - 2008)) and (v90 < v103) and v97.Warbreaker:IsCastable() and v49 and ((v57 and v30) or not v57)) then
						if (((3301 - 2343) > (715 + 232)) and v24(v97.Warbreaker)) then
							return "warbreaker precombat";
						end
					end
					if (((11487 - 6995) >= (3342 - (364 + 324))) and v97.Overpower:IsCastable() and v40) then
						if (((9435 - 5993) >= (3606 - 2103)) and v24(v97.Overpower)) then
							return "overpower precombat";
						end
					end
				end
				if ((v34 and v97.Charge:IsCastable()) or ((1051 + 2119) <= (6125 - 4661))) then
					if (v24(v97.Charge) or ((7681 - 2884) == (13326 - 8938))) then
						return "charge precombat";
					end
				end
				break;
			end
		end
	end
	local function v113()
		local v130 = 1268 - (1249 + 19);
		while true do
			if (((498 + 53) <= (2650 - 1969)) and (v130 == (1087 - (686 + 400)))) then
				if (((2572 + 705) > (636 - (73 + 156))) and (v90 < v103) and v97.Warbreaker:IsCastable() and v49 and ((v57 and v30) or not v57) and (v105 > (1 + 0))) then
					if (((5506 - (721 + 90)) >= (16 + 1399)) and v24(v97.Warbreaker, not v101)) then
						return "warbreaker hac 72";
					end
				end
				if (((v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) or ((10428 - 7216) <= (1414 - (224 + 246)))) then
					if (v93.CastCycle(v97.ColossusSmash, v104, v107, not v101) or ((5015 - 1919) <= (3310 - 1512))) then
						return "colossus_smash hac 73";
					end
				end
				if (((642 + 2895) == (85 + 3452)) and (v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) then
					if (((2819 + 1018) >= (3121 - 1551)) and v24(v97.ColossusSmash, not v101)) then
						return "colossus_smash hac 74";
					end
				end
				if (((v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)) or ((v105 > (3 - 2)) and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (513 - (203 + 310)))))) or ((4943 - (1238 + 755)) == (267 + 3545))) then
					if (((6257 - (709 + 825)) >= (4271 - 1953)) and v24(v97.ThunderousRoar, not v15:IsInMeleeRange(11 - 3))) then
						return "thunderous_roar hac 75";
					end
				end
				if (((v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "player") and v97.SpearofBastion:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or ((2891 - (196 + 668)) > (11260 - 8408))) then
					if (v24(v99.SpearOfBastionPlayer, not v15:IsSpellInRange(v97.SpearofBastion)) or ((2353 - 1217) > (5150 - (171 + 662)))) then
						return "spear_of_bastion hac 76";
					end
				end
				v130 = 95 - (4 + 89);
			end
			if (((16641 - 11893) == (1729 + 3019)) and (v130 == (21 - 16))) then
				if (((1466 + 2270) <= (6226 - (35 + 1451))) and v97.ThunderClap:IsReady() and v47 and (v105 > (1455 - (28 + 1425)))) then
					if (v24(v97.ThunderClap, not v101) or ((5383 - (941 + 1052)) <= (2935 + 125))) then
						return "thunder_clap hac 90";
					end
				end
				if ((v97.MortalStrike:IsReady() and v39) or ((2513 - (822 + 692)) > (3843 - 1150))) then
					if (((219 + 244) < (898 - (45 + 252))) and v24(v97.MortalStrike, not v101)) then
						return "mortal_strike hac 91";
					end
				end
				if ((v97.Rend:IsReady() and v41 and (v105 == (1 + 0)) and v15:DebuffRefreshable(v97.RendDebuff)) or ((752 + 1431) < (1671 - 984))) then
					if (((4982 - (114 + 319)) == (6530 - 1981)) and v24(v97.Rend, not v101)) then
						return "rend hac 92";
					end
				end
				if (((5986 - 1314) == (2979 + 1693)) and v97.Whirlwind:IsReady() and v50 and (v97.StormofSwords:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 > (1 - 0))))) then
					if (v24(v97.Whirlwind, not v15:IsInMeleeRange(16 - 8)) or ((5631 - (556 + 1407)) < (1601 - (741 + 465)))) then
						return "whirlwind hac 93";
					end
				end
				if ((v97.Cleave:IsReady() and v35 and not v97.CrushingForce:IsAvailable()) or ((4631 - (170 + 295)) == (240 + 215))) then
					if (v24(v97.Cleave, not v101) or ((4087 + 362) == (6556 - 3893))) then
						return "cleave hac 94";
					end
				end
				v130 = 5 + 1;
			end
			if ((v130 == (4 + 2)) or ((2422 + 1855) < (4219 - (957 + 273)))) then
				if ((v97.IgnorePain:IsReady() and v65 and v97.Battlelord:IsAvailable() and v97.AngerManagement:IsAvailable() and (v14:Rage() > (9 + 21)) and ((v15:HealthPercentage() < (9 + 11)) or (v97.Massacre:IsAvailable() and (v15:HealthPercentage() < (133 - 98))))) or ((2292 - 1422) >= (12672 - 8523))) then
					if (((10953 - 8741) < (4963 - (389 + 1391))) and v24(v97.IgnorePain, not v101)) then
						return "ignore_pain hac 95";
					end
				end
				if (((2915 + 1731) > (312 + 2680)) and v97.Slam:IsReady() and v45 and v97.CrushingForce:IsAvailable() and (v14:Rage() > (68 - 38)) and ((v97.FervorofBattle:IsAvailable() and (v105 == (952 - (783 + 168)))) or not v97.FervorofBattle:IsAvailable())) then
					if (((4812 - 3378) < (3056 + 50)) and v24(v97.Slam, not v101)) then
						return "slam hac 96";
					end
				end
				if (((1097 - (309 + 2)) < (9283 - 6260)) and v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable())) then
					if (v24(v97.Shockwave, not v15:IsInMeleeRange(1220 - (1090 + 122))) or ((792 + 1650) < (248 - 174))) then
						return "shockwave hac 97";
					end
				end
				if (((3104 + 1431) == (5653 - (628 + 490))) and v30 and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable()) then
					if (v24(v97.Bladestorm, not v101) or ((540 + 2469) <= (5211 - 3106))) then
						return "bladestorm hac 98";
					end
				end
				break;
			end
			if (((8363 - 6533) < (4443 - (431 + 343))) and (v130 == (0 - 0))) then
				if ((v97.Execute:IsReady() and v37 and v14:BuffUp(v97.JuggernautBuff) and (v14:BuffRemains(v97.JuggernautBuff) < v14:GCD())) or ((4136 - 2706) >= (2854 + 758))) then
					if (((344 + 2339) >= (4155 - (556 + 1139))) and v24(v97.Execute, not v101)) then
						return "execute hac 67";
					end
				end
				if ((v97.ThunderClap:IsReady() and v47 and (v105 > (17 - (6 + 9))) and v97.BloodandThunder:IsAvailable() and v97.Rend:IsAvailable() and v15:DebuffRefreshable(v97.RendDebuff)) or ((331 + 1473) >= (1678 + 1597))) then
					if (v24(v97.ThunderClap, not v101) or ((1586 - (28 + 141)) > (1406 + 2223))) then
						return "thunder_clap hac 68";
					end
				end
				if (((5918 - 1123) > (285 + 117)) and v97.SweepingStrikes:IsCastable() and v46 and (v105 >= (1319 - (486 + 831))) and ((v97.Bladestorm:CooldownRemains() > (38 - 23)) or not v97.Bladestorm:IsAvailable())) then
					if (((16944 - 12131) > (674 + 2891)) and v24(v97.SweepingStrikes, not v15:IsInMeleeRange(25 - 17))) then
						return "sweeping_strikes hac 68";
					end
				end
				if (((5175 - (668 + 595)) == (3521 + 391)) and ((v97.Rend:IsReady() and v41 and (v105 == (1 + 0)) and ((v15:HealthPercentage() > (54 - 34)) or (v97.Massacre:IsAvailable() and (v15:HealthPercentage() < (325 - (23 + 267)))))) or (v97.TideofBlood:IsAvailable() and (v97.Skullsplitter:CooldownRemains() <= v14:GCD()) and ((v97.ColossusSmash:CooldownRemains() < v14:GCD()) or v15:DebuffUp(v97.ColossusSmashDebuff)) and (v15:DebuffRemains(v97.RendDebuff) < ((1965 - (1129 + 815)) * (387.85 - (371 + 16))))))) then
					if (((4571 - (1326 + 424)) <= (9136 - 4312)) and v24(v97.Rend, not v101)) then
						return "rend hac 70";
					end
				end
				if (((6351 - 4613) <= (2313 - (88 + 30))) and (v90 < v103) and v31 and ((v52 and v30) or not v52) and v97.Avatar:IsCastable()) then
					if (((812 - (720 + 51)) <= (6713 - 3695)) and v24(v97.Avatar, not v101)) then
						return "avatar hac 71";
					end
				end
				v130 = 1777 - (421 + 1355);
			end
			if (((3538 - 1393) <= (2016 + 2088)) and (v130 == (1085 - (286 + 797)))) then
				if (((9829 - 7140) < (8024 - 3179)) and (v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "cursor") and v97.SpearofBastion:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) then
					if (v24(v99.SpearOfBastionCursor, not v15:IsSpellInRange(v97.SpearofBastion)) or ((2761 - (397 + 42)) > (819 + 1803))) then
						return "spear_of_bastion hac 76";
					end
				end
				if (((v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable() and v97.Unhinged:IsAvailable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or ((5334 - (24 + 776)) == (3206 - 1124))) then
					if (v24(v97.Bladestorm, not v101) or ((2356 - (222 + 563)) > (4113 - 2246))) then
						return "bladestorm hac 77";
					end
				end
				if (((v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable() and (((v105 > (1 + 0)) and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or ((v105 > (191 - (23 + 167))) and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (1798 - (690 + 1108)))))) or ((958 + 1696) >= (2472 + 524))) then
					if (((4826 - (40 + 808)) > (347 + 1757)) and v24(v97.Bladestorm, not v101)) then
						return "bladestorm hac 78";
					end
				end
				if (((11452 - 8457) > (1473 + 68)) and v97.Cleave:IsReady() and v35 and ((v105 > (2 + 0)) or (not v97.Battlelord:IsAvailable() and v14:BuffUp(v97.MercilessBonegrinderBuff) and (v97.MortalStrike:CooldownRemains() > v14:GCD())))) then
					if (((1782 + 1467) > (1524 - (47 + 524))) and v24(v97.Cleave, not v101)) then
						return "cleave hac 79";
					end
				end
				if ((v97.Whirlwind:IsReady() and v50 and ((v105 > (2 + 0)) or (v97.StormofSwords:IsAvailable() and (v14:BuffUp(v97.MercilessBonegrinderBuff) or v14:BuffUp(v97.HurricaneBuff))))) or ((8946 - 5673) > (6837 - 2264))) then
					if (v24(v97.Whirlwind, not v15:IsInMeleeRange(17 - 9)) or ((4877 - (1165 + 561)) < (39 + 1245))) then
						return "whirlwind hac 80";
					end
				end
				v130 = 9 - 6;
			end
			if ((v130 == (2 + 2)) or ((2329 - (341 + 138)) == (413 + 1116))) then
				if (((1694 - 873) < (2449 - (89 + 237))) and (v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable()) then
					if (((2901 - 1999) < (4894 - 2569)) and v24(v97.ThunderousRoar, not v15:IsInMeleeRange(889 - (581 + 300)))) then
						return "thunderous_roar hac 85";
					end
				end
				if (((2078 - (855 + 365)) <= (7035 - 4073)) and v97.Shockwave:IsCastable() and v43 and (v105 > (1 + 1)) and (v97.SonicBoom:IsAvailable() or v15:IsCasting())) then
					if (v24(v97.Shockwave, not v15:IsInMeleeRange(1243 - (1030 + 205))) or ((3705 + 241) < (1199 + 89))) then
						return "shockwave hac 86";
					end
				end
				if ((v97.Overpower:IsCastable() and v40 and (v105 == (287 - (156 + 130))) and (((v97.Overpower:Charges() == (4 - 2)) and not v97.Battlelord:IsAvailable() and (v15:Debuffdown(v97.ColossusSmashDebuff) or (v14:RagePercentage() < (42 - 17)))) or v97.Battlelord:IsAvailable())) or ((6639 - 3397) == (150 + 417))) then
					if (v24(v97.Overpower, not v101) or ((494 + 353) >= (1332 - (10 + 59)))) then
						return "overpower hac 87";
					end
				end
				if ((v97.Slam:IsReady() and v45 and (v105 == (1 + 0)) and not v97.Battlelord:IsAvailable() and (v14:RagePercentage() > (344 - 274))) or ((3416 - (671 + 492)) == (1474 + 377))) then
					if (v24(v97.Slam, not v101) or ((3302 - (369 + 846)) > (628 + 1744))) then
						return "slam hac 88";
					end
				end
				if ((v97.Overpower:IsCastable() and v40 and (((v97.Overpower:Charges() == (2 + 0)) and (not v97.TestofMight:IsAvailable() or (v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)) or v97.Battlelord:IsAvailable())) or (v14:Rage() < (2015 - (1036 + 909))))) or ((3535 + 910) < (6965 - 2816))) then
					if (v24(v97.Overpower, not v101) or ((2021 - (11 + 192)) == (43 + 42))) then
						return "overpower hac 89";
					end
				end
				v130 = 180 - (135 + 40);
			end
			if (((1526 - 896) < (1283 + 844)) and (v130 == (6 - 3))) then
				if ((v97.Skullsplitter:IsCastable() and v44 and ((v14:Rage() < (59 - 19)) or (v97.TideofBlood:IsAvailable() and (v15:DebuffRemains(v97.RendDebuff) > (176 - (50 + 126))) and ((v14:BuffUp(v97.SweepingStrikes) and (v105 > (5 - 3))) or v15:DebuffUp(v97.ColossusSmashDebuff) or v14:BuffUp(v97.TestofMightBuff))))) or ((429 + 1509) == (3927 - (1233 + 180)))) then
					if (((5224 - (522 + 447)) >= (1476 - (107 + 1314))) and v24(v97.Skullsplitter, not v15:IsInMeleeRange(4 + 4))) then
						return "sweeping_strikes execute 81";
					end
				end
				if (((9137 - 6138) > (491 + 665)) and v97.MortalStrike:IsReady() and v39 and v14:BuffUp(v97.SweepingStrikes) and (v14:BuffStack(v97.CrushingAdvanceBuff) == (5 - 2))) then
					if (((9298 - 6948) > (3065 - (716 + 1194))) and v24(v97.MortalStrike, not v101)) then
						return "mortal_strike hac 81.5";
					end
				end
				if (((69 + 3960) <= (520 + 4333)) and v97.Overpower:IsCastable() and v40 and v14:BuffUp(v97.SweepingStrikes) and v97.Dreadnaught:IsAvailable()) then
					if (v24(v97.Overpower, not v101) or ((1019 - (74 + 429)) > (6623 - 3189))) then
						return "overpower hac 82";
					end
				end
				if (((2006 + 2040) >= (6942 - 3909)) and v97.MortalStrike:IsReady() and v39) then
					if (v93.CastCycle(v97.MortalStrike, v104, v108, not v101) or ((1924 + 795) <= (4460 - 3013))) then
						return "mortal_strike hac 83";
					end
				end
				if ((v97.Execute:IsReady() and v37 and (v14:BuffUp(v97.SuddenDeathBuff) or ((v105 <= (4 - 2)) and ((v15:HealthPercentage() < (453 - (279 + 154))) or (v97.Massacre:IsAvailable() and (v15:HealthPercentage() < (813 - (454 + 324)))))) or v14:BuffUp(v97.SweepingStrikes))) or ((3253 + 881) < (3943 - (12 + 5)))) then
					if (v93.CastCycle(v97.Execute, v104, v109, not v101) or ((89 + 75) >= (7096 - 4311))) then
						return "execute hac 84";
					end
				end
				v130 = 2 + 2;
			end
		end
	end
	local function v114()
		local v131 = 1093 - (277 + 816);
		while true do
			if ((v131 == (8 - 6)) or ((1708 - (1058 + 125)) == (396 + 1713))) then
				if (((1008 - (815 + 160)) == (141 - 108)) and (v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "player") and v97.SpearofBastion:IsCastable() and (v15:DebuffUp(v97.ColossusSmashDebuff) or v14:BuffUp(v97.TestofMightBuff))) then
					if (((7249 - 4195) <= (958 + 3057)) and v24(v99.SpearOfBastionPlayer, not v15:IsSpellInRange(v97.SpearofBastion))) then
						return "spear_of_bastion execute 57";
					end
				end
				if (((5469 - 3598) < (5280 - (41 + 1857))) and (v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "cursor") and v97.SpearofBastion:IsCastable() and (v15:DebuffUp(v97.ColossusSmashDebuff) or v14:BuffUp(v97.TestofMightBuff))) then
					if (((3186 - (1222 + 671)) <= (5597 - 3431)) and v24(v99.SpearOfBastionCursor, not v15:IsSpellInRange(v97.SpearofBastion))) then
						return "spear_of_bastion execute 57";
					end
				end
				if ((v97.Cleave:IsReady() and v35 and (v105 > (2 - 0)) and (v15:DebuffRemains(v97.DeepWoundsDebuff) < v14:GCD())) or ((3761 - (229 + 953)) < (1897 - (1111 + 663)))) then
					if (v24(v97.Cleave, not v101) or ((2425 - (874 + 705)) >= (332 + 2036))) then
						return "cleave execute 58";
					end
				end
				if ((v97.MortalStrike:IsReady() and v39 and ((v15:DebuffStack(v97.ExecutionersPrecisionDebuff) == (2 + 0)) or (v15:DebuffRemains(v97.DeepWoundsDebuff) <= v14:GCD()))) or ((8338 - 4326) <= (95 + 3263))) then
					if (((2173 - (642 + 37)) <= (686 + 2319)) and v24(v97.MortalStrike, not v101)) then
						return "mortal_strike execute 59";
					end
				end
				v131 = 1 + 2;
			end
			if (((2 - 1) == v131) or ((3565 - (233 + 221)) == (4934 - 2800))) then
				if (((2073 + 282) == (3896 - (718 + 823))) and (v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) then
					if (v24(v97.ColossusSmash, not v101) or ((371 + 217) <= (1237 - (266 + 539)))) then
						return "colossus_smash execute 55";
					end
				end
				if (((13581 - 8784) >= (5120 - (636 + 589))) and v97.Execute:IsReady() and v37 and v14:BuffUp(v97.SuddenDeathBuff) and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (0 - 0))) then
					if (((7377 - 3800) == (2835 + 742)) and v24(v97.Execute, not v101)) then
						return "execute execute 56";
					end
				end
				if (((1379 + 2415) > (4708 - (657 + 358))) and v97.Skullsplitter:IsCastable() and v44 and ((v97.TestofMight:IsAvailable() and (v14:RagePercentage() <= (79 - 49))) or (not v97.TestofMight:IsAvailable() and (v15:DebuffUp(v97.ColossusSmashDebuff) or (v97.ColossusSmash:CooldownRemains() > (11 - 6))) and (v14:RagePercentage() <= (1217 - (1151 + 36)))))) then
					if (v24(v97.Skullsplitter, not v15:IsInMeleeRange(8 + 0)) or ((336 + 939) == (12244 - 8144))) then
						return "skullsplitter execute 57";
					end
				end
				if (((v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or ((3423 - (1552 + 280)) >= (4414 - (64 + 770)))) then
					if (((668 + 315) <= (4104 - 2296)) and v24(v97.ThunderousRoar, not v15:IsInMeleeRange(2 + 6))) then
						return "thunderous_roar execute 57";
					end
				end
				v131 = 1245 - (157 + 1086);
			end
			if ((v131 == (7 - 3)) or ((9416 - 7266) <= (1836 - 639))) then
				if (((5143 - 1374) >= (1992 - (599 + 220))) and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable()) then
					if (((2956 - 1471) == (3416 - (1813 + 118))) and v24(v97.Bladestorm, not v101)) then
						return "bladestorm execute 65";
					end
				end
				break;
			end
			if ((v131 == (0 + 0)) or ((4532 - (841 + 376)) <= (3897 - 1115))) then
				if (((v90 < v103) and v46 and v97.SweepingStrikes:IsCastable() and (v105 > (1 + 0))) or ((2391 - 1515) >= (3823 - (464 + 395)))) then
					if (v24(v97.SweepingStrikes, not v15:IsInMeleeRange(20 - 12)) or ((1072 + 1160) > (3334 - (467 + 370)))) then
						return "sweeping_strikes execute 51";
					end
				end
				if ((v97.Rend:IsReady() and v41 and (v15:DebuffRemains(v97.RendDebuff) <= v14:GCD()) and not v97.Bloodletting:IsAvailable() and ((not v97.Warbreaker:IsAvailable() and (v97.ColossusSmash:CooldownRemains() < (8 - 4))) or (v97.Warbreaker:IsAvailable() and (v97.Warbreaker:CooldownRemains() < (3 + 1)))) and (v15:TimeToDie() > (40 - 28))) or ((330 + 1780) <= (772 - 440))) then
					if (((4206 - (150 + 370)) > (4454 - (74 + 1208))) and v24(v97.Rend, not v101)) then
						return "rend execute 52";
					end
				end
				if (((v90 < v103) and v31 and ((v52 and v30) or not v52) and v97.Avatar:IsCastable() and (v97.ColossusSmash:CooldownUp() or v15:DebuffUp(v97.ColossusSmashDebuff) or (v103 < (49 - 29)))) or ((21218 - 16744) < (584 + 236))) then
					if (((4669 - (14 + 376)) >= (4998 - 2116)) and v24(v97.Avatar, not v101)) then
						return "avatar execute 53";
					end
				end
				if (((v90 < v103) and v49 and ((v57 and v30) or not v57) and v97.Warbreaker:IsCastable()) or ((1313 + 716) >= (3094 + 427))) then
					if (v24(v97.Warbreaker, not v101) or ((1943 + 94) >= (13601 - 8959))) then
						return "warbreaker execute 54";
					end
				end
				v131 = 1 + 0;
			end
			if (((1798 - (23 + 55)) < (10565 - 6107)) and (v131 == (3 + 0))) then
				if ((v97.Overpower:IsCastable() and v40 and (v14:Rage() < (36 + 4)) and (v14:BuffStack(v97.MartialProwessBuff) < (2 - 0))) or ((138 + 298) > (3922 - (652 + 249)))) then
					if (((1908 - 1195) <= (2715 - (708 + 1160))) and v24(v97.Overpower, not v101)) then
						return "overpower execute 60";
					end
				end
				if (((5846 - 3692) <= (7349 - 3318)) and v97.Execute:IsReady() and v37) then
					if (((4642 - (10 + 17)) == (1037 + 3578)) and v24(v97.Execute, not v101)) then
						return "execute execute 62";
					end
				end
				if ((v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable() or v15:IsCasting())) or ((5522 - (1400 + 332)) == (959 - 459))) then
					if (((1997 - (242 + 1666)) < (95 + 126)) and v24(v97.Shockwave, not v15:IsInMeleeRange(3 + 5))) then
						return "shockwave execute 63";
					end
				end
				if (((1751 + 303) >= (2361 - (850 + 90))) and v97.Overpower:IsCastable() and v40) then
					if (((1211 - 519) < (4448 - (360 + 1030))) and v24(v97.Overpower, not v101)) then
						return "overpower execute 64";
					end
				end
				v131 = 4 + 0;
			end
		end
	end
	local function v115()
		local v132 = 0 - 0;
		while true do
			if ((v132 == (0 - 0)) or ((4915 - (909 + 752)) == (2878 - (109 + 1114)))) then
				if (((v90 < v103) and v46 and v97.SweepingStrikes:IsCastable() and (v105 > (1 - 0))) or ((505 + 791) == (5152 - (6 + 236)))) then
					if (((2122 + 1246) == (2711 + 657)) and v24(v97.SweepingStrikes, not v15:IsInMeleeRange(18 - 10))) then
						return "sweeping_strikes single_target 97";
					end
				end
				if (((4616 - 1973) < (4948 - (1076 + 57))) and v97.Execute:IsReady() and (v14:BuffUp(v97.SuddenDeathBuff))) then
					if (((315 + 1598) > (1182 - (579 + 110))) and v24(v97.Execute, not v101)) then
						return "execute single_target 98";
					end
				end
				if (((376 + 4379) > (3031 + 397)) and v97.MortalStrike:IsReady() and v39) then
					if (((733 + 648) <= (2776 - (174 + 233))) and v24(v97.MortalStrike, not v101)) then
						return "mortal_strike single_target 99";
					end
				end
				v132 = 2 - 1;
			end
			if ((v132 == (1 - 0)) or ((2154 + 2689) == (5258 - (663 + 511)))) then
				if (((4166 + 503) > (79 + 284)) and v97.Rend:IsReady() and v41 and ((v15:DebuffRemains(v97.RendDebuff) <= v14:GCD()) or (v97.TideofBlood:IsAvailable() and (v97.Skullsplitter:CooldownRemains() <= v14:GCD()) and ((v97.ColossusSmash:CooldownRemains() <= v14:GCD()) or v15:DebuffUp(v97.ColossusSmashDebuff)) and (v15:DebuffRemains(v97.RendDebuff) < (v97.RendDebuff:BaseDuration() * (0.85 - 0)))))) then
					if (v24(v97.Rend, not v101) or ((1137 + 740) >= (7387 - 4249))) then
						return "rend single_target 100";
					end
				end
				if (((11479 - 6737) >= (1731 + 1895)) and (v90 < v103) and v31 and ((v52 and v30) or not v52) and v97.Avatar:IsCastable() and ((v97.WarlordsTorment:IsAvailable() and (v14:RagePercentage() < (63 - 30)) and (v97.ColossusSmash:CooldownUp() or v15:DebuffUp(v97.ColossusSmashDebuff) or v14:BuffUp(v97.TestofMightBuff))) or (not v97.WarlordsTorment:IsAvailable() and (v97.ColossusSmash:CooldownUp() or v15:DebuffUp(v97.ColossusSmashDebuff))))) then
					if (v24(v97.Avatar, not v101) or ((3236 + 1304) == (84 + 832))) then
						return "avatar single_target 101";
					end
				end
				if (((v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "player") and v97.SpearofBastion:IsCastable() and ((v97.ColossusSmash:CooldownRemains() <= v14:GCD()) or (v97.Warbreaker:CooldownRemains() <= v14:GCD()))) or ((1878 - (478 + 244)) > (4862 - (440 + 77)))) then
					if (((1018 + 1219) < (15551 - 11302)) and v24(v99.SpearOfBastionPlayer, not v15:IsSpellInRange(v97.SpearofBastion))) then
						return "spear_of_bastion single_target 102";
					end
				end
				v132 = 1558 - (655 + 901);
			end
			if ((v132 == (1 + 3)) or ((2055 + 628) < (16 + 7))) then
				if (((2807 - 2110) <= (2271 - (695 + 750))) and v97.Whirlwind:IsReady() and v50 and v97.StormofSwords:IsAvailable() and v97.TestofMight:IsAvailable() and (v14:RagePercentage() > (273 - 193)) and v15:DebuffUp(v97.ColossusSmashDebuff)) then
					if (((1704 - 599) <= (4729 - 3553)) and v24(v97.Whirlwind, not v15:IsInMeleeRange(359 - (285 + 66)))) then
						return "whirlwind single_target 108";
					end
				end
				if (((7876 - 4497) <= (5122 - (682 + 628))) and v97.ThunderClap:IsReady() and v47 and (v15:DebuffRemains(v97.RendDebuff) <= v14:GCD()) and not v97.TideofBlood:IsAvailable()) then
					if (v24(v97.ThunderClap, not v101) or ((128 + 660) >= (1915 - (176 + 123)))) then
						return "thunder_clap single_target 109";
					end
				end
				if (((776 + 1078) <= (2452 + 927)) and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable() and ((v97.Hurricane:IsAvailable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or (v97.Unhinged:IsAvailable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))))) then
					if (((4818 - (239 + 30)) == (1237 + 3312)) and v24(v97.Bladestorm, not v101)) then
						return "bladestorm single_target 110";
					end
				end
				v132 = 5 + 0;
			end
			if ((v132 == (13 - 5)) or ((9428 - 6406) >= (3339 - (306 + 9)))) then
				if (((16819 - 11999) > (383 + 1815)) and v97.Cleave:IsReady() and v35 and v14:HasTier(18 + 11, 1 + 1) and not v97.CrushingForce:IsAvailable()) then
					if (v24(v97.Cleave, not v101) or ((3033 - 1972) >= (6266 - (1140 + 235)))) then
						return "cleave single_target 121";
					end
				end
				if (((869 + 495) <= (4102 + 371)) and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable()) then
					if (v24(v97.Bladestorm, not v101) or ((923 + 2672) <= (55 - (33 + 19)))) then
						return "bladestorm single_target 122";
					end
				end
				if ((v97.Cleave:IsReady() and v35) or ((1687 + 2985) == (11545 - 7693))) then
					if (((687 + 872) == (3056 - 1497)) and v24(v97.Cleave, not v101)) then
						return "cleave single_target 123";
					end
				end
				v132 = 9 + 0;
			end
			if ((v132 == (695 - (586 + 103))) or ((160 + 1592) <= (2425 - 1637))) then
				if ((v97.Slam:IsReady() and v45 and ((v97.CrushingForce:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff) and (v14:Rage() >= (1548 - (1309 + 179))) and v97.TestofMight:IsAvailable()) or v97.ImprovedSlam:IsAvailable()) and (not v97.FervorofBattle:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 == (1 - 0))))) or ((1701 + 2206) == (475 - 298))) then
					if (((2622 + 848) > (1179 - 624)) and v24(v97.Slam, not v101)) then
						return "slam single_target 115";
					end
				end
				if ((v97.Whirlwind:IsReady() and v50 and (v97.StormofSwords:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 > (1 - 0))))) or ((1581 - (295 + 314)) == (1584 - 939))) then
					if (((5144 - (1300 + 662)) >= (6641 - 4526)) and v24(v97.Whirlwind, not v15:IsInMeleeRange(1763 - (1178 + 577)))) then
						return "whirlwind single_target 116";
					end
				end
				if (((2022 + 1871) < (13092 - 8663)) and v97.Slam:IsReady() and v45 and (v97.CrushingForce:IsAvailable() or (not v97.CrushingForce:IsAvailable() and (v14:Rage() >= (1435 - (851 + 554))))) and (not v97.FervorofBattle:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 == (1 + 0))))) then
					if (v24(v97.Slam, not v101) or ((7950 - 5083) < (4137 - 2232))) then
						return "slam single_target 117";
					end
				end
				v132 = 309 - (115 + 187);
			end
			if ((v132 == (2 + 0)) or ((1701 + 95) >= (15963 - 11912))) then
				if (((2780 - (160 + 1001)) <= (3286 + 470)) and (v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "cursor") and v97.SpearofBastion:IsCastable() and ((v97.ColossusSmash:CooldownRemains() <= v14:GCD()) or (v97.Warbreaker:CooldownRemains() <= v14:GCD()))) then
					if (((417 + 187) == (1235 - 631)) and v24(v99.SpearOfBastionCursor, not v15:IsSpellInRange(v97.SpearofBastion))) then
						return "spear_of_bastion single_target 102";
					end
				end
				if (((v90 < v103) and v49 and ((v57 and v30) or not v57) and v97.Warbreaker:IsCastable()) or ((4842 - (237 + 121)) == (1797 - (525 + 372)))) then
					if (v24(v97.Warbreaker, not v15:IsInRange(14 - 6)) or ((14650 - 10191) <= (1255 - (96 + 46)))) then
						return "warbreaker single_target 103";
					end
				end
				if (((4409 - (643 + 134)) > (1227 + 2171)) and (v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) then
					if (((9787 - 5705) <= (18255 - 13338)) and v24(v97.ColossusSmash, not v101)) then
						return "colossus_smash single_target 104";
					end
				end
				v132 = 3 + 0;
			end
			if (((9482 - 4650) >= (2833 - 1447)) and (v132 == (728 - (316 + 403)))) then
				if (((92 + 45) == (376 - 239)) and v97.Rend:IsReady() and v41 and v15:DebuffRefreshable(v97.RendDebuff) and not v97.CrushingForce:IsAvailable()) then
					if (v24(v97.Rend, not v101) or ((568 + 1002) >= (10909 - 6577))) then
						return "rend single_target 124";
					end
				end
				break;
			end
			if ((v132 == (4 + 1)) or ((1310 + 2754) <= (6302 - 4483))) then
				if ((v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable() or v15:IsCasting())) or ((23812 - 18826) < (3269 - 1695))) then
					if (((254 + 4172) > (338 - 166)) and v24(v97.Shockwave, not v15:IsInMeleeRange(1 + 7))) then
						return "shockwave single_target 111";
					end
				end
				if (((1724 - 1138) > (472 - (12 + 5))) and v97.Whirlwind:IsReady() and v50 and v97.StormofSwords:IsAvailable() and v97.TestofMight:IsAvailable() and (v97.ColossusSmash:CooldownRemains() > (v14:GCD() * (27 - 20)))) then
					if (((1761 - 935) == (1755 - 929)) and v24(v97.Whirlwind, not v15:IsInMeleeRange(19 - 11))) then
						return "whirlwind single_target 113";
					end
				end
				if ((v97.Overpower:IsCastable() and v40 and (((v97.Overpower:Charges() == (1 + 1)) and not v97.Battlelord:IsAvailable() and (v15:DebuffUp(v97.ColossusSmashDebuff) or (v14:RagePercentage() < (1998 - (1656 + 317))))) or v97.Battlelord:IsAvailable())) or ((3582 + 437) > (3559 + 882))) then
					if (((5362 - 3345) < (20970 - 16709)) and v24(v97.Overpower, not v101)) then
						return "overpower single_target 114";
					end
				end
				v132 = 360 - (5 + 349);
			end
			if (((22400 - 17684) > (1351 - (266 + 1005))) and (v132 == (2 + 1))) then
				if ((v97.Skullsplitter:IsCastable() and v44 and not v97.TestofMight:IsAvailable() and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (0 - 0)) and (v15:DebuffUp(v97.ColossusSmashDebuff) or (v97.ColossusSmash:CooldownRemains() > (3 - 0)))) or ((5203 - (561 + 1135)) == (4263 - 991))) then
					if (v24(v97.Skullsplitter, not v101) or ((2879 - 2003) >= (4141 - (507 + 559)))) then
						return "skullsplitter single_target 105";
					end
				end
				if (((10920 - 6568) > (7898 - 5344)) and v97.Skullsplitter:IsCastable() and v44 and v97.TestofMight:IsAvailable() and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (388 - (212 + 176)))) then
					if (v24(v97.Skullsplitter, not v101) or ((5311 - (250 + 655)) < (11024 - 6981))) then
						return "skullsplitter single_target 106";
					end
				end
				if (((v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff) and (v14:RagePercentage() < (57 - 24))) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or ((2954 - 1065) >= (5339 - (1869 + 87)))) then
					if (((6562 - 4670) <= (4635 - (484 + 1417))) and v24(v97.ThunderousRoar, not v15:IsInMeleeRange(16 - 8))) then
						return "thunderous_roar single_target 107";
					end
				end
				v132 = 6 - 2;
			end
			if (((2696 - (48 + 725)) < (3622 - 1404)) and (v132 == (18 - 11))) then
				if (((1263 + 910) > (1012 - 633)) and v97.ThunderClap:IsReady() and v47 and v97.Battlelord:IsAvailable() and v97.BloodandThunder:IsAvailable()) then
					if (v24(v97.ThunderClap, not v101) or ((726 + 1865) == (994 + 2415))) then
						return "thunder_clap single_target 118";
					end
				end
				if (((5367 - (152 + 701)) > (4635 - (430 + 881))) and v97.Overpower:IsCastable() and v40 and ((v15:DebuffDown(v97.ColossusSmashDebuff) and (v14:RagePercentage() < (20 + 30)) and not v97.Battlelord:IsAvailable()) or (v14:RagePercentage() < (920 - (557 + 338))))) then
					if (v24(v97.Overpower, not v101) or ((62 + 146) >= (13605 - 8777))) then
						return "overpower single_target 119";
					end
				end
				if ((v97.Whirlwind:IsReady() and v50 and v14:BuffUp(v97.MercilessBonegrinderBuff)) or ((5542 - 3959) > (9476 - 5909))) then
					if (v24(v97.Whirlwind, not v15:IsInRange(17 - 9)) or ((2114 - (499 + 302)) == (1660 - (39 + 827)))) then
						return "whirlwind single_target 120";
					end
				end
				v132 = 21 - 13;
			end
		end
	end
	local function v116()
		local v133 = 0 - 0;
		while true do
			if (((12606 - 9432) > (4454 - 1552)) and (v133 == (0 + 0))) then
				if (((12058 - 7938) <= (682 + 3578)) and not v14:AffectingCombat()) then
					local v190 = 0 - 0;
					while true do
						if (((104 - (103 + 1)) == v190) or ((1437 - (475 + 79)) > (10328 - 5550))) then
							if ((v97.BattleStance:IsCastable() and v14:BuffDown(v97.BattleStance, true)) or ((11584 - 7964) >= (633 + 4258))) then
								if (((3748 + 510) > (2440 - (1395 + 108))) and v24(v97.BattleStance)) then
									return "battle_stance";
								end
							end
							if ((v97.BattleShout:IsCastable() and v32 and (v14:BuffDown(v97.BattleShoutBuff, true) or v93.GroupBuffMissing(v97.BattleShoutBuff))) or ((14168 - 9299) < (2110 - (7 + 1197)))) then
								if (v24(v97.BattleShout) or ((535 + 690) > (1476 + 2752))) then
									return "battle_shout precombat";
								end
							end
							break;
						end
					end
				end
				if (((3647 - (27 + 292)) > (6557 - 4319)) and v93.TargetIsValid() and v28) then
					if (((4894 - 1055) > (5892 - 4487)) and not v14:AffectingCombat()) then
						local v192 = 0 - 0;
						while true do
							if ((v192 == (0 - 0)) or ((1432 - (43 + 96)) <= (2068 - 1561))) then
								v27 = v112();
								if (v27 or ((6547 - 3651) < (668 + 137))) then
									return v27;
								end
								break;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v117()
		v27 = v110();
		if (((654 + 1662) == (4577 - 2261)) and v27) then
			return v27;
		end
		if (v85 or ((985 + 1585) == (2872 - 1339))) then
			local v174 = 0 + 0;
			while true do
				if ((v174 == (0 + 0)) or ((2634 - (1414 + 337)) == (3400 - (1642 + 298)))) then
					v27 = v93.HandleIncorporeal(v97.StormBolt, v99.StormBoltMouseover, 52 - 32, true);
					if (v27 or ((13287 - 8668) <= (2964 - 1965))) then
						return v27;
					end
					v174 = 1 + 0;
				end
				if ((v174 == (1 + 0)) or ((4382 - (357 + 615)) > (2890 + 1226))) then
					v27 = v93.HandleIncorporeal(v97.IntimidatingShout, v99.IntimidatingShoutMouseover, 19 - 11, true);
					if (v27 or ((774 + 129) >= (6555 - 3496))) then
						return v27;
					end
					break;
				end
			end
		end
		if (v93.TargetIsValid() or ((3180 + 796) < (195 + 2662))) then
			local v175 = 0 + 0;
			local v176;
			while true do
				if (((6231 - (384 + 917)) > (3004 - (128 + 569))) and (v175 == (1544 - (1407 + 136)))) then
					if ((v90 < v103) or ((5933 - (687 + 1200)) < (3001 - (556 + 1154)))) then
						if ((v92 and ((v30 and v58) or not v58)) or ((14920 - 10679) == (3640 - (9 + 86)))) then
							local v197 = 421 - (275 + 146);
							while true do
								if ((v197 == (0 + 0)) or ((4112 - (29 + 35)) > (18755 - 14523))) then
									v27 = v111();
									if (v27 or ((5227 - 3477) >= (15331 - 11858))) then
										return v27;
									end
									break;
								end
							end
						end
					end
					if (((2063 + 1103) == (4178 - (53 + 959))) and v38 and v97.HeroicThrow:IsCastable() and not v15:IsInRange(438 - (312 + 96))) then
						if (((3059 - 1296) < (4009 - (147 + 138))) and v24(v97.HeroicThrow, not v15:IsInRange(929 - (813 + 86)))) then
							return "heroic_throw main";
						end
					end
					if (((52 + 5) <= (5044 - 2321)) and v97.WreckingThrow:IsCastable() and v51 and v15:AffectingCombat() and v106()) then
						if (v24(v97.WreckingThrow, not v15:IsInRange(522 - (18 + 474))) or ((699 + 1371) == (1445 - 1002))) then
							return "wrecking_throw main";
						end
					end
					if ((v29 and (v105 > (1088 - (860 + 226)))) or ((3008 - (121 + 182)) == (172 + 1221))) then
						local v193 = 1240 - (988 + 252);
						while true do
							if ((v193 == (0 + 0)) or ((1442 + 3159) < (2031 - (49 + 1921)))) then
								v27 = v113();
								if (v27 or ((2280 - (223 + 667)) >= (4796 - (51 + 1)))) then
									return v27;
								end
								break;
							end
						end
					end
					v175 = 2 - 0;
				end
				if ((v175 == (0 - 0)) or ((3128 - (146 + 979)) > (1083 + 2751))) then
					if ((v34 and v97.Charge:IsCastable() and not v101) or ((761 - (311 + 294)) > (10912 - 6999))) then
						if (((83 + 112) == (1638 - (496 + 947))) and v24(v97.Charge, not v15:IsSpellInRange(v97.Charge))) then
							return "charge main 34";
						end
					end
					v176 = v93.HandleDPSPotion(v15:DebuffUp(v97.ColossusSmashDebuff));
					if (((4463 - (1233 + 125)) >= (729 + 1067)) and v176) then
						return v176;
					end
					if (((3929 + 450) >= (405 + 1726)) and v101 and v91 and ((v59 and v30) or not v59) and (v90 < v103)) then
						local v194 = 1645 - (963 + 682);
						while true do
							if (((3208 + 636) >= (3547 - (504 + 1000))) and (v194 == (3 + 0))) then
								if ((v97.BagofTricks:IsCastable() and v15:DebuffDown(v97.ColossusSmashDebuff) and not v97.MortalStrike:CooldownUp()) or ((2944 + 288) <= (258 + 2473))) then
									if (((7233 - 2328) == (4191 + 714)) and v24(v97.BagofTricks, not v15:IsSpellInRange(v97.BagofTricks))) then
										return "bag_of_tricks main 10";
									end
								end
								break;
							end
							if ((v194 == (1 + 0)) or ((4318 - (156 + 26)) >= (2542 + 1869))) then
								if ((v97.ArcaneTorrent:IsCastable() and (v97.MortalStrike:CooldownRemains() > (1.5 - 0)) and (v14:Rage() < (214 - (149 + 15)))) or ((3918 - (890 + 70)) == (4134 - (39 + 78)))) then
									if (((1710 - (14 + 468)) >= (1787 - 974)) and v24(v97.ArcaneTorrent, not v15:IsInRange(22 - 14))) then
										return "arcane_torrent main 41";
									end
								end
								if ((v97.LightsJudgment:IsCastable() and v15:DebuffDown(v97.ColossusSmashDebuff) and not v97.MortalStrike:CooldownUp()) or ((1783 + 1672) > (2433 + 1617))) then
									if (((52 + 191) == (110 + 133)) and v24(v97.LightsJudgment, not v15:IsSpellInRange(v97.LightsJudgment))) then
										return "lights_judgment main 42";
									end
								end
								v194 = 1 + 1;
							end
							if ((v194 == (0 - 0)) or ((268 + 3) > (5523 - 3951))) then
								if (((70 + 2669) < (3344 - (12 + 39))) and v97.BloodFury:IsCastable() and v15:DebuffUp(v97.ColossusSmashDebuff)) then
									if (v24(v97.BloodFury) or ((3668 + 274) < (3509 - 2375))) then
										return "blood_fury main 39";
									end
								end
								if ((v97.Berserking:IsCastable() and (v15:DebuffRemains(v97.ColossusSmashDebuff) > (21 - 15))) or ((799 + 1894) == (2618 + 2355))) then
									if (((5441 - 3295) == (1430 + 716)) and v24(v97.Berserking)) then
										return "berserking main 40";
									end
								end
								v194 = 4 - 3;
							end
							if ((v194 == (1712 - (1596 + 114))) or ((5858 - 3614) == (3937 - (164 + 549)))) then
								if ((v97.Fireblood:IsCastable() and (v15:DebuffUp(v97.ColossusSmashDebuff))) or ((6342 - (1059 + 379)) <= (2378 - 462))) then
									if (((47 + 43) <= (180 + 885)) and v24(v97.Fireblood)) then
										return "fireblood main 43";
									end
								end
								if (((5194 - (145 + 247)) == (3941 + 861)) and v97.AncestralCall:IsCastable() and (v15:DebuffUp(v97.ColossusSmashDebuff))) then
									if (v24(v97.AncestralCall) or ((1054 + 1226) <= (1514 - 1003))) then
										return "ancestral_call main 44";
									end
								end
								v194 = 1 + 2;
							end
						end
					end
					v175 = 1 + 0;
				end
				if ((v175 == (2 - 0)) or ((2396 - (254 + 466)) <= (1023 - (544 + 16)))) then
					if (((12295 - 8426) == (4497 - (294 + 334))) and ((v97.Massacre:IsAvailable() and (v15:HealthPercentage() < (288 - (236 + 17)))) or (v15:HealthPercentage() < (9 + 11)))) then
						v27 = v114();
						if (((902 + 256) <= (9840 - 7227)) and v27) then
							return v27;
						end
					end
					v27 = v115();
					if (v27 or ((11192 - 8828) <= (1030 + 969))) then
						return v27;
					end
					if (v20.CastAnnotated(v97.Pool, false, "WAIT") or ((4054 + 868) < (988 - (413 + 381)))) then
						return "Wait/Pool Resources";
					end
					break;
				end
			end
		end
	end
	local function v118()
		v32 = EpicSettings.Settings['useBattleShout'];
		v34 = EpicSettings.Settings['useCharge'];
		v35 = EpicSettings.Settings['useCleave'];
		v37 = EpicSettings.Settings['useExecute'];
		v38 = EpicSettings.Settings['useHeroicThrow'];
		v39 = EpicSettings.Settings['useMortalStrike'];
		v40 = EpicSettings.Settings['useOverpower'];
		v41 = EpicSettings.Settings['useRend'];
		v43 = EpicSettings.Settings['useShockwave'];
		v44 = EpicSettings.Settings['useSkullsplitter'];
		v45 = EpicSettings.Settings['useSlam'];
		v46 = EpicSettings.Settings['useSweepingStrikes'];
		v47 = EpicSettings.Settings['useThunderClap'];
		v50 = EpicSettings.Settings['useWhirlwind'];
		v51 = EpicSettings.Settings['useWreckingThrow'];
		v31 = EpicSettings.Settings['useAvatar'];
		v33 = EpicSettings.Settings['useBladestorm'];
		v36 = EpicSettings.Settings['useColossusSmash'];
		v83 = EpicSettings.Settings['useSpearOfBastion'];
		v48 = EpicSettings.Settings['useThunderousRoar'];
		v49 = EpicSettings.Settings['useWarbreaker'];
		v52 = EpicSettings.Settings['avatarWithCD'];
		v53 = EpicSettings.Settings['bladestormWithCD'];
		v54 = EpicSettings.Settings['colossusSmashWithCD'];
		v55 = EpicSettings.Settings['spearOfBastionWithCD'];
		v56 = EpicSettings.Settings['thunderousRoarWithCD'];
		v57 = EpicSettings.Settings['warbreakerWithCD'];
	end
	local function v119()
		local v161 = 0 + 0;
		while true do
			if ((v161 == (10 - 5)) or ((5431 - 3340) < (2001 - (582 + 1388)))) then
				v77 = EpicSettings.Settings['interveneHP'] or (0 - 0);
				v76 = EpicSettings.Settings['rallyingCryGroup'] or (0 + 0);
				v75 = EpicSettings.Settings['rallyingCryHP'] or (364 - (326 + 38));
				v161 = 17 - 11;
			end
			if ((v161 == (0 - 0)) or ((3050 - (47 + 573)) >= (1718 + 3154))) then
				v60 = EpicSettings.Settings['usePummel'];
				v61 = EpicSettings.Settings['useStormBolt'];
				v62 = EpicSettings.Settings['useIntimidatingShout'];
				v161 = 4 - 3;
			end
			if ((v161 == (5 - 1)) or ((6434 - (1269 + 395)) < (2227 - (76 + 416)))) then
				v81 = EpicSettings.Settings['unstanceHP'] or (443 - (319 + 124));
				v73 = EpicSettings.Settings['dieByTheSwordHP'] or (0 - 0);
				v74 = EpicSettings.Settings['ignorePainHP'] or (1007 - (564 + 443));
				v161 = 13 - 8;
			end
			if ((v161 == (461 - (337 + 121))) or ((13006 - 8567) <= (7828 - 5478))) then
				v71 = EpicSettings.Settings['useVictoryRush'];
				v72 = EpicSettings.Settings['bitterImmunityHP'] or (1911 - (1261 + 650));
				v78 = EpicSettings.Settings['defensiveStanceHP'] or (0 + 0);
				v161 = 6 - 2;
			end
			if ((v161 == (1819 - (772 + 1045))) or ((632 + 3847) < (4610 - (102 + 42)))) then
				v65 = EpicSettings.Settings['useIgnorePain'];
				v67 = EpicSettings.Settings['useIntervene'];
				v66 = EpicSettings.Settings['useRallyingCry'];
				v161 = 1847 - (1524 + 320);
			end
			if (((3817 - (1049 + 221)) > (1381 - (18 + 138))) and (v161 == (14 - 8))) then
				v82 = EpicSettings.Settings['victoryRushHP'] or (1102 - (67 + 1035));
				v84 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
			if (((5019 - (136 + 212)) > (11362 - 8688)) and (v161 == (1 + 0))) then
				v63 = EpicSettings.Settings['useBitterImmunity'];
				v68 = EpicSettings.Settings['useDefensiveStance'];
				v64 = EpicSettings.Settings['useDieByTheSword'];
				v161 = 2 + 0;
			end
		end
	end
	local function v120()
		v90 = EpicSettings.Settings['fightRemainsCheck'] or (1604 - (240 + 1364));
		v87 = EpicSettings.Settings['InterruptWithStun'];
		v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v89 = EpicSettings.Settings['InterruptThreshold'];
		v92 = EpicSettings.Settings['useTrinkets'];
		v91 = EpicSettings.Settings['useRacials'];
		v58 = EpicSettings.Settings['trinketsWithCD'];
		v59 = EpicSettings.Settings['racialsWithCD'];
		v69 = EpicSettings.Settings['useHealthstone'];
		v70 = EpicSettings.Settings['useHealingPotion'];
		v79 = EpicSettings.Settings['healthstoneHP'] or (1082 - (1050 + 32));
		v80 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v86 = EpicSettings.Settings['HealingPotionName'] or "";
		v85 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v121()
		local v172 = 0 + 0;
		while true do
			if ((v172 == (1055 - (331 + 724))) or ((299 + 3397) < (3971 - (269 + 375)))) then
				v119();
				v118();
				v120();
				v28 = EpicSettings.Toggles['ooc'];
				v172 = 726 - (267 + 458);
			end
			if (((1 + 1) == v172) or ((8734 - 4192) == (3788 - (667 + 151)))) then
				v101 = v15:IsInMeleeRange(1505 - (1410 + 87));
				if (((2149 - (1504 + 393)) <= (5343 - 3366)) and (v93.TargetIsValid() or v14:AffectingCombat())) then
					local v191 = 0 - 0;
					while true do
						if ((v191 == (796 - (461 + 335))) or ((184 + 1252) == (5536 - (1730 + 31)))) then
							v102 = v10.BossFightRemains(nil, true);
							v103 = v102;
							v191 = 1668 - (728 + 939);
						end
						if ((v191 == (3 - 2)) or ((3281 - 1663) < (2130 - 1200))) then
							if (((5791 - (138 + 930)) > (3796 + 357)) and (v103 == (8687 + 2424))) then
								v103 = v10.FightRemains(v104, false);
							end
							break;
						end
					end
				end
				if (not v14:IsChanneling() or ((3132 + 522) >= (19003 - 14349))) then
					if (((2717 - (459 + 1307)) <= (3366 - (474 + 1396))) and v14:AffectingCombat()) then
						local v195 = 0 - 0;
						while true do
							if ((v195 == (0 + 0)) or ((6 + 1730) == (1635 - 1064))) then
								v27 = v117();
								if (v27 or ((114 + 782) > (15920 - 11151))) then
									return v27;
								end
								break;
							end
						end
					else
						local v196 = 0 - 0;
						while true do
							if ((v196 == (591 - (562 + 29))) or ((891 + 154) <= (2439 - (374 + 1045)))) then
								v27 = v116();
								if (v27 or ((919 + 241) <= (1018 - 690))) then
									return v27;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((4446 - (448 + 190)) > (944 + 1980)) and ((1 + 0) == v172)) then
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				if (((2536 + 1355) < (18912 - 13993)) and v14:IsDeadOrGhost()) then
					return;
				end
				if (v29 or ((6941 - 4707) <= (2996 - (1307 + 187)))) then
					v104 = v14:GetEnemiesInMeleeRange(31 - 23);
					v105 = #v104;
				else
					v105 = 2 - 1;
				end
				v172 = 5 - 3;
			end
		end
	end
	local function v122()
		v20.Print("Arms Warrior by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(754 - (232 + 451), v121, v122);
end;
return v0["Epix_Warrior_Arms.lua"]();

