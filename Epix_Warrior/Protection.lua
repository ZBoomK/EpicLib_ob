local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1555 - (991 + 564);
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((4779 - (1381 + 178)) == (1280 + 84))) then
			v6 = v0[v4];
			if (not v6 or ((850 + 204) > (1447 + 1945))) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
		end
		if ((v5 == (1 + 0)) or ((1146 - (381 + 89)) >= (1457 + 185))) then
			return v6(...);
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
	local v90 = 7515 + 3596;
	local v91 = 19032 - 7921;
	local v92;
	local v93 = v19.Commons.Everyone;
	local v94 = v17.Warrior.Protection;
	local v95 = v18.Warrior.Protection;
	local v96 = v22.Warrior.Protection;
	local v97 = {};
	local v98;
	local v99;
	local v100;
	local function v101()
		local v119 = 1156 - (1074 + 82);
		local v120;
		while true do
			if (((9063 - 4927) > (4181 - (214 + 1570))) and (v119 == (1455 - (990 + 465)))) then
				v120 = UnitGetTotalAbsorbs(v14);
				if ((v120 > (0 + 0)) or ((1886 + 2448) == (4129 + 116))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v102()
		return v13:IsTankingAoE(62 - 46) or v13:IsTanking(v14) or v14:IsDummy();
	end
	local function v103()
		if (v13:BuffUp(v94.IgnorePain) or ((6002 - (1668 + 58)) <= (3657 - (512 + 114)))) then
			local v144 = 0 - 0;
			local v145;
			local v146;
			local v147;
			while true do
				if (((1 - 0) == v144) or ((16639 - 11857) <= (558 + 641))) then
					v147 = v146.points[1 + 0];
					return v147 < v145;
				end
				if ((v144 == (0 + 0)) or ((16405 - 11541) < (3896 - (109 + 1885)))) then
					v145 = v13:AttackPowerDamageMod() * (1472.5 - (1269 + 200)) * ((1 - 0) + (v13:VersatilityDmgPct() / (915 - (98 + 717))));
					v146 = v13:AuraInfo(v94.IgnorePain, nil, true);
					v144 = 827 - (802 + 24);
				end
			end
		else
			return true;
		end
	end
	local function v104()
		if (((8344 - 3505) >= (4672 - 972)) and v13:BuffUp(v94.IgnorePain)) then
			local v148 = v13:BuffInfo(v94.IgnorePain, nil, true);
			return v148.points[1 + 0];
		else
			return 0 + 0;
		end
	end
	local function v105()
		return v102() and v94.ShieldBlock:IsReady() and (((v13:BuffRemains(v94.ShieldBlockBuff) <= (3 + 15)) and v94.EnduringDefenses:IsAvailable()) or (v13:BuffRemains(v94.ShieldBlockBuff) <= (3 + 9)));
	end
	local function v106(v121)
		local v122 = 222 - 142;
		if ((v122 < (116 - 81)) or (v13:Rage() < (13 + 22)) or ((438 + 637) > (1583 + 335))) then
			return false;
		end
		local v123 = false;
		local v124 = (v13:Rage() >= (26 + 9)) and not v105();
		if (((185 + 211) <= (5237 - (797 + 636))) and v124 and (((v13:Rage() + v121) >= v122) or v94.DemoralizingShout:IsReady())) then
			v123 = true;
		end
		if (v123 or ((20241 - 16072) == (3806 - (1427 + 192)))) then
			if (((488 + 918) == (3264 - 1858)) and v102() and v103()) then
				if (((1377 + 154) < (1936 + 2335)) and v23(v94.IgnorePain, nil, nil, true)) then
					return "ignore_pain rage capped";
				end
			elseif (((961 - (192 + 134)) == (1911 - (316 + 960))) and v23(v94.Revenge, not v98)) then
				return "revenge rage capped";
			end
		end
	end
	local function v107()
		if (((1878 + 1495) <= (2745 + 811)) and v94.BitterImmunity:IsReady() and v60 and (v13:HealthPercentage() <= v70)) then
			if (v23(v94.BitterImmunity) or ((3042 + 249) < (12539 - 9259))) then
				return "bitter_immunity defensive";
			end
		end
		if (((4937 - (83 + 468)) >= (2679 - (1202 + 604))) and v94.LastStand:IsCastable() and v63 and ((v13:HealthPercentage() <= v73) or v13:ActiveMitigationNeeded())) then
			if (((4299 - 3378) <= (1833 - 731)) and v23(v94.LastStand)) then
				return "last_stand defensive";
			end
		end
		if (((13029 - 8323) >= (1288 - (45 + 280))) and v94.IgnorePain:IsReady() and v64 and (v13:HealthPercentage() <= v74) and v103()) then
			if (v23(v94.IgnorePain, nil, nil, true) or ((927 + 33) <= (766 + 110))) then
				return "ignore_pain defensive";
			end
		end
		if ((v94.RallyingCry:IsReady() and v65 and v13:BuffDown(v94.AspectsFavorBuff) and v13:BuffDown(v94.RallyingCry) and (((v13:HealthPercentage() <= v75) and v93.IsSoloMode()) or v93.AreUnitsBelowHealthPercentage(v75, v76))) or ((755 + 1311) == (516 + 416))) then
			if (((849 + 3976) < (8967 - 4124)) and v23(v94.RallyingCry)) then
				return "rallying_cry defensive";
			end
		end
		if ((v94.Intervene:IsReady() and v66 and (v16:HealthPercentage() <= v77) and (v16:UnitName() ~= v13:UnitName())) or ((5788 - (340 + 1571)) >= (1790 + 2747))) then
			if (v23(v96.InterveneFocus) or ((6087 - (1733 + 39)) < (4742 - 3016))) then
				return "intervene defensive";
			end
		end
		if ((v94.ShieldWall:IsCastable() and v61 and v13:BuffDown(v94.ShieldWallBuff) and ((v13:HealthPercentage() <= v71) or v13:ActiveMitigationNeeded())) or ((4713 - (125 + 909)) < (2573 - (1096 + 852)))) then
			if (v23(v94.ShieldWall) or ((2075 + 2550) < (902 - 270))) then
				return "shield_wall defensive";
			end
		end
		if ((v95.Healthstone:IsReady() and v67 and (v13:HealthPercentage() <= v79)) or ((81 + 2) > (2292 - (409 + 103)))) then
			if (((782 - (46 + 190)) <= (1172 - (51 + 44))) and v23(v96.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if ((v68 and (v13:HealthPercentage() <= v80)) or ((281 + 715) > (5618 - (1114 + 203)))) then
			if (((4796 - (228 + 498)) > (149 + 538)) and (v85 == "Refreshing Healing Potion")) then
				if (v95.RefreshingHealingPotion:IsReady() or ((363 + 293) >= (3993 - (174 + 489)))) then
					if (v23(v96.RefreshingHealingPotion) or ((6492 - 4000) <= (2240 - (830 + 1075)))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if (((4846 - (303 + 221)) >= (3831 - (231 + 1038))) and (v85 == "Dreamwalker's Healing Potion")) then
				if (v95.DreamwalkersHealingPotion:IsReady() or ((3031 + 606) >= (4932 - (171 + 991)))) then
					if (v23(v96.RefreshingHealingPotion) or ((9804 - 7425) > (12292 - 7714))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v108()
		v28 = v93.HandleTopTrinket(v97, v31, 99 - 59, nil);
		if (v28 or ((387 + 96) > (2604 - 1861))) then
			return v28;
		end
		v28 = v93.HandleBottomTrinket(v97, v31, 115 - 75, nil);
		if (((3955 - 1501) > (1786 - 1208)) and v28) then
			return v28;
		end
	end
	local function v109()
		if (((2178 - (111 + 1137)) < (4616 - (91 + 67))) and v14:IsInMeleeRange(23 - 15)) then
			if (((166 + 496) <= (1495 - (423 + 100))) and v94.ThunderClap:IsCastable() and v45) then
				if (((31 + 4339) == (12099 - 7729)) and v23(v94.ThunderClap)) then
					return "thunder_clap precombat";
				end
			end
		elseif ((v34 and v94.Charge:IsCastable() and not v14:IsInRange(5 + 3)) or ((5533 - (326 + 445)) <= (3757 - 2896))) then
			if (v23(v94.Charge, not v14:IsSpellInRange(v94.Charge)) or ((3145 - 1733) == (9953 - 5689))) then
				return "charge precombat";
			end
		end
	end
	local function v110()
		local v125 = 711 - (530 + 181);
		while true do
			if ((v125 == (882 - (614 + 267))) or ((3200 - (19 + 13)) < (3503 - 1350))) then
				if ((v94.ThunderClap:IsCastable() and v45 and v13:BuffUp(v94.ViolentOutburstBuff) and (v100 > (11 - 6)) and v13:BuffUp(v94.AvatarBuff) and v94.UnstoppableForce:IsAvailable()) or ((14214 - 9238) < (346 + 986))) then
					v106(8 - 3);
					if (((9597 - 4969) == (6440 - (1293 + 519))) and v23(v94.ThunderClap, not v14:IsInMeleeRange(16 - 8))) then
						return "thunder_clap aoe 4";
					end
				end
				if ((v94.Revenge:IsReady() and v40 and (v13:Rage() >= (182 - 112)) and v94.SeismicReverberation:IsAvailable() and (v100 >= (5 - 2))) or ((232 - 178) == (930 - 535))) then
					if (((44 + 38) == (17 + 65)) and v23(v94.Revenge, not v98)) then
						return "revenge aoe 6";
					end
				end
				v125 = 4 - 2;
			end
			if ((v125 == (0 + 0)) or ((194 + 387) < (177 + 105))) then
				if ((v94.ThunderClap:IsCastable() and v45 and (v14:DebuffRemains(v94.RendDebuff) <= (1097 - (709 + 387)))) or ((6467 - (673 + 1185)) < (7235 - 4740))) then
					local v189 = 0 - 0;
					while true do
						if (((1894 - 742) == (824 + 328)) and (v189 == (0 + 0))) then
							v106(6 - 1);
							if (((466 + 1430) <= (6822 - 3400)) and v23(v94.ThunderClap, not v14:IsInMeleeRange(15 - 7))) then
								return "thunder_clap aoe 2";
							end
							break;
						end
					end
				end
				if ((v94.ShieldSlam:IsCastable() and v42 and ((v13:HasTier(1910 - (446 + 1434), 1285 - (1040 + 243)) and (v100 <= (20 - 13))) or v13:BuffUp(v94.EarthenTenacityBuff))) or ((2837 - (559 + 1288)) > (3551 - (609 + 1322)))) then
					if (v23(v94.ShieldSlam, not v98) or ((1331 - (13 + 441)) > (17544 - 12849))) then
						return "shield_slam aoe 3";
					end
				end
				v125 = 2 - 1;
			end
			if (((13402 - 10711) >= (69 + 1782)) and (v125 == (10 - 7))) then
				if ((v94.Revenge:IsReady() and v40 and ((v13:Rage() >= (11 + 19)) or ((v13:Rage() >= (18 + 22)) and v94.BarbaricTraining:IsAvailable()))) or ((8858 - 5873) >= (2658 + 2198))) then
					if (((7863 - 3587) >= (791 + 404)) and v23(v94.Revenge, not v98)) then
						return "revenge aoe 12";
					end
				end
				break;
			end
			if (((1798 + 1434) <= (3370 + 1320)) and (v125 == (2 + 0))) then
				if ((v94.ShieldSlam:IsCastable() and v42 and ((v13:Rage() <= (59 + 1)) or (v13:BuffUp(v94.ViolentOutburstBuff) and (v100 <= (440 - (153 + 280)))))) or ((2587 - 1691) >= (2825 + 321))) then
					local v190 = 0 + 0;
					while true do
						if (((1602 + 1459) >= (2685 + 273)) and (v190 == (0 + 0))) then
							v106(30 - 10);
							if (((1970 + 1217) >= (1311 - (89 + 578))) and v23(v94.ShieldSlam, not v98)) then
								return "shield_slam aoe 8";
							end
							break;
						end
					end
				end
				if (((461 + 183) <= (1463 - 759)) and v94.ThunderClap:IsCastable() and v45) then
					local v191 = 1049 - (572 + 477);
					while true do
						if (((130 + 828) > (569 + 378)) and ((0 + 0) == v191)) then
							v106(91 - (84 + 2));
							if (((7402 - 2910) >= (1912 + 742)) and v23(v94.ThunderClap, not v14:IsInMeleeRange(850 - (497 + 345)))) then
								return "thunder_clap aoe 10";
							end
							break;
						end
					end
				end
				v125 = 1 + 2;
			end
		end
	end
	local function v111()
		if (((582 + 2860) >= (2836 - (605 + 728))) and v94.ShieldSlam:IsCastable() and v42) then
			local v149 = 0 + 0;
			while true do
				if ((v149 == (0 - 0)) or ((146 + 3024) <= (5412 - 3948))) then
					v106(19 + 1);
					if (v23(v94.ShieldSlam, not v98) or ((13290 - 8493) == (3314 + 1074))) then
						return "shield_slam generic 2";
					end
					break;
				end
			end
		end
		if (((1040 - (457 + 32)) <= (289 + 392)) and v94.ThunderClap:IsCastable() and v45 and (v14:DebuffRemains(v94.RendDebuff) <= (1403 - (832 + 570))) and v13:BuffDown(v94.ViolentOutburstBuff)) then
			local v150 = 0 + 0;
			while true do
				if (((855 + 2422) > (1439 - 1032)) and (v150 == (0 + 0))) then
					v106(801 - (588 + 208));
					if (((12654 - 7959) >= (3215 - (884 + 916))) and v23(v94.ThunderClap, not v14:IsInMeleeRange(16 - 8))) then
						return "thunder_clap generic 4";
					end
					break;
				end
			end
		end
		if ((v94.Execute:IsReady() and v37 and v13:BuffUp(v94.SuddenDeathBuff) and v94.SuddenDeath:IsAvailable()) or ((1863 + 1349) <= (1597 - (232 + 421)))) then
			if (v23(v94.Execute, not v98) or ((4985 - (1569 + 320)) <= (442 + 1356))) then
				return "execute generic 6";
			end
		end
		if (((672 + 2865) == (11918 - 8381)) and v94.Execute:IsReady() and v37 and (v100 == (606 - (316 + 289))) and (v94.Massacre:IsAvailable() or v94.Juggernaut:IsAvailable()) and (v13:Rage() >= (130 - 80))) then
			if (((178 + 3659) >= (3023 - (666 + 787))) and v23(v94.Execute, not v98)) then
				return "execute generic 6";
			end
		end
		if ((v94.Execute:IsReady() and v37 and (v100 == (426 - (360 + 65))) and (v13:Rage() >= (47 + 3))) or ((3204 - (79 + 175)) == (6010 - 2198))) then
			if (((3686 + 1037) >= (7105 - 4787)) and v23(v94.Execute, not v98)) then
				return "execute generic 10";
			end
		end
		if ((v94.ThunderClap:IsCastable() and v45 and ((v100 > (1 - 0)) or (v94.ShieldSlam:CooldownDown() and not v13:BuffUp(v94.ViolentOutburstBuff)))) or ((2926 - (503 + 396)) > (3033 - (92 + 89)))) then
			local v151 = 0 - 0;
			while true do
				if ((v151 == (0 + 0)) or ((673 + 463) > (16905 - 12588))) then
					v106(1 + 4);
					if (((10825 - 6077) == (4143 + 605)) and v23(v94.ThunderClap, not v14:IsInMeleeRange(4 + 4))) then
						return "thunder_clap generic 12";
					end
					break;
				end
			end
		end
		if (((11378 - 7642) <= (592 + 4148)) and v94.Revenge:IsReady() and v40 and (((v13:Rage() >= (91 - 31)) and (v14:HealthPercentage() > (1264 - (485 + 759)))) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() <= (46 - 26)) and (v13:Rage() <= (1207 - (442 + 747))) and v94.ShieldSlam:CooldownDown()) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() > (1155 - (832 + 303)))) or ((((v13:Rage() >= (1006 - (88 + 858))) and (v14:HealthPercentage() > (11 + 24))) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() <= (29 + 6)) and (v13:Rage() <= (1 + 17)) and v94.ShieldSlam:CooldownDown()) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() > (824 - (766 + 23))))) and v94.Massacre:IsAvailable()))) then
			if (v23(v94.Revenge, not v98) or ((16735 - 13345) <= (4185 - 1125))) then
				return "revenge generic 14";
			end
		end
		if ((v94.Execute:IsReady() and v37 and (v100 == (2 - 1))) or ((3390 - 2391) > (3766 - (1036 + 37)))) then
			if (((329 + 134) < (1170 - 569)) and v23(v94.Execute, not v98)) then
				return "execute generic 16";
			end
		end
		if ((v94.Revenge:IsReady() and v40 and (v14:HealthPercentage() > (16 + 4))) or ((3663 - (641 + 839)) < (1600 - (910 + 3)))) then
			if (((11596 - 7047) == (6233 - (1466 + 218))) and v23(v94.Revenge, not v98)) then
				return "revenge generic 18";
			end
		end
		if (((2148 + 2524) == (5820 - (556 + 592))) and v94.ThunderClap:IsCastable() and v45 and ((v100 >= (1 + 0)) or (v94.ShieldSlam:CooldownDown() and v13:BuffUp(v94.ViolentOutburstBuff)))) then
			local v152 = 808 - (329 + 479);
			while true do
				if ((v152 == (854 - (174 + 680))) or ((12603 - 8935) < (818 - 423))) then
					v106(4 + 1);
					if (v23(v94.ThunderClap, not v14:IsInMeleeRange(747 - (396 + 343))) or ((369 + 3797) == (1932 - (29 + 1448)))) then
						return "thunder_clap generic 20";
					end
					break;
				end
			end
		end
		if ((v94.Devastate:IsCastable() and v36) or ((5838 - (135 + 1254)) == (10032 - 7369))) then
			if (v23(v94.Devastate, not v98) or ((19969 - 15692) < (1992 + 997))) then
				return "devastate generic 22";
			end
		end
	end
	local function v112()
		local v126 = 1527 - (389 + 1138);
		while true do
			if ((v126 == (574 - (102 + 472))) or ((822 + 48) >= (2301 + 1848))) then
				if (((2063 + 149) < (4728 - (320 + 1225))) and not v13:AffectingCombat()) then
					local v192 = 0 - 0;
					while true do
						if (((2843 + 1803) > (4456 - (157 + 1307))) and (v192 == (1859 - (821 + 1038)))) then
							if (((3577 - 2143) < (340 + 2766)) and v94.BattleShout:IsCastable() and v33 and (v13:BuffDown(v94.BattleShoutBuff, true) or v93.GroupBuffMissing(v94.BattleShoutBuff))) then
								if (((1395 - 609) < (1125 + 1898)) and v23(v94.BattleShout)) then
									return "battle_shout precombat";
								end
							end
							if ((v92 and v94.BattleStance:IsCastable() and not v13:BuffUp(v94.BattleStance)) or ((6052 - 3610) < (1100 - (834 + 192)))) then
								if (((289 + 4246) == (1165 + 3370)) and v23(v94.BattleStance)) then
									return "battle_stance precombat";
								end
							end
							break;
						end
					end
				end
				if ((v93.TargetIsValid() and v29) or ((65 + 2944) <= (3261 - 1156))) then
					if (((2134 - (300 + 4)) < (980 + 2689)) and not v13:AffectingCombat()) then
						local v195 = 0 - 0;
						while true do
							if ((v195 == (362 - (112 + 250))) or ((571 + 859) >= (9048 - 5436))) then
								v28 = v109();
								if (((1538 + 1145) >= (1273 + 1187)) and v28) then
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
	local function v113()
		local v127 = 0 + 0;
		while true do
			if ((v127 == (1 + 0)) or ((1341 + 463) >= (4689 - (1001 + 413)))) then
				if (v84 or ((3159 - 1742) > (4511 - (244 + 638)))) then
					v28 = v93.HandleIncorporeal(v94.StormBolt, v96.StormBoltMouseover, 713 - (627 + 66), true);
					if (((14287 - 9492) > (1004 - (512 + 90))) and v28) then
						return v28;
					end
					v28 = v93.HandleIncorporeal(v94.IntimidatingShout, v96.IntimidatingShoutMouseover, 1914 - (1665 + 241), true);
					if (((5530 - (373 + 344)) > (1608 + 1957)) and v28) then
						return v28;
					end
				end
				if (((1036 + 2876) == (10318 - 6406)) and v93.TargetIsValid()) then
					local v193 = 0 - 0;
					local v194;
					while true do
						if (((3920 - (35 + 1064)) <= (3510 + 1314)) and ((12 - 6) == v193)) then
							v28 = v111();
							if (((7 + 1731) <= (3431 - (298 + 938))) and v28) then
								return v28;
							end
							if (((1300 - (233 + 1026)) <= (4684 - (636 + 1030))) and v19.CastAnnotated(v94.Pool, false, "WAIT")) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((1097 + 1048) <= (4009 + 95)) and (v193 == (0 + 0))) then
							if (((182 + 2507) < (5066 - (55 + 166))) and v92 and (v13:HealthPercentage() <= v78)) then
								if ((v94.DefensiveStance:IsCastable() and not v13:BuffUp(v94.DefensiveStance)) or ((450 + 1872) > (264 + 2358))) then
									if (v23(v94.DefensiveStance) or ((17315 - 12781) == (2379 - (36 + 261)))) then
										return "defensive_stance while tanking";
									end
								end
							end
							if ((v92 and (v13:HealthPercentage() > v78)) or ((2747 - 1176) > (3235 - (34 + 1334)))) then
								if ((v94.BattleStance:IsCastable() and not v13:BuffUp(v94.BattleStance)) or ((1021 + 1633) >= (2328 + 668))) then
									if (((5261 - (1035 + 248)) > (2125 - (20 + 1))) and v23(v94.BattleStance)) then
										return "battle_stance while not tanking";
									end
								end
							end
							if (((1561 + 1434) > (1860 - (134 + 185))) and v41 and ((v52 and v31) or not v52) and (v89 < v91) and v94.ShieldCharge:IsCastable() and not v98) then
								if (((4382 - (549 + 584)) > (1638 - (314 + 371))) and v23(v94.ShieldCharge, not v14:IsSpellInRange(v94.ShieldCharge))) then
									return "shield_charge main 34";
								end
							end
							if ((v34 and v94.Charge:IsCastable() and not v98) or ((11235 - 7962) > (5541 - (478 + 490)))) then
								if (v23(v94.Charge, not v14:IsSpellInRange(v94.Charge)) or ((1670 + 1481) < (2456 - (786 + 386)))) then
									return "charge main 34";
								end
							end
							v193 = 3 - 2;
						end
						if ((v193 == (1382 - (1055 + 324))) or ((3190 - (1093 + 247)) == (1359 + 170))) then
							if (((87 + 734) < (8428 - 6305)) and v102() and v63 and v94.LastStand:IsCastable() and v13:BuffDown(v94.ShieldWallBuff) and (((v14:HealthPercentage() >= (305 - 215)) and v94.UnnervingFocus:IsAvailable()) or ((v14:HealthPercentage() <= (56 - 36)) and v94.UnnervingFocus:IsAvailable()) or v94.Bolster:IsAvailable() or v13:HasTier(75 - 45, 1 + 1))) then
								if (((3474 - 2572) < (8013 - 5688)) and v23(v94.LastStand)) then
									return "last_stand defensive";
								end
							end
							if (((647 + 211) <= (7574 - 4612)) and (v89 < v91) and v39 and ((v51 and v31) or not v51) and (v82 == "player") and v94.Ravager:IsCastable()) then
								local v196 = 688 - (364 + 324);
								while true do
									if ((v196 == (0 - 0)) or ((9468 - 5522) < (427 + 861))) then
										v106(41 - 31);
										if (v23(v96.RavagerPlayer, not v98) or ((5191 - 1949) == (1721 - 1154))) then
											return "ravager main 24";
										end
										break;
									end
								end
							end
							if (((v89 < v91) and v39 and ((v51 and v31) or not v51) and (v82 == "cursor") and v94.Ravager:IsCastable()) or ((2115 - (1249 + 19)) >= (1141 + 122))) then
								local v197 = 0 - 0;
								while true do
									if ((v197 == (1086 - (686 + 400))) or ((1768 + 485) == (2080 - (73 + 156)))) then
										v106(1 + 9);
										if (v23(v96.RavagerCursor, not v98) or ((2898 - (721 + 90)) > (27 + 2345))) then
											return "ravager main 24";
										end
										break;
									end
								end
							end
							if ((v94.DemoralizingShout:IsCastable() and v35 and v94.BoomingVoice:IsAvailable()) or ((14432 - 9987) < (4619 - (224 + 246)))) then
								local v198 = 0 - 0;
								while true do
									if ((v198 == (0 - 0)) or ((330 + 1488) == (3 + 82))) then
										v106(23 + 7);
										if (((1252 - 622) < (7078 - 4951)) and v23(v94.DemoralizingShout, not v98)) then
											return "demoralizing_shout main 28";
										end
										break;
									end
								end
							end
							v193 = 517 - (203 + 310);
						end
						if ((v193 == (1998 - (1238 + 755))) or ((136 + 1802) == (4048 - (709 + 825)))) then
							if (((7840 - 3585) >= (79 - 24)) and ((v94.Shockwave:IsCastable() and v43 and v13:BuffUp(v94.AvatarBuff) and v94.UnstoppableForce:IsAvailable() and not v94.RumblingEarth:IsAvailable()) or (v94.SonicBoom:IsAvailable() and v94.RumblingEarth:IsAvailable() and (v100 >= (867 - (196 + 668))) and v14:IsCasting()))) then
								v106(39 - 29);
								if (((6211 - 3212) > (1989 - (171 + 662))) and v23(v94.Shockwave, not v14:IsInMeleeRange(101 - (4 + 89)))) then
									return "shockwave main 32";
								end
							end
							if (((8236 - 5886) > (421 + 734)) and (v89 < v91) and v94.ShieldCharge:IsCastable() and v41 and ((v52 and v31) or not v52)) then
								if (((17696 - 13667) <= (1904 + 2949)) and v23(v94.ShieldCharge, not v14:IsSpellInRange(v94.ShieldCharge))) then
									return "shield_charge main 34";
								end
							end
							if ((v105() and v62) or ((2002 - (35 + 1451)) > (4887 - (28 + 1425)))) then
								if (((6039 - (941 + 1052)) >= (2909 + 124)) and v23(v94.ShieldBlock)) then
									return "shield_block main 38";
								end
							end
							if ((v100 > (1517 - (822 + 692))) or ((3881 - 1162) <= (682 + 765))) then
								local v199 = 297 - (45 + 252);
								while true do
									if ((v199 == (1 + 0)) or ((1423 + 2711) < (9554 - 5628))) then
										if (v19.CastAnnotated(v94.Pool, false, "WAIT") or ((597 - (114 + 319)) >= (3998 - 1213))) then
											return "Pool for Aoe()";
										end
										break;
									end
									if ((v199 == (0 - 0)) or ((335 + 190) == (3141 - 1032))) then
										v28 = v110();
										if (((68 - 35) == (1996 - (556 + 1407))) and v28) then
											return v28;
										end
										v199 = 1207 - (741 + 465);
									end
								end
							end
							v193 = 471 - (170 + 295);
						end
						if (((1610 + 1444) <= (3688 + 327)) and (v193 == (2 - 1))) then
							if (((1551 + 320) < (2169 + 1213)) and (v89 < v91)) then
								if (((733 + 560) <= (3396 - (957 + 273))) and v48 and ((v31 and v55) or not v55)) then
									local v201 = 0 + 0;
									while true do
										if ((v201 == (0 + 0)) or ((9827 - 7248) < (324 - 201))) then
											v28 = v108();
											if (v28 or ((2583 - 1737) >= (11725 - 9357))) then
												return v28;
											end
											break;
										end
									end
								end
							end
							if ((v38 and v94.HeroicThrow:IsCastable() and not v14:IsInRange(1810 - (389 + 1391))) or ((2518 + 1494) <= (350 + 3008))) then
								if (((3400 - 1906) <= (3956 - (783 + 168))) and v23(v94.HeroicThrow, not v14:IsInRange(100 - 70))) then
									return "heroic_throw main";
								end
							end
							if ((v94.WreckingThrow:IsCastable() and v47 and v14:AffectingCombat() and v101()) or ((3061 + 50) == (2445 - (309 + 2)))) then
								if (((7231 - 4876) == (3567 - (1090 + 122))) and v23(v94.WreckingThrow, not v14:IsInRange(10 + 20))) then
									return "wrecking_throw main";
								end
							end
							if (((v89 < v91) and v32 and ((v50 and v31) or not v50) and v94.Avatar:IsCastable()) or ((1974 - 1386) <= (296 + 136))) then
								if (((5915 - (628 + 490)) >= (699 + 3196)) and v23(v94.Avatar)) then
									return "avatar main 2";
								end
							end
							v193 = 4 - 2;
						end
						if (((16346 - 12769) == (4351 - (431 + 343))) and (v193 == (3 - 1))) then
							if (((10975 - 7181) > (2918 + 775)) and (v89 < v91) and v49 and ((v56 and v31) or not v56)) then
								local v200 = 0 + 0;
								while true do
									if ((v200 == (1696 - (556 + 1139))) or ((1290 - (6 + 9)) == (751 + 3349))) then
										if (v94.ArcaneTorrent:IsCastable() or ((816 + 775) >= (3749 - (28 + 141)))) then
											if (((381 + 602) <= (2231 - 423)) and v23(v94.ArcaneTorrent)) then
												return "arcane_torrent main 8";
											end
										end
										if (v94.LightsJudgment:IsCastable() or ((1523 + 627) <= (2514 - (486 + 831)))) then
											if (((9807 - 6038) >= (4129 - 2956)) and v23(v94.LightsJudgment)) then
												return "lights_judgment main 10";
											end
										end
										v200 = 1 + 1;
									end
									if (((4695 - 3210) == (2748 - (668 + 595))) and (v200 == (2 + 0))) then
										if (v94.Fireblood:IsCastable() or ((669 + 2646) <= (7586 - 4804))) then
											if (v23(v94.Fireblood) or ((1166 - (23 + 267)) >= (4908 - (1129 + 815)))) then
												return "fireblood main 12";
											end
										end
										if (v94.AncestralCall:IsCastable() or ((2619 - (371 + 16)) > (4247 - (1326 + 424)))) then
											if (v23(v94.AncestralCall) or ((3996 - 1886) <= (1213 - 881))) then
												return "ancestral_call main 14";
											end
										end
										v200 = 121 - (88 + 30);
									end
									if (((4457 - (720 + 51)) > (7055 - 3883)) and (v200 == (1779 - (421 + 1355)))) then
										if (v94.BagofTricks:IsCastable() or ((7380 - 2906) < (403 + 417))) then
											if (((5362 - (286 + 797)) >= (10535 - 7653)) and v23(v94.BagofTricks)) then
												return "ancestral_call main 16";
											end
										end
										break;
									end
									if ((v200 == (0 - 0)) or ((2468 - (397 + 42)) >= (1100 + 2421))) then
										if (v94.BloodFury:IsCastable() or ((2837 - (24 + 776)) >= (7150 - 2508))) then
											if (((2505 - (222 + 563)) < (9822 - 5364)) and v23(v94.BloodFury)) then
												return "blood_fury main 4";
											end
										end
										if (v94.Berserking:IsCastable() or ((314 + 122) > (3211 - (23 + 167)))) then
											if (((2511 - (690 + 1108)) <= (306 + 541)) and v23(v94.Berserking)) then
												return "berserking main 6";
											end
										end
										v200 = 1 + 0;
									end
								end
							end
							v194 = v93.HandleDPSPotion(v14:BuffUp(v94.AvatarBuff));
							if (((3002 - (40 + 808)) <= (664 + 3367)) and v194) then
								return v194;
							end
							if (((17647 - 13032) == (4411 + 204)) and v94.IgnorePain:IsReady() and v64 and v103() and (v14:HealthPercentage() >= (11 + 9)) and (((v13:RageDeficit() <= (9 + 6)) and v94.ShieldSlam:CooldownUp()) or ((v13:RageDeficit() <= (611 - (47 + 524))) and v94.ShieldCharge:CooldownUp() and v94.ChampionsBulwark:IsAvailable()) or ((v13:RageDeficit() <= (13 + 7)) and v94.ShieldCharge:CooldownUp()) or ((v13:RageDeficit() <= (82 - 52)) and v94.DemoralizingShout:CooldownUp() and v94.BoomingVoice:IsAvailable()) or ((v13:RageDeficit() <= (29 - 9)) and v94.Avatar:CooldownUp()) or ((v13:RageDeficit() <= (102 - 57)) and v94.DemoralizingShout:CooldownUp() and v94.BoomingVoice:IsAvailable() and v13:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable()) or ((v13:RageDeficit() <= (1756 - (1165 + 561))) and v94.Avatar:CooldownUp() and v13:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable()) or (v13:RageDeficit() <= (1 + 19)) or ((v13:RageDeficit() <= (123 - 83)) and v94.ShieldSlam:CooldownUp() and v13:BuffUp(v94.ViolentOutburstBuff) and v94.HeavyRepercussions:IsAvailable() and v94.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (21 + 34)) and v94.ShieldSlam:CooldownUp() and v13:BuffUp(v94.ViolentOutburstBuff) and v13:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable() and v94.HeavyRepercussions:IsAvailable() and v94.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (496 - (341 + 138))) and v94.ShieldSlam:CooldownUp() and v94.HeavyRepercussions:IsAvailable()) or ((v13:RageDeficit() <= (5 + 13)) and v94.ShieldSlam:CooldownUp() and v94.ImpenetrableWall:IsAvailable()))) then
								if (v23(v94.IgnorePain, nil, nil, true) or ((7821 - 4031) == (826 - (89 + 237)))) then
									return "ignore_pain main 20";
								end
							end
							v193 = 9 - 6;
						end
						if (((187 - 98) < (1102 - (581 + 300))) and ((1224 - (855 + 365)) == v193)) then
							if (((4878 - 2824) >= (464 + 957)) and (v89 < v91) and v44 and ((v53 and v31) or not v53) and (v83 == "player") and v94.ChampionsSpear:IsCastable()) then
								v106(1255 - (1030 + 205));
								if (((650 + 42) < (2845 + 213)) and v23(v96.ChampionsSpearPlayer, not v98)) then
									return "spear_of_bastion main 28";
								end
							end
							if (((v89 < v91) and v44 and ((v53 and v31) or not v53) and (v83 == "cursor") and v94.ChampionsSpear:IsCastable()) or ((3540 - (156 + 130)) == (3760 - 2105))) then
								v106(33 - 13);
								if (v23(v96.ChampionsSpearCursor, not v98) or ((2654 - 1358) == (1294 + 3616))) then
									return "spear_of_bastion main 28";
								end
							end
							if (((1964 + 1404) == (3437 - (10 + 59))) and (v89 < v91) and v46 and ((v54 and v31) or not v54) and v94.ThunderousRoar:IsCastable()) then
								if (((748 + 1895) < (18788 - 14973)) and v23(v94.ThunderousRoar, not v14:IsInMeleeRange(1171 - (671 + 492)))) then
									return "thunderous_roar main 30";
								end
							end
							if (((1523 + 390) > (1708 - (369 + 846))) and v94.ShieldSlam:IsCastable() and v42 and v13:BuffUp(v94.FervidBuff)) then
								if (((1259 + 3496) > (2926 + 502)) and v23(v94.ShieldSlam, not v98)) then
									return "shield_slam main 31";
								end
							end
							v193 = 1950 - (1036 + 909);
						end
					end
				end
				break;
			end
			if (((1099 + 282) <= (3976 - 1607)) and (v127 == (203 - (11 + 192)))) then
				v28 = v107();
				if (v28 or ((2448 + 2395) == (4259 - (135 + 40)))) then
					return v28;
				end
				v127 = 2 - 1;
			end
		end
	end
	local function v114()
		local v128 = 0 + 0;
		while true do
			if (((10285 - 5616) > (543 - 180)) and (v128 == (180 - (50 + 126)))) then
				v39 = EpicSettings.Settings['useRavager'];
				v41 = EpicSettings.Settings['useShieldCharge'];
				v44 = EpicSettings.Settings['useChampionsSpear'];
				v128 = 13 - 8;
			end
			if (((1 + 2) == v128) or ((3290 - (1233 + 180)) >= (4107 - (522 + 447)))) then
				v45 = EpicSettings.Settings['useThunderClap'];
				v47 = EpicSettings.Settings['useWreckingThrow'];
				v32 = EpicSettings.Settings['useAvatar'];
				v128 = 1425 - (107 + 1314);
			end
			if (((2201 + 2541) >= (11048 - 7422)) and (v128 == (1 + 0))) then
				v36 = EpicSettings.Settings['useDevastate'];
				v37 = EpicSettings.Settings['useExecute'];
				v38 = EpicSettings.Settings['useHeroicThrow'];
				v128 = 3 - 1;
			end
			if ((v128 == (19 - 14)) or ((6450 - (716 + 1194)) == (16 + 900))) then
				v46 = EpicSettings.Settings['useThunderousRoar'];
				v50 = EpicSettings.Settings['avatarWithCD'];
				v51 = EpicSettings.Settings['ravagerWithCD'];
				v128 = 1 + 5;
			end
			if ((v128 == (503 - (74 + 429))) or ((2229 - 1073) > (2154 + 2191))) then
				v33 = EpicSettings.Settings['useBattleShout'];
				v34 = EpicSettings.Settings['useCharge'];
				v35 = EpicSettings.Settings['useDemoralizingShout'];
				v128 = 2 - 1;
			end
			if (((1583 + 654) < (13099 - 8850)) and ((4 - 2) == v128)) then
				v40 = EpicSettings.Settings['useRevenge'];
				v42 = EpicSettings.Settings['useShieldSlam'];
				v43 = EpicSettings.Settings['useShockwave'];
				v128 = 436 - (279 + 154);
			end
			if ((v128 == (784 - (454 + 324))) or ((2111 + 572) < (40 - (12 + 5)))) then
				v52 = EpicSettings.Settings['shieldChargeWithCD'];
				v53 = EpicSettings.Settings['championsSpearWithCD'];
				v54 = EpicSettings.Settings['thunderousRoarWithCD'];
				break;
			end
		end
	end
	local function v115()
		local v129 = 0 + 0;
		while true do
			if (((1775 - 1078) <= (306 + 520)) and (v129 == (1098 - (277 + 816)))) then
				v81 = EpicSettings.Settings['victoryRushHP'] or (0 - 0);
				v78 = EpicSettings.Settings['defensiveStanceHP'] or (1183 - (1058 + 125));
				v82 = EpicSettings.Settings['ravagerSetting'] or "";
				v83 = EpicSettings.Settings['spearSetting'] or "";
				break;
			end
			if (((208 + 897) <= (2151 - (815 + 160))) and (v129 == (12 - 9))) then
				v70 = EpicSettings.Settings['bitterImmunityHP'] or (0 - 0);
				v74 = EpicSettings.Settings['ignorePainHP'] or (0 + 0);
				v77 = EpicSettings.Settings['interveneHP'] or (0 - 0);
				v73 = EpicSettings.Settings['lastStandHP'] or (1898 - (41 + 1857));
				v129 = 1897 - (1222 + 671);
			end
			if (((8733 - 5354) <= (5478 - 1666)) and (v129 == (1183 - (229 + 953)))) then
				v64 = EpicSettings.Settings['useIgnorePain'];
				v66 = EpicSettings.Settings['useIntervene'];
				v63 = EpicSettings.Settings['useLastStand'];
				v65 = EpicSettings.Settings['useRallyingCry'];
				v129 = 1776 - (1111 + 663);
			end
			if ((v129 == (1583 - (874 + 705))) or ((111 + 677) >= (1103 + 513))) then
				v76 = EpicSettings.Settings['rallyingCryGroup'] or (0 - 0);
				v75 = EpicSettings.Settings['rallyingCryHP'] or (0 + 0);
				v72 = EpicSettings.Settings['shieldBlockHP'] or (679 - (642 + 37));
				v71 = EpicSettings.Settings['shieldWallHP'] or (0 + 0);
				v129 = 1 + 4;
			end
			if (((4654 - 2800) <= (3833 - (233 + 221))) and (v129 == (0 - 0))) then
				v57 = EpicSettings.Settings['usePummel'];
				v58 = EpicSettings.Settings['useStormBolt'];
				v59 = EpicSettings.Settings['useIntimidatingShout'];
				v60 = EpicSettings.Settings['useBitterImmunity'];
				v129 = 1 + 0;
			end
			if (((6090 - (718 + 823)) == (2863 + 1686)) and (v129 == (807 - (266 + 539)))) then
				v62 = EpicSettings.Settings['useShieldBlock'];
				v61 = EpicSettings.Settings['useShieldWall'];
				v69 = EpicSettings.Settings['useVictoryRush'];
				v92 = EpicSettings.Settings['useChangeStance'];
				v129 = 8 - 5;
			end
		end
	end
	local function v116()
		v89 = EpicSettings.Settings['fightRemainsCheck'] or (1225 - (636 + 589));
		v86 = EpicSettings.Settings['InterruptWithStun'];
		v87 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v88 = EpicSettings.Settings['InterruptThreshold'];
		v48 = EpicSettings.Settings['useTrinkets'];
		v49 = EpicSettings.Settings['useRacials'];
		v55 = EpicSettings.Settings['trinketsWithCD'];
		v56 = EpicSettings.Settings['racialsWithCD'];
		v67 = EpicSettings.Settings['useHealthstone'];
		v68 = EpicSettings.Settings['useHealingPotion'];
		v79 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v80 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v85 = EpicSettings.Settings['HealingPotionName'] or "";
		v84 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v117()
		v115();
		v114();
		v116();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		if (v13:IsDeadOrGhost() or ((2395 + 627) >= (1099 + 1925))) then
			return v28;
		end
		if (((5835 - (657 + 358)) > (5819 - 3621)) and v30) then
			v99 = v13:GetEnemiesInMeleeRange(18 - 10);
			v100 = #v99;
		else
			v100 = 1188 - (1151 + 36);
		end
		v98 = v14:IsInMeleeRange(8 + 0);
		if (v93.TargetIsValid() or v13:AffectingCombat() or ((279 + 782) >= (14606 - 9715))) then
			local v153 = 1832 - (1552 + 280);
			while true do
				if (((2198 - (64 + 770)) <= (3037 + 1436)) and (v153 == (0 - 0))) then
					v90 = v10.BossFightRemains(nil, true);
					v91 = v90;
					v153 = 1 + 0;
				end
				if ((v153 == (1244 - (157 + 1086))) or ((7195 - 3600) <= (13 - 10))) then
					if ((v91 == (17043 - 5932)) or ((6376 - 1704) == (4671 - (599 + 220)))) then
						v91 = v10.FightRemains(v99, false);
					end
					break;
				end
			end
		end
		if (((3104 - 1545) == (3490 - (1813 + 118))) and not v13:IsChanneling()) then
			if (v13:AffectingCombat() or ((1281 + 471) <= (2005 - (841 + 376)))) then
				v28 = v113();
				if (v28 or ((5474 - 1567) == (42 + 135))) then
					return v28;
				end
			else
				local v187 = 0 - 0;
				while true do
					if (((4329 - (464 + 395)) > (1424 - 869)) and (v187 == (0 + 0))) then
						v28 = v112();
						if (v28 or ((1809 - (467 + 370)) == (1332 - 687))) then
							return v28;
						end
						break;
					end
				end
			end
		end
	end
	local function v118()
		v19.Print("Protection Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(54 + 19, v117, v118);
end;
return v0["Epix_Warrior_Protection.lua"]();

