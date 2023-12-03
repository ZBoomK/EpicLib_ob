local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1998 - (1339 + 659))) or ((2637 + 1023) <= (2776 - (530 + 181)))) then
			v6 = v0[v4];
			if (not v6 or ((4991 - (614 + 267)) > (4408 - (19 + 13)))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if ((v5 == (2 - 1)) or ((4656 - 3026) > (1091 + 3107))) then
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
	local v27 = 8 - 3;
	local v28;
	local v29 = false;
	local v30 = false;
	local v31 = false;
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
	local v92 = v20.Commons.Everyone;
	local v93 = v18.Warrior.Fury;
	local v94 = v19.Warrior.Fury;
	local v95 = v23.Warrior.Fury;
	local v96 = {};
	local v97 = 23042 - 11931;
	local v98 = 12923 - (1293 + 519);
	v10:RegisterForEvent(function()
		local v115 = 0 - 0;
		while true do
			if (((2751 - 1697) == (2015 - 961)) and (v115 == (0 - 0))) then
				v97 = 26174 - 15063;
				v98 = 5885 + 5226;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v99, v100;
	local v101;
	local function v102()
		local v116 = 0 + 0;
		local v117;
		while true do
			if ((v116 == (0 - 0)) or ((157 + 519) >= (546 + 1096))) then
				v117 = UnitGetTotalAbsorbs(v15);
				if (((2585 + 1551) > (3493 - (709 + 387))) and (v117 > (1858 - (673 + 1185)))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v103()
		if ((v93.BitterImmunity:IsReady() and v64 and (v14:HealthPercentage() <= v73)) or ((12568 - 8234) == (13631 - 9386))) then
			if (v24(v93.BitterImmunity) or ((7035 - 2759) <= (2168 + 863))) then
				return "bitter_immunity defensive";
			end
		end
		if ((v93.EnragedRegeneration:IsCastable() and v65 and (v14:HealthPercentage() <= v74)) or ((3574 + 1208) <= (1618 - 419))) then
			if (v24(v93.EnragedRegeneration) or ((1195 + 3669) < (3791 - 1889))) then
				return "enraged_regeneration defensive";
			end
		end
		if (((9498 - 4659) >= (5580 - (446 + 1434))) and v93.IgnorePain:IsCastable() and v66 and (v14:HealthPercentage() <= v75)) then
			if (v24(v93.IgnorePain, nil, nil, true) or ((2358 - (1040 + 243)) > (5724 - 3806))) then
				return "ignore_pain defensive";
			end
		end
		if (((2243 - (559 + 1288)) <= (5735 - (609 + 1322))) and v93.RallyingCry:IsCastable() and v67 and v14:BuffDown(v93.AspectsFavorBuff) and v14:BuffDown(v93.RallyingCry) and (((v14:HealthPercentage() <= v76) and v92.IsSoloMode()) or v92.AreUnitsBelowHealthPercentage(v76, v77))) then
			if (v24(v93.RallyingCry) or ((4623 - (13 + 441)) == (8172 - 5985))) then
				return "rallying_cry defensive";
			end
		end
		if (((3682 - 2276) == (7002 - 5596)) and v93.Intervene:IsCastable() and v68 and (v17:HealthPercentage() <= v78) and (v17:UnitName() ~= v14:UnitName())) then
			if (((58 + 1473) < (15511 - 11240)) and v24(v95.InterveneFocus)) then
				return "intervene defensive";
			end
		end
		if (((226 + 409) == (279 + 356)) and v93.DefensiveStance:IsCastable() and v69 and (v14:HealthPercentage() <= v79) and v14:BuffDown(v93.DefensiveStance, true)) then
			if (((10009 - 6636) <= (1946 + 1610)) and v24(v93.DefensiveStance)) then
				return "defensive_stance defensive";
			end
		end
		if ((v93.BerserkerStance:IsCastable() and v69 and (v14:HealthPercentage() > v82) and v14:BuffDown(v93.BerserkerStance, true)) or ((6052 - 2761) < (2169 + 1111))) then
			if (((2440 + 1946) >= (628 + 245)) and v24(v93.BerserkerStance)) then
				return "berserker_stance after defensive stance defensive";
			end
		end
		if (((774 + 147) <= (1079 + 23)) and v94.Healthstone:IsReady() and v70 and (v14:HealthPercentage() <= v80)) then
			if (((5139 - (153 + 280)) >= (2780 - 1817)) and v24(v95.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if ((v71 and (v14:HealthPercentage() <= v81)) or ((862 + 98) <= (346 + 530))) then
			if ((v87 == "Refreshing Healing Potion") or ((1082 + 984) == (846 + 86))) then
				if (((3497 + 1328) < (7374 - 2531)) and v94.RefreshingHealingPotion:IsReady()) then
					if (v24(v95.RefreshingHealingPotion) or ((2397 + 1480) >= (5204 - (89 + 578)))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if ((v87 == "Dreamwalker's Healing Potion") or ((3083 + 1232) < (3587 - 1861))) then
				if (v94.DreamwalkersHealingPotion:IsReady() or ((4728 - (572 + 477)) < (85 + 540))) then
					if (v24(v95.RefreshingHealingPotion) or ((2776 + 1849) < (76 + 556))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v104()
		v28 = v92.HandleTopTrinket(v96, v31, 126 - (84 + 2), nil);
		if (v28 or ((136 - 53) > (1283 + 497))) then
			return v28;
		end
		v28 = v92.HandleBottomTrinket(v96, v31, 882 - (497 + 345), nil);
		if (((14 + 532) <= (183 + 894)) and v28) then
			return v28;
		end
	end
	local function v105()
		local v118 = 1333 - (605 + 728);
		while true do
			if ((v118 == (1 + 0)) or ((2214 - 1218) > (198 + 4103))) then
				if (((15047 - 10977) > (620 + 67)) and v93.Bloodthirst:IsCastable() and v35 and v101) then
					if (v24(v93.Bloodthirst, not v101) or ((1817 - 1161) >= (2515 + 815))) then
						return "bloodthirst precombat 10";
					end
				end
				if ((v36 and v93.Charge:IsReady() and not v101) or ((2981 - (457 + 32)) <= (143 + 192))) then
					if (((5724 - (832 + 570)) >= (2414 + 148)) and v24(v93.Charge, not v15:IsSpellInRange(v93.Charge))) then
						return "charge precombat 12";
					end
				end
				break;
			end
			if ((v118 == (0 + 0)) or ((12870 - 9233) >= (1817 + 1953))) then
				if ((v32 and ((v53 and v31) or not v53) and (v91 < v98) and v93.Avatar:IsCastable() and not v93.TitansTorment:IsAvailable()) or ((3175 - (588 + 208)) > (12338 - 7760))) then
					if (v24(v93.Avatar, not v101) or ((2283 - (884 + 916)) > (1555 - 812))) then
						return "avatar precombat 6";
					end
				end
				if (((1423 + 1031) > (1231 - (232 + 421))) and v45 and ((v56 and v31) or not v56) and (v91 < v98) and v93.Recklessness:IsCastable() and not v93.RecklessAbandon:IsAvailable()) then
					if (((2819 - (1569 + 320)) < (1094 + 3364)) and v24(v93.Recklessness, not v101)) then
						return "recklessness precombat 8";
					end
				end
				v118 = 1 + 0;
			end
		end
	end
	local function v106()
		if (((2230 - 1568) <= (1577 - (316 + 289))) and v93.Whirlwind:IsCastable() and v49 and (v100 > (2 - 1)) and v93.ImprovedWhilwind:IsAvailable() and v14:BuffDown(v93.MeatCleaverBuff)) then
			if (((202 + 4168) == (5823 - (666 + 787))) and v24(v93.Whirlwind, not v15:IsInMeleeRange(v27))) then
				return "whirlwind single_target 2";
			end
		end
		if ((v93.Execute:IsReady() and v38 and v14:BuffUp(v93.AshenJuggernautBuff) and (v14:BuffRemains(v93.AshenJuggernautBuff) < v14:GCD())) or ((5187 - (360 + 65)) <= (805 + 56))) then
			if (v24(v93.Execute, not v101) or ((1666 - (79 + 175)) == (6722 - 2458))) then
				return "execute single_target 4";
			end
		end
		if ((v40 and ((v54 and v31) or not v54) and v93.OdynsFury:IsCastable() and (v91 < v98) and v14:BuffUp(v93.EnrageBuff) and ((v93.DancingBlades:IsAvailable() and (v14:BuffRemains(v93.DancingBladesBuff) < (4 + 1))) or not v93.DancingBlades:IsAvailable())) or ((9710 - 6542) < (4146 - 1993))) then
			if (v24(v93.OdynsFury, not v15:IsInMeleeRange(v27)) or ((5875 - (503 + 396)) < (1513 - (92 + 89)))) then
				return "odyns_fury single_target 6";
			end
		end
		if (((8977 - 4349) == (2374 + 2254)) and v93.Rampage:IsReady() and v43 and v93.AngerManagement:IsAvailable() and (v14:BuffUp(v93.RecklessnessBuff) or (v14:BuffRemains(v93.EnrageBuff) < v14:GCD()) or (v14:RagePercentage() > (51 + 34)))) then
			if (v24(v93.Rampage, not v101) or ((211 - 157) == (55 + 340))) then
				return "rampage single_target 8";
			end
		end
		local v119 = v14:CritChancePct() + (v25(v14:BuffUp(v93.RecklessnessBuff)) * (45 - 25)) + (v14:BuffStack(v93.MercilessAssaultBuff) * (9 + 1)) + (v14:BuffStack(v93.BloodcrazeBuff) * (8 + 7));
		if (((249 - 167) == (11 + 71)) and ((v119 >= (144 - 49)) or (not v93.ColdSteelHotBlood:IsAvailable() and v14:HasTier(1274 - (485 + 759), 8 - 4)))) then
			local v128 = 1189 - (442 + 747);
			while true do
				if (((1135 - (832 + 303)) == v128) or ((1527 - (88 + 858)) < (86 + 196))) then
					if ((v93.Bloodbath:IsCastable() and v34) or ((3815 + 794) < (103 + 2392))) then
						if (((1941 - (766 + 23)) == (5687 - 4535)) and v24(v93.Bloodbath, not v101)) then
							return "bloodbath single_target 10";
						end
					end
					if (((2592 - 696) <= (9015 - 5593)) and v93.Bloodthirst:IsCastable() and v35) then
						if (v24(v93.Bloodthirst, not v101) or ((3360 - 2370) > (2693 - (1036 + 37)))) then
							return "bloodthirst single_target 12";
						end
					end
					break;
				end
			end
		end
		if ((v93.Bloodbath:IsCastable() and v34 and v14:HasTier(22 + 9, 3 - 1)) or ((690 + 187) > (6175 - (641 + 839)))) then
			if (((3604 - (910 + 3)) >= (4718 - 2867)) and v24(v93.Bloodbath, not v101)) then
				return "bloodbath single_target 14";
			end
		end
		if ((v48 and ((v58 and v31) or not v58) and (v91 < v98) and v93.ThunderousRoar:IsCastable() and v14:BuffUp(v93.EnrageBuff)) or ((4669 - (1466 + 218)) >= (2232 + 2624))) then
			if (((5424 - (556 + 592)) >= (425 + 770)) and v24(v93.ThunderousRoar, not v15:IsInMeleeRange(v27))) then
				return "thunderous_roar single_target 16";
			end
		end
		if (((4040 - (329 + 479)) <= (5544 - (174 + 680))) and v93.Onslaught:IsReady() and v41 and (v14:BuffUp(v93.EnrageBuff) or v93.Tenderize:IsAvailable())) then
			if (v24(v93.Onslaught, not v101) or ((3078 - 2182) >= (6520 - 3374))) then
				return "onslaught single_target 18";
			end
		end
		if (((2186 + 875) >= (3697 - (396 + 343))) and v93.CrushingBlow:IsCastable() and v37 and v93.WrathandFury:IsAvailable() and v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.FuriousBloodthirstBuff)) then
			if (((282 + 2905) >= (2121 - (29 + 1448))) and v24(v93.CrushingBlow, not v101)) then
				return "crushing_blow single_target 20";
			end
		end
		if (((2033 - (135 + 1254)) <= (2651 - 1947)) and v93.Execute:IsReady() and v38 and ((v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.FuriousBloodthirstBuff) and v14:BuffUp(v93.AshenJuggernautBuff)) or ((v14:BuffRemains(v93.SuddenDeathBuff) <= v14:GCD()) and (((v15:HealthPercentage() > (163 - 128)) and v93.Massacre:IsAvailable()) or (v15:HealthPercentage() > (14 + 6)))))) then
			if (((2485 - (389 + 1138)) > (1521 - (102 + 472))) and v24(v93.Execute, not v101)) then
				return "execute single_target 22";
			end
		end
		if (((4240 + 252) >= (1472 + 1182)) and v93.Rampage:IsReady() and v43 and v93.RecklessAbandon:IsAvailable() and (v14:BuffUp(v93.RecklessnessBuff) or (v14:BuffRemains(v93.EnrageBuff) < v14:GCD()) or (v14:RagePercentage() > (80 + 5)))) then
			if (((4987 - (320 + 1225)) >= (2675 - 1172)) and v24(v93.Rampage, not v101)) then
				return "rampage single_target 24";
			end
		end
		if ((v93.Execute:IsReady() and v38 and v14:BuffUp(v93.EnrageBuff)) or ((1940 + 1230) <= (2928 - (157 + 1307)))) then
			if (v24(v93.Execute, not v101) or ((6656 - (821 + 1038)) == (10947 - 6559))) then
				return "execute single_target 26";
			end
		end
		if (((61 + 490) <= (1209 - 528)) and v93.Rampage:IsReady() and v43 and v93.AngerManagement:IsAvailable()) then
			if (((1220 + 2057) > (1008 - 601)) and v24(v93.Rampage, not v101)) then
				return "rampage single_target 28";
			end
		end
		if (((5721 - (834 + 192)) >= (90 + 1325)) and v93.Execute:IsReady() and v38) then
			if (v24(v93.Execute, not v101) or ((825 + 2387) <= (21 + 923))) then
				return "execute single_target 29";
			end
		end
		if ((v93.Bloodbath:IsCastable() and v34 and v14:BuffUp(v93.EnrageBuff) and v93.RecklessAbandon:IsAvailable() and not v93.WrathandFury:IsAvailable()) or ((4795 - 1699) <= (2102 - (300 + 4)))) then
			if (((945 + 2592) == (9258 - 5721)) and v24(v93.Bloodbath, not v101)) then
				return "bloodbath single_target 30";
			end
		end
		if (((4199 - (112 + 250)) >= (626 + 944)) and v93.Rampage:IsReady() and v43 and (v15:HealthPercentage() < (87 - 52)) and v93.Massacre:IsAvailable()) then
			if (v24(v93.Rampage, not v101) or ((1690 + 1260) == (1972 + 1840))) then
				return "rampage single_target 32";
			end
		end
		if (((3533 + 1190) >= (1150 + 1168)) and v93.Bloodthirst:IsCastable() and v35 and (not v14:BuffUp(v93.EnrageBuff) or (v93.Annihilator:IsAvailable() and v14:BuffDown(v93.RecklessnessBuff))) and v14:BuffDown(v93.FuriousBloodthirstBuff)) then
			if (v24(v93.Bloodthirst, not v101) or ((1506 + 521) > (4266 - (1001 + 413)))) then
				return "bloodthirst single_target 34";
			end
		end
		if ((v93.RagingBlow:IsCastable() and v42 and (v93.RagingBlow:Charges() > (2 - 1)) and v93.WrathandFury:IsAvailable()) or ((2018 - (244 + 638)) > (5010 - (627 + 66)))) then
			if (((14147 - 9399) == (5350 - (512 + 90))) and v24(v93.RagingBlow, not v101)) then
				return "raging_blow single_target 36";
			end
		end
		if (((5642 - (1665 + 241)) <= (5457 - (373 + 344))) and v93.CrushingBlow:IsCastable() and v37 and (v93.CrushingBlow:Charges() > (1 + 0)) and v93.WrathandFury:IsAvailable() and v14:BuffDown(v93.FuriousBloodthirstBuff)) then
			if (v24(v93.CrushingBlow, not v101) or ((897 + 2493) <= (8071 - 5011))) then
				return "crushing_blow single_target 38";
			end
		end
		if ((v93.Bloodbath:IsCastable() and v34 and (not v14:BuffUp(v93.EnrageBuff) or not v93.WrathandFury:IsAvailable())) or ((1690 - 691) > (3792 - (35 + 1064)))) then
			if (((337 + 126) < (1285 - 684)) and v24(v93.Bloodbath, not v101)) then
				return "bloodbath single_target 40";
			end
		end
		if ((v93.CrushingBlow:IsCastable() and v37 and v14:BuffUp(v93.EnrageBuff) and v93.RecklessAbandon:IsAvailable() and v14:BuffDown(v93.FuriousBloodthirstBuff)) or ((9 + 2174) < (1923 - (298 + 938)))) then
			if (((5808 - (233 + 1026)) == (6215 - (636 + 1030))) and v24(v93.CrushingBlow, not v101)) then
				return "crushing_blow single_target 42";
			end
		end
		if (((2389 + 2283) == (4564 + 108)) and v93.Bloodthirst:IsCastable() and v35 and not v93.WrathandFury:IsAvailable() and v14:BuffDown(v93.FuriousBloodthirstBuff)) then
			if (v24(v93.Bloodthirst, not v101) or ((1090 + 2578) < (27 + 368))) then
				return "bloodthirst single_target 44";
			end
		end
		if ((v93.RagingBlow:IsCastable() and v42 and (v93.RagingBlow:Charges() > (222 - (55 + 166)))) or ((808 + 3358) == (46 + 409))) then
			if (v24(v93.RagingBlow, not v101) or ((16990 - 12541) == (2960 - (36 + 261)))) then
				return "raging_blow single_target 46";
			end
		end
		if ((v93.Rampage:IsReady() and v43) or ((7479 - 3202) < (4357 - (34 + 1334)))) then
			if (v24(v93.Rampage, not v101) or ((335 + 535) >= (3224 + 925))) then
				return "rampage single_target 47";
			end
		end
		if (((3495 - (1035 + 248)) < (3204 - (20 + 1))) and v93.Slam:IsReady() and v46 and (v93.Annihilator:IsAvailable())) then
			if (((2421 + 2225) > (3311 - (134 + 185))) and v24(v93.Slam, not v101)) then
				return "slam single_target 48";
			end
		end
		if (((2567 - (549 + 584)) < (3791 - (314 + 371))) and v93.Bloodbath:IsCastable() and v34) then
			if (((2698 - 1912) < (3991 - (478 + 490))) and v24(v93.Bloodbath, not v101)) then
				return "bloodbath single_target 50";
			end
		end
		if ((v93.RagingBlow:IsCastable() and v42) or ((1294 + 1148) < (1246 - (786 + 386)))) then
			if (((14688 - 10153) == (5914 - (1055 + 324))) and v24(v93.RagingBlow, not v101)) then
				return "raging_blow single_target 52";
			end
		end
		if ((v93.CrushingBlow:IsCastable() and v37 and v14:BuffDown(v93.FuriousBloodthirstBuff)) or ((4349 - (1093 + 247)) <= (1871 + 234))) then
			if (((193 + 1637) < (14566 - 10897)) and v24(v93.CrushingBlow, not v101)) then
				return "crushing_blow single_target 54";
			end
		end
		if ((v93.Bloodthirst:IsCastable() and v35) or ((4853 - 3423) >= (10277 - 6665))) then
			if (((6741 - 4058) >= (876 + 1584)) and v24(v93.Bloodthirst, not v101)) then
				return "bloodthirst single_target 56";
			end
		end
		if ((v30 and v93.Whirlwind:IsCastable() and v49) or ((6949 - 5145) >= (11288 - 8013))) then
			if (v24(v93.Whirlwind, not v15:IsInMeleeRange(v27)) or ((1069 + 348) > (9280 - 5651))) then
				return "whirlwind single_target 58";
			end
		end
	end
	local function v107()
		local v120 = 688 - (364 + 324);
		local v121;
		while true do
			if (((13144 - 8349) > (964 - 562)) and (v120 == (2 + 4))) then
				if (((20138 - 15325) > (5709 - 2144)) and v93.Bloodbath:IsCastable() and v34 and (not v14:BuffUp(v93.EnrageBuff) or not v93.WrathandFury:IsAvailable())) then
					if (((11881 - 7969) == (5180 - (1249 + 19))) and v24(v93.Bloodbath, not v101)) then
						return "bloodbath multi_target 34";
					end
				end
				if (((2547 + 274) <= (18777 - 13953)) and v93.CrushingBlow:IsCastable() and v37 and v14:BuffUp(v93.EnrageBuff) and v93.RecklessAbandon:IsAvailable()) then
					if (((2824 - (686 + 400)) <= (1723 + 472)) and v24(v93.CrushingBlow, not v101)) then
						return "crushing_blow multi_target 36";
					end
				end
				if (((270 - (73 + 156)) <= (15 + 3003)) and v93.Bloodthirst:IsCastable() and v35 and not v93.WrathandFury:IsAvailable()) then
					if (((2956 - (721 + 90)) <= (47 + 4057)) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst multi_target 38";
					end
				end
				v120 = 22 - 15;
			end
			if (((3159 - (224 + 246)) < (7848 - 3003)) and (v120 == (14 - 6))) then
				if ((v93.Bloodbath:IsCastable() and v34) or ((422 + 1900) > (63 + 2559))) then
					if (v24(v93.Bloodbath, not v101) or ((3331 + 1203) == (4138 - 2056))) then
						return "bloodbath multi_target 46";
					end
				end
				if ((v93.RagingBlow:IsCastable() and v42) or ((5227 - 3656) > (2380 - (203 + 310)))) then
					if (v24(v93.RagingBlow, not v101) or ((4647 - (1238 + 755)) >= (210 + 2786))) then
						return "raging_blow multi_target 48";
					end
				end
				if (((5512 - (709 + 825)) > (3877 - 1773)) and v93.CrushingBlow:IsCastable() and v37) then
					if (((4362 - 1367) > (2405 - (196 + 668))) and v24(v93.CrushingBlow, not v101)) then
						return "crushing_blow multi_target 50";
					end
				end
				v120 = 35 - 26;
			end
			if (((6729 - 3480) > (1786 - (171 + 662))) and ((97 - (4 + 89)) == v120)) then
				if ((v93.Execute:IsReady() and v38) or ((11471 - 8198) > (1666 + 2907))) then
					if (v24(v93.Execute, not v101) or ((13839 - 10688) < (504 + 780))) then
						return "execute multi_target 22";
					end
				end
				if ((v93.Bloodbath:IsCastable() and v34 and v14:BuffUp(v93.EnrageBuff) and v93.RecklessAbandon:IsAvailable() and not v93.WrathandFury:IsAvailable()) or ((3336 - (35 + 1451)) == (2982 - (28 + 1425)))) then
					if (((2814 - (941 + 1052)) < (2036 + 87)) and v24(v93.Bloodbath, not v101)) then
						return "bloodbath multi_target 24";
					end
				end
				if (((2416 - (822 + 692)) < (3318 - 993)) and v93.Bloodthirst:IsCastable() and v35 and (not v14:BuffUp(v93.EnrageBuff) or (v93.Annihilator:IsAvailable() and v14:BuffDown(v93.RecklessnessBuff)))) then
					if (((405 + 453) <= (3259 - (45 + 252))) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst multi_target 26";
					end
				end
				v120 = 5 + 0;
			end
			if ((v120 == (1 + 0)) or ((9603 - 5657) < (1721 - (114 + 319)))) then
				if ((v93.Execute:IsReady() and v38 and v14:BuffUp(v93.AshenJuggernautBuff) and (v14:BuffRemains(v93.AshenJuggernautBuff) < v14:GCD())) or ((4654 - 1412) == (726 - 159))) then
					if (v24(v93.Execute, not v101) or ((540 + 307) >= (1881 - 618))) then
						return "execute multi_target 8";
					end
				end
				if ((v93.ThunderousRoar:IsCastable() and ((v58 and v31) or not v58) and v48 and (v91 < v98) and v14:BuffUp(v93.EnrageBuff)) or ((4720 - 2467) == (3814 - (556 + 1407)))) then
					if (v24(v93.ThunderousRoar, not v15:IsInMeleeRange(v27)) or ((3293 - (741 + 465)) > (2837 - (170 + 295)))) then
						return "thunderous_roar multi_target 10";
					end
				end
				if ((v93.OdynsFury:IsCastable() and ((v54 and v31) or not v54) and v40 and (v91 < v98) and (v100 > (1 + 0)) and v14:BuffUp(v93.EnrageBuff)) or ((4083 + 362) < (10214 - 6065))) then
					if (v24(v93.OdynsFury, not v15:IsInMeleeRange(v27)) or ((1508 + 310) == (55 + 30))) then
						return "odyns_fury multi_target 12";
					end
				end
				v120 = 2 + 0;
			end
			if (((1860 - (957 + 273)) < (569 + 1558)) and ((3 + 2) == v120)) then
				if ((v93.Onslaught:IsReady() and v41 and ((not v93.Annihilator:IsAvailable() and v14:BuffUp(v93.EnrageBuff)) or v93.Tenderize:IsAvailable())) or ((7384 - 5446) == (6624 - 4110))) then
					if (((12996 - 8741) >= (272 - 217)) and v24(v93.Onslaught, not v101)) then
						return "onslaught multi_target 28";
					end
				end
				if (((4779 - (389 + 1391)) > (726 + 430)) and v93.RagingBlow:IsCastable() and v42 and (v93.RagingBlow:Charges() > (1 + 0)) and v93.WrathandFury:IsAvailable()) then
					if (((5350 - 3000) > (2106 - (783 + 168))) and v24(v93.RagingBlow, not v101)) then
						return "raging_blow multi_target 30";
					end
				end
				if (((13521 - 9492) <= (4774 + 79)) and v93.CrushingBlow:IsCastable() and v37 and (v93.CrushingBlow:Charges() > (312 - (309 + 2))) and v93.WrathandFury:IsAvailable()) then
					if (v24(v93.CrushingBlow, not v101) or ((1584 - 1068) > (4646 - (1090 + 122)))) then
						return "crushing_blow multi_target 32";
					end
				end
				v120 = 2 + 4;
			end
			if (((13588 - 9542) >= (2076 + 957)) and (v120 == (1125 - (628 + 490)))) then
				if ((v93.RagingBlow:IsCastable() and v42 and (v93.RagingBlow:Charges() > (1 + 0))) or ((6731 - 4012) <= (6612 - 5165))) then
					if (v24(v93.RagingBlow, not v101) or ((4908 - (431 + 343)) < (7928 - 4002))) then
						return "raging_blow multi_target 40";
					end
				end
				if ((v93.Rampage:IsReady() and v43) or ((474 - 310) >= (2201 + 584))) then
					if (v24(v93.Rampage, not v101) or ((68 + 457) == (3804 - (556 + 1139)))) then
						return "rampage multi_target 42";
					end
				end
				if (((48 - (6 + 9)) == (7 + 26)) and v93.Slam:IsReady() and v46 and (v93.Annihilator:IsAvailable())) then
					if (((1565 + 1489) <= (4184 - (28 + 141))) and v24(v93.Slam, not v101)) then
						return "slam multi_target 44";
					end
				end
				v120 = 4 + 4;
			end
			if (((2309 - 438) < (2396 + 986)) and ((1326 - (486 + 831)) == v120)) then
				if (((3364 - 2071) <= (7625 - 5459)) and v93.Whirlwind:IsCastable() and v49) then
					if (v24(v93.Whirlwind, not v15:IsInMeleeRange(v27)) or ((488 + 2091) < (388 - 265))) then
						return "whirlwind multi_target 52";
					end
				end
				break;
			end
			if ((v120 == (1266 - (668 + 595))) or ((762 + 84) >= (478 + 1890))) then
				if ((v93.Execute:IsReady() and v38 and v14:BuffUp(v93.EnrageBuff)) or ((10941 - 6929) <= (3648 - (23 + 267)))) then
					if (((3438 - (1129 + 815)) <= (3392 - (371 + 16))) and v24(v93.Execute, not v101)) then
						return "execute multi_target 16";
					end
				end
				if ((v93.OdynsFury:IsCastable() and ((v54 and v31) or not v54) and v40 and (v91 < v98) and v14:BuffUp(v93.EnrageBuff)) or ((4861 - (1326 + 424)) == (4041 - 1907))) then
					if (((8605 - 6250) == (2473 - (88 + 30))) and v24(v93.OdynsFury, not v15:IsInMeleeRange(v27))) then
						return "odyns_fury multi_target 18";
					end
				end
				if ((v93.Rampage:IsReady() and v43 and (v14:BuffUp(v93.RecklessnessBuff) or (v14:BuffRemains(v93.EnrageBuff) < v14:GCD()) or ((v14:Rage() > (881 - (720 + 51))) and v93.OverwhelmingRage:IsAvailable()) or ((v14:Rage() > (177 - 97)) and not v93.OverwhelmingRage:IsAvailable()))) or ((2364 - (421 + 1355)) <= (711 - 279))) then
					if (((2357 + 2440) >= (4978 - (286 + 797))) and v24(v93.Rampage, not v101)) then
						return "rampage multi_target 20";
					end
				end
				v120 = 14 - 10;
			end
			if (((5924 - 2347) == (4016 - (397 + 42))) and (v120 == (1 + 1))) then
				v121 = v14:CritChancePct() + (v25(v14:BuffUp(v93.RecklessnessBuff)) * (820 - (24 + 776))) + (v14:BuffStack(v93.MercilessAssaultBuff) * (15 - 5)) + (v14:BuffStack(v93.BloodcrazeBuff) * (800 - (222 + 563)));
				if (((8359 - 4565) > (2659 + 1034)) and (v121 >= (285 - (23 + 167))) and v14:HasTier(1828 - (690 + 1108), 2 + 2)) then
					local v177 = 0 + 0;
					while true do
						if ((v177 == (848 - (40 + 808))) or ((210 + 1065) == (15678 - 11578))) then
							if ((v93.Bloodbath:IsCastable() and v34) or ((1521 + 70) >= (1894 + 1686))) then
								if (((540 + 443) <= (2379 - (47 + 524))) and v24(v93.Bloodbath, not v101)) then
									return "bloodbath multi_target 14";
								end
							end
							if ((v93.Bloodthirst:IsCastable() and v35) or ((1396 + 754) <= (3271 - 2074))) then
								if (((5635 - 1866) >= (2674 - 1501)) and v24(v93.Bloodthirst, not v101)) then
									return "bloodthirst multi_target 16";
								end
							end
							break;
						end
					end
				end
				if (((3211 - (1165 + 561)) == (45 + 1440)) and v93.CrushingBlow:IsCastable() and v93.WrathandFury:IsAvailable() and v37 and v14:BuffUp(v93.EnrageBuff)) then
					if (v24(v93.CrushingBlow, not v101) or ((10267 - 6952) <= (1062 + 1720))) then
						return "crushing_blow multi_target 14";
					end
				end
				v120 = 482 - (341 + 138);
			end
			if ((v120 == (0 + 0)) or ((1807 - 931) >= (3290 - (89 + 237)))) then
				if ((v93.Recklessness:IsCastable() and ((v56 and v31) or not v56) and v45 and (v91 < v98) and ((v100 > (3 - 2)) or (v98 < (24 - 12)))) or ((3113 - (581 + 300)) > (3717 - (855 + 365)))) then
					if (v24(v93.Recklessness, not v101) or ((5011 - 2901) <= (109 + 223))) then
						return "recklessness multi_target 2";
					end
				end
				if (((4921 - (1030 + 205)) > (2978 + 194)) and v93.OdynsFury:IsCastable() and ((v54 and v31) or not v54) and v40 and (v91 < v98) and (v100 > (1 + 0)) and v93.TitanicRage:IsAvailable() and (v14:BuffDown(v93.MeatCleaverBuff) or v14:BuffUp(v93.AvatarBuff) or v14:BuffUp(v93.RecklessnessBuff))) then
					if (v24(v93.OdynsFury, not v15:IsInMeleeRange(v27)) or ((4760 - (156 + 130)) < (1863 - 1043))) then
						return "odyns_fury multi_target 4";
					end
				end
				if (((7211 - 2932) >= (5902 - 3020)) and v93.Whirlwind:IsCastable() and v49 and (v100 > (1 + 0)) and v93.ImprovedWhilwind:IsAvailable() and v14:BuffDown(v93.MeatCleaverBuff)) then
					if (v24(v93.Whirlwind, not v15:IsInMeleeRange(v27)) or ((1184 + 845) >= (3590 - (10 + 59)))) then
						return "whirlwind multi_target 6";
					end
				end
				v120 = 1 + 0;
			end
		end
	end
	local function v108()
		local v122 = 0 - 0;
		while true do
			if ((v122 == (1164 - (671 + 492))) or ((1622 + 415) >= (5857 - (369 + 846)))) then
				if (((456 + 1264) < (3805 + 653)) and v86) then
					local v178 = 1945 - (1036 + 909);
					while true do
						if ((v178 == (1 + 0)) or ((731 - 295) > (3224 - (11 + 192)))) then
							v28 = v92.HandleIncorporeal(v93.IntimidatingShout, v95.IntimidatingShoutMouseover, 5 + 3, true);
							if (((888 - (135 + 40)) <= (2052 - 1205)) and v28) then
								return v28;
							end
							break;
						end
						if (((1299 + 855) <= (8880 - 4849)) and (v178 == (0 - 0))) then
							v28 = v92.HandleIncorporeal(v93.StormBolt, v95.StormBoltMouseover, 196 - (50 + 126), true);
							if (((12850 - 8235) == (1022 + 3593)) and v28) then
								return v28;
							end
							v178 = 1414 - (1233 + 180);
						end
					end
				end
				if (v92.TargetIsValid() or ((4759 - (522 + 447)) == (1921 - (107 + 1314)))) then
					if (((42 + 47) < (673 - 452)) and v36 and v93.Charge:IsCastable()) then
						if (((873 + 1181) >= (2821 - 1400)) and v24(v93.Charge, not v15:IsSpellInRange(v93.Charge))) then
							return "charge main 2";
						end
					end
					local v179 = v92.HandleDPSPotion(v15:BuffUp(v93.RecklessnessBuff));
					if (((2737 - 2045) < (4968 - (716 + 1194))) and v179) then
						return v179;
					end
					if ((v91 < v98) or ((56 + 3198) == (178 + 1477))) then
						if ((v52 and ((v31 and v60) or not v60)) or ((1799 - (74 + 429)) == (9471 - 4561))) then
							local v184 = 0 + 0;
							while true do
								if (((7709 - 4341) == (2383 + 985)) and (v184 == (0 - 0))) then
									v28 = v104();
									if (((6534 - 3891) < (4248 - (279 + 154))) and v28) then
										return v28;
									end
									break;
								end
							end
						end
					end
					if (((2691 - (454 + 324)) > (388 + 105)) and (v91 < v98) and v51 and ((v59 and v31) or not v59)) then
						if (((4772 - (12 + 5)) > (1849 + 1579)) and v93.BloodFury:IsCastable()) then
							if (((3518 - 2137) <= (876 + 1493)) and v24(v93.BloodFury, not v101)) then
								return "blood_fury main 12";
							end
						end
						if ((v93.Berserking:IsCastable() and v14:BuffUp(v93.RecklessnessBuff)) or ((5936 - (277 + 816)) == (17451 - 13367))) then
							if (((5852 - (1058 + 125)) > (69 + 294)) and v24(v93.Berserking, not v101)) then
								return "berserking main 14";
							end
						end
						if ((v93.LightsJudgment:IsCastable() and v14:BuffDown(v93.RecklessnessBuff)) or ((2852 - (815 + 160)) >= (13463 - 10325))) then
							if (((11256 - 6514) >= (865 + 2761)) and v24(v93.LightsJudgment, not v15:IsSpellInRange(v93.LightsJudgment))) then
								return "lights_judgment main 16";
							end
						end
						if (v93.Fireblood:IsCastable() or ((13271 - 8731) == (2814 - (41 + 1857)))) then
							if (v24(v93.Fireblood, not v101) or ((3049 - (1222 + 671)) > (11229 - 6884))) then
								return "fireblood main 18";
							end
						end
						if (((3215 - 978) < (5431 - (229 + 953))) and v93.AncestralCall:IsCastable()) then
							if (v24(v93.AncestralCall, not v101) or ((4457 - (1111 + 663)) < (1602 - (874 + 705)))) then
								return "ancestral_call main 20";
							end
						end
						if (((98 + 599) <= (564 + 262)) and v93.BagofTricks:IsCastable() and v14:BuffDown(v93.RecklessnessBuff) and v14:BuffUp(v93.EnrageBuff)) then
							if (((2296 - 1191) <= (34 + 1142)) and v22(v93.BagofTricks, not v15:IsSpellInRange(v93.BagofTricks))) then
								return "bag_of_tricks main 22";
							end
						end
					end
					if (((4058 - (642 + 37)) <= (870 + 2942)) and (v91 < v98)) then
						local v180 = 0 + 0;
						while true do
							if ((v180 == (2 - 1)) or ((1242 - (233 + 221)) >= (3736 - 2120))) then
								if (((1632 + 222) <= (4920 - (718 + 823))) and v93.Recklessness:IsCastable() and v45 and ((v56 and v31) or not v56) and (not v93.Annihilator:IsAvailable() or (v10.FightRemains() < (8 + 4)))) then
									if (((5354 - (266 + 539)) == (12878 - 8329)) and v24(v93.Recklessness, not v101)) then
										return "recklessness main 27";
									end
								end
								if ((v93.Ravager:IsCastable() and (v84 == "player") and v44 and ((v55 and v31) or not v55) and ((v93.Avatar:CooldownRemains() < (1228 - (636 + 589))) or v14:BuffUp(v93.RecklessnessBuff) or (v98 < (23 - 13)))) or ((6232 - 3210) >= (2397 + 627))) then
									if (((1752 + 3068) > (3213 - (657 + 358))) and v24(v95.RavagerPlayer, not v101)) then
										return "ravager main 28";
									end
								end
								v180 = 4 - 2;
							end
							if ((v180 == (0 - 0)) or ((2248 - (1151 + 36)) >= (4724 + 167))) then
								if (((359 + 1005) <= (13358 - 8885)) and v93.Avatar:IsCastable() and v32 and ((v53 and v31) or not v53) and ((v93.TitansTorment:IsAvailable() and v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.AvatarBuff) and (v93.OdynsFury:CooldownRemains() > (1832 - (1552 + 280)))) or (v93.BerserkersTorment:IsAvailable() and v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.AvatarBuff)) or (not v93.TitansTorment:IsAvailable() and not v93.BerserkersTorment:IsAvailable() and (v14:BuffUp(v93.RecklessnessBuff) or (v98 < (854 - (64 + 770))))))) then
									if (v24(v93.Avatar, not v101) or ((2441 + 1154) <= (6 - 3))) then
										return "avatar main 24";
									end
								end
								if ((v93.Recklessness:IsCastable() and v45 and ((v56 and v31) or not v56) and ((v93.Annihilator:IsAvailable() and (v93.Avatar:CooldownRemains() < (1 + 0))) or (v93.Avatar:CooldownRemains() > (1283 - (157 + 1086))) or not v93.Avatar:IsAvailable() or (v98 < (23 - 11)))) or ((20462 - 15790) == (5908 - 2056))) then
									if (((2127 - 568) == (2378 - (599 + 220))) and v24(v93.Recklessness, not v101)) then
										return "recklessness main 26";
									end
								end
								v180 = 1 - 0;
							end
							if ((v180 == (1933 - (1813 + 118))) or ((1281 + 471) <= (2005 - (841 + 376)))) then
								if ((v93.Ravager:IsCastable() and (v84 == "cursor") and v44 and ((v55 and v31) or not v55) and ((v93.Avatar:CooldownRemains() < (3 - 0)) or v14:BuffUp(v93.RecklessnessBuff) or (v98 < (3 + 7)))) or ((10664 - 6757) == (1036 - (464 + 395)))) then
									if (((8905 - 5435) > (267 + 288)) and v24(v95.RavagerCursor, not v101)) then
										return "ravager main 28";
									end
								end
								if ((v93.SpearofBastion:IsCastable() and (v85 == "player") and v47 and ((v57 and v31) or not v57) and v14:BuffUp(v93.EnrageBuff) and (v14:BuffUp(v93.RecklessnessBuff) or v14:BuffUp(v93.AvatarBuff) or (v98 < (857 - (467 + 370))) or (v100 > (1 - 0)) or not v93.TitansTorment:IsAvailable() or not v14:HasTier(23 + 8, 6 - 4))) or ((152 + 820) == (1500 - 855))) then
									if (((3702 - (150 + 370)) >= (3397 - (74 + 1208))) and v24(v95.SpearOfBastionPlayer, not v101)) then
										return "spear_of_bastion main 30";
									end
								end
								v180 = 7 - 4;
							end
							if (((18462 - 14569) < (3152 + 1277)) and (v180 == (393 - (14 + 376)))) then
								if ((v93.SpearofBastion:IsCastable() and (v85 == "cursor") and v47 and ((v57 and v31) or not v57) and v14:BuffUp(v93.EnrageBuff) and (v14:BuffUp(v93.RecklessnessBuff) or v14:BuffUp(v93.AvatarBuff) or (v98 < (34 - 14)) or (v100 > (1 + 0)) or not v93.TitansTorment:IsAvailable() or not v14:HasTier(28 + 3, 2 + 0))) or ((8400 - 5533) < (1434 + 471))) then
									if (v24(v95.SpearOfBastionCursor, not v101) or ((1874 - (23 + 55)) >= (9600 - 5549))) then
										return "spear_of_bastion main 31";
									end
								end
								break;
							end
						end
					end
					if (((1081 + 538) <= (3373 + 383)) and v39 and v93.HeroicThrow:IsCastable() and not v15:IsInRange(46 - 16)) then
						if (((190 + 414) == (1505 - (652 + 249))) and v24(v93.HeroicThrow, not v15:IsInRange(80 - 50))) then
							return "heroic_throw main";
						end
					end
					if ((v93.WreckingThrow:IsCastable() and v50 and v15:AffectingCombat() and v102()) or ((6352 - (708 + 1160)) == (2442 - 1542))) then
						if (v24(v93.WreckingThrow, not v15:IsInRange(54 - 24)) or ((4486 - (10 + 17)) <= (250 + 863))) then
							return "wrecking_throw main";
						end
					end
					if (((5364 - (1400 + 332)) > (6517 - 3119)) and v30 and (v100 > (1910 - (242 + 1666)))) then
						local v181 = 0 + 0;
						while true do
							if (((1497 + 2585) <= (4191 + 726)) and (v181 == (940 - (850 + 90)))) then
								v28 = v107();
								if (((8462 - 3630) >= (2776 - (360 + 1030))) and v28) then
									return v28;
								end
								break;
							end
						end
					end
					v28 = v106();
					if (((122 + 15) == (386 - 249)) and v28) then
						return v28;
					end
					if (v20.CastAnnotated(v93.Pool, false, "WAIT") or ((2160 - 590) >= (5993 - (909 + 752)))) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if ((v122 == (1223 - (109 + 1114))) or ((7440 - 3376) <= (709 + 1110))) then
				v28 = v103();
				if (v28 or ((5228 - (6 + 236)) < (992 + 582))) then
					return v28;
				end
				v122 = 1 + 0;
			end
		end
	end
	local function v109()
		if (((10437 - 6011) > (300 - 128)) and not v14:AffectingCombat()) then
			if (((1719 - (1076 + 57)) > (75 + 380)) and v93.BerserkerStance:IsCastable() and v14:BuffDown(v93.BerserkerStance, true)) then
				if (((1515 - (579 + 110)) == (66 + 760)) and v24(v93.BerserkerStance)) then
					return "berserker_stance";
				end
			end
			if ((v93.BattleShout:IsCastable() and v33 and (v14:BuffDown(v93.BattleShoutBuff, true) or v92.GroupBuffMissing(v93.BattleShoutBuff))) or ((3554 + 465) > (2357 + 2084))) then
				if (((2424 - (174 + 233)) < (11902 - 7641)) and v24(v93.BattleShout)) then
					return "battle_shout precombat";
				end
			end
		end
		if (((8277 - 3561) > (36 + 44)) and v92.TargetIsValid() and v29) then
			if (not v14:AffectingCombat() or ((4681 - (663 + 511)) == (2920 + 352))) then
				v28 = v105();
				if (v28 or ((191 + 685) >= (9480 - 6405))) then
					return v28;
				end
			end
		end
	end
	local function v110()
		local v123 = 0 + 0;
		while true do
			if (((10245 - 5893) > (6182 - 3628)) and ((3 + 3) == v123)) then
				v58 = EpicSettings.Settings['thunderousRoarWithCD'];
				break;
			end
			if ((v123 == (1 - 0)) or ((3141 + 1265) < (370 + 3673))) then
				v37 = EpicSettings.Settings['useCrushingBlow'];
				v38 = EpicSettings.Settings['useExecute'];
				v39 = EpicSettings.Settings['useHeroicThrow'];
				v41 = EpicSettings.Settings['useOnslaught'];
				v123 = 724 - (478 + 244);
			end
			if ((v123 == (522 - (440 + 77))) or ((859 + 1030) >= (12381 - 8998))) then
				v54 = EpicSettings.Settings['odynFuryWithCD'];
				v55 = EpicSettings.Settings['ravagerWithCD'];
				v56 = EpicSettings.Settings['recklessnessWithCD'];
				v57 = EpicSettings.Settings['spearOfBastionWithCD'];
				v123 = 1562 - (655 + 901);
			end
			if (((351 + 1541) <= (2094 + 640)) and ((2 + 0) == v123)) then
				v42 = EpicSettings.Settings['useRagingBlow'];
				v43 = EpicSettings.Settings['useRampage'];
				v46 = EpicSettings.Settings['useSlam'];
				v49 = EpicSettings.Settings['useWhirlwind'];
				v123 = 11 - 8;
			end
			if (((3368 - (695 + 750)) < (7573 - 5355)) and (v123 == (6 - 2))) then
				v45 = EpicSettings.Settings['useRecklessness'];
				v47 = EpicSettings.Settings['useSpearOfBastion'];
				v48 = EpicSettings.Settings['useThunderousRoar'];
				v53 = EpicSettings.Settings['avatarWithCD'];
				v123 = 20 - 15;
			end
			if (((2524 - (285 + 66)) > (883 - 504)) and ((1313 - (682 + 628)) == v123)) then
				v50 = EpicSettings.Settings['useWreckingThrow'];
				v32 = EpicSettings.Settings['useAvatar'];
				v40 = EpicSettings.Settings['useOdynsFury'];
				v44 = EpicSettings.Settings['useRavager'];
				v123 = 1 + 3;
			end
			if ((v123 == (299 - (176 + 123))) or ((1084 + 1507) == (2473 + 936))) then
				v33 = EpicSettings.Settings['useBattleShout'];
				v34 = EpicSettings.Settings['useBloodbath'];
				v35 = EpicSettings.Settings['useBloodthirst'];
				v36 = EpicSettings.Settings['useCharge'];
				v123 = 270 - (239 + 30);
			end
		end
	end
	local function v111()
		local v124 = 0 + 0;
		while true do
			if (((4339 + 175) > (5883 - 2559)) and (v124 == (2 - 1))) then
				v64 = EpicSettings.Settings['useBitterImmunity'];
				v65 = EpicSettings.Settings['useEnragedRegeneration'];
				v66 = EpicSettings.Settings['useIgnorePain'];
				v124 = 317 - (306 + 9);
			end
			if ((v124 == (17 - 12)) or ((37 + 171) >= (2963 + 1865))) then
				v78 = EpicSettings.Settings['interveneHP'] or (0 + 0);
				v79 = EpicSettings.Settings['defensiveStanceHP'] or (0 - 0);
				v82 = EpicSettings.Settings['unstanceHP'] or (1375 - (1140 + 235));
				v124 = 4 + 2;
			end
			if (((4 + 0) == v124) or ((407 + 1176) > (3619 - (33 + 19)))) then
				v75 = EpicSettings.Settings['ignorePainHP'] or (0 + 0);
				v76 = EpicSettings.Settings['rallyingCryHP'] or (0 - 0);
				v77 = EpicSettings.Settings['rallyingCryGroup'] or (0 + 0);
				v124 = 9 - 4;
			end
			if ((v124 == (0 + 0)) or ((2002 - (586 + 103)) == (73 + 721))) then
				v61 = EpicSettings.Settings['usePummel'];
				v62 = EpicSettings.Settings['useStormBolt'];
				v63 = EpicSettings.Settings['useIntimidatingShout'];
				v124 = 2 - 1;
			end
			if (((4662 - (1309 + 179)) > (5238 - 2336)) and ((3 + 3) == v124)) then
				v83 = EpicSettings.Settings['victoryRushHP'] or (0 - 0);
				v84 = EpicSettings.Settings['ravagerSetting'] or "player";
				v85 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
			if (((3112 + 1008) <= (9051 - 4791)) and (v124 == (3 - 1))) then
				v67 = EpicSettings.Settings['useRallyingCry'];
				v68 = EpicSettings.Settings['useIntervene'];
				v69 = EpicSettings.Settings['useDefensiveStance'];
				v124 = 612 - (295 + 314);
			end
			if ((v124 == (6 - 3)) or ((2845 - (1300 + 662)) > (15003 - 10225))) then
				v72 = EpicSettings.Settings['useVictoryRush'];
				v73 = EpicSettings.Settings['bitterImmunityHP'] or (1755 - (1178 + 577));
				v74 = EpicSettings.Settings['enragedRegenerationHP'] or (0 + 0);
				v124 = 11 - 7;
			end
		end
	end
	local function v112()
		local v125 = 1405 - (851 + 554);
		while true do
			if ((v125 == (0 + 0)) or ((10039 - 6419) >= (10622 - 5731))) then
				v91 = EpicSettings.Settings['fightRemainsCheck'] or (302 - (115 + 187));
				v88 = EpicSettings.Settings['InterruptWithStun'];
				v89 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v90 = EpicSettings.Settings['InterruptThreshold'];
				v125 = 1 + 0;
			end
			if (((4031 + 227) > (3692 - 2755)) and (v125 == (1163 - (160 + 1001)))) then
				v70 = EpicSettings.Settings['useHealthstone'];
				v71 = EpicSettings.Settings['useHealingPotion'];
				v80 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v81 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v125 = 5 - 2;
			end
			if ((v125 == (361 - (237 + 121))) or ((5766 - (525 + 372)) < (1717 - 811))) then
				v87 = EpicSettings.Settings['HealingPotionName'] or "";
				v86 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v125 == (3 - 2)) or ((1367 - (96 + 46)) > (5005 - (643 + 134)))) then
				v52 = EpicSettings.Settings['useTrinkets'];
				v51 = EpicSettings.Settings['useRacials'];
				v60 = EpicSettings.Settings['trinketsWithCD'];
				v59 = EpicSettings.Settings['racialsWithCD'];
				v125 = 1 + 1;
			end
		end
	end
	local function v113()
		local v126 = 0 - 0;
		while true do
			if (((12355 - 9027) > (2147 + 91)) and (v126 == (0 - 0))) then
				v111();
				v110();
				v112();
				v126 = 1 - 0;
			end
			if (((4558 - (316 + 403)) > (934 + 471)) and (v126 == (8 - 5))) then
				v101 = v15:IsInMeleeRange(2 + 3);
				if (v92.TargetIsValid() or v14:AffectingCombat() or ((3256 - 1963) <= (360 + 147))) then
					v97 = v10.BossFightRemains(nil, true);
					v98 = v97;
					if ((v98 == (3581 + 7530)) or ((10034 - 7138) < (3844 - 3039))) then
						v98 = v10.FightRemains(v99, false);
					end
				end
				if (((4811 - 2495) == (133 + 2183)) and not v14:IsChanneling()) then
					if (v14:AffectingCombat() or ((5059 - 2489) == (75 + 1458))) then
						local v182 = 0 - 0;
						while true do
							if ((v182 == (17 - (12 + 5))) or ((3429 - 2546) == (3115 - 1655))) then
								v28 = v108();
								if (v28 or ((9818 - 5199) <= (2477 - 1478))) then
									return v28;
								end
								break;
							end
						end
					else
						local v183 = 0 + 0;
						while true do
							if ((v183 == (1973 - (1656 + 317))) or ((3039 + 371) > (3299 + 817))) then
								v28 = v109();
								if (v28 or ((2400 - 1497) >= (15054 - 11995))) then
									return v28;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v126 == (355 - (5 + 349))) or ((18885 - 14909) < (4128 - (266 + 1005)))) then
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v126 = 2 + 0;
			end
			if (((16821 - 11891) > (3036 - 729)) and (v126 == (1698 - (561 + 1135)))) then
				if (v14:IsDeadOrGhost() or ((5271 - 1225) < (4243 - 2952))) then
					return;
				end
				if (v93.IntimidatingShout:IsAvailable() or ((5307 - (507 + 559)) == (8895 - 5350))) then
					v27 = 24 - 16;
				end
				if (v30 or ((4436 - (212 + 176)) > (5137 - (250 + 655)))) then
					v99 = v14:GetEnemiesInMeleeRange(v27);
					v100 = #v99;
				else
					v100 = 2 - 1;
				end
				v126 = 5 - 2;
			end
		end
	end
	local function v114()
		v20.Print("Fury Warrior by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(112 - 40, v113, v114);
end;
return v0["Epix_Warrior_Fury.lua"]();

