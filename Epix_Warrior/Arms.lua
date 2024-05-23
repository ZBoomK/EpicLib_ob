local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((4236 - 2664) >= (3331 - (884 + 916))) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Warrior_Arms.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.TargetTarget;
	local v16 = v11.Focus;
	local v17 = v9.Spell;
	local v18 = v9.Item;
	local v19 = EpicLib;
	local v20 = v19.Bind;
	local v21 = v19.Cast;
	local v22 = v19.Macro;
	local v23 = v19.Press;
	local v24 = v19.Commons.Everyone.num;
	local v25 = v19.Commons.Everyone.bool;
	local v26;
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v30;
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
	local v93 = v9.Commons.Everyone;
	local v94 = v13:GetEquipment();
	local v95 = (v94[27 - 14] and v18(v94[8 + 5])) or v18(653 - (232 + 421));
	local v96 = (v94[1903 - (1569 + 320)] and v18(v94[4 + 10])) or v18(0 + 0);
	local v97 = v17.Warrior.Arms;
	local v98 = v18.Warrior.Arms;
	local v99 = v22.Warrior.Arms;
	local v100 = {};
	local v101;
	local v102 = 37441 - 26330;
	local v103 = 11716 - (316 + 289);
	v9:RegisterForEvent(function()
		local v123 = 0 - 0;
		while true do
			if ((v123 == (0 + 0)) or ((6140 - (666 + 787)) < (4967 - (360 + 65)))) then
				v102 = 10384 + 727;
				v103 = 11365 - (79 + 175);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v94 = v13:GetEquipment();
		v95 = (v94[19 - 6] and v18(v94[11 + 2])) or v18(0 - 0);
		v96 = (v94[26 - 12] and v18(v94[913 - (503 + 396)])) or v18(181 - (92 + 89));
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v104;
	local v105;
	local function v106()
		local v124 = UnitGetTotalAbsorbs(v14:ID());
		if (((6384 - 3093) > (855 + 812)) and (v124 > (0 + 0))) then
			return true;
		else
			return false;
		end
	end
	local function v107(v125)
		return (v125:HealthPercentage() > (78 - 58)) or (v97.Massacre:IsAvailable() and (v125:HealthPercentage() < (5 + 30)));
	end
	local function v108(v126)
		return (v126:DebuffStack(v97.ExecutionersPrecisionDebuff) == (4 - 2)) or (v126:DebuffRemains(v97.DeepWoundsDebuff) <= v13:GCD()) or (v105 <= (2 + 0));
	end
	local function v109(v127)
		return v13:BuffUp(v97.SuddenDeathBuff) or (v127:HealthPercentage() < (10 + 10)) or (v97.Massacre:IsAvailable() and (v127:HealthPercentage() < (106 - 71))) or v13:BuffUp(v97.SweepingStrikesBuff) or (v105 <= (1 + 1));
	end
	local function v110()
		local v128 = 0 - 0;
		while true do
			if ((v128 == (1246 - (485 + 759))) or ((2019 - 1146) == (3223 - (442 + 747)))) then
				if ((v97.Intervene:IsCastable() and v67 and (v16:HealthPercentage() <= v77) and (v16:Name() ~= v13:Name())) or ((3951 - (832 + 303)) < (957 - (88 + 858)))) then
					if (((1128 + 2571) < (3895 + 811)) and v23(v99.InterveneFocus)) then
						return "intervene defensive";
					end
				end
				if (((109 + 2537) >= (1665 - (766 + 23))) and v97.DefensiveStance:IsCastable() and v13:BuffDown(v97.DefensiveStance, true) and v68 and (v13:HealthPercentage() <= v78)) then
					if (((3031 - 2417) <= (4354 - 1170)) and v23(v97.DefensiveStance)) then
						return "defensive_stance defensive";
					end
				end
				v128 = 7 - 4;
			end
			if (((10609 - 7483) == (4199 - (1036 + 37))) and (v128 == (1 + 0))) then
				if ((v97.IgnorePain:IsCastable() and v65 and (v13:HealthPercentage() <= v74)) or ((4258 - 2071) >= (3897 + 1057))) then
					if (v23(v97.IgnorePain, nil, nil, true) or ((5357 - (641 + 839)) == (4488 - (910 + 3)))) then
						return "ignore_pain defensive";
					end
				end
				if (((1802 - 1095) > (2316 - (1466 + 218))) and v97.RallyingCry:IsCastable() and v66 and v13:BuffDown(v97.AspectsFavorBuff) and v13:BuffDown(v97.RallyingCry) and (((v13:HealthPercentage() <= v75) and v93.IsSoloMode()) or v93.AreUnitsBelowHealthPercentage(v75, v76, v97.Intervene))) then
					if (v23(v97.RallyingCry) or ((251 + 295) >= (3832 - (556 + 592)))) then
						return "rallying_cry defensive";
					end
				end
				v128 = 1 + 1;
			end
			if (((2273 - (329 + 479)) <= (5155 - (174 + 680))) and (v128 == (13 - 9))) then
				if (((3531 - 1827) > (1018 + 407)) and v70 and (v13:HealthPercentage() <= v80)) then
					local v192 = 739 - (396 + 343);
					while true do
						if ((v192 == (0 + 0)) or ((2164 - (29 + 1448)) == (5623 - (135 + 1254)))) then
							if ((v86 == "Refreshing Healing Potion") or ((12544 - 9214) < (6672 - 5243))) then
								if (((765 + 382) >= (1862 - (389 + 1138))) and v98.RefreshingHealingPotion:IsReady()) then
									if (((4009 - (102 + 472)) > (1979 + 118)) and v23(v99.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v86 == "Dreamwalker's Healing Potion") or ((2091 + 1679) >= (3768 + 273))) then
								if (v98.DreamwalkersHealingPotion:IsReady() or ((5336 - (320 + 1225)) <= (2867 - 1256))) then
									if (v23(v99.RefreshingHealingPotion) or ((2802 + 1776) <= (3472 - (157 + 1307)))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							v192 = 1860 - (821 + 1038);
						end
						if (((2806 - 1681) <= (228 + 1848)) and (v192 == (1 - 0))) then
							if ((v86 == "Potion of Withering Dreams") or ((277 + 466) >= (10903 - 6504))) then
								if (((2181 - (834 + 192)) < (107 + 1566)) and v98.PotionOfWitheringDreams:IsReady()) then
									if (v23(v99.RefreshingHealingPotion) or ((597 + 1727) <= (13 + 565))) then
										return "potion of withering dreams defensive";
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((5835 - 2068) == (4071 - (300 + 4))) and (v128 == (0 + 0))) then
				if (((10703 - 6614) == (4451 - (112 + 250))) and v97.BitterImmunity:IsReady() and v63 and (v13:HealthPercentage() <= v72)) then
					if (((1778 + 2680) >= (4193 - 2519)) and v23(v97.BitterImmunity)) then
						return "bitter_immunity defensive";
					end
				end
				if (((557 + 415) <= (734 + 684)) and v97.DieByTheSword:IsCastable() and v64 and (v13:HealthPercentage() <= v73)) then
					if (v23(v97.DieByTheSword) or ((3694 + 1244) < (2362 + 2400))) then
						return "die_by_the_sword defensive";
					end
				end
				v128 = 1 + 0;
			end
			if ((v128 == (1417 - (1001 + 413))) or ((5583 - 3079) > (5146 - (244 + 638)))) then
				if (((2846 - (627 + 66)) == (6414 - 4261)) and v97.BattleStance:IsCastable() and v13:BuffDown(v97.BattleStance, true) and v68 and (v13:HealthPercentage() > v81)) then
					if (v23(v97.BattleStance) or ((1109 - (512 + 90)) >= (4497 - (1665 + 241)))) then
						return "battle_stance after defensive stance defensive";
					end
				end
				if (((5198 - (373 + 344)) == (2022 + 2459)) and v98.Healthstone:IsReady() and v69 and (v13:HealthPercentage() <= v79)) then
					if (v23(v99.Healthstone) or ((616 + 1712) < (1827 - 1134))) then
						return "healthstone defensive 3";
					end
				end
				v128 = 6 - 2;
			end
		end
	end
	local function v111()
		v26 = v93.HandleTopTrinket(v100, v29, 1139 - (35 + 1064), nil);
		if (((3150 + 1178) == (9259 - 4931)) and v26) then
			return v26;
		end
		v26 = v93.HandleBottomTrinket(v100, v29, 1 + 39, nil);
		if (((2824 - (298 + 938)) >= (2591 - (233 + 1026))) and v26) then
			return v26;
		end
	end
	local function v112()
		local v129 = 1666 - (636 + 1030);
		while true do
			if ((v129 == (0 + 0)) or ((4078 + 96) > (1262 + 2986))) then
				if (v101 or ((310 + 4276) <= (303 - (55 + 166)))) then
					local v193 = 0 + 0;
					while true do
						if (((389 + 3474) == (14752 - 10889)) and (v193 == (297 - (36 + 261)))) then
							if ((v97.Skullsplitter:IsCastable() and v44) or ((492 - 210) <= (1410 - (34 + 1334)))) then
								if (((1772 + 2837) >= (596 + 170)) and v23(v97.Skullsplitter)) then
									return "skullsplitter precombat";
								end
							end
							if (((v90 < v103) and v97.ColossusSmash:IsCastable() and v36 and ((v54 and v29) or not v54)) or ((2435 - (1035 + 248)) == (2509 - (20 + 1)))) then
								if (((1783 + 1639) > (3669 - (134 + 185))) and v23(v97.ColossusSmash)) then
									return "colossus_smash precombat";
								end
							end
							v193 = 1134 - (549 + 584);
						end
						if (((1562 - (314 + 371)) > (1290 - 914)) and (v193 == (969 - (478 + 490)))) then
							if (((v90 < v103) and v97.Warbreaker:IsCastable() and v49 and ((v57 and v29) or not v57)) or ((1652 + 1466) <= (3023 - (786 + 386)))) then
								if (v23(v97.Warbreaker) or ((534 - 369) >= (4871 - (1055 + 324)))) then
									return "warbreaker precombat";
								end
							end
							if (((5289 - (1093 + 247)) < (4316 + 540)) and v97.Overpower:IsCastable() and v40) then
								if (v23(v97.Overpower) or ((450 + 3826) < (11974 - 8958))) then
									return "overpower precombat";
								end
							end
							break;
						end
					end
				end
				if (((15916 - 11226) > (11737 - 7612)) and v34 and v97.Charge:IsCastable()) then
					if (v23(v97.Charge) or ((125 - 75) >= (319 + 577))) then
						return "charge precombat";
					end
				end
				break;
			end
		end
	end
	local function v113()
		local v130 = 0 - 0;
		while true do
			if ((v130 == (20 - 14)) or ((1293 + 421) >= (7564 - 4606))) then
				if ((v97.Overpower:IsCastable() and v40) or ((2179 - (364 + 324)) < (1765 - 1121))) then
					if (((1689 - 985) < (328 + 659)) and v23(v97.Overpower, not v101)) then
						return "overpower execute 34";
					end
				end
				if (((15557 - 11839) > (3052 - 1146)) and (v90 < v103) and v33 and ((v53 and v29) or not v53) and v97.Bladestorm:IsCastable()) then
					if (v23(v97.Bladestorm, not v101) or ((2909 - 1951) > (4903 - (1249 + 19)))) then
						return "bladestorm execute 36";
					end
				end
				if (((3161 + 340) <= (17484 - 12992)) and v97.WreckingThrow:IsCastable() and v51 and v106()) then
					if (v23(v97.WreckingThrow, not v101) or ((4528 - (686 + 400)) < (2000 + 548))) then
						return "wrecking_throw execute 38";
					end
				end
				break;
			end
			if (((3104 - (73 + 156)) >= (7 + 1457)) and (v130 == (816 - (721 + 90)))) then
				if ((v97.Skullsplitter:IsCastable() and v44 and (v13:Rage() < (1 + 39))) or ((15575 - 10778) >= (5363 - (224 + 246)))) then
					if (v23(v97.Skullsplitter, not v14:IsInMeleeRange(12 - 4)) or ((1014 - 463) > (376 + 1692))) then
						return "skullsplitter execute 28";
					end
				end
				if (((51 + 2063) > (694 + 250)) and v97.Execute:IsReady() and v37) then
					if (v23(v97.Execute, not v101) or ((4496 - 2234) >= (10302 - 7206))) then
						return "execute execute 30";
					end
				end
				if ((v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable() or v14:IsCasting())) or ((2768 - (203 + 310)) >= (5530 - (1238 + 755)))) then
					if (v23(v97.Shockwave, not v14:IsInMeleeRange(1 + 7)) or ((5371 - (709 + 825)) < (2405 - 1099))) then
						return "shockwave execute 32";
					end
				end
				v130 = 8 - 2;
			end
			if (((3814 - (196 + 668)) == (11647 - 8697)) and (v130 == (5 - 2))) then
				if (((v90 < v103) and v48 and ((v56 and v29) or not v56) and v97.ThunderousRoar:IsCastable() and ((v97.TestofMight:IsAvailable() and (v13:Rage() < (873 - (171 + 662)))) or (not v97.TestofMight:IsAvailable() and (v13:BuffUp(v97.AvatarBuff) or v14:DebuffUp(v97.ColossusSmashDebuff)) and (v13:Rage() < (163 - (4 + 89)))))) or ((16553 - 11830) < (1201 + 2097))) then
					if (((4989 - 3853) >= (61 + 93)) and v23(v97.ThunderousRoar, not v14:IsInMeleeRange(1494 - (35 + 1451)))) then
						return "thunderous_roar execute 16";
					end
				end
				if ((v97.Cleave:IsReady() and (v105 > (1455 - (28 + 1425))) and (v14:DebuffRemains(v97.DeepWoundsDebuff) <= v13:GCD()) and v35) or ((2264 - (941 + 1052)) > (4553 + 195))) then
					if (((6254 - (822 + 692)) >= (4499 - 1347)) and v23(v97.Cleave, not v101)) then
						return "cleave execute 18";
					end
				end
				if (((v90 < v103) and v33 and ((v53 and v29) or not v53) and v97.Bladestorm:IsCastable() and (v13:Rage() < (19 + 21))) or ((2875 - (45 + 252)) >= (3355 + 35))) then
					if (((15 + 26) <= (4042 - 2381)) and v23(v97.Bladestorm, not v101)) then
						return "bladestorm execute 20";
					end
				end
				v130 = 437 - (114 + 319);
			end
			if (((862 - 261) < (4561 - 1001)) and ((2 + 0) == v130)) then
				if (((350 - 115) < (1439 - 752)) and (v90 < v103) and v83 and ((v55 and v29) or not v55) and (v84 == "cursor") and v97.ChampionsSpear:IsCastable() and (v14:DebuffUp(v97.ColossusSmashDebuff) or v13:BuffUp(v97.TestofMightBuff))) then
					if (((6512 - (556 + 1407)) > (2359 - (741 + 465))) and v23(v99.ChampionsSpearCursor, not v14:IsInRange(485 - (170 + 295)))) then
						return "spear_of_bastion execute 11";
					end
				end
				if (((v90 < v103) and v49 and ((v57 and v29) or not v57) and v97.Warbreaker:IsCastable()) or ((2463 + 2211) < (4292 + 380))) then
					if (((9030 - 5362) < (3781 + 780)) and v23(v97.Warbreaker, not v101)) then
						return "warbreaker execute 12";
					end
				end
				if (((v90 < v103) and v36 and ((v54 and v29) or not v54) and v97.ColossusSmash:IsCastable()) or ((292 + 163) == (2042 + 1563))) then
					if (v23(v97.ColossusSmash, not v101) or ((3893 - (957 + 273)) == (886 + 2426))) then
						return "colossus_smash execute 14";
					end
				end
				v130 = 2 + 1;
			end
			if (((16297 - 12020) <= (11792 - 7317)) and ((2 - 1) == v130)) then
				if ((v97.Rend:IsReady() and v41 and (v14:DebuffRemains(v97.RendDebuff) <= v13:GCD()) and not v97.Bloodletting:IsAvailable() and ((not v97.Warbreaker:IsAvailable() and (v97.ColossusSmash:CooldownRemains() < (19 - 15))) or (v97.Warbreaker:IsAvailable() and (v97.Warbreaker:CooldownRemains() < (1784 - (389 + 1391))))) and (v14:TimeToDie() > (8 + 4))) or ((91 + 779) == (2706 - 1517))) then
					if (((2504 - (783 + 168)) <= (10514 - 7381)) and v23(v97.Rend, not v101)) then
						return "rend execute 6";
					end
				end
				if (((v90 < v103) and v31 and ((v52 and v29) or not v52) and v97.Avatar:IsCastable() and (v97.ColossusSmash:CooldownUp() or v14:DebuffUp(v97.ColossusSmashDebuff) or (v103 < (20 + 0)))) or ((2548 - (309 + 2)) >= (10781 - 7270))) then
					if (v23(v97.Avatar, not v101) or ((2536 - (1090 + 122)) > (980 + 2040))) then
						return "avatar execute 8";
					end
				end
				if (((v90 < v103) and v83 and ((v55 and v29) or not v55) and (v84 == "player") and v97.ChampionsSpear:IsCastable() and (v97.ColossusSmash:CooldownRemains() <= v13:GCD())) or ((10048 - 7056) == (1288 + 593))) then
					if (((4224 - (628 + 490)) > (274 + 1252)) and v23(v99.ChampionsSpearPlayer, not v101)) then
						return "spear_of_bastion execute 10";
					end
				end
				v130 = 4 - 2;
			end
			if (((13815 - 10792) < (4644 - (431 + 343))) and (v130 == (7 - 3))) then
				if (((413 - 270) > (59 + 15)) and v97.MortalStrike:IsReady() and v39 and (v14:DebuffStack(v97.ExecutionersPrecisionDebuff) == (1 + 1))) then
					if (((1713 - (556 + 1139)) < (2127 - (6 + 9))) and v23(v97.MortalStrike, not v101)) then
						return "mortal_strike execute 22";
					end
				end
				if (((201 + 896) <= (834 + 794)) and v97.Execute:IsReady() and v37 and v13:BuffUp(v97.SuddenDeathBuff) and (v14:DebuffRemains(v97.DeepWoundsDebuff) > (169 - (28 + 141)))) then
					if (((1794 + 2836) == (5715 - 1085)) and v23(v97.Execute, not v101)) then
						return "execute execute 24";
					end
				end
				if (((2508 + 1032) > (4000 - (486 + 831))) and v97.Overpower:IsCastable() and v40 and (v13:Rage() < (104 - 64)) and (v13:BuffStack(v97.MartialProwessBuff) < (6 - 4))) then
					if (((906 + 3888) >= (10355 - 7080)) and v23(v97.Overpower, not v101)) then
						return "overpower execute 26";
					end
				end
				v130 = 1268 - (668 + 595);
			end
			if (((1336 + 148) == (300 + 1184)) and (v130 == (0 - 0))) then
				if (((1722 - (23 + 267)) < (5499 - (1129 + 815))) and v97.Whirlwind:IsReady() and v50 and v13:BuffUp(v97.CollateralDamageBuff) and (v97.SweepingStrikes:CooldownRemains() < (390 - (371 + 16)))) then
					if (v23(v97.Whirlwind, not v14:IsInMeleeRange(1758 - (1326 + 424))) or ((2016 - 951) > (13074 - 9496))) then
						return "whirlwind execute 1";
					end
				end
				if (((v90 < v103) and v46 and v97.SweepingStrikes:IsCastable() and (v105 > (119 - (88 + 30)))) or ((5566 - (720 + 51)) < (3129 - 1722))) then
					if (((3629 - (421 + 1355)) < (7940 - 3127)) and v23(v97.SweepingStrikes, not v14:IsInMeleeRange(4 + 4))) then
						return "sweeping_strikes execute 2";
					end
				end
				if ((v97.MortalStrike:IsReady() and v39 and (v14:DebuffRemains(v97.RendDebuff) <= v13:GCD()) and v97.Bloodletting:IsAvailable()) or ((3904 - (286 + 797)) < (8886 - 6455))) then
					if (v23(v97.MortalStrike, not v101) or ((4760 - 1886) < (2620 - (397 + 42)))) then
						return "mortal_strike execute 4";
					end
				end
				v130 = 1 + 0;
			end
		end
	end
	local function v114()
		if ((v97.Execute:IsReady() and v37 and v13:BuffUp(v97.JuggernautBuff) and (v13:BuffRemains(v97.JuggernautBuff) < v13:GCD()) and v13:HasTier(831 - (24 + 776), 5 - 1)) or ((3474 - (222 + 563)) <= (755 - 412))) then
			if (v23(v97.Execute, not v101) or ((1346 + 523) == (2199 - (23 + 167)))) then
				return "execute hac 2";
			end
		end
		if ((v97.Whirlwind:IsReady() and ((v13:BuffUp(v97.CollateralDamageBuff) and (v97.SweepingStrikes:CooldownRemains() < (1801 - (690 + 1108)))) or (v14:DebuffUp(v97.DeepWoundsDebuff) and v14:DebuffUp(v97.ColossusSmashDebuff) and v13:BuffDown(v97.SweepingStrikesBuff))) and v50) or ((1280 + 2266) < (1916 + 406))) then
			if (v23(v97.Whirlwind, not v14:IsInMeleeRange(856 - (40 + 808))) or ((343 + 1739) == (18251 - 13478))) then
				return "whirlwind hac 4";
			end
		end
		if (((3101 + 143) > (559 + 496)) and v97.ThunderClap:IsReady() and v47 and v97.BloodandThunder:IsAvailable() and v97.Rend:IsAvailable() and v14:DebuffRefreshable(v97.RendDebuff)) then
			if (v23(v97.ThunderClap, not v101) or ((1817 + 1496) <= (2349 - (47 + 524)))) then
				return "thunder_clap hac 6";
			end
		end
		if ((v97.SweepingStrikes:IsCastable() and v46 and ((v97.Bladestorm:CooldownRemains() > (10 + 5)) or (v97.ImprovedSweepingStrikes:IsAvailable() and (v97.Bladestorm:CooldownRemains() > (57 - 36))) or not v97.Bladestorm:IsAvailable()) and v14:DebuffUp(v97.RendDebuff) and (v14:DebuffUp(v97.ThunderousRoarDebuff) or (v97.ThunderousRoar:CooldownRemains() > (0 - 0))) and (v13:PrevGCD(2 - 1, v97.Cleave) or v13:BuffUp(v97.StrikeVulnerabilitiesBuff) or not v13:HasTier(1756 - (1165 + 561), 1 + 3))) or ((4401 - 2980) >= (803 + 1301))) then
			if (((2291 - (341 + 138)) <= (878 + 2371)) and v23(v97.SweepingStrikes, not v14:IsInMeleeRange(16 - 8))) then
				return "sweeping_strikes hac 8";
			end
		end
		if (((1949 - (89 + 237)) <= (6295 - 4338)) and (v90 < v103) and v31 and ((v52 and v29) or not v52) and v97.Avatar:IsCastable() and (v97.BlademastersTorment:IsAvailable() or (v103 < (42 - 22)) or (v13:BuffRemains(v97.HurricaneBuff) < (884 - (581 + 300))))) then
			if (((5632 - (855 + 365)) == (10479 - 6067)) and v23(v97.Avatar, not v101)) then
				return "avatar hac 10";
			end
		end
		if (((572 + 1178) >= (2077 - (1030 + 205))) and (v90 < v103) and v97.Warbreaker:IsCastable() and v49 and ((v57 and v29) or not v57) and (v105 > (1 + 0))) then
			if (((4068 + 304) > (2136 - (156 + 130))) and v23(v97.Warbreaker, not v101)) then
				return "warbreaker hac 12";
			end
		end
		if (((526 - 294) < (1383 - 562)) and (v90 < v103) and v36 and ((v54 and v29) or not v54) and v97.ColossusSmash:IsCastable()) then
			local v137 = 0 - 0;
			while true do
				if (((137 + 381) < (526 + 376)) and (v137 == (69 - (10 + 59)))) then
					if (((847 + 2147) > (4225 - 3367)) and v93.CastCycle(v97.ColossusSmash, v104, v107, not v101)) then
						return "colossus_smash hac 73";
					end
					if (v23(v97.ColossusSmash, not v101) or ((4918 - (671 + 492)) <= (729 + 186))) then
						return "colossus_smash hac 14";
					end
					break;
				end
			end
		end
		if (((5161 - (369 + 846)) > (991 + 2752)) and (v90 < v103) and v36 and ((v54 and v29) or not v54) and v97.ColossusSmash:IsCastable()) then
			if (v23(v97.ColossusSmash, not v101) or ((1140 + 195) >= (5251 - (1036 + 909)))) then
				return "colossus_smash hac 16";
			end
		end
		if (((3852 + 992) > (3782 - 1529)) and v97.Execute:IsReady() and v37 and v13:BuffUp(v97.SuddenDeathBuff) and v13:HasTier(234 - (11 + 192), 3 + 1)) then
			if (((627 - (135 + 40)) == (1094 - 642)) and v23(v97.Execute, not v101)) then
				return "execute hac 18";
			end
		end
		if ((v97.Cleave:IsReady() and v35 and (v13:BuffStack(v97.MartialProwessBuff) > (0 + 0))) or ((10039 - 5482) < (3127 - 1040))) then
			if (((4050 - (50 + 126)) == (10787 - 6913)) and v23(v97.Cleave, not v101)) then
				return "cleave hac 20";
			end
		end
		if ((v97.MortalStrike:IsReady() and v39 and v97.SharpenedBlades:IsAvailable() and v13:BuffUp(v97.SweepingStrikes) and (v13:BuffStack(v97.MartialProwessBuff) == (1 + 1)) and (v105 <= (1417 - (1233 + 180)))) or ((2907 - (522 + 447)) > (6356 - (107 + 1314)))) then
			if (v23(v97.MortalStrike, not v101) or ((1975 + 2280) < (10430 - 7007))) then
				return "mortal_strike hac 22";
			end
		end
		if (((618 + 836) <= (4946 - 2455)) and (v90 < v103) and v48 and ((v56 and v29) or not v56) and v97.ThunderousRoar:IsCastable() and (v13:BuffUp(v97.TestofMightBuff) or v14:DebuffUp(v97.ColossusSmashDebuff) or v14:DebuffUp(v97.DeepWoundsDebuff))) then
			if (v23(v97.ThunderousRoar, not v14:IsInMeleeRange(31 - 23)) or ((6067 - (716 + 1194)) <= (48 + 2755))) then
				return "thunderous_roar hac 24";
			end
		end
		if (((520 + 4333) >= (3485 - (74 + 429))) and (v90 < v103) and v83 and ((v55 and v29) or not v55) and (v84 == "player") and v97.ChampionsSpear:IsCastable() and (v13:BuffUp(v97.TestofMightBuff) or v14:DebuffUp(v97.ColossusSmashDebuff) or v14:DebuffUp(v97.DeepWoundsDebuff))) then
			if (((7974 - 3840) > (1664 + 1693)) and v23(v99.ChampionsSpearPlayer, not v101)) then
				return "spear_of_bastion hac 26";
			end
		end
		if (((v90 < v103) and v83 and ((v55 and v29) or not v55) and (v84 == "cursor") and v97.ChampionsSpear:IsCastable() and (v13:BuffUp(v97.TestofMightBuff) or v14:DebuffUp(v97.ColossusSmashDebuff) or v14:DebuffUp(v97.DeepWoundsDebuff))) or ((7821 - 4404) < (1793 + 741))) then
			if (v23(v99.ChampionsSpearCursor, not v14:IsInRange(61 - 41)) or ((6729 - 4007) <= (597 - (279 + 154)))) then
				return "spear_of_bastion hac 27";
			end
		end
		if (((v90 < v103) and v33 and ((v53 and v29) or not v53) and v97.Bladestorm:IsCastable() and ((v13:BuffRemains(v97.HurricaneBuff) < (781 - (454 + 324))) or not v97.Hurricane:IsAvailable())) or ((1895 + 513) < (2126 - (12 + 5)))) then
			if (v23(v97.Bladestorm, not v101) or ((18 + 15) == (3707 - 2252))) then
				return "bladestorm hac 28";
			end
		end
		if ((v97.Cleave:IsReady() and v35 and (not v97.FervorofBattle:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v14:DebuffRemains(v97.DeepWoundsDebuff) <= (v97.DeepWoundsDebuff:BaseDuration() * (0.3 + 0)))))) or ((1536 - (277 + 816)) >= (17156 - 13141))) then
			if (((4565 - (1058 + 125)) > (32 + 134)) and v23(v97.Cleave, not v101)) then
				return "cleave hac 30";
			end
		end
		if ((v97.Overpower:IsCastable() and v40 and v13:BuffUp(v97.SweepingStrikes) and (v97.Dreadnaught:IsAvailable() or (v97.Overpower:Charges() == (977 - (815 + 160))))) or ((1201 - 921) == (7261 - 4202))) then
			if (((449 + 1432) > (3779 - 2486)) and v23(v97.Overpower, not v101)) then
				return "overpower hac 32";
			end
		end
		if (((4255 - (41 + 1857)) == (4250 - (1222 + 671))) and v97.Whirlwind:IsReady() and v50 and (v97.FervorofBattle:IsAvailable() or v97.StormofSwords:IsAvailable())) then
			if (((317 - 194) == (175 - 52)) and v23(v97.Whirlwind, not v14:IsInMeleeRange(1190 - (229 + 953)))) then
				return "whirlwind hac 34";
			end
		end
		if ((v97.Overpower:IsCastable() and v40) or ((2830 - (1111 + 663)) >= (4971 - (874 + 705)))) then
			if (v23(v97.Overpower, not v101) or ((152 + 929) < (734 + 341))) then
				return "overpower hac 36";
			end
		end
		if ((v97.MortalStrike:IsReady() and v39) or ((2180 - 1131) >= (125 + 4307))) then
			if (v93.CastCycle(v97.MortalStrike, v104, v108, not v101) or ((5447 - (642 + 37)) <= (193 + 653))) then
				return "mortal_strike hac 83";
			end
			if (v23(v97.MortalStrike, not v101) or ((538 + 2820) <= (3565 - 2145))) then
				return "mortal_strike hac 83";
			end
		end
		if ((v97.Execute:IsReady() and v37 and (v13:BuffUp(v97.SuddenDeathBuff) or (v14:HealthPercentage() < (474 - (233 + 221))) or (v97.Massacre:IsAvailable() and (v14:HealthPercentage() < (80 - 45))) or v13:BuffUp(v97.SweepingStrikesBuff) or (v105 <= (2 + 0)))) or ((5280 - (718 + 823)) <= (1891 + 1114))) then
			local v138 = 805 - (266 + 539);
			while true do
				if ((v138 == (0 - 0)) or ((2884 - (636 + 589)) >= (5065 - 2931))) then
					if (v93.CastCycle(v97.Execute, v104, v109, not v101) or ((6723 - 3463) < (1867 + 488))) then
						return "execute hac 84";
					end
					if (v23(v97.Execute, not v101) or ((244 + 425) == (5238 - (657 + 358)))) then
						return "execute hac 84";
					end
					break;
				end
			end
		end
		if ((v97.ThunderClap:IsReady() and v47 and (v105 > (7 - 4))) or ((3854 - 2162) < (1775 - (1151 + 36)))) then
			if (v23(v97.ThunderClap, not v101) or ((4633 + 164) < (960 + 2691))) then
				return "thunder_clap hac 85";
			end
		end
		if ((v97.MortalStrike:IsReady() and v39) or ((12474 - 8297) > (6682 - (1552 + 280)))) then
			if (v23(v97.MortalStrike, not v101) or ((1234 - (64 + 770)) > (755 + 356))) then
				return "mortal_strike hac 91";
			end
		end
		if (((6925 - 3874) > (179 + 826)) and v97.ThunderClap:IsReady() and v47 and not v97.CrushingForce:IsAvailable()) then
			if (((4936 - (157 + 1086)) <= (8770 - 4388)) and v23(v97.ThunderClap, not v101)) then
				return "thunder_clap hac 92";
			end
		end
		if ((v97.Slam:IsReady() and v45) or ((14374 - 11092) > (6289 - 2189))) then
			if (v23(v97.Slam, not v101) or ((4886 - 1306) < (3663 - (599 + 220)))) then
				return "slam hac 93";
			end
		end
		if (((176 - 87) < (6421 - (1813 + 118))) and v97.Shockwave:IsCastable() and v43) then
			if (v23(v97.Shockwave, not v14:IsInMeleeRange(6 + 2)) or ((6200 - (841 + 376)) < (2533 - 725))) then
				return "shockwave hac 94";
			end
		end
		if (((890 + 2939) > (10287 - 6518)) and v97.WreckingThrow:IsCastable() and v51 and v106()) then
			if (((2344 - (464 + 395)) <= (7452 - 4548)) and v23(v97.WreckingThrow, not v101)) then
				return "wrecking_throw hac 95";
			end
		end
	end
	local function v115()
		local v131 = 0 + 0;
		while true do
			if (((5106 - (467 + 370)) == (8821 - 4552)) and (v131 == (2 + 0))) then
				if (((1326 - 939) <= (435 + 2347)) and v97.MortalStrike:IsReady() and v39) then
					if (v23(v97.MortalStrike, not v101) or ((4417 - 2518) <= (1437 - (150 + 370)))) then
						return "mortal_strike single_target 16";
					end
				end
				if ((v97.Execute:IsReady() and v37 and ((v13:BuffUp(v97.JuggernautBuff) and (v13:BuffRemains(v97.JuggernautBuff) < v13:GCD())) or (v13:BuffUp(v97.SuddenDeathBuff) and (v14:DebuffRemains(v97.DeepWoundsDebuff) > (1282 - (74 + 1208))) and v13:HasTier(75 - 44, 9 - 7)) or (v13:BuffUp(v97.SuddenDeathBuff) and not v14:DebuffUp(v97.RendDebuff) and v13:HasTier(23 + 8, 394 - (14 + 376))))) or ((7478 - 3166) <= (567 + 309))) then
					if (((1961 + 271) <= (2476 + 120)) and v23(v97.Execute, not v101)) then
						return "execute single_target 18";
					end
				end
				if (((6138 - 4043) < (2773 + 913)) and v97.ThunderClap:IsReady() and v47 and (v14:DebuffRemains(v97.RendDebuff) <= v13:GCD()) and v97.BloodandThunder:IsAvailable()) then
					if (v23(v97.ThunderClap, not v101) or ((1673 - (23 + 55)) >= (10602 - 6128))) then
						return "thunder_clap single_target 20";
					end
				end
				if ((v97.Rend:IsReady() and v41 and (v14:DebuffRemains(v97.RendDebuff) <= v13:GCD()) and not v97.BloodandThunder:IsAvailable()) or ((3083 + 1536) < (2589 + 293))) then
					if (v23(v97.Rend, not v101) or ((455 - 161) >= (1520 + 3311))) then
						return "rend single_target 22";
					end
				end
				v131 = 904 - (652 + 249);
			end
			if (((5429 - 3400) <= (4952 - (708 + 1160))) and (v131 == (0 - 0))) then
				if ((v97.Whirlwind:IsReady() and v50 and v13:BuffUp(v97.CollateralDamageBuff) and (v97.SweepingStrikes:CooldownRemains() < (5 - 2))) or ((2064 - (10 + 17)) == (544 + 1876))) then
					if (((6190 - (1400 + 332)) > (7487 - 3583)) and v23(v97.Whirlwind, not v14:IsInMeleeRange(1916 - (242 + 1666)))) then
						return "whirlwind single_target 1";
					end
				end
				if (((187 + 249) >= (46 + 77)) and (v90 < v103) and v46 and v97.SweepingStrikes:IsCastable() and (v105 > (1 + 0))) then
					if (((1440 - (850 + 90)) < (3180 - 1364)) and v23(v97.SweepingStrikes, not v14:IsInMeleeRange(1398 - (360 + 1030)))) then
						return "sweeping_strikes single_target 2";
					end
				end
				if (((3163 + 411) == (10087 - 6513)) and v97.ThunderClap:IsReady() and v47 and (v14:DebuffRemains(v97.RendDebuff) <= v13:GCD()) and v97.BloodandThunder:IsAvailable() and v97.BlademastersTorment:IsAvailable()) then
					if (((303 - 82) < (2051 - (909 + 752))) and v23(v97.ThunderClap, not v101)) then
						return "thunder_clap single_target 4";
					end
				end
				if (((v90 < v103) and v48 and ((v56 and v29) or not v56) and v97.ThunderousRoar:IsCastable()) or ((3436 - (109 + 1114)) <= (2601 - 1180))) then
					if (((1191 + 1867) < (5102 - (6 + 236))) and v23(v97.ThunderousRoar, not v14:IsInMeleeRange(6 + 2))) then
						return "thunderous_roar single_target 6";
					end
				end
				v131 = 1 + 0;
			end
			if ((v131 == (15 - 8)) or ((2263 - 967) >= (5579 - (1076 + 57)))) then
				if ((v97.WreckingThrow:IsCastable() and v51 and v106()) or ((230 + 1163) > (5178 - (579 + 110)))) then
					if (v23(v97.WreckingThrow, not v101) or ((350 + 4074) < (24 + 3))) then
						return "wrecking_throw single_target 54";
					end
				end
				break;
			end
			if ((v131 == (4 + 2)) or ((2404 - (174 + 233)) > (10656 - 6841))) then
				if (((6081 - 2616) > (851 + 1062)) and v97.Whirlwind:IsReady() and v50 and v13:BuffUp(v97.MercilessBonegrinderBuff)) then
					if (((1907 - (663 + 511)) < (1623 + 196)) and v23(v97.Whirlwind, not v14:IsInMeleeRange(2 + 6))) then
						return "whirlwind single_target 46";
					end
				end
				if ((v97.Slam:IsReady() and v45) or ((13549 - 9154) == (2880 + 1875))) then
					if (v23(v97.Slam, not v101) or ((8929 - 5136) < (5734 - 3365))) then
						return "slam single_target 48";
					end
				end
				if (((v90 < v103) and v33 and ((v53 and v29) or not v53) and v97.Bladestorm:IsCastable()) or ((1949 + 2135) == (515 - 250))) then
					if (((3106 + 1252) == (399 + 3959)) and v23(v97.Bladestorm, not v101)) then
						return "bladestorm single_target 50";
					end
				end
				if ((v97.Cleave:IsReady() and v35) or ((3860 - (478 + 244)) < (1510 - (440 + 77)))) then
					if (((1515 + 1815) > (8502 - 6179)) and v23(v97.Cleave, not v101)) then
						return "cleave single_target 52";
					end
				end
				v131 = 1563 - (655 + 901);
			end
			if ((v131 == (1 + 3)) or ((2776 + 850) == (2694 + 1295))) then
				if ((v97.Skullsplitter:IsCastable() and v44) or ((3690 - 2774) == (4116 - (695 + 750)))) then
					if (((928 - 656) == (419 - 147)) and v23(v97.Skullsplitter, not v101)) then
						return "skullsplitter single_target 30";
					end
				end
				if (((17088 - 12839) <= (5190 - (285 + 66))) and v97.Execute:IsReady() and v37 and v13:BuffUp(v97.SuddenDeathBuff)) then
					if (((6472 - 3695) < (4510 - (682 + 628))) and v23(v97.Execute, not v101)) then
						return "execute single_target 32";
					end
				end
				if (((16 + 79) < (2256 - (176 + 123))) and v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable() or v14:IsCasting())) then
					if (((346 + 480) < (1246 + 471)) and v23(v97.Shockwave, not v14:IsInMeleeRange(277 - (239 + 30)))) then
						return "shockwave single_target 34";
					end
				end
				if (((388 + 1038) >= (1063 + 42)) and v97.Whirlwind:IsReady() and v50 and v97.StormofSwords:IsAvailable() and v97.TestofMight:IsAvailable() and (v97.ColossusSmash:CooldownRemains() > (v13:GCD() * (12 - 5)))) then
					if (((8592 - 5838) <= (3694 - (306 + 9))) and v23(v97.Whirlwind, not v14:IsInMeleeRange(27 - 19))) then
						return "whirlwind single_target 36";
					end
				end
				v131 = 1 + 4;
			end
			if ((v131 == (1 + 0)) or ((1891 + 2036) == (4040 - 2627))) then
				if (((v90 < v103) and v33 and ((v53 and v29) or not v53) and v97.Bladestorm:IsCastable() and v97.Hurricane:IsAvailable() and (v103 > (1397 - (1140 + 235))) and v97.WarlordsTorment:IsAvailable()) or ((735 + 419) <= (723 + 65))) then
					if (v23(v97.Bladestorm, not v101) or ((422 + 1221) > (3431 - (33 + 19)))) then
						return "bladestorm single_target 8";
					end
				end
				if (((v90 < v103) and v31 and ((v52 and v29) or not v52) and v97.Avatar:IsCastable() and (v103 < (8 + 12))) or ((8401 - 5598) > (2004 + 2545))) then
					if (v23(v97.Avatar, not v101) or ((431 - 211) >= (2834 + 188))) then
						return "avatar single_target 10";
					end
				end
				if (((3511 - (586 + 103)) == (257 + 2565)) and (v90 < v103) and v36 and ((v54 and v29) or not v54) and v97.ColossusSmash:IsCastable()) then
					if (v23(v97.ColossusSmash, not v101) or ((3266 - 2205) == (3345 - (1309 + 179)))) then
						return "colossus_smash single_target 12";
					end
				end
				if (((4982 - 2222) > (594 + 770)) and (v90 < v103) and v49 and ((v57 and v29) or not v57) and v97.Warbreaker:IsCastable()) then
					if (v23(v97.Warbreaker, not v101) or ((13164 - 8262) <= (2716 + 879))) then
						return "warbreaker single_target 14";
					end
				end
				v131 = 3 - 1;
			end
			if ((v131 == (5 - 2)) or ((4461 - (295 + 314)) == (719 - 426))) then
				if ((v97.Whirlwind:IsReady() and v50 and v97.StormofSwords:IsAvailable() and v14:DebuffUp(v97.ColossusSmashDebuff)) or ((3521 - (1300 + 662)) == (14406 - 9818))) then
					if (v23(v97.Whirlwind, not v14:IsInMeleeRange(1763 - (1178 + 577))) or ((2329 + 2155) == (2329 - 1541))) then
						return "whirlwind single_target 24";
					end
				end
				if (((5973 - (851 + 554)) >= (3455 + 452)) and (v90 < v103) and v33 and ((v53 and v29) or not v53) and v97.Bladestorm:IsCastable() and v97.Hurricane:IsAvailable() and (v13:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v14:DebuffUp(v97.ColossusSmashDebuff) and (v13:BuffRemains(v97.HurricaneBuff) < (5 - 3))))) then
					if (((2705 - 1459) < (3772 - (115 + 187))) and v23(v97.Bladestorm, not v101)) then
						return "bladestorm single_target 26";
					end
				end
				if (((3116 + 952) >= (921 + 51)) and (v90 < v103) and v83 and ((v55 and v29) or not v55) and (v84 == "player") and v97.ChampionsSpear:IsCastable() and (v13:BuffUp(v97.TestofMightBuff) or v14:DebuffUp(v97.ColossusSmashDebuff))) then
					if (((1942 - 1449) < (5054 - (160 + 1001))) and v23(v99.ChampionsSpearPlayer, not v101)) then
						return "spear_of_bastion single_target 28";
					end
				end
				if (((v90 < v103) and v83 and ((v55 and v29) or not v55) and (v84 == "cursor") and v97.ChampionsSpear:IsCastable() and (v13:BuffUp(v97.TestofMightBuff) or v14:DebuffUp(v97.ColossusSmashDebuff))) or ((1289 + 184) >= (2300 + 1032))) then
					if (v23(v99.ChampionsSpearCursor, not v14:IsInRange(40 - 20)) or ((4409 - (237 + 121)) <= (2054 - (525 + 372)))) then
						return "spear_of_bastion single_target 29";
					end
				end
				v131 = 7 - 3;
			end
			if (((1984 - 1380) < (3023 - (96 + 46))) and ((782 - (643 + 134)) == v131)) then
				if ((v97.Overpower:IsCastable() and v40 and (((v97.Overpower:Charges() == (1 + 1)) and not v97.Battlelord:IsAvailable()) or v97.Battlelord:IsAvailable())) or ((2158 - 1258) == (12537 - 9160))) then
					if (((4277 + 182) > (1159 - 568)) and v23(v97.Overpower, not v101)) then
						return "overpower single_target 38";
					end
				end
				if (((6945 - 3547) >= (3114 - (316 + 403))) and v97.Whirlwind:IsReady() and v50 and (v97.StormofSwords:IsAvailable())) then
					if (v23(v97.Whirlwind, not v14:IsInMeleeRange(6 + 2)) or ((6001 - 3818) >= (1021 + 1803))) then
						return "whirlwind single_target 40";
					end
				end
				if (((4875 - 2939) == (1372 + 564)) and v97.ThunderClap:IsReady() and v47) then
					if (v23(v97.ThunderClap, not v101) or ((1558 + 3274) < (14944 - 10631))) then
						return "thunder_clap single_target 42";
					end
				end
				if (((19523 - 15435) > (8047 - 4173)) and v97.Slam:IsReady() and v45 and v97.CrushingForce:IsAvailable()) then
					if (((248 + 4084) == (8527 - 4195)) and v23(v97.Slam, not v101)) then
						return "slam single_target 44";
					end
				end
				v131 = 1 + 5;
			end
		end
	end
	local function v116()
		if (((11765 - 7766) >= (2917 - (12 + 5))) and not v13:AffectingCombat()) then
			local v139 = 0 - 0;
			while true do
				if ((v139 == (0 - 0)) or ((5367 - 2842) > (10077 - 6013))) then
					if (((888 + 3483) == (6344 - (1656 + 317))) and v97.BattleStance:IsCastable() and v13:BuffDown(v97.BattleStance, true)) then
						if (v23(v97.BattleStance) or ((238 + 28) > (3996 + 990))) then
							return "battle_stance";
						end
					end
					if (((5293 - 3302) >= (4552 - 3627)) and v97.BattleShout:IsCastable() and v32 and (v13:BuffDown(v97.BattleShoutBuff, true) or v93.GroupBuffMissing(v97.BattleShoutBuff))) then
						if (((809 - (5 + 349)) < (9751 - 7698)) and v23(v97.BattleShout)) then
							return "battle_shout precombat";
						end
					end
					break;
				end
			end
		end
		if ((v93.TargetIsValid() and v27) or ((2097 - (266 + 1005)) == (3197 + 1654))) then
			if (((624 - 441) == (240 - 57)) and not v13:AffectingCombat()) then
				local v191 = 1696 - (561 + 1135);
				while true do
					if (((1509 - 350) <= (5877 - 4089)) and (v191 == (1066 - (507 + 559)))) then
						v26 = v112();
						if (v26 or ((8799 - 5292) > (13354 - 9036))) then
							return v26;
						end
						break;
					end
				end
			end
		end
	end
	local function v117()
		local v132 = 388 - (212 + 176);
		while true do
			if ((v132 == (905 - (250 + 655))) or ((8385 - 5310) <= (5180 - 2215))) then
				v26 = v110();
				if (((2135 - 770) <= (3967 - (1869 + 87))) and v26) then
					return v26;
				end
				v132 = 3 - 2;
			end
			if ((v132 == (1902 - (484 + 1417))) or ((5950 - 3174) > (5990 - 2415))) then
				if (v85 or ((3327 - (48 + 725)) == (7847 - 3043))) then
					local v194 = 0 - 0;
					while true do
						if (((1498 + 1079) == (6886 - 4309)) and ((1 + 0) == v194)) then
							v26 = v93.HandleIncorporeal(v97.IntimidatingShout, v99.IntimidatingShoutMouseover, 3 + 5, true);
							if (v26 or ((859 - (152 + 701)) >= (3200 - (430 + 881)))) then
								return v26;
							end
							break;
						end
						if (((194 + 312) <= (2787 - (557 + 338))) and (v194 == (0 + 0))) then
							v26 = v93.HandleIncorporeal(v97.StormBolt, v99.StormBoltMouseover, 56 - 36, true);
							if (v26 or ((7031 - 5023) > (5892 - 3674))) then
								return v26;
							end
							v194 = 2 - 1;
						end
					end
				end
				if (((1180 - (499 + 302)) <= (5013 - (39 + 827))) and v93.TargetIsValid()) then
					local v195 = 0 - 0;
					local v196;
					while true do
						if ((v195 == (6 - 3)) or ((17928 - 13414) <= (1548 - 539))) then
							v26 = v115();
							if (v26 or ((300 + 3196) == (3488 - 2296))) then
								return v26;
							end
							if (v19.CastAnnotated(v97.Pool, false, "WAIT") or ((34 + 174) == (4681 - 1722))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((4381 - (103 + 1)) >= (1867 - (475 + 79))) and ((0 - 0) == v195)) then
							if (((8278 - 5691) < (411 + 2763)) and v34 and v97.Charge:IsCastable() and not v101) then
								if (v23(v97.Charge, not v14:IsSpellInRange(v97.Charge)) or ((3626 + 494) <= (3701 - (1395 + 108)))) then
									return "charge main 34";
								end
							end
							v196 = v93.HandleDPSPotion((v14:DebuffRemains(v97.ColossusSmashDebuff) > (23 - 15)) or (v103 < (1229 - (7 + 1197))));
							if (v196 or ((696 + 900) == (300 + 558))) then
								return v196;
							end
							v195 = 320 - (27 + 292);
						end
						if (((9435 - 6215) == (4106 - 886)) and (v195 == (8 - 6))) then
							if ((v97.WreckingThrow:IsCastable() and v51 and v106() and v13:CanAttack(v14)) or ((2764 - 1362) > (6894 - 3274))) then
								if (((2713 - (43 + 96)) == (10499 - 7925)) and v23(v97.WreckingThrow, not v14:IsSpellInRange(v97.WreckingThrow))) then
									return "wrecking_throw main";
								end
							end
							if (((4064 - 2266) < (2288 + 469)) and v28 and ((v105 > (1 + 1)) or (v97.FervorofBattle:IsAvailable() and ((v97.Massacre:IsAvailable() and (v14:HealthPercentage() > (69 - 34))) or (v14:HealthPercentage() > (8 + 12))) and (v105 > (1 - 0))))) then
								v26 = v114();
								if (v26 or ((119 + 258) > (191 + 2413))) then
									return v26;
								end
							end
							if (((2319 - (1414 + 337)) < (2851 - (1642 + 298))) and ((v97.Massacre:IsAvailable() and (v14:HealthPercentage() < (90 - 55))) or (v14:HealthPercentage() < (57 - 37)))) then
								local v200 = 0 - 0;
								while true do
									if (((1082 + 2203) < (3290 + 938)) and (v200 == (972 - (357 + 615)))) then
										v26 = v113();
										if (((2749 + 1167) > (8165 - 4837)) and v26) then
											return v26;
										end
										break;
									end
								end
							end
							v195 = 3 + 0;
						end
						if (((5357 - 2857) < (3071 + 768)) and (v195 == (1 + 0))) then
							if (((319 + 188) == (1808 - (384 + 917))) and v101 and v91 and ((v59 and v29) or not v59) and (v90 < v103)) then
								if (((937 - (128 + 569)) <= (4708 - (1407 + 136))) and v97.BloodFury:IsCastable() and v14:DebuffUp(v97.ColossusSmashDebuff)) then
									if (((2721 - (687 + 1200)) >= (2515 - (556 + 1154))) and v23(v97.BloodFury)) then
										return "blood_fury main 39";
									end
								end
								if ((v97.Berserking:IsCastable() and (v14:DebuffRemains(v97.ColossusSmashDebuff) > (20 - 14))) or ((3907 - (9 + 86)) < (2737 - (275 + 146)))) then
									if (v23(v97.Berserking) or ((432 + 2220) <= (1597 - (29 + 35)))) then
										return "berserking main 40";
									end
								end
								if ((v97.ArcaneTorrent:IsCastable() and (v97.MortalStrike:CooldownRemains() > (4.5 - 3)) and (v13:Rage() < (149 - 99))) or ((15883 - 12285) < (951 + 509))) then
									if (v23(v97.ArcaneTorrent, not v14:IsInRange(1020 - (53 + 959))) or ((4524 - (312 + 96)) < (2068 - 876))) then
										return "arcane_torrent main 41";
									end
								end
								if ((v97.LightsJudgment:IsCastable() and v14:DebuffDown(v97.ColossusSmashDebuff) and not v97.MortalStrike:CooldownUp()) or ((3662 - (147 + 138)) <= (1802 - (813 + 86)))) then
									if (((3594 + 382) >= (812 - 373)) and v23(v97.LightsJudgment, not v14:IsSpellInRange(v97.LightsJudgment))) then
										return "lights_judgment main 42";
									end
								end
								if (((4244 - (18 + 474)) == (1266 + 2486)) and v97.Fireblood:IsCastable() and (v14:DebuffUp(v97.ColossusSmashDebuff))) then
									if (((13205 - 9159) > (3781 - (860 + 226))) and v23(v97.Fireblood)) then
										return "fireblood main 43";
									end
								end
								if ((v97.AncestralCall:IsCastable() and (v14:DebuffUp(v97.ColossusSmashDebuff))) or ((3848 - (121 + 182)) == (394 + 2803))) then
									if (((3634 - (988 + 252)) > (43 + 330)) and v23(v97.AncestralCall)) then
										return "ancestral_call main 44";
									end
								end
								if (((1302 + 2853) <= (6202 - (49 + 1921))) and v97.BagofTricks:IsCastable() and v14:DebuffDown(v97.ColossusSmashDebuff) and not v97.MortalStrike:CooldownUp()) then
									if (v23(v97.BagofTricks, not v14:IsSpellInRange(v97.BagofTricks)) or ((4471 - (223 + 667)) == (3525 - (51 + 1)))) then
										return "bag_of_tricks main 10";
									end
								end
							end
							if (((8597 - 3602) > (7169 - 3821)) and (v90 < v103)) then
								local v201 = 1125 - (146 + 979);
								while true do
									if ((v201 == (0 + 0)) or ((1359 - (311 + 294)) > (10385 - 6661))) then
										if (((92 + 125) >= (1500 - (496 + 947))) and v92 and ((v29 and v58) or not v58)) then
											v26 = v111();
											if (v26 or ((3428 - (1233 + 125)) >= (1639 + 2398))) then
												return v26;
											end
										end
										if (((2427 + 278) == (514 + 2191)) and v29 and v98.FyralathTheDreamrender:IsEquippedAndReady() and v30) then
											if (((1706 - (963 + 682)) == (51 + 10)) and v23(v99.UseWeapon)) then
												return "Fyralath The Dreamrender used";
											end
										end
										break;
									end
								end
							end
							if ((v38 and v97.HeroicThrow:IsCastable() and not v14:IsInRange(1529 - (504 + 1000)) and v13:CanAttack(v14)) or ((471 + 228) >= (1181 + 115))) then
								if (v23(v97.HeroicThrow, not v14:IsSpellInRange(v97.HeroicThrow)) or ((169 + 1614) >= (5331 - 1715))) then
									return "heroic_throw main";
								end
							end
							v195 = 2 + 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v118()
		local v133 = 0 + 0;
		while true do
			if ((v133 == (187 - (156 + 26))) or ((2255 + 1658) > (7082 - 2555))) then
				v51 = EpicSettings.Settings['useWreckingThrow'];
				v31 = EpicSettings.Settings['useAvatar'];
				v33 = EpicSettings.Settings['useBladestorm'];
				v133 = 170 - (149 + 15);
			end
			if (((5336 - (890 + 70)) > (934 - (39 + 78))) and (v133 == (490 - (14 + 468)))) then
				v54 = EpicSettings.Settings['colossusSmashWithCD'];
				v55 = EpicSettings.Settings['championsSpearWithCD'];
				v56 = EpicSettings.Settings['thunderousRoarWithCD'];
				v133 = 19 - 10;
			end
			if (((13586 - 8725) > (426 + 398)) and (v133 == (2 + 1))) then
				v43 = EpicSettings.Settings['useShockwave'];
				v44 = EpicSettings.Settings['useSkullsplitter'];
				v45 = EpicSettings.Settings['useSlam'];
				v133 = 1 + 3;
			end
			if ((v133 == (4 + 3)) or ((363 + 1020) >= (4078 - 1947))) then
				v49 = EpicSettings.Settings['useWarbreaker'];
				v52 = EpicSettings.Settings['avatarWithCD'];
				v53 = EpicSettings.Settings['bladestormWithCD'];
				v133 = 8 + 0;
			end
			if ((v133 == (21 - 15)) or ((48 + 1828) >= (2592 - (12 + 39)))) then
				v36 = EpicSettings.Settings['useColossusSmash'];
				v83 = EpicSettings.Settings['useChampionsSpear'];
				v48 = EpicSettings.Settings['useThunderousRoar'];
				v133 = 7 + 0;
			end
			if (((5515 - 3733) <= (13434 - 9662)) and (v133 == (3 + 6))) then
				v57 = EpicSettings.Settings['warbreakerWithCD'];
				break;
			end
			if ((v133 == (3 + 1)) or ((11918 - 7218) < (542 + 271))) then
				v46 = EpicSettings.Settings['useSweepingStrikes'];
				v47 = EpicSettings.Settings['useThunderClap'];
				v50 = EpicSettings.Settings['useWhirlwind'];
				v133 = 24 - 19;
			end
			if (((4909 - (1596 + 114)) < (10574 - 6524)) and (v133 == (715 - (164 + 549)))) then
				v39 = EpicSettings.Settings['useMortalStrike'];
				v40 = EpicSettings.Settings['useOverpower'];
				v41 = EpicSettings.Settings['useRend'];
				v133 = 1441 - (1059 + 379);
			end
			if ((v133 == (0 - 0)) or ((2566 + 2385) < (747 + 3683))) then
				v30 = EpicSettings.Settings['useWeapon'];
				v32 = EpicSettings.Settings['useBattleShout'];
				v34 = EpicSettings.Settings['useCharge'];
				v133 = 393 - (145 + 247);
			end
			if (((79 + 17) == (45 + 51)) and (v133 == (2 - 1))) then
				v35 = EpicSettings.Settings['useCleave'];
				v37 = EpicSettings.Settings['useExecute'];
				v38 = EpicSettings.Settings['useHeroicThrow'];
				v133 = 1 + 1;
			end
		end
	end
	local function v119()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (0 - 0)) or ((3459 - (254 + 466)) > (4568 - (544 + 16)))) then
				v60 = EpicSettings.Settings['usePummel'];
				v61 = EpicSettings.Settings['useStormBolt'];
				v62 = EpicSettings.Settings['useIntimidatingShout'];
				v63 = EpicSettings.Settings['useBitterImmunity'];
				v134 = 2 - 1;
			end
			if ((v134 == (630 - (294 + 334))) or ((276 - (236 + 17)) == (489 + 645))) then
				v66 = EpicSettings.Settings['useRallyingCry'];
				v71 = EpicSettings.Settings['useVictoryRush'];
				v72 = EpicSettings.Settings['bitterImmunityHP'] or (0 + 0);
				v78 = EpicSettings.Settings['defensiveStanceHP'] or (0 - 0);
				v134 = 14 - 11;
			end
			if ((v134 == (3 + 1)) or ((2218 + 475) >= (4905 - (413 + 381)))) then
				v76 = EpicSettings.Settings['rallyingCryGroup'] or (0 + 0);
				v75 = EpicSettings.Settings['rallyingCryHP'] or (0 - 0);
				v82 = EpicSettings.Settings['victoryRushHP'] or (0 - 0);
				v84 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
			if ((v134 == (1973 - (582 + 1388))) or ((7353 - 3037) <= (1537 + 609))) then
				v81 = EpicSettings.Settings['unstanceHP'] or (364 - (326 + 38));
				v73 = EpicSettings.Settings['dieByTheSwordHP'] or (0 - 0);
				v74 = EpicSettings.Settings['ignorePainHP'] or (0 - 0);
				v77 = EpicSettings.Settings['interveneHP'] or (620 - (47 + 573));
				v134 = 2 + 2;
			end
			if (((4 - 3) == v134) or ((5755 - 2209) <= (4473 - (1269 + 395)))) then
				v68 = EpicSettings.Settings['useDefensiveStance'];
				v64 = EpicSettings.Settings['useDieByTheSword'];
				v65 = EpicSettings.Settings['useIgnorePain'];
				v67 = EpicSettings.Settings['useIntervene'];
				v134 = 494 - (76 + 416);
			end
		end
	end
	local function v120()
		local v135 = 443 - (319 + 124);
		while true do
			if (((11210 - 6306) > (3173 - (564 + 443))) and ((0 - 0) == v135)) then
				v90 = EpicSettings.Settings['fightRemainsCheck'] or (458 - (337 + 121));
				v87 = EpicSettings.Settings['InterruptWithStun'];
				v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v89 = EpicSettings.Settings['InterruptThreshold'];
				v135 = 2 - 1;
			end
			if (((362 - 253) >= (2001 - (1261 + 650))) and ((1 + 1) == v135)) then
				v69 = EpicSettings.Settings['useHealthstone'];
				v70 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v80 = EpicSettings.Settings['healingPotionHP'] or (1817 - (772 + 1045));
				v135 = 1 + 2;
			end
			if (((5122 - (102 + 42)) > (4749 - (1524 + 320))) and (v135 == (1273 - (1049 + 221)))) then
				v86 = EpicSettings.Settings['HealingPotionName'] or "";
				v85 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v135 == (157 - (18 + 138))) or ((7406 - 4380) <= (3382 - (67 + 1035)))) then
				v92 = EpicSettings.Settings['useTrinkets'];
				v91 = EpicSettings.Settings['useRacials'];
				v58 = EpicSettings.Settings['trinketsWithCD'];
				v59 = EpicSettings.Settings['racialsWithCD'];
				v135 = 350 - (136 + 212);
			end
		end
	end
	local function v121()
		local v136 = 0 - 0;
		while true do
			if ((v136 == (2 + 0)) or ((1524 + 129) <= (2712 - (240 + 1364)))) then
				if (((3991 - (1050 + 32)) > (9315 - 6706)) and v13:IsDeadOrGhost()) then
					return v26;
				end
				if (((448 + 309) > (1249 - (331 + 724))) and v28) then
					local v197 = 0 + 0;
					while true do
						if (((644 - (269 + 375)) == v197) or ((756 - (267 + 458)) >= (435 + 963))) then
							v104 = v13:GetEnemiesInMeleeRange(15 - 7);
							v105 = #v104;
							break;
						end
					end
				else
					v105 = 819 - (667 + 151);
				end
				v101 = v14:IsInMeleeRange(1505 - (1410 + 87));
				v136 = 1900 - (1504 + 393);
			end
			if (((8638 - 5442) <= (12639 - 7767)) and (v136 == (796 - (461 + 335)))) then
				v119();
				v118();
				v120();
				v136 = 1 + 0;
			end
			if (((5087 - (1730 + 31)) == (4993 - (728 + 939))) and (v136 == (3 - 2))) then
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				v136 = 3 - 1;
			end
			if (((3282 - 1849) <= (4946 - (138 + 930))) and (v136 == (3 + 0))) then
				if (v93.TargetIsValid() or v13:AffectingCombat() or ((1238 + 345) == (1487 + 248))) then
					v102 = v9.BossFightRemains(nil, true);
					v103 = v102;
					if ((v103 == (45369 - 34258)) or ((4747 - (459 + 1307)) == (4220 - (474 + 1396)))) then
						v103 = v9.FightRemains(v104, false);
					end
				end
				if (not v13:IsChanneling() or ((7798 - 3332) <= (463 + 30))) then
					if (v13:AffectingCombat() or ((9 + 2538) <= (5691 - 3704))) then
						local v198 = 0 + 0;
						while true do
							if (((9884 - 6923) > (11949 - 9209)) and ((591 - (562 + 29)) == v198)) then
								v26 = v117();
								if (((3151 + 545) >= (5031 - (374 + 1045))) and v26) then
									return v26;
								end
								break;
							end
						end
					else
						local v199 = 0 + 0;
						while true do
							if ((v199 == (0 - 0)) or ((3608 - (448 + 190)) == (607 + 1271))) then
								v26 = v116();
								if (v26 or ((1668 + 2025) < (1289 + 688))) then
									return v26;
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
	local function v122()
		v19.Print("Arms Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(272 - 201, v121, v122);
end;
return v0["Epix_Warrior_Arms.lua"]();

