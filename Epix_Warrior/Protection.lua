local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((1727 - (1668 + 58)) == v5) or ((900 - (512 + 114)) == (9338 - 5756))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((6673 - 4755) == (501 + 574))) then
			v6 = v0[v4];
			if (((75 + 321) <= (3307 + 497)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
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
	local v90 = 13105 - (109 + 1885);
	local v91 = 12580 - (1269 + 200);
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
		local v119 = 0 - 0;
		local v120;
		while true do
			if (((815 - (98 + 717)) == v119) or ((4995 - (802 + 24)) == (3770 - 1583))) then
				v120 = UnitGetTotalAbsorbs(v14:ID());
				if (((1775 - 369) == (208 + 1198)) and (v120 > (0 + 0))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v102()
		return v13:IsTankingAoE(3 + 13) or v13:IsTanking(v14) or v14:IsDummy();
	end
	local function v103()
		if (((331 + 1200) < (11881 - 7610)) and v13:BuffUp(v94.IgnorePain)) then
			local v168 = v13:AttackPowerDamageMod() * (9.5 - 6) * (1 + 0 + (v13:VersatilityDmgPct() / (41 + 59)));
			local v169 = v13:AuraInfo(v94.IgnorePain, nil, true);
			local v170 = v169.points[1 + 0];
			return v170 < v168;
		else
			return true;
		end
	end
	local function v104()
		if (((462 + 173) == (297 + 338)) and v13:BuffUp(v94.IgnorePain)) then
			local v171 = v13:BuffInfo(v94.IgnorePain, nil, true);
			return v171.points[1434 - (797 + 636)];
		else
			return 0 - 0;
		end
	end
	local function v105()
		return v102() and v94.ShieldBlock:IsReady() and (((v13:BuffRemains(v94.ShieldBlockBuff) <= (1637 - (1427 + 192))) and v94.EnduringDefenses:IsAvailable()) or (v13:BuffRemains(v94.ShieldBlockBuff) <= (5 + 7)));
	end
	local function v106(v121)
		local v122 = 0 - 0;
		local v123;
		local v124;
		local v125;
		while true do
			if (((3032 + 341) <= (1612 + 1944)) and (v122 == (327 - (192 + 134)))) then
				v124 = false;
				v125 = (v13:Rage() >= (1311 - (316 + 960))) and not v105();
				v122 = 2 + 0;
			end
			if ((v122 == (0 + 0)) or ((3042 + 249) < (12539 - 9259))) then
				v123 = 631 - (83 + 468);
				if (((6192 - (1202 + 604)) >= (4075 - 3202)) and ((v123 < (57 - 22)) or (v13:Rage() < (96 - 61)))) then
					return false;
				end
				v122 = 326 - (45 + 280);
			end
			if (((889 + 32) <= (963 + 139)) and (v122 == (1 + 1))) then
				if (((2605 + 2101) >= (170 + 793)) and v125 and (((v13:Rage() + v121) >= v123) or v94.DemoralizingShout:IsReady())) then
					v124 = true;
				end
				if (v124 or ((1777 - 817) <= (2787 - (340 + 1571)))) then
					if ((v102() and v103()) or ((815 + 1251) == (2704 - (1733 + 39)))) then
						if (((13258 - 8433) < (5877 - (125 + 909))) and v23(v94.IgnorePain, nil, nil, true)) then
							return "ignore_pain rage capped";
						end
					elseif (v23(v94.Revenge, not v98) or ((5825 - (1096 + 852)) >= (2036 + 2501))) then
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
			if ((v126 == (0 + 0)) or ((4827 - (409 + 103)) < (1962 - (46 + 190)))) then
				if ((v94.BitterImmunity:IsReady() and v60 and (v13:HealthPercentage() <= v70)) or ((3774 - (51 + 44)) < (177 + 448))) then
					if (v23(v94.BitterImmunity) or ((5942 - (1114 + 203)) < (1358 - (228 + 498)))) then
						return "bitter_immunity defensive";
					end
				end
				if ((v94.LastStand:IsCastable() and v63 and ((v13:HealthPercentage() <= v73) or v13:ActiveMitigationNeeded())) or ((18 + 65) > (984 + 796))) then
					if (((1209 - (174 + 489)) <= (2805 - 1728)) and v23(v94.LastStand)) then
						return "last_stand defensive";
					end
				end
				v126 = 1906 - (830 + 1075);
			end
			if ((v126 == (527 - (303 + 221))) or ((2265 - (231 + 1038)) > (3585 + 716))) then
				if (((5232 - (171 + 991)) > (2831 - 2144)) and v95.Healthstone:IsReady() and v67 and (v13:HealthPercentage() <= v79)) then
					if (v23(v96.Healthstone) or ((1761 - 1105) >= (8309 - 4979))) then
						return "healthstone defensive 3";
					end
				end
				if ((v68 and (v13:HealthPercentage() <= v80)) or ((1995 + 497) <= (1174 - 839))) then
					local v190 = 0 - 0;
					while true do
						if (((6966 - 2644) >= (7919 - 5357)) and (v190 == (1248 - (111 + 1137)))) then
							if ((v85 == "Refreshing Healing Potion") or ((3795 - (91 + 67)) >= (11220 - 7450))) then
								if (v95.RefreshingHealingPotion:IsReady() or ((594 + 1785) > (5101 - (423 + 100)))) then
									if (v23(v96.RefreshingHealingPotion) or ((4 + 479) > (2056 - 1313))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((1280 + 1174) > (1349 - (326 + 445))) and (v85 == "Dreamwalker's Healing Potion")) then
								if (((4058 - 3128) < (9931 - 5473)) and v95.DreamwalkersHealingPotion:IsReady()) then
									if (((1544 - 882) <= (1683 - (530 + 181))) and v23(v96.RefreshingHealingPotion)) then
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
			if (((5251 - (614 + 267)) == (4402 - (19 + 13))) and (v126 == (2 - 0))) then
				if ((v94.Intervene:IsReady() and v66 and (v16:HealthPercentage() <= v77) and (v16:UnitName() ~= v13:UnitName())) or ((11096 - 6334) <= (2459 - 1598))) then
					if (v23(v96.InterveneFocus) or ((367 + 1045) == (7498 - 3234))) then
						return "intervene defensive";
					end
				end
				if ((v94.ShieldWall:IsCastable() and v61 and v13:BuffDown(v94.ShieldWallBuff) and ((v13:HealthPercentage() <= v71) or v13:ActiveMitigationNeeded())) or ((6569 - 3401) < (3965 - (1293 + 519)))) then
					if (v23(v94.ShieldWall) or ((10152 - 5176) < (3477 - 2145))) then
						return "shield_wall defensive";
					end
				end
				v126 = 5 - 2;
			end
			if (((19956 - 15328) == (10902 - 6274)) and (v126 == (1 + 0))) then
				if ((v94.IgnorePain:IsReady() and v64 and (v13:HealthPercentage() <= v74) and v103()) or ((12 + 42) == (917 - 522))) then
					if (((19 + 63) == (28 + 54)) and v23(v94.IgnorePain, nil, nil, true)) then
						return "ignore_pain defensive";
					end
				end
				if ((v94.RallyingCry:IsReady() and v65 and v13:BuffDown(v94.AspectsFavorBuff) and v13:BuffDown(v94.RallyingCry) and (((v13:HealthPercentage() <= v75) and v93.IsSoloMode()) or v93.AreUnitsBelowHealthPercentage(v75, v76))) or ((364 + 217) < (1378 - (709 + 387)))) then
					if (v23(v94.RallyingCry) or ((6467 - (673 + 1185)) < (7235 - 4740))) then
						return "rallying_cry defensive";
					end
				end
				v126 = 6 - 4;
			end
		end
	end
	local function v108()
		local v127 = 0 - 0;
		while true do
			if (((824 + 328) == (861 + 291)) and (v127 == (1 - 0))) then
				v28 = v93.HandleBottomTrinket(v97, v31, 10 + 30, nil);
				if (((3780 - 1884) <= (6717 - 3295)) and v28) then
					return v28;
				end
				break;
			end
			if ((v127 == (1880 - (446 + 1434))) or ((2273 - (1040 + 243)) > (4835 - 3215))) then
				v28 = v93.HandleTopTrinket(v97, v31, 1887 - (559 + 1288), nil);
				if (v28 or ((2808 - (609 + 1322)) > (5149 - (13 + 441)))) then
					return v28;
				end
				v127 = 3 - 2;
			end
		end
	end
	local function v109()
		if (((7048 - 4357) >= (9218 - 7367)) and v14:IsInMeleeRange(1 + 7)) then
			if ((v94.ThunderClap:IsCastable() and v45) or ((10840 - 7855) >= (1725 + 3131))) then
				if (((1874 + 2402) >= (3546 - 2351)) and v23(v94.ThunderClap)) then
					return "thunder_clap precombat";
				end
			end
		elseif (((1769 + 1463) <= (8625 - 3935)) and v34 and v94.Charge:IsCastable() and not v14:IsInRange(6 + 2)) then
			if (v23(v94.Charge, not v14:IsSpellInRange(v94.Charge)) or ((499 + 397) >= (2261 + 885))) then
				return "charge precombat";
			end
		end
	end
	local function v110()
		local v128 = 0 + 0;
		while true do
			if (((2995 + 66) >= (3391 - (153 + 280))) and (v128 == (5 - 3))) then
				if (((2862 + 325) >= (255 + 389)) and v94.ShieldSlam:IsCastable() and v42 and ((v13:Rage() <= (32 + 28)) or (v13:BuffUp(v94.ViolentOutburstBuff) and (v100 <= (7 + 0))))) then
					v106(15 + 5);
					if (((980 - 336) <= (436 + 268)) and v23(v94.ShieldSlam, not v98)) then
						return "shield_slam aoe 8";
					end
				end
				if (((1625 - (89 + 578)) > (677 + 270)) and v94.ThunderClap:IsCastable() and v45) then
					local v191 = 0 - 0;
					while true do
						if (((5541 - (572 + 477)) >= (358 + 2296)) and (v191 == (0 + 0))) then
							v106(1 + 4);
							if (((3528 - (84 + 2)) >= (2476 - 973)) and v23(v94.ThunderClap, not v14:IsInMeleeRange(6 + 2))) then
								return "thunder_clap aoe 10";
							end
							break;
						end
					end
				end
				v128 = 845 - (497 + 345);
			end
			if ((v128 == (0 + 0)) or ((536 + 2634) <= (2797 - (605 + 728)))) then
				if ((v94.ThunderClap:IsCastable() and v45 and (v14:DebuffRemains(v94.RendDebuff) <= (1 + 0))) or ((10664 - 5867) == (202 + 4186))) then
					local v192 = 0 - 0;
					while true do
						if (((497 + 54) <= (1886 - 1205)) and ((0 + 0) == v192)) then
							v106(494 - (457 + 32));
							if (((1391 + 1886) > (1809 - (832 + 570))) and v23(v94.ThunderClap, not v14:IsInMeleeRange(8 + 0))) then
								return "thunder_clap aoe 2";
							end
							break;
						end
					end
				end
				if (((1225 + 3470) >= (5007 - 3592)) and v94.ShieldSlam:IsCastable() and v42 and ((v13:HasTier(15 + 15, 798 - (588 + 208)) and (v100 <= (18 - 11))) or v13:BuffUp(v94.EarthenTenacityBuff))) then
					if (v23(v94.ShieldSlam, not v98) or ((5012 - (884 + 916)) <= (1975 - 1031))) then
						return "shield_slam aoe 3";
					end
				end
				v128 = 1 + 0;
			end
			if ((v128 == (654 - (232 + 421))) or ((4985 - (1569 + 320)) <= (442 + 1356))) then
				if (((672 + 2865) == (11918 - 8381)) and v94.ThunderClap:IsCastable() and v45 and v13:BuffUp(v94.ViolentOutburstBuff) and (v100 > (610 - (316 + 289))) and v13:BuffUp(v94.AvatarBuff) and v94.UnstoppableForce:IsAvailable()) then
					v106(13 - 8);
					if (((178 + 3659) >= (3023 - (666 + 787))) and v23(v94.ThunderClap, not v14:IsInMeleeRange(433 - (360 + 65)))) then
						return "thunder_clap aoe 4";
					end
				end
				if ((v94.Revenge:IsReady() and v40 and (v13:Rage() >= (66 + 4)) and v94.SeismicReverberation:IsAvailable() and (v100 >= (257 - (79 + 175)))) or ((4651 - 1701) == (2975 + 837))) then
					if (((14476 - 9753) >= (4464 - 2146)) and v23(v94.Revenge, not v98)) then
						return "revenge aoe 6";
					end
				end
				v128 = 901 - (503 + 396);
			end
			if ((v128 == (184 - (92 + 89))) or ((3932 - 1905) > (1463 + 1389))) then
				if ((v94.Revenge:IsReady() and v40 and ((v13:Rage() >= (18 + 12)) or ((v13:Rage() >= (156 - 116)) and v94.BarbaricTraining:IsAvailable()))) or ((156 + 980) > (9843 - 5526))) then
					if (((4143 + 605) == (2268 + 2480)) and v23(v94.Revenge, not v98)) then
						return "revenge aoe 12";
					end
				end
				break;
			end
		end
	end
	local function v111()
		if (((11378 - 7642) <= (592 + 4148)) and v94.ShieldSlam:IsCastable() and v42) then
			local v172 = 0 - 0;
			while true do
				if (((1244 - (485 + 759)) == v172) or ((7844 - 4454) <= (4249 - (442 + 747)))) then
					v106(1155 - (832 + 303));
					if (v23(v94.ShieldSlam, not v98) or ((1945 - (88 + 858)) > (821 + 1872))) then
						return "shield_slam generic 2";
					end
					break;
				end
			end
		end
		if (((384 + 79) < (25 + 576)) and v94.ThunderClap:IsCastable() and v45 and (v14:DebuffRemains(v94.RendDebuff) <= (790 - (766 + 23))) and v13:BuffDown(v94.ViolentOutburstBuff)) then
			local v173 = 0 - 0;
			while true do
				if ((v173 == (0 - 0)) or ((5751 - 3568) < (2331 - 1644))) then
					v106(1078 - (1036 + 37));
					if (((3226 + 1323) == (8858 - 4309)) and v23(v94.ThunderClap, not v14:IsInMeleeRange(7 + 1))) then
						return "thunder_clap generic 4";
					end
					break;
				end
			end
		end
		if (((6152 - (641 + 839)) == (5585 - (910 + 3))) and v94.Execute:IsReady() and v37 and v13:BuffUp(v94.SuddenDeathBuff) and v94.SuddenDeath:IsAvailable()) then
			if (v23(v94.Execute, not v98) or ((9350 - 5682) < (2079 - (1466 + 218)))) then
				return "execute generic 6";
			end
		end
		if ((v94.Execute:IsReady() and v37 and (v100 == (1 + 0)) and (v94.Massacre:IsAvailable() or v94.Juggernaut:IsAvailable()) and (v13:Rage() >= (1198 - (556 + 592)))) or ((1482 + 2684) == (1263 - (329 + 479)))) then
			if (v23(v94.Execute, not v98) or ((5303 - (174 + 680)) == (9150 - 6487))) then
				return "execute generic 6";
			end
		end
		if ((v94.Execute:IsReady() and v37 and (v100 == (1 - 0)) and (v13:Rage() >= (36 + 14))) or ((5016 - (396 + 343)) < (265 + 2724))) then
			if (v23(v94.Execute, not v98) or ((2347 - (29 + 1448)) >= (5538 - (135 + 1254)))) then
				return "execute generic 10";
			end
		end
		if (((8332 - 6120) < (14861 - 11678)) and v94.ThunderClap:IsCastable() and v45 and ((v100 > (1 + 0)) or (v94.ShieldSlam:CooldownDown() and not v13:BuffUp(v94.ViolentOutburstBuff)))) then
			v106(1532 - (389 + 1138));
			if (((5220 - (102 + 472)) > (2824 + 168)) and v23(v94.ThunderClap, not v14:IsInMeleeRange(5 + 3))) then
				return "thunder_clap generic 12";
			end
		end
		if (((1338 + 96) < (4651 - (320 + 1225))) and v94.Revenge:IsReady() and v40 and (((v13:Rage() >= (106 - 46)) and (v14:HealthPercentage() > (13 + 7))) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() <= (1484 - (157 + 1307))) and (v13:Rage() <= (1877 - (821 + 1038))) and v94.ShieldSlam:CooldownDown()) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() > (49 - 29))) or ((((v13:Rage() >= (7 + 53)) and (v14:HealthPercentage() > (61 - 26))) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() <= (14 + 21)) and (v13:Rage() <= (44 - 26)) and v94.ShieldSlam:CooldownDown()) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() > (1061 - (834 + 192))))) and v94.Massacre:IsAvailable()))) then
			if (((50 + 736) < (776 + 2247)) and v23(v94.Revenge, not v98)) then
				return "revenge generic 14";
			end
		end
		if ((v94.Execute:IsReady() and v37 and (v100 == (1 + 0))) or ((3782 - 1340) < (378 - (300 + 4)))) then
			if (((1212 + 3323) == (11871 - 7336)) and v23(v94.Execute, not v98)) then
				return "execute generic 16";
			end
		end
		if ((v94.Revenge:IsReady() and v40 and (v14:HealthPercentage() > (382 - (112 + 250)))) or ((1200 + 1809) <= (5273 - 3168))) then
			if (((1049 + 781) < (1898 + 1771)) and v23(v94.Revenge, not v98)) then
				return "revenge generic 18";
			end
		end
		if ((v94.ThunderClap:IsCastable() and v45 and ((v100 >= (1 + 0)) or (v94.ShieldSlam:CooldownDown() and v13:BuffUp(v94.ViolentOutburstBuff)))) or ((710 + 720) >= (2684 + 928))) then
			local v174 = 1414 - (1001 + 413);
			while true do
				if (((5982 - 3299) >= (3342 - (244 + 638))) and (v174 == (693 - (627 + 66)))) then
					v106(14 - 9);
					if (v23(v94.ThunderClap, not v14:IsInMeleeRange(610 - (512 + 90))) or ((3710 - (1665 + 241)) >= (3992 - (373 + 344)))) then
						return "thunder_clap generic 20";
					end
					break;
				end
			end
		end
		if ((v94.Devastate:IsCastable() and v36) or ((640 + 777) > (961 + 2668))) then
			if (((12647 - 7852) > (679 - 277)) and v23(v94.Devastate, not v98)) then
				return "devastate generic 22";
			end
		end
	end
	local function v112()
		if (((5912 - (35 + 1064)) > (2594 + 971)) and not v13:AffectingCombat()) then
			local v175 = 0 - 0;
			while true do
				if (((16 + 3896) == (5148 - (298 + 938))) and (v175 == (1259 - (233 + 1026)))) then
					if (((4487 - (636 + 1030)) <= (2467 + 2357)) and v94.BattleShout:IsCastable() and v33 and (v13:BuffDown(v94.BattleShoutBuff, true) or v93.GroupBuffMissing(v94.BattleShoutBuff))) then
						if (((1698 + 40) <= (653 + 1542)) and v23(v94.BattleShout)) then
							return "battle_shout precombat";
						end
					end
					if (((3 + 38) <= (3239 - (55 + 166))) and v92 and v94.BattleStance:IsCastable() and not v13:BuffUp(v94.BattleStance)) then
						if (((416 + 1729) <= (413 + 3691)) and v23(v94.BattleStance)) then
							return "battle_stance precombat";
						end
					end
					break;
				end
			end
		end
		if (((10269 - 7580) < (5142 - (36 + 261))) and v93.TargetIsValid() and v29) then
			if (not v13:AffectingCombat() or ((4060 - 1738) > (3990 - (34 + 1334)))) then
				local v187 = 0 + 0;
				while true do
					if (((0 + 0) == v187) or ((5817 - (1035 + 248)) == (2103 - (20 + 1)))) then
						v28 = v109();
						if (v28 or ((819 + 752) > (2186 - (134 + 185)))) then
							return v28;
						end
						break;
					end
				end
			end
		end
	end
	local function v113()
		local v129 = 1133 - (549 + 584);
		while true do
			if ((v129 == (686 - (314 + 371))) or ((9111 - 6457) >= (3964 - (478 + 490)))) then
				if (((2108 + 1870) > (3276 - (786 + 386))) and v84) then
					local v193 = 0 - 0;
					while true do
						if (((4374 - (1055 + 324)) > (2881 - (1093 + 247))) and (v193 == (1 + 0))) then
							v28 = v93.HandleIncorporeal(v94.IntimidatingShout, v96.IntimidatingShoutMouseover, 1 + 7, true);
							if (((12899 - 9650) > (3233 - 2280)) and v28) then
								return v28;
							end
							break;
						end
						if ((v193 == (0 - 0)) or ((8224 - 4951) > (1627 + 2946))) then
							v28 = v93.HandleIncorporeal(v94.StormBolt, v96.StormBoltMouseover, 77 - 57, true);
							if (v28 or ((10860 - 7709) < (969 + 315))) then
								return v28;
							end
							v193 = 2 - 1;
						end
					end
				end
				if (v93.TargetIsValid() or ((2538 - (364 + 324)) == (4191 - 2662))) then
					local v194 = 0 - 0;
					local v195;
					while true do
						if (((273 + 548) < (8883 - 6760)) and (v194 == (9 - 3))) then
							v28 = v111();
							if (((2739 - 1837) < (3593 - (1249 + 19))) and v28) then
								return v28;
							end
							if (((775 + 83) <= (11529 - 8567)) and v19.CastAnnotated(v94.Pool, false, "WAIT")) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((v194 == (1089 - (686 + 400))) or ((3097 + 849) < (1517 - (73 + 156)))) then
							if ((v102() and v63 and v94.LastStand:IsCastable() and v13:BuffDown(v94.ShieldWallBuff) and (((v14:HealthPercentage() >= (1 + 89)) and v94.UnnervingFocus:IsAvailable()) or ((v14:HealthPercentage() <= (831 - (721 + 90))) and v94.UnnervingFocus:IsAvailable()) or v94.Bolster:IsAvailable() or v13:HasTier(1 + 29, 6 - 4))) or ((3712 - (224 + 246)) == (918 - 351))) then
								if (v23(v94.LastStand) or ((1559 - 712) >= (230 + 1033))) then
									return "last_stand defensive";
								end
							end
							if (((v89 < v91) and v39 and ((v51 and v31) or not v51) and (v82 == "player") and v94.Ravager:IsCastable()) or ((54 + 2199) == (1360 + 491))) then
								local v196 = 0 - 0;
								while true do
									if ((v196 == (0 - 0)) or ((2600 - (203 + 310)) > (4365 - (1238 + 755)))) then
										v106(1 + 9);
										if (v23(v96.RavagerPlayer, not v98) or ((5979 - (709 + 825)) < (7645 - 3496))) then
											return "ravager main 24";
										end
										break;
									end
								end
							end
							if (((v89 < v91) and v39 and ((v51 and v31) or not v51) and (v82 == "cursor") and v94.Ravager:IsCastable()) or ((2647 - 829) == (949 - (196 + 668)))) then
								local v197 = 0 - 0;
								while true do
									if (((1304 - 674) < (2960 - (171 + 662))) and (v197 == (93 - (4 + 89)))) then
										v106(35 - 25);
										if (v23(v96.RavagerCursor, not v98) or ((706 + 1232) == (11042 - 8528))) then
											return "ravager main 24";
										end
										break;
									end
								end
							end
							if (((1669 + 2586) >= (1541 - (35 + 1451))) and v94.DemoralizingShout:IsCastable() and v35 and v94.BoomingVoice:IsAvailable()) then
								local v198 = 1453 - (28 + 1425);
								while true do
									if (((4992 - (941 + 1052)) > (1109 + 47)) and (v198 == (1514 - (822 + 692)))) then
										v106(42 - 12);
										if (((1107 + 1243) > (1452 - (45 + 252))) and v23(v94.DemoralizingShout, not v98)) then
											return "demoralizing_shout main 28";
										end
										break;
									end
								end
							end
							v194 = 4 + 0;
						end
						if (((1387 + 2642) <= (11810 - 6957)) and (v194 == (437 - (114 + 319)))) then
							if (((v89 < v91) and v44 and ((v53 and v31) or not v53) and (v83 == "player") and v94.ChampionsSpear:IsCastable()) or ((740 - 224) > (4399 - 965))) then
								local v199 = 0 + 0;
								while true do
									if (((6027 - 1981) >= (6354 - 3321)) and (v199 == (1963 - (556 + 1407)))) then
										v106(1226 - (741 + 465));
										if (v23(v96.ChampionsSpearPlayer, not v98) or ((3184 - (170 + 295)) <= (763 + 684))) then
											return "spear_of_bastion main 28";
										end
										break;
									end
								end
							end
							if (((v89 < v91) and v44 and ((v53 and v31) or not v53) and (v83 == "cursor") and v94.ChampionsSpear:IsCastable()) or ((3798 + 336) < (9665 - 5739))) then
								local v200 = 0 + 0;
								while true do
									if ((v200 == (0 + 0)) or ((93 + 71) >= (4015 - (957 + 273)))) then
										v106(6 + 14);
										if (v23(v96.ChampionsSpearCursor, not v98) or ((211 + 314) == (8036 - 5927))) then
											return "spear_of_bastion main 28";
										end
										break;
									end
								end
							end
							if (((86 - 53) == (100 - 67)) and (v89 < v91) and v46 and ((v54 and v31) or not v54) and v94.ThunderousRoar:IsCastable()) then
								if (((15122 - 12068) <= (5795 - (389 + 1391))) and v23(v94.ThunderousRoar, not v14:IsInMeleeRange(6 + 2))) then
									return "thunderous_roar main 30";
								end
							end
							if (((195 + 1676) < (7699 - 4317)) and v94.ShieldSlam:IsCastable() and v42 and v13:BuffUp(v94.FervidBuff)) then
								if (((2244 - (783 + 168)) <= (7269 - 5103)) and v23(v94.ShieldSlam, not v98)) then
									return "shield_slam main 31";
								end
							end
							v194 = 5 + 0;
						end
						if ((v194 == (312 - (309 + 2))) or ((7919 - 5340) < (1335 - (1090 + 122)))) then
							if ((v89 < v91) or ((275 + 571) >= (7952 - 5584))) then
								local v201 = 0 + 0;
								while true do
									if ((v201 == (1118 - (628 + 490))) or ((720 + 3292) <= (8314 - 4956))) then
										if (((6827 - 5333) <= (3779 - (431 + 343))) and v48 and ((v31 and v55) or not v55)) then
											v28 = v108();
											if (v28 or ((6282 - 3171) == (6173 - 4039))) then
												return v28;
											end
										end
										if (((1861 + 494) == (302 + 2053)) and v31 and v95.FyralathTheDreamrender:IsEquippedAndReady()) then
											if (v23(v96.UseWeapon) or ((2283 - (556 + 1139)) <= (447 - (6 + 9)))) then
												return "Fyralath The Dreamrender used";
											end
										end
										break;
									end
								end
							end
							if (((879 + 3918) >= (1996 + 1899)) and v38 and v94.HeroicThrow:IsCastable() and not v14:IsInRange(194 - (28 + 141))) then
								if (((1386 + 2191) == (4414 - 837)) and v23(v94.HeroicThrow, not v14:IsSpellInRange(v94.HeroicThrow))) then
									return "heroic_throw main";
								end
							end
							if (((2688 + 1106) > (5010 - (486 + 831))) and v94.WreckingThrow:IsCastable() and v47 and v13:CanAttack(v14) and v101()) then
								if (v23(v94.WreckingThrow, not v14:IsSpellInRange(v94.WreckingThrow)) or ((3317 - 2042) == (14434 - 10334))) then
									return "wrecking_throw main";
								end
							end
							if (((v89 < v91) and v32 and ((v50 and v31) or not v50) and v94.Avatar:IsCastable()) or ((301 + 1290) >= (11319 - 7739))) then
								if (((2246 - (668 + 595)) <= (1627 + 181)) and v23(v94.Avatar)) then
									return "avatar main 2";
								end
							end
							v194 = 1 + 1;
						end
						if ((v194 == (13 - 8)) or ((2440 - (23 + 267)) <= (3141 - (1129 + 815)))) then
							if (((4156 - (371 + 16)) >= (2923 - (1326 + 424))) and ((v94.Shockwave:IsCastable() and v43 and v13:BuffUp(v94.AvatarBuff) and v94.UnstoppableForce:IsAvailable() and not v94.RumblingEarth:IsAvailable()) or (v94.SonicBoom:IsAvailable() and v94.RumblingEarth:IsAvailable() and (v100 >= (5 - 2)) and v14:IsCasting()))) then
								v106(36 - 26);
								if (((1603 - (88 + 30)) == (2256 - (720 + 51))) and v23(v94.Shockwave, not v14:IsInMeleeRange(17 - 9))) then
									return "shockwave main 32";
								end
							end
							if (((v89 < v91) and v94.ShieldCharge:IsCastable() and v41 and ((v52 and v31) or not v52)) or ((5091 - (421 + 1355)) <= (4588 - 1806))) then
								if (v23(v94.ShieldCharge, not v14:IsSpellInRange(v94.ShieldCharge)) or ((431 + 445) >= (4047 - (286 + 797)))) then
									return "shield_charge main 34";
								end
							end
							if ((v105() and v62) or ((8159 - 5927) > (4135 - 1638))) then
								if (v23(v94.ShieldBlock) or ((2549 - (397 + 42)) <= (104 + 228))) then
									return "shield_block main 38";
								end
							end
							if (((4486 - (24 + 776)) > (4886 - 1714)) and (v100 > (788 - (222 + 563)))) then
								local v202 = 0 - 0;
								while true do
									if (((0 + 0) == v202) or ((4664 - (23 + 167)) < (2618 - (690 + 1108)))) then
										v28 = v110();
										if (((1544 + 2735) >= (2378 + 504)) and v28) then
											return v28;
										end
										v202 = 849 - (40 + 808);
									end
									if (((1 + 0) == v202) or ((7758 - 5729) >= (3366 + 155))) then
										if (v19.CastAnnotated(v94.Pool, false, "WAIT") or ((1078 + 959) >= (2546 + 2096))) then
											return "Pool for Aoe()";
										end
										break;
									end
								end
							end
							v194 = 577 - (47 + 524);
						end
						if (((1117 + 603) < (12186 - 7728)) and (v194 == (2 - 0))) then
							if (((v89 < v91) and v49 and ((v56 and v31) or not v56)) or ((994 - 558) > (4747 - (1165 + 561)))) then
								local v203 = 0 + 0;
								while true do
									if (((2208 - 1495) <= (324 + 523)) and (v203 == (480 - (341 + 138)))) then
										if (((582 + 1572) <= (8318 - 4287)) and v94.ArcaneTorrent:IsCastable()) then
											if (((4941 - (89 + 237)) == (14846 - 10231)) and v23(v94.ArcaneTorrent)) then
												return "arcane_torrent main 8";
											end
										end
										if (v94.LightsJudgment:IsCastable() or ((7979 - 4189) == (1381 - (581 + 300)))) then
											if (((1309 - (855 + 365)) < (524 - 303)) and v23(v94.LightsJudgment)) then
												return "lights_judgment main 10";
											end
										end
										v203 = 1 + 1;
									end
									if (((3289 - (1030 + 205)) >= (1335 + 86)) and (v203 == (0 + 0))) then
										if (((978 - (156 + 130)) < (6948 - 3890)) and v94.BloodFury:IsCastable()) then
											if (v23(v94.BloodFury) or ((5483 - 2229) == (3389 - 1734))) then
												return "blood_fury main 4";
											end
										end
										if (v94.Berserking:IsCastable() or ((342 + 954) == (2864 + 2046))) then
											if (((3437 - (10 + 59)) == (953 + 2415)) and v23(v94.Berserking)) then
												return "berserking main 6";
											end
										end
										v203 = 4 - 3;
									end
									if (((3806 - (671 + 492)) < (3037 + 778)) and (v203 == (1218 - (369 + 846)))) then
										if (((507 + 1406) > (421 + 72)) and v94.BagofTricks:IsCastable()) then
											if (((6700 - (1036 + 909)) > (2726 + 702)) and v23(v94.BagofTricks)) then
												return "ancestral_call main 16";
											end
										end
										break;
									end
									if (((2318 - 937) <= (2572 - (11 + 192))) and (v203 == (2 + 0))) then
										if (v94.Fireblood:IsCastable() or ((5018 - (135 + 40)) == (9894 - 5810))) then
											if (((2815 + 1854) > (799 - 436)) and v23(v94.Fireblood)) then
												return "fireblood main 12";
											end
										end
										if (v94.AncestralCall:IsCastable() or ((2813 - 936) >= (3314 - (50 + 126)))) then
											if (((13204 - 8462) >= (803 + 2823)) and v23(v94.AncestralCall)) then
												return "ancestral_call main 14";
											end
										end
										v203 = 1416 - (1233 + 180);
									end
								end
							end
							v195 = v93.HandleDPSPotion(v14:BuffUp(v94.AvatarBuff));
							if (v195 or ((5509 - (522 + 447)) == (2337 - (107 + 1314)))) then
								return v195;
							end
							if ((v94.IgnorePain:IsReady() and v64 and v103() and (v14:HealthPercentage() >= (10 + 10)) and (((v13:RageDeficit() <= (45 - 30)) and v94.ShieldSlam:CooldownUp()) or ((v13:RageDeficit() <= (17 + 23)) and v94.ShieldCharge:CooldownUp() and v94.ChampionsBulwark:IsAvailable()) or ((v13:RageDeficit() <= (39 - 19)) and v94.ShieldCharge:CooldownUp()) or ((v13:RageDeficit() <= (118 - 88)) and v94.DemoralizingShout:CooldownUp() and v94.BoomingVoice:IsAvailable()) or ((v13:RageDeficit() <= (1930 - (716 + 1194))) and v94.Avatar:CooldownUp()) or ((v13:RageDeficit() <= (1 + 44)) and v94.DemoralizingShout:CooldownUp() and v94.BoomingVoice:IsAvailable() and v13:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable()) or ((v13:RageDeficit() <= (4 + 26)) and v94.Avatar:CooldownUp() and v13:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable()) or (v13:RageDeficit() <= (523 - (74 + 429))) or ((v13:RageDeficit() <= (77 - 37)) and v94.ShieldSlam:CooldownUp() and v13:BuffUp(v94.ViolentOutburstBuff) and v94.HeavyRepercussions:IsAvailable() and v94.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (28 + 27)) and v94.ShieldSlam:CooldownUp() and v13:BuffUp(v94.ViolentOutburstBuff) and v13:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable() and v94.HeavyRepercussions:IsAvailable() and v94.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (38 - 21)) and v94.ShieldSlam:CooldownUp() and v94.HeavyRepercussions:IsAvailable()) or ((v13:RageDeficit() <= (13 + 5)) and v94.ShieldSlam:CooldownUp() and v94.ImpenetrableWall:IsAvailable()))) or ((3563 - 2407) > (10743 - 6398))) then
								if (((2670 - (279 + 154)) < (5027 - (454 + 324))) and v23(v94.IgnorePain, nil, nil, true)) then
									return "ignore_pain main 20";
								end
							end
							v194 = 3 + 0;
						end
						if ((v194 == (17 - (12 + 5))) or ((1447 + 1236) < (58 - 35))) then
							if (((258 + 439) <= (1919 - (277 + 816))) and v92 and (v13:HealthPercentage() <= v78)) then
								if (((4721 - 3616) <= (2359 - (1058 + 125))) and v94.DefensiveStance:IsCastable() and not v13:BuffUp(v94.DefensiveStance)) then
									if (((634 + 2745) <= (4787 - (815 + 160))) and v23(v94.DefensiveStance)) then
										return "defensive_stance while tanking";
									end
								end
							end
							if ((v92 and (v13:HealthPercentage() > v78)) or ((3380 - 2592) >= (3835 - 2219))) then
								if (((443 + 1411) <= (9877 - 6498)) and v94.BattleStance:IsCastable() and not v13:BuffUp(v94.BattleStance)) then
									if (((6447 - (41 + 1857)) == (6442 - (1222 + 671))) and v23(v94.BattleStance)) then
										return "battle_stance while not tanking";
									end
								end
							end
							if ((v41 and ((v52 and v31) or not v52) and (v89 < v91) and v94.ShieldCharge:IsCastable() and not v98) or ((7810 - 4788) >= (4346 - 1322))) then
								if (((6002 - (229 + 953)) > (3972 - (1111 + 663))) and v23(v94.ShieldCharge, not v14:IsSpellInRange(v94.ShieldCharge))) then
									return "shield_charge main 34";
								end
							end
							if ((v34 and v94.Charge:IsCastable() and not v98) or ((2640 - (874 + 705)) >= (685 + 4206))) then
								if (((931 + 433) <= (9297 - 4824)) and v23(v94.Charge, not v14:IsSpellInRange(v94.Charge))) then
									return "charge main 34";
								end
							end
							v194 = 1 + 0;
						end
					end
				end
				break;
			end
			if (((679 - (642 + 37)) == v129) or ((820 + 2775) <= (1 + 2))) then
				v28 = v107();
				if (v28 or ((11730 - 7058) == (4306 - (233 + 221)))) then
					return v28;
				end
				v129 = 2 - 1;
			end
		end
	end
	local function v114()
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
		v70 = EpicSettings.Settings['bitterImmunityHP'] or (0 + 0);
		v74 = EpicSettings.Settings['ignorePainHP'] or (1541 - (718 + 823));
		v77 = EpicSettings.Settings['interveneHP'] or (0 + 0);
		v73 = EpicSettings.Settings['lastStandHP'] or (805 - (266 + 539));
		v76 = EpicSettings.Settings['rallyingCryGroup'] or (0 - 0);
		v75 = EpicSettings.Settings['rallyingCryHP'] or (1225 - (636 + 589));
		v72 = EpicSettings.Settings['shieldBlockHP'] or (0 - 0);
		v71 = EpicSettings.Settings['shieldWallHP'] or (0 - 0);
		v81 = EpicSettings.Settings['victoryRushHP'] or (0 + 0);
		v78 = EpicSettings.Settings['defensiveStanceHP'] or (0 + 0);
		v82 = EpicSettings.Settings['ravagerSetting'] or "";
		v83 = EpicSettings.Settings['spearSetting'] or "";
	end
	local function v116()
		local v163 = 1015 - (657 + 358);
		while true do
			if (((4127 - 2568) == (3551 - 1992)) and (v163 == (1190 - (1151 + 36)))) then
				v85 = EpicSettings.Settings['HealingPotionName'] or "";
				v84 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v163 == (1 + 0)) or ((461 + 1291) <= (2353 - 1565))) then
				v48 = EpicSettings.Settings['useTrinkets'];
				v49 = EpicSettings.Settings['useRacials'];
				v55 = EpicSettings.Settings['trinketsWithCD'];
				v56 = EpicSettings.Settings['racialsWithCD'];
				v163 = 1834 - (1552 + 280);
			end
			if (((834 - (64 + 770)) == v163) or ((2653 + 1254) == (401 - 224))) then
				v89 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v86 = EpicSettings.Settings['InterruptWithStun'];
				v87 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v88 = EpicSettings.Settings['InterruptThreshold'];
				v163 = 1244 - (157 + 1086);
			end
			if (((6945 - 3475) > (2430 - 1875)) and ((2 - 0) == v163)) then
				v67 = EpicSettings.Settings['useHealthstone'];
				v68 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v80 = EpicSettings.Settings['healingPotionHP'] or (819 - (599 + 220));
				v163 = 5 - 2;
			end
		end
	end
	local function v117()
		v115();
		v114();
		v116();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		if (v13:IsDeadOrGhost() or ((2903 - (1813 + 118)) == (472 + 173))) then
			return v28;
		end
		if (((4399 - (841 + 376)) >= (2963 - 848)) and v30) then
			local v176 = 0 + 0;
			while true do
				if (((10625 - 6732) < (5288 - (464 + 395))) and (v176 == (0 - 0))) then
					v99 = v13:GetEnemiesInMeleeRange(4 + 4);
					v100 = #v99;
					break;
				end
			end
		else
			v100 = 838 - (467 + 370);
		end
		v98 = v14:IsInMeleeRange(16 - 8);
		if (v93.TargetIsValid() or v13:AffectingCombat() or ((2105 + 762) < (6530 - 4625))) then
			v90 = v10.BossFightRemains(nil, true);
			v91 = v90;
			if ((v91 == (1734 + 9377)) or ((4178 - 2382) >= (4571 - (150 + 370)))) then
				v91 = v10.FightRemains(v99, false);
			end
		end
		if (((2901 - (74 + 1208)) <= (9238 - 5482)) and not v13:IsChanneling()) then
			if (((2864 - 2260) == (430 + 174)) and v13:AffectingCombat()) then
				local v188 = 390 - (14 + 376);
				while true do
					if (((0 - 0) == v188) or ((2902 + 1582) == (791 + 109))) then
						v28 = v113();
						if (v28 or ((4253 + 206) <= (3261 - 2148))) then
							return v28;
						end
						break;
					end
				end
			else
				local v189 = 0 + 0;
				while true do
					if (((3710 - (23 + 55)) > (8052 - 4654)) and (v189 == (0 + 0))) then
						v28 = v112();
						if (((3666 + 416) <= (7623 - 2706)) and v28) then
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
	v19.SetAPL(23 + 50, v117, v118);
end;
return v0["Epix_Warrior_Protection.lua"]();

