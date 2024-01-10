local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((3435 + 507) <= (5389 - (108 + 294))) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Monk_Mistweaver.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Pet;
	local v14 = v11.Target;
	local v15 = v11.MouseOver;
	local v16 = v11.Focus;
	local v17 = v9.Spell;
	local v18 = v9.MultiSpell;
	local v19 = v9.Item;
	local v20 = v9.Utils;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Press;
	local v24 = v21.Macro;
	local v25 = v21.Commons.Everyone.num;
	local v26 = v21.Commons.Everyone.bool;
	local v27;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = false;
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
	local v46 = v17.Monk.Mistweaver;
	local v47 = v19.Monk.Mistweaver;
	local v48 = v24.Monk.Mistweaver;
	local v49 = {};
	local v50;
	local v51;
	local v52;
	local v53 = {{v46.LegSweep,"Cast Leg Sweep (Stun)",function()
		return true;
	end},{v46.Paralysis,"Cast Paralysis (Stun)",function()
		return true;
	end}};
	local v54 = v21.Commons.Everyone;
	local v55 = v21.Commons.Monk;
	local function v56()
		if (((11451 - 6867) == (4079 + 505)) and v46.ImprovedPurifySpirit:IsAvailable()) then
			v54.DispellableDebuffs = v20.MergeTable(v54.DispellableMagicDebuffs, v54.DispellableCurseDebuffs);
		else
			v54.DispellableDebuffs = v54.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v56();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v57()
		local v65 = 700 - (271 + 429);
		while true do
			if (((3656 + 323) >= (3168 - (1408 + 92))) and (v65 == (1086 - (461 + 625)))) then
				if (((1856 - (993 + 295)) > (23 + 405)) and v46.DampenHarm:IsCastable() and v12:BuffDown(v46.FortifyingBrew) and (v12:HealthPercentage() <= Settings.Mistweaver.DampenHarmHP)) then
					if (((2505 - (418 + 753)) <= (1757 + 2856)) and v22(v46.DampenHarm, nil, Settings.Mistweaver.DisplayStyle.DampenHarm)) then
						return "dampen_harm defensives 2";
					end
				end
				if ((v46.FortifyingBrew:IsCastable() and v12:BuffDown(v46.DampenHarm) and (v12:HealthPercentage() <= Settings.Mistweaver.FortifyingBrewHP)) or ((193 + 1672) >= (594 + 1435))) then
					if (((1251 + 3699) >= (2145 - (406 + 123))) and v22(v46.FortifyingBrew, Settings.Mistweaver.DisplayStyle.FortifyingBrew)) then
						return "fortifying_brew defensives 4";
					end
				end
				break;
			end
		end
	end
	local function v58()
		if (((3494 - (1749 + 20)) == (410 + 1315)) and v46.ChiBurst:IsCastable()) then
			if (((2781 - (1249 + 73)) <= (886 + 1596)) and v22(v46.ChiBurst, nil, nil, not v14:IsInRange(1185 - (466 + 679)))) then
				return "chi_burst precombat 4";
			end
		end
		if (v46.ChiWave:IsCastable() or ((6484 - 3788) >= (12962 - 8430))) then
			if (((2948 - (106 + 1794)) >= (17 + 35)) and v22(v46.ChiWave, nil, nil, not v14:IsInRange(11 + 29))) then
				return "chi_wave precombat 6";
			end
		end
	end
	local function v59()
		if (((8733 - 5775) < (12193 - 7690)) and v46.SpinningCraneKick:IsCastable()) then
			if (v22(v46.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(122 - (4 + 110))) or ((3319 - (57 + 527)) == (2736 - (41 + 1386)))) then
				return "spinning_crane_kick aoe 2";
			end
		end
		if (v46.ChiWave:IsCastable() or ((4233 - (17 + 86)) <= (2006 + 949))) then
			if (v22(v46.ChiWave, nil, nil, not v14:IsInRange(89 - 49)) or ((5687 - 3723) <= (1506 - (122 + 44)))) then
				return "chi_wave aoe 4";
			end
		end
		if (((4316 - 1817) == (8290 - 5791)) and v46.ChiBurst:IsCastable()) then
			if (v22(v46.ChiBurst, nil, nil, not v14:IsInRange(33 + 7)) or ((327 + 1928) < (43 - 21))) then
				return "chi_burst aoe 6";
			end
		end
	end
	local function v60()
		local v66 = 65 - (30 + 35);
		while true do
			if ((v66 == (1 + 0)) or ((2343 - (1043 + 214)) >= (5311 - 3906))) then
				if ((v46.BlackoutKick:IsCastable() and (v12:BuffStack(v46.TeachingsOfTheMonasteryBuff) == (1213 - (323 + 889))) and (v46.RisingSunKick:CooldownRemains() < (31 - 19))) or ((2949 - (361 + 219)) == (746 - (53 + 267)))) then
					if (v22(v46.BlackoutKick, nil, nil, not v14:IsInMeleeRange(2 + 3)) or ((3489 - (15 + 398)) > (4165 - (18 + 964)))) then
						return "blackout_kick st 6";
					end
				end
				if (((4524 - 3322) > (613 + 445)) and v46.ChiWave:IsCastable()) then
					if (((2339 + 1372) > (4205 - (20 + 830))) and v22(v46.ChiWave, nil, nil, not v14:IsInRange(32 + 8))) then
						return "chi_wave st 8";
					end
				end
				v66 = 128 - (116 + 10);
			end
			if ((v66 == (0 + 0)) or ((1644 - (542 + 196)) >= (4777 - 2548))) then
				if (((377 + 911) > (636 + 615)) and v46.ThunderFocusTea:IsCastable()) then
					if (v22(v46.ThunderFocusTea, Settings.Mistweaver.OffGCDasOffGCD.ThunderFocusTea) or ((1625 + 2888) < (8832 - 5480))) then
						return "thunder_focus_tea st 2";
					end
				end
				if (v46.RisingSunKick:IsReady() or ((5294 - 3229) >= (4747 - (1126 + 425)))) then
					if (v22(v46.RisingSunKick, nil, nil, not v14:IsInMeleeRange(410 - (118 + 287))) or ((17150 - 12774) <= (2602 - (118 + 1003)))) then
						return "rising_sun_kick st 4";
					end
				end
				v66 = 2 - 1;
			end
			if ((v66 == (379 - (142 + 235))) or ((15387 - 11995) >= (1032 + 3709))) then
				if (((4302 - (553 + 424)) >= (4072 - 1918)) and v46.ChiBurst:IsCastable()) then
					if (v22(v46.ChiBurst, nil, nil, not v14:IsInRange(36 + 4)) or ((1285 + 10) >= (1883 + 1350))) then
						return "chi_burst st 10";
					end
				end
				if (((1861 + 2516) > (938 + 704)) and v46.TigerPalm:IsCastable() and ((v12:BuffStack(v46.TeachingsOfTheMonasteryBuff) < (6 - 3)) or (v12:BuffRemains(v46.TeachingsOfTheMonasteryBuff) < (5 - 3)))) then
					if (((10574 - 5851) > (395 + 961)) and v22(v46.TigerPalm, nil, nil, not v14:IsInMeleeRange(24 - 19))) then
						return "tiger_palm st 12";
					end
				end
				break;
			end
		end
	end
	local function v61()
	end
	local function v62()
	end
	local function v63()
		v61();
		v62();
		v28 = EpicSettings.Toggles['ooc'];
		v29 = EpicSettings.Toggles['cds'];
		v30 = EpicSettings.Toggles['dispel'];
		v31 = EpicSettings.Toggles['healing'];
		v32 = EpicSettings.Toggles['dps'];
		if (v12:IsDeadOrGhost() or ((4889 - (239 + 514)) <= (1206 + 2227))) then
			return;
		end
		v50 = v12:GetEnemiesInMeleeRange(1334 - (797 + 532));
		v51 = v12:GetEnemiesInMeleeRange(6 + 2);
		if (((1433 + 2812) <= (10888 - 6257)) and v59) then
			v52 = #v51;
		else
			v52 = 1203 - (373 + 829);
		end
		if (((5007 - (476 + 255)) >= (5044 - (369 + 761))) and (v54.TargetIsValid() or v12:AffectingCombat())) then
			local v75 = 0 + 0;
			while true do
				if (((359 - 161) <= (8271 - 3906)) and (v75 == (239 - (64 + 174)))) then
					FightRemains = BossFightRemains;
					if (((682 + 4100) > (6924 - 2248)) and (FightRemains == (11447 - (144 + 192)))) then
						FightRemains = v9.FightRemains(Enemies40y, false);
					end
					break;
				end
				if (((5080 - (42 + 174)) > (1651 + 546)) and (v75 == (0 + 0))) then
					Enemies40y = v12:GetEnemiesInRange(17 + 23);
					BossFightRemains = v9.BossFightRemains(nil, true);
					v75 = 1505 - (363 + 1141);
				end
			end
		end
		if (v12:AffectingCombat() or v28 or ((5280 - (1183 + 397)) == (7632 - 5125))) then
			local v76 = 0 + 0;
			local v77;
			while true do
				if (((3345 + 1129) >= (2249 - (1913 + 62))) and (v76 == (1 + 0))) then
					if (v27 or ((5013 - 3119) <= (3339 - (565 + 1368)))) then
						return v27;
					end
					if (((5911 - 4339) >= (3192 - (1477 + 184))) and v30) then
						if ((v16 and v42) or ((6386 - 1699) < (4233 + 309))) then
							if (((4147 - (564 + 292)) > (2876 - 1209)) and v46.PurifySpirit:IsReady() and v54.DispellableFriendlyUnit(75 - 50)) then
								if (v23(v48.PurifySpiritFocus, not v16:IsSpellInRange(v46.PurifySpirit)) or ((1177 - (244 + 60)) == (1564 + 470))) then
									return "purify_spirit dispel";
								end
							end
						end
					end
					break;
				end
				if ((v76 == (476 - (41 + 435))) or ((3817 - (938 + 63)) < (9 + 2))) then
					v77 = v42 and v46.PurifySpirit:IsReady() and v30;
					v27 = v54.FocusUnit(v77, nil, nil, nil);
					v76 = 1126 - (936 + 189);
				end
			end
		end
		if (((1218 + 2481) < (6319 - (1565 + 48))) and not v12:AffectingCombat()) then
			if (((1635 + 1011) >= (2014 - (782 + 356))) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) then
				local v79 = v54.DeadFriendlyUnitsCount();
				if (((881 - (176 + 91)) <= (8295 - 5111)) and (v79 > (1 - 0))) then
					if (((4218 - (975 + 117)) == (5001 - (157 + 1718))) and v23(v46.AncestralVision, nil)) then
						return "ancestral_vision";
					end
				elseif (v23(v48.AncestralSpiritMouseover, not v14:IsInRange(33 + 7)) or ((7763 - 5576) >= (16936 - 11982))) then
					return "ancestral_spirit";
				end
			end
		end
		if ((not v12:AffectingCombat() and v28) or ((4895 - (697 + 321)) == (9738 - 6163))) then
			v27 = v58();
			if (((1497 - 790) > (1456 - 824)) and v27) then
				return v27;
			end
		end
		if (v28 or v12:AffectingCombat() or ((213 + 333) >= (5028 - 2344))) then
			v27 = HandleAffixes();
			if (((3927 - 2462) <= (5528 - (322 + 905))) and v27) then
				return v27;
			end
			if (((2315 - (602 + 9)) > (2614 - (449 + 740))) and v31) then
				local v80 = 872 - (826 + 46);
				while true do
					if ((v80 == (947 - (245 + 702))) or ((2170 - 1483) == (1362 + 2872))) then
						v27 = HealingAOE();
						if (v27 or ((5228 - (260 + 1638)) < (1869 - (382 + 58)))) then
							return v27;
						end
						v80 = 3 - 2;
					end
					if (((954 + 193) >= (691 - 356)) and (v80 == (2 - 1))) then
						v27 = HealingST();
						if (((4640 - (902 + 303)) > (4604 - 2507)) and v27) then
							return v27;
						end
						break;
					end
				end
			end
			if ((FightRemains > FightRemainsCheck) or ((9080 - 5310) >= (348 + 3693))) then
				local v81 = 1690 - (1121 + 569);
				while true do
					if (((214 - (22 + 192)) == v81) or ((4474 - (483 + 200)) <= (3074 - (1404 + 59)))) then
						v27 = Cooldowns();
						if (v27 or ((12528 - 7950) <= (2698 - 690))) then
							return v27;
						end
						break;
					end
				end
			end
		end
		if (((1890 - (468 + 297)) <= (2638 - (334 + 228))) and (v28 or v12:AffectingCombat()) and v54.TargetIsValid()) then
			local v78 = 0 - 0;
			while true do
				if ((v78 == (0 - 0)) or ((1347 - 604) >= (1250 + 3149))) then
					v27 = v57();
					if (((1391 - (141 + 95)) < (1644 + 29)) and v27) then
						return v27;
					end
					v78 = 2 - 1;
				end
				if ((v78 == (2 - 1)) or ((545 + 1779) <= (1583 - 1005))) then
					if (((2649 + 1118) == (1962 + 1805)) and UseTrinkets and ((v29 and TrinketsWithCD) or not TrinketsWithCD)) then
						v27 = v54.HandleTopTrinket(v49, v29, 56 - 16, nil);
						if (((2412 + 1677) == (4252 - (92 + 71))) and v27) then
							return v27;
						end
						v27 = v54.HandleBottomTrinket(v49, v29, 20 + 20, nil);
						if (((7495 - 3037) >= (2439 - (574 + 191))) and v27) then
							return v27;
						end
					end
					if (((802 + 170) <= (3552 - 2134)) and v32) then
						if ((v29 and (FightRemains < (10 + 8))) or ((5787 - (254 + 595)) < (4888 - (55 + 71)))) then
							if (v46.BloodFury:IsCastable() or ((3298 - 794) > (6054 - (573 + 1217)))) then
								if (((5962 - 3809) == (164 + 1989)) and v22(v46.BloodFury, nil)) then
									return "blood_fury main 4";
								end
							end
							if (v46.Berserking:IsCastable() or ((816 - 309) >= (3530 - (714 + 225)))) then
								if (((13095 - 8614) == (6246 - 1765)) and v22(v46.Berserking, nil)) then
									return "berserking main 6";
								end
							end
							if (v46.LightsJudgment:IsCastable() or ((253 + 2075) < (1002 - 309))) then
								if (((5134 - (118 + 688)) == (4376 - (25 + 23))) and v22(v46.LightsJudgment, not v14:IsInRange(8 + 32))) then
									return "lights_judgment main 8";
								end
							end
							if (((3474 - (927 + 959)) >= (4489 - 3157)) and v46.Fireblood:IsCastable()) then
								if (v22(v46.Fireblood, nil) or ((4906 - (16 + 716)) > (8200 - 3952))) then
									return "fireblood main 10";
								end
							end
							if (v46.AncestralCall:IsCastable() or ((4683 - (11 + 86)) <= (199 - 117))) then
								if (((4148 - (175 + 110)) == (9752 - 5889)) and v22(v46.AncestralCall, nil)) then
									return "ancestral_call main 12";
								end
							end
							if (v46.BagOfTricks:IsCastable() or ((1390 - 1108) <= (1838 - (503 + 1293)))) then
								if (((12871 - 8262) >= (554 + 212)) and v22(v46.BagOfTricks, not v14:IsInRange(1101 - (810 + 251)))) then
									return "bag_of_tricks main 14";
								end
							end
						end
						if ((v46.WeaponsOfOrder:IsCastable() and v29) or ((800 + 352) == (764 + 1724))) then
							if (((3085 + 337) > (3883 - (43 + 490))) and v22(v46.WeaponsOfOrder, nil)) then
								return "weapons_of_order main 18";
							end
						end
						if (((1610 - (711 + 22)) > (1454 - 1078)) and v46.FaelineStomp:IsCastable()) then
							if (v22(v46.FaelineStomp, nil) or ((3977 - (240 + 619)) <= (447 + 1404))) then
								return "faeline_stomp main 20";
							end
						end
						if ((v52 >= (4 - 1)) or ((11 + 154) >= (5236 - (1344 + 400)))) then
							local v82 = 405 - (255 + 150);
							while true do
								if (((3111 + 838) < (2600 + 2256)) and ((0 - 0) == v82)) then
									v27 = v59();
									if (v27 or ((13811 - 9535) < (4755 - (404 + 1335)))) then
										return v27;
									end
									break;
								end
							end
						end
						if (((5096 - (183 + 223)) > (5019 - 894)) and (v52 < (2 + 1))) then
							local v83 = 0 + 0;
							while true do
								if ((v83 == (337 - (10 + 327))) or ((35 + 15) >= (1234 - (118 + 220)))) then
									v27 = v60();
									if (v27 or ((572 + 1142) >= (3407 - (108 + 341)))) then
										return v27;
									end
									break;
								end
							end
						end
						if (v22(v46.PoolEnergy) or ((670 + 821) < (2722 - 2078))) then
							return "Pool Energy";
						end
					end
					break;
				end
			end
		end
	end
	local function v64()
		v56();
		v21.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(1763 - (711 + 782), v63, v64);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

