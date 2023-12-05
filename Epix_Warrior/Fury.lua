local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((3312 - 2636) == (1732 - (657 + 399))) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((844 + 3292) > (5569 - 3172)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1 + 0)) or ((2709 + 1625) == (5341 - (709 + 387)))) then
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
	local v96 = 12969 - (673 + 1185);
	local v97 = 32223 - 21112;
	v10:RegisterForEvent(function()
		v96 = 35679 - 24568;
		v97 = 18281 - 7170;
	end, "PLAYER_REGEN_ENABLED");
	local v98, v99;
	local v100;
	local function v101()
		local v114 = UnitGetTotalAbsorbs(v15);
		if ((v114 > (0 + 0)) or ((3196 + 1080) <= (4092 - 1061))) then
			return true;
		else
			return false;
		end
	end
	local function v102()
		if ((v92.BitterImmunity:IsReady() and v63 and (v14:HealthPercentage() <= v72)) or ((1175 + 3607) <= (2390 - 1191))) then
			if (v24(v92.BitterImmunity) or ((9548 - 4684) < (3782 - (446 + 1434)))) then
				return "bitter_immunity defensive";
			end
		end
		if (((6122 - (1040 + 243)) >= (11043 - 7343)) and v92.EnragedRegeneration:IsCastable() and v64 and (v14:HealthPercentage() <= v73)) then
			if (v24(v92.EnragedRegeneration) or ((2922 - (559 + 1288)) > (3849 - (609 + 1322)))) then
				return "enraged_regeneration defensive";
			end
		end
		if (((850 - (13 + 441)) <= (14214 - 10410)) and v92.IgnorePain:IsCastable() and v65 and (v14:HealthPercentage() <= v74)) then
			if (v24(v92.IgnorePain, nil, nil, true) or ((10919 - 6750) == (10892 - 8705))) then
				return "ignore_pain defensive";
			end
		end
		if (((53 + 1353) == (5106 - 3700)) and v92.RallyingCry:IsCastable() and v66 and v14:BuffDown(v92.AspectsFavorBuff) and v14:BuffDown(v92.RallyingCry) and (((v14:HealthPercentage() <= v75) and v91.IsSoloMode()) or v91.AreUnitsBelowHealthPercentage(v75, v76))) then
			if (((544 + 987) < (1872 + 2399)) and v24(v92.RallyingCry)) then
				return "rallying_cry defensive";
			end
		end
		if (((1884 - 1249) == (348 + 287)) and v92.Intervene:IsCastable() and v67 and (v17:HealthPercentage() <= v77) and (v17:UnitName() ~= v14:UnitName())) then
			if (((6203 - 2830) <= (2351 + 1205)) and v24(v94.InterveneFocus)) then
				return "intervene defensive";
			end
		end
		if ((v92.DefensiveStance:IsCastable() and v68 and (v14:HealthPercentage() <= v78) and v14:BuffDown(v92.DefensiveStance, true)) or ((1831 + 1460) < (2357 + 923))) then
			if (((3683 + 703) >= (855 + 18)) and v24(v92.DefensiveStance)) then
				return "defensive_stance defensive";
			end
		end
		if (((1354 - (153 + 280)) <= (3181 - 2079)) and v92.BerserkerStance:IsCastable() and v68 and (v14:HealthPercentage() > v81) and v14:BuffDown(v92.BerserkerStance, true)) then
			if (((4226 + 480) >= (381 + 582)) and v24(v92.BerserkerStance)) then
				return "berserker_stance after defensive stance defensive";
			end
		end
		if ((v93.Healthstone:IsReady() and v69 and (v14:HealthPercentage() <= v79)) or ((503 + 457) <= (795 + 81))) then
			if (v24(v94.Healthstone) or ((1498 + 568) == (1418 - 486))) then
				return "healthstone defensive 3";
			end
		end
		if (((2983 + 1842) < (5510 - (89 + 578))) and v70 and (v14:HealthPercentage() <= v80)) then
			if ((v86 == "Refreshing Healing Potion") or ((2770 + 1107) >= (9432 - 4895))) then
				if (v93.RefreshingHealingPotion:IsReady() or ((5364 - (572 + 477)) < (233 + 1493))) then
					if (v24(v94.RefreshingHealingPotion) or ((2208 + 1471) < (75 + 550))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if ((v86 == "Dreamwalker's Healing Potion") or ((4711 - (84 + 2)) < (1040 - 408))) then
				if (v93.DreamwalkersHealingPotion:IsReady() or ((60 + 23) > (2622 - (497 + 345)))) then
					if (((14 + 532) <= (183 + 894)) and v24(v94.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v103()
		local v115 = 1333 - (605 + 728);
		while true do
			if (((1 + 0) == v115) or ((2214 - 1218) > (198 + 4103))) then
				v27 = v91.HandleBottomTrinket(v95, v30, 147 - 107, nil);
				if (((3670 + 400) > (1903 - 1216)) and v27) then
					return v27;
				end
				break;
			end
			if ((v115 == (0 + 0)) or ((1145 - (457 + 32)) >= (1413 + 1917))) then
				v27 = v91.HandleTopTrinket(v95, v30, 1442 - (832 + 570), nil);
				if (v27 or ((2348 + 144) <= (88 + 247))) then
					return v27;
				end
				v115 = 3 - 2;
			end
		end
	end
	local function v104()
		if (((2082 + 2240) >= (3358 - (588 + 208))) and v31 and ((v52 and v30) or not v52) and (v90 < v97) and v92.Avatar:IsCastable() and not v92.TitansTorment:IsAvailable()) then
			if (v24(v92.Avatar, not v100) or ((9802 - 6165) >= (5570 - (884 + 916)))) then
				return "avatar precombat 6";
			end
		end
		if ((v44 and ((v55 and v30) or not v55) and (v90 < v97) and v92.Recklessness:IsCastable() and not v92.RecklessAbandon:IsAvailable()) or ((4980 - 2601) > (2655 + 1923))) then
			if (v24(v92.Recklessness, not v100) or ((1136 - (232 + 421)) > (2632 - (1569 + 320)))) then
				return "recklessness precombat 8";
			end
		end
		if (((603 + 1851) > (110 + 468)) and v92.Bloodthirst:IsCastable() and v34 and v100) then
			if (((3133 - 2203) < (5063 - (316 + 289))) and v24(v92.Bloodthirst, not v100)) then
				return "bloodthirst precombat 10";
			end
		end
		if (((1732 - 1070) <= (45 + 927)) and v35 and v92.Charge:IsReady() and not v100) then
			if (((5823 - (666 + 787)) == (4795 - (360 + 65))) and v24(v92.Charge, not v15:IsSpellInRange(v92.Charge))) then
				return "charge precombat 12";
			end
		end
	end
	local function v105()
		local v116 = 0 + 0;
		local v117;
		while true do
			if ((v116 == (256 - (79 + 175))) or ((7508 - 2746) <= (672 + 189))) then
				if ((v92.Onslaught:IsReady() and v40 and (v14:BuffUp(v92.EnrageBuff) or v92.Tenderize:IsAvailable())) or ((4327 - 2915) == (8211 - 3947))) then
					if (v24(v92.Onslaught, not v100) or ((4067 - (503 + 396)) < (2334 - (92 + 89)))) then
						return "onslaught single_target 18";
					end
				end
				if ((v92.CrushingBlow:IsCastable() and v36 and v92.WrathandFury:IsAvailable() and v14:BuffUp(v92.EnrageBuff) and v14:BuffDown(v92.FuriousBloodthirstBuff)) or ((9652 - 4676) < (684 + 648))) then
					if (((2740 + 1888) == (18123 - 13495)) and v24(v92.CrushingBlow, not v100)) then
						return "crushing_blow single_target 20";
					end
				end
				if ((v92.Execute:IsReady() and v37 and ((v14:BuffUp(v92.EnrageBuff) and v14:BuffDown(v92.FuriousBloodthirstBuff) and v14:BuffUp(v92.AshenJuggernautBuff)) or ((v14:BuffRemains(v92.SuddenDeathBuff) <= v14:GCD()) and (((v15:HealthPercentage() > (5 + 30)) and v92.Massacre:IsAvailable()) or (v15:HealthPercentage() > (45 - 25)))))) or ((48 + 6) == (189 + 206))) then
					if (((249 - 167) == (11 + 71)) and v24(v92.Execute, not v100)) then
						return "execute single_target 22";
					end
				end
				if ((v92.Rampage:IsReady() and v42 and v92.RecklessAbandon:IsAvailable() and (v14:BuffUp(v92.RecklessnessBuff) or (v14:BuffRemains(v92.EnrageBuff) < v14:GCD()) or (v14:RagePercentage() > (129 - 44)))) or ((1825 - (485 + 759)) < (652 - 370))) then
					if (v24(v92.Rampage, not v100) or ((5798 - (442 + 747)) < (3630 - (832 + 303)))) then
						return "rampage single_target 24";
					end
				end
				v116 = 949 - (88 + 858);
			end
			if (((352 + 800) == (954 + 198)) and (v116 == (1 + 5))) then
				if (((2685 - (766 + 23)) <= (16893 - 13471)) and v92.Rampage:IsReady() and v42) then
					if (v24(v92.Rampage, not v100) or ((1353 - 363) > (4268 - 2648))) then
						return "rampage single_target 47";
					end
				end
				if ((v92.Slam:IsReady() and v45 and (v92.Annihilator:IsAvailable())) or ((2976 - 2099) > (5768 - (1036 + 37)))) then
					if (((1908 + 783) >= (3604 - 1753)) and v24(v92.Slam, not v100)) then
						return "slam single_target 48";
					end
				end
				if ((v92.Bloodbath:IsCastable() and v33) or ((2349 + 636) >= (6336 - (641 + 839)))) then
					if (((5189 - (910 + 3)) >= (3046 - 1851)) and v24(v92.Bloodbath, not v100)) then
						return "bloodbath single_target 50";
					end
				end
				if (((4916 - (1466 + 218)) <= (2156 + 2534)) and v92.RagingBlow:IsCastable() and v41) then
					if (v24(v92.RagingBlow, not v100) or ((2044 - (556 + 592)) >= (1119 + 2027))) then
						return "raging_blow single_target 52";
					end
				end
				v116 = 815 - (329 + 479);
			end
			if (((3915 - (174 + 680)) >= (10163 - 7205)) and (v116 == (8 - 4))) then
				if (((2276 + 911) >= (1383 - (396 + 343))) and v92.Rampage:IsReady() and v42 and (v15:HealthPercentage() < (4 + 31)) and v92.Massacre:IsAvailable()) then
					if (((2121 - (29 + 1448)) <= (2093 - (135 + 1254))) and v24(v92.Rampage, not v100)) then
						return "rampage single_target 32";
					end
				end
				if (((3608 - 2650) > (4421 - 3474)) and v92.Bloodthirst:IsCastable() and v34 and (not v14:BuffUp(v92.EnrageBuff) or (v92.Annihilator:IsAvailable() and v14:BuffDown(v92.RecklessnessBuff))) and v14:BuffDown(v92.FuriousBloodthirstBuff)) then
					if (((2994 + 1498) >= (4181 - (389 + 1138))) and v24(v92.Bloodthirst, not v100)) then
						return "bloodthirst single_target 34";
					end
				end
				if (((4016 - (102 + 472)) >= (1419 + 84)) and v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (1 + 0)) and v92.WrathandFury:IsAvailable()) then
					if (v24(v92.RagingBlow, not v100) or ((2956 + 214) <= (3009 - (320 + 1225)))) then
						return "raging_blow single_target 36";
					end
				end
				if ((v92.CrushingBlow:IsCastable() and v36 and (v92.CrushingBlow:Charges() > (1 - 0)) and v92.WrathandFury:IsAvailable() and v14:BuffDown(v92.FuriousBloodthirstBuff)) or ((2936 + 1861) == (5852 - (157 + 1307)))) then
					if (((2410 - (821 + 1038)) <= (1698 - 1017)) and v24(v92.CrushingBlow, not v100)) then
						return "crushing_blow single_target 38";
					end
				end
				v116 = 1 + 4;
			end
			if (((5820 - 2543) > (152 + 255)) and (v116 == (17 - 10))) then
				if (((5721 - (834 + 192)) >= (90 + 1325)) and v92.CrushingBlow:IsCastable() and v36 and v14:BuffDown(v92.FuriousBloodthirstBuff)) then
					if (v24(v92.CrushingBlow, not v100) or ((825 + 2387) <= (21 + 923))) then
						return "crushing_blow single_target 54";
					end
				end
				if ((v92.Bloodthirst:IsCastable() and v34) or ((4795 - 1699) <= (2102 - (300 + 4)))) then
					if (((945 + 2592) == (9258 - 5721)) and v24(v92.Bloodthirst, not v100)) then
						return "bloodthirst single_target 56";
					end
				end
				if (((4199 - (112 + 250)) >= (626 + 944)) and v29 and v92.Whirlwind:IsCastable() and v48) then
					if (v24(v92.Whirlwind, not v15:IsInMeleeRange(19 - 11)) or ((1690 + 1260) == (1972 + 1840))) then
						return "whirlwind single_target 58";
					end
				end
				break;
			end
			if (((3533 + 1190) >= (1150 + 1168)) and (v116 == (3 + 0))) then
				if ((v92.Execute:IsReady() and v37 and v14:BuffUp(v92.EnrageBuff)) or ((3441 - (1001 + 413)) > (6359 - 3507))) then
					if (v24(v92.Execute, not v100) or ((2018 - (244 + 638)) > (5010 - (627 + 66)))) then
						return "execute single_target 26";
					end
				end
				if (((14147 - 9399) == (5350 - (512 + 90))) and v92.Rampage:IsReady() and v42 and v92.AngerManagement:IsAvailable()) then
					if (((5642 - (1665 + 241)) <= (5457 - (373 + 344))) and v24(v92.Rampage, not v100)) then
						return "rampage single_target 28";
					end
				end
				if ((v92.Execute:IsReady() and v37) or ((1529 + 1861) <= (810 + 2250))) then
					if (v24(v92.Execute, not v100) or ((2634 - 1635) > (4556 - 1863))) then
						return "execute single_target 29";
					end
				end
				if (((1562 - (35 + 1064)) < (438 + 163)) and v92.Bloodbath:IsCastable() and v33 and v14:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and not v92.WrathandFury:IsAvailable()) then
					if (v24(v92.Bloodbath, not v100) or ((4670 - 2487) < (3 + 684))) then
						return "bloodbath single_target 30";
					end
				end
				v116 = 1240 - (298 + 938);
			end
			if (((5808 - (233 + 1026)) == (6215 - (636 + 1030))) and (v116 == (1 + 0))) then
				v117 = v14:CritChancePct() + (v25(v14:BuffUp(v92.RecklessnessBuff)) * (20 + 0)) + (v14:BuffStack(v92.MercilessAssaultBuff) * (3 + 7)) + (v14:BuffStack(v92.BloodcrazeBuff) * (2 + 13));
				if (((4893 - (55 + 166)) == (906 + 3766)) and ((v117 >= (10 + 85)) or (not v92.ColdSteelHotBlood:IsAvailable() and v14:HasTier(114 - 84, 301 - (36 + 261))))) then
					local v174 = 0 - 0;
					while true do
						if ((v174 == (1368 - (34 + 1334))) or ((1411 + 2257) < (307 + 88))) then
							if ((v92.Bloodbath:IsCastable() and v33) or ((5449 - (1035 + 248)) == (476 - (20 + 1)))) then
								if (v24(v92.Bloodbath, not v100) or ((2318 + 2131) == (2982 - (134 + 185)))) then
									return "bloodbath single_target 10";
								end
							end
							if ((v92.Bloodthirst:IsCastable() and v34) or ((5410 - (549 + 584)) < (3674 - (314 + 371)))) then
								if (v24(v92.Bloodthirst, not v100) or ((2986 - 2116) >= (5117 - (478 + 490)))) then
									return "bloodthirst single_target 12";
								end
							end
							break;
						end
					end
				end
				if (((1172 + 1040) < (4355 - (786 + 386))) and v92.Bloodbath:IsCastable() and v33 and v14:HasTier(100 - 69, 1381 - (1055 + 324))) then
					if (((5986 - (1093 + 247)) > (2659 + 333)) and v24(v92.Bloodbath, not v100)) then
						return "bloodbath single_target 14";
					end
				end
				if (((151 + 1283) < (12331 - 9225)) and v47 and ((v57 and v30) or not v57) and (v90 < v97) and v92.ThunderousRoar:IsCastable() and v14:BuffUp(v92.EnrageBuff)) then
					if (((2667 - 1881) < (8601 - 5578)) and v24(v92.ThunderousRoar, not v15:IsInMeleeRange(19 - 11))) then
						return "thunderous_roar single_target 16";
					end
				end
				v116 = 1 + 1;
			end
			if ((v116 == (19 - 14)) or ((8416 - 5974) < (56 + 18))) then
				if (((11597 - 7062) == (5223 - (364 + 324))) and v92.Bloodbath:IsCastable() and v33 and (not v14:BuffUp(v92.EnrageBuff) or not v92.WrathandFury:IsAvailable())) then
					if (v24(v92.Bloodbath, not v100) or ((8248 - 5239) <= (5051 - 2946))) then
						return "bloodbath single_target 40";
					end
				end
				if (((607 + 1223) < (15352 - 11683)) and v92.CrushingBlow:IsCastable() and v36 and v14:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and v14:BuffDown(v92.FuriousBloodthirstBuff)) then
					if (v24(v92.CrushingBlow, not v100) or ((2290 - 860) >= (10969 - 7357))) then
						return "crushing_blow single_target 42";
					end
				end
				if (((3951 - (1249 + 19)) >= (2221 + 239)) and v92.Bloodthirst:IsCastable() and v34 and not v92.WrathandFury:IsAvailable() and v14:BuffDown(v92.FuriousBloodthirstBuff)) then
					if (v24(v92.Bloodthirst, not v100) or ((7021 - 5217) >= (4361 - (686 + 400)))) then
						return "bloodthirst single_target 44";
					end
				end
				if ((v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (1 + 0))) or ((1646 - (73 + 156)) > (18 + 3611))) then
					if (((5606 - (721 + 90)) > (5 + 397)) and v24(v92.RagingBlow, not v100)) then
						return "raging_blow single_target 46";
					end
				end
				v116 = 19 - 13;
			end
			if (((5283 - (224 + 246)) > (5775 - 2210)) and (v116 == (0 - 0))) then
				if (((710 + 3202) == (94 + 3818)) and v92.Whirlwind:IsCastable() and v48 and (v99 > (1 + 0)) and v92.ImprovedWhilwind:IsAvailable() and v14:BuffDown(v92.MeatCleaverBuff)) then
					if (((5608 - 2787) <= (16053 - 11229)) and v24(v92.Whirlwind, not v15:IsInMeleeRange(521 - (203 + 310)))) then
						return "whirlwind single_target 2";
					end
				end
				if (((3731 - (1238 + 755)) <= (154 + 2041)) and v92.Execute:IsReady() and v37 and v14:BuffUp(v92.AshenJuggernautBuff) and (v14:BuffRemains(v92.AshenJuggernautBuff) < v14:GCD())) then
					if (((1575 - (709 + 825)) <= (5561 - 2543)) and v24(v92.Execute, not v100)) then
						return "execute single_target 4";
					end
				end
				if (((3124 - 979) <= (4968 - (196 + 668))) and v39 and ((v53 and v30) or not v53) and v92.OdynsFury:IsCastable() and (v90 < v97) and v14:BuffUp(v92.EnrageBuff) and ((v92.DancingBlades:IsAvailable() and (v14:BuffRemains(v92.DancingBladesBuff) < (19 - 14))) or not v92.DancingBlades:IsAvailable())) then
					if (((5569 - 2880) < (5678 - (171 + 662))) and v24(v92.OdynsFury, not v15:IsInMeleeRange(101 - (4 + 89)))) then
						return "odyns_fury single_target 6";
					end
				end
				if ((v92.Rampage:IsReady() and v42 and v92.AngerManagement:IsAvailable() and (v14:BuffUp(v92.RecklessnessBuff) or (v14:BuffRemains(v92.EnrageBuff) < v14:GCD()) or (v14:RagePercentage() > (297 - 212)))) or ((846 + 1476) > (11516 - 8894))) then
					if (v24(v92.Rampage, not v100) or ((1779 + 2755) == (3568 - (35 + 1451)))) then
						return "rampage single_target 8";
					end
				end
				v116 = 1454 - (28 + 1425);
			end
		end
	end
	local function v106()
		local v118 = 1993 - (941 + 1052);
		local v119;
		while true do
			if ((v118 == (4 + 0)) or ((3085 - (822 + 692)) > (2665 - 798))) then
				if ((v92.Execute:IsReady() and v37) or ((1251 + 1403) >= (3293 - (45 + 252)))) then
					if (((3936 + 42) > (725 + 1379)) and v24(v92.Execute, not v100)) then
						return "execute multi_target 22";
					end
				end
				if (((7289 - 4294) > (1974 - (114 + 319))) and v92.Bloodbath:IsCastable() and v33 and v14:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable() and not v92.WrathandFury:IsAvailable()) then
					if (((4664 - 1415) > (1220 - 267)) and v24(v92.Bloodbath, not v100)) then
						return "bloodbath multi_target 24";
					end
				end
				if ((v92.Bloodthirst:IsCastable() and v34 and (not v14:BuffUp(v92.EnrageBuff) or (v92.Annihilator:IsAvailable() and v14:BuffDown(v92.RecklessnessBuff)))) or ((2087 + 1186) > (6812 - 2239))) then
					if (v24(v92.Bloodthirst, not v100) or ((6602 - 3451) < (3247 - (556 + 1407)))) then
						return "bloodthirst multi_target 26";
					end
				end
				v118 = 1211 - (741 + 465);
			end
			if ((v118 == (471 - (170 + 295))) or ((975 + 875) == (1405 + 124))) then
				if (((2021 - 1200) < (1760 + 363)) and v92.Bloodbath:IsCastable() and v33 and (not v14:BuffUp(v92.EnrageBuff) or not v92.WrathandFury:IsAvailable())) then
					if (((579 + 323) < (1317 + 1008)) and v24(v92.Bloodbath, not v100)) then
						return "bloodbath multi_target 34";
					end
				end
				if (((2088 - (957 + 273)) <= (793 + 2169)) and v92.CrushingBlow:IsCastable() and v36 and v14:BuffUp(v92.EnrageBuff) and v92.RecklessAbandon:IsAvailable()) then
					if (v24(v92.CrushingBlow, not v100) or ((1580 + 2366) < (4907 - 3619))) then
						return "crushing_blow multi_target 36";
					end
				end
				if ((v92.Bloodthirst:IsCastable() and v34 and not v92.WrathandFury:IsAvailable()) or ((8543 - 5301) == (1731 - 1164))) then
					if (v24(v92.Bloodthirst, not v100) or ((4194 - 3347) >= (3043 - (389 + 1391)))) then
						return "bloodthirst multi_target 38";
					end
				end
				v118 = 5 + 2;
			end
			if ((v118 == (1 + 7)) or ((5129 - 2876) == (2802 - (783 + 168)))) then
				if ((v92.Bloodbath:IsCastable() and v33) or ((7004 - 4917) > (2334 + 38))) then
					if (v24(v92.Bloodbath, not v100) or ((4756 - (309 + 2)) < (12740 - 8591))) then
						return "bloodbath multi_target 46";
					end
				end
				if ((v92.RagingBlow:IsCastable() and v41) or ((3030 - (1090 + 122)) == (28 + 57))) then
					if (((2115 - 1485) < (1456 + 671)) and v24(v92.RagingBlow, not v100)) then
						return "raging_blow multi_target 48";
					end
				end
				if ((v92.CrushingBlow:IsCastable() and v36) or ((3056 - (628 + 490)) == (451 + 2063))) then
					if (((10535 - 6280) >= (251 - 196)) and v24(v92.CrushingBlow, not v100)) then
						return "crushing_blow multi_target 50";
					end
				end
				v118 = 783 - (431 + 343);
			end
			if (((6056 - 3057) > (3344 - 2188)) and ((0 + 0) == v118)) then
				if (((301 + 2049) > (2850 - (556 + 1139))) and v92.Recklessness:IsCastable() and ((v55 and v30) or not v55) and v44 and (v90 < v97) and ((v99 > (16 - (6 + 9))) or (v97 < (3 + 9)))) then
					if (((2064 + 1965) <= (5022 - (28 + 141))) and v24(v92.Recklessness, not v100)) then
						return "recklessness multi_target 2";
					end
				end
				if ((v92.OdynsFury:IsCastable() and ((v53 and v30) or not v53) and v39 and (v90 < v97) and (v99 > (1 + 0)) and v92.TitanicRage:IsAvailable() and (v14:BuffDown(v92.MeatCleaverBuff) or v14:BuffUp(v92.AvatarBuff) or v14:BuffUp(v92.RecklessnessBuff))) or ((636 - 120) > (2433 + 1001))) then
					if (((5363 - (486 + 831)) >= (7892 - 4859)) and v24(v92.OdynsFury, not v15:IsInMeleeRange(27 - 19))) then
						return "odyns_fury multi_target 4";
					end
				end
				if ((v92.Whirlwind:IsCastable() and v48 and (v99 > (1 + 0)) and v92.ImprovedWhilwind:IsAvailable() and v14:BuffDown(v92.MeatCleaverBuff)) or ((8597 - 5878) <= (2710 - (668 + 595)))) then
					if (v24(v92.Whirlwind, not v15:IsInMeleeRange(8 + 0)) or ((834 + 3300) < (10706 - 6780))) then
						return "whirlwind multi_target 6";
					end
				end
				v118 = 291 - (23 + 267);
			end
			if ((v118 == (1949 - (1129 + 815))) or ((551 - (371 + 16)) >= (4535 - (1326 + 424)))) then
				if ((v92.Onslaught:IsReady() and v40 and ((not v92.Annihilator:IsAvailable() and v14:BuffUp(v92.EnrageBuff)) or v92.Tenderize:IsAvailable())) or ((994 - 469) == (7706 - 5597))) then
					if (((151 - (88 + 30)) == (804 - (720 + 51))) and v24(v92.Onslaught, not v100)) then
						return "onslaught multi_target 28";
					end
				end
				if (((6793 - 3739) <= (5791 - (421 + 1355))) and v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (1 - 0)) and v92.WrathandFury:IsAvailable()) then
					if (((920 + 951) < (4465 - (286 + 797))) and v24(v92.RagingBlow, not v100)) then
						return "raging_blow multi_target 30";
					end
				end
				if (((4726 - 3433) <= (3587 - 1421)) and v92.CrushingBlow:IsCastable() and v36 and (v92.CrushingBlow:Charges() > (440 - (397 + 42))) and v92.WrathandFury:IsAvailable()) then
					if (v24(v92.CrushingBlow, not v100) or ((806 + 1773) < (923 - (24 + 776)))) then
						return "crushing_blow multi_target 32";
					end
				end
				v118 = 8 - 2;
			end
			if ((v118 == (794 - (222 + 563))) or ((1863 - 1017) >= (1705 + 663))) then
				if ((v92.Whirlwind:IsCastable() and v48) or ((4202 - (23 + 167)) <= (5156 - (690 + 1108)))) then
					if (((540 + 954) <= (2479 + 526)) and v24(v92.Whirlwind, not v15:IsInMeleeRange(856 - (40 + 808)))) then
						return "whirlwind multi_target 52";
					end
				end
				break;
			end
			if (((1 + 1) == v118) or ((11896 - 8785) == (2040 + 94))) then
				v119 = v14:CritChancePct() + (v25(v14:BuffUp(v92.RecklessnessBuff)) * (11 + 9)) + (v14:BuffStack(v92.MercilessAssaultBuff) * (6 + 4)) + (v14:BuffStack(v92.BloodcrazeBuff) * (586 - (47 + 524)));
				if (((1529 + 826) == (6437 - 4082)) and (v119 >= (142 - 47)) and v14:HasTier(68 - 38, 1730 - (1165 + 561))) then
					if ((v92.Bloodbath:IsCastable() and v33) or ((18 + 570) <= (1337 - 905))) then
						if (((1831 + 2966) >= (4374 - (341 + 138))) and v24(v92.Bloodbath, not v100)) then
							return "bloodbath multi_target 14";
						end
					end
					if (((966 + 2611) == (7381 - 3804)) and v92.Bloodthirst:IsCastable() and v34) then
						if (((4120 - (89 + 237)) > (11880 - 8187)) and v24(v92.Bloodthirst, not v100)) then
							return "bloodthirst multi_target 16";
						end
					end
				end
				if ((v92.CrushingBlow:IsCastable() and v92.WrathandFury:IsAvailable() and v36 and v14:BuffUp(v92.EnrageBuff)) or ((2684 - 1409) == (4981 - (581 + 300)))) then
					if (v24(v92.CrushingBlow, not v100) or ((2811 - (855 + 365)) >= (8503 - 4923))) then
						return "crushing_blow multi_target 14";
					end
				end
				v118 = 1 + 2;
			end
			if (((2218 - (1030 + 205)) <= (1698 + 110)) and (v118 == (1 + 0))) then
				if ((v92.Execute:IsReady() and v37 and v14:BuffUp(v92.AshenJuggernautBuff) and (v14:BuffRemains(v92.AshenJuggernautBuff) < v14:GCD())) or ((2436 - (156 + 130)) <= (2719 - 1522))) then
					if (((6351 - 2582) >= (2402 - 1229)) and v24(v92.Execute, not v100)) then
						return "execute multi_target 8";
					end
				end
				if (((392 + 1093) == (866 + 619)) and v92.ThunderousRoar:IsCastable() and ((v57 and v30) or not v57) and v47 and (v90 < v97) and v14:BuffUp(v92.EnrageBuff)) then
					if (v24(v92.ThunderousRoar, not v15:IsInMeleeRange(77 - (10 + 59))) or ((938 + 2377) <= (13700 - 10918))) then
						return "thunderous_roar multi_target 10";
					end
				end
				if ((v92.OdynsFury:IsCastable() and ((v53 and v30) or not v53) and v39 and (v90 < v97) and (v99 > (1164 - (671 + 492))) and v14:BuffUp(v92.EnrageBuff)) or ((698 + 178) >= (4179 - (369 + 846)))) then
					if (v24(v92.OdynsFury, not v15:IsInMeleeRange(3 + 5)) or ((1905 + 327) > (4442 - (1036 + 909)))) then
						return "odyns_fury multi_target 12";
					end
				end
				v118 = 2 + 0;
			end
			if ((v118 == (4 - 1)) or ((2313 - (11 + 192)) <= (168 + 164))) then
				if (((3861 - (135 + 40)) > (7685 - 4513)) and v92.Execute:IsReady() and v37 and v14:BuffUp(v92.EnrageBuff)) then
					if (v24(v92.Execute, not v100) or ((2697 + 1777) < (1806 - 986))) then
						return "execute multi_target 16";
					end
				end
				if (((6414 - 2135) >= (3058 - (50 + 126))) and v92.OdynsFury:IsCastable() and ((v53 and v30) or not v53) and v39 and (v90 < v97) and v14:BuffUp(v92.EnrageBuff)) then
					if (v24(v92.OdynsFury, not v15:IsInMeleeRange(22 - 14)) or ((450 + 1579) >= (4934 - (1233 + 180)))) then
						return "odyns_fury multi_target 18";
					end
				end
				if ((v92.Rampage:IsReady() and v42 and (v14:BuffUp(v92.RecklessnessBuff) or (v14:BuffRemains(v92.EnrageBuff) < v14:GCD()) or ((v14:Rage() > (1079 - (522 + 447))) and v92.OverwhelmingRage:IsAvailable()) or ((v14:Rage() > (1501 - (107 + 1314))) and not v92.OverwhelmingRage:IsAvailable()))) or ((946 + 1091) >= (14144 - 9502))) then
					if (((731 + 989) < (8852 - 4394)) and v24(v92.Rampage, not v100)) then
						return "rampage multi_target 20";
					end
				end
				v118 = 15 - 11;
			end
			if ((v118 == (1917 - (716 + 1194))) or ((8 + 428) > (324 + 2697))) then
				if (((1216 - (74 + 429)) <= (1633 - 786)) and v92.RagingBlow:IsCastable() and v41 and (v92.RagingBlow:Charges() > (1 + 0))) then
					if (((4930 - 2776) <= (2852 + 1179)) and v24(v92.RagingBlow, not v100)) then
						return "raging_blow multi_target 40";
					end
				end
				if (((14227 - 9612) == (11410 - 6795)) and v92.Rampage:IsReady() and v42) then
					if (v24(v92.Rampage, not v100) or ((4223 - (279 + 154)) == (1278 - (454 + 324)))) then
						return "rampage multi_target 42";
					end
				end
				if (((71 + 18) < (238 - (12 + 5))) and v92.Slam:IsReady() and v45 and (v92.Annihilator:IsAvailable())) then
					if (((1108 + 946) >= (3620 - 2199)) and v24(v92.Slam, not v100)) then
						return "slam multi_target 44";
					end
				end
				v118 = 3 + 5;
			end
		end
	end
	local function v107()
		local v120 = 1093 - (277 + 816);
		while true do
			if (((2956 - 2264) < (4241 - (1058 + 125))) and (v120 == (1 + 0))) then
				if (v85 or ((4229 - (815 + 160)) == (7101 - 5446))) then
					v27 = v91.HandleIncorporeal(v92.StormBolt, v94.StormBoltMouseover, 47 - 27, true);
					if (v27 or ((310 + 986) == (14352 - 9442))) then
						return v27;
					end
					v27 = v91.HandleIncorporeal(v92.IntimidatingShout, v94.IntimidatingShoutMouseover, 1906 - (41 + 1857), true);
					if (((5261 - (1222 + 671)) == (8704 - 5336)) and v27) then
						return v27;
					end
				end
				if (((3798 - 1155) < (4997 - (229 + 953))) and v91.TargetIsValid()) then
					local v175 = 1774 - (1111 + 663);
					local v176;
					while true do
						if (((3492 - (874 + 705)) > (70 + 423)) and (v175 == (1 + 0))) then
							if (((9883 - 5128) > (97 + 3331)) and (v90 < v97)) then
								if (((2060 - (642 + 37)) <= (541 + 1828)) and v51 and ((v30 and v59) or not v59)) then
									local v184 = 0 + 0;
									while true do
										if ((v184 == (0 - 0)) or ((5297 - (233 + 221)) == (9443 - 5359))) then
											v27 = v103();
											if (((4110 + 559) > (1904 - (718 + 823))) and v27) then
												return v27;
											end
											break;
										end
									end
								end
							end
							if (((v90 < v97) and v50 and ((v58 and v30) or not v58)) or ((1182 + 695) >= (3943 - (266 + 539)))) then
								if (((13425 - 8683) >= (4851 - (636 + 589))) and v92.BloodFury:IsCastable()) then
									if (v24(v92.BloodFury, not v100) or ((10776 - 6236) == (1888 - 972))) then
										return "blood_fury main 12";
									end
								end
								if ((v92.Berserking:IsCastable() and v14:BuffUp(v92.RecklessnessBuff)) or ((917 + 239) > (1579 + 2766))) then
									if (((3252 - (657 + 358)) < (11250 - 7001)) and v24(v92.Berserking, not v100)) then
										return "berserking main 14";
									end
								end
								if ((v92.LightsJudgment:IsCastable() and v14:BuffDown(v92.RecklessnessBuff)) or ((6112 - 3429) < (1210 - (1151 + 36)))) then
									if (((674 + 23) <= (218 + 608)) and v24(v92.LightsJudgment, not v15:IsSpellInRange(v92.LightsJudgment))) then
										return "lights_judgment main 16";
									end
								end
								if (((3299 - 2194) <= (3008 - (1552 + 280))) and v92.Fireblood:IsCastable()) then
									if (((4213 - (64 + 770)) <= (2589 + 1223)) and v24(v92.Fireblood, not v100)) then
										return "fireblood main 18";
									end
								end
								if (v92.AncestralCall:IsCastable() or ((1788 - 1000) >= (287 + 1329))) then
									if (((3097 - (157 + 1086)) <= (6762 - 3383)) and v24(v92.AncestralCall, not v100)) then
										return "ancestral_call main 20";
									end
								end
								if (((19923 - 15374) == (6977 - 2428)) and v92.BagofTricks:IsCastable() and v14:BuffDown(v92.RecklessnessBuff) and v14:BuffUp(v92.EnrageBuff)) then
									if (v22(v92.BagofTricks, not v15:IsSpellInRange(v92.BagofTricks)) or ((4124 - 1102) >= (3843 - (599 + 220)))) then
										return "bag_of_tricks main 22";
									end
								end
							end
							if (((9598 - 4778) > (4129 - (1813 + 118))) and (v90 < v97)) then
								local v182 = 0 + 0;
								while true do
									if ((v182 == (1218 - (841 + 376))) or ((1486 - 425) >= (1137 + 3754))) then
										if (((3722 - 2358) <= (5332 - (464 + 395))) and v92.Recklessness:IsCastable() and v44 and ((v55 and v30) or not v55) and (not v92.Annihilator:IsAvailable() or (v10.FightRemains() < (30 - 18)))) then
											if (v24(v92.Recklessness, not v100) or ((1727 + 1868) <= (840 - (467 + 370)))) then
												return "recklessness main 27";
											end
										end
										if ((v92.Ravager:IsCastable() and (v83 == "player") and v43 and ((v54 and v30) or not v54) and ((v92.Avatar:CooldownRemains() < (5 - 2)) or v14:BuffUp(v92.RecklessnessBuff) or (v97 < (8 + 2)))) or ((16015 - 11343) == (601 + 3251))) then
											if (((3626 - 2067) == (2079 - (150 + 370))) and v24(v94.RavagerPlayer, not v100)) then
												return "ravager main 28";
											end
										end
										v182 = 1284 - (74 + 1208);
									end
									if ((v182 == (4 - 2)) or ((8308 - 6556) <= (561 + 227))) then
										if ((v92.Ravager:IsCastable() and (v83 == "cursor") and v43 and ((v54 and v30) or not v54) and ((v92.Avatar:CooldownRemains() < (393 - (14 + 376))) or v14:BuffUp(v92.RecklessnessBuff) or (v97 < (17 - 7)))) or ((2529 + 1378) == (156 + 21))) then
											if (((3310 + 160) > (1626 - 1071)) and v24(v94.RavagerCursor, not v100)) then
												return "ravager main 28";
											end
										end
										if ((v92.SpearofBastion:IsCastable() and (v84 == "player") and v46 and ((v56 and v30) or not v56) and v14:BuffUp(v92.EnrageBuff) and (v14:BuffUp(v92.RecklessnessBuff) or v14:BuffUp(v92.AvatarBuff) or (v97 < (16 + 4)) or (v99 > (79 - (23 + 55))) or not v92.TitansTorment:IsAvailable() or not v14:HasTier(73 - 42, 2 + 0))) or ((873 + 99) == (1000 - 355))) then
											if (((1001 + 2181) >= (3016 - (652 + 249))) and v24(v94.SpearOfBastionPlayer, not v100)) then
												return "spear_of_bastion main 30";
											end
										end
										v182 = 7 - 4;
									end
									if (((5761 - (708 + 1160)) < (12022 - 7593)) and (v182 == (5 - 2))) then
										if ((v92.SpearofBastion:IsCastable() and (v84 == "cursor") and v46 and ((v56 and v30) or not v56) and v14:BuffUp(v92.EnrageBuff) and (v14:BuffUp(v92.RecklessnessBuff) or v14:BuffUp(v92.AvatarBuff) or (v97 < (47 - (10 + 17))) or (v99 > (1 + 0)) or not v92.TitansTorment:IsAvailable() or not v14:HasTier(1763 - (1400 + 332), 3 - 1))) or ((4775 - (242 + 1666)) < (816 + 1089))) then
											if (v24(v94.SpearOfBastionCursor, not v100) or ((659 + 1137) >= (3453 + 598))) then
												return "spear_of_bastion main 31";
											end
										end
										break;
									end
									if (((2559 - (850 + 90)) <= (6577 - 2821)) and (v182 == (1390 - (360 + 1030)))) then
										if (((535 + 69) == (1704 - 1100)) and v92.Avatar:IsCastable() and v31 and ((v52 and v30) or not v52) and ((v92.TitansTorment:IsAvailable() and v14:BuffUp(v92.EnrageBuff) and v14:BuffDown(v92.AvatarBuff) and (v92.OdynsFury:CooldownRemains() > (0 - 0))) or (v92.BerserkersTorment:IsAvailable() and v14:BuffUp(v92.EnrageBuff) and v14:BuffDown(v92.AvatarBuff)) or (not v92.TitansTorment:IsAvailable() and not v92.BerserkersTorment:IsAvailable() and (v14:BuffUp(v92.RecklessnessBuff) or (v97 < (1681 - (909 + 752))))))) then
											if (v24(v92.Avatar, not v100) or ((5707 - (109 + 1114)) == (1647 - 747))) then
												return "avatar main 24";
											end
										end
										if ((v92.Recklessness:IsCastable() and v44 and ((v55 and v30) or not v55) and ((v92.Annihilator:IsAvailable() and (v92.Avatar:CooldownRemains() < (1 + 0))) or (v92.Avatar:CooldownRemains() > (282 - (6 + 236))) or not v92.Avatar:IsAvailable() or (v97 < (8 + 4)))) or ((3590 + 869) <= (2624 - 1511))) then
											if (((6343 - 2711) > (4531 - (1076 + 57))) and v24(v92.Recklessness, not v100)) then
												return "recklessness main 26";
											end
										end
										v182 = 1 + 0;
									end
								end
							end
							v175 = 691 - (579 + 110);
						end
						if (((323 + 3759) <= (4348 + 569)) and (v175 == (0 + 0))) then
							if (((5239 - (174 + 233)) >= (3871 - 2485)) and v35 and v92.Charge:IsCastable()) then
								if (((240 - 103) == (61 + 76)) and v24(v92.Charge, not v15:IsSpellInRange(v92.Charge))) then
									return "charge main 2";
								end
							end
							v176 = v91.HandleDPSPotion(v15:BuffUp(v92.RecklessnessBuff));
							if (v176 or ((2744 - (663 + 511)) >= (3865 + 467))) then
								return v176;
							end
							v175 = 1 + 0;
						end
						if ((v175 == (9 - 6)) or ((2461 + 1603) <= (4282 - 2463))) then
							v27 = v105();
							if (v27 or ((12069 - 7083) < (752 + 822))) then
								return v27;
							end
							if (((8614 - 4188) > (123 + 49)) and v20.CastAnnotated(v92.Pool, false, "WAIT")) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((54 + 532) > (1177 - (478 + 244))) and (v175 == (519 - (440 + 77)))) then
							if (((376 + 450) == (3022 - 2196)) and v38 and v92.HeroicThrow:IsCastable() and not v15:IsInRange(1586 - (655 + 901))) then
								if (v24(v92.HeroicThrow, not v15:IsInRange(6 + 24)) or ((3077 + 942) > (2999 + 1442))) then
									return "heroic_throw main";
								end
							end
							if (((8125 - 6108) < (5706 - (695 + 750))) and v92.WreckingThrow:IsCastable() and v49 and v15:AffectingCombat() and v101()) then
								if (((16103 - 11387) > (123 - 43)) and v24(v92.WreckingThrow, not v15:IsInRange(120 - 90))) then
									return "wrecking_throw main";
								end
							end
							if ((v29 and (v99 > (353 - (285 + 66)))) or ((8174 - 4667) == (4582 - (682 + 628)))) then
								local v183 = 0 + 0;
								while true do
									if ((v183 == (299 - (176 + 123))) or ((367 + 509) >= (2231 + 844))) then
										v27 = v106();
										if (((4621 - (239 + 30)) > (695 + 1859)) and v27) then
											return v27;
										end
										break;
									end
								end
							end
							v175 = 3 + 0;
						end
					end
				end
				break;
			end
			if ((v120 == (0 - 0)) or ((13745 - 9339) < (4358 - (306 + 9)))) then
				v27 = v102();
				if (v27 or ((6591 - 4702) >= (589 + 2794))) then
					return v27;
				end
				v120 = 1 + 0;
			end
		end
	end
	local function v108()
		local v121 = 0 + 0;
		while true do
			if (((5410 - 3518) <= (4109 - (1140 + 235))) and (v121 == (0 + 0))) then
				if (((1764 + 159) < (570 + 1648)) and not v14:AffectingCombat()) then
					local v177 = 52 - (33 + 19);
					while true do
						if (((785 + 1388) > (1135 - 756)) and (v177 == (0 + 0))) then
							if ((v92.BerserkerStance:IsCastable() and v14:BuffDown(v92.BerserkerStance, true)) or ((5081 - 2490) == (3197 + 212))) then
								if (((5203 - (586 + 103)) > (303 + 3021)) and v24(v92.BerserkerStance)) then
									return "berserker_stance";
								end
							end
							if ((v92.BattleShout:IsCastable() and v32 and (v14:BuffDown(v92.BattleShoutBuff, true) or v91.GroupBuffMissing(v92.BattleShoutBuff))) or ((640 - 432) >= (6316 - (1309 + 179)))) then
								if (v24(v92.BattleShout) or ((2857 - 1274) > (1553 + 2014))) then
									return "battle_shout precombat";
								end
							end
							break;
						end
					end
				end
				if ((v91.TargetIsValid() and v28) or ((3525 - 2212) == (600 + 194))) then
					if (((6743 - 3569) > (5782 - 2880)) and not v14:AffectingCombat()) then
						local v180 = 609 - (295 + 314);
						while true do
							if (((10119 - 5999) <= (6222 - (1300 + 662))) and (v180 == (0 - 0))) then
								v27 = v104();
								if (v27 or ((2638 - (1178 + 577)) > (2482 + 2296))) then
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
	local function v109()
		local v122 = 0 - 0;
		while true do
			if ((v122 == (1412 - (851 + 554))) or ((3202 + 418) >= (13564 - 8673))) then
				v54 = EpicSettings.Settings['ravagerWithCD'];
				v55 = EpicSettings.Settings['recklessnessWithCD'];
				v56 = EpicSettings.Settings['spearOfBastionWithCD'];
				v122 = 17 - 9;
			end
			if (((4560 - (115 + 187)) > (718 + 219)) and (v122 == (6 + 0))) then
				v47 = EpicSettings.Settings['useThunderousRoar'];
				v52 = EpicSettings.Settings['avatarWithCD'];
				v53 = EpicSettings.Settings['odynFuryWithCD'];
				v122 = 27 - 20;
			end
			if (((1162 - (160 + 1001)) == v122) or ((4260 + 609) < (626 + 280))) then
				v35 = EpicSettings.Settings['useCharge'];
				v36 = EpicSettings.Settings['useCrushingBlow'];
				v37 = EpicSettings.Settings['useExecute'];
				v122 = 3 - 1;
			end
			if ((v122 == (361 - (237 + 121))) or ((2122 - (525 + 372)) > (8015 - 3787))) then
				v42 = EpicSettings.Settings['useRampage'];
				v45 = EpicSettings.Settings['useSlam'];
				v48 = EpicSettings.Settings['useWhirlwind'];
				v122 = 12 - 8;
			end
			if (((3470 - (96 + 46)) > (3015 - (643 + 134))) and (v122 == (2 + 3))) then
				v43 = EpicSettings.Settings['useRavager'];
				v44 = EpicSettings.Settings['useRecklessness'];
				v46 = EpicSettings.Settings['useSpearOfBastion'];
				v122 = 14 - 8;
			end
			if (((14252 - 10413) > (1348 + 57)) and (v122 == (3 - 1))) then
				v38 = EpicSettings.Settings['useHeroicThrow'];
				v40 = EpicSettings.Settings['useOnslaught'];
				v41 = EpicSettings.Settings['useRagingBlow'];
				v122 = 5 - 2;
			end
			if (((727 - (316 + 403)) == v122) or ((860 + 433) <= (1393 - 886))) then
				v57 = EpicSettings.Settings['thunderousRoarWithCD'];
				break;
			end
			if ((v122 == (0 + 0)) or ((7293 - 4397) < (571 + 234))) then
				v32 = EpicSettings.Settings['useBattleShout'];
				v33 = EpicSettings.Settings['useBloodbath'];
				v34 = EpicSettings.Settings['useBloodthirst'];
				v122 = 1 + 0;
			end
			if (((8024 - 5708) == (11060 - 8744)) and (v122 == (7 - 3))) then
				v49 = EpicSettings.Settings['useWreckingThrow'];
				v31 = EpicSettings.Settings['useAvatar'];
				v39 = EpicSettings.Settings['useOdynsFury'];
				v122 = 1 + 4;
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
		v73 = EpicSettings.Settings['enragedRegenerationHP'] or (0 + 0);
		v74 = EpicSettings.Settings['ignorePainHP'] or (0 - 0);
		v75 = EpicSettings.Settings['rallyingCryHP'] or (17 - (12 + 5));
		v76 = EpicSettings.Settings['rallyingCryGroup'] or (0 - 0);
		v77 = EpicSettings.Settings['interveneHP'] or (0 - 0);
		v78 = EpicSettings.Settings['defensiveStanceHP'] or (0 - 0);
		v81 = EpicSettings.Settings['unstanceHP'] or (0 - 0);
		v82 = EpicSettings.Settings['victoryRushHP'] or (0 + 0);
		v83 = EpicSettings.Settings['ravagerSetting'] or "player";
		v84 = EpicSettings.Settings['spearSetting'] or "player";
	end
	local function v111()
		local v133 = 1973 - (1656 + 317);
		while true do
			if ((v133 == (2 + 0)) or ((2060 + 510) == (4076 - 2543))) then
				v59 = EpicSettings.Settings['trinketsWithCD'];
				v58 = EpicSettings.Settings['racialsWithCD'];
				v69 = EpicSettings.Settings['useHealthstone'];
				v133 = 14 - 11;
			end
			if ((v133 == (357 - (5 + 349))) or ((4194 - 3311) == (2731 - (266 + 1005)))) then
				v70 = EpicSettings.Settings['useHealingPotion'];
				v79 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v80 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v133 = 4 - 0;
			end
			if ((v133 == (1697 - (561 + 1135))) or ((6018 - 1399) <= (3283 - 2284))) then
				v89 = EpicSettings.Settings['InterruptThreshold'];
				v51 = EpicSettings.Settings['useTrinkets'];
				v50 = EpicSettings.Settings['useRacials'];
				v133 = 1068 - (507 + 559);
			end
			if ((v133 == (9 - 5)) or ((10546 - 7136) > (4504 - (212 + 176)))) then
				v86 = EpicSettings.Settings['HealingPotionName'] or "";
				v85 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v133 == (905 - (250 + 655))) or ((2462 - 1559) >= (5344 - 2285))) then
				v90 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v87 = EpicSettings.Settings['InterruptWithStun'];
				v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v133 = 1957 - (1869 + 87);
			end
		end
	end
	local function v112()
		local v134 = 0 - 0;
		while true do
			if (((1901 - (484 + 1417)) == v134) or ((8522 - 4546) < (4787 - 1930))) then
				v110();
				v109();
				v111();
				v134 = 774 - (48 + 725);
			end
			if (((8053 - 3123) > (6189 - 3882)) and (v134 == (2 + 1))) then
				if (v91.TargetIsValid() or v14:AffectingCombat() or ((10812 - 6766) < (362 + 929))) then
					local v178 = 0 + 0;
					while true do
						if ((v178 == (854 - (152 + 701))) or ((5552 - (430 + 881)) == (1358 + 2187))) then
							if ((v97 == (12006 - (557 + 338))) or ((1197 + 2851) > (11925 - 7693))) then
								v97 = v10.FightRemains(v98, false);
							end
							break;
						end
						if ((v178 == (0 - 0)) or ((4649 - 2899) >= (7484 - 4011))) then
							v96 = v10.BossFightRemains(nil, true);
							v97 = v96;
							v178 = 802 - (499 + 302);
						end
					end
				end
				if (((4032 - (39 + 827)) == (8739 - 5573)) and not v14:IsChanneling()) then
					if (((3937 - 2174) < (14791 - 11067)) and v14:AffectingCombat()) then
						local v181 = 0 - 0;
						while true do
							if (((5 + 52) <= (7969 - 5246)) and (v181 == (0 + 0))) then
								v27 = v107();
								if (v27 or ((3275 - 1205) == (547 - (103 + 1)))) then
									return v27;
								end
								break;
							end
						end
					else
						v27 = v108();
						if (v27 or ((3259 - (475 + 79)) == (3011 - 1618))) then
							return v27;
						end
					end
				end
				break;
			end
			if ((v134 == (6 - 4)) or ((595 + 4006) < (54 + 7))) then
				if (v14:IsDeadOrGhost() or ((2893 - (1395 + 108)) >= (13804 - 9060))) then
					return;
				end
				if (v29 or ((3207 - (7 + 1197)) > (1672 + 2162))) then
					local v179 = 0 + 0;
					while true do
						if ((v179 == (319 - (27 + 292))) or ((456 - 300) > (4989 - 1076))) then
							v98 = v14:GetEnemiesInMeleeRange(33 - 25);
							v99 = #v98;
							break;
						end
					end
				else
					v99 = 1 - 0;
				end
				v100 = v15:IsInMeleeRange(9 - 4);
				v134 = 142 - (43 + 96);
			end
			if (((795 - 600) == (440 - 245)) and (v134 == (1 + 0))) then
				v28 = EpicSettings.Toggles['ooc'];
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				v134 = 1 + 1;
			end
		end
	end
	local function v113()
		v20.Print("Fury Warrior by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(141 - 69, v112, v113);
end;
return v0["Epix_Warrior_Fury.lua"]();

