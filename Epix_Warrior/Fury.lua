local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((3542 - (374 + 433)) >= (5222 - (418 + 344)))) then
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
	local v90;
	local v91 = v19.Commons.Everyone;
	local v92 = v17.Warrior.Fury;
	local v93 = v18.Warrior.Fury;
	local v94 = v22.Warrior.Fury;
	local v95 = {};
	local v96 = 11437 - (192 + 134);
	local v97 = 12387 - (316 + 960);
	v9:RegisterForEvent(function()
		local v114 = 0 + 0;
		while true do
			if (((2241 + 662) >= (1382 + 113)) and (v114 == (0 - 0))) then
				v96 = 11662 - (83 + 468);
				v97 = 12917 - (1202 + 604);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v98, v99;
	local v100;
	local function v101()
		local v115 = UnitGetTotalAbsorbs(v14:ID());
		if (((21221 - 16675) >= (3785 - 1510)) and (v115 > (0 - 0))) then
			return true;
		else
			return false;
		end
	end
	local function v102()
		if (((1144 - (45 + 280)) >= (22 + 0)) and v92.BitterImmunity:IsReady() and v63 and (v13:HealthPercentage() <= v72)) then
			if (((2763 + 399) == (1155 + 2007)) and v23(v92.BitterImmunity)) then
				return "bitter_immunity defensive";
			end
		end
		if ((v92.EnragedRegeneration:IsCastable() and v64 and (v13:HealthPercentage() <= v73)) or ((1311 + 1058) > (780 + 3649))) then
			if (((7583 - 3488) >= (5094 - (340 + 1571))) and v23(v92.EnragedRegeneration)) then
				return "enraged_regeneration defensive";
			end
		end
		if ((v92.IgnorePain:IsCastable() and v65 and (v13:HealthPercentage() <= v74)) or ((1464 + 2247) < (2780 - (1733 + 39)))) then
			if (v23(v92.IgnorePain, nil, nil, true) or ((2882 - 1833) <= (1940 - (125 + 909)))) then
				return "ignore_pain defensive";
			end
		end
		if (((6461 - (1096 + 852)) > (1223 + 1503)) and v92.RallyingCry:IsCastable() and v66 and v13:BuffDown(v92.AspectsFavorBuff) and v13:BuffDown(v92.RallyingCry) and (((v13:HealthPercentage() <= v75) and v91.IsSoloMode()) or v91.AreUnitsBelowHealthPercentage(v75, v76))) then
			if (v23(v92.RallyingCry) or ((2114 - 633) >= (2579 + 79))) then
				return "rallying_cry defensive";
			end
		end
		if ((v92.Intervene:IsCastable() and v67 and (v16:HealthPercentage() <= v77) and (v16:Name() ~= v13:Name())) or ((3732 - (409 + 103)) == (1600 - (46 + 190)))) then
			if (v23(v94.InterveneFocus) or ((1149 - (51 + 44)) > (957 + 2435))) then
				return "intervene defensive";
			end
		end
		if ((v92.DefensiveStance:IsCastable() and v68 and (v13:HealthPercentage() <= v78) and v13:BuffDown(v92.DefensiveStance, true)) or ((1993 - (1114 + 203)) >= (2368 - (228 + 498)))) then
			if (((897 + 3239) > (1325 + 1072)) and v23(v92.DefensiveStance)) then
				return "defensive_stance defensive";
			end
		end
		if ((v92.BerserkerStance:IsCastable() and v68 and (v13:HealthPercentage() > v81) and v13:BuffDown(v92.BerserkerStance, true)) or ((4997 - (174 + 489)) == (11059 - 6814))) then
			if (v23(v92.BerserkerStance) or ((6181 - (830 + 1075)) <= (3555 - (303 + 221)))) then
				return "berserker_stance after defensive stance defensive";
			end
		end
		if ((v93.Healthstone:IsReady() and v69 and (v13:HealthPercentage() <= v79)) or ((6051 - (231 + 1038)) <= (1000 + 199))) then
			if (v23(v94.Healthstone) or ((6026 - (171 + 991)) < (7838 - 5936))) then
				return "healthstone defensive 3";
			end
		end
		if (((12993 - 8154) >= (9233 - 5533)) and v70 and (v13:HealthPercentage() <= v80)) then
			local v132 = 0 + 0;
			while true do
				if ((v132 == (0 - 0)) or ((3101 - 2026) > (3091 - 1173))) then
					if (((1224 - 828) <= (5052 - (111 + 1137))) and (v86 == "Refreshing Healing Potion")) then
						if (v93.RefreshingHealingPotion:IsReady() or ((4327 - (91 + 67)) == (6509 - 4322))) then
							if (((351 + 1055) == (1929 - (423 + 100))) and v23(v94.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((11 + 1520) < (11825 - 7554)) and (v86 == "Dreamwalker's Healing Potion")) then
						if (((331 + 304) == (1406 - (326 + 445))) and v93.DreamwalkersHealingPotion:IsReady()) then
							if (((14719 - 11346) <= (7921 - 4365)) and v23(v94.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v103()
		v26 = v91.HandleTopTrinket(v95, v29, 93 - 53, nil);
		if (v26 or ((4002 - (530 + 181)) < (4161 - (614 + 267)))) then
			return v26;
		end
		v26 = v91.HandleBottomTrinket(v95, v29, 72 - (19 + 13), nil);
		if (((7137 - 2751) >= (2033 - 1160)) and v26) then
			return v26;
		end
	end
	local function v104()
		local v116 = 0 - 0;
		while true do
			if (((240 + 681) <= (1937 - 835)) and (v116 == (1 - 0))) then
				if (((6518 - (1293 + 519)) >= (1964 - 1001)) and v92.Bloodthirst:IsCastable() and v34 and v100) then
					if (v23(v92.Bloodthirst, not v100) or ((2506 - 1546) <= (1675 - 799))) then
						return "bloodthirst precombat 10";
					end
				end
				if ((v35 and v92.Charge:IsReady() and not v100) or ((8908 - 6842) == (2195 - 1263))) then
					if (((2556 + 2269) < (989 + 3854)) and v23(v92.Charge, not v14:IsSpellInRange(v92.Charge))) then
						return "charge precombat 12";
					end
				end
				break;
			end
			if ((v116 == (0 - 0)) or ((896 + 2981) >= (1508 + 3029))) then
				if ((v31 and ((v52 and v29) or not v52) and (v90 < v97) and v92.Avatar:IsCastable() and not v92.TitansTorment:IsAvailable()) or ((2697 + 1618) < (2822 - (709 + 387)))) then
					if (v23(v92.Avatar, not v100) or ((5537 - (673 + 1185)) < (1812 - 1187))) then
						return "avatar precombat 6";
					end
				end
				if ((v44 and ((v55 and v29) or not v55) and (v90 < v97) and v92.Recklessness:IsCastable() and not v92.RecklessAbandon:IsAvailable()) or ((14851 - 10226) < (1039 - 407))) then
					if (v23(v92.Recklessness, not v100) or ((60 + 23) > (1331 + 449))) then
						return "recklessness precombat 8";
					end
				end
				v116 = 1 - 0;
			end
		end
	end
	local function v105()
		if (((135 + 411) <= (2146 - 1069)) and not v13:AffectingCombat()) then
			local v133 = 0 - 0;
			while true do
				if ((v133 == (1880 - (446 + 1434))) or ((2279 - (1040 + 243)) > (12836 - 8535))) then
					if (((5917 - (559 + 1288)) > (2618 - (609 + 1322))) and v92.BerserkerStance:IsCastable() and v13:BuffDown(v92.BerserkerStance, true)) then
						if (v23(v92.BerserkerStance) or ((1110 - (13 + 441)) >= (12443 - 9113))) then
							return "berserker_stance";
						end
					end
					if ((v92.BattleShout:IsCastable() and v32 and (v13:BuffDown(v92.BattleShoutBuff, true) or v91.GroupBuffMissing(v92.BattleShoutBuff))) or ((6527 - 4035) <= (1668 - 1333))) then
						if (((161 + 4161) >= (9304 - 6742)) and v23(v92.BattleShout)) then
							return "battle_shout precombat";
						end
					end
					break;
				end
			end
		end
		if ((v91.TargetIsValid() and v27) or ((1292 + 2345) >= (1652 + 2118))) then
			if (not v13:AffectingCombat() or ((7059 - 4680) > (2506 + 2072))) then
				v26 = v104();
				if (v26 or ((887 - 404) > (492 + 251))) then
					return v26;
				end
			end
		end
	end
	local function v106()
		if (((1365 + 1089) > (416 + 162)) and v92.Whirlwind:IsCastable() and v48 and (v99 > (1 + 0)) and v92.ImprovedWhilwind:IsAvailable() and v13:BuffDown(v92.MeatCleaverBuff)) then
			if (((910 + 20) < (4891 - (153 + 280))) and v23(v92.Whirlwind, not v14:IsInMeleeRange(23 - 15))) then
				return "whirlwind single_target 2";
			end
		end
		if (((595 + 67) <= (384 + 588)) and v92.Execute:IsReady() and v37 and v13:BuffUp(v92.AshenJuggernautBuff) and (v13:BuffRemains(v92.AshenJuggernautBuff) < v13:GCD())) then
			if (((2287 + 2083) == (3966 + 404)) and v23(v92.Execute, not v100)) then
				return "execute single_target 4";
			end
		end
		if ((v39 and ((v53 and v29) or not v53) and v92.OdynsFury:IsCastable() and (v90 < v97) and v13:BuffUp(v92.EnrageBuff) and ((v92.DancingBlades:IsAvailable() and (v13:BuffRemains(v92.DancingBladesBuff) < (4 + 1))) or not v92.DancingBlades:IsAvailable())) or ((7250 - 2488) <= (533 + 328))) then
			if (v23(v92.OdynsFury, not v14:IsInMeleeRange(675 - (89 + 578))) or ((1009 + 403) == (8864 - 4600))) then
				return "odyns_fury single_target 6";
			end
		end
		if ((v92.Rampage:IsReady() and v42 and v92.AngerManagement:IsAvailable() and (v13:BuffUp(v92.RecklessnessBuff) or (v13:BuffRemains(v92.EnrageBuff) < v13:GCD()) or (v13:RagePercentage() > (1134 - (572 + 477))))) or ((428 + 2740) < (1293 + 860))) then
			if (v23(v92.Rampage, not v100) or ((594 + 4382) < (1418 - (84 + 2)))) then
				return "rampage single_target 8";
			end
		end
		local v117 = v13:CritChancePct() + (v24(v13:BuffUp(v92.RecklessnessBuff)) * (32 - 12)) + (v13:BuffStack(v92.MercilessAssaultBuff) * (8 + 2)) + (v13:BuffStack(v92.BloodcrazeBuff) * (857 - (497 + 345)));
		if (((119 + 4509) == (783 + 3845)) and v92.Bloodbath:IsCastable() and v33 and v13:HasTier(1363 - (605 + 728), 3 + 1) and (v117 >= (211 - 116))) then
			if (v23(v92.Bloodbath, not v100) or ((3 + 51) == (1460 - 1065))) then
				return "bloodbath single_target 10";
			end
		end
		if (((74 + 8) == (226 - 144)) and v92.Bloodthirst:IsCastable() and v34 and ((v13:HasTier(23 + 7, 493 - (457 + 32)) and (v117 >= (41 + 54))) or (not v92.RecklessAbandon:IsAvailable() and v13:BuffUp(v92.FuriousBloodthirstBuff) and v13:BuffUp(v92.EnrageBuff) and (v14:DebuffDown(v92.GushingWoundDebuff) or v13:BuffUp(v92.ChampionsMightBuff))))) then
			if (v23(v92.Bloodthirst, not v100) or ((1983 - (832 + 570)) < (266 + 16))) then
				return "bloodthirst single_target 12";
			end
		end
		if ((v92.Bloodbath:IsCastable() and v33 and v13:HasTier(9 + 22, 6 - 4)) or ((2221 + 2388) < (3291 - (588 + 208)))) then
			if (((3104 - 1952) == (2952 - (884 + 916))) and v23(v92.Bloodbath, not v100)) then
				return "bloodbath single_target 14";
			end
		end
		if (((3969 - 2073) <= (1985 + 1437)) and v47 and ((v57 and v29) or not v57) and (v90 < v97) and v92.ThunderousRoar:IsCastable() and v13:BuffUp(v92.EnrageBuff)) then
			if (v23(v92.ThunderousRoar, not v14:IsInMeleeRange(661 - (232 + 421))) or ((2879 - (1569 + 320)) > (398 + 1222))) then
				return "thunderous_roar single_target 16";
			end
		end
		if ((v92.Onslaught:IsReady() and v40 and (v13:BuffUp(v92.EnrageBuff) or v92.Tenderize:IsAvailable())) or ((167 + 710) > (15821 - 11126))) then
			if (((3296 - (316 + 289)) >= (4845 - 2994)) and v23(v92.Onslaught, not v100)) then
				return "onslaught single_target 18";
			end
		end
		if ((v92.CrushingBlow:IsCastable() and v36 and v92.WrathandFury:IsAvailable() and v13:BuffUp(v92.EnrageBuff) and v13:BuffDown(v92.FuriousBloodthirstBuff)) or ((138 + 2847) >= (6309 - (666 + 787)))) then
			if (((4701 - (360 + 65)) >= (1117 + 78)) and v23(v92.CrushingBlow, not v100)) then
				return "crushing_blow single_target 20";
			end
		end
		if (((3486 - (79 + 175)) <= (7395 - 2705)) and v92.Execute:IsReady() and v37 and ((v13:BuffUp(v92.EnrageBuff) and v13:BuffDown(v92.FuriousBloodthirstBuff) and v13:BuffUp(v92.AshenJuggernautBuff)) or ((v13:BuffRemains(v92.SuddenDeathBuff) <= v13:GCD()) and (((v14:HealthPercentage() > (28 + 7)) and v92.Massacre:IsAvailable()) or (v14:HealthPercentage() > (61 - 41)))))) then
			if (v23(v92.Execute, not v100) or ((1725 - 829) >= (4045 - (503 + 396)))) then
				return "execute single_target 22";
			end
		end
		if (((3242 - (92 + 89)) >= (5738 - 2780)) and v92.Rampage:IsReady() and v42 and v92.RecklessAbandon:IsAvailable() and (v13:BuffUp(v92.RecklessnessBuff) or (v13:BuffRemains(v92.EnrageBuff) < v13:GCD()) or (v13:RagePercentage() > (44 + 41)))) then
			if (((1887 + 1300) >= (2521 - 1877)) and v23(v92.Rampage, not v100)) then
				return "rampage single_target 24";
			end
		end
		if (((89 + 555) <= (1604 - 900)) and v92.Execute:IsReady() and v37 and v13:BuffUp(v92.EnrageBuff)) then
			if (((836 + 122) > (453 + 494)) and v23(v92.Execute, not v100)) then
				return "execute single_target 26";
			end
		end
		if (((13680 - 9188) >= (332 + 2322)) and v92.Rampage:IsReady() and v42 and v92.AngerManagement:IsAvailable()) then
			if (((5248 - 1806) >= (2747 - (485 + 759))) and v23(v92.Rampage, not v100)) then
				return "rampage single_target 28";
			end
		end
		if ((v92.Execute:IsReady() and v37) or ((7335 - 4165) <= (2653 - (442 + 747)))) then
			if (v23(v92.Execute, not v100) or ((5932 - (832 + 303)) == (5334 - (88 + 858)))) then
				return "execute single_target 29";
			end
		end
		if (((168 + 383) <= (564 + 117)) and v92.Bloodbath:IsCastable() and v33 and v13:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and not v92.WrathandFury:IsAvailable()) then
			if (((135 + 3142) > (1196 - (766 + 23))) and v23(v92.Bloodbath, not v100)) then
				return "bloodbath single_target 30";
			end
		end
		if (((23177 - 18482) >= (1934 - 519)) and v92.Rampage:IsReady() and v42 and (v14:HealthPercentage() < (92 - 57)) and v92.Massacre:IsAvailable()) then
			if (v23(v92.Rampage, not v100) or ((10901 - 7689) <= (2017 - (1036 + 37)))) then
				return "rampage single_target 32";
			end
		end
		if ((v92.Bloodthirst:IsCastable() and v34 and (not v13:BuffUp(v92.EnrageBuff) or (v92.Annihilator:IsAvailable() and v13:BuffDown(v92.RecklessnessBuff))) and v13:BuffDown(v92.FuriousBloodthirstBuff)) or ((2195 + 901) <= (3501 - 1703))) then
			if (((2783 + 754) == (5017 - (641 + 839))) and v23(v92.Bloodthirst, not v100)) then
				return "bloodthirst single_target 34";
			end
		end
		if (((4750 - (910 + 3)) >= (4002 - 2432)) and v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (1685 - (1466 + 218))) and v92.WrathandFury:IsAvailable()) then
			if (v23(v92.RagingBlow, not v100) or ((1356 + 1594) == (4960 - (556 + 592)))) then
				return "raging_blow single_target 36";
			end
		end
		if (((1680 + 3043) >= (3126 - (329 + 479))) and v92.CrushingBlow:IsCastable() and v36 and (v92.CrushingBlow:Charges() > (855 - (174 + 680))) and v92.WrathandFury:IsAvailable() and v13:BuffDown(v92.FuriousBloodthirstBuff)) then
			if (v23(v92.CrushingBlow, not v100) or ((6964 - 4937) > (5911 - 3059))) then
				return "crushing_blow single_target 38";
			end
		end
		if ((v92.Bloodbath:IsCastable() and v33 and (not v13:BuffUp(v92.EnrageBuff) or not v92.WrathandFury:IsAvailable())) or ((812 + 324) > (5056 - (396 + 343)))) then
			if (((421 + 4327) == (6225 - (29 + 1448))) and v23(v92.Bloodbath, not v100)) then
				return "bloodbath single_target 40";
			end
		end
		if (((5125 - (135 + 1254)) <= (17856 - 13116)) and v92.CrushingBlow:IsCastable() and v36 and v13:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and v13:BuffDown(v92.FuriousBloodthirstBuff)) then
			if (v23(v92.CrushingBlow, not v100) or ((15828 - 12438) <= (2040 + 1020))) then
				return "crushing_blow single_target 42";
			end
		end
		if ((v92.Bloodthirst:IsCastable() and v34 and not v92.WrathandFury:IsAvailable() and v13:BuffDown(v92.FuriousBloodthirstBuff)) or ((2526 - (389 + 1138)) > (3267 - (102 + 472)))) then
			if (((437 + 26) < (334 + 267)) and v23(v92.Bloodthirst, not v100)) then
				return "bloodthirst single_target 44";
			end
		end
		if ((v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (1 + 0))) or ((3728 - (320 + 1225)) < (1222 - 535))) then
			if (((2784 + 1765) == (6013 - (157 + 1307))) and v23(v92.RagingBlow, not v100)) then
				return "raging_blow single_target 46";
			end
		end
		if (((6531 - (821 + 1038)) == (11656 - 6984)) and v92.Rampage:IsReady() and v42) then
			if (v23(v92.Rampage, not v100) or ((402 + 3266) < (701 - 306))) then
				return "rampage single_target 47";
			end
		end
		if ((v92.Slam:IsReady() and v45 and (v92.Annihilator:IsAvailable())) or ((1550 + 2616) == (1127 - 672))) then
			if (v23(v92.Slam, not v100) or ((5475 - (834 + 192)) == (170 + 2493))) then
				return "slam single_target 48";
			end
		end
		if ((v92.Bloodbath:IsCastable() and v33) or ((1098 + 3179) < (65 + 2924))) then
			if (v23(v92.Bloodbath, not v100) or ((1347 - 477) >= (4453 - (300 + 4)))) then
				return "bloodbath single_target 50";
			end
		end
		if (((591 + 1621) < (8332 - 5149)) and v92.RagingBlow:IsCastable() and v41) then
			if (((5008 - (112 + 250)) > (1193 + 1799)) and v23(v92.RagingBlow, not v100)) then
				return "raging_blow single_target 52";
			end
		end
		if (((3592 - 2158) < (1780 + 1326)) and v92.CrushingBlow:IsCastable() and v36 and v13:BuffDown(v92.FuriousBloodthirstBuff)) then
			if (((407 + 379) < (2261 + 762)) and v23(v92.CrushingBlow, not v100)) then
				return "crushing_blow single_target 54";
			end
		end
		if ((v92.Bloodthirst:IsCastable() and v34) or ((1211 + 1231) < (55 + 19))) then
			if (((5949 - (1001 + 413)) == (10112 - 5577)) and v23(v92.Bloodthirst, not v100)) then
				return "bloodthirst single_target 56";
			end
		end
		if ((v28 and v92.Whirlwind:IsCastable() and v48) or ((3891 - (244 + 638)) <= (2798 - (627 + 66)))) then
			if (((5452 - 3622) < (4271 - (512 + 90))) and v23(v92.Whirlwind, not v14:IsInMeleeRange(1914 - (1665 + 241)))) then
				return "whirlwind single_target 58";
			end
		end
	end
	local function v107()
		if ((v92.Recklessness:IsCastable() and ((v55 and v29) or not v55) and v44 and (v90 < v97) and ((v99 > (718 - (373 + 344))) or (v97 < (6 + 6)))) or ((379 + 1051) >= (9527 - 5915))) then
			if (((4539 - 1856) >= (3559 - (35 + 1064))) and v23(v92.Recklessness, not v100)) then
				return "recklessness multi_target 2";
			end
		end
		if ((v92.OdynsFury:IsCastable() and ((v53 and v29) or not v53) and v39 and (v90 < v97) and (v99 > (1 + 0)) and v92.TitanicRage:IsAvailable() and (v13:BuffDown(v92.MeatCleaverBuff) or v13:BuffUp(v92.AvatarBuff) or v13:BuffUp(v92.RecklessnessBuff))) or ((3859 - 2055) >= (14 + 3261))) then
			if (v23(v92.OdynsFury, not v14:IsInMeleeRange(1244 - (298 + 938))) or ((2676 - (233 + 1026)) > (5295 - (636 + 1030)))) then
				return "odyns_fury multi_target 4";
			end
		end
		if (((2452 + 2343) > (393 + 9)) and v92.Whirlwind:IsCastable() and v48 and (v99 > (1 + 0)) and v92.ImprovedWhilwind:IsAvailable() and v13:BuffDown(v92.MeatCleaverBuff)) then
			if (((326 + 4487) > (3786 - (55 + 166))) and v23(v92.Whirlwind, not v14:IsInMeleeRange(2 + 6))) then
				return "whirlwind multi_target 6";
			end
		end
		if (((394 + 3518) == (14940 - 11028)) and v92.Execute:IsReady() and v37 and v13:BuffUp(v92.AshenJuggernautBuff) and (v13:BuffRemains(v92.AshenJuggernautBuff) < v13:GCD())) then
			if (((3118 - (36 + 261)) <= (8436 - 3612)) and v23(v92.Execute, not v100)) then
				return "execute multi_target 8";
			end
		end
		if (((3106 - (34 + 1334)) <= (844 + 1351)) and v92.ThunderousRoar:IsCastable() and ((v57 and v29) or not v57) and v47 and (v90 < v97) and v13:BuffUp(v92.EnrageBuff)) then
			if (((32 + 9) <= (4301 - (1035 + 248))) and v23(v92.ThunderousRoar, not v14:IsInMeleeRange(29 - (20 + 1)))) then
				return "thunderous_roar multi_target 10";
			end
		end
		if (((1118 + 1027) <= (4423 - (134 + 185))) and v92.OdynsFury:IsCastable() and ((v53 and v29) or not v53) and v39 and (v90 < v97) and (v99 > (1134 - (549 + 584))) and v13:BuffUp(v92.EnrageBuff)) then
			if (((3374 - (314 + 371)) < (16632 - 11787)) and v23(v92.OdynsFury, not v14:IsInMeleeRange(976 - (478 + 490)))) then
				return "odyns_fury multi_target 12";
			end
		end
		local v118 = v13:CritChancePct() + (v24(v13:BuffUp(v92.RecklessnessBuff)) * (11 + 9)) + (v13:BuffStack(v92.MercilessAssaultBuff) * (1182 - (786 + 386))) + (v13:BuffStack(v92.BloodcrazeBuff) * (48 - 33));
		if ((v92.Bloodbath:IsCastable() and v33 and v13:HasTier(1409 - (1055 + 324), 1344 - (1093 + 247)) and (v118 >= (85 + 10))) or ((245 + 2077) > (10409 - 7787))) then
			if (v23(v92.Bloodbath, not v100) or ((15387 - 10853) == (5924 - 3842))) then
				return "bloodbath multi_target 14";
			end
		end
		if ((v92.Bloodthirst:IsCastable() and v34 and ((v13:HasTier(75 - 45, 2 + 2) and (v118 >= (365 - 270))) or (not v92.RecklessAbandon:IsAvailable() and v13:BuffUp(v92.FuriousBloodthirstBuff) and v13:BuffUp(v92.EnrageBuff)))) or ((5414 - 3843) > (1408 + 459))) then
			if (v23(v92.Bloodthirst, not v100) or ((6786 - 4132) >= (3684 - (364 + 324)))) then
				return "bloodthirst multi_target 16";
			end
		end
		if (((10904 - 6926) > (5048 - 2944)) and v92.CrushingBlow:IsCastable() and v92.WrathandFury:IsAvailable() and v36 and v13:BuffUp(v92.EnrageBuff)) then
			if (((993 + 2002) > (6447 - 4906)) and v23(v92.CrushingBlow, not v100)) then
				return "crushing_blow multi_target 14";
			end
		end
		if (((5202 - 1953) > (2894 - 1941)) and v92.Execute:IsReady() and v37 and v13:BuffUp(v92.EnrageBuff)) then
			if (v23(v92.Execute, not v100) or ((4541 - (1249 + 19)) > (4128 + 445))) then
				return "execute multi_target 16";
			end
		end
		if ((v92.OdynsFury:IsCastable() and ((v53 and v29) or not v53) and v39 and (v90 < v97) and v13:BuffUp(v92.EnrageBuff)) or ((12265 - 9114) < (2370 - (686 + 400)))) then
			if (v23(v92.OdynsFury, not v14:IsInMeleeRange(7 + 1)) or ((2079 - (73 + 156)) == (8 + 1521))) then
				return "odyns_fury multi_target 18";
			end
		end
		if (((1632 - (721 + 90)) < (24 + 2099)) and v92.Rampage:IsReady() and v42 and (v13:BuffUp(v92.RecklessnessBuff) or (v13:BuffRemains(v92.EnrageBuff) < v13:GCD()) or ((v13:Rage() > (357 - 247)) and v92.OverwhelmingRage:IsAvailable()) or ((v13:Rage() > (550 - (224 + 246))) and not v92.OverwhelmingRage:IsAvailable()))) then
			if (((1460 - 558) < (4280 - 1955)) and v23(v92.Rampage, not v100)) then
				return "rampage multi_target 20";
			end
		end
		if (((156 + 702) <= (71 + 2891)) and v92.Execute:IsReady() and v37) then
			if (v23(v92.Execute, not v100) or ((2899 + 1047) < (2560 - 1272))) then
				return "execute multi_target 22";
			end
		end
		if ((v92.Bloodbath:IsCastable() and v33 and v13:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and not v92.WrathandFury:IsAvailable()) or ((10788 - 7546) == (1080 - (203 + 310)))) then
			if (v23(v92.Bloodbath, not v100) or ((2840 - (1238 + 755)) >= (89 + 1174))) then
				return "bloodbath multi_target 24";
			end
		end
		if ((v92.Bloodthirst:IsCastable() and v34 and (not v13:BuffUp(v92.EnrageBuff) or (v92.Annihilator:IsAvailable() and v13:BuffDown(v92.RecklessnessBuff)))) or ((3787 - (709 + 825)) == (3410 - 1559))) then
			if (v23(v92.Bloodthirst, not v100) or ((3040 - 953) > (3236 - (196 + 668)))) then
				return "bloodthirst multi_target 26";
			end
		end
		if ((v92.Onslaught:IsReady() and v40 and ((not v92.Annihilator:IsAvailable() and v13:BuffUp(v92.EnrageBuff)) or v92.Tenderize:IsAvailable())) or ((17550 - 13105) < (8593 - 4444))) then
			if (v23(v92.Onslaught, not v100) or ((2651 - (171 + 662)) == (178 - (4 + 89)))) then
				return "onslaught multi_target 28";
			end
		end
		if (((2208 - 1578) < (775 + 1352)) and v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (4 - 3)) and v92.WrathandFury:IsAvailable()) then
			if (v23(v92.RagingBlow, not v100) or ((760 + 1178) == (4000 - (35 + 1451)))) then
				return "raging_blow multi_target 30";
			end
		end
		if (((5708 - (28 + 1425)) >= (2048 - (941 + 1052))) and v92.CrushingBlow:IsCastable() and v36 and (v92.CrushingBlow:Charges() > (1 + 0)) and v92.WrathandFury:IsAvailable()) then
			if (((4513 - (822 + 692)) > (1649 - 493)) and v23(v92.CrushingBlow, not v100)) then
				return "crushing_blow multi_target 32";
			end
		end
		if (((1107 + 1243) > (1452 - (45 + 252))) and v92.Bloodbath:IsCastable() and v33 and (not v13:BuffUp(v92.EnrageBuff) or not v92.WrathandFury:IsAvailable())) then
			if (((3987 + 42) <= (1671 + 3182)) and v23(v92.Bloodbath, not v100)) then
				return "bloodbath multi_target 34";
			end
		end
		if ((v92.CrushingBlow:IsCastable() and v36 and v13:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable()) or ((1255 - 739) > (3867 - (114 + 319)))) then
			if (((5808 - 1762) >= (3885 - 852)) and v23(v92.CrushingBlow, not v100)) then
				return "crushing_blow multi_target 36";
			end
		end
		if ((v92.Bloodthirst:IsCastable() and v34 and not v92.WrathandFury:IsAvailable()) or ((1734 + 985) <= (2155 - 708))) then
			if (v23(v92.Bloodthirst, not v100) or ((8661 - 4527) < (5889 - (556 + 1407)))) then
				return "bloodthirst multi_target 38";
			end
		end
		if ((v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (1207 - (741 + 465)))) or ((629 - (170 + 295)) >= (1468 + 1317))) then
			if (v23(v92.RagingBlow, not v100) or ((483 + 42) == (5192 - 3083))) then
				return "raging_blow multi_target 40";
			end
		end
		if (((28 + 5) == (22 + 11)) and v92.Rampage:IsReady() and v42) then
			if (((1730 + 1324) <= (5245 - (957 + 273))) and v23(v92.Rampage, not v100)) then
				return "rampage multi_target 42";
			end
		end
		if (((501 + 1370) < (1354 + 2028)) and v92.Slam:IsReady() and v45 and (v92.Annihilator:IsAvailable())) then
			if (((4926 - 3633) <= (5707 - 3541)) and v23(v92.Slam, not v100)) then
				return "slam multi_target 44";
			end
		end
		if ((v92.Bloodbath:IsCastable() and v33) or ((7877 - 5298) < (609 - 486))) then
			if (v23(v92.Bloodbath, not v100) or ((2626 - (389 + 1391)) >= (1486 + 882))) then
				return "bloodbath multi_target 46";
			end
		end
		if ((v92.RagingBlow:IsCastable() and v41) or ((418 + 3594) <= (7644 - 4286))) then
			if (((2445 - (783 + 168)) <= (10085 - 7080)) and v23(v92.RagingBlow, not v100)) then
				return "raging_blow multi_target 48";
			end
		end
		if ((v92.CrushingBlow:IsCastable() and v36) or ((3061 + 50) == (2445 - (309 + 2)))) then
			if (((7231 - 4876) == (3567 - (1090 + 122))) and v23(v92.CrushingBlow, not v100)) then
				return "crushing_blow multi_target 50";
			end
		end
		if ((v92.Whirlwind:IsCastable() and v48) or ((191 + 397) <= (1450 - 1018))) then
			if (((3283 + 1514) >= (5013 - (628 + 490))) and v23(v92.Whirlwind, not v14:IsInMeleeRange(2 + 6))) then
				return "whirlwind multi_target 52";
			end
		end
	end
	local function v108()
		v26 = v102();
		if (((8855 - 5278) == (16346 - 12769)) and v26) then
			return v26;
		end
		if (((4568 - (431 + 343)) > (7458 - 3765)) and v85) then
			local v134 = 0 - 0;
			while true do
				if ((v134 == (0 + 0)) or ((164 + 1111) == (5795 - (556 + 1139)))) then
					v26 = v91.HandleIncorporeal(v92.StormBolt, v94.StormBoltMouseover, 35 - (6 + 9), true);
					if (v26 or ((292 + 1299) >= (1834 + 1746))) then
						return v26;
					end
					v134 = 170 - (28 + 141);
				end
				if (((381 + 602) <= (2231 - 423)) and (v134 == (1 + 0))) then
					v26 = v91.HandleIncorporeal(v92.IntimidatingShout, v94.IntimidatingShoutMouseover, 1325 - (486 + 831), true);
					if (v26 or ((5594 - 3444) <= (4214 - 3017))) then
						return v26;
					end
					break;
				end
			end
		end
		if (((713 + 3056) >= (3708 - 2535)) and v91.TargetIsValid()) then
			if (((2748 - (668 + 595)) == (1337 + 148)) and v35 and v92.Charge:IsCastable()) then
				if (v23(v92.Charge, not v14:IsSpellInRange(v92.Charge)) or ((669 + 2646) <= (7586 - 4804))) then
					return "charge main 2";
				end
			end
			local v135 = v91.HandleDPSPotion(v14:BuffUp(v92.RecklessnessBuff));
			if (v135 or ((1166 - (23 + 267)) >= (4908 - (1129 + 815)))) then
				return v135;
			end
			if ((v90 < v97) or ((2619 - (371 + 16)) > (4247 - (1326 + 424)))) then
				if ((v51 and ((v29 and v59) or not v59)) or ((3996 - 1886) <= (1213 - 881))) then
					local v178 = 118 - (88 + 30);
					while true do
						if (((4457 - (720 + 51)) > (7055 - 3883)) and ((1776 - (421 + 1355)) == v178)) then
							v26 = v103();
							if (v26 or ((7380 - 2906) < (403 + 417))) then
								return v26;
							end
							break;
						end
					end
				end
				if (((5362 - (286 + 797)) >= (10535 - 7653)) and v29 and v93.FyralathTheDreamrender:IsEquippedAndReady() and v30) then
					if (v23(v94.UseWeapon) or ((3360 - 1331) >= (3960 - (397 + 42)))) then
						return "Fyralath The Dreamrender used";
					end
				end
			end
			if (((v90 < v97) and v50 and ((v58 and v29) or not v58)) or ((637 + 1400) >= (5442 - (24 + 776)))) then
				local v175 = 0 - 0;
				while true do
					if (((2505 - (222 + 563)) < (9822 - 5364)) and ((2 + 0) == v175)) then
						if (v92.AncestralCall:IsCastable() or ((626 - (23 + 167)) > (4819 - (690 + 1108)))) then
							if (((258 + 455) <= (699 + 148)) and v23(v92.AncestralCall, not v100)) then
								return "ancestral_call main 20";
							end
						end
						if (((3002 - (40 + 808)) <= (664 + 3367)) and v92.BagofTricks:IsCastable() and v13:BuffDown(v92.RecklessnessBuff) and v13:BuffUp(v92.EnrageBuff)) then
							if (((17647 - 13032) == (4411 + 204)) and v23(v92.BagofTricks, not v14:IsSpellInRange(v92.BagofTricks))) then
								return "bag_of_tricks main 22";
							end
						end
						break;
					end
					if ((v175 == (1 + 0)) or ((2079 + 1711) == (1071 - (47 + 524)))) then
						if (((58 + 31) < (604 - 383)) and v92.LightsJudgment:IsCastable() and v13:BuffDown(v92.RecklessnessBuff)) then
							if (((3070 - 1016) >= (3240 - 1819)) and v23(v92.LightsJudgment, not v14:IsSpellInRange(v92.LightsJudgment))) then
								return "lights_judgment main 16";
							end
						end
						if (((2418 - (1165 + 561)) < (91 + 2967)) and v92.Fireblood:IsCastable()) then
							if (v23(v92.Fireblood, not v100) or ((10077 - 6823) == (632 + 1023))) then
								return "fireblood main 18";
							end
						end
						v175 = 481 - (341 + 138);
					end
					if ((v175 == (0 + 0)) or ((2674 - 1378) == (5236 - (89 + 237)))) then
						if (((10834 - 7466) == (7090 - 3722)) and v92.BloodFury:IsCastable()) then
							if (((3524 - (581 + 300)) < (5035 - (855 + 365))) and v23(v92.BloodFury, not v100)) then
								return "blood_fury main 12";
							end
						end
						if (((4543 - 2630) > (161 + 332)) and v92.Berserking:IsCastable() and v13:BuffUp(v92.RecklessnessBuff)) then
							if (((5990 - (1030 + 205)) > (3219 + 209)) and v23(v92.Berserking, not v100)) then
								return "berserking main 14";
							end
						end
						v175 = 1 + 0;
					end
				end
			end
			if (((1667 - (156 + 130)) <= (5382 - 3013)) and (v90 < v97)) then
				if ((v92.Avatar:IsCastable() and v31 and ((v52 and v29) or not v52) and v92.TitansTorment:IsAvailable() and v13:BuffUp(v92.EnrageBuff) and (v90 < v97) and v13:BuffDown(v92.AvatarBuff) and (not v92.OdynsFury:IsAvailable() or (v92.OdynsFury:CooldownRemains() > (0 - 0)))) or (v92.BerserkersTorment:IsAvailable() and v13:BuffUp(v92.EnrageBuff) and v13:BuffDown(v92.AvatarBuff)) or (not v92.TitansTorment:IsAvailable() and not v92.BerserkersTorment:IsAvailable() and (v13:BuffUp(v92.RecklessnessBuff) or (v97 < (40 - 20)))) or ((1277 + 3566) == (2382 + 1702))) then
					if (((4738 - (10 + 59)) > (103 + 260)) and v23(v92.Avatar, not v100)) then
						return "avatar main 24";
					end
				end
				if ((v92.Recklessness:IsCastable() and v44 and ((v55 and v29) or not v55) and (not v92.Annihilator:IsAvailable() or (v92.ChampionsSpear:CooldownRemains() < (4 - 3)) or (v92.Avatar:CooldownRemains() > (1203 - (671 + 492))) or not v92.Avatar:IsAvailable() or (v97 < (10 + 2)))) or ((3092 - (369 + 846)) >= (831 + 2307))) then
					if (((4047 + 695) >= (5571 - (1036 + 909))) and v23(v92.Recklessness, not v100)) then
						return "recklessness main 26";
					end
				end
				if ((v92.Recklessness:IsCastable() and v44 and ((v55 and v29) or not v55) and (not v92.Annihilator:IsAvailable() or (v97 < (10 + 2)))) or ((7622 - 3082) == (1119 - (11 + 192)))) then
					if (v23(v92.Recklessness, not v100) or ((585 + 571) > (4520 - (135 + 40)))) then
						return "recklessness main 27";
					end
				end
				if (((5419 - 3182) < (2562 + 1687)) and v92.Ravager:IsCastable() and (v83 == "player") and v43 and ((v54 and v29) or not v54) and ((v92.Avatar:CooldownRemains() < (6 - 3)) or v13:BuffUp(v92.RecklessnessBuff) or (v97 < (14 - 4)))) then
					if (v23(v94.RavagerPlayer, not v100) or ((2859 - (50 + 126)) < (63 - 40))) then
						return "ravager main 28";
					end
				end
				if (((155 + 542) <= (2239 - (1233 + 180))) and v92.Ravager:IsCastable() and (v83 == "cursor") and v43 and ((v54 and v29) or not v54) and ((v92.Avatar:CooldownRemains() < (972 - (522 + 447))) or v13:BuffUp(v92.RecklessnessBuff) or (v97 < (1431 - (107 + 1314))))) then
					if (((513 + 592) <= (3583 - 2407)) and v23(v94.RavagerCursor, not v100)) then
						return "ravager main 28";
					end
				end
				if (((1436 + 1943) <= (7569 - 3757)) and v92.ChampionsSpear:IsCastable() and (v84 == "player") and v46 and ((v56 and v29) or not v56) and v13:BuffUp(v92.EnrageBuff) and ((v13:BuffUp(v92.FuriousBloodthirstBuff) and v92.TitansTorment:IsAvailable()) or not v92.TitansTorment:IsAvailable() or (v97 < (79 - 59)) or (v99 > (1911 - (716 + 1194))) or not v13:HasTier(1 + 30, 1 + 1))) then
					if (v23(v94.ChampionsSpearPlayer, not v100) or ((1291 - (74 + 429)) >= (3117 - 1501))) then
						return "spear_of_bastion main 30";
					end
				end
				if (((919 + 935) <= (7734 - 4355)) and v92.ChampionsSpear:IsCastable() and (v84 == "cursor") and v46 and ((v56 and v29) or not v56) and v13:BuffUp(v92.EnrageBuff) and ((v13:BuffUp(v92.FuriousBloodthirstBuff) and v92.TitansTorment:IsAvailable()) or not v92.TitansTorment:IsAvailable() or (v97 < (15 + 5)) or (v99 > (2 - 1)) or not v13:HasTier(76 - 45, 435 - (279 + 154)))) then
					if (((5327 - (454 + 324)) == (3579 + 970)) and v23(v94.ChampionsSpearCursor, not v14:IsInRange(47 - (12 + 5)))) then
						return "spear_of_bastion main 31";
					end
				end
			end
			if ((v38 and v92.HeroicThrow:IsCastable() and not v14:IsInRange(14 + 11) and v13:CanAttack(v14)) or ((7699 - 4677) >= (1118 + 1906))) then
				if (((5913 - (277 + 816)) > (9392 - 7194)) and v23(v92.HeroicThrow, not v14:IsSpellInRange(v92.HeroicThrow))) then
					return "heroic_throw main";
				end
			end
			if ((v92.WreckingThrow:IsCastable() and v49 and v101() and v13:CanAttack(v14)) or ((2244 - (1058 + 125)) >= (918 + 3973))) then
				if (((2339 - (815 + 160)) <= (19191 - 14718)) and v23(v92.WreckingThrow, not v14:IsSpellInRange(v92.WreckingThrow))) then
					return "wrecking_throw main";
				end
			end
			if ((v28 and (v99 >= (4 - 2))) or ((858 + 2737) <= (8 - 5))) then
				local v176 = 1898 - (41 + 1857);
				while true do
					if ((v176 == (1893 - (1222 + 671))) or ((12074 - 7402) == (5536 - 1684))) then
						v26 = v107();
						if (((2741 - (229 + 953)) == (3333 - (1111 + 663))) and v26) then
							return v26;
						end
						break;
					end
				end
			end
			v26 = v106();
			if (v26 or ((3331 - (874 + 705)) <= (111 + 677))) then
				return v26;
			end
		end
	end
	local function v109()
		local v119 = 0 + 0;
		while true do
			if ((v119 == (6 - 3)) or ((110 + 3797) == (856 - (642 + 37)))) then
				v41 = EpicSettings.Settings['useRagingBlow'];
				v42 = EpicSettings.Settings['useRampage'];
				v45 = EpicSettings.Settings['useSlam'];
				v119 = 1 + 3;
			end
			if (((556 + 2914) > (1393 - 838)) and (v119 == (460 - (233 + 221)))) then
				v46 = EpicSettings.Settings['useChampionsSpear'];
				v47 = EpicSettings.Settings['useThunderousRoar'];
				v52 = EpicSettings.Settings['avatarWithCD'];
				v119 = 15 - 8;
			end
			if ((v119 == (4 + 0)) or ((2513 - (718 + 823)) == (406 + 239))) then
				v48 = EpicSettings.Settings['useWhirlwind'];
				v49 = EpicSettings.Settings['useWreckingThrow'];
				v31 = EpicSettings.Settings['useAvatar'];
				v119 = 810 - (266 + 539);
			end
			if (((9008 - 5826) >= (3340 - (636 + 589))) and (v119 == (18 - 10))) then
				v56 = EpicSettings.Settings['championsSpearWithCD'];
				v57 = EpicSettings.Settings['thunderousRoarWithCD'];
				break;
			end
			if (((8028 - 4135) < (3510 + 919)) and ((0 + 0) == v119)) then
				v30 = EpicSettings.Settings['useWeapon'];
				v32 = EpicSettings.Settings['useBattleShout'];
				v33 = EpicSettings.Settings['useBloodbath'];
				v119 = 1016 - (657 + 358);
			end
			if (((4 - 2) == v119) or ((6531 - 3664) < (3092 - (1151 + 36)))) then
				v37 = EpicSettings.Settings['useExecute'];
				v38 = EpicSettings.Settings['useHeroicThrow'];
				v40 = EpicSettings.Settings['useOnslaught'];
				v119 = 3 + 0;
			end
			if ((v119 == (2 + 5)) or ((5363 - 3567) >= (5883 - (1552 + 280)))) then
				v53 = EpicSettings.Settings['odynFuryWithCD'];
				v54 = EpicSettings.Settings['ravagerWithCD'];
				v55 = EpicSettings.Settings['recklessnessWithCD'];
				v119 = 842 - (64 + 770);
			end
			if (((1100 + 519) <= (8526 - 4770)) and (v119 == (1 + 4))) then
				v39 = EpicSettings.Settings['useOdynsFury'];
				v43 = EpicSettings.Settings['useRavager'];
				v44 = EpicSettings.Settings['useRecklessness'];
				v119 = 1249 - (157 + 1086);
			end
			if (((1208 - 604) == (2645 - 2041)) and (v119 == (1 - 0))) then
				v34 = EpicSettings.Settings['useBloodthirst'];
				v35 = EpicSettings.Settings['useCharge'];
				v36 = EpicSettings.Settings['useCrushingBlow'];
				v119 = 2 - 0;
			end
		end
	end
	local function v110()
		v60 = EpicSettings.Settings['usePummel'];
		v61 = EpicSettings.Settings['useStormBolt'];
		v62 = EpicSettings.Settings['useIntimidatingShout'];
		v63 = EpicSettings.Settings['useBitterImmunity'];
		v64 = EpicSettings.Settings['useEnragedRegeneration'];
		v65 = EpicSettings.Settings['useIgnorePain'];
		v66 = EpicSettings.Settings['useRallyingCry'];
		v67 = EpicSettings.Settings['useIntervene'];
		v68 = EpicSettings.Settings['useDefensiveStance'];
		v71 = EpicSettings.Settings['useVictoryRush'];
		v72 = EpicSettings.Settings['bitterImmunityHP'] or (819 - (599 + 220));
		v73 = EpicSettings.Settings['enragedRegenerationHP'] or (0 - 0);
		v74 = EpicSettings.Settings['ignorePainHP'] or (1931 - (1813 + 118));
		v75 = EpicSettings.Settings['rallyingCryHP'] or (0 + 0);
		v76 = EpicSettings.Settings['rallyingCryGroup'] or (1217 - (841 + 376));
		v77 = EpicSettings.Settings['interveneHP'] or (0 - 0);
		v78 = EpicSettings.Settings['defensiveStanceHP'] or (0 + 0);
		v81 = EpicSettings.Settings['unstanceHP'] or (0 - 0);
		v82 = EpicSettings.Settings['victoryRushHP'] or (859 - (464 + 395));
		v83 = EpicSettings.Settings['ravagerSetting'] or "player";
		v84 = EpicSettings.Settings['spearSetting'] or "player";
	end
	local function v111()
		local v130 = 0 - 0;
		while true do
			if ((v130 == (1 + 0)) or ((5321 - (467 + 370)) == (1859 - 959))) then
				v89 = EpicSettings.Settings['InterruptThreshold'];
				v51 = EpicSettings.Settings['useTrinkets'];
				v50 = EpicSettings.Settings['useRacials'];
				v130 = 2 + 0;
			end
			if ((v130 == (6 - 4)) or ((696 + 3763) <= (2589 - 1476))) then
				v59 = EpicSettings.Settings['trinketsWithCD'];
				v58 = EpicSettings.Settings['racialsWithCD'];
				v69 = EpicSettings.Settings['useHealthstone'];
				v130 = 523 - (150 + 370);
			end
			if (((4914 - (74 + 1208)) > (8357 - 4959)) and (v130 == (0 - 0))) then
				v90 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v87 = EpicSettings.Settings['InterruptWithStun'];
				v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v130 = 391 - (14 + 376);
			end
			if (((7079 - 2997) <= (3182 + 1735)) and (v130 == (3 + 0))) then
				v70 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v80 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v130 = 4 + 0;
			end
			if (((4910 - (23 + 55)) >= (3284 - 1898)) and (v130 == (3 + 1))) then
				v86 = EpicSettings.Settings['HealingPotionName'] or "";
				v85 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v112()
		local v131 = 0 + 0;
		while true do
			if (((212 - 75) == (44 + 93)) and (v131 == (901 - (652 + 249)))) then
				v110();
				v109();
				v111();
				v131 = 2 - 1;
			end
			if ((v131 == (1870 - (708 + 1160))) or ((4261 - 2691) >= (7897 - 3565))) then
				if (v13:IsDeadOrGhost() or ((4091 - (10 + 17)) <= (409 + 1410))) then
					return v26;
				end
				if (v28 or ((6718 - (1400 + 332)) < (3018 - 1444))) then
					v98 = v13:GetEnemiesInMeleeRange(1916 - (242 + 1666));
					v99 = #v98;
				else
					v99 = 1 + 0;
				end
				v100 = v14:IsInMeleeRange(2 + 3);
				v131 = 3 + 0;
			end
			if (((5366 - (850 + 90)) > (300 - 128)) and (v131 == (1393 - (360 + 1030)))) then
				if (((519 + 67) > (1283 - 828)) and (v91.TargetIsValid() or v13:AffectingCombat())) then
					local v177 = 0 - 0;
					while true do
						if (((2487 - (909 + 752)) == (2049 - (109 + 1114))) and ((0 - 0) == v177)) then
							v96 = v9.BossFightRemains(nil, true);
							v97 = v96;
							v177 = 1 + 0;
						end
						if ((v177 == (243 - (6 + 236))) or ((2533 + 1486) > (3575 + 866))) then
							if (((4756 - 2739) < (7442 - 3181)) and (v97 == (12244 - (1076 + 57)))) then
								v97 = v9.FightRemains(v98, false);
							end
							break;
						end
					end
				end
				if (((776 + 3940) > (769 - (579 + 110))) and not v13:IsChanneling()) then
					if (v13:AffectingCombat() or ((277 + 3230) == (2893 + 379))) then
						local v179 = 0 + 0;
						while true do
							if (((407 - (174 + 233)) == v179) or ((2446 - 1570) >= (5397 - 2322))) then
								v26 = v108();
								if (((1936 + 2416) > (3728 - (663 + 511))) and v26) then
									return v26;
								end
								break;
							end
						end
					else
						v26 = v105();
						if (v26 or ((3931 + 475) < (878 + 3165))) then
							return v26;
						end
					end
				end
				break;
			end
			if ((v131 == (2 - 1)) or ((1144 + 745) >= (7964 - 4581))) then
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				v131 = 4 - 2;
			end
		end
	end
	local function v113()
		v19.Print("Fury Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(35 + 37, v112, v113);
end;
return v0["Epix_Warrior_Fury.lua"]();

