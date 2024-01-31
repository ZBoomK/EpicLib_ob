local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((2960 - (340 + 1571)) < (757 + 1160)) and (v5 == (1772 - (1733 + 39)))) then
			v6 = v0[v4];
			if (((7792 - 4956) > (1528 - (125 + 909))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1949 - (1096 + 852);
		end
		if ((v5 == (1 + 0)) or ((3892 - 1166) == (3753 + 116))) then
			return v6(...);
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
	local v106 = 11623 - (409 + 103);
	local v107 = 11347 - (46 + 190);
	local v108;
	local v109 = v18.Monk.Mistweaver;
	local v110 = v20.Monk.Mistweaver;
	local v111 = v25.Monk.Mistweaver;
	local v112 = {};
	local v113;
	local v114;
	local v115 = {{v109.LegSweep,"Cast Leg Sweep (Stun)",function()
		return true;
	end},{v109.Paralysis,"Cast Paralysis (Stun)",function()
		return true;
	end}};
	local v116 = v22.Commons.Everyone;
	local v117 = v22.Commons.Monk;
	local function v118()
		if (v109.ImprovedDetox:IsAvailable() or ((6281 - (830 + 1075)) <= (2005 - (303 + 221)))) then
			v116.DispellableDebuffs = v21.MergeTable(v116.DispellableMagicDebuffs, v116.DispellablePoisonDebuffs, v116.DispellableDiseaseDebuffs);
		else
			v116.DispellableDebuffs = v116.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v118();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v119()
		local v133 = 1269 - (231 + 1038);
		while true do
			if (((1 + 0) == v133) or ((4554 - (171 + 991)) >= (19538 - 14797))) then
				if (((8928 - 5603) >= (5374 - 3220)) and v109.ExpelHarm:IsCastable() and (v13:HealthPercentage() <= v55) and v54 and v13:BuffUp(v109.ChiHarmonyBuff)) then
					if (v24(v109.ExpelHarm, nil) or ((1037 + 258) >= (11332 - 8099))) then
						return "expel_harm defensives 3";
					end
				end
				if (((12626 - 8249) > (2646 - 1004)) and v110.Healthstone:IsReady() and v84 and (v13:HealthPercentage() <= v85)) then
					if (((14599 - 9876) > (2604 - (111 + 1137))) and v24(v111.Healthstone)) then
						return "healthstone defensive 4";
					end
				end
				v133 = 160 - (91 + 67);
			end
			if ((v133 == (0 - 0)) or ((1032 + 3104) <= (3956 - (423 + 100)))) then
				if (((30 + 4215) <= (12822 - 8191)) and v109.DampenHarm:IsCastable() and v13:BuffDown(v109.FortifyingBrew) and (v13:HealthPercentage() <= v42) and v41) then
					if (((2229 + 2047) >= (4685 - (326 + 445))) and v24(v109.DampenHarm, nil)) then
						return "dampen_harm defensives 1";
					end
				end
				if (((864 - 666) <= (9724 - 5359)) and v109.FortifyingBrew:IsCastable() and v13:BuffDown(v109.DampenHarmBuff) and (v13:HealthPercentage() <= v40) and v39) then
					if (((11161 - 6379) > (5387 - (530 + 181))) and v24(v109.FortifyingBrew, nil)) then
						return "fortifying_brew defensives 2";
					end
				end
				v133 = 882 - (614 + 267);
			end
			if (((4896 - (19 + 13)) > (3575 - 1378)) and (v133 == (4 - 2))) then
				if ((v86 and (v13:HealthPercentage() <= v87)) or ((10569 - 6869) == (652 + 1855))) then
					if (((7868 - 3394) >= (567 - 293)) and (v88 == "Refreshing Healing Potion")) then
						if (v110.RefreshingHealingPotion:IsReady() or ((3706 - (1293 + 519)) <= (2868 - 1462))) then
							if (((4104 - 2532) >= (2927 - 1396)) and v24(v111.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 5";
							end
						end
					end
					if ((v88 == "Dreamwalker's Healing Potion") or ((20210 - 15523) < (10699 - 6157))) then
						if (((1744 + 1547) > (341 + 1326)) and v110.DreamwalkersHealingPotion:IsReady()) then
							if (v24(v111.RefreshingHealingPotion) or ((2027 - 1154) == (471 + 1563))) then
								return "dreamwalkers healing potion defensive 5";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v120()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (1 + 0)) or ((3912 - (709 + 387)) < (1869 - (673 + 1185)))) then
				if (((10727 - 7028) < (15111 - 10405)) and v102) then
					local v220 = 0 - 0;
					while true do
						if (((1893 + 753) >= (655 + 221)) and (v220 == (1 - 0))) then
							v29 = v116.HandleChromie(v109.HealingSurge, v111.HealingSurgeMouseover, 10 + 30);
							if (((1223 - 609) <= (6250 - 3066)) and v29) then
								return v29;
							end
							break;
						end
						if (((5006 - (446 + 1434)) == (4409 - (1040 + 243))) and (v220 == (0 - 0))) then
							v29 = v116.HandleChromie(v109.Riptide, v111.RiptideMouseover, 1887 - (559 + 1288));
							if (v29 or ((4118 - (609 + 1322)) >= (5408 - (13 + 441)))) then
								return v29;
							end
							v220 = 3 - 2;
						end
					end
				end
				if (v103 or ((10155 - 6278) == (17805 - 14230))) then
					v29 = v116.HandleCharredTreant(v109.RenewingMist, v111.RenewingMistMouseover, 2 + 38);
					if (((2567 - 1860) > (225 + 407)) and v29) then
						return v29;
					end
					v29 = v116.HandleCharredTreant(v109.SoothingMist, v111.SoothingMistMouseover, 18 + 22);
					if (v29 or ((1620 - 1074) >= (1469 + 1215))) then
						return v29;
					end
					v29 = v116.HandleCharredTreant(v109.Vivify, v111.VivifyMouseover, 73 - 33);
					if (((969 + 496) <= (2393 + 1908)) and v29) then
						return v29;
					end
					v29 = v116.HandleCharredTreant(v109.EnvelopingMist, v111.EnvelopingMistMouseover, 29 + 11);
					if (((1431 + 273) > (1395 + 30)) and v29) then
						return v29;
					end
				end
				v134 = 435 - (153 + 280);
			end
			if ((v134 == (0 - 0)) or ((617 + 70) == (1672 + 2562))) then
				if (v101 or ((1743 + 1587) < (1297 + 132))) then
					v29 = v116.HandleIncorporeal(v109.Paralysis, v111.ParalysisMouseover, 22 + 8, true);
					if (((1745 - 598) >= (208 + 127)) and v29) then
						return v29;
					end
				end
				if (((4102 - (89 + 578)) > (1499 + 598)) and v100) then
					v29 = v116.HandleAfflicted(v109.Detox, v111.DetoxMouseover, 62 - 32);
					if (v29 or ((4819 - (572 + 477)) >= (545 + 3496))) then
						return v29;
					end
				end
				v134 = 1 + 0;
			end
			if ((v134 == (1 + 1)) or ((3877 - (84 + 2)) <= (2654 - 1043))) then
				if (v104 or ((3299 + 1279) <= (2850 - (497 + 345)))) then
					local v221 = 0 + 0;
					while true do
						if (((191 + 934) <= (3409 - (605 + 728))) and (v221 == (1 + 0))) then
							v29 = v116.HandleCharredBrambles(v109.SoothingMist, v111.SoothingMistMouseover, 88 - 48);
							if (v29 or ((35 + 708) >= (16264 - 11865))) then
								return v29;
							end
							v221 = 2 + 0;
						end
						if (((3199 - 2044) < (1264 + 409)) and ((489 - (457 + 32)) == v221)) then
							v29 = v116.HandleCharredBrambles(v109.RenewingMist, v111.RenewingMistMouseover, 17 + 23);
							if (v29 or ((3726 - (832 + 570)) <= (545 + 33))) then
								return v29;
							end
							v221 = 1 + 0;
						end
						if (((13330 - 9563) == (1815 + 1952)) and (v221 == (798 - (588 + 208)))) then
							v29 = v116.HandleCharredBrambles(v109.Vivify, v111.VivifyMouseover, 107 - 67);
							if (((5889 - (884 + 916)) == (8560 - 4471)) and v29) then
								return v29;
							end
							v221 = 2 + 1;
						end
						if (((5111 - (232 + 421)) >= (3563 - (1569 + 320))) and (v221 == (1 + 2))) then
							v29 = v116.HandleCharredBrambles(v109.EnvelopingMist, v111.EnvelopingMistMouseover, 8 + 32);
							if (((3275 - 2303) <= (2023 - (316 + 289))) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (v105 or ((12926 - 7988) < (220 + 4542))) then
					v29 = v116.HandleFyrakkNPC(v109.RenewingMist, v111.RenewingMistMouseover, 1493 - (666 + 787));
					if (v29 or ((2929 - (360 + 65)) > (3985 + 279))) then
						return v29;
					end
					v29 = v116.HandleFyrakkNPC(v109.SoothingMist, v111.SoothingMistMouseover, 294 - (79 + 175));
					if (((3394 - 1241) == (1681 + 472)) and v29) then
						return v29;
					end
					v29 = v116.HandleFyrakkNPC(v109.Vivify, v111.VivifyMouseover, 122 - 82);
					if (v29 or ((975 - 468) >= (3490 - (503 + 396)))) then
						return v29;
					end
					v29 = v116.HandleFyrakkNPC(v109.EnvelopingMist, v111.EnvelopingMistMouseover, 221 - (92 + 89));
					if (((8692 - 4211) == (2299 + 2182)) and v29) then
						return v29;
					end
				end
				break;
			end
		end
	end
	local function v121()
		local v135 = 0 + 0;
		while true do
			if ((v135 == (0 - 0)) or ((319 + 2009) < (1579 - 886))) then
				if (((3777 + 551) == (2068 + 2260)) and v109.ChiBurst:IsCastable() and v50) then
					if (((4836 - 3248) >= (167 + 1165)) and v24(v109.ChiBurst, not v15:IsInRange(61 - 21))) then
						return "chi_burst precombat 4";
					end
				end
				if ((v109.SpinningCraneKick:IsCastable() and v46 and (v114 >= (1246 - (485 + 759)))) or ((9657 - 5483) > (5437 - (442 + 747)))) then
					if (v24(v109.SpinningCraneKick, not v15:IsInMeleeRange(1143 - (832 + 303))) or ((5532 - (88 + 858)) <= (25 + 57))) then
						return "spinning_crane_kick precombat 6";
					end
				end
				v135 = 1 + 0;
			end
			if (((160 + 3703) == (4652 - (766 + 23))) and ((4 - 3) == v135)) then
				if ((v109.TigerPalm:IsCastable() and v48) or ((385 - 103) <= (110 - 68))) then
					if (((15642 - 11033) >= (1839 - (1036 + 37))) and v24(v109.TigerPalm, not v15:IsInMeleeRange(4 + 1))) then
						return "tiger_palm precombat 8";
					end
				end
				break;
			end
		end
	end
	local function v122()
		local v136 = 0 - 0;
		while true do
			if ((v136 == (2 + 0)) or ((2632 - (641 + 839)) == (3401 - (910 + 3)))) then
				if (((8723 - 5301) > (5034 - (1466 + 218))) and v109.SpinningCraneKick:IsCastable() and v46 and v15:DebuffDown(v109.MysticTouchDebuff) and v109.MysticTouch:IsAvailable()) then
					if (((404 + 473) > (1524 - (556 + 592))) and v24(v109.SpinningCraneKick, not v15:IsInMeleeRange(3 + 5))) then
						return "spinning_crane_kick aoe 5";
					end
				end
				if ((v109.BlackoutKick:IsCastable() and v109.AncientConcordance:IsAvailable() and v13:BuffUp(v109.JadefireStomp) and v45 and (v114 >= (811 - (329 + 479)))) or ((3972 - (174 + 680)) <= (6360 - 4509))) then
					if (v24(v109.BlackoutKick, not v15:IsInMeleeRange(10 - 5)) or ((118 + 47) >= (4231 - (396 + 343)))) then
						return "blackout_kick aoe 6";
					end
				end
				v136 = 1 + 2;
			end
			if (((5426 - (29 + 1448)) < (6245 - (135 + 1254))) and (v136 == (3 - 2))) then
				if ((v109.JadefireStomp:IsReady() and v49) or ((19965 - 15689) < (2010 + 1006))) then
					if (((6217 - (389 + 1138)) > (4699 - (102 + 472))) and v24(v109.JadefireStomp, nil)) then
						return "JadefireStomp aoe3";
					end
				end
				if ((v109.ChiBurst:IsCastable() and v50) or ((48 + 2) >= (497 + 399))) then
					if (v24(v109.ChiBurst, not v15:IsInRange(38 + 2)) or ((3259 - (320 + 1225)) >= (5265 - 2307))) then
						return "chi_burst aoe 4";
					end
				end
				v136 = 2 + 0;
			end
			if ((v136 == (1464 - (157 + 1307))) or ((3350 - (821 + 1038)) < (1606 - 962))) then
				if (((77 + 627) < (1753 - 766)) and v109.SummonWhiteTigerStatue:IsReady() and (v114 >= (2 + 1)) and v44) then
					if (((9215 - 5497) > (2932 - (834 + 192))) and (v43 == "Player")) then
						if (v24(v111.SummonWhiteTigerStatuePlayer, not v15:IsInRange(3 + 37)) or ((246 + 712) > (79 + 3556))) then
							return "summon_white_tiger_statue aoe player 1";
						end
					elseif (((5423 - 1922) <= (4796 - (300 + 4))) and (v43 == "Cursor")) then
						if (v24(v111.SummonWhiteTigerStatueCursor, not v15:IsInRange(11 + 29)) or ((9010 - 5568) < (2910 - (112 + 250)))) then
							return "summon_white_tiger_statue aoe cursor 1";
						end
					elseif (((1147 + 1728) >= (3667 - 2203)) and (v43 == "Friendly under Cursor") and v16:Exists() and not v13:CanAttack(v16)) then
						if (v24(v111.SummonWhiteTigerStatueCursor, not v15:IsInRange(23 + 17)) or ((2481 + 2316) >= (3660 + 1233))) then
							return "summon_white_tiger_statue aoe cursor friendly 1";
						end
					elseif (((v43 == "Enemy under Cursor") and v16:Exists() and v13:CanAttack(v16)) or ((274 + 277) > (1537 + 531))) then
						if (((3528 - (1001 + 413)) > (2104 - 1160)) and v24(v111.SummonWhiteTigerStatueCursor, not v15:IsInRange(922 - (244 + 638)))) then
							return "summon_white_tiger_statue aoe cursor enemy 1";
						end
					elseif ((v43 == "Confirmation") or ((2955 - (627 + 66)) >= (9224 - 6128))) then
						if (v24(v111.SummonWhiteTigerStatue, not v15:IsInRange(642 - (512 + 90))) or ((4161 - (1665 + 241)) >= (4254 - (373 + 344)))) then
							return "summon_white_tiger_statue aoe confirmation 1";
						end
					end
				end
				if ((v109.TouchofDeath:IsCastable() and v51) or ((1731 + 2106) < (346 + 960))) then
					if (((7781 - 4831) == (4992 - 2042)) and v24(v109.TouchofDeath, not v15:IsInMeleeRange(1104 - (35 + 1064)))) then
						return "touch_of_death aoe 2";
					end
				end
				v136 = 1 + 0;
			end
			if ((v136 == (6 - 3)) or ((19 + 4704) < (4534 - (298 + 938)))) then
				if (((2395 - (233 + 1026)) >= (1820 - (636 + 1030))) and v109.TigerPalm:IsCastable() and v109.TeachingsoftheMonastery:IsAvailable() and (v109.BlackoutKick:CooldownRemains() > (0 + 0)) and v48 and (v114 >= (3 + 0))) then
					if (v24(v109.TigerPalm, not v15:IsInMeleeRange(2 + 3)) or ((19 + 252) > (4969 - (55 + 166)))) then
						return "tiger_palm aoe 7";
					end
				end
				if (((919 + 3821) >= (317 + 2835)) and v109.SpinningCraneKick:IsCastable() and v46) then
					if (v24(v109.SpinningCraneKick, not v15:IsInMeleeRange(30 - 22)) or ((2875 - (36 + 261)) >= (5928 - 2538))) then
						return "spinning_crane_kick aoe 8";
					end
				end
				break;
			end
		end
	end
	local function v123()
		if (((1409 - (34 + 1334)) <= (639 + 1022)) and v109.TouchofDeath:IsCastable() and v51) then
			if (((467 + 134) < (4843 - (1035 + 248))) and v24(v109.TouchofDeath, not v15:IsInMeleeRange(26 - (20 + 1)))) then
				return "touch_of_death st 1";
			end
		end
		if (((123 + 112) < (1006 - (134 + 185))) and v109.JadefireStomp:IsReady() and v49) then
			if (((5682 - (549 + 584)) > (1838 - (314 + 371))) and v24(v109.JadefireStomp, nil)) then
				return "JadefireStomp st 2";
			end
		end
		if ((v109.RisingSunKick:IsReady() and v47) or ((16045 - 11371) < (5640 - (478 + 490)))) then
			if (((1944 + 1724) < (5733 - (786 + 386))) and v24(v109.RisingSunKick, not v15:IsInMeleeRange(16 - 11))) then
				return "rising_sun_kick st 3";
			end
		end
		if ((v109.ChiBurst:IsCastable() and v50) or ((1834 - (1055 + 324)) == (4945 - (1093 + 247)))) then
			if (v24(v109.ChiBurst, not v15:IsInRange(36 + 4)) or ((281 + 2382) == (13149 - 9837))) then
				return "chi_burst st 4";
			end
		end
		if (((14515 - 10238) <= (12733 - 8258)) and v109.BlackoutKick:IsCastable() and (v13:BuffStack(v109.TeachingsoftheMonasteryBuff) == (7 - 4)) and (v109.RisingSunKick:CooldownRemains() > v13:GCD()) and v45) then
			if (v24(v109.BlackoutKick, not v15:IsInMeleeRange(2 + 3)) or ((3351 - 2481) == (4098 - 2909))) then
				return "blackout_kick st 5";
			end
		end
		if (((1172 + 381) <= (8011 - 4878)) and v109.TigerPalm:IsCastable() and ((v13:BuffStack(v109.TeachingsoftheMonasteryBuff) < (691 - (364 + 324))) or (v13:BuffRemains(v109.TeachingsoftheMonasteryBuff) < (5 - 3))) and v48) then
			if (v24(v109.TigerPalm, not v15:IsInMeleeRange(11 - 6)) or ((742 + 1495) >= (14691 - 11180))) then
				return "tiger_palm st 6";
			end
		end
	end
	local function v124()
		if ((v52 and v109.RenewingMist:IsReady() and v17:BuffDown(v109.RenewingMistBuff) and (v109.RenewingMist:ChargesFractional() >= (1.8 - 0))) or ((4020 - 2696) > (4288 - (1249 + 19)))) then
			if ((v17:HealthPercentage() <= v53) or ((2701 + 291) == (7321 - 5440))) then
				if (((4192 - (686 + 400)) > (1198 + 328)) and v24(v111.RenewingMistFocus, not v17:IsSpellInRange(v109.RenewingMist))) then
					return "RenewingMist healing st";
				end
			end
		end
		if (((3252 - (73 + 156)) < (19 + 3851)) and v47 and v109.RisingSunKick:IsReady() and (v116.FriendlyUnitsWithBuffCount(v109.RenewingMistBuff, false, false, 836 - (721 + 90)) > (1 + 0))) then
			if (((464 - 321) > (544 - (224 + 246))) and v24(v109.RisingSunKick, not v15:IsInMeleeRange(8 - 3))) then
				return "RisingSunKick healing st";
			end
		end
		if (((32 - 14) < (384 + 1728)) and v52 and v109.RenewingMist:IsReady() and v17:BuffDown(v109.RenewingMistBuff)) then
			if (((27 + 1070) <= (1196 + 432)) and (v17:HealthPercentage() <= v53)) then
				if (((9205 - 4575) == (15407 - 10777)) and v24(v111.RenewingMistFocus, not v17:IsSpellInRange(v109.RenewingMist))) then
					return "RenewingMist healing st";
				end
			end
		end
		if (((4053 - (203 + 310)) > (4676 - (1238 + 755))) and v56 and v109.Vivify:IsReady() and v13:BuffUp(v109.VivaciousVivificationBuff)) then
			if (((335 + 4459) >= (4809 - (709 + 825))) and (v17:HealthPercentage() <= v57)) then
				if (((2734 - 1250) == (2161 - 677)) and v24(v111.VivifyFocus, not v17:IsSpellInRange(v109.Vivify))) then
					return "Vivify instant healing st";
				end
			end
		end
		if (((2296 - (196 + 668)) < (14036 - 10481)) and v60 and v109.SoothingMist:IsReady() and v17:BuffDown(v109.SoothingMist)) then
			if ((v17:HealthPercentage() <= v61) or ((2206 - 1141) > (4411 - (171 + 662)))) then
				if (v24(v111.SoothingMistFocus, not v17:IsSpellInRange(v109.SoothingMist)) or ((4888 - (4 + 89)) < (4931 - 3524))) then
					return "SoothingMist healing st";
				end
			end
		end
	end
	local function v125()
		local v137 = 0 + 0;
		while true do
			if (((8138 - 6285) < (1888 + 2925)) and (v137 == (1486 - (35 + 1451)))) then
				if ((v47 and v109.RisingSunKick:IsReady() and (v116.FriendlyUnitsWithBuffCount(v109.RenewingMistBuff, false, false, 1478 - (28 + 1425)) > (1994 - (941 + 1052)))) or ((2705 + 116) < (3945 - (822 + 692)))) then
					if (v24(v109.RisingSunKick, not v15:IsInMeleeRange(6 - 1)) or ((1354 + 1520) < (2478 - (45 + 252)))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (v116.AreUnitsBelowHealthPercentage(v64, v63) or ((2661 + 28) <= (119 + 224))) then
					local v222 = 0 - 0;
					while true do
						if ((v222 == (434 - (114 + 319))) or ((2682 - 813) == (2573 - 564))) then
							if ((v62 and v109.EssenceFont:IsReady() and (v13:BuffUp(v109.ThunderFocusTea) or (v109.ThunderFocusTea:CooldownRemains() > (6 + 2)))) or ((5282 - 1736) < (4864 - 2542))) then
								if (v24(v109.EssenceFont, nil) or ((4045 - (556 + 1407)) == (5979 - (741 + 465)))) then
									return "EssenceFont healing aoe";
								end
							end
							break;
						end
						if (((3709 - (170 + 295)) > (556 + 499)) and (v222 == (0 + 0))) then
							if ((v36 and (v13:BuffStack(v109.ManaTeaCharges) > v37) and v109.EssenceFont:IsReady() and v109.ManaTea:IsCastable()) or ((8156 - 4843) <= (1474 + 304))) then
								if (v24(v109.ManaTea, nil) or ((912 + 509) >= (1192 + 912))) then
									return "EssenceFont healing aoe";
								end
							end
							if (((3042 - (957 + 273)) <= (869 + 2380)) and v38 and v109.ThunderFocusTea:IsReady() and (v109.EssenceFont:CooldownRemains() < v13:GCD())) then
								if (((650 + 973) <= (7457 - 5500)) and v24(v109.ThunderFocusTea, nil)) then
									return "ThunderFocusTea healing aoe";
								end
							end
							v222 = 2 - 1;
						end
					end
				end
				v137 = 2 - 1;
			end
			if (((21846 - 17434) == (6192 - (389 + 1391))) and (v137 == (2 + 0))) then
				if (((183 + 1567) >= (1916 - 1074)) and v70 and v109.SheilunsGift:IsReady() and v109.SheilunsGift:IsCastable() and v116.AreUnitsBelowHealthPercentage(v72, v71)) then
					if (((5323 - (783 + 168)) > (6208 - 4358)) and v24(v109.SheilunsGift, nil)) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
			if (((229 + 3) < (1132 - (309 + 2))) and (v137 == (2 - 1))) then
				if (((1730 - (1090 + 122)) < (293 + 609)) and v62 and v109.EssenceFont:IsReady() and v109.AncientTeachings:IsAvailable() and v13:BuffDown(v109.EssenceFontBuff)) then
					if (((10055 - 7061) > (588 + 270)) and v24(v109.EssenceFont, nil)) then
						return "EssenceFont healing aoe";
					end
				end
				if ((v67 and v109.ZenPulse:IsReady() and v116.AreUnitsBelowHealthPercentage(v69, v68)) or ((4873 - (628 + 490)) <= (165 + 750))) then
					if (((9769 - 5823) > (17105 - 13362)) and v24(v111.ZenPulseFocus, not v17:IsSpellInRange(v109.ZenPulse))) then
						return "ZenPulse healing aoe";
					end
				end
				v137 = 776 - (431 + 343);
			end
		end
	end
	local function v126()
		if ((v58 and v109.EnvelopingMist:IsReady() and (v116.FriendlyUnitsWithBuffCount(v109.EnvelopingMist, false, false, 50 - 25) < (8 - 5))) or ((1055 + 280) >= (423 + 2883))) then
			v29 = v116.FocusUnitRefreshableBuff(v109.EnvelopingMist, 1697 - (556 + 1139), 55 - (6 + 9), nil, false, 5 + 20);
			if (((2482 + 2362) > (2422 - (28 + 141))) and v29) then
				return v29;
			end
			if (((176 + 276) == (557 - 105)) and v24(v111.EnvelopingMistFocus, not v17:IsSpellInRange(v109.EnvelopingMist))) then
				return "Enveloping Mist YuLon";
			end
		end
		if ((v47 and v109.RisingSunKick:IsReady() and (v116.FriendlyUnitsWithBuffCount(v109.EnvelopingMist, false, false, 18 + 7) > (1319 - (486 + 831)))) or ((11858 - 7301) < (7347 - 5260))) then
			if (((733 + 3141) == (12249 - 8375)) and v24(v109.RisingSunKick, not v15:IsInMeleeRange(1268 - (668 + 595)))) then
				return "Rising Sun Kick YuLon";
			end
		end
		if ((v60 and v109.SoothingMist:IsReady() and v17:BuffUp(v109.ChiHarmonyBuff) and v17:BuffDown(v109.SoothingMist)) or ((1744 + 194) > (996 + 3939))) then
			if (v24(v111.SoothingMistFocus, not v17:IsSpellInRange(v109.SoothingMist)) or ((11603 - 7348) < (3713 - (23 + 267)))) then
				return "Soothing Mist YuLon";
			end
		end
	end
	local function v127()
		if (((3398 - (1129 + 815)) <= (2878 - (371 + 16))) and v45 and v109.BlackoutKick:IsReady() and (v13:BuffStack(v109.TeachingsoftheMonastery) >= (1753 - (1326 + 424)))) then
			if (v24(v109.BlackoutKick, not v15:IsInMeleeRange(9 - 4)) or ((15190 - 11033) <= (2921 - (88 + 30)))) then
				return "Blackout Kick ChiJi";
			end
		end
		if (((5624 - (720 + 51)) >= (6633 - 3651)) and v58 and v109.EnvelopingMist:IsReady() and (v13:BuffStack(v109.InvokeChiJiBuff) == (1779 - (421 + 1355)))) then
			if (((6819 - 2685) > (1650 + 1707)) and (v17:HealthPercentage() <= v59)) then
				if (v24(v111.EnvelopingMistFocus, not v17:IsSpellInRange(v109.EnvelopingMist)) or ((4500 - (286 + 797)) < (9263 - 6729))) then
					return "Enveloping Mist 3 Stacks ChiJi";
				end
			end
		end
		if ((v47 and v109.RisingSunKick:IsReady()) or ((4508 - 1786) <= (603 - (397 + 42)))) then
			if (v24(v109.RisingSunKick, not v15:IsInMeleeRange(2 + 3)) or ((3208 - (24 + 776)) < (3248 - 1139))) then
				return "Rising Sun Kick ChiJi";
			end
		end
		if ((v58 and v109.EnvelopingMist:IsReady() and (v13:BuffStack(v109.InvokeChiJiBuff) >= (787 - (222 + 563)))) or ((72 - 39) == (1048 + 407))) then
			if ((v17:HealthPercentage() <= v59) or ((633 - (23 + 167)) >= (5813 - (690 + 1108)))) then
				if (((1221 + 2161) > (137 + 29)) and v24(v111.EnvelopingMistFocus, not v17:IsSpellInRange(v109.EnvelopingMist))) then
					return "Enveloping Mist 2 Stacks ChiJi";
				end
			end
		end
		if ((v62 and v109.EssenceFont:IsReady() and v109.AncientTeachings:IsAvailable() and v13:BuffDown(v109.AncientTeachings)) or ((1128 - (40 + 808)) == (504 + 2555))) then
			if (((7192 - 5311) > (1236 + 57)) and v24(v109.EssenceFont, nil)) then
				return "Essence Font ChiJi";
			end
		end
	end
	local function v128()
		local v138 = 0 + 0;
		while true do
			if (((1293 + 1064) == (2928 - (47 + 524))) and (v138 == (1 + 0))) then
				if (((336 - 213) == (183 - 60)) and v81 and v109.Restoral:IsReady() and v109.Restoral:IsAvailable() and v116.AreUnitsBelowHealthPercentage(v83, v82)) then
					if (v24(v109.Restoral, nil) or ((2408 - 1352) >= (5118 - (1165 + 561)))) then
						return "Restoral CD";
					end
				end
				if ((v73 and v109.InvokeYulonTheJadeSerpent:IsAvailable() and v109.InvokeYulonTheJadeSerpent:IsReady() and v116.AreUnitsBelowHealthPercentage(v75, v74)) or ((33 + 1048) < (3329 - 2254))) then
					if ((v52 and v109.RenewingMist:IsReady() and (v109.RenewingMist:ChargesFractional() >= (1 + 0))) or ((1528 - (341 + 138)) >= (1197 + 3235))) then
						local v229 = 0 - 0;
						while true do
							if ((v229 == (326 - (89 + 237))) or ((15338 - 10570) <= (1780 - 934))) then
								v29 = v116.FocusUnitRefreshableBuff(v109.RenewingMistBuff, 887 - (581 + 300), 1260 - (855 + 365), nil, false, 59 - 34);
								if (v29 or ((1097 + 2261) <= (2655 - (1030 + 205)))) then
									return v29;
								end
								v229 = 1 + 0;
							end
							if ((v229 == (1 + 0)) or ((4025 - (156 + 130)) <= (6827 - 3822))) then
								if (v24(v111.RenewingMistFocus, not v17:IsSpellInRange(v109.RenewingMist)) or ((2795 - 1136) >= (4370 - 2236))) then
									return "Renewing Mist YuLon prep";
								end
								break;
							end
						end
					end
					if ((v36 and v109.ManaTea:IsCastable() and (v13:BuffStack(v109.ManaTeaCharges) >= (1 + 2)) and v13:BuffDown(v109.ManaTeaBuff)) or ((1901 + 1359) < (2424 - (10 + 59)))) then
						if (v24(v109.ManaTea, nil) or ((190 + 479) == (20797 - 16574))) then
							return "ManaTea YuLon prep";
						end
					end
					if ((v70 and v109.SheilunsGift:IsReady() and (v109.SheilunsGift:TimeSinceLastCast() > (1183 - (671 + 492)))) or ((1347 + 345) < (1803 - (369 + 846)))) then
						if (v24(v109.SheilunsGift, nil) or ((1270 + 3527) < (3116 + 535))) then
							return "Sheilun's Gift YuLon prep";
						end
					end
					if ((v109.InvokeYulonTheJadeSerpent:IsReady() and (v109.RenewingMist:ChargesFractional() < (1946 - (1036 + 909))) and v13:BuffUp(v109.ManaTeaBuff) and (v109.SheilunsGift:TimeSinceLastCast() < ((4 + 0) * v13:GCD()))) or ((7012 - 2835) > (5053 - (11 + 192)))) then
						if (v24(v109.InvokeYulonTheJadeSerpent, nil) or ((203 + 197) > (1286 - (135 + 40)))) then
							return "Invoke Yu'lon GO";
						end
					end
				end
				v138 = 4 - 2;
			end
			if (((1840 + 1211) > (2213 - 1208)) and (v138 == (0 - 0))) then
				if (((3869 - (50 + 126)) <= (12201 - 7819)) and v79 and v109.LifeCocoon:IsReady() and (v17:HealthPercentage() <= v80)) then
					if (v24(v111.LifeCocoonFocus, not v17:IsSpellInRange(v109.LifeCocoon)) or ((727 + 2555) > (5513 - (1233 + 180)))) then
						return "Life Cocoon CD";
					end
				end
				if ((v81 and v109.Revival:IsReady() and v109.Revival:IsAvailable() and v116.AreUnitsBelowHealthPercentage(v83, v82)) or ((4549 - (522 + 447)) < (4265 - (107 + 1314)))) then
					if (((42 + 47) < (13681 - 9191)) and v24(v109.Revival, nil)) then
						return "Revival CD";
					end
				end
				v138 = 1 + 0;
			end
			if ((v138 == (5 - 2)) or ((19715 - 14732) < (3718 - (716 + 1194)))) then
				if (((66 + 3763) > (404 + 3365)) and (v109.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (528 - (74 + 429)))) then
					local v223 = 0 - 0;
					while true do
						if (((736 + 749) <= (6647 - 3743)) and ((0 + 0) == v223)) then
							v29 = v127();
							if (((13160 - 8891) == (10555 - 6286)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				break;
			end
			if (((820 - (279 + 154)) <= (3560 - (454 + 324))) and (v138 == (2 + 0))) then
				if ((v109.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (42 - (12 + 5))) or ((1024 + 875) <= (2336 - 1419))) then
					local v224 = 0 + 0;
					while true do
						if (((1093 - (277 + 816)) == v224) or ((18425 - 14113) <= (2059 - (1058 + 125)))) then
							v29 = v126();
							if (((419 + 1813) <= (3571 - (815 + 160))) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (((8988 - 6893) < (8749 - 5063)) and v76 and v109.InvokeChiJiTheRedCrane:IsReady() and v109.InvokeChiJiTheRedCrane:IsAvailable() and v116.AreUnitsBelowHealthPercentage(v78, v77)) then
					local v225 = 0 + 0;
					while true do
						if (((2 - 1) == v225) or ((3493 - (41 + 1857)) >= (6367 - (1222 + 671)))) then
							if ((v109.InvokeChiJiTheRedCrane:IsReady() and (v109.RenewingMist:ChargesFractional() < (2 - 1)) and v13:BuffUp(v109.AncientTeachings) and (v13:BuffStack(v109.TeachingsoftheMonastery) == (3 - 0)) and (v109.SheilunsGift:TimeSinceLastCast() < ((1186 - (229 + 953)) * v13:GCD()))) or ((6393 - (1111 + 663)) < (4461 - (874 + 705)))) then
								if (v24(v109.InvokeChiJiTheRedCrane, nil) or ((42 + 252) >= (3297 + 1534))) then
									return "Invoke Chi'ji GO";
								end
							end
							break;
						end
						if (((4217 - 2188) <= (87 + 2997)) and (v225 == (679 - (642 + 37)))) then
							if ((v52 and v109.RenewingMist:IsReady() and (v109.RenewingMist:ChargesFractional() >= (1 + 0))) or ((326 + 1711) == (6076 - 3656))) then
								v29 = v116.FocusUnitRefreshableBuff(v109.RenewingMistBuff, 460 - (233 + 221), 92 - 52, nil, false, 23 + 2);
								if (((5999 - (718 + 823)) > (2457 + 1447)) and v29) then
									return v29;
								end
								if (((1241 - (266 + 539)) >= (347 - 224)) and v24(v111.RenewingMistFocus, not v17:IsSpellInRange(v109.RenewingMist))) then
									return "Renewing Mist ChiJi prep";
								end
							end
							if (((1725 - (636 + 589)) < (4310 - 2494)) and v70 and v109.SheilunsGift:IsReady() and (v109.SheilunsGift:TimeSinceLastCast() > (41 - 21))) then
								if (((2833 + 741) == (1299 + 2275)) and v24(v109.SheilunsGift, nil)) then
									return "Sheilun's Gift ChiJi prep";
								end
							end
							v225 = 1016 - (657 + 358);
						end
					end
				end
				v138 = 7 - 4;
			end
		end
	end
	local function v129()
		v36 = EpicSettings.Settings['UseManaTea'];
		v37 = EpicSettings.Settings['ManaTeaStacks'];
		v38 = EpicSettings.Settings['UseThunderFocusTea'];
		v39 = EpicSettings.Settings['UseFortifyingBrew'];
		v40 = EpicSettings.Settings['FortifyingBrewHP'];
		v41 = EpicSettings.Settings['UseDampenHarm'];
		v42 = EpicSettings.Settings['DampenHarmHP'];
		v43 = EpicSettings.Settings['WhiteTigerUsage'];
		v44 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
		v45 = EpicSettings.Settings['UseBlackoutKick'];
		v46 = EpicSettings.Settings['UseSpinningCraneKick'];
		v47 = EpicSettings.Settings['UseRisingSunKick'];
		v48 = EpicSettings.Settings['UseTigerPalm'];
		v49 = EpicSettings.Settings['UseJadefireStomp'];
		v50 = EpicSettings.Settings['UseChiBurst'];
		v51 = EpicSettings.Settings['UseTouchOfDeath'];
		v52 = EpicSettings.Settings['UseRenewingMist'];
		v53 = EpicSettings.Settings['RenewingMistHP'];
		v54 = EpicSettings.Settings['UseExpelHarm'];
		v55 = EpicSettings.Settings['ExpelHarmHP'];
		v56 = EpicSettings.Settings['UseVivify'];
		v57 = EpicSettings.Settings['VivifyHP'];
		v58 = EpicSettings.Settings['UseEnvelopingMist'];
		v59 = EpicSettings.Settings['EnvelopingMistHP'];
		v60 = EpicSettings.Settings['UseSoothingMist'];
		v61 = EpicSettings.Settings['SoothingMistHP'];
		v62 = EpicSettings.Settings['UseEssenceFont'];
		v64 = EpicSettings.Settings['EssenceFontHP'];
		v63 = EpicSettings.Settings['EssenceFontGroup'];
		v66 = EpicSettings.Settings['UseJadeSerpent'];
		v65 = EpicSettings.Settings['JadeSerpentUsage'];
		v67 = EpicSettings.Settings['UseZenPulse'];
		v69 = EpicSettings.Settings['ZenPulseHP'];
		v68 = EpicSettings.Settings['ZenPulseGroup'];
		v70 = EpicSettings.Settings['UseSheilunsGift'];
		v72 = EpicSettings.Settings['SheilunsGiftHP'];
		v71 = EpicSettings.Settings['SheilunsGiftGroup'];
	end
	local function v130()
		v96 = EpicSettings.Settings['racialsWithCD'];
		v95 = EpicSettings.Settings['useRacials'];
		v98 = EpicSettings.Settings['trinketsWithCD'];
		v97 = EpicSettings.Settings['useTrinkets'];
		v99 = EpicSettings.Settings['fightRemainsCheck'];
		v89 = EpicSettings.Settings['dispelDebuffs'];
		v86 = EpicSettings.Settings['useHealingPotion'];
		v87 = EpicSettings.Settings['healingPotionHP'];
		v88 = EpicSettings.Settings['HealingPotionName'];
		v84 = EpicSettings.Settings['useHealthstone'];
		v85 = EpicSettings.Settings['healthstoneHP'];
		v92 = EpicSettings.Settings['InterruptThreshold'];
		v90 = EpicSettings.Settings['InterruptWithStun'];
		v91 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v93 = EpicSettings.Settings['useSpearHandStrike'];
		v94 = EpicSettings.Settings['useLegSweep'];
		v100 = EpicSettings.Settings['handleAfflicted'];
		v101 = EpicSettings.Settings['HandleIncorporeal'];
		v102 = EpicSettings.Settings['HandleChromie'];
		v104 = EpicSettings.Settings['HandleCharredBrambles'];
		v103 = EpicSettings.Settings['HandleCharredTreant'];
		v105 = EpicSettings.Settings['HandleFyrakkNPC'];
		v73 = EpicSettings.Settings['UseInvokeYulon'];
		v75 = EpicSettings.Settings['InvokeYulonHP'];
		v74 = EpicSettings.Settings['InvokeYulonGroup'];
		v76 = EpicSettings.Settings['UseInvokeChiJi'];
		v78 = EpicSettings.Settings['InvokeChiJiHP'];
		v77 = EpicSettings.Settings['InvokeChiJiGroup'];
		v79 = EpicSettings.Settings['UseLifeCocoon'];
		v80 = EpicSettings.Settings['LifeCocoonHP'];
		v81 = EpicSettings.Settings['UseRevival'];
		v83 = EpicSettings.Settings['RevivalHP'];
		v82 = EpicSettings.Settings['RevivalGroup'];
	end
	local function v131()
		local v209 = 0 - 0;
		while true do
			if (((1408 - (1151 + 36)) < (377 + 13)) and (v209 == (1 + 1))) then
				if (v13:IsDeadOrGhost() or ((6608 - 4395) <= (3253 - (1552 + 280)))) then
					return;
				end
				v113 = v13:GetEnemiesInMeleeRange(842 - (64 + 770));
				if (((2077 + 981) < (11032 - 6172)) and v31) then
					v114 = #v113;
				else
					v114 = 1 + 0;
				end
				if (v116.TargetIsValid() or v13:AffectingCombat() or ((2539 - (157 + 1086)) >= (8898 - 4452))) then
					local v226 = 0 - 0;
					while true do
						if (((1 - 0) == v226) or ((1900 - 507) > (5308 - (599 + 220)))) then
							v107 = v106;
							if ((v107 == (22126 - 11015)) or ((6355 - (1813 + 118)) < (20 + 7))) then
								v107 = v10.FightRemains(v108, false);
							end
							break;
						end
						if ((v226 == (1217 - (841 + 376))) or ((2798 - 801) > (887 + 2928))) then
							v108 = v13:GetEnemiesInRange(109 - 69);
							v106 = v10.BossFightRemains(nil, true);
							v226 = 860 - (464 + 395);
						end
					end
				end
				v209 = 7 - 4;
			end
			if (((1665 + 1800) > (2750 - (467 + 370))) and (v209 == (8 - 4))) then
				if (((539 + 194) < (6235 - 4416)) and not v13:AffectingCombat() and v30) then
					local v227 = 0 + 0;
					while true do
						if ((v227 == (0 - 0)) or ((4915 - (150 + 370)) == (6037 - (74 + 1208)))) then
							v29 = v121();
							if (v29 or ((9329 - 5536) < (11235 - 8866))) then
								return v29;
							end
							break;
						end
					end
				end
				if (v30 or v13:AffectingCombat() or ((2906 + 1178) == (655 - (14 + 376)))) then
					if (((7558 - 3200) == (2820 + 1538)) and v34) then
						if ((v109.SummonJadeSerpentStatue:IsReady() and v109.SummonJadeSerpentStatue:IsAvailable() and (v109.SummonJadeSerpentStatue:TimeSinceLastCast() > (80 + 10)) and v66) or ((2993 + 145) < (2909 - 1916))) then
							if (((2506 + 824) > (2401 - (23 + 55))) and (v65 == "Player")) then
								if (v24(v111.SummonJadeSerpentStatuePlayer, not v15:IsInRange(94 - 54)) or ((2420 + 1206) == (3583 + 406))) then
									return "jade serpent main player";
								end
							elseif ((v65 == "Cursor") or ((1420 - 504) == (841 + 1830))) then
								if (((1173 - (652 + 249)) == (727 - 455)) and v24(v111.SummonJadeSerpentStatueCursor, not v15:IsInRange(1908 - (708 + 1160)))) then
									return "jade serpent main cursor";
								end
							elseif (((11533 - 7284) <= (8822 - 3983)) and (v65 == "Confirmation")) then
								if (((2804 - (10 + 17)) < (719 + 2481)) and v24(v109.SummonJadeSerpentStatue, not v15:IsInRange(1772 - (1400 + 332)))) then
									return "jade serpent main confirmation";
								end
							end
						end
						if (((182 - 87) < (3865 - (242 + 1666))) and v36 and (v13:BuffStack(v109.ManaTeaCharges) >= (8 + 10)) and v109.ManaTea:IsCastable()) then
							if (((303 + 523) < (1464 + 253)) and v24(v109.ManaTea, nil)) then
								return "Mana Tea main avoid overcap";
							end
						end
						if (((2366 - (850 + 90)) >= (1934 - 829)) and (v107 > v99) and v32) then
							v29 = v128();
							if (((4144 - (360 + 1030)) <= (2991 + 388)) and v29) then
								return v29;
							end
						end
						if (v31 or ((11084 - 7157) == (1943 - 530))) then
							v29 = v125();
							if (v29 or ((2815 - (909 + 752)) <= (2011 - (109 + 1114)))) then
								return v29;
							end
						end
						v29 = v124();
						if (v29 or ((3007 - 1364) > (1316 + 2063))) then
							return v29;
						end
					end
				end
				if (((v30 or v13:AffectingCombat()) and v116.TargetIsValid() and v13:CanAttack(v15)) or ((3045 - (6 + 236)) > (2867 + 1682))) then
					v29 = v119();
					if (v29 or ((178 + 42) >= (7126 - 4104))) then
						return v29;
					end
					if (((4928 - 2106) == (3955 - (1076 + 57))) and v97 and ((v32 and v98) or not v98)) then
						v29 = v116.HandleTopTrinket(v112, v32, 7 + 33, nil);
						if (v29 or ((1750 - (579 + 110)) == (147 + 1710))) then
							return v29;
						end
						v29 = v116.HandleBottomTrinket(v112, v32, 36 + 4, nil);
						if (((1465 + 1295) > (1771 - (174 + 233))) and v29) then
							return v29;
						end
					end
					if (v35 or ((13692 - 8790) <= (6309 - 2714))) then
						local v230 = 0 + 0;
						while true do
							if ((v230 == (1175 - (663 + 511))) or ((3437 + 415) == (64 + 229))) then
								if (((v114 >= (9 - 6)) and v31) or ((945 + 614) == (10801 - 6213))) then
									local v233 = 0 - 0;
									while true do
										if ((v233 == (0 + 0)) or ((8727 - 4243) == (562 + 226))) then
											v29 = v122();
											if (((418 + 4150) >= (4629 - (478 + 244))) and v29) then
												return v29;
											end
											break;
										end
									end
								end
								if (((1763 - (440 + 77)) < (1578 + 1892)) and (v114 < (10 - 7))) then
									local v234 = 1556 - (655 + 901);
									while true do
										if (((755 + 3313) >= (745 + 227)) and (v234 == (0 + 0))) then
											v29 = v123();
											if (((1985 - 1492) < (5338 - (695 + 750))) and v29) then
												return v29;
											end
											break;
										end
									end
								end
								break;
							end
							if ((v230 == (0 - 0)) or ((2272 - 799) >= (13400 - 10068))) then
								if ((v95 and ((v32 and v96) or not v96) and (v107 < (369 - (285 + 66)))) or ((9443 - 5392) <= (2467 - (682 + 628)))) then
									if (((98 + 506) < (3180 - (176 + 123))) and v109.BloodFury:IsCastable()) then
										if (v24(v109.BloodFury, nil) or ((377 + 523) == (2450 + 927))) then
											return "blood_fury main 4";
										end
									end
									if (((4728 - (239 + 30)) > (161 + 430)) and v109.Berserking:IsCastable()) then
										if (((3266 + 132) >= (4238 - 1843)) and v24(v109.Berserking, nil)) then
											return "berserking main 6";
										end
									end
									if (v109.LightsJudgment:IsCastable() or ((6810 - 4627) >= (3139 - (306 + 9)))) then
										if (((6755 - 4819) == (337 + 1599)) and v24(v109.LightsJudgment, not v15:IsInRange(25 + 15))) then
											return "lights_judgment main 8";
										end
									end
									if (v109.Fireblood:IsCastable() or ((2326 + 2506) < (12333 - 8020))) then
										if (((5463 - (1140 + 235)) > (2466 + 1408)) and v24(v109.Fireblood, nil)) then
											return "fireblood main 10";
										end
									end
									if (((3973 + 359) == (1112 + 3220)) and v109.AncestralCall:IsCastable()) then
										if (((4051 - (33 + 19)) >= (1048 + 1852)) and v24(v109.AncestralCall, nil)) then
											return "ancestral_call main 12";
										end
									end
									if (v109.BagofTricks:IsCastable() or ((7567 - 5042) > (1791 + 2273))) then
										if (((8571 - 4200) == (4099 + 272)) and v24(v109.BagofTricks, not v15:IsInRange(729 - (586 + 103)))) then
											return "bag_of_tricks main 14";
										end
									end
								end
								if ((v38 and v109.ThunderFocusTea:IsReady() and not v109.EssenceFont:IsAvailable() and (v109.RisingSunKick:CooldownRemains() < v13:GCD())) or ((25 + 241) > (15350 - 10364))) then
									if (((3479 - (1309 + 179)) >= (1669 - 744)) and v24(v109.ThunderFocusTea, nil)) then
										return "ThunderFocusTea main 16";
									end
								end
								v230 = 1 + 0;
							end
						end
					end
				end
				break;
			end
			if (((1221 - 766) < (1551 + 502)) and (v209 == (5 - 2))) then
				v29 = v120();
				if (v29 or ((1645 - 819) == (5460 - (295 + 314)))) then
					return v29;
				end
				if (((449 - 266) == (2145 - (1300 + 662))) and (v13:AffectingCombat() or v30)) then
					local v228 = v89 and v109.Detox:IsReady() and v33;
					v29 = v116.FocusUnit(v228, nil, nil, nil);
					if (((3639 - 2480) <= (3543 - (1178 + 577))) and v29) then
						return v29;
					end
					if ((v33 and v89) or ((1822 + 1685) > (12764 - 8446))) then
						local v231 = 1405 - (851 + 554);
						while true do
							if ((v231 == (0 + 0)) or ((8528 - 5453) <= (6439 - 3474))) then
								if (((1667 - (115 + 187)) <= (1541 + 470)) and v17) then
									if ((v109.Detox:IsCastable() and v116.DispellableFriendlyUnit(24 + 1)) or ((10939 - 8163) > (4736 - (160 + 1001)))) then
										local v235 = 0 + 0;
										while true do
											if (((0 + 0) == v235) or ((5227 - 2673) == (5162 - (237 + 121)))) then
												v116.Wait(898 - (525 + 372));
												if (((4885 - 2308) == (8466 - 5889)) and v24(v111.DetoxFocus, not v17:IsSpellInRange(v109.Detox))) then
													return "detox dispel focus";
												end
												break;
											end
										end
									end
								end
								if ((v16 and v16:Exists() and v16:IsAPlayer() and v116.UnitHasDispellableDebuffByPlayer(v16)) or ((148 - (96 + 46)) >= (2666 - (643 + 134)))) then
									if (((183 + 323) <= (4536 - 2644)) and v109.Detox:IsCastable()) then
										if (v24(v111.DetoxMouseover, not v16:IsSpellInRange(v109.Detox)) or ((7455 - 5447) > (2128 + 90))) then
											return "detox dispel mouseover";
										end
									end
								end
								break;
							end
						end
					end
				end
				if (((743 - 364) <= (8476 - 4329)) and not v13:AffectingCombat()) then
					if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((5233 - (316 + 403)) <= (671 + 338))) then
						local v232 = v116.DeadFriendlyUnitsCount();
						if ((v232 > (2 - 1)) or ((1264 + 2232) == (3001 - 1809))) then
							if (v24(v109.Reawaken, nil) or ((148 + 60) == (954 + 2005))) then
								return "reawaken";
							end
						elseif (((14819 - 10542) >= (6270 - 4957)) and v24(v111.ResuscitateMouseover, not v15:IsInRange(83 - 43))) then
							return "resuscitate";
						end
					end
				end
				v209 = 1 + 3;
			end
			if (((5092 - 2505) < (156 + 3018)) and (v209 == (2 - 1))) then
				v32 = EpicSettings.Toggles['cds'];
				v33 = EpicSettings.Toggles['dispel'];
				v34 = EpicSettings.Toggles['healing'];
				v35 = EpicSettings.Toggles['dps'];
				v209 = 19 - (12 + 5);
			end
			if (((0 - 0) == v209) or ((8790 - 4670) <= (4672 - 2474))) then
				v129();
				v130();
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['aoe'];
				v209 = 2 - 1;
			end
		end
	end
	local function v132()
		v118();
		v22.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(55 + 215, v131, v132);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

