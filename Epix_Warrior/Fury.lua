local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((5766 - (692 + 120)) == (2231 + 672))) then
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
	local v96 = 1826 + 9285;
	local v97 = 2397 + 8714;
	v9:RegisterForEvent(function()
		v96 = 30910 - 19799;
		v97 = 37052 - 25941;
	end, "PLAYER_REGEN_ENABLED");
	local v98, v99;
	local v100;
	local function v101()
		local v114 = 0 + 0;
		local v115;
		while true do
			if (((1256 + 1828) > (33 + 7)) and (v114 == (0 + 0))) then
				v115 = UnitGetTotalAbsorbs(v14:ID());
				if (((1594 + 1818) > (2252 - (797 + 636))) and (v115 > (0 - 0))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v102()
		if (((4781 - (1427 + 192)) <= (1193 + 2248)) and v92.BitterImmunity:IsReady() and v63 and (v13:HealthPercentage() <= v72)) then
			if (((10926 - 6220) > (3982 + 447)) and v23(v92.BitterImmunity)) then
				return "bitter_immunity defensive";
			end
		end
		if (((1294 + 1560) < (4421 - (192 + 134))) and v92.EnragedRegeneration:IsCastable() and v64 and (v13:HealthPercentage() <= v73)) then
			if (v23(v92.EnragedRegeneration) or ((2334 - (316 + 960)) >= (669 + 533))) then
				return "enraged_regeneration defensive";
			end
		end
		if (((2864 + 847) > (3102 + 253)) and v92.IgnorePain:IsCastable() and v65 and (v13:HealthPercentage() <= v74)) then
			if (v23(v92.IgnorePain, nil, nil, true) or ((3463 - 2557) >= (2780 - (83 + 468)))) then
				return "ignore_pain defensive";
			end
		end
		if (((3094 - (1202 + 604)) > (5839 - 4588)) and v92.RallyingCry:IsCastable() and v66 and v13:BuffDown(v92.AspectsFavorBuff) and v13:BuffDown(v92.RallyingCry) and (((v13:HealthPercentage() <= v75) and v91.IsSoloMode()) or v91.AreUnitsBelowHealthPercentage(v75, v76, v92.Intervene))) then
			if (v23(v92.RallyingCry) or ((7510 - 2997) < (9280 - 5928))) then
				return "rallying_cry defensive";
			end
		end
		if ((v92.Intervene:IsCastable() and v67 and (v16:HealthPercentage() <= v77) and (v16:Name() ~= v13:Name())) or ((2390 - (45 + 280)) >= (3085 + 111))) then
			if (v23(v94.InterveneFocus) or ((3824 + 552) <= (541 + 940))) then
				return "intervene defensive";
			end
		end
		if ((v92.DefensiveStance:IsCastable() and v68 and (v13:HealthPercentage() <= v78) and v13:BuffDown(v92.DefensiveStance, true)) or ((1878 + 1514) >= (834 + 3907))) then
			if (((6157 - 2832) >= (4065 - (340 + 1571))) and v23(v92.DefensiveStance)) then
				return "defensive_stance defensive";
			end
		end
		if ((v92.BerserkerStance:IsCastable() and v68 and (v13:HealthPercentage() > v81) and v13:BuffDown(v92.BerserkerStance, true)) or ((511 + 784) >= (5005 - (1733 + 39)))) then
			if (((12027 - 7650) > (2676 - (125 + 909))) and v23(v92.BerserkerStance)) then
				return "berserker_stance after defensive stance defensive";
			end
		end
		if (((6671 - (1096 + 852)) > (609 + 747)) and v93.Healthstone:IsReady() and v69 and (v13:HealthPercentage() <= v79)) then
			if (v23(v94.Healthstone) or ((5905 - 1769) <= (3330 + 103))) then
				return "healthstone defensive 3";
			end
		end
		if (((4757 - (409 + 103)) <= (4867 - (46 + 190))) and v70 and (v13:HealthPercentage() <= v80)) then
			local v160 = 95 - (51 + 44);
			while true do
				if (((1207 + 3069) >= (5231 - (1114 + 203))) and (v160 == (726 - (228 + 498)))) then
					if (((43 + 155) <= (2412 + 1953)) and (v86 == "Refreshing Healing Potion")) then
						if (((5445 - (174 + 489)) > (12182 - 7506)) and v93.RefreshingHealingPotion:IsReady()) then
							if (((6769 - (830 + 1075)) > (2721 - (303 + 221))) and v23(v94.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v86 == "Dreamwalker's Healing Potion") or ((4969 - (231 + 1038)) == (2090 + 417))) then
						if (((5636 - (171 + 991)) >= (1129 - 855)) and v93.DreamwalkersHealingPotion:IsReady()) then
							if (v23(v94.RefreshingHealingPotion) or ((5085 - 3191) <= (3508 - 2102))) then
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
		v26 = v91.HandleTopTrinket(v95, v29, 33 + 7, nil);
		if (((5510 - 3938) >= (4416 - 2885)) and v26) then
			return v26;
		end
		v26 = v91.HandleBottomTrinket(v95, v29, 64 - 24, nil);
		if (v26 or ((14488 - 9801) < (5790 - (111 + 1137)))) then
			return v26;
		end
	end
	local function v104()
		if (((3449 - (91 + 67)) > (4961 - 3294)) and v31 and ((v52 and v29) or not v52) and (v90 < v97) and v92.Avatar:IsCastable() and not v92.TitansTorment:IsAvailable()) then
			if (v23(v92.Avatar, not v100) or ((218 + 655) == (2557 - (423 + 100)))) then
				return "avatar precombat 6";
			end
		end
		if ((v44 and ((v55 and v29) or not v55) and (v90 < v97) and v92.Recklessness:IsCastable() and not v92.RecklessAbandon:IsAvailable()) or ((20 + 2796) < (30 - 19))) then
			if (((1928 + 1771) < (5477 - (326 + 445))) and v23(v92.Recklessness, not v100)) then
				return "recklessness precombat 8";
			end
		end
		if (((11547 - 8901) >= (1950 - 1074)) and v92.Bloodthirst:IsCastable() and v34 and v100) then
			if (((1433 - 819) <= (3895 - (530 + 181))) and v23(v92.Bloodthirst, not v100)) then
				return "bloodthirst precombat 10";
			end
		end
		if (((4007 - (614 + 267)) == (3158 - (19 + 13))) and v35 and v92.Charge:IsReady() and not v100) then
			if (v23(v92.Charge, not v14:IsSpellInRange(v92.Charge)) or ((3559 - 1372) >= (11544 - 6590))) then
				return "charge precombat 12";
			end
		end
	end
	local function v105()
		if (not v13:AffectingCombat() or ((11075 - 7198) == (929 + 2646))) then
			local v161 = 0 - 0;
			while true do
				if (((1465 - 758) > (2444 - (1293 + 519))) and (v161 == (0 - 0))) then
					if ((v92.BerserkerStance:IsCastable() and v13:BuffDown(v92.BerserkerStance, true)) or ((1425 - 879) >= (5132 - 2448))) then
						if (((6317 - 4852) <= (10131 - 5830)) and v23(v92.BerserkerStance)) then
							return "berserker_stance";
						end
					end
					if (((903 + 801) > (291 + 1134)) and v92.BattleShout:IsCastable() and v32 and (v13:BuffDown(v92.BattleShoutBuff, true) or v91.GroupBuffMissing(v92.BattleShoutBuff))) then
						if (v23(v92.BattleShout) or ((1596 - 909) == (979 + 3255))) then
							return "battle_shout precombat";
						end
					end
					break;
				end
			end
		end
		if ((v91.TargetIsValid() and v27) or ((1107 + 2223) < (894 + 535))) then
			if (((2243 - (709 + 387)) >= (2193 - (673 + 1185))) and not v13:AffectingCombat()) then
				local v176 = 0 - 0;
				while true do
					if (((11030 - 7595) > (3449 - 1352)) and (v176 == (0 + 0))) then
						v26 = v104();
						if (v26 or ((2817 + 953) >= (5455 - 1414))) then
							return v26;
						end
						break;
					end
				end
			end
		end
	end
	local function v106()
		local v116 = 0 + 0;
		local v117;
		while true do
			if ((v116 == (9 - 4)) or ((7441 - 3650) <= (3491 - (446 + 1434)))) then
				if ((v92.Rampage:IsReady() and v42) or ((5861 - (1040 + 243)) <= (5993 - 3985))) then
					if (((2972 - (559 + 1288)) <= (4007 - (609 + 1322))) and v23(v92.Rampage, not v100)) then
						return "rampage multi_target 42";
					end
				end
				if ((v92.Slam:IsReady() and v45 and (v92.Annihilator:IsAvailable())) or ((1197 - (13 + 441)) >= (16438 - 12039))) then
					if (((3025 - 1870) < (8332 - 6659)) and v23(v92.Slam, not v100)) then
						return "slam multi_target 44";
					end
				end
				if ((v92.Bloodbath:IsCastable() and v33) or ((87 + 2237) <= (2099 - 1521))) then
					if (((1338 + 2429) == (1651 + 2116)) and v23(v92.Bloodbath, not v100)) then
						return "bloodbath multi_target 46";
					end
				end
				if (((12134 - 8045) == (2238 + 1851)) and v92.RagingBlow:IsCastable() and v41) then
					if (((8198 - 3740) >= (1107 + 567)) and v23(v92.RagingBlow, not v100)) then
						return "raging_blow multi_target 48";
					end
				end
				if (((541 + 431) <= (1019 + 399)) and v92.CrushingBlow:IsCastable() and v36) then
					if (v23(v92.CrushingBlow, not v100) or ((4147 + 791) < (4660 + 102))) then
						return "crushing_blow multi_target 50";
					end
				end
				v116 = 439 - (153 + 280);
			end
			if ((v116 == (8 - 5)) or ((2249 + 255) > (1684 + 2580))) then
				if (((1127 + 1026) == (1954 + 199)) and v92.Execute:IsReady() and v37 and v13:BuffUp(v92.EnrageBuff) and v92.AshenJuggernaut:IsAvailable()) then
					if (v23(v92.Execute, not v100) or ((368 + 139) >= (3944 - 1353))) then
						return "execute multi_target 26";
					end
				end
				if (((2770 + 1711) == (5148 - (89 + 578))) and v92.Bloodthirst:IsCastable() and v34 and (not v13:BuffUp(v92.EnrageBuff) or (v92.Annihilator:IsAvailable() and v13:BuffDown(v92.RecklessnessBuff)))) then
					if (v23(v92.Bloodthirst, not v100) or ((1664 + 664) < (1440 - 747))) then
						return "bloodthirst multi_target 26";
					end
				end
				if (((5377 - (572 + 477)) == (584 + 3744)) and v92.Onslaught:IsReady() and v40 and ((not v92.Annihilator:IsAvailable() and v13:BuffUp(v92.EnrageBuff)) or v92.Tenderize:IsAvailable())) then
					if (((953 + 635) >= (159 + 1173)) and v23(v92.Onslaught, not v100)) then
						return "onslaught multi_target 28";
					end
				end
				if ((v92.Execute:IsReady() and v37 and v13:BuffUp(v92.EnrageBuff)) or ((4260 - (84 + 2)) > (7000 - 2752))) then
					if (v23(v92.Execute, not v100) or ((3304 + 1282) <= (924 - (497 + 345)))) then
						return "execute multi_target 30";
					end
				end
				if (((99 + 3764) == (654 + 3209)) and v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (1334 - (605 + 728))) and v92.WrathandFury:IsAvailable()) then
					if (v23(v92.RagingBlow, not v100) or ((202 + 80) <= (92 - 50))) then
						return "raging_blow multi_target 30";
					end
				end
				v116 = 1 + 3;
			end
			if (((17040 - 12431) >= (691 + 75)) and (v116 == (16 - 10))) then
				if ((v92.Bloodthirst:IsCastable() and v34) or ((870 + 282) == (2977 - (457 + 32)))) then
					if (((1452 + 1970) > (4752 - (832 + 570))) and v23(v92.Bloodthirst, not v100)) then
						return "bloodthirst multi_target 52";
					end
				end
				if (((827 + 50) > (99 + 277)) and v92.Whirlwind:IsCastable() and v48) then
					if (v23(v92.Whirlwind, not v14:IsInMeleeRange(28 - 20)) or ((1502 + 1616) <= (2647 - (588 + 208)))) then
						return "whirlwind multi_target 54";
					end
				end
				break;
			end
			if ((v116 == (5 - 3)) or ((1965 - (884 + 916)) >= (7310 - 3818))) then
				if (((2290 + 1659) < (5509 - (232 + 421))) and v92.Bloodthirst:IsCastable() and v34 and ((v13:HasTier(1919 - (1569 + 320), 1 + 3) and (v117 >= (19 + 76))) or (not v92.RecklessAbandon:IsAvailable() and v13:BuffUp(v92.FuriousBloodthirstBuff) and v13:BuffUp(v92.EnrageBuff)))) then
					if (v23(v92.Bloodthirst, not v100) or ((14409 - 10133) < (3621 - (316 + 289)))) then
						return "bloodthirst multi_target 16";
					end
				end
				if (((12277 - 7587) > (191 + 3934)) and v92.CrushingBlow:IsCastable() and v92.WrathandFury:IsAvailable() and v36 and v13:BuffUp(v92.EnrageBuff)) then
					if (v23(v92.CrushingBlow, not v100) or ((1503 - (666 + 787)) >= (1321 - (360 + 65)))) then
						return "crushing_blow multi_target 14";
					end
				end
				if ((v92.OdynsFury:IsCastable() and ((v53 and v29) or not v53) and v39 and (v90 < v97) and v13:BuffUp(v92.EnrageBuff)) or ((1602 + 112) >= (3212 - (79 + 175)))) then
					if (v23(v92.OdynsFury, not v14:IsInMeleeRange(12 - 4)) or ((1164 + 327) < (1973 - 1329))) then
						return "odyns_fury multi_target 18";
					end
				end
				if (((1355 - 651) < (1886 - (503 + 396))) and v92.Rampage:IsReady() and v42 and (v13:BuffUp(v92.RecklessnessBuff) or (v13:BuffRemains(v92.EnrageBuff) < v13:GCD()) or ((v13:Rage() > (291 - (92 + 89))) and v92.OverwhelmingRage:IsAvailable()) or ((v13:Rage() > (155 - 75)) and not v92.OverwhelmingRage:IsAvailable()))) then
					if (((1907 + 1811) > (1129 + 777)) and v23(v92.Rampage, not v100)) then
						return "rampage multi_target 20";
					end
				end
				if ((v92.Bloodbath:IsCastable() and v33 and v13:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and not v92.WrathandFury:IsAvailable()) or ((3751 - 2793) > (498 + 3137))) then
					if (((7982 - 4481) <= (3920 + 572)) and v23(v92.Bloodbath, not v100)) then
						return "bloodbath multi_target 24";
					end
				end
				v116 = 2 + 1;
			end
			if ((v116 == (2 - 1)) or ((430 + 3012) < (3885 - 1337))) then
				if (((4119 - (485 + 759)) >= (3387 - 1923)) and v92.ThunderousRoar:IsCastable() and ((v57 and v29) or not v57) and v47 and (v90 < v97) and v13:BuffUp(v92.EnrageBuff)) then
					if (v23(v92.ThunderousRoar, not v14:IsInMeleeRange(1197 - (442 + 747))) or ((5932 - (832 + 303)) >= (5839 - (88 + 858)))) then
						return "thunderous_roar multi_target 10";
					end
				end
				if ((v92.OdynsFury:IsCastable() and ((v53 and v29) or not v53) and v39 and (v90 < v97) and (v99 > (1 + 0)) and v13:BuffUp(v92.EnrageBuff)) or ((457 + 94) > (86 + 1982))) then
					if (((2903 - (766 + 23)) > (4660 - 3716)) and v23(v92.OdynsFury, not v14:IsInMeleeRange(10 - 2))) then
						return "odyns_fury multi_target 12";
					end
				end
				if ((v92.Whirlwind:IsCastable() and v48 and (v13:BuffStack(v92.MeatCleaverBuff) == (2 - 1)) and v13:BuffUp(v92.HurricaneBuff) and (v13:Rage() < (271 - 191)) and (v13:Rage() > (1133 - (1036 + 37)))) or ((1604 + 658) >= (6029 - 2933))) then
					if (v23(v92.Whirlwind, not v14:IsInMeleeRange(7 + 1)) or ((3735 - (641 + 839)) >= (4450 - (910 + 3)))) then
						return "whirlwind multi_target 14";
					end
				end
				v117 = v13:CritChancePct() + (v24(v13:BuffUp(v92.RecklessnessBuff)) * (50 - 30)) + (v13:BuffStack(v92.MercilessAssaultBuff) * (1694 - (1466 + 218))) + (v13:BuffStack(v92.BloodcrazeBuff) * (7 + 8));
				if ((v92.Bloodbath:IsCastable() and v33 and ((v13:HasTier(1178 - (556 + 592), 2 + 2) and (v117 >= (903 - (329 + 479)))) or v13:HasTier(885 - (174 + 680), 13 - 9))) or ((7953 - 4116) < (933 + 373))) then
					if (((3689 - (396 + 343)) == (262 + 2688)) and v23(v92.Bloodbath, not v100)) then
						return "bloodbath multi_target 16";
					end
				end
				v116 = 1479 - (29 + 1448);
			end
			if ((v116 == (1393 - (135 + 1254))) or ((17792 - 13069) < (15398 - 12100))) then
				if (((758 + 378) >= (1681 - (389 + 1138))) and v92.CrushingBlow:IsCastable() and v36 and (v92.CrushingBlow:Charges() > (575 - (102 + 472))) and v92.WrathandFury:IsAvailable()) then
					if (v23(v92.CrushingBlow, not v100) or ((256 + 15) > (2633 + 2115))) then
						return "crushing_blow multi_target 32";
					end
				end
				if (((4420 + 320) >= (4697 - (320 + 1225))) and v92.Bloodbath:IsCastable() and v33 and (not v13:BuffUp(v92.EnrageBuff) or not v92.WrathandFury:IsAvailable())) then
					if (v23(v92.Bloodbath, not v100) or ((4589 - 2011) >= (2075 + 1315))) then
						return "bloodbath multi_target 34";
					end
				end
				if (((1505 - (157 + 1307)) <= (3520 - (821 + 1038))) and v92.CrushingBlow:IsCastable() and v36 and v13:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable()) then
					if (((1499 - 898) < (390 + 3170)) and v23(v92.CrushingBlow, not v100)) then
						return "crushing_blow multi_target 36";
					end
				end
				if (((417 - 182) < (256 + 431)) and v92.Bloodthirst:IsCastable() and v34 and not v92.WrathandFury:IsAvailable()) then
					if (((11274 - 6725) > (2179 - (834 + 192))) and v23(v92.Bloodthirst, not v100)) then
						return "bloodthirst multi_target 38";
					end
				end
				if ((v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (1 + 0))) or ((1200 + 3474) < (101 + 4571))) then
					if (((5682 - 2014) < (4865 - (300 + 4))) and v23(v92.RagingBlow, not v100)) then
						return "raging_blow multi_target 40";
					end
				end
				v116 = 2 + 3;
			end
			if ((v116 == (0 - 0)) or ((817 - (112 + 250)) == (1438 + 2167))) then
				if ((v92.Recklessness:IsCastable() and ((v55 and v29) or not v55) and v44 and (v90 < v97) and ((v99 > (2 - 1)) or (v97 < (7 + 5)))) or ((1378 + 1285) == (2478 + 834))) then
					if (((2121 + 2156) <= (3325 + 1150)) and v23(v92.Recklessness, not v100)) then
						return "recklessness multi_target 2";
					end
				end
				if ((v92.OdynsFury:IsCastable() and ((v53 and v29) or not v53) and v39 and (v90 < v97) and (v99 > (1415 - (1001 + 413))) and v92.TitanicRage:IsAvailable() and (v13:BuffDown(v92.MeatCleaverBuff) or v13:BuffUp(v92.AvatarBuff) or v13:BuffUp(v92.RecklessnessBuff))) or ((1940 - 1070) == (2071 - (244 + 638)))) then
					if (((2246 - (627 + 66)) <= (9334 - 6201)) and v23(v92.OdynsFury, not v14:IsInMeleeRange(610 - (512 + 90)))) then
						return "odyns_fury multi_target 4";
					end
				end
				if ((v92.Whirlwind:IsCastable() and v48 and (v99 > (1907 - (1665 + 241))) and v92.ImprovedWhilwind:IsAvailable() and v13:BuffDown(v92.MeatCleaverBuff)) or ((2954 - (373 + 344)) >= (1584 + 1927))) then
					if (v23(v92.Whirlwind, not v14:IsInMeleeRange(3 + 5)) or ((3492 - 2168) > (5110 - 2090))) then
						return "whirlwind multi_target 6";
					end
				end
				if ((v92.Execute:IsReady() and v37 and v13:BuffUp(v92.AshenJuggernautBuff) and (v13:BuffRemains(v92.AshenJuggernautBuff) < v13:GCD())) or ((4091 - (35 + 1064)) == (1369 + 512))) then
					if (((6645 - 3539) > (7 + 1519)) and v23(v92.Execute, not v100)) then
						return "execute multi_target 8";
					end
				end
				if (((4259 - (298 + 938)) < (5129 - (233 + 1026))) and v92.Rampage:IsReady() and v42 and v92.AngerManagement:IsAvailable() and (v13:BuffUp(v92.RecklessnessBuff) or (v13:BuffRemains(v92.EnrageBuff) < v13:GCD()) or (v13:RagePercentage() > (1751 - (636 + 1030))))) then
					if (((74 + 69) > (73 + 1)) and v23(v92.Rampage, not v100)) then
						return "rampage multi_target 10";
					end
				end
				v116 = 1 + 0;
			end
		end
	end
	local function v107()
		local v118 = 0 + 0;
		local v119;
		while true do
			if (((239 - (55 + 166)) < (410 + 1702)) and (v118 == (1 + 4))) then
				if (((4189 - 3092) <= (1925 - (36 + 261))) and v92.CrushingBlow:IsCastable() and v36 and (v92.CrushingBlow:Charges() > (1 - 0)) and v92.WrathandFury:IsAvailable() and v13:BuffDown(v92.FuriousBloodthirstBuff)) then
					if (((5998 - (34 + 1334)) == (1780 + 2850)) and v23(v92.CrushingBlow, not v100)) then
						return "crushing_blow single_target 38";
					end
				end
				if (((2751 + 789) > (3966 - (1035 + 248))) and v92.Bloodbath:IsCastable() and v33 and (not v13:BuffUp(v92.EnrageBuff) or not v92.WrathandFury:IsAvailable())) then
					if (((4815 - (20 + 1)) >= (1707 + 1568)) and v23(v92.Bloodbath, not v100)) then
						return "bloodbath single_target 40";
					end
				end
				if (((1803 - (134 + 185)) == (2617 - (549 + 584))) and v92.CrushingBlow:IsCastable() and v36 and v13:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and v13:BuffDown(v92.FuriousBloodthirstBuff)) then
					if (((2117 - (314 + 371)) < (12204 - 8649)) and v23(v92.CrushingBlow, not v100)) then
						return "crushing_blow single_target 42";
					end
				end
				if ((v92.Bloodthirst:IsCastable() and v34 and not v92.WrathandFury:IsAvailable() and v13:BuffDown(v92.FuriousBloodthirstBuff)) or ((2033 - (478 + 490)) > (1896 + 1682))) then
					if (v23(v92.Bloodthirst, not v100) or ((5967 - (786 + 386)) < (4557 - 3150))) then
						return "bloodthirst single_target 44";
					end
				end
				v118 = 1385 - (1055 + 324);
			end
			if (((3193 - (1093 + 247)) < (4277 + 536)) and (v118 == (1 + 0))) then
				v119 = v13:CritChancePct() + (v24(v13:BuffUp(v92.RecklessnessBuff)) * (79 - 59)) + (v13:BuffStack(v92.MercilessAssaultBuff) * (33 - 23)) + (v13:BuffStack(v92.BloodcrazeBuff) * (42 - 27));
				if ((v92.Bloodbath:IsCastable() and v33 and v13:HasTier(75 - 45, 2 + 2) and (v119 >= (365 - 270))) or ((9723 - 6902) < (1834 + 597))) then
					if (v23(v92.Bloodbath, not v100) or ((7349 - 4475) < (2869 - (364 + 324)))) then
						return "bloodbath single_target 10";
					end
				end
				if ((v92.Bloodthirst:IsCastable() and v34 and ((v13:HasTier(82 - 52, 9 - 5) and (v119 >= (32 + 63))) or (not v92.RecklessAbandon:IsAvailable() and v13:BuffUp(v92.FuriousBloodthirstBuff) and v13:BuffUp(v92.EnrageBuff) and (v14:DebuffDown(v92.GushingWoundDebuff) or v13:BuffUp(v92.ElysianMightBuff))))) or ((11251 - 8562) <= (549 - 206))) then
					if (v23(v92.Bloodthirst, not v100) or ((5676 - 3807) == (3277 - (1249 + 19)))) then
						return "bloodthirst single_target 12";
					end
				end
				if ((v92.Bloodbath:IsCastable() and v33 and v13:HasTier(28 + 3, 7 - 5)) or ((4632 - (686 + 400)) < (1822 + 500))) then
					if (v23(v92.Bloodbath, not v100) or ((2311 - (73 + 156)) == (23 + 4750))) then
						return "bloodbath single_target 14";
					end
				end
				v118 = 813 - (721 + 90);
			end
			if (((37 + 3207) > (3425 - 2370)) and (v118 == (477 - (224 + 246)))) then
				if ((v92.RagingBlow:IsCastable() and v41) or ((5366 - 2053) <= (3273 - 1495))) then
					if (v23(v92.RagingBlow, not v100) or ((258 + 1163) >= (51 + 2053))) then
						return "raging_blow single_target 52";
					end
				end
				if (((1331 + 481) <= (6459 - 3210)) and v92.CrushingBlow:IsCastable() and v36 and v13:BuffDown(v92.FuriousBloodthirstBuff)) then
					if (((5400 - 3777) <= (2470 - (203 + 310))) and v23(v92.CrushingBlow, not v100)) then
						return "crushing_blow single_target 54";
					end
				end
				if (((6405 - (1238 + 755)) == (309 + 4103)) and v92.Bloodthirst:IsCastable() and v34) then
					if (((3284 - (709 + 825)) >= (1551 - 709)) and v23(v92.Bloodthirst, not v100)) then
						return "bloodthirst single_target 56";
					end
				end
				if (((6368 - 1996) > (2714 - (196 + 668))) and v28 and v92.Whirlwind:IsCastable() and v48) then
					if (((915 - 683) < (1700 - 879)) and v23(v92.Whirlwind, not v14:IsInMeleeRange(841 - (171 + 662)))) then
						return "whirlwind single_target 58";
					end
				end
				v118 = 101 - (4 + 89);
			end
			if (((1815 - 1297) < (329 + 573)) and (v118 == (0 - 0))) then
				if (((1175 + 1819) > (2344 - (35 + 1451))) and v92.Whirlwind:IsCastable() and v48 and (v99 > (1454 - (28 + 1425))) and v92.ImprovedWhilwind:IsAvailable() and v13:BuffDown(v92.MeatCleaverBuff)) then
					if (v23(v92.Whirlwind, not v14:IsInMeleeRange(2001 - (941 + 1052))) or ((3601 + 154) <= (2429 - (822 + 692)))) then
						return "whirlwind single_target 2";
					end
				end
				if (((5632 - 1686) > (1764 + 1979)) and v92.Execute:IsReady() and v37 and v13:BuffUp(v92.AshenJuggernautBuff) and (v13:BuffRemains(v92.AshenJuggernautBuff) < v13:GCD())) then
					if (v23(v92.Execute, not v100) or ((1632 - (45 + 252)) >= (3272 + 34))) then
						return "execute single_target 4";
					end
				end
				if (((1668 + 3176) > (5483 - 3230)) and v39 and ((v53 and v29) or not v53) and v92.OdynsFury:IsCastable() and (v90 < v97) and v13:BuffUp(v92.EnrageBuff) and ((v92.DancingBlades:IsAvailable() and (v13:BuffRemains(v92.DancingBladesBuff) < (438 - (114 + 319)))) or not v92.DancingBlades:IsAvailable())) then
					if (((648 - 196) == (578 - 126)) and v23(v92.OdynsFury, not v14:IsInMeleeRange(6 + 2))) then
						return "odyns_fury single_target 6";
					end
				end
				if ((v92.Rampage:IsReady() and v42 and v92.AngerManagement:IsAvailable() and (v13:BuffUp(v92.RecklessnessBuff) or (v13:BuffRemains(v92.EnrageBuff) < v13:GCD()) or (v13:RagePercentage() > (126 - 41)))) or ((9548 - 4991) < (4050 - (556 + 1407)))) then
					if (((5080 - (741 + 465)) == (4339 - (170 + 295))) and v23(v92.Rampage, not v100)) then
						return "rampage single_target 8";
					end
				end
				v118 = 1 + 0;
			end
			if ((v118 == (4 + 0)) or ((4771 - 2833) > (4091 + 844))) then
				if ((v92.Bloodbath:IsCastable() and v33 and v13:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and not v92.WrathandFury:IsAvailable()) or ((2729 + 1526) < (1939 + 1484))) then
					if (((2684 - (957 + 273)) <= (667 + 1824)) and v23(v92.Bloodbath, not v100)) then
						return "bloodbath single_target 30";
					end
				end
				if ((v92.Rampage:IsReady() and v42 and (v14:HealthPercentage() < (15 + 20)) and v92.Massacre:IsAvailable()) or ((15840 - 11683) <= (7386 - 4583))) then
					if (((14823 - 9970) >= (14765 - 11783)) and v23(v92.Rampage, not v100)) then
						return "rampage single_target 32";
					end
				end
				if (((5914 - (389 + 1391)) > (2107 + 1250)) and v92.Bloodthirst:IsCastable() and v34 and (not v13:BuffUp(v92.EnrageBuff) or (v92.Annihilator:IsAvailable() and v13:BuffDown(v92.RecklessnessBuff))) and v13:BuffDown(v92.FuriousBloodthirstBuff)) then
					if (v23(v92.Bloodthirst, not v100) or ((356 + 3061) < (5768 - 3234))) then
						return "bloodthirst single_target 34";
					end
				end
				if ((v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (952 - (783 + 168))) and v92.WrathandFury:IsAvailable()) or ((9135 - 6413) <= (162 + 2))) then
					if (v23(v92.RagingBlow, not v100) or ((2719 - (309 + 2)) < (6476 - 4367))) then
						return "raging_blow single_target 36";
					end
				end
				v118 = 1217 - (1090 + 122);
			end
			if (((1 + 2) == v118) or ((110 - 77) == (996 + 459))) then
				if ((v92.Rampage:IsReady() and v42 and v92.RecklessAbandon:IsAvailable() and (v13:BuffUp(v92.RecklessnessBuff) or (v13:BuffRemains(v92.EnrageBuff) < v13:GCD()) or (v13:RagePercentage() > (1203 - (628 + 490))))) or ((80 + 363) >= (9940 - 5925))) then
					if (((15455 - 12073) > (940 - (431 + 343))) and v23(v92.Rampage, not v100)) then
						return "rampage single_target 24";
					end
				end
				if ((v92.Execute:IsReady() and v37 and v13:BuffUp(v92.EnrageBuff)) or ((565 - 285) == (8849 - 5790))) then
					if (((1487 + 394) > (166 + 1127)) and v23(v92.Execute, not v100)) then
						return "execute single_target 26";
					end
				end
				if (((4052 - (556 + 1139)) == (2372 - (6 + 9))) and v92.Rampage:IsReady() and v42 and v92.AngerManagement:IsAvailable()) then
					if (((23 + 100) == (64 + 59)) and v23(v92.Rampage, not v100)) then
						return "rampage single_target 28";
					end
				end
				if ((v92.Execute:IsReady() and v37) or ((1225 - (28 + 141)) >= (1314 + 2078))) then
					if (v23(v92.Execute, not v100) or ((1334 - 253) < (762 + 313))) then
						return "execute single_target 29";
					end
				end
				v118 = 1321 - (486 + 831);
			end
			if ((v118 == (15 - 9)) or ((3692 - 2643) >= (838 + 3594))) then
				if ((v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (3 - 2))) or ((6031 - (668 + 595)) <= (762 + 84))) then
					if (v23(v92.RagingBlow, not v100) or ((678 + 2680) <= (3872 - 2452))) then
						return "raging_blow single_target 46";
					end
				end
				if ((v92.Rampage:IsReady() and v42) or ((4029 - (23 + 267)) <= (4949 - (1129 + 815)))) then
					if (v23(v92.Rampage, not v100) or ((2046 - (371 + 16)) >= (3884 - (1326 + 424)))) then
						return "rampage single_target 47";
					end
				end
				if ((v92.Slam:IsReady() and v45 and (v92.Annihilator:IsAvailable())) or ((6174 - 2914) < (8605 - 6250))) then
					if (v23(v92.Slam, not v100) or ((787 - (88 + 30)) == (4994 - (720 + 51)))) then
						return "slam single_target 48";
					end
				end
				if ((v92.Bloodbath:IsCastable() and v33) or ((3763 - 2071) < (2364 - (421 + 1355)))) then
					if (v23(v92.Bloodbath, not v100) or ((7913 - 3116) < (1794 + 1857))) then
						return "bloodbath single_target 50";
					end
				end
				v118 = 1090 - (286 + 797);
			end
			if ((v118 == (7 - 5)) or ((6918 - 2741) > (5289 - (397 + 42)))) then
				if ((v47 and ((v57 and v29) or not v57) and (v90 < v97) and v92.ThunderousRoar:IsCastable() and v13:BuffUp(v92.EnrageBuff)) or ((125 + 275) > (1911 - (24 + 776)))) then
					if (((4699 - 1648) > (1790 - (222 + 563))) and v23(v92.ThunderousRoar, not v14:IsInMeleeRange(17 - 9))) then
						return "thunderous_roar single_target 16";
					end
				end
				if (((2659 + 1034) <= (4572 - (23 + 167))) and v92.Onslaught:IsReady() and v40 and (v13:BuffUp(v92.EnrageBuff) or v92.Tenderize:IsAvailable())) then
					if (v23(v92.Onslaught, not v100) or ((5080 - (690 + 1108)) > (1480 + 2620))) then
						return "onslaught single_target 18";
					end
				end
				if ((v92.CrushingBlow:IsCastable() and v36 and v92.WrathandFury:IsAvailable() and v13:BuffUp(v92.EnrageBuff) and v13:BuffDown(v92.FuriousBloodthirstBuff)) or ((2953 + 627) < (3692 - (40 + 808)))) then
					if (((15 + 74) < (17169 - 12679)) and v23(v92.CrushingBlow, not v100)) then
						return "crushing_blow single_target 20";
					end
				end
				if ((v92.Execute:IsReady() and v37 and ((v13:BuffUp(v92.EnrageBuff) and v13:BuffDown(v92.FuriousBloodthirstBuff) and v13:BuffUp(v92.AshenJuggernautBuff)) or ((v13:BuffRemains(v92.SuddenDeathBuff) <= v13:GCD()) and (((v14:HealthPercentage() > (34 + 1)) and v92.Massacre:IsAvailable()) or (v14:HealthPercentage() > (11 + 9)))))) or ((2733 + 2250) < (2379 - (47 + 524)))) then
					if (((2485 + 1344) > (10302 - 6533)) and v23(v92.Execute, not v100)) then
						return "execute single_target 22";
					end
				end
				v118 = 4 - 1;
			end
			if (((3386 - 1901) <= (4630 - (1165 + 561))) and (v118 == (1 + 7))) then
				if (((13221 - 8952) == (1629 + 2640)) and v92.WreckingThrow:IsCastable() and v49 and v101()) then
					if (((866 - (341 + 138)) <= (751 + 2031)) and v23(v92.WreckingThrow, not v100)) then
						return "wrecking_throw single_target 60";
					end
				end
				break;
			end
		end
	end
	local function v108()
		v26 = v102();
		if (v26 or ((3918 - 2019) <= (1243 - (89 + 237)))) then
			return v26;
		end
		if (v85 or ((13871 - 9559) <= (1844 - 968))) then
			local v162 = 881 - (581 + 300);
			while true do
				if (((3452 - (855 + 365)) <= (6165 - 3569)) and (v162 == (1 + 0))) then
					v26 = v91.HandleIncorporeal(v92.IntimidatingShout, v94.IntimidatingShoutMouseover, 1243 - (1030 + 205), true);
					if (((1967 + 128) < (3429 + 257)) and v26) then
						return v26;
					end
					break;
				end
				if ((v162 == (286 - (156 + 130))) or ((3624 - 2029) >= (7539 - 3065))) then
					v26 = v91.HandleIncorporeal(v92.StormBolt, v94.StormBoltMouseover, 40 - 20, true);
					if (v26 or ((1218 + 3401) < (1681 + 1201))) then
						return v26;
					end
					v162 = 70 - (10 + 59);
				end
			end
		end
		if (v91.TargetIsValid() or ((84 + 210) >= (23791 - 18960))) then
			if (((3192 - (671 + 492)) <= (2456 + 628)) and v35 and v92.Charge:IsCastable()) then
				if (v23(v92.Charge, not v14:IsSpellInRange(v92.Charge)) or ((3252 - (369 + 846)) == (641 + 1779))) then
					return "charge main 2";
				end
			end
			local v163 = v91.HandleDPSPotion(v14:BuffUp(v92.RecklessnessBuff));
			if (((3805 + 653) > (5849 - (1036 + 909))) and v163) then
				return v163;
			end
			if (((347 + 89) >= (206 - 83)) and (v90 < v97)) then
				if (((703 - (11 + 192)) < (918 + 898)) and v51 and ((v29 and v59) or not v59)) then
					local v179 = 175 - (135 + 40);
					while true do
						if (((8659 - 5085) == (2155 + 1419)) and (v179 == (0 - 0))) then
							v26 = v103();
							if (((330 - 109) < (566 - (50 + 126))) and v26) then
								return v26;
							end
							break;
						end
					end
				end
				if ((v29 and v93.FyralathTheDreamrender:IsEquippedAndReady() and v30) or ((6162 - 3949) <= (315 + 1106))) then
					if (((4471 - (1233 + 180)) < (5829 - (522 + 447))) and v23(v94.UseWeapon)) then
						return "Fyralath The Dreamrender used";
					end
				end
			end
			if ((v92.Ravager:IsCastable() and (v83 == "player") and v43 and ((v54 and v29) or not v54) and ((v92.Avatar:CooldownRemains() < (1424 - (107 + 1314))) or v13:BuffUp(v92.RecklessnessBuff) or (v97 < (5 + 5)))) or ((3948 - 2652) >= (1889 + 2557))) then
				if (v23(v94.RavagerPlayer, not v100) or ((2766 - 1373) > (17761 - 13272))) then
					return "ravager main 4";
				end
			end
			if ((v92.Ravager:IsCastable() and (v83 == "cursor") and v43 and ((v54 and v29) or not v54) and ((v92.Avatar:CooldownRemains() < (1913 - (716 + 1194))) or v13:BuffUp(v92.RecklessnessBuff) or (v97 < (1 + 9)))) or ((474 + 3950) < (530 - (74 + 429)))) then
				if (v23(v94.RavagerCursor, not v14:IsInRange(38 - 18)) or ((990 + 1007) > (8732 - 4917))) then
					return "ravager main 6";
				end
			end
			if (((2452 + 1013) > (5897 - 3984)) and (v90 < v97) and v50 and ((v58 and v29) or not v58)) then
				if (((1812 - 1079) < (2252 - (279 + 154))) and v92.BloodFury:IsCastable()) then
					if (v23(v92.BloodFury, not v100) or ((5173 - (454 + 324)) == (3742 + 1013))) then
						return "blood_fury main 12";
					end
				end
				if ((v92.Berserking:IsCastable() and v13:BuffUp(v92.RecklessnessBuff)) or ((3810 - (12 + 5)) < (1278 + 1091))) then
					if (v23(v92.Berserking, not v100) or ((10406 - 6322) == (98 + 167))) then
						return "berserking main 14";
					end
				end
				if (((5451 - (277 + 816)) == (18622 - 14264)) and v92.LightsJudgment:IsCastable() and v13:BuffDown(v92.RecklessnessBuff)) then
					if (v23(v92.LightsJudgment, not v14:IsSpellInRange(v92.LightsJudgment)) or ((4321 - (1058 + 125)) < (187 + 806))) then
						return "lights_judgment main 16";
					end
				end
				if (((4305 - (815 + 160)) > (9967 - 7644)) and v92.Fireblood:IsCastable()) then
					if (v23(v92.Fireblood, not v100) or ((8607 - 4981) == (952 + 3037))) then
						return "fireblood main 18";
					end
				end
				if (v92.AncestralCall:IsCastable() or ((2677 - 1761) == (4569 - (41 + 1857)))) then
					if (((2165 - (1222 + 671)) == (702 - 430)) and v23(v92.AncestralCall, not v100)) then
						return "ancestral_call main 20";
					end
				end
				if (((6106 - 1857) <= (6021 - (229 + 953))) and v92.BagofTricks:IsCastable() and v13:BuffDown(v92.RecklessnessBuff) and v13:BuffUp(v92.EnrageBuff)) then
					if (((4551 - (1111 + 663)) < (4779 - (874 + 705))) and v23(v92.BagofTricks, not v14:IsSpellInRange(v92.BagofTricks))) then
						return "bag_of_tricks main 22";
					end
				end
			end
			if (((14 + 81) < (1336 + 621)) and (v90 < v97)) then
				local v177 = 0 - 0;
				while true do
					if (((24 + 802) < (2396 - (642 + 37))) and (v177 == (1 + 0))) then
						if (((229 + 1197) >= (2774 - 1669)) and v92.Recklessness:IsCastable() and v44 and ((v55 and v29) or not v55) and (not v92.Annihilator:IsAvailable() or (v97 < (466 - (233 + 221))))) then
							if (((6368 - 3614) <= (2975 + 404)) and v23(v92.Recklessness, not v100)) then
								return "recklessness main 27";
							end
						end
						if ((v92.ChampionsSpear:IsCastable() and (v84 == "player") and v46 and ((v56 and v29) or not v56) and ((v13:BuffUp(v92.EnrageBuff) and v13:BuffUp(v92.FuriousBloodthirstBuff) and v92.TitansTorment:IsAvailable()) or not v92.TitansTorment:IsAvailable() or (v97 < (1561 - (718 + 823))) or (v99 > (1 + 0)) or not v13:HasTier(836 - (266 + 539), 5 - 3))) or ((5152 - (636 + 589)) == (3353 - 1940))) then
							if (v23(v94.ChampionsSpearPlayer, not v100) or ((2380 - 1226) <= (625 + 163))) then
								return "spear_of_bastion main 30";
							end
						end
						v177 = 1 + 1;
					end
					if ((v177 == (1015 - (657 + 358))) or ((4350 - 2707) > (7698 - 4319))) then
						if ((v92.Avatar:IsCastable() and v31 and ((v52 and v29) or not v52) and ((v92.TitansTorment:IsAvailable() and v13:BuffUp(v92.EnrageBuff) and v13:BuffDown(v92.AvatarBuff) and v92.OdynsFury:CooldownDown()) or (v92.BerserkersTorment:IsAvailable() and v13:BuffUp(v92.EnrageBuff) and v13:BuffDown(v92.AvatarBuff)) or (not v92.TitansTorment:IsAvailable() and not v92.BerserkersTorment:IsAvailable() and (v13:BuffUp(v92.RecklessnessBuff) or (v97 < (1207 - (1151 + 36))))))) or ((2707 + 96) > (1196 + 3353))) then
							if (v23(v92.Avatar, not v100) or ((657 - 437) >= (4854 - (1552 + 280)))) then
								return "avatar main 24";
							end
						end
						if (((3656 - (64 + 770)) == (1916 + 906)) and v92.Recklessness:IsCastable() and v44 and ((v55 and v29) or not v55) and ((v92.Annihilator:IsAvailable() and (v92.ChampionsSpear:CooldownRemains() < (2 - 1))) or (v92.Avatar:CooldownRemains() > (8 + 32)) or not v92.Avatar:IsAvailable() or (v97 < (1255 - (157 + 1086))))) then
							if (v23(v92.Recklessness, not v100) or ((2123 - 1062) == (8133 - 6276))) then
								return "recklessness main 26";
							end
						end
						v177 = 1 - 0;
					end
					if (((3767 - 1007) > (2183 - (599 + 220))) and ((3 - 1) == v177)) then
						if ((v92.ChampionsSpear:IsCastable() and (v84 == "cursor") and v46 and ((v56 and v29) or not v56) and ((v13:BuffUp(v92.EnrageBuff) and v13:BuffUp(v92.FuriousBloodthirstBuff) and v92.TitansTorment:IsAvailable()) or not v92.TitansTorment:IsAvailable() or (v97 < (1951 - (1813 + 118))) or (v99 > (1 + 0)) or not v13:HasTier(1248 - (841 + 376), 2 - 0))) or ((1139 + 3763) <= (9812 - 6217))) then
							if (v23(v94.ChampionsSpearCursor, not v14:IsInRange(889 - (464 + 395))) or ((9885 - 6033) == (141 + 152))) then
								return "spear_of_bastion main 31";
							end
						end
						break;
					end
				end
			end
			if ((v38 and v92.HeroicThrow:IsCastable() and not v14:IsInRange(862 - (467 + 370)) and v13:CanAttack(v14)) or ((3221 - 1662) == (3368 + 1220))) then
				if (v23(v92.HeroicThrow, not v14:IsSpellInRange(v92.HeroicThrow)) or ((15371 - 10887) == (123 + 665))) then
					return "heroic_throw main";
				end
			end
			if (((10627 - 6059) >= (4427 - (150 + 370))) and v92.WreckingThrow:IsCastable() and v49 and v101() and v13:CanAttack(v14)) then
				if (((2528 - (74 + 1208)) < (8534 - 5064)) and v23(v92.WreckingThrow, not v14:IsSpellInRange(v92.WreckingThrow))) then
					return "wrecking_throw main";
				end
			end
			if (((19292 - 15224) >= (692 + 280)) and v28 and (v99 >= (392 - (14 + 376)))) then
				v26 = v106();
				if (((854 - 361) < (2520 + 1373)) and v26) then
					return v26;
				end
			end
			v26 = v107();
			if (v26 or ((1294 + 179) >= (3178 + 154))) then
				return v26;
			end
		end
	end
	local function v109()
		v30 = EpicSettings.Settings['useWeapon'];
		v32 = EpicSettings.Settings['useBattleShout'];
		v33 = EpicSettings.Settings['useBloodbath'];
		v34 = EpicSettings.Settings['useBloodthirst'];
		v35 = EpicSettings.Settings['useCharge'];
		v36 = EpicSettings.Settings['useCrushingBlow'];
		v37 = EpicSettings.Settings['useExecute'];
		v38 = EpicSettings.Settings['useHeroicThrow'];
		v40 = EpicSettings.Settings['useOnslaught'];
		v41 = EpicSettings.Settings['useRagingBlow'];
		v42 = EpicSettings.Settings['useRampage'];
		v45 = EpicSettings.Settings['useSlam'];
		v48 = EpicSettings.Settings['useWhirlwind'];
		v49 = EpicSettings.Settings['useWreckingThrow'];
		v31 = EpicSettings.Settings['useAvatar'];
		v39 = EpicSettings.Settings['useOdynsFury'];
		v43 = EpicSettings.Settings['useRavager'];
		v44 = EpicSettings.Settings['useRecklessness'];
		v46 = EpicSettings.Settings['useChampionsSpear'];
		v47 = EpicSettings.Settings['useThunderousRoar'];
		v52 = EpicSettings.Settings['avatarWithCD'];
		v53 = EpicSettings.Settings['odynFuryWithCD'];
		v54 = EpicSettings.Settings['ravagerWithCD'];
		v55 = EpicSettings.Settings['recklessnessWithCD'];
		v56 = EpicSettings.Settings['championsSpearWithCD'];
		v57 = EpicSettings.Settings['thunderousRoarWithCD'];
	end
	local function v110()
		local v146 = 0 - 0;
		while true do
			if ((v146 == (3 + 0)) or ((4129 - (23 + 55)) <= (2741 - 1584))) then
				v74 = EpicSettings.Settings['ignorePainHP'] or (0 + 0);
				v75 = EpicSettings.Settings['rallyingCryHP'] or (0 + 0);
				v76 = EpicSettings.Settings['rallyingCryGroup'] or (0 - 0);
				v77 = EpicSettings.Settings['interveneHP'] or (0 + 0);
				v146 = 905 - (652 + 249);
			end
			if (((1616 - 1012) < (4749 - (708 + 1160))) and (v146 == (2 - 1))) then
				v64 = EpicSettings.Settings['useEnragedRegeneration'];
				v65 = EpicSettings.Settings['useIgnorePain'];
				v66 = EpicSettings.Settings['useRallyingCry'];
				v67 = EpicSettings.Settings['useIntervene'];
				v146 = 3 - 1;
			end
			if ((v146 == (29 - (10 + 17))) or ((203 + 697) == (5109 - (1400 + 332)))) then
				v68 = EpicSettings.Settings['useDefensiveStance'];
				v71 = EpicSettings.Settings['useVictoryRush'];
				v72 = EpicSettings.Settings['bitterImmunityHP'] or (0 - 0);
				v73 = EpicSettings.Settings['enragedRegenerationHP'] or (1908 - (242 + 1666));
				v146 = 2 + 1;
			end
			if (((1635 + 2824) > (504 + 87)) and (v146 == (945 - (850 + 90)))) then
				v84 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
			if (((5951 - 2553) >= (3785 - (360 + 1030))) and (v146 == (0 + 0))) then
				v60 = EpicSettings.Settings['usePummel'];
				v61 = EpicSettings.Settings['useStormBolt'];
				v62 = EpicSettings.Settings['useIntimidatingShout'];
				v63 = EpicSettings.Settings['useBitterImmunity'];
				v146 = 2 - 1;
			end
			if ((v146 == (5 - 1)) or ((3844 - (909 + 752)) >= (4047 - (109 + 1114)))) then
				v78 = EpicSettings.Settings['defensiveStanceHP'] or (0 - 0);
				v81 = EpicSettings.Settings['unstanceHP'] or (0 + 0);
				v82 = EpicSettings.Settings['victoryRushHP'] or (242 - (6 + 236));
				v83 = EpicSettings.Settings['ravagerSetting'] or "player";
				v146 = 4 + 1;
			end
		end
	end
	local function v111()
		v90 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v87 = EpicSettings.Settings['InterruptWithStun'];
		v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v89 = EpicSettings.Settings['InterruptThreshold'];
		v51 = EpicSettings.Settings['useTrinkets'];
		v50 = EpicSettings.Settings['useRacials'];
		v59 = EpicSettings.Settings['trinketsWithCD'];
		v58 = EpicSettings.Settings['racialsWithCD'];
		v69 = EpicSettings.Settings['useHealthstone'];
		v70 = EpicSettings.Settings['useHealingPotion'];
		v79 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v80 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v86 = EpicSettings.Settings['HealingPotionName'] or "";
		v85 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v112()
		v110();
		v109();
		v111();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		if (((3069 - (1076 + 57)) == (319 + 1617)) and v13:IsDeadOrGhost()) then
			return v26;
		end
		if (v28 or ((5521 - (579 + 110)) < (341 + 3972))) then
			local v164 = 0 + 0;
			while true do
				if (((2170 + 1918) > (4281 - (174 + 233))) and ((0 - 0) == v164)) then
					v98 = v13:GetEnemiesInMeleeRange(13 - 5);
					v99 = #v98;
					break;
				end
			end
		else
			v99 = 1 + 0;
		end
		v100 = v14:IsInMeleeRange(1179 - (663 + 511));
		if (((3865 + 467) == (941 + 3391)) and (v91.TargetIsValid() or v13:AffectingCombat())) then
			local v165 = 0 - 0;
			while true do
				if (((2422 + 1577) >= (6827 - 3927)) and ((0 - 0) == v165)) then
					v96 = v9.BossFightRemains(nil, true);
					v97 = v96;
					v165 = 1 + 0;
				end
				if (((1 - 0) == v165) or ((1800 + 725) > (372 + 3692))) then
					if (((5093 - (478 + 244)) == (4888 - (440 + 77))) and (v97 == (5052 + 6059))) then
						v97 = v9.FightRemains(v98, false);
					end
					break;
				end
			end
		end
		if (not v13:IsChanneling() or ((973 - 707) > (6542 - (655 + 901)))) then
			if (((370 + 1621) >= (709 + 216)) and v13:AffectingCombat()) then
				v26 = v108();
				if (((308 + 147) < (8270 - 6217)) and v26) then
					return v26;
				end
			else
				local v178 = 1445 - (695 + 750);
				while true do
					if (((0 - 0) == v178) or ((1274 - 448) == (19509 - 14658))) then
						v26 = v105();
						if (((534 - (285 + 66)) == (426 - 243)) and v26) then
							return v26;
						end
						break;
					end
				end
			end
		end
	end
	local function v113()
		v19.Print("Fury Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(1382 - (682 + 628), v112, v113);
end;
return v0["Epix_Warrior_Fury.lua"]();

