local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((9583 - 5604) >= (144 + 1524)) and (v5 == (1691 - (1121 + 569)))) then
			return v6(...);
		end
		if (((782 - (22 + 192)) > (1111 - (483 + 200))) and (v5 == (1463 - (1404 + 59)))) then
			v6 = v0[v4];
			if (((3650 - 2316) <= (6199 - 1586)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 766 - (468 + 297);
		end
	end
end
v0["Epix_Hunter_BeastMastery.lua"] = function(...)
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
	local v19 = v10.Item;
	local v20 = v10.Action;
	local v21 = v10.Bind;
	local v22 = v10.Macro;
	local v23 = v10.AoEON;
	local v24 = v10.CDsON;
	local v25 = v10.Cast;
	local v26 = v10.Press;
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v30 = math.max;
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
	local function v50()
		v31 = EpicSettings.Settings['UseRacials'];
		v33 = EpicSettings.Settings['UseHealingPotion'];
		v34 = EpicSettings.Settings['HealingPotionName'] or (562 - (334 + 228));
		v35 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v36 = EpicSettings.Settings['UseHealthstone'];
		v37 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v38 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
		v39 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
		v40 = EpicSettings.Settings['InterruptThreshold'] or (236 - (141 + 95));
		v41 = EpicSettings.Settings['UsePet'];
		v42 = EpicSettings.Settings['SummonPetSlot'] or (0 + 0);
		v43 = EpicSettings.Settings['UseSteelTrap'];
		v44 = EpicSettings.Settings['UseRevive'];
		v45 = EpicSettings.Settings['UseMendPet'];
		v46 = EpicSettings.Settings['MendPetHP'] or (0 - 0);
		v47 = EpicSettings.Settings['UseExhilaration'];
		v48 = EpicSettings.Settings['ExhilarationHP'] or (0 - 0);
		v49 = EpicSettings.Settings['UseTranq'];
	end
	local v51 = v10.Commons.Everyone;
	local v52 = v10.Commons.Hunter;
	local v53 = v18.Hunter.BeastMastery;
	local v54 = {v53.SummonPet,v53.SummonPet2,v53.SummonPet3,v53.SummonPet4,v53.SummonPet5};
	local v55 = v19.Hunter.BeastMastery;
	local v56 = {};
	local v57 = v22.Hunter.BeastMastery;
	local v58 = v13:GetEquipment();
	v10:RegisterForEvent(function()
		v58 = v13:GetEquipment();
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v59;
	local v60 = 6554 + 4557;
	local v61 = 11274 - (92 + 71);
	v10:RegisterForEvent(function()
		local v97 = 0 + 0;
		while true do
			if ((v97 == (0 - 0)) or ((2630 - (574 + 191)) >= (1674 + 355))) then
				v60 = 27836 - 16725;
				v61 = 5676 + 5435;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v62, v63, v64;
	local v65, v66;
	local v67;
	local v68 = {{v53.Intimidation,"Cast Intimidation (Interrupt)",function()
		return true;
	end}};
	local function v69(v98)
		return (v98:DebuffRemains(v53.BarbedShotDebuff));
	end
	local function v70(v99)
		return (v99:DebuffStack(v53.LatentPoisonDebuff));
	end
	local function v71(v100)
		return (v100:DebuffRemains(v53.SerpentStingDebuff));
	end
	local function v72(v101)
		return (v101:DebuffStack(v53.LatentPoisonDebuff) > (24 - 15)) and ((v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + 0.25 + 0))) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < ((18 - 6) + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < (942 - (714 + 225))) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp())) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown()));
	end
	local function v73(v102)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + (0.25 - 0)))) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < ((16 - 4) + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < (1 + 2)) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp())) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown());
	end
	local function v74(v103)
		return (v103:DebuffStack(v53.LatentPoisonDebuff) > (12 - 3)) and (v13:BuffUp(v53.CalloftheWildBuff) or (v61 < (815 - (118 + 688))) or (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (49.2 - (25 + 23)))) or v53.Savagery:IsAvailable());
	end
	local function v75(v104)
		return v13:BuffUp(v53.CalloftheWildBuff) or (v61 < (2 + 7)) or (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1887.2 - (927 + 959)))) or v53.Savagery:IsAvailable();
	end
	local function v76(v105)
		return v105:DebuffRefreshable(v53.SerpentStingDebuff) and (v105:TimeToDie() > v53.SerpentStingDebuff:BaseDuration());
	end
	local function v77(v106)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + (0.25 - 0)))) or (v53.ScentofBlood:IsAvailable() and (v17:BuffStack(v53.FrenzyPetBuff) < (735 - (16 + 716))) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp()));
	end
	local function v78(v107)
		return (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1.4 - 0))) or v13:BuffUp(v53.CalloftheWildBuff) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown()) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < ((109 - (11 + 86)) + v59))) or v53.Savagery:IsAvailable() or (v61 < (21 - 12));
	end
	local function v79(v108)
		return v108:DebuffRefreshable(v53.SerpentStingDebuff) and (v14:TimeToDie() > v53.SerpentStingDebuff:BaseDuration());
	end
	local function v80()
		if (((5235 - (175 + 110)) >= (4079 - 2463)) and v15:Exists() and v53.Misdirection:IsReady()) then
			if (((8508 - 6783) == (3521 - (503 + 1293))) and v26(v57.MisdirectionFocus)) then
				return "misdirection precombat 0";
			end
		end
		if (((4074 - 2615) <= (1795 + 687)) and v53.SteelTrap:IsCastable() and not v53.WailingArrow:IsAvailable() and v53.SteelTrap:IsAvailable()) then
			if (v26(v53.SteelTrap) or ((3757 - (810 + 251)) >= (3146 + 1386))) then
				return "steel_trap precombat 2";
			end
		end
		if (((322 + 726) >= (47 + 5)) and v53.BarbedShot:IsCastable() and (v53.BarbedShot:Charges() >= (535 - (43 + 490)))) then
			if (((3691 - (711 + 22)) < (17418 - 12915)) and v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot))) then
				return "barbed_shot precombat 8";
			end
		end
		if (v53.KillShot:IsReady() or ((3594 - (240 + 619)) == (316 + 993))) then
			if (v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot)) or ((6569 - 2439) <= (196 + 2759))) then
				return "kill_shot precombat 10";
			end
		end
		if ((v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (1764 - (1344 + 400)))) or ((2369 - (255 + 150)) <= (1056 + 284))) then
			if (((1338 + 1161) == (10677 - 8178)) and v26(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot))) then
				return "kill_shot_mouseover precombat 11";
			end
		end
		if (v53.KillCommand:IsReady() or ((7283 - 5028) < (1761 - (404 + 1335)))) then
			if (v26(v57.KillCommandPetAttack) or ((1492 - (183 + 223)) >= (1709 - 304))) then
				return "kill_command precombat 12";
			end
		end
		if ((v64 > (1 + 0)) or ((853 + 1516) == (763 - (10 + 327)))) then
			if (v53.MultiShot:IsReady() or ((2143 + 933) > (3521 - (118 + 220)))) then
				if (((401 + 801) > (1507 - (108 + 341))) and v26(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot))) then
					return "multishot precombat 14";
				end
			end
		elseif (((1667 + 2044) > (14184 - 10829)) and v53.CobraShot:IsReady()) then
			if (v26(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot)) or ((2399 - (711 + 782)) >= (4272 - 2043))) then
				return "cobra_shot precombat 16";
			end
		end
	end
	local function v81()
		local v109 = 469 - (270 + 199);
		while true do
			if (((418 + 870) > (3070 - (580 + 1239))) and (v109 == (2 - 1))) then
				if ((v53.AncestralCall:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (16 + 0)))) or ((163 + 4350) < (1461 + 1891))) then
					if (v26(v53.AncestralCall) or ((5391 - 3326) >= (1986 + 1210))) then
						return "ancestral_call cds 10";
					end
				end
				if ((v53.Fireblood:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (1176 - (645 + 522))))) or ((6166 - (1010 + 780)) <= (1481 + 0))) then
					if (v26(v53.Fireblood) or ((16159 - 12767) >= (13893 - 9152))) then
						return "fireblood cds 12";
					end
				end
				break;
			end
			if (((5161 - (1045 + 791)) >= (5451 - 3297)) and (v109 == (0 - 0))) then
				if ((v53.Berserking:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (518 - (351 + 154))))) or ((2869 - (1281 + 293)) >= (3499 - (28 + 238)))) then
					if (((9780 - 5403) > (3201 - (1381 + 178))) and v26(v53.Berserking)) then
						return "berserking cds 2";
					end
				end
				if (((4430 + 293) > (1094 + 262)) and v53.BloodFury:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (7 + 9)))) then
					if (v26(v53.BloodFury) or ((14258 - 10122) <= (1779 + 1654))) then
						return "blood_fury cds 8";
					end
				end
				v109 = 471 - (381 + 89);
			end
		end
	end
	local function v82()
		local v110 = v51.HandleTopTrinket(v56, v29, 36 + 4, nil);
		if (((2871 + 1374) <= (7932 - 3301)) and v110) then
			return v110;
		end
		local v110 = v51.HandleBottomTrinket(v56, v29, 1196 - (1074 + 82), nil);
		if (((9370 - 5094) >= (5698 - (214 + 1570))) and v110) then
			return v110;
		end
	end
	local function v83()
		if (((1653 - (990 + 465)) <= (1800 + 2565)) and v53.BarbedShot:IsCastable()) then
			if (((2081 + 2701) > (4548 + 128)) and v51.CastTargetIf(v53.BarbedShot, v62, "max", v70, v72, not v14:IsSpellInRange(v53.BarbedShot))) then
				return "barbed_shot cleave 2";
			end
		end
		if (((19142 - 14278) > (3923 - (1668 + 58))) and v53.BarbedShot:IsCastable()) then
			if (v51.CastTargetIf(v53.BarbedShot, v62, "min", v69, v73, not v14:IsSpellInRange(v53.BarbedShot)) or ((4326 - (512 + 114)) == (6535 - 4028))) then
				return "barbed_shot cleave 4";
			end
		end
		if (((9249 - 4775) >= (953 - 679)) and v53.MultiShot:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < (0.25 + 0 + v59)) and (not v53.BloodyFrenzy:IsAvailable() or v53.CalloftheWild:CooldownDown())) then
			if (v26(v53.MultiShot, nil, nil, not v14:IsSpellInRange(v53.MultiShot)) or ((355 + 1539) <= (1223 + 183))) then
				return "multishot cleave 6";
			end
		end
		if (((5302 - 3730) >= (3525 - (109 + 1885))) and v53.BestialWrath:IsCastable() and v29) then
			if (v26(v53.BestialWrath) or ((6156 - (1269 + 200)) < (8705 - 4163))) then
				return "bestial_wrath cleave 8";
			end
		end
		if (((4106 - (98 + 717)) > (2493 - (802 + 24))) and v53.CalloftheWild:IsCastable() and v29) then
			if (v25(v53.CalloftheWild) or ((1505 - 632) == (2568 - 534))) then
				return "call_of_the_wild cleave 10";
			end
		end
		if ((v53.KillCommand:IsReady() and (v53.KillCleave:IsAvailable())) or ((416 + 2400) < (9 + 2))) then
			if (((608 + 3091) < (1016 + 3690)) and v25(v53.KillCommand, nil, nil, not v14:IsInRange(139 - 89))) then
				return "kill_command cleave 12";
			end
		end
		if (((8823 - 6177) >= (314 + 562)) and v53.ExplosiveShot:IsReady()) then
			if (((250 + 364) <= (2627 + 557)) and v26(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot))) then
				return "explosive_shot cleave 12";
			end
		end
		if (((2274 + 852) == (1460 + 1666)) and v53.Stampede:IsCastable() and v29) then
			if (v26(v53.Stampede, not v14:IsSpellInRange(v53.Stampede)) or ((3620 - (797 + 636)) >= (24053 - 19099))) then
				return "stampede cleave 14";
			end
		end
		if (v53.Bloodshed:IsCastable() or ((5496 - (1427 + 192)) == (1239 + 2336))) then
			if (((1641 - 934) > (569 + 63)) and v26(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed))) then
				return "bloodshed cleave 16";
			end
		end
		if ((v53.DeathChakram:IsCastable() and v29) or ((248 + 298) >= (3010 - (192 + 134)))) then
			if (((2741 - (316 + 960)) <= (2394 + 1907)) and v26(v53.DeathChakram, not v14:IsSpellInRange(v53.DeathChakram))) then
				return "death_chakram cleave 18";
			end
		end
		if (((1316 + 388) > (1318 + 107)) and v53.SteelTrap:IsCastable()) then
			if (v26(v57.SteelTrap) or ((2626 - 1939) == (4785 - (83 + 468)))) then
				return "steel_trap cleave 22";
			end
		end
		if ((v53.AMurderofCrows:IsReady() and v29) or ((5136 - (1202 + 604)) < (6670 - 5241))) then
			if (((1908 - 761) >= (927 - 592)) and v26(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows))) then
				return "a_murder_of_crows cleave 24";
			end
		end
		if (((3760 - (45 + 280)) > (2025 + 72)) and v53.BarbedShot:IsCastable()) then
			if (v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "max", v70, v74, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover) or ((3294 + 476) >= (1476 + 2565))) then
				return "barbed_shot cleave 26";
			end
		end
		if (v53.BarbedShot:IsCastable() or ((2098 + 1693) <= (284 + 1327))) then
			if (v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v75, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover) or ((8476 - 3898) <= (3919 - (340 + 1571)))) then
				return "barbed_shot cleave 28";
			end
		end
		if (((444 + 681) <= (3848 - (1733 + 39))) and v53.KillCommand:IsReady()) then
			if (v26(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand)) or ((2041 - 1298) >= (5433 - (125 + 909)))) then
				return "kill_command cleave 30";
			end
		end
		if (((3103 - (1096 + 852)) < (751 + 922)) and v53.DireBeast:IsCastable()) then
			if (v26(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast)) or ((3318 - 994) <= (561 + 17))) then
				return "dire_beast cleave 32";
			end
		end
		if (((4279 - (409 + 103)) == (4003 - (46 + 190))) and v53.SerpentSting:IsReady()) then
			if (((4184 - (51 + 44)) == (1154 + 2935)) and v51.CastTargetIf(v53.SerpentSting, v62, "min", v71, v76, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover)) then
				return "serpent_sting cleave 34";
			end
		end
		if (((5775 - (1114 + 203)) >= (2400 - (228 + 498))) and v53.Barrage:IsReady() and (v17:BuffRemains(v53.FrenzyPetBuff) > v53.Barrage:ExecuteTime())) then
			if (((211 + 761) <= (784 + 634)) and v26(v53.Barrage, not v14:IsSpellInRange(v53.Barrage))) then
				return "barrage cleave 36";
			end
		end
		if ((v53.MultiShot:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < (v13:GCD() * (665 - (174 + 489))))) or ((12864 - 7926) < (6667 - (830 + 1075)))) then
			if (v26(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot)) or ((3028 - (303 + 221)) > (5533 - (231 + 1038)))) then
				return "multishot cleave 38";
			end
		end
		if (((1795 + 358) == (3315 - (171 + 991))) and v53.AspectoftheWild:IsCastable() and v29) then
			if (v26(v53.AspectoftheWild) or ((2089 - 1582) >= (6957 - 4366))) then
				return "aspect_of_the_wild cleave 40";
			end
		end
		if (((11182 - 6701) == (3587 + 894)) and v29 and v53.LightsJudgment:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v14:TimeToDie() < (17 - 12)))) then
			if (v25(v53.LightsJudgment, nil, not v14:IsInRange(14 - 9)) or ((3752 - 1424) < (2142 - 1449))) then
				return "lights_judgment cleave 40";
			end
		end
		if (((5576 - (111 + 1137)) == (4486 - (91 + 67))) and v53.KillShot:IsReady()) then
			if (((4726 - 3138) >= (333 + 999)) and v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot))) then
				return "kill_shot cleave 38";
			end
		end
		if ((v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (543 - (423 + 100)))) or ((30 + 4144) > (11761 - 7513))) then
			if (v26(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot)) or ((2391 + 2195) <= (853 - (326 + 445)))) then
				return "kill_shot_mouseover cleave 39";
			end
		end
		if (((16857 - 12994) == (8605 - 4742)) and v53.CobraShot:IsReady() and (v13:FocusTimeToMax() < (v59 * (4 - 2)))) then
			if (v26(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot)) or ((993 - (530 + 181)) <= (923 - (614 + 267)))) then
				return "cobra_shot cleave 42";
			end
		end
		if (((4641 - (19 + 13)) >= (1246 - 480)) and v53.WailingArrow:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53.WailingArrow:ExecuteTime()) or (v61 < (11 - 6)))) then
			if (v26(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow)) or ((3290 - 2138) == (647 + 1841))) then
				return "wailing_arrow cleave 44";
			end
		end
		if (((6017 - 2595) > (6947 - 3597)) and v53.BagofTricks:IsCastable() and v29 and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (1817 - (1293 + 519))))) then
			if (((1788 - 911) > (981 - 605)) and v26(v53.BagofTricks)) then
				return "bag_of_tricks cleave 46";
			end
		end
		if ((v53.ArcaneTorrent:IsCastable() and v29 and ((v13:Focus() + v13:FocusRegen() + (57 - 27)) < v13:FocusMax())) or ((13445 - 10327) <= (4360 - 2509))) then
			if (v26(v53.ArcaneTorrent) or ((88 + 77) >= (713 + 2779))) then
				return "arcane_torrent cleave 48";
			end
		end
	end
	local function v84()
		if (((9175 - 5226) < (1123 + 3733)) and v53.BarbedShot:IsCastable()) then
			if (v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v77, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover) or ((1421 + 2855) < (1885 + 1131))) then
				return "barbed_shot st 2";
			end
		end
		if (((5786 - (709 + 387)) > (5983 - (673 + 1185))) and v53.BarbedShot:IsCastable() and v77(v14)) then
			if (v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot)) or ((145 - 95) >= (2877 - 1981))) then
				return "barbed_shot st mt_backup 3";
			end
		end
		if ((v53.CalloftheWild:IsCastable() and v29) or ((2819 - 1105) >= (2116 + 842))) then
			if (v26(v53.CalloftheWild) or ((1115 + 376) < (869 - 225))) then
				return "call_of_the_wild st 6";
			end
		end
		if (((173 + 531) < (1967 - 980)) and v53.KillCommand:IsReady() and (v53.KillCommand:FullRechargeTime() < v59) and v53.AlphaPredator:IsAvailable()) then
			if (((7298 - 3580) > (3786 - (446 + 1434))) and v26(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand))) then
				return "kill_command st 4";
			end
		end
		if ((v53.Stampede:IsCastable() and v29) or ((2241 - (1040 + 243)) > (10849 - 7214))) then
			if (((5348 - (559 + 1288)) <= (6423 - (609 + 1322))) and v25(v53.Stampede, nil, nil, not v14:IsSpellInRange(v53.Stampede))) then
				return "stampede st 8";
			end
		end
		if (v53.Bloodshed:IsCastable() or ((3896 - (13 + 441)) < (9521 - 6973))) then
			if (((7530 - 4655) >= (7291 - 5827)) and v26(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed))) then
				return "bloodshed st 10";
			end
		end
		if ((v53.BestialWrath:IsCastable() and v29) or ((179 + 4618) >= (17770 - 12877))) then
			if (v26(v53.BestialWrath) or ((196 + 355) > (907 + 1161))) then
				return "bestial_wrath st 12";
			end
		end
		if (((6273 - 4159) > (517 + 427)) and v53.DeathChakram:IsCastable() and v29) then
			if (v25(v53.DeathChakram, nil, nil, not v14:IsSpellInRange(v53.DeathChakram)) or ((4159 - 1897) >= (2047 + 1049))) then
				return "death_chakram st 14";
			end
		end
		if (v53.KillCommand:IsReady() or ((1255 + 1000) >= (2542 + 995))) then
			if (v26(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand)) or ((3222 + 615) < (1278 + 28))) then
				return "kill_command st 22";
			end
		end
		if (((3383 - (153 + 280)) == (8518 - 5568)) and v53.AMurderofCrows:IsCastable() and v29) then
			if (v26(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows)) or ((4241 + 482) < (1303 + 1995))) then
				return "a_murder_of_crows st 14";
			end
		end
		if (((595 + 541) >= (140 + 14)) and v53.SteelTrap:IsCastable()) then
			if (v26(v53.SteelTrap) or ((197 + 74) > (7229 - 2481))) then
				return "steel_trap st 16";
			end
		end
		if (((2930 + 1810) >= (3819 - (89 + 578))) and v53.ExplosiveShot:IsReady()) then
			if (v26(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot)) or ((1842 + 736) >= (7047 - 3657))) then
				return "explosive_shot st 18";
			end
		end
		if (((1090 - (572 + 477)) <= (225 + 1436)) and v53.BarbedShot:IsCastable()) then
			if (((361 + 240) < (425 + 3135)) and v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v78, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
				return "barbed_shot st 24";
			end
		end
		if (((321 - (84 + 2)) < (1131 - 444)) and v53.BarbedShot:IsCastable() and v78(v14)) then
			if (((3278 + 1271) > (1995 - (497 + 345))) and v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot))) then
				return "barbed_shot st mt_backup 25";
			end
		end
		if (v53.DireBeast:IsCastable() or ((120 + 4554) < (790 + 3882))) then
			if (((5001 - (605 + 728)) < (3255 + 1306)) and v26(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast))) then
				return "dire_beast st 26";
			end
		end
		if (v53.SerpentSting:IsReady() or ((1011 - 556) == (166 + 3439))) then
			if (v51.CastTargetIf(v53.SerpentSting, v62, "min", v71, v79, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover) or ((9845 - 7182) == (2986 + 326))) then
				return "serpent_sting st 28";
			end
		end
		if (((11849 - 7572) <= (3379 + 1096)) and v53.KillShot:IsReady()) then
			if (v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot)) or ((1359 - (457 + 32)) == (505 + 684))) then
				return "kill_shot st 30";
			end
		end
		if (((2955 - (832 + 570)) <= (2952 + 181)) and v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (6 + 14))) then
			if (v26(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot)) or ((7916 - 5679) >= (1692 + 1819))) then
				return "kill_shot_mouseover st 31";
			end
		end
		if ((v53.AspectoftheWild:IsCastable() and v29) or ((2120 - (588 + 208)) > (8139 - 5119))) then
			if (v26(v53.AspectoftheWild) or ((4792 - (884 + 916)) == (3937 - 2056))) then
				return "aspect_of_the_wild st 32";
			end
		end
		if (((1801 + 1305) > (2179 - (232 + 421))) and v53.CobraShot:IsReady()) then
			if (((4912 - (1569 + 320)) < (950 + 2920)) and v26(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot))) then
				return "cobra_shot st 34";
			end
		end
		if (((28 + 115) > (249 - 175)) and v53.WailingArrow:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53.WailingArrow:ExecuteTime()) or (v61 < (610 - (316 + 289))))) then
			if (((46 - 28) < (98 + 2014)) and v26(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow), true)) then
				return "wailing_arrow st 36";
			end
		end
		if (((2550 - (666 + 787)) <= (2053 - (360 + 65))) and v29) then
			local v116 = 0 + 0;
			while true do
				if (((4884 - (79 + 175)) == (7300 - 2670)) and (v116 == (1 + 0))) then
					if (((10851 - 7311) > (5166 - 2483)) and v53.ArcaneTorrent:IsCastable() and ((v13:Focus() + v13:FocusRegen() + (914 - (503 + 396))) < v13:FocusMax())) then
						if (((4975 - (92 + 89)) >= (6352 - 3077)) and v26(v53.ArcaneTorrent)) then
							return "arcane_torrent st 42";
						end
					end
					break;
				end
				if (((762 + 722) == (879 + 605)) and (v116 == (0 - 0))) then
					if (((196 + 1236) < (8105 - 4550)) and v53.BagofTricks:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (5 + 0)))) then
						if (v26(v53.BagofTricks) or ((509 + 556) > (10897 - 7319))) then
							return "bag_of_tricks st 38";
						end
					end
					if ((v53.ArcanePulse:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (1 + 4)))) or ((7312 - 2517) < (2651 - (485 + 759)))) then
						if (((4287 - 2434) < (6002 - (442 + 747))) and v26(v53.ArcanePulse)) then
							return "arcane_pulse st 40";
						end
					end
					v116 = 1136 - (832 + 303);
				end
			end
		end
	end
	local function v85()
		if ((not v13:IsCasting() and not v13:IsChanneling()) or ((3767 - (88 + 858)) < (741 + 1690))) then
			local v117 = v51.Interrupt(v53.CounterShot, 34 + 6, true);
			if (v117 or ((119 + 2755) < (2970 - (766 + 23)))) then
				return v117;
			end
			v117 = v51.InterruptWithStun(v53.Intimidation, 197 - 157);
			if (v117 or ((3676 - 987) <= (903 - 560))) then
				return v117;
			end
		end
	end
	local function v86()
		local v111 = 0 - 0;
		local v112;
		local v113;
		while true do
			if ((v111 == (1077 - (1036 + 37))) or ((1326 + 543) == (3911 - 1902))) then
				if (v51.TargetIsValid() or ((2790 + 756) < (3802 - (641 + 839)))) then
					if ((not v13:AffectingCombat() and not v27) or ((2995 - (910 + 3)) == (12167 - 7394))) then
						local v125 = v80();
						if (((4928 - (1466 + 218)) > (485 + 570)) and v125) then
							return v125;
						end
					end
					local v121 = v85();
					if (v121 or ((4461 - (556 + 592)) <= (633 + 1145))) then
						return v121;
					end
					if (v29 or ((2229 - (329 + 479)) >= (2958 - (174 + 680)))) then
						local v126 = v81();
						if (((6226 - 4414) <= (6733 - 3484)) and v126) then
							return v126;
						end
					end
					local v121 = v82();
					if (((1159 + 464) <= (2696 - (396 + 343))) and v121) then
						return v121;
					end
					if (((391 + 4021) == (5889 - (29 + 1448))) and ((v64 < (1391 - (135 + 1254))) or (not v53.BeastCleave:IsAvailable() and (v64 < (11 - 8))))) then
						local v127 = v84();
						if (((8170 - 6420) >= (562 + 280)) and v127) then
							return v127;
						end
					end
					if (((5899 - (389 + 1138)) > (2424 - (102 + 472))) and ((v64 > (2 + 0)) or (v53.BeastCleave:IsAvailable() and (v64 > (1 + 0))))) then
						local v128 = 0 + 0;
						local v129;
						while true do
							if (((1777 - (320 + 1225)) < (1461 - 640)) and (v128 == (0 + 0))) then
								v129 = v83();
								if (((1982 - (157 + 1307)) < (2761 - (821 + 1038))) and v129) then
									return v129;
								end
								break;
							end
						end
					end
					if (((7469 - 4475) > (94 + 764)) and not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53.MendPet:IsCastable() and (v17:HealthPercentage() < v46) and v45) then
						if (v26(v53.MendPet) or ((6669 - 2914) <= (341 + 574))) then
							return "Mend Pet Low Priority (w/ Target)";
						end
					end
				end
				if (((9780 - 5834) > (4769 - (834 + 192))) and not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53.MendPet:IsCastable() and (v17:HealthPercentage() < v46) and v45) then
					if (v26(v53.MendPet) or ((85 + 1250) >= (849 + 2457))) then
						return "Mend Pet Low Priority (w/o Target)";
					end
				end
				break;
			end
			if (((104 + 4740) > (3490 - 1237)) and (v111 == (307 - (300 + 4)))) then
				if (((121 + 331) == (1183 - 731)) and (v51.TargetIsValid() or v13:AffectingCombat())) then
					v60 = v10.BossFightRemains();
					v61 = v60;
					if ((v61 == (11473 - (112 + 250))) or ((1817 + 2740) < (5228 - 3141))) then
						v61 = v10.FightRemains(v62, false);
					end
				end
				if (((2220 + 1654) == (2004 + 1870)) and v53.Exhilaration:IsCastable() and v53.Exhilaration:IsReady() and (v13:HealthPercentage() <= v48)) then
					if (v26(v53.Exhilaration) or ((1450 + 488) > (2447 + 2488))) then
						return "Exhilaration";
					end
				end
				if (((v13:HealthPercentage() <= v37) and v36 and v55.Healthstone:IsReady() and v55.Healthstone:IsUsable()) or ((3161 + 1094) < (4837 - (1001 + 413)))) then
					if (((3242 - 1788) <= (3373 - (244 + 638))) and v26(v57.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				if (not (v13:IsMounted() or v13:IsInVehicle()) or ((4850 - (627 + 66)) <= (8351 - 5548))) then
					local v122 = 602 - (512 + 90);
					while true do
						if (((6759 - (1665 + 241)) >= (3699 - (373 + 344))) and (v122 == (0 + 0))) then
							if (((1094 + 3040) > (8854 - 5497)) and v53.SummonPet:IsCastable() and v41) then
								if (v26(v54[v42]) or ((5782 - 2365) < (3633 - (35 + 1064)))) then
									return "Summon Pet";
								end
							end
							if ((v53.RevivePet:IsCastable() and v44 and v17:IsDeadOrGhost()) or ((1981 + 741) <= (350 - 186))) then
								if (v26(v53.RevivePet) or ((10 + 2398) < (3345 - (298 + 938)))) then
									return "Revive Pet";
								end
							end
							v122 = 1260 - (233 + 1026);
						end
						if ((v122 == (1667 - (636 + 1030))) or ((17 + 16) == (1422 + 33))) then
							if ((v53.MendPet:IsCastable() and v45 and (v17:HealthPercentage() < v46)) or ((132 + 311) >= (272 + 3743))) then
								if (((3603 - (55 + 166)) > (33 + 133)) and v26(v53.MendPet)) then
									return "Mend Pet High Priority";
								end
							end
							break;
						end
					end
				end
				v111 = 1 + 3;
			end
			if ((v111 == (0 - 0)) or ((577 - (36 + 261)) == (5349 - 2290))) then
				v50();
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				v111 = 1369 - (34 + 1334);
			end
			if (((724 + 1157) > (1005 + 288)) and (v111 == (1285 - (1035 + 248)))) then
				v65 = v14:IsInRange(61 - (20 + 1));
				v66 = v14:IsInRange(16 + 14);
				v67 = (v113 and v14:IsSpellInActionRange(v113)) or v14:IsInRange(349 - (134 + 185));
				v59 = v13:GCD() + (1133.15 - (549 + 584));
				v111 = 688 - (314 + 371);
			end
			if (((8091 - 5734) == (3325 - (478 + 490))) and (v111 == (1 + 0))) then
				if (((1295 - (786 + 386)) == (398 - 275)) and v53.Stomp:IsAvailable()) then
					v10.SplashEnemies.ChangeFriendTargetsTracking("Mine Only");
				else
					v10.SplashEnemies.ChangeFriendTargetsTracking("All");
				end
				v112 = (v53.BloodBolt:IsPetKnown() and v20.FindBySpellID(v53.BloodBolt:ID()) and v53.BloodBolt) or (v53.Bite:IsPetKnown() and v20.FindBySpellID(v53.Bite:ID()) and v53.Bite) or (v53.Claw:IsPetKnown() and v20.FindBySpellID(v53.Claw:ID()) and v53.Claw) or (v53.Smack:IsPetKnown() and v20.FindBySpellID(v53.Smack:ID()) and v53.Smack) or nil;
				v113 = (v53.Growl:IsPetKnown() and v20.FindBySpellID(v53.Growl:ID()) and v53.Growl) or nil;
				if (v23() or ((2435 - (1055 + 324)) >= (4732 - (1093 + 247)))) then
					local v123 = 0 + 0;
					while true do
						if ((v123 == (0 + 0)) or ((4291 - 3210) < (3648 - 2573))) then
							v62 = v13:GetEnemiesInRange(113 - 73);
							v63 = (v112 and v13:GetEnemiesInSpellActionRange(v112)) or v14:GetEnemiesInSplashRange(19 - 11);
							v123 = 1 + 0;
						end
						if ((v123 == (3 - 2)) or ((3615 - 2566) >= (3342 + 1090))) then
							v64 = (v112 and #v63) or v14:GetEnemiesInSplashRangeCount(20 - 12);
							break;
						end
					end
				else
					local v124 = 688 - (364 + 324);
					while true do
						if ((v124 == (2 - 1)) or ((11441 - 6673) <= (281 + 565))) then
							v64 = 0 - 0;
							break;
						end
						if (((0 - 0) == v124) or ((10198 - 6840) <= (2688 - (1249 + 19)))) then
							v62 = {};
							v63 = v14 or {};
							v124 = 1 + 0;
						end
					end
				end
				v111 = 7 - 5;
			end
		end
	end
	local function v87()
		v10.Print("Beast Mastery by Epic. Supported by Gojira");
		local v114 = (v53.Growl:IsPetKnown() and v20.FindBySpellID(v53.Growl:ID()) and v53.Growl) or nil;
		if (not v114 or ((4825 - (686 + 400)) <= (2358 + 647))) then
			v10.Print("|cffffff00Info|r: Add pet abilities to your action bars to improve range checks.");
		end
	end
	v10.SetAPL(482 - (73 + 156), v86, v87);
end;
return v0["Epix_Hunter_BeastMastery.lua"]();

