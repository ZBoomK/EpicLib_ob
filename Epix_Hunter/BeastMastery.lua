local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((3595 - (53 + 138)) == (4761 - (112 + 189)))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Hunter_BeastMastery.lua"] = function(...)
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
	local v18 = v9.Item;
	local v19 = v9.Action;
	local v20 = v9.Bind;
	local v21 = v9.Macro;
	local v22 = v9.AoEON;
	local v23 = v9.CDsON;
	local v24 = v9.Cast;
	local v25 = v9.Press;
	local v26 = false;
	local v27 = false;
	local v28 = false;
	local v29 = math.max;
	local v30;
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
	local function v49()
		v30 = EpicSettings.Settings['UseRacials'];
		v32 = EpicSettings.Settings['UseHealingPotion'];
		v33 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
		v34 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v35 = EpicSettings.Settings['UseHealthstone'];
		v36 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v37 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
		v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
		v39 = EpicSettings.Settings['InterruptThreshold'] or (1744 - (1344 + 400));
		v40 = EpicSettings.Settings['UsePet'];
		v41 = EpicSettings.Settings['SummonPetSlot'] or (405 - (255 + 150));
		v42 = EpicSettings.Settings['UseSteelTrap'];
		v43 = EpicSettings.Settings['UseRevive'];
		v44 = EpicSettings.Settings['UseMendPet'];
		v45 = EpicSettings.Settings['MendPetHP'] or (0 + 0);
		v46 = EpicSettings.Settings['UseExhilaration'];
		v47 = EpicSettings.Settings['ExhilarationHP'] or (0 + 0);
		v48 = EpicSettings.Settings['UseTranq'];
	end
	local v50 = v9.Commons.Everyone;
	local v51 = v9.Commons.Hunter;
	local v52 = v17.Hunter.BeastMastery;
	local v53 = {v52.SummonPet,v52.SummonPet2,v52.SummonPet3,v52.SummonPet4,v52.SummonPet5};
	local v54 = v18.Hunter.BeastMastery;
	local v55 = {};
	local v56 = v21.Hunter.BeastMastery;
	local v57 = v12:GetEquipment();
	v9:RegisterForEvent(function()
		v57 = v12:GetEquipment();
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v58;
	local v59 = 7363 + 3748;
	local v60 = 3999 + 7112;
	v9:RegisterForEvent(function()
		v59 = 11448 - (10 + 327);
		v60 = 7738 + 3373;
	end, "PLAYER_REGEN_ENABLED");
	local v61, v62, v63;
	local v64, v65;
	local v66;
	local v67 = {{v52.Intimidation,"Cast Intimidation (Interrupt)",function()
		return true;
	end}};
	local function v68(v96)
		return (v96:DebuffRemains(v52.BarbedShotDebuff));
	end
	local function v69(v97)
		return (v97:DebuffStack(v52.LatentPoisonDebuff));
	end
	local function v70(v98)
		return (v98:DebuffRemains(v52.SerpentStingDebuff));
	end
	local function v71(v99)
		return (v99:DebuffStack(v52.LatentPoisonDebuff) > (37 - 28)) and ((v16:BuffUp(v52.FrenzyPetBuff) and (v16:BuffRemains(v52.FrenzyPetBuff) <= (v58 + (1493.25 - (711 + 782))))) or (v52.ScentofBlood:IsAvailable() and (v52.BestialWrath:CooldownRemains() < ((22 - 10) + v58))) or ((v16:BuffStack(v52.FrenzyPetBuff) < (472 - (270 + 199))) and (v52.BestialWrath:CooldownUp() or v52.CalloftheWild:CooldownUp())) or ((v52.BarbedShot:FullRechargeTime() < v58) and v52.BestialWrath:CooldownDown()));
	end
	local function v72(v100)
		return (v16:BuffUp(v52.FrenzyPetBuff) and (v16:BuffRemains(v52.FrenzyPetBuff) <= (v58 + 0.25 + 0))) or (v52.ScentofBlood:IsAvailable() and (v52.BestialWrath:CooldownRemains() < ((1831 - (580 + 1239)) + v58))) or ((v16:BuffStack(v52.FrenzyPetBuff) < (8 - 5)) and (v52.BestialWrath:CooldownUp() or v52.CalloftheWild:CooldownUp())) or ((v52.BarbedShot:FullRechargeTime() < v58) and v52.BestialWrath:CooldownDown());
	end
	local function v73(v101)
		return (v101:DebuffStack(v52.LatentPoisonDebuff) > (9 + 0)) and (v12:BuffUp(v52.CalloftheWildBuff) or (v60 < (1 + 8)) or (v52.WildCall:IsAvailable() and (v52.BarbedShot:ChargesFractional() > (1.2 + 0))) or v52.Savagery:IsAvailable());
	end
	local function v74(v102)
		return v12:BuffUp(v52.CalloftheWildBuff) or (v60 < (22 - 13)) or (v52.WildCall:IsAvailable() and (v52.BarbedShot:ChargesFractional() > (1.2 + 0))) or v52.Savagery:IsAvailable();
	end
	local function v75(v103)
		return v103:DebuffRefreshable(v52.SerpentStingDebuff) and (v103:TimeToDie() > v52.SerpentStingDebuff:BaseDuration());
	end
	local function v76(v104)
		return (v16:BuffUp(v52.FrenzyPetBuff) and (v16:BuffRemains(v52.FrenzyPetBuff) <= (v58 + (1167.25 - (645 + 522))))) or (v52.ScentofBlood:IsAvailable() and (v16:BuffStack(v52.FrenzyPetBuff) < (1793 - (1010 + 780))) and (v52.BestialWrath:CooldownUp() or v52.CalloftheWild:CooldownUp()));
	end
	local function v77(v105)
		return (v52.WildCall:IsAvailable() and (v52.BarbedShot:ChargesFractional() > (1.4 + 0))) or v12:BuffUp(v52.CalloftheWildBuff) or ((v52.BarbedShot:FullRechargeTime() < v58) and v52.BestialWrath:CooldownDown()) or (v52.ScentofBlood:IsAvailable() and (v52.BestialWrath:CooldownRemains() < ((57 - 45) + v58))) or v52.Savagery:IsAvailable() or (v60 < (26 - 17));
	end
	local function v78(v106)
		return v106:DebuffRefreshable(v52.SerpentStingDebuff) and (v13:TimeToDie() > v52.SerpentStingDebuff:BaseDuration());
	end
	local function v79()
		if ((v14:Exists() and v52.Misdirection:IsReady()) or ((4200 - (1045 + 791)) > (8874 - 5368))) then
			if (v25(v56.MisdirectionFocus) or ((4432 - 1529) > (5459 - (351 + 154)))) then
				return "misdirection precombat 0";
			end
		end
		if (((4658 - (1281 + 293)) > (306 - (28 + 238))) and v52.SteelTrap:IsCastable() and not v52.WailingArrow:IsAvailable() and v52.SteelTrap:IsAvailable()) then
			if (((7623 - 4211) > (2378 - (1381 + 178))) and v25(v52.SteelTrap)) then
				return "steel_trap precombat 2";
			end
		end
		if (((2966 + 196) <= (2775 + 666)) and v52.BarbedShot:IsCastable() and (v52.BarbedShot:Charges() >= (1 + 1))) then
			if (((16223 - 11517) > (2295 + 2134)) and v25(v56.BarbedShotPetAttack, not v13:IsSpellInRange(v52.BarbedShot))) then
				return "barbed_shot precombat 8";
			end
		end
		if (((3324 - (381 + 89)) < (3632 + 463)) and v52.KillShot:IsReady()) then
			if (v25(v52.KillShot, not v13:IsSpellInRange(v52.KillShot)) or ((716 + 342) >= (2058 - 856))) then
				return "kill_shot precombat 10";
			end
		end
		if (((4867 - (1074 + 82)) > (7352 - 3997)) and v15:Exists() and v52.KillShot:IsCastable() and (v15:HealthPercentage() <= (1804 - (214 + 1570)))) then
			if (v24(v56.KillShotMouseover, not v15:IsSpellInRange(v52.KillShot)) or ((2361 - (990 + 465)) >= (919 + 1310))) then
				return "kill_shot_mouseover precombat 11";
			end
		end
		if (((561 + 727) > (1217 + 34)) and v52.KillCommand:IsReady()) then
			if (v25(v56.KillCommandPetAttack) or ((17760 - 13247) < (5078 - (1668 + 58)))) then
				return "kill_command precombat 12";
			end
		end
		if ((v63 > (627 - (512 + 114))) or ((5383 - 3318) >= (6606 - 3410))) then
			if (v52.MultiShot:IsReady() or ((15226 - 10850) <= (689 + 792))) then
				if (v24(v52.MultiShot, not v13:IsSpellInRange(v52.MultiShot)) or ((635 + 2757) >= (4122 + 619))) then
					return "multishot precombat 14";
				end
			end
		elseif (((11215 - 7890) >= (4148 - (109 + 1885))) and v52.CobraShot:IsReady()) then
			if (v24(v56.CobraShotPetAttack, not v13:IsSpellInRange(v52.CobraShot)) or ((2764 - (1269 + 200)) >= (6196 - 2963))) then
				return "cobra_shot precombat 16";
			end
		end
	end
	local function v80()
		local v107 = 815 - (98 + 717);
		while true do
			if (((5203 - (802 + 24)) > (2831 - 1189)) and (v107 == (0 - 0))) then
				if (((698 + 4025) > (1042 + 314)) and v52.Berserking:IsCastable() and (v12:BuffUp(v52.CalloftheWildBuff) or (not v52.CalloftheWild:IsAvailable() and v12:BuffUp(v52.BestialWrathBuff)) or (v60 < (3 + 10)))) then
					if (v25(v52.Berserking) or ((893 + 3243) <= (9550 - 6117))) then
						return "berserking cds 2";
					end
				end
				if (((14155 - 9910) <= (1657 + 2974)) and v52.BloodFury:IsCastable() and (v12:BuffUp(v52.CalloftheWildBuff) or (not v52.CalloftheWild:IsAvailable() and v12:BuffUp(v52.BestialWrathBuff)) or (v60 < (7 + 9)))) then
					if (((3528 + 748) >= (2846 + 1068)) and v25(v52.BloodFury)) then
						return "blood_fury cds 8";
					end
				end
				v107 = 1 + 0;
			end
			if (((1631 - (797 + 636)) <= (21193 - 16828)) and (v107 == (1620 - (1427 + 192)))) then
				if (((1657 + 3125) > (10856 - 6180)) and v52.AncestralCall:IsCastable() and (v12:BuffUp(v52.CalloftheWildBuff) or (not v52.CalloftheWild:IsAvailable() and v12:BuffUp(v52.BestialWrathBuff)) or (v60 < (15 + 1)))) then
					if (((2205 + 2659) > (2523 - (192 + 134))) and v25(v52.AncestralCall)) then
						return "ancestral_call cds 10";
					end
				end
				if ((v52.Fireblood:IsCastable() and (v12:BuffUp(v52.CalloftheWildBuff) or (not v52.CalloftheWild:IsAvailable() and v12:BuffUp(v52.BestialWrathBuff)) or (v60 < (1285 - (316 + 960))))) or ((2060 + 1640) == (1935 + 572))) then
					if (((4136 + 338) >= (1047 - 773)) and v25(v52.Fireblood)) then
						return "fireblood cds 12";
					end
				end
				break;
			end
		end
	end
	local function v81()
		local v108 = 551 - (83 + 468);
		local v109;
		while true do
			if ((v108 == (1806 - (1202 + 604))) or ((8841 - 6947) <= (2339 - 933))) then
				v109 = v50.HandleTopTrinket(v55, v28, 110 - 70, nil);
				if (((1897 - (45 + 280)) >= (1478 + 53)) and v109) then
					return v109;
				end
				v108 = 1 + 0;
			end
			if ((v108 == (1 + 0)) or ((2594 + 2093) < (799 + 3743))) then
				v109 = v50.HandleBottomTrinket(v55, v28, 74 - 34, nil);
				if (((5202 - (340 + 1571)) > (658 + 1009)) and v109) then
					return v109;
				end
				break;
			end
		end
	end
	local function v82()
		local v110 = 1772 - (1733 + 39);
		while true do
			if ((v110 == (10 - 6)) or ((1907 - (125 + 909)) == (3982 - (1096 + 852)))) then
				if (v52.SerpentSting:IsReady() or ((1264 + 1552) < (15 - 4))) then
					if (((3588 + 111) < (5218 - (409 + 103))) and v50.CastTargetIf(v52.SerpentSting, v61, "min", v70, v75, not v13:IsSpellInRange(v52.SerpentSting), nil, nil, v56.SerpentStingMouseover)) then
						return "serpent_sting cleave 34";
					end
				end
				if (((2882 - (46 + 190)) >= (971 - (51 + 44))) and v52.Barrage:IsReady() and (v16:BuffRemains(v52.FrenzyPetBuff) > v52.Barrage:ExecuteTime())) then
					if (((174 + 440) <= (4501 - (1114 + 203))) and v24(v52.Barrage, not v13:IsSpellInRange(v52.Barrage))) then
						return "barrage cleave 36";
					end
				end
				if (((3852 - (228 + 498)) == (678 + 2448)) and v52.MultiShot:IsReady() and (v16:BuffRemains(v52.BeastCleavePetBuff) < (v12:GCD() * (2 + 1)))) then
					if (v24(v52.MultiShot, not v13:IsSpellInRange(v52.MultiShot)) or ((2850 - (174 + 489)) >= (12906 - 7952))) then
						return "multishot cleave 38";
					end
				end
				if ((v52.AspectoftheWild:IsCastable() and v28) or ((5782 - (830 + 1075)) == (4099 - (303 + 221)))) then
					if (((1976 - (231 + 1038)) > (527 + 105)) and v25(v52.AspectoftheWild)) then
						return "aspect_of_the_wild cleave 40";
					end
				end
				v110 = 1167 - (171 + 991);
			end
			if ((v110 == (20 - 15)) or ((1466 - 920) >= (6697 - 4013))) then
				if (((1173 + 292) <= (15076 - 10775)) and v28 and v52.LightsJudgment:IsCastable() and (v12:BuffDown(v52.BestialWrathBuff) or (v13:TimeToDie() < (14 - 9)))) then
					if (((2746 - 1042) > (4405 - 2980)) and v24(v52.LightsJudgment, nil, not v13:IsInRange(1253 - (111 + 1137)))) then
						return "lights_judgment cleave 40";
					end
				end
				if (v52.KillShot:IsReady() or ((845 - (91 + 67)) == (12601 - 8367))) then
					if (v24(v52.KillShot, not v13:IsSpellInRange(v52.KillShot)) or ((831 + 2499) < (1952 - (423 + 100)))) then
						return "kill_shot cleave 38";
					end
				end
				if (((9 + 1138) >= (927 - 592)) and v15:Exists() and v52.KillShot:IsCastable() and (v15:HealthPercentage() <= (11 + 9))) then
					if (((4206 - (326 + 445)) > (9151 - 7054)) and v24(v56.KillShotMouseover, not v15:IsSpellInRange(v52.KillShot))) then
						return "kill_shot_mouseover cleave 39";
					end
				end
				if ((v52.CobraShot:IsReady() and (v12:FocusTimeToMax() < (v58 * (4 - 2)))) or ((8800 - 5030) >= (4752 - (530 + 181)))) then
					if (v24(v56.CobraShotPetAttack, not v13:IsSpellInRange(v52.CobraShot)) or ((4672 - (614 + 267)) <= (1643 - (19 + 13)))) then
						return "cobra_shot cleave 42";
					end
				end
				v110 = 9 - 3;
			end
			if ((v110 == (4 - 2)) or ((13077 - 8499) <= (522 + 1486))) then
				if (((1978 - 853) <= (4305 - 2229)) and v52.Bloodshed:IsCastable()) then
					if (v24(v52.Bloodshed, not v13:IsSpellInRange(v52.Bloodshed)) or ((2555 - (1293 + 519)) >= (8974 - 4575))) then
						return "bloodshed cleave 16";
					end
				end
				if (((3015 - 1860) < (3198 - 1525)) and v52.DeathChakram:IsCastable() and v28) then
					if (v24(v52.DeathChakram, not v13:IsSpellInRange(v52.DeathChakram)) or ((10021 - 7697) <= (1361 - 783))) then
						return "death_chakram cleave 18";
					end
				end
				if (((1996 + 1771) == (769 + 2998)) and v52.SteelTrap:IsCastable()) then
					if (((9500 - 5411) == (945 + 3144)) and v25(v56.SteelTrap)) then
						return "steel_trap cleave 22";
					end
				end
				if (((1481 + 2977) >= (1047 + 627)) and v52.AMurderofCrows:IsReady() and v28) then
					if (((2068 - (709 + 387)) <= (3276 - (673 + 1185))) and v24(v52.AMurderofCrows, not v13:IsSpellInRange(v52.AMurderofCrows))) then
						return "a_murder_of_crows cleave 24";
					end
				end
				v110 = 8 - 5;
			end
			if ((v110 == (19 - 13)) or ((8124 - 3186) < (3407 + 1355))) then
				if ((v52.WailingArrow:IsReady() and ((v16:BuffRemains(v52.FrenzyPetBuff) > v52.WailingArrow:ExecuteTime()) or (v60 < (4 + 1)))) or ((3380 - 876) > (1048 + 3216))) then
					if (((4292 - 2139) == (4225 - 2072)) and v24(v52.WailingArrow, not v13:IsSpellInRange(v52.WailingArrow))) then
						return "wailing_arrow cleave 44";
					end
				end
				if ((v52.BagofTricks:IsCastable() and v28 and (v12:BuffDown(v52.BestialWrathBuff) or (v60 < (1885 - (446 + 1434))))) or ((1790 - (1040 + 243)) >= (7733 - 5142))) then
					if (((6328 - (559 + 1288)) == (6412 - (609 + 1322))) and v25(v52.BagofTricks)) then
						return "bag_of_tricks cleave 46";
					end
				end
				if ((v52.ArcaneTorrent:IsCastable() and v28 and ((v12:Focus() + v12:FocusRegen() + (484 - (13 + 441))) < v12:FocusMax())) or ((8699 - 6371) < (1815 - 1122))) then
					if (((21555 - 17227) == (162 + 4166)) and v25(v52.ArcaneTorrent)) then
						return "arcane_torrent cleave 48";
					end
				end
				break;
			end
			if (((5767 - 4179) >= (474 + 858)) and (v110 == (0 + 0))) then
				if (v52.BarbedShot:IsCastable() or ((12386 - 8212) > (2325 + 1923))) then
					if (v50.CastTargetIf(v52.BarbedShot, v61, "max", v69, v71, not v13:IsSpellInRange(v52.BarbedShot)) or ((8434 - 3848) <= (55 + 27))) then
						return "barbed_shot cleave 2";
					end
				end
				if (((2149 + 1714) == (2776 + 1087)) and v52.BarbedShot:IsCastable()) then
					if (v50.CastTargetIf(v52.BarbedShot, v61, "min", v68, v72, not v13:IsSpellInRange(v52.BarbedShot)) or ((237 + 45) <= (42 + 0))) then
						return "barbed_shot cleave 4";
					end
				end
				if (((5042 - (153 + 280)) >= (2211 - 1445)) and v52.MultiShot:IsReady() and (v16:BuffRemains(v52.BeastCleavePetBuff) < (0.5 + 0 + v58)) and (not v52.BloodyFrenzy:IsAvailable() or v52.CalloftheWild:CooldownDown())) then
					if (v24(v52.MultiShot, nil, nil, not v13:IsSpellInRange(v52.MultiShot)) or ((455 + 697) == (1303 + 1185))) then
						return "multishot cleave 6";
					end
				end
				if (((3106 + 316) > (2428 + 922)) and v52.BestialWrath:IsCastable() and v28) then
					if (((1334 - 457) > (233 + 143)) and v25(v52.BestialWrath)) then
						return "bestial_wrath cleave 8";
					end
				end
				v110 = 668 - (89 + 578);
			end
			if ((v110 == (1 + 0)) or ((6481 - 3363) <= (2900 - (572 + 477)))) then
				if ((v52.CalloftheWild:IsCastable() and v28) or ((23 + 142) >= (2096 + 1396))) then
					if (((472 + 3477) < (4942 - (84 + 2))) and v24(v52.CalloftheWild)) then
						return "call_of_the_wild cleave 10";
					end
				end
				if ((v52.KillCommand:IsReady() and (v52.KillCleave:IsAvailable())) or ((7046 - 2770) < (2173 + 843))) then
					if (((5532 - (497 + 345)) > (106 + 4019)) and v24(v52.KillCommand, nil, nil, not v13:IsInRange(9 + 41))) then
						return "kill_command cleave 12";
					end
				end
				if (v52.ExplosiveShot:IsReady() or ((1383 - (605 + 728)) >= (640 + 256))) then
					if (v24(v52.ExplosiveShot, not v13:IsSpellInRange(v52.ExplosiveShot)) or ((3810 - 2096) >= (136 + 2822))) then
						return "explosive_shot cleave 12";
					end
				end
				if ((v52.Stampede:IsCastable() and v28) or ((5512 - 4021) < (581 + 63))) then
					if (((1950 - 1246) < (746 + 241)) and v24(v52.Stampede, not v13:IsSpellInRange(v52.Stampede))) then
						return "stampede cleave 14";
					end
				end
				v110 = 491 - (457 + 32);
			end
			if (((1578 + 2140) > (3308 - (832 + 570))) and (v110 == (3 + 0))) then
				if (v52.BarbedShot:IsCastable() or ((250 + 708) > (12863 - 9228))) then
					if (((1687 + 1814) <= (5288 - (588 + 208))) and v50.CastTargetIf(v56.BarbedShotPetAttack, v61, "max", v69, v73, not v13:IsSpellInRange(v52.BarbedShot), nil, nil, v56.BarbedShotMouseover)) then
						return "barbed_shot cleave 26";
					end
				end
				if (v52.BarbedShot:IsCastable() or ((9276 - 5834) < (4348 - (884 + 916)))) then
					if (((6019 - 3144) >= (849 + 615)) and v50.CastTargetIf(v56.BarbedShotPetAttack, v61, "min", v68, v74, not v13:IsSpellInRange(v52.BarbedShot), nil, nil, v56.BarbedShotMouseover)) then
						return "barbed_shot cleave 28";
					end
				end
				if (v52.KillCommand:IsReady() or ((5450 - (232 + 421)) >= (6782 - (1569 + 320)))) then
					if (v24(v56.KillCommandPetAttack, not v13:IsSpellInRange(v52.KillCommand)) or ((136 + 415) > (393 + 1675))) then
						return "kill_command cleave 30";
					end
				end
				if (((7123 - 5009) > (1549 - (316 + 289))) and v52.DireBeast:IsCastable()) then
					if (v24(v52.DireBeast, not v13:IsSpellInRange(v52.DireBeast)) or ((5921 - 3659) >= (143 + 2953))) then
						return "dire_beast cleave 32";
					end
				end
				v110 = 1457 - (666 + 787);
			end
		end
	end
	local function v83()
		local v111 = 425 - (360 + 65);
		while true do
			if ((v111 == (7 + 0)) or ((2509 - (79 + 175)) >= (5576 - 2039))) then
				if (v28 or ((2995 + 842) < (4002 - 2696))) then
					if (((5681 - 2731) == (3849 - (503 + 396))) and v52.BagofTricks:IsCastable() and (v12:BuffDown(v52.BestialWrathBuff) or (v60 < (186 - (92 + 89))))) then
						if (v25(v52.BagofTricks) or ((9161 - 4438) < (1692 + 1606))) then
							return "bag_of_tricks st 38";
						end
					end
					if (((673 + 463) >= (602 - 448)) and v52.ArcanePulse:IsCastable() and (v12:BuffDown(v52.BestialWrathBuff) or (v60 < (1 + 4)))) then
						if (v25(v52.ArcanePulse) or ((617 - 346) > (4143 + 605))) then
							return "arcane_pulse st 40";
						end
					end
					if (((2264 + 2476) >= (9599 - 6447)) and v52.ArcaneTorrent:IsCastable() and ((v12:Focus() + v12:FocusRegen() + 2 + 13) < v12:FocusMax())) then
						if (v25(v52.ArcaneTorrent) or ((3931 - 1353) >= (4634 - (485 + 759)))) then
							return "arcane_torrent st 42";
						end
					end
				end
				break;
			end
			if (((94 - 53) <= (2850 - (442 + 747))) and (v111 == (1138 - (832 + 303)))) then
				if (((1547 - (88 + 858)) < (1086 + 2474)) and v52.AMurderofCrows:IsCastable() and v28) then
					if (((195 + 40) < (29 + 658)) and v24(v52.AMurderofCrows, not v13:IsSpellInRange(v52.AMurderofCrows))) then
						return "a_murder_of_crows st 14";
					end
				end
				if (((5338 - (766 + 23)) > (5692 - 4539)) and v52.SteelTrap:IsCastable()) then
					if (v25(v52.SteelTrap) or ((6392 - 1718) < (12308 - 7636))) then
						return "steel_trap st 16";
					end
				end
				if (((12449 - 8781) < (5634 - (1036 + 37))) and v52.ExplosiveShot:IsReady()) then
					if (v24(v52.ExplosiveShot, not v13:IsSpellInRange(v52.ExplosiveShot)) or ((323 + 132) == (7020 - 3415))) then
						return "explosive_shot st 18";
					end
				end
				v111 = 4 + 0;
			end
			if ((v111 == (1482 - (641 + 839))) or ((3576 - (910 + 3)) == (8443 - 5131))) then
				if (((5961 - (1466 + 218)) <= (2057 + 2418)) and v52.BestialWrath:IsCastable() and v28) then
					if (v25(v52.BestialWrath) or ((2018 - (556 + 592)) == (423 + 766))) then
						return "bestial_wrath st 12";
					end
				end
				if (((2361 - (329 + 479)) <= (3987 - (174 + 680))) and v52.DeathChakram:IsCastable() and v28) then
					if (v24(v52.DeathChakram, nil, nil, not v13:IsSpellInRange(v52.DeathChakram)) or ((7686 - 5449) >= (7277 - 3766))) then
						return "death_chakram st 14";
					end
				end
				if (v52.KillCommand:IsReady() or ((946 + 378) > (3759 - (396 + 343)))) then
					if (v24(v56.KillCommandPetAttack, not v13:IsSpellInRange(v52.KillCommand)) or ((265 + 2727) == (3358 - (29 + 1448)))) then
						return "kill_command st 22";
					end
				end
				v111 = 1392 - (135 + 1254);
			end
			if (((11700 - 8594) > (7125 - 5599)) and (v111 == (4 + 1))) then
				if (((4550 - (389 + 1138)) < (4444 - (102 + 472))) and v52.SerpentSting:IsReady()) then
					if (((135 + 8) > (42 + 32)) and v50.CastTargetIf(v52.SerpentSting, v61, "min", v70, v78, not v13:IsSpellInRange(v52.SerpentSting), nil, nil, v56.SerpentStingMouseover)) then
						return "serpent_sting st 28";
					end
				end
				if (((17 + 1) < (3657 - (320 + 1225))) and v52.KillShot:IsReady()) then
					if (((1952 - 855) <= (997 + 631)) and v24(v52.KillShot, not v13:IsSpellInRange(v52.KillShot))) then
						return "kill_shot st 30";
					end
				end
				if (((6094 - (157 + 1307)) == (6489 - (821 + 1038))) and v15:Exists() and v52.KillShot:IsCastable() and (v15:HealthPercentage() <= (49 - 29))) then
					if (((388 + 3152) > (4765 - 2082)) and v24(v56.KillShotMouseover, not v15:IsSpellInRange(v52.KillShot))) then
						return "kill_shot_mouseover st 31";
					end
				end
				v111 = 3 + 3;
			end
			if (((11882 - 7088) >= (4301 - (834 + 192))) and (v111 == (1 + 0))) then
				if (((381 + 1103) == (32 + 1452)) and v52.KillCommand:IsReady() and (v52.KillCommand:FullRechargeTime() < v58) and v52.AlphaPredator:IsAvailable()) then
					if (((2217 - 785) < (3859 - (300 + 4))) and v24(v56.KillCommandPetAttack, not v13:IsSpellInRange(v52.KillCommand))) then
						return "kill_command st 4";
					end
				end
				if ((v52.Stampede:IsCastable() and v28) or ((285 + 780) > (9366 - 5788))) then
					if (v24(v52.Stampede, nil, nil, not v13:IsSpellInRange(v52.Stampede)) or ((5157 - (112 + 250)) < (561 + 846))) then
						return "stampede st 8";
					end
				end
				if (((4641 - 2788) < (2758 + 2055)) and v52.Bloodshed:IsCastable()) then
					if (v24(v52.Bloodshed, not v13:IsSpellInRange(v52.Bloodshed)) or ((1459 + 1362) < (1819 + 612))) then
						return "bloodshed st 10";
					end
				end
				v111 = 1 + 1;
			end
			if (((5 + 1) == v111) or ((4288 - (1001 + 413)) < (4863 - 2682))) then
				if ((v52.AspectoftheWild:IsCastable() and v28) or ((3571 - (244 + 638)) <= (1036 - (627 + 66)))) then
					if (v25(v52.AspectoftheWild) or ((5568 - 3699) == (2611 - (512 + 90)))) then
						return "aspect_of_the_wild st 32";
					end
				end
				if (v52.CobraShot:IsReady() or ((5452 - (1665 + 241)) < (3039 - (373 + 344)))) then
					if (v24(v56.CobraShotPetAttack, not v13:IsSpellInRange(v52.CobraShot)) or ((940 + 1142) == (1263 + 3510))) then
						return "cobra_shot st 34";
					end
				end
				if (((8556 - 5312) > (1784 - 729)) and v52.WailingArrow:IsReady() and ((v16:BuffRemains(v52.FrenzyPetBuff) > v52.WailingArrow:ExecuteTime()) or (v60 < (1104 - (35 + 1064))))) then
					if (v24(v52.WailingArrow, not v13:IsSpellInRange(v52.WailingArrow), true) or ((2411 + 902) <= (3803 - 2025))) then
						return "wailing_arrow st 36";
					end
				end
				v111 = 1 + 6;
			end
			if ((v111 == (1240 - (298 + 938))) or ((2680 - (233 + 1026)) >= (3770 - (636 + 1030)))) then
				if (((927 + 885) <= (3174 + 75)) and v52.BarbedShot:IsCastable()) then
					if (((483 + 1140) <= (133 + 1824)) and v50.CastTargetIf(v56.BarbedShotPetAttack, v61, "min", v68, v77, not v13:IsSpellInRange(v52.BarbedShot), nil, nil, v56.BarbedShotMouseover)) then
						return "barbed_shot st 24";
					end
				end
				if (((4633 - (55 + 166)) == (856 + 3556)) and v52.BarbedShot:IsCastable() and v77(v13)) then
					if (((176 + 1574) >= (3215 - 2373)) and v24(v56.BarbedShotPetAttack, not v13:IsSpellInRange(v52.BarbedShot))) then
						return "barbed_shot st mt_backup 25";
					end
				end
				if (((4669 - (36 + 261)) > (3235 - 1385)) and v52.DireBeast:IsCastable()) then
					if (((1600 - (34 + 1334)) < (316 + 505)) and v24(v52.DireBeast, not v13:IsSpellInRange(v52.DireBeast))) then
						return "dire_beast st 26";
					end
				end
				v111 = 4 + 1;
			end
			if (((1801 - (1035 + 248)) < (923 - (20 + 1))) and ((0 + 0) == v111)) then
				if (((3313 - (134 + 185)) > (1991 - (549 + 584))) and v52.BarbedShot:IsCastable()) then
					if (v50.CastTargetIf(v56.BarbedShotPetAttack, v61, "min", v68, v76, not v13:IsSpellInRange(v52.BarbedShot), nil, nil, v56.BarbedShotMouseover) or ((4440 - (314 + 371)) <= (3141 - 2226))) then
						return "barbed_shot st 2";
					end
				end
				if (((4914 - (478 + 490)) > (1983 + 1760)) and v52.BarbedShot:IsCastable() and v76(v13)) then
					if (v24(v56.BarbedShotPetAttack, not v13:IsSpellInRange(v52.BarbedShot)) or ((2507 - (786 + 386)) >= (10707 - 7401))) then
						return "barbed_shot st mt_backup 3";
					end
				end
				if (((6223 - (1055 + 324)) > (3593 - (1093 + 247))) and v52.CalloftheWild:IsCastable() and v28) then
					if (((402 + 50) == (48 + 404)) and v25(v52.CalloftheWild)) then
						return "call_of_the_wild st 6";
					end
				end
				v111 = 3 - 2;
			end
		end
	end
	local function v84()
		if ((not v12:IsCasting() and not v12:IsChanneling()) or ((15465 - 10908) < (5938 - 3851))) then
			local v118 = 0 - 0;
			local v119;
			while true do
				if (((1379 + 2495) == (14924 - 11050)) and (v118 == (3 - 2))) then
					v119 = v50.InterruptWithStun(v52.Intimidation, 31 + 9);
					if (v119 or ((4955 - 3017) > (5623 - (364 + 324)))) then
						return v119;
					end
					break;
				end
				if ((v118 == (0 - 0)) or ((10210 - 5955) < (1135 + 2288))) then
					v119 = v50.Interrupt(v52.CounterShot, 167 - 127, true);
					if (((2328 - 874) <= (7565 - 5074)) and v119) then
						return v119;
					end
					v118 = 1269 - (1249 + 19);
				end
			end
		end
	end
	local function v85()
		v49();
		v26 = EpicSettings.Toggles['ooc'];
		v27 = EpicSettings.Toggles['aoe'];
		v28 = EpicSettings.Toggles['cds'];
		if (v52.Stomp:IsAvailable() or ((3753 + 404) <= (10910 - 8107))) then
			v9.SplashEnemies.ChangeFriendTargetsTracking("Mine Only");
		else
			v9.SplashEnemies.ChangeFriendTargetsTracking("All");
		end
		local v115 = (v52.BloodBolt:IsPetKnown() and v19.FindBySpellID(v52.BloodBolt:ID()) and v52.BloodBolt) or (v52.Bite:IsPetKnown() and v19.FindBySpellID(v52.Bite:ID()) and v52.Bite) or (v52.Claw:IsPetKnown() and v19.FindBySpellID(v52.Claw:ID()) and v52.Claw) or (v52.Smack:IsPetKnown() and v19.FindBySpellID(v52.Smack:ID()) and v52.Smack) or nil;
		local v116 = (v52.Growl:IsPetKnown() and v19.FindBySpellID(v52.Growl:ID()) and v52.Growl) or nil;
		if (((5939 - (686 + 400)) >= (2340 + 642)) and v27) then
			v61 = v12:GetEnemiesInRange(269 - (73 + 156));
			v62 = (v115 and v12:GetEnemiesInSpellActionRange(v115)) or v13:GetEnemiesInSplashRange(1 + 7);
			v63 = (v115 and #v62) or v13:GetEnemiesInSplashRangeCount(819 - (721 + 90));
		else
			v61 = {};
			v62 = v13 or {};
			v63 = 0 + 0;
		end
		v64 = v13:IsInRange(129 - 89);
		v65 = v13:IsInRange(500 - (224 + 246));
		v66 = (v116 and v13:IsSpellInActionRange(v116)) or v13:IsInRange(48 - 18);
		v58 = v12:GCD() + (0.15 - 0);
		if (((750 + 3384) > (80 + 3277)) and (v50.TargetIsValid() or v12:AffectingCombat())) then
			v59 = v9.BossFightRemains();
			v60 = v59;
			if ((v60 == (8161 + 2950)) or ((6792 - 3375) < (8432 - 5898))) then
				v60 = v9.FightRemains(v61, false);
			end
		end
		if ((v52.Exhilaration:IsCastable() and v46 and (v12:HealthPercentage() <= v47)) or ((3235 - (203 + 310)) <= (2157 - (1238 + 755)))) then
			if (v24(v52.Exhilaration) or ((169 + 2239) < (3643 - (709 + 825)))) then
				return "Exhilaration";
			end
		end
		if (((v12:HealthPercentage() <= v36) and v35 and v54.Healthstone:IsReady()) or ((60 - 27) == (2119 - 664))) then
			if (v25(v56.Healthstone, nil, nil, true) or ((1307 - (196 + 668)) >= (15852 - 11837))) then
				return "healthstone defensive 3";
			end
		end
		if (((7005 - 3623) > (999 - (171 + 662))) and v32 and (v12:HealthPercentage() <= v34)) then
			if ((v33 == "Refreshing Healing Potion") or ((373 - (4 + 89)) == (10721 - 7662))) then
				if (((685 + 1196) > (5679 - 4386)) and v54.RefreshingHealingPotion:IsReady()) then
					if (((925 + 1432) == (3843 - (35 + 1451))) and v25(v56.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if (((1576 - (28 + 1425)) == (2116 - (941 + 1052))) and (v33 == "Dreamwalker's Healing Potion")) then
				if (v54.DreamwalkersHealingPotion:IsReady() or ((1013 + 43) >= (4906 - (822 + 692)))) then
					if (v25(v56.RefreshingHealingPotion) or ((1543 - 462) < (507 + 568))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
		if (not (v12:IsMounted() or v12:IsInVehicle()) or ((1346 - (45 + 252)) >= (4386 + 46))) then
			local v120 = 0 + 0;
			while true do
				if ((v120 == (2 - 1)) or ((5201 - (114 + 319)) <= (1213 - 367))) then
					if ((v52.MendPet:IsCastable() and v44 and (v16:HealthPercentage() < v45)) or ((4302 - 944) <= (906 + 514))) then
						if (v25(v52.MendPet) or ((5570 - 1831) <= (6296 - 3291))) then
							return "Mend Pet High Priority";
						end
					end
					break;
				end
				if ((v120 == (1963 - (556 + 1407))) or ((2865 - (741 + 465)) >= (2599 - (170 + 295)))) then
					if ((v52.SummonPet:IsCastable() and v40) or ((1718 + 1542) < (2164 + 191))) then
						if (v25(v53[v41]) or ((1646 - 977) == (3501 + 722))) then
							return "Summon Pet";
						end
					end
					if ((v52.RevivePet:IsCastable() and v43 and v16:IsDeadOrGhost()) or ((1086 + 606) < (333 + 255))) then
						if (v25(v52.RevivePet) or ((6027 - (957 + 273)) < (977 + 2674))) then
							return "Revive Pet";
						end
					end
					v120 = 1 + 0;
				end
			end
		end
		if (v50.TargetIsValid() or ((15916 - 11739) > (12780 - 7930))) then
			local v121 = 0 - 0;
			local v122;
			local v123;
			while true do
				if ((v121 == (19 - 15)) or ((2180 - (389 + 1391)) > (698 + 413))) then
					if (((318 + 2733) > (2288 - 1283)) and ((v63 < (953 - (783 + 168))) or (not v52.BeastCleave:IsAvailable() and (v63 < (9 - 6))))) then
						local v124 = 0 + 0;
						local v125;
						while true do
							if (((4004 - (309 + 2)) <= (13456 - 9074)) and ((1212 - (1090 + 122)) == v124)) then
								v125 = v83();
								if (v125 or ((1065 + 2217) > (13769 - 9669))) then
									return v125;
								end
								break;
							end
						end
					end
					if ((not (v12:IsMounted() or v12:IsInVehicle()) and not v16:IsDeadOrGhost() and v52.MendPet:IsCastable() and (v16:HealthPercentage() < v45) and v44) or ((2451 + 1129) < (3962 - (628 + 490)))) then
						if (((16 + 73) < (11116 - 6626)) and v25(v52.MendPet)) then
							return "Mend Pet Low Priority (w/ Target)";
						end
					end
					break;
				end
				if ((v121 == (0 - 0)) or ((5757 - (431 + 343)) < (3651 - 1843))) then
					if (((11076 - 7247) > (2978 + 791)) and not v12:AffectingCombat() and not v26) then
						local v126 = 0 + 0;
						local v127;
						while true do
							if (((3180 - (556 + 1139)) <= (2919 - (6 + 9))) and (v126 == (0 + 0))) then
								v127 = v79();
								if (((2187 + 2082) == (4438 - (28 + 141))) and v127) then
									return v127;
								end
								break;
							end
						end
					end
					if (((150 + 237) <= (3433 - 651)) and not v12:IsCasting() and not v12:IsChanneling()) then
						local v128 = 0 + 0;
						local v129;
						while true do
							if ((v128 == (1318 - (486 + 831))) or ((4941 - 3042) <= (3228 - 2311))) then
								v129 = v50.Interrupt(v52.CounterShot, 8 + 32, true, v15, v56.CounterShotMouseover);
								if (v129 or ((13634 - 9322) <= (2139 - (668 + 595)))) then
									return v129;
								end
								v128 = 2 + 0;
							end
							if (((451 + 1781) <= (7079 - 4483)) and (v128 == (290 - (23 + 267)))) then
								v129 = v50.Interrupt(v52.CounterShot, 1984 - (1129 + 815), true);
								if (((2482 - (371 + 16)) < (5436 - (1326 + 424))) and v129) then
									return v129;
								end
								v128 = 1 - 0;
							end
							if ((v128 == (7 - 5)) or ((1713 - (88 + 30)) >= (5245 - (720 + 51)))) then
								v129 = v50.InterruptWithStun(v52.Intimidation, 88 - 48, true);
								if (v129 or ((6395 - (421 + 1355)) < (4753 - 1871))) then
									return v129;
								end
								v128 = 2 + 1;
							end
							if ((v128 == (1086 - (286 + 797))) or ((1074 - 780) >= (8001 - 3170))) then
								v129 = v50.InterruptWithStun(v52.Intimidation, 479 - (397 + 42), true, v15, v56.IntimidationMouseover);
								if (((634 + 1395) <= (3884 - (24 + 776))) and v129) then
									return v129;
								end
								break;
							end
						end
					end
					v121 = 1 - 0;
				end
				if ((v121 == (787 - (222 + 563))) or ((4487 - 2450) == (1743 + 677))) then
					if (((4648 - (23 + 167)) > (5702 - (690 + 1108))) and v28) then
						local v130 = 0 + 0;
						local v131;
						while true do
							if (((360 + 76) >= (971 - (40 + 808))) and (v130 == (0 + 0))) then
								v131 = v80();
								if (((1912 - 1412) < (1736 + 80)) and v131) then
									return v131;
								end
								break;
							end
						end
					end
					v123 = v81();
					v121 = 2 + 1;
				end
				if (((1960 + 1614) == (4145 - (47 + 524))) and (v121 == (2 + 1))) then
					if (((604 - 383) < (583 - 193)) and v123) then
						return v123;
					end
					if ((v63 > (4 - 2)) or (v52.BeastCleave:IsAvailable() and (v63 > (1727 - (1165 + 561)))) or ((66 + 2147) <= (4401 - 2980))) then
						local v132 = v82();
						if (((1167 + 1891) < (5339 - (341 + 138))) and v132) then
							return v132;
						end
					end
					v121 = 2 + 2;
				end
				if ((v121 == (1 - 0)) or ((1622 - (89 + 237)) >= (14302 - 9856))) then
					v122 = v50.HandleDPSPotion();
					if (v122 or ((2932 - 1539) > (5370 - (581 + 300)))) then
						return v122;
					end
					v121 = 1222 - (855 + 365);
				end
			end
		end
		if ((not (v12:IsMounted() or v12:IsInVehicle()) and not v16:IsDeadOrGhost() and v52.MendPet:IsCastable() and (v16:HealthPercentage() < v45) and v44) or ((10507 - 6083) < (9 + 18))) then
			if (v25(v52.MendPet) or ((3232 - (1030 + 205)) > (3582 + 233))) then
				return "Mend Pet Low Priority (w/o Target)";
			end
		end
	end
	local function v86()
		v9.Print("Beast Mastery by Epic. Supported by Gojira");
		local v117 = (v52.Growl:IsPetKnown() and v19.FindBySpellID(v52.Growl:ID()) and v52.Growl) or nil;
		if (((3224 + 241) > (2199 - (156 + 130))) and not v117) then
			v9.Print("|cffffff00Info|r: Add pet abilities to your action bars to improve range checks.");
		end
	end
	v9.SetAPL(574 - 321, v85, v86);
end;
return v0["Epix_Hunter_BeastMastery.lua"]();

