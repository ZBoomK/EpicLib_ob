local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((4698 + 145) >= (3638 - (409 + 103))) and (v5 == (237 - (46 + 190)))) then
			return v6(...);
		end
		if ((v5 == (95 - (51 + 44))) or ((617 + 1570) >= (6271 - (1114 + 203)))) then
			v6 = v0[v4];
			if (not v6 or ((4603 - (228 + 498)) == (775 + 2800))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
	end
end
v0["Epix_Paladin_Protection.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Focus;
	local v15 = v12.Player;
	local v16 = v12.MouseOver;
	local v17 = v12.Target;
	local v18 = v12.Pet;
	local v19 = v10.Spell;
	local v20 = v10.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Bind;
	local v24 = v21.Macro;
	local v25 = v21.Press;
	local v26 = v21.Commons.Everyone.num;
	local v27 = v21.Commons.Everyone.bool;
	local v28 = string.format;
	local v29;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
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
	local v94;
	local v95;
	local v96;
	local v97;
	local v98;
	local v99;
	local v100 = v19.Paladin.Protection;
	local v101 = v20.Paladin.Protection;
	local v102 = v24.Paladin.Protection;
	local v103 = {};
	local v104;
	local v105;
	local v106, v107;
	local v108, v109;
	local v110 = v21.Commons.Everyone;
	local v111 = 11774 - (174 + 489);
	local v112 = 28947 - 17836;
	local v113 = 1905 - (830 + 1075);
	v10:RegisterForEvent(function()
		local v131 = 524 - (303 + 221);
		while true do
			if (((1976 - (231 + 1038)) > (527 + 105)) and (v131 == (1162 - (171 + 991)))) then
				v111 = 45790 - 34679;
				v112 = 29835 - 18724;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v114()
		if (v100.CleanseToxins:IsAvailable() or ((1362 - 816) >= (2149 + 535))) then
			v110.DispellableDebuffs = v13.MergeTable(v110.DispellableDiseaseDebuffs, v110.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v114();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v115(v132)
		return v132:DebuffRemains(v100.JudgmentDebuff);
	end
	local function v116()
		return v15:BuffDown(v100.RetributionAura) and v15:BuffDown(v100.DevotionAura) and v15:BuffDown(v100.ConcentrationAura) and v15:BuffDown(v100.CrusaderAura);
	end
	local v117 = 0 - 0;
	local function v118()
		if (((4226 - 2761) <= (6932 - 2631)) and v100.CleanseToxins:IsReady() and (v110.UnitHasDispellableDebuffByPlayer(v14) or v110.DispellableFriendlyUnit(61 - 41) or v110.UnitHasCurseDebuff(v14) or v110.UnitHasPoisonDebuff(v14))) then
			local v170 = 1248 - (111 + 1137);
			while true do
				if (((1862 - (91 + 67)) > (4241 - 2816)) and (v170 == (0 + 0))) then
					if ((v117 == (523 - (423 + 100))) or ((5 + 682) == (11723 - 7489))) then
						v117 = GetTime();
					end
					if (v110.Wait(261 + 239, v117) or ((4101 - (326 + 445)) < (6236 - 4807))) then
						local v228 = 0 - 0;
						while true do
							if (((2677 - 1530) >= (1046 - (530 + 181))) and (v228 == (881 - (614 + 267)))) then
								if (((3467 - (19 + 13)) > (3413 - 1316)) and v25(v102.CleanseToxinsFocus)) then
									return "cleanse_toxins dispel";
								end
								v117 = 0 - 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v119()
		if ((v98 and (v15:HealthPercentage() <= v99)) or ((10769 - 6999) >= (1050 + 2991))) then
			if (v100.FlashofLight:IsReady() or ((6666 - 2875) <= (3340 - 1729))) then
				if (v25(v100.FlashofLight) or ((6390 - (1293 + 519)) <= (4096 - 2088))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v120()
		local v133 = 0 - 0;
		while true do
			if (((2151 - 1026) <= (8951 - 6875)) and (v133 == (2 - 1))) then
				v29 = v110.HandleBottomTrinket(v103, v32, 22 + 18, nil);
				if (v29 or ((152 + 591) >= (10220 - 5821))) then
					return v29;
				end
				break;
			end
			if (((267 + 888) < (556 + 1117)) and (v133 == (0 + 0))) then
				v29 = v110.HandleTopTrinket(v103, v32, 1136 - (709 + 387), nil);
				if (v29 or ((4182 - (673 + 1185)) <= (1676 - 1098))) then
					return v29;
				end
				v133 = 3 - 2;
			end
		end
	end
	local function v121()
		if (((6197 - 2430) == (2695 + 1072)) and (v15:HealthPercentage() <= v69) and v58 and v100.DivineShield:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) then
			if (((3056 + 1033) == (5520 - 1431)) and v25(v100.DivineShield)) then
				return "divine_shield defensive";
			end
		end
		if (((1095 + 3363) >= (3337 - 1663)) and (v15:HealthPercentage() <= v71) and v60 and v100.LayonHands:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) then
			if (((1907 - 935) <= (3298 - (446 + 1434))) and v25(v102.LayonHandsPlayer)) then
				return "lay_on_hands defensive 2";
			end
		end
		if ((v100.GuardianofAncientKings:IsCastable() and (v15:HealthPercentage() <= v70) and v59 and v15:BuffDown(v100.ArdentDefenderBuff)) or ((6221 - (1040 + 243)) < (14212 - 9450))) then
			if (v25(v100.GuardianofAncientKings) or ((4351 - (559 + 1288)) > (6195 - (609 + 1322)))) then
				return "guardian_of_ancient_kings defensive 4";
			end
		end
		if (((2607 - (13 + 441)) == (8045 - 5892)) and v100.ArdentDefender:IsCastable() and (v15:HealthPercentage() <= v68) and v57 and v15:BuffDown(v100.GuardianofAncientKingsBuff)) then
			if (v25(v100.ArdentDefender) or ((1327 - 820) >= (12904 - 10313))) then
				return "ardent_defender defensive 6";
			end
		end
		if (((167 + 4314) == (16274 - 11793)) and v100.WordofGlory:IsReady() and (v15:HealthPercentage() <= v72) and v61 and not v15:HealingAbsorbed()) then
			if ((v15:BuffRemains(v100.ShieldoftheRighteousBuff) >= (2 + 3)) or v15:BuffUp(v100.DivinePurposeBuff) or v15:BuffUp(v100.ShiningLightFreeBuff) or ((1021 + 1307) < (2056 - 1363))) then
				if (((2369 + 1959) == (7959 - 3631)) and v25(v102.WordofGloryPlayer)) then
					return "word_of_glory defensive 8";
				end
			end
		end
		if (((1050 + 538) >= (741 + 591)) and v100.ShieldoftheRighteous:IsCastable() and (v15:HolyPower() > (2 + 0)) and v15:BuffRefreshable(v100.ShieldoftheRighteousBuff) and v62 and (v104 or (v15:HealthPercentage() <= v73))) then
			if (v25(v100.ShieldoftheRighteous) or ((3505 + 669) > (4157 + 91))) then
				return "shield_of_the_righteous defensive 12";
			end
		end
		if ((v101.Healthstone:IsReady() and v94 and (v15:HealthPercentage() <= v96)) or ((5019 - (153 + 280)) <= (236 - 154))) then
			if (((3469 + 394) == (1526 + 2337)) and v25(v102.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if ((v93 and (v15:HealthPercentage() <= v95)) or ((148 + 134) <= (39 + 3))) then
			local v171 = 0 + 0;
			while true do
				if (((7017 - 2408) >= (474 + 292)) and (v171 == (667 - (89 + 578)))) then
					if ((v97 == "Refreshing Healing Potion") or ((823 + 329) == (5172 - 2684))) then
						if (((4471 - (572 + 477)) > (452 + 2898)) and v101.RefreshingHealingPotion:IsReady()) then
							if (((527 + 350) > (45 + 331)) and v25(v102.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v97 == "Dreamwalker's Healing Potion") or ((3204 - (84 + 2)) <= (3050 - 1199))) then
						if (v101.DreamwalkersHealingPotion:IsReady() or ((119 + 46) >= (4334 - (497 + 345)))) then
							if (((102 + 3847) < (821 + 4035)) and v25(v102.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					v171 = 1334 - (605 + 728);
				end
				if ((v171 == (1 + 0)) or ((9506 - 5230) < (139 + 2877))) then
					if (((17340 - 12650) > (3719 + 406)) and (v97 == "Potion of Withering Dreams")) then
						if (v101.PotionOfWitheringDreams:IsReady() or ((138 - 88) >= (677 + 219))) then
							if (v25(v102.RefreshingHealingPotion) or ((2203 - (457 + 32)) >= (1256 + 1702))) then
								return "potion of withering dreams defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v122()
		local v134 = 1402 - (832 + 570);
		while true do
			if ((v134 == (0 + 0)) or ((389 + 1102) < (2278 - 1634))) then
				if (((340 + 364) < (1783 - (588 + 208))) and v16:Exists()) then
					if (((10020 - 6302) > (3706 - (884 + 916))) and v100.WordofGlory:IsReady() and v65 and not v15:CanAttack(v16) and (v16:HealthPercentage() <= v76)) then
						if (v25(v102.WordofGloryMouseover) or ((2005 - 1047) > (2108 + 1527))) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (((4154 - (232 + 421)) <= (6381 - (1569 + 320))) and (not v14 or not v14:Exists() or not v14:IsInRange(8 + 22))) then
					return;
				end
				v134 = 1 + 0;
			end
			if ((v134 == (3 - 2)) or ((4047 - (316 + 289)) < (6669 - 4121))) then
				if (((133 + 2742) >= (2917 - (666 + 787))) and v14) then
					local v212 = 425 - (360 + 65);
					while true do
						if (((0 + 0) == v212) or ((5051 - (79 + 175)) >= (7714 - 2821))) then
							if ((v100.WordofGlory:IsReady() and v64 and (v15:BuffUp(v100.ShiningLightFreeBuff) or (v113 >= (3 + 0))) and (v14:HealthPercentage() <= v75)) or ((1688 - 1137) > (3982 - 1914))) then
								if (((3013 - (503 + 396)) > (1125 - (92 + 89))) and v25(v102.WordofGloryFocus)) then
									return "word_of_glory defensive focus";
								end
							end
							if ((v100.LayonHands:IsCastable() and v63 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v74) and v15:AffectingCombat()) or ((4387 - 2125) >= (1588 + 1508))) then
								if (v25(v102.LayonHandsFocus) or ((1335 + 920) >= (13851 - 10314))) then
									return "lay_on_hands defensive focus";
								end
							end
							v212 = 1 + 0;
						end
						if ((v212 == (2 - 1)) or ((3348 + 489) < (624 + 682))) then
							if (((8984 - 6034) == (369 + 2581)) and v100.BlessingofSacrifice:IsCastable() and v67 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v78)) then
								if (v25(v102.BlessingofSacrificeFocus) or ((7202 - 2479) < (4542 - (485 + 759)))) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if (((2628 - 1492) >= (1343 - (442 + 747))) and v100.BlessingofProtection:IsCastable() and v66 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v77)) then
								if (v25(v102.BlessingofProtectionFocus) or ((1406 - (832 + 303)) > (5694 - (88 + 858)))) then
									return "blessing_of_protection defensive focus";
								end
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v123()
		local v135 = 0 + 0;
		while true do
			if (((3923 + 817) >= (130 + 3022)) and ((791 - (766 + 23)) == v135)) then
				if ((v100.Judgment:IsReady() and v42) or ((12726 - 10148) >= (4636 - 1246))) then
					if (((107 - 66) <= (5637 - 3976)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment precombat 12";
					end
				end
				break;
			end
			if (((1674 - (1036 + 37)) < (2524 + 1036)) and ((1 - 0) == v135)) then
				if (((185 + 50) < (2167 - (641 + 839))) and v100.Consecration:IsCastable() and v38) then
					if (((5462 - (910 + 3)) > (2939 - 1786)) and v25(v100.Consecration, not v17:IsInRange(1692 - (1466 + 218)))) then
						return "consecration precombat 8";
					end
				end
				if ((v100.AvengersShield:IsCastable() and v36) or ((2149 + 2525) < (5820 - (556 + 592)))) then
					local v213 = 0 + 0;
					while true do
						if (((4476 - (329 + 479)) < (5415 - (174 + 680))) and (v213 == (0 - 0))) then
							if ((v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(v100.AvengersShield)) or ((942 - 487) == (2574 + 1031))) then
								if (v25(v102.AvengersShieldMouseover) or ((3402 - (396 + 343)) == (294 + 3018))) then
									return "avengers_shield mouseover precombat 10";
								end
							end
							if (((5754 - (29 + 1448)) <= (5864 - (135 + 1254))) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
								return "avengers_shield precombat 10";
							end
							break;
						end
					end
				end
				v135 = 7 - 5;
			end
			if ((v135 == (0 - 0)) or ((580 + 290) == (2716 - (389 + 1138)))) then
				if (((2127 - (102 + 472)) <= (2957 + 176)) and (v88 < v112) and v100.LightsJudgment:IsCastable() and v91 and ((v92 and v32) or not v92)) then
					if (v25(v100.LightsJudgment, not v17:IsSpellInRange(v100.LightsJudgment)) or ((1241 + 996) >= (3274 + 237))) then
						return "lights_judgment precombat 4";
					end
				end
				if (((v88 < v112) and v100.ArcaneTorrent:IsCastable() and v91 and ((v92 and v32) or not v92) and (v113 < (1550 - (320 + 1225)))) or ((2356 - 1032) > (1848 + 1172))) then
					if (v25(v100.ArcaneTorrent, not v17:IsInRange(1472 - (157 + 1307))) or ((4851 - (821 + 1038)) == (4692 - 2811))) then
						return "arcane_torrent precombat 6";
					end
				end
				v135 = 1 + 0;
			end
		end
	end
	local function v124()
		if (((5516 - 2410) > (568 + 958)) and v100.AvengersShield:IsCastable() and v36 and (v10.CombatTime() < (4 - 2)) and v15:HasTier(1055 - (834 + 192), 1 + 1)) then
			local v172 = 0 + 0;
			while true do
				if (((65 + 2958) < (5995 - 2125)) and (v172 == (304 - (300 + 4)))) then
					if (((39 + 104) > (193 - 119)) and v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(v100.AvengersShield)) then
						if (((380 - (112 + 250)) < (842 + 1270)) and v25(v102.AvengersShieldMouseover)) then
							return "avengers_shield mouseover cooldowns 2";
						end
					end
					if (((2748 - 1651) <= (933 + 695)) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
						return "avengers_shield cooldowns 2";
					end
					break;
				end
			end
		end
		if (((2395 + 2235) == (3463 + 1167)) and v100.LightsJudgment:IsCastable() and v91 and ((v92 and v32) or not v92) and (v109 >= (1 + 1))) then
			if (((2630 + 910) > (4097 - (1001 + 413))) and v25(v100.LightsJudgment, not v17:IsSpellInRange(v100.LightsJudgment))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if (((10690 - 5896) >= (4157 - (244 + 638))) and v100.AvengingWrath:IsCastable() and v43 and ((v49 and v32) or not v49)) then
			if (((2177 - (627 + 66)) == (4421 - 2937)) and v25(v100.AvengingWrath, not v17:IsInRange(610 - (512 + 90)))) then
				return "avenging_wrath cooldowns 6";
			end
		end
		if (((3338 - (1665 + 241)) < (4272 - (373 + 344))) and v100.Sentinel:IsCastable() and v48 and ((v54 and v32) or not v54)) then
			if (v25(v100.Sentinel, not v17:IsInRange(4 + 4)) or ((282 + 783) > (9437 - 5859))) then
				return "sentinel cooldowns 8";
			end
		end
		local v136 = v110.HandleDPSPotion(v15:BuffUp(v100.AvengingWrathBuff));
		if (v136 or ((8114 - 3319) < (2506 - (35 + 1064)))) then
			return v136;
		end
		if (((1349 + 504) < (10297 - 5484)) and v100.MomentOfGlory:IsCastable() and v47 and ((v53 and v32) or not v53) and ((v15:BuffRemains(v100.SentinelBuff) < (1 + 14)) or (((v10.CombatTime() > (1246 - (298 + 938))) or (v100.Sentinel:CooldownRemains() > (1274 - (233 + 1026))) or (v100.AvengingWrath:CooldownRemains() > (1681 - (636 + 1030)))) and (v100.AvengersShield:CooldownRemains() > (0 + 0)) and (v100.Judgment:CooldownRemains() > (0 + 0)) and (v100.HammerofWrath:CooldownRemains() > (0 + 0))))) then
			if (v25(v100.MomentOfGlory, not v17:IsInRange(1 + 7)) or ((3042 - (55 + 166)) < (472 + 1959))) then
				return "moment_of_glory cooldowns 10";
			end
		end
		if ((v45 and ((v51 and v32) or not v51) and v100.DivineToll:IsReady() and (v108 >= (1 + 2))) or ((10975 - 8101) < (2478 - (36 + 261)))) then
			if (v25(v100.DivineToll, not v17:IsInRange(52 - 22)) or ((4057 - (34 + 1334)) <= (132 + 211))) then
				return "divine_toll cooldowns 12";
			end
		end
		if ((v100.BastionofLight:IsCastable() and v44 and ((v50 and v32) or not v50) and (v15:BuffUp(v100.AvengingWrathBuff) or (v100.AvengingWrath:CooldownRemains() <= (24 + 6)))) or ((3152 - (1035 + 248)) == (2030 - (20 + 1)))) then
			if (v25(v100.BastionofLight, not v17:IsInRange(5 + 3)) or ((3865 - (134 + 185)) < (3455 - (549 + 584)))) then
				return "bastion_of_light cooldowns 14";
			end
		end
	end
	local function v125()
		local v137 = 685 - (314 + 371);
		while true do
			if ((v137 == (0 - 0)) or ((3050 - (478 + 490)) == (2529 + 2244))) then
				if (((4416 - (786 + 386)) > (3417 - 2362)) and v100.Consecration:IsCastable() and v38 and (v15:BuffStack(v100.SanctificationBuff) == (1384 - (1055 + 324)))) then
					if (v25(v100.Consecration, not v17:IsInRange(1348 - (1093 + 247))) or ((2945 + 368) <= (187 + 1591))) then
						return "consecration standard 2";
					end
				end
				if ((v100.ShieldoftheRighteous:IsCastable() and v62 and ((v15:HolyPower() > (7 - 5)) or v15:BuffUp(v100.BastionofLightBuff) or v15:BuffUp(v100.DivinePurposeBuff)) and (v15:BuffDown(v100.SanctificationBuff) or (v15:BuffStack(v100.SanctificationBuff) < (16 - 11)))) or ((4043 - 2622) >= (5286 - 3182))) then
					if (((645 + 1167) <= (12516 - 9267)) and v25(v100.ShieldoftheRighteous)) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if (((5593 - 3970) <= (1476 + 481)) and v100.Judgment:IsReady() and v42 and (v108 > (7 - 4)) and (v15:BuffStack(v100.BulwarkofRighteousFuryBuff) >= (691 - (364 + 324))) and (v15:HolyPower() < (7 - 4))) then
					local v214 = 0 - 0;
					while true do
						if (((1463 + 2949) == (18461 - 14049)) and ((0 - 0) == v214)) then
							if (((5314 - 3564) >= (2110 - (1249 + 19))) and v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment))) then
								return "judgment standard 6";
							end
							if (((3947 + 425) > (7201 - 5351)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
								return "judgment standard 6";
							end
							break;
						end
					end
				end
				v137 = 1087 - (686 + 400);
			end
			if (((183 + 49) < (1050 - (73 + 156))) and (v137 == (1 + 5))) then
				if (((1329 - (721 + 90)) < (11 + 891)) and v100.Consecration:IsCastable() and v38 and (v15:BuffDown(v100.SanctificationEmpowerBuff))) then
					if (((9720 - 6726) > (1328 - (224 + 246))) and v25(v100.Consecration, not v17:IsInRange(12 - 4))) then
						return "consecration standard 38";
					end
				end
				break;
			end
			if (((6 - 2) == v137) or ((682 + 3073) <= (22 + 893))) then
				if (((2899 + 1047) > (7441 - 3698)) and (v88 < v112) and v46 and ((v52 and v32) or not v52) and v100.EyeofTyr:IsCastable() and v100.InmostLight:IsAvailable() and (v108 >= (9 - 6))) then
					if (v25(v100.EyeofTyr, not v17:IsInRange(521 - (203 + 310))) or ((3328 - (1238 + 755)) >= (231 + 3075))) then
						return "eye_of_tyr standard 26";
					end
				end
				if (((6378 - (709 + 825)) > (4150 - 1897)) and v100.BlessedHammer:IsCastable() and v37) then
					if (((657 - 205) == (1316 - (196 + 668))) and v25(v100.BlessedHammer, not v17:IsInRange(31 - 23))) then
						return "blessed_hammer standard 28";
					end
				end
				if ((v100.HammeroftheRighteous:IsCastable() and v40) or ((9439 - 4882) < (2920 - (171 + 662)))) then
					if (((3967 - (4 + 89)) == (13578 - 9704)) and v25(v100.HammeroftheRighteous, not v17:IsInRange(3 + 5))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				v137 = 21 - 16;
			end
			if ((v137 == (1 + 1)) or ((3424 - (35 + 1451)) > (6388 - (28 + 1425)))) then
				if ((v100.AvengersShield:IsCastable() and v36 and ((v109 > (1995 - (941 + 1052))) or v15:BuffUp(v100.MomentOfGloryBuff))) or ((4080 + 175) < (4937 - (822 + 692)))) then
					local v215 = 0 - 0;
					while true do
						if (((685 + 769) <= (2788 - (45 + 252))) and (v215 == (0 + 0))) then
							if ((v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(v100.AvengersShield)) or ((1431 + 2726) <= (6821 - 4018))) then
								if (((5286 - (114 + 319)) >= (4280 - 1298)) and v25(v102.AvengersShieldMouseover)) then
									return "avengers_shield mouseover standard 14";
								end
							end
							if (((5296 - 1162) > (2141 + 1216)) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
								return "avengers_shield standard 14";
							end
							break;
						end
					end
				end
				if ((v45 and ((v51 and v32) or not v51) and v100.DivineToll:IsReady()) or ((5090 - 1673) < (5309 - 2775))) then
					if (v25(v100.DivineToll, not v17:IsInRange(1993 - (556 + 1407))) or ((3928 - (741 + 465)) <= (629 - (170 + 295)))) then
						return "divine_toll standard 16";
					end
				end
				if ((v100.AvengersShield:IsCastable() and v36) or ((1269 + 1139) < (1938 + 171))) then
					local v216 = 0 - 0;
					while true do
						if ((v216 == (0 + 0)) or ((22 + 11) == (824 + 631))) then
							if ((v16:Exists() and v16 and v15:CanAttack(v16) and v16:IsSpellInRange(v100.AvengersShield)) or ((1673 - (957 + 273)) >= (1074 + 2941))) then
								if (((1354 + 2028) > (632 - 466)) and v25(v102.AvengersShieldMouseover)) then
									return "avengers_shield mouseover standard 18";
								end
							end
							if (v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield)) or ((737 - 457) == (9343 - 6284))) then
								return "avengers_shield standard 18";
							end
							break;
						end
					end
				end
				v137 = 14 - 11;
			end
			if (((3661 - (389 + 1391)) > (812 + 481)) and (v137 == (1 + 0))) then
				if (((5365 - 3008) == (3308 - (783 + 168))) and v100.Judgment:IsReady() and v42 and v15:BuffDown(v100.SanctificationEmpowerBuff) and v15:HasTier(103 - 72, 2 + 0)) then
					local v217 = 311 - (309 + 2);
					while true do
						if (((377 - 254) == (1335 - (1090 + 122))) and (v217 == (0 + 0))) then
							if (v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment)) or ((3546 - 2490) >= (2322 + 1070))) then
								return "judgment standard 8";
							end
							if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((2199 - (628 + 490)) < (193 + 882))) then
								return "judgment standard 8";
							end
							break;
						end
					end
				end
				if ((v100.HammerofWrath:IsReady() and v41) or ((2596 - 1547) >= (20254 - 15822))) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((5542 - (431 + 343)) <= (1708 - 862))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if ((v100.Judgment:IsReady() and v42 and ((v100.Judgment:Charges() >= (5 - 3)) or (v100.Judgment:FullRechargeTime() <= v15:GCD()))) or ((2653 + 705) <= (182 + 1238))) then
					local v218 = 1695 - (556 + 1139);
					while true do
						if ((v218 == (15 - (6 + 9))) or ((685 + 3054) <= (1540 + 1465))) then
							if (v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment)) or ((1828 - (28 + 141)) >= (827 + 1307))) then
								return "judgment standard 12";
							end
							if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((4024 - 764) < (1668 + 687))) then
								return "judgment standard 12";
							end
							break;
						end
					end
				end
				v137 = 1319 - (486 + 831);
			end
			if ((v137 == (12 - 7)) or ((2354 - 1685) == (798 + 3425))) then
				if ((v100.CrusaderStrike:IsCastable() and v39) or ((5349 - 3657) < (1851 - (668 + 595)))) then
					if (v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike)) or ((4317 + 480) < (737 + 2914))) then
						return "crusader_strike standard 32";
					end
				end
				if (((v88 < v112) and v46 and ((v52 and v32) or not v52) and v100.EyeofTyr:IsCastable() and not v100.InmostLight:IsAvailable()) or ((11391 - 7214) > (5140 - (23 + 267)))) then
					if (v25(v100.EyeofTyr, not v17:IsInRange(1952 - (1129 + 815))) or ((787 - (371 + 16)) > (2861 - (1326 + 424)))) then
						return "eye_of_tyr standard 34";
					end
				end
				if (((5778 - 2727) > (3672 - 2667)) and v100.ArcaneTorrent:IsCastable() and v91 and ((v92 and v32) or not v92) and (v113 < (123 - (88 + 30)))) then
					if (((4464 - (720 + 51)) <= (9747 - 5365)) and v25(v100.ArcaneTorrent, not v17:IsInRange(1784 - (421 + 1355)))) then
						return "arcane_torrent standard 36";
					end
				end
				v137 = 9 - 3;
			end
			if ((v137 == (2 + 1)) or ((4365 - (286 + 797)) > (14988 - 10888))) then
				if ((v100.HammerofWrath:IsReady() and v41) or ((5929 - 2349) < (3283 - (397 + 42)))) then
					if (((28 + 61) < (5290 - (24 + 776))) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if ((v100.Judgment:IsReady() and v42) or ((7676 - 2693) < (2593 - (222 + 563)))) then
					if (((8436 - 4607) > (2714 + 1055)) and v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment standard 22";
					end
					if (((1675 - (23 + 167)) <= (4702 - (690 + 1108))) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment standard 22";
					end
				end
				if (((1541 + 2728) == (3522 + 747)) and v100.Consecration:IsCastable() and v38 and v15:BuffDown(v100.ConsecrationBuff) and ((v15:BuffStack(v100.SanctificationBuff) < (853 - (40 + 808))) or not v15:HasTier(6 + 25, 7 - 5))) then
					if (((370 + 17) <= (1472 + 1310)) and v25(v100.Consecration, not v17:IsInRange(5 + 3))) then
						return "consecration standard 24";
					end
				end
				v137 = 575 - (47 + 524);
			end
		end
	end
	local function v126()
		local v138 = 0 + 0;
		while true do
			if (((13 - 8) == v138) or ((2839 - 940) <= (2091 - 1174))) then
				v54 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if ((v138 == (1726 - (1165 + 561))) or ((129 + 4183) <= (2713 - 1837))) then
				v34 = EpicSettings.Settings['swapAuras'];
				v35 = EpicSettings.Settings['useWeapon'];
				v36 = EpicSettings.Settings['useAvengersShield'];
				v37 = EpicSettings.Settings['useBlessedHammer'];
				v138 = 1 + 0;
			end
			if (((2711 - (341 + 138)) <= (701 + 1895)) and (v138 == (1 - 0))) then
				v38 = EpicSettings.Settings['useConsecration'];
				v39 = EpicSettings.Settings['useCrusaderStrike'];
				v40 = EpicSettings.Settings['useHammeroftheRighteous'];
				v41 = EpicSettings.Settings['useHammerofWrath'];
				v138 = 328 - (89 + 237);
			end
			if (((6739 - 4644) < (7760 - 4074)) and (v138 == (884 - (581 + 300)))) then
				v46 = EpicSettings.Settings['useEyeofTyr'];
				v47 = EpicSettings.Settings['useMomentOfGlory'];
				v48 = EpicSettings.Settings['useSentinel'];
				v49 = EpicSettings.Settings['avengingWrathWithCD'];
				v138 = 1224 - (855 + 365);
			end
			if ((v138 == (4 - 2)) or ((521 + 1074) >= (5709 - (1030 + 205)))) then
				v42 = EpicSettings.Settings['useJudgment'];
				v43 = EpicSettings.Settings['useAvengingWrath'];
				v44 = EpicSettings.Settings['useBastionofLight'];
				v45 = EpicSettings.Settings['useDivineToll'];
				v138 = 3 + 0;
			end
			if ((v138 == (4 + 0)) or ((4905 - (156 + 130)) < (6548 - 3666))) then
				v50 = EpicSettings.Settings['bastionofLightWithCD'];
				v51 = EpicSettings.Settings['divineTollWithCD'];
				v52 = EpicSettings.Settings['eyeofTyrWithCD'];
				v53 = EpicSettings.Settings['momentOfGloryWithCD'];
				v138 = 8 - 3;
			end
		end
	end
	local function v127()
		v55 = EpicSettings.Settings['useRebuke'];
		v56 = EpicSettings.Settings['useHammerofJustice'];
		v57 = EpicSettings.Settings['useArdentDefender'];
		v58 = EpicSettings.Settings['useDivineShield'];
		v59 = EpicSettings.Settings['useGuardianofAncientKings'];
		v60 = EpicSettings.Settings['useLayOnHands'];
		v61 = EpicSettings.Settings['useWordofGloryPlayer'];
		v62 = EpicSettings.Settings['useShieldoftheRighteous'];
		v63 = EpicSettings.Settings['useLayOnHandsFocus'];
		v64 = EpicSettings.Settings['useWordofGloryFocus'];
		v65 = EpicSettings.Settings['useWordofGloryMouseover'];
		v66 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
		v67 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
		v68 = EpicSettings.Settings['ardentDefenderHP'];
		v69 = EpicSettings.Settings['divineShieldHP'];
		v70 = EpicSettings.Settings['guardianofAncientKingsHP'];
		v71 = EpicSettings.Settings['layonHandsHP'];
		v72 = EpicSettings.Settings['wordofGloryHP'];
		v73 = EpicSettings.Settings['shieldoftheRighteousHP'];
		v74 = EpicSettings.Settings['layOnHandsFocusHP'];
		v75 = EpicSettings.Settings['wordofGloryFocusHP'];
		v76 = EpicSettings.Settings['wordofGloryMouseoverHP'];
		v77 = EpicSettings.Settings['blessingofProtectionFocusHP'];
		v78 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
		v79 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v80 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
	end
	local function v128()
		local v165 = 0 - 0;
		while true do
			if ((v165 == (1 + 2)) or ((172 + 122) >= (4900 - (10 + 59)))) then
				v92 = EpicSettings.Settings['racialsWithCD'];
				v94 = EpicSettings.Settings['useHealthstone'];
				v93 = EpicSettings.Settings['useHealingPotion'];
				v165 = 2 + 2;
			end
			if (((9992 - 7963) <= (4247 - (671 + 492))) and (v165 == (0 + 0))) then
				v88 = EpicSettings.Settings['fightRemainsCheck'] or (1215 - (369 + 846));
				v85 = EpicSettings.Settings['InterruptWithStun'];
				v86 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v165 = 1 + 0;
			end
			if ((v165 == (6 + 0)) or ((3982 - (1036 + 909)) == (1925 + 495))) then
				v99 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
				break;
			end
			if (((4661 - (11 + 192)) > (1973 + 1931)) and (v165 == (179 - (135 + 40)))) then
				v96 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v95 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v97 = EpicSettings.Settings['HealingPotionName'] or "";
				v165 = 10 - 5;
			end
			if (((653 - 217) >= (299 - (50 + 126))) and (v165 == (2 - 1))) then
				v87 = EpicSettings.Settings['InterruptThreshold'];
				v82 = EpicSettings.Settings['DispelDebuffs'];
				v81 = EpicSettings.Settings['DispelBuffs'];
				v165 = 1 + 1;
			end
			if (((1913 - (1233 + 180)) < (2785 - (522 + 447))) and (v165 == (1423 - (107 + 1314)))) then
				v89 = EpicSettings.Settings['useTrinkets'];
				v91 = EpicSettings.Settings['useRacials'];
				v90 = EpicSettings.Settings['trinketsWithCD'];
				v165 = 2 + 1;
			end
			if (((10890 - 7316) == (1518 + 2056)) and (v165 == (9 - 4))) then
				v83 = EpicSettings.Settings['handleAfflicted'];
				v84 = EpicSettings.Settings['HandleIncorporeal'];
				v98 = EpicSettings.Settings['HealOOC'];
				v165 = 23 - 17;
			end
		end
	end
	local function v129()
		local v166 = 1910 - (716 + 1194);
		while true do
			if (((4 + 217) < (42 + 348)) and (v166 == (506 - (74 + 429)))) then
				v105 = v15:IsTankingAoE(14 - 6) or v15:IsTanking(v17);
				if ((not v15:AffectingCombat() and v15:IsMounted()) or ((1097 + 1116) <= (3252 - 1831))) then
					if (((2164 + 894) < (14983 - 10123)) and v100.CrusaderAura:IsCastable() and (v15:BuffDown(v100.CrusaderAura)) and v34) then
						if (v25(v100.CrusaderAura) or ((3204 - 1908) >= (4879 - (279 + 154)))) then
							return "crusader_aura";
						end
					end
				end
				if (v110.TargetIsValid() or v15:AffectingCombat() or ((2171 - (454 + 324)) > (3532 + 957))) then
					local v219 = 17 - (12 + 5);
					while true do
						if ((v219 == (0 + 0)) or ((11272 - 6848) < (10 + 17))) then
							v111 = v10.BossFightRemains(nil, true);
							v112 = v111;
							v219 = 1094 - (277 + 816);
						end
						if ((v219 == (4 - 3)) or ((3180 - (1058 + 125)) > (716 + 3099))) then
							if (((4440 - (815 + 160)) > (8207 - 6294)) and (v112 == (26375 - 15264))) then
								v112 = v10.FightRemains(v106, false);
							end
							v113 = v15:HolyPower();
							break;
						end
					end
				end
				if (((175 + 558) < (5317 - 3498)) and (v15:AffectingCombat() or (v82 and v100.CleanseToxins:IsAvailable()))) then
					local v220 = 1898 - (41 + 1857);
					local v221;
					while true do
						if ((v220 == (1893 - (1222 + 671))) or ((11359 - 6964) == (6834 - 2079))) then
							v221 = v82 and v100.CleanseToxins:IsReady() and v33;
							v29 = v110.FocusUnit(v221, nil, 1202 - (229 + 953), nil, 1799 - (1111 + 663), v100.WordofGlory);
							v220 = 1580 - (874 + 705);
						end
						if ((v220 == (1 + 0)) or ((2588 + 1205) < (4923 - 2554))) then
							if (v29 or ((115 + 3969) == (944 - (642 + 37)))) then
								return v29;
							end
							break;
						end
					end
				end
				v166 = 1 + 3;
			end
			if (((698 + 3660) == (10941 - 6583)) and (v166 == (461 - (233 + 221)))) then
				if (v105 or ((7256 - 4118) < (875 + 118))) then
					v29 = v121();
					if (((4871 - (718 + 823)) > (1462 + 861)) and v29) then
						return v29;
					end
				end
				if ((v110.TargetIsValid() and not v15:AffectingCombat() and v30) or ((4431 - (266 + 539)) == (11293 - 7304))) then
					local v222 = 1225 - (636 + 589);
					while true do
						if (((0 - 0) == v222) or ((1888 - 972) == (2117 + 554))) then
							v29 = v123();
							if (((99 + 173) == (1287 - (657 + 358))) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (((11250 - 7001) <= (11024 - 6185)) and v110.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) then
					local v223 = 1187 - (1151 + 36);
					while true do
						if (((2682 + 95) < (842 + 2358)) and (v223 == (2 - 1))) then
							v29 = v125();
							if (((1927 - (1552 + 280)) < (2791 - (64 + 770))) and v29) then
								return v29;
							end
							v223 = 2 + 0;
						end
						if (((1874 - 1048) < (305 + 1412)) and (v223 == (1243 - (157 + 1086)))) then
							if (((2853 - 1427) >= (4839 - 3734)) and (v88 < v112)) then
								v29 = v124();
								if (((4224 - 1470) <= (4611 - 1232)) and v29) then
									return v29;
								end
								if ((v32 and v101.FyralathTheDreamrender:IsEquippedAndReady() and v35) or ((4746 - (599 + 220)) == (2813 - 1400))) then
									if (v25(v102.UseWeapon) or ((3085 - (1813 + 118)) <= (577 + 211))) then
										return "Fyralath The Dreamrender used";
									end
								end
							end
							if ((v89 and ((v32 and v90) or not v90) and v17:IsInRange(1225 - (841 + 376))) or ((2301 - 658) > (785 + 2594))) then
								local v229 = 0 - 0;
								while true do
									if ((v229 == (859 - (464 + 395))) or ((7193 - 4390) > (2185 + 2364))) then
										v29 = v120();
										if (v29 or ((1057 - (467 + 370)) >= (6244 - 3222))) then
											return v29;
										end
										break;
									end
								end
							end
							v223 = 1 + 0;
						end
						if (((9673 - 6851) == (441 + 2381)) and (v223 == (4 - 2))) then
							if (v25(v100.Pool) or ((1581 - (150 + 370)) == (3139 - (74 + 1208)))) then
								return "Wait/Pool Resources";
							end
							break;
						end
					end
				end
				break;
			end
			if (((6788 - 4028) > (6468 - 5104)) and (v166 == (3 + 1))) then
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((5292 - (14 + 376)) <= (6235 - 2640))) then
					if (v15:AffectingCombat() or ((2493 + 1359) == (258 + 35))) then
						if (v100.Intercession:IsCastable() or ((1487 + 72) == (13443 - 8855))) then
							if (v25(v100.Intercession, not v17:IsInRange(23 + 7), true) or ((4562 - (23 + 55)) == (1867 - 1079))) then
								return "intercession target";
							end
						end
					elseif (((3049 + 1519) >= (3509 + 398)) and v100.Redemption:IsCastable()) then
						if (((1931 - 685) < (1092 + 2378)) and v25(v100.Redemption, not v17:IsInRange(931 - (652 + 249)), true)) then
							return "redemption target";
						end
					end
				end
				if (((10886 - 6818) >= (2840 - (708 + 1160))) and v100.Redemption:IsCastable() and v100.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
					if (((1338 - 845) < (7097 - 3204)) and v25(v102.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (v15:AffectingCombat() or ((1500 - (10 + 17)) >= (749 + 2583))) then
					if ((v100.Intercession:IsCastable() and (v15:HolyPower() >= (1735 - (1400 + 332))) and v100.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((7769 - 3718) <= (3065 - (242 + 1666)))) then
						if (((259 + 345) < (1056 + 1825)) and v25(v102.IntercessionMouseover)) then
							return "Intercession";
						end
					end
				end
				if ((v33 and v82) or ((768 + 132) == (4317 - (850 + 90)))) then
					local v224 = 0 - 0;
					while true do
						if (((5849 - (360 + 1030)) > (524 + 67)) and (v224 == (0 - 0))) then
							v29 = v110.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 55 - 15, 1686 - (909 + 752), v100.WordofGlory, 1225 - (109 + 1114));
							if (((6221 - 2823) >= (933 + 1462)) and v29) then
								return v29;
							end
							v224 = 243 - (6 + 236);
						end
						if ((v224 == (1 + 0)) or ((1758 + 425) >= (6659 - 3835))) then
							if (((3381 - 1445) == (3069 - (1076 + 57))) and v100.BlessingofFreedom:IsReady() and v110.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
								if (v25(v102.BlessingofFreedomFocus) or ((795 + 4037) < (5002 - (579 + 110)))) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
					end
				end
				v166 = 1 + 4;
			end
			if (((3615 + 473) > (2057 + 1817)) and (v166 == (413 - (174 + 233)))) then
				if (((12100 - 7768) == (7603 - 3271)) and not v15:AffectingCombat()) then
					if (((1779 + 2220) >= (4074 - (663 + 511))) and v100.DevotionAura:IsCastable() and (v116()) and v34) then
						if (v25(v100.DevotionAura) or ((2253 + 272) > (883 + 3181))) then
							return "devotion_aura";
						end
					end
				end
				if (((13475 - 9104) == (2647 + 1724)) and v83) then
					local v225 = 0 - 0;
					while true do
						if ((v225 == (0 - 0)) or ((127 + 139) > (9704 - 4718))) then
							if (((1419 + 572) >= (85 + 840)) and v79) then
								v29 = v110.HandleAfflicted(v100.CleanseToxins, v102.CleanseToxinsMouseover, 762 - (478 + 244));
								if (((972 - (440 + 77)) < (934 + 1119)) and v29) then
									return v29;
								end
							end
							if ((v15:BuffUp(v100.ShiningLightFreeBuff) and v80) or ((3022 - 2196) == (6407 - (655 + 901)))) then
								local v230 = 0 + 0;
								while true do
									if (((141 + 42) == (124 + 59)) and (v230 == (0 - 0))) then
										v29 = v110.HandleAfflicted(v100.WordofGlory, v102.WordofGloryMouseover, 1485 - (695 + 750), true);
										if (((3957 - 2798) <= (2759 - 971)) and v29) then
											return v29;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (v84 or ((14104 - 10597) > (4669 - (285 + 66)))) then
					v29 = v110.HandleIncorporeal(v100.Repentance, v102.RepentanceMouseOver, 69 - 39, true);
					if (v29 or ((4385 - (682 + 628)) <= (478 + 2487))) then
						return v29;
					end
					v29 = v110.HandleIncorporeal(v100.TurnEvil, v102.TurnEvilMouseOver, 329 - (176 + 123), true);
					if (((571 + 794) <= (1459 + 552)) and v29) then
						return v29;
					end
				end
				if ((v82 and v33) or ((3045 - (239 + 30)) > (972 + 2603))) then
					local v226 = 0 + 0;
					while true do
						if ((v226 == (0 - 0)) or ((7968 - 5414) == (5119 - (306 + 9)))) then
							if (((8992 - 6415) == (449 + 2128)) and v14) then
								local v231 = 0 + 0;
								while true do
									if ((v231 == (0 + 0)) or ((16 - 10) >= (3264 - (1140 + 235)))) then
										v29 = v118();
										if (((323 + 183) <= (1735 + 157)) and v29) then
											return v29;
										end
										break;
									end
								end
							end
							if ((v16 and v16:Exists() and not v15:CanAttack(v16) and v16:IsAPlayer() and (v110.UnitHasCurseDebuff(v16) or v110.UnitHasPoisonDebuff(v16) or v110.UnitHasDispellableDebuffByPlayer(v16))) or ((516 + 1492) > (2270 - (33 + 19)))) then
								if (((137 + 242) <= (12429 - 8282)) and v100.CleanseToxins:IsReady()) then
									if (v25(v102.CleanseToxinsMouseover) or ((1989 + 2525) <= (1978 - 969))) then
										return "cleanse_toxins dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				v166 = 7 + 0;
			end
			if ((v166 == (691 - (586 + 103))) or ((319 + 3177) == (3669 - 2477))) then
				v106 = v15:GetEnemiesInMeleeRange(1496 - (1309 + 179));
				v107 = v15:GetEnemiesInRange(54 - 24);
				if (v31 or ((91 + 117) == (7946 - 4987))) then
					v108 = #v106;
					v109 = #v107;
				else
					local v227 = 0 + 0;
					while true do
						if (((9086 - 4809) >= (2615 - 1302)) and ((609 - (295 + 314)) == v227)) then
							v108 = 2 - 1;
							v109 = 1963 - (1300 + 662);
							break;
						end
					end
				end
				v104 = v15:ActiveMitigationNeeded();
				v166 = 9 - 6;
			end
			if (((4342 - (1178 + 577)) < (1649 + 1525)) and (v166 == (14 - 9))) then
				v29 = v122();
				if (v29 or ((5525 - (851 + 554)) <= (1944 + 254))) then
					return v29;
				end
				v29 = v119();
				if (v29 or ((4426 - 2830) == (1863 - 1005))) then
					return v29;
				end
				v166 = 308 - (115 + 187);
			end
			if (((2466 + 754) == (3049 + 171)) and (v166 == (3 - 2))) then
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v33 = EpicSettings.Toggles['dispel'];
				if (v15:IsDeadOrGhost() or ((2563 - (160 + 1001)) > (3167 + 453))) then
					return v29;
				end
				v166 = 2 + 0;
			end
			if (((5268 - 2694) == (2932 - (237 + 121))) and ((897 - (525 + 372)) == v166)) then
				v127();
				v126();
				v128();
				v30 = EpicSettings.Toggles['ooc'];
				v166 = 1 - 0;
			end
		end
	end
	local function v130()
		local v167 = 0 - 0;
		while true do
			if (((1940 - (96 + 46)) < (3534 - (643 + 134))) and (v167 == (0 + 0))) then
				v21.Print("Protection Paladin by Epic. Supported by xKaneto");
				v114();
				break;
			end
		end
	end
	v21.SetAPL(157 - 91, v129, v130);
end;
return v0["Epix_Paladin_Protection.lua"]();

