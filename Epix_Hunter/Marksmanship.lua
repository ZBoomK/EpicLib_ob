local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((10058 - 6654) == (12606 - 8146))) then
			v6 = v0[v4];
			if (not v6 or ((125 + 2239) > (513 + 2993))) then
				return v1(v4, ...);
			end
			v5 = 1053 - (433 + 619);
		end
		if ((v5 == (164 - (92 + 71))) or ((1434 + 1469) > (8328 - 3374))) then
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
		local v93 = 765 - (574 + 191);
		while true do
			if (((2544 + 540) > (100 - 60)) and (v93 == (2 + 1))) then
				v46 = EpicSettings.Settings['UseSteelTrap'];
				v47 = EpicSettings.Settings['UseRevive'];
				v48 = EpicSettings.Settings['UseMendPet'];
				v49 = EpicSettings.Settings['MendPetHP'] or (849 - (254 + 595));
				v93 = 130 - (55 + 71);
			end
			if (((4494 - 1082) > (2609 - (573 + 1217))) and (v93 == (10 - 6))) then
				v50 = EpicSettings.Settings['UseExhilaration'];
				v51 = EpicSettings.Settings['ExhilarationHP'] or (0 + 0);
				v52 = EpicSettings.Settings['UseTranq'];
				v53 = EpicSettings.Settings['UseVolley'];
				break;
			end
			if (((5094 - 1932) <= (4380 - (714 + 225))) and (v93 == (2 - 1))) then
				v38 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v39 = EpicSettings.Settings['UseHealthstone'];
				v40 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v41 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
				v93 = 808 - (118 + 688);
			end
			if (((4754 - (25 + 23)) > (858 + 3571)) and (v93 == (1886 - (927 + 959)))) then
				v34 = EpicSettings.Settings['UseRacials'];
				v35 = EpicSettings.Settings['UseTrinkets'];
				v36 = EpicSettings.Settings['UseHealingPotion'];
				v37 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v93 = 733 - (16 + 716);
			end
			if (((5508 - 2654) < (4192 - (11 + 86))) and (v93 == (4 - 2))) then
				v42 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (285 - (175 + 110));
				v43 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v44 = EpicSettings.Settings['UsePet'];
				v45 = EpicSettings.Settings['SummonPetSlot'] or (0 - 0);
				v93 = 1799 - (503 + 1293);
			end
		end
	end
	local v55 = v18.Hunter.Marksmanship;
	local v56 = v20.Hunter.Marksmanship;
	local v57 = v22.Hunter.Marksmanship;
	local v58 = {v55.SummonPet,v55.SummonPet2,v55.SummonPet3,v55.SummonPet4,v55.SummonPet5};
	local v59 = {};
	local v60 = v13:GetEquipment();
	local v61 = (v60[12 + 1] and v20(v60[546 - (43 + 490)])) or v20(733 - (711 + 22));
	local v62 = (v60[53 - 39] and v20(v60[873 - (240 + 619)])) or v20(0 + 0);
	local v63 = {LastCast=(0 - 0),Count=(0 + 0)};
	local v64;
	local v65 = 12855 - (1344 + 400);
	local v66 = 11516 - (255 + 150);
	local v67;
	local v68;
	local v69;
	local v70;
	local v71 = v10.Commons.Everyone;
	local v72 = (v14:HealthPercentage() > (56 + 14)) and v55.CarefulAim:IsAvailable();
	local v73 = {{v55.Intimidation,"Cast Intimidation (Interrupt)",function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		v60 = v13:GetEquipment();
		v61 = (v60[419 - (183 + 223)] and v20(v60[15 - 2])) or v20(0 + 0);
		v62 = (v60[6 + 8] and v20(v60[351 - (10 + 327)])) or v20(0 + 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v94 = 338 - (118 + 220);
		while true do
			if ((v94 == (0 + 0)) or ((1507 - (108 + 341)) >= (540 + 662))) then
				v63 = {LastCast=(0 - 0),Count=(1493 - (711 + 782))};
				v65 = 21299 - 10188;
				v94 = 470 - (270 + 199);
			end
			if (((1204 + 2507) > (5174 - (580 + 1239))) and ((2 - 1) == v94)) then
				v66 = 10624 + 487;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v55.SerpentSting:RegisterInFlight();
		v55.SteadyShot:RegisterInFlight();
		v55.AimedShot:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v55.SerpentSting:RegisterInFlight();
	v55.SteadyShot:RegisterInFlight();
	v55.AimedShot:RegisterInFlight();
	local function v74()
		return (v13:BuffUp(v55.TrickShotsBuff) and not v13:IsCasting(v55.AimedShot) and not v13:IsChanneling(v55.RapidFire)) or v13:BuffUp(v55.VolleyBuff);
	end
	local function v75()
		local v95 = 0 + 0;
		while true do
			if ((v95 == (1 + 0)) or ((2365 - 1459) >= (1385 + 844))) then
				if (((2455 - (645 + 522)) > (3041 - (1010 + 780))) and (v55.SteadyFocusBuff.LastAppliedOnPlayerTime > v63.LastCast)) then
					v63.Count = 0 + 0;
				end
				break;
			end
			if ((v95 == (0 - 0)) or ((13225 - 8712) < (5188 - (1045 + 791)))) then
				if ((((v63.Count == (0 - 0)) or (v63.Count == (1 - 0))) and v13:IsCasting(v55.SteadyShot) and (v63.LastCast < (v27() - v55.SteadyShot:CastTime()))) or ((2570 - (351 + 154)) >= (4770 - (1281 + 293)))) then
					local v128 = 266 - (28 + 238);
					while true do
						if ((v128 == (0 - 0)) or ((5935 - (1381 + 178)) <= (1390 + 91))) then
							v63.LastCast = v27();
							v63.Count = v63.Count + 1 + 0;
							break;
						end
					end
				end
				if (not (v13:IsCasting(v55.SteadyShot) or v13:PrevGCDP(1 + 0, v55.SteadyShot)) or ((11693 - 8301) >= (2457 + 2284))) then
					v63.Count = 470 - (381 + 89);
				end
				v95 = 1 + 0;
			end
		end
	end
	local function v76(v96)
		return (v96:DebuffRemains(v55.SerpentStingDebuff));
	end
	local function v77(v97)
		return v97:DebuffRemains(v55.SerpentStingDebuff) + (v29(v55.SerpentSting:InFlight()) * (67 + 32));
	end
	local function v78(v98)
		return (v98:DebuffStack(v55.LatentPoisonDebuff));
	end
	local function v79(v99)
		return v99:DebuffRefreshable(v55.SerpentStingDebuff) and not v55.SerpentstalkersTrickery:IsAvailable();
	end
	local function v80(v100)
		return v100:DebuffRefreshable(v55.SerpentStingDebuff) and v55.HydrasBite:IsAvailable() and not v55.SerpentstalkersTrickery:IsAvailable();
	end
	local function v81(v101)
		return v101:DebuffRefreshable(v55.SerpentStingDebuff) and v55.PoisonInjection:IsAvailable() and not v55.SerpentstalkersTrickery:IsAvailable();
	end
	local function v82(v102)
		return v55.SerpentstalkersTrickery:IsAvailable() and (v13:BuffDown(v55.PreciseShotsBuff) or ((v13:BuffUp(v55.TrueshotBuff) or (v55.AimedShot:FullRechargeTime() < (v13:GCD() + v55.AimedShot:CastTime()))) and (not v55.ChimaeraShot:IsAvailable() or (v69 < (2 - 0)))) or ((v13:BuffRemains(v55.TrickShotsBuff) > v55.AimedShot:ExecuteTime()) and (v69 > (1157 - (1074 + 82)))));
	end
	local function v83(v103)
		return v13:BuffDown(v55.PreciseShotsBuff) or ((v13:BuffUp(v55.TrueshotBuff) or (v55.AimedShot:FullRechargeTime() < (v13:GCD() + v55.AimedShot:CastTime()))) and (not v55.ChimaeraShot:IsAvailable() or (v69 < (3 - 1)))) or ((v13:BuffRemains(v55.TrickShotsBuff) > v55.AimedShot:ExecuteTime()) and (v69 > (1785 - (214 + 1570))));
	end
	local function v84(v104)
		return v55.SerpentstalkersTrickery:IsAvailable() and (v13:BuffRemains(v55.TrickShotsBuff) >= v55.AimedShot:ExecuteTime()) and (v13:BuffDown(v55.PreciseShotsBuff) or v13:BuffUp(v55.TrueshotBuff) or (v55.AimedShot:FullRechargeTime() < (v55.AimedShot:CastTime() + v13:GCD())));
	end
	local function v85(v105)
		return (v13:BuffRemains(v55.TrickShotsBuff) >= v55.AimedShot:ExecuteTime()) and (v13:BuffDown(v55.PreciseShotsBuff) or v13:BuffUp(v55.TrueshotBuff) or (v55.AimedShot:FullRechargeTime() < (v55.AimedShot:CastTime() + v13:GCD())));
	end
	local function v86()
		if (((4780 - (990 + 465)) >= (888 + 1266)) and v15 and v15:Exists() and v55.Misdirection:IsReady()) then
			if (v26(v57.MisdirectionFocus) or ((564 + 731) >= (3144 + 89))) then
				return "misdirection opener";
			end
		end
		if (((17225 - 12848) > (3368 - (1668 + 58))) and v55.SummonPet:IsCastable() and not v55.LoneWolf:IsAvailable() and v44) then
			if (((5349 - (512 + 114)) > (3535 - 2179)) and v26(v58[v45])) then
				return "Summon Pet opener";
			end
		end
		if ((v55.Salvo:IsCastable() and v33) or ((8550 - 4414) <= (11945 - 8512))) then
			if (((1975 + 2270) <= (867 + 3764)) and v26(v55.Salvo)) then
				return "salvo opener";
			end
		end
		if (((3718 + 558) >= (13201 - 9287)) and v55.AimedShot:IsReady() and not v13:IsCasting(v55.AimedShot) and (v69 < (1997 - (109 + 1885))) and (not v55.Volley:IsAvailable() or (v69 < (1471 - (1269 + 200))))) then
			if (((379 - 181) <= (5180 - (98 + 717))) and v26(v55.AimedShot, not v70, true)) then
				return "aimed_shot opener";
			end
		end
		if (((5608 - (802 + 24)) > (8063 - 3387)) and v55.WailingArrow:IsReady() and not v13:IsCasting(v55.WailingArrow) and ((v69 > (2 - 0)) or not v55.SteadyFocus:IsAvailable())) then
			if (((719 + 4145) > (1689 + 508)) and v26(v55.WailingArrow, not v70, true)) then
				return "wailing_arrow opener";
			end
		end
		if ((v55.SteadyShot:IsCastable() and ((v69 > (1 + 1)) or (v55.Volley:IsAvailable() and (v69 == (1 + 1))))) or ((10293 - 6593) == (8360 - 5853))) then
			if (((1601 + 2873) >= (112 + 162)) and v26(v55.SteadyShot, not v70)) then
				return "steady_shot opener";
			end
		end
	end
	local function v87()
		local v106 = 0 + 0;
		while true do
			if ((v106 == (1 + 0)) or ((885 + 1009) <= (2839 - (797 + 636)))) then
				if (((7632 - 6060) >= (3150 - (1427 + 192))) and v55.AncestralCall:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v55.Trueshot:CooldownRemains() > (11 + 19)) or (v66 < (37 - 21)))) then
					if (v26(v55.AncestralCall) or ((4213 + 474) < (2059 + 2483))) then
						return "ancestral_call cds 6";
					end
				end
				if (((3617 - (192 + 134)) > (2943 - (316 + 960))) and v55.Fireblood:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v55.Trueshot:CooldownRemains() > (17 + 13)) or (v66 < (7 + 2)))) then
					if (v26(v55.Fireblood) or ((807 + 66) == (7775 - 5741))) then
						return "fireblood cds 8";
					end
				end
				v106 = 553 - (83 + 468);
			end
			if (((1808 - (1202 + 604)) == v106) or ((13145 - 10329) < (18 - 7))) then
				if (((10241 - 6542) < (5031 - (45 + 280))) and v55.LightsJudgment:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) then
					if (((2554 + 92) >= (766 + 110)) and v26(v55.LightsJudgment, not v14:IsSpellInRange(v55.LightsJudgment))) then
						return "lights_judgment cds 10";
					end
				end
				if (((225 + 389) <= (1762 + 1422)) and v55.Salvo:IsCastable() and ((v69 > (1 + 1)) or (v55.Volley:CooldownRemains() < (18 - 8)))) then
					if (((5037 - (340 + 1571)) == (1233 + 1893)) and v26(v55.Salvo)) then
						return "salvo cds 14";
					end
				end
				break;
			end
			if ((v106 == (1772 - (1733 + 39))) or ((6009 - 3822) >= (5988 - (125 + 909)))) then
				if ((v55.Berserking:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v66 < (1961 - (1096 + 852))))) or ((1740 + 2137) == (5105 - 1530))) then
					if (((686 + 21) > (1144 - (409 + 103))) and v26(v55.Berserking)) then
						return "berserking cds 2";
					end
				end
				if ((v55.BloodFury:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v55.Trueshot:CooldownRemains() > (266 - (46 + 190))) or (v66 < (111 - (51 + 44))))) or ((154 + 392) >= (4001 - (1114 + 203)))) then
					if (((2191 - (228 + 498)) <= (932 + 3369)) and v26(v55.BloodFury)) then
						return "blood_fury cds 4";
					end
				end
				v106 = 1 + 0;
			end
		end
	end
	local function v88()
		if (((2367 - (174 + 489)) > (3712 - 2287)) and v55.SteadyShot:IsCastable() and v55.SteadyFocus:IsAvailable() and (((v63.Count == (1906 - (830 + 1075))) and (v13:BuffRemains(v55.SteadyFocusBuff) < (529 - (303 + 221)))) or (v13:BuffDown(v55.SteadyFocusBuff) and v13:BuffDown(v55.TrueshotBuff) and (v63.Count ~= (1271 - (231 + 1038)))))) then
			if (v26(v55.SteadyShot, not v70) or ((573 + 114) == (5396 - (171 + 991)))) then
				return "steady_shot st 2";
			end
		end
		if ((v55.AimedShot:IsReady() and v13:BuffUp(v55.TrueshotBuff) and (v55.AimedShot:FullRechargeTime() < (v13:GCD() + v55.AimedShot:CastTime())) and v55.LegacyoftheWindrunners:IsAvailable() and v55.WindrunnersGuidance:IsAvailable()) or ((13723 - 10393) < (3836 - 2407))) then
			if (((2862 - 1715) >= (269 + 66)) and v26(v55.AimedShot, not v70, true)) then
				return "aimed_shot st 4";
			end
		end
		if (((12040 - 8605) > (6049 - 3952)) and v55.KillShot:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) then
			if (v26(v55.KillShot, not v70) or ((6077 - 2307) >= (12491 - 8450))) then
				return "kill_shot st 6";
			end
		end
		if ((v53 and v55.Volley:IsReady() and (v13:BuffUp(v55.SalvoBuff))) or ((5039 - (111 + 1137)) <= (1769 - (91 + 67)))) then
			if (v26(v57.VolleyCursor, not v70) or ((13625 - 9047) <= (502 + 1506))) then
				return "volley st 5";
			end
		end
		if (((1648 - (423 + 100)) <= (15 + 2061)) and v16:Exists() and v55.KillShot:IsCastable() and (v16:HealthPercentage() <= (55 - 35))) then
			if (v26(v57.KillShotMouseover, not v16:IsSpellInRange(v55.KillShot)) or ((388 + 355) >= (5170 - (326 + 445)))) then
				return "kill_shot_mouseover cleave 38";
			end
		end
		if (((5040 - 3885) < (3726 - 2053)) and v46 and v55.SteelTrap:IsCastable() and (v13:BuffDown(v55.TrueshotBuff))) then
			if (v26(v57.SteelTrapCursor, not v14:IsInRange(93 - 53)) or ((3035 - (530 + 181)) <= (1459 - (614 + 267)))) then
				return "steel_trap st 6";
			end
		end
		if (((3799 - (19 + 13)) == (6131 - 2364)) and v55.SerpentSting:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) then
			if (((9528 - 5439) == (11680 - 7591)) and v71.CastTargetIf(v55.SerpentSting, v67, "min", v76, v79, not v70, nil, nil, v57.SerpentStingMouseover)) then
				return "serpent_sting st 8";
			end
		end
		if (((1158 + 3300) >= (2943 - 1269)) and v55.ExplosiveShot:IsReady()) then
			if (((2015 - 1043) <= (3230 - (1293 + 519))) and v26(v55.ExplosiveShot, not v70)) then
				return "explosive_shot st 10";
			end
		end
		if ((v55.Stampede:IsCastable() and v33) or ((10074 - 5136) < (12433 - 7671))) then
			if (v26(v55.Stampede, not v14:IsInRange(57 - 27)) or ((10797 - 8293) > (10044 - 5780))) then
				return "stampede st 14";
			end
		end
		if (((1141 + 1012) == (440 + 1713)) and v55.DeathChakram:IsReady() and v33) then
			if (v26(v55.DeathChakram, not v70) or ((1177 - 670) >= (599 + 1992))) then
				return "dark_chakram st 16";
			end
		end
		if (((1489 + 2992) == (2801 + 1680)) and v55.WailingArrow:IsReady() and (v69 > (1097 - (709 + 387)))) then
			if (v26(v55.WailingArrow, not v70, true) or ((4186 - (673 + 1185)) < (2009 - 1316))) then
				return "wailing_arrow st 18";
			end
		end
		if (((13897 - 9569) == (7120 - 2792)) and v55.RapidFire:IsCastable() and (v55.SurgingShots:IsAvailable() or (v55.AimedShot:FullRechargeTime() > (v55.AimedShot:CastTime() + v55.RapidFire:CastTime())))) then
			if (((1136 + 452) >= (996 + 336)) and v26(v55.RapidFire, not v70)) then
				return "rapid_fire st 22";
			end
		end
		if (v55.KillShot:IsReady() or ((5635 - 1461) > (1044 + 3204))) then
			if (v26(v55.KillShot, not v70) or ((9143 - 4557) <= (160 - 78))) then
				return "kill_shot st 24";
			end
		end
		if (((5743 - (446 + 1434)) == (5146 - (1040 + 243))) and v55.Trueshot:IsReady() and v33 and v64 and (v13:BuffDown(v55.TrueshotBuff) or (v13:BuffRemains(v55.TrueshotBuff) < (14 - 9)))) then
			if (v26(v55.Trueshot, not v70) or ((2129 - (559 + 1288)) <= (1973 - (609 + 1322)))) then
				return "trueshot st 26";
			end
		end
		if (((5063 - (13 + 441)) >= (2862 - 2096)) and v55.MultiShot:IsReady() and ((v13:BuffUp(v55.BombardmentBuff) and not v74() and (v69 > (2 - 1))) or (v13:BuffUp(v55.SalvoBuff) and not v55.Volley:IsAvailable()))) then
			if (v26(v55.MultiShot, not v70) or ((5737 - 4585) == (93 + 2395))) then
				return "multishot st 26";
			end
		end
		if (((12427 - 9005) > (1190 + 2160)) and v55.AimedShot:IsReady()) then
			if (((385 + 492) > (1115 - 739)) and v71.CastTargetIf(v55.AimedShot, v67, "min", v77, v82, not v70, nil, nil, v57.AimedShotMouseover, true)) then
				return "aimed_shot st 28";
			end
		end
		if (v55.AimedShot:IsReady() or ((1707 + 1411) <= (3404 - 1553))) then
			if (v71.CastTargetIf(v55.AimedShot, v67, "max", v78, v83, not v70, nil, nil, v57.AimedShotMouseover, true) or ((110 + 55) >= (1943 + 1549))) then
				return "aimed_shot st 30";
			end
		end
		if (((2838 + 1111) < (4078 + 778)) and v53 and v55.Volley:IsReady()) then
			if (v26(v57.VolleyCursor, not v70) or ((4184 + 92) < (3449 - (153 + 280)))) then
				return "volley st 20";
			end
		end
		if (((13542 - 8852) > (3704 + 421)) and v55.RapidFire:IsCastable()) then
			if (v26(v55.RapidFire, not v70) or ((20 + 30) >= (469 + 427))) then
				return "rapid_fire st 34";
			end
		end
		if ((v55.WailingArrow:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) or ((1556 + 158) >= (2144 + 814))) then
			if (v26(v55.WailingArrow, not v70, true) or ((2269 - 778) < (399 + 245))) then
				return "wailing_arrow st 36";
			end
		end
		if (((1371 - (89 + 578)) < (706 + 281)) and v55.KillCommand:IsCastable() and (v13:BuffDown(v55.TrueshotBuff))) then
			if (((7729 - 4011) > (2955 - (572 + 477))) and v26(v55.KillCommand, not v14:IsInRange(7 + 43))) then
				return "kill_command st 37";
			end
		end
		if ((v55.ChimaeraShot:IsReady() and (v13:BuffUp(v55.PreciseShotsBuff) or (v13:Focus() > (v55.ChimaeraShot:Cost() + v55.AimedShot:Cost())))) or ((575 + 383) > (434 + 3201))) then
			if (((3587 - (84 + 2)) <= (7402 - 2910)) and v26(v55.ChimaeraShot, not v70)) then
				return "chimaera_shot st 38";
			end
		end
		if ((v55.ArcaneShot:IsReady() and (v13:BuffUp(v55.PreciseShotsBuff) or (v13:Focus() > (v55.ArcaneShot:Cost() + v55.AimedShot:Cost())))) or ((2480 + 962) < (3390 - (497 + 345)))) then
			if (((74 + 2801) >= (248 + 1216)) and v26(v55.ArcaneShot, not v70)) then
				return "arcane_shot st 40";
			end
		end
		if (v55.BagofTricks:IsReady() or ((6130 - (605 + 728)) >= (3492 + 1401))) then
			if (v26(v55.BagofTricks, not v14:IsSpellInRange(v55.BagofTricks)) or ((1224 - 673) > (95 + 1973))) then
				return "bag_of_tricks st 42";
			end
		end
		if (((7815 - 5701) > (852 + 92)) and v55.SteadyShot:IsCastable()) then
			if (v26(v55.SteadyShot, not v70) or ((6266 - 4004) >= (2338 + 758))) then
				return "steady_shot st 44";
			end
		end
	end
	local function v89()
		local v107 = 489 - (457 + 32);
		while true do
			if ((v107 == (3 + 2)) or ((3657 - (832 + 570)) >= (3333 + 204))) then
				if ((v55.MultiShot:IsReady() and (v13:Focus() > (v55.MultiShot:Cost() + v55.AimedShot:Cost()))) or ((1001 + 2836) < (4621 - 3315))) then
					if (((1422 + 1528) == (3746 - (588 + 208))) and v26(v55.MultiShot, not v70)) then
						return "multishot trickshots 42";
					end
				end
				if ((v55.BagofTricks:IsReady() and (v13:BuffDown(v55.Trueshot))) or ((12729 - 8006) < (5098 - (884 + 916)))) then
					if (((2378 - 1242) >= (90 + 64)) and v26(v55.BagofTricks, not v14:IsSpellInRange(v55.BagofTricks))) then
						return "bag_of_tricks trickshots 44";
					end
				end
				if (v55.SteadyShot:IsCastable() or ((924 - (232 + 421)) > (6637 - (1569 + 320)))) then
					if (((1163 + 3577) >= (599 + 2553)) and v26(v55.SteadyShot, not v70)) then
						return "steady_shot trickshots 46";
					end
				end
				break;
			end
			if ((v107 == (6 - 4)) or ((3183 - (316 + 289)) >= (8874 - 5484))) then
				if (((2 + 39) <= (3114 - (666 + 787))) and v55.Barrage:IsReady() and (v69 > (432 - (360 + 65))) and v33) then
					if (((562 + 39) < (3814 - (79 + 175))) and v26(v55.Barrage, not v70)) then
						return "barrage trickshots 18";
					end
				end
				if (((370 - 135) < (537 + 150)) and v53 and v55.Volley:IsReady()) then
					if (((13943 - 9394) > (2220 - 1067)) and v26(v57.VolleyCursor)) then
						return "volley trickshots 20";
					end
				end
				if ((v55.Trueshot:IsReady() and v33 and not v13:IsCasting(v55.SteadyShot) and not v13:IsCasting(v55.RapidFire) and not v13:IsChanneling(v55.RapidFire)) or ((5573 - (503 + 396)) < (4853 - (92 + 89)))) then
					if (((7115 - 3447) < (2340 + 2221)) and v26(v55.Trueshot, not v70)) then
						return "trueshot trickshots 22";
					end
				end
				if ((v55.RapidFire:IsCastable() and (v13:BuffRemains(v55.TrickShotsBuff) >= v55.RapidFire:ExecuteTime()) and v55.SurgingShots:IsAvailable()) or ((270 + 185) == (14117 - 10512))) then
					if (v26(v55.RapidFire, not v70) or ((365 + 2298) == (7551 - 4239))) then
						return "rapid_fire trickshots 24";
					end
				end
				v107 = 3 + 0;
			end
			if (((2043 + 2234) <= (13629 - 9154)) and (v107 == (1 + 2))) then
				if (v55.AimedShot:IsReady() or ((1326 - 456) == (2433 - (485 + 759)))) then
					if (((3593 - 2040) <= (4322 - (442 + 747))) and v71.CastTargetIf(v55.AimedShot, v67, "min", v77, v84, not v70, nil, nil, v57.AimedShotMouseover, true)) then
						return "aimed_shot trickshots 26";
					end
				end
				if (v55.AimedShot:IsReady() or ((3372 - (832 + 303)) >= (4457 - (88 + 858)))) then
					if (v71.CastTargetIf(v55.AimedShot, v67, "max", v78, v85, not v70, nil, nil, v57.AimedShotMouseover, true) or ((404 + 920) > (2500 + 520))) then
						return "aimed_shot trickshots 28";
					end
				end
				if ((v55.RapidFire:IsCastable() and (v13:BuffRemains(v55.TrickShotsBuff) >= v55.RapidFire:ExecuteTime())) or ((124 + 2868) == (2670 - (766 + 23)))) then
					if (((15333 - 12227) > (2086 - 560)) and v26(v55.RapidFire, not v70)) then
						return "rapid_fire trickshots 30";
					end
				end
				if (((7964 - 4941) < (13134 - 9264)) and v55.ChimaeraShot:IsReady() and v13:BuffUp(v55.TrickShotsBuff) and v13:BuffUp(v55.PreciseShotsBuff) and (v13:Focus() > (v55.ChimaeraShot:Cost() + v55.AimedShot:Cost())) and (v69 < (1077 - (1036 + 37)))) then
					if (((102 + 41) > (143 - 69)) and v26(v55.ChimaeraShot, not v70)) then
						return "chimaera_shot trickshots 32";
					end
				end
				v107 = 4 + 0;
			end
			if (((1498 - (641 + 839)) < (3025 - (910 + 3))) and (v107 == (0 - 0))) then
				if (((2781 - (1466 + 218)) <= (749 + 879)) and v55.SteadyShot:IsCastable() and v55.SteadyFocus:IsAvailable() and (v63.Count == (1149 - (556 + 592))) and (v13:BuffRemains(v55.SteadyFocusBuff) < (3 + 5))) then
					if (((5438 - (329 + 479)) == (5484 - (174 + 680))) and v26(v55.SteadyShot, not v70)) then
						return "steady_shot trickshots 2";
					end
				end
				if (((12164 - 8624) > (5560 - 2877)) and v55.KillShot:IsReady()) then
					if (((3423 + 1371) >= (4014 - (396 + 343))) and v26(v55.KillShot, not v70)) then
						return "kill_shot trickshots 4";
					end
				end
				if (((132 + 1352) == (2961 - (29 + 1448))) and v16:Exists() and v55.KillShot:IsCastable() and (v16:HealthPercentage() <= (1409 - (135 + 1254)))) then
					if (((5394 - 3962) < (16598 - 13043)) and v26(v57.KillShotMouseover, not v16:IsSpellInRange(v55.KillShot))) then
						return "kill_shot_mouseover cleave 38";
					end
				end
				if (v55.ExplosiveShot:IsReady() or ((710 + 355) > (5105 - (389 + 1138)))) then
					if (v26(v55.ExplosiveShot, not v70) or ((5369 - (102 + 472)) < (1328 + 79))) then
						return "explosive_shot trickshots 8";
					end
				end
				v107 = 1 + 0;
			end
			if (((1728 + 125) < (6358 - (320 + 1225))) and (v107 == (1 - 0))) then
				if ((v55.DeathChakram:IsReady() and v33) or ((1727 + 1094) < (3895 - (157 + 1307)))) then
					if (v26(v55.DeathChakram, not v70) or ((4733 - (821 + 1038)) < (5441 - 3260))) then
						return "death_chakram trickshots 10";
					end
				end
				if ((v55.Stampede:IsReady() and v33) or ((295 + 2394) <= (608 - 265))) then
					if (v26(v55.Stampede, not v14:IsInRange(12 + 18)) or ((4632 - 2763) == (3035 - (834 + 192)))) then
						return "stampede trickshots 12";
					end
				end
				if (v55.WailingArrow:IsReady() or ((226 + 3320) < (596 + 1726))) then
					if (v26(v55.WailingArrow, not v70, true) or ((45 + 2037) == (7394 - 2621))) then
						return "wailing_arrow trickshots 14";
					end
				end
				if (((3548 - (300 + 4)) > (282 + 773)) and v55.SerpentSting:IsReady()) then
					if (v71.CastTargetIf(v55.SerpentSting, v67, "min", v76, v80, not v70, nil, nil, v57.SerpentStingMouseover) or ((8672 - 5359) <= (2140 - (112 + 250)))) then
						return "serpent_sting trickshots 16";
					end
				end
				v107 = 1 + 1;
			end
			if ((v107 == (9 - 5)) or ((815 + 606) >= (1089 + 1015))) then
				if (((1356 + 456) <= (1611 + 1638)) and v55.MultiShot:IsReady() and (not v74() or ((v13:BuffUp(v55.PreciseShotsBuff) or (v13:BuffStack(v55.BulletstormBuff) == (8 + 2))) and (v13:Focus() > (v55.MultiShot:Cost() + v55.AimedShot:Cost()))))) then
					if (((3037 - (1001 + 413)) <= (4363 - 2406)) and v26(v55.MultiShot, not v70)) then
						return "multishot trickshots 34";
					end
				end
				if (((5294 - (244 + 638)) == (5105 - (627 + 66))) and v55.SerpentSting:IsReady()) then
					if (((5214 - 3464) >= (1444 - (512 + 90))) and v71.CastTargetIf(v55.SerpentSting, v67, "min", v76, v81, not v70, nil, nil, v57.SerpentStingMouseover)) then
						return "serpent_sting trickshots 36";
					end
				end
				if (((6278 - (1665 + 241)) > (2567 - (373 + 344))) and v46 and v55.SteelTrap:IsCastable()) then
					if (((105 + 127) < (218 + 603)) and v26(v57.SteelTrapCursor, not v14:IsInRange(105 - 65))) then
						return "steel_trap trickshots 38";
					end
				end
				if (((876 - 358) < (2001 - (35 + 1064))) and v55.KillShot:IsReady() and (v13:Focus() > (v55.KillShot:Cost() + v55.AimedShot:Cost()))) then
					if (((2179 + 815) > (1835 - 977)) and v26(v55.KillShot, not v70)) then
						return "kill_shot trickshots 40";
					end
				end
				v107 = 1 + 4;
			end
		end
	end
	local function v90()
		local v108 = v13:GetUseableItems(v59, 1249 - (298 + 938));
		if ((v108 and (v13:BuffUp(v55.TrueshotBuff) or (v66 < (1272 - (233 + 1026))))) or ((5421 - (636 + 1030)) <= (468 + 447))) then
			if (((3855 + 91) > (1112 + 2631)) and v26(v57.Trinket1, nil, nil, true)) then
				return "trinket1 trinket 2";
			end
		end
		local v109 = v13:GetUseableItems(v59, 1 + 13);
		if ((v109 and (v13:BuffUp(v55.TrueshotBuff) or (v66 < (234 - (55 + 166))))) or ((259 + 1076) >= (333 + 2973))) then
			if (((18499 - 13655) > (2550 - (36 + 261))) and v26(v57.Trinket2, nil, nil, true)) then
				return "trinket2 trinket 4";
			end
		end
	end
	local function v91()
		v54();
		v31 = EpicSettings.Toggles['ooc'];
		v32 = EpicSettings.Toggles['aoe'];
		v33 = EpicSettings.Toggles['cds'];
		v70 = v14:IsSpellInRange(v55.AimedShot);
		v67 = v13:GetEnemiesInRange(v55.AimedShot.MaximumRange);
		v68 = v14:GetEnemiesInSplashRange(17 - 7);
		if (((1820 - (34 + 1334)) == (174 + 278)) and v23()) then
			v69 = v14:GetEnemiesInSplashRangeCount(8 + 2);
		else
			v69 = 1284 - (1035 + 248);
		end
		if (v71.TargetIsValid() or v13:AffectingCombat() or ((4578 - (20 + 1)) < (1088 + 999))) then
			local v114 = 319 - (134 + 185);
			while true do
				if (((5007 - (549 + 584)) == (4559 - (314 + 371))) and (v114 == (0 - 0))) then
					v65 = v10.BossFightRemains(nil, true);
					v66 = v65;
					v114 = 969 - (478 + 490);
				end
				if ((v114 == (1 + 0)) or ((3110 - (786 + 386)) > (15984 - 11049))) then
					if ((v66 == (12490 - (1055 + 324))) or ((5595 - (1093 + 247)) < (3042 + 381))) then
						v66 = v10.FightRemains(v68, false);
					end
					break;
				end
			end
		end
		if (((153 + 1301) <= (9889 - 7398)) and v71.TargetIsValid()) then
			local v115 = 0 - 0;
			while true do
				if ((v115 == (2 - 1)) or ((10446 - 6289) <= (998 + 1805))) then
					if (((18695 - 13842) >= (10278 - 7296)) and (v13:HealthPercentage() <= v40) and v56.Healthstone:IsReady()) then
						if (((3118 + 1016) > (8584 - 5227)) and v26(v57.Healthstone, nil, nil, true)) then
							return "healthstone";
						end
					end
					if ((not v13:IsCasting() and not v13:IsChanneling()) or ((4105 - (364 + 324)) < (6946 - 4412))) then
						local v130 = 0 - 0;
						local v131;
						while true do
							if ((v130 == (1 + 0)) or ((11389 - 8667) <= (262 - 98))) then
								v131 = v71.InterruptWithStun(v55.Intimidation, 121 - 81);
								if (v131 or ((3676 - (1249 + 19)) < (1904 + 205))) then
									return v131;
								end
								v130 = 7 - 5;
							end
							if ((v130 == (1086 - (686 + 400))) or ((26 + 7) == (1684 - (73 + 156)))) then
								v131 = v71.Interrupt(v55.CounterShot, 1 + 39, true);
								if (v131 or ((1254 - (721 + 90)) >= (46 + 3969))) then
									return v131;
								end
								v130 = 3 - 2;
							end
							if (((3852 - (224 + 246)) > (268 - 102)) and (v130 == (3 - 1))) then
								v131 = v71.Interrupt(v55.CounterShot, 8 + 32, true, v16, v57.CounterShotMouseover);
								if (v131 or ((7 + 273) == (2247 + 812))) then
									return v131;
								end
								v130 = 5 - 2;
							end
							if (((6259 - 4378) > (1806 - (203 + 310))) and (v130 == (1996 - (1238 + 755)))) then
								v131 = v71.InterruptWithStun(v55.Intimidation, 3 + 37, false, v16, v57.IntimidationMouseover);
								if (((3891 - (709 + 825)) == (4343 - 1986)) and v131) then
									return v131;
								end
								break;
							end
						end
					end
					if (((178 - 55) == (987 - (196 + 668))) and v52 and v55.TranquilizingShot:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and (v71.UnitHasEnrageBuff(v14) or v71.UnitHasMagicBuff(v14))) then
						if (v26(v55.TranquilizingShot, not v70) or ((4169 - 3113) >= (7026 - 3634))) then
							return "dispel";
						end
					end
					v115 = 835 - (171 + 662);
				end
				if ((v115 == (93 - (4 + 89))) or ((3788 - 2707) < (392 + 683))) then
					v75();
					if ((not v13:AffectingCombat() and not v31) or ((4607 - 3558) >= (1739 + 2693))) then
						local v132 = v86();
						if (v132 or ((6254 - (35 + 1451)) <= (2299 - (28 + 1425)))) then
							return v132;
						end
					end
					if ((v55.Exhilaration:IsReady() and (v13:HealthPercentage() <= v51)) or ((5351 - (941 + 1052)) <= (1362 + 58))) then
						if (v26(v55.Exhilaration) or ((5253 - (822 + 692)) <= (4289 - 1284))) then
							return "exhilaration";
						end
					end
					v115 = 1 + 0;
				end
				if ((v115 == (299 - (45 + 252))) or ((1642 + 17) >= (735 + 1399))) then
					v64 = v55.Trueshot:CooldownUp();
					if ((v35 and v33) or ((7934 - 4674) < (2788 - (114 + 319)))) then
						local v133 = 0 - 0;
						local v134;
						while true do
							if ((v133 == (0 - 0)) or ((427 + 242) == (6291 - 2068))) then
								v134 = v90();
								if (v134 or ((3544 - 1852) < (2551 - (556 + 1407)))) then
									return v134;
								end
								break;
							end
						end
					end
					if (v33 or ((6003 - (741 + 465)) < (4116 - (170 + 295)))) then
						local v135 = v87();
						if (v135 or ((2201 + 1976) > (4455 + 395))) then
							return v135;
						end
					end
					v115 = 7 - 4;
				end
				if ((v115 == (3 + 0)) or ((257 + 143) > (630 + 481))) then
					if (((4281 - (957 + 273)) > (269 + 736)) and ((v69 < (2 + 1)) or not v55.TrickShots:IsAvailable() or not v32)) then
						local v136 = 0 - 0;
						local v137;
						while true do
							if (((9731 - 6038) <= (13384 - 9002)) and ((0 - 0) == v136)) then
								v137 = v88();
								if (v137 or ((5062 - (389 + 1391)) > (2573 + 1527))) then
									return v137;
								end
								break;
							end
						end
					end
					if ((v69 > (1 + 1)) or ((8150 - 4570) < (3795 - (783 + 168)))) then
						local v138 = v89();
						if (((298 - 209) < (4417 + 73)) and v138) then
							return v138;
						end
					end
					if (v26(v55.PoolFocus) or ((5294 - (309 + 2)) < (5552 - 3744))) then
						return "Pooling Focus";
					end
					break;
				end
			end
		end
	end
	local function v92()
		v10.Print("Marksmanship by Epic. Supported by Gojira");
	end
	v10.SetAPL(1466 - (1090 + 122), v91, v92);
end;
return v0["Epix_Hunter_Marksmanship.lua"]();

