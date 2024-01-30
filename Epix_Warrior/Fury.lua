local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((123 + 45) < (1382 + 1576)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Warrior_Fury.lua"] = function(...)
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
	local v90 = v19.Commons.Everyone;
	local v91 = v17.Warrior.Fury;
	local v92 = v18.Warrior.Fury;
	local v93 = v22.Warrior.Fury;
	local v94 = {};
	local v95 = 12544 - (797 + 636);
	local v96 = 53947 - 42836;
	v9:RegisterForEvent(function()
		v95 = 12730 - (1427 + 192);
		v96 = 3850 + 7261;
	end, "PLAYER_REGEN_ENABLED");
	local v97, v98;
	local v99;
	local function v100()
		local v113 = 0 - 0;
		local v114;
		while true do
			if ((v113 == (0 + 0)) or ((1240 + 1495) >= (4786 - (192 + 134)))) then
				v114 = UnitGetTotalAbsorbs(v14);
				if (((4179 - (316 + 960)) >= (832 + 663)) and (v114 > (0 + 0))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v101()
		if (((4202 + 344) >= (8697 - 6422)) and v91.BitterImmunity:IsReady() and v62 and (v13:HealthPercentage() <= v71)) then
			if (((1370 - (83 + 468)) >= (1828 - (1202 + 604))) and v23(v91.BitterImmunity)) then
				return "bitter_immunity defensive";
			end
		end
		if (((14760 - 11598) == (5262 - 2100)) and v91.EnragedRegeneration:IsCastable() and v63 and (v13:HealthPercentage() <= v72)) then
			if (v23(v91.EnragedRegeneration) or ((6559 - 4190) > (4754 - (45 + 280)))) then
				return "enraged_regeneration defensive";
			end
		end
		if (((3953 + 142) >= (2781 + 402)) and v91.IgnorePain:IsCastable() and v64 and (v13:HealthPercentage() <= v73)) then
			if (v23(v91.IgnorePain, nil, nil, true) or ((1356 + 2355) < (558 + 450))) then
				return "ignore_pain defensive";
			end
		end
		if ((v91.RallyingCry:IsCastable() and v65 and v13:BuffDown(v91.AspectsFavorBuff) and v13:BuffDown(v91.RallyingCry) and (((v13:HealthPercentage() <= v74) and v90.IsSoloMode()) or v90.AreUnitsBelowHealthPercentage(v74, v75))) or ((185 + 864) <= (1677 - 771))) then
			if (((6424 - (340 + 1571)) > (1076 + 1650)) and v23(v91.RallyingCry)) then
				return "rallying_cry defensive";
			end
		end
		if ((v91.Intervene:IsCastable() and v66 and (v16:HealthPercentage() <= v76) and (v16:UnitName() ~= v13:UnitName())) or ((3253 - (1733 + 39)) >= (7303 - 4645))) then
			if (v23(v93.InterveneFocus) or ((4254 - (125 + 909)) == (3312 - (1096 + 852)))) then
				return "intervene defensive";
			end
		end
		if ((v91.DefensiveStance:IsCastable() and v67 and (v13:HealthPercentage() <= v77) and v13:BuffDown(v91.DefensiveStance, true)) or ((473 + 581) > (4843 - 1451))) then
			if (v23(v91.DefensiveStance) or ((656 + 20) >= (2154 - (409 + 103)))) then
				return "defensive_stance defensive";
			end
		end
		if (((4372 - (46 + 190)) > (2492 - (51 + 44))) and v91.BerserkerStance:IsCastable() and v67 and (v13:HealthPercentage() > v80) and v13:BuffDown(v91.BerserkerStance, true)) then
			if (v23(v91.BerserkerStance) or ((1223 + 3111) == (5562 - (1114 + 203)))) then
				return "berserker_stance after defensive stance defensive";
			end
		end
		if ((v92.Healthstone:IsReady() and v68 and (v13:HealthPercentage() <= v78)) or ((5002 - (228 + 498)) <= (657 + 2374))) then
			if (v23(v93.Healthstone) or ((2642 + 2140) <= (1862 - (174 + 489)))) then
				return "healthstone defensive 3";
			end
		end
		if ((v69 and (v13:HealthPercentage() <= v79)) or ((12672 - 7808) < (3807 - (830 + 1075)))) then
			local v133 = 524 - (303 + 221);
			while true do
				if (((6108 - (231 + 1038)) >= (3084 + 616)) and (v133 == (1162 - (171 + 991)))) then
					if ((v85 == "Refreshing Healing Potion") or ((4430 - 3355) > (5149 - 3231))) then
						if (((988 - 592) <= (3045 + 759)) and v92.RefreshingHealingPotion:IsReady()) then
							if (v23(v93.RefreshingHealingPotion) or ((14613 - 10444) == (6308 - 4121))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((2266 - 860) == (4346 - 2940)) and (v85 == "Dreamwalker's Healing Potion")) then
						if (((2779 - (111 + 1137)) < (4429 - (91 + 67))) and v92.DreamwalkersHealingPotion:IsReady()) then
							if (((1889 - 1254) == (159 + 476)) and v23(v93.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v102()
		local v115 = 523 - (423 + 100);
		while true do
			if (((24 + 3349) <= (9845 - 6289)) and (v115 == (1 + 0))) then
				v26 = v90.HandleBottomTrinket(v94, v29, 811 - (326 + 445), nil);
				if (v26 or ((14361 - 11070) < (7307 - 4027))) then
					return v26;
				end
				break;
			end
			if (((10237 - 5851) >= (1584 - (530 + 181))) and (v115 == (881 - (614 + 267)))) then
				v26 = v90.HandleTopTrinket(v94, v29, 72 - (19 + 13), nil);
				if (((1498 - 577) <= (2567 - 1465)) and v26) then
					return v26;
				end
				v115 = 2 - 1;
			end
		end
	end
	local function v103()
		if (((1223 + 3483) >= (1692 - 729)) and v30 and ((v51 and v29) or not v51) and (v89 < v96) and v91.Avatar:IsCastable() and not v91.TitansTorment:IsAvailable()) then
			if (v23(v91.Avatar, not v99) or ((1990 - 1030) <= (2688 - (1293 + 519)))) then
				return "avatar precombat 6";
			end
		end
		if ((v43 and ((v54 and v29) or not v54) and (v89 < v96) and v91.Recklessness:IsCastable() and not v91.RecklessAbandon:IsAvailable()) or ((4214 - 2148) == (2433 - 1501))) then
			if (((9226 - 4401) < (20883 - 16040)) and v23(v91.Recklessness, not v99)) then
				return "recklessness precombat 8";
			end
		end
		if ((v91.Bloodthirst:IsCastable() and v33 and v99) or ((9133 - 5256) >= (2403 + 2134))) then
			if (v23(v91.Bloodthirst, not v99) or ((881 + 3434) < (4009 - 2283))) then
				return "bloodthirst precombat 10";
			end
		end
		if ((v34 and v91.Charge:IsReady() and not v99) or ((851 + 2828) < (208 + 417))) then
			if (v23(v91.Charge, not v14:IsSpellInRange(v91.Charge)) or ((2891 + 1734) < (1728 - (709 + 387)))) then
				return "charge precombat 12";
			end
		end
	end
	local function v104()
		local v116 = 1858 - (673 + 1185);
		while true do
			if ((v116 == (0 - 0)) or ((266 - 183) > (2928 - 1148))) then
				if (((391 + 155) <= (805 + 272)) and not v13:AffectingCombat()) then
					local v172 = 0 - 0;
					while true do
						if ((v172 == (0 + 0)) or ((1985 - 989) > (8442 - 4141))) then
							if (((5950 - (446 + 1434)) > (1970 - (1040 + 243))) and v91.BerserkerStance:IsCastable() and v13:BuffDown(v91.BerserkerStance, true)) then
								if (v23(v91.BerserkerStance) or ((1957 - 1301) >= (5177 - (559 + 1288)))) then
									return "berserker_stance";
								end
							end
							if ((v91.BattleShout:IsCastable() and v31 and (v13:BuffDown(v91.BattleShoutBuff, true) or v90.GroupBuffMissing(v91.BattleShoutBuff))) or ((4423 - (609 + 1322)) <= (789 - (13 + 441)))) then
								if (((16150 - 11828) >= (6710 - 4148)) and v23(v91.BattleShout)) then
									return "battle_shout precombat";
								end
							end
							break;
						end
					end
				end
				if ((v90.TargetIsValid() and v27) or ((18113 - 14476) >= (141 + 3629))) then
					if (not v13:AffectingCombat() or ((8639 - 6260) > (1626 + 2952))) then
						local v177 = 0 + 0;
						while true do
							if ((v177 == (0 - 0)) or ((265 + 218) > (1365 - 622))) then
								v26 = v103();
								if (((1623 + 831) > (322 + 256)) and v26) then
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
	local function v105()
		if (((669 + 261) < (3744 + 714)) and v91.Whirlwind:IsCastable() and v47 and (v98 > (1 + 0)) and v91.ImprovedWhilwind:IsAvailable() and v13:BuffDown(v91.MeatCleaverBuff)) then
			if (((1095 - (153 + 280)) <= (2806 - 1834)) and v23(v91.Whirlwind, not v14:IsInMeleeRange(8 + 0))) then
				return "whirlwind single_target 2";
			end
		end
		if (((1726 + 2644) == (2287 + 2083)) and v91.Execute:IsReady() and v36 and v13:BuffUp(v91.AshenJuggernautBuff) and (v13:BuffRemains(v91.AshenJuggernautBuff) < v13:GCD())) then
			if (v23(v91.Execute, not v99) or ((4322 + 440) <= (624 + 237))) then
				return "execute single_target 4";
			end
		end
		if ((v38 and ((v52 and v29) or not v52) and v91.OdynsFury:IsCastable() and (v89 < v96) and v13:BuffUp(v91.EnrageBuff) and ((v91.DancingBlades:IsAvailable() and (v13:BuffRemains(v91.DancingBladesBuff) < (7 - 2))) or not v91.DancingBlades:IsAvailable())) or ((873 + 539) == (4931 - (89 + 578)))) then
			if (v23(v91.OdynsFury, not v14:IsInMeleeRange(6 + 2)) or ((6585 - 3417) < (3202 - (572 + 477)))) then
				return "odyns_fury single_target 6";
			end
		end
		if ((v91.Rampage:IsReady() and v41 and v91.AngerManagement:IsAvailable() and (v13:BuffUp(v91.RecklessnessBuff) or (v13:BuffRemains(v91.EnrageBuff) < v13:GCD()) or (v13:RagePercentage() > (12 + 73)))) or ((2987 + 1989) < (159 + 1173))) then
			if (((4714 - (84 + 2)) == (7627 - 2999)) and v23(v91.Rampage, not v99)) then
				return "rampage single_target 8";
			end
		end
		local v117 = v13:CritChancePct() + (v24(v13:BuffUp(v91.RecklessnessBuff)) * (15 + 5)) + (v13:BuffStack(v91.MercilessAssaultBuff) * (852 - (497 + 345))) + (v13:BuffStack(v91.BloodcrazeBuff) * (1 + 14));
		if ((v91.Bloodbath:IsCastable() and v32 and v13:HasTier(6 + 24, 1337 - (605 + 728)) and (v117 >= (68 + 27))) or ((119 - 65) == (19 + 376))) then
			if (((303 - 221) == (74 + 8)) and v23(v91.Bloodbath, not v99)) then
				return "bloodbath single_target 10";
			end
		end
		if ((v91.Bloodthirst:IsCastable() and v33 and ((v13:HasTier(83 - 53, 4 + 0) and (v117 >= (584 - (457 + 32)))) or (not v91.RecklessAbandon:IsAvailable() and v13:BuffUp(v91.FuriousBloodthirstBuff) and v13:BuffUp(v91.EnrageBuff) and (v14:DebuffDown(v91.GushingWoundDebuff) or v13:BuffUp(v91.ChampionsMightBuff))))) or ((247 + 334) < (1684 - (832 + 570)))) then
			if (v23(v91.Bloodthirst, not v99) or ((4343 + 266) < (651 + 1844))) then
				return "bloodthirst single_target 12";
			end
		end
		if (((4076 - 2924) == (555 + 597)) and v91.Bloodbath:IsCastable() and v32 and v13:HasTier(827 - (588 + 208), 5 - 3)) then
			if (((3696 - (884 + 916)) <= (7163 - 3741)) and v23(v91.Bloodbath, not v99)) then
				return "bloodbath single_target 14";
			end
		end
		if ((v46 and ((v56 and v29) or not v56) and (v89 < v96) and v91.ThunderousRoar:IsCastable() and v13:BuffUp(v91.EnrageBuff)) or ((575 + 415) > (2273 - (232 + 421)))) then
			if (v23(v91.ThunderousRoar, not v14:IsInMeleeRange(1897 - (1569 + 320))) or ((216 + 661) > (892 + 3803))) then
				return "thunderous_roar single_target 16";
			end
		end
		if (((9068 - 6377) >= (2456 - (316 + 289))) and v91.Onslaught:IsReady() and v39 and (v13:BuffUp(v91.EnrageBuff) or v91.Tenderize:IsAvailable())) then
			if (v23(v91.Onslaught, not v99) or ((7813 - 4828) >= (225 + 4631))) then
				return "onslaught single_target 18";
			end
		end
		if (((5729 - (666 + 787)) >= (1620 - (360 + 65))) and v91.CrushingBlow:IsCastable() and v35 and v91.WrathandFury:IsAvailable() and v13:BuffUp(v91.EnrageBuff) and v13:BuffDown(v91.FuriousBloodthirstBuff)) then
			if (((3021 + 211) <= (4944 - (79 + 175))) and v23(v91.CrushingBlow, not v99)) then
				return "crushing_blow single_target 20";
			end
		end
		if ((v91.Execute:IsReady() and v36 and ((v13:BuffUp(v91.EnrageBuff) and v13:BuffDown(v91.FuriousBloodthirstBuff) and v13:BuffUp(v91.AshenJuggernautBuff)) or ((v13:BuffRemains(v91.SuddenDeathBuff) <= v13:GCD()) and (((v14:HealthPercentage() > (55 - 20)) and v91.Massacre:IsAvailable()) or (v14:HealthPercentage() > (16 + 4)))))) or ((2746 - 1850) >= (6058 - 2912))) then
			if (((3960 - (503 + 396)) >= (3139 - (92 + 89))) and v23(v91.Execute, not v99)) then
				return "execute single_target 22";
			end
		end
		if (((6182 - 2995) >= (331 + 313)) and v91.Rampage:IsReady() and v41 and v91.RecklessAbandon:IsAvailable() and (v13:BuffUp(v91.RecklessnessBuff) or (v13:BuffRemains(v91.EnrageBuff) < v13:GCD()) or (v13:RagePercentage() > (51 + 34)))) then
			if (((2521 - 1877) <= (97 + 607)) and v23(v91.Rampage, not v99)) then
				return "rampage single_target 24";
			end
		end
		if (((2183 - 1225) > (827 + 120)) and v91.Execute:IsReady() and v36 and v13:BuffUp(v91.EnrageBuff)) then
			if (((2146 + 2346) >= (8083 - 5429)) and v23(v91.Execute, not v99)) then
				return "execute single_target 26";
			end
		end
		if (((430 + 3012) >= (2291 - 788)) and v91.Rampage:IsReady() and v41 and v91.AngerManagement:IsAvailable()) then
			if (v23(v91.Rampage, not v99) or ((4414 - (485 + 759)) <= (3387 - 1923))) then
				return "rampage single_target 28";
			end
		end
		if ((v91.Execute:IsReady() and v36) or ((5986 - (442 + 747)) == (5523 - (832 + 303)))) then
			if (((1497 - (88 + 858)) <= (208 + 473)) and v23(v91.Execute, not v99)) then
				return "execute single_target 29";
			end
		end
		if (((2713 + 564) > (17 + 390)) and v91.Bloodbath:IsCastable() and v32 and v13:BuffUp(v91.EnrageBuff) and v91.RecklessAbandon:IsAvailable() and not v91.WrathandFury:IsAvailable()) then
			if (((5484 - (766 + 23)) >= (6985 - 5570)) and v23(v91.Bloodbath, not v99)) then
				return "bloodbath single_target 30";
			end
		end
		if ((v91.Rampage:IsReady() and v41 and (v14:HealthPercentage() < (47 - 12)) and v91.Massacre:IsAvailable()) or ((8462 - 5250) <= (3203 - 2259))) then
			if (v23(v91.Rampage, not v99) or ((4169 - (1036 + 37)) <= (1275 + 523))) then
				return "rampage single_target 32";
			end
		end
		if (((6887 - 3350) == (2783 + 754)) and v91.Bloodthirst:IsCastable() and v33 and (not v13:BuffUp(v91.EnrageBuff) or (v91.Annihilator:IsAvailable() and v13:BuffDown(v91.RecklessnessBuff))) and v13:BuffDown(v91.FuriousBloodthirstBuff)) then
			if (((5317 - (641 + 839)) >= (2483 - (910 + 3))) and v23(v91.Bloodthirst, not v99)) then
				return "bloodthirst single_target 34";
			end
		end
		if ((v91.RagingBlow:IsCastable() and v40 and (v91.RagingBlow:Charges() > (2 - 1)) and v91.WrathandFury:IsAvailable()) or ((4634 - (1466 + 218)) == (1752 + 2060))) then
			if (((5871 - (556 + 592)) >= (825 + 1493)) and v23(v91.RagingBlow, not v99)) then
				return "raging_blow single_target 36";
			end
		end
		if ((v91.CrushingBlow:IsCastable() and v35 and (v91.CrushingBlow:Charges() > (809 - (329 + 479))) and v91.WrathandFury:IsAvailable() and v13:BuffDown(v91.FuriousBloodthirstBuff)) or ((2881 - (174 + 680)) > (9799 - 6947))) then
			if (v23(v91.CrushingBlow, not v99) or ((2354 - 1218) > (3083 + 1234))) then
				return "crushing_blow single_target 38";
			end
		end
		if (((5487 - (396 + 343)) == (421 + 4327)) and v91.Bloodbath:IsCastable() and v32 and (not v13:BuffUp(v91.EnrageBuff) or not v91.WrathandFury:IsAvailable())) then
			if (((5213 - (29 + 1448)) <= (6129 - (135 + 1254))) and v23(v91.Bloodbath, not v99)) then
				return "bloodbath single_target 40";
			end
		end
		if ((v91.CrushingBlow:IsCastable() and v35 and v13:BuffUp(v91.EnrageBuff) and v91.RecklessAbandon:IsAvailable() and v13:BuffDown(v91.FuriousBloodthirstBuff)) or ((12770 - 9380) <= (14287 - 11227))) then
			if (v23(v91.CrushingBlow, not v99) or ((666 + 333) > (4220 - (389 + 1138)))) then
				return "crushing_blow single_target 42";
			end
		end
		if (((1037 - (102 + 472)) < (568 + 33)) and v91.Bloodthirst:IsCastable() and v33 and not v91.WrathandFury:IsAvailable() and v13:BuffDown(v91.FuriousBloodthirstBuff)) then
			if (v23(v91.Bloodthirst, not v99) or ((1211 + 972) < (641 + 46))) then
				return "bloodthirst single_target 44";
			end
		end
		if (((6094 - (320 + 1225)) == (8097 - 3548)) and v91.RagingBlow:IsCastable() and v40 and (v91.RagingBlow:Charges() > (1 + 0))) then
			if (((6136 - (157 + 1307)) == (6531 - (821 + 1038))) and v23(v91.RagingBlow, not v99)) then
				return "raging_blow single_target 46";
			end
		end
		if ((v91.Rampage:IsReady() and v41) or ((9151 - 5483) < (44 + 351))) then
			if (v23(v91.Rampage, not v99) or ((7399 - 3233) == (170 + 285))) then
				return "rampage single_target 47";
			end
		end
		if ((v91.Slam:IsReady() and v44 and (v91.Annihilator:IsAvailable())) or ((11026 - 6577) == (3689 - (834 + 192)))) then
			if (v23(v91.Slam, not v99) or ((272 + 4005) < (768 + 2221))) then
				return "slam single_target 48";
			end
		end
		if ((v91.Bloodbath:IsCastable() and v32) or ((19 + 851) >= (6427 - 2278))) then
			if (((2516 - (300 + 4)) < (851 + 2332)) and v23(v91.Bloodbath, not v99)) then
				return "bloodbath single_target 50";
			end
		end
		if (((12162 - 7516) > (3354 - (112 + 250))) and v91.RagingBlow:IsCastable() and v40) then
			if (((572 + 862) < (7781 - 4675)) and v23(v91.RagingBlow, not v99)) then
				return "raging_blow single_target 52";
			end
		end
		if (((451 + 335) < (1564 + 1459)) and v91.CrushingBlow:IsCastable() and v35 and v13:BuffDown(v91.FuriousBloodthirstBuff)) then
			if (v23(v91.CrushingBlow, not v99) or ((1827 + 615) < (37 + 37))) then
				return "crushing_blow single_target 54";
			end
		end
		if (((3369 + 1166) == (5949 - (1001 + 413))) and v91.Bloodthirst:IsCastable() and v33) then
			if (v23(v91.Bloodthirst, not v99) or ((6709 - 3700) <= (2987 - (244 + 638)))) then
				return "bloodthirst single_target 56";
			end
		end
		if (((2523 - (627 + 66)) < (10931 - 7262)) and v28 and v91.Whirlwind:IsCastable() and v47) then
			if (v23(v91.Whirlwind, not v14:IsInMeleeRange(610 - (512 + 90))) or ((3336 - (1665 + 241)) >= (4329 - (373 + 344)))) then
				return "whirlwind single_target 58";
			end
		end
	end
	local function v106()
		if (((1211 + 1472) >= (651 + 1809)) and v91.Recklessness:IsCastable() and ((v54 and v29) or not v54) and v43 and (v89 < v96) and ((v98 > (2 - 1)) or (v96 < (19 - 7)))) then
			if (v23(v91.Recklessness, not v99) or ((2903 - (35 + 1064)) >= (2383 + 892))) then
				return "recklessness multi_target 2";
			end
		end
		if ((v91.OdynsFury:IsCastable() and ((v52 and v29) or not v52) and v38 and (v89 < v96) and (v98 > (2 - 1)) and v91.TitanicRage:IsAvailable() and (v13:BuffDown(v91.MeatCleaverBuff) or v13:BuffUp(v91.AvatarBuff) or v13:BuffUp(v91.RecklessnessBuff))) or ((6 + 1411) > (4865 - (298 + 938)))) then
			if (((6054 - (233 + 1026)) > (2068 - (636 + 1030))) and v23(v91.OdynsFury, not v14:IsInMeleeRange(5 + 3))) then
				return "odyns_fury multi_target 4";
			end
		end
		if (((4702 + 111) > (1060 + 2505)) and v91.Whirlwind:IsCastable() and v47 and (v98 > (1 + 0)) and v91.ImprovedWhilwind:IsAvailable() and v13:BuffDown(v91.MeatCleaverBuff)) then
			if (((4133 - (55 + 166)) == (759 + 3153)) and v23(v91.Whirlwind, not v14:IsInMeleeRange(1 + 7))) then
				return "whirlwind multi_target 6";
			end
		end
		if (((10773 - 7952) <= (5121 - (36 + 261))) and v91.Execute:IsReady() and v36 and v13:BuffUp(v91.AshenJuggernautBuff) and (v13:BuffRemains(v91.AshenJuggernautBuff) < v13:GCD())) then
			if (((3039 - 1301) <= (3563 - (34 + 1334))) and v23(v91.Execute, not v99)) then
				return "execute multi_target 8";
			end
		end
		if (((16 + 25) <= (2345 + 673)) and v91.ThunderousRoar:IsCastable() and ((v56 and v29) or not v56) and v46 and (v89 < v96) and v13:BuffUp(v91.EnrageBuff)) then
			if (((3428 - (1035 + 248)) <= (4125 - (20 + 1))) and v23(v91.ThunderousRoar, not v14:IsInMeleeRange(5 + 3))) then
				return "thunderous_roar multi_target 10";
			end
		end
		if (((3008 - (134 + 185)) < (5978 - (549 + 584))) and v91.OdynsFury:IsCastable() and ((v52 and v29) or not v52) and v38 and (v89 < v96) and (v98 > (686 - (314 + 371))) and v13:BuffUp(v91.EnrageBuff)) then
			if (v23(v91.OdynsFury, not v14:IsInMeleeRange(27 - 19)) or ((3290 - (478 + 490)) > (1389 + 1233))) then
				return "odyns_fury multi_target 12";
			end
		end
		local v118 = v13:CritChancePct() + (v24(v13:BuffUp(v91.RecklessnessBuff)) * (1192 - (786 + 386))) + (v13:BuffStack(v91.MercilessAssaultBuff) * (32 - 22)) + (v13:BuffStack(v91.BloodcrazeBuff) * (1394 - (1055 + 324)));
		if ((v91.Bloodbath:IsCastable() and v32 and v13:HasTier(1370 - (1093 + 247), 4 + 0) and (v118 >= (10 + 85))) or ((18000 - 13466) == (7065 - 4983))) then
			if (v23(v91.Bloodbath, not v99) or ((4470 - 2899) > (4691 - 2824))) then
				return "bloodbath multi_target 14";
			end
		end
		if ((v91.Bloodthirst:IsCastable() and v33 and ((v13:HasTier(11 + 19, 15 - 11) and (v118 >= (327 - 232))) or (not v91.RecklessAbandon:IsAvailable() and v13:BuffUp(v91.FuriousBloodthirstBuff) and v13:BuffUp(v91.EnrageBuff)))) or ((2002 + 652) >= (7661 - 4665))) then
			if (((4666 - (364 + 324)) > (5767 - 3663)) and v23(v91.Bloodthirst, not v99)) then
				return "bloodthirst multi_target 16";
			end
		end
		if (((7186 - 4191) > (511 + 1030)) and v91.CrushingBlow:IsCastable() and v91.WrathandFury:IsAvailable() and v35 and v13:BuffUp(v91.EnrageBuff)) then
			if (((13594 - 10345) > (1526 - 573)) and v23(v91.CrushingBlow, not v99)) then
				return "crushing_blow multi_target 14";
			end
		end
		if ((v91.Execute:IsReady() and v36 and v13:BuffUp(v91.EnrageBuff)) or ((9940 - 6667) > (5841 - (1249 + 19)))) then
			if (v23(v91.Execute, not v99) or ((2845 + 306) < (4997 - 3713))) then
				return "execute multi_target 16";
			end
		end
		if ((v91.OdynsFury:IsCastable() and ((v52 and v29) or not v52) and v38 and (v89 < v96) and v13:BuffUp(v91.EnrageBuff)) or ((2936 - (686 + 400)) == (1200 + 329))) then
			if (((1050 - (73 + 156)) < (11 + 2112)) and v23(v91.OdynsFury, not v14:IsInMeleeRange(819 - (721 + 90)))) then
				return "odyns_fury multi_target 18";
			end
		end
		if (((11 + 891) < (7549 - 5224)) and v91.Rampage:IsReady() and v41 and (v13:BuffUp(v91.RecklessnessBuff) or (v13:BuffRemains(v91.EnrageBuff) < v13:GCD()) or ((v13:Rage() > (580 - (224 + 246))) and v91.OverwhelmingRage:IsAvailable()) or ((v13:Rage() > (129 - 49)) and not v91.OverwhelmingRage:IsAvailable()))) then
			if (((1579 - 721) <= (538 + 2424)) and v23(v91.Rampage, not v99)) then
				return "rampage multi_target 20";
			end
		end
		if ((v91.Execute:IsReady() and v36) or ((94 + 3852) < (947 + 341))) then
			if (v23(v91.Execute, not v99) or ((6444 - 3202) == (1886 - 1319))) then
				return "execute multi_target 22";
			end
		end
		if ((v91.Bloodbath:IsCastable() and v32 and v13:BuffUp(v91.EnrageBuff) and v91.RecklessAbandon:IsAvailable() and not v91.WrathandFury:IsAvailable()) or ((1360 - (203 + 310)) >= (3256 - (1238 + 755)))) then
			if (v23(v91.Bloodbath, not v99) or ((158 + 2095) == (3385 - (709 + 825)))) then
				return "bloodbath multi_target 24";
			end
		end
		if ((v91.Bloodthirst:IsCastable() and v33 and (not v13:BuffUp(v91.EnrageBuff) or (v91.Annihilator:IsAvailable() and v13:BuffDown(v91.RecklessnessBuff)))) or ((3845 - 1758) > (3454 - 1082))) then
			if (v23(v91.Bloodthirst, not v99) or ((5309 - (196 + 668)) < (16381 - 12232))) then
				return "bloodthirst multi_target 26";
			end
		end
		if ((v91.Onslaught:IsReady() and v39 and ((not v91.Annihilator:IsAvailable() and v13:BuffUp(v91.EnrageBuff)) or v91.Tenderize:IsAvailable())) or ((3765 - 1947) == (918 - (171 + 662)))) then
			if (((723 - (4 + 89)) < (7455 - 5328)) and v23(v91.Onslaught, not v99)) then
				return "onslaught multi_target 28";
			end
		end
		if ((v91.RagingBlow:IsCastable() and v40 and (v91.RagingBlow:Charges() > (1 + 0)) and v91.WrathandFury:IsAvailable()) or ((8512 - 6574) == (986 + 1528))) then
			if (((5741 - (35 + 1451)) >= (1508 - (28 + 1425))) and v23(v91.RagingBlow, not v99)) then
				return "raging_blow multi_target 30";
			end
		end
		if (((4992 - (941 + 1052)) > (1109 + 47)) and v91.CrushingBlow:IsCastable() and v35 and (v91.CrushingBlow:Charges() > (1515 - (822 + 692))) and v91.WrathandFury:IsAvailable()) then
			if (((3355 - 1005) > (545 + 610)) and v23(v91.CrushingBlow, not v99)) then
				return "crushing_blow multi_target 32";
			end
		end
		if (((4326 - (45 + 252)) <= (4802 + 51)) and v91.Bloodbath:IsCastable() and v32 and (not v13:BuffUp(v91.EnrageBuff) or not v91.WrathandFury:IsAvailable())) then
			if (v23(v91.Bloodbath, not v99) or ((178 + 338) > (8357 - 4923))) then
				return "bloodbath multi_target 34";
			end
		end
		if (((4479 - (114 + 319)) >= (4353 - 1320)) and v91.CrushingBlow:IsCastable() and v35 and v13:BuffUp(v91.EnrageBuff) and v91.RecklessAbandon:IsAvailable()) then
			if (v23(v91.CrushingBlow, not v99) or ((3483 - 764) <= (923 + 524))) then
				return "crushing_blow multi_target 36";
			end
		end
		if ((v91.Bloodthirst:IsCastable() and v33 and not v91.WrathandFury:IsAvailable()) or ((6158 - 2024) < (8225 - 4299))) then
			if (v23(v91.Bloodthirst, not v99) or ((2127 - (556 + 1407)) >= (3991 - (741 + 465)))) then
				return "bloodthirst multi_target 38";
			end
		end
		if ((v91.RagingBlow:IsCastable() and v40 and (v91.RagingBlow:Charges() > (466 - (170 + 295)))) or ((277 + 248) == (1938 + 171))) then
			if (((80 - 47) == (28 + 5)) and v23(v91.RagingBlow, not v99)) then
				return "raging_blow multi_target 40";
			end
		end
		if (((1959 + 1095) <= (2274 + 1741)) and v91.Rampage:IsReady() and v41) then
			if (((3101 - (957 + 273)) < (905 + 2477)) and v23(v91.Rampage, not v99)) then
				return "rampage multi_target 42";
			end
		end
		if (((518 + 775) <= (8253 - 6087)) and v91.Slam:IsReady() and v44 and (v91.Annihilator:IsAvailable())) then
			if (v23(v91.Slam, not v99) or ((6796 - 4217) < (375 - 252))) then
				return "slam multi_target 44";
			end
		end
		if ((v91.Bloodbath:IsCastable() and v32) or ((4189 - 3343) >= (4148 - (389 + 1391)))) then
			if (v23(v91.Bloodbath, not v99) or ((2518 + 1494) <= (350 + 3008))) then
				return "bloodbath multi_target 46";
			end
		end
		if (((3400 - 1906) <= (3956 - (783 + 168))) and v91.RagingBlow:IsCastable() and v40) then
			if (v23(v91.RagingBlow, not v99) or ((10441 - 7330) == (2100 + 34))) then
				return "raging_blow multi_target 48";
			end
		end
		if (((2666 - (309 + 2)) == (7231 - 4876)) and v91.CrushingBlow:IsCastable() and v35) then
			if (v23(v91.CrushingBlow, not v99) or ((1800 - (1090 + 122)) <= (141 + 291))) then
				return "crushing_blow multi_target 50";
			end
		end
		if (((16110 - 11313) >= (2666 + 1229)) and v91.Whirlwind:IsCastable() and v47) then
			if (((4695 - (628 + 490)) == (642 + 2935)) and v23(v91.Whirlwind, not v14:IsInMeleeRange(19 - 11))) then
				return "whirlwind multi_target 52";
			end
		end
	end
	local function v107()
		local v119 = 0 - 0;
		while true do
			if (((4568 - (431 + 343)) > (7458 - 3765)) and ((2 - 1) == v119)) then
				if (v84 or ((1008 + 267) == (525 + 3575))) then
					local v173 = 1695 - (556 + 1139);
					while true do
						if ((v173 == (16 - (6 + 9))) or ((292 + 1299) >= (1834 + 1746))) then
							v26 = v90.HandleIncorporeal(v91.IntimidatingShout, v93.IntimidatingShoutMouseover, 177 - (28 + 141), true);
							if (((381 + 602) <= (2231 - 423)) and v26) then
								return v26;
							end
							break;
						end
						if ((v173 == (0 + 0)) or ((3467 - (486 + 831)) <= (3114 - 1917))) then
							v26 = v90.HandleIncorporeal(v91.StormBolt, v93.StormBoltMouseover, 70 - 50, true);
							if (((713 + 3056) >= (3708 - 2535)) and v26) then
								return v26;
							end
							v173 = 1264 - (668 + 595);
						end
					end
				end
				if (((1337 + 148) == (300 + 1185)) and v90.TargetIsValid()) then
					local v174 = 0 - 0;
					local v175;
					while true do
						if ((v174 == (292 - (23 + 267))) or ((5259 - (1129 + 815)) <= (3169 - (371 + 16)))) then
							if ((v28 and (v98 >= (1752 - (1326 + 424)))) or ((1658 - 782) >= (10831 - 7867))) then
								v26 = v106();
								if (v26 or ((2350 - (88 + 30)) > (3268 - (720 + 51)))) then
									return v26;
								end
							end
							v26 = v105();
							if (v26 or ((4693 - 2583) <= (2108 - (421 + 1355)))) then
								return v26;
							end
							break;
						end
						if (((6080 - 2394) > (1559 + 1613)) and ((1084 - (286 + 797)) == v174)) then
							if (((v89 < v96) and v49 and ((v57 and v29) or not v57)) or ((16355 - 11881) < (1358 - 538))) then
								local v179 = 439 - (397 + 42);
								while true do
									if (((1337 + 2942) >= (3682 - (24 + 776))) and ((0 - 0) == v179)) then
										if (v91.BloodFury:IsCastable() or ((2814 - (222 + 563)) >= (7757 - 4236))) then
											if (v23(v91.BloodFury, not v99) or ((1467 + 570) >= (4832 - (23 + 167)))) then
												return "blood_fury main 12";
											end
										end
										if (((3518 - (690 + 1108)) < (1609 + 2849)) and v91.Berserking:IsCastable() and v13:BuffUp(v91.RecklessnessBuff)) then
											if (v23(v91.Berserking, not v99) or ((360 + 76) > (3869 - (40 + 808)))) then
												return "berserking main 14";
											end
										end
										v179 = 1 + 0;
									end
									if (((2726 - 2013) <= (810 + 37)) and ((2 + 0) == v179)) then
										if (((1182 + 972) <= (4602 - (47 + 524))) and v91.AncestralCall:IsCastable()) then
											if (((2995 + 1620) == (12615 - 8000)) and v23(v91.AncestralCall, not v99)) then
												return "ancestral_call main 20";
											end
										end
										if ((v91.BagofTricks:IsCastable() and v13:BuffDown(v91.RecklessnessBuff) and v13:BuffUp(v91.EnrageBuff)) or ((5667 - 1877) == (1140 - 640))) then
											if (((1815 - (1165 + 561)) < (7 + 214)) and v23(v91.BagofTricks, not v14:IsSpellInRange(v91.BagofTricks))) then
												return "bag_of_tricks main 22";
											end
										end
										break;
									end
									if (((6361 - 4307) >= (543 + 878)) and (v179 == (480 - (341 + 138)))) then
										if (((187 + 505) < (6310 - 3252)) and v91.LightsJudgment:IsCastable() and v13:BuffDown(v91.RecklessnessBuff)) then
											if (v23(v91.LightsJudgment, not v14:IsSpellInRange(v91.LightsJudgment)) or ((3580 - (89 + 237)) == (5324 - 3669))) then
												return "lights_judgment main 16";
											end
										end
										if (v91.Fireblood:IsCastable() or ((2728 - 1432) == (5791 - (581 + 300)))) then
											if (((4588 - (855 + 365)) == (7999 - 4631)) and v23(v91.Fireblood, not v99)) then
												return "fireblood main 18";
											end
										end
										v179 = 1 + 1;
									end
								end
							end
							if (((3878 - (1030 + 205)) < (3582 + 233)) and (v89 < v96)) then
								if (((1780 + 133) > (779 - (156 + 130))) and ((v91.Avatar:IsCastable() and v30 and ((v51 and v29) or not v51) and v91.TitansTorment:IsAvailable() and v13:BuffUp(v91.EnrageBuff) and (v89 < v96) and v13:BuffDown(v91.AvatarBuff) and (not v91.OdynsFury:IsAvailable() or (v91.OdynsFury:CooldownRemains() > (0 - 0)))) or (v91.BerserkersTorment:IsAvailable() and v13:BuffUp(v91.EnrageBuff) and v13:BuffDown(v91.AvatarBuff)) or (not v91.TitansTorment:IsAvailable() and not v91.BerserkersTorment:IsAvailable() and (v13:BuffUp(v91.RecklessnessBuff) or (v96 < (33 - 13)))))) then
									if (((9738 - 4983) > (904 + 2524)) and v23(v91.Avatar, not v99)) then
										return "avatar main 24";
									end
								end
								if (((806 + 575) <= (2438 - (10 + 59))) and v91.Recklessness:IsCastable() and v43 and ((v54 and v29) or not v54) and (not v91.Annihilator:IsAvailable() or (v91.ChampionsSpear:CooldownRemains() < (1 + 0)) or (v91.Avatar:CooldownRemains() > (196 - 156)) or not v91.Avatar:IsAvailable() or (v96 < (1175 - (671 + 492))))) then
									if (v23(v91.Recklessness, not v99) or ((3856 + 987) == (5299 - (369 + 846)))) then
										return "recklessness main 26";
									end
								end
								if (((1237 + 3432) > (310 + 53)) and v91.Recklessness:IsCastable() and v43 and ((v54 and v29) or not v54) and (not v91.Annihilator:IsAvailable() or (v96 < (1957 - (1036 + 909))))) then
									if (v23(v91.Recklessness, not v99) or ((1493 + 384) >= (5268 - 2130))) then
										return "recklessness main 27";
									end
								end
								if (((4945 - (11 + 192)) >= (1833 + 1793)) and v91.Ravager:IsCastable() and (v82 == "player") and v42 and ((v53 and v29) or not v53) and ((v91.Avatar:CooldownRemains() < (178 - (135 + 40))) or v13:BuffUp(v91.RecklessnessBuff) or (v96 < (24 - 14)))) then
									if (v23(v93.RavagerPlayer, not v99) or ((2737 + 1803) == (2017 - 1101))) then
										return "ravager main 28";
									end
								end
								if ((v91.Ravager:IsCastable() and (v82 == "cursor") and v42 and ((v53 and v29) or not v53) and ((v91.Avatar:CooldownRemains() < (4 - 1)) or v13:BuffUp(v91.RecklessnessBuff) or (v96 < (186 - (50 + 126))))) or ((3218 - 2062) > (962 + 3383))) then
									if (((3650 - (1233 + 180)) < (5218 - (522 + 447))) and v23(v93.RavagerCursor, not v99)) then
										return "ravager main 28";
									end
								end
								if ((v91.ChampionsSpear:IsCastable() and (v83 == "player") and v45 and ((v55 and v29) or not v55) and v13:BuffUp(v91.EnrageBuff) and ((v13:BuffUp(v91.FuriousBloodthirstBuff) and v91.TitansTorment:IsAvailable()) or not v91.TitansTorment:IsAvailable() or (v96 < (1441 - (107 + 1314))) or (v98 > (1 + 0)) or not v13:HasTier(94 - 63, 1 + 1))) or ((5327 - 2644) < (90 - 67))) then
									if (((2607 - (716 + 1194)) <= (15 + 811)) and v23(v93.ChampionsSpearPlayer, not v99)) then
										return "spear_of_bastion main 30";
									end
								end
								if (((119 + 986) <= (1679 - (74 + 429))) and v91.ChampionsSpear:IsCastable() and (v83 == "cursor") and v45 and ((v55 and v29) or not v55) and v13:BuffUp(v91.EnrageBuff) and ((v13:BuffUp(v91.FuriousBloodthirstBuff) and v91.TitansTorment:IsAvailable()) or not v91.TitansTorment:IsAvailable() or (v96 < (38 - 18)) or (v98 > (1 + 0)) or not v13:HasTier(70 - 39, 2 + 0))) then
									if (((10416 - 7037) <= (9425 - 5613)) and v23(v93.ChampionsSpearCursor, not v14:IsInRange(463 - (279 + 154)))) then
										return "spear_of_bastion main 31";
									end
								end
							end
							if ((v37 and v91.HeroicThrow:IsCastable() and not v14:IsInRange(808 - (454 + 324))) or ((620 + 168) >= (1633 - (12 + 5)))) then
								if (((1000 + 854) <= (8609 - 5230)) and v23(v91.HeroicThrow, not v14:IsInRange(12 + 18))) then
									return "heroic_throw main";
								end
							end
							if (((5642 - (277 + 816)) == (19438 - 14889)) and v91.WreckingThrow:IsCastable() and v48 and v14:AffectingCombat() and v100()) then
								if (v23(v91.WreckingThrow, not v14:IsInRange(1213 - (1058 + 125))) or ((567 + 2455) >= (3999 - (815 + 160)))) then
									return "wrecking_throw main";
								end
							end
							v174 = 8 - 6;
						end
						if (((11442 - 6622) > (525 + 1673)) and ((0 - 0) == v174)) then
							if ((v34 and v91.Charge:IsCastable()) or ((2959 - (41 + 1857)) >= (6784 - (1222 + 671)))) then
								if (((3525 - 2161) <= (6428 - 1955)) and v23(v91.Charge, not v14:IsSpellInRange(v91.Charge))) then
									return "charge main 2";
								end
							end
							v175 = v90.HandleDPSPotion(v14:BuffUp(v91.RecklessnessBuff));
							if (v175 or ((4777 - (229 + 953)) <= (1777 - (1111 + 663)))) then
								return v175;
							end
							if ((v89 < v96) or ((6251 - (874 + 705)) == (540 + 3312))) then
								if (((1064 + 495) == (3240 - 1681)) and v50 and ((v29 and v58) or not v58)) then
									v26 = v102();
									if (v26 or ((50 + 1702) <= (1467 - (642 + 37)))) then
										return v26;
									end
								end
							end
							v174 = 1 + 0;
						end
					end
				end
				break;
			end
			if ((v119 == (0 + 0)) or ((9809 - 5902) == (631 - (233 + 221)))) then
				v26 = v101();
				if (((8024 - 4554) > (489 + 66)) and v26) then
					return v26;
				end
				v119 = 1542 - (718 + 823);
			end
		end
	end
	local function v108()
		local v120 = 0 + 0;
		while true do
			if ((v120 == (807 - (266 + 539))) or ((2751 - 1779) == (1870 - (636 + 589)))) then
				v40 = EpicSettings.Settings['useRagingBlow'];
				v41 = EpicSettings.Settings['useRampage'];
				v44 = EpicSettings.Settings['useSlam'];
				v47 = EpicSettings.Settings['useWhirlwind'];
				v120 = 6 - 3;
			end
			if (((6562 - 3380) >= (1677 + 438)) and (v120 == (2 + 2))) then
				v43 = EpicSettings.Settings['useRecklessness'];
				v45 = EpicSettings.Settings['useChampionsSpear'];
				v46 = EpicSettings.Settings['useThunderousRoar'];
				v51 = EpicSettings.Settings['avatarWithCD'];
				v120 = 1020 - (657 + 358);
			end
			if (((10307 - 6414) < (10090 - 5661)) and (v120 == (1190 - (1151 + 36)))) then
				v48 = EpicSettings.Settings['useWreckingThrow'];
				v30 = EpicSettings.Settings['useAvatar'];
				v38 = EpicSettings.Settings['useOdynsFury'];
				v42 = EpicSettings.Settings['useRavager'];
				v120 = 4 + 0;
			end
			if ((v120 == (2 + 4)) or ((8561 - 5694) < (3737 - (1552 + 280)))) then
				v56 = EpicSettings.Settings['thunderousRoarWithCD'];
				break;
			end
			if ((v120 == (839 - (64 + 770))) or ((1220 + 576) >= (9195 - 5144))) then
				v52 = EpicSettings.Settings['odynFuryWithCD'];
				v53 = EpicSettings.Settings['ravagerWithCD'];
				v54 = EpicSettings.Settings['recklessnessWithCD'];
				v55 = EpicSettings.Settings['championsSpearWithCD'];
				v120 = 2 + 4;
			end
			if (((2862 - (157 + 1086)) <= (7517 - 3761)) and (v120 == (0 - 0))) then
				v31 = EpicSettings.Settings['useBattleShout'];
				v32 = EpicSettings.Settings['useBloodbath'];
				v33 = EpicSettings.Settings['useBloodthirst'];
				v34 = EpicSettings.Settings['useCharge'];
				v120 = 1 - 0;
			end
			if (((824 - 220) == (1423 - (599 + 220))) and (v120 == (1 - 0))) then
				v35 = EpicSettings.Settings['useCrushingBlow'];
				v36 = EpicSettings.Settings['useExecute'];
				v37 = EpicSettings.Settings['useHeroicThrow'];
				v39 = EpicSettings.Settings['useOnslaught'];
				v120 = 1933 - (1813 + 118);
			end
		end
	end
	local function v109()
		v59 = EpicSettings.Settings['usePummel'];
		v60 = EpicSettings.Settings['useStormBolt'];
		v61 = EpicSettings.Settings['useIntimidatingShout'];
		v62 = EpicSettings.Settings['useBitterImmunity'];
		v63 = EpicSettings.Settings['useEnragedRegeneration'];
		v64 = EpicSettings.Settings['useIgnorePain'];
		v65 = EpicSettings.Settings['useRallyingCry'];
		v66 = EpicSettings.Settings['useIntervene'];
		v67 = EpicSettings.Settings['useDefensiveStance'];
		v70 = EpicSettings.Settings['useVictoryRush'];
		v71 = EpicSettings.Settings['bitterImmunityHP'] or (0 + 0);
		v72 = EpicSettings.Settings['enragedRegenerationHP'] or (1217 - (841 + 376));
		v73 = EpicSettings.Settings['ignorePainHP'] or (0 - 0);
		v74 = EpicSettings.Settings['rallyingCryHP'] or (0 + 0);
		v75 = EpicSettings.Settings['rallyingCryGroup'] or (0 - 0);
		v76 = EpicSettings.Settings['interveneHP'] or (859 - (464 + 395));
		v77 = EpicSettings.Settings['defensiveStanceHP'] or (0 - 0);
		v80 = EpicSettings.Settings['unstanceHP'] or (0 + 0);
		v81 = EpicSettings.Settings['victoryRushHP'] or (837 - (467 + 370));
		v82 = EpicSettings.Settings['ravagerSetting'] or "player";
		v83 = EpicSettings.Settings['spearSetting'] or "player";
	end
	local function v110()
		local v131 = 0 - 0;
		while true do
			if ((v131 == (0 + 0)) or ((15371 - 10887) == (141 + 759))) then
				v89 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v86 = EpicSettings.Settings['InterruptWithStun'];
				v87 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v88 = EpicSettings.Settings['InterruptThreshold'];
				v131 = 521 - (150 + 370);
			end
			if ((v131 == (1285 - (74 + 1208))) or ((10967 - 6508) <= (5278 - 4165))) then
				v85 = EpicSettings.Settings['HealingPotionName'] or "";
				v84 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((2585 + 1047) > (3788 - (14 + 376))) and ((3 - 1) == v131)) then
				v68 = EpicSettings.Settings['useHealthstone'];
				v69 = EpicSettings.Settings['useHealingPotion'];
				v78 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v79 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v131 = 3 + 0;
			end
			if (((11960 - 7878) <= (3700 + 1217)) and (v131 == (79 - (23 + 55)))) then
				v50 = EpicSettings.Settings['useTrinkets'];
				v49 = EpicSettings.Settings['useRacials'];
				v58 = EpicSettings.Settings['trinketsWithCD'];
				v57 = EpicSettings.Settings['racialsWithCD'];
				v131 = 4 - 2;
			end
		end
	end
	local function v111()
		local v132 = 0 + 0;
		while true do
			if (((4340 + 492) >= (2148 - 762)) and (v132 == (1 + 0))) then
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				if (((1038 - (652 + 249)) == (366 - 229)) and v13:IsDeadOrGhost()) then
					return v26;
				end
				if (v28 or ((3438 - (708 + 1160)) >= (11758 - 7426))) then
					local v176 = 0 - 0;
					while true do
						if ((v176 == (27 - (10 + 17))) or ((913 + 3151) <= (3551 - (1400 + 332)))) then
							v97 = v13:GetEnemiesInMeleeRange(15 - 7);
							v98 = #v97;
							break;
						end
					end
				else
					v98 = 1909 - (242 + 1666);
				end
				v132 = 1 + 1;
			end
			if ((v132 == (1 + 1)) or ((4250 + 736) < (2514 - (850 + 90)))) then
				v99 = v14:IsInMeleeRange(8 - 3);
				if (((5816 - (360 + 1030)) > (153 + 19)) and (v90.TargetIsValid() or v13:AffectingCombat())) then
					v95 = v9.BossFightRemains(nil, true);
					v96 = v95;
					if (((1653 - 1067) > (625 - 170)) and (v96 == (12772 - (909 + 752)))) then
						v96 = v9.FightRemains(v97, false);
					end
				end
				if (((2049 - (109 + 1114)) == (1511 - 685)) and not v13:IsChanneling()) then
					if (v13:AffectingCombat() or ((1565 + 2454) > (4683 - (6 + 236)))) then
						v26 = v107();
						if (((1271 + 746) < (3430 + 831)) and v26) then
							return v26;
						end
					else
						local v178 = 0 - 0;
						while true do
							if (((8237 - 3521) > (1213 - (1076 + 57))) and (v178 == (0 + 0))) then
								v26 = v104();
								if (v26 or ((4196 - (579 + 110)) == (259 + 3013))) then
									return v26;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v132 == (0 + 0)) or ((465 + 411) >= (3482 - (174 + 233)))) then
				v109();
				v108();
				v110();
				v27 = EpicSettings.Toggles['ooc'];
				v132 = 2 - 1;
			end
		end
	end
	local function v112()
		v19.Print("Fury Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(126 - 54, v111, v112);
end;
return v0["Epix_Warrior_Fury.lua"]();

