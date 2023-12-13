local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((17422 - 12716) > (2909 + 1520)) and not v5) then
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
	local v92 = v9.Commons.Everyone;
	local v93 = v13:GetEquipment();
	local v94 = (v93[13 + 0] and v18(v93[8 + 5])) or v18(0 - 0);
	local v95 = (v93[31 - 17] and v18(v93[32 - 18])) or v18(711 - (530 + 181));
	local v96 = v17.Warrior.Arms;
	local v97 = v18.Warrior.Arms;
	local v98 = v22.Warrior.Arms;
	local v99 = {};
	local v100;
	local v101 = 11992 - (614 + 267);
	local v102 = 11143 - (19 + 13);
	v9:RegisterForEvent(function()
		local v122 = 0 - 0;
		while true do
			if (((6650 - 3796) < (11697 - 7602)) and (v122 == (0 + 0))) then
				v101 = 19540 - 8429;
				v102 = 23042 - 11931;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v93 = v13:GetEquipment();
		v94 = (v93[1825 - (1293 + 519)] and v18(v93[26 - 13])) or v18(0 - 0);
		v95 = (v93[26 - 12] and v18(v93[60 - 46])) or v18(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v103;
	local v104;
	local function v105()
		local v123 = UnitGetTotalAbsorbs(v14);
		if ((v123 > (0 + 0)) or ((216 + 842) >= (2792 - 1590))) then
			return true;
		else
			return false;
		end
	end
	local function v106(v124)
		return (v124:HealthPercentage() > (5 + 15)) or (v96.Massacre:IsAvailable() and (v124:HealthPercentage() < (12 + 23)));
	end
	local function v107(v125)
		return (v125:DebuffStack(v96.ExecutionersPrecisionDebuff) == (2 + 0)) or (v125:DebuffRemains(v96.DeepWoundsDebuff) <= v13:GCD()) or (v96.Dreadnaught:IsAvailable() and v96.Battlelord:IsAvailable() and (v104 <= (1098 - (709 + 387))));
	end
	local function v108(v126)
		return v13:BuffUp(v96.SuddenDeathBuff) or ((v104 <= (1860 - (673 + 1185))) and ((v126:HealthPercentage() < (58 - 38)) or (v96.Massacre:IsAvailable() and (v126:HealthPercentage() < (112 - 77))))) or v13:BuffUp(v96.SweepingStrikes);
	end
	local function v109()
		local v127 = 0 - 0;
		while true do
			if (((2655 + 1056) > (2507 + 848)) and (v127 == (2 - 0))) then
				if ((v96.Intervene:IsCastable() and v66 and (v16:HealthPercentage() <= v76) and (v16:UnitName() ~= v13:UnitName())) or ((223 + 683) >= (4444 - 2215))) then
					if (((2528 - 1240) > (3131 - (446 + 1434))) and v23(v98.InterveneFocus)) then
						return "intervene defensive";
					end
				end
				if ((v96.DefensiveStance:IsCastable() and v13:BuffDown(v96.DefensiveStance, true) and v67 and (v13:HealthPercentage() <= v77)) or ((5796 - (1040 + 243)) < (10004 - 6652))) then
					if (v23(v96.DefensiveStance) or ((3912 - (559 + 1288)) >= (5127 - (609 + 1322)))) then
						return "defensive_stance defensive";
					end
				end
				v127 = 457 - (13 + 441);
			end
			if ((v127 == (3 - 2)) or ((11462 - 7086) <= (7376 - 5895))) then
				if ((v96.IgnorePain:IsCastable() and v64 and (v13:HealthPercentage() <= v73)) or ((127 + 3265) >= (17218 - 12477))) then
					if (((1181 + 2144) >= (944 + 1210)) and v23(v96.IgnorePain, nil, nil, true)) then
						return "ignore_pain defensive";
					end
				end
				if ((v96.RallyingCry:IsCastable() and v65 and v13:BuffDown(v96.AspectsFavorBuff) and v13:BuffDown(v96.RallyingCry) and (((v13:HealthPercentage() <= v74) and v92.IsSoloMode()) or v92.AreUnitsBelowHealthPercentage(v74, v75))) or ((3842 - 2547) >= (1770 + 1463))) then
					if (((8050 - 3673) > (1086 + 556)) and v23(v96.RallyingCry)) then
						return "rallying_cry defensive";
					end
				end
				v127 = 2 + 0;
			end
			if (((3394 + 1329) > (1139 + 217)) and (v127 == (4 + 0))) then
				if ((v69 and (v13:HealthPercentage() <= v79)) or ((4569 - (153 + 280)) <= (9913 - 6480))) then
					local v189 = 0 + 0;
					while true do
						if (((1677 + 2568) <= (2424 + 2207)) and (v189 == (0 + 0))) then
							if (((3099 + 1177) >= (5959 - 2045)) and (v85 == "Refreshing Healing Potion")) then
								if (((123 + 75) <= (5032 - (89 + 578))) and v97.RefreshingHealingPotion:IsReady()) then
									if (((3417 + 1365) > (9720 - 5044)) and v23(v98.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((5913 - (572 + 477)) > (297 + 1900)) and (v85 == "Dreamwalker's Healing Potion")) then
								if (v97.DreamwalkersHealingPotion:IsReady() or ((2221 + 1479) == (300 + 2207))) then
									if (((4560 - (84 + 2)) >= (451 - 177)) and v23(v98.RefreshingHealingPotion)) then
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
			if ((v127 == (0 + 0)) or ((2736 - (497 + 345)) <= (36 + 1370))) then
				if (((266 + 1306) >= (2864 - (605 + 728))) and v96.BitterImmunity:IsReady() and v62 and (v13:HealthPercentage() <= v71)) then
					if (v23(v96.BitterImmunity) or ((3345 + 1342) < (10097 - 5555))) then
						return "bitter_immunity defensive";
					end
				end
				if (((151 + 3140) > (6163 - 4496)) and v96.DieByTheSword:IsCastable() and v63 and (v13:HealthPercentage() <= v72)) then
					if (v23(v96.DieByTheSword) or ((788 + 85) == (5635 - 3601))) then
						return "die_by_the_sword defensive";
					end
				end
				v127 = 1 + 0;
			end
			if ((v127 == (492 - (457 + 32))) or ((1195 + 1621) < (1413 - (832 + 570)))) then
				if (((3485 + 214) < (1228 + 3478)) and v96.BattleStance:IsCastable() and v13:BuffDown(v96.BattleStance, true) and v67 and (v13:HealthPercentage() > v80)) then
					if (((9363 - 6717) >= (422 + 454)) and v23(v96.BattleStance)) then
						return "battle_stance after defensive stance defensive";
					end
				end
				if (((1410 - (588 + 208)) <= (8581 - 5397)) and v97.Healthstone:IsReady() and v68 and (v13:HealthPercentage() <= v78)) then
					if (((4926 - (884 + 916)) == (6544 - 3418)) and v23(v98.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				v127 = 3 + 1;
			end
		end
	end
	local function v110()
		local v128 = 653 - (232 + 421);
		while true do
			if ((v128 == (1889 - (1569 + 320))) or ((537 + 1650) >= (942 + 4012))) then
				v26 = v92.HandleTopTrinket(v99, v29, 134 - 94, nil);
				if (v26 or ((4482 - (316 + 289)) == (9358 - 5783))) then
					return v26;
				end
				v128 = 1 + 0;
			end
			if (((2160 - (666 + 787)) > (1057 - (360 + 65))) and (v128 == (1 + 0))) then
				v26 = v92.HandleBottomTrinket(v99, v29, 294 - (79 + 175), nil);
				if (v26 or ((860 - 314) >= (2095 + 589))) then
					return v26;
				end
				break;
			end
		end
	end
	local function v111()
		local v129 = 0 - 0;
		while true do
			if (((2821 - 1356) <= (5200 - (503 + 396))) and (v129 == (181 - (92 + 89)))) then
				if (((3305 - 1601) > (731 + 694)) and v100) then
					if ((v96.Skullsplitter:IsCastable() and v43) or ((407 + 280) == (16580 - 12346))) then
						if (v23(v96.Skullsplitter) or ((456 + 2874) < (3257 - 1828))) then
							return "skullsplitter precombat";
						end
					end
					if (((1001 + 146) >= (161 + 174)) and (v89 < v102) and v96.ColossusSmash:IsCastable() and v35 and ((v53 and v29) or not v53)) then
						if (((10461 - 7026) > (262 + 1835)) and v23(v96.ColossusSmash)) then
							return "colossus_smash precombat";
						end
					end
					if (((v89 < v102) and v96.Warbreaker:IsCastable() and v48 and ((v56 and v29) or not v56)) or ((5749 - 1979) >= (5285 - (485 + 759)))) then
						if (v23(v96.Warbreaker) or ((8771 - 4980) <= (2800 - (442 + 747)))) then
							return "warbreaker precombat";
						end
					end
					if ((v96.Overpower:IsCastable() and v39) or ((5713 - (832 + 303)) <= (2954 - (88 + 858)))) then
						if (((343 + 782) <= (1719 + 357)) and v23(v96.Overpower)) then
							return "overpower precombat";
						end
					end
				end
				if ((v33 and v96.Charge:IsCastable()) or ((31 + 712) >= (5188 - (766 + 23)))) then
					if (((5701 - 4546) < (2287 - 614)) and v23(v96.Charge)) then
						return "charge precombat";
					end
				end
				break;
			end
		end
	end
	local function v112()
		local v130 = 0 - 0;
		while true do
			if ((v130 == (6 - 4)) or ((3397 - (1036 + 37)) <= (410 + 168))) then
				if (((7335 - 3568) == (2964 + 803)) and (v89 < v102) and v32 and ((v52 and v29) or not v52) and v96.Bladestorm:IsCastable() and (((v104 > (1481 - (641 + 839))) and (v13:BuffUp(v96.TestofMightBuff) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)))) or ((v104 > (914 - (910 + 3))) and (v14:DebuffRemains(v96.DeepWoundsDebuff) > (0 - 0))))) then
					if (((5773 - (1466 + 218)) == (1880 + 2209)) and v23(v96.Bladestorm, not v100)) then
						return "bladestorm hac 78";
					end
				end
				if (((5606 - (556 + 592)) >= (596 + 1078)) and v96.Cleave:IsReady() and v34 and ((v104 > (810 - (329 + 479))) or (not v96.Battlelord:IsAvailable() and v13:BuffUp(v96.MercilessBonegrinderBuff) and (v96.MortalStrike:CooldownRemains() > v13:GCD())))) then
					if (((1826 - (174 + 680)) <= (4872 - 3454)) and v23(v96.Cleave, not v100)) then
						return "cleave hac 79";
					end
				end
				if ((v96.Whirlwind:IsReady() and v49 and ((v104 > (3 - 1)) or (v96.StormofSwords:IsAvailable() and (v13:BuffUp(v96.MercilessBonegrinderBuff) or v13:BuffUp(v96.HurricaneBuff))))) or ((3526 + 1412) < (5501 - (396 + 343)))) then
					if (v23(v96.Whirlwind, not v14:IsInMeleeRange(1 + 7)) or ((3981 - (29 + 1448)) > (5653 - (135 + 1254)))) then
						return "whirlwind hac 80";
					end
				end
				if (((8110 - 5957) == (10052 - 7899)) and v96.Skullsplitter:IsCastable() and v43 and ((v13:Rage() < (27 + 13)) or (v96.TideofBlood:IsAvailable() and (v14:DebuffRemains(v96.RendDebuff) > (1527 - (389 + 1138))) and ((v13:BuffUp(v96.SweepingStrikes) and (v104 > (576 - (102 + 472)))) or v14:DebuffUp(v96.ColossusSmashDebuff) or v13:BuffUp(v96.TestofMightBuff))))) then
					if (v23(v96.Skullsplitter, not v14:IsInMeleeRange(8 + 0)) or ((282 + 225) >= (2416 + 175))) then
						return "sweeping_strikes execute 81";
					end
				end
				if (((6026 - (320 + 1225)) == (7976 - 3495)) and v96.MortalStrike:IsReady() and v38 and v13:BuffUp(v96.SweepingStrikes) and (v13:BuffStack(v96.CrushingAdvanceBuff) == (2 + 1))) then
					if (v23(v96.MortalStrike, not v100) or ((3792 - (157 + 1307)) < (2552 - (821 + 1038)))) then
						return "mortal_strike hac 81.5";
					end
				end
				if (((10798 - 6470) == (474 + 3854)) and v96.Overpower:IsCastable() and v39 and v13:BuffUp(v96.SweepingStrikes) and v96.Dreadnaught:IsAvailable()) then
					if (((2820 - 1232) >= (496 + 836)) and v23(v96.Overpower, not v100)) then
						return "overpower hac 82";
					end
				end
				v130 = 7 - 4;
			end
			if ((v130 == (1031 - (834 + 192))) or ((266 + 3908) > (1091 + 3157))) then
				if ((v96.IgnorePain:IsReady() and v64 and v96.Battlelord:IsAvailable() and v96.AngerManagement:IsAvailable() and (v13:Rage() > (1 + 29)) and ((v14:HealthPercentage() < (30 - 10)) or (v96.Massacre:IsAvailable() and (v14:HealthPercentage() < (339 - (300 + 4)))))) or ((1225 + 3361) <= (214 - 132))) then
					if (((4225 - (112 + 250)) == (1540 + 2323)) and v23(v96.IgnorePain, not v100)) then
						return "ignore_pain hac 95";
					end
				end
				if ((v96.Slam:IsReady() and v44 and v96.CrushingForce:IsAvailable() and (v13:Rage() > (75 - 45)) and ((v96.FervorofBattle:IsAvailable() and (v104 == (1 + 0))) or not v96.FervorofBattle:IsAvailable())) or ((146 + 136) <= (32 + 10))) then
					if (((2286 + 2323) >= (570 + 196)) and v23(v96.Slam, not v100)) then
						return "slam hac 96";
					end
				end
				if ((v96.Shockwave:IsCastable() and v42 and (v96.SonicBoom:IsAvailable())) or ((2566 - (1001 + 413)) == (5547 - 3059))) then
					if (((4304 - (244 + 638)) > (4043 - (627 + 66))) and v23(v96.Shockwave, not v14:IsInMeleeRange(23 - 15))) then
						return "shockwave hac 97";
					end
				end
				if (((1479 - (512 + 90)) > (2282 - (1665 + 241))) and v29 and (v89 < v102) and v32 and ((v52 and v29) or not v52) and v96.Bladestorm:IsCastable()) then
					if (v23(v96.Bladestorm, not v100) or ((3835 - (373 + 344)) <= (835 + 1016))) then
						return "bladestorm hac 98";
					end
				end
				break;
			end
			if ((v130 == (0 + 0)) or ((435 - 270) >= (5908 - 2416))) then
				if (((5048 - (35 + 1064)) < (3534 + 1322)) and v96.Execute:IsReady() and v36 and v13:BuffUp(v96.JuggernautBuff) and (v13:BuffRemains(v96.JuggernautBuff) < v13:GCD())) then
					if (v23(v96.Execute, not v100) or ((9148 - 4872) < (13 + 3003))) then
						return "execute hac 67";
					end
				end
				if (((5926 - (298 + 938)) > (5384 - (233 + 1026))) and v96.ThunderClap:IsReady() and v46 and (v104 > (1668 - (636 + 1030))) and v96.BloodandThunder:IsAvailable() and v96.Rend:IsAvailable() and v14:DebuffRefreshable(v96.RendDebuff)) then
					if (v23(v96.ThunderClap, not v100) or ((26 + 24) >= (876 + 20))) then
						return "thunder_clap hac 68";
					end
				end
				if ((v96.SweepingStrikes:IsCastable() and v45 and (v104 >= (1 + 1)) and ((v96.Bladestorm:CooldownRemains() > (2 + 13)) or not v96.Bladestorm:IsAvailable())) or ((1935 - (55 + 166)) >= (574 + 2384))) then
					if (v23(v96.SweepingStrikes, not v14:IsInMeleeRange(1 + 7)) or ((5694 - 4203) < (941 - (36 + 261)))) then
						return "sweeping_strikes hac 68";
					end
				end
				if (((1231 - 527) < (2355 - (34 + 1334))) and ((v96.Rend:IsReady() and v40 and (v104 == (1 + 0)) and ((v14:HealthPercentage() > (16 + 4)) or (v96.Massacre:IsAvailable() and (v14:HealthPercentage() < (1318 - (1035 + 248)))))) or (v96.TideofBlood:IsAvailable() and (v96.Skullsplitter:CooldownRemains() <= v13:GCD()) and ((v96.ColossusSmash:CooldownRemains() < v13:GCD()) or v14:DebuffUp(v96.ColossusSmashDebuff)) and (v14:DebuffRemains(v96.RendDebuff) < ((42 - (20 + 1)) * (0.85 + 0)))))) then
					if (((4037 - (134 + 185)) > (3039 - (549 + 584))) and v23(v96.Rend, not v100)) then
						return "rend hac 70";
					end
				end
				if (((v89 < v102) and v30 and ((v51 and v29) or not v51) and v96.Avatar:IsCastable()) or ((1643 - (314 + 371)) > (12478 - 8843))) then
					if (((4469 - (478 + 490)) <= (2380 + 2112)) and v23(v96.Avatar, not v100)) then
						return "avatar hac 71";
					end
				end
				if (((v89 < v102) and v96.Warbreaker:IsCastable() and v48 and ((v56 and v29) or not v56) and (v104 > (1173 - (786 + 386)))) or ((11148 - 7706) < (3927 - (1055 + 324)))) then
					if (((4215 - (1093 + 247)) >= (1301 + 163)) and v23(v96.Warbreaker, not v100)) then
						return "warbreaker hac 72";
					end
				end
				v130 = 1 + 0;
			end
			if (((11 - 8) == v130) or ((16279 - 11482) >= (13922 - 9029))) then
				if ((v96.MortalStrike:IsReady() and v38) or ((1384 - 833) > (736 + 1332))) then
					if (((8144 - 6030) > (3253 - 2309)) and v92.CastCycle(v96.MortalStrike, v103, v107, not v100)) then
						return "mortal_strike hac 83";
					end
					if (v23(v96.MortalStrike, not v100) or ((1706 + 556) >= (7917 - 4821))) then
						return "mortal_strike hac 83";
					end
				end
				if ((v96.Execute:IsReady() and v36 and (v13:BuffUp(v96.SuddenDeathBuff) or ((v104 <= (690 - (364 + 324))) and ((v14:HealthPercentage() < (54 - 34)) or (v96.Massacre:IsAvailable() and (v14:HealthPercentage() < (83 - 48))))) or v13:BuffUp(v96.SweepingStrikes))) or ((748 + 1507) >= (14799 - 11262))) then
					if (v92.CastCycle(v96.Execute, v103, v108, not v100) or ((6144 - 2307) < (3966 - 2660))) then
						return "execute hac 84";
					end
					if (((4218 - (1249 + 19)) == (2663 + 287)) and v23(v96.Execute, not v100)) then
						return "execute hac 84";
					end
				end
				if (((v89 < v102) and v47 and ((v55 and v29) or not v55) and v96.ThunderousRoar:IsCastable()) or ((18384 - 13661) < (4384 - (686 + 400)))) then
					if (((892 + 244) >= (383 - (73 + 156))) and v23(v96.ThunderousRoar, not v14:IsInMeleeRange(1 + 7))) then
						return "thunderous_roar hac 85";
					end
				end
				if ((v96.Shockwave:IsCastable() and v42 and (v104 > (813 - (721 + 90))) and (v96.SonicBoom:IsAvailable() or v14:IsCasting())) or ((4 + 267) > (15416 - 10668))) then
					if (((5210 - (224 + 246)) >= (5105 - 1953)) and v23(v96.Shockwave, not v14:IsInMeleeRange(14 - 6))) then
						return "shockwave hac 86";
					end
				end
				if ((v96.Overpower:IsCastable() and v39 and (v104 == (1 + 0)) and (((v96.Overpower:Charges() == (1 + 1)) and not v96.Battlelord:IsAvailable() and (v14:Debuffdown(v96.ColossusSmashDebuff) or (v13:RagePercentage() < (19 + 6)))) or v96.Battlelord:IsAvailable())) or ((5125 - 2547) >= (11281 - 7891))) then
					if (((554 - (203 + 310)) <= (3654 - (1238 + 755))) and v23(v96.Overpower, not v100)) then
						return "overpower hac 87";
					end
				end
				if (((42 + 559) < (5094 - (709 + 825))) and v96.Slam:IsReady() and v44 and (v104 == (1 - 0)) and not v96.Battlelord:IsAvailable() and (v13:RagePercentage() > (101 - 31))) then
					if (((1099 - (196 + 668)) < (2712 - 2025)) and v23(v96.Slam, not v100)) then
						return "slam hac 88";
					end
				end
				v130 = 7 - 3;
			end
			if (((5382 - (171 + 662)) > (1246 - (4 + 89))) and ((13 - 9) == v130)) then
				if ((v96.Overpower:IsCastable() and v39 and (((v96.Overpower:Charges() == (1 + 1)) and (not v96.TestofMight:IsAvailable() or (v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)) or v96.Battlelord:IsAvailable())) or (v13:Rage() < (307 - 237)))) or ((1833 + 2841) < (6158 - (35 + 1451)))) then
					if (((5121 - (28 + 1425)) < (6554 - (941 + 1052))) and v23(v96.Overpower, not v100)) then
						return "overpower hac 89";
					end
				end
				if ((v96.ThunderClap:IsReady() and v46 and (v104 > (2 + 0))) or ((1969 - (822 + 692)) == (5146 - 1541))) then
					if (v23(v96.ThunderClap, not v100) or ((1255 + 1408) == (3609 - (45 + 252)))) then
						return "thunder_clap hac 90";
					end
				end
				if (((4232 + 45) <= (1541 + 2934)) and v96.MortalStrike:IsReady() and v38) then
					if (v23(v96.MortalStrike, not v100) or ((2117 - 1247) == (1622 - (114 + 319)))) then
						return "mortal_strike hac 91";
					end
				end
				if (((2228 - 675) <= (4014 - 881)) and v96.Rend:IsReady() and v40 and (v104 == (1 + 0)) and v14:DebuffRefreshable(v96.RendDebuff)) then
					if (v23(v96.Rend, not v100) or ((3332 - 1095) >= (7356 - 3845))) then
						return "rend hac 92";
					end
				end
				if ((v96.Whirlwind:IsReady() and v49 and (v96.StormofSwords:IsAvailable() or (v96.FervorofBattle:IsAvailable() and (v104 > (1964 - (556 + 1407)))))) or ((2530 - (741 + 465)) > (3485 - (170 + 295)))) then
					if (v23(v96.Whirlwind, not v14:IsInMeleeRange(5 + 3)) or ((2749 + 243) == (4631 - 2750))) then
						return "whirlwind hac 93";
					end
				end
				if (((2575 + 531) > (979 + 547)) and v96.Cleave:IsReady() and v34 and not v96.CrushingForce:IsAvailable()) then
					if (((1712 + 1311) < (5100 - (957 + 273))) and v23(v96.Cleave, not v100)) then
						return "cleave hac 94";
					end
				end
				v130 = 2 + 3;
			end
			if (((58 + 85) > (281 - 207)) and (v130 == (2 - 1))) then
				if (((54 - 36) < (10457 - 8345)) and (v89 < v102) and v35 and ((v53 and v29) or not v53) and v96.ColossusSmash:IsCastable()) then
					local v190 = 1780 - (389 + 1391);
					while true do
						if (((689 + 408) <= (170 + 1458)) and (v190 == (0 - 0))) then
							if (((5581 - (783 + 168)) == (15539 - 10909)) and v92.CastCycle(v96.ColossusSmash, v103, v106, not v100)) then
								return "colossus_smash hac 73";
							end
							if (((3483 + 57) > (2994 - (309 + 2))) and v23(v96.ColossusSmash, not v100)) then
								return "colossus_smash hac 73";
							end
							break;
						end
					end
				end
				if (((14721 - 9927) >= (4487 - (1090 + 122))) and (v89 < v102) and v35 and ((v53 and v29) or not v53) and v96.ColossusSmash:IsCastable()) then
					if (((482 + 1002) == (4983 - 3499)) and v23(v96.ColossusSmash, not v100)) then
						return "colossus_smash hac 74";
					end
				end
				if (((981 + 451) < (4673 - (628 + 490))) and (v89 < v102) and v47 and ((v55 and v29) or not v55) and v96.ThunderousRoar:IsCastable() and (v13:BuffUp(v96.TestofMightBuff) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)) or ((v104 > (1 + 0)) and (v14:DebuffRemains(v96.DeepWoundsDebuff) > (0 - 0))))) then
					if (v23(v96.ThunderousRoar, not v14:IsInMeleeRange(36 - 28)) or ((1839 - (431 + 343)) > (7226 - 3648))) then
						return "thunderous_roar hac 75";
					end
				end
				if (((v89 < v102) and v82 and ((v54 and v29) or not v54) and (v83 == "player") and v96.SpearofBastion:IsCastable() and (v13:BuffUp(v96.TestofMightBuff) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)))) or ((13871 - 9076) < (1112 + 295))) then
					if (((238 + 1615) < (6508 - (556 + 1139))) and v23(v98.SpearOfBastionPlayer, not v14:IsSpellInRange(v96.SpearofBastion))) then
						return "spear_of_bastion hac 76";
					end
				end
				if (((v89 < v102) and v82 and ((v54 and v29) or not v54) and (v83 == "cursor") and v96.SpearofBastion:IsCastable() and (v13:BuffUp(v96.TestofMightBuff) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)))) or ((2836 - (6 + 9)) < (446 + 1985))) then
					if (v23(v98.SpearOfBastionCursor, not v14:IsSpellInRange(v96.SpearofBastion)) or ((1473 + 1401) < (2350 - (28 + 141)))) then
						return "spear_of_bastion hac 76";
					end
				end
				if (((v89 < v102) and v32 and ((v52 and v29) or not v52) and v96.Bladestorm:IsCastable() and v96.Unhinged:IsAvailable() and (v13:BuffUp(v96.TestofMightBuff) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)))) or ((1042 + 1647) <= (422 - 79))) then
					if (v23(v96.Bladestorm, not v100) or ((1324 + 545) == (3326 - (486 + 831)))) then
						return "bladestorm hac 77";
					end
				end
				v130 = 5 - 3;
			end
		end
	end
	local function v113()
		if (((v89 < v102) and v45 and v96.SweepingStrikes:IsCastable() and (v104 > (3 - 2))) or ((671 + 2875) < (7341 - 5019))) then
			if (v23(v96.SweepingStrikes, not v14:IsInMeleeRange(1271 - (668 + 595))) or ((1874 + 208) == (963 + 3810))) then
				return "sweeping_strikes execute 51";
			end
		end
		if (((8846 - 5602) > (1345 - (23 + 267))) and v96.Rend:IsReady() and v40 and (v14:DebuffRemains(v96.RendDebuff) <= v13:GCD()) and not v96.Bloodletting:IsAvailable() and ((not v96.Warbreaker:IsAvailable() and (v96.ColossusSmash:CooldownRemains() < (1948 - (1129 + 815)))) or (v96.Warbreaker:IsAvailable() and (v96.Warbreaker:CooldownRemains() < (391 - (371 + 16))))) and (v14:TimeToDie() > (1762 - (1326 + 424)))) then
			if (v23(v96.Rend, not v100) or ((6274 - 2961) <= (6497 - 4719))) then
				return "rend execute 52";
			end
		end
		if (((v89 < v102) and v30 and ((v51 and v29) or not v51) and v96.Avatar:IsCastable() and (v96.ColossusSmash:CooldownUp() or v14:DebuffUp(v96.ColossusSmashDebuff) or (v102 < (138 - (88 + 30))))) or ((2192 - (720 + 51)) >= (4680 - 2576))) then
			if (((3588 - (421 + 1355)) <= (5359 - 2110)) and v23(v96.Avatar, not v100)) then
				return "avatar execute 53";
			end
		end
		if (((798 + 825) <= (3040 - (286 + 797))) and (v89 < v102) and v48 and ((v56 and v29) or not v56) and v96.Warbreaker:IsCastable()) then
			if (((16128 - 11716) == (7307 - 2895)) and v23(v96.Warbreaker, not v100)) then
				return "warbreaker execute 54";
			end
		end
		if (((2189 - (397 + 42)) >= (263 + 579)) and (v89 < v102) and v35 and ((v53 and v29) or not v53) and v96.ColossusSmash:IsCastable()) then
			if (((5172 - (24 + 776)) > (2850 - 1000)) and v23(v96.ColossusSmash, not v100)) then
				return "colossus_smash execute 55";
			end
		end
		if (((1017 - (222 + 563)) < (1808 - 987)) and v96.Execute:IsReady() and v36 and v13:BuffUp(v96.SuddenDeathBuff) and (v14:DebuffRemains(v96.DeepWoundsDebuff) > (0 + 0))) then
			if (((708 - (23 + 167)) < (2700 - (690 + 1108))) and v23(v96.Execute, not v100)) then
				return "execute execute 56";
			end
		end
		if (((1081 + 1913) > (708 + 150)) and v96.Skullsplitter:IsCastable() and v43 and ((v96.TestofMight:IsAvailable() and (v13:RagePercentage() <= (878 - (40 + 808)))) or (not v96.TestofMight:IsAvailable() and (v14:DebuffUp(v96.ColossusSmashDebuff) or (v96.ColossusSmash:CooldownRemains() > (1 + 4))) and (v13:RagePercentage() <= (114 - 84))))) then
			if (v23(v96.Skullsplitter, not v14:IsInMeleeRange(8 + 0)) or ((1987 + 1768) <= (502 + 413))) then
				return "skullsplitter execute 57";
			end
		end
		if (((4517 - (47 + 524)) > (2430 + 1313)) and (v89 < v102) and v47 and ((v55 and v29) or not v55) and v96.ThunderousRoar:IsCastable() and (v13:BuffUp(v96.TestofMightBuff) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)))) then
			if (v23(v96.ThunderousRoar, not v14:IsInMeleeRange(21 - 13)) or ((1996 - 661) >= (7539 - 4233))) then
				return "thunderous_roar execute 57";
			end
		end
		if (((6570 - (1165 + 561)) > (67 + 2186)) and (v89 < v102) and v82 and ((v54 and v29) or not v54) and (v83 == "player") and v96.SpearofBastion:IsCastable() and (v14:DebuffUp(v96.ColossusSmashDebuff) or v13:BuffUp(v96.TestofMightBuff))) then
			if (((1399 - 947) == (173 + 279)) and v23(v98.SpearOfBastionPlayer, not v14:IsSpellInRange(v96.SpearofBastion))) then
				return "spear_of_bastion execute 57";
			end
		end
		if (((v89 < v102) and v82 and ((v54 and v29) or not v54) and (v83 == "cursor") and v96.SpearofBastion:IsCastable() and (v14:DebuffUp(v96.ColossusSmashDebuff) or v13:BuffUp(v96.TestofMightBuff))) or ((5036 - (341 + 138)) < (564 + 1523))) then
			if (((7994 - 4120) == (4200 - (89 + 237))) and v23(v98.SpearOfBastionCursor, not v14:IsSpellInRange(v96.SpearofBastion))) then
				return "spear_of_bastion execute 57";
			end
		end
		if ((v96.Cleave:IsReady() and v34 and (v104 > (6 - 4)) and (v14:DebuffRemains(v96.DeepWoundsDebuff) < v13:GCD())) or ((4080 - 2142) > (5816 - (581 + 300)))) then
			if (v23(v96.Cleave, not v100) or ((5475 - (855 + 365)) < (8130 - 4707))) then
				return "cleave execute 58";
			end
		end
		if (((475 + 979) <= (3726 - (1030 + 205))) and v96.MortalStrike:IsReady() and v38 and ((v14:DebuffStack(v96.ExecutionersPrecisionDebuff) == (2 + 0)) or (v14:DebuffRemains(v96.DeepWoundsDebuff) <= v13:GCD()))) then
			if (v23(v96.MortalStrike, not v100) or ((3868 + 289) <= (3089 - (156 + 130)))) then
				return "mortal_strike execute 59";
			end
		end
		if (((11026 - 6173) >= (5025 - 2043)) and v96.Overpower:IsCastable() and v39 and (v13:Rage() < (81 - 41)) and (v13:BuffStack(v96.MartialProwessBuff) < (1 + 1))) then
			if (((2411 + 1723) > (3426 - (10 + 59))) and v23(v96.Overpower, not v100)) then
				return "overpower execute 60";
			end
		end
		if ((v96.Execute:IsReady() and v36) or ((967 + 2450) < (12479 - 9945))) then
			if (v23(v96.Execute, not v100) or ((3885 - (671 + 492)) <= (131 + 33))) then
				return "execute execute 62";
			end
		end
		if ((v96.Shockwave:IsCastable() and v42 and (v96.SonicBoom:IsAvailable() or v14:IsCasting())) or ((3623 - (369 + 846)) < (559 + 1550))) then
			if (v23(v96.Shockwave, not v14:IsInMeleeRange(7 + 1)) or ((1978 - (1036 + 909)) == (1157 + 298))) then
				return "shockwave execute 63";
			end
		end
		if ((v96.Overpower:IsCastable() and v39) or ((743 - 300) >= (4218 - (11 + 192)))) then
			if (((1710 + 1672) > (341 - (135 + 40))) and v23(v96.Overpower, not v100)) then
				return "overpower execute 64";
			end
		end
		if (((v89 < v102) and v32 and ((v52 and v29) or not v52) and v96.Bladestorm:IsCastable()) or ((678 - 398) == (1844 + 1215))) then
			if (((4143 - 2262) > (1938 - 645)) and v23(v96.Bladestorm, not v100)) then
				return "bladestorm execute 65";
			end
		end
	end
	local function v114()
		if (((2533 - (50 + 126)) == (6563 - 4206)) and (v89 < v102) and v45 and v96.SweepingStrikes:IsCastable() and (v104 > (1 + 0))) then
			if (((1536 - (1233 + 180)) == (1092 - (522 + 447))) and v23(v96.SweepingStrikes, not v14:IsInMeleeRange(1429 - (107 + 1314)))) then
				return "sweeping_strikes single_target 97";
			end
		end
		if ((v96.Execute:IsReady() and (v13:BuffUp(v96.SuddenDeathBuff))) or ((491 + 565) >= (10335 - 6943))) then
			if (v23(v96.Execute, not v100) or ((460 + 621) < (2134 - 1059))) then
				return "execute single_target 98";
			end
		end
		if ((v96.MortalStrike:IsReady() and v38) or ((4150 - 3101) >= (6342 - (716 + 1194)))) then
			if (v23(v96.MortalStrike, not v100) or ((82 + 4686) <= (91 + 755))) then
				return "mortal_strike single_target 99";
			end
		end
		if ((v96.Rend:IsReady() and v40 and ((v14:DebuffRemains(v96.RendDebuff) <= v13:GCD()) or (v96.TideofBlood:IsAvailable() and (v96.Skullsplitter:CooldownRemains() <= v13:GCD()) and ((v96.ColossusSmash:CooldownRemains() <= v13:GCD()) or v14:DebuffUp(v96.ColossusSmashDebuff)) and (v14:DebuffRemains(v96.RendDebuff) < (v96.RendDebuff:BaseDuration() * (503.85 - (74 + 429))))))) or ((6477 - 3119) <= (704 + 716))) then
			if (v23(v96.Rend, not v100) or ((8558 - 4819) <= (2126 + 879))) then
				return "rend single_target 100";
			end
		end
		if (((v89 < v102) and v30 and ((v51 and v29) or not v51) and v96.Avatar:IsCastable() and ((v96.WarlordsTorment:IsAvailable() and (v13:RagePercentage() < (101 - 68)) and (v96.ColossusSmash:CooldownUp() or v14:DebuffUp(v96.ColossusSmashDebuff) or v13:BuffUp(v96.TestofMightBuff))) or (not v96.WarlordsTorment:IsAvailable() and (v96.ColossusSmash:CooldownUp() or v14:DebuffUp(v96.ColossusSmashDebuff))))) or ((4101 - 2442) >= (2567 - (279 + 154)))) then
			if (v23(v96.Avatar, not v100) or ((4038 - (454 + 324)) < (1853 + 502))) then
				return "avatar single_target 101";
			end
		end
		if (((v89 < v102) and v82 and ((v54 and v29) or not v54) and (v83 == "player") and v96.SpearofBastion:IsCastable() and ((v96.ColossusSmash:CooldownRemains() <= v13:GCD()) or (v96.Warbreaker:CooldownRemains() <= v13:GCD()))) or ((686 - (12 + 5)) == (2277 + 1946))) then
			if (v23(v98.SpearOfBastionPlayer, not v14:IsSpellInRange(v96.SpearofBastion)) or ((4310 - 2618) < (218 + 370))) then
				return "spear_of_bastion single_target 102";
			end
		end
		if (((v89 < v102) and v82 and ((v54 and v29) or not v54) and (v83 == "cursor") and v96.SpearofBastion:IsCastable() and ((v96.ColossusSmash:CooldownRemains() <= v13:GCD()) or (v96.Warbreaker:CooldownRemains() <= v13:GCD()))) or ((5890 - (277 + 816)) < (15600 - 11949))) then
			if (v23(v98.SpearOfBastionCursor, not v14:IsSpellInRange(v96.SpearofBastion)) or ((5360 - (1058 + 125)) > (910 + 3940))) then
				return "spear_of_bastion single_target 102";
			end
		end
		if (((v89 < v102) and v48 and ((v56 and v29) or not v56) and v96.Warbreaker:IsCastable()) or ((1375 - (815 + 160)) > (4766 - 3655))) then
			if (((7242 - 4191) > (240 + 765)) and v23(v96.Warbreaker, not v14:IsInRange(23 - 15))) then
				return "warbreaker single_target 103";
			end
		end
		if (((5591 - (41 + 1857)) <= (6275 - (1222 + 671))) and (v89 < v102) and v35 and ((v53 and v29) or not v53) and v96.ColossusSmash:IsCastable()) then
			if (v23(v96.ColossusSmash, not v100) or ((8482 - 5200) > (5893 - 1793))) then
				return "colossus_smash single_target 104";
			end
		end
		if ((v96.Skullsplitter:IsCastable() and v43 and not v96.TestofMight:IsAvailable() and (v14:DebuffRemains(v96.DeepWoundsDebuff) > (1182 - (229 + 953))) and (v14:DebuffUp(v96.ColossusSmashDebuff) or (v96.ColossusSmash:CooldownRemains() > (1777 - (1111 + 663))))) or ((5159 - (874 + 705)) < (399 + 2445))) then
			if (((61 + 28) < (9333 - 4843)) and v23(v96.Skullsplitter, not v100)) then
				return "skullsplitter single_target 105";
			end
		end
		if ((v96.Skullsplitter:IsCastable() and v43 and v96.TestofMight:IsAvailable() and (v14:DebuffRemains(v96.DeepWoundsDebuff) > (0 + 0))) or ((5662 - (642 + 37)) < (413 + 1395))) then
			if (((613 + 3216) > (9462 - 5693)) and v23(v96.Skullsplitter, not v100)) then
				return "skullsplitter single_target 106";
			end
		end
		if (((1939 - (233 + 221)) <= (6714 - 3810)) and (v89 < v102) and v47 and ((v55 and v29) or not v55) and v96.ThunderousRoar:IsCastable() and (v13:BuffUp(v96.TestofMightBuff) or (v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff) and (v13:RagePercentage() < (30 + 3))) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)))) then
			if (((5810 - (718 + 823)) == (2687 + 1582)) and v23(v96.ThunderousRoar, not v14:IsInMeleeRange(813 - (266 + 539)))) then
				return "thunderous_roar single_target 107";
			end
		end
		if (((1095 - 708) <= (4007 - (636 + 589))) and v96.Whirlwind:IsReady() and v49 and v96.StormofSwords:IsAvailable() and v96.TestofMight:IsAvailable() and (v13:RagePercentage() > (189 - 109)) and v14:DebuffUp(v96.ColossusSmashDebuff)) then
			if (v23(v96.Whirlwind, not v14:IsInMeleeRange(16 - 8)) or ((1505 + 394) <= (334 + 583))) then
				return "whirlwind single_target 108";
			end
		end
		if ((v96.ThunderClap:IsReady() and v46 and (v14:DebuffRemains(v96.RendDebuff) <= v13:GCD()) and not v96.TideofBlood:IsAvailable()) or ((5327 - (657 + 358)) <= (2319 - 1443))) then
			if (((5084 - 2852) <= (3783 - (1151 + 36))) and v23(v96.ThunderClap, not v100)) then
				return "thunder_clap single_target 109";
			end
		end
		if (((2024 + 71) < (970 + 2716)) and (v89 < v102) and v32 and ((v52 and v29) or not v52) and v96.Bladestorm:IsCastable() and ((v96.Hurricane:IsAvailable() and (v13:BuffUp(v96.TestofMightBuff) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)))) or (v96.Unhinged:IsAvailable() and (v13:BuffUp(v96.TestofMightBuff) or (not v96.TestofMight:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff)))))) then
			if (v23(v96.Bladestorm, not v100) or ((4763 - 3168) >= (6306 - (1552 + 280)))) then
				return "bladestorm single_target 110";
			end
		end
		if ((v96.Shockwave:IsCastable() and v42 and (v96.SonicBoom:IsAvailable() or v14:IsCasting())) or ((5453 - (64 + 770)) < (1957 + 925))) then
			if (v23(v96.Shockwave, not v14:IsInMeleeRange(18 - 10)) or ((53 + 241) >= (6074 - (157 + 1086)))) then
				return "shockwave single_target 111";
			end
		end
		if (((4060 - 2031) <= (13507 - 10423)) and v96.Whirlwind:IsReady() and v49 and v96.StormofSwords:IsAvailable() and v96.TestofMight:IsAvailable() and (v96.ColossusSmash:CooldownRemains() > (v13:GCD() * (10 - 3)))) then
			if (v23(v96.Whirlwind, not v14:IsInMeleeRange(10 - 2)) or ((2856 - (599 + 220)) == (4819 - 2399))) then
				return "whirlwind single_target 113";
			end
		end
		if (((6389 - (1813 + 118)) > (2854 + 1050)) and v96.Overpower:IsCastable() and v39 and (((v96.Overpower:Charges() == (1219 - (841 + 376))) and not v96.Battlelord:IsAvailable() and (v14:DebuffUp(v96.ColossusSmashDebuff) or (v13:RagePercentage() < (34 - 9)))) or v96.Battlelord:IsAvailable())) then
			if (((102 + 334) >= (335 - 212)) and v23(v96.Overpower, not v100)) then
				return "overpower single_target 114";
			end
		end
		if (((1359 - (464 + 395)) < (4660 - 2844)) and v96.Slam:IsReady() and v44 and ((v96.CrushingForce:IsAvailable() and v14:DebuffUp(v96.ColossusSmashDebuff) and (v13:Rage() >= (29 + 31)) and v96.TestofMight:IsAvailable()) or v96.ImprovedSlam:IsAvailable()) and (not v96.FervorofBattle:IsAvailable() or (v96.FervorofBattle:IsAvailable() and (v104 == (838 - (467 + 370)))))) then
			if (((7385 - 3811) == (2624 + 950)) and v23(v96.Slam, not v100)) then
				return "slam single_target 115";
			end
		end
		if (((757 - 536) < (61 + 329)) and v96.Whirlwind:IsReady() and v49 and (v96.StormofSwords:IsAvailable() or (v96.FervorofBattle:IsAvailable() and (v104 > (2 - 1))))) then
			if (v23(v96.Whirlwind, not v14:IsInMeleeRange(528 - (150 + 370))) or ((3495 - (74 + 1208)) <= (3494 - 2073))) then
				return "whirlwind single_target 116";
			end
		end
		if (((14502 - 11444) < (3459 + 1401)) and v96.Slam:IsReady() and v44 and (v96.CrushingForce:IsAvailable() or (not v96.CrushingForce:IsAvailable() and (v13:Rage() >= (420 - (14 + 376))))) and (not v96.FervorofBattle:IsAvailable() or (v96.FervorofBattle:IsAvailable() and (v104 == (1 - 0))))) then
			if (v23(v96.Slam, not v100) or ((839 + 457) >= (3906 + 540))) then
				return "slam single_target 117";
			end
		end
		if ((v96.ThunderClap:IsReady() and v46 and v96.Battlelord:IsAvailable() and v96.BloodandThunder:IsAvailable()) or ((1329 + 64) > (13153 - 8664))) then
			if (v23(v96.ThunderClap, not v100) or ((3329 + 1095) < (105 - (23 + 55)))) then
				return "thunder_clap single_target 118";
			end
		end
		if ((v96.Overpower:IsCastable() and v39 and ((v14:DebuffDown(v96.ColossusSmashDebuff) and (v13:RagePercentage() < (118 - 68)) and not v96.Battlelord:IsAvailable()) or (v13:RagePercentage() < (17 + 8)))) or ((1794 + 203) > (5915 - 2100))) then
			if (((1090 + 2375) > (2814 - (652 + 249))) and v23(v96.Overpower, not v100)) then
				return "overpower single_target 119";
			end
		end
		if (((1961 - 1228) < (3687 - (708 + 1160))) and v96.Whirlwind:IsReady() and v49 and v13:BuffUp(v96.MercilessBonegrinderBuff)) then
			if (v23(v96.Whirlwind, not v14:IsInRange(21 - 13)) or ((8013 - 3618) == (4782 - (10 + 17)))) then
				return "whirlwind single_target 120";
			end
		end
		if ((v96.Cleave:IsReady() and v34 and v13:HasTier(7 + 22, 1734 - (1400 + 332)) and not v96.CrushingForce:IsAvailable()) or ((7275 - 3482) < (4277 - (242 + 1666)))) then
			if (v23(v96.Cleave, not v100) or ((1748 + 2336) == (98 + 167))) then
				return "cleave single_target 121";
			end
		end
		if (((3715 + 643) == (5298 - (850 + 90))) and (v89 < v102) and v32 and ((v52 and v29) or not v52) and v96.Bladestorm:IsCastable()) then
			if (v23(v96.Bladestorm, not v100) or ((5495 - 2357) < (2383 - (360 + 1030)))) then
				return "bladestorm single_target 122";
			end
		end
		if (((2947 + 383) > (6556 - 4233)) and v96.Cleave:IsReady() and v34) then
			if (v23(v96.Cleave, not v100) or ((4988 - 1362) == (5650 - (909 + 752)))) then
				return "cleave single_target 123";
			end
		end
		if ((v96.Rend:IsReady() and v40 and v14:DebuffRefreshable(v96.RendDebuff) and not v96.CrushingForce:IsAvailable()) or ((2139 - (109 + 1114)) == (4889 - 2218))) then
			if (((106 + 166) == (514 - (6 + 236))) and v23(v96.Rend, not v100)) then
				return "rend single_target 124";
			end
		end
	end
	local function v115()
		if (((2678 + 1571) <= (3896 + 943)) and not v13:AffectingCombat()) then
			local v163 = 0 - 0;
			while true do
				if (((4850 - 2073) < (4333 - (1076 + 57))) and (v163 == (0 + 0))) then
					if (((784 - (579 + 110)) < (155 + 1802)) and v96.BattleStance:IsCastable() and v13:BuffDown(v96.BattleStance, true)) then
						if (((731 + 95) < (912 + 805)) and v23(v96.BattleStance)) then
							return "battle_stance";
						end
					end
					if (((1833 - (174 + 233)) >= (3086 - 1981)) and v96.BattleShout:IsCastable() and v31 and (v13:BuffDown(v96.BattleShoutBuff, true) or v92.GroupBuffMissing(v96.BattleShoutBuff))) then
						if (((4833 - 2079) <= (1503 + 1876)) and v23(v96.BattleShout)) then
							return "battle_shout precombat";
						end
					end
					break;
				end
			end
		end
		if ((v92.TargetIsValid() and v27) or ((5101 - (663 + 511)) == (1261 + 152))) then
			if (not v13:AffectingCombat() or ((251 + 903) <= (2429 - 1641))) then
				v26 = v111();
				if (v26 or ((995 + 648) > (7954 - 4575))) then
					return v26;
				end
			end
		end
	end
	local function v116()
		v26 = v109();
		if (v26 or ((6785 - 3982) > (2171 + 2378))) then
			return v26;
		end
		if (v84 or ((428 - 208) >= (2154 + 868))) then
			local v164 = 0 + 0;
			while true do
				if (((3544 - (478 + 244)) == (3339 - (440 + 77))) and (v164 == (0 + 0))) then
					v26 = v92.HandleIncorporeal(v96.StormBolt, v98.StormBoltMouseover, 73 - 53, true);
					if (v26 or ((2617 - (655 + 901)) == (345 + 1512))) then
						return v26;
					end
					v164 = 1 + 0;
				end
				if (((1864 + 896) > (5494 - 4130)) and (v164 == (1446 - (695 + 750)))) then
					v26 = v92.HandleIncorporeal(v96.IntimidatingShout, v98.IntimidatingShoutMouseover, 27 - 19, true);
					if (v26 or ((7564 - 2662) <= (14458 - 10863))) then
						return v26;
					end
					break;
				end
			end
		end
		if (v92.TargetIsValid() or ((4203 - (285 + 66)) == (682 - 389))) then
			local v165 = 1310 - (682 + 628);
			local v166;
			while true do
				if ((v165 == (1 + 2)) or ((1858 - (176 + 123)) == (1920 + 2668))) then
					v26 = v114();
					if (v26 or ((3253 + 1231) == (1057 - (239 + 30)))) then
						return v26;
					end
					if (((1242 + 3326) >= (3756 + 151)) and v19.CastAnnotated(v96.Pool, false, "WAIT")) then
						return "Wait/Pool Resources";
					end
					break;
				end
				if (((2204 - 958) < (10826 - 7356)) and (v165 == (317 - (306 + 9)))) then
					if (((14195 - 10127) >= (170 + 802)) and v96.WreckingThrow:IsCastable() and v50 and v14:AffectingCombat() and v105()) then
						if (((303 + 190) < (1874 + 2019)) and v23(v96.WreckingThrow, not v14:IsInRange(85 - 55))) then
							return "wrecking_throw main";
						end
					end
					if ((v28 and (v104 > (1377 - (1140 + 235)))) or ((938 + 535) >= (3056 + 276))) then
						v26 = v112();
						if (v26 or ((1040 + 3011) <= (1209 - (33 + 19)))) then
							return v26;
						end
					end
					if (((219 + 385) < (8635 - 5754)) and ((v96.Massacre:IsAvailable() and (v14:HealthPercentage() < (16 + 19))) or (v14:HealthPercentage() < (39 - 19)))) then
						local v191 = 0 + 0;
						while true do
							if ((v191 == (689 - (586 + 103))) or ((82 + 818) == (10396 - 7019))) then
								v26 = v113();
								if (((5947 - (1309 + 179)) > (1066 - 475)) and v26) then
									return v26;
								end
								break;
							end
						end
					end
					v165 = 2 + 1;
				end
				if (((9125 - 5727) >= (1810 + 585)) and (v165 == (1 - 0))) then
					if ((v100 and v90 and ((v58 and v29) or not v58) and (v89 < v102)) or ((4349 - 2166) >= (3433 - (295 + 314)))) then
						local v192 = 0 - 0;
						while true do
							if (((3898 - (1300 + 662)) == (6079 - 4143)) and (v192 == (1756 - (1178 + 577)))) then
								if ((v96.ArcaneTorrent:IsCastable() and (v96.MortalStrike:CooldownRemains() > (1.5 + 0)) and (v13:Rage() < (147 - 97))) or ((6237 - (851 + 554)) < (3814 + 499))) then
									if (((11337 - 7249) > (8413 - 4539)) and v23(v96.ArcaneTorrent, not v14:IsInRange(310 - (115 + 187)))) then
										return "arcane_torrent main 41";
									end
								end
								if (((3318 + 1014) == (4102 + 230)) and v96.LightsJudgment:IsCastable() and v14:DebuffDown(v96.ColossusSmashDebuff) and not v96.MortalStrike:CooldownUp()) then
									if (((15758 - 11759) >= (4061 - (160 + 1001))) and v23(v96.LightsJudgment, not v14:IsSpellInRange(v96.LightsJudgment))) then
										return "lights_judgment main 42";
									end
								end
								v192 = 2 + 0;
							end
							if ((v192 == (2 + 0)) or ((5169 - 2644) > (4422 - (237 + 121)))) then
								if (((5268 - (525 + 372)) == (8286 - 3915)) and v96.Fireblood:IsCastable() and (v14:DebuffUp(v96.ColossusSmashDebuff))) then
									if (v23(v96.Fireblood) or ((873 - 607) > (5128 - (96 + 46)))) then
										return "fireblood main 43";
									end
								end
								if (((2768 - (643 + 134)) >= (334 + 591)) and v96.AncestralCall:IsCastable() and (v14:DebuffUp(v96.ColossusSmashDebuff))) then
									if (((1090 - 635) < (7622 - 5569)) and v23(v96.AncestralCall)) then
										return "ancestral_call main 44";
									end
								end
								v192 = 3 + 0;
							end
							if ((v192 == (0 - 0)) or ((1688 - 862) == (5570 - (316 + 403)))) then
								if (((122 + 61) == (503 - 320)) and v96.BloodFury:IsCastable() and v14:DebuffUp(v96.ColossusSmashDebuff)) then
									if (((419 + 740) <= (4502 - 2714)) and v23(v96.BloodFury)) then
										return "blood_fury main 39";
									end
								end
								if ((v96.Berserking:IsCastable() and (v14:DebuffRemains(v96.ColossusSmashDebuff) > (5 + 1))) or ((1131 + 2376) > (14961 - 10643))) then
									if (v23(v96.Berserking) or ((14685 - 11610) <= (6159 - 3194))) then
										return "berserking main 40";
									end
								end
								v192 = 1 + 0;
							end
							if (((2687 - 1322) <= (99 + 1912)) and ((8 - 5) == v192)) then
								if ((v96.BagofTricks:IsCastable() and v14:DebuffDown(v96.ColossusSmashDebuff) and not v96.MortalStrike:CooldownUp()) or ((2793 - (12 + 5)) > (13885 - 10310))) then
									if (v23(v96.BagofTricks, not v14:IsSpellInRange(v96.BagofTricks)) or ((5449 - 2895) == (10211 - 5407))) then
										return "bag_of_tricks main 10";
									end
								end
								break;
							end
						end
					end
					if (((6390 - 3813) == (524 + 2053)) and (v89 < v102)) then
						if ((v91 and ((v29 and v57) or not v57)) or ((1979 - (1656 + 317)) >= (1684 + 205))) then
							local v193 = 0 + 0;
							while true do
								if (((1345 - 839) <= (9311 - 7419)) and (v193 == (354 - (5 + 349)))) then
									v26 = v110();
									if (v26 or ((9537 - 7529) > (3489 - (266 + 1005)))) then
										return v26;
									end
									break;
								end
							end
						end
					end
					if (((250 + 129) <= (14149 - 10002)) and v37 and v96.HeroicThrow:IsCastable() and not v14:IsInRange(39 - 9)) then
						if (v23(v96.HeroicThrow, not v14:IsInRange(1726 - (561 + 1135))) or ((5882 - 1368) <= (3316 - 2307))) then
							return "heroic_throw main";
						end
					end
					v165 = 1068 - (507 + 559);
				end
				if ((v165 == (0 - 0)) or ((10811 - 7315) == (1580 - (212 + 176)))) then
					if ((v33 and v96.Charge:IsCastable() and not v100) or ((1113 - (250 + 655)) == (8068 - 5109))) then
						if (((7472 - 3195) >= (2053 - 740)) and v23(v96.Charge, not v14:IsSpellInRange(v96.Charge))) then
							return "charge main 34";
						end
					end
					v166 = v92.HandleDPSPotion(v14:DebuffUp(v96.ColossusSmashDebuff));
					if (((4543 - (1869 + 87)) < (11008 - 7834)) and v166) then
						return v166;
					end
					v165 = 1902 - (484 + 1417);
				end
			end
		end
	end
	local function v117()
		v31 = EpicSettings.Settings['useBattleShout'];
		v33 = EpicSettings.Settings['useCharge'];
		v34 = EpicSettings.Settings['useCleave'];
		v36 = EpicSettings.Settings['useExecute'];
		v37 = EpicSettings.Settings['useHeroicThrow'];
		v38 = EpicSettings.Settings['useMortalStrike'];
		v39 = EpicSettings.Settings['useOverpower'];
		v40 = EpicSettings.Settings['useRend'];
		v42 = EpicSettings.Settings['useShockwave'];
		v43 = EpicSettings.Settings['useSkullsplitter'];
		v44 = EpicSettings.Settings['useSlam'];
		v45 = EpicSettings.Settings['useSweepingStrikes'];
		v46 = EpicSettings.Settings['useThunderClap'];
		v49 = EpicSettings.Settings['useWhirlwind'];
		v50 = EpicSettings.Settings['useWreckingThrow'];
		v30 = EpicSettings.Settings['useAvatar'];
		v32 = EpicSettings.Settings['useBladestorm'];
		v35 = EpicSettings.Settings['useColossusSmash'];
		v82 = EpicSettings.Settings['useSpearOfBastion'];
		v47 = EpicSettings.Settings['useThunderousRoar'];
		v48 = EpicSettings.Settings['useWarbreaker'];
		v51 = EpicSettings.Settings['avatarWithCD'];
		v52 = EpicSettings.Settings['bladestormWithCD'];
		v53 = EpicSettings.Settings['colossusSmashWithCD'];
		v54 = EpicSettings.Settings['spearOfBastionWithCD'];
		v55 = EpicSettings.Settings['thunderousRoarWithCD'];
		v56 = EpicSettings.Settings['warbreakerWithCD'];
	end
	local function v118()
		local v158 = 0 - 0;
		while true do
			if ((v158 == (2 - 0)) or ((4893 - (48 + 725)) <= (3590 - 1392))) then
				v64 = EpicSettings.Settings['useIgnorePain'];
				v66 = EpicSettings.Settings['useIntervene'];
				v65 = EpicSettings.Settings['useRallyingCry'];
				v158 = 7 - 4;
			end
			if ((v158 == (0 + 0)) or ((4265 - 2669) == (241 + 617))) then
				v59 = EpicSettings.Settings['usePummel'];
				v60 = EpicSettings.Settings['useStormBolt'];
				v61 = EpicSettings.Settings['useIntimidatingShout'];
				v158 = 1 + 0;
			end
			if (((4073 - (152 + 701)) == (4531 - (430 + 881))) and (v158 == (1 + 0))) then
				v62 = EpicSettings.Settings['useBitterImmunity'];
				v67 = EpicSettings.Settings['useDefensiveStance'];
				v63 = EpicSettings.Settings['useDieByTheSword'];
				v158 = 897 - (557 + 338);
			end
			if (((2 + 4) == v158) or ((3950 - 2548) > (12676 - 9056))) then
				v81 = EpicSettings.Settings['victoryRushHP'] or (0 - 0);
				v83 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
			if (((5547 - 2973) == (3375 - (499 + 302))) and (v158 == (869 - (39 + 827)))) then
				v70 = EpicSettings.Settings['useVictoryRush'];
				v71 = EpicSettings.Settings['bitterImmunityHP'] or (0 - 0);
				v77 = EpicSettings.Settings['defensiveStanceHP'] or (0 - 0);
				v158 = 15 - 11;
			end
			if (((2760 - 962) < (237 + 2520)) and ((14 - 9) == v158)) then
				v76 = EpicSettings.Settings['interveneHP'] or (0 + 0);
				v75 = EpicSettings.Settings['rallyingCryGroup'] or (0 - 0);
				v74 = EpicSettings.Settings['rallyingCryHP'] or (104 - (103 + 1));
				v158 = 560 - (475 + 79);
			end
			if ((v158 == (8 - 4)) or ((1206 - 829) > (337 + 2267))) then
				v80 = EpicSettings.Settings['unstanceHP'] or (0 + 0);
				v72 = EpicSettings.Settings['dieByTheSwordHP'] or (1503 - (1395 + 108));
				v73 = EpicSettings.Settings['ignorePainHP'] or (0 - 0);
				v158 = 1209 - (7 + 1197);
			end
		end
	end
	local function v119()
		local v159 = 0 + 0;
		while true do
			if (((199 + 369) < (1230 - (27 + 292))) and (v159 == (2 - 1))) then
				v91 = EpicSettings.Settings['useTrinkets'];
				v90 = EpicSettings.Settings['useRacials'];
				v57 = EpicSettings.Settings['trinketsWithCD'];
				v58 = EpicSettings.Settings['racialsWithCD'];
				v159 = 2 - 0;
			end
			if (((13776 - 10491) < (8337 - 4109)) and (v159 == (3 - 1))) then
				v68 = EpicSettings.Settings['useHealthstone'];
				v69 = EpicSettings.Settings['useHealingPotion'];
				v78 = EpicSettings.Settings['healthstoneHP'] or (139 - (43 + 96));
				v79 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v159 = 6 - 3;
			end
			if (((3250 + 666) > (940 + 2388)) and (v159 == (5 - 2))) then
				v85 = EpicSettings.Settings['HealingPotionName'] or "";
				v84 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((959 + 1541) < (7194 - 3355)) and (v159 == (0 + 0))) then
				v89 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v86 = EpicSettings.Settings['InterruptWithStun'];
				v87 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v88 = EpicSettings.Settings['InterruptThreshold'];
				v159 = 1752 - (1414 + 337);
			end
		end
	end
	local function v120()
		v118();
		v117();
		v119();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		if (((2447 - (1642 + 298)) == (1321 - 814)) and v13:IsDeadOrGhost()) then
			return v26;
		end
		if (((690 - 450) <= (9392 - 6227)) and v28) then
			v103 = v13:GetEnemiesInMeleeRange(3 + 5);
			v104 = #v103;
		else
			v104 = 1 + 0;
		end
		v100 = v14:IsInMeleeRange(980 - (357 + 615));
		if (((586 + 248) >= (1974 - 1169)) and (v92.TargetIsValid() or v13:AffectingCombat())) then
			local v167 = 0 + 0;
			while true do
				if ((v167 == (2 - 1)) or ((3049 + 763) < (158 + 2158))) then
					if ((v102 == (6984 + 4127)) or ((3953 - (384 + 917)) <= (2230 - (128 + 569)))) then
						v102 = v9.FightRemains(v103, false);
					end
					break;
				end
				if ((v167 == (1543 - (1407 + 136))) or ((5485 - (687 + 1200)) < (3170 - (556 + 1154)))) then
					v101 = v9.BossFightRemains(nil, true);
					v102 = v101;
					v167 = 3 - 2;
				end
			end
		end
		if (not v13:IsChanneling() or ((4211 - (9 + 86)) < (1613 - (275 + 146)))) then
			if (v13:AffectingCombat() or ((550 + 2827) <= (967 - (29 + 35)))) then
				v26 = v116();
				if (((17621 - 13645) >= (1310 - 871)) and v26) then
					return v26;
				end
			else
				local v188 = 0 - 0;
				while true do
					if (((2444 + 1308) == (4764 - (53 + 959))) and (v188 == (408 - (312 + 96)))) then
						v26 = v115();
						if (((7022 - 2976) > (2980 - (147 + 138))) and v26) then
							return v26;
						end
						break;
					end
				end
			end
		end
	end
	local function v121()
		v19.Print("Arms Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(970 - (813 + 86), v120, v121);
end;
return v0["Epix_Warrior_Arms.lua"]();

