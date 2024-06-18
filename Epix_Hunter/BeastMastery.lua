local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 191 - (53 + 138);
	local v7;
	while true do
		if ((v6 == (301 - (112 + 189))) or ((23897 - 18943) == (5135 - 2232))) then
			v7 = v1[v5];
			if (((745 + 2339) > (63 - 23)) and not v7) then
				return v2(v5, v0, ...);
			end
			v6 = 1 + 0;
		end
		if (((5156 - (1344 + 400)) > (1224 - (255 + 150))) and (v6 == (1 + 0))) then
			return v7(v0, ...);
		end
	end
end
v1["Epix_Hunter_BeastMastery.lua"] = function(...)
	local v8, v9 = ...;
	local v10 = EpicDBC.DBC;
	local v11 = EpicLib;
	local v12 = EpicCache;
	local v13 = v11.Unit;
	local v14 = v13.Player;
	local v15 = v13.Target;
	local v16 = v13.Focus;
	local v17 = v13.MouseOver;
	local v18 = v13.Pet;
	local v19 = v11.Spell;
	local v20 = v11.Item;
	local v21 = v11.Action;
	local v22 = v11.Bind;
	local v23 = v11.Macro;
	local v24 = v11.AoEON;
	local v25 = v11.CDsON;
	local v26 = v11.Cast;
	local v27 = v11.Press;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31 = math.max;
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
	local v50;
	local function v51()
		local v93 = 0 + 0;
		while true do
			if (((13509 - 10347) <= (11114 - 7673)) and (v93 == (1739 - (404 + 1335)))) then
				v32 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or (406 - (183 + 223));
				v93 = 1 - 0;
			end
			if (((3119 + 1587) > (1594 + 2835)) and (v93 == (340 - (10 + 327)))) then
				v42 = EpicSettings.Settings['UsePet'];
				v43 = EpicSettings.Settings['SummonPetSlot'] or (0 + 0);
				v44 = EpicSettings.Settings['UseSteelTrap'];
				v93 = 342 - (118 + 220);
			end
			if (((952 + 1902) < (4544 - (108 + 341))) and (v93 == (3 + 2))) then
				v48 = EpicSettings.Settings['UseExhilaration'];
				v49 = EpicSettings.Settings['ExhilarationHP'] or (0 - 0);
				v50 = EpicSettings.Settings['UseTranq'];
				break;
			end
			if ((v93 == (1497 - (711 + 782))) or ((2028 - 970) >= (1671 - (270 + 199)))) then
				v45 = EpicSettings.Settings['UseRevive'];
				v46 = EpicSettings.Settings['UseMendPet'];
				v47 = EpicSettings.Settings['MendPetHP'] or (0 + 0);
				v93 = 1824 - (580 + 1239);
			end
			if (((11031 - 7320) > (3208 + 147)) and (v93 == (1 + 0))) then
				v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v37 = EpicSettings.Settings['UseHealthstone'];
				v38 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v93 = 2 + 0;
			end
			if ((v93 == (1169 - (645 + 522))) or ((2696 - (1010 + 780)) >= (2228 + 1))) then
				v39 = EpicSettings.Settings['InterruptWithStun'] or (0 - 0);
				v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v41 = EpicSettings.Settings['InterruptThreshold'] or (1836 - (1045 + 791));
				v93 = 7 - 4;
			end
		end
	end
	local v52 = v11.Commons.Everyone;
	local v53 = v11.Commons.Hunter;
	local v54 = v19.Hunter.BeastMastery;
	local v55 = {v54.SummonPet,v54.SummonPet2,v54.SummonPet3,v54.SummonPet4,v54.SummonPet5};
	local v56 = v20.Hunter.BeastMastery;
	local v57 = {};
	local v58 = v23.Hunter.BeastMastery;
	local v59 = v14:GetEquipment();
	v11:RegisterForEvent(function()
		v59 = v14:GetEquipment();
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v60;
	local v61 = 12670 - (1381 + 178);
	local v62 = 10422 + 689;
	local v63 = true;
	local v64 = false;
	local v65 = false;
	local v66 = 0 + 0;
	v11:RegisterForEvent(function()
		v61 = 4740 + 6371;
		v62 = 38304 - 27193;
	end, "PLAYER_REGEN_ENABLED");
	local v67, v68, v69;
	local v70, v71;
	local v72;
	local v73 = {{v54.Intimidation,"Cast Intimidation (Interrupt)",function()
		return true;
	end}};
	local function v74(v94)
		return (v94:DebuffRemains(v54.BarbedShotDebuff));
	end
	local function v75(v95)
		return (v95:DebuffStack(v54.LatentPoisonDebuff));
	end
	local function v76(v96)
		return (v96:DebuffRemains(v54.SerpentStingDebuff));
	end
	local function v77(v97)
		return (v97:DebuffStack(v54.LatentPoisonDebuff) > (14 - 5)) and ((v18:BuffUp(v54.FrenzyPetBuff) and (v18:BuffRemains(v54.FrenzyPetBuff) <= (v60 + (1156.25 - (1074 + 82))))) or (v54.ScentofBlood:IsAvailable() and (v54.BestialWrath:CooldownRemains() < ((25 - 13) + v60))) or ((v18:BuffStack(v54.FrenzyPetBuff) < (1787 - (214 + 1570))) and (v54.BestialWrath:CooldownUp() or v54.CalloftheWild:CooldownUp())) or ((v54.BarbedShot:FullRechargeTime() < v60) and v54.BestialWrath:CooldownDown()));
	end
	local function v78(v98)
		return (v18:BuffUp(v54.FrenzyPetBuff) and (v18:BuffRemains(v54.FrenzyPetBuff) <= (v60 + (1455.25 - (990 + 465))))) or (v54.ScentofBlood:IsAvailable() and (v54.BestialWrath:CooldownRemains() < (5 + 7 + v60))) or ((v18:BuffStack(v54.FrenzyPetBuff) < (2 + 1)) and (v54.BestialWrath:CooldownUp() or v54.CalloftheWild:CooldownUp())) or ((v54.BarbedShot:FullRechargeTime() < v60) and v54.BestialWrath:CooldownDown());
	end
	local function v79(v99)
		return (v99:DebuffStack(v54.LatentPoisonDebuff) > (9 + 0)) and (v14:BuffUp(v54.CalloftheWildBuff) or (v62 < (35 - 26)) or (v54.WildCall:IsAvailable() and (v54.BarbedShot:ChargesFractional() > (1727.2 - (1668 + 58)))) or v54.Savagery:IsAvailable());
	end
	local function v80(v100)
		return v14:BuffUp(v54.CalloftheWildBuff) or (v62 < (635 - (512 + 114))) or (v54.WildCall:IsAvailable() and (v54.BarbedShot:ChargesFractional() > (2.2 - 1))) or v54.Savagery:IsAvailable();
	end
	local function v81(v101)
		return v101:DebuffRefreshable(v54.SerpentStingDebuff) and (v101:TimeToDie() > v54.SerpentStingDebuff:BaseDuration());
	end
	local function v82(v102)
		return (v18:BuffUp(v54.FrenzyPetBuff) and (v18:BuffRemains(v54.FrenzyPetBuff) <= (v60 + (0.25 - 0)))) or (v54.ScentofBlood:IsAvailable() and (v18:BuffStack(v54.FrenzyPetBuff) < (10 - 7)) and (v54.BestialWrath:CooldownUp() or v54.CalloftheWild:CooldownUp()));
	end
	local function v83(v103)
		return (v54.WildCall:IsAvailable() and (v54.BarbedShot:ChargesFractional() > (1.4 + 0))) or v14:BuffUp(v54.CalloftheWildBuff) or ((v54.BarbedShot:FullRechargeTime() < v60) and v54.BestialWrath:CooldownDown()) or (v54.ScentofBlood:IsAvailable() and (v54.BestialWrath:CooldownRemains() < (3 + 9 + v60))) or v54.Savagery:IsAvailable() or (v62 < (8 + 1));
	end
	local function v84(v104)
		return v104:DebuffRefreshable(v54.SerpentStingDebuff) and (v15:TimeToDie() > v54.SerpentStingDebuff:BaseDuration());
	end
	local function v85()
		local v105 = 0 - 0;
		while true do
			if (((3282 - (109 + 1885)) > (2720 - (1269 + 200))) and (v105 == (3 - 1))) then
				if ((v17:Exists() and v54.KillShot:IsCastable() and (v17:HealthPercentage() <= (835 - (98 + 717)))) or ((5339 - (802 + 24)) < (5779 - 2427))) then
					if (v26(v58.KillShotMouseover, not v17:IsSpellInRange(v54.KillShot)) or ((2608 - 543) >= (472 + 2724))) then
						return "kill_shot_mouseover precombat 11";
					end
				end
				if (v54.KillCommand:IsReady() or ((3363 + 1013) <= (244 + 1237))) then
					if (v27(v58.KillCommandPetAttack) or ((732 + 2660) >= (13189 - 8448))) then
						return "kill_command precombat 12";
					end
				end
				v105 = 9 - 6;
			end
			if (((1190 + 2135) >= (877 + 1277)) and (v105 == (0 + 0))) then
				if ((v16:Exists() and v54.Misdirection:IsReady()) or ((942 + 353) >= (1510 + 1723))) then
					if (((5810 - (797 + 636)) > (7972 - 6330)) and v27(v58.MisdirectionFocus)) then
						return "misdirection precombat 0";
					end
				end
				if (((6342 - (1427 + 192)) > (470 + 886)) and v54.SteelTrap:IsCastable() and not v54.WailingArrow:IsAvailable() and v54.SteelTrap:IsAvailable() and v44) then
					if (v27(v54.SteelTrap) or ((9602 - 5466) <= (3086 + 347))) then
						return "steel_trap precombat 2";
					end
				end
				v105 = 1 + 0;
			end
			if (((4571 - (192 + 134)) <= (5907 - (316 + 960))) and (v105 == (2 + 1))) then
				if (((3300 + 976) >= (3618 + 296)) and (v69 > (3 - 2))) then
					if (((749 - (83 + 468)) <= (6171 - (1202 + 604))) and v54.MultiShot:IsReady()) then
						if (((22323 - 17541) > (7781 - 3105)) and v26(v54.MultiShot, not v15:IsSpellInRange(v54.MultiShot))) then
							return "multishot precombat 14";
						end
					end
				elseif (((13467 - 8603) > (2522 - (45 + 280))) and v54.CobraShot:IsReady()) then
					if (v26(v58.CobraShotPetAttack, not v15:IsSpellInRange(v54.CobraShot)) or ((3572 + 128) == (2191 + 316))) then
						return "cobra_shot precombat 16";
					end
				end
				break;
			end
			if (((1634 + 2840) >= (152 + 122)) and (v105 == (1 + 0))) then
				if ((v54.BarbedShot:IsCastable() and (v54.BarbedShot:Charges() >= (3 - 1))) or ((3805 - (340 + 1571)) <= (555 + 851))) then
					if (((3344 - (1733 + 39)) >= (4206 - 2675)) and v27(v58.BarbedShotPetAttack, not v15:IsSpellInRange(v54.BarbedShot))) then
						return "barbed_shot precombat 8";
					end
				end
				if (v54.KillShot:IsReady() or ((5721 - (125 + 909)) < (6490 - (1096 + 852)))) then
					if (((1477 + 1814) > (2380 - 713)) and v27(v54.KillShot, not v15:IsSpellInRange(v54.KillShot))) then
						return "kill_shot precombat 10";
					end
				end
				v105 = 2 + 0;
			end
		end
	end
	local function v86()
		local v106 = 512 - (409 + 103);
		while true do
			if ((v106 == (236 - (46 + 190))) or ((968 - (51 + 44)) == (574 + 1460))) then
				if ((v54.Berserking:IsCastable() and (v14:BuffUp(v54.CalloftheWildBuff) or (not v54.CalloftheWild:IsAvailable() and v14:BuffUp(v54.BestialWrathBuff)) or (v62 < (1330 - (1114 + 203))))) or ((3542 - (228 + 498)) < (3 + 8))) then
					if (((2044 + 1655) < (5369 - (174 + 489))) and v27(v54.Berserking)) then
						return "berserking cds 2";
					end
				end
				if (((6893 - 4247) >= (2781 - (830 + 1075))) and v54.BloodFury:IsCastable() and (v14:BuffUp(v54.CalloftheWildBuff) or (not v54.CalloftheWild:IsAvailable() and v14:BuffUp(v54.BestialWrathBuff)) or (v62 < (540 - (303 + 221))))) then
					if (((1883 - (231 + 1038)) <= (2654 + 530)) and v27(v54.BloodFury)) then
						return "blood_fury cds 8";
					end
				end
				v106 = 1163 - (171 + 991);
			end
			if (((12882 - 9756) == (8393 - 5267)) and (v106 == (2 - 1))) then
				if ((v54.AncestralCall:IsCastable() and (v14:BuffUp(v54.CalloftheWildBuff) or (not v54.CalloftheWild:IsAvailable() and v14:BuffUp(v54.BestialWrathBuff)) or (v62 < (13 + 3)))) or ((7666 - 5479) >= (14291 - 9337))) then
					if (v27(v54.AncestralCall) or ((6248 - 2371) == (11051 - 7476))) then
						return "ancestral_call cds 10";
					end
				end
				if (((1955 - (111 + 1137)) > (790 - (91 + 67))) and v54.Fireblood:IsCastable() and (v14:BuffUp(v54.CalloftheWildBuff) or (not v54.CalloftheWild:IsAvailable() and v14:BuffUp(v54.BestialWrathBuff)) or (v62 < (26 - 17)))) then
					if (v27(v54.Fireblood) or ((137 + 409) >= (3207 - (423 + 100)))) then
						return "fireblood cds 12";
					end
				end
				break;
			end
		end
	end
	local function v87()
		local v107 = 0 + 0;
		local v108;
		while true do
			if (((4056 - 2591) <= (2242 + 2059)) and (v107 == (772 - (326 + 445)))) then
				v108 = v52.HandleBottomTrinket(v57, v30, 174 - 134, nil);
				if (((3796 - 2092) > (3325 - 1900)) and v108) then
					return v108;
				end
				break;
			end
			if (((711 - (530 + 181)) == v107) or ((1568 - (614 + 267)) == (4266 - (19 + 13)))) then
				v108 = v52.HandleTopTrinket(v57, v30, 65 - 25, nil);
				if (v108 or ((7760 - 4430) < (4082 - 2653))) then
					return v108;
				end
				v107 = 1 + 0;
			end
		end
	end
	local function v88()
		if (((2017 - 870) >= (694 - 359)) and v54.BarbedShot:IsCastable()) then
			if (((5247 - (1293 + 519)) > (4277 - 2180)) and v52.CastTargetIf(v54.BarbedShot, v67, "max", v75, v77, not v15:IsSpellInRange(v54.BarbedShot))) then
				return "barbed_shot cleave 2";
			end
		end
		if (v54.BarbedShot:IsCastable() or ((9843 - 6073) >= (7727 - 3686))) then
			if (v52.CastTargetIf(v54.BarbedShot, v67, "min", v74, v78, not v15:IsSpellInRange(v54.BarbedShot)) or ((16347 - 12556) <= (3794 - 2183))) then
				return "barbed_shot cleave 4";
			end
		end
		if ((v54.MultiShot:IsReady() and (v18:BuffRemains(v54.BeastCleavePetBuff) < (0.5 + 0 + v60)) and (not v54.BloodyFrenzy:IsAvailable() or v54.CalloftheWild:CooldownDown())) or ((934 + 3644) <= (4665 - 2657))) then
			if (((260 + 865) <= (690 + 1386)) and v26(v54.MultiShot, nil, nil, not v15:IsSpellInRange(v54.MultiShot))) then
				return "multishot cleave 6";
			end
		end
		if (v54.BestialWrath:IsCastable() or ((465 + 278) >= (5495 - (709 + 387)))) then
			if (((3013 - (673 + 1185)) < (4851 - 3178)) and v27(v54.BestialWrath)) then
				return "bestial_wrath cleave 8";
			end
		end
		if ((v54.CalloftheWild:IsCastable() and v30) or ((7462 - 5138) <= (950 - 372))) then
			if (((2695 + 1072) == (2815 + 952)) and v26(v54.CalloftheWild)) then
				return "call_of_the_wild cleave 10";
			end
		end
		if (((5520 - 1431) == (1005 + 3084)) and v54.KillCommand:IsReady() and (v54.KillCleave:IsAvailable())) then
			if (((8888 - 4430) >= (3285 - 1611)) and v26(v54.KillCommand, nil, nil, not v15:IsInRange(1930 - (446 + 1434)))) then
				return "kill_command cleave 12";
			end
		end
		if (((2255 - (1040 + 243)) <= (4232 - 2814)) and v54.ExplosiveShot:IsReady()) then
			if (v26(v54.ExplosiveShot, not v15:IsSpellInRange(v54.ExplosiveShot)) or ((6785 - (559 + 1288)) < (6693 - (609 + 1322)))) then
				return "explosive_shot cleave 12";
			end
		end
		if ((v54.Stampede:IsCastable() and v30) or ((2958 - (13 + 441)) > (15933 - 11669))) then
			if (((5639 - 3486) == (10722 - 8569)) and v26(v54.Stampede, not v15:IsSpellInRange(v54.Stampede))) then
				return "stampede cleave 14";
			end
		end
		if (v54.Bloodshed:IsCastable() or ((19 + 488) >= (9409 - 6818))) then
			if (((1592 + 2889) == (1964 + 2517)) and v26(v54.Bloodshed, not v15:IsSpellInRange(v54.Bloodshed))) then
				return "bloodshed cleave 16";
			end
		end
		if ((v54.DeathChakram:IsCastable() and v30) or ((6908 - 4580) < (380 + 313))) then
			if (((7959 - 3631) == (2862 + 1466)) and v26(v54.DeathChakram, not v15:IsSpellInRange(v54.DeathChakram))) then
				return "death_chakram cleave 18";
			end
		end
		if (((884 + 704) >= (958 + 374)) and v54.SteelTrap:IsCastable() and v44) then
			if (v27(v58.SteelTrap) or ((3505 + 669) > (4157 + 91))) then
				return "steel_trap cleave 22";
			end
		end
		if ((v54.AMurderofCrows:IsReady() and v30) or ((5019 - (153 + 280)) <= (236 - 154))) then
			if (((3469 + 394) == (1526 + 2337)) and v26(v54.AMurderofCrows, not v15:IsSpellInRange(v54.AMurderofCrows))) then
				return "a_murder_of_crows cleave 24";
			end
		end
		if (v54.BarbedShot:IsCastable() or ((148 + 134) <= (39 + 3))) then
			if (((3340 + 1269) >= (1166 - 400)) and v52.CastTargetIf(v58.BarbedShotPetAttack, v67, "max", v75, v79, not v15:IsSpellInRange(v54.BarbedShot), nil, nil, v58.BarbedShotMouseover)) then
				return "barbed_shot cleave 26";
			end
		end
		if (v54.BarbedShot:IsCastable() or ((713 + 439) == (3155 - (89 + 578)))) then
			if (((2445 + 977) > (6964 - 3614)) and v52.CastTargetIf(v58.BarbedShotPetAttack, v67, "min", v74, v80, not v15:IsSpellInRange(v54.BarbedShot), nil, nil, v58.BarbedShotMouseover)) then
				return "barbed_shot cleave 28";
			end
		end
		if (((1926 - (572 + 477)) > (51 + 325)) and v54.KillCommand:IsReady()) then
			if (v26(v58.KillCommandPetAttack, not v15:IsSpellInRange(v54.KillCommand)) or ((1872 + 1246) <= (221 + 1630))) then
				return "kill_command cleave 30";
			end
		end
		if (v54.DireBeast:IsCastable() or ((251 - (84 + 2)) >= (5754 - 2262))) then
			if (((2845 + 1104) < (5698 - (497 + 345))) and v26(v54.DireBeast, not v15:IsSpellInRange(v54.DireBeast))) then
				return "dire_beast cleave 32";
			end
		end
		if (v54.SerpentSting:IsReady() or ((110 + 4166) < (510 + 2506))) then
			if (((6023 - (605 + 728)) > (2944 + 1181)) and v52.CastTargetIf(v54.SerpentSting, v67, "min", v76, v81, not v15:IsSpellInRange(v54.SerpentSting), nil, nil, v58.SerpentStingMouseover)) then
				return "serpent_sting cleave 34";
			end
		end
		if ((v54.Barrage:IsReady() and (v18:BuffRemains(v54.FrenzyPetBuff) > v54.Barrage:ExecuteTime())) or ((111 - 61) >= (42 + 854))) then
			if (v26(v54.Barrage, not v15:IsSpellInRange(v54.Barrage)) or ((6337 - 4623) >= (2667 + 291))) then
				return "barrage cleave 36";
			end
		end
		if ((v54.MultiShot:IsReady() and (v18:BuffRemains(v54.BeastCleavePetBuff) < (v14:GCD() * (7 - 4)))) or ((1126 + 365) < (1133 - (457 + 32)))) then
			if (((299 + 405) < (2389 - (832 + 570))) and v26(v54.MultiShot, not v15:IsSpellInRange(v54.MultiShot))) then
				return "multishot cleave 38";
			end
		end
		if (((3503 + 215) > (498 + 1408)) and v54.AspectoftheWild:IsCastable() and v30) then
			if (v27(v54.AspectoftheWild) or ((3390 - 2432) > (1751 + 1884))) then
				return "aspect_of_the_wild cleave 40";
			end
		end
		if (((4297 - (588 + 208)) <= (12106 - 7614)) and v30 and v54.LightsJudgment:IsCastable() and (v14:BuffDown(v54.BestialWrathBuff) or (v15:TimeToDie() < (1805 - (884 + 916))))) then
			if (v26(v54.LightsJudgment, nil, not v15:IsInRange(10 - 5)) or ((1996 + 1446) < (3201 - (232 + 421)))) then
				return "lights_judgment cleave 40";
			end
		end
		if (((4764 - (1569 + 320)) >= (360 + 1104)) and v54.KillShot:IsReady()) then
			if (v26(v54.KillShot, not v15:IsSpellInRange(v54.KillShot)) or ((912 + 3885) >= (16488 - 11595))) then
				return "kill_shot cleave 38";
			end
		end
		if ((v17:Exists() and v54.KillShot:IsCastable() and (v17:HealthPercentage() <= (625 - (316 + 289)))) or ((1442 - 891) > (96 + 1972))) then
			if (((3567 - (666 + 787)) > (1369 - (360 + 65))) and v26(v58.KillShotMouseover, not v17:IsSpellInRange(v54.KillShot))) then
				return "kill_shot_mouseover cleave 39";
			end
		end
		if ((v54.CobraShot:IsReady() and (v14:FocusTimeToMax() < (v60 * (2 + 0)))) or ((2516 - (79 + 175)) >= (4881 - 1785))) then
			if (v26(v58.CobraShotPetAttack, not v15:IsSpellInRange(v54.CobraShot)) or ((1760 + 495) >= (10841 - 7304))) then
				return "cobra_shot cleave 42";
			end
		end
		if ((v54.WailingArrow:IsReady() and ((v18:BuffRemains(v54.FrenzyPetBuff) > v54.WailingArrow:ExecuteTime()) or (v62 < (9 - 4)))) or ((4736 - (503 + 396)) < (1487 - (92 + 89)))) then
			if (((5722 - 2772) == (1513 + 1437)) and v26(v54.WailingArrow, not v15:IsSpellInRange(v54.WailingArrow))) then
				return "wailing_arrow cleave 44";
			end
		end
		if ((v54.BagofTricks:IsCastable() and v30 and (v14:BuffDown(v54.BestialWrathBuff) or (v62 < (3 + 2)))) or ((18495 - 13772) < (452 + 2846))) then
			if (((2590 - 1454) >= (135 + 19)) and v27(v54.BagofTricks)) then
				return "bag_of_tricks cleave 46";
			end
		end
		if ((v54.ArcaneTorrent:IsCastable() and v30 and ((v14:Focus() + v14:FocusRegen() + 15 + 15) < v14:FocusMax())) or ((825 - 554) > (593 + 4155))) then
			if (((7228 - 2488) >= (4396 - (485 + 759))) and v27(v54.ArcaneTorrent)) then
				return "arcane_torrent cleave 48";
			end
		end
	end
	local function v89()
		local v109 = 0 - 0;
		while true do
			if ((v109 == (1194 - (442 + 747))) or ((3713 - (832 + 303)) >= (4336 - (88 + 858)))) then
				if (((13 + 28) <= (1375 + 286)) and v54.WailingArrow:IsReady() and ((v18:BuffRemains(v54.FrenzyPetBuff) > v54.WailingArrow:ExecuteTime()) or (v62 < (1 + 4)))) then
					if (((1390 - (766 + 23)) < (17574 - 14014)) and v26(v54.WailingArrow, not v15:IsSpellInRange(v54.WailingArrow), true)) then
						return "wailing_arrow st 36";
					end
				end
				if (((320 - 85) < (1809 - 1122)) and v30) then
					if (((15439 - 10890) > (2226 - (1036 + 37))) and v54.BagofTricks:IsCastable() and (v14:BuffDown(v54.BestialWrathBuff) or (v62 < (4 + 1)))) then
						if (v27(v54.BagofTricks) or ((9101 - 4427) < (3676 + 996))) then
							return "bag_of_tricks st 38";
						end
					end
					if (((5148 - (641 + 839)) < (5474 - (910 + 3))) and v54.ArcanePulse:IsCastable() and (v14:BuffDown(v54.BestialWrathBuff) or (v62 < (12 - 7)))) then
						if (v27(v54.ArcanePulse) or ((2139 - (1466 + 218)) == (1657 + 1948))) then
							return "arcane_pulse st 40";
						end
					end
					if ((v54.ArcaneTorrent:IsCastable() and ((v14:Focus() + v14:FocusRegen() + (1163 - (556 + 592))) < v14:FocusMax())) or ((947 + 1716) == (4120 - (329 + 479)))) then
						if (((5131 - (174 + 680)) <= (15376 - 10901)) and v27(v54.ArcaneTorrent)) then
							return "arcane_torrent st 42";
						end
					end
				end
				break;
			end
			if ((v109 == (3 - 1)) or ((622 + 248) == (1928 - (396 + 343)))) then
				if (((138 + 1415) <= (4610 - (29 + 1448))) and v54.KillCommand:IsReady()) then
					if (v26(v58.KillCommandPetAttack, not v15:IsSpellInRange(v54.KillCommand)) or ((3626 - (135 + 1254)) >= (13226 - 9715))) then
						return "kill_command st 22";
					end
				end
				if ((v54.AMurderofCrows:IsCastable() and v30) or ((6181 - 4857) > (2013 + 1007))) then
					if (v26(v54.AMurderofCrows, not v15:IsSpellInRange(v54.AMurderofCrows)) or ((4519 - (389 + 1138)) == (2455 - (102 + 472)))) then
						return "a_murder_of_crows st 14";
					end
				end
				if (((2932 + 174) > (847 + 679)) and v54.SteelTrap:IsCastable() and v44) then
					if (((2819 + 204) < (5415 - (320 + 1225))) and v27(v54.SteelTrap)) then
						return "steel_trap st 16";
					end
				end
				if (((254 - 111) > (46 + 28)) and v54.ExplosiveShot:IsReady()) then
					if (((1482 - (157 + 1307)) < (3971 - (821 + 1038))) and v26(v54.ExplosiveShot, not v15:IsSpellInRange(v54.ExplosiveShot))) then
						return "explosive_shot st 18";
					end
				end
				v109 = 7 - 4;
			end
			if (((120 + 977) <= (2891 - 1263)) and (v109 == (2 + 1))) then
				if (((11475 - 6845) == (5656 - (834 + 192))) and v54.BarbedShot:IsCastable()) then
					if (((226 + 3314) > (689 + 1994)) and v52.CastTargetIf(v58.BarbedShotPetAttack, v67, "min", v74, v83, not v15:IsSpellInRange(v54.BarbedShot), nil, nil, v58.BarbedShotMouseover)) then
						return "barbed_shot st 24";
					end
				end
				if (((103 + 4691) >= (5073 - 1798)) and v54.BarbedShot:IsCastable() and v83(v15)) then
					if (((1788 - (300 + 4)) == (397 + 1087)) and v26(v58.BarbedShotPetAttack, not v15:IsSpellInRange(v54.BarbedShot))) then
						return "barbed_shot st mt_backup 25";
					end
				end
				if (((3748 - 2316) < (3917 - (112 + 250))) and v54.DireBeast:IsCastable()) then
					if (v26(v54.DireBeast, not v15:IsSpellInRange(v54.DireBeast)) or ((425 + 640) > (8963 - 5385))) then
						return "dire_beast st 26";
					end
				end
				if (v54.SerpentSting:IsReady() or ((2747 + 2048) < (728 + 679))) then
					if (((1386 + 467) < (2387 + 2426)) and v52.CastTargetIf(v54.SerpentSting, v67, "min", v76, v84, not v15:IsSpellInRange(v54.SerpentSting), nil, nil, v58.SerpentStingMouseover)) then
						return "serpent_sting st 28";
					end
				end
				v109 = 3 + 1;
			end
			if ((v109 == (1414 - (1001 + 413))) or ((6290 - 3469) < (3313 - (244 + 638)))) then
				if (v54.BarbedShot:IsCastable() or ((3567 - (627 + 66)) < (6498 - 4317))) then
					if (v52.CastTargetIf(v58.BarbedShotPetAttack, v67, "min", v74, v82, not v15:IsSpellInRange(v54.BarbedShot), nil, nil, v58.BarbedShotMouseover) or ((3291 - (512 + 90)) <= (2249 - (1665 + 241)))) then
						return "barbed_shot st 2";
					end
				end
				if ((v54.BarbedShot:IsCastable() and v82(v15)) or ((2586 - (373 + 344)) == (907 + 1102))) then
					if (v26(v58.BarbedShotPetAttack, not v15:IsSpellInRange(v54.BarbedShot)) or ((939 + 2607) < (6124 - 3802))) then
						return "barbed_shot st mt_backup 3";
					end
				end
				if ((v54.CalloftheWild:IsCastable() and v30) or ((3522 - 1440) == (5872 - (35 + 1064)))) then
					if (((2361 + 883) > (2257 - 1202)) and v27(v54.CalloftheWild)) then
						return "call_of_the_wild st 6";
					end
				end
				if ((v54.KillCommand:IsReady() and (v54.KillCommand:FullRechargeTime() < v60) and v54.AlphaPredator:IsAvailable()) or ((14 + 3299) <= (3014 - (298 + 938)))) then
					if (v26(v58.KillCommandPetAttack, not v15:IsSpellInRange(v54.KillCommand)) or ((2680 - (233 + 1026)) >= (3770 - (636 + 1030)))) then
						return "kill_command st 4";
					end
				end
				v109 = 1 + 0;
			end
			if (((1770 + 42) <= (966 + 2283)) and (v109 == (1 + 0))) then
				if (((1844 - (55 + 166)) <= (380 + 1577)) and v54.Stampede:IsCastable() and v30) then
					if (((444 + 3968) == (16849 - 12437)) and v26(v54.Stampede, nil, nil, not v15:IsSpellInRange(v54.Stampede))) then
						return "stampede st 8";
					end
				end
				if (((2047 - (36 + 261)) >= (1472 - 630)) and v54.Bloodshed:IsCastable()) then
					if (((5740 - (34 + 1334)) > (712 + 1138)) and v26(v54.Bloodshed, not v15:IsSpellInRange(v54.Bloodshed))) then
						return "bloodshed st 10";
					end
				end
				if (((181 + 51) < (2104 - (1035 + 248))) and v54.BestialWrath:IsCastable()) then
					if (((539 - (20 + 1)) < (470 + 432)) and v27(v54.BestialWrath)) then
						return "bestial_wrath st 12";
					end
				end
				if (((3313 - (134 + 185)) > (1991 - (549 + 584))) and v54.DeathChakram:IsCastable() and v30) then
					if (v26(v54.DeathChakram, nil, nil, not v15:IsSpellInRange(v54.DeathChakram)) or ((4440 - (314 + 371)) <= (3141 - 2226))) then
						return "death_chakram st 14";
					end
				end
				v109 = 970 - (478 + 490);
			end
			if (((2091 + 1855) > (4915 - (786 + 386))) and (v109 == (12 - 8))) then
				if (v54.KillShot:IsReady() or ((2714 - (1055 + 324)) >= (4646 - (1093 + 247)))) then
					if (((4305 + 539) > (237 + 2016)) and v26(v54.KillShot, not v15:IsSpellInRange(v54.KillShot))) then
						return "kill_shot st 30";
					end
				end
				if (((1794 - 1342) == (1533 - 1081)) and v17:Exists() and v54.KillShot:IsCastable() and (v17:HealthPercentage() <= (56 - 36))) then
					if (v26(v58.KillShotMouseover, not v17:IsSpellInRange(v54.KillShot)) or ((11451 - 6894) < (743 + 1344))) then
						return "kill_shot_mouseover st 31";
					end
				end
				if (((14924 - 11050) == (13352 - 9478)) and v54.AspectoftheWild:IsCastable() and v30) then
					if (v27(v54.AspectoftheWild) or ((1462 + 476) > (12620 - 7685))) then
						return "aspect_of_the_wild st 32";
					end
				end
				if (v54.CobraShot:IsReady() or ((4943 - (364 + 324)) < (9383 - 5960))) then
					if (((3488 - 2034) <= (826 + 1665)) and v26(v58.CobraShotPetAttack, not v15:IsSpellInRange(v54.CobraShot))) then
						return "cobra_shot st 34";
					end
				end
				v109 = 20 - 15;
			end
		end
	end
	local function v90()
		if ((not v14:IsCasting() and not v14:IsChanneling()) or ((6656 - 2499) <= (8512 - 5709))) then
			local v118 = v52.Interrupt(v54.CounterShot, 1308 - (1249 + 19), true);
			if (((4381 + 472) >= (11607 - 8625)) and v118) then
				return v118;
			end
			v118 = v52.InterruptWithStun(v54.Intimidation, 1126 - (686 + 400));
			if (((3244 + 890) > (3586 - (73 + 156))) and v118) then
				return v118;
			end
		end
	end
	local function v91()
		v51();
		v28 = EpicSettings.Toggles['ooc'];
		v29 = EpicSettings.Toggles['aoe'];
		v30 = EpicSettings.Toggles['cds'];
		if (v54.Stomp:IsAvailable() or ((17 + 3400) < (3345 - (721 + 90)))) then
			v11.SplashEnemies.ChangeFriendTargetsTracking("Mine Only");
		else
			v11.SplashEnemies.ChangeFriendTargetsTracking("All");
		end
		local v113 = (v54.BloodBolt:IsPetKnown() and v21.FindBySpellID(v54.BloodBolt:ID()) and v54.BloodBolt) or (v54.Bite:IsPetKnown() and v21.FindBySpellID(v54.Bite:ID()) and v54.Bite) or (v54.Claw:IsPetKnown() and v21.FindBySpellID(v54.Claw:ID()) and v54.Claw) or (v54.Smack:IsPetKnown() and v21.FindBySpellID(v54.Smack:ID()) and v54.Smack) or nil;
		local v114 = (v54.Growl:IsPetKnown() and v21.FindBySpellID(v54.Growl:ID()) and v54.Growl) or nil;
		if (v29 or ((31 + 2691) <= (532 - 368))) then
			local v119 = 470 - (224 + 246);
			while true do
				if ((v119 == (0 - 0)) or ((4433 - 2025) < (383 + 1726))) then
					v67 = v14:GetEnemiesInRange(1 + 39);
					v68 = (v113 and v14:GetEnemiesInSpellActionRange(v113)) or v15:GetEnemiesInSplashRange(6 + 2);
					v119 = 1 - 0;
				end
				if (((3 - 2) == v119) or ((546 - (203 + 310)) == (3448 - (1238 + 755)))) then
					v69 = (v113 and #v68) or v15:GetEnemiesInSplashRangeCount(1 + 7);
					break;
				end
			end
		else
			local v120 = 1534 - (709 + 825);
			while true do
				if ((v120 == (1 - 0)) or ((644 - 201) >= (4879 - (196 + 668)))) then
					v69 = 0 - 0;
					break;
				end
				if (((7005 - 3623) > (999 - (171 + 662))) and (v120 == (93 - (4 + 89)))) then
					v67 = {};
					v68 = v15 or {};
					v120 = 3 - 2;
				end
			end
		end
		v70 = v15:IsInRange(15 + 25);
		v71 = v15:IsInRange(131 - 101);
		v72 = (v114 and v15:IsSpellInActionRange(v114)) or v15:IsInRange(12 + 18);
		v60 = v14:GCD() + (1486.15 - (35 + 1451));
		if (v52.TargetIsValid() or v14:AffectingCombat() or ((1733 - (28 + 1425)) == (5052 - (941 + 1052)))) then
			local v121 = 0 + 0;
			while true do
				if (((3395 - (822 + 692)) > (1845 - 552)) and (v121 == (1 + 0))) then
					if (((2654 - (45 + 252)) == (2333 + 24)) and (v62 == (3824 + 7287))) then
						v62 = v11.FightRemains(v67, false);
					end
					break;
				end
				if (((299 - 176) == (556 - (114 + 319))) and (v121 == (0 - 0))) then
					v61 = v11.BossFightRemains();
					v62 = v61;
					v121 = 1 - 0;
				end
			end
		end
		if ((v54.Exhilaration:IsCastable() and v48 and (v14:HealthPercentage() <= v49)) or ((674 + 382) >= (5052 - 1660))) then
			if (v26(v54.Exhilaration) or ((2264 - 1183) < (3038 - (556 + 1407)))) then
				return "Exhilaration";
			end
		end
		if (((v14:HealthPercentage() <= v38) and v37 and v56.Healthstone:IsReady()) or ((2255 - (741 + 465)) >= (4897 - (170 + 295)))) then
			if (v27(v58.Healthstone, nil, nil, true) or ((2513 + 2255) <= (778 + 68))) then
				return "healthstone defensive 3";
			end
		end
		if ((v34 and (v14:HealthPercentage() <= v36)) or ((8267 - 4909) <= (1178 + 242))) then
			if ((v35 == "Refreshing Healing Potion") or ((2398 + 1341) <= (1702 + 1303))) then
				if (v56.RefreshingHealingPotion:IsReady() or ((2889 - (957 + 273)) >= (571 + 1563))) then
					if (v27(v58.RefreshingHealingPotion) or ((1306 + 1954) < (8973 - 6618))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if ((v35 == "Dreamwalker's Healing Potion") or ((1762 - 1093) == (12899 - 8676))) then
				if (v56.DreamwalkersHealingPotion:IsReady() or ((8378 - 6686) < (2368 - (389 + 1391)))) then
					if (v27(v58.RefreshingHealingPotion) or ((3010 + 1787) < (381 + 3270))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
		if (not (v14:IsMounted() or v14:IsInVehicle()) or ((9509 - 5332) > (5801 - (783 + 168)))) then
			local v122 = 0 - 0;
			while true do
				if ((v122 == (1 + 0)) or ((711 - (309 + 2)) > (3411 - 2300))) then
					if (((4263 - (1090 + 122)) > (326 + 679)) and v54.MendPet:IsCastable() and v46 and (v18:HealthPercentage() < v47)) then
						if (((12402 - 8709) <= (2999 + 1383)) and v27(v54.MendPet)) then
							return "Mend Pet High Priority";
						end
					end
					break;
				end
				if ((v122 == (1118 - (628 + 490))) or ((589 + 2693) > (10151 - 6051))) then
					if ((v54.SummonPet:IsCastable() and v42) or ((16360 - 12780) < (3618 - (431 + 343)))) then
						if (((179 - 90) < (12989 - 8499)) and v27(v55[v43])) then
							return "Summon Pet";
						end
					end
					if ((v54.RevivePet:IsCastable() and v45 and v18:IsDeadOrGhost()) or ((3937 + 1046) < (232 + 1576))) then
						if (((5524 - (556 + 1139)) > (3784 - (6 + 9))) and v27(v54.RevivePet)) then
							return "Revive Pet";
						end
					end
					v122 = 1 + 0;
				end
			end
		end
		if (((761 + 724) <= (3073 - (28 + 141))) and v52.TargetIsValid()) then
			if (((1654 + 2615) == (5268 - 999)) and not v14:AffectingCombat() and not v28) then
				local v134 = v85();
				if (((275 + 112) <= (4099 - (486 + 831))) and v134) then
					return v134;
				end
			end
			if ((not v14:IsCasting() and not v14:IsChanneling()) or ((4941 - 3042) <= (3228 - 2311))) then
				local v135 = v52.Interrupt(v54.CounterShot, 8 + 32, true);
				if (v135 or ((13634 - 9322) <= (2139 - (668 + 595)))) then
					return v135;
				end
				v135 = v52.Interrupt(v54.CounterShot, 36 + 4, true, v17, v58.CounterShotMouseover);
				if (((451 + 1781) <= (7079 - 4483)) and v135) then
					return v135;
				end
				v135 = v52.InterruptWithStun(v54.Intimidation, 330 - (23 + 267), true);
				if (((4039 - (1129 + 815)) < (4073 - (371 + 16))) and v135) then
					return v135;
				end
				v135 = v52.InterruptWithStun(v54.Intimidation, 1790 - (1326 + 424), true, v17, v58.IntimidationMouseover);
				if (v135 or ((3020 - 1425) >= (16349 - 11875))) then
					return v135;
				end
			end
			local v123 = v52.HandleDPSPotion();
			if (v123 or ((4737 - (88 + 30)) < (3653 - (720 + 51)))) then
				return v123;
			end
			if (v30 or ((653 - 359) >= (6607 - (421 + 1355)))) then
				local v136 = 0 - 0;
				local v137;
				while true do
					if (((997 + 1032) <= (4167 - (286 + 797))) and ((0 - 0) == v136)) then
						v137 = v86();
						if (v137 or ((3373 - 1336) == (2859 - (397 + 42)))) then
							return v137;
						end
						break;
					end
				end
			end
			local v124 = v87();
			if (((1393 + 3065) > (4704 - (24 + 776))) and v124) then
				return v124;
			end
			if (((671 - 235) >= (908 - (222 + 563))) and ((v69 > (3 - 1)) or (v54.BeastCleave:IsAvailable() and (v69 > (1 + 0))))) then
				local v138 = v88();
				if (((690 - (23 + 167)) < (3614 - (690 + 1108))) and v138) then
					return v138;
				end
			end
			if (((1290 + 2284) == (2948 + 626)) and ((v69 < (850 - (40 + 808))) or (not v54.BeastCleave:IsAvailable() and (v69 < (1 + 2))))) then
				local v139 = v89();
				if (((845 - 624) < (373 + 17)) and v139) then
					return v139;
				end
			end
			if ((not (v14:IsMounted() or v14:IsInVehicle()) and not v18:IsDeadOrGhost() and v54.MendPet:IsCastable() and (v18:HealthPercentage() < v47) and v46) or ((1171 + 1042) <= (780 + 641))) then
				if (((3629 - (47 + 524)) < (3154 + 1706)) and v27(v54.MendPet)) then
					return "Mend Pet Low Priority (w/ Target)";
				end
			end
		end
		if ((not (v14:IsMounted() or v14:IsInVehicle()) and not v18:IsDeadOrGhost() and v54.MendPet:IsCastable() and (v18:HealthPercentage() < v47) and v46) or ((3542 - 2246) >= (6647 - 2201))) then
			if (v27(v54.MendPet) or ((3176 - 1783) > (6215 - (1165 + 561)))) then
				return "Mend Pet Low Priority (w/o Target)";
			end
		end
	end
	local function v92()
		local v115 = 0 + 0;
		local v116;
		while true do
			if ((v115 == (0 - 0)) or ((1688 + 2736) < (506 - (341 + 138)))) then
				v11.Print("Beast Mastery by Epic. Supported by Gojira");
				v116 = (v54.Growl:IsPetKnown() and v21.FindBySpellID(v54.Growl:ID()) and v54.Growl) or nil;
				v115 = 1 + 0;
			end
			if ((v115 == (1 - 0)) or ((2323 - (89 + 237)) > (12272 - 8457))) then
				if (((7294 - 3829) > (2794 - (581 + 300))) and not v116) then
					v11.Print("|cffffff00Info|r: Add pet abilities to your action bars to improve range checks.");
				end
				break;
			end
		end
	end
	v11.SetAPL(1473 - (855 + 365), v91, v92);
end;
return v1["Epix_Hunter_BeastMastery.lua"](...);

