local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1790 - (573 + 1217))) or ((9208 - 5883) > (351 + 4262))) then
			v6 = v0[v4];
			if (not v6 or ((7976 - 3026) <= (5492 - (714 + 225)))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
		if (((3714 - 1049) <= (426 + 3507)) and (v5 == (1 - 0))) then
			return v6(...);
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
		local v88 = 806 - (118 + 688);
		while true do
			if (((3321 - (25 + 23)) == (634 + 2639)) and (v88 == (1889 - (927 + 959)))) then
				v44 = EpicSettings.Settings['UseRevive'];
				v45 = EpicSettings.Settings['UseMendPet'];
				v46 = EpicSettings.Settings['MendPetHP'] or (0 - 0);
				v47 = EpicSettings.Settings['UseExhilaration'];
				v88 = 736 - (16 + 716);
			end
			if (((7381 - 3557) > (506 - (11 + 86))) and (v88 == (9 - 5))) then
				v48 = EpicSettings.Settings['ExhilarationHP'] or (285 - (175 + 110));
				v49 = EpicSettings.Settings['UseTranq'];
				break;
			end
			if (((5269 - 3182) == (10293 - 8206)) and (v88 == (1797 - (503 + 1293)))) then
				v36 = EpicSettings.Settings['UseHealthstone'];
				v37 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v38 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v39 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (1061 - (810 + 251));
				v88 = 2 + 0;
			end
			if ((v88 == (0 + 0)) or ((3069 + 335) > (5036 - (43 + 490)))) then
				v31 = EpicSettings.Settings['UseRacials'];
				v33 = EpicSettings.Settings['UseHealingPotion'];
				v34 = EpicSettings.Settings['HealingPotionName'] or (733 - (711 + 22));
				v35 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v88 = 860 - (240 + 619);
			end
			if ((v88 == (1 + 1)) or ((5576 - 2070) <= (87 + 1222))) then
				v40 = EpicSettings.Settings['InterruptThreshold'] or (1744 - (1344 + 400));
				v41 = EpicSettings.Settings['UsePet'];
				v42 = EpicSettings.Settings['SummonPetSlot'] or (405 - (255 + 150));
				v43 = EpicSettings.Settings['UseSteelTrap'];
				v88 = 3 + 0;
			end
		end
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
	local v60 = 13520 - 2409;
	local v61 = 7363 + 3748;
	v10:RegisterForEvent(function()
		local v89 = 0 + 0;
		while true do
			if (((3292 - (10 + 327)) == (2058 + 897)) and (v89 == (338 - (118 + 220)))) then
				v60 = 3703 + 7408;
				v61 = 11560 - (108 + 341);
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
	local function v69(v90)
		return (v90:DebuffRemains(v53.BarbedShotDebuff));
	end
	local function v70(v91)
		return (v91:DebuffStack(v53.LatentPoisonDebuff));
	end
	local function v71(v92)
		return (v92:DebuffRemains(v53.SerpentStingDebuff));
	end
	local function v72(v93)
		return (v93:DebuffStack(v53.LatentPoisonDebuff) > (478 - (270 + 199))) and ((v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + 0.25 + 0))) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < ((1831 - (580 + 1239)) + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < (8 - 5)) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp())) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown()));
	end
	local function v73(v94)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + 0.25 + 0))) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < (1 + 11 + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < (2 + 1)) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp())) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown());
	end
	local function v74(v95)
		return (v95:DebuffStack(v53.LatentPoisonDebuff) > (22 - 13)) and (v13:BuffUp(v53.CalloftheWildBuff) or (v61 < (6 + 3)) or (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1168.2 - (645 + 522)))) or v53.Savagery:IsAvailable());
	end
	local function v75(v96)
		return v13:BuffUp(v53.CalloftheWildBuff) or (v61 < (1799 - (1010 + 780))) or (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1.2 + 0))) or v53.Savagery:IsAvailable();
	end
	local function v76(v97)
		return v97:DebuffRefreshable(v53.SerpentStingDebuff) and (v97:TimeToDie() > v53.SerpentStingDebuff:BaseDuration());
	end
	local function v77(v98)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + (0.25 - 0)))) or (v53.ScentofBlood:IsAvailable() and (v17:BuffStack(v53.FrenzyPetBuff) < (8 - 5)) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp()));
	end
	local function v78(v99)
		return (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1837.4 - (1045 + 791)))) or v13:BuffUp(v53.CalloftheWildBuff) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown()) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < ((30 - 18) + v59))) or v53.Savagery:IsAvailable() or (v61 < (13 - 4));
	end
	local function v79(v100)
		return v100:DebuffRefreshable(v53.SerpentStingDebuff) and (v14:TimeToDie() > v53.SerpentStingDebuff:BaseDuration());
	end
	local function v80()
		if ((v15:Exists() and v53.Misdirection:IsReady()) or ((3408 - (351 + 154)) == (3069 - (1281 + 293)))) then
			if (((4812 - (28 + 238)) >= (5083 - 2808)) and v26(v57.MisdirectionFocus)) then
				return "misdirection precombat 0";
			end
		end
		if (((2378 - (1381 + 178)) >= (21 + 1)) and v53.SteelTrap:IsCastable() and not v53.WailingArrow:IsAvailable() and v53.SteelTrap:IsAvailable()) then
			if (((2550 + 612) == (1349 + 1813)) and v26(v53.SteelTrap)) then
				return "steel_trap precombat 2";
			end
		end
		if ((v53.BarbedShot:IsCastable() and (v53.BarbedShot:Charges() >= (6 - 4))) or ((1228 + 1141) > (4899 - (381 + 89)))) then
			if (((3632 + 463) >= (2153 + 1030)) and v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot))) then
				return "barbed_shot precombat 8";
			end
		end
		if (v53.KillShot:IsReady() or ((6356 - 2645) < (2164 - (1074 + 82)))) then
			if (v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot)) or ((2298 - 1249) <= (2690 - (214 + 1570)))) then
				return "kill_shot precombat 10";
			end
		end
		if (((5968 - (990 + 465)) > (1124 + 1602)) and v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (9 + 11))) then
			if (v26(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot)) or ((1441 + 40) >= (10460 - 7802))) then
				return "kill_shot_mouseover precombat 11";
			end
		end
		if (v53.KillCommand:IsReady() or ((4946 - (1668 + 58)) == (1990 - (512 + 114)))) then
			if (v26(v57.KillCommandPetAttack) or ((2747 - 1693) > (7012 - 3620))) then
				return "kill_command precombat 12";
			end
		end
		if ((v64 > (3 - 2)) or ((315 + 361) >= (308 + 1334))) then
			if (((3596 + 540) > (8084 - 5687)) and v53.MultiShot:IsReady()) then
				if (v26(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot)) or ((6328 - (109 + 1885)) == (5714 - (1269 + 200)))) then
					return "multishot precombat 14";
				end
			end
		elseif (v53.CobraShot:IsReady() or ((8195 - 3919) <= (3846 - (98 + 717)))) then
			if (v26(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot)) or ((5608 - (802 + 24)) <= (2067 - 868))) then
				return "cobra_shot precombat 16";
			end
		end
	end
	local function v81()
		if ((v53.Berserking:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (15 - 2)))) or ((719 + 4145) < (1462 + 440))) then
			if (((795 + 4044) >= (799 + 2901)) and v26(v53.Berserking)) then
				return "berserking cds 2";
			end
		end
		if ((v53.BloodFury:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (44 - 28)))) or ((3584 - 2509) > (687 + 1231))) then
			if (((162 + 234) <= (3138 + 666)) and v26(v53.BloodFury)) then
				return "blood_fury cds 8";
			end
		end
		if ((v53.AncestralCall:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (12 + 4)))) or ((1947 + 2222) == (3620 - (797 + 636)))) then
			if (((6826 - 5420) == (3025 - (1427 + 192))) and v26(v53.AncestralCall)) then
				return "ancestral_call cds 10";
			end
		end
		if (((531 + 1000) < (9916 - 5645)) and v53.Fireblood:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (9 + 0)))) then
			if (((288 + 347) == (961 - (192 + 134))) and v26(v53.Fireblood)) then
				return "fireblood cds 12";
			end
		end
	end
	local function v82()
		local v101 = 1276 - (316 + 960);
		local v102;
		while true do
			if (((1878 + 1495) <= (2745 + 811)) and (v101 == (0 + 0))) then
				v102 = v51.HandleTopTrinket(v56, v29, 152 - 112, nil);
				if (v102 or ((3842 - (83 + 468)) < (5086 - (1202 + 604)))) then
					return v102;
				end
				v101 = 4 - 3;
			end
			if (((7299 - 2913) >= (2417 - 1544)) and (v101 == (326 - (45 + 280)))) then
				v102 = v51.HandleBottomTrinket(v56, v29, 39 + 1, nil);
				if (((805 + 116) <= (403 + 699)) and v102) then
					return v102;
				end
				break;
			end
		end
	end
	local function v83()
		if (((2605 + 2101) >= (170 + 793)) and v53.BarbedShot:IsCastable()) then
			if (v51.CastTargetIf(v53.BarbedShot, v62, "max", v70, v72, not v14:IsSpellInRange(v53.BarbedShot)) or ((1777 - 817) <= (2787 - (340 + 1571)))) then
				return "barbed_shot cleave 2";
			end
		end
		if (v53.BarbedShot:IsCastable() or ((815 + 1251) == (2704 - (1733 + 39)))) then
			if (((13258 - 8433) < (5877 - (125 + 909))) and v51.CastTargetIf(v53.BarbedShot, v62, "min", v69, v73, not v14:IsSpellInRange(v53.BarbedShot))) then
				return "barbed_shot cleave 4";
			end
		end
		if ((v53.MultiShot:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < ((1948.25 - (1096 + 852)) + v59)) and (not v53.BloodyFrenzy:IsAvailable() or v53.CalloftheWild:CooldownDown())) or ((1740 + 2137) >= (6479 - 1942))) then
			if (v26(v53.MultiShot, nil, nil, not v14:IsSpellInRange(v53.MultiShot)) or ((4186 + 129) < (2238 - (409 + 103)))) then
				return "multishot cleave 6";
			end
		end
		if ((v53.BestialWrath:IsCastable() and v29) or ((3915 - (46 + 190)) < (720 - (51 + 44)))) then
			if (v26(v53.BestialWrath) or ((1305 + 3320) < (1949 - (1114 + 203)))) then
				return "bestial_wrath cleave 8";
			end
		end
		if ((v53.CalloftheWild:IsCastable() and v29) or ((809 - (228 + 498)) > (386 + 1394))) then
			if (((302 + 244) <= (1740 - (174 + 489))) and v25(v53.CalloftheWild)) then
				return "call_of_the_wild cleave 10";
			end
		end
		if ((v53.KillCommand:IsReady() and (v53.KillCleave:IsAvailable())) or ((2594 - 1598) > (6206 - (830 + 1075)))) then
			if (((4594 - (303 + 221)) > (1956 - (231 + 1038))) and v25(v53.KillCommand, nil, nil, not v14:IsInRange(42 + 8))) then
				return "kill_command cleave 12";
			end
		end
		if (v53.ExplosiveShot:IsReady() or ((1818 - (171 + 991)) >= (13723 - 10393))) then
			if (v26(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot)) or ((6691 - 4199) <= (835 - 500))) then
				return "explosive_shot cleave 12";
			end
		end
		if (((3460 + 862) >= (8980 - 6418)) and v53.Stampede:IsCastable() and v29) then
			if (v26(v53.Stampede, not v14:IsSpellInRange(v53.Stampede)) or ((10491 - 6854) >= (6077 - 2307))) then
				return "stampede cleave 14";
			end
		end
		if (v53.Bloodshed:IsCastable() or ((7353 - 4974) > (5826 - (111 + 1137)))) then
			if (v26(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed)) or ((641 - (91 + 67)) > (2211 - 1468))) then
				return "bloodshed cleave 16";
			end
		end
		if (((613 + 1841) > (1101 - (423 + 100))) and v53.DeathChakram:IsCastable() and v29) then
			if (((7 + 923) < (12343 - 7885)) and v26(v53.DeathChakram, not v14:IsSpellInRange(v53.DeathChakram))) then
				return "death_chakram cleave 18";
			end
		end
		if (((346 + 316) <= (1743 - (326 + 445))) and v53.SteelTrap:IsCastable()) then
			if (((19070 - 14700) == (9735 - 5365)) and v26(v57.SteelTrap)) then
				return "steel_trap cleave 22";
			end
		end
		if ((v53.AMurderofCrows:IsReady() and v29) or ((11115 - 6353) <= (1572 - (530 + 181)))) then
			if (v26(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows)) or ((2293 - (614 + 267)) == (4296 - (19 + 13)))) then
				return "a_murder_of_crows cleave 24";
			end
		end
		if (v53.BarbedShot:IsCastable() or ((5155 - 1987) < (5016 - 2863))) then
			if (v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "max", v70, v74, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover) or ((14214 - 9238) < (346 + 986))) then
				return "barbed_shot cleave 26";
			end
		end
		if (((8138 - 3510) == (9597 - 4969)) and v53.BarbedShot:IsCastable()) then
			if (v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v75, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover) or ((1866 - (1293 + 519)) == (805 - 410))) then
				return "barbed_shot cleave 28";
			end
		end
		if (((213 - 131) == (156 - 74)) and v53.KillCommand:IsReady()) then
			if (v26(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand)) or ((2505 - 1924) < (664 - 382))) then
				return "kill_command cleave 30";
			end
		end
		if (v53.DireBeast:IsCastable() or ((2442 + 2167) < (510 + 1985))) then
			if (((2676 - 1524) == (267 + 885)) and v26(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast))) then
				return "dire_beast cleave 32";
			end
		end
		if (((630 + 1266) <= (2139 + 1283)) and v53.SerpentSting:IsReady()) then
			if (v51.CastTargetIf(v53.SerpentSting, v62, "min", v71, v76, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover) or ((2086 - (709 + 387)) > (3478 - (673 + 1185)))) then
				return "serpent_sting cleave 34";
			end
		end
		if ((v53.Barrage:IsReady() and (v17:BuffRemains(v53.FrenzyPetBuff) > v53.Barrage:ExecuteTime())) or ((2543 - 1666) > (15076 - 10381))) then
			if (((4427 - 1736) >= (1324 + 527)) and v26(v53.Barrage, not v14:IsSpellInRange(v53.Barrage))) then
				return "barrage cleave 36";
			end
		end
		if ((v53.MultiShot:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < (v13:GCD() * (2 + 0)))) or ((4029 - 1044) >= (1193 + 3663))) then
			if (((8525 - 4249) >= (2345 - 1150)) and v26(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot))) then
				return "multishot cleave 38";
			end
		end
		if (((5112 - (446 + 1434)) <= (5973 - (1040 + 243))) and v53.AspectoftheWild:IsCastable() and v29) then
			if (v26(v53.AspectoftheWild) or ((2674 - 1778) >= (4993 - (559 + 1288)))) then
				return "aspect_of_the_wild cleave 40";
			end
		end
		if (((4992 - (609 + 1322)) >= (3412 - (13 + 441))) and v29 and v53.LightsJudgment:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v14:TimeToDie() < (18 - 13)))) then
			if (((8347 - 5160) >= (3207 - 2563)) and v25(v53.LightsJudgment, nil, not v14:IsInRange(1 + 4))) then
				return "lights_judgment cleave 40";
			end
		end
		if (((2338 - 1694) <= (251 + 453)) and v53.KillShot:IsReady()) then
			if (((420 + 538) > (2810 - 1863)) and v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot))) then
				return "kill_shot cleave 38";
			end
		end
		if (((2459 + 2033) >= (4881 - 2227)) and v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (14 + 6))) then
			if (((1915 + 1527) >= (1080 + 423)) and v26(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot))) then
				return "kill_shot_mouseover cleave 39";
			end
		end
		if ((v53.CobraShot:IsReady() and (v13:FocusTimeToMax() < (v59 * (2 + 0)))) or ((3102 + 68) <= (1897 - (153 + 280)))) then
			if (v26(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot)) or ((13851 - 9054) == (3940 + 448))) then
				return "cobra_shot cleave 42";
			end
		end
		if (((218 + 333) <= (357 + 324)) and v53.WailingArrow:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53.WailingArrow:ExecuteTime()) or (v61 < (5 + 0)))) then
			if (((2375 + 902) > (618 - 211)) and v26(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow))) then
				return "wailing_arrow cleave 44";
			end
		end
		if (((2902 + 1793) >= (2082 - (89 + 578))) and v53.BagofTricks:IsCastable() and v29 and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (4 + 1)))) then
			if (v26(v53.BagofTricks) or ((6677 - 3465) <= (1993 - (572 + 477)))) then
				return "bag_of_tricks cleave 46";
			end
		end
		if ((v53.ArcaneTorrent:IsCastable() and v29 and ((v13:Focus() + v13:FocusRegen() + 5 + 25) < v13:FocusMax())) or ((1858 + 1238) <= (215 + 1583))) then
			if (((3623 - (84 + 2)) == (5828 - 2291)) and v26(v53.ArcaneTorrent)) then
				return "arcane_torrent cleave 48";
			end
		end
	end
	local function v84()
		if (((2765 + 1072) >= (2412 - (497 + 345))) and v53.BarbedShot:IsCastable()) then
			if (v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v77, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover) or ((76 + 2874) == (645 + 3167))) then
				return "barbed_shot st 2";
			end
		end
		if (((6056 - (605 + 728)) >= (1654 + 664)) and v53.BarbedShot:IsCastable() and v77(v14)) then
			if (v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot)) or ((4506 - 2479) > (131 + 2721))) then
				return "barbed_shot st mt_backup 3";
			end
		end
		if ((v53.CalloftheWild:IsCastable() and v29) or ((4199 - 3063) > (3892 + 425))) then
			if (((13154 - 8406) == (3585 + 1163)) and v26(v53.CalloftheWild)) then
				return "call_of_the_wild st 6";
			end
		end
		if (((4225 - (457 + 32)) <= (2012 + 2728)) and v53.KillCommand:IsReady() and (v53.KillCommand:FullRechargeTime() < v59) and v53.AlphaPredator:IsAvailable()) then
			if (v26(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand)) or ((4792 - (832 + 570)) <= (2883 + 177))) then
				return "kill_command st 4";
			end
		end
		if ((v53.Stampede:IsCastable() and v29) or ((261 + 738) > (9529 - 6836))) then
			if (((224 + 239) < (1397 - (588 + 208))) and v25(v53.Stampede, nil, nil, not v14:IsSpellInRange(v53.Stampede))) then
				return "stampede st 8";
			end
		end
		if (v53.Bloodshed:IsCastable() or ((5883 - 3700) < (2487 - (884 + 916)))) then
			if (((9523 - 4974) == (2638 + 1911)) and v26(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed))) then
				return "bloodshed st 10";
			end
		end
		if (((5325 - (232 + 421)) == (6561 - (1569 + 320))) and v53.BestialWrath:IsCastable() and v29) then
			if (v26(v53.BestialWrath) or ((900 + 2768) < (76 + 319))) then
				return "bestial_wrath st 12";
			end
		end
		if ((v53.DeathChakram:IsCastable() and v29) or ((14038 - 9872) == (1060 - (316 + 289)))) then
			if (v25(v53.DeathChakram, nil, nil, not v14:IsSpellInRange(v53.DeathChakram)) or ((11645 - 7196) == (123 + 2540))) then
				return "death_chakram st 14";
			end
		end
		if (v53.KillCommand:IsReady() or ((5730 - (666 + 787)) < (3414 - (360 + 65)))) then
			if (v26(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand)) or ((814 + 56) >= (4403 - (79 + 175)))) then
				return "kill_command st 22";
			end
		end
		if (((3487 - 1275) < (2484 + 699)) and v53.AMurderofCrows:IsCastable() and v29) then
			if (((14240 - 9594) > (5761 - 2769)) and v26(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows))) then
				return "a_murder_of_crows st 14";
			end
		end
		if (((2333 - (503 + 396)) < (3287 - (92 + 89))) and v53.SteelTrap:IsCastable()) then
			if (((1524 - 738) < (1551 + 1472)) and v26(v53.SteelTrap)) then
				return "steel_trap st 16";
			end
		end
		if (v53.ExplosiveShot:IsReady() or ((1446 + 996) < (289 - 215))) then
			if (((621 + 3914) == (10340 - 5805)) and v26(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot))) then
				return "explosive_shot st 18";
			end
		end
		if (v53.BarbedShot:IsCastable() or ((2626 + 383) <= (1006 + 1099))) then
			if (((5573 - 3743) < (458 + 3211)) and v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v78, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
				return "barbed_shot st 24";
			end
		end
		if ((v53.BarbedShot:IsCastable() and v78(v14)) or ((2180 - 750) >= (4856 - (485 + 759)))) then
			if (((6207 - 3524) >= (3649 - (442 + 747))) and v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot))) then
				return "barbed_shot st mt_backup 25";
			end
		end
		if (v53.DireBeast:IsCastable() or ((2939 - (832 + 303)) >= (4221 - (88 + 858)))) then
			if (v26(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast)) or ((432 + 985) > (3004 + 625))) then
				return "dire_beast st 26";
			end
		end
		if (((198 + 4597) > (1191 - (766 + 23))) and v53.SerpentSting:IsReady()) then
			if (((23760 - 18947) > (4875 - 1310)) and v51.CastTargetIf(v53.SerpentSting, v62, "min", v71, v79, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover)) then
				return "serpent_sting st 28";
			end
		end
		if (((10306 - 6394) == (13277 - 9365)) and v53.KillShot:IsReady()) then
			if (((3894 - (1036 + 37)) <= (3421 + 1403)) and v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot))) then
				return "kill_shot st 30";
			end
		end
		if (((3384 - 1646) <= (1727 + 468)) and v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (1500 - (641 + 839)))) then
			if (((954 - (910 + 3)) <= (7693 - 4675)) and v26(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot))) then
				return "kill_shot_mouseover st 31";
			end
		end
		if (((3829 - (1466 + 218)) <= (1887 + 2217)) and v53.AspectoftheWild:IsCastable() and v29) then
			if (((3837 - (556 + 592)) < (1723 + 3122)) and v26(v53.AspectoftheWild)) then
				return "aspect_of_the_wild st 32";
			end
		end
		if (v53.CobraShot:IsReady() or ((3130 - (329 + 479)) > (3476 - (174 + 680)))) then
			if (v26(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot)) or ((15579 - 11045) == (4315 - 2233))) then
				return "cobra_shot st 34";
			end
		end
		if ((v53.WailingArrow:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53.WailingArrow:ExecuteTime()) or (v61 < (4 + 1)))) or ((2310 - (396 + 343)) > (166 + 1701))) then
			if (v26(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow), true) or ((4131 - (29 + 1448)) >= (4385 - (135 + 1254)))) then
				return "wailing_arrow st 36";
			end
		end
		if (((14985 - 11007) > (9823 - 7719)) and v29) then
			local v110 = 0 + 0;
			while true do
				if (((4522 - (389 + 1138)) > (2115 - (102 + 472))) and ((1 + 0) == v110)) then
					if (((1802 + 1447) > (889 + 64)) and v53.ArcaneTorrent:IsCastable() and ((v13:Focus() + v13:FocusRegen() + (1560 - (320 + 1225))) < v13:FocusMax())) then
						if (v26(v53.ArcaneTorrent) or ((5826 - 2553) > (2799 + 1774))) then
							return "arcane_torrent st 42";
						end
					end
					break;
				end
				if (((1464 - (157 + 1307)) == v110) or ((5010 - (821 + 1038)) < (3203 - 1919))) then
					if ((v53.BagofTricks:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (1 + 4)))) or ((3286 - 1436) == (569 + 960))) then
						if (((2034 - 1213) < (3149 - (834 + 192))) and v26(v53.BagofTricks)) then
							return "bag_of_tricks st 38";
						end
					end
					if (((58 + 844) < (597 + 1728)) and v53.ArcanePulse:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (1 + 4)))) then
						if (((1329 - 471) <= (3266 - (300 + 4))) and v26(v53.ArcanePulse)) then
							return "arcane_pulse st 40";
						end
					end
					v110 = 1 + 0;
				end
			end
		end
	end
	local function v85()
		if ((not v13:IsCasting() and not v13:IsChanneling()) or ((10329 - 6383) < (1650 - (112 + 250)))) then
			local v111 = 0 + 0;
			local v112;
			while true do
				if ((v111 == (2 - 1)) or ((1858 + 1384) == (294 + 273))) then
					v112 = v51.InterruptWithStun(v53.Intimidation, 30 + 10);
					if (v112 or ((420 + 427) >= (939 + 324))) then
						return v112;
					end
					break;
				end
				if ((v111 == (1414 - (1001 + 413))) or ((5023 - 2770) == (2733 - (244 + 638)))) then
					v112 = v51.Interrupt(v53.CounterShot, 733 - (627 + 66), true);
					if (v112 or ((6218 - 4131) > (2974 - (512 + 90)))) then
						return v112;
					end
					v111 = 1907 - (1665 + 241);
				end
			end
		end
	end
	local function v86()
		v50();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		if (v53.Stomp:IsAvailable() or ((5162 - (373 + 344)) < (1872 + 2277))) then
			v10.SplashEnemies.ChangeFriendTargetsTracking("Mine Only");
		else
			v10.SplashEnemies.ChangeFriendTargetsTracking("All");
		end
		local v106 = (v53.BloodBolt:IsPetKnown() and v20.FindBySpellID(v53.BloodBolt:ID()) and v53.BloodBolt) or (v53.Bite:IsPetKnown() and v20.FindBySpellID(v53.Bite:ID()) and v53.Bite) or (v53.Claw:IsPetKnown() and v20.FindBySpellID(v53.Claw:ID()) and v53.Claw) or (v53.Smack:IsPetKnown() and v20.FindBySpellID(v53.Smack:ID()) and v53.Smack) or nil;
		local v107 = (v53.Growl:IsPetKnown() and v20.FindBySpellID(v53.Growl:ID()) and v53.Growl) or nil;
		if (v28 or ((482 + 1336) == (224 - 139))) then
			v62 = v13:GetEnemiesInRange(67 - 27);
			v63 = (v106 and v13:GetEnemiesInSpellActionRange(v106)) or v14:GetEnemiesInSplashRange(1107 - (35 + 1064));
			v64 = (v106 and #v63) or v14:GetEnemiesInSplashRangeCount(6 + 2);
		else
			local v113 = 0 - 0;
			while true do
				if (((3 + 627) < (3363 - (298 + 938))) and (v113 == (1260 - (233 + 1026)))) then
					v64 = 1666 - (636 + 1030);
					break;
				end
				if (((0 + 0) == v113) or ((1893 + 45) == (747 + 1767))) then
					v62 = {};
					v63 = v14 or {};
					v113 = 1 + 0;
				end
			end
		end
		v65 = v14:IsInRange(261 - (55 + 166));
		v66 = v14:IsInRange(6 + 24);
		v67 = (v107 and v14:IsSpellInActionRange(v107)) or v14:IsInRange(4 + 26);
		v59 = v13:GCD() + (0.15 - 0);
		if (((4552 - (36 + 261)) >= (95 - 40)) and (v51.TargetIsValid() or v13:AffectingCombat())) then
			local v114 = 1368 - (34 + 1334);
			while true do
				if (((1153 + 1846) > (899 + 257)) and (v114 == (1283 - (1035 + 248)))) then
					v60 = v10.BossFightRemains();
					v61 = v60;
					v114 = 22 - (20 + 1);
				end
				if (((1225 + 1125) > (1474 - (134 + 185))) and (v114 == (1134 - (549 + 584)))) then
					if (((4714 - (314 + 371)) <= (16659 - 11806)) and (v61 == (12079 - (478 + 490)))) then
						v61 = v10.FightRemains(v62, false);
					end
					break;
				end
			end
		end
		if ((v53.Exhilaration:IsCastable() and v53.Exhilaration:IsReady() and (v13:HealthPercentage() <= v48)) or ((274 + 242) > (4606 - (786 + 386)))) then
			if (((13104 - 9058) >= (4412 - (1055 + 324))) and v26(v53.Exhilaration)) then
				return "Exhilaration";
			end
		end
		if (((v13:HealthPercentage() <= v37) and v36 and v55.Healthstone:IsReady() and v55.Healthstone:IsUsable()) or ((4059 - (1093 + 247)) <= (1286 + 161))) then
			if (v26(v57.Healthstone, nil, nil, true) or ((435 + 3699) < (15586 - 11660))) then
				return "healthstone defensive 3";
			end
		end
		if (not (v13:IsMounted() or v13:IsInVehicle()) or ((556 - 392) >= (7924 - 5139))) then
			if ((v53.SummonPet:IsCastable() and v41) or ((1319 - 794) == (751 + 1358))) then
				if (((126 - 93) == (113 - 80)) and v26(v54[v42])) then
					return "Summon Pet";
				end
			end
			if (((2303 + 751) <= (10268 - 6253)) and v53.RevivePet:IsCastable() and v44 and v17:IsDeadOrGhost()) then
				if (((2559 - (364 + 324)) < (9270 - 5888)) and v26(v53.RevivePet)) then
					return "Revive Pet";
				end
			end
			if (((3102 - 1809) <= (718 + 1448)) and v53.MendPet:IsCastable() and v45 and (v17:HealthPercentage() < v46)) then
				if (v26(v53.MendPet) or ((10791 - 8212) < (196 - 73))) then
					return "Mend Pet High Priority";
				end
			end
		end
		if (v51.TargetIsValid() or ((2569 - 1723) >= (3636 - (1249 + 19)))) then
			if ((not v13:AffectingCombat() and not v27) or ((3622 + 390) <= (13070 - 9712))) then
				local v126 = 1086 - (686 + 400);
				local v127;
				while true do
					if (((1173 + 321) <= (3234 - (73 + 156))) and (v126 == (0 + 0))) then
						v127 = v80();
						if (v127 or ((3922 - (721 + 90)) == (24 + 2110))) then
							return v127;
						end
						break;
					end
				end
			end
			local v115 = v85();
			if (((7646 - 5291) == (2825 - (224 + 246))) and v115) then
				return v115;
			end
			local v116 = v51.HandleDPSPotion();
			if (v116 or ((952 - 364) <= (795 - 363))) then
				return v116;
			end
			if (((871 + 3926) >= (93 + 3802)) and v29) then
				local v128 = 0 + 0;
				local v129;
				while true do
					if (((7111 - 3534) == (11903 - 8326)) and (v128 == (513 - (203 + 310)))) then
						v129 = v81();
						if (((5787 - (1238 + 755)) > (259 + 3434)) and v129) then
							return v129;
						end
						break;
					end
				end
			end
			local v115 = v82();
			if (v115 or ((2809 - (709 + 825)) == (7555 - 3455))) then
				return v115;
			end
			if ((v64 < (2 - 0)) or (not v53.BeastCleave:IsAvailable() and (v64 < (867 - (196 + 668)))) or ((6281 - 4690) >= (7415 - 3835))) then
				local v130 = v84();
				if (((1816 - (171 + 662)) <= (1901 - (4 + 89))) and v130) then
					return v130;
				end
			end
			if ((v64 > (6 - 4)) or (v53.BeastCleave:IsAvailable() and (v64 > (1 + 0))) or ((9443 - 7293) <= (470 + 727))) then
				local v131 = 1486 - (35 + 1451);
				local v132;
				while true do
					if (((5222 - (28 + 1425)) >= (3166 - (941 + 1052))) and (v131 == (0 + 0))) then
						v132 = v83();
						if (((2999 - (822 + 692)) == (2119 - 634)) and v132) then
							return v132;
						end
						break;
					end
				end
			end
			if ((not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53.MendPet:IsCastable() and (v17:HealthPercentage() < v46) and v45) or ((1562 + 1753) <= (3079 - (45 + 252)))) then
				if (v26(v53.MendPet) or ((867 + 9) >= (1021 + 1943))) then
					return "Mend Pet Low Priority (w/ Target)";
				end
			end
		end
		if ((not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53.MendPet:IsCastable() and (v17:HealthPercentage() < v46) and v45) or ((5431 - 3199) > (2930 - (114 + 319)))) then
			if (v26(v53.MendPet) or ((3029 - 919) <= (425 - 93))) then
				return "Mend Pet Low Priority (w/o Target)";
			end
		end
	end
	local function v87()
		v10.Print("Beast Mastery by Epic. Supported by Gojira");
		local v108 = (v53.Growl:IsPetKnown() and v20.FindBySpellID(v53.Growl:ID()) and v53.Growl) or nil;
		if (((2350 + 1336) > (4725 - 1553)) and not v108) then
			v10.Print("|cffffff00Info|r: Add pet abilities to your action bars to improve range checks.");
		end
	end
	v10.SetAPL(529 - 276, v86, v87);
end;
return v0["Epix_Hunter_BeastMastery.lua"]();

