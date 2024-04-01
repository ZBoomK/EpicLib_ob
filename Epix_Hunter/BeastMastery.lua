local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((6343 - 4379) < (3079 - (404 + 1335)))) then
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
		local v87 = 406 - (183 + 223);
		while true do
			if (((3040 - 541) == (1656 + 843)) and (v87 == (1 + 1))) then
				v37 = EpicSettings.Settings['InterruptWithStun'] or (337 - (10 + 327));
				v38 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v39 = EpicSettings.Settings['InterruptThreshold'] or (338 - (118 + 220));
				v87 = 1 + 2;
			end
			if ((v87 == (450 - (108 + 341))) or ((1013 + 1242) < (92 - 70))) then
				v34 = EpicSettings.Settings['HealingPotionHP'] or (1493 - (711 + 782));
				v35 = EpicSettings.Settings['UseHealthstone'];
				v36 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v87 = 471 - (270 + 199);
			end
			if ((v87 == (2 + 3)) or ((2905 - (580 + 1239)) >= (4176 - 2771))) then
				v46 = EpicSettings.Settings['UseExhilaration'];
				v47 = EpicSettings.Settings['ExhilarationHP'] or (0 + 0);
				v48 = EpicSettings.Settings['UseTranq'];
				break;
			end
			if ((v87 == (0 + 0)) or ((1032 + 1337) == (1112 - 686))) then
				v30 = EpicSettings.Settings['UseRacials'];
				v32 = EpicSettings.Settings['UseHealingPotion'];
				v33 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v87 = 1168 - (645 + 522);
			end
			if ((v87 == (1793 - (1010 + 780))) or ((3075 + 1) > (15163 - 11980))) then
				v40 = EpicSettings.Settings['UsePet'];
				v41 = EpicSettings.Settings['SummonPetSlot'] or (0 - 0);
				v42 = EpicSettings.Settings['UseSteelTrap'];
				v87 = 1840 - (1045 + 791);
			end
			if (((3042 - 1840) > (1615 - 557)) and (v87 == (509 - (351 + 154)))) then
				v43 = EpicSettings.Settings['UseRevive'];
				v44 = EpicSettings.Settings['UseMendPet'];
				v45 = EpicSettings.Settings['MendPetHP'] or (1574 - (1281 + 293));
				v87 = 271 - (28 + 238);
			end
		end
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
	local v59 = 38304 - 27193;
	local v60 = 5757 + 5354;
	v9:RegisterForEvent(function()
		local v88 = 470 - (381 + 89);
		while true do
			if (((3291 + 420) > (2269 + 1086)) and (v88 == (0 - 0))) then
				v59 = 12267 - (1074 + 82);
				v60 = 24349 - 13238;
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
	local function v68(v89)
		return (v89:DebuffRemains(v52.BarbedShotDebuff));
	end
	local function v69(v90)
		return (v90:DebuffStack(v52.LatentPoisonDebuff));
	end
	local function v70(v91)
		return (v91:DebuffRemains(v52.SerpentStingDebuff));
	end
	local function v71(v92)
		return (v92:DebuffStack(v52.LatentPoisonDebuff) > (9 + 0)) and ((v16:BuffUp(v52.FrenzyPetBuff) and (v16:BuffRemains(v52.FrenzyPetBuff) <= (v58 + (0.25 - 0)))) or (v52.ScentofBlood:IsAvailable() and (v52.BestialWrath:CooldownRemains() < ((1738 - (1668 + 58)) + v58))) or ((v16:BuffStack(v52.FrenzyPetBuff) < (629 - (512 + 114))) and (v52.BestialWrath:CooldownUp() or v52.CalloftheWild:CooldownUp())) or ((v52.BarbedShot:FullRechargeTime() < v58) and v52.BestialWrath:CooldownDown()));
	end
	local function v72(v93)
		return (v16:BuffUp(v52.FrenzyPetBuff) and (v16:BuffRemains(v52.FrenzyPetBuff) <= (v58 + (0.25 - 0)))) or (v52.ScentofBlood:IsAvailable() and (v52.BestialWrath:CooldownRemains() < ((24 - 12) + v58))) or ((v16:BuffStack(v52.FrenzyPetBuff) < (10 - 7)) and (v52.BestialWrath:CooldownUp() or v52.CalloftheWild:CooldownUp())) or ((v52.BarbedShot:FullRechargeTime() < v58) and v52.BestialWrath:CooldownDown());
	end
	local function v73(v94)
		return (v94:DebuffStack(v52.LatentPoisonDebuff) > (5 + 4)) and (v12:BuffUp(v52.CalloftheWildBuff) or (v60 < (2 + 7)) or (v52.WildCall:IsAvailable() and (v52.BarbedShot:ChargesFractional() > (1.2 + 0))) or v52.Savagery:IsAvailable());
	end
	local function v74(v95)
		return v12:BuffUp(v52.CalloftheWildBuff) or (v60 < (30 - 21)) or (v52.WildCall:IsAvailable() and (v52.BarbedShot:ChargesFractional() > (1995.2 - (109 + 1885)))) or v52.Savagery:IsAvailable();
	end
	local function v75(v96)
		return v96:DebuffRefreshable(v52.SerpentStingDebuff) and (v96:TimeToDie() > v52.SerpentStingDebuff:BaseDuration());
	end
	local function v76(v97)
		return (v16:BuffUp(v52.FrenzyPetBuff) and (v16:BuffRemains(v52.FrenzyPetBuff) <= (v58 + (1469.25 - (1269 + 200))))) or (v52.ScentofBlood:IsAvailable() and (v16:BuffStack(v52.FrenzyPetBuff) < (5 - 2)) and (v52.BestialWrath:CooldownUp() or v52.CalloftheWild:CooldownUp()));
	end
	local function v77(v98)
		return (v52.WildCall:IsAvailable() and (v52.BarbedShot:ChargesFractional() > (816.4 - (98 + 717)))) or v12:BuffUp(v52.CalloftheWildBuff) or ((v52.BarbedShot:FullRechargeTime() < v58) and v52.BestialWrath:CooldownDown()) or (v52.ScentofBlood:IsAvailable() and (v52.BestialWrath:CooldownRemains() < ((838 - (802 + 24)) + v58))) or v52.Savagery:IsAvailable() or (v60 < (15 - 6));
	end
	local function v78(v99)
		return v99:DebuffRefreshable(v52.SerpentStingDebuff) and (v13:TimeToDie() > v52.SerpentStingDebuff:BaseDuration());
	end
	local function v79()
		local v100 = 0 - 0;
		while true do
			if ((v100 == (1 + 2)) or ((697 + 209) >= (367 + 1862))) then
				if (((278 + 1010) > (3480 - 2229)) and (v63 > (3 - 2))) then
					if (v52.MultiShot:IsReady() or ((1615 + 2898) < (1365 + 1987))) then
						if (v24(v52.MultiShot, not v13:IsSpellInRange(v52.MultiShot)) or ((1704 + 361) >= (2324 + 872))) then
							return "multishot precombat 14";
						end
					end
				elseif (v52.CobraShot:IsReady() or ((2044 + 2332) <= (2914 - (797 + 636)))) then
					if (v24(v56.CobraShotPetAttack, not v13:IsSpellInRange(v52.CobraShot)) or ((16469 - 13077) >= (6360 - (1427 + 192)))) then
						return "cobra_shot precombat 16";
					end
				end
				break;
			end
			if (((1153 + 2172) >= (5000 - 2846)) and (v100 == (2 + 0))) then
				if ((v15:Exists() and v52.KillShot:IsCastable() and (v15:HealthPercentage() <= (10 + 10))) or ((1621 - (192 + 134)) >= (4509 - (316 + 960)))) then
					if (((2436 + 1941) > (1268 + 374)) and v24(v56.KillShotMouseover, not v15:IsSpellInRange(v52.KillShot))) then
						return "kill_shot_mouseover precombat 11";
					end
				end
				if (((4366 + 357) > (5183 - 3827)) and v52.KillCommand:IsReady()) then
					if (v25(v56.KillCommandPetAttack) or ((4687 - (83 + 468)) <= (5239 - (1202 + 604)))) then
						return "kill_command precombat 12";
					end
				end
				v100 = 13 - 10;
			end
			if (((7064 - 2819) <= (12821 - 8190)) and (v100 == (325 - (45 + 280)))) then
				if (((4128 + 148) >= (3420 + 494)) and v14:Exists() and v52.Misdirection:IsReady()) then
					if (((73 + 125) <= (2416 + 1949)) and v25(v56.MisdirectionFocus)) then
						return "misdirection precombat 0";
					end
				end
				if (((842 + 3940) > (8658 - 3982)) and v52.SteelTrap:IsCastable() and not v52.WailingArrow:IsAvailable() and v52.SteelTrap:IsAvailable() and v42) then
					if (((6775 - (340 + 1571)) > (867 + 1330)) and v25(v52.SteelTrap)) then
						return "steel_trap precombat 2";
					end
				end
				v100 = 1773 - (1733 + 39);
			end
			if ((v100 == (2 - 1)) or ((4734 - (125 + 909)) == (4455 - (1096 + 852)))) then
				if (((2007 + 2467) >= (391 - 117)) and v52.BarbedShot:IsCastable() and (v52.BarbedShot:Charges() >= (2 + 0))) then
					if (v25(v56.BarbedShotPetAttack, not v13:IsSpellInRange(v52.BarbedShot)) or ((2406 - (409 + 103)) <= (1642 - (46 + 190)))) then
						return "barbed_shot precombat 8";
					end
				end
				if (((1667 - (51 + 44)) >= (432 + 1099)) and v52.KillShot:IsReady()) then
					if (v25(v52.KillShot, not v13:IsSpellInRange(v52.KillShot)) or ((6004 - (1114 + 203)) < (5268 - (228 + 498)))) then
						return "kill_shot precombat 10";
					end
				end
				v100 = 1 + 1;
			end
		end
	end
	local function v80()
		local v101 = 0 + 0;
		while true do
			if (((3954 - (174 + 489)) > (4343 - 2676)) and (v101 == (1905 - (830 + 1075)))) then
				if ((v52.Berserking:IsCastable() and (v12:BuffUp(v52.CalloftheWildBuff) or (not v52.CalloftheWild:IsAvailable() and v12:BuffUp(v52.BestialWrathBuff)) or (v60 < (537 - (303 + 221))))) or ((2142 - (231 + 1038)) == (1695 + 339))) then
					if (v25(v52.Berserking) or ((3978 - (171 + 991)) < (45 - 34))) then
						return "berserking cds 2";
					end
				end
				if (((9932 - 6233) < (11743 - 7037)) and v52.BloodFury:IsCastable() and (v12:BuffUp(v52.CalloftheWildBuff) or (not v52.CalloftheWild:IsAvailable() and v12:BuffUp(v52.BestialWrathBuff)) or (v60 < (13 + 3)))) then
					if (((9275 - 6629) >= (2526 - 1650)) and v25(v52.BloodFury)) then
						return "blood_fury cds 8";
					end
				end
				v101 = 1 - 0;
			end
			if (((1897 - 1283) <= (4432 - (111 + 1137))) and (v101 == (159 - (91 + 67)))) then
				if (((9303 - 6177) == (780 + 2346)) and v52.AncestralCall:IsCastable() and (v12:BuffUp(v52.CalloftheWildBuff) or (not v52.CalloftheWild:IsAvailable() and v12:BuffUp(v52.BestialWrathBuff)) or (v60 < (539 - (423 + 100))))) then
					if (v25(v52.AncestralCall) or ((16 + 2171) >= (13716 - 8762))) then
						return "ancestral_call cds 10";
					end
				end
				if ((v52.Fireblood:IsCastable() and (v12:BuffUp(v52.CalloftheWildBuff) or (not v52.CalloftheWild:IsAvailable() and v12:BuffUp(v52.BestialWrathBuff)) or (v60 < (5 + 4)))) or ((4648 - (326 + 445)) == (15601 - 12026))) then
					if (((1574 - 867) > (1474 - 842)) and v25(v52.Fireblood)) then
						return "fireblood cds 12";
					end
				end
				break;
			end
		end
	end
	local function v81()
		local v102 = 711 - (530 + 181);
		local v103;
		while true do
			if ((v102 == (882 - (614 + 267))) or ((578 - (19 + 13)) >= (4368 - 1684))) then
				v103 = v50.HandleBottomTrinket(v55, v28, 93 - 53, nil);
				if (((4184 - 2719) <= (1118 + 3183)) and v103) then
					return v103;
				end
				break;
			end
			if (((2996 - 1292) > (2955 - 1530)) and ((1812 - (1293 + 519)) == v102)) then
				v103 = v50.HandleTopTrinket(v55, v28, 81 - 41, nil);
				if (v103 or ((1793 - 1106) == (8096 - 3862))) then
					return v103;
				end
				v102 = 4 - 3;
			end
		end
	end
	local function v82()
		local v104 = 0 - 0;
		while true do
			if ((v104 == (2 + 1)) or ((680 + 2650) < (3319 - 1890))) then
				if (((266 + 881) >= (112 + 223)) and v52.DeathChakram:IsCastable() and v28) then
					if (((2147 + 1288) > (3193 - (709 + 387))) and v24(v52.DeathChakram, not v13:IsSpellInRange(v52.DeathChakram))) then
						return "death_chakram cleave 18";
					end
				end
				if ((v52.SteelTrap:IsCastable() and v42) or ((5628 - (673 + 1185)) >= (11719 - 7678))) then
					if (v25(v56.SteelTrap) or ((12173 - 8382) <= (2650 - 1039))) then
						return "steel_trap cleave 22";
					end
				end
				if ((v52.AMurderofCrows:IsReady() and v28) or ((3275 + 1303) <= (1501 + 507))) then
					if (((1518 - 393) <= (510 + 1566)) and v24(v52.AMurderofCrows, not v13:IsSpellInRange(v52.AMurderofCrows))) then
						return "a_murder_of_crows cleave 24";
					end
				end
				v104 = 7 - 3;
			end
			if ((v104 == (11 - 5)) or ((2623 - (446 + 1434)) >= (5682 - (1040 + 243)))) then
				if (((3447 - 2292) < (3520 - (559 + 1288))) and v52.MultiShot:IsReady() and (v16:BuffRemains(v52.BeastCleavePetBuff) < (v12:GCD() * (1934 - (609 + 1322))))) then
					if (v24(v52.MultiShot, not v13:IsSpellInRange(v52.MultiShot)) or ((2778 - (13 + 441)) <= (2159 - 1581))) then
						return "multishot cleave 38";
					end
				end
				if (((9867 - 6100) == (18761 - 14994)) and v52.AspectoftheWild:IsCastable() and v28) then
					if (((153 + 3936) == (14850 - 10761)) and v25(v52.AspectoftheWild)) then
						return "aspect_of_the_wild cleave 40";
					end
				end
				if (((1584 + 2874) >= (734 + 940)) and v28 and v52.LightsJudgment:IsCastable() and (v12:BuffDown(v52.BestialWrathBuff) or (v13:TimeToDie() < (14 - 9)))) then
					if (((532 + 440) <= (2607 - 1189)) and v24(v52.LightsJudgment, nil, not v13:IsInRange(4 + 1))) then
						return "lights_judgment cleave 40";
					end
				end
				v104 = 4 + 3;
			end
			if ((v104 == (3 + 1)) or ((4147 + 791) < (4660 + 102))) then
				if (v52.BarbedShot:IsCastable() or ((2937 - (153 + 280)) > (12312 - 8048))) then
					if (((1933 + 220) == (851 + 1302)) and v50.CastTargetIf(v56.BarbedShotPetAttack, v61, "max", v69, v73, not v13:IsSpellInRange(v52.BarbedShot), nil, nil, v56.BarbedShotMouseover)) then
						return "barbed_shot cleave 26";
					end
				end
				if (v52.BarbedShot:IsCastable() or ((266 + 241) >= (2352 + 239))) then
					if (((3247 + 1234) == (6822 - 2341)) and v50.CastTargetIf(v56.BarbedShotPetAttack, v61, "min", v68, v74, not v13:IsSpellInRange(v52.BarbedShot), nil, nil, v56.BarbedShotMouseover)) then
						return "barbed_shot cleave 28";
					end
				end
				if (v52.KillCommand:IsReady() or ((1439 + 889) < (1360 - (89 + 578)))) then
					if (((3092 + 1236) == (8997 - 4669)) and v24(v56.KillCommandPetAttack, not v13:IsSpellInRange(v52.KillCommand))) then
						return "kill_command cleave 30";
					end
				end
				v104 = 1054 - (572 + 477);
			end
			if (((215 + 1373) >= (800 + 532)) and (v104 == (1 + 7))) then
				if ((v52.WailingArrow:IsReady() and ((v16:BuffRemains(v52.FrenzyPetBuff) > v52.WailingArrow:ExecuteTime()) or (v60 < (91 - (84 + 2))))) or ((6878 - 2704) > (3061 + 1187))) then
					if (v24(v52.WailingArrow, not v13:IsSpellInRange(v52.WailingArrow)) or ((5428 - (497 + 345)) <= (3 + 79))) then
						return "wailing_arrow cleave 44";
					end
				end
				if (((654 + 3209) == (5196 - (605 + 728))) and v52.BagofTricks:IsCastable() and v28 and (v12:BuffDown(v52.BestialWrathBuff) or (v60 < (4 + 1)))) then
					if (v25(v52.BagofTricks) or ((626 - 344) <= (2 + 40))) then
						return "bag_of_tricks cleave 46";
					end
				end
				if (((17040 - 12431) >= (691 + 75)) and v52.ArcaneTorrent:IsCastable() and v28 and ((v12:Focus() + v12:FocusRegen() + (83 - 53)) < v12:FocusMax())) then
					if (v25(v52.ArcaneTorrent) or ((870 + 282) == (2977 - (457 + 32)))) then
						return "arcane_torrent cleave 48";
					end
				end
				break;
			end
			if (((1452 + 1970) > (4752 - (832 + 570))) and ((0 + 0) == v104)) then
				if (((229 + 648) > (1330 - 954)) and v52.BarbedShot:IsCastable()) then
					if (v50.CastTargetIf(v52.BarbedShot, v61, "max", v69, v71, not v13:IsSpellInRange(v52.BarbedShot)) or ((1502 + 1616) <= (2647 - (588 + 208)))) then
						return "barbed_shot cleave 2";
					end
				end
				if (v52.BarbedShot:IsCastable() or ((444 - 279) >= (5292 - (884 + 916)))) then
					if (((8267 - 4318) < (2816 + 2040)) and v50.CastTargetIf(v52.BarbedShot, v61, "min", v68, v72, not v13:IsSpellInRange(v52.BarbedShot))) then
						return "barbed_shot cleave 4";
					end
				end
				if ((v52.MultiShot:IsReady() and (v16:BuffRemains(v52.BeastCleavePetBuff) < ((653.5 - (232 + 421)) + v58)) and (not v52.BloodyFrenzy:IsAvailable() or v52.CalloftheWild:CooldownDown())) or ((6165 - (1569 + 320)) < (740 + 2276))) then
					if (((892 + 3798) > (13900 - 9775)) and v24(v52.MultiShot, nil, nil, not v13:IsSpellInRange(v52.MultiShot))) then
						return "multishot cleave 6";
					end
				end
				v104 = 606 - (316 + 289);
			end
			if (((5 - 3) == v104) or ((3 + 47) >= (2349 - (666 + 787)))) then
				if (v52.ExplosiveShot:IsReady() or ((2139 - (360 + 65)) >= (2765 + 193))) then
					if (v24(v52.ExplosiveShot, not v13:IsSpellInRange(v52.ExplosiveShot)) or ((1745 - (79 + 175)) < (1014 - 370))) then
						return "explosive_shot cleave 12";
					end
				end
				if (((550 + 154) < (3025 - 2038)) and v52.Stampede:IsCastable() and v28) then
					if (((7160 - 3442) > (2805 - (503 + 396))) and v24(v52.Stampede, not v13:IsSpellInRange(v52.Stampede))) then
						return "stampede cleave 14";
					end
				end
				if (v52.Bloodshed:IsCastable() or ((1139 - (92 + 89)) > (7051 - 3416))) then
					if (((1796 + 1705) <= (2659 + 1833)) and v24(v52.Bloodshed, not v13:IsSpellInRange(v52.Bloodshed))) then
						return "bloodshed cleave 16";
					end
				end
				v104 = 11 - 8;
			end
			if ((v104 == (1 + 6)) or ((7847 - 4405) < (2224 + 324))) then
				if (((1374 + 1501) >= (4458 - 2994)) and v52.KillShot:IsReady()) then
					if (v24(v52.KillShot, not v13:IsSpellInRange(v52.KillShot)) or ((599 + 4198) >= (7461 - 2568))) then
						return "kill_shot cleave 38";
					end
				end
				if ((v15:Exists() and v52.KillShot:IsCastable() and (v15:HealthPercentage() <= (1264 - (485 + 759)))) or ((1274 - 723) > (3257 - (442 + 747)))) then
					if (((3249 - (832 + 303)) > (1890 - (88 + 858))) and v24(v56.KillShotMouseover, not v15:IsSpellInRange(v52.KillShot))) then
						return "kill_shot_mouseover cleave 39";
					end
				end
				if ((v52.CobraShot:IsReady() and (v12:FocusTimeToMax() < (v58 * (1 + 1)))) or ((1873 + 389) >= (128 + 2968))) then
					if (v24(v56.CobraShotPetAttack, not v13:IsSpellInRange(v52.CobraShot)) or ((3044 - (766 + 23)) >= (17461 - 13924))) then
						return "cobra_shot cleave 42";
					end
				end
				v104 = 10 - 2;
			end
			if ((v104 == (13 - 8)) or ((13022 - 9185) < (2379 - (1036 + 37)))) then
				if (((2092 + 858) == (5744 - 2794)) and v52.DireBeast:IsCastable()) then
					if (v24(v52.DireBeast, not v13:IsSpellInRange(v52.DireBeast)) or ((3716 + 1007) < (4778 - (641 + 839)))) then
						return "dire_beast cleave 32";
					end
				end
				if (((2049 - (910 + 3)) >= (392 - 238)) and v52.SerpentSting:IsReady()) then
					if (v50.CastTargetIf(v52.SerpentSting, v61, "min", v70, v75, not v13:IsSpellInRange(v52.SerpentSting), nil, nil, v56.SerpentStingMouseover) or ((1955 - (1466 + 218)) > (2183 + 2565))) then
						return "serpent_sting cleave 34";
					end
				end
				if (((5888 - (556 + 592)) >= (1121 + 2031)) and v52.Barrage:IsReady() and (v16:BuffRemains(v52.FrenzyPetBuff) > v52.Barrage:ExecuteTime())) then
					if (v24(v52.Barrage, not v13:IsSpellInRange(v52.Barrage)) or ((3386 - (329 + 479)) >= (4244 - (174 + 680)))) then
						return "barrage cleave 36";
					end
				end
				v104 = 20 - 14;
			end
			if (((84 - 43) <= (1186 + 475)) and (v104 == (740 - (396 + 343)))) then
				if (((54 + 547) < (5037 - (29 + 1448))) and v52.BestialWrath:IsCastable() and v28) then
					if (((1624 - (135 + 1254)) < (2587 - 1900)) and v25(v52.BestialWrath)) then
						return "bestial_wrath cleave 8";
					end
				end
				if (((21239 - 16690) > (769 + 384)) and v52.CalloftheWild:IsCastable() and v28) then
					if (v24(v52.CalloftheWild) or ((6201 - (389 + 1138)) < (5246 - (102 + 472)))) then
						return "call_of_the_wild cleave 10";
					end
				end
				if (((3462 + 206) < (2530 + 2031)) and v52.KillCommand:IsReady() and (v52.KillCleave:IsAvailable())) then
					if (v24(v52.KillCommand, nil, nil, not v13:IsInRange(47 + 3)) or ((2000 - (320 + 1225)) == (6417 - 2812))) then
						return "kill_command cleave 12";
					end
				end
				v104 = 2 + 0;
			end
		end
	end
	local function v83()
		local v105 = 1464 - (157 + 1307);
		while true do
			if ((v105 == (1865 - (821 + 1038))) or ((6644 - 3981) == (363 + 2949))) then
				if (((7597 - 3320) <= (1665 + 2810)) and v52.AspectoftheWild:IsCastable() and v28) then
					if (v25(v52.AspectoftheWild) or ((2156 - 1286) == (2215 - (834 + 192)))) then
						return "aspect_of_the_wild st 32";
					end
				end
				if (((99 + 1454) <= (805 + 2328)) and v52.CobraShot:IsReady()) then
					if (v24(v56.CobraShotPetAttack, not v13:IsSpellInRange(v52.CobraShot)) or ((49 + 2188) >= (5438 - 1927))) then
						return "cobra_shot st 34";
					end
				end
				if ((v52.WailingArrow:IsReady() and ((v16:BuffRemains(v52.FrenzyPetBuff) > v52.WailingArrow:ExecuteTime()) or (v60 < (309 - (300 + 4))))) or ((354 + 970) > (7905 - 4885))) then
					if (v24(v52.WailingArrow, not v13:IsSpellInRange(v52.WailingArrow), true) or ((3354 - (112 + 250)) == (750 + 1131))) then
						return "wailing_arrow st 36";
					end
				end
				v105 = 17 - 10;
			end
			if (((1780 + 1326) > (790 + 736)) and (v105 == (3 + 1))) then
				if (((1499 + 1524) < (2875 + 995)) and v52.BarbedShot:IsCastable()) then
					if (((1557 - (1001 + 413)) > (164 - 90)) and v50.CastTargetIf(v56.BarbedShotPetAttack, v61, "min", v68, v77, not v13:IsSpellInRange(v52.BarbedShot), nil, nil, v56.BarbedShotMouseover)) then
						return "barbed_shot st 24";
					end
				end
				if (((900 - (244 + 638)) < (2805 - (627 + 66))) and v52.BarbedShot:IsCastable() and v77(v13)) then
					if (((3268 - 2171) <= (2230 - (512 + 90))) and v24(v56.BarbedShotPetAttack, not v13:IsSpellInRange(v52.BarbedShot))) then
						return "barbed_shot st mt_backup 25";
					end
				end
				if (((6536 - (1665 + 241)) == (5347 - (373 + 344))) and v52.DireBeast:IsCastable()) then
					if (((1597 + 1943) > (710 + 1973)) and v24(v52.DireBeast, not v13:IsSpellInRange(v52.DireBeast))) then
						return "dire_beast st 26";
					end
				end
				v105 = 13 - 8;
			end
			if (((8112 - 3318) >= (4374 - (35 + 1064))) and (v105 == (6 + 1))) then
				if (((3174 - 1690) == (6 + 1478)) and v28) then
					if (((2668 - (298 + 938)) < (4814 - (233 + 1026))) and v52.BagofTricks:IsCastable() and (v12:BuffDown(v52.BestialWrathBuff) or (v60 < (1671 - (636 + 1030))))) then
						if (v25(v52.BagofTricks) or ((545 + 520) > (3495 + 83))) then
							return "bag_of_tricks st 38";
						end
					end
					if ((v52.ArcanePulse:IsCastable() and (v12:BuffDown(v52.BestialWrathBuff) or (v60 < (2 + 3)))) or ((324 + 4471) < (1628 - (55 + 166)))) then
						if (((360 + 1493) < (484 + 4329)) and v25(v52.ArcanePulse)) then
							return "arcane_pulse st 40";
						end
					end
					if ((v52.ArcaneTorrent:IsCastable() and ((v12:Focus() + v12:FocusRegen() + (57 - 42)) < v12:FocusMax())) or ((3118 - (36 + 261)) < (4251 - 1820))) then
						if (v25(v52.ArcaneTorrent) or ((4242 - (34 + 1334)) < (839 + 1342))) then
							return "arcane_torrent st 42";
						end
					end
				end
				break;
			end
			if ((v105 == (0 + 0)) or ((3972 - (1035 + 248)) <= (364 - (20 + 1)))) then
				if (v52.BarbedShot:IsCastable() or ((974 + 895) == (2328 - (134 + 185)))) then
					if (v50.CastTargetIf(v56.BarbedShotPetAttack, v61, "min", v68, v76, not v13:IsSpellInRange(v52.BarbedShot), nil, nil, v56.BarbedShotMouseover) or ((4679 - (549 + 584)) < (3007 - (314 + 371)))) then
						return "barbed_shot st 2";
					end
				end
				if ((v52.BarbedShot:IsCastable() and v76(v13)) or ((7147 - 5065) == (5741 - (478 + 490)))) then
					if (((1719 + 1525) > (2227 - (786 + 386))) and v24(v56.BarbedShotPetAttack, not v13:IsSpellInRange(v52.BarbedShot))) then
						return "barbed_shot st mt_backup 3";
					end
				end
				if ((v52.CalloftheWild:IsCastable() and v28) or ((10730 - 7417) <= (3157 - (1055 + 324)))) then
					if (v25(v52.CalloftheWild) or ((2761 - (1093 + 247)) >= (1870 + 234))) then
						return "call_of_the_wild st 6";
					end
				end
				v105 = 1 + 0;
			end
			if (((7193 - 5381) <= (11026 - 7777)) and (v105 == (14 - 9))) then
				if (((4078 - 2455) <= (697 + 1260)) and v52.SerpentSting:IsReady()) then
					if (((16996 - 12584) == (15207 - 10795)) and v50.CastTargetIf(v52.SerpentSting, v61, "min", v70, v78, not v13:IsSpellInRange(v52.SerpentSting), nil, nil, v56.SerpentStingMouseover)) then
						return "serpent_sting st 28";
					end
				end
				if (((1320 + 430) >= (2153 - 1311)) and v52.KillShot:IsReady()) then
					if (((5060 - (364 + 324)) > (5071 - 3221)) and v24(v52.KillShot, not v13:IsSpellInRange(v52.KillShot))) then
						return "kill_shot st 30";
					end
				end
				if (((556 - 324) < (273 + 548)) and v15:Exists() and v52.KillShot:IsCastable() and (v15:HealthPercentage() <= (83 - 63))) then
					if (((829 - 311) < (2739 - 1837)) and v24(v56.KillShotMouseover, not v15:IsSpellInRange(v52.KillShot))) then
						return "kill_shot_mouseover st 31";
					end
				end
				v105 = 1274 - (1249 + 19);
			end
			if (((2703 + 291) > (3339 - 2481)) and (v105 == (1089 - (686 + 400)))) then
				if ((v52.AMurderofCrows:IsCastable() and v28) or ((2947 + 808) <= (1144 - (73 + 156)))) then
					if (((19 + 3927) > (4554 - (721 + 90))) and v24(v52.AMurderofCrows, not v13:IsSpellInRange(v52.AMurderofCrows))) then
						return "a_murder_of_crows st 14";
					end
				end
				if ((v52.SteelTrap:IsCastable() and v42) or ((16 + 1319) >= (10734 - 7428))) then
					if (((5314 - (224 + 246)) > (3649 - 1396)) and v25(v52.SteelTrap)) then
						return "steel_trap st 16";
					end
				end
				if (((831 - 379) == (82 + 370)) and v52.ExplosiveShot:IsReady()) then
					if (v24(v52.ExplosiveShot, not v13:IsSpellInRange(v52.ExplosiveShot)) or ((109 + 4448) < (1533 + 554))) then
						return "explosive_shot st 18";
					end
				end
				v105 = 7 - 3;
			end
			if (((12891 - 9017) == (4387 - (203 + 310))) and (v105 == (1994 - (1238 + 755)))) then
				if ((v52.KillCommand:IsReady() and (v52.KillCommand:FullRechargeTime() < v58) and v52.AlphaPredator:IsAvailable()) or ((136 + 1802) > (6469 - (709 + 825)))) then
					if (v24(v56.KillCommandPetAttack, not v13:IsSpellInRange(v52.KillCommand)) or ((7840 - 3585) < (4985 - 1562))) then
						return "kill_command st 4";
					end
				end
				if (((2318 - (196 + 668)) <= (9835 - 7344)) and v52.Stampede:IsCastable() and v28) then
					if (v24(v52.Stampede, nil, nil, not v13:IsSpellInRange(v52.Stampede)) or ((8610 - 4453) <= (3636 - (171 + 662)))) then
						return "stampede st 8";
					end
				end
				if (((4946 - (4 + 89)) >= (10451 - 7469)) and v52.Bloodshed:IsCastable()) then
					if (((1506 + 2628) > (14744 - 11387)) and v24(v52.Bloodshed, not v13:IsSpellInRange(v52.Bloodshed))) then
						return "bloodshed st 10";
					end
				end
				v105 = 1 + 1;
			end
			if ((v105 == (1488 - (35 + 1451))) or ((4870 - (28 + 1425)) < (4527 - (941 + 1052)))) then
				if ((v52.BestialWrath:IsCastable() and v28) or ((2611 + 111) <= (1678 - (822 + 692)))) then
					if (v25(v52.BestialWrath) or ((3437 - 1029) < (994 + 1115))) then
						return "bestial_wrath st 12";
					end
				end
				if ((v52.DeathChakram:IsCastable() and v28) or ((330 - (45 + 252)) == (1440 + 15))) then
					if (v24(v52.DeathChakram, nil, nil, not v13:IsSpellInRange(v52.DeathChakram)) or ((153 + 290) >= (9771 - 5756))) then
						return "death_chakram st 14";
					end
				end
				if (((3815 - (114 + 319)) > (237 - 71)) and v52.KillCommand:IsReady()) then
					if (v24(v56.KillCommandPetAttack, not v13:IsSpellInRange(v52.KillCommand)) or ((358 - 78) == (1951 + 1108))) then
						return "kill_command st 22";
					end
				end
				v105 = 4 - 1;
			end
		end
	end
	local function v84()
		if (((3941 - 2060) > (3256 - (556 + 1407))) and not v12:IsCasting() and not v12:IsChanneling()) then
			local v113 = v50.Interrupt(v52.CounterShot, 1246 - (741 + 465), true);
			if (((2822 - (170 + 295)) == (1242 + 1115)) and v113) then
				return v113;
			end
			v113 = v50.InterruptWithStun(v52.Intimidation, 37 + 3);
			if (((302 - 179) == (102 + 21)) and v113) then
				return v113;
			end
		end
	end
	local function v85()
		v49();
		v26 = EpicSettings.Toggles['ooc'];
		v27 = EpicSettings.Toggles['aoe'];
		v28 = EpicSettings.Toggles['cds'];
		if (v52.Stomp:IsAvailable() or ((678 + 378) >= (1921 + 1471))) then
			v9.SplashEnemies.ChangeFriendTargetsTracking("Mine Only");
		else
			v9.SplashEnemies.ChangeFriendTargetsTracking("All");
		end
		local v109 = (v52.BloodBolt:IsPetKnown() and v19.FindBySpellID(v52.BloodBolt:ID()) and v52.BloodBolt) or (v52.Bite:IsPetKnown() and v19.FindBySpellID(v52.Bite:ID()) and v52.Bite) or (v52.Claw:IsPetKnown() and v19.FindBySpellID(v52.Claw:ID()) and v52.Claw) or (v52.Smack:IsPetKnown() and v19.FindBySpellID(v52.Smack:ID()) and v52.Smack) or nil;
		local v110 = (v52.Growl:IsPetKnown() and v19.FindBySpellID(v52.Growl:ID()) and v52.Growl) or nil;
		if (v27 or ((2311 - (957 + 273)) < (288 + 787))) then
			v61 = v12:GetEnemiesInRange(17 + 23);
			v62 = (v109 and v12:GetEnemiesInSpellActionRange(v109)) or v13:GetEnemiesInSplashRange(30 - 22);
			v63 = (v109 and #v62) or v13:GetEnemiesInSplashRangeCount(21 - 13);
		else
			v61 = {};
			v62 = v13 or {};
			v63 = 0 - 0;
		end
		v64 = v13:IsInRange(198 - 158);
		v65 = v13:IsInRange(1810 - (389 + 1391));
		v66 = (v110 and v13:IsSpellInActionRange(v110)) or v13:IsInRange(19 + 11);
		v58 = v12:GCD() + 0.15 + 0;
		if (v50.TargetIsValid() or v12:AffectingCombat() or ((2387 - 1338) >= (5383 - (783 + 168)))) then
			v59 = v9.BossFightRemains();
			v60 = v59;
			if ((v60 == (37290 - 26179)) or ((4690 + 78) <= (1157 - (309 + 2)))) then
				v60 = v9.FightRemains(v61, false);
			end
		end
		if ((v52.Exhilaration:IsCastable() and v46 and (v12:HealthPercentage() <= v47)) or ((10312 - 6954) <= (2632 - (1090 + 122)))) then
			if (v24(v52.Exhilaration) or ((1213 + 2526) <= (10092 - 7087))) then
				return "Exhilaration";
			end
		end
		if (((v12:HealthPercentage() <= v36) and v35 and v54.Healthstone:IsReady()) or ((1136 + 523) >= (3252 - (628 + 490)))) then
			if (v25(v56.Healthstone, nil, nil, true) or ((585 + 2675) < (5830 - 3475))) then
				return "healthstone defensive 3";
			end
		end
		if ((v32 and (v12:HealthPercentage() <= v34)) or ((3057 - 2388) == (4997 - (431 + 343)))) then
			if ((v33 == "Refreshing Healing Potion") or ((3416 - 1724) < (1700 - 1112))) then
				if (v54.RefreshingHealingPotion:IsReady() or ((3790 + 1007) < (467 + 3184))) then
					if (v25(v56.RefreshingHealingPotion) or ((5872 - (556 + 1139)) > (4865 - (6 + 9)))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if ((v33 == "Dreamwalker's Healing Potion") or ((74 + 326) > (570 + 541))) then
				if (((3220 - (28 + 141)) > (390 + 615)) and v54.DreamwalkersHealingPotion:IsReady()) then
					if (((4557 - 864) <= (3104 + 1278)) and v25(v56.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
		if (not (v12:IsMounted() or v12:IsInVehicle()) or ((4599 - (486 + 831)) > (10669 - 6569))) then
			if ((v52.SummonPet:IsCastable() and v40) or ((12603 - 9023) < (538 + 2306))) then
				if (((281 - 192) < (5753 - (668 + 595))) and v25(v53[v41])) then
					return "Summon Pet";
				end
			end
			if ((v52.RevivePet:IsCastable() and v43 and v16:IsDeadOrGhost()) or ((4484 + 499) < (365 + 1443))) then
				if (((10441 - 6612) > (4059 - (23 + 267))) and v25(v52.RevivePet)) then
					return "Revive Pet";
				end
			end
			if (((3429 - (1129 + 815)) <= (3291 - (371 + 16))) and v52.MendPet:IsCastable() and v44 and (v16:HealthPercentage() < v45)) then
				if (((6019 - (1326 + 424)) == (8084 - 3815)) and v25(v52.MendPet)) then
					return "Mend Pet High Priority";
				end
			end
		end
		if (((1414 - 1027) <= (2900 - (88 + 30))) and v50.TargetIsValid()) then
			local v114 = 771 - (720 + 51);
			local v115;
			local v116;
			while true do
				if ((v114 == (8 - 4)) or ((3675 - (421 + 1355)) <= (1512 - 595))) then
					if ((v63 < (1 + 1)) or (not v52.BeastCleave:IsAvailable() and (v63 < (1086 - (286 + 797)))) or ((15763 - 11451) <= (1450 - 574))) then
						local v126 = 439 - (397 + 42);
						local v127;
						while true do
							if (((698 + 1534) <= (3396 - (24 + 776))) and (v126 == (0 - 0))) then
								v127 = v83();
								if (((2880 - (222 + 563)) < (8121 - 4435)) and v127) then
									return v127;
								end
								break;
							end
						end
					end
					if ((not (v12:IsMounted() or v12:IsInVehicle()) and not v16:IsDeadOrGhost() and v52.MendPet:IsCastable() and (v16:HealthPercentage() < v45) and v44) or ((1149 + 446) >= (4664 - (23 + 167)))) then
						if (v25(v52.MendPet) or ((6417 - (690 + 1108)) < (1040 + 1842))) then
							return "Mend Pet Low Priority (w/ Target)";
						end
					end
					break;
				end
				if ((v114 == (2 + 0)) or ((1142 - (40 + 808)) >= (796 + 4035))) then
					if (((7758 - 5729) <= (2948 + 136)) and v28) then
						local v128 = 0 + 0;
						local v129;
						while true do
							if (((0 + 0) == v128) or ((2608 - (47 + 524)) == (1571 + 849))) then
								v129 = v80();
								if (((12186 - 7728) > (5837 - 1933)) and v129) then
									return v129;
								end
								break;
							end
						end
					end
					v116 = v81();
					v114 = 6 - 3;
				end
				if (((2162 - (1165 + 561)) >= (4 + 119)) and (v114 == (9 - 6))) then
					if (((191 + 309) < (2295 - (341 + 138))) and v116) then
						return v116;
					end
					if (((965 + 2609) == (7375 - 3801)) and ((v63 > (328 - (89 + 237))) or (v52.BeastCleave:IsAvailable() and (v63 > (3 - 2))))) then
						local v130 = v82();
						if (((465 - 244) < (1271 - (581 + 300))) and v130) then
							return v130;
						end
					end
					v114 = 1224 - (855 + 365);
				end
				if ((v114 == (0 - 0)) or ((723 + 1490) <= (2656 - (1030 + 205)))) then
					if (((2871 + 187) < (4522 + 338)) and not v12:AffectingCombat() and not v26) then
						local v131 = v79();
						if (v131 or ((1582 - (156 + 130)) >= (10102 - 5656))) then
							return v131;
						end
					end
					if ((not v12:IsCasting() and not v12:IsChanneling()) or ((2347 - 954) > (9193 - 4704))) then
						local v132 = v50.Interrupt(v52.CounterShot, 11 + 29, true);
						if (v132 or ((2580 + 1844) < (96 - (10 + 59)))) then
							return v132;
						end
						v132 = v50.Interrupt(v52.CounterShot, 12 + 28, true, v15, v56.CounterShotMouseover);
						if (v132 or ((9834 - 7837) > (4978 - (671 + 492)))) then
							return v132;
						end
						v132 = v50.InterruptWithStun(v52.Intimidation, 32 + 8, true);
						if (((4680 - (369 + 846)) > (507 + 1406)) and v132) then
							return v132;
						end
						v132 = v50.InterruptWithStun(v52.Intimidation, 35 + 5, true, v15, v56.IntimidationMouseover);
						if (((2678 - (1036 + 909)) < (1447 + 372)) and v132) then
							return v132;
						end
					end
					v114 = 1 - 0;
				end
				if ((v114 == (204 - (11 + 192))) or ((2222 + 2173) == (4930 - (135 + 40)))) then
					v115 = v50.HandleDPSPotion();
					if (v115 or ((9189 - 5396) < (1428 + 941))) then
						return v115;
					end
					v114 = 4 - 2;
				end
			end
		end
		if ((not (v12:IsMounted() or v12:IsInVehicle()) and not v16:IsDeadOrGhost() and v52.MendPet:IsCastable() and (v16:HealthPercentage() < v45) and v44) or ((6121 - 2037) == (441 - (50 + 126)))) then
			if (((12134 - 7776) == (965 + 3393)) and v25(v52.MendPet)) then
				return "Mend Pet Low Priority (w/o Target)";
			end
		end
	end
	local function v86()
		local v111 = 1413 - (1233 + 180);
		local v112;
		while true do
			if ((v111 == (970 - (522 + 447))) or ((4559 - (107 + 1314)) < (461 + 532))) then
				if (((10146 - 6816) > (987 + 1336)) and not v112) then
					v9.Print("|cffffff00Info|r: Add pet abilities to your action bars to improve range checks.");
				end
				break;
			end
			if ((v111 == (0 - 0)) or ((14346 - 10720) == (5899 - (716 + 1194)))) then
				v9.Print("Beast Mastery by Epic. Supported by Gojira");
				v112 = (v52.Growl:IsPetKnown() and v19.FindBySpellID(v52.Growl:ID()) and v52.Growl) or nil;
				v111 = 1 + 0;
			end
		end
	end
	v9.SetAPL(28 + 225, v85, v86);
end;
return v0["Epix_Hunter_BeastMastery.lua"]();

