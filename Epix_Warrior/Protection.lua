local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((1120 + 3422) == (1625 + 2917)) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((1942 + 728) < (812 + 927))) then
			v6 = v0[v4];
			if (not v6 or ((1765 - (797 + 636)) >= (19435 - 15432))) then
				return v1(v4, ...);
			end
			v5 = 1620 - (1427 + 192);
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
	local v90;
	local v91 = 3850 + 7261;
	local v92 = 25797 - 14686;
	local v93;
	local v94 = v19.Commons.Everyone;
	local v95 = v17.Warrior.Protection;
	local v96 = v18.Warrior.Protection;
	local v97 = v22.Warrior.Protection;
	local v98 = {};
	local v99;
	local v100;
	local v101;
	local function v102()
		local v120 = 0 + 0;
		local v121;
		while true do
			if ((v120 == (0 + 0)) or ((3617 - (192 + 134)) <= (4556 - (316 + 960)))) then
				v121 = UnitGetTotalAbsorbs(v14:ID());
				if (((2441 + 1945) >= (674 + 199)) and (v121 > (0 + 0))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v103()
		return v13:IsTankingAoE(60 - 44) or v13:IsTanking(v14) or v14:IsDummy();
	end
	local function v104()
		if (((1472 - (83 + 468)) <= (2908 - (1202 + 604))) and v13:BuffUp(v95.IgnorePain)) then
			local v157 = v13:AttackPowerDamageMod() * (18.375 - 14) * ((1 - 0) + (v13:VersatilityDmgPct() / (276 - 176)));
			local v158 = v13:AuraInfo(v95.IgnorePain, nil, true);
			local v159 = v158.points[326 - (45 + 280)];
			return (v159 + v157) < (v13:MaxHealth() * (0.3 + 0));
		else
			return true;
		end
	end
	local function v105()
		if (((4112 + 594) >= (352 + 611)) and v13:BuffUp(v95.IgnorePain)) then
			local v160 = 0 + 0;
			local v161;
			while true do
				if ((v160 == (0 + 0)) or ((1777 - 817) <= (2787 - (340 + 1571)))) then
					v161 = v13:BuffInfo(v95.IgnorePain, nil, true);
					return v161.points[1 + 0];
				end
			end
		else
			return 1772 - (1733 + 39);
		end
	end
	local function v106()
		return v103() and v95.ShieldBlock:IsReady() and (v13:BuffRemains(v95.ShieldBlockBuff) <= (27 - 17));
	end
	local function v107(v122)
		local v123 = 1034 - (125 + 909);
		local v124;
		local v125;
		local v126;
		while true do
			if ((v123 == (1949 - (1096 + 852))) or ((927 + 1139) == (1330 - 398))) then
				v125 = false;
				v126 = (v13:Rage() >= (34 + 1)) and not v106();
				v123 = 514 - (409 + 103);
			end
			if (((5061 - (46 + 190)) < (4938 - (51 + 44))) and (v123 == (1 + 1))) then
				if ((v126 and (((v13:Rage() + v122) >= v124) or v95.DemoralizingShout:IsReady())) or ((5194 - (1114 + 203)) >= (5263 - (228 + 498)))) then
					v125 = true;
				end
				if (v125 or ((935 + 3380) < (954 + 772))) then
					if ((v103() and v104()) or ((4342 - (174 + 489)) < (1628 - 1003))) then
						if (v23(v95.IgnorePain, nil, nil, true) or ((6530 - (830 + 1075)) < (1156 - (303 + 221)))) then
							return "ignore_pain rage capped";
						end
					elseif (v23(v95.Revenge, not v99) or ((1352 - (231 + 1038)) > (1484 + 296))) then
						return "revenge rage capped";
					end
				end
				break;
			end
			if (((1708 - (171 + 991)) <= (4438 - 3361)) and (v123 == (0 - 0))) then
				v124 = 199 - 119;
				if ((v124 < (29 + 6)) or (v13:Rage() < (122 - 87)) or ((2873 - 1877) > (6932 - 2631))) then
					return false;
				end
				v123 = 3 - 2;
			end
		end
	end
	local function v108()
		local v127 = 1248 - (111 + 1137);
		while true do
			if (((4228 - (91 + 67)) > (2044 - 1357)) and ((1 + 1) == v127)) then
				if ((v95.Intervene:IsReady() and v67 and (v16:HealthPercentage() <= v78) and (v16:Name() ~= v13:Name())) or ((1179 - (423 + 100)) >= (24 + 3306))) then
					if (v23(v97.InterveneFocus) or ((6899 - 4407) <= (175 + 160))) then
						return "intervene defensive";
					end
				end
				if (((5093 - (326 + 445)) >= (11180 - 8618)) and v95.ShieldWall:IsCastable() and v62 and v13:BuffDown(v95.ShieldWallBuff) and ((v13:HealthPercentage() <= v72) or v13:ActiveMitigationNeeded())) then
					if (v23(v95.ShieldWall) or ((8102 - 4465) >= (8800 - 5030))) then
						return "shield_wall defensive";
					end
				end
				v127 = 714 - (530 + 181);
			end
			if ((v127 == (884 - (614 + 267))) or ((2411 - (19 + 13)) > (7450 - 2872))) then
				if ((v96.Healthstone:IsReady() and v68 and (v13:HealthPercentage() <= v80)) or ((1124 - 641) > (2122 - 1379))) then
					if (((638 + 1816) > (1016 - 438)) and v23(v97.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if (((1928 - 998) < (6270 - (1293 + 519))) and v69 and (v13:HealthPercentage() <= v81)) then
					local v190 = 0 - 0;
					while true do
						if (((1728 - 1066) <= (1858 - 886)) and (v190 == (0 - 0))) then
							if (((10294 - 5924) == (2315 + 2055)) and (v86 == "Refreshing Healing Potion")) then
								if (v96.RefreshingHealingPotion:IsReady() or ((972 + 3790) <= (2000 - 1139))) then
									if (v23(v97.RefreshingHealingPotion) or ((327 + 1085) == (1417 + 2847))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v86 == "Dreamwalker's Healing Potion") or ((1980 + 1188) < (3249 - (709 + 387)))) then
								if (v96.DreamwalkersHealingPotion:IsReady() or ((6834 - (673 + 1185)) < (3862 - 2530))) then
									if (((14861 - 10233) == (7614 - 2986)) and v23(v97.RefreshingHealingPotion)) then
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
			if ((v127 == (0 + 0)) or ((41 + 13) == (532 - 137))) then
				if (((21 + 61) == (162 - 80)) and v95.BitterImmunity:IsReady() and v61 and (v13:HealthPercentage() <= v71)) then
					if (v23(v95.BitterImmunity) or ((1140 - 559) < (2162 - (446 + 1434)))) then
						return "bitter_immunity defensive";
					end
				end
				if ((v95.LastStand:IsCastable() and v64 and ((v13:HealthPercentage() <= v74) or v13:ActiveMitigationNeeded())) or ((5892 - (1040 + 243)) < (7446 - 4951))) then
					if (((2999 - (559 + 1288)) == (3083 - (609 + 1322))) and v23(v95.LastStand)) then
						return "last_stand defensive";
					end
				end
				v127 = 455 - (13 + 441);
			end
			if (((7084 - 5188) <= (8963 - 5541)) and (v127 == (4 - 3))) then
				if ((v95.IgnorePain:IsReady() and v65 and (v13:HealthPercentage() <= v75) and v104()) or ((37 + 953) > (5883 - 4263))) then
					if (v23(v95.IgnorePain, nil, nil, true) or ((312 + 565) > (2058 + 2637))) then
						return "ignore_pain defensive";
					end
				end
				if (((7985 - 5294) >= (1013 + 838)) and v95.RallyingCry:IsReady() and v66 and v13:BuffDown(v95.AspectsFavorBuff) and v13:BuffDown(v95.RallyingCry) and (((v13:HealthPercentage() <= v76) and v94.IsSoloMode()) or v94.AreUnitsBelowHealthPercentage(v76, v77, v95.Intervene))) then
					if (v23(v95.RallyingCry) or ((5489 - 2504) >= (3211 + 1645))) then
						return "rallying_cry defensive";
					end
				end
				v127 = 2 + 0;
			end
		end
	end
	local function v109()
		v28 = v94.HandleTopTrinket(v98, v31, 29 + 11, nil);
		if (((3591 + 685) >= (1170 + 25)) and v28) then
			return v28;
		end
		v28 = v94.HandleBottomTrinket(v98, v31, 473 - (153 + 280), nil);
		if (((9332 - 6100) <= (4211 + 479)) and v28) then
			return v28;
		end
	end
	local function v110()
		if (v14:IsInMeleeRange(4 + 4) or ((469 + 427) >= (2855 + 291))) then
			if (((2219 + 842) >= (4504 - 1546)) and v95.ThunderClap:IsCastable() and v46) then
				if (((1970 + 1217) >= (1311 - (89 + 578))) and v23(v95.ThunderClap)) then
					return "thunder_clap precombat";
				end
			end
		elseif (((461 + 183) <= (1463 - 759)) and v35 and v95.Charge:IsCastable() and not v14:IsInRange(1057 - (572 + 477))) then
			if (((130 + 828) > (569 + 378)) and v23(v95.Charge, not v14:IsSpellInRange(v95.Charge))) then
				return "charge precombat";
			end
		end
	end
	local function v111()
		local v128 = 0 + 0;
		while true do
			if (((4578 - (84 + 2)) >= (4373 - 1719)) and (v128 == (3 + 0))) then
				if (((4284 - (497 + 345)) >= (39 + 1464)) and v95.Revenge:IsReady() and v41 and ((v13:Rage() >= (6 + 24)) or ((v13:Rage() >= (1373 - (605 + 728))) and v95.BarbaricTraining:IsAvailable()))) then
					if (v23(v95.Revenge, not v99) or ((2262 + 908) <= (3254 - 1790))) then
						return "revenge aoe 12";
					end
				end
				break;
			end
			if ((v128 == (1 + 0)) or ((17735 - 12938) == (3956 + 432))) then
				if (((1526 - 975) <= (515 + 166)) and v95.ThunderClap:IsCastable() and v46 and v13:BuffUp(v95.ViolentOutburstBuff) and (v101 > (494 - (457 + 32))) and v13:BuffUp(v95.AvatarBuff) and v95.UnstoppableForce:IsAvailable()) then
					local v191 = 0 + 0;
					while true do
						if (((4679 - (832 + 570)) > (384 + 23)) and (v191 == (0 + 0))) then
							v107(17 - 12);
							if (((2262 + 2433) >= (2211 - (588 + 208))) and v23(v95.ThunderClap, not v14:IsInMeleeRange(21 - 13))) then
								return "thunder_clap aoe 4";
							end
							break;
						end
					end
				end
				if ((v95.Revenge:IsReady() and v41 and (v13:Rage() >= (1870 - (884 + 916))) and v95.SeismicReverberation:IsAvailable() and (v101 >= (6 - 3))) or ((1863 + 1349) <= (1597 - (232 + 421)))) then
					if (v23(v95.Revenge, not v99) or ((4985 - (1569 + 320)) <= (442 + 1356))) then
						return "revenge aoe 6";
					end
				end
				v128 = 1 + 1;
			end
			if (((11918 - 8381) == (4142 - (316 + 289))) and (v128 == (0 - 0))) then
				if (((178 + 3659) >= (3023 - (666 + 787))) and v95.ThunderClap:IsCastable() and v46 and (v14:DebuffRemains(v95.RendDebuff) <= (426 - (360 + 65)))) then
					local v192 = 0 + 0;
					while true do
						if ((v192 == (254 - (79 + 175))) or ((4651 - 1701) == (2975 + 837))) then
							v107(15 - 10);
							if (((9095 - 4372) >= (3217 - (503 + 396))) and v23(v95.ThunderClap, not v14:IsInMeleeRange(189 - (92 + 89)))) then
								return "thunder_clap aoe 2";
							end
							break;
						end
					end
				end
				if ((v95.ShieldSlam:IsCastable() and v43 and ((v13:HasTier(58 - 28, 2 + 0) and (v101 <= (5 + 2))) or v13:BuffUp(v95.EarthenTenacityBuff))) or ((7937 - 5910) > (391 + 2461))) then
					if (v23(v95.ShieldSlam, not v99) or ((2590 - 1454) > (3767 + 550))) then
						return "shield_slam aoe 3";
					end
				end
				v128 = 1 + 0;
			end
			if (((14460 - 9712) == (593 + 4155)) and (v128 == (2 - 0))) then
				if (((4980 - (485 + 759)) <= (10967 - 6227)) and v95.ShieldSlam:IsCastable() and v43 and ((v13:Rage() <= (1249 - (442 + 747))) or (v13:BuffUp(v95.ViolentOutburstBuff) and (v101 <= (1142 - (832 + 303)))))) then
					local v193 = 946 - (88 + 858);
					while true do
						if ((v193 == (0 + 0)) or ((2806 + 584) <= (127 + 2933))) then
							v107(809 - (766 + 23));
							if (v23(v95.ShieldSlam, not v99) or ((4931 - 3932) > (3682 - 989))) then
								return "shield_slam aoe 8";
							end
							break;
						end
					end
				end
				if (((1219 - 756) < (2039 - 1438)) and v95.ThunderClap:IsCastable() and v46) then
					v107(1078 - (1036 + 37));
					if (v23(v95.ThunderClap, not v14:IsInMeleeRange(6 + 2)) or ((4250 - 2067) < (541 + 146))) then
						return "thunder_clap aoe 10";
					end
				end
				v128 = 1483 - (641 + 839);
			end
		end
	end
	local function v112()
		if (((5462 - (910 + 3)) == (11596 - 7047)) and v95.ShieldSlam:IsCastable() and v43) then
			v107(1704 - (1466 + 218));
			if (((2148 + 2524) == (5820 - (556 + 592))) and v23(v95.ShieldSlam, not v99)) then
				return "shield_slam generic 2";
			end
		end
		if ((v95.ThunderClap:IsCastable() and v46 and (v14:DebuffRemains(v95.RendDebuff) <= (1 + 1)) and v13:BuffDown(v95.ViolentOutburstBuff)) or ((4476 - (329 + 479)) < (1249 - (174 + 680)))) then
			local v162 = 0 - 0;
			while true do
				if ((v162 == (0 - 0)) or ((2975 + 1191) == (1194 - (396 + 343)))) then
					v107(1 + 4);
					if (v23(v95.ThunderClap, not v14:IsInMeleeRange(1485 - (29 + 1448))) or ((5838 - (135 + 1254)) == (10032 - 7369))) then
						return "thunder_clap generic 4";
					end
					break;
				end
			end
		end
		if ((v95.Execute:IsReady() and v38 and v13:BuffUp(v95.SuddenDeathBuff) and v95.SuddenDeath:IsAvailable()) or ((19969 - 15692) < (1992 + 997))) then
			if (v23(v95.Execute, not v99) or ((2397 - (389 + 1138)) >= (4723 - (102 + 472)))) then
				return "execute generic 6";
			end
		end
		if (((2088 + 124) < (1766 + 1417)) and v95.Execute:IsReady() and v38) then
			if (((4333 + 313) > (4537 - (320 + 1225))) and v23(v95.Execute, not v99)) then
				return "execute generic 8";
			end
		end
		if (((2552 - 1118) < (1901 + 1205)) and v95.ThunderClap:IsCastable() and v46 and ((v101 > (1465 - (157 + 1307))) or (v95.ShieldSlam:CooldownDown() and not v13:BuffUp(v95.ViolentOutburstBuff)))) then
			local v163 = 1859 - (821 + 1038);
			while true do
				if (((1960 - 1174) < (331 + 2692)) and ((0 - 0) == v163)) then
					v107(2 + 3);
					if (v23(v95.ThunderClap, not v14:IsInMeleeRange(19 - 11)) or ((3468 - (834 + 192)) < (5 + 69))) then
						return "thunder_clap generic 12";
					end
					break;
				end
			end
		end
		if (((1165 + 3370) == (98 + 4437)) and v95.Revenge:IsReady() and v41 and (((v13:Rage() >= (123 - 43)) and (v14:HealthPercentage() > (324 - (300 + 4)))) or (v13:BuffUp(v95.RevengeBuff) and (v14:HealthPercentage() <= (6 + 14)) and (v13:Rage() <= (47 - 29)) and v95.ShieldSlam:CooldownDown()) or (v13:BuffUp(v95.RevengeBuff) and (v14:HealthPercentage() > (382 - (112 + 250)))) or ((((v13:Rage() >= (32 + 48)) and (v14:HealthPercentage() > (87 - 52))) or (v13:BuffUp(v95.RevengeBuff) and (v14:HealthPercentage() <= (21 + 14)) and (v13:Rage() <= (10 + 8)) and v95.ShieldSlam:CooldownDown()) or (v13:BuffUp(v95.RevengeBuff) and (v14:HealthPercentage() > (27 + 8)))) and v95.Massacre:IsAvailable()))) then
			if (v23(v95.Revenge, not v99) or ((1492 + 1517) <= (1564 + 541))) then
				return "revenge generic 14";
			end
		end
		if (((3244 - (1001 + 413)) < (8181 - 4512)) and v95.Execute:IsReady() and v38 and (v101 == (883 - (244 + 638)))) then
			if (v23(v95.Execute, not v99) or ((2123 - (627 + 66)) >= (10762 - 7150))) then
				return "execute generic 16";
			end
		end
		if (((3285 - (512 + 90)) >= (4366 - (1665 + 241))) and v95.Revenge:IsReady() and v41 and (v14:HealthPercentage() > (737 - (373 + 344)))) then
			if (v23(v95.Revenge, not v99) or ((814 + 990) >= (867 + 2408))) then
				return "revenge generic 18";
			end
		end
		if ((v95.ThunderClap:IsCastable() and v46 and ((v101 >= (2 - 1)) or (v95.ShieldSlam:CooldownDown() and v13:BuffUp(v95.ViolentOutburstBuff)))) or ((2397 - 980) > (4728 - (35 + 1064)))) then
			local v164 = 0 + 0;
			while true do
				if (((10259 - 5464) > (2 + 400)) and (v164 == (1236 - (298 + 938)))) then
					v107(1264 - (233 + 1026));
					if (((6479 - (636 + 1030)) > (1823 + 1742)) and v23(v95.ThunderClap, not v14:IsInMeleeRange(8 + 0))) then
						return "thunder_clap generic 20";
					end
					break;
				end
			end
		end
		if (((1163 + 2749) == (265 + 3647)) and v95.Devastate:IsCastable() and v37) then
			if (((3042 - (55 + 166)) <= (935 + 3889)) and v23(v95.Devastate, not v99)) then
				return "devastate generic 22";
			end
		end
	end
	local function v113()
		local v129 = 0 + 0;
		while true do
			if (((6637 - 4899) <= (2492 - (36 + 261))) and (v129 == (0 - 0))) then
				if (((1409 - (34 + 1334)) <= (1161 + 1857)) and not v13:AffectingCombat()) then
					local v194 = 0 + 0;
					while true do
						if (((3428 - (1035 + 248)) <= (4125 - (20 + 1))) and (v194 == (0 + 0))) then
							if (((3008 - (134 + 185)) < (5978 - (549 + 584))) and v95.BattleShout:IsCastable() and v34 and (v13:BuffDown(v95.BattleShoutBuff, true) or v94.GroupBuffMissing(v95.BattleShoutBuff))) then
								if (v23(v95.BattleShout) or ((3007 - (314 + 371)) > (9001 - 6379))) then
									return "battle_shout precombat";
								end
							end
							if ((v93 and v95.BattleStance:IsCastable() and not v13:BuffUp(v95.BattleStance)) or ((5502 - (478 + 490)) == (1103 + 979))) then
								if (v23(v95.BattleStance) or ((2743 - (786 + 386)) > (6047 - 4180))) then
									return "battle_stance precombat";
								end
							end
							break;
						end
					end
				end
				if ((v94.TargetIsValid() and v29) or ((4033 - (1055 + 324)) >= (4336 - (1093 + 247)))) then
					if (((3535 + 443) > (222 + 1882)) and not v13:AffectingCombat()) then
						v28 = v110();
						if (((11890 - 8895) > (5229 - 3688)) and v28) then
							return v28;
						end
					end
				end
				break;
			end
		end
	end
	local function v114()
		local v130 = 0 - 0;
		while true do
			if (((8164 - 4915) > (340 + 613)) and (v130 == (0 - 0))) then
				v28 = v108();
				if (v28 or ((11281 - 8008) > (3449 + 1124))) then
					return v28;
				end
				v130 = 2 - 1;
			end
			if (((689 - (364 + 324)) == v130) or ((8637 - 5486) < (3081 - 1797))) then
				if (v85 or ((614 + 1236) == (6397 - 4868))) then
					v28 = v94.HandleIncorporeal(v95.StormBolt, v97.StormBoltMouseover, 32 - 12, true);
					if (((2493 - 1672) < (3391 - (1249 + 19))) and v28) then
						return v28;
					end
					v28 = v94.HandleIncorporeal(v95.IntimidatingShout, v97.IntimidatingShoutMouseover, 8 + 0, true);
					if (((3510 - 2608) < (3411 - (686 + 400))) and v28) then
						return v28;
					end
				end
				if (((674 + 184) <= (3191 - (73 + 156))) and v94.TargetIsValid()) then
					local v195 = 0 + 0;
					local v196;
					while true do
						if ((v195 == (819 - (721 + 90))) or ((45 + 3901) < (4181 - 2893))) then
							v28 = v112();
							if (v28 or ((3712 - (224 + 246)) == (918 - 351))) then
								return v28;
							end
							if (v19.CastAnnotated(v95.Pool, false, "WAIT") or ((1559 - 712) >= (230 + 1033))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((v195 == (1 + 0)) or ((1655 + 598) == (3679 - 1828))) then
							if ((v35 and v95.Charge:IsCastable() and not v99) or ((6944 - 4857) > (2885 - (203 + 310)))) then
								if (v23(v95.Charge, not v14:IsSpellInRange(v95.Charge)) or ((6438 - (1238 + 755)) < (290 + 3859))) then
									return "charge main 34";
								end
							end
							if ((v90 < v92) or ((3352 - (709 + 825)) == (156 - 71))) then
								local v201 = 0 - 0;
								while true do
									if (((1494 - (196 + 668)) < (8397 - 6270)) and (v201 == (0 - 0))) then
										if ((v49 and ((v31 and v56) or not v56)) or ((2771 - (171 + 662)) == (2607 - (4 + 89)))) then
											local v206 = 0 - 0;
											while true do
												if (((1550 + 2705) >= (241 - 186)) and (v206 == (0 + 0))) then
													v28 = v109();
													if (((4485 - (35 + 1451)) > (2609 - (28 + 1425))) and v28) then
														return v28;
													end
													break;
												end
											end
										end
										if (((4343 - (941 + 1052)) > (1108 + 47)) and v31 and v96.FyralathTheDreamrender:IsEquippedAndReady() and v32) then
											if (((5543 - (822 + 692)) <= (6927 - 2074)) and v23(v97.UseWeapon)) then
												return "Fyralath The Dreamrender used";
											end
										end
										break;
									end
								end
							end
							if ((v39 and v95.HeroicThrow:IsCastable() and not v14:IsInRange(12 + 13)) or ((813 - (45 + 252)) > (3398 + 36))) then
								if (((1393 + 2653) >= (7381 - 4348)) and v23(v95.HeroicThrow, not v14:IsSpellInRange(v95.HeroicThrow))) then
									return "heroic_throw main";
								end
							end
							v195 = 435 - (114 + 319);
						end
						if ((v195 == (0 - 0)) or ((3483 - 764) <= (923 + 524))) then
							if ((v93 and (v13:HealthPercentage() <= v79)) or ((6158 - 2024) < (8225 - 4299))) then
								if ((v95.DefensiveStance:IsCastable() and not v13:BuffUp(v95.DefensiveStance)) or ((2127 - (556 + 1407)) >= (3991 - (741 + 465)))) then
									if (v23(v95.DefensiveStance) or ((990 - (170 + 295)) == (1112 + 997))) then
										return "defensive_stance while tanking";
									end
								end
							end
							if (((31 + 2) == (80 - 47)) and v93 and (v13:HealthPercentage() > v79)) then
								if (((2532 + 522) <= (2575 + 1440)) and v95.BattleStance:IsCastable() and not v13:BuffUp(v95.BattleStance)) then
									if (((1060 + 811) < (4612 - (957 + 273))) and v23(v95.BattleStance)) then
										return "battle_stance while not tanking";
									end
								end
							end
							if (((346 + 947) <= (868 + 1298)) and v42 and ((v53 and v31) or not v53) and (v90 < v92) and v95.ShieldCharge:IsCastable() and not v99) then
								if (v23(v95.ShieldCharge, not v14:IsSpellInRange(v95.ShieldCharge)) or ((9827 - 7248) < (324 - 201))) then
									return "shield_charge main 34";
								end
							end
							v195 = 2 - 1;
						end
						if ((v195 == (29 - 23)) or ((2626 - (389 + 1391)) >= (1486 + 882))) then
							if (((v90 < v92) and v47 and ((v55 and v31) or not v55) and v95.ThunderousRoar:IsCastable()) or ((418 + 3594) <= (7644 - 4286))) then
								if (((2445 - (783 + 168)) <= (10085 - 7080)) and v23(v95.ThunderousRoar, not v14:IsInMeleeRange(8 + 0))) then
									return "thunderous_roar main 30";
								end
							end
							if ((v95.ShieldSlam:IsCastable() and v43 and v13:BuffUp(v95.FervidBuff)) or ((3422 - (309 + 2)) == (6553 - 4419))) then
								if (((3567 - (1090 + 122)) == (764 + 1591)) and v23(v95.ShieldSlam, not v99)) then
									return "shield_slam main 31";
								end
							end
							if ((v95.Shockwave:IsCastable() and v44 and ((v13:BuffUp(v95.AvatarBuff) and v95.UnstoppableForce:IsAvailable() and not v95.RumblingEarth:IsAvailable()) or (v95.SonicBoom:IsAvailable() and v95.RumblingEarth:IsAvailable() and (v101 >= (9 - 6)))) and v14:IsCasting()) or ((403 + 185) <= (1550 - (628 + 490)))) then
								v107(2 + 8);
								if (((11876 - 7079) >= (17800 - 13905)) and v23(v95.Shockwave, not v14:IsInMeleeRange(782 - (431 + 343)))) then
									return "shockwave main 32";
								end
							end
							v195 = 13 - 6;
						end
						if (((10347 - 6770) == (2826 + 751)) and (v195 == (1 + 1))) then
							if (((5489 - (556 + 1139)) > (3708 - (6 + 9))) and v95.WreckingThrow:IsCastable() and v48 and v13:CanAttack(v14) and v102()) then
								if (v23(v95.WreckingThrow, not v14:IsSpellInRange(v95.WreckingThrow)) or ((234 + 1041) == (2101 + 1999))) then
									return "wrecking_throw main";
								end
							end
							if (((v90 < v92) and v33 and ((v51 and v31) or not v51) and v95.Avatar:IsCastable()) or ((1760 - (28 + 141)) >= (1387 + 2193))) then
								if (((1212 - 229) <= (1281 + 527)) and v23(v95.Avatar)) then
									return "avatar main 2";
								end
							end
							if (((v90 < v92) and v50 and ((v57 and v31) or not v57)) or ((3467 - (486 + 831)) <= (3114 - 1917))) then
								if (((13268 - 9499) >= (222 + 951)) and v95.BloodFury:IsCastable()) then
									if (((4695 - 3210) == (2748 - (668 + 595))) and v23(v95.BloodFury)) then
										return "blood_fury main 4";
									end
								end
								if (v95.Berserking:IsCastable() or ((2983 + 332) <= (561 + 2221))) then
									if (v23(v95.Berserking) or ((2388 - 1512) >= (3254 - (23 + 267)))) then
										return "berserking main 6";
									end
								end
								if (v95.ArcaneTorrent:IsCastable() or ((4176 - (1129 + 815)) > (2884 - (371 + 16)))) then
									if (v23(v95.ArcaneTorrent) or ((3860 - (1326 + 424)) <= (628 - 296))) then
										return "arcane_torrent main 8";
									end
								end
								if (((13469 - 9783) > (3290 - (88 + 30))) and v95.LightsJudgment:IsCastable()) then
									if (v23(v95.LightsJudgment) or ((5245 - (720 + 51)) < (1824 - 1004))) then
										return "lights_judgment main 10";
									end
								end
								if (((6055 - (421 + 1355)) >= (4753 - 1871)) and v95.Fireblood:IsCastable()) then
									if (v23(v95.Fireblood) or ((997 + 1032) >= (4604 - (286 + 797)))) then
										return "fireblood main 12";
									end
								end
								if (v95.AncestralCall:IsCastable() or ((7446 - 5409) >= (7688 - 3046))) then
									if (((2159 - (397 + 42)) < (1393 + 3065)) and v23(v95.AncestralCall)) then
										return "ancestral_call main 14";
									end
								end
								if (v95.BagofTricks:IsCastable() or ((1236 - (24 + 776)) > (4653 - 1632))) then
									if (((1498 - (222 + 563)) <= (1865 - 1018)) and v23(v95.BagofTricks)) then
										return "ancestral_call main 16";
									end
								end
							end
							v195 = 3 + 0;
						end
						if (((2344 - (23 + 167)) <= (5829 - (690 + 1108))) and ((3 + 4) == v195)) then
							if (((3807 + 808) == (5463 - (40 + 808))) and (v90 < v92) and v95.ShieldCharge:IsCastable() and v42 and ((v53 and v31) or not v53)) then
								v107(7 + 33);
								if (v23(v95.ShieldCharge, not v14:IsSpellInRange(v95.ShieldCharge)) or ((14492 - 10702) == (478 + 22))) then
									return "shield_charge main 34";
								end
							end
							if (((48 + 41) < (122 + 99)) and v106() and v63) then
								if (((2625 - (47 + 524)) >= (923 + 498)) and v23(v95.ShieldBlock)) then
									return "shield_block main 38";
								end
							end
							if (((1891 - 1199) < (4572 - 1514)) and (v101 > (6 - 3))) then
								v28 = v111();
								if (v28 or ((4980 - (1165 + 561)) == (50 + 1605))) then
									return v28;
								end
								if (v19.CastAnnotated(v95.Pool, false, "WAIT") or ((4013 - 2717) == (1874 + 3036))) then
									return "Pool for Aoe()";
								end
							end
							v195 = 487 - (341 + 138);
						end
						if (((910 + 2458) == (6950 - 3582)) and (v195 == (331 - (89 + 237)))) then
							if (((8502 - 5859) < (8031 - 4216)) and v95.DemoralizingShout:IsCastable() and v36 and v95.BoomingVoice:IsAvailable()) then
								local v202 = 881 - (581 + 300);
								while true do
									if (((3133 - (855 + 365)) > (1170 - 677)) and ((0 + 0) == v202)) then
										v107(1265 - (1030 + 205));
										if (((4465 + 290) > (3189 + 239)) and v23(v95.DemoralizingShout, not v99)) then
											return "demoralizing_shout main 28";
										end
										break;
									end
								end
							end
							if (((1667 - (156 + 130)) <= (5382 - 3013)) and (v90 < v92) and v45 and ((v54 and v31) or not v54) and (v84 == "player") and v95.ChampionsSpear:IsCastable()) then
								local v203 = 0 - 0;
								while true do
									if ((v203 == (0 - 0)) or ((1277 + 3566) == (2382 + 1702))) then
										v107(89 - (10 + 59));
										if (((1321 + 3348) > (1787 - 1424)) and v23(v97.ChampionsSpearPlayer, not v99)) then
											return "spear_of_bastion main 28";
										end
										break;
									end
								end
							end
							if (((v90 < v92) and v45 and ((v54 and v31) or not v54) and (v84 == "cursor") and v95.ChampionsSpear:IsCastable()) or ((3040 - (671 + 492)) >= (2499 + 639))) then
								local v204 = 1215 - (369 + 846);
								while true do
									if (((1256 + 3486) >= (3095 + 531)) and (v204 == (1945 - (1036 + 909)))) then
										v107(16 + 4);
										if (v23(v97.ChampionsSpearCursor, not v99) or ((7622 - 3082) == (1119 - (11 + 192)))) then
											return "spear_of_bastion main 28";
										end
										break;
									end
								end
							end
							v195 = 4 + 2;
						end
						if ((v195 == (179 - (135 + 40))) or ((2800 - 1644) > (2619 + 1726))) then
							if (((4928 - 2691) < (6369 - 2120)) and v103() and v64 and v95.LastStand:IsCastable() and v13:BuffDown(v95.ShieldWallBuff) and (((v14:HealthPercentage() >= (266 - (50 + 126))) and v95.UnnervingFocus:IsAvailable()) or ((v14:HealthPercentage() <= (55 - 35)) and v95.UnnervingFocus:IsAvailable()) or v95.Bolster:IsAvailable() or v13:HasTier(7 + 23, 1415 - (1233 + 180)))) then
								if (v23(v95.LastStand) or ((3652 - (522 + 447)) < (1444 - (107 + 1314)))) then
									return "last_stand defensive";
								end
							end
							if (((324 + 373) <= (2516 - 1690)) and (v90 < v92) and v40 and ((v52 and v31) or not v52) and (v83 == "player") and v95.Ravager:IsCastable()) then
								v107(5 + 5);
								if (((2194 - 1089) <= (4652 - 3476)) and v23(v97.RavagerPlayer, not v99)) then
									return "ravager main 24";
								end
							end
							if (((5289 - (716 + 1194)) <= (66 + 3746)) and (v90 < v92) and v40 and ((v52 and v31) or not v52) and (v83 == "cursor") and v95.Ravager:IsCastable()) then
								local v205 = 0 + 0;
								while true do
									if ((v205 == (503 - (74 + 429))) or ((1519 - 731) >= (801 + 815))) then
										v107(22 - 12);
										if (((1312 + 542) <= (10416 - 7037)) and v23(v97.RavagerCursor, not v99)) then
											return "ravager main 24";
										end
										break;
									end
								end
							end
							v195 = 12 - 7;
						end
						if (((4982 - (279 + 154)) == (5327 - (454 + 324))) and (v195 == (3 + 0))) then
							v196 = v94.HandleDPSPotion(v14:BuffUp(v95.AvatarBuff));
							if (v196 or ((3039 - (12 + 5)) >= (1631 + 1393))) then
								return v196;
							end
							if (((12281 - 7461) > (813 + 1385)) and v95.IgnorePain:IsReady() and v65 and v104() and (((v14:HealthPercentage() >= (1113 - (277 + 816))) and (((v13:RageDeficit() <= (63 - 48)) and v95.ShieldSlam:CooldownUp()) or ((v13:RageDeficit() <= (1223 - (1058 + 125))) and v95.ShieldCharge:CooldownUp() and v95.ChampionsBulwark:IsAvailable()) or ((v13:RageDeficit() <= (4 + 16)) and v95.ShieldCharge:CooldownUp()) or ((v13:RageDeficit() <= (1005 - (815 + 160))) and v95.DemoralizingShout:CooldownUp() and v95.BoomingVoice:IsAvailable()) or ((v13:RageDeficit() <= (85 - 65)) and v95.Avatar:CooldownUp()) or ((v13:RageDeficit() <= (106 - 61)) and v95.DemoralizingShout:CooldownUp() and v95.BoomingVoice:IsAvailable() and v13:BuffUp(v95.LastStandBuff) and v95.UnnervingFocus:IsAvailable()) or ((v13:RageDeficit() <= (8 + 22)) and v95.Avatar:CooldownUp() and v13:BuffUp(v95.LastStandBuff) and v95.UnnervingFocus:IsAvailable()) or (v13:RageDeficit() <= (58 - 38)) or ((v13:RageDeficit() <= (1938 - (41 + 1857))) and v95.ShieldSlam:CooldownUp() and v13:BuffUp(v95.ViolentOutburstBuff) and v95.HeavyRepercussions:IsAvailable() and v95.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (1948 - (1222 + 671))) and v95.ShieldSlam:CooldownUp() and v13:BuffUp(v95.ViolentOutburstBuff) and v13:BuffUp(v95.LastStandBuff) and v95.UnnervingFocus:IsAvailable() and v95.HeavyRepercussions:IsAvailable() and v95.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (43 - 26)) and v95.ShieldSlam:CooldownUp() and v95.HeavyRepercussions:IsAvailable()) or ((v13:RageDeficit() <= (25 - 7)) and v95.ShieldSlam:CooldownUp() and v95.ImpenetrableWall:IsAvailable()))) or (((v13:Rage() >= (1252 - (229 + 953))) or ((v13:BuffStack(v95.SeeingRedBuff) == (1781 - (1111 + 663))) and (v13:Rage() >= (1614 - (874 + 705))))) and (v95.ShieldSlam:CooldownRemains() <= (1 + 0)) and (v13:BuffRemains(v95.ShieldBlockBuff) >= (3 + 1)) and v13:HasTier(64 - 33, 1 + 1)))) then
								if (v23(v95.IgnorePain, nil, nil, true) or ((1740 - (642 + 37)) >= (1116 + 3775))) then
									return "ignore_pain main 20";
								end
							end
							v195 = 1 + 3;
						end
					end
				end
				break;
			end
		end
	end
	local function v115()
		v32 = EpicSettings.Settings['useWeapon'];
		v34 = EpicSettings.Settings['useBattleShout'];
		v35 = EpicSettings.Settings['useCharge'];
		v36 = EpicSettings.Settings['useDemoralizingShout'];
		v37 = EpicSettings.Settings['useDevastate'];
		v38 = EpicSettings.Settings['useExecute'];
		v39 = EpicSettings.Settings['useHeroicThrow'];
		v41 = EpicSettings.Settings['useRevenge'];
		v43 = EpicSettings.Settings['useShieldSlam'];
		v44 = EpicSettings.Settings['useShockwave'];
		v46 = EpicSettings.Settings['useThunderClap'];
		v48 = EpicSettings.Settings['useWreckingThrow'];
		v33 = EpicSettings.Settings['useAvatar'];
		v40 = EpicSettings.Settings['useRavager'];
		v42 = EpicSettings.Settings['useShieldCharge'];
		v45 = EpicSettings.Settings['useChampionsSpear'];
		v47 = EpicSettings.Settings['useThunderousRoar'];
		v51 = EpicSettings.Settings['avatarWithCD'];
		v52 = EpicSettings.Settings['ravagerWithCD'];
		v53 = EpicSettings.Settings['shieldChargeWithCD'];
		v54 = EpicSettings.Settings['championsSpearWithCD'];
		v55 = EpicSettings.Settings['thunderousRoarWithCD'];
	end
	local function v116()
		local v153 = 0 - 0;
		while true do
			if (((1818 - (233 + 221)) <= (10343 - 5870)) and (v153 == (0 + 0))) then
				v58 = EpicSettings.Settings['usePummel'];
				v59 = EpicSettings.Settings['useStormBolt'];
				v60 = EpicSettings.Settings['useIntimidatingShout'];
				v153 = 1542 - (718 + 823);
			end
			if ((v153 == (2 + 0)) or ((4400 - (266 + 539)) <= (8 - 5))) then
				v64 = EpicSettings.Settings['useLastStand'];
				v66 = EpicSettings.Settings['useRallyingCry'];
				v63 = EpicSettings.Settings['useShieldBlock'];
				v153 = 1228 - (636 + 589);
			end
			if ((v153 == (16 - 9)) or ((9635 - 4963) == (3053 + 799))) then
				v79 = EpicSettings.Settings['defensiveStanceHP'] or (0 + 0);
				v83 = EpicSettings.Settings['ravagerSetting'] or "";
				v84 = EpicSettings.Settings['spearSetting'] or "";
				break;
			end
			if (((2574 - (657 + 358)) == (4127 - 2568)) and ((13 - 7) == v153)) then
				v73 = EpicSettings.Settings['shieldBlockHP'] or (1187 - (1151 + 36));
				v72 = EpicSettings.Settings['shieldWallHP'] or (0 + 0);
				v82 = EpicSettings.Settings['victoryRushHP'] or (0 + 0);
				v153 = 20 - 13;
			end
			if ((v153 == (1833 - (1552 + 280))) or ((2586 - (64 + 770)) <= (536 + 252))) then
				v61 = EpicSettings.Settings['useBitterImmunity'];
				v65 = EpicSettings.Settings['useIgnorePain'];
				v67 = EpicSettings.Settings['useIntervene'];
				v153 = 4 - 2;
			end
			if ((v153 == (1 + 3)) or ((5150 - (157 + 1086)) == (353 - 176))) then
				v71 = EpicSettings.Settings['bitterImmunityHP'] or (0 - 0);
				v75 = EpicSettings.Settings['ignorePainHP'] or (0 - 0);
				v78 = EpicSettings.Settings['interveneHP'] or (0 - 0);
				v153 = 824 - (599 + 220);
			end
			if (((6910 - 3440) > (2486 - (1813 + 118))) and (v153 == (4 + 1))) then
				v74 = EpicSettings.Settings['lastStandHP'] or (1217 - (841 + 376));
				v77 = EpicSettings.Settings['rallyingCryGroup'] or (0 - 0);
				v76 = EpicSettings.Settings['rallyingCryHP'] or (0 + 0);
				v153 = 16 - 10;
			end
			if ((v153 == (862 - (464 + 395))) or ((2494 - 1522) == (310 + 335))) then
				v62 = EpicSettings.Settings['useShieldWall'];
				v70 = EpicSettings.Settings['useVictoryRush'];
				v93 = EpicSettings.Settings['useChangeStance'];
				v153 = 841 - (467 + 370);
			end
		end
	end
	local function v117()
		local v154 = 0 - 0;
		while true do
			if (((2336 + 846) >= (7250 - 5135)) and (v154 == (1 + 1))) then
				v68 = EpicSettings.Settings['useHealthstone'];
				v69 = EpicSettings.Settings['useHealingPotion'];
				v80 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v81 = EpicSettings.Settings['healingPotionHP'] or (520 - (150 + 370));
				v154 = 1285 - (74 + 1208);
			end
			if (((9575 - 5682) < (21004 - 16575)) and (v154 == (0 + 0))) then
				v90 = EpicSettings.Settings['fightRemainsCheck'] or (390 - (14 + 376));
				v87 = EpicSettings.Settings['InterruptWithStun'];
				v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v89 = EpicSettings.Settings['InterruptThreshold'];
				v154 = 1 - 0;
			end
			if ((v154 == (1 + 0)) or ((2519 + 348) < (1817 + 88))) then
				v49 = EpicSettings.Settings['useTrinkets'];
				v50 = EpicSettings.Settings['useRacials'];
				v56 = EpicSettings.Settings['trinketsWithCD'];
				v57 = EpicSettings.Settings['racialsWithCD'];
				v154 = 5 - 3;
			end
			if (((3 + 0) == v154) or ((1874 - (23 + 55)) >= (9600 - 5549))) then
				v86 = EpicSettings.Settings['HealingPotionName'] or "";
				v85 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v118()
		local v155 = 0 + 0;
		while true do
			if (((1454 + 165) <= (5823 - 2067)) and (v155 == (1 + 1))) then
				if (((1505 - (652 + 249)) == (1616 - 1012)) and v13:IsDeadOrGhost()) then
					return v28;
				end
				if (v30 or ((6352 - (708 + 1160)) == (2442 - 1542))) then
					local v197 = 0 - 0;
					while true do
						if (((27 - (10 + 17)) == v197) or ((1002 + 3457) <= (2845 - (1400 + 332)))) then
							v100 = v13:GetEnemiesInMeleeRange(15 - 7);
							v101 = #v100;
							break;
						end
					end
				else
					v101 = 1909 - (242 + 1666);
				end
				v99 = v14:IsInMeleeRange(4 + 4);
				v155 = 2 + 1;
			end
			if (((3096 + 536) > (4338 - (850 + 90))) and (v155 == (0 - 0))) then
				v116();
				v115();
				v117();
				v155 = 1391 - (360 + 1030);
			end
			if (((3613 + 469) <= (13878 - 8961)) and (v155 == (1 - 0))) then
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v155 = 1663 - (909 + 752);
			end
			if (((6055 - (109 + 1114)) >= (2537 - 1151)) and (v155 == (2 + 1))) then
				if (((379 - (6 + 236)) == (87 + 50)) and (v94.TargetIsValid() or v13:AffectingCombat())) then
					local v198 = 0 + 0;
					while true do
						if ((v198 == (2 - 1)) or ((2742 - 1172) >= (5465 - (1076 + 57)))) then
							if ((v92 == (1828 + 9283)) or ((4753 - (579 + 110)) <= (144 + 1675))) then
								v92 = v10.FightRemains(v100, false);
							end
							break;
						end
						if ((v198 == (0 + 0)) or ((2647 + 2339) < (1981 - (174 + 233)))) then
							v91 = v10.BossFightRemains(nil, true);
							v92 = v91;
							v198 = 2 - 1;
						end
					end
				end
				if (((7768 - 3342) > (77 + 95)) and not v13:IsChanneling()) then
					if (((1760 - (663 + 511)) > (406 + 49)) and v13:AffectingCombat()) then
						local v199 = 0 + 0;
						while true do
							if (((2546 - 1720) == (501 + 325)) and (v199 == (0 - 0))) then
								v28 = v114();
								if (v28 or ((9728 - 5709) > (2120 + 2321))) then
									return v28;
								end
								break;
							end
						end
					else
						local v200 = 0 - 0;
						while true do
							if (((1438 + 579) < (390 + 3871)) and (v200 == (722 - (478 + 244)))) then
								v28 = v113();
								if (((5233 - (440 + 77)) > (37 + 43)) and v28) then
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
	local function v119()
		v19.Print("Protection Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(266 - 193, v118, v119);
end;
return v0["Epix_Warrior_Protection.lua"]();

