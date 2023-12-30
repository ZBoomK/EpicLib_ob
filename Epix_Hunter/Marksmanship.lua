local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((565 + 489) <= (14830 - 11359)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((3342 - (404 + 1335)) <= (1082 - (183 + 223)))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if (((2275 + 1158) <= (1489 + 2647)) and (v5 == (338 - (10 + 327)))) then
			return v6(...);
		end
	end
end
v0["Epix_Hunter_Marksmanship.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v12.Focus;
	local v16 = v12.MouseOver;
	local v17 = v12.Pet;
	local v18 = v10.Spell;
	local v19 = v10.MultiSpell;
	local v20 = v10.Item;
	local v21 = v10.Bind;
	local v22 = v10.Macro;
	local v23 = v10.AoEON;
	local v24 = v10.CDsON;
	local v25 = v10.Cast;
	local v26 = v10.Press;
	local v27 = GetTime;
	local v28 = v10.Commons.Hunter;
	local v29 = v10.Commons.Everyone.num;
	local v30 = v10.Commons.Everyone.bool;
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
	local function v54()
		local v93 = 0 + 0;
		while true do
			if (((4583 - (118 + 220)) <= (1544 + 3087)) and (v93 == (449 - (108 + 341)))) then
				v34 = EpicSettings.Settings['UseRacials'];
				v36 = EpicSettings.Settings['UseHealingPotion'];
				v37 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v93 = 4 - 3;
			end
			if (((5769 - (711 + 782)) >= (7502 - 3588)) and (v93 == (475 - (270 + 199)))) then
				v53 = EpicSettings.Settings['UseVolley'];
				break;
			end
			if (((65 + 133) <= (6184 - (580 + 1239))) and (v93 == (14 - 9))) then
				v50 = EpicSettings.Settings['UseExhilaration'];
				v51 = EpicSettings.Settings['ExhilarationHP'] or (0 + 0);
				v52 = EpicSettings.Settings['UseTranq'];
				v93 = 1 + 5;
			end
			if (((2084 + 2698) > (12208 - 7532)) and (v93 == (3 + 1))) then
				v47 = EpicSettings.Settings['UseRevive'];
				v48 = EpicSettings.Settings['UseMendPet'];
				v49 = EpicSettings.Settings['MendPetHP'] or (1167 - (645 + 522));
				v93 = 1795 - (1010 + 780);
			end
			if (((4862 + 2) > (10466 - 8269)) and (v93 == (5 - 3))) then
				v41 = EpicSettings.Settings['InterruptWithStun'] or (1836 - (1045 + 791));
				v42 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v43 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v93 = 508 - (351 + 154);
			end
			if ((v93 == (1575 - (1281 + 293))) or ((3966 - (28 + 238)) == (5601 - 3094))) then
				v38 = EpicSettings.Settings['HealingPotionHP'] or (1559 - (1381 + 178));
				v39 = EpicSettings.Settings['UseHealthstone'];
				v40 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v93 = 2 + 0;
			end
			if (((1909 + 2565) >= (944 - 670)) and (v93 == (2 + 1))) then
				v44 = EpicSettings.Settings['UsePet'];
				v45 = EpicSettings.Settings['SummonPetSlot'] or (470 - (381 + 89));
				v46 = EpicSettings.Settings['UseSteelTrap'];
				v93 = 4 + 0;
			end
		end
	end
	local v55 = v18.Hunter.Marksmanship;
	local v56 = v20.Hunter.Marksmanship;
	local v57 = v22.Hunter.Marksmanship;
	local v58 = {v55.SummonPet,v55.SummonPet2,v55.SummonPet3,v55.SummonPet4,v55.SummonPet5};
	local v59 = {};
	local v60 = v13:GetEquipment();
	local v61 = (v60[1468 - (990 + 465)] and v20(v60[6 + 7])) or v20(0 + 0);
	local v62 = (v60[14 + 0] and v20(v60[55 - 41])) or v20(1726 - (1668 + 58));
	local v63 = {LastCast=(626 - (512 + 114)),Count=(0 - 0)};
	local v64;
	local v65 = 22970 - 11859;
	local v66 = 38662 - 27551;
	local v67;
	local v68;
	local v69;
	local v70;
	local v71 = v10.Commons.Everyone;
	local v72 = (v14:HealthPercentage() > (33 + 37)) and v55.CarefulAim:IsAvailable();
	local v73 = {{v55.Intimidation,"Cast Intimidation (Interrupt)",function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		local v94 = 1469 - (1269 + 200);
		while true do
			if (((1 - 0) == v94) or ((2709 - (98 + 717)) <= (2232 - (802 + 24)))) then
				v62 = (v60[23 - 9] and v20(v60[16 - 2])) or v20(0 + 0);
				break;
			end
			if (((1208 + 364) >= (252 + 1279)) and (v94 == (0 + 0))) then
				v60 = v13:GetEquipment();
				v61 = (v60[36 - 23] and v20(v60[43 - 30])) or v20(0 + 0);
				v94 = 1 + 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v63 = {LastCast=(0 + 0),Count=(0 + 0)};
		v65 = 5188 + 5923;
		v66 = 12544 - (797 + 636);
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v95 = 0 - 0;
		while true do
			if (((1619 - (1427 + 192)) == v95) or ((1625 + 3062) < (10545 - 6003))) then
				v55.SerpentSting:RegisterInFlight();
				v55.SteadyShot:RegisterInFlight();
				v95 = 1 + 0;
			end
			if (((1492 + 1799) > (1993 - (192 + 134))) and (v95 == (1277 - (316 + 960)))) then
				v55.AimedShot:RegisterInFlight();
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v55.SerpentSting:RegisterInFlight();
	v55.SteadyShot:RegisterInFlight();
	v55.AimedShot:RegisterInFlight();
	local function v74()
		return (v13:BuffUp(v55.TrickShotsBuff) and not v13:IsCasting(v55.AimedShot) and not v13:IsChanneling(v55.RapidFire)) or v13:BuffUp(v55.VolleyBuff);
	end
	local function v75()
		local v96 = 0 + 0;
		while true do
			if ((v96 == (0 + 0)) or ((807 + 66) == (7775 - 5741))) then
				if ((((v63.Count == (551 - (83 + 468))) or (v63.Count == (1807 - (1202 + 604)))) and v13:IsCasting(v55.SteadyShot) and (v63.LastCast < (v27() - v55.SteadyShot:CastTime()))) or ((13145 - 10329) < (18 - 7))) then
					local v127 = 0 - 0;
					while true do
						if (((4024 - (45 + 280)) < (4543 + 163)) and (v127 == (0 + 0))) then
							v63.LastCast = v27();
							v63.Count = v63.Count + 1 + 0;
							break;
						end
					end
				end
				if (((1465 + 1181) >= (155 + 721)) and not (v13:IsCasting(v55.SteadyShot) or v13:PrevGCDP(1 - 0, v55.SteadyShot))) then
					v63.Count = 1911 - (340 + 1571);
				end
				v96 = 1 + 0;
			end
			if (((2386 - (1733 + 39)) <= (8749 - 5565)) and ((1035 - (125 + 909)) == v96)) then
				if (((5074 - (1096 + 852)) == (1403 + 1723)) and (v55.SteadyFocusBuff.LastAppliedOnPlayerTime > v63.LastCast)) then
					v63.Count = 0 - 0;
				end
				break;
			end
		end
	end
	local function v76(v97)
		return (v97:DebuffRemains(v55.SerpentStingDebuff));
	end
	local function v77(v98)
		return v98:DebuffRemains(v55.SerpentStingDebuff) + (v29(v55.SerpentSting:InFlight()) * (97 + 2));
	end
	local function v78(v99)
		return (v99:DebuffStack(v55.LatentPoisonDebuff));
	end
	local function v79(v100)
		return v100:DebuffRefreshable(v55.SerpentStingDebuff) and not v55.SerpentstalkersTrickery:IsAvailable();
	end
	local function v80(v101)
		return v101:DebuffRefreshable(v55.SerpentStingDebuff) and v55.HydrasBite:IsAvailable() and not v55.SerpentstalkersTrickery:IsAvailable();
	end
	local function v81(v102)
		return v102:DebuffRefreshable(v55.SerpentStingDebuff) and v55.PoisonInjection:IsAvailable() and not v55.SerpentstalkersTrickery:IsAvailable();
	end
	local function v82(v103)
		return v55.SerpentstalkersTrickery:IsAvailable() and (v13:BuffDown(v55.PreciseShotsBuff) or ((v13:BuffUp(v55.TrueshotBuff) or (v55.AimedShot:FullRechargeTime() < (v13:GCD() + v55.AimedShot:CastTime()))) and (not v55.ChimaeraShot:IsAvailable() or (v69 < (514 - (409 + 103))))) or ((v13:BuffRemains(v55.TrickShotsBuff) > v55.AimedShot:ExecuteTime()) and (v69 > (237 - (46 + 190)))));
	end
	local function v83(v104)
		return v13:BuffDown(v55.PreciseShotsBuff) or ((v13:BuffUp(v55.TrueshotBuff) or (v55.AimedShot:FullRechargeTime() < (v13:GCD() + v55.AimedShot:CastTime()))) and (not v55.ChimaeraShot:IsAvailable() or (v69 < (97 - (51 + 44))))) or ((v13:BuffRemains(v55.TrickShotsBuff) > v55.AimedShot:ExecuteTime()) and (v69 > (1 + 0)));
	end
	local function v84(v105)
		return v55.SerpentstalkersTrickery:IsAvailable() and (v13:BuffRemains(v55.TrickShotsBuff) >= v55.AimedShot:ExecuteTime()) and (v13:BuffDown(v55.PreciseShotsBuff) or v13:BuffUp(v55.TrueshotBuff) or (v55.AimedShot:FullRechargeTime() < (v55.AimedShot:CastTime() + v13:GCD())));
	end
	local function v85(v106)
		return (v13:BuffRemains(v55.TrickShotsBuff) >= v55.AimedShot:ExecuteTime()) and (v13:BuffDown(v55.PreciseShotsBuff) or v13:BuffUp(v55.TrueshotBuff) or (v55.AimedShot:FullRechargeTime() < (v55.AimedShot:CastTime() + v13:GCD())));
	end
	local function v86()
		if ((v15 and v15:Exists() and v55.Misdirection:IsReady()) or ((3504 - (1114 + 203)) >= (5680 - (228 + 498)))) then
			if (v26(v57.MisdirectionFocus) or ((840 + 3037) == (1976 + 1599))) then
				return "misdirection opener";
			end
		end
		if (((1370 - (174 + 489)) > (1646 - 1014)) and v55.SummonPet:IsCastable() and not v55.LoneWolf:IsAvailable() and v44) then
			if (v26(v58[v45]) or ((2451 - (830 + 1075)) >= (3208 - (303 + 221)))) then
				return "Summon Pet opener";
			end
		end
		if (((2734 - (231 + 1038)) <= (3585 + 716)) and v55.Salvo:IsCastable() and v33) then
			if (((2866 - (171 + 991)) > (5872 - 4447)) and v26(v55.Salvo)) then
				return "salvo opener";
			end
		end
		if ((v55.AimedShot:IsReady() and not v13:IsCasting(v55.AimedShot) and (v69 < (7 - 4)) and (not v55.Volley:IsAvailable() or (v69 < (4 - 2)))) or ((550 + 137) == (14841 - 10607))) then
			if (v26(v55.AimedShot, not v70, true) or ((9606 - 6276) < (2302 - 873))) then
				return "aimed_shot opener";
			end
		end
		if (((3545 - 2398) >= (1583 - (111 + 1137))) and v55.WailingArrow:IsReady() and not v13:IsCasting(v55.WailingArrow) and ((v69 > (160 - (91 + 67))) or not v55.SteadyFocus:IsAvailable())) then
			if (((10223 - 6788) > (524 + 1573)) and v26(v55.WailingArrow, not v70, true)) then
				return "wailing_arrow opener";
			end
		end
		if ((v55.SteadyShot:IsCastable() and ((v69 > (525 - (423 + 100))) or (v55.Volley:IsAvailable() and (v69 == (1 + 1))))) or ((10438 - 6668) >= (2107 + 1934))) then
			if (v26(v55.SteadyShot, not v70) or ((4562 - (326 + 445)) <= (7030 - 5419))) then
				return "steady_shot opener";
			end
		end
	end
	local function v87()
		local v107 = 0 - 0;
		while true do
			if ((v107 == (4 - 2)) or ((5289 - (530 + 181)) <= (2889 - (614 + 267)))) then
				if (((1157 - (19 + 13)) <= (3378 - 1302)) and v55.LightsJudgment:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) then
					if (v26(v55.LightsJudgment, not v14:IsSpellInRange(v55.LightsJudgment)) or ((1730 - 987) >= (12566 - 8167))) then
						return "lights_judgment cds 10";
					end
				end
				if (((300 + 855) < (2941 - 1268)) and v55.Salvo:IsCastable() and ((v69 > (3 - 1)) or (v55.Volley:CooldownRemains() < (1822 - (1293 + 519))))) then
					if (v26(v55.Salvo) or ((4741 - 2417) <= (1508 - 930))) then
						return "salvo cds 14";
					end
				end
				break;
			end
			if (((7203 - 3436) == (16243 - 12476)) and ((2 - 1) == v107)) then
				if (((2166 + 1923) == (835 + 3254)) and v55.AncestralCall:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v55.Trueshot:CooldownRemains() > (69 - 39)) or (v66 < (4 + 12)))) then
					if (((1481 + 2977) >= (1047 + 627)) and v26(v55.AncestralCall)) then
						return "ancestral_call cds 6";
					end
				end
				if (((2068 - (709 + 387)) <= (3276 - (673 + 1185))) and v55.Fireblood:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v55.Trueshot:CooldownRemains() > (87 - 57)) or (v66 < (28 - 19)))) then
					if (v26(v55.Fireblood) or ((8124 - 3186) < (3407 + 1355))) then
						return "fireblood cds 8";
					end
				end
				v107 = 2 + 0;
			end
			if ((v107 == (0 - 0)) or ((615 + 1889) > (8501 - 4237))) then
				if (((4225 - 2072) == (4033 - (446 + 1434))) and v55.Berserking:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v66 < (1296 - (1040 + 243))))) then
					if (v26(v55.Berserking) or ((1513 - 1006) >= (4438 - (559 + 1288)))) then
						return "berserking cds 2";
					end
				end
				if (((6412 - (609 + 1322)) == (4935 - (13 + 441))) and v55.BloodFury:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v55.Trueshot:CooldownRemains() > (112 - 82)) or (v66 < (41 - 25)))) then
					if (v26(v55.BloodFury) or ((11594 - 9266) < (26 + 667))) then
						return "blood_fury cds 4";
					end
				end
				v107 = 3 - 2;
			end
		end
	end
	local function v88()
		local v108 = 0 + 0;
		while true do
			if (((1897 + 2431) == (12843 - 8515)) and (v108 == (2 + 0))) then
				if (((2920 - 1332) >= (881 + 451)) and v55.SerpentSting:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) then
					if (v71.CastTargetIf(v55.SerpentSting, v67, "min", v76, v79, not v70, nil, nil, v57.SerpentStingMouseover) or ((2322 + 1852) > (3053 + 1195))) then
						return "serpent_sting st 8";
					end
				end
				if (v55.ExplosiveShot:IsReady() or ((3851 + 735) <= (81 + 1))) then
					if (((4296 - (153 + 280)) == (11154 - 7291)) and v26(v55.ExplosiveShot, not v70)) then
						return "explosive_shot st 10";
					end
				end
				if ((v55.Stampede:IsCastable() and v33) or ((254 + 28) <= (17 + 25))) then
					if (((2412 + 2197) >= (696 + 70)) and v26(v55.Stampede, not v14:IsInRange(22 + 8))) then
						return "stampede st 14";
					end
				end
				v108 = 4 - 1;
			end
			if ((v108 == (0 + 0)) or ((1819 - (89 + 578)) == (1778 + 710))) then
				if (((7113 - 3691) > (4399 - (572 + 477))) and v55.SteadyShot:IsCastable() and v55.SteadyFocus:IsAvailable() and (((v63.Count == (1 + 0)) and (v13:BuffRemains(v55.SteadyFocusBuff) < (4 + 1))) or (v13:BuffDown(v55.SteadyFocusBuff) and v13:BuffDown(v55.TrueshotBuff) and (v63.Count ~= (1 + 1))))) then
					if (((963 - (84 + 2)) > (619 - 243)) and v26(v55.SteadyShot, not v70)) then
						return "steady_shot st 2";
					end
				end
				if ((v55.AimedShot:IsReady() and v13:BuffUp(v55.TrueshotBuff) and (v55.AimedShot:FullRechargeTime() < (v13:GCD() + v55.AimedShot:CastTime())) and v55.LegacyoftheWindrunners:IsAvailable() and v55.WindrunnersGuidance:IsAvailable()) or ((2247 + 871) <= (2693 - (497 + 345)))) then
					if (v26(v55.AimedShot, not v70, true) or ((5 + 160) >= (591 + 2901))) then
						return "aimed_shot st 4";
					end
				end
				if (((5282 - (605 + 728)) < (3465 + 1391)) and v55.KillShot:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) then
					if (v26(v55.KillShot, not v70) or ((9506 - 5230) < (139 + 2877))) then
						return "kill_shot st 6";
					end
				end
				v108 = 3 - 2;
			end
			if (((4229 + 461) > (11428 - 7303)) and (v108 == (5 + 1))) then
				if (v55.RapidFire:IsCastable() or ((539 - (457 + 32)) >= (381 + 515))) then
					if (v26(v55.RapidFire, not v70) or ((3116 - (832 + 570)) >= (2787 + 171))) then
						return "rapid_fire st 34";
					end
				end
				if ((v55.WailingArrow:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) or ((389 + 1102) < (2278 - 1634))) then
					if (((340 + 364) < (1783 - (588 + 208))) and v26(v55.WailingArrow, not v70, true)) then
						return "wailing_arrow st 36";
					end
				end
				if (((10020 - 6302) > (3706 - (884 + 916))) and v55.KillCommand:IsCastable() and (v13:BuffDown(v55.TrueshotBuff))) then
					if (v26(v55.KillCommand, not v14:IsInRange(104 - 54)) or ((556 + 402) > (4288 - (232 + 421)))) then
						return "kill_command st 37";
					end
				end
				v108 = 1896 - (1569 + 320);
			end
			if (((859 + 2642) <= (854 + 3638)) and (v108 == (23 - 16))) then
				if ((v55.ChimaeraShot:IsReady() and (v13:BuffUp(v55.PreciseShotsBuff) or (v13:Focus() > (v55.ChimaeraShot:Cost() + v55.AimedShot:Cost())))) or ((4047 - (316 + 289)) < (6669 - 4121))) then
					if (((133 + 2742) >= (2917 - (666 + 787))) and v26(v55.ChimaeraShot, not v70)) then
						return "chimaera_shot st 38";
					end
				end
				if ((v55.ArcaneShot:IsReady() and (v13:BuffUp(v55.PreciseShotsBuff) or (v13:Focus() > (v55.ArcaneShot:Cost() + v55.AimedShot:Cost())))) or ((5222 - (360 + 65)) >= (4573 + 320))) then
					if (v26(v55.ArcaneShot, not v70) or ((805 - (79 + 175)) > (3260 - 1192))) then
						return "arcane_shot st 40";
					end
				end
				if (((1650 + 464) > (2893 - 1949)) and v55.BagofTricks:IsReady()) then
					if (v26(v55.BagofTricks, not v14:IsSpellInRange(v55.BagofTricks)) or ((4355 - 2093) >= (3995 - (503 + 396)))) then
						return "bag_of_tricks st 42";
					end
				end
				v108 = 189 - (92 + 89);
			end
			if ((v108 == (15 - 7)) or ((1157 + 1098) >= (2094 + 1443))) then
				if (v55.SteadyShot:IsCastable() or ((15025 - 11188) < (179 + 1127))) then
					if (((6726 - 3776) == (2574 + 376)) and v26(v55.SteadyShot, not v70)) then
						return "steady_shot st 44";
					end
				end
				break;
			end
			if ((v108 == (3 + 2)) or ((14384 - 9661) < (412 + 2886))) then
				if (((1732 - 596) >= (1398 - (485 + 759))) and v55.AimedShot:IsReady()) then
					if (v71.CastTargetIf(v55.AimedShot, v67, "min", v77, v82, not v70, nil, nil, v57.AimedShotMouseover, true) or ((626 - 355) > (5937 - (442 + 747)))) then
						return "aimed_shot st 28";
					end
				end
				if (((5875 - (832 + 303)) >= (4098 - (88 + 858))) and v55.AimedShot:IsReady()) then
					if (v71.CastTargetIf(v55.AimedShot, v67, "max", v78, v83, not v70, nil, nil, v57.AimedShotMouseover, true) or ((786 + 1792) >= (2806 + 584))) then
						return "aimed_shot st 30";
					end
				end
				if (((2 + 39) <= (2450 - (766 + 23))) and v53 and v55.Volley:IsReady()) then
					if (((2966 - 2365) < (4868 - 1308)) and v26(v57.VolleyCursor, not v70)) then
						return "volley st 20";
					end
				end
				v108 = 15 - 9;
			end
			if (((797 - 562) < (1760 - (1036 + 37))) and (v108 == (1 + 0))) then
				if (((8858 - 4309) > (907 + 246)) and v53 and v55.Volley:IsReady() and (v13:BuffUp(v55.SalvoBuff))) then
					if (v26(v57.VolleyCursor, not v70) or ((6154 - (641 + 839)) < (5585 - (910 + 3)))) then
						return "volley st 5";
					end
				end
				if (((9350 - 5682) < (6245 - (1466 + 218))) and v16:Exists() and v55.KillShot:IsCastable() and (v16:HealthPercentage() <= (10 + 10))) then
					if (v26(v57.KillShotMouseover, not v16:IsSpellInRange(v55.KillShot)) or ((1603 - (556 + 592)) == (1282 + 2323))) then
						return "kill_shot_mouseover cleave 38";
					end
				end
				if ((v46 and v55.SteelTrap:IsCastable() and (v13:BuffDown(v55.TrueshotBuff))) or ((3471 - (329 + 479)) == (4166 - (174 + 680)))) then
					if (((14696 - 10419) <= (9275 - 4800)) and v26(v57.SteelTrapCursor, not v14:IsInRange(29 + 11))) then
						return "steel_trap st 6";
					end
				end
				v108 = 741 - (396 + 343);
			end
			if ((v108 == (1 + 3)) or ((2347 - (29 + 1448)) == (2578 - (135 + 1254)))) then
				if (((5850 - 4297) <= (14628 - 11495)) and v55.KillShot:IsReady()) then
					if (v26(v55.KillShot, not v70) or ((1491 + 746) >= (5038 - (389 + 1138)))) then
						return "kill_shot st 24";
					end
				end
				if ((v55.Trueshot:IsReady() and v33 and v64 and (v13:BuffDown(v55.TrueshotBuff) or (v13:BuffRemains(v55.TrueshotBuff) < (579 - (102 + 472))))) or ((1250 + 74) > (1675 + 1345))) then
					if (v26(v55.Trueshot, not v70) or ((2790 + 202) == (3426 - (320 + 1225)))) then
						return "trueshot st 26";
					end
				end
				if (((5528 - 2422) > (934 + 592)) and v55.MultiShot:IsReady() and ((v13:BuffUp(v55.BombardmentBuff) and not v74() and (v69 > (1465 - (157 + 1307)))) or (v13:BuffUp(v55.SalvoBuff) and not v55.Volley:IsAvailable()))) then
					if (((4882 - (821 + 1038)) < (9655 - 5785)) and v26(v55.MultiShot, not v70)) then
						return "multishot st 26";
					end
				end
				v108 = 1 + 4;
			end
			if (((253 - 110) > (28 + 46)) and (v108 == (7 - 4))) then
				if (((1044 - (834 + 192)) < (135 + 1977)) and v55.DeathChakram:IsReady() and v33) then
					if (((282 + 815) <= (35 + 1593)) and v26(v55.DeathChakram, not v70)) then
						return "dark_chakram st 16";
					end
				end
				if (((7172 - 2542) == (4934 - (300 + 4))) and v55.WailingArrow:IsReady() and (v69 > (1 + 0))) then
					if (((9266 - 5726) > (3045 - (112 + 250))) and v26(v55.WailingArrow, not v70, true)) then
						return "wailing_arrow st 18";
					end
				end
				if (((1912 + 2882) >= (8204 - 4929)) and v55.RapidFire:IsCastable() and (v55.SurgingShots:IsAvailable() or (v55.AimedShot:FullRechargeTime() > (v55.AimedShot:CastTime() + v55.RapidFire:CastTime())))) then
					if (((851 + 633) == (768 + 716)) and v26(v55.RapidFire, not v70)) then
						return "rapid_fire st 22";
					end
				end
				v108 = 3 + 1;
			end
		end
	end
	local function v89()
		local v109 = 0 + 0;
		while true do
			if (((1064 + 368) < (4969 - (1001 + 413))) and ((2 - 1) == v109)) then
				if (v55.ExplosiveShot:IsReady() or ((1947 - (244 + 638)) > (4271 - (627 + 66)))) then
					if (v26(v55.ExplosiveShot, not v70) or ((14287 - 9492) < (2009 - (512 + 90)))) then
						return "explosive_shot trickshots 8";
					end
				end
				if (((3759 - (1665 + 241)) < (5530 - (373 + 344))) and v55.DeathChakram:IsReady() and v33) then
					if (v26(v55.DeathChakram, not v70) or ((1273 + 1548) < (644 + 1787))) then
						return "death_chakram trickshots 10";
					end
				end
				if ((v55.Stampede:IsReady() and v33) or ((7580 - 4706) < (3690 - 1509))) then
					if (v26(v55.Stampede, not v14:IsInRange(1129 - (35 + 1064))) or ((1957 + 732) <= (733 - 390))) then
						return "stampede trickshots 12";
					end
				end
				v109 = 1 + 1;
			end
			if ((v109 == (1241 - (298 + 938))) or ((3128 - (233 + 1026)) == (3675 - (636 + 1030)))) then
				if ((v55.ChimaeraShot:IsReady() and v13:BuffUp(v55.TrickShotsBuff) and v13:BuffUp(v55.PreciseShotsBuff) and (v13:Focus() > (v55.ChimaeraShot:Cost() + v55.AimedShot:Cost())) and (v69 < (3 + 1))) or ((3464 + 82) < (690 + 1632))) then
					if (v26(v55.ChimaeraShot, not v70) or ((141 + 1941) == (4994 - (55 + 166)))) then
						return "chimaera_shot trickshots 32";
					end
				end
				if (((629 + 2615) > (107 + 948)) and v55.MultiShot:IsReady() and (not v74() or ((v13:BuffUp(v55.PreciseShotsBuff) or (v13:BuffStack(v55.BulletstormBuff) == (38 - 28))) and (v13:Focus() > (v55.MultiShot:Cost() + v55.AimedShot:Cost()))))) then
					if (v26(v55.MultiShot, not v70) or ((3610 - (36 + 261)) <= (3109 - 1331))) then
						return "multishot trickshots 34";
					end
				end
				if (v55.SerpentSting:IsReady() or ((2789 - (34 + 1334)) >= (809 + 1295))) then
					if (((1408 + 404) <= (4532 - (1035 + 248))) and v71.CastTargetIf(v55.SerpentSting, v67, "min", v76, v81, not v70, nil, nil, v57.SerpentStingMouseover)) then
						return "serpent_sting trickshots 36";
					end
				end
				v109 = 27 - (20 + 1);
			end
			if (((846 + 777) <= (2276 - (134 + 185))) and (v109 == (1133 - (549 + 584)))) then
				if (((5097 - (314 + 371)) == (15146 - 10734)) and v55.SteadyShot:IsCastable() and v55.SteadyFocus:IsAvailable() and (v63.Count == (969 - (478 + 490))) and (v13:BuffRemains(v55.SteadyFocusBuff) < (5 + 3))) then
					if (((2922 - (786 + 386)) >= (2727 - 1885)) and v26(v55.SteadyShot, not v70)) then
						return "steady_shot trickshots 2";
					end
				end
				if (((5751 - (1055 + 324)) > (3190 - (1093 + 247))) and v55.KillShot:IsReady()) then
					if (((207 + 25) < (87 + 734)) and v26(v55.KillShot, not v70)) then
						return "kill_shot trickshots 4";
					end
				end
				if (((2056 - 1538) < (3060 - 2158)) and v16:Exists() and v55.KillShot:IsCastable() and (v16:HealthPercentage() <= (56 - 36))) then
					if (((7523 - 4529) > (306 + 552)) and v26(v57.KillShotMouseover, not v16:IsSpellInRange(v55.KillShot))) then
						return "kill_shot_mouseover cleave 38";
					end
				end
				v109 = 3 - 2;
			end
			if (((6 - 4) == v109) or ((2832 + 923) <= (2340 - 1425))) then
				if (((4634 - (364 + 324)) > (10260 - 6517)) and v55.WailingArrow:IsReady()) then
					if (v26(v55.WailingArrow, not v70, true) or ((3203 - 1868) >= (1096 + 2210))) then
						return "wailing_arrow trickshots 14";
					end
				end
				if (((20268 - 15424) > (3608 - 1355)) and v55.SerpentSting:IsReady()) then
					if (((1372 - 920) == (1720 - (1249 + 19))) and v71.CastTargetIf(v55.SerpentSting, v67, "min", v76, v80, not v70, nil, nil, v57.SerpentStingMouseover)) then
						return "serpent_sting trickshots 16";
					end
				end
				if ((v55.Barrage:IsReady() and (v69 > (7 + 0)) and v33) or ((17737 - 13180) < (3173 - (686 + 400)))) then
					if (((3040 + 834) == (4103 - (73 + 156))) and v26(v55.Barrage, not v70)) then
						return "barrage trickshots 18";
					end
				end
				v109 = 1 + 2;
			end
			if ((v109 == (817 - (721 + 90))) or ((22 + 1916) > (16023 - 11088))) then
				if ((v46 and v55.SteelTrap:IsCastable()) or ((4725 - (224 + 246)) < (5544 - 2121))) then
					if (((2676 - 1222) <= (452 + 2039)) and v26(v57.SteelTrapCursor, not v14:IsInRange(1 + 39))) then
						return "steel_trap trickshots 38";
					end
				end
				if ((v55.KillShot:IsReady() and (v13:Focus() > (v55.KillShot:Cost() + v55.AimedShot:Cost()))) or ((3054 + 1103) <= (5572 - 2769))) then
					if (((16149 - 11296) >= (3495 - (203 + 310))) and v26(v55.KillShot, not v70)) then
						return "kill_shot trickshots 40";
					end
				end
				if (((6127 - (1238 + 755)) > (235 + 3122)) and v55.MultiShot:IsReady() and (v13:Focus() > (v55.MultiShot:Cost() + v55.AimedShot:Cost()))) then
					if (v26(v55.MultiShot, not v70) or ((4951 - (709 + 825)) < (4669 - 2135))) then
						return "multishot trickshots 42";
					end
				end
				v109 = 10 - 3;
			end
			if ((v109 == (868 - (196 + 668))) or ((10747 - 8025) <= (339 - 175))) then
				if (v55.AimedShot:IsReady() or ((3241 - (171 + 662)) < (2202 - (4 + 89)))) then
					if (v71.CastTargetIf(v55.AimedShot, v67, "min", v77, v84, not v70, nil, nil, v57.AimedShotMouseover, true) or ((115 - 82) == (530 + 925))) then
						return "aimed_shot trickshots 26";
					end
				end
				if (v55.AimedShot:IsReady() or ((1945 - 1502) >= (1575 + 2440))) then
					if (((4868 - (35 + 1451)) > (1619 - (28 + 1425))) and v71.CastTargetIf(v55.AimedShot, v67, "max", v78, v85, not v70, nil, nil, v57.AimedShotMouseover, true)) then
						return "aimed_shot trickshots 28";
					end
				end
				if ((v55.RapidFire:IsCastable() and (v13:BuffRemains(v55.TrickShotsBuff) >= v55.RapidFire:ExecuteTime())) or ((2273 - (941 + 1052)) == (2934 + 125))) then
					if (((3395 - (822 + 692)) > (1845 - 552)) and v26(v55.RapidFire, not v70)) then
						return "rapid_fire trickshots 30";
					end
				end
				v109 = 3 + 2;
			end
			if (((2654 - (45 + 252)) == (2333 + 24)) and (v109 == (3 + 4))) then
				if (((299 - 176) == (556 - (114 + 319))) and v55.BagofTricks:IsReady() and (v13:BuffDown(v55.Trueshot))) then
					if (v26(v55.BagofTricks, not v14:IsSpellInRange(v55.BagofTricks)) or ((1515 - 459) >= (4346 - 954))) then
						return "bag_of_tricks trickshots 44";
					end
				end
				if (v55.SteadyShot:IsCastable() or ((690 + 391) < (1601 - 526))) then
					if (v26(v55.SteadyShot, not v70) or ((2197 - 1148) >= (6395 - (556 + 1407)))) then
						return "steady_shot trickshots 46";
					end
				end
				break;
			end
			if ((v109 == (1209 - (741 + 465))) or ((5233 - (170 + 295)) <= (446 + 400))) then
				if ((v53 and v55.Volley:IsReady()) or ((3085 + 273) <= (3496 - 2076))) then
					if (v26(v57.VolleyCursor) or ((3100 + 639) <= (1928 + 1077))) then
						return "volley trickshots 20";
					end
				end
				if ((v55.Trueshot:IsReady() and v33 and not v13:IsCasting(v55.SteadyShot) and not v13:IsCasting(v55.RapidFire) and not v13:IsChanneling(v55.RapidFire)) or ((940 + 719) >= (3364 - (957 + 273)))) then
					if (v26(v55.Trueshot, not v70) or ((872 + 2388) < (943 + 1412))) then
						return "trueshot trickshots 22";
					end
				end
				if ((v55.RapidFire:IsCastable() and (v13:BuffRemains(v55.TrickShotsBuff) >= v55.RapidFire:ExecuteTime()) and v55.SurgingShots:IsAvailable()) or ((2549 - 1880) == (11128 - 6905))) then
					if (v26(v55.RapidFire, not v70) or ((5167 - 3475) < (2911 - 2323))) then
						return "rapid_fire trickshots 24";
					end
				end
				v109 = 1784 - (389 + 1391);
			end
		end
	end
	local function v90()
		local v110 = v13:GetUseableItems(v59, 9 + 4);
		if ((v110 and (v13:BuffUp(v55.TrueshotBuff) or (v66 < (2 + 11)))) or ((10920 - 6123) < (4602 - (783 + 168)))) then
			if (v26(v57.Trinket1, nil, nil, true) or ((14018 - 9841) > (4771 + 79))) then
				return "trinket1 trinket 2";
			end
		end
		local v111 = v13:GetUseableItems(v59, 325 - (309 + 2));
		if ((v111 and (v13:BuffUp(v55.TrueshotBuff) or (v66 < (39 - 26)))) or ((1612 - (1090 + 122)) > (361 + 750))) then
			if (((10246 - 7195) > (688 + 317)) and v26(v57.Trinket2, nil, nil, true)) then
				return "trinket2 trinket 4";
			end
		end
	end
	local function v91()
		local v112 = 1118 - (628 + 490);
		while true do
			if (((663 + 3030) <= (10848 - 6466)) and (v112 == (4 - 3))) then
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v112 = 776 - (431 + 343);
			end
			if ((v112 == (7 - 3)) or ((9494 - 6212) > (3240 + 860))) then
				if (v71.TargetIsValid() or v13:AffectingCombat() or ((458 + 3122) < (4539 - (556 + 1139)))) then
					v65 = v10.BossFightRemains(nil, true);
					v66 = v65;
					if (((104 - (6 + 9)) < (823 + 3667)) and (v66 == (5692 + 5419))) then
						v66 = v10.FightRemains(v68, false);
					end
				end
				if (v71.TargetIsValid() or ((5152 - (28 + 141)) < (701 + 1107))) then
					local v130 = 0 - 0;
					while true do
						if (((2712 + 1117) > (5086 - (486 + 831))) and (v130 == (5 - 3))) then
							if (((5228 - 3743) <= (549 + 2355)) and v33) then
								local v133 = 0 - 0;
								local v134;
								while true do
									if (((5532 - (668 + 595)) == (3842 + 427)) and (v133 == (0 + 0))) then
										v134 = v87();
										if (((1055 - 668) <= (3072 - (23 + 267))) and v134) then
											return v134;
										end
										break;
									end
								end
							end
							if ((v69 < (1947 - (1129 + 815))) or not v55.TrickShots:IsAvailable() or not v32 or ((2286 - (371 + 16)) <= (2667 - (1326 + 424)))) then
								local v135 = v88();
								if (v135 or ((8166 - 3854) <= (3201 - 2325))) then
									return v135;
								end
							end
							if (((2350 - (88 + 30)) <= (3367 - (720 + 51))) and (v69 > (4 - 2))) then
								local v136 = v89();
								if (((3871 - (421 + 1355)) < (6080 - 2394)) and v136) then
									return v136;
								end
							end
							if (v26(v55.PoolFocus) or ((784 + 811) >= (5557 - (286 + 797)))) then
								return "Pooling Focus";
							end
							break;
						end
						if ((v130 == (0 - 0)) or ((7650 - 3031) < (3321 - (397 + 42)))) then
							v75();
							if ((not v13:AffectingCombat() and not v31) or ((92 + 202) >= (5631 - (24 + 776)))) then
								local v137 = 0 - 0;
								local v138;
								while true do
									if (((2814 - (222 + 563)) <= (6794 - 3710)) and (v137 == (0 + 0))) then
										v138 = v86();
										if (v138 or ((2227 - (23 + 167)) == (4218 - (690 + 1108)))) then
											return v138;
										end
										break;
									end
								end
							end
							if (((1609 + 2849) > (3221 + 683)) and v55.Exhilaration:IsReady() and (v13:HealthPercentage() <= v51)) then
								if (((1284 - (40 + 808)) >= (21 + 102)) and v26(v55.Exhilaration)) then
									return "exhilaration";
								end
							end
							if (((1912 - 1412) < (1736 + 80)) and (v13:HealthPercentage() <= v40) and v56.Healthstone:IsReady()) then
								if (((1891 + 1683) == (1960 + 1614)) and v26(v57.Healthstone, nil, nil, true)) then
									return "healthstone";
								end
							end
							v130 = 572 - (47 + 524);
						end
						if (((144 + 77) < (1066 - 676)) and (v130 == (1 - 0))) then
							if ((not v13:IsCasting() and not v13:IsChanneling()) or ((5046 - 2833) <= (3147 - (1165 + 561)))) then
								local v139 = v71.Interrupt(v55.CounterShot, 2 + 38, true);
								if (((9470 - 6412) < (1855 + 3005)) and v139) then
									return v139;
								end
								v139 = v71.InterruptWithStun(v55.Intimidation, 519 - (341 + 138));
								if (v139 or ((350 + 946) >= (9175 - 4729))) then
									return v139;
								end
								v139 = v71.Interrupt(v55.CounterShot, 366 - (89 + 237), true, v16, v57.CounterShotMouseover);
								if (v139 or ((4481 - 3088) > (9450 - 4961))) then
									return v139;
								end
								v139 = v71.InterruptWithStun(v55.Intimidation, 921 - (581 + 300), false, v16, v57.IntimidationMouseover);
								if (v139 or ((5644 - (855 + 365)) < (64 - 37))) then
									return v139;
								end
							end
							if ((v52 and v55.TranquilizingShot:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and (v71.UnitHasEnrageBuff(v14) or v71.UnitHasMagicBuff(v14))) or ((653 + 1344) > (5050 - (1030 + 205)))) then
								if (((3253 + 212) > (1780 + 133)) and v26(v55.TranquilizingShot, not v70)) then
									return "dispel";
								end
							end
							v64 = v55.Trueshot:CooldownUp();
							if (((1019 - (156 + 130)) < (4132 - 2313)) and v35 and v33) then
								local v140 = v90();
								if (v140 or ((7407 - 3012) == (9738 - 4983))) then
									return v140;
								end
							end
							v130 = 1 + 1;
						end
					end
				end
				break;
			end
			if (((2 + 0) == v112) or ((3862 - (10 + 59)) < (671 + 1698))) then
				v70 = v14:IsSpellInRange(v55.AimedShot);
				v67 = v13:GetEnemiesInRange(v55.AimedShot.MaximumRange);
				v112 = 14 - 11;
			end
			if (((1163 - (671 + 492)) == v112) or ((3252 + 832) == (1480 - (369 + 846)))) then
				v54();
				v31 = EpicSettings.Toggles['ooc'];
				v112 = 1 + 0;
			end
			if (((3720 + 638) == (6303 - (1036 + 909))) and (v112 == (3 + 0))) then
				v68 = v14:GetEnemiesInSplashRange(16 - 6);
				if (v23() or ((3341 - (11 + 192)) < (502 + 491))) then
					v69 = v14:GetEnemiesInSplashRangeCount(185 - (135 + 40));
				else
					v69 = 2 - 1;
				end
				v112 = 3 + 1;
			end
		end
	end
	local function v92()
		v10.Print("Marksmanship by Epic. Supported by Gojira");
	end
	v10.SetAPL(559 - 305, v91, v92);
end;
return v0["Epix_Hunter_Marksmanship.lua"]();

