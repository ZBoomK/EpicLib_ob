local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (551 - (400 + 150))) or ((2072 - 1396) >= (926 + 716))) then
			return v6(...);
		end
		if (((5770 - (1607 + 27)) > (690 + 1707)) and (v5 == (1726 - (1668 + 58)))) then
			v6 = v0[v4];
			if (not v6 or ((4960 - (512 + 114)) == (11067 - 6822))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
	end
end
v0["Epix_Warrior_Protection.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = v10.Unit;
	local v12 = v10.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.TargetTarget;
	local v16 = v11.Focus;
	local v17 = v10.Spell;
	local v18 = v10.Item;
	local v19 = EpicLib;
	local v20 = v19.Bind;
	local v21 = v19.Cast;
	local v22 = v19.Macro;
	local v23 = v19.Press;
	local v24 = v19.Commons.Everyone.num;
	local v25 = v19.Commons.Everyone.bool;
	local v26 = UnitIsUnit;
	local v27 = math.floor;
	local v28 = 17 - 12;
	local v29;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
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
	local v94 = 5169 + 5942;
	local v95 = 2080 + 9031;
	local v96;
	local v97 = v19.Commons.Everyone;
	local v98 = v17.Warrior.Protection;
	local v99 = v18.Warrior.Protection;
	local v100 = v22.Warrior.Protection;
	local v101 = {};
	local v102;
	local v103;
	local v104;
	local function v105()
		local v123 = 0 + 0;
		local v124;
		while true do
			if ((v123 == (0 - 0)) or ((6270 - (109 + 1885)) <= (4500 - (1269 + 200)))) then
				v124 = UnitGetTotalAbsorbs(v14);
				if ((v124 > (0 - 0)) or ((5597 - (98 + 717)) <= (2025 - (802 + 24)))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v106()
		return v13:IsTankingAoE(27 - 11) or v13:IsTanking(v14) or v14:IsDummy();
	end
	local function v107()
		if (v13:BuffUp(v98.IgnorePain) or ((6142 - 1278) < (281 + 1621))) then
			local v147 = 0 + 0;
			local v148;
			local v149;
			local v150;
			while true do
				if (((795 + 4044) >= (799 + 2901)) and (v147 == (2 - 1))) then
					v150 = v149.points[3 - 2];
					return v150 < v148;
				end
				if ((v147 == (0 + 0)) or ((438 + 637) > (1583 + 335))) then
					v148 = v13:AttackPowerDamageMod() * (3.5 + 0) * (1 + 0 + (v13:VersatilityDmgPct() / (1533 - (797 + 636))));
					v149 = v13:AuraInfo(v98.IgnorePain, nil, true);
					v147 = 4 - 3;
				end
			end
		else
			return true;
		end
	end
	local function v108()
		if (((2015 - (1427 + 192)) <= (1319 + 2485)) and v13:BuffUp(v98.IgnorePain)) then
			local v151 = 0 - 0;
			local v152;
			while true do
				if ((v151 == (0 + 0)) or ((1890 + 2279) == (2513 - (192 + 134)))) then
					v152 = v13:BuffInfo(v98.IgnorePain, nil, true);
					return v152.points[1277 - (316 + 960)];
				end
			end
		else
			return 0 + 0;
		end
	end
	local function v109()
		return v106() and v98.ShieldBlock:IsReady() and (((v13:BuffRemains(v98.ShieldBlockBuff) <= (14 + 4)) and v98.EnduringDefenses:IsAvailable()) or (v13:BuffRemains(v98.ShieldBlockBuff) <= (12 + 0)));
	end
	local function v110(v125)
		local v126 = 305 - 225;
		if (((1957 - (83 + 468)) == (3212 - (1202 + 604))) and ((v126 < (163 - 128)) or (v13:Rage() < (57 - 22)))) then
			return false;
		end
		local v127 = false;
		local v128 = (v13:Rage() >= (96 - 61)) and not v109();
		if (((1856 - (45 + 280)) < (4123 + 148)) and v128 and (((v13:Rage() + v125) >= v126) or v98.DemoralizingShout:IsReady())) then
			v127 = true;
		end
		if (((555 + 80) == (232 + 403)) and v127) then
			if (((1867 + 1506) <= (626 + 2930)) and v106() and v107()) then
				if (v23(v98.IgnorePain, nil, nil, true) or ((6094 - 2803) < (5191 - (340 + 1571)))) then
					return "ignore_pain rage capped";
				end
			elseif (((1730 + 2656) >= (2645 - (1733 + 39))) and v23(v98.Revenge, not v102)) then
				return "revenge rage capped";
			end
		end
	end
	local function v111()
		if (((2530 - 1609) <= (2136 - (125 + 909))) and v98.BitterImmunity:IsReady() and v62 and (v13:HealthPercentage() <= v73)) then
			if (((6654 - (1096 + 852)) >= (432 + 531)) and v23(v98.BitterImmunity)) then
				return "bitter_immunity defensive";
			end
		end
		if ((v98.LastStand:IsCastable() and v65 and ((v13:HealthPercentage() <= v76) or v13:ActiveMitigationNeeded())) or ((1370 - 410) <= (850 + 26))) then
			if (v23(v98.LastStand) or ((2578 - (409 + 103)) == (1168 - (46 + 190)))) then
				return "last_stand defensive";
			end
		end
		if (((4920 - (51 + 44)) < (1366 + 3477)) and v98.IgnorePain:IsReady() and v66 and (v13:HealthPercentage() <= v77) and v107()) then
			if (v23(v98.IgnorePain, nil, nil, true) or ((5194 - (1114 + 203)) >= (5263 - (228 + 498)))) then
				return "ignore_pain defensive";
			end
		end
		if ((v98.RallyingCry:IsReady() and v67 and v13:BuffDown(v98.AspectsFavorBuff) and v13:BuffDown(v98.RallyingCry) and (((v13:HealthPercentage() <= v78) and v97.IsSoloMode()) or v97.AreUnitsBelowHealthPercentage(v78, v79))) or ((935 + 3380) < (954 + 772))) then
			if (v23(v98.RallyingCry) or ((4342 - (174 + 489)) < (1628 - 1003))) then
				return "rallying_cry defensive";
			end
		end
		if ((v98.Intervene:IsReady() and v68 and (v16:HealthPercentage() <= v80) and (v16:UnitName() ~= v13:UnitName())) or ((6530 - (830 + 1075)) < (1156 - (303 + 221)))) then
			if (v23(v100.InterveneFocus) or ((1352 - (231 + 1038)) > (1484 + 296))) then
				return "intervene defensive";
			end
		end
		if (((1708 - (171 + 991)) <= (4438 - 3361)) and v98.ShieldWall:IsCastable() and v63 and v13:BuffDown(v98.ShieldWallBuff) and ((v13:HealthPercentage() <= v74) or v13:ActiveMitigationNeeded())) then
			if (v23(v98.ShieldWall) or ((2674 - 1678) > (10732 - 6431))) then
				return "shield_wall defensive";
			end
		end
		if (((3258 + 812) > (2408 - 1721)) and v99.Healthstone:IsReady() and v70 and (v13:HealthPercentage() <= v82)) then
			if (v23(v100.Healthstone) or ((1892 - 1236) >= (5367 - 2037))) then
				return "healthstone defensive 3";
			end
		end
		if ((v71 and (v13:HealthPercentage() <= v83)) or ((7703 - 5211) <= (1583 - (111 + 1137)))) then
			local v153 = 158 - (91 + 67);
			while true do
				if (((12863 - 8541) >= (640 + 1922)) and (v153 == (523 - (423 + 100)))) then
					if ((v89 == "Refreshing Healing Potion") or ((26 + 3611) >= (10438 - 6668))) then
						if (v99.RefreshingHealingPotion:IsReady() or ((1240 + 1139) > (5349 - (326 + 445)))) then
							if (v23(v100.RefreshingHealingPotion) or ((2107 - 1624) > (1654 - 911))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((5728 - 3274) > (1289 - (530 + 181))) and (v89 == "Dreamwalker's Healing Potion")) then
						if (((1811 - (614 + 267)) < (4490 - (19 + 13))) and v99.DreamwalkersHealingPotion:IsReady()) then
							if (((1076 - 414) <= (2264 - 1292)) and v23(v100.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v112()
		local v129 = 0 - 0;
		while true do
			if (((1135 + 3235) == (7685 - 3315)) and (v129 == (0 - 0))) then
				v29 = v97.HandleTopTrinket(v101, v32, 1852 - (1293 + 519), nil);
				if (v29 or ((9715 - 4953) <= (2247 - 1386))) then
					return v29;
				end
				v129 = 1 - 0;
			end
			if ((v129 == (4 - 3)) or ((3326 - 1914) == (2259 + 2005))) then
				v29 = v97.HandleBottomTrinket(v101, v32, 9 + 31, nil);
				if (v29 or ((7360 - 4192) < (498 + 1655))) then
					return v29;
				end
				break;
			end
		end
	end
	local function v113()
		if (v14:IsInMeleeRange(v28) or ((1654 + 3322) < (833 + 499))) then
			if (((5724 - (709 + 387)) == (6486 - (673 + 1185))) and v98.ThunderClap:IsCastable() and v47) then
				if (v23(v98.ThunderClap) or ((156 - 102) == (1268 - 873))) then
					return "thunder_clap precombat";
				end
			end
		elseif (((134 - 52) == (59 + 23)) and v36 and v98.Charge:IsCastable() and not v14:IsInRange(6 + 2)) then
			if (v23(v98.Charge, not v14:IsSpellInRange(v98.Charge)) or ((784 - 203) < (70 + 212))) then
				return "charge precombat";
			end
		end
	end
	local function v114()
		if ((v98.ThunderClap:IsCastable() and v47 and (v14:DebuffRemains(v98.RendDebuff) <= (1 - 0))) or ((9047 - 4438) < (4375 - (446 + 1434)))) then
			v110(1288 - (1040 + 243));
			if (((3438 - 2286) == (2999 - (559 + 1288))) and v23(v98.ThunderClap, not v14:IsInMeleeRange(v28))) then
				return "thunder_clap aoe 2";
			end
		end
		if (((3827 - (609 + 1322)) <= (3876 - (13 + 441))) and v98.ShieldSlam:IsCastable() and v44 and ((v13:HasTier(112 - 82, 5 - 3) and (v104 <= (34 - 27))) or v13:BuffUp(v98.EarthenTenacityBuff))) then
			if (v23(v98.ShieldSlam, not v102) or ((37 + 953) > (5883 - 4263))) then
				return "shield_slam aoe 3";
			end
		end
		if ((v98.ThunderClap:IsCastable() and v47 and v13:BuffUp(v98.ViolentOutburstBuff) and (v104 > (2 + 3)) and v13:BuffUp(v98.AvatarBuff) and v98.UnstoppableForce:IsAvailable()) or ((385 + 492) > (13932 - 9237))) then
			local v154 = 0 + 0;
			while true do
				if (((4949 - 2258) >= (1224 + 627)) and ((0 + 0) == v154)) then
					v110(4 + 1);
					if (v23(v98.ThunderClap, not v14:IsInMeleeRange(v28)) or ((2507 + 478) >= (4752 + 104))) then
						return "thunder_clap aoe 4";
					end
					break;
				end
			end
		end
		if (((4709 - (153 + 280)) >= (3450 - 2255)) and v98.Revenge:IsReady() and v42 and (v13:Rage() >= (63 + 7)) and v98.SeismicReverberation:IsAvailable() and (v104 >= (2 + 1))) then
			if (((1692 + 1540) <= (4257 + 433)) and v23(v98.Revenge, not v102)) then
				return "revenge aoe 6";
			end
		end
		if ((v98.ShieldSlam:IsCastable() and v44 and ((v13:Rage() <= (44 + 16)) or (v13:BuffUp(v98.ViolentOutburstBuff) and (v104 <= (9 - 2))))) or ((554 + 342) >= (3813 - (89 + 578)))) then
			local v155 = 0 + 0;
			while true do
				if (((6363 - 3302) >= (4007 - (572 + 477))) and (v155 == (0 + 0))) then
					v110(13 + 7);
					if (((381 + 2806) >= (730 - (84 + 2))) and v23(v98.ShieldSlam, not v102)) then
						return "shield_slam aoe 8";
					end
					break;
				end
			end
		end
		if (((1060 - 416) <= (508 + 196)) and v98.ThunderClap:IsCastable() and v47) then
			local v156 = 842 - (497 + 345);
			while true do
				if (((25 + 933) > (161 + 786)) and ((1333 - (605 + 728)) == v156)) then
					v110(4 + 1);
					if (((9986 - 5494) >= (122 + 2532)) and v23(v98.ThunderClap, not v14:IsInMeleeRange(v28))) then
						return "thunder_clap aoe 10";
					end
					break;
				end
			end
		end
		if (((12725 - 9283) >= (1355 + 148)) and v98.Revenge:IsReady() and v42 and ((v13:Rage() >= (83 - 53)) or ((v13:Rage() >= (31 + 9)) and v98.BarbaricTraining:IsAvailable()))) then
			if (v23(v98.Revenge, not v102) or ((3659 - (457 + 32)) <= (622 + 842))) then
				return "revenge aoe 12";
			end
		end
	end
	local function v115()
		local v130 = 1402 - (832 + 570);
		while true do
			if ((v130 == (1 + 0)) or ((1251 + 3546) == (15528 - 11140))) then
				if (((266 + 285) <= (1477 - (588 + 208))) and v98.Execute:IsReady() and v39 and (v104 == (2 - 1)) and (v98.Massacre:IsAvailable() or v98.Juggernaut:IsAvailable()) and (v13:Rage() >= (1850 - (884 + 916)))) then
					if (((6860 - 3583) > (236 + 171)) and v23(v98.Execute, not v102)) then
						return "execute generic 6";
					end
				end
				if (((5348 - (232 + 421)) >= (3304 - (1569 + 320))) and v98.Execute:IsReady() and v39 and (v104 == (1 + 0)) and (v13:Rage() >= (10 + 40))) then
					if (v23(v98.Execute, not v102) or ((10823 - 7611) <= (1549 - (316 + 289)))) then
						return "execute generic 10";
					end
				end
				if ((v98.ThunderClap:IsCastable() and v47 and ((v104 > (2 - 1)) or (v98.ShieldSlam:CooldownDown() and not v13:BuffUp(v98.ViolentOutburstBuff)))) or ((143 + 2953) <= (3251 - (666 + 787)))) then
					local v195 = 425 - (360 + 65);
					while true do
						if (((3306 + 231) == (3791 - (79 + 175))) and (v195 == (0 - 0))) then
							v110(4 + 1);
							if (((11761 - 7924) >= (3023 - 1453)) and v23(v98.ThunderClap, not v14:IsInMeleeRange(v28))) then
								return "thunder_clap generic 12";
							end
							break;
						end
					end
				end
				v130 = 901 - (503 + 396);
			end
			if ((v130 == (183 - (92 + 89))) or ((5722 - 2772) == (1955 + 1857))) then
				if (((2796 + 1927) >= (9077 - 6759)) and v98.Revenge:IsReady() and v42 and (((v13:Rage() >= (9 + 51)) and (v14:HealthPercentage() > (45 - 25))) or (v13:BuffUp(v98.RevengeBuff) and (v14:HealthPercentage() <= (18 + 2)) and (v13:Rage() <= (9 + 9)) and v98.ShieldSlam:CooldownDown()) or (v13:BuffUp(v98.RevengeBuff) and (v14:HealthPercentage() > (60 - 40))) or ((((v13:Rage() >= (8 + 52)) and (v14:HealthPercentage() > (53 - 18))) or (v13:BuffUp(v98.RevengeBuff) and (v14:HealthPercentage() <= (1279 - (485 + 759))) and (v13:Rage() <= (41 - 23)) and v98.ShieldSlam:CooldownDown()) or (v13:BuffUp(v98.RevengeBuff) and (v14:HealthPercentage() > (1224 - (442 + 747))))) and v98.Massacre:IsAvailable()))) then
					if (v23(v98.Revenge, not v102) or ((3162 - (832 + 303)) > (3798 - (88 + 858)))) then
						return "revenge generic 14";
					end
				end
				if ((v98.Execute:IsReady() and v39 and (v104 == (1 + 0))) or ((941 + 195) > (178 + 4139))) then
					if (((5537 - (766 + 23)) == (23439 - 18691)) and v23(v98.Execute, not v102)) then
						return "execute generic 16";
					end
				end
				if (((5108 - 1372) <= (12488 - 7748)) and v98.Revenge:IsReady() and v42 and (v14:HealthPercentage() > (67 - 47))) then
					if (v23(v98.Revenge, not v102) or ((4463 - (1036 + 37)) <= (2170 + 890))) then
						return "revenge generic 18";
					end
				end
				v130 = 5 - 2;
			end
			if (((3 + 0) == v130) or ((2479 - (641 + 839)) > (3606 - (910 + 3)))) then
				if (((1180 - 717) < (2285 - (1466 + 218))) and v98.ThunderClap:IsCastable() and v47 and ((v104 >= (1 + 0)) or (v98.ShieldSlam:CooldownDown() and v13:BuffUp(v98.ViolentOutburstBuff)))) then
					v110(1153 - (556 + 592));
					if (v23(v98.ThunderClap, not v14:IsInMeleeRange(v28)) or ((777 + 1406) < (1495 - (329 + 479)))) then
						return "thunder_clap generic 20";
					end
				end
				if (((5403 - (174 + 680)) == (15630 - 11081)) and v98.Devastate:IsCastable() and v38) then
					if (((9683 - 5011) == (3336 + 1336)) and v23(v98.Devastate, not v102)) then
						return "devastate generic 22";
					end
				end
				break;
			end
			if ((v130 == (739 - (396 + 343))) or ((325 + 3343) < (1872 - (29 + 1448)))) then
				if ((v98.ShieldSlam:IsCastable() and v44) or ((5555 - (135 + 1254)) == (1714 - 1259))) then
					local v196 = 0 - 0;
					while true do
						if ((v196 == (0 + 0)) or ((5976 - (389 + 1138)) == (3237 - (102 + 472)))) then
							v110(19 + 1);
							if (v23(v98.ShieldSlam, not v102) or ((2372 + 1905) < (2788 + 201))) then
								return "shield_slam generic 2";
							end
							break;
						end
					end
				end
				if ((v98.ThunderClap:IsCastable() and v47 and (v14:DebuffRemains(v98.RendDebuff) <= (1546 - (320 + 1225))) and v13:BuffDown(v98.ViolentOutburstBuff)) or ((1548 - 678) >= (2539 + 1610))) then
					v110(1469 - (157 + 1307));
					if (((4071 - (821 + 1038)) < (7941 - 4758)) and v23(v98.ThunderClap, not v14:IsInMeleeRange(v28))) then
						return "thunder_clap generic 4";
					end
				end
				if (((509 + 4137) > (5314 - 2322)) and v98.Execute:IsReady() and v39 and v13:BuffUp(v98.SuddenDeathBuff) and v98.SuddenDeath:IsAvailable()) then
					if (((534 + 900) < (7698 - 4592)) and v23(v98.Execute, not v102)) then
						return "execute generic 6";
					end
				end
				v130 = 1027 - (834 + 192);
			end
		end
	end
	local function v116()
		local v131 = 0 + 0;
		while true do
			if (((202 + 584) < (65 + 2958)) and (v131 == (0 - 0))) then
				if (not v13:AffectingCombat() or ((2746 - (300 + 4)) < (20 + 54))) then
					local v197 = 0 - 0;
					while true do
						if (((4897 - (112 + 250)) == (1808 + 2727)) and (v197 == (0 - 0))) then
							if ((v98.BattleShout:IsCastable() and v35 and (v13:BuffDown(v98.BattleShoutBuff, true) or v97.GroupBuffMissing(v98.BattleShoutBuff))) or ((1724 + 1285) <= (1089 + 1016))) then
								if (((1369 + 461) < (1820 + 1849)) and v23(v98.BattleShout)) then
									return "battle_shout precombat";
								end
							end
							if ((v96 and v98.BattleStance:IsCastable() and not v13:BuffUp(v98.BattleStance)) or ((1063 + 367) >= (5026 - (1001 + 413)))) then
								if (((5982 - 3299) >= (3342 - (244 + 638))) and v23(v98.BattleStance)) then
									return "battle_stance precombat";
								end
							end
							break;
						end
					end
				end
				if ((v97.TargetIsValid() and v30) or ((2497 - (627 + 66)) >= (9758 - 6483))) then
					if (not v13:AffectingCombat() or ((2019 - (512 + 90)) > (5535 - (1665 + 241)))) then
						v29 = v113();
						if (((5512 - (373 + 344)) > (182 + 220)) and v29) then
							return v29;
						end
					end
				end
				break;
			end
		end
	end
	local function v117()
		local v132 = 0 + 0;
		while true do
			if (((12695 - 7882) > (6032 - 2467)) and (v132 == (1100 - (35 + 1064)))) then
				if (((2847 + 1065) == (8369 - 4457)) and v88) then
					v29 = v97.HandleIncorporeal(v98.StormBolt, v100.StormBoltMouseover, 1 + 19, true);
					if (((4057 - (298 + 938)) <= (6083 - (233 + 1026))) and v29) then
						return v29;
					end
					v29 = v97.HandleIncorporeal(v98.IntimidatingShout, v100.IntimidatingShoutMouseover, 1674 - (636 + 1030), true);
					if (((889 + 849) <= (2145 + 50)) and v29) then
						return v29;
					end
				end
				if (((13 + 28) <= (204 + 2814)) and v97.TargetIsValid()) then
					local v198 = 221 - (55 + 166);
					local v199;
					while true do
						if (((416 + 1729) <= (413 + 3691)) and (v198 == (0 - 0))) then
							if (((2986 - (36 + 261)) < (8472 - 3627)) and v96 and (v13:HealthPercentage() <= v81)) then
								if ((v98.DefensiveStance:IsCastable() and not v13:BuffUp(v98.DefensiveStance)) or ((3690 - (34 + 1334)) > (1008 + 1614))) then
									if (v23(v98.DefensiveStance) or ((3523 + 1011) == (3365 - (1035 + 248)))) then
										return "defensive_stance while tanking";
									end
								end
							end
							if ((v96 and (v13:HealthPercentage() > v81)) or ((1592 - (20 + 1)) > (973 + 894))) then
								if ((v98.BattleStance:IsCastable() and not v13:BuffUp(v98.BattleStance)) or ((2973 - (134 + 185)) >= (4129 - (549 + 584)))) then
									if (((4663 - (314 + 371)) > (7222 - 5118)) and v23(v98.BattleStance)) then
										return "battle_stance while not tanking";
									end
								end
							end
							if (((3963 - (478 + 490)) > (817 + 724)) and v43 and ((v54 and v32) or not v54) and (v93 < v95) and v98.ShieldCharge:IsCastable() and not v102) then
								if (((4421 - (786 + 386)) > (3086 - 2133)) and v23(v98.ShieldCharge, not v14:IsSpellInRange(v98.ShieldCharge))) then
									return "shield_charge main 34";
								end
							end
							v198 = 1380 - (1055 + 324);
						end
						if ((v198 == (1342 - (1093 + 247))) or ((2909 + 364) > (481 + 4092))) then
							if ((v98.WreckingThrow:IsCastable() and v49 and v14:AffectingCombat() and v105()) or ((12510 - 9359) < (4357 - 3073))) then
								if (v23(v98.WreckingThrow, not v14:IsInRange(85 - 55)) or ((4648 - 2798) == (544 + 985))) then
									return "wrecking_throw main";
								end
							end
							if (((3162 - 2341) < (7317 - 5194)) and (v93 < v95) and v34 and ((v52 and v32) or not v52) and v98.Avatar:IsCastable()) then
								if (((681 + 221) < (5945 - 3620)) and v23(v98.Avatar)) then
									return "avatar main 2";
								end
							end
							if (((1546 - (364 + 324)) <= (8119 - 5157)) and (v93 < v95) and v51 and ((v58 and v32) or not v58)) then
								if (v98.BloodFury:IsCastable() or ((9468 - 5522) < (427 + 861))) then
									if (v23(v98.BloodFury) or ((13565 - 10323) == (907 - 340))) then
										return "blood_fury main 4";
									end
								end
								if (v98.Berserking:IsCastable() or ((2572 - 1725) >= (2531 - (1249 + 19)))) then
									if (v23(v98.Berserking) or ((2034 + 219) == (7204 - 5353))) then
										return "berserking main 6";
									end
								end
								if (v98.ArcaneTorrent:IsCastable() or ((3173 - (686 + 400)) > (1862 + 510))) then
									if (v23(v98.ArcaneTorrent) or ((4674 - (73 + 156)) < (20 + 4129))) then
										return "arcane_torrent main 8";
									end
								end
								if (v98.LightsJudgment:IsCastable() or ((2629 - (721 + 90)) == (1 + 84))) then
									if (((2045 - 1415) < (2597 - (224 + 246))) and v23(v98.LightsJudgment)) then
										return "lights_judgment main 10";
									end
								end
								if (v98.Fireblood:IsCastable() or ((3139 - 1201) == (4628 - 2114))) then
									if (((772 + 3483) >= (2 + 53)) and v23(v98.Fireblood)) then
										return "fireblood main 12";
									end
								end
								if (((2203 + 796) > (2298 - 1142)) and v98.AncestralCall:IsCastable()) then
									if (((7820 - 5470) > (1668 - (203 + 310))) and v23(v98.AncestralCall)) then
										return "ancestral_call main 14";
									end
								end
								if (((6022 - (1238 + 755)) <= (340 + 4513)) and v98.BagofTricks:IsCastable()) then
									if (v23(v98.BagofTricks) or ((2050 - (709 + 825)) > (6327 - 2893))) then
										return "ancestral_call main 16";
									end
								end
							end
							v198 = 3 - 0;
						end
						if (((4910 - (196 + 668)) >= (11974 - 8941)) and (v198 == (10 - 5))) then
							if ((v98.DemoralizingShout:IsCastable() and v37 and v98.BoomingVoice:IsAvailable()) or ((3552 - (171 + 662)) <= (1540 - (4 + 89)))) then
								local v201 = 0 - 0;
								while true do
									if ((v201 == (0 + 0)) or ((18157 - 14023) < (1540 + 2386))) then
										v110(1516 - (35 + 1451));
										if (v23(v98.DemoralizingShout, not v102) or ((1617 - (28 + 1425)) >= (4778 - (941 + 1052)))) then
											return "demoralizing_shout main 28";
										end
										break;
									end
								end
							end
							if (((v93 < v95) and v46 and ((v55 and v32) or not v55) and (v87 == "player") and v98.SpearofBastion:IsCastable()) or ((504 + 21) == (3623 - (822 + 692)))) then
								v110(28 - 8);
								if (((16 + 17) == (330 - (45 + 252))) and v23(v100.SpearOfBastionPlayer, not v102)) then
									return "spear_of_bastion main 28";
								end
							end
							if (((3022 + 32) <= (1382 + 2633)) and (v93 < v95) and v46 and ((v55 and v32) or not v55) and (v87 == "cursor") and v98.SpearofBastion:IsCastable()) then
								local v202 = 0 - 0;
								while true do
									if (((2304 - (114 + 319)) < (4855 - 1473)) and (v202 == (0 - 0))) then
										v110(13 + 7);
										if (((1926 - 633) <= (4537 - 2371)) and v23(v100.SpearOfBastionCursor, not v102)) then
											return "spear_of_bastion main 28";
										end
										break;
									end
								end
							end
							v198 = 1969 - (556 + 1407);
						end
						if ((v198 == (1210 - (741 + 465))) or ((3044 - (170 + 295)) < (65 + 58))) then
							if ((v106() and v65 and v98.LastStand:IsCastable() and v13:BuffDown(v98.ShieldWallBuff) and (((v14:HealthPercentage() >= (83 + 7)) and v98.UnnervingFocus:IsAvailable()) or ((v14:HealthPercentage() <= (49 - 29)) and v98.UnnervingFocus:IsAvailable()) or v98.Bolster:IsAvailable() or v13:HasTier(25 + 5, 2 + 0))) or ((480 + 366) >= (3598 - (957 + 273)))) then
								if (v23(v98.LastStand) or ((1074 + 2938) <= (1345 + 2013))) then
									return "last_stand defensive";
								end
							end
							if (((5692 - 4198) <= (7918 - 4913)) and (v93 < v95) and v41 and ((v53 and v32) or not v53) and (v86 == "player") and v98.Ravager:IsCastable()) then
								local v203 = 0 - 0;
								while true do
									if ((v203 == (0 - 0)) or ((4891 - (389 + 1391)) == (1339 + 795))) then
										v110(2 + 8);
										if (((5361 - 3006) == (3306 - (783 + 168))) and v23(v100.RavagerPlayer, not v102)) then
											return "ravager main 24";
										end
										break;
									end
								end
							end
							if (((v93 < v95) and v41 and ((v53 and v32) or not v53) and (v86 == "cursor") and v98.Ravager:IsCastable()) or ((1973 - 1385) <= (425 + 7))) then
								v110(321 - (309 + 2));
								if (((14730 - 9933) >= (5107 - (1090 + 122))) and v23(v100.RavagerCursor, not v102)) then
									return "ravager main 24";
								end
							end
							v198 = 2 + 3;
						end
						if (((12013 - 8436) == (2448 + 1129)) and (v198 == (1124 - (628 + 490)))) then
							if (((681 + 3113) > (9143 - 5450)) and (v93 < v95) and v48 and ((v56 and v32) or not v56) and v98.ThunderousRoar:IsCastable()) then
								if (v23(v98.ThunderousRoar, not v14:IsInMeleeRange(v28)) or ((5826 - 4551) == (4874 - (431 + 343)))) then
									return "thunderous_roar main 30";
								end
							end
							if ((v98.ShieldSlam:IsCastable() and v44 and v13:BuffUp(v98.FervidBuff)) or ((3212 - 1621) >= (10356 - 6776))) then
								if (((777 + 206) <= (232 + 1576)) and v23(v98.ShieldSlam, not v102)) then
									return "shield_slam main 31";
								end
							end
							if ((v98.Shockwave:IsCastable() and v45 and v13:BuffUp(v98.AvatarBuff) and v98.UnstoppableForce:IsAvailable() and not v98.RumblingEarth:IsAvailable()) or (v98.SonicBoom:IsAvailable() and v98.RumblingEarth:IsAvailable() and (v104 >= (1698 - (556 + 1139))) and v14:IsCasting()) or ((2165 - (6 + 9)) <= (220 + 977))) then
								v110(6 + 4);
								if (((3938 - (28 + 141)) >= (455 + 718)) and v23(v98.Shockwave, not v14:IsInMeleeRange(v28))) then
									return "shockwave main 32";
								end
							end
							v198 = 8 - 1;
						end
						if (((1052 + 433) == (2802 - (486 + 831))) and (v198 == (7 - 4))) then
							v199 = v97.HandleDPSPotion(v14:BuffUp(v98.AvatarBuff));
							if (v199 or ((11670 - 8355) <= (526 + 2256))) then
								return v199;
							end
							if ((v98.IgnorePain:IsReady() and v66 and v107() and (v14:HealthPercentage() >= (63 - 43)) and (((v13:RageDeficit() <= (1278 - (668 + 595))) and v98.ShieldSlam:CooldownUp()) or ((v13:RageDeficit() <= (36 + 4)) and v98.ShieldCharge:CooldownUp() and v98.ChampionsBulwark:IsAvailable()) or ((v13:RageDeficit() <= (5 + 15)) and v98.ShieldCharge:CooldownUp()) or ((v13:RageDeficit() <= (81 - 51)) and v98.DemoralizingShout:CooldownUp() and v98.BoomingVoice:IsAvailable()) or ((v13:RageDeficit() <= (310 - (23 + 267))) and v98.Avatar:CooldownUp()) or ((v13:RageDeficit() <= (1989 - (1129 + 815))) and v98.DemoralizingShout:CooldownUp() and v98.BoomingVoice:IsAvailable() and v13:BuffUp(v98.LastStandBuff) and v98.UnnervingFocus:IsAvailable()) or ((v13:RageDeficit() <= (417 - (371 + 16))) and v98.Avatar:CooldownUp() and v13:BuffUp(v98.LastStandBuff) and v98.UnnervingFocus:IsAvailable()) or (v13:RageDeficit() <= (1770 - (1326 + 424))) or ((v13:RageDeficit() <= (75 - 35)) and v98.ShieldSlam:CooldownUp() and v13:BuffUp(v98.ViolentOutburstBuff) and v98.HeavyRepercussions:IsAvailable() and v98.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (200 - 145)) and v98.ShieldSlam:CooldownUp() and v13:BuffUp(v98.ViolentOutburstBuff) and v13:BuffUp(v98.LastStandBuff) and v98.UnnervingFocus:IsAvailable() and v98.HeavyRepercussions:IsAvailable() and v98.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (135 - (88 + 30))) and v98.ShieldSlam:CooldownUp() and v98.HeavyRepercussions:IsAvailable()) or ((v13:RageDeficit() <= (789 - (720 + 51))) and v98.ShieldSlam:CooldownUp() and v98.ImpenetrableWall:IsAvailable()))) or ((1948 - 1072) >= (4740 - (421 + 1355)))) then
								if (v23(v98.IgnorePain, nil, nil, true) or ((3681 - 1449) > (1227 + 1270))) then
									return "ignore_pain main 20";
								end
							end
							v198 = 1087 - (286 + 797);
						end
						if ((v198 == (29 - 21)) or ((3494 - 1384) <= (771 - (397 + 42)))) then
							v29 = v115();
							if (((1152 + 2534) > (3972 - (24 + 776))) and v29) then
								return v29;
							end
							if (v19.CastAnnotated(v98.Pool, false, "WAIT") or ((6892 - 2418) < (1605 - (222 + 563)))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((9427 - 5148) >= (2075 + 807)) and (v198 == (197 - (23 + 167)))) then
							if (((v93 < v95) and v98.ShieldCharge:IsCastable() and v43 and ((v54 and v32) or not v54)) or ((3827 - (690 + 1108)) >= (1271 + 2250))) then
								if (v23(v98.ShieldCharge, not v14:IsSpellInRange(v98.ShieldCharge)) or ((1681 + 356) >= (5490 - (40 + 808)))) then
									return "shield_charge main 34";
								end
							end
							if (((284 + 1436) < (17047 - 12589)) and v109() and v64) then
								if (v23(v98.ShieldBlock) or ((417 + 19) > (1599 + 1422))) then
									return "shield_block main 38";
								end
							end
							if (((391 + 322) <= (1418 - (47 + 524))) and (v104 > (2 + 1))) then
								local v204 = 0 - 0;
								while true do
									if (((3220 - 1066) <= (9193 - 5162)) and ((1726 - (1165 + 561)) == v204)) then
										v29 = v114();
										if (((138 + 4477) == (14293 - 9678)) and v29) then
											return v29;
										end
										v204 = 1 + 0;
									end
									if ((v204 == (480 - (341 + 138))) or ((1024 + 2766) == (1031 - 531))) then
										if (((415 - (89 + 237)) < (710 - 489)) and v19.CastAnnotated(v98.Pool, false, "WAIT")) then
											return "Pool for Aoe()";
										end
										break;
									end
								end
							end
							v198 = 16 - 8;
						end
						if (((2935 - (581 + 300)) >= (2641 - (855 + 365))) and (v198 == (2 - 1))) then
							if (((226 + 466) < (4293 - (1030 + 205))) and v36 and v98.Charge:IsCastable() and not v102) then
								if (v23(v98.Charge, not v14:IsSpellInRange(v98.Charge)) or ((3055 + 199) == (1540 + 115))) then
									return "charge main 34";
								end
							end
							if ((v93 < v95) or ((1582 - (156 + 130)) == (11156 - 6246))) then
								if (((5676 - 2308) == (6897 - 3529)) and v50 and ((v32 and v57) or not v57)) then
									local v205 = 0 + 0;
									while true do
										if (((1542 + 1101) < (3884 - (10 + 59))) and ((0 + 0) == v205)) then
											v29 = v112();
											if (((9421 - 7508) > (1656 - (671 + 492))) and v29) then
												return v29;
											end
											break;
										end
									end
								end
							end
							if (((3786 + 969) > (4643 - (369 + 846))) and v40 and v98.HeroicThrow:IsCastable() and not v14:IsInRange(8 + 22)) then
								if (((1179 + 202) <= (4314 - (1036 + 909))) and v23(v98.HeroicThrow, not v14:IsInRange(24 + 6))) then
									return "heroic_throw main";
								end
							end
							v198 = 2 - 0;
						end
					end
				end
				break;
			end
			if ((v132 == (203 - (11 + 192))) or ((2448 + 2395) == (4259 - (135 + 40)))) then
				v29 = v111();
				if (((11312 - 6643) > (219 + 144)) and v29) then
					return v29;
				end
				v132 = 2 - 1;
			end
		end
	end
	local function v118()
		local v133 = 0 - 0;
		while true do
			if ((v133 == (178 - (50 + 126))) or ((5226 - 3349) >= (695 + 2443))) then
				v42 = EpicSettings.Settings['useRevenge'];
				v44 = EpicSettings.Settings['useShieldSlam'];
				v45 = EpicSettings.Settings['useShockwave'];
				v133 = 1416 - (1233 + 180);
			end
			if (((5711 - (522 + 447)) >= (5047 - (107 + 1314))) and (v133 == (2 + 2))) then
				v41 = EpicSettings.Settings['useRavager'];
				v43 = EpicSettings.Settings['useShieldCharge'];
				v46 = EpicSettings.Settings['useSpearOfBastion'];
				v133 = 15 - 10;
			end
			if ((v133 == (0 + 0)) or ((9015 - 4475) == (3624 - 2708))) then
				v35 = EpicSettings.Settings['useBattleShout'];
				v36 = EpicSettings.Settings['useCharge'];
				v37 = EpicSettings.Settings['useDemoralizingShout'];
				v133 = 1911 - (716 + 1194);
			end
			if ((v133 == (1 + 0)) or ((124 + 1032) > (4848 - (74 + 429)))) then
				v38 = EpicSettings.Settings['useDevastate'];
				v39 = EpicSettings.Settings['useExecute'];
				v40 = EpicSettings.Settings['useHeroicThrow'];
				v133 = 3 - 1;
			end
			if (((1109 + 1128) < (9725 - 5476)) and ((5 + 1) == v133)) then
				v54 = EpicSettings.Settings['shieldChargeWithCD'];
				v55 = EpicSettings.Settings['spearOfBastionWithCD'];
				v56 = EpicSettings.Settings['thunderousRoarWithCD'];
				break;
			end
			if ((v133 == (8 - 5)) or ((6633 - 3950) < (456 - (279 + 154)))) then
				v47 = EpicSettings.Settings['useThunderClap'];
				v49 = EpicSettings.Settings['useWreckingThrow'];
				v34 = EpicSettings.Settings['useAvatar'];
				v133 = 782 - (454 + 324);
			end
			if (((549 + 148) <= (843 - (12 + 5))) and ((3 + 2) == v133)) then
				v48 = EpicSettings.Settings['useThunderousRoar'];
				v52 = EpicSettings.Settings['avatarWithCD'];
				v53 = EpicSettings.Settings['ravagerWithCD'];
				v133 = 14 - 8;
			end
		end
	end
	local function v119()
		local v134 = 0 + 0;
		while true do
			if (((2198 - (277 + 816)) <= (5024 - 3848)) and (v134 == (1188 - (1058 + 125)))) then
				v76 = EpicSettings.Settings['lastStandHP'] or (0 + 0);
				v79 = EpicSettings.Settings['rallyingCryGroup'] or (975 - (815 + 160));
				v78 = EpicSettings.Settings['rallyingCryHP'] or (0 - 0);
				v134 = 14 - 8;
			end
			if (((807 + 2572) <= (11142 - 7330)) and (v134 == (1901 - (41 + 1857)))) then
				v63 = EpicSettings.Settings['useShieldWall'];
				v72 = EpicSettings.Settings['useVictoryRush'];
				v96 = EpicSettings.Settings['useChangeStance'];
				v134 = 1897 - (1222 + 671);
			end
			if ((v134 == (2 - 1)) or ((1132 - 344) >= (2798 - (229 + 953)))) then
				v62 = EpicSettings.Settings['useBitterImmunity'];
				v66 = EpicSettings.Settings['useIgnorePain'];
				v68 = EpicSettings.Settings['useIntervene'];
				v134 = 1776 - (1111 + 663);
			end
			if (((3433 - (874 + 705)) <= (473 + 2906)) and (v134 == (5 + 1))) then
				v75 = EpicSettings.Settings['shieldBlockHP'] or (0 - 0);
				v74 = EpicSettings.Settings['shieldWallHP'] or (0 + 0);
				v85 = EpicSettings.Settings['victoryRushHP'] or (679 - (642 + 37));
				v134 = 2 + 5;
			end
			if (((728 + 3821) == (11421 - 6872)) and (v134 == (454 - (233 + 221)))) then
				v59 = EpicSettings.Settings['usePummel'];
				v60 = EpicSettings.Settings['useStormBolt'];
				v61 = EpicSettings.Settings['useIntimidatingShout'];
				v134 = 2 - 1;
			end
			if ((v134 == (2 + 0)) or ((4563 - (718 + 823)) >= (1903 + 1121))) then
				v65 = EpicSettings.Settings['useLastStand'];
				v67 = EpicSettings.Settings['useRallyingCry'];
				v64 = EpicSettings.Settings['useShieldBlock'];
				v134 = 808 - (266 + 539);
			end
			if (((13646 - 8826) > (3423 - (636 + 589))) and (v134 == (16 - 9))) then
				v81 = EpicSettings.Settings['defensiveStanceHP'] or (0 - 0);
				v86 = EpicSettings.Settings['ravagerSetting'] or "";
				v87 = EpicSettings.Settings['spearSetting'] or "";
				break;
			end
			if ((v134 == (4 + 0)) or ((386 + 675) >= (5906 - (657 + 358)))) then
				v73 = EpicSettings.Settings['bitterImmunityHP'] or (0 - 0);
				v77 = EpicSettings.Settings['ignorePainHP'] or (0 - 0);
				v80 = EpicSettings.Settings['interveneHP'] or (1187 - (1151 + 36));
				v134 = 5 + 0;
			end
		end
	end
	local function v120()
		v93 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v90 = EpicSettings.Settings['InterruptWithStun'];
		v91 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v92 = EpicSettings.Settings['InterruptThreshold'];
		v50 = EpicSettings.Settings['useTrinkets'];
		v51 = EpicSettings.Settings['useRacials'];
		v57 = EpicSettings.Settings['trinketsWithCD'];
		v58 = EpicSettings.Settings['racialsWithCD'];
		v70 = EpicSettings.Settings['useHealthstone'];
		v71 = EpicSettings.Settings['useHealingPotion'];
		v82 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v83 = EpicSettings.Settings['healingPotionHP'] or (1832 - (1552 + 280));
		v89 = EpicSettings.Settings['HealingPotionName'] or "";
		v88 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v121()
		local v145 = 834 - (64 + 770);
		while true do
			if (((927 + 437) <= (10153 - 5680)) and (v145 == (1 + 2))) then
				if (v31 or ((4838 - (157 + 1086)) <= (5 - 2))) then
					v103 = v13:GetEnemiesInMeleeRange(v28);
					v104 = #v103;
				else
					v104 = 4 - 3;
				end
				v102 = v14:IsInMeleeRange(v28);
				if (v97.TargetIsValid() or v13:AffectingCombat() or ((7166 - 2494) == (5256 - 1404))) then
					v94 = v10.BossFightRemains(nil, true);
					v95 = v94;
					if (((2378 - (599 + 220)) == (3104 - 1545)) and (v95 == (13042 - (1813 + 118)))) then
						v95 = v10.FightRemains(v103, false);
					end
				end
				v145 = 3 + 1;
			end
			if ((v145 == (1218 - (841 + 376))) or ((2454 - 702) <= (184 + 604))) then
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v145 = 5 - 3;
			end
			if (((859 - (464 + 395)) == v145) or ((10026 - 6119) == (86 + 91))) then
				v119();
				v118();
				v120();
				v145 = 838 - (467 + 370);
			end
			if (((7170 - 3700) > (408 + 147)) and (v145 == (6 - 4))) then
				v33 = EpicSettings.Toggles['kick'];
				if (v13:IsDeadOrGhost() or ((152 + 820) == (1500 - 855))) then
					return;
				end
				if (((3702 - (150 + 370)) >= (3397 - (74 + 1208))) and v98.IntimidatingShout:IsAvailable()) then
					v28 = 19 - 11;
				end
				v145 = 14 - 11;
			end
			if (((2771 + 1122) < (4819 - (14 + 376))) and ((6 - 2) == v145)) then
				if (not v13:IsChanneling() or ((1856 + 1011) < (1674 + 231))) then
					if (v13:AffectingCombat() or ((1713 + 83) >= (11869 - 7818))) then
						local v200 = 0 + 0;
						while true do
							if (((1697 - (23 + 55)) <= (8901 - 5145)) and (v200 == (0 + 0))) then
								v29 = v117();
								if (((543 + 61) == (935 - 331)) and v29) then
									return v29;
								end
								break;
							end
						end
					else
						v29 = v116();
						if (v29 or ((1411 + 3073) == (1801 - (652 + 249)))) then
							return v29;
						end
					end
				end
				break;
			end
		end
	end
	local function v122()
		v19.Print("Protection Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(195 - 122, v121, v122);
end;
return v0["Epix_Warrior_Protection.lua"]();

