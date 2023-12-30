local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((2344 + 2033) > (7015 - 5373)) and (v5 == (3 - 2))) then
			return v6(...);
		end
		if (((6462 - (404 + 1335)) > (1762 - (183 + 223))) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((2741 + 1395) <= (1236 + 2197))) then
				return v1(v4, ...);
			end
			v5 = 338 - (10 + 327);
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
			if (((4583 - (118 + 220)) <= (1544 + 3087)) and (v93 == (454 - (108 + 341)))) then
				v50 = EpicSettings.Settings['UseExhilaration'];
				v51 = EpicSettings.Settings['ExhilarationHP'] or (0 + 0);
				v52 = EpicSettings.Settings['UseTranq'];
				v93 = 25 - 19;
			end
			if (((5769 - (711 + 782)) >= (7502 - 3588)) and (v93 == (475 - (270 + 199)))) then
				v53 = EpicSettings.Settings['UseVolley'];
				break;
			end
			if (((65 + 133) <= (6184 - (580 + 1239))) and ((0 - 0) == v93)) then
				v34 = EpicSettings.Settings['UseRacials'];
				v36 = EpicSettings.Settings['UseHealingPotion'];
				v37 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v93 = 1 + 0;
			end
			if (((2084 + 2698) > (12208 - 7532)) and ((2 + 1) == v93)) then
				v44 = EpicSettings.Settings['UsePet'];
				v45 = EpicSettings.Settings['SummonPetSlot'] or (1167 - (645 + 522));
				v46 = EpicSettings.Settings['UseSteelTrap'];
				v93 = 1794 - (1010 + 780);
			end
			if (((4862 + 2) > (10466 - 8269)) and (v93 == (5 - 3))) then
				v41 = EpicSettings.Settings['InterruptWithStun'] or (1836 - (1045 + 791));
				v42 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v43 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v93 = 508 - (351 + 154);
			end
			if ((v93 == (1578 - (1281 + 293))) or ((3966 - (28 + 238)) == (5601 - 3094))) then
				v47 = EpicSettings.Settings['UseRevive'];
				v48 = EpicSettings.Settings['UseMendPet'];
				v49 = EpicSettings.Settings['MendPetHP'] or (1559 - (1381 + 178));
				v93 = 5 + 0;
			end
			if (((3608 + 866) >= (117 + 157)) and (v93 == (3 - 2))) then
				v38 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v39 = EpicSettings.Settings['UseHealthstone'];
				v40 = EpicSettings.Settings['HealthstoneHP'] or (470 - (381 + 89));
				v93 = 2 + 0;
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
		v60 = v13:GetEquipment();
		v61 = (v60[1482 - (1269 + 200)] and v20(v60[24 - 11])) or v20(815 - (98 + 717));
		v62 = (v60[840 - (802 + 24)] and v20(v60[23 - 9])) or v20(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v94 = 0 + 0;
		while true do
			if ((v94 == (1 + 0)) or ((312 + 1582) <= (304 + 1102))) then
				v66 = 30910 - 19799;
				break;
			end
			if (((5242 - 3670) >= (548 + 983)) and (v94 == (0 + 0))) then
				v63 = {LastCast=(0 + 0),Count=(0 + 0)};
				v65 = 5188 + 5923;
				v94 = 1434 - (797 + 636);
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v95 = 0 - 0;
		while true do
			if ((v95 == (1620 - (1427 + 192))) or ((1625 + 3062) < (10545 - 6003))) then
				v55.AimedShot:RegisterInFlight();
				break;
			end
			if (((2959 + 332) > (756 + 911)) and (v95 == (326 - (192 + 134)))) then
				v55.SerpentSting:RegisterInFlight();
				v55.SteadyShot:RegisterInFlight();
				v95 = 1277 - (316 + 960);
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
			if ((v96 == (1 + 0)) or ((807 + 66) == (7775 - 5741))) then
				if ((v55.SteadyFocusBuff.LastAppliedOnPlayerTime > v63.LastCast) or ((3367 - (83 + 468)) < (1817 - (1202 + 604)))) then
					v63.Count = 0 - 0;
				end
				break;
			end
			if (((6155 - 2456) < (13029 - 8323)) and (v96 == (325 - (45 + 280)))) then
				if (((2554 + 92) >= (766 + 110)) and ((v63.Count == (0 + 0)) or (v63.Count == (1 + 0))) and v13:IsCasting(v55.SteadyShot) and (v63.LastCast < (v27() - v55.SteadyShot:CastTime()))) then
					local v128 = 0 + 0;
					while true do
						if (((1136 - 522) <= (5095 - (340 + 1571))) and (v128 == (0 + 0))) then
							v63.LastCast = v27();
							v63.Count = v63.Count + (1773 - (1733 + 39));
							break;
						end
					end
				end
				if (((8589 - 5463) == (4160 - (125 + 909))) and not (v13:IsCasting(v55.SteadyShot) or v13:PrevGCDP(1949 - (1096 + 852), v55.SteadyShot))) then
					v63.Count = 0 + 0;
				end
				v96 = 1 - 0;
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
		local v107 = 1317 - (1114 + 203);
		while true do
			if ((v107 == (726 - (228 + 498))) or ((474 + 1713) >= (2737 + 2217))) then
				if ((v15 and v15:Exists() and v55.Misdirection:IsReady()) or ((4540 - (174 + 489)) == (9313 - 5738))) then
					if (((2612 - (830 + 1075)) > (1156 - (303 + 221))) and v26(v57.MisdirectionFocus)) then
						return "misdirection opener";
					end
				end
				if ((v55.SummonPet:IsCastable() and not v55.LoneWolf:IsAvailable() and v44) or ((1815 - (231 + 1038)) >= (2237 + 447))) then
					if (((2627 - (171 + 991)) <= (17725 - 13424)) and v26(v58[v45])) then
						return "Summon Pet opener";
					end
				end
				v107 = 2 - 1;
			end
			if (((4252 - 2548) > (1141 + 284)) and (v107 == (3 - 2))) then
				if ((v55.Salvo:IsCastable() and v33) or ((1981 - 1294) == (6824 - 2590))) then
					if (v26(v55.Salvo) or ((10293 - 6963) < (2677 - (111 + 1137)))) then
						return "salvo opener";
					end
				end
				if (((1305 - (91 + 67)) >= (997 - 662)) and v55.AimedShot:IsReady() and not v13:IsCasting(v55.AimedShot) and (v69 < (1 + 2)) and (not v55.Volley:IsAvailable() or (v69 < (525 - (423 + 100))))) then
					if (((25 + 3410) > (5806 - 3709)) and v26(v55.AimedShot, not v70, true)) then
						return "aimed_shot opener";
					end
				end
				v107 = 2 + 0;
			end
			if ((v107 == (773 - (326 + 445))) or ((16452 - 12682) >= (9002 - 4961))) then
				if ((v55.WailingArrow:IsReady() and not v13:IsCasting(v55.WailingArrow) and ((v69 > (4 - 2)) or not v55.SteadyFocus:IsAvailable())) or ((4502 - (530 + 181)) <= (2492 - (614 + 267)))) then
					if (v26(v55.WailingArrow, not v70, true) or ((4610 - (19 + 13)) <= (3267 - 1259))) then
						return "wailing_arrow opener";
					end
				end
				if (((2621 - 1496) <= (5930 - 3854)) and v55.SteadyShot:IsCastable() and ((v69 > (1 + 1)) or (v55.Volley:IsAvailable() and (v69 == (3 - 1))))) then
					if (v26(v55.SteadyShot, not v70) or ((1540 - 797) >= (6211 - (1293 + 519)))) then
						return "steady_shot opener";
					end
				end
				break;
			end
		end
	end
	local function v87()
		local v108 = 0 - 0;
		while true do
			if (((3015 - 1860) < (3198 - 1525)) and (v108 == (8 - 6))) then
				if ((v55.LightsJudgment:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) or ((5474 - 3150) <= (307 + 271))) then
					if (((769 + 2998) == (8752 - 4985)) and v26(v55.LightsJudgment, not v14:IsSpellInRange(v55.LightsJudgment))) then
						return "lights_judgment cds 10";
					end
				end
				if (((945 + 3144) == (1359 + 2730)) and v55.Salvo:IsCastable() and ((v69 > (2 + 0)) or (v55.Volley:CooldownRemains() < (1106 - (709 + 387))))) then
					if (((6316 - (673 + 1185)) >= (4854 - 3180)) and v26(v55.Salvo)) then
						return "salvo cds 14";
					end
				end
				break;
			end
			if (((3120 - 2148) <= (2332 - 914)) and (v108 == (1 + 0))) then
				if ((v55.AncestralCall:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v55.Trueshot:CooldownRemains() > (23 + 7)) or (v66 < (20 - 4)))) or ((1213 + 3725) < (9494 - 4732))) then
					if (v26(v55.AncestralCall) or ((4915 - 2411) > (6144 - (446 + 1434)))) then
						return "ancestral_call cds 6";
					end
				end
				if (((3436 - (1040 + 243)) == (6425 - 4272)) and v55.Fireblood:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v55.Trueshot:CooldownRemains() > (1877 - (559 + 1288))) or (v66 < (1940 - (609 + 1322))))) then
					if (v26(v55.Fireblood) or ((961 - (13 + 441)) >= (9682 - 7091))) then
						return "fireblood cds 8";
					end
				end
				v108 = 5 - 3;
			end
			if (((22317 - 17836) == (167 + 4314)) and (v108 == (0 - 0))) then
				if ((v55.Berserking:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v66 < (5 + 8)))) or ((1021 + 1307) < (2056 - 1363))) then
					if (((2369 + 1959) == (7959 - 3631)) and v26(v55.Berserking)) then
						return "berserking cds 2";
					end
				end
				if (((1050 + 538) >= (741 + 591)) and v55.BloodFury:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v55.Trueshot:CooldownRemains() > (22 + 8)) or (v66 < (14 + 2)))) then
					if (v26(v55.BloodFury) or ((4084 + 90) > (4681 - (153 + 280)))) then
						return "blood_fury cds 4";
					end
				end
				v108 = 2 - 1;
			end
		end
	end
	local function v88()
		local v109 = 0 + 0;
		while true do
			if ((v109 == (0 + 0)) or ((2400 + 2186) <= (75 + 7))) then
				if (((2800 + 1063) == (5882 - 2019)) and v55.SteadyShot:IsCastable() and v55.SteadyFocus:IsAvailable() and (((v63.Count == (1 + 0)) and (v13:BuffRemains(v55.SteadyFocusBuff) < (672 - (89 + 578)))) or (v13:BuffDown(v55.SteadyFocusBuff) and v13:BuffDown(v55.TrueshotBuff) and (v63.Count ~= (2 + 0))))) then
					if (v26(v55.SteadyShot, not v70) or ((585 - 303) <= (1091 - (572 + 477)))) then
						return "steady_shot st 2";
					end
				end
				if (((622 + 3987) >= (460 + 306)) and v55.AimedShot:IsReady() and v13:BuffUp(v55.TrueshotBuff) and (v55.AimedShot:FullRechargeTime() < (v13:GCD() + v55.AimedShot:CastTime())) and v55.LegacyoftheWindrunners:IsAvailable() and v55.WindrunnersGuidance:IsAvailable()) then
					if (v26(v55.AimedShot, not v70, true) or ((138 + 1014) == (2574 - (84 + 2)))) then
						return "aimed_shot st 4";
					end
				end
				if (((5639 - 2217) > (2414 + 936)) and v55.KillShot:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) then
					if (((1719 - (497 + 345)) > (10 + 366)) and v26(v55.KillShot, not v70)) then
						return "kill_shot st 6";
					end
				end
				v109 = 1 + 0;
			end
			if ((v109 == (1336 - (605 + 728))) or ((2225 + 893) <= (4115 - 2264))) then
				if ((v55.DeathChakram:IsReady() and v33) or ((8 + 157) >= (12910 - 9418))) then
					if (((3561 + 388) < (13453 - 8597)) and v26(v55.DeathChakram, not v70)) then
						return "dark_chakram st 16";
					end
				end
				if ((v55.WailingArrow:IsReady() and (v69 > (1 + 0))) or ((4765 - (457 + 32)) < (1280 + 1736))) then
					if (((6092 - (832 + 570)) > (3887 + 238)) and v26(v55.WailingArrow, not v70, true)) then
						return "wailing_arrow st 18";
					end
				end
				if ((v55.RapidFire:IsCastable() and (v55.SurgingShots:IsAvailable() or (v55.AimedShot:FullRechargeTime() > (v55.AimedShot:CastTime() + v55.RapidFire:CastTime())))) or ((14 + 36) >= (3170 - 2274))) then
					if (v26(v55.RapidFire, not v70) or ((826 + 888) >= (3754 - (588 + 208)))) then
						return "rapid_fire st 22";
					end
				end
				v109 = 10 - 6;
			end
			if ((v109 == (1802 - (884 + 916))) or ((3121 - 1630) < (374 + 270))) then
				if (((1357 - (232 + 421)) < (2876 - (1569 + 320))) and v55.SerpentSting:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) then
					if (((913 + 2805) > (363 + 1543)) and v71.CastTargetIf(v55.SerpentSting, v67, "min", v76, v79, not v70, nil, nil, v57.SerpentStingMouseover)) then
						return "serpent_sting st 8";
					end
				end
				if (v55.ExplosiveShot:IsReady() or ((3228 - 2270) > (4240 - (316 + 289)))) then
					if (((9164 - 5663) <= (208 + 4284)) and v26(v55.ExplosiveShot, not v70)) then
						return "explosive_shot st 10";
					end
				end
				if ((v55.Stampede:IsCastable() and v33) or ((4895 - (666 + 787)) < (2973 - (360 + 65)))) then
					if (((2687 + 188) >= (1718 - (79 + 175))) and v26(v55.Stampede, not v14:IsInRange(47 - 17))) then
						return "stampede st 14";
					end
				end
				v109 = 3 + 0;
			end
			if ((v109 == (2 - 1)) or ((9237 - 4440) >= (5792 - (503 + 396)))) then
				if ((v53 and v55.Volley:IsReady() and (v16:GUID() == v14:GUID()) and (v13:BuffUp(v55.SalvoBuff))) or ((732 - (92 + 89)) > (4011 - 1943))) then
					if (((1085 + 1029) > (559 + 385)) and v26(v57.VolleyCursor, not v70)) then
						return "volley st 5";
					end
				end
				if ((v16:Exists() and v55.KillShot:IsCastable() and (v16:HealthPercentage() <= (78 - 58))) or ((310 + 1952) >= (7059 - 3963))) then
					if (v26(v57.KillShotMouseover, not v16:IsSpellInRange(v55.KillShot)) or ((1968 + 287) >= (1690 + 1847))) then
						return "kill_shot_mouseover cleave 38";
					end
				end
				if ((v46 and v55.SteelTrap:IsCastable() and (v13:BuffDown(v55.TrueshotBuff))) or ((11686 - 7849) < (164 + 1142))) then
					if (((4498 - 1548) == (4194 - (485 + 759))) and v26(v57.SteelTrapCursor, not v14:IsInRange(92 - 52))) then
						return "steel_trap st 6";
					end
				end
				v109 = 1191 - (442 + 747);
			end
			if ((v109 == (1141 - (832 + 303))) or ((5669 - (88 + 858)) < (1006 + 2292))) then
				if (((941 + 195) >= (7 + 147)) and v55.RapidFire:IsCastable()) then
					if (v26(v55.RapidFire, not v70) or ((1060 - (766 + 23)) > (23439 - 18691))) then
						return "rapid_fire st 34";
					end
				end
				if (((6482 - 1742) >= (8304 - 5152)) and v55.WailingArrow:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) then
					if (v26(v55.WailingArrow, not v70, true) or ((8749 - 6171) >= (4463 - (1036 + 37)))) then
						return "wailing_arrow st 36";
					end
				end
				if (((30 + 11) <= (3234 - 1573)) and v55.KillCommand:IsCastable() and (v13:BuffDown(v55.TrueshotBuff))) then
					if (((473 + 128) < (5040 - (641 + 839))) and v26(v55.KillCommand, not v14:IsInRange(963 - (910 + 3)))) then
						return "kill_command st 37";
					end
				end
				v109 = 17 - 10;
			end
			if (((1919 - (1466 + 218)) < (316 + 371)) and (v109 == (1156 - (556 + 592)))) then
				if (((1618 + 2931) > (1961 - (329 + 479))) and v55.SteadyShot:IsCastable()) then
					if (v26(v55.SteadyShot, not v70) or ((5528 - (174 + 680)) < (16053 - 11381))) then
						return "steady_shot st 44";
					end
				end
				break;
			end
			if (((7602 - 3934) < (3257 + 1304)) and ((744 - (396 + 343)) == v109)) then
				if (v55.AimedShot:IsReady() or ((41 + 414) == (5082 - (29 + 1448)))) then
					if (v71.CastTargetIf(v55.AimedShot, v67, "min", v77, v82, not v70, nil, nil, v57.AimedShotMouseover, true) or ((4052 - (135 + 1254)) == (12476 - 9164))) then
						return "aimed_shot st 28";
					end
				end
				if (((19969 - 15692) <= (2983 + 1492)) and v55.AimedShot:IsReady()) then
					if (v71.CastTargetIf(v55.AimedShot, v67, "max", v78, v83, not v70, nil, nil, v57.AimedShotMouseover, true) or ((2397 - (389 + 1138)) == (1763 - (102 + 472)))) then
						return "aimed_shot st 30";
					end
				end
				if (((1466 + 87) <= (1738 + 1395)) and v53 and v55.Volley:IsReady() and (v16:GUID() == v14:GUID())) then
					if (v26(v57.VolleyCursor, not v70) or ((2086 + 151) >= (5056 - (320 + 1225)))) then
						return "volley st 20";
					end
				end
				v109 = 10 - 4;
			end
			if ((v109 == (5 + 2)) or ((2788 - (157 + 1307)) > (4879 - (821 + 1038)))) then
				if ((v55.ChimaeraShot:IsReady() and (v13:BuffUp(v55.PreciseShotsBuff) or (v13:Focus() > (v55.ChimaeraShot:Cost() + v55.AimedShot:Cost())))) or ((7464 - 4472) == (206 + 1675))) then
					if (((5516 - 2410) > (568 + 958)) and v26(v55.ChimaeraShot, not v70)) then
						return "chimaera_shot st 38";
					end
				end
				if (((7492 - 4469) < (4896 - (834 + 192))) and v55.ArcaneShot:IsReady() and (v13:BuffUp(v55.PreciseShotsBuff) or (v13:Focus() > (v55.ArcaneShot:Cost() + v55.AimedShot:Cost())))) then
					if (((10 + 133) > (19 + 55)) and v26(v55.ArcaneShot, not v70)) then
						return "arcane_shot st 40";
					end
				end
				if (((1 + 17) < (3271 - 1159)) and v55.BagofTricks:IsReady()) then
					if (((1401 - (300 + 4)) <= (435 + 1193)) and v26(v55.BagofTricks, not v14:IsSpellInRange(v55.BagofTricks))) then
						return "bag_of_tricks st 42";
					end
				end
				v109 = 20 - 12;
			end
			if (((4992 - (112 + 250)) == (1846 + 2784)) and (v109 == (9 - 5))) then
				if (((2028 + 1512) > (1388 + 1295)) and v55.KillShot:IsReady()) then
					if (((3586 + 1208) >= (1624 + 1651)) and v26(v55.KillShot, not v70)) then
						return "kill_shot st 24";
					end
				end
				if (((1103 + 381) == (2898 - (1001 + 413))) and v55.Trueshot:IsReady() and v33 and v64 and (v13:BuffDown(v55.TrueshotBuff) or (v13:BuffRemains(v55.TrueshotBuff) < (11 - 6)))) then
					if (((2314 - (244 + 638)) < (4248 - (627 + 66))) and v26(v55.Trueshot, not v70)) then
						return "trueshot st 26";
					end
				end
				if ((v55.MultiShot:IsReady() and ((v13:BuffUp(v55.BombardmentBuff) and not v74() and (v69 > (2 - 1))) or (v13:BuffUp(v55.SalvoBuff) and not v55.Volley:IsAvailable()))) or ((1667 - (512 + 90)) > (5484 - (1665 + 241)))) then
					if (v26(v55.MultiShot, not v70) or ((5512 - (373 + 344)) < (635 + 772))) then
						return "multishot st 26";
					end
				end
				v109 = 2 + 3;
			end
		end
	end
	local function v89()
		if (((4887 - 3034) < (8144 - 3331)) and v55.SteadyShot:IsCastable() and v55.SteadyFocus:IsAvailable() and (v63.Count == (1100 - (35 + 1064))) and (v13:BuffRemains(v55.SteadyFocusBuff) < (6 + 2))) then
			if (v26(v55.SteadyShot, not v70) or ((6035 - 3214) < (10 + 2421))) then
				return "steady_shot trickshots 2";
			end
		end
		if (v55.KillShot:IsReady() or ((4110 - (298 + 938)) < (3440 - (233 + 1026)))) then
			if (v26(v55.KillShot, not v70) or ((4355 - (636 + 1030)) <= (176 + 167))) then
				return "kill_shot trickshots 4";
			end
		end
		if ((v16:Exists() and v55.KillShot:IsCastable() and (v16:HealthPercentage() <= (20 + 0))) or ((556 + 1313) == (136 + 1873))) then
			if (v26(v57.KillShotMouseover, not v16:IsSpellInRange(v55.KillShot)) or ((3767 - (55 + 166)) < (450 + 1872))) then
				return "kill_shot_mouseover cleave 38";
			end
		end
		if (v55.ExplosiveShot:IsReady() or ((210 + 1872) == (18228 - 13455))) then
			if (((3541 - (36 + 261)) > (1844 - 789)) and v26(v55.ExplosiveShot, not v70)) then
				return "explosive_shot trickshots 8";
			end
		end
		if ((v55.DeathChakram:IsReady() and v33) or ((4681 - (34 + 1334)) <= (684 + 1094))) then
			if (v26(v55.DeathChakram, not v70) or ((1105 + 316) >= (3387 - (1035 + 248)))) then
				return "death_chakram trickshots 10";
			end
		end
		if (((1833 - (20 + 1)) <= (1693 + 1556)) and v55.Stampede:IsReady() and v33) then
			if (((1942 - (134 + 185)) <= (3090 - (549 + 584))) and v26(v55.Stampede, not v14:IsInRange(715 - (314 + 371)))) then
				return "stampede trickshots 12";
			end
		end
		if (((15146 - 10734) == (5380 - (478 + 490))) and v55.WailingArrow:IsReady()) then
			if (((928 + 822) >= (2014 - (786 + 386))) and v26(v55.WailingArrow, not v70, true)) then
				return "wailing_arrow trickshots 14";
			end
		end
		if (((14160 - 9788) > (3229 - (1055 + 324))) and v55.SerpentSting:IsReady()) then
			if (((1572 - (1093 + 247)) < (730 + 91)) and v71.CastTargetIf(v55.SerpentSting, v67, "min", v76, v80, not v70, nil, nil, v57.SerpentStingMouseover)) then
				return "serpent_sting trickshots 16";
			end
		end
		if (((55 + 463) < (3581 - 2679)) and v55.Barrage:IsReady() and (v69 > (23 - 16)) and v33) then
			if (((8519 - 5525) > (2155 - 1297)) and v26(v55.Barrage, not v70)) then
				return "barrage trickshots 18";
			end
		end
		if ((v53 and v55.Volley:IsReady() and (v16:GUID() == v14:GUID())) or ((1336 + 2419) <= (3524 - 2609))) then
			if (((13600 - 9654) > (2823 + 920)) and v26(v57.VolleyCursor)) then
				return "volley trickshots 20";
			end
		end
		if ((v55.Trueshot:IsReady() and v33 and not v13:IsCasting(v55.SteadyShot) and not v13:IsCasting(v55.RapidFire) and not v13:IsChanneling(v55.RapidFire)) or ((3414 - 2079) >= (3994 - (364 + 324)))) then
			if (((13279 - 8435) > (5406 - 3153)) and v26(v55.Trueshot, not v70)) then
				return "trueshot trickshots 22";
			end
		end
		if (((150 + 302) == (1891 - 1439)) and v55.RapidFire:IsCastable() and (v13:BuffRemains(v55.TrickShotsBuff) >= v55.RapidFire:ExecuteTime()) and v55.SurgingShots:IsAvailable()) then
			if (v26(v55.RapidFire, not v70) or ((7297 - 2740) < (6338 - 4251))) then
				return "rapid_fire trickshots 24";
			end
		end
		if (((5142 - (1249 + 19)) == (3497 + 377)) and v55.AimedShot:IsReady()) then
			if (v71.CastTargetIf(v55.AimedShot, v67, "min", v77, v84, not v70, nil, nil, v57.AimedShotMouseover, true) or ((7543 - 5605) > (6021 - (686 + 400)))) then
				return "aimed_shot trickshots 26";
			end
		end
		if (v55.AimedShot:IsReady() or ((3339 + 916) < (3652 - (73 + 156)))) then
			if (((7 + 1447) <= (3302 - (721 + 90))) and v71.CastTargetIf(v55.AimedShot, v67, "max", v78, v85, not v70, nil, nil, v57.AimedShotMouseover, true)) then
				return "aimed_shot trickshots 28";
			end
		end
		if ((v55.RapidFire:IsCastable() and (v13:BuffRemains(v55.TrickShotsBuff) >= v55.RapidFire:ExecuteTime())) or ((47 + 4110) <= (9100 - 6297))) then
			if (((5323 - (224 + 246)) >= (4830 - 1848)) and v26(v55.RapidFire, not v70)) then
				return "rapid_fire trickshots 30";
			end
		end
		if (((7611 - 3477) > (609 + 2748)) and v55.ChimaeraShot:IsReady() and v13:BuffUp(v55.TrickShotsBuff) and v13:BuffUp(v55.PreciseShotsBuff) and (v13:Focus() > (v55.ChimaeraShot:Cost() + v55.AimedShot:Cost())) and (v69 < (1 + 3))) then
			if (v26(v55.ChimaeraShot, not v70) or ((2510 + 907) < (5037 - 2503))) then
				return "chimaera_shot trickshots 32";
			end
		end
		if ((v55.MultiShot:IsReady() and (not v74() or ((v13:BuffUp(v55.PreciseShotsBuff) or (v13:BuffStack(v55.BulletstormBuff) == (33 - 23))) and (v13:Focus() > (v55.MultiShot:Cost() + v55.AimedShot:Cost()))))) or ((3235 - (203 + 310)) <= (2157 - (1238 + 755)))) then
			if (v26(v55.MultiShot, not v70) or ((169 + 2239) < (3643 - (709 + 825)))) then
				return "multishot trickshots 34";
			end
		end
		if (v55.SerpentSting:IsReady() or ((60 - 27) == (2119 - 664))) then
			if (v71.CastTargetIf(v55.SerpentSting, v67, "min", v76, v81, not v70, nil, nil, v57.SerpentStingMouseover) or ((1307 - (196 + 668)) >= (15852 - 11837))) then
				return "serpent_sting trickshots 36";
			end
		end
		if (((7005 - 3623) > (999 - (171 + 662))) and v46 and v55.SteelTrap:IsCastable()) then
			if (v26(v57.SteelTrapCursor, not v14:IsInRange(133 - (4 + 89))) or ((981 - 701) == (1114 + 1945))) then
				return "steel_trap trickshots 38";
			end
		end
		if (((8261 - 6380) > (508 + 785)) and v55.KillShot:IsReady() and (v13:Focus() > (v55.KillShot:Cost() + v55.AimedShot:Cost()))) then
			if (((3843 - (35 + 1451)) == (3810 - (28 + 1425))) and v26(v55.KillShot, not v70)) then
				return "kill_shot trickshots 40";
			end
		end
		if (((2116 - (941 + 1052)) == (118 + 5)) and v55.MultiShot:IsReady() and (v13:Focus() > (v55.MultiShot:Cost() + v55.AimedShot:Cost()))) then
			if (v26(v55.MultiShot, not v70) or ((2570 - (822 + 692)) >= (4842 - 1450))) then
				return "multishot trickshots 42";
			end
		end
		if ((v55.BagofTricks:IsReady() and (v13:BuffDown(v55.Trueshot))) or ((510 + 571) < (1372 - (45 + 252)))) then
			if (v26(v55.BagofTricks, not v14:IsSpellInRange(v55.BagofTricks)) or ((1038 + 11) >= (1526 + 2906))) then
				return "bag_of_tricks trickshots 44";
			end
		end
		if (v55.SteadyShot:IsCastable() or ((11604 - 6836) <= (1279 - (114 + 319)))) then
			if (v26(v55.SteadyShot, not v70) or ((4821 - 1463) <= (1819 - 399))) then
				return "steady_shot trickshots 46";
			end
		end
	end
	local function v90()
		local v110 = v13:GetUseableItems(v59, 9 + 4);
		if ((v110 and (v13:BuffUp(v55.TrueshotBuff) or (v66 < (19 - 6)))) or ((7833 - 4094) <= (4968 - (556 + 1407)))) then
			if (v26(v57.Trinket1, nil, nil, true) or ((2865 - (741 + 465)) >= (2599 - (170 + 295)))) then
				return "trinket1 trinket 2";
			end
		end
		local v111 = v13:GetUseableItems(v59, 8 + 6);
		if ((v111 and (v13:BuffUp(v55.TrueshotBuff) or (v66 < (12 + 1)))) or ((8026 - 4766) < (1953 + 402))) then
			if (v26(v57.Trinket2, nil, nil, true) or ((430 + 239) == (2392 + 1831))) then
				return "trinket2 trinket 4";
			end
		end
	end
	local function v91()
		local v112 = 1230 - (957 + 273);
		while true do
			if ((v112 == (0 + 0)) or ((678 + 1014) < (2240 - 1652))) then
				v54();
				v31 = EpicSettings.Toggles['ooc'];
				v112 = 2 - 1;
			end
			if ((v112 == (9 - 6)) or ((23753 - 18956) < (5431 - (389 + 1391)))) then
				v68 = v14:GetEnemiesInSplashRange(7 + 3);
				if (v23() or ((435 + 3742) > (11041 - 6191))) then
					v69 = v14:GetEnemiesInSplashRangeCount(961 - (783 + 168));
				else
					v69 = 3 - 2;
				end
				v112 = 4 + 0;
			end
			if ((v112 == (315 - (309 + 2))) or ((1228 - 828) > (2323 - (1090 + 122)))) then
				if (((990 + 2061) > (3375 - 2370)) and (v71.TargetIsValid() or v13:AffectingCombat())) then
					local v130 = 0 + 0;
					while true do
						if (((4811 - (628 + 490)) <= (786 + 3596)) and (v130 == (2 - 1))) then
							if ((v66 == (50777 - 39666)) or ((4056 - (431 + 343)) > (8280 - 4180))) then
								v66 = v10.FightRemains(v68, false);
							end
							break;
						end
						if ((v130 == (0 - 0)) or ((2829 + 751) < (364 + 2480))) then
							v65 = v10.BossFightRemains(nil, true);
							v66 = v65;
							v130 = 1696 - (556 + 1139);
						end
					end
				end
				if (((104 - (6 + 9)) < (823 + 3667)) and v71.TargetIsValid()) then
					local v131 = 0 + 0;
					while true do
						if ((v131 == (171 - (28 + 141))) or ((1931 + 3052) < (2231 - 423))) then
							if (((2712 + 1117) > (5086 - (486 + 831))) and v33) then
								local v134 = 0 - 0;
								local v135;
								while true do
									if (((5228 - 3743) <= (549 + 2355)) and (v134 == (0 - 0))) then
										v135 = v87();
										if (((5532 - (668 + 595)) == (3842 + 427)) and v135) then
											return v135;
										end
										break;
									end
								end
							end
							if (((79 + 308) <= (7586 - 4804)) and ((v69 < (293 - (23 + 267))) or not v55.TrickShots:IsAvailable() or not v32)) then
								local v136 = 1944 - (1129 + 815);
								local v137;
								while true do
									if ((v136 == (387 - (371 + 16))) or ((3649 - (1326 + 424)) <= (1736 - 819))) then
										v137 = v88();
										if (v137 or ((15757 - 11445) <= (994 - (88 + 30)))) then
											return v137;
										end
										break;
									end
								end
							end
							if (((3003 - (720 + 51)) <= (5774 - 3178)) and (v69 > (1778 - (421 + 1355)))) then
								local v138 = 0 - 0;
								local v139;
								while true do
									if (((1030 + 1065) < (4769 - (286 + 797))) and (v138 == (0 - 0))) then
										v139 = v89();
										if (v139 or ((2641 - 1046) >= (4913 - (397 + 42)))) then
											return v139;
										end
										break;
									end
								end
							end
							if (v26(v55.PoolFocus) or ((1443 + 3176) < (3682 - (24 + 776)))) then
								return "Pooling Focus";
							end
							break;
						end
						if ((v131 == (0 - 0)) or ((1079 - (222 + 563)) >= (10644 - 5813))) then
							v75();
							if (((1461 + 568) <= (3274 - (23 + 167))) and not v13:AffectingCombat() and not v31) then
								local v140 = 1798 - (690 + 1108);
								local v141;
								while true do
									if ((v140 == (0 + 0)) or ((1681 + 356) == (3268 - (40 + 808)))) then
										v141 = v86();
										if (((734 + 3724) > (14928 - 11024)) and v141) then
											return v141;
										end
										break;
									end
								end
							end
							if (((417 + 19) >= (66 + 57)) and v55.Exhilaration:IsReady() and (v13:HealthPercentage() <= v51)) then
								if (((275 + 225) < (2387 - (47 + 524))) and v26(v55.Exhilaration)) then
									return "exhilaration";
								end
							end
							if (((2320 + 1254) == (9769 - 6195)) and (v13:HealthPercentage() <= v40) and v56.Healthstone:IsReady()) then
								if (((330 - 109) < (889 - 499)) and v26(v57.Healthstone, nil, nil, true)) then
									return "healthstone";
								end
							end
							v131 = 1727 - (1165 + 561);
						end
						if ((v131 == (1 + 0)) or ((6853 - 4640) <= (543 + 878))) then
							if (((3537 - (341 + 138)) < (1312 + 3548)) and not v13:IsCasting() and not v13:IsChanneling()) then
								local v142 = v71.Interrupt(v55.CounterShot, 82 - 42, true);
								if (v142 or ((1622 - (89 + 237)) >= (14302 - 9856))) then
									return v142;
								end
								v142 = v71.InterruptWithStun(v55.Intimidation, 84 - 44);
								if (v142 or ((2274 - (581 + 300)) > (5709 - (855 + 365)))) then
									return v142;
								end
								v142 = v71.Interrupt(v55.CounterShot, 95 - 55, true, v16, v57.CounterShotMouseover);
								if (v142 or ((1445 + 2979) < (1262 - (1030 + 205)))) then
									return v142;
								end
								v142 = v71.InterruptWithStun(v55.Intimidation, 38 + 2, false, v16, v57.IntimidationMouseover);
								if (v142 or ((1858 + 139) > (4101 - (156 + 130)))) then
									return v142;
								end
							end
							if (((7873 - 4408) > (3223 - 1310)) and v52 and v55.TranquilizingShot:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and (v71.UnitHasEnrageBuff(v14) or v71.UnitHasMagicBuff(v14))) then
								if (((1501 - 768) < (480 + 1339)) and v26(v55.TranquilizingShot, not v70)) then
									return "dispel";
								end
							end
							v64 = v55.Trueshot:CooldownUp();
							if ((v35 and v33) or ((2563 + 1832) == (4824 - (10 + 59)))) then
								local v143 = 0 + 0;
								local v144;
								while true do
									if ((v143 == (0 - 0)) or ((4956 - (671 + 492)) < (1886 + 483))) then
										v144 = v90();
										if (v144 or ((5299 - (369 + 846)) == (71 + 194))) then
											return v144;
										end
										break;
									end
								end
							end
							v131 = 2 + 0;
						end
					end
				end
				break;
			end
			if (((6303 - (1036 + 909)) == (3465 + 893)) and (v112 == (1 - 0))) then
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v112 = 205 - (11 + 192);
			end
			if ((v112 == (2 + 0)) or ((3313 - (135 + 40)) < (2405 - 1412))) then
				v70 = v14:IsSpellInRange(v55.AimedShot);
				v67 = v13:GetEnemiesInRange(v55.AimedShot.MaximumRange);
				v112 = 2 + 1;
			end
		end
	end
	local function v92()
		v10.Print("Marksmanship by Epic. Supported by Gojira");
	end
	v10.SetAPL(559 - 305, v91, v92);
end;
return v0["Epix_Hunter_Marksmanship.lua"]();

