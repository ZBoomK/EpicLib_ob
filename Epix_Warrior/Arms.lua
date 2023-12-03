local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((326 + 309) == (376 + 259)) and not v5) then
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
	local v26 = 19 - 14;
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
	local v90;
	local v91;
	local v92;
	local v93 = v9.Commons.Everyone;
	local v94 = v13:GetEquipment();
	local v95 = (v94[2 + 11] and v18(v94[29 - 16])) or v18(0 + 0);
	local v96 = (v94[7 + 7] and v18(v94[42 - 28])) or v18(0 + 0);
	local v97 = v17.Warrior.Arms;
	local v98 = v18.Warrior.Arms;
	local v99 = v22.Warrior.Arms;
	local v100 = {};
	local v101;
	local v102 = 16944 - 5833;
	local v103 = 12355 - (485 + 759);
	v9:RegisterForEvent(function()
		local v123 = 0 - 0;
		while true do
			if (((4562 - (442 + 747)) <= (4691 - (832 + 303))) and (v123 == (946 - (88 + 858)))) then
				v102 = 3387 + 7724;
				v103 = 9196 + 1915;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		local v124 = 0 + 0;
		while true do
			if ((v124 == (790 - (766 + 23))) or ((16246 - 12955) < (4485 - 1205))) then
				v96 = (v94[36 - 22] and v18(v94[47 - 33])) or v18(1073 - (1036 + 37));
				break;
			end
			if (((3110 + 1276) >= (1699 - 826)) and (v124 == (0 + 0))) then
				v94 = v13:GetEquipment();
				v95 = (v94[1493 - (641 + 839)] and v18(v94[926 - (910 + 3)])) or v18(0 - 0);
				v124 = 1685 - (1466 + 218);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v104;
	local v105;
	local function v106()
		local v125 = 0 + 0;
		local v126;
		while true do
			if (((2069 - (556 + 592)) <= (392 + 710)) and (v125 == (808 - (329 + 479)))) then
				v126 = UnitGetTotalAbsorbs(v14);
				if (((5560 - (174 + 680)) >= (3308 - 2345)) and (v126 > (0 - 0))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v107(v127)
		return (v127:HealthPercentage() > (15 + 5)) or (v97.Massacre:IsAvailable() and (v127:HealthPercentage() < (774 - (396 + 343))));
	end
	local function v108(v128)
		return (v128:DebuffStack(v97.ExecutionersPrecisionDebuff) == (1 + 1)) or (v128:DebuffRemains(v97.DeepWoundsDebuff) <= v13:GCD()) or (v97.Dreadnaught:IsAvailable() and v97.Battlelord:IsAvailable() and (v105 <= (1479 - (29 + 1448))));
	end
	local function v109(v129)
		return v13:BuffUp(v97.SuddenDeathBuff) or ((v105 <= (1391 - (135 + 1254))) and ((v129:HealthPercentage() < (75 - 55)) or (v97.Massacre:IsAvailable() and (v129:HealthPercentage() < (163 - 128))))) or v13:BuffUp(v97.SweepingStrikes);
	end
	local function v110()
		local v130 = 0 + 0;
		while true do
			if ((v130 == (1528 - (389 + 1138))) or ((1534 - (102 + 472)) <= (827 + 49))) then
				if ((v97.IgnorePain:IsCastable() and v65 and (v13:HealthPercentage() <= v74)) or ((1146 + 920) == (870 + 62))) then
					if (((6370 - (320 + 1225)) < (8621 - 3778)) and v23(v97.IgnorePain, nil, nil, true)) then
						return "ignore_pain defensive";
					end
				end
				if ((v97.RallyingCry:IsCastable() and v66 and v13:BuffDown(v97.AspectsFavorBuff) and v13:BuffDown(v97.RallyingCry) and (((v13:HealthPercentage() <= v75) and v93.IsSoloMode()) or v93.AreUnitsBelowHealthPercentage(v75, v76))) or ((2373 + 1504) >= (6001 - (157 + 1307)))) then
					if (v23(v97.RallyingCry) or ((6174 - (821 + 1038)) < (4306 - 2580))) then
						return "rallying_cry defensive";
					end
				end
				v130 = 1 + 1;
			end
			if ((v130 == (3 - 1)) or ((1369 + 2310) < (1549 - 924))) then
				if ((v97.Intervene:IsCastable() and v67 and (v16:HealthPercentage() <= v77) and (v16:UnitName() ~= v13:UnitName())) or ((5651 - (834 + 192)) < (41 + 591))) then
					if (v23(v99.InterveneFocus) or ((22 + 61) > (39 + 1741))) then
						return "intervene defensive";
					end
				end
				if (((845 - 299) <= (1381 - (300 + 4))) and v97.DefensiveStance:IsCastable() and v13:BuffDown(v97.DefensiveStance, true) and v68 and (v13:HealthPercentage() <= v78)) then
					if (v23(v97.DefensiveStance) or ((266 + 730) > (11258 - 6957))) then
						return "defensive_stance defensive";
					end
				end
				v130 = 365 - (112 + 250);
			end
			if (((1623 + 2447) > (1720 - 1033)) and (v130 == (0 + 0))) then
				if ((v97.BitterImmunity:IsReady() and v63 and (v13:HealthPercentage() <= v72)) or ((340 + 316) >= (2491 + 839))) then
					if (v23(v97.BitterImmunity) or ((1236 + 1256) <= (249 + 86))) then
						return "bitter_immunity defensive";
					end
				end
				if (((5736 - (1001 + 413)) >= (5713 - 3151)) and v97.DieByTheSword:IsCastable() and v64 and (v13:HealthPercentage() <= v73)) then
					if (v23(v97.DieByTheSword) or ((4519 - (244 + 638)) >= (4463 - (627 + 66)))) then
						return "die_by_the_sword defensive";
					end
				end
				v130 = 2 - 1;
			end
			if ((v130 == (606 - (512 + 90))) or ((4285 - (1665 + 241)) > (5295 - (373 + 344)))) then
				if ((v70 and (v13:HealthPercentage() <= v80)) or ((218 + 265) > (197 + 546))) then
					local v192 = 0 - 0;
					while true do
						if (((4152 - 1698) > (1677 - (35 + 1064))) and (v192 == (0 + 0))) then
							if (((1989 - 1059) < (18 + 4440)) and (v86 == "Refreshing Healing Potion")) then
								if (((1898 - (298 + 938)) <= (2231 - (233 + 1026))) and v98.RefreshingHealingPotion:IsReady()) then
									if (((6036 - (636 + 1030)) == (2235 + 2135)) and v23(v99.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v86 == "Dreamwalker's Healing Potion") or ((4652 + 110) <= (256 + 605))) then
								if (v98.DreamwalkersHealingPotion:IsReady() or ((96 + 1316) == (4485 - (55 + 166)))) then
									if (v23(v99.RefreshingHealingPotion) or ((614 + 2554) < (217 + 1936))) then
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
			if ((v130 == (11 - 8)) or ((5273 - (36 + 261)) < (2329 - 997))) then
				if (((5996 - (34 + 1334)) == (1780 + 2848)) and v97.BattleStance:IsCastable() and v13:BuffDown(v97.BattleStance, true) and v68 and (v13:HealthPercentage() > v81)) then
					if (v23(v97.BattleStance) or ((42 + 12) == (1678 - (1035 + 248)))) then
						return "battle_stance after defensive stance defensive";
					end
				end
				if (((103 - (20 + 1)) == (43 + 39)) and v98.Healthstone:IsReady() and v69 and (v13:HealthPercentage() <= v79)) then
					if (v23(v99.Healthstone) or ((900 - (134 + 185)) < (1415 - (549 + 584)))) then
						return "healthstone defensive 3";
					end
				end
				v130 = 689 - (314 + 371);
			end
		end
	end
	local function v111()
		local v131 = 0 - 0;
		while true do
			if ((v131 == (968 - (478 + 490))) or ((2442 + 2167) < (3667 - (786 + 386)))) then
				v27 = v93.HandleTopTrinket(v100, v30, 129 - 89, nil);
				if (((2531 - (1055 + 324)) == (2492 - (1093 + 247))) and v27) then
					return v27;
				end
				v131 = 1 + 0;
			end
			if (((200 + 1696) <= (13585 - 10163)) and (v131 == (3 - 2))) then
				v27 = v93.HandleBottomTrinket(v100, v30, 113 - 73, nil);
				if (v27 or ((2487 - 1497) > (577 + 1043))) then
					return v27;
				end
				break;
			end
		end
	end
	local function v112()
		local v132 = 0 - 0;
		while true do
			if ((v132 == (0 - 0)) or ((662 + 215) > (12007 - 7312))) then
				if (((3379 - (364 + 324)) >= (5074 - 3223)) and v101) then
					local v193 = 0 - 0;
					while true do
						if ((v193 == (1 + 0)) or ((12490 - 9505) >= (7776 - 2920))) then
							if (((12986 - 8710) >= (2463 - (1249 + 19))) and (v90 < v103) and v97.Warbreaker:IsCastable() and v49 and ((v57 and v30) or not v57)) then
								if (((2918 + 314) <= (18255 - 13565)) and v23(v97.Warbreaker)) then
									return "warbreaker precombat";
								end
							end
							if ((v97.Overpower:IsCastable() and v40) or ((1982 - (686 + 400)) >= (2469 + 677))) then
								if (((3290 - (73 + 156)) >= (14 + 2944)) and v23(v97.Overpower)) then
									return "overpower precombat";
								end
							end
							break;
						end
						if (((3998 - (721 + 90)) >= (8 + 636)) and (v193 == (0 - 0))) then
							if (((1114 - (224 + 246)) <= (1139 - 435)) and v97.Skullsplitter:IsCastable() and v44) then
								if (((1763 - 805) > (172 + 775)) and v23(v97.Skullsplitter)) then
									return "skullsplitter precombat";
								end
							end
							if (((107 + 4385) >= (1950 + 704)) and (v90 < v103) and v97.ColossusSmash:IsCastable() and v36 and ((v54 and v30) or not v54)) then
								if (((6842 - 3400) >= (5001 - 3498)) and v23(v97.ColossusSmash)) then
									return "colossus_smash precombat";
								end
							end
							v193 = 514 - (203 + 310);
						end
					end
				end
				if ((v34 and v97.Charge:IsCastable()) or ((5163 - (1238 + 755)) <= (103 + 1361))) then
					if (v23(v97.Charge) or ((6331 - (709 + 825)) == (8085 - 3697))) then
						return "charge precombat";
					end
				end
				break;
			end
		end
	end
	local function v113()
		local v133 = 0 - 0;
		while true do
			if (((1415 - (196 + 668)) <= (2688 - 2007)) and ((1 - 0) == v133)) then
				if (((4110 - (171 + 662)) > (500 - (4 + 89))) and (v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) then
					if (((16455 - 11760) >= (516 + 899)) and v93.CastCycle(v97.ColossusSmash, v104, v107, not v101)) then
						return "colossus_smash hac 73";
					end
				end
				if (((v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) or ((14107 - 10895) <= (371 + 573))) then
					if (v23(v97.ColossusSmash, not v101) or ((4582 - (35 + 1451)) <= (3251 - (28 + 1425)))) then
						return "colossus_smash hac 74";
					end
				end
				if (((5530 - (941 + 1052)) == (3392 + 145)) and (v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable() and (v13:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v14:DebuffUp(v97.ColossusSmashDebuff)) or ((v105 > (1515 - (822 + 692))) and (v14:DebuffRemains(v97.DeepWoundsDebuff) > (0 - 0))))) then
					if (((1808 + 2029) >= (1867 - (45 + 252))) and v23(v97.ThunderousRoar, not v14:IsInMeleeRange(v26))) then
						return "thunderous_roar hac 75";
					end
				end
				if (((v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "player") and v97.SpearofBastion:IsCastable() and (v13:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v14:DebuffUp(v97.ColossusSmashDebuff)))) or ((2919 + 31) == (1312 + 2500))) then
					if (((11494 - 6771) >= (2751 - (114 + 319))) and v23(v99.SpearOfBastionPlayer, not v14:IsSpellInRange(v97.SpearofBastion))) then
						return "spear_of_bastion hac 76";
					end
				end
				if (((v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "cursor") and v97.SpearofBastion:IsCastable() and (v13:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v14:DebuffUp(v97.ColossusSmashDebuff)))) or ((2910 - 883) > (3654 - 802))) then
					if (v23(v99.SpearOfBastionCursor, not v14:IsSpellInRange(v97.SpearofBastion)) or ((725 + 411) > (6430 - 2113))) then
						return "spear_of_bastion hac 76";
					end
				end
				if (((9948 - 5200) == (6711 - (556 + 1407))) and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable() and v97.Unhinged:IsAvailable() and (v13:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v14:DebuffUp(v97.ColossusSmashDebuff)))) then
					if (((4942 - (741 + 465)) <= (5205 - (170 + 295))) and v23(v97.Bladestorm, not v101)) then
						return "bladestorm hac 77";
					end
				end
				v133 = 2 + 0;
			end
			if (((2 + 0) == v133) or ((8346 - 4956) <= (2537 + 523))) then
				if (((v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable() and (((v105 > (1 + 0)) and (v13:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v14:DebuffUp(v97.ColossusSmashDebuff)))) or ((v105 > (1 + 0)) and (v14:DebuffRemains(v97.DeepWoundsDebuff) > (1230 - (957 + 273)))))) or ((268 + 731) > (1079 + 1614))) then
					if (((1764 - 1301) < (1583 - 982)) and v23(v97.Bladestorm, not v101)) then
						return "bladestorm hac 78";
					end
				end
				if ((v97.Cleave:IsReady() and v35 and ((v105 > (5 - 3)) or (not v97.Battlelord:IsAvailable() and v13:BuffUp(v97.MercilessBonegrinderBuff) and (v97.MortalStrike:CooldownRemains() > v13:GCD())))) or ((10809 - 8626) < (2467 - (389 + 1391)))) then
					if (((2855 + 1694) == (474 + 4075)) and v23(v97.Cleave, not v101)) then
						return "cleave hac 79";
					end
				end
				if (((10635 - 5963) == (5623 - (783 + 168))) and v97.Whirlwind:IsReady() and v50 and ((v105 > (6 - 4)) or (v97.StormofSwords:IsAvailable() and (v13:BuffUp(v97.MercilessBonegrinderBuff) or v13:BuffUp(v97.HurricaneBuff))))) then
					if (v23(v97.Whirlwind, not v14:IsInMeleeRange(v26)) or ((3608 + 60) < (706 - (309 + 2)))) then
						return "whirlwind hac 80";
					end
				end
				if ((v97.Skullsplitter:IsCastable() and v44 and ((v13:Rage() < (122 - 82)) or (v97.TideofBlood:IsAvailable() and (v14:DebuffRemains(v97.RendDebuff) > (1212 - (1090 + 122))) and ((v13:BuffUp(v97.SweepingStrikes) and (v105 > (1 + 1))) or v14:DebuffUp(v97.ColossusSmashDebuff) or v13:BuffUp(v97.TestofMightBuff))))) or ((13991 - 9825) == (312 + 143))) then
					if (v23(v97.Skullsplitter, not v14:IsInMeleeRange(v26)) or ((5567 - (628 + 490)) == (478 + 2185))) then
						return "sweeping_strikes execute 81";
					end
				end
				if ((v97.MortalStrike:IsReady() and v39 and v13:BuffUp(v97.SweepingStrikes) and (v13:BuffStack(v97.CrushingAdvanceBuff) == (7 - 4))) or ((19545 - 15268) < (3763 - (431 + 343)))) then
					if (v23(v97.MortalStrike, not v101) or ((1757 - 887) >= (12002 - 7853))) then
						return "mortal_strike hac 81.5";
					end
				end
				if (((1748 + 464) < (408 + 2775)) and v97.Overpower:IsCastable() and v40 and v13:BuffUp(v97.SweepingStrikes) and v97.Dreadnaught:IsAvailable()) then
					if (((6341 - (556 + 1139)) > (3007 - (6 + 9))) and v23(v97.Overpower, not v101)) then
						return "overpower hac 82";
					end
				end
				v133 = 1 + 2;
			end
			if (((735 + 699) < (3275 - (28 + 141))) and (v133 == (2 + 1))) then
				if (((970 - 184) < (2142 + 881)) and v97.MortalStrike:IsReady() and v39) then
					if (v93.CastCycle(v97.MortalStrike, v104, v108, not v101) or ((3759 - (486 + 831)) < (192 - 118))) then
						return "mortal_strike hac 83";
					end
				end
				if (((15966 - 11431) == (857 + 3678)) and v97.Execute:IsReady() and v37 and (v13:BuffUp(v97.SuddenDeathBuff) or ((v105 <= (6 - 4)) and ((v14:HealthPercentage() < (1283 - (668 + 595))) or (v97.Massacre:IsAvailable() and (v14:HealthPercentage() < (32 + 3))))) or v13:BuffUp(v97.SweepingStrikes))) then
					if (v93.CastCycle(v97.Execute, v104, v109, not v101) or ((607 + 2402) <= (5740 - 3635))) then
						return "execute hac 84";
					end
				end
				if (((2120 - (23 + 267)) < (5613 - (1129 + 815))) and (v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable()) then
					if (v23(v97.ThunderousRoar, not v14:IsInMeleeRange(v26)) or ((1817 - (371 + 16)) >= (5362 - (1326 + 424)))) then
						return "thunderous_roar hac 85";
					end
				end
				if (((5080 - 2397) >= (8989 - 6529)) and v97.Shockwave:IsCastable() and v43 and (v105 > (120 - (88 + 30))) and (v97.SonicBoom:IsAvailable() or v14:IsCasting())) then
					if (v23(v97.Shockwave, not v14:IsInMeleeRange(v26)) or ((2575 - (720 + 51)) >= (7285 - 4010))) then
						return "shockwave hac 86";
					end
				end
				if ((v97.Overpower:IsCastable() and v40 and (v105 == (1777 - (421 + 1355))) and (((v97.Overpower:Charges() == (2 - 0)) and not v97.Battlelord:IsAvailable() and (v14:Debuffdown(v97.ColossusSmashDebuff) or (v13:RagePercentage() < (13 + 12)))) or v97.Battlelord:IsAvailable())) or ((2500 - (286 + 797)) > (13266 - 9637))) then
					if (((7941 - 3146) > (841 - (397 + 42))) and v23(v97.Overpower, not v101)) then
						return "overpower hac 87";
					end
				end
				if (((1504 + 3309) > (4365 - (24 + 776))) and v97.Slam:IsReady() and v45 and (v105 == (1 - 0)) and not v97.Battlelord:IsAvailable() and (v13:RagePercentage() > (855 - (222 + 563)))) then
					if (((8618 - 4706) == (2817 + 1095)) and v23(v97.Slam, not v101)) then
						return "slam hac 88";
					end
				end
				v133 = 194 - (23 + 167);
			end
			if (((4619 - (690 + 1108)) <= (1741 + 3083)) and (v133 == (5 + 0))) then
				if (((2586 - (40 + 808)) <= (362 + 1833)) and v97.IgnorePain:IsReady() and v65 and v97.Battlelord:IsAvailable() and v97.AngerManagement:IsAvailable() and (v13:Rage() > (114 - 84)) and ((v14:HealthPercentage() < (20 + 0)) or (v97.Massacre:IsAvailable() and (v14:HealthPercentage() < (19 + 16))))) then
					if (((23 + 18) <= (3589 - (47 + 524))) and v23(v97.IgnorePain, not v101)) then
						return "ignore_pain hac 95";
					end
				end
				if (((1393 + 752) <= (11218 - 7114)) and v97.Slam:IsReady() and v45 and v97.CrushingForce:IsAvailable() and (v13:Rage() > (44 - 14)) and ((v97.FervorofBattle:IsAvailable() and (v105 == (2 - 1))) or not v97.FervorofBattle:IsAvailable())) then
					if (((4415 - (1165 + 561)) < (144 + 4701)) and v23(v97.Slam, not v101)) then
						return "slam hac 96";
					end
				end
				if ((v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable())) or ((7191 - 4869) > (1001 + 1621))) then
					if (v23(v97.Shockwave, not v14:IsInMeleeRange(v26)) or ((5013 - (341 + 138)) == (563 + 1519))) then
						return "shockwave hac 97";
					end
				end
				if ((v30 and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable()) or ((3242 - 1671) > (2193 - (89 + 237)))) then
					if (v23(v97.Bladestorm, not v101) or ((8537 - 5883) >= (6307 - 3311))) then
						return "bladestorm hac 98";
					end
				end
				break;
			end
			if (((4859 - (581 + 300)) > (3324 - (855 + 365))) and (v133 == (0 - 0))) then
				if (((978 + 2017) > (2776 - (1030 + 205))) and v97.Execute:IsReady() and v37 and v13:BuffUp(v97.JuggernautBuff) and (v13:BuffRemains(v97.JuggernautBuff) < v13:GCD())) then
					if (((3051 + 198) > (887 + 66)) and v23(v97.Execute, not v101)) then
						return "execute hac 67";
					end
				end
				if ((v97.ThunderClap:IsReady() and v47 and (v105 > (288 - (156 + 130))) and v97.BloodandThunder:IsAvailable() and v97.Rend:IsAvailable() and v14:DebuffRefreshable(v97.RendDebuff)) or ((7436 - 4163) > (7707 - 3134))) then
					if (v23(v97.ThunderClap, not v101) or ((6453 - 3302) < (339 + 945))) then
						return "thunder_clap hac 68";
					end
				end
				if ((v97.SweepingStrikes:IsCastable() and v46 and (v105 >= (2 + 0)) and ((v97.Bladestorm:CooldownRemains() > (84 - (10 + 59))) or not v97.Bladestorm:IsAvailable())) or ((524 + 1326) == (7529 - 6000))) then
					if (((1984 - (671 + 492)) < (1691 + 432)) and v23(v97.SweepingStrikes, not v14:IsInMeleeRange(v26))) then
						return "sweeping_strikes hac 68";
					end
				end
				if (((2117 - (369 + 846)) < (616 + 1709)) and ((v97.Rend:IsReady() and v41 and (v105 == (1 + 0)) and ((v14:HealthPercentage() > (1965 - (1036 + 909))) or (v97.Massacre:IsAvailable() and (v14:HealthPercentage() < (28 + 7))))) or (v97.TideofBlood:IsAvailable() and (v97.Skullsplitter:CooldownRemains() <= v13:GCD()) and ((v97.ColossusSmash:CooldownRemains() < v13:GCD()) or v14:DebuffUp(v97.ColossusSmashDebuff)) and (v14:DebuffRemains(v97.RendDebuff) < ((34 - 13) * (203.85 - (11 + 192))))))) then
					if (((434 + 424) <= (3137 - (135 + 40))) and v23(v97.Rend, not v101)) then
						return "rend hac 70";
					end
				end
				if (((v90 < v103) and v31 and ((v52 and v30) or not v52) and v97.Avatar:IsCastable()) or ((9560 - 5614) < (777 + 511))) then
					if (v23(v97.Avatar, not v101) or ((7141 - 3899) == (849 - 282))) then
						return "avatar hac 71";
					end
				end
				if (((v90 < v103) and v97.Warbreaker:IsCastable() and v49 and ((v57 and v30) or not v57) and (v105 > (177 - (50 + 126)))) or ((2358 - 1511) >= (280 + 983))) then
					if (v23(v97.Warbreaker, not v101) or ((3666 - (1233 + 180)) == (2820 - (522 + 447)))) then
						return "warbreaker hac 72";
					end
				end
				v133 = 1422 - (107 + 1314);
			end
			if ((v133 == (2 + 2)) or ((6359 - 4272) > (1008 + 1364))) then
				if ((v97.Overpower:IsCastable() and v40 and (((v97.Overpower:Charges() == (3 - 1)) and (not v97.TestofMight:IsAvailable() or (v97.TestofMight:IsAvailable() and v14:DebuffUp(v97.ColossusSmashDebuff)) or v97.Battlelord:IsAvailable())) or (v13:Rage() < (276 - 206)))) or ((6355 - (716 + 1194)) < (71 + 4078))) then
					if (v23(v97.Overpower, not v101) or ((195 + 1623) == (588 - (74 + 429)))) then
						return "overpower hac 89";
					end
				end
				if (((1215 - 585) < (1055 + 1072)) and v97.ThunderClap:IsReady() and v47 and (v105 > (4 - 2))) then
					if (v23(v97.ThunderClap, not v101) or ((1372 + 566) == (7750 - 5236))) then
						return "thunder_clap hac 90";
					end
				end
				if (((10520 - 6265) >= (488 - (279 + 154))) and v97.MortalStrike:IsReady() and v39) then
					if (((3777 - (454 + 324)) > (910 + 246)) and v23(v97.MortalStrike, not v101)) then
						return "mortal_strike hac 91";
					end
				end
				if (((2367 - (12 + 5)) > (623 + 532)) and v97.Rend:IsReady() and v41 and (v105 == (2 - 1)) and v14:DebuffRefreshable(v97.RendDebuff)) then
					if (((1489 + 2540) <= (5946 - (277 + 816))) and v23(v97.Rend, not v101)) then
						return "rend hac 92";
					end
				end
				if ((v97.Whirlwind:IsReady() and v50 and (v97.StormofSwords:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 > (4 - 3))))) or ((1699 - (1058 + 125)) > (644 + 2790))) then
					if (((5021 - (815 + 160)) >= (13013 - 9980)) and v23(v97.Whirlwind, not v14:IsInMeleeRange(v26))) then
						return "whirlwind hac 93";
					end
				end
				if ((v97.Cleave:IsReady() and v35 and not v97.CrushingForce:IsAvailable()) or ((6454 - 3735) <= (346 + 1101))) then
					if (v23(v97.Cleave, not v101) or ((12084 - 7950) < (5824 - (41 + 1857)))) then
						return "cleave hac 94";
					end
				end
				v133 = 1898 - (1222 + 671);
			end
		end
	end
	local function v114()
		local v134 = 0 - 0;
		while true do
			if ((v134 == (1 - 0)) or ((1346 - (229 + 953)) >= (4559 - (1111 + 663)))) then
				if (((v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) or ((2104 - (874 + 705)) == (296 + 1813))) then
					if (((23 + 10) == (68 - 35)) and v23(v97.ColossusSmash, not v101)) then
						return "colossus_smash execute 55";
					end
				end
				if (((86 + 2968) <= (4694 - (642 + 37))) and v97.Execute:IsReady() and v37 and v13:BuffUp(v97.SuddenDeathBuff) and (v14:DebuffRemains(v97.DeepWoundsDebuff) > (0 + 0))) then
					if (((300 + 1571) < (8491 - 5109)) and v23(v97.Execute, not v101)) then
						return "execute execute 56";
					end
				end
				if (((1747 - (233 + 221)) <= (5008 - 2842)) and v97.Skullsplitter:IsCastable() and v44 and ((v97.TestofMight:IsAvailable() and (v13:RagePercentage() <= (27 + 3))) or (not v97.TestofMight:IsAvailable() and (v14:DebuffUp(v97.ColossusSmashDebuff) or (v97.ColossusSmash:CooldownRemains() > (1546 - (718 + 823)))) and (v13:RagePercentage() <= (19 + 11))))) then
					if (v23(v97.Skullsplitter, not v14:IsInMeleeRange(v26)) or ((3384 - (266 + 539)) < (347 - 224))) then
						return "skullsplitter execute 57";
					end
				end
				if (((v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable() and (v13:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v14:DebuffUp(v97.ColossusSmashDebuff)))) or ((2071 - (636 + 589)) >= (5620 - 3252))) then
					if (v23(v97.ThunderousRoar, not v14:IsInMeleeRange(v26)) or ((8274 - 4262) <= (2662 + 696))) then
						return "thunderous_roar execute 57";
					end
				end
				v134 = 1 + 1;
			end
			if (((2509 - (657 + 358)) <= (7956 - 4951)) and (v134 == (8 - 4))) then
				if (((v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable()) or ((4298 - (1151 + 36)) == (2061 + 73))) then
					if (((620 + 1735) == (7032 - 4677)) and v23(v97.Bladestorm, not v101)) then
						return "bladestorm execute 65";
					end
				end
				break;
			end
			if ((v134 == (1835 - (1552 + 280))) or ((1422 - (64 + 770)) <= (294 + 138))) then
				if (((10889 - 6092) >= (692 + 3203)) and v97.Overpower:IsCastable() and v40 and (v13:Rage() < (1283 - (157 + 1086))) and (v13:BuffStack(v97.MartialProwessBuff) < (3 - 1))) then
					if (((15666 - 12089) == (5486 - 1909)) and v23(v97.Overpower, not v101)) then
						return "overpower execute 60";
					end
				end
				if (((5178 - 1384) > (4512 - (599 + 220))) and v97.Execute:IsReady() and v37) then
					if (v23(v97.Execute, not v101) or ((2538 - 1263) == (6031 - (1813 + 118)))) then
						return "execute execute 62";
					end
				end
				if ((v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable() or v14:IsCasting())) or ((1163 + 428) >= (4797 - (841 + 376)))) then
					if (((1376 - 393) <= (421 + 1387)) and v23(v97.Shockwave, not v14:IsInMeleeRange(v26))) then
						return "shockwave execute 63";
					end
				end
				if ((v97.Overpower:IsCastable() and v40) or ((5868 - 3718) <= (2056 - (464 + 395)))) then
					if (((9672 - 5903) >= (564 + 609)) and v23(v97.Overpower, not v101)) then
						return "overpower execute 64";
					end
				end
				v134 = 841 - (467 + 370);
			end
			if (((3068 - 1583) == (1091 + 394)) and (v134 == (6 - 4))) then
				if (((v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "player") and v97.SpearofBastion:IsCastable() and (v14:DebuffUp(v97.ColossusSmashDebuff) or v13:BuffUp(v97.TestofMightBuff))) or ((518 + 2797) <= (6472 - 3690))) then
					if (v23(v99.SpearOfBastionPlayer, not v14:IsSpellInRange(v97.SpearofBastion)) or ((1396 - (150 + 370)) >= (4246 - (74 + 1208)))) then
						return "spear_of_bastion execute 57";
					end
				end
				if (((v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "cursor") and v97.SpearofBastion:IsCastable() and (v14:DebuffUp(v97.ColossusSmashDebuff) or v13:BuffUp(v97.TestofMightBuff))) or ((5489 - 3257) > (11842 - 9345))) then
					if (v23(v99.SpearOfBastionCursor, not v14:IsSpellInRange(v97.SpearofBastion)) or ((1502 + 608) <= (722 - (14 + 376)))) then
						return "spear_of_bastion execute 57";
					end
				end
				if (((6393 - 2707) > (2053 + 1119)) and v97.Cleave:IsReady() and v35 and (v105 > (2 + 0)) and (v14:DebuffRemains(v97.DeepWoundsDebuff) < v13:GCD())) then
					if (v23(v97.Cleave, not v101) or ((4267 + 207) < (2402 - 1582))) then
						return "cleave execute 58";
					end
				end
				if (((3220 + 1059) >= (2960 - (23 + 55))) and v97.MortalStrike:IsReady() and v39 and ((v14:DebuffStack(v97.ExecutionersPrecisionDebuff) == (4 - 2)) or (v14:DebuffRemains(v97.DeepWoundsDebuff) <= v13:GCD()))) then
					if (v23(v97.MortalStrike, not v101) or ((1354 + 675) >= (3162 + 359))) then
						return "mortal_strike execute 59";
					end
				end
				v134 = 4 - 1;
			end
			if ((v134 == (0 + 0)) or ((2938 - (652 + 249)) >= (12422 - 7780))) then
				if (((3588 - (708 + 1160)) < (12100 - 7642)) and (v90 < v103) and v46 and v97.SweepingStrikes:IsCastable() and (v105 > (1 - 0))) then
					if (v23(v97.SweepingStrikes, not v14:IsInMeleeRange(v26)) or ((463 - (10 + 17)) > (679 + 2342))) then
						return "sweeping_strikes execute 51";
					end
				end
				if (((2445 - (1400 + 332)) <= (1624 - 777)) and v97.Rend:IsReady() and v41 and (v14:DebuffRemains(v97.RendDebuff) <= v13:GCD()) and not v97.Bloodletting:IsAvailable() and ((not v97.Warbreaker:IsAvailable() and (v97.ColossusSmash:CooldownRemains() < (1912 - (242 + 1666)))) or (v97.Warbreaker:IsAvailable() and (v97.Warbreaker:CooldownRemains() < (2 + 2)))) and (v14:TimeToDie() > (5 + 7))) then
					if (((1836 + 318) <= (4971 - (850 + 90))) and v23(v97.Rend, not v101)) then
						return "rend execute 52";
					end
				end
				if (((8082 - 3467) == (6005 - (360 + 1030))) and (v90 < v103) and v31 and ((v52 and v30) or not v52) and v97.Avatar:IsCastable() and (v97.ColossusSmash:CooldownUp() or v14:DebuffUp(v97.ColossusSmashDebuff) or (v103 < (18 + 2)))) then
					if (v23(v97.Avatar, not v101) or ((10697 - 6907) == (687 - 187))) then
						return "avatar execute 53";
					end
				end
				if (((1750 - (909 + 752)) < (1444 - (109 + 1114))) and (v90 < v103) and v49 and ((v57 and v30) or not v57) and v97.Warbreaker:IsCastable()) then
					if (((3760 - 1706) >= (554 + 867)) and v23(v97.Warbreaker, not v101)) then
						return "warbreaker execute 54";
					end
				end
				v134 = 243 - (6 + 236);
			end
		end
	end
	local function v115()
		local v135 = 0 + 0;
		while true do
			if (((558 + 134) < (7211 - 4153)) and (v135 == (13 - 5))) then
				if ((v97.Cleave:IsReady() and v35 and v13:HasTier(1162 - (1076 + 57), 1 + 1) and not v97.CrushingForce:IsAvailable()) or ((3943 - (579 + 110)) == (131 + 1524))) then
					if (v23(v97.Cleave, not v101) or ((1146 + 150) == (2606 + 2304))) then
						return "cleave single_target 121";
					end
				end
				if (((3775 - (174 + 233)) == (9407 - 6039)) and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable()) then
					if (((4638 - 1995) < (1697 + 2118)) and v23(v97.Bladestorm, not v101)) then
						return "bladestorm single_target 122";
					end
				end
				if (((3087 - (663 + 511)) > (440 + 53)) and v97.Cleave:IsReady() and v35) then
					if (((1033 + 3722) > (10568 - 7140)) and v23(v97.Cleave, not v101)) then
						return "cleave single_target 123";
					end
				end
				v135 = 6 + 3;
			end
			if (((3251 - 1870) <= (5734 - 3365)) and (v135 == (3 + 3))) then
				if ((v97.Slam:IsReady() and v45 and ((v97.CrushingForce:IsAvailable() and v14:DebuffUp(v97.ColossusSmashDebuff) and (v13:Rage() >= (116 - 56)) and v97.TestofMight:IsAvailable()) or v97.ImprovedSlam:IsAvailable()) and (not v97.FervorofBattle:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 == (1 + 0))))) or ((443 + 4400) == (4806 - (478 + 244)))) then
					if (((5186 - (440 + 77)) > (166 + 197)) and v23(v97.Slam, not v101)) then
						return "slam single_target 115";
					end
				end
				if ((v97.Whirlwind:IsReady() and v50 and (v97.StormofSwords:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 > (3 - 2))))) or ((3433 - (655 + 901)) >= (582 + 2556))) then
					if (((3631 + 1111) >= (2449 + 1177)) and v23(v97.Whirlwind, not v14:IsInMeleeRange(v26))) then
						return "whirlwind single_target 116";
					end
				end
				if ((v97.Slam:IsReady() and v45 and (v97.CrushingForce:IsAvailable() or (not v97.CrushingForce:IsAvailable() and (v13:Rage() >= (120 - 90)))) and (not v97.FervorofBattle:IsAvailable() or (v97.FervorofBattle:IsAvailable() and (v105 == (1446 - (695 + 750)))))) or ((15502 - 10962) == (1412 - 496))) then
					if (v23(v97.Slam, not v101) or ((4649 - 3493) > (4696 - (285 + 66)))) then
						return "slam single_target 117";
					end
				end
				v135 = 15 - 8;
			end
			if (((3547 - (682 + 628)) < (685 + 3564)) and (v135 == (308 - (176 + 123)))) then
				if ((v97.Rend:IsReady() and v41 and v14:DebuffRefreshable(v97.RendDebuff) and not v97.CrushingForce:IsAvailable()) or ((1123 + 1560) < (17 + 6))) then
					if (((966 - (239 + 30)) <= (225 + 601)) and v23(v97.Rend, not v101)) then
						return "rend single_target 124";
					end
				end
				break;
			end
			if (((1063 + 42) <= (2080 - 904)) and (v135 == (2 - 1))) then
				if (((3694 - (306 + 9)) <= (13302 - 9490)) and v97.Rend:IsReady() and v41 and ((v14:DebuffRemains(v97.RendDebuff) <= v13:GCD()) or (v97.TideofBlood:IsAvailable() and (v97.Skullsplitter:CooldownRemains() <= v13:GCD()) and ((v97.ColossusSmash:CooldownRemains() <= v13:GCD()) or v14:DebuffUp(v97.ColossusSmashDebuff)) and (v14:DebuffRemains(v97.RendDebuff) < (v97.RendDebuff:BaseDuration() * (0.85 + 0)))))) then
					if (v23(v97.Rend, not v101) or ((484 + 304) >= (778 + 838))) then
						return "rend single_target 100";
					end
				end
				if (((5301 - 3447) <= (4754 - (1140 + 235))) and (v90 < v103) and v31 and ((v52 and v30) or not v52) and v97.Avatar:IsCastable() and ((v97.WarlordsTorment:IsAvailable() and (v13:RagePercentage() < (22 + 11)) and (v97.ColossusSmash:CooldownUp() or v14:DebuffUp(v97.ColossusSmashDebuff) or v13:BuffUp(v97.TestofMightBuff))) or (not v97.WarlordsTorment:IsAvailable() and (v97.ColossusSmash:CooldownUp() or v14:DebuffUp(v97.ColossusSmashDebuff))))) then
					if (((4172 + 377) == (1168 + 3381)) and v23(v97.Avatar, not v101)) then
						return "avatar single_target 101";
					end
				end
				if (((v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "player") and v97.SpearofBastion:IsCastable() and ((v97.ColossusSmash:CooldownRemains() <= v13:GCD()) or (v97.Warbreaker:CooldownRemains() <= v13:GCD()))) or ((3074 - (33 + 19)) >= (1092 + 1932))) then
					if (((14446 - 9626) > (969 + 1229)) and v23(v99.SpearOfBastionPlayer, not v14:IsSpellInRange(v97.SpearofBastion))) then
						return "spear_of_bastion single_target 102";
					end
				end
				v135 = 3 - 1;
			end
			if ((v135 == (7 + 0)) or ((1750 - (586 + 103)) >= (446 + 4445))) then
				if (((4199 - 2835) <= (5961 - (1309 + 179))) and v97.ThunderClap:IsReady() and v47 and v97.Battlelord:IsAvailable() and v97.BloodandThunder:IsAvailable()) then
					if (v23(v97.ThunderClap, not v101) or ((6490 - 2895) <= (2 + 1))) then
						return "thunder_clap single_target 118";
					end
				end
				if ((v97.Overpower:IsCastable() and v40 and ((v14:DebuffDown(v97.ColossusSmashDebuff) and (v13:RagePercentage() < (134 - 84)) and not v97.Battlelord:IsAvailable()) or (v13:RagePercentage() < (19 + 6)))) or ((9926 - 5254) == (7675 - 3823))) then
					if (((2168 - (295 + 314)) == (3828 - 2269)) and v23(v97.Overpower, not v101)) then
						return "overpower single_target 119";
					end
				end
				if ((v97.Whirlwind:IsReady() and v50 and v13:BuffUp(v97.MercilessBonegrinderBuff)) or ((3714 - (1300 + 662)) <= (2474 - 1686))) then
					if (v23(v97.Whirlwind, not v14:IsInRange(1763 - (1178 + 577))) or ((2030 + 1877) == (523 - 346))) then
						return "whirlwind single_target 120";
					end
				end
				v135 = 1413 - (851 + 554);
			end
			if (((3069 + 401) > (1539 - 984)) and (v135 == (0 - 0))) then
				if (((v90 < v103) and v46 and v97.SweepingStrikes:IsCastable() and (v105 > (303 - (115 + 187)))) or ((745 + 227) == (611 + 34))) then
					if (((12539 - 9357) >= (3276 - (160 + 1001))) and v23(v97.SweepingStrikes, not v14:IsInMeleeRange(v26))) then
						return "sweeping_strikes single_target 97";
					end
				end
				if (((3406 + 487) < (3056 + 1373)) and v97.Execute:IsReady() and (v13:BuffUp(v97.SuddenDeathBuff))) then
					if (v23(v97.Execute, not v101) or ((5868 - 3001) < (2263 - (237 + 121)))) then
						return "execute single_target 98";
					end
				end
				if ((v97.MortalStrike:IsReady() and v39) or ((2693 - (525 + 372)) >= (7680 - 3629))) then
					if (((5319 - 3700) <= (3898 - (96 + 46))) and v23(v97.MortalStrike, not v101)) then
						return "mortal_strike single_target 99";
					end
				end
				v135 = 778 - (643 + 134);
			end
			if (((219 + 385) == (1448 - 844)) and (v135 == (18 - 13))) then
				if ((v97.Shockwave:IsCastable() and v43 and (v97.SonicBoom:IsAvailable() or v14:IsCasting())) or ((4301 + 183) == (1766 - 866))) then
					if (v23(v97.Shockwave, not v14:IsInMeleeRange(v26)) or ((9114 - 4655) <= (1832 - (316 + 403)))) then
						return "shockwave single_target 111";
					end
				end
				if (((2415 + 1217) > (9342 - 5944)) and v97.Whirlwind:IsReady() and v50 and v97.StormofSwords:IsAvailable() and v97.TestofMight:IsAvailable() and (v97.ColossusSmash:CooldownRemains() > (v13:GCD() * (3 + 4)))) then
					if (((10279 - 6197) <= (3485 + 1432)) and v23(v97.Whirlwind, not v14:IsInMeleeRange(v26))) then
						return "whirlwind single_target 113";
					end
				end
				if (((1558 + 3274) >= (4802 - 3416)) and v97.Overpower:IsCastable() and v40 and (((v97.Overpower:Charges() == (9 - 7)) and not v97.Battlelord:IsAvailable() and (v14:DebuffUp(v97.ColossusSmashDebuff) or (v13:RagePercentage() < (51 - 26)))) or v97.Battlelord:IsAvailable())) then
					if (((8 + 129) == (269 - 132)) and v23(v97.Overpower, not v101)) then
						return "overpower single_target 114";
					end
				end
				v135 = 1 + 5;
			end
			if ((v135 == (11 - 7)) or ((1587 - (12 + 5)) >= (16825 - 12493))) then
				if ((v97.Whirlwind:IsReady() and v50 and v97.StormofSwords:IsAvailable() and v97.TestofMight:IsAvailable() and (v13:RagePercentage() > (170 - 90)) and v14:DebuffUp(v97.ColossusSmashDebuff)) or ((8638 - 4574) <= (4510 - 2691))) then
					if (v23(v97.Whirlwind, not v14:IsInMeleeRange(v26)) or ((1012 + 3974) < (3547 - (1656 + 317)))) then
						return "whirlwind single_target 108";
					end
				end
				if (((3944 + 482) > (138 + 34)) and v97.ThunderClap:IsReady() and v47 and (v14:DebuffRemains(v97.RendDebuff) <= v13:GCD()) and not v97.TideofBlood:IsAvailable()) then
					if (((1557 - 971) > (2239 - 1784)) and v23(v97.ThunderClap, not v101)) then
						return "thunder_clap single_target 109";
					end
				end
				if (((1180 - (5 + 349)) == (3923 - 3097)) and (v90 < v103) and v33 and ((v53 and v30) or not v53) and v97.Bladestorm:IsCastable() and ((v97.Hurricane:IsAvailable() and (v13:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v14:DebuffUp(v97.ColossusSmashDebuff)))) or (v97.Unhinged:IsAvailable() and (v13:BuffUp(v97.TestofMightBuff) or (not v97.TestofMight:IsAvailable() and v14:DebuffUp(v97.ColossusSmashDebuff)))))) then
					if (v23(v97.Bladestorm, not v101) or ((5290 - (266 + 1005)) > (2927 + 1514))) then
						return "bladestorm single_target 110";
					end
				end
				v135 = 16 - 11;
			end
			if (((2655 - 638) < (5957 - (561 + 1135))) and (v135 == (2 - 0))) then
				if (((15501 - 10785) > (1146 - (507 + 559))) and (v90 < v103) and v83 and ((v55 and v30) or not v55) and (v84 == "cursor") and v97.SpearofBastion:IsCastable() and ((v97.ColossusSmash:CooldownRemains() <= v13:GCD()) or (v97.Warbreaker:CooldownRemains() <= v13:GCD()))) then
					if (v23(v99.SpearOfBastionCursor, not v14:IsSpellInRange(v97.SpearofBastion)) or ((8799 - 5292) == (10119 - 6847))) then
						return "spear_of_bastion single_target 102";
					end
				end
				if (((v90 < v103) and v49 and ((v57 and v30) or not v57) and v97.Warbreaker:IsCastable()) or ((1264 - (212 + 176)) >= (3980 - (250 + 655)))) then
					if (((11867 - 7515) > (4462 - 1908)) and v23(v97.Warbreaker, not v14:IsInRange(12 - 4))) then
						return "warbreaker single_target 103";
					end
				end
				if (((v90 < v103) and v36 and ((v54 and v30) or not v54) and v97.ColossusSmash:IsCastable()) or ((6362 - (1869 + 87)) < (14022 - 9979))) then
					if (v23(v97.ColossusSmash, not v101) or ((3790 - (484 + 1417)) >= (7250 - 3867))) then
						return "colossus_smash single_target 104";
					end
				end
				v135 = 4 - 1;
			end
			if (((2665 - (48 + 725)) <= (4465 - 1731)) and (v135 == (7 - 4))) then
				if (((1118 + 805) < (5927 - 3709)) and v97.Skullsplitter:IsCastable() and v44 and not v97.TestofMight:IsAvailable() and (v14:DebuffRemains(v97.DeepWoundsDebuff) > (0 + 0)) and (v14:DebuffUp(v97.ColossusSmashDebuff) or (v97.ColossusSmash:CooldownRemains() > (1 + 2)))) then
					if (((3026 - (152 + 701)) > (1690 - (430 + 881))) and v23(v97.Skullsplitter, not v101)) then
						return "skullsplitter single_target 105";
					end
				end
				if ((v97.Skullsplitter:IsCastable() and v44 and v97.TestofMight:IsAvailable() and (v14:DebuffRemains(v97.DeepWoundsDebuff) > (0 + 0))) or ((3486 - (557 + 338)) == (1008 + 2401))) then
					if (((12720 - 8206) > (11639 - 8315)) and v23(v97.Skullsplitter, not v101)) then
						return "skullsplitter single_target 106";
					end
				end
				if (((v90 < v103) and v48 and ((v56 and v30) or not v56) and v97.ThunderousRoar:IsCastable() and (v13:BuffUp(v97.TestofMightBuff) or (v97.TestofMight:IsAvailable() and v14:DebuffUp(v97.ColossusSmashDebuff) and (v13:RagePercentage() < (87 - 54))) or (not v97.TestofMight:IsAvailable() and v14:DebuffUp(v97.ColossusSmashDebuff)))) or ((448 - 240) >= (5629 - (499 + 302)))) then
					if (v23(v97.ThunderousRoar, not v14:IsInMeleeRange(v26)) or ((2449 - (39 + 827)) > (9846 - 6279))) then
						return "thunderous_roar single_target 107";
					end
				end
				v135 = 8 - 4;
			end
		end
	end
	local function v116()
		if (not v13:AffectingCombat() or ((5215 - 3902) == (1218 - 424))) then
			local v167 = 0 + 0;
			while true do
				if (((9289 - 6115) > (465 + 2437)) and (v167 == (0 - 0))) then
					if (((4224 - (103 + 1)) <= (4814 - (475 + 79))) and v97.BattleStance:IsCastable() and v13:BuffDown(v97.BattleStance, true)) then
						if (v23(v97.BattleStance) or ((1908 - 1025) > (15289 - 10511))) then
							return "battle_stance";
						end
					end
					if ((v97.BattleShout:IsCastable() and v32 and (v13:BuffDown(v97.BattleShoutBuff, true) or v93.GroupBuffMissing(v97.BattleShoutBuff))) or ((468 + 3152) >= (4305 + 586))) then
						if (((5761 - (1395 + 108)) > (2726 - 1789)) and v23(v97.BattleShout)) then
							return "battle_shout precombat";
						end
					end
					break;
				end
			end
		end
		if ((v93.TargetIsValid() and v28) or ((6073 - (7 + 1197)) < (396 + 510))) then
			if (not v13:AffectingCombat() or ((428 + 797) > (4547 - (27 + 292)))) then
				local v191 = 0 - 0;
				while true do
					if (((4243 - 915) > (9385 - 7147)) and (v191 == (0 - 0))) then
						v27 = v112();
						if (((7310 - 3471) > (1544 - (43 + 96))) and v27) then
							return v27;
						end
						break;
					end
				end
			end
		end
	end
	local function v117()
		local v136 = 0 - 0;
		while true do
			if ((v136 == (1 - 0)) or ((1073 + 220) <= (144 + 363))) then
				if (v85 or ((5723 - 2827) < (309 + 496))) then
					v27 = v93.HandleIncorporeal(v97.StormBolt, v99.StormBoltMouseover, 37 - 17, true);
					if (((730 + 1586) == (170 + 2146)) and v27) then
						return v27;
					end
					v27 = v93.HandleIncorporeal(v97.IntimidatingShout, v99.IntimidatingShoutMouseover, 1759 - (1414 + 337), true);
					if (v27 or ((4510 - (1642 + 298)) == (3995 - 2462))) then
						return v27;
					end
				end
				if (v93.TargetIsValid() or ((2539 - 1656) == (4332 - 2872))) then
					if ((v34 and v97.Charge:IsCastable() and not v101) or ((1521 + 3098) <= (778 + 221))) then
						if (v23(v97.Charge, not v14:IsSpellInRange(v97.Charge)) or ((4382 - (357 + 615)) > (2890 + 1226))) then
							return "charge main 34";
						end
					end
					local v194 = v93.HandleDPSPotion(v14:DebuffUp(v97.ColossusSmashDebuff));
					if (v194 or ((2215 - 1312) >= (2622 + 437))) then
						return v194;
					end
					if ((v101 and v91 and ((v59 and v30) or not v59) and (v90 < v103)) or ((8520 - 4544) < (2286 + 571))) then
						local v196 = 0 + 0;
						while true do
							if (((3099 + 1831) > (3608 - (384 + 917))) and (v196 == (697 - (128 + 569)))) then
								if ((v97.BloodFury:IsCastable() and v14:DebuffUp(v97.ColossusSmashDebuff)) or ((5589 - (1407 + 136)) < (3178 - (687 + 1200)))) then
									if (v23(v97.BloodFury) or ((5951 - (556 + 1154)) == (12471 - 8926))) then
										return "blood_fury main 39";
									end
								end
								if ((v97.Berserking:IsCastable() and (v14:DebuffRemains(v97.ColossusSmashDebuff) > (101 - (9 + 86)))) or ((4469 - (275 + 146)) > (689 + 3543))) then
									if (v23(v97.Berserking) or ((1814 - (29 + 35)) >= (15392 - 11919))) then
										return "berserking main 40";
									end
								end
								v196 = 2 - 1;
							end
							if (((13976 - 10810) == (2063 + 1103)) and (v196 == (1014 - (53 + 959)))) then
								if (((2171 - (312 + 96)) < (6462 - 2738)) and v97.Fireblood:IsCastable() and (v14:DebuffUp(v97.ColossusSmashDebuff))) then
									if (((342 - (147 + 138)) <= (3622 - (813 + 86))) and v23(v97.Fireblood)) then
										return "fireblood main 43";
									end
								end
								if ((v97.AncestralCall:IsCastable() and (v14:DebuffUp(v97.ColossusSmashDebuff))) or ((1871 + 199) == (820 - 377))) then
									if (v23(v97.AncestralCall) or ((3197 - (18 + 474)) == (470 + 923))) then
										return "ancestral_call main 44";
									end
								end
								v196 = 9 - 6;
							end
							if ((v196 == (1089 - (860 + 226))) or ((4904 - (121 + 182)) < (8 + 53))) then
								if ((v97.BagofTricks:IsCastable() and v14:DebuffDown(v97.ColossusSmashDebuff) and not v97.MortalStrike:CooldownUp()) or ((2630 - (988 + 252)) >= (536 + 4208))) then
									if (v23(v97.BagofTricks, not v14:IsSpellInRange(v97.BagofTricks)) or ((628 + 1375) > (5804 - (49 + 1921)))) then
										return "bag_of_tricks main 10";
									end
								end
								break;
							end
							if ((v196 == (891 - (223 + 667))) or ((208 - (51 + 1)) > (6734 - 2821))) then
								if (((417 - 222) == (1320 - (146 + 979))) and v97.ArcaneTorrent:IsCastable() and (v97.MortalStrike:CooldownRemains() > (1.5 + 0)) and (v13:Rage() < (655 - (311 + 294)))) then
									if (((8658 - 5553) >= (761 + 1035)) and v23(v97.ArcaneTorrent, not v14:IsInRange(1451 - (496 + 947)))) then
										return "arcane_torrent main 41";
									end
								end
								if (((5737 - (1233 + 125)) >= (865 + 1266)) and v97.LightsJudgment:IsCastable() and v14:DebuffDown(v97.ColossusSmashDebuff) and not v97.MortalStrike:CooldownUp()) then
									if (((3449 + 395) >= (389 + 1654)) and v23(v97.LightsJudgment, not v14:IsSpellInRange(v97.LightsJudgment))) then
										return "lights_judgment main 42";
									end
								end
								v196 = 1647 - (963 + 682);
							end
						end
					end
					if ((v90 < v103) or ((2698 + 534) <= (4235 - (504 + 1000)))) then
						if (((3304 + 1601) == (4467 + 438)) and v92 and ((v30 and v58) or not v58)) then
							local v200 = 0 + 0;
							while true do
								if ((v200 == (0 - 0)) or ((3534 + 602) >= (2566 + 1845))) then
									v27 = v111();
									if (v27 or ((3140 - (156 + 26)) == (2315 + 1702))) then
										return v27;
									end
									break;
								end
							end
						end
					end
					if (((1920 - 692) >= (977 - (149 + 15))) and v38 and v97.HeroicThrow:IsCastable() and not v14:IsInRange(990 - (890 + 70))) then
						if (v23(v97.HeroicThrow, not v14:IsInRange(147 - (39 + 78))) or ((3937 - (14 + 468)) > (8906 - 4856))) then
							return "heroic_throw main";
						end
					end
					if (((679 - 436) == (126 + 117)) and v97.WreckingThrow:IsCastable() and v51 and v14:AffectingCombat() and v106()) then
						if (v23(v97.WreckingThrow, not v14:IsInRange(19 + 11)) or ((58 + 213) > (710 + 862))) then
							return "wrecking_throw main";
						end
					end
					if (((718 + 2021) < (6302 - 3009)) and v29 and (v105 > (2 + 0))) then
						local v197 = 0 - 0;
						while true do
							if ((v197 == (0 + 0)) or ((3993 - (12 + 39)) < (1056 + 78))) then
								v27 = v113();
								if (v27 or ((8335 - 5642) == (17711 - 12738))) then
									return v27;
								end
								break;
							end
						end
					end
					if (((637 + 1509) == (1130 + 1016)) and ((v97.Massacre:IsAvailable() and (v14:HealthPercentage() < (88 - 53))) or (v14:HealthPercentage() < (14 + 6)))) then
						v27 = v114();
						if (v27 or ((10844 - 8600) == (4934 - (1596 + 114)))) then
							return v27;
						end
					end
					v27 = v115();
					if (v27 or ((12803 - 7899) <= (2629 - (164 + 549)))) then
						return v27;
					end
					if (((1528 - (1059 + 379)) <= (1322 - 257)) and v19.CastAnnotated(v97.Pool, false, "WAIT")) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if (((2489 + 2313) == (810 + 3992)) and (v136 == (392 - (145 + 247)))) then
				v27 = v110();
				if (v27 or ((1871 + 409) <= (237 + 274))) then
					return v27;
				end
				v136 = 2 - 1;
			end
		end
	end
	local function v118()
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
		v83 = EpicSettings.Settings['useSpearOfBastion'];
		v48 = EpicSettings.Settings['useThunderousRoar'];
		v49 = EpicSettings.Settings['useWarbreaker'];
		v52 = EpicSettings.Settings['avatarWithCD'];
		v53 = EpicSettings.Settings['bladestormWithCD'];
		v54 = EpicSettings.Settings['colossusSmashWithCD'];
		v55 = EpicSettings.Settings['spearOfBastionWithCD'];
		v56 = EpicSettings.Settings['thunderousRoarWithCD'];
		v57 = EpicSettings.Settings['warbreakerWithCD'];
	end
	local function v119()
		local v164 = 0 + 0;
		while true do
			if ((v164 == (3 + 0)) or ((2720 - 1044) <= (1183 - (254 + 466)))) then
				v71 = EpicSettings.Settings['useVictoryRush'];
				v72 = EpicSettings.Settings['bitterImmunityHP'] or (560 - (544 + 16));
				v78 = EpicSettings.Settings['defensiveStanceHP'] or (0 - 0);
				v164 = 632 - (294 + 334);
			end
			if (((4122 - (236 + 17)) == (1668 + 2201)) and (v164 == (1 + 0))) then
				v63 = EpicSettings.Settings['useBitterImmunity'];
				v68 = EpicSettings.Settings['useDefensiveStance'];
				v64 = EpicSettings.Settings['useDieByTheSword'];
				v164 = 7 - 5;
			end
			if (((5482 - 4324) <= (1346 + 1267)) and (v164 == (4 + 0))) then
				v81 = EpicSettings.Settings['unstanceHP'] or (794 - (413 + 381));
				v73 = EpicSettings.Settings['dieByTheSwordHP'] or (0 + 0);
				v74 = EpicSettings.Settings['ignorePainHP'] or (0 - 0);
				v164 = 12 - 7;
			end
			if ((v164 == (1976 - (582 + 1388))) or ((4027 - 1663) <= (1431 + 568))) then
				v82 = EpicSettings.Settings['victoryRushHP'] or (364 - (326 + 38));
				v84 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
			if (((5 - 3) == v164) or ((7026 - 2104) < (814 - (47 + 573)))) then
				v65 = EpicSettings.Settings['useIgnorePain'];
				v67 = EpicSettings.Settings['useIntervene'];
				v66 = EpicSettings.Settings['useRallyingCry'];
				v164 = 2 + 1;
			end
			if ((v164 == (21 - 16)) or ((3393 - 1302) < (1695 - (1269 + 395)))) then
				v77 = EpicSettings.Settings['interveneHP'] or (492 - (76 + 416));
				v76 = EpicSettings.Settings['rallyingCryGroup'] or (443 - (319 + 124));
				v75 = EpicSettings.Settings['rallyingCryHP'] or (0 - 0);
				v164 = 1013 - (564 + 443);
			end
			if ((v164 == (0 - 0)) or ((2888 - (337 + 121)) >= (14275 - 9403))) then
				v60 = EpicSettings.Settings['usePummel'];
				v61 = EpicSettings.Settings['useStormBolt'];
				v62 = EpicSettings.Settings['useIntimidatingShout'];
				v164 = 3 - 2;
			end
		end
	end
	local function v120()
		local v165 = 1911 - (1261 + 650);
		while true do
			if ((v165 == (2 + 2)) or ((7602 - 2832) < (3552 - (772 + 1045)))) then
				v86 = EpicSettings.Settings['HealingPotionName'] or "";
				v85 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v165 == (1 + 0)) or ((4583 - (102 + 42)) <= (4194 - (1524 + 320)))) then
				v89 = EpicSettings.Settings['InterruptThreshold'];
				v92 = EpicSettings.Settings['useTrinkets'];
				v91 = EpicSettings.Settings['useRacials'];
				v165 = 1272 - (1049 + 221);
			end
			if (((156 - (18 + 138)) == v165) or ((10963 - 6484) < (5568 - (67 + 1035)))) then
				v90 = EpicSettings.Settings['fightRemainsCheck'] or (348 - (136 + 212));
				v87 = EpicSettings.Settings['InterruptWithStun'];
				v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v165 = 4 - 3;
			end
			if (((2041 + 506) > (1130 + 95)) and (v165 == (1607 - (240 + 1364)))) then
				v70 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (1082 - (1050 + 32));
				v80 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v165 = 3 + 1;
			end
			if (((5726 - (331 + 724)) > (216 + 2458)) and (v165 == (646 - (269 + 375)))) then
				v58 = EpicSettings.Settings['trinketsWithCD'];
				v59 = EpicSettings.Settings['racialsWithCD'];
				v69 = EpicSettings.Settings['useHealthstone'];
				v165 = 728 - (267 + 458);
			end
		end
	end
	local function v121()
		local v166 = 0 + 0;
		while true do
			if ((v166 == (5 - 2)) or ((4514 - (667 + 151)) < (4824 - (1410 + 87)))) then
				v101 = v14:IsInMeleeRange(v26);
				if (v93.TargetIsValid() or v13:AffectingCombat() or ((6439 - (1504 + 393)) == (8028 - 5058))) then
					local v195 = 0 - 0;
					while true do
						if (((1048 - (461 + 335)) <= (253 + 1724)) and (v195 == (1762 - (1730 + 31)))) then
							if ((v103 == (12778 - (728 + 939))) or ((5085 - 3649) == (7656 - 3881))) then
								v103 = v9.FightRemains(v104, false);
							end
							break;
						end
						if ((v195 == (0 - 0)) or ((2686 - (138 + 930)) < (850 + 80))) then
							v102 = v9.BossFightRemains(nil, true);
							v103 = v102;
							v195 = 1 + 0;
						end
					end
				end
				if (((4048 + 675) > (16957 - 12804)) and not v13:IsChanneling()) then
					if (v13:AffectingCombat() or ((5420 - (459 + 1307)) >= (6524 - (474 + 1396)))) then
						local v198 = 0 - 0;
						while true do
							if (((892 + 59) <= (5 + 1491)) and (v198 == (0 - 0))) then
								v27 = v117();
								if (v27 or ((220 + 1516) == (1906 - 1335))) then
									return v27;
								end
								break;
							end
						end
					else
						local v199 = 0 - 0;
						while true do
							if (((591 - (562 + 29)) == v199) or ((764 + 132) > (6188 - (374 + 1045)))) then
								v27 = v116();
								if (v27 or ((828 + 217) <= (3167 - 2147))) then
									return v27;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v166 == (639 - (448 + 190))) or ((375 + 785) <= (149 + 179))) then
				v28 = EpicSettings.Toggles['ooc'];
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				v166 = 2 + 0;
			end
			if (((14640 - 10832) > (9085 - 6161)) and ((1496 - (1307 + 187)) == v166)) then
				if (((15429 - 11538) < (11516 - 6597)) and v13:IsDeadOrGhost()) then
					return;
				end
				if (v97.IntimidatingShout:IsAvailable() or ((6849 - 4615) <= (2185 - (232 + 451)))) then
					v26 = 8 + 0;
				end
				if (v29 or ((2220 + 292) < (996 - (510 + 54)))) then
					v104 = v13:GetEnemiesInMeleeRange(v26);
					v105 = #v104;
				else
					v105 = 1 - 0;
				end
				v166 = 39 - (13 + 23);
			end
			if ((v166 == (0 - 0)) or ((2655 - 807) == (1571 - 706))) then
				v119();
				v118();
				v120();
				v166 = 1089 - (830 + 258);
			end
		end
	end
	local function v122()
		v19.Print("Arms Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(250 - 179, v121, v122);
end;
return v0["Epix_Warrior_Arms.lua"]();

