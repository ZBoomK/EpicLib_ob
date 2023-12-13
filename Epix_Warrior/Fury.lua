local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1225 - (942 + 283);
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((848 + 508) == (4648 - (709 + 387)))) then
			v6 = v0[v4];
			if (((5994 - (673 + 1185)) >= (6951 - 4554)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
		end
		if ((v5 == (1 - 0)) or ((3100 + 1234) == (3172 + 1073))) then
			return v6(...);
		end
	end
end
v0["Epix_Warrior_Fury.lua"] = function(...)
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
	local v91 = v20.Commons.Everyone;
	local v92 = v18.Warrior.Fury;
	local v93 = v19.Warrior.Fury;
	local v94 = v23.Warrior.Fury;
	local v95 = {};
	local v96 = 15001 - 3890;
	local v97 = 2729 + 8382;
	v10:RegisterForEvent(function()
		v96 = 22154 - 11043;
		v97 = 21810 - 10699;
	end, "PLAYER_REGEN_ENABLED");
	local v98, v99;
	local v100;
	local function v101()
		local v114 = 1880 - (446 + 1434);
		local v115;
		while true do
			if ((v114 == (1283 - (1040 + 243))) or ((12762 - 8486) <= (4878 - (559 + 1288)))) then
				v115 = UnitGetTotalAbsorbs(v15);
				if ((v115 > (1931 - (609 + 1322))) or ((5236 - (13 + 441)) <= (4480 - 3281))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v102()
		local v116 = 0 - 0;
		while true do
			if ((v116 == (4 - 3)) or ((182 + 4682) < (6907 - 5005))) then
				if (((1719 + 3120) >= (1622 + 2078)) and v92.IgnorePain:IsCastable() and v65 and (v14:HealthPercentage() <= v74)) then
					if (v24(v92.IgnorePain, nil, nil, true) or ((3190 - 2115) > (1050 + 868))) then
						return "ignore_pain defensive";
					end
				end
				if (((727 - 331) <= (2515 + 1289)) and v92.RallyingCry:IsCastable() and v66 and v14:BuffDown(v92.AspectsFavorBuff) and v14:BuffDown(v92.RallyingCry) and (((v14:HealthPercentage() <= v75) and v91.IsSoloMode()) or v91.AreUnitsBelowHealthPercentage(v75, v76))) then
					if (v24(v92.RallyingCry) or ((2319 + 1850) == (1572 + 615))) then
						return "rallying_cry defensive";
					end
				end
				v116 = 2 + 0;
			end
			if (((1376 + 30) == (1839 - (153 + 280))) and (v116 == (0 - 0))) then
				if (((1375 + 156) < (1687 + 2584)) and v92.BitterImmunity:IsReady() and v63 and (v14:HealthPercentage() <= v72)) then
					if (((333 + 302) == (577 + 58)) and v24(v92.BitterImmunity)) then
						return "bitter_immunity defensive";
					end
				end
				if (((2445 + 928) <= (5414 - 1858)) and v92.EnragedRegeneration:IsCastable() and v64 and (v14:HealthPercentage() <= v73)) then
					if (v24(v92.EnragedRegeneration) or ((2035 + 1256) < (3947 - (89 + 578)))) then
						return "enraged_regeneration defensive";
					end
				end
				v116 = 1 + 0;
			end
			if (((9117 - 4731) >= (1922 - (572 + 477))) and (v116 == (1 + 3))) then
				if (((553 + 368) <= (132 + 970)) and v70 and (v14:HealthPercentage() <= v80)) then
					if (((4792 - (84 + 2)) >= (1586 - 623)) and (v86 == "Refreshing Healing Potion")) then
						if (v93.RefreshingHealingPotion:IsReady() or ((692 + 268) <= (1718 - (497 + 345)))) then
							if (v24(v94.RefreshingHealingPotion) or ((53 + 2013) == (158 + 774))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((6158 - (605 + 728)) < (3456 + 1387)) and (v86 == "Dreamwalker's Healing Potion")) then
						if (v93.DreamwalkersHealingPotion:IsReady() or ((8619 - 4742) >= (208 + 4329))) then
							if (v24(v94.RefreshingHealingPotion) or ((15953 - 11638) < (1556 + 170))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if ((v116 == (5 - 3)) or ((2778 + 901) < (1114 - (457 + 32)))) then
				if ((v92.Intervene:IsCastable() and v67 and (v17:HealthPercentage() <= v77) and (v17:UnitName() ~= v14:UnitName())) or ((1963 + 2662) < (2034 - (832 + 570)))) then
					if (v24(v94.InterveneFocus) or ((79 + 4) > (465 + 1315))) then
						return "intervene defensive";
					end
				end
				if (((1932 - 1386) <= (519 + 558)) and v92.DefensiveStance:IsCastable() and v68 and (v14:HealthPercentage() <= v78) and v14:BuffDown(v92.DefensiveStance, true)) then
					if (v24(v92.DefensiveStance) or ((1792 - (588 + 208)) > (11592 - 7291))) then
						return "defensive_stance defensive";
					end
				end
				v116 = 1803 - (884 + 916);
			end
			if (((8520 - 4450) > (399 + 288)) and (v116 == (656 - (232 + 421)))) then
				if ((v92.BerserkerStance:IsCastable() and v68 and (v14:HealthPercentage() > v81) and v14:BuffDown(v92.BerserkerStance, true)) or ((2545 - (1569 + 320)) >= (817 + 2513))) then
					if (v24(v92.BerserkerStance) or ((474 + 2018) <= (1128 - 793))) then
						return "berserker_stance after defensive stance defensive";
					end
				end
				if (((4927 - (316 + 289)) >= (6706 - 4144)) and v93.Healthstone:IsReady() and v69 and (v14:HealthPercentage() <= v79)) then
					if (v24(v94.Healthstone) or ((168 + 3469) >= (5223 - (666 + 787)))) then
						return "healthstone defensive 3";
					end
				end
				v116 = 429 - (360 + 65);
			end
		end
	end
	local function v103()
		local v117 = 0 + 0;
		while true do
			if ((v117 == (255 - (79 + 175))) or ((3750 - 1371) > (3573 + 1005))) then
				v27 = v91.HandleBottomTrinket(v95, v30, 122 - 82, nil);
				if (v27 or ((930 - 447) > (1642 - (503 + 396)))) then
					return v27;
				end
				break;
			end
			if (((2635 - (92 + 89)) > (1120 - 542)) and (v117 == (0 + 0))) then
				v27 = v91.HandleTopTrinket(v95, v30, 24 + 16, nil);
				if (((3642 - 2712) < (610 + 3848)) and v27) then
					return v27;
				end
				v117 = 2 - 1;
			end
		end
	end
	local function v104()
		if (((578 + 84) <= (465 + 507)) and v31 and ((v52 and v30) or not v52) and (v90 < v97) and v92.Avatar:IsCastable() and not v92.TitansTorment:IsAvailable()) then
			if (((13309 - 8939) == (546 + 3824)) and v24(v92.Avatar, not v100)) then
				return "avatar precombat 6";
			end
		end
		if ((v44 and ((v55 and v30) or not v55) and (v90 < v97) and v92.Recklessness:IsCastable() and not v92.RecklessAbandon:IsAvailable()) or ((7261 - 2499) <= (2105 - (485 + 759)))) then
			if (v24(v92.Recklessness, not v100) or ((3267 - 1855) == (5453 - (442 + 747)))) then
				return "recklessness precombat 8";
			end
		end
		if ((v92.Bloodthirst:IsCastable() and v34 and v100) or ((4303 - (832 + 303)) < (3099 - (88 + 858)))) then
			if (v24(v92.Bloodthirst, not v100) or ((1517 + 3459) < (1103 + 229))) then
				return "bloodthirst precombat 10";
			end
		end
		if (((191 + 4437) == (5417 - (766 + 23))) and v35 and v92.Charge:IsReady() and not v100) then
			if (v24(v92.Charge, not v15:IsSpellInRange(v92.Charge)) or ((266 - 212) == (539 - 144))) then
				return "charge precombat 12";
			end
		end
	end
	local function v105()
		local v118 = 0 - 0;
		local v119;
		while true do
			if (((278 - 196) == (1155 - (1036 + 37))) and ((1 + 0) == v118)) then
				if ((v119 >= (185 - 90)) or (not v92.ColdSteelHotBlood:IsAvailable() and v14:HasTier(24 + 6, 1484 - (641 + 839))) or ((1494 - (910 + 3)) < (718 - 436))) then
					if ((v92.Bloodbath:IsCastable() and v33) or ((6293 - (1466 + 218)) < (1147 + 1348))) then
						if (((2300 - (556 + 592)) == (410 + 742)) and v24(v92.Bloodbath, not v100)) then
							return "bloodbath single_target 10";
						end
					end
					if (((2704 - (329 + 479)) <= (4276 - (174 + 680))) and v92.Bloodthirst:IsCastable() and v34) then
						if (v24(v92.Bloodthirst, not v100) or ((3401 - 2411) > (3357 - 1737))) then
							return "bloodthirst single_target 12";
						end
					end
				end
				if ((v92.Bloodbath:IsCastable() and v33 and v14:HasTier(23 + 8, 741 - (396 + 343))) or ((78 + 799) > (6172 - (29 + 1448)))) then
					if (((4080 - (135 + 1254)) >= (6972 - 5121)) and v24(v92.Bloodbath, not v100)) then
						return "bloodbath single_target 14";
					end
				end
				if ((v47 and ((v57 and v30) or not v57) and (v90 < v97) and v92.ThunderousRoar:IsCastable() and v14:BuffUp(v92.EnrageBuff)) or ((13937 - 10952) >= (3237 + 1619))) then
					if (((5803 - (389 + 1138)) >= (1769 - (102 + 472))) and v24(v92.ThunderousRoar, not v15:IsInMeleeRange(8 + 0))) then
						return "thunderous_roar single_target 16";
					end
				end
				if (((1793 + 1439) <= (4374 + 316)) and v92.Onslaught:IsReady() and v40 and (v14:BuffUp(v92.EnrageBuff) or v92.Tenderize:IsAvailable())) then
					if (v24(v92.Onslaught, not v100) or ((2441 - (320 + 1225)) >= (5600 - 2454))) then
						return "onslaught single_target 18";
					end
				end
				if (((1873 + 1188) >= (4422 - (157 + 1307))) and v92.CrushingBlow:IsCastable() and v36 and v92.WrathandFury:IsAvailable() and v14:BuffUp(v92.EnrageBuff) and v14:BuffDown(v92.FuriousBloodthirstBuff)) then
					if (((5046 - (821 + 1038)) >= (1606 - 962)) and v24(v92.CrushingBlow, not v100)) then
						return "crushing_blow single_target 20";
					end
				end
				v118 = 1 + 1;
			end
			if (((1143 - 499) <= (262 + 442)) and (v118 == (4 - 2))) then
				if (((1984 - (834 + 192)) > (61 + 886)) and v92.Execute:IsReady() and v37 and ((v14:BuffUp(v92.EnrageBuff) and v14:BuffDown(v92.FuriousBloodthirstBuff) and v14:BuffUp(v92.AshenJuggernautBuff)) or ((v14:BuffRemains(v92.SuddenDeathBuff) <= v14:GCD()) and (((v15:HealthPercentage() > (9 + 26)) and v92.Massacre:IsAvailable()) or (v15:HealthPercentage() > (1 + 19)))))) then
					if (((6958 - 2466) >= (2958 - (300 + 4))) and v24(v92.Execute, not v100)) then
						return "execute single_target 22";
					end
				end
				if (((920 + 2522) >= (3934 - 2431)) and v92.Rampage:IsReady() and v42 and v92.RecklessAbandon:IsAvailable() and (v14:BuffUp(v92.RecklessnessBuff) or (v14:BuffRemains(v92.EnrageBuff) < v14:GCD()) or (v14:RagePercentage() > (447 - (112 + 250))))) then
					if (v24(v92.Rampage, not v100) or ((1264 + 1906) <= (3667 - 2203))) then
						return "rampage single_target 24";
					end
				end
				if ((v92.Execute:IsReady() and v37 and v14:BuffUp(v92.EnrageBuff)) or ((2749 + 2048) == (2270 + 2118))) then
					if (((413 + 138) <= (338 + 343)) and v24(v92.Execute, not v100)) then
						return "execute single_target 26";
					end
				end
				if (((2435 + 842) > (1821 - (1001 + 413))) and v92.Rampage:IsReady() and v42 and v92.AngerManagement:IsAvailable()) then
					if (((10469 - 5774) >= (2297 - (244 + 638))) and v24(v92.Rampage, not v100)) then
						return "rampage single_target 28";
					end
				end
				if ((v92.Execute:IsReady() and v37) or ((3905 - (627 + 66)) <= (2812 - 1868))) then
					if (v24(v92.Execute, not v100) or ((3698 - (512 + 90)) <= (3704 - (1665 + 241)))) then
						return "execute single_target 29";
					end
				end
				v118 = 720 - (373 + 344);
			end
			if (((1596 + 1941) == (936 + 2601)) and ((13 - 8) == v118)) then
				if (((6493 - 2656) >= (2669 - (35 + 1064))) and v92.Slam:IsReady() and v45 and (v92.Annihilator:IsAvailable())) then
					if (v24(v92.Slam, not v100) or ((2147 + 803) == (8155 - 4343))) then
						return "slam single_target 48";
					end
				end
				if (((19 + 4704) >= (3554 - (298 + 938))) and v92.Bloodbath:IsCastable() and v33) then
					if (v24(v92.Bloodbath, not v100) or ((3286 - (233 + 1026)) > (4518 - (636 + 1030)))) then
						return "bloodbath single_target 50";
					end
				end
				if ((v92.RagingBlow:IsCastable() and v41) or ((581 + 555) > (4217 + 100))) then
					if (((1411 + 3337) == (321 + 4427)) and v24(v92.RagingBlow, not v100)) then
						return "raging_blow single_target 52";
					end
				end
				if (((3957 - (55 + 166)) <= (919 + 3821)) and v92.CrushingBlow:IsCastable() and v36 and v14:BuffDown(v92.FuriousBloodthirstBuff)) then
					if (v24(v92.CrushingBlow, not v100) or ((341 + 3049) <= (11686 - 8626))) then
						return "crushing_blow single_target 54";
					end
				end
				if ((v92.Bloodthirst:IsCastable() and v34) or ((1296 - (36 + 261)) > (4708 - 2015))) then
					if (((1831 - (34 + 1334)) < (232 + 369)) and v24(v92.Bloodthirst, not v100)) then
						return "bloodthirst single_target 56";
					end
				end
				v118 = 5 + 1;
			end
			if ((v118 == (1287 - (1035 + 248))) or ((2204 - (20 + 1)) < (358 + 329))) then
				if (((4868 - (134 + 185)) == (5682 - (549 + 584))) and v92.Bloodbath:IsCastable() and v33 and (not v14:BuffUp(v92.EnrageBuff) or not v92.WrathandFury:IsAvailable())) then
					if (((5357 - (314 + 371)) == (16038 - 11366)) and v24(v92.Bloodbath, not v100)) then
						return "bloodbath single_target 40";
					end
				end
				if ((v92.CrushingBlow:IsCastable() and v36 and v14:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and v14:BuffDown(v92.FuriousBloodthirstBuff)) or ((4636 - (478 + 490)) < (210 + 185))) then
					if (v24(v92.CrushingBlow, not v100) or ((5338 - (786 + 386)) == (1473 - 1018))) then
						return "crushing_blow single_target 42";
					end
				end
				if ((v92.Bloodthirst:IsCastable() and v34 and not v92.WrathandFury:IsAvailable() and v14:BuffDown(v92.FuriousBloodthirstBuff)) or ((5828 - (1055 + 324)) == (4003 - (1093 + 247)))) then
					if (v24(v92.Bloodthirst, not v100) or ((3801 + 476) < (315 + 2674))) then
						return "bloodthirst single_target 44";
					end
				end
				if ((v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (3 - 2))) or ((2952 - 2082) >= (11805 - 7656))) then
					if (((5558 - 3346) < (1133 + 2050)) and v24(v92.RagingBlow, not v100)) then
						return "raging_blow single_target 46";
					end
				end
				if (((17898 - 13252) > (10312 - 7320)) and v92.Rampage:IsReady() and v42) then
					if (((1082 + 352) < (7943 - 4837)) and v24(v92.Rampage, not v100)) then
						return "rampage single_target 47";
					end
				end
				v118 = 693 - (364 + 324);
			end
			if (((2154 - 1368) < (7253 - 4230)) and (v118 == (2 + 4))) then
				if ((v29 and v92.Whirlwind:IsCastable() and v48) or ((10218 - 7776) < (117 - 43))) then
					if (((13773 - 9238) == (5803 - (1249 + 19))) and v24(v92.Whirlwind, not v15:IsInMeleeRange(8 + 0))) then
						return "whirlwind single_target 58";
					end
				end
				break;
			end
			if (((0 - 0) == v118) or ((4095 - (686 + 400)) <= (1652 + 453))) then
				if (((2059 - (73 + 156)) < (18 + 3651)) and v92.Whirlwind:IsCastable() and v48 and (v99 > (812 - (721 + 90))) and v92.ImprovedWhilwind:IsAvailable() and v14:BuffDown(v92.MeatCleaverBuff)) then
					if (v24(v92.Whirlwind, not v15:IsInMeleeRange(1 + 7)) or ((4643 - 3213) >= (4082 - (224 + 246)))) then
						return "whirlwind single_target 2";
					end
				end
				if (((4346 - 1663) >= (4529 - 2069)) and v92.Execute:IsReady() and v37 and v14:BuffUp(v92.AshenJuggernautBuff) and (v14:BuffRemains(v92.AshenJuggernautBuff) < v14:GCD())) then
					if (v24(v92.Execute, not v100) or ((328 + 1476) >= (78 + 3197))) then
						return "execute single_target 4";
					end
				end
				if ((v39 and ((v53 and v30) or not v53) and v92.OdynsFury:IsCastable() and (v90 < v97) and v14:BuffUp(v92.EnrageBuff) and ((v92.DancingBlades:IsAvailable() and (v14:BuffRemains(v92.DancingBladesBuff) < (4 + 1))) or not v92.DancingBlades:IsAvailable())) or ((2816 - 1399) > (12076 - 8447))) then
					if (((5308 - (203 + 310)) > (2395 - (1238 + 755))) and v24(v92.OdynsFury, not v15:IsInMeleeRange(1 + 7))) then
						return "odyns_fury single_target 6";
					end
				end
				if (((6347 - (709 + 825)) > (6569 - 3004)) and v92.Rampage:IsReady() and v42 and v92.AngerManagement:IsAvailable() and (v14:BuffUp(v92.RecklessnessBuff) or (v14:BuffRemains(v92.EnrageBuff) < v14:GCD()) or (v14:RagePercentage() > (123 - 38)))) then
					if (((4776 - (196 + 668)) == (15445 - 11533)) and v24(v92.Rampage, not v100)) then
						return "rampage single_target 8";
					end
				end
				v119 = v14:CritChancePct() + (v25(v14:BuffUp(v92.RecklessnessBuff)) * (41 - 21)) + (v14:BuffStack(v92.MercilessAssaultBuff) * (843 - (171 + 662))) + (v14:BuffStack(v92.BloodcrazeBuff) * (108 - (4 + 89)));
				v118 = 3 - 2;
			end
			if (((1028 + 1793) <= (21188 - 16364)) and (v118 == (2 + 1))) then
				if (((3224 - (35 + 1451)) <= (3648 - (28 + 1425))) and v92.Bloodbath:IsCastable() and v33 and v14:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and not v92.WrathandFury:IsAvailable()) then
					if (((2034 - (941 + 1052)) <= (2894 + 124)) and v24(v92.Bloodbath, not v100)) then
						return "bloodbath single_target 30";
					end
				end
				if (((3659 - (822 + 692)) <= (5858 - 1754)) and v92.Rampage:IsReady() and v42 and (v15:HealthPercentage() < (17 + 18)) and v92.Massacre:IsAvailable()) then
					if (((2986 - (45 + 252)) < (4794 + 51)) and v24(v92.Rampage, not v100)) then
						return "rampage single_target 32";
					end
				end
				if ((v92.Bloodthirst:IsCastable() and v34 and (not v14:BuffUp(v92.EnrageBuff) or (v92.Annihilator:IsAvailable() and v14:BuffDown(v92.RecklessnessBuff))) and v14:BuffDown(v92.FuriousBloodthirstBuff)) or ((800 + 1522) > (6380 - 3758))) then
					if (v24(v92.Bloodthirst, not v100) or ((4967 - (114 + 319)) == (2988 - 906))) then
						return "bloodthirst single_target 34";
					end
				end
				if ((v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (1 - 0)) and v92.WrathandFury:IsAvailable()) or ((1002 + 569) > (2780 - 913))) then
					if (v24(v92.RagingBlow, not v100) or ((5560 - 2906) >= (4959 - (556 + 1407)))) then
						return "raging_blow single_target 36";
					end
				end
				if (((5184 - (741 + 465)) > (2569 - (170 + 295))) and v92.CrushingBlow:IsCastable() and v36 and (v92.CrushingBlow:Charges() > (1 + 0)) and v92.WrathandFury:IsAvailable() and v14:BuffDown(v92.FuriousBloodthirstBuff)) then
					if (((2751 + 244) > (3793 - 2252)) and v24(v92.CrushingBlow, not v100)) then
						return "crushing_blow single_target 38";
					end
				end
				v118 = 4 + 0;
			end
		end
	end
	local function v106()
		local v120 = 0 + 0;
		local v121;
		while true do
			if (((1840 + 1409) > (2183 - (957 + 273))) and (v120 == (2 + 4))) then
				if ((v92.Bloodbath:IsCastable() and v33) or ((1311 + 1962) > (17425 - 12852))) then
					if (v24(v92.Bloodbath, not v100) or ((8303 - 5152) < (3921 - 2637))) then
						return "bloodbath multi_target 46";
					end
				end
				if ((v92.RagingBlow:IsCastable() and v41) or ((9160 - 7310) == (3309 - (389 + 1391)))) then
					if (((516 + 305) < (221 + 1902)) and v24(v92.RagingBlow, not v100)) then
						return "raging_blow multi_target 48";
					end
				end
				if (((2053 - 1151) < (3276 - (783 + 168))) and v92.CrushingBlow:IsCastable() and v36) then
					if (((2879 - 2021) <= (2914 + 48)) and v24(v92.CrushingBlow, not v100)) then
						return "crushing_blow multi_target 50";
					end
				end
				if ((v92.Whirlwind:IsCastable() and v48) or ((4257 - (309 + 2)) < (3955 - 2667))) then
					if (v24(v92.Whirlwind, not v15:IsInMeleeRange(1220 - (1090 + 122))) or ((1052 + 2190) == (1904 - 1337))) then
						return "whirlwind multi_target 52";
					end
				end
				break;
			end
			if ((v120 == (3 + 0)) or ((1965 - (628 + 490)) >= (227 + 1036))) then
				if ((v92.Execute:IsReady() and v37) or ((5578 - 3325) == (8459 - 6608))) then
					if (v24(v92.Execute, not v100) or ((2861 - (431 + 343)) > (4790 - 2418))) then
						return "execute multi_target 22";
					end
				end
				if ((v92.Bloodbath:IsCastable() and v33 and v14:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and not v92.WrathandFury:IsAvailable()) or ((12859 - 8414) < (3278 + 871))) then
					if (v24(v92.Bloodbath, not v100) or ((233 + 1585) == (1780 - (556 + 1139)))) then
						return "bloodbath multi_target 24";
					end
				end
				if (((645 - (6 + 9)) < (390 + 1737)) and v92.Bloodthirst:IsCastable() and v34 and (not v14:BuffUp(v92.EnrageBuff) or (v92.Annihilator:IsAvailable() and v14:BuffDown(v92.RecklessnessBuff)))) then
					if (v24(v92.Bloodthirst, not v100) or ((993 + 945) == (2683 - (28 + 141)))) then
						return "bloodthirst multi_target 26";
					end
				end
				if (((1649 + 2606) >= (67 - 12)) and v92.Onslaught:IsReady() and v40 and ((not v92.Annihilator:IsAvailable() and v14:BuffUp(v92.EnrageBuff)) or v92.Tenderize:IsAvailable())) then
					if (((2125 + 874) > (2473 - (486 + 831))) and v24(v92.Onslaught, not v100)) then
						return "onslaught multi_target 28";
					end
				end
				v120 = 10 - 6;
			end
			if (((8273 - 5923) > (219 + 936)) and (v120 == (12 - 8))) then
				if (((5292 - (668 + 595)) <= (4367 + 486)) and v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (1 + 0)) and v92.WrathandFury:IsAvailable()) then
					if (v24(v92.RagingBlow, not v100) or ((1407 - 891) > (3724 - (23 + 267)))) then
						return "raging_blow multi_target 30";
					end
				end
				if (((5990 - (1129 + 815)) >= (3420 - (371 + 16))) and v92.CrushingBlow:IsCastable() and v36 and (v92.CrushingBlow:Charges() > (1751 - (1326 + 424))) and v92.WrathandFury:IsAvailable()) then
					if (v24(v92.CrushingBlow, not v100) or ((5149 - 2430) <= (5287 - 3840))) then
						return "crushing_blow multi_target 32";
					end
				end
				if ((v92.Bloodbath:IsCastable() and v33 and (not v14:BuffUp(v92.EnrageBuff) or not v92.WrathandFury:IsAvailable())) or ((4252 - (88 + 30)) < (4697 - (720 + 51)))) then
					if (v24(v92.Bloodbath, not v100) or ((364 - 200) >= (4561 - (421 + 1355)))) then
						return "bloodbath multi_target 34";
					end
				end
				if ((v92.CrushingBlow:IsCastable() and v36 and v14:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable()) or ((866 - 341) == (1036 + 1073))) then
					if (((1116 - (286 + 797)) == (120 - 87)) and v24(v92.CrushingBlow, not v100)) then
						return "crushing_blow multi_target 36";
					end
				end
				v120 = 7 - 2;
			end
			if (((3493 - (397 + 42)) <= (1254 + 2761)) and (v120 == (801 - (24 + 776)))) then
				if (((2882 - 1011) < (4167 - (222 + 563))) and v92.ThunderousRoar:IsCastable() and ((v57 and v30) or not v57) and v47 and (v90 < v97) and v14:BuffUp(v92.EnrageBuff)) then
					if (((2848 - 1555) <= (1560 + 606)) and v24(v92.ThunderousRoar, not v15:IsInMeleeRange(198 - (23 + 167)))) then
						return "thunderous_roar multi_target 10";
					end
				end
				if ((v92.OdynsFury:IsCastable() and ((v53 and v30) or not v53) and v39 and (v90 < v97) and (v99 > (1799 - (690 + 1108))) and v14:BuffUp(v92.EnrageBuff)) or ((931 + 1648) < (102 + 21))) then
					if (v24(v92.OdynsFury, not v15:IsInMeleeRange(856 - (40 + 808))) or ((140 + 706) >= (9055 - 6687))) then
						return "odyns_fury multi_target 12";
					end
				end
				v121 = v14:CritChancePct() + (v25(v14:BuffUp(v92.RecklessnessBuff)) * (20 + 0)) + (v14:BuffStack(v92.MercilessAssaultBuff) * (6 + 4)) + (v14:BuffStack(v92.BloodcrazeBuff) * (9 + 6));
				if (((v121 >= (666 - (47 + 524))) and v14:HasTier(20 + 10, 10 - 6)) or ((5998 - 1986) <= (7658 - 4300))) then
					local v175 = 1726 - (1165 + 561);
					while true do
						if (((45 + 1449) <= (9307 - 6302)) and (v175 == (0 + 0))) then
							if ((v92.Bloodbath:IsCastable() and v33) or ((3590 - (341 + 138)) == (577 + 1557))) then
								if (((4860 - 2505) == (2681 - (89 + 237))) and v24(v92.Bloodbath, not v100)) then
									return "bloodbath multi_target 14";
								end
							end
							if ((v92.Bloodthirst:IsCastable() and v34) or ((1891 - 1303) <= (909 - 477))) then
								if (((5678 - (581 + 300)) >= (5115 - (855 + 365))) and v24(v92.Bloodthirst, not v100)) then
									return "bloodthirst multi_target 16";
								end
							end
							break;
						end
					end
				end
				v120 = 4 - 2;
			end
			if (((1168 + 2409) == (4812 - (1030 + 205))) and (v120 == (5 + 0))) then
				if (((3530 + 264) > (3979 - (156 + 130))) and v92.Bloodthirst:IsCastable() and v34 and not v92.WrathandFury:IsAvailable()) then
					if (v24(v92.Bloodthirst, not v100) or ((2897 - 1622) == (6910 - 2810))) then
						return "bloodthirst multi_target 38";
					end
				end
				if ((v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (1 - 0))) or ((420 + 1171) >= (2088 + 1492))) then
					if (((1052 - (10 + 59)) <= (512 + 1296)) and v24(v92.RagingBlow, not v100)) then
						return "raging_blow multi_target 40";
					end
				end
				if ((v92.Rampage:IsReady() and v42) or ((10588 - 8438) <= (2360 - (671 + 492)))) then
					if (((3001 + 768) >= (2388 - (369 + 846))) and v24(v92.Rampage, not v100)) then
						return "rampage multi_target 42";
					end
				end
				if (((394 + 1091) == (1268 + 217)) and v92.Slam:IsReady() and v45 and (v92.Annihilator:IsAvailable())) then
					if (v24(v92.Slam, not v100) or ((5260 - (1036 + 909)) <= (2212 + 570))) then
						return "slam multi_target 44";
					end
				end
				v120 = 9 - 3;
			end
			if ((v120 == (205 - (11 + 192))) or ((443 + 433) >= (3139 - (135 + 40)))) then
				if ((v92.CrushingBlow:IsCastable() and v92.WrathandFury:IsAvailable() and v36 and v14:BuffUp(v92.EnrageBuff)) or ((5407 - 3175) > (1506 + 991))) then
					if (v24(v92.CrushingBlow, not v100) or ((4648 - 2538) <= (496 - 164))) then
						return "crushing_blow multi_target 14";
					end
				end
				if (((3862 - (50 + 126)) > (8832 - 5660)) and v92.Execute:IsReady() and v37 and v14:BuffUp(v92.EnrageBuff)) then
					if (v24(v92.Execute, not v100) or ((991 + 3483) < (2233 - (1233 + 180)))) then
						return "execute multi_target 16";
					end
				end
				if (((5248 - (522 + 447)) >= (4303 - (107 + 1314))) and v92.OdynsFury:IsCastable() and ((v53 and v30) or not v53) and v39 and (v90 < v97) and v14:BuffUp(v92.EnrageBuff)) then
					if (v24(v92.OdynsFury, not v15:IsInMeleeRange(4 + 4)) or ((6182 - 4153) >= (1496 + 2025))) then
						return "odyns_fury multi_target 18";
					end
				end
				if ((v92.Rampage:IsReady() and v42 and (v14:BuffUp(v92.RecklessnessBuff) or (v14:BuffRemains(v92.EnrageBuff) < v14:GCD()) or ((v14:Rage() > (218 - 108)) and v92.OverwhelmingRage:IsAvailable()) or ((v14:Rage() > (316 - 236)) and not v92.OverwhelmingRage:IsAvailable()))) or ((3947 - (716 + 1194)) >= (80 + 4562))) then
					if (((185 + 1535) < (4961 - (74 + 429))) and v24(v92.Rampage, not v100)) then
						return "rampage multi_target 20";
					end
				end
				v120 = 5 - 2;
			end
			if ((v120 == (0 + 0)) or ((997 - 561) > (2138 + 883))) then
				if (((2197 - 1484) <= (2093 - 1246)) and v92.Recklessness:IsCastable() and ((v55 and v30) or not v55) and v44 and (v90 < v97) and ((v99 > (434 - (279 + 154))) or (v97 < (790 - (454 + 324))))) then
					if (((1695 + 459) <= (4048 - (12 + 5))) and v24(v92.Recklessness, not v100)) then
						return "recklessness multi_target 2";
					end
				end
				if (((2489 + 2126) == (11758 - 7143)) and v92.OdynsFury:IsCastable() and ((v53 and v30) or not v53) and v39 and (v90 < v97) and (v99 > (1 + 0)) and v92.TitanicRage:IsAvailable() and (v14:BuffDown(v92.MeatCleaverBuff) or v14:BuffUp(v92.AvatarBuff) or v14:BuffUp(v92.RecklessnessBuff))) then
					if (v24(v92.OdynsFury, not v15:IsInMeleeRange(1101 - (277 + 816))) or ((16195 - 12405) == (1683 - (1058 + 125)))) then
						return "odyns_fury multi_target 4";
					end
				end
				if (((17 + 72) < (1196 - (815 + 160))) and v92.Whirlwind:IsCastable() and v48 and (v99 > (4 - 3)) and v92.ImprovedWhilwind:IsAvailable() and v14:BuffDown(v92.MeatCleaverBuff)) then
					if (((4875 - 2821) >= (339 + 1082)) and v24(v92.Whirlwind, not v15:IsInMeleeRange(23 - 15))) then
						return "whirlwind multi_target 6";
					end
				end
				if (((2590 - (41 + 1857)) < (4951 - (1222 + 671))) and v92.Execute:IsReady() and v37 and v14:BuffUp(v92.AshenJuggernautBuff) and (v14:BuffRemains(v92.AshenJuggernautBuff) < v14:GCD())) then
					if (v24(v92.Execute, not v100) or ((8410 - 5156) == (2378 - 723))) then
						return "execute multi_target 8";
					end
				end
				v120 = 1183 - (229 + 953);
			end
		end
	end
	local function v107()
		local v122 = 1774 - (1111 + 663);
		while true do
			if ((v122 == (1579 - (874 + 705))) or ((182 + 1114) == (3350 + 1560))) then
				v27 = v102();
				if (((7000 - 3632) == (95 + 3273)) and v27) then
					return v27;
				end
				v122 = 680 - (642 + 37);
			end
			if (((603 + 2040) < (611 + 3204)) and (v122 == (2 - 1))) then
				if (((2367 - (233 + 221)) > (1139 - 646)) and v85) then
					local v176 = 0 + 0;
					while true do
						if (((6296 - (718 + 823)) > (2158 + 1270)) and (v176 == (805 - (266 + 539)))) then
							v27 = v91.HandleIncorporeal(v92.StormBolt, v94.StormBoltMouseover, 56 - 36, true);
							if (((2606 - (636 + 589)) <= (5622 - 3253)) and v27) then
								return v27;
							end
							v176 = 1 - 0;
						end
						if ((v176 == (1 + 0)) or ((1760 + 3083) == (5099 - (657 + 358)))) then
							v27 = v91.HandleIncorporeal(v92.IntimidatingShout, v94.IntimidatingShoutMouseover, 21 - 13, true);
							if (((10637 - 5968) > (1550 - (1151 + 36))) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				if (v91.TargetIsValid() or ((1813 + 64) >= (825 + 2313))) then
					local v177 = 0 - 0;
					local v178;
					while true do
						if (((6574 - (1552 + 280)) >= (4460 - (64 + 770))) and (v177 == (3 + 0))) then
							v27 = v105();
							if (v27 or ((10306 - 5766) == (163 + 753))) then
								return v27;
							end
							if (v20.CastAnnotated(v92.Pool, false, "WAIT") or ((2399 - (157 + 1086)) > (8697 - 4352))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((9797 - 7560) < (6517 - 2268)) and (v177 == (0 - 0))) then
							if ((v35 and v92.Charge:IsCastable()) or ((3502 - (599 + 220)) < (45 - 22))) then
								if (((2628 - (1813 + 118)) <= (604 + 222)) and v24(v92.Charge, not v15:IsSpellInRange(v92.Charge))) then
									return "charge main 2";
								end
							end
							v178 = v91.HandleDPSPotion(v15:BuffUp(v92.RecklessnessBuff));
							if (((2322 - (841 + 376)) <= (1647 - 471)) and v178) then
								return v178;
							end
							v177 = 1 + 0;
						end
						if (((9222 - 5843) <= (4671 - (464 + 395))) and (v177 == (5 - 3))) then
							if ((v38 and v92.HeroicThrow:IsCastable() and not v15:IsInRange(15 + 15)) or ((1625 - (467 + 370)) >= (3338 - 1722))) then
								if (((1361 + 493) <= (11583 - 8204)) and v24(v92.HeroicThrow, not v15:IsInRange(5 + 25))) then
									return "heroic_throw main";
								end
							end
							if (((10583 - 6034) == (5069 - (150 + 370))) and v92.WreckingThrow:IsCastable() and v49 and v15:AffectingCombat() and v101()) then
								if (v24(v92.WreckingThrow, not v15:IsInRange(1312 - (74 + 1208))) or ((7432 - 4410) >= (14341 - 11317))) then
									return "wrecking_throw main";
								end
							end
							if (((3430 + 1390) > (2588 - (14 + 376))) and v29 and (v99 > (3 - 1))) then
								local v182 = 0 + 0;
								while true do
									if ((v182 == (0 + 0)) or ((1012 + 49) >= (14331 - 9440))) then
										v27 = v106();
										if (((1027 + 337) <= (4551 - (23 + 55))) and v27) then
											return v27;
										end
										break;
									end
								end
							end
							v177 = 6 - 3;
						end
						if ((v177 == (1 + 0)) or ((3229 + 366) <= (4 - 1))) then
							if ((v90 < v97) or ((1470 + 3202) == (4753 - (652 + 249)))) then
								if (((4171 - 2612) == (3427 - (708 + 1160))) and v51 and ((v30 and v59) or not v59)) then
									v27 = v103();
									if (v27 or ((4755 - 3003) <= (1436 - 648))) then
										return v27;
									end
								end
							end
							if (((v90 < v97) and v50 and ((v58 and v30) or not v58)) or ((3934 - (10 + 17)) == (40 + 137))) then
								local v183 = 1732 - (1400 + 332);
								while true do
									if (((6655 - 3185) > (2463 - (242 + 1666))) and (v183 == (1 + 1))) then
										if (v92.AncestralCall:IsCastable() or ((357 + 615) == (550 + 95))) then
											if (((4122 - (850 + 90)) >= (3703 - 1588)) and v24(v92.AncestralCall, not v100)) then
												return "ancestral_call main 20";
											end
										end
										if (((5283 - (360 + 1030)) < (3920 + 509)) and v92.BagofTricks:IsCastable() and v14:BuffDown(v92.RecklessnessBuff) and v14:BuffUp(v92.EnrageBuff)) then
											if (v24(v92.BagofTricks, not v15:IsSpellInRange(v92.BagofTricks)) or ((8092 - 5225) < (2620 - 715))) then
												return "bag_of_tricks main 22";
											end
										end
										break;
									end
									if ((v183 == (1662 - (909 + 752))) or ((3019 - (109 + 1114)) >= (7416 - 3365))) then
										if (((631 + 988) <= (3998 - (6 + 236))) and v92.LightsJudgment:IsCastable() and v14:BuffDown(v92.RecklessnessBuff)) then
											if (((381 + 223) == (487 + 117)) and v24(v92.LightsJudgment, not v15:IsSpellInRange(v92.LightsJudgment))) then
												return "lights_judgment main 16";
											end
										end
										if (v92.Fireblood:IsCastable() or ((10574 - 6090) == (1572 - 672))) then
											if (v24(v92.Fireblood, not v100) or ((5592 - (1076 + 57)) <= (184 + 929))) then
												return "fireblood main 18";
											end
										end
										v183 = 691 - (579 + 110);
									end
									if (((287 + 3345) > (3005 + 393)) and (v183 == (0 + 0))) then
										if (((4489 - (174 + 233)) <= (13734 - 8817)) and v92.BloodFury:IsCastable()) then
											if (((8480 - 3648) >= (617 + 769)) and v24(v92.BloodFury, not v100)) then
												return "blood_fury main 12";
											end
										end
										if (((1311 - (663 + 511)) == (123 + 14)) and v92.Berserking:IsCastable() and v14:BuffUp(v92.RecklessnessBuff)) then
											if (v24(v92.Berserking, not v100) or ((341 + 1229) >= (13355 - 9023))) then
												return "berserking main 14";
											end
										end
										v183 = 1 + 0;
									end
								end
							end
							if ((v90 < v97) or ((9567 - 5503) <= (4403 - 2584))) then
								local v184 = 0 + 0;
								while true do
									if ((v184 == (1 - 0)) or ((3554 + 1432) < (144 + 1430))) then
										if (((5148 - (478 + 244)) > (689 - (440 + 77))) and v92.Recklessness:IsCastable() and v44 and ((v55 and v30) or not v55) and (not v92.Annihilator:IsAvailable() or (v10.FightRemains() < (6 + 6)))) then
											if (((2144 - 1558) > (2011 - (655 + 901))) and v24(v92.Recklessness, not v100)) then
												return "recklessness main 27";
											end
										end
										if (((154 + 672) == (633 + 193)) and v92.Ravager:IsCastable() and (v83 == "player") and v43 and ((v54 and v30) or not v54) and ((v92.Avatar:CooldownRemains() < (3 + 0)) or v14:BuffUp(v92.RecklessnessBuff) or (v97 < (40 - 30)))) then
											if (v24(v94.RavagerPlayer, not v100) or ((5464 - (695 + 750)) > (15164 - 10723))) then
												return "ravager main 28";
											end
										end
										v184 = 2 - 0;
									end
									if (((8111 - 6094) < (4612 - (285 + 66))) and (v184 == (4 - 2))) then
										if (((6026 - (682 + 628)) > (13 + 67)) and v92.Ravager:IsCastable() and (v83 == "cursor") and v43 and ((v54 and v30) or not v54) and ((v92.Avatar:CooldownRemains() < (302 - (176 + 123))) or v14:BuffUp(v92.RecklessnessBuff) or (v97 < (5 + 5)))) then
											if (v24(v94.RavagerCursor, not v100) or ((2544 + 963) == (3541 - (239 + 30)))) then
												return "ravager main 28";
											end
										end
										if ((v92.SpearofBastion:IsCastable() and (v84 == "player") and v46 and ((v56 and v30) or not v56) and v14:BuffUp(v92.EnrageBuff) and (v14:BuffUp(v92.RecklessnessBuff) or v14:BuffUp(v92.AvatarBuff) or (v97 < (6 + 14)) or (v99 > (1 + 0)) or not v92.TitansTorment:IsAvailable() or not v14:HasTier(54 - 23, 5 - 3))) or ((1191 - (306 + 9)) >= (10730 - 7655))) then
											if (((757 + 3595) > (1568 + 986)) and v24(v94.SpearOfBastionPlayer, not v100)) then
												return "spear_of_bastion main 30";
											end
										end
										v184 = 2 + 1;
									end
									if ((v184 == (8 - 5)) or ((5781 - (1140 + 235)) < (2573 + 1470))) then
										if ((v92.SpearofBastion:IsCastable() and (v84 == "cursor") and v46 and ((v56 and v30) or not v56) and v14:BuffUp(v92.EnrageBuff) and (v14:BuffUp(v92.RecklessnessBuff) or v14:BuffUp(v92.AvatarBuff) or (v97 < (19 + 1)) or (v99 > (1 + 0)) or not v92.TitansTorment:IsAvailable() or not v14:HasTier(83 - (33 + 19), 1 + 1))) or ((5661 - 3772) >= (1491 + 1892))) then
											if (((3710 - 1818) <= (2564 + 170)) and v24(v94.SpearOfBastionCursor, not v100)) then
												return "spear_of_bastion main 31";
											end
										end
										break;
									end
									if (((2612 - (586 + 103)) < (202 + 2016)) and (v184 == (0 - 0))) then
										if (((3661 - (1309 + 179)) > (683 - 304)) and v92.Avatar:IsCastable() and v31 and ((v52 and v30) or not v52) and ((v92.TitansTorment:IsAvailable() and v14:BuffUp(v92.EnrageBuff) and v14:BuffDown(v92.AvatarBuff) and (v92.OdynsFury:CooldownRemains() > (0 + 0))) or (v92.BerserkersTorment:IsAvailable() and v14:BuffUp(v92.EnrageBuff) and v14:BuffDown(v92.AvatarBuff)) or (not v92.TitansTorment:IsAvailable() and not v92.BerserkersTorment:IsAvailable() and (v14:BuffUp(v92.RecklessnessBuff) or (v97 < (53 - 33)))))) then
											if (v24(v92.Avatar, not v100) or ((1958 + 633) == (7242 - 3833))) then
												return "avatar main 24";
											end
										end
										if (((8994 - 4480) > (3933 - (295 + 314))) and v92.Recklessness:IsCastable() and v44 and ((v55 and v30) or not v55) and ((v92.Annihilator:IsAvailable() and (v92.Avatar:CooldownRemains() < (2 - 1))) or (v92.Avatar:CooldownRemains() > (2002 - (1300 + 662))) or not v92.Avatar:IsAvailable() or (v97 < (37 - 25)))) then
											if (v24(v92.Recklessness, not v100) or ((1963 - (1178 + 577)) >= (2508 + 2320))) then
												return "recklessness main 26";
											end
										end
										v184 = 2 - 1;
									end
								end
							end
							v177 = 1407 - (851 + 554);
						end
					end
				end
				break;
			end
		end
	end
	local function v108()
		if (not v14:AffectingCombat() or ((1400 + 183) > (9892 - 6325))) then
			if ((v92.BerserkerStance:IsCastable() and v14:BuffDown(v92.BerserkerStance, true)) or ((2851 - 1538) == (1096 - (115 + 187)))) then
				if (((2431 + 743) > (2748 + 154)) and v24(v92.BerserkerStance)) then
					return "berserker_stance";
				end
			end
			if (((16235 - 12115) <= (5421 - (160 + 1001))) and v92.BattleShout:IsCastable() and v32 and (v14:BuffDown(v92.BattleShoutBuff, true) or v91.GroupBuffMissing(v92.BattleShoutBuff))) then
				if (v24(v92.BattleShout) or ((773 + 110) > (3297 + 1481))) then
					return "battle_shout precombat";
				end
			end
		end
		if ((v91.TargetIsValid() and v28) or ((7410 - 3790) >= (5249 - (237 + 121)))) then
			if (((5155 - (525 + 372)) > (1776 - 839)) and not v14:AffectingCombat()) then
				v27 = v104();
				if (v27 or ((15997 - 11128) < (1048 - (96 + 46)))) then
					return v27;
				end
			end
		end
	end
	local function v109()
		local v123 = 777 - (643 + 134);
		while true do
			if ((v123 == (3 + 3)) or ((2937 - 1712) > (15697 - 11469))) then
				v47 = EpicSettings.Settings['useThunderousRoar'];
				v52 = EpicSettings.Settings['avatarWithCD'];
				v53 = EpicSettings.Settings['odynFuryWithCD'];
				v123 = 7 + 0;
			end
			if (((6530 - 3202) > (4574 - 2336)) and (v123 == (723 - (316 + 403)))) then
				v49 = EpicSettings.Settings['useWreckingThrow'];
				v31 = EpicSettings.Settings['useAvatar'];
				v39 = EpicSettings.Settings['useOdynsFury'];
				v123 = 4 + 1;
			end
			if (((10554 - 6715) > (508 + 897)) and (v123 == (7 - 4))) then
				v42 = EpicSettings.Settings['useRampage'];
				v45 = EpicSettings.Settings['useSlam'];
				v48 = EpicSettings.Settings['useWhirlwind'];
				v123 = 3 + 1;
			end
			if (((0 + 0) == v123) or ((4480 - 3187) <= (2421 - 1914))) then
				v32 = EpicSettings.Settings['useBattleShout'];
				v33 = EpicSettings.Settings['useBloodbath'];
				v34 = EpicSettings.Settings['useBloodthirst'];
				v123 = 1 - 0;
			end
			if ((v123 == (1 + 4)) or ((5700 - 2804) < (40 + 765))) then
				v43 = EpicSettings.Settings['useRavager'];
				v44 = EpicSettings.Settings['useRecklessness'];
				v46 = EpicSettings.Settings['useSpearOfBastion'];
				v123 = 17 - 11;
			end
			if (((2333 - (12 + 5)) == (8995 - 6679)) and (v123 == (14 - 7))) then
				v54 = EpicSettings.Settings['ravagerWithCD'];
				v55 = EpicSettings.Settings['recklessnessWithCD'];
				v56 = EpicSettings.Settings['spearOfBastionWithCD'];
				v123 = 16 - 8;
			end
			if ((v123 == (19 - 11)) or ((522 + 2048) == (3506 - (1656 + 317)))) then
				v57 = EpicSettings.Settings['thunderousRoarWithCD'];
				break;
			end
			if ((v123 == (1 + 0)) or ((708 + 175) == (3882 - 2422))) then
				v35 = EpicSettings.Settings['useCharge'];
				v36 = EpicSettings.Settings['useCrushingBlow'];
				v37 = EpicSettings.Settings['useExecute'];
				v123 = 9 - 7;
			end
			if ((v123 == (356 - (5 + 349))) or ((21939 - 17320) <= (2270 - (266 + 1005)))) then
				v38 = EpicSettings.Settings['useHeroicThrow'];
				v40 = EpicSettings.Settings['useOnslaught'];
				v41 = EpicSettings.Settings['useRagingBlow'];
				v123 = 2 + 1;
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
		v72 = EpicSettings.Settings['bitterImmunityHP'] or (0 - 0);
		v73 = EpicSettings.Settings['enragedRegenerationHP'] or (0 - 0);
		v74 = EpicSettings.Settings['ignorePainHP'] or (1696 - (561 + 1135));
		v75 = EpicSettings.Settings['rallyingCryHP'] or (0 - 0);
		v76 = EpicSettings.Settings['rallyingCryGroup'] or (0 - 0);
		v77 = EpicSettings.Settings['interveneHP'] or (1066 - (507 + 559));
		v78 = EpicSettings.Settings['defensiveStanceHP'] or (0 - 0);
		v81 = EpicSettings.Settings['unstanceHP'] or (0 - 0);
		v82 = EpicSettings.Settings['victoryRushHP'] or (388 - (212 + 176));
		v83 = EpicSettings.Settings['ravagerSetting'] or "player";
		v84 = EpicSettings.Settings['spearSetting'] or "player";
	end
	local function v111()
		local v134 = 905 - (250 + 655);
		while true do
			if ((v134 == (0 - 0)) or ((5958 - 2548) > (6439 - 2323))) then
				v90 = EpicSettings.Settings['fightRemainsCheck'] or (1956 - (1869 + 87));
				v87 = EpicSettings.Settings['InterruptWithStun'];
				v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v89 = EpicSettings.Settings['InterruptThreshold'];
				v134 = 3 - 2;
			end
			if ((v134 == (1902 - (484 + 1417))) or ((1935 - 1032) >= (5126 - 2067))) then
				v51 = EpicSettings.Settings['useTrinkets'];
				v50 = EpicSettings.Settings['useRacials'];
				v59 = EpicSettings.Settings['trinketsWithCD'];
				v58 = EpicSettings.Settings['racialsWithCD'];
				v134 = 775 - (48 + 725);
			end
			if ((v134 == (4 - 1)) or ((10666 - 6690) < (1661 + 1196))) then
				v86 = EpicSettings.Settings['HealingPotionName'] or "";
				v85 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((13175 - 8245) > (646 + 1661)) and (v134 == (1 + 1))) then
				v69 = EpicSettings.Settings['useHealthstone'];
				v70 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (853 - (152 + 701));
				v80 = EpicSettings.Settings['healingPotionHP'] or (1311 - (430 + 881));
				v134 = 2 + 1;
			end
		end
	end
	local function v112()
		local v135 = 895 - (557 + 338);
		while true do
			if ((v135 == (0 + 0)) or ((11401 - 7355) < (4520 - 3229))) then
				v110();
				v109();
				v111();
				v135 = 2 - 1;
			end
			if ((v135 == (4 - 2)) or ((5042 - (499 + 302)) == (4411 - (39 + 827)))) then
				if (v14:IsDeadOrGhost() or ((11174 - 7126) > (9451 - 5219))) then
					return v27;
				end
				if (v29 or ((6950 - 5200) >= (5331 - 1858))) then
					v98 = v14:GetEnemiesInMeleeRange(1 + 7);
					v99 = #v98;
				else
					v99 = 2 - 1;
				end
				v100 = v15:IsInMeleeRange(1 + 4);
				v135 = 4 - 1;
			end
			if (((3270 - (103 + 1)) == (3720 - (475 + 79))) and ((6 - 3) == v135)) then
				if (((5641 - 3878) < (482 + 3242)) and (v91.TargetIsValid() or v14:AffectingCombat())) then
					local v179 = 0 + 0;
					while true do
						if (((1560 - (1395 + 108)) <= (7923 - 5200)) and (v179 == (1204 - (7 + 1197)))) then
							v96 = v10.BossFightRemains(nil, true);
							v97 = v96;
							v179 = 1 + 0;
						end
						if ((v179 == (1 + 0)) or ((2389 - (27 + 292)) == (1297 - 854))) then
							if ((v97 == (14169 - 3058)) or ((11344 - 8639) == (2746 - 1353))) then
								v97 = v10.FightRemains(v98, false);
							end
							break;
						end
					end
				end
				if (not v14:IsChanneling() or ((8762 - 4161) < (200 - (43 + 96)))) then
					if (v14:AffectingCombat() or ((5669 - 4279) >= (10725 - 5981))) then
						local v180 = 0 + 0;
						while true do
							if ((v180 == (0 + 0)) or ((3958 - 1955) > (1470 + 2364))) then
								v27 = v107();
								if (v27 or ((292 - 136) > (1232 + 2681))) then
									return v27;
								end
								break;
							end
						end
					else
						local v181 = 0 + 0;
						while true do
							if (((1946 - (1414 + 337)) == (2135 - (1642 + 298))) and (v181 == (0 - 0))) then
								v27 = v108();
								if (((8932 - 5827) >= (5329 - 3533)) and v27) then
									return v27;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((1442 + 2937) >= (1659 + 472)) and ((973 - (357 + 615)) == v135)) then
				v28 = EpicSettings.Toggles['ooc'];
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				v135 = 2 + 0;
			end
		end
	end
	local function v113()
		v20.Print("Fury Warrior by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(176 - 104, v112, v113);
end;
return v0["Epix_Warrior_Fury.lua"]();

