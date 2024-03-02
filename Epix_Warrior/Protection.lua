local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((1223 + 349) >= (3838 - 2307)) and (v5 == (2 - 1))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((6321 - (1607 + 27)) < (1307 + 3235))) then
			v6 = v0[v4];
			if (((5017 - (1668 + 58)) > (2293 - (512 + 114))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
	end
end
v0["Epix_Warrior_Protection.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = v10.Unit;
	local v12 = v10.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.TargetTarget;
	local v16 = v11.Focus;
	local v17 = v10.Spell;
	local v18 = v10.Item;
	local v19 = EpicLib;
	local v20 = v19.Bind;
	local v21 = v19.Cast;
	local v22 = v19.Macro;
	local v23 = v19.Press;
	local v24 = v19.Commons.Everyone.num;
	local v25 = v19.Commons.Everyone.bool;
	local v26 = UnitIsUnit;
	local v27 = math.floor;
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
	local v91 = 22970 - 11859;
	local v92 = 38662 - 27551;
	local v93;
	local v94 = v19.Commons.Everyone;
	local v95 = v17.Warrior.Protection;
	local v96 = v18.Warrior.Protection;
	local v97 = v22.Warrior.Protection;
	local v98 = {};
	local v99;
	local v100;
	local v101;
	local function v102()
		local v120 = 0 + 0;
		local v121;
		while true do
			if ((v120 == (0 + 0)) or ((759 + 114) == (6860 - 4826))) then
				v121 = UnitGetTotalAbsorbs(v14:ID());
				if ((v121 > (1994 - (109 + 1885))) or ((4285 - (1269 + 200)) < (20 - 9))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v103()
		return v13:IsTankingAoE(831 - (98 + 717)) or v13:IsTanking(v14) or v14:IsDummy();
	end
	local function v104()
		if (((4525 - (802 + 24)) < (8115 - 3409)) and v13:BuffUp(v95.IgnorePain)) then
			local v169 = v13:AttackPowerDamageMod() * (3.5 - 0) * (1 + 0 + (v13:VersatilityDmgPct() / (77 + 23)));
			local v170 = v13:AuraInfo(v95.IgnorePain, nil, true);
			local v171 = v170.points[1 + 0];
			return v171 < v169;
		else
			return true;
		end
	end
	local function v105()
		if (((571 + 2075) >= (2436 - 1560)) and v13:BuffUp(v95.IgnorePain)) then
			local v172 = 0 - 0;
			local v173;
			while true do
				if (((220 + 394) <= (1297 + 1887)) and (v172 == (0 + 0))) then
					v173 = v13:BuffInfo(v95.IgnorePain, nil, true);
					return v173.points[1 + 0];
				end
			end
		else
			return 0 + 0;
		end
	end
	local function v106()
		return v103() and v95.ShieldBlock:IsReady() and (((v13:BuffRemains(v95.ShieldBlockBuff) <= (1451 - (797 + 636))) and v95.EnduringDefenses:IsAvailable()) or (v13:BuffRemains(v95.ShieldBlockBuff) <= (58 - 46)));
	end
	local function v107(v122)
		local v123 = 1619 - (1427 + 192);
		local v124;
		local v125;
		local v126;
		while true do
			if (((1084 + 2042) == (7257 - 4131)) and (v123 == (2 + 0))) then
				if ((v126 and (((v13:Rage() + v122) >= v124) or v95.DemoralizingShout:IsReady())) or ((992 + 1195) >= (5280 - (192 + 134)))) then
					v125 = true;
				end
				if (v125 or ((5153 - (316 + 960)) == (1990 + 1585))) then
					if (((546 + 161) > (585 + 47)) and v103() and v104()) then
						if (v23(v95.IgnorePain, nil, nil, true) or ((2087 - 1541) >= (3235 - (83 + 468)))) then
							return "ignore_pain rage capped";
						end
					elseif (((3271 - (1202 + 604)) <= (20077 - 15776)) and v23(v95.Revenge, not v99)) then
						return "revenge rage capped";
					end
				end
				break;
			end
			if (((2835 - 1131) > (3945 - 2520)) and (v123 == (325 - (45 + 280)))) then
				v124 = 78 + 2;
				if ((v124 < (31 + 4)) or (v13:Rage() < (13 + 22)) or ((381 + 306) == (745 + 3489))) then
					return false;
				end
				v123 = 1 - 0;
			end
			if ((v123 == (1912 - (340 + 1571))) or ((1314 + 2016) < (3201 - (1733 + 39)))) then
				v125 = false;
				v126 = (v13:Rage() >= (96 - 61)) and not v106();
				v123 = 1036 - (125 + 909);
			end
		end
	end
	local function v108()
		local v127 = 1948 - (1096 + 852);
		while true do
			if (((515 + 632) >= (477 - 142)) and (v127 == (3 + 0))) then
				if (((3947 - (409 + 103)) > (2333 - (46 + 190))) and v96.Healthstone:IsReady() and v68 and (v13:HealthPercentage() <= v80)) then
					if (v23(v97.Healthstone) or ((3865 - (51 + 44)) >= (1140 + 2901))) then
						return "healthstone defensive 3";
					end
				end
				if ((v69 and (v13:HealthPercentage() <= v81)) or ((5108 - (1114 + 203)) <= (2337 - (228 + 498)))) then
					local v187 = 0 + 0;
					while true do
						if (((0 + 0) == v187) or ((5241 - (174 + 489)) <= (5231 - 3223))) then
							if (((3030 - (830 + 1075)) <= (2600 - (303 + 221))) and (v86 == "Refreshing Healing Potion")) then
								if (v96.RefreshingHealingPotion:IsReady() or ((2012 - (231 + 1038)) >= (3666 + 733))) then
									if (((2317 - (171 + 991)) < (6894 - 5221)) and v23(v97.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v86 == "Dreamwalker's Healing Potion") or ((6240 - 3916) <= (1442 - 864))) then
								if (((3015 + 752) == (13204 - 9437)) and v96.DreamwalkersHealingPotion:IsReady()) then
									if (((11795 - 7706) == (6590 - 2501)) and v23(v97.RefreshingHealingPotion)) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((13780 - 9322) >= (2922 - (111 + 1137))) and (v127 == (159 - (91 + 67)))) then
				if (((2892 - 1920) <= (354 + 1064)) and v95.IgnorePain:IsReady() and v65 and (v13:HealthPercentage() <= v75) and v104()) then
					if (v23(v95.IgnorePain, nil, nil, true) or ((5461 - (423 + 100)) < (34 + 4728))) then
						return "ignore_pain defensive";
					end
				end
				if ((v95.RallyingCry:IsReady() and v66 and v13:BuffDown(v95.AspectsFavorBuff) and v13:BuffDown(v95.RallyingCry) and (((v13:HealthPercentage() <= v76) and v94.IsSoloMode()) or v94.AreUnitsBelowHealthPercentage(v76, v77, v95.Intervene))) or ((6933 - 4429) > (2223 + 2041))) then
					if (((2924 - (326 + 445)) == (9395 - 7242)) and v23(v95.RallyingCry)) then
						return "rallying_cry defensive";
					end
				end
				v127 = 4 - 2;
			end
			if (((0 - 0) == v127) or ((1218 - (530 + 181)) >= (3472 - (614 + 267)))) then
				if (((4513 - (19 + 13)) == (7293 - 2812)) and v95.BitterImmunity:IsReady() and v61 and (v13:HealthPercentage() <= v71)) then
					if (v23(v95.BitterImmunity) or ((5424 - 3096) < (1979 - 1286))) then
						return "bitter_immunity defensive";
					end
				end
				if (((1125 + 3203) == (7611 - 3283)) and v95.LastStand:IsCastable() and v64 and ((v13:HealthPercentage() <= v74) or v13:ActiveMitigationNeeded())) then
					if (((3293 - 1705) >= (3144 - (1293 + 519))) and v23(v95.LastStand)) then
						return "last_stand defensive";
					end
				end
				v127 = 1 - 0;
			end
			if (((4 - 2) == v127) or ((7981 - 3807) > (18317 - 14069))) then
				if ((v95.Intervene:IsReady() and v67 and (v16:HealthPercentage() <= v78) and (v16:Name() ~= v13:Name())) or ((10803 - 6217) <= (44 + 38))) then
					if (((789 + 3074) == (8975 - 5112)) and v23(v97.InterveneFocus)) then
						return "intervene defensive";
					end
				end
				if ((v95.ShieldWall:IsCastable() and v62 and v13:BuffDown(v95.ShieldWallBuff) and ((v13:HealthPercentage() <= v72) or v13:ActiveMitigationNeeded())) or ((66 + 216) <= (14 + 28))) then
					if (((2881 + 1728) >= (1862 - (709 + 387))) and v23(v95.ShieldWall)) then
						return "shield_wall defensive";
					end
				end
				v127 = 1861 - (673 + 1185);
			end
		end
	end
	local function v109()
		v28 = v94.HandleTopTrinket(v98, v31, 116 - 76, nil);
		if (v28 or ((3698 - 2546) == (4093 - 1605))) then
			return v28;
		end
		v28 = v94.HandleBottomTrinket(v98, v31, 29 + 11, nil);
		if (((2557 + 865) > (4523 - 1173)) and v28) then
			return v28;
		end
	end
	local function v110()
		if (((216 + 661) > (749 - 373)) and v14:IsInMeleeRange(15 - 7)) then
			if ((v95.ThunderClap:IsCastable() and v46) or ((4998 - (446 + 1434)) <= (3134 - (1040 + 243)))) then
				if (v23(v95.ThunderClap) or ((492 - 327) >= (5339 - (559 + 1288)))) then
					return "thunder_clap precombat";
				end
			end
		elseif (((5880 - (609 + 1322)) < (5310 - (13 + 441))) and v35 and v95.Charge:IsCastable() and not v14:IsInRange(29 - 21)) then
			if (v23(v95.Charge, not v14:IsSpellInRange(v95.Charge)) or ((11200 - 6924) < (15021 - 12005))) then
				return "charge precombat";
			end
		end
	end
	local function v111()
		local v128 = 0 + 0;
		while true do
			if (((17033 - 12343) > (1466 + 2659)) and (v128 == (1 + 0))) then
				if ((v95.ThunderClap:IsCastable() and v46 and v13:BuffUp(v95.ViolentOutburstBuff) and (v101 > (14 - 9)) and v13:BuffUp(v95.AvatarBuff) and v95.UnstoppableForce:IsAvailable()) or ((28 + 22) >= (1647 - 751))) then
					local v188 = 0 + 0;
					while true do
						if ((v188 == (0 + 0)) or ((1232 + 482) >= (2484 + 474))) then
							v107(5 + 0);
							if (v23(v95.ThunderClap, not v14:IsInMeleeRange(441 - (153 + 280))) or ((4305 - 2814) < (579 + 65))) then
								return "thunder_clap aoe 4";
							end
							break;
						end
					end
				end
				if (((278 + 426) < (517 + 470)) and v95.Revenge:IsReady() and v41 and (v13:Rage() >= (64 + 6)) and v95.SeismicReverberation:IsAvailable() and (v101 >= (3 + 0))) then
					if (((5661 - 1943) > (1179 + 727)) and v23(v95.Revenge, not v99)) then
						return "revenge aoe 6";
					end
				end
				v128 = 669 - (89 + 578);
			end
			if ((v128 == (2 + 0)) or ((1991 - 1033) > (4684 - (572 + 477)))) then
				if (((473 + 3028) <= (2696 + 1796)) and v95.ShieldSlam:IsCastable() and v43 and ((v13:Rage() <= (8 + 52)) or (v13:BuffUp(v95.ViolentOutburstBuff) and (v101 <= (93 - (84 + 2)))))) then
					local v189 = 0 - 0;
					while true do
						if ((v189 == (0 + 0)) or ((4284 - (497 + 345)) < (66 + 2482))) then
							v107(4 + 16);
							if (((4208 - (605 + 728)) >= (1045 + 419)) and v23(v95.ShieldSlam, not v99)) then
								return "shield_slam aoe 8";
							end
							break;
						end
					end
				end
				if ((v95.ThunderClap:IsCastable() and v46) or ((10664 - 5867) >= (225 + 4668))) then
					local v190 = 0 - 0;
					while true do
						if ((v190 == (0 + 0)) or ((1526 - 975) > (1562 + 506))) then
							v107(494 - (457 + 32));
							if (((897 + 1217) > (2346 - (832 + 570))) and v23(v95.ThunderClap, not v14:IsInMeleeRange(8 + 0))) then
								return "thunder_clap aoe 10";
							end
							break;
						end
					end
				end
				v128 = 1 + 2;
			end
			if (((10 - 7) == v128) or ((1090 + 1172) >= (3892 - (588 + 208)))) then
				if ((v95.Revenge:IsReady() and v41 and ((v13:Rage() >= (80 - 50)) or ((v13:Rage() >= (1840 - (884 + 916))) and v95.BarbaricTraining:IsAvailable()))) or ((4721 - 2466) >= (2051 + 1486))) then
					if (v23(v95.Revenge, not v99) or ((4490 - (232 + 421)) < (3195 - (1569 + 320)))) then
						return "revenge aoe 12";
					end
				end
				break;
			end
			if (((724 + 2226) == (561 + 2389)) and (v128 == (0 - 0))) then
				if ((v95.ThunderClap:IsCastable() and v46 and (v14:DebuffRemains(v95.RendDebuff) <= (606 - (316 + 289)))) or ((12363 - 7640) < (153 + 3145))) then
					local v191 = 1453 - (666 + 787);
					while true do
						if (((1561 - (360 + 65)) >= (144 + 10)) and (v191 == (254 - (79 + 175)))) then
							v107(7 - 2);
							if (v23(v95.ThunderClap, not v14:IsInMeleeRange(7 + 1)) or ((830 - 559) > (9143 - 4395))) then
								return "thunder_clap aoe 2";
							end
							break;
						end
					end
				end
				if (((5639 - (503 + 396)) >= (3333 - (92 + 89))) and v95.ShieldSlam:IsCastable() and v43 and ((v13:HasTier(58 - 28, 2 + 0) and (v101 <= (5 + 2))) or v13:BuffUp(v95.EarthenTenacityBuff))) then
					if (v23(v95.ShieldSlam, not v99) or ((10095 - 7517) >= (464 + 2926))) then
						return "shield_slam aoe 3";
					end
				end
				v128 = 2 - 1;
			end
		end
	end
	local function v112()
		local v129 = 0 + 0;
		while true do
			if (((20 + 21) <= (5058 - 3397)) and (v129 == (1 + 1))) then
				if (((916 - 315) < (4804 - (485 + 759))) and v95.Revenge:IsReady() and v41 and (((v13:Rage() >= (138 - 78)) and (v14:HealthPercentage() > (1209 - (442 + 747)))) or (v13:BuffUp(v95.RevengeBuff) and (v14:HealthPercentage() <= (1155 - (832 + 303))) and (v13:Rage() <= (964 - (88 + 858))) and v95.ShieldSlam:CooldownDown()) or (v13:BuffUp(v95.RevengeBuff) and (v14:HealthPercentage() > (7 + 13))) or ((((v13:Rage() >= (50 + 10)) and (v14:HealthPercentage() > (2 + 33))) or (v13:BuffUp(v95.RevengeBuff) and (v14:HealthPercentage() <= (824 - (766 + 23))) and (v13:Rage() <= (88 - 70)) and v95.ShieldSlam:CooldownDown()) or (v13:BuffUp(v95.RevengeBuff) and (v14:HealthPercentage() > (47 - 12)))) and v95.Massacre:IsAvailable()))) then
					if (((619 - 384) < (2331 - 1644)) and v23(v95.Revenge, not v99)) then
						return "revenge generic 14";
					end
				end
				if (((5622 - (1036 + 37)) > (818 + 335)) and v95.Execute:IsReady() and v38 and (v101 == (1 - 0))) then
					if (v23(v95.Execute, not v99) or ((3677 + 997) < (6152 - (641 + 839)))) then
						return "execute generic 16";
					end
				end
				if (((4581 - (910 + 3)) < (11627 - 7066)) and v95.Revenge:IsReady() and v41 and (v14:HealthPercentage() > (1704 - (1466 + 218)))) then
					if (v23(v95.Revenge, not v99) or ((210 + 245) == (4753 - (556 + 592)))) then
						return "revenge generic 18";
					end
				end
				v129 = 2 + 1;
			end
			if ((v129 == (808 - (329 + 479))) or ((3517 - (174 + 680)) == (11380 - 8068))) then
				if (((8865 - 4588) <= (3196 + 1279)) and v95.ShieldSlam:IsCastable() and v43) then
					v107(759 - (396 + 343));
					if (v23(v95.ShieldSlam, not v99) or ((77 + 793) == (2666 - (29 + 1448)))) then
						return "shield_slam generic 2";
					end
				end
				if (((2942 - (135 + 1254)) <= (11802 - 8669)) and v95.ThunderClap:IsCastable() and v46 and (v14:DebuffRemains(v95.RendDebuff) <= (4 - 3)) and v13:BuffDown(v95.ViolentOutburstBuff)) then
					local v192 = 0 + 0;
					while true do
						if ((v192 == (1527 - (389 + 1138))) or ((2811 - (102 + 472)) >= (3314 + 197))) then
							v107(3 + 2);
							if (v23(v95.ThunderClap, not v14:IsInMeleeRange(8 + 0)) or ((2869 - (320 + 1225)) > (5376 - 2356))) then
								return "thunder_clap generic 4";
							end
							break;
						end
					end
				end
				if ((v95.Execute:IsReady() and v38 and v13:BuffUp(v95.SuddenDeathBuff) and v95.SuddenDeath:IsAvailable()) or ((1831 + 1161) == (3345 - (157 + 1307)))) then
					if (((4965 - (821 + 1038)) > (3807 - 2281)) and v23(v95.Execute, not v99)) then
						return "execute generic 6";
					end
				end
				v129 = 1 + 0;
			end
			if (((5369 - 2346) < (1440 + 2430)) and (v129 == (2 - 1))) then
				if (((1169 - (834 + 192)) > (5 + 69)) and v95.Execute:IsReady() and v38 and (v101 == (1 + 0)) and (v95.Massacre:IsAvailable() or v95.Juggernaut:IsAvailable()) and (v13:Rage() >= (2 + 48))) then
					if (((27 - 9) < (2416 - (300 + 4))) and v23(v95.Execute, not v99)) then
						return "execute generic 6";
					end
				end
				if (((293 + 804) <= (4261 - 2633)) and v95.Execute:IsReady() and v38 and (v101 == (363 - (112 + 250))) and (v13:Rage() >= (20 + 30))) then
					if (((11599 - 6969) == (2653 + 1977)) and v23(v95.Execute, not v99)) then
						return "execute generic 10";
					end
				end
				if (((1831 + 1709) > (2007 + 676)) and v95.ThunderClap:IsCastable() and v46 and ((v101 > (1 + 0)) or (v95.ShieldSlam:CooldownDown() and not v13:BuffUp(v95.ViolentOutburstBuff)))) then
					v107(4 + 1);
					if (((6208 - (1001 + 413)) >= (7303 - 4028)) and v23(v95.ThunderClap, not v14:IsInMeleeRange(890 - (244 + 638)))) then
						return "thunder_clap generic 12";
					end
				end
				v129 = 695 - (627 + 66);
			end
			if (((4421 - 2937) == (2086 - (512 + 90))) and (v129 == (1909 - (1665 + 241)))) then
				if (((2149 - (373 + 344)) < (1604 + 1951)) and v95.ThunderClap:IsCastable() and v46 and ((v101 >= (1 + 0)) or (v95.ShieldSlam:CooldownDown() and v13:BuffUp(v95.ViolentOutburstBuff)))) then
					local v193 = 0 - 0;
					while true do
						if ((v193 == (0 - 0)) or ((2164 - (35 + 1064)) > (2604 + 974))) then
							v107(10 - 5);
							if (v23(v95.ThunderClap, not v14:IsInMeleeRange(1 + 7)) or ((6031 - (298 + 938)) < (2666 - (233 + 1026)))) then
								return "thunder_clap generic 20";
							end
							break;
						end
					end
				end
				if (((3519 - (636 + 1030)) < (2461 + 2352)) and v95.Devastate:IsCastable() and v37) then
					if (v23(v95.Devastate, not v99) or ((2756 + 65) < (723 + 1708))) then
						return "devastate generic 22";
					end
				end
				break;
			end
		end
	end
	local function v113()
		local v130 = 0 + 0;
		while true do
			if (((221 - (55 + 166)) == v130) or ((557 + 2317) < (220 + 1961))) then
				if (not v13:AffectingCombat() or ((10269 - 7580) <= (640 - (36 + 261)))) then
					local v194 = 0 - 0;
					while true do
						if ((v194 == (1368 - (34 + 1334))) or ((719 + 1150) == (1561 + 448))) then
							if ((v95.BattleShout:IsCastable() and v34 and (v13:BuffDown(v95.BattleShoutBuff, true) or v94.GroupBuffMissing(v95.BattleShoutBuff))) or ((4829 - (1035 + 248)) < (2343 - (20 + 1)))) then
								if (v23(v95.BattleShout) or ((1085 + 997) == (5092 - (134 + 185)))) then
									return "battle_shout precombat";
								end
							end
							if (((4377 - (549 + 584)) > (1740 - (314 + 371))) and v93 and v95.BattleStance:IsCastable() and not v13:BuffUp(v95.BattleStance)) then
								if (v23(v95.BattleStance) or ((11373 - 8060) <= (2746 - (478 + 490)))) then
									return "battle_stance precombat";
								end
							end
							break;
						end
					end
				end
				if ((v94.TargetIsValid() and v29) or ((753 + 668) >= (3276 - (786 + 386)))) then
					if (((5868 - 4056) <= (4628 - (1055 + 324))) and not v13:AffectingCombat()) then
						local v198 = 1340 - (1093 + 247);
						while true do
							if (((1443 + 180) <= (206 + 1751)) and (v198 == (0 - 0))) then
								v28 = v110();
								if (((14973 - 10561) == (12554 - 8142)) and v28) then
									return v28;
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
	local function v114()
		local v131 = 0 - 0;
		while true do
			if (((623 + 1127) >= (3243 - 2401)) and (v131 == (3 - 2))) then
				if (((3297 + 1075) > (4731 - 2881)) and v85) then
					local v195 = 688 - (364 + 324);
					while true do
						if (((635 - 403) < (1969 - 1148)) and (v195 == (0 + 0))) then
							v28 = v94.HandleIncorporeal(v95.StormBolt, v97.StormBoltMouseover, 83 - 63, true);
							if (((829 - 311) < (2739 - 1837)) and v28) then
								return v28;
							end
							v195 = 1269 - (1249 + 19);
						end
						if (((2703 + 291) > (3339 - 2481)) and (v195 == (1087 - (686 + 400)))) then
							v28 = v94.HandleIncorporeal(v95.IntimidatingShout, v97.IntimidatingShoutMouseover, 7 + 1, true);
							if (v28 or ((3984 - (73 + 156)) <= (5 + 910))) then
								return v28;
							end
							break;
						end
					end
				end
				if (((4757 - (721 + 90)) > (43 + 3700)) and v94.TargetIsValid()) then
					local v196 = 0 - 0;
					local v197;
					while true do
						if ((v196 == (470 - (224 + 246))) or ((2162 - 827) >= (6086 - 2780))) then
							if (((879 + 3965) > (54 + 2199)) and v93 and (v13:HealthPercentage() <= v79)) then
								if (((332 + 120) == (898 - 446)) and v95.DefensiveStance:IsCastable() and not v13:BuffUp(v95.DefensiveStance)) then
									if (v23(v95.DefensiveStance) or ((15164 - 10607) < (2600 - (203 + 310)))) then
										return "defensive_stance while tanking";
									end
								end
							end
							if (((5867 - (1238 + 755)) == (271 + 3603)) and v93 and (v13:HealthPercentage() > v79)) then
								if ((v95.BattleStance:IsCastable() and not v13:BuffUp(v95.BattleStance)) or ((3472 - (709 + 825)) > (9093 - 4158))) then
									if (v23(v95.BattleStance) or ((6197 - 1942) < (4287 - (196 + 668)))) then
										return "battle_stance while not tanking";
									end
								end
							end
							if (((5740 - 4286) <= (5159 - 2668)) and v42 and ((v53 and v31) or not v53) and (v90 < v92) and v95.ShieldCharge:IsCastable() and not v99) then
								if (v23(v95.ShieldCharge, not v14:IsSpellInRange(v95.ShieldCharge)) or ((4990 - (171 + 662)) <= (2896 - (4 + 89)))) then
									return "shield_charge main 34";
								end
							end
							if (((17009 - 12156) >= (1086 + 1896)) and v35 and v95.Charge:IsCastable() and not v99) then
								if (((18157 - 14023) > (1317 + 2040)) and v23(v95.Charge, not v14:IsSpellInRange(v95.Charge))) then
									return "charge main 34";
								end
							end
							v196 = 1487 - (35 + 1451);
						end
						if ((v196 == (1454 - (28 + 1425))) or ((5410 - (941 + 1052)) < (2430 + 104))) then
							if ((v90 < v92) or ((4236 - (822 + 692)) <= (233 - 69))) then
								local v201 = 0 + 0;
								while true do
									if (((297 - (45 + 252)) == v201) or ((2383 + 25) < (726 + 1383))) then
										if ((v49 and ((v31 and v56) or not v56)) or ((80 - 47) == (1888 - (114 + 319)))) then
											local v207 = 0 - 0;
											while true do
												if (((0 - 0) == v207) or ((283 + 160) >= (5981 - 1966))) then
													v28 = v109();
													if (((7085 - 3703) > (2129 - (556 + 1407))) and v28) then
														return v28;
													end
													break;
												end
											end
										end
										if ((v31 and v96.FyralathTheDreamrender:IsEquippedAndReady() and v32) or ((1486 - (741 + 465)) == (3524 - (170 + 295)))) then
											if (((992 + 889) > (1188 + 105)) and v23(v97.UseWeapon)) then
												return "Fyralath The Dreamrender used";
											end
										end
										break;
									end
								end
							end
							if (((5803 - 3446) == (1954 + 403)) and v39 and v95.HeroicThrow:IsCastable() and not v14:IsInRange(17 + 8)) then
								if (((70 + 53) == (1353 - (957 + 273))) and v23(v95.HeroicThrow, not v14:IsSpellInRange(v95.HeroicThrow))) then
									return "heroic_throw main";
								end
							end
							if ((v95.WreckingThrow:IsCastable() and v48 and v13:CanAttack(v14) and v102()) or ((283 + 773) >= (1358 + 2034))) then
								if (v23(v95.WreckingThrow, not v14:IsSpellInRange(v95.WreckingThrow)) or ((4119 - 3038) < (2832 - 1757))) then
									return "wrecking_throw main";
								end
							end
							if (((v90 < v92) and v33 and ((v51 and v31) or not v51) and v95.Avatar:IsCastable()) or ((3203 - 2154) >= (21945 - 17513))) then
								if (v23(v95.Avatar) or ((6548 - (389 + 1391)) <= (531 + 315))) then
									return "avatar main 2";
								end
							end
							v196 = 1 + 1;
						end
						if ((v196 == (6 - 3)) or ((4309 - (783 + 168)) <= (4765 - 3345))) then
							if ((v103() and v64 and v95.LastStand:IsCastable() and v13:BuffDown(v95.ShieldWallBuff) and (((v14:HealthPercentage() >= (89 + 1)) and v95.UnnervingFocus:IsAvailable()) or ((v14:HealthPercentage() <= (331 - (309 + 2))) and v95.UnnervingFocus:IsAvailable()) or v95.Bolster:IsAvailable() or v13:HasTier(92 - 62, 1214 - (1090 + 122)))) or ((1213 + 2526) <= (10092 - 7087))) then
								if (v23(v95.LastStand) or ((1136 + 523) >= (3252 - (628 + 490)))) then
									return "last_stand defensive";
								end
							end
							if (((v90 < v92) and v40 and ((v52 and v31) or not v52) and (v83 == "player") and v95.Ravager:IsCastable()) or ((585 + 2675) < (5830 - 3475))) then
								v107(45 - 35);
								if (v23(v97.RavagerPlayer, not v99) or ((1443 - (431 + 343)) == (8528 - 4305))) then
									return "ravager main 24";
								end
							end
							if (((v90 < v92) and v40 and ((v52 and v31) or not v52) and (v83 == "cursor") and v95.Ravager:IsCastable()) or ((4894 - 3202) < (465 + 123))) then
								v107(2 + 8);
								if (v23(v97.RavagerCursor, not v99) or ((6492 - (556 + 1139)) < (3666 - (6 + 9)))) then
									return "ravager main 24";
								end
							end
							if ((v95.DemoralizingShout:IsCastable() and v36 and v95.BoomingVoice:IsAvailable()) or ((765 + 3412) > (2485 + 2365))) then
								local v202 = 169 - (28 + 141);
								while true do
									if ((v202 == (0 + 0)) or ((493 - 93) > (787 + 324))) then
										v107(1347 - (486 + 831));
										if (((7939 - 4888) > (3538 - 2533)) and v23(v95.DemoralizingShout, not v99)) then
											return "demoralizing_shout main 28";
										end
										break;
									end
								end
							end
							v196 = 1 + 3;
						end
						if (((11676 - 7983) <= (5645 - (668 + 595))) and (v196 == (5 + 0))) then
							if ((v95.Shockwave:IsCastable() and v44 and v13:BuffUp(v95.AvatarBuff) and v95.UnstoppableForce:IsAvailable() and not v95.RumblingEarth:IsAvailable()) or (v95.SonicBoom:IsAvailable() and v95.RumblingEarth:IsAvailable() and (v101 >= (1 + 2)) and v14:IsCasting()) or ((8950 - 5668) > (4390 - (23 + 267)))) then
								local v203 = 1944 - (1129 + 815);
								while true do
									if ((v203 == (387 - (371 + 16))) or ((5330 - (1326 + 424)) < (5386 - 2542))) then
										v107(36 - 26);
										if (((207 - (88 + 30)) < (5261 - (720 + 51))) and v23(v95.Shockwave, not v14:IsInMeleeRange(17 - 9))) then
											return "shockwave main 32";
										end
										break;
									end
								end
							end
							if (((v90 < v92) and v95.ShieldCharge:IsCastable() and v42 and ((v53 and v31) or not v53)) or ((6759 - (421 + 1355)) < (2982 - 1174))) then
								if (((1881 + 1948) > (4852 - (286 + 797))) and v23(v95.ShieldCharge, not v14:IsSpellInRange(v95.ShieldCharge))) then
									return "shield_charge main 34";
								end
							end
							if (((5428 - 3943) <= (4809 - 1905)) and v106() and v63) then
								if (((4708 - (397 + 42)) == (1334 + 2935)) and v23(v95.ShieldBlock)) then
									return "shield_block main 38";
								end
							end
							if (((1187 - (24 + 776)) <= (4285 - 1503)) and (v101 > (788 - (222 + 563)))) then
								local v204 = 0 - 0;
								while true do
									if ((v204 == (1 + 0)) or ((2089 - (23 + 167)) <= (2715 - (690 + 1108)))) then
										if (v19.CastAnnotated(v95.Pool, false, "WAIT") or ((1556 + 2756) <= (723 + 153))) then
											return "Pool for Aoe()";
										end
										break;
									end
									if (((3080 - (40 + 808)) <= (428 + 2168)) and (v204 == (0 - 0))) then
										v28 = v111();
										if (((2003 + 92) < (1950 + 1736)) and v28) then
											return v28;
										end
										v204 = 1 + 0;
									end
								end
							end
							v196 = 577 - (47 + 524);
						end
						if ((v196 == (2 + 0)) or ((4359 - 2764) >= (6689 - 2215))) then
							if (((v90 < v92) and v50 and ((v57 and v31) or not v57)) or ((10533 - 5914) < (4608 - (1165 + 561)))) then
								if (v95.BloodFury:IsCastable() or ((9 + 285) >= (14962 - 10131))) then
									if (((775 + 1254) <= (3563 - (341 + 138))) and v23(v95.BloodFury)) then
										return "blood_fury main 4";
									end
								end
								if (v95.Berserking:IsCastable() or ((550 + 1487) == (4994 - 2574))) then
									if (((4784 - (89 + 237)) > (12558 - 8654)) and v23(v95.Berserking)) then
										return "berserking main 6";
									end
								end
								if (((917 - 481) >= (1004 - (581 + 300))) and v95.ArcaneTorrent:IsCastable()) then
									if (((1720 - (855 + 365)) < (4313 - 2497)) and v23(v95.ArcaneTorrent)) then
										return "arcane_torrent main 8";
									end
								end
								if (((1167 + 2407) == (4809 - (1030 + 205))) and v95.LightsJudgment:IsCastable()) then
									if (((208 + 13) < (363 + 27)) and v23(v95.LightsJudgment)) then
										return "lights_judgment main 10";
									end
								end
								if (v95.Fireblood:IsCastable() or ((2499 - (156 + 130)) <= (3228 - 1807))) then
									if (((5153 - 2095) < (9953 - 5093)) and v23(v95.Fireblood)) then
										return "fireblood main 12";
									end
								end
								if (v95.AncestralCall:IsCastable() or ((342 + 954) >= (2593 + 1853))) then
									if (v23(v95.AncestralCall) or ((1462 - (10 + 59)) > (1270 + 3219))) then
										return "ancestral_call main 14";
									end
								end
								if (v95.BagofTricks:IsCastable() or ((21787 - 17363) < (1190 - (671 + 492)))) then
									if (v23(v95.BagofTricks) or ((1590 + 407) > (5030 - (369 + 846)))) then
										return "ancestral_call main 16";
									end
								end
							end
							v197 = v94.HandleDPSPotion(v14:BuffUp(v95.AvatarBuff));
							if (((918 + 2547) > (1633 + 280)) and v197) then
								return v197;
							end
							if (((2678 - (1036 + 909)) < (1447 + 372)) and v95.IgnorePain:IsReady() and v65 and v104() and (v14:HealthPercentage() >= (33 - 13)) and (((v13:RageDeficit() <= (218 - (11 + 192))) and v95.ShieldSlam:CooldownUp()) or ((v13:RageDeficit() <= (21 + 19)) and v95.ShieldCharge:CooldownUp() and v95.ChampionsBulwark:IsAvailable()) or ((v13:RageDeficit() <= (195 - (135 + 40))) and v95.ShieldCharge:CooldownUp()) or ((v13:RageDeficit() <= (72 - 42)) and v95.DemoralizingShout:CooldownUp() and v95.BoomingVoice:IsAvailable()) or ((v13:RageDeficit() <= (13 + 7)) and v95.Avatar:CooldownUp()) or ((v13:RageDeficit() <= (98 - 53)) and v95.DemoralizingShout:CooldownUp() and v95.BoomingVoice:IsAvailable() and v13:BuffUp(v95.LastStandBuff) and v95.UnnervingFocus:IsAvailable()) or ((v13:RageDeficit() <= (44 - 14)) and v95.Avatar:CooldownUp() and v13:BuffUp(v95.LastStandBuff) and v95.UnnervingFocus:IsAvailable()) or (v13:RageDeficit() <= (196 - (50 + 126))) or ((v13:RageDeficit() <= (111 - 71)) and v95.ShieldSlam:CooldownUp() and v13:BuffUp(v95.ViolentOutburstBuff) and v95.HeavyRepercussions:IsAvailable() and v95.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (13 + 42)) and v95.ShieldSlam:CooldownUp() and v13:BuffUp(v95.ViolentOutburstBuff) and v13:BuffUp(v95.LastStandBuff) and v95.UnnervingFocus:IsAvailable() and v95.HeavyRepercussions:IsAvailable() and v95.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (1430 - (1233 + 180))) and v95.ShieldSlam:CooldownUp() and v95.HeavyRepercussions:IsAvailable()) or ((v13:RageDeficit() <= (987 - (522 + 447))) and v95.ShieldSlam:CooldownUp() and v95.ImpenetrableWall:IsAvailable()))) then
								if (v23(v95.IgnorePain, nil, nil, true) or ((5816 - (107 + 1314)) == (2207 + 2548))) then
									return "ignore_pain main 20";
								end
							end
							v196 = 8 - 5;
						end
						if ((v196 == (3 + 3)) or ((7532 - 3739) < (9373 - 7004))) then
							v28 = v112();
							if (v28 or ((5994 - (716 + 1194)) == (5 + 260))) then
								return v28;
							end
							if (((467 + 3891) == (4861 - (74 + 429))) and v19.CastAnnotated(v95.Pool, false, "WAIT")) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((v196 == (7 - 3)) or ((1556 + 1582) < (2272 - 1279))) then
							if (((2356 + 974) > (7161 - 4838)) and (v90 < v92) and v45 and ((v54 and v31) or not v54) and (v84 == "player") and v95.ChampionsSpear:IsCastable()) then
								local v205 = 0 - 0;
								while true do
									if ((v205 == (433 - (279 + 154))) or ((4404 - (454 + 324)) == (3139 + 850))) then
										v107(37 - (12 + 5));
										if (v23(v97.ChampionsSpearPlayer, not v99) or ((494 + 422) == (6805 - 4134))) then
											return "spear_of_bastion main 28";
										end
										break;
									end
								end
							end
							if (((101 + 171) == (1365 - (277 + 816))) and (v90 < v92) and v45 and ((v54 and v31) or not v54) and (v84 == "cursor") and v95.ChampionsSpear:IsCastable()) then
								local v206 = 0 - 0;
								while true do
									if (((5432 - (1058 + 125)) <= (908 + 3931)) and (v206 == (975 - (815 + 160)))) then
										v107(85 - 65);
										if (((6591 - 3814) < (764 + 2436)) and v23(v97.ChampionsSpearCursor, not v99)) then
											return "spear_of_bastion main 28";
										end
										break;
									end
								end
							end
							if (((277 - 182) < (3855 - (41 + 1857))) and (v90 < v92) and v47 and ((v55 and v31) or not v55) and v95.ThunderousRoar:IsCastable()) then
								if (((2719 - (1222 + 671)) < (4437 - 2720)) and v23(v95.ThunderousRoar, not v14:IsInMeleeRange(11 - 3))) then
									return "thunderous_roar main 30";
								end
							end
							if (((2608 - (229 + 953)) >= (2879 - (1111 + 663))) and v95.ShieldSlam:IsCastable() and v43 and v13:BuffUp(v95.FervidBuff)) then
								if (((4333 - (874 + 705)) <= (473 + 2906)) and v23(v95.ShieldSlam, not v99)) then
									return "shield_slam main 31";
								end
							end
							v196 = 4 + 1;
						end
					end
				end
				break;
			end
			if ((v131 == (0 - 0)) or ((111 + 3816) == (2092 - (642 + 37)))) then
				v28 = v108();
				if (v28 or ((264 + 890) <= (127 + 661))) then
					return v28;
				end
				v131 = 2 - 1;
			end
		end
	end
	local function v115()
		v32 = EpicSettings.Settings['useWeapon'];
		v34 = EpicSettings.Settings['useBattleShout'];
		v35 = EpicSettings.Settings['useCharge'];
		v36 = EpicSettings.Settings['useDemoralizingShout'];
		v37 = EpicSettings.Settings['useDevastate'];
		v38 = EpicSettings.Settings['useExecute'];
		v39 = EpicSettings.Settings['useHeroicThrow'];
		v41 = EpicSettings.Settings['useRevenge'];
		v43 = EpicSettings.Settings['useShieldSlam'];
		v44 = EpicSettings.Settings['useShockwave'];
		v46 = EpicSettings.Settings['useThunderClap'];
		v48 = EpicSettings.Settings['useWreckingThrow'];
		v33 = EpicSettings.Settings['useAvatar'];
		v40 = EpicSettings.Settings['useRavager'];
		v42 = EpicSettings.Settings['useShieldCharge'];
		v45 = EpicSettings.Settings['useChampionsSpear'];
		v47 = EpicSettings.Settings['useThunderousRoar'];
		v51 = EpicSettings.Settings['avatarWithCD'];
		v52 = EpicSettings.Settings['ravagerWithCD'];
		v53 = EpicSettings.Settings['shieldChargeWithCD'];
		v54 = EpicSettings.Settings['championsSpearWithCD'];
		v55 = EpicSettings.Settings['thunderousRoarWithCD'];
	end
	local function v116()
		v58 = EpicSettings.Settings['usePummel'];
		v59 = EpicSettings.Settings['useStormBolt'];
		v60 = EpicSettings.Settings['useIntimidatingShout'];
		v61 = EpicSettings.Settings['useBitterImmunity'];
		v65 = EpicSettings.Settings['useIgnorePain'];
		v67 = EpicSettings.Settings['useIntervene'];
		v64 = EpicSettings.Settings['useLastStand'];
		v66 = EpicSettings.Settings['useRallyingCry'];
		v63 = EpicSettings.Settings['useShieldBlock'];
		v62 = EpicSettings.Settings['useShieldWall'];
		v70 = EpicSettings.Settings['useVictoryRush'];
		v93 = EpicSettings.Settings['useChangeStance'];
		v71 = EpicSettings.Settings['bitterImmunityHP'] or (454 - (233 + 221));
		v75 = EpicSettings.Settings['ignorePainHP'] or (0 - 0);
		v78 = EpicSettings.Settings['interveneHP'] or (0 + 0);
		v74 = EpicSettings.Settings['lastStandHP'] or (1541 - (718 + 823));
		v77 = EpicSettings.Settings['rallyingCryGroup'] or (0 + 0);
		v76 = EpicSettings.Settings['rallyingCryHP'] or (805 - (266 + 539));
		v73 = EpicSettings.Settings['shieldBlockHP'] or (0 - 0);
		v72 = EpicSettings.Settings['shieldWallHP'] or (1225 - (636 + 589));
		v82 = EpicSettings.Settings['victoryRushHP'] or (0 - 0);
		v79 = EpicSettings.Settings['defensiveStanceHP'] or (0 - 0);
		v83 = EpicSettings.Settings['ravagerSetting'] or "";
		v84 = EpicSettings.Settings['spearSetting'] or "";
	end
	local function v117()
		local v166 = 0 + 0;
		while true do
			if ((v166 == (1 + 0)) or ((2658 - (657 + 358)) > (8946 - 5567))) then
				v49 = EpicSettings.Settings['useTrinkets'];
				v50 = EpicSettings.Settings['useRacials'];
				v56 = EpicSettings.Settings['trinketsWithCD'];
				v57 = EpicSettings.Settings['racialsWithCD'];
				v166 = 4 - 2;
			end
			if ((v166 == (1187 - (1151 + 36))) or ((2707 + 96) > (1196 + 3353))) then
				v90 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v87 = EpicSettings.Settings['InterruptWithStun'];
				v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v89 = EpicSettings.Settings['InterruptThreshold'];
				v166 = 1833 - (1552 + 280);
			end
			if ((v166 == (837 - (64 + 770))) or ((150 + 70) >= (6859 - 3837))) then
				v86 = EpicSettings.Settings['HealingPotionName'] or "";
				v85 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((502 + 2320) == (4065 - (157 + 1086))) and ((3 - 1) == v166)) then
				v68 = EpicSettings.Settings['useHealthstone'];
				v69 = EpicSettings.Settings['useHealingPotion'];
				v80 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v81 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v166 = 3 - 0;
			end
		end
	end
	local function v118()
		local v167 = 819 - (599 + 220);
		while true do
			if ((v167 == (0 - 0)) or ((2992 - (1813 + 118)) == (1358 + 499))) then
				v116();
				v115();
				v117();
				v29 = EpicSettings.Toggles['ooc'];
				v167 = 1218 - (841 + 376);
			end
			if (((3867 - 1107) > (317 + 1047)) and ((5 - 3) == v167)) then
				v99 = v14:IsInMeleeRange(867 - (464 + 395));
				if (v94.TargetIsValid() or v13:AffectingCombat() or ((12580 - 7678) <= (1727 + 1868))) then
					v91 = v10.BossFightRemains(nil, true);
					v92 = v91;
					if ((v92 == (11948 - (467 + 370))) or ((7959 - 4107) == (216 + 77))) then
						v92 = v10.FightRemains(v100, false);
					end
				end
				if (not v13:IsChanneling() or ((5344 - 3785) == (716 + 3872))) then
					if (v13:AffectingCombat() or ((10431 - 5947) == (1308 - (150 + 370)))) then
						local v199 = 1282 - (74 + 1208);
						while true do
							if (((11235 - 6667) >= (18529 - 14622)) and (v199 == (0 + 0))) then
								v28 = v114();
								if (((1636 - (14 + 376)) < (6018 - 2548)) and v28) then
									return v28;
								end
								break;
							end
						end
					else
						local v200 = 0 + 0;
						while true do
							if (((3574 + 494) >= (928 + 44)) and (v200 == (0 - 0))) then
								v28 = v113();
								if (((371 + 122) < (3971 - (23 + 55))) and v28) then
									return v28;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((2 - 1) == v167) or ((983 + 490) >= (2993 + 339))) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				if (v13:IsDeadOrGhost() or ((6280 - 2229) <= (364 + 793))) then
					return v28;
				end
				if (((1505 - (652 + 249)) < (7709 - 4828)) and v30) then
					v100 = v13:GetEnemiesInMeleeRange(1876 - (708 + 1160));
					v101 = #v100;
				else
					v101 = 2 - 1;
				end
				v167 = 3 - 1;
			end
		end
	end
	local function v119()
		v19.Print("Protection Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(100 - (10 + 17), v118, v119);
end;
return v0["Epix_Warrior_Protection.lua"]();

