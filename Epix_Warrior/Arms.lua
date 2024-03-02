local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((1006 + 80) >= (816 + 589))) then
			v6 = v0[v4];
			if (not v6 or ((10338 - 7969) == (948 - 522))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
		if ((v5 == (712 - (530 + 181))) or ((3957 - (614 + 267)) > (3215 - (19 + 13)))) then
			return v6(...);
		end
	end
end
v0["Epix_Warrior_Arms.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Player;
	local v15 = v12.Target;
	local v16 = v12.TargetTarget;
	local v17 = v12.Focus;
	local v18 = v10.Spell;
	local v19 = v10.Item;
	local v20 = EpicLib;
	local v21 = v20.Bind;
	local v22 = v20.Cast;
	local v23 = v20.Macro;
	local v24 = v20.Press;
	local v25 = v20.Commons.Everyone.num;
	local v26 = v20.Commons.Everyone.bool;
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
	local v93;
	local v94 = v10.Commons.Everyone;
	local v95 = v14:GetEquipment();
	local v96 = (v95[20 - 7] and v19(v95[29 - 16])) or v19(0 - 0);
	local v97 = (v95[4 + 10] and v19(v95[24 - 10])) or v19(0 - 0);
	local v98 = v18.Warrior.Arms;
	local v99 = v19.Warrior.Arms;
	local v100 = v23.Warrior.Arms;
	local v101 = {};
	local v102;
	local v103 = 12923 - (1293 + 519);
	local v104 = 22669 - 11558;
	v10:RegisterForEvent(function()
		v103 = 29010 - 17899;
		v104 = 21247 - 10136;
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v95 = v14:GetEquipment();
		v96 = (v95[56 - 43] and v19(v95[30 - 17])) or v19(0 + 0);
		v97 = (v95[3 + 11] and v19(v95[32 - 18])) or v19(0 + 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v105;
	local v106;
	local function v107()
		local v124 = UnitGetTotalAbsorbs(v15:ID());
		if (((400 + 802) > (662 + 396)) and (v124 > (1096 - (709 + 387)))) then
			return true;
		else
			return false;
		end
	end
	local function v108(v125)
		return (v125:HealthPercentage() > (1878 - (673 + 1185))) or (v98.Massacre:IsAvailable() and (v125:HealthPercentage() < (101 - 66)));
	end
	local function v109(v126)
		return (v126:DebuffStack(v98.ExecutionersPrecisionDebuff) == (6 - 4)) or (v126:DebuffRemains(v98.DeepWoundsDebuff) <= v14:GCD()) or (v98.Dreadnaught:IsAvailable() and v98.Battlelord:IsAvailable() and (v106 <= (2 - 0)));
	end
	local function v110(v127)
		return v14:BuffUp(v98.SuddenDeathBuff) or ((v106 <= (2 + 0)) and ((v127:HealthPercentage() < (15 + 5)) or (v98.Massacre:IsAvailable() and (v127:HealthPercentage() < (46 - 11))))) or v14:BuffUp(v98.SweepingStrikes);
	end
	local function v111()
		local v128 = 0 + 0;
		while true do
			if (((7399 - 3688) > (6585 - 3230)) and (v128 == (1882 - (446 + 1434)))) then
				if ((v98.Intervene:IsCastable() and v68 and (v17:HealthPercentage() <= v78) and (v17:Name() ~= v14:Name())) or ((2189 - (1040 + 243)) >= (6652 - 4423))) then
					if (((3135 - (559 + 1288)) > (3182 - (609 + 1322))) and v24(v100.InterveneFocus)) then
						return "intervene defensive";
					end
				end
				if ((v98.DefensiveStance:IsCastable() and v14:BuffDown(v98.DefensiveStance, true) and v69 and (v14:HealthPercentage() <= v79)) or ((4967 - (13 + 441)) < (12525 - 9173))) then
					if (v24(v98.DefensiveStance) or ((5408 - 3343) >= (15917 - 12721))) then
						return "defensive_stance defensive";
					end
				end
				v128 = 1 + 2;
			end
			if ((v128 == (3 - 2)) or ((1555 + 2821) <= (649 + 832))) then
				if ((v98.IgnorePain:IsCastable() and v66 and (v14:HealthPercentage() <= v75)) or ((10065 - 6673) >= (2595 + 2146))) then
					if (((6115 - 2790) >= (1425 + 729)) and v24(v98.IgnorePain, nil, nil, true)) then
						return "ignore_pain defensive";
					end
				end
				if ((v98.RallyingCry:IsCastable() and v67 and v14:BuffDown(v98.AspectsFavorBuff) and v14:BuffDown(v98.RallyingCry) and (((v14:HealthPercentage() <= v76) and v94.IsSoloMode()) or v94.AreUnitsBelowHealthPercentage(v76, v77, v98.Intervene))) or ((721 + 574) >= (2323 + 910))) then
					if (((3676 + 701) > (1607 + 35)) and v24(v98.RallyingCry)) then
						return "rallying_cry defensive";
					end
				end
				v128 = 435 - (153 + 280);
			end
			if (((13638 - 8915) > (1218 + 138)) and ((2 + 1) == v128)) then
				if ((v98.BattleStance:IsCastable() and v14:BuffDown(v98.BattleStance, true) and v69 and (v14:HealthPercentage() > v82)) or ((2165 + 1971) <= (3116 + 317))) then
					if (((3076 + 1169) <= (7051 - 2420)) and v24(v98.BattleStance)) then
						return "battle_stance after defensive stance defensive";
					end
				end
				if (((2643 + 1633) >= (4581 - (89 + 578))) and v99.Healthstone:IsReady() and v70 and (v14:HealthPercentage() <= v80)) then
					if (((142 + 56) <= (9074 - 4709)) and v24(v100.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				v128 = 1053 - (572 + 477);
			end
			if (((645 + 4137) > (2807 + 1869)) and (v128 == (0 + 0))) then
				if (((4950 - (84 + 2)) > (3620 - 1423)) and v98.BitterImmunity:IsReady() and v64 and (v14:HealthPercentage() <= v73)) then
					if (v24(v98.BitterImmunity) or ((2666 + 1034) == (3349 - (497 + 345)))) then
						return "bitter_immunity defensive";
					end
				end
				if (((115 + 4359) >= (47 + 227)) and v98.DieByTheSword:IsCastable() and v65 and (v14:HealthPercentage() <= v74)) then
					if (v24(v98.DieByTheSword) or ((3227 - (605 + 728)) <= (1004 + 402))) then
						return "die_by_the_sword defensive";
					end
				end
				v128 = 1 - 0;
			end
			if (((73 + 1499) >= (5660 - 4129)) and (v128 == (4 + 0))) then
				if ((v71 and (v14:HealthPercentage() <= v81)) or ((12985 - 8298) < (3430 + 1112))) then
					if (((3780 - (457 + 32)) > (708 + 959)) and (v87 == "Refreshing Healing Potion")) then
						if (v99.RefreshingHealingPotion:IsReady() or ((2275 - (832 + 570)) == (1917 + 117))) then
							if (v24(v100.RefreshingHealingPotion) or ((735 + 2081) < (38 - 27))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((1782 + 1917) < (5502 - (588 + 208))) and (v87 == "Dreamwalker's Healing Potion")) then
						if (((7131 - 4485) >= (2676 - (884 + 916))) and v99.DreamwalkersHealingPotion:IsReady()) then
							if (((1285 - 671) <= (1847 + 1337)) and v24(v100.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v112()
		local v129 = 653 - (232 + 421);
		while true do
			if (((5015 - (1569 + 320)) == (767 + 2359)) and (v129 == (0 + 0))) then
				v27 = v94.HandleTopTrinket(v101, v30, 134 - 94, nil);
				if (v27 or ((2792 - (316 + 289)) >= (12967 - 8013))) then
					return v27;
				end
				v129 = 1 + 0;
			end
			if ((v129 == (1454 - (666 + 787))) or ((4302 - (360 + 65)) == (3342 + 233))) then
				v27 = v94.HandleBottomTrinket(v101, v30, 294 - (79 + 175), nil);
				if (((1114 - 407) > (494 + 138)) and v27) then
					return v27;
				end
				break;
			end
		end
	end
	local function v113()
		if (v102 or ((1673 - 1127) >= (5168 - 2484))) then
			local v149 = 899 - (503 + 396);
			while true do
				if (((1646 - (92 + 89)) <= (8343 - 4042)) and ((0 + 0) == v149)) then
					if (((1009 + 695) > (5580 - 4155)) and v98.Skullsplitter:IsCastable() and v45) then
						if (v24(v98.Skullsplitter) or ((94 + 593) == (9653 - 5419))) then
							return "skullsplitter precombat";
						end
					end
					if (((v91 < v104) and v98.ColossusSmash:IsCastable() and v37 and ((v55 and v30) or not v55)) or ((2906 + 424) < (683 + 746))) then
						if (((3493 - 2346) >= (42 + 293)) and v24(v98.ColossusSmash)) then
							return "colossus_smash precombat";
						end
					end
					v149 = 1 - 0;
				end
				if (((4679 - (485 + 759)) > (4852 - 2755)) and (v149 == (1190 - (442 + 747)))) then
					if (((v91 < v104) and v98.Warbreaker:IsCastable() and v50 and ((v58 and v30) or not v58)) or ((4905 - (832 + 303)) >= (4987 - (88 + 858)))) then
						if (v24(v98.Warbreaker) or ((1156 + 2635) <= (1334 + 277))) then
							return "warbreaker precombat";
						end
					end
					if ((v98.Overpower:IsCastable() and v41) or ((189 + 4389) <= (2797 - (766 + 23)))) then
						if (((5553 - 4428) <= (2838 - 762)) and v24(v98.Overpower)) then
							return "overpower precombat";
						end
					end
					break;
				end
			end
		end
		if ((v35 and v98.Charge:IsCastable()) or ((1957 - 1214) >= (14930 - 10531))) then
			if (((2228 - (1036 + 37)) < (1187 + 486)) and v24(v98.Charge)) then
				return "charge precombat";
			end
		end
	end
	local function v114()
		if ((v98.Execute:IsReady() and v38 and v14:BuffUp(v98.JuggernautBuff) and (v14:BuffRemains(v98.JuggernautBuff) < v14:GCD())) or ((4525 - 2201) <= (455 + 123))) then
			if (((5247 - (641 + 839)) == (4680 - (910 + 3))) and v24(v98.Execute, not v102)) then
				return "execute hac 67";
			end
		end
		if (((10423 - 6334) == (5773 - (1466 + 218))) and v98.ThunderClap:IsReady() and v48 and (v106 > (1 + 1)) and v98.BloodandThunder:IsAvailable() and v98.Rend:IsAvailable() and v15:DebuffRefreshable(v98.RendDebuff)) then
			if (((5606 - (556 + 592)) >= (596 + 1078)) and v24(v98.ThunderClap, not v102)) then
				return "thunder_clap hac 68";
			end
		end
		if (((1780 - (329 + 479)) <= (2272 - (174 + 680))) and v98.SweepingStrikes:IsCastable() and v47 and (v106 >= (6 - 4)) and ((v98.Bladestorm:CooldownRemains() > (30 - 15)) or not v98.Bladestorm:IsAvailable())) then
			if (v24(v98.SweepingStrikes, not v15:IsInMeleeRange(6 + 2)) or ((5677 - (396 + 343)) < (422 + 4340))) then
				return "sweeping_strikes hac 68";
			end
		end
		if ((v98.Rend:IsReady() and v42 and (v106 == (1478 - (29 + 1448))) and ((v15:HealthPercentage() > (1409 - (135 + 1254))) or (v98.Massacre:IsAvailable() and (v15:HealthPercentage() < (131 - 96))))) or (v98.TideofBlood:IsAvailable() and (v98.Skullsplitter:CooldownRemains() <= v14:GCD()) and ((v98.ColossusSmash:CooldownRemains() < v14:GCD()) or v15:DebuffUp(v98.ColossusSmashDebuff)) and (v15:DebuffRemains(v98.RendDebuff) < ((98 - 77) * (0.85 + 0)))) or ((4031 - (389 + 1138)) > (4838 - (102 + 472)))) then
			if (((2032 + 121) == (1194 + 959)) and v24(v98.Rend, not v102)) then
				return "rend hac 70";
			end
		end
		if (((v91 < v104) and v32 and ((v53 and v30) or not v53) and v98.Avatar:IsCastable()) or ((473 + 34) >= (4136 - (320 + 1225)))) then
			if (((7976 - 3495) == (2742 + 1739)) and v24(v98.Avatar, not v102)) then
				return "avatar hac 71";
			end
		end
		if (((v91 < v104) and v98.Warbreaker:IsCastable() and v50 and ((v58 and v30) or not v58) and (v106 > (1465 - (157 + 1307)))) or ((4187 - (821 + 1038)) < (1728 - 1035))) then
			if (((474 + 3854) == (7687 - 3359)) and v24(v98.Warbreaker, not v102)) then
				return "warbreaker hac 72";
			end
		end
		if (((591 + 997) >= (3301 - 1969)) and (v91 < v104) and v37 and ((v55 and v30) or not v55) and v98.ColossusSmash:IsCastable()) then
			local v150 = 1026 - (834 + 192);
			while true do
				if ((v150 == (0 + 0)) or ((1072 + 3102) > (92 + 4156))) then
					if (v94.CastCycle(v98.ColossusSmash, v105, v108, not v102) or ((7104 - 2518) <= (386 - (300 + 4)))) then
						return "colossus_smash hac 73";
					end
					if (((1032 + 2831) == (10112 - 6249)) and v24(v98.ColossusSmash, not v102)) then
						return "colossus_smash hac 73";
					end
					break;
				end
			end
		end
		if (((v91 < v104) and v37 and ((v55 and v30) or not v55) and v98.ColossusSmash:IsCastable()) or ((644 - (112 + 250)) <= (17 + 25))) then
			if (((11546 - 6937) >= (439 + 327)) and v24(v98.ColossusSmash, not v102)) then
				return "colossus_smash hac 74";
			end
		end
		if (((v91 < v104) and v49 and ((v57 and v30) or not v57) and v98.ThunderousRoar:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)) or ((v106 > (1 + 0)) and (v15:DebuffRemains(v98.DeepWoundsDebuff) > (0 + 0))))) or ((572 + 580) == (1849 + 639))) then
			if (((4836 - (1001 + 413)) > (7470 - 4120)) and v24(v98.ThunderousRoar, not v15:IsInMeleeRange(890 - (244 + 638)))) then
				return "thunderous_roar hac 75";
			end
		end
		if (((1570 - (627 + 66)) > (1120 - 744)) and (v91 < v104) and v84 and ((v56 and v30) or not v56) and (v85 == "player") and v98.ChampionsSpear:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) then
			if (v24(v100.ChampionsSpearPlayer, not v15:IsSpellInRange(v98.ChampionsSpear)) or ((3720 - (512 + 90)) <= (3757 - (1665 + 241)))) then
				return "spear_of_bastion hac 76";
			end
		end
		if (((v91 < v104) and v84 and ((v56 and v30) or not v56) and (v85 == "cursor") and v98.ChampionsSpear:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) or ((882 - (373 + 344)) >= (1575 + 1917))) then
			if (((1045 + 2904) < (12808 - 7952)) and v24(v100.ChampionsSpearCursor, not v15:IsSpellInRange(v98.ChampionsSpear))) then
				return "spear_of_bastion hac 76";
			end
		end
		if (((v91 < v104) and v34 and ((v54 and v30) or not v54) and v98.Bladestorm:IsCastable() and v98.Unhinged:IsAvailable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) or ((7235 - 2959) < (4115 - (35 + 1064)))) then
			if (((3413 + 1277) > (8825 - 4700)) and v24(v98.Bladestorm, not v102)) then
				return "bladestorm hac 77";
			end
		end
		if (((v91 < v104) and v34 and ((v54 and v30) or not v54) and v98.Bladestorm:IsCastable() and (((v106 > (1 + 0)) and (v14:BuffUp(v98.TestofMightBuff) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) or ((v106 > (1237 - (298 + 938))) and (v15:DebuffRemains(v98.DeepWoundsDebuff) > (1259 - (233 + 1026)))))) or ((1716 - (636 + 1030)) >= (459 + 437))) then
			if (v24(v98.Bladestorm, not v102) or ((1675 + 39) >= (879 + 2079))) then
				return "bladestorm hac 78";
			end
		end
		if ((v98.Cleave:IsReady() and v36 and ((v106 > (1 + 1)) or (not v98.Battlelord:IsAvailable() and v14:BuffUp(v98.MercilessBonegrinderBuff) and (v98.MortalStrike:CooldownRemains() > v14:GCD())))) or ((1712 - (55 + 166)) < (125 + 519))) then
			if (((71 + 633) < (3769 - 2782)) and v24(v98.Cleave, not v102)) then
				return "cleave hac 79";
			end
		end
		if (((4015 - (36 + 261)) > (3332 - 1426)) and v98.Whirlwind:IsReady() and v51 and ((v106 > (1370 - (34 + 1334))) or (v98.StormofSwords:IsAvailable() and (v14:BuffUp(v98.MercilessBonegrinderBuff) or v14:BuffUp(v98.HurricaneBuff))))) then
			if (v24(v98.Whirlwind, not v15:IsInMeleeRange(4 + 4)) or ((745 + 213) > (4918 - (1035 + 248)))) then
				return "whirlwind hac 80";
			end
		end
		if (((3522 - (20 + 1)) <= (2341 + 2151)) and v98.Skullsplitter:IsCastable() and v45 and ((v14:Rage() < (359 - (134 + 185))) or (v98.TideofBlood:IsAvailable() and (v15:DebuffRemains(v98.RendDebuff) > (1133 - (549 + 584))) and ((v14:BuffUp(v98.SweepingStrikes) and (v106 > (687 - (314 + 371)))) or v15:DebuffUp(v98.ColossusSmashDebuff) or v14:BuffUp(v98.TestofMightBuff))))) then
			if (v24(v98.Skullsplitter, not v15:IsInMeleeRange(27 - 19)) or ((4410 - (478 + 490)) < (1350 + 1198))) then
				return "sweeping_strikes execute 81";
			end
		end
		if (((4047 - (786 + 386)) >= (4741 - 3277)) and v98.MortalStrike:IsReady() and v40 and v14:BuffUp(v98.SweepingStrikes) and (v14:BuffStack(v98.CrushingAdvanceBuff) == (1382 - (1055 + 324)))) then
			if (v24(v98.MortalStrike, not v102) or ((6137 - (1093 + 247)) >= (4349 + 544))) then
				return "mortal_strike hac 81.5";
			end
		end
		if ((v98.Overpower:IsCastable() and v41 and v14:BuffUp(v98.SweepingStrikes) and v98.Dreadnaught:IsAvailable()) or ((58 + 493) > (8210 - 6142))) then
			if (((7174 - 5060) > (2685 - 1741)) and v24(v98.Overpower, not v102)) then
				return "overpower hac 82";
			end
		end
		if ((v98.MortalStrike:IsReady() and v40) or ((5684 - 3422) >= (1102 + 1994))) then
			if (v94.CastCycle(v98.MortalStrike, v105, v109, not v102) or ((8687 - 6432) >= (12191 - 8654))) then
				return "mortal_strike hac 83";
			end
			if (v24(v98.MortalStrike, not v102) or ((2894 + 943) < (3339 - 2033))) then
				return "mortal_strike hac 83";
			end
		end
		if (((3638 - (364 + 324)) == (8087 - 5137)) and v98.Execute:IsReady() and v38 and (v14:BuffUp(v98.SuddenDeathBuff) or ((v106 <= (4 - 2)) and ((v15:HealthPercentage() < (7 + 13)) or (v98.Massacre:IsAvailable() and (v15:HealthPercentage() < (146 - 111))))) or v14:BuffUp(v98.SweepingStrikes))) then
			if (v94.CastCycle(v98.Execute, v105, v110, not v102) or ((7563 - 2840) < (10016 - 6718))) then
				return "execute hac 84";
			end
			if (((2404 - (1249 + 19)) >= (140 + 14)) and v24(v98.Execute, not v102)) then
				return "execute hac 84";
			end
		end
		if (((v91 < v104) and v49 and ((v57 and v30) or not v57) and v98.ThunderousRoar:IsCastable()) or ((1054 - 783) > (5834 - (686 + 400)))) then
			if (((3720 + 1020) >= (3381 - (73 + 156))) and v24(v98.ThunderousRoar, not v15:IsInMeleeRange(1 + 7))) then
				return "thunderous_roar hac 85";
			end
		end
		if ((v98.Shockwave:IsCastable() and v44 and (v106 > (813 - (721 + 90))) and (v98.SonicBoom:IsAvailable() or v15:IsCasting())) or ((29 + 2549) >= (11006 - 7616))) then
			if (((511 - (224 + 246)) <= (2690 - 1029)) and v24(v98.Shockwave, not v15:IsInMeleeRange(14 - 6))) then
				return "shockwave hac 86";
			end
		end
		if (((110 + 491) < (85 + 3475)) and v98.Overpower:IsCastable() and v41 and (v106 == (1 + 0)) and (((v98.Overpower:Charges() == (3 - 1)) and not v98.Battlelord:IsAvailable() and (v15:Debuffdown(v98.ColossusSmashDebuff) or (v14:RagePercentage() < (83 - 58)))) or v98.Battlelord:IsAvailable())) then
			if (((748 - (203 + 310)) < (2680 - (1238 + 755))) and v24(v98.Overpower, not v102)) then
				return "overpower hac 87";
			end
		end
		if (((318 + 4231) > (2687 - (709 + 825))) and v98.Slam:IsReady() and v46 and (v106 == (1 - 0)) and not v98.Battlelord:IsAvailable() and (v14:RagePercentage() > (101 - 31))) then
			if (v24(v98.Slam, not v102) or ((5538 - (196 + 668)) < (18446 - 13774))) then
				return "slam hac 88";
			end
		end
		if (((7597 - 3929) < (5394 - (171 + 662))) and v98.Overpower:IsCastable() and v41 and (((v98.Overpower:Charges() == (95 - (4 + 89))) and (not v98.TestofMight:IsAvailable() or (v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)) or v98.Battlelord:IsAvailable())) or (v14:Rage() < (245 - 175)))) then
			if (v24(v98.Overpower, not v102) or ((166 + 289) == (15833 - 12228))) then
				return "overpower hac 89";
			end
		end
		if ((v98.ThunderClap:IsReady() and v48 and (v106 > (1 + 1))) or ((4149 - (35 + 1451)) == (4765 - (28 + 1425)))) then
			if (((6270 - (941 + 1052)) <= (4291 + 184)) and v24(v98.ThunderClap, not v102)) then
				return "thunder_clap hac 90";
			end
		end
		if ((v98.MortalStrike:IsReady() and v40) or ((2384 - (822 + 692)) == (1696 - 507))) then
			if (((732 + 821) <= (3430 - (45 + 252))) and v24(v98.MortalStrike, not v102)) then
				return "mortal_strike hac 91";
			end
		end
		if ((v98.Rend:IsReady() and v42 and (v106 == (1 + 0)) and v15:DebuffRefreshable(v98.RendDebuff)) or ((770 + 1467) >= (8544 - 5033))) then
			if (v24(v98.Rend, not v102) or ((1757 - (114 + 319)) > (4336 - 1316))) then
				return "rend hac 92";
			end
		end
		if ((v98.Whirlwind:IsReady() and v51 and (v98.StormofSwords:IsAvailable() or (v98.FervorofBattle:IsAvailable() and (v106 > (1 - 0))))) or ((1908 + 1084) == (2802 - 921))) then
			if (((6507 - 3401) > (3489 - (556 + 1407))) and v24(v98.Whirlwind, not v15:IsInMeleeRange(1214 - (741 + 465)))) then
				return "whirlwind hac 93";
			end
		end
		if (((3488 - (170 + 295)) < (2040 + 1830)) and v98.Cleave:IsReady() and v36 and not v98.CrushingForce:IsAvailable()) then
			if (((132 + 11) > (182 - 108)) and v24(v98.Cleave, not v102)) then
				return "cleave hac 94";
			end
		end
		if (((15 + 3) < (1355 + 757)) and v98.IgnorePain:IsReady() and v66 and v98.Battlelord:IsAvailable() and v98.AngerManagement:IsAvailable() and (v14:Rage() > (17 + 13)) and ((v15:HealthPercentage() < (1250 - (957 + 273))) or (v98.Massacre:IsAvailable() and (v15:HealthPercentage() < (10 + 25))))) then
			if (((440 + 657) <= (6203 - 4575)) and v24(v98.IgnorePain, not v102)) then
				return "ignore_pain hac 95";
			end
		end
		if (((12201 - 7571) == (14142 - 9512)) and v98.Slam:IsReady() and v46 and v98.CrushingForce:IsAvailable() and (v14:Rage() > (148 - 118)) and ((v98.FervorofBattle:IsAvailable() and (v106 == (1781 - (389 + 1391)))) or not v98.FervorofBattle:IsAvailable())) then
			if (((2221 + 1319) > (280 + 2403)) and v24(v98.Slam, not v102)) then
				return "slam hac 96";
			end
		end
		if (((10913 - 6119) >= (4226 - (783 + 168))) and v98.Shockwave:IsCastable() and v44 and (v98.SonicBoom:IsAvailable())) then
			if (((4980 - 3496) == (1460 + 24)) and v24(v98.Shockwave, not v15:IsInMeleeRange(319 - (309 + 2)))) then
				return "shockwave hac 97";
			end
		end
		if (((4397 - 2965) < (4767 - (1090 + 122))) and v30 and (v91 < v104) and v34 and ((v54 and v30) or not v54) and v98.Bladestorm:IsCastable()) then
			if (v24(v98.Bladestorm, not v102) or ((346 + 719) > (12016 - 8438))) then
				return "bladestorm hac 98";
			end
		end
	end
	local function v115()
		if (((v91 < v104) and v47 and v98.SweepingStrikes:IsCastable() and (v106 > (1 + 0))) or ((5913 - (628 + 490)) < (253 + 1154))) then
			if (((4587 - 2734) < (21995 - 17182)) and v24(v98.SweepingStrikes, not v15:IsInMeleeRange(782 - (431 + 343)))) then
				return "sweeping_strikes execute 51";
			end
		end
		if ((v98.Rend:IsReady() and v42 and (v15:DebuffRemains(v98.RendDebuff) <= v14:GCD()) and not v98.Bloodletting:IsAvailable() and ((not v98.Warbreaker:IsAvailable() and (v98.ColossusSmash:CooldownRemains() < (7 - 3))) or (v98.Warbreaker:IsAvailable() and (v98.Warbreaker:CooldownRemains() < (11 - 7)))) and (v15:TimeToDie() > (10 + 2))) or ((361 + 2460) < (4126 - (556 + 1139)))) then
			if (v24(v98.Rend, not v102) or ((2889 - (6 + 9)) < (400 + 1781))) then
				return "rend execute 52";
			end
		end
		if (((v91 < v104) and v32 and ((v53 and v30) or not v53) and v98.Avatar:IsCastable() and (v98.ColossusSmash:CooldownUp() or v15:DebuffUp(v98.ColossusSmashDebuff) or (v104 < (11 + 9)))) or ((2858 - (28 + 141)) <= (133 + 210))) then
			if (v24(v98.Avatar, not v102) or ((2306 - 437) == (1423 + 586))) then
				return "avatar execute 53";
			end
		end
		if (((v91 < v104) and v50 and ((v58 and v30) or not v58) and v98.Warbreaker:IsCastable()) or ((4863 - (486 + 831)) < (6042 - 3720))) then
			if (v24(v98.Warbreaker, not v102) or ((7329 - 5247) == (902 + 3871))) then
				return "warbreaker execute 54";
			end
		end
		if (((10257 - 7013) > (2318 - (668 + 595))) and (v91 < v104) and v37 and ((v55 and v30) or not v55) and v98.ColossusSmash:IsCastable()) then
			if (v24(v98.ColossusSmash, not v102) or ((2982 + 331) <= (359 + 1419))) then
				return "colossus_smash execute 55";
			end
		end
		if ((v98.Execute:IsReady() and v38 and v14:BuffUp(v98.SuddenDeathBuff) and (v15:DebuffRemains(v98.DeepWoundsDebuff) > (0 - 0))) or ((1711 - (23 + 267)) >= (4048 - (1129 + 815)))) then
			if (((2199 - (371 + 16)) <= (4999 - (1326 + 424))) and v24(v98.Execute, not v102)) then
				return "execute execute 56";
			end
		end
		if (((3073 - 1450) <= (7151 - 5194)) and v98.Skullsplitter:IsCastable() and v45 and ((v98.TestofMight:IsAvailable() and (v14:RagePercentage() <= (148 - (88 + 30)))) or (not v98.TestofMight:IsAvailable() and (v15:DebuffUp(v98.ColossusSmashDebuff) or (v98.ColossusSmash:CooldownRemains() > (776 - (720 + 51)))) and (v14:RagePercentage() <= (66 - 36))))) then
			if (((6188 - (421 + 1355)) == (7277 - 2865)) and v24(v98.Skullsplitter, not v15:IsInMeleeRange(4 + 4))) then
				return "skullsplitter execute 57";
			end
		end
		if (((2833 - (286 + 797)) >= (3077 - 2235)) and (v91 < v104) and v49 and ((v57 and v30) or not v57) and v98.ThunderousRoar:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) then
			if (((7241 - 2869) > (2289 - (397 + 42))) and v24(v98.ThunderousRoar, not v15:IsInMeleeRange(3 + 5))) then
				return "thunderous_roar execute 57";
			end
		end
		if (((1032 - (24 + 776)) < (1264 - 443)) and (v91 < v104) and v84 and ((v56 and v30) or not v56) and (v85 == "player") and v98.ChampionsSpear:IsCastable() and (v15:DebuffUp(v98.ColossusSmashDebuff) or v14:BuffUp(v98.TestofMightBuff))) then
			if (((1303 - (222 + 563)) < (1986 - 1084)) and v24(v100.ChampionsSpearPlayer, not v15:IsSpellInRange(v98.ChampionsSpear))) then
				return "spear_of_bastion execute 57";
			end
		end
		if (((2156 + 838) > (1048 - (23 + 167))) and (v91 < v104) and v84 and ((v56 and v30) or not v56) and (v85 == "cursor") and v98.ChampionsSpear:IsCastable() and (v15:DebuffUp(v98.ColossusSmashDebuff) or v14:BuffUp(v98.TestofMightBuff))) then
			if (v24(v100.ChampionsSpearCursor, not v15:IsSpellInRange(v98.ChampionsSpear)) or ((5553 - (690 + 1108)) <= (331 + 584))) then
				return "spear_of_bastion execute 57";
			end
		end
		if (((3255 + 691) > (4591 - (40 + 808))) and v98.Cleave:IsReady() and v36 and (v106 > (1 + 1)) and (v15:DebuffRemains(v98.DeepWoundsDebuff) < v14:GCD())) then
			if (v24(v98.Cleave, not v102) or ((5105 - 3770) >= (3160 + 146))) then
				return "cleave execute 58";
			end
		end
		if (((2563 + 2281) > (1236 + 1017)) and v98.MortalStrike:IsReady() and v40 and ((v15:DebuffStack(v98.ExecutionersPrecisionDebuff) == (573 - (47 + 524))) or (v15:DebuffRemains(v98.DeepWoundsDebuff) <= v14:GCD()))) then
			if (((294 + 158) == (1235 - 783)) and v24(v98.MortalStrike, not v102)) then
				return "mortal_strike execute 59";
			end
		end
		if ((v98.Overpower:IsCastable() and v41 and (v14:Rage() < (59 - 19)) and (v14:BuffStack(v98.MartialProwessBuff) < (4 - 2))) or ((6283 - (1165 + 561)) < (62 + 2025))) then
			if (((11998 - 8124) == (1479 + 2395)) and v24(v98.Overpower, not v102)) then
				return "overpower execute 60";
			end
		end
		if ((v98.Execute:IsReady() and v38) or ((2417 - (341 + 138)) > (1333 + 3602))) then
			if (v24(v98.Execute, not v102) or ((8781 - 4526) < (3749 - (89 + 237)))) then
				return "execute execute 62";
			end
		end
		if (((4677 - 3223) <= (5244 - 2753)) and v98.Shockwave:IsCastable() and v44 and (v98.SonicBoom:IsAvailable() or v15:IsCasting())) then
			if (v24(v98.Shockwave, not v15:IsInMeleeRange(889 - (581 + 300))) or ((5377 - (855 + 365)) <= (6657 - 3854))) then
				return "shockwave execute 63";
			end
		end
		if (((1585 + 3268) >= (4217 - (1030 + 205))) and v98.Overpower:IsCastable() and v41) then
			if (((3882 + 252) > (3123 + 234)) and v24(v98.Overpower, not v102)) then
				return "overpower execute 64";
			end
		end
		if (((v91 < v104) and v34 and ((v54 and v30) or not v54) and v98.Bladestorm:IsCastable()) or ((3703 - (156 + 130)) < (5757 - 3223))) then
			if (v24(v98.Bladestorm, not v102) or ((4586 - 1864) <= (335 - 171))) then
				return "bladestorm execute 65";
			end
		end
	end
	local function v116()
		local v130 = 0 + 0;
		while true do
			if ((v130 == (0 + 0)) or ((2477 - (10 + 59)) < (597 + 1512))) then
				if (((v91 < v104) and v47 and v98.SweepingStrikes:IsCastable() and (v106 > (4 - 3))) or ((1196 - (671 + 492)) == (1159 + 296))) then
					if (v24(v98.SweepingStrikes, not v15:IsInMeleeRange(1223 - (369 + 846))) or ((118 + 325) >= (3427 + 588))) then
						return "sweeping_strikes single_target 97";
					end
				end
				if (((5327 - (1036 + 909)) > (132 + 34)) and v98.Execute:IsReady() and (v14:BuffUp(v98.SuddenDeathBuff))) then
					if (v24(v98.Execute, not v102) or ((470 - 190) == (3262 - (11 + 192)))) then
						return "execute single_target 98";
					end
				end
				if (((951 + 930) > (1468 - (135 + 40))) and v98.MortalStrike:IsReady() and v40) then
					if (((5710 - 3353) == (1421 + 936)) and v24(v98.MortalStrike, not v102)) then
						return "mortal_strike single_target 99";
					end
				end
				if (((270 - 147) == (184 - 61)) and v98.Rend:IsReady() and v42 and ((v15:DebuffRemains(v98.RendDebuff) <= v14:GCD()) or (v98.TideofBlood:IsAvailable() and (v98.Skullsplitter:CooldownRemains() <= v14:GCD()) and ((v98.ColossusSmash:CooldownRemains() <= v14:GCD()) or v15:DebuffUp(v98.ColossusSmashDebuff)) and (v15:DebuffRemains(v98.RendDebuff) < (v98.RendDebuff:BaseDuration() * (176.85 - (50 + 126))))))) then
					if (v24(v98.Rend, not v102) or ((2940 - 1884) >= (751 + 2641))) then
						return "rend single_target 100";
					end
				end
				v130 = 1414 - (1233 + 180);
			end
			if ((v130 == (975 - (522 + 447))) or ((2502 - (107 + 1314)) < (499 + 576))) then
				if ((v98.Cleave:IsReady() and v36 and v14:HasTier(87 - 58, 1 + 1) and not v98.CrushingForce:IsAvailable()) or ((2082 - 1033) >= (17535 - 13103))) then
					if (v24(v98.Cleave, not v102) or ((6678 - (716 + 1194)) <= (15 + 831))) then
						return "cleave single_target 121";
					end
				end
				if (((v91 < v104) and v34 and ((v54 and v30) or not v54) and v98.Bladestorm:IsCastable()) or ((360 + 2998) <= (1923 - (74 + 429)))) then
					if (v24(v98.Bladestorm, not v102) or ((7212 - 3473) <= (1490 + 1515))) then
						return "bladestorm single_target 122";
					end
				end
				if ((v98.Cleave:IsReady() and v36) or ((3797 - 2138) >= (1510 + 624))) then
					if (v24(v98.Cleave, not v102) or ((10050 - 6790) < (5822 - 3467))) then
						return "cleave single_target 123";
					end
				end
				if ((v98.Rend:IsReady() and v42 and v15:DebuffRefreshable(v98.RendDebuff) and not v98.CrushingForce:IsAvailable()) or ((1102 - (279 + 154)) == (5001 - (454 + 324)))) then
					if (v24(v98.Rend, not v102) or ((1332 + 360) < (605 - (12 + 5)))) then
						return "rend single_target 124";
					end
				end
				break;
			end
			if (((3 + 1) == v130) or ((12222 - 7425) < (1350 + 2301))) then
				if ((v98.Whirlwind:IsReady() and v51 and v98.StormofSwords:IsAvailable() and v98.TestofMight:IsAvailable() and (v98.ColossusSmash:CooldownRemains() > (v14:GCD() * (1100 - (277 + 816))))) or ((17848 - 13671) > (6033 - (1058 + 125)))) then
					if (v24(v98.Whirlwind, not v15:IsInMeleeRange(2 + 6)) or ((1375 - (815 + 160)) > (4766 - 3655))) then
						return "whirlwind single_target 113";
					end
				end
				if (((7242 - 4191) > (240 + 765)) and v98.Overpower:IsCastable() and v41 and (((v98.Overpower:Charges() == (5 - 3)) and not v98.Battlelord:IsAvailable() and (v15:DebuffUp(v98.ColossusSmashDebuff) or (v14:RagePercentage() < (1923 - (41 + 1857))))) or v98.Battlelord:IsAvailable())) then
					if (((5586 - (1222 + 671)) <= (11325 - 6943)) and v24(v98.Overpower, not v102)) then
						return "overpower single_target 114";
					end
				end
				if ((v98.Slam:IsReady() and v46 and ((v98.CrushingForce:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff) and (v14:Rage() >= (86 - 26)) and v98.TestofMight:IsAvailable()) or v98.ImprovedSlam:IsAvailable()) and (not v98.FervorofBattle:IsAvailable() or (v98.FervorofBattle:IsAvailable() and (v106 == (1183 - (229 + 953)))))) or ((5056 - (1111 + 663)) > (5679 - (874 + 705)))) then
					if (v24(v98.Slam, not v102) or ((502 + 3078) < (1941 + 903))) then
						return "slam single_target 115";
					end
				end
				if (((184 - 95) < (127 + 4363)) and v98.Whirlwind:IsReady() and v51 and (v98.StormofSwords:IsAvailable() or (v98.FervorofBattle:IsAvailable() and (v106 > (680 - (642 + 37)))))) then
					if (v24(v98.Whirlwind, not v15:IsInMeleeRange(2 + 6)) or ((798 + 4185) < (4539 - 2731))) then
						return "whirlwind single_target 116";
					end
				end
				v130 = 459 - (233 + 221);
			end
			if (((8853 - 5024) > (3318 + 451)) and (v130 == (1544 - (718 + 823)))) then
				if (((935 + 550) <= (3709 - (266 + 539))) and v98.Whirlwind:IsReady() and v51 and v98.StormofSwords:IsAvailable() and v98.TestofMight:IsAvailable() and (v14:RagePercentage() > (226 - 146)) and v15:DebuffUp(v98.ColossusSmashDebuff)) then
					if (((5494 - (636 + 589)) == (10133 - 5864)) and v24(v98.Whirlwind, not v15:IsInMeleeRange(16 - 8))) then
						return "whirlwind single_target 108";
					end
				end
				if (((307 + 80) <= (1011 + 1771)) and v98.ThunderClap:IsReady() and v48 and (v15:DebuffRemains(v98.RendDebuff) <= v14:GCD()) and not v98.TideofBlood:IsAvailable()) then
					if (v24(v98.ThunderClap, not v102) or ((2914 - (657 + 358)) <= (2427 - 1510))) then
						return "thunder_clap single_target 109";
					end
				end
				if (((v91 < v104) and v34 and ((v54 and v30) or not v54) and v98.Bladestorm:IsCastable() and ((v98.Hurricane:IsAvailable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) or (v98.Unhinged:IsAvailable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))))) or ((9823 - 5511) <= (2063 - (1151 + 36)))) then
					if (((2156 + 76) <= (683 + 1913)) and v24(v98.Bladestorm, not v102)) then
						return "bladestorm single_target 110";
					end
				end
				if (((6256 - 4161) < (5518 - (1552 + 280))) and v98.Shockwave:IsCastable() and v44 and (v98.SonicBoom:IsAvailable() or v15:IsCasting())) then
					if (v24(v98.Shockwave, not v15:IsInMeleeRange(842 - (64 + 770))) or ((1083 + 512) >= (10156 - 5682))) then
						return "shockwave single_target 111";
					end
				end
				v130 = 1 + 3;
			end
			if ((v130 == (1245 - (157 + 1086))) or ((9244 - 4625) < (12622 - 9740))) then
				if (((v91 < v104) and v37 and ((v55 and v30) or not v55) and v98.ColossusSmash:IsCastable()) or ((450 - 156) >= (6593 - 1762))) then
					if (((2848 - (599 + 220)) <= (6141 - 3057)) and v24(v98.ColossusSmash, not v102)) then
						return "colossus_smash single_target 104";
					end
				end
				if ((v98.Skullsplitter:IsCastable() and v45 and not v98.TestofMight:IsAvailable() and (v15:DebuffRemains(v98.DeepWoundsDebuff) > (1931 - (1813 + 118))) and (v15:DebuffUp(v98.ColossusSmashDebuff) or (v98.ColossusSmash:CooldownRemains() > (3 + 0)))) or ((3254 - (841 + 376)) == (3391 - 971))) then
					if (((1036 + 3422) > (10655 - 6751)) and v24(v98.Skullsplitter, not v102)) then
						return "skullsplitter single_target 105";
					end
				end
				if (((1295 - (464 + 395)) >= (315 - 192)) and v98.Skullsplitter:IsCastable() and v45 and v98.TestofMight:IsAvailable() and (v15:DebuffRemains(v98.DeepWoundsDebuff) > (0 + 0))) then
					if (((1337 - (467 + 370)) < (3752 - 1936)) and v24(v98.Skullsplitter, not v102)) then
						return "skullsplitter single_target 106";
					end
				end
				if (((2624 + 950) == (12251 - 8677)) and (v91 < v104) and v49 and ((v57 and v30) or not v57) and v98.ThunderousRoar:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff) and (v14:RagePercentage() < (6 + 27))) or (not v98.TestofMight:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) then
					if (((514 - 293) < (910 - (150 + 370))) and v24(v98.ThunderousRoar, not v15:IsInMeleeRange(1290 - (74 + 1208)))) then
						return "thunderous_roar single_target 107";
					end
				end
				v130 = 7 - 4;
			end
			if ((v130 == (4 - 3)) or ((1575 + 638) <= (1811 - (14 + 376)))) then
				if (((5303 - 2245) < (3145 + 1715)) and (v91 < v104) and v32 and ((v53 and v30) or not v53) and v98.Avatar:IsCastable() and ((v98.WarlordsTorment:IsAvailable() and (v14:RagePercentage() < (29 + 4)) and (v98.ColossusSmash:CooldownUp() or v15:DebuffUp(v98.ColossusSmashDebuff) or v14:BuffUp(v98.TestofMightBuff))) or (not v98.WarlordsTorment:IsAvailable() and (v98.ColossusSmash:CooldownUp() or v15:DebuffUp(v98.ColossusSmashDebuff))))) then
					if (v24(v98.Avatar, not v102) or ((1237 + 59) >= (13027 - 8581))) then
						return "avatar single_target 101";
					end
				end
				if (((v91 < v104) and v84 and ((v56 and v30) or not v56) and (v85 == "player") and v98.ChampionsSpear:IsCastable() and ((v98.ColossusSmash:CooldownRemains() <= v14:GCD()) or (v98.Warbreaker:CooldownRemains() <= v14:GCD()))) or ((1048 + 345) > (4567 - (23 + 55)))) then
					if (v24(v100.ChampionsSpearPlayer, not v15:IsSpellInRange(v98.ChampionsSpear)) or ((10484 - 6060) < (19 + 8))) then
						return "spear_of_bastion single_target 102";
					end
				end
				if (((v91 < v104) and v84 and ((v56 and v30) or not v56) and (v85 == "cursor") and v98.ChampionsSpear:IsCastable() and ((v98.ColossusSmash:CooldownRemains() <= v14:GCD()) or (v98.Warbreaker:CooldownRemains() <= v14:GCD()))) or ((1794 + 203) > (5915 - 2100))) then
					if (((1090 + 2375) > (2814 - (652 + 249))) and v24(v100.ChampionsSpearCursor, not v15:IsSpellInRange(v98.ChampionsSpear))) then
						return "spear_of_bastion single_target 102";
					end
				end
				if (((1961 - 1228) < (3687 - (708 + 1160))) and (v91 < v104) and v50 and ((v58 and v30) or not v58) and v98.Warbreaker:IsCastable()) then
					if (v24(v98.Warbreaker, not v15:IsInRange(21 - 13)) or ((8013 - 3618) == (4782 - (10 + 17)))) then
						return "warbreaker single_target 103";
					end
				end
				v130 = 1 + 1;
			end
			if ((v130 == (1737 - (1400 + 332))) or ((7275 - 3482) < (4277 - (242 + 1666)))) then
				if ((v98.Slam:IsReady() and v46 and (v98.CrushingForce:IsAvailable() or (not v98.CrushingForce:IsAvailable() and (v14:Rage() >= (13 + 17)))) and (not v98.FervorofBattle:IsAvailable() or (v98.FervorofBattle:IsAvailable() and (v106 == (1 + 0))))) or ((3481 + 603) == (1205 - (850 + 90)))) then
					if (((7632 - 3274) == (5748 - (360 + 1030))) and v24(v98.Slam, not v102)) then
						return "slam single_target 117";
					end
				end
				if ((v98.ThunderClap:IsReady() and v48 and v98.Battlelord:IsAvailable() and v98.BloodandThunder:IsAvailable()) or ((2778 + 360) < (2802 - 1809))) then
					if (((4581 - 1251) > (3984 - (909 + 752))) and v24(v98.ThunderClap, not v102)) then
						return "thunder_clap single_target 118";
					end
				end
				if ((v98.Overpower:IsCastable() and v41 and ((v15:DebuffDown(v98.ColossusSmashDebuff) and (v14:RagePercentage() < (1273 - (109 + 1114))) and not v98.Battlelord:IsAvailable()) or (v14:RagePercentage() < (45 - 20)))) or ((1412 + 2214) == (4231 - (6 + 236)))) then
					if (v24(v98.Overpower, not v102) or ((578 + 338) == (2150 + 521))) then
						return "overpower single_target 119";
					end
				end
				if (((640 - 368) == (474 - 202)) and v98.Whirlwind:IsReady() and v51 and v14:BuffUp(v98.MercilessBonegrinderBuff)) then
					if (((5382 - (1076 + 57)) <= (796 + 4043)) and v24(v98.Whirlwind, not v15:IsInRange(697 - (579 + 110)))) then
						return "whirlwind single_target 120";
					end
				end
				v130 = 1 + 5;
			end
		end
	end
	local function v117()
		local v131 = 0 + 0;
		while true do
			if (((1474 + 1303) < (3607 - (174 + 233))) and (v131 == (0 - 0))) then
				if (((166 - 71) < (871 + 1086)) and not v14:AffectingCombat()) then
					if (((2000 - (663 + 511)) < (1532 + 185)) and v98.BattleStance:IsCastable() and v14:BuffDown(v98.BattleStance, true)) then
						if (((310 + 1116) >= (3406 - 2301)) and v24(v98.BattleStance)) then
							return "battle_stance";
						end
					end
					if (((1668 + 1086) <= (7954 - 4575)) and v98.BattleShout:IsCastable() and v33 and (v14:BuffDown(v98.BattleShoutBuff, true) or v94.GroupBuffMissing(v98.BattleShoutBuff))) then
						if (v24(v98.BattleShout) or ((9506 - 5579) == (675 + 738))) then
							return "battle_shout precombat";
						end
					end
				end
				if ((v94.TargetIsValid() and v28) or ((2245 - 1091) <= (562 + 226))) then
					if (not v14:AffectingCombat() or ((151 + 1492) > (4101 - (478 + 244)))) then
						local v192 = 517 - (440 + 77);
						while true do
							if ((v192 == (0 + 0)) or ((10258 - 7455) > (6105 - (655 + 901)))) then
								v27 = v113();
								if (v27 or ((41 + 179) >= (2314 + 708))) then
									return v27;
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
		local v132 = 0 + 0;
		while true do
			if (((11368 - 8546) == (4267 - (695 + 750))) and (v132 == (3 - 2))) then
				if (v86 or ((1637 - 576) == (7468 - 5611))) then
					v27 = v94.HandleIncorporeal(v98.StormBolt, v100.StormBoltMouseover, 371 - (285 + 66), true);
					if (((6433 - 3673) > (2674 - (682 + 628))) and v27) then
						return v27;
					end
					v27 = v94.HandleIncorporeal(v98.IntimidatingShout, v100.IntimidatingShoutMouseover, 2 + 6, true);
					if (v27 or ((5201 - (176 + 123)) <= (1504 + 2091))) then
						return v27;
					end
				end
				if (v94.TargetIsValid() or ((2795 + 1057) == (562 - (239 + 30)))) then
					if ((v35 and v98.Charge:IsCastable() and not v102) or ((424 + 1135) == (4410 + 178))) then
						if (v24(v98.Charge, not v15:IsSpellInRange(v98.Charge)) or ((7936 - 3452) == (2458 - 1670))) then
							return "charge main 34";
						end
					end
					local v191 = v94.HandleDPSPotion(v15:DebuffUp(v98.ColossusSmashDebuff));
					if (((4883 - (306 + 9)) >= (13633 - 9726)) and v191) then
						return v191;
					end
					if (((217 + 1029) < (2130 + 1340)) and v102 and v92 and ((v60 and v30) or not v60) and (v91 < v104)) then
						if (((1959 + 2109) >= (2779 - 1807)) and v98.BloodFury:IsCastable() and v15:DebuffUp(v98.ColossusSmashDebuff)) then
							if (((1868 - (1140 + 235)) < (2478 + 1415)) and v24(v98.BloodFury)) then
								return "blood_fury main 39";
							end
						end
						if ((v98.Berserking:IsCastable() and (v15:DebuffRemains(v98.ColossusSmashDebuff) > (6 + 0))) or ((379 + 1094) >= (3384 - (33 + 19)))) then
							if (v24(v98.Berserking) or ((1463 + 2588) <= (3467 - 2310))) then
								return "berserking main 40";
							end
						end
						if (((267 + 337) < (5649 - 2768)) and v98.ArcaneTorrent:IsCastable() and (v98.MortalStrike:CooldownRemains() > (1.5 + 0)) and (v14:Rage() < (739 - (586 + 103)))) then
							if (v24(v98.ArcaneTorrent, not v15:IsInRange(1 + 7)) or ((2770 - 1870) == (4865 - (1309 + 179)))) then
								return "arcane_torrent main 41";
							end
						end
						if (((8049 - 3590) > (258 + 333)) and v98.LightsJudgment:IsCastable() and v15:DebuffDown(v98.ColossusSmashDebuff) and not v98.MortalStrike:CooldownUp()) then
							if (((9125 - 5727) >= (1810 + 585)) and v24(v98.LightsJudgment, not v15:IsSpellInRange(v98.LightsJudgment))) then
								return "lights_judgment main 42";
							end
						end
						if ((v98.Fireblood:IsCastable() and (v15:DebuffUp(v98.ColossusSmashDebuff))) or ((4637 - 2454) >= (5626 - 2802))) then
							if (((2545 - (295 + 314)) == (4755 - 2819)) and v24(v98.Fireblood)) then
								return "fireblood main 43";
							end
						end
						if ((v98.AncestralCall:IsCastable() and (v15:DebuffUp(v98.ColossusSmashDebuff))) or ((6794 - (1300 + 662)) < (13543 - 9230))) then
							if (((5843 - (1178 + 577)) > (2012 + 1862)) and v24(v98.AncestralCall)) then
								return "ancestral_call main 44";
							end
						end
						if (((12806 - 8474) == (5737 - (851 + 554))) and v98.BagofTricks:IsCastable() and v15:DebuffDown(v98.ColossusSmashDebuff) and not v98.MortalStrike:CooldownUp()) then
							if (((3537 + 462) >= (8042 - 5142)) and v24(v98.BagofTricks, not v15:IsSpellInRange(v98.BagofTricks))) then
								return "bag_of_tricks main 10";
							end
						end
					end
					if ((v91 < v104) or ((5483 - 2958) > (4366 - (115 + 187)))) then
						if (((3348 + 1023) == (4138 + 233)) and v93 and ((v30 and v59) or not v59)) then
							local v193 = 0 - 0;
							while true do
								if ((v193 == (1161 - (160 + 1001))) or ((233 + 33) > (3441 + 1545))) then
									v27 = v112();
									if (((4075 - 2084) >= (1283 - (237 + 121))) and v27) then
										return v27;
									end
									break;
								end
							end
						end
						if (((1352 - (525 + 372)) < (3891 - 1838)) and v30 and v99.FyralathTheDreamrender:IsEquippedAndReady() and v31) then
							if (v24(v100.UseWeapon) or ((2713 - 1887) == (4993 - (96 + 46)))) then
								return "Fyralath The Dreamrender used";
							end
						end
					end
					if (((960 - (643 + 134)) == (67 + 116)) and v39 and v98.HeroicThrow:IsCastable() and not v15:IsInRange(59 - 34) and v14:CanAttack(v15)) then
						if (((4302 - 3143) <= (1715 + 73)) and v24(v98.HeroicThrow, not v15:IsSpellInRange(v98.HeroicThrow))) then
							return "heroic_throw main";
						end
					end
					if ((v98.WreckingThrow:IsCastable() and v52 and v107() and v14:CanAttack(v15)) or ((6882 - 3375) > (8826 - 4508))) then
						if (v24(v98.WreckingThrow, not v15:IsSpellInRange(v98.WreckingThrow)) or ((3794 - (316 + 403)) <= (1971 + 994))) then
							return "wrecking_throw main";
						end
					end
					if (((3752 - 2387) <= (727 + 1284)) and v29 and (v106 > (4 - 2))) then
						v27 = v114();
						if (v27 or ((1968 + 808) > (1153 + 2422))) then
							return v27;
						end
					end
					if ((v98.Massacre:IsAvailable() and (v15:HealthPercentage() < (121 - 86))) or (v15:HealthPercentage() < (95 - 75)) or ((5305 - 2751) == (276 + 4528))) then
						v27 = v115();
						if (((5072 - 2495) == (126 + 2451)) and v27) then
							return v27;
						end
					end
					v27 = v116();
					if (v27 or ((17 - 11) >= (1906 - (12 + 5)))) then
						return v27;
					end
					if (((1965 - 1459) <= (4036 - 2144)) and v20.CastAnnotated(v98.Pool, false, "WAIT")) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if ((v132 == (0 - 0)) or ((4979 - 2971) > (451 + 1767))) then
				v27 = v111();
				if (((2352 - (1656 + 317)) <= (3696 + 451)) and v27) then
					return v27;
				end
				v132 = 1 + 0;
			end
		end
	end
	local function v119()
		local v133 = 0 - 0;
		while true do
			if ((v133 == (34 - 27)) or ((4868 - (5 + 349)) <= (4792 - 3783))) then
				v50 = EpicSettings.Settings['useWarbreaker'];
				v53 = EpicSettings.Settings['avatarWithCD'];
				v54 = EpicSettings.Settings['bladestormWithCD'];
				v133 = 1279 - (266 + 1005);
			end
			if ((v133 == (2 + 1)) or ((11928 - 8432) == (1568 - 376))) then
				v44 = EpicSettings.Settings['useShockwave'];
				v45 = EpicSettings.Settings['useSkullsplitter'];
				v46 = EpicSettings.Settings['useSlam'];
				v133 = 1700 - (561 + 1135);
			end
			if ((v133 == (6 - 1)) or ((683 - 475) == (4025 - (507 + 559)))) then
				v52 = EpicSettings.Settings['useWreckingThrow'];
				v32 = EpicSettings.Settings['useAvatar'];
				v34 = EpicSettings.Settings['useBladestorm'];
				v133 = 14 - 8;
			end
			if (((13227 - 8950) >= (1701 - (212 + 176))) and (v133 == (907 - (250 + 655)))) then
				v40 = EpicSettings.Settings['useMortalStrike'];
				v41 = EpicSettings.Settings['useOverpower'];
				v42 = EpicSettings.Settings['useRend'];
				v133 = 8 - 5;
			end
			if (((4519 - 1932) < (4965 - 1791)) and (v133 == (1965 - (1869 + 87)))) then
				v58 = EpicSettings.Settings['warbreakerWithCD'];
				break;
			end
			if ((v133 == (3 - 2)) or ((6021 - (484 + 1417)) <= (4710 - 2512))) then
				v36 = EpicSettings.Settings['useCleave'];
				v38 = EpicSettings.Settings['useExecute'];
				v39 = EpicSettings.Settings['useHeroicThrow'];
				v133 = 2 - 0;
			end
			if ((v133 == (773 - (48 + 725))) or ((2607 - 1011) == (2301 - 1443))) then
				v31 = EpicSettings.Settings['useWeapon'];
				v33 = EpicSettings.Settings['useBattleShout'];
				v35 = EpicSettings.Settings['useCharge'];
				v133 = 1 + 0;
			end
			if (((8605 - 5385) == (902 + 2318)) and (v133 == (2 + 4))) then
				v37 = EpicSettings.Settings['useColossusSmash'];
				v84 = EpicSettings.Settings['useChampionsSpear'];
				v49 = EpicSettings.Settings['useThunderousRoar'];
				v133 = 860 - (152 + 701);
			end
			if ((v133 == (1319 - (430 + 881))) or ((537 + 865) > (4515 - (557 + 338)))) then
				v55 = EpicSettings.Settings['colossusSmashWithCD'];
				v56 = EpicSettings.Settings['championsSpearWithCD'];
				v57 = EpicSettings.Settings['thunderousRoarWithCD'];
				v133 = 3 + 6;
			end
			if (((7253 - 4679) == (9013 - 6439)) and (v133 == (10 - 6))) then
				v47 = EpicSettings.Settings['useSweepingStrikes'];
				v48 = EpicSettings.Settings['useThunderClap'];
				v51 = EpicSettings.Settings['useWhirlwind'];
				v133 = 10 - 5;
			end
		end
	end
	local function v120()
		local v134 = 801 - (499 + 302);
		while true do
			if (((2664 - (39 + 827)) < (7610 - 4853)) and (v134 == (13 - 7))) then
				v83 = EpicSettings.Settings['victoryRushHP'] or (0 - 0);
				v85 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
			if ((v134 == (3 - 0)) or ((33 + 344) > (7621 - 5017))) then
				v72 = EpicSettings.Settings['useVictoryRush'];
				v73 = EpicSettings.Settings['bitterImmunityHP'] or (0 + 0);
				v79 = EpicSettings.Settings['defensiveStanceHP'] or (0 - 0);
				v134 = 108 - (103 + 1);
			end
			if (((1122 - (475 + 79)) < (1969 - 1058)) and (v134 == (0 - 0))) then
				v61 = EpicSettings.Settings['usePummel'];
				v62 = EpicSettings.Settings['useStormBolt'];
				v63 = EpicSettings.Settings['useIntimidatingShout'];
				v134 = 1 + 0;
			end
			if (((2892 + 393) < (5731 - (1395 + 108))) and (v134 == (5 - 3))) then
				v66 = EpicSettings.Settings['useIgnorePain'];
				v68 = EpicSettings.Settings['useIntervene'];
				v67 = EpicSettings.Settings['useRallyingCry'];
				v134 = 1207 - (7 + 1197);
			end
			if (((1708 + 2208) > (1162 + 2166)) and (v134 == (324 - (27 + 292)))) then
				v78 = EpicSettings.Settings['interveneHP'] or (0 - 0);
				v77 = EpicSettings.Settings['rallyingCryGroup'] or (0 - 0);
				v76 = EpicSettings.Settings['rallyingCryHP'] or (0 - 0);
				v134 = 11 - 5;
			end
			if (((4761 - 2261) < (3978 - (43 + 96))) and (v134 == (4 - 3))) then
				v64 = EpicSettings.Settings['useBitterImmunity'];
				v69 = EpicSettings.Settings['useDefensiveStance'];
				v65 = EpicSettings.Settings['useDieByTheSword'];
				v134 = 3 - 1;
			end
			if (((421 + 86) == (144 + 363)) and ((7 - 3) == v134)) then
				v82 = EpicSettings.Settings['unstanceHP'] or (0 + 0);
				v74 = EpicSettings.Settings['dieByTheSwordHP'] or (0 - 0);
				v75 = EpicSettings.Settings['ignorePainHP'] or (0 + 0);
				v134 = 1 + 4;
			end
		end
	end
	local function v121()
		v91 = EpicSettings.Settings['fightRemainsCheck'] or (1751 - (1414 + 337));
		v88 = EpicSettings.Settings['InterruptWithStun'];
		v89 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v90 = EpicSettings.Settings['InterruptThreshold'];
		v93 = EpicSettings.Settings['useTrinkets'];
		v92 = EpicSettings.Settings['useRacials'];
		v59 = EpicSettings.Settings['trinketsWithCD'];
		v60 = EpicSettings.Settings['racialsWithCD'];
		v70 = EpicSettings.Settings['useHealthstone'];
		v71 = EpicSettings.Settings['useHealingPotion'];
		v80 = EpicSettings.Settings['healthstoneHP'] or (1940 - (1642 + 298));
		v81 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v87 = EpicSettings.Settings['HealingPotionName'] or "";
		v86 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v122()
		v120();
		v119();
		v121();
		v28 = EpicSettings.Toggles['ooc'];
		v29 = EpicSettings.Toggles['aoe'];
		v30 = EpicSettings.Toggles['cds'];
		if (((690 - 450) <= (9392 - 6227)) and v14:IsDeadOrGhost()) then
			return v27;
		end
		if (((275 + 559) >= (627 + 178)) and v29) then
			v105 = v14:GetEnemiesInMeleeRange(980 - (357 + 615));
			v106 = #v105;
		else
			v106 = 1 + 0;
		end
		v102 = v15:IsInMeleeRange(19 - 11);
		if (v94.TargetIsValid() or v14:AffectingCombat() or ((3267 + 545) < (4963 - 2647))) then
			v103 = v10.BossFightRemains(nil, true);
			v104 = v103;
			if ((v104 == (8887 + 2224)) or ((181 + 2471) <= (964 + 569))) then
				v104 = v10.FightRemains(v105, false);
			end
		end
		if (not v14:IsChanneling() or ((4899 - (384 + 917)) < (2157 - (128 + 569)))) then
			if (v14:AffectingCombat() or ((5659 - (1407 + 136)) < (3079 - (687 + 1200)))) then
				local v189 = 1710 - (556 + 1154);
				while true do
					if ((v189 == (0 - 0)) or ((3472 - (9 + 86)) <= (1324 - (275 + 146)))) then
						v27 = v118();
						if (((647 + 3329) >= (503 - (29 + 35))) and v27) then
							return v27;
						end
						break;
					end
				end
			else
				local v190 = 0 - 0;
				while true do
					if (((11206 - 7454) == (16563 - 12811)) and ((0 + 0) == v190)) then
						v27 = v117();
						if (((5058 - (53 + 959)) > (3103 - (312 + 96))) and v27) then
							return v27;
						end
						break;
					end
				end
			end
		end
	end
	local function v123()
		v20.Print("Arms Warrior by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(123 - 52, v122, v123);
end;
return v0["Epix_Warrior_Arms.lua"]();

