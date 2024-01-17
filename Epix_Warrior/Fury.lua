local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((4202 - 3003) == (3458 - 2259)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((1965 - 1329) == (3150 - (111 + 1137)))) then
				return v1(v4, ...);
			end
			v5 = 159 - (91 + 67);
		end
		if ((v5 == (2 - 1)) or ((1208 + 3631) <= (3803 - (423 + 100)))) then
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
	local v96 = 78 + 11033;
	local v97 = 30764 - 19653;
	v10:RegisterForEvent(function()
		local v114 = 0 + 0;
		while true do
			if ((v114 == (771 - (326 + 445))) or ((16033 - 12359) <= (4370 - 2408))) then
				v96 = 25935 - 14824;
				v97 = 11822 - (530 + 181);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v98, v99;
	local v100;
	local function v101()
		local v115 = 881 - (614 + 267);
		local v116;
		while true do
			if ((v115 == (32 - (19 + 13))) or ((3082 - 1188) < (3275 - 1869))) then
				v116 = UnitGetTotalAbsorbs(v15);
				if (((4490 - 2918) >= (398 + 1133)) and (v116 > (0 - 0))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v102()
		local v117 = 0 - 0;
		while true do
			if ((v117 == (1814 - (1293 + 519))) or ((9562 - 4875) < (11858 - 7316))) then
				if (((6293 - 3002) > (7188 - 5521)) and v92.Intervene:IsCastable() and v67 and (v17:HealthPercentage() <= v77) and (v17:UnitName() ~= v14:UnitName())) then
					if (v24(v94.InterveneFocus) or ((2056 - 1183) == (1078 + 956))) then
						return "intervene defensive";
					end
				end
				if ((v92.DefensiveStance:IsCastable() and v68 and (v14:HealthPercentage() <= v78) and v14:BuffDown(v92.DefensiveStance, true)) or ((575 + 2241) < (25 - 14))) then
					if (((855 + 2844) < (1564 + 3142)) and v24(v92.DefensiveStance)) then
						return "defensive_stance defensive";
					end
				end
				v117 = 2 + 1;
			end
			if (((3742 - (709 + 387)) >= (2734 - (673 + 1185))) and (v117 == (2 - 1))) then
				if (((1971 - 1357) <= (5238 - 2054)) and v92.IgnorePain:IsCastable() and v65 and (v14:HealthPercentage() <= v74)) then
					if (((2236 + 890) == (2336 + 790)) and v24(v92.IgnorePain, nil, nil, true)) then
						return "ignore_pain defensive";
					end
				end
				if ((v92.RallyingCry:IsCastable() and v66 and v14:BuffDown(v92.AspectsFavorBuff) and v14:BuffDown(v92.RallyingCry) and (((v14:HealthPercentage() <= v75) and v91.IsSoloMode()) or v91.AreUnitsBelowHealthPercentage(v75, v76))) or ((2952 - 765) >= (1217 + 3737))) then
					if (v24(v92.RallyingCry) or ((7729 - 3852) == (7017 - 3442))) then
						return "rallying_cry defensive";
					end
				end
				v117 = 1882 - (446 + 1434);
			end
			if (((1990 - (1040 + 243)) > (1886 - 1254)) and ((1850 - (559 + 1288)) == v117)) then
				if ((v92.BerserkerStance:IsCastable() and v68 and (v14:HealthPercentage() > v81) and v14:BuffDown(v92.BerserkerStance, true)) or ((2477 - (609 + 1322)) >= (3138 - (13 + 441)))) then
					if (((5474 - 4009) <= (11265 - 6964)) and v24(v92.BerserkerStance)) then
						return "berserker_stance after defensive stance defensive";
					end
				end
				if (((8486 - 6782) > (54 + 1371)) and v93.Healthstone:IsReady() and v69 and (v14:HealthPercentage() <= v79)) then
					if (v24(v94.Healthstone) or ((2494 - 1807) == (1504 + 2730))) then
						return "healthstone defensive 3";
					end
				end
				v117 = 2 + 2;
			end
			if ((v117 == (0 - 0)) or ((1823 + 1507) < (2627 - 1198))) then
				if (((759 + 388) >= (187 + 148)) and v92.BitterImmunity:IsReady() and v63 and (v14:HealthPercentage() <= v72)) then
					if (((2469 + 966) > (1761 + 336)) and v24(v92.BitterImmunity)) then
						return "bitter_immunity defensive";
					end
				end
				if ((v92.EnragedRegeneration:IsCastable() and v64 and (v14:HealthPercentage() <= v73)) or ((3689 + 81) >= (4474 - (153 + 280)))) then
					if (v24(v92.EnragedRegeneration) or ((10946 - 7155) <= (1447 + 164))) then
						return "enraged_regeneration defensive";
					end
				end
				v117 = 1 + 0;
			end
			if ((v117 == (3 + 1)) or ((4155 + 423) <= (1456 + 552))) then
				if (((1713 - 588) <= (1284 + 792)) and v70 and (v14:HealthPercentage() <= v80)) then
					if ((v86 == "Refreshing Healing Potion") or ((1410 - (89 + 578)) >= (3143 + 1256))) then
						if (((2400 - 1245) < (2722 - (572 + 477))) and v93.RefreshingHealingPotion:IsReady()) then
							if (v24(v94.RefreshingHealingPotion) or ((314 + 2010) <= (347 + 231))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((450 + 3317) == (3853 - (84 + 2))) and (v86 == "Dreamwalker's Healing Potion")) then
						if (((6738 - 2649) == (2946 + 1143)) and v93.DreamwalkersHealingPotion:IsReady()) then
							if (((5300 - (497 + 345)) >= (43 + 1631)) and v24(v94.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v103()
		local v118 = 0 + 0;
		while true do
			if (((2305 - (605 + 728)) <= (1012 + 406)) and (v118 == (0 - 0))) then
				v27 = v91.HandleTopTrinket(v95, v30, 2 + 38, nil);
				if (v27 or ((18256 - 13318) < (4293 + 469))) then
					return v27;
				end
				v118 = 2 - 1;
			end
			if ((v118 == (1 + 0)) or ((2993 - (457 + 32)) > (1810 + 2454))) then
				v27 = v91.HandleBottomTrinket(v95, v30, 1442 - (832 + 570), nil);
				if (((2029 + 124) == (562 + 1591)) and v27) then
					return v27;
				end
				break;
			end
		end
	end
	local function v104()
		local v119 = 0 - 0;
		while true do
			if (((1 + 0) == v119) or ((1303 - (588 + 208)) >= (6983 - 4392))) then
				if (((6281 - (884 + 916)) == (9381 - 4900)) and v92.Bloodthirst:IsCastable() and v34 and v100) then
					if (v24(v92.Bloodthirst, not v100) or ((1350 + 978) < (1346 - (232 + 421)))) then
						return "bloodthirst precombat 10";
					end
				end
				if (((6217 - (1569 + 320)) == (1062 + 3266)) and v35 and v92.Charge:IsReady() and not v100) then
					if (((302 + 1286) >= (4488 - 3156)) and v24(v92.Charge, not v15:IsSpellInRange(v92.Charge))) then
						return "charge precombat 12";
					end
				end
				break;
			end
			if ((v119 == (605 - (316 + 289))) or ((10925 - 6751) > (197 + 4051))) then
				if ((v31 and ((v52 and v30) or not v52) and (v90 < v97) and v92.Avatar:IsCastable() and not v92.TitansTorment:IsAvailable()) or ((6039 - (666 + 787)) <= (507 - (360 + 65)))) then
					if (((3611 + 252) == (4117 - (79 + 175))) and v24(v92.Avatar, not v100)) then
						return "avatar precombat 6";
					end
				end
				if ((v44 and ((v55 and v30) or not v55) and (v90 < v97) and v92.Recklessness:IsCastable() and not v92.RecklessAbandon:IsAvailable()) or ((444 - 162) <= (33 + 9))) then
					if (((14127 - 9518) >= (1474 - 708)) and v24(v92.Recklessness, not v100)) then
						return "recklessness precombat 8";
					end
				end
				v119 = 900 - (503 + 396);
			end
		end
	end
	local function v105()
		local v120 = 181 - (92 + 89);
		local v121;
		while true do
			if ((v120 == (3 - 1)) or ((591 + 561) == (1473 + 1015))) then
				if (((13400 - 9978) > (459 + 2891)) and v92.Execute:IsReady() and v37 and v14:BuffUp(v92.EnrageBuff)) then
					if (((1999 - 1122) > (329 + 47)) and v24(v92.Execute, not v100)) then
						return "execute single_target 26";
					end
				end
				if ((v92.Rampage:IsReady() and v42 and v92.AngerManagement:IsAvailable()) or ((1490 + 1628) <= (5637 - 3786))) then
					if (v24(v92.Rampage, not v100) or ((21 + 144) >= (5324 - 1832))) then
						return "rampage single_target 28";
					end
				end
				if (((5193 - (485 + 759)) < (11236 - 6380)) and v92.Execute:IsReady() and v37) then
					if (v24(v92.Execute, not v100) or ((5465 - (442 + 747)) < (4151 - (832 + 303)))) then
						return "execute single_target 29";
					end
				end
				if (((5636 - (88 + 858)) > (1258 + 2867)) and v92.Bloodbath:IsCastable() and v33 and v14:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and not v92.WrathandFury:IsAvailable()) then
					if (v24(v92.Bloodbath, not v100) or ((42 + 8) >= (37 + 859))) then
						return "bloodbath single_target 30";
					end
				end
				if ((v92.Rampage:IsReady() and v42 and (v15:HealthPercentage() < (824 - (766 + 23))) and v92.Massacre:IsAvailable()) or ((8461 - 6747) >= (4045 - 1087))) then
					if (v24(v92.Rampage, not v100) or ((3928 - 2437) < (2185 - 1541))) then
						return "rampage single_target 32";
					end
				end
				if (((1777 - (1036 + 37)) < (700 + 287)) and v92.Bloodthirst:IsCastable() and v34 and (not v14:BuffUp(v92.EnrageBuff) or (v92.Annihilator:IsAvailable() and v14:BuffDown(v92.RecklessnessBuff))) and v14:BuffDown(v92.FuriousBloodthirstBuff)) then
					if (((7240 - 3522) > (1500 + 406)) and v24(v92.Bloodthirst, not v100)) then
						return "bloodthirst single_target 34";
					end
				end
				v120 = 1483 - (641 + 839);
			end
			if ((v120 == (916 - (910 + 3))) or ((2442 - 1484) > (5319 - (1466 + 218)))) then
				if (((1610 + 1891) <= (5640 - (556 + 592))) and v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (1 + 0)) and v92.WrathandFury:IsAvailable()) then
					if (v24(v92.RagingBlow, not v100) or ((4250 - (329 + 479)) < (3402 - (174 + 680)))) then
						return "raging_blow single_target 36";
					end
				end
				if (((9879 - 7004) >= (3034 - 1570)) and v92.CrushingBlow:IsCastable() and v36 and (v92.CrushingBlow:Charges() > (1 + 0)) and v92.WrathandFury:IsAvailable() and v14:BuffDown(v92.FuriousBloodthirstBuff)) then
					if (v24(v92.CrushingBlow, not v100) or ((5536 - (396 + 343)) >= (433 + 4460))) then
						return "crushing_blow single_target 38";
					end
				end
				if ((v92.Bloodbath:IsCastable() and v33 and (not v14:BuffUp(v92.EnrageBuff) or not v92.WrathandFury:IsAvailable())) or ((2028 - (29 + 1448)) > (3457 - (135 + 1254)))) then
					if (((7963 - 5849) > (4407 - 3463)) and v24(v92.Bloodbath, not v100)) then
						return "bloodbath single_target 40";
					end
				end
				if ((v92.CrushingBlow:IsCastable() and v36 and v14:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and v14:BuffDown(v92.FuriousBloodthirstBuff)) or ((1508 + 754) >= (4623 - (389 + 1138)))) then
					if (v24(v92.CrushingBlow, not v100) or ((2829 - (102 + 472)) >= (3338 + 199))) then
						return "crushing_blow single_target 42";
					end
				end
				if ((v92.Bloodthirst:IsCastable() and v34 and not v92.WrathandFury:IsAvailable() and v14:BuffDown(v92.FuriousBloodthirstBuff)) or ((2128 + 1709) < (1218 + 88))) then
					if (((4495 - (320 + 1225)) == (5251 - 2301)) and v24(v92.Bloodthirst, not v100)) then
						return "bloodthirst single_target 44";
					end
				end
				if ((v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (1 + 0))) or ((6187 - (157 + 1307)) < (5157 - (821 + 1038)))) then
					if (((2834 - 1698) >= (17 + 137)) and v24(v92.RagingBlow, not v100)) then
						return "raging_blow single_target 46";
					end
				end
				v120 = 6 - 2;
			end
			if ((v120 == (0 + 0)) or ((671 - 400) > (5774 - (834 + 192)))) then
				if (((302 + 4438) >= (810 + 2342)) and v92.Whirlwind:IsCastable() and v48 and (v99 > (1 + 0)) and v92.ImprovedWhilwind:IsAvailable() and v14:BuffDown(v92.MeatCleaverBuff)) then
					if (v24(v92.Whirlwind, not v15:IsInMeleeRange(12 - 4)) or ((2882 - (300 + 4)) >= (906 + 2484))) then
						return "whirlwind single_target 2";
					end
				end
				if (((107 - 66) <= (2023 - (112 + 250))) and v92.Execute:IsReady() and v37 and v14:BuffUp(v92.AshenJuggernautBuff) and (v14:BuffRemains(v92.AshenJuggernautBuff) < v14:GCD())) then
					if (((240 + 361) < (8918 - 5358)) and v24(v92.Execute, not v100)) then
						return "execute single_target 4";
					end
				end
				if (((135 + 100) < (356 + 331)) and v39 and ((v53 and v30) or not v53) and v92.OdynsFury:IsCastable() and (v90 < v97) and v14:BuffUp(v92.EnrageBuff) and ((v92.DancingBlades:IsAvailable() and (v14:BuffRemains(v92.DancingBladesBuff) < (4 + 1))) or not v92.DancingBlades:IsAvailable())) then
					if (((2256 + 2293) > (857 + 296)) and v24(v92.OdynsFury, not v15:IsInMeleeRange(1422 - (1001 + 413)))) then
						return "odyns_fury single_target 6";
					end
				end
				if ((v92.Rampage:IsReady() and v42 and v92.AngerManagement:IsAvailable() and (v14:BuffUp(v92.RecklessnessBuff) or (v14:BuffRemains(v92.EnrageBuff) < v14:GCD()) or (v14:RagePercentage() > (189 - 104)))) or ((5556 - (244 + 638)) < (5365 - (627 + 66)))) then
					if (((10929 - 7261) < (5163 - (512 + 90))) and v24(v92.Rampage, not v100)) then
						return "rampage single_target 8";
					end
				end
				v121 = v14:CritChancePct() + (v25(v14:BuffUp(v92.RecklessnessBuff)) * (1926 - (1665 + 241))) + (v14:BuffStack(v92.MercilessAssaultBuff) * (727 - (373 + 344))) + (v14:BuffStack(v92.BloodcrazeBuff) * (7 + 8));
				if ((v121 >= (26 + 69)) or (not v92.ColdSteelHotBlood:IsAvailable() and v14:HasTier(79 - 49, 6 - 2)) or ((1554 - (35 + 1064)) == (2623 + 982))) then
					local v178 = 0 - 0;
					while true do
						if ((v178 == (0 + 0)) or ((3899 - (298 + 938)) == (4571 - (233 + 1026)))) then
							if (((5943 - (636 + 1030)) <= (2288 + 2187)) and v92.Bloodbath:IsCastable() and v33) then
								if (v24(v92.Bloodbath, not v100) or ((850 + 20) == (354 + 835))) then
									return "bloodbath single_target 10";
								end
							end
							if (((105 + 1448) <= (3354 - (55 + 166))) and v92.Bloodthirst:IsCastable() and v34) then
								if (v24(v92.Bloodthirst, not v100) or ((434 + 1803) >= (354 + 3157))) then
									return "bloodthirst single_target 12";
								end
							end
							break;
						end
					end
				end
				v120 = 3 - 2;
			end
			if ((v120 == (298 - (36 + 261))) or ((2315 - 991) > (4388 - (34 + 1334)))) then
				if ((v92.Bloodbath:IsCastable() and v33 and v14:HasTier(12 + 19, 2 + 0)) or ((4275 - (1035 + 248)) == (1902 - (20 + 1)))) then
					if (((1619 + 1487) > (1845 - (134 + 185))) and v24(v92.Bloodbath, not v100)) then
						return "bloodbath single_target 14";
					end
				end
				if (((4156 - (549 + 584)) < (4555 - (314 + 371))) and v47 and ((v57 and v30) or not v57) and (v90 < v97) and v92.ThunderousRoar:IsCastable() and v14:BuffUp(v92.EnrageBuff)) then
					if (((490 - 347) > (1042 - (478 + 490))) and v24(v92.ThunderousRoar, not v15:IsInMeleeRange(5 + 3))) then
						return "thunderous_roar single_target 16";
					end
				end
				if (((1190 - (786 + 386)) < (6840 - 4728)) and v92.Onslaught:IsReady() and v40 and (v14:BuffUp(v92.EnrageBuff) or v92.Tenderize:IsAvailable())) then
					if (((2476 - (1055 + 324)) <= (2968 - (1093 + 247))) and v24(v92.Onslaught, not v100)) then
						return "onslaught single_target 18";
					end
				end
				if (((4115 + 515) == (487 + 4143)) and v92.CrushingBlow:IsCastable() and v36 and v92.WrathandFury:IsAvailable() and v14:BuffUp(v92.EnrageBuff) and v14:BuffDown(v92.FuriousBloodthirstBuff)) then
					if (((14054 - 10514) > (9105 - 6422)) and v24(v92.CrushingBlow, not v100)) then
						return "crushing_blow single_target 20";
					end
				end
				if (((13640 - 8846) >= (8229 - 4954)) and v92.Execute:IsReady() and v37 and ((v14:BuffUp(v92.EnrageBuff) and v14:BuffDown(v92.FuriousBloodthirstBuff) and v14:BuffUp(v92.AshenJuggernautBuff)) or ((v14:BuffRemains(v92.SuddenDeathBuff) <= v14:GCD()) and (((v15:HealthPercentage() > (13 + 22)) and v92.Massacre:IsAvailable()) or (v15:HealthPercentage() > (77 - 57)))))) then
					if (((5114 - 3630) == (1119 + 365)) and v24(v92.Execute, not v100)) then
						return "execute single_target 22";
					end
				end
				if (((3661 - 2229) < (4243 - (364 + 324))) and v92.Rampage:IsReady() and v42 and v92.RecklessAbandon:IsAvailable() and (v14:BuffUp(v92.RecklessnessBuff) or (v14:BuffRemains(v92.EnrageBuff) < v14:GCD()) or (v14:RagePercentage() > (232 - 147)))) then
					if (v24(v92.Rampage, not v100) or ((2555 - 1490) > (1186 + 2392))) then
						return "rampage single_target 24";
					end
				end
				v120 = 8 - 6;
			end
			if ((v120 == (5 - 1)) or ((14562 - 9767) < (2675 - (1249 + 19)))) then
				if (((1673 + 180) < (18734 - 13921)) and v92.Rampage:IsReady() and v42) then
					if (v24(v92.Rampage, not v100) or ((3907 - (686 + 400)) < (1908 + 523))) then
						return "rampage single_target 47";
					end
				end
				if ((v92.Slam:IsReady() and v45 and (v92.Annihilator:IsAvailable())) or ((3103 - (73 + 156)) < (11 + 2170))) then
					if (v24(v92.Slam, not v100) or ((3500 - (721 + 90)) <= (4 + 339))) then
						return "slam single_target 48";
					end
				end
				if ((v92.Bloodbath:IsCastable() and v33) or ((6068 - 4199) == (2479 - (224 + 246)))) then
					if (v24(v92.Bloodbath, not v100) or ((5744 - 2198) < (4275 - 1953))) then
						return "bloodbath single_target 50";
					end
				end
				if ((v92.RagingBlow:IsCastable() and v41) or ((378 + 1704) == (114 + 4659))) then
					if (((2383 + 861) > (2097 - 1042)) and v24(v92.RagingBlow, not v100)) then
						return "raging_blow single_target 52";
					end
				end
				if ((v92.CrushingBlow:IsCastable() and v36 and v14:BuffDown(v92.FuriousBloodthirstBuff)) or ((11024 - 7711) <= (2291 - (203 + 310)))) then
					if (v24(v92.CrushingBlow, not v100) or ((3414 - (1238 + 755)) >= (147 + 1957))) then
						return "crushing_blow single_target 54";
					end
				end
				if (((3346 - (709 + 825)) <= (5986 - 2737)) and v92.Bloodthirst:IsCastable() and v34) then
					if (((2363 - 740) <= (2821 - (196 + 668))) and v24(v92.Bloodthirst, not v100)) then
						return "bloodthirst single_target 56";
					end
				end
				v120 = 19 - 14;
			end
			if (((9138 - 4726) == (5245 - (171 + 662))) and (v120 == (98 - (4 + 89)))) then
				if (((6133 - 4383) >= (307 + 535)) and v29 and v92.Whirlwind:IsCastable() and v48) then
					if (((19202 - 14830) > (726 + 1124)) and v24(v92.Whirlwind, not v15:IsInMeleeRange(1494 - (35 + 1451)))) then
						return "whirlwind single_target 58";
					end
				end
				break;
			end
		end
	end
	local function v106()
		if (((1685 - (28 + 1425)) < (2814 - (941 + 1052))) and v92.Recklessness:IsCastable() and ((v55 and v30) or not v55) and v44 and (v90 < v97) and ((v99 > (1 + 0)) or (v97 < (1526 - (822 + 692))))) then
			if (((739 - 221) < (425 + 477)) and v24(v92.Recklessness, not v100)) then
				return "recklessness multi_target 2";
			end
		end
		if (((3291 - (45 + 252)) > (849 + 9)) and v92.OdynsFury:IsCastable() and ((v53 and v30) or not v53) and v39 and (v90 < v97) and (v99 > (1 + 0)) and v92.TitanicRage:IsAvailable() and (v14:BuffDown(v92.MeatCleaverBuff) or v14:BuffUp(v92.AvatarBuff) or v14:BuffUp(v92.RecklessnessBuff))) then
			if (v24(v92.OdynsFury, not v15:IsInMeleeRange(19 - 11)) or ((4188 - (114 + 319)) <= (1313 - 398))) then
				return "odyns_fury multi_target 4";
			end
		end
		if (((5056 - 1110) > (2387 + 1356)) and v92.Whirlwind:IsCastable() and v48 and (v99 > (1 - 0)) and v92.ImprovedWhilwind:IsAvailable() and v14:BuffDown(v92.MeatCleaverBuff)) then
			if (v24(v92.Whirlwind, not v15:IsInMeleeRange(16 - 8)) or ((3298 - (556 + 1407)) >= (4512 - (741 + 465)))) then
				return "whirlwind multi_target 6";
			end
		end
		if (((5309 - (170 + 295)) > (1188 + 1065)) and v92.Execute:IsReady() and v37 and v14:BuffUp(v92.AshenJuggernautBuff) and (v14:BuffRemains(v92.AshenJuggernautBuff) < v14:GCD())) then
			if (((416 + 36) == (1112 - 660)) and v24(v92.Execute, not v100)) then
				return "execute multi_target 8";
			end
		end
		if ((v92.ThunderousRoar:IsCastable() and ((v57 and v30) or not v57) and v47 and (v90 < v97) and v14:BuffUp(v92.EnrageBuff)) or ((3778 + 779) < (1339 + 748))) then
			if (((2194 + 1680) == (5104 - (957 + 273))) and v24(v92.ThunderousRoar, not v15:IsInMeleeRange(3 + 5))) then
				return "thunderous_roar multi_target 10";
			end
		end
		if ((v92.OdynsFury:IsCastable() and ((v53 and v30) or not v53) and v39 and (v90 < v97) and (v99 > (1 + 0)) and v14:BuffUp(v92.EnrageBuff)) or ((7384 - 5446) > (13004 - 8069))) then
			if (v24(v92.OdynsFury, not v15:IsInMeleeRange(24 - 16)) or ((21069 - 16814) < (5203 - (389 + 1391)))) then
				return "odyns_fury multi_target 12";
			end
		end
		local v122 = v14:CritChancePct() + (v25(v14:BuffUp(v92.RecklessnessBuff)) * (13 + 7)) + (v14:BuffStack(v92.MercilessAssaultBuff) * (2 + 8)) + (v14:BuffStack(v92.BloodcrazeBuff) * (34 - 19));
		if (((2405 - (783 + 168)) <= (8360 - 5869)) and (v122 >= (94 + 1)) and v14:HasTier(341 - (309 + 2), 12 - 8)) then
			local v139 = 1212 - (1090 + 122);
			while true do
				if ((v139 == (0 + 0)) or ((13961 - 9804) <= (1919 + 884))) then
					if (((5971 - (628 + 490)) >= (535 + 2447)) and v92.Bloodbath:IsCastable() and v33) then
						if (((10235 - 6101) > (15341 - 11984)) and v24(v92.Bloodbath, not v100)) then
							return "bloodbath multi_target 14";
						end
					end
					if ((v92.Bloodthirst:IsCastable() and v34) or ((4191 - (431 + 343)) < (5117 - 2583))) then
						if (v24(v92.Bloodthirst, not v100) or ((7874 - 5152) <= (130 + 34))) then
							return "bloodthirst multi_target 16";
						end
					end
					break;
				end
			end
		end
		if ((v92.CrushingBlow:IsCastable() and v92.WrathandFury:IsAvailable() and v36 and v14:BuffUp(v92.EnrageBuff)) or ((308 + 2100) < (3804 - (556 + 1139)))) then
			if (v24(v92.CrushingBlow, not v100) or ((48 - (6 + 9)) == (267 + 1188))) then
				return "crushing_blow multi_target 14";
			end
		end
		if ((v92.Execute:IsReady() and v37 and v14:BuffUp(v92.EnrageBuff)) or ((227 + 216) >= (4184 - (28 + 141)))) then
			if (((1310 + 2072) > (204 - 38)) and v24(v92.Execute, not v100)) then
				return "execute multi_target 16";
			end
		end
		if ((v92.OdynsFury:IsCastable() and ((v53 and v30) or not v53) and v39 and (v90 < v97) and v14:BuffUp(v92.EnrageBuff)) or ((199 + 81) == (4376 - (486 + 831)))) then
			if (((4894 - 3013) > (4551 - 3258)) and v24(v92.OdynsFury, not v15:IsInMeleeRange(2 + 6))) then
				return "odyns_fury multi_target 18";
			end
		end
		if (((7452 - 5095) == (3620 - (668 + 595))) and v92.Rampage:IsReady() and v42 and (v14:BuffUp(v92.RecklessnessBuff) or (v14:BuffRemains(v92.EnrageBuff) < v14:GCD()) or ((v14:Rage() > (99 + 11)) and v92.OverwhelmingRage:IsAvailable()) or ((v14:Rage() > (17 + 63)) and not v92.OverwhelmingRage:IsAvailable()))) then
			if (((335 - 212) == (413 - (23 + 267))) and v24(v92.Rampage, not v100)) then
				return "rampage multi_target 20";
			end
		end
		if ((v92.Execute:IsReady() and v37) or ((3000 - (1129 + 815)) >= (3779 - (371 + 16)))) then
			if (v24(v92.Execute, not v100) or ((2831 - (1326 + 424)) < (2035 - 960))) then
				return "execute multi_target 22";
			end
		end
		if ((v92.Bloodbath:IsCastable() and v33 and v14:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and not v92.WrathandFury:IsAvailable()) or ((3833 - 2784) >= (4550 - (88 + 30)))) then
			if (v24(v92.Bloodbath, not v100) or ((5539 - (720 + 51)) <= (1881 - 1035))) then
				return "bloodbath multi_target 24";
			end
		end
		if ((v92.Bloodthirst:IsCastable() and v34 and (not v14:BuffUp(v92.EnrageBuff) or (v92.Annihilator:IsAvailable() and v14:BuffDown(v92.RecklessnessBuff)))) or ((5134 - (421 + 1355)) <= (2342 - 922))) then
			if (v24(v92.Bloodthirst, not v100) or ((1837 + 1902) <= (4088 - (286 + 797)))) then
				return "bloodthirst multi_target 26";
			end
		end
		if ((v92.Onslaught:IsReady() and v40 and ((not v92.Annihilator:IsAvailable() and v14:BuffUp(v92.EnrageBuff)) or v92.Tenderize:IsAvailable())) or ((6064 - 4405) >= (3534 - 1400))) then
			if (v24(v92.Onslaught, not v100) or ((3699 - (397 + 42)) < (736 + 1619))) then
				return "onslaught multi_target 28";
			end
		end
		if ((v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (801 - (24 + 776))) and v92.WrathandFury:IsAvailable()) or ((1030 - 361) == (5008 - (222 + 563)))) then
			if (v24(v92.RagingBlow, not v100) or ((3727 - 2035) < (424 + 164))) then
				return "raging_blow multi_target 30";
			end
		end
		if ((v92.CrushingBlow:IsCastable() and v36 and (v92.CrushingBlow:Charges() > (191 - (23 + 167))) and v92.WrathandFury:IsAvailable()) or ((6595 - (690 + 1108)) < (1318 + 2333))) then
			if (v24(v92.CrushingBlow, not v100) or ((3446 + 731) > (5698 - (40 + 808)))) then
				return "crushing_blow multi_target 32";
			end
		end
		if ((v92.Bloodbath:IsCastable() and v33 and (not v14:BuffUp(v92.EnrageBuff) or not v92.WrathandFury:IsAvailable())) or ((66 + 334) > (4248 - 3137))) then
			if (((2917 + 134) > (532 + 473)) and v24(v92.Bloodbath, not v100)) then
				return "bloodbath multi_target 34";
			end
		end
		if (((2026 + 1667) <= (4953 - (47 + 524))) and v92.CrushingBlow:IsCastable() and v36 and v14:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable()) then
			if (v24(v92.CrushingBlow, not v100) or ((2130 + 1152) > (11207 - 7107))) then
				return "crushing_blow multi_target 36";
			end
		end
		if ((v92.Bloodthirst:IsCastable() and v34 and not v92.WrathandFury:IsAvailable()) or ((5353 - 1773) < (6485 - 3641))) then
			if (((1815 - (1165 + 561)) < (134 + 4356)) and v24(v92.Bloodthirst, not v100)) then
				return "bloodthirst multi_target 38";
			end
		end
		if ((v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (3 - 2))) or ((1902 + 3081) < (2287 - (341 + 138)))) then
			if (((1034 + 2795) > (7777 - 4008)) and v24(v92.RagingBlow, not v100)) then
				return "raging_blow multi_target 40";
			end
		end
		if (((1811 - (89 + 237)) <= (9341 - 6437)) and v92.Rampage:IsReady() and v42) then
			if (((8987 - 4718) == (5150 - (581 + 300))) and v24(v92.Rampage, not v100)) then
				return "rampage multi_target 42";
			end
		end
		if (((1607 - (855 + 365)) <= (6607 - 3825)) and v92.Slam:IsReady() and v45 and (v92.Annihilator:IsAvailable())) then
			if (v24(v92.Slam, not v100) or ((621 + 1278) <= (2152 - (1030 + 205)))) then
				return "slam multi_target 44";
			end
		end
		if ((v92.Bloodbath:IsCastable() and v33) or ((4049 + 263) <= (815 + 61))) then
			if (((2518 - (156 + 130)) <= (5898 - 3302)) and v24(v92.Bloodbath, not v100)) then
				return "bloodbath multi_target 46";
			end
		end
		if (((3530 - 1435) < (7549 - 3863)) and v92.RagingBlow:IsCastable() and v41) then
			if (v24(v92.RagingBlow, not v100) or ((421 + 1174) >= (2609 + 1865))) then
				return "raging_blow multi_target 48";
			end
		end
		if ((v92.CrushingBlow:IsCastable() and v36) or ((4688 - (10 + 59)) < (816 + 2066))) then
			if (v24(v92.CrushingBlow, not v100) or ((1447 - 1153) >= (5994 - (671 + 492)))) then
				return "crushing_blow multi_target 50";
			end
		end
		if (((1616 + 413) <= (4299 - (369 + 846))) and v92.Whirlwind:IsCastable() and v48) then
			if (v24(v92.Whirlwind, not v15:IsInMeleeRange(3 + 5)) or ((1739 + 298) == (4365 - (1036 + 909)))) then
				return "whirlwind multi_target 52";
			end
		end
	end
	local function v107()
		local v123 = 0 + 0;
		while true do
			if (((7484 - 3026) > (4107 - (11 + 192))) and (v123 == (0 + 0))) then
				v27 = v102();
				if (((611 - (135 + 40)) >= (297 - 174)) and v27) then
					return v27;
				end
				v123 = 1 + 0;
			end
			if (((1101 - 601) < (2721 - 905)) and (v123 == (177 - (50 + 126)))) then
				if (((9951 - 6377) == (792 + 2782)) and v85) then
					local v179 = 1413 - (1233 + 180);
					while true do
						if (((1190 - (522 + 447)) < (1811 - (107 + 1314))) and (v179 == (1 + 0))) then
							v27 = v91.HandleIncorporeal(v92.IntimidatingShout, v94.IntimidatingShoutMouseover, 24 - 16, true);
							if (v27 or ((940 + 1273) <= (2821 - 1400))) then
								return v27;
							end
							break;
						end
						if (((12099 - 9041) < (6770 - (716 + 1194))) and (v179 == (0 + 0))) then
							v27 = v91.HandleIncorporeal(v92.StormBolt, v94.StormBoltMouseover, 3 + 17, true);
							if (v27 or ((1799 - (74 + 429)) >= (8576 - 4130))) then
								return v27;
							end
							v179 = 1 + 0;
						end
					end
				end
				if (v91.TargetIsValid() or ((3188 - 1795) > (3176 + 1313))) then
					local v180 = 0 - 0;
					local v181;
					while true do
						if ((v180 == (4 - 2)) or ((4857 - (279 + 154)) < (805 - (454 + 324)))) then
							if ((v38 and v92.HeroicThrow:IsCastable() and not v15:IsInRange(24 + 6)) or ((2014 - (12 + 5)) > (2057 + 1758))) then
								if (((8828 - 5363) > (707 + 1206)) and v24(v92.HeroicThrow, not v15:IsInRange(1123 - (277 + 816)))) then
									return "heroic_throw main";
								end
							end
							if (((3131 - 2398) < (3002 - (1058 + 125))) and v92.WreckingThrow:IsCastable() and v49 and v15:AffectingCombat() and v101()) then
								if (v24(v92.WreckingThrow, not v15:IsInRange(6 + 24)) or ((5370 - (815 + 160)) == (20402 - 15647))) then
									return "wrecking_throw main";
								end
							end
							if ((v29 and (v99 > (4 - 2))) or ((905 + 2888) < (6924 - 4555))) then
								local v186 = 1898 - (41 + 1857);
								while true do
									if ((v186 == (1893 - (1222 + 671))) or ((10555 - 6471) == (380 - 115))) then
										v27 = v106();
										if (((5540 - (229 + 953)) == (6132 - (1111 + 663))) and v27) then
											return v27;
										end
										break;
									end
								end
							end
							v180 = 1582 - (874 + 705);
						end
						if ((v180 == (1 + 0)) or ((2141 + 997) < (2063 - 1070))) then
							if (((94 + 3236) > (3002 - (642 + 37))) and (v90 < v97)) then
								if ((v51 and ((v30 and v59) or not v59)) or ((827 + 2799) == (639 + 3350))) then
									v27 = v103();
									if (v27 or ((2299 - 1383) == (3125 - (233 + 221)))) then
										return v27;
									end
								end
							end
							if (((628 - 356) == (240 + 32)) and (v90 < v97) and v50 and ((v58 and v30) or not v58)) then
								local v187 = 1541 - (718 + 823);
								while true do
									if (((2674 + 1575) <= (5644 - (266 + 539))) and (v187 == (2 - 1))) then
										if (((4002 - (636 + 589)) < (7596 - 4396)) and v92.LightsJudgment:IsCastable() and v14:BuffDown(v92.RecklessnessBuff)) then
											if (((195 - 100) < (1551 + 406)) and v24(v92.LightsJudgment, not v15:IsSpellInRange(v92.LightsJudgment))) then
												return "lights_judgment main 16";
											end
										end
										if (((301 + 525) < (2732 - (657 + 358))) and v92.Fireblood:IsCastable()) then
											if (((3775 - 2349) >= (2517 - 1412)) and v24(v92.Fireblood, not v100)) then
												return "fireblood main 18";
											end
										end
										v187 = 1189 - (1151 + 36);
									end
									if (((2660 + 94) <= (889 + 2490)) and (v187 == (5 - 3))) then
										if (v92.AncestralCall:IsCastable() or ((5759 - (1552 + 280)) == (2247 - (64 + 770)))) then
											if (v24(v92.AncestralCall, not v100) or ((784 + 370) <= (1788 - 1000))) then
												return "ancestral_call main 20";
											end
										end
										if ((v92.BagofTricks:IsCastable() and v14:BuffDown(v92.RecklessnessBuff) and v14:BuffUp(v92.EnrageBuff)) or ((292 + 1351) > (4622 - (157 + 1086)))) then
											if (v24(v92.BagofTricks, not v15:IsSpellInRange(v92.BagofTricks)) or ((5610 - 2807) > (19923 - 15374))) then
												return "bag_of_tricks main 22";
											end
										end
										break;
									end
									if ((v187 == (0 - 0)) or ((300 - 80) >= (3841 - (599 + 220)))) then
										if (((5619 - 2797) == (4753 - (1813 + 118))) and v92.BloodFury:IsCastable()) then
											if (v24(v92.BloodFury, not v100) or ((776 + 285) == (3074 - (841 + 376)))) then
												return "blood_fury main 12";
											end
										end
										if (((3867 - 1107) > (317 + 1047)) and v92.Berserking:IsCastable() and v14:BuffUp(v92.RecklessnessBuff)) then
											if (v24(v92.Berserking, not v100) or ((13380 - 8478) <= (4454 - (464 + 395)))) then
												return "berserking main 14";
											end
										end
										v187 = 2 - 1;
									end
								end
							end
							if ((v90 < v97) or ((1850 + 2002) == (1130 - (467 + 370)))) then
								if ((v92.Avatar:IsCastable() and v31 and ((v52 and v30) or not v52) and ((v92.TitansTorment:IsAvailable() and v14:BuffUp(v92.EnrageBuff) and v14:BuffDown(v92.AvatarBuff) and (v92.OdynsFury:CooldownRemains() > (0 - 0))) or (v92.BerserkersTorment:IsAvailable() and v14:BuffUp(v92.EnrageBuff) and v14:BuffDown(v92.AvatarBuff)) or (not v92.TitansTorment:IsAvailable() and not v92.BerserkersTorment:IsAvailable() and (v14:BuffUp(v92.RecklessnessBuff) or (v97 < (15 + 5)))))) or ((5344 - 3785) == (716 + 3872))) then
									if (v24(v92.Avatar, not v100) or ((10431 - 5947) == (1308 - (150 + 370)))) then
										return "avatar main 24";
									end
								end
								if (((5850 - (74 + 1208)) >= (9609 - 5702)) and v92.Recklessness:IsCastable() and v44 and ((v55 and v30) or not v55) and ((v92.Annihilator:IsAvailable() and (v92.Avatar:CooldownRemains() < (4 - 3))) or (v92.Avatar:CooldownRemains() > (29 + 11)) or not v92.Avatar:IsAvailable() or (v97 < (402 - (14 + 376))))) then
									if (((2161 - 915) < (2246 + 1224)) and v24(v92.Recklessness, not v100)) then
										return "recklessness main 26";
									end
								end
								if (((3574 + 494) >= (928 + 44)) and v92.Recklessness:IsCastable() and v44 and ((v55 and v30) or not v55) and (not v92.Annihilator:IsAvailable() or (v10.FightRemains() < (35 - 23)))) then
									if (((371 + 122) < (3971 - (23 + 55))) and v24(v92.Recklessness, not v100)) then
										return "recklessness main 27";
									end
								end
								if ((v92.Ravager:IsCastable() and (v83 == "player") and v43 and ((v54 and v30) or not v54) and ((v92.Avatar:CooldownRemains() < (6 - 3)) or v14:BuffUp(v92.RecklessnessBuff) or (v97 < (7 + 3)))) or ((1323 + 150) >= (5165 - 1833))) then
									if (v24(v94.RavagerPlayer, not v100) or ((1275 + 2776) <= (2058 - (652 + 249)))) then
										return "ravager main 28";
									end
								end
								if (((1616 - 1012) < (4749 - (708 + 1160))) and v92.Ravager:IsCastable() and (v83 == "cursor") and v43 and ((v54 and v30) or not v54) and ((v92.Avatar:CooldownRemains() < (8 - 5)) or v14:BuffUp(v92.RecklessnessBuff) or (v97 < (18 - 8)))) then
									if (v24(v94.RavagerCursor, not v100) or ((927 - (10 + 17)) == (759 + 2618))) then
										return "ravager main 28";
									end
								end
								if (((6191 - (1400 + 332)) > (1133 - 542)) and v92.ChampionsSpear:IsCastable() and (v84 == "player") and v46 and ((v56 and v30) or not v56) and v14:BuffUp(v92.EnrageBuff) and (v14:BuffUp(v92.RecklessnessBuff) or v14:BuffUp(v92.AvatarBuff) or (v97 < (1928 - (242 + 1666))) or (v99 > (1 + 0)) or not v92.TitansTorment:IsAvailable() or not v14:HasTier(12 + 19, 2 + 0))) then
									if (((4338 - (850 + 90)) >= (4194 - 1799)) and v24(v94.ChampionsSpearPlayer, not v100)) then
										return "spear_of_bastion main 30";
									end
								end
								if ((v92.ChampionsSpear:IsCastable() and (v84 == "cursor") and v46 and ((v56 and v30) or not v56) and v14:BuffUp(v92.EnrageBuff) and (v14:BuffUp(v92.RecklessnessBuff) or v14:BuffUp(v92.AvatarBuff) or (v97 < (1410 - (360 + 1030))) or (v99 > (1 + 0)) or not v92.TitansTorment:IsAvailable() or not v14:HasTier(87 - 56, 2 - 0))) or ((3844 - (909 + 752)) >= (4047 - (109 + 1114)))) then
									if (((3544 - 1608) == (754 + 1182)) and v24(v94.ChampionsSpearCursor, not v100)) then
										return "spear_of_bastion main 31";
									end
								end
							end
							v180 = 244 - (6 + 236);
						end
						if ((v180 == (2 + 1)) or ((3890 + 942) < (10171 - 5858))) then
							v27 = v105();
							if (((7140 - 3052) > (5007 - (1076 + 57))) and v27) then
								return v27;
							end
							if (((713 + 3619) == (5021 - (579 + 110))) and v20.CastAnnotated(v92.Pool, false, "WAIT")) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((316 + 3683) >= (2564 + 336)) and (v180 == (0 + 0))) then
							if ((v35 and v92.Charge:IsCastable()) or ((2932 - (174 + 233)) > (11351 - 7287))) then
								if (((7671 - 3300) == (1944 + 2427)) and v24(v92.Charge, not v15:IsSpellInRange(v92.Charge))) then
									return "charge main 2";
								end
							end
							v181 = v91.HandleDPSPotion(v15:BuffUp(v92.RecklessnessBuff));
							if (v181 or ((1440 - (663 + 511)) > (4449 + 537))) then
								return v181;
							end
							v180 = 1 + 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v108()
		local v124 = 0 - 0;
		while true do
			if (((1206 + 785) >= (2177 - 1252)) and (v124 == (0 - 0))) then
				if (((218 + 237) < (3995 - 1942)) and not v14:AffectingCombat()) then
					local v182 = 0 + 0;
					while true do
						if ((v182 == (0 + 0)) or ((1548 - (478 + 244)) == (5368 - (440 + 77)))) then
							if (((84 + 99) == (669 - 486)) and v92.BerserkerStance:IsCastable() and v14:BuffDown(v92.BerserkerStance, true)) then
								if (((2715 - (655 + 901)) <= (332 + 1456)) and v24(v92.BerserkerStance)) then
									return "berserker_stance";
								end
							end
							if ((v92.BattleShout:IsCastable() and v32 and (v14:BuffDown(v92.BattleShoutBuff, true) or v91.GroupBuffMissing(v92.BattleShoutBuff))) or ((2685 + 822) > (2916 + 1402))) then
								if (v24(v92.BattleShout) or ((12388 - 9313) <= (4410 - (695 + 750)))) then
									return "battle_shout precombat";
								end
							end
							break;
						end
					end
				end
				if (((4660 - 3295) <= (3103 - 1092)) and v91.TargetIsValid() and v28) then
					if (not v14:AffectingCombat() or ((11164 - 8388) > (3926 - (285 + 66)))) then
						v27 = v104();
						if (v27 or ((5953 - 3399) == (6114 - (682 + 628)))) then
							return v27;
						end
					end
				end
				break;
			end
		end
	end
	local function v109()
		local v125 = 0 + 0;
		while true do
			if (((2876 - (176 + 123)) == (1078 + 1499)) and (v125 == (0 + 0))) then
				v32 = EpicSettings.Settings['useBattleShout'];
				v33 = EpicSettings.Settings['useBloodbath'];
				v34 = EpicSettings.Settings['useBloodthirst'];
				v35 = EpicSettings.Settings['useCharge'];
				v125 = 270 - (239 + 30);
			end
			if ((v125 == (2 + 4)) or ((6 + 0) >= (3342 - 1453))) then
				v57 = EpicSettings.Settings['thunderousRoarWithCD'];
				break;
			end
			if (((1578 - 1072) <= (2207 - (306 + 9))) and (v125 == (13 - 9))) then
				v44 = EpicSettings.Settings['useRecklessness'];
				v46 = EpicSettings.Settings['useChampionsSpear'];
				v47 = EpicSettings.Settings['useThunderousRoar'];
				v52 = EpicSettings.Settings['avatarWithCD'];
				v125 = 1 + 4;
			end
			if ((v125 == (4 + 1)) or ((967 + 1041) > (6342 - 4124))) then
				v53 = EpicSettings.Settings['odynFuryWithCD'];
				v54 = EpicSettings.Settings['ravagerWithCD'];
				v55 = EpicSettings.Settings['recklessnessWithCD'];
				v56 = EpicSettings.Settings['championsSpearWithCD'];
				v125 = 1381 - (1140 + 235);
			end
			if (((242 + 137) <= (3803 + 344)) and (v125 == (1 + 0))) then
				v36 = EpicSettings.Settings['useCrushingBlow'];
				v37 = EpicSettings.Settings['useExecute'];
				v38 = EpicSettings.Settings['useHeroicThrow'];
				v40 = EpicSettings.Settings['useOnslaught'];
				v125 = 54 - (33 + 19);
			end
			if ((v125 == (2 + 1)) or ((13529 - 9015) <= (445 + 564))) then
				v49 = EpicSettings.Settings['useWreckingThrow'];
				v31 = EpicSettings.Settings['useAvatar'];
				v39 = EpicSettings.Settings['useOdynsFury'];
				v43 = EpicSettings.Settings['useRavager'];
				v125 = 7 - 3;
			end
			if ((v125 == (2 + 0)) or ((4185 - (586 + 103)) == (109 + 1083))) then
				v41 = EpicSettings.Settings['useRagingBlow'];
				v42 = EpicSettings.Settings['useRampage'];
				v45 = EpicSettings.Settings['useSlam'];
				v48 = EpicSettings.Settings['useWhirlwind'];
				v125 = 9 - 6;
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
		v72 = EpicSettings.Settings['bitterImmunityHP'] or (1488 - (1309 + 179));
		v73 = EpicSettings.Settings['enragedRegenerationHP'] or (0 - 0);
		v74 = EpicSettings.Settings['ignorePainHP'] or (0 + 0);
		v75 = EpicSettings.Settings['rallyingCryHP'] or (0 - 0);
		v76 = EpicSettings.Settings['rallyingCryGroup'] or (0 + 0);
		v77 = EpicSettings.Settings['interveneHP'] or (0 - 0);
		v78 = EpicSettings.Settings['defensiveStanceHP'] or (0 - 0);
		v81 = EpicSettings.Settings['unstanceHP'] or (609 - (295 + 314));
		v82 = EpicSettings.Settings['victoryRushHP'] or (0 - 0);
		v83 = EpicSettings.Settings['ravagerSetting'] or "player";
		v84 = EpicSettings.Settings['spearSetting'] or "player";
	end
	local function v111()
		local v136 = 1962 - (1300 + 662);
		while true do
			if ((v136 == (6 - 4)) or ((1963 - (1178 + 577)) == (1537 + 1422))) then
				v69 = EpicSettings.Settings['useHealthstone'];
				v70 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v80 = EpicSettings.Settings['healingPotionHP'] or (1405 - (851 + 554));
				v136 = 3 + 0;
			end
			if (((11861 - 7584) >= (2851 - 1538)) and (v136 == (305 - (115 + 187)))) then
				v86 = EpicSettings.Settings['HealingPotionName'] or "";
				v85 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((1982 + 605) < (3005 + 169)) and (v136 == (0 - 0))) then
				v90 = EpicSettings.Settings['fightRemainsCheck'] or (1161 - (160 + 1001));
				v87 = EpicSettings.Settings['InterruptWithStun'];
				v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v89 = EpicSettings.Settings['InterruptThreshold'];
				v136 = 1 + 0;
			end
			if ((v136 == (1 + 0)) or ((8434 - 4314) <= (2556 - (237 + 121)))) then
				v51 = EpicSettings.Settings['useTrinkets'];
				v50 = EpicSettings.Settings['useRacials'];
				v59 = EpicSettings.Settings['trinketsWithCD'];
				v58 = EpicSettings.Settings['racialsWithCD'];
				v136 = 899 - (525 + 372);
			end
		end
	end
	local function v112()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (0 - 0)) or ((1738 - (96 + 46)) == (1635 - (643 + 134)))) then
				v110();
				v109();
				v111();
				v137 = 1 + 0;
			end
			if (((7720 - 4500) == (11954 - 8734)) and (v137 == (2 + 0))) then
				if (v14:IsDeadOrGhost() or ((2751 - 1349) > (7399 - 3779))) then
					return v27;
				end
				if (((3293 - (316 + 403)) == (1711 + 863)) and v29) then
					local v183 = 0 - 0;
					while true do
						if (((650 + 1148) < (6942 - 4185)) and (v183 == (0 + 0))) then
							v98 = v14:GetEnemiesInMeleeRange(3 + 5);
							v99 = #v98;
							break;
						end
					end
				else
					v99 = 3 - 2;
				end
				v100 = v15:IsInMeleeRange(23 - 18);
				v137 = 5 - 2;
			end
			if ((v137 == (1 + 2)) or ((741 - 364) > (128 + 2476))) then
				if (((1671 - 1103) < (928 - (12 + 5))) and (v91.TargetIsValid() or v14:AffectingCombat())) then
					local v184 = 0 - 0;
					while true do
						if (((7008 - 3723) < (8987 - 4759)) and (v184 == (0 - 0))) then
							v96 = v10.BossFightRemains(nil, true);
							v97 = v96;
							v184 = 1 + 0;
						end
						if (((5889 - (1656 + 317)) > (2966 + 362)) and ((1 + 0) == v184)) then
							if (((6647 - 4147) < (18893 - 15054)) and (v97 == (11465 - (5 + 349)))) then
								v97 = v10.FightRemains(v98, false);
							end
							break;
						end
					end
				end
				if (((2408 - 1901) == (1778 - (266 + 1005))) and not v14:IsChanneling()) then
					if (((159 + 81) <= (10799 - 7634)) and v14:AffectingCombat()) then
						local v185 = 0 - 0;
						while true do
							if (((2530 - (561 + 1135)) >= (1048 - 243)) and (v185 == (0 - 0))) then
								v27 = v107();
								if (v27 or ((4878 - (507 + 559)) < (5811 - 3495))) then
									return v27;
								end
								break;
							end
						end
					else
						v27 = v108();
						if (v27 or ((8201 - 5549) <= (1921 - (212 + 176)))) then
							return v27;
						end
					end
				end
				break;
			end
			if ((v137 == (906 - (250 + 655))) or ((9811 - 6213) < (2551 - 1091))) then
				v28 = EpicSettings.Toggles['ooc'];
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				v137 = 2 - 0;
			end
		end
	end
	local function v113()
		v20.Print("Fury Warrior by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(2028 - (1869 + 87), v112, v113);
end;
return v0["Epix_Warrior_Fury.lua"]();

