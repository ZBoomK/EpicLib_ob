local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((704 + 484) <= (12320 - 9174)) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((3048 + 445) <= (1002 + 1095))) then
			v6 = v0[v4];
			if (not v6 or ((11482 - 7712) == (454 + 3183))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
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
	local v105 = 12355 - (485 + 759);
	local v106 = 25709 - 14598;
	local v107;
	local v108 = v18.Monk.Mistweaver;
	local v109 = v20.Monk.Mistweaver;
	local v110 = v25.Monk.Mistweaver;
	local v111 = {};
	local v112;
	local v113;
	local v114 = {{v108.LegSweep,"Cast Leg Sweep (Stun)",function()
		return true;
	end},{v108.Paralysis,"Cast Paralysis (Stun)",function()
		return true;
	end}};
	local v115 = v22.Commons.Everyone;
	local v116 = v22.Commons.Monk;
	local function v117()
		if (v108.ImprovedDetox:IsAvailable() or ((3252 - 873) > (12061 - 7483))) then
			v115.DispellableDebuffs = v21.MergeTable(v115.DispellableMagicDebuffs, v115.DispellablePoisonDebuffs, v115.DispellableDiseaseDebuffs);
		else
			v115.DispellableDebuffs = v115.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v117();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v118()
		local v132 = 0 - 0;
		while true do
			if ((v132 == (1075 - (1036 + 37))) or ((343 + 140) > (1446 - 703))) then
				if (((1931 + 523) > (2058 - (641 + 839))) and v86 and (v13:HealthPercentage() <= v87)) then
					local v227 = 913 - (910 + 3);
					while true do
						if (((2370 - 1440) < (6142 - (1466 + 218))) and (v227 == (0 + 0))) then
							if (((1810 - (556 + 592)) <= (346 + 626)) and (v88 == "Refreshing Healing Potion")) then
								if (((5178 - (329 + 479)) == (5224 - (174 + 680))) and v109.RefreshingHealingPotion:IsReady()) then
									if (v24(v110.RefreshingHealingPotion) or ((16362 - 11600) <= (1784 - 923))) then
										return "refreshing healing potion defensive 5";
									end
								end
							end
							if ((v88 == "Dreamwalker's Healing Potion") or ((1009 + 403) == (5003 - (396 + 343)))) then
								if (v109.DreamwalkersHealingPotion:IsReady() or ((281 + 2887) < (3630 - (29 + 1448)))) then
									if (v24(v110.RefreshingHealingPotion) or ((6365 - (135 + 1254)) < (5017 - 3685))) then
										return "dreamwalkers healing potion defensive 5";
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((21608 - 16980) == (3085 + 1543)) and (v132 == (1527 - (389 + 1138)))) then
				if ((v108.DampenHarm:IsCastable() and v13:BuffDown(v108.FortifyingBrew) and (v13:HealthPercentage() <= v42) and v41) or ((628 - (102 + 472)) == (373 + 22))) then
					if (((46 + 36) == (77 + 5)) and v24(v108.DampenHarm, nil)) then
						return "dampen_harm defensives 1";
					end
				end
				if ((v108.FortifyingBrew:IsCastable() and v13:BuffDown(v108.DampenHarmBuff) and (v13:HealthPercentage() <= v40) and v39) or ((2126 - (320 + 1225)) < (501 - 219))) then
					if (v24(v108.FortifyingBrew, nil) or ((2821 + 1788) < (3959 - (157 + 1307)))) then
						return "fortifying_brew defensives 2";
					end
				end
				v132 = 1860 - (821 + 1038);
			end
			if (((2873 - 1721) == (126 + 1026)) and (v132 == (1 - 0))) then
				if (((706 + 1190) <= (8481 - 5059)) and v108.ExpelHarm:IsCastable() and (v13:HealthPercentage() <= v55) and v54 and v13:BuffUp(v108.ChiHarmonyBuff)) then
					if (v24(v108.ExpelHarm, nil) or ((2016 - (834 + 192)) > (103 + 1517))) then
						return "expel_harm defensives 3";
					end
				end
				if ((v109.Healthstone:IsReady() and v84 and (v13:HealthPercentage() <= v85)) or ((226 + 651) > (101 + 4594))) then
					if (((4168 - 1477) >= (2155 - (300 + 4))) and v24(v110.Healthstone)) then
						return "healthstone defensive 4";
					end
				end
				v132 = 1 + 1;
			end
		end
	end
	local function v119()
		local v133 = 0 - 0;
		while true do
			if ((v133 == (364 - (112 + 250))) or ((1190 + 1795) >= (12165 - 7309))) then
				if (((2450 + 1826) >= (619 + 576)) and v104) then
					local v228 = 0 + 0;
					while true do
						if (((1603 + 1629) <= (3485 + 1205)) and (v228 == (1415 - (1001 + 413)))) then
							v29 = v115.HandleFyrakkNPC(v108.SoothingMist, v110.SoothingMistMouseover, 89 - 49);
							if (v29 or ((1778 - (244 + 638)) >= (3839 - (627 + 66)))) then
								return v29;
							end
							v228 = 5 - 3;
						end
						if (((3663 - (512 + 90)) >= (4864 - (1665 + 241))) and (v228 == (719 - (373 + 344)))) then
							v29 = v115.HandleFyrakkNPC(v108.Vivify, v110.VivifyMouseover, 19 + 21);
							if (((844 + 2343) >= (1698 - 1054)) and v29) then
								return v29;
							end
							v228 = 4 - 1;
						end
						if (((1743 - (35 + 1064)) <= (513 + 191)) and ((0 - 0) == v228)) then
							v29 = v115.HandleFyrakkNPC(v108.RenewingMist, v110.RenewingMistMouseover, 1 + 39);
							if (((2194 - (298 + 938)) > (2206 - (233 + 1026))) and v29) then
								return v29;
							end
							v228 = 1667 - (636 + 1030);
						end
						if (((2297 + 2195) >= (2593 + 61)) and (v228 == (1 + 2))) then
							v29 = v115.HandleFyrakkNPC(v108.EnvelopingMist, v110.EnvelopingMistMouseover, 3 + 37);
							if (((3663 - (55 + 166)) >= (292 + 1211)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v133 == (1 + 0)) or ((12106 - 8936) <= (1761 - (36 + 261)))) then
				if (v102 or ((8389 - 3592) == (5756 - (34 + 1334)))) then
					local v229 = 0 + 0;
					while true do
						if (((429 + 122) <= (1964 - (1035 + 248))) and (v229 == (24 - (20 + 1)))) then
							v29 = v115.HandleCharredTreant(v108.EnvelopingMist, v110.EnvelopingMistMouseover, 21 + 19);
							if (((3596 - (134 + 185)) > (1540 - (549 + 584))) and v29) then
								return v29;
							end
							break;
						end
						if (((5380 - (314 + 371)) >= (4857 - 3442)) and (v229 == (970 - (478 + 490)))) then
							v29 = v115.HandleCharredTreant(v108.Vivify, v110.VivifyMouseover, 22 + 18);
							if (v29 or ((4384 - (786 + 386)) <= (3057 - 2113))) then
								return v29;
							end
							v229 = 1382 - (1055 + 324);
						end
						if ((v229 == (1341 - (1093 + 247))) or ((2752 + 344) <= (190 + 1608))) then
							v29 = v115.HandleCharredTreant(v108.SoothingMist, v110.SoothingMistMouseover, 158 - 118);
							if (((12003 - 8466) == (10064 - 6527)) and v29) then
								return v29;
							end
							v229 = 4 - 2;
						end
						if (((1365 + 2472) >= (6048 - 4478)) and (v229 == (0 - 0))) then
							v29 = v115.HandleCharredTreant(v108.RenewingMist, v110.RenewingMistMouseover, 31 + 9);
							if (v29 or ((7544 - 4594) == (4500 - (364 + 324)))) then
								return v29;
							end
							v229 = 2 - 1;
						end
					end
				end
				if (((11333 - 6610) >= (769 + 1549)) and v103) then
					local v230 = 0 - 0;
					while true do
						if ((v230 == (2 - 0)) or ((6156 - 4129) > (4120 - (1249 + 19)))) then
							v29 = v115.HandleCharredBrambles(v108.Vivify, v110.VivifyMouseover, 37 + 3);
							if (v29 or ((4421 - 3285) > (5403 - (686 + 400)))) then
								return v29;
							end
							v230 = 3 + 0;
						end
						if (((4977 - (73 + 156)) == (23 + 4725)) and ((812 - (721 + 90)) == v230)) then
							v29 = v115.HandleCharredBrambles(v108.SoothingMist, v110.SoothingMistMouseover, 1 + 39);
							if (((12130 - 8394) <= (5210 - (224 + 246))) and v29) then
								return v29;
							end
							v230 = 2 - 0;
						end
						if ((v230 == (0 - 0)) or ((615 + 2775) <= (73 + 2987))) then
							v29 = v115.HandleCharredBrambles(v108.RenewingMist, v110.RenewingMistMouseover, 30 + 10);
							if (v29 or ((1985 - 986) > (8961 - 6268))) then
								return v29;
							end
							v230 = 514 - (203 + 310);
						end
						if (((2456 - (1238 + 755)) < (42 + 559)) and (v230 == (1537 - (709 + 825)))) then
							v29 = v115.HandleCharredBrambles(v108.EnvelopingMist, v110.EnvelopingMistMouseover, 73 - 33);
							if (v29 or ((3179 - 996) < (1551 - (196 + 668)))) then
								return v29;
							end
							break;
						end
					end
				end
				v133 = 7 - 5;
			end
			if (((9422 - 4873) == (5382 - (171 + 662))) and (v133 == (93 - (4 + 89)))) then
				if (((16375 - 11703) == (1702 + 2970)) and v101) then
					local v231 = 0 - 0;
					while true do
						if ((v231 == (0 + 0)) or ((5154 - (35 + 1451)) < (1848 - (28 + 1425)))) then
							v29 = v115.HandleIncorporeal(v108.Paralysis, v110.ParalysisMouseover, 2023 - (941 + 1052), true);
							if (v29 or ((3995 + 171) == (1969 - (822 + 692)))) then
								return v29;
							end
							break;
						end
					end
				end
				if (v100 or ((6351 - 1902) == (1255 + 1408))) then
					local v232 = 297 - (45 + 252);
					while true do
						if ((v232 == (0 + 0)) or ((1472 + 2805) < (7274 - 4285))) then
							v29 = v115.HandleAfflicted(v108.Detox, v110.DetoxMouseover, 463 - (114 + 319));
							if (v29 or ((1249 - 379) >= (5315 - 1166))) then
								return v29;
							end
							break;
						end
					end
				end
				v133 = 1 + 0;
			end
		end
	end
	local function v120()
		local v134 = 0 - 0;
		while true do
			if (((4634 - 2422) < (5146 - (556 + 1407))) and (v134 == (1207 - (741 + 465)))) then
				if (((5111 - (170 + 295)) > (1577 + 1415)) and v108.TigerPalm:IsCastable() and v48) then
					if (((1318 + 116) < (7646 - 4540)) and v24(v108.TigerPalm, not v15:IsInMeleeRange(5 + 0))) then
						return "tiger_palm precombat 8";
					end
				end
				break;
			end
			if (((505 + 281) < (1712 + 1311)) and (v134 == (1230 - (957 + 273)))) then
				if ((v108.ChiBurst:IsCastable() and v50) or ((654 + 1788) < (30 + 44))) then
					if (((17280 - 12745) == (11950 - 7415)) and v24(v108.ChiBurst, not v15:IsInRange(122 - 82))) then
						return "chi_burst precombat 4";
					end
				end
				if ((v108.SpinningCraneKick:IsCastable() and v46 and (v113 >= (9 - 7))) or ((4789 - (389 + 1391)) <= (1321 + 784))) then
					if (((191 + 1639) < (8352 - 4683)) and v24(v108.SpinningCraneKick, not v15:IsInMeleeRange(959 - (783 + 168)))) then
						return "spinning_crane_kick precombat 6";
					end
				end
				v134 = 3 - 2;
			end
		end
	end
	local function v121()
		local v135 = 0 + 0;
		while true do
			if (((313 - (309 + 2)) == v135) or ((4391 - 2961) >= (4824 - (1090 + 122)))) then
				if (((870 + 1813) >= (8261 - 5801)) and v108.SpinningCraneKick:IsCastable() and v46 and v15:DebuffDown(v108.MysticTouch) and v108.MysticTouch:IsAvailable()) then
					if (v24(v108.SpinningCraneKick, not v15:IsInMeleeRange(6 + 2)) or ((2922 - (628 + 490)) >= (588 + 2687))) then
						return "spinning_crane_kick aoe 5";
					end
				end
				if ((v108.BlackoutKick:IsCastable() and v108.AncientConcordance:IsAvailable() and v13:BuffUp(v108.FaelineStomp) and v45 and (v113 >= (7 - 4))) or ((6475 - 5058) > (4403 - (431 + 343)))) then
					if (((9684 - 4889) > (1162 - 760)) and v24(v108.BlackoutKick, not v15:IsInMeleeRange(4 + 1))) then
						return "blackout_kick aoe 6";
					end
				end
				v135 = 1 + 2;
			end
			if (((6508 - (556 + 1139)) > (3580 - (6 + 9))) and (v135 == (1 + 2))) then
				if (((2005 + 1907) == (4081 - (28 + 141))) and v108.TigerPalm:IsCastable() and v108.TeachingsoftheMonastery:IsAvailable() and (v108.BlackoutKick:CooldownRemains() > (0 + 0)) and v48 and (v113 >= (3 - 0))) then
					if (((1998 + 823) <= (6141 - (486 + 831))) and v24(v108.TigerPalm, not v15:IsInMeleeRange(12 - 7))) then
						return "tiger_palm aoe 7";
					end
				end
				if (((6118 - 4380) <= (415 + 1780)) and v108.SpinningCraneKick:IsCastable() and v46) then
					if (((129 - 88) <= (4281 - (668 + 595))) and v24(v108.SpinningCraneKick, not v15:IsInMeleeRange(8 + 0))) then
						return "spinning_crane_kick aoe 8";
					end
				end
				break;
			end
			if (((433 + 1712) <= (11191 - 7087)) and (v135 == (290 - (23 + 267)))) then
				if (((4633 - (1129 + 815)) < (5232 - (371 + 16))) and v108.SummonWhiteTigerStatue:IsReady() and (v113 >= (1753 - (1326 + 424))) and v44) then
					if ((v43 == "Player") or ((4397 - 2075) > (9581 - 6959))) then
						if (v24(v110.SummonWhiteTigerStatuePlayer, not v15:IsInRange(158 - (88 + 30))) or ((5305 - (720 + 51)) == (4631 - 2549))) then
							return "summon_white_tiger_statue aoe player 1";
						end
					elseif ((v43 == "Cursor") or ((3347 - (421 + 1355)) > (3079 - 1212))) then
						if (v24(v110.SummonWhiteTigerStatueCursor, not v15:IsInRange(20 + 20)) or ((3737 - (286 + 797)) >= (10952 - 7956))) then
							return "summon_white_tiger_statue aoe cursor 1";
						end
					elseif (((6588 - 2610) > (2543 - (397 + 42))) and (v43 == "Friendly under Cursor") and v16:Exists() and not v13:CanAttack(v16)) then
						if (((936 + 2059) > (2341 - (24 + 776))) and v24(v110.SummonWhiteTigerStatueCursor, not v15:IsInRange(61 - 21))) then
							return "summon_white_tiger_statue aoe cursor friendly 1";
						end
					elseif (((4034 - (222 + 563)) > (2099 - 1146)) and (v43 == "Enemy under Cursor") and v16:Exists() and v13:CanAttack(v16)) then
						if (v24(v110.SummonWhiteTigerStatueCursor, not v15:IsInRange(29 + 11)) or ((3463 - (23 + 167)) > (6371 - (690 + 1108)))) then
							return "summon_white_tiger_statue aoe cursor enemy 1";
						end
					elseif ((v43 == "Confirmation") or ((1137 + 2014) < (1060 + 224))) then
						if (v24(v110.SummonWhiteTigerStatue, not v15:IsInRange(888 - (40 + 808))) or ((305 + 1545) == (5846 - 4317))) then
							return "summon_white_tiger_statue aoe confirmation 1";
						end
					end
				end
				if (((785 + 36) < (1124 + 999)) and v108.TouchofDeath:IsCastable() and v51) then
					if (((495 + 407) < (2896 - (47 + 524))) and v24(v108.TouchofDeath, not v15:IsInMeleeRange(4 + 1))) then
						return "touch_of_death aoe 2";
					end
				end
				v135 = 2 - 1;
			end
			if (((1282 - 424) <= (6755 - 3793)) and (v135 == (1727 - (1165 + 561)))) then
				if ((v108.FaelineStomp:IsReady() and v49) or ((118 + 3828) < (3988 - 2700))) then
					if (v24(v108.FaelineStomp, nil) or ((1237 + 2005) == (1046 - (341 + 138)))) then
						return "FaelineStomp aoe3";
					end
				end
				if ((v108.ChiBurst:IsCastable() and v50) or ((229 + 618) >= (2606 - 1343))) then
					if (v24(v108.ChiBurst, not v15:IsInRange(366 - (89 + 237))) or ((7247 - 4994) == (3896 - 2045))) then
						return "chi_burst aoe 4";
					end
				end
				v135 = 883 - (581 + 300);
			end
		end
	end
	local function v122()
		local v136 = 1220 - (855 + 365);
		while true do
			if ((v136 == (0 - 0)) or ((682 + 1405) > (3607 - (1030 + 205)))) then
				if ((v108.TouchofDeath:IsCastable() and v51) or ((4173 + 272) < (3860 + 289))) then
					if (v24(v108.TouchofDeath, not v15:IsInMeleeRange(291 - (156 + 130))) or ((4130 - 2312) == (143 - 58))) then
						return "touch_of_death st 1";
					end
				end
				if (((1290 - 660) < (561 + 1566)) and v108.FaelineStomp:IsReady() and v49) then
					if (v24(v108.FaelineStomp, nil) or ((1131 + 807) == (2583 - (10 + 59)))) then
						return "FaelineStomp st 2";
					end
				end
				v136 = 1 + 0;
			end
			if (((20954 - 16699) >= (1218 - (671 + 492))) and (v136 == (1 + 0))) then
				if (((4214 - (369 + 846)) > (307 + 849)) and v108.RisingSunKick:IsReady() and v47) then
					if (((2006 + 344) > (3100 - (1036 + 909))) and v24(v108.RisingSunKick, not v15:IsInMeleeRange(4 + 1))) then
						return "rising_sun_kick st 3";
					end
				end
				if (((6763 - 2734) <= (5056 - (11 + 192))) and v108.ChiBurst:IsCastable() and v50) then
					if (v24(v108.ChiBurst, not v15:IsInRange(21 + 19)) or ((691 - (135 + 40)) > (8320 - 4886))) then
						return "chi_burst st 4";
					end
				end
				v136 = 2 + 0;
			end
			if (((8913 - 4867) >= (4546 - 1513)) and (v136 == (178 - (50 + 126)))) then
				if ((v108.BlackoutKick:IsCastable() and (v13:BuffStack(v108.TeachingsoftheMonasteryBuff) == (8 - 5)) and (v108.RisingSunKick:CooldownRemains() > v13:GCD()) and v45) or ((602 + 2117) <= (2860 - (1233 + 180)))) then
					if (v24(v108.BlackoutKick, not v15:IsInMeleeRange(974 - (522 + 447))) or ((5555 - (107 + 1314)) < (1822 + 2104))) then
						return "blackout_kick st 5";
					end
				end
				if ((v108.TigerPalm:IsCastable() and ((v13:BuffStack(v108.TeachingsoftheMonasteryBuff) < (8 - 5)) or (v13:BuffRemains(v108.TeachingsoftheMonasteryBuff) < (1 + 1))) and v48) or ((325 - 161) >= (11019 - 8234))) then
					if (v24(v108.TigerPalm, not v15:IsInMeleeRange(1915 - (716 + 1194))) or ((9 + 516) == (226 + 1883))) then
						return "tiger_palm st 6";
					end
				end
				break;
			end
		end
	end
	local function v123()
		if (((536 - (74 + 429)) == (63 - 30)) and v52 and v108.RenewingMist:IsReady() and v17:BuffDown(v108.RenewingMistBuff) and (v108.RenewingMist:ChargesFractional() >= (1.8 + 0))) then
			if (((6990 - 3936) <= (2841 + 1174)) and (v17:HealthPercentage() <= v53)) then
				if (((5768 - 3897) < (8361 - 4979)) and v24(v110.RenewingMistFocus, not v17:IsSpellInRange(v108.RenewingMist))) then
					return "RenewingMist healing st";
				end
			end
		end
		if (((1726 - (279 + 154)) <= (2944 - (454 + 324))) and v47 and v108.RisingSunKick:IsReady() and (v115.FriendlyUnitsWithBuffCount(v108.RenewingMistBuff, false, false, 20 + 5) > (18 - (12 + 5)))) then
			if (v24(v108.RisingSunKick, not v15:IsInMeleeRange(3 + 2)) or ((6571 - 3992) < (46 + 77))) then
				return "RisingSunKick healing st";
			end
		end
		if ((v52 and v108.RenewingMist:IsReady() and v17:BuffDown(v108.RenewingMistBuff)) or ((1939 - (277 + 816)) >= (10118 - 7750))) then
			if ((v17:HealthPercentage() <= v53) or ((5195 - (1058 + 125)) <= (630 + 2728))) then
				if (((2469 - (815 + 160)) <= (12893 - 9888)) and v24(v110.RenewingMistFocus, not v17:IsSpellInRange(v108.RenewingMist))) then
					return "RenewingMist healing st";
				end
			end
		end
		if ((v56 and v108.Vivify:IsReady() and v13:BuffUp(v108.VivaciousVivificationBuff)) or ((7384 - 4273) == (510 + 1624))) then
			if (((6884 - 4529) == (4253 - (41 + 1857))) and (v17:HealthPercentage() <= v57)) then
				if (v24(v110.VivifyFocus, not v17:IsSpellInRange(v108.Vivify)) or ((2481 - (1222 + 671)) <= (1116 - 684))) then
					return "Vivify instant healing st";
				end
			end
		end
		if (((6895 - 2098) >= (5077 - (229 + 953))) and v60 and v108.SoothingMist:IsReady() and v17:BuffDown(v108.SoothingMist)) then
			if (((5351 - (1111 + 663)) == (5156 - (874 + 705))) and (v17:HealthPercentage() <= v61)) then
				if (((532 + 3262) > (2520 + 1173)) and v24(v110.SoothingMistFocus, not v17:IsSpellInRange(v108.SoothingMist))) then
					return "SoothingMist healing st";
				end
			end
		end
	end
	local function v124()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (1 + 1)) or ((1954 - (642 + 37)) == (935 + 3165))) then
				if ((v70 and v108.SheilunsGift:IsReady() and v108.SheilunsGift:IsCastable() and v115.AreUnitsBelowHealthPercentage(v72, v71)) or ((255 + 1336) >= (8988 - 5408))) then
					if (((1437 - (233 + 221)) <= (4180 - 2372)) and v24(v108.SheilunsGift, nil)) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
			if ((v137 == (1 + 0)) or ((3691 - (718 + 823)) <= (754 + 443))) then
				if (((4574 - (266 + 539)) >= (3320 - 2147)) and v62 and v108.EssenceFont:IsReady() and v108.AncientTeachings:IsAvailable() and v13:BuffDown(v108.EssenceFontBuff)) then
					if (((2710 - (636 + 589)) == (3525 - 2040)) and v24(v108.EssenceFont, nil)) then
						return "EssenceFont healing aoe";
					end
				end
				if ((v67 and v108.ZenPulse:IsReady() and v115.AreUnitsBelowHealthPercentage(v69, v68)) or ((6837 - 3522) <= (2205 + 577))) then
					if (v24(v110.ZenPulseFocus, not v17:IsSpellInRange(v108.ZenPulse)) or ((319 + 557) >= (3979 - (657 + 358)))) then
						return "ZenPulse healing aoe";
					end
				end
				v137 = 4 - 2;
			end
			if ((v137 == (0 - 0)) or ((3419 - (1151 + 36)) > (2412 + 85))) then
				if ((v47 and v108.RisingSunKick:IsReady() and (v115.FriendlyUnitsWithBuffCount(v108.RenewingMistBuff, false, false, 7 + 18) > (2 - 1))) or ((3942 - (1552 + 280)) <= (1166 - (64 + 770)))) then
					if (((2503 + 1183) > (7200 - 4028)) and v24(v108.RisingSunKick, not v15:IsInMeleeRange(1 + 4))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (v115.AreUnitsBelowHealthPercentage(v64, v63) or ((5717 - (157 + 1086)) < (1641 - 821))) then
					local v233 = 0 - 0;
					while true do
						if (((6563 - 2284) >= (3932 - 1050)) and (v233 == (820 - (599 + 220)))) then
							if ((v62 and v108.EssenceFont:IsReady() and (v13:BuffUp(v108.ThunderFocusTea) or (v108.ThunderFocusTea:CooldownRemains() > (15 - 7)))) or ((3960 - (1813 + 118)) >= (2574 + 947))) then
								if (v24(v108.EssenceFont, nil) or ((3254 - (841 + 376)) >= (6504 - 1862))) then
									return "EssenceFont healing aoe";
								end
							end
							break;
						end
						if (((400 + 1320) < (12168 - 7710)) and (v233 == (859 - (464 + 395)))) then
							if ((v36 and (v13:BuffStack(v108.ManaTeaCharges) > v37) and v108.EssenceFont:IsReady() and v108.ManaTea:IsCastable()) or ((1118 - 682) > (1451 + 1570))) then
								if (((1550 - (467 + 370)) <= (1750 - 903)) and v24(v108.ManaTea, nil)) then
									return "EssenceFont healing aoe";
								end
							end
							if (((1582 + 572) <= (13818 - 9787)) and v38 and v108.ThunderFocusTea:IsReady() and (v108.EssenceFont:CooldownRemains() < v13:GCD())) then
								if (((720 + 3895) == (10737 - 6122)) and v24(v108.ThunderFocusTea, nil)) then
									return "ThunderFocusTea healing aoe";
								end
							end
							v233 = 521 - (150 + 370);
						end
					end
				end
				v137 = 1283 - (74 + 1208);
			end
		end
	end
	local function v125()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (0 - 0)) or ((2697 + 1093) == (890 - (14 + 376)))) then
				if (((153 - 64) < (144 + 77)) and v58 and v108.EnvelopingMist:IsReady() and (v115.FriendlyUnitsWithBuffCount(v108.EnvelopingMist, false, false, 22 + 3) < (3 + 0))) then
					local v234 = 0 - 0;
					while true do
						if (((1546 + 508) >= (1499 - (23 + 55))) and (v234 == (0 - 0))) then
							v29 = v115.FocusUnitRefreshableBuff(v108.EnvelopingMist, 2 + 0, 36 + 4, nil, false, 38 - 13);
							if (((218 + 474) < (3959 - (652 + 249))) and v29) then
								return v29;
							end
							v234 = 2 - 1;
						end
						if (((1869 - (708 + 1160)) == v234) or ((8832 - 5578) == (3017 - 1362))) then
							if (v24(v110.EnvelopingMistFocus, not v17:IsSpellInRange(v108.EnvelopingMist)) or ((1323 - (10 + 17)) == (1103 + 3807))) then
								return "Enveloping Mist YuLon";
							end
							break;
						end
					end
				end
				if (((5100 - (1400 + 332)) == (6459 - 3091)) and v47 and v108.RisingSunKick:IsReady() and (v115.FriendlyUnitsWithBuffCount(v108.EnvelopingMist, false, false, 1933 - (242 + 1666)) > (1 + 1))) then
					if (((969 + 1674) < (3252 + 563)) and v24(v108.RisingSunKick, not v15:IsInMeleeRange(945 - (850 + 90)))) then
						return "Rising Sun Kick YuLon";
					end
				end
				v138 = 1 - 0;
			end
			if (((3303 - (360 + 1030)) > (437 + 56)) and (v138 == (2 - 1))) then
				if (((6541 - 1786) > (5089 - (909 + 752))) and v60 and v108.SoothingMist:IsReady() and v17:BuffUp(v108.ChiHarmonyBuff) and v17:BuffDown(v108.SoothingMist)) then
					if (((2604 - (109 + 1114)) <= (4336 - 1967)) and v24(v110.SoothingMistFocus, not v17:IsSpellInRange(v108.SoothingMist))) then
						return "Soothing Mist YuLon";
					end
				end
				break;
			end
		end
	end
	local function v126()
		if ((v45 and v108.BlackoutKick:IsReady() and (v13:BuffStack(v108.TeachingsoftheMonastery) >= (2 + 1))) or ((5085 - (6 + 236)) == (2574 + 1510))) then
			if (((3759 + 910) > (855 - 492)) and v24(v108.BlackoutKick, not v15:IsInMeleeRange(8 - 3))) then
				return "Blackout Kick ChiJi";
			end
		end
		if ((v58 and v108.EnvelopingMist:IsReady() and (v13:BuffStack(v108.InvokeChiJiBuff) == (1136 - (1076 + 57)))) or ((309 + 1568) >= (3827 - (579 + 110)))) then
			if (((375 + 4367) >= (3206 + 420)) and (v17:HealthPercentage() <= v59)) then
				if (v24(v110.EnvelopingMistFocus, not v17:IsSpellInRange(v108.EnvelopingMist)) or ((2410 + 2130) == (1323 - (174 + 233)))) then
					return "Enveloping Mist 3 Stacks ChiJi";
				end
			end
		end
		if ((v47 and v108.RisingSunKick:IsReady()) or ((3228 - 2072) > (7626 - 3281))) then
			if (((995 + 1242) < (5423 - (663 + 511))) and v24(v108.RisingSunKick, not v15:IsInMeleeRange(5 + 0))) then
				return "Rising Sun Kick ChiJi";
			end
		end
		if ((v58 and v108.EnvelopingMist:IsReady() and (v13:BuffStack(v108.InvokeChiJiBuff) >= (1 + 1))) or ((8271 - 5588) < (14 + 9))) then
			if (((1640 - 943) <= (1999 - 1173)) and (v17:HealthPercentage() <= v59)) then
				if (((528 + 577) <= (2288 - 1112)) and v24(v110.EnvelopingMistFocus, not v17:IsSpellInRange(v108.EnvelopingMist))) then
					return "Enveloping Mist 2 Stacks ChiJi";
				end
			end
		end
		if (((2409 + 970) <= (349 + 3463)) and v62 and v108.EssenceFont:IsReady() and v108.AncientTeachings:IsAvailable() and v13:BuffDown(v108.AncientTeachings)) then
			if (v24(v108.EssenceFont, nil) or ((1510 - (478 + 244)) >= (2133 - (440 + 77)))) then
				return "Essence Font ChiJi";
			end
		end
	end
	local function v127()
		local v139 = 0 + 0;
		while true do
			if (((6785 - 4931) <= (4935 - (655 + 901))) and (v139 == (1 + 1))) then
				if (((3483 + 1066) == (3072 + 1477)) and (v108.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (100 - 75))) then
					v29 = v125();
					if (v29 or ((4467 - (695 + 750)) >= (10326 - 7302))) then
						return v29;
					end
				end
				if (((7438 - 2618) > (8839 - 6641)) and v76 and v108.InvokeChiJiTheRedCrane:IsReady() and v108.InvokeChiJiTheRedCrane:IsAvailable() and v115.AreUnitsBelowHealthPercentage(v78, v77)) then
					local v235 = 351 - (285 + 66);
					while true do
						if ((v235 == (0 - 0)) or ((2371 - (682 + 628)) >= (789 + 4102))) then
							if (((1663 - (176 + 123)) <= (1872 + 2601)) and v52 and v108.RenewingMist:IsReady() and (v108.RenewingMist:ChargesFractional() >= (1 + 0))) then
								local v243 = 269 - (239 + 30);
								while true do
									if ((v243 == (0 + 0)) or ((3456 + 139) <= (4 - 1))) then
										v29 = v115.FocusUnitRefreshableBuff(v108.RenewingMistBuff, 18 - 12, 355 - (306 + 9), nil, false, 87 - 62);
										if (v29 or ((813 + 3859) == (2364 + 1488))) then
											return v29;
										end
										v243 = 1 + 0;
									end
									if (((4457 - 2898) == (2934 - (1140 + 235))) and (v243 == (1 + 0))) then
										if (v24(v110.RenewingMistFocus, not v17:IsSpellInRange(v108.RenewingMist)) or ((1607 + 145) <= (203 + 585))) then
											return "Renewing Mist ChiJi prep";
										end
										break;
									end
								end
							end
							if ((v70 and v108.SheilunsGift:IsReady() and (v108.SheilunsGift:TimeSinceLastCast() > (72 - (33 + 19)))) or ((1411 + 2496) == (530 - 353))) then
								if (((1529 + 1941) > (1088 - 533)) and v24(v108.SheilunsGift, nil)) then
									return "Sheilun's Gift ChiJi prep";
								end
							end
							v235 = 1 + 0;
						end
						if ((v235 == (690 - (586 + 103))) or ((89 + 883) == (1985 - 1340))) then
							if (((4670 - (1309 + 179)) >= (3818 - 1703)) and v108.InvokeChiJiTheRedCrane:IsReady() and (v108.RenewingMist:ChargesFractional() < (1 + 0)) and v13:BuffUp(v108.AncientTeachings) and (v13:BuffStack(v108.TeachingsoftheMonastery) == (7 - 4)) and (v108.SheilunsGift:TimeSinceLastCast() < ((4 + 0) * v13:GCD()))) then
								if (((8270 - 4377) < (8824 - 4395)) and v24(v108.InvokeChiJiTheRedCrane, nil)) then
									return "Invoke Chi'ji GO";
								end
							end
							break;
						end
					end
				end
				v139 = 612 - (295 + 314);
			end
			if ((v139 == (0 - 0)) or ((4829 - (1300 + 662)) < (5981 - 4076))) then
				if ((v79 and v108.LifeCocoon:IsReady() and (v17:HealthPercentage() <= v80)) or ((3551 - (1178 + 577)) >= (2104 + 1947))) then
					if (((4785 - 3166) <= (5161 - (851 + 554))) and v24(v110.LifeCocoonFocus, not v17:IsSpellInRange(v108.LifeCocoon))) then
						return "Life Cocoon CD";
					end
				end
				if (((535 + 69) == (1674 - 1070)) and v81 and v108.Revival:IsReady() and v108.Revival:IsAvailable() and v115.AreUnitsBelowHealthPercentage(v83, v82)) then
					if (v24(v108.Revival, nil) or ((9738 - 5254) == (1202 - (115 + 187)))) then
						return "Revival CD";
					end
				end
				v139 = 1 + 0;
			end
			if ((v139 == (3 + 0)) or ((17571 - 13112) <= (2274 - (160 + 1001)))) then
				if (((3178 + 454) > (2345 + 1053)) and (v108.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (51 - 26))) then
					local v236 = 358 - (237 + 121);
					while true do
						if (((4979 - (525 + 372)) <= (9321 - 4404)) and (v236 == (0 - 0))) then
							v29 = v126();
							if (((4974 - (96 + 46)) >= (2163 - (643 + 134))) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				break;
			end
			if (((50 + 87) == (328 - 191)) and (v139 == (3 - 2))) then
				if ((v81 and v108.Restoral:IsReady() and v108.Restoral:IsAvailable() and v115.AreUnitsBelowHealthPercentage(v83, v82)) or ((1506 + 64) >= (8501 - 4169))) then
					if (v24(v108.Restoral, nil) or ((8306 - 4242) <= (2538 - (316 + 403)))) then
						return "Restoral CD";
					end
				end
				if ((v73 and v108.InvokeYulonTheJadeSerpent:IsAvailable() and v108.InvokeYulonTheJadeSerpent:IsReady() and v115.AreUnitsBelowHealthPercentage(v75, v74)) or ((3315 + 1671) < (4327 - 2753))) then
					local v237 = 0 + 0;
					while true do
						if (((11146 - 6720) > (122 + 50)) and (v237 == (0 + 0))) then
							if (((2030 - 1444) > (2173 - 1718)) and v52 and v108.RenewingMist:IsReady() and (v108.RenewingMist:ChargesFractional() >= (1 - 0))) then
								v29 = v115.FocusUnitRefreshableBuff(v108.RenewingMistBuff, 1 + 5, 78 - 38, nil, false, 2 + 23);
								if (((2430 - 1604) == (843 - (12 + 5))) and v29) then
									return v29;
								end
								if (v24(v110.RenewingMistFocus, not v17:IsSpellInRange(v108.RenewingMist)) or ((15609 - 11590) > (9475 - 5034))) then
									return "Renewing Mist YuLon prep";
								end
							end
							if (((4287 - 2270) < (10566 - 6305)) and v36 and v108.ManaTea:IsCastable() and (v13:BuffStack(v108.ManaTeaCharges) >= (1 + 2)) and v13:BuffDown(v108.ManaTeaBuff)) then
								if (((6689 - (1656 + 317)) > (72 + 8)) and v24(v108.ManaTea, nil)) then
									return "ManaTea YuLon prep";
								end
							end
							v237 = 1 + 0;
						end
						if ((v237 == (2 - 1)) or ((17259 - 13752) == (3626 - (5 + 349)))) then
							if ((v70 and v108.SheilunsGift:IsReady() and (v108.SheilunsGift:TimeSinceLastCast() > (94 - 74))) or ((2147 - (266 + 1005)) >= (2027 + 1048))) then
								if (((14849 - 10497) > (3361 - 807)) and v24(v108.SheilunsGift, nil)) then
									return "Sheilun's Gift YuLon prep";
								end
							end
							if ((v108.InvokeYulonTheJadeSerpent:IsReady() and (v108.RenewingMist:ChargesFractional() < (1697 - (561 + 1135))) and v13:BuffUp(v108.ManaTeaBuff) and (v108.SheilunsGift:TimeSinceLastCast() < ((5 - 1) * v13:GCD()))) or ((14482 - 10076) < (5109 - (507 + 559)))) then
								if (v24(v108.InvokeYulonTheJadeSerpent, nil) or ((4739 - 2850) >= (10462 - 7079))) then
									return "Invoke Yu'lon GO";
								end
							end
							break;
						end
					end
				end
				v139 = 390 - (212 + 176);
			end
		end
	end
	local function v128()
		local v140 = 905 - (250 + 655);
		while true do
			if (((5159 - 3267) <= (4776 - 2042)) and (v140 == (7 - 2))) then
				v61 = EpicSettings.Settings['SoothingMistHP'];
				v62 = EpicSettings.Settings['UseEssenceFont'];
				v64 = EpicSettings.Settings['EssenceFontHP'];
				v63 = EpicSettings.Settings['EssenceFontGroup'];
				v66 = EpicSettings.Settings['UseJadeSerpent'];
				v140 = 1962 - (1869 + 87);
			end
			if (((6669 - 4746) < (4119 - (484 + 1417))) and (v140 == (12 - 6))) then
				v65 = EpicSettings.Settings['JadeSerpentUsage'];
				v67 = EpicSettings.Settings['UseZenPulse'];
				v69 = EpicSettings.Settings['ZenPulseHP'];
				v68 = EpicSettings.Settings['ZenPulseGroup'];
				v70 = EpicSettings.Settings['UseSheilunsGift'];
				v140 = 11 - 4;
			end
			if (((2946 - (48 + 725)) > (618 - 239)) and ((7 - 4) == v140)) then
				v51 = EpicSettings.Settings['UseTouchOfDeath'];
				v52 = EpicSettings.Settings['UseRenewingMist'];
				v53 = EpicSettings.Settings['RenewingMistHP'];
				v54 = EpicSettings.Settings['UseExpelHarm'];
				v55 = EpicSettings.Settings['ExpelHarmHP'];
				v140 = 3 + 1;
			end
			if ((v140 == (0 - 0)) or ((726 + 1865) == (994 + 2415))) then
				v36 = EpicSettings.Settings['UseManaTea'];
				v37 = EpicSettings.Settings['ManaTeaStacks'];
				v38 = EpicSettings.Settings['UseThunderFocusTea'];
				v39 = EpicSettings.Settings['UseFortifyingBrew'];
				v40 = EpicSettings.Settings['FortifyingBrewHP'];
				v140 = 854 - (152 + 701);
			end
			if (((5825 - (430 + 881)) > (1273 + 2051)) and (v140 == (897 - (557 + 338)))) then
				v46 = EpicSettings.Settings['UseSpinningCraneKick'];
				v47 = EpicSettings.Settings['UseRisingSunKick'];
				v48 = EpicSettings.Settings['UseTigerPalm'];
				v49 = EpicSettings.Settings['UseFaelineStomp'];
				v50 = EpicSettings.Settings['UseChiBurst'];
				v140 = 1 + 2;
			end
			if (((10 - 6) == v140) or ((728 - 520) >= (12826 - 7998))) then
				v56 = EpicSettings.Settings['UseVivify'];
				v57 = EpicSettings.Settings['VivifyHP'];
				v58 = EpicSettings.Settings['UseEnvelopingMist'];
				v59 = EpicSettings.Settings['EnvelopingMistHP'];
				v60 = EpicSettings.Settings['UseSoothingMist'];
				v140 = 10 - 5;
			end
			if ((v140 == (802 - (499 + 302))) or ((2449 - (39 + 827)) > (9846 - 6279))) then
				v41 = EpicSettings.Settings['UseDampenHarm'];
				v42 = EpicSettings.Settings['DampenHarmHP'];
				v43 = EpicSettings.Settings['WhiteTigerUsage'];
				v44 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
				v45 = EpicSettings.Settings['UseBlackoutKick'];
				v140 = 4 - 2;
			end
			if ((v140 == (27 - 20)) or ((2015 - 702) == (68 + 726))) then
				v72 = EpicSettings.Settings['SheilunsGiftHP'];
				v71 = EpicSettings.Settings['SheilunsGiftGroup'];
				break;
			end
		end
	end
	local function v129()
		local v141 = 0 - 0;
		while true do
			if (((508 + 2666) > (4591 - 1689)) and ((104 - (103 + 1)) == v141)) then
				v96 = EpicSettings.Settings['racialsWithCD'];
				v95 = EpicSettings.Settings['useRacials'];
				v98 = EpicSettings.Settings['trinketsWithCD'];
				v97 = EpicSettings.Settings['useTrinkets'];
				v99 = EpicSettings.Settings['fightRemainsCheck'];
				v89 = EpicSettings.Settings['dispelDebuffs'];
				v141 = 555 - (475 + 79);
			end
			if (((8906 - 4786) <= (13632 - 9372)) and (v141 == (1 + 3))) then
				v76 = EpicSettings.Settings['UseInvokeChiJi'];
				v78 = EpicSettings.Settings['InvokeChiJiHP'];
				v77 = EpicSettings.Settings['InvokeChiJiGroup'];
				v79 = EpicSettings.Settings['UseLifeCocoon'];
				v80 = EpicSettings.Settings['LifeCocoonHP'];
				v81 = EpicSettings.Settings['UseRevival'];
				v141 = 5 + 0;
			end
			if (((1506 - (1395 + 108)) == v141) or ((2569 - 1686) > (5982 - (7 + 1197)))) then
				v103 = EpicSettings.Settings['HandleCharredBrambles'];
				v102 = EpicSettings.Settings['HandleCharredTreant'];
				v104 = EpicSettings.Settings['HandleFyrakkNPC'];
				v73 = EpicSettings.Settings['UseInvokeYulon'];
				v75 = EpicSettings.Settings['InvokeYulonHP'];
				v74 = EpicSettings.Settings['InvokeYulonGroup'];
				v141 = 2 + 2;
			end
			if (((1 + 1) == v141) or ((3939 - (27 + 292)) >= (14332 - 9441))) then
				v90 = EpicSettings.Settings['InterruptWithStun'];
				v91 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v93 = EpicSettings.Settings['useSpearHandStrike'];
				v94 = EpicSettings.Settings['useLegSweep'];
				v100 = EpicSettings.Settings['handleAfflicted'];
				v101 = EpicSettings.Settings['HandleIncorporeal'];
				v141 = 3 - 0;
			end
			if (((17857 - 13599) > (1847 - 910)) and ((1 - 0) == v141)) then
				v86 = EpicSettings.Settings['useHealingPotion'];
				v87 = EpicSettings.Settings['healingPotionHP'];
				v88 = EpicSettings.Settings['HealingPotionName'];
				v84 = EpicSettings.Settings['useHealthstone'];
				v85 = EpicSettings.Settings['healthstoneHP'];
				v92 = EpicSettings.Settings['InterruptThreshold'];
				v141 = 141 - (43 + 96);
			end
			if ((v141 == (20 - 15)) or ((11007 - 6138) < (752 + 154))) then
				v83 = EpicSettings.Settings['RevivalHP'];
				v82 = EpicSettings.Settings['RevivalGroup'];
				break;
			end
		end
	end
	local function v130()
		v128();
		v129();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		v34 = EpicSettings.Toggles['healing'];
		v35 = EpicSettings.Toggles['dps'];
		if (v13:IsDeadOrGhost() or ((346 + 879) > (8356 - 4128))) then
			return;
		end
		v112 = v13:GetEnemiesInMeleeRange(4 + 4);
		if (((6236 - 2908) > (705 + 1533)) and v31) then
			v113 = #v112;
		else
			v113 = 1 + 0;
		end
		if (((5590 - (1414 + 337)) > (3345 - (1642 + 298))) and (v115.TargetIsValid() or v13:AffectingCombat())) then
			v107 = v13:GetEnemiesInRange(104 - 64);
			v105 = v10.BossFightRemains(nil, true);
			v106 = v105;
			if ((v106 == (31964 - 20853)) or ((3836 - 2543) <= (167 + 340))) then
				v106 = v10.FightRemains(v107, false);
			end
		end
		if (v13:AffectingCombat() or v30 or ((2254 + 642) < (1777 - (357 + 615)))) then
			local v153 = v89 and v108.Detox:IsReady() and v33;
			v29 = v115.FocusUnit(v153, nil, nil, nil);
			if (((1626 + 690) == (5682 - 3366)) and v29) then
				return v29;
			end
			if ((v33 and v89) or ((2203 + 367) == (3285 - 1752))) then
				if (v17 or ((707 + 176) == (100 + 1360))) then
					if ((v108.Detox:IsCastable() and v115.DispellableFriendlyUnit(16 + 9)) or ((5920 - (384 + 917)) <= (1696 - (128 + 569)))) then
						if (v24(v110.DetoxFocus, not v17:IsSpellInRange(v108.Detox)) or ((4953 - (1407 + 136)) > (6003 - (687 + 1200)))) then
							return "detox dispel focus";
						end
					end
				end
				if ((v16 and v16:Exists() and v16:IsAPlayer() and v115.UnitHasDispellableDebuffByPlayer(v16)) or ((2613 - (556 + 1154)) >= (10761 - 7702))) then
					if (v108.Detox:IsCastable() or ((4071 - (9 + 86)) < (3278 - (275 + 146)))) then
						if (((802 + 4128) > (2371 - (29 + 35))) and v24(v110.DetoxMouseover, not v16:IsSpellInRange(v108.Detox))) then
							return "detox dispel mouseover";
						end
					end
				end
			end
		end
		if (not v13:AffectingCombat() or ((17931 - 13885) < (3856 - 2565))) then
			if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((18721 - 14480) == (2309 + 1236))) then
				local v226 = v115.DeadFriendlyUnitsCount();
				if ((v226 > (1013 - (53 + 959))) or ((4456 - (312 + 96)) > (7344 - 3112))) then
					if (v24(v108.Reawaken, nil) or ((2035 - (147 + 138)) >= (4372 - (813 + 86)))) then
						return "reawaken";
					end
				elseif (((2862 + 304) == (5865 - 2699)) and v24(v110.ResuscitateMouseover, not v15:IsInRange(532 - (18 + 474)))) then
					return "resuscitate";
				end
			end
		end
		if (((595 + 1168) < (12154 - 8430)) and not v13:AffectingCombat() and v30) then
			local v154 = 1086 - (860 + 226);
			while true do
				if (((360 - (121 + 182)) <= (336 + 2387)) and (v154 == (1240 - (988 + 252)))) then
					v29 = v120();
					if (v29 or ((234 + 1836) == (139 + 304))) then
						return v29;
					end
					break;
				end
			end
		end
		if (v30 or v13:AffectingCombat() or ((4675 - (49 + 1921)) == (2283 - (223 + 667)))) then
			local v155 = 52 - (51 + 1);
			while true do
				if ((v155 == (1 - 0)) or ((9852 - 5251) < (1186 - (146 + 979)))) then
					if (v34 or ((393 + 997) >= (5349 - (311 + 294)))) then
						if ((v108.SummonJadeSerpentStatue:IsReady() and v108.SummonJadeSerpentStatue:IsAvailable() and (v108.SummonJadeSerpentStatue:TimeSinceLastCast() > (250 - 160)) and v66) or ((849 + 1154) > (5277 - (496 + 947)))) then
							if ((v65 == "Player") or ((1514 - (1233 + 125)) > (1588 + 2325))) then
								if (((175 + 20) == (38 + 157)) and v24(v110.SummonJadeSerpentStatuePlayer, not v15:IsInRange(1685 - (963 + 682)))) then
									return "jade serpent main player";
								end
							elseif (((2592 + 513) >= (3300 - (504 + 1000))) and (v65 == "Cursor")) then
								if (((2949 + 1430) >= (1941 + 190)) and v24(v110.SummonJadeSerpentStatueCursor, not v15:IsInRange(4 + 36))) then
									return "jade serpent main cursor";
								end
							elseif (((5667 - 1823) >= (1746 + 297)) and (v65 == "Confirmation")) then
								if (v24(v108.SummonJadeSerpentStatue, not v15:IsInRange(24 + 16)) or ((3414 - (156 + 26)) <= (1574 + 1157))) then
									return "jade serpent main confirmation";
								end
							end
						end
						if (((7673 - 2768) == (5069 - (149 + 15))) and v36 and (v13:BuffStack(v108.ManaTeaCharges) >= (978 - (890 + 70))) and v108.ManaTea:IsCastable()) then
							if (v24(v108.ManaTea, nil) or ((4253 - (39 + 78)) >= (4893 - (14 + 468)))) then
								return "Mana Tea main avoid overcap";
							end
						end
						if (((v106 > v99) and v32) or ((6504 - 3546) == (11227 - 7210))) then
							local v239 = 0 + 0;
							while true do
								if (((738 + 490) >= (173 + 640)) and (v239 == (0 + 0))) then
									v29 = v127();
									if (v29 or ((906 + 2549) > (7752 - 3702))) then
										return v29;
									end
									break;
								end
							end
						end
						if (((241 + 2) == (853 - 610)) and v31) then
							local v240 = 0 + 0;
							while true do
								if ((v240 == (51 - (12 + 39))) or ((253 + 18) > (4865 - 3293))) then
									v29 = v124();
									if (((9754 - 7015) < (977 + 2316)) and v29) then
										return v29;
									end
									break;
								end
							end
						end
						v29 = v123();
						if (v29 or ((2075 + 1867) < (2875 - 1741))) then
							return v29;
						end
					end
					break;
				end
				if ((v155 == (0 + 0)) or ((13014 - 10321) == (6683 - (1596 + 114)))) then
					v29 = v119();
					if (((5602 - 3456) == (2859 - (164 + 549))) and v29) then
						return v29;
					end
					v155 = 1439 - (1059 + 379);
				end
			end
		end
		if (((v30 or v13:AffectingCombat()) and v115.TargetIsValid() and v13:CanAttack(v15)) or ((2785 - 541) == (1671 + 1553))) then
			local v156 = 0 + 0;
			while true do
				if (((392 - (145 + 247)) == v156) or ((4024 + 880) <= (886 + 1030))) then
					v29 = v118();
					if (((266 - 176) <= (205 + 860)) and v29) then
						return v29;
					end
					v156 = 1 + 0;
				end
				if (((7796 - 2994) == (5522 - (254 + 466))) and (v156 == (561 - (544 + 16)))) then
					if ((v97 and ((v32 and v98) or not v98)) or ((7246 - 4966) <= (1139 - (294 + 334)))) then
						local v238 = 253 - (236 + 17);
						while true do
							if ((v238 == (0 + 0)) or ((1305 + 371) <= (1743 - 1280))) then
								v29 = v115.HandleTopTrinket(v111, v32, 189 - 149, nil);
								if (((1993 + 1876) == (3187 + 682)) and v29) then
									return v29;
								end
								v238 = 795 - (413 + 381);
							end
							if (((49 + 1109) <= (5556 - 2943)) and (v238 == (2 - 1))) then
								v29 = v115.HandleBottomTrinket(v111, v32, 2010 - (582 + 1388), nil);
								if (v29 or ((4027 - 1663) <= (1431 + 568))) then
									return v29;
								end
								break;
							end
						end
					end
					if (v35 or ((5286 - (326 + 38)) < (573 - 379))) then
						if ((v95 and ((v32 and v96) or not v96) and (v106 < (25 - 7))) or ((2711 - (47 + 573)) < (11 + 20))) then
							local v241 = 0 - 0;
							while true do
								if ((v241 == (2 - 0)) or ((4094 - (1269 + 395)) >= (5364 - (76 + 416)))) then
									if (v108.AncestralCall:IsCastable() or ((5213 - (319 + 124)) < (3965 - 2230))) then
										if (v24(v108.AncestralCall, nil) or ((5446 - (564 + 443)) <= (6505 - 4155))) then
											return "ancestral_call main 12";
										end
									end
									if (v108.BagofTricks:IsCastable() or ((4937 - (337 + 121)) < (13085 - 8619))) then
										if (((8484 - 5937) > (3136 - (1261 + 650))) and v24(v108.BagofTricks, not v15:IsInRange(17 + 23))) then
											return "bag_of_tricks main 14";
										end
									end
									break;
								end
								if (((7443 - 2772) > (4491 - (772 + 1045))) and (v241 == (1 + 0))) then
									if (v108.LightsJudgment:IsCastable() or ((3840 - (102 + 42)) < (5171 - (1524 + 320)))) then
										if (v24(v108.LightsJudgment, not v15:IsInRange(1310 - (1049 + 221))) or ((4698 - (18 + 138)) == (7269 - 4299))) then
											return "lights_judgment main 8";
										end
									end
									if (((1354 - (67 + 1035)) <= (2325 - (136 + 212))) and v108.Fireblood:IsCastable()) then
										if (v24(v108.Fireblood, nil) or ((6102 - 4666) == (3025 + 750))) then
											return "fireblood main 10";
										end
									end
									v241 = 2 + 0;
								end
								if ((v241 == (1604 - (240 + 1364))) or ((2700 - (1050 + 32)) < (3320 - 2390))) then
									if (((2794 + 1929) > (5208 - (331 + 724))) and v108.BloodFury:IsCastable()) then
										if (v24(v108.BloodFury, nil) or ((295 + 3359) >= (5298 - (269 + 375)))) then
											return "blood_fury main 4";
										end
									end
									if (((1676 - (267 + 458)) <= (466 + 1030)) and v108.Berserking:IsCastable()) then
										if (v24(v108.Berserking, nil) or ((3338 - 1602) == (1389 - (667 + 151)))) then
											return "berserking main 6";
										end
									end
									v241 = 1498 - (1410 + 87);
								end
							end
						end
						if ((v38 and v108.ThunderFocusTea:IsReady() and not v108.EssenceFont:IsAvailable() and (v108.RisingSunKick:CooldownRemains() < v13:GCD())) or ((2793 - (1504 + 393)) > (12890 - 8121))) then
							if (v24(v108.ThunderFocusTea, nil) or ((2711 - 1666) <= (1816 - (461 + 335)))) then
								return "ThunderFocusTea main 16";
							end
						end
						if (((v113 >= (1 + 2)) and v31) or ((2921 - (1730 + 31)) <= (1995 - (728 + 939)))) then
							v29 = v121();
							if (((13486 - 9678) > (5930 - 3006)) and v29) then
								return v29;
							end
						end
						if (((8915 - 5024) < (5987 - (138 + 930))) and (v113 < (3 + 0))) then
							local v242 = 0 + 0;
							while true do
								if ((v242 == (0 + 0)) or ((9121 - 6887) <= (3268 - (459 + 1307)))) then
									v29 = v122();
									if (v29 or ((4382 - (474 + 1396)) < (753 - 321))) then
										return v29;
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
	end
	local function v131()
		local v148 = 0 + 0;
		while true do
			if (((0 + 0) == v148) or ((5293 - 3445) == (110 + 755))) then
				v117();
				v22.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(901 - 631, v130, v131);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

