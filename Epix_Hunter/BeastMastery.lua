local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((1964 + 2549) >= (2651 + 75)) and (v5 == (3 - 2))) then
			return v6(...);
		end
		if ((v5 == (1726 - (1668 + 58))) or ((2107 - (512 + 114)) >= (6929 - 4271))) then
			v6 = v0[v4];
			if (not v6 or ((6656 - 3436) == (4746 - 3382))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
			if ((v88 == (4 + 0)) or ((3554 - 2500) > (5386 - (109 + 1885)))) then
				v48 = EpicSettings.Settings['ExhilarationHP'] or (1469 - (1269 + 200));
				v49 = EpicSettings.Settings['UseTranq'];
				break;
			end
			if ((v88 == (5 - 2)) or ((1491 - (98 + 717)) >= (2468 - (802 + 24)))) then
				v44 = EpicSettings.Settings['UseRevive'];
				v45 = EpicSettings.Settings['UseMendPet'];
				v46 = EpicSettings.Settings['MendPetHP'] or (0 - 0);
				v47 = EpicSettings.Settings['UseExhilaration'];
				v88 = 4 - 0;
			end
			if (((611 + 3525) > (1842 + 555)) and (v88 == (0 + 0))) then
				v31 = EpicSettings.Settings['UseRacials'];
				v33 = EpicSettings.Settings['UseHealingPotion'];
				v34 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v35 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v88 = 3 - 2;
			end
			if (((1 + 1) == v88) or ((1765 + 2569) == (3502 + 743))) then
				v40 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v41 = EpicSettings.Settings['UsePet'];
				v42 = EpicSettings.Settings['SummonPetSlot'] or (0 + 0);
				v43 = EpicSettings.Settings['UseSteelTrap'];
				v88 = 1436 - (797 + 636);
			end
			if ((v88 == (4 - 3)) or ((5895 - (1427 + 192)) <= (1051 + 1980))) then
				v36 = EpicSettings.Settings['UseHealthstone'];
				v37 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v38 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v39 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v88 = 328 - (192 + 134);
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
	local v60 = 11662 - (83 + 468);
	local v61 = 12917 - (1202 + 604);
	v10:RegisterForEvent(function()
		v60 = 51868 - 40757;
		v61 = 18492 - 7381;
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
		return (v92:DebuffStack(v53.LatentPoisonDebuff) > (4 + 5)) and ((v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + 0.25 + 0))) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < (3 + 9 + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < (5 - 2)) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp())) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown()));
	end
	local function v73(v93)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + (1911.25 - (340 + 1571))))) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < (5 + 7 + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < (1775 - (1733 + 39))) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp())) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown());
	end
	local function v74(v94)
		return (v94:DebuffStack(v53.LatentPoisonDebuff) > (24 - 15)) and (v13:BuffUp(v53.CalloftheWildBuff) or (v61 < (1043 - (125 + 909))) or (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1949.2 - (1096 + 852)))) or v53.Savagery:IsAvailable());
	end
	local function v75(v95)
		return v13:BuffUp(v53.CalloftheWildBuff) or (v61 < (5 + 4)) or (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (1.2 - 0))) or v53.Savagery:IsAvailable();
	end
	local function v76(v96)
		return v96:DebuffRefreshable(v53.SerpentStingDebuff) and (v96:TimeToDie() > v53.SerpentStingDebuff:BaseDuration());
	end
	local function v77(v97)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + 0.25 + 0))) or (v53.ScentofBlood:IsAvailable() and (v17:BuffStack(v53.FrenzyPetBuff) < (515 - (409 + 103))) and (v53.BestialWrath:CooldownUp() or v53.CalloftheWild:CooldownUp()));
	end
	local function v78(v98)
		return (v53.WildCall:IsAvailable() and (v53.BarbedShot:ChargesFractional() > (237.4 - (46 + 190)))) or v13:BuffUp(v53.CalloftheWildBuff) or ((v53.BarbedShot:FullRechargeTime() < v59) and v53.BestialWrath:CooldownDown()) or (v53.ScentofBlood:IsAvailable() and (v53.BestialWrath:CooldownRemains() < ((107 - (51 + 44)) + v59))) or v53.Savagery:IsAvailable() or (v61 < (3 + 6));
	end
	local function v79(v99)
		return v99:DebuffRefreshable(v53.SerpentStingDebuff) and (v14:TimeToDie() > v53.SerpentStingDebuff:BaseDuration());
	end
	local function v80()
		local v100 = 1317 - (1114 + 203);
		while true do
			if ((v100 == (728 - (228 + 498))) or ((1037 + 3745) <= (663 + 536))) then
				if ((v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (683 - (174 + 489)))) or ((12672 - 7808) < (3807 - (830 + 1075)))) then
					if (((5363 - (303 + 221)) >= (4969 - (231 + 1038))) and v25(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot))) then
						return "kill_shot_mouseover precombat 11";
					end
				end
				if (v53.KillCommand:IsReady() or ((896 + 179) > (3080 - (171 + 991)))) then
					if (((1631 - 1235) <= (10214 - 6410)) and v26(v57.KillCommandPetAttack)) then
						return "kill_command precombat 12";
					end
				end
				v100 = 7 - 4;
			end
			if ((v100 == (0 + 0)) or ((14613 - 10444) == (6308 - 4121))) then
				if (((2266 - 860) == (4346 - 2940)) and v15:Exists() and v53.Misdirection:IsReady()) then
					if (((2779 - (111 + 1137)) < (4429 - (91 + 67))) and v26(v57.MisdirectionFocus)) then
						return "misdirection precombat 0";
					end
				end
				if (((1889 - 1254) == (159 + 476)) and v53.SteelTrap:IsCastable() and not v53.WailingArrow:IsAvailable() and v53.SteelTrap:IsAvailable()) then
					if (((3896 - (423 + 100)) <= (25 + 3531)) and v26(v53.SteelTrap)) then
						return "steel_trap precombat 2";
					end
				end
				v100 = 2 - 1;
			end
			if ((v100 == (1 + 0)) or ((4062 - (326 + 445)) < (14313 - 11033))) then
				if (((9770 - 5384) >= (2037 - 1164)) and v53.BarbedShot:IsCastable() and (v53.BarbedShot:Charges() >= (713 - (530 + 181)))) then
					if (((1802 - (614 + 267)) <= (1134 - (19 + 13))) and v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot))) then
						return "barbed_shot precombat 8";
					end
				end
				if (((7658 - 2952) >= (2243 - 1280)) and v53.KillShot:IsReady()) then
					if (v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot)) or ((2742 - 1782) <= (228 + 648))) then
						return "kill_shot precombat 10";
					end
				end
				v100 = 3 - 1;
			end
			if ((v100 == (6 - 3)) or ((3878 - (1293 + 519)) == (1900 - 968))) then
				if (((12597 - 7772) < (9261 - 4418)) and (v64 > (4 - 3))) then
					if (v53.MultiShot:IsReady() or ((9133 - 5256) >= (2403 + 2134))) then
						if (v25(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot)) or ((881 + 3434) < (4009 - 2283))) then
							return "multishot precombat 14";
						end
					end
				elseif (v53.CobraShot:IsReady() or ((851 + 2828) < (208 + 417))) then
					if (v25(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot)) or ((2891 + 1734) < (1728 - (709 + 387)))) then
						return "cobra_shot precombat 16";
					end
				end
				break;
			end
		end
	end
	local function v81()
		local v101 = 1858 - (673 + 1185);
		while true do
			if ((v101 == (2 - 1)) or ((266 - 183) > (2928 - 1148))) then
				if (((391 + 155) <= (805 + 272)) and v53.AncestralCall:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (20 - 4)))) then
					if (v26(v53.AncestralCall) or ((245 + 751) > (8575 - 4274))) then
						return "ancestral_call cds 10";
					end
				end
				if (((7989 - 3919) > (2567 - (446 + 1434))) and v53.Fireblood:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (1292 - (1040 + 243))))) then
					if (v26(v53.Fireblood) or ((1957 - 1301) >= (5177 - (559 + 1288)))) then
						return "fireblood cds 12";
					end
				end
				break;
			end
			if (((1931 - (609 + 1322)) == v101) or ((2946 - (13 + 441)) <= (1251 - 916))) then
				if (((11320 - 6998) >= (12759 - 10197)) and v53.Berserking:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (1 + 12)))) then
					if (v26(v53.Berserking) or ((13208 - 9571) >= (1340 + 2430))) then
						return "berserking cds 2";
					end
				end
				if ((v53.BloodFury:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53.CalloftheWild:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < (8 + 8)))) or ((7059 - 4680) > (2506 + 2072))) then
					if (v26(v53.BloodFury) or ((887 - 404) > (492 + 251))) then
						return "blood_fury cds 8";
					end
				end
				v101 = 1 + 0;
			end
		end
	end
	local function v82()
		local v102 = 0 + 0;
		local v103;
		while true do
			if (((2061 + 393) > (566 + 12)) and (v102 == (433 - (153 + 280)))) then
				v103 = v51.HandleTopTrinket(v56, v29, 115 - 75, nil);
				if (((835 + 95) < (1761 + 2697)) and v103) then
					return v103;
				end
				v102 = 1 + 0;
			end
			if (((601 + 61) <= (705 + 267)) and (v102 == (1 - 0))) then
				v103 = v51.HandleBottomTrinket(v56, v29, 25 + 15, nil);
				if (((5037 - (89 + 578)) == (3122 + 1248)) and v103) then
					return v103;
				end
				break;
			end
		end
	end
	local function v83()
		local v104 = 0 - 0;
		while true do
			if ((v104 == (1052 - (572 + 477))) or ((643 + 4119) <= (517 + 344))) then
				if ((v53.DeathChakram:IsCastable() and v29) or ((169 + 1243) == (4350 - (84 + 2)))) then
					if (v25(v53.DeathChakram, not v14:IsSpellInRange(v53.DeathChakram)) or ((5220 - 2052) < (1552 + 601))) then
						return "death_chakram cleave 18";
					end
				end
				if (v53.SteelTrap:IsCastable() or ((5818 - (497 + 345)) < (35 + 1297))) then
					if (((783 + 3845) == (5961 - (605 + 728))) and v26(v57.SteelTrap)) then
						return "steel_trap cleave 22";
					end
				end
				if ((v53.AMurderofCrows:IsReady() and v29) or ((39 + 15) == (878 - 483))) then
					if (((4 + 78) == (303 - 221)) and v25(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows))) then
						return "a_murder_of_crows cleave 24";
					end
				end
				v104 = 4 + 0;
			end
			if ((v104 == (19 - 12)) or ((439 + 142) < (771 - (457 + 32)))) then
				if (v53.KillShot:IsReady() or ((1956 + 2653) < (3897 - (832 + 570)))) then
					if (((1086 + 66) == (301 + 851)) and v25(v53.KillShot, not v14:IsSpellInRange(v53.KillShot))) then
						return "kill_shot cleave 38";
					end
				end
				if (((6709 - 4813) <= (1649 + 1773)) and v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (816 - (588 + 208)))) then
					if (v25(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot)) or ((2668 - 1678) > (3420 - (884 + 916)))) then
						return "kill_shot_mouseover cleave 39";
					end
				end
				if ((v53.CobraShot:IsReady() and (v13:FocusTimeToMax() < (v59 * (3 - 1)))) or ((509 + 368) > (5348 - (232 + 421)))) then
					if (((4580 - (1569 + 320)) >= (455 + 1396)) and v25(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot))) then
						return "cobra_shot cleave 42";
					end
				end
				v104 = 2 + 6;
			end
			if ((v104 == (16 - 11)) or ((3590 - (316 + 289)) >= (12711 - 7855))) then
				if (((198 + 4078) >= (2648 - (666 + 787))) and v53.DireBeast:IsCastable()) then
					if (((3657 - (360 + 65)) <= (4384 + 306)) and v25(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast))) then
						return "dire_beast cleave 32";
					end
				end
				if (v53.SerpentSting:IsReady() or ((1150 - (79 + 175)) >= (4960 - 1814))) then
					if (((2389 + 672) >= (9066 - 6108)) and v51.CastTargetIf(v53.SerpentSting, v62, "min", v71, v76, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover)) then
						return "serpent_sting cleave 34";
					end
				end
				if (((6137 - 2950) >= (1543 - (503 + 396))) and v53.Barrage:IsReady() and (v17:BuffRemains(v53.FrenzyPetBuff) > v53.Barrage:ExecuteTime())) then
					if (((825 - (92 + 89)) <= (1365 - 661)) and v25(v53.Barrage, not v14:IsSpellInRange(v53.Barrage))) then
						return "barrage cleave 36";
					end
				end
				v104 = 4 + 2;
			end
			if (((567 + 391) > (3708 - 2761)) and (v104 == (1 + 3))) then
				if (((10242 - 5750) >= (2316 + 338)) and v53.BarbedShot:IsCastable()) then
					if (((1645 + 1797) >= (4577 - 3074)) and v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "max", v70, v74, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
						return "barbed_shot cleave 26";
					end
				end
				if (v53.BarbedShot:IsCastable() or ((396 + 2774) <= (2232 - 768))) then
					if (v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v75, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover) or ((6041 - (485 + 759)) == (10153 - 5765))) then
						return "barbed_shot cleave 28";
					end
				end
				if (((1740 - (442 + 747)) <= (1816 - (832 + 303))) and v53.KillCommand:IsReady()) then
					if (((4223 - (88 + 858)) > (125 + 282)) and v25(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand))) then
						return "kill_command cleave 30";
					end
				end
				v104 = 5 + 0;
			end
			if (((194 + 4501) >= (2204 - (766 + 23))) and ((0 - 0) == v104)) then
				if (v53.BarbedShot:IsCastable() or ((4392 - 1180) <= (2486 - 1542))) then
					if (v51.CastTargetIf(v53.BarbedShot, v62, "max", v70, v72, not v14:IsSpellInRange(v53.BarbedShot)) or ((10507 - 7411) <= (2871 - (1036 + 37)))) then
						return "barbed_shot cleave 2";
					end
				end
				if (((2508 + 1029) == (6887 - 3350)) and v53.BarbedShot:IsCastable()) then
					if (((3019 + 818) >= (3050 - (641 + 839))) and v51.CastTargetIf(v53.BarbedShot, v62, "min", v69, v73, not v14:IsSpellInRange(v53.BarbedShot))) then
						return "barbed_shot cleave 4";
					end
				end
				if ((v53.MultiShot:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < ((913.5 - (910 + 3)) + v59)) and (not v53.BloodyFrenzy:IsAvailable() or v53.CalloftheWild:CooldownDown())) or ((7520 - 4570) == (5496 - (1466 + 218)))) then
					if (((2171 + 2552) >= (3466 - (556 + 592))) and v25(v53.MultiShot, nil, nil, not v14:IsSpellInRange(v53.MultiShot))) then
						return "multishot cleave 6";
					end
				end
				v104 = 1 + 0;
			end
			if ((v104 == (814 - (329 + 479))) or ((2881 - (174 + 680)) > (9799 - 6947))) then
				if ((v53.MultiShot:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < (v13:GCD() * (5 - 2)))) or ((812 + 324) > (5056 - (396 + 343)))) then
					if (((421 + 4327) == (6225 - (29 + 1448))) and v25(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot))) then
						return "multishot cleave 38";
					end
				end
				if (((5125 - (135 + 1254)) <= (17856 - 13116)) and v53.AspectoftheWild:IsCastable() and v29) then
					if (v26(v53.AspectoftheWild) or ((15828 - 12438) <= (2040 + 1020))) then
						return "aspect_of_the_wild cleave 40";
					end
				end
				if ((v29 and v53.LightsJudgment:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v14:TimeToDie() < (1532 - (389 + 1138))))) or ((1573 - (102 + 472)) > (2542 + 151))) then
					if (((257 + 206) < (561 + 40)) and v25(v53.LightsJudgment, nil, not v14:IsInRange(1550 - (320 + 1225)))) then
						return "lights_judgment cleave 40";
					end
				end
				v104 = 11 - 4;
			end
			if ((v104 == (5 + 3)) or ((3647 - (157 + 1307)) < (2546 - (821 + 1038)))) then
				if (((11349 - 6800) == (498 + 4051)) and v53.WailingArrow:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53.WailingArrow:ExecuteTime()) or (v61 < (8 - 3)))) then
					if (((1739 + 2933) == (11579 - 6907)) and v25(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow))) then
						return "wailing_arrow cleave 44";
					end
				end
				if ((v53.BagofTricks:IsCastable() and v29 and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (1031 - (834 + 192))))) or ((234 + 3434) < (102 + 293))) then
					if (v26(v53.BagofTricks) or ((90 + 4076) == (704 - 249))) then
						return "bag_of_tricks cleave 46";
					end
				end
				if ((v53.ArcaneTorrent:IsCastable() and v29 and ((v13:Focus() + v13:FocusRegen() + (334 - (300 + 4))) < v13:FocusMax())) or ((1189 + 3260) == (6971 - 4308))) then
					if (v26(v53.ArcaneTorrent) or ((4639 - (112 + 250)) < (1192 + 1797))) then
						return "arcane_torrent cleave 48";
					end
				end
				break;
			end
			if ((v104 == (4 - 2)) or ((499 + 371) >= (2146 + 2003))) then
				if (((1655 + 557) < (1579 + 1604)) and v53.ExplosiveShot:IsReady()) then
					if (((3452 + 1194) > (4406 - (1001 + 413))) and v25(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot))) then
						return "explosive_shot cleave 12";
					end
				end
				if (((3197 - 1763) < (3988 - (244 + 638))) and v53.Stampede:IsCastable() and v29) then
					if (((1479 - (627 + 66)) < (9007 - 5984)) and v25(v53.Stampede, not v14:IsSpellInRange(v53.Stampede))) then
						return "stampede cleave 14";
					end
				end
				if (v53.Bloodshed:IsCastable() or ((3044 - (512 + 90)) < (1980 - (1665 + 241)))) then
					if (((5252 - (373 + 344)) == (2046 + 2489)) and v25(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed))) then
						return "bloodshed cleave 16";
					end
				end
				v104 = 1 + 2;
			end
			if ((v104 == (2 - 1)) or ((5091 - 2082) <= (3204 - (35 + 1064)))) then
				if (((1332 + 498) < (7849 - 4180)) and v53.BestialWrath:IsCastable() and v29) then
					if (v26(v53.BestialWrath) or ((6 + 1424) >= (4848 - (298 + 938)))) then
						return "bestial_wrath cleave 8";
					end
				end
				if (((3942 - (233 + 1026)) >= (4126 - (636 + 1030))) and v53.CalloftheWild:IsCastable() and v29) then
					if (v25(v53.CalloftheWild) or ((923 + 881) >= (3199 + 76))) then
						return "call_of_the_wild cleave 10";
					end
				end
				if ((v53.KillCommand:IsReady() and (v53.KillCleave:IsAvailable())) or ((421 + 996) > (246 + 3383))) then
					if (((5016 - (55 + 166)) > (78 + 324)) and v25(v53.KillCommand, nil, nil, not v14:IsInRange(6 + 44))) then
						return "kill_command cleave 12";
					end
				end
				v104 = 7 - 5;
			end
		end
	end
	local function v84()
		local v105 = 297 - (36 + 261);
		while true do
			if (((8416 - 3603) > (4933 - (34 + 1334))) and (v105 == (2 + 2))) then
				if (((3040 + 872) == (5195 - (1035 + 248))) and v53.KillShot:IsReady()) then
					if (((2842 - (20 + 1)) <= (2514 + 2310)) and v25(v53.KillShot, not v14:IsSpellInRange(v53.KillShot))) then
						return "kill_shot st 30";
					end
				end
				if (((2057 - (134 + 185)) <= (3328 - (549 + 584))) and v16:Exists() and v53.KillShot:IsCastable() and (v16:HealthPercentage() <= (705 - (314 + 371)))) then
					if (((140 - 99) <= (3986 - (478 + 490))) and v25(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot))) then
						return "kill_shot_mouseover st 31";
					end
				end
				if (((1137 + 1008) <= (5276 - (786 + 386))) and v53.AspectoftheWild:IsCastable() and v29) then
					if (((8709 - 6020) < (6224 - (1055 + 324))) and v26(v53.AspectoftheWild)) then
						return "aspect_of_the_wild st 32";
					end
				end
				if (v53.CobraShot:IsReady() or ((3662 - (1093 + 247)) > (2330 + 292))) then
					if (v25(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot)) or ((477 + 4057) == (8265 - 6183))) then
						return "cobra_shot st 34";
					end
				end
				v105 = 16 - 11;
			end
			if ((v105 == (0 - 0)) or ((3947 - 2376) > (665 + 1202))) then
				if (v53.BarbedShot:IsCastable() or ((10224 - 7570) >= (10326 - 7330))) then
					if (((3000 + 978) > (5380 - 3276)) and v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v77, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
						return "barbed_shot st 2";
					end
				end
				if (((3683 - (364 + 324)) > (4224 - 2683)) and v53.BarbedShot:IsCastable() and v77(v14)) then
					if (((7796 - 4547) > (316 + 637)) and v25(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot))) then
						return "barbed_shot st mt_backup 3";
					end
				end
				if ((v53.CalloftheWild:IsCastable() and v29) or ((13695 - 10422) > (7323 - 2750))) then
					if (v26(v53.CalloftheWild) or ((9569 - 6418) < (2552 - (1249 + 19)))) then
						return "call_of_the_wild st 6";
					end
				end
				if ((v53.KillCommand:IsReady() and (v53.KillCommand:FullRechargeTime() < v59) and v53.AlphaPredator:IsAvailable()) or ((1670 + 180) == (5951 - 4422))) then
					if (((1907 - (686 + 400)) < (1666 + 457)) and v25(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand))) then
						return "kill_command st 4";
					end
				end
				v105 = 230 - (73 + 156);
			end
			if (((5 + 897) < (3136 - (721 + 90))) and (v105 == (1 + 2))) then
				if (((2785 - 1927) <= (3432 - (224 + 246))) and v53.BarbedShot:IsCastable()) then
					if (v51.CastTargetIf(v57.BarbedShotPetAttack, v62, "min", v69, v78, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover) or ((6392 - 2446) < (2371 - 1083))) then
						return "barbed_shot st 24";
					end
				end
				if ((v53.BarbedShot:IsCastable() and v78(v14)) or ((589 + 2653) == (14 + 553))) then
					if (v25(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot)) or ((623 + 224) >= (2510 - 1247))) then
						return "barbed_shot st mt_backup 25";
					end
				end
				if (v53.DireBeast:IsCastable() or ((7497 - 5244) == (2364 - (203 + 310)))) then
					if (v25(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast)) or ((4080 - (1238 + 755)) > (166 + 2206))) then
						return "dire_beast st 26";
					end
				end
				if (v53.SerpentSting:IsReady() or ((5979 - (709 + 825)) < (7645 - 3496))) then
					if (v51.CastTargetIf(v53.SerpentSting, v62, "min", v71, v79, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover) or ((2647 - 829) == (949 - (196 + 668)))) then
						return "serpent_sting st 28";
					end
				end
				v105 = 15 - 11;
			end
			if (((1304 - 674) < (2960 - (171 + 662))) and (v105 == (98 - (4 + 89)))) then
				if ((v53.WailingArrow:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53.WailingArrow:ExecuteTime()) or (v61 < (17 - 12)))) or ((706 + 1232) == (11042 - 8528))) then
					if (((1669 + 2586) >= (1541 - (35 + 1451))) and v25(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow), true)) then
						return "wailing_arrow st 36";
					end
				end
				if (((4452 - (28 + 1425)) > (3149 - (941 + 1052))) and v29) then
					if (((2254 + 96) > (2669 - (822 + 692))) and v53.BagofTricks:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (6 - 1)))) then
						if (((1898 + 2131) <= (5150 - (45 + 252))) and v26(v53.BagofTricks)) then
							return "bag_of_tricks st 38";
						end
					end
					if ((v53.ArcanePulse:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < (5 + 0)))) or ((178 + 338) > (8357 - 4923))) then
						if (((4479 - (114 + 319)) >= (4353 - 1320)) and v26(v53.ArcanePulse)) then
							return "arcane_pulse st 40";
						end
					end
					if ((v53.ArcaneTorrent:IsCastable() and ((v13:Focus() + v13:FocusRegen() + (19 - 4)) < v13:FocusMax())) or ((1734 + 985) <= (2155 - 708))) then
						if (v26(v53.ArcaneTorrent) or ((8661 - 4527) < (5889 - (556 + 1407)))) then
							return "arcane_torrent st 42";
						end
					end
				end
				break;
			end
			if ((v105 == (1207 - (741 + 465))) or ((629 - (170 + 295)) >= (1468 + 1317))) then
				if ((v53.Stampede:IsCastable() and v29) or ((483 + 42) == (5192 - 3083))) then
					if (((28 + 5) == (22 + 11)) and v25(v53.Stampede, nil, nil, not v14:IsSpellInRange(v53.Stampede))) then
						return "stampede st 8";
					end
				end
				if (((1730 + 1324) <= (5245 - (957 + 273))) and v53.Bloodshed:IsCastable()) then
					if (((501 + 1370) < (1354 + 2028)) and v25(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed))) then
						return "bloodshed st 10";
					end
				end
				if (((4926 - 3633) <= (5707 - 3541)) and v53.BestialWrath:IsCastable() and v29) then
					if (v26(v53.BestialWrath) or ((7877 - 5298) < (609 - 486))) then
						return "bestial_wrath st 12";
					end
				end
				if ((v53.DeathChakram:IsCastable() and v29) or ((2626 - (389 + 1391)) >= (1486 + 882))) then
					if (v25(v53.DeathChakram, nil, nil, not v14:IsSpellInRange(v53.DeathChakram)) or ((418 + 3594) <= (7644 - 4286))) then
						return "death_chakram st 14";
					end
				end
				v105 = 953 - (783 + 168);
			end
			if (((5014 - 3520) <= (2956 + 49)) and (v105 == (313 - (309 + 2)))) then
				if (v53.KillCommand:IsReady() or ((9553 - 6442) == (3346 - (1090 + 122)))) then
					if (((764 + 1591) == (7909 - 5554)) and v25(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand))) then
						return "kill_command st 22";
					end
				end
				if ((v53.AMurderofCrows:IsCastable() and v29) or ((403 + 185) <= (1550 - (628 + 490)))) then
					if (((861 + 3936) >= (9643 - 5748)) and v25(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows))) then
						return "a_murder_of_crows st 14";
					end
				end
				if (((16346 - 12769) == (4351 - (431 + 343))) and v53.SteelTrap:IsCastable()) then
					if (((7662 - 3868) > (10683 - 6990)) and v26(v53.SteelTrap)) then
						return "steel_trap st 16";
					end
				end
				if (v53.ExplosiveShot:IsReady() or ((1008 + 267) == (525 + 3575))) then
					if (v25(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot)) or ((3286 - (556 + 1139)) >= (3595 - (6 + 9)))) then
						return "explosive_shot st 18";
					end
				end
				v105 = 1 + 2;
			end
		end
	end
	local function v85()
		if (((504 + 479) <= (1977 - (28 + 141))) and not v13:IsCasting() and not v13:IsChanneling()) then
			local v111 = 0 + 0;
			local v112;
			while true do
				if ((v111 == (0 - 0)) or ((1523 + 627) <= (2514 - (486 + 831)))) then
					v112 = v51.Interrupt(v53.CounterShot, 104 - 64, true);
					if (((13268 - 9499) >= (222 + 951)) and v112) then
						return v112;
					end
					v111 = 3 - 2;
				end
				if (((2748 - (668 + 595)) == (1337 + 148)) and (v111 == (1 + 0))) then
					v112 = v51.InterruptWithStun(v53.Intimidation, 109 - 69);
					if (v112 or ((3605 - (23 + 267)) <= (4726 - (1129 + 815)))) then
						return v112;
					end
					break;
				end
			end
		end
	end
	local function v86()
		local v106 = 387 - (371 + 16);
		local v107;
		local v108;
		while true do
			if ((v106 == (1750 - (1326 + 424))) or ((1658 - 782) >= (10831 - 7867))) then
				v50();
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v106 = 119 - (88 + 30);
			end
			if (((776 - (720 + 51)) == v106) or ((4964 - 2732) > (4273 - (421 + 1355)))) then
				if (not (v13:IsMounted() or v13:IsInVehicle()) or ((3480 - 1370) <= (164 + 168))) then
					local v125 = 1083 - (286 + 797);
					while true do
						if (((13474 - 9788) > (5253 - 2081)) and ((440 - (397 + 42)) == v125)) then
							if ((v53.MendPet:IsCastable() and v45 and (v17:HealthPercentage() < v46)) or ((1398 + 3076) < (1620 - (24 + 776)))) then
								if (((6591 - 2312) >= (3667 - (222 + 563))) and v26(v53.MendPet)) then
									return "Mend Pet High Priority";
								end
							end
							break;
						end
						if ((v125 == (0 - 0)) or ((1461 + 568) >= (3711 - (23 + 167)))) then
							if ((v53.SummonPet:IsCastable() and v41) or ((3835 - (690 + 1108)) >= (1675 + 2967))) then
								if (((1419 + 301) < (5306 - (40 + 808))) and v26(v54[v42])) then
									return "Summon Pet";
								end
							end
							if ((v53.RevivePet:IsCastable() and v44 and v17:IsDeadOrGhost()) or ((72 + 364) > (11552 - 8531))) then
								if (((682 + 31) <= (449 + 398)) and v26(v53.RevivePet)) then
									return "Revive Pet";
								end
							end
							v125 = 1 + 0;
						end
					end
				end
				if (((2725 - (47 + 524)) <= (2616 + 1415)) and v51.TargetIsValid()) then
					if (((12615 - 8000) == (6900 - 2285)) and not v13:AffectingCombat() and not v27) then
						local v131 = 0 - 0;
						local v132;
						while true do
							if ((v131 == (1726 - (1165 + 561))) or ((113 + 3677) == (1548 - 1048))) then
								v132 = v80();
								if (((34 + 55) < (700 - (341 + 138))) and v132) then
									return v132;
								end
								break;
							end
						end
					end
					local v126 = v85();
					if (((555 + 1499) >= (2932 - 1511)) and v126) then
						return v126;
					end
					if (((1018 - (89 + 237)) < (9837 - 6779)) and not v13:IsCasting() and not v13:IsChanneling()) then
						local v133 = 0 - 0;
						local v134;
						while true do
							if ((v133 == (884 - (581 + 300))) or ((4474 - (855 + 365)) == (3930 - 2275))) then
								v134 = v51.InterruptWithStun(v53.Intimidation, 14 + 26, true, v16, v57.IntimidationMouseover);
								if (v134 or ((2531 - (1030 + 205)) == (4610 + 300))) then
									return v134;
								end
								break;
							end
							if (((3134 + 234) == (3654 - (156 + 130))) and (v133 == (2 - 1))) then
								v134 = v51.Interrupt(v53.CounterShot, 67 - 27, true, v16, v57.CounterShotMouseover);
								if (((5413 - 2770) < (1006 + 2809)) and v134) then
									return v134;
								end
								v133 = 2 + 0;
							end
							if (((1982 - (10 + 59)) > (140 + 353)) and (v133 == (9 - 7))) then
								v134 = v51.InterruptWithStun(v53.Intimidation, 1203 - (671 + 492), true);
								if (((3786 + 969) > (4643 - (369 + 846))) and v134) then
									return v134;
								end
								v133 = 1 + 2;
							end
							if (((1179 + 202) <= (4314 - (1036 + 909))) and (v133 == (0 + 0))) then
								v134 = v51.Interrupt(v53.CounterShot, 67 - 27, true);
								if (v134 or ((5046 - (11 + 192)) == (2064 + 2020))) then
									return v134;
								end
								v133 = 176 - (135 + 40);
							end
						end
					end
					local v127 = v51.HandleDPSPotion();
					if (((11312 - 6643) > (219 + 144)) and v127) then
						return v127;
					end
					if (v29 or ((4135 - 2258) >= (4703 - 1565))) then
						local v135 = 176 - (50 + 126);
						local v136;
						while true do
							if (((13204 - 8462) >= (803 + 2823)) and (v135 == (1413 - (1233 + 180)))) then
								v136 = v81();
								if (v136 or ((5509 - (522 + 447)) == (2337 - (107 + 1314)))) then
									return v136;
								end
								break;
							end
						end
					end
					local v126 = v82();
					if (v126 or ((537 + 619) > (13239 - 8894))) then
						return v126;
					end
					if (((951 + 1286) < (8437 - 4188)) and ((v64 > (7 - 5)) or (v53.BeastCleave:IsAvailable() and (v64 > (1911 - (716 + 1194)))))) then
						local v137 = 0 + 0;
						local v138;
						while true do
							if ((v137 == (0 + 0)) or ((3186 - (74 + 429)) < (43 - 20))) then
								v138 = v83();
								if (((346 + 351) <= (1890 - 1064)) and v138) then
									return v138;
								end
								break;
							end
						end
					end
					if (((782 + 323) <= (3625 - 2449)) and ((v64 < (4 - 2)) or (not v53.BeastCleave:IsAvailable() and (v64 < (436 - (279 + 154)))))) then
						local v139 = v84();
						if (((4157 - (454 + 324)) <= (3000 + 812)) and v139) then
							return v139;
						end
					end
					if ((not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53.MendPet:IsCastable() and (v17:HealthPercentage() < v46) and v45) or ((805 - (12 + 5)) >= (872 + 744))) then
						if (((4723 - 2869) <= (1249 + 2130)) and v26(v53.MendPet)) then
							return "Mend Pet Low Priority (w/ Target)";
						end
					end
				end
				if (((5642 - (277 + 816)) == (19438 - 14889)) and not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53.MendPet:IsCastable() and (v17:HealthPercentage() < v46) and v45) then
					if (v26(v53.MendPet) or ((4205 - (1058 + 125)) >= (567 + 2457))) then
						return "Mend Pet Low Priority (w/o Target)";
					end
				end
				break;
			end
			if (((5795 - (815 + 160)) > (9430 - 7232)) and ((9 - 5) == v106)) then
				if (v51.TargetIsValid() or v13:AffectingCombat() or ((254 + 807) >= (14297 - 9406))) then
					local v128 = 1898 - (41 + 1857);
					while true do
						if (((3257 - (1222 + 671)) <= (11560 - 7087)) and ((0 - 0) == v128)) then
							v60 = v10.BossFightRemains();
							v61 = v60;
							v128 = 1183 - (229 + 953);
						end
						if (((1775 - (1111 + 663)) == v128) or ((5174 - (874 + 705)) <= (1 + 2))) then
							if ((v61 == (7581 + 3530)) or ((9710 - 5038) == (109 + 3743))) then
								v61 = v10.FightRemains(v62, false);
							end
							break;
						end
					end
				end
				if (((2238 - (642 + 37)) == (356 + 1203)) and v53.Exhilaration:IsCastable() and v53.Exhilaration:IsReady() and (v13:HealthPercentage() <= v48)) then
					if (v26(v53.Exhilaration) or ((281 + 1471) <= (1978 - 1190))) then
						return "Exhilaration";
					end
				end
				if (((v13:HealthPercentage() <= v37) and v36 and v55.Healthstone:IsReady() and v55.Healthstone:IsUsable()) or ((4361 - (233 + 221)) == (408 - 231))) then
					if (((3055 + 415) > (2096 - (718 + 823))) and v26(v57.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				v106 = 4 + 1;
			end
			if (((807 - (266 + 539)) == v106) or ((2751 - 1779) == (1870 - (636 + 589)))) then
				v108 = (v53.Growl:IsPetKnown() and v20.FindBySpellID(v53.Growl:ID()) and v53.Growl) or nil;
				if (((7553 - 4371) >= (4361 - 2246)) and v28) then
					local v129 = 0 + 0;
					while true do
						if (((1415 + 2478) < (5444 - (657 + 358))) and (v129 == (2 - 1))) then
							v64 = (v107 and #v63) or v14:GetEnemiesInSplashRangeCount(18 - 10);
							break;
						end
						if ((v129 == (1187 - (1151 + 36))) or ((2769 + 98) < (501 + 1404))) then
							v62 = v13:GetEnemiesInRange(119 - 79);
							v63 = (v107 and v13:GetEnemiesInSpellActionRange(v107)) or v14:GetEnemiesInSplashRange(1840 - (1552 + 280));
							v129 = 835 - (64 + 770);
						end
					end
				else
					local v130 = 0 + 0;
					while true do
						if (((2 - 1) == v130) or ((319 + 1477) >= (5294 - (157 + 1086)))) then
							v64 = 0 - 0;
							break;
						end
						if (((7090 - 5471) <= (5760 - 2004)) and (v130 == (0 - 0))) then
							v62 = {};
							v63 = v14 or {};
							v130 = 820 - (599 + 220);
						end
					end
				end
				v65 = v14:IsInRange(79 - 39);
				v106 = 1934 - (1813 + 118);
			end
			if (((442 + 162) == (1821 - (841 + 376))) and (v106 == (1 - 0))) then
				v29 = EpicSettings.Toggles['cds'];
				if (v53.Stomp:IsAvailable() or ((1042 + 3442) == (2456 - 1556))) then
					v10.SplashEnemies.ChangeFriendTargetsTracking("Mine Only");
				else
					v10.SplashEnemies.ChangeFriendTargetsTracking("All");
				end
				v107 = (v53.BloodBolt:IsPetKnown() and v20.FindBySpellID(v53.BloodBolt:ID()) and v53.BloodBolt) or (v53.Bite:IsPetKnown() and v20.FindBySpellID(v53.Bite:ID()) and v53.Bite) or (v53.Claw:IsPetKnown() and v20.FindBySpellID(v53.Claw:ID()) and v53.Claw) or (v53.Smack:IsPetKnown() and v20.FindBySpellID(v53.Smack:ID()) and v53.Smack) or nil;
				v106 = 861 - (464 + 395);
			end
			if (((7 - 4) == v106) or ((2142 + 2317) <= (1950 - (467 + 370)))) then
				v66 = v14:IsInRange(61 - 31);
				v67 = (v108 and v14:IsSpellInActionRange(v108)) or v14:IsInRange(23 + 7);
				v59 = v13:GCD() + (0.15 - 0);
				v106 = 1 + 3;
			end
		end
	end
	local function v87()
		v10.Print("Beast Mastery by Epic. Supported by Gojira");
		local v109 = (v53.Growl:IsPetKnown() and v20.FindBySpellID(v53.Growl:ID()) and v53.Growl) or nil;
		if (((8449 - 4817) > (3918 - (150 + 370))) and not v109) then
			v10.Print("|cffffff00Info|r: Add pet abilities to your action bars to improve range checks.");
		end
	end
	v10.SetAPL(1535 - (74 + 1208), v86, v87);
end;
return v0["Epix_Hunter_BeastMastery.lua"]();

