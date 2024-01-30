local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((14175 - 9930) <= (15266 - 10635)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Warrior_Arms.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.TargetTarget;
	local v16 = v11.Focus;
	local v17 = v9.Spell;
	local v18 = v9.Item;
	local v19 = EpicLib;
	local v20 = v19.Bind;
	local v21 = v19.Cast;
	local v22 = v19.Macro;
	local v23 = v19.Press;
	local v24 = v19.Commons.Everyone.num;
	local v25 = v19.Commons.Everyone.bool;
	local v26;
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v30;
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
	local v92 = v9.Commons.Everyone;
	local v93 = v13:GetEquipment();
	local v94 = (v93[2 + 11] and v18(v93[35 - 22])) or v18(0 + 0);
	local v95 = (v93[786 - (757 + 15)] and v18(v93[8 + 6])) or v18(0 - 0);
	local v96 = v17.Warrior.Arms;
	local v97 = v18.Warrior.Arms;
	local v98 = v22.Warrior.Arms;
	local v99 = {};
	local v100;
	local v101 = 7346 + 3765;
	local v102 = 6180 + 4931;
	v9:RegisterForEvent(function()
		local v122 = 0 + 0;
		while true do
			if (((3591 + 685) >= (3830 + 84)) and (v122 == (433 - (153 + 280)))) then
				v101 = 32083 - 20972;
				v102 = 9976 + 1135;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		local v123 = 0 + 0;
		while true do
			if (((104 + 94) <= (3962 + 403)) and (v123 == (1 + 0))) then
				v95 = (v93[20 - 6] and v18(v93[9 + 5])) or v18(667 - (89 + 578));
				break;
			end
			if (((3417 + 1365) > (9720 - 5044)) and (v123 == (1049 - (572 + 477)))) then
				v93 = v13:GetEquipment();
				v94 = (v93[2 + 11] and v18(v93[8 + 5])) or v18(0 + 0);
				v123 = 87 - (84 + 2);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v103;
	local v104;
	local function v105()
		local v124 = UnitGetTotalAbsorbs(v14);
		if (((8015 - 3151) > (1583 + 614)) and (v124 > (842 - (497 + 345)))) then
			return true;
		else
			return false;
		end
	end
	local function v106(v125)
		return (v125:HealthPercentage() > (1 + 19)) or (v96.Massacre:IsAvailable() and (v125:HealthPercentage() < (6 + 29)));
	end
	local function v107(v126)
		return (v126:DebuffStack(v96.ExecutionersPrecisionDebuff) == (1335 - (605 + 728))) or (v126:DebuffRemains(v96.DeepWoundsDebuff) <= v13:GCD()) or (v96.Dreadnaught:IsAvailable() and v96.Battlelord:IsAvailable() and (v104 <= (2 + 0)));
	end
	local function v108(v127)
		return v13:BuffUp(v96.SuddenDeathBuff) or ((v104 <= (3 - 1)) and ((v127:HealthPercentage() < (1 + 19)) or (v96.Massacre:IsAvailable() and (v127:HealthPercentage() < (129 - 94))))) or v13:BuffUp(v96.SweepingStrikes);
	end
	local function v109()
		if ((v96.BitterImmunity:IsReady() and v62 and (v13:HealthPercentage() <= v71)) or ((3336 + 364) == (6945 - 4438))) then
			if (((3379 + 1095) >= (763 - (457 + 32))) and v23(v96.BitterImmunity)) then
				return "bitter_immunity defensive";
			end
		end
		if ((v96.DieByTheSword:IsCastable() and v63 and (v13:HealthPercentage() <= v72)) or ((804 + 1090) <= (2808 - (832 + 570)))) then
			if (((1481 + 91) >= (400 + 1131)) and v23(v96.DieByTheSword)) then
				return "die_by_the_sword defensive";
			end
		end
		if ((v96.IgnorePain:IsCastable() and v64 and (v13:HealthPercentage() <= v73)) or ((16586 - 11899) < (2188 + 2354))) then
			if (((4087 - (588 + 208)) > (4492 - 2825)) and v23(v96.IgnorePain, nil, nil, true)) then
				return "ignore_pain defensive";
			end
		end
		if ((v96.RallyingCry:IsCastable() and v65 and v13:BuffDown(v96.AspectsFavorBuff) and v13:BuffDown(v96.RallyingCry) and (((v13:HealthPercentage() <= v74) and v92.IsSoloMode()) or v92.AreUnitsBelowHealthPercentage(v74, v75))) or ((2673 - (884 + 916)) == (4258 - 2224))) then
			if (v23(v96.RallyingCry) or ((1633 + 1183) < (664 - (232 + 421)))) then
				return "rallying_cry defensive";
			end
		end
		if (((5588 - (1569 + 320)) < (1155 + 3551)) and v96.Intervene:IsCastable() and v66 and (v16:HealthPercentage() <= v76) and (v16:UnitName() ~= v13:UnitName())) then
			if (((503 + 2143) >= (2951 - 2075)) and v23(v98.InterveneFocus)) then
				return "intervene defensive";
			end
		end
		if (((1219 - (316 + 289)) <= (8334 - 5150)) and v96.DefensiveStance:IsCastable() and v13:BuffDown(v96.DefensiveStance, true) and v67 and (v13:HealthPercentage() <= v77)) then
			if (((145 + 2981) == (4579 - (666 + 787))) and v23(v96.DefensiveStance)) then
				return "defensive_stance defensive";
			end
		end
		if ((v96.BattleStance:IsCastable() and v13:BuffDown(v96.BattleStance, true) and v67 and (v13:HealthPercentage() > v80)) or ((2612 - (360 + 65)) >= (4630 + 324))) then
			if (v23(v96.BattleStance) or ((4131 - (79 + 175)) == (5637 - 2062))) then
				return "battle_stance after defensive stance defensive";
			end
		end
		if (((552 + 155) > (1936 - 1304)) and v97.Healthstone:IsReady() and v68 and (v13:HealthPercentage() <= v78)) then
			if (v23(v98.Healthstone) or ((1051 - 505) >= (3583 - (503 + 396)))) then
				return "healthstone defensive 3";
			end
		end
		if (((1646 - (92 + 89)) <= (8343 - 4042)) and v69 and (v13:HealthPercentage() <= v79)) then
			local v134 = 0 + 0;
			while true do
				if (((1009 + 695) > (5580 - 4155)) and (v134 == (0 + 0))) then
					if ((v85 == "Refreshing Healing Potion") or ((1566 - 879) == (3695 + 539))) then
						if (v97.RefreshingHealingPotion:IsReady() or ((1591 + 1739) < (4352 - 2923))) then
							if (((144 + 1003) >= (510 - 175)) and v23(v98.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((4679 - (485 + 759)) > (4852 - 2755)) and (v85 == "Dreamwalker's Healing Potion")) then
						if (v97.DreamwalkersHealingPotion:IsReady() or ((4959 - (442 + 747)) >= (5176 - (832 + 303)))) then
							if (v23(v98.RefreshingHealingPotion) or ((4737 - (88 + 858)) <= (492 + 1119))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v110()
		local v128 = 0 + 0;
		while true do
			if ((v128 == (1 + 0)) or ((5367 - (766 + 23)) <= (9912 - 7904))) then
				v26 = v92.HandleBottomTrinket(v99, v29, 54 - 14, nil);
				if (((2964 - 1839) <= (7045 - 4969)) and v26) then
					return v26;
				end
				break;
			end
			if ((v128 == (1073 - (1036 + 37))) or ((527 + 216) >= (8566 - 4167))) then
				v26 = v92.HandleTopTrinket(v99, v29, 32 + 8, nil);
				if (((2635 - (641 + 839)) < (2586 - (910 + 3))) and v26) then
					return v26;
				end
				v128 = 2 - 1;
			end
		end
	end
	local function v111()
		if (v100 or ((4008 - (1466 + 218)) <= (266 + 312))) then
			local v135 = 1148 - (556 + 592);
			while true do
				if (((1340 + 2427) == (4575 - (329 + 479))) and (v135 == (855 - (174 + 680)))) then
					if (((14050 - 9961) == (8474 - 4385)) and (v89 < v102) and v96.Warbreaker:IsCastable() and v48 and ((v56 and v29) or not v56)) then
						if (((3183 + 1275) >= (2413 - (396 + 343))) and v23(v96.Warbreaker)) then
							return "warbreaker precombat";
						end
					end
					if (((87 + 885) <= (2895 - (29 + 1448))) and v96.Overpower:IsCastable() and v39) then
						if (v23(v96.Overpower) or ((6327 - (135 + 1254)) < (17939 - 13177))) then
							return "overpower precombat";
						end
					end
					break;
				end
				if ((v135 == (0 - 0)) or ((1669 + 835) > (5791 - (389 + 1138)))) then
					if (((2727 - (102 + 472)) == (2032 + 121)) and v96.Skullsplitter:IsCastable() and v43) then
						if (v23(v96.Skullsplitter) or ((282 + 225) >= (2416 + 175))) then
							return "skullsplitter precombat";
						end
					end
					if (((6026 - (320 + 1225)) == (7976 - 3495)) and (v89 < v102) and v96.ColossusSmash:IsCastable() and v35 and ((v53 and v29) or not v53)) then
						if (v23(v96.ColossusSmash) or ((1425 + 903) < (2157 - (157 + 1307)))) then
							return "colossus_smash precombat";
						end
					end
					v135 = 1860 - (821 + 1038);
				end
			end
		end
		if (((10798 - 6470) == (474 + 3854)) and v33 and v96.Charge:IsCastable()) then
			if (((2820 - 1232) >= (496 + 836)) and v23(v96.Charge)) then
				return "charge precombat";
			end
		end
	end
	local function v112()
		if ((v96.Execute:IsReady() and v36 and v13:BuffUp(v96.JuggernautBuff) and (v13:BuffRemains(v96.JuggernautBuff) < v13:GCD())) or ((10345 - 6171) > (5274 - (834 + 192)))) then
			if (v23(v96.Execute, not v100) or ((292 + 4294) <= (22 + 60))) then
				return "execute hac 67";
			end
		end
		if (((83 + 3780) == (5984 - 2121)) and v96.ThunderClap:IsReady() and v46 and (v104 > (306 - (300 + 4))) and v96.BloodandThunder:IsAvailable() and v96.Rend:IsAvailable() and v14:DebuffRefreshable(v96.RendDebuff)) then
			if (v23(v96.ThunderClap, not v100) or ((76 + 206) <= (109 - 67))) then
				return "thunder_clap hac 68";
			end
		end
		if (((4971 - (112 + 250)) >= (306 + 460)) and v96.SweepingStrikes:IsCastable() and v45 and (v104 >= (4 - 2)) and ((v96.Bladestorm:CooldownRemains() > (9 + 6)) or not v96.Bladestorm:IsAvailable())) then
			if (v23(v96.SweepingStrikes, not v14:IsInMeleeRange(5 + 3)) or ((862 + 290) == (1234 + 1254))) then
				return "sweeping_strikes hac 68";
			end
		end
		if (((2543 + 879) > (4764 - (1001 + 413))) and ((v96.Rend:IsReady() and v40 and (v104 == (2 - 1)) and ((v14:HealthPercentage() > (902 - (244 + 638))) or (v96.Massacre:IsAvailable() and (v14:HealthPercentage() < (728 - (627 + 66)))))) or (v96.TideofBlood:IsAvailable() and (v96.Skullsplitter:CooldownRemains() <= v13:GCD()) and ((v96.ColossusSmash:CooldownRemains() < v13:GCD()) or v14:DebuffUp(v96.ColossusSmashDebuff)) and (v14:DebuffRemains(v96.RendDebuff) < ((62 - 41) * (602.85 - (512 + 90))))))) then
			if (((2783 - (1665 + 241)) > (1093 - (373 + 344))) and v23(v96.Rend, not v100)) then
				return "rend hac 70";
			end
		end
		if (((v89 < v102) and v30 and ((v51 and v29) or not v51) and v96.Avatar:IsCastable()) or ((1407 + 1711) <= (490 + 1361))) then
			if (v23(v96.Avatar, not v100) or ((435 - 270) >= (5908 - 2416))) then
				return "avatar hac 71";
			end
		end
		if (((5048 - (35 + 1064)) < (3534 + 1322)) and (v89 < v102) and v96.Warbreaker:IsCastable() and v48 and ((v56 and v29) or not v56) and (v104 > (2 - 1))) then
			if (v23(v96.Warbreaker, not v100) or ((18 + 4258) < (4252 - (298 + 938)))) then
				return "warbreaker hac 72";
			end
		end
		if (((5949 - (233 + 1026)) > (5791 - (636 + 1030))) and (v89 < v102) and v35 and ((v53 and v29) or not v53) and v96.ColossusSmash:IsCastable()) then
			local v136 = 0 + 0;
			while true do
				if (((0 + 0) == v136) or ((15 + 35) >= (61 + 835))) then
					if (v92.CastCycle(v96.ColossusSmash, v103, v106, not v100) or ((1935 - (55 + 166)) >= (574 + 2384))) then
						return "colossus_smash hac 73";
					end
					if (v23(v96.ColossusSmash, not v100) or ((150 + 1341) < (2459 - 1815))) then
						return "colossus_smash hac 73";
					end
					break;
				end
			end
		end
		if (((1001 - (36 + 261)) < (1726 - 739)) and (v89 < v102) and v35 and ((v53 and v29) or not v53) and v96.ColossusSmash:IsCastable()) then
			if (((5086 - (34 + 1334)) > (733 + 1173)) and v23(v96.ColossusSmash, not v100)) then
				return "colossus_smash hac 74";
			end
		end
		if (((v89 < v102) and v47 and ((v55 and v29) or not v55) and v96.ThunderousRoar:IsCastable() and (v13:BuffUp(v96.TestofMightBuff) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)) or ((v104 > (1 + 0)) and (v14:DebuffRemains(v96.DeepWoundsDebuff) > (1283 - (1035 + 248)))))) or ((979 - (20 + 1)) > (1894 + 1741))) then
			if (((3820 - (134 + 185)) <= (5625 - (549 + 584))) and v23(v96.ThunderousRoar, not v14:IsInMeleeRange(693 - (314 + 371)))) then
				return "thunderous_roar hac 75";
			end
		end
		if (((v89 < v102) and v82 and ((v54 and v29) or not v54) and (v83 == "player") and v96.ChampionsSpear:IsCastable() and (v13:BuffUp(v96.TestofMightBuff) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)))) or ((11816 - 8374) < (3516 - (478 + 490)))) then
			if (((1523 + 1352) >= (2636 - (786 + 386))) and v23(v98.ChampionsSpearPlayer, not v14:IsSpellInRange(v96.ChampionsSpear))) then
				return "spear_of_bastion hac 76";
			end
		end
		if (((v89 < v102) and v82 and ((v54 and v29) or not v54) and (v83 == "cursor") and v96.ChampionsSpear:IsCastable() and (v13:BuffUp(v96.TestofMightBuff) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)))) or ((15537 - 10740) >= (6272 - (1055 + 324)))) then
			if (v23(v98.ChampionsSpearCursor, not v14:IsSpellInRange(v96.ChampionsSpear)) or ((1891 - (1093 + 247)) > (1838 + 230))) then
				return "spear_of_bastion hac 76";
			end
		end
		if (((223 + 1891) > (3747 - 2803)) and (v89 < v102) and v32 and ((v52 and v29) or not v52) and v96.Bladestorm:IsCastable() and v96.Unhinged:IsAvailable() and (v13:BuffUp(v96.TestofMightBuff) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)))) then
			if (v23(v96.Bladestorm, not v100) or ((7676 - 5414) >= (8809 - 5713))) then
				return "bladestorm hac 77";
			end
		end
		if (((v89 < v102) and v32 and ((v52 and v29) or not v52) and v96.Bladestorm:IsCastable() and (((v104 > (2 - 1)) and (v13:BuffUp(v96.TestofMightBuff) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)))) or ((v104 > (1 + 0)) and (v14:DebuffRemains(v96.DeepWoundsDebuff) > (0 - 0))))) or ((7772 - 5517) >= (2668 + 869))) then
			if (v23(v96.Bladestorm, not v100) or ((9812 - 5975) < (1994 - (364 + 324)))) then
				return "bladestorm hac 78";
			end
		end
		if (((8087 - 5137) == (7078 - 4128)) and v96.Cleave:IsReady() and v34 and ((v104 > (1 + 1)) or (not v96.Battlelord:IsAvailable() and v13:BuffUp(v96.MercilessBonegrinderBuff) and (v96.MortalStrike:CooldownRemains() > v13:GCD())))) then
			if (v23(v96.Cleave, not v100) or ((19762 - 15039) < (5281 - 1983))) then
				return "cleave hac 79";
			end
		end
		if (((3450 - 2314) >= (1422 - (1249 + 19))) and v96.Whirlwind:IsReady() and v49 and ((v104 > (2 + 0)) or (v96.StormofSwords:IsAvailable() and (v13:BuffUp(v96.MercilessBonegrinderBuff) or v13:BuffUp(v96.HurricaneBuff))))) then
			if (v23(v96.Whirlwind, not v14:IsInMeleeRange(31 - 23)) or ((1357 - (686 + 400)) > (3726 + 1022))) then
				return "whirlwind hac 80";
			end
		end
		if (((4969 - (73 + 156)) >= (15 + 3137)) and v96.Skullsplitter:IsCastable() and v43 and ((v13:Rage() < (851 - (721 + 90))) or (v96.TideofBlood:IsAvailable() and (v14:DebuffRemains(v96.RendDebuff) > (0 + 0)) and ((v13:BuffUp(v96.SweepingStrikes) and (v104 > (6 - 4))) or v14:DebuffUp(v96.ColossusSmashDebuff) or v13:BuffUp(v96.TestofMightBuff))))) then
			if (v23(v96.Skullsplitter, not v14:IsInMeleeRange(478 - (224 + 246))) or ((4175 - 1597) >= (6241 - 2851))) then
				return "sweeping_strikes execute 81";
			end
		end
		if (((8 + 33) <= (40 + 1621)) and v96.MortalStrike:IsReady() and v38 and v13:BuffUp(v96.SweepingStrikes) and (v13:BuffStack(v96.CrushingAdvanceBuff) == (3 + 0))) then
			if (((1194 - 593) < (11847 - 8287)) and v23(v96.MortalStrike, not v100)) then
				return "mortal_strike hac 81.5";
			end
		end
		if (((748 - (203 + 310)) < (2680 - (1238 + 755))) and v96.Overpower:IsCastable() and v39 and v13:BuffUp(v96.SweepingStrikes) and v96.Dreadnaught:IsAvailable()) then
			if (((318 + 4231) > (2687 - (709 + 825))) and v23(v96.Overpower, not v100)) then
				return "overpower hac 82";
			end
		end
		if ((v96.MortalStrike:IsReady() and v38) or ((8612 - 3938) < (6805 - 2133))) then
			local v137 = 864 - (196 + 668);
			while true do
				if (((14482 - 10814) < (9447 - 4886)) and (v137 == (833 - (171 + 662)))) then
					if (v92.CastCycle(v96.MortalStrike, v103, v107, not v100) or ((548 - (4 + 89)) == (12635 - 9030))) then
						return "mortal_strike hac 83";
					end
					if (v23(v96.MortalStrike, not v100) or ((970 + 1693) == (14546 - 11234))) then
						return "mortal_strike hac 83";
					end
					break;
				end
			end
		end
		if (((1678 + 2599) <= (5961 - (35 + 1451))) and v96.Execute:IsReady() and v36 and (v13:BuffUp(v96.SuddenDeathBuff) or ((v104 <= (1455 - (28 + 1425))) and ((v14:HealthPercentage() < (2013 - (941 + 1052))) or (v96.Massacre:IsAvailable() and (v14:HealthPercentage() < (34 + 1))))) or v13:BuffUp(v96.SweepingStrikes))) then
			local v138 = 1514 - (822 + 692);
			while true do
				if ((v138 == (0 - 0)) or ((410 + 460) == (1486 - (45 + 252)))) then
					if (((1537 + 16) <= (1079 + 2054)) and v92.CastCycle(v96.Execute, v103, v108, not v100)) then
						return "execute hac 84";
					end
					if (v23(v96.Execute, not v100) or ((5443 - 3206) >= (3944 - (114 + 319)))) then
						return "execute hac 84";
					end
					break;
				end
			end
		end
		if (((v89 < v102) and v47 and ((v55 and v29) or not v55) and v96.ThunderousRoar:IsCastable()) or ((1900 - 576) > (3869 - 849))) then
			if (v23(v96.ThunderousRoar, not v14:IsInMeleeRange(6 + 2)) or ((4456 - 1464) == (3941 - 2060))) then
				return "thunderous_roar hac 85";
			end
		end
		if (((5069 - (556 + 1407)) > (2732 - (741 + 465))) and v96.Shockwave:IsCastable() and v42 and (v104 > (467 - (170 + 295))) and (v96.SonicBoom:IsAvailable() or v14:IsCasting())) then
			if (((1593 + 1430) < (3555 + 315)) and v23(v96.Shockwave, not v14:IsInMeleeRange(19 - 11))) then
				return "shockwave hac 86";
			end
		end
		if (((119 + 24) > (48 + 26)) and v96.Overpower:IsCastable() and v39 and (v104 == (1 + 0)) and (((v96.Overpower:Charges() == (1232 - (957 + 273))) and not v96.Battlelord:IsAvailable() and (v14:Debuffdown(v96.ColossusSmashDebuff) or (v13:RagePercentage() < (7 + 18)))) or v96.Battlelord:IsAvailable())) then
			if (((8 + 10) < (8047 - 5935)) and v23(v96.Overpower, not v100)) then
				return "overpower hac 87";
			end
		end
		if (((2890 - 1793) <= (4972 - 3344)) and v96.Slam:IsReady() and v44 and (v104 == (4 - 3)) and not v96.Battlelord:IsAvailable() and (v13:RagePercentage() > (1850 - (389 + 1391)))) then
			if (((2905 + 1725) == (482 + 4148)) and v23(v96.Slam, not v100)) then
				return "slam hac 88";
			end
		end
		if (((8059 - 4519) > (3634 - (783 + 168))) and v96.Overpower:IsCastable() and v39 and (((v96.Overpower:Charges() == (6 - 4)) and (not v96.TestofMight:IsAvailable() or (v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)) or v96.Battlelord:IsAvailable())) or (v13:Rage() < (69 + 1)))) then
			if (((5105 - (309 + 2)) >= (10057 - 6782)) and v23(v96.Overpower, not v100)) then
				return "overpower hac 89";
			end
		end
		if (((2696 - (1090 + 122)) == (482 + 1002)) and v96.ThunderClap:IsReady() and v46 and (v104 > (6 - 4))) then
			if (((981 + 451) < (4673 - (628 + 490))) and v23(v96.ThunderClap, not v100)) then
				return "thunder_clap hac 90";
			end
		end
		if ((v96.MortalStrike:IsReady() and v38) or ((191 + 874) > (8858 - 5280))) then
			if (v23(v96.MortalStrike, not v100) or ((21913 - 17118) < (2181 - (431 + 343)))) then
				return "mortal_strike hac 91";
			end
		end
		if (((3742 - 1889) < (13923 - 9110)) and v96.Rend:IsReady() and v40 and (v104 == (1 + 0)) and v14:DebuffRefreshable(v96.RendDebuff)) then
			if (v23(v96.Rend, not v100) or ((361 + 2460) < (4126 - (556 + 1139)))) then
				return "rend hac 92";
			end
		end
		if ((v96.Whirlwind:IsReady() and v49 and (v96.StormofSwords:IsAvailable() or (v96.FervorofBattle:IsAvailable() and (v104 > (16 - (6 + 9)))))) or ((527 + 2347) < (1118 + 1063))) then
			if (v23(v96.Whirlwind, not v14:IsInMeleeRange(177 - (28 + 141))) or ((1042 + 1647) <= (422 - 79))) then
				return "whirlwind hac 93";
			end
		end
		if ((v96.Cleave:IsReady() and v34 and not v96.CrushingForce:IsAvailable()) or ((1324 + 545) == (3326 - (486 + 831)))) then
			if (v23(v96.Cleave, not v100) or ((9227 - 5681) < (8174 - 5852))) then
				return "cleave hac 94";
			end
		end
		if ((v96.IgnorePain:IsReady() and v64 and v96.Battlelord:IsAvailable() and v96.AngerManagement:IsAvailable() and (v13:Rage() > (6 + 24)) and ((v14:HealthPercentage() < (63 - 43)) or (v96.Massacre:IsAvailable() and (v14:HealthPercentage() < (1298 - (668 + 595)))))) or ((1874 + 208) == (963 + 3810))) then
			if (((8846 - 5602) > (1345 - (23 + 267))) and v23(v96.IgnorePain, not v100)) then
				return "ignore_pain hac 95";
			end
		end
		if ((v96.Slam:IsReady() and v44 and v96.CrushingForce:IsAvailable() and (v13:Rage() > (1974 - (1129 + 815))) and ((v96.FervorofBattle:IsAvailable() and (v104 == (388 - (371 + 16)))) or not v96.FervorofBattle:IsAvailable())) or ((5063 - (1326 + 424)) <= (3367 - 1589))) then
			if (v23(v96.Slam, not v100) or ((5192 - 3771) >= (2222 - (88 + 30)))) then
				return "slam hac 96";
			end
		end
		if (((2583 - (720 + 51)) <= (7227 - 3978)) and v96.Shockwave:IsCastable() and v42 and (v96.SonicBoom:IsAvailable())) then
			if (((3399 - (421 + 1355)) <= (3227 - 1270)) and v23(v96.Shockwave, not v14:IsInMeleeRange(4 + 4))) then
				return "shockwave hac 97";
			end
		end
		if (((5495 - (286 + 797)) == (16128 - 11716)) and v29 and (v89 < v102) and v32 and ((v52 and v29) or not v52) and v96.Bladestorm:IsCastable()) then
			if (((2898 - 1148) >= (1281 - (397 + 42))) and v23(v96.Bladestorm, not v100)) then
				return "bladestorm hac 98";
			end
		end
	end
	local function v113()
		local v129 = 0 + 0;
		while true do
			if (((5172 - (24 + 776)) > (2850 - 1000)) and (v129 == (787 - (222 + 563)))) then
				if (((510 - 278) < (592 + 229)) and v96.Skullsplitter:IsCastable() and v43 and ((v96.TestofMight:IsAvailable() and (v13:RagePercentage() <= (220 - (23 + 167)))) or (not v96.TestofMight:IsAvailable() and (v14:DebuffUp(v96.ColossusSmashDebuff) or (v96.ColossusSmash:CooldownRemains() > (1803 - (690 + 1108)))) and (v13:RagePercentage() <= (11 + 19))))) then
					if (((428 + 90) < (1750 - (40 + 808))) and v23(v96.Skullsplitter, not v14:IsInMeleeRange(2 + 6))) then
						return "skullsplitter execute 57";
					end
				end
				if (((11448 - 8454) > (821 + 37)) and (v89 < v102) and v47 and ((v55 and v29) or not v55) and v96.ThunderousRoar:IsCastable() and (v13:BuffUp(v96.TestofMightBuff) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)))) then
					if (v23(v96.ThunderousRoar, not v14:IsInMeleeRange(5 + 3)) or ((2060 + 1695) <= (1486 - (47 + 524)))) then
						return "thunderous_roar execute 57";
					end
				end
				if (((2561 + 1385) > (10231 - 6488)) and (v89 < v102) and v82 and ((v54 and v29) or not v54) and (v83 == "player") and v96.ChampionsSpear:IsCastable() and (v14:DebuffUp(v96.ColossusSmashDebuff) or v13:BuffUp(v96.TestofMightBuff))) then
					if (v23(v98.ChampionsSpearPlayer, not v14:IsSpellInRange(v96.ChampionsSpear)) or ((1996 - 661) >= (7539 - 4233))) then
						return "spear_of_bastion execute 57";
					end
				end
				v129 = 1729 - (1165 + 561);
			end
			if (((144 + 4700) > (6977 - 4724)) and (v129 == (2 + 3))) then
				if (((931 - (341 + 138)) == (123 + 329)) and v96.Overpower:IsCastable() and v39) then
					if (v23(v96.Overpower, not v100) or ((9404 - 4847) < (2413 - (89 + 237)))) then
						return "overpower execute 64";
					end
				end
				if (((12462 - 8588) == (8155 - 4281)) and (v89 < v102) and v32 and ((v52 and v29) or not v52) and v96.Bladestorm:IsCastable()) then
					if (v23(v96.Bladestorm, not v100) or ((2819 - (581 + 300)) > (6155 - (855 + 365)))) then
						return "bladestorm execute 65";
					end
				end
				break;
			end
			if ((v129 == (2 - 1)) or ((1390 + 2865) < (4658 - (1030 + 205)))) then
				if (((1366 + 88) <= (2318 + 173)) and (v89 < v102) and v48 and ((v56 and v29) or not v56) and v96.Warbreaker:IsCastable()) then
					if (v23(v96.Warbreaker, not v100) or ((4443 - (156 + 130)) <= (6368 - 3565))) then
						return "warbreaker execute 54";
					end
				end
				if (((8179 - 3326) >= (6106 - 3124)) and (v89 < v102) and v35 and ((v53 and v29) or not v53) and v96.ColossusSmash:IsCastable()) then
					if (((1090 + 3044) > (1958 + 1399)) and v23(v96.ColossusSmash, not v100)) then
						return "colossus_smash execute 55";
					end
				end
				if ((v96.Execute:IsReady() and v36 and v13:BuffUp(v96.SuddenDeathBuff) and (v14:DebuffRemains(v96.DeepWoundsDebuff) > (69 - (10 + 59)))) or ((967 + 2450) < (12479 - 9945))) then
					if (v23(v96.Execute, not v100) or ((3885 - (671 + 492)) <= (131 + 33))) then
						return "execute execute 56";
					end
				end
				v129 = 1217 - (369 + 846);
			end
			if ((v129 == (0 + 0)) or ((2055 + 353) < (4054 - (1036 + 909)))) then
				if (((v89 < v102) and v45 and v96.SweepingStrikes:IsCastable() and (v104 > (1 + 0))) or ((55 - 22) == (1658 - (11 + 192)))) then
					if (v23(v96.SweepingStrikes, not v14:IsInMeleeRange(5 + 3)) or ((618 - (135 + 40)) >= (9727 - 5712))) then
						return "sweeping_strikes execute 51";
					end
				end
				if (((2039 + 1343) > (365 - 199)) and v96.Rend:IsReady() and v40 and (v14:DebuffRemains(v96.RendDebuff) <= v13:GCD()) and not v96.Bloodletting:IsAvailable() and ((not v96.Warbreaker:IsAvailable() and (v96.ColossusSmash:CooldownRemains() < (5 - 1))) or (v96.Warbreaker:IsAvailable() and (v96.Warbreaker:CooldownRemains() < (180 - (50 + 126))))) and (v14:TimeToDie() > (33 - 21))) then
					if (v23(v96.Rend, not v100) or ((62 + 218) == (4472 - (1233 + 180)))) then
						return "rend execute 52";
					end
				end
				if (((2850 - (522 + 447)) > (2714 - (107 + 1314))) and (v89 < v102) and v30 and ((v51 and v29) or not v51) and v96.Avatar:IsCastable() and (v96.ColossusSmash:CooldownUp() or v14:DebuffUp(v96.ColossusSmashDebuff) or (v102 < (10 + 10)))) then
					if (((7181 - 4824) == (1002 + 1355)) and v23(v96.Avatar, not v100)) then
						return "avatar execute 53";
					end
				end
				v129 = 1 - 0;
			end
			if (((486 - 363) == (2033 - (716 + 1194))) and (v129 == (1 + 3))) then
				if ((v96.Overpower:IsCastable() and v39 and (v13:Rage() < (5 + 35)) and (v13:BuffStack(v96.MartialProwessBuff) < (505 - (74 + 429)))) or ((2036 - 980) >= (1682 + 1710))) then
					if (v23(v96.Overpower, not v100) or ((2474 - 1393) < (761 + 314))) then
						return "overpower execute 60";
					end
				end
				if ((v96.Execute:IsReady() and v36) or ((3233 - 2184) >= (10958 - 6526))) then
					if (v23(v96.Execute, not v100) or ((5201 - (279 + 154)) <= (1624 - (454 + 324)))) then
						return "execute execute 62";
					end
				end
				if ((v96.Shockwave:IsCastable() and v42 and (v96.SonicBoom:IsAvailable() or v14:IsCasting())) or ((2642 + 716) <= (1437 - (12 + 5)))) then
					if (v23(v96.Shockwave, not v14:IsInMeleeRange(5 + 3)) or ((9526 - 5787) <= (1111 + 1894))) then
						return "shockwave execute 63";
					end
				end
				v129 = 1098 - (277 + 816);
			end
			if ((v129 == (12 - 9)) or ((2842 - (1058 + 125)) >= (401 + 1733))) then
				if (((v89 < v102) and v82 and ((v54 and v29) or not v54) and (v83 == "cursor") and v96.ChampionsSpear:IsCastable() and (v14:DebuffUp(v96.ColossusSmashDebuff) or v13:BuffUp(v96.TestofMightBuff))) or ((4235 - (815 + 160)) < (10104 - 7749))) then
					if (v23(v98.ChampionsSpearCursor, not v14:IsSpellInRange(v96.ChampionsSpear)) or ((1587 - 918) == (1008 + 3215))) then
						return "spear_of_bastion execute 57";
					end
				end
				if ((v96.Cleave:IsReady() and v34 and (v104 > (5 - 3)) and (v14:DebuffRemains(v96.DeepWoundsDebuff) < v13:GCD())) or ((3590 - (41 + 1857)) < (2481 - (1222 + 671)))) then
					if (v23(v96.Cleave, not v100) or ((12398 - 7601) < (5247 - 1596))) then
						return "cleave execute 58";
					end
				end
				if ((v96.MortalStrike:IsReady() and v38 and ((v14:DebuffStack(v96.ExecutionersPrecisionDebuff) == (1184 - (229 + 953))) or (v14:DebuffRemains(v96.DeepWoundsDebuff) <= v13:GCD()))) or ((5951 - (1111 + 663)) > (6429 - (874 + 705)))) then
					if (v23(v96.MortalStrike, not v100) or ((56 + 344) > (759 + 352))) then
						return "mortal_strike execute 59";
					end
				end
				v129 = 7 - 3;
			end
		end
	end
	local function v114()
		if (((86 + 2965) > (1684 - (642 + 37))) and (v89 < v102) and v45 and v96.SweepingStrikes:IsCastable() and (v104 > (1 + 0))) then
			if (((591 + 3102) <= (11002 - 6620)) and v23(v96.SweepingStrikes, not v14:IsInMeleeRange(462 - (233 + 221)))) then
				return "sweeping_strikes single_target 97";
			end
		end
		if ((v96.Execute:IsReady() and (v13:BuffUp(v96.SuddenDeathBuff))) or ((7588 - 4306) > (3609 + 491))) then
			if (v23(v96.Execute, not v100) or ((5121 - (718 + 823)) < (1790 + 1054))) then
				return "execute single_target 98";
			end
		end
		if (((894 - (266 + 539)) < (12712 - 8222)) and v96.MortalStrike:IsReady() and v38) then
			if (v23(v96.MortalStrike, not v100) or ((6208 - (636 + 589)) < (4291 - 2483))) then
				return "mortal_strike single_target 99";
			end
		end
		if (((7897 - 4068) > (2987 + 782)) and v96.Rend:IsReady() and v40 and ((v14:DebuffRemains(v96.RendDebuff) <= v13:GCD()) or (v96.TideofBlood:IsAvailable() and (v96.Skullsplitter:CooldownRemains() <= v13:GCD()) and ((v96.ColossusSmash:CooldownRemains() <= v13:GCD()) or v14:DebuffUp(v96.ColossusSmashDebuff)) and (v14:DebuffRemains(v96.RendDebuff) < (v96.RendDebuff:BaseDuration() * (0.85 + 0)))))) then
			if (((2500 - (657 + 358)) <= (7688 - 4784)) and v23(v96.Rend, not v100)) then
				return "rend single_target 100";
			end
		end
		if (((9725 - 5456) == (5456 - (1151 + 36))) and (v89 < v102) and v30 and ((v51 and v29) or not v51) and v96.Avatar:IsCastable() and ((v96.WarlordsTorment:IsAvailable() and (v13:RagePercentage() < (32 + 1)) and (v96.ColossusSmash:CooldownUp() or v14:DebuffUp(v96.ColossusSmashDebuff) or v13:BuffUp(v96.TestofMightBuff))) or (not v96.WarlordsTorment:IsAvailable() and (v96.ColossusSmash:CooldownUp() or v14:DebuffUp(v96.ColossusSmashDebuff))))) then
			if (((102 + 285) <= (8308 - 5526)) and v23(v96.Avatar, not v100)) then
				return "avatar single_target 101";
			end
		end
		if (((v89 < v102) and v82 and ((v54 and v29) or not v54) and (v83 == "player") and v96.ChampionsSpear:IsCastable() and ((v96.ColossusSmash:CooldownRemains() <= v13:GCD()) or (v96.Warbreaker:CooldownRemains() <= v13:GCD()))) or ((3731 - (1552 + 280)) <= (1751 - (64 + 770)))) then
			if (v23(v98.ChampionsSpearPlayer, not v14:IsSpellInRange(v96.ChampionsSpear)) or ((2928 + 1384) <= (1988 - 1112))) then
				return "spear_of_bastion single_target 102";
			end
		end
		if (((397 + 1835) <= (3839 - (157 + 1086))) and (v89 < v102) and v82 and ((v54 and v29) or not v54) and (v83 == "cursor") and v96.ChampionsSpear:IsCastable() and ((v96.ColossusSmash:CooldownRemains() <= v13:GCD()) or (v96.Warbreaker:CooldownRemains() <= v13:GCD()))) then
			if (((4193 - 2098) < (16143 - 12457)) and v23(v98.ChampionsSpearCursor, not v14:IsSpellInRange(v96.ChampionsSpear))) then
				return "spear_of_bastion single_target 102";
			end
		end
		if (((v89 < v102) and v48 and ((v56 and v29) or not v56) and v96.Warbreaker:IsCastable()) or ((2446 - 851) >= (6106 - 1632))) then
			if (v23(v96.Warbreaker, not v14:IsInRange(827 - (599 + 220))) or ((9197 - 4578) < (4813 - (1813 + 118)))) then
				return "warbreaker single_target 103";
			end
		end
		if (((v89 < v102) and v35 and ((v53 and v29) or not v53) and v96.ColossusSmash:IsCastable()) or ((215 + 79) >= (6048 - (841 + 376)))) then
			if (((2842 - 813) <= (717 + 2367)) and v23(v96.ColossusSmash, not v100)) then
				return "colossus_smash single_target 104";
			end
		end
		if ((v96.Skullsplitter:IsCastable() and v43 and not v96.TestofMight:IsAvailable() and (v14:DebuffRemains(v96.DeepWoundsDebuff) > (0 - 0)) and (v14:DebuffUp(v96.ColossusSmashDebuff) or (v96.ColossusSmash:CooldownRemains() > (862 - (464 + 395))))) or ((5227 - 3190) == (1163 + 1257))) then
			if (((5295 - (467 + 370)) > (8067 - 4163)) and v23(v96.Skullsplitter, not v100)) then
				return "skullsplitter single_target 105";
			end
		end
		if (((321 + 115) >= (421 - 298)) and v96.Skullsplitter:IsCastable() and v43 and v96.TestofMight:IsAvailable() and (v14:DebuffRemains(v96.DeepWoundsDebuff) > (0 + 0))) then
			if (((1163 - 663) < (2336 - (150 + 370))) and v23(v96.Skullsplitter, not v100)) then
				return "skullsplitter single_target 106";
			end
		end
		if (((4856 - (74 + 1208)) == (8790 - 5216)) and (v89 < v102) and v47 and ((v55 and v29) or not v55) and v96.ThunderousRoar:IsCastable() and (v13:BuffUp(v96.TestofMightBuff) or (v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff) and (v13:RagePercentage() < (156 - 123))) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)))) then
			if (((158 + 63) < (780 - (14 + 376))) and v23(v96.ThunderousRoar, not v14:IsInMeleeRange(13 - 5))) then
				return "thunderous_roar single_target 107";
			end
		end
		if ((v96.Whirlwind:IsReady() and v49 and v96.StormofSwords:IsAvailable() and v96.TestofMight:IsAvailable() and (v13:RagePercentage() > (52 + 28)) and v14:DebuffUp(v96.ColossusSmashDebuff)) or ((1945 + 268) <= (1356 + 65))) then
			if (((8960 - 5902) < (3657 + 1203)) and v23(v96.Whirlwind, not v14:IsInMeleeRange(86 - (23 + 55)))) then
				return "whirlwind single_target 108";
			end
		end
		if ((v96.ThunderClap:IsReady() and v46 and (v14:DebuffRemains(v96.RendDebuff) <= v13:GCD()) and not v96.TideofBlood:IsAvailable()) or ((3071 - 1775) >= (2967 + 1479))) then
			if (v23(v96.ThunderClap, not v100) or ((1251 + 142) > (6959 - 2470))) then
				return "thunder_clap single_target 109";
			end
		end
		if (((v89 < v102) and v32 and ((v52 and v29) or not v52) and v96.Bladestorm:IsCastable() and ((v96.Hurricane:IsAvailable() and (v13:BuffUp(v96.TestofMightBuff) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)))) or (v96.Unhinged:IsAvailable() and (v13:BuffUp(v96.TestofMightBuff) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)))))) or ((1392 + 3032) < (928 - (652 + 249)))) then
			if (v23(v96.Bladestorm, not v100) or ((5344 - 3347) > (5683 - (708 + 1160)))) then
				return "bladestorm single_target 110";
			end
		end
		if (((9405 - 5940) > (3487 - 1574)) and v96.Shockwave:IsCastable() and v42 and (v96.SonicBoom:IsAvailable() or v14:IsCasting())) then
			if (((760 - (10 + 17)) < (409 + 1410)) and v23(v96.Shockwave, not v14:IsInMeleeRange(1740 - (1400 + 332)))) then
				return "shockwave single_target 111";
			end
		end
		if ((v96.Whirlwind:IsReady() and v49 and v96.StormofSwords:IsAvailable() and v96.TestofMight:IsAvailable() and (v96.ColossusSmash:CooldownRemains() > (v13:GCD() * (12 - 5)))) or ((6303 - (242 + 1666)) == (2035 + 2720))) then
			if (v23(v96.Whirlwind, not v14:IsInMeleeRange(3 + 5)) or ((3233 + 560) < (3309 - (850 + 90)))) then
				return "whirlwind single_target 113";
			end
		end
		if ((v96.Overpower:IsCastable() and v39 and (((v96.Overpower:Charges() == (3 - 1)) and not v96.Battlelord:IsAvailable() and (v14:DebuffUp(v96.ColossusSmashDebuff) or (v13:RagePercentage() < (1415 - (360 + 1030))))) or v96.Battlelord:IsAvailable())) or ((3615 + 469) == (747 - 482))) then
			if (((5995 - 1637) == (6019 - (909 + 752))) and v23(v96.Overpower, not v100)) then
				return "overpower single_target 114";
			end
		end
		if ((v96.Slam:IsReady() and v44 and ((v96.CrushingForce:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff) and (v13:Rage() >= (1283 - (109 + 1114))) and v96.TestofMight:IsAvailable()) or v96.ImprovedSlam:IsAvailable()) and (not v96.FervorofBattle:IsAvailable() or (v96.FervorofBattle:IsAvailable() and (v104 == (1 - 0))))) or ((1222 + 1916) < (1235 - (6 + 236)))) then
			if (((2099 + 1231) > (1870 + 453)) and v23(v96.Slam, not v100)) then
				return "slam single_target 115";
			end
		end
		if ((v96.Whirlwind:IsReady() and v49 and (v96.StormofSwords:IsAvailable() or (v96.FervorofBattle:IsAvailable() and (v104 > (2 - 1))))) or ((6333 - 2707) == (5122 - (1076 + 57)))) then
			if (v23(v96.Whirlwind, not v14:IsInMeleeRange(2 + 6)) or ((1605 - (579 + 110)) == (211 + 2460))) then
				return "whirlwind single_target 116";
			end
		end
		if (((241 + 31) == (145 + 127)) and v96.Slam:IsReady() and v44 and (v96.CrushingForce:IsAvailable() or (not v96.CrushingForce:IsAvailable() and (v13:Rage() >= (437 - (174 + 233))))) and (not v96.FervorofBattle:IsAvailable() or (v96.FervorofBattle:IsAvailable() and (v104 == (2 - 1))))) then
			if (((7457 - 3208) <= (2152 + 2687)) and v23(v96.Slam, not v100)) then
				return "slam single_target 117";
			end
		end
		if (((3951 - (663 + 511)) < (2855 + 345)) and v96.ThunderClap:IsReady() and v46 and v96.Battlelord:IsAvailable() and v96.BloodandThunder:IsAvailable()) then
			if (((21 + 74) < (6033 - 4076)) and v23(v96.ThunderClap, not v100)) then
				return "thunder_clap single_target 118";
			end
		end
		if (((501 + 325) < (4042 - 2325)) and v96.Overpower:IsCastable() and v39 and ((v14:DebuffDown(v96.ColossusSmashDebuff) and (v13:RagePercentage() < (121 - 71)) and not v96.Battlelord:IsAvailable()) or (v13:RagePercentage() < (12 + 13)))) then
			if (((2775 - 1349) >= (788 + 317)) and v23(v96.Overpower, not v100)) then
				return "overpower single_target 119";
			end
		end
		if (((252 + 2502) <= (4101 - (478 + 244))) and v96.Whirlwind:IsReady() and v49 and v13:BuffUp(v96.MercilessBonegrinderBuff)) then
			if (v23(v96.Whirlwind, not v14:IsInRange(525 - (440 + 77))) or ((1786 + 2141) == (5171 - 3758))) then
				return "whirlwind single_target 120";
			end
		end
		if ((v96.Cleave:IsReady() and v34 and v13:HasTier(1585 - (655 + 901), 1 + 1) and not v96.CrushingForce:IsAvailable()) or ((884 + 270) <= (533 + 255))) then
			if (v23(v96.Cleave, not v100) or ((6618 - 4975) > (4824 - (695 + 750)))) then
				return "cleave single_target 121";
			end
		end
		if (((v89 < v102) and v32 and ((v52 and v29) or not v52) and v96.Bladestorm:IsCastable()) or ((9571 - 6768) > (7019 - 2470))) then
			if (v23(v96.Bladestorm, not v100) or ((884 - 664) >= (3373 - (285 + 66)))) then
				return "bladestorm single_target 122";
			end
		end
		if (((6577 - 3755) == (4132 - (682 + 628))) and v96.Cleave:IsReady() and v34) then
			if (v23(v96.Cleave, not v100) or ((172 + 889) == (2156 - (176 + 123)))) then
				return "cleave single_target 123";
			end
		end
		if (((1155 + 1605) > (990 + 374)) and v96.Rend:IsReady() and v40 and v14:DebuffRefreshable(v96.RendDebuff) and not v96.CrushingForce:IsAvailable()) then
			if (v23(v96.Rend, not v100) or ((5171 - (239 + 30)) <= (978 + 2617))) then
				return "rend single_target 124";
			end
		end
	end
	local function v115()
		if (not v13:AffectingCombat() or ((3703 + 149) == (517 - 224))) then
			local v139 = 0 - 0;
			while true do
				if (((315 - (306 + 9)) == v139) or ((5440 - 3881) == (798 + 3790))) then
					if ((v96.BattleStance:IsCastable() and v13:BuffDown(v96.BattleStance, true)) or ((2752 + 1732) == (380 + 408))) then
						if (((13062 - 8494) >= (5282 - (1140 + 235))) and v23(v96.BattleStance)) then
							return "battle_stance";
						end
					end
					if (((793 + 453) < (3183 + 287)) and v96.BattleShout:IsCastable() and v31 and (v13:BuffDown(v96.BattleShoutBuff, true) or v92.GroupBuffMissing(v96.BattleShoutBuff))) then
						if (((1045 + 3023) >= (1024 - (33 + 19))) and v23(v96.BattleShout)) then
							return "battle_shout precombat";
						end
					end
					break;
				end
			end
		end
		if (((179 + 314) < (11668 - 7775)) and v92.TargetIsValid() and v27) then
			if (not v13:AffectingCombat() or ((649 + 824) >= (6533 - 3201))) then
				local v192 = 0 + 0;
				while true do
					if ((v192 == (689 - (586 + 103))) or ((369 + 3682) <= (3561 - 2404))) then
						v26 = v111();
						if (((2092 - (1309 + 179)) < (5200 - 2319)) and v26) then
							return v26;
						end
						break;
					end
				end
			end
		end
	end
	local function v116()
		v26 = v109();
		if (v26 or ((392 + 508) == (9069 - 5692))) then
			return v26;
		end
		if (((3369 + 1090) > (1255 - 664)) and v84) then
			v26 = v92.HandleIncorporeal(v96.StormBolt, v98.StormBoltMouseover, 39 - 19, true);
			if (((4007 - (295 + 314)) >= (5882 - 3487)) and v26) then
				return v26;
			end
			v26 = v92.HandleIncorporeal(v96.IntimidatingShout, v98.IntimidatingShoutMouseover, 1970 - (1300 + 662), true);
			if (v26 or ((6854 - 4671) >= (4579 - (1178 + 577)))) then
				return v26;
			end
		end
		if (((1006 + 930) == (5722 - 3786)) and v92.TargetIsValid()) then
			local v140 = 1405 - (851 + 554);
			local v141;
			while true do
				if ((v140 == (1 + 0)) or ((13400 - 8568) < (9367 - 5054))) then
					if (((4390 - (115 + 187)) > (2967 + 907)) and v100 and v90 and ((v58 and v29) or not v58) and (v89 < v102)) then
						local v195 = 0 + 0;
						while true do
							if (((17070 - 12738) == (5493 - (160 + 1001))) and (v195 == (1 + 0))) then
								if (((2760 + 1239) >= (5936 - 3036)) and v96.ArcaneTorrent:IsCastable() and (v96.MortalStrike:CooldownRemains() > (359.5 - (237 + 121))) and (v13:Rage() < (947 - (525 + 372)))) then
									if (v23(v96.ArcaneTorrent, not v14:IsInRange(14 - 6)) or ((8296 - 5771) > (4206 - (96 + 46)))) then
										return "arcane_torrent main 41";
									end
								end
								if (((5148 - (643 + 134)) == (1578 + 2793)) and v96.LightsJudgment:IsCastable() and v14:DebuffDown(v96.ColossusSmashDebuff) and not v96.MortalStrike:CooldownUp()) then
									if (v23(v96.LightsJudgment, not v14:IsSpellInRange(v96.LightsJudgment)) or ((637 - 371) > (18511 - 13525))) then
										return "lights_judgment main 42";
									end
								end
								v195 = 2 + 0;
							end
							if (((3907 - 1916) >= (1890 - 965)) and (v195 == (722 - (316 + 403)))) then
								if (((303 + 152) < (5644 - 3591)) and v96.BagofTricks:IsCastable() and v14:DebuffDown(v96.ColossusSmashDebuff) and not v96.MortalStrike:CooldownUp()) then
									if (v23(v96.BagofTricks, not v14:IsSpellInRange(v96.BagofTricks)) or ((299 + 527) == (12216 - 7365))) then
										return "bag_of_tricks main 10";
									end
								end
								break;
							end
							if (((130 + 53) == (59 + 124)) and (v195 == (6 - 4))) then
								if (((5535 - 4376) <= (3714 - 1926)) and v96.Fireblood:IsCastable() and (v14:DebuffUp(v96.ColossusSmashDebuff))) then
									if (v23(v96.Fireblood) or ((201 + 3306) > (8500 - 4182))) then
										return "fireblood main 43";
									end
								end
								if ((v96.AncestralCall:IsCastable() and (v14:DebuffUp(v96.ColossusSmashDebuff))) or ((151 + 2924) <= (8723 - 5758))) then
									if (((1382 - (12 + 5)) <= (7810 - 5799)) and v23(v96.AncestralCall)) then
										return "ancestral_call main 44";
									end
								end
								v195 = 5 - 2;
							end
							if ((v195 == (0 - 0)) or ((6883 - 4107) > (726 + 2849))) then
								if ((v96.BloodFury:IsCastable() and v14:DebuffUp(v96.ColossusSmashDebuff)) or ((4527 - (1656 + 317)) == (4281 + 523))) then
									if (((2066 + 511) == (6851 - 4274)) and v23(v96.BloodFury)) then
										return "blood_fury main 39";
									end
								end
								if ((v96.Berserking:IsCastable() and (v14:DebuffRemains(v96.ColossusSmashDebuff) > (29 - 23))) or ((360 - (5 + 349)) >= (8972 - 7083))) then
									if (((1777 - (266 + 1005)) <= (1247 + 645)) and v23(v96.Berserking)) then
										return "berserking main 40";
									end
								end
								v195 = 3 - 2;
							end
						end
					end
					if ((v89 < v102) or ((2643 - 635) > (3914 - (561 + 1135)))) then
						if (((493 - 114) <= (13631 - 9484)) and v91 and ((v29 and v57) or not v57)) then
							local v197 = 1066 - (507 + 559);
							while true do
								if ((v197 == (0 - 0)) or ((13960 - 9446) <= (1397 - (212 + 176)))) then
									v26 = v110();
									if (v26 or ((4401 - (250 + 655)) == (3250 - 2058))) then
										return v26;
									end
									break;
								end
							end
						end
					end
					if ((v37 and v96.HeroicThrow:IsCastable() and not v14:IsInRange(52 - 22)) or ((324 - 116) == (4915 - (1869 + 87)))) then
						if (((14834 - 10557) >= (3214 - (484 + 1417))) and v23(v96.HeroicThrow, not v14:IsInRange(64 - 34))) then
							return "heroic_throw main";
						end
					end
					v140 = 2 - 0;
				end
				if (((3360 - (48 + 725)) < (5184 - 2010)) and ((0 - 0) == v140)) then
					if ((v33 and v96.Charge:IsCastable() and not v100) or ((2395 + 1725) <= (5873 - 3675))) then
						if (v23(v96.Charge, not v14:IsSpellInRange(v96.Charge)) or ((447 + 1149) == (251 + 607))) then
							return "charge main 34";
						end
					end
					v141 = v92.HandleDPSPotion(v14:DebuffUp(v96.ColossusSmashDebuff));
					if (((4073 - (152 + 701)) == (4531 - (430 + 881))) and v141) then
						return v141;
					end
					v140 = 1 + 0;
				end
				if ((v140 == (897 - (557 + 338))) or ((415 + 987) > (10201 - 6581))) then
					if (((9013 - 6439) == (6838 - 4264)) and v96.WreckingThrow:IsCastable() and v50 and v14:AffectingCombat() and v105()) then
						if (((3874 - 2076) < (3558 - (499 + 302))) and v23(v96.WreckingThrow, not v14:IsInRange(896 - (39 + 827)))) then
							return "wrecking_throw main";
						end
					end
					if ((v28 and (v104 > (5 - 3))) or ((841 - 464) > (10342 - 7738))) then
						v26 = v112();
						if (((871 - 303) < (78 + 833)) and v26) then
							return v26;
						end
					end
					if (((9614 - 6329) < (677 + 3551)) and ((v96.Massacre:IsAvailable() and (v14:HealthPercentage() < (55 - 20))) or (v14:HealthPercentage() < (124 - (103 + 1))))) then
						local v196 = 554 - (475 + 79);
						while true do
							if (((8465 - 4549) > (10649 - 7321)) and (v196 == (0 + 0))) then
								v26 = v113();
								if (((2201 + 299) < (5342 - (1395 + 108))) and v26) then
									return v26;
								end
								break;
							end
						end
					end
					v140 = 8 - 5;
				end
				if (((1711 - (7 + 1197)) == (222 + 285)) and (v140 == (2 + 1))) then
					v26 = v114();
					if (((559 - (27 + 292)) <= (9274 - 6109)) and v26) then
						return v26;
					end
					if (((1062 - 228) >= (3376 - 2571)) and v19.CastAnnotated(v96.Pool, false, "WAIT")) then
						return "Wait/Pool Resources";
					end
					break;
				end
			end
		end
	end
	local function v117()
		local v130 = 0 - 0;
		while true do
			if ((v130 == (6 - 2)) or ((3951 - (43 + 96)) < (9447 - 7131))) then
				v32 = EpicSettings.Settings['useBladestorm'];
				v35 = EpicSettings.Settings['useColossusSmash'];
				v82 = EpicSettings.Settings['useChampionsSpear'];
				v47 = EpicSettings.Settings['useThunderousRoar'];
				v130 = 11 - 6;
			end
			if ((v130 == (5 + 1)) or ((749 + 1903) <= (3029 - 1496))) then
				v54 = EpicSettings.Settings['championsSpearWithCD'];
				v55 = EpicSettings.Settings['thunderousRoarWithCD'];
				v56 = EpicSettings.Settings['warbreakerWithCD'];
				break;
			end
			if ((v130 == (2 + 1)) or ((6742 - 3144) < (460 + 1000))) then
				v46 = EpicSettings.Settings['useThunderClap'];
				v49 = EpicSettings.Settings['useWhirlwind'];
				v50 = EpicSettings.Settings['useWreckingThrow'];
				v30 = EpicSettings.Settings['useAvatar'];
				v130 = 1 + 3;
			end
			if ((v130 == (1756 - (1414 + 337))) or ((6056 - (1642 + 298)) < (3107 - 1915))) then
				v48 = EpicSettings.Settings['useWarbreaker'];
				v51 = EpicSettings.Settings['avatarWithCD'];
				v52 = EpicSettings.Settings['bladestormWithCD'];
				v53 = EpicSettings.Settings['colossusSmashWithCD'];
				v130 = 16 - 10;
			end
			if ((v130 == (2 - 1)) or ((1112 + 2265) <= (703 + 200))) then
				v37 = EpicSettings.Settings['useHeroicThrow'];
				v38 = EpicSettings.Settings['useMortalStrike'];
				v39 = EpicSettings.Settings['useOverpower'];
				v40 = EpicSettings.Settings['useRend'];
				v130 = 974 - (357 + 615);
			end
			if (((2791 + 1185) >= (1076 - 637)) and (v130 == (0 + 0))) then
				v31 = EpicSettings.Settings['useBattleShout'];
				v33 = EpicSettings.Settings['useCharge'];
				v34 = EpicSettings.Settings['useCleave'];
				v36 = EpicSettings.Settings['useExecute'];
				v130 = 2 - 1;
			end
			if (((3001 + 751) == (255 + 3497)) and (v130 == (2 + 0))) then
				v42 = EpicSettings.Settings['useShockwave'];
				v43 = EpicSettings.Settings['useSkullsplitter'];
				v44 = EpicSettings.Settings['useSlam'];
				v45 = EpicSettings.Settings['useSweepingStrikes'];
				v130 = 1304 - (384 + 917);
			end
		end
	end
	local function v118()
		local v131 = 697 - (128 + 569);
		while true do
			if (((5589 - (1407 + 136)) > (4582 - (687 + 1200))) and (v131 == (1710 - (556 + 1154)))) then
				v59 = EpicSettings.Settings['usePummel'];
				v60 = EpicSettings.Settings['useStormBolt'];
				v61 = EpicSettings.Settings['useIntimidatingShout'];
				v131 = 3 - 2;
			end
			if ((v131 == (99 - (9 + 86))) or ((3966 - (275 + 146)) == (520 + 2677))) then
				v80 = EpicSettings.Settings['unstanceHP'] or (64 - (29 + 35));
				v72 = EpicSettings.Settings['dieByTheSwordHP'] or (0 - 0);
				v73 = EpicSettings.Settings['ignorePainHP'] or (0 - 0);
				v131 = 21 - 16;
			end
			if (((1560 + 834) > (1385 - (53 + 959))) and (v131 == (409 - (312 + 96)))) then
				v62 = EpicSettings.Settings['useBitterImmunity'];
				v67 = EpicSettings.Settings['useDefensiveStance'];
				v63 = EpicSettings.Settings['useDieByTheSword'];
				v131 = 3 - 1;
			end
			if (((4440 - (147 + 138)) <= (5131 - (813 + 86))) and (v131 == (2 + 0))) then
				v64 = EpicSettings.Settings['useIgnorePain'];
				v66 = EpicSettings.Settings['useIntervene'];
				v65 = EpicSettings.Settings['useRallyingCry'];
				v131 = 4 - 1;
			end
			if ((v131 == (497 - (18 + 474))) or ((1209 + 2372) == (11335 - 7862))) then
				v76 = EpicSettings.Settings['interveneHP'] or (1086 - (860 + 226));
				v75 = EpicSettings.Settings['rallyingCryGroup'] or (303 - (121 + 182));
				v74 = EpicSettings.Settings['rallyingCryHP'] or (0 + 0);
				v131 = 1246 - (988 + 252);
			end
			if (((565 + 4430) > (1049 + 2299)) and (v131 == (1973 - (49 + 1921)))) then
				v70 = EpicSettings.Settings['useVictoryRush'];
				v71 = EpicSettings.Settings['bitterImmunityHP'] or (890 - (223 + 667));
				v77 = EpicSettings.Settings['defensiveStanceHP'] or (52 - (51 + 1));
				v131 = 6 - 2;
			end
			if ((v131 == (12 - 6)) or ((1879 - (146 + 979)) > (1052 + 2672))) then
				v81 = EpicSettings.Settings['victoryRushHP'] or (605 - (311 + 294));
				v83 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
		end
	end
	local function v119()
		local v132 = 0 - 0;
		while true do
			if (((92 + 125) >= (1500 - (496 + 947))) and (v132 == (1361 - (1233 + 125)))) then
				v85 = EpicSettings.Settings['HealingPotionName'] or "";
				v84 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((1 + 0) == v132) or ((1858 + 212) >= (768 + 3269))) then
				v91 = EpicSettings.Settings['useTrinkets'];
				v90 = EpicSettings.Settings['useRacials'];
				v57 = EpicSettings.Settings['trinketsWithCD'];
				v58 = EpicSettings.Settings['racialsWithCD'];
				v132 = 1647 - (963 + 682);
			end
			if (((2258 + 447) == (4209 - (504 + 1000))) and (v132 == (2 + 0))) then
				v68 = EpicSettings.Settings['useHealthstone'];
				v69 = EpicSettings.Settings['useHealingPotion'];
				v78 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v79 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v132 = 4 - 1;
			end
			if (((53 + 8) == (36 + 25)) and (v132 == (182 - (156 + 26)))) then
				v89 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v86 = EpicSettings.Settings['InterruptWithStun'];
				v87 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v88 = EpicSettings.Settings['InterruptThreshold'];
				v132 = 1 - 0;
			end
		end
	end
	local function v120()
		local v133 = 164 - (149 + 15);
		while true do
			if ((v133 == (962 - (890 + 70))) or ((816 - (39 + 78)) >= (1778 - (14 + 468)))) then
				v100 = v14:IsInMeleeRange(17 - 9);
				if (v92.TargetIsValid() or v13:AffectingCombat() or ((4983 - 3200) >= (1866 + 1750))) then
					local v193 = 0 + 0;
					while true do
						if ((v193 == (0 + 0)) or ((1768 + 2145) > (1187 + 3340))) then
							v101 = v9.BossFightRemains(nil, true);
							v102 = v101;
							v193 = 1 - 0;
						end
						if (((4326 + 50) > (2870 - 2053)) and (v193 == (1 + 0))) then
							if (((4912 - (12 + 39)) > (767 + 57)) and (v102 == (34392 - 23281))) then
								v102 = v9.FightRemains(v103, false);
							end
							break;
						end
					end
				end
				if (not v13:IsChanneling() or ((4925 - 3542) >= (632 + 1499))) then
					if (v13:AffectingCombat() or ((988 + 888) >= (6443 - 3902))) then
						v26 = v116();
						if (((1187 + 595) <= (18229 - 14457)) and v26) then
							return v26;
						end
					else
						v26 = v115();
						if (v26 or ((6410 - (1596 + 114)) < (2122 - 1309))) then
							return v26;
						end
					end
				end
				break;
			end
			if (((3912 - (164 + 549)) < (5488 - (1059 + 379))) and (v133 == (1 - 0))) then
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				if (v13:IsDeadOrGhost() or ((2566 + 2385) < (747 + 3683))) then
					return v26;
				end
				if (((488 - (145 + 247)) == (79 + 17)) and v28) then
					local v194 = 0 + 0;
					while true do
						if ((v194 == (0 - 0)) or ((526 + 2213) > (3453 + 555))) then
							v103 = v13:GetEnemiesInMeleeRange(12 - 4);
							v104 = #v103;
							break;
						end
					end
				else
					v104 = 721 - (254 + 466);
				end
				v133 = 562 - (544 + 16);
			end
			if ((v133 == (0 - 0)) or ((651 - (294 + 334)) == (1387 - (236 + 17)))) then
				v118();
				v117();
				v119();
				v27 = EpicSettings.Toggles['ooc'];
				v133 = 1 + 0;
			end
		end
	end
	local function v121()
		v19.Print("Arms Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(56 + 15, v120, v121);
end;
return v0["Epix_Warrior_Arms.lua"]();

