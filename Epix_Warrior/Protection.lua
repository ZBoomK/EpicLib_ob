local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((25 + 607) >= (2326 - (1427 + 192)))) then
			v6 = v0[v4];
			if (not v6 or ((190 + 356) >= (6231 - 3547))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((664 + 801) <= (4627 - (192 + 134))) and (v5 == (1277 - (316 + 960)))) then
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
	local v90 = 6184 + 4927;
	local v91 = 8575 + 2536;
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
		local v119 = 0 + 0;
		local v120;
		while true do
			if (((6514 - 4810) > (1976 - (83 + 468))) and (v119 == (1806 - (1202 + 604)))) then
				v120 = UnitGetTotalAbsorbs(v14:ID());
				if ((v120 > (0 - 0)) or ((1143 - 456) == (11722 - 7488))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v102()
		return v13:IsTankingAoE(341 - (45 + 280)) or v13:IsTanking(v14) or v14:IsDummy();
	end
	local function v103()
		if (v13:BuffUp(v94.IgnorePain) or ((3215 + 115) < (1249 + 180))) then
			local v146 = 0 + 0;
			local v147;
			local v148;
			local v149;
			while true do
				if (((635 + 512) >= (59 + 276)) and ((1 - 0) == v146)) then
					v149 = v148.points[1912 - (340 + 1571)];
					return v149 < v147;
				end
				if (((1355 + 2080) > (3869 - (1733 + 39))) and (v146 == (0 - 0))) then
					v147 = v13:AttackPowerDamageMod() * (1037.5 - (125 + 909)) * ((1949 - (1096 + 852)) + (v13:VersatilityDmgPct() / (45 + 55)));
					v148 = v13:AuraInfo(v94.IgnorePain, nil, true);
					v146 = 1 - 0;
				end
			end
		else
			return true;
		end
	end
	local function v104()
		if (v13:BuffUp(v94.IgnorePain) or ((3657 + 113) >= (4553 - (409 + 103)))) then
			local v150 = v13:BuffInfo(v94.IgnorePain, nil, true);
			return v150.points[237 - (46 + 190)];
		else
			return 95 - (51 + 44);
		end
	end
	local function v105()
		return v102() and v94.ShieldBlock:IsReady() and (((v13:BuffRemains(v94.ShieldBlockBuff) <= (6 + 12)) and v94.EnduringDefenses:IsAvailable()) or (v13:BuffRemains(v94.ShieldBlockBuff) <= (1329 - (1114 + 203))));
	end
	local function v106(v121)
		local v122 = 726 - (228 + 498);
		local v123;
		local v124;
		local v125;
		while true do
			if (((1 + 0) == v122) or ((2095 + 1696) <= (2274 - (174 + 489)))) then
				v124 = false;
				v125 = (v13:Rage() >= (91 - 56)) and not v105();
				v122 = 1907 - (830 + 1075);
			end
			if (((524 - (303 + 221)) == v122) or ((5847 - (231 + 1038)) <= (1674 + 334))) then
				v123 = 1242 - (171 + 991);
				if (((4636 - 3511) <= (5574 - 3498)) and ((v123 < (87 - 52)) or (v13:Rage() < (29 + 6)))) then
					return false;
				end
				v122 = 3 - 2;
			end
			if ((v122 == (5 - 3)) or ((1197 - 454) >= (13598 - 9199))) then
				if (((2403 - (111 + 1137)) < (1831 - (91 + 67))) and v125 and (((v13:Rage() + v121) >= v123) or v94.DemoralizingShout:IsReady())) then
					v124 = true;
				end
				if (v124 or ((6916 - 4592) <= (145 + 433))) then
					if (((4290 - (423 + 100)) == (27 + 3740)) and v102() and v103()) then
						if (((11321 - 7232) == (2132 + 1957)) and v23(v94.IgnorePain, nil, nil, true)) then
							return "ignore_pain rage capped";
						end
					elseif (((5229 - (326 + 445)) >= (7305 - 5631)) and v23(v94.Revenge, not v98)) then
						return "revenge rage capped";
					end
				end
				break;
			end
		end
	end
	local function v107()
		local v126 = 0 - 0;
		while true do
			if (((2268 - 1296) <= (2129 - (530 + 181))) and (v126 == (883 - (614 + 267)))) then
				if ((v94.Intervene:IsReady() and v66 and (v16:HealthPercentage() <= v77) and (v16:Name() ~= v13:Name())) or ((4970 - (19 + 13)) < (7750 - 2988))) then
					if (v23(v96.InterveneFocus) or ((5835 - 3331) > (12180 - 7916))) then
						return "intervene defensive";
					end
				end
				if (((560 + 1593) == (3785 - 1632)) and v94.ShieldWall:IsCastable() and v61 and v13:BuffDown(v94.ShieldWallBuff) and ((v13:HealthPercentage() <= v71) or v13:ActiveMitigationNeeded())) then
					if (v23(v94.ShieldWall) or ((1050 - 543) >= (4403 - (1293 + 519)))) then
						return "shield_wall defensive";
					end
				end
				v126 = 5 - 2;
			end
			if (((11699 - 7218) == (8568 - 4087)) and (v126 == (0 - 0))) then
				if ((v94.BitterImmunity:IsReady() and v60 and (v13:HealthPercentage() <= v70)) or ((5484 - 3156) < (368 + 325))) then
					if (((883 + 3445) == (10055 - 5727)) and v23(v94.BitterImmunity)) then
						return "bitter_immunity defensive";
					end
				end
				if (((367 + 1221) >= (443 + 889)) and v94.LastStand:IsCastable() and v63 and ((v13:HealthPercentage() <= v73) or v13:ActiveMitigationNeeded())) then
					if (v23(v94.LastStand) or ((2609 + 1565) > (5344 - (709 + 387)))) then
						return "last_stand defensive";
					end
				end
				v126 = 1859 - (673 + 1185);
			end
			if ((v126 == (8 - 5)) or ((14726 - 10140) <= (134 - 52))) then
				if (((2764 + 1099) == (2887 + 976)) and v95.Healthstone:IsReady() and v67 and (v13:HealthPercentage() <= v79)) then
					if (v23(v96.Healthstone) or ((380 - 98) <= (11 + 31))) then
						return "healthstone defensive 3";
					end
				end
				if (((9189 - 4580) >= (1503 - 737)) and v68 and (v13:HealthPercentage() <= v80)) then
					local v188 = 1880 - (446 + 1434);
					while true do
						if ((v188 == (1283 - (1040 + 243))) or ((3438 - 2286) == (4335 - (559 + 1288)))) then
							if (((5353 - (609 + 1322)) > (3804 - (13 + 441))) and (v85 == "Refreshing Healing Potion")) then
								if (((3277 - 2400) > (984 - 608)) and v95.RefreshingHealingPotion:IsReady()) then
									if (v23(v96.RefreshingHealingPotion) or ((15529 - 12411) <= (69 + 1782))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v85 == "Dreamwalker's Healing Potion") or ((599 - 434) >= (1241 + 2251))) then
								if (((1731 + 2218) < (14410 - 9554)) and v95.DreamwalkersHealingPotion:IsReady()) then
									if (v23(v96.RefreshingHealingPotion) or ((2340 + 1936) < (5546 - 2530))) then
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
			if (((3101 + 1589) > (2295 + 1830)) and ((1 + 0) == v126)) then
				if ((v94.IgnorePain:IsReady() and v64 and (v13:HealthPercentage() <= v74) and v103()) or ((42 + 8) >= (877 + 19))) then
					if (v23(v94.IgnorePain, nil, nil, true) or ((2147 - (153 + 280)) >= (8541 - 5583))) then
						return "ignore_pain defensive";
					end
				end
				if ((v94.RallyingCry:IsReady() and v65 and v13:BuffDown(v94.AspectsFavorBuff) and v13:BuffDown(v94.RallyingCry) and (((v13:HealthPercentage() <= v75) and v93.IsSoloMode()) or v93.AreUnitsBelowHealthPercentage(v75, v76))) or ((1339 + 152) < (255 + 389))) then
					if (((369 + 335) < (896 + 91)) and v23(v94.RallyingCry)) then
						return "rallying_cry defensive";
					end
				end
				v126 = 2 + 0;
			end
		end
	end
	local function v108()
		local v127 = 0 - 0;
		while true do
			if (((2298 + 1420) > (2573 - (89 + 578))) and (v127 == (1 + 0))) then
				v28 = v93.HandleBottomTrinket(v97, v31, 83 - 43, nil);
				if (v28 or ((2007 - (572 + 477)) > (491 + 3144))) then
					return v28;
				end
				break;
			end
			if (((2102 + 1399) <= (537 + 3955)) and (v127 == (86 - (84 + 2)))) then
				v28 = v93.HandleTopTrinket(v97, v31, 65 - 25, nil);
				if (v28 or ((2480 + 962) < (3390 - (497 + 345)))) then
					return v28;
				end
				v127 = 1 + 0;
			end
		end
	end
	local function v109()
		if (((487 + 2388) >= (2797 - (605 + 728))) and v14:IsInMeleeRange(6 + 2)) then
			if ((v94.ThunderClap:IsCastable() and v45) or ((10664 - 5867) >= (225 + 4668))) then
				if (v23(v94.ThunderClap) or ((2037 - 1486) > (1865 + 203))) then
					return "thunder_clap precombat";
				end
			end
		elseif (((5857 - 3743) > (713 + 231)) and v34 and v94.Charge:IsCastable() and not v14:IsInRange(497 - (457 + 32))) then
			if (v23(v94.Charge, not v14:IsSpellInRange(v94.Charge)) or ((960 + 1302) >= (4498 - (832 + 570)))) then
				return "charge precombat";
			end
		end
	end
	local function v110()
		local v128 = 0 + 0;
		while true do
			if ((v128 == (1 + 1)) or ((7980 - 5725) >= (1704 + 1833))) then
				if ((v94.ShieldSlam:IsCastable() and v42 and ((v13:Rage() <= (856 - (588 + 208))) or (v13:BuffUp(v94.ViolentOutburstBuff) and (v100 <= (18 - 11))))) or ((5637 - (884 + 916)) < (2733 - 1427))) then
					local v189 = 0 + 0;
					while true do
						if (((3603 - (232 + 421)) == (4839 - (1569 + 320))) and ((0 + 0) == v189)) then
							v106(4 + 16);
							if (v23(v94.ShieldSlam, not v98) or ((15915 - 11192) < (3903 - (316 + 289)))) then
								return "shield_slam aoe 8";
							end
							break;
						end
					end
				end
				if (((2973 - 1837) >= (8 + 146)) and v94.ThunderClap:IsCastable() and v45) then
					local v190 = 1453 - (666 + 787);
					while true do
						if ((v190 == (425 - (360 + 65))) or ((254 + 17) > (5002 - (79 + 175)))) then
							v106(7 - 2);
							if (((3699 + 1041) >= (9661 - 6509)) and v23(v94.ThunderClap, not v14:IsInMeleeRange(15 - 7))) then
								return "thunder_clap aoe 10";
							end
							break;
						end
					end
				end
				v128 = 902 - (503 + 396);
			end
			if ((v128 == (181 - (92 + 89))) or ((5000 - 2422) >= (1739 + 1651))) then
				if (((25 + 16) <= (6504 - 4843)) and v94.ThunderClap:IsCastable() and v45 and (v14:DebuffRemains(v94.RendDebuff) <= (1 + 0))) then
					local v191 = 0 - 0;
					while true do
						if (((525 + 76) < (1701 + 1859)) and (v191 == (0 - 0))) then
							v106(1 + 4);
							if (((358 - 123) < (1931 - (485 + 759))) and v23(v94.ThunderClap, not v14:IsInMeleeRange(18 - 10))) then
								return "thunder_clap aoe 2";
							end
							break;
						end
					end
				end
				if (((5738 - (442 + 747)) > (2288 - (832 + 303))) and v94.ShieldSlam:IsCastable() and v42 and ((v13:HasTier(976 - (88 + 858), 1 + 1) and (v100 <= (6 + 1))) or v13:BuffUp(v94.EarthenTenacityBuff))) then
					if (v23(v94.ShieldSlam, not v98) or ((193 + 4481) < (5461 - (766 + 23)))) then
						return "shield_slam aoe 3";
					end
				end
				v128 = 4 - 3;
			end
			if (((5016 - 1348) < (12016 - 7455)) and (v128 == (3 - 2))) then
				if ((v94.ThunderClap:IsCastable() and v45 and v13:BuffUp(v94.ViolentOutburstBuff) and (v100 > (1078 - (1036 + 37))) and v13:BuffUp(v94.AvatarBuff) and v94.UnstoppableForce:IsAvailable()) or ((323 + 132) == (7020 - 3415))) then
					local v192 = 0 + 0;
					while true do
						if (((1480 - (641 + 839)) == v192) or ((3576 - (910 + 3)) == (8443 - 5131))) then
							v106(1689 - (1466 + 218));
							if (((1966 + 2311) <= (5623 - (556 + 592))) and v23(v94.ThunderClap, not v14:IsInMeleeRange(3 + 5))) then
								return "thunder_clap aoe 4";
							end
							break;
						end
					end
				end
				if ((v94.Revenge:IsReady() and v40 and (v13:Rage() >= (878 - (329 + 479))) and v94.SeismicReverberation:IsAvailable() and (v100 >= (857 - (174 + 680)))) or ((2989 - 2119) == (2463 - 1274))) then
					if (((1109 + 444) <= (3872 - (396 + 343))) and v23(v94.Revenge, not v98)) then
						return "revenge aoe 6";
					end
				end
				v128 = 1 + 1;
			end
			if ((v128 == (1480 - (29 + 1448))) or ((3626 - (135 + 1254)) >= (13226 - 9715))) then
				if ((v94.Revenge:IsReady() and v40 and ((v13:Rage() >= (140 - 110)) or ((v13:Rage() >= (27 + 13)) and v94.BarbaricTraining:IsAvailable()))) or ((2851 - (389 + 1138)) > (3594 - (102 + 472)))) then
					if (v23(v94.Revenge, not v98) or ((2824 + 168) == (1044 + 837))) then
						return "revenge aoe 12";
					end
				end
				break;
			end
		end
	end
	local function v111()
		local v129 = 0 + 0;
		while true do
			if (((4651 - (320 + 1225)) > (2716 - 1190)) and (v129 == (1 + 0))) then
				if (((4487 - (157 + 1307)) < (5729 - (821 + 1038))) and v94.Execute:IsReady() and v37 and (v100 == (2 - 1)) and (v13:Rage() >= (6 + 44))) then
					if (((253 - 110) > (28 + 46)) and v23(v94.Execute, not v98)) then
						return "execute generic 10";
					end
				end
				if (((44 - 26) < (3138 - (834 + 192))) and v94.ThunderClap:IsCastable() and v45 and ((v100 > (1 + 0)) or (v94.ShieldSlam:CooldownDown() and not v13:BuffUp(v94.ViolentOutburstBuff)))) then
					local v193 = 0 + 0;
					while true do
						if (((24 + 1073) <= (2521 - 893)) and (v193 == (304 - (300 + 4)))) then
							v106(2 + 3);
							if (((12120 - 7490) == (4992 - (112 + 250))) and v23(v94.ThunderClap, not v14:IsInMeleeRange(4 + 4))) then
								return "thunder_clap generic 12";
							end
							break;
						end
					end
				end
				if (((8868 - 5328) > (1538 + 1145)) and v94.Revenge:IsReady() and v40 and (((v13:Rage() >= (32 + 28)) and (v14:HealthPercentage() > (15 + 5))) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() <= (10 + 10)) and (v13:Rage() <= (14 + 4)) and v94.ShieldSlam:CooldownDown()) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() > (1434 - (1001 + 413)))) or ((((v13:Rage() >= (133 - 73)) and (v14:HealthPercentage() > (917 - (244 + 638)))) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() <= (728 - (627 + 66))) and (v13:Rage() <= (53 - 35)) and v94.ShieldSlam:CooldownDown()) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() > (637 - (512 + 90))))) and v94.Massacre:IsAvailable()))) then
					if (((6700 - (1665 + 241)) >= (3992 - (373 + 344))) and v23(v94.Revenge, not v98)) then
						return "revenge generic 14";
					end
				end
				if (((670 + 814) == (393 + 1091)) and v94.Execute:IsReady() and v37 and (v100 == (2 - 1))) then
					if (((2422 - 990) < (4654 - (35 + 1064))) and v23(v94.Execute, not v98)) then
						return "execute generic 16";
					end
				end
				v129 = 2 + 0;
			end
			if ((v129 == (4 - 2)) or ((5 + 1060) > (4814 - (298 + 938)))) then
				if ((v94.Revenge:IsReady() and v40 and (v14:HealthPercentage() > (1279 - (233 + 1026)))) or ((6461 - (636 + 1030)) < (720 + 687))) then
					if (((1810 + 43) < (1430 + 3383)) and v23(v94.Revenge, not v98)) then
						return "revenge generic 18";
					end
				end
				if ((v94.ThunderClap:IsCastable() and v45 and ((v100 >= (1 + 0)) or (v94.ShieldSlam:CooldownDown() and v13:BuffUp(v94.ViolentOutburstBuff)))) or ((3042 - (55 + 166)) < (472 + 1959))) then
					v106(1 + 4);
					if (v23(v94.ThunderClap, not v14:IsInMeleeRange(30 - 22)) or ((3171 - (36 + 261)) < (3814 - 1633))) then
						return "thunder_clap generic 20";
					end
				end
				if ((v94.Devastate:IsCastable() and v36) or ((4057 - (34 + 1334)) <= (132 + 211))) then
					if (v23(v94.Devastate, not v98) or ((1453 + 416) == (3292 - (1035 + 248)))) then
						return "devastate generic 22";
					end
				end
				break;
			end
			if ((v129 == (21 - (20 + 1))) or ((1848 + 1698) < (2641 - (134 + 185)))) then
				if ((v94.ShieldSlam:IsCastable() and v42) or ((3215 - (549 + 584)) == (5458 - (314 + 371)))) then
					v106(68 - 48);
					if (((4212 - (478 + 490)) > (559 + 496)) and v23(v94.ShieldSlam, not v98)) then
						return "shield_slam generic 2";
					end
				end
				if ((v94.ThunderClap:IsCastable() and v45 and (v14:DebuffRemains(v94.RendDebuff) <= (1173 - (786 + 386))) and v13:BuffDown(v94.ViolentOutburstBuff)) or ((10730 - 7417) <= (3157 - (1055 + 324)))) then
					v106(1345 - (1093 + 247));
					if (v23(v94.ThunderClap, not v14:IsInMeleeRange(8 + 0)) or ((150 + 1271) >= (8353 - 6249))) then
						return "thunder_clap generic 4";
					end
				end
				if (((6149 - 4337) <= (9244 - 5995)) and v94.Execute:IsReady() and v37 and v13:BuffUp(v94.SuddenDeathBuff) and v94.SuddenDeath:IsAvailable()) then
					if (((4078 - 2455) <= (697 + 1260)) and v23(v94.Execute, not v98)) then
						return "execute generic 6";
					end
				end
				if (((16996 - 12584) == (15207 - 10795)) and v94.Execute:IsReady() and v37 and (v100 == (1 + 0)) and (v94.Massacre:IsAvailable() or v94.Juggernaut:IsAvailable()) and (v13:Rage() >= (127 - 77))) then
					if (((2438 - (364 + 324)) >= (2307 - 1465)) and v23(v94.Execute, not v98)) then
						return "execute generic 6";
					end
				end
				v129 = 2 - 1;
			end
		end
	end
	local function v112()
		local v130 = 0 + 0;
		while true do
			if (((18293 - 13921) > (2962 - 1112)) and (v130 == (0 - 0))) then
				if (((1500 - (1249 + 19)) < (742 + 79)) and not v13:AffectingCombat()) then
					if (((2016 - 1498) < (1988 - (686 + 400))) and v94.BattleShout:IsCastable() and v33 and (v13:BuffDown(v94.BattleShoutBuff, true) or v93.GroupBuffMissing(v94.BattleShoutBuff))) then
						if (((2350 + 644) > (1087 - (73 + 156))) and v23(v94.BattleShout)) then
							return "battle_shout precombat";
						end
					end
					if ((v92 and v94.BattleStance:IsCastable() and not v13:BuffUp(v94.BattleStance)) or ((18 + 3737) <= (1726 - (721 + 90)))) then
						if (((45 + 3901) > (12153 - 8410)) and v23(v94.BattleStance)) then
							return "battle_stance precombat";
						end
					end
				end
				if ((v93.TargetIsValid() and v29) or ((1805 - (224 + 246)) >= (5355 - 2049))) then
					if (((8918 - 4074) > (409 + 1844)) and not v13:AffectingCombat()) then
						local v198 = 0 + 0;
						while true do
							if (((332 + 120) == (898 - 446)) and (v198 == (0 - 0))) then
								v28 = v109();
								if (v28 or ((5070 - (203 + 310)) < (4080 - (1238 + 755)))) then
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
		local v131 = 0 + 0;
		while true do
			if (((5408 - (709 + 825)) == (7138 - 3264)) and (v131 == (0 - 0))) then
				v28 = v107();
				if (v28 or ((2802 - (196 + 668)) > (19484 - 14549))) then
					return v28;
				end
				v131 = 1 - 0;
			end
			if (((834 - (171 + 662)) == v131) or ((4348 - (4 + 89)) < (11997 - 8574))) then
				if (((530 + 924) <= (10940 - 8449)) and v84) then
					local v194 = 0 + 0;
					while true do
						if ((v194 == (1486 - (35 + 1451))) or ((5610 - (28 + 1425)) <= (4796 - (941 + 1052)))) then
							v28 = v93.HandleIncorporeal(v94.StormBolt, v96.StormBoltMouseover, 20 + 0, true);
							if (((6367 - (822 + 692)) >= (4256 - 1274)) and v28) then
								return v28;
							end
							v194 = 1 + 0;
						end
						if (((4431 - (45 + 252)) > (3322 + 35)) and (v194 == (1 + 0))) then
							v28 = v93.HandleIncorporeal(v94.IntimidatingShout, v96.IntimidatingShoutMouseover, 19 - 11, true);
							if (v28 or ((3850 - (114 + 319)) < (3638 - 1104))) then
								return v28;
							end
							break;
						end
					end
				end
				if (v93.TargetIsValid() or ((3487 - 765) <= (105 + 59))) then
					if ((v92 and (v13:HealthPercentage() <= v78)) or ((3587 - 1179) < (4418 - 2309))) then
						if ((v94.DefensiveStance:IsCastable() and not v13:BuffUp(v94.DefensiveStance)) or ((1996 - (556 + 1407)) == (2661 - (741 + 465)))) then
							if (v23(v94.DefensiveStance) or ((908 - (170 + 295)) >= (2116 + 1899))) then
								return "defensive_stance while tanking";
							end
						end
					end
					if (((3107 + 275) > (408 - 242)) and v92 and (v13:HealthPercentage() > v78)) then
						if ((v94.BattleStance:IsCastable() and not v13:BuffUp(v94.BattleStance)) or ((233 + 47) == (1962 + 1097))) then
							if (((1066 + 815) > (2523 - (957 + 273))) and v23(v94.BattleStance)) then
								return "battle_stance while not tanking";
							end
						end
					end
					if (((631 + 1726) == (944 + 1413)) and v41 and ((v52 and v31) or not v52) and (v89 < v91) and v94.ShieldCharge:IsCastable() and not v98) then
						if (((468 - 345) == (324 - 201)) and v23(v94.ShieldCharge, not v14:IsSpellInRange(v94.ShieldCharge))) then
							return "shield_charge main 34";
						end
					end
					if ((v34 and v94.Charge:IsCastable() and not v98) or ((3225 - 2169) >= (16796 - 13404))) then
						if (v23(v94.Charge, not v14:IsSpellInRange(v94.Charge)) or ((2861 - (389 + 1391)) < (675 + 400))) then
							return "charge main 34";
						end
					end
					if ((v89 < v91) or ((110 + 939) >= (10089 - 5657))) then
						if ((v48 and ((v31 and v55) or not v55)) or ((5719 - (783 + 168)) <= (2839 - 1993))) then
							v28 = v108();
							if (v28 or ((3304 + 54) <= (1731 - (309 + 2)))) then
								return v28;
							end
						end
						if ((v31 and v95.FyralathTheDreamrender:IsEquippedAndReady()) or ((11481 - 7742) <= (4217 - (1090 + 122)))) then
							if (v23(v96.UseWeapon) or ((538 + 1121) >= (7166 - 5032))) then
								return "Fyralath The Dreamrender used";
							end
						end
					end
					if ((v38 and v94.HeroicThrow:IsCastable() and not v14:IsInRange(18 + 7)) or ((4378 - (628 + 490)) < (423 + 1932))) then
						if (v23(v94.HeroicThrow, not v14:IsSpellInRange(v94.HeroicThrow)) or ((1655 - 986) == (19299 - 15076))) then
							return "heroic_throw main";
						end
					end
					if ((v94.WreckingThrow:IsCastable() and v47 and v13:CanAttack(v14) and v101()) or ((2466 - (431 + 343)) < (1187 - 599))) then
						if (v23(v94.WreckingThrow, not v14:IsSpellInRange(v94.WreckingThrow)) or ((13877 - 9080) < (2885 + 766))) then
							return "wrecking_throw main";
						end
					end
					if (((v89 < v91) and v32 and ((v50 and v31) or not v50) and v94.Avatar:IsCastable()) or ((535 + 3642) > (6545 - (556 + 1139)))) then
						if (v23(v94.Avatar) or ((415 - (6 + 9)) > (204 + 907))) then
							return "avatar main 2";
						end
					end
					if (((1563 + 1488) > (1174 - (28 + 141))) and (v89 < v91) and v49 and ((v56 and v31) or not v56)) then
						local v199 = 0 + 0;
						while true do
							if (((4557 - 864) <= (3104 + 1278)) and (v199 == (1318 - (486 + 831)))) then
								if (v94.ArcaneTorrent:IsCastable() or ((8540 - 5258) > (14434 - 10334))) then
									if (v23(v94.ArcaneTorrent) or ((677 + 2903) < (8992 - 6148))) then
										return "arcane_torrent main 8";
									end
								end
								if (((1352 - (668 + 595)) < (4041 + 449)) and v94.LightsJudgment:IsCastable()) then
									if (v23(v94.LightsJudgment) or ((1005 + 3978) < (4930 - 3122))) then
										return "lights_judgment main 10";
									end
								end
								v199 = 292 - (23 + 267);
							end
							if (((5773 - (1129 + 815)) > (4156 - (371 + 16))) and (v199 == (1752 - (1326 + 424)))) then
								if (((2812 - 1327) <= (10611 - 7707)) and v94.Fireblood:IsCastable()) then
									if (((4387 - (88 + 30)) == (5040 - (720 + 51))) and v23(v94.Fireblood)) then
										return "fireblood main 12";
									end
								end
								if (((860 - 473) <= (4558 - (421 + 1355))) and v94.AncestralCall:IsCastable()) then
									if (v23(v94.AncestralCall) or ((3132 - 1233) <= (451 + 466))) then
										return "ancestral_call main 14";
									end
								end
								v199 = 1086 - (286 + 797);
							end
							if ((v199 == (10 - 7)) or ((7141 - 2829) <= (1315 - (397 + 42)))) then
								if (((698 + 1534) <= (3396 - (24 + 776))) and v94.BagofTricks:IsCastable()) then
									if (((3227 - 1132) < (4471 - (222 + 563))) and v23(v94.BagofTricks)) then
										return "ancestral_call main 16";
									end
								end
								break;
							end
							if ((v199 == (0 - 0)) or ((1149 + 446) >= (4664 - (23 + 167)))) then
								if (v94.BloodFury:IsCastable() or ((6417 - (690 + 1108)) < (1040 + 1842))) then
									if (v23(v94.BloodFury) or ((243 + 51) >= (5679 - (40 + 808)))) then
										return "blood_fury main 4";
									end
								end
								if (((335 + 1694) <= (11792 - 8708)) and v94.Berserking:IsCastable()) then
									if (v23(v94.Berserking) or ((1947 + 90) == (1281 + 1139))) then
										return "berserking main 6";
									end
								end
								v199 = 1 + 0;
							end
						end
					end
					local v195 = v93.HandleDPSPotion(v14:BuffUp(v94.AvatarBuff));
					if (((5029 - (47 + 524)) > (2534 + 1370)) and v195) then
						return v195;
					end
					if (((1191 - 755) >= (183 - 60)) and v94.IgnorePain:IsReady() and v64 and v103() and (v14:HealthPercentage() >= (45 - 25)) and (((v13:RageDeficit() <= (1741 - (1165 + 561))) and v94.ShieldSlam:CooldownUp()) or ((v13:RageDeficit() <= (2 + 38)) and v94.ShieldCharge:CooldownUp() and v94.ChampionsBulwark:IsAvailable()) or ((v13:RageDeficit() <= (61 - 41)) and v94.ShieldCharge:CooldownUp()) or ((v13:RageDeficit() <= (12 + 18)) and v94.DemoralizingShout:CooldownUp() and v94.BoomingVoice:IsAvailable()) or ((v13:RageDeficit() <= (499 - (341 + 138))) and v94.Avatar:CooldownUp()) or ((v13:RageDeficit() <= (13 + 32)) and v94.DemoralizingShout:CooldownUp() and v94.BoomingVoice:IsAvailable() and v13:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable()) or ((v13:RageDeficit() <= (61 - 31)) and v94.Avatar:CooldownUp() and v13:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable()) or (v13:RageDeficit() <= (346 - (89 + 237))) or ((v13:RageDeficit() <= (128 - 88)) and v94.ShieldSlam:CooldownUp() and v13:BuffUp(v94.ViolentOutburstBuff) and v94.HeavyRepercussions:IsAvailable() and v94.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (115 - 60)) and v94.ShieldSlam:CooldownUp() and v13:BuffUp(v94.ViolentOutburstBuff) and v13:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable() and v94.HeavyRepercussions:IsAvailable() and v94.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (898 - (581 + 300))) and v94.ShieldSlam:CooldownUp() and v94.HeavyRepercussions:IsAvailable()) or ((v13:RageDeficit() <= (1238 - (855 + 365))) and v94.ShieldSlam:CooldownUp() and v94.ImpenetrableWall:IsAvailable()))) then
						if (((1187 - 687) < (593 + 1223)) and v23(v94.IgnorePain, nil, nil, true)) then
							return "ignore_pain main 20";
						end
					end
					if (((4809 - (1030 + 205)) == (3356 + 218)) and v102() and v63 and v94.LastStand:IsCastable() and v13:BuffDown(v94.ShieldWallBuff) and (((v14:HealthPercentage() >= (84 + 6)) and v94.UnnervingFocus:IsAvailable()) or ((v14:HealthPercentage() <= (306 - (156 + 130))) and v94.UnnervingFocus:IsAvailable()) or v94.Bolster:IsAvailable() or v13:HasTier(68 - 38, 2 - 0))) then
						if (((452 - 231) < (103 + 287)) and v23(v94.LastStand)) then
							return "last_stand defensive";
						end
					end
					if (((v89 < v91) and v39 and ((v51 and v31) or not v51) and (v82 == "player") and v94.Ravager:IsCastable()) or ((1291 + 922) <= (1490 - (10 + 59)))) then
						local v200 = 0 + 0;
						while true do
							if (((15059 - 12001) < (6023 - (671 + 492))) and (v200 == (0 + 0))) then
								v106(1225 - (369 + 846));
								if (v23(v96.RavagerPlayer, not v98) or ((344 + 952) >= (3795 + 651))) then
									return "ravager main 24";
								end
								break;
							end
						end
					end
					if (((v89 < v91) and v39 and ((v51 and v31) or not v51) and (v82 == "cursor") and v94.Ravager:IsCastable()) or ((3338 - (1036 + 909)) > (3570 + 919))) then
						local v201 = 0 - 0;
						while true do
							if ((v201 == (203 - (11 + 192))) or ((2236 + 2188) < (202 - (135 + 40)))) then
								v106(24 - 14);
								if (v23(v96.RavagerCursor, not v98) or ((1204 + 793) > (8404 - 4589))) then
									return "ravager main 24";
								end
								break;
							end
						end
					end
					if (((5194 - 1729) > (2089 - (50 + 126))) and v94.DemoralizingShout:IsCastable() and v35 and v94.BoomingVoice:IsAvailable()) then
						local v202 = 0 - 0;
						while true do
							if (((163 + 570) < (3232 - (1233 + 180))) and (v202 == (969 - (522 + 447)))) then
								v106(1451 - (107 + 1314));
								if (v23(v94.DemoralizingShout, not v98) or ((2040 + 2355) == (14489 - 9734))) then
									return "demoralizing_shout main 28";
								end
								break;
							end
						end
					end
					if (((v89 < v91) and v44 and ((v53 and v31) or not v53) and (v83 == "player") and v94.ChampionsSpear:IsCastable()) or ((1611 + 2182) < (4704 - 2335))) then
						local v203 = 0 - 0;
						while true do
							if ((v203 == (1910 - (716 + 1194))) or ((70 + 4014) == (29 + 236))) then
								v106(523 - (74 + 429));
								if (((8406 - 4048) == (2160 + 2198)) and v23(v96.ChampionsSpearPlayer, not v98)) then
									return "spear_of_bastion main 28";
								end
								break;
							end
						end
					end
					if (((v89 < v91) and v44 and ((v53 and v31) or not v53) and (v83 == "cursor") and v94.ChampionsSpear:IsCastable()) or ((7183 - 4045) < (703 + 290))) then
						local v204 = 0 - 0;
						while true do
							if (((8233 - 4903) > (2756 - (279 + 154))) and (v204 == (778 - (454 + 324)))) then
								v106(16 + 4);
								if (v23(v96.ChampionsSpearCursor, not v98) or ((3643 - (12 + 5)) == (2151 + 1838))) then
									return "spear_of_bastion main 28";
								end
								break;
							end
						end
					end
					if (((v89 < v91) and v46 and ((v54 and v31) or not v54) and v94.ThunderousRoar:IsCastable()) or ((2333 - 1417) == (988 + 1683))) then
						if (((1365 - (277 + 816)) == (1162 - 890)) and v23(v94.ThunderousRoar, not v14:IsInMeleeRange(1191 - (1058 + 125)))) then
							return "thunderous_roar main 30";
						end
					end
					if (((797 + 3452) <= (5814 - (815 + 160))) and v94.ShieldSlam:IsCastable() and v42 and v13:BuffUp(v94.FervidBuff)) then
						if (((11915 - 9138) < (7596 - 4396)) and v23(v94.ShieldSlam, not v98)) then
							return "shield_slam main 31";
						end
					end
					if (((23 + 72) < (5720 - 3763)) and ((v94.Shockwave:IsCastable() and v43 and v13:BuffUp(v94.AvatarBuff) and v94.UnstoppableForce:IsAvailable() and not v94.RumblingEarth:IsAvailable()) or (v94.SonicBoom:IsAvailable() and v94.RumblingEarth:IsAvailable() and (v100 >= (1901 - (41 + 1857))) and v14:IsCasting()))) then
						local v205 = 1893 - (1222 + 671);
						while true do
							if (((2134 - 1308) < (2467 - 750)) and (v205 == (1182 - (229 + 953)))) then
								v106(1784 - (1111 + 663));
								if (((3005 - (874 + 705)) >= (155 + 950)) and v23(v94.Shockwave, not v14:IsInMeleeRange(6 + 2))) then
									return "shockwave main 32";
								end
								break;
							end
						end
					end
					if (((5724 - 2970) <= (96 + 3283)) and (v89 < v91) and v94.ShieldCharge:IsCastable() and v41 and ((v52 and v31) or not v52)) then
						if (v23(v94.ShieldCharge, not v14:IsSpellInRange(v94.ShieldCharge)) or ((4606 - (642 + 37)) == (323 + 1090))) then
							return "shield_charge main 34";
						end
					end
					if ((v105() and v62) or ((185 + 969) <= (1978 - 1190))) then
						if (v23(v94.ShieldBlock) or ((2097 - (233 + 221)) > (7813 - 4434))) then
							return "shield_block main 38";
						end
					end
					if ((v100 > (3 + 0)) or ((4344 - (718 + 823)) > (2863 + 1686))) then
						local v206 = 805 - (266 + 539);
						while true do
							if ((v206 == (2 - 1)) or ((1445 - (636 + 589)) >= (7173 - 4151))) then
								if (((5820 - 2998) == (2237 + 585)) and v19.CastAnnotated(v94.Pool, false, "WAIT")) then
									return "Pool for Aoe()";
								end
								break;
							end
							if ((v206 == (0 + 0)) or ((2076 - (657 + 358)) == (4916 - 3059))) then
								v28 = v110();
								if (((6288 - 3528) > (2551 - (1151 + 36))) and v28) then
									return v28;
								end
								v206 = 1 + 0;
							end
						end
					end
					v28 = v111();
					if (v28 or ((1289 + 3613) <= (10736 - 7141))) then
						return v28;
					end
					if (v19.CastAnnotated(v94.Pool, false, "WAIT") or ((5684 - (1552 + 280)) == (1127 - (64 + 770)))) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
		end
	end
	local function v114()
		local v132 = 0 + 0;
		while true do
			if ((v132 == (6 - 3)) or ((277 + 1282) == (5831 - (157 + 1086)))) then
				v39 = EpicSettings.Settings['useRavager'];
				v41 = EpicSettings.Settings['useShieldCharge'];
				v44 = EpicSettings.Settings['useChampionsSpear'];
				v46 = EpicSettings.Settings['useThunderousRoar'];
				v132 = 7 - 3;
			end
			if ((v132 == (4 - 3)) or ((6878 - 2394) == (1075 - 287))) then
				v37 = EpicSettings.Settings['useExecute'];
				v38 = EpicSettings.Settings['useHeroicThrow'];
				v40 = EpicSettings.Settings['useRevenge'];
				v42 = EpicSettings.Settings['useShieldSlam'];
				v132 = 821 - (599 + 220);
			end
			if (((9096 - 4528) >= (5838 - (1813 + 118))) and (v132 == (2 + 0))) then
				v43 = EpicSettings.Settings['useShockwave'];
				v45 = EpicSettings.Settings['useThunderClap'];
				v47 = EpicSettings.Settings['useWreckingThrow'];
				v32 = EpicSettings.Settings['useAvatar'];
				v132 = 1220 - (841 + 376);
			end
			if (((1745 - 499) < (807 + 2663)) and (v132 == (13 - 8))) then
				v54 = EpicSettings.Settings['thunderousRoarWithCD'];
				break;
			end
			if (((4927 - (464 + 395)) >= (2494 - 1522)) and (v132 == (0 + 0))) then
				v33 = EpicSettings.Settings['useBattleShout'];
				v34 = EpicSettings.Settings['useCharge'];
				v35 = EpicSettings.Settings['useDemoralizingShout'];
				v36 = EpicSettings.Settings['useDevastate'];
				v132 = 838 - (467 + 370);
			end
			if (((1018 - 525) < (2858 + 1035)) and (v132 == (13 - 9))) then
				v50 = EpicSettings.Settings['avatarWithCD'];
				v51 = EpicSettings.Settings['ravagerWithCD'];
				v52 = EpicSettings.Settings['shieldChargeWithCD'];
				v53 = EpicSettings.Settings['championsSpearWithCD'];
				v132 = 1 + 4;
			end
		end
	end
	local function v115()
		local v133 = 0 - 0;
		while true do
			if ((v133 == (521 - (150 + 370))) or ((2755 - (74 + 1208)) >= (8194 - 4862))) then
				v64 = EpicSettings.Settings['useIgnorePain'];
				v66 = EpicSettings.Settings['useIntervene'];
				v63 = EpicSettings.Settings['useLastStand'];
				v65 = EpicSettings.Settings['useRallyingCry'];
				v133 = 9 - 7;
			end
			if ((v133 == (4 + 1)) or ((4441 - (14 + 376)) <= (2006 - 849))) then
				v81 = EpicSettings.Settings['victoryRushHP'] or (0 + 0);
				v78 = EpicSettings.Settings['defensiveStanceHP'] or (0 + 0);
				v82 = EpicSettings.Settings['ravagerSetting'] or "";
				v83 = EpicSettings.Settings['spearSetting'] or "";
				break;
			end
			if (((577 + 27) < (8441 - 5560)) and (v133 == (0 + 0))) then
				v57 = EpicSettings.Settings['usePummel'];
				v58 = EpicSettings.Settings['useStormBolt'];
				v59 = EpicSettings.Settings['useIntimidatingShout'];
				v60 = EpicSettings.Settings['useBitterImmunity'];
				v133 = 79 - (23 + 55);
			end
			if ((v133 == (9 - 5)) or ((601 + 299) == (3033 + 344))) then
				v76 = EpicSettings.Settings['rallyingCryGroup'] or (0 - 0);
				v75 = EpicSettings.Settings['rallyingCryHP'] or (0 + 0);
				v72 = EpicSettings.Settings['shieldBlockHP'] or (901 - (652 + 249));
				v71 = EpicSettings.Settings['shieldWallHP'] or (0 - 0);
				v133 = 1873 - (708 + 1160);
			end
			if (((12103 - 7644) > (1077 - 486)) and ((30 - (10 + 17)) == v133)) then
				v70 = EpicSettings.Settings['bitterImmunityHP'] or (0 + 0);
				v74 = EpicSettings.Settings['ignorePainHP'] or (1732 - (1400 + 332));
				v77 = EpicSettings.Settings['interveneHP'] or (0 - 0);
				v73 = EpicSettings.Settings['lastStandHP'] or (1908 - (242 + 1666));
				v133 = 2 + 2;
			end
			if (((1246 + 2152) >= (2042 + 353)) and (v133 == (942 - (850 + 90)))) then
				v62 = EpicSettings.Settings['useShieldBlock'];
				v61 = EpicSettings.Settings['useShieldWall'];
				v69 = EpicSettings.Settings['useVictoryRush'];
				v92 = EpicSettings.Settings['useChangeStance'];
				v133 = 4 - 1;
			end
		end
	end
	local function v116()
		v89 = EpicSettings.Settings['fightRemainsCheck'] or (1390 - (360 + 1030));
		v86 = EpicSettings.Settings['InterruptWithStun'];
		v87 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v88 = EpicSettings.Settings['InterruptThreshold'];
		v48 = EpicSettings.Settings['useTrinkets'];
		v49 = EpicSettings.Settings['useRacials'];
		v55 = EpicSettings.Settings['trinketsWithCD'];
		v56 = EpicSettings.Settings['racialsWithCD'];
		v67 = EpicSettings.Settings['useHealthstone'];
		v68 = EpicSettings.Settings['useHealingPotion'];
		v79 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v80 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v85 = EpicSettings.Settings['HealingPotionName'] or "";
		v84 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v117()
		local v144 = 0 - 0;
		while true do
			if ((v144 == (1663 - (909 + 752))) or ((3406 - (109 + 1114)) >= (5169 - 2345))) then
				if (((754 + 1182) == (2178 - (6 + 236))) and v13:IsDeadOrGhost()) then
					return v28;
				end
				if (v30 or ((3045 + 1787) < (3472 + 841))) then
					local v196 = 0 - 0;
					while true do
						if (((7140 - 3052) > (5007 - (1076 + 57))) and ((0 + 0) == v196)) then
							v99 = v13:GetEnemiesInMeleeRange(697 - (579 + 110));
							v100 = #v99;
							break;
						end
					end
				else
					v100 = 1 + 0;
				end
				v98 = v14:IsInMeleeRange(8 + 0);
				v144 = 2 + 1;
			end
			if (((4739 - (174 + 233)) == (12100 - 7768)) and (v144 == (1 - 0))) then
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v144 = 1 + 1;
			end
			if (((5173 - (663 + 511)) >= (2588 + 312)) and ((0 + 0) == v144)) then
				v115();
				v114();
				v116();
				v144 = 2 - 1;
			end
			if ((v144 == (2 + 1)) or ((5944 - 3419) > (9837 - 5773))) then
				if (((2086 + 2285) == (8507 - 4136)) and (v93.TargetIsValid() or v13:AffectingCombat())) then
					local v197 = 0 + 0;
					while true do
						if (((0 + 0) == v197) or ((988 - (478 + 244)) > (5503 - (440 + 77)))) then
							v90 = v10.BossFightRemains(nil, true);
							v91 = v90;
							v197 = 1 + 0;
						end
						if (((7287 - 5296) >= (2481 - (655 + 901))) and ((1 + 0) == v197)) then
							if (((349 + 106) < (1387 + 666)) and (v91 == (44762 - 33651))) then
								v91 = v10.FightRemains(v99, false);
							end
							break;
						end
					end
				end
				if (not v13:IsChanneling() or ((2271 - (695 + 750)) == (16564 - 11713))) then
					if (((281 - 98) == (735 - 552)) and v13:AffectingCombat()) then
						local v207 = 351 - (285 + 66);
						while true do
							if (((2701 - 1542) <= (3098 - (682 + 628))) and (v207 == (0 + 0))) then
								v28 = v113();
								if (v28 or ((3806 - (176 + 123)) > (1807 + 2511))) then
									return v28;
								end
								break;
							end
						end
					else
						local v208 = 0 + 0;
						while true do
							if (((269 - (239 + 30)) == v208) or ((836 + 2239) <= (2850 + 115))) then
								v28 = v112();
								if (((2415 - 1050) <= (6273 - 4262)) and v28) then
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
	local function v118()
		v19.Print("Protection Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(388 - (306 + 9), v117, v118);
end;
return v0["Epix_Warrior_Protection.lua"]();

