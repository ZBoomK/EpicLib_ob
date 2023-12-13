local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((5051 - (1192 + 35)) > (1434 - 1025)) and (v5 == (1 - 0))) then
			return v6(...);
		end
		if (((3289 - 1202) == (3857 - (1134 + 636))) and (v5 == (495 - (263 + 232)))) then
			v6 = v0[v4];
			if (not v6 or ((7632 - 4228) > (6555 - 2052))) then
				return v1(v4, ...);
			end
			v5 = 158 - (26 + 131);
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
			if ((v88 == (15 - 11)) or ((4365 - (240 + 619)) <= (316 + 993))) then
				v48 = EpicSettings.Settings['ExhilarationHP'] or (0 - 0);
				v49 = EpicSettings.Settings['UseTranq'];
				break;
			end
			if (((196 + 2759) == (4699 - (1344 + 400))) and (v88 == (408 - (255 + 150)))) then
				v44 = EpicSettings.Settings['UseRevive'];
				v45 = EpicSettings.Settings['UseMendPet'];
				v46 = EpicSettings.Settings['MendPetHP'] or (0 + 0);
				v47 = EpicSettings.Settings['UseExhilaration'];
				v88 = 3 + 1;
			end
			if ((v88 == (0 - 0)) or ((9376 - 6473) == (3234 - (404 + 1335)))) then
				v31 = EpicSettings.Settings['UseRacials'];
				v33 = EpicSettings.Settings['UseHealingPotion'];
				v34 = EpicSettings.Settings['HealingPotionName'] or (406 - (183 + 223));
				v35 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v88 = 1 + 0;
			end
			if (((1636 + 2910) >= (2612 - (10 + 327))) and ((2 + 0) == v88)) then
				v40 = EpicSettings.Settings['InterruptThreshold'] or (338 - (118 + 220));
				v41 = EpicSettings.Settings['UsePet'];
				v42 = EpicSettings.Settings['SummonPetSlot'] or (0 + 0);
				v43 = EpicSettings.Settings['UseSteelTrap'];
				v88 = 452 - (108 + 341);
			end
			if (((368 + 451) >= (92 - 70)) and (v88 == (1494 - (711 + 782)))) then
				v36 = EpicSettings.Settings['UseHealthstone'];
				v37 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v38 = EpicSettings.Settings['InterruptWithStun'] or (469 - (270 + 199));
				v39 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v88 = 1821 - (580 + 1239);
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
	local v60 = 6903 + 4208;
	local v61 = 12278 - (645 + 522);
	v10:RegisterForEvent(function()
		local v89 = 1790 - (1010 + 780);
		while true do
			if (((3161 + 1) == (15063 - 11901)) and (v89 == (0 - 0))) then
				v60 = 12947 - (1045 + 791);
				v61 = 28124 - 17013;
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
		return (v93:DebuffStack(v53.LatentPoisonDebuff) > (19 - 10)) and ((v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + (1559.25 - (1381 + 178))))) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < (12 + 0 + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < (3 + 0)) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp())) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown()));
	end
	local function v73(v94)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + 0.25 + 0))) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < ((41 - 29) + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < (2 + 1)) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp())) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown());
	end
	local function v74(v95)
		return (v95:DebuffStack(v53.LatentPoisonDebuff) > (479 - (381 + 89))) and (v13:BuffUp(v53.CalloftheWildBuff) or (v61 < (8 + 1)) or (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1.2 + 0))) or v53.Savagery:IsAvailable());
	end
	local function v75(v96)
		return v13:BuffUp(v53.CalloftheWildBuff) or (v61 < (14 - 5)) or (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1157.2 - (1074 + 82)))) or v53.Savagery:IsAvailable();
	end
	local function v76(v97)
		return v97:DebuffRefreshable(v53.SerpentStingDebuff) and (v97:TimeToDie() > v53.SerpentStingDebuff:BaseDuration());
	end
	local function v77(v98)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + (0.25 - 0)))) or (v53.ScentofBlood:IsAvailable() and (v17:BuffStack(v53.FrenzyPetBuff) < (1787 - (214 + 1570))) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp()));
	end
	local function v78(v99)
		return (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1456.4 - (990 + 465)))) or v13:BuffUp(v53.CalloftheWildBuff) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown()) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < (5 + 7 + v59))) or v53.Savagery:IsAvailable() or (v61 < (4 + 5));
	end
	local function v79(v100)
		return v100:DebuffRefreshable(v53.SerpentStingDebuff) and (v14:TimeToDie() > v53.SerpentStingDebuff:BaseDuration());
	end
	local function v80()
		local v101 = 0 + 0;
		while true do
			if ((v101 == (7 - 5)) or ((4095 - (1668 + 58)) > (5055 - (512 + 114)))) then
				if (((10676 - 6581) >= (6579 - 3396)) and v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (69 - 49))) then
					if (v26(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot)) or ((1727 + 1984) < (189 + 819))) then
						return "kill_shot_mouseover precombat 11";
					end
				end
				if (v53.KillCommand:IsReady() or ((912 + 137) <= (3055 - 2149))) then
					if (((6507 - (109 + 1885)) > (4195 - (1269 + 200))) and v26(v57.KillCommandPetAttack)) then
						return "kill_command precombat 12";
					end
				end
				v101 = 5 - 2;
			end
			if ((v101 == (815 - (98 + 717))) or ((2307 - (802 + 24)) >= (4583 - 1925))) then
				if ((v15:Exists() and v53.Misdirection:IsReady()) or ((4066 - 846) == (202 + 1162))) then
					if (v26(v57.MisdirectionFocus) or ((810 + 244) > (558 + 2834))) then
						return "misdirection precombat 0";
					end
				end
				if ((v53.SteelTrap:IsCastable() and not v53.WailingArrow:IsAvailable() and v53.SteelTrap:IsAvailable()) or ((146 + 530) >= (4567 - 2925))) then
					if (((13792 - 9656) > (858 + 1539)) and v26(v53.SteelTrap)) then
						return "steel_trap precombat 2";
					end
				end
				v101 = 1 + 0;
			end
			if ((v101 == (3 + 0)) or ((3152 + 1182) == (1982 + 2263))) then
				if ((v64 > (1434 - (797 + 636))) or ((20761 - 16485) <= (4650 - (1427 + 192)))) then
					if (v53.MultiShot:IsReady() or ((1657 + 3125) <= (2783 - 1584))) then
						if (v26(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot)) or ((4373 + 491) < (862 + 1040))) then
							return "multishot precombat 14";
						end
					end
				elseif (((5165 - (192 + 134)) >= (4976 - (316 + 960))) and v53.CobraShot:IsReady()) then
					if (v26(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot)) or ((599 + 476) > (1481 + 437))) then
						return "cobra_shot precombat 16";
					end
				end
				break;
			end
			if (((367 + 29) <= (14542 - 10738)) and (v101 == (552 - (83 + 468)))) then
				if ((v53.BarbedShot:IsCastable() and (v53.BarbedShot:Charges() >= (1808 - (1202 + 604)))) or ((19461 - 15292) == (3639 - 1452))) then
					if (((3892 - 2486) == (1731 - (45 + 280))) and v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot))) then
						return "barbed_shot precombat 8";
					end
				end
				if (((1478 + 53) < (3732 + 539)) and v53.KillShot:IsReady()) then
					if (((232 + 403) == (352 + 283)) and v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot))) then
						return "kill_shot precombat 10";
					end
				end
				v101 = 1 + 1;
			end
		end
	end
	local function v81()
		if (((6245 - 2872) <= (5467 - (340 + 1571))) and v53.Berserking:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (6 + 7)))) then
			if (v26(v53.Berserking) or ((5063 - (1733 + 39)) < (9013 - 5733))) then
				return "berserking cds 2";
			end
		end
		if (((5420 - (125 + 909)) >= (2821 - (1096 + 852))) and v53.BloodFury:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (8 + 8)))) then
			if (((1315 - 394) <= (1069 + 33)) and v26(v53.BloodFury)) then
				return "blood_fury cds 8";
			end
		end
		if (((5218 - (409 + 103)) >= (1199 - (46 + 190))) and v53.AncestralCall:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (111 - (51 + 44))))) then
			if (v26(v53.AncestralCall) or ((271 + 689) <= (2193 - (1114 + 203)))) then
				return "ancestral_call cds 10";
			end
		end
		if ((v53.Fireblood:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (735 - (228 + 498))))) or ((448 + 1618) == (515 + 417))) then
			if (((5488 - (174 + 489)) < (12617 - 7774)) and v26(v53.Fireblood)) then
				return "fireblood cds 12";
			end
		end
	end
	local function v82()
		local v102 = 1905 - (830 + 1075);
		local v103;
		while true do
			if ((v102 == (524 - (303 + 221))) or ((5146 - (231 + 1038)) >= (3781 + 756))) then
				v103 = v51.HandleTopTrinket(v56, v29, 1202 - (171 + 991), nil);
				if (v103 or ((17782 - 13467) < (4634 - 2908))) then
					return v103;
				end
				v102 = 2 - 1;
			end
			if ((v102 == (1 + 0)) or ((12896 - 9217) < (1803 - 1178))) then
				v103 = v51.HandleBottomTrinket(v56, v29, 64 - 24, nil);
				if (v103 or ((14297 - 9672) < (1880 - (111 + 1137)))) then
					return v103;
				end
				break;
			end
		end
	end
	local function v83()
		if (v53.BarbedShot:IsCastable() or ((241 - (91 + 67)) > (5297 - 3517))) then
			if (((137 + 409) <= (1600 - (423 + 100))) and v51.CastTargetIf(v53.BarbedShot, v62, "max", v70, v72, not v14:IsSpellInRange(v53.BarbedShot))) then
				return "barbed_shot cleave 2";
			end
		end
		if (v53.BarbedShot:IsCastable() or ((7 + 989) > (11908 - 7607))) then
			if (((2122 + 1948) > (1458 - (326 + 445))) and v51.CastTargetIf(v53.BarbedShot, v62, "min", v69, v73, not v14:IsSpellInRange(v53.BarbedShot))) then
				return "barbed_shot cleave 4";
			end
		end
		if ((v53.MultiShot:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < ((0.25 - 0) + v59)) and (not v53.BloodyFrenzy:IsAvailable() or v53.CalloftheWild:CooldownDown())) or ((1460 - 804) >= (7772 - 4442))) then
			if (v26(v53.MultiShot, nil, nil, not v14:IsSpellInRange(v53.MultiShot)) or ((3203 - (530 + 181)) <= (1216 - (614 + 267)))) then
				return "multishot cleave 6";
			end
		end
		if (((4354 - (19 + 13)) >= (4169 - 1607)) and v53.BestialWrath:IsCastable() and v29) then
			if (v26(v53.BestialWrath) or ((8475 - 4838) >= (10769 - 6999))) then
				return "bestial_wrath cleave 8";
			end
		end
		if ((v53.CalloftheWild:IsCastable() and v29) or ((618 + 1761) > (8050 - 3472))) then
			if (v25(v53.CalloftheWild) or ((1001 - 518) > (2555 - (1293 + 519)))) then
				return "call_of_the_wild cleave 10";
			end
		end
		if (((5006 - 2552) > (1508 - 930)) and v53.KillCommand:IsReady() and (v53.KillCleave:IsAvailable())) then
			if (((1778 - 848) < (19223 - 14765)) and v25(v53.KillCommand, nil, nil, not v14:IsInRange(117 - 67))) then
				return "kill_command cleave 12";
			end
		end
		if (((351 + 311) <= (199 + 773)) and v53.ExplosiveShot:IsReady()) then
			if (((10153 - 5783) == (1010 + 3360)) and v26(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot))) then
				return "explosive_shot cleave 12";
			end
		end
		if ((v53.Stampede:IsCastable() and v29) or ((1582 + 3180) <= (539 + 322))) then
			if (v26(v53.Stampede, not v14:IsSpellInRange(v53.Stampede)) or ((2508 - (709 + 387)) == (6122 - (673 + 1185)))) then
				return "stampede cleave 14";
			end
		end
		if (v53.Bloodshed:IsCastable() or ((9187 - 6019) < (6913 - 4760))) then
			if (v26(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed)) or ((8186 - 3210) < (953 + 379))) then
				return "bloodshed cleave 16";
			end
		end
		if (((3459 + 1169) == (6248 - 1620)) and v53.DeathChakram:IsCastable() and v29) then
			if (v26(v53.DeathChakram, not v14:IsSpellInRange(v53.DeathChakram)) or ((14 + 40) == (787 - 392))) then
				return "death_chakram cleave 18";
			end
		end
		if (((160 - 78) == (1962 - (446 + 1434))) and v53.SteelTrap:IsCastable()) then
			if (v26(v57.SteelTrap) or ((1864 - (1040 + 243)) < (841 - 559))) then
				return "steel_trap cleave 22";
			end
		end
		if ((v53.AMurderofCrows:IsReady() and v29) or ((6456 - (559 + 1288)) < (4426 - (609 + 1322)))) then
			if (((1606 - (13 + 441)) == (4304 - 3152)) and v26(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows))) then
				return "a_murder_of_crows cleave 24";
			end
		end
		if (((4966 - 3070) <= (17043 - 13621)) and v53.BarbedShot:IsCastable()) then
			if (v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "max", v70, v74, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover) or ((37 + 953) > (5883 - 4263))) then
				return "barbed_shot cleave 26";
			end
		end
		if (v53.BarbedShot:IsCastable() or ((312 + 565) > (2058 + 2637))) then
			if (((7985 - 5294) >= (1013 + 838)) and v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v75, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
				return "barbed_shot cleave 28";
			end
		end
		if (v53.KillCommand:IsReady() or ((5489 - 2504) >= (3211 + 1645))) then
			if (((2379 + 1897) >= (859 + 336)) and v26(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand))) then
				return "kill_command cleave 30";
			end
		end
		if (((2714 + 518) <= (4589 + 101)) and v53.DireBeast:IsCastable()) then
			if (v26(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast)) or ((1329 - (153 + 280)) >= (9084 - 5938))) then
				return "dire_beast cleave 32";
			end
		end
		if (((2749 + 312) >= (1168 + 1790)) and v53.SerpentSting:IsReady()) then
			if (((1668 + 1519) >= (585 + 59)) and v51.CastTargetIf(v53.SerpentSting, v62, "min", v71, v76, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover)) then
				return "serpent_sting cleave 34";
			end
		end
		if (((467 + 177) <= (1071 - 367)) and v53.Barrage:IsReady() and (v17:BuffRemains(v53.FrenzyPetBuff) > v53.Barrage:ExecuteTime())) then
			if (((593 + 365) > (1614 - (89 + 578))) and v26(v53.Barrage, not v14:IsSpellInRange(v53.Barrage))) then
				return "barrage cleave 36";
			end
		end
		if (((3209 + 1283) >= (5517 - 2863)) and v53.MultiShot:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < (v13:GCD() * (1051 - (572 + 477))))) then
			if (((465 + 2977) >= (902 + 601)) and v26(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot))) then
				return "multishot cleave 38";
			end
		end
		if ((v53.AspectoftheWild:IsCastable() and v29) or ((379 + 2791) <= (1550 - (84 + 2)))) then
			if (v26(v53.AspectoftheWild) or ((7905 - 3108) == (3162 + 1226))) then
				return "aspect_of_the_wild cleave 40";
			end
		end
		if (((1393 - (497 + 345)) <= (18 + 663)) and v29 and v53.LightsJudgment:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v14:TimeToDie() < (1 + 4)))) then
			if (((4610 - (605 + 728)) > (291 + 116)) and v25(v53.LightsJudgment, nil, not v14:IsInRange(11 - 6))) then
				return "lights_judgment cleave 40";
			end
		end
		if (((216 + 4479) >= (5231 - 3816)) and v53.KillShot:IsReady()) then
			if (v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot)) or ((2896 + 316) <= (2615 - 1671))) then
				return "kill_shot cleave 38";
			end
		end
		if ((v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (16 + 4))) or ((3585 - (457 + 32)) <= (763 + 1035))) then
			if (((4939 - (832 + 570)) == (3333 + 204)) and v26(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot))) then
				return "kill_shot_mouseover cleave 39";
			end
		end
		if (((1001 + 2836) >= (5555 - 3985)) and v53.CobraShot:IsReady() and (v13:FocusTimeToMax() < (v59 * (1 + 1)))) then
			if (v26(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot)) or ((3746 - (588 + 208)) == (10274 - 6462))) then
				return "cobra_shot cleave 42";
			end
		end
		if (((6523 - (884 + 916)) >= (4852 - 2534)) and v53.WailingArrow:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53.WailingArrow:ExecuteTime()) or (v61 < (3 + 2)))) then
			if (v26(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow)) or ((2680 - (232 + 421)) > (4741 - (1569 + 320)))) then
				return "wailing_arrow cleave 44";
			end
		end
		if ((v53.BagofTricks:IsCastable() and v29 and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (2 + 3)))) or ((216 + 920) > (14547 - 10230))) then
			if (((5353 - (316 + 289)) == (12428 - 7680)) and v26(v53.BagofTricks)) then
				return "bag_of_tricks cleave 46";
			end
		end
		if (((173 + 3563) <= (6193 - (666 + 787))) and v53.ArcaneTorrent:IsCastable() and v29 and ((v13:Focus() + v13:FocusRegen() + (455 - (360 + 65))) < v13:FocusMax())) then
			if (v26(v53.ArcaneTorrent) or ((3169 + 221) <= (3314 - (79 + 175)))) then
				return "arcane_torrent cleave 48";
			end
		end
	end
	local function v84()
		if (v53.BarbedShot:IsCastable() or ((1574 - 575) > (2102 + 591))) then
			if (((1418 - 955) < (1157 - 556)) and v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v77, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
				return "barbed_shot st 2";
			end
		end
		if ((v53.BarbedShot:IsCastable() and v77(v14)) or ((3082 - (503 + 396)) < (868 - (92 + 89)))) then
			if (((8824 - 4275) == (2333 + 2216)) and v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot))) then
				return "barbed_shot st mt_backup 3";
			end
		end
		if (((2766 + 1906) == (18295 - 13623)) and v53.CalloftheWild:IsCastable() and v29) then
			if (v26(v53.CalloftheWild) or ((502 + 3166) < (900 - 505))) then
				return "call_of_the_wild st 6";
			end
		end
		if ((v53.KillCommand:IsReady() and (v53.KillCommand:FullRechargeTime() < v59) and v53.AlphaPredator:IsAvailable()) or ((3635 + 531) == (218 + 237))) then
			if (v26(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand)) or ((13549 - 9100) == (333 + 2330))) then
				return "kill_command st 4";
			end
		end
		if ((v53.Stampede:IsCastable() and v29) or ((6521 - 2244) < (4233 - (485 + 759)))) then
			if (v25(v53.Stampede, nil, nil, not v14:IsSpellInRange(v53.Stampede)) or ((2013 - 1143) >= (5338 - (442 + 747)))) then
				return "stampede st 8";
			end
		end
		if (((3347 - (832 + 303)) < (4129 - (88 + 858))) and v53.Bloodshed:IsCastable()) then
			if (((1417 + 3229) > (2477 + 515)) and v26(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed))) then
				return "bloodshed st 10";
			end
		end
		if (((60 + 1374) < (3895 - (766 + 23))) and v53.BestialWrath:IsCastable() and v29) then
			if (((3880 - 3094) < (4133 - 1110)) and v26(v53.BestialWrath)) then
				return "bestial_wrath st 12";
			end
		end
		if ((v53.DeathChakram:IsCastable() and v29) or ((6433 - 3991) < (251 - 177))) then
			if (((5608 - (1036 + 37)) == (3216 + 1319)) and v25(v53.DeathChakram, nil, nil, not v14:IsSpellInRange(v53.DeathChakram))) then
				return "death_chakram st 14";
			end
		end
		if (v53.KillCommand:IsReady() or ((5859 - 2850) <= (1656 + 449))) then
			if (((3310 - (641 + 839)) < (4582 - (910 + 3))) and v26(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand))) then
				return "kill_command st 22";
			end
		end
		if ((v53.AMurderofCrows:IsCastable() and v29) or ((3645 - 2215) >= (5296 - (1466 + 218)))) then
			if (((1234 + 1449) >= (3608 - (556 + 592))) and v26(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows))) then
				return "a_murder_of_crows st 14";
			end
		end
		if (v53.SteelTrap:IsCastable() or ((642 + 1162) >= (4083 - (329 + 479)))) then
			if (v26(v53.SteelTrap) or ((2271 - (174 + 680)) > (12469 - 8840))) then
				return "steel_trap st 16";
			end
		end
		if (((9938 - 5143) > (288 + 114)) and v53.ExplosiveShot:IsReady()) then
			if (((5552 - (396 + 343)) > (316 + 3249)) and v26(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot))) then
				return "explosive_shot st 18";
			end
		end
		if (((5389 - (29 + 1448)) == (5301 - (135 + 1254))) and v53.BarbedShot:IsCastable()) then
			if (((10627 - 7806) <= (22523 - 17699)) and v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v78, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
				return "barbed_shot st 24";
			end
		end
		if (((1159 + 579) <= (3722 - (389 + 1138))) and v53.BarbedShot:IsCastable() and v78(v14)) then
			if (((615 - (102 + 472)) <= (2849 + 169)) and v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot))) then
				return "barbed_shot st mt_backup 25";
			end
		end
		if (((1190 + 955) <= (3827 + 277)) and v53.DireBeast:IsCastable()) then
			if (((4234 - (320 + 1225)) < (8625 - 3780)) and v26(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast))) then
				return "dire_beast st 26";
			end
		end
		if (v53.SerpentSting:IsReady() or ((1421 + 901) > (4086 - (157 + 1307)))) then
			if (v51.CastTargetIf(v53.SerpentSting, v62, "min", v71, v79, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover) or ((6393 - (821 + 1038)) == (5194 - 3112))) then
				return "serpent_sting st 28";
			end
		end
		if (v53.KillShot:IsReady() or ((172 + 1399) > (3316 - 1449))) then
			if (v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot)) or ((988 + 1666) >= (7425 - 4429))) then
				return "kill_shot st 30";
			end
		end
		if (((5004 - (834 + 192)) > (134 + 1970)) and v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (6 + 14))) then
			if (((65 + 2930) > (2386 - 845)) and v26(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot))) then
				return "kill_shot_mouseover st 31";
			end
		end
		if (((3553 - (300 + 4)) > (255 + 698)) and v53.AspectoftheWild:IsCastable() and v29) then
			if (v26(v53.AspectoftheWild) or ((8567 - 5294) > (4935 - (112 + 250)))) then
				return "aspect_of_the_wild st 32";
			end
		end
		if (v53.CobraShot:IsReady() or ((1257 + 1894) < (3216 - 1932))) then
			if (v26(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot)) or ((1060 + 790) == (791 + 738))) then
				return "cobra_shot st 34";
			end
		end
		if (((615 + 206) < (1053 + 1070)) and v53.WailingArrow:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53.WailingArrow:ExecuteTime()) or (v61 < (4 + 1)))) then
			if (((2316 - (1001 + 413)) < (5184 - 2859)) and v26(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow), true)) then
				return "wailing_arrow st 36";
			end
		end
		if (((1740 - (244 + 638)) <= (3655 - (627 + 66))) and v29) then
			if ((v53.BagofTricks:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (14 - 9)))) or ((4548 - (512 + 90)) < (3194 - (1665 + 241)))) then
				if (v26(v53.BagofTricks) or ((3959 - (373 + 344)) == (256 + 311))) then
					return "bag_of_tricks st 38";
				end
			end
			if ((v53.ArcanePulse:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (2 + 3)))) or ((2234 - 1387) >= (2136 - 873))) then
				if (v26(v53.ArcanePulse) or ((3352 - (35 + 1064)) == (1347 + 504))) then
					return "arcane_pulse st 40";
				end
			end
			if ((v53.ArcaneTorrent:IsCastable() and ((v13:Focus() + v13:FocusRegen() + (32 - 17)) < v13:FocusMax())) or ((9 + 2078) > (3608 - (298 + 938)))) then
				if (v26(v53.ArcaneTorrent) or ((5704 - (233 + 1026)) < (5815 - (636 + 1030)))) then
					return "arcane_torrent st 42";
				end
			end
		end
	end
	local function v85()
		if ((not v13:IsCasting() and not v13:IsChanneling()) or ((930 + 888) == (84 + 1))) then
			local v109 = v51.Interrupt(v53.CounterShot, 12 + 28, true);
			if (((43 + 587) < (2348 - (55 + 166))) and v109) then
				return v109;
			end
			v109 = v51.InterruptWithStun(v53.Intimidation, 8 + 32);
			if (v109 or ((195 + 1743) == (9601 - 7087))) then
				return v109;
			end
		end
	end
	local function v86()
		local v104 = 297 - (36 + 261);
		local v105;
		local v106;
		while true do
			if (((7440 - 3185) >= (1423 - (34 + 1334))) and (v104 == (1 + 0))) then
				if (((2331 + 668) > (2439 - (1035 + 248))) and v53.Stomp:IsAvailable()) then
					v10.SplashEnemies.ChangeFriendTargetsTracking("Mine Only");
				else
					v10.SplashEnemies.ChangeFriendTargetsTracking("All");
				end
				v105 = (v53.BloodBolt:IsPetKnown() and v20.FindBySpellID(v53.BloodBolt:ID()) and v53.BloodBolt) or (v53.Bite:IsPetKnown() and v20.FindBySpellID(v53.Bite:ID()) and v53.Bite) or (v53.Claw:IsPetKnown() and v20.FindBySpellID(v53.Claw:ID()) and v53.Claw) or (v53.Smack:IsPetKnown() and v20.FindBySpellID(v53.Smack:ID()) and v53.Smack) or nil;
				v106 = (v53.Growl:IsPetKnown() and v20.FindBySpellID(v53.Growl:ID()) and v53.Growl) or nil;
				if (((2371 - (20 + 1)) > (602 + 553)) and v23()) then
					v62 = v13:GetEnemiesInRange(359 - (134 + 185));
					v63 = (v105 and v13:GetEnemiesInSpellActionRange(v105)) or v14:GetEnemiesInSplashRange(1141 - (549 + 584));
					v64 = (v105 and #v63) or v14:GetEnemiesInSplashRangeCount(693 - (314 + 371));
				else
					v62 = {};
					v63 = v14 or {};
					v64 = 0 - 0;
				end
				v104 = 970 - (478 + 490);
			end
			if (((2135 + 1894) <= (6025 - (786 + 386))) and ((0 - 0) == v104)) then
				v50();
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v29 = EpicSettings.Toggles['cds'];
				v104 = 1380 - (1055 + 324);
			end
			if ((v104 == (1342 - (1093 + 247))) or ((459 + 57) > (362 + 3072))) then
				v65 = v14:IsInRange(158 - 118);
				v66 = v14:IsInRange(101 - 71);
				v67 = (v106 and v14:IsSpellInActionRange(v106)) or v14:IsInRange(85 - 55);
				v59 = v13:GCD() + (0.15 - 0);
				v104 = 2 + 1;
			end
			if (((15586 - 11540) >= (10453 - 7420)) and (v104 == (4 + 0))) then
				if (v51.TargetIsValid() or ((6953 - 4234) <= (2135 - (364 + 324)))) then
					local v122 = 0 - 0;
					local v123;
					local v124;
					while true do
						if ((v122 == (0 - 0)) or ((1371 + 2763) < (16427 - 12501))) then
							if ((not v13:AffectingCombat() and not v27) or ((262 - 98) >= (8458 - 5673))) then
								local v127 = 1268 - (1249 + 19);
								local v128;
								while true do
									if (((0 + 0) == v127) or ((2043 - 1518) == (3195 - (686 + 400)))) then
										v128 = v80();
										if (((26 + 7) == (262 - (73 + 156))) and v128) then
											return v128;
										end
										break;
									end
								end
							end
							v123 = v85();
							if (((15 + 3039) <= (4826 - (721 + 90))) and v123) then
								return v123;
							end
							v124 = v51.HandleDPSPotion();
							v122 = 1 + 0;
						end
						if (((6074 - 4203) < (3852 - (224 + 246))) and (v122 == (2 - 0))) then
							if (((2380 - 1087) <= (393 + 1773)) and ((v64 < (1 + 1)) or (not v53.BeastCleave:IsAvailable() and (v64 < (3 + 0))))) then
								local v129 = 0 - 0;
								local v130;
								while true do
									if ((v129 == (0 - 0)) or ((3092 - (203 + 310)) < (2116 - (1238 + 755)))) then
										v130 = v84();
										if (v130 or ((60 + 786) >= (3902 - (709 + 825)))) then
											return v130;
										end
										break;
									end
								end
							end
							if ((v64 > (3 - 1)) or (v53.BeastCleave:IsAvailable() and (v64 > (1 - 0))) or ((4876 - (196 + 668)) <= (13258 - 9900))) then
								local v131 = 0 - 0;
								local v132;
								while true do
									if (((2327 - (171 + 662)) <= (3098 - (4 + 89))) and (v131 == (0 - 0))) then
										v132 = v83();
										if (v132 or ((1133 + 1978) == (9372 - 7238))) then
											return v132;
										end
										break;
									end
								end
							end
							if (((924 + 1431) == (3841 - (35 + 1451))) and not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53.MendPet:IsCastable() and (v17:HealthPercentage() < v46) and v45) then
								if (v26(v53.MendPet) or ((2041 - (28 + 1425)) <= (2425 - (941 + 1052)))) then
									return "Mend Pet Low Priority (w/ Target)";
								end
							end
							break;
						end
						if (((4600 + 197) >= (5409 - (822 + 692))) and (v122 == (1 - 0))) then
							if (((1685 + 1892) == (3874 - (45 + 252))) and v124) then
								return v124;
							end
							if (((3754 + 40) > (1271 + 2422)) and v29) then
								local v133 = v81();
								if (v133 or ((3103 - 1828) == (4533 - (114 + 319)))) then
									return v133;
								end
							end
							v123 = v82();
							if (v123 or ((2284 - 693) >= (4587 - 1007))) then
								return v123;
							end
							v122 = 2 + 0;
						end
					end
				end
				if (((1464 - 481) <= (3788 - 1980)) and not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53.MendPet:IsCastable() and (v17:HealthPercentage() < v46) and v45) then
					if (v26(v53.MendPet) or ((4113 - (556 + 1407)) <= (2403 - (741 + 465)))) then
						return "Mend Pet Low Priority (w/o Target)";
					end
				end
				break;
			end
			if (((4234 - (170 + 295)) >= (619 + 554)) and (v104 == (3 + 0))) then
				if (((3655 - 2170) == (1232 + 253)) and (v51.TargetIsValid() or v13:AffectingCombat())) then
					local v125 = 0 + 0;
					while true do
						if ((v125 == (1 + 0)) or ((4545 - (957 + 273)) <= (745 + 2037))) then
							if ((v61 == (4448 + 6663)) or ((3337 - 2461) >= (7810 - 4846))) then
								v61 = v10.FightRemains(v62, false);
							end
							break;
						end
						if ((v125 == (0 - 0)) or ((11052 - 8820) > (4277 - (389 + 1391)))) then
							v60 = v10.BossFightRemains();
							v61 = v60;
							v125 = 1 + 0;
						end
					end
				end
				if ((v53.Exhilaration:IsCastable() and v53.Exhilaration:IsReady() and (v13:HealthPercentage() <= v48)) or ((220 + 1890) <= (755 - 423))) then
					if (((4637 - (783 + 168)) > (10645 - 7473)) and v26(v53.Exhilaration)) then
						return "Exhilaration";
					end
				end
				if (((v13:HealthPercentage() <= v37) and v36 and v55.Healthstone:IsReady() and v55.Healthstone:IsUsable()) or ((4401 + 73) < (1131 - (309 + 2)))) then
					if (((13140 - 8861) >= (4094 - (1090 + 122))) and v26(v57.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				if (not (v13:IsMounted() or v13:IsInVehicle()) or ((658 + 1371) >= (11825 - 8304))) then
					local v126 = 0 + 0;
					while true do
						if ((v126 == (1119 - (628 + 490))) or ((366 + 1671) >= (11492 - 6850))) then
							if (((7860 - 6140) < (5232 - (431 + 343))) and v53.MendPet:IsCastable() and v45 and (v17:HealthPercentage() < v46)) then
								if (v26(v53.MendPet) or ((880 - 444) > (8739 - 5718))) then
									return "Mend Pet High Priority";
								end
							end
							break;
						end
						if (((564 + 149) <= (109 + 738)) and (v126 == (1695 - (556 + 1139)))) then
							if (((2169 - (6 + 9)) <= (739 + 3292)) and v53.SummonPet:IsCastable() and v41) then
								if (((2365 + 2250) == (4784 - (28 + 141))) and v26(v54[v42])) then
									return "Summon Pet";
								end
							end
							if ((v53.RevivePet:IsCastable() and v44 and v17:IsDeadOrGhost()) or ((1468 + 2322) == (617 - 117))) then
								if (((64 + 25) < (1538 - (486 + 831))) and v26(v53.RevivePet)) then
									return "Revive Pet";
								end
							end
							v126 = 2 - 1;
						end
					end
				end
				v104 = 13 - 9;
			end
		end
	end
	local function v87()
		v10.Print("Beast Mastery by Epic. Supported by Gojira");
		local v107 = (v53.Growl:IsPetKnown() and v20.FindBySpellID(v53.Growl:ID()) and v53.Growl) or nil;
		if (((389 + 1665) >= (4493 - 3072)) and not v107) then
			v10.Print("|cffffff00Info|r: Add pet abilities to your action bars to improve range checks.");
		end
	end
	v10.SetAPL(1516 - (668 + 595), v86, v87);
end;
return v0["Epix_Hunter_BeastMastery.lua"]();

