local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 806 - (118 + 688);
	local v6;
	while true do
		if ((v5 == (49 - (25 + 23))) or ((243 + 1011) >= (3611 - (927 + 959)))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((1141 - (16 + 716)) >= (7381 - 3557))) then
			v6 = v0[v4];
			if (((2184 - (11 + 86)) == (5090 - 3003)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 286 - (175 + 110);
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
		local v87 = 0 - 0;
		while true do
			if ((v87 == (19 - 15)) or ((5200 - (503 + 1293)) > (12575 - 8072))) then
				v48 = EpicSettings.Settings['ExhilarationHP'] or (0 + 0);
				v49 = EpicSettings.Settings['UseTranq'];
				break;
			end
			if ((v87 == (1064 - (810 + 251))) or ((2434 + 1072) <= (402 + 907))) then
				v44 = EpicSettings.Settings['UseRevive'];
				v45 = EpicSettings.Settings['UseMendPet'];
				v46 = EpicSettings.Settings['MendPetHP'] or (0 + 0);
				v47 = EpicSettings.Settings['UseExhilaration'];
				v87 = 537 - (43 + 490);
			end
			if (((3688 - (711 + 22)) == (11430 - 8475)) and (v87 == (859 - (240 + 619)))) then
				v31 = EpicSettings.Settings['UseRacials'];
				v33 = EpicSettings.Settings['UseHealingPotion'];
				v34 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v35 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v87 = 1 + 0;
			end
			if (((1746 - (1344 + 400)) == v87) or ((3308 - (255 + 150)) == (1178 + 317))) then
				v40 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v41 = EpicSettings.Settings['UsePet'];
				v42 = EpicSettings.Settings['SummonPetSlot'] or (0 - 0);
				v43 = EpicSettings.Settings['UseSteelTrap'];
				v87 = 9 - 6;
			end
			if (((6285 - (404 + 1335)) >= (2681 - (183 + 223))) and (v87 == (1 - 0))) then
				v36 = EpicSettings.Settings['UseHealthstone'];
				v37 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v38 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v39 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (337 - (10 + 327));
				v87 = 2 + 0;
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
	local v60 = 12604 - (711 + 782);
	local v61 = 21299 - 10188;
	v10:RegisterForEvent(function()
		local v88 = 469 - (270 + 199);
		while true do
			if (((266 + 553) >= (1841 - (580 + 1239))) and (v88 == (0 - 0))) then
				v60 = 10624 + 487;
				v61 = 400 + 10711;
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
		return (v92:DebuffStack(v53.LatentPoisonDebuff) > (1799 - (1010 + 780))) and ((v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + 0.25 + 0))) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < ((57 - 45) + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < (8 - 5)) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp())) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown()));
	end
	local function v73(v93)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + (1836.25 - (1045 + 791))))) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < ((30 - 18) + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < (4 - 1)) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp())) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown());
	end
	local function v74(v94)
		return (v94:DebuffStack(v53.LatentPoisonDebuff) > (514 - (351 + 154))) and (v13:BuffUp(v53.CalloftheWildBuff) or (v61 < (1583 - (1281 + 293))) or (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (267.2 - (28 + 238)))) or v53.Savagery:IsAvailable());
	end
	local function v75(v95)
		return v13:BuffUp(v53.CalloftheWildBuff) or (v61 < (19 - 10)) or (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1560.2 - (1381 + 178)))) or v53.Savagery:IsAvailable();
	end
	local function v76(v96)
		return v96:DebuffRefreshable(v53.SerpentStingDebuff) and (v96:TimeToDie() > v53.SerpentStingDebuff:BaseDuration());
	end
	local function v77(v97)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + 0.25 + 0))) or (v53.ScentofBlood:IsAvailable() and (v17:BuffStack(v53.FrenzyPetBuff) < (3 + 0)) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp()));
	end
	local function v78(v98)
		return (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1.4 + 0))) or v13:BuffUp(v53.CalloftheWildBuff) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown()) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < ((41 - 29) + v59))) or v53.Savagery:IsAvailable() or (v61 < (5 + 4));
	end
	local function v79(v99)
		return v99:DebuffRefreshable(v53.SerpentStingDebuff) and (v14:TimeToDie() > v53.SerpentStingDebuff:BaseDuration());
	end
	local function v80()
		if (((3632 - (381 + 89)) == (2805 + 357)) and v15:Exists() and v53.Misdirection:IsReady()) then
			if (v26(v57.MisdirectionFocus) or ((1603 + 766) > (7586 - 3157))) then
				return "misdirection precombat 0";
			end
		end
		if (((5251 - (1074 + 82)) >= (6975 - 3792)) and v53.SteelTrap:IsCastable() and not v53.WailingArrow:IsAvailable() and v53.SteelTrap:IsAvailable()) then
			if (v26(v53.SteelTrap) or ((5495 - (214 + 1570)) < (2463 - (990 + 465)))) then
				return "steel_trap precombat 2";
			end
		end
		if ((v53.BarbedShot:IsCastable() and (v53.BarbedShot:Charges() >= (1 + 1))) or ((457 + 592) <= (882 + 24))) then
			if (((17760 - 13247) > (4452 - (1668 + 58))) and v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot))) then
				return "barbed_shot precombat 8";
			end
		end
		if (v53.KillShot:IsReady() or ((2107 - (512 + 114)) >= (6929 - 4271))) then
			if (v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot)) or ((6656 - 3436) == (4746 - 3382))) then
				return "kill_shot precombat 10";
			end
		end
		if ((v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (10 + 10))) or ((198 + 856) > (2949 + 443))) then
			if (v26(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot)) or ((2280 - 1604) >= (3636 - (109 + 1885)))) then
				return "kill_shot_mouseover precombat 11";
			end
		end
		if (((5605 - (1269 + 200)) > (4594 - 2197)) and v53.KillCommand:IsReady()) then
			if (v26(v57.KillCommandPetAttack) or ((5149 - (98 + 717)) == (5071 - (802 + 24)))) then
				return "kill_command precombat 12";
			end
		end
		if ((v64 > (1 - 0)) or ((5400 - 1124) <= (448 + 2583))) then
			if (v53.MultiShot:IsReady() or ((3675 + 1107) <= (197 + 1002))) then
				if (v26(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot)) or ((1050 + 3814) < (5291 - 3389))) then
					return "multishot precombat 14";
				end
			end
		elseif (((16136 - 11297) >= (1324 + 2376)) and v53.CobraShot:IsReady()) then
			if (v26(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot)) or ((438 + 637) > (1583 + 335))) then
				return "cobra_shot precombat 16";
			end
		end
	end
	local function v81()
		local v100 = 0 + 0;
		while true do
			if (((185 + 211) <= (5237 - (797 + 636))) and (v100 == (0 - 0))) then
				if ((v53.Berserking:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (1632 - (1427 + 192))))) or ((1445 + 2724) == (5077 - 2890))) then
					if (((1264 + 142) == (638 + 768)) and v26(v53.Berserking, nil, nil, true)) then
						return "berserking cds 2";
					end
				end
				if (((1857 - (192 + 134)) < (5547 - (316 + 960))) and v53.BloodFury:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (9 + 7)))) then
					if (((491 + 144) == (587 + 48)) and v26(v53.BloodFury, nil, nil, true)) then
						return "blood_fury cds 8";
					end
				end
				v100 = 3 - 2;
			end
			if (((3924 - (83 + 468)) <= (5362 - (1202 + 604))) and (v100 == (4 - 3))) then
				if ((v53.AncestralCall:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (26 - 10)))) or ((9111 - 5820) < (3605 - (45 + 280)))) then
					if (((4234 + 152) >= (763 + 110)) and v26(v53.AncestralCall)) then
						return "ancestral_call cds 10";
					end
				end
				if (((337 + 584) <= (610 + 492)) and v53.Fireblood:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (2 + 7)))) then
					if (((8714 - 4008) >= (2874 - (340 + 1571))) and v26(v53.Fireblood)) then
						return "fireblood cds 12";
					end
				end
				break;
			end
		end
	end
	local function v82()
		local v101 = v51.HandleTopTrinket(v56, v29, 16 + 24, nil);
		if (v101 or ((2732 - (1733 + 39)) <= (2407 - 1531))) then
			return v101;
		end
		local v101 = v51.HandleBottomTrinket(v56, v29, 1074 - (125 + 909), nil);
		if (v101 or ((4014 - (1096 + 852)) == (419 + 513))) then
			return v101;
		end
	end
	local function v83()
		if (((6890 - 2065) < (4698 + 145)) and v53.BarbedShot:IsCastable()) then
			if (v51.CastTargetIf(v53.BarbedShot, v62, "max", v70, v72, not v14:IsSpellInRange(v53.BarbedShot)) or ((4389 - (409 + 103)) >= (4773 - (46 + 190)))) then
				return "barbed_shot cleave 2";
			end
		end
		if (v53.BarbedShot:IsCastable() or ((4410 - (51 + 44)) < (487 + 1239))) then
			if (v51.CastTargetIf(v53.BarbedShot, v62, "min", v69, v73, not v14:IsSpellInRange(v53.BarbedShot)) or ((4996 - (1114 + 203)) < (1351 - (228 + 498)))) then
				return "barbed_shot cleave 4";
			end
		end
		if ((v53.MultiShot:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < (0.25 + 0 + v59)) and (not v53.BloodyFrenzy:IsAvailable() or v53.CalloftheWild:CooldownDown())) or ((2556 + 2069) < (1295 - (174 + 489)))) then
			if (v26(v53.MultiShot, nil, nil, not v14:IsSpellInRange(v53.MultiShot)) or ((216 - 133) > (3685 - (830 + 1075)))) then
				return "multishot cleave 6";
			end
		end
		if (((1070 - (303 + 221)) <= (2346 - (231 + 1038))) and v53.BestialWrath:IsCastable() and v29) then
			if (v26(v53.BestialWrath) or ((830 + 166) > (5463 - (171 + 991)))) then
				return "bestial_wrath cleave 8";
			end
		end
		if (((16773 - 12703) > (1844 - 1157)) and v53.CalloftheWild:IsCastable() and v29) then
			if (v25(v53.CalloftheWild) or ((1636 - 980) >= (2666 + 664))) then
				return "call_of_the_wild cleave 10";
			end
		end
		if ((v53.KillCommand:IsReady() and (v53.KillCleave:IsAvailable())) or ((8735 - 6243) <= (966 - 631))) then
			if (((6966 - 2644) >= (7919 - 5357)) and v25(v53.KillCommand, nil, nil, not v14:IsInRange(1298 - (111 + 1137)))) then
				return "kill_command cleave 12";
			end
		end
		if (v53.ExplosiveShot:IsReady() or ((3795 - (91 + 67)) >= (11220 - 7450))) then
			if (v26(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot)) or ((594 + 1785) > (5101 - (423 + 100)))) then
				return "explosive_shot cleave 12";
			end
		end
		if ((v53.Stampede:IsCastable() and v29) or ((4 + 479) > (2056 - 1313))) then
			if (((1280 + 1174) > (1349 - (326 + 445))) and v26(v53.Stampede, not v14:IsSpellInRange(v53.Stampede))) then
				return "stampede cleave 14";
			end
		end
		if (((4058 - 3128) < (9931 - 5473)) and v53.Bloodshed:IsCastable()) then
			if (((1544 - 882) <= (1683 - (530 + 181))) and v26(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed))) then
				return "bloodshed cleave 16";
			end
		end
		if (((5251 - (614 + 267)) == (4402 - (19 + 13))) and v53.DeathChakram:IsCastable() and v29) then
			if (v26(v53.DeathChakram, not v14:IsSpellInRange(v53.DeathChakram)) or ((7750 - 2988) <= (2006 - 1145))) then
				return "death_chakram cleave 18";
			end
		end
		if (v53.SteelTrap:IsCastable() or ((4033 - 2621) == (1108 + 3156))) then
			if (v26(v57.SteelTrap) or ((5571 - 2403) < (4464 - 2311))) then
				return "steel_trap cleave 22";
			end
		end
		if ((v53.AMurderofCrows:IsReady() and v29) or ((6788 - (1293 + 519)) < (2717 - 1385))) then
			if (((12083 - 7455) == (8849 - 4221)) and v26(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows))) then
				return "a_murder_of_crows cleave 24";
			end
		end
		if (v53.BarbedShot:IsCastable() or ((232 - 178) == (930 - 535))) then
			if (((44 + 38) == (17 + 65)) and v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "max", v70, v74, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
				return "barbed_shot cleave 26";
			end
		end
		if (v53.BarbedShot:IsCastable() or ((1349 - 768) < (66 + 216))) then
			if (v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v75, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover) or ((1532 + 3077) < (1560 + 935))) then
				return "barbed_shot cleave 28";
			end
		end
		if (((2248 - (709 + 387)) == (3010 - (673 + 1185))) and v53.KillCommand:IsReady()) then
			if (((5498 - 3602) <= (10988 - 7566)) and v26(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand))) then
				return "kill_command cleave 30";
			end
		end
		if (v53.DireBeast:IsCastable() or ((1628 - 638) > (1159 + 461))) then
			if (v26(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast)) or ((656 + 221) > (6338 - 1643))) then
				return "dire_beast cleave 32";
			end
		end
		if (((661 + 2030) >= (3690 - 1839)) and v53.SerpentSting:IsReady()) then
			if (v51.CastTargetIf(v53.SerpentSting, v62, "min", v71, v76, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover) or ((5859 - 2874) >= (6736 - (446 + 1434)))) then
				return "serpent_sting cleave 34";
			end
		end
		if (((5559 - (1040 + 243)) >= (3566 - 2371)) and v53.Barrage:IsReady() and (v17:BuffRemains(v53.FrenzyPetBuff) > v53.Barrage:ExecuteTime())) then
			if (((5079 - (559 + 1288)) <= (6621 - (609 + 1322))) and v26(v53.Barrage, not v14:IsSpellInRange(v53.Barrage))) then
				return "barrage cleave 36";
			end
		end
		if ((v53.MultiShot:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < (v13:GCD() * (456 - (13 + 441))))) or ((3347 - 2451) >= (8240 - 5094))) then
			if (((15245 - 12184) >= (111 + 2847)) and v26(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot))) then
				return "multishot cleave 38";
			end
		end
		if (((11574 - 8387) >= (229 + 415)) and v53.AspectoftheWild:IsCastable() and v29) then
			if (((283 + 361) <= (2089 - 1385)) and v26(v53.AspectoftheWild)) then
				return "aspect_of_the_wild cleave 40";
			end
		end
		if (((525 + 433) > (1741 - 794)) and v29 and v53.LightsJudgment:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v14:TimeToDie() < (4 + 1)))) then
			if (((2499 + 1993) >= (1907 + 747)) and v25(v53.LightsJudgment, nil, not v14:IsInRange(5 + 0))) then
				return "lights_judgment cleave 40";
			end
		end
		if (((3368 + 74) >= (1936 - (153 + 280))) and v53.KillShot:IsReady()) then
			if (v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot)) or ((9153 - 5983) <= (1315 + 149))) then
				return "kill_shot cleave 38";
			end
		end
		if ((v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (8 + 12))) or ((2511 + 2286) == (3983 + 405))) then
			if (((400 + 151) <= (1036 - 355)) and v26(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot))) then
				return "kill_shot_mouseover cleave 39";
			end
		end
		if (((2026 + 1251) > (1074 - (89 + 578))) and v53.CobraShot:IsReady() and (v13:FocusTimeToMax() < (v59 * (2 + 0)))) then
			if (((9760 - 5065) >= (2464 - (572 + 477))) and v26(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot))) then
				return "cobra_shot cleave 42";
			end
		end
		if ((v53.WailingArrow:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53.WailingArrow:ExecuteTime()) or (v61 < (1 + 4)))) or ((1928 + 1284) <= (113 + 831))) then
			if (v26(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow), true) or ((3182 - (84 + 2)) <= (2963 - 1165))) then
				return "wailing_arrow cleave 44";
			end
		end
		if (((2549 + 988) == (4379 - (497 + 345))) and v53.BagofTricks:IsCastable() and v29 and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (1 + 4)))) then
			if (((649 + 3188) >= (2903 - (605 + 728))) and v26(v53.BagofTricks)) then
				return "bag_of_tricks cleave 46";
			end
		end
		if ((v53.ArcaneTorrent:IsCastable() and v29 and ((v13:Focus() + v13:FocusRegen() + 22 + 8) < v13:FocusMax())) or ((6558 - 3608) == (175 + 3637))) then
			if (((17461 - 12738) >= (2090 + 228)) and v26(v53.ArcaneTorrent)) then
				return "arcane_torrent cleave 48";
			end
		end
	end
	local function v84()
		local v102 = 0 - 0;
		while true do
			if (((1 + 0) == v102) or ((2516 - (457 + 32)) > (1211 + 1641))) then
				if ((v53.BestialWrath:IsCastable() and v29) or ((2538 - (832 + 570)) > (4067 + 250))) then
					if (((1239 + 3509) == (16802 - 12054)) and v26(v53.BestialWrath)) then
						return "bestial_wrath st 20";
					end
				end
				if (((1800 + 1936) <= (5536 - (588 + 208))) and v53.Bloodshed:IsCastable()) then
					if (v26(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed)) or ((9136 - 5746) <= (4860 - (884 + 916)))) then
						return "bloodshed st 10";
					end
				end
				if ((v53.DeathChakram:IsCastable() and v29) or ((2091 - 1092) > (1562 + 1131))) then
					if (((1116 - (232 + 421)) < (2490 - (1569 + 320))) and v26(v53.DeathChakram, not v14:IsSpellInRange(v53.DeathChakram))) then
						return "death_chakram st 8";
					end
				end
				if (v53.KillCommand:IsReady() or ((536 + 1647) < (131 + 556))) then
					if (((15328 - 10779) == (5154 - (316 + 289))) and v26(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand))) then
						return "kill_command st 22";
					end
				end
				v102 = 5 - 3;
			end
			if (((216 + 4456) == (6125 - (666 + 787))) and ((427 - (360 + 65)) == v102)) then
				if ((v53.AMurderofCrows:IsCastable() and v29) or ((3428 + 240) < (649 - (79 + 175)))) then
					if (v26(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows)) or ((6568 - 2402) == (356 + 99))) then
						return "a_murder_of_crows st 14";
					end
				end
				if (v53.SteelTrap:IsCastable() or ((13637 - 9188) == (5128 - 2465))) then
					if (v26(v53.SteelTrap) or ((5176 - (503 + 396)) < (3170 - (92 + 89)))) then
						return "steel_trap st 16";
					end
				end
				if (v53.ExplosiveShot:IsReady() or ((1687 - 817) >= (2128 + 2021))) then
					if (((1310 + 902) < (12465 - 9282)) and v26(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot))) then
						return "explosive_shot st 18";
					end
				end
				if (((636 + 4010) > (6821 - 3829)) and v53.BarbedShot:IsCastable()) then
					if (((1252 + 182) < (1484 + 1622)) and v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v78, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
						return "barbed_shot st 24";
					end
				end
				v102 = 8 - 5;
			end
			if (((99 + 687) < (4609 - 1586)) and (v102 == (1247 - (485 + 759)))) then
				if ((v53.BarbedShot:IsCastable() and v78(v14)) or ((5650 - 3208) < (1263 - (442 + 747)))) then
					if (((5670 - (832 + 303)) == (5481 - (88 + 858))) and v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot))) then
						return "barbed_shot st mt_backup 25";
					end
				end
				if (v53.DireBeast:IsCastable() or ((918 + 2091) <= (1743 + 362))) then
					if (((76 + 1754) < (4458 - (766 + 23))) and v26(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast))) then
						return "dire_beast st 26";
					end
				end
				if (v53.SerpentSting:IsReady() or ((7059 - 5629) >= (4939 - 1327))) then
					if (((7068 - 4385) >= (8349 - 5889)) and v51.CastTargetIf(v53.SerpentSting, v62, "min", v71, v79, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover)) then
						return "serpent_sting st 28";
					end
				end
				if ((v53.Stampede:IsCastable() and v29) or ((2877 - (1036 + 37)) >= (2322 + 953))) then
					if (v26(v53.Stampede, not v14:IsSpellInRange(v53.Stampede)) or ((2759 - 1342) > (2855 + 774))) then
						return "stampede st 12";
					end
				end
				v102 = 1484 - (641 + 839);
			end
			if (((5708 - (910 + 3)) > (1024 - 622)) and (v102 == (1689 - (1466 + 218)))) then
				if (((2212 + 2601) > (4713 - (556 + 592))) and v53.WailingArrow:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53.WailingArrow:ExecuteTime()) or (v61 < (2 + 3)))) then
					if (((4720 - (329 + 479)) == (4766 - (174 + 680))) and v26(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow), true)) then
						return "wailing_arrow st 36";
					end
				end
				if (((9693 - 6872) <= (9998 - 5174)) and v29) then
					if (((1241 + 497) <= (2934 - (396 + 343))) and v53.BagofTricks:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (1 + 4)))) then
						if (((1518 - (29 + 1448)) <= (4407 - (135 + 1254))) and v26(v53.BagofTricks)) then
							return "bag_of_tricks st 38";
						end
					end
					if (((8080 - 5935) <= (19162 - 15058)) and v53.ArcanePulse:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (4 + 1)))) then
						if (((4216 - (389 + 1138)) < (5419 - (102 + 472))) and v26(v53.ArcanePulse)) then
							return "arcane_pulse st 40";
						end
					end
					if ((v53.ArcaneTorrent:IsCastable() and ((v13:Focus() + v13:FocusRegen() + 15 + 0) < v13:FocusMax())) or ((1288 + 1034) > (2445 + 177))) then
						if (v26(v53.ArcaneTorrent) or ((6079 - (320 + 1225)) == (3705 - 1623))) then
							return "arcane_torrent st 42";
						end
					end
				end
				break;
			end
			if ((v102 == (0 + 0)) or ((3035 - (157 + 1307)) > (3726 - (821 + 1038)))) then
				if (v53.BarbedShot:IsCastable() or ((6621 - 3967) >= (328 + 2668))) then
					if (((7065 - 3087) > (783 + 1321)) and v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v77, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
						return "barbed_shot st 2";
					end
				end
				if (((7423 - 4428) > (2567 - (834 + 192))) and v53.BarbedShot:IsCastable() and v77(v14)) then
					if (((207 + 3042) > (245 + 708)) and v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot))) then
						return "barbed_shot st mt_backup 3";
					end
				end
				if ((v53.CalloftheWild:IsCastable() and v29) or ((71 + 3202) > (7084 - 2511))) then
					if (v26(v53.CalloftheWild) or ((3455 - (300 + 4)) < (343 + 941))) then
						return "call_of_the_wild st 6";
					end
				end
				if ((v53.KillCommand:IsReady() and (v53.KillCommand:FullRechargeTime() < v59) and v53.AlphaPredator:IsAvailable()) or ((4842 - 2992) == (1891 - (112 + 250)))) then
					if (((328 + 493) < (5318 - 3195)) and v26(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand))) then
						return "kill_command st 4";
					end
				end
				v102 = 1 + 0;
			end
			if (((467 + 435) < (1739 + 586)) and (v102 == (2 + 2))) then
				if (((638 + 220) <= (4376 - (1001 + 413))) and v53.KillShot:IsReady()) then
					if (v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot)) or ((8799 - 4853) < (2170 - (244 + 638)))) then
						return "kill_shot st 30";
					end
				end
				if ((v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (713 - (627 + 66)))) or ((9659 - 6417) == (1169 - (512 + 90)))) then
					if (v26(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot)) or ((2753 - (1665 + 241)) >= (1980 - (373 + 344)))) then
						return "kill_shot_mouseover st 31";
					end
				end
				if ((v53.AspectoftheWild:IsCastable() and v29) or ((1017 + 1236) == (490 + 1361))) then
					if (v26(v53.AspectoftheWild) or ((5504 - 3417) > (4013 - 1641))) then
						return "aspect_of_the_wild st 32";
					end
				end
				if (v53.CobraShot:IsReady() or ((5544 - (35 + 1064)) < (3019 + 1130))) then
					if (v26(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot)) or ((3889 - 2071) == (1 + 84))) then
						return "cobra_shot st 34";
					end
				end
				v102 = 1241 - (298 + 938);
			end
		end
	end
	local function v85()
		v50();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		if (((1889 - (233 + 1026)) < (3793 - (636 + 1030))) and v53.Stomp:IsAvailable()) then
			v10.SplashEnemies.ChangeFriendTargetsTracking("Mine Only");
		else
			v10.SplashEnemies.ChangeFriendTargetsTracking("All");
		end
		local v106 = (v53.BloodBolt:IsPetKnown() and v53.BloodBolt) or (v53.Bite:IsPetKnown() and v53.Bite) or (v53.Claw:IsPetKnown() and v53.Claw) or (v53.Smack:IsPetKnown() and v53.Smack) or nil;
		local v107 = (v53.Growl:IsPetKnown() and v20.FindBySpellID(v53.Growl:ID()) and v53.Growl) or nil;
		if (v23() or ((991 + 947) == (2456 + 58))) then
			v62 = v13:GetEnemiesInRange(12 + 28);
			v63 = (v106 and v13:GetEnemiesInSpellActionRange(v106)) or v14:GetEnemiesInSplashRange(1 + 7);
			v64 = (v106 and #v63) or v14:GetEnemiesInSplashRangeCount(229 - (55 + 166));
		else
			local v111 = 0 + 0;
			while true do
				if (((428 + 3827) >= (209 - 154)) and (v111 == (297 - (36 + 261)))) then
					v62 = {};
					v63 = v14 or {};
					v111 = 1 - 0;
				end
				if (((4367 - (34 + 1334)) > (445 + 711)) and (v111 == (1 + 0))) then
					v64 = 1283 - (1035 + 248);
					break;
				end
			end
		end
		v65 = v14:IsInRange(61 - (20 + 1));
		v66 = v14:IsInRange(16 + 14);
		v67 = (v107 and v14:IsSpellInActionRange(v107)) or v14:IsInRange(349 - (134 + 185));
		v59 = v13:GCD() + (1133.15 - (549 + 584));
		if (((3035 - (314 + 371)) > (3964 - 2809)) and (v51.TargetIsValid() or v13:AffectingCombat())) then
			v60 = v10.BossFightRemains(nil, true);
			v61 = v60;
			if (((4997 - (478 + 490)) <= (2571 + 2282)) and (v61 == (12283 - (786 + 386)))) then
				v61 = v10.FightRemains(v62, false);
			end
		end
		if ((v53.Exhilaration:IsCastable() and v53.Exhilaration:IsReady() and (v13:HealthPercentage() <= v48)) or ((1671 - 1155) > (4813 - (1055 + 324)))) then
			if (((5386 - (1093 + 247)) >= (2696 + 337)) and v26(v53.Exhilaration)) then
				return "Exhilaration";
			end
		end
		if (((v13:HealthPercentage() <= v37) and v36 and v55.Healthstone:IsReady() and v55.Healthstone:IsUsable()) or ((286 + 2433) <= (5744 - 4297))) then
			if (v26(v57.Healthstone, nil, nil, true) or ((14029 - 9895) < (11171 - 7245))) then
				return "healthstone defensive 3";
			end
		end
		if (not (v13:IsMounted() or v13:IsInVehicle()) or ((411 - 247) >= (991 + 1794))) then
			local v112 = 0 - 0;
			while true do
				if ((v112 == (3 - 2)) or ((396 + 129) == (5393 - 3284))) then
					if (((721 - (364 + 324)) == (90 - 57)) and v53.MendPet:IsCastable() and v45 and (v17:HealthPercentage() < v46)) then
						if (((7328 - 4274) <= (1331 + 2684)) and v26(v53.MendPet)) then
							return "Mend Pet High Priority";
						end
					end
					break;
				end
				if (((7828 - 5957) < (5415 - 2033)) and (v112 == (0 - 0))) then
					if (((2561 - (1249 + 19)) <= (1956 + 210)) and v53.SummonPet:IsCastable() and v41) then
						if (v26(v54[v42]) or ((10038 - 7459) < (1209 - (686 + 400)))) then
							return "Summon Pet";
						end
					end
					if ((v53.RevivePet:IsCastable() and v44 and v17:IsDeadOrGhost()) or ((664 + 182) >= (2597 - (73 + 156)))) then
						if (v26(v53.RevivePet) or ((19 + 3993) <= (4169 - (721 + 90)))) then
							return "Revive Pet";
						end
					end
					v112 = 1 + 0;
				end
			end
		end
		if (((4850 - 3356) <= (3475 - (224 + 246))) and v51.TargetIsValid()) then
			if ((not v13:AffectingCombat() and not v27) or ((5039 - 1928) == (3928 - 1794))) then
				local v123 = 0 + 0;
				local v124;
				while true do
					if (((57 + 2298) == (1730 + 625)) and (v123 == (0 - 0))) then
						v124 = v80();
						if (v124 or ((1956 - 1368) <= (945 - (203 + 310)))) then
							return v124;
						end
						break;
					end
				end
			end
			local v113 = v51.Interrupt(2033 - (1238 + 755), v53.CounterShot, v68);
			if (((336 + 4461) >= (5429 - (709 + 825))) and v113) then
				return v113;
			end
			if (((6591 - 3014) == (5210 - 1633)) and v29) then
				local v125 = 864 - (196 + 668);
				local v126;
				while true do
					if (((14979 - 11185) > (7649 - 3956)) and (v125 == (833 - (171 + 662)))) then
						v126 = v81();
						if (v126 or ((1368 - (4 + 89)) == (14370 - 10270))) then
							return v126;
						end
						break;
					end
				end
			end
			if ((v32 and v29) or ((580 + 1011) >= (15724 - 12144))) then
				local v127 = v82();
				if (((386 + 597) <= (3294 - (35 + 1451))) and v127) then
					return v127;
				end
			end
			if ((v64 < (1455 - (28 + 1425))) or (not v53.BeastCleave:IsAvailable() and (v64 < (1996 - (941 + 1052)))) or ((2062 + 88) <= (2711 - (822 + 692)))) then
				local v128 = 0 - 0;
				local v129;
				while true do
					if (((1776 + 1993) >= (1470 - (45 + 252))) and (v128 == (0 + 0))) then
						v129 = v84();
						if (((512 + 973) == (3614 - 2129)) and v129) then
							return v129;
						end
						break;
					end
				end
			end
			if ((v64 > (435 - (114 + 319))) or (v53.BeastCleave:IsAvailable() and (v64 > (1 - 0))) or ((4247 - 932) <= (1774 + 1008))) then
				local v130 = 0 - 0;
				local v131;
				while true do
					if ((v130 == (0 - 0)) or ((2839 - (556 + 1407)) >= (4170 - (741 + 465)))) then
						v131 = v83();
						if (v131 or ((2697 - (170 + 295)) > (1316 + 1181))) then
							return v131;
						end
						break;
					end
				end
			end
			if ((not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53.MendPet:IsCastable() and (v17:HealthPercentage() < v46) and v45) or ((1939 + 171) <= (817 - 485))) then
				if (((3056 + 630) > (2035 + 1137)) and v26(v53.MendPet)) then
					return "Mend Pet Low Priority (w/ Target)";
				end
			end
			if (v26(v53.PoolFocus) or ((2534 + 1940) < (2050 - (957 + 273)))) then
				return "Pooling Focus";
			end
		end
		if (((1145 + 3134) >= (1154 + 1728)) and not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53.MendPet:IsCastable() and (v17:HealthPercentage() < v46) and v45) then
			if (v26(v53.MendPet) or ((7731 - 5702) >= (9278 - 5757))) then
				return "Mend Pet Low Priority (w/o Target)";
			end
		end
	end
	local function v86()
		local v108 = 0 - 0;
		local v109;
		while true do
			if ((v108 == (4 - 3)) or ((3817 - (389 + 1391)) >= (2913 + 1729))) then
				if (((180 + 1540) < (10149 - 5691)) and not v109) then
					v10.Print("|cffffff00Info|r: Add pet abilities to your action bars to improve range checks.");
				end
				break;
			end
			if ((v108 == (951 - (783 + 168))) or ((1463 - 1027) > (2972 + 49))) then
				v10.Print("Beast Mastery by Epic. Supported by Gojira");
				v109 = (v53.Growl:IsPetKnown() and v20.FindBySpellID(v53.Growl:ID()) and v53.Growl) or nil;
				v108 = 312 - (309 + 2);
			end
		end
	end
	v10.SetAPL(776 - 523, v85, v86);
end;
return v0["Epix_Hunter_BeastMastery.lua"]();

