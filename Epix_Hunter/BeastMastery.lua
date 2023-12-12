local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((9876 - 5292) == (2413 + 2171)) and not v5) then
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
		v33 = EpicSettings.Settings['HealingPotionName'] or (1907 - (957 + 950));
		v34 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v35 = EpicSettings.Settings['UseHealthstone'];
		v36 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v37 = EpicSettings.Settings['InterruptWithStun'] or (1205 - (902 + 303));
		v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
		v39 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v40 = EpicSettings.Settings['UsePet'];
		v41 = EpicSettings.Settings['SummonPetSlot'] or (0 + 0);
		v42 = EpicSettings.Settings['UseSteelTrap'];
		v43 = EpicSettings.Settings['UseRevive'];
		v44 = EpicSettings.Settings['UseMendPet'];
		v45 = EpicSettings.Settings['MendPetHP'] or (1690 - (1121 + 569));
		v46 = EpicSettings.Settings['UseExhilaration'];
		v47 = EpicSettings.Settings['ExhilarationHP'] or (214 - (22 + 192));
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
	local v59 = 11673 - (334 + 228);
	local v60 = 37477 - 26366;
	v9:RegisterForEvent(function()
		local v95 = 0 - 0;
		while true do
			if (((7215 - 3236) >= (474 + 1194)) and (v95 == (236 - (141 + 95)))) then
				v59 = 10915 + 196;
				v60 = 28599 - 17488;
				break;
			end
		end
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
		return (v99:DebuffStack(v52.LatentPoisonDebuff) > (5 + 4)) and ((v16:BuffUp(v52.FrenzyPetBuff) and (v16:BuffRemains(v52.FrenzyPetBuff) <= (v58 + (0.25 - 0)))) or (v52.ScentofBlood:IsAvailable() and (v52.BestialWrath:CooldownRemains() < (8 + 4 + v58))) or ((v16:BuffStack(v52.FrenzyPetBuff) < (166 - (92 + 71))) and (v52.BestialWrath:CooldownUp() or v52.CalloftheWild:CooldownUp())) or ((v52.BarbedShot:FullRechargeTime() < v58) and v52.BestialWrath:CooldownDown()));
	end
	local function v72(v100)
		return (v16:BuffUp(v52.FrenzyPetBuff) and (v16:BuffRemains(v52.FrenzyPetBuff) <= (v58 + 0.25 + 0))) or (v52.ScentofBlood:IsAvailable() and (v52.BestialWrath:CooldownRemains() < ((19 - 7) + v58))) or ((v16:BuffStack(v52.FrenzyPetBuff) < (768 - (574 + 191))) and (v52.BestialWrath:CooldownUp() or v52.CalloftheWild:CooldownUp())) or ((v52.BarbedShot:FullRechargeTime() < v58) and v52.BestialWrath:CooldownDown());
	end
	local function v73(v101)
		return (v101:DebuffStack(v52.LatentPoisonDebuff) > (8 + 1)) and (v12:BuffUp(v52.CalloftheWildBuff) or (v60 < (22 - 13)) or (v52.WildCall:IsAvailable() and (v52.BarbedShot:ChargesFractional() > (1.2 + 0))) or v52.Savagery:IsAvailable());
	end
	local function v74(v102)
		return v12:BuffUp(v52.CalloftheWildBuff) or (v60 < (858 - (254 + 595))) or (v52.WildCall:IsAvailable() and (v52.BarbedShot:ChargesFractional() > (127.2 - (55 + 71)))) or v52.Savagery:IsAvailable();
	end
	local function v75(v103)
		return v103:DebuffRefreshable(v52.SerpentStingDebuff) and (v103:TimeToDie() > v52.SerpentStingDebuff:BaseDuration());
	end
	local function v76(v104)
		return (v16:BuffUp(v52.FrenzyPetBuff) and (v16:BuffRemains(v52.FrenzyPetBuff) <= (v58 + (0.25 - 0)))) or (v52.ScentofBlood:IsAvailable() and (v16:BuffStack(v52.FrenzyPetBuff) < (1793 - (573 + 1217))) and (v52.BestialWrath:CooldownUp() or v52.CalloftheWild:CooldownUp()));
	end
	local function v77(v105)
		return (v52.WildCall:IsAvailable() and (v52.BarbedShot:ChargesFractional() > (2.4 - 1))) or v12:BuffUp(v52.CalloftheWildBuff) or ((v52.BarbedShot:FullRechargeTime() < v58) and v52.BestialWrath:CooldownDown()) or (v52.ScentofBlood:IsAvailable() and (v52.BestialWrath:CooldownRemains() < (1 + 11 + v58))) or v52.Savagery:IsAvailable() or (v60 < (13 - 4));
	end
	local function v78(v106)
		return v106:DebuffRefreshable(v52.SerpentStingDebuff) and (v13:TimeToDie() > v52.SerpentStingDebuff:BaseDuration());
	end
	local function v79()
		local v107 = 939 - (714 + 225);
		while true do
			if (((1659 - 1091) > (596 - 168)) and (v107 == (1 + 1))) then
				if (((1931 - 597) <= (5419 - (118 + 688))) and v15:Exists() and v52.KillShot:IsCastable() and (v15:HealthPercentage() <= (68 - (25 + 23)))) then
					if (v25(v56.KillShotMouseover, not v15:IsSpellInRange(v52.KillShot)) or ((362 + 1503) >= (3915 - (927 + 959)))) then
						return "kill_shot_mouseover precombat 11";
					end
				end
				if (((16685 - 11735) >= (2348 - (16 + 716))) and v52.KillCommand:IsReady()) then
					if (((3329 - 1604) == (1822 - (11 + 86))) and v25(v56.KillCommandPetAttack)) then
						return "kill_command precombat 12";
					end
				end
				v107 = 6 - 3;
			end
			if (((1744 - (175 + 110)) <= (6266 - 3784)) and (v107 == (4 - 3))) then
				if ((v52.BarbedShot:IsCastable() and (v52.BarbedShot:Charges() >= (1798 - (503 + 1293)))) or ((7529 - 4833) >= (3278 + 1254))) then
					if (((2109 - (810 + 251)) >= (37 + 15)) and v25(v56.BarbedShotPetAttack, not v13:IsSpellInRange(v52.BarbedShot))) then
						return "barbed_shot precombat 8";
					end
				end
				if (((908 + 2050) < (4060 + 443)) and v52.KillShot:IsReady()) then
					if (v25(v52.KillShot, not v13:IsSpellInRange(v52.KillShot)) or ((3268 - (43 + 490)) == (2042 - (711 + 22)))) then
						return "kill_shot precombat 10";
					end
				end
				v107 = 7 - 5;
			end
			if ((v107 == (862 - (240 + 619))) or ((997 + 3133) <= (4700 - 1745))) then
				if ((v63 > (1 + 0)) or ((3708 - (1344 + 400)) <= (1745 - (255 + 150)))) then
					if (((1969 + 530) == (1338 + 1161)) and v52.MultiShot:IsReady()) then
						if (v25(v52.MultiShot, not v13:IsSpellInRange(v52.MultiShot)) or ((9634 - 7379) < (70 - 48))) then
							return "multishot precombat 14";
						end
					end
				elseif (v52.CobraShot:IsReady() or ((2825 - (404 + 1335)) >= (1811 - (183 + 223)))) then
					if (v25(v56.CobraShotPetAttack, not v13:IsSpellInRange(v52.CobraShot)) or ((2881 - 512) == (283 + 143))) then
						return "cobra_shot precombat 16";
					end
				end
				break;
			end
			if ((v107 == (0 + 0)) or ((3413 - (10 + 327)) > (2217 + 966))) then
				if (((1540 - (118 + 220)) > (353 + 705)) and v14:Exists() and v52.Misdirection:IsReady()) then
					if (((4160 - (108 + 341)) > (1507 + 1848)) and v25(v56.MisdirectionFocus)) then
						return "misdirection precombat 0";
					end
				end
				if ((v52.SteelTrap:IsCastable() and not v52.WailingArrow:IsAvailable() and v52.SteelTrap:IsAvailable()) or ((3830 - 2924) >= (3722 - (711 + 782)))) then
					if (((2469 - 1181) > (1720 - (270 + 199))) and v25(v52.SteelTrap)) then
						return "steel_trap precombat 2";
					end
				end
				v107 = 1 + 0;
			end
		end
	end
	local function v80()
		local v108 = 1819 - (580 + 1239);
		while true do
			if ((v108 == (2 - 1)) or ((4316 + 197) < (121 + 3231))) then
				if ((v52.AncestralCall:IsCastable() and (v12:BuffUp(v52.CalloftheWildBuff) or (not v52.CalloftheWild:IsAvailable() and v12:BuffUp(v52.BestialWrathBuff)) or (v60 < (7 + 9)))) or ((5391 - 3326) >= (1986 + 1210))) then
					if (v25(v52.AncestralCall) or ((5543 - (645 + 522)) <= (3271 - (1010 + 780)))) then
						return "ancestral_call cds 10";
					end
				end
				if ((v52.Fireblood:IsCastable() and (v12:BuffUp(v52.CalloftheWildBuff) or (not v52.CalloftheWild:IsAvailable() and v12:BuffUp(v52.BestialWrathBuff)) or (v60 < (9 + 0)))) or ((16159 - 12767) >= (13893 - 9152))) then
					if (((5161 - (1045 + 791)) >= (5451 - 3297)) and v25(v52.Fireblood)) then
						return "fireblood cds 12";
					end
				end
				break;
			end
			if ((v108 == (0 - 0)) or ((1800 - (351 + 154)) >= (4807 - (1281 + 293)))) then
				if (((4643 - (28 + 238)) > (3668 - 2026)) and v52.Berserking:IsCastable() and (v12:BuffUp(v52.CalloftheWildBuff) or (not v52.CalloftheWild:IsAvailable() and v12:BuffUp(v52.BestialWrathBuff)) or (v60 < (1572 - (1381 + 178))))) then
					if (((4430 + 293) > (1094 + 262)) and v25(v52.Berserking)) then
						return "berserking cds 2";
					end
				end
				if ((v52.BloodFury:IsCastable() and (v12:BuffUp(v52.CalloftheWildBuff) or (not v52.CalloftheWild:IsAvailable() and v12:BuffUp(v52.BestialWrathBuff)) or (v60 < (7 + 9)))) or ((14258 - 10122) <= (1779 + 1654))) then
					if (((4715 - (381 + 89)) <= (4107 + 524)) and v25(v52.BloodFury)) then
						return "blood_fury cds 8";
					end
				end
				v108 = 1 + 0;
			end
		end
	end
	local function v81()
		local v109 = 0 - 0;
		local v110;
		while true do
			if (((5432 - (1074 + 82)) >= (8577 - 4663)) and ((1785 - (214 + 1570)) == v109)) then
				v110 = v50.HandleBottomTrinket(v55, v28, 1495 - (990 + 465), nil);
				if (((82 + 116) <= (1900 + 2465)) and v110) then
					return v110;
				end
				break;
			end
			if (((4651 + 131) > (18402 - 13726)) and (v109 == (1726 - (1668 + 58)))) then
				v110 = v50.HandleTopTrinket(v55, v28, 666 - (512 + 114), nil);
				if (((12681 - 7817) > (4541 - 2344)) and v110) then
					return v110;
				end
				v109 = 3 - 2;
			end
		end
	end
	local function v82()
		if (v52.BarbedShot:IsCastable() or ((1722 + 1978) == (470 + 2037))) then
			if (((3890 + 584) >= (924 - 650)) and v50.CastTargetIf(v52.BarbedShot, v61, "max", v69, v71, not v13:IsSpellInRange(v52.BarbedShot))) then
				return "barbed_shot cleave 2";
			end
		end
		if (v52.BarbedShot:IsCastable() or ((3888 - (109 + 1885)) <= (2875 - (1269 + 200)))) then
			if (((3012 - 1440) >= (2346 - (98 + 717))) and v50.CastTargetIf(v52.BarbedShot, v61, "min", v68, v72, not v13:IsSpellInRange(v52.BarbedShot))) then
				return "barbed_shot cleave 4";
			end
		end
		if ((v52.MultiShot:IsReady() and (v16:BuffRemains(v52.BeastCleavePetBuff) < ((826.25 - (802 + 24)) + v58)) and (not v52.BloodyFrenzy:IsAvailable() or v52.CalloftheWild:CooldownDown())) or ((8082 - 3395) < (5735 - 1193))) then
			if (((487 + 2804) > (1281 + 386)) and v25(v52.MultiShot, nil, nil, not v13:IsSpellInRange(v52.MultiShot))) then
				return "multishot cleave 6";
			end
		end
		if ((v52.BestialWrath:IsCastable() and v28) or ((144 + 729) == (439 + 1595))) then
			if (v25(v52.BestialWrath) or ((7833 - 5017) < (36 - 25))) then
				return "bestial_wrath cleave 8";
			end
		end
		if (((1324 + 2375) < (1916 + 2790)) and v52.CalloftheWild:IsCastable() and v28) then
			if (((2183 + 463) >= (637 + 239)) and v24(v52.CalloftheWild)) then
				return "call_of_the_wild cleave 10";
			end
		end
		if (((287 + 327) <= (4617 - (797 + 636))) and v52.KillCommand:IsReady() and (v52.KillCleave:IsAvailable())) then
			if (((15177 - 12051) == (4745 - (1427 + 192))) and v24(v52.KillCommand, nil, nil, not v13:IsInRange(18 + 32))) then
				return "kill_command cleave 12";
			end
		end
		if (v52.ExplosiveShot:IsReady() or ((5077 - 2890) >= (4453 + 501))) then
			if (v25(v52.ExplosiveShot, not v13:IsSpellInRange(v52.ExplosiveShot)) or ((1757 + 2120) == (3901 - (192 + 134)))) then
				return "explosive_shot cleave 12";
			end
		end
		if (((1983 - (316 + 960)) > (352 + 280)) and v52.Stampede:IsCastable() and v28) then
			if (v25(v52.Stampede, not v13:IsSpellInRange(v52.Stampede)) or ((422 + 124) >= (2481 + 203))) then
				return "stampede cleave 14";
			end
		end
		if (((5600 - 4135) <= (4852 - (83 + 468))) and v52.Bloodshed:IsCastable()) then
			if (((3510 - (1202 + 604)) > (6652 - 5227)) and v25(v52.Bloodshed, not v13:IsSpellInRange(v52.Bloodshed))) then
				return "bloodshed cleave 16";
			end
		end
		if ((v52.DeathChakram:IsCastable() and v28) or ((1143 - 456) == (11722 - 7488))) then
			if (v25(v52.DeathChakram, not v13:IsSpellInRange(v52.DeathChakram)) or ((3655 - (45 + 280)) < (1380 + 49))) then
				return "death_chakram cleave 18";
			end
		end
		if (((1003 + 144) >= (123 + 212)) and v52.SteelTrap:IsCastable()) then
			if (((1901 + 1534) > (369 + 1728)) and v25(v56.SteelTrap)) then
				return "steel_trap cleave 22";
			end
		end
		if ((v52.AMurderofCrows:IsReady() and v28) or ((6981 - 3211) >= (5952 - (340 + 1571)))) then
			if (v25(v52.AMurderofCrows, not v13:IsSpellInRange(v52.AMurderofCrows)) or ((1496 + 2295) <= (3383 - (1733 + 39)))) then
				return "a_murder_of_crows cleave 24";
			end
		end
		if (v52.BarbedShot:IsCastable() or ((12579 - 8001) <= (3042 - (125 + 909)))) then
			if (((3073 - (1096 + 852)) <= (932 + 1144)) and v50.CastTargetIf(v56.BarbedShotPetAttack, v61, "max", v69, v73, not v13:IsSpellInRange(v52.BarbedShot), nil, nil, v56.BarbedShotMouseover)) then
				return "barbed_shot cleave 26";
			end
		end
		if (v52.BarbedShot:IsCastable() or ((1060 - 317) >= (4267 + 132))) then
			if (((1667 - (409 + 103)) < (1909 - (46 + 190))) and v50.CastTargetIf(v56.BarbedShotPetAttack, v61, "min", v68, v74, not v13:IsSpellInRange(v52.BarbedShot), nil, nil, v56.BarbedShotMouseover)) then
				return "barbed_shot cleave 28";
			end
		end
		if (v52.KillCommand:IsReady() or ((2419 - (51 + 44)) <= (164 + 414))) then
			if (((5084 - (1114 + 203)) == (4493 - (228 + 498))) and v25(v56.KillCommandPetAttack, not v13:IsSpellInRange(v52.KillCommand))) then
				return "kill_command cleave 30";
			end
		end
		if (((886 + 3203) == (2260 + 1829)) and v52.DireBeast:IsCastable()) then
			if (((5121 - (174 + 489)) >= (4361 - 2687)) and v25(v52.DireBeast, not v13:IsSpellInRange(v52.DireBeast))) then
				return "dire_beast cleave 32";
			end
		end
		if (((2877 - (830 + 1075)) <= (1942 - (303 + 221))) and v52.SerpentSting:IsReady()) then
			if (v50.CastTargetIf(v52.SerpentSting, v61, "min", v70, v75, not v13:IsSpellInRange(v52.SerpentSting), nil, nil, v56.SerpentStingMouseover) or ((6207 - (231 + 1038)) < (3969 + 793))) then
				return "serpent_sting cleave 34";
			end
		end
		if ((v52.Barrage:IsReady() and (v16:BuffRemains(v52.FrenzyPetBuff) > v52.Barrage:ExecuteTime())) or ((3666 - (171 + 991)) > (17572 - 13308))) then
			if (((5780 - 3627) == (5372 - 3219)) and v25(v52.Barrage, not v13:IsSpellInRange(v52.Barrage))) then
				return "barrage cleave 36";
			end
		end
		if ((v52.MultiShot:IsReady() and (v16:BuffRemains(v52.BeastCleavePetBuff) < (v12:GCD() * (2 + 0)))) or ((1777 - 1270) >= (7474 - 4883))) then
			if (((7222 - 2741) == (13851 - 9370)) and v25(v52.MultiShot, not v13:IsSpellInRange(v52.MultiShot))) then
				return "multishot cleave 38";
			end
		end
		if ((v52.AspectoftheWild:IsCastable() and v28) or ((3576 - (111 + 1137)) < (851 - (91 + 67)))) then
			if (((12881 - 8553) == (1080 + 3248)) and v25(v52.AspectoftheWild)) then
				return "aspect_of_the_wild cleave 40";
			end
		end
		if (((2111 - (423 + 100)) >= (10 + 1322)) and v28 and v52.LightsJudgment:IsCastable() and (v12:BuffDown(v52.BestialWrathBuff) or (v13:TimeToDie() < (13 - 8)))) then
			if (v24(v52.LightsJudgment, nil, not v13:IsInRange(3 + 2)) or ((4945 - (326 + 445)) > (18538 - 14290))) then
				return "lights_judgment cleave 40";
			end
		end
		if (v52.KillShot:IsReady() or ((10216 - 5630) <= (190 - 108))) then
			if (((4574 - (530 + 181)) == (4744 - (614 + 267))) and v25(v52.KillShot, not v13:IsSpellInRange(v52.KillShot))) then
				return "kill_shot cleave 38";
			end
		end
		if ((v15:Exists() and v52.KillShot:IsCastable() and (v15:HealthPercentage() <= (52 - (19 + 13)))) or ((458 - 176) <= (97 - 55))) then
			if (((13166 - 8557) >= (199 + 567)) and v25(v56.KillShotMouseover, not v15:IsSpellInRange(v52.KillShot))) then
				return "kill_shot_mouseover cleave 39";
			end
		end
		if ((v52.CobraShot:IsReady() and (v12:FocusTimeToMax() < (v58 * (3 - 1)))) or ((2388 - 1236) == (4300 - (1293 + 519)))) then
			if (((6981 - 3559) > (8746 - 5396)) and v25(v56.CobraShotPetAttack, not v13:IsSpellInRange(v52.CobraShot))) then
				return "cobra_shot cleave 42";
			end
		end
		if (((1676 - 799) > (1621 - 1245)) and v52.WailingArrow:IsReady() and ((v16:BuffRemains(v52.FrenzyPetBuff) > v52.WailingArrow:ExecuteTime()) or (v60 < (11 - 6)))) then
			if (v25(v52.WailingArrow, not v13:IsSpellInRange(v52.WailingArrow)) or ((1652 + 1466) <= (378 + 1473))) then
				return "wailing_arrow cleave 44";
			end
		end
		if ((v52.BagofTricks:IsCastable() and v28 and (v12:BuffDown(v52.BestialWrathBuff) or (v60 < (11 - 6)))) or ((39 + 126) >= (1161 + 2331))) then
			if (((2468 + 1481) < (5952 - (709 + 387))) and v25(v52.BagofTricks)) then
				return "bag_of_tricks cleave 46";
			end
		end
		if ((v52.ArcaneTorrent:IsCastable() and v28 and ((v12:Focus() + v12:FocusRegen() + (1888 - (673 + 1185))) < v12:FocusMax())) or ((12400 - 8124) < (9684 - 6668))) then
			if (((7716 - 3026) > (2951 + 1174)) and v25(v52.ArcaneTorrent)) then
				return "arcane_torrent cleave 48";
			end
		end
	end
	local function v83()
		if (v52.BarbedShot:IsCastable() or ((38 + 12) >= (1208 - 312))) then
			if (v50.CastTargetIf(v56.BarbedShotPetAttack, v61, "min", v68, v76, not v13:IsSpellInRange(v52.BarbedShot), nil, nil, v56.BarbedShotMouseover) or ((421 + 1293) >= (5897 - 2939))) then
				return "barbed_shot st 2";
			end
		end
		if ((v52.BarbedShot:IsCastable() and v76(v13)) or ((2926 - 1435) < (2524 - (446 + 1434)))) then
			if (((1987 - (1040 + 243)) < (2945 - 1958)) and v25(v56.BarbedShotPetAttack, not v13:IsSpellInRange(v52.BarbedShot))) then
				return "barbed_shot st mt_backup 3";
			end
		end
		if (((5565 - (559 + 1288)) > (3837 - (609 + 1322))) and v52.CalloftheWild:IsCastable() and v28) then
			if (v25(v52.CalloftheWild) or ((1412 - (13 + 441)) > (13583 - 9948))) then
				return "call_of_the_wild st 6";
			end
		end
		if (((9170 - 5669) <= (22372 - 17880)) and v52.KillCommand:IsReady() and (v52.KillCommand:FullRechargeTime() < v58) and v52.AlphaPredator:IsAvailable()) then
			if (v25(v56.KillCommandPetAttack, not v13:IsSpellInRange(v52.KillCommand)) or ((129 + 3313) < (9253 - 6705))) then
				return "kill_command st 4";
			end
		end
		if (((1022 + 1853) >= (642 + 822)) and v52.Stampede:IsCastable() and v28) then
			if (v24(v52.Stampede, nil, nil, not v13:IsSpellInRange(v52.Stampede)) or ((14235 - 9438) >= (2678 + 2215))) then
				return "stampede st 8";
			end
		end
		if (v52.Bloodshed:IsCastable() or ((1013 - 462) > (1368 + 700))) then
			if (((1176 + 938) > (679 + 265)) and v25(v52.Bloodshed, not v13:IsSpellInRange(v52.Bloodshed))) then
				return "bloodshed st 10";
			end
		end
		if ((v52.BestialWrath:IsCastable() and v28) or ((1900 + 362) >= (3030 + 66))) then
			if (v25(v52.BestialWrath) or ((2688 - (153 + 280)) >= (10213 - 6676))) then
				return "bestial_wrath st 12";
			end
		end
		if ((v52.DeathChakram:IsCastable() and v28) or ((3445 + 392) < (516 + 790))) then
			if (((1544 + 1406) == (2678 + 272)) and v24(v52.DeathChakram, nil, nil, not v13:IsSpellInRange(v52.DeathChakram))) then
				return "death_chakram st 14";
			end
		end
		if (v52.KillCommand:IsReady() or ((3423 + 1300) < (5021 - 1723))) then
			if (((703 + 433) >= (821 - (89 + 578))) and v25(v56.KillCommandPetAttack, not v13:IsSpellInRange(v52.KillCommand))) then
				return "kill_command st 22";
			end
		end
		if ((v52.AMurderofCrows:IsCastable() and v28) or ((194 + 77) > (9870 - 5122))) then
			if (((5789 - (572 + 477)) >= (426 + 2726)) and v25(v52.AMurderofCrows, not v13:IsSpellInRange(v52.AMurderofCrows))) then
				return "a_murder_of_crows st 14";
			end
		end
		if (v52.SteelTrap:IsCastable() or ((1548 + 1030) >= (405 + 2985))) then
			if (((127 - (84 + 2)) <= (2737 - 1076)) and v25(v52.SteelTrap)) then
				return "steel_trap st 16";
			end
		end
		if (((433 + 168) < (4402 - (497 + 345))) and v52.ExplosiveShot:IsReady()) then
			if (((7 + 228) < (117 + 570)) and v25(v52.ExplosiveShot, not v13:IsSpellInRange(v52.ExplosiveShot))) then
				return "explosive_shot st 18";
			end
		end
		if (((5882 - (605 + 728)) > (823 + 330)) and v52.BarbedShot:IsCastable()) then
			if (v50.CastTargetIf(v56.BarbedShotPetAttack, v61, "min", v68, v77, not v13:IsSpellInRange(v52.BarbedShot), nil, nil, v56.BarbedShotMouseover) or ((10391 - 5717) < (215 + 4457))) then
				return "barbed_shot st 24";
			end
		end
		if (((13561 - 9893) < (4112 + 449)) and v52.BarbedShot:IsCastable() and v77(v13)) then
			if (v25(v56.BarbedShotPetAttack, not v13:IsSpellInRange(v52.BarbedShot)) or ((1260 - 805) == (2722 + 883))) then
				return "barbed_shot st mt_backup 25";
			end
		end
		if (v52.DireBeast:IsCastable() or ((3152 - (457 + 32)) == (1406 + 1906))) then
			if (((5679 - (832 + 570)) <= (4216 + 259)) and v25(v52.DireBeast, not v13:IsSpellInRange(v52.DireBeast))) then
				return "dire_beast st 26";
			end
		end
		if (v52.SerpentSting:IsReady() or ((227 + 643) == (4207 - 3018))) then
			if (((749 + 804) <= (3929 - (588 + 208))) and v50.CastTargetIf(v52.SerpentSting, v61, "min", v70, v78, not v13:IsSpellInRange(v52.SerpentSting), nil, nil, v56.SerpentStingMouseover)) then
				return "serpent_sting st 28";
			end
		end
		if (v52.KillShot:IsReady() or ((6029 - 3792) >= (5311 - (884 + 916)))) then
			if (v25(v52.KillShot, not v13:IsSpellInRange(v52.KillShot)) or ((2771 - 1447) > (1752 + 1268))) then
				return "kill_shot st 30";
			end
		end
		if ((v15:Exists() and v52.KillShot:IsCastable() and (v15:HealthPercentage() <= (673 - (232 + 421)))) or ((4881 - (1569 + 320)) == (462 + 1419))) then
			if (((591 + 2515) > (5142 - 3616)) and v25(v56.KillShotMouseover, not v15:IsSpellInRange(v52.KillShot))) then
				return "kill_shot_mouseover st 31";
			end
		end
		if (((3628 - (316 + 289)) < (10130 - 6260)) and v52.AspectoftheWild:IsCastable() and v28) then
			if (((7 + 136) > (1527 - (666 + 787))) and v25(v52.AspectoftheWild)) then
				return "aspect_of_the_wild st 32";
			end
		end
		if (((443 - (360 + 65)) < (1974 + 138)) and v52.CobraShot:IsReady()) then
			if (((1351 - (79 + 175)) <= (2566 - 938)) and v25(v56.CobraShotPetAttack, not v13:IsSpellInRange(v52.CobraShot))) then
				return "cobra_shot st 34";
			end
		end
		if (((3613 + 1017) == (14192 - 9562)) and v52.WailingArrow:IsReady() and ((v16:BuffRemains(v52.FrenzyPetBuff) > v52.WailingArrow:ExecuteTime()) or (v60 < (9 - 4)))) then
			if (((4439 - (503 + 396)) > (2864 - (92 + 89))) and v25(v52.WailingArrow, not v13:IsSpellInRange(v52.WailingArrow), true)) then
				return "wailing_arrow st 36";
			end
		end
		if (((9299 - 4505) >= (1680 + 1595)) and v28) then
			local v118 = 0 + 0;
			while true do
				if (((5811 - 4327) == (203 + 1281)) and (v118 == (2 - 1))) then
					if (((1250 + 182) < (1698 + 1857)) and v52.ArcaneTorrent:IsCastable() and ((v12:Focus() + v12:FocusRegen() + (45 - 30)) < v12:FocusMax())) then
						if (v25(v52.ArcaneTorrent) or ((133 + 932) > (5456 - 1878))) then
							return "arcane_torrent st 42";
						end
					end
					break;
				end
				if ((v118 == (1244 - (485 + 759))) or ((11095 - 6300) < (2596 - (442 + 747)))) then
					if (((2988 - (832 + 303)) < (5759 - (88 + 858))) and v52.BagofTricks:IsCastable() and (v12:BuffDown(v52.BestialWrathBuff) or (v60 < (2 + 3)))) then
						if (v25(v52.BagofTricks) or ((2335 + 486) < (101 + 2330))) then
							return "bag_of_tricks st 38";
						end
					end
					if ((v52.ArcanePulse:IsCastable() and (v12:BuffDown(v52.BestialWrathBuff) or (v60 < (794 - (766 + 23))))) or ((14188 - 11314) < (2982 - 801))) then
						if (v25(v52.ArcanePulse) or ((7084 - 4395) <= (1164 - 821))) then
							return "arcane_pulse st 40";
						end
					end
					v118 = 1074 - (1036 + 37);
				end
			end
		end
	end
	local function v84()
		v49();
		v26 = EpicSettings.Toggles['ooc'];
		v27 = EpicSettings.Toggles['aoe'];
		v28 = EpicSettings.Toggles['cds'];
		if (v52.Stomp:IsAvailable() or ((1326 + 543) == (3911 - 1902))) then
			v9.SplashEnemies.ChangeFriendTargetsTracking("Mine Only");
		else
			v9.SplashEnemies.ChangeFriendTargetsTracking("All");
		end
		local v114 = (v52.BloodBolt:IsPetKnown() and v19.FindBySpellID(v52.BloodBolt:ID()) and v52.BloodBolt) or (v52.Bite:IsPetKnown() and v19.FindBySpellID(v52.Bite:ID()) and v52.Bite) or (v52.Claw:IsPetKnown() and v19.FindBySpellID(v52.Claw:ID()) and v52.Claw) or (v52.Smack:IsPetKnown() and v19.FindBySpellID(v52.Smack:ID()) and v52.Smack) or nil;
		local v115 = (v52.Growl:IsPetKnown() and v19.FindBySpellID(v52.Growl:ID()) and v52.Growl) or nil;
		if (v22() or ((2790 + 756) < (3802 - (641 + 839)))) then
			v61 = v12:GetEnemiesInRange(953 - (910 + 3));
			v62 = (v114 and v12:GetEnemiesInSpellActionRange(v114)) or v13:GetEnemiesInSplashRange(20 - 12);
			v63 = (v114 and #v62) or v13:GetEnemiesInSplashRangeCount(1692 - (1466 + 218));
		else
			v61 = {};
			v62 = v13 or {};
			v63 = 0 + 0;
		end
		v64 = v13:IsInRange(1188 - (556 + 592));
		v65 = v13:IsInRange(11 + 19);
		v66 = (v115 and v13:IsSpellInActionRange(v115)) or v13:IsInRange(838 - (329 + 479));
		v58 = v12:GCD() + (854.15 - (174 + 680));
		if (v50.TargetIsValid() or v12:AffectingCombat() or ((7153 - 5071) == (9892 - 5119))) then
			local v119 = 0 + 0;
			while true do
				if (((3983 - (396 + 343)) > (94 + 961)) and (v119 == (1478 - (29 + 1448)))) then
					if ((v60 == (12500 - (135 + 1254))) or ((12480 - 9167) <= (8301 - 6523))) then
						v60 = v9.FightRemains(v61, false);
					end
					break;
				end
				if (((0 + 0) == v119) or ((2948 - (389 + 1138)) >= (2678 - (102 + 472)))) then
					v59 = v9.BossFightRemains();
					v60 = v59;
					v119 = 1 + 0;
				end
			end
		end
		if (((1005 + 807) <= (3030 + 219)) and v52.Exhilaration:IsCastable() and v52.Exhilaration:IsReady() and (v12:HealthPercentage() <= v47)) then
			if (((3168 - (320 + 1225)) <= (3483 - 1526)) and v25(v52.Exhilaration)) then
				return "Exhilaration";
			end
		end
		if (((2700 + 1712) == (5876 - (157 + 1307))) and (v12:HealthPercentage() <= v36) and v35 and v54.Healthstone:IsReady() and v54.Healthstone:IsUsable()) then
			if (((3609 - (821 + 1038)) >= (2100 - 1258)) and v25(v56.Healthstone, nil, nil, true)) then
				return "healthstone defensive 3";
			end
		end
		if (((479 + 3893) > (3286 - 1436)) and not (v12:IsMounted() or v12:IsInVehicle())) then
			if (((87 + 145) < (2034 - 1213)) and v52.SummonPet:IsCastable() and v40) then
				if (((1544 - (834 + 192)) < (58 + 844)) and v25(v53[v41])) then
					return "Summon Pet";
				end
			end
			if (((769 + 2225) > (19 + 839)) and v52.RevivePet:IsCastable() and v43 and v16:IsDeadOrGhost()) then
				if (v25(v52.RevivePet) or ((5817 - 2062) <= (1219 - (300 + 4)))) then
					return "Revive Pet";
				end
			end
			if (((1054 + 2892) > (9798 - 6055)) and v52.MendPet:IsCastable() and v44 and (v16:HealthPercentage() < v45)) then
				if (v25(v52.MendPet) or ((1697 - (112 + 250)) >= (1318 + 1988))) then
					return "Mend Pet High Priority";
				end
			end
		end
		if (((12134 - 7290) > (1291 + 962)) and v50.TargetIsValid()) then
			if (((234 + 218) == (339 + 113)) and not v12:AffectingCombat() and not v26) then
				local v121 = 0 + 0;
				local v122;
				while true do
					if ((v121 == (0 + 0)) or ((5971 - (1001 + 413)) < (4653 - 2566))) then
						v122 = v79();
						if (((4756 - (244 + 638)) == (4567 - (627 + 66))) and v122) then
							return v122;
						end
						break;
					end
				end
			end
			local v120 = v50.Interrupt(119 - 79, v52.CounterShot, v67);
			if (v120 or ((2540 - (512 + 90)) > (6841 - (1665 + 241)))) then
				return v120;
			end
			if (v28 or ((4972 - (373 + 344)) < (1544 + 1879))) then
				local v123 = v80();
				if (((385 + 1069) <= (6570 - 4079)) and v123) then
					return v123;
				end
			end
			if ((v31 and v28) or ((7034 - 2877) <= (3902 - (35 + 1064)))) then
				local v124 = v81();
				if (((3532 + 1321) >= (6379 - 3397)) and v124) then
					return v124;
				end
			end
			if (((17 + 4117) > (4593 - (298 + 938))) and ((v63 < (1261 - (233 + 1026))) or (not v52.BeastCleave:IsAvailable() and (v63 < (1669 - (636 + 1030)))))) then
				local v125 = 0 + 0;
				local v126;
				while true do
					if (((0 + 0) == v125) or ((1016 + 2401) < (172 + 2362))) then
						v126 = v83();
						if (v126 or ((2943 - (55 + 166)) <= (32 + 132))) then
							return v126;
						end
						break;
					end
				end
			end
			if ((v63 > (1 + 1)) or (v52.BeastCleave:IsAvailable() and (v63 > (3 - 2))) or ((2705 - (36 + 261)) < (3687 - 1578))) then
				local v127 = 1368 - (34 + 1334);
				local v128;
				while true do
					if (((0 + 0) == v127) or ((26 + 7) == (2738 - (1035 + 248)))) then
						v128 = v82();
						if (v128 or ((464 - (20 + 1)) >= (2092 + 1923))) then
							return v128;
						end
						break;
					end
				end
			end
			if (((3701 - (134 + 185)) > (1299 - (549 + 584))) and not (v12:IsMounted() or v12:IsInVehicle()) and not v16:IsDeadOrGhost() and v52.MendPet:IsCastable() and (v16:HealthPercentage() < v45) and v44) then
				if (v25(v52.MendPet) or ((965 - (314 + 371)) == (10501 - 7442))) then
					return "Mend Pet Low Priority (w/ Target)";
				end
			end
		end
		if (((2849 - (478 + 490)) > (685 + 608)) and not (v12:IsMounted() or v12:IsInVehicle()) and not v16:IsDeadOrGhost() and v52.MendPet:IsCastable() and (v16:HealthPercentage() < v45) and v44) then
			if (((3529 - (786 + 386)) == (7634 - 5277)) and v25(v52.MendPet)) then
				return "Mend Pet Low Priority (w/o Target)";
			end
		end
	end
	local function v85()
		local v116 = 1379 - (1055 + 324);
		local v117;
		while true do
			if (((1463 - (1093 + 247)) == (110 + 13)) and (v116 == (0 + 0))) then
				v9.Print("Beast Mastery by Epic. Supported by Gojira");
				v117 = (v52.Growl:IsPetKnown() and v19.FindBySpellID(v52.Growl:ID()) and v52.Growl) or nil;
				v116 = 3 - 2;
			end
			if ((v116 == (3 - 2)) or ((3004 - 1948) >= (8523 - 5131))) then
				if (not v117 or ((385 + 696) < (4141 - 3066))) then
					v9.Print("|cffffff00Info|r: Add pet abilities to your action bars to improve range checks.");
				end
				break;
			end
		end
	end
	v9.SetAPL(871 - 618, v84, v85);
end;
return v0["Epix_Hunter_BeastMastery.lua"]();

