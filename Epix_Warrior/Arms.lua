local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1027 - (834 + 192))) or ((159 + 2333) <= (86 + 249))) then
			return v6(...);
		end
		if (((93 + 4229) >= (3968 - 1406)) and (v5 == (304 - (300 + 4)))) then
			v6 = v0[v4];
			if (not v6 or ((972 + 2665) >= (9868 - 6098))) then
				return v1(v4, ...);
			end
			v5 = 363 - (112 + 250);
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
	local v93;
	local v94 = v10.Commons.Everyone;
	local v95 = v14:GetEquipment();
	local v96 = (v95[6 + 7] and v19(v95[32 - 19])) or v19(0 + 0);
	local v97 = (v95[8 + 6] and v19(v95[11 + 3])) or v19(0 + 0);
	local v98 = v18.Warrior.Arms;
	local v99 = v19.Warrior.Arms;
	local v100 = v23.Warrior.Arms;
	local v101 = {};
	local v102;
	local v103 = 8255 + 2856;
	local v104 = 12525 - (1001 + 413);
	v10:RegisterForEvent(function()
		local v124 = 0 - 0;
		while true do
			if ((v124 == (882 - (244 + 638))) or ((3072 - (627 + 66)) > (13640 - 9062))) then
				v103 = 11713 - (512 + 90);
				v104 = 13017 - (1665 + 241);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v95 = v14:GetEquipment();
		v96 = (v95[730 - (373 + 344)] and v19(v95[6 + 7])) or v19(0 + 0);
		v97 = (v95[36 - 22] and v19(v95[23 - 9])) or v19(1099 - (35 + 1064));
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v105;
	local v106;
	local function v107()
		local v125 = 0 + 0;
		local v126;
		while true do
			if ((v125 == (0 - 0)) or ((2 + 481) > (1979 - (298 + 938)))) then
				v126 = UnitGetTotalAbsorbs(v15:ID());
				if (((3713 - (233 + 1026)) > (2244 - (636 + 1030))) and (v126 > (0 + 0))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v108(v127)
		return (v127:HealthPercentage() > (20 + 0)) or (v98.Massacre:IsAvailable() and (v127:HealthPercentage() < (11 + 24)));
	end
	local function v109(v128)
		return (v128:DebuffStack(v98.ExecutionersPrecisionDebuff) == (1 + 1)) or (v128:DebuffRemains(v98.DeepWoundsDebuff) <= v14:GCD()) or (v98.Dreadnaught:IsAvailable() and v98.Battlelord:IsAvailable() and (v106 <= (223 - (55 + 166))));
	end
	local function v110(v129)
		return v14:BuffUp(v98.SuddenDeathBuff) or ((v106 <= (1 + 1)) and ((v129:HealthPercentage() < (3 + 17)) or (v98.Massacre:IsAvailable() and (v129:HealthPercentage() < (133 - 98))))) or v14:BuffUp(v98.SweepingStrikes);
	end
	local function v111()
		local v130 = 297 - (36 + 261);
		while true do
			if (((1626 - 696) < (5826 - (34 + 1334))) and (v130 == (2 + 1))) then
				if (((515 + 147) <= (2255 - (1035 + 248))) and v98.BattleStance:IsCastable() and v14:BuffDown(v98.BattleStance, true) and v69 and (v14:HealthPercentage() > v82)) then
					if (((4391 - (20 + 1)) == (2277 + 2093)) and v24(v98.BattleStance)) then
						return "battle_stance after defensive stance defensive";
					end
				end
				if ((v99.Healthstone:IsReady() and v70 and (v14:HealthPercentage() <= v80)) or ((5081 - (134 + 185)) <= (1994 - (549 + 584)))) then
					if (v24(v100.Healthstone) or ((2097 - (314 + 371)) == (14638 - 10374))) then
						return "healthstone defensive 3";
					end
				end
				v130 = 972 - (478 + 490);
			end
			if ((v130 == (3 + 1)) or ((4340 - (786 + 386)) < (6973 - 4820))) then
				if ((v71 and (v14:HealthPercentage() <= v81)) or ((6355 - (1055 + 324)) < (2672 - (1093 + 247)))) then
					local v193 = 0 + 0;
					while true do
						if (((487 + 4141) == (18373 - 13745)) and (v193 == (0 - 0))) then
							if ((v87 == "Refreshing Healing Potion") or ((153 - 99) == (992 - 597))) then
								if (((30 + 52) == (315 - 233)) and v99.RefreshingHealingPotion:IsReady()) then
									if (v24(v100.RefreshingHealingPotion) or ((2002 - 1421) < (213 + 69))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v87 == "Dreamwalker's Healing Potion") or ((11786 - 7177) < (3183 - (364 + 324)))) then
								if (((3157 - 2005) == (2764 - 1612)) and v99.DreamwalkersHealingPotion:IsReady()) then
									if (((629 + 1267) <= (14318 - 10896)) and v24(v100.RefreshingHealingPotion)) then
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
			if ((v130 == (1 - 0)) or ((3006 - 2016) > (2888 - (1249 + 19)))) then
				if ((v98.IgnorePain:IsCastable() and v66 and (v14:HealthPercentage() <= v75)) or ((792 + 85) > (18275 - 13580))) then
					if (((3777 - (686 + 400)) >= (1453 + 398)) and v24(v98.IgnorePain, nil, nil, true)) then
						return "ignore_pain defensive";
					end
				end
				if ((v98.RallyingCry:IsCastable() and v67 and v14:BuffDown(v98.AspectsFavorBuff) and v14:BuffDown(v98.RallyingCry) and (((v14:HealthPercentage() <= v76) and v94.IsSoloMode()) or v94.AreUnitsBelowHealthPercentage(v76, v77))) or ((3214 - (73 + 156)) >= (23 + 4833))) then
					if (((5087 - (721 + 90)) >= (14 + 1181)) and v24(v98.RallyingCry)) then
						return "rallying_cry defensive";
					end
				end
				v130 = 6 - 4;
			end
			if (((3702 - (224 + 246)) <= (7597 - 2907)) and (v130 == (0 - 0))) then
				if ((v98.BitterImmunity:IsReady() and v64 and (v14:HealthPercentage() <= v73)) or ((163 + 733) >= (75 + 3071))) then
					if (((2249 + 812) >= (5880 - 2922)) and v24(v98.BitterImmunity)) then
						return "bitter_immunity defensive";
					end
				end
				if (((10605 - 7418) >= (1157 - (203 + 310))) and v98.DieByTheSword:IsCastable() and v65 and (v14:HealthPercentage() <= v74)) then
					if (((2637 - (1238 + 755)) <= (50 + 654)) and v24(v98.DieByTheSword)) then
						return "die_by_the_sword defensive";
					end
				end
				v130 = 1535 - (709 + 825);
			end
			if (((1765 - 807) > (1379 - 432)) and (v130 == (866 - (196 + 668)))) then
				if (((17735 - 13243) >= (5497 - 2843)) and v98.Intervene:IsCastable() and v68 and (v17:HealthPercentage() <= v78) and (v17:Name() ~= v14:Name())) then
					if (((4275 - (171 + 662)) >= (1596 - (4 + 89))) and v24(v100.InterveneFocus)) then
						return "intervene defensive";
					end
				end
				if ((v98.DefensiveStance:IsCastable() and v14:BuffDown(v98.DefensiveStance, true) and v69 and (v14:HealthPercentage() <= v79)) or ((11110 - 7940) <= (534 + 930))) then
					if (v24(v98.DefensiveStance) or ((21069 - 16272) == (1721 + 2667))) then
						return "defensive_stance defensive";
					end
				end
				v130 = 1489 - (35 + 1451);
			end
		end
	end
	local function v112()
		local v131 = 1453 - (28 + 1425);
		while true do
			if (((2544 - (941 + 1052)) <= (653 + 28)) and (v131 == (1514 - (822 + 692)))) then
				v27 = v94.HandleTopTrinket(v101, v30, 57 - 17, nil);
				if (((1544 + 1733) > (704 - (45 + 252))) and v27) then
					return v27;
				end
				v131 = 1 + 0;
			end
			if (((1616 + 3079) >= (3443 - 2028)) and ((434 - (114 + 319)) == v131)) then
				v27 = v94.HandleBottomTrinket(v101, v30, 57 - 17, nil);
				if (v27 or ((4115 - 903) <= (602 + 342))) then
					return v27;
				end
				break;
			end
		end
	end
	local function v113()
		local v132 = 0 - 0;
		while true do
			if ((v132 == (0 - 0)) or ((5059 - (556 + 1407)) <= (3004 - (741 + 465)))) then
				if (((4002 - (170 + 295)) == (1864 + 1673)) and v102) then
					local v194 = 0 + 0;
					while true do
						if (((9446 - 5609) >= (1302 + 268)) and (v194 == (1 + 0))) then
							if (((v91 < v104) and v98.Warbreaker:IsCastable() and v50 and ((v58 and v30) or not v58)) or ((1671 + 1279) == (5042 - (957 + 273)))) then
								if (((1264 + 3459) >= (928 + 1390)) and v24(v98.Warbreaker)) then
									return "warbreaker precombat";
								end
							end
							if ((v98.Overpower:IsCastable() and v41) or ((7723 - 5696) > (7515 - 4663))) then
								if (v24(v98.Overpower) or ((3469 - 2333) > (21376 - 17059))) then
									return "overpower precombat";
								end
							end
							break;
						end
						if (((6528 - (389 + 1391)) == (2979 + 1769)) and (v194 == (0 + 0))) then
							if (((8505 - 4769) <= (5691 - (783 + 168))) and v98.Skullsplitter:IsCastable() and v45) then
								if (v24(v98.Skullsplitter) or ((11377 - 7987) <= (3010 + 50))) then
									return "skullsplitter precombat";
								end
							end
							if (((v91 < v104) and v98.ColossusSmash:IsCastable() and v37 and ((v55 and v30) or not v55)) or ((1310 - (309 + 2)) > (8269 - 5576))) then
								if (((1675 - (1090 + 122)) < (195 + 406)) and v24(v98.ColossusSmash)) then
									return "colossus_smash precombat";
								end
							end
							v194 = 3 - 2;
						end
					end
				end
				if ((v35 and v98.Charge:IsCastable()) or ((1494 + 689) < (1805 - (628 + 490)))) then
					if (((816 + 3733) == (11262 - 6713)) and v24(v98.Charge)) then
						return "charge precombat";
					end
				end
				break;
			end
		end
	end
	local function v114()
		local v133 = 0 - 0;
		while true do
			if (((5446 - (431 + 343)) == (9435 - 4763)) and (v133 == (5 - 3))) then
				if (((v91 < v104) and v49 and ((v57 and v30) or not v57) and v98.ThunderousRoar:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)) or ((v106 > (1 + 0)) and (v15:DebuffRemains(v98.DeepWoundsDebuff) > (0 + 0))))) or ((5363 - (556 + 1139)) < (410 - (6 + 9)))) then
					if (v24(v98.ThunderousRoar, not v15:IsInMeleeRange(2 + 6)) or ((2135 + 2031) == (624 - (28 + 141)))) then
						return "thunderous_roar hac 75";
					end
				end
				if (((v91 < v104) and v84 and ((v56 and v30) or not v56) and (v85 == "player") and v98.ChampionsSpear:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) or ((1724 + 2725) == (3286 - 623))) then
					if (v24(v100.ChampionsSpearPlayer, not v15:IsSpellInRange(v98.ChampionsSpear)) or ((3030 + 1247) < (4306 - (486 + 831)))) then
						return "spear_of_bastion hac 76";
					end
				end
				if (((v91 < v104) and v84 and ((v56 and v30) or not v56) and (v85 == "cursor") and v98.ChampionsSpear:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) or ((2263 - 1393) >= (14606 - 10457))) then
					if (((418 + 1794) < (10064 - 6881)) and v24(v100.ChampionsSpearCursor, not v15:IsSpellInRange(v98.ChampionsSpear))) then
						return "spear_of_bastion hac 76";
					end
				end
				if (((5909 - (668 + 595)) > (2693 + 299)) and (v91 < v104) and v34 and ((v54 and v30) or not v54) and v98.Bladestorm:IsCastable() and v98.Unhinged:IsAvailable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) then
					if (((290 + 1144) < (8470 - 5364)) and v24(v98.Bladestorm, not v102)) then
						return "bladestorm hac 77";
					end
				end
				v133 = 293 - (23 + 267);
			end
			if (((2730 - (1129 + 815)) < (3410 - (371 + 16))) and (v133 == (1756 - (1326 + 424)))) then
				if ((v98.Overpower:IsCastable() and v41 and (((v98.Overpower:Charges() == (3 - 1)) and (not v98.TestofMight:IsAvailable() or (v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)) or v98.Battlelord:IsAvailable())) or (v14:Rage() < (255 - 185)))) or ((2560 - (88 + 30)) < (845 - (720 + 51)))) then
					if (((10088 - 5553) == (6311 - (421 + 1355))) and v24(v98.Overpower, not v102)) then
						return "overpower hac 89";
					end
				end
				if ((v98.ThunderClap:IsReady() and v48 and (v106 > (2 - 0))) or ((1479 + 1530) <= (3188 - (286 + 797)))) then
					if (((6689 - 4859) < (6076 - 2407)) and v24(v98.ThunderClap, not v102)) then
						return "thunder_clap hac 90";
					end
				end
				if ((v98.MortalStrike:IsReady() and v40) or ((1869 - (397 + 42)) >= (1129 + 2483))) then
					if (((3483 - (24 + 776)) >= (3789 - 1329)) and v24(v98.MortalStrike, not v102)) then
						return "mortal_strike hac 91";
					end
				end
				if ((v98.Rend:IsReady() and v42 and (v106 == (786 - (222 + 563))) and v15:DebuffRefreshable(v98.RendDebuff)) or ((3974 - 2170) >= (2358 + 917))) then
					if (v24(v98.Rend, not v102) or ((1607 - (23 + 167)) > (5427 - (690 + 1108)))) then
						return "rend hac 92";
					end
				end
				v133 = 3 + 4;
			end
			if (((3956 + 839) > (1250 - (40 + 808))) and (v133 == (0 + 0))) then
				if (((18404 - 13591) > (3408 + 157)) and v98.Execute:IsReady() and v38 and v14:BuffUp(v98.JuggernautBuff) and (v14:BuffRemains(v98.JuggernautBuff) < v14:GCD())) then
					if (((2070 + 1842) == (2146 + 1766)) and v24(v98.Execute, not v102)) then
						return "execute hac 67";
					end
				end
				if (((3392 - (47 + 524)) <= (3131 + 1693)) and v98.ThunderClap:IsReady() and v48 and (v106 > (5 - 3)) and v98.BloodandThunder:IsAvailable() and v98.Rend:IsAvailable() and v15:DebuffRefreshable(v98.RendDebuff)) then
					if (((2598 - 860) <= (5006 - 2811)) and v24(v98.ThunderClap, not v102)) then
						return "thunder_clap hac 68";
					end
				end
				if (((1767 - (1165 + 561)) <= (90 + 2928)) and v98.SweepingStrikes:IsCastable() and v47 and (v106 >= (6 - 4)) and ((v98.Bladestorm:CooldownRemains() > (6 + 9)) or not v98.Bladestorm:IsAvailable())) then
					if (((2624 - (341 + 138)) <= (1108 + 2996)) and v24(v98.SweepingStrikes, not v15:IsInMeleeRange(16 - 8))) then
						return "sweeping_strikes hac 68";
					end
				end
				if (((3015 - (89 + 237)) < (15586 - 10741)) and ((v98.Rend:IsReady() and v42 and (v106 == (1 - 0)) and ((v15:HealthPercentage() > (901 - (581 + 300))) or (v98.Massacre:IsAvailable() and (v15:HealthPercentage() < (1255 - (855 + 365)))))) or (v98.TideofBlood:IsAvailable() and (v98.Skullsplitter:CooldownRemains() <= v14:GCD()) and ((v98.ColossusSmash:CooldownRemains() < v14:GCD()) or v15:DebuffUp(v98.ColossusSmashDebuff)) and (v15:DebuffRemains(v98.RendDebuff) < ((49 - 28) * (0.85 + 0)))))) then
					if (v24(v98.Rend, not v102) or ((3557 - (1030 + 205)) > (2462 + 160))) then
						return "rend hac 70";
					end
				end
				v133 = 1 + 0;
			end
			if ((v133 == (290 - (156 + 130))) or ((10301 - 5767) == (3508 - 1426))) then
				if ((v98.MortalStrike:IsReady() and v40 and v14:BuffUp(v98.SweepingStrikes) and (v14:BuffStack(v98.CrushingAdvanceBuff) == (5 - 2))) or ((414 + 1157) > (1089 + 778))) then
					if (v24(v98.MortalStrike, not v102) or ((2723 - (10 + 59)) >= (848 + 2148))) then
						return "mortal_strike hac 81.5";
					end
				end
				if (((19590 - 15612) > (3267 - (671 + 492))) and v98.Overpower:IsCastable() and v41 and v14:BuffUp(v98.SweepingStrikes) and v98.Dreadnaught:IsAvailable()) then
					if (((2385 + 610) > (2756 - (369 + 846))) and v24(v98.Overpower, not v102)) then
						return "overpower hac 82";
					end
				end
				if (((861 + 2388) > (814 + 139)) and v98.MortalStrike:IsReady() and v40) then
					local v195 = 1945 - (1036 + 909);
					while true do
						if ((v195 == (0 + 0)) or ((5494 - 2221) > (4776 - (11 + 192)))) then
							if (v94.CastCycle(v98.MortalStrike, v105, v109, not v102) or ((1593 + 1558) < (1459 - (135 + 40)))) then
								return "mortal_strike hac 83";
							end
							if (v24(v98.MortalStrike, not v102) or ((4482 - 2632) == (922 + 607))) then
								return "mortal_strike hac 83";
							end
							break;
						end
					end
				end
				if (((1808 - 987) < (3182 - 1059)) and v98.Execute:IsReady() and v38 and (v14:BuffUp(v98.SuddenDeathBuff) or ((v106 <= (178 - (50 + 126))) and ((v15:HealthPercentage() < (55 - 35)) or (v98.Massacre:IsAvailable() and (v15:HealthPercentage() < (8 + 27))))) or v14:BuffUp(v98.SweepingStrikes))) then
					local v196 = 1413 - (1233 + 180);
					while true do
						if (((1871 - (522 + 447)) < (3746 - (107 + 1314))) and (v196 == (0 + 0))) then
							if (((2614 - 1756) <= (1259 + 1703)) and v94.CastCycle(v98.Execute, v105, v110, not v102)) then
								return "execute hac 84";
							end
							if (v24(v98.Execute, not v102) or ((7835 - 3889) < (5096 - 3808))) then
								return "execute hac 84";
							end
							break;
						end
					end
				end
				v133 = 1915 - (716 + 1194);
			end
			if (((1 + 2) == v133) or ((348 + 2894) == (1070 - (74 + 429)))) then
				if (((v91 < v104) and v34 and ((v54 and v30) or not v54) and v98.Bladestorm:IsCastable() and (((v106 > (1 - 0)) and (v14:BuffUp(v98.TestofMightBuff) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) or ((v106 > (1 + 0)) and (v15:DebuffRemains(v98.DeepWoundsDebuff) > (0 - 0))))) or ((600 + 247) >= (3893 - 2630))) then
					if (v24(v98.Bladestorm, not v102) or ((5570 - 3317) == (2284 - (279 + 154)))) then
						return "bladestorm hac 78";
					end
				end
				if ((v98.Cleave:IsReady() and v36 and ((v106 > (780 - (454 + 324))) or (not v98.Battlelord:IsAvailable() and v14:BuffUp(v98.MercilessBonegrinderBuff) and (v98.MortalStrike:CooldownRemains() > v14:GCD())))) or ((1642 + 445) > (2389 - (12 + 5)))) then
					if (v24(v98.Cleave, not v102) or ((2397 + 2048) < (10571 - 6422))) then
						return "cleave hac 79";
					end
				end
				if ((v98.Whirlwind:IsReady() and v51 and ((v106 > (1 + 1)) or (v98.StormofSwords:IsAvailable() and (v14:BuffUp(v98.MercilessBonegrinderBuff) or v14:BuffUp(v98.HurricaneBuff))))) or ((2911 - (277 + 816)) == (363 - 278))) then
					if (((1813 - (1058 + 125)) < (399 + 1728)) and v24(v98.Whirlwind, not v15:IsInMeleeRange(983 - (815 + 160)))) then
						return "whirlwind hac 80";
					end
				end
				if ((v98.Skullsplitter:IsCastable() and v45 and ((v14:Rage() < (171 - 131)) or (v98.TideofBlood:IsAvailable() and (v15:DebuffRemains(v98.RendDebuff) > (0 - 0)) and ((v14:BuffUp(v98.SweepingStrikes) and (v106 > (1 + 1))) or v15:DebuffUp(v98.ColossusSmashDebuff) or v14:BuffUp(v98.TestofMightBuff))))) or ((5665 - 3727) == (4412 - (41 + 1857)))) then
					if (((6148 - (1222 + 671)) >= (142 - 87)) and v24(v98.Skullsplitter, not v15:IsInMeleeRange(11 - 3))) then
						return "sweeping_strikes execute 81";
					end
				end
				v133 = 1186 - (229 + 953);
			end
			if (((4773 - (1111 + 663)) > (2735 - (874 + 705))) and ((1 + 4) == v133)) then
				if (((1604 + 746) > (2400 - 1245)) and (v91 < v104) and v49 and ((v57 and v30) or not v57) and v98.ThunderousRoar:IsCastable()) then
					if (((114 + 3915) <= (5532 - (642 + 37))) and v24(v98.ThunderousRoar, not v15:IsInMeleeRange(2 + 6))) then
						return "thunderous_roar hac 85";
					end
				end
				if ((v98.Shockwave:IsCastable() and v44 and (v106 > (1 + 1)) and (v98.SonicBoom:IsAvailable() or v15:IsCasting())) or ((1295 - 779) > (3888 - (233 + 221)))) then
					if (((9355 - 5309) >= (2670 + 363)) and v24(v98.Shockwave, not v15:IsInMeleeRange(1549 - (718 + 823)))) then
						return "shockwave hac 86";
					end
				end
				if ((v98.Overpower:IsCastable() and v41 and (v106 == (1 + 0)) and (((v98.Overpower:Charges() == (807 - (266 + 539))) and not v98.Battlelord:IsAvailable() and (v15:Debuffdown(v98.ColossusSmashDebuff) or (v14:RagePercentage() < (70 - 45)))) or v98.Battlelord:IsAvailable())) or ((3944 - (636 + 589)) <= (3434 - 1987))) then
					if (v24(v98.Overpower, not v102) or ((8526 - 4392) < (3112 + 814))) then
						return "overpower hac 87";
					end
				end
				if ((v98.Slam:IsReady() and v46 and (v106 == (1 + 0)) and not v98.Battlelord:IsAvailable() and (v14:RagePercentage() > (1085 - (657 + 358)))) or ((433 - 269) >= (6345 - 3560))) then
					if (v24(v98.Slam, not v102) or ((1712 - (1151 + 36)) == (2037 + 72))) then
						return "slam hac 88";
					end
				end
				v133 = 2 + 4;
			end
			if (((98 - 65) == (1865 - (1552 + 280))) and (v133 == (835 - (64 + 770)))) then
				if (((2074 + 980) <= (9114 - 5099)) and (v91 < v104) and v32 and ((v53 and v30) or not v53) and v98.Avatar:IsCastable()) then
					if (((333 + 1538) < (4625 - (157 + 1086))) and v24(v98.Avatar, not v102)) then
						return "avatar hac 71";
					end
				end
				if (((2587 - 1294) <= (9486 - 7320)) and (v91 < v104) and v98.Warbreaker:IsCastable() and v50 and ((v58 and v30) or not v58) and (v106 > (1 - 0))) then
					if (v24(v98.Warbreaker, not v102) or ((3519 - 940) < (942 - (599 + 220)))) then
						return "warbreaker hac 72";
					end
				end
				if (((v91 < v104) and v37 and ((v55 and v30) or not v55) and v98.ColossusSmash:IsCastable()) or ((1684 - 838) >= (4299 - (1813 + 118)))) then
					local v197 = 0 + 0;
					while true do
						if (((1217 - (841 + 376)) == v197) or ((5621 - 1609) <= (781 + 2577))) then
							if (((4077 - 2583) <= (3864 - (464 + 395))) and v94.CastCycle(v98.ColossusSmash, v105, v108, not v102)) then
								return "colossus_smash hac 73";
							end
							if (v24(v98.ColossusSmash, not v102) or ((7984 - 4873) == (1025 + 1109))) then
								return "colossus_smash hac 73";
							end
							break;
						end
					end
				end
				if (((3192 - (467 + 370)) == (4866 - 2511)) and (v91 < v104) and v37 and ((v55 and v30) or not v55) and v98.ColossusSmash:IsCastable()) then
					if (v24(v98.ColossusSmash, not v102) or ((432 + 156) <= (1480 - 1048))) then
						return "colossus_smash hac 74";
					end
				end
				v133 = 1 + 1;
			end
			if (((11160 - 6363) >= (4415 - (150 + 370))) and (v133 == (1290 - (74 + 1208)))) then
				if (((8797 - 5220) == (16964 - 13387)) and v98.Shockwave:IsCastable() and v44 and (v98.SonicBoom:IsAvailable())) then
					if (((2700 + 1094) > (4083 - (14 + 376))) and v24(v98.Shockwave, not v15:IsInMeleeRange(13 - 5))) then
						return "shockwave hac 97";
					end
				end
				if ((v30 and (v91 < v104) and v34 and ((v54 and v30) or not v54) and v98.Bladestorm:IsCastable()) or ((826 + 449) == (3602 + 498))) then
					if (v24(v98.Bladestorm, not v102) or ((1518 + 73) >= (10489 - 6909))) then
						return "bladestorm hac 98";
					end
				end
				break;
			end
			if (((740 + 243) <= (1886 - (23 + 55))) and (v133 == (16 - 9))) then
				if ((v98.Whirlwind:IsReady() and v51 and (v98.StormofSwords:IsAvailable() or (v98.FervorofBattle:IsAvailable() and (v106 > (1 + 0))))) or ((1931 + 219) <= (1855 - 658))) then
					if (((1186 + 2583) >= (2074 - (652 + 249))) and v24(v98.Whirlwind, not v15:IsInMeleeRange(21 - 13))) then
						return "whirlwind hac 93";
					end
				end
				if (((3353 - (708 + 1160)) == (4030 - 2545)) and v98.Cleave:IsReady() and v36 and not v98.CrushingForce:IsAvailable()) then
					if (v24(v98.Cleave, not v102) or ((6043 - 2728) <= (2809 - (10 + 17)))) then
						return "cleave hac 94";
					end
				end
				if ((v98.IgnorePain:IsReady() and v66 and v98.Battlelord:IsAvailable() and v98.AngerManagement:IsAvailable() and (v14:Rage() > (7 + 23)) and ((v15:HealthPercentage() < (1752 - (1400 + 332))) or (v98.Massacre:IsAvailable() and (v15:HealthPercentage() < (67 - 32))))) or ((2784 - (242 + 1666)) >= (1269 + 1695))) then
					if (v24(v98.IgnorePain, not v102) or ((819 + 1413) > (2129 + 368))) then
						return "ignore_pain hac 95";
					end
				end
				if ((v98.Slam:IsReady() and v46 and v98.CrushingForce:IsAvailable() and (v14:Rage() > (970 - (850 + 90))) and ((v98.FervorofBattle:IsAvailable() and (v106 == (1 - 0))) or not v98.FervorofBattle:IsAvailable())) or ((3500 - (360 + 1030)) <= (294 + 38))) then
					if (((10403 - 6717) > (4363 - 1191)) and v24(v98.Slam, not v102)) then
						return "slam hac 96";
					end
				end
				v133 = 1669 - (909 + 752);
			end
		end
	end
	local function v115()
		local v134 = 1223 - (109 + 1114);
		while true do
			if ((v134 == (5 - 2)) or ((1742 + 2732) < (1062 - (6 + 236)))) then
				if (((2696 + 1583) >= (2320 + 562)) and v98.Overpower:IsCastable() and v41 and (v14:Rage() < (94 - 54)) and (v14:BuffStack(v98.MartialProwessBuff) < (3 - 1))) then
					if (v24(v98.Overpower, not v102) or ((3162 - (1076 + 57)) >= (580 + 2941))) then
						return "overpower execute 60";
					end
				end
				if ((v98.Execute:IsReady() and v38) or ((2726 - (579 + 110)) >= (367 + 4275))) then
					if (((1521 + 199) < (2366 + 2092)) and v24(v98.Execute, not v102)) then
						return "execute execute 62";
					end
				end
				if ((v98.Shockwave:IsCastable() and v44 and (v98.SonicBoom:IsAvailable() or v15:IsCasting())) or ((843 - (174 + 233)) > (8438 - 5417))) then
					if (((1251 - 538) <= (377 + 470)) and v24(v98.Shockwave, not v15:IsInMeleeRange(1182 - (663 + 511)))) then
						return "shockwave execute 63";
					end
				end
				if (((1922 + 232) <= (876 + 3155)) and v98.Overpower:IsCastable() and v41) then
					if (((14228 - 9613) == (2795 + 1820)) and v24(v98.Overpower, not v102)) then
						return "overpower execute 64";
					end
				end
				v134 = 9 - 5;
			end
			if (((2 - 1) == v134) or ((1809 + 1981) == (973 - 473))) then
				if (((64 + 25) < (21 + 200)) and (v91 < v104) and v37 and ((v55 and v30) or not v55) and v98.ColossusSmash:IsCastable()) then
					if (((2776 - (478 + 244)) >= (1938 - (440 + 77))) and v24(v98.ColossusSmash, not v102)) then
						return "colossus_smash execute 55";
					end
				end
				if (((315 + 377) < (11192 - 8134)) and v98.Execute:IsReady() and v38 and v14:BuffUp(v98.SuddenDeathBuff) and (v15:DebuffRemains(v98.DeepWoundsDebuff) > (1556 - (655 + 901)))) then
					if (v24(v98.Execute, not v102) or ((604 + 2650) == (1268 + 387))) then
						return "execute execute 56";
					end
				end
				if ((v98.Skullsplitter:IsCastable() and v45 and ((v98.TestofMight:IsAvailable() and (v14:RagePercentage() <= (21 + 9))) or (not v98.TestofMight:IsAvailable() and (v15:DebuffUp(v98.ColossusSmashDebuff) or (v98.ColossusSmash:CooldownRemains() > (20 - 15))) and (v14:RagePercentage() <= (1475 - (695 + 750)))))) or ((4425 - 3129) == (7577 - 2667))) then
					if (((13545 - 10177) == (3719 - (285 + 66))) and v24(v98.Skullsplitter, not v15:IsInMeleeRange(18 - 10))) then
						return "skullsplitter execute 57";
					end
				end
				if (((3953 - (682 + 628)) < (615 + 3200)) and (v91 < v104) and v49 and ((v57 and v30) or not v57) and v98.ThunderousRoar:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) then
					if (((2212 - (176 + 123)) > (207 + 286)) and v24(v98.ThunderousRoar, not v15:IsInMeleeRange(6 + 2))) then
						return "thunderous_roar execute 57";
					end
				end
				v134 = 271 - (239 + 30);
			end
			if (((1293 + 3462) > (3295 + 133)) and (v134 == (0 - 0))) then
				if (((4308 - 2927) <= (2684 - (306 + 9))) and (v91 < v104) and v47 and v98.SweepingStrikes:IsCastable() and (v106 > (3 - 2))) then
					if (v24(v98.SweepingStrikes, not v15:IsInMeleeRange(2 + 6)) or ((2972 + 1871) == (1966 + 2118))) then
						return "sweeping_strikes execute 51";
					end
				end
				if (((13351 - 8682) > (1738 - (1140 + 235))) and v98.Rend:IsReady() and v42 and (v15:DebuffRemains(v98.RendDebuff) <= v14:GCD()) and not v98.Bloodletting:IsAvailable() and ((not v98.Warbreaker:IsAvailable() and (v98.ColossusSmash:CooldownRemains() < (3 + 1))) or (v98.Warbreaker:IsAvailable() and (v98.Warbreaker:CooldownRemains() < (4 + 0)))) and (v15:TimeToDie() > (4 + 8))) then
					if (v24(v98.Rend, not v102) or ((1929 - (33 + 19)) >= (1134 + 2004))) then
						return "rend execute 52";
					end
				end
				if (((14212 - 9470) >= (1598 + 2028)) and (v91 < v104) and v32 and ((v53 and v30) or not v53) and v98.Avatar:IsCastable() and (v98.ColossusSmash:CooldownUp() or v15:DebuffUp(v98.ColossusSmashDebuff) or (v104 < (39 - 19)))) then
					if (v24(v98.Avatar, not v102) or ((4258 + 282) == (1605 - (586 + 103)))) then
						return "avatar execute 53";
					end
				end
				if (((v91 < v104) and v50 and ((v58 and v30) or not v58) and v98.Warbreaker:IsCastable()) or ((106 + 1050) > (13376 - 9031))) then
					if (((3725 - (1309 + 179)) < (7670 - 3421)) and v24(v98.Warbreaker, not v102)) then
						return "warbreaker execute 54";
					end
				end
				v134 = 1 + 0;
			end
			if ((v134 == (10 - 6)) or ((2027 + 656) < (48 - 25))) then
				if (((1388 - 691) <= (1435 - (295 + 314))) and (v91 < v104) and v34 and ((v54 and v30) or not v54) and v98.Bladestorm:IsCastable()) then
					if (((2714 - 1609) <= (3138 - (1300 + 662))) and v24(v98.Bladestorm, not v102)) then
						return "bladestorm execute 65";
					end
				end
				break;
			end
			if (((10610 - 7231) <= (5567 - (1178 + 577))) and (v134 == (2 + 0))) then
				if (((v91 < v104) and v84 and ((v56 and v30) or not v56) and (v85 == "player") and v98.ChampionsSpear:IsCastable() and (v15:DebuffUp(v98.ColossusSmashDebuff) or v14:BuffUp(v98.TestofMightBuff))) or ((2329 - 1541) >= (3021 - (851 + 554)))) then
					if (((1640 + 214) <= (9370 - 5991)) and v24(v100.ChampionsSpearPlayer, not v15:IsSpellInRange(v98.ChampionsSpear))) then
						return "spear_of_bastion execute 57";
					end
				end
				if (((9879 - 5330) == (4851 - (115 + 187))) and (v91 < v104) and v84 and ((v56 and v30) or not v56) and (v85 == "cursor") and v98.ChampionsSpear:IsCastable() and (v15:DebuffUp(v98.ColossusSmashDebuff) or v14:BuffUp(v98.TestofMightBuff))) then
					if (v24(v100.ChampionsSpearCursor, not v15:IsSpellInRange(v98.ChampionsSpear)) or ((2315 + 707) >= (2863 + 161))) then
						return "spear_of_bastion execute 57";
					end
				end
				if (((18994 - 14174) > (3359 - (160 + 1001))) and v98.Cleave:IsReady() and v36 and (v106 > (2 + 0)) and (v15:DebuffRemains(v98.DeepWoundsDebuff) < v14:GCD())) then
					if (v24(v98.Cleave, not v102) or ((733 + 328) >= (10012 - 5121))) then
						return "cleave execute 58";
					end
				end
				if (((1722 - (237 + 121)) <= (5370 - (525 + 372))) and v98.MortalStrike:IsReady() and v40 and ((v15:DebuffStack(v98.ExecutionersPrecisionDebuff) == (3 - 1)) or (v15:DebuffRemains(v98.DeepWoundsDebuff) <= v14:GCD()))) then
					if (v24(v98.MortalStrike, not v102) or ((11811 - 8216) <= (145 - (96 + 46)))) then
						return "mortal_strike execute 59";
					end
				end
				v134 = 780 - (643 + 134);
			end
		end
	end
	local function v116()
		local v135 = 0 + 0;
		while true do
			if ((v135 == (4 - 2)) or ((17345 - 12673) == (3695 + 157))) then
				if (((3058 - 1499) == (3186 - 1627)) and (v91 < v104) and v37 and ((v55 and v30) or not v55) and v98.ColossusSmash:IsCastable()) then
					if (v24(v98.ColossusSmash, not v102) or ((2471 - (316 + 403)) <= (524 + 264))) then
						return "colossus_smash single_target 104";
					end
				end
				if ((v98.Skullsplitter:IsCastable() and v45 and not v98.TestofMight:IsAvailable() and (v15:DebuffRemains(v98.DeepWoundsDebuff) > (0 - 0)) and (v15:DebuffUp(v98.ColossusSmashDebuff) or (v98.ColossusSmash:CooldownRemains() > (2 + 1)))) or ((9838 - 5931) == (126 + 51))) then
					if (((1119 + 2351) > (1923 - 1368)) and v24(v98.Skullsplitter, not v102)) then
						return "skullsplitter single_target 105";
					end
				end
				if ((v98.Skullsplitter:IsCastable() and v45 and v98.TestofMight:IsAvailable() and (v15:DebuffRemains(v98.DeepWoundsDebuff) > (0 - 0))) or ((2018 - 1046) == (37 + 608))) then
					if (((6263 - 3081) >= (104 + 2011)) and v24(v98.Skullsplitter, not v102)) then
						return "skullsplitter single_target 106";
					end
				end
				if (((11453 - 7560) < (4446 - (12 + 5))) and (v91 < v104) and v49 and ((v57 and v30) or not v57) and v98.ThunderousRoar:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff) and (v14:RagePercentage() < (127 - 94))) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) then
					if (v24(v98.ThunderousRoar, not v15:IsInMeleeRange(16 - 8)) or ((6093 - 3226) < (4724 - 2819))) then
						return "thunderous_roar single_target 107";
					end
				end
				v135 = 1 + 2;
			end
			if ((v135 == (1977 - (1656 + 317))) or ((1601 + 195) >= (3247 + 804))) then
				if (((4304 - 2685) <= (18485 - 14729)) and v98.Whirlwind:IsReady() and v51 and v98.StormofSwords:IsAvailable() and v98.TestofMight:IsAvailable() and (v98.ColossusSmash:CooldownRemains() > (v14:GCD() * (361 - (5 + 349))))) then
					if (((2868 - 2264) == (1875 - (266 + 1005))) and v24(v98.Whirlwind, not v15:IsInMeleeRange(6 + 2))) then
						return "whirlwind single_target 113";
					end
				end
				if ((v98.Overpower:IsCastable() and v41 and (((v98.Overpower:Charges() == (6 - 4)) and not v98.Battlelord:IsAvailable() and (v15:DebuffUp(v98.ColossusSmashDebuff) or (v14:RagePercentage() < (32 - 7)))) or v98.Battlelord:IsAvailable())) or ((6180 - (561 + 1135)) == (1172 - 272))) then
					if (v24(v98.Overpower, not v102) or ((14657 - 10198) <= (2179 - (507 + 559)))) then
						return "overpower single_target 114";
					end
				end
				if (((9113 - 5481) > (10508 - 7110)) and v98.Slam:IsReady() and v46 and ((v98.CrushingForce:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff) and (v14:Rage() >= (448 - (212 + 176))) and v98.TestofMight:IsAvailable()) or v98.ImprovedSlam:IsAvailable()) and (not v98.FervorofBattle:IsAvailable() or (v98.FervorofBattle:IsAvailable() and (v106 == (906 - (250 + 655)))))) then
					if (((11131 - 7049) <= (8591 - 3674)) and v24(v98.Slam, not v102)) then
						return "slam single_target 115";
					end
				end
				if (((7559 - 2727) >= (3342 - (1869 + 87))) and v98.Whirlwind:IsReady() and v51 and (v98.StormofSwords:IsAvailable() or (v98.FervorofBattle:IsAvailable() and (v106 > (3 - 2))))) then
					if (((2038 - (484 + 1417)) == (293 - 156)) and v24(v98.Whirlwind, not v15:IsInMeleeRange(13 - 5))) then
						return "whirlwind single_target 116";
					end
				end
				v135 = 778 - (48 + 725);
			end
			if ((v135 == (9 - 3)) or ((4212 - 2642) >= (2518 + 1814))) then
				if ((v98.Cleave:IsReady() and v36 and v14:HasTier(77 - 48, 1 + 1) and not v98.CrushingForce:IsAvailable()) or ((1185 + 2879) <= (2672 - (152 + 701)))) then
					if (v24(v98.Cleave, not v102) or ((6297 - (430 + 881)) < (603 + 971))) then
						return "cleave single_target 121";
					end
				end
				if (((5321 - (557 + 338)) > (51 + 121)) and (v91 < v104) and v34 and ((v54 and v30) or not v54) and v98.Bladestorm:IsCastable()) then
					if (((1651 - 1065) > (1593 - 1138)) and v24(v98.Bladestorm, not v102)) then
						return "bladestorm single_target 122";
					end
				end
				if (((2194 - 1368) == (1779 - 953)) and v98.Cleave:IsReady() and v36) then
					if (v24(v98.Cleave, not v102) or ((4820 - (499 + 302)) > (5307 - (39 + 827)))) then
						return "cleave single_target 123";
					end
				end
				if (((5567 - 3550) < (9516 - 5255)) and v98.Rend:IsReady() and v42 and v15:DebuffRefreshable(v98.RendDebuff) and not v98.CrushingForce:IsAvailable()) then
					if (((18731 - 14015) > (122 - 42)) and v24(v98.Rend, not v102)) then
						return "rend single_target 124";
					end
				end
				break;
			end
			if ((v135 == (0 + 0)) or ((10264 - 6757) == (524 + 2748))) then
				if (((v91 < v104) and v47 and v98.SweepingStrikes:IsCastable() and (v106 > (1 - 0))) or ((980 - (103 + 1)) >= (3629 - (475 + 79)))) then
					if (((9407 - 5055) > (8172 - 5618)) and v24(v98.SweepingStrikes, not v15:IsInMeleeRange(2 + 6))) then
						return "sweeping_strikes single_target 97";
					end
				end
				if ((v98.Execute:IsReady() and (v14:BuffUp(v98.SuddenDeathBuff))) or ((3878 + 528) < (5546 - (1395 + 108)))) then
					if (v24(v98.Execute, not v102) or ((5496 - 3607) >= (4587 - (7 + 1197)))) then
						return "execute single_target 98";
					end
				end
				if (((825 + 1067) <= (954 + 1780)) and v98.MortalStrike:IsReady() and v40) then
					if (((2242 - (27 + 292)) < (6499 - 4281)) and v24(v98.MortalStrike, not v102)) then
						return "mortal_strike single_target 99";
					end
				end
				if (((2770 - 597) > (1589 - 1210)) and v98.Rend:IsReady() and v42 and ((v15:DebuffRemains(v98.RendDebuff) <= v14:GCD()) or (v98.TideofBlood:IsAvailable() and (v98.Skullsplitter:CooldownRemains() <= v14:GCD()) and ((v98.ColossusSmash:CooldownRemains() <= v14:GCD()) or v15:DebuffUp(v98.ColossusSmashDebuff)) and (v15:DebuffRemains(v98.RendDebuff) < (v98.RendDebuff:BaseDuration() * (0.85 - 0)))))) then
					if (v24(v98.Rend, not v102) or ((4934 - 2343) == (3548 - (43 + 96)))) then
						return "rend single_target 100";
					end
				end
				v135 = 4 - 3;
			end
			if (((10205 - 5691) > (2759 + 565)) and (v135 == (1 + 0))) then
				if (((v91 < v104) and v32 and ((v53 and v30) or not v53) and v98.Avatar:IsCastable() and ((v98.WarlordsTorment:IsAvailable() and (v14:RagePercentage() < (65 - 32)) and (v98.ColossusSmash:CooldownUp() or v15:DebuffUp(v98.ColossusSmashDebuff) or v14:BuffUp(v98.TestofMightBuff))) or (not v98.WarlordsTorment:IsAvailable() and (v98.ColossusSmash:CooldownUp() or v15:DebuffUp(v98.ColossusSmashDebuff))))) or ((80 + 128) >= (9048 - 4220))) then
					if (v24(v98.Avatar, not v102) or ((499 + 1084) > (262 + 3305))) then
						return "avatar single_target 101";
					end
				end
				if (((v91 < v104) and v84 and ((v56 and v30) or not v56) and (v85 == "player") and v98.ChampionsSpear:IsCastable() and ((v98.ColossusSmash:CooldownRemains() <= v14:GCD()) or (v98.Warbreaker:CooldownRemains() <= v14:GCD()))) or ((3064 - (1414 + 337)) == (2734 - (1642 + 298)))) then
					if (((8274 - 5100) > (8348 - 5446)) and v24(v100.ChampionsSpearPlayer, not v15:IsSpellInRange(v98.ChampionsSpear))) then
						return "spear_of_bastion single_target 102";
					end
				end
				if (((12226 - 8106) <= (1402 + 2858)) and (v91 < v104) and v84 and ((v56 and v30) or not v56) and (v85 == "cursor") and v98.ChampionsSpear:IsCastable() and ((v98.ColossusSmash:CooldownRemains() <= v14:GCD()) or (v98.Warbreaker:CooldownRemains() <= v14:GCD()))) then
					if (v24(v100.ChampionsSpearCursor, not v15:IsSpellInRange(v98.ChampionsSpear)) or ((688 + 195) > (5750 - (357 + 615)))) then
						return "spear_of_bastion single_target 102";
					end
				end
				if (((v91 < v104) and v50 and ((v58 and v30) or not v58) and v98.Warbreaker:IsCastable()) or ((2542 + 1078) >= (12000 - 7109))) then
					if (((3649 + 609) > (2007 - 1070)) and v24(v98.Warbreaker, not v15:IsInRange(7 + 1))) then
						return "warbreaker single_target 103";
					end
				end
				v135 = 1 + 1;
			end
			if (((4 + 1) == v135) or ((6170 - (384 + 917)) < (1603 - (128 + 569)))) then
				if ((v98.Slam:IsReady() and v46 and (v98.CrushingForce:IsAvailable() or (not v98.CrushingForce:IsAvailable() and (v14:Rage() >= (1573 - (1407 + 136))))) and (not v98.FervorofBattle:IsAvailable() or (v98.FervorofBattle:IsAvailable() and (v106 == (1888 - (687 + 1200)))))) or ((2935 - (556 + 1154)) > (14874 - 10646))) then
					if (((3423 - (9 + 86)) > (2659 - (275 + 146))) and v24(v98.Slam, not v102)) then
						return "slam single_target 117";
					end
				end
				if (((625 + 3214) > (1469 - (29 + 35))) and v98.ThunderClap:IsReady() and v48 and v98.Battlelord:IsAvailable() and v98.BloodandThunder:IsAvailable()) then
					if (v24(v98.ThunderClap, not v102) or ((5730 - 4437) <= (1514 - 1007))) then
						return "thunder_clap single_target 118";
					end
				end
				if ((v98.Overpower:IsCastable() and v41 and ((v15:DebuffDown(v98.ColossusSmashDebuff) and (v14:RagePercentage() < (220 - 170)) and not v98.Battlelord:IsAvailable()) or (v14:RagePercentage() < (17 + 8)))) or ((3908 - (53 + 959)) < (1213 - (312 + 96)))) then
					if (((4019 - 1703) == (2601 - (147 + 138))) and v24(v98.Overpower, not v102)) then
						return "overpower single_target 119";
					end
				end
				if ((v98.Whirlwind:IsReady() and v51 and v14:BuffUp(v98.MercilessBonegrinderBuff)) or ((3469 - (813 + 86)) == (1386 + 147))) then
					if (v24(v98.Whirlwind, not v15:IsInRange(14 - 6)) or ((1375 - (18 + 474)) == (493 + 967))) then
						return "whirlwind single_target 120";
					end
				end
				v135 = 19 - 13;
			end
			if ((v135 == (1089 - (860 + 226))) or ((4922 - (121 + 182)) <= (123 + 876))) then
				if ((v98.Whirlwind:IsReady() and v51 and v98.StormofSwords:IsAvailable() and v98.TestofMight:IsAvailable() and (v14:RagePercentage() > (1320 - (988 + 252))) and v15:DebuffUp(v98.ColossusSmashDebuff)) or ((386 + 3024) > (1290 + 2826))) then
					if (v24(v98.Whirlwind, not v15:IsInMeleeRange(1978 - (49 + 1921))) or ((1793 - (223 + 667)) >= (3111 - (51 + 1)))) then
						return "whirlwind single_target 108";
					end
				end
				if ((v98.ThunderClap:IsReady() and v48 and (v15:DebuffRemains(v98.RendDebuff) <= v14:GCD()) and not v98.TideofBlood:IsAvailable()) or ((6843 - 2867) < (6117 - 3260))) then
					if (((6055 - (146 + 979)) > (652 + 1655)) and v24(v98.ThunderClap, not v102)) then
						return "thunder_clap single_target 109";
					end
				end
				if (((v91 < v104) and v34 and ((v54 and v30) or not v54) and v98.Bladestorm:IsCastable() and ((v98.Hurricane:IsAvailable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) or (v98.Unhinged:IsAvailable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))))) or ((4651 - (311 + 294)) < (3600 - 2309))) then
					if (v24(v98.Bladestorm, not v102) or ((1797 + 2444) == (4988 - (496 + 947)))) then
						return "bladestorm single_target 110";
					end
				end
				if ((v98.Shockwave:IsCastable() and v44 and (v98.SonicBoom:IsAvailable() or v15:IsCasting())) or ((5406 - (1233 + 125)) > (1718 + 2514))) then
					if (v24(v98.Shockwave, not v15:IsInMeleeRange(8 + 0)) or ((333 + 1417) >= (5118 - (963 + 682)))) then
						return "shockwave single_target 111";
					end
				end
				v135 = 4 + 0;
			end
		end
	end
	local function v117()
		local v136 = 1504 - (504 + 1000);
		while true do
			if (((2133 + 1033) == (2884 + 282)) and ((0 + 0) == v136)) then
				if (((2599 - 836) < (3182 + 542)) and not v14:AffectingCombat()) then
					local v198 = 0 + 0;
					while true do
						if (((239 - (156 + 26)) <= (1569 + 1154)) and (v198 == (0 - 0))) then
							if ((v98.BattleStance:IsCastable() and v14:BuffDown(v98.BattleStance, true)) or ((2234 - (149 + 15)) == (1403 - (890 + 70)))) then
								if (v24(v98.BattleStance) or ((2822 - (39 + 78)) == (1875 - (14 + 468)))) then
									return "battle_stance";
								end
							end
							if ((v98.BattleShout:IsCastable() and v33 and (v14:BuffDown(v98.BattleShoutBuff, true) or v94.GroupBuffMissing(v98.BattleShoutBuff))) or ((10117 - 5516) < (170 - 109))) then
								if (v24(v98.BattleShout) or ((718 + 672) >= (2849 + 1895))) then
									return "battle_shout precombat";
								end
							end
							break;
						end
					end
				end
				if ((v94.TargetIsValid() and v28) or ((426 + 1577) > (1732 + 2102))) then
					if (not v14:AffectingCombat() or ((41 + 115) > (7489 - 3576))) then
						local v204 = 0 + 0;
						while true do
							if (((685 - 490) == (5 + 190)) and ((51 - (12 + 39)) == v204)) then
								v27 = v113();
								if (((2889 + 216) >= (5559 - 3763)) and v27) then
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
	local function v118()
		local v137 = 0 - 0;
		while true do
			if (((1299 + 3080) >= (1122 + 1009)) and (v137 == (2 - 1))) then
				if (((2561 + 1283) >= (9873 - 7830)) and v86) then
					local v199 = 1710 - (1596 + 114);
					while true do
						if ((v199 == (2 - 1)) or ((3945 - (164 + 549)) <= (4169 - (1059 + 379)))) then
							v27 = v94.HandleIncorporeal(v98.IntimidatingShout, v100.IntimidatingShoutMouseover, 9 - 1, true);
							if (((2543 + 2362) == (827 + 4078)) and v27) then
								return v27;
							end
							break;
						end
						if (((392 - (145 + 247)) == v199) or ((3394 + 742) >= (2039 + 2372))) then
							v27 = v94.HandleIncorporeal(v98.StormBolt, v100.StormBoltMouseover, 59 - 39, true);
							if (v27 or ((568 + 2390) == (3461 + 556))) then
								return v27;
							end
							v199 = 1 - 0;
						end
					end
				end
				if (((1948 - (254 + 466)) >= (1373 - (544 + 16))) and v94.TargetIsValid()) then
					local v200 = 0 - 0;
					local v201;
					while true do
						if ((v200 == (630 - (294 + 334))) or ((3708 - (236 + 17)) > (1746 + 2304))) then
							if (((190 + 53) == (914 - 671)) and ((v98.Massacre:IsAvailable() and (v15:HealthPercentage() < (165 - 130))) or (v15:HealthPercentage() < (11 + 9)))) then
								local v207 = 0 + 0;
								while true do
									if ((v207 == (794 - (413 + 381))) or ((12 + 259) > (3343 - 1771))) then
										v27 = v115();
										if (((7114 - 4375) < (5263 - (582 + 1388))) and v27) then
											return v27;
										end
										break;
									end
								end
							end
							v27 = v116();
							if (v27 or ((6715 - 2773) < (812 + 322))) then
								return v27;
							end
							if (v20.CastAnnotated(v98.Pool, false, "WAIT") or ((3057 - (326 + 38)) == (14710 - 9737))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((3063 - 917) == (2766 - (47 + 573))) and (v200 == (0 + 0))) then
							if ((v35 and v98.Charge:IsCastable() and not v102) or ((9530 - 7286) == (5232 - 2008))) then
								if (v24(v98.Charge, not v15:IsSpellInRange(v98.Charge)) or ((6568 - (1269 + 395)) <= (2408 - (76 + 416)))) then
									return "charge main 34";
								end
							end
							v201 = v94.HandleDPSPotion(v15:DebuffUp(v98.ColossusSmashDebuff));
							if (((533 - (319 + 124)) <= (2434 - 1369)) and v201) then
								return v201;
							end
							if (((5809 - (564 + 443)) == (13293 - 8491)) and v102 and v92 and ((v60 and v30) or not v60) and (v91 < v104)) then
								local v208 = 458 - (337 + 121);
								while true do
									if ((v208 == (5 - 3)) or ((7595 - 5315) <= (2422 - (1261 + 650)))) then
										if ((v98.Fireblood:IsCastable() and (v15:DebuffUp(v98.ColossusSmashDebuff))) or ((710 + 966) <= (737 - 274))) then
											if (((5686 - (772 + 1045)) == (546 + 3323)) and v24(v98.Fireblood)) then
												return "fireblood main 43";
											end
										end
										if (((1302 - (102 + 42)) <= (4457 - (1524 + 320))) and v98.AncestralCall:IsCastable() and (v15:DebuffUp(v98.ColossusSmashDebuff))) then
											if (v24(v98.AncestralCall) or ((3634 - (1049 + 221)) <= (2155 - (18 + 138)))) then
												return "ancestral_call main 44";
											end
										end
										v208 = 7 - 4;
									end
									if ((v208 == (1103 - (67 + 1035))) or ((5270 - (136 + 212)) < (824 - 630))) then
										if ((v98.ArcaneTorrent:IsCastable() and (v98.MortalStrike:CooldownRemains() > (1.5 + 0)) and (v14:Rage() < (47 + 3))) or ((3695 - (240 + 1364)) < (1113 - (1050 + 32)))) then
											if (v24(v98.ArcaneTorrent, not v15:IsInRange(28 - 20)) or ((1438 + 992) >= (5927 - (331 + 724)))) then
												return "arcane_torrent main 41";
											end
										end
										if ((v98.LightsJudgment:IsCastable() and v15:DebuffDown(v98.ColossusSmashDebuff) and not v98.MortalStrike:CooldownUp()) or ((385 + 4385) < (2379 - (269 + 375)))) then
											if (v24(v98.LightsJudgment, not v15:IsSpellInRange(v98.LightsJudgment)) or ((5164 - (267 + 458)) <= (731 + 1619))) then
												return "lights_judgment main 42";
											end
										end
										v208 = 3 - 1;
									end
									if ((v208 == (821 - (667 + 151))) or ((5976 - (1410 + 87)) < (6363 - (1504 + 393)))) then
										if (((6884 - 4337) > (3178 - 1953)) and v98.BagofTricks:IsCastable() and v15:DebuffDown(v98.ColossusSmashDebuff) and not v98.MortalStrike:CooldownUp()) then
											if (((5467 - (461 + 335)) > (342 + 2332)) and v24(v98.BagofTricks, not v15:IsSpellInRange(v98.BagofTricks))) then
												return "bag_of_tricks main 10";
											end
										end
										break;
									end
									if ((v208 == (1761 - (1730 + 31))) or ((5363 - (728 + 939)) < (11782 - 8455))) then
										if ((v98.BloodFury:IsCastable() and v15:DebuffUp(v98.ColossusSmashDebuff)) or ((9212 - 4670) == (6805 - 3835))) then
											if (((1320 - (138 + 930)) <= (1807 + 170)) and v24(v98.BloodFury)) then
												return "blood_fury main 39";
											end
										end
										if ((v98.Berserking:IsCastable() and (v15:DebuffRemains(v98.ColossusSmashDebuff) > (5 + 1))) or ((1231 + 205) == (15414 - 11639))) then
											if (v24(v98.Berserking) or ((3384 - (459 + 1307)) < (2800 - (474 + 1396)))) then
												return "berserking main 40";
											end
										end
										v208 = 1 - 0;
									end
								end
							end
							v200 = 1 + 0;
						end
						if (((16 + 4707) > (11895 - 7742)) and (v200 == (1 + 0))) then
							if ((v91 < v104) or ((12197 - 8543) >= (20296 - 15642))) then
								if (((1542 - (562 + 29)) <= (1276 + 220)) and v93 and ((v30 and v59) or not v59)) then
									v27 = v112();
									if (v27 or ((3155 - (374 + 1045)) == (452 + 119))) then
										return v27;
									end
								end
								if ((v30 and v99.FyralathTheDreamrender:IsEquippedAndReady() and v31) or ((2782 - 1886) > (5407 - (448 + 190)))) then
									if (v24(v100.UseWeapon) or ((338 + 707) <= (461 + 559))) then
										return "Fyralath The Dreamrender used";
									end
								end
							end
							if ((v39 and v98.HeroicThrow:IsCastable() and not v15:IsInRange(17 + 8) and v14:CanAttack(v15)) or ((4459 - 3299) <= (1018 - 690))) then
								if (((5302 - (1307 + 187)) > (11595 - 8671)) and v24(v98.HeroicThrow, not v15:IsSpellInRange(v98.HeroicThrow))) then
									return "heroic_throw main";
								end
							end
							if (((9110 - 5219) < (15082 - 10163)) and v98.WreckingThrow:IsCastable() and v52 and v107() and v14:CanAttack(v15)) then
								if (v24(v98.WreckingThrow, not v15:IsSpellInRange(v98.WreckingThrow)) or ((2917 - (232 + 451)) <= (1435 + 67))) then
									return "wrecking_throw main";
								end
							end
							if ((v29 and (v106 > (2 + 0))) or ((3076 - (510 + 54)) < (870 - 438))) then
								local v209 = 36 - (13 + 23);
								while true do
									if ((v209 == (0 - 0)) or ((2655 - 807) == (1571 - 706))) then
										v27 = v114();
										if (v27 or ((5770 - (830 + 258)) <= (16018 - 11477))) then
											return v27;
										end
										break;
									end
								end
							end
							v200 = 2 + 0;
						end
					end
				end
				break;
			end
			if ((v137 == (0 + 0)) or ((4467 - (860 + 581)) >= (14924 - 10878))) then
				v27 = v111();
				if (((1594 + 414) > (879 - (237 + 4))) and v27) then
					return v27;
				end
				v137 = 2 - 1;
			end
		end
	end
	local function v119()
		v31 = EpicSettings.Settings['useWeapon'];
		v33 = EpicSettings.Settings['useBattleShout'];
		v35 = EpicSettings.Settings['useCharge'];
		v36 = EpicSettings.Settings['useCleave'];
		v38 = EpicSettings.Settings['useExecute'];
		v39 = EpicSettings.Settings['useHeroicThrow'];
		v40 = EpicSettings.Settings['useMortalStrike'];
		v41 = EpicSettings.Settings['useOverpower'];
		v42 = EpicSettings.Settings['useRend'];
		v44 = EpicSettings.Settings['useShockwave'];
		v45 = EpicSettings.Settings['useSkullsplitter'];
		v46 = EpicSettings.Settings['useSlam'];
		v47 = EpicSettings.Settings['useSweepingStrikes'];
		v48 = EpicSettings.Settings['useThunderClap'];
		v51 = EpicSettings.Settings['useWhirlwind'];
		v52 = EpicSettings.Settings['useWreckingThrow'];
		v32 = EpicSettings.Settings['useAvatar'];
		v34 = EpicSettings.Settings['useBladestorm'];
		v37 = EpicSettings.Settings['useColossusSmash'];
		v84 = EpicSettings.Settings['useChampionsSpear'];
		v49 = EpicSettings.Settings['useThunderousRoar'];
		v50 = EpicSettings.Settings['useWarbreaker'];
		v53 = EpicSettings.Settings['avatarWithCD'];
		v54 = EpicSettings.Settings['bladestormWithCD'];
		v55 = EpicSettings.Settings['colossusSmashWithCD'];
		v56 = EpicSettings.Settings['championsSpearWithCD'];
		v57 = EpicSettings.Settings['thunderousRoarWithCD'];
		v58 = EpicSettings.Settings['warbreakerWithCD'];
	end
	local function v120()
		local v166 = 0 - 0;
		while true do
			if (((3365 - 1590) <= (2647 + 586)) and (v166 == (2 + 1))) then
				v72 = EpicSettings.Settings['useVictoryRush'];
				v73 = EpicSettings.Settings['bitterImmunityHP'] or (0 - 0);
				v79 = EpicSettings.Settings['defensiveStanceHP'] or (0 + 0);
				v166 = 3 + 1;
			end
			if ((v166 == (1427 - (85 + 1341))) or ((7751 - 3208) == (5639 - 3642))) then
				v64 = EpicSettings.Settings['useBitterImmunity'];
				v69 = EpicSettings.Settings['useDefensiveStance'];
				v65 = EpicSettings.Settings['useDieByTheSword'];
				v166 = 374 - (45 + 327);
			end
			if ((v166 == (3 - 1)) or ((3604 - (444 + 58)) < (317 + 411))) then
				v66 = EpicSettings.Settings['useIgnorePain'];
				v68 = EpicSettings.Settings['useIntervene'];
				v67 = EpicSettings.Settings['useRallyingCry'];
				v166 = 1 + 2;
			end
			if (((169 + 176) == (999 - 654)) and (v166 == (1737 - (64 + 1668)))) then
				v78 = EpicSettings.Settings['interveneHP'] or (1973 - (1227 + 746));
				v77 = EpicSettings.Settings['rallyingCryGroup'] or (0 - 0);
				v76 = EpicSettings.Settings['rallyingCryHP'] or (0 - 0);
				v166 = 500 - (415 + 79);
			end
			if (((0 + 0) == v166) or ((3318 - (142 + 349)) < (162 + 216))) then
				v61 = EpicSettings.Settings['usePummel'];
				v62 = EpicSettings.Settings['useStormBolt'];
				v63 = EpicSettings.Settings['useIntimidatingShout'];
				v166 = 1 - 0;
			end
			if ((v166 == (2 + 2)) or ((2450 + 1026) < (7072 - 4475))) then
				v82 = EpicSettings.Settings['unstanceHP'] or (1864 - (1710 + 154));
				v74 = EpicSettings.Settings['dieByTheSwordHP'] or (318 - (200 + 118));
				v75 = EpicSettings.Settings['ignorePainHP'] or (0 + 0);
				v166 = 8 - 3;
			end
			if (((4566 - 1487) < (4260 + 534)) and (v166 == (6 + 0))) then
				v83 = EpicSettings.Settings['victoryRushHP'] or (0 + 0);
				v85 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
		end
	end
	local function v121()
		local v167 = 0 + 0;
		while true do
			if (((10515 - 5661) > (5714 - (363 + 887))) and (v167 == (6 - 2))) then
				v87 = EpicSettings.Settings['HealingPotionName'] or "";
				v86 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v167 == (4 - 3)) or ((759 + 4153) == (8793 - 5035))) then
				v90 = EpicSettings.Settings['InterruptThreshold'];
				v93 = EpicSettings.Settings['useTrinkets'];
				v92 = EpicSettings.Settings['useRacials'];
				v167 = 2 + 0;
			end
			if (((1790 - (674 + 990)) <= (999 + 2483)) and ((0 + 0) == v167)) then
				v91 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v88 = EpicSettings.Settings['InterruptWithStun'];
				v89 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v167 = 1056 - (507 + 548);
			end
			if ((v167 == (840 - (289 + 548))) or ((4192 - (821 + 997)) == (4629 - (195 + 60)))) then
				v71 = EpicSettings.Settings['useHealingPotion'];
				v80 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v81 = EpicSettings.Settings['healingPotionHP'] or (1501 - (251 + 1250));
				v167 = 11 - 7;
			end
			if (((1083 + 492) == (2607 - (809 + 223))) and (v167 == (2 - 0))) then
				v59 = EpicSettings.Settings['trinketsWithCD'];
				v60 = EpicSettings.Settings['racialsWithCD'];
				v70 = EpicSettings.Settings['useHealthstone'];
				v167 = 8 - 5;
			end
		end
	end
	local function v122()
		local v168 = 0 - 0;
		while true do
			if ((v168 == (0 + 0)) or ((1170 + 1064) == (2072 - (14 + 603)))) then
				v120();
				v119();
				v121();
				v28 = EpicSettings.Toggles['ooc'];
				v168 = 130 - (118 + 11);
			end
			if ((v168 == (1 + 1)) or ((889 + 178) > (5184 - 3405))) then
				v102 = v15:IsInMeleeRange(957 - (551 + 398));
				if (((1366 + 795) >= (333 + 601)) and (v94.TargetIsValid() or v14:AffectingCombat())) then
					local v202 = 0 + 0;
					while true do
						if (((5995 - 4383) == (3713 - 2101)) and (v202 == (0 + 0))) then
							v103 = v10.BossFightRemains(nil, true);
							v104 = v103;
							v202 = 3 - 2;
						end
						if (((1202 + 3150) >= (2922 - (40 + 49))) and (v202 == (3 - 2))) then
							if ((v104 == (11601 - (99 + 391))) or ((2666 + 556) < (13508 - 10435))) then
								v104 = v10.FightRemains(v105, false);
							end
							break;
						end
					end
				end
				if (((1842 - 1098) <= (2866 + 76)) and not v14:IsChanneling()) then
					if (v14:AffectingCombat() or ((4823 - 2990) <= (2926 - (1032 + 572)))) then
						local v205 = 417 - (203 + 214);
						while true do
							if ((v205 == (1817 - (568 + 1249))) or ((2713 + 754) <= (2533 - 1478))) then
								v27 = v118();
								if (((13677 - 10136) == (4847 - (913 + 393))) and v27) then
									return v27;
								end
								break;
							end
						end
					else
						local v206 = 0 - 0;
						while true do
							if ((v206 == (0 - 0)) or ((3967 - (269 + 141)) >= (8902 - 4899))) then
								v27 = v117();
								if (v27 or ((2638 - (362 + 1619)) >= (3293 - (950 + 675)))) then
									return v27;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((1 + 0) == v168) or ((2206 - (216 + 963)) > (5145 - (485 + 802)))) then
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				if (v14:IsDeadOrGhost() or ((4213 - (432 + 127)) < (1523 - (1065 + 8)))) then
					return v27;
				end
				if (((1051 + 840) < (6054 - (635 + 966))) and v29) then
					local v203 = 0 + 0;
					while true do
						if ((v203 == (42 - (5 + 37))) or ((7809 - 4669) < (886 + 1243))) then
							v105 = v14:GetEnemiesInMeleeRange(12 - 4);
							v106 = #v105;
							break;
						end
					end
				else
					v106 = 1 + 0;
				end
				v168 = 3 - 1;
			end
		end
	end
	local function v123()
		v20.Print("Arms Warrior by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(269 - 198, v122, v123);
end;
return v0["Epix_Warrior_Arms.lua"]();

