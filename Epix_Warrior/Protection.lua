local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((5103 - (507 + 1184)) > (1046 - 227)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Warrior_Protection.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = v9.Unit;
	local v11 = v9.Utils;
	local v12 = v10.Player;
	local v13 = v10.Target;
	local v14 = v10.TargetTarget;
	local v15 = v10.Focus;
	local v16 = v9.Spell;
	local v17 = v9.Item;
	local v18 = EpicLib;
	local v19 = v18.Bind;
	local v20 = v18.Cast;
	local v21 = v18.Macro;
	local v22 = v18.Press;
	local v23 = v18.Commons.Everyone.num;
	local v24 = v18.Commons.Everyone.bool;
	local v25 = UnitIsUnit;
	local v26 = math.floor;
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
	local v90 = 12626 - (624 + 891);
	local v91 = 12001 - (142 + 748);
	local v92;
	local v93 = v18.Commons.Everyone;
	local v94 = v16.Warrior.Protection;
	local v95 = v17.Warrior.Protection;
	local v96 = v21.Warrior.Protection;
	local v97 = {};
	local v98;
	local v99;
	local v100;
	local function v101()
		local v119 = UnitGetTotalAbsorbs(v13:ID());
		if (((4389 - (1192 + 35)) <= (12066 - 8625)) and (v119 > (0 - 0))) then
			return true;
		else
			return false;
		end
	end
	local function v102()
		return v12:IsTankingAoE(24 - 8) or v12:IsTanking(v13) or v13:IsDummy();
	end
	local function v103()
		if (((6476 - (1134 + 636)) > (4924 - (263 + 232))) and v12:BuffUp(v94.IgnorePain)) then
			local v175 = v12:AttackPowerDamageMod() * (6.5 - 3) * ((1 - 0) + (v12:VersatilityDmgPct() / (257 - (26 + 131))));
			local v176 = v12:AuraInfo(v94.IgnorePain, nil, true);
			local v177 = v176.points[1 + 0];
			return v177 < v175;
		else
			return true;
		end
	end
	local function v104()
		if (((11039 - 8185) < (4954 - (240 + 619))) and v12:BuffUp(v94.IgnorePain)) then
			local v178 = v12:BuffInfo(v94.IgnorePain, nil, true);
			return v178.points[1 + 0];
		else
			return 0 - 0;
		end
	end
	local function v105()
		return v102() and v94.ShieldBlock:IsReady() and (((v12:BuffRemains(v94.ShieldBlockBuff) <= (2 + 16)) and v94.EnduringDefenses:IsAvailable()) or (v12:BuffRemains(v94.ShieldBlockBuff) <= (1756 - (1344 + 400))));
	end
	local function v106(v120)
		local v121 = 485 - (255 + 150);
		if ((v121 < (28 + 7)) or (v12:Rage() < (19 + 16)) or ((4520 - 3462) >= (3882 - 2680))) then
			return false;
		end
		local v122 = false;
		local v123 = (v12:Rage() >= (1774 - (404 + 1335))) and not v105();
		if (((4117 - (183 + 223)) > (4082 - 727)) and v123 and (((v12:Rage() + v120) >= v121) or v94.DemoralizingShout:IsReady())) then
			v122 = true;
		end
		if (v122 or ((601 + 305) >= (803 + 1426))) then
			if (((1625 - (10 + 327)) > (872 + 379)) and v102() and v103()) then
				if (v22(v94.IgnorePain, nil, nil, true) or ((4851 - (118 + 220)) < (1118 + 2234))) then
					return "ignore_pain rage capped";
				end
			elseif (v22(v94.Revenge, not v98) or ((2514 - (108 + 341)) >= (1436 + 1760))) then
				return "revenge rage capped";
			end
		end
	end
	local function v107()
		local v124 = 0 - 0;
		while true do
			if ((v124 == (1496 - (711 + 782))) or ((8388 - 4012) <= (1950 - (270 + 199)))) then
				if ((v95.Healthstone:IsReady() and v67 and (v12:HealthPercentage() <= v79)) or ((1100 + 2292) >= (6560 - (580 + 1239)))) then
					if (((9884 - 6559) >= (2060 + 94)) and v22(v96.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if ((v68 and (v12:HealthPercentage() <= v80)) or ((47 + 1248) >= (1409 + 1824))) then
					if (((11427 - 7050) > (1021 + 621)) and (v85 == "Refreshing Healing Potion")) then
						if (((5890 - (645 + 522)) > (3146 - (1010 + 780))) and v95.RefreshingHealingPotion:IsReady()) then
							if (v22(v96.RefreshingHealingPotion) or ((4134 + 2) <= (16354 - 12921))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((12439 - 8194) <= (6467 - (1045 + 791))) and (v85 == "Dreamwalker's Healing Potion")) then
						if (((10823 - 6547) >= (5975 - 2061)) and v95.DreamwalkersHealingPotion:IsReady()) then
							if (((703 - (351 + 154)) <= (5939 - (1281 + 293))) and v22(v96.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((5048 - (28 + 238)) > (10447 - 5771)) and (v124 == (1560 - (1381 + 178)))) then
				if (((4563 + 301) > (1772 + 425)) and v94.IgnorePain:IsReady() and v64 and (v12:HealthPercentage() <= v74) and v103()) then
					if (v22(v94.IgnorePain, nil, nil, true) or ((1579 + 2121) == (8642 - 6135))) then
						return "ignore_pain defensive";
					end
				end
				if (((2318 + 2156) >= (744 - (381 + 89))) and v94.RallyingCry:IsReady() and v65 and v12:BuffDown(v94.AspectsFavorBuff) and v12:BuffDown(v94.RallyingCry) and (((v12:HealthPercentage() <= v75) and v93.IsSoloMode()) or v93.AreUnitsBelowHealthPercentage(v75, v76))) then
					if (v22(v94.RallyingCry) or ((1680 + 214) <= (951 + 455))) then
						return "rallying_cry defensive";
					end
				end
				v124 = 2 - 0;
			end
			if (((2728 - (1074 + 82)) >= (3354 - 1823)) and (v124 == (1784 - (214 + 1570)))) then
				if ((v94.BitterImmunity:IsReady() and v60 and (v12:HealthPercentage() <= v70)) or ((6142 - (990 + 465)) < (1873 + 2669))) then
					if (((1432 + 1859) > (1622 + 45)) and v22(v94.BitterImmunity)) then
						return "bitter_immunity defensive";
					end
				end
				if ((v94.LastStand:IsCastable() and v63 and ((v12:HealthPercentage() <= v73) or v12:ActiveMitigationNeeded())) or ((3435 - 2562) == (3760 - (1668 + 58)))) then
					if (v22(v94.LastStand) or ((3442 - (512 + 114)) < (28 - 17))) then
						return "last_stand defensive";
					end
				end
				v124 = 1 - 0;
			end
			if (((12871 - 9172) < (2190 + 2516)) and (v124 == (1 + 1))) then
				if (((2301 + 345) >= (2954 - 2078)) and v94.Intervene:IsReady() and v66 and (v15:HealthPercentage() <= v77) and (v15:Name() ~= v12:Name())) then
					if (((2608 - (109 + 1885)) <= (4653 - (1269 + 200))) and v22(v96.InterveneFocus)) then
						return "intervene defensive";
					end
				end
				if (((5991 - 2865) == (3941 - (98 + 717))) and v94.ShieldWall:IsCastable() and v61 and v12:BuffDown(v94.ShieldWallBuff) and ((v12:HealthPercentage() <= v71) or v12:ActiveMitigationNeeded())) then
					if (v22(v94.ShieldWall) or ((3013 - (802 + 24)) >= (8542 - 3588))) then
						return "shield_wall defensive";
					end
				end
				v124 = 3 - 0;
			end
		end
	end
	local function v108()
		v27 = v93.HandleTopTrinket(v97, v30, 6 + 34, nil);
		if (v27 or ((2979 + 898) == (588 + 2987))) then
			return v27;
		end
		v27 = v93.HandleBottomTrinket(v97, v30, 9 + 31, nil);
		if (((1966 - 1259) > (2107 - 1475)) and v27) then
			return v27;
		end
	end
	local function v109()
		if (v13:IsInMeleeRange(3 + 5) or ((223 + 323) >= (2214 + 470))) then
			if (((1066 + 399) <= (2009 + 2292)) and v94.ThunderClap:IsCastable() and v45) then
				if (((3137 - (797 + 636)) > (6918 - 5493)) and v22(v94.ThunderClap)) then
					return "thunder_clap precombat";
				end
			end
		elseif ((v34 and v94.Charge:IsCastable() and not v13:IsInRange(1627 - (1427 + 192))) or ((239 + 448) == (9829 - 5595))) then
			if (v22(v94.Charge, not v13:IsSpellInRange(v94.Charge)) or ((2994 + 336) < (648 + 781))) then
				return "charge precombat";
			end
		end
	end
	local function v110()
		local v125 = 326 - (192 + 134);
		while true do
			if (((2423 - (316 + 960)) >= (187 + 148)) and (v125 == (2 + 0))) then
				if (((3176 + 259) > (8016 - 5919)) and v94.ShieldSlam:IsCastable() and v42 and ((v12:Rage() <= (611 - (83 + 468))) or (v12:BuffUp(v94.ViolentOutburstBuff) and (v100 <= (1813 - (1202 + 604)))))) then
					local v184 = 0 - 0;
					while true do
						if (((0 - 0) == v184) or ((10438 - 6668) >= (4366 - (45 + 280)))) then
							v106(20 + 0);
							if (v22(v94.ShieldSlam, not v98) or ((3313 + 478) <= (589 + 1022))) then
								return "shield_slam aoe 8";
							end
							break;
						end
					end
				end
				if ((v94.ThunderClap:IsCastable() and v45) or ((2534 + 2044) <= (354 + 1654))) then
					v106(9 - 4);
					if (((3036 - (340 + 1571)) <= (819 + 1257)) and v22(v94.ThunderClap, not v13:IsInMeleeRange(1780 - (1733 + 39)))) then
						return "thunder_clap aoe 10";
					end
				end
				v125 = 8 - 5;
			end
			if ((v125 == (1037 - (125 + 909))) or ((2691 - (1096 + 852)) >= (1974 + 2425))) then
				if (((1649 - 494) < (1623 + 50)) and v94.Revenge:IsReady() and v40 and ((v12:Rage() >= (542 - (409 + 103))) or ((v12:Rage() >= (276 - (46 + 190))) and v94.BarbaricTraining:IsAvailable()))) then
					if (v22(v94.Revenge, not v98) or ((2419 - (51 + 44)) <= (164 + 414))) then
						return "revenge aoe 12";
					end
				end
				break;
			end
			if (((5084 - (1114 + 203)) == (4493 - (228 + 498))) and (v125 == (1 + 0))) then
				if (((2260 + 1829) == (4752 - (174 + 489))) and v94.ThunderClap:IsCastable() and v45 and v12:BuffUp(v94.ViolentOutburstBuff) and (v100 > (12 - 7)) and v12:BuffUp(v94.AvatarBuff) and v94.UnstoppableForce:IsAvailable()) then
					local v185 = 1905 - (830 + 1075);
					while true do
						if (((4982 - (303 + 221)) >= (2943 - (231 + 1038))) and ((0 + 0) == v185)) then
							v106(1167 - (171 + 991));
							if (((4005 - 3033) <= (3807 - 2389)) and v22(v94.ThunderClap, not v13:IsInMeleeRange(19 - 11))) then
								return "thunder_clap aoe 4";
							end
							break;
						end
					end
				end
				if ((v94.Revenge:IsReady() and v40 and (v12:Rage() >= (57 + 13)) and v94.SeismicReverberation:IsAvailable() and (v100 >= (10 - 7))) or ((14245 - 9307) < (7675 - 2913))) then
					if (v22(v94.Revenge, not v98) or ((7740 - 5236) > (5512 - (111 + 1137)))) then
						return "revenge aoe 6";
					end
				end
				v125 = 160 - (91 + 67);
			end
			if (((6407 - 4254) == (538 + 1615)) and ((523 - (423 + 100)) == v125)) then
				if ((v94.ThunderClap:IsCastable() and v45 and (v13:DebuffRemains(v94.RendDebuff) <= (1 + 0))) or ((1403 - 896) >= (1351 + 1240))) then
					v106(776 - (326 + 445));
					if (((19554 - 15073) == (9982 - 5501)) and v22(v94.ThunderClap, not v13:IsInMeleeRange(18 - 10))) then
						return "thunder_clap aoe 2";
					end
				end
				if ((v94.ShieldSlam:IsCastable() and v42 and ((v12:HasTier(741 - (530 + 181), 883 - (614 + 267)) and (v100 <= (39 - (19 + 13)))) or v12:BuffUp(v94.EarthenTenacityBuff))) or ((3788 - 1460) < (1614 - 921))) then
					if (((12363 - 8035) == (1125 + 3203)) and v22(v94.ShieldSlam, not v98)) then
						return "shield_slam aoe 3";
					end
				end
				v125 = 1 - 0;
			end
		end
	end
	local function v111()
		if (((3293 - 1705) >= (3144 - (1293 + 519))) and v94.ShieldSlam:IsCastable() and v42) then
			local v179 = 0 - 0;
			while true do
				if ((v179 == (0 - 0)) or ((7981 - 3807) > (18317 - 14069))) then
					v106(47 - 27);
					if (v22(v94.ShieldSlam, not v98) or ((2429 + 2157) <= (17 + 65))) then
						return "shield_slam generic 2";
					end
					break;
				end
			end
		end
		if (((8975 - 5112) == (893 + 2970)) and v94.ThunderClap:IsCastable() and v45 and (v13:DebuffRemains(v94.RendDebuff) <= (1 + 0)) and v12:BuffDown(v94.ViolentOutburstBuff)) then
			v106(4 + 1);
			if (v22(v94.ThunderClap, not v13:IsInMeleeRange(1104 - (709 + 387))) or ((2140 - (673 + 1185)) <= (121 - 79))) then
				return "thunder_clap generic 4";
			end
		end
		if (((14800 - 10191) >= (1259 - 493)) and v94.Execute:IsReady() and v37 and v12:BuffUp(v94.SuddenDeathBuff) and v94.SuddenDeath:IsAvailable()) then
			if (v22(v94.Execute, not v98) or ((824 + 328) == (1860 + 628))) then
				return "execute generic 6";
			end
		end
		if (((4619 - 1197) > (823 + 2527)) and v94.Execute:IsReady() and v37 and (v100 == (1 - 0)) and (v94.Massacre:IsAvailable() or v94.Juggernaut:IsAvailable()) and (v12:Rage() >= (98 - 48))) then
			if (((2757 - (446 + 1434)) > (1659 - (1040 + 243))) and v22(v94.Execute, not v98)) then
				return "execute generic 6";
			end
		end
		if ((v94.Execute:IsReady() and v37 and (v100 == (2 - 1)) and (v12:Rage() >= (1897 - (559 + 1288)))) or ((5049 - (609 + 1322)) <= (2305 - (13 + 441)))) then
			if (v22(v94.Execute, not v98) or ((616 - 451) >= (9146 - 5654))) then
				return "execute generic 10";
			end
		end
		if (((19667 - 15718) < (181 + 4675)) and v94.ThunderClap:IsCastable() and v45 and ((v100 > (3 - 2)) or (v94.ShieldSlam:CooldownDown() and not v12:BuffUp(v94.ViolentOutburstBuff)))) then
			local v180 = 0 + 0;
			while true do
				if (((0 + 0) == v180) or ((12689 - 8413) < (1651 + 1365))) then
					v106(8 - 3);
					if (((3101 + 1589) > (2295 + 1830)) and v22(v94.ThunderClap, not v13:IsInMeleeRange(6 + 2))) then
						return "thunder_clap generic 12";
					end
					break;
				end
			end
		end
		if ((v94.Revenge:IsReady() and v40 and (((v12:Rage() >= (51 + 9)) and (v13:HealthPercentage() > (20 + 0))) or (v12:BuffUp(v94.RevengeBuff) and (v13:HealthPercentage() <= (453 - (153 + 280))) and (v12:Rage() <= (51 - 33)) and v94.ShieldSlam:CooldownDown()) or (v12:BuffUp(v94.RevengeBuff) and (v13:HealthPercentage() > (18 + 2))) or ((((v12:Rage() >= (24 + 36)) and (v13:HealthPercentage() > (19 + 16))) or (v12:BuffUp(v94.RevengeBuff) and (v13:HealthPercentage() <= (32 + 3)) and (v12:Rage() <= (14 + 4)) and v94.ShieldSlam:CooldownDown()) or (v12:BuffUp(v94.RevengeBuff) and (v13:HealthPercentage() > (53 - 18)))) and v94.Massacre:IsAvailable()))) or ((31 + 19) >= (1563 - (89 + 578)))) then
			if (v22(v94.Revenge, not v98) or ((1225 + 489) >= (6149 - 3191))) then
				return "revenge generic 14";
			end
		end
		if ((v94.Execute:IsReady() and v37 and (v100 == (1050 - (572 + 477)))) or ((202 + 1289) < (387 + 257))) then
			if (((85 + 619) < (1073 - (84 + 2))) and v22(v94.Execute, not v98)) then
				return "execute generic 16";
			end
		end
		if (((6127 - 2409) > (1374 + 532)) and v94.Revenge:IsReady() and v40 and (v13:HealthPercentage() > (862 - (497 + 345)))) then
			if (v22(v94.Revenge, not v98) or ((25 + 933) > (615 + 3020))) then
				return "revenge generic 18";
			end
		end
		if (((4834 - (605 + 728)) <= (3205 + 1287)) and v94.ThunderClap:IsCastable() and v45 and ((v100 >= (1 - 0)) or (v94.ShieldSlam:CooldownDown() and v12:BuffUp(v94.ViolentOutburstBuff)))) then
			v106(1 + 4);
			if (v22(v94.ThunderClap, not v13:IsInMeleeRange(29 - 21)) or ((3103 + 339) < (7059 - 4511))) then
				return "thunder_clap generic 20";
			end
		end
		if (((2171 + 704) >= (1953 - (457 + 32))) and v94.Devastate:IsCastable() and v36) then
			if (v22(v94.Devastate, not v98) or ((2036 + 2761) >= (6295 - (832 + 570)))) then
				return "devastate generic 22";
			end
		end
	end
	local function v112()
		local v126 = 0 + 0;
		while true do
			if ((v126 == (0 + 0)) or ((1949 - 1398) > (997 + 1071))) then
				if (((2910 - (588 + 208)) > (2544 - 1600)) and not v12:AffectingCombat()) then
					local v186 = 1800 - (884 + 916);
					while true do
						if ((v186 == (0 - 0)) or ((1312 + 950) >= (3749 - (232 + 421)))) then
							if ((v94.BattleShout:IsCastable() and v33 and (v12:BuffDown(v94.BattleShoutBuff, true) or v93.GroupBuffMissing(v94.BattleShoutBuff))) or ((4144 - (1569 + 320)) >= (868 + 2669))) then
								if (v22(v94.BattleShout) or ((729 + 3108) < (4400 - 3094))) then
									return "battle_shout precombat";
								end
							end
							if (((3555 - (316 + 289)) == (7722 - 4772)) and v92 and v94.BattleStance:IsCastable() and not v12:BuffUp(v94.BattleStance)) then
								if (v22(v94.BattleStance) or ((219 + 4504) < (4751 - (666 + 787)))) then
									return "battle_stance precombat";
								end
							end
							break;
						end
					end
				end
				if (((1561 - (360 + 65)) >= (144 + 10)) and v93.TargetIsValid() and v28) then
					if (not v12:AffectingCombat() or ((525 - (79 + 175)) > (7486 - 2738))) then
						v27 = v109();
						if (((3699 + 1041) >= (9661 - 6509)) and v27) then
							return v27;
						end
					end
				end
				break;
			end
		end
	end
	local function v113()
		local v127 = 0 - 0;
		while true do
			if ((v127 == (900 - (503 + 396))) or ((2759 - (92 + 89)) >= (6576 - 3186))) then
				if (((22 + 19) <= (984 + 677)) and v84) then
					v27 = v93.HandleIncorporeal(v94.StormBolt, v96.StormBoltMouseover, 78 - 58, true);
					if (((83 + 518) < (8117 - 4557)) and v27) then
						return v27;
					end
					v27 = v93.HandleIncorporeal(v94.IntimidatingShout, v96.IntimidatingShoutMouseover, 7 + 1, true);
					if (((113 + 122) < (2092 - 1405)) and v27) then
						return v27;
					end
				end
				if (((568 + 3981) > (1758 - 605)) and v93.TargetIsValid()) then
					local v187 = 1244 - (485 + 759);
					local v188;
					while true do
						if ((v187 == (11 - 6)) or ((5863 - (442 + 747)) < (5807 - (832 + 303)))) then
							if (((4614 - (88 + 858)) < (1391 + 3170)) and v94.DemoralizingShout:IsCastable() and v35 and v94.BoomingVoice:IsAvailable()) then
								v106(25 + 5);
								if (v22(v94.DemoralizingShout, not v98) or ((19 + 436) == (4394 - (766 + 23)))) then
									return "demoralizing_shout main 28";
								end
							end
							if (((v89 < v91) and v44 and ((v53 and v30) or not v53) and (v83 == "player") and v94.ChampionsSpear:IsCastable()) or ((13146 - 10483) == (4529 - 1217))) then
								local v189 = 0 - 0;
								while true do
									if (((14516 - 10239) <= (5548 - (1036 + 37))) and (v189 == (0 + 0))) then
										v106(38 - 18);
										if (v22(v96.ChampionsSpearPlayer, not v98) or ((685 + 185) == (2669 - (641 + 839)))) then
											return "spear_of_bastion main 28";
										end
										break;
									end
								end
							end
							if (((2466 - (910 + 3)) <= (7986 - 4853)) and (v89 < v91) and v44 and ((v53 and v30) or not v53) and (v83 == "cursor") and v94.ChampionsSpear:IsCastable()) then
								local v190 = 1684 - (1466 + 218);
								while true do
									if (((0 + 0) == v190) or ((3385 - (556 + 592)) >= (1249 + 2262))) then
										v106(828 - (329 + 479));
										if (v22(v96.ChampionsSpearCursor, not v98) or ((2178 - (174 + 680)) > (10377 - 7357))) then
											return "spear_of_bastion main 28";
										end
										break;
									end
								end
							end
							v187 = 11 - 5;
						end
						if ((v187 == (6 + 2)) or ((3731 - (396 + 343)) == (167 + 1714))) then
							v27 = v111();
							if (((4583 - (29 + 1448)) > (2915 - (135 + 1254))) and v27) then
								return v27;
							end
							if (((11388 - 8365) < (18069 - 14199)) and v18.CastAnnotated(v94.Pool, false, "WAIT")) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((96 + 47) > (1601 - (389 + 1138))) and (v187 == (577 - (102 + 472)))) then
							v188 = v93.HandleDPSPotion(v13:BuffUp(v94.AvatarBuff));
							if (((17 + 1) < (1172 + 940)) and v188) then
								return v188;
							end
							if (((1023 + 74) <= (3173 - (320 + 1225))) and v94.IgnorePain:IsReady() and v64 and v103() and (v13:HealthPercentage() >= (35 - 15)) and (((v12:RageDeficit() <= (10 + 5)) and v94.ShieldSlam:CooldownUp()) or ((v12:RageDeficit() <= (1504 - (157 + 1307))) and v94.ShieldCharge:CooldownUp() and v94.ChampionsBulwark:IsAvailable()) or ((v12:RageDeficit() <= (1879 - (821 + 1038))) and v94.ShieldCharge:CooldownUp()) or ((v12:RageDeficit() <= (74 - 44)) and v94.DemoralizingShout:CooldownUp() and v94.BoomingVoice:IsAvailable()) or ((v12:RageDeficit() <= (3 + 17)) and v94.Avatar:CooldownUp()) or ((v12:RageDeficit() <= (79 - 34)) and v94.DemoralizingShout:CooldownUp() and v94.BoomingVoice:IsAvailable() and v12:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable()) or ((v12:RageDeficit() <= (12 + 18)) and v94.Avatar:CooldownUp() and v12:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable()) or (v12:RageDeficit() <= (49 - 29)) or ((v12:RageDeficit() <= (1066 - (834 + 192))) and v94.ShieldSlam:CooldownUp() and v12:BuffUp(v94.ViolentOutburstBuff) and v94.HeavyRepercussions:IsAvailable() and v94.ImpenetrableWall:IsAvailable()) or ((v12:RageDeficit() <= (4 + 51)) and v94.ShieldSlam:CooldownUp() and v12:BuffUp(v94.ViolentOutburstBuff) and v12:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable() and v94.HeavyRepercussions:IsAvailable() and v94.ImpenetrableWall:IsAvailable()) or ((v12:RageDeficit() <= (5 + 12)) and v94.ShieldSlam:CooldownUp() and v94.HeavyRepercussions:IsAvailable()) or ((v12:RageDeficit() <= (1 + 17)) and v94.ShieldSlam:CooldownUp() and v94.ImpenetrableWall:IsAvailable()))) then
								if (((7172 - 2542) == (4934 - (300 + 4))) and v22(v94.IgnorePain, nil, nil, true)) then
									return "ignore_pain main 20";
								end
							end
							v187 = 2 + 2;
						end
						if (((9266 - 5726) > (3045 - (112 + 250))) and (v187 == (3 + 4))) then
							if (((12009 - 7215) >= (1877 + 1398)) and (v89 < v91) and v94.ShieldCharge:IsCastable() and v41 and ((v52 and v30) or not v52)) then
								if (((768 + 716) == (1110 + 374)) and v22(v94.ShieldCharge, not v13:IsSpellInRange(v94.ShieldCharge))) then
									return "shield_charge main 34";
								end
							end
							if (((711 + 721) < (2641 + 914)) and v105() and v62) then
								if (v22(v94.ShieldBlock) or ((2479 - (1001 + 413)) > (7978 - 4400))) then
									return "shield_block main 38";
								end
							end
							if ((v100 > (885 - (244 + 638))) or ((5488 - (627 + 66)) < (4192 - 2785))) then
								local v191 = 602 - (512 + 90);
								while true do
									if (((3759 - (1665 + 241)) < (5530 - (373 + 344))) and ((0 + 0) == v191)) then
										v27 = v110();
										if (v27 or ((747 + 2074) < (6412 - 3981))) then
											return v27;
										end
										v191 = 1 - 0;
									end
									if ((v191 == (1100 - (35 + 1064))) or ((2092 + 782) < (4666 - 2485))) then
										if (v18.CastAnnotated(v94.Pool, false, "WAIT") or ((11 + 2678) <= (1579 - (298 + 938)))) then
											return "Pool for Aoe()";
										end
										break;
									end
								end
							end
							v187 = 1267 - (233 + 1026);
						end
						if ((v187 == (1672 - (636 + 1030))) or ((956 + 913) == (1963 + 46))) then
							if (((v89 < v91) and v46 and ((v54 and v30) or not v54) and v94.ThunderousRoar:IsCastable()) or ((1054 + 2492) < (157 + 2165))) then
								if (v22(v94.ThunderousRoar, not v13:IsInMeleeRange(229 - (55 + 166))) or ((404 + 1678) == (480 + 4293))) then
									return "thunderous_roar main 30";
								end
							end
							if (((12389 - 9145) > (1352 - (36 + 261))) and v94.ShieldSlam:IsCastable() and v42 and v12:BuffUp(v94.FervidBuff)) then
								if (v22(v94.ShieldSlam, not v98) or ((5793 - 2480) <= (3146 - (34 + 1334)))) then
									return "shield_slam main 31";
								end
							end
							if ((v94.Shockwave:IsCastable() and v43 and v12:BuffUp(v94.AvatarBuff) and v94.UnstoppableForce:IsAvailable() and not v94.RumblingEarth:IsAvailable()) or (v94.SonicBoom:IsAvailable() and v94.RumblingEarth:IsAvailable() and (v100 >= (2 + 1)) and v13:IsCasting()) or ((1105 + 316) >= (3387 - (1035 + 248)))) then
								local v192 = 21 - (20 + 1);
								while true do
									if (((945 + 867) <= (3568 - (134 + 185))) and (v192 == (1133 - (549 + 584)))) then
										v106(695 - (314 + 371));
										if (((5571 - 3948) <= (2925 - (478 + 490))) and v22(v94.Shockwave, not v13:IsInMeleeRange(5 + 3))) then
											return "shockwave main 32";
										end
										break;
									end
								end
							end
							v187 = 1179 - (786 + 386);
						end
						if (((14290 - 9878) == (5791 - (1055 + 324))) and (v187 == (1341 - (1093 + 247)))) then
							if (((1556 + 194) >= (89 + 753)) and v34 and v94.Charge:IsCastable() and not v98) then
								if (((17357 - 12985) > (6278 - 4428)) and v22(v94.Charge, not v13:IsSpellInRange(v94.Charge))) then
									return "charge main 34";
								end
							end
							if (((659 - 427) < (2063 - 1242)) and (v89 < v91)) then
								local v193 = 0 + 0;
								while true do
									if (((1995 - 1477) < (3108 - 2206)) and (v193 == (0 + 0))) then
										if (((7656 - 4662) > (1546 - (364 + 324))) and v48 and ((v30 and v55) or not v55)) then
											local v196 = 0 - 0;
											while true do
												if ((v196 == (0 - 0)) or ((1245 + 2510) <= (3828 - 2913))) then
													v27 = v108();
													if (((6319 - 2373) > (11367 - 7624)) and v27) then
														return v27;
													end
													break;
												end
											end
										end
										if ((v30 and v95.FyralathTheDreamrender:IsEquippedAndReady() and v31) or ((2603 - (1249 + 19)) >= (2985 + 321))) then
											if (((18855 - 14011) > (3339 - (686 + 400))) and v22(v96.UseWeapon)) then
												return "Fyralath The Dreamrender used";
											end
										end
										break;
									end
								end
							end
							if (((355 + 97) == (681 - (73 + 156))) and v38 and v94.HeroicThrow:IsCastable() and not v13:IsInRange(1 + 24)) then
								if (v22(v94.HeroicThrow, not v13:IsSpellInRange(v94.HeroicThrow)) or ((5368 - (721 + 90)) < (24 + 2063))) then
									return "heroic_throw main";
								end
							end
							v187 = 6 - 4;
						end
						if (((4344 - (224 + 246)) == (6275 - 2401)) and (v187 == (6 - 2))) then
							if ((v102() and v63 and v94.LastStand:IsCastable() and v12:BuffDown(v94.ShieldWallBuff) and (((v13:HealthPercentage() >= (17 + 73)) and v94.UnnervingFocus:IsAvailable()) or ((v13:HealthPercentage() <= (1 + 19)) and v94.UnnervingFocus:IsAvailable()) or v94.Bolster:IsAvailable() or v12:HasTier(23 + 7, 3 - 1))) or ((6449 - 4511) > (5448 - (203 + 310)))) then
								if (v22(v94.LastStand) or ((6248 - (1238 + 755)) < (240 + 3183))) then
									return "last_stand defensive";
								end
							end
							if (((2988 - (709 + 825)) <= (4590 - 2099)) and (v89 < v91) and v39 and ((v51 and v30) or not v51) and (v82 == "player") and v94.Ravager:IsCastable()) then
								local v194 = 0 - 0;
								while true do
									if ((v194 == (864 - (196 + 668))) or ((16412 - 12255) <= (5805 - 3002))) then
										v106(843 - (171 + 662));
										if (((4946 - (4 + 89)) >= (10451 - 7469)) and v22(v96.RavagerPlayer, not v98)) then
											return "ravager main 24";
										end
										break;
									end
								end
							end
							if (((1506 + 2628) > (14744 - 11387)) and (v89 < v91) and v39 and ((v51 and v30) or not v51) and (v82 == "cursor") and v94.Ravager:IsCastable()) then
								local v195 = 0 + 0;
								while true do
									if ((v195 == (1486 - (35 + 1451))) or ((4870 - (28 + 1425)) < (4527 - (941 + 1052)))) then
										v106(10 + 0);
										if (v22(v96.RavagerCursor, not v98) or ((4236 - (822 + 692)) <= (233 - 69))) then
											return "ravager main 24";
										end
										break;
									end
								end
							end
							v187 = 3 + 2;
						end
						if ((v187 == (299 - (45 + 252))) or ((2383 + 25) < (726 + 1383))) then
							if ((v94.WreckingThrow:IsCastable() and v47 and v12:CanAttack(v13) and v101()) or ((80 - 47) == (1888 - (114 + 319)))) then
								if (v22(v94.WreckingThrow, not v13:IsSpellInRange(v94.WreckingThrow)) or ((635 - 192) >= (5144 - 1129))) then
									return "wrecking_throw main";
								end
							end
							if (((2156 + 1226) > (246 - 80)) and (v89 < v91) and v32 and ((v50 and v30) or not v50) and v94.Avatar:IsCastable()) then
								if (v22(v94.Avatar) or ((586 - 306) == (5022 - (556 + 1407)))) then
									return "avatar main 2";
								end
							end
							if (((3087 - (741 + 465)) > (1758 - (170 + 295))) and (v89 < v91) and v49 and ((v56 and v30) or not v56)) then
								if (((1242 + 1115) == (2165 + 192)) and v94.BloodFury:IsCastable()) then
									if (((302 - 179) == (102 + 21)) and v22(v94.BloodFury)) then
										return "blood_fury main 4";
									end
								end
								if (v94.Berserking:IsCastable() or ((678 + 378) >= (1921 + 1471))) then
									if (v22(v94.Berserking) or ((2311 - (957 + 273)) < (288 + 787))) then
										return "berserking main 6";
									end
								end
								if (v94.ArcaneTorrent:IsCastable() or ((420 + 629) >= (16887 - 12455))) then
									if (v22(v94.ArcaneTorrent) or ((12564 - 7796) <= (2583 - 1737))) then
										return "arcane_torrent main 8";
									end
								end
								if (v94.LightsJudgment:IsCastable() or ((16627 - 13269) <= (3200 - (389 + 1391)))) then
									if (v22(v94.LightsJudgment) or ((2346 + 1393) <= (313 + 2692))) then
										return "lights_judgment main 10";
									end
								end
								if (v94.Fireblood:IsCastable() or ((3776 - 2117) >= (3085 - (783 + 168)))) then
									if (v22(v94.Fireblood) or ((10941 - 7681) < (2317 + 38))) then
										return "fireblood main 12";
									end
								end
								if (v94.AncestralCall:IsCastable() or ((980 - (309 + 2)) == (12968 - 8745))) then
									if (v22(v94.AncestralCall) or ((2904 - (1090 + 122)) < (191 + 397))) then
										return "ancestral_call main 14";
									end
								end
								if (v94.BagofTricks:IsCastable() or ((16110 - 11313) < (2499 + 1152))) then
									if (v22(v94.BagofTricks) or ((5295 - (628 + 490)) > (870 + 3980))) then
										return "ancestral_call main 16";
									end
								end
							end
							v187 = 7 - 4;
						end
						if ((v187 == (0 - 0)) or ((1174 - (431 + 343)) > (2243 - 1132))) then
							if (((8826 - 5775) > (794 + 211)) and v92 and (v12:HealthPercentage() <= v78)) then
								if (((473 + 3220) <= (6077 - (556 + 1139))) and v94.DefensiveStance:IsCastable() and not v12:BuffUp(v94.DefensiveStance)) then
									if (v22(v94.DefensiveStance) or ((3297 - (6 + 9)) > (751 + 3349))) then
										return "defensive_stance while tanking";
									end
								end
							end
							if ((v92 and (v12:HealthPercentage() > v78)) or ((1834 + 1746) < (3013 - (28 + 141)))) then
								if (((35 + 54) < (5542 - 1052)) and v94.BattleStance:IsCastable() and not v12:BuffUp(v94.BattleStance)) then
									if (v22(v94.BattleStance) or ((3530 + 1453) < (3125 - (486 + 831)))) then
										return "battle_stance while not tanking";
									end
								end
							end
							if (((9963 - 6134) > (13268 - 9499)) and v41 and ((v52 and v30) or not v52) and (v89 < v91) and v94.ShieldCharge:IsCastable() and not v98) then
								if (((281 + 1204) <= (9182 - 6278)) and v22(v94.ShieldCharge, not v13:IsSpellInRange(v94.ShieldCharge))) then
									return "shield_charge main 34";
								end
							end
							v187 = 1264 - (668 + 595);
						end
					end
				end
				break;
			end
			if (((3842 + 427) == (861 + 3408)) and ((0 - 0) == v127)) then
				v27 = v107();
				if (((677 - (23 + 267)) <= (4726 - (1129 + 815))) and v27) then
					return v27;
				end
				v127 = 388 - (371 + 16);
			end
		end
	end
	local function v114()
		v31 = EpicSettings.Settings['useWeapon'];
		v33 = EpicSettings.Settings['useBattleShout'];
		v34 = EpicSettings.Settings['useCharge'];
		v35 = EpicSettings.Settings['useDemoralizingShout'];
		v36 = EpicSettings.Settings['useDevastate'];
		v37 = EpicSettings.Settings['useExecute'];
		v38 = EpicSettings.Settings['useHeroicThrow'];
		v40 = EpicSettings.Settings['useRevenge'];
		v42 = EpicSettings.Settings['useShieldSlam'];
		v43 = EpicSettings.Settings['useShockwave'];
		v45 = EpicSettings.Settings['useThunderClap'];
		v47 = EpicSettings.Settings['useWreckingThrow'];
		v32 = EpicSettings.Settings['useAvatar'];
		v39 = EpicSettings.Settings['useRavager'];
		v41 = EpicSettings.Settings['useShieldCharge'];
		v44 = EpicSettings.Settings['useChampionsSpear'];
		v46 = EpicSettings.Settings['useThunderousRoar'];
		v50 = EpicSettings.Settings['avatarWithCD'];
		v51 = EpicSettings.Settings['ravagerWithCD'];
		v52 = EpicSettings.Settings['shieldChargeWithCD'];
		v53 = EpicSettings.Settings['championsSpearWithCD'];
		v54 = EpicSettings.Settings['thunderousRoarWithCD'];
	end
	local function v115()
		v57 = EpicSettings.Settings['usePummel'];
		v58 = EpicSettings.Settings['useStormBolt'];
		v59 = EpicSettings.Settings['useIntimidatingShout'];
		v60 = EpicSettings.Settings['useBitterImmunity'];
		v64 = EpicSettings.Settings['useIgnorePain'];
		v66 = EpicSettings.Settings['useIntervene'];
		v63 = EpicSettings.Settings['useLastStand'];
		v65 = EpicSettings.Settings['useRallyingCry'];
		v62 = EpicSettings.Settings['useShieldBlock'];
		v61 = EpicSettings.Settings['useShieldWall'];
		v69 = EpicSettings.Settings['useVictoryRush'];
		v92 = EpicSettings.Settings['useChangeStance'];
		v70 = EpicSettings.Settings['bitterImmunityHP'] or (1750 - (1326 + 424));
		v74 = EpicSettings.Settings['ignorePainHP'] or (0 - 0);
		v77 = EpicSettings.Settings['interveneHP'] or (0 - 0);
		v73 = EpicSettings.Settings['lastStandHP'] or (118 - (88 + 30));
		v76 = EpicSettings.Settings['rallyingCryGroup'] or (771 - (720 + 51));
		v75 = EpicSettings.Settings['rallyingCryHP'] or (0 - 0);
		v72 = EpicSettings.Settings['shieldBlockHP'] or (1776 - (421 + 1355));
		v71 = EpicSettings.Settings['shieldWallHP'] or (0 - 0);
		v81 = EpicSettings.Settings['victoryRushHP'] or (0 + 0);
		v78 = EpicSettings.Settings['defensiveStanceHP'] or (1083 - (286 + 797));
		v82 = EpicSettings.Settings['ravagerSetting'] or "";
		v83 = EpicSettings.Settings['spearSetting'] or "";
	end
	local function v116()
		v89 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
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
		v80 = EpicSettings.Settings['healingPotionHP'] or (439 - (397 + 42));
		v85 = EpicSettings.Settings['HealingPotionName'] or "";
		v84 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v117()
		v115();
		v114();
		v116();
		v28 = EpicSettings.Toggles['ooc'];
		v29 = EpicSettings.Toggles['aoe'];
		v30 = EpicSettings.Toggles['cds'];
		if (v12:IsDeadOrGhost() or ((594 + 1305) <= (1717 - (24 + 776)))) then
			return v27;
		end
		if (v29 or ((6642 - 2330) <= (1661 - (222 + 563)))) then
			v99 = v12:GetEnemiesInMeleeRange(17 - 9);
			v100 = #v99;
		else
			v100 = 1 + 0;
		end
		v98 = v13:IsInMeleeRange(198 - (23 + 167));
		if (((4030 - (690 + 1108)) <= (937 + 1659)) and (v93.TargetIsValid() or v12:AffectingCombat())) then
			local v181 = 0 + 0;
			while true do
				if (((2943 - (40 + 808)) < (607 + 3079)) and (v181 == (0 - 0))) then
					v90 = v9.BossFightRemains(nil, true);
					v91 = v90;
					v181 = 1 + 0;
				end
				if ((v181 == (1 + 0)) or ((875 + 720) >= (5045 - (47 + 524)))) then
					if ((v91 == (7211 + 3900)) or ((12626 - 8007) < (4308 - 1426))) then
						v91 = v9.FightRemains(v99, false);
					end
					break;
				end
			end
		end
		if (not v12:IsChanneling() or ((670 - 376) >= (6557 - (1165 + 561)))) then
			if (((61 + 1968) <= (9551 - 6467)) and v12:AffectingCombat()) then
				local v182 = 0 + 0;
				while true do
					if ((v182 == (479 - (341 + 138))) or ((550 + 1487) == (4994 - 2574))) then
						v27 = v113();
						if (((4784 - (89 + 237)) > (12558 - 8654)) and v27) then
							return v27;
						end
						break;
					end
				end
			else
				local v183 = 0 - 0;
				while true do
					if (((1317 - (581 + 300)) >= (1343 - (855 + 365))) and (v183 == (0 - 0))) then
						v27 = v112();
						if (((164 + 336) < (3051 - (1030 + 205))) and v27) then
							return v27;
						end
						break;
					end
				end
			end
		end
	end
	local function v118()
		v18.Print("Protection Warrior by Epic. Supported by xKaneto.");
	end
	v18.SetAPL(69 + 4, v117, v118);
end;
return v0["Epix_Warrior_Protection.lua"]();

