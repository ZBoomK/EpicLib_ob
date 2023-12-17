local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((10400 - 7180) == (4959 - (404 + 1335))) and (v5 == (406 - (183 + 223)))) then
			v6 = v0[v4];
			if (((2595 - 461) == (1414 + 720)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (338 - (10 + 327))) or ((1501 + 653) >= (3663 - (118 + 220)))) then
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
		local v88 = 0 + 0;
		while true do
			if ((v88 == (452 - (108 + 341))) or ((582 + 713) >= (13668 - 10435))) then
				v44 = EpicSettings.Settings['UseRevive'];
				v45 = EpicSettings.Settings['UseMendPet'];
				v46 = EpicSettings.Settings['MendPetHP'] or (1493 - (711 + 782));
				v47 = EpicSettings.Settings['UseExhilaration'];
				v88 = 7 - 3;
			end
			if (((4846 - (270 + 199)) > (533 + 1109)) and (v88 == (1819 - (580 + 1239)))) then
				v31 = EpicSettings.Settings['UseRacials'];
				v33 = EpicSettings.Settings['UseHealingPotion'];
				v34 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v35 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v88 = 1 + 0;
			end
			if (((2058 + 2665) > (3540 - 2184)) and (v88 == (1 + 0))) then
				v36 = EpicSettings.Settings['UseHealthstone'];
				v37 = EpicSettings.Settings['HealthstoneHP'] or (1167 - (645 + 522));
				v38 = EpicSettings.Settings['InterruptWithStun'] or (1790 - (1010 + 780));
				v39 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v88 = 9 - 7;
			end
			if ((v88 == (5 - 3)) or ((5972 - (1045 + 791)) <= (8689 - 5256))) then
				v40 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v41 = EpicSettings.Settings['UsePet'];
				v42 = EpicSettings.Settings['SummonPetSlot'] or (505 - (351 + 154));
				v43 = EpicSettings.Settings['UseSteelTrap'];
				v88 = 1577 - (1281 + 293);
			end
			if (((4511 - (28 + 238)) <= (10347 - 5716)) and (v88 == (1563 - (1381 + 178)))) then
				v48 = EpicSettings.Settings['ExhilarationHP'] or (0 + 0);
				v49 = EpicSettings.Settings['UseTranq'];
				break;
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
	local v60 = 9854 + 1257;
	local v61 = 7515 + 3596;
	v10:RegisterForEvent(function()
		v60 = 19032 - 7921;
		v61 = 12267 - (1074 + 82);
	end, "PLAYER_REGEN_ENABLED");
	local v62, v63, v64;
	local v65, v66;
	local v67;
	local v68 = {{v53.Intimidation,"Cast Intimidation (Interrupt)",function()
		return true;
	end}};
	local function v69(v89)
		return (v89:DebuffRemains(v53.BarbedShotDebuff));
	end
	local function v70(v90)
		return (v90:DebuffStack(v53.LatentPoisonDebuff));
	end
	local function v71(v91)
		return (v91:DebuffRemains(v53.SerpentStingDebuff));
	end
	local function v72(v92)
		return (v92:DebuffStack(v53.LatentPoisonDebuff) > (4 + 5)) and ((v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + 0.25 + 0))) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < ((47 - 35) + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < (1729 - (1668 + 58))) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp())) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown()));
	end
	local function v73(v93)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + (626.25 - (512 + 114))))) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < ((31 - 19) + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < (5 - 2)) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp())) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown());
	end
	local function v74(v94)
		return (v94:DebuffStack(v53.LatentPoisonDebuff) > (31 - 22)) and (v13:BuffUp(v53.CalloftheWildBuff) or (v61 < (5 + 4)) or (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1.2 + 0))) or v53.Savagery:IsAvailable());
	end
	local function v75(v95)
		return v13:BuffUp(v53.CalloftheWildBuff) or (v61 < (8 + 1)) or (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (3.2 - 2))) or v53.Savagery:IsAvailable();
	end
	local function v76(v96)
		return v96:DebuffRefreshable(v53.SerpentStingDebuff) and (v96:TimeToDie() > v53.SerpentStingDebuff:BaseDuration());
	end
	local function v77(v97)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + (1994.25 - (109 + 1885))))) or (v53.ScentofBlood:IsAvailable() and (v17:BuffStack(v53.FrenzyPetBuff) < (1472 - (1269 + 200))) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp()));
	end
	local function v78(v98)
		return (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1.4 - 0))) or v13:BuffUp(v53.CalloftheWildBuff) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown()) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < ((827 - (98 + 717)) + v59))) or v53.Savagery:IsAvailable() or (v61 < (835 - (802 + 24)));
	end
	local function v79(v99)
		return v99:DebuffRefreshable(v53.SerpentStingDebuff) and (v14:TimeToDie() > v53.SerpentStingDebuff:BaseDuration());
	end
	local function v80()
		if (((7373 - 3097) >= (4942 - 1028)) and v15:Exists() and v53.Misdirection:IsReady()) then
			if (((30 + 168) <= (3354 + 1011)) and v26(v57.MisdirectionFocus)) then
				return "misdirection precombat 0";
			end
		end
		if (((786 + 3996) > (1009 + 3667)) and v53.SteelTrap:IsCastable() and not v53.WailingArrow:IsAvailable() and v53.SteelTrap:IsAvailable()) then
			if (((13531 - 8667) > (7326 - 5129)) and v26(v53.SteelTrap)) then
				return "steel_trap precombat 2";
			end
		end
		if ((v53.BarbedShot:IsCastable() and (v53.BarbedShot:Charges() >= (1 + 1))) or ((1507 + 2193) == (2068 + 439))) then
			if (((3254 + 1220) >= (128 + 146)) and v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot))) then
				return "barbed_shot precombat 8";
			end
		end
		if (v53.KillShot:IsReady() or ((3327 - (797 + 636)) <= (6826 - 5420))) then
			if (((3191 - (1427 + 192)) >= (531 + 1000)) and v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot))) then
				return "kill_shot precombat 10";
			end
		end
		if ((v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (46 - 26))) or ((4213 + 474) < (2059 + 2483))) then
			if (((3617 - (192 + 134)) > (2943 - (316 + 960))) and v25(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot))) then
				return "kill_shot_mouseover precombat 11";
			end
		end
		if (v53.KillCommand:IsReady() or ((486 + 387) == (1570 + 464))) then
			if (v26(v57.KillCommandPetAttack) or ((2603 + 213) < (41 - 30))) then
				return "kill_command precombat 12";
			end
		end
		if (((4250 - (83 + 468)) < (6512 - (1202 + 604))) and (v64 > (4 - 3))) then
			if (((4403 - 1757) >= (2425 - 1549)) and v53.MultiShot:IsReady()) then
				if (((939 - (45 + 280)) <= (3074 + 110)) and v25(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot))) then
					return "multishot precombat 14";
				end
			end
		elseif (((2732 + 394) == (1142 + 1984)) and v53.CobraShot:IsReady()) then
			if (v25(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot)) or ((1211 + 976) >= (872 + 4082))) then
				return "cobra_shot precombat 16";
			end
		end
	end
	local function v81()
		if ((v53.Berserking:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (23 - 10)))) or ((5788 - (340 + 1571)) == (1411 + 2164))) then
			if (((2479 - (1733 + 39)) > (1736 - 1104)) and v26(v53.Berserking)) then
				return "berserking cds 2";
			end
		end
		if ((v53.BloodFury:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (1050 - (125 + 909))))) or ((2494 - (1096 + 852)) >= (1204 + 1480))) then
			if (((2091 - 626) <= (4172 + 129)) and v26(v53.BloodFury)) then
				return "blood_fury cds 8";
			end
		end
		if (((2216 - (409 + 103)) > (1661 - (46 + 190))) and v53.AncestralCall:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (111 - (51 + 44))))) then
			if (v26(v53.AncestralCall) or ((194 + 493) == (5551 - (1114 + 203)))) then
				return "ancestral_call cds 10";
			end
		end
		if ((v53.Fireblood:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (735 - (228 + 498))))) or ((722 + 2608) < (790 + 639))) then
			if (((1810 - (174 + 489)) >= (872 - 537)) and v26(v53.Fireblood)) then
				return "fireblood cds 12";
			end
		end
	end
	local function v82()
		local v100 = 1905 - (830 + 1075);
		local v101;
		while true do
			if (((3959 - (303 + 221)) > (3366 - (231 + 1038))) and (v100 == (0 + 0))) then
				v101 = v51.HandleTopTrinket(v56, v29, 1202 - (171 + 991), nil);
				if (v101 or ((15536 - 11766) >= (10850 - 6809))) then
					return v101;
				end
				v100 = 2 - 1;
			end
			if ((v100 == (1 + 0)) or ((13288 - 9497) <= (4647 - 3036))) then
				v101 = v51.HandleBottomTrinket(v56, v29, 64 - 24, nil);
				if (v101 or ((14151 - 9573) <= (3256 - (111 + 1137)))) then
					return v101;
				end
				break;
			end
		end
	end
	local function v83()
		local v102 = 158 - (91 + 67);
		while true do
			if (((3348 - 2223) <= (518 + 1558)) and (v102 == (526 - (423 + 100)))) then
				if ((v53.DeathChakram:IsCastable() and v29) or ((6 + 737) >= (12179 - 7780))) then
					if (((603 + 552) < (2444 - (326 + 445))) and v25(v53.DeathChakram, not v14:IsSpellInRange(v53.DeathChakram))) then
						return "death_chakram cleave 18";
					end
				end
				if (v53.SteelTrap:IsCastable() or ((10141 - 7817) <= (1287 - 709))) then
					if (((8792 - 5025) == (4478 - (530 + 181))) and v26(v57.SteelTrap)) then
						return "steel_trap cleave 22";
					end
				end
				if (((4970 - (614 + 267)) == (4121 - (19 + 13))) and v53.AMurderofCrows:IsReady() and v29) then
					if (((7255 - 2797) >= (3900 - 2226)) and v25(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows))) then
						return "a_murder_of_crows cleave 24";
					end
				end
				v102 = 11 - 7;
			end
			if (((253 + 719) <= (2493 - 1075)) and (v102 == (0 - 0))) then
				if (v53.BarbedShot:IsCastable() or ((6750 - (1293 + 519)) < (9715 - 4953))) then
					if (v51.CastTargetIf(v53.BarbedShot, v62, "max", v70, v72, not v14:IsSpellInRange(v53.BarbedShot)) or ((6537 - 4033) > (8153 - 3889))) then
						return "barbed_shot cleave 2";
					end
				end
				if (((9283 - 7130) == (5071 - 2918)) and v53.BarbedShot:IsCastable()) then
					if (v51.CastTargetIf(v53.BarbedShot, v62, "min", v69, v73, not v14:IsSpellInRange(v53.BarbedShot)) or ((269 + 238) >= (529 + 2062))) then
						return "barbed_shot cleave 4";
					end
				end
				if (((10411 - 5930) == (1036 + 3445)) and v53.MultiShot:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < (0.5 + 0 + v59)) and (not v53.BloodyFrenzy:IsAvailable() or v53.CalloftheWild:CooldownDown())) then
					if (v25(v53.MultiShot, nil, nil, not v14:IsSpellInRange(v53.MultiShot)) or ((1455 + 873) < (1789 - (709 + 387)))) then
						return "multishot cleave 6";
					end
				end
				v102 = 1859 - (673 + 1185);
			end
			if (((12551 - 8223) == (13897 - 9569)) and (v102 == (9 - 3))) then
				if (((1136 + 452) >= (996 + 336)) and v53.MultiShot:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < (v13:GCD() * (3 - 0)))) then
					if (v25(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot)) or ((1026 + 3148) > (8470 - 4222))) then
						return "multishot cleave 38";
					end
				end
				if ((v53.AspectoftheWild:IsCastable() and v29) or ((9001 - 4415) <= (1962 - (446 + 1434)))) then
					if (((5146 - (1040 + 243)) == (11529 - 7666)) and v26(v53.AspectoftheWild)) then
						return "aspect_of_the_wild cleave 40";
					end
				end
				if ((v29 and v53.LightsJudgment:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v14:TimeToDie() < (1852 - (559 + 1288))))) or ((2213 - (609 + 1322)) <= (496 - (13 + 441)))) then
					if (((17222 - 12613) >= (2006 - 1240)) and v25(v53.LightsJudgment, nil, not v14:IsInRange(24 - 19))) then
						return "lights_judgment cleave 40";
					end
				end
				v102 = 1 + 6;
			end
			if ((v102 == (3 - 2)) or ((410 + 742) == (1091 + 1397))) then
				if (((10154 - 6732) > (1834 + 1516)) and v53.BestialWrath:IsCastable() and v29) then
					if (((1612 - 735) > (249 + 127)) and v26(v53.BestialWrath)) then
						return "bestial_wrath cleave 8";
					end
				end
				if ((v53.CalloftheWild:IsCastable() and v29) or ((1735 + 1383) <= (1330 + 521))) then
					if (v25(v53.CalloftheWild) or ((139 + 26) >= (3417 + 75))) then
						return "call_of_the_wild cleave 10";
					end
				end
				if (((4382 - (153 + 280)) < (14022 - 9166)) and v53.KillCommand:IsReady() and (v53.KillCleave:IsAvailable())) then
					if (v25(v53.KillCommand, nil, nil, not v14:IsInRange(45 + 5)) or ((1689 + 2587) < (1579 + 1437))) then
						return "kill_command cleave 12";
					end
				end
				v102 = 2 + 0;
			end
			if (((3399 + 1291) > (6281 - 2156)) and (v102 == (2 + 0))) then
				if (v53.ExplosiveShot:IsReady() or ((717 - (89 + 578)) >= (641 + 255))) then
					if (v25(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot)) or ((3563 - 1849) >= (4007 - (572 + 477)))) then
						return "explosive_shot cleave 12";
					end
				end
				if ((v53.Stampede:IsCastable() and v29) or ((202 + 1289) < (387 + 257))) then
					if (((85 + 619) < (1073 - (84 + 2))) and v25(v53.Stampede, not v14:IsSpellInRange(v53.Stampede))) then
						return "stampede cleave 14";
					end
				end
				if (((6127 - 2409) > (1374 + 532)) and v53.Bloodshed:IsCastable()) then
					if (v25(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed)) or ((1800 - (497 + 345)) > (93 + 3542))) then
						return "bloodshed cleave 16";
					end
				end
				v102 = 1 + 2;
			end
			if (((4834 - (605 + 728)) <= (3205 + 1287)) and ((17 - 9) == v102)) then
				if ((v53.WailingArrow:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53.WailingArrow:ExecuteTime()) or (v61 < (1 + 4)))) or ((12725 - 9283) < (2298 + 250))) then
					if (((7965 - 5090) >= (1106 + 358)) and v25(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow))) then
						return "wailing_arrow cleave 44";
					end
				end
				if ((v53.BagofTricks:IsCastable() and v29 and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (494 - (457 + 32))))) or ((2036 + 2761) >= (6295 - (832 + 570)))) then
					if (v26(v53.BagofTricks) or ((520 + 31) > (540 + 1528))) then
						return "bag_of_tricks cleave 46";
					end
				end
				if (((7480 - 5366) > (455 + 489)) and v53.ArcaneTorrent:IsCastable() and v29 and ((v13:Focus() + v13:FocusRegen() + (826 - (588 + 208))) < v13:FocusMax())) then
					if (v26(v53.ArcaneTorrent) or ((6096 - 3834) >= (4896 - (884 + 916)))) then
						return "arcane_torrent cleave 48";
					end
				end
				break;
			end
			if ((v102 == (8 - 4)) or ((1308 + 947) >= (4190 - (232 + 421)))) then
				if (v53.BarbedShot:IsCastable() or ((5726 - (1569 + 320)) < (321 + 985))) then
					if (((561 + 2389) == (9940 - 6990)) and v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "max", v70, v74, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
						return "barbed_shot cleave 26";
					end
				end
				if (v53.BarbedShot:IsCastable() or ((5328 - (316 + 289)) < (8632 - 5334))) then
					if (((53 + 1083) >= (1607 - (666 + 787))) and v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v75, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
						return "barbed_shot cleave 28";
					end
				end
				if (v53.KillCommand:IsReady() or ((696 - (360 + 65)) > (4438 + 310))) then
					if (((4994 - (79 + 175)) >= (4969 - 1817)) and v25(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand))) then
						return "kill_command cleave 30";
					end
				end
				v102 = 4 + 1;
			end
			if (((21 - 14) == v102) or ((4964 - 2386) >= (4289 - (503 + 396)))) then
				if (((222 - (92 + 89)) <= (3222 - 1561)) and v53.KillShot:IsReady()) then
					if (((309 + 292) < (2107 + 1453)) and v25(v53.KillShot, not v14:IsSpellInRange(v53.KillShot))) then
						return "kill_shot cleave 38";
					end
				end
				if (((920 - 685) < (94 + 593)) and v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (45 - 25))) then
					if (((3969 + 580) > (551 + 602)) and v25(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot))) then
						return "kill_shot_mouseover cleave 39";
					end
				end
				if ((v53.CobraShot:IsReady() and (v13:FocusTimeToMax() < (v59 * (5 - 3)))) or ((584 + 4090) < (7124 - 2452))) then
					if (((4912 - (485 + 759)) < (10553 - 5992)) and v25(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot))) then
						return "cobra_shot cleave 42";
					end
				end
				v102 = 1197 - (442 + 747);
			end
			if ((v102 == (1140 - (832 + 303))) or ((1401 - (88 + 858)) == (1099 + 2506))) then
				if (v53.DireBeast:IsCastable() or ((2204 + 459) == (137 + 3175))) then
					if (((5066 - (766 + 23)) <= (22091 - 17616)) and v25(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast))) then
						return "dire_beast cleave 32";
					end
				end
				if (v53.SerpentSting:IsReady() or ((1189 - 319) == (3132 - 1943))) then
					if (((5270 - 3717) <= (4206 - (1036 + 37))) and v51.CastTargetIf(v53.SerpentSting, v62, "min", v71, v76, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover)) then
						return "serpent_sting cleave 34";
					end
				end
				if ((v53.Barrage:IsReady() and (v17:BuffRemains(v53.FrenzyPetBuff) > v53.Barrage:ExecuteTime())) or ((1586 + 651) >= (6837 - 3326))) then
					if (v25(v53.Barrage, not v14:IsSpellInRange(v53.Barrage)) or ((1042 + 282) > (4500 - (641 + 839)))) then
						return "barrage cleave 36";
					end
				end
				v102 = 919 - (910 + 3);
			end
		end
	end
	local function v84()
		local v103 = 0 - 0;
		while true do
			if ((v103 == (1687 - (1466 + 218))) or ((1376 + 1616) == (3029 - (556 + 592)))) then
				if (((1105 + 2001) > (2334 - (329 + 479))) and v53.BarbedShot:IsCastable()) then
					if (((3877 - (174 + 680)) < (13297 - 9427)) and v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v78, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
						return "barbed_shot st 24";
					end
				end
				if (((295 - 152) > (53 + 21)) and v53.BarbedShot:IsCastable() and v78(v14)) then
					if (((757 - (396 + 343)) < (187 + 1925)) and v25(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot))) then
						return "barbed_shot st mt_backup 25";
					end
				end
				if (((2574 - (29 + 1448)) <= (3017 - (135 + 1254))) and v53.DireBeast:IsCastable()) then
					if (((17442 - 12812) == (21618 - 16988)) and v25(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast))) then
						return "dire_beast st 26";
					end
				end
				if (((2360 + 1180) > (4210 - (389 + 1138))) and v53.SerpentSting:IsReady()) then
					if (((5368 - (102 + 472)) >= (3091 + 184)) and v51.CastTargetIf(v53.SerpentSting, v62, "min", v71, v79, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover)) then
						return "serpent_sting st 28";
					end
				end
				v103 = 3 + 1;
			end
			if (((1384 + 100) == (3029 - (320 + 1225))) and (v103 == (2 - 0))) then
				if (((877 + 555) < (5019 - (157 + 1307))) and v53.KillCommand:IsReady()) then
					if (v25(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand)) or ((2924 - (821 + 1038)) > (8927 - 5349))) then
						return "kill_command st 22";
					end
				end
				if ((v53.AMurderofCrows:IsCastable() and v29) or ((525 + 4270) < (2499 - 1092))) then
					if (((690 + 1163) < (11929 - 7116)) and v25(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows))) then
						return "a_murder_of_crows st 14";
					end
				end
				if (v53.SteelTrap:IsCastable() or ((3847 - (834 + 192)) < (155 + 2276))) then
					if (v26(v53.SteelTrap) or ((738 + 2136) < (47 + 2134))) then
						return "steel_trap st 16";
					end
				end
				if (v53.ExplosiveShot:IsReady() or ((4165 - 1476) <= (647 - (300 + 4)))) then
					if (v25(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot)) or ((500 + 1369) == (5258 - 3249))) then
						return "explosive_shot st 18";
					end
				end
				v103 = 365 - (112 + 250);
			end
			if ((v103 == (0 + 0)) or ((8883 - 5337) < (1331 + 991))) then
				if (v53.BarbedShot:IsCastable() or ((1077 + 1005) == (3570 + 1203))) then
					if (((1609 + 1635) > (784 + 271)) and v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v77, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
						return "barbed_shot st 2";
					end
				end
				if ((v53.BarbedShot:IsCastable() and v77(v14)) or ((4727 - (1001 + 413)) <= (3964 - 2186))) then
					if (v25(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot)) or ((2303 - (244 + 638)) >= (2797 - (627 + 66)))) then
						return "barbed_shot st mt_backup 3";
					end
				end
				if (((5398 - 3586) <= (3851 - (512 + 90))) and v53.CalloftheWild:IsCastable() and v29) then
					if (((3529 - (1665 + 241)) <= (2674 - (373 + 344))) and v26(v53.CalloftheWild)) then
						return "call_of_the_wild st 6";
					end
				end
				if (((1990 + 2422) == (1168 + 3244)) and v53.KillCommand:IsReady() and (v53.KillCommand:FullRechargeTime() < v59) and v53.AlphaPredator:IsAvailable()) then
					if (((4616 - 2866) >= (1424 - 582)) and v25(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand))) then
						return "kill_command st 4";
					end
				end
				v103 = 1100 - (35 + 1064);
			end
			if (((3182 + 1190) > (3958 - 2108)) and (v103 == (1 + 3))) then
				if (((1468 - (298 + 938)) < (2080 - (233 + 1026))) and v53.KillShot:IsReady()) then
					if (((2184 - (636 + 1030)) < (462 + 440)) and v25(v53.KillShot, not v14:IsSpellInRange(v53.KillShot))) then
						return "kill_shot st 30";
					end
				end
				if (((2925 + 69) > (255 + 603)) and v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (2 + 18))) then
					if (v25(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot)) or ((3976 - (55 + 166)) <= (178 + 737))) then
						return "kill_shot_mouseover st 31";
					end
				end
				if (((397 + 3549) > (14294 - 10551)) and v53.AspectoftheWild:IsCastable() and v29) then
					if (v26(v53.AspectoftheWild) or ((1632 - (36 + 261)) >= (5781 - 2475))) then
						return "aspect_of_the_wild st 32";
					end
				end
				if (((6212 - (34 + 1334)) > (867 + 1386)) and v53.CobraShot:IsReady()) then
					if (((352 + 100) == (1735 - (1035 + 248))) and v25(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot))) then
						return "cobra_shot st 34";
					end
				end
				v103 = 26 - (20 + 1);
			end
			if ((v103 == (1 + 0)) or ((4876 - (134 + 185)) < (3220 - (549 + 584)))) then
				if (((4559 - (314 + 371)) == (13299 - 9425)) and v53.Stampede:IsCastable() and v29) then
					if (v25(v53.Stampede, nil, nil, not v14:IsSpellInRange(v53.Stampede)) or ((2906 - (478 + 490)) > (2615 + 2320))) then
						return "stampede st 8";
					end
				end
				if (v53.Bloodshed:IsCastable() or ((5427 - (786 + 386)) < (11086 - 7663))) then
					if (((2833 - (1055 + 324)) <= (3831 - (1093 + 247))) and v25(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed))) then
						return "bloodshed st 10";
					end
				end
				if ((v53.BestialWrath:IsCastable() and v29) or ((3695 + 462) <= (295 + 2508))) then
					if (((19267 - 14414) >= (10120 - 7138)) and v26(v53.BestialWrath)) then
						return "bestial_wrath st 12";
					end
				end
				if (((11762 - 7628) > (8435 - 5078)) and v53.DeathChakram:IsCastable() and v29) then
					if (v25(v53.DeathChakram, nil, nil, not v14:IsSpellInRange(v53.DeathChakram)) or ((1216 + 2201) < (9762 - 7228))) then
						return "death_chakram st 14";
					end
				end
				v103 = 6 - 4;
			end
			if ((v103 == (4 + 1)) or ((6961 - 4239) <= (852 - (364 + 324)))) then
				if ((v53.WailingArrow:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53.WailingArrow:ExecuteTime()) or (v61 < (13 - 8)))) or ((5778 - 3370) < (699 + 1410))) then
					if (v25(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow), true) or ((137 - 104) == (2330 - 875))) then
						return "wailing_arrow st 36";
					end
				end
				if (v29 or ((1345 - 902) >= (5283 - (1249 + 19)))) then
					local v128 = 0 + 0;
					while true do
						if (((13164 - 9782) > (1252 - (686 + 400))) and (v128 == (0 + 0))) then
							if ((v53.BagofTricks:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (234 - (73 + 156))))) or ((2 + 278) == (3870 - (721 + 90)))) then
								if (((22 + 1859) > (4198 - 2905)) and v26(v53.BagofTricks)) then
									return "bag_of_tricks st 38";
								end
							end
							if (((2827 - (224 + 246)) == (3818 - 1461)) and v53.ArcanePulse:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (9 - 4)))) then
								if (((23 + 100) == (3 + 120)) and v26(v53.ArcanePulse)) then
									return "arcane_pulse st 40";
								end
							end
							v128 = 1 + 0;
						end
						if ((v128 == (1 - 0)) or ((3514 - 2458) >= (3905 - (203 + 310)))) then
							if ((v53.ArcaneTorrent:IsCastable() and ((v13:Focus() + v13:FocusRegen() + (2008 - (1238 + 755))) < v13:FocusMax())) or ((76 + 1005) < (2609 - (709 + 825)))) then
								if (v26(v53.ArcaneTorrent) or ((1932 - 883) >= (6455 - 2023))) then
									return "arcane_torrent st 42";
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
	local function v85()
		if ((not v13:IsCasting() and not v13:IsChanneling()) or ((5632 - (196 + 668)) <= (3340 - 2494))) then
			local v111 = 0 - 0;
			local v112;
			while true do
				if ((v111 == (834 - (171 + 662))) or ((3451 - (4 + 89)) <= (4977 - 3557))) then
					v112 = v51.InterruptWithStun(v53.Intimidation, 15 + 25);
					if (v112 or ((16422 - 12683) <= (1179 + 1826))) then
						return v112;
					end
					break;
				end
				if (((1486 - (35 + 1451)) == v111) or ((3112 - (28 + 1425)) >= (4127 - (941 + 1052)))) then
					v112 = v51.Interrupt(v53.CounterShot, 39 + 1, true);
					if (v112 or ((4774 - (822 + 692)) < (3361 - 1006))) then
						return v112;
					end
					v111 = 1 + 0;
				end
			end
		end
	end
	local function v86()
		v50();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		if (v53.Stomp:IsAvailable() or ((966 - (45 + 252)) == (4179 + 44))) then
			v10.SplashEnemies.ChangeFriendTargetsTracking("Mine Only");
		else
			v10.SplashEnemies.ChangeFriendTargetsTracking("All");
		end
		local v107 = (v53.BloodBolt:IsPetKnown() and v20.FindBySpellID(v53.BloodBolt:ID()) and v53.BloodBolt) or (v53.Bite:IsPetKnown() and v20.FindBySpellID(v53.Bite:ID()) and v53.Bite) or (v53.Claw:IsPetKnown() and v20.FindBySpellID(v53.Claw:ID()) and v53.Claw) or (v53.Smack:IsPetKnown() and v20.FindBySpellID(v53.Smack:ID()) and v53.Smack) or nil;
		local v108 = (v53.Growl:IsPetKnown() and v20.FindBySpellID(v53.Growl:ID()) and v53.Growl) or nil;
		if (v28 or ((583 + 1109) < (1430 - 842))) then
			local v113 = 433 - (114 + 319);
			while true do
				if ((v113 == (0 - 0)) or ((6146 - 1349) < (2328 + 1323))) then
					v62 = v13:GetEnemiesInRange(59 - 19);
					v63 = (v107 and v13:GetEnemiesInSpellActionRange(v107)) or v14:GetEnemiesInSplashRange(16 - 8);
					v113 = 1964 - (556 + 1407);
				end
				if ((v113 == (1207 - (741 + 465))) or ((4642 - (170 + 295)) > (2556 + 2294))) then
					v64 = (v107 and #v63) or v14:GetEnemiesInSplashRangeCount(8 + 0);
					break;
				end
			end
		else
			local v114 = 0 - 0;
			while true do
				if ((v114 == (0 + 0)) or ((257 + 143) > (630 + 481))) then
					v62 = {};
					v63 = v14 or {};
					v114 = 1231 - (957 + 273);
				end
				if (((817 + 2234) > (403 + 602)) and (v114 == (3 - 2))) then
					v64 = 0 - 0;
					break;
				end
			end
		end
		v65 = v14:IsInRange(122 - 82);
		v66 = v14:IsInRange(148 - 118);
		v67 = (v108 and v14:IsSpellInActionRange(v108)) or v14:IsInRange(1810 - (389 + 1391));
		v59 = v13:GCD() + 0.15 + 0;
		if (((385 + 3308) <= (9975 - 5593)) and (v51.TargetIsValid() or v13:AffectingCombat())) then
			local v115 = 951 - (783 + 168);
			while true do
				if (((3 - 2) == v115) or ((3229 + 53) > (4411 - (309 + 2)))) then
					if ((v61 == (34120 - 23009)) or ((4792 - (1090 + 122)) < (923 + 1921))) then
						v61 = v10.FightRemains(v62, false);
					end
					break;
				end
				if (((298 - 209) < (3073 + 1417)) and (v115 == (1118 - (628 + 490)))) then
					v60 = v10.BossFightRemains();
					v61 = v60;
					v115 = 1 + 0;
				end
			end
		end
		if ((v53.Exhilaration:IsCastable() and v53.Exhilaration:IsReady() and (v13:HealthPercentage() <= v48)) or ((12337 - 7354) < (8262 - 6454))) then
			if (((4603 - (431 + 343)) > (7611 - 3842)) and v26(v53.Exhilaration)) then
				return "Exhilaration";
			end
		end
		if (((4296 - 2811) <= (2295 + 609)) and (v13:HealthPercentage() <= v37) and v36 and v55.Healthstone:IsReady() and v55.Healthstone:IsUsable()) then
			if (((547 + 3722) == (5964 - (556 + 1139))) and v26(v57.Healthstone, nil, nil, true)) then
				return "healthstone defensive 3";
			end
		end
		if (((402 - (6 + 9)) <= (510 + 2272)) and not (v13:IsMounted() or v13:IsInVehicle())) then
			if ((v53.SummonPet:IsCastable() and v41) or ((973 + 926) <= (1086 - (28 + 141)))) then
				if (v26(v54[v42]) or ((1671 + 2641) <= (1081 - 205))) then
					return "Summon Pet";
				end
			end
			if (((1581 + 651) <= (3913 - (486 + 831))) and v53.RevivePet:IsCastable() and v44 and v17:IsDeadOrGhost()) then
				if (((5451 - 3356) < (12976 - 9290)) and v26(v53.RevivePet)) then
					return "Revive Pet";
				end
			end
			if ((v53.MendPet:IsCastable() and v45 and (v17:HealthPercentage() < v46)) or ((302 + 1293) >= (14146 - 9672))) then
				if (v26(v53.MendPet) or ((5882 - (668 + 595)) < (2594 + 288))) then
					return "Mend Pet High Priority";
				end
			end
		end
		if (v51.TargetIsValid() or ((60 + 234) >= (13174 - 8343))) then
			local v116 = 290 - (23 + 267);
			local v117;
			local v118;
			while true do
				if (((3973 - (1129 + 815)) <= (3471 - (371 + 16))) and (v116 == (1751 - (1326 + 424)))) then
					if (v118 or ((3857 - 1820) == (8843 - 6423))) then
						return v118;
					end
					if (((4576 - (88 + 30)) > (4675 - (720 + 51))) and v29) then
						local v129 = v81();
						if (((969 - 533) >= (1899 - (421 + 1355))) and v129) then
							return v129;
						end
					end
					v117 = v82();
					if (((824 - 324) < (893 + 923)) and v117) then
						return v117;
					end
					v116 = 1085 - (286 + 797);
				end
				if (((13065 - 9491) == (5919 - 2345)) and (v116 == (439 - (397 + 42)))) then
					if (((70 + 151) < (1190 - (24 + 776))) and not v13:AffectingCombat() and not v27) then
						local v130 = v80();
						if (v130 or ((3409 - 1196) <= (2206 - (222 + 563)))) then
							return v130;
						end
					end
					v117 = v85();
					if (((6737 - 3679) < (3500 + 1360)) and v117) then
						return v117;
					end
					v118 = v51.HandleDPSPotion();
					v116 = 191 - (23 + 167);
				end
				if ((v116 == (1800 - (690 + 1108))) or ((468 + 828) >= (3668 + 778))) then
					if ((v64 > (850 - (40 + 808))) or (v53.BeastCleave:IsAvailable() and (v64 > (1 + 0))) or ((5326 - 3933) > (4291 + 198))) then
						local v131 = 0 + 0;
						local v132;
						while true do
							if ((v131 == (0 + 0)) or ((4995 - (47 + 524)) < (18 + 9))) then
								v132 = v83();
								if (v132 or ((5458 - 3461) > (5704 - 1889))) then
									return v132;
								end
								break;
							end
						end
					end
					if (((7902 - 4437) > (3639 - (1165 + 561))) and ((v64 < (1 + 1)) or (not v53.BeastCleave:IsAvailable() and (v64 < (9 - 6))))) then
						local v133 = 0 + 0;
						local v134;
						while true do
							if (((1212 - (341 + 138)) < (492 + 1327)) and (v133 == (0 - 0))) then
								v134 = v84();
								if (v134 or ((4721 - (89 + 237)) == (15296 - 10541))) then
									return v134;
								end
								break;
							end
						end
					end
					if ((not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53.MendPet:IsCastable() and (v17:HealthPercentage() < v46) and v45) or ((7985 - 4192) < (3250 - (581 + 300)))) then
						if (v26(v53.MendPet) or ((5304 - (855 + 365)) == (629 - 364))) then
							return "Mend Pet Low Priority (w/ Target)";
						end
					end
					break;
				end
			end
		end
		if (((1423 + 2935) == (5593 - (1030 + 205))) and not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53.MendPet:IsCastable() and (v17:HealthPercentage() < v46) and v45) then
			if (v26(v53.MendPet) or ((2946 + 192) < (924 + 69))) then
				return "Mend Pet Low Priority (w/o Target)";
			end
		end
	end
	local function v87()
		v10.Print("Beast Mastery by Epic. Supported by Gojira");
		local v109 = (v53.Growl:IsPetKnown() and v20.FindBySpellID(v53.Growl:ID()) and v53.Growl) or nil;
		if (((3616 - (156 + 130)) > (5278 - 2955)) and not v109) then
			v10.Print("|cffffff00Info|r: Add pet abilities to your action bars to improve range checks.");
		end
	end
	v10.SetAPL(426 - 173, v86, v87);
end;
return v0["Epix_Hunter_BeastMastery.lua"]();

