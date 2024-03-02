local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (3 - 2)) or ((118 + 214) >= (1755 + 2248))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((1801 + 1490) <= (6032 - 2752))) then
			v6 = v0[v4];
			if (((2900 + 1486) >= (486 + 387)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
	local v91;
	local v92 = v20.Commons.Everyone;
	local v93 = v18.Warrior.Fury;
	local v94 = v19.Warrior.Fury;
	local v95 = v23.Warrior.Fury;
	local v96 = {};
	local v97 = 9330 + 1781;
	local v98 = 10871 + 240;
	v10:RegisterForEvent(function()
		local v115 = 433 - (153 + 280);
		while true do
			if (((2659 - 1738) <= (990 + 112)) and (v115 == (0 + 0))) then
				v97 = 5815 + 5296;
				v98 = 10084 + 1027;
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
			if (((7165 - 2459) >= (596 + 367)) and (v116 == (667 - (89 + 578)))) then
				v117 = UnitGetTotalAbsorbs(v15:ID());
				if ((v117 > (0 + 0)) or ((1995 - 1035) <= (1925 - (572 + 477)))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v103()
		if ((v93.BitterImmunity:IsReady() and v64 and (v14:HealthPercentage() <= v73)) or ((279 + 1787) == (560 + 372))) then
			if (((576 + 4249) < (4929 - (84 + 2))) and v24(v93.BitterImmunity)) then
				return "bitter_immunity defensive";
			end
		end
		if ((v93.EnragedRegeneration:IsCastable() and v65 and (v14:HealthPercentage() <= v74)) or ((6388 - 2511) >= (3269 + 1268))) then
			if (v24(v93.EnragedRegeneration) or ((5157 - (497 + 345)) < (45 + 1681))) then
				return "enraged_regeneration defensive";
			end
		end
		if ((v93.IgnorePain:IsCastable() and v66 and (v14:HealthPercentage() <= v75)) or ((622 + 3057) < (1958 - (605 + 728)))) then
			if (v24(v93.IgnorePain, nil, nil, true) or ((3300 + 1325) < (1404 - 772))) then
				return "ignore_pain defensive";
			end
		end
		if ((v93.RallyingCry:IsCastable() and v67 and v14:BuffDown(v93.AspectsFavorBuff) and v14:BuffDown(v93.RallyingCry) and (((v14:HealthPercentage() <= v76) and v92.IsSoloMode()) or v92.AreUnitsBelowHealthPercentage(v76, v77, v93.Intervene))) or ((4 + 79) > (6581 - 4801))) then
			if (((493 + 53) <= (2983 - 1906)) and v24(v93.RallyingCry)) then
				return "rallying_cry defensive";
			end
		end
		if ((v93.Intervene:IsCastable() and v68 and (v17:HealthPercentage() <= v78) and (v17:Name() ~= v14:Name())) or ((753 + 243) > (4790 - (457 + 32)))) then
			if (((1727 + 2343) > (2089 - (832 + 570))) and v24(v95.InterveneFocus)) then
				return "intervene defensive";
			end
		end
		if ((v93.DefensiveStance:IsCastable() and v69 and (v14:HealthPercentage() <= v79) and v14:BuffDown(v93.DefensiveStance, true)) or ((619 + 37) >= (869 + 2461))) then
			if (v24(v93.DefensiveStance) or ((8818 - 6326) <= (162 + 173))) then
				return "defensive_stance defensive";
			end
		end
		if (((5118 - (588 + 208)) >= (6905 - 4343)) and v93.BerserkerStance:IsCastable() and v69 and (v14:HealthPercentage() > v82) and v14:BuffDown(v93.BerserkerStance, true)) then
			if (v24(v93.BerserkerStance) or ((5437 - (884 + 916)) >= (7892 - 4122))) then
				return "berserker_stance after defensive stance defensive";
			end
		end
		if ((v94.Healthstone:IsReady() and v70 and (v14:HealthPercentage() <= v80)) or ((1380 + 999) > (5231 - (232 + 421)))) then
			if (v24(v95.Healthstone) or ((2372 - (1569 + 320)) > (183 + 560))) then
				return "healthstone defensive 3";
			end
		end
		if (((467 + 1987) > (1947 - 1369)) and v71 and (v14:HealthPercentage() <= v81)) then
			if (((1535 - (316 + 289)) < (11669 - 7211)) and (v87 == "Refreshing Healing Potion")) then
				if (((31 + 631) <= (2425 - (666 + 787))) and v94.RefreshingHealingPotion:IsReady()) then
					if (((4795 - (360 + 65)) == (4085 + 285)) and v24(v95.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if ((v87 == "Dreamwalker's Healing Potion") or ((5016 - (79 + 175)) <= (1357 - 496))) then
				if (v94.DreamwalkersHealingPotion:IsReady() or ((1102 + 310) == (13070 - 8806))) then
					if (v24(v95.RefreshingHealingPotion) or ((6100 - 2932) < (3052 - (503 + 396)))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v104()
		local v118 = 181 - (92 + 89);
		while true do
			if ((v118 == (0 - 0)) or ((2552 + 2424) < (789 + 543))) then
				v27 = v92.HandleTopTrinket(v96, v30, 156 - 116, nil);
				if (((633 + 3995) == (10552 - 5924)) and v27) then
					return v27;
				end
				v118 = 1 + 0;
			end
			if (((1 + 0) == v118) or ((164 - 110) == (50 + 345))) then
				v27 = v92.HandleBottomTrinket(v96, v30, 61 - 21, nil);
				if (((1326 - (485 + 759)) == (189 - 107)) and v27) then
					return v27;
				end
				break;
			end
		end
	end
	local function v105()
		local v119 = 1189 - (442 + 747);
		while true do
			if ((v119 == (1136 - (832 + 303))) or ((1527 - (88 + 858)) < (86 + 196))) then
				if ((v93.Bloodthirst:IsCastable() and v35 and v101) or ((3815 + 794) < (103 + 2392))) then
					if (((1941 - (766 + 23)) == (5687 - 4535)) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst precombat 10";
					end
				end
				if (((2592 - 696) <= (9015 - 5593)) and v36 and v93.Charge:IsReady() and not v101) then
					if (v24(v93.Charge, not v15:IsSpellInRange(v93.Charge)) or ((3360 - 2370) > (2693 - (1036 + 37)))) then
						return "charge precombat 12";
					end
				end
				break;
			end
			if ((v119 == (0 + 0)) or ((1707 - 830) > (3694 + 1001))) then
				if (((4171 - (641 + 839)) >= (2764 - (910 + 3))) and v32 and ((v53 and v30) or not v53) and (v91 < v98) and v93.Avatar:IsCastable() and not v93.TitansTorment:IsAvailable()) then
					if (v24(v93.Avatar, not v101) or ((7609 - 4624) >= (6540 - (1466 + 218)))) then
						return "avatar precombat 6";
					end
				end
				if (((1966 + 2310) >= (2343 - (556 + 592))) and v45 and ((v56 and v30) or not v56) and (v91 < v98) and v93.Recklessness:IsCastable() and not v93.RecklessAbandon:IsAvailable()) then
					if (((1150 + 2082) <= (5498 - (329 + 479))) and v24(v93.Recklessness, not v101)) then
						return "recklessness precombat 8";
					end
				end
				v119 = 855 - (174 + 680);
			end
		end
	end
	local function v106()
		local v120 = 0 - 0;
		while true do
			if ((v120 == (0 - 0)) or ((640 + 256) >= (3885 - (396 + 343)))) then
				if (((271 + 2790) >= (4435 - (29 + 1448))) and not v14:AffectingCombat()) then
					if (((4576 - (135 + 1254)) >= (2425 - 1781)) and v93.BerserkerStance:IsCastable() and v14:BuffDown(v93.BerserkerStance, true)) then
						if (((3006 - 2362) <= (470 + 234)) and v24(v93.BerserkerStance)) then
							return "berserker_stance";
						end
					end
					if (((2485 - (389 + 1138)) > (1521 - (102 + 472))) and v93.BattleShout:IsCastable() and v33 and (v14:BuffDown(v93.BattleShoutBuff, true) or v92.GroupBuffMissing(v93.BattleShoutBuff))) then
						if (((4240 + 252) >= (1472 + 1182)) and v24(v93.BattleShout)) then
							return "battle_shout precombat";
						end
					end
				end
				if (((3210 + 232) >= (3048 - (320 + 1225))) and v92.TargetIsValid() and v28) then
					if (not v14:AffectingCombat() or ((5643 - 2473) <= (896 + 568))) then
						v27 = v105();
						if (v27 or ((6261 - (157 + 1307)) == (6247 - (821 + 1038)))) then
							return v27;
						end
					end
				end
				break;
			end
		end
	end
	local function v107()
		local v121 = 0 - 0;
		local v122;
		while true do
			if (((61 + 490) <= (1209 - 528)) and (v121 == (3 + 4))) then
				if (((8122 - 4845) > (1433 - (834 + 192))) and v93.RagingBlow:IsCastable() and v42) then
					if (((299 + 4396) >= (364 + 1051)) and v24(v93.RagingBlow, not v101)) then
						return "raging_blow single_target 52";
					end
				end
				if ((v93.CrushingBlow:IsCastable() and v37 and v14:BuffDown(v93.FuriousBloodthirstBuff)) or ((69 + 3143) <= (1461 - 517))) then
					if (v24(v93.CrushingBlow, not v101) or ((3400 - (300 + 4)) <= (481 + 1317))) then
						return "crushing_blow single_target 54";
					end
				end
				if (((9258 - 5721) == (3899 - (112 + 250))) and v93.Bloodthirst:IsCastable() and v35) then
					if (((1530 + 2307) >= (3933 - 2363)) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst single_target 56";
					end
				end
				if ((v29 and v93.Whirlwind:IsCastable() and v49) or ((1690 + 1260) == (1972 + 1840))) then
					if (((3533 + 1190) >= (1150 + 1168)) and v24(v93.Whirlwind, not v15:IsInMeleeRange(6 + 2))) then
						return "whirlwind single_target 58";
					end
				end
				break;
			end
			if (((1419 - (1001 + 413)) == v121) or ((4520 - 2493) > (3734 - (244 + 638)))) then
				if ((v93.CrushingBlow:IsCastable() and v37 and (v93.CrushingBlow:Charges() > (694 - (627 + 66))) and v93.WrathandFury:IsAvailable() and v14:BuffDown(v93.FuriousBloodthirstBuff)) or ((3384 - 2248) > (4919 - (512 + 90)))) then
					if (((6654 - (1665 + 241)) == (5465 - (373 + 344))) and v24(v93.CrushingBlow, not v101)) then
						return "crushing_blow single_target 38";
					end
				end
				if (((1686 + 2050) <= (1255 + 3485)) and v93.Bloodbath:IsCastable() and v34 and (not v14:BuffUp(v93.EnrageBuff) or not v93.WrathandFury:IsAvailable())) then
					if (v24(v93.Bloodbath, not v101) or ((8941 - 5551) <= (5178 - 2118))) then
						return "bloodbath single_target 40";
					end
				end
				if ((v93.CrushingBlow:IsCastable() and v37 and v14:BuffUp(v93.EnrageBuff) and v93.RecklessAbandon:IsAvailable() and v14:BuffDown(v93.FuriousBloodthirstBuff)) or ((2098 - (35 + 1064)) > (1960 + 733))) then
					if (((990 - 527) < (3 + 598)) and v24(v93.CrushingBlow, not v101)) then
						return "crushing_blow single_target 42";
					end
				end
				if ((v93.Bloodthirst:IsCastable() and v35 and not v93.WrathandFury:IsAvailable() and v14:BuffDown(v93.FuriousBloodthirstBuff)) or ((3419 - (298 + 938)) < (1946 - (233 + 1026)))) then
					if (((6215 - (636 + 1030)) == (2326 + 2223)) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst single_target 44";
					end
				end
				v121 = 6 + 0;
			end
			if (((1388 + 3284) == (316 + 4356)) and (v121 == (222 - (55 + 166)))) then
				v122 = v14:CritChancePct() + (v25(v14:BuffUp(v93.RecklessnessBuff)) * (4 + 16)) + (v14:BuffStack(v93.MercilessAssaultBuff) * (2 + 8)) + (v14:BuffStack(v93.BloodcrazeBuff) * (57 - 42));
				if ((v93.Bloodbath:IsCastable() and v34 and v14:HasTier(327 - (36 + 261), 6 - 2) and (v122 >= (1463 - (34 + 1334)))) or ((1411 + 2257) < (307 + 88))) then
					if (v24(v93.Bloodbath, not v101) or ((5449 - (1035 + 248)) == (476 - (20 + 1)))) then
						return "bloodbath single_target 10";
					end
				end
				if ((v93.Bloodthirst:IsCastable() and v35 and ((v14:HasTier(16 + 14, 323 - (134 + 185)) and (v122 >= (1228 - (549 + 584)))) or (not v93.RecklessAbandon:IsAvailable() and v14:BuffUp(v93.FuriousBloodthirstBuff) and v14:BuffUp(v93.EnrageBuff) and (v15:DebuffDown(v93.GushingWoundDebuff) or v14:BuffUp(v93.ChampionsMightBuff))))) or ((5134 - (314 + 371)) == (9141 - 6478))) then
					if (v24(v93.Bloodthirst, not v101) or ((5245 - (478 + 490)) < (1584 + 1405))) then
						return "bloodthirst single_target 12";
					end
				end
				if ((v93.Bloodbath:IsCastable() and v34 and v14:HasTier(1203 - (786 + 386), 6 - 4)) or ((2249 - (1055 + 324)) >= (5489 - (1093 + 247)))) then
					if (((1966 + 246) < (335 + 2848)) and v24(v93.Bloodbath, not v101)) then
						return "bloodbath single_target 14";
					end
				end
				v121 = 7 - 5;
			end
			if (((15767 - 11121) > (8513 - 5521)) and (v121 == (9 - 5))) then
				if (((511 + 923) < (11965 - 8859)) and v93.Bloodbath:IsCastable() and v34 and v14:BuffUp(v93.EnrageBuff) and v93.RecklessAbandon:IsAvailable() and not v93.WrathandFury:IsAvailable()) then
					if (((2709 - 1923) < (2280 + 743)) and v24(v93.Bloodbath, not v101)) then
						return "bloodbath single_target 30";
					end
				end
				if ((v93.Rampage:IsReady() and v43 and (v15:HealthPercentage() < (89 - 54)) and v93.Massacre:IsAvailable()) or ((3130 - (364 + 324)) < (202 - 128))) then
					if (((10882 - 6347) == (1504 + 3031)) and v24(v93.Rampage, not v101)) then
						return "rampage single_target 32";
					end
				end
				if ((v93.Bloodthirst:IsCastable() and v35 and (not v14:BuffUp(v93.EnrageBuff) or (v93.Annihilator:IsAvailable() and v14:BuffDown(v93.RecklessnessBuff))) and v14:BuffDown(v93.FuriousBloodthirstBuff)) or ((12590 - 9581) <= (3371 - 1266))) then
					if (((5557 - 3727) < (4937 - (1249 + 19))) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst single_target 34";
					end
				end
				if ((v93.RagingBlow:IsCastable() and v42 and (v93.RagingBlow:Charges() > (1 + 0)) and v93.WrathandFury:IsAvailable()) or ((5566 - 4136) >= (4698 - (686 + 400)))) then
					if (((2106 + 577) >= (2689 - (73 + 156))) and v24(v93.RagingBlow, not v101)) then
						return "raging_blow single_target 36";
					end
				end
				v121 = 1 + 4;
			end
			if ((v121 == (811 - (721 + 90))) or ((21 + 1783) >= (10633 - 7358))) then
				if ((v93.Whirlwind:IsCastable() and v49 and (v100 > (471 - (224 + 246))) and v93.ImprovedWhilwind:IsAvailable() and v14:BuffDown(v93.MeatCleaverBuff)) or ((2295 - 878) > (6681 - 3052))) then
					if (((870 + 3925) > (10 + 392)) and v24(v93.Whirlwind, not v15:IsInMeleeRange(6 + 2))) then
						return "whirlwind single_target 2";
					end
				end
				if (((9568 - 4755) > (11863 - 8298)) and v93.Execute:IsReady() and v38 and v14:BuffUp(v93.AshenJuggernautBuff) and (v14:BuffRemains(v93.AshenJuggernautBuff) < v14:GCD())) then
					if (((4425 - (203 + 310)) == (5905 - (1238 + 755))) and v24(v93.Execute, not v101)) then
						return "execute single_target 4";
					end
				end
				if (((198 + 2623) <= (6358 - (709 + 825))) and v40 and ((v54 and v30) or not v54) and v93.OdynsFury:IsCastable() and (v91 < v98) and v14:BuffUp(v93.EnrageBuff) and ((v93.DancingBlades:IsAvailable() and (v14:BuffRemains(v93.DancingBladesBuff) < (8 - 3))) or not v93.DancingBlades:IsAvailable())) then
					if (((2531 - 793) <= (3059 - (196 + 668))) and v24(v93.OdynsFury, not v15:IsInMeleeRange(31 - 23))) then
						return "odyns_fury single_target 6";
					end
				end
				if (((84 - 43) <= (3851 - (171 + 662))) and v93.Rampage:IsReady() and v43 and v93.AngerManagement:IsAvailable() and (v14:BuffUp(v93.RecklessnessBuff) or (v14:BuffRemains(v93.EnrageBuff) < v14:GCD()) or (v14:RagePercentage() > (178 - (4 + 89))))) then
					if (((7517 - 5372) <= (1495 + 2609)) and v24(v93.Rampage, not v101)) then
						return "rampage single_target 8";
					end
				end
				v121 = 4 - 3;
			end
			if (((1055 + 1634) < (6331 - (35 + 1451))) and ((1456 - (28 + 1425)) == v121)) then
				if ((v93.Rampage:IsReady() and v43 and v93.RecklessAbandon:IsAvailable() and (v14:BuffUp(v93.RecklessnessBuff) or (v14:BuffRemains(v93.EnrageBuff) < v14:GCD()) or (v14:RagePercentage() > (2078 - (941 + 1052))))) or ((2227 + 95) > (4136 - (822 + 692)))) then
					if (v24(v93.Rampage, not v101) or ((6472 - 1938) == (981 + 1101))) then
						return "rampage single_target 24";
					end
				end
				if ((v93.Execute:IsReady() and v38 and v14:BuffUp(v93.EnrageBuff)) or ((1868 - (45 + 252)) > (1848 + 19))) then
					if (v24(v93.Execute, not v101) or ((914 + 1740) >= (7291 - 4295))) then
						return "execute single_target 26";
					end
				end
				if (((4411 - (114 + 319)) > (3020 - 916)) and v93.Rampage:IsReady() and v43 and v93.AngerManagement:IsAvailable()) then
					if (((3837 - 842) > (983 + 558)) and v24(v93.Rampage, not v101)) then
						return "rampage single_target 28";
					end
				end
				if (((4839 - 1590) > (1996 - 1043)) and v93.Execute:IsReady() and v38) then
					if (v24(v93.Execute, not v101) or ((5236 - (556 + 1407)) > (5779 - (741 + 465)))) then
						return "execute single_target 29";
					end
				end
				v121 = 469 - (170 + 295);
			end
			if ((v121 == (2 + 0)) or ((2895 + 256) < (3161 - 1877))) then
				if ((v48 and ((v58 and v30) or not v58) and (v91 < v98) and v93.ThunderousRoar:IsCastable() and v14:BuffUp(v93.EnrageBuff)) or ((1534 + 316) == (981 + 548))) then
					if (((465 + 356) < (3353 - (957 + 273))) and v24(v93.ThunderousRoar, not v15:IsInMeleeRange(3 + 5))) then
						return "thunderous_roar single_target 16";
					end
				end
				if (((362 + 540) < (8859 - 6534)) and v93.Onslaught:IsReady() and v41 and (v14:BuffUp(v93.EnrageBuff) or v93.Tenderize:IsAvailable())) then
					if (((2260 - 1402) <= (9047 - 6085)) and v24(v93.Onslaught, not v101)) then
						return "onslaught single_target 18";
					end
				end
				if ((v93.CrushingBlow:IsCastable() and v37 and v93.WrathandFury:IsAvailable() and v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.FuriousBloodthirstBuff)) or ((19539 - 15593) < (3068 - (389 + 1391)))) then
					if (v24(v93.CrushingBlow, not v101) or ((2035 + 1207) == (60 + 507))) then
						return "crushing_blow single_target 20";
					end
				end
				if ((v93.Execute:IsReady() and v38 and ((v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.FuriousBloodthirstBuff) and v14:BuffUp(v93.AshenJuggernautBuff)) or ((v14:BuffRemains(v93.SuddenDeathBuff) <= v14:GCD()) and (((v15:HealthPercentage() > (79 - 44)) and v93.Massacre:IsAvailable()) or (v15:HealthPercentage() > (971 - (783 + 168))))))) or ((2842 - 1995) >= (1243 + 20))) then
					if (v24(v93.Execute, not v101) or ((2564 - (309 + 2)) == (5684 - 3833))) then
						return "execute single_target 22";
					end
				end
				v121 = 1215 - (1090 + 122);
			end
			if ((v121 == (2 + 4)) or ((7009 - 4922) > (1624 + 748))) then
				if ((v93.RagingBlow:IsCastable() and v42 and (v93.RagingBlow:Charges() > (1119 - (628 + 490)))) or ((798 + 3647) < (10272 - 6123))) then
					if (v24(v93.RagingBlow, not v101) or ((8308 - 6490) == (859 - (431 + 343)))) then
						return "raging_blow single_target 46";
					end
				end
				if (((1272 - 642) < (6152 - 4025)) and v93.Rampage:IsReady() and v43) then
					if (v24(v93.Rampage, not v101) or ((1532 + 406) == (322 + 2192))) then
						return "rampage single_target 47";
					end
				end
				if (((5950 - (556 + 1139)) >= (70 - (6 + 9))) and v93.Slam:IsReady() and v46 and (v93.Annihilator:IsAvailable())) then
					if (((550 + 2449) > (593 + 563)) and v24(v93.Slam, not v101)) then
						return "slam single_target 48";
					end
				end
				if (((2519 - (28 + 141)) > (448 + 707)) and v93.Bloodbath:IsCastable() and v34) then
					if (((4972 - 943) <= (3438 + 1415)) and v24(v93.Bloodbath, not v101)) then
						return "bloodbath single_target 50";
					end
				end
				v121 = 1324 - (486 + 831);
			end
		end
	end
	local function v108()
		local v123 = 0 - 0;
		local v124;
		while true do
			if ((v123 == (10 - 7)) or ((98 + 418) > (10858 - 7424))) then
				if (((5309 - (668 + 595)) >= (2730 + 303)) and v93.CrushingBlow:IsCastable() and v93.WrathandFury:IsAvailable() and v37 and v14:BuffUp(v93.EnrageBuff)) then
					if (v24(v93.CrushingBlow, not v101) or ((549 + 2170) <= (3946 - 2499))) then
						return "crushing_blow multi_target 14";
					end
				end
				if ((v93.Execute:IsReady() and v38 and v14:BuffUp(v93.EnrageBuff)) or ((4424 - (23 + 267)) < (5870 - (1129 + 815)))) then
					if (v24(v93.Execute, not v101) or ((551 - (371 + 16)) >= (4535 - (1326 + 424)))) then
						return "execute multi_target 16";
					end
				end
				if ((v93.OdynsFury:IsCastable() and ((v54 and v30) or not v54) and v40 and (v91 < v98) and v14:BuffUp(v93.EnrageBuff)) or ((994 - 469) == (7706 - 5597))) then
					if (((151 - (88 + 30)) == (804 - (720 + 51))) and v24(v93.OdynsFury, not v15:IsInMeleeRange(17 - 9))) then
						return "odyns_fury multi_target 18";
					end
				end
				v123 = 1780 - (421 + 1355);
			end
			if (((5037 - 1983) <= (1973 + 2042)) and (v123 == (1089 - (286 + 797)))) then
				if (((6839 - 4968) < (5601 - 2219)) and v93.CrushingBlow:IsCastable() and v37 and (v93.CrushingBlow:Charges() > (440 - (397 + 42))) and v93.WrathandFury:IsAvailable()) then
					if (((404 + 889) <= (2966 - (24 + 776))) and v24(v93.CrushingBlow, not v101)) then
						return "crushing_blow multi_target 32";
					end
				end
				if ((v93.Bloodbath:IsCastable() and v34 and (not v14:BuffUp(v93.EnrageBuff) or not v93.WrathandFury:IsAvailable())) or ((3972 - 1393) < (908 - (222 + 563)))) then
					if (v24(v93.Bloodbath, not v101) or ((1863 - 1017) >= (1705 + 663))) then
						return "bloodbath multi_target 34";
					end
				end
				if ((v93.CrushingBlow:IsCastable() and v37 and v14:BuffUp(v93.EnrageBuff) and v93.RecklessAbandon:IsAvailable()) or ((4202 - (23 + 167)) <= (5156 - (690 + 1108)))) then
					if (((540 + 954) <= (2479 + 526)) and v24(v93.CrushingBlow, not v101)) then
						return "crushing_blow multi_target 36";
					end
				end
				v123 = 855 - (40 + 808);
			end
			if ((v123 == (1 + 3)) or ((11896 - 8785) == (2040 + 94))) then
				if (((1246 + 1109) == (1292 + 1063)) and v93.Rampage:IsReady() and v43 and (v14:BuffUp(v93.RecklessnessBuff) or (v14:BuffRemains(v93.EnrageBuff) < v14:GCD()) or ((v14:Rage() > (681 - (47 + 524))) and v93.OverwhelmingRage:IsAvailable()) or ((v14:Rage() > (52 + 28)) and not v93.OverwhelmingRage:IsAvailable()))) then
					if (v24(v93.Rampage, not v101) or ((1607 - 1019) <= (645 - 213))) then
						return "rampage multi_target 20";
					end
				end
				if (((10940 - 6143) >= (5621 - (1165 + 561))) and v93.Execute:IsReady() and v38) then
					if (((107 + 3470) == (11078 - 7501)) and v24(v93.Execute, not v101)) then
						return "execute multi_target 22";
					end
				end
				if (((1448 + 2346) > (4172 - (341 + 138))) and v93.Bloodbath:IsCastable() and v34 and v14:BuffUp(v93.EnrageBuff) and v93.RecklessAbandon:IsAvailable() and not v93.WrathandFury:IsAvailable()) then
					if (v24(v93.Bloodbath, not v101) or ((345 + 930) == (8461 - 4361))) then
						return "bloodbath multi_target 24";
					end
				end
				v123 = 331 - (89 + 237);
			end
			if ((v123 == (25 - 17)) or ((3349 - 1758) >= (4461 - (581 + 300)))) then
				if (((2203 - (855 + 365)) <= (4294 - 2486)) and v93.Slam:IsReady() and v46 and (v93.Annihilator:IsAvailable())) then
					if (v24(v93.Slam, not v101) or ((703 + 1447) <= (2432 - (1030 + 205)))) then
						return "slam multi_target 44";
					end
				end
				if (((3539 + 230) >= (1092 + 81)) and v93.Bloodbath:IsCastable() and v34) then
					if (((1771 - (156 + 130)) == (3374 - 1889)) and v24(v93.Bloodbath, not v101)) then
						return "bloodbath multi_target 46";
					end
				end
				if ((v93.RagingBlow:IsCastable() and v42) or ((5587 - 2272) <= (5697 - 2915))) then
					if (v24(v93.RagingBlow, not v101) or ((231 + 645) >= (1729 + 1235))) then
						return "raging_blow multi_target 48";
					end
				end
				v123 = 78 - (10 + 59);
			end
			if ((v123 == (0 + 0)) or ((10992 - 8760) > (3660 - (671 + 492)))) then
				if ((v93.Recklessness:IsCastable() and ((v56 and v30) or not v56) and v45 and (v91 < v98) and ((v100 > (1 + 0)) or (v98 < (1227 - (369 + 846))))) or ((559 + 1551) <= (284 + 48))) then
					if (((5631 - (1036 + 909)) > (2522 + 650)) and v24(v93.Recklessness, not v101)) then
						return "recklessness multi_target 2";
					end
				end
				if ((v93.OdynsFury:IsCastable() and ((v54 and v30) or not v54) and v40 and (v91 < v98) and (v100 > (1 - 0)) and v93.TitanicRage:IsAvailable() and (v14:BuffDown(v93.MeatCleaverBuff) or v14:BuffUp(v93.AvatarBuff) or v14:BuffUp(v93.RecklessnessBuff))) or ((4677 - (11 + 192)) < (415 + 405))) then
					if (((4454 - (135 + 40)) >= (6982 - 4100)) and v24(v93.OdynsFury, not v15:IsInMeleeRange(5 + 3))) then
						return "odyns_fury multi_target 4";
					end
				end
				if ((v93.Whirlwind:IsCastable() and v49 and (v100 > (2 - 1)) and v93.ImprovedWhilwind:IsAvailable() and v14:BuffDown(v93.MeatCleaverBuff)) or ((3041 - 1012) >= (3697 - (50 + 126)))) then
					if (v24(v93.Whirlwind, not v15:IsInMeleeRange(22 - 14)) or ((451 + 1586) >= (6055 - (1233 + 180)))) then
						return "whirlwind multi_target 6";
					end
				end
				v123 = 970 - (522 + 447);
			end
			if (((3141 - (107 + 1314)) < (2069 + 2389)) and ((5 - 3) == v123)) then
				v124 = v14:CritChancePct() + (v25(v14:BuffUp(v93.RecklessnessBuff)) * (9 + 11)) + (v14:BuffStack(v93.MercilessAssaultBuff) * (19 - 9)) + (v14:BuffStack(v93.BloodcrazeBuff) * (59 - 44));
				if ((v93.Bloodbath:IsCastable() and v34 and v14:HasTier(1940 - (716 + 1194), 1 + 3) and (v124 >= (11 + 84))) or ((939 - (74 + 429)) > (5827 - 2806))) then
					if (((354 + 359) <= (1938 - 1091)) and v24(v93.Bloodbath, not v101)) then
						return "bloodbath multi_target 14";
					end
				end
				if (((1524 + 630) <= (12427 - 8396)) and v93.Bloodthirst:IsCastable() and v35 and ((v14:HasTier(74 - 44, 437 - (279 + 154)) and (v124 >= (873 - (454 + 324)))) or (not v93.RecklessAbandon:IsAvailable() and v14:BuffUp(v93.FuriousBloodthirstBuff) and v14:BuffUp(v93.EnrageBuff)))) then
					if (((3631 + 984) == (4632 - (12 + 5))) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst multi_target 16";
					end
				end
				v123 = 2 + 1;
			end
			if ((v123 == (17 - 10)) or ((1401 + 2389) == (1593 - (277 + 816)))) then
				if (((380 - 291) < (1404 - (1058 + 125))) and v93.Bloodthirst:IsCastable() and v35 and not v93.WrathandFury:IsAvailable()) then
					if (((386 + 1668) >= (2396 - (815 + 160))) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst multi_target 38";
					end
				end
				if (((2969 - 2277) < (7259 - 4201)) and v93.RagingBlow:IsCastable() and v42 and (v93.RagingBlow:Charges() > (1 + 0))) then
					if (v24(v93.RagingBlow, not v101) or ((9511 - 6257) == (3553 - (41 + 1857)))) then
						return "raging_blow multi_target 40";
					end
				end
				if ((v93.Rampage:IsReady() and v43) or ((3189 - (1222 + 671)) == (12690 - 7780))) then
					if (((4840 - 1472) == (4550 - (229 + 953))) and v24(v93.Rampage, not v101)) then
						return "rampage multi_target 42";
					end
				end
				v123 = 1782 - (1111 + 663);
			end
			if (((4222 - (874 + 705)) < (535 + 3280)) and (v123 == (4 + 1))) then
				if (((3976 - 2063) > (14 + 479)) and v93.Bloodthirst:IsCastable() and v35 and (not v14:BuffUp(v93.EnrageBuff) or (v93.Annihilator:IsAvailable() and v14:BuffDown(v93.RecklessnessBuff)))) then
					if (((5434 - (642 + 37)) > (782 + 2646)) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst multi_target 26";
					end
				end
				if (((221 + 1160) <= (5947 - 3578)) and v93.Onslaught:IsReady() and v41 and ((not v93.Annihilator:IsAvailable() and v14:BuffUp(v93.EnrageBuff)) or v93.Tenderize:IsAvailable())) then
					if (v24(v93.Onslaught, not v101) or ((5297 - (233 + 221)) == (9443 - 5359))) then
						return "onslaught multi_target 28";
					end
				end
				if (((4110 + 559) > (1904 - (718 + 823))) and v93.RagingBlow:IsCastable() and v42 and (v93.RagingBlow:Charges() > (1 + 0)) and v93.WrathandFury:IsAvailable()) then
					if (v24(v93.RagingBlow, not v101) or ((2682 - (266 + 539)) >= (8884 - 5746))) then
						return "raging_blow multi_target 30";
					end
				end
				v123 = 1231 - (636 + 589);
			end
			if (((11256 - 6514) >= (7478 - 3852)) and (v123 == (1 + 0))) then
				if ((v93.Execute:IsReady() and v38 and v14:BuffUp(v93.AshenJuggernautBuff) and (v14:BuffRemains(v93.AshenJuggernautBuff) < v14:GCD())) or ((1650 + 2890) == (1931 - (657 + 358)))) then
					if (v24(v93.Execute, not v101) or ((3060 - 1904) > (9899 - 5554))) then
						return "execute multi_target 8";
					end
				end
				if (((3424 - (1151 + 36)) < (4104 + 145)) and v93.ThunderousRoar:IsCastable() and ((v58 and v30) or not v58) and v48 and (v91 < v98) and v14:BuffUp(v93.EnrageBuff)) then
					if (v24(v93.ThunderousRoar, not v15:IsInMeleeRange(3 + 5)) or ((8012 - 5329) < (1855 - (1552 + 280)))) then
						return "thunderous_roar multi_target 10";
					end
				end
				if (((1531 - (64 + 770)) <= (561 + 265)) and v93.OdynsFury:IsCastable() and ((v54 and v30) or not v54) and v40 and (v91 < v98) and (v100 > (2 - 1)) and v14:BuffUp(v93.EnrageBuff)) then
					if (((197 + 908) <= (2419 - (157 + 1086))) and v24(v93.OdynsFury, not v15:IsInMeleeRange(15 - 7))) then
						return "odyns_fury multi_target 12";
					end
				end
				v123 = 8 - 6;
			end
			if (((5182 - 1803) <= (5202 - 1390)) and (v123 == (828 - (599 + 220)))) then
				if ((v93.CrushingBlow:IsCastable() and v37) or ((1568 - 780) >= (3547 - (1813 + 118)))) then
					if (((1356 + 498) <= (4596 - (841 + 376))) and v24(v93.CrushingBlow, not v101)) then
						return "crushing_blow multi_target 50";
					end
				end
				if (((6373 - 1824) == (1057 + 3492)) and v93.Whirlwind:IsCastable() and v49) then
					if (v24(v93.Whirlwind, not v15:IsInMeleeRange(21 - 13)) or ((3881 - (464 + 395)) >= (7760 - 4736))) then
						return "whirlwind multi_target 52";
					end
				end
				break;
			end
		end
	end
	local function v109()
		local v125 = 0 + 0;
		while true do
			if (((5657 - (467 + 370)) > (4541 - 2343)) and (v125 == (0 + 0))) then
				v27 = v103();
				if (v27 or ((3637 - 2576) >= (764 + 4127))) then
					return v27;
				end
				v125 = 2 - 1;
			end
			if (((1884 - (150 + 370)) <= (5755 - (74 + 1208))) and (v125 == (2 - 1))) then
				if (v86 or ((17049 - 13454) <= (3 + 0))) then
					local v179 = 390 - (14 + 376);
					while true do
						if (((1 - 0) == v179) or ((3024 + 1648) == (3384 + 468))) then
							v27 = v92.HandleIncorporeal(v93.IntimidatingShout, v95.IntimidatingShoutMouseover, 8 + 0, true);
							if (((4568 - 3009) == (1173 + 386)) and v27) then
								return v27;
							end
							break;
						end
						if ((v179 == (78 - (23 + 55))) or ((4151 - 2399) <= (526 + 262))) then
							v27 = v92.HandleIncorporeal(v93.StormBolt, v95.StormBoltMouseover, 18 + 2, true);
							if (v27 or ((6057 - 2150) == (56 + 121))) then
								return v27;
							end
							v179 = 902 - (652 + 249);
						end
					end
				end
				if (((9286 - 5816) > (2423 - (708 + 1160))) and v92.TargetIsValid()) then
					local v180 = 0 - 0;
					local v181;
					while true do
						if (((5 - 2) == v180) or ((999 - (10 + 17)) == (145 + 500))) then
							v27 = v107();
							if (((4914 - (1400 + 332)) >= (4056 - 1941)) and v27) then
								return v27;
							end
							break;
						end
						if (((5801 - (242 + 1666)) < (1896 + 2533)) and (v180 == (0 + 0))) then
							if ((v36 and v93.Charge:IsCastable()) or ((2444 + 423) < (2845 - (850 + 90)))) then
								if (v24(v93.Charge, not v15:IsSpellInRange(v93.Charge)) or ((3144 - 1348) >= (5441 - (360 + 1030)))) then
									return "charge main 2";
								end
							end
							v181 = v92.HandleDPSPotion(v15:BuffUp(v93.RecklessnessBuff));
							if (((1433 + 186) <= (10600 - 6844)) and v181) then
								return v181;
							end
							v180 = 1 - 0;
						end
						if (((2265 - (909 + 752)) == (1827 - (109 + 1114))) and ((1 - 0) == v180)) then
							if ((v91 < v98) or ((1746 + 2738) == (1142 - (6 + 236)))) then
								local v185 = 0 + 0;
								while true do
									if ((v185 == (0 + 0)) or ((10515 - 6056) <= (1943 - 830))) then
										if (((4765 - (1076 + 57)) > (559 + 2839)) and v52 and ((v30 and v60) or not v60)) then
											v27 = v104();
											if (((4771 - (579 + 110)) <= (389 + 4528)) and v27) then
												return v27;
											end
										end
										if (((4273 + 559) >= (736 + 650)) and v30 and v94.FyralathTheDreamrender:IsEquippedAndReady() and v31) then
											if (((544 - (174 + 233)) == (382 - 245)) and v24(v95.UseWeapon)) then
												return "Fyralath The Dreamrender used";
											end
										end
										break;
									end
								end
							end
							if (((v91 < v98) and v51 and ((v59 and v30) or not v59)) or ((2755 - 1185) >= (1927 + 2405))) then
								local v186 = 1174 - (663 + 511);
								while true do
									if (((2 + 0) == v186) or ((883 + 3181) <= (5607 - 3788))) then
										if (v93.AncestralCall:IsCastable() or ((3020 + 1966) < (3705 - 2131))) then
											if (((10714 - 6288) > (83 + 89)) and v24(v93.AncestralCall, not v101)) then
												return "ancestral_call main 20";
											end
										end
										if (((1140 - 554) > (325 + 130)) and v93.BagofTricks:IsCastable() and v14:BuffDown(v93.RecklessnessBuff) and v14:BuffUp(v93.EnrageBuff)) then
											if (((76 + 750) == (1548 - (478 + 244))) and v24(v93.BagofTricks, not v15:IsSpellInRange(v93.BagofTricks))) then
												return "bag_of_tricks main 22";
											end
										end
										break;
									end
									if ((v186 == (518 - (440 + 77))) or ((1828 + 2191) > (16254 - 11813))) then
										if (((3573 - (655 + 901)) < (791 + 3470)) and v93.LightsJudgment:IsCastable() and v14:BuffDown(v93.RecklessnessBuff)) then
											if (((3611 + 1105) > (55 + 25)) and v24(v93.LightsJudgment, not v15:IsSpellInRange(v93.LightsJudgment))) then
												return "lights_judgment main 16";
											end
										end
										if (v93.Fireblood:IsCastable() or ((14128 - 10621) == (4717 - (695 + 750)))) then
											if (v24(v93.Fireblood, not v101) or ((2990 - 2114) >= (4745 - 1670))) then
												return "fireblood main 18";
											end
										end
										v186 = 7 - 5;
									end
									if (((4703 - (285 + 66)) > (5953 - 3399)) and (v186 == (1310 - (682 + 628)))) then
										if (v93.BloodFury:IsCastable() or ((711 + 3695) < (4342 - (176 + 123)))) then
											if (v24(v93.BloodFury, not v101) or ((791 + 1098) >= (2454 + 929))) then
												return "blood_fury main 12";
											end
										end
										if (((2161 - (239 + 30)) <= (744 + 1990)) and v93.Berserking:IsCastable() and v14:BuffUp(v93.RecklessnessBuff)) then
											if (((1849 + 74) < (3925 - 1707)) and v24(v93.Berserking, not v101)) then
												return "berserking main 14";
											end
										end
										v186 = 2 - 1;
									end
								end
							end
							if (((2488 - (306 + 9)) > (1322 - 943)) and (v91 < v98)) then
								local v187 = 0 + 0;
								while true do
									if ((v187 == (2 + 0)) or ((1248 + 1343) == (9748 - 6339))) then
										if (((5889 - (1140 + 235)) > (2116 + 1208)) and v93.Ravager:IsCastable() and (v84 == "cursor") and v44 and ((v55 and v30) or not v55) and ((v93.Avatar:CooldownRemains() < (3 + 0)) or v14:BuffUp(v93.RecklessnessBuff) or (v98 < (3 + 7)))) then
											if (v24(v95.RavagerCursor, not v101) or ((260 - (33 + 19)) >= (1744 + 3084))) then
												return "ravager main 28";
											end
										end
										if ((v93.ChampionsSpear:IsCastable() and (v85 == "player") and v47 and ((v57 and v30) or not v57) and v14:BuffUp(v93.EnrageBuff) and ((v14:BuffUp(v93.FuriousBloodthirstBuff) and v93.TitansTorment:IsAvailable()) or not v93.TitansTorment:IsAvailable() or (v98 < (59 - 39)) or (v100 > (1 + 0)) or not v14:HasTier(60 - 29, 2 + 0))) or ((2272 - (586 + 103)) > (325 + 3242))) then
											if (v24(v95.ChampionsSpearPlayer, not v101) or ((4042 - 2729) == (2282 - (1309 + 179)))) then
												return "spear_of_bastion main 30";
											end
										end
										v187 = 5 - 2;
									end
									if (((1382 + 1792) > (7793 - 4891)) and (v187 == (0 + 0))) then
										if (((8753 - 4633) <= (8488 - 4228)) and ((v93.Avatar:IsCastable() and v32 and ((v53 and v30) or not v53) and v93.TitansTorment:IsAvailable() and v14:BuffUp(v93.EnrageBuff) and (v91 < v98) and v14:BuffDown(v93.AvatarBuff) and (not v93.OdynsFury:IsAvailable() or (v93.OdynsFury:CooldownRemains() > (609 - (295 + 314))))) or (v93.BerserkersTorment:IsAvailable() and v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.AvatarBuff)) or (not v93.TitansTorment:IsAvailable() and not v93.BerserkersTorment:IsAvailable() and (v14:BuffUp(v93.RecklessnessBuff) or (v98 < (49 - 29)))))) then
											if (v24(v93.Avatar, not v101) or ((2845 - (1300 + 662)) > (15003 - 10225))) then
												return "avatar main 24";
											end
										end
										if ((v93.Recklessness:IsCastable() and v45 and ((v56 and v30) or not v56) and (not v93.Annihilator:IsAvailable() or (v93.ChampionsSpear:CooldownRemains() < (1756 - (1178 + 577))) or (v93.Avatar:CooldownRemains() > (21 + 19)) or not v93.Avatar:IsAvailable() or (v98 < (35 - 23)))) or ((5025 - (851 + 554)) >= (4326 + 565))) then
											if (((11808 - 7550) > (2034 - 1097)) and v24(v93.Recklessness, not v101)) then
												return "recklessness main 26";
											end
										end
										v187 = 303 - (115 + 187);
									end
									if (((1 + 0) == v187) or ((4610 + 259) < (3570 - 2664))) then
										if ((v93.Recklessness:IsCastable() and v45 and ((v56 and v30) or not v56) and (not v93.Annihilator:IsAvailable() or (v98 < (1173 - (160 + 1001))))) or ((1072 + 153) > (2918 + 1310))) then
											if (((6812 - 3484) > (2596 - (237 + 121))) and v24(v93.Recklessness, not v101)) then
												return "recklessness main 27";
											end
										end
										if (((4736 - (525 + 372)) > (2663 - 1258)) and v93.Ravager:IsCastable() and (v84 == "player") and v44 and ((v55 and v30) or not v55) and ((v93.Avatar:CooldownRemains() < (9 - 6)) or v14:BuffUp(v93.RecklessnessBuff) or (v98 < (152 - (96 + 46))))) then
											if (v24(v95.RavagerPlayer, not v101) or ((2070 - (643 + 134)) <= (184 + 323))) then
												return "ravager main 28";
											end
										end
										v187 = 4 - 2;
									end
									if ((v187 == (11 - 8)) or ((2778 + 118) < (1579 - 774))) then
										if (((4734 - 2418) == (3035 - (316 + 403))) and v93.ChampionsSpear:IsCastable() and (v85 == "cursor") and v47 and ((v57 and v30) or not v57) and v14:BuffUp(v93.EnrageBuff) and ((v14:BuffUp(v93.FuriousBloodthirstBuff) and v93.TitansTorment:IsAvailable()) or not v93.TitansTorment:IsAvailable() or (v98 < (14 + 6)) or (v100 > (2 - 1)) or not v14:HasTier(12 + 19, 4 - 2))) then
											if (v24(v95.ChampionsSpearCursor, not v15:IsInRange(22 + 8)) or ((829 + 1741) == (5311 - 3778))) then
												return "spear_of_bastion main 31";
											end
										end
										break;
									end
								end
							end
							v180 = 9 - 7;
						end
						if ((v180 == (3 - 1)) or ((51 + 832) == (2874 - 1414))) then
							if ((v39 and v93.HeroicThrow:IsCastable() and not v15:IsInRange(2 + 23) and v14:CanAttack(v15)) or ((13589 - 8970) <= (1016 - (12 + 5)))) then
								if (v24(v93.HeroicThrow, not v15:IsSpellInRange(v93.HeroicThrow)) or ((13244 - 9834) > (8781 - 4665))) then
									return "heroic_throw main";
								end
							end
							if ((v93.WreckingThrow:IsCastable() and v50 and v102() and v14:CanAttack(v15)) or ((1919 - 1016) >= (7585 - 4526))) then
								if (v24(v93.WreckingThrow, not v15:IsSpellInRange(v93.WreckingThrow)) or ((807 + 3169) < (4830 - (1656 + 317)))) then
									return "wrecking_throw main";
								end
							end
							if (((4394 + 536) > (1849 + 458)) and v29 and (v100 >= (4 - 2))) then
								local v188 = 0 - 0;
								while true do
									if (((354 - (5 + 349)) == v188) or ((19217 - 15171) < (2562 - (266 + 1005)))) then
										v27 = v108();
										if (v27 or ((2795 + 1446) == (12095 - 8550))) then
											return v27;
										end
										break;
									end
								end
							end
							v180 = 3 - 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v110()
		v31 = EpicSettings.Settings['useWeapon'];
		v33 = EpicSettings.Settings['useBattleShout'];
		v34 = EpicSettings.Settings['useBloodbath'];
		v35 = EpicSettings.Settings['useBloodthirst'];
		v36 = EpicSettings.Settings['useCharge'];
		v37 = EpicSettings.Settings['useCrushingBlow'];
		v38 = EpicSettings.Settings['useExecute'];
		v39 = EpicSettings.Settings['useHeroicThrow'];
		v41 = EpicSettings.Settings['useOnslaught'];
		v42 = EpicSettings.Settings['useRagingBlow'];
		v43 = EpicSettings.Settings['useRampage'];
		v46 = EpicSettings.Settings['useSlam'];
		v49 = EpicSettings.Settings['useWhirlwind'];
		v50 = EpicSettings.Settings['useWreckingThrow'];
		v32 = EpicSettings.Settings['useAvatar'];
		v40 = EpicSettings.Settings['useOdynsFury'];
		v44 = EpicSettings.Settings['useRavager'];
		v45 = EpicSettings.Settings['useRecklessness'];
		v47 = EpicSettings.Settings['useChampionsSpear'];
		v48 = EpicSettings.Settings['useThunderousRoar'];
		v53 = EpicSettings.Settings['avatarWithCD'];
		v54 = EpicSettings.Settings['odynFuryWithCD'];
		v55 = EpicSettings.Settings['ravagerWithCD'];
		v56 = EpicSettings.Settings['recklessnessWithCD'];
		v57 = EpicSettings.Settings['championsSpearWithCD'];
		v58 = EpicSettings.Settings['thunderousRoarWithCD'];
	end
	local function v111()
		local v152 = 1696 - (561 + 1135);
		while true do
			if (((5 - 1) == v152) or ((13306 - 9258) > (5298 - (507 + 559)))) then
				v79 = EpicSettings.Settings['defensiveStanceHP'] or (0 - 0);
				v82 = EpicSettings.Settings['unstanceHP'] or (0 - 0);
				v83 = EpicSettings.Settings['victoryRushHP'] or (388 - (212 + 176));
				v84 = EpicSettings.Settings['ravagerSetting'] or "player";
				v152 = 910 - (250 + 655);
			end
			if ((v152 == (0 - 0)) or ((3057 - 1307) >= (5433 - 1960))) then
				v61 = EpicSettings.Settings['usePummel'];
				v62 = EpicSettings.Settings['useStormBolt'];
				v63 = EpicSettings.Settings['useIntimidatingShout'];
				v64 = EpicSettings.Settings['useBitterImmunity'];
				v152 = 1957 - (1869 + 87);
			end
			if (((10980 - 7814) == (5067 - (484 + 1417))) and (v152 == (6 - 3))) then
				v75 = EpicSettings.Settings['ignorePainHP'] or (0 - 0);
				v76 = EpicSettings.Settings['rallyingCryHP'] or (773 - (48 + 725));
				v77 = EpicSettings.Settings['rallyingCryGroup'] or (0 - 0);
				v78 = EpicSettings.Settings['interveneHP'] or (0 - 0);
				v152 = 3 + 1;
			end
			if (((4711 - 2948) < (1043 + 2681)) and (v152 == (1 + 0))) then
				v65 = EpicSettings.Settings['useEnragedRegeneration'];
				v66 = EpicSettings.Settings['useIgnorePain'];
				v67 = EpicSettings.Settings['useRallyingCry'];
				v68 = EpicSettings.Settings['useIntervene'];
				v152 = 855 - (152 + 701);
			end
			if (((1368 - (430 + 881)) <= (1043 + 1680)) and ((897 - (557 + 338)) == v152)) then
				v69 = EpicSettings.Settings['useDefensiveStance'];
				v72 = EpicSettings.Settings['useVictoryRush'];
				v73 = EpicSettings.Settings['bitterImmunityHP'] or (0 + 0);
				v74 = EpicSettings.Settings['enragedRegenerationHP'] or (0 - 0);
				v152 = 10 - 7;
			end
			if ((v152 == (13 - 8)) or ((4461 - 2391) == (1244 - (499 + 302)))) then
				v85 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
		end
	end
	local function v112()
		local v153 = 866 - (39 + 827);
		while true do
			if ((v153 == (2 - 1)) or ((6041 - 3336) == (5532 - 4139))) then
				v52 = EpicSettings.Settings['useTrinkets'];
				v51 = EpicSettings.Settings['useRacials'];
				v60 = EpicSettings.Settings['trinketsWithCD'];
				v59 = EpicSettings.Settings['racialsWithCD'];
				v153 = 2 - 0;
			end
			if ((v153 == (1 + 1)) or ((13466 - 8865) < (10 + 51))) then
				v70 = EpicSettings.Settings['useHealthstone'];
				v71 = EpicSettings.Settings['useHealingPotion'];
				v80 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v81 = EpicSettings.Settings['healingPotionHP'] or (104 - (103 + 1));
				v153 = 557 - (475 + 79);
			end
			if ((v153 == (6 - 3)) or ((4448 - 3058) >= (614 + 4130))) then
				v87 = EpicSettings.Settings['HealingPotionName'] or "";
				v86 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v153 == (0 + 0)) or ((3506 - (1395 + 108)) > (11156 - 7322))) then
				v91 = EpicSettings.Settings['fightRemainsCheck'] or (1204 - (7 + 1197));
				v88 = EpicSettings.Settings['InterruptWithStun'];
				v89 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v90 = EpicSettings.Settings['InterruptThreshold'];
				v153 = 1 + 0;
			end
		end
	end
	local function v113()
		local v154 = 0 + 0;
		while true do
			if (((320 - (27 + 292)) == v154) or ((456 - 300) > (4989 - 1076))) then
				v28 = EpicSettings.Toggles['ooc'];
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				v154 = 8 - 6;
			end
			if (((384 - 189) == (371 - 176)) and (v154 == (142 - (43 + 96)))) then
				if (((12665 - 9560) >= (4060 - 2264)) and (v92.TargetIsValid() or v14:AffectingCombat())) then
					local v182 = 0 + 0;
					while true do
						if (((1237 + 3142) >= (4211 - 2080)) and (v182 == (1 + 0))) then
							if (((7203 - 3359) >= (644 + 1399)) and (v98 == (815 + 10296))) then
								v98 = v10.FightRemains(v99, false);
							end
							break;
						end
						if ((v182 == (1751 - (1414 + 337))) or ((5172 - (1642 + 298)) <= (7119 - 4388))) then
							v97 = v10.BossFightRemains(nil, true);
							v98 = v97;
							v182 = 2 - 1;
						end
					end
				end
				if (((14555 - 9650) == (1615 + 3290)) and not v14:IsChanneling()) then
					if (v14:AffectingCombat() or ((3218 + 918) >= (5383 - (357 + 615)))) then
						local v184 = 0 + 0;
						while true do
							if ((v184 == (0 - 0)) or ((2535 + 423) == (8608 - 4591))) then
								v27 = v109();
								if (((983 + 245) >= (56 + 757)) and v27) then
									return v27;
								end
								break;
							end
						end
					else
						v27 = v106();
						if (v27 or ((2172 + 1283) > (5351 - (384 + 917)))) then
							return v27;
						end
					end
				end
				break;
			end
			if (((940 - (128 + 569)) == (1786 - (1407 + 136))) and (v154 == (1887 - (687 + 1200)))) then
				v111();
				v110();
				v112();
				v154 = 1711 - (556 + 1154);
			end
			if (((6 - 4) == v154) or ((366 - (9 + 86)) > (1993 - (275 + 146)))) then
				if (((446 + 2293) < (3357 - (29 + 35))) and v14:IsDeadOrGhost()) then
					return v27;
				end
				if (v29 or ((17470 - 13528) < (3386 - 2252))) then
					local v183 = 0 - 0;
					while true do
						if ((v183 == (0 + 0)) or ((3705 - (53 + 959)) == (5381 - (312 + 96)))) then
							v99 = v14:GetEnemiesInMeleeRange(13 - 5);
							v100 = #v99;
							break;
						end
					end
				else
					v100 = 286 - (147 + 138);
				end
				v101 = v15:IsInMeleeRange(904 - (813 + 86));
				v154 = 3 + 0;
			end
		end
	end
	local function v114()
		v20.Print("Fury Warrior by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(132 - 60, v113, v114);
end;
return v0["Epix_Warrior_Fury.lua"]();

