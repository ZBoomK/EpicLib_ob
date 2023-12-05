local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((3208 - 1744) <= (6161 - (214 + 1570))) and (v5 == (1455 - (990 + 465)))) then
			v6 = v0[v4];
			if (((1109 + 1580) < (2056 + 2667)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((16277 - 12141) >= (4123 - (1668 + 58))) and (v5 == (627 - (512 + 114)))) then
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
	local v32 = false;
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
	local v93 = 28967 - 17856;
	local v94 = 22970 - 11859;
	local v95;
	local v96 = v19.Commons.Everyone;
	local v97 = v17.Warrior.Protection;
	local v98 = v18.Warrior.Protection;
	local v99 = v22.Warrior.Protection;
	local v100 = {};
	local v101;
	local v102;
	local v103;
	local function v104()
		local v122 = UnitGetTotalAbsorbs(v14);
		if ((v122 > (0 - 0)) or ((2017 + 2317) == (795 + 3450))) then
			return true;
		else
			return false;
		end
	end
	local function v105()
		return v13:IsTankingAoE(14 + 2) or v13:IsTanking(v14) or v14:IsDummy();
	end
	local function v106()
		if (v13:BuffUp(v97.IgnorePain) or ((14422 - 10146) <= (5025 - (109 + 1885)))) then
			local v157 = 1469 - (1269 + 200);
			local v158;
			local v159;
			local v160;
			while true do
				if ((v157 == (0 - 0)) or ((5597 - (98 + 717)) <= (2025 - (802 + 24)))) then
					v158 = v13:AttackPowerDamageMod() * (5.5 - 2) * ((1 - 0) + (v13:VersatilityDmgPct() / (15 + 85)));
					v159 = v13:AuraInfo(v97.IgnorePain, nil, true);
					v157 = 1 + 0;
				end
				if ((v157 == (1 + 0)) or ((1050 + 3814) < (5291 - 3389))) then
					v160 = v159.points[3 - 2];
					return v160 < v158;
				end
			end
		else
			return true;
		end
	end
	local function v107()
		if (((1731 + 3108) >= (1507 + 2193)) and v13:BuffUp(v97.IgnorePain)) then
			local v161 = v13:BuffInfo(v97.IgnorePain, nil, true);
			return v161.points[1 + 0];
		else
			return 0 + 0;
		end
	end
	local function v108()
		return v105() and v97.ShieldBlock:IsReady() and (((v13:BuffRemains(v97.ShieldBlockBuff) <= (9 + 9)) and v97.EnduringDefenses:IsAvailable()) or (v13:BuffRemains(v97.ShieldBlockBuff) <= (1445 - (797 + 636))));
	end
	local function v109(v123)
		local v124 = 0 - 0;
		local v125;
		local v126;
		local v127;
		while true do
			if ((v124 == (1621 - (1427 + 192))) or ((373 + 702) > (4452 - 2534))) then
				if (((356 + 40) <= (1724 + 2080)) and v127 and (((v13:Rage() + v123) >= v125) or v97.DemoralizingShout:IsReady())) then
					v126 = true;
				end
				if (v126 or ((4495 - (192 + 134)) == (3463 - (316 + 960)))) then
					if (((783 + 623) == (1086 + 320)) and v105() and v106()) then
						if (((1416 + 115) < (16327 - 12056)) and v23(v97.IgnorePain, nil, nil, true)) then
							return "ignore_pain rage capped";
						end
					elseif (((1186 - (83 + 468)) == (2441 - (1202 + 604))) and v23(v97.Revenge, not v101)) then
						return "revenge rage capped";
					end
				end
				break;
			end
			if (((15745 - 12372) <= (5917 - 2361)) and (v124 == (0 - 0))) then
				v125 = 405 - (45 + 280);
				if ((v125 < (34 + 1)) or (v13:Rage() < (31 + 4)) or ((1202 + 2089) < (1816 + 1464))) then
					return false;
				end
				v124 = 1 + 0;
			end
			if (((8121 - 3735) >= (2784 - (340 + 1571))) and (v124 == (1 + 0))) then
				v126 = false;
				v127 = (v13:Rage() >= (1807 - (1733 + 39))) and not v108();
				v124 = 5 - 3;
			end
		end
	end
	local function v110()
		local v128 = 1034 - (125 + 909);
		while true do
			if (((2869 - (1096 + 852)) <= (495 + 607)) and (v128 == (0 - 0))) then
				if (((4565 + 141) >= (1475 - (409 + 103))) and v97.BitterImmunity:IsReady() and v61 and (v13:HealthPercentage() <= v72)) then
					if (v23(v97.BitterImmunity) or ((1196 - (46 + 190)) <= (971 - (51 + 44)))) then
						return "bitter_immunity defensive";
					end
				end
				if ((v97.LastStand:IsCastable() and v64 and ((v13:HealthPercentage() <= v75) or v13:ActiveMitigationNeeded())) or ((583 + 1483) == (2249 - (1114 + 203)))) then
					if (((5551 - (228 + 498)) < (1050 + 3793)) and v23(v97.LastStand)) then
						return "last_stand defensive";
					end
				end
				v128 = 1 + 0;
			end
			if (((664 - (174 + 489)) == v128) or ((10100 - 6223) >= (6442 - (830 + 1075)))) then
				if ((v97.IgnorePain:IsReady() and v65 and (v13:HealthPercentage() <= v76) and v106()) or ((4839 - (303 + 221)) < (2995 - (231 + 1038)))) then
					if (v23(v97.IgnorePain, nil, nil, true) or ((3066 + 613) < (1787 - (171 + 991)))) then
						return "ignore_pain defensive";
					end
				end
				if ((v97.RallyingCry:IsReady() and v66 and v13:BuffDown(v97.AspectsFavorBuff) and v13:BuffDown(v97.RallyingCry) and (((v13:HealthPercentage() <= v77) and v96.IsSoloMode()) or v96.AreUnitsBelowHealthPercentage(v77, v78))) or ((19060 - 14435) < (1696 - 1064))) then
					if (v23(v97.RallyingCry) or ((206 - 123) > (1425 + 355))) then
						return "rallying_cry defensive";
					end
				end
				v128 = 6 - 4;
			end
			if (((1574 - 1028) <= (1735 - 658)) and (v128 == (6 - 4))) then
				if ((v97.Intervene:IsReady() and v67 and (v16:HealthPercentage() <= v79) and (v16:UnitName() ~= v13:UnitName())) or ((2244 - (111 + 1137)) > (4459 - (91 + 67)))) then
					if (((12113 - 8043) > (172 + 515)) and v23(v99.InterveneFocus)) then
						return "intervene defensive";
					end
				end
				if ((v97.ShieldWall:IsCastable() and v62 and v13:BuffDown(v97.ShieldWallBuff) and ((v13:HealthPercentage() <= v73) or v13:ActiveMitigationNeeded())) or ((1179 - (423 + 100)) >= (24 + 3306))) then
					if (v23(v97.ShieldWall) or ((6899 - 4407) <= (175 + 160))) then
						return "shield_wall defensive";
					end
				end
				v128 = 774 - (326 + 445);
			end
			if (((18860 - 14538) >= (5707 - 3145)) and ((6 - 3) == v128)) then
				if ((v98.Healthstone:IsReady() and v69 and (v13:HealthPercentage() <= v81)) or ((4348 - (530 + 181)) >= (4651 - (614 + 267)))) then
					if (v23(v99.Healthstone) or ((2411 - (19 + 13)) > (7450 - 2872))) then
						return "healthstone defensive 3";
					end
				end
				if ((v70 and (v13:HealthPercentage() <= v82)) or ((1124 - 641) > (2122 - 1379))) then
					if (((638 + 1816) > (1016 - 438)) and (v88 == "Refreshing Healing Potion")) then
						if (((1928 - 998) < (6270 - (1293 + 519))) and v98.RefreshingHealingPotion:IsReady()) then
							if (((1350 - 688) <= (2537 - 1565)) and v23(v99.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((8356 - 3986) == (18843 - 14473)) and (v88 == "Dreamwalker's Healing Potion")) then
						if (v98.DreamwalkersHealingPotion:IsReady() or ((11217 - 6455) <= (457 + 404))) then
							if (v23(v99.RefreshingHealingPotion) or ((289 + 1123) == (9907 - 5643))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v111()
		local v129 = 0 + 0;
		while true do
			if ((v129 == (0 + 0)) or ((1980 + 1188) < (3249 - (709 + 387)))) then
				v28 = v96.HandleTopTrinket(v100, v31, 1898 - (673 + 1185), nil);
				if (v28 or ((14430 - 9454) < (4276 - 2944))) then
					return v28;
				end
				v129 = 1 - 0;
			end
			if (((3311 + 1317) == (3459 + 1169)) and ((1 - 0) == v129)) then
				v28 = v96.HandleBottomTrinket(v100, v31, 10 + 30, nil);
				if (v28 or ((107 - 53) == (775 - 380))) then
					return v28;
				end
				break;
			end
		end
	end
	local function v112()
		if (((1962 - (446 + 1434)) == (1365 - (1040 + 243))) and v14:IsInMeleeRange(23 - 15)) then
			if ((v97.ThunderClap:IsCastable() and v46) or ((2428 - (559 + 1288)) < (2213 - (609 + 1322)))) then
				if (v23(v97.ThunderClap) or ((5063 - (13 + 441)) < (9323 - 6828))) then
					return "thunder_clap precombat";
				end
			end
		elseif (((3017 - 1865) == (5737 - 4585)) and v35 and v97.Charge:IsCastable() and not v14:IsInRange(1 + 7)) then
			if (((6885 - 4989) <= (1216 + 2206)) and v23(v97.Charge, not v14:IsSpellInRange(v97.Charge))) then
				return "charge precombat";
			end
		end
	end
	local function v113()
		if ((v97.ThunderClap:IsCastable() and v46 and (v14:DebuffRemains(v97.RendDebuff) <= (1 + 0))) or ((2937 - 1947) > (887 + 733))) then
			local v162 = 0 - 0;
			while true do
				if ((v162 == (0 + 0)) or ((488 + 389) > (3374 + 1321))) then
					v109(5 + 0);
					if (((2633 + 58) >= (2284 - (153 + 280))) and v23(v97.ThunderClap, not v14:IsInMeleeRange(23 - 15))) then
						return "thunder_clap aoe 2";
					end
					break;
				end
			end
		end
		if ((v97.ShieldSlam:IsCastable() and v43 and ((v13:HasTier(27 + 3, 1 + 1) and (v103 <= (4 + 3))) or v13:BuffUp(v97.EarthenTenacityBuff))) or ((2709 + 276) >= (3519 + 1337))) then
			if (((6510 - 2234) >= (739 + 456)) and v23(v97.ShieldSlam, not v101)) then
				return "shield_slam aoe 3";
			end
		end
		if (((3899 - (89 + 578)) <= (3351 + 1339)) and v97.ThunderClap:IsCastable() and v46 and v13:BuffUp(v97.ViolentOutburstBuff) and (v103 > (10 - 5)) and v13:BuffUp(v97.AvatarBuff) and v97.UnstoppableForce:IsAvailable()) then
			v109(1054 - (572 + 477));
			if (v23(v97.ThunderClap, not v14:IsInMeleeRange(2 + 6)) or ((538 + 358) >= (376 + 2770))) then
				return "thunder_clap aoe 4";
			end
		end
		if (((3147 - (84 + 2)) >= (4874 - 1916)) and v97.Revenge:IsReady() and v41 and (v13:Rage() >= (51 + 19)) and v97.SeismicReverberation:IsAvailable() and (v103 >= (845 - (497 + 345)))) then
			if (((82 + 3105) >= (109 + 535)) and v23(v97.Revenge, not v101)) then
				return "revenge aoe 6";
			end
		end
		if (((1977 - (605 + 728)) <= (503 + 201)) and v97.ShieldSlam:IsCastable() and v43 and ((v13:Rage() <= (133 - 73)) or (v13:BuffUp(v97.ViolentOutburstBuff) and (v103 <= (1 + 6))))) then
			local v163 = 0 - 0;
			while true do
				if (((864 + 94) > (2623 - 1676)) and (v163 == (0 + 0))) then
					v109(509 - (457 + 32));
					if (((1906 + 2586) >= (4056 - (832 + 570))) and v23(v97.ShieldSlam, not v101)) then
						return "shield_slam aoe 8";
					end
					break;
				end
			end
		end
		if (((3243 + 199) >= (392 + 1111)) and v97.ThunderClap:IsCastable() and v46) then
			local v164 = 0 - 0;
			while true do
				if ((v164 == (0 + 0)) or ((3966 - (588 + 208)) <= (3945 - 2481))) then
					v109(1805 - (884 + 916));
					if (v23(v97.ThunderClap, not v14:IsInMeleeRange(16 - 8)) or ((2782 + 2015) == (5041 - (232 + 421)))) then
						return "thunder_clap aoe 10";
					end
					break;
				end
			end
		end
		if (((2440 - (1569 + 320)) <= (168 + 513)) and v97.Revenge:IsReady() and v41 and ((v13:Rage() >= (6 + 24)) or ((v13:Rage() >= (134 - 94)) and v97.BarbaricTraining:IsAvailable()))) then
			if (((3882 - (316 + 289)) > (1065 - 658)) and v23(v97.Revenge, not v101)) then
				return "revenge aoe 12";
			end
		end
	end
	local function v114()
		local v130 = 0 + 0;
		while true do
			if (((6148 - (666 + 787)) >= (1840 - (360 + 65))) and (v130 == (2 + 0))) then
				if ((v97.Revenge:IsReady() and v41 and (v14:HealthPercentage() > (274 - (79 + 175)))) or ((5064 - 1852) <= (737 + 207))) then
					if (v23(v97.Revenge, not v101) or ((9489 - 6393) <= (3462 - 1664))) then
						return "revenge generic 18";
					end
				end
				if (((4436 - (503 + 396)) == (3718 - (92 + 89))) and v97.ThunderClap:IsCastable() and v46 and ((v103 >= (1 - 0)) or (v97.ShieldSlam:CooldownDown() and v13:BuffUp(v97.ViolentOutburstBuff)))) then
					local v192 = 0 + 0;
					while true do
						if (((2271 + 1566) >= (6148 - 4578)) and (v192 == (0 + 0))) then
							v109(11 - 6);
							if (v23(v97.ThunderClap, not v14:IsInMeleeRange(7 + 1)) or ((1410 + 1540) == (11609 - 7797))) then
								return "thunder_clap generic 20";
							end
							break;
						end
					end
				end
				if (((590 + 4133) >= (3534 - 1216)) and v97.Devastate:IsCastable() and v37) then
					if (v23(v97.Devastate, not v101) or ((3271 - (485 + 759)) > (6599 - 3747))) then
						return "devastate generic 22";
					end
				end
				break;
			end
			if ((v130 == (1190 - (442 + 747))) or ((2271 - (832 + 303)) > (5263 - (88 + 858)))) then
				if (((1448 + 3300) == (3930 + 818)) and v97.Execute:IsReady() and v38 and (v103 == (1 + 0)) and (v13:Rage() >= (839 - (766 + 23)))) then
					if (((18443 - 14707) <= (6482 - 1742)) and v23(v97.Execute, not v101)) then
						return "execute generic 10";
					end
				end
				if ((v97.ThunderClap:IsCastable() and v46 and ((v103 > (2 - 1)) or (v97.ShieldSlam:CooldownDown() and not v13:BuffUp(v97.ViolentOutburstBuff)))) or ((11505 - 8115) <= (4133 - (1036 + 37)))) then
					v109(4 + 1);
					if (v23(v97.ThunderClap, not v14:IsInMeleeRange(15 - 7)) or ((786 + 213) > (4173 - (641 + 839)))) then
						return "thunder_clap generic 12";
					end
				end
				if (((1376 - (910 + 3)) < (1532 - 931)) and v97.Revenge:IsReady() and v41 and (((v13:Rage() >= (1744 - (1466 + 218))) and (v14:HealthPercentage() > (10 + 10))) or (v13:BuffUp(v97.RevengeBuff) and (v14:HealthPercentage() <= (1168 - (556 + 592))) and (v13:Rage() <= (7 + 11)) and v97.ShieldSlam:CooldownDown()) or (v13:BuffUp(v97.RevengeBuff) and (v14:HealthPercentage() > (828 - (329 + 479)))) or ((((v13:Rage() >= (914 - (174 + 680))) and (v14:HealthPercentage() > (120 - 85))) or (v13:BuffUp(v97.RevengeBuff) and (v14:HealthPercentage() <= (72 - 37)) and (v13:Rage() <= (13 + 5)) and v97.ShieldSlam:CooldownDown()) or (v13:BuffUp(v97.RevengeBuff) and (v14:HealthPercentage() > (774 - (396 + 343))))) and v97.Massacre:IsAvailable()))) then
					if (v23(v97.Revenge, not v101) or ((194 + 1989) < (2164 - (29 + 1448)))) then
						return "revenge generic 14";
					end
				end
				if (((5938 - (135 + 1254)) == (17136 - 12587)) and v97.Execute:IsReady() and v38 and (v103 == (4 - 3))) then
					if (((3114 + 1558) == (6199 - (389 + 1138))) and v23(v97.Execute, not v101)) then
						return "execute generic 16";
					end
				end
				v130 = 576 - (102 + 472);
			end
			if ((v130 == (0 + 0)) or ((2035 + 1633) < (369 + 26))) then
				if ((v97.ShieldSlam:IsCastable() and v43) or ((5711 - (320 + 1225)) == (809 - 354))) then
					v109(13 + 7);
					if (v23(v97.ShieldSlam, not v101) or ((5913 - (157 + 1307)) == (4522 - (821 + 1038)))) then
						return "shield_slam generic 2";
					end
				end
				if ((v97.ThunderClap:IsCastable() and v46 and (v14:DebuffRemains(v97.RendDebuff) <= (2 - 1)) and v13:BuffDown(v97.ViolentOutburstBuff)) or ((468 + 3809) < (5308 - 2319))) then
					v109(2 + 3);
					if (v23(v97.ThunderClap, not v14:IsInMeleeRange(19 - 11)) or ((1896 - (834 + 192)) >= (264 + 3885))) then
						return "thunder_clap generic 4";
					end
				end
				if (((568 + 1644) < (69 + 3114)) and v97.Execute:IsReady() and v38 and v13:BuffUp(v97.SuddenDeathBuff) and v97.SuddenDeath:IsAvailable()) then
					if (((7197 - 2551) > (3296 - (300 + 4))) and v23(v97.Execute, not v101)) then
						return "execute generic 6";
					end
				end
				if (((383 + 1051) < (8130 - 5024)) and v97.Execute:IsReady() and v38 and (v103 == (363 - (112 + 250))) and (v97.Massacre:IsAvailable() or v97.Juggernaut:IsAvailable()) and (v13:Rage() >= (20 + 30))) then
					if (((1968 - 1182) < (1732 + 1291)) and v23(v97.Execute, not v101)) then
						return "execute generic 6";
					end
				end
				v130 = 1 + 0;
			end
		end
	end
	local function v115()
		if (not v13:AffectingCombat() or ((1827 + 615) < (37 + 37))) then
			if (((3369 + 1166) == (5949 - (1001 + 413))) and v97.BattleShout:IsCastable() and v34 and (v13:BuffDown(v97.BattleShoutBuff, true) or v96.GroupBuffMissing(v97.BattleShoutBuff))) then
				if (v23(v97.BattleShout) or ((6709 - 3700) <= (2987 - (244 + 638)))) then
					return "battle_shout precombat";
				end
			end
			if (((2523 - (627 + 66)) < (10931 - 7262)) and v95 and v97.BattleStance:IsCastable() and not v13:BuffUp(v97.BattleStance)) then
				if (v23(v97.BattleStance) or ((2032 - (512 + 90)) >= (5518 - (1665 + 241)))) then
					return "battle_stance precombat";
				end
			end
		end
		if (((3400 - (373 + 344)) >= (1110 + 1350)) and v96.TargetIsValid() and v29) then
			if (not v13:AffectingCombat() or ((478 + 1326) >= (8638 - 5363))) then
				v28 = v112();
				if (v28 or ((2397 - 980) > (4728 - (35 + 1064)))) then
					return v28;
				end
			end
		end
	end
	local function v116()
		local v131 = 0 + 0;
		while true do
			if (((10259 - 5464) > (2 + 400)) and (v131 == (1237 - (298 + 938)))) then
				if (((6072 - (233 + 1026)) > (5231 - (636 + 1030))) and v87) then
					local v193 = 0 + 0;
					while true do
						if (((3822 + 90) == (1163 + 2749)) and (v193 == (0 + 0))) then
							v28 = v96.HandleIncorporeal(v97.StormBolt, v99.StormBoltMouseover, 241 - (55 + 166), true);
							if (((547 + 2274) <= (486 + 4338)) and v28) then
								return v28;
							end
							v193 = 3 - 2;
						end
						if (((2035 - (36 + 261)) <= (3838 - 1643)) and (v193 == (1369 - (34 + 1334)))) then
							v28 = v96.HandleIncorporeal(v97.IntimidatingShout, v99.IntimidatingShoutMouseover, 4 + 4, true);
							if (((32 + 9) <= (4301 - (1035 + 248))) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (((2166 - (20 + 1)) <= (2139 + 1965)) and v96.TargetIsValid()) then
					local v194 = 319 - (134 + 185);
					local v195;
					while true do
						if (((3822 - (549 + 584)) < (5530 - (314 + 371))) and (v194 == (6 - 4))) then
							if ((v97.WreckingThrow:IsCastable() and v48 and v14:AffectingCombat() and v104()) or ((3290 - (478 + 490)) > (1389 + 1233))) then
								if (v23(v97.WreckingThrow, not v14:IsInRange(1202 - (786 + 386))) or ((14685 - 10151) == (3461 - (1055 + 324)))) then
									return "wrecking_throw main";
								end
							end
							if (((v92 < v94) and v33 and ((v51 and v31) or not v51) and v97.Avatar:IsCastable()) or ((2911 - (1093 + 247)) > (1660 + 207))) then
								if (v23(v97.Avatar) or ((280 + 2374) >= (11894 - 8898))) then
									return "avatar main 2";
								end
							end
							if (((13500 - 9522) > (5986 - 3882)) and (v92 < v94) and v50 and ((v57 and v31) or not v57)) then
								if (((7526 - 4531) > (549 + 992)) and v97.BloodFury:IsCastable()) then
									if (((12516 - 9267) > (3284 - 2331)) and v23(v97.BloodFury)) then
										return "blood_fury main 4";
									end
								end
								if (v97.Berserking:IsCastable() or ((2468 + 805) > (11694 - 7121))) then
									if (v23(v97.Berserking) or ((3839 - (364 + 324)) < (3519 - 2235))) then
										return "berserking main 6";
									end
								end
								if (v97.ArcaneTorrent:IsCastable() or ((4439 - 2589) == (507 + 1022))) then
									if (((3435 - 2614) < (3399 - 1276)) and v23(v97.ArcaneTorrent)) then
										return "arcane_torrent main 8";
									end
								end
								if (((2739 - 1837) < (3593 - (1249 + 19))) and v97.LightsJudgment:IsCastable()) then
									if (((775 + 83) <= (11529 - 8567)) and v23(v97.LightsJudgment)) then
										return "lights_judgment main 10";
									end
								end
								if (v97.Fireblood:IsCastable() or ((5032 - (686 + 400)) < (1011 + 277))) then
									if (v23(v97.Fireblood) or ((3471 - (73 + 156)) == (3 + 564))) then
										return "fireblood main 12";
									end
								end
								if (v97.AncestralCall:IsCastable() or ((1658 - (721 + 90)) >= (15 + 1248))) then
									if (v23(v97.AncestralCall) or ((7315 - 5062) == (2321 - (224 + 246)))) then
										return "ancestral_call main 14";
									end
								end
								if (v97.BagofTricks:IsCastable() or ((3380 - 1293) > (4367 - 1995))) then
									if (v23(v97.BagofTricks) or ((807 + 3638) < (99 + 4050))) then
										return "ancestral_call main 16";
									end
								end
							end
							v194 = 3 + 0;
						end
						if ((v194 == (11 - 5)) or ((6049 - 4231) == (598 - (203 + 310)))) then
							if (((2623 - (1238 + 755)) < (149 + 1978)) and (v92 < v94) and v47 and ((v55 and v31) or not v55) and v97.ThunderousRoar:IsCastable()) then
								if (v23(v97.ThunderousRoar, not v14:IsInMeleeRange(1542 - (709 + 825))) or ((3570 - 1632) == (3661 - 1147))) then
									return "thunderous_roar main 30";
								end
							end
							if (((5119 - (196 + 668)) >= (217 - 162)) and v97.ShieldSlam:IsCastable() and v43 and v13:BuffUp(v97.FervidBuff)) then
								if (((6211 - 3212) > (1989 - (171 + 662))) and v23(v97.ShieldSlam, not v101)) then
									return "shield_slam main 31";
								end
							end
							if (((2443 - (4 + 89)) > (4048 - 2893)) and ((v97.Shockwave:IsCastable() and v44 and v13:BuffUp(v97.AvatarBuff) and v97.UnstoppableForce:IsAvailable() and not v97.RumblingEarth:IsAvailable()) or (v97.SonicBoom:IsAvailable() and v97.RumblingEarth:IsAvailable() and (v103 >= (2 + 1)) and v14:IsCasting()))) then
								local v199 = 0 - 0;
								while true do
									if (((1580 + 2449) <= (6339 - (35 + 1451))) and (v199 == (1453 - (28 + 1425)))) then
										v109(2003 - (941 + 1052));
										if (v23(v97.Shockwave, not v14:IsInMeleeRange(8 + 0)) or ((2030 - (822 + 692)) > (4902 - 1468))) then
											return "shockwave main 32";
										end
										break;
									end
								end
							end
							v194 = 4 + 3;
						end
						if (((4343 - (45 + 252)) >= (3001 + 32)) and (v194 == (3 + 5))) then
							v28 = v114();
							if (v28 or ((6617 - 3898) <= (1880 - (114 + 319)))) then
								return v28;
							end
							if (v19.CastAnnotated(v97.Pool, false, "WAIT") or ((5935 - 1801) < (5030 - 1104))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((v194 == (2 + 1)) or ((243 - 79) >= (5835 - 3050))) then
							v195 = v96.HandleDPSPotion(v14:BuffUp(v97.AvatarBuff));
							if (v195 or ((2488 - (556 + 1407)) == (3315 - (741 + 465)))) then
								return v195;
							end
							if (((498 - (170 + 295)) == (18 + 15)) and v97.IgnorePain:IsReady() and v65 and v106() and (v14:HealthPercentage() >= (19 + 1)) and (((v13:RageDeficit() <= (36 - 21)) and v97.ShieldSlam:CooldownUp()) or ((v13:RageDeficit() <= (34 + 6)) and v97.ShieldCharge:CooldownUp() and v97.ChampionsBulwark:IsAvailable()) or ((v13:RageDeficit() <= (13 + 7)) and v97.ShieldCharge:CooldownUp()) or ((v13:RageDeficit() <= (17 + 13)) and v97.DemoralizingShout:CooldownUp() and v97.BoomingVoice:IsAvailable()) or ((v13:RageDeficit() <= (1250 - (957 + 273))) and v97.Avatar:CooldownUp()) or ((v13:RageDeficit() <= (13 + 32)) and v97.DemoralizingShout:CooldownUp() and v97.BoomingVoice:IsAvailable() and v13:BuffUp(v97.LastStandBuff) and v97.UnnervingFocus:IsAvailable()) or ((v13:RageDeficit() <= (13 + 17)) and v97.Avatar:CooldownUp() and v13:BuffUp(v97.LastStandBuff) and v97.UnnervingFocus:IsAvailable()) or (v13:RageDeficit() <= (76 - 56)) or ((v13:RageDeficit() <= (105 - 65)) and v97.ShieldSlam:CooldownUp() and v13:BuffUp(v97.ViolentOutburstBuff) and v97.HeavyRepercussions:IsAvailable() and v97.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (167 - 112)) and v97.ShieldSlam:CooldownUp() and v13:BuffUp(v97.ViolentOutburstBuff) and v13:BuffUp(v97.LastStandBuff) and v97.UnnervingFocus:IsAvailable() and v97.HeavyRepercussions:IsAvailable() and v97.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (84 - 67)) and v97.ShieldSlam:CooldownUp() and v97.HeavyRepercussions:IsAvailable()) or ((v13:RageDeficit() <= (1798 - (389 + 1391))) and v97.ShieldSlam:CooldownUp() and v97.ImpenetrableWall:IsAvailable()))) then
								if (((1917 + 1137) <= (418 + 3597)) and v23(v97.IgnorePain, nil, nil, true)) then
									return "ignore_pain main 20";
								end
							end
							v194 = 8 - 4;
						end
						if (((2822 - (783 + 168)) < (11350 - 7968)) and (v194 == (1 + 0))) then
							if (((1604 - (309 + 2)) <= (6651 - 4485)) and v35 and v97.Charge:IsCastable() and not v101) then
								if (v23(v97.Charge, not v14:IsSpellInRange(v97.Charge)) or ((3791 - (1090 + 122)) < (40 + 83))) then
									return "charge main 34";
								end
							end
							if ((v92 < v94) or ((2841 - 1995) >= (1621 + 747))) then
								if ((v49 and ((v31 and v56) or not v56)) or ((5130 - (628 + 490)) <= (603 + 2755))) then
									local v204 = 0 - 0;
									while true do
										if (((6827 - 5333) <= (3779 - (431 + 343))) and ((0 - 0) == v204)) then
											v28 = v111();
											if (v28 or ((8999 - 5888) == (1686 + 448))) then
												return v28;
											end
											break;
										end
									end
								end
							end
							if (((302 + 2053) == (4050 - (556 + 1139))) and v39 and v97.HeroicThrow:IsCastable() and not v14:IsInRange(45 - (6 + 9))) then
								if (v23(v97.HeroicThrow, not v14:IsInRange(6 + 24)) or ((302 + 286) <= (601 - (28 + 141)))) then
									return "heroic_throw main";
								end
							end
							v194 = 1 + 1;
						end
						if (((5920 - 1123) >= (2759 + 1136)) and (v194 == (1317 - (486 + 831)))) then
							if (((9308 - 5731) == (12593 - 9016)) and v95 and (v13:HealthPercentage() <= v80)) then
								if (((717 + 3077) > (11676 - 7983)) and v97.DefensiveStance:IsCastable() and not v13:BuffUp(v97.DefensiveStance)) then
									if (v23(v97.DefensiveStance) or ((2538 - (668 + 595)) == (3690 + 410))) then
										return "defensive_stance while tanking";
									end
								end
							end
							if ((v95 and (v13:HealthPercentage() > v80)) or ((321 + 1270) >= (9763 - 6183))) then
								if (((1273 - (23 + 267)) <= (3752 - (1129 + 815))) and v97.BattleStance:IsCastable() and not v13:BuffUp(v97.BattleStance)) then
									if (v23(v97.BattleStance) or ((2537 - (371 + 16)) <= (2947 - (1326 + 424)))) then
										return "battle_stance while not tanking";
									end
								end
							end
							if (((7137 - 3368) >= (4286 - 3113)) and v42 and ((v53 and v31) or not v53) and (v92 < v94) and v97.ShieldCharge:IsCastable() and not v101) then
								if (((1603 - (88 + 30)) == (2256 - (720 + 51))) and v23(v97.ShieldCharge, not v14:IsSpellInRange(v97.ShieldCharge))) then
									return "shield_charge main 34";
								end
							end
							v194 = 2 - 1;
						end
						if ((v194 == (1781 - (421 + 1355))) or ((5468 - 2153) <= (1367 + 1415))) then
							if ((v97.DemoralizingShout:IsCastable() and v36 and v97.BoomingVoice:IsAvailable()) or ((1959 - (286 + 797)) >= (10835 - 7871))) then
								local v200 = 0 - 0;
								while true do
									if ((v200 == (439 - (397 + 42))) or ((698 + 1534) > (3297 - (24 + 776)))) then
										v109(46 - 16);
										if (v23(v97.DemoralizingShout, not v101) or ((2895 - (222 + 563)) <= (730 - 398))) then
											return "demoralizing_shout main 28";
										end
										break;
									end
								end
							end
							if (((2654 + 1032) > (3362 - (23 + 167))) and (v92 < v94) and v45 and ((v54 and v31) or not v54) and (v86 == "player") and v97.SpearofBastion:IsCastable()) then
								v109(1818 - (690 + 1108));
								if (v23(v99.SpearOfBastionPlayer, not v101) or ((1615 + 2859) < (677 + 143))) then
									return "spear_of_bastion main 28";
								end
							end
							if (((5127 - (40 + 808)) >= (475 + 2407)) and (v92 < v94) and v45 and ((v54 and v31) or not v54) and (v86 == "cursor") and v97.SpearofBastion:IsCastable()) then
								local v201 = 0 - 0;
								while true do
									if ((v201 == (0 + 0)) or ((1074 + 955) >= (1931 + 1590))) then
										v109(591 - (47 + 524));
										if (v23(v99.SpearOfBastionCursor, not v101) or ((1322 + 715) >= (12689 - 8047))) then
											return "spear_of_bastion main 28";
										end
										break;
									end
								end
							end
							v194 = 8 - 2;
						end
						if (((3922 - 2202) < (6184 - (1165 + 561))) and (v194 == (1 + 6))) then
							if (((v92 < v94) and v97.ShieldCharge:IsCastable() and v42 and ((v53 and v31) or not v53)) or ((1350 - 914) > (1153 + 1868))) then
								if (((1192 - (341 + 138)) <= (229 + 618)) and v23(v97.ShieldCharge, not v14:IsSpellInRange(v97.ShieldCharge))) then
									return "shield_charge main 34";
								end
							end
							if (((4444 - 2290) <= (4357 - (89 + 237))) and v108() and v63) then
								if (((14846 - 10231) == (9716 - 5101)) and v23(v97.ShieldBlock)) then
									return "shield_block main 38";
								end
							end
							if ((v103 > (884 - (581 + 300))) or ((5010 - (855 + 365)) == (1187 - 687))) then
								local v202 = 0 + 0;
								while true do
									if (((1324 - (1030 + 205)) < (208 + 13)) and (v202 == (0 + 0))) then
										v28 = v113();
										if (((2340 - (156 + 130)) >= (3228 - 1807)) and v28) then
											return v28;
										end
										v202 = 1 - 0;
									end
									if (((1416 - 724) < (806 + 2252)) and (v202 == (1 + 0))) then
										if (v19.CastAnnotated(v97.Pool, false, "WAIT") or ((3323 - (10 + 59)) == (469 + 1186))) then
											return "Pool for Aoe()";
										end
										break;
									end
								end
							end
							v194 = 39 - 31;
						end
						if ((v194 == (1167 - (671 + 492))) or ((1032 + 264) == (6125 - (369 + 846)))) then
							if (((892 + 2476) == (2875 + 493)) and v105() and v64 and v97.LastStand:IsCastable() and v13:BuffDown(v97.ShieldWallBuff) and (((v14:HealthPercentage() >= (2035 - (1036 + 909))) and v97.UnnervingFocus:IsAvailable()) or ((v14:HealthPercentage() <= (16 + 4)) and v97.UnnervingFocus:IsAvailable()) or v97.Bolster:IsAvailable() or v13:HasTier(50 - 20, 205 - (11 + 192)))) then
								if (((1336 + 1307) < (3990 - (135 + 40))) and v23(v97.LastStand)) then
									return "last_stand defensive";
								end
							end
							if (((4634 - 2721) > (298 + 195)) and (v92 < v94) and v40 and ((v52 and v31) or not v52) and (v85 == "player") and v97.Ravager:IsCastable()) then
								local v203 = 0 - 0;
								while true do
									if (((7128 - 2373) > (3604 - (50 + 126))) and (v203 == (0 - 0))) then
										v109(3 + 7);
										if (((2794 - (1233 + 180)) <= (3338 - (522 + 447))) and v23(v99.RavagerPlayer, not v101)) then
											return "ravager main 24";
										end
										break;
									end
								end
							end
							if (((v92 < v94) and v40 and ((v52 and v31) or not v52) and (v85 == "cursor") and v97.Ravager:IsCastable()) or ((6264 - (107 + 1314)) == (1896 + 2188))) then
								v109(30 - 20);
								if (((1984 + 2685) > (720 - 357)) and v23(v99.RavagerCursor, not v101)) then
									return "ravager main 24";
								end
							end
							v194 = 19 - 14;
						end
					end
				end
				break;
			end
			if ((v131 == (1910 - (716 + 1194))) or ((33 + 1844) >= (337 + 2801))) then
				v28 = v110();
				if (((5245 - (74 + 429)) >= (6994 - 3368)) and v28) then
					return v28;
				end
				v131 = 1 + 0;
			end
		end
	end
	local function v117()
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
		v45 = EpicSettings.Settings['useSpearOfBastion'];
		v47 = EpicSettings.Settings['useThunderousRoar'];
		v51 = EpicSettings.Settings['avatarWithCD'];
		v52 = EpicSettings.Settings['ravagerWithCD'];
		v53 = EpicSettings.Settings['shieldChargeWithCD'];
		v54 = EpicSettings.Settings['spearOfBastionWithCD'];
		v55 = EpicSettings.Settings['thunderousRoarWithCD'];
	end
	local function v118()
		local v153 = 0 - 0;
		while true do
			if ((v153 == (4 + 1)) or ((13996 - 9456) == (2264 - 1348))) then
				v84 = EpicSettings.Settings['victoryRushHP'] or (433 - (279 + 154));
				v80 = EpicSettings.Settings['defensiveStanceHP'] or (778 - (454 + 324));
				v85 = EpicSettings.Settings['ravagerSetting'] or "";
				v86 = EpicSettings.Settings['spearSetting'] or "";
				break;
			end
			if ((v153 == (2 + 0)) or ((1173 - (12 + 5)) > (2343 + 2002))) then
				v63 = EpicSettings.Settings['useShieldBlock'];
				v62 = EpicSettings.Settings['useShieldWall'];
				v71 = EpicSettings.Settings['useVictoryRush'];
				v95 = EpicSettings.Settings['useChangeStance'];
				v153 = 7 - 4;
			end
			if (((827 + 1410) < (5342 - (277 + 816))) and (v153 == (17 - 13))) then
				v78 = EpicSettings.Settings['rallyingCryGroup'] or (1183 - (1058 + 125));
				v77 = EpicSettings.Settings['rallyingCryHP'] or (0 + 0);
				v74 = EpicSettings.Settings['shieldBlockHP'] or (975 - (815 + 160));
				v73 = EpicSettings.Settings['shieldWallHP'] or (0 - 0);
				v153 = 11 - 6;
			end
			if (((1 + 0) == v153) or ((7842 - 5159) < (1921 - (41 + 1857)))) then
				v65 = EpicSettings.Settings['useIgnorePain'];
				v67 = EpicSettings.Settings['useIntervene'];
				v64 = EpicSettings.Settings['useLastStand'];
				v66 = EpicSettings.Settings['useRallyingCry'];
				v153 = 1895 - (1222 + 671);
			end
			if (((1801 - 1104) <= (1186 - 360)) and (v153 == (1185 - (229 + 953)))) then
				v72 = EpicSettings.Settings['bitterImmunityHP'] or (1774 - (1111 + 663));
				v76 = EpicSettings.Settings['ignorePainHP'] or (1579 - (874 + 705));
				v79 = EpicSettings.Settings['interveneHP'] or (0 + 0);
				v75 = EpicSettings.Settings['lastStandHP'] or (0 + 0);
				v153 = 7 - 3;
			end
			if (((32 + 1073) <= (1855 - (642 + 37))) and ((0 + 0) == v153)) then
				v58 = EpicSettings.Settings['usePummel'];
				v59 = EpicSettings.Settings['useStormBolt'];
				v60 = EpicSettings.Settings['useIntimidatingShout'];
				v61 = EpicSettings.Settings['useBitterImmunity'];
				v153 = 1 + 0;
			end
		end
	end
	local function v119()
		local v154 = 0 - 0;
		while true do
			if (((3833 - (233 + 221)) <= (8814 - 5002)) and (v154 == (4 + 0))) then
				v88 = EpicSettings.Settings['HealingPotionName'] or "";
				v87 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v154 == (1543 - (718 + 823))) or ((496 + 292) >= (2421 - (266 + 539)))) then
				v56 = EpicSettings.Settings['trinketsWithCD'];
				v57 = EpicSettings.Settings['racialsWithCD'];
				v69 = EpicSettings.Settings['useHealthstone'];
				v154 = 8 - 5;
			end
			if (((3079 - (636 + 589)) <= (8020 - 4641)) and (v154 == (0 - 0))) then
				v92 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v89 = EpicSettings.Settings['InterruptWithStun'];
				v90 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v154 = 1 + 0;
			end
			if (((5564 - (657 + 358)) == (12044 - 7495)) and (v154 == (2 - 1))) then
				v91 = EpicSettings.Settings['InterruptThreshold'];
				v49 = EpicSettings.Settings['useTrinkets'];
				v50 = EpicSettings.Settings['useRacials'];
				v154 = 1189 - (1151 + 36);
			end
			if ((v154 == (3 + 0)) or ((795 + 2227) >= (9030 - 6006))) then
				v70 = EpicSettings.Settings['useHealingPotion'];
				v81 = EpicSettings.Settings['healthstoneHP'] or (1832 - (1552 + 280));
				v82 = EpicSettings.Settings['healingPotionHP'] or (834 - (64 + 770));
				v154 = 3 + 1;
			end
		end
	end
	local function v120()
		local v155 = 0 - 0;
		while true do
			if (((856 + 3964) > (3441 - (157 + 1086))) and (v155 == (5 - 2))) then
				v101 = v14:IsInMeleeRange(35 - 27);
				if (v96.TargetIsValid() or v13:AffectingCombat() or ((1627 - 566) >= (6675 - 1784))) then
					local v196 = 819 - (599 + 220);
					while true do
						if (((2716 - 1352) <= (6404 - (1813 + 118))) and (v196 == (0 + 0))) then
							v93 = v10.BossFightRemains(nil, true);
							v94 = v93;
							v196 = 1218 - (841 + 376);
						end
						if ((v196 == (1 - 0)) or ((836 + 2759) <= (8 - 5))) then
							if ((v94 == (11970 - (464 + 395))) or ((11990 - 7318) == (1850 + 2002))) then
								v94 = v10.FightRemains(v102, false);
							end
							break;
						end
					end
				end
				if (((2396 - (467 + 370)) == (3221 - 1662)) and not v13:IsChanneling()) then
					if (v13:AffectingCombat() or ((1287 + 465) <= (2701 - 1913))) then
						v28 = v116();
						if (v28 or ((610 + 3297) == (411 - 234))) then
							return v28;
						end
					else
						local v198 = 520 - (150 + 370);
						while true do
							if (((4752 - (74 + 1208)) > (1365 - 810)) and (v198 == (0 - 0))) then
								v28 = v115();
								if (v28 or ((692 + 280) == (1035 - (14 + 376)))) then
									return v28;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((5518 - 2336) >= (1369 + 746)) and (v155 == (0 + 0))) then
				v118();
				v117();
				v119();
				v155 = 1 + 0;
			end
			if (((11406 - 7513) < (3332 + 1097)) and ((79 - (23 + 55)) == v155)) then
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v155 = 4 - 2;
			end
			if ((v155 == (2 + 0)) or ((2575 + 292) < (2953 - 1048))) then
				v32 = EpicSettings.Toggles['kick'];
				if (v13:IsDeadOrGhost() or ((565 + 1231) >= (4952 - (652 + 249)))) then
					return;
				end
				if (((4332 - 2713) <= (5624 - (708 + 1160))) and v30) then
					local v197 = 0 - 0;
					while true do
						if (((1100 - 496) == (631 - (10 + 17))) and (v197 == (0 + 0))) then
							v102 = v13:GetEnemiesInMeleeRange(1740 - (1400 + 332));
							v103 = #v102;
							break;
						end
					end
				else
					v103 = 1 - 0;
				end
				v155 = 1911 - (242 + 1666);
			end
		end
	end
	local function v121()
		v19.Print("Protection Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(32 + 41, v120, v121);
end;
return v0["Epix_Warrior_Protection.lua"]();

