local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1836 + 128) < (1864 - (446 + 78)))) then
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
	local v95 = (v94[1017 - (771 + 233)] and v18(v94[1918 - (830 + 1075)])) or v18(524 - (303 + 221));
	local v96 = (v94[1283 - (231 + 1038)] and v18(v94[12 + 2])) or v18(1162 - (171 + 991));
	local v97 = v17.Warrior.Arms;
	local v98 = v18.Warrior.Arms;
	local v99 = v22.Warrior.Arms;
	local v100 = {};
	local v101;
	local v102 = 45790 - 34679;
	local v103 = 29835 - 18724;
	v9:RegisterForEvent(function()
		v102 = 27726 - 16615;
		v103 = 8893 + 2218;
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		local v123 = 0 - 0;
		while true do
			if (((7208 - 4709) == (4027 - 1528)) and (v123 == (0 - 0))) then
				v94 = v13:GetEquipment();
				v95 = (v94[1261 - (111 + 1137)] and v18(v94[171 - (91 + 67)])) or v18(0 - 0);
				v123 = 1 + 0;
			end
			if ((v123 == (524 - (423 + 100))) or ((16 + 2239) < (60 - 38))) then
				v96 = (v94[8 + 6] and v18(v94[785 - (326 + 445)])) or v18(0 - 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v104;
	local v105;
	local function v106()
		local v124 = 0 - 0;
		local v125;
		while true do
			if ((v124 == (0 - 0)) or ((1797 - (530 + 181)) >= (2286 - (614 + 267)))) then
				v125 = UnitGetTotalAbsorbs(v14:ID());
				if ((v125 > (32 - (19 + 13))) or ((3855 - 1486) == (992 - 566))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v107(v126)
		return (v126:HealthPercentage() > (57 - 37)) or (v97.Massacre:IsAvailable() and (v126:HealthPercentage() < (10 + 25)));
	end
	local function v108(v127)
		return (v127:DebuffStack(v97.ExecutionersPrecisionDebuff) == (3 - 1)) or (v127:DebuffRemains(v97.DeepWoundsDebuff) <= v13:GCD()) or (v105 <= (3 - 1));
	end
	local function v109(v128)
		return v13:BuffUp(v97.SuddenDeathBuff) or (v128:HealthPercentage() < (1832 - (1293 + 519))) or (v97.Massacre:IsAvailable() and (v128:HealthPercentage() < (71 - 36))) or v13:BuffUp(v97.SweepingStrikesBuff) or (v105 <= (4 - 2));
	end
	local function v110()
		if ((v97.BitterImmunity:IsReady() and v63 and (v13:HealthPercentage() <= v72)) or ((5882 - 2806) > (13725 - 10542))) then
			if (((2831 - 1629) > (561 + 497)) and v23(v97.BitterImmunity)) then
				return "bitter_immunity defensive";
			end
		end
		if (((758 + 2953) > (7795 - 4440)) and v97.DieByTheSword:IsCastable() and v64 and (v13:HealthPercentage() <= v73)) then
			if (v23(v97.DieByTheSword) or ((210 + 696) >= (741 + 1488))) then
				return "die_by_the_sword defensive";
			end
		end
		if (((805 + 483) > (2347 - (709 + 387))) and v97.IgnorePain:IsCastable() and v65 and (v13:HealthPercentage() <= v74)) then
			if (v23(v97.IgnorePain, nil, nil, true) or ((6371 - (673 + 1185)) < (9720 - 6368))) then
				return "ignore_pain defensive";
			end
		end
		if ((v97.RallyingCry:IsCastable() and v66 and v13:BuffDown(v97.AspectsFavorBuff) and v13:BuffDown(v97.RallyingCry) and (((v13:HealthPercentage() <= v75) and v93.IsSoloMode()) or v93.AreUnitsBelowHealthPercentage(v75, v76, v97.Intervene))) or ((6631 - 4566) >= (5258 - 2062))) then
			if (v23(v97.RallyingCry) or ((3130 + 1246) <= (1107 + 374))) then
				return "rallying_cry defensive";
			end
		end
		if ((v97.Intervene:IsCastable() and v67 and (v16:HealthPercentage() <= v77) and (v16:Name() ~= v13:Name())) or ((4579 - 1187) >= (1165 + 3576))) then
			if (((6629 - 3304) >= (4228 - 2074)) and v23(v99.InterveneFocus)) then
				return "intervene defensive";
			end
		end
		if ((v97.DefensiveStance:IsCastable() and v13:BuffDown(v97.DefensiveStance, true) and v68 and (v13:HealthPercentage() <= v78)) or ((3175 - (446 + 1434)) >= (4516 - (1040 + 243)))) then
			if (((13063 - 8686) > (3489 - (559 + 1288))) and v23(v97.DefensiveStance)) then
				return "defensive_stance defensive";
			end
		end
		if (((6654 - (609 + 1322)) > (1810 - (13 + 441))) and v97.BattleStance:IsCastable() and v13:BuffDown(v97.BattleStance, true) and v68 and (v13:HealthPercentage() > v81)) then
			if (v23(v97.BattleStance) or ((15455 - 11319) <= (8992 - 5559))) then
				return "battle_stance after defensive stance defensive";
			end
		end
		if (((21141 - 16896) <= (173 + 4458)) and v98.Healthstone:IsReady() and v69 and (v13:HealthPercentage() <= v79)) then
			if (((15529 - 11253) >= (1391 + 2523)) and v23(v99.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if (((87 + 111) <= (12953 - 8588)) and v70 and (v13:HealthPercentage() <= v80)) then
			local v173 = 0 + 0;
			while true do
				if (((8794 - 4012) > (3092 + 1584)) and (v173 == (0 + 0))) then
					if (((3495 + 1369) > (1845 + 352)) and (v86 == "Refreshing Healing Potion")) then
						if (v98.RefreshingHealingPotion:IsReady() or ((3621 + 79) == (2940 - (153 + 280)))) then
							if (((12918 - 8444) >= (246 + 28)) and v23(v99.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v86 == "Dreamwalker's Healing Potion") or ((748 + 1146) <= (736 + 670))) then
						if (((1427 + 145) >= (1110 + 421)) and v98.DreamwalkersHealingPotion:IsReady()) then
							if (v23(v99.RefreshingHealingPotion) or ((7136 - 2449) < (2808 + 1734))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v111()
		v26 = v93.HandleTopTrinket(v100, v29, 707 - (89 + 578), nil);
		if (((2351 + 940) > (3465 - 1798)) and v26) then
			return v26;
		end
		v26 = v93.HandleBottomTrinket(v100, v29, 1089 - (572 + 477), nil);
		if (v26 or ((118 + 755) == (1221 + 813))) then
			return v26;
		end
	end
	local function v112()
		local v129 = 0 + 0;
		while true do
			if ((v129 == (86 - (84 + 2))) or ((4640 - 1824) < (8 + 3))) then
				if (((4541 - (497 + 345)) < (121 + 4585)) and v101) then
					if (((448 + 2198) >= (2209 - (605 + 728))) and v97.Skullsplitter:IsCastable() and v44) then
						if (((439 + 175) <= (7078 - 3894)) and v23(v97.Skullsplitter)) then
							return "skullsplitter precombat";
						end
					end
					if (((144 + 2982) == (11557 - 8431)) and (v90 < v103) and v97.ColossusSmash:IsCastable() and v36 and ((v54 and v29) or not v54)) then
						if (v23(v97.ColossusSmash) or ((1972 + 215) >= (13725 - 8771))) then
							return "colossus_smash precombat";
						end
					end
					if (((v90 < v103) and v97.Warbreaker:IsCastable() and v49 and ((v57 and v29) or not v57)) or ((2928 + 949) == (4064 - (457 + 32)))) then
						if (((300 + 407) > (2034 - (832 + 570))) and v23(v97.Warbreaker)) then
							return "warbreaker precombat";
						end
					end
					if ((v97.Overpower:IsCastable() and v40) or ((515 + 31) >= (700 + 1984))) then
						if (((5184 - 3719) <= (2072 + 2229)) and v23(v97.Overpower)) then
							return "overpower precombat";
						end
					end
				end
				if (((2500 - (588 + 208)) > (3840 - 2415)) and v34 and v97.Charge:IsCastable()) then
					if (v23(v97.Charge) or ((2487 - (884 + 916)) == (8863 - 4629))) then
						return "charge precombat";
					end
				end
				break;
			end
		end
	end
	local function v113()
		local v130 = 0 + 0;
		while true do
			if ((v130 == (655 - (232 + 421))) or ((5219 - (1569 + 320)) < (351 + 1078))) then
				if (((218 + 929) >= (1128 - 793)) and (v90 < v103) and v83 and ((v55 and v29) or not v55) and (v84 == "cursor") and v97.ChampionsSpear:IsCastable() and (v14:DebuffUp(v97.ColossusSmashDebuff) or v13:BuffUp(v97.TestofMightBuff))) then
					if (((4040 - (316 + 289)) > (5489 - 3392)) and v23(v99.ChampionsSpearCursor, not v14:IsInRange(1 + 19))) then
						return "spear_of_bastion execute 11";
					end
				end
				if (((v90 < v103) and v49 and ((v57 and v29) or not v57) and v97.Warbreaker:IsCastable()) or ((5223 - (666 + 787)) >= (4466 - (360 + 65)))) then
					if (v23(v97.Warbreaker, not v101) or ((3543 + 248) <= (1865 - (79 + 175)))) then
						return "warbreaker execute 12";
					end
				end
				if (((v90 < v103) and v36 and ((v54 and v29) or not v54) and v97.ColossusSmash:IsCastable()) or ((7218 - 2640) <= (1567 + 441))) then
					if (((3448 - 2323) <= (3997 - 1921)) and v23(v97.ColossusSmash, not v101)) then
						return "colossus_smash execute 14";
					end
				end
				v130 = 902 - (503 + 396);
			end
			if (((186 - (92 + 89)) == v130) or ((1440 - 697) >= (2256 + 2143))) then
				if (((684 + 471) < (6551 - 4878)) and v97.Skullsplitter:IsCastable() and v44 and (v13:Rage() < (6 + 34))) then
					if (v23(v97.Skullsplitter, not v14:IsInMeleeRange(17 - 9)) or ((2028 + 296) <= (277 + 301))) then
						return "skullsplitter execute 28";
					end
				end
				if (((11473 - 7706) == (471 + 3296)) and v97.Execute:IsReady() and v37) then
					if (((6235 - 2146) == (5333 - (485 + 759))) and v23(v97.Execute, not v101)) then
						return "execute execute 30";
					end
				end
				if (((10315 - 5857) >= (2863 - (442 + 747))) and v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable() or v14:IsCasting())) then
					if (((2107 - (832 + 303)) <= (2364 - (88 + 858))) and v23(v97.Shockwave, not v14:IsInMeleeRange(3 + 5))) then
						return "shockwave execute 32";
					end
				end
				v130 = 5 + 1;
			end
			if ((v130 == (1 + 5)) or ((5727 - (766 + 23)) < (23508 - 18746))) then
				if ((v97.Overpower:IsCastable() and v40) or ((3424 - 920) > (11234 - 6970))) then
					if (((7307 - 5154) == (3226 - (1036 + 37))) and v23(v97.Overpower, not v101)) then
						return "overpower execute 34";
					end
				end
				if (((v90 < v103) and v33 and ((v53 and v29) or not v53) and v97.Bladestorm:IsCastable()) or ((360 + 147) >= (5045 - 2454))) then
					if (((3525 + 956) == (5961 - (641 + 839))) and v23(v97.Bladestorm, not v101)) then
						return "bladestorm execute 36";
					end
				end
				if ((v97.WreckingThrow:IsCastable() and v51 and v106()) or ((3241 - (910 + 3)) < (1766 - 1073))) then
					if (((6012 - (1466 + 218)) == (1990 + 2338)) and v23(v97.WreckingThrow, not v101)) then
						return "wrecking_throw execute 38";
					end
				end
				break;
			end
			if (((2736 - (556 + 592)) >= (474 + 858)) and (v130 == (809 - (329 + 479)))) then
				if ((v97.Rend:IsReady() and v41 and (v14:DebuffRemains(v97.RendDebuff) <= v13:GCD()) and not v97.Bloodletting:IsAvailable() and ((not v97.Warbreaker:IsAvailable() and (v97.ColossusSmash:CooldownRemains() < (858 - (174 + 680)))) or (v97.Warbreaker:IsAvailable() and (v97.Warbreaker:CooldownRemains() < (13 - 9)))) and (v14:TimeToDie() > (24 - 12))) or ((2981 + 1193) > (4987 - (396 + 343)))) then
					if (v23(v97.Rend, not v101) or ((406 + 4180) <= (1559 - (29 + 1448)))) then
						return "rend execute 6";
					end
				end
				if (((5252 - (135 + 1254)) == (14552 - 10689)) and (v90 < v103) and v31 and ((v52 and v29) or not v52) and v97.Avatar:IsCastable() and (v97.ColossusSmash:CooldownUp() or v14:DebuffUp(v97.ColossusSmashDebuff) or (v103 < (93 - 73)))) then
					if (v23(v97.Avatar, not v101) or ((188 + 94) <= (1569 - (389 + 1138)))) then
						return "avatar execute 8";
					end
				end
				if (((5183 - (102 + 472)) >= (723 + 43)) and (v90 < v103) and v83 and ((v55 and v29) or not v55) and (v84 == "player") and v97.ChampionsSpear:IsCastable() and (v97.ColossusSmash:CooldownRemains() <= v13:GCD())) then
					if (v23(v99.ChampionsSpearPlayer, not v101) or ((639 + 513) == (2320 + 168))) then
						return "spear_of_bastion execute 10";
					end
				end
				v130 = 1547 - (320 + 1225);
			end
			if (((6091 - 2669) > (2050 + 1300)) and ((1467 - (157 + 1307)) == v130)) then
				if (((2736 - (821 + 1038)) > (937 - 561)) and (v90 < v103) and v48 and ((v56 and v29) or not v56) and v97.ThunderousRoar:IsCastable() and ((v97.TestofMight:IsAvailable() and (v13:Rage() < (5 + 35))) or (not v97.TestofMight:IsAvailable() and (v13:BuffUp(v97.AvatarBuff) or v14:DebuffUp(v97.ColossusSmashDebuff)) and (v13:Rage() < (124 - 54))))) then
					if (v23(v97.ThunderousRoar, not v14:IsInMeleeRange(3 + 5)) or ((7728 - 4610) <= (2877 - (834 + 192)))) then
						return "thunderous_roar execute 16";
					end
				end
				if ((v97.Cleave:IsReady() and (v105 > (1 + 1)) and (v14:DebuffRemains(v97.DeepWoundsDebuff) <= v13:GCD()) and v35) or ((43 + 122) >= (75 + 3417))) then
					if (((6117 - 2168) < (5160 - (300 + 4))) and v23(v97.Cleave, not v101)) then
						return "cleave execute 18";
					end
				end
				if (((v90 < v103) and v33 and ((v53 and v29) or not v53) and v97.Bladestorm:IsCastable() and (v13:Rage() < (11 + 29))) or ((11193 - 6917) < (3378 - (112 + 250)))) then
					if (((1870 + 2820) > (10334 - 6209)) and v23(v97.Bladestorm, not v101)) then
						return "bladestorm execute 20";
					end
				end
				v130 = 3 + 1;
			end
			if ((v130 == (0 + 0)) or ((38 + 12) >= (445 + 451))) then
				if ((v97.Whirlwind:IsReady() and v50 and v13:BuffUp(v97.CollateralDamageBuff) and (v97.SweepingStrikes:CooldownRemains() < (3 + 0))) or ((3128 - (1001 + 413)) >= (6596 - 3638))) then
					if (v23(v97.Whirlwind, not v14:IsInMeleeRange(890 - (244 + 638))) or ((2184 - (627 + 66)) < (1918 - 1274))) then
						return "whirlwind execute 1";
					end
				end
				if (((1306 - (512 + 90)) < (2893 - (1665 + 241))) and (v90 < v103) and v46 and v97.SweepingStrikes:IsCastable() and (v105 > (718 - (373 + 344)))) then
					if (((1677 + 2041) > (505 + 1401)) and v23(v97.SweepingStrikes, not v14:IsInMeleeRange(20 - 12))) then
						return "sweeping_strikes execute 2";
					end
				end
				if ((v97.MortalStrike:IsReady() and v39 and (v14:DebuffRemains(v97.RendDebuff) <= v13:GCD()) and v97.Bloodletting:IsAvailable()) or ((1620 - 662) > (4734 - (35 + 1064)))) then
					if (((2548 + 953) <= (9610 - 5118)) and v23(v97.MortalStrike, not v101)) then
						return "mortal_strike execute 4";
					end
				end
				v130 = 1 + 0;
			end
			if ((v130 == (1240 - (298 + 938))) or ((4701 - (233 + 1026)) < (4214 - (636 + 1030)))) then
				if (((1470 + 1405) >= (1430 + 34)) and v97.MortalStrike:IsReady() and v39 and (v14:DebuffStack(v97.ExecutionersPrecisionDebuff) == (1 + 1))) then
					if (v23(v97.MortalStrike, not v101) or ((325 + 4472) >= (5114 - (55 + 166)))) then
						return "mortal_strike execute 22";
					end
				end
				if ((v97.Execute:IsReady() and v37 and v13:BuffUp(v97.SuddenDeathBuff) and (v14:DebuffRemains(v97.DeepWoundsDebuff) > (0 + 0))) or ((56 + 495) > (7897 - 5829))) then
					if (((2411 - (36 + 261)) > (1650 - 706)) and v23(v97.Execute, not v101)) then
						return "execute execute 24";
					end
				end
				if ((v97.Overpower:IsCastable() and v40 and (v13:Rage() < (1408 - (34 + 1334))) and (v13:BuffStack(v97.MartialProwessBuff) < (1 + 1))) or ((1758 + 504) >= (4379 - (1035 + 248)))) then
					if (v23(v97.Overpower, not v101) or ((2276 - (20 + 1)) >= (1843 + 1694))) then
						return "overpower execute 26";
					end
				end
				v130 = 324 - (134 + 185);
			end
		end
	end
	local function v114()
		local v131 = 1133 - (549 + 584);
		while true do
			if ((v131 == (687 - (314 + 371))) or ((13172 - 9335) < (2274 - (478 + 490)))) then
				if (((1563 + 1387) == (4122 - (786 + 386))) and (v90 < v103) and v36 and ((v54 and v29) or not v54) and v97.ColossusSmash:IsCastable()) then
					local v189 = 0 - 0;
					while true do
						if ((v189 == (1379 - (1055 + 324))) or ((6063 - (1093 + 247)) < (2931 + 367))) then
							if (((120 + 1016) >= (611 - 457)) and v93.CastCycle(v97.ColossusSmash, v104, v107, not v101)) then
								return "colossus_smash hac 73";
							end
							if (v23(v97.ColossusSmash, not v101) or ((919 - 648) > (13510 - 8762))) then
								return "colossus_smash hac 14";
							end
							break;
						end
					end
				end
				if (((11911 - 7171) >= (1122 + 2030)) and (v90 < v103) and v36 and ((v54 and v29) or not v54) and v97.ColossusSmash:IsCastable()) then
					if (v23(v97.ColossusSmash, not v101) or ((9931 - 7353) >= (11684 - 8294))) then
						return "colossus_smash hac 16";
					end
				end
				if (((31 + 10) <= (4247 - 2586)) and v97.Execute:IsReady() and v37 and v13:BuffUp(v97.SuddenDeathBuff) and v13:HasTier(719 - (364 + 324), 10 - 6)) then
					if (((1442 - 841) < (1180 + 2380)) and v23(v97.Execute, not v101)) then
						return "execute hac 18";
					end
				end
				v131 = 12 - 9;
			end
			if (((376 - 141) < (2086 - 1399)) and (v131 == (1274 - (1249 + 19)))) then
				if (((4107 + 442) > (4488 - 3335)) and v97.Overpower:IsCastable() and v40) then
					if (v23(v97.Overpower, not v101) or ((5760 - (686 + 400)) < (3666 + 1006))) then
						return "overpower hac 36";
					end
				end
				if (((3897 - (73 + 156)) < (22 + 4539)) and v97.MortalStrike:IsReady() and v39) then
					if (v93.CastCycle(v97.MortalStrike, v104, v108, not v101) or ((1266 - (721 + 90)) == (41 + 3564))) then
						return "mortal_strike hac 83";
					end
					if (v23(v97.MortalStrike, not v101) or ((8646 - 5983) == (3782 - (224 + 246)))) then
						return "mortal_strike hac 83";
					end
				end
				if (((6928 - 2651) <= (8239 - 3764)) and v97.Execute:IsReady() and v37 and (v13:BuffUp(v97.SuddenDeathBuff) or (v14:HealthPercentage() < (4 + 16)) or (v97.Massacre:IsAvailable() and (v14:HealthPercentage() < (1 + 34))) or v13:BuffUp(v97.SweepingStrikesBuff) or (v105 <= (2 + 0)))) then
					if (v93.CastCycle(v97.Execute, v104, v109, not v101) or ((1729 - 859) == (3956 - 2767))) then
						return "execute hac 84";
					end
					if (((2066 - (203 + 310)) <= (5126 - (1238 + 755))) and v23(v97.Execute, not v101)) then
						return "execute hac 84";
					end
				end
				v131 = 1 + 6;
			end
			if ((v131 == (1534 - (709 + 825))) or ((4122 - 1885) >= (5114 - 1603))) then
				if ((v97.Execute:IsReady() and v37 and v13:BuffUp(v97.JuggernautBuff) and (v13:BuffRemains(v97.JuggernautBuff) < v13:GCD()) and v13:HasTier(895 - (196 + 668), 15 - 11)) or ((2742 - 1418) > (3853 - (171 + 662)))) then
					if (v23(v97.Execute, not v101) or ((3085 - (4 + 89)) == (6592 - 4711))) then
						return "execute hac 2";
					end
				end
				if (((1131 + 1975) > (6702 - 5176)) and v97.Whirlwind:IsReady() and ((v13:BuffUp(v97.CollateralDamageBuff) and (v97.SweepingStrikes:CooldownRemains() < (2 + 1))) or (v14:DebuffUp(v97.DeepWoundsDebuff) and v14:DebuffUp(v97.ColossusSmashDebuff) and v13:BuffDown(v97.SweepingStrikesBuff))) and v50) then
					if (((4509 - (35 + 1451)) < (5323 - (28 + 1425))) and v23(v97.Whirlwind, not v14:IsInMeleeRange(2001 - (941 + 1052)))) then
						return "whirlwind hac 4";
					end
				end
				if (((138 + 5) > (1588 - (822 + 692))) and v97.ThunderClap:IsReady() and v47 and v97.BloodandThunder:IsAvailable() and v97.Rend:IsAvailable() and v14:DebuffRefreshable(v97.RendDebuff)) then
					if (((25 - 7) < (995 + 1117)) and v23(v97.ThunderClap, not v101)) then
						return "thunder_clap hac 6";
					end
				end
				v131 = 298 - (45 + 252);
			end
			if (((1086 + 11) <= (561 + 1067)) and (v131 == (9 - 5))) then
				if (((5063 - (114 + 319)) == (6647 - 2017)) and (v90 < v103) and v83 and ((v55 and v29) or not v55) and (v84 == "player") and v97.ChampionsSpear:IsCastable() and (v13:BuffUp(v97.TestofMightBuff) or v14:DebuffUp(v97.ColossusSmashDebuff) or v14:DebuffUp(v97.DeepWoundsDebuff))) then
					if (((4536 - 996) > (1711 + 972)) and v23(v99.ChampionsSpearPlayer, not v101)) then
						return "spear_of_bastion hac 26";
					end
				end
				if (((7141 - 2347) >= (6861 - 3586)) and (v90 < v103) and v83 and ((v55 and v29) or not v55) and (v84 == "cursor") and v97.ChampionsSpear:IsCastable() and (v13:BuffUp(v97.TestofMightBuff) or v14:DebuffUp(v97.ColossusSmashDebuff) or v14:DebuffUp(v97.DeepWoundsDebuff))) then
					if (((3447 - (556 + 1407)) == (2690 - (741 + 465))) and v23(v99.ChampionsSpearCursor, not v14:IsInRange(485 - (170 + 295)))) then
						return "spear_of_bastion hac 27";
					end
				end
				if (((755 + 677) < (3266 + 289)) and (v90 < v103) and v33 and ((v53 and v29) or not v53) and v97.Bladestorm:IsCastable() and ((v13:BuffRemains(v97.HurricaneBuff) < (7 - 4)) or not v97.Hurricane:IsAvailable())) then
					if (v23(v97.Bladestorm, not v101) or ((883 + 182) > (2295 + 1283))) then
						return "bladestorm hac 28";
					end
				end
				v131 = 3 + 2;
			end
			if (((1233 - (957 + 273)) == v131) or ((1283 + 3512) < (564 + 843))) then
				if (((7060 - 5207) < (12683 - 7870)) and v97.Cleave:IsReady() and v35 and (v13:BuffStack(v97.MartialProwessBuff) > (0 - 0))) then
					if (v23(v97.Cleave, not v101) or ((13968 - 11147) < (4211 - (389 + 1391)))) then
						return "cleave hac 20";
					end
				end
				if ((v97.MortalStrike:IsReady() and v39 and v97.SharpenedBlades:IsAvailable() and v13:BuffUp(v97.SweepingStrikes) and (v13:BuffStack(v97.MartialProwessBuff) == (2 + 0)) and (v105 <= (1 + 3))) or ((6542 - 3668) < (3132 - (783 + 168)))) then
					if (v23(v97.MortalStrike, not v101) or ((9024 - 6335) <= (338 + 5))) then
						return "mortal_strike hac 22";
					end
				end
				if (((v90 < v103) and v48 and ((v56 and v29) or not v56) and v97.ThunderousRoar:IsCastable() and (v13:BuffUp(v97.TestofMightBuff) or v14:DebuffUp(v97.ColossusSmashDebuff) or v14:DebuffUp(v97.DeepWoundsDebuff))) or ((2180 - (309 + 2)) == (6169 - 4160))) then
					if (v23(v97.ThunderousRoar, not v14:IsInMeleeRange(1220 - (1090 + 122))) or ((1150 + 2396) < (7798 - 5476))) then
						return "thunderous_roar hac 24";
					end
				end
				v131 = 3 + 1;
			end
			if (((1123 - (628 + 490)) == v131) or ((374 + 1708) == (11817 - 7044))) then
				if (((14825 - 11581) > (1829 - (431 + 343))) and v97.Cleave:IsReady() and v35 and (not v97.FervorofBattle:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v14:DebuffRemains(v97.DeepWoundsDebuff) <= (v97.DeepWoundsDebuff:BaseDuration() * (0.3 - 0)))))) then
					if (v23(v97.Cleave, not v101) or ((9584 - 6271) <= (1405 + 373))) then
						return "cleave hac 30";
					end
				end
				if ((v97.Overpower:IsCastable() and v40 and v13:BuffUp(v97.SweepingStrikes) and (v97.Dreadnaught:IsAvailable() or (v97.Overpower:Charges() == (1 + 1)))) or ((3116 - (556 + 1139)) >= (2119 - (6 + 9)))) then
					if (((332 + 1480) <= (1665 + 1584)) and v23(v97.Overpower, not v101)) then
						return "overpower hac 32";
					end
				end
				if (((1792 - (28 + 141)) <= (758 + 1199)) and v97.Whirlwind:IsReady() and v50 and (v97.FervorofBattle:IsAvailable() or v97.StormofSwords:IsAvailable())) then
					if (((5445 - 1033) == (3125 + 1287)) and v23(v97.Whirlwind, not v14:IsInMeleeRange(1325 - (486 + 831)))) then
						return "whirlwind hac 34";
					end
				end
				v131 = 15 - 9;
			end
			if (((6161 - 4411) >= (160 + 682)) and (v131 == (3 - 2))) then
				if (((5635 - (668 + 595)) > (1665 + 185)) and v97.SweepingStrikes:IsCastable() and v46 and ((v97.Bladestorm:CooldownRemains() > (4 + 11)) or (v97.ImprovedSweepingStrikes:IsAvailable() and (v97.Bladestorm:CooldownRemains() > (57 - 36))) or not v97.Bladestorm:IsAvailable()) and v14:DebuffUp(v97.RendDebuff) and (v14:DebuffUp(v97.ThunderousRoarDebuff) or (v97.ThunderousRoar:CooldownRemains() > (290 - (23 + 267)))) and (v13:PrevGCD(1945 - (1129 + 815), v97.Cleave) or v13:BuffUp(v97.StrikeVulnerabilitiesBuff) or not v13:HasTier(417 - (371 + 16), 1754 - (1326 + 424)))) then
					if (((439 - 207) < (3000 - 2179)) and v23(v97.SweepingStrikes, not v14:IsInMeleeRange(126 - (88 + 30)))) then
						return "sweeping_strikes hac 8";
					end
				end
				if (((1289 - (720 + 51)) < (2006 - 1104)) and (v90 < v103) and v31 and ((v52 and v29) or not v52) and v97.Avatar:IsCastable() and (v97.BlademastersTorment:IsAvailable() or (v103 < (1796 - (421 + 1355))) or (v13:BuffRemains(v97.HurricaneBuff) < (4 - 1)))) then
					if (((1471 + 1523) > (1941 - (286 + 797))) and v23(v97.Avatar, not v101)) then
						return "avatar hac 10";
					end
				end
				if (((v90 < v103) and v97.Warbreaker:IsCastable() and v49 and ((v57 and v29) or not v57) and (v105 > (3 - 2))) or ((6219 - 2464) <= (1354 - (397 + 42)))) then
					if (((1233 + 2713) > (4543 - (24 + 776))) and v23(v97.Warbreaker, not v101)) then
						return "warbreaker hac 12";
					end
				end
				v131 = 2 - 0;
			end
			if ((v131 == (793 - (222 + 563))) or ((2941 - 1606) >= (2381 + 925))) then
				if (((5034 - (23 + 167)) > (4051 - (690 + 1108))) and v97.Slam:IsReady() and v45) then
					if (((164 + 288) == (373 + 79)) and v23(v97.Slam, not v101)) then
						return "slam hac 93";
					end
				end
				if ((v97.Shockwave:IsCastable() and v43) or ((5405 - (40 + 808)) < (344 + 1743))) then
					if (((14813 - 10939) == (3703 + 171)) and v23(v97.Shockwave, not v14:IsInMeleeRange(5 + 3))) then
						return "shockwave hac 94";
					end
				end
				if ((v97.WreckingThrow:IsCastable() and v51 and v106()) or ((1063 + 875) > (5506 - (47 + 524)))) then
					if (v23(v97.WreckingThrow, not v101) or ((2762 + 1493) < (9356 - 5933))) then
						return "wrecking_throw hac 95";
					end
				end
				break;
			end
			if (((2173 - 719) <= (5680 - 3189)) and (v131 == (1733 - (1165 + 561)))) then
				if ((v97.ThunderClap:IsReady() and v47 and (v105 > (1 + 2))) or ((12874 - 8717) <= (1070 + 1733))) then
					if (((5332 - (341 + 138)) >= (805 + 2177)) and v23(v97.ThunderClap, not v101)) then
						return "thunder_clap hac 85";
					end
				end
				if (((8530 - 4396) > (3683 - (89 + 237))) and v97.MortalStrike:IsReady() and v39) then
					if (v23(v97.MortalStrike, not v101) or ((10992 - 7575) < (5334 - 2800))) then
						return "mortal_strike hac 91";
					end
				end
				if ((v97.ThunderClap:IsReady() and v47 and not v97.CrushingForce:IsAvailable()) or ((3603 - (581 + 300)) <= (1384 - (855 + 365)))) then
					if (v23(v97.ThunderClap, not v101) or ((5719 - 3311) < (689 + 1420))) then
						return "thunder_clap hac 92";
					end
				end
				v131 = 1243 - (1030 + 205);
			end
		end
	end
	local function v115()
		if ((v97.Whirlwind:IsReady() and v50 and v13:BuffUp(v97.CollateralDamageBuff) and (v97.SweepingStrikes:CooldownRemains() < (3 + 0))) or ((31 + 2) == (1741 - (156 + 130)))) then
			if (v23(v97.Whirlwind, not v14:IsInMeleeRange(17 - 9)) or ((746 - 303) >= (8223 - 4208))) then
				return "whirlwind single_target 1";
			end
		end
		if (((892 + 2490) > (97 + 69)) and (v90 < v103) and v46 and v97.SweepingStrikes:IsCastable() and (v105 > (70 - (10 + 59)))) then
			if (v23(v97.SweepingStrikes, not v14:IsInMeleeRange(3 + 5)) or ((1378 - 1098) == (4222 - (671 + 492)))) then
				return "sweeping_strikes single_target 2";
			end
		end
		if (((1498 + 383) > (2508 - (369 + 846))) and v97.ThunderClap:IsReady() and v47 and (v14:DebuffRemains(v97.RendDebuff) <= v13:GCD()) and v97.BloodandThunder:IsAvailable() and v97.BlademastersTorment:IsAvailable()) then
			if (((624 + 1733) == (2012 + 345)) and v23(v97.ThunderClap, not v101)) then
				return "thunder_clap single_target 4";
			end
		end
		if (((2068 - (1036 + 909)) == (98 + 25)) and (v90 < v103) and v48 and ((v56 and v29) or not v56) and v97.ThunderousRoar:IsCastable()) then
			if (v23(v97.ThunderousRoar, not v14:IsInMeleeRange(13 - 5)) or ((1259 - (11 + 192)) >= (1715 + 1677))) then
				return "thunderous_roar single_target 6";
			end
		end
		if (((v90 < v103) and v33 and ((v53 and v29) or not v53) and v97.Bladestorm:IsCastable() and v97.Hurricane:IsAvailable() and (v103 > (197 - (135 + 40))) and v97.WarlordsTorment:IsAvailable()) or ((2619 - 1538) < (648 + 427))) then
			if (v23(v97.Bladestorm, not v101) or ((2310 - 1261) >= (6643 - 2211))) then
				return "bladestorm single_target 8";
			end
		end
		if (((v90 < v103) and v31 and ((v52 and v29) or not v52) and v97.Avatar:IsCastable() and (v103 < (196 - (50 + 126)))) or ((13276 - 8508) <= (188 + 658))) then
			if (v23(v97.Avatar, not v101) or ((4771 - (1233 + 180)) <= (2389 - (522 + 447)))) then
				return "avatar single_target 10";
			end
		end
		if (((v90 < v103) and v36 and ((v54 and v29) or not v54) and v97.ColossusSmash:IsCastable()) or ((5160 - (107 + 1314)) <= (1395 + 1610))) then
			if (v23(v97.ColossusSmash, not v101) or ((5054 - 3395) >= (907 + 1227))) then
				return "colossus_smash single_target 12";
			end
		end
		if (((v90 < v103) and v49 and ((v57 and v29) or not v57) and v97.Warbreaker:IsCastable()) or ((6473 - 3213) < (9317 - 6962))) then
			if (v23(v97.Warbreaker, not v101) or ((2579 - (716 + 1194)) == (73 + 4150))) then
				return "warbreaker single_target 14";
			end
		end
		if ((v97.MortalStrike:IsReady() and v39) or ((182 + 1510) < (1091 - (74 + 429)))) then
			if (v23(v97.MortalStrike, not v101) or ((9253 - 4456) < (1810 + 1841))) then
				return "mortal_strike single_target 16";
			end
		end
		if ((v97.Execute:IsReady() and v37 and ((v13:BuffUp(v97.JuggernautBuff) and (v13:BuffRemains(v97.JuggernautBuff) < v13:GCD())) or (v13:BuffUp(v97.SuddenDeathBuff) and (v14:DebuffRemains(v97.DeepWoundsDebuff) > (0 - 0)) and v13:HasTier(22 + 9, 5 - 3)) or (v13:BuffUp(v97.SuddenDeathBuff) and not v14:DebuffUp(v97.RendDebuff) and v13:HasTier(76 - 45, 437 - (279 + 154))))) or ((4955 - (454 + 324)) > (3816 + 1034))) then
			if (v23(v97.Execute, not v101) or ((417 - (12 + 5)) > (600 + 511))) then
				return "execute single_target 18";
			end
		end
		if (((7773 - 4722) > (372 + 633)) and v97.ThunderClap:IsReady() and v47 and (v14:DebuffRemains(v97.RendDebuff) <= v13:GCD()) and v97.BloodandThunder:IsAvailable()) then
			if (((4786 - (277 + 816)) <= (18724 - 14342)) and v23(v97.ThunderClap, not v101)) then
				return "thunder_clap single_target 20";
			end
		end
		if ((v97.Rend:IsReady() and v41 and (v14:DebuffRemains(v97.RendDebuff) <= v13:GCD()) and not v97.BloodandThunder:IsAvailable()) or ((4465 - (1058 + 125)) > (769 + 3331))) then
			if (v23(v97.Rend, not v101) or ((4555 - (815 + 160)) < (12202 - 9358))) then
				return "rend single_target 22";
			end
		end
		if (((211 - 122) < (1072 + 3418)) and v97.Whirlwind:IsReady() and v50 and v97.StormofSwords:IsAvailable() and v14:DebuffUp(v97.ColossusSmashDebuff)) then
			if (v23(v97.Whirlwind, not v14:IsInMeleeRange(23 - 15)) or ((6881 - (41 + 1857)) < (3701 - (1222 + 671)))) then
				return "whirlwind single_target 24";
			end
		end
		if (((9896 - 6067) > (5417 - 1648)) and (v90 < v103) and v33 and ((v53 and v29) or not v53) and v97.Bladestorm:IsCastable() and v97.Hurricane:IsAvailable() and (v13:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v14:DebuffUp(v97.ColossusSmashDebuff) and (v13:BuffRemains(v97.HurricaneBuff) < (1184 - (229 + 953)))))) then
			if (((3259 - (1111 + 663)) <= (4483 - (874 + 705))) and v23(v97.Bladestorm, not v101)) then
				return "bladestorm single_target 26";
			end
		end
		if (((598 + 3671) == (2913 + 1356)) and (v90 < v103) and v83 and ((v55 and v29) or not v55) and (v84 == "player") and v97.ChampionsSpear:IsCastable() and (v13:BuffUp(v97.TestofMightBuff) or v14:DebuffUp(v97.ColossusSmashDebuff))) then
			if (((803 - 416) <= (79 + 2703)) and v23(v99.ChampionsSpearPlayer, not v101)) then
				return "spear_of_bastion single_target 28";
			end
		end
		if (((v90 < v103) and v83 and ((v55 and v29) or not v55) and (v84 == "cursor") and v97.ChampionsSpear:IsCastable() and (v13:BuffUp(v97.TestofMightBuff) or v14:DebuffUp(v97.ColossusSmashDebuff))) or ((2578 - (642 + 37)) <= (210 + 707))) then
			if (v23(v99.ChampionsSpearCursor, not v14:IsInRange(4 + 16)) or ((10826 - 6514) <= (1330 - (233 + 221)))) then
				return "spear_of_bastion single_target 29";
			end
		end
		if (((5160 - 2928) <= (2285 + 311)) and v97.Skullsplitter:IsCastable() and v44) then
			if (((3636 - (718 + 823)) < (2320 + 1366)) and v23(v97.Skullsplitter, not v101)) then
				return "skullsplitter single_target 30";
			end
		end
		if ((v97.Execute:IsReady() and v37 and v13:BuffUp(v97.SuddenDeathBuff)) or ((2400 - (266 + 539)) >= (12666 - 8192))) then
			if (v23(v97.Execute, not v101) or ((5844 - (636 + 589)) < (6840 - 3958))) then
				return "execute single_target 32";
			end
		end
		if ((v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable() or v14:IsCasting())) or ((606 - 312) >= (3829 + 1002))) then
			if (((738 + 1291) <= (4099 - (657 + 358))) and v23(v97.Shockwave, not v14:IsInMeleeRange(21 - 13))) then
				return "shockwave single_target 34";
			end
		end
		if ((v97.Whirlwind:IsReady() and v50 and v97.StormofSwords:IsAvailable() and v97.TestofMight:IsAvailable() and (v97.ColossusSmash:CooldownRemains() > (v13:GCD() * (15 - 8)))) or ((3224 - (1151 + 36)) == (2337 + 83))) then
			if (((1173 + 3285) > (11658 - 7754)) and v23(v97.Whirlwind, not v14:IsInMeleeRange(1840 - (1552 + 280)))) then
				return "whirlwind single_target 36";
			end
		end
		if (((1270 - (64 + 770)) >= (84 + 39)) and v97.Overpower:IsCastable() and v40 and (((v97.Overpower:Charges() == (4 - 2)) and not v97.Battlelord:IsAvailable()) or v97.Battlelord:IsAvailable())) then
			if (((89 + 411) < (3059 - (157 + 1086))) and v23(v97.Overpower, not v101)) then
				return "overpower single_target 38";
			end
		end
		if (((7153 - 3579) == (15653 - 12079)) and v97.Whirlwind:IsReady() and v50 and (v97.StormofSwords:IsAvailable())) then
			if (((338 - 117) < (532 - 142)) and v23(v97.Whirlwind, not v14:IsInMeleeRange(827 - (599 + 220)))) then
				return "whirlwind single_target 40";
			end
		end
		if ((v97.ThunderClap:IsReady() and v47) or ((4406 - 2193) <= (3352 - (1813 + 118)))) then
			if (((2236 + 822) < (6077 - (841 + 376))) and v23(v97.ThunderClap, not v101)) then
				return "thunder_clap single_target 42";
			end
		end
		if ((v97.Slam:IsReady() and v45 and v97.CrushingForce:IsAvailable()) or ((1815 - 519) >= (1033 + 3413))) then
			if (v23(v97.Slam, not v101) or ((3802 - 2409) > (5348 - (464 + 395)))) then
				return "slam single_target 44";
			end
		end
		if ((v97.Whirlwind:IsReady() and v50 and v13:BuffUp(v97.MercilessBonegrinderBuff)) or ((11353 - 6929) < (13 + 14))) then
			if (v23(v97.Whirlwind, not v14:IsInMeleeRange(845 - (467 + 370))) or ((4126 - 2129) > (2801 + 1014))) then
				return "whirlwind single_target 46";
			end
		end
		if (((11878 - 8413) > (299 + 1614)) and v97.Slam:IsReady() and v45) then
			if (((1705 - 972) < (2339 - (150 + 370))) and v23(v97.Slam, not v101)) then
				return "slam single_target 48";
			end
		end
		if (((v90 < v103) and v33 and ((v53 and v29) or not v53) and v97.Bladestorm:IsCastable()) or ((5677 - (74 + 1208)) == (11695 - 6940))) then
			if (v23(v97.Bladestorm, not v101) or ((17988 - 14195) < (1686 + 683))) then
				return "bladestorm single_target 50";
			end
		end
		if ((v97.Cleave:IsReady() and v35) or ((4474 - (14 + 376)) == (459 - 194))) then
			if (((2820 + 1538) == (3829 + 529)) and v23(v97.Cleave, not v101)) then
				return "cleave single_target 52";
			end
		end
		if ((v97.WreckingThrow:IsCastable() and v51 and v106()) or ((2993 + 145) < (2909 - 1916))) then
			if (((2506 + 824) > (2401 - (23 + 55))) and v23(v97.WreckingThrow, not v101)) then
				return "wrecking_throw single_target 54";
			end
		end
	end
	local function v116()
		if (not v13:AffectingCombat() or ((8593 - 4967) == (2662 + 1327))) then
			local v174 = 0 + 0;
			while true do
				if ((v174 == (0 - 0)) or ((289 + 627) == (3572 - (652 + 249)))) then
					if (((727 - 455) == (2140 - (708 + 1160))) and v97.BattleStance:IsCastable() and v13:BuffDown(v97.BattleStance, true)) then
						if (((11533 - 7284) <= (8822 - 3983)) and v23(v97.BattleStance)) then
							return "battle_stance";
						end
					end
					if (((2804 - (10 + 17)) < (719 + 2481)) and v97.BattleShout:IsCastable() and v32 and (v13:BuffDown(v97.BattleShoutBuff, true) or v93.GroupBuffMissing(v97.BattleShoutBuff))) then
						if (((1827 - (1400 + 332)) < (3753 - 1796)) and v23(v97.BattleShout)) then
							return "battle_shout precombat";
						end
					end
					break;
				end
			end
		end
		if (((2734 - (242 + 1666)) < (735 + 982)) and v93.TargetIsValid() and v27) then
			if (((523 + 903) >= (942 + 163)) and not v13:AffectingCombat()) then
				local v188 = 940 - (850 + 90);
				while true do
					if (((4823 - 2069) <= (4769 - (360 + 1030))) and (v188 == (0 + 0))) then
						v26 = v112();
						if (v26 or ((11084 - 7157) == (1943 - 530))) then
							return v26;
						end
						break;
					end
				end
			end
		end
	end
	local function v117()
		local v132 = 1661 - (909 + 752);
		while true do
			if ((v132 == (1224 - (109 + 1114))) or ((2112 - 958) <= (307 + 481))) then
				if (v85 or ((1885 - (6 + 236)) > (2129 + 1250))) then
					v26 = v93.HandleIncorporeal(v97.StormBolt, v99.StormBoltMouseover, 17 + 3, true);
					if (v26 or ((6610 - 3807) > (7945 - 3396))) then
						return v26;
					end
					v26 = v93.HandleIncorporeal(v97.IntimidatingShout, v99.IntimidatingShoutMouseover, 1141 - (1076 + 57), true);
					if (v26 or ((37 + 183) >= (3711 - (579 + 110)))) then
						return v26;
					end
				end
				if (((223 + 2599) == (2496 + 326)) and v93.TargetIsValid()) then
					if ((v34 and v97.Charge:IsCastable() and not v101) or ((564 + 497) == (2264 - (174 + 233)))) then
						if (((7709 - 4949) > (2393 - 1029)) and v23(v97.Charge, not v14:IsSpellInRange(v97.Charge))) then
							return "charge main 34";
						end
					end
					local v190 = v93.HandleDPSPotion((v14:DebuffRemains(v97.ColossusSmashDebuff) > (4 + 4)) or (v103 < (1199 - (663 + 511))));
					if (v190 or ((4374 + 528) <= (781 + 2814))) then
						return v190;
					end
					if ((v101 and v91 and ((v59 and v29) or not v59) and (v90 < v103)) or ((11875 - 8023) == (178 + 115))) then
						if ((v97.BloodFury:IsCastable() and v14:DebuffUp(v97.ColossusSmashDebuff)) or ((3670 - 2111) == (11106 - 6518))) then
							if (v23(v97.BloodFury) or ((2140 + 2344) == (1533 - 745))) then
								return "blood_fury main 39";
							end
						end
						if (((3256 + 1312) >= (358 + 3549)) and v97.Berserking:IsCastable() and (v14:DebuffRemains(v97.ColossusSmashDebuff) > (728 - (478 + 244)))) then
							if (((1763 - (440 + 77)) < (1578 + 1892)) and v23(v97.Berserking)) then
								return "berserking main 40";
							end
						end
						if (((14889 - 10821) >= (2528 - (655 + 901))) and v97.ArcaneTorrent:IsCastable() and (v97.MortalStrike:CooldownRemains() > (1.5 + 0)) and (v13:Rage() < (39 + 11))) then
							if (((333 + 160) < (15683 - 11790)) and v23(v97.ArcaneTorrent, not v14:IsInRange(1453 - (695 + 750)))) then
								return "arcane_torrent main 41";
							end
						end
						if ((v97.LightsJudgment:IsCastable() and v14:DebuffDown(v97.ColossusSmashDebuff) and not v97.MortalStrike:CooldownUp()) or ((5029 - 3556) >= (5141 - 1809))) then
							if (v23(v97.LightsJudgment, not v14:IsSpellInRange(v97.LightsJudgment)) or ((16292 - 12241) <= (1508 - (285 + 66)))) then
								return "lights_judgment main 42";
							end
						end
						if (((1407 - 803) < (4191 - (682 + 628))) and v97.Fireblood:IsCastable() and (v14:DebuffUp(v97.ColossusSmashDebuff))) then
							if (v23(v97.Fireblood) or ((146 + 754) == (3676 - (176 + 123)))) then
								return "fireblood main 43";
							end
						end
						if (((1866 + 2593) > (429 + 162)) and v97.AncestralCall:IsCastable() and (v14:DebuffUp(v97.ColossusSmashDebuff))) then
							if (((3667 - (239 + 30)) >= (652 + 1743)) and v23(v97.AncestralCall)) then
								return "ancestral_call main 44";
							end
						end
						if ((v97.BagofTricks:IsCastable() and v14:DebuffDown(v97.ColossusSmashDebuff) and not v97.MortalStrike:CooldownUp()) or ((2099 + 84) >= (4998 - 2174))) then
							if (((6039 - 4103) == (2251 - (306 + 9))) and v23(v97.BagofTricks, not v14:IsSpellInRange(v97.BagofTricks))) then
								return "bag_of_tricks main 10";
							end
						end
					end
					if ((v90 < v103) or ((16861 - 12029) < (751 + 3562))) then
						if (((2509 + 1579) > (1865 + 2009)) and v92 and ((v29 and v58) or not v58)) then
							local v194 = 0 - 0;
							while true do
								if (((5707 - (1140 + 235)) == (2757 + 1575)) and (v194 == (0 + 0))) then
									v26 = v111();
									if (((1027 + 2972) >= (2952 - (33 + 19))) and v26) then
										return v26;
									end
									break;
								end
							end
						end
						if ((v29 and v98.FyralathTheDreamrender:IsEquippedAndReady() and v30) or ((912 + 1613) > (12180 - 8116))) then
							if (((1926 + 2445) == (8571 - 4200)) and v23(v99.UseWeapon)) then
								return "Fyralath The Dreamrender used";
							end
						end
					end
					if ((v38 and v97.HeroicThrow:IsCastable() and not v14:IsInRange(24 + 1) and v13:CanAttack(v14)) or ((955 - (586 + 103)) > (454 + 4532))) then
						if (((6129 - 4138) >= (2413 - (1309 + 179))) and v23(v97.HeroicThrow, not v14:IsSpellInRange(v97.HeroicThrow))) then
							return "heroic_throw main";
						end
					end
					if (((821 - 366) < (894 + 1159)) and v97.WreckingThrow:IsCastable() and v51 and v106() and v13:CanAttack(v14)) then
						if (v23(v97.WreckingThrow, not v14:IsSpellInRange(v97.WreckingThrow)) or ((2218 - 1392) == (3665 + 1186))) then
							return "wrecking_throw main";
						end
					end
					if (((388 - 205) == (364 - 181)) and v28 and ((v105 > (611 - (295 + 314))) or (v97.FervorofBattle:IsAvailable() and ((v97.Massacre:IsAvailable() and (v14:HealthPercentage() > (85 - 50))) or (v14:HealthPercentage() > (1982 - (1300 + 662)))) and (v105 > (3 - 2))))) then
						local v191 = 1755 - (1178 + 577);
						while true do
							if (((602 + 557) <= (5285 - 3497)) and (v191 == (1405 - (851 + 554)))) then
								v26 = v114();
								if (v26 or ((3102 + 405) > (11975 - 7657))) then
									return v26;
								end
								break;
							end
						end
					end
					if ((v97.Massacre:IsAvailable() and (v14:HealthPercentage() < (76 - 41))) or (v14:HealthPercentage() < (322 - (115 + 187))) or ((2355 + 720) <= (2807 + 158))) then
						local v192 = 0 - 0;
						while true do
							if (((2526 - (160 + 1001)) <= (1760 + 251)) and (v192 == (0 + 0))) then
								v26 = v113();
								if (v26 or ((5682 - 2906) > (3933 - (237 + 121)))) then
									return v26;
								end
								break;
							end
						end
					end
					v26 = v115();
					if (v26 or ((3451 - (525 + 372)) == (9107 - 4303))) then
						return v26;
					end
					if (((8466 - 5889) == (2719 - (96 + 46))) and v19.CastAnnotated(v97.Pool, false, "WAIT")) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if ((v132 == (777 - (643 + 134))) or ((3 + 3) >= (4529 - 2640))) then
				v26 = v110();
				if (((1878 - 1372) <= (1815 + 77)) and v26) then
					return v26;
				end
				v132 = 1 - 0;
			end
		end
	end
	local function v118()
		v30 = EpicSettings.Settings['useWeapon'];
		v32 = EpicSettings.Settings['useBattleShout'];
		v34 = EpicSettings.Settings['useCharge'];
		v35 = EpicSettings.Settings['useCleave'];
		v37 = EpicSettings.Settings['useExecute'];
		v38 = EpicSettings.Settings['useHeroicThrow'];
		v39 = EpicSettings.Settings['useMortalStrike'];
		v40 = EpicSettings.Settings['useOverpower'];
		v41 = EpicSettings.Settings['useRend'];
		v43 = EpicSettings.Settings['useShockwave'];
		v44 = EpicSettings.Settings['useSkullsplitter'];
		v45 = EpicSettings.Settings['useSlam'];
		v46 = EpicSettings.Settings['useSweepingStrikes'];
		v47 = EpicSettings.Settings['useThunderClap'];
		v50 = EpicSettings.Settings['useWhirlwind'];
		v51 = EpicSettings.Settings['useWreckingThrow'];
		v31 = EpicSettings.Settings['useAvatar'];
		v33 = EpicSettings.Settings['useBladestorm'];
		v36 = EpicSettings.Settings['useColossusSmash'];
		v83 = EpicSettings.Settings['useChampionsSpear'];
		v48 = EpicSettings.Settings['useThunderousRoar'];
		v49 = EpicSettings.Settings['useWarbreaker'];
		v52 = EpicSettings.Settings['avatarWithCD'];
		v53 = EpicSettings.Settings['bladestormWithCD'];
		v54 = EpicSettings.Settings['colossusSmashWithCD'];
		v55 = EpicSettings.Settings['championsSpearWithCD'];
		v56 = EpicSettings.Settings['thunderousRoarWithCD'];
		v57 = EpicSettings.Settings['warbreakerWithCD'];
	end
	local function v119()
		v60 = EpicSettings.Settings['usePummel'];
		v61 = EpicSettings.Settings['useStormBolt'];
		v62 = EpicSettings.Settings['useIntimidatingShout'];
		v63 = EpicSettings.Settings['useBitterImmunity'];
		v68 = EpicSettings.Settings['useDefensiveStance'];
		v64 = EpicSettings.Settings['useDieByTheSword'];
		v65 = EpicSettings.Settings['useIgnorePain'];
		v67 = EpicSettings.Settings['useIntervene'];
		v66 = EpicSettings.Settings['useRallyingCry'];
		v71 = EpicSettings.Settings['useVictoryRush'];
		v72 = EpicSettings.Settings['bitterImmunityHP'] or (0 - 0);
		v78 = EpicSettings.Settings['defensiveStanceHP'] or (719 - (316 + 403));
		v81 = EpicSettings.Settings['unstanceHP'] or (0 + 0);
		v73 = EpicSettings.Settings['dieByTheSwordHP'] or (0 - 0);
		v74 = EpicSettings.Settings['ignorePainHP'] or (0 + 0);
		v77 = EpicSettings.Settings['interveneHP'] or (0 - 0);
		v76 = EpicSettings.Settings['rallyingCryGroup'] or (0 + 0);
		v75 = EpicSettings.Settings['rallyingCryHP'] or (0 + 0);
		v82 = EpicSettings.Settings['victoryRushHP'] or (0 - 0);
		v84 = EpicSettings.Settings['spearSetting'] or "player";
	end
	local function v120()
		local v171 = 0 - 0;
		while true do
			if ((v171 == (7 - 3)) or ((115 + 1893) > (4365 - 2147))) then
				v86 = EpicSettings.Settings['HealingPotionName'] or "";
				v85 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((19 + 360) <= (12200 - 8053)) and (v171 == (19 - (12 + 5)))) then
				v58 = EpicSettings.Settings['trinketsWithCD'];
				v59 = EpicSettings.Settings['racialsWithCD'];
				v69 = EpicSettings.Settings['useHealthstone'];
				v171 = 11 - 8;
			end
			if ((v171 == (5 - 2)) or ((9595 - 5081) <= (2501 - 1492))) then
				v70 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v80 = EpicSettings.Settings['healingPotionHP'] or (1973 - (1656 + 317));
				v171 = 4 + 0;
			end
			if ((v171 == (0 + 0)) or ((9295 - 5799) == (5866 - 4674))) then
				v90 = EpicSettings.Settings['fightRemainsCheck'] or (354 - (5 + 349));
				v87 = EpicSettings.Settings['InterruptWithStun'];
				v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v171 = 4 - 3;
			end
			if ((v171 == (1272 - (266 + 1005))) or ((138 + 70) == (10096 - 7137))) then
				v89 = EpicSettings.Settings['InterruptThreshold'];
				v92 = EpicSettings.Settings['useTrinkets'];
				v91 = EpicSettings.Settings['useRacials'];
				v171 = 2 - 0;
			end
		end
	end
	local function v121()
		local v172 = 1696 - (561 + 1135);
		while true do
			if (((5573 - 1296) >= (4315 - 3002)) and ((1068 - (507 + 559)) == v172)) then
				v101 = v14:IsInMeleeRange(20 - 12);
				if (((8000 - 5413) < (3562 - (212 + 176))) and (v93.TargetIsValid() or v13:AffectingCombat())) then
					v102 = v9.BossFightRemains(nil, true);
					v103 = v102;
					if ((v103 == (12016 - (250 + 655))) or ((11234 - 7114) <= (3840 - 1642))) then
						v103 = v9.FightRemains(v104, false);
					end
				end
				if (not v13:IsChanneling() or ((2496 - 900) == (2814 - (1869 + 87)))) then
					if (((11168 - 7948) == (5121 - (484 + 1417))) and v13:AffectingCombat()) then
						v26 = v117();
						if (v26 or ((3004 - 1602) > (6066 - 2446))) then
							return v26;
						end
					else
						local v193 = 773 - (48 + 725);
						while true do
							if (((4204 - 1630) == (6905 - 4331)) and (v193 == (0 + 0))) then
								v26 = v116();
								if (((4804 - 3006) < (772 + 1985)) and v26) then
									return v26;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v172 == (1 + 0)) or ((1230 - (152 + 701)) > (3915 - (430 + 881)))) then
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				if (((218 + 350) < (1806 - (557 + 338))) and v13:IsDeadOrGhost()) then
					return v26;
				end
				if (((971 + 2314) < (11914 - 7686)) and v28) then
					v104 = v13:GetEnemiesInMeleeRange(27 - 19);
					v105 = #v104;
				else
					v105 = 2 - 1;
				end
				v172 = 4 - 2;
			end
			if (((4717 - (499 + 302)) > (4194 - (39 + 827))) and (v172 == (0 - 0))) then
				v119();
				v118();
				v120();
				v27 = EpicSettings.Toggles['ooc'];
				v172 = 2 - 1;
			end
		end
	end
	local function v122()
		v19.Print("Arms Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(281 - 210, v121, v122);
end;
return v0["Epix_Warrior_Arms.lua"]();

