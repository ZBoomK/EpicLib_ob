local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((2491 + 671) <= (1843 + 1598)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((15199 - 10493) > (6168 - (404 + 1335))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 407 - (183 + 223);
		end
		if (((3472 - 618) < (2714 + 1381)) and (v5 == (1 + 0))) then
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
		v31 = EpicSettings.Settings['UseRacials'];
		v33 = EpicSettings.Settings['UseHealingPotion'];
		v34 = EpicSettings.Settings['HealingPotionName'] or (337 - (10 + 327));
		v35 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v36 = EpicSettings.Settings['UseHealthstone'];
		v37 = EpicSettings.Settings['HealthstoneHP'] or (338 - (118 + 220));
		v38 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
		v39 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (449 - (108 + 341));
		v40 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v41 = EpicSettings.Settings['UsePet'];
		v42 = EpicSettings.Settings['SummonPetSlot'] or (0 - 0);
		v43 = EpicSettings.Settings['UseSteelTrap'];
		v44 = EpicSettings.Settings['UseRevive'];
		v45 = EpicSettings.Settings['UseMendPet'];
		v46 = EpicSettings.Settings['MendPetHP'] or (1493 - (711 + 782));
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
	local v60 = 400 + 10711;
	local v61 = 4841 + 6270;
	v10:RegisterForEvent(function()
		v60 = 29010 - 17899;
		v61 = 6903 + 4208;
	end, "PLAYER_REGEN_ENABLED");
	local v62, v63, v64;
	local v65, v66;
	local v67;
	local v68 = {{v53.Intimidation,"Cast Intimidation (Interrupt)",function()
		return true;
	end}};
	local function v69(v97)
		return (v97:DebuffRemains(v53.BarbedShotDebuff));
	end
	local function v70(v98)
		return (v98:DebuffStack(v53.LatentPoisonDebuff));
	end
	local function v71(v99)
		return (v99:DebuffRemains(v53.SerpentStingDebuff));
	end
	local function v72(v100)
		return (v100:DebuffStack(v53.LatentPoisonDebuff) > (26 - 17)) and ((v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + (1836.25 - (1045 + 791))))) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < ((30 - 18) + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < (4 - 1)) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp())) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown()));
	end
	local function v73(v101)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + (505.25 - (351 + 154))))) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < ((1586 - (1281 + 293)) + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < (269 - (28 + 238))) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp())) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown());
	end
	local function v74(v102)
		return (v102:DebuffStack(v53.LatentPoisonDebuff) > (19 - 10)) and (v13:BuffUp(v53.CalloftheWildBuff) or (v61 < (1568 - (1381 + 178))) or (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1.2 + 0))) or v53.Savagery:IsAvailable());
	end
	local function v75(v103)
		return v13:BuffUp(v53.CalloftheWildBuff) or (v61 < (8 + 1)) or (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1.2 + 0))) or v53.Savagery:IsAvailable();
	end
	local function v76(v104)
		return v104:DebuffRefreshable(v53.SerpentStingDebuff) and (v104:TimeToDie() > v53.SerpentStingDebuff:BaseDuration());
	end
	local function v77(v105)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + (0.25 - 0)))) or (v53.ScentofBlood:IsAvailable() and (v17:BuffStack(v53.FrenzyPetBuff) < (2 + 1)) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp()));
	end
	local function v78(v106)
		return (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (471.4 - (381 + 89)))) or v13:BuffUp(v53.CalloftheWildBuff) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown()) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < (11 + 1 + v59))) or v53.Savagery:IsAvailable() or (v61 < (7 + 2));
	end
	local function v79(v107)
		return v107:DebuffRefreshable(v53.SerpentStingDebuff) and (v14:TimeToDie() > v53.SerpentStingDebuff:BaseDuration());
	end
	local function v80()
		if ((v15:Exists() and v53.Misdirection:IsReady()) or ((1812 - 754) >= (2358 - (1074 + 82)))) then
			if (((8132 - 4421) > (5139 - (214 + 1570))) and v26(v57.MisdirectionFocus)) then
				return "misdirection precombat 0";
			end
		end
		if ((v53.SteelTrap:IsCastable() and not v53.WailingArrow:IsAvailable() and v53.SteelTrap:IsAvailable()) or ((2361 - (990 + 465)) >= (919 + 1310))) then
			if (((561 + 727) > (1217 + 34)) and v26(v53.SteelTrap)) then
				return "steel_trap precombat 2";
			end
		end
		if ((v53.BarbedShot:IsCastable() and (v53.BarbedShot:Charges() >= (7 - 5))) or ((6239 - (1668 + 58)) < (3978 - (512 + 114)))) then
			if (v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot)) or ((5383 - 3318) >= (6606 - 3410))) then
				return "barbed_shot precombat 8";
			end
		end
		if (v53.KillShot:IsReady() or ((15226 - 10850) <= (689 + 792))) then
			if (v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot)) or ((635 + 2757) >= (4122 + 619))) then
				return "kill_shot precombat 10";
			end
		end
		if (((11215 - 7890) >= (4148 - (109 + 1885))) and v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (1489 - (1269 + 200)))) then
			if (v25(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot)) or ((2482 - 1187) >= (4048 - (98 + 717)))) then
				return "kill_shot_mouseover precombat 11";
			end
		end
		if (((5203 - (802 + 24)) > (2831 - 1189)) and v53.KillCommand:IsReady()) then
			if (((5964 - 1241) > (201 + 1155)) and v26(v57.KillCommandPetAttack)) then
				return "kill_command precombat 12";
			end
		end
		if ((v64 > (1 + 0)) or ((680 + 3456) <= (741 + 2692))) then
			if (((11809 - 7564) <= (15443 - 10812)) and v53.MultiShot:IsReady()) then
				if (((1530 + 2746) >= (1594 + 2320)) and v25(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot))) then
					return "multishot precombat 14";
				end
			end
		elseif (((164 + 34) <= (3174 + 1191)) and v53.CobraShot:IsReady()) then
			if (((2233 + 2549) > (6109 - (797 + 636))) and v25(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot))) then
				return "cobra_shot precombat 16";
			end
		end
	end
	local function v81()
		local v108 = 0 - 0;
		while true do
			if (((6483 - (1427 + 192)) > (762 + 1435)) and (v108 == (0 - 0))) then
				if ((v53.Berserking:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (12 + 1)))) or ((1677 + 2023) == (2833 - (192 + 134)))) then
					if (((5750 - (316 + 960)) >= (153 + 121)) and v26(v53.Berserking)) then
						return "berserking cds 2";
					end
				end
				if ((v53.BloodFury:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (13 + 3)))) or ((1751 + 143) <= (5374 - 3968))) then
					if (((2123 - (83 + 468)) >= (3337 - (1202 + 604))) and v26(v53.BloodFury)) then
						return "blood_fury cds 8";
					end
				end
				v108 = 4 - 3;
			end
			if ((v108 == (1 - 0)) or ((12976 - 8289) < (4867 - (45 + 280)))) then
				if (((3177 + 114) > (1457 + 210)) and v53.AncestralCall:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (6 + 10)))) then
					if (v26(v53.AncestralCall) or ((484 + 389) == (358 + 1676))) then
						return "ancestral_call cds 10";
					end
				end
				if ((v53.Fireblood:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (16 - 7)))) or ((4727 - (340 + 1571)) < (5 + 6))) then
					if (((5471 - (1733 + 39)) < (12931 - 8225)) and v26(v53.Fireblood)) then
						return "fireblood cds 12";
					end
				end
				break;
			end
		end
	end
	local function v82()
		local v109 = v51.HandleTopTrinket(v56, v29, 1074 - (125 + 909), nil);
		if (((4594 - (1096 + 852)) >= (393 + 483)) and v109) then
			return v109;
		end
		local v109 = v51.HandleBottomTrinket(v56, v29, 57 - 17, nil);
		if (((596 + 18) <= (3696 - (409 + 103))) and v109) then
			return v109;
		end
	end
	local function v83()
		local v110 = 236 - (46 + 190);
		while true do
			if (((3221 - (51 + 44)) == (882 + 2244)) and (v110 == (1321 - (1114 + 203)))) then
				if (v53.SerpentSting:IsReady() or ((2913 - (228 + 498)) >= (1074 + 3880))) then
					if (v51.CastTargetIf(v53.SerpentSting, v62, "min", v71, v76, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover) or ((2142 + 1735) == (4238 - (174 + 489)))) then
						return "serpent_sting cleave 34";
					end
				end
				if (((1841 - 1134) > (2537 - (830 + 1075))) and v53.Barrage:IsReady() and (v17:BuffRemains(v53.FrenzyPetBuff) > v53.Barrage:ExecuteTime())) then
					if (v25(v53.Barrage, not v14:IsSpellInRange(v53.Barrage)) or ((1070 - (303 + 221)) >= (3953 - (231 + 1038)))) then
						return "barrage cleave 36";
					end
				end
				if (((1221 + 244) <= (5463 - (171 + 991))) and v53.MultiShot:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < (v13:GCD() * (12 - 9)))) then
					if (((4575 - 2871) > (3556 - 2131)) and v25(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot))) then
						return "multishot cleave 38";
					end
				end
				if ((v53.AspectoftheWild:IsCastable() and v29) or ((550 + 137) == (14841 - 10607))) then
					if (v26(v53.AspectoftheWild) or ((9606 - 6276) < (2302 - 873))) then
						return "aspect_of_the_wild cleave 40";
					end
				end
				v110 = 15 - 10;
			end
			if (((2395 - (111 + 1137)) >= (493 - (91 + 67))) and (v110 == (14 - 9))) then
				if (((858 + 2577) > (2620 - (423 + 100))) and v29 and v53.LightsJudgment:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v14:TimeToDie() < (1 + 4)))) then
					if (v25(v53.LightsJudgment, nil, not v14:IsInRange(13 - 8)) or ((1966 + 1804) >= (4812 - (326 + 445)))) then
						return "lights_judgment cleave 40";
					end
				end
				if (v53.KillShot:IsReady() or ((16543 - 12752) <= (3588 - 1977))) then
					if (v25(v53.KillShot, not v14:IsSpellInRange(v53.KillShot)) or ((10685 - 6107) <= (2719 - (530 + 181)))) then
						return "kill_shot cleave 38";
					end
				end
				if (((2006 - (614 + 267)) <= (2108 - (19 + 13))) and v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (32 - 12))) then
					if (v25(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot)) or ((1730 - 987) >= (12566 - 8167))) then
						return "kill_shot_mouseover cleave 39";
					end
				end
				if (((300 + 855) < (2941 - 1268)) and v53.CobraShot:IsReady() and (v13:FocusTimeToMax() < (v59 * (3 - 1)))) then
					if (v25(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot)) or ((4136 - (1293 + 519)) <= (1179 - 601))) then
						return "cobra_shot cleave 42";
					end
				end
				v110 = 15 - 9;
			end
			if (((7203 - 3436) == (16243 - 12476)) and (v110 == (4 - 2))) then
				if (((2166 + 1923) == (835 + 3254)) and v53.Bloodshed:IsCastable()) then
					if (((10357 - 5899) >= (387 + 1287)) and v25(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed))) then
						return "bloodshed cleave 16";
					end
				end
				if (((323 + 649) <= (887 + 531)) and v53.DeathChakram:IsCastable() and v29) then
					if (v25(v53.DeathChakram, not v14:IsSpellInRange(v53.DeathChakram)) or ((6034 - (709 + 387)) < (6620 - (673 + 1185)))) then
						return "death_chakram cleave 18";
					end
				end
				if (v53.SteelTrap:IsCastable() or ((7261 - 4757) > (13692 - 9428))) then
					if (((3542 - 1389) == (1540 + 613)) and v26(v57.SteelTrap)) then
						return "steel_trap cleave 22";
					end
				end
				if ((v53.AMurderofCrows:IsReady() and v29) or ((379 + 128) >= (3497 - 906))) then
					if (((1101 + 3380) == (8934 - 4453)) and v25(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows))) then
						return "a_murder_of_crows cleave 24";
					end
				end
				v110 = 5 - 2;
			end
			if ((v110 == (1886 - (446 + 1434))) or ((3611 - (1040 + 243)) < (2068 - 1375))) then
				if (((6175 - (559 + 1288)) == (6259 - (609 + 1322))) and v53.WailingArrow:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53.WailingArrow:ExecuteTime()) or (v61 < (459 - (13 + 441))))) then
					if (((5933 - 4345) >= (3488 - 2156)) and v25(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow))) then
						return "wailing_arrow cleave 44";
					end
				end
				if ((v53.BagofTricks:IsCastable() and v29 and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (24 - 19)))) or ((156 + 4018) > (15427 - 11179))) then
					if (v26(v53.BagofTricks) or ((1629 + 2957) <= (36 + 46))) then
						return "bag_of_tricks cleave 46";
					end
				end
				if (((11463 - 7600) == (2114 + 1749)) and v53.ArcaneTorrent:IsCastable() and v29 and ((v13:Focus() + v13:FocusRegen() + (55 - 25)) < v13:FocusMax())) then
					if (v26(v53.ArcaneTorrent) or ((187 + 95) <= (24 + 18))) then
						return "arcane_torrent cleave 48";
					end
				end
				break;
			end
			if (((3312 + 1297) >= (644 + 122)) and (v110 == (0 + 0))) then
				if (v53.BarbedShot:IsCastable() or ((1585 - (153 + 280)) == (7184 - 4696))) then
					if (((3073 + 349) > (1323 + 2027)) and v51.CastTargetIf(v53.BarbedShot, v62, "max", v70, v72, not v14:IsSpellInRange(v53.BarbedShot))) then
						return "barbed_shot cleave 2";
					end
				end
				if (((459 + 418) > (342 + 34)) and v53.BarbedShot:IsCastable()) then
					if (v51.CastTargetIf(v53.BarbedShot, v62, "min", v69, v73, not v14:IsSpellInRange(v53.BarbedShot)) or ((2260 + 858) <= (2818 - 967))) then
						return "barbed_shot cleave 4";
					end
				end
				if ((v53.MultiShot:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < (0.5 + 0 + v59)) and (not v53.BloodyFrenzy:IsAvailable() or v53.CalloftheWild:CooldownDown())) or ((832 - (89 + 578)) >= (2495 + 997))) then
					if (((8209 - 4260) < (5905 - (572 + 477))) and v25(v53.MultiShot, nil, nil, not v14:IsSpellInRange(v53.MultiShot))) then
						return "multishot cleave 6";
					end
				end
				if ((v53.BestialWrath:IsCastable() and v29) or ((577 + 3699) < (1810 + 1206))) then
					if (((560 + 4130) > (4211 - (84 + 2))) and v26(v53.BestialWrath)) then
						return "bestial_wrath cleave 8";
					end
				end
				v110 = 1 - 0;
			end
			if ((v110 == (1 + 0)) or ((892 - (497 + 345)) >= (23 + 873))) then
				if ((v53.CalloftheWild:IsCastable() and v29) or ((290 + 1424) >= (4291 - (605 + 728)))) then
					if (v25(v53.CalloftheWild) or ((1064 + 427) < (1431 - 787))) then
						return "call_of_the_wild cleave 10";
					end
				end
				if (((33 + 671) < (3649 - 2662)) and v53.KillCommand:IsReady() and (v53.KillCleave:IsAvailable())) then
					if (((3352 + 366) > (5280 - 3374)) and v25(v53.KillCommand, nil, nil, not v14:IsInRange(38 + 12))) then
						return "kill_command cleave 12";
					end
				end
				if (v53.ExplosiveShot:IsReady() or ((1447 - (457 + 32)) > (1543 + 2092))) then
					if (((4903 - (832 + 570)) <= (4232 + 260)) and v25(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot))) then
						return "explosive_shot cleave 12";
					end
				end
				if ((v53.Stampede:IsCastable() and v29) or ((898 + 2544) < (9016 - 6468))) then
					if (((1385 + 1490) >= (2260 - (588 + 208))) and v25(v53.Stampede, not v14:IsSpellInRange(v53.Stampede))) then
						return "stampede cleave 14";
					end
				end
				v110 = 5 - 3;
			end
			if ((v110 == (1803 - (884 + 916))) or ((10042 - 5245) >= (2838 + 2055))) then
				if (v53.BarbedShot:IsCastable() or ((1204 - (232 + 421)) > (3957 - (1569 + 320)))) then
					if (((519 + 1595) > (180 + 764)) and v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "max", v70, v74, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
						return "barbed_shot cleave 26";
					end
				end
				if (v53.BarbedShot:IsCastable() or ((7622 - 5360) >= (3701 - (316 + 289)))) then
					if (v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v75, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover) or ((5902 - 3647) >= (164 + 3373))) then
						return "barbed_shot cleave 28";
					end
				end
				if (v53.KillCommand:IsReady() or ((5290 - (666 + 787)) < (1731 - (360 + 65)))) then
					if (((2757 + 193) == (3204 - (79 + 175))) and v25(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand))) then
						return "kill_command cleave 30";
					end
				end
				if (v53.DireBeast:IsCastable() or ((7446 - 2723) < (2574 + 724))) then
					if (((3481 - 2345) >= (296 - 142)) and v25(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast))) then
						return "dire_beast cleave 32";
					end
				end
				v110 = 903 - (503 + 396);
			end
		end
	end
	local function v84()
		local v111 = 181 - (92 + 89);
		while true do
			if ((v111 == (13 - 6)) or ((139 + 132) > (2811 + 1937))) then
				if (((18562 - 13822) >= (432 + 2720)) and v29) then
					local v129 = 0 - 0;
					while true do
						if ((v129 == (1 + 0)) or ((1232 + 1346) >= (10324 - 6934))) then
							if (((6 + 35) <= (2532 - 871)) and v53.ArcaneTorrent:IsCastable() and ((v13:Focus() + v13:FocusRegen() + (1259 - (485 + 759))) < v13:FocusMax())) then
								if (((1390 - 789) < (4749 - (442 + 747))) and v26(v53.ArcaneTorrent)) then
									return "arcane_torrent st 42";
								end
							end
							break;
						end
						if (((1370 - (832 + 303)) < (1633 - (88 + 858))) and (v129 == (0 + 0))) then
							if (((3765 + 784) > (48 + 1105)) and v53.BagofTricks:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (794 - (766 + 23))))) then
								if (v26(v53.BagofTricks) or ((23074 - 18400) < (6389 - 1717))) then
									return "bag_of_tricks st 38";
								end
							end
							if (((9664 - 5996) < (15480 - 10919)) and v53.ArcanePulse:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (1078 - (1036 + 37))))) then
								if (v26(v53.ArcanePulse) or ((323 + 132) == (7020 - 3415))) then
									return "arcane_pulse st 40";
								end
							end
							v129 = 1 + 0;
						end
					end
				end
				break;
			end
			if ((v111 == (1483 - (641 + 839))) or ((3576 - (910 + 3)) == (8443 - 5131))) then
				if (((5961 - (1466 + 218)) <= (2057 + 2418)) and v53.AMurderofCrows:IsCastable() and v29) then
					if (v25(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows)) or ((2018 - (556 + 592)) == (423 + 766))) then
						return "a_murder_of_crows st 14";
					end
				end
				if (((2361 - (329 + 479)) <= (3987 - (174 + 680))) and v53.SteelTrap:IsCastable()) then
					if (v26(v53.SteelTrap) or ((7686 - 5449) >= (7277 - 3766))) then
						return "steel_trap st 16";
					end
				end
				if (v53.ExplosiveShot:IsReady() or ((946 + 378) > (3759 - (396 + 343)))) then
					if (v25(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot)) or ((265 + 2727) == (3358 - (29 + 1448)))) then
						return "explosive_shot st 18";
					end
				end
				v111 = 1393 - (135 + 1254);
			end
			if (((11700 - 8594) > (7125 - 5599)) and (v111 == (2 + 0))) then
				if (((4550 - (389 + 1138)) < (4444 - (102 + 472))) and v53.BestialWrath:IsCastable() and v29) then
					if (((135 + 8) > (42 + 32)) and v26(v53.BestialWrath)) then
						return "bestial_wrath st 12";
					end
				end
				if (((17 + 1) < (3657 - (320 + 1225))) and v53.DeathChakram:IsCastable() and v29) then
					if (((1952 - 855) <= (997 + 631)) and v25(v53.DeathChakram, nil, nil, not v14:IsSpellInRange(v53.DeathChakram))) then
						return "death_chakram st 14";
					end
				end
				if (((6094 - (157 + 1307)) == (6489 - (821 + 1038))) and v53.KillCommand:IsReady()) then
					if (((8832 - 5292) > (294 + 2389)) and v25(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand))) then
						return "kill_command st 22";
					end
				end
				v111 = 4 - 1;
			end
			if (((1784 + 3010) >= (8117 - 4842)) and (v111 == (1031 - (834 + 192)))) then
				if (((95 + 1389) == (381 + 1103)) and v53.SerpentSting:IsReady()) then
					if (((31 + 1401) < (5507 - 1952)) and v51.CastTargetIf(v53.SerpentSting, v62, "min", v71, v79, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover)) then
						return "serpent_sting st 28";
					end
				end
				if (v53.KillShot:IsReady() or ((1369 - (300 + 4)) > (956 + 2622))) then
					if (v25(v53.KillShot, not v14:IsSpellInRange(v53.KillShot)) or ((12552 - 7757) < (1769 - (112 + 250)))) then
						return "kill_shot st 30";
					end
				end
				if (((739 + 1114) < (12057 - 7244)) and v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (12 + 8))) then
					if (v25(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot)) or ((1459 + 1362) < (1819 + 612))) then
						return "kill_shot_mouseover st 31";
					end
				end
				v111 = 3 + 3;
			end
			if ((v111 == (1 + 0)) or ((4288 - (1001 + 413)) < (4863 - 2682))) then
				if ((v53.KillCommand:IsReady() and (v53.KillCommand:FullRechargeTime() < v59) and v53.AlphaPredator:IsAvailable()) or ((3571 - (244 + 638)) <= (1036 - (627 + 66)))) then
					if (v25(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand)) or ((5568 - 3699) == (2611 - (512 + 90)))) then
						return "kill_command st 4";
					end
				end
				if ((v53.Stampede:IsCastable() and v29) or ((5452 - (1665 + 241)) < (3039 - (373 + 344)))) then
					if (v25(v53.Stampede, nil, nil, not v14:IsSpellInRange(v53.Stampede)) or ((940 + 1142) == (1263 + 3510))) then
						return "stampede st 8";
					end
				end
				if (((8556 - 5312) > (1784 - 729)) and v53.Bloodshed:IsCastable()) then
					if (v25(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed)) or ((4412 - (35 + 1064)) <= (1294 + 484))) then
						return "bloodshed st 10";
					end
				end
				v111 = 4 - 2;
			end
			if (((1 + 5) == v111) or ((2657 - (298 + 938)) >= (3363 - (233 + 1026)))) then
				if (((3478 - (636 + 1030)) <= (1662 + 1587)) and v53.AspectoftheWild:IsCastable() and v29) then
					if (((1586 + 37) <= (582 + 1375)) and v26(v53.AspectoftheWild)) then
						return "aspect_of_the_wild st 32";
					end
				end
				if (((299 + 4113) == (4633 - (55 + 166))) and v53.CobraShot:IsReady()) then
					if (((340 + 1410) >= (85 + 757)) and v25(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot))) then
						return "cobra_shot st 34";
					end
				end
				if (((16696 - 12324) > (2147 - (36 + 261))) and v53.WailingArrow:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53.WailingArrow:ExecuteTime()) or (v61 < (8 - 3)))) then
					if (((1600 - (34 + 1334)) < (316 + 505)) and v25(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow), true)) then
						return "wailing_arrow st 36";
					end
				end
				v111 = 6 + 1;
			end
			if (((1801 - (1035 + 248)) < (923 - (20 + 1))) and (v111 == (3 + 1))) then
				if (((3313 - (134 + 185)) > (1991 - (549 + 584))) and v53.BarbedShot:IsCastable()) then
					if (v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v78, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover) or ((4440 - (314 + 371)) <= (3141 - 2226))) then
						return "barbed_shot st 24";
					end
				end
				if (((4914 - (478 + 490)) > (1983 + 1760)) and v53.BarbedShot:IsCastable() and v78(v14)) then
					if (v25(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot)) or ((2507 - (786 + 386)) >= (10707 - 7401))) then
						return "barbed_shot st mt_backup 25";
					end
				end
				if (((6223 - (1055 + 324)) > (3593 - (1093 + 247))) and v53.DireBeast:IsCastable()) then
					if (((402 + 50) == (48 + 404)) and v25(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast))) then
						return "dire_beast st 26";
					end
				end
				v111 = 19 - 14;
			end
			if (((0 - 0) == v111) or ((12966 - 8409) < (5244 - 3157))) then
				if (((1379 + 2495) == (14924 - 11050)) and v53.BarbedShot:IsCastable()) then
					if (v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v77, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover) or ((6679 - 4741) > (3722 + 1213))) then
						return "barbed_shot st 2";
					end
				end
				if ((v53.BarbedShot:IsCastable() and v77(v14)) or ((10881 - 6626) < (4111 - (364 + 324)))) then
					if (((3985 - 2531) <= (5977 - 3486)) and v25(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot))) then
						return "barbed_shot st mt_backup 3";
					end
				end
				if ((v53.CalloftheWild:IsCastable() and v29) or ((1378 + 2779) <= (11728 - 8925))) then
					if (((7772 - 2919) >= (9056 - 6074)) and v26(v53.CalloftheWild)) then
						return "call_of_the_wild st 6";
					end
				end
				v111 = 1269 - (1249 + 19);
			end
		end
	end
	local function v85()
		if (((3732 + 402) > (13066 - 9709)) and not v13:IsCasting() and not v13:IsChanneling()) then
			local v120 = 1086 - (686 + 400);
			local v121;
			while true do
				if ((v120 == (1 + 0)) or ((3646 - (73 + 156)) < (12 + 2522))) then
					v121 = v51.InterruptWithStun(v53.Intimidation, 851 - (721 + 90));
					if (v121 or ((31 + 2691) <= (532 - 368))) then
						return v121;
					end
					break;
				end
				if ((v120 == (470 - (224 + 246))) or ((3900 - 1492) < (3882 - 1773))) then
					v121 = v51.Interrupt(v53.CounterShot, 8 + 32, true);
					if (v121 or ((1 + 32) == (1069 + 386))) then
						return v121;
					end
					v120 = 1 - 0;
				end
			end
		end
	end
	local function v86()
		v50();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		if (v53.Stomp:IsAvailable() or ((1473 - 1030) >= (4528 - (203 + 310)))) then
			v10.SplashEnemies.ChangeFriendTargetsTracking("Mine Only");
		else
			v10.SplashEnemies.ChangeFriendTargetsTracking("All");
		end
		local v115 = (v53.BloodBolt:IsPetKnown() and v20.FindBySpellID(v53.BloodBolt:ID()) and v53.BloodBolt) or (v53.Bite:IsPetKnown() and v20.FindBySpellID(v53.Bite:ID()) and v53.Bite) or (v53.Claw:IsPetKnown() and v20.FindBySpellID(v53.Claw:ID()) and v53.Claw) or (v53.Smack:IsPetKnown() and v20.FindBySpellID(v53.Smack:ID()) and v53.Smack) or nil;
		local v116 = (v53.Growl:IsPetKnown() and v20.FindBySpellID(v53.Growl:ID()) and v53.Growl) or nil;
		if (((5375 - (1238 + 755)) > (12 + 154)) and v28) then
			local v122 = 1534 - (709 + 825);
			while true do
				if ((v122 == (0 - 0)) or ((407 - 127) == (3923 - (196 + 668)))) then
					v62 = v13:GetEnemiesInRange(157 - 117);
					v63 = (v115 and v13:GetEnemiesInSpellActionRange(v115)) or v14:GetEnemiesInSplashRange(16 - 8);
					v122 = 834 - (171 + 662);
				end
				if (((1974 - (4 + 89)) > (4531 - 3238)) and (v122 == (1 + 0))) then
					v64 = (v115 and #v63) or v14:GetEnemiesInSplashRangeCount(35 - 27);
					break;
				end
			end
		else
			local v123 = 0 + 0;
			while true do
				if (((3843 - (35 + 1451)) == (3810 - (28 + 1425))) and (v123 == (1993 - (941 + 1052)))) then
					v62 = {};
					v63 = v14 or {};
					v123 = 1 + 0;
				end
				if (((1637 - (822 + 692)) == (174 - 51)) and (v123 == (1 + 0))) then
					v64 = 297 - (45 + 252);
					break;
				end
			end
		end
		v65 = v14:IsInRange(40 + 0);
		v66 = v14:IsInRange(11 + 19);
		v67 = (v116 and v14:IsSpellInActionRange(v116)) or v14:IsInRange(73 - 43);
		v59 = v13:GCD() + (433.15 - (114 + 319));
		if (v51.TargetIsValid() or v13:AffectingCombat() or ((1515 - 459) >= (4346 - 954))) then
			local v124 = 0 + 0;
			while true do
				if ((v124 == (1 - 0)) or ((2264 - 1183) < (3038 - (556 + 1407)))) then
					if ((v61 == (12317 - (741 + 465))) or ((1514 - (170 + 295)) >= (2336 + 2096))) then
						v61 = v10.FightRemains(v62, false);
					end
					break;
				end
				if (((0 + 0) == v124) or ((11738 - 6970) <= (702 + 144))) then
					v60 = v10.BossFightRemains();
					v61 = v60;
					v124 = 1 + 0;
				end
			end
		end
		if ((v53.Exhilaration:IsCastable() and v53.Exhilaration:IsReady() and (v13:HealthPercentage() <= v48)) or ((1902 + 1456) <= (2650 - (957 + 273)))) then
			if (v26(v53.Exhilaration) or ((1001 + 2738) <= (1203 + 1802))) then
				return "Exhilaration";
			end
		end
		if (((v13:HealthPercentage() <= v37) and v36 and v55.Healthstone:IsReady() and v55.Healthstone:IsUsable()) or ((6321 - 4662) >= (5623 - 3489))) then
			if (v26(v57.Healthstone, nil, nil, true) or ((9957 - 6697) < (11661 - 9306))) then
				return "healthstone defensive 3";
			end
		end
		if (not (v13:IsMounted() or v13:IsInVehicle()) or ((2449 - (389 + 1391)) == (2650 + 1573))) then
			local v125 = 0 + 0;
			while true do
				if ((v125 == (2 - 1)) or ((2643 - (783 + 168)) < (1973 - 1385))) then
					if ((v53.MendPet:IsCastable() and v45 and (v17:HealthPercentage() < v46)) or ((4719 + 78) < (3962 - (309 + 2)))) then
						if (v26(v53.MendPet) or ((12826 - 8649) > (6062 - (1090 + 122)))) then
							return "Mend Pet High Priority";
						end
					end
					break;
				end
				if ((v125 == (0 + 0)) or ((1343 - 943) > (761 + 350))) then
					if (((4169 - (628 + 490)) > (181 + 824)) and v53.SummonPet:IsCastable() and v41) then
						if (((9143 - 5450) <= (20025 - 15643)) and v26(v54[v42])) then
							return "Summon Pet";
						end
					end
					if ((v53.RevivePet:IsCastable() and v44 and v17:IsDeadOrGhost()) or ((4056 - (431 + 343)) > (8280 - 4180))) then
						if (v26(v53.RevivePet) or ((10356 - 6776) < (2247 + 597))) then
							return "Revive Pet";
						end
					end
					v125 = 1 + 0;
				end
			end
		end
		if (((1784 - (556 + 1139)) < (4505 - (6 + 9))) and v51.TargetIsValid()) then
			local v126 = 0 + 0;
			local v127;
			local v128;
			while true do
				if ((v126 == (2 + 1)) or ((5152 - (28 + 141)) < (701 + 1107))) then
					if (((4725 - 896) > (2670 + 1099)) and v128) then
						return v128;
					end
					if (((2802 - (486 + 831)) <= (7556 - 4652)) and ((v64 > (6 - 4)) or (v53.BeastCleave:IsAvailable() and (v64 > (1 + 0))))) then
						local v130 = 0 - 0;
						local v131;
						while true do
							if (((5532 - (668 + 595)) == (3842 + 427)) and (v130 == (0 + 0))) then
								v131 = v83();
								if (((1055 - 668) <= (3072 - (23 + 267))) and v131) then
									return v131;
								end
								break;
							end
						end
					end
					v126 = 1948 - (1129 + 815);
				end
				if ((v126 == (389 - (371 + 16))) or ((3649 - (1326 + 424)) <= (1736 - 819))) then
					if (v29 or ((15757 - 11445) <= (994 - (88 + 30)))) then
						local v132 = 771 - (720 + 51);
						local v133;
						while true do
							if (((4964 - 2732) <= (4372 - (421 + 1355))) and (v132 == (0 - 0))) then
								v133 = v81();
								if (((1030 + 1065) < (4769 - (286 + 797))) and v133) then
									return v133;
								end
								break;
							end
						end
					end
					v128 = v82();
					v126 = 10 - 7;
				end
				if ((v126 == (1 - 0)) or ((2034 - (397 + 42)) >= (1398 + 3076))) then
					v127 = v51.HandleDPSPotion();
					if (v127 or ((5419 - (24 + 776)) < (4439 - 1557))) then
						return v127;
					end
					v126 = 787 - (222 + 563);
				end
				if (((8 - 4) == v126) or ((212 + 82) >= (5021 - (23 + 167)))) then
					if (((3827 - (690 + 1108)) <= (1113 + 1971)) and ((v64 < (2 + 0)) or (not v53.BeastCleave:IsAvailable() and (v64 < (851 - (40 + 808)))))) then
						local v134 = 0 + 0;
						local v135;
						while true do
							if (((0 - 0) == v134) or ((1947 + 90) == (1281 + 1139))) then
								v135 = v84();
								if (((2445 + 2013) > (4475 - (47 + 524))) and v135) then
									return v135;
								end
								break;
							end
						end
					end
					if (((283 + 153) >= (336 - 213)) and not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53.MendPet:IsCastable() and (v17:HealthPercentage() < v46) and v45) then
						if (((747 - 247) < (4141 - 2325)) and v26(v53.MendPet)) then
							return "Mend Pet Low Priority (w/ Target)";
						end
					end
					break;
				end
				if (((5300 - (1165 + 561)) == (107 + 3467)) and (v126 == (0 - 0))) then
					if (((85 + 136) < (869 - (341 + 138))) and not v13:AffectingCombat() and not v27) then
						local v136 = 0 + 0;
						local v137;
						while true do
							if ((v136 == (0 - 0)) or ((2539 - (89 + 237)) <= (4571 - 3150))) then
								v137 = v80();
								if (((6437 - 3379) < (5741 - (581 + 300))) and v137) then
									return v137;
								end
								break;
							end
						end
					end
					if ((not v13:IsCasting() and not v13:IsChanneling()) or ((2516 - (855 + 365)) >= (10559 - 6113))) then
						local v138 = v51.Interrupt(v53.CounterShot, 14 + 26, true);
						if (v138 or ((2628 - (1030 + 205)) > (4215 + 274))) then
							return v138;
						end
						v138 = v51.Interrupt(v53.CounterShot, 38 + 2, true, v16, v57.CounterShotMouseover);
						if (v138 or ((4710 - (156 + 130)) < (61 - 34))) then
							return v138;
						end
						v138 = v51.InterruptWithStun(v53.Intimidation, 67 - 27, true);
						if (v138 or ((4089 - 2092) > (1006 + 2809))) then
							return v138;
						end
						v138 = v51.InterruptWithStun(v53.Intimidation, 24 + 16, true, v16, v57.IntimidationMouseover);
						if (((3534 - (10 + 59)) > (542 + 1371)) and v138) then
							return v138;
						end
					end
					v126 = 4 - 3;
				end
			end
		end
		if (((1896 - (671 + 492)) < (1449 + 370)) and not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53.MendPet:IsCastable() and (v17:HealthPercentage() < v46) and v45) then
			if (v26(v53.MendPet) or ((5610 - (369 + 846)) == (1259 + 3496))) then
				return "Mend Pet Low Priority (w/o Target)";
			end
		end
	end
	local function v87()
		local v117 = 0 + 0;
		local v118;
		while true do
			if (((1945 - (1036 + 909)) == v117) or ((3016 + 777) < (3976 - 1607))) then
				v10.Print("Beast Mastery by Epic. Supported by Gojira");
				v118 = (v53.Growl:IsPetKnown() and v20.FindBySpellID(v53.Growl:ID()) and v53.Growl) or nil;
				v117 = 204 - (11 + 192);
			end
			if ((v117 == (1 + 0)) or ((4259 - (135 + 40)) == (641 - 376))) then
				if (((2627 + 1731) == (9600 - 5242)) and not v118) then
					v10.Print("|cffffff00Info|r: Add pet abilities to your action bars to improve range checks.");
				end
				break;
			end
		end
	end
	v10.SetAPL(379 - 126, v86, v87);
end;
return v0["Epix_Hunter_BeastMastery.lua"]();

