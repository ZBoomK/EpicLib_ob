local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1212 - (109 + 1103);
	local v6;
	while true do
		if ((v5 == (806 - (118 + 688))) or ((2303 - (25 + 23)) < (5 + 17))) then
			v6 = v0[v4];
			if (not v6 or ((2972 - (927 + 959)) >= (4736 - 3331))) then
				return v1(v4, ...);
			end
			v5 = 733 - (16 + 716);
		end
		if ((v5 == (1 - 0)) or ((2466 - (11 + 86)) == (1038 - 612))) then
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
	local v90;
	local v91 = 11396 - (175 + 110);
	local v92 = 28052 - 16941;
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
		local v120 = 0 - 0;
		local v121;
		while true do
			if ((v120 == (1796 - (503 + 1293))) or ((8590 - 5514) > (2302 + 881))) then
				v121 = UnitGetTotalAbsorbs(v14);
				if (((2263 - (810 + 251)) > (735 + 323)) and (v121 > (0 + 0))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v103()
		return v13:IsTankingAoE(15 + 1) or v13:IsTanking(v14) or v14:IsDummy();
	end
	local function v104()
		if (((4244 - (43 + 490)) > (4088 - (711 + 22))) and v13:BuffUp(v95.IgnorePain)) then
			local v175 = 0 - 0;
			local v176;
			local v177;
			local v178;
			while true do
				if (((860 - (240 + 619)) == v175) or ((219 + 687) >= (3545 - 1316))) then
					v178 = v177.points[1 + 0];
					return v178 < v176;
				end
				if (((3032 - (1344 + 400)) > (1656 - (255 + 150))) and (v175 == (0 + 0))) then
					v176 = v13:AttackPowerDamageMod() * (2.5 + 1) * ((4 - 3) + (v13:VersatilityDmgPct() / (322 - 222)));
					v177 = v13:AuraInfo(v95.IgnorePain, nil, true);
					v175 = 1740 - (404 + 1335);
				end
			end
		else
			return true;
		end
	end
	local function v105()
		if (v13:BuffUp(v95.IgnorePain) or ((4919 - (183 + 223)) < (4078 - 726))) then
			local v179 = v13:BuffInfo(v95.IgnorePain, nil, true);
			return v179.points[1 + 0];
		else
			return 0 + 0;
		end
	end
	local function v106()
		return v103() and v95.ShieldBlock:IsReady() and (((v13:BuffRemains(v95.ShieldBlockBuff) <= (355 - (10 + 327))) and v95.EnduringDefenses:IsAvailable()) or (v13:BuffRemains(v95.ShieldBlockBuff) <= (9 + 3)));
	end
	local function v107(v122)
		local v123 = 418 - (118 + 220);
		if ((v123 < (12 + 23)) or (v13:Rage() < (484 - (108 + 341))) or ((928 + 1137) >= (13511 - 10315))) then
			return false;
		end
		local v124 = false;
		local v125 = (v13:Rage() >= (1528 - (711 + 782))) and not v106();
		if ((v125 and (((v13:Rage() + v122) >= v123) or v95.DemoralizingShout:IsReady())) or ((8388 - 4012) <= (1950 - (270 + 199)))) then
			v124 = true;
		end
		if (v124 or ((1100 + 2292) >= (6560 - (580 + 1239)))) then
			if (((9884 - 6559) >= (2060 + 94)) and v103() and v104()) then
				if (v23(v95.IgnorePain, nil, nil, true) or ((47 + 1248) >= (1409 + 1824))) then
					return "ignore_pain rage capped";
				end
			elseif (((11427 - 7050) > (1021 + 621)) and v23(v95.Revenge, not v99)) then
				return "revenge rage capped";
			end
		end
	end
	local function v108()
		if (((5890 - (645 + 522)) > (3146 - (1010 + 780))) and v95.BitterImmunity:IsReady() and v60 and (v13:HealthPercentage() <= v70)) then
			if (v23(v95.BitterImmunity) or ((4134 + 2) <= (16354 - 12921))) then
				return "bitter_immunity defensive";
			end
		end
		if (((12439 - 8194) <= (6467 - (1045 + 791))) and v95.LastStand:IsCastable() and v63 and ((v13:HealthPercentage() <= v73) or v13:ActiveMitigationNeeded())) then
			if (((10823 - 6547) >= (5975 - 2061)) and v23(v95.LastStand)) then
				return "last_stand defensive";
			end
		end
		if (((703 - (351 + 154)) <= (5939 - (1281 + 293))) and v95.IgnorePain:IsReady() and v64 and (v13:HealthPercentage() <= v74) and v104()) then
			if (((5048 - (28 + 238)) > (10447 - 5771)) and v23(v95.IgnorePain, nil, nil, true)) then
				return "ignore_pain defensive";
			end
		end
		if (((6423 - (1381 + 178)) > (2061 + 136)) and v95.RallyingCry:IsReady() and v65 and v13:BuffDown(v95.AspectsFavorBuff) and v13:BuffDown(v95.RallyingCry) and (((v13:HealthPercentage() <= v75) and v94.IsSoloMode()) or v94.AreUnitsBelowHealthPercentage(v75, v76))) then
			if (v23(v95.RallyingCry) or ((2984 + 716) == (1070 + 1437))) then
				return "rallying_cry defensive";
			end
		end
		if (((15423 - 10949) >= (142 + 132)) and v95.Intervene:IsReady() and v66 and (v16:HealthPercentage() <= v77) and (v16:UnitName() ~= v13:UnitName())) then
			if (v23(v97.InterveneFocus) or ((2364 - (381 + 89)) <= (1247 + 159))) then
				return "intervene defensive";
			end
		end
		if (((1064 + 508) >= (2622 - 1091)) and v95.ShieldWall:IsCastable() and v61 and v13:BuffDown(v95.ShieldWallBuff) and ((v13:HealthPercentage() <= v71) or v13:ActiveMitigationNeeded())) then
			if (v23(v95.ShieldWall) or ((5843 - (1074 + 82)) < (9953 - 5411))) then
				return "shield_wall defensive";
			end
		end
		if (((5075 - (214 + 1570)) > (3122 - (990 + 465))) and v96.Healthstone:IsReady() and v67 and (v13:HealthPercentage() <= v79)) then
			if (v23(v97.Healthstone) or ((360 + 513) == (886 + 1148))) then
				return "healthstone defensive 3";
			end
		end
		if ((v68 and (v13:HealthPercentage() <= v80)) or ((2739 + 77) < (43 - 32))) then
			local v180 = 1726 - (1668 + 58);
			while true do
				if (((4325 - (512 + 114)) < (12269 - 7563)) and (v180 == (0 - 0))) then
					if (((9207 - 6561) >= (408 + 468)) and (v86 == "Refreshing Healing Potion")) then
						if (((115 + 499) <= (2768 + 416)) and v96.RefreshingHealingPotion:IsReady()) then
							if (((10543 - 7417) == (5120 - (109 + 1885))) and v23(v97.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v86 == "Dreamwalker's Healing Potion") or ((3656 - (1269 + 200)) >= (9494 - 4540))) then
						if (v96.DreamwalkersHealingPotion:IsReady() or ((4692 - (98 + 717)) == (4401 - (802 + 24)))) then
							if (((1218 - 511) > (797 - 165)) and v23(v97.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v109()
		v28 = v94.HandleTopTrinket(v98, v31, 6 + 34, nil);
		if (v28 or ((420 + 126) >= (441 + 2243))) then
			return v28;
		end
		v28 = v94.HandleBottomTrinket(v98, v31, 9 + 31, nil);
		if (((4075 - 2610) <= (14342 - 10041)) and v28) then
			return v28;
		end
	end
	local function v110()
		if (((610 + 1094) > (581 + 844)) and v14:IsInMeleeRange(7 + 1)) then
			if ((v95.ThunderClap:IsCastable() and v45) or ((500 + 187) == (1977 + 2257))) then
				if (v23(v95.ThunderClap) or ((4763 - (797 + 636)) < (6938 - 5509))) then
					return "thunder_clap precombat";
				end
			end
		elseif (((2766 - (1427 + 192)) >= (117 + 218)) and v34 and v95.Charge:IsCastable() and not v14:IsInRange(18 - 10)) then
			if (((3088 + 347) > (951 + 1146)) and v23(v95.Charge, not v14:IsSpellInRange(v95.Charge))) then
				return "charge precombat";
			end
		end
	end
	local function v111()
		local v126 = 326 - (192 + 134);
		while true do
			if (((1278 - (316 + 960)) == v126) or ((2098 + 1672) >= (3119 + 922))) then
				if ((v95.ShieldSlam:IsCastable() and v42 and ((v13:Rage() <= (56 + 4)) or (v13:BuffUp(v95.ViolentOutburstBuff) and (v101 <= (26 - 19))))) or ((4342 - (83 + 468)) <= (3417 - (1202 + 604)))) then
					local v185 = 0 - 0;
					while true do
						if ((v185 == (0 - 0)) or ((12675 - 8097) <= (2333 - (45 + 280)))) then
							v107(20 + 0);
							if (((983 + 142) <= (759 + 1317)) and v23(v95.ShieldSlam, not v99)) then
								return "shield_slam aoe 8";
							end
							break;
						end
					end
				end
				if ((v95.ThunderClap:IsCastable() and v45) or ((412 + 331) >= (774 + 3625))) then
					v107(9 - 4);
					if (((3066 - (340 + 1571)) < (660 + 1013)) and v23(v95.ThunderClap, not v14:IsInMeleeRange(1780 - (1733 + 39)))) then
						return "thunder_clap aoe 10";
					end
				end
				v126 = 8 - 5;
			end
			if ((v126 == (1037 - (125 + 909))) or ((4272 - (1096 + 852)) <= (260 + 318))) then
				if (((5379 - 1612) == (3654 + 113)) and v95.Revenge:IsReady() and v40 and ((v13:Rage() >= (542 - (409 + 103))) or ((v13:Rage() >= (276 - (46 + 190))) and v95.BarbaricTraining:IsAvailable()))) then
					if (((4184 - (51 + 44)) == (1154 + 2935)) and v23(v95.Revenge, not v99)) then
						return "revenge aoe 12";
					end
				end
				break;
			end
			if (((5775 - (1114 + 203)) >= (2400 - (228 + 498))) and (v126 == (0 + 0))) then
				if (((537 + 435) <= (2081 - (174 + 489))) and v95.ThunderClap:IsCastable() and v45 and (v14:DebuffRemains(v95.RendDebuff) <= (2 - 1))) then
					local v186 = 1905 - (830 + 1075);
					while true do
						if ((v186 == (524 - (303 + 221))) or ((6207 - (231 + 1038)) < (3969 + 793))) then
							v107(1167 - (171 + 991));
							if (v23(v95.ThunderClap, not v14:IsInMeleeRange(32 - 24)) or ((6723 - 4219) > (10640 - 6376))) then
								return "thunder_clap aoe 2";
							end
							break;
						end
					end
				end
				if (((1724 + 429) == (7546 - 5393)) and v95.ShieldSlam:IsCastable() and v42 and ((v13:HasTier(86 - 56, 2 - 0) and (v101 <= (21 - 14))) or v13:BuffUp(v95.EarthenTenacityBuff))) then
					if (v23(v95.ShieldSlam, not v99) or ((1755 - (111 + 1137)) >= (2749 - (91 + 67)))) then
						return "shield_slam aoe 3";
					end
				end
				v126 = 2 - 1;
			end
			if (((1119 + 3362) == (5004 - (423 + 100))) and (v126 == (1 + 0))) then
				if ((v95.ThunderClap:IsCastable() and v45 and v13:BuffUp(v95.ViolentOutburstBuff) and (v101 > (13 - 8)) and v13:BuffUp(v95.AvatarBuff) and v95.UnstoppableForce:IsAvailable()) or ((1214 + 1114) < (1464 - (326 + 445)))) then
					local v187 = 0 - 0;
					while true do
						if (((9641 - 5313) == (10102 - 5774)) and ((711 - (530 + 181)) == v187)) then
							v107(886 - (614 + 267));
							if (((1620 - (19 + 13)) >= (2167 - 835)) and v23(v95.ThunderClap, not v14:IsInMeleeRange(18 - 10))) then
								return "thunder_clap aoe 4";
							end
							break;
						end
					end
				end
				if ((v95.Revenge:IsReady() and v40 and (v13:Rage() >= (199 - 129)) and v95.SeismicReverberation:IsAvailable() and (v101 >= (1 + 2))) or ((7340 - 3166) > (8809 - 4561))) then
					if (v23(v95.Revenge, not v99) or ((6398 - (1293 + 519)) <= (166 - 84))) then
						return "revenge aoe 6";
					end
				end
				v126 = 4 - 2;
			end
		end
	end
	local function v112()
		local v127 = 0 - 0;
		while true do
			if (((16657 - 12794) == (9099 - 5236)) and (v127 == (2 + 0))) then
				if ((v95.Revenge:IsReady() and v40 and (v14:HealthPercentage() > (5 + 15))) or ((654 - 372) <= (10 + 32))) then
					if (((1532 + 3077) >= (479 + 287)) and v23(v95.Revenge, not v99)) then
						return "revenge generic 18";
					end
				end
				if ((v95.ThunderClap:IsCastable() and v45 and ((v101 >= (1097 - (709 + 387))) or (v95.ShieldSlam:CooldownDown() and v13:BuffUp(v95.ViolentOutburstBuff)))) or ((3010 - (673 + 1185)) == (7215 - 4727))) then
					local v188 = 0 - 0;
					while true do
						if (((5629 - 2207) > (2397 + 953)) and (v188 == (0 + 0))) then
							v107(6 - 1);
							if (((216 + 661) > (749 - 373)) and v23(v95.ThunderClap, not v14:IsInMeleeRange(15 - 7))) then
								return "thunder_clap generic 20";
							end
							break;
						end
					end
				end
				if ((v95.Devastate:IsCastable() and v36) or ((4998 - (446 + 1434)) <= (3134 - (1040 + 243)))) then
					if (v23(v95.Devastate, not v99) or ((492 - 327) >= (5339 - (559 + 1288)))) then
						return "devastate generic 22";
					end
				end
				break;
			end
			if (((5880 - (609 + 1322)) < (5310 - (13 + 441))) and ((3 - 2) == v127)) then
				if ((v95.Execute:IsReady() and v37 and (v101 == (2 - 1)) and (v13:Rage() >= (249 - 199))) or ((160 + 4116) < (10953 - 7937))) then
					if (((1666 + 3024) > (1808 + 2317)) and v23(v95.Execute, not v99)) then
						return "execute generic 10";
					end
				end
				if ((v95.ThunderClap:IsCastable() and v45 and ((v101 > (2 - 1)) or (v95.ShieldSlam:CooldownDown() and not v13:BuffUp(v95.ViolentOutburstBuff)))) or ((28 + 22) >= (1647 - 751))) then
					v107(4 + 1);
					if (v23(v95.ThunderClap, not v14:IsInMeleeRange(5 + 3)) or ((1232 + 482) >= (2484 + 474))) then
						return "thunder_clap generic 12";
					end
				end
				if ((v95.Revenge:IsReady() and v40 and (((v13:Rage() >= (59 + 1)) and (v14:HealthPercentage() > (453 - (153 + 280)))) or (v13:BuffUp(v95.RevengeBuff) and (v14:HealthPercentage() <= (57 - 37)) and (v13:Rage() <= (17 + 1)) and v95.ShieldSlam:CooldownDown()) or (v13:BuffUp(v95.RevengeBuff) and (v14:HealthPercentage() > (8 + 12))) or ((((v13:Rage() >= (32 + 28)) and (v14:HealthPercentage() > (32 + 3))) or (v13:BuffUp(v95.RevengeBuff) and (v14:HealthPercentage() <= (26 + 9)) and (v13:Rage() <= (27 - 9)) and v95.ShieldSlam:CooldownDown()) or (v13:BuffUp(v95.RevengeBuff) and (v14:HealthPercentage() > (22 + 13)))) and v95.Massacre:IsAvailable()))) or ((2158 - (89 + 578)) < (461 + 183))) then
					if (((1463 - 759) < (2036 - (572 + 477))) and v23(v95.Revenge, not v99)) then
						return "revenge generic 14";
					end
				end
				if (((502 + 3216) > (1144 + 762)) and v95.Execute:IsReady() and v37 and (v101 == (1 + 0))) then
					if (v23(v95.Execute, not v99) or ((1044 - (84 + 2)) > (5990 - 2355))) then
						return "execute generic 16";
					end
				end
				v127 = 2 + 0;
			end
			if (((4343 - (497 + 345)) <= (115 + 4377)) and (v127 == (0 + 0))) then
				if ((v95.ShieldSlam:IsCastable() and v42) or ((4775 - (605 + 728)) < (1818 + 730))) then
					local v189 = 0 - 0;
					while true do
						if (((132 + 2743) >= (5412 - 3948)) and (v189 == (0 + 0))) then
							v107(55 - 35);
							if (v23(v95.ShieldSlam, not v99) or ((3622 + 1175) >= (5382 - (457 + 32)))) then
								return "shield_slam generic 2";
							end
							break;
						end
					end
				end
				if ((v95.ThunderClap:IsCastable() and v45 and (v14:DebuffRemains(v95.RendDebuff) <= (1 + 0)) and v13:BuffDown(v95.ViolentOutburstBuff)) or ((1953 - (832 + 570)) > (1949 + 119))) then
					local v190 = 0 + 0;
					while true do
						if (((7480 - 5366) > (455 + 489)) and (v190 == (796 - (588 + 208)))) then
							v107(13 - 8);
							if (v23(v95.ThunderClap, not v14:IsInMeleeRange(1808 - (884 + 916))) or ((4735 - 2473) >= (1796 + 1300))) then
								return "thunder_clap generic 4";
							end
							break;
						end
					end
				end
				if ((v95.Execute:IsReady() and v37 and v13:BuffUp(v95.SuddenDeathBuff) and v95.SuddenDeath:IsAvailable()) or ((2908 - (232 + 421)) >= (5426 - (1569 + 320)))) then
					if (v23(v95.Execute, not v99) or ((942 + 2895) < (249 + 1057))) then
						return "execute generic 6";
					end
				end
				if (((9940 - 6990) == (3555 - (316 + 289))) and v95.Execute:IsReady() and v37 and (v101 == (2 - 1)) and (v95.Massacre:IsAvailable() or v95.Juggernaut:IsAvailable()) and (v13:Rage() >= (3 + 47))) then
					if (v23(v95.Execute, not v99) or ((6176 - (666 + 787)) < (3723 - (360 + 65)))) then
						return "execute generic 6";
					end
				end
				v127 = 1 + 0;
			end
		end
	end
	local function v113()
		local v128 = 254 - (79 + 175);
		while true do
			if (((1791 - 655) >= (121 + 33)) and (v128 == (0 - 0))) then
				if (not v13:AffectingCombat() or ((521 - 250) > (5647 - (503 + 396)))) then
					local v191 = 181 - (92 + 89);
					while true do
						if (((9195 - 4455) >= (1617 + 1535)) and (v191 == (0 + 0))) then
							if ((v95.BattleShout:IsCastable() and v33 and (v13:BuffDown(v95.BattleShoutBuff, true) or v94.GroupBuffMissing(v95.BattleShoutBuff))) or ((10095 - 7517) >= (464 + 2926))) then
								if (((93 - 52) <= (1450 + 211)) and v23(v95.BattleShout)) then
									return "battle_shout precombat";
								end
							end
							if (((288 + 313) < (10842 - 7282)) and v93 and v95.BattleStance:IsCastable() and not v13:BuffUp(v95.BattleStance)) then
								if (((30 + 205) < (1046 - 359)) and v23(v95.BattleStance)) then
									return "battle_stance precombat";
								end
							end
							break;
						end
					end
				end
				if (((5793 - (485 + 759)) > (2667 - 1514)) and v94.TargetIsValid() and v29) then
					if (not v13:AffectingCombat() or ((5863 - (442 + 747)) < (5807 - (832 + 303)))) then
						local v195 = 946 - (88 + 858);
						while true do
							if (((1118 + 2550) < (3775 + 786)) and (v195 == (0 + 0))) then
								v28 = v110();
								if (v28 or ((1244 - (766 + 23)) == (17796 - 14191))) then
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
	local function v114()
		local v129 = 0 - 0;
		while true do
			if ((v129 == (0 - 0)) or ((9038 - 6375) == (4385 - (1036 + 37)))) then
				v28 = v108();
				if (((3033 + 1244) <= (8714 - 4239)) and v28) then
					return v28;
				end
				v129 = 1 + 0;
			end
			if ((v129 == (1481 - (641 + 839))) or ((1783 - (910 + 3)) == (3030 - 1841))) then
				if (((3237 - (1466 + 218)) <= (1440 + 1693)) and v85) then
					local v192 = 1148 - (556 + 592);
					while true do
						if ((v192 == (0 + 0)) or ((3045 - (329 + 479)) >= (4365 - (174 + 680)))) then
							v28 = v94.HandleIncorporeal(v95.StormBolt, v97.StormBoltMouseover, 68 - 48, true);
							if (v28 or ((2744 - 1420) > (2157 + 863))) then
								return v28;
							end
							v192 = 740 - (396 + 343);
						end
						if (((1 + 0) == v192) or ((4469 - (29 + 1448)) == (3270 - (135 + 1254)))) then
							v28 = v94.HandleIncorporeal(v95.IntimidatingShout, v97.IntimidatingShoutMouseover, 30 - 22, true);
							if (((14502 - 11396) > (1017 + 509)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (((4550 - (389 + 1138)) < (4444 - (102 + 472))) and v94.TargetIsValid()) then
					if (((135 + 8) > (42 + 32)) and v93 and (v13:HealthPercentage() <= v78)) then
						if (((17 + 1) < (3657 - (320 + 1225))) and v95.DefensiveStance:IsCastable() and not v13:BuffUp(v95.DefensiveStance)) then
							if (((1952 - 855) <= (997 + 631)) and v23(v95.DefensiveStance)) then
								return "defensive_stance while tanking";
							end
						end
					end
					if (((6094 - (157 + 1307)) == (6489 - (821 + 1038))) and v93 and (v13:HealthPercentage() > v78)) then
						if (((8832 - 5292) > (294 + 2389)) and v95.BattleStance:IsCastable() and not v13:BuffUp(v95.BattleStance)) then
							if (((8515 - 3721) >= (1219 + 2056)) and v23(v95.BattleStance)) then
								return "battle_stance while not tanking";
							end
						end
					end
					if (((3678 - 2194) == (2510 - (834 + 192))) and v41 and ((v52 and v31) or not v52) and (v90 < v92) and v95.ShieldCharge:IsCastable() and not v99) then
						if (((92 + 1340) < (913 + 2642)) and v23(v95.ShieldCharge, not v14:IsSpellInRange(v95.ShieldCharge))) then
							return "shield_charge main 34";
						end
					end
					if ((v34 and v95.Charge:IsCastable() and not v99) or ((23 + 1042) > (5542 - 1964))) then
						if (v23(v95.Charge, not v14:IsSpellInRange(v95.Charge)) or ((5099 - (300 + 4)) < (376 + 1031))) then
							return "charge main 34";
						end
					end
					if (((4850 - 2997) < (5175 - (112 + 250))) and (v90 < v92)) then
						if ((v48 and ((v31 and v55) or not v55)) or ((1125 + 1696) < (6090 - 3659))) then
							local v202 = 0 + 0;
							while true do
								if ((v202 == (0 + 0)) or ((2150 + 724) < (1082 + 1099))) then
									v28 = v109();
									if (v28 or ((1998 + 691) <= (1757 - (1001 + 413)))) then
										return v28;
									end
									break;
								end
							end
						end
					end
					if ((v38 and v95.HeroicThrow:IsCastable() and not v14:IsInRange(66 - 36)) or ((2751 - (244 + 638)) == (2702 - (627 + 66)))) then
						if (v23(v95.HeroicThrow, not v14:IsInRange(89 - 59)) or ((4148 - (512 + 90)) < (4228 - (1665 + 241)))) then
							return "heroic_throw main";
						end
					end
					if ((v95.WreckingThrow:IsCastable() and v47 and v14:AffectingCombat() and v102()) or ((2799 - (373 + 344)) == (2153 + 2620))) then
						if (((859 + 2385) > (2782 - 1727)) and v23(v95.WreckingThrow, not v14:IsInRange(50 - 20))) then
							return "wrecking_throw main";
						end
					end
					if (((v90 < v92) and v32 and ((v50 and v31) or not v50) and v95.Avatar:IsCastable()) or ((4412 - (35 + 1064)) <= (1294 + 484))) then
						if (v23(v95.Avatar) or ((3040 - 1619) >= (9 + 2095))) then
							return "avatar main 2";
						end
					end
					if (((3048 - (298 + 938)) <= (4508 - (233 + 1026))) and (v90 < v92) and v49 and ((v56 and v31) or not v56)) then
						if (((3289 - (636 + 1030)) <= (1001 + 956)) and v95.BloodFury:IsCastable()) then
							if (((4310 + 102) == (1311 + 3101)) and v23(v95.BloodFury)) then
								return "blood_fury main 4";
							end
						end
						if (((119 + 1631) >= (1063 - (55 + 166))) and v95.Berserking:IsCastable()) then
							if (((848 + 3524) > (187 + 1663)) and v23(v95.Berserking)) then
								return "berserking main 6";
							end
						end
						if (((885 - 653) < (1118 - (36 + 261))) and v95.ArcaneTorrent:IsCastable()) then
							if (((905 - 387) < (2270 - (34 + 1334))) and v23(v95.ArcaneTorrent)) then
								return "arcane_torrent main 8";
							end
						end
						if (((1151 + 1843) > (667 + 191)) and v95.LightsJudgment:IsCastable()) then
							if (v23(v95.LightsJudgment) or ((5038 - (1035 + 248)) <= (936 - (20 + 1)))) then
								return "lights_judgment main 10";
							end
						end
						if (((2056 + 1890) > (4062 - (134 + 185))) and v95.Fireblood:IsCastable()) then
							if (v23(v95.Fireblood) or ((2468 - (549 + 584)) >= (3991 - (314 + 371)))) then
								return "fireblood main 12";
							end
						end
						if (((16629 - 11785) > (3221 - (478 + 490))) and v95.AncestralCall:IsCastable()) then
							if (((240 + 212) == (1624 - (786 + 386))) and v23(v95.AncestralCall)) then
								return "ancestral_call main 14";
							end
						end
						if (v95.BagofTricks:IsCastable() or ((14760 - 10203) < (3466 - (1055 + 324)))) then
							if (((5214 - (1093 + 247)) == (3443 + 431)) and v23(v95.BagofTricks)) then
								return "ancestral_call main 16";
							end
						end
					end
					local v193 = v94.HandleDPSPotion(v14:BuffUp(v95.AvatarBuff));
					if (v193 or ((204 + 1734) > (19592 - 14657))) then
						return v193;
					end
					if ((v95.IgnorePain:IsReady() and v64 and v104() and (v14:HealthPercentage() >= (67 - 47)) and (((v13:RageDeficit() <= (42 - 27)) and v95.ShieldSlam:CooldownUp()) or ((v13:RageDeficit() <= (100 - 60)) and v95.ShieldCharge:CooldownUp() and v95.ChampionsBulwark:IsAvailable()) or ((v13:RageDeficit() <= (8 + 12)) and v95.ShieldCharge:CooldownUp()) or ((v13:RageDeficit() <= (115 - 85)) and v95.DemoralizingShout:CooldownUp() and v95.BoomingVoice:IsAvailable()) or ((v13:RageDeficit() <= (68 - 48)) and v95.Avatar:CooldownUp()) or ((v13:RageDeficit() <= (34 + 11)) and v95.DemoralizingShout:CooldownUp() and v95.BoomingVoice:IsAvailable() and v13:BuffUp(v95.LastStandBuff) and v95.UnnervingFocus:IsAvailable()) or ((v13:RageDeficit() <= (76 - 46)) and v95.Avatar:CooldownUp() and v13:BuffUp(v95.LastStandBuff) and v95.UnnervingFocus:IsAvailable()) or (v13:RageDeficit() <= (708 - (364 + 324))) or ((v13:RageDeficit() <= (109 - 69)) and v95.ShieldSlam:CooldownUp() and v13:BuffUp(v95.ViolentOutburstBuff) and v95.HeavyRepercussions:IsAvailable() and v95.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (131 - 76)) and v95.ShieldSlam:CooldownUp() and v13:BuffUp(v95.ViolentOutburstBuff) and v13:BuffUp(v95.LastStandBuff) and v95.UnnervingFocus:IsAvailable() and v95.HeavyRepercussions:IsAvailable() and v95.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (6 + 11)) and v95.ShieldSlam:CooldownUp() and v95.HeavyRepercussions:IsAvailable()) or ((v13:RageDeficit() <= (75 - 57)) and v95.ShieldSlam:CooldownUp() and v95.ImpenetrableWall:IsAvailable()))) or ((6814 - 2559) < (10395 - 6972))) then
						if (((2722 - (1249 + 19)) <= (2249 + 242)) and v23(v95.IgnorePain, nil, nil, true)) then
							return "ignore_pain main 20";
						end
					end
					if ((v103() and v63 and v95.LastStand:IsCastable() and v13:BuffDown(v95.ShieldWallBuff) and (((v14:HealthPercentage() >= (350 - 260)) and v95.UnnervingFocus:IsAvailable()) or ((v14:HealthPercentage() <= (1106 - (686 + 400))) and v95.UnnervingFocus:IsAvailable()) or v95.Bolster:IsAvailable() or v13:HasTier(24 + 6, 231 - (73 + 156)))) or ((20 + 4137) <= (3614 - (721 + 90)))) then
						if (((55 + 4798) >= (9681 - 6699)) and v23(v95.LastStand)) then
							return "last_stand defensive";
						end
					end
					if (((4604 - (224 + 246)) > (5438 - 2081)) and (v90 < v92) and v39 and ((v51 and v31) or not v51) and (v83 == "player") and v95.Ravager:IsCastable()) then
						local v196 = 0 - 0;
						while true do
							if ((v196 == (0 + 0)) or ((82 + 3335) < (1862 + 672))) then
								v107(19 - 9);
								if (v23(v97.RavagerPlayer, not v99) or ((9058 - 6336) <= (677 - (203 + 310)))) then
									return "ravager main 24";
								end
								break;
							end
						end
					end
					if (((v90 < v92) and v39 and ((v51 and v31) or not v51) and (v83 == "cursor") and v95.Ravager:IsCastable()) or ((4401 - (1238 + 755)) < (148 + 1961))) then
						v107(1544 - (709 + 825));
						if (v23(v97.RavagerCursor, not v99) or ((60 - 27) == (2119 - 664))) then
							return "ravager main 24";
						end
					end
					if ((v95.DemoralizingShout:IsCastable() and v35 and v95.BoomingVoice:IsAvailable()) or ((1307 - (196 + 668)) >= (15852 - 11837))) then
						local v197 = 0 - 0;
						while true do
							if (((4215 - (171 + 662)) > (259 - (4 + 89))) and (v197 == (0 - 0))) then
								v107(11 + 19);
								if (v23(v95.DemoralizingShout, not v99) or ((1229 - 949) == (1200 + 1859))) then
									return "demoralizing_shout main 28";
								end
								break;
							end
						end
					end
					if (((3367 - (35 + 1451)) > (2746 - (28 + 1425))) and (v90 < v92) and v44 and ((v53 and v31) or not v53) and (v84 == "player") and v95.SpearofBastion:IsCastable()) then
						local v198 = 1993 - (941 + 1052);
						while true do
							if (((2261 + 96) == (3871 - (822 + 692))) and ((0 - 0) == v198)) then
								v107(10 + 10);
								if (((420 - (45 + 252)) == (122 + 1)) and v23(v97.SpearOfBastionPlayer, not v99)) then
									return "spear_of_bastion main 28";
								end
								break;
							end
						end
					end
					if (((v90 < v92) and v44 and ((v53 and v31) or not v53) and (v84 == "cursor") and v95.SpearofBastion:IsCastable()) or ((364 + 692) >= (8254 - 4862))) then
						local v199 = 433 - (114 + 319);
						while true do
							if ((v199 == (0 - 0)) or ((1384 - 303) < (686 + 389))) then
								v107(29 - 9);
								if (v23(v97.SpearOfBastionCursor, not v99) or ((2197 - 1148) >= (6395 - (556 + 1407)))) then
									return "spear_of_bastion main 28";
								end
								break;
							end
						end
					end
					if (((v90 < v92) and v46 and ((v54 and v31) or not v54) and v95.ThunderousRoar:IsCastable()) or ((5974 - (741 + 465)) <= (1311 - (170 + 295)))) then
						if (v23(v95.ThunderousRoar, not v14:IsInMeleeRange(5 + 3)) or ((3085 + 273) <= (3496 - 2076))) then
							return "thunderous_roar main 30";
						end
					end
					if ((v95.ShieldSlam:IsCastable() and v42 and v13:BuffUp(v95.FervidBuff)) or ((3100 + 639) <= (1928 + 1077))) then
						if (v23(v95.ShieldSlam, not v99) or ((940 + 719) >= (3364 - (957 + 273)))) then
							return "shield_slam main 31";
						end
					end
					if ((v95.Shockwave:IsCastable() and v43 and v13:BuffUp(v95.AvatarBuff) and v95.UnstoppableForce:IsAvailable() and not v95.RumblingEarth:IsAvailable()) or (v95.SonicBoom:IsAvailable() and v95.RumblingEarth:IsAvailable() and (v101 >= (1 + 2)) and v14:IsCasting()) or ((1306 + 1954) < (8973 - 6618))) then
						v107(26 - 16);
						if (v23(v95.Shockwave, not v14:IsInMeleeRange(24 - 16)) or ((3312 - 2643) == (6003 - (389 + 1391)))) then
							return "shockwave main 32";
						end
					end
					if (((v90 < v92) and v95.ShieldCharge:IsCastable() and v41 and ((v52 and v31) or not v52)) or ((1062 + 630) < (62 + 526))) then
						if (v23(v95.ShieldCharge, not v14:IsSpellInRange(v95.ShieldCharge)) or ((10920 - 6123) < (4602 - (783 + 168)))) then
							return "shield_charge main 34";
						end
					end
					if ((v106() and v62) or ((14018 - 9841) > (4771 + 79))) then
						if (v23(v95.ShieldBlock) or ((711 - (309 + 2)) > (3411 - 2300))) then
							return "shield_block main 38";
						end
					end
					if (((4263 - (1090 + 122)) > (326 + 679)) and (v101 > (9 - 6))) then
						local v200 = 0 + 0;
						while true do
							if (((4811 - (628 + 490)) <= (786 + 3596)) and (v200 == (0 - 0))) then
								v28 = v111();
								if (v28 or ((14998 - 11716) > (4874 - (431 + 343)))) then
									return v28;
								end
								v200 = 1 - 0;
							end
							if ((v200 == (2 - 1)) or ((2829 + 751) < (364 + 2480))) then
								if (((1784 - (556 + 1139)) < (4505 - (6 + 9))) and v19.CastAnnotated(v95.Pool, false, "WAIT")) then
									return "Pool for Aoe()";
								end
								break;
							end
						end
					end
					v28 = v112();
					if (v28 or ((913 + 4070) < (927 + 881))) then
						return v28;
					end
					if (((3998 - (28 + 141)) > (1460 + 2309)) and v19.CastAnnotated(v95.Pool, false, "WAIT")) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
		end
	end
	local function v115()
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
		v44 = EpicSettings.Settings['useSpearOfBastion'];
		v46 = EpicSettings.Settings['useThunderousRoar'];
		v50 = EpicSettings.Settings['avatarWithCD'];
		v51 = EpicSettings.Settings['ravagerWithCD'];
		v52 = EpicSettings.Settings['shieldChargeWithCD'];
		v53 = EpicSettings.Settings['spearOfBastionWithCD'];
		v54 = EpicSettings.Settings['thunderousRoarWithCD'];
	end
	local function v116()
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
		v93 = EpicSettings.Settings['useChangeStance'];
		v70 = EpicSettings.Settings['bitterImmunityHP'] or (0 - 0);
		v74 = EpicSettings.Settings['ignorePainHP'] or (0 + 0);
		v77 = EpicSettings.Settings['interveneHP'] or (1317 - (486 + 831));
		v73 = EpicSettings.Settings['lastStandHP'] or (0 - 0);
		v76 = EpicSettings.Settings['rallyingCryGroup'] or (0 - 0);
		v75 = EpicSettings.Settings['rallyingCryHP'] or (0 + 0);
		v72 = EpicSettings.Settings['shieldBlockHP'] or (0 - 0);
		v71 = EpicSettings.Settings['shieldWallHP'] or (1263 - (668 + 595));
		v82 = EpicSettings.Settings['victoryRushHP'] or (0 + 0);
		v78 = EpicSettings.Settings['defensiveStanceHP'] or (0 + 0);
		v83 = EpicSettings.Settings['ravagerSetting'] or "";
		v84 = EpicSettings.Settings['spearSetting'] or "";
	end
	local function v117()
		v90 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v87 = EpicSettings.Settings['InterruptWithStun'];
		v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v89 = EpicSettings.Settings['InterruptThreshold'];
		v48 = EpicSettings.Settings['useTrinkets'];
		v49 = EpicSettings.Settings['useRacials'];
		v55 = EpicSettings.Settings['trinketsWithCD'];
		v56 = EpicSettings.Settings['racialsWithCD'];
		v67 = EpicSettings.Settings['useHealthstone'];
		v68 = EpicSettings.Settings['useHealingPotion'];
		v79 = EpicSettings.Settings['healthstoneHP'] or (290 - (23 + 267));
		v80 = EpicSettings.Settings['healingPotionHP'] or (1944 - (1129 + 815));
		v86 = EpicSettings.Settings['HealingPotionName'] or "";
		v85 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v118()
		local v173 = 387 - (371 + 16);
		while true do
			if (((3235 - (1326 + 424)) <= (5499 - 2595)) and (v173 == (7 - 5))) then
				v99 = v14:IsInMeleeRange(126 - (88 + 30));
				if (((5040 - (720 + 51)) == (9496 - 5227)) and (v94.TargetIsValid() or v13:AffectingCombat())) then
					v91 = v10.BossFightRemains(nil, true);
					v92 = v91;
					if (((2163 - (421 + 1355)) <= (4588 - 1806)) and (v92 == (5458 + 5653))) then
						v92 = v10.FightRemains(v100, false);
					end
				end
				if (not v13:IsChanneling() or ((2982 - (286 + 797)) <= (3352 - 2435))) then
					if (v13:AffectingCombat() or ((7141 - 2829) <= (1315 - (397 + 42)))) then
						v28 = v114();
						if (((698 + 1534) <= (3396 - (24 + 776))) and v28) then
							return v28;
						end
					else
						local v201 = 0 - 0;
						while true do
							if (((2880 - (222 + 563)) < (8121 - 4435)) and (v201 == (0 + 0))) then
								v28 = v113();
								if (v28 or ((1785 - (23 + 167)) >= (6272 - (690 + 1108)))) then
									return v28;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((0 + 0) == v173) or ((3810 + 809) < (3730 - (40 + 808)))) then
				v116();
				v115();
				v117();
				v29 = EpicSettings.Toggles['ooc'];
				v173 = 1 + 0;
			end
			if ((v173 == (3 - 2)) or ((281 + 13) >= (2556 + 2275))) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				if (((1113 + 916) <= (3655 - (47 + 524))) and v13:IsDeadOrGhost()) then
					return v28;
				end
				if (v30 or ((1322 + 715) == (6615 - 4195))) then
					local v194 = 0 - 0;
					while true do
						if (((10166 - 5708) > (5630 - (1165 + 561))) and (v194 == (0 + 0))) then
							v100 = v13:GetEnemiesInMeleeRange(24 - 16);
							v101 = #v100;
							break;
						end
					end
				else
					v101 = 1 + 0;
				end
				v173 = 481 - (341 + 138);
			end
		end
	end
	local function v119()
		v19.Print("Protection Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(20 + 53, v118, v119);
end;
return v0["Epix_Warrior_Protection.lua"]();

