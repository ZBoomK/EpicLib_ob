local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (48 - (25 + 23))) or ((437 + 1818) < (1908 - (927 + 959)))) then
			v6 = v0[v4];
			if (not v6 or ((3660 - 2574) >= (2137 - (16 + 716)))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if ((v5 == (98 - (11 + 86))) or ((5777 - 3408) == (711 - (175 + 110)))) then
			return v6(...);
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
	local v28;
	local v29 = false;
	local v30 = false;
	local v31 = false;
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
	local v90 = 28052 - 16941;
	local v91 = 54802 - 43691;
	local v92;
	local v93 = v19.Commons.Everyone;
	local v94 = v17.Warrior.Protection;
	local v95 = v18.Warrior.Protection;
	local v96 = v22.Warrior.Protection;
	local v97 = {};
	local v98;
	local v99;
	local v100;
	local function v101()
		local v119 = 1796 - (503 + 1293);
		local v120;
		while true do
			if ((v119 == (0 - 0)) or ((2225 + 851) > (4244 - (810 + 251)))) then
				v120 = UnitGetTotalAbsorbs(v14);
				if (((835 + 367) > (325 + 733)) and (v120 > (0 + 0))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v102()
		return v13:IsTankingAoE(549 - (43 + 490)) or v13:IsTanking(v14) or v14:IsDummy();
	end
	local function v103()
		if (((4444 - (711 + 22)) > (12977 - 9622)) and v13:BuffUp(v94.IgnorePain)) then
			local v155 = v13:AttackPowerDamageMod() * (862.5 - (240 + 619)) * (1 + 0 + (v13:VersatilityDmgPct() / (159 - 59)));
			local v156 = v13:AuraInfo(v94.IgnorePain, nil, true);
			local v157 = v156.points[1 + 0];
			return v157 < v155;
		else
			return true;
		end
	end
	local function v104()
		if (v13:BuffUp(v94.IgnorePain) or ((2650 - (1344 + 400)) >= (2634 - (255 + 150)))) then
			local v158 = 0 + 0;
			local v159;
			while true do
				if (((690 + 598) > (5344 - 4093)) and (v158 == (0 - 0))) then
					v159 = v13:BuffInfo(v94.IgnorePain, nil, true);
					return v159.points[1740 - (404 + 1335)];
				end
			end
		else
			return 406 - (183 + 223);
		end
	end
	local function v105()
		return v102() and v94.ShieldBlock:IsReady() and (((v13:BuffRemains(v94.ShieldBlockBuff) <= (21 - 3)) and v94.EnduringDefenses:IsAvailable()) or (v13:BuffRemains(v94.ShieldBlockBuff) <= (8 + 4)));
	end
	local function v106(v121)
		local v122 = 29 + 51;
		if ((v122 < (372 - (10 + 327))) or (v13:Rage() < (25 + 10)) or ((4851 - (118 + 220)) < (1118 + 2234))) then
			return false;
		end
		local v123 = false;
		local v124 = (v13:Rage() >= (484 - (108 + 341))) and not v105();
		if ((v124 and (((v13:Rage() + v121) >= v122) or v94.DemoralizingShout:IsReady())) or ((928 + 1137) >= (13511 - 10315))) then
			v123 = true;
		end
		if (v123 or ((5869 - (711 + 782)) <= (2838 - 1357))) then
			if ((v102() and v103()) or ((3861 - (270 + 199)) >= (1537 + 3204))) then
				if (((5144 - (580 + 1239)) >= (6403 - 4249)) and v23(v94.IgnorePain, nil, nil, true)) then
					return "ignore_pain rage capped";
				end
			elseif (v23(v94.Revenge, not v98) or ((1239 + 56) >= (117 + 3116))) then
				return "revenge rage capped";
			end
		end
	end
	local function v107()
		local v125 = 0 + 0;
		while true do
			if (((11427 - 7050) > (1021 + 621)) and (v125 == (1170 - (645 + 522)))) then
				if (((6513 - (1010 + 780)) > (1356 + 0)) and v95.Healthstone:IsReady() and v67 and (v13:HealthPercentage() <= v79)) then
					if (v23(v96.Healthstone) or ((19703 - 15567) <= (10060 - 6627))) then
						return "healthstone defensive 3";
					end
				end
				if (((6081 - (1045 + 791)) <= (11722 - 7091)) and v68 and (v13:HealthPercentage() <= v80)) then
					if (((6528 - 2252) >= (4419 - (351 + 154))) and (v85 == "Refreshing Healing Potion")) then
						if (((1772 - (1281 + 293)) <= (4631 - (28 + 238))) and v95.RefreshingHealingPotion:IsReady()) then
							if (((10684 - 5902) > (6235 - (1381 + 178))) and v23(v96.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((4563 + 301) > (1772 + 425)) and (v85 == "Dreamwalker's Healing Potion")) then
						if (v95.DreamwalkersHealingPotion:IsReady() or ((1579 + 2121) == (8642 - 6135))) then
							if (((2318 + 2156) >= (744 - (381 + 89))) and v23(v96.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if ((v125 == (2 + 0)) or ((1281 + 613) <= (2408 - 1002))) then
				if (((2728 - (1074 + 82)) >= (3354 - 1823)) and v94.Intervene:IsReady() and v66 and (v16:HealthPercentage() <= v77) and (v16:UnitName() ~= v13:UnitName())) then
					if (v23(v96.InterveneFocus) or ((6471 - (214 + 1570)) < (5997 - (990 + 465)))) then
						return "intervene defensive";
					end
				end
				if (((1357 + 1934) > (726 + 941)) and v94.ShieldWall:IsCastable() and v61 and v13:BuffDown(v94.ShieldWallBuff) and ((v13:HealthPercentage() <= v71) or v13:ActiveMitigationNeeded())) then
					if (v23(v94.ShieldWall) or ((849 + 24) == (8004 - 5970))) then
						return "shield_wall defensive";
					end
				end
				v125 = 1729 - (1668 + 58);
			end
			if ((v125 == (627 - (512 + 114))) or ((7341 - 4525) < (22 - 11))) then
				if (((12871 - 9172) < (2190 + 2516)) and v94.IgnorePain:IsReady() and v64 and (v13:HealthPercentage() <= v74) and v103()) then
					if (((496 + 2150) >= (762 + 114)) and v23(v94.IgnorePain, nil, nil, true)) then
						return "ignore_pain defensive";
					end
				end
				if (((2070 - 1456) <= (5178 - (109 + 1885))) and v94.RallyingCry:IsReady() and v65 and v13:BuffDown(v94.AspectsFavorBuff) and v13:BuffDown(v94.RallyingCry) and (((v13:HealthPercentage() <= v75) and v93.IsSoloMode()) or v93.AreUnitsBelowHealthPercentage(v75, v76))) then
					if (((4595 - (1269 + 200)) == (5991 - 2865)) and v23(v94.RallyingCry)) then
						return "rallying_cry defensive";
					end
				end
				v125 = 817 - (98 + 717);
			end
			if ((v125 == (826 - (802 + 24))) or ((3770 - 1583) >= (6255 - 1301))) then
				if ((v94.BitterImmunity:IsReady() and v60 and (v13:HealthPercentage() <= v70)) or ((573 + 3304) == (2747 + 828))) then
					if (((117 + 590) > (137 + 495)) and v23(v94.BitterImmunity)) then
						return "bitter_immunity defensive";
					end
				end
				if ((v94.LastStand:IsCastable() and v63 and ((v13:HealthPercentage() <= v73) or v13:ActiveMitigationNeeded())) or ((1518 - 972) >= (8950 - 6266))) then
					if (((524 + 941) <= (1751 + 2550)) and v23(v94.LastStand)) then
						return "last_stand defensive";
					end
				end
				v125 = 1 + 0;
			end
		end
	end
	local function v108()
		local v126 = 0 + 0;
		while true do
			if (((796 + 908) > (2858 - (797 + 636))) and (v126 == (0 - 0))) then
				v28 = v93.HandleTopTrinket(v97, v31, 1659 - (1427 + 192), nil);
				if (v28 or ((239 + 448) == (9829 - 5595))) then
					return v28;
				end
				v126 = 1 + 0;
			end
			if (((1 + 0) == v126) or ((3656 - (192 + 134)) < (2705 - (316 + 960)))) then
				v28 = v93.HandleBottomTrinket(v97, v31, 23 + 17, nil);
				if (((886 + 261) >= (310 + 25)) and v28) then
					return v28;
				end
				break;
			end
		end
	end
	local function v109()
		if (((13131 - 9696) > (2648 - (83 + 468))) and v14:IsInMeleeRange(1814 - (1202 + 604))) then
			if ((v94.ThunderClap:IsCastable() and v45) or ((17599 - 13829) >= (6725 - 2684))) then
				if (v23(v94.ThunderClap) or ((10496 - 6705) <= (1936 - (45 + 280)))) then
					return "thunder_clap precombat";
				end
			end
		elseif ((v34 and v94.Charge:IsCastable() and not v14:IsInRange(8 + 0)) or ((4000 + 578) <= (734 + 1274))) then
			if (((623 + 502) <= (366 + 1710)) and v23(v94.Charge, not v14:IsSpellInRange(v94.Charge))) then
				return "charge precombat";
			end
		end
	end
	local function v110()
		if ((v94.ThunderClap:IsCastable() and v45 and (v14:DebuffRemains(v94.RendDebuff) <= (1 - 0))) or ((2654 - (340 + 1571)) >= (1736 + 2663))) then
			v106(1777 - (1733 + 39));
			if (((3173 - 2018) < (2707 - (125 + 909))) and v23(v94.ThunderClap, not v14:IsInMeleeRange(1956 - (1096 + 852)))) then
				return "thunder_clap aoe 2";
			end
		end
		if ((v94.ShieldSlam:IsCastable() and v42 and ((v13:HasTier(14 + 16, 2 - 0) and (v100 <= (7 + 0))) or v13:BuffUp(v94.EarthenTenacityBuff))) or ((2836 - (409 + 103)) <= (814 - (46 + 190)))) then
			if (((3862 - (51 + 44)) == (1063 + 2704)) and v23(v94.ShieldSlam, not v98)) then
				return "shield_slam aoe 3";
			end
		end
		if (((5406 - (1114 + 203)) == (4815 - (228 + 498))) and v94.ThunderClap:IsCastable() and v45 and v13:BuffUp(v94.ViolentOutburstBuff) and (v100 > (2 + 3)) and v13:BuffUp(v94.AvatarBuff) and v94.UnstoppableForce:IsAvailable()) then
			v106(3 + 2);
			if (((5121 - (174 + 489)) >= (4361 - 2687)) and v23(v94.ThunderClap, not v14:IsInMeleeRange(1913 - (830 + 1075)))) then
				return "thunder_clap aoe 4";
			end
		end
		if (((1496 - (303 + 221)) <= (2687 - (231 + 1038))) and v94.Revenge:IsReady() and v40 and (v13:Rage() >= (59 + 11)) and v94.SeismicReverberation:IsAvailable() and (v100 >= (1165 - (171 + 991)))) then
			if (v23(v94.Revenge, not v98) or ((20350 - 15412) < (12786 - 8024))) then
				return "revenge aoe 6";
			end
		end
		if ((v94.ShieldSlam:IsCastable() and v42 and ((v13:Rage() <= (149 - 89)) or (v13:BuffUp(v94.ViolentOutburstBuff) and (v100 <= (6 + 1))))) or ((8777 - 6273) > (12300 - 8036))) then
			local v160 = 0 - 0;
			while true do
				if (((6655 - 4502) == (3401 - (111 + 1137))) and (v160 == (158 - (91 + 67)))) then
					v106(59 - 39);
					if (v23(v94.ShieldSlam, not v98) or ((127 + 380) >= (3114 - (423 + 100)))) then
						return "shield_slam aoe 8";
					end
					break;
				end
			end
		end
		if (((32 + 4449) == (12407 - 7926)) and v94.ThunderClap:IsCastable() and v45) then
			local v161 = 0 + 0;
			while true do
				if (((771 - (326 + 445)) == v161) or ((10159 - 7831) < (1543 - 850))) then
					v106(11 - 6);
					if (((5039 - (530 + 181)) == (5209 - (614 + 267))) and v23(v94.ThunderClap, not v14:IsInMeleeRange(40 - (19 + 13)))) then
						return "thunder_clap aoe 10";
					end
					break;
				end
			end
		end
		if (((2584 - 996) >= (3103 - 1771)) and v94.Revenge:IsReady() and v40 and ((v13:Rage() >= (85 - 55)) or ((v13:Rage() >= (11 + 29)) and v94.BarbaricTraining:IsAvailable()))) then
			if (v23(v94.Revenge, not v98) or ((7340 - 3166) > (8809 - 4561))) then
				return "revenge aoe 12";
			end
		end
	end
	local function v111()
		if ((v94.ShieldSlam:IsCastable() and v42) or ((6398 - (1293 + 519)) <= (166 - 84))) then
			local v162 = 0 - 0;
			while true do
				if (((7386 - 3523) == (16657 - 12794)) and (v162 == (0 - 0))) then
					v106(11 + 9);
					if (v23(v94.ShieldSlam, not v98) or ((58 + 224) <= (97 - 55))) then
						return "shield_slam generic 2";
					end
					break;
				end
			end
		end
		if (((1066 + 3543) >= (255 + 511)) and v94.ThunderClap:IsCastable() and v45 and (v14:DebuffRemains(v94.RendDebuff) <= (1 + 0)) and v13:BuffDown(v94.ViolentOutburstBuff)) then
			local v163 = 1096 - (709 + 387);
			while true do
				if ((v163 == (1858 - (673 + 1185))) or ((3340 - 2188) == (7989 - 5501))) then
					v106(8 - 3);
					if (((2448 + 974) > (2504 + 846)) and v23(v94.ThunderClap, not v14:IsInMeleeRange(10 - 2))) then
						return "thunder_clap generic 4";
					end
					break;
				end
			end
		end
		if (((216 + 661) > (749 - 373)) and v94.Execute:IsReady() and v37 and v13:BuffUp(v94.SuddenDeathBuff) and v94.SuddenDeath:IsAvailable()) then
			if (v23(v94.Execute, not v98) or ((6120 - 3002) <= (3731 - (446 + 1434)))) then
				return "execute generic 6";
			end
		end
		if ((v94.Execute:IsReady() and v37 and (v100 == (1284 - (1040 + 243))) and (v94.Massacre:IsAvailable() or v94.Juggernaut:IsAvailable()) and (v13:Rage() >= (149 - 99))) or ((2012 - (559 + 1288)) >= (5423 - (609 + 1322)))) then
			if (((4403 - (13 + 441)) < (18145 - 13289)) and v23(v94.Execute, not v98)) then
				return "execute generic 6";
			end
		end
		if ((v94.Execute:IsReady() and v37 and (v100 == (2 - 1)) and (v13:Rage() >= (249 - 199))) or ((160 + 4116) < (10953 - 7937))) then
			if (((1666 + 3024) > (1808 + 2317)) and v23(v94.Execute, not v98)) then
				return "execute generic 10";
			end
		end
		if ((v94.ThunderClap:IsCastable() and v45 and ((v100 > (2 - 1)) or (v94.ShieldSlam:CooldownDown() and not v13:BuffUp(v94.ViolentOutburstBuff)))) or ((28 + 22) >= (1647 - 751))) then
			local v164 = 0 + 0;
			while true do
				if ((v164 == (0 + 0)) or ((1232 + 482) >= (2484 + 474))) then
					v106(5 + 0);
					if (v23(v94.ThunderClap, not v14:IsInMeleeRange(441 - (153 + 280))) or ((4305 - 2814) < (579 + 65))) then
						return "thunder_clap generic 12";
					end
					break;
				end
			end
		end
		if (((278 + 426) < (517 + 470)) and v94.Revenge:IsReady() and v40 and (((v13:Rage() >= (55 + 5)) and (v14:HealthPercentage() > (15 + 5))) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() <= (30 - 10)) and (v13:Rage() <= (12 + 6)) and v94.ShieldSlam:CooldownDown()) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() > (687 - (89 + 578)))) or ((((v13:Rage() >= (43 + 17)) and (v14:HealthPercentage() > (72 - 37))) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() <= (1084 - (572 + 477))) and (v13:Rage() <= (3 + 15)) and v94.ShieldSlam:CooldownDown()) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() > (22 + 13)))) and v94.Massacre:IsAvailable()))) then
			if (((444 + 3274) > (1992 - (84 + 2))) and v23(v94.Revenge, not v98)) then
				return "revenge generic 14";
			end
		end
		if ((v94.Execute:IsReady() and v37 and (v100 == (1 - 0))) or ((691 + 267) > (4477 - (497 + 345)))) then
			if (((90 + 3411) <= (760 + 3732)) and v23(v94.Execute, not v98)) then
				return "execute generic 16";
			end
		end
		if ((v94.Revenge:IsReady() and v40 and (v14:HealthPercentage() > (1353 - (605 + 728)))) or ((2456 + 986) < (5664 - 3116))) then
			if (((132 + 2743) >= (5412 - 3948)) and v23(v94.Revenge, not v98)) then
				return "revenge generic 18";
			end
		end
		if ((v94.ThunderClap:IsCastable() and v45 and ((v100 >= (1 + 0)) or (v94.ShieldSlam:CooldownDown() and v13:BuffUp(v94.ViolentOutburstBuff)))) or ((13290 - 8493) >= (3695 + 1198))) then
			local v165 = 489 - (457 + 32);
			while true do
				if ((v165 == (0 + 0)) or ((1953 - (832 + 570)) > (1949 + 119))) then
					v106(2 + 3);
					if (((7480 - 5366) > (455 + 489)) and v23(v94.ThunderClap, not v14:IsInMeleeRange(804 - (588 + 208)))) then
						return "thunder_clap generic 20";
					end
					break;
				end
			end
		end
		if ((v94.Devastate:IsCastable() and v36) or ((6096 - 3834) >= (4896 - (884 + 916)))) then
			if (v23(v94.Devastate, not v98) or ((4721 - 2466) >= (2051 + 1486))) then
				return "devastate generic 22";
			end
		end
	end
	local function v112()
		local v127 = 653 - (232 + 421);
		while true do
			if ((v127 == (1889 - (1569 + 320))) or ((942 + 2895) < (249 + 1057))) then
				if (((9940 - 6990) == (3555 - (316 + 289))) and not v13:AffectingCombat()) then
					if ((v94.BattleShout:IsCastable() and v33 and (v13:BuffDown(v94.BattleShoutBuff, true) or v93.GroupBuffMissing(v94.BattleShoutBuff))) or ((12363 - 7640) < (153 + 3145))) then
						if (((2589 - (666 + 787)) >= (579 - (360 + 65))) and v23(v94.BattleShout)) then
							return "battle_shout precombat";
						end
					end
					if ((v92 and v94.BattleStance:IsCastable() and not v13:BuffUp(v94.BattleStance)) or ((254 + 17) > (5002 - (79 + 175)))) then
						if (((7474 - 2734) >= (2460 + 692)) and v23(v94.BattleStance)) then
							return "battle_stance precombat";
						end
					end
				end
				if ((v93.TargetIsValid() and v29) or ((7902 - 5324) >= (6528 - 3138))) then
					if (((940 - (503 + 396)) <= (1842 - (92 + 89))) and not v13:AffectingCombat()) then
						local v198 = 0 - 0;
						while true do
							if (((309 + 292) < (2107 + 1453)) and (v198 == (0 - 0))) then
								v28 = v109();
								if (((33 + 202) < (1566 - 879)) and v28) then
									return v28;
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
	local function v113()
		v28 = v107();
		if (((3969 + 580) > (551 + 602)) and v28) then
			return v28;
		end
		if (v84 or ((14235 - 9561) < (584 + 4088))) then
			local v166 = 0 - 0;
			while true do
				if (((4912 - (485 + 759)) < (10553 - 5992)) and (v166 == (1190 - (442 + 747)))) then
					v28 = v93.HandleIncorporeal(v94.IntimidatingShout, v96.IntimidatingShoutMouseover, 1143 - (832 + 303), true);
					if (v28 or ((1401 - (88 + 858)) == (1099 + 2506))) then
						return v28;
					end
					break;
				end
				if ((v166 == (0 + 0)) or ((110 + 2553) == (4101 - (766 + 23)))) then
					v28 = v93.HandleIncorporeal(v94.StormBolt, v96.StormBoltMouseover, 98 - 78, true);
					if (((5849 - 1572) <= (11790 - 7315)) and v28) then
						return v28;
					end
					v166 = 3 - 2;
				end
			end
		end
		if (v93.TargetIsValid() or ((1943 - (1036 + 37)) == (843 + 346))) then
			if (((3023 - 1470) <= (2465 + 668)) and v92 and (v13:HealthPercentage() <= v78)) then
				if ((v94.DefensiveStance:IsCastable() and not v13:BuffUp(v94.DefensiveStance)) or ((3717 - (641 + 839)) >= (4424 - (910 + 3)))) then
					if (v23(v94.DefensiveStance) or ((3375 - 2051) > (4704 - (1466 + 218)))) then
						return "defensive_stance while tanking";
					end
				end
			end
			if ((v92 and (v13:HealthPercentage() > v78)) or ((1376 + 1616) == (3029 - (556 + 592)))) then
				if (((1105 + 2001) > (2334 - (329 + 479))) and v94.BattleStance:IsCastable() and not v13:BuffUp(v94.BattleStance)) then
					if (((3877 - (174 + 680)) < (13297 - 9427)) and v23(v94.BattleStance)) then
						return "battle_stance while not tanking";
					end
				end
			end
			if (((295 - 152) > (53 + 21)) and v41 and ((v52 and v31) or not v52) and (v89 < v91) and v94.ShieldCharge:IsCastable() and not v98) then
				if (((757 - (396 + 343)) < (187 + 1925)) and v23(v94.ShieldCharge, not v14:IsSpellInRange(v94.ShieldCharge))) then
					return "shield_charge main 34";
				end
			end
			if (((2574 - (29 + 1448)) <= (3017 - (135 + 1254))) and v34 and v94.Charge:IsCastable() and not v98) then
				if (((17442 - 12812) == (21618 - 16988)) and v23(v94.Charge, not v14:IsSpellInRange(v94.Charge))) then
					return "charge main 34";
				end
			end
			if (((2360 + 1180) > (4210 - (389 + 1138))) and (v89 < v91)) then
				if (((5368 - (102 + 472)) >= (3091 + 184)) and v48 and ((v31 and v55) or not v55)) then
					v28 = v108();
					if (((823 + 661) == (1384 + 100)) and v28) then
						return v28;
					end
				end
			end
			if (((2977 - (320 + 1225)) < (6328 - 2773)) and v38 and v94.HeroicThrow:IsCastable() and not v14:IsInRange(19 + 11)) then
				if (v23(v94.HeroicThrow, not v14:IsInRange(1494 - (157 + 1307))) or ((2924 - (821 + 1038)) > (8927 - 5349))) then
					return "heroic_throw main";
				end
			end
			if ((v94.WreckingThrow:IsCastable() and v47 and v14:AffectingCombat() and v101()) or ((525 + 4270) < (2499 - 1092))) then
				if (((690 + 1163) < (11929 - 7116)) and v23(v94.WreckingThrow, not v14:IsInRange(1056 - (834 + 192)))) then
					return "wrecking_throw main";
				end
			end
			if (((v89 < v91) and v32 and ((v50 and v31) or not v50) and v94.Avatar:IsCastable()) or ((180 + 2641) < (624 + 1807))) then
				if (v23(v94.Avatar) or ((62 + 2812) < (3378 - 1197))) then
					return "avatar main 2";
				end
			end
			if (((v89 < v91) and v49 and ((v56 and v31) or not v56)) or ((2993 - (300 + 4)) <= (92 + 251))) then
				local v190 = 0 - 0;
				while true do
					if ((v190 == (364 - (112 + 250))) or ((746 + 1123) == (5032 - 3023))) then
						if (v94.Fireblood:IsCastable() or ((2032 + 1514) < (1201 + 1121))) then
							if (v23(v94.Fireblood) or ((1558 + 524) == (2367 + 2406))) then
								return "fireblood main 12";
							end
						end
						if (((2410 + 834) > (2469 - (1001 + 413))) and v94.AncestralCall:IsCastable()) then
							if (v23(v94.AncestralCall) or ((7387 - 4074) <= (2660 - (244 + 638)))) then
								return "ancestral_call main 14";
							end
						end
						v190 = 696 - (627 + 66);
					end
					if ((v190 == (0 - 0)) or ((2023 - (512 + 90)) >= (4010 - (1665 + 241)))) then
						if (((2529 - (373 + 344)) <= (1466 + 1783)) and v94.BloodFury:IsCastable()) then
							if (((430 + 1193) <= (5161 - 3204)) and v23(v94.BloodFury)) then
								return "blood_fury main 4";
							end
						end
						if (((7465 - 3053) == (5511 - (35 + 1064))) and v94.Berserking:IsCastable()) then
							if (((1274 + 476) >= (1801 - 959)) and v23(v94.Berserking)) then
								return "berserking main 6";
							end
						end
						v190 = 1 + 0;
					end
					if (((5608 - (298 + 938)) > (3109 - (233 + 1026))) and (v190 == (1667 - (636 + 1030)))) then
						if (((119 + 113) < (802 + 19)) and v94.ArcaneTorrent:IsCastable()) then
							if (((154 + 364) < (61 + 841)) and v23(v94.ArcaneTorrent)) then
								return "arcane_torrent main 8";
							end
						end
						if (((3215 - (55 + 166)) > (167 + 691)) and v94.LightsJudgment:IsCastable()) then
							if (v23(v94.LightsJudgment) or ((378 + 3377) <= (3494 - 2579))) then
								return "lights_judgment main 10";
							end
						end
						v190 = 299 - (36 + 261);
					end
					if (((6900 - 2954) > (5111 - (34 + 1334))) and (v190 == (2 + 1))) then
						if (v94.BagofTricks:IsCastable() or ((1038 + 297) >= (4589 - (1035 + 248)))) then
							if (((4865 - (20 + 1)) > (1174 + 1079)) and v23(v94.BagofTricks)) then
								return "ancestral_call main 16";
							end
						end
						break;
					end
				end
			end
			local v167 = v93.HandleDPSPotion(v14:BuffUp(v94.AvatarBuff));
			if (((771 - (134 + 185)) == (1585 - (549 + 584))) and v167) then
				return v167;
			end
			if ((v94.IgnorePain:IsReady() and v64 and v103() and (v14:HealthPercentage() >= (705 - (314 + 371))) and (((v13:RageDeficit() <= (51 - 36)) and v94.ShieldSlam:CooldownUp()) or ((v13:RageDeficit() <= (1008 - (478 + 490))) and v94.ShieldCharge:CooldownUp() and v94.ChampionsBulwark:IsAvailable()) or ((v13:RageDeficit() <= (11 + 9)) and v94.ShieldCharge:CooldownUp()) or ((v13:RageDeficit() <= (1202 - (786 + 386))) and v94.DemoralizingShout:CooldownUp() and v94.BoomingVoice:IsAvailable()) or ((v13:RageDeficit() <= (64 - 44)) and v94.Avatar:CooldownUp()) or ((v13:RageDeficit() <= (1424 - (1055 + 324))) and v94.DemoralizingShout:CooldownUp() and v94.BoomingVoice:IsAvailable() and v13:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable()) or ((v13:RageDeficit() <= (1370 - (1093 + 247))) and v94.Avatar:CooldownUp() and v13:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable()) or (v13:RageDeficit() <= (18 + 2)) or ((v13:RageDeficit() <= (5 + 35)) and v94.ShieldSlam:CooldownUp() and v13:BuffUp(v94.ViolentOutburstBuff) and v94.HeavyRepercussions:IsAvailable() and v94.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (218 - 163)) and v94.ShieldSlam:CooldownUp() and v13:BuffUp(v94.ViolentOutburstBuff) and v13:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable() and v94.HeavyRepercussions:IsAvailable() and v94.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (57 - 40)) and v94.ShieldSlam:CooldownUp() and v94.HeavyRepercussions:IsAvailable()) or ((v13:RageDeficit() <= (50 - 32)) and v94.ShieldSlam:CooldownUp() and v94.ImpenetrableWall:IsAvailable()))) or ((11451 - 6894) < (743 + 1344))) then
				if (((14924 - 11050) == (13352 - 9478)) and v23(v94.IgnorePain, nil, nil, true)) then
					return "ignore_pain main 20";
				end
			end
			if ((v102() and v63 and v94.LastStand:IsCastable() and v13:BuffDown(v94.ShieldWallBuff) and (((v14:HealthPercentage() >= (68 + 22)) and v94.UnnervingFocus:IsAvailable()) or ((v14:HealthPercentage() <= (51 - 31)) and v94.UnnervingFocus:IsAvailable()) or v94.Bolster:IsAvailable() or v13:HasTier(718 - (364 + 324), 5 - 3))) or ((4650 - 2712) > (1636 + 3299))) then
				if (v23(v94.LastStand) or ((17804 - 13549) < (5481 - 2058))) then
					return "last_stand defensive";
				end
			end
			if (((4415 - 2961) <= (3759 - (1249 + 19))) and (v89 < v91) and v39 and ((v51 and v31) or not v51) and (v82 == "player") and v94.Ravager:IsCastable()) then
				local v191 = 0 + 0;
				while true do
					if (((0 - 0) == v191) or ((5243 - (686 + 400)) <= (2200 + 603))) then
						v106(239 - (73 + 156));
						if (((23 + 4830) >= (3793 - (721 + 90))) and v23(v96.RavagerPlayer, not v98)) then
							return "ravager main 24";
						end
						break;
					end
				end
			end
			if (((47 + 4087) > (10899 - 7542)) and (v89 < v91) and v39 and ((v51 and v31) or not v51) and (v82 == "cursor") and v94.Ravager:IsCastable()) then
				local v192 = 470 - (224 + 246);
				while true do
					if (((0 - 0) == v192) or ((6291 - 2874) < (460 + 2074))) then
						v106(1 + 9);
						if (v23(v96.RavagerCursor, not v98) or ((2000 + 722) <= (325 - 161))) then
							return "ravager main 24";
						end
						break;
					end
				end
			end
			if ((v94.DemoralizingShout:IsCastable() and v35 and v94.BoomingVoice:IsAvailable()) or ((8013 - 5605) < (2622 - (203 + 310)))) then
				v106(2023 - (1238 + 755));
				if (v23(v94.DemoralizingShout, not v98) or ((3 + 30) == (2989 - (709 + 825)))) then
					return "demoralizing_shout main 28";
				end
			end
			if (((v89 < v91) and v44 and ((v53 and v31) or not v53) and (v83 == "player") and v94.ChampionsSpear:IsCastable()) or ((815 - 372) >= (5848 - 1833))) then
				local v193 = 864 - (196 + 668);
				while true do
					if (((13352 - 9970) > (343 - 177)) and (v193 == (833 - (171 + 662)))) then
						v106(113 - (4 + 89));
						if (v23(v96.ChampionsSpearPlayer, not v98) or ((981 - 701) == (1114 + 1945))) then
							return "spear_of_bastion main 28";
						end
						break;
					end
				end
			end
			if (((8261 - 6380) > (508 + 785)) and (v89 < v91) and v44 and ((v53 and v31) or not v53) and (v83 == "cursor") and v94.ChampionsSpear:IsCastable()) then
				v106(1506 - (35 + 1451));
				if (((3810 - (28 + 1425)) == (4350 - (941 + 1052))) and v23(v96.ChampionsSpearCursor, not v98)) then
					return "spear_of_bastion main 28";
				end
			end
			if (((118 + 5) == (1637 - (822 + 692))) and (v89 < v91) and v46 and ((v54 and v31) or not v54) and v94.ThunderousRoar:IsCastable()) then
				if (v23(v94.ThunderousRoar, not v14:IsInMeleeRange(11 - 3)) or ((498 + 558) >= (3689 - (45 + 252)))) then
					return "thunderous_roar main 30";
				end
			end
			if ((v94.ShieldSlam:IsCastable() and v42 and v13:BuffUp(v94.FervidBuff)) or ((1070 + 11) < (370 + 705))) then
				if (v23(v94.ShieldSlam, not v98) or ((2552 - 1503) >= (4865 - (114 + 319)))) then
					return "shield_slam main 31";
				end
			end
			if ((v94.Shockwave:IsCastable() and v43 and v13:BuffUp(v94.AvatarBuff) and v94.UnstoppableForce:IsAvailable() and not v94.RumblingEarth:IsAvailable()) or (v94.SonicBoom:IsAvailable() and v94.RumblingEarth:IsAvailable() and (v100 >= (3 - 0)) and v14:IsCasting()) or ((6109 - 1341) <= (540 + 306))) then
				local v194 = 0 - 0;
				while true do
					if ((v194 == (0 - 0)) or ((5321 - (556 + 1407)) <= (2626 - (741 + 465)))) then
						v106(475 - (170 + 295));
						if (v23(v94.Shockwave, not v14:IsInMeleeRange(5 + 3)) or ((3435 + 304) <= (7398 - 4393))) then
							return "shockwave main 32";
						end
						break;
					end
				end
			end
			if (((v89 < v91) and v94.ShieldCharge:IsCastable() and v41 and ((v52 and v31) or not v52)) or ((1376 + 283) >= (1369 + 765))) then
				if (v23(v94.ShieldCharge, not v14:IsSpellInRange(v94.ShieldCharge)) or ((1847 + 1413) < (3585 - (957 + 273)))) then
					return "shield_charge main 34";
				end
			end
			if ((v105() and v62) or ((179 + 490) == (1691 + 2532))) then
				if (v23(v94.ShieldBlock) or ((6447 - 4755) < (1549 - 961))) then
					return "shield_block main 38";
				end
			end
			if ((v100 > (9 - 6)) or ((23753 - 18956) < (5431 - (389 + 1391)))) then
				local v195 = 0 + 0;
				while true do
					if ((v195 == (1 + 0)) or ((9509 - 5332) > (5801 - (783 + 168)))) then
						if (v19.CastAnnotated(v94.Pool, false, "WAIT") or ((1342 - 942) > (1093 + 18))) then
							return "Pool for Aoe()";
						end
						break;
					end
					if (((3362 - (309 + 2)) > (3086 - 2081)) and (v195 == (1212 - (1090 + 122)))) then
						v28 = v110();
						if (((1198 + 2495) <= (14716 - 10334)) and v28) then
							return v28;
						end
						v195 = 1 + 0;
					end
				end
			end
			v28 = v111();
			if (v28 or ((4400 - (628 + 490)) > (736 + 3364))) then
				return v28;
			end
			if (v19.CastAnnotated(v94.Pool, false, "WAIT") or ((8863 - 5283) < (12997 - 10153))) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v114()
		local v128 = 774 - (431 + 343);
		while true do
			if (((179 - 90) < (12989 - 8499)) and (v128 == (4 + 1))) then
				v54 = EpicSettings.Settings['thunderousRoarWithCD'];
				break;
			end
			if (((1 + 0) == v128) or ((6678 - (556 + 1139)) < (1823 - (6 + 9)))) then
				v37 = EpicSettings.Settings['useExecute'];
				v38 = EpicSettings.Settings['useHeroicThrow'];
				v40 = EpicSettings.Settings['useRevenge'];
				v42 = EpicSettings.Settings['useShieldSlam'];
				v128 = 1 + 1;
			end
			if (((1962 + 1867) > (3938 - (28 + 141))) and (v128 == (0 + 0))) then
				v33 = EpicSettings.Settings['useBattleShout'];
				v34 = EpicSettings.Settings['useCharge'];
				v35 = EpicSettings.Settings['useDemoralizingShout'];
				v36 = EpicSettings.Settings['useDevastate'];
				v128 = 1 - 0;
			end
			if (((1052 + 433) <= (4221 - (486 + 831))) and ((7 - 4) == v128)) then
				v39 = EpicSettings.Settings['useRavager'];
				v41 = EpicSettings.Settings['useShieldCharge'];
				v44 = EpicSettings.Settings['useChampionsSpear'];
				v46 = EpicSettings.Settings['useThunderousRoar'];
				v128 = 13 - 9;
			end
			if (((807 + 3462) == (13498 - 9229)) and ((1265 - (668 + 595)) == v128)) then
				v43 = EpicSettings.Settings['useShockwave'];
				v45 = EpicSettings.Settings['useThunderClap'];
				v47 = EpicSettings.Settings['useWreckingThrow'];
				v32 = EpicSettings.Settings['useAvatar'];
				v128 = 3 + 0;
			end
			if (((79 + 308) <= (7586 - 4804)) and ((294 - (23 + 267)) == v128)) then
				v50 = EpicSettings.Settings['avatarWithCD'];
				v51 = EpicSettings.Settings['ravagerWithCD'];
				v52 = EpicSettings.Settings['shieldChargeWithCD'];
				v53 = EpicSettings.Settings['championsSpearWithCD'];
				v128 = 1949 - (1129 + 815);
			end
		end
	end
	local function v115()
		v57 = EpicSettings.Settings['usePummel'];
		v58 = EpicSettings.Settings['useStormBolt'];
		v59 = EpicSettings.Settings['useIntimidatingShout'];
		v60 = EpicSettings.Settings['useBitterImmunity'];
		v64 = EpicSettings.Settings['useIgnorePain'];
		v66 = EpicSettings.Settings['useIntervene'];
		v63 = EpicSettings.Settings['useLastStand'];
		v65 = EpicSettings.Settings['useRallyingCry'];
		v62 = EpicSettings.Settings['useShieldBlock'];
		v61 = EpicSettings.Settings['useShieldWall'];
		v69 = EpicSettings.Settings['useVictoryRush'];
		v92 = EpicSettings.Settings['useChangeStance'];
		v70 = EpicSettings.Settings['bitterImmunityHP'] or (387 - (371 + 16));
		v74 = EpicSettings.Settings['ignorePainHP'] or (1750 - (1326 + 424));
		v77 = EpicSettings.Settings['interveneHP'] or (0 - 0);
		v73 = EpicSettings.Settings['lastStandHP'] or (0 - 0);
		v76 = EpicSettings.Settings['rallyingCryGroup'] or (118 - (88 + 30));
		v75 = EpicSettings.Settings['rallyingCryHP'] or (771 - (720 + 51));
		v72 = EpicSettings.Settings['shieldBlockHP'] or (0 - 0);
		v71 = EpicSettings.Settings['shieldWallHP'] or (1776 - (421 + 1355));
		v81 = EpicSettings.Settings['victoryRushHP'] or (0 - 0);
		v78 = EpicSettings.Settings['defensiveStanceHP'] or (0 + 0);
		v82 = EpicSettings.Settings['ravagerSetting'] or "";
		v83 = EpicSettings.Settings['spearSetting'] or "";
	end
	local function v116()
		v89 = EpicSettings.Settings['fightRemainsCheck'] or (1083 - (286 + 797));
		v86 = EpicSettings.Settings['InterruptWithStun'];
		v87 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v88 = EpicSettings.Settings['InterruptThreshold'];
		v48 = EpicSettings.Settings['useTrinkets'];
		v49 = EpicSettings.Settings['useRacials'];
		v55 = EpicSettings.Settings['trinketsWithCD'];
		v56 = EpicSettings.Settings['racialsWithCD'];
		v67 = EpicSettings.Settings['useHealthstone'];
		v68 = EpicSettings.Settings['useHealingPotion'];
		v79 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v80 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v85 = EpicSettings.Settings['HealingPotionName'] or "";
		v84 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v117()
		v115();
		v114();
		v116();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		if (v13:IsDeadOrGhost() or ((2338 - (397 + 42)) <= (287 + 630))) then
			return v28;
		end
		if (v30 or ((5112 - (24 + 776)) <= (1349 - 473))) then
			local v168 = 785 - (222 + 563);
			while true do
				if (((4917 - 2685) <= (1870 + 726)) and (v168 == (190 - (23 + 167)))) then
					v99 = v13:GetEnemiesInMeleeRange(1806 - (690 + 1108));
					v100 = #v99;
					break;
				end
			end
		else
			v100 = 1 + 0;
		end
		v98 = v14:IsInMeleeRange(7 + 1);
		if (((2943 - (40 + 808)) < (607 + 3079)) and (v93.TargetIsValid() or v13:AffectingCombat())) then
			v90 = v10.BossFightRemains(nil, true);
			v91 = v90;
			if ((v91 == (42488 - 31377)) or ((1525 + 70) >= (2367 + 2107))) then
				v91 = v10.FightRemains(v99, false);
			end
		end
		if (not v13:IsChanneling() or ((2533 + 2086) < (3453 - (47 + 524)))) then
			if (v13:AffectingCombat() or ((191 + 103) >= (13205 - 8374))) then
				local v196 = 0 - 0;
				while true do
					if (((4626 - 2597) <= (4810 - (1165 + 561))) and (v196 == (0 + 0))) then
						v28 = v113();
						if (v28 or ((6308 - 4271) == (924 + 1496))) then
							return v28;
						end
						break;
					end
				end
			else
				local v197 = 479 - (341 + 138);
				while true do
					if (((1204 + 3254) > (8056 - 4152)) and (v197 == (326 - (89 + 237)))) then
						v28 = v112();
						if (((1402 - 966) >= (258 - 135)) and v28) then
							return v28;
						end
						break;
					end
				end
			end
		end
	end
	local function v118()
		v19.Print("Protection Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(954 - (581 + 300), v117, v118);
end;
return v0["Epix_Warrior_Protection.lua"]();

