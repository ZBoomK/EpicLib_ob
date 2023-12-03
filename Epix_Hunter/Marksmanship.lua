local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((4154 - 2429) > (301 + 3191))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Hunter_Marksmanship.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Target;
	local v14 = v11.Focus;
	local v15 = v11.MouseOver;
	local v16 = v11.Pet;
	local v17 = v9.Spell;
	local v18 = v9.MultiSpell;
	local v19 = v9.Item;
	local v20 = v9.Bind;
	local v21 = v9.Macro;
	local v22 = v9.AoEON;
	local v23 = v9.CDsON;
	local v24 = v9.Cast;
	local v25 = v9.Press;
	local v26 = GetTime;
	local v27 = v9.Commons.Hunter;
	local v28 = v9.Commons.Everyone.num;
	local v29 = v9.Commons.Everyone.bool;
	local v30 = false;
	local v31 = false;
	local v32 = false;
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
	local function v53()
		v33 = EpicSettings.Settings['UseRacials'];
		v35 = EpicSettings.Settings['UseHealingPotion'];
		v36 = EpicSettings.Settings['HealingPotionName'] or (1690 - (1121 + 569));
		v37 = EpicSettings.Settings['HealingPotionHP'] or (214 - (22 + 192));
		v38 = EpicSettings.Settings['UseHealthstone'];
		v39 = EpicSettings.Settings['HealthstoneHP'] or (683 - (483 + 200));
		v40 = EpicSettings.Settings['InterruptWithStun'] or (1463 - (1404 + 59));
		v41 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
		v42 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v43 = EpicSettings.Settings['UsePet'];
		v44 = EpicSettings.Settings['SummonPetSlot'] or (765 - (468 + 297));
		v45 = EpicSettings.Settings['UseSteelTrap'];
		v46 = EpicSettings.Settings['UseRevive'];
		v47 = EpicSettings.Settings['UseMendPet'];
		v48 = EpicSettings.Settings['MendPetHP'] or (562 - (334 + 228));
		v49 = EpicSettings.Settings['UseExhilaration'];
		v50 = EpicSettings.Settings['ExhilarationHP'] or (0 - 0);
		v51 = EpicSettings.Settings['UseTranq'];
		v52 = EpicSettings.Settings['UseVolley'];
	end
	local v54 = v17.Hunter.Marksmanship;
	local v55 = v19.Hunter.Marksmanship;
	local v56 = v21.Hunter.Marksmanship;
	local v57 = {v54.SummonPet,v54.SummonPet2,v54.SummonPet3,v54.SummonPet4,v54.SummonPet5};
	local v58 = {};
	local v59 = v12:GetEquipment();
	local v60 = (v59[33 - 20] and v19(v59[30 - 17])) or v19(0 + 0);
	local v61 = (v59[38 - 24] and v19(v59[10 + 4])) or v19(0 + 0);
	local v62 = {LastCast=(0 - 0),Count=(0 + 0)};
	local v63;
	local v64 = 11274 - (92 + 71);
	local v65 = 5489 + 5622;
	local v66;
	local v67;
	local v68;
	local v69;
	local v70 = v9.Commons.Everyone;
	local v71 = (v13:HealthPercentage() > (117 - 47)) and v54.CarefulAim:IsAvailable();
	local v72 = {{v54.Intimidation,"Cast Intimidation (Interrupt)",function()
		return true;
	end}};
	v9:RegisterForEvent(function()
		local v102 = 849 - (254 + 595);
		while true do
			if (((1585 - (55 + 71)) <= (3269 - 787)) and (v102 == (1791 - (573 + 1217)))) then
				v61 = (v59[38 - 24] and v19(v59[2 + 12])) or v19(0 - 0);
				break;
			end
			if ((v102 == (939 - (714 + 225))) or ((7878 - 5182) >= (6317 - 1785))) then
				v59 = v12:GetEquipment();
				v60 = (v59[2 + 11] and v19(v59[18 - 5])) or v19(806 - (118 + 688));
				v102 = 49 - (25 + 23);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v62 = {LastCast=(0 + 0),Count=(1886 - (927 + 959))};
		v64 = 37453 - 26342;
		v65 = 11843 - (16 + 716);
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v54.SerpentSting:RegisterInFlight();
		v54.SteadyShot:RegisterInFlight();
		v54.AimedShot:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v54.SerpentSting:RegisterInFlight();
	v54.SteadyShot:RegisterInFlight();
	v54.AimedShot:RegisterInFlight();
	local function v73()
		return (v12:BuffUp(v54.TrickShotsBuff) and not v12:IsCasting(v54.AimedShot) and not v12:IsChanneling(v54.RapidFire)) or v12:BuffUp(v54.VolleyBuff);
	end
	local function v74()
		local v103 = 0 - 0;
		while true do
			if (((1145 - (11 + 86)) >= (126 - 74)) and (v103 == (286 - (175 + 110)))) then
				if (((7468 - 4510) < (22209 - 17706)) and (v54.SteadyFocusBuff.LastAppliedOnPlayerTime > v62.LastCast)) then
					v62.Count = 1796 - (503 + 1293);
				end
				break;
			end
			if ((v103 == (0 - 0)) or ((1978 + 757) == (2370 - (810 + 251)))) then
				if ((((v62.Count == (0 + 0)) or (v62.Count == (1 + 0))) and v12:IsCasting(v54.SteadyShot) and (v62.LastCast < (v26() - v54.SteadyShot:CastTime()))) or ((3724 + 406) <= (3488 - (43 + 490)))) then
					v62.LastCast = v26();
					v62.Count = v62.Count + (734 - (711 + 22));
				end
				if (not (v12:IsCasting(v54.SteadyShot) or v12:PrevGCDP(3 - 2, v54.SteadyShot)) or ((2823 - (240 + 619)) <= (324 + 1016))) then
					v62.Count = 0 - 0;
				end
				v103 = 1 + 0;
			end
		end
	end
	local function v75(v104)
		return (v104:DebuffRemains(v54.SerpentStingDebuff));
	end
	local function v76(v105)
		return v105:DebuffRemains(v54.SerpentStingDebuff) + (v28(v54.SerpentSting:InFlight()) * (1843 - (1344 + 400)));
	end
	local function v77(v106)
		return (v106:DebuffStack(v54.LatentPoisonDebuff));
	end
	local function v78(v107)
		return v107:DebuffRefreshable(v54.SerpentStingDebuff) and not v54.SerpentstalkersTrickery:IsAvailable();
	end
	local function v79(v108)
		return v108:DebuffRefreshable(v54.SerpentStingDebuff) and v54.HydrasBite:IsAvailable() and not v54.SerpentstalkersTrickery:IsAvailable();
	end
	local function v80(v109)
		return v109:DebuffRefreshable(v54.SerpentStingDebuff) and v54.PoisonInjection:IsAvailable() and not v54.SerpentstalkersTrickery:IsAvailable();
	end
	local function v81(v110)
		return v54.SerpentstalkersTrickery:IsAvailable() and (v12:BuffDown(v54.PreciseShotsBuff) or ((v12:BuffUp(v54.TrueshotBuff) or (v54.AimedShot:FullRechargeTime() < (v12:GCD() + v54.AimedShot:CastTime()))) and (not v54.ChimaeraShot:IsAvailable() or (v68 < (407 - (255 + 150))))) or ((v12:BuffRemains(v54.TrickShotsBuff) > v54.AimedShot:ExecuteTime()) and (v68 > (1 + 0))));
	end
	local function v82(v111)
		return v12:BuffDown(v54.PreciseShotsBuff) or ((v12:BuffUp(v54.TrueshotBuff) or (v54.AimedShot:FullRechargeTime() < (v12:GCD() + v54.AimedShot:CastTime()))) and (not v54.ChimaeraShot:IsAvailable() or (v68 < (2 + 0)))) or ((v12:BuffRemains(v54.TrickShotsBuff) > v54.AimedShot:ExecuteTime()) and (v68 > (4 - 3)));
	end
	local function v83(v112)
		return v54.SerpentstalkersTrickery:IsAvailable() and (v12:BuffRemains(v54.TrickShotsBuff) >= v54.AimedShot:ExecuteTime()) and (v12:BuffDown(v54.PreciseShotsBuff) or v12:BuffUp(v54.TrueshotBuff) or (v54.AimedShot:FullRechargeTime() < (v54.AimedShot:CastTime() + v12:GCD())));
	end
	local function v84(v113)
		return (v12:BuffRemains(v54.TrickShotsBuff) >= v54.AimedShot:ExecuteTime()) and (v12:BuffDown(v54.PreciseShotsBuff) or v12:BuffUp(v54.TrueshotBuff) or (v54.AimedShot:FullRechargeTime() < (v54.AimedShot:CastTime() + v12:GCD())));
	end
	local function v85()
		local v114 = 0 - 0;
		while true do
			if (((4238 - (404 + 1335)) == (2905 - (183 + 223))) and (v114 == (1 - 0))) then
				if ((v54.Salvo:IsCastable() and v32) or ((1495 + 760) < (8 + 14))) then
					if (v25(v54.Salvo) or ((1423 - (10 + 327)) >= (979 + 426))) then
						return "salvo opener";
					end
				end
				if ((v54.AimedShot:IsReady() and not v12:IsCasting(v54.AimedShot) and (v68 < (341 - (118 + 220))) and (not v54.Volley:IsAvailable() or (v68 < (1 + 1)))) or ((2818 - (108 + 341)) == (192 + 234))) then
					if (v25(v54.AimedShot, not v69, true) or ((13004 - 9928) > (4676 - (711 + 782)))) then
						return "aimed_shot opener";
					end
				end
				v114 = 3 - 1;
			end
			if (((1671 - (270 + 199)) > (343 + 715)) and (v114 == (1821 - (580 + 1239)))) then
				if (((11031 - 7320) > (3208 + 147)) and v54.WailingArrow:IsReady() and not v12:IsCasting(v54.WailingArrow) and ((v68 > (1 + 1)) or not v54.SteadyFocus:IsAvailable())) then
					if (v25(v54.WailingArrow, not v69, true) or ((395 + 511) >= (5819 - 3590))) then
						return "wailing_arrow opener";
					end
				end
				if (((801 + 487) > (2418 - (645 + 522))) and v54.SteadyShot:IsCastable() and ((v68 > (1792 - (1010 + 780))) or (v54.Volley:IsAvailable() and (v68 == (2 + 0))))) then
					if (v25(v54.SteadyShot, not v69) or ((21499 - 16986) < (9822 - 6470))) then
						return "steady_shot opener";
					end
				end
				break;
			end
			if ((v114 == (1836 - (1045 + 791))) or ((5227 - 3162) >= (4879 - 1683))) then
				if ((v14 and v14:Exists() and v54.Misdirection:IsReady()) or ((4881 - (351 + 154)) <= (3055 - (1281 + 293)))) then
					if (v25(v56.MisdirectionFocus) or ((3658 - (28 + 238)) >= (10593 - 5852))) then
						return "misdirection opener";
					end
				end
				if (((4884 - (1381 + 178)) >= (2021 + 133)) and v54.SummonPet:IsCastable() and not v54.LoneWolf:IsAvailable() and v43) then
					if (v25(v57[v44]) or ((1045 + 250) >= (1380 + 1853))) then
						return "Summon Pet opener";
					end
				end
				v114 = 3 - 2;
			end
		end
	end
	local function v86()
		local v115 = 0 + 0;
		while true do
			if (((4847 - (381 + 89)) > (1457 + 185)) and (v115 == (2 + 0))) then
				if (((8090 - 3367) > (2512 - (1074 + 82))) and v54.LightsJudgment:IsReady() and (v12:BuffDown(v54.TrueshotBuff))) then
					if (v25(v54.LightsJudgment, not v13:IsSpellInRange(v54.LightsJudgment)) or ((9063 - 4927) <= (5217 - (214 + 1570)))) then
						return "lights_judgment cds 10";
					end
				end
				if (((5700 - (990 + 465)) <= (1910 + 2721)) and v54.Salvo:IsCastable() and ((v68 > (1 + 1)) or (v54.Volley:CooldownRemains() < (10 + 0)))) then
					if (((16828 - 12552) >= (5640 - (1668 + 58))) and v25(v54.Salvo)) then
						return "salvo cds 14";
					end
				end
				break;
			end
			if (((824 - (512 + 114)) <= (11380 - 7015)) and (v115 == (1 - 0))) then
				if (((16639 - 11857) > (2176 + 2500)) and v54.AncestralCall:IsReady() and (v12:BuffUp(v54.TrueshotBuff) or (v54.Trueshot:CooldownRemains() > (6 + 24)) or (v65 < (14 + 2)))) then
					if (((16405 - 11541) > (4191 - (109 + 1885))) and v25(v54.AncestralCall)) then
						return "ancestral_call cds 6";
					end
				end
				if ((v54.Fireblood:IsReady() and (v12:BuffUp(v54.TrueshotBuff) or (v54.Trueshot:CooldownRemains() > (1499 - (1269 + 200))) or (v65 < (16 - 7)))) or ((4515 - (98 + 717)) == (3333 - (802 + 24)))) then
					if (((7715 - 3241) >= (345 - 71)) and v25(v54.Fireblood)) then
						return "fireblood cds 8";
					end
				end
				v115 = 1 + 1;
			end
			if ((v115 == (0 + 0)) or ((312 + 1582) <= (304 + 1102))) then
				if (((4373 - 2801) >= (5105 - 3574)) and v54.Berserking:IsReady() and (v12:BuffUp(v54.TrueshotBuff) or (v65 < (5 + 8)))) then
					if (v25(v54.Berserking) or ((1908 + 2779) < (3747 + 795))) then
						return "berserking cds 2";
					end
				end
				if (((2393 + 898) > (779 + 888)) and v54.BloodFury:IsReady() and (v12:BuffUp(v54.TrueshotBuff) or (v54.Trueshot:CooldownRemains() > (1463 - (797 + 636))) or (v65 < (77 - 61)))) then
					if (v25(v54.BloodFury) or ((2492 - (1427 + 192)) == (705 + 1329))) then
						return "blood_fury cds 4";
					end
				end
				v115 = 2 - 1;
			end
		end
	end
	local function v87()
		if ((v54.SteadyShot:IsCastable() and v54.SteadyFocus:IsAvailable() and (((v62.Count == (1 + 0)) and (v12:BuffRemains(v54.SteadyFocusBuff) < (3 + 2))) or (v12:BuffDown(v54.SteadyFocusBuff) and v12:BuffDown(v54.TrueshotBuff) and (v62.Count ~= (328 - (192 + 134)))))) or ((4092 - (316 + 960)) < (7 + 4))) then
			if (((2855 + 844) < (4350 + 356)) and v25(v54.SteadyShot, not v69)) then
				return "steady_shot st 2";
			end
		end
		if (((10115 - 7469) >= (1427 - (83 + 468))) and v54.AimedShot:IsReady() and v12:BuffUp(v54.TrueshotBuff) and (v54.AimedShot:FullRechargeTime() < (v12:GCD() + v54.AimedShot:CastTime())) and v54.LegacyoftheWindrunners:IsAvailable() and v54.WindrunnersGuidance:IsAvailable()) then
			if (((2420 - (1202 + 604)) <= (14863 - 11679)) and v25(v54.AimedShot, not v69, true)) then
				return "aimed_shot st 4";
			end
		end
		if (((5202 - 2076) == (8655 - 5529)) and v54.KillShot:IsReady() and (v12:BuffDown(v54.TrueshotBuff))) then
			if (v25(v54.KillShot, not v69) or ((2512 - (45 + 280)) >= (4782 + 172))) then
				return "kill_shot st 6";
			end
		end
		if ((v52 and v54.Volley:IsReady() and (v15:GUID() == v13:GUID()) and (v12:BuffUp(v54.SalvoBuff))) or ((3388 + 489) == (1306 + 2269))) then
			if (((392 + 315) > (112 + 520)) and v25(v56.VolleyCursor, not v69)) then
				return "volley st 5";
			end
		end
		if ((v15:Exists() and v54.KillShot:IsCastable() and (v15:HealthPercentage() <= (37 - 17))) or ((2457 - (340 + 1571)) >= (1059 + 1625))) then
			if (((3237 - (1733 + 39)) <= (11818 - 7517)) and v25(v56.KillShotMouseover, not v15:IsSpellInRange(v54.KillShot))) then
				return "kill_shot_mouseover cleave 38";
			end
		end
		if (((2738 - (125 + 909)) > (3373 - (1096 + 852))) and v45 and v54.SteelTrap:IsCastable() and (v13:GUID() == v15:GUID()) and (v12:BuffDown(v54.TrueshotBuff))) then
			if (v25(v56.SteelTrapCursor, not v13:IsInRange(18 + 22)) or ((981 - 294) == (4107 + 127))) then
				return "steel_trap st 6";
			end
		end
		if ((v54.SerpentSting:IsReady() and (v12:BuffDown(v54.TrueshotBuff))) or ((3842 - (409 + 103)) < (1665 - (46 + 190)))) then
			if (((1242 - (51 + 44)) >= (95 + 240)) and v70.CastTargetIf(v54.SerpentSting, v66, "min", v75, v78, not v69, nil, nil, v56.SerpentStingMouseover)) then
				return "serpent_sting st 8";
			end
		end
		if (((4752 - (1114 + 203)) > (2823 - (228 + 498))) and v54.ExplosiveShot:IsReady()) then
			if (v25(v54.ExplosiveShot, not v69) or ((817 + 2953) >= (2233 + 1808))) then
				return "explosive_shot st 10";
			end
		end
		if ((v54.Stampede:IsCastable() and v32) or ((4454 - (174 + 489)) <= (4197 - 2586))) then
			if (v25(v54.Stampede, not v13:IsInRange(1935 - (830 + 1075))) or ((5102 - (303 + 221)) <= (3277 - (231 + 1038)))) then
				return "stampede st 14";
			end
		end
		if (((938 + 187) <= (3238 - (171 + 991))) and v54.DeathChakram:IsReady() and v32) then
			if (v25(v54.DeathChakram, not v69) or ((3061 - 2318) >= (11811 - 7412))) then
				return "dark_chakram st 16";
			end
		end
		if (((2882 - 1727) < (1339 + 334)) and v54.WailingArrow:IsReady() and (v68 > (3 - 2))) then
			if (v25(v54.WailingArrow, not v69, true) or ((6704 - 4380) <= (931 - 353))) then
				return "wailing_arrow st 18";
			end
		end
		if (((11644 - 7877) == (5015 - (111 + 1137))) and v54.RapidFire:IsCastable() and (v54.SurgingShots:IsAvailable() or (v54.AimedShot:FullRechargeTime() > (v54.AimedShot:CastTime() + v54.RapidFire:CastTime())))) then
			if (((4247 - (91 + 67)) == (12169 - 8080)) and v25(v54.RapidFire, not v69)) then
				return "rapid_fire st 22";
			end
		end
		if (((1113 + 3345) >= (2197 - (423 + 100))) and v54.KillShot:IsReady()) then
			if (((7 + 965) <= (3925 - 2507)) and v25(v54.KillShot, not v69)) then
				return "kill_shot st 24";
			end
		end
		if ((v54.Trueshot:IsReady() and v32 and v63 and (v12:BuffDown(v54.TrueshotBuff) or (v12:BuffRemains(v54.TrueshotBuff) < (3 + 2)))) or ((5709 - (326 + 445)) < (20781 - 16019))) then
			if (v25(v54.Trueshot, not v69) or ((5578 - 3074) > (9953 - 5689))) then
				return "trueshot st 26";
			end
		end
		if (((2864 - (530 + 181)) == (3034 - (614 + 267))) and v54.MultiShot:IsReady() and ((v12:BuffUp(v54.BombardmentBuff) and not v73() and (v68 > (33 - (19 + 13)))) or (v12:BuffUp(v54.SalvoBuff) and not v54.Volley:IsAvailable()))) then
			if (v25(v54.MultiShot, not v69) or ((825 - 318) >= (6037 - 3446))) then
				return "multishot st 26";
			end
		end
		if (((12800 - 8319) == (1164 + 3317)) and v54.AimedShot:IsReady()) then
			if (v70.CastTargetIf(v54.AimedShot, v66, "min", v76, v81, not v69, nil, nil, v56.AimedShotMouseover, true) or ((4093 - 1765) < (1437 - 744))) then
				return "aimed_shot st 28";
			end
		end
		if (((6140 - (1293 + 519)) == (8830 - 4502)) and v54.AimedShot:IsReady()) then
			if (((4145 - 2557) >= (2546 - 1214)) and v70.CastTargetIf(v54.AimedShot, v66, "max", v77, v82, not v69, nil, nil, v56.AimedShotMouseover, true)) then
				return "aimed_shot st 30";
			end
		end
		if ((v52 and v54.Volley:IsReady() and (v15:GUID() == v13:GUID())) or ((17998 - 13824) > (10007 - 5759))) then
			if (v25(v56.VolleyCursor, not v69) or ((2429 + 2157) <= (17 + 65))) then
				return "volley st 20";
			end
		end
		if (((8975 - 5112) == (893 + 2970)) and v54.RapidFire:IsCastable()) then
			if (v25(v54.RapidFire, not v69) or ((94 + 188) <= (27 + 15))) then
				return "rapid_fire st 34";
			end
		end
		if (((5705 - (709 + 387)) >= (2624 - (673 + 1185))) and v54.WailingArrow:IsReady() and (v12:BuffDown(v54.TrueshotBuff))) then
			if (v25(v54.WailingArrow, not v69, true) or ((3340 - 2188) == (7989 - 5501))) then
				return "wailing_arrow st 36";
			end
		end
		if (((5629 - 2207) > (2397 + 953)) and v54.KillCommand:IsCastable() and (v12:BuffDown(v54.TrueshotBuff))) then
			if (((656 + 221) > (506 - 130)) and v25(v54.KillCommand, not v13:IsInRange(13 + 37))) then
				return "kill_command st 37";
			end
		end
		if ((v54.ChimaeraShot:IsReady() and (v12:BuffUp(v54.PreciseShotsBuff) or (v12:FocusP() > (v54.ChimaeraShot:Cost() + v54.AimedShot:Cost())))) or ((6216 - 3098) <= (3633 - 1782))) then
			if (v25(v54.ChimaeraShot, not v69) or ((2045 - (446 + 1434)) >= (4775 - (1040 + 243)))) then
				return "chimaera_shot st 38";
			end
		end
		if (((11786 - 7837) < (6703 - (559 + 1288))) and v54.ArcaneShot:IsReady() and (v12:BuffUp(v54.PreciseShotsBuff) or (v12:FocusP() > (v54.ArcaneShot:Cost() + v54.AimedShot:Cost())))) then
			if (v25(v54.ArcaneShot, not v69) or ((6207 - (609 + 1322)) < (3470 - (13 + 441)))) then
				return "arcane_shot st 40";
			end
		end
		if (((17525 - 12835) > (10804 - 6679)) and v54.BagofTricks:IsReady()) then
			if (v25(v54.BagofTricks, not v13:IsSpellInRange(v54.BagofTricks)) or ((249 - 199) >= (34 + 862))) then
				return "bag_of_tricks st 42";
			end
		end
		if (v54.SteadyShot:IsCastable() or ((6224 - 4510) >= (1051 + 1907))) then
			if (v25(v54.SteadyShot, not v69) or ((654 + 837) < (1911 - 1267))) then
				return "steady_shot st 44";
			end
		end
	end
	local function v88()
		if (((386 + 318) < (1815 - 828)) and v54.SteadyShot:IsCastable() and v54.SteadyFocus:IsAvailable() and (v62.Count == (1 + 0)) and (v12:BuffRemains(v54.SteadyFocusBuff) < (5 + 3))) then
			if (((2672 + 1046) > (1601 + 305)) and v25(v54.SteadyShot, not v69)) then
				return "steady_shot trickshots 2";
			end
		end
		if (v54.KillShot:IsReady() or ((938 + 20) > (4068 - (153 + 280)))) then
			if (((10109 - 6608) <= (4033 + 459)) and v25(v54.KillShot, not v69)) then
				return "kill_shot trickshots 4";
			end
		end
		if ((v15:Exists() and v54.KillShot:IsCastable() and (v15:HealthPercentage() <= (8 + 12))) or ((1802 + 1640) < (2313 + 235))) then
			if (((2084 + 791) >= (2228 - 764)) and v25(v56.KillShotMouseover, not v15:IsSpellInRange(v54.KillShot))) then
				return "kill_shot_mouseover cleave 38";
			end
		end
		if (v54.ExplosiveShot:IsReady() or ((2965 + 1832) >= (5560 - (89 + 578)))) then
			if (v25(v54.ExplosiveShot, not v69) or ((394 + 157) > (4299 - 2231))) then
				return "explosive_shot trickshots 8";
			end
		end
		if (((3163 - (572 + 477)) > (128 + 816)) and v54.DeathChakram:IsReady() and v32) then
			if (v25(v54.DeathChakram, not v69) or ((1358 + 904) >= (370 + 2726))) then
				return "death_chakram trickshots 10";
			end
		end
		if ((v54.Stampede:IsReady() and v32) or ((2341 - (84 + 2)) >= (5828 - 2291))) then
			if (v25(v54.Stampede, not v13:IsInRange(22 + 8)) or ((4679 - (497 + 345)) < (34 + 1272))) then
				return "stampede trickshots 12";
			end
		end
		if (((499 + 2451) == (4283 - (605 + 728))) and v54.WailingArrow:IsReady()) then
			if (v25(v54.WailingArrow, not v69, true) or ((3370 + 1353) < (7332 - 4034))) then
				return "wailing_arrow trickshots 14";
			end
		end
		if (((53 + 1083) >= (569 - 415)) and v54.SerpentSting:IsReady()) then
			if (v70.CastTargetIf(v54.SerpentSting, v66, "min", v75, v79, not v69, nil, nil, v56.SerpentStingMouseover) or ((245 + 26) > (13154 - 8406))) then
				return "serpent_sting trickshots 16";
			end
		end
		if (((3579 + 1161) >= (3641 - (457 + 32))) and v54.Barrage:IsReady() and (v68 > (3 + 4)) and v32) then
			if (v25(v54.Barrage, not v69) or ((3980 - (832 + 570)) >= (3194 + 196))) then
				return "barrage trickshots 18";
			end
		end
		if (((11 + 30) <= (5877 - 4216)) and v52 and v54.Volley:IsReady() and (v15:GUID() == v13:GUID())) then
			if (((290 + 311) < (4356 - (588 + 208))) and v25(v56.VolleyCursor)) then
				return "volley trickshots 20";
			end
		end
		if (((633 - 398) < (2487 - (884 + 916))) and v54.Trueshot:IsReady() and v32 and not v12:IsCasting(v54.SteadyShot) and not v12:IsCasting(v54.RapidFire) and not v12:IsChanneling(v54.RapidFire)) then
			if (((9523 - 4974) > (669 + 484)) and v25(v54.Trueshot, not v69)) then
				return "trueshot trickshots 22";
			end
		end
		if ((v54.RapidFire:IsCastable() and (v12:BuffRemains(v54.TrickShotsBuff) >= v54.RapidFire:ExecuteTime()) and v54.SurgingShots:IsAvailable()) or ((5327 - (232 + 421)) < (6561 - (1569 + 320)))) then
			if (((900 + 2768) < (867 + 3694)) and v25(v54.RapidFire, not v69)) then
				return "rapid_fire trickshots 24";
			end
		end
		if (v54.AimedShot:IsReady() or ((1533 - 1078) == (4210 - (316 + 289)))) then
			if (v70.CastTargetIf(v54.AimedShot, v66, "min", v76, v83, not v69, nil, nil, v56.AimedShotMouseover, true) or ((6970 - 4307) == (153 + 3159))) then
				return "aimed_shot trickshots 26";
			end
		end
		if (((5730 - (666 + 787)) <= (4900 - (360 + 65))) and v54.AimedShot:IsReady()) then
			if (v70.CastTargetIf(v54.AimedShot, v66, "max", v77, v84, not v69, nil, nil, v56.AimedShotMouseover, true) or ((814 + 56) == (1443 - (79 + 175)))) then
				return "aimed_shot trickshots 28";
			end
		end
		if (((2448 - 895) <= (2445 + 688)) and v54.RapidFire:IsCastable() and (v12:BuffRemains(v54.TrickShotsBuff) >= v54.RapidFire:ExecuteTime())) then
			if (v25(v54.RapidFire, not v69) or ((6856 - 4619) >= (6761 - 3250))) then
				return "rapid_fire trickshots 30";
			end
		end
		if ((v54.ChimaeraShot:IsReady() and v12:BuffUp(v54.TrickShotsBuff) and v12:BuffUp(v54.PreciseShotsBuff) and (v12:FocusP() > (v54.ChimaeraShot:Cost() + v54.AimedShot:Cost())) and (v68 < (903 - (503 + 396)))) or ((1505 - (92 + 89)) > (5858 - 2838))) then
			if (v25(v54.ChimaeraShot, not v69) or ((1535 + 1457) == (1114 + 767))) then
				return "chimaera_shot trickshots 32";
			end
		end
		if (((12163 - 9057) > (209 + 1317)) and v54.MultiShot:IsReady() and (not v73() or ((v12:BuffUp(v54.PreciseShotsBuff) or (v12:BuffStack(v54.BulletstormBuff) == (22 - 12))) and (v12:FocusP() > (v54.MultiShot:Cost() + v54.AimedShot:Cost()))))) then
			if (((2638 + 385) < (1849 + 2021)) and v25(v54.MultiShot, not v69)) then
				return "multishot trickshots 34";
			end
		end
		if (((435 - 292) > (10 + 64)) and v54.SerpentSting:IsReady()) then
			if (((27 - 9) < (3356 - (485 + 759))) and v70.CastTargetIf(v54.SerpentSting, v66, "min", v75, v80, not v69, nil, nil, v56.SerpentStingMouseover)) then
				return "serpent_sting trickshots 36";
			end
		end
		if (((2538 - 1441) <= (2817 - (442 + 747))) and v45 and v54.SteelTrap:IsCastable() and (v13:GUID() == v15:GUID())) then
			if (((5765 - (832 + 303)) == (5576 - (88 + 858))) and v25(v56.SteelTrapCursor, not v13:IsInRange(13 + 27))) then
				return "steel_trap trickshots 38";
			end
		end
		if (((2930 + 610) > (111 + 2572)) and v54.KillShot:IsReady() and (v12:FocusP() > (v54.KillShot:Cost() + v54.AimedShot:Cost()))) then
			if (((5583 - (766 + 23)) >= (16167 - 12892)) and v25(v54.KillShot, not v69)) then
				return "kill_shot trickshots 40";
			end
		end
		if (((2029 - 545) == (3909 - 2425)) and v54.MultiShot:IsReady() and (v12:FocusP() > (v54.MultiShot:Cost() + v54.AimedShot:Cost()))) then
			if (((4860 - 3428) < (4628 - (1036 + 37))) and v25(v54.MultiShot, not v69)) then
				return "multishot trickshots 42";
			end
		end
		if ((v54.BagofTricks:IsReady() and (v12:BuffDown(v54.Trueshot))) or ((756 + 309) > (6967 - 3389))) then
			if (v25(v54.BagofTricks, not v13:IsSpellInRange(v54.BagofTricks)) or ((3772 + 1023) < (2887 - (641 + 839)))) then
				return "bag_of_tricks trickshots 44";
			end
		end
		if (((2766 - (910 + 3)) < (12269 - 7456)) and v54.SteadyShot:IsCastable()) then
			if (v25(v54.SteadyShot, not v69) or ((4505 - (1466 + 218)) < (1118 + 1313))) then
				return "steady_shot trickshots 46";
			end
		end
	end
	local function v89()
		local v116 = 1148 - (556 + 592);
		local v117;
		local v118;
		while true do
			if ((v116 == (1 + 0)) or ((3682 - (329 + 479)) < (3035 - (174 + 680)))) then
				v118 = v12:GetUseableItems(v58, 47 - 33);
				if ((v118 and (v12:BuffUp(v54.TrueshotBuff) or (v65 < (26 - 13)))) or ((1920 + 769) <= (1082 - (396 + 343)))) then
					if (v25(v56.Trinket2, nil, nil, true) or ((166 + 1703) == (3486 - (29 + 1448)))) then
						return "trinket2 trinket 4";
					end
				end
				break;
			end
			if ((v116 == (1389 - (135 + 1254))) or ((13358 - 9812) < (10841 - 8519))) then
				v117 = v12:GetUseableItems(v58, 9 + 4);
				if ((v117 and (v12:BuffUp(v54.TrueshotBuff) or (v65 < (1540 - (389 + 1138))))) or ((2656 - (102 + 472)) == (4505 + 268))) then
					if (((1799 + 1445) > (984 + 71)) and v25(v56.Trinket1, nil, nil, true)) then
						return "trinket1 trinket 2";
					end
				end
				v116 = 1546 - (320 + 1225);
			end
		end
	end
	local function v90()
		local v119 = 0 - 0;
		while true do
			if ((v119 == (2 + 0)) or ((4777 - (157 + 1307)) <= (3637 - (821 + 1038)))) then
				v69 = v13:IsSpellInRange(v54.AimedShot);
				v66 = v12:GetEnemiesInRange(v54.AimedShot.MaximumRange);
				v119 = 7 - 4;
			end
			if ((v119 == (1 + 2)) or ((2523 - 1102) >= (783 + 1321))) then
				v67 = v13:GetEnemiesInSplashRange(24 - 14);
				if (((2838 - (834 + 192)) <= (207 + 3042)) and v22()) then
					v68 = v13:GetEnemiesInSplashRangeCount(3 + 7);
				else
					v68 = 1 + 0;
				end
				v119 = 5 - 1;
			end
			if (((1927 - (300 + 4)) <= (523 + 1434)) and (v119 == (0 - 0))) then
				v53();
				v30 = EpicSettings.Toggles['ooc'];
				v119 = 363 - (112 + 250);
			end
			if (((1759 + 2653) == (11052 - 6640)) and ((3 + 1) == v119)) then
				if (((906 + 844) >= (630 + 212)) and (v70.TargetIsValid() or v12:AffectingCombat())) then
					local v127 = 0 + 0;
					while true do
						if (((3248 + 1124) > (3264 - (1001 + 413))) and (v127 == (0 - 0))) then
							v64 = v9.BossFightRemains(nil, true);
							v65 = v64;
							v127 = 883 - (244 + 638);
						end
						if (((925 - (627 + 66)) < (2446 - 1625)) and (v127 == (603 - (512 + 90)))) then
							if (((2424 - (1665 + 241)) < (1619 - (373 + 344))) and (v65 == (5012 + 6099))) then
								v65 = v9.FightRemains(v67, false);
							end
							break;
						end
					end
				end
				if (((793 + 2201) > (2263 - 1405)) and v70.TargetIsValid()) then
					v74();
					if ((not v12:AffectingCombat() and not v30) or ((6354 - 2599) <= (2014 - (35 + 1064)))) then
						local v128 = v85();
						if (((2872 + 1074) > (8007 - 4264)) and v128) then
							return v128;
						end
					end
					if ((v54.Exhilaration:IsReady() and (v12:HealthPercentage() <= v50)) or ((6 + 1329) >= (4542 - (298 + 938)))) then
						if (((6103 - (233 + 1026)) > (3919 - (636 + 1030))) and v25(v54.Exhilaration)) then
							return "exhilaration";
						end
					end
					if (((232 + 220) == (442 + 10)) and (v12:HealthPercentage() <= v39) and v55.Healthstone:IsReady()) then
						if (v25(v56.Healthstone, nil, nil, true) or ((1354 + 3203) < (142 + 1945))) then
							return "healthstone";
						end
					end
					if (((4095 - (55 + 166)) == (751 + 3123)) and not v12:IsCasting() and not v12:IsChanneling()) then
						local v129 = 0 + 0;
						local v130;
						while true do
							if ((v129 == (3 - 2)) or ((2235 - (36 + 261)) > (8630 - 3695))) then
								v130 = v70.InterruptWithStun(v54.Intimidation, 1408 - (34 + 1334));
								if (v130 or ((1636 + 2619) < (2660 + 763))) then
									return v130;
								end
								v129 = 1285 - (1035 + 248);
							end
							if (((1475 - (20 + 1)) <= (1298 + 1193)) and (v129 == (321 - (134 + 185)))) then
								v130 = v70.Interrupt(v54.CounterShot, 1173 - (549 + 584), true, v15, v56.CounterShotMouseover);
								if (v130 or ((4842 - (314 + 371)) <= (9622 - 6819))) then
									return v130;
								end
								v129 = 971 - (478 + 490);
							end
							if (((2571 + 2282) >= (4154 - (786 + 386))) and (v129 == (9 - 6))) then
								v130 = v70.InterruptWithStun(v54.Intimidation, 1419 - (1055 + 324), false, v15, v56.IntimidationMouseover);
								if (((5474 - (1093 + 247)) > (2984 + 373)) and v130) then
									return v130;
								end
								break;
							end
							if ((v129 == (0 + 0)) or ((13566 - 10149) < (8599 - 6065))) then
								v130 = v70.Interrupt(v54.CounterShot, 113 - 73, true);
								if (v130 or ((6840 - 4118) <= (59 + 105))) then
									return v130;
								end
								v129 = 3 - 2;
							end
						end
					end
					if ((v51 and v54.TranquilizingShot:IsReady() and not v12:IsCasting() and not v12:IsChanneling() and (v70.UnitHasEnrageBuff(v13) or v70.UnitHasMagicBuff(v13))) or ((8299 - 5891) < (1591 + 518))) then
						if (v25(v54.TranquilizingShot, not v69) or ((84 - 51) == (2143 - (364 + 324)))) then
							return "dispel";
						end
					end
					v63 = v54.Trueshot:CooldownUp();
					if ((v34 and v32) or ((1214 - 771) >= (9634 - 5619))) then
						local v131 = v89();
						if (((1121 + 2261) > (694 - 528)) and v131) then
							return v131;
						end
					end
					if (v32 or ((448 - 168) == (9290 - 6231))) then
						local v132 = 1268 - (1249 + 19);
						local v133;
						while true do
							if (((1698 + 183) > (5032 - 3739)) and (v132 == (1086 - (686 + 400)))) then
								v133 = v86();
								if (((1850 + 507) == (2586 - (73 + 156))) and v133) then
									return v133;
								end
								break;
							end
						end
					end
					if (((1 + 122) == (934 - (721 + 90))) and ((v68 < (1 + 2)) or not v54.TrickShots:IsAvailable() or not v31)) then
						local v134 = 0 - 0;
						local v135;
						while true do
							if ((v134 == (470 - (224 + 246))) or ((1710 - 654) >= (6245 - 2853))) then
								v135 = v87();
								if (v135 or ((197 + 884) < (26 + 1049))) then
									return v135;
								end
								break;
							end
						end
					end
					if ((v68 > (2 + 0)) or ((2085 - 1036) >= (14748 - 10316))) then
						local v136 = 513 - (203 + 310);
						local v137;
						while true do
							if ((v136 == (1993 - (1238 + 755))) or ((334 + 4434) <= (2380 - (709 + 825)))) then
								v137 = v88();
								if (v137 or ((6187 - 2829) <= (2068 - 648))) then
									return v137;
								end
								break;
							end
						end
					end
					if (v25(v54.PoolFocus) or ((4603 - (196 + 668)) <= (11864 - 8859))) then
						return "Pooling Focus";
					end
				end
				break;
			end
			if ((v119 == (1 - 0)) or ((2492 - (171 + 662)) >= (2227 - (4 + 89)))) then
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v119 = 6 - 4;
			end
		end
	end
	local function v91()
		v9.Print("Marksmanship by Epic. Supported by Gojira");
	end
	v9.SetAPL(93 + 161, v90, v91);
end;
return v0["Epix_Hunter_Marksmanship.lua"]();

