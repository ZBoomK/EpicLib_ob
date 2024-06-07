local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = v1[v5];
	if (not v6 or ((3994 - (404 + 1335)) < (428 - (183 + 223)))) then
		return v2(v5, v0, ...);
	end
	return v6(v0, ...);
end
v1["Epix_Hunter_BeastMastery.lua"] = function(...)
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
		v34 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
		v35 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v36 = EpicSettings.Settings['UseHealthstone'];
		v37 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v38 = EpicSettings.Settings['InterruptWithStun'] or (337 - (10 + 327));
		v39 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
		v40 = EpicSettings.Settings['InterruptThreshold'] or (338 - (118 + 220));
		v41 = EpicSettings.Settings['UsePet'];
		v42 = EpicSettings.Settings['SummonPetSlot'] or (0 + 0);
		v43 = EpicSettings.Settings['UseSteelTrap'];
		v44 = EpicSettings.Settings['UseRevive'];
		v45 = EpicSettings.Settings['UseMendPet'];
		v46 = EpicSettings.Settings['MendPetHP'] or (449 - (108 + 341));
		v47 = EpicSettings.Settings['UseExhilaration'];
		v48 = EpicSettings.Settings['ExhilarationHP'] or (0 + 0);
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
	local v60 = 12930 - (580 + 1239);
	local v61 = 33030 - 21919;
	local v62 = true;
	local v63 = false;
	local v64 = false;
	local v65 = 0 + 0;
	local v66 = not Trinket2:HasCooldown() or (Trinket1:HasUseBuff() and (not Trinket2:HasUseBuff() or ((not Trinket1:ID() == v55.MirrorofFracturedTomorrows:ID()) and ((Trinket2:ID() == v55.MirrorofFracturedTomorrows:ID()) or (Trinket2:Cooldown() < Trinket1:Cooldown()) or (Trinket2:CastTime() < Trinket1:CastTime()) or ((Trinket2:CastTime() == Trinket1:CastTime()) and (Trinket2:Cooldown() == Trinket1:Cooldown())))))) or (not Trinket1:HasUseBuff() and not Trinket2:HasUseBuff() and ((Trinket2:Cooldown() < Trinket1:Cooldown()) or (Trinket2:CastTime() < Trinket1:CastTime()) or ((Trinket2:CastTime() == Trinket1:CastTime()) and (Trinket2:Cooldown() == Trinket1:Cooldown()))));
	local v67 = not v66;
	v10:RegisterForEvent(function()
		local v103 = 0 + 0;
		while true do
			if ((v103 == (0 + 0)) or ((2835 - 1749) >= (873 + 532))) then
				v60 = 12278 - (645 + 522);
				v61 = 12901 - (1010 + 780);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		Equip = v13:GetEquipment();
		Trinket1 = (Equip[13 + 0] and v19(Equip[61 - 48])) or v19(0 - 0);
		Trinket2 = (Equip[1850 - (1045 + 791)] and v19(Equip[34 - 20])) or v19(0 - 0);
		v66 = not Trinket2:HasCooldown() or (Trinket1:HasUseBuff() and (not Trinket2:HasUseBuff() or ((not Trinket1:ID() == v55.MirrorofFracturedTomorrows:ID()) and ((Trinket2:ID() == v55.MirrorofFracturedTomorrows:ID()) or (Trinket2:Cooldown() < Trinket1:Cooldown()) or (Trinket2:CastTime() < Trinket1:CastTime()) or ((Trinket2:CastTime() == Trinket1:CastTime()) and (Trinket2:Cooldown() == Trinket1:Cooldown())))))) or (not Trinket1:HasUseBuff() and not Trinket2:HasUseBuff() and ((Trinket2:Cooldown() < Trinket1:Cooldown()) or (Trinket2:CastTime() < Trinket1:CastTime()) or ((Trinket2:CastTime() == Trinket1:CastTime()) and (Trinket2:Cooldown() == Trinket1:Cooldown()))));
		v67 = not v66;
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v68, v69, v70;
	local v71, v72;
	local v73;
	local v74 = {{v53.Intimidation,"Cast Intimidation (Interrupt)",function()
		return true;
	end}};
	local function v75(v104)
		return (v104:DebuffRemains(v53.BarbedShotDebuff));
	end
	local function v76(v105)
		return (v105:DebuffStack(v53.LatentPoisonDebuff));
	end
	local function v77(v106)
		return (v106:DebuffRemains(v53.SerpentStingDebuff));
	end
	local function v78(v107)
		return (v107:DebuffStack(v53.LatentPoisonDebuff) > (1568 - (1381 + 178))) and ((v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + 0.25 + 0))) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < (10 + 2 + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < (2 + 1)) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp())) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown()));
	end
	local function v79(v108)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + (0.25 - 0)))) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < (7 + 5 + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < (473 - (381 + 89))) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp())) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown());
	end
	local function v80(v109)
		return (v109:DebuffStack(v53.LatentPoisonDebuff) > (8 + 1)) and (v13:BuffUp(v53.CalloftheWildBuff) or (v61 < (7 + 2)) or (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1.2 - 0))) or v53.Savagery:IsAvailable());
	end
	local function v81(v110)
		return v13:BuffUp(v53.CalloftheWildBuff) or (v61 < (1165 - (1074 + 82))) or (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1.2 - 0))) or v53.Savagery:IsAvailable();
	end
	local function v82(v111)
		return v111:DebuffRefreshable(v53.SerpentStingDebuff) and (v111:TimeToDie() > v53.SerpentStingDebuff:BaseDuration());
	end
	local function v83(v112)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + (1784.25 - (214 + 1570))))) or (v53.ScentofBlood:IsAvailable() and (v17:BuffStack(v53.FrenzyPetBuff) < (1458 - (990 + 465))) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp()));
	end
	local function v84(v113)
		return (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1.4 + 0))) or v13:BuffUp(v53.CalloftheWildBuff) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown()) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < (6 + 6 + v59))) or v53.Savagery:IsAvailable() or (v61 < (9 + 0));
	end
	local function v85(v114)
		return v114:DebuffRefreshable(v53.SerpentStingDebuff) and (v14:TimeToDie() > v53.SerpentStingDebuff:BaseDuration());
	end
	local function v86()
		local v115 = 0 - 0;
		while true do
			if ((v115 == (1728 - (1668 + 58))) or ((2995 - (512 + 114)) == (1110 - 684))) then
				if ((v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (41 - 21))) or ((10703 - 7627) > (1481 + 1702))) then
					if (((226 + 976) > (920 + 138)) and v25(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot))) then
						return "kill_shot_mouseover precombat 11";
					end
				end
				if (((12516 - 8805) > (5349 - (109 + 1885))) and v53.KillCommand:IsReady()) then
					if (v26(v57.KillCommandPetAttack) or ((2375 - (1269 + 200)) >= (4271 - 2042))) then
						return "kill_command precombat 12";
					end
				end
				v115 = 818 - (98 + 717);
			end
			if (((2114 - (802 + 24)) > (2157 - 906)) and (v115 == (1 - 0))) then
				if ((v53.BarbedShot:IsCastable() and (v53.BarbedShot:Charges() >= (1 + 1))) or ((3468 + 1045) < (551 + 2801))) then
					if (v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot)) or ((446 + 1619) >= (8891 - 5695))) then
						return "barbed_shot precombat 8";
					end
				end
				if (v53.KillShot:IsReady() or ((14592 - 10216) <= (530 + 951))) then
					if (v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot)) or ((1381 + 2011) >= (3911 + 830))) then
						return "kill_shot precombat 10";
					end
				end
				v115 = 2 + 0;
			end
			if (((1553 + 1772) >= (3587 - (797 + 636))) and (v115 == (14 - 11))) then
				if ((v70 > (1620 - (1427 + 192))) or ((449 + 846) >= (7505 - 4272))) then
					if (((3935 + 442) > (745 + 897)) and v53.MultiShot:IsReady()) then
						if (((5049 - (192 + 134)) > (2632 - (316 + 960))) and v25(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot))) then
							return "multishot precombat 14";
						end
					end
				elseif (v53.CobraShot:IsReady() or ((2302 + 1834) <= (2650 + 783))) then
					if (((3924 + 321) <= (17704 - 13073)) and v25(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot))) then
						return "cobra_shot precombat 16";
					end
				end
				break;
			end
			if (((4827 - (83 + 468)) >= (5720 - (1202 + 604))) and (v115 == (0 - 0))) then
				if (((329 - 131) <= (12085 - 7720)) and v15:Exists() and v53.Misdirection:IsReady()) then
					if (((5107 - (45 + 280)) > (4514 + 162)) and v26(v57.MisdirectionFocus)) then
						return "misdirection precombat 0";
					end
				end
				if (((4250 + 614) > (803 + 1394)) and v53.SteelTrap:IsCastable() and not v53.WailingArrow:IsAvailable() and v53.SteelTrap:IsAvailable() and v43) then
					if (v26(v53.SteelTrap) or ((2048 + 1652) == (441 + 2066))) then
						return "steel_trap precombat 2";
					end
				end
				v115 = 1 - 0;
			end
		end
	end
	local function v87()
		if (((6385 - (340 + 1571)) >= (109 + 165)) and v53.Berserking:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (1785 - (1733 + 39))))) then
			if (v26(v53.Berserking) or ((5204 - 3310) <= (2440 - (125 + 909)))) then
				return "berserking cds 2";
			end
		end
		if (((3520 - (1096 + 852)) >= (687 + 844)) and v53.BloodFury:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (22 - 6)))) then
			if (v26(v53.BloodFury) or ((4547 + 140) < (5054 - (409 + 103)))) then
				return "blood_fury cds 8";
			end
		end
		if (((3527 - (46 + 190)) > (1762 - (51 + 44))) and v53.AncestralCall:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (5 + 11)))) then
			if (v26(v53.AncestralCall) or ((2190 - (1114 + 203)) == (2760 - (228 + 498)))) then
				return "ancestral_call cds 10";
			end
		end
		if ((v53.Fireblood:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (2 + 7)))) or ((1556 + 1260) < (674 - (174 + 489)))) then
			if (((9636 - 5937) < (6611 - (830 + 1075))) and v26(v53.Fireblood)) then
				return "fireblood cds 12";
			end
		end
	end
	local function v88()
		local v116 = 524 - (303 + 221);
		local v117;
		while true do
			if (((3915 - (231 + 1038)) >= (730 + 146)) and (v116 == (1162 - (171 + 991)))) then
				v117 = v51.HandleTopTrinket(v56, v29, 164 - 124, nil);
				if (((1648 - 1034) <= (7945 - 4761)) and v117) then
					return v117;
				end
				v116 = 1 + 0;
			end
			if (((10957 - 7831) == (9017 - 5891)) and (v116 == (1 - 0))) then
				v117 = v51.HandleBottomTrinket(v56, v29, 123 - 83, nil);
				if (v117 or ((3435 - (111 + 1137)) >= (5112 - (91 + 67)))) then
					return v117;
				end
				break;
			end
		end
	end
	local function v89()
		local v118 = 0 - 0;
		while true do
			if ((v118 == (1 + 2)) or ((4400 - (423 + 100)) == (26 + 3549))) then
				if (((1957 - 1250) > (330 + 302)) and v53.DeathChakram:IsCastable() and v29) then
					if (v25(v53.DeathChakram, not v14:IsSpellInRange(v53.DeathChakram)) or ((1317 - (326 + 445)) >= (11712 - 9028))) then
						return "death_chakram cleave 18";
					end
				end
				if (((3263 - 1798) <= (10039 - 5738)) and v53.SteelTrap:IsCastable() and v43) then
					if (((2415 - (530 + 181)) > (2306 - (614 + 267))) and v26(v57.SteelTrap)) then
						return "steel_trap cleave 22";
					end
				end
				if ((v53.AMurderofCrows:IsReady() and v29) or ((719 - (19 + 13)) == (6891 - 2657))) then
					if (v25(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows)) or ((7760 - 4430) < (4082 - 2653))) then
						return "a_murder_of_crows cleave 24";
					end
				end
				v118 = 2 + 2;
			end
			if (((2017 - 870) >= (694 - 359)) and ((1816 - (1293 + 519)) == v118)) then
				if (((7008 - 3573) > (5474 - 3377)) and v53.BarbedShot:IsCastable()) then
					if (v51.CastTargetIf(v57.BarbedShotPetAttack, v68, "max", v76, v80, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover) or ((7209 - 3439) >= (17425 - 13384))) then
						return "barbed_shot cleave 26";
					end
				end
				if (v53.BarbedShot:IsCastable() or ((8930 - 5139) <= (854 + 757))) then
					if (v51.CastTargetIf(v57.BarbedShotPetAttack, v68, "min", v75, v81, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover) or ((934 + 3644) <= (4665 - 2657))) then
						return "barbed_shot cleave 28";
					end
				end
				if (((260 + 865) <= (690 + 1386)) and v53.KillCommand:IsReady()) then
					if (v25(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand)) or ((465 + 278) >= (5495 - (709 + 387)))) then
						return "kill_command cleave 30";
					end
				end
				v118 = 1863 - (673 + 1185);
			end
			if (((3349 - 2194) < (5372 - 3699)) and ((8 - 3) == v118)) then
				if (v53.DireBeast:IsCastable() or ((1663 + 661) <= (432 + 146))) then
					if (((5085 - 1318) == (926 + 2841)) and v25(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast))) then
						return "dire_beast cleave 32";
					end
				end
				if (((8152 - 4063) == (8026 - 3937)) and v53.SerpentSting:IsReady()) then
					if (((6338 - (446 + 1434)) >= (2957 - (1040 + 243))) and v51.CastTargetIf(v53.SerpentSting, v68, "min", v77, v82, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover)) then
						return "serpent_sting cleave 34";
					end
				end
				if (((2901 - 1929) <= (3265 - (559 + 1288))) and v53.Barrage:IsReady() and (v17:BuffRemains(v53.FrenzyPetBuff) > v53.Barrage:ExecuteTime())) then
					if (v25(v53.Barrage, not v14:IsSpellInRange(v53.Barrage)) or ((6869 - (609 + 1322)) < (5216 - (13 + 441)))) then
						return "barrage cleave 36";
					end
				end
				v118 = 22 - 16;
			end
			if ((v118 == (15 - 9)) or ((12471 - 9967) > (159 + 4105))) then
				if (((7819 - 5666) == (765 + 1388)) and v53.MultiShot:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < (v13:GCD() * (2 + 1)))) then
					if (v25(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot)) or ((1504 - 997) >= (1418 + 1173))) then
						return "multishot cleave 38";
					end
				end
				if (((8241 - 3760) == (2963 + 1518)) and v53.AspectoftheWild:IsCastable() and v29) then
					if (v26(v53.AspectoftheWild) or ((1295 + 1033) < (498 + 195))) then
						return "aspect_of_the_wild cleave 40";
					end
				end
				if (((3635 + 693) == (4235 + 93)) and v29 and v53.LightsJudgment:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v14:TimeToDie() < (438 - (153 + 280))))) then
					if (((4585 - 2997) >= (1196 + 136)) and v25(v53.LightsJudgment, nil, not v14:IsInRange(2 + 3))) then
						return "lights_judgment cleave 40";
					end
				end
				v118 = 4 + 3;
			end
			if ((v118 == (2 + 0)) or ((3025 + 1149) > (6468 - 2220))) then
				if (v53.ExplosiveShot:IsReady() or ((2835 + 1751) <= (749 - (89 + 578)))) then
					if (((2760 + 1103) == (8030 - 4167)) and v25(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot))) then
						return "explosive_shot cleave 12";
					end
				end
				if ((v53.Stampede:IsCastable() and v29) or ((1331 - (572 + 477)) <= (6 + 36))) then
					if (((2766 + 1843) >= (92 + 674)) and v25(v53.Stampede, not v14:IsSpellInRange(v53.Stampede))) then
						return "stampede cleave 14";
					end
				end
				if (v53.Bloodshed:IsCastable() or ((1238 - (84 + 2)) == (4100 - 1612))) then
					if (((2466 + 956) > (4192 - (497 + 345))) and v25(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed))) then
						return "bloodshed cleave 16";
					end
				end
				v118 = 1 + 2;
			end
			if (((149 + 728) > (1709 - (605 + 728))) and (v118 == (1 + 0))) then
				if (v53.BestialWrath:IsCastable() or ((6932 - 3814) <= (85 + 1766))) then
					if (v26(v53.BestialWrath) or ((609 - 444) >= (3149 + 343))) then
						return "bestial_wrath cleave 8";
					end
				end
				if (((10940 - 6991) < (3667 + 1189)) and v53.CalloftheWild:IsCastable() and v29) then
					if (v25(v53.CalloftheWild) or ((4765 - (457 + 32)) < (1280 + 1736))) then
						return "call_of_the_wild cleave 10";
					end
				end
				if (((6092 - (832 + 570)) > (3887 + 238)) and v53.KillCommand:IsReady() and (v53.KillCleave:IsAvailable())) then
					if (v25(v53.KillCommand, nil, nil, not v14:IsInRange(14 + 36)) or ((176 - 126) >= (432 + 464))) then
						return "kill_command cleave 12";
					end
				end
				v118 = 798 - (588 + 208);
			end
			if ((v118 == (21 - 13)) or ((3514 - (884 + 916)) >= (6192 - 3234))) then
				if ((v53.WailingArrow:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53.WailingArrow:ExecuteTime()) or (v61 < (3 + 2)))) or ((2144 - (232 + 421)) < (2533 - (1569 + 320)))) then
					if (((173 + 531) < (188 + 799)) and v25(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow))) then
						return "wailing_arrow cleave 44";
					end
				end
				if (((12528 - 8810) > (2511 - (316 + 289))) and v53.BagofTricks:IsCastable() and v29 and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (13 - 8)))) then
					if (v26(v53.BagofTricks) or ((45 + 913) > (5088 - (666 + 787)))) then
						return "bag_of_tricks cleave 46";
					end
				end
				if (((3926 - (360 + 65)) <= (4199 + 293)) and v53.ArcaneTorrent:IsCastable() and v29 and ((v13:Focus() + v13:FocusRegen() + (284 - (79 + 175))) < v13:FocusMax())) then
					if (v26(v53.ArcaneTorrent) or ((5427 - 1985) < (1989 + 559))) then
						return "arcane_torrent cleave 48";
					end
				end
				break;
			end
			if (((8812 - 5937) >= (2819 - 1355)) and (v118 == (899 - (503 + 396)))) then
				if (v53.BarbedShot:IsCastable() or ((4978 - (92 + 89)) >= (9491 - 4598))) then
					if (v51.CastTargetIf(v53.BarbedShot, v68, "max", v76, v78, not v14:IsSpellInRange(v53.BarbedShot)) or ((283 + 268) > (1224 + 844))) then
						return "barbed_shot cleave 2";
					end
				end
				if (((8278 - 6164) > (130 + 814)) and v53.BarbedShot:IsCastable()) then
					if (v51.CastTargetIf(v53.BarbedShot, v68, "min", v75, v79, not v14:IsSpellInRange(v53.BarbedShot)) or ((5157 - 2895) >= (2702 + 394))) then
						return "barbed_shot cleave 4";
					end
				end
				if ((v53.MultiShot:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < (0.5 + 0 + v59)) and (not v53.BloodyFrenzy:IsAvailable() or v53.CalloftheWild:CooldownDown())) or ((6867 - 4612) >= (442 + 3095))) then
					if (v25(v53.MultiShot, nil, nil, not v14:IsSpellInRange(v53.MultiShot)) or ((5850 - 2013) < (2550 - (485 + 759)))) then
						return "multishot cleave 6";
					end
				end
				v118 = 2 - 1;
			end
			if (((4139 - (442 + 747)) == (4085 - (832 + 303))) and (v118 == (953 - (88 + 858)))) then
				if (v53.KillShot:IsReady() or ((1440 + 3283) < (2730 + 568))) then
					if (((47 + 1089) >= (943 - (766 + 23))) and v25(v53.KillShot, not v14:IsSpellInRange(v53.KillShot))) then
						return "kill_shot cleave 38";
					end
				end
				if ((v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (98 - 78))) or ((370 - 99) > (12509 - 7761))) then
					if (((16087 - 11347) >= (4225 - (1036 + 37))) and v25(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot))) then
						return "kill_shot_mouseover cleave 39";
					end
				end
				if ((v53.CobraShot:IsReady() and (v13:FocusTimeToMax() < (v59 * (2 + 0)))) or ((5020 - 2442) >= (2667 + 723))) then
					if (((1521 - (641 + 839)) <= (2574 - (910 + 3))) and v25(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot))) then
						return "cobra_shot cleave 42";
					end
				end
				v118 = 20 - 12;
			end
		end
	end
	local function v90()
		if (((2285 - (1466 + 218)) < (1637 + 1923)) and v53.BarbedShot:IsCastable()) then
			if (((1383 - (556 + 592)) < (245 + 442)) and v51.CastTargetIf(v57.BarbedShotPetAttack, v68, "min", v75, v83, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
				return "barbed_shot st 2";
			end
		end
		if (((5357 - (329 + 479)) > (2007 - (174 + 680))) and v53.BarbedShot:IsCastable() and v83(v14)) then
			if (v25(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot)) or ((16060 - 11386) < (9683 - 5011))) then
				return "barbed_shot st mt_backup 3";
			end
		end
		if (((2619 + 1049) < (5300 - (396 + 343))) and v53.CalloftheWild:IsCastable() and v29) then
			if (v26(v53.CalloftheWild) or ((41 + 414) == (5082 - (29 + 1448)))) then
				return "call_of_the_wild st 6";
			end
		end
		if ((v53.KillCommand:IsReady() and (v53.KillCommand:FullRechargeTime() < v59) and v53.AlphaPredator:IsAvailable()) or ((4052 - (135 + 1254)) == (12476 - 9164))) then
			if (((19969 - 15692) <= (2983 + 1492)) and v25(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand))) then
				return "kill_command st 4";
			end
		end
		if ((v53.Stampede:IsCastable() and v29) or ((2397 - (389 + 1138)) == (1763 - (102 + 472)))) then
			if (((1466 + 87) <= (1738 + 1395)) and v25(v53.Stampede, nil, nil, not v14:IsSpellInRange(v53.Stampede))) then
				return "stampede st 8";
			end
		end
		if (v53.Bloodshed:IsCastable() or ((2086 + 151) >= (5056 - (320 + 1225)))) then
			if (v25(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed)) or ((2356 - 1032) > (1848 + 1172))) then
				return "bloodshed st 10";
			end
		end
		if (v53.BestialWrath:IsCastable() or ((4456 - (157 + 1307)) == (3740 - (821 + 1038)))) then
			if (((7749 - 4643) > (167 + 1359)) and v26(v53.BestialWrath)) then
				return "bestial_wrath st 12";
			end
		end
		if (((5369 - 2346) < (1440 + 2430)) and v53.DeathChakram:IsCastable() and v29) then
			if (((354 - 211) > (1100 - (834 + 192))) and v25(v53.DeathChakram, nil, nil, not v14:IsSpellInRange(v53.DeathChakram))) then
				return "death_chakram st 14";
			end
		end
		if (((2 + 16) < (543 + 1569)) and v53.KillCommand:IsReady()) then
			if (((24 + 1073) <= (2521 - 893)) and v25(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand))) then
				return "kill_command st 22";
			end
		end
		if (((4934 - (300 + 4)) == (1237 + 3393)) and v53.AMurderofCrows:IsCastable() and v29) then
			if (((9266 - 5726) > (3045 - (112 + 250))) and v25(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows))) then
				return "a_murder_of_crows st 14";
			end
		end
		if (((1912 + 2882) >= (8204 - 4929)) and v53.SteelTrap:IsCastable() and v43) then
			if (((851 + 633) == (768 + 716)) and v26(v53.SteelTrap)) then
				return "steel_trap st 16";
			end
		end
		if (((1071 + 361) < (1763 + 1792)) and v53.ExplosiveShot:IsReady()) then
			if (v25(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot)) or ((792 + 273) > (4992 - (1001 + 413)))) then
				return "explosive_shot st 18";
			end
		end
		if (v53.BarbedShot:IsCastable() or ((10692 - 5897) < (2289 - (244 + 638)))) then
			if (((2546 - (627 + 66)) < (14340 - 9527)) and v51.CastTargetIf(v57.BarbedShotPetAttack, v68, "min", v75, v84, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
				return "barbed_shot st 24";
			end
		end
		if ((v53.BarbedShot:IsCastable() and v84(v14)) or ((3423 - (512 + 90)) < (4337 - (1665 + 241)))) then
			if (v25(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot)) or ((3591 - (373 + 344)) < (984 + 1197))) then
				return "barbed_shot st mt_backup 25";
			end
		end
		if (v53.DireBeast:IsCastable() or ((712 + 1977) <= (904 - 561))) then
			if (v25(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast)) or ((3162 - 1293) == (3108 - (35 + 1064)))) then
				return "dire_beast st 26";
			end
		end
		if (v53.SerpentSting:IsReady() or ((2581 + 965) < (4967 - 2645))) then
			if (v51.CastTargetIf(v53.SerpentSting, v68, "min", v77, v85, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover) or ((9 + 2073) == (6009 - (298 + 938)))) then
				return "serpent_sting st 28";
			end
		end
		if (((4503 - (233 + 1026)) > (2721 - (636 + 1030))) and v53.KillShot:IsReady()) then
			if (v25(v53.KillShot, not v14:IsSpellInRange(v53.KillShot)) or ((1694 + 1619) <= (1737 + 41))) then
				return "kill_shot st 30";
			end
		end
		if ((v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (6 + 14))) or ((97 + 1324) >= (2325 - (55 + 166)))) then
			if (((352 + 1460) <= (327 + 2922)) and v25(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot))) then
				return "kill_shot_mouseover st 31";
			end
		end
		if (((6198 - 4575) <= (2254 - (36 + 261))) and v53.AspectoftheWild:IsCastable() and v29) then
			if (((7715 - 3303) == (5780 - (34 + 1334))) and v26(v53.AspectoftheWild)) then
				return "aspect_of_the_wild st 32";
			end
		end
		if (((673 + 1077) >= (655 + 187)) and v53.CobraShot:IsReady()) then
			if (((5655 - (1035 + 248)) > (1871 - (20 + 1))) and v25(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot))) then
				return "cobra_shot st 34";
			end
		end
		if (((121 + 111) < (1140 - (134 + 185))) and v53.WailingArrow:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53.WailingArrow:ExecuteTime()) or (v61 < (1138 - (549 + 584))))) then
			if (((1203 - (314 + 371)) < (3096 - 2194)) and v25(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow), true)) then
				return "wailing_arrow st 36";
			end
		end
		if (((3962 - (478 + 490)) > (455 + 403)) and v29) then
			local v123 = 1172 - (786 + 386);
			while true do
				if ((v123 == (3 - 2)) or ((5134 - (1055 + 324)) <= (2255 - (1093 + 247)))) then
					if (((3507 + 439) > (394 + 3349)) and v53.ArcaneTorrent:IsCastable() and ((v13:Focus() + v13:FocusRegen() + (59 - 44)) < v13:FocusMax())) then
						if (v26(v53.ArcaneTorrent) or ((4530 - 3195) >= (9407 - 6101))) then
							return "arcane_torrent st 42";
						end
					end
					break;
				end
				if (((12172 - 7328) > (802 + 1451)) and (v123 == (0 - 0))) then
					if (((1557 - 1105) == (341 + 111)) and v53.BagofTricks:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (12 - 7)))) then
						if (v26(v53.BagofTricks) or ((5245 - (364 + 324)) < (5721 - 3634))) then
							return "bag_of_tricks st 38";
						end
					end
					if (((9296 - 5422) == (1284 + 2590)) and v53.ArcanePulse:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (20 - 15)))) then
						if (v26(v53.ArcanePulse) or ((3103 - 1165) > (14988 - 10053))) then
							return "arcane_pulse st 40";
						end
					end
					v123 = 1269 - (1249 + 19);
				end
			end
		end
	end
	local function v91()
		if ((not v13:IsCasting() and not v13:IsChanneling()) or ((3841 + 414) < (13324 - 9901))) then
			local v124 = 1086 - (686 + 400);
			local v125;
			while true do
				if (((1141 + 313) <= (2720 - (73 + 156))) and (v124 == (1 + 0))) then
					v125 = v51.InterruptWithStun(v53.Intimidation, 851 - (721 + 90));
					if (v125 or ((47 + 4110) <= (9100 - 6297))) then
						return v125;
					end
					break;
				end
				if (((5323 - (224 + 246)) >= (4830 - 1848)) and (v124 == (0 - 0))) then
					v125 = v51.Interrupt(v53.CounterShot, 8 + 32, true);
					if (((99 + 4035) > (2466 + 891)) and v125) then
						return v125;
					end
					v124 = 1 - 0;
				end
			end
		end
	end
	local function v92()
		local v119 = 0 - 0;
		local v120;
		local v121;
		while true do
			if ((v119 == (513 - (203 + 310))) or ((5410 - (1238 + 755)) < (178 + 2356))) then
				v50();
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v119 = 1535 - (709 + 825);
			end
			if ((v119 == (4 - 1)) or ((3964 - 1242) <= (1028 - (196 + 668)))) then
				v72 = v14:IsInRange(118 - 88);
				v73 = (v121 and v14:IsSpellInActionRange(v121)) or v14:IsInRange(62 - 32);
				v59 = v13:GCD() + (833.15 - (171 + 662));
				v119 = 97 - (4 + 89);
			end
			if ((v119 == (6 - 4)) or ((877 + 1531) < (9263 - 7154))) then
				v121 = (v53.Growl:IsPetKnown() and v20.FindBySpellID(v53.Growl:ID()) and v53.Growl) or nil;
				if (v28 or ((13 + 20) == (2941 - (35 + 1451)))) then
					local v129 = 1453 - (28 + 1425);
					while true do
						if ((v129 == (1994 - (941 + 1052))) or ((425 + 18) >= (5529 - (822 + 692)))) then
							v70 = (v120 and #v69) or v14:GetEnemiesInSplashRangeCount(11 - 3);
							break;
						end
						if (((1593 + 1789) > (463 - (45 + 252))) and (v129 == (0 + 0))) then
							v68 = v13:GetEnemiesInRange(14 + 26);
							v69 = (v120 and v13:GetEnemiesInSpellActionRange(v120)) or v14:GetEnemiesInSplashRange(19 - 11);
							v129 = 434 - (114 + 319);
						end
					end
				else
					local v130 = 0 - 0;
					while true do
						if ((v130 == (1 - 0)) or ((179 + 101) == (4556 - 1497))) then
							v70 = 0 - 0;
							break;
						end
						if (((3844 - (556 + 1407)) > (2499 - (741 + 465))) and (v130 == (465 - (170 + 295)))) then
							v68 = {};
							v69 = v14 or {};
							v130 = 1 + 0;
						end
					end
				end
				v71 = v14:IsInRange(37 + 3);
				v119 = 7 - 4;
			end
			if (((1954 + 403) == (1512 + 845)) and (v119 == (3 + 1))) then
				if (((1353 - (957 + 273)) == (33 + 90)) and (v51.TargetIsValid() or v13:AffectingCombat())) then
					v60 = v10.BossFightRemains();
					v61 = v60;
					if ((v61 == (4448 + 6663)) or ((4023 - 2967) >= (8938 - 5546))) then
						v61 = v10.FightRemains(v68, false);
					end
				end
				if ((v53.Exhilaration:IsCastable() and v47 and (v13:HealthPercentage() <= v48)) or ((3301 - 2220) < (5323 - 4248))) then
					if (v25(v53.Exhilaration) or ((2829 - (389 + 1391)) >= (2781 + 1651))) then
						return "Exhilaration";
					end
				end
				if (((v13:HealthPercentage() <= v37) and v36 and v55.Healthstone:IsReady()) or ((497 + 4271) <= (1925 - 1079))) then
					if (v26(v57.Healthstone, nil, nil, true) or ((4309 - (783 + 168)) <= (4765 - 3345))) then
						return "healthstone defensive 3";
					end
				end
				v119 = 5 + 0;
			end
			if ((v119 == (312 - (309 + 2))) or ((11481 - 7742) <= (4217 - (1090 + 122)))) then
				v29 = EpicSettings.Toggles['cds'];
				if (v53.Stomp:IsAvailable() or ((538 + 1121) >= (7166 - 5032))) then
					v10.SplashEnemies.ChangeFriendTargetsTracking("Mine Only");
				else
					v10.SplashEnemies.ChangeFriendTargetsTracking("All");
				end
				v120 = (v53.BloodBolt:IsPetKnown() and v20.FindBySpellID(v53.BloodBolt:ID()) and v53.BloodBolt) or (v53.Bite:IsPetKnown() and v20.FindBySpellID(v53.Bite:ID()) and v53.Bite) or (v53.Claw:IsPetKnown() and v20.FindBySpellID(v53.Claw:ID()) and v53.Claw) or (v53.Smack:IsPetKnown() and v20.FindBySpellID(v53.Smack:ID()) and v53.Smack) or nil;
				v119 = 2 + 0;
			end
			if ((v119 == (1123 - (628 + 490))) or ((585 + 2675) < (5830 - 3475))) then
				if ((v33 and (v13:HealthPercentage() <= v35)) or ((3057 - 2388) == (4997 - (431 + 343)))) then
					if ((v34 == "Refreshing Healing Potion") or ((3416 - 1724) < (1700 - 1112))) then
						if (v55.RefreshingHealingPotion:IsReady() or ((3790 + 1007) < (467 + 3184))) then
							if (v26(v57.RefreshingHealingPotion) or ((5872 - (556 + 1139)) > (4865 - (6 + 9)))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v34 == "Dreamwalker's Healing Potion") or ((74 + 326) > (570 + 541))) then
						if (((3220 - (28 + 141)) > (390 + 615)) and v55.DreamwalkersHealingPotion:IsReady()) then
							if (((4557 - 864) <= (3104 + 1278)) and v26(v57.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				if (not (v13:IsMounted() or v13:IsInVehicle()) or ((4599 - (486 + 831)) > (10669 - 6569))) then
					local v131 = 0 - 0;
					while true do
						if ((v131 == (1 + 0)) or ((11319 - 7739) < (4107 - (668 + 595)))) then
							if (((81 + 8) < (906 + 3584)) and v53.MendPet:IsCastable() and v45 and (v17:HealthPercentage() < v46)) then
								if (v26(v53.MendPet) or ((13589 - 8606) < (2098 - (23 + 267)))) then
									return "Mend Pet High Priority";
								end
							end
							break;
						end
						if (((5773 - (1129 + 815)) > (4156 - (371 + 16))) and (v131 == (1750 - (1326 + 424)))) then
							if (((2812 - 1327) <= (10611 - 7707)) and v53.SummonPet:IsCastable() and v41) then
								if (((4387 - (88 + 30)) == (5040 - (720 + 51))) and v26(v54[v42])) then
									return "Summon Pet";
								end
							end
							if (((860 - 473) <= (4558 - (421 + 1355))) and v53.RevivePet:IsCastable() and v44 and v17:IsDeadOrGhost()) then
								if (v26(v53.RevivePet) or ((3132 - 1233) <= (451 + 466))) then
									return "Revive Pet";
								end
							end
							v131 = 1084 - (286 + 797);
						end
					end
				end
				if (v51.TargetIsValid() or ((15763 - 11451) <= (1450 - 574))) then
					if (((2671 - (397 + 42)) <= (811 + 1785)) and not v13:AffectingCombat() and not v27) then
						local v134 = 800 - (24 + 776);
						local v135;
						while true do
							if (((3227 - 1132) < (4471 - (222 + 563))) and ((0 - 0) == v134)) then
								v135 = v86();
								if (v135 or ((1149 + 446) >= (4664 - (23 + 167)))) then
									return v135;
								end
								break;
							end
						end
					end
					if ((not v13:IsCasting() and not v13:IsChanneling()) or ((6417 - (690 + 1108)) < (1040 + 1842))) then
						local v136 = 0 + 0;
						local v137;
						while true do
							if ((v136 == (850 - (40 + 808))) or ((49 + 245) >= (18473 - 13642))) then
								v137 = v51.InterruptWithStun(v53.Intimidation, 39 + 1, true);
								if (((1074 + 955) <= (1692 + 1392)) and v137) then
									return v137;
								end
								v136 = 574 - (47 + 524);
							end
							if ((v136 == (0 + 0)) or ((5568 - 3531) == (3618 - 1198))) then
								v137 = v51.Interrupt(v53.CounterShot, 91 - 51, true);
								if (((6184 - (1165 + 561)) > (116 + 3788)) and v137) then
									return v137;
								end
								v136 = 3 - 2;
							end
							if (((167 + 269) >= (602 - (341 + 138))) and (v136 == (1 + 0))) then
								v137 = v51.Interrupt(v53.CounterShot, 82 - 42, true, v16, v57.CounterShotMouseover);
								if (((826 - (89 + 237)) < (5842 - 4026)) and v137) then
									return v137;
								end
								v136 = 3 - 1;
							end
							if (((4455 - (581 + 300)) == (4794 - (855 + 365))) and (v136 == (6 - 3))) then
								v137 = v51.InterruptWithStun(v53.Intimidation, 14 + 26, true, v16, v57.IntimidationMouseover);
								if (((1456 - (1030 + 205)) < (367 + 23)) and v137) then
									return v137;
								end
								break;
							end
						end
					end
					local v132 = v51.HandleDPSPotion();
					if (v132 or ((2059 + 154) <= (1707 - (156 + 130)))) then
						return v132;
					end
					if (((6948 - 3890) < (8191 - 3331)) and v29) then
						local v138 = v87();
						if (v138 or ((2654 - 1358) >= (1172 + 3274))) then
							return v138;
						end
					end
					local v133 = v88();
					if (v133 or ((813 + 580) > (4558 - (10 + 59)))) then
						return v133;
					end
					if ((v70 > (1 + 1)) or (v53.BeastCleave:IsAvailable() and (v70 > (4 - 3))) or ((5587 - (671 + 492)) < (22 + 5))) then
						local v139 = 1215 - (369 + 846);
						local v140;
						while true do
							if ((v139 == (0 + 0)) or ((1705 + 292) > (5760 - (1036 + 909)))) then
								v140 = v89();
								if (((2755 + 710) > (3211 - 1298)) and v140) then
									return v140;
								end
								break;
							end
						end
					end
					if (((936 - (11 + 192)) < (920 + 899)) and ((v70 < (177 - (135 + 40))) or (not v53.BeastCleave:IsAvailable() and (v70 < (6 - 3))))) then
						local v141 = 0 + 0;
						local v142;
						while true do
							if ((v141 == (0 - 0)) or ((6588 - 2193) == (4931 - (50 + 126)))) then
								v142 = v90();
								if (v142 or ((10561 - 6768) < (525 + 1844))) then
									return v142;
								end
								break;
							end
						end
					end
					if ((not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53.MendPet:IsCastable() and (v17:HealthPercentage() < v46) and v45) or ((5497 - (1233 + 180)) == (1234 - (522 + 447)))) then
						if (((5779 - (107 + 1314)) == (2023 + 2335)) and v26(v53.MendPet)) then
							return "Mend Pet Low Priority (w/ Target)";
						end
					end
				end
				v119 = 18 - 12;
			end
			if ((v119 == (3 + 3)) or ((6231 - 3093) < (3928 - 2935))) then
				if (((5240 - (716 + 1194)) > (40 + 2283)) and not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53.MendPet:IsCastable() and (v17:HealthPercentage() < v46) and v45) then
					if (v26(v53.MendPet) or ((389 + 3237) == (4492 - (74 + 429)))) then
						return "Mend Pet Low Priority (w/o Target)";
					end
				end
				break;
			end
		end
	end
	local function v93()
		v10.Print("Beast Mastery by Epic. Supported by Gojira");
		local v122 = (v53.Growl:IsPetKnown() and v20.FindBySpellID(v53.Growl:ID()) and v53.Growl) or nil;
		if (not v122 or ((1766 - 850) == (1324 + 1347))) then
			v10.Print("|cffffff00Info|r: Add pet abilities to your action bars to improve range checks.");
		end
	end
	v10.SetAPL(579 - 326, v92, v93);
end;
return v1["Epix_Hunter_BeastMastery.lua"](...);

