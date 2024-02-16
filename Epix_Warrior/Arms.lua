local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((1694 - (556 + 592)) >= (955 + 1729))) then
			return v6(...);
		end
		if (((2273 - (329 + 479)) <= (5155 - (174 + 680))) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((3531 - 1827) > (1018 + 407)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 740 - (396 + 343);
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
	local v95 = (v94[2 + 11] and v19(v94[1490 - (29 + 1448)])) or v19(1389 - (135 + 1254));
	local v96 = (v94[52 - 38] and v19(v94[65 - 51])) or v19(0 + 0);
	local v97 = v18.Warrior.Arms;
	local v98 = v19.Warrior.Arms;
	local v99 = v23.Warrior.Arms;
	local v100 = {};
	local v101;
	local v102 = 12638 - (389 + 1138);
	local v103 = 11685 - (102 + 472);
	v10:RegisterForEvent(function()
		local v123 = 0 + 0;
		while true do
			if ((v123 == (0 + 0)) or ((641 + 46) == (5779 - (320 + 1225)))) then
				v102 = 19779 - 8668;
				v103 = 6799 + 4312;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v124 = 1464 - (157 + 1307);
		while true do
			if ((v124 == (1859 - (821 + 1038))) or ((8308 - 4978) < (157 + 1272))) then
				v94 = v14:GetEquipment();
				v95 = (v94[22 - 9] and v19(v94[5 + 8])) or v19(0 - 0);
				v124 = 1027 - (834 + 192);
			end
			if (((73 + 1074) >= (86 + 249)) and (v124 == (1 + 0))) then
				v96 = (v94[21 - 7] and v19(v94[318 - (300 + 4)])) or v19(0 + 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v104;
	local v105;
	local function v106()
		local v125 = UnitGetTotalAbsorbs(v15:ID());
		if (((8991 - 5556) > (2459 - (112 + 250))) and (v125 > (0 + 0))) then
			return true;
		else
			return false;
		end
	end
	local function v107(v126)
		return (v126:HealthPercentage() > (50 - 30)) or (v97.Massacre:IsAvailable() and (v126:HealthPercentage() < (21 + 14)));
	end
	local function v108(v127)
		return (v127:DebuffStack(v97.ExecutionersPrecisionDebuff) == (2 + 0)) or (v127:DebuffRemains(v97.DeepWoundsDebuff) <= v14:GCD()) or (v97.Dreadnaught:IsAvailable() and v97.Battlelord:IsAvailable() and (v105 <= (2 + 0)));
	end
	local function v109(v128)
		return v14:BuffUp(v97.SuddenDeathBuff) or ((v105 <= (1 + 1)) and ((v128:HealthPercentage() < (15 + 5)) or (v97.Massacre:IsAvailable() and (v128:HealthPercentage() < (1449 - (1001 + 413)))))) or v14:BuffUp(v97.SweepingStrikes);
	end
	local function v110()
		local v129 = 0 - 0;
		while true do
			if ((v129 == (885 - (244 + 638))) or ((4463 - (627 + 66)) >= (12040 - 7999))) then
				if ((v97.BattleStance:IsCastable() and v14:BuffDown(v97.BattleStance, true) and v68 and (v14:HealthPercentage() > v81)) or ((4393 - (512 + 90)) <= (3517 - (1665 + 241)))) then
					if (v24(v97.BattleStance) or ((5295 - (373 + 344)) <= (906 + 1102))) then
						return "battle_stance after defensive stance defensive";
					end
				end
				if (((298 + 827) <= (5475 - 3399)) and v98.Healthstone:IsReady() and v69 and (v14:HealthPercentage() <= v79)) then
					if (v24(v99.Healthstone) or ((1256 - 513) >= (5498 - (35 + 1064)))) then
						return "healthstone defensive 3";
					end
				end
				v129 = 3 + 1;
			end
			if (((2471 - 1316) < (7 + 1666)) and (v129 == (1238 - (298 + 938)))) then
				if ((v97.Intervene:IsCastable() and v67 and (v17:HealthPercentage() <= v77) and (v17:Name() ~= v14:Name())) or ((3583 - (233 + 1026)) <= (2244 - (636 + 1030)))) then
					if (((1926 + 1841) == (3680 + 87)) and v24(v99.InterveneFocus)) then
						return "intervene defensive";
					end
				end
				if (((1215 + 2874) == (277 + 3812)) and v97.DefensiveStance:IsCastable() and v14:BuffDown(v97.DefensiveStance, true) and v68 and (v14:HealthPercentage() <= v78)) then
					if (((4679 - (55 + 166)) >= (325 + 1349)) and v24(v97.DefensiveStance)) then
						return "defensive_stance defensive";
					end
				end
				v129 = 1 + 2;
			end
			if (((3711 - 2739) <= (1715 - (36 + 261))) and (v129 == (6 - 2))) then
				if ((v70 and (v14:HealthPercentage() <= v80)) or ((6306 - (34 + 1334)) < (1831 + 2931))) then
					local v191 = 0 + 0;
					while true do
						if ((v191 == (1283 - (1035 + 248))) or ((2525 - (20 + 1)) > (2222 + 2042))) then
							if (((2472 - (134 + 185)) == (3286 - (549 + 584))) and (v86 == "Refreshing Healing Potion")) then
								if (v98.RefreshingHealingPotion:IsReady() or ((1192 - (314 + 371)) >= (8894 - 6303))) then
									if (((5449 - (478 + 490)) == (2374 + 2107)) and v24(v99.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v86 == "Dreamwalker's Healing Potion") or ((3500 - (786 + 386)) < (2244 - 1551))) then
								if (((5707 - (1055 + 324)) == (5668 - (1093 + 247))) and v98.DreamwalkersHealingPotion:IsReady()) then
									if (((1412 + 176) >= (141 + 1191)) and v24(v99.RefreshingHealingPotion)) then
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
			if (((3 - 2) == v129) or ((14165 - 9991) > (12087 - 7839))) then
				if ((v97.IgnorePain:IsCastable() and v65 and (v14:HealthPercentage() <= v74)) or ((11524 - 6938) <= (30 + 52))) then
					if (((14881 - 11018) == (13314 - 9451)) and v24(v97.IgnorePain, nil, nil, true)) then
						return "ignore_pain defensive";
					end
				end
				if ((v97.RallyingCry:IsCastable() and v66 and v14:BuffDown(v97.AspectsFavorBuff) and v14:BuffDown(v97.RallyingCry) and (((v14:HealthPercentage() <= v75) and v93.IsSoloMode()) or v93.AreUnitsBelowHealthPercentage(v75, v76))) or ((213 + 69) <= (107 - 65))) then
					if (((5297 - (364 + 324)) >= (2099 - 1333)) and v24(v97.RallyingCry)) then
						return "rallying_cry defensive";
					end
				end
				v129 = 4 - 2;
			end
			if ((v129 == (0 + 0)) or ((4820 - 3668) == (3984 - 1496))) then
				if (((10392 - 6970) > (4618 - (1249 + 19))) and v97.BitterImmunity:IsReady() and v63 and (v14:HealthPercentage() <= v72)) then
					if (((792 + 85) > (1463 - 1087)) and v24(v97.BitterImmunity)) then
						return "bitter_immunity defensive";
					end
				end
				if ((v97.DieByTheSword:IsCastable() and v64 and (v14:HealthPercentage() <= v73)) or ((4204 - (686 + 400)) <= (1453 + 398))) then
					if (v24(v97.DieByTheSword) or ((394 - (73 + 156)) >= (17 + 3475))) then
						return "die_by_the_sword defensive";
					end
				end
				v129 = 812 - (721 + 90);
			end
		end
	end
	local function v111()
		local v130 = 0 + 0;
		while true do
			if (((12821 - 8872) < (5326 - (224 + 246))) and (v130 == (1 - 0))) then
				v27 = v93.HandleBottomTrinket(v100, v30, 73 - 33, nil);
				if (v27 or ((776 + 3500) < (72 + 2944))) then
					return v27;
				end
				break;
			end
			if (((3445 + 1245) > (8201 - 4076)) and (v130 == (0 - 0))) then
				v27 = v93.HandleTopTrinket(v100, v30, 553 - (203 + 310), nil);
				if (v27 or ((2043 - (1238 + 755)) >= (63 + 833))) then
					return v27;
				end
				v130 = 1535 - (709 + 825);
			end
		end
	end
	local function v112()
		local v131 = 0 - 0;
		while true do
			if ((v131 == (0 - 0)) or ((2578 - (196 + 668)) >= (11678 - 8720))) then
				if (v101 or ((3088 - 1597) < (1477 - (171 + 662)))) then
					if (((797 - (4 + 89)) < (3459 - 2472)) and v97.Skullsplitter:IsCastable() and v44) then
						if (((1354 + 2364) > (8371 - 6465)) and v24(v97.Skullsplitter)) then
							return "skullsplitter precombat";
						end
					end
					if (((v90 < v103) and v97.ColossusSmash:IsCastable() and v36 and ((v54 and v30) or not v54)) or ((376 + 582) > (5121 - (35 + 1451)))) then
						if (((4954 - (28 + 1425)) <= (6485 - (941 + 1052))) and v24(v97.ColossusSmash)) then
							return "colossus_smash precombat";
						end
					end
					if (((v90 < v103) and v97.Warbreaker:IsCastable() and v49 and ((v57 and v30) or not v57)) or ((3301 + 141) < (4062 - (822 + 692)))) then
						if (((4104 - 1229) >= (690 + 774)) and v24(v97.Warbreaker)) then
							return "warbreaker precombat";
						end
					end
					if ((v97.Overpower:IsCastable() and v40) or ((5094 - (45 + 252)) >= (4842 + 51))) then
						if (v24(v97.Overpower) or ((190 + 361) > (5032 - 2964))) then
							return "overpower precombat";
						end
					end
				end
				if (((2547 - (114 + 319)) > (1355 - 411)) and v34 and v97.Charge:IsCastable()) then
					if (v24(v97.Charge) or ((2898 - 636) >= (1974 + 1122))) then
						return "charge precombat";
					end
				end
				break;
			end
		end
	end
	local function v113()
		local v132 = 0 - 0;
		while true do
			if ((v132 == (10 - 5)) or ((4218 - (556 + 1407)) >= (4743 - (741 + 465)))) then
				if (((v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable()) or ((4302 - (170 + 295)) < (689 + 617))) then
					if (((2710 + 240) == (7263 - 4313)) and v24(v97.ThunderousRoar, not v15:IsInMeleeRange(7 + 1))) then
						return "thunderous_roar hac 85";
					end
				end
				if ((v97.Shockwave:IsCastable() and v43 and (v105 > (2 + 0)) and (v97.SonicBoom:IsAvailable() or v15:IsCasting())) or ((2675 + 2048) < (4528 - (957 + 273)))) then
					if (((304 + 832) >= (62 + 92)) and v24(v97.Shockwave, not v15:IsInMeleeRange(30 - 22))) then
						return "shockwave hac 86";
					end
				end
				if ((v97.Overpower:IsCastable() and v40 and (v105 == (2 - 1)) and (((v97.Overpower:Charges() == (5 - 3)) and not v97.Battlelord:IsAvailable() and (v15:Debuffdown(v97.ColossusSmashDebuff) or (v14:RagePercentage() < (123 - 98)))) or v97.Battlelord:IsAvailable())) or ((2051 - (389 + 1391)) > (2979 + 1769))) then
					if (((494 + 4246) >= (7175 - 4023)) and v24(v97.Overpower, not v101)) then
						return "overpower hac 87";
					end
				end
				if ((v97.Slam:IsReady() and v45 and (v105 == (952 - (783 + 168))) and not v97.Battlelord:IsAvailable() and (v14:RagePercentage() > (234 - 164))) or ((2536 + 42) >= (3701 - (309 + 2)))) then
					if (((125 - 84) <= (2873 - (1090 + 122))) and v24(v97.Slam, not v101)) then
						return "slam hac 88";
					end
				end
				v132 = 2 + 4;
			end
			if (((2018 - 1417) < (2437 + 1123)) and (v132 == (1118 - (628 + 490)))) then
				if (((43 + 192) < (1700 - 1013)) and v97.Execute:IsReady() and v37 and v14:BuffUp(v97.JuggernautBuff) and (v14:BuffRemains(v97.JuggernautBuff) < v14:GCD())) then
					if (((20788 - 16239) > (1927 - (431 + 343))) and v24(v97.Execute, not v101)) then
						return "execute hac 67";
					end
				end
				if ((v97.ThunderClap:IsReady() and v47 and (v105 > (3 - 1)) and v97.BloodandThunder:IsAvailable() and v97.Rend:IsAvailable() and v15:DebuffRefreshable(v97.RendDebuff)) or ((13521 - 8847) < (3691 + 981))) then
					if (((470 + 3198) < (6256 - (556 + 1139))) and v24(v97.ThunderClap, not v101)) then
						return "thunder_clap hac 68";
					end
				end
				if ((v97.SweepingStrikes:IsCastable() and v46 and (v105 >= (17 - (6 + 9))) and ((v97.Bladestorm:CooldownRemains() > (3 + 12)) or not v97.Bladestorm:IsAvailable())) or ((234 + 221) == (3774 - (28 + 141)))) then
					if (v24(v97.SweepingStrikes, not v15:IsInMeleeRange(4 + 4)) or ((3286 - 623) == (2346 + 966))) then
						return "sweeping_strikes hac 68";
					end
				end
				if (((5594 - (486 + 831)) <= (11644 - 7169)) and ((v97.Rend:IsReady() and v41 and (v105 == (3 - 2)) and ((v15:HealthPercentage() > (4 + 16)) or (v97.Massacre:IsAvailable() and (v15:HealthPercentage() < (110 - 75))))) or (v97.TideofBlood:IsAvailable() and (v97.Skullsplitter:CooldownRemains() <= v14:GCD()) and ((v97.ColossusSmash:CooldownRemains() < v14:GCD()) or v15:DebuffUp(v97.ColossusSmashDebuff)) and (v15:DebuffRemains(v97.RendDebuff) < ((1284 - (668 + 595)) * (0.85 + 0)))))) then
					if (v24(v97.Rend, not v101) or ((176 + 694) == (3242 - 2053))) then
						return "rend hac 70";
					end
				end
				v132 = 291 - (23 + 267);
			end
			if (((3497 - (1129 + 815)) <= (3520 - (371 + 16))) and (v132 == (1753 - (1326 + 424)))) then
				if (((v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable() and (((v105 > (1 - 0)) and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or ((v105 > (3 - 2)) and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (118 - (88 + 30)))))) or ((3008 - (720 + 51)) >= (7810 - 4299))) then
					if (v24(v97.Bladestorm, not v101) or ((3100 - (421 + 1355)) > (4982 - 1962))) then
						return "bladestorm hac 78";
					end
				end
				if ((v97.Cleave:IsReady() and v35 and ((v105 > (1 + 1)) or (not v97.Battlelord:IsAvailable() and v14:BuffUp(v97.MercilessBonegrinderBuff) and (v97.MortalStrike:CooldownRemains() > v14:GCD())))) or ((4075 - (286 + 797)) == (6876 - 4995))) then
					if (((5144 - 2038) > (1965 - (397 + 42))) and v24(v97.Cleave, not v101)) then
						return "cleave hac 79";
					end
				end
				if (((945 + 2078) < (4670 - (24 + 776))) and v97.Whirlwind:IsReady() and v50 and ((v105 > (2 - 0)) or (v97.StormofSwords:IsAvailable() and (v14:BuffUp(v97.MercilessBonegrinderBuff) or v14:BuffUp(v97.HurricaneBuff))))) then
					if (((928 - (222 + 563)) > (162 - 88)) and v24(v97.Whirlwind, not v15:IsInMeleeRange(6 + 2))) then
						return "whirlwind hac 80";
					end
				end
				if (((208 - (23 + 167)) < (3910 - (690 + 1108))) and v97.Skullsplitter:IsCastable() and v44 and ((v14:Rage() < (15 + 25)) or (v97.TideofBlood:IsAvailable() and (v15:DebuffRemains(v97.RendDebuff) > (0 + 0)) and ((v14:BuffUp(v97.SweepingStrikes) and (v105 > (850 - (40 + 808)))) or v15:DebuffUp(v97.ColossusSmashDebuff) or v14:BuffUp(v97.TestofMightBuff))))) then
					if (((181 + 916) <= (6225 - 4597)) and v24(v97.Skullsplitter, not v15:IsInMeleeRange(8 + 0))) then
						return "sweeping_strikes execute 81";
					end
				end
				v132 = 3 + 1;
			end
			if (((2539 + 2091) == (5201 - (47 + 524))) and (v132 == (6 + 2))) then
				if (((9676 - 6136) > (4011 - 1328)) and v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable())) then
					if (((10932 - 6138) >= (5001 - (1165 + 561))) and v24(v97.Shockwave, not v15:IsInMeleeRange(1 + 7))) then
						return "shockwave hac 97";
					end
				end
				if (((4595 - 3111) == (567 + 917)) and v30 and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable()) then
					if (((1911 - (341 + 138)) < (960 + 2595)) and v24(v97.Bladestorm, not v101)) then
						return "bladestorm hac 98";
					end
				end
				break;
			end
			if ((v132 == (12 - 6)) or ((1391 - (89 + 237)) > (11510 - 7932))) then
				if ((v97.Overpower:IsCastable() and v40 and (((v97.Overpower:Charges() == (3 - 1)) and (not v97.TestofMight:IsAvailable() or (v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)) or v97.Battlelord:IsAvailable())) or (v14:Rage() < (951 - (581 + 300))))) or ((6015 - (855 + 365)) < (3341 - 1934))) then
					if (((606 + 1247) < (6048 - (1030 + 205))) and v24(v97.Overpower, not v101)) then
						return "overpower hac 89";
					end
				end
				if ((v97.ThunderClap:IsReady() and v47 and (v105 > (2 + 0))) or ((2625 + 196) < (2717 - (156 + 130)))) then
					if (v24(v97.ThunderClap, not v101) or ((6529 - 3655) < (3675 - 1494))) then
						return "thunder_clap hac 90";
					end
				end
				if ((v97.MortalStrike:IsReady() and v39) or ((5506 - 2817) <= (91 + 252))) then
					if (v24(v97.MortalStrike, not v101) or ((1090 + 779) == (2078 - (10 + 59)))) then
						return "mortal_strike hac 91";
					end
				end
				if ((v97.Rend:IsReady() and v41 and (v105 == (1 + 0)) and v15:DebuffRefreshable(v97.RendDebuff)) or ((17463 - 13917) < (3485 - (671 + 492)))) then
					if (v24(v97.Rend, not v101) or ((1658 + 424) == (5988 - (369 + 846)))) then
						return "rend hac 92";
					end
				end
				v132 = 2 + 5;
			end
			if (((2769 + 475) > (3000 - (1036 + 909))) and (v132 == (2 + 0))) then
				if (((v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)) or ((v105 > (1 - 0)) and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (203 - (11 + 192)))))) or ((1675 + 1638) <= (1953 - (135 + 40)))) then
					if (v24(v97.ThunderousRoar, not v15:IsInMeleeRange(19 - 11)) or ((857 + 564) >= (4635 - 2531))) then
						return "thunderous_roar hac 75";
					end
				end
				if (((2715 - 903) <= (3425 - (50 + 126))) and (v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "player") and v97.ChampionsSpear:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) then
					if (((4519 - 2896) <= (434 + 1523)) and v24(v99.ChampionsSpearPlayer, not v15:IsSpellInRange(v97.ChampionsSpear))) then
						return "spear_of_bastion hac 76";
					end
				end
				if (((5825 - (1233 + 180)) == (5381 - (522 + 447))) and (v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "cursor") and v97.ChampionsSpear:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) then
					if (((3171 - (107 + 1314)) >= (391 + 451)) and v24(v99.ChampionsSpearCursor, not v15:IsSpellInRange(v97.ChampionsSpear))) then
						return "spear_of_bastion hac 76";
					end
				end
				if (((13321 - 8949) > (786 + 1064)) and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable() and v97.Unhinged:IsAvailable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) then
					if (((460 - 228) < (3248 - 2427)) and v24(v97.Bladestorm, not v101)) then
						return "bladestorm hac 77";
					end
				end
				v132 = 1913 - (716 + 1194);
			end
			if (((9 + 509) < (97 + 805)) and (v132 == (510 - (74 + 429)))) then
				if (((5775 - 2781) > (426 + 432)) and v97.Whirlwind:IsReady() and v50 and (v97.StormofSwords:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 > (2 - 1))))) then
					if (v24(v97.Whirlwind, not v15:IsInMeleeRange(6 + 2)) or ((11576 - 7821) <= (2262 - 1347))) then
						return "whirlwind hac 93";
					end
				end
				if (((4379 - (279 + 154)) > (4521 - (454 + 324))) and v97.Cleave:IsReady() and v35 and not v97.CrushingForce:IsAvailable()) then
					if (v24(v97.Cleave, not v101) or ((1051 + 284) >= (3323 - (12 + 5)))) then
						return "cleave hac 94";
					end
				end
				if (((2612 + 2232) > (5740 - 3487)) and v97.IgnorePain:IsReady() and v65 and v97.Battlelord:IsAvailable() and v97.AngerManagement:IsAvailable() and (v14:Rage() > (12 + 18)) and ((v15:HealthPercentage() < (1113 - (277 + 816))) or (v97.Massacre:IsAvailable() and (v15:HealthPercentage() < (149 - 114))))) then
					if (((1635 - (1058 + 125)) == (85 + 367)) and v24(v97.IgnorePain, not v101)) then
						return "ignore_pain hac 95";
					end
				end
				if ((v97.Slam:IsReady() and v45 and v97.CrushingForce:IsAvailable() and (v14:Rage() > (1005 - (815 + 160))) and ((v97.FervorofBattle:IsAvailable() and (v105 == (4 - 3))) or not v97.FervorofBattle:IsAvailable())) or ((10817 - 6260) < (498 + 1589))) then
					if (((11324 - 7450) == (5772 - (41 + 1857))) and v24(v97.Slam, not v101)) then
						return "slam hac 96";
					end
				end
				v132 = 1901 - (1222 + 671);
			end
			if ((v132 == (2 - 1)) or ((2785 - 847) > (6117 - (229 + 953)))) then
				if (((v90 < v103) and v31 and ((v52 and v30) or not v52) and v97.Avatar:IsCastable()) or ((6029 - (1111 + 663)) < (5002 - (874 + 705)))) then
					if (((204 + 1250) <= (1700 + 791)) and v24(v97.Avatar, not v101)) then
						return "avatar hac 71";
					end
				end
				if (((v90 < v103) and v97.Warbreaker:IsCastable() and v49 and ((v57 and v30) or not v57) and (v105 > (1 - 0))) or ((117 + 4040) <= (3482 - (642 + 37)))) then
					if (((1107 + 3746) >= (478 + 2504)) and v24(v97.Warbreaker, not v101)) then
						return "warbreaker hac 72";
					end
				end
				if (((10379 - 6245) > (3811 - (233 + 221))) and (v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) then
					local v192 = 0 - 0;
					while true do
						if ((v192 == (0 + 0)) or ((4958 - (718 + 823)) < (1595 + 939))) then
							if (v93.CastCycle(v97.ColossusSmash, v104, v107, not v101) or ((3527 - (266 + 539)) <= (464 - 300))) then
								return "colossus_smash hac 73";
							end
							if (v24(v97.ColossusSmash, not v101) or ((3633 - (636 + 589)) < (5005 - 2896))) then
								return "colossus_smash hac 73";
							end
							break;
						end
					end
				end
				if (((v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) or ((67 - 34) == (1154 + 301))) then
					if (v24(v97.ColossusSmash, not v101) or ((161 + 282) >= (5030 - (657 + 358)))) then
						return "colossus_smash hac 74";
					end
				end
				v132 = 4 - 2;
			end
			if (((7704 - 4322) > (1353 - (1151 + 36))) and (v132 == (4 + 0))) then
				if ((v97.MortalStrike:IsReady() and v39 and v14:BuffUp(v97.SweepingStrikes) and (v14:BuffStack(v97.CrushingAdvanceBuff) == (1 + 2))) or ((836 - 556) == (4891 - (1552 + 280)))) then
					if (((2715 - (64 + 770)) > (878 + 415)) and v24(v97.MortalStrike, not v101)) then
						return "mortal_strike hac 81.5";
					end
				end
				if (((5350 - 2993) == (419 + 1938)) and v97.Overpower:IsCastable() and v40 and v14:BuffUp(v97.SweepingStrikes) and v97.Dreadnaught:IsAvailable()) then
					if (((1366 - (157 + 1086)) == (246 - 123)) and v24(v97.Overpower, not v101)) then
						return "overpower hac 82";
					end
				end
				if ((v97.MortalStrike:IsReady() and v39) or ((4624 - 3568) >= (5202 - 1810))) then
					local v193 = 0 - 0;
					while true do
						if (((819 - (599 + 220)) == v193) or ((2152 - 1071) < (3006 - (1813 + 118)))) then
							if (v93.CastCycle(v97.MortalStrike, v104, v108, not v101) or ((767 + 282) >= (5649 - (841 + 376)))) then
								return "mortal_strike hac 83";
							end
							if (v24(v97.MortalStrike, not v101) or ((6680 - 1912) <= (197 + 649))) then
								return "mortal_strike hac 83";
							end
							break;
						end
					end
				end
				if ((v97.Execute:IsReady() and v37 and (v14:BuffUp(v97.SuddenDeathBuff) or ((v105 <= (5 - 3)) and ((v15:HealthPercentage() < (879 - (464 + 395))) or (v97.Massacre:IsAvailable() and (v15:HealthPercentage() < (89 - 54))))) or v14:BuffUp(v97.SweepingStrikes))) or ((1613 + 1745) <= (2257 - (467 + 370)))) then
					local v194 = 0 - 0;
					while true do
						if ((v194 == (0 + 0)) or ((12817 - 9078) <= (469 + 2536))) then
							if (v93.CastCycle(v97.Execute, v104, v109, not v101) or ((3859 - 2200) >= (2654 - (150 + 370)))) then
								return "execute hac 84";
							end
							if (v24(v97.Execute, not v101) or ((4542 - (74 + 1208)) < (5792 - 3437))) then
								return "execute hac 84";
							end
							break;
						end
					end
				end
				v132 = 23 - 18;
			end
		end
	end
	local function v114()
		local v133 = 0 + 0;
		while true do
			if ((v133 == (393 - (14 + 376))) or ((1159 - 490) == (2733 + 1490))) then
				if (((v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "cursor") and v97.ChampionsSpear:IsCastable() and (v15:DebuffUp(v97.ColossusSmashDebuff) or v14:BuffUp(v97.TestofMightBuff))) or ((1487 + 205) < (561 + 27))) then
					if (v24(v99.ChampionsSpearCursor, not v15:IsSpellInRange(v97.ChampionsSpear)) or ((14055 - 9258) < (2747 + 904))) then
						return "spear_of_bastion execute 57";
					end
				end
				if ((v97.Cleave:IsReady() and v35 and (v105 > (80 - (23 + 55))) and (v15:DebuffRemains(v97.DeepWoundsDebuff) < v14:GCD())) or ((9898 - 5721) > (3237 + 1613))) then
					if (v24(v97.Cleave, not v101) or ((360 + 40) > (1722 - 611))) then
						return "cleave execute 58";
					end
				end
				if (((960 + 2091) > (1906 - (652 + 249))) and v97.MortalStrike:IsReady() and v39 and ((v15:DebuffStack(v97.ExecutionersPrecisionDebuff) == (5 - 3)) or (v15:DebuffRemains(v97.DeepWoundsDebuff) <= v14:GCD()))) then
					if (((5561 - (708 + 1160)) <= (11894 - 7512)) and v24(v97.MortalStrike, not v101)) then
						return "mortal_strike execute 59";
					end
				end
				v133 = 6 - 2;
			end
			if ((v133 == (29 - (10 + 17))) or ((738 + 2544) > (5832 - (1400 + 332)))) then
				if ((v97.Skullsplitter:IsCastable() and v44 and ((v97.TestofMight:IsAvailable() and (v14:RagePercentage() <= (57 - 27))) or (not v97.TestofMight:IsAvailable() and (v15:DebuffUp(v97.ColossusSmashDebuff) or (v97.ColossusSmash:CooldownRemains() > (1913 - (242 + 1666)))) and (v14:RagePercentage() <= (13 + 17))))) or ((1313 + 2267) < (2424 + 420))) then
					if (((1029 - (850 + 90)) < (7864 - 3374)) and v24(v97.Skullsplitter, not v15:IsInMeleeRange(1398 - (360 + 1030)))) then
						return "skullsplitter execute 57";
					end
				end
				if (((v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or ((4410 + 573) < (5102 - 3294))) then
					if (((5267 - 1438) > (5430 - (909 + 752))) and v24(v97.ThunderousRoar, not v15:IsInMeleeRange(1231 - (109 + 1114)))) then
						return "thunderous_roar execute 57";
					end
				end
				if (((2718 - 1233) <= (1131 + 1773)) and (v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "player") and v97.ChampionsSpear:IsCastable() and (v15:DebuffUp(v97.ColossusSmashDebuff) or v14:BuffUp(v97.TestofMightBuff))) then
					if (((4511 - (6 + 236)) == (2690 + 1579)) and v24(v99.ChampionsSpearPlayer, not v15:IsSpellInRange(v97.ChampionsSpear))) then
						return "spear_of_bastion execute 57";
					end
				end
				v133 = 3 + 0;
			end
			if (((912 - 525) <= (4859 - 2077)) and (v133 == (1133 - (1076 + 57)))) then
				if (((v90 < v103) and v46 and v97.SweepingStrikes:IsCastable() and (v105 > (1 + 0))) or ((2588 - (579 + 110)) <= (73 + 844))) then
					if (v24(v97.SweepingStrikes, not v15:IsInMeleeRange(8 + 0)) or ((2289 + 2023) <= (1283 - (174 + 233)))) then
						return "sweeping_strikes execute 51";
					end
				end
				if (((6234 - 4002) <= (4556 - 1960)) and v97.Rend:IsReady() and v41 and (v15:DebuffRemains(v97.RendDebuff) <= v14:GCD()) and not v97.Bloodletting:IsAvailable() and ((not v97.Warbreaker:IsAvailable() and (v97.ColossusSmash:CooldownRemains() < (2 + 2))) or (v97.Warbreaker:IsAvailable() and (v97.Warbreaker:CooldownRemains() < (1178 - (663 + 511))))) and (v15:TimeToDie() > (11 + 1))) then
					if (((455 + 1640) < (11363 - 7677)) and v24(v97.Rend, not v101)) then
						return "rend execute 52";
					end
				end
				if (((v90 < v103) and v31 and ((v52 and v30) or not v52) and v97.Avatar:IsCastable() and (v97.ColossusSmash:CooldownUp() or v15:DebuffUp(v97.ColossusSmashDebuff) or (v103 < (13 + 7)))) or ((3754 - 2159) >= (10830 - 6356))) then
					if (v24(v97.Avatar, not v101) or ((2205 + 2414) < (5609 - 2727))) then
						return "avatar execute 53";
					end
				end
				v133 = 1 + 0;
			end
			if ((v133 == (1 + 4)) or ((1016 - (478 + 244)) >= (5348 - (440 + 77)))) then
				if (((923 + 1106) <= (11287 - 8203)) and v97.Overpower:IsCastable() and v40) then
					if (v24(v97.Overpower, not v101) or ((3593 - (655 + 901)) == (449 + 1971))) then
						return "overpower execute 64";
					end
				end
				if (((3413 + 1045) > (2637 + 1267)) and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable()) then
					if (((1756 - 1320) >= (1568 - (695 + 750))) and v24(v97.Bladestorm, not v101)) then
						return "bladestorm execute 65";
					end
				end
				break;
			end
			if (((1707 - 1207) < (2801 - 985)) and (v133 == (15 - 11))) then
				if (((3925 - (285 + 66)) == (8330 - 4756)) and v97.Overpower:IsCastable() and v40 and (v14:Rage() < (1350 - (682 + 628))) and (v14:BuffStack(v97.MartialProwessBuff) < (1 + 1))) then
					if (((520 - (176 + 123)) < (164 + 226)) and v24(v97.Overpower, not v101)) then
						return "overpower execute 60";
					end
				end
				if ((v97.Execute:IsReady() and v37) or ((1606 + 607) <= (1690 - (239 + 30)))) then
					if (((832 + 2226) < (4672 + 188)) and v24(v97.Execute, not v101)) then
						return "execute execute 62";
					end
				end
				if ((v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable() or v15:IsCasting())) or ((2293 - 997) >= (13870 - 9424))) then
					if (v24(v97.Shockwave, not v15:IsInMeleeRange(323 - (306 + 9))) or ((4860 - 3467) > (781 + 3708))) then
						return "shockwave execute 63";
					end
				end
				v133 = 4 + 1;
			end
			if ((v133 == (1 + 0)) or ((12650 - 8226) < (1402 - (1140 + 235)))) then
				if (((v90 < v103) and v49 and ((v57 and v30) or not v57) and v97.Warbreaker:IsCastable()) or ((1271 + 726) > (3499 + 316))) then
					if (((890 + 2575) > (1965 - (33 + 19))) and v24(v97.Warbreaker, not v101)) then
						return "warbreaker execute 54";
					end
				end
				if (((265 + 468) < (5451 - 3632)) and (v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) then
					if (v24(v97.ColossusSmash, not v101) or ((1937 + 2458) == (9324 - 4569))) then
						return "colossus_smash execute 55";
					end
				end
				if ((v97.Execute:IsReady() and v37 and v14:BuffUp(v97.SuddenDeathBuff) and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (0 + 0))) or ((4482 - (586 + 103)) < (216 + 2153))) then
					if (v24(v97.Execute, not v101) or ((12573 - 8489) == (1753 - (1309 + 179)))) then
						return "execute execute 56";
					end
				end
				v133 = 2 - 0;
			end
		end
	end
	local function v115()
		local v134 = 0 + 0;
		while true do
			if (((11703 - 7345) == (3292 + 1066)) and (v134 == (1 - 0))) then
				if (((v90 < v103) and v31 and ((v52 and v30) or not v52) and v97.Avatar:IsCastable() and ((v97.WarlordsTorment:IsAvailable() and (v14:RagePercentage() < (65 - 32)) and (v97.ColossusSmash:CooldownUp() or v15:DebuffUp(v97.ColossusSmashDebuff) or v14:BuffUp(v97.TestofMightBuff))) or (not v97.WarlordsTorment:IsAvailable() and (v97.ColossusSmash:CooldownUp() or v15:DebuffUp(v97.ColossusSmashDebuff))))) or ((3747 - (295 + 314)) < (2438 - 1445))) then
					if (((5292 - (1300 + 662)) > (7294 - 4971)) and v24(v97.Avatar, not v101)) then
						return "avatar single_target 101";
					end
				end
				if (((v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "player") and v97.ChampionsSpear:IsCastable() and ((v97.ColossusSmash:CooldownRemains() <= v14:GCD()) or (v97.Warbreaker:CooldownRemains() <= v14:GCD()))) or ((5381 - (1178 + 577)) == (2072 + 1917))) then
					if (v24(v99.ChampionsSpearPlayer, not v15:IsSpellInRange(v97.ChampionsSpear)) or ((2707 - 1791) == (4076 - (851 + 554)))) then
						return "spear_of_bastion single_target 102";
					end
				end
				if (((241 + 31) == (753 - 481)) and (v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "cursor") and v97.ChampionsSpear:IsCastable() and ((v97.ColossusSmash:CooldownRemains() <= v14:GCD()) or (v97.Warbreaker:CooldownRemains() <= v14:GCD()))) then
					if (((9227 - 4978) <= (5141 - (115 + 187))) and v24(v99.ChampionsSpearCursor, not v15:IsSpellInRange(v97.ChampionsSpear))) then
						return "spear_of_bastion single_target 102";
					end
				end
				if (((2127 + 650) < (3030 + 170)) and (v90 < v103) and v49 and ((v57 and v30) or not v57) and v97.Warbreaker:IsCastable()) then
					if (((374 - 279) < (3118 - (160 + 1001))) and v24(v97.Warbreaker, not v15:IsInRange(7 + 1))) then
						return "warbreaker single_target 103";
					end
				end
				v134 = 2 + 0;
			end
			if (((1690 - 864) < (2075 - (237 + 121))) and ((900 - (525 + 372)) == v134)) then
				if (((2702 - 1276) >= (3630 - 2525)) and v97.Whirlwind:IsReady() and v50 and v97.StormofSwords:IsAvailable() and v97.TestofMight:IsAvailable() and (v14:RagePercentage() > (222 - (96 + 46))) and v15:DebuffUp(v97.ColossusSmashDebuff)) then
					if (((3531 - (643 + 134)) <= (1220 + 2159)) and v24(v97.Whirlwind, not v15:IsInMeleeRange(19 - 11))) then
						return "whirlwind single_target 108";
					end
				end
				if ((v97.ThunderClap:IsReady() and v47 and (v15:DebuffRemains(v97.RendDebuff) <= v14:GCD()) and not v97.TideofBlood:IsAvailable()) or ((14579 - 10652) == (1356 + 57))) then
					if (v24(v97.ThunderClap, not v101) or ((2264 - 1110) <= (1610 - 822))) then
						return "thunder_clap single_target 109";
					end
				end
				if (((v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable() and ((v97.Hurricane:IsAvailable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or (v97.Unhinged:IsAvailable() and (v14:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))))) or ((2362 - (316 + 403)) > (2247 + 1132))) then
					if (v24(v97.Bladestorm, not v101) or ((7706 - 4903) > (1644 + 2905))) then
						return "bladestorm single_target 110";
					end
				end
				if ((v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable() or v15:IsCasting())) or ((554 - 334) >= (2142 + 880))) then
					if (((910 + 1912) == (9777 - 6955)) and v24(v97.Shockwave, not v15:IsInMeleeRange(38 - 30))) then
						return "shockwave single_target 111";
					end
				end
				v134 = 7 - 3;
			end
			if (((1 + 3) == v134) or ((2088 - 1027) == (91 + 1766))) then
				if (((8120 - 5360) > (1381 - (12 + 5))) and v97.Whirlwind:IsReady() and v50 and v97.StormofSwords:IsAvailable() and v97.TestofMight:IsAvailable() and (v97.ColossusSmash:CooldownRemains() > (v14:GCD() * (27 - 20)))) then
					if (v24(v97.Whirlwind, not v15:IsInMeleeRange(16 - 8)) or ((10419 - 5517) <= (8915 - 5320))) then
						return "whirlwind single_target 113";
					end
				end
				if ((v97.Overpower:IsCastable() and v40 and (((v97.Overpower:Charges() == (1 + 1)) and not v97.Battlelord:IsAvailable() and (v15:DebuffUp(v97.ColossusSmashDebuff) or (v14:RagePercentage() < (1998 - (1656 + 317))))) or v97.Battlelord:IsAvailable())) or ((3433 + 419) == (235 + 58))) then
					if (v24(v97.Overpower, not v101) or ((4145 - 2586) == (22579 - 17991))) then
						return "overpower single_target 114";
					end
				end
				if ((v97.Slam:IsReady() and v45 and ((v97.CrushingForce:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff) and (v14:Rage() >= (414 - (5 + 349))) and v97.TestofMight:IsAvailable()) or v97.ImprovedSlam:IsAvailable()) and (not v97.FervorofBattle:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 == (4 - 3))))) or ((5755 - (266 + 1005)) == (520 + 268))) then
					if (((15586 - 11018) >= (5143 - 1236)) and v24(v97.Slam, not v101)) then
						return "slam single_target 115";
					end
				end
				if (((2942 - (561 + 1135)) < (4521 - 1051)) and v97.Whirlwind:IsReady() and v50 and (v97.StormofSwords:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 > (3 - 2))))) then
					if (((5134 - (507 + 559)) >= (2438 - 1466)) and v24(v97.Whirlwind, not v15:IsInMeleeRange(24 - 16))) then
						return "whirlwind single_target 116";
					end
				end
				v134 = 393 - (212 + 176);
			end
			if (((1398 - (250 + 655)) < (10615 - 6722)) and (v134 == (0 - 0))) then
				if (((v90 < v103) and v46 and v97.SweepingStrikes:IsCastable() and (v105 > (1 - 0))) or ((3429 - (1869 + 87)) >= (11556 - 8224))) then
					if (v24(v97.SweepingStrikes, not v15:IsInMeleeRange(1909 - (484 + 1417))) or ((8682 - 4631) <= (1938 - 781))) then
						return "sweeping_strikes single_target 97";
					end
				end
				if (((1377 - (48 + 725)) < (4706 - 1825)) and v97.Execute:IsReady() and (v14:BuffUp(v97.SuddenDeathBuff))) then
					if (v24(v97.Execute, not v101) or ((2414 - 1514) == (1963 + 1414))) then
						return "execute single_target 98";
					end
				end
				if (((11916 - 7457) > (166 + 425)) and v97.MortalStrike:IsReady() and v39) then
					if (((991 + 2407) >= (3248 - (152 + 701))) and v24(v97.MortalStrike, not v101)) then
						return "mortal_strike single_target 99";
					end
				end
				if ((v97.Rend:IsReady() and v41 and ((v15:DebuffRemains(v97.RendDebuff) <= v14:GCD()) or (v97.TideofBlood:IsAvailable() and (v97.Skullsplitter:CooldownRemains() <= v14:GCD()) and ((v97.ColossusSmash:CooldownRemains() <= v14:GCD()) or v15:DebuffUp(v97.ColossusSmashDebuff)) and (v15:DebuffRemains(v97.RendDebuff) < (v97.RendDebuff:BaseDuration() * (1311.85 - (430 + 881))))))) or ((837 + 1346) >= (3719 - (557 + 338)))) then
					if (((573 + 1363) == (5455 - 3519)) and v24(v97.Rend, not v101)) then
						return "rend single_target 100";
					end
				end
				v134 = 3 - 2;
			end
			if (((15 - 9) == v134) or ((10413 - 5581) < (5114 - (499 + 302)))) then
				if (((4954 - (39 + 827)) > (10694 - 6820)) and v97.Cleave:IsReady() and v35 and v14:HasTier(64 - 35, 7 - 5) and not v97.CrushingForce:IsAvailable()) then
					if (((6650 - 2318) == (371 + 3961)) and v24(v97.Cleave, not v101)) then
						return "cleave single_target 121";
					end
				end
				if (((11704 - 7705) >= (464 + 2436)) and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable()) then
					if (v24(v97.Bladestorm, not v101) or ((3995 - 1470) > (4168 - (103 + 1)))) then
						return "bladestorm single_target 122";
					end
				end
				if (((4925 - (475 + 79)) == (9449 - 5078)) and v97.Cleave:IsReady() and v35) then
					if (v24(v97.Cleave, not v101) or ((851 - 585) > (645 + 4341))) then
						return "cleave single_target 123";
					end
				end
				if (((1753 + 238) >= (2428 - (1395 + 108))) and v97.Rend:IsReady() and v41 and v15:DebuffRefreshable(v97.RendDebuff) and not v97.CrushingForce:IsAvailable()) then
					if (((1324 - 869) < (3257 - (7 + 1197))) and v24(v97.Rend, not v101)) then
						return "rend single_target 124";
					end
				end
				break;
			end
			if ((v134 == (1 + 1)) or ((289 + 537) == (5170 - (27 + 292)))) then
				if (((535 - 352) == (232 - 49)) and (v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) then
					if (((4860 - 3701) <= (3525 - 1737)) and v24(v97.ColossusSmash, not v101)) then
						return "colossus_smash single_target 104";
					end
				end
				if ((v97.Skullsplitter:IsCastable() and v44 and not v97.TestofMight:IsAvailable() and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (0 - 0)) and (v15:DebuffUp(v97.ColossusSmashDebuff) or (v97.ColossusSmash:CooldownRemains() > (142 - (43 + 96))))) or ((14305 - 10798) > (9762 - 5444))) then
					if (v24(v97.Skullsplitter, not v101) or ((2552 + 523) <= (838 + 2127))) then
						return "skullsplitter single_target 105";
					end
				end
				if (((2697 - 1332) <= (771 + 1240)) and v97.Skullsplitter:IsCastable() and v44 and v97.TestofMight:IsAvailable() and (v15:DebuffRemains(v97.DeepWoundsDebuff) > (0 - 0))) then
					if (v24(v97.Skullsplitter, not v101) or ((874 + 1902) > (263 + 3312))) then
						return "skullsplitter single_target 106";
					end
				end
				if (((v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable() and (v14:BuffUp(v97.TestofMightBuff) or (v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff) and (v14:RagePercentage() < (1784 - (1414 + 337)))) or (not v97.TestofMight:IsAvailable() and v15:DebuffUp(v97.ColossusSmashDebuff)))) or ((4494 - (1642 + 298)) == (12523 - 7719))) then
					if (((7413 - 4836) == (7647 - 5070)) and v24(v97.ThunderousRoar, not v15:IsInMeleeRange(3 + 5))) then
						return "thunderous_roar single_target 107";
					end
				end
				v134 = 3 + 0;
			end
			if ((v134 == (977 - (357 + 615))) or ((5 + 1) >= (4634 - 2745))) then
				if (((434 + 72) <= (4054 - 2162)) and v97.Slam:IsReady() and v45 and (v97.CrushingForce:IsAvailable() or (not v97.CrushingForce:IsAvailable() and (v14:Rage() >= (24 + 6)))) and (not v97.FervorofBattle:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 == (1 + 0))))) then
					if (v24(v97.Slam, not v101) or ((1263 + 745) > (3519 - (384 + 917)))) then
						return "slam single_target 117";
					end
				end
				if (((1076 - (128 + 569)) <= (5690 - (1407 + 136))) and v97.ThunderClap:IsReady() and v47 and v97.Battlelord:IsAvailable() and v97.BloodandThunder:IsAvailable()) then
					if (v24(v97.ThunderClap, not v101) or ((6401 - (687 + 1200)) <= (2719 - (556 + 1154)))) then
						return "thunder_clap single_target 118";
					end
				end
				if ((v97.Overpower:IsCastable() and v40 and ((v15:DebuffDown(v97.ColossusSmashDebuff) and (v14:RagePercentage() < (175 - 125)) and not v97.Battlelord:IsAvailable()) or (v14:RagePercentage() < (120 - (9 + 86))))) or ((3917 - (275 + 146)) == (194 + 998))) then
					if (v24(v97.Overpower, not v101) or ((272 - (29 + 35)) == (13114 - 10155))) then
						return "overpower single_target 119";
					end
				end
				if (((12774 - 8497) >= (5796 - 4483)) and v97.Whirlwind:IsReady() and v50 and v14:BuffUp(v97.MercilessBonegrinderBuff)) then
					if (((1685 + 902) < (4186 - (53 + 959))) and v24(v97.Whirlwind, not v15:IsInRange(416 - (312 + 96)))) then
						return "whirlwind single_target 120";
					end
				end
				v134 = 10 - 4;
			end
		end
	end
	local function v116()
		if (not v14:AffectingCombat() or ((4405 - (147 + 138)) <= (3097 - (813 + 86)))) then
			if ((v97.BattleStance:IsCastable() and v14:BuffDown(v97.BattleStance, true)) or ((1443 + 153) == (1589 - 731))) then
				if (((3712 - (18 + 474)) == (1087 + 2133)) and v24(v97.BattleStance)) then
					return "battle_stance";
				end
			end
			if ((v97.BattleShout:IsCastable() and v32 and (v14:BuffDown(v97.BattleShoutBuff, true) or v93.GroupBuffMissing(v97.BattleShoutBuff))) or ((4575 - 3173) > (4706 - (860 + 226)))) then
				if (((2877 - (121 + 182)) == (317 + 2257)) and v24(v97.BattleShout)) then
					return "battle_shout precombat";
				end
			end
		end
		if (((3038 - (988 + 252)) < (312 + 2445)) and v93.TargetIsValid() and v28) then
			if (not v14:AffectingCombat() or ((119 + 258) > (4574 - (49 + 1921)))) then
				v27 = v112();
				if (((1458 - (223 + 667)) < (963 - (51 + 1))) and v27) then
					return v27;
				end
			end
		end
	end
	local function v117()
		local v135 = 0 - 0;
		while true do
			if (((7034 - 3749) < (5353 - (146 + 979))) and (v135 == (0 + 0))) then
				v27 = v110();
				if (((4521 - (311 + 294)) > (9280 - 5952)) and v27) then
					return v27;
				end
				v135 = 1 + 0;
			end
			if (((3943 - (496 + 947)) < (5197 - (1233 + 125))) and (v135 == (1 + 0))) then
				if (((455 + 52) == (97 + 410)) and v85) then
					v27 = v93.HandleIncorporeal(v97.StormBolt, v99.StormBoltMouseover, 1665 - (963 + 682), true);
					if (((201 + 39) <= (4669 - (504 + 1000))) and v27) then
						return v27;
					end
					v27 = v93.HandleIncorporeal(v97.IntimidatingShout, v99.IntimidatingShoutMouseover, 6 + 2, true);
					if (((760 + 74) >= (76 + 729)) and v27) then
						return v27;
					end
				end
				if (v93.TargetIsValid() or ((5620 - 1808) < (1979 + 337))) then
					local v195 = 0 + 0;
					local v196;
					while true do
						if ((v195 == (183 - (156 + 26))) or ((1528 + 1124) <= (2397 - 864))) then
							if ((v90 < v103) or ((3762 - (149 + 15)) < (2420 - (890 + 70)))) then
								local v200 = 117 - (39 + 78);
								while true do
									if ((v200 == (482 - (14 + 468))) or ((9051 - 4935) < (3331 - 2139))) then
										if ((v92 and ((v30 and v58) or not v58)) or ((1743 + 1634) <= (543 + 360))) then
											local v204 = 0 + 0;
											while true do
												if (((1796 + 2180) >= (116 + 323)) and (v204 == (0 - 0))) then
													v27 = v111();
													if (((3709 + 43) == (13184 - 9432)) and v27) then
														return v27;
													end
													break;
												end
											end
										end
										if (((103 + 3943) > (2746 - (12 + 39))) and v30 and v98.FyralathTheDreamrender:IsEquippedAndReady()) then
											if (v24(v99.UseWeapon) or ((3299 + 246) == (9895 - 6698))) then
												return "Fyralath The Dreamrender used";
											end
										end
										break;
									end
								end
							end
							if (((8526 - 6132) > (111 + 262)) and v38 and v97.HeroicThrow:IsCastable() and not v15:IsInRange(14 + 11) and v14:CanAttack(v15)) then
								if (((10536 - 6381) <= (2819 + 1413)) and v24(v97.HeroicThrow, not v15:IsSpellInRange(v97.HeroicThrow))) then
									return "heroic_throw main";
								end
							end
							if ((v97.WreckingThrow:IsCastable() and v51 and v106() and v14:CanAttack(v15)) or ((17306 - 13725) == (5183 - (1596 + 114)))) then
								if (((13041 - 8046) > (4061 - (164 + 549))) and v24(v97.WreckingThrow, not v15:IsSpellInRange(v97.WreckingThrow))) then
									return "wrecking_throw main";
								end
							end
							if ((v29 and (v105 > (1440 - (1059 + 379)))) or ((935 - 181) > (1931 + 1793))) then
								local v201 = 0 + 0;
								while true do
									if (((609 - (145 + 247)) >= (47 + 10)) and (v201 == (0 + 0))) then
										v27 = v113();
										if (v27 or ((6137 - 4067) >= (775 + 3262))) then
											return v27;
										end
										break;
									end
								end
							end
							v195 = 2 + 0;
						end
						if (((4391 - 1686) == (3425 - (254 + 466))) and ((560 - (544 + 16)) == v195)) then
							if (((193 - 132) == (689 - (294 + 334))) and v34 and v97.Charge:IsCastable() and not v101) then
								if (v24(v97.Charge, not v15:IsSpellInRange(v97.Charge)) or ((952 - (236 + 17)) >= (559 + 737))) then
									return "charge main 34";
								end
							end
							v196 = v93.HandleDPSPotion(v15:DebuffUp(v97.ColossusSmashDebuff));
							if (v196 or ((1388 + 395) >= (13617 - 10001))) then
								return v196;
							end
							if ((v101 and v91 and ((v59 and v30) or not v59) and (v90 < v103)) or ((18526 - 14613) > (2331 + 2196))) then
								local v202 = 0 + 0;
								while true do
									if (((5170 - (413 + 381)) > (35 + 782)) and (v202 == (1 - 0))) then
										if (((12626 - 7765) > (2794 - (582 + 1388))) and v97.ArcaneTorrent:IsCastable() and (v97.MortalStrike:CooldownRemains() > (1.5 - 0)) and (v14:Rage() < (36 + 14))) then
											if (v24(v97.ArcaneTorrent, not v15:IsInRange(372 - (326 + 38))) or ((4090 - 2707) >= (3041 - 910))) then
												return "arcane_torrent main 41";
											end
										end
										if ((v97.LightsJudgment:IsCastable() and v15:DebuffDown(v97.ColossusSmashDebuff) and not v97.MortalStrike:CooldownUp()) or ((2496 - (47 + 573)) >= (896 + 1645))) then
											if (((7568 - 5786) <= (6121 - 2349)) and v24(v97.LightsJudgment, not v15:IsSpellInRange(v97.LightsJudgment))) then
												return "lights_judgment main 42";
											end
										end
										v202 = 1666 - (1269 + 395);
									end
									if ((v202 == (492 - (76 + 416))) or ((5143 - (319 + 124)) < (1858 - 1045))) then
										if (((4206 - (564 + 443)) < (11212 - 7162)) and v97.BloodFury:IsCastable() and v15:DebuffUp(v97.ColossusSmashDebuff)) then
											if (v24(v97.BloodFury) or ((5409 - (337 + 121)) < (12980 - 8550))) then
												return "blood_fury main 39";
											end
										end
										if (((319 - 223) == (2007 - (1261 + 650))) and v97.Berserking:IsCastable() and (v15:DebuffRemains(v97.ColossusSmashDebuff) > (3 + 3))) then
											if (v24(v97.Berserking) or ((4364 - 1625) > (5825 - (772 + 1045)))) then
												return "berserking main 40";
											end
										end
										v202 = 1 + 0;
									end
									if ((v202 == (147 - (102 + 42))) or ((1867 - (1524 + 320)) == (2404 - (1049 + 221)))) then
										if ((v97.BagofTricks:IsCastable() and v15:DebuffDown(v97.ColossusSmashDebuff) and not v97.MortalStrike:CooldownUp()) or ((2849 - (18 + 138)) >= (10062 - 5951))) then
											if (v24(v97.BagofTricks, not v15:IsSpellInRange(v97.BagofTricks)) or ((5418 - (67 + 1035)) <= (2494 - (136 + 212)))) then
												return "bag_of_tricks main 10";
											end
										end
										break;
									end
									if ((v202 == (8 - 6)) or ((2841 + 705) <= (2590 + 219))) then
										if (((6508 - (240 + 1364)) > (3248 - (1050 + 32))) and v97.Fireblood:IsCastable() and (v15:DebuffUp(v97.ColossusSmashDebuff))) then
											if (((389 - 280) >= (54 + 36)) and v24(v97.Fireblood)) then
												return "fireblood main 43";
											end
										end
										if (((6033 - (331 + 724)) > (235 + 2670)) and v97.AncestralCall:IsCastable() and (v15:DebuffUp(v97.ColossusSmashDebuff))) then
											if (v24(v97.AncestralCall) or ((3670 - (269 + 375)) <= (3005 - (267 + 458)))) then
												return "ancestral_call main 44";
											end
										end
										v202 = 1 + 2;
									end
								end
							end
							v195 = 1 - 0;
						end
						if ((v195 == (820 - (667 + 151))) or ((3150 - (1410 + 87)) <= (3005 - (1504 + 393)))) then
							if (((7863 - 4954) > (6768 - 4159)) and ((v97.Massacre:IsAvailable() and (v15:HealthPercentage() < (831 - (461 + 335)))) or (v15:HealthPercentage() < (3 + 17)))) then
								local v203 = 1761 - (1730 + 31);
								while true do
									if (((2424 - (728 + 939)) > (686 - 492)) and (v203 == (0 - 0))) then
										v27 = v114();
										if (v27 or ((70 - 39) >= (2466 - (138 + 930)))) then
											return v27;
										end
										break;
									end
								end
							end
							v27 = v115();
							if (((2921 + 275) <= (3809 + 1063)) and v27) then
								return v27;
							end
							if (((2851 + 475) == (13580 - 10254)) and v20.CastAnnotated(v97.Pool, false, "WAIT")) then
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
		local v136 = 1766 - (459 + 1307);
		while true do
			if (((3303 - (474 + 1396)) <= (6771 - 2893)) and (v136 == (3 + 0))) then
				v44 = EpicSettings.Settings['useSkullsplitter'];
				v45 = EpicSettings.Settings['useSlam'];
				v46 = EpicSettings.Settings['useSweepingStrikes'];
				v136 = 1 + 3;
			end
			if ((v136 == (19 - 12)) or ((201 + 1382) == (5791 - 4056))) then
				v52 = EpicSettings.Settings['avatarWithCD'];
				v53 = EpicSettings.Settings['bladestormWithCD'];
				v54 = EpicSettings.Settings['colossusSmashWithCD'];
				v136 = 34 - 26;
			end
			if ((v136 == (592 - (562 + 29))) or ((2542 + 439) == (3769 - (374 + 1045)))) then
				v37 = EpicSettings.Settings['useExecute'];
				v38 = EpicSettings.Settings['useHeroicThrow'];
				v39 = EpicSettings.Settings['useMortalStrike'];
				v136 = 2 + 0;
			end
			if ((v136 == (12 - 8)) or ((5104 - (448 + 190)) <= (160 + 333))) then
				v47 = EpicSettings.Settings['useThunderClap'];
				v50 = EpicSettings.Settings['useWhirlwind'];
				v51 = EpicSettings.Settings['useWreckingThrow'];
				v136 = 3 + 2;
			end
			if ((v136 == (2 + 0)) or ((9792 - 7245) <= (6174 - 4187))) then
				v40 = EpicSettings.Settings['useOverpower'];
				v41 = EpicSettings.Settings['useRend'];
				v43 = EpicSettings.Settings['useShockwave'];
				v136 = 1497 - (1307 + 187);
			end
			if (((11741 - 8780) > (6415 - 3675)) and ((15 - 10) == v136)) then
				v31 = EpicSettings.Settings['useAvatar'];
				v33 = EpicSettings.Settings['useBladestorm'];
				v36 = EpicSettings.Settings['useColossusSmash'];
				v136 = 689 - (232 + 451);
			end
			if (((3530 + 166) >= (3191 + 421)) and (v136 == (564 - (510 + 54)))) then
				v32 = EpicSettings.Settings['useBattleShout'];
				v34 = EpicSettings.Settings['useCharge'];
				v35 = EpicSettings.Settings['useCleave'];
				v136 = 1 - 0;
			end
			if ((v136 == (44 - (13 + 23))) or ((5789 - 2819) == (2698 - 820))) then
				v55 = EpicSettings.Settings['championsSpearWithCD'];
				v56 = EpicSettings.Settings['thunderousRoarWithCD'];
				v57 = EpicSettings.Settings['warbreakerWithCD'];
				break;
			end
			if ((v136 == (10 - 4)) or ((4781 - (830 + 258)) < (6974 - 4997))) then
				v83 = EpicSettings.Settings['useChampionsSpear'];
				v48 = EpicSettings.Settings['useThunderousRoar'];
				v49 = EpicSettings.Settings['useWarbreaker'];
				v136 = 5 + 2;
			end
		end
	end
	local function v119()
		local v137 = 0 + 0;
		while true do
			if ((v137 == (1441 - (860 + 581))) or ((3430 - 2500) > (1668 + 433))) then
				v60 = EpicSettings.Settings['usePummel'];
				v61 = EpicSettings.Settings['useStormBolt'];
				v62 = EpicSettings.Settings['useIntimidatingShout'];
				v137 = 242 - (237 + 4);
			end
			if (((9759 - 5606) > (7807 - 4721)) and (v137 == (3 - 1))) then
				v65 = EpicSettings.Settings['useIgnorePain'];
				v67 = EpicSettings.Settings['useIntervene'];
				v66 = EpicSettings.Settings['useRallyingCry'];
				v137 = 3 + 0;
			end
			if ((v137 == (3 + 2)) or ((17570 - 12916) <= (1738 + 2312))) then
				v77 = EpicSettings.Settings['interveneHP'] or (0 + 0);
				v76 = EpicSettings.Settings['rallyingCryGroup'] or (1426 - (85 + 1341));
				v75 = EpicSettings.Settings['rallyingCryHP'] or (0 - 0);
				v137 = 16 - 10;
			end
			if ((v137 == (376 - (45 + 327))) or ((4909 - 2307) < (1998 - (444 + 58)))) then
				v81 = EpicSettings.Settings['unstanceHP'] or (0 + 0);
				v73 = EpicSettings.Settings['dieByTheSwordHP'] or (0 + 0);
				v74 = EpicSettings.Settings['ignorePainHP'] or (0 + 0);
				v137 = 14 - 9;
			end
			if ((v137 == (1738 - (64 + 1668))) or ((2993 - (1227 + 746)) > (7032 - 4744))) then
				v82 = EpicSettings.Settings['victoryRushHP'] or (0 - 0);
				v84 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
			if (((822 - (415 + 79)) == (9 + 319)) and (v137 == (494 - (142 + 349)))) then
				v71 = EpicSettings.Settings['useVictoryRush'];
				v72 = EpicSettings.Settings['bitterImmunityHP'] or (0 + 0);
				v78 = EpicSettings.Settings['defensiveStanceHP'] or (0 - 0);
				v137 = 2 + 2;
			end
			if (((1065 + 446) < (10370 - 6562)) and (v137 == (1865 - (1710 + 154)))) then
				v63 = EpicSettings.Settings['useBitterImmunity'];
				v68 = EpicSettings.Settings['useDefensiveStance'];
				v64 = EpicSettings.Settings['useDieByTheSword'];
				v137 = 320 - (200 + 118);
			end
		end
	end
	local function v120()
		local v138 = 0 + 0;
		while true do
			if ((v138 == (0 - 0)) or ((3722 - 1212) > (4371 + 548))) then
				v90 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v87 = EpicSettings.Settings['InterruptWithStun'];
				v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v138 = 1 + 0;
			end
			if (((761 + 4002) == (10318 - 5555)) and (v138 == (1251 - (363 + 887)))) then
				v89 = EpicSettings.Settings['InterruptThreshold'];
				v92 = EpicSettings.Settings['useTrinkets'];
				v91 = EpicSettings.Settings['useRacials'];
				v138 = 2 - 0;
			end
			if (((19691 - 15554) > (286 + 1562)) and (v138 == (4 - 2))) then
				v58 = EpicSettings.Settings['trinketsWithCD'];
				v59 = EpicSettings.Settings['racialsWithCD'];
				v69 = EpicSettings.Settings['useHealthstone'];
				v138 = 3 + 0;
			end
			if (((4100 - (674 + 990)) <= (899 + 2235)) and (v138 == (2 + 2))) then
				v86 = EpicSettings.Settings['HealingPotionName'] or "";
				v85 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((5900 - 2177) == (4778 - (507 + 548))) and (v138 == (840 - (289 + 548)))) then
				v70 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (1818 - (821 + 997));
				v80 = EpicSettings.Settings['healingPotionHP'] or (255 - (195 + 60));
				v138 = 2 + 2;
			end
		end
	end
	local function v121()
		local v139 = 1501 - (251 + 1250);
		while true do
			if (((5 - 3) == v139) or ((2781 + 1265) >= (5348 - (809 + 223)))) then
				v101 = v15:IsInMeleeRange(11 - 3);
				if (v93.TargetIsValid() or v14:AffectingCombat() or ((6030 - 4022) < (6378 - 4449))) then
					local v197 = 0 + 0;
					while true do
						if (((1249 + 1135) > (2392 - (14 + 603))) and ((130 - (118 + 11)) == v197)) then
							if ((v103 == (1798 + 9313)) or ((3784 + 759) <= (12752 - 8376))) then
								v103 = v10.FightRemains(v104, false);
							end
							break;
						end
						if (((1677 - (551 + 398)) == (461 + 267)) and (v197 == (0 + 0))) then
							v102 = v10.BossFightRemains(nil, true);
							v103 = v102;
							v197 = 1 + 0;
						end
					end
				end
				if (not v14:IsChanneling() or ((4001 - 2925) > (10762 - 6091))) then
					if (((600 + 1251) >= (1500 - 1122)) and v14:AffectingCombat()) then
						v27 = v117();
						if (v27 or ((538 + 1410) >= (3565 - (40 + 49)))) then
							return v27;
						end
					else
						local v199 = 0 - 0;
						while true do
							if (((5284 - (99 + 391)) >= (690 + 143)) and ((0 - 0) == v199)) then
								v27 = v116();
								if (((10128 - 6038) == (3984 + 106)) and v27) then
									return v27;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((2 - 1) == v139) or ((5362 - (1032 + 572)) == (2915 - (203 + 214)))) then
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				if (v14:IsDeadOrGhost() or ((4490 - (568 + 1249)) < (1233 + 342))) then
					return v27;
				end
				if (v29 or ((8937 - 5216) <= (5620 - 4165))) then
					local v198 = 1306 - (913 + 393);
					while true do
						if (((2637 - 1703) < (3207 - 937)) and ((410 - (269 + 141)) == v198)) then
							v104 = v14:GetEnemiesInMeleeRange(17 - 9);
							v105 = #v104;
							break;
						end
					end
				else
					v105 = 1982 - (362 + 1619);
				end
				v139 = 1627 - (950 + 675);
			end
			if ((v139 == (0 + 0)) or ((2791 - (216 + 963)) == (2542 - (485 + 802)))) then
				v119();
				v118();
				v120();
				v28 = EpicSettings.Toggles['ooc'];
				v139 = 560 - (432 + 127);
			end
		end
	end
	local function v122()
		v20.Print("Arms Warrior by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(1144 - (1065 + 8), v121, v122);
end;
return v0["Epix_Warrior_Arms.lua"]();

