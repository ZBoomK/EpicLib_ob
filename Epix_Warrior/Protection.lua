local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1574 - (1281 + 293);
	local v6;
	while true do
		if ((v5 == (266 - (28 + 238))) or ((9241 - 5105) <= (4992 - (1381 + 178)))) then
			v6 = v0[v4];
			if (((3982 + 263) <= (3735 + 896)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((14741 - 10465) >= (2028 + 1886)) and (v5 == (471 - (381 + 89)))) then
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
	local v90 = 9854 + 1257;
	local v91 = 7515 + 3596;
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
		local v119 = UnitGetTotalAbsorbs(v14);
		if (((339 - 141) <= (5521 - (1074 + 82))) and (v119 > (0 - 0))) then
			return true;
		else
			return false;
		end
	end
	local function v102()
		return v13:IsTankingAoE(1800 - (214 + 1570)) or v13:IsTanking(v14) or v14:IsDummy();
	end
	local function v103()
		if (((6237 - (990 + 465)) > (1928 + 2748)) and v13:BuffUp(v94.IgnorePain)) then
			local v145 = 0 + 0;
			local v146;
			local v147;
			local v148;
			while true do
				if (((4730 + 134) > (8646 - 6449)) and (v145 == (1726 - (1668 + 58)))) then
					v146 = v13:AttackPowerDamageMod() * (629.5 - (512 + 114)) * ((2 - 1) + (v13:VersatilityDmgPct() / (206 - 106)));
					v147 = v13:AuraInfo(v94.IgnorePain, nil, true);
					v145 = 3 - 2;
				end
				if ((v145 == (1 + 0)) or ((693 + 3007) == (2180 + 327))) then
					v148 = v147.points[3 - 2];
					return v148 < v146;
				end
			end
		else
			return true;
		end
	end
	local function v104()
		if (((6468 - (109 + 1885)) >= (1743 - (1269 + 200))) and v13:BuffUp(v94.IgnorePain)) then
			local v149 = v13:BuffInfo(v94.IgnorePain, nil, true);
			return v149.points[1 - 0];
		else
			return 815 - (98 + 717);
		end
	end
	local function v105()
		return v102() and v94.ShieldBlock:IsReady() and (((v13:BuffRemains(v94.ShieldBlockBuff) <= (844 - (802 + 24))) and v94.EnduringDefenses:IsAvailable()) or (v13:BuffRemains(v94.ShieldBlockBuff) <= (20 - 8)));
	end
	local function v106(v120)
		local v121 = 0 - 0;
		local v122;
		local v123;
		local v124;
		while true do
			if ((v121 == (1 + 1)) or ((1456 + 438) <= (231 + 1175))) then
				if (((340 + 1232) >= (4259 - 2728)) and v124 and (((v13:Rage() + v120) >= v122) or v94.DemoralizingShout:IsReady())) then
					v123 = true;
				end
				if (v123 or ((15630 - 10943) < (1625 + 2917))) then
					if (((1340 + 1951) > (1376 + 291)) and v102() and v103()) then
						if (v23(v94.IgnorePain, nil, nil, true) or ((635 + 238) == (950 + 1084))) then
							return "ignore_pain rage capped";
						end
					elseif (v23(v94.Revenge, not v98) or ((4249 - (797 + 636)) < (53 - 42))) then
						return "revenge rage capped";
					end
				end
				break;
			end
			if (((5318 - (1427 + 192)) < (1631 + 3075)) and (v121 == (0 - 0))) then
				v122 = 72 + 8;
				if (((1200 + 1446) >= (1202 - (192 + 134))) and ((v122 < (1311 - (316 + 960))) or (v13:Rage() < (20 + 15)))) then
					return false;
				end
				v121 = 1 + 0;
			end
			if (((568 + 46) <= (12172 - 8988)) and (v121 == (552 - (83 + 468)))) then
				v123 = false;
				v124 = (v13:Rage() >= (1841 - (1202 + 604))) and not v105();
				v121 = 9 - 7;
			end
		end
	end
	local function v107()
		local v125 = 0 - 0;
		while true do
			if (((8655 - 5529) == (3451 - (45 + 280))) and (v125 == (0 + 0))) then
				if ((v94.BitterImmunity:IsReady() and v60 and (v13:HealthPercentage() <= v70)) or ((1911 + 276) >= (1809 + 3145))) then
					if (v23(v94.BitterImmunity) or ((2146 + 1731) == (629 + 2946))) then
						return "bitter_immunity defensive";
					end
				end
				if (((1308 - 601) > (2543 - (340 + 1571))) and v94.LastStand:IsCastable() and v63 and ((v13:HealthPercentage() <= v73) or v13:ActiveMitigationNeeded())) then
					if (v23(v94.LastStand) or ((216 + 330) >= (4456 - (1733 + 39)))) then
						return "last_stand defensive";
					end
				end
				v125 = 2 - 1;
			end
			if (((2499 - (125 + 909)) <= (6249 - (1096 + 852))) and ((1 + 0) == v125)) then
				if (((2433 - 729) > (1383 + 42)) and v94.IgnorePain:IsReady() and v64 and (v13:HealthPercentage() <= v74) and v103()) then
					if (v23(v94.IgnorePain, nil, nil, true) or ((1199 - (409 + 103)) == (4470 - (46 + 190)))) then
						return "ignore_pain defensive";
					end
				end
				if ((v94.RallyingCry:IsReady() and v65 and v13:BuffDown(v94.AspectsFavorBuff) and v13:BuffDown(v94.RallyingCry) and (((v13:HealthPercentage() <= v75) and v93.IsSoloMode()) or v93.AreUnitsBelowHealthPercentage(v75, v76))) or ((3425 - (51 + 44)) < (404 + 1025))) then
					if (((2464 - (1114 + 203)) >= (1061 - (228 + 498))) and v23(v94.RallyingCry)) then
						return "rallying_cry defensive";
					end
				end
				v125 = 1 + 1;
			end
			if (((1898 + 1537) > (2760 - (174 + 489))) and (v125 == (5 - 3))) then
				if ((v94.Intervene:IsReady() and v66 and (v16:HealthPercentage() <= v77) and (v16:UnitName() ~= v13:UnitName())) or ((5675 - (830 + 1075)) >= (4565 - (303 + 221)))) then
					if (v23(v96.InterveneFocus) or ((5060 - (231 + 1038)) <= (1343 + 268))) then
						return "intervene defensive";
					end
				end
				if ((v94.ShieldWall:IsCastable() and v61 and v13:BuffDown(v94.ShieldWallBuff) and ((v13:HealthPercentage() <= v71) or v13:ActiveMitigationNeeded())) or ((5740 - (171 + 991)) <= (8275 - 6267))) then
					if (((3020 - 1895) <= (5180 - 3104)) and v23(v94.ShieldWall)) then
						return "shield_wall defensive";
					end
				end
				v125 = 3 + 0;
			end
			if (((10 - 7) == v125) or ((2143 - 1400) >= (7090 - 2691))) then
				if (((3570 - 2415) < (2921 - (111 + 1137))) and v95.Healthstone:IsReady() and v67 and (v13:HealthPercentage() <= v79)) then
					if (v23(v96.Healthstone) or ((2482 - (91 + 67)) <= (1720 - 1142))) then
						return "healthstone defensive 3";
					end
				end
				if (((940 + 2827) == (4290 - (423 + 100))) and v68 and (v13:HealthPercentage() <= v80)) then
					local v190 = 0 + 0;
					while true do
						if (((11321 - 7232) == (2132 + 1957)) and (v190 == (771 - (326 + 445)))) then
							if (((19454 - 14996) >= (3729 - 2055)) and (v85 == "Refreshing Healing Potion")) then
								if (((2268 - 1296) <= (2129 - (530 + 181))) and v95.RefreshingHealingPotion:IsReady()) then
									if (v23(v96.RefreshingHealingPotion) or ((5819 - (614 + 267)) < (4794 - (19 + 13)))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v85 == "Dreamwalker's Healing Potion") or ((4075 - 1571) > (9936 - 5672))) then
								if (((6150 - 3997) == (560 + 1593)) and v95.DreamwalkersHealingPotion:IsReady()) then
									if (v23(v96.RefreshingHealingPotion) or ((891 - 384) >= (5373 - 2782))) then
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
		end
	end
	local function v108()
		local v126 = 1812 - (1293 + 519);
		while true do
			if (((9142 - 4661) == (11699 - 7218)) and (v126 == (1 - 0))) then
				v28 = v93.HandleBottomTrinket(v97, v31, 172 - 132, nil);
				if (v28 or ((5484 - 3156) < (368 + 325))) then
					return v28;
				end
				break;
			end
			if (((883 + 3445) == (10055 - 5727)) and ((0 + 0) == v126)) then
				v28 = v93.HandleTopTrinket(v97, v31, 14 + 26, nil);
				if (((993 + 595) >= (2428 - (709 + 387))) and v28) then
					return v28;
				end
				v126 = 1859 - (673 + 1185);
			end
		end
	end
	local function v109()
		if (v14:IsInMeleeRange(23 - 15) or ((13403 - 9229) > (6989 - 2741))) then
			if ((v94.ThunderClap:IsCastable() and v45) or ((3281 + 1305) <= (62 + 20))) then
				if (((5214 - 1351) == (949 + 2914)) and v23(v94.ThunderClap)) then
					return "thunder_clap precombat";
				end
			end
		elseif ((v34 and v94.Charge:IsCastable() and not v14:IsInRange(15 - 7)) or ((553 - 271) <= (1922 - (446 + 1434)))) then
			if (((5892 - (1040 + 243)) >= (2286 - 1520)) and v23(v94.Charge, not v14:IsSpellInRange(v94.Charge))) then
				return "charge precombat";
			end
		end
	end
	local function v110()
		local v127 = 1847 - (559 + 1288);
		while true do
			if (((1932 - (609 + 1322)) == v127) or ((1606 - (13 + 441)) == (9297 - 6809))) then
				if (((8963 - 5541) > (16684 - 13334)) and v94.ThunderClap:IsCastable() and v45 and v13:BuffUp(v94.ViolentOutburstBuff) and (v100 > (1 + 4)) and v13:BuffUp(v94.AvatarBuff) and v94.UnstoppableForce:IsAvailable()) then
					local v191 = 0 - 0;
					while true do
						if (((312 + 565) > (165 + 211)) and (v191 == (0 - 0))) then
							v106(3 + 2);
							if (v23(v94.ThunderClap, not v14:IsInMeleeRange(14 - 6)) or ((2062 + 1056) <= (1030 + 821))) then
								return "thunder_clap aoe 4";
							end
							break;
						end
					end
				end
				if ((v94.Revenge:IsReady() and v40 and (v13:Rage() >= (51 + 19)) and v94.SeismicReverberation:IsAvailable() and (v100 >= (3 + 0))) or ((162 + 3) >= (3925 - (153 + 280)))) then
					if (((11402 - 7453) < (4360 + 496)) and v23(v94.Revenge, not v98)) then
						return "revenge aoe 6";
					end
				end
				v127 = 1 + 1;
			end
			if ((v127 == (2 + 0)) or ((3881 + 395) < (2186 + 830))) then
				if (((7141 - 2451) > (2550 + 1575)) and v94.ShieldSlam:IsCastable() and v42 and ((v13:Rage() <= (727 - (89 + 578))) or (v13:BuffUp(v94.ViolentOutburstBuff) and (v100 <= (6 + 1))))) then
					local v192 = 0 - 0;
					while true do
						if ((v192 == (1049 - (572 + 477))) or ((7 + 43) >= (538 + 358))) then
							v106(3 + 17);
							if (v23(v94.ShieldSlam, not v98) or ((1800 - (84 + 2)) >= (4874 - 1916))) then
								return "shield_slam aoe 8";
							end
							break;
						end
					end
				end
				if ((v94.ThunderClap:IsCastable() and v45) or ((1075 + 416) < (1486 - (497 + 345)))) then
					local v193 = 0 + 0;
					while true do
						if (((120 + 584) < (2320 - (605 + 728))) and (v193 == (0 + 0))) then
							v106(11 - 6);
							if (((171 + 3547) > (7046 - 5140)) and v23(v94.ThunderClap, not v14:IsInMeleeRange(8 + 0))) then
								return "thunder_clap aoe 10";
							end
							break;
						end
					end
				end
				v127 = 7 - 4;
			end
			if ((v127 == (0 + 0)) or ((1447 - (457 + 32)) > (1543 + 2092))) then
				if (((4903 - (832 + 570)) <= (4232 + 260)) and v94.ThunderClap:IsCastable() and v45 and (v14:DebuffRemains(v94.RendDebuff) <= (1 + 0))) then
					local v194 = 0 - 0;
					while true do
						if ((v194 == (0 + 0)) or ((4238 - (588 + 208)) < (6867 - 4319))) then
							v106(1805 - (884 + 916));
							if (((6019 - 3144) >= (849 + 615)) and v23(v94.ThunderClap, not v14:IsInMeleeRange(661 - (232 + 421)))) then
								return "thunder_clap aoe 2";
							end
							break;
						end
					end
				end
				if ((v94.ShieldSlam:IsCastable() and v42 and ((v13:HasTier(1919 - (1569 + 320), 1 + 1) and (v100 <= (2 + 5))) or v13:BuffUp(v94.EarthenTenacityBuff))) or ((16164 - 11367) >= (5498 - (316 + 289)))) then
					if (v23(v94.ShieldSlam, not v98) or ((1442 - 891) > (96 + 1972))) then
						return "shield_slam aoe 3";
					end
				end
				v127 = 1454 - (666 + 787);
			end
			if (((2539 - (360 + 65)) > (883 + 61)) and (v127 == (257 - (79 + 175)))) then
				if ((v94.Revenge:IsReady() and v40 and ((v13:Rage() >= (47 - 17)) or ((v13:Rage() >= (32 + 8)) and v94.BarbaricTraining:IsAvailable()))) or ((6933 - 4671) >= (5962 - 2866))) then
					if (v23(v94.Revenge, not v98) or ((3154 - (503 + 396)) >= (3718 - (92 + 89)))) then
						return "revenge aoe 12";
					end
				end
				break;
			end
		end
	end
	local function v111()
		local v128 = 0 - 0;
		while true do
			if ((v128 == (0 + 0)) or ((2271 + 1566) < (5114 - 3808))) then
				if (((404 + 2546) == (6726 - 3776)) and v94.ShieldSlam:IsCastable() and v42) then
					v106(18 + 2);
					if (v23(v94.ShieldSlam, not v98) or ((2256 + 2467) < (10044 - 6746))) then
						return "shield_slam generic 2";
					end
				end
				if (((142 + 994) >= (234 - 80)) and v94.ThunderClap:IsCastable() and v45 and (v14:DebuffRemains(v94.RendDebuff) <= (1245 - (485 + 759))) and v13:BuffDown(v94.ViolentOutburstBuff)) then
					local v195 = 0 - 0;
					while true do
						if (((1189 - (442 + 747)) == v195) or ((1406 - (832 + 303)) > (5694 - (88 + 858)))) then
							v106(2 + 3);
							if (((3923 + 817) >= (130 + 3022)) and v23(v94.ThunderClap, not v14:IsInMeleeRange(797 - (766 + 23)))) then
								return "thunder_clap generic 4";
							end
							break;
						end
					end
				end
				if ((v94.Execute:IsReady() and v37 and v13:BuffUp(v94.SuddenDeathBuff) and v94.SuddenDeath:IsAvailable()) or ((12726 - 10148) >= (4636 - 1246))) then
					if (((107 - 66) <= (5637 - 3976)) and v23(v94.Execute, not v98)) then
						return "execute generic 6";
					end
				end
				v128 = 1074 - (1036 + 37);
			end
			if (((427 + 174) < (6932 - 3372)) and (v128 == (2 + 0))) then
				if (((1715 - (641 + 839)) < (1600 - (910 + 3))) and v94.Revenge:IsReady() and v40 and (((v13:Rage() >= (152 - 92)) and (v14:HealthPercentage() > (1704 - (1466 + 218)))) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() <= (10 + 10)) and (v13:Rage() <= (1166 - (556 + 592))) and v94.ShieldSlam:CooldownDown()) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() > (8 + 12))) or ((((v13:Rage() >= (868 - (329 + 479))) and (v14:HealthPercentage() > (889 - (174 + 680)))) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() <= (120 - 85)) and (v13:Rage() <= (37 - 19)) and v94.ShieldSlam:CooldownDown()) or (v13:BuffUp(v94.RevengeBuff) and (v14:HealthPercentage() > (25 + 10)))) and v94.Massacre:IsAvailable()))) then
					if (((5288 - (396 + 343)) > (103 + 1050)) and v23(v94.Revenge, not v98)) then
						return "revenge generic 14";
					end
				end
				if ((v94.Execute:IsReady() and v37 and (v100 == (1478 - (29 + 1448)))) or ((6063 - (135 + 1254)) < (17600 - 12928))) then
					if (((17126 - 13458) < (3040 + 1521)) and v23(v94.Execute, not v98)) then
						return "execute generic 16";
					end
				end
				if ((v94.Revenge:IsReady() and v40 and (v14:HealthPercentage() > (1547 - (389 + 1138)))) or ((1029 - (102 + 472)) == (3403 + 202))) then
					if (v23(v94.Revenge, not v98) or ((1477 + 1186) == (3089 + 223))) then
						return "revenge generic 18";
					end
				end
				v128 = 1548 - (320 + 1225);
			end
			if (((7613 - 3336) <= (2739 + 1736)) and (v128 == (1465 - (157 + 1307)))) then
				if ((v94.Execute:IsReady() and v37 and (v100 == (1860 - (821 + 1038))) and (v94.Massacre:IsAvailable() or v94.Juggernaut:IsAvailable()) and (v13:Rage() >= (124 - 74))) or ((96 + 774) == (2111 - 922))) then
					if (((578 + 975) <= (7765 - 4632)) and v23(v94.Execute, not v98)) then
						return "execute generic 6";
					end
				end
				if ((v94.Execute:IsReady() and v37 and (v100 == (1027 - (834 + 192))) and (v13:Rage() >= (4 + 46))) or ((575 + 1662) >= (76 + 3435))) then
					if (v23(v94.Execute, not v98) or ((2050 - 726) > (3324 - (300 + 4)))) then
						return "execute generic 10";
					end
				end
				if ((v94.ThunderClap:IsCastable() and v45 and ((v100 > (1 + 0)) or (v94.ShieldSlam:CooldownDown() and not v13:BuffUp(v94.ViolentOutburstBuff)))) or ((7832 - 4840) == (2243 - (112 + 250)))) then
					v106(2 + 3);
					if (((7781 - 4675) > (875 + 651)) and v23(v94.ThunderClap, not v14:IsInMeleeRange(5 + 3))) then
						return "thunder_clap generic 12";
					end
				end
				v128 = 2 + 0;
			end
			if (((1499 + 1524) < (2875 + 995)) and (v128 == (1417 - (1001 + 413)))) then
				if (((318 - 175) > (956 - (244 + 638))) and v94.ThunderClap:IsCastable() and v45 and ((v100 >= (694 - (627 + 66))) or (v94.ShieldSlam:CooldownDown() and v13:BuffUp(v94.ViolentOutburstBuff)))) then
					v106(14 - 9);
					if (((620 - (512 + 90)) < (4018 - (1665 + 241))) and v23(v94.ThunderClap, not v14:IsInMeleeRange(725 - (373 + 344)))) then
						return "thunder_clap generic 20";
					end
				end
				if (((495 + 602) <= (431 + 1197)) and v94.Devastate:IsCastable() and v36) then
					if (((12212 - 7582) == (7835 - 3205)) and v23(v94.Devastate, not v98)) then
						return "devastate generic 22";
					end
				end
				break;
			end
		end
	end
	local function v112()
		if (((4639 - (35 + 1064)) > (1953 + 730)) and not v13:AffectingCombat()) then
			if (((10256 - 5462) >= (14 + 3261)) and v94.BattleShout:IsCastable() and v33 and (v13:BuffDown(v94.BattleShoutBuff, true) or v93.GroupBuffMissing(v94.BattleShoutBuff))) then
				if (((2720 - (298 + 938)) == (2743 - (233 + 1026))) and v23(v94.BattleShout)) then
					return "battle_shout precombat";
				end
			end
			if (((3098 - (636 + 1030)) < (1818 + 1737)) and v92 and v94.BattleStance:IsCastable() and not v13:BuffUp(v94.BattleStance)) then
				if (v23(v94.BattleStance) or ((1041 + 24) > (1063 + 2515))) then
					return "battle_stance precombat";
				end
			end
		end
		if ((v93.TargetIsValid() and v29) or ((324 + 4471) < (1628 - (55 + 166)))) then
			if (((360 + 1493) < (484 + 4329)) and not v13:AffectingCombat()) then
				local v187 = 0 - 0;
				while true do
					if ((v187 == (297 - (36 + 261))) or ((4933 - 2112) < (3799 - (34 + 1334)))) then
						v28 = v109();
						if (v28 or ((1105 + 1769) < (1695 + 486))) then
							return v28;
						end
						break;
					end
				end
			end
		end
	end
	local function v113()
		v28 = v107();
		if (v28 or ((3972 - (1035 + 248)) <= (364 - (20 + 1)))) then
			return v28;
		end
		if (v84 or ((974 + 895) == (2328 - (134 + 185)))) then
			v28 = v93.HandleIncorporeal(v94.StormBolt, v96.StormBoltMouseover, 1153 - (549 + 584), true);
			if (v28 or ((4231 - (314 + 371)) < (7971 - 5649))) then
				return v28;
			end
			v28 = v93.HandleIncorporeal(v94.IntimidatingShout, v96.IntimidatingShoutMouseover, 976 - (478 + 490), true);
			if (v28 or ((1103 + 979) == (5945 - (786 + 386)))) then
				return v28;
			end
		end
		if (((10507 - 7263) > (2434 - (1055 + 324))) and v93.TargetIsValid()) then
			local v150 = 1340 - (1093 + 247);
			local v151;
			while true do
				if (((4 + 0) == v150) or ((349 + 2964) <= (7058 - 5280))) then
					if (((v89 < v91) and v44 and ((v53 and v31) or not v53) and (v83 == "player") and v94.SpearofBastion:IsCastable()) or ((4822 - 3401) >= (5986 - 3882))) then
						v106(50 - 30);
						if (((645 + 1167) <= (12516 - 9267)) and v23(v96.SpearOfBastionPlayer, not v98)) then
							return "spear_of_bastion main 28";
						end
					end
					if (((5593 - 3970) <= (1476 + 481)) and (v89 < v91) and v44 and ((v53 and v31) or not v53) and (v83 == "cursor") and v94.SpearofBastion:IsCastable()) then
						local v196 = 0 - 0;
						while true do
							if (((5100 - (364 + 324)) == (12094 - 7682)) and (v196 == (0 - 0))) then
								v106(7 + 13);
								if (((7322 - 5572) >= (1347 - 505)) and v23(v96.SpearOfBastionCursor, not v98)) then
									return "spear_of_bastion main 28";
								end
								break;
							end
						end
					end
					if (((13278 - 8906) > (3118 - (1249 + 19))) and (v89 < v91) and v46 and ((v54 and v31) or not v54) and v94.ThunderousRoar:IsCastable()) then
						if (((210 + 22) < (3195 - 2374)) and v23(v94.ThunderousRoar, not v14:IsInMeleeRange(1094 - (686 + 400)))) then
							return "thunderous_roar main 30";
						end
					end
					if (((407 + 111) < (1131 - (73 + 156))) and v94.ShieldSlam:IsCastable() and v42 and v13:BuffUp(v94.FervidBuff)) then
						if (((15 + 2979) > (1669 - (721 + 90))) and v23(v94.ShieldSlam, not v98)) then
							return "shield_slam main 31";
						end
					end
					v150 = 1 + 4;
				end
				if ((v150 == (3 - 2)) or ((4225 - (224 + 246)) <= (1482 - 567))) then
					if (((7265 - 3319) > (679 + 3064)) and (v89 < v91)) then
						if ((v48 and ((v31 and v55) or not v55)) or ((32 + 1303) >= (2429 + 877))) then
							local v200 = 0 - 0;
							while true do
								if (((16119 - 11275) > (2766 - (203 + 310))) and (v200 == (1993 - (1238 + 755)))) then
									v28 = v108();
									if (((32 + 420) == (1986 - (709 + 825))) and v28) then
										return v28;
									end
									break;
								end
							end
						end
					end
					if ((v38 and v94.HeroicThrow:IsCastable() and not v14:IsInRange(55 - 25)) or ((6638 - 2081) < (2951 - (196 + 668)))) then
						if (((15295 - 11421) == (8024 - 4150)) and v23(v94.HeroicThrow, not v14:IsInRange(863 - (171 + 662)))) then
							return "heroic_throw main";
						end
					end
					if ((v94.WreckingThrow:IsCastable() and v47 and v14:AffectingCombat() and v101()) or ((2031 - (4 + 89)) > (17296 - 12361))) then
						if (v23(v94.WreckingThrow, not v14:IsInRange(11 + 19)) or ((18688 - 14433) < (1343 + 2080))) then
							return "wrecking_throw main";
						end
					end
					if (((2940 - (35 + 1451)) <= (3944 - (28 + 1425))) and (v89 < v91) and v32 and ((v50 and v31) or not v50) and v94.Avatar:IsCastable()) then
						if (v23(v94.Avatar) or ((6150 - (941 + 1052)) <= (2688 + 115))) then
							return "avatar main 2";
						end
					end
					v150 = 1516 - (822 + 692);
				end
				if (((6927 - 2074) >= (1405 + 1577)) and ((300 - (45 + 252)) == v150)) then
					if (((4091 + 43) > (1156 + 2201)) and v102() and v63 and v94.LastStand:IsCastable() and v13:BuffDown(v94.ShieldWallBuff) and (((v14:HealthPercentage() >= (219 - 129)) and v94.UnnervingFocus:IsAvailable()) or ((v14:HealthPercentage() <= (453 - (114 + 319))) and v94.UnnervingFocus:IsAvailable()) or v94.Bolster:IsAvailable() or v13:HasTier(43 - 13, 2 - 0))) then
						if (v23(v94.LastStand) or ((2179 + 1238) < (3774 - 1240))) then
							return "last_stand defensive";
						end
					end
					if (((v89 < v91) and v39 and ((v51 and v31) or not v51) and (v82 == "player") and v94.Ravager:IsCastable()) or ((5703 - 2981) <= (2127 - (556 + 1407)))) then
						v106(1216 - (741 + 465));
						if (v23(v96.RavagerPlayer, not v98) or ((2873 - (170 + 295)) < (1112 + 997))) then
							return "ravager main 24";
						end
					end
					if (((v89 < v91) and v39 and ((v51 and v31) or not v51) and (v82 == "cursor") and v94.Ravager:IsCastable()) or ((31 + 2) == (3582 - 2127))) then
						v106(9 + 1);
						if (v23(v96.RavagerCursor, not v98) or ((285 + 158) >= (2274 + 1741))) then
							return "ravager main 24";
						end
					end
					if (((4612 - (957 + 273)) > (45 + 121)) and v94.DemoralizingShout:IsCastable() and v35 and v94.BoomingVoice:IsAvailable()) then
						local v197 = 0 + 0;
						while true do
							if ((v197 == (0 - 0)) or ((737 - 457) == (9343 - 6284))) then
								v106(148 - 118);
								if (((3661 - (389 + 1391)) > (812 + 481)) and v23(v94.DemoralizingShout, not v98)) then
									return "demoralizing_shout main 28";
								end
								break;
							end
						end
					end
					v150 = 1 + 3;
				end
				if (((5365 - 3008) == (3308 - (783 + 168))) and (v150 == (6 - 4))) then
					if (((121 + 2) == (434 - (309 + 2))) and (v89 < v91) and v49 and ((v56 and v31) or not v56)) then
						local v198 = 0 - 0;
						while true do
							if ((v198 == (1213 - (1090 + 122))) or ((343 + 713) >= (11391 - 7999))) then
								if (v94.ArcaneTorrent:IsCastable() or ((740 + 341) < (2193 - (628 + 490)))) then
									if (v23(v94.ArcaneTorrent) or ((189 + 860) >= (10972 - 6540))) then
										return "arcane_torrent main 8";
									end
								end
								if (v94.LightsJudgment:IsCastable() or ((21789 - 17021) <= (1620 - (431 + 343)))) then
									if (v23(v94.LightsJudgment) or ((6781 - 3423) <= (4107 - 2687))) then
										return "lights_judgment main 10";
									end
								end
								v198 = 2 + 0;
							end
							if ((v198 == (1 + 1)) or ((5434 - (556 + 1139)) <= (3020 - (6 + 9)))) then
								if (v94.Fireblood:IsCastable() or ((304 + 1355) >= (1094 + 1040))) then
									if (v23(v94.Fireblood) or ((3429 - (28 + 141)) < (913 + 1442))) then
										return "fireblood main 12";
									end
								end
								if (v94.AncestralCall:IsCastable() or ((824 - 155) == (2991 + 1232))) then
									if (v23(v94.AncestralCall) or ((3009 - (486 + 831)) < (1530 - 942))) then
										return "ancestral_call main 14";
									end
								end
								v198 = 10 - 7;
							end
							if ((v198 == (1 + 2)) or ((15167 - 10370) < (4914 - (668 + 595)))) then
								if (v94.BagofTricks:IsCastable() or ((3759 + 418) > (978 + 3872))) then
									if (v23(v94.BagofTricks) or ((1090 - 690) > (1401 - (23 + 267)))) then
										return "ancestral_call main 16";
									end
								end
								break;
							end
							if (((4995 - (1129 + 815)) > (1392 - (371 + 16))) and (v198 == (1750 - (1326 + 424)))) then
								if (((6993 - 3300) <= (16012 - 11630)) and v94.BloodFury:IsCastable()) then
									if (v23(v94.BloodFury) or ((3400 - (88 + 30)) > (4871 - (720 + 51)))) then
										return "blood_fury main 4";
									end
								end
								if (v94.Berserking:IsCastable() or ((7963 - 4383) < (4620 - (421 + 1355)))) then
									if (((146 - 57) < (2206 + 2284)) and v23(v94.Berserking)) then
										return "berserking main 6";
									end
								end
								v198 = 1084 - (286 + 797);
							end
						end
					end
					v151 = v93.HandleDPSPotion(v14:BuffUp(v94.AvatarBuff));
					if (v151 or ((18215 - 13232) < (2994 - 1186))) then
						return v151;
					end
					if (((4268 - (397 + 42)) > (1178 + 2591)) and v94.IgnorePain:IsReady() and v64 and v103() and (v14:HealthPercentage() >= (820 - (24 + 776))) and (((v13:RageDeficit() <= (23 - 8)) and v94.ShieldSlam:CooldownUp()) or ((v13:RageDeficit() <= (825 - (222 + 563))) and v94.ShieldCharge:CooldownUp() and v94.ChampionsBulwark:IsAvailable()) or ((v13:RageDeficit() <= (44 - 24)) and v94.ShieldCharge:CooldownUp()) or ((v13:RageDeficit() <= (22 + 8)) and v94.DemoralizingShout:CooldownUp() and v94.BoomingVoice:IsAvailable()) or ((v13:RageDeficit() <= (210 - (23 + 167))) and v94.Avatar:CooldownUp()) or ((v13:RageDeficit() <= (1843 - (690 + 1108))) and v94.DemoralizingShout:CooldownUp() and v94.BoomingVoice:IsAvailable() and v13:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable()) or ((v13:RageDeficit() <= (11 + 19)) and v94.Avatar:CooldownUp() and v13:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable()) or (v13:RageDeficit() <= (17 + 3)) or ((v13:RageDeficit() <= (888 - (40 + 808))) and v94.ShieldSlam:CooldownUp() and v13:BuffUp(v94.ViolentOutburstBuff) and v94.HeavyRepercussions:IsAvailable() and v94.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (10 + 45)) and v94.ShieldSlam:CooldownUp() and v13:BuffUp(v94.ViolentOutburstBuff) and v13:BuffUp(v94.LastStandBuff) and v94.UnnervingFocus:IsAvailable() and v94.HeavyRepercussions:IsAvailable() and v94.ImpenetrableWall:IsAvailable()) or ((v13:RageDeficit() <= (64 - 47)) and v94.ShieldSlam:CooldownUp() and v94.HeavyRepercussions:IsAvailable()) or ((v13:RageDeficit() <= (18 + 0)) and v94.ShieldSlam:CooldownUp() and v94.ImpenetrableWall:IsAvailable()))) then
						if (((786 + 699) <= (1593 + 1311)) and v23(v94.IgnorePain, nil, nil, true)) then
							return "ignore_pain main 20";
						end
					end
					v150 = 574 - (47 + 524);
				end
				if (((2771 + 1498) == (11669 - 7400)) and (v150 == (7 - 2))) then
					if (((882 - 495) <= (4508 - (1165 + 561))) and ((v94.Shockwave:IsCastable() and v43 and v13:BuffUp(v94.AvatarBuff) and v94.UnstoppableForce:IsAvailable() and not v94.RumblingEarth:IsAvailable()) or (v94.SonicBoom:IsAvailable() and v94.RumblingEarth:IsAvailable() and (v100 >= (1 + 2)) and v14:IsCasting()))) then
						v106(30 - 20);
						if (v23(v94.Shockwave, not v14:IsInMeleeRange(4 + 4)) or ((2378 - (341 + 138)) <= (248 + 669))) then
							return "shockwave main 32";
						end
					end
					if (((v89 < v91) and v94.ShieldCharge:IsCastable() and v41 and ((v52 and v31) or not v52)) or ((8898 - 4586) <= (1202 - (89 + 237)))) then
						if (((7180 - 4948) <= (5465 - 2869)) and v23(v94.ShieldCharge, not v14:IsSpellInRange(v94.ShieldCharge))) then
							return "shield_charge main 34";
						end
					end
					if (((2976 - (581 + 300)) < (4906 - (855 + 365))) and v105() and v62) then
						if (v23(v94.ShieldBlock) or ((3788 - 2193) >= (1461 + 3013))) then
							return "shield_block main 38";
						end
					end
					if ((v100 > (1238 - (1030 + 205))) or ((4337 + 282) < (2682 + 200))) then
						local v199 = 286 - (156 + 130);
						while true do
							if ((v199 == (0 - 0)) or ((495 - 201) >= (9894 - 5063))) then
								v28 = v110();
								if (((535 + 1494) <= (1799 + 1285)) and v28) then
									return v28;
								end
								v199 = 70 - (10 + 59);
							end
							if ((v199 == (1 + 0)) or ((10031 - 7994) == (3583 - (671 + 492)))) then
								if (((3549 + 909) > (5119 - (369 + 846))) and v19.CastAnnotated(v94.Pool, false, "WAIT")) then
									return "Pool for Aoe()";
								end
								break;
							end
						end
					end
					v150 = 2 + 4;
				end
				if (((373 + 63) >= (2068 - (1036 + 909))) and (v150 == (5 + 1))) then
					v28 = v111();
					if (((839 - 339) < (2019 - (11 + 192))) and v28) then
						return v28;
					end
					if (((1807 + 1767) == (3749 - (135 + 40))) and v19.CastAnnotated(v94.Pool, false, "WAIT")) then
						return "Wait/Pool Resources";
					end
					break;
				end
				if (((535 - 314) < (236 + 154)) and (v150 == (0 - 0))) then
					if ((v92 and (v13:HealthPercentage() <= v78)) or ((3317 - 1104) <= (1597 - (50 + 126)))) then
						if (((8515 - 5457) < (1076 + 3784)) and v94.DefensiveStance:IsCastable() and not v13:BuffUp(v94.DefensiveStance)) then
							if (v23(v94.DefensiveStance) or ((2709 - (1233 + 180)) >= (5415 - (522 + 447)))) then
								return "defensive_stance while tanking";
							end
						end
					end
					if ((v92 and (v13:HealthPercentage() > v78)) or ((2814 - (107 + 1314)) > (2084 + 2405))) then
						if ((v94.BattleStance:IsCastable() and not v13:BuffUp(v94.BattleStance)) or ((13480 - 9056) < (12 + 15))) then
							if (v23(v94.BattleStance) or ((3965 - 1968) > (15094 - 11279))) then
								return "battle_stance while not tanking";
							end
						end
					end
					if (((5375 - (716 + 1194)) > (33 + 1880)) and v41 and ((v52 and v31) or not v52) and (v89 < v91) and v94.ShieldCharge:IsCastable() and not v98) then
						if (((79 + 654) < (2322 - (74 + 429))) and v23(v94.ShieldCharge, not v14:IsSpellInRange(v94.ShieldCharge))) then
							return "shield_charge main 34";
						end
					end
					if ((v34 and v94.Charge:IsCastable() and not v98) or ((8478 - 4083) == (2357 + 2398))) then
						if (v23(v94.Charge, not v14:IsSpellInRange(v94.Charge)) or ((8682 - 4889) < (1677 + 692))) then
							return "charge main 34";
						end
					end
					v150 = 2 - 1;
				end
			end
		end
	end
	local function v114()
		local v129 = 0 - 0;
		while true do
			if ((v129 == (436 - (279 + 154))) or ((4862 - (454 + 324)) == (209 + 56))) then
				v45 = EpicSettings.Settings['useThunderClap'];
				v47 = EpicSettings.Settings['useWreckingThrow'];
				v32 = EpicSettings.Settings['useAvatar'];
				v129 = 21 - (12 + 5);
			end
			if (((2350 + 2008) == (11104 - 6746)) and (v129 == (0 + 0))) then
				v33 = EpicSettings.Settings['useBattleShout'];
				v34 = EpicSettings.Settings['useCharge'];
				v35 = EpicSettings.Settings['useDemoralizingShout'];
				v129 = 1094 - (277 + 816);
			end
			if ((v129 == (4 - 3)) or ((4321 - (1058 + 125)) < (187 + 806))) then
				v36 = EpicSettings.Settings['useDevastate'];
				v37 = EpicSettings.Settings['useExecute'];
				v38 = EpicSettings.Settings['useHeroicThrow'];
				v129 = 977 - (815 + 160);
			end
			if (((14287 - 10957) > (5514 - 3191)) and (v129 == (2 + 4))) then
				v52 = EpicSettings.Settings['shieldChargeWithCD'];
				v53 = EpicSettings.Settings['spearOfBastionWithCD'];
				v54 = EpicSettings.Settings['thunderousRoarWithCD'];
				break;
			end
			if ((v129 == (5 - 3)) or ((5524 - (41 + 1857)) == (5882 - (1222 + 671)))) then
				v40 = EpicSettings.Settings['useRevenge'];
				v42 = EpicSettings.Settings['useShieldSlam'];
				v43 = EpicSettings.Settings['useShockwave'];
				v129 = 7 - 4;
			end
			if ((v129 == (5 - 1)) or ((2098 - (229 + 953)) == (4445 - (1111 + 663)))) then
				v39 = EpicSettings.Settings['useRavager'];
				v41 = EpicSettings.Settings['useShieldCharge'];
				v44 = EpicSettings.Settings['useSpearOfBastion'];
				v129 = 1584 - (874 + 705);
			end
			if (((39 + 233) == (186 + 86)) and (v129 == (10 - 5))) then
				v46 = EpicSettings.Settings['useThunderousRoar'];
				v50 = EpicSettings.Settings['avatarWithCD'];
				v51 = EpicSettings.Settings['ravagerWithCD'];
				v129 = 1 + 5;
			end
		end
	end
	local function v115()
		local v130 = 679 - (642 + 37);
		while true do
			if (((969 + 3280) <= (775 + 4064)) and (v130 == (7 - 4))) then
				v61 = EpicSettings.Settings['useShieldWall'];
				v69 = EpicSettings.Settings['useVictoryRush'];
				v92 = EpicSettings.Settings['useChangeStance'];
				v130 = 458 - (233 + 221);
			end
			if (((6421 - 3644) < (2817 + 383)) and (v130 == (1542 - (718 + 823)))) then
				v60 = EpicSettings.Settings['useBitterImmunity'];
				v64 = EpicSettings.Settings['useIgnorePain'];
				v66 = EpicSettings.Settings['useIntervene'];
				v130 = 2 + 0;
			end
			if (((900 - (266 + 539)) < (5540 - 3583)) and (v130 == (1225 - (636 + 589)))) then
				v57 = EpicSettings.Settings['usePummel'];
				v58 = EpicSettings.Settings['useStormBolt'];
				v59 = EpicSettings.Settings['useIntimidatingShout'];
				v130 = 2 - 1;
			end
			if (((1703 - 877) < (1361 + 356)) and (v130 == (2 + 3))) then
				v73 = EpicSettings.Settings['lastStandHP'] or (1015 - (657 + 358));
				v76 = EpicSettings.Settings['rallyingCryGroup'] or (0 - 0);
				v75 = EpicSettings.Settings['rallyingCryHP'] or (0 - 0);
				v130 = 1193 - (1151 + 36);
			end
			if (((1378 + 48) >= (291 + 814)) and (v130 == (11 - 7))) then
				v70 = EpicSettings.Settings['bitterImmunityHP'] or (1832 - (1552 + 280));
				v74 = EpicSettings.Settings['ignorePainHP'] or (834 - (64 + 770));
				v77 = EpicSettings.Settings['interveneHP'] or (0 + 0);
				v130 = 11 - 6;
			end
			if (((489 + 2265) <= (4622 - (157 + 1086))) and (v130 == (13 - 6))) then
				v78 = EpicSettings.Settings['defensiveStanceHP'] or (0 - 0);
				v82 = EpicSettings.Settings['ravagerSetting'] or "";
				v83 = EpicSettings.Settings['spearSetting'] or "";
				break;
			end
			if ((v130 == (2 - 0)) or ((5359 - 1432) == (2232 - (599 + 220)))) then
				v63 = EpicSettings.Settings['useLastStand'];
				v65 = EpicSettings.Settings['useRallyingCry'];
				v62 = EpicSettings.Settings['useShieldBlock'];
				v130 = 5 - 2;
			end
			if ((v130 == (1937 - (1813 + 118))) or ((844 + 310) <= (2005 - (841 + 376)))) then
				v72 = EpicSettings.Settings['shieldBlockHP'] or (0 - 0);
				v71 = EpicSettings.Settings['shieldWallHP'] or (0 + 0);
				v81 = EpicSettings.Settings['victoryRushHP'] or (0 - 0);
				v130 = 866 - (464 + 395);
			end
		end
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
		v79 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v80 = EpicSettings.Settings['healingPotionHP'] or (837 - (467 + 370));
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
		if (v13:IsDeadOrGhost() or ((3394 - 1751) > (2481 + 898))) then
			return v28;
		end
		if (v30 or ((9608 - 6805) > (710 + 3839))) then
			local v152 = 0 - 0;
			while true do
				if ((v152 == (520 - (150 + 370))) or ((1502 - (74 + 1208)) >= (7432 - 4410))) then
					v99 = v13:GetEnemiesInMeleeRange(37 - 29);
					v100 = #v99;
					break;
				end
			end
		else
			v100 = 1 + 0;
		end
		v98 = v14:IsInMeleeRange(398 - (14 + 376));
		if (((4894 - 2072) == (1827 + 995)) and (v93.TargetIsValid() or v13:AffectingCombat())) then
			local v153 = 0 + 0;
			while true do
				if ((v153 == (1 + 0)) or ((3108 - 2047) == (1398 + 459))) then
					if (((2838 - (23 + 55)) > (3232 - 1868)) and (v91 == (7415 + 3696))) then
						v91 = v10.FightRemains(v99, false);
					end
					break;
				end
				if ((v153 == (0 + 0)) or ((7600 - 2698) <= (1131 + 2464))) then
					v90 = v10.BossFightRemains(nil, true);
					v91 = v90;
					v153 = 902 - (652 + 249);
				end
			end
		end
		if (not v13:IsChanneling() or ((10308 - 6456) == (2161 - (708 + 1160)))) then
			if (v13:AffectingCombat() or ((4231 - 2672) == (8364 - 3776))) then
				local v188 = 27 - (10 + 17);
				while true do
					if ((v188 == (0 + 0)) or ((6216 - (1400 + 332)) == (1511 - 723))) then
						v28 = v113();
						if (((6476 - (242 + 1666)) >= (1672 + 2235)) and v28) then
							return v28;
						end
						break;
					end
				end
			else
				v28 = v112();
				if (((457 + 789) < (2958 + 512)) and v28) then
					return v28;
				end
			end
		end
	end
	local function v118()
		v19.Print("Protection Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(1013 - (850 + 90), v117, v118);
end;
return v0["Epix_Warrior_Protection.lua"]();

