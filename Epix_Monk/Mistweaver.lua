local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((1113 - 437) == (487 + 189)) and (v5 == (843 - (497 + 345)))) then
			return v6(...);
		end
		if (((106 + 4030) > (406 + 1991)) and (v5 == (1333 - (605 + 728)))) then
			v6 = v0[v4];
			if (not v6 or ((3093 + 1241) == (9437 - 5192))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
	end
end
v0["Epix_Monk_Mistweaver.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Pet;
	local v15 = v12.Target;
	local v16 = v12.MouseOver;
	local v17 = v12.Focus;
	local v18 = v10.Spell;
	local v19 = v10.MultiSpell;
	local v20 = v10.Item;
	local v21 = v10.Utils;
	local v22 = EpicLib;
	local v23 = v22.Cast;
	local v24 = v22.Press;
	local v25 = v22.Macro;
	local v26 = v22.Commons.Everyone.num;
	local v27 = v22.Commons.Everyone.bool;
	local v28 = GetNumGroupMembers;
	local v29;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
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
	local v100;
	local v101;
	local v102;
	local v103;
	local v104;
	local v105;
	local v106;
	local v107;
	local v108;
	local v109;
	local v110;
	local v111 = 41079 - 29968;
	local v112 = 10017 + 1094;
	local v113;
	local v114 = v18.Monk.Mistweaver;
	local v115 = v20.Monk.Mistweaver;
	local v116 = v25.Monk.Mistweaver;
	local v117 = {};
	local v118;
	local v119;
	local v120 = v22.Commons.Everyone;
	local v121 = v22.Commons.Monk;
	local function v122()
		if (v114.ImprovedDetox:IsAvailable() or ((11846 - 7570) <= (2289 + 742))) then
			v120.DispellableDebuffs = v21.MergeTable(v120.DispellableMagicDebuffs, v120.DispellablePoisonDebuffs, v120.DispellableDiseaseDebuffs);
		else
			v120.DispellableDebuffs = v120.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123()
		local v138 = 489 - (457 + 32);
		while true do
			if ((v138 == (0 + 0)) or ((6184 - (832 + 570)) <= (1130 + 69))) then
				if ((v114.DampenHarm:IsCastable() and v13:BuffDown(v114.FortifyingBrew) and (v13:HealthPercentage() <= v42) and v41) or ((1269 + 3595) < (6730 - 4828))) then
					if (((2331 + 2508) >= (4496 - (588 + 208))) and v24(v114.DampenHarm, nil)) then
						return "dampen_harm defensives 1";
					end
				end
				if ((v114.FortifyingBrew:IsCastable() and v13:BuffDown(v114.DampenHarmBuff) and (v13:HealthPercentage() <= v40) and v39) or ((2897 - 1822) > (3718 - (884 + 916)))) then
					if (((828 - 432) <= (2206 + 1598)) and v24(v114.FortifyingBrew, nil)) then
						return "fortifying_brew defensives 2";
					end
				end
				v138 = 654 - (232 + 421);
			end
			if ((v138 == (1890 - (1569 + 320))) or ((1023 + 3146) == (416 + 1771))) then
				if (((4737 - 3331) == (2011 - (316 + 289))) and v114.ExpelHarm:IsCastable() and (v13:HealthPercentage() <= v55) and v54 and v13:BuffUp(v114.ChiHarmonyBuff)) then
					if (((4007 - 2476) < (198 + 4073)) and v24(v114.ExpelHarm, nil)) then
						return "expel_harm defensives 3";
					end
				end
				if (((2088 - (666 + 787)) == (1060 - (360 + 65))) and v115.Healthstone:IsReady() and v115.Healthstone:IsUsable() and v84 and (v13:HealthPercentage() <= v85)) then
					if (((3153 + 220) <= (3810 - (79 + 175))) and v24(v116.Healthstone)) then
						return "healthstone defensive 4";
					end
				end
				v138 = 2 - 0;
			end
			if ((v138 == (2 + 0)) or ((10087 - 6796) < (6316 - 3036))) then
				if (((5285 - (503 + 396)) >= (1054 - (92 + 89))) and v86 and (v13:HealthPercentage() <= v87)) then
					if (((1786 - 865) <= (566 + 536)) and (v88 == "Refreshing Healing Potion")) then
						if (((2786 + 1920) >= (3771 - 2808)) and v115.RefreshingHealingPotion:IsReady() and v115.RefreshingHealingPotion:IsUsable()) then
							if (v24(v116.RefreshingHealingPotion) or ((132 + 828) <= (1997 - 1121))) then
								return "refreshing healing potion defensive 5";
							end
						end
					end
					if ((v88 == "Dreamwalker's Healing Potion") or ((1803 + 263) == (446 + 486))) then
						if (((14695 - 9870) < (605 + 4238)) and v115.DreamwalkersHealingPotion:IsReady() and v115.DreamwalkersHealingPotion:IsUsable()) then
							if (v24(v116.RefreshingHealingPotion) or ((5911 - 2034) >= (5781 - (485 + 759)))) then
								return "dreamwalkers healing potion defensive 5";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v139 = 0 - 0;
		while true do
			if ((v139 == (1191 - (442 + 747))) or ((5450 - (832 + 303)) < (2672 - (88 + 858)))) then
				if (v105 or ((1122 + 2557) < (518 + 107))) then
					v29 = v120.HandleCharredBrambles(v114.RenewingMist, v116.RenewingMistMouseover, 2 + 38);
					if (v29 or ((5414 - (766 + 23)) < (3120 - 2488))) then
						return v29;
					end
					v29 = v120.HandleCharredBrambles(v114.SoothingMist, v116.SoothingMistMouseover, 54 - 14);
					if (v29 or ((218 - 135) > (6041 - 4261))) then
						return v29;
					end
					v29 = v120.HandleCharredBrambles(v114.Vivify, v116.VivifyMouseover, 1113 - (1036 + 37));
					if (((388 + 158) <= (2097 - 1020)) and v29) then
						return v29;
					end
					v29 = v120.HandleCharredBrambles(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 32 + 8);
					if (v29 or ((2476 - (641 + 839)) > (5214 - (910 + 3)))) then
						return v29;
					end
				end
				if (((10375 - 6305) > (2371 - (1466 + 218))) and v106) then
					v29 = v120.HandleFyrakkNPC(v114.RenewingMist, v116.RenewingMistMouseover, 19 + 21);
					if (v29 or ((1804 - (556 + 592)) >= (1185 + 2145))) then
						return v29;
					end
					v29 = v120.HandleFyrakkNPC(v114.SoothingMist, v116.SoothingMistMouseover, 848 - (329 + 479));
					if (v29 or ((3346 - (174 + 680)) <= (1151 - 816))) then
						return v29;
					end
					v29 = v120.HandleFyrakkNPC(v114.Vivify, v116.VivifyMouseover, 82 - 42);
					if (((3086 + 1236) >= (3301 - (396 + 343))) and v29) then
						return v29;
					end
					v29 = v120.HandleFyrakkNPC(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 4 + 36);
					if (v29 or ((5114 - (29 + 1448)) >= (5159 - (135 + 1254)))) then
						return v29;
					end
				end
				break;
			end
			if ((v139 == (0 - 0)) or ((11107 - 8728) > (3051 + 1527))) then
				if (v102 or ((2010 - (389 + 1138)) > (1317 - (102 + 472)))) then
					v29 = v120.HandleIncorporeal(v114.Paralysis, v116.ParalysisMouseover, 29 + 1, true);
					if (((1361 + 1093) > (539 + 39)) and v29) then
						return v29;
					end
				end
				if (((2475 - (320 + 1225)) < (7935 - 3477)) and v101) then
					local v239 = 0 + 0;
					while true do
						if (((2126 - (157 + 1307)) <= (2831 - (821 + 1038))) and ((2 - 1) == v239)) then
							if (((478 + 3892) == (7762 - 3392)) and v114.Detox:CooldownRemains()) then
								local v247 = 0 + 0;
								while true do
									if ((v247 == (0 - 0)) or ((5788 - (834 + 192)) <= (55 + 806))) then
										v29 = v120.HandleAfflicted(v114.Vivify, v116.VivifyMouseover, 8 + 22);
										if (v29 or ((31 + 1381) == (6605 - 2341))) then
											return v29;
										end
										break;
									end
								end
							end
							break;
						end
						if ((v239 == (304 - (300 + 4))) or ((847 + 2321) < (5635 - 3482))) then
							v29 = v120.HandleAfflicted(v114.Detox, v116.DetoxMouseover, 392 - (112 + 250));
							if (v29 or ((1984 + 2992) < (3336 - 2004))) then
								return v29;
							end
							v239 = 1 + 0;
						end
					end
				end
				v139 = 1 + 0;
			end
			if (((3462 + 1166) == (2295 + 2333)) and (v139 == (1 + 0))) then
				if (v103 or ((1468 - (1001 + 413)) == (880 - 485))) then
					v29 = v120.HandleChromie(v114.Riptide, v116.RiptideMouseover, 922 - (244 + 638));
					if (((775 - (627 + 66)) == (244 - 162)) and v29) then
						return v29;
					end
					v29 = v120.HandleChromie(v114.HealingSurge, v116.HealingSurgeMouseover, 642 - (512 + 90));
					if (v29 or ((2487 - (1665 + 241)) < (999 - (373 + 344)))) then
						return v29;
					end
				end
				if (v104 or ((2079 + 2530) < (661 + 1834))) then
					v29 = v120.HandleCharredTreant(v114.RenewingMist, v116.RenewingMistMouseover, 105 - 65);
					if (((1949 - 797) == (2251 - (35 + 1064))) and v29) then
						return v29;
					end
					v29 = v120.HandleCharredTreant(v114.SoothingMist, v116.SoothingMistMouseover, 30 + 10);
					if (((4056 - 2160) <= (14 + 3408)) and v29) then
						return v29;
					end
					v29 = v120.HandleCharredTreant(v114.Vivify, v116.VivifyMouseover, 1276 - (298 + 938));
					if (v29 or ((2249 - (233 + 1026)) > (3286 - (636 + 1030)))) then
						return v29;
					end
					v29 = v120.HandleCharredTreant(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 21 + 19);
					if (v29 or ((857 + 20) > (1395 + 3300))) then
						return v29;
					end
				end
				v139 = 1 + 1;
			end
		end
	end
	local function v125()
		if (((2912 - (55 + 166)) >= (359 + 1492)) and v114.ChiBurst:IsCastable() and v50) then
			if (v24(v114.ChiBurst, not v15:IsInRange(5 + 35)) or ((11399 - 8414) >= (5153 - (36 + 261)))) then
				return "chi_burst precombat 4";
			end
		end
		if (((7477 - 3201) >= (2563 - (34 + 1334))) and v114.SpinningCraneKick:IsCastable() and v46 and (v119 >= (1 + 1))) then
			if (((2512 + 720) <= (5973 - (1035 + 248))) and v24(v114.SpinningCraneKick, not v15:IsInMeleeRange(29 - (20 + 1)))) then
				return "spinning_crane_kick precombat 6";
			end
		end
		if ((v114.TigerPalm:IsCastable() and v48) or ((467 + 429) >= (3465 - (134 + 185)))) then
			if (((4194 - (549 + 584)) >= (3643 - (314 + 371))) and v24(v114.TigerPalm, not v15:IsInMeleeRange(17 - 12))) then
				return "tiger_palm precombat 8";
			end
		end
	end
	local function v126()
		if (((4155 - (478 + 490)) >= (342 + 302)) and v114.SummonWhiteTigerStatue:IsReady() and (v119 >= (1175 - (786 + 386))) and v44) then
			if (((2085 - 1441) <= (2083 - (1055 + 324))) and (v43 == "Player")) then
				if (((2298 - (1093 + 247)) > (842 + 105)) and v24(v116.SummonWhiteTigerStatuePlayer, not v15:IsInRange(5 + 35))) then
					return "summon_white_tiger_statue aoe player 1";
				end
			elseif (((17834 - 13342) >= (9007 - 6353)) and (v43 == "Cursor")) then
				if (((9794 - 6352) >= (3776 - 2273)) and v24(v116.SummonWhiteTigerStatueCursor, not v15:IsInRange(15 + 25))) then
					return "summon_white_tiger_statue aoe cursor 1";
				end
			elseif (((v43 == "Friendly under Cursor") and v16:Exists() and not v13:CanAttack(v16)) or ((12212 - 9042) <= (5046 - 3582))) then
				if (v24(v116.SummonWhiteTigerStatueCursor, not v15:IsInRange(31 + 9)) or ((12267 - 7470) == (5076 - (364 + 324)))) then
					return "summon_white_tiger_statue aoe cursor friendly 1";
				end
			elseif (((1510 - 959) <= (1634 - 953)) and (v43 == "Enemy under Cursor") and v16:Exists() and v13:CanAttack(v16)) then
				if (((1087 + 2190) > (1703 - 1296)) and v24(v116.SummonWhiteTigerStatueCursor, not v15:IsInRange(64 - 24))) then
					return "summon_white_tiger_statue aoe cursor enemy 1";
				end
			elseif (((14259 - 9564) >= (2683 - (1249 + 19))) and (v43 == "Confirmation")) then
				if (v24(v116.SummonWhiteTigerStatue, not v15:IsInRange(37 + 3)) or ((12502 - 9290) <= (2030 - (686 + 400)))) then
					return "summon_white_tiger_statue aoe confirmation 1";
				end
			end
		end
		if ((v114.TouchofDeath:IsCastable() and v51) or ((2430 + 666) <= (2027 - (73 + 156)))) then
			if (((17 + 3520) == (4348 - (721 + 90))) and v24(v114.TouchofDeath, not v15:IsInMeleeRange(1 + 4))) then
				return "touch_of_death aoe 2";
			end
		end
		if (((12458 - 8621) >= (2040 - (224 + 246))) and v114.JadefireStomp:IsReady() and v49) then
			if (v24(v114.JadefireStomp, not v15:IsInMeleeRange(12 - 4)) or ((5431 - 2481) == (692 + 3120))) then
				return "JadefireStomp aoe3";
			end
		end
		if (((113 + 4610) >= (1703 + 615)) and v114.ChiBurst:IsCastable() and v50) then
			if (v24(v114.ChiBurst, not v15:IsInRange(79 - 39)) or ((6745 - 4718) > (3365 - (203 + 310)))) then
				return "chi_burst aoe 4";
			end
		end
		if ((v114.SpinningCraneKick:IsCastable() and v46 and (v15:DebuffDown(v114.MysticTouchDebuff) or (v120.EnemiesWithDebuffCount(v114.MysticTouchDebuff) <= (v118 - (1994 - (1238 + 755))))) and v114.MysticTouch:IsAvailable()) or ((80 + 1056) > (5851 - (709 + 825)))) then
			if (((8749 - 4001) == (6916 - 2168)) and v24(v114.SpinningCraneKick, not v15:IsInMeleeRange(872 - (196 + 668)))) then
				return "spinning_crane_kick aoe 5";
			end
		end
		if (((14750 - 11014) <= (9818 - 5078)) and v114.BlackoutKick:IsCastable() and v114.AncientConcordance:IsAvailable() and v13:BuffUp(v114.JadefireStomp) and v45 and (v119 >= (836 - (171 + 662)))) then
			if (v24(v114.BlackoutKick, not v15:IsInMeleeRange(98 - (4 + 89))) or ((11881 - 8491) <= (1115 + 1945))) then
				return "blackout_kick aoe 6";
			end
		end
		if ((v114.TigerPalm:IsCastable() and v114.TeachingsoftheMonastery:IsAvailable() and (v114.BlackoutKick:CooldownRemains() > (0 - 0)) and v48 and (v119 >= (2 + 1))) or ((2485 - (35 + 1451)) > (4146 - (28 + 1425)))) then
			if (((2456 - (941 + 1052)) < (577 + 24)) and v24(v114.TigerPalm, not v15:IsInMeleeRange(1519 - (822 + 692)))) then
				return "tiger_palm aoe 7";
			end
		end
		if ((v114.SpinningCraneKick:IsCastable() and v46) or ((3115 - 932) < (324 + 363))) then
			if (((4846 - (45 + 252)) == (4501 + 48)) and v24(v114.SpinningCraneKick, not v15:IsInMeleeRange(3 + 5))) then
				return "spinning_crane_kick aoe 8";
			end
		end
	end
	local function v127()
		if (((11370 - 6698) == (5105 - (114 + 319))) and v114.TouchofDeath:IsCastable() and v51) then
			if (v24(v114.TouchofDeath, not v15:IsInMeleeRange(6 - 1)) or ((4699 - 1031) < (252 + 143))) then
				return "touch_of_death st 1";
			end
		end
		if ((v114.JadefireStomp:IsReady() and v49) or ((6206 - 2040) == (953 - 498))) then
			if (v24(v114.JadefireStomp, nil) or ((6412 - (556 + 1407)) == (3869 - (741 + 465)))) then
				return "JadefireStomp st 2";
			end
		end
		if ((v114.RisingSunKick:IsReady() and v47) or ((4742 - (170 + 295)) < (1575 + 1414))) then
			if (v24(v114.RisingSunKick, not v15:IsInMeleeRange(5 + 0)) or ((2141 - 1271) >= (3440 + 709))) then
				return "rising_sun_kick st 3";
			end
		end
		if (((1419 + 793) < (1803 + 1380)) and v114.ChiBurst:IsCastable() and v50) then
			if (((5876 - (957 + 273)) > (801 + 2191)) and v24(v114.ChiBurst, not v15:IsInRange(17 + 23))) then
				return "chi_burst st 4";
			end
		end
		if (((5464 - 4030) < (8184 - 5078)) and v114.BlackoutKick:IsCastable() and (v13:BuffStack(v114.TeachingsoftheMonasteryBuff) >= (9 - 6)) and (v114.RisingSunKick:CooldownRemains() > v13:GCD()) and v45) then
			if (((3892 - 3106) < (4803 - (389 + 1391))) and v24(v114.BlackoutKick, not v15:IsInMeleeRange(4 + 1))) then
				return "blackout_kick st 5";
			end
		end
		if ((v114.TigerPalm:IsCastable() and ((v13:BuffStack(v114.TeachingsoftheMonasteryBuff) < (1 + 2)) or (v13:BuffRemains(v114.TeachingsoftheMonasteryBuff) < (4 - 2))) and v48) or ((3393 - (783 + 168)) < (248 - 174))) then
			if (((4461 + 74) == (4846 - (309 + 2))) and v24(v114.TigerPalm, not v15:IsInMeleeRange(15 - 10))) then
				return "tiger_palm st 6";
			end
		end
	end
	local function v128()
		if ((v52 and v114.RenewingMist:IsReady() and v17:BuffDown(v114.RenewingMistBuff) and (v114.RenewingMist:ChargesFractional() >= (1213.8 - (1090 + 122)))) or ((976 + 2033) <= (7069 - 4964))) then
			if (((1253 + 577) < (4787 - (628 + 490))) and (v17:HealthPercentage() <= v53)) then
				if (v24(v116.RenewingMistFocus, not v17:IsSpellInRange(v114.RenewingMist)) or ((257 + 1173) >= (8942 - 5330))) then
					return "RenewingMist healing st";
				end
			end
		end
		if (((12261 - 9578) >= (3234 - (431 + 343))) and v47 and v114.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.RenewingMistBuff, false, false, 50 - 25) > (2 - 1))) then
			if (v24(v114.RisingSunKick, not v15:IsInMeleeRange(4 + 1)) or ((231 + 1573) >= (4970 - (556 + 1139)))) then
				return "RisingSunKick healing st";
			end
		end
		if ((v52 and v114.RenewingMist:IsReady() and v17:BuffDown(v114.RenewingMistBuff)) or ((1432 - (6 + 9)) > (665 + 2964))) then
			if (((2457 + 2338) > (571 - (28 + 141))) and (v17:HealthPercentage() <= v53)) then
				if (((1865 + 2948) > (4400 - 835)) and v24(v116.RenewingMistFocus, not v17:IsSpellInRange(v114.RenewingMist))) then
					return "RenewingMist healing st";
				end
			end
		end
		if (((2771 + 1141) == (5229 - (486 + 831))) and v56 and v114.Vivify:IsReady() and v13:BuffUp(v114.VivaciousVivificationBuff)) then
			if (((7340 - 4519) <= (16983 - 12159)) and (v17:HealthPercentage() <= v57)) then
				if (((329 + 1409) <= (6940 - 4745)) and v24(v116.VivifyFocus, not v17:IsSpellInRange(v114.Vivify))) then
					return "Vivify instant healing st";
				end
			end
		end
		if (((1304 - (668 + 595)) <= (2716 + 302)) and v60 and v114.SoothingMist:IsReady() and v17:BuffDown(v114.SoothingMist)) then
			if (((433 + 1712) <= (11191 - 7087)) and (v17:HealthPercentage() <= v61)) then
				if (((2979 - (23 + 267)) < (6789 - (1129 + 815))) and v24(v116.SoothingMistFocus, not v17:IsSpellInRange(v114.SoothingMist))) then
					return "SoothingMist healing st";
				end
			end
		end
	end
	local function v129()
		local v140 = 387 - (371 + 16);
		while true do
			if ((v140 == (1751 - (1326 + 424))) or ((4397 - 2075) > (9581 - 6959))) then
				if ((v67 and v114.ZenPulse:IsReady() and v120.AreUnitsBelowHealthPercentage(v69, v68, v114.EnvelopingMist)) or ((4652 - (88 + 30)) == (2853 - (720 + 51)))) then
					if (v24(v116.ZenPulseFocus, not v17:IsSpellInRange(v114.ZenPulse)) or ((3494 - 1923) > (3643 - (421 + 1355)))) then
						return "ZenPulse healing aoe";
					end
				end
				if ((v70 and v114.SheilunsGift:IsReady() and v114.SheilunsGift:IsCastable() and v120.AreUnitsBelowHealthPercentage(v72, v71, v114.EnvelopingMist)) or ((4377 - 1723) >= (1472 + 1524))) then
					if (((5061 - (286 + 797)) > (7691 - 5587)) and v24(v114.SheilunsGift, nil)) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
			if (((4960 - 1965) > (1980 - (397 + 42))) and (v140 == (0 + 0))) then
				if (((4049 - (24 + 776)) > (1467 - 514)) and v47 and v114.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.RenewingMistBuff, false, false, 810 - (222 + 563)) > (1 - 0))) then
					if (v24(v114.RisingSunKick, not v15:IsInMeleeRange(4 + 1)) or ((3463 - (23 + 167)) > (6371 - (690 + 1108)))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (v120.AreUnitsBelowHealthPercentage(v64, v63, v114.EnvelopingMist) or ((1137 + 2014) < (1060 + 224))) then
					local v240 = 848 - (40 + 808);
					while true do
						if ((v240 == (0 + 0)) or ((7074 - 5224) == (1462 + 67))) then
							if (((435 + 386) < (1165 + 958)) and v36 and (v13:BuffStack(v114.ManaTeaCharges) > v37) and v114.EssenceFont:IsReady() and v114.ManaTea:IsCastable()) then
								if (((1473 - (47 + 524)) < (1509 + 816)) and v24(v114.ManaTea, nil)) then
									return "EssenceFont healing aoe";
								end
							end
							if (((2345 - 1487) <= (4428 - 1466)) and v38 and v114.ThunderFocusTea:IsReady() and (v114.EssenceFont:CooldownRemains() < v13:GCD())) then
								if (v24(v114.ThunderFocusTea, nil) or ((8999 - 5053) < (3014 - (1165 + 561)))) then
									return "ThunderFocusTea healing aoe";
								end
							end
							v240 = 1 + 0;
						end
						if ((v240 == (3 - 2)) or ((1237 + 2005) == (1046 - (341 + 138)))) then
							if ((v62 and v114.EssenceFont:IsReady() and (v13:BuffUp(v114.ThunderFocusTea) or (v114.ThunderFocusTea:CooldownRemains() > (3 + 5)))) or ((1747 - 900) >= (1589 - (89 + 237)))) then
								if (v24(v114.EssenceFont, nil) or ((7247 - 4994) == (3896 - 2045))) then
									return "EssenceFont healing aoe";
								end
							end
							if ((v62 and v114.EssenceFont:IsReady() and v114.AncientTeachings:IsAvailable() and v13:BuffDown(v114.EssenceFontBuff)) or ((2968 - (581 + 300)) > (3592 - (855 + 365)))) then
								if (v24(v114.EssenceFont, nil) or ((10557 - 6112) < (1355 + 2794))) then
									return "EssenceFont healing aoe";
								end
							end
							break;
						end
					end
				end
				v140 = 1236 - (1030 + 205);
			end
		end
	end
	local function v130()
		local v141 = 0 + 0;
		while true do
			if ((v141 == (1 + 0)) or ((2104 - (156 + 130)) == (193 - 108))) then
				if (((1061 - 431) < (4355 - 2228)) and v60 and v114.SoothingMist:IsReady() and v17:BuffUp(v114.ChiHarmonyBuff) and v17:BuffDown(v114.SoothingMist)) then
					if (v24(v116.SoothingMistFocus, not v17:IsSpellInRange(v114.SoothingMist)) or ((511 + 1427) == (1466 + 1048))) then
						return "Soothing Mist YuLon";
					end
				end
				break;
			end
			if (((4324 - (10 + 59)) >= (16 + 39)) and ((0 - 0) == v141)) then
				if (((4162 - (671 + 492)) > (921 + 235)) and v58 and v114.EnvelopingMist:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.EnvelopingMist, false, false, 1240 - (369 + 846)) < (1 + 2))) then
					v29 = v120.FocusUnitRefreshableBuff(v114.EnvelopingMist, 2 + 0, 1985 - (1036 + 909), nil, false, 20 + 5, v114.EnvelopingMist);
					if (((3945 - 1595) > (1358 - (11 + 192))) and v29) then
						return v29;
					end
					if (((2037 + 1992) <= (5028 - (135 + 40))) and v24(v116.EnvelopingMistFocus, not v17:IsSpellInRange(v114.EnvelopingMist))) then
						return "Enveloping Mist YuLon";
					end
				end
				if ((v47 and v114.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.EnvelopingMist, false, false, 60 - 35) > (2 + 0))) or ((1136 - 620) > (5147 - 1713))) then
					if (((4222 - (50 + 126)) >= (8445 - 5412)) and v24(v114.RisingSunKick, not v15:IsInMeleeRange(2 + 3))) then
						return "Rising Sun Kick YuLon";
					end
				end
				v141 = 1414 - (1233 + 180);
			end
		end
	end
	local function v131()
		if ((v45 and v114.BlackoutKick:IsReady() and (v13:BuffStack(v114.TeachingsoftheMonastery) >= (972 - (522 + 447)))) or ((4140 - (107 + 1314)) <= (672 + 775))) then
			if (v24(v114.BlackoutKick, not v15:IsInMeleeRange(15 - 10)) or ((1756 + 2378) < (7796 - 3870))) then
				return "Blackout Kick ChiJi";
			end
		end
		if ((v58 and v114.EnvelopingMist:IsReady() and (v13:BuffStack(v114.InvokeChiJiBuff) == (11 - 8))) or ((2074 - (716 + 1194)) >= (48 + 2737))) then
			if ((v17:HealthPercentage() <= v59) or ((57 + 468) == (2612 - (74 + 429)))) then
				if (((63 - 30) == (17 + 16)) and v24(v116.EnvelopingMistFocus, not v17:IsSpellInRange(v114.EnvelopingMist))) then
					return "Enveloping Mist 3 Stacks ChiJi";
				end
			end
		end
		if (((6990 - 3936) <= (2841 + 1174)) and v47 and v114.RisingSunKick:IsReady()) then
			if (((5768 - 3897) < (8361 - 4979)) and v24(v114.RisingSunKick, not v15:IsInMeleeRange(438 - (279 + 154)))) then
				return "Rising Sun Kick ChiJi";
			end
		end
		if (((2071 - (454 + 324)) <= (1705 + 461)) and v58 and v114.EnvelopingMist:IsReady() and (v13:BuffStack(v114.InvokeChiJiBuff) >= (19 - (12 + 5)))) then
			if ((v17:HealthPercentage() <= v59) or ((1391 + 1188) < (312 - 189))) then
				if (v24(v116.EnvelopingMistFocus, not v17:IsSpellInRange(v114.EnvelopingMist)) or ((313 + 533) >= (3461 - (277 + 816)))) then
					return "Enveloping Mist 2 Stacks ChiJi";
				end
			end
		end
		if ((v62 and v114.EssenceFont:IsReady() and v114.AncientTeachings:IsAvailable() and v13:BuffDown(v114.AncientTeachings)) or ((17143 - 13131) <= (4541 - (1058 + 125)))) then
			if (((281 + 1213) <= (3980 - (815 + 160))) and v24(v114.EssenceFont, nil)) then
				return "Essence Font ChiJi";
			end
		end
	end
	local function v132()
		local v142 = 0 - 0;
		while true do
			if ((v142 == (0 - 0)) or ((743 + 2368) == (6237 - 4103))) then
				if (((4253 - (41 + 1857)) == (4248 - (1222 + 671))) and v79 and v114.LifeCocoon:IsReady() and (v17:HealthPercentage() <= v80)) then
					if (v24(v116.LifeCocoonFocus, not v17:IsSpellInRange(v114.LifeCocoon)) or ((1519 - 931) <= (620 - 188))) then
						return "Life Cocoon CD";
					end
				end
				if (((5979 - (229 + 953)) >= (5669 - (1111 + 663))) and v81 and v114.Revival:IsReady() and v114.Revival:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v83, v82, v114.EnvelopingMist)) then
					if (((5156 - (874 + 705)) == (501 + 3076)) and v24(v114.Revival, nil)) then
						return "Revival CD";
					end
				end
				v142 = 1 + 0;
			end
			if (((7885 - 4091) > (104 + 3589)) and (v142 == (681 - (642 + 37)))) then
				if ((v114.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (6 + 19)) or ((204 + 1071) == (10294 - 6194))) then
					v29 = v130();
					if (v29 or ((2045 - (233 + 221)) >= (8278 - 4698))) then
						return v29;
					end
				end
				if (((866 + 117) <= (3349 - (718 + 823))) and v76 and v114.InvokeChiJiTheRedCrane:IsReady() and v114.InvokeChiJiTheRedCrane:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v78, v77, v114.EnvelopingMist)) then
					local v241 = 0 + 0;
					while true do
						if ((v241 == (805 - (266 + 539))) or ((6087 - 3937) <= (2422 - (636 + 589)))) then
							if (((8946 - 5177) >= (2418 - 1245)) and v52 and v114.RenewingMist:IsReady() and (v114.RenewingMist:ChargesFractional() >= (1 + 0))) then
								v29 = v120.FocusUnitRefreshableBuff(v114.RenewingMistBuff, 3 + 3, 1055 - (657 + 358), nil, false, 66 - 41, v114.EnvelopingMist);
								if (((3383 - 1898) == (2672 - (1151 + 36))) and v29) then
									return v29;
								end
								if (v24(v116.RenewingMistFocus, not v17:IsSpellInRange(v114.RenewingMist)) or ((3202 + 113) <= (732 + 2050))) then
									return "Renewing Mist ChiJi prep";
								end
							end
							if ((v70 and v114.SheilunsGift:IsReady() and (v114.SheilunsGift:TimeSinceLastCast() > (59 - 39))) or ((2708 - (1552 + 280)) >= (3798 - (64 + 770)))) then
								if (v24(v114.SheilunsGift, nil) or ((1516 + 716) > (5667 - 3170))) then
									return "Sheilun's Gift ChiJi prep";
								end
							end
							v241 = 1 + 0;
						end
						if ((v241 == (1244 - (157 + 1086))) or ((4223 - 2113) <= (1453 - 1121))) then
							if (((5653 - 1967) > (4328 - 1156)) and v114.InvokeChiJiTheRedCrane:IsReady() and (v114.RenewingMist:ChargesFractional() < (820 - (599 + 220))) and v13:BuffUp(v114.AncientTeachings) and (v13:BuffStack(v114.TeachingsoftheMonastery) == (5 - 2)) and (v114.SheilunsGift:TimeSinceLastCast() < ((1935 - (1813 + 118)) * v13:GCD()))) then
								if (v24(v114.InvokeChiJiTheRedCrane, nil) or ((3271 + 1203) < (2037 - (841 + 376)))) then
									return "Invoke Chi'ji GO";
								end
							end
							break;
						end
					end
				end
				v142 = 3 - 0;
			end
			if (((995 + 3284) >= (7866 - 4984)) and (v142 == (860 - (464 + 395)))) then
				if ((v81 and v114.Restoral:IsReady() and v114.Restoral:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v83, v82, v114.EnvelopingMist)) or ((5207 - 3178) >= (1691 + 1830))) then
					if (v24(v114.Restoral, nil) or ((2874 - (467 + 370)) >= (9592 - 4950))) then
						return "Restoral CD";
					end
				end
				if (((1263 + 457) < (15282 - 10824)) and v73 and v114.InvokeYulonTheJadeSerpent:IsAvailable() and v114.InvokeYulonTheJadeSerpent:IsReady() and v120.AreUnitsBelowHealthPercentage(v75, v74, v114.EnvelopingMist)) then
					if ((v52 and v114.RenewingMist:IsReady() and (v114.RenewingMist:ChargesFractional() >= (1 + 0))) or ((1014 - 578) > (3541 - (150 + 370)))) then
						local v245 = 1282 - (74 + 1208);
						while true do
							if (((1753 - 1040) <= (4016 - 3169)) and (v245 == (1 + 0))) then
								if (((2544 - (14 + 376)) <= (6991 - 2960)) and v24(v116.RenewingMistFocus, not v17:IsSpellInRange(v114.RenewingMist))) then
									return "Renewing Mist YuLon prep";
								end
								break;
							end
							if (((2987 + 1628) == (4055 + 560)) and (v245 == (0 + 0))) then
								v29 = v120.FocusUnitRefreshableBuff(v114.RenewingMistBuff, 17 - 11, 31 + 9, nil, false, 103 - (23 + 55), v114.EnvelopingMist);
								if (v29 or ((8982 - 5192) == (334 + 166))) then
									return v29;
								end
								v245 = 1 + 0;
							end
						end
					end
					if (((137 - 48) < (70 + 151)) and v36 and v114.ManaTea:IsCastable() and (v13:BuffStack(v114.ManaTeaCharges) >= (904 - (652 + 249))) and v13:BuffDown(v114.ManaTeaBuff)) then
						if (((5496 - 3442) >= (3289 - (708 + 1160))) and v24(v114.ManaTea, nil)) then
							return "ManaTea YuLon prep";
						end
					end
					if (((1878 - 1186) < (5575 - 2517)) and v70 and v114.SheilunsGift:IsReady() and (v114.SheilunsGift:TimeSinceLastCast() > (47 - (10 + 17)))) then
						if (v24(v114.SheilunsGift, nil) or ((731 + 2523) == (3387 - (1400 + 332)))) then
							return "Sheilun's Gift YuLon prep";
						end
					end
					if ((v114.InvokeYulonTheJadeSerpent:IsReady() and (v114.RenewingMist:ChargesFractional() < (1 - 0)) and v13:BuffUp(v114.ManaTeaBuff) and (v114.SheilunsGift:TimeSinceLastCast() < ((1912 - (242 + 1666)) * v13:GCD()))) or ((555 + 741) == (1800 + 3110))) then
						if (((2871 + 497) == (4308 - (850 + 90))) and v24(v114.InvokeYulonTheJadeSerpent, nil)) then
							return "Invoke Yu'lon GO";
						end
					end
				end
				v142 = 3 - 1;
			end
			if (((4033 - (360 + 1030)) < (3377 + 438)) and (v142 == (7 - 4))) then
				if (((2631 - 718) > (2154 - (909 + 752))) and (v114.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (1248 - (109 + 1114)))) then
					local v242 = 0 - 0;
					while true do
						if (((1851 + 2904) > (3670 - (6 + 236))) and (v242 == (0 + 0))) then
							v29 = v131();
							if (((1112 + 269) <= (5586 - 3217)) and v29) then
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
	local function v133()
		local v143 = 0 - 0;
		while true do
			if ((v143 == (1140 - (1076 + 57))) or ((797 + 4046) == (4773 - (579 + 110)))) then
				v72 = EpicSettings.Settings['SheilunsGiftHP'];
				v71 = EpicSettings.Settings['SheilunsGiftGroup'];
				break;
			end
			if (((369 + 4300) > (321 + 42)) and (v143 == (1 + 0))) then
				v41 = EpicSettings.Settings['UseDampenHarm'];
				v42 = EpicSettings.Settings['DampenHarmHP'];
				v43 = EpicSettings.Settings['WhiteTigerUsage'];
				v44 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
				v45 = EpicSettings.Settings['UseBlackoutKick'];
				v143 = 409 - (174 + 233);
			end
			if ((v143 == (5 - 3)) or ((3294 - 1417) >= (1396 + 1742))) then
				v46 = EpicSettings.Settings['UseSpinningCraneKick'];
				v47 = EpicSettings.Settings['UseRisingSunKick'];
				v48 = EpicSettings.Settings['UseTigerPalm'];
				v49 = EpicSettings.Settings['UseJadefireStomp'];
				v50 = EpicSettings.Settings['UseChiBurst'];
				v143 = 1177 - (663 + 511);
			end
			if (((4231 + 511) >= (788 + 2838)) and (v143 == (15 - 10))) then
				v61 = EpicSettings.Settings['SoothingMistHP'];
				v62 = EpicSettings.Settings['UseEssenceFont'];
				v64 = EpicSettings.Settings['EssenceFontHP'];
				v63 = EpicSettings.Settings['EssenceFontGroup'];
				v66 = EpicSettings.Settings['UseJadeSerpent'];
				v143 = 4 + 2;
			end
			if ((v143 == (0 - 0)) or ((10990 - 6450) == (438 + 478))) then
				v36 = EpicSettings.Settings['UseManaTea'];
				v37 = EpicSettings.Settings['ManaTeaStacks'];
				v38 = EpicSettings.Settings['UseThunderFocusTea'];
				v39 = EpicSettings.Settings['UseFortifyingBrew'];
				v40 = EpicSettings.Settings['FortifyingBrewHP'];
				v143 = 1 - 0;
			end
			if ((v143 == (3 + 1)) or ((106 + 1050) > (5067 - (478 + 244)))) then
				v56 = EpicSettings.Settings['UseVivify'];
				v57 = EpicSettings.Settings['VivifyHP'];
				v58 = EpicSettings.Settings['UseEnvelopingMist'];
				v59 = EpicSettings.Settings['EnvelopingMistHP'];
				v60 = EpicSettings.Settings['UseSoothingMist'];
				v143 = 522 - (440 + 77);
			end
			if (((1018 + 1219) < (15551 - 11302)) and (v143 == (1562 - (655 + 901)))) then
				v65 = EpicSettings.Settings['JadeSerpentUsage'];
				v67 = EpicSettings.Settings['UseZenPulse'];
				v69 = EpicSettings.Settings['ZenPulseHP'];
				v68 = EpicSettings.Settings['ZenPulseGroup'];
				v70 = EpicSettings.Settings['UseSheilunsGift'];
				v143 = 2 + 5;
			end
			if ((v143 == (3 + 0)) or ((1812 + 871) < (92 - 69))) then
				v51 = EpicSettings.Settings['UseTouchOfDeath'];
				v52 = EpicSettings.Settings['UseRenewingMist'];
				v53 = EpicSettings.Settings['RenewingMistHP'];
				v54 = EpicSettings.Settings['UseExpelHarm'];
				v55 = EpicSettings.Settings['ExpelHarmHP'];
				v143 = 1449 - (695 + 750);
			end
		end
	end
	local function v134()
		local v144 = 0 - 0;
		while true do
			if (((1075 - 378) <= (3321 - 2495)) and (v144 == (357 - (285 + 66)))) then
				v105 = EpicSettings.Settings['HandleCharredBrambles'];
				v104 = EpicSettings.Settings['HandleCharredTreant'];
				v106 = EpicSettings.Settings['HandleFyrakkNPC'];
				v73 = EpicSettings.Settings['UseInvokeYulon'];
				v144 = 15 - 8;
			end
			if (((2415 - (682 + 628)) <= (190 + 986)) and (v144 == (308 - (176 + 123)))) then
				v83 = EpicSettings.Settings['RevivalHP'];
				v82 = EpicSettings.Settings['RevivalGroup'];
				break;
			end
			if (((1414 + 1965) <= (2766 + 1046)) and (v144 == (273 - (239 + 30)))) then
				v92 = EpicSettings.Settings['InterruptThreshold'];
				v90 = EpicSettings.Settings['InterruptWithStun'];
				v91 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v93 = EpicSettings.Settings['useSpearHandStrike'];
				v144 = 2 + 3;
			end
			if ((v144 == (1 + 0)) or ((1394 - 606) >= (5041 - 3425))) then
				v99 = EpicSettings.Settings['fightRemainsCheck'];
				v100 = EpicSettings.Settings['useWeapon'];
				v89 = EpicSettings.Settings['dispelDebuffs'];
				v86 = EpicSettings.Settings['useHealingPotion'];
				v144 = 317 - (306 + 9);
			end
			if (((6469 - 4615) <= (588 + 2791)) and (v144 == (5 + 3))) then
				v77 = EpicSettings.Settings['InvokeChiJiGroup'];
				v79 = EpicSettings.Settings['UseLifeCocoon'];
				v80 = EpicSettings.Settings['LifeCocoonHP'];
				v81 = EpicSettings.Settings['UseRevival'];
				v144 = 5 + 4;
			end
			if (((13008 - 8459) == (5924 - (1140 + 235))) and ((4 + 1) == v144)) then
				v94 = EpicSettings.Settings['useLegSweep'];
				v101 = EpicSettings.Settings['handleAfflicted'];
				v102 = EpicSettings.Settings['HandleIncorporeal'];
				v103 = EpicSettings.Settings['HandleChromie'];
				v144 = 6 + 0;
			end
			if ((v144 == (2 + 5)) or ((3074 - (33 + 19)) >= (1092 + 1932))) then
				v75 = EpicSettings.Settings['InvokeYulonHP'];
				v74 = EpicSettings.Settings['InvokeYulonGroup'];
				v76 = EpicSettings.Settings['UseInvokeChiJi'];
				v78 = EpicSettings.Settings['InvokeChiJiHP'];
				v144 = 23 - 15;
			end
			if (((2124 + 2696) > (4310 - 2112)) and (v144 == (3 + 0))) then
				v107 = EpicSettings.Settings['useManaPotion'];
				v108 = EpicSettings.Settings['manaPotionSlider'];
				v109 = EpicSettings.Settings['RevivalBurstingGroup'];
				v110 = EpicSettings.Settings['RevivalBurstingStacks'];
				v144 = 693 - (586 + 103);
			end
			if ((v144 == (1 + 1)) or ((3266 - 2205) >= (6379 - (1309 + 179)))) then
				v87 = EpicSettings.Settings['healingPotionHP'];
				v88 = EpicSettings.Settings['HealingPotionName'];
				v84 = EpicSettings.Settings['useHealthstone'];
				v85 = EpicSettings.Settings['healthstoneHP'];
				v144 = 5 - 2;
			end
			if (((594 + 770) <= (12012 - 7539)) and ((0 + 0) == v144)) then
				v96 = EpicSettings.Settings['racialsWithCD'];
				v95 = EpicSettings.Settings['useRacials'];
				v98 = EpicSettings.Settings['trinketsWithCD'];
				v97 = EpicSettings.Settings['useTrinkets'];
				v144 = 1 - 0;
			end
		end
	end
	local v135 = 0 - 0;
	local function v136()
		v133();
		v134();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		v34 = EpicSettings.Toggles['healing'];
		v35 = EpicSettings.Toggles['dps'];
		if (v13:IsDeadOrGhost() or ((4204 - (295 + 314)) <= (6 - 3))) then
			return;
		end
		v118 = v13:GetEnemiesInMeleeRange(1970 - (1300 + 662));
		if (v31 or ((14670 - 9998) == (5607 - (1178 + 577)))) then
			v119 = #v118;
		else
			v119 = 1 + 0;
		end
		if (((4608 - 3049) == (2964 - (851 + 554))) and (v120.TargetIsValid() or v13:AffectingCombat())) then
			local v156 = 0 + 0;
			while true do
				if ((v156 == (2 - 1)) or ((3804 - 2052) <= (1090 - (115 + 187)))) then
					v112 = v111;
					if ((v112 == (8510 + 2601)) or ((3699 + 208) == (697 - 520))) then
						v112 = v10.FightRemains(v113, false);
					end
					break;
				end
				if (((4631 - (160 + 1001)) > (486 + 69)) and (v156 == (0 + 0))) then
					v113 = v13:GetEnemiesInRange(81 - 41);
					v111 = v10.BossFightRemains(nil, true);
					v156 = 359 - (237 + 121);
				end
			end
		end
		v29 = v124();
		if (v29 or ((1869 - (525 + 372)) == (1222 - 577))) then
			return v29;
		end
		if (((10454 - 7272) >= (2257 - (96 + 46))) and (v13:AffectingCombat() or v30)) then
			local v157 = 777 - (643 + 134);
			local v158;
			while true do
				if (((1406 + 2487) < (10619 - 6190)) and (v157 == (3 - 2))) then
					if (v29 or ((2750 + 117) < (3738 - 1833))) then
						return v29;
					end
					if ((v33 and v89) or ((3671 - 1875) >= (4770 - (316 + 403)))) then
						if (((1077 + 542) <= (10326 - 6570)) and v17) then
							if (((219 + 385) == (1520 - 916)) and v114.Detox:IsCastable() and v120.UnitHasDispellableDebuffByPlayer(v17)) then
								if ((v135 == (0 + 0)) or ((1446 + 3038) == (3118 - 2218))) then
									v135 = GetTime();
								end
								if (v120.Wait(2387 - 1887, v135) or ((9262 - 4803) <= (64 + 1049))) then
									if (((7149 - 3517) > (166 + 3232)) and v24(v116.DetoxFocus, not v17:IsSpellInRange(v114.Detox))) then
										return "detox dispel focus";
									end
									v135 = 0 - 0;
								end
							end
						end
						if (((4099 - (12 + 5)) <= (19097 - 14180)) and v16 and v16:Exists() and v16:IsAPlayer() and v120.UnitHasDispellableDebuffByPlayer(v16)) then
							if (((10309 - 5477) >= (2946 - 1560)) and v114.Detox:IsCastable()) then
								if (((339 - 202) == (28 + 109)) and v24(v116.DetoxMouseover, not v16:IsSpellInRange(v114.Detox))) then
									return "detox dispel mouseover";
								end
							end
						end
					end
					break;
				end
				if ((v157 == (1973 - (1656 + 317))) or ((1400 + 170) >= (3472 + 860))) then
					v158 = v89 and v114.Detox:IsReady() and v33;
					v29 = v120.FocusUnit(v158, nil, 106 - 66, nil, 123 - 98, v114.EnvelopingMist);
					v157 = 355 - (5 + 349);
				end
			end
		end
		if (not v13:AffectingCombat() or ((19303 - 15239) <= (3090 - (266 + 1005)))) then
			if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((3286 + 1700) < (5370 - 3796))) then
				local v236 = 0 - 0;
				local v237;
				while true do
					if (((6122 - (561 + 1135)) > (223 - 51)) and (v236 == (0 - 0))) then
						v237 = v120.DeadFriendlyUnitsCount();
						if (((1652 - (507 + 559)) > (1141 - 686)) and (v237 > (3 - 2))) then
							if (((1214 - (212 + 176)) == (1731 - (250 + 655))) and v24(v114.Reawaken, nil)) then
								return "reawaken";
							end
						elseif (v24(v116.ResuscitateMouseover, not v15:IsInRange(109 - 69)) or ((7022 - 3003) > (6948 - 2507))) then
							return "resuscitate";
						end
						break;
					end
				end
			end
		end
		if (((3973 - (1869 + 87)) < (14778 - 10517)) and not v13:AffectingCombat() and v30) then
			local v159 = 1901 - (484 + 1417);
			while true do
				if (((10108 - 5392) > (134 - 54)) and (v159 == (773 - (48 + 725)))) then
					v29 = v125();
					if (v29 or ((5728 - 2221) == (8778 - 5506))) then
						return v29;
					end
					break;
				end
			end
		end
		if (v30 or v13:AffectingCombat() or ((510 + 366) >= (8217 - 5142))) then
			local v160 = 0 + 0;
			while true do
				if (((1269 + 3083) > (3407 - (152 + 701))) and (v160 == (1313 - (430 + 881)))) then
					if (v34 or ((1688 + 2718) < (4938 - (557 + 338)))) then
						if ((v114.SummonJadeSerpentStatue:IsReady() and v114.SummonJadeSerpentStatue:IsAvailable() and (v114.SummonJadeSerpentStatue:TimeSinceLastCast() > (27 + 63)) and v66) or ((5322 - 3433) >= (11846 - 8463))) then
							if (((5026 - 3134) <= (5892 - 3158)) and (v65 == "Player")) then
								if (((2724 - (499 + 302)) < (3084 - (39 + 827))) and v24(v116.SummonJadeSerpentStatuePlayer, not v15:IsInRange(110 - 70))) then
									return "jade serpent main player";
								end
							elseif (((4852 - 2679) > (1505 - 1126)) and (v65 == "Cursor")) then
								if (v24(v116.SummonJadeSerpentStatueCursor, not v15:IsInRange(61 - 21)) or ((222 + 2369) == (9977 - 6568))) then
									return "jade serpent main cursor";
								end
							elseif (((723 + 3791) > (5259 - 1935)) and (v65 == "Confirmation")) then
								if (v24(v114.SummonJadeSerpentStatue, not v15:IsInRange(144 - (103 + 1))) or ((762 - (475 + 79)) >= (10436 - 5608))) then
									return "jade serpent main confirmation";
								end
							end
						end
						if ((v52 and v114.RenewingMist:IsReady() and v15:BuffDown(v114.RenewingMistBuff) and not v13:CanAttack(v15)) or ((5065 - 3482) > (461 + 3106))) then
							if ((v15:HealthPercentage() <= v53) or ((1156 + 157) == (2297 - (1395 + 108)))) then
								if (((9235 - 6061) > (4106 - (7 + 1197))) and v24(v114.RenewingMist, not v15:IsSpellInRange(v114.RenewingMist))) then
									return "RenewingMist main";
								end
							end
						end
						if (((1797 + 2323) <= (1487 + 2773)) and v60 and v114.SoothingMist:IsReady() and v15:BuffDown(v114.SoothingMist) and not v13:CanAttack(v15)) then
							if ((v15:HealthPercentage() <= v61) or ((1202 - (27 + 292)) > (14001 - 9223))) then
								if (v24(v114.SoothingMist, not v15:IsSpellInRange(v114.SoothingMist)) or ((4616 - 996) >= (20511 - 15620))) then
									return "SoothingMist main";
								end
							end
						end
						if (((8396 - 4138) > (1784 - 847)) and v36 and (v13:BuffStack(v114.ManaTeaCharges) >= (157 - (43 + 96))) and v114.ManaTea:IsCastable()) then
							if (v24(v114.ManaTea, nil) or ((19861 - 14992) < (2048 - 1142))) then
								return "Mana Tea main avoid overcap";
							end
						end
						if (((v112 > v99) and v32 and v13:AffectingCombat()) or ((1017 + 208) > (1194 + 3034))) then
							v29 = v132();
							if (((6577 - 3249) > (858 + 1380)) and v29) then
								return v29;
							end
						end
						if (((7194 - 3355) > (443 + 962)) and v31) then
							local v246 = 0 + 0;
							while true do
								if ((v246 == (1751 - (1414 + 337))) or ((3233 - (1642 + 298)) <= (1321 - 814))) then
									v29 = v129();
									if (v29 or ((8331 - 5435) < (2388 - 1583))) then
										return v29;
									end
									break;
								end
							end
						end
						v29 = v128();
						if (((763 + 1553) == (1802 + 514)) and v29) then
							return v29;
						end
					end
					break;
				end
				if ((v160 == (972 - (357 + 615))) or ((1805 + 765) == (3761 - 2228))) then
					if ((v32 and v100 and (v115.Dreambinder:IsEquippedAndReady() or v115.Iridal:IsEquippedAndReady())) or ((757 + 126) == (3128 - 1668))) then
						if (v24(v116.UseWeapon, nil) or ((3695 + 924) <= (68 + 931))) then
							return "Using Weapon Macro";
						end
					end
					if ((v107 and v115.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v108)) or ((2144 + 1266) > (5417 - (384 + 917)))) then
						if (v24(v116.ManaPotion, nil) or ((1600 - (128 + 569)) >= (4602 - (1407 + 136)))) then
							return "Mana Potion main";
						end
					end
					v160 = 1888 - (687 + 1200);
				end
				if ((v160 == (1711 - (556 + 1154))) or ((13987 - 10011) < (2952 - (9 + 86)))) then
					if (((5351 - (275 + 146)) > (376 + 1931)) and (v13:DebuffStack(v114.Bursting) > (69 - (29 + 35)))) then
						if ((v114.DiffuseMagic:IsReady() and v114.DiffuseMagic:IsAvailable()) or ((17931 - 13885) < (3856 - 2565))) then
							if (v24(v114.DiffuseMagic, nil) or ((18721 - 14480) == (2309 + 1236))) then
								return "Diffues Magic Bursting Player";
							end
						end
					end
					if (((v114.Bursting:MaxDebuffStack() > v110) and (v114.Bursting:AuraActiveCount() > v109)) or ((5060 - (53 + 959)) > (4640 - (312 + 96)))) then
						if ((v81 and v114.Revival:IsReady() and v114.Revival:IsAvailable()) or ((3037 - 1287) >= (3758 - (147 + 138)))) then
							if (((4065 - (813 + 86)) == (2862 + 304)) and v24(v114.Revival, nil)) then
								return "Revival Bursting";
							end
						end
					end
					v160 = 3 - 1;
				end
			end
		end
		if (((2255 - (18 + 474)) < (1257 + 2467)) and (v30 or v13:AffectingCombat()) and v120.TargetIsValid() and v13:CanAttack(v15)) then
			v29 = v123();
			if (((185 - 128) <= (3809 - (860 + 226))) and v29) then
				return v29;
			end
			if ((v97 and ((v32 and v98) or not v98)) or ((2373 - (121 + 182)) == (55 + 388))) then
				local v238 = 1240 - (988 + 252);
				while true do
					if (((0 + 0) == v238) or ((848 + 1857) == (3363 - (49 + 1921)))) then
						v29 = v120.HandleTopTrinket(v117, v32, 930 - (223 + 667), nil);
						if (v29 or ((4653 - (51 + 1)) < (104 - 43))) then
							return v29;
						end
						v238 = 1 - 0;
					end
					if ((v238 == (1126 - (146 + 979))) or ((393 + 997) >= (5349 - (311 + 294)))) then
						v29 = v120.HandleBottomTrinket(v117, v32, 111 - 71, nil);
						if (v29 or ((849 + 1154) > (5277 - (496 + 947)))) then
							return v29;
						end
						break;
					end
				end
			end
			if (v35 or ((1514 - (1233 + 125)) > (1588 + 2325))) then
				if (((175 + 20) == (38 + 157)) and v95 and ((v32 and v96) or not v96) and (v112 < (1663 - (963 + 682)))) then
					local v243 = 0 + 0;
					while true do
						if (((4609 - (504 + 1000)) >= (1210 + 586)) and (v243 == (1 + 0))) then
							if (((414 + 3965) >= (3142 - 1011)) and v114.LightsJudgment:IsCastable()) then
								if (((3285 + 559) >= (1189 + 854)) and v24(v114.LightsJudgment, not v15:IsInRange(222 - (156 + 26)))) then
									return "lights_judgment main 8";
								end
							end
							if (v114.Fireblood:IsCastable() or ((1862 + 1370) <= (4272 - 1541))) then
								if (((5069 - (149 + 15)) == (5865 - (890 + 70))) and v24(v114.Fireblood, nil)) then
									return "fireblood main 10";
								end
							end
							v243 = 119 - (39 + 78);
						end
						if ((v243 == (482 - (14 + 468))) or ((9095 - 4959) >= (12328 - 7917))) then
							if (v114.BloodFury:IsCastable() or ((1527 + 1431) == (2413 + 1604))) then
								if (((261 + 967) >= (368 + 445)) and v24(v114.BloodFury, nil)) then
									return "blood_fury main 4";
								end
							end
							if (v114.Berserking:IsCastable() or ((906 + 2549) > (7752 - 3702))) then
								if (((241 + 2) == (853 - 610)) and v24(v114.Berserking, nil)) then
									return "berserking main 6";
								end
							end
							v243 = 1 + 0;
						end
						if ((v243 == (53 - (12 + 39))) or ((253 + 18) > (4865 - 3293))) then
							if (((9754 - 7015) < (977 + 2316)) and v114.AncestralCall:IsCastable()) then
								if (v24(v114.AncestralCall, nil) or ((2075 + 1867) < (2875 - 1741))) then
									return "ancestral_call main 12";
								end
							end
							if (v114.BagofTricks:IsCastable() or ((1794 + 899) == (24033 - 19060))) then
								if (((3856 - (1596 + 114)) == (5602 - 3456)) and v24(v114.BagofTricks, not v15:IsInRange(753 - (164 + 549)))) then
									return "bag_of_tricks main 14";
								end
							end
							break;
						end
					end
				end
				if ((v38 and v114.ThunderFocusTea:IsReady() and not v114.EssenceFont:IsAvailable() and (v114.RisingSunKick:CooldownRemains() < v13:GCD())) or ((3682 - (1059 + 379)) == (4002 - 778))) then
					if (v24(v114.ThunderFocusTea, nil) or ((2542 + 2362) <= (323 + 1593))) then
						return "ThunderFocusTea main 16";
					end
				end
				if (((482 - (145 + 247)) <= (874 + 191)) and (v119 >= (2 + 1)) and v31) then
					v29 = v126();
					if (((14236 - 9434) == (922 + 3880)) and v29) then
						return v29;
					end
				end
				if ((v119 < (3 + 0)) or ((3702 - 1422) <= (1231 - (254 + 466)))) then
					local v244 = 560 - (544 + 16);
					while true do
						if ((v244 == (0 - 0)) or ((2304 - (294 + 334)) <= (716 - (236 + 17)))) then
							v29 = v127();
							if (((1668 + 2201) == (3012 + 857)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
			end
		end
	end
	local function v137()
		local v151 = 0 - 0;
		while true do
			if (((5482 - 4324) <= (1346 + 1267)) and (v151 == (1 + 0))) then
				v22.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
				break;
			end
			if ((v151 == (794 - (413 + 381))) or ((100 + 2264) <= (4251 - 2252))) then
				v122();
				v114.Bursting:RegisterAuraTracking();
				v151 = 2 - 1;
			end
		end
	end
	v22.SetAPL(2240 - (582 + 1388), v136, v137);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

