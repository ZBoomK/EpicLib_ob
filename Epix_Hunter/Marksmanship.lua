local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (550 - (400 + 150))) or ((840 - 566) == (2019 + 1563))) then
			v6 = v0[v4];
			if (not v6 or ((3552 - (1607 + 27)) == (310 + 765))) then
				return v1(v4, ...);
			end
			v5 = 1727 - (1668 + 58);
		end
		if (((1022 - (512 + 114)) <= (9917 - 6113)) and (v5 == (1 - 0))) then
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
		local v93 = 0 - 0;
		while true do
			if ((v93 == (2 + 1)) or ((781 + 3388) == (1902 + 285))) then
				v44 = EpicSettings.Settings['UsePet'];
				v45 = EpicSettings.Settings['SummonPetSlot'] or (0 - 0);
				v46 = EpicSettings.Settings['UseSteelTrap'];
				v93 = 1998 - (109 + 1885);
			end
			if (((2875 - (1269 + 200)) == (2694 - 1288)) and (v93 == (817 - (98 + 717)))) then
				v41 = EpicSettings.Settings['InterruptWithStun'] or (826 - (802 + 24));
				v42 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v43 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v93 = 1 + 2;
			end
			if (((1177 + 354) < (702 + 3569)) and (v93 == (2 + 4))) then
				v53 = EpicSettings.Settings['UseVolley'];
				break;
			end
			if (((1766 - 1131) == (2117 - 1482)) and (v93 == (2 + 2))) then
				v47 = EpicSettings.Settings['UseRevive'];
				v48 = EpicSettings.Settings['UseMendPet'];
				v49 = EpicSettings.Settings['MendPetHP'] or (0 + 0);
				v93 = 5 + 0;
			end
			if (((2453 + 920) <= (1661 + 1895)) and (v93 == (1438 - (797 + 636)))) then
				v50 = EpicSettings.Settings['UseExhilaration'];
				v51 = EpicSettings.Settings['ExhilarationHP'] or (0 - 0);
				v52 = EpicSettings.Settings['UseTranq'];
				v93 = 1625 - (1427 + 192);
			end
			if ((v93 == (0 + 0)) or ((7640 - 4349) < (2949 + 331))) then
				v34 = EpicSettings.Settings['UseRacials'];
				v36 = EpicSettings.Settings['UseHealingPotion'];
				v37 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v93 = 327 - (192 + 134);
			end
			if (((5662 - (316 + 960)) >= (486 + 387)) and (v93 == (1 + 0))) then
				v38 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v39 = EpicSettings.Settings['UseHealthstone'];
				v40 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v93 = 553 - (83 + 468);
			end
		end
	end
	local v55 = v18.Hunter.Marksmanship;
	local v56 = v20.Hunter.Marksmanship;
	local v57 = v22.Hunter.Marksmanship;
	local v58 = {v55.SummonPet,v55.SummonPet2,v55.SummonPet3,v55.SummonPet4,v55.SummonPet5};
	local v59 = {};
	local v60 = v13:GetEquipment();
	local v61 = (v60[13 + 0] and v20(v60[12 + 1])) or v20(0 + 0);
	local v62 = (v60[8 + 6] and v20(v60[3 + 11])) or v20(0 - 0);
	local v63 = {LastCast=(1911 - (340 + 1571)),Count=(0 + 0)};
	local v64;
	local v65 = 12883 - (1733 + 39);
	local v66 = 30531 - 19420;
	local v67;
	local v68;
	local v69;
	local v70;
	local v71 = v10.Commons.Everyone;
	local v72 = (v14:HealthPercentage() > (1104 - (125 + 909))) and v55.CarefulAim:IsAvailable();
	local v73 = {{v55.Intimidation,"Cast Intimidation (Interrupt)",function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		local v94 = 512 - (409 + 103);
		while true do
			if (((1157 - (46 + 190)) <= (1197 - (51 + 44))) and (v94 == (0 + 0))) then
				v60 = v13:GetEquipment();
				v61 = (v60[1330 - (1114 + 203)] and v20(v60[739 - (228 + 498)])) or v20(0 + 0);
				v94 = 1 + 0;
			end
			if (((5369 - (174 + 489)) >= (2508 - 1545)) and (v94 == (1906 - (830 + 1075)))) then
				v62 = (v60[538 - (303 + 221)] and v20(v60[1283 - (231 + 1038)])) or v20(0 + 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v95 = 1162 - (171 + 991);
		while true do
			if ((v95 == (0 - 0)) or ((2577 - 1617) <= (2185 - 1309))) then
				v63 = {LastCast=(0 + 0),Count=(0 - 0)};
				v65 = 32052 - 20941;
				v95 = 1 - 0;
			end
			if ((v95 == (3 - 2)) or ((3314 - (111 + 1137)) == (1090 - (91 + 67)))) then
				v66 = 33069 - 21958;
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
		local v96 = 0 + 0;
		while true do
			if (((5348 - (423 + 100)) < (34 + 4809)) and (v96 == (2 - 1))) then
				if ((v55.SteadyFocusBuff.LastAppliedOnPlayerTime > v63.LastCast) or ((2021 + 1856) >= (5308 - (326 + 445)))) then
					v63.Count = 0 - 0;
				end
				break;
			end
			if ((v96 == (0 - 0)) or ((10071 - 5756) < (2437 - (530 + 181)))) then
				if ((((v63.Count == (881 - (614 + 267))) or (v63.Count == (33 - (19 + 13)))) and v13:IsCasting(v55.SteadyShot) and (v63.LastCast < (v27() - v55.SteadyShot:CastTime()))) or ((5987 - 2308) < (1456 - 831))) then
					local v130 = 0 - 0;
					while true do
						if ((v130 == (0 + 0)) or ((8133 - 3508) < (1310 - 678))) then
							v63.LastCast = v27();
							v63.Count = v63.Count + (1813 - (1293 + 519));
							break;
						end
					end
				end
				if (not (v13:IsCasting(v55.SteadyShot) or v13:PrevGCDP(1 - 0, v55.SteadyShot)) or ((216 - 133) > (3403 - 1623))) then
					v63.Count = 0 - 0;
				end
				v96 = 2 - 1;
			end
		end
	end
	local function v76(v97)
		return (v97:DebuffRemains(v55.SerpentStingDebuff));
	end
	local function v77(v98)
		return v98:DebuffRemains(v55.SerpentStingDebuff) + (v29(v55.SerpentSting:InFlight()) * (53 + 46));
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
		return v55.SerpentstalkersTrickery:IsAvailable() and (v13:BuffDown(v55.PreciseShotsBuff) or ((v13:BuffUp(v55.TrueshotBuff) or (v55.AimedShot:FullRechargeTime() < (v13:GCD() + v55.AimedShot:CastTime()))) and (not v55.ChimaeraShot:IsAvailable() or (v69 < (1 + 1)))) or ((v13:BuffRemains(v55.TrickShotsBuff) > v55.AimedShot:ExecuteTime()) and (v69 > (2 - 1))));
	end
	local function v83(v104)
		return v13:BuffDown(v55.PreciseShotsBuff) or ((v13:BuffUp(v55.TrueshotBuff) or (v55.AimedShot:FullRechargeTime() < (v13:GCD() + v55.AimedShot:CastTime()))) and (not v55.ChimaeraShot:IsAvailable() or (v69 < (1 + 1)))) or ((v13:BuffRemains(v55.TrickShotsBuff) > v55.AimedShot:ExecuteTime()) and (v69 > (1 + 0)));
	end
	local function v84(v105)
		return v55.SerpentstalkersTrickery:IsAvailable() and (v13:BuffRemains(v55.TrickShotsBuff) >= v55.AimedShot:ExecuteTime()) and (v13:BuffDown(v55.PreciseShotsBuff) or v13:BuffUp(v55.TrueshotBuff) or (v55.AimedShot:FullRechargeTime() < (v55.AimedShot:CastTime() + v13:GCD())));
	end
	local function v85(v106)
		return (v13:BuffRemains(v55.TrickShotsBuff) >= v55.AimedShot:ExecuteTime()) and (v13:BuffDown(v55.PreciseShotsBuff) or v13:BuffUp(v55.TrueshotBuff) or (v55.AimedShot:FullRechargeTime() < (v55.AimedShot:CastTime() + v13:GCD())));
	end
	local function v86()
		local v107 = 0 + 0;
		while true do
			if (((1642 - (709 + 387)) <= (2935 - (673 + 1185))) and (v107 == (0 - 0))) then
				if ((v15 and v15:Exists() and v55.Misdirection:IsReady()) or ((3198 - 2202) > (7076 - 2775))) then
					if (((2912 + 1158) > (514 + 173)) and v26(v57.MisdirectionFocus)) then
						return "misdirection opener";
					end
				end
				if ((v55.SummonPet:IsCastable() and not v55.LoneWolf:IsAvailable() and v44) or ((884 - 228) >= (818 + 2512))) then
					if (v26(v58[v45]) or ((4968 - 2476) <= (657 - 322))) then
						return "Summon Pet opener";
					end
				end
				v107 = 1881 - (446 + 1434);
			end
			if (((5605 - (1040 + 243)) >= (7646 - 5084)) and (v107 == (1848 - (559 + 1288)))) then
				if ((v55.Salvo:IsCastable() and v33) or ((5568 - (609 + 1322)) >= (4224 - (13 + 441)))) then
					if (v26(v55.Salvo) or ((8889 - 6510) > (11991 - 7413))) then
						return "salvo opener";
					end
				end
				if ((v55.AimedShot:IsReady() and not v13:IsCasting(v55.AimedShot) and (v69 < (14 - 11)) and (not v55.Volley:IsAvailable() or (v69 < (1 + 1)))) or ((1754 - 1271) > (264 + 479))) then
					if (((1076 + 1378) > (1715 - 1137)) and v26(v55.AimedShot, not v70, true)) then
						return "aimed_shot opener";
					end
				end
				v107 = 2 + 0;
			end
			if (((1710 - 780) < (2948 + 1510)) and (v107 == (2 + 0))) then
				if (((476 + 186) <= (817 + 155)) and v55.WailingArrow:IsReady() and not v13:IsCasting(v55.WailingArrow) and ((v69 > (2 + 0)) or not v55.SteadyFocus:IsAvailable())) then
					if (((4803 - (153 + 280)) == (12618 - 8248)) and v26(v55.WailingArrow, not v70, true)) then
						return "wailing_arrow opener";
					end
				end
				if ((v55.SteadyShot:IsCastable() and ((v69 > (2 + 0)) or (v55.Volley:IsAvailable() and (v69 == (1 + 1))))) or ((2493 + 2269) <= (782 + 79))) then
					if (v26(v55.SteadyShot, not v70) or ((1024 + 388) == (6492 - 2228))) then
						return "steady_shot opener";
					end
				end
				break;
			end
		end
	end
	local function v87()
		local v108 = 0 + 0;
		while true do
			if ((v108 == (669 - (89 + 578))) or ((2264 + 904) < (4475 - 2322))) then
				if ((v55.LightsJudgment:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) or ((6025 - (572 + 477)) < (180 + 1152))) then
					if (((2778 + 1850) == (553 + 4075)) and v26(v55.LightsJudgment, not v14:IsSpellInRange(v55.LightsJudgment))) then
						return "lights_judgment cds 10";
					end
				end
				if ((v55.Salvo:IsCastable() and ((v69 > (88 - (84 + 2))) or (v55.Volley:CooldownRemains() < (16 - 6)))) or ((39 + 15) == (1237 - (497 + 345)))) then
					if (((3 + 79) == (14 + 68)) and v26(v55.Salvo)) then
						return "salvo cds 14";
					end
				end
				break;
			end
			if ((v108 == (1334 - (605 + 728))) or ((415 + 166) < (626 - 344))) then
				if ((v55.AncestralCall:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v55.Trueshot:CooldownRemains() > (2 + 28)) or (v66 < (59 - 43)))) or ((4155 + 454) < (6912 - 4417))) then
					if (((870 + 282) == (1641 - (457 + 32))) and v26(v55.AncestralCall)) then
						return "ancestral_call cds 6";
					end
				end
				if (((805 + 1091) <= (4824 - (832 + 570))) and v55.Fireblood:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v55.Trueshot:CooldownRemains() > (29 + 1)) or (v66 < (3 + 6)))) then
					if (v26(v55.Fireblood) or ((3503 - 2513) > (781 + 839))) then
						return "fireblood cds 8";
					end
				end
				v108 = 798 - (588 + 208);
			end
			if ((v108 == (0 - 0)) or ((2677 - (884 + 916)) > (9829 - 5134))) then
				if (((1561 + 1130) >= (2504 - (232 + 421))) and v55.Berserking:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v66 < (1902 - (1569 + 320))))) then
					if (v26(v55.Berserking) or ((733 + 2252) >= (923 + 3933))) then
						return "berserking cds 2";
					end
				end
				if (((14409 - 10133) >= (1800 - (316 + 289))) and v55.BloodFury:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v55.Trueshot:CooldownRemains() > (78 - 48)) or (v66 < (1 + 15)))) then
					if (((4685 - (666 + 787)) <= (5115 - (360 + 65))) and v26(v55.BloodFury)) then
						return "blood_fury cds 4";
					end
				end
				v108 = 1 + 0;
			end
		end
	end
	local function v88()
		local v109 = 254 - (79 + 175);
		while true do
			if ((v109 == (2 - 0)) or ((700 + 196) >= (9642 - 6496))) then
				if (((5894 - 2833) >= (3857 - (503 + 396))) and v55.Stampede:IsCastable() and v33) then
					if (((3368 - (92 + 89)) >= (1249 - 605)) and v26(v55.Stampede, not v14:IsInRange(16 + 14))) then
						return "stampede st 14";
					end
				end
				if (((382 + 262) <= (2756 - 2052)) and v55.DeathChakram:IsReady() and v33) then
					if (((132 + 826) > (2159 - 1212)) and v26(v55.DeathChakram, not v70)) then
						return "dark_chakram st 16";
					end
				end
				if (((3920 + 572) >= (1268 + 1386)) and v55.WailingArrow:IsReady() and (v69 > (2 - 1))) then
					if (((430 + 3012) >= (2291 - 788)) and v26(v55.WailingArrow, not v70, true)) then
						return "wailing_arrow st 18";
					end
				end
				if ((v55.RapidFire:IsCastable() and (v55.SurgingShots:IsAvailable() or (v55.AimedShot:FullRechargeTime() > (v55.AimedShot:CastTime() + v55.RapidFire:CastTime())))) or ((4414 - (485 + 759)) <= (3387 - 1923))) then
					if (v26(v55.RapidFire, not v70) or ((5986 - (442 + 747)) == (5523 - (832 + 303)))) then
						return "rapid_fire st 22";
					end
				end
				v109 = 949 - (88 + 858);
			end
			if (((168 + 383) <= (564 + 117)) and (v109 == (1 + 2))) then
				if (((4066 - (766 + 23)) > (2009 - 1602)) and v55.KillShot:IsReady()) then
					if (((6420 - 1725) >= (3728 - 2313)) and v26(v55.KillShot, not v70)) then
						return "kill_shot st 24";
					end
				end
				if ((v55.Trueshot:IsReady() and v33 and v64 and (v13:BuffDown(v55.TrueshotBuff) or (v13:BuffRemains(v55.TrueshotBuff) < (16 - 11)))) or ((4285 - (1036 + 37)) <= (670 + 274))) then
					if (v26(v55.Trueshot, not v70) or ((6029 - 2933) <= (1415 + 383))) then
						return "trueshot st 26";
					end
				end
				if (((5017 - (641 + 839)) == (4450 - (910 + 3))) and v55.MultiShot:IsReady() and ((v13:BuffUp(v55.BombardmentBuff) and not v74() and (v69 > (2 - 1))) or (v13:BuffUp(v55.SalvoBuff) and not v55.Volley:IsAvailable()))) then
					if (((5521 - (1466 + 218)) >= (722 + 848)) and v26(v55.MultiShot, not v70)) then
						return "multishot st 26";
					end
				end
				if (v55.AimedShot:IsReady() or ((4098 - (556 + 592)) == (1356 + 2456))) then
					if (((5531 - (329 + 479)) >= (3172 - (174 + 680))) and v71.CastTargetIf(v55.AimedShot, v67, "min", v77, v82, not v70, nil, nil, v57.AimedShotMouseover, true)) then
						return "aimed_shot st 28";
					end
				end
				v109 = 13 - 9;
			end
			if ((v109 == (0 - 0)) or ((1448 + 579) > (3591 - (396 + 343)))) then
				if ((v55.SteadyShot:IsCastable() and v55.SteadyFocus:IsAvailable() and (((v63.Count == (1 + 0)) and (v13:BuffRemains(v55.SteadyFocusBuff) < (1482 - (29 + 1448)))) or (v13:BuffDown(v55.SteadyFocusBuff) and v13:BuffDown(v55.TrueshotBuff) and (v63.Count ~= (1391 - (135 + 1254)))))) or ((4279 - 3143) > (20156 - 15839))) then
					if (((3165 + 1583) == (6275 - (389 + 1138))) and v26(v55.SteadyShot, not v70)) then
						return "steady_shot st 2";
					end
				end
				if (((4310 - (102 + 472)) <= (4474 + 266)) and v55.AimedShot:IsReady() and v13:BuffUp(v55.TrueshotBuff) and (v55.AimedShot:FullRechargeTime() < (v13:GCD() + v55.AimedShot:CastTime())) and v55.LegacyoftheWindrunners:IsAvailable() and v55.WindrunnersGuidance:IsAvailable()) then
					if (v26(v55.AimedShot, not v70, true) or ((1880 + 1510) <= (2854 + 206))) then
						return "aimed_shot st 4";
					end
				end
				if ((v55.KillShot:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) or ((2544 - (320 + 1225)) > (4793 - 2100))) then
					if (((284 + 179) < (2065 - (157 + 1307))) and v26(v55.KillShot, not v70)) then
						return "kill_shot st 6";
					end
				end
				if ((v53 and v55.Volley:IsReady() and (v16:GUID() == v14:GUID()) and (v13:BuffUp(v55.SalvoBuff))) or ((4042 - (821 + 1038)) < (1713 - 1026))) then
					if (((498 + 4051) == (8079 - 3530)) and v26(v57.VolleyCursor, not v70)) then
						return "volley st 5";
					end
				end
				v109 = 1 + 0;
			end
			if (((11579 - 6907) == (5698 - (834 + 192))) and (v109 == (1 + 3))) then
				if (v55.AimedShot:IsReady() or ((942 + 2726) < (9 + 386))) then
					if (v71.CastTargetIf(v55.AimedShot, v67, "max", v78, v83, not v70, nil, nil, v57.AimedShotMouseover, true) or ((6453 - 2287) == (759 - (300 + 4)))) then
						return "aimed_shot st 30";
					end
				end
				if ((v53 and v55.Volley:IsReady() and (v16:GUID() == v14:GUID())) or ((1189 + 3260) == (6971 - 4308))) then
					if (v26(v57.VolleyCursor, not v70) or ((4639 - (112 + 250)) < (1192 + 1797))) then
						return "volley st 20";
					end
				end
				if (v55.RapidFire:IsCastable() or ((2179 - 1309) >= (2377 + 1772))) then
					if (((1144 + 1068) < (2381 + 802)) and v26(v55.RapidFire, not v70)) then
						return "rapid_fire st 34";
					end
				end
				if (((2304 + 2342) > (2223 + 769)) and v55.WailingArrow:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) then
					if (((2848 - (1001 + 413)) < (6926 - 3820)) and v26(v55.WailingArrow, not v70, true)) then
						return "wailing_arrow st 36";
					end
				end
				v109 = 887 - (244 + 638);
			end
			if (((1479 - (627 + 66)) < (9007 - 5984)) and (v109 == (607 - (512 + 90)))) then
				if ((v55.KillCommand:IsCastable() and (v13:BuffDown(v55.TrueshotBuff))) or ((4348 - (1665 + 241)) < (791 - (373 + 344)))) then
					if (((2046 + 2489) == (1200 + 3335)) and v26(v55.KillCommand, not v14:IsInRange(131 - 81))) then
						return "kill_command st 37";
					end
				end
				if ((v55.ChimaeraShot:IsReady() and (v13:BuffUp(v55.PreciseShotsBuff) or (v13:Focus() > (v55.ChimaeraShot:Cost() + v55.AimedShot:Cost())))) or ((5091 - 2082) <= (3204 - (35 + 1064)))) then
					if (((1332 + 498) < (7849 - 4180)) and v26(v55.ChimaeraShot, not v70)) then
						return "chimaera_shot st 38";
					end
				end
				if ((v55.ArcaneShot:IsReady() and (v13:BuffUp(v55.PreciseShotsBuff) or (v13:Focus() > (v55.ArcaneShot:Cost() + v55.AimedShot:Cost())))) or ((6 + 1424) >= (4848 - (298 + 938)))) then
					if (((3942 - (233 + 1026)) >= (4126 - (636 + 1030))) and v26(v55.ArcaneShot, not v70)) then
						return "arcane_shot st 40";
					end
				end
				if (v55.BagofTricks:IsReady() or ((923 + 881) >= (3199 + 76))) then
					if (v26(v55.BagofTricks, not v14:IsSpellInRange(v55.BagofTricks)) or ((421 + 996) > (246 + 3383))) then
						return "bag_of_tricks st 42";
					end
				end
				v109 = 227 - (55 + 166);
			end
			if (((930 + 3865) > (41 + 361)) and (v109 == (22 - 16))) then
				if (((5110 - (36 + 261)) > (6234 - 2669)) and v55.SteadyShot:IsCastable()) then
					if (((5280 - (34 + 1334)) == (1504 + 2408)) and v26(v55.SteadyShot, not v70)) then
						return "steady_shot st 44";
					end
				end
				break;
			end
			if (((2192 + 629) <= (6107 - (1035 + 248))) and (v109 == (22 - (20 + 1)))) then
				if (((906 + 832) <= (2514 - (134 + 185))) and v16:Exists() and v55.KillShot:IsCastable() and (v16:HealthPercentage() <= (1153 - (549 + 584)))) then
					if (((726 - (314 + 371)) <= (10360 - 7342)) and v26(v57.KillShotMouseover, not v16:IsSpellInRange(v55.KillShot))) then
						return "kill_shot_mouseover cleave 38";
					end
				end
				if (((3113 - (478 + 490)) <= (2175 + 1929)) and v46 and v55.SteelTrap:IsCastable() and (v14:GUID() == v16:GUID()) and (v13:BuffDown(v55.TrueshotBuff))) then
					if (((3861 - (786 + 386)) < (15692 - 10847)) and v26(v57.SteelTrapCursor, not v14:IsInRange(1419 - (1055 + 324)))) then
						return "steel_trap st 6";
					end
				end
				if ((v55.SerpentSting:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) or ((3662 - (1093 + 247)) > (2330 + 292))) then
					if (v71.CastTargetIf(v55.SerpentSting, v67, "min", v76, v79, not v70, nil, nil, v57.SerpentStingMouseover) or ((477 + 4057) == (8265 - 6183))) then
						return "serpent_sting st 8";
					end
				end
				if (v55.ExplosiveShot:IsReady() or ((5331 - 3760) > (5312 - 3445))) then
					if (v26(v55.ExplosiveShot, not v70) or ((6669 - 4015) >= (1066 + 1930))) then
						return "explosive_shot st 10";
					end
				end
				v109 = 7 - 5;
			end
		end
	end
	local function v89()
		local v110 = 0 - 0;
		while true do
			if (((3000 + 978) > (5380 - 3276)) and ((689 - (364 + 324)) == v110)) then
				if (((8210 - 5215) > (3697 - 2156)) and v55.ExplosiveShot:IsReady()) then
					if (((1077 + 2172) > (3987 - 3034)) and v26(v55.ExplosiveShot, not v70)) then
						return "explosive_shot trickshots 8";
					end
				end
				if ((v55.DeathChakram:IsReady() and v33) or ((5241 - 1968) > (13888 - 9315))) then
					if (v26(v55.DeathChakram, not v70) or ((4419 - (1249 + 19)) < (1159 + 125))) then
						return "death_chakram trickshots 10";
					end
				end
				if ((v55.Stampede:IsReady() and v33) or ((7201 - 5351) == (2615 - (686 + 400)))) then
					if (((645 + 176) < (2352 - (73 + 156))) and v26(v55.Stampede, not v14:IsInRange(1 + 29))) then
						return "stampede trickshots 12";
					end
				end
				v110 = 813 - (721 + 90);
			end
			if (((11 + 891) < (7549 - 5224)) and ((477 - (224 + 246)) == v110)) then
				if (((1389 - 531) <= (5453 - 2491)) and v55.BagofTricks:IsReady() and (v13:BuffDown(v55.Trueshot))) then
					if (v26(v55.BagofTricks, not v14:IsSpellInRange(v55.BagofTricks)) or ((716 + 3230) < (31 + 1257))) then
						return "bag_of_tricks trickshots 44";
					end
				end
				if (v55.SteadyShot:IsCastable() or ((2382 + 860) == (1126 - 559))) then
					if (v26(v55.SteadyShot, not v70) or ((2818 - 1971) >= (1776 - (203 + 310)))) then
						return "steady_shot trickshots 46";
					end
				end
				break;
			end
			if ((v110 == (1998 - (1238 + 755))) or ((158 + 2095) == (3385 - (709 + 825)))) then
				if ((v55.ChimaeraShot:IsReady() and v13:BuffUp(v55.TrickShotsBuff) and v13:BuffUp(v55.PreciseShotsBuff) and (v13:Focus() > (v55.ChimaeraShot:Cost() + v55.AimedShot:Cost())) and (v69 < (7 - 3))) or ((3040 - 953) > (3236 - (196 + 668)))) then
					if (v26(v55.ChimaeraShot, not v70) or ((17550 - 13105) < (8593 - 4444))) then
						return "chimaera_shot trickshots 32";
					end
				end
				if ((v55.MultiShot:IsReady() and (not v74() or ((v13:BuffUp(v55.PreciseShotsBuff) or (v13:BuffStack(v55.BulletstormBuff) == (843 - (171 + 662)))) and (v13:Focus() > (v55.MultiShot:Cost() + v55.AimedShot:Cost()))))) or ((1911 - (4 + 89)) == (297 - 212))) then
					if (((230 + 400) < (9342 - 7215)) and v26(v55.MultiShot, not v70)) then
						return "multishot trickshots 34";
					end
				end
				if (v55.SerpentSting:IsReady() or ((760 + 1178) == (4000 - (35 + 1451)))) then
					if (((5708 - (28 + 1425)) >= (2048 - (941 + 1052))) and v71.CastTargetIf(v55.SerpentSting, v67, "min", v76, v81, not v70, nil, nil, v57.SerpentStingMouseover)) then
						return "serpent_sting trickshots 36";
					end
				end
				v110 = 6 + 0;
			end
			if (((4513 - (822 + 692)) > (1649 - 493)) and (v110 == (2 + 2))) then
				if (((2647 - (45 + 252)) > (1143 + 12)) and v55.AimedShot:IsReady()) then
					if (((1387 + 2642) <= (11810 - 6957)) and v71.CastTargetIf(v55.AimedShot, v67, "min", v77, v84, not v70, nil, nil, v57.AimedShotMouseover, true)) then
						return "aimed_shot trickshots 26";
					end
				end
				if (v55.AimedShot:IsReady() or ((949 - (114 + 319)) > (4930 - 1496))) then
					if (((5184 - 1138) >= (1934 + 1099)) and v71.CastTargetIf(v55.AimedShot, v67, "max", v78, v85, not v70, nil, nil, v57.AimedShotMouseover, true)) then
						return "aimed_shot trickshots 28";
					end
				end
				if ((v55.RapidFire:IsCastable() and (v13:BuffRemains(v55.TrickShotsBuff) >= v55.RapidFire:ExecuteTime())) or ((4050 - 1331) <= (3031 - 1584))) then
					if (v26(v55.RapidFire, not v70) or ((6097 - (556 + 1407)) < (5132 - (741 + 465)))) then
						return "rapid_fire trickshots 30";
					end
				end
				v110 = 470 - (170 + 295);
			end
			if ((v110 == (4 + 2)) or ((151 + 13) >= (6856 - 4071))) then
				if ((v46 and v55.SteelTrap:IsCastable() and (v14:GUID() == v16:GUID())) or ((436 + 89) == (1353 + 756))) then
					if (((19 + 14) == (1263 - (957 + 273))) and v26(v57.SteelTrapCursor, not v14:IsInRange(11 + 29))) then
						return "steel_trap trickshots 38";
					end
				end
				if (((1223 + 1831) <= (15298 - 11283)) and v55.KillShot:IsReady() and (v13:Focus() > (v55.KillShot:Cost() + v55.AimedShot:Cost()))) then
					if (((4930 - 3059) < (10329 - 6947)) and v26(v55.KillShot, not v70)) then
						return "kill_shot trickshots 40";
					end
				end
				if (((6402 - 5109) <= (3946 - (389 + 1391))) and v55.MultiShot:IsReady() and (v13:Focus() > (v55.MultiShot:Cost() + v55.AimedShot:Cost()))) then
					if (v26(v55.MultiShot, not v70) or ((1619 + 960) < (13 + 110))) then
						return "multishot trickshots 42";
					end
				end
				v110 = 15 - 8;
			end
			if ((v110 == (951 - (783 + 168))) or ((2839 - 1993) >= (2330 + 38))) then
				if ((v55.SteadyShot:IsCastable() and v55.SteadyFocus:IsAvailable() and (v63.Count == (312 - (309 + 2))) and (v13:BuffRemains(v55.SteadyFocusBuff) < (24 - 16))) or ((5224 - (1090 + 122)) <= (1089 + 2269))) then
					if (((5017 - 3523) <= (2057 + 948)) and v26(v55.SteadyShot, not v70)) then
						return "steady_shot trickshots 2";
					end
				end
				if (v55.KillShot:IsReady() or ((4229 - (628 + 490)) == (383 + 1751))) then
					if (((5830 - 3475) == (10762 - 8407)) and v26(v55.KillShot, not v70)) then
						return "kill_shot trickshots 4";
					end
				end
				if ((v16:Exists() and v55.KillShot:IsCastable() and (v16:HealthPercentage() <= (794 - (431 + 343)))) or ((1187 - 599) <= (1249 - 817))) then
					if (((3790 + 1007) >= (499 + 3396)) and v26(v57.KillShotMouseover, not v16:IsSpellInRange(v55.KillShot))) then
						return "kill_shot_mouseover cleave 38";
					end
				end
				v110 = 1696 - (556 + 1139);
			end
			if (((3592 - (6 + 9)) == (655 + 2922)) and (v110 == (2 + 1))) then
				if (((3963 - (28 + 141)) > (1431 + 2262)) and v53 and v55.Volley:IsReady() and (v16:GUID() == v14:GUID())) then
					if (v26(v57.VolleyCursor) or ((1573 - 298) == (2904 + 1196))) then
						return "volley trickshots 20";
					end
				end
				if ((v55.Trueshot:IsReady() and v33 and not v13:IsCasting(v55.SteadyShot) and not v13:IsCasting(v55.RapidFire) and not v13:IsChanneling(v55.RapidFire)) or ((2908 - (486 + 831)) >= (9316 - 5736))) then
					if (((3460 - 2477) <= (342 + 1466)) and v26(v55.Trueshot, not v70)) then
						return "trueshot trickshots 22";
					end
				end
				if ((v55.RapidFire:IsCastable() and (v13:BuffRemains(v55.TrickShotsBuff) >= v55.RapidFire:ExecuteTime()) and v55.SurgingShots:IsAvailable()) or ((6798 - 4648) <= (2460 - (668 + 595)))) then
					if (((3392 + 377) >= (237 + 936)) and v26(v55.RapidFire, not v70)) then
						return "rapid_fire trickshots 24";
					end
				end
				v110 = 10 - 6;
			end
			if (((1775 - (23 + 267)) == (3429 - (1129 + 815))) and (v110 == (389 - (371 + 16)))) then
				if (v55.WailingArrow:IsReady() or ((5065 - (1326 + 424)) <= (5268 - 2486))) then
					if (v26(v55.WailingArrow, not v70, true) or ((3201 - 2325) >= (3082 - (88 + 30)))) then
						return "wailing_arrow trickshots 14";
					end
				end
				if (v55.SerpentSting:IsReady() or ((3003 - (720 + 51)) > (5554 - 3057))) then
					if (v71.CastTargetIf(v55.SerpentSting, v67, "min", v76, v80, not v70, nil, nil, v57.SerpentStingMouseover) or ((3886 - (421 + 1355)) <= (546 - 214))) then
						return "serpent_sting trickshots 16";
					end
				end
				if (((1811 + 1875) > (4255 - (286 + 797))) and v55.Barrage:IsReady() and (v69 > (25 - 18)) and v33) then
					if (v26(v55.Barrage, not v70) or ((7410 - 2936) < (1259 - (397 + 42)))) then
						return "barrage trickshots 18";
					end
				end
				v110 = 1 + 2;
			end
		end
	end
	local function v90()
		local v111 = 800 - (24 + 776);
		local v112;
		local v113;
		while true do
			if (((6591 - 2312) >= (3667 - (222 + 563))) and (v111 == (0 - 0))) then
				v112 = v13:GetUseableItems(v59, 10 + 3);
				if ((v112 and (v13:BuffUp(v55.TrueshotBuff) or (v66 < (203 - (23 + 167))))) or ((3827 - (690 + 1108)) >= (1271 + 2250))) then
					if (v26(v57.Trinket1, nil, nil, true) or ((1681 + 356) >= (5490 - (40 + 808)))) then
						return "trinket1 trinket 2";
					end
				end
				v111 = 1 + 0;
			end
			if (((6577 - 4857) < (4261 + 197)) and (v111 == (1 + 0))) then
				v113 = v13:GetUseableItems(v59, 8 + 6);
				if ((v113 and (v13:BuffUp(v55.TrueshotBuff) or (v66 < (584 - (47 + 524))))) or ((283 + 153) > (8257 - 5236))) then
					if (((1065 - 352) <= (1931 - 1084)) and v26(v57.Trinket2, nil, nil, true)) then
						return "trinket2 trinket 4";
					end
				end
				break;
			end
		end
	end
	local function v91()
		local v114 = 1726 - (1165 + 561);
		while true do
			if (((64 + 2090) <= (12484 - 8453)) and (v114 == (2 + 2))) then
				if (((5094 - (341 + 138)) == (1246 + 3369)) and (v71.TargetIsValid() or v13:AffectingCombat())) then
					local v132 = 0 - 0;
					while true do
						if ((v132 == (327 - (89 + 237))) or ((12192 - 8402) == (1052 - 552))) then
							if (((970 - (581 + 300)) < (1441 - (855 + 365))) and (v66 == (26390 - 15279))) then
								v66 = v10.FightRemains(v68, false);
							end
							break;
						end
						if (((671 + 1383) >= (2656 - (1030 + 205))) and (v132 == (0 + 0))) then
							v65 = v10.BossFightRemains(nil, true);
							v66 = v65;
							v132 = 1 + 0;
						end
					end
				end
				if (((978 - (156 + 130)) < (6948 - 3890)) and v71.TargetIsValid()) then
					local v133 = 0 - 0;
					while true do
						if ((v133 == (1 - 0)) or ((858 + 2396) == (966 + 689))) then
							if ((not v13:IsCasting() and not v13:IsChanneling()) or ((1365 - (10 + 59)) == (1389 + 3521))) then
								local v136 = 0 - 0;
								local v137;
								while true do
									if (((4531 - (671 + 492)) == (2682 + 686)) and (v136 == (1215 - (369 + 846)))) then
										v137 = v71.Interrupt(v55.CounterShot, 11 + 29, true);
										if (((2256 + 387) < (5760 - (1036 + 909))) and v137) then
											return v137;
										end
										v136 = 1 + 0;
									end
									if (((3211 - 1298) > (696 - (11 + 192))) and ((1 + 0) == v136)) then
										v137 = v71.InterruptWithStun(v55.Intimidation, 215 - (135 + 40));
										if (((11520 - 6765) > (2067 + 1361)) and v137) then
											return v137;
										end
										v136 = 4 - 2;
									end
									if (((2069 - 688) <= (2545 - (50 + 126))) and (v136 == (8 - 5))) then
										v137 = v71.InterruptWithStun(v55.Intimidation, 9 + 31, false, v16, v57.IntimidationMouseover);
										if (v137 or ((6256 - (1233 + 180)) == (5053 - (522 + 447)))) then
											return v137;
										end
										break;
									end
									if (((6090 - (107 + 1314)) > (169 + 194)) and ((5 - 3) == v136)) then
										v137 = v71.Interrupt(v55.CounterShot, 17 + 23, true, v16, v57.CounterShotMouseover);
										if (v137 or ((3726 - 1849) >= (12415 - 9277))) then
											return v137;
										end
										v136 = 1913 - (716 + 1194);
									end
								end
							end
							if (((81 + 4661) >= (389 + 3237)) and v52 and v55.TranquilizingShot:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and (v71.UnitHasEnrageBuff(v14) or v71.UnitHasMagicBuff(v14))) then
								if (v26(v55.TranquilizingShot, not v70) or ((5043 - (74 + 429)) == (1766 - 850))) then
									return "dispel";
								end
							end
							v64 = v55.Trueshot:CooldownUp();
							if ((v35 and v33) or ((573 + 583) > (9946 - 5601))) then
								local v138 = 0 + 0;
								local v139;
								while true do
									if (((6896 - 4659) < (10505 - 6256)) and ((433 - (279 + 154)) == v138)) then
										v139 = v90();
										if (v139 or ((3461 - (454 + 324)) < (19 + 4))) then
											return v139;
										end
										break;
									end
								end
							end
							v133 = 19 - (12 + 5);
						end
						if (((376 + 321) <= (2104 - 1278)) and (v133 == (1 + 1))) then
							if (((2198 - (277 + 816)) <= (5024 - 3848)) and v33) then
								local v140 = 1183 - (1058 + 125);
								local v141;
								while true do
									if (((634 + 2745) <= (4787 - (815 + 160))) and (v140 == (0 - 0))) then
										v141 = v87();
										if (v141 or ((1870 - 1082) >= (386 + 1230))) then
											return v141;
										end
										break;
									end
								end
							end
							if (((5419 - 3565) <= (5277 - (41 + 1857))) and ((v69 < (1896 - (1222 + 671))) or not v55.TrickShots:IsAvailable() or not v32)) then
								local v142 = 0 - 0;
								local v143;
								while true do
									if (((6538 - 1989) == (5731 - (229 + 953))) and (v142 == (1774 - (1111 + 663)))) then
										v143 = v88();
										if (v143 or ((4601 - (874 + 705)) >= (424 + 2600))) then
											return v143;
										end
										break;
									end
								end
							end
							if (((3289 + 1531) > (4568 - 2370)) and (v69 > (1 + 1))) then
								local v144 = 679 - (642 + 37);
								local v145;
								while true do
									if ((v144 == (0 + 0)) or ((170 + 891) >= (12280 - 7389))) then
										v145 = v89();
										if (((1818 - (233 + 221)) <= (10343 - 5870)) and v145) then
											return v145;
										end
										break;
									end
								end
							end
							if (v26(v55.PoolFocus) or ((3165 + 430) <= (1544 - (718 + 823)))) then
								return "Pooling Focus";
							end
							break;
						end
						if ((v133 == (0 + 0)) or ((5477 - (266 + 539)) == (10905 - 7053))) then
							v75();
							if (((2784 - (636 + 589)) == (3700 - 2141)) and not v13:AffectingCombat() and not v31) then
								local v146 = 0 - 0;
								local v147;
								while true do
									if ((v146 == (0 + 0)) or ((637 + 1115) <= (1803 - (657 + 358)))) then
										v147 = v86();
										if (v147 or ((10344 - 6437) == (402 - 225))) then
											return v147;
										end
										break;
									end
								end
							end
							if (((4657 - (1151 + 36)) > (536 + 19)) and v55.Exhilaration:IsReady() and (v13:HealthPercentage() <= v51)) then
								if (v26(v55.Exhilaration) or ((256 + 716) == (1926 - 1281))) then
									return "exhilaration";
								end
							end
							if (((5014 - (1552 + 280)) >= (2949 - (64 + 770))) and (v13:HealthPercentage() <= v40) and v56.Healthstone:IsReady()) then
								if (((2644 + 1249) < (10053 - 5624)) and v26(v57.Healthstone, nil, nil, true)) then
									return "healthstone";
								end
							end
							v133 = 1 + 0;
						end
					end
				end
				break;
			end
			if ((v114 == (1243 - (157 + 1086))) or ((5738 - 2871) < (8343 - 6438))) then
				v54();
				v31 = EpicSettings.Toggles['ooc'];
				v114 = 1 - 0;
			end
			if ((v114 == (2 - 0)) or ((2615 - (599 + 220)) >= (8066 - 4015))) then
				v70 = v14:IsSpellInRange(v55.AimedShot);
				v67 = v13:GetEnemiesInRange(v55.AimedShot.MaximumRange);
				v114 = 1934 - (1813 + 118);
			end
			if (((1184 + 435) <= (4973 - (841 + 376))) and (v114 == (1 - 0))) then
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v114 = 1 + 1;
			end
			if (((1648 - 1044) == (1463 - (464 + 395))) and (v114 == (7 - 4))) then
				v68 = v14:GetEnemiesInSplashRange(5 + 5);
				if (v23() or ((5321 - (467 + 370)) == (1859 - 959))) then
					v69 = v14:GetEnemiesInSplashRangeCount(8 + 2);
				else
					v69 = 3 - 2;
				end
				v114 = 1 + 3;
			end
		end
	end
	local function v92()
		v10.Print("Marksmanship by Epic. Supported by Gojira");
	end
	v10.SetAPL(590 - 336, v91, v92);
end;
return v0["Epix_Hunter_Marksmanship.lua"]();

