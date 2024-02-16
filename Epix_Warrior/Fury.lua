local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((2478 - (455 + 974)) < (3456 - 1539)) and not v5) then
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
	local v95 = 11794 - (27 + 656);
	local v96 = 9708 + 1403;
	v9:RegisterForEvent(function()
		local v113 = 0 + 0;
		while true do
			if (((1570 + 1266) > (87 + 407)) and (v113 == (0 - 0))) then
				v95 = 13022 - (340 + 1571);
				v96 = 4383 + 6728;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v97, v98;
	local v99;
	local function v100()
		local v114 = 1772 - (1733 + 39);
		local v115;
		while true do
			if ((v114 == (0 - 0)) or ((3760 - (125 + 909)) == (5817 - (1096 + 852)))) then
				v115 = UnitGetTotalAbsorbs(v14:ID());
				if ((v115 > (0 + 0)) or ((6248 - 1872) <= (1437 + 44))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v101()
		if ((v91.BitterImmunity:IsReady() and v62 and (v13:HealthPercentage() <= v71)) or ((3904 - (409 + 103)) >= (4977 - (46 + 190)))) then
			if (((3420 - (51 + 44)) >= (608 + 1546)) and v23(v91.BitterImmunity)) then
				return "bitter_immunity defensive";
			end
		end
		if ((v91.EnragedRegeneration:IsCastable() and v63 and (v13:HealthPercentage() <= v72)) or ((2612 - (1114 + 203)) >= (3959 - (228 + 498)))) then
			if (((949 + 3428) > (908 + 734)) and v23(v91.EnragedRegeneration)) then
				return "enraged_regeneration defensive";
			end
		end
		if (((5386 - (174 + 489)) > (3532 - 2176)) and v91.IgnorePain:IsCastable() and v64 and (v13:HealthPercentage() <= v73)) then
			if (v23(v91.IgnorePain, nil, nil, true) or ((6041 - (830 + 1075)) <= (3957 - (303 + 221)))) then
				return "ignore_pain defensive";
			end
		end
		if (((5514 - (231 + 1038)) <= (3860 + 771)) and v91.RallyingCry:IsCastable() and v65 and v13:BuffDown(v91.AspectsFavorBuff) and v13:BuffDown(v91.RallyingCry) and (((v13:HealthPercentage() <= v74) and v90.IsSoloMode()) or v90.AreUnitsBelowHealthPercentage(v74, v75))) then
			if (((5438 - (171 + 991)) >= (16130 - 12216)) and v23(v91.RallyingCry)) then
				return "rallying_cry defensive";
			end
		end
		if (((531 - 333) <= (10892 - 6527)) and v91.Intervene:IsCastable() and v66 and (v16:HealthPercentage() <= v76) and (v16:Name() ~= v13:Name())) then
			if (((3828 + 954) > (16391 - 11715)) and v23(v93.InterveneFocus)) then
				return "intervene defensive";
			end
		end
		if (((14031 - 9167) > (3540 - 1343)) and v91.DefensiveStance:IsCastable() and v67 and (v13:HealthPercentage() <= v77) and v13:BuffDown(v91.DefensiveStance, true)) then
			if (v23(v91.DefensiveStance) or ((11437 - 7737) == (3755 - (111 + 1137)))) then
				return "defensive_stance defensive";
			end
		end
		if (((4632 - (91 + 67)) >= (815 - 541)) and v91.BerserkerStance:IsCastable() and v67 and (v13:HealthPercentage() > v80) and v13:BuffDown(v91.BerserkerStance, true)) then
			if (v23(v91.BerserkerStance) or ((473 + 1421) <= (1929 - (423 + 100)))) then
				return "berserker_stance after defensive stance defensive";
			end
		end
		if (((12 + 1560) >= (4238 - 2707)) and v92.Healthstone:IsReady() and v68 and (v13:HealthPercentage() <= v78)) then
			if (v23(v93.Healthstone) or ((2443 + 2244) < (5313 - (326 + 445)))) then
				return "healthstone defensive 3";
			end
		end
		if (((14361 - 11070) > (3713 - 2046)) and v69 and (v13:HealthPercentage() <= v79)) then
			local v124 = 0 - 0;
			while true do
				if ((v124 == (711 - (530 + 181))) or ((1754 - (614 + 267)) == (2066 - (19 + 13)))) then
					if ((v85 == "Refreshing Healing Potion") or ((4582 - 1766) < (25 - 14))) then
						if (((10566 - 6867) < (1223 + 3483)) and v92.RefreshingHealingPotion:IsReady()) then
							if (((4652 - 2006) >= (1816 - 940)) and v23(v93.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((2426 - (1293 + 519)) <= (6495 - 3311)) and (v85 == "Dreamwalker's Healing Potion")) then
						if (((8161 - 5035) == (5977 - 2851)) and v92.DreamwalkersHealingPotion:IsReady()) then
							if (v23(v93.RefreshingHealingPotion) or ((9430 - 7243) >= (11670 - 6716))) then
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
		v26 = v90.HandleTopTrinket(v94, v29, 22 + 18, nil);
		if (v26 or ((791 + 3086) == (8306 - 4731))) then
			return v26;
		end
		v26 = v90.HandleBottomTrinket(v94, v29, 10 + 30, nil);
		if (((235 + 472) > (395 + 237)) and v26) then
			return v26;
		end
	end
	local function v103()
		if ((v30 and ((v51 and v29) or not v51) and (v89 < v96) and v91.Avatar:IsCastable() and not v91.TitansTorment:IsAvailable()) or ((1642 - (709 + 387)) >= (4542 - (673 + 1185)))) then
			if (((4248 - 2783) <= (13811 - 9510)) and v23(v91.Avatar, not v99)) then
				return "avatar precombat 6";
			end
		end
		if (((2803 - 1099) > (1020 + 405)) and v43 and ((v54 and v29) or not v54) and (v89 < v96) and v91.Recklessness:IsCastable() and not v91.RecklessAbandon:IsAvailable()) then
			if (v23(v91.Recklessness, not v99) or ((514 + 173) == (5716 - 1482))) then
				return "recklessness precombat 8";
			end
		end
		if ((v91.Bloodthirst:IsCastable() and v33 and v99) or ((818 + 2512) < (2848 - 1419))) then
			if (((2251 - 1104) >= (2215 - (446 + 1434))) and v23(v91.Bloodthirst, not v99)) then
				return "bloodthirst precombat 10";
			end
		end
		if (((4718 - (1040 + 243)) > (6258 - 4161)) and v34 and v91.Charge:IsReady() and not v99) then
			if (v23(v91.Charge, not v14:IsSpellInRange(v91.Charge)) or ((5617 - (559 + 1288)) >= (5972 - (609 + 1322)))) then
				return "charge precombat 12";
			end
		end
	end
	local function v104()
		local v116 = 454 - (13 + 441);
		while true do
			if ((v116 == (0 - 0)) or ((9929 - 6138) <= (8023 - 6412))) then
				if (not v13:AffectingCombat() or ((171 + 4407) <= (7292 - 5284))) then
					if (((400 + 725) <= (910 + 1166)) and v91.BerserkerStance:IsCastable() and v13:BuffDown(v91.BerserkerStance, true)) then
						if (v23(v91.BerserkerStance) or ((2204 - 1461) >= (2408 + 1991))) then
							return "berserker_stance";
						end
					end
					if (((2123 - 968) < (1107 + 566)) and v91.BattleShout:IsCastable() and v31 and (v13:BuffDown(v91.BattleShoutBuff, true) or v90.GroupBuffMissing(v91.BattleShoutBuff))) then
						if (v23(v91.BattleShout) or ((1293 + 1031) <= (416 + 162))) then
							return "battle_shout precombat";
						end
					end
				end
				if (((3163 + 604) == (3686 + 81)) and v90.TargetIsValid() and v27) then
					if (((4522 - (153 + 280)) == (11807 - 7718)) and not v13:AffectingCombat()) then
						v26 = v103();
						if (((4003 + 455) >= (661 + 1013)) and v26) then
							return v26;
						end
					end
				end
				break;
			end
		end
	end
	local function v105()
		if (((509 + 463) <= (1287 + 131)) and v91.Whirlwind:IsCastable() and v47 and (v98 > (1 + 0)) and v91.ImprovedWhilwind:IsAvailable() and v13:BuffDown(v91.MeatCleaverBuff)) then
			if (v23(v91.Whirlwind, not v14:IsInMeleeRange(11 - 3)) or ((3052 + 1886) < (5429 - (89 + 578)))) then
				return "whirlwind single_target 2";
			end
		end
		if ((v91.Execute:IsReady() and v36 and v13:BuffUp(v91.AshenJuggernautBuff) and (v13:BuffRemains(v91.AshenJuggernautBuff) < v13:GCD())) or ((1789 + 715) > (8864 - 4600))) then
			if (((3202 - (572 + 477)) == (291 + 1862)) and v23(v91.Execute, not v99)) then
				return "execute single_target 4";
			end
		end
		if ((v38 and ((v52 and v29) or not v52) and v91.OdynsFury:IsCastable() and (v89 < v96) and v13:BuffUp(v91.EnrageBuff) and ((v91.DancingBlades:IsAvailable() and (v13:BuffRemains(v91.DancingBladesBuff) < (4 + 1))) or not v91.DancingBlades:IsAvailable())) or ((61 + 446) >= (2677 - (84 + 2)))) then
			if (((7384 - 2903) == (3229 + 1252)) and v23(v91.OdynsFury, not v14:IsInMeleeRange(850 - (497 + 345)))) then
				return "odyns_fury single_target 6";
			end
		end
		if ((v91.Rampage:IsReady() and v41 and v91.AngerManagement:IsAvailable() and (v13:BuffUp(v91.RecklessnessBuff) or (v13:BuffRemains(v91.EnrageBuff) < v13:GCD()) or (v13:RagePercentage() > (3 + 82)))) or ((394 + 1934) < (2026 - (605 + 728)))) then
			if (((3088 + 1240) == (9622 - 5294)) and v23(v91.Rampage, not v99)) then
				return "rampage single_target 8";
			end
		end
		local v117 = v13:CritChancePct() + (v24(v13:BuffUp(v91.RecklessnessBuff)) * (1 + 19)) + (v13:BuffStack(v91.MercilessAssaultBuff) * (36 - 26)) + (v13:BuffStack(v91.BloodcrazeBuff) * (14 + 1));
		if (((4399 - 2811) >= (1006 + 326)) and v91.Bloodbath:IsCastable() and v32 and v13:HasTier(519 - (457 + 32), 2 + 2) and (v117 >= (1497 - (832 + 570)))) then
			if (v23(v91.Bloodbath, not v99) or ((3933 + 241) > (1108 + 3140))) then
				return "bloodbath single_target 10";
			end
		end
		if ((v91.Bloodthirst:IsCastable() and v33 and ((v13:HasTier(106 - 76, 2 + 2) and (v117 >= (891 - (588 + 208)))) or (not v91.RecklessAbandon:IsAvailable() and v13:BuffUp(v91.FuriousBloodthirstBuff) and v13:BuffUp(v91.EnrageBuff) and (v14:DebuffDown(v91.GushingWoundDebuff) or v13:BuffUp(v91.ChampionsMightBuff))))) or ((12360 - 7774) <= (1882 - (884 + 916)))) then
			if (((8087 - 4224) == (2240 + 1623)) and v23(v91.Bloodthirst, not v99)) then
				return "bloodthirst single_target 12";
			end
		end
		if ((v91.Bloodbath:IsCastable() and v32 and v13:HasTier(684 - (232 + 421), 1891 - (1569 + 320))) or ((70 + 212) <= (8 + 34))) then
			if (((15531 - 10922) >= (1371 - (316 + 289))) and v23(v91.Bloodbath, not v99)) then
				return "bloodbath single_target 14";
			end
		end
		if ((v46 and ((v56 and v29) or not v56) and (v89 < v96) and v91.ThunderousRoar:IsCastable() and v13:BuffUp(v91.EnrageBuff)) or ((3015 - 1863) == (115 + 2373))) then
			if (((4875 - (666 + 787)) > (3775 - (360 + 65))) and v23(v91.ThunderousRoar, not v14:IsInMeleeRange(8 + 0))) then
				return "thunderous_roar single_target 16";
			end
		end
		if (((1131 - (79 + 175)) > (592 - 216)) and v91.Onslaught:IsReady() and v39 and (v13:BuffUp(v91.EnrageBuff) or v91.Tenderize:IsAvailable())) then
			if (v23(v91.Onslaught, not v99) or ((2434 + 684) <= (5673 - 3822))) then
				return "onslaught single_target 18";
			end
		end
		if ((v91.CrushingBlow:IsCastable() and v35 and v91.WrathandFury:IsAvailable() and v13:BuffUp(v91.EnrageBuff) and v13:BuffDown(v91.FuriousBloodthirstBuff)) or ((317 - 152) >= (4391 - (503 + 396)))) then
			if (((4130 - (92 + 89)) < (9419 - 4563)) and v23(v91.CrushingBlow, not v99)) then
				return "crushing_blow single_target 20";
			end
		end
		if ((v91.Execute:IsReady() and v36 and ((v13:BuffUp(v91.EnrageBuff) and v13:BuffDown(v91.FuriousBloodthirstBuff) and v13:BuffUp(v91.AshenJuggernautBuff)) or ((v13:BuffRemains(v91.SuddenDeathBuff) <= v13:GCD()) and (((v14:HealthPercentage() > (18 + 17)) and v91.Massacre:IsAvailable()) or (v14:HealthPercentage() > (12 + 8)))))) or ((16745 - 12469) < (413 + 2603))) then
			if (((10693 - 6003) > (3600 + 525)) and v23(v91.Execute, not v99)) then
				return "execute single_target 22";
			end
		end
		if ((v91.Rampage:IsReady() and v41 and v91.RecklessAbandon:IsAvailable() and (v13:BuffUp(v91.RecklessnessBuff) or (v13:BuffRemains(v91.EnrageBuff) < v13:GCD()) or (v13:RagePercentage() > (41 + 44)))) or ((152 - 102) >= (112 + 784))) then
			if (v23(v91.Rampage, not v99) or ((2613 - 899) >= (4202 - (485 + 759)))) then
				return "rampage single_target 24";
			end
		end
		if ((v91.Execute:IsReady() and v36 and v13:BuffUp(v91.EnrageBuff)) or ((3449 - 1958) < (1833 - (442 + 747)))) then
			if (((1839 - (832 + 303)) < (1933 - (88 + 858))) and v23(v91.Execute, not v99)) then
				return "execute single_target 26";
			end
		end
		if (((1134 + 2584) > (1578 + 328)) and v91.Rampage:IsReady() and v41 and v91.AngerManagement:IsAvailable()) then
			if (v23(v91.Rampage, not v99) or ((40 + 918) > (4424 - (766 + 23)))) then
				return "rampage single_target 28";
			end
		end
		if (((17283 - 13782) <= (6142 - 1650)) and v91.Execute:IsReady() and v36) then
			if (v23(v91.Execute, not v99) or ((9068 - 5626) < (8647 - 6099))) then
				return "execute single_target 29";
			end
		end
		if (((3948 - (1036 + 37)) >= (1038 + 426)) and v91.Bloodbath:IsCastable() and v32 and v13:BuffUp(v91.EnrageBuff) and v91.RecklessAbandon:IsAvailable() and not v91.WrathandFury:IsAvailable()) then
			if (v23(v91.Bloodbath, not v99) or ((9341 - 4544) >= (3849 + 1044))) then
				return "bloodbath single_target 30";
			end
		end
		if ((v91.Rampage:IsReady() and v41 and (v14:HealthPercentage() < (1515 - (641 + 839))) and v91.Massacre:IsAvailable()) or ((1464 - (910 + 3)) > (5271 - 3203))) then
			if (((3798 - (1466 + 218)) > (434 + 510)) and v23(v91.Rampage, not v99)) then
				return "rampage single_target 32";
			end
		end
		if ((v91.Bloodthirst:IsCastable() and v33 and (not v13:BuffUp(v91.EnrageBuff) or (v91.Annihilator:IsAvailable() and v13:BuffDown(v91.RecklessnessBuff))) and v13:BuffDown(v91.FuriousBloodthirstBuff)) or ((3410 - (556 + 592)) >= (1101 + 1995))) then
			if (v23(v91.Bloodthirst, not v99) or ((3063 - (329 + 479)) >= (4391 - (174 + 680)))) then
				return "bloodthirst single_target 34";
			end
		end
		if ((v91.RagingBlow:IsCastable() and v40 and (v91.RagingBlow:Charges() > (3 - 2)) and v91.WrathandFury:IsAvailable()) or ((7953 - 4116) < (933 + 373))) then
			if (((3689 - (396 + 343)) == (262 + 2688)) and v23(v91.RagingBlow, not v99)) then
				return "raging_blow single_target 36";
			end
		end
		if ((v91.CrushingBlow:IsCastable() and v35 and (v91.CrushingBlow:Charges() > (1478 - (29 + 1448))) and v91.WrathandFury:IsAvailable() and v13:BuffDown(v91.FuriousBloodthirstBuff)) or ((6112 - (135 + 1254)) < (12424 - 9126))) then
			if (((5304 - 4168) >= (103 + 51)) and v23(v91.CrushingBlow, not v99)) then
				return "crushing_blow single_target 38";
			end
		end
		if ((v91.Bloodbath:IsCastable() and v32 and (not v13:BuffUp(v91.EnrageBuff) or not v91.WrathandFury:IsAvailable())) or ((1798 - (389 + 1138)) > (5322 - (102 + 472)))) then
			if (((4474 + 266) >= (1748 + 1404)) and v23(v91.Bloodbath, not v99)) then
				return "bloodbath single_target 40";
			end
		end
		if ((v91.CrushingBlow:IsCastable() and v35 and v13:BuffUp(v91.EnrageBuff) and v91.RecklessAbandon:IsAvailable() and v13:BuffDown(v91.FuriousBloodthirstBuff)) or ((2404 + 174) >= (4935 - (320 + 1225)))) then
			if (((72 - 31) <= (1017 + 644)) and v23(v91.CrushingBlow, not v99)) then
				return "crushing_blow single_target 42";
			end
		end
		if (((2065 - (157 + 1307)) < (5419 - (821 + 1038))) and v91.Bloodthirst:IsCastable() and v33 and not v91.WrathandFury:IsAvailable() and v13:BuffDown(v91.FuriousBloodthirstBuff)) then
			if (((586 - 351) < (76 + 611)) and v23(v91.Bloodthirst, not v99)) then
				return "bloodthirst single_target 44";
			end
		end
		if (((8079 - 3530) > (429 + 724)) and v91.RagingBlow:IsCastable() and v40 and (v91.RagingBlow:Charges() > (2 - 1))) then
			if (v23(v91.RagingBlow, not v99) or ((5700 - (834 + 192)) < (298 + 4374))) then
				return "raging_blow single_target 46";
			end
		end
		if (((942 + 2726) < (98 + 4463)) and v91.Rampage:IsReady() and v41) then
			if (v23(v91.Rampage, not v99) or ((704 - 249) == (3909 - (300 + 4)))) then
				return "rampage single_target 47";
			end
		end
		if ((v91.Slam:IsReady() and v44 and (v91.Annihilator:IsAvailable())) or ((712 + 1951) == (8669 - 5357))) then
			if (((4639 - (112 + 250)) <= (1784 + 2691)) and v23(v91.Slam, not v99)) then
				return "slam single_target 48";
			end
		end
		if ((v91.Bloodbath:IsCastable() and v32) or ((2179 - 1309) == (682 + 507))) then
			if (((804 + 749) <= (2344 + 789)) and v23(v91.Bloodbath, not v99)) then
				return "bloodbath single_target 50";
			end
		end
		if ((v91.RagingBlow:IsCastable() and v40) or ((1110 + 1127) >= (2609 + 902))) then
			if (v23(v91.RagingBlow, not v99) or ((2738 - (1001 + 413)) > (6734 - 3714))) then
				return "raging_blow single_target 52";
			end
		end
		if ((v91.CrushingBlow:IsCastable() and v35 and v13:BuffDown(v91.FuriousBloodthirstBuff)) or ((3874 - (244 + 638)) == (2574 - (627 + 66)))) then
			if (((9254 - 6148) > (2128 - (512 + 90))) and v23(v91.CrushingBlow, not v99)) then
				return "crushing_blow single_target 54";
			end
		end
		if (((4929 - (1665 + 241)) < (4587 - (373 + 344))) and v91.Bloodthirst:IsCastable() and v33) then
			if (((65 + 78) > (20 + 54)) and v23(v91.Bloodthirst, not v99)) then
				return "bloodthirst single_target 56";
			end
		end
		if (((47 - 29) < (3573 - 1461)) and v28 and v91.Whirlwind:IsCastable() and v47) then
			if (((2196 - (35 + 1064)) <= (1185 + 443)) and v23(v91.Whirlwind, not v14:IsInMeleeRange(16 - 8))) then
				return "whirlwind single_target 58";
			end
		end
	end
	local function v106()
		local v118 = 0 + 0;
		local v119;
		while true do
			if (((5866 - (298 + 938)) == (5889 - (233 + 1026))) and (v118 == (1667 - (636 + 1030)))) then
				if (((1810 + 1730) > (2621 + 62)) and v91.ThunderousRoar:IsCastable() and ((v56 and v29) or not v56) and v46 and (v89 < v96) and v13:BuffUp(v91.EnrageBuff)) then
					if (((1425 + 3369) >= (222 + 3053)) and v23(v91.ThunderousRoar, not v14:IsInMeleeRange(229 - (55 + 166)))) then
						return "thunderous_roar multi_target 10";
					end
				end
				if (((288 + 1196) == (150 + 1334)) and v91.OdynsFury:IsCastable() and ((v52 and v29) or not v52) and v38 and (v89 < v96) and (v98 > (3 - 2)) and v13:BuffUp(v91.EnrageBuff)) then
					if (((1729 - (36 + 261)) < (6216 - 2661)) and v23(v91.OdynsFury, not v14:IsInMeleeRange(1376 - (34 + 1334)))) then
						return "odyns_fury multi_target 12";
					end
				end
				v119 = v13:CritChancePct() + (v24(v13:BuffUp(v91.RecklessnessBuff)) * (8 + 12)) + (v13:BuffStack(v91.MercilessAssaultBuff) * (8 + 2)) + (v13:BuffStack(v91.BloodcrazeBuff) * (1298 - (1035 + 248)));
				if ((v91.Bloodbath:IsCastable() and v32 and v13:HasTier(51 - (20 + 1), 3 + 1) and (v119 >= (414 - (134 + 185)))) or ((2198 - (549 + 584)) > (4263 - (314 + 371)))) then
					if (v23(v91.Bloodbath, not v99) or ((16460 - 11665) < (2375 - (478 + 490)))) then
						return "bloodbath multi_target 14";
					end
				end
				v118 = 2 + 0;
			end
			if (((3025 - (786 + 386)) < (15589 - 10776)) and (v118 == (1382 - (1055 + 324)))) then
				if ((v91.Rampage:IsReady() and v41 and (v13:BuffUp(v91.RecklessnessBuff) or (v13:BuffRemains(v91.EnrageBuff) < v13:GCD()) or ((v13:Rage() > (1450 - (1093 + 247))) and v91.OverwhelmingRage:IsAvailable()) or ((v13:Rage() > (72 + 8)) and not v91.OverwhelmingRage:IsAvailable()))) or ((297 + 2524) < (9651 - 7220))) then
					if (v23(v91.Rampage, not v99) or ((9753 - 6879) < (6205 - 4024))) then
						return "rampage multi_target 20";
					end
				end
				if ((v91.Execute:IsReady() and v36) or ((6757 - 4068) <= (123 + 220))) then
					if (v23(v91.Execute, not v99) or ((7200 - 5331) == (6924 - 4915))) then
						return "execute multi_target 22";
					end
				end
				if ((v91.Bloodbath:IsCastable() and v32 and v13:BuffUp(v91.EnrageBuff) and v91.RecklessAbandon:IsAvailable() and not v91.WrathandFury:IsAvailable()) or ((2674 + 872) < (5938 - 3616))) then
					if (v23(v91.Bloodbath, not v99) or ((2770 - (364 + 324)) == (13084 - 8311))) then
						return "bloodbath multi_target 24";
					end
				end
				if (((7784 - 4540) > (350 + 705)) and v91.Bloodthirst:IsCastable() and v33 and (not v13:BuffUp(v91.EnrageBuff) or (v91.Annihilator:IsAvailable() and v13:BuffDown(v91.RecklessnessBuff)))) then
					if (v23(v91.Bloodthirst, not v99) or ((13862 - 10549) <= (2847 - 1069))) then
						return "bloodthirst multi_target 26";
					end
				end
				v118 = 11 - 7;
			end
			if ((v118 == (1274 - (1249 + 19))) or ((1283 + 138) >= (8189 - 6085))) then
				if (((2898 - (686 + 400)) <= (2550 + 699)) and v91.Slam:IsReady() and v44 and (v91.Annihilator:IsAvailable())) then
					if (((1852 - (73 + 156)) <= (10 + 1947)) and v23(v91.Slam, not v99)) then
						return "slam multi_target 44";
					end
				end
				if (((5223 - (721 + 90)) == (50 + 4362)) and v91.Bloodbath:IsCastable() and v32) then
					if (((5682 - 3932) >= (1312 - (224 + 246))) and v23(v91.Bloodbath, not v99)) then
						return "bloodbath multi_target 46";
					end
				end
				if (((7082 - 2710) > (3406 - 1556)) and v91.RagingBlow:IsCastable() and v40) then
					if (((43 + 189) < (20 + 801)) and v23(v91.RagingBlow, not v99)) then
						return "raging_blow multi_target 48";
					end
				end
				if (((381 + 137) < (1792 - 890)) and v91.CrushingBlow:IsCastable() and v35) then
					if (((9963 - 6969) > (1371 - (203 + 310))) and v23(v91.CrushingBlow, not v99)) then
						return "crushing_blow multi_target 50";
					end
				end
				v118 = 2000 - (1238 + 755);
			end
			if ((v118 == (1 + 6)) or ((5289 - (709 + 825)) <= (1685 - 770))) then
				if (((5747 - 1801) > (4607 - (196 + 668))) and v91.Whirlwind:IsCastable() and v47) then
					if (v23(v91.Whirlwind, not v14:IsInMeleeRange(31 - 23)) or ((2765 - 1430) >= (4139 - (171 + 662)))) then
						return "whirlwind multi_target 52";
					end
				end
				break;
			end
			if (((4937 - (4 + 89)) > (7896 - 5643)) and (v118 == (2 + 3))) then
				if (((1985 - 1533) == (178 + 274)) and v91.CrushingBlow:IsCastable() and v35 and v13:BuffUp(v91.EnrageBuff) and v91.RecklessAbandon:IsAvailable()) then
					if (v23(v91.CrushingBlow, not v99) or ((6043 - (35 + 1451)) < (3540 - (28 + 1425)))) then
						return "crushing_blow multi_target 36";
					end
				end
				if (((5867 - (941 + 1052)) == (3715 + 159)) and v91.Bloodthirst:IsCastable() and v33 and not v91.WrathandFury:IsAvailable()) then
					if (v23(v91.Bloodthirst, not v99) or ((3452 - (822 + 692)) > (7045 - 2110))) then
						return "bloodthirst multi_target 38";
					end
				end
				if ((v91.RagingBlow:IsCastable() and v40 and (v91.RagingBlow:Charges() > (1 + 0))) or ((4552 - (45 + 252)) < (3387 + 36))) then
					if (((501 + 953) <= (6062 - 3571)) and v23(v91.RagingBlow, not v99)) then
						return "raging_blow multi_target 40";
					end
				end
				if ((v91.Rampage:IsReady() and v41) or ((4590 - (114 + 319)) <= (4023 - 1220))) then
					if (((6218 - 1365) >= (1901 + 1081)) and v23(v91.Rampage, not v99)) then
						return "rampage multi_target 42";
					end
				end
				v118 = 8 - 2;
			end
			if (((8661 - 4527) > (5320 - (556 + 1407))) and (v118 == (1206 - (741 + 465)))) then
				if ((v91.Recklessness:IsCastable() and ((v54 and v29) or not v54) and v43 and (v89 < v96) and ((v98 > (466 - (170 + 295))) or (v96 < (7 + 5)))) or ((3139 + 278) < (6238 - 3704))) then
					if (v23(v91.Recklessness, not v99) or ((2257 + 465) <= (106 + 58))) then
						return "recklessness multi_target 2";
					end
				end
				if ((v91.OdynsFury:IsCastable() and ((v52 and v29) or not v52) and v38 and (v89 < v96) and (v98 > (1 + 0)) and v91.TitanicRage:IsAvailable() and (v13:BuffDown(v91.MeatCleaverBuff) or v13:BuffUp(v91.AvatarBuff) or v13:BuffUp(v91.RecklessnessBuff))) or ((3638 - (957 + 273)) < (565 + 1544))) then
					if (v23(v91.OdynsFury, not v14:IsInMeleeRange(4 + 4)) or ((125 - 92) == (3834 - 2379))) then
						return "odyns_fury multi_target 4";
					end
				end
				if ((v91.Whirlwind:IsCastable() and v47 and (v98 > (2 - 1)) and v91.ImprovedWhilwind:IsAvailable() and v13:BuffDown(v91.MeatCleaverBuff)) or ((2193 - 1750) >= (5795 - (389 + 1391)))) then
					if (((2122 + 1260) > (18 + 148)) and v23(v91.Whirlwind, not v14:IsInMeleeRange(18 - 10))) then
						return "whirlwind multi_target 6";
					end
				end
				if ((v91.Execute:IsReady() and v36 and v13:BuffUp(v91.AshenJuggernautBuff) and (v13:BuffRemains(v91.AshenJuggernautBuff) < v13:GCD())) or ((1231 - (783 + 168)) == (10266 - 7207))) then
					if (((1851 + 30) > (1604 - (309 + 2))) and v23(v91.Execute, not v99)) then
						return "execute multi_target 8";
					end
				end
				v118 = 2 - 1;
			end
			if (((3569 - (1090 + 122)) == (765 + 1592)) and (v118 == (13 - 9))) then
				if (((85 + 38) == (1241 - (628 + 490))) and v91.Onslaught:IsReady() and v39 and ((not v91.Annihilator:IsAvailable() and v13:BuffUp(v91.EnrageBuff)) or v91.Tenderize:IsAvailable())) then
					if (v23(v91.Onslaught, not v99) or ((190 + 866) >= (8397 - 5005))) then
						return "onslaught multi_target 28";
					end
				end
				if ((v91.RagingBlow:IsCastable() and v40 and (v91.RagingBlow:Charges() > (4 - 3)) and v91.WrathandFury:IsAvailable()) or ((1855 - (431 + 343)) < (2171 - 1096))) then
					if (v23(v91.RagingBlow, not v99) or ((3034 - 1985) >= (3502 + 930))) then
						return "raging_blow multi_target 30";
					end
				end
				if ((v91.CrushingBlow:IsCastable() and v35 and (v91.CrushingBlow:Charges() > (1 + 0)) and v91.WrathandFury:IsAvailable()) or ((6463 - (556 + 1139)) <= (861 - (6 + 9)))) then
					if (v23(v91.CrushingBlow, not v99) or ((615 + 2743) <= (728 + 692))) then
						return "crushing_blow multi_target 32";
					end
				end
				if ((v91.Bloodbath:IsCastable() and v32 and (not v13:BuffUp(v91.EnrageBuff) or not v91.WrathandFury:IsAvailable())) or ((3908 - (28 + 141)) <= (1164 + 1841))) then
					if (v23(v91.Bloodbath, not v99) or ((2047 - 388) >= (1512 + 622))) then
						return "bloodbath multi_target 34";
					end
				end
				v118 = 1322 - (486 + 831);
			end
			if ((v118 == (5 - 3)) or ((11477 - 8217) < (446 + 1909))) then
				if ((v91.Bloodthirst:IsCastable() and v33 and ((v13:HasTier(94 - 64, 1267 - (668 + 595)) and (v119 >= (86 + 9))) or (not v91.RecklessAbandon:IsAvailable() and v13:BuffUp(v91.FuriousBloodthirstBuff) and v13:BuffUp(v91.EnrageBuff)))) or ((135 + 534) == (11516 - 7293))) then
					if (v23(v91.Bloodthirst, not v99) or ((1982 - (23 + 267)) < (2532 - (1129 + 815)))) then
						return "bloodthirst multi_target 16";
					end
				end
				if ((v91.CrushingBlow:IsCastable() and v91.WrathandFury:IsAvailable() and v35 and v13:BuffUp(v91.EnrageBuff)) or ((5184 - (371 + 16)) < (5401 - (1326 + 424)))) then
					if (v23(v91.CrushingBlow, not v99) or ((7911 - 3734) > (17723 - 12873))) then
						return "crushing_blow multi_target 14";
					end
				end
				if ((v91.Execute:IsReady() and v36 and v13:BuffUp(v91.EnrageBuff)) or ((518 - (88 + 30)) > (1882 - (720 + 51)))) then
					if (((6786 - 3735) > (2781 - (421 + 1355))) and v23(v91.Execute, not v99)) then
						return "execute multi_target 16";
					end
				end
				if (((6092 - 2399) <= (2153 + 2229)) and v91.OdynsFury:IsCastable() and ((v52 and v29) or not v52) and v38 and (v89 < v96) and v13:BuffUp(v91.EnrageBuff)) then
					if (v23(v91.OdynsFury, not v14:IsInMeleeRange(1091 - (286 + 797))) or ((11997 - 8715) > (6791 - 2691))) then
						return "odyns_fury multi_target 18";
					end
				end
				v118 = 442 - (397 + 42);
			end
		end
	end
	local function v107()
		v26 = v101();
		if (v26 or ((1119 + 2461) < (3644 - (24 + 776)))) then
			return v26;
		end
		if (((136 - 47) < (5275 - (222 + 563))) and v84) then
			v26 = v90.HandleIncorporeal(v91.StormBolt, v93.StormBoltMouseover, 44 - 24, true);
			if (v26 or ((3588 + 1395) < (1998 - (23 + 167)))) then
				return v26;
			end
			v26 = v90.HandleIncorporeal(v91.IntimidatingShout, v93.IntimidatingShoutMouseover, 1806 - (690 + 1108), true);
			if (((1382 + 2447) > (3109 + 660)) and v26) then
				return v26;
			end
		end
		if (((2333 - (40 + 808)) <= (479 + 2425)) and v90.TargetIsValid()) then
			local v125 = 0 - 0;
			local v126;
			while true do
				if (((4081 + 188) == (2259 + 2010)) and (v125 == (2 + 0))) then
					if (((958 - (47 + 524)) <= (1806 + 976)) and v28 and (v98 >= (5 - 3))) then
						local v176 = 0 - 0;
						while true do
							if ((v176 == (0 - 0)) or ((3625 - (1165 + 561)) <= (28 + 889))) then
								v26 = v106();
								if (v26 or ((13354 - 9042) <= (335 + 541))) then
									return v26;
								end
								break;
							end
						end
					end
					v26 = v105();
					if (((2711 - (341 + 138)) <= (701 + 1895)) and v26) then
						return v26;
					end
					break;
				end
				if (((4323 - 2228) < (4012 - (89 + 237))) and (v125 == (0 - 0))) then
					if ((v34 and v91.Charge:IsCastable()) or ((3357 - 1762) >= (5355 - (581 + 300)))) then
						if (v23(v91.Charge, not v14:IsSpellInRange(v91.Charge)) or ((5839 - (855 + 365)) < (6845 - 3963))) then
							return "charge main 2";
						end
					end
					v126 = v90.HandleDPSPotion(v14:BuffUp(v91.RecklessnessBuff));
					if (v126 or ((96 + 198) >= (6066 - (1030 + 205)))) then
						return v126;
					end
					if (((1905 + 124) <= (2869 + 215)) and (v89 < v96)) then
						local v177 = 286 - (156 + 130);
						while true do
							if ((v177 == (0 - 0)) or ((3432 - 1395) == (4956 - 2536))) then
								if (((1175 + 3283) > (2277 + 1627)) and v50 and ((v29 and v58) or not v58)) then
									v26 = v102();
									if (((505 - (10 + 59)) >= (35 + 88)) and v26) then
										return v26;
									end
								end
								if (((2462 - 1962) < (2979 - (671 + 492))) and v29 and v92.FyralathTheDreamrender:IsEquippedAndReady()) then
									if (((2846 + 728) == (4789 - (369 + 846))) and v23(v93.UseWeapon)) then
										return "Fyralath The Dreamrender used";
									end
								end
								break;
							end
						end
					end
					v125 = 1 + 0;
				end
				if (((189 + 32) < (2335 - (1036 + 909))) and ((1 + 0) == v125)) then
					if (((v89 < v96) and v49 and ((v57 and v29) or not v57)) or ((3715 - 1502) <= (1624 - (11 + 192)))) then
						local v178 = 0 + 0;
						while true do
							if (((3233 - (135 + 40)) < (11775 - 6915)) and (v178 == (2 + 0))) then
								if (v91.AncestralCall:IsCastable() or ((2854 - 1558) >= (6664 - 2218))) then
									if (v23(v91.AncestralCall, not v99) or ((1569 - (50 + 126)) > (12499 - 8010))) then
										return "ancestral_call main 20";
									end
								end
								if ((v91.BagofTricks:IsCastable() and v13:BuffDown(v91.RecklessnessBuff) and v13:BuffUp(v91.EnrageBuff)) or ((980 + 3444) < (1440 - (1233 + 180)))) then
									if (v23(v91.BagofTricks, not v14:IsSpellInRange(v91.BagofTricks)) or ((2966 - (522 + 447)) > (5236 - (107 + 1314)))) then
										return "bag_of_tricks main 22";
									end
								end
								break;
							end
							if (((1608 + 1857) > (5828 - 3915)) and (v178 == (1 + 0))) then
								if (((1455 - 722) < (7197 - 5378)) and v91.LightsJudgment:IsCastable() and v13:BuffDown(v91.RecklessnessBuff)) then
									if (v23(v91.LightsJudgment, not v14:IsSpellInRange(v91.LightsJudgment)) or ((6305 - (716 + 1194)) == (82 + 4673))) then
										return "lights_judgment main 16";
									end
								end
								if (v91.Fireblood:IsCastable() or ((407 + 3386) < (2872 - (74 + 429)))) then
									if (v23(v91.Fireblood, not v99) or ((7877 - 3793) == (132 + 133))) then
										return "fireblood main 18";
									end
								end
								v178 = 4 - 2;
							end
							if (((3084 + 1274) == (13435 - 9077)) and (v178 == (0 - 0))) then
								if (v91.BloodFury:IsCastable() or ((3571 - (279 + 154)) < (1771 - (454 + 324)))) then
									if (((2620 + 710) > (2340 - (12 + 5))) and v23(v91.BloodFury, not v99)) then
										return "blood_fury main 12";
									end
								end
								if ((v91.Berserking:IsCastable() and v13:BuffUp(v91.RecklessnessBuff)) or ((1955 + 1671) == (10163 - 6174))) then
									if (v23(v91.Berserking, not v99) or ((339 + 577) == (3764 - (277 + 816)))) then
										return "berserking main 14";
									end
								end
								v178 = 4 - 3;
							end
						end
					end
					if (((1455 - (1058 + 125)) == (51 + 221)) and (v89 < v96)) then
						local v179 = 975 - (815 + 160);
						while true do
							if (((18230 - 13981) <= (11486 - 6647)) and (v179 == (0 + 0))) then
								if (((8117 - 5340) < (5098 - (41 + 1857))) and ((v91.Avatar:IsCastable() and v30 and ((v51 and v29) or not v51) and v91.TitansTorment:IsAvailable() and v13:BuffUp(v91.EnrageBuff) and (v89 < v96) and v13:BuffDown(v91.AvatarBuff) and (not v91.OdynsFury:IsAvailable() or (v91.OdynsFury:CooldownRemains() > (1893 - (1222 + 671))))) or (v91.BerserkersTorment:IsAvailable() and v13:BuffUp(v91.EnrageBuff) and v13:BuffDown(v91.AvatarBuff)) or (not v91.TitansTorment:IsAvailable() and not v91.BerserkersTorment:IsAvailable() and (v13:BuffUp(v91.RecklessnessBuff) or (v96 < (51 - 31)))))) then
									if (((136 - 41) < (3139 - (229 + 953))) and v23(v91.Avatar, not v99)) then
										return "avatar main 24";
									end
								end
								if (((2600 - (1111 + 663)) < (3296 - (874 + 705))) and v91.Recklessness:IsCastable() and v43 and ((v54 and v29) or not v54) and (not v91.Annihilator:IsAvailable() or (v91.ChampionsSpear:CooldownRemains() < (1 + 0)) or (v91.Avatar:CooldownRemains() > (28 + 12)) or not v91.Avatar:IsAvailable() or (v96 < (24 - 12)))) then
									if (((41 + 1385) >= (1784 - (642 + 37))) and v23(v91.Recklessness, not v99)) then
										return "recklessness main 26";
									end
								end
								v179 = 1 + 0;
							end
							if (((441 + 2313) <= (8483 - 5104)) and (v179 == (457 - (233 + 221)))) then
								if ((v91.ChampionsSpear:IsCastable() and (v83 == "cursor") and v45 and ((v55 and v29) or not v55) and v13:BuffUp(v91.EnrageBuff) and ((v13:BuffUp(v91.FuriousBloodthirstBuff) and v91.TitansTorment:IsAvailable()) or not v91.TitansTorment:IsAvailable() or (v96 < (46 - 26)) or (v98 > (1 + 0)) or not v13:HasTier(1572 - (718 + 823), 2 + 0))) or ((4732 - (266 + 539)) == (4000 - 2587))) then
									if (v23(v93.ChampionsSpearCursor, not v14:IsInRange(1255 - (636 + 589))) or ((2738 - 1584) <= (1625 - 837))) then
										return "spear_of_bastion main 31";
									end
								end
								break;
							end
							if ((v179 == (2 + 0)) or ((597 + 1046) > (4394 - (657 + 358)))) then
								if ((v91.Ravager:IsCastable() and (v82 == "cursor") and v42 and ((v53 and v29) or not v53) and ((v91.Avatar:CooldownRemains() < (7 - 4)) or v13:BuffUp(v91.RecklessnessBuff) or (v96 < (22 - 12)))) or ((3990 - (1151 + 36)) > (4393 + 156))) then
									if (v23(v93.RavagerCursor, not v99) or ((58 + 162) >= (9024 - 6002))) then
										return "ravager main 28";
									end
								end
								if (((4654 - (1552 + 280)) == (3656 - (64 + 770))) and v91.ChampionsSpear:IsCastable() and (v83 == "player") and v45 and ((v55 and v29) or not v55) and v13:BuffUp(v91.EnrageBuff) and ((v13:BuffUp(v91.FuriousBloodthirstBuff) and v91.TitansTorment:IsAvailable()) or not v91.TitansTorment:IsAvailable() or (v96 < (14 + 6)) or (v98 > (2 - 1)) or not v13:HasTier(6 + 25, 1245 - (157 + 1086)))) then
									if (v23(v93.ChampionsSpearPlayer, not v99) or ((2123 - 1062) == (8133 - 6276))) then
										return "spear_of_bastion main 30";
									end
								end
								v179 = 3 - 0;
							end
							if (((3767 - 1007) > (2183 - (599 + 220))) and (v179 == (1 - 0))) then
								if ((v91.Recklessness:IsCastable() and v43 and ((v54 and v29) or not v54) and (not v91.Annihilator:IsAvailable() or (v96 < (1943 - (1813 + 118))))) or ((3584 + 1318) <= (4812 - (841 + 376)))) then
									if (v23(v91.Recklessness, not v99) or ((5397 - 1545) == (69 + 224))) then
										return "recklessness main 27";
									end
								end
								if ((v91.Ravager:IsCastable() and (v82 == "player") and v42 and ((v53 and v29) or not v53) and ((v91.Avatar:CooldownRemains() < (8 - 5)) or v13:BuffUp(v91.RecklessnessBuff) or (v96 < (869 - (464 + 395))))) or ((4000 - 2441) == (2204 + 2384))) then
									if (v23(v93.RavagerPlayer, not v99) or ((5321 - (467 + 370)) == (1628 - 840))) then
										return "ravager main 28";
									end
								end
								v179 = 2 + 0;
							end
						end
					end
					if (((15659 - 11091) >= (610 + 3297)) and v37 and v91.HeroicThrow:IsCastable() and not v14:IsInRange(58 - 33) and v13:CanAttack(v14)) then
						if (((1766 - (150 + 370)) < (4752 - (74 + 1208))) and v23(v91.HeroicThrow, not v14:IsSpellInRange(v91.HeroicThrow))) then
							return "heroic_throw main";
						end
					end
					if (((10005 - 5937) >= (4609 - 3637)) and v91.WreckingThrow:IsCastable() and v48 and v100() and v13:CanAttack(v14)) then
						if (((351 + 142) < (4283 - (14 + 376))) and v23(v91.WreckingThrow, not v14:IsSpellInRange(v91.WreckingThrow))) then
							return "wrecking_throw main";
						end
					end
					v125 = 3 - 1;
				end
			end
		end
	end
	local function v108()
		local v120 = 0 + 0;
		while true do
			if (((1 + 0) == v120) or ((1405 + 68) >= (9763 - 6431))) then
				v35 = EpicSettings.Settings['useCrushingBlow'];
				v36 = EpicSettings.Settings['useExecute'];
				v37 = EpicSettings.Settings['useHeroicThrow'];
				v39 = EpicSettings.Settings['useOnslaught'];
				v120 = 2 + 0;
			end
			if ((v120 == (83 - (23 + 55))) or ((9600 - 5549) <= (773 + 384))) then
				v52 = EpicSettings.Settings['odynFuryWithCD'];
				v53 = EpicSettings.Settings['ravagerWithCD'];
				v54 = EpicSettings.Settings['recklessnessWithCD'];
				v55 = EpicSettings.Settings['championsSpearWithCD'];
				v120 = 6 + 0;
			end
			if (((935 - 331) < (907 + 1974)) and (v120 == (901 - (652 + 249)))) then
				v31 = EpicSettings.Settings['useBattleShout'];
				v32 = EpicSettings.Settings['useBloodbath'];
				v33 = EpicSettings.Settings['useBloodthirst'];
				v34 = EpicSettings.Settings['useCharge'];
				v120 = 2 - 1;
			end
			if ((v120 == (1871 - (708 + 1160))) or ((2442 - 1542) == (6156 - 2779))) then
				v48 = EpicSettings.Settings['useWreckingThrow'];
				v30 = EpicSettings.Settings['useAvatar'];
				v38 = EpicSettings.Settings['useOdynsFury'];
				v42 = EpicSettings.Settings['useRavager'];
				v120 = 31 - (10 + 17);
			end
			if (((1002 + 3457) > (2323 - (1400 + 332))) and (v120 == (7 - 3))) then
				v43 = EpicSettings.Settings['useRecklessness'];
				v45 = EpicSettings.Settings['useChampionsSpear'];
				v46 = EpicSettings.Settings['useThunderousRoar'];
				v51 = EpicSettings.Settings['avatarWithCD'];
				v120 = 1913 - (242 + 1666);
			end
			if (((1455 + 1943) >= (878 + 1517)) and (v120 == (6 + 0))) then
				v56 = EpicSettings.Settings['thunderousRoarWithCD'];
				break;
			end
			if ((v120 == (942 - (850 + 90))) or ((3822 - 1639) >= (4214 - (360 + 1030)))) then
				v40 = EpicSettings.Settings['useRagingBlow'];
				v41 = EpicSettings.Settings['useRampage'];
				v44 = EpicSettings.Settings['useSlam'];
				v47 = EpicSettings.Settings['useWhirlwind'];
				v120 = 3 + 0;
			end
		end
	end
	local function v109()
		local v121 = 0 - 0;
		while true do
			if (((2662 - 726) == (3597 - (909 + 752))) and ((1229 - (109 + 1114)) == v121)) then
				v81 = EpicSettings.Settings['victoryRushHP'] or (0 - 0);
				v82 = EpicSettings.Settings['ravagerSetting'] or "player";
				v83 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
			if ((v121 == (0 + 0)) or ((5074 - (6 + 236)) < (2718 + 1595))) then
				v59 = EpicSettings.Settings['usePummel'];
				v60 = EpicSettings.Settings['useStormBolt'];
				v61 = EpicSettings.Settings['useIntimidatingShout'];
				v121 = 1 + 0;
			end
			if (((9641 - 5553) > (6766 - 2892)) and ((1134 - (1076 + 57)) == v121)) then
				v62 = EpicSettings.Settings['useBitterImmunity'];
				v63 = EpicSettings.Settings['useEnragedRegeneration'];
				v64 = EpicSettings.Settings['useIgnorePain'];
				v121 = 1 + 1;
			end
			if (((5021 - (579 + 110)) == (343 + 3989)) and (v121 == (5 + 0))) then
				v76 = EpicSettings.Settings['interveneHP'] or (0 + 0);
				v77 = EpicSettings.Settings['defensiveStanceHP'] or (407 - (174 + 233));
				v80 = EpicSettings.Settings['unstanceHP'] or (0 - 0);
				v121 = 10 - 4;
			end
			if (((1779 + 2220) >= (4074 - (663 + 511))) and (v121 == (4 + 0))) then
				v73 = EpicSettings.Settings['ignorePainHP'] or (0 + 0);
				v74 = EpicSettings.Settings['rallyingCryHP'] or (0 - 0);
				v75 = EpicSettings.Settings['rallyingCryGroup'] or (0 + 0);
				v121 = 11 - 6;
			end
			if ((v121 == (7 - 4)) or ((1205 + 1320) > (7909 - 3845))) then
				v70 = EpicSettings.Settings['useVictoryRush'];
				v71 = EpicSettings.Settings['bitterImmunityHP'] or (0 + 0);
				v72 = EpicSettings.Settings['enragedRegenerationHP'] or (0 + 0);
				v121 = 726 - (478 + 244);
			end
			if (((4888 - (440 + 77)) == (1988 + 2383)) and (v121 == (7 - 5))) then
				v65 = EpicSettings.Settings['useRallyingCry'];
				v66 = EpicSettings.Settings['useIntervene'];
				v67 = EpicSettings.Settings['useDefensiveStance'];
				v121 = 1559 - (655 + 901);
			end
		end
	end
	local function v110()
		local v122 = 0 + 0;
		while true do
			if ((v122 == (0 + 0)) or ((180 + 86) > (20086 - 15100))) then
				v89 = EpicSettings.Settings['fightRemainsCheck'] or (1445 - (695 + 750));
				v86 = EpicSettings.Settings['InterruptWithStun'];
				v87 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v122 = 3 - 2;
			end
			if (((3072 - 1081) >= (3720 - 2795)) and (v122 == (353 - (285 + 66)))) then
				v58 = EpicSettings.Settings['trinketsWithCD'];
				v57 = EpicSettings.Settings['racialsWithCD'];
				v68 = EpicSettings.Settings['useHealthstone'];
				v122 = 6 - 3;
			end
			if (((1765 - (682 + 628)) < (331 + 1722)) and ((300 - (176 + 123)) == v122)) then
				v88 = EpicSettings.Settings['InterruptThreshold'];
				v50 = EpicSettings.Settings['useTrinkets'];
				v49 = EpicSettings.Settings['useRacials'];
				v122 = 1 + 1;
			end
			if ((v122 == (3 + 0)) or ((1095 - (239 + 30)) == (1319 + 3532))) then
				v69 = EpicSettings.Settings['useHealingPotion'];
				v78 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v79 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v122 = 12 - 8;
			end
			if (((498 - (306 + 9)) == (638 - 455)) and (v122 == (1 + 3))) then
				v85 = EpicSettings.Settings['HealingPotionName'] or "";
				v84 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v111()
		local v123 = 0 + 0;
		while true do
			if (((558 + 601) <= (5112 - 3324)) and (v123 == (1375 - (1140 + 235)))) then
				v109();
				v108();
				v110();
				v27 = EpicSettings.Toggles['ooc'];
				v123 = 1 + 0;
			end
			if ((v123 == (1 + 0)) or ((901 + 2606) > (4370 - (33 + 19)))) then
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				if (v13:IsDeadOrGhost() or ((1111 + 1964) <= (8886 - 5921))) then
					return v26;
				end
				if (((602 + 763) <= (3943 - 1932)) and v28) then
					local v175 = 0 + 0;
					while true do
						if ((v175 == (689 - (586 + 103))) or ((253 + 2523) > (11006 - 7431))) then
							v97 = v13:GetEnemiesInMeleeRange(1496 - (1309 + 179));
							v98 = #v97;
							break;
						end
					end
				else
					v98 = 1 - 0;
				end
				v123 = 1 + 1;
			end
			if ((v123 == (5 - 3)) or ((1930 + 624) == (10206 - 5402))) then
				v99 = v14:IsInMeleeRange(9 - 4);
				if (((3186 - (295 + 314)) == (6329 - 3752)) and (v90.TargetIsValid() or v13:AffectingCombat())) then
					v95 = v9.BossFightRemains(nil, true);
					v96 = v95;
					if ((v96 == (13073 - (1300 + 662))) or ((18 - 12) >= (3644 - (1178 + 577)))) then
						v96 = v9.FightRemains(v97, false);
					end
				end
				if (((263 + 243) <= (5592 - 3700)) and not v13:IsChanneling()) then
					if (v13:AffectingCombat() or ((3413 - (851 + 554)) > (1962 + 256))) then
						local v180 = 0 - 0;
						while true do
							if (((822 - 443) <= (4449 - (115 + 187))) and (v180 == (0 + 0))) then
								v26 = v107();
								if (v26 or ((4274 + 240) <= (3975 - 2966))) then
									return v26;
								end
								break;
							end
						end
					else
						local v181 = 1161 - (160 + 1001);
						while true do
							if ((v181 == (0 + 0)) or ((2413 + 1083) == (2439 - 1247))) then
								v26 = v104();
								if (v26 or ((566 - (237 + 121)) == (3856 - (525 + 372)))) then
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
	local function v112()
		v19.Print("Fury Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(136 - 64, v111, v112);
end;
return v0["Epix_Warrior_Fury.lua"]();

