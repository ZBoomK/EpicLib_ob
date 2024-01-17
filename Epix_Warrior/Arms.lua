local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1149 - (556 + 592))) or ((1058 + 1917) < (1885 - (329 + 479)))) then
			return v6(...);
		end
		if (((2367 - (174 + 680)) == (5198 - 3685)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((3250 + 1301) > (4809 - (396 + 343))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
	local v95 = (v94[1490 - (29 + 1448)] and v19(v94[1402 - (135 + 1254)])) or v19(0 - 0);
	local v96 = (v94[65 - 51] and v19(v94[10 + 4])) or v19(1527 - (389 + 1138));
	local v97 = v18.Warrior.Arms;
	local v98 = v19.Warrior.Arms;
	local v99 = v23.Warrior.Arms;
	local v100 = {};
	local v101;
	local v102 = 11685 - (102 + 472);
	local v103 = 10486 + 625;
	v10:RegisterForEvent(function()
		v102 = 6162 + 4949;
		v103 = 10361 + 750;
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v123 = 1545 - (320 + 1225);
		while true do
			if (((85 - 37) == (30 + 18)) and (v123 == (1465 - (157 + 1307)))) then
				v96 = (v94[1873 - (821 + 1038)] and v19(v94[34 - 20])) or v19(0 + 0);
				break;
			end
			if (((2037 - 890) >= (125 + 210)) and (v123 == (0 - 0))) then
				v94 = v14:GetEquipment();
				v95 = (v94[1039 - (834 + 192)] and v19(v94[1 + 12])) or v19(0 + 0);
				v123 = 1 + 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v104;
	local v105;
	local function v106()
		local v124 = 0 - 0;
		local v125;
		while true do
			if (((3739 - (300 + 4)) > (561 + 1536)) and (v124 == (0 - 0))) then
				v125 = UnitGetTotalAbsorbs(v15);
				if ((v125 > (362 - (112 + 250))) or ((1503 + 2267) >= (10123 - 6082))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v107(v126)
		return (v126:HealthPercentage() > (12 + 8)) or (v97.Massacre:IsAvailable() and (v126:HealthPercentage() < (19 + 16)));
	end
	local function v108(v127)
		return (v127:DebuffStack(v97.ExecutionersPrecisionDebuff) == (2 + 0)) or (v127:DebuffRemains(v97.DeepWoundsDebuff) <= v14:GCD()) or (v97.Dreadnaught:IsAvailable() and v97.Battlelord:IsAvailable() and (v105 <= (1 + 1)));
	end
	local function v109(v128)
		return v14:BuffUp(v97.SuddenDeathBuff) or ((v105 <= (2 + 0)) and ((v128:HealthPercentage() < (1434 - (1001 + 413))) or (v97.Massacre:IsAvailable() and (v128:HealthPercentage() < (78 - 43))))) or v14:BuffUp(v97.SweepingStrikes);
	end
	local function v110()
		local v129 = 882 - (244 + 638);
		while true do
			if ((v129 == (696 - (627 + 66))) or ((11295 - 7504) <= (2213 - (512 + 90)))) then
				if ((v97.BattleStance:IsCastable() and v14:BuffDown(v97.BattleStance, true) and v68 and (v14:HealthPercentage() > v81)) or ((6484 - (1665 + 241)) <= (2725 - (373 + 344)))) then
					if (((508 + 617) <= (550 + 1526)) and v24(v97.BattleStance)) then
						return "battle_stance after defensive stance defensive";
					end
				end
				if ((v98.Healthstone:IsReady() and v69 and (v14:HealthPercentage() <= v79)) or ((1959 - 1216) >= (7443 - 3044))) then
					if (((2254 - (35 + 1064)) < (1218 + 455)) and v24(v99.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				v129 = 8 - 4;
			end
			if ((v129 == (0 + 0)) or ((3560 - (298 + 938)) <= (1837 - (233 + 1026)))) then
				if (((5433 - (636 + 1030)) == (1926 + 1841)) and v97.BitterImmunity:IsReady() and v63 and (v14:HealthPercentage() <= v72)) then
					if (((3994 + 95) == (1215 + 2874)) and v24(v97.BitterImmunity)) then
						return "bitter_immunity defensive";
					end
				end
				if (((302 + 4156) >= (1895 - (55 + 166))) and v97.DieByTheSword:IsCastable() and v64 and (v14:HealthPercentage() <= v73)) then
					if (((189 + 783) <= (143 + 1275)) and v24(v97.DieByTheSword)) then
						return "die_by_the_sword defensive";
					end
				end
				v129 = 3 - 2;
			end
			if ((v129 == (298 - (36 + 261))) or ((8635 - 3697) < (6130 - (34 + 1334)))) then
				if ((v97.IgnorePain:IsCastable() and v65 and (v14:HealthPercentage() <= v74)) or ((963 + 1541) > (3314 + 950))) then
					if (((3436 - (1035 + 248)) == (2174 - (20 + 1))) and v24(v97.IgnorePain, nil, nil, true)) then
						return "ignore_pain defensive";
					end
				end
				if ((v97.RallyingCry:IsCastable() and v66 and v14:BuffDown(v97.AspectsFavorBuff) and v14:BuffDown(v97.RallyingCry) and (((v14:HealthPercentage() <= v75) and v93.IsSoloMode()) or v93.AreUnitsBelowHealthPercentage(v75, v76))) or ((265 + 242) >= (2910 - (134 + 185)))) then
					if (((5614 - (549 + 584)) == (5166 - (314 + 371))) and v24(v97.RallyingCry)) then
						return "rallying_cry defensive";
					end
				end
				v129 = 6 - 4;
			end
			if ((v129 == (972 - (478 + 490))) or ((1234 + 1094) < (1865 - (786 + 386)))) then
				if (((14018 - 9690) == (5707 - (1055 + 324))) and v70 and (v14:HealthPercentage() <= v80)) then
					local v191 = 1340 - (1093 + 247);
					while true do
						if (((1412 + 176) >= (141 + 1191)) and (v191 == (0 - 0))) then
							if ((v86 == "Refreshing Healing Potion") or ((14165 - 9991) > (12087 - 7839))) then
								if (v98.RefreshingHealingPotion:IsReady() or ((11524 - 6938) <= (30 + 52))) then
									if (((14881 - 11018) == (13314 - 9451)) and v24(v99.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v86 == "Dreamwalker's Healing Potion") or ((213 + 69) <= (107 - 65))) then
								if (((5297 - (364 + 324)) >= (2099 - 1333)) and v98.DreamwalkersHealingPotion:IsReady()) then
									if (v24(v99.RefreshingHealingPotion) or ((2764 - 1612) == (825 + 1663))) then
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
			if (((14318 - 10896) > (5365 - 2015)) and (v129 == (5 - 3))) then
				if (((2145 - (1249 + 19)) > (340 + 36)) and v97.Intervene:IsCastable() and v67 and (v17:HealthPercentage() <= v77) and (v17:UnitName() ~= v14:UnitName())) then
					if (v24(v99.InterveneFocus) or ((12136 - 9018) <= (2937 - (686 + 400)))) then
						return "intervene defensive";
					end
				end
				if ((v97.DefensiveStance:IsCastable() and v14:BuffDown(v97.DefensiveStance, true) and v68 and (v14:HealthPercentage() <= v78)) or ((130 + 35) >= (3721 - (73 + 156)))) then
					if (((19 + 3930) < (5667 - (721 + 90))) and v24(v97.DefensiveStance)) then
						return "defensive_stance defensive";
					end
				end
				v129 = 1 + 2;
			end
		end
	end
	local function v111()
		v27 = v93.HandleTopTrinket(v100, v30, 129 - 89, nil);
		if (v27 or ((4746 - (224 + 246)) < (4885 - 1869))) then
			return v27;
		end
		v27 = v93.HandleBottomTrinket(v100, v30, 73 - 33, nil);
		if (((851 + 3839) > (99 + 4026)) and v27) then
			return v27;
		end
	end
	local function v112()
		local v130 = 0 + 0;
		while true do
			if ((v130 == (0 - 0)) or ((166 - 116) >= (1409 - (203 + 310)))) then
				if (v101 or ((3707 - (1238 + 755)) >= (207 + 2751))) then
					local v192 = 1534 - (709 + 825);
					while true do
						if ((v192 == (1 - 0)) or ((2171 - 680) < (1508 - (196 + 668)))) then
							if (((2779 - 2075) < (2044 - 1057)) and (v90 < v103) and v97.Warbreaker:IsCastable() and v49 and ((v57 and v30) or not v57)) then
								if (((4551 - (171 + 662)) > (1999 - (4 + 89))) and v24(v97.Warbreaker)) then
									return "warbreaker precombat";
								end
							end
							if ((v97.Overpower:IsCastable() and v40) or ((3357 - 2399) > (1324 + 2311))) then
								if (((15377 - 11876) <= (1762 + 2730)) and v24(v97.Overpower)) then
									return "overpower precombat";
								end
							end
							break;
						end
						if ((v192 == (1486 - (35 + 1451))) or ((4895 - (28 + 1425)) < (4541 - (941 + 1052)))) then
							if (((2757 + 118) >= (2978 - (822 + 692))) and v97.Skullsplitter:IsCastable() and v44) then
								if (v24(v97.Skullsplitter) or ((6848 - 2051) >= (2305 + 2588))) then
									return "skullsplitter precombat";
								end
							end
							if (((v90 < v103) and v97.ColossusSmash:IsCastable() and v36 and ((v54 and v30) or not v54)) or ((848 - (45 + 252)) > (2047 + 21))) then
								if (((728 + 1386) > (2297 - 1353)) and v24(v97.ColossusSmash)) then
									return "colossus_smash precombat";
								end
							end
							v192 = 434 - (114 + 319);
						end
					end
				end
				if ((v34 and v97.Charge:IsCastable()) or ((3247 - 985) >= (3967 - 871))) then
					if (v24(v97.Charge) or ((1438 + 817) >= (5268 - 1731))) then
						return "charge precombat";
					end
				end
				break;
			end
		end
	end
	local function v113()
		local v131 = 0 - 0;
		while true do
			if ((v131 == (1967 - (556 + 1407))) or ((5043 - (741 + 465)) < (1771 - (170 + 295)))) then
				if (((1555 + 1395) == (2710 + 240)) and v97.Overpower:IsCastable() and v40 and (((v97.Overpower:Charges() == (4 - 2)) and (not v97.TestofMight:IsAvailable() or (v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)) or v97.Battlelord:IsAvailable())) or (v14:Rage() < (59 + 11)))) then
					if (v24(v97.Overpower, not v101) or ((3029 + 1694) < (1868 + 1430))) then
						return "overpower hac 89";
					end
				end
				if (((2366 - (957 + 273)) >= (42 + 112)) and v97.ThunderClap:IsReady() and v47 and (v105 > (1 + 1))) then
					if (v24(v97.ThunderClap, not v101) or ((1032 - 761) > (12512 - 7764))) then
						return "thunder_clap hac 90";
					end
				end
				if (((14478 - 9738) >= (15607 - 12455)) and v97.MortalStrike:IsReady() and v39) then
					if (v24(v97.MortalStrike, not v101) or ((4358 - (389 + 1391)) >= (2127 + 1263))) then
						return "mortal_strike hac 91";
					end
				end
				if (((5 + 36) <= (3781 - 2120)) and v97.Rend:IsReady() and v41 and (v105 == (952 - (783 + 168))) and v15:DebuffRefreshable(v97.RendDebuff)) then
					if (((2017 - 1416) < (3502 + 58)) and v24(v97.Rend, not v101)) then
						return "rend hac 92";
					end
				end
				if (((546 - (309 + 2)) < (2109 - 1422)) and v97.Whirlwind:IsReady() and v50 and (v97.StormofSwords:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 > (1213 - (1090 + 122)))))) then
					if (((1475 + 3074) > (3872 - 2719)) and v24(v97.Whirlwind, not v15:IsInMeleeRange(6 + 2))) then
						return "whirlwind hac 93";
					end
				end
				if ((v97.Cleave:IsReady() and v35 and not v97.CrushingForce:IsAvailable()) or ((5792 - (628 + 490)) < (838 + 3834))) then
					if (((9081 - 5413) < (20843 - 16282)) and v24(v97.Cleave, not v101)) then
						return "cleave hac 94";
					end
				end
				v131 = 779 - (431 + 343);
			end
			if (((1 - 0) == v131) or ((1316 - 861) == (2848 + 757))) then
				if (((v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) or ((341 + 2322) == (5007 - (556 + 1139)))) then
					local v193 = 15 - (6 + 9);
					while true do
						if (((784 + 3493) <= (2293 + 2182)) and (v193 == (169 - (28 + 141)))) then
							if (v93.CastCycle(v97.ColossusSmash, v104, v107, not v101) or ((337 + 533) == (1466 - 277))) then
								return "colossus_smash hac 73";
							end
							if (((1100 + 453) <= (4450 - (486 + 831))) and v24(v97.ColossusSmash, not v101)) then
								return "colossus_smash hac 73";
							end
							break;
						end
					end
				end
				if (((v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) or ((5821 - 3584) >= (12360 - 8849))) then
					if (v24(v97.ColossusSmash, not v101) or ((251 + 1073) > (9549 - 6529))) then
						return "colossus_smash hac 74";
					end
				end
				if (((v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)) or ((v105 > (1264 - (668 + 595))) and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (0 + 0))))) or ((604 + 2388) == (5129 - 3248))) then
					if (((3396 - (23 + 267)) > (3470 - (1129 + 815))) and v24(v97.ThunderousRoar, not v15:IsInMeleeRange(395 - (371 + 16)))) then
						return "thunderous_roar hac 75";
					end
				end
				if (((4773 - (1326 + 424)) < (7329 - 3459)) and (v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "player") and v97.ChampionsSpear:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) then
					if (((522 - 379) > (192 - (88 + 30))) and v24(v99.ChampionsSpearPlayer, not v15:IsSpellInRange(v97.ChampionsSpear))) then
						return "spear_of_bastion hac 76";
					end
				end
				if (((789 - (720 + 51)) < (4698 - 2586)) and (v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "cursor") and v97.ChampionsSpear:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) then
					if (((2873 - (421 + 1355)) <= (2685 - 1057)) and v24(v99.ChampionsSpearCursor, not v15:IsSpellInRange(v97.ChampionsSpear))) then
						return "spear_of_bastion hac 76";
					end
				end
				if (((2275 + 2355) == (5713 - (286 + 797))) and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable() and v97.Unhinged:IsAvailable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) then
					if (((12940 - 9400) > (4443 - 1760)) and v24(v97.Bladestorm, not v101)) then
						return "bladestorm hac 77";
					end
				end
				v131 = 441 - (397 + 42);
			end
			if (((1498 + 3296) >= (4075 - (24 + 776))) and (v131 == (4 - 1))) then
				if (((2269 - (222 + 563)) == (3269 - 1785)) and v97.MortalStrike:IsReady() and v39) then
					local v194 = 0 + 0;
					while true do
						if (((1622 - (23 + 167)) < (5353 - (690 + 1108))) and (v194 == (0 + 0))) then
							if (v93.CastCycle(v97.MortalStrike, v104, v108, not v101) or ((879 + 186) > (4426 - (40 + 808)))) then
								return "mortal_strike hac 83";
							end
							if (v24(v97.MortalStrike, not v101) or ((790 + 4005) < (5380 - 3973))) then
								return "mortal_strike hac 83";
							end
							break;
						end
					end
				end
				if (((1772 + 81) < (2547 + 2266)) and v97.Execute:IsReady() and v37 and (v14:BuffUp(v97.SuddenDeathBuff) or ((v105 <= (2 + 0)) and ((v15:HealthPercentage() < (591 - (47 + 524))) or (v97.Massacre:IsAvailable() and (v15:HealthPercentage() < (23 + 12))))) or v14:BuffUp(v97.SweepingStrikes))) then
					local v195 = 0 - 0;
					while true do
						if ((v195 == (0 - 0)) or ((6433 - 3612) < (4157 - (1165 + 561)))) then
							if (v93.CastCycle(v97.Execute, v104, v109, not v101) or ((86 + 2788) < (6754 - 4573))) then
								return "execute hac 84";
							end
							if (v24(v97.Execute, not v101) or ((1026 + 1663) <= (822 - (341 + 138)))) then
								return "execute hac 84";
							end
							break;
						end
					end
				end
				if (((v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable()) or ((505 + 1364) == (4145 - 2136))) then
					if (v24(v97.ThunderousRoar, not v15:IsInMeleeRange(334 - (89 + 237))) or ((11407 - 7861) < (4888 - 2566))) then
						return "thunderous_roar hac 85";
					end
				end
				if ((v97.Shockwave:IsCastable() and v43 and (v105 > (883 - (581 + 300))) and (v97.SonicBoom:IsAvailable() or v15:IsCasting())) or ((3302 - (855 + 365)) == (11336 - 6563))) then
					if (((1060 + 2184) > (2290 - (1030 + 205))) and v24(v97.Shockwave, not v15:IsInMeleeRange(8 + 0))) then
						return "shockwave hac 86";
					end
				end
				if ((v97.Overpower:IsCastable() and v40 and (v105 == (1 + 0)) and (((v97.Overpower:Charges() == (288 - (156 + 130))) and not v97.Battlelord:IsAvailable() and (v15:Debuffdown(v97.ColossusSmashDebuff) or (v14:RagePercentage() < (56 - 31)))) or v97.Battlelord:IsAvailable())) or ((5583 - 2270) <= (3641 - 1863))) then
					if (v24(v97.Overpower, not v101) or ((375 + 1046) >= (1227 + 877))) then
						return "overpower hac 87";
					end
				end
				if (((1881 - (10 + 59)) <= (919 + 2330)) and v97.Slam:IsReady() and v45 and (v105 == (4 - 3)) and not v97.Battlelord:IsAvailable() and (v14:RagePercentage() > (1233 - (671 + 492)))) then
					if (((1292 + 331) <= (3172 - (369 + 846))) and v24(v97.Slam, not v101)) then
						return "slam hac 88";
					end
				end
				v131 = 2 + 2;
			end
			if (((3766 + 646) == (6357 - (1036 + 909))) and ((4 + 1) == v131)) then
				if (((2938 - 1188) >= (1045 - (11 + 192))) and v97.IgnorePain:IsReady() and v65 and v97.Battlelord:IsAvailable() and v97.AngerManagement:IsAvailable() and (v14:Rage() > (16 + 14)) and ((v15:HealthPercentage() < (195 - (135 + 40))) or (v97.Massacre:IsAvailable() and (v15:HealthPercentage() < (84 - 49))))) then
					if (((2636 + 1736) > (4075 - 2225)) and v24(v97.IgnorePain, not v101)) then
						return "ignore_pain hac 95";
					end
				end
				if (((347 - 115) < (997 - (50 + 126))) and v97.Slam:IsReady() and v45 and v97.CrushingForce:IsAvailable() and (v14:Rage() > (83 - 53)) and ((v97.FervorofBattle:IsAvailable() and (v105 == (1 + 0))) or not v97.FervorofBattle:IsAvailable())) then
					if (((1931 - (1233 + 180)) < (1871 - (522 + 447))) and v24(v97.Slam, not v101)) then
						return "slam hac 96";
					end
				end
				if (((4415 - (107 + 1314)) > (399 + 459)) and v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable())) then
					if (v24(v97.Shockwave, not v15:IsInMeleeRange(24 - 16)) or ((1595 + 2160) <= (1817 - 902))) then
						return "shockwave hac 97";
					end
				end
				if (((15612 - 11666) > (5653 - (716 + 1194))) and v30 and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable()) then
					if (v24(v97.Bladestorm, not v101) or ((23 + 1312) >= (355 + 2951))) then
						return "bladestorm hac 98";
					end
				end
				break;
			end
			if (((5347 - (74 + 429)) > (4345 - 2092)) and (v131 == (1 + 1))) then
				if (((1034 - 582) == (320 + 132)) and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable() and (((v105 > (2 - 1)) and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or ((v105 > (2 - 1)) and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (433 - (279 + 154)))))) then
					if (v24(v97.Bladestorm, not v101) or ((5335 - (454 + 324)) < (1642 + 445))) then
						return "bladestorm hac 78";
					end
				end
				if (((3891 - (12 + 5)) == (2089 + 1785)) and v97.Cleave:IsReady() and v35 and ((v105 > (4 - 2)) or (not v97.Battlelord:IsAvailable() and v14:BuffUp(v97.MercilessBonegrinderBuff) and (v97.MortalStrike:CooldownRemains() > v14:GCD())))) then
					if (v24(v97.Cleave, not v101) or ((717 + 1221) > (6028 - (277 + 816)))) then
						return "cleave hac 79";
					end
				end
				if ((v97.Whirlwind:IsReady() and v50 and ((v105 > (8 - 6)) or (v97.StormofSwords:IsAvailable() and (v14:BuffUp(v97.MercilessBonegrinderBuff) or v14:BuffUp(v97.HurricaneBuff))))) or ((5438 - (1058 + 125)) < (642 + 2781))) then
					if (((2429 - (815 + 160)) <= (10687 - 8196)) and v24(v97.Whirlwind, not v15:IsInMeleeRange(18 - 10))) then
						return "whirlwind hac 80";
					end
				end
				if ((v97.Skullsplitter:IsCastable() and v44 and ((v14:Rage() < (10 + 30)) or (v97.TideofBlood:IsAvailable() and (v15:DebuffRemains(v97.RendDebuff) > (0 - 0)) and ((v14:BuffUp(v97.SweepingStrikes) and (v105 > (1900 - (41 + 1857)))) or v15:DebuffUp(v97.ColossusSmashDebuff) or v14:BuffUp(v97.TestofMightBuff))))) or ((6050 - (1222 + 671)) <= (7244 - 4441))) then
					if (((6974 - 2121) >= (4164 - (229 + 953))) and v24(v97.Skullsplitter, not v15:IsInMeleeRange(1782 - (1111 + 663)))) then
						return "sweeping_strikes execute 81";
					end
				end
				if (((5713 - (874 + 705)) > (470 + 2887)) and v97.MortalStrike:IsReady() and v39 and v14:BuffUp(v97.SweepingStrikes) and (v14:BuffStack(v97.CrushingAdvanceBuff) == (3 + 0))) then
					if (v24(v97.MortalStrike, not v101) or ((7102 - 3685) < (72 + 2462))) then
						return "mortal_strike hac 81.5";
					end
				end
				if ((v97.Overpower:IsCastable() and v40 and v14:BuffUp(v97.SweepingStrikes) and v97.Dreadnaught:IsAvailable()) or ((3401 - (642 + 37)) <= (38 + 126))) then
					if (v24(v97.Overpower, not v101) or ((386 + 2022) < (5294 - 3185))) then
						return "overpower hac 82";
					end
				end
				v131 = 457 - (233 + 221);
			end
			if ((v131 == (0 - 0)) or ((30 + 3) == (2996 - (718 + 823)))) then
				if ((v97.Execute:IsReady() and v37 and v14:BuffUp(v97.JuggernautBuff) and (v14:BuffRemains(v97.JuggernautBuff) < v14:GCD())) or ((279 + 164) >= (4820 - (266 + 539)))) then
					if (((9574 - 6192) > (1391 - (636 + 589))) and v24(v97.Execute, not v101)) then
						return "execute hac 67";
					end
				end
				if ((v97.ThunderClap:IsReady() and v47 and (v105 > (4 - 2)) and v97.BloodandThunder:IsAvailable() and v97.Rend:IsAvailable() and v15:DebuffRefreshable(v97.RendDebuff)) or ((577 - 297) == (2425 + 634))) then
					if (((684 + 1197) > (2308 - (657 + 358))) and v24(v97.ThunderClap, not v101)) then
						return "thunder_clap hac 68";
					end
				end
				if (((6240 - 3883) == (5369 - 3012)) and v97.SweepingStrikes:IsCastable() and v46 and (v105 >= (1189 - (1151 + 36))) and ((v97.Bladestorm:CooldownRemains() > (15 + 0)) or not v97.Bladestorm:IsAvailable())) then
					if (((33 + 90) == (367 - 244)) and v24(v97.SweepingStrikes, not v15:IsInMeleeRange(1840 - (1552 + 280)))) then
						return "sweeping_strikes hac 68";
					end
				end
				if ((v97.Rend:IsReady() and v41 and (v105 == (835 - (64 + 770))) and ((v15:HealthPercentage() > (14 + 6)) or (v97.Massacre:IsAvailable() and (v15:HealthPercentage() < (79 - 44))))) or (v97.TideofBlood:IsAvailable() and (v97.Skullsplitter:CooldownRemains() <= v14:GCD()) and ((v97.ColossusSmash:CooldownRemains() < v14:GCD()) or v15:DebuffUp(v97.ColossusSmashDebuff)) and (v15:DebuffRemains(v97.RendDebuff) < ((4 + 17) * (1243.85 - (157 + 1086))))) or ((2113 - 1057) >= (14855 - 11463))) then
					if (v24(v97.Rend, not v101) or ((1657 - 576) < (1466 - 391))) then
						return "rend hac 70";
					end
				end
				if (((v90 < v103) and v31 and ((v52 and v30) or not v52) and v97.Avatar:IsCastable()) or ((1868 - (599 + 220)) >= (8825 - 4393))) then
					if (v24(v97.Avatar, not v101) or ((6699 - (1813 + 118)) <= (619 + 227))) then
						return "avatar hac 71";
					end
				end
				if (((v90 < v103) and v97.Warbreaker:IsCastable() and v49 and ((v57 and v30) or not v57) and (v105 > (1218 - (841 + 376)))) or ((4705 - 1347) <= (330 + 1090))) then
					if (v24(v97.Warbreaker, not v101) or ((10205 - 6466) <= (3864 - (464 + 395)))) then
						return "warbreaker hac 72";
					end
				end
				v131 = 2 - 1;
			end
		end
	end
	local function v114()
		local v132 = 0 + 0;
		while true do
			if ((v132 == (837 - (467 + 370))) or ((3427 - 1768) >= (1567 + 567))) then
				if (((v90 < v103) and v46 and v97.SweepingStrikes:IsCastable() and (v105 > (3 - 2))) or ((509 + 2751) < (5479 - 3124))) then
					if (v24(v97.SweepingStrikes, not v15:IsInMeleeRange(528 - (150 + 370))) or ((1951 - (74 + 1208)) == (10386 - 6163))) then
						return "sweeping_strikes execute 51";
					end
				end
				if ((v97.Rend:IsReady() and v41 and (v15:DebuffRemains(v97.RendDebuff) <= v14:GCD()) and not v97.Bloodletting:IsAvailable() and ((not v97.Warbreaker:IsAvailable() and (v97.ColossusSmash:CooldownRemains() < (18 - 14))) or (v97.Warbreaker:IsAvailable() and (v97.Warbreaker:CooldownRemains() < (3 + 1)))) and (v15:TimeToDie() > (402 - (14 + 376)))) or ((2934 - 1242) < (381 + 207))) then
					if (v24(v97.Rend, not v101) or ((4214 + 583) < (3482 + 169))) then
						return "rend execute 52";
					end
				end
				if (((v90 < v103) and v31 and ((v52 and v30) or not v52) and v97.Avatar:IsCastable() and (v97.ColossusSmash:CooldownUp() or v15:DebuffUp(v97.ColossusSmashDebuff) or (v103 < (58 - 38)))) or ((3143 + 1034) > (4928 - (23 + 55)))) then
					if (v24(v97.Avatar, not v101) or ((947 - 547) > (742 + 369))) then
						return "avatar execute 53";
					end
				end
				v132 = 1 + 0;
			end
			if (((4730 - 1679) > (317 + 688)) and (v132 == (903 - (652 + 249)))) then
				if (((9882 - 6189) <= (6250 - (708 + 1160))) and v97.Skullsplitter:IsCastable() and v44 and ((v97.TestofMight:IsAvailable() and (v14:RagePercentage() <= (81 - 51))) or (not v97.TestofMight:IsAvailable() and (v15:DebuffUp(v97.ColossusSmashDebuff) or (v97.ColossusSmash:CooldownRemains() > (9 - 4))) and (v14:RagePercentage() <= (57 - (10 + 17)))))) then
					if (v24(v97.Skullsplitter, not v15:IsInMeleeRange(2 + 6)) or ((5014 - (1400 + 332)) > (7864 - 3764))) then
						return "skullsplitter execute 57";
					end
				end
				if (((v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or ((5488 - (242 + 1666)) < (1218 + 1626))) then
					if (((33 + 56) < (3827 + 663)) and v24(v97.ThunderousRoar, not v15:IsInMeleeRange(948 - (850 + 90)))) then
						return "thunderous_roar execute 57";
					end
				end
				if (((v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "player") and v97.ChampionsSpear:IsCastable() and (v15:DebuffUp(v97.ColossusSmashDebuff) or v14:BuffUp(v97.TestofMightBuff))) or ((8726 - 3743) < (3198 - (360 + 1030)))) then
					if (((3389 + 440) > (10637 - 6868)) and v24(v99.ChampionsSpearPlayer, not v15:IsSpellInRange(v97.ChampionsSpear))) then
						return "spear_of_bastion execute 57";
					end
				end
				v132 = 3 - 0;
			end
			if (((3146 - (909 + 752)) <= (4127 - (109 + 1114))) and (v132 == (1 - 0))) then
				if (((1662 + 2607) == (4511 - (6 + 236))) and (v90 < v103) and v49 and ((v57 and v30) or not v57) and v97.Warbreaker:IsCastable()) then
					if (((244 + 143) <= (2240 + 542)) and v24(v97.Warbreaker, not v101)) then
						return "warbreaker execute 54";
					end
				end
				if (((v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) or ((4478 - 2579) <= (1601 - 684))) then
					if (v24(v97.ColossusSmash, not v101) or ((5445 - (1076 + 57)) <= (145 + 731))) then
						return "colossus_smash execute 55";
					end
				end
				if (((2921 - (579 + 110)) <= (205 + 2391)) and v97.Execute:IsReady() and v37 and v14:BuffUp(v97.SuddenDeathBuff) and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (0 + 0))) then
					if (((1112 + 983) < (4093 - (174 + 233))) and v24(v97.Execute, not v101)) then
						return "execute execute 56";
					end
				end
				v132 = 5 - 3;
			end
			if ((v132 == (4 - 1)) or ((710 + 885) >= (5648 - (663 + 511)))) then
				if (((v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "cursor") and v97.ChampionsSpear:IsCastable() and (v15:DebuffUp(v97.ColossusSmashDebuff) or v14:BuffUp(v97.TestofMightBuff))) or ((4121 + 498) < (626 + 2256))) then
					if (v24(v99.ChampionsSpearCursor, not v15:IsSpellInRange(v97.ChampionsSpear)) or ((906 - 612) >= (2926 + 1905))) then
						return "spear_of_bastion execute 57";
					end
				end
				if (((4776 - 2747) <= (7465 - 4381)) and v97.Cleave:IsReady() and v35 and (v105 > (1 + 1)) and (v15:DebuffRemains(v97.DeepWoundsDebuff) < v14:GCD())) then
					if (v24(v97.Cleave, not v101) or ((3964 - 1927) == (1725 + 695))) then
						return "cleave execute 58";
					end
				end
				if (((408 + 4050) > (4626 - (478 + 244))) and v97.MortalStrike:IsReady() and v39 and ((v15:DebuffStack(v97.ExecutionersPrecisionDebuff) == (519 - (440 + 77))) or (v15:DebuffRemains(v97.DeepWoundsDebuff) <= v14:GCD()))) then
					if (((199 + 237) >= (449 - 326)) and v24(v97.MortalStrike, not v101)) then
						return "mortal_strike execute 59";
					end
				end
				v132 = 1560 - (655 + 901);
			end
			if (((93 + 407) < (1391 + 425)) and (v132 == (3 + 1))) then
				if (((14398 - 10824) == (5019 - (695 + 750))) and v97.Overpower:IsCastable() and v40 and (v14:Rage() < (136 - 96)) and (v14:BuffStack(v97.MartialProwessBuff) < (2 - 0))) then
					if (((888 - 667) < (741 - (285 + 66))) and v24(v97.Overpower, not v101)) then
						return "overpower execute 60";
					end
				end
				if ((v97.Execute:IsReady() and v37) or ((5158 - 2945) <= (2731 - (682 + 628)))) then
					if (((493 + 2565) < (5159 - (176 + 123))) and v24(v97.Execute, not v101)) then
						return "execute execute 62";
					end
				end
				if ((v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable() or v15:IsCasting())) or ((543 + 753) >= (3226 + 1220))) then
					if (v24(v97.Shockwave, not v15:IsInMeleeRange(277 - (239 + 30))) or ((379 + 1014) > (4315 + 174))) then
						return "shockwave execute 63";
					end
				end
				v132 = 8 - 3;
			end
			if (((15 - 10) == v132) or ((4739 - (306 + 9)) < (94 - 67))) then
				if ((v97.Overpower:IsCastable() and v40) or ((348 + 1649) > (2341 + 1474))) then
					if (((1668 + 1797) > (5470 - 3557)) and v24(v97.Overpower, not v101)) then
						return "overpower execute 64";
					end
				end
				if (((2108 - (1140 + 235)) < (1158 + 661)) and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable()) then
					if (v24(v97.Bladestorm, not v101) or ((4031 + 364) == (1221 + 3534))) then
						return "bladestorm execute 65";
					end
				end
				break;
			end
		end
	end
	local function v115()
		local v133 = 52 - (33 + 19);
		while true do
			if ((v133 == (2 + 1)) or ((11368 - 7575) < (1044 + 1325))) then
				if ((v97.Skullsplitter:IsCastable() and v44 and not v97.TestofMight:IsAvailable() and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (0 - 0)) and (v15:DebuffUp(v97.ColossusSmashDebuff) or (v97.ColossusSmash:CooldownRemains() > (3 + 0)))) or ((4773 - (586 + 103)) == (25 + 240))) then
					if (((13416 - 9058) == (5846 - (1309 + 179))) and v24(v97.Skullsplitter, not v101)) then
						return "skullsplitter single_target 105";
					end
				end
				if ((v97.Skullsplitter:IsCastable() and v44 and v97.TestofMight:IsAvailable() and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (0 - 0))) or ((1366 + 1772) < (2666 - 1673))) then
					if (((2516 + 814) > (4935 - 2612)) and v24(v97.Skullsplitter, not v101)) then
						return "skullsplitter single_target 106";
					end
				end
				if (((v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff) and (v14:RagePercentage() < (65 - 32))) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or ((4235 - (295 + 314)) == (9797 - 5808))) then
					if (v24(v97.ThunderousRoar, not v15:IsInMeleeRange(1970 - (1300 + 662))) or ((2876 - 1960) == (4426 - (1178 + 577)))) then
						return "thunderous_roar single_target 107";
					end
				end
				v133 = 3 + 1;
			end
			if (((803 - 531) == (1677 - (851 + 554))) and (v133 == (4 + 0))) then
				if (((11783 - 7534) <= (10509 - 5670)) and v97.Whirlwind:IsReady() and v50 and v97.StormofSwords:IsAvailable() and v97.TestofMight:IsAvailable() and (v14:RagePercentage() > (382 - (115 + 187))) and v15:DebuffUp(v97.ColossusSmashDebuff)) then
					if (((2127 + 650) < (3030 + 170)) and v24(v97.Whirlwind, not v15:IsInMeleeRange(31 - 23))) then
						return "whirlwind single_target 108";
					end
				end
				if (((1256 - (160 + 1001)) < (1713 + 244)) and v97.ThunderClap:IsReady() and v47 and (v15:DebuffRemains(v97.RendDebuff) <= v14:GCD()) and not v97.TideofBlood:IsAvailable()) then
					if (((570 + 256) < (3514 - 1797)) and v24(v97.ThunderClap, not v101)) then
						return "thunder_clap single_target 109";
					end
				end
				if (((1784 - (237 + 121)) >= (2002 - (525 + 372))) and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable() and ((v97.Hurricane:IsAvailable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or (v97.Unhinged:IsAvailable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))))) then
					if (((5221 - 2467) <= (11101 - 7722)) and v24(v97.Bladestorm, not v101)) then
						return "bladestorm single_target 110";
					end
				end
				v133 = 147 - (96 + 46);
			end
			if ((v133 == (782 - (643 + 134))) or ((1418 + 2509) == (3387 - 1974))) then
				if ((v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable() or v15:IsCasting())) or ((4284 - 3130) <= (756 + 32))) then
					if (v24(v97.Shockwave, not v15:IsInMeleeRange(15 - 7)) or ((3358 - 1715) > (4098 - (316 + 403)))) then
						return "shockwave single_target 111";
					end
				end
				if ((v97.Whirlwind:IsReady() and v50 and v97.StormofSwords:IsAvailable() and v97.TestofMight:IsAvailable() and (v97.ColossusSmash:CooldownRemains() > (v14:GCD() * (5 + 2)))) or ((7706 - 4903) > (1644 + 2905))) then
					if (v24(v97.Whirlwind, not v15:IsInMeleeRange(20 - 12)) or ((156 + 64) >= (974 + 2048))) then
						return "whirlwind single_target 113";
					end
				end
				if (((9777 - 6955) == (13477 - 10655)) and v97.Overpower:IsCastable() and v40 and (((v97.Overpower:Charges() == (3 - 1)) and not v97.Battlelord:IsAvailable() and (v15:DebuffUp(v97.ColossusSmashDebuff) or (v14:RagePercentage() < (2 + 23)))) or v97.Battlelord:IsAvailable())) then
					if (v24(v97.Overpower, not v101) or ((2088 - 1027) == (91 + 1766))) then
						return "overpower single_target 114";
					end
				end
				v133 = 17 - 11;
			end
			if (((2777 - (12 + 5)) > (5297 - 3933)) and (v133 == (18 - 9))) then
				if ((v97.Rend:IsReady() and v41 and v15:DebuffRefreshable(v97.RendDebuff) and not v97.CrushingForce:IsAvailable()) or ((10419 - 5517) <= (8915 - 5320))) then
					if (v24(v97.Rend, not v101) or ((782 + 3070) == (2266 - (1656 + 317)))) then
						return "rend single_target 124";
					end
				end
				break;
			end
			if ((v133 == (7 + 0)) or ((1250 + 309) == (12199 - 7611))) then
				if ((v97.ThunderClap:IsReady() and v47 and v97.Battlelord:IsAvailable() and v97.BloodandThunder:IsAvailable()) or ((22068 - 17584) == (1142 - (5 + 349)))) then
					if (((21697 - 17129) >= (5178 - (266 + 1005))) and v24(v97.ThunderClap, not v101)) then
						return "thunder_clap single_target 118";
					end
				end
				if (((822 + 424) < (11839 - 8369)) and v97.Overpower:IsCastable() and v40 and ((v15:DebuffDown(v97.ColossusSmashDebuff) and (v14:RagePercentage() < (65 - 15)) and not v97.Battlelord:IsAvailable()) or (v14:RagePercentage() < (1721 - (561 + 1135))))) then
					if (((5300 - 1232) >= (3194 - 2222)) and v24(v97.Overpower, not v101)) then
						return "overpower single_target 119";
					end
				end
				if (((1559 - (507 + 559)) < (9768 - 5875)) and v97.Whirlwind:IsReady() and v50 and v14:BuffUp(v97.MercilessBonegrinderBuff)) then
					if (v24(v97.Whirlwind, not v15:IsInRange(24 - 16)) or ((1861 - (212 + 176)) >= (4237 - (250 + 655)))) then
						return "whirlwind single_target 120";
					end
				end
				v133 = 21 - 13;
			end
			if ((v133 == (10 - 4)) or ((6337 - 2286) <= (3113 - (1869 + 87)))) then
				if (((2094 - 1490) < (4782 - (484 + 1417))) and v97.Slam:IsReady() and v45 and ((v97.CrushingForce:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff) and (v14:Rage() >= (128 - 68)) and v97.TestofMight:IsAvailable()) or v97.ImprovedSlam:IsAvailable()) and (not v97.FervorofBattle:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 == (1 - 0))))) then
					if (v24(v97.Slam, not v101) or ((1673 - (48 + 725)) == (5516 - 2139))) then
						return "slam single_target 115";
					end
				end
				if (((11962 - 7503) > (344 + 247)) and v97.Whirlwind:IsReady() and v50 and (v97.StormofSwords:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 > (2 - 1))))) then
					if (((951 + 2447) >= (698 + 1697)) and v24(v97.Whirlwind, not v15:IsInMeleeRange(861 - (152 + 701)))) then
						return "whirlwind single_target 116";
					end
				end
				if ((v97.Slam:IsReady() and v45 and (v97.CrushingForce:IsAvailable() or (not v97.CrushingForce:IsAvailable() and (v14:Rage() >= (1341 - (430 + 881))))) and (not v97.FervorofBattle:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 == (1 + 0))))) or ((3078 - (557 + 338)) >= (835 + 1989))) then
					if (((5455 - 3519) == (6779 - 4843)) and v24(v97.Slam, not v101)) then
						return "slam single_target 117";
					end
				end
				v133 = 18 - 11;
			end
			if ((v133 == (0 - 0)) or ((5633 - (499 + 302)) < (5179 - (39 + 827)))) then
				if (((11284 - 7196) > (8651 - 4777)) and (v90 < v103) and v46 and v97.SweepingStrikes:IsCastable() and (v105 > (3 - 2))) then
					if (((6650 - 2318) == (371 + 3961)) and v24(v97.SweepingStrikes, not v15:IsInMeleeRange(23 - 15))) then
						return "sweeping_strikes single_target 97";
					end
				end
				if (((640 + 3359) >= (4588 - 1688)) and v97.Execute:IsReady() and (v14:BuffUp(v97.SuddenDeathBuff))) then
					if (v24(v97.Execute, not v101) or ((2629 - (103 + 1)) > (4618 - (475 + 79)))) then
						return "execute single_target 98";
					end
				end
				if (((9449 - 5078) == (13987 - 9616)) and v97.MortalStrike:IsReady() and v39) then
					if (v24(v97.MortalStrike, not v101) or ((35 + 231) > (4389 + 597))) then
						return "mortal_strike single_target 99";
					end
				end
				v133 = 1504 - (1395 + 108);
			end
			if (((5793 - 3802) >= (2129 - (7 + 1197))) and (v133 == (4 + 4))) then
				if (((159 + 296) < (2372 - (27 + 292))) and v97.Cleave:IsReady() and v35 and v14:HasTier(84 - 55, 2 - 0) and not v97.CrushingForce:IsAvailable()) then
					if (v24(v97.Cleave, not v101) or ((3464 - 2638) == (9566 - 4715))) then
						return "cleave single_target 121";
					end
				end
				if (((348 - 165) == (322 - (43 + 96))) and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable()) then
					if (((4727 - 3568) <= (4042 - 2254)) and v24(v97.Bladestorm, not v101)) then
						return "bladestorm single_target 122";
					end
				end
				if ((v97.Cleave:IsReady() and v35) or ((2911 + 596) > (1220 + 3098))) then
					if (v24(v97.Cleave, not v101) or ((6077 - 3002) <= (1137 + 1828))) then
						return "cleave single_target 123";
					end
				end
				v133 = 16 - 7;
			end
			if (((430 + 935) <= (148 + 1863)) and (v133 == (1752 - (1414 + 337)))) then
				if ((v97.Rend:IsReady() and v41 and ((v15:DebuffRemains(v97.RendDebuff) <= v14:GCD()) or (v97.TideofBlood:IsAvailable() and (v97.Skullsplitter:CooldownRemains() <= v14:GCD()) and ((v97.ColossusSmash:CooldownRemains() <= v14:GCD()) or v15:DebuffUp(v97.ColossusSmashDebuff)) and (v15:DebuffRemains(v97.RendDebuff) < (v97.RendDebuff:BaseDuration() * (1940.85 - (1642 + 298))))))) or ((7236 - 4460) > (10284 - 6709))) then
					if (v24(v97.Rend, not v101) or ((7579 - 5025) == (1581 + 3223))) then
						return "rend single_target 100";
					end
				end
				if (((2006 + 571) == (3549 - (357 + 615))) and (v90 < v103) and v31 and ((v52 and v30) or not v52) and v97.Avatar:IsCastable() and ((v97.WarlordsTorment:IsAvailable() and (v14:RagePercentage() < (24 + 9)) and (v97.ColossusSmash:CooldownUp() or v15:DebuffUp(v97.ColossusSmashDebuff) or v14:BuffUp(v97.TestofMightBuff))) or (not v97.WarlordsTorment:IsAvailable() and (v97.ColossusSmash:CooldownUp() or v15:DebuffUp(v97.ColossusSmashDebuff))))) then
					if (v24(v97.Avatar, not v101) or ((14 - 8) >= (1619 + 270))) then
						return "avatar single_target 101";
					end
				end
				if (((1084 - 578) <= (1514 + 378)) and (v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "player") and v97.ChampionsSpear:IsCastable() and ((v97.ColossusSmash:CooldownRemains() <= v14:GCD()) or (v97.Warbreaker:CooldownRemains() <= v14:GCD()))) then
					if (v24(v99.ChampionsSpearPlayer, not v15:IsSpellInRange(v97.ChampionsSpear)) or ((137 + 1871) > (1395 + 823))) then
						return "spear_of_bastion single_target 102";
					end
				end
				v133 = 1303 - (384 + 917);
			end
			if (((1076 - (128 + 569)) <= (5690 - (1407 + 136))) and (v133 == (1889 - (687 + 1200)))) then
				if (((v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "cursor") and v97.ChampionsSpear:IsCastable() and ((v97.ColossusSmash:CooldownRemains() <= v14:GCD()) or (v97.Warbreaker:CooldownRemains() <= v14:GCD()))) or ((6224 - (556 + 1154)) <= (3549 - 2540))) then
					if (v24(v99.ChampionsSpearCursor, not v15:IsSpellInRange(v97.ChampionsSpear)) or ((3591 - (9 + 86)) == (1613 - (275 + 146)))) then
						return "spear_of_bastion single_target 102";
					end
				end
				if (((v90 < v103) and v49 and ((v57 and v30) or not v57) and v97.Warbreaker:IsCastable()) or ((34 + 174) == (3023 - (29 + 35)))) then
					if (((18955 - 14678) >= (3921 - 2608)) and v24(v97.Warbreaker, not v15:IsInRange(35 - 27))) then
						return "warbreaker single_target 103";
					end
				end
				if (((1685 + 902) < (4186 - (53 + 959))) and (v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) then
					if (v24(v97.ColossusSmash, not v101) or ((4528 - (312 + 96)) <= (3814 - 1616))) then
						return "colossus_smash single_target 104";
					end
				end
				v133 = 288 - (147 + 138);
			end
		end
	end
	local function v116()
		local v134 = 899 - (813 + 86);
		while true do
			if ((v134 == (0 + 0)) or ((2956 - 1360) == (1350 - (18 + 474)))) then
				if (((1087 + 2133) == (10509 - 7289)) and not v14:AffectingCombat()) then
					local v196 = 1086 - (860 + 226);
					while true do
						if (((303 - (121 + 182)) == v196) or ((173 + 1229) > (4860 - (988 + 252)))) then
							if (((291 + 2283) == (807 + 1767)) and v97.BattleStance:IsCastable() and v14:BuffDown(v97.BattleStance, true)) then
								if (((3768 - (49 + 1921)) < (3647 - (223 + 667))) and v24(v97.BattleStance)) then
									return "battle_stance";
								end
							end
							if ((v97.BattleShout:IsCastable() and v32 and (v14:BuffDown(v97.BattleShoutBuff, true) or v93.GroupBuffMissing(v97.BattleShoutBuff))) or ((429 - (51 + 1)) > (4481 - 1877))) then
								if (((1216 - 648) < (2036 - (146 + 979))) and v24(v97.BattleShout)) then
									return "battle_shout precombat";
								end
							end
							break;
						end
					end
				end
				if (((928 + 2357) < (4833 - (311 + 294))) and v93.TargetIsValid() and v28) then
					if (((10920 - 7004) > (1410 + 1918)) and not v14:AffectingCombat()) then
						local v200 = 1443 - (496 + 947);
						while true do
							if (((3858 - (1233 + 125)) < (1558 + 2281)) and ((0 + 0) == v200)) then
								v27 = v112();
								if (((97 + 410) == (2152 - (963 + 682))) and v27) then
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
		local v135 = 0 + 0;
		while true do
			if (((1744 - (504 + 1000)) <= (2132 + 1033)) and (v135 == (1 + 0))) then
				if (((79 + 755) >= (1187 - 382)) and v85) then
					v27 = v93.HandleIncorporeal(v97.StormBolt, v99.StormBoltMouseover, 18 + 2, true);
					if (v27 or ((2217 + 1595) < (2498 - (156 + 26)))) then
						return v27;
					end
					v27 = v93.HandleIncorporeal(v97.IntimidatingShout, v99.IntimidatingShoutMouseover, 5 + 3, true);
					if (v27 or ((4148 - 1496) <= (1697 - (149 + 15)))) then
						return v27;
					end
				end
				if (v93.TargetIsValid() or ((4558 - (890 + 70)) < (1577 - (39 + 78)))) then
					local v197 = 482 - (14 + 468);
					local v198;
					while true do
						if ((v197 == (0 - 0)) or ((11504 - 7388) < (616 + 576))) then
							if ((v34 and v97.Charge:IsCastable() and not v101) or ((2028 + 1349) <= (192 + 711))) then
								if (((1796 + 2180) >= (116 + 323)) and v24(v97.Charge, not v15:IsSpellInRange(v97.Charge))) then
									return "charge main 34";
								end
							end
							v198 = v93.HandleDPSPotion(v15:DebuffUp(v97.ColossusSmashDebuff));
							if (((7181 - 3429) == (3709 + 43)) and v198) then
								return v198;
							end
							v197 = 3 - 2;
						end
						if (((103 + 3943) > (2746 - (12 + 39))) and (v197 == (3 + 0))) then
							v27 = v115();
							if (v27 or ((10972 - 7427) == (11386 - 8189))) then
								return v27;
							end
							if (((710 + 1684) > (197 + 176)) and v20.CastAnnotated(v97.Pool, false, "WAIT")) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((10536 - 6381) <= (2819 + 1413)) and (v197 == (9 - 7))) then
							if ((v97.WreckingThrow:IsCastable() and v51 and v15:AffectingCombat() and v106()) or ((5291 - (1596 + 114)) == (9067 - 5594))) then
								if (((5708 - (164 + 549)) > (4786 - (1059 + 379))) and v24(v97.WreckingThrow, not v15:IsInRange(37 - 7))) then
									return "wrecking_throw main";
								end
							end
							if ((v29 and (v105 > (2 + 0))) or ((128 + 626) > (4116 - (145 + 247)))) then
								local v203 = 0 + 0;
								while true do
									if (((101 + 116) >= (168 - 111)) and (v203 == (0 + 0))) then
										v27 = v113();
										if (v27 or ((1784 + 286) >= (6554 - 2517))) then
											return v27;
										end
										break;
									end
								end
							end
							if (((3425 - (254 + 466)) == (3265 - (544 + 16))) and ((v97.Massacre:IsAvailable() and (v15:HealthPercentage() < (111 - 76))) or (v15:HealthPercentage() < (648 - (294 + 334))))) then
								local v204 = 253 - (236 + 17);
								while true do
									if (((27 + 34) == (48 + 13)) and (v204 == (0 - 0))) then
										v27 = v114();
										if (v27 or ((3309 - 2610) >= (668 + 628))) then
											return v27;
										end
										break;
									end
								end
							end
							v197 = 3 + 0;
						end
						if ((v197 == (795 - (413 + 381))) or ((76 + 1707) >= (7690 - 4074))) then
							if ((v101 and v91 and ((v59 and v30) or not v59) and (v90 < v103)) or ((10164 - 6251) > (6497 - (582 + 1388)))) then
								local v205 = 0 - 0;
								while true do
									if (((3133 + 1243) > (1181 - (326 + 38))) and (v205 == (0 - 0))) then
										if (((6939 - 2078) > (1444 - (47 + 573))) and v97.BloodFury:IsCastable() and v15:DebuffUp(v97.ColossusSmashDebuff)) then
											if (v24(v97.BloodFury) or ((488 + 895) >= (9050 - 6919))) then
												return "blood_fury main 39";
											end
										end
										if ((v97.Berserking:IsCastable() and (v15:DebuffRemains(v97.ColossusSmashDebuff) > (9 - 3))) or ((3540 - (1269 + 395)) >= (3033 - (76 + 416)))) then
											if (((2225 - (319 + 124)) <= (8622 - 4850)) and v24(v97.Berserking)) then
												return "berserking main 40";
											end
										end
										v205 = 1008 - (564 + 443);
									end
									if ((v205 == (2 - 1)) or ((5158 - (337 + 121)) < (2381 - 1568))) then
										if (((10656 - 7457) < (5961 - (1261 + 650))) and v97.ArcaneTorrent:IsCastable() and (v97.MortalStrike:CooldownRemains() > (1.5 + 0)) and (v14:Rage() < (79 - 29))) then
											if (v24(v97.ArcaneTorrent, not v15:IsInRange(1825 - (772 + 1045))) or ((699 + 4252) < (4574 - (102 + 42)))) then
												return "arcane_torrent main 41";
											end
										end
										if (((1940 - (1524 + 320)) == (1366 - (1049 + 221))) and v97.LightsJudgment:IsCastable() and v15:DebuffDown(v97.ColossusSmashDebuff) and not v97.MortalStrike:CooldownUp()) then
											if (v24(v97.LightsJudgment, not v15:IsSpellInRange(v97.LightsJudgment)) or ((2895 - (18 + 138)) > (9810 - 5802))) then
												return "lights_judgment main 42";
											end
										end
										v205 = 1104 - (67 + 1035);
									end
									if (((351 - (136 + 212)) == v205) or ((97 - 74) == (909 + 225))) then
										if ((v97.BagofTricks:IsCastable() and v15:DebuffDown(v97.ColossusSmashDebuff) and not v97.MortalStrike:CooldownUp()) or ((2483 + 210) >= (5715 - (240 + 1364)))) then
											if (v24(v97.BagofTricks, not v15:IsSpellInRange(v97.BagofTricks)) or ((5398 - (1050 + 32)) <= (7662 - 5516))) then
												return "bag_of_tricks main 10";
											end
										end
										break;
									end
									if (((2 + 0) == v205) or ((4601 - (331 + 724)) <= (227 + 2582))) then
										if (((5548 - (269 + 375)) > (2891 - (267 + 458))) and v97.Fireblood:IsCastable() and (v15:DebuffUp(v97.ColossusSmashDebuff))) then
											if (((34 + 75) >= (173 - 83)) and v24(v97.Fireblood)) then
												return "fireblood main 43";
											end
										end
										if (((5796 - (667 + 151)) > (4402 - (1410 + 87))) and v97.AncestralCall:IsCastable() and (v15:DebuffUp(v97.ColossusSmashDebuff))) then
											if (v24(v97.AncestralCall) or ((4923 - (1504 + 393)) <= (6162 - 3882))) then
												return "ancestral_call main 44";
											end
										end
										v205 = 7 - 4;
									end
								end
							end
							if ((v90 < v103) or ((2449 - (461 + 335)) <= (142 + 966))) then
								if (((4670 - (1730 + 31)) > (4276 - (728 + 939))) and v92 and ((v30 and v58) or not v58)) then
									local v206 = 0 - 0;
									while true do
										if (((1535 - 778) > (444 - 250)) and ((1068 - (138 + 930)) == v206)) then
											v27 = v111();
											if (v27 or ((29 + 2) >= (1093 + 305))) then
												return v27;
											end
											break;
										end
									end
								end
							end
							if (((2740 + 456) <= (19893 - 15021)) and v38 and v97.HeroicThrow:IsCastable() and not v15:IsInRange(1796 - (459 + 1307))) then
								if (((5196 - (474 + 1396)) == (5807 - 2481)) and v24(v97.HeroicThrow, not v15:IsInRange(29 + 1))) then
									return "heroic_throw main";
								end
							end
							v197 = 1 + 1;
						end
					end
				end
				break;
			end
			if (((4104 - 2671) <= (492 + 3386)) and (v135 == (0 - 0))) then
				v27 = v110();
				if (v27 or ((6903 - 5320) == (2326 - (562 + 29)))) then
					return v27;
				end
				v135 = 1 + 0;
			end
		end
	end
	local function v118()
		local v136 = 1419 - (374 + 1045);
		while true do
			if (((6 + 1) == v136) or ((9256 - 6275) == (2988 - (448 + 190)))) then
				v52 = EpicSettings.Settings['avatarWithCD'];
				v53 = EpicSettings.Settings['bladestormWithCD'];
				v54 = EpicSettings.Settings['colossusSmashWithCD'];
				v136 = 3 + 5;
			end
			if ((v136 == (1 + 1)) or ((2910 + 1556) <= (1895 - 1402))) then
				v40 = EpicSettings.Settings['useOverpower'];
				v41 = EpicSettings.Settings['useRend'];
				v43 = EpicSettings.Settings['useShockwave'];
				v136 = 8 - 5;
			end
			if ((v136 == (1499 - (1307 + 187))) or ((10100 - 7553) <= (4652 - 2665))) then
				v31 = EpicSettings.Settings['useAvatar'];
				v33 = EpicSettings.Settings['useBladestorm'];
				v36 = EpicSettings.Settings['useColossusSmash'];
				v136 = 18 - 12;
			end
			if (((3644 - (232 + 451)) > (2617 + 123)) and (v136 == (8 + 0))) then
				v55 = EpicSettings.Settings['championsSpearWithCD'];
				v56 = EpicSettings.Settings['thunderousRoarWithCD'];
				v57 = EpicSettings.Settings['warbreakerWithCD'];
				break;
			end
			if (((4260 - (510 + 54)) >= (7277 - 3665)) and (v136 == (42 - (13 + 23)))) then
				v83 = EpicSettings.Settings['useChampionsSpear'];
				v48 = EpicSettings.Settings['useThunderousRoar'];
				v49 = EpicSettings.Settings['useWarbreaker'];
				v136 = 13 - 6;
			end
			if ((v136 == (3 - 0)) or ((5396 - 2426) == (2966 - (830 + 258)))) then
				v44 = EpicSettings.Settings['useSkullsplitter'];
				v45 = EpicSettings.Settings['useSlam'];
				v46 = EpicSettings.Settings['useSweepingStrikes'];
				v136 = 14 - 10;
			end
			if ((v136 == (0 + 0)) or ((3143 + 550) < (3418 - (860 + 581)))) then
				v32 = EpicSettings.Settings['useBattleShout'];
				v34 = EpicSettings.Settings['useCharge'];
				v35 = EpicSettings.Settings['useCleave'];
				v136 = 3 - 2;
			end
			if ((v136 == (1 + 0)) or ((1171 - (237 + 4)) > (4937 - 2836))) then
				v37 = EpicSettings.Settings['useExecute'];
				v38 = EpicSettings.Settings['useHeroicThrow'];
				v39 = EpicSettings.Settings['useMortalStrike'];
				v136 = 4 - 2;
			end
			if (((7874 - 3721) > (2526 + 560)) and (v136 == (3 + 1))) then
				v47 = EpicSettings.Settings['useThunderClap'];
				v50 = EpicSettings.Settings['useWhirlwind'];
				v51 = EpicSettings.Settings['useWreckingThrow'];
				v136 = 18 - 13;
			end
		end
	end
	local function v119()
		local v137 = 0 + 0;
		while true do
			if ((v137 == (2 + 0)) or ((6080 - (85 + 1341)) <= (6910 - 2860))) then
				v66 = EpicSettings.Settings['useRallyingCry'];
				v71 = EpicSettings.Settings['useVictoryRush'];
				v72 = EpicSettings.Settings['bitterImmunityHP'] or (0 - 0);
				v78 = EpicSettings.Settings['defensiveStanceHP'] or (372 - (45 + 327));
				v137 = 5 - 2;
			end
			if ((v137 == (505 - (444 + 58))) or ((1131 + 1471) < (258 + 1238))) then
				v81 = EpicSettings.Settings['unstanceHP'] or (0 + 0);
				v73 = EpicSettings.Settings['dieByTheSwordHP'] or (0 - 0);
				v74 = EpicSettings.Settings['ignorePainHP'] or (1732 - (64 + 1668));
				v77 = EpicSettings.Settings['interveneHP'] or (1973 - (1227 + 746));
				v137 = 12 - 8;
			end
			if ((v137 == (1 - 0)) or ((1514 - (415 + 79)) > (59 + 2229))) then
				v68 = EpicSettings.Settings['useDefensiveStance'];
				v64 = EpicSettings.Settings['useDieByTheSword'];
				v65 = EpicSettings.Settings['useIgnorePain'];
				v67 = EpicSettings.Settings['useIntervene'];
				v137 = 493 - (142 + 349);
			end
			if (((141 + 187) == (450 - 122)) and (v137 == (2 + 2))) then
				v76 = EpicSettings.Settings['rallyingCryGroup'] or (0 + 0);
				v75 = EpicSettings.Settings['rallyingCryHP'] or (0 - 0);
				v82 = EpicSettings.Settings['victoryRushHP'] or (1864 - (1710 + 154));
				v84 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
			if (((1829 - (200 + 118)) < (1509 + 2299)) and (v137 == (0 - 0))) then
				v60 = EpicSettings.Settings['usePummel'];
				v61 = EpicSettings.Settings['useStormBolt'];
				v62 = EpicSettings.Settings['useIntimidatingShout'];
				v63 = EpicSettings.Settings['useBitterImmunity'];
				v137 = 1 - 0;
			end
		end
	end
	local function v120()
		local v138 = 0 + 0;
		while true do
			if ((v138 == (1 + 0)) or ((1348 + 1162) > (786 + 4133))) then
				v89 = EpicSettings.Settings['InterruptThreshold'];
				v92 = EpicSettings.Settings['useTrinkets'];
				v91 = EpicSettings.Settings['useRacials'];
				v138 = 4 - 2;
			end
			if (((6013 - (363 + 887)) == (8317 - 3554)) and (v138 == (9 - 7))) then
				v58 = EpicSettings.Settings['trinketsWithCD'];
				v59 = EpicSettings.Settings['racialsWithCD'];
				v69 = EpicSettings.Settings['useHealthstone'];
				v138 = 1 + 2;
			end
			if (((9680 - 5543) > (1263 + 585)) and (v138 == (1668 - (674 + 990)))) then
				v86 = EpicSettings.Settings['HealingPotionName'] or "";
				v85 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((699 + 1737) <= (1283 + 1851)) and (v138 == (0 - 0))) then
				v90 = EpicSettings.Settings['fightRemainsCheck'] or (1055 - (507 + 548));
				v87 = EpicSettings.Settings['InterruptWithStun'];
				v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v138 = 838 - (289 + 548);
			end
			if (((5541 - (821 + 997)) == (3978 - (195 + 60))) and (v138 == (1 + 2))) then
				v70 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (1501 - (251 + 1250));
				v80 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v138 = 3 + 1;
			end
		end
	end
	local function v121()
		local v139 = 1032 - (809 + 223);
		while true do
			if (((1 - 0) == v139) or ((12150 - 8104) >= (14270 - 9954))) then
				v28 = EpicSettings.Toggles['ooc'];
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				v139 = 2 + 0;
			end
			if ((v139 == (2 + 1)) or ((2625 - (14 + 603)) < (2058 - (118 + 11)))) then
				if (((386 + 1998) > (1479 + 296)) and (v93.TargetIsValid() or v14:AffectingCombat())) then
					local v199 = 0 - 0;
					while true do
						if ((v199 == (950 - (551 + 398))) or ((2872 + 1671) <= (1558 + 2818))) then
							if (((592 + 136) == (2707 - 1979)) and (v103 == (25601 - 14490))) then
								v103 = v10.FightRemains(v104, false);
							end
							break;
						end
						if ((v199 == (0 + 0)) or ((4271 - 3195) > (1290 + 3381))) then
							v102 = v10.BossFightRemains(nil, true);
							v103 = v102;
							v199 = 90 - (40 + 49);
						end
					end
				end
				if (((7048 - 5197) >= (868 - (99 + 391))) and not v14:IsChanneling()) then
					if (v14:AffectingCombat() or ((1612 + 336) >= (15280 - 11804))) then
						local v201 = 0 - 0;
						while true do
							if (((4670 + 124) >= (2191 - 1358)) and (v201 == (1604 - (1032 + 572)))) then
								v27 = v117();
								if (((4507 - (203 + 214)) == (5907 - (568 + 1249))) and v27) then
									return v27;
								end
								break;
							end
						end
					else
						local v202 = 0 + 0;
						while true do
							if ((v202 == (0 - 0)) or ((14515 - 10757) == (3804 - (913 + 393)))) then
								v27 = v116();
								if (v27 or ((7548 - 4875) < (2225 - 650))) then
									return v27;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v139 == (410 - (269 + 141))) or ((8276 - 4555) <= (3436 - (362 + 1619)))) then
				v119();
				v118();
				v120();
				v139 = 1626 - (950 + 675);
			end
			if (((361 + 573) < (3449 - (216 + 963))) and ((1289 - (485 + 802)) == v139)) then
				if (v14:IsDeadOrGhost() or ((2171 - (432 + 127)) == (2328 - (1065 + 8)))) then
					return v27;
				end
				if (v29 or ((2418 + 1934) < (5807 - (635 + 966)))) then
					v104 = v14:GetEnemiesInMeleeRange(6 + 2);
					v105 = #v104;
				else
					v105 = 43 - (5 + 37);
				end
				v101 = v15:IsInMeleeRange(19 - 11);
				v139 = 2 + 1;
			end
		end
	end
	local function v122()
		v20.Print("Arms Warrior by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(112 - 41, v121, v122);
end;
return v0["Epix_Warrior_Arms.lua"]();

