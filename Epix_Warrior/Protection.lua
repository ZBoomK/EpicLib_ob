local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((233 + 775) <= (7454 - 3743)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Warrior_Protection.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = v9.Unit;
	local v11 = v9.Utils;
	local v12 = v10.Player;
	local v13 = v10.Target;
	local v14 = v10.TargetTarget;
	local v15 = v10.Focus;
	local v16 = v9.Spell;
	local v17 = v9.Item;
	local v18 = EpicLib;
	local v19 = v18.Bind;
	local v20 = v18.Cast;
	local v21 = v18.Macro;
	local v22 = v18.Press;
	local v23 = v18.Commons.Everyone.num;
	local v24 = v18.Commons.Everyone.bool;
	local v25 = UnitIsUnit;
	local v26 = math.floor;
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
	local v90 = 8423 + 2688;
	local v91 = 4979 + 6132;
	local v92;
	local v93 = v18.Commons.Everyone;
	local v94 = v16.Warrior.Protection;
	local v95 = v17.Warrior.Protection;
	local v96 = v21.Warrior.Protection;
	local v97 = {};
	local v98;
	local v99;
	local v100;
	local function v101()
		local v119 = UnitGetTotalAbsorbs(v13:ID());
		if ((v119 > (1790 - (1010 + 780))) or ((1049 + 0) <= (4316 - 3410))) then
			return true;
		else
			return false;
		end
	end
	local function v102()
		return v12:IsTankingAoE(46 - 30) or v12:IsTanking(v13) or v13:IsDummy();
	end
	local function v103()
		if (((6349 - (1045 + 791)) > (6900 - 4174)) and v12:BuffUp(v94.IgnorePain)) then
			local v155 = 0 - 0;
			local v156;
			local v157;
			local v158;
			while true do
				if ((v155 == (506 - (351 + 154))) or ((3055 - (1281 + 293)) >= (2924 - (28 + 238)))) then
					v158 = v157.points[2 - 1];
					return (v158 + v156) < (v12:MaxHealth() * (1559.3 - (1381 + 178)));
				end
				if ((v155 == (0 + 0)) or ((2597 + 623) == (582 + 782))) then
					v156 = v12:AttackPowerDamageMod() * (13.375 - 9) * (1 + 0 + (v12:VersatilityDmgPct() / (570 - (381 + 89))));
					v157 = v12:AuraInfo(v94.IgnorePain, nil, true);
					v155 = 1 + 0;
				end
			end
		else
			return true;
		end
	end
	local function v104()
		if (v12:BuffUp(v94.IgnorePain) or ((713 + 341) > (5809 - 2417))) then
			local v159 = 1156 - (1074 + 82);
			local v160;
			while true do
				if ((v159 == (0 - 0)) or ((2460 - (214 + 1570)) >= (3097 - (990 + 465)))) then
					v160 = v12:BuffInfo(v94.IgnorePain, nil, true);
					return v160.points[1 + 0];
				end
			end
		else
			return 0 + 0;
		end
	end
	local function v105()
		return v102() and v94.ShieldBlock:IsReady() and (v12:BuffRemains(v94.ShieldBlockBuff) <= (10 + 0));
	end
	local function v106(v120)
		local v121 = 0 - 0;
		local v122;
		local v123;
		local v124;
		while true do
			if (((5862 - (1668 + 58)) > (3023 - (512 + 114))) and (v121 == (2 - 1))) then
				v123 = false;
				v124 = (v12:Rage() >= (72 - 37)) and not v105();
				v121 = 6 - 4;
			end
			if ((v121 == (0 + 0)) or ((812 + 3522) == (3691 + 554))) then
				v122 = 269 - 189;
				if ((v122 < (2029 - (109 + 1885))) or (v12:Rage() < (1504 - (1269 + 200))) or ((8195 - 3919) <= (3846 - (98 + 717)))) then
					return false;
				end
				v121 = 827 - (802 + 24);
			end
			if ((v121 == (2 - 0)) or ((6039 - 1257) <= (178 + 1021))) then
				if ((v124 and (((v12:Rage() + v120) >= v122) or v94.DemoralizingShout:IsReady())) or ((3738 + 1126) < (313 + 1589))) then
					v123 = true;
				end
				if (((1044 + 3795) >= (10293 - 6593)) and v123) then
					if ((v102() and v103()) or ((3584 - 2509) > (687 + 1231))) then
						if (((162 + 234) <= (3138 + 666)) and v22(v94.IgnorePain, nil, nil, true)) then
							return "ignore_pain rage capped";
						end
					elseif (v22(v94.Revenge, not v98) or ((3032 + 1137) == (1022 + 1165))) then
						return "revenge rage capped";
					end
				end
				break;
			end
		end
	end
	local function v107()
		local v125 = 1433 - (797 + 636);
		while true do
			if (((6826 - 5420) == (3025 - (1427 + 192))) and (v125 == (1 + 0))) then
				if (((3554 - 2023) < (3840 + 431)) and v94.IgnorePain:IsReady() and v64 and (v12:HealthPercentage() <= v74) and v103()) then
					if (((288 + 347) == (961 - (192 + 134))) and v22(v94.IgnorePain, nil, nil, true)) then
						return "ignore_pain defensive";
					end
				end
				if (((4649 - (316 + 960)) <= (1979 + 1577)) and v94.RallyingCry:IsReady() and v65 and v12:BuffDown(v94.AspectsFavorBuff) and v12:BuffDown(v94.RallyingCry) and (((v12:HealthPercentage() <= v75) and v93.IsSoloMode()) or v93.AreUnitsBelowHealthPercentage(v75, v76, v94.Intervene))) then
					if (v22(v94.RallyingCry) or ((2540 + 751) < (3032 + 248))) then
						return "rallying_cry defensive";
					end
				end
				v125 = 7 - 5;
			end
			if (((4937 - (83 + 468)) >= (2679 - (1202 + 604))) and (v125 == (0 - 0))) then
				if (((1532 - 611) <= (3051 - 1949)) and v94.BitterImmunity:IsReady() and v60 and (v12:HealthPercentage() <= v70)) then
					if (((5031 - (45 + 280)) >= (930 + 33)) and v22(v94.BitterImmunity)) then
						return "bitter_immunity defensive";
					end
				end
				if ((v94.LastStand:IsCastable() and v63 and ((v12:HealthPercentage() <= v73) or v12:ActiveMitigationNeeded())) or ((839 + 121) <= (320 + 556))) then
					if (v22(v94.LastStand) or ((1144 + 922) == (164 + 768))) then
						return "last_stand defensive";
					end
				end
				v125 = 1 - 0;
			end
			if (((6736 - (340 + 1571)) < (1911 + 2932)) and (v125 == (1775 - (1733 + 39)))) then
				if ((v95.Healthstone:IsReady() and v67 and (v12:HealthPercentage() <= v79)) or ((10653 - 6776) >= (5571 - (125 + 909)))) then
					if (v22(v96.Healthstone) or ((6263 - (1096 + 852)) < (775 + 951))) then
						return "healthstone defensive 3";
					end
				end
				if ((v68 and (v12:HealthPercentage() <= v80)) or ((5253 - 1574) < (607 + 18))) then
					if ((v85 == "Refreshing Healing Potion") or ((5137 - (409 + 103)) < (868 - (46 + 190)))) then
						if (v95.RefreshingHealingPotion:IsReady() or ((178 - (51 + 44)) > (503 + 1277))) then
							if (((1863 - (1114 + 203)) <= (1803 - (228 + 498))) and v22(v96.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v85 == "Dreamwalker's Healing Potion") or ((216 + 780) > (2377 + 1924))) then
						if (((4733 - (174 + 489)) > (1789 - 1102)) and v95.DreamwalkersHealingPotion:IsReady()) then
							if (v22(v96.RefreshingHealingPotion) or ((2561 - (830 + 1075)) >= (3854 - (303 + 221)))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					if ((v85 == "Potion of Withering Dreams") or ((3761 - (231 + 1038)) <= (280 + 55))) then
						if (((5484 - (171 + 991)) >= (10558 - 7996)) and v95.PotionOfWitheringDreams:IsReady()) then
							if (v22(v96.RefreshingHealingPotion) or ((9765 - 6128) >= (9407 - 5637))) then
								return "potion of withering dreams defensive";
							end
						end
					end
				end
				break;
			end
			if ((v125 == (2 + 0)) or ((8339 - 5960) > (13206 - 8628))) then
				if ((v94.Intervene:IsReady() and v66 and (v15:HealthPercentage() <= v77) and (v15:Name() ~= v12:Name())) or ((778 - 295) > (2296 - 1553))) then
					if (((3702 - (111 + 1137)) > (736 - (91 + 67))) and v22(v96.InterveneFocus)) then
						return "intervene defensive";
					end
				end
				if (((2767 - 1837) < (1113 + 3345)) and v94.ShieldWall:IsCastable() and v61 and v12:BuffDown(v94.ShieldWallBuff) and ((v12:HealthPercentage() <= v71) or v12:ActiveMitigationNeeded())) then
					if (((1185 - (423 + 100)) <= (7 + 965)) and v22(v94.ShieldWall)) then
						return "shield_wall defensive";
					end
				end
				v125 = 7 - 4;
			end
		end
	end
	local function v108()
		v27 = v93.HandleTopTrinket(v97, v30, 21 + 19, nil);
		if (((5141 - (326 + 445)) == (19070 - 14700)) and v27) then
			return v27;
		end
		v27 = v93.HandleBottomTrinket(v97, v30, 89 - 49, nil);
		if (v27 or ((11115 - 6353) <= (1572 - (530 + 181)))) then
			return v27;
		end
	end
	local function v109()
		if (v13:IsInMeleeRange(889 - (614 + 267)) or ((1444 - (19 + 13)) == (6939 - 2675))) then
			if ((v94.ThunderClap:IsCastable() and v45) or ((7382 - 4214) < (6150 - 3997))) then
				if (v22(v94.ThunderClap) or ((1293 + 3683) < (2342 - 1010))) then
					return "thunder_clap precombat";
				end
			end
		elseif (((9597 - 4969) == (6440 - (1293 + 519))) and v34 and v94.Charge:IsCastable() and not v13:IsInRange(16 - 8)) then
			if (v22(v94.Charge, not v13:IsSpellInRange(v94.Charge)) or ((140 - 86) == (755 - 360))) then
				return "charge precombat";
			end
		end
	end
	local function v110()
		if (((353 - 271) == (192 - 110)) and v94.ThunderClap:IsCastable() and v45 and (v13:DebuffRemains(v94.RendDebuff) <= (1 + 0))) then
			v106(2 + 3);
			if (v22(v94.ThunderClap, not v13:IsInMeleeRange(18 - 10)) or ((135 + 446) < (94 + 188))) then
				return "thunder_clap aoe 2";
			end
		end
		if ((v94.ShieldSlam:IsCastable() and v42 and ((v12:HasTier(19 + 11, 1098 - (709 + 387)) and (v100 <= (1865 - (673 + 1185)))) or v12:BuffUp(v94.EarthenTenacityBuff))) or ((13366 - 8757) < (8011 - 5516))) then
			if (((1894 - 742) == (824 + 328)) and v22(v94.ShieldSlam, not v98)) then
				return "shield_slam aoe 3";
			end
		end
		if (((1417 + 479) <= (4619 - 1197)) and v94.ThunderClap:IsCastable() and v45 and v12:BuffUp(v94.ViolentOutburstBuff) and (v100 > (2 + 3)) and v12:BuffUp(v94.AvatarBuff) and v94.UnstoppableForce:IsAvailable()) then
			v106(9 - 4);
			if (v22(v94.ThunderClap, not v13:IsInMeleeRange(15 - 7)) or ((2870 - (446 + 1434)) > (2903 - (1040 + 243)))) then
				return "thunder_clap aoe 4";
			end
		end
		if ((v94.Revenge:IsReady() and v40 and (v12:Rage() >= (208 - 138)) and v94.SeismicReverberation:IsAvailable() and (v100 >= (1850 - (559 + 1288)))) or ((2808 - (609 + 1322)) > (5149 - (13 + 441)))) then
			if (((10055 - 7364) >= (4848 - 2997)) and v22(v94.Revenge, not v98)) then
				return "revenge aoe 6";
			end
		end
		if ((v94.ShieldSlam:IsCastable() and v42 and ((v12:Rage() <= (298 - 238)) or (v12:BuffUp(v94.ViolentOutburstBuff) and (v100 <= (1 + 6))))) or ((10840 - 7855) >= (1725 + 3131))) then
			v106(9 + 11);
			if (((12689 - 8413) >= (654 + 541)) and v22(v94.ShieldSlam, not v98)) then
				return "shield_slam aoe 8";
			end
		end
		if (((5943 - 2711) <= (3101 + 1589)) and v94.ThunderClap:IsCastable() and v45) then
			local v161 = 0 + 0;
			while true do
				if ((v161 == (0 + 0)) or ((753 + 143) >= (3079 + 67))) then
					v106(438 - (153 + 280));
					if (((8838 - 5777) >= (2656 + 302)) and v22(v94.ThunderClap, not v13:IsInMeleeRange(4 + 4))) then
						return "thunder_clap aoe 10";
					end
					break;
				end
			end
		end
		if (((1668 + 1519) >= (585 + 59)) and v94.Revenge:IsReady() and v40 and ((v12:Rage() >= (22 + 8)) or ((v12:Rage() >= (60 - 20)) and v94.BarbaricTraining:IsAvailable()))) then
			if (((399 + 245) <= (1371 - (89 + 578))) and v22(v94.Revenge, not v98)) then
				return "revenge aoe 12";
			end
		end
	end
	local function v111()
		if (((685 + 273) > (1968 - 1021)) and v94.ShieldSlam:IsCastable() and v42) then
			local v162 = 1049 - (572 + 477);
			while true do
				if (((606 + 3886) >= (1593 + 1061)) and (v162 == (0 + 0))) then
					v106(106 - (84 + 2));
					if (((5671 - 2229) >= (1083 + 420)) and v22(v94.ShieldSlam, not v98)) then
						return "shield_slam generic 2";
					end
					break;
				end
			end
		end
		if ((v94.ThunderClap:IsCastable() and v45 and (v13:DebuffRemains(v94.RendDebuff) <= (844 - (497 + 345))) and v12:BuffDown(v94.ViolentOutburstBuff)) or ((82 + 3088) <= (248 + 1216))) then
			v106(1338 - (605 + 728));
			if (v22(v94.ThunderClap, not v13:IsInMeleeRange(6 + 2)) or ((10664 - 5867) == (202 + 4186))) then
				return "thunder_clap generic 4";
			end
		end
		if (((2037 - 1486) <= (614 + 67)) and v94.Execute:IsReady() and v37 and v12:BuffUp(v94.SuddenDeathBuff) and v94.SuddenDeath:IsAvailable()) then
			if (((9079 - 5802) > (308 + 99)) and v22(v94.Execute, not v98)) then
				return "execute generic 6";
			end
		end
		if (((5184 - (457 + 32)) >= (601 + 814)) and v94.Execute:IsReady() and v37) then
			if (v22(v94.Execute, not v98) or ((4614 - (832 + 570)) <= (890 + 54))) then
				return "execute generic 8";
			end
		end
		if ((v94.ThunderClap:IsCastable() and v45 and ((v100 > (1 + 0)) or (v94.ShieldSlam:CooldownDown() and not v12:BuffUp(v94.ViolentOutburstBuff)))) or ((10956 - 7860) <= (867 + 931))) then
			v106(801 - (588 + 208));
			if (((9532 - 5995) == (5337 - (884 + 916))) and v22(v94.ThunderClap, not v13:IsInMeleeRange(16 - 8))) then
				return "thunder_clap generic 12";
			end
		end
		if (((2225 + 1612) >= (2223 - (232 + 421))) and v94.Revenge:IsReady() and v40 and (((v12:Rage() >= (1969 - (1569 + 320))) and (v13:HealthPercentage() > (5 + 15))) or (v12:BuffUp(v94.RevengeBuff) and (v13:HealthPercentage() <= (4 + 16)) and (v12:Rage() <= (60 - 42)) and v94.ShieldSlam:CooldownDown()) or (v12:BuffUp(v94.RevengeBuff) and (v13:HealthPercentage() > (625 - (316 + 289)))) or ((((v12:Rage() >= (209 - 129)) and (v13:HealthPercentage() > (2 + 33))) or (v12:BuffUp(v94.RevengeBuff) and (v13:HealthPercentage() <= (1488 - (666 + 787))) and (v12:Rage() <= (443 - (360 + 65))) and v94.ShieldSlam:CooldownDown()) or (v12:BuffUp(v94.RevengeBuff) and (v13:HealthPercentage() > (33 + 2)))) and v94.Massacre:IsAvailable()))) then
			if (v22(v94.Revenge, not v98) or ((3204 - (79 + 175)) == (6010 - 2198))) then
				return "revenge generic 14";
			end
		end
		if (((3686 + 1037) >= (7105 - 4787)) and v94.Execute:IsReady() and v37 and (v100 == (1 - 0))) then
			if (v22(v94.Execute, not v98) or ((2926 - (503 + 396)) > (3033 - (92 + 89)))) then
				return "execute generic 16";
			end
		end
		if ((v94.Revenge:IsReady() and v40 and (v13:HealthPercentage() > (38 - 18))) or ((583 + 553) > (2556 + 1761))) then
			if (((18593 - 13845) == (650 + 4098)) and v22(v94.Revenge, not v98)) then
				return "revenge generic 18";
			end
		end
		if (((8518 - 4782) <= (4136 + 604)) and v94.ThunderClap:IsCastable() and v45 and ((v100 >= (1 + 0)) or (v94.ShieldSlam:CooldownDown() and v12:BuffUp(v94.ViolentOutburstBuff)))) then
			v106(15 - 10);
			if (v22(v94.ThunderClap, not v13:IsInMeleeRange(1 + 7)) or ((5169 - 1779) <= (4304 - (485 + 759)))) then
				return "thunder_clap generic 20";
			end
		end
		if ((v94.Devastate:IsCastable() and v36) or ((2311 - 1312) > (3882 - (442 + 747)))) then
			if (((1598 - (832 + 303)) < (1547 - (88 + 858))) and v22(v94.Devastate, not v98)) then
				return "devastate generic 22";
			end
		end
	end
	local function v112()
		local v126 = 0 + 0;
		while true do
			if (((0 + 0) == v126) or ((90 + 2093) < (1476 - (766 + 23)))) then
				if (((22457 - 17908) == (6220 - 1671)) and not v12:AffectingCombat()) then
					local v188 = 0 - 0;
					while true do
						if (((15856 - 11184) == (5745 - (1036 + 37))) and (v188 == (0 + 0))) then
							if ((v94.BattleShout:IsCastable() and v33 and (v12:BuffDown(v94.BattleShoutBuff, true) or v93.GroupBuffMissing(v94.BattleShoutBuff))) or ((7142 - 3474) < (311 + 84))) then
								if (v22(v94.BattleShout) or ((5646 - (641 + 839)) == (1368 - (910 + 3)))) then
									return "battle_shout precombat";
								end
							end
							if ((v92 and v94.BattleStance:IsCastable() and not v12:BuffUp(v94.BattleStance)) or ((11341 - 6892) == (4347 - (1466 + 218)))) then
								if (v22(v94.BattleStance) or ((1966 + 2311) < (4137 - (556 + 592)))) then
									return "battle_stance precombat";
								end
							end
							break;
						end
					end
				end
				if ((v93.TargetIsValid() and v28) or ((310 + 560) >= (4957 - (329 + 479)))) then
					if (((3066 - (174 + 680)) < (10937 - 7754)) and not v12:AffectingCombat()) then
						v27 = v109();
						if (((9629 - 4983) > (2137 + 855)) and v27) then
							return v27;
						end
					end
				end
				break;
			end
		end
	end
	local function v113()
		local v127 = 739 - (396 + 343);
		while true do
			if (((127 + 1307) < (4583 - (29 + 1448))) and ((1390 - (135 + 1254)) == v127)) then
				if (((2960 - 2174) < (14114 - 11091)) and v84) then
					v27 = v93.HandleIncorporeal(v94.StormBolt, v96.StormBoltMouseover, 14 + 6, true);
					if (v27 or ((3969 - (389 + 1138)) < (648 - (102 + 472)))) then
						return v27;
					end
					v27 = v93.HandleIncorporeal(v94.IntimidatingShout, v96.IntimidatingShoutMouseover, 8 + 0, true);
					if (((2515 + 2020) == (4229 + 306)) and v27) then
						return v27;
					end
				end
				if (v93.TargetIsValid() or ((4554 - (320 + 1225)) <= (3747 - 1642))) then
					local v189 = 0 + 0;
					local v190;
					while true do
						if (((3294 - (157 + 1307)) < (5528 - (821 + 1038))) and (v189 == (7 - 4))) then
							v190 = v93.HandleDPSPotion(v13:BuffUp(v94.AvatarBuff));
							if (v190 or ((157 + 1273) >= (6415 - 2803))) then
								return v190;
							end
							if (((999 + 1684) >= (6097 - 3637)) and v94.IgnorePain:IsReady() and v64 and v103() and (((v13:HealthPercentage() >= (1046 - (834 + 192))) and (((v12:RageDeficit() <= (1 + 14)) and v94.ShieldSlam:CooldownUp()) or ((v12:RageDeficit() <= (11 + 29)) and v94.ShieldCharge:CooldownUp() and v94.ChampionsBulwark:IsAvailable()) or ((v12:RageDeficit() <= (1 + 19)) and v94.ShieldCharge:CooldownUp()) or ((v12:RageDeficit() <= (46 - 16)) and v94.DemoralizingShout:CooldownUp() and v94.BoomingVoice:IsAvailable()) or ((v12:RageDeficit() <= (324 - (300 + 4))) and v94.Avatar:CooldownUp()) or ((v12:RageDeficit() <= (13 + 32)) and v94.DemoralizingShout:CooldownUp() and v94.BoomingVoice:IsAvailable() and v12:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable()) or ((v12:RageDeficit() <= (78 - 48)) and v94.Avatar:CooldownUp() and v12:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable()) or (v12:RageDeficit() <= (382 - (112 + 250))) or ((v12:RageDeficit() <= (16 + 24)) and v94.ShieldSlam:CooldownUp() and v12:BuffUp(v94.ViolentOutburstBuff) and v94.HeavyRepercussions:IsAvailable() and v94.ImpenetrableWall:IsAvailable()) or ((v12:RageDeficit() <= (137 - 82)) and v94.ShieldSlam:CooldownUp() and v12:BuffUp(v94.ViolentOutburstBuff) and v12:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable() and v94.HeavyRepercussions:IsAvailable() and v94.ImpenetrableWall:IsAvailable()) or ((v12:RageDeficit() <= (10 + 7)) and v94.ShieldSlam:CooldownUp() and v94.HeavyRepercussions:IsAvailable()) or ((v12:RageDeficit() <= (10 + 8)) and v94.ShieldSlam:CooldownUp() and v94.ImpenetrableWall:IsAvailable()))) or (((v12:Rage() >= (53 + 17)) or ((v12:BuffStack(v94.SeeingRedBuff) == (4 + 3)) and (v12:Rage() >= (27 + 8)))) and (v94.ShieldSlam:CooldownRemains() <= (1415 - (1001 + 413))) and (v12:BuffRemains(v94.ShieldBlockBuff) >= (8 - 4)) and v12:HasTier(913 - (244 + 638), 695 - (627 + 66))))) then
								if (v22(v94.IgnorePain, nil, nil, true) or ((5374 - 3570) >= (3877 - (512 + 90)))) then
									return "ignore_pain main 20";
								end
							end
							v189 = 1910 - (1665 + 241);
						end
						if ((v189 == (721 - (373 + 344))) or ((640 + 777) > (961 + 2668))) then
							if (((12647 - 7852) > (679 - 277)) and v102() and v63 and v94.LastStand:IsCastable() and v12:BuffDown(v94.ShieldWallBuff) and (((v13:HealthPercentage() >= (1189 - (35 + 1064))) and v94.UnnervingFocus:IsAvailable()) or ((v13:HealthPercentage() <= (15 + 5)) and v94.UnnervingFocus:IsAvailable()) or v94.Bolster:IsAvailable() or v12:HasTier(64 - 34, 1 + 1))) then
								if (((6049 - (298 + 938)) > (4824 - (233 + 1026))) and v22(v94.LastStand)) then
									return "last_stand defensive";
								end
							end
							if (((5578 - (636 + 1030)) == (2001 + 1911)) and (v89 < v91) and v39 and ((v51 and v30) or not v51) and (v82 == "player") and v94.Ravager:IsCastable()) then
								v106(10 + 0);
								if (((839 + 1982) <= (326 + 4498)) and v22(v96.RavagerPlayer, not v98)) then
									return "ravager main 24";
								end
							end
							if (((1959 - (55 + 166)) <= (426 + 1769)) and (v89 < v91) and v39 and ((v51 and v30) or not v51) and (v82 == "cursor") and v94.Ravager:IsCastable()) then
								v106(2 + 8);
								if (((156 - 115) <= (3315 - (36 + 261))) and v22(v96.RavagerCursor, not v98)) then
									return "ravager main 24";
								end
							end
							v189 = 8 - 3;
						end
						if (((3513 - (34 + 1334)) <= (1578 + 2526)) and (v189 == (4 + 1))) then
							if (((3972 - (1035 + 248)) < (4866 - (20 + 1))) and v94.DemoralizingShout:IsCastable() and v35 and v94.BoomingVoice:IsAvailable()) then
								local v191 = 0 + 0;
								while true do
									if ((v191 == (319 - (134 + 185))) or ((3455 - (549 + 584)) > (3307 - (314 + 371)))) then
										v106(102 - 72);
										if (v22(v94.DemoralizingShout, not v98) or ((5502 - (478 + 490)) == (1103 + 979))) then
											return "demoralizing_shout main 28";
										end
										break;
									end
								end
							end
							if (((v89 < v91) and v44 and ((v53 and v30) or not v53) and (v83 == "player") and v94.ChampionsSpear:IsCastable()) or ((2743 - (786 + 386)) > (6047 - 4180))) then
								v106(1399 - (1055 + 324));
								if (v22(v96.ChampionsSpearPlayer, not v98) or ((3994 - (1093 + 247)) >= (2663 + 333))) then
									return "spear_of_bastion main 28";
								end
							end
							if (((419 + 3559) > (8353 - 6249)) and (v89 < v91) and v44 and ((v53 and v30) or not v53) and (v83 == "cursor") and v94.ChampionsSpear:IsCastable()) then
								local v192 = 0 - 0;
								while true do
									if (((8522 - 5527) > (3872 - 2331)) and (v192 == (0 + 0))) then
										v106(77 - 57);
										if (((11198 - 7949) > (719 + 234)) and v22(v96.ChampionsSpearCursor, not v98)) then
											return "spear_of_bastion main 28";
										end
										break;
									end
								end
							end
							v189 = 15 - 9;
						end
						if ((v189 == (690 - (364 + 324))) or ((8972 - 5699) > (10973 - 6400))) then
							if ((v94.WreckingThrow:IsCastable() and v47 and v12:CanAttack(v13) and v101()) or ((1045 + 2106) < (5372 - 4088))) then
								if (v22(v94.WreckingThrow, not v13:IsSpellInRange(v94.WreckingThrow)) or ((2962 - 1112) == (4643 - 3114))) then
									return "wrecking_throw main";
								end
							end
							if (((2089 - (1249 + 19)) < (1917 + 206)) and (v89 < v91) and v32 and ((v50 and v30) or not v50) and v94.Avatar:IsCastable()) then
								if (((3510 - 2608) < (3411 - (686 + 400))) and v22(v94.Avatar)) then
									return "avatar main 2";
								end
							end
							if (((674 + 184) <= (3191 - (73 + 156))) and (v89 < v91) and v49 and ((v56 and v30) or not v56)) then
								local v193 = 0 + 0;
								while true do
									if ((v193 == (811 - (721 + 90))) or ((45 + 3901) < (4181 - 2893))) then
										if (v94.BloodFury:IsCastable() or ((3712 - (224 + 246)) == (918 - 351))) then
											if (v22(v94.BloodFury) or ((1559 - 712) >= (230 + 1033))) then
												return "blood_fury main 4";
											end
										end
										if (v94.Berserking:IsCastable() or ((54 + 2199) == (1360 + 491))) then
											if (v22(v94.Berserking) or ((4148 - 2061) > (7893 - 5521))) then
												return "berserking main 6";
											end
										end
										v193 = 514 - (203 + 310);
									end
									if ((v193 == (1996 - (1238 + 755))) or ((311 + 4134) < (5683 - (709 + 825)))) then
										if (v94.BagofTricks:IsCastable() or ((3349 - 1531) == (123 - 38))) then
											if (((1494 - (196 + 668)) < (8397 - 6270)) and v22(v94.BagofTricks)) then
												return "ancestral_call main 16";
											end
										end
										break;
									end
									if (((3 - 1) == v193) or ((2771 - (171 + 662)) == (2607 - (4 + 89)))) then
										if (((14913 - 10658) >= (21 + 34)) and v94.Fireblood:IsCastable()) then
											if (((13172 - 10173) > (454 + 702)) and v22(v94.Fireblood)) then
												return "fireblood main 12";
											end
										end
										if (((3836 - (35 + 1451)) > (2608 - (28 + 1425))) and v94.AncestralCall:IsCastable()) then
											if (((6022 - (941 + 1052)) <= (4654 + 199)) and v22(v94.AncestralCall)) then
												return "ancestral_call main 14";
											end
										end
										v193 = 1517 - (822 + 692);
									end
									if ((v193 == (1 - 0)) or ((244 + 272) > (3731 - (45 + 252)))) then
										if (((4004 + 42) >= (1044 + 1989)) and v94.ArcaneTorrent:IsCastable()) then
											if (v22(v94.ArcaneTorrent) or ((6617 - 3898) <= (1880 - (114 + 319)))) then
												return "arcane_torrent main 8";
											end
										end
										if (v94.LightsJudgment:IsCastable() or ((5935 - 1801) < (5030 - 1104))) then
											if (v22(v94.LightsJudgment) or ((105 + 59) >= (4149 - 1364))) then
												return "lights_judgment main 10";
											end
										end
										v193 = 3 - 1;
									end
								end
							end
							v189 = 1966 - (556 + 1407);
						end
						if ((v189 == (1213 - (741 + 465))) or ((990 - (170 + 295)) == (1112 + 997))) then
							if (((31 + 2) == (80 - 47)) and (v89 < v91) and v94.ShieldCharge:IsCastable() and v41 and ((v52 and v30) or not v52)) then
								local v194 = 0 + 0;
								while true do
									if (((1959 + 1095) <= (2274 + 1741)) and ((1230 - (957 + 273)) == v194)) then
										v106(11 + 29);
										if (((749 + 1122) < (12886 - 9504)) and v22(v94.ShieldCharge, not v13:IsSpellInRange(v94.ShieldCharge))) then
											return "shield_charge main 34";
										end
										break;
									end
								end
							end
							if (((3407 - 2114) <= (6615 - 4449)) and v105() and v62) then
								if (v22(v94.ShieldBlock) or ((12770 - 10191) < (1903 - (389 + 1391)))) then
									return "shield_block main 38";
								end
							end
							if ((v100 > (2 + 1)) or ((89 + 757) >= (5390 - 3022))) then
								v27 = v110();
								if (v27 or ((4963 - (783 + 168)) <= (11270 - 7912))) then
									return v27;
								end
								if (((1470 + 24) <= (3316 - (309 + 2))) and v18.CastAnnotated(v94.Pool, false, "WAIT")) then
									return "Pool for Aoe()";
								end
							end
							v189 = 24 - 16;
						end
						if ((v189 == (1218 - (1090 + 122))) or ((1009 + 2102) == (7166 - 5032))) then
							if (((1612 + 743) == (3473 - (628 + 490))) and (v89 < v91) and v46 and ((v54 and v30) or not v54) and v94.ThunderousRoar:IsCastable()) then
								if (v22(v94.ThunderousRoar, not v13:IsInMeleeRange(2 + 6)) or ((1455 - 867) <= (1974 - 1542))) then
									return "thunderous_roar main 30";
								end
							end
							if (((5571 - (431 + 343)) >= (7866 - 3971)) and v94.ShieldSlam:IsCastable() and v42 and v12:BuffUp(v94.FervidBuff)) then
								if (((10347 - 6770) == (2826 + 751)) and v22(v94.ShieldSlam, not v98)) then
									return "shield_slam main 31";
								end
							end
							if (((486 + 3308) > (5388 - (556 + 1139))) and v94.Shockwave:IsCastable() and v43 and ((v12:BuffUp(v94.AvatarBuff) and v94.UnstoppableForce:IsAvailable() and not v94.RumblingEarth:IsAvailable()) or (v94.SonicBoom:IsAvailable() and v94.RumblingEarth:IsAvailable() and (v100 >= (18 - (6 + 9))))) and v13:IsCasting()) then
								local v195 = 0 + 0;
								while true do
									if ((v195 == (0 + 0)) or ((1444 - (28 + 141)) == (1589 + 2511))) then
										v106(12 - 2);
										if (v22(v94.Shockwave, not v13:IsInMeleeRange(6 + 2)) or ((2908 - (486 + 831)) >= (9316 - 5736))) then
											return "shockwave main 32";
										end
										break;
									end
								end
							end
							v189 = 24 - 17;
						end
						if (((186 + 797) <= (5716 - 3908)) and (v189 == (1263 - (668 + 595)))) then
							if ((v92 and (v12:HealthPercentage() <= v78)) or ((1935 + 215) <= (242 + 955))) then
								if (((10278 - 6509) >= (1463 - (23 + 267))) and v94.DefensiveStance:IsCastable() and not v12:BuffUp(v94.DefensiveStance)) then
									if (((3429 - (1129 + 815)) == (1872 - (371 + 16))) and v22(v94.DefensiveStance)) then
										return "defensive_stance while tanking";
									end
								end
							end
							if ((v92 and (v12:HealthPercentage() > v78)) or ((5065 - (1326 + 424)) <= (5268 - 2486))) then
								if ((v94.BattleStance:IsCastable() and not v12:BuffUp(v94.BattleStance)) or ((3201 - 2325) >= (3082 - (88 + 30)))) then
									if (v22(v94.BattleStance) or ((3003 - (720 + 51)) > (5554 - 3057))) then
										return "battle_stance while not tanking";
									end
								end
							end
							if ((v41 and ((v52 and v30) or not v52) and (v89 < v91) and v94.ShieldCharge:IsCastable() and not v98) or ((3886 - (421 + 1355)) <= (546 - 214))) then
								if (((1811 + 1875) > (4255 - (286 + 797))) and v22(v94.ShieldCharge, not v13:IsSpellInRange(v94.ShieldCharge))) then
									return "shield_charge main 34";
								end
							end
							v189 = 3 - 2;
						end
						if ((v189 == (12 - 4)) or ((4913 - (397 + 42)) < (257 + 563))) then
							v27 = v111();
							if (((5079 - (24 + 776)) >= (4439 - 1557)) and v27) then
								return v27;
							end
							if (v18.CastAnnotated(v94.Pool, false, "WAIT") or ((2814 - (222 + 563)) >= (7757 - 4236))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((v189 == (1 + 0)) or ((2227 - (23 + 167)) >= (6440 - (690 + 1108)))) then
							if (((621 + 1099) < (3678 + 780)) and v34 and v94.Charge:IsCastable() and not v98) then
								if (v22(v94.Charge, not v13:IsSpellInRange(v94.Charge)) or ((1284 - (40 + 808)) > (498 + 2523))) then
									return "charge main 34";
								end
							end
							if (((2726 - 2013) <= (810 + 37)) and (v89 < v91)) then
								if (((1140 + 1014) <= (2211 + 1820)) and v48 and ((v30 and v55) or not v55)) then
									v27 = v108();
									if (((5186 - (47 + 524)) == (2995 + 1620)) and v27) then
										return v27;
									end
								end
								if ((v30 and v95.FyralathTheDreamrender:IsEquippedAndReady() and v31) or ((10360 - 6570) == (747 - 247))) then
									if (((202 - 113) < (1947 - (1165 + 561))) and v22(v96.UseWeapon)) then
										return "Fyralath The Dreamrender used";
									end
								end
							end
							if (((62 + 1992) >= (4401 - 2980)) and v38 and v94.HeroicThrow:IsCastable() and not v13:IsInRange(10 + 15)) then
								if (((1171 - (341 + 138)) < (826 + 2232)) and v22(v94.HeroicThrow, not v13:IsSpellInRange(v94.HeroicThrow))) then
									return "heroic_throw main";
								end
							end
							v189 = 3 - 1;
						end
					end
				end
				break;
			end
			if ((v127 == (326 - (89 + 237))) or ((10467 - 7213) == (3484 - 1829))) then
				v27 = v107();
				if (v27 or ((2177 - (581 + 300)) == (6130 - (855 + 365)))) then
					return v27;
				end
				v127 = 2 - 1;
			end
		end
	end
	local function v114()
		v31 = EpicSettings.Settings['useWeapon'];
		v33 = EpicSettings.Settings['useBattleShout'];
		v34 = EpicSettings.Settings['useCharge'];
		v35 = EpicSettings.Settings['useDemoralizingShout'];
		v36 = EpicSettings.Settings['useDevastate'];
		v37 = EpicSettings.Settings['useExecute'];
		v38 = EpicSettings.Settings['useHeroicThrow'];
		v40 = EpicSettings.Settings['useRevenge'];
		v42 = EpicSettings.Settings['useShieldSlam'];
		v43 = EpicSettings.Settings['useShockwave'];
		v45 = EpicSettings.Settings['useThunderClap'];
		v47 = EpicSettings.Settings['useWreckingThrow'];
		v32 = EpicSettings.Settings['useAvatar'];
		v39 = EpicSettings.Settings['useRavager'];
		v41 = EpicSettings.Settings['useShieldCharge'];
		v44 = EpicSettings.Settings['useChampionsSpear'];
		v46 = EpicSettings.Settings['useThunderousRoar'];
		v50 = EpicSettings.Settings['avatarWithCD'];
		v51 = EpicSettings.Settings['ravagerWithCD'];
		v52 = EpicSettings.Settings['shieldChargeWithCD'];
		v53 = EpicSettings.Settings['championsSpearWithCD'];
		v54 = EpicSettings.Settings['thunderousRoarWithCD'];
	end
	local function v115()
		local v150 = 0 + 0;
		while true do
			if (((4603 - (1030 + 205)) == (3162 + 206)) and ((0 + 0) == v150)) then
				v57 = EpicSettings.Settings['usePummel'];
				v58 = EpicSettings.Settings['useStormBolt'];
				v59 = EpicSettings.Settings['useIntimidatingShout'];
				v60 = EpicSettings.Settings['useBitterImmunity'];
				v150 = 287 - (156 + 130);
			end
			if (((6005 - 3362) < (6429 - 2614)) and (v150 == (7 - 3))) then
				v76 = EpicSettings.Settings['rallyingCryGroup'] or (0 + 0);
				v75 = EpicSettings.Settings['rallyingCryHP'] or (0 + 0);
				v72 = EpicSettings.Settings['shieldBlockHP'] or (69 - (10 + 59));
				v71 = EpicSettings.Settings['shieldWallHP'] or (0 + 0);
				v150 = 24 - 19;
			end
			if (((3076 - (671 + 492)) > (393 + 100)) and ((1218 - (369 + 846)) == v150)) then
				v70 = EpicSettings.Settings['bitterImmunityHP'] or (0 + 0);
				v74 = EpicSettings.Settings['ignorePainHP'] or (0 + 0);
				v77 = EpicSettings.Settings['interveneHP'] or (1945 - (1036 + 909));
				v73 = EpicSettings.Settings['lastStandHP'] or (0 + 0);
				v150 = 6 - 2;
			end
			if (((4958 - (11 + 192)) > (1733 + 1695)) and ((177 - (135 + 40)) == v150)) then
				v62 = EpicSettings.Settings['useShieldBlock'];
				v61 = EpicSettings.Settings['useShieldWall'];
				v69 = EpicSettings.Settings['useVictoryRush'];
				v92 = EpicSettings.Settings['useChangeStance'];
				v150 = 6 - 3;
			end
			if (((833 + 548) <= (5218 - 2849)) and ((1 - 0) == v150)) then
				v64 = EpicSettings.Settings['useIgnorePain'];
				v66 = EpicSettings.Settings['useIntervene'];
				v63 = EpicSettings.Settings['useLastStand'];
				v65 = EpicSettings.Settings['useRallyingCry'];
				v150 = 178 - (50 + 126);
			end
			if ((v150 == (13 - 8)) or ((1072 + 3771) == (5497 - (1233 + 180)))) then
				v81 = EpicSettings.Settings['victoryRushHP'] or (969 - (522 + 447));
				v78 = EpicSettings.Settings['defensiveStanceHP'] or (1421 - (107 + 1314));
				v82 = EpicSettings.Settings['ravagerSetting'] or "";
				v83 = EpicSettings.Settings['spearSetting'] or "";
				break;
			end
		end
	end
	local function v116()
		local v151 = 0 + 0;
		while true do
			if (((14226 - 9557) > (155 + 208)) and (v151 == (7 - 3))) then
				v85 = EpicSettings.Settings['HealingPotionName'] or "";
				v84 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v151 == (11 - 8)) or ((3787 - (716 + 1194)) >= (54 + 3084))) then
				v68 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v80 = EpicSettings.Settings['healingPotionHP'] or (503 - (74 + 429));
				v151 = 7 - 3;
			end
			if (((2351 + 2391) >= (8300 - 4674)) and ((2 + 0) == v151)) then
				v55 = EpicSettings.Settings['trinketsWithCD'];
				v56 = EpicSettings.Settings['racialsWithCD'];
				v67 = EpicSettings.Settings['useHealthstone'];
				v151 = 8 - 5;
			end
			if ((v151 == (2 - 1)) or ((4973 - (279 + 154)) == (1694 - (454 + 324)))) then
				v88 = EpicSettings.Settings['InterruptThreshold'];
				v48 = EpicSettings.Settings['useTrinkets'];
				v49 = EpicSettings.Settings['useRacials'];
				v151 = 2 + 0;
			end
			if (((17 - (12 + 5)) == v151) or ((624 + 532) > (11070 - 6725))) then
				v89 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v86 = EpicSettings.Settings['InterruptWithStun'];
				v87 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v151 = 1094 - (277 + 816);
			end
		end
	end
	local function v117()
		v115();
		v114();
		v116();
		v28 = EpicSettings.Toggles['ooc'];
		v29 = EpicSettings.Toggles['aoe'];
		v30 = EpicSettings.Toggles['cds'];
		if (((9558 - 7321) < (5432 - (1058 + 125))) and v12:IsDeadOrGhost()) then
			return v27;
		end
		if (v29 or ((504 + 2179) < (998 - (815 + 160)))) then
			v99 = v12:GetEnemiesInMeleeRange(34 - 26);
			v100 = #v99;
		else
			v100 = 2 - 1;
		end
		v98 = v13:IsInMeleeRange(2 + 6);
		if (((2037 - 1340) <= (2724 - (41 + 1857))) and (v93.TargetIsValid() or v12:AffectingCombat())) then
			v90 = v9.BossFightRemains(nil, true);
			v91 = v90;
			if (((2998 - (1222 + 671)) <= (3039 - 1863)) and (v91 == (15970 - 4859))) then
				v91 = v9.FightRemains(v99, false);
			end
		end
		if (((4561 - (229 + 953)) <= (5586 - (1111 + 663))) and not v12:IsChanneling()) then
			if (v12:AffectingCombat() or ((2367 - (874 + 705)) >= (227 + 1389))) then
				local v185 = 0 + 0;
				while true do
					if (((3853 - 1999) <= (96 + 3283)) and (v185 == (679 - (642 + 37)))) then
						v27 = v113();
						if (((1038 + 3511) == (728 + 3821)) and v27) then
							return v27;
						end
						break;
					end
				end
			else
				local v186 = 0 - 0;
				while true do
					if ((v186 == (454 - (233 + 221))) or ((6987 - 3965) >= (2662 + 362))) then
						v27 = v112();
						if (((6361 - (718 + 823)) > (1384 + 814)) and v27) then
							return v27;
						end
						break;
					end
				end
			end
		end
	end
	local function v118()
		v18.Print("Protection Warrior by Epic. Supported by xKaneto.");
	end
	v18.SetAPL(878 - (266 + 539), v117, v118);
end;
return v0["Epix_Warrior_Protection.lua"]();

