local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((4501 - (221 + 925)) >= (3897 - (1019 + 26))) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Shaman_Enhancement.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.Focus;
	local v16 = v11.Mouseover;
	local v17 = v9.Spell;
	local v18 = v9.MultiSpell;
	local v19 = v9.Item;
	local v20 = EpicLib;
	local v21 = v20.Cast;
	local v22 = v20.Macro;
	local v23 = v20.Press;
	local v24 = v20.Commons.Everyone.num;
	local v25 = v20.Commons.Everyone.bool;
	local v26 = GetWeaponEnchantInfo;
	local v27 = math.max;
	local v28 = math.min;
	local v29 = string.match;
	local v30 = GetTime;
	local v31 = C_Timer;
	local v32;
	local v33 = false;
	local v34 = false;
	local v35 = false;
	local v36 = false;
	local v37 = false;
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
	local v51;
	local v52;
	local v53;
	local v54;
	local v55;
	local v56;
	local v57;
	local v58;
	local v59;
	local v60;
	local v61;
	local v62;
	local v63;
	local v64;
	local v65;
	local v66;
	local v67;
	local v68;
	local v69;
	local v70;
	local v71;
	local v72;
	local v73;
	local v74;
	local v75;
	local v76;
	local v77;
	local v78;
	local v79;
	local v80;
	local v81;
	local v82;
	local v83;
	local v84;
	local v85;
	local v86;
	local v87;
	local v88;
	local v89;
	local v90;
	local v91;
	local v92;
	local v93;
	local v94;
	local v95;
	local v96;
	local v97;
	local v98;
	local v99;
	local v100;
	local v101;
	local v102 = v17.Shaman.Enhancement;
	local v103 = v19.Shaman.Enhancement;
	local v104 = v22.Shaman.Enhancement;
	local v105 = {};
	local v106, v107;
	local v108, v109;
	local v110, v111, v112, v113;
	local v114 = (v102.LavaBurst:IsAvailable() and (2 + 0)) or (1 + 0);
	local v115 = "Lightning Bolt";
	local v116 = 23688 - 12577;
	local v117 = 11536 - (360 + 65);
	local v118 = v20.Commons.Everyone;
	v20.Commons.Shaman = {};
	local v120 = v20.Commons.Shaman;
	v120.FeralSpiritCount = 0 + 0;
	v9:RegisterForEvent(function()
		v114 = (v102.LavaBurst:IsAvailable() and (256 - (79 + 175))) or (1 - 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v9:RegisterForEvent(function()
		v115 = "Lightning Bolt";
		v116 = 8671 + 2440;
		v117 = 34058 - 22947;
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForSelfCombatEvent(function(...)
		local v143, v144, v144, v144, v144, v144, v144, v144, v145 = select(7 - 3, ...);
		if (((v143 == v13:GUID()) and (v145 == (192533 - (503 + 396)))) or ((1230 - (92 + 89)) <= (1756 - 850))) then
			v120.LastSKCast = v30();
		end
		if (((2315 + 2198) > (1614 + 1112)) and v13:HasTier(121 - 90, 1 + 1) and (v143 == v13:GUID()) and (v145 == (857287 - 481305))) then
			v120.FeralSpiritCount = v120.FeralSpiritCount + 1 + 0;
			v31.After(8 + 7, function()
				v120.FeralSpiritCount = v120.FeralSpiritCount - (2 - 1);
			end);
		end
		if (((v143 == v13:GUID()) and (v145 == (6432 + 45101))) or ((2258 - 777) >= (3902 - (485 + 759)))) then
			v120.FeralSpiritCount = v120.FeralSpiritCount + (4 - 2);
			v31.After(1204 - (442 + 747), function()
				v120.FeralSpiritCount = v120.FeralSpiritCount - (1137 - (832 + 303));
			end);
		end
	end, "SPELL_CAST_SUCCESS");
	local function v122()
		if (v102.CleanseSpirit:IsAvailable() or ((4166 - (88 + 858)) == (416 + 948))) then
			v118.DispellableDebuffs = v118.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123()
		for v168 = 1 + 0, 1 + 5, 790 - (766 + 23) do
			if (v29(v13:TotemName(v168), "Totem") or ((5203 - 4149) > (4638 - 1246))) then
				return v168;
			end
		end
	end
	local function v124()
		local v146 = 0 - 0;
		local v147;
		while true do
			if ((v146 == (0 - 0)) or ((1749 - (1036 + 37)) >= (1165 + 477))) then
				if (((8054 - 3918) > (1886 + 511)) and (not v102.AlphaWolf:IsAvailable() or v13:BuffDown(v102.FeralSpiritBuff))) then
					return 1480 - (641 + 839);
				end
				v147 = v28(v102.CrashLightning:TimeSinceLastCast(), v102.ChainLightning:TimeSinceLastCast());
				v146 = 914 - (910 + 3);
			end
			if ((v146 == (2 - 1)) or ((6018 - (1466 + 218)) == (1951 + 2294))) then
				if ((v147 > (1156 - (556 + 592))) or (v147 > v102.FeralSpirit:TimeSinceLastCast()) or ((1521 + 2755) <= (3839 - (329 + 479)))) then
					return 854 - (174 + 680);
				end
				return (27 - 19) - v147;
			end
		end
	end
	local function v125(v148)
		return (v148:DebuffRefreshable(v102.FlameShockDebuff));
	end
	local function v126(v149)
		return (v149:DebuffRefreshable(v102.LashingFlamesDebuff));
	end
	local v127 = 0 - 0;
	local function v128()
		if ((v102.CleanseSpirit:IsReady() and v37 and v118.DispellableFriendlyUnit(18 + 7)) or ((5521 - (396 + 343)) <= (107 + 1092))) then
			if ((v127 == (1477 - (29 + 1448))) or ((6253 - (135 + 1254)) < (7164 - 5262))) then
				v127 = v30();
			end
			if (((22593 - 17754) >= (2466 + 1234)) and v118.Wait(2027 - (389 + 1138), v127)) then
				local v223 = 574 - (102 + 472);
				while true do
					if ((v223 == (0 + 0)) or ((597 + 478) > (1789 + 129))) then
						if (((1941 - (320 + 1225)) <= (6771 - 2967)) and v23(v104.CleanseSpiritFocus)) then
							return "cleanse_spirit dispel";
						end
						v127 = 0 + 0;
						break;
					end
				end
			end
		end
	end
	local function v129()
		if (not v15 or not v15:Exists() or not v15:IsInRange(1504 - (157 + 1307)) or ((6028 - (821 + 1038)) == (5456 - 3269))) then
			return;
		end
		if (((154 + 1252) == (2496 - 1090)) and v15) then
			if (((570 + 961) < (10585 - 6314)) and (v15:HealthPercentage() <= v82) and v72 and v102.HealingSurge:IsReady() and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (1031 - (834 + 192)))) then
				if (((41 + 594) == (163 + 472)) and v23(v104.HealingSurgeFocus)) then
					return "healing_surge heal focus";
				end
			end
		end
	end
	local function v130()
		if (((73 + 3300) <= (5508 - 1952)) and (v13:HealthPercentage() <= v86)) then
			if (v102.HealingSurge:IsReady() or ((3595 - (300 + 4)) < (876 + 2404))) then
				if (((11481 - 7095) >= (1235 - (112 + 250))) and v23(v102.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v131()
		if (((368 + 553) <= (2760 - 1658)) and v102.AstralShift:IsReady() and v69 and (v13:HealthPercentage() <= v77)) then
			if (((2696 + 2010) >= (499 + 464)) and v23(v102.AstralShift)) then
				return "astral_shift defensive 1";
			end
		end
		if ((v102.AncestralGuidance:IsReady() and v70 and v118.AreUnitsBelowHealthPercentage(v78, v79, v102.HealingSurge)) or ((718 + 242) <= (435 + 441))) then
			if (v23(v102.AncestralGuidance) or ((1535 + 531) == (2346 - (1001 + 413)))) then
				return "ancestral_guidance defensive 2";
			end
		end
		if (((10759 - 5934) < (5725 - (244 + 638))) and v102.HealingStreamTotem:IsReady() and v71 and v118.AreUnitsBelowHealthPercentage(v80, v81, v102.HealingSurge)) then
			if (v23(v102.HealingStreamTotem) or ((4570 - (627 + 66)) >= (13518 - 8981))) then
				return "healing_stream_totem defensive 3";
			end
		end
		if ((v102.HealingSurge:IsReady() and v72 and (v13:HealthPercentage() <= v82) and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (607 - (512 + 90)))) or ((6221 - (1665 + 241)) < (2443 - (373 + 344)))) then
			if (v23(v102.HealingSurge) or ((1660 + 2019) < (166 + 459))) then
				return "healing_surge defensive 4";
			end
		end
		if ((v103.Healthstone:IsReady() and v73 and (v13:HealthPercentage() <= v83)) or ((12199 - 7574) < (1069 - 437))) then
			if (v23(v104.Healthstone) or ((1182 - (35 + 1064)) > (1296 + 484))) then
				return "healthstone defensive 3";
			end
		end
		if (((1168 - 622) <= (5 + 1072)) and v74 and (v13:HealthPercentage() <= v84)) then
			if ((v95 == "Refreshing Healing Potion") or ((2232 - (298 + 938)) > (5560 - (233 + 1026)))) then
				if (((5736 - (636 + 1030)) > (352 + 335)) and v103.RefreshingHealingPotion:IsReady()) then
					if (v23(v104.RefreshingHealingPotion) or ((641 + 15) >= (990 + 2340))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if ((v95 == "Dreamwalker's Healing Potion") or ((169 + 2323) <= (556 - (55 + 166)))) then
				if (((838 + 3484) >= (258 + 2304)) and v103.DreamwalkersHealingPotion:IsReady()) then
					if (v23(v104.RefreshingHealingPotion) or ((13889 - 10252) >= (4067 - (36 + 261)))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v132()
		v32 = v118.HandleTopTrinket(v105, v35, 69 - 29, nil);
		if (v32 or ((3747 - (34 + 1334)) > (1760 + 2818))) then
			return v32;
		end
		v32 = v118.HandleBottomTrinket(v105, v35, 32 + 8, nil);
		if (v32 or ((1766 - (1035 + 248)) > (764 - (20 + 1)))) then
			return v32;
		end
	end
	local function v133()
		if (((1279 + 1175) > (897 - (134 + 185))) and v102.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (1223 - (549 + 584))))) then
			if (((1615 - (314 + 371)) < (15304 - 10846)) and v23(v102.WindfuryTotem)) then
				return "windfury_totem precombat 4";
			end
		end
		if (((1630 - (478 + 490)) <= (515 + 457)) and v102.FeralSpirit:IsCastable() and v55 and ((v60 and v35) or not v60)) then
			if (((5542 - (786 + 386)) == (14154 - 9784)) and v23(v102.FeralSpirit)) then
				return "feral_spirit precombat 6";
			end
		end
		if ((v102.DoomWinds:IsCastable() and v56 and ((v61 and v35) or not v61)) or ((6141 - (1055 + 324)) <= (2201 - (1093 + 247)))) then
			if (v23(v102.DoomWinds, not v14:IsSpellInRange(v102.DoomWinds)) or ((1255 + 157) == (449 + 3815))) then
				return "doom_winds precombat 8";
			end
		end
		if ((v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62)) or ((12577 - 9409) < (7306 - 5153))) then
			if (v23(v102.Sundering, not v14:IsInRange(14 - 9)) or ((12504 - 7528) < (474 + 858))) then
				return "sundering precombat 10";
			end
		end
		if (((17828 - 13200) == (15951 - 11323)) and v102.Stormstrike:IsReady() and v49) then
			if (v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike)) or ((41 + 13) == (1010 - 615))) then
				return "stormstrike precombat 12";
			end
		end
	end
	local function v134()
		if (((770 - (364 + 324)) == (224 - 142)) and v102.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v117) and v14:DebuffDown(v102.FlameShockDebuff) and v102.LashingFlames:IsAvailable()) then
			if (v23(v102.PrimordialWave, not v14:IsSpellInRange(v102.PrimordialWave)) or ((1394 - 813) < (94 + 188))) then
				return "primordial_wave single 1";
			end
		end
		if ((v102.FlameShock:IsReady() and v42 and v14:DebuffDown(v102.FlameShockDebuff) and v102.LashingFlames:IsAvailable()) or ((19285 - 14676) < (3995 - 1500))) then
			if (((3498 - 2346) == (2420 - (1249 + 19))) and v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock))) then
				return "flame_shock single 2";
			end
		end
		if (((1712 + 184) <= (13319 - 9897)) and v102.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (1091 - (686 + 400))) and v102.ElementalSpirits:IsAvailable() and (v120.FeralSpiritCount >= (4 + 0))) then
			if (v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast)) or ((1219 - (73 + 156)) > (8 + 1612))) then
				return "elemental_blast single 3";
			end
		end
		if ((v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v117) and (v13:HasTier(841 - (721 + 90), 1 + 1))) or ((2847 - 1970) > (5165 - (224 + 246)))) then
			if (((4359 - 1668) >= (3407 - 1556)) and v23(v102.Sundering, not v14:IsInRange(2 + 6))) then
				return "sundering single 4";
			end
		end
		if ((v102.LightningBolt:IsReady() and v47 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (1 + 4)) and v13:BuffDown(v102.CracklingThunderBuff) and v13:BuffUp(v102.AscendanceBuff) and (v115 == "Chain Lightning") and (v13:BuffRemains(v102.AscendanceBuff) > (v102.ChainLightning:CooldownRemains() + v13:GCD()))) or ((2193 + 792) >= (9654 - 4798))) then
			if (((14229 - 9953) >= (1708 - (203 + 310))) and v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt))) then
				return "lightning_bolt single 5";
			end
		end
		if (((5225 - (1238 + 755)) <= (328 + 4362)) and v102.Stormstrike:IsReady() and v49 and (v13:BuffUp(v102.DoomWindsBuff) or v102.DeeplyRootedElements:IsAvailable() or (v102.Stormblast:IsAvailable() and v13:BuffUp(v102.StormbringerBuff)))) then
			if (v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike)) or ((2430 - (709 + 825)) >= (5796 - 2650))) then
				return "stormstrike single 6";
			end
		end
		if (((4458 - 1397) >= (3822 - (196 + 668))) and v102.LavaLash:IsReady() and v46 and (v13:BuffUp(v102.HotHandBuff))) then
			if (((12583 - 9396) >= (1333 - 689)) and v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash))) then
				return "lava_lash single 7";
			end
		end
		if (((1477 - (171 + 662)) <= (797 - (4 + 89))) and v102.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v102.WindfuryTotemBuff, true))) then
			if (((3357 - 2399) > (345 + 602)) and v23(v102.WindfuryTotem)) then
				return "windfury_totem single 8";
			end
		end
		if (((19729 - 15237) >= (1041 + 1613)) and v102.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (1491 - (35 + 1451))) and (v102.ElementalBlast:Charges() == v114)) then
			if (((4895 - (28 + 1425)) >= (3496 - (941 + 1052))) and v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast))) then
				return "elemental_blast single 9";
			end
		end
		if ((v102.LightningBolt:IsReady() and v47 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (8 + 0)) and v13:BuffUp(v102.PrimordialWaveBuff) and (v13:BuffDown(v102.SplinteredElementsBuff) or (v117 <= (1526 - (822 + 692))))) or ((4525 - 1355) <= (690 + 774))) then
			if (v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt)) or ((5094 - (45 + 252)) == (4342 + 46))) then
				return "lightning_bolt single 10";
			end
		end
		if (((190 + 361) <= (1657 - 976)) and v102.ChainLightning:IsReady() and v38 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (441 - (114 + 319))) and v13:BuffUp(v102.CracklingThunderBuff) and v102.ElementalSpirits:IsAvailable()) then
			if (((4705 - 1428) > (521 - 114)) and v23(v102.ChainLightning, not v14:IsSpellInRange(v102.ChainLightning))) then
				return "chain_lightning single 11";
			end
		end
		if (((2993 + 1702) >= (2108 - 693)) and v102.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (16 - 8)) and ((v120.FeralSpiritCount >= (1965 - (556 + 1407))) or not v102.ElementalSpirits:IsAvailable())) then
			if (v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast)) or ((4418 - (741 + 465)) <= (1409 - (170 + 295)))) then
				return "elemental_blast single 12";
			end
		end
		if ((v102.LavaBurst:IsReady() and v45 and not v102.ThorimsInvocation:IsAvailable() and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (3 + 2))) or ((2844 + 252) <= (4426 - 2628))) then
			if (((2933 + 604) == (2269 + 1268)) and v23(v102.LavaBurst, not v14:IsSpellInRange(v102.LavaBurst))) then
				return "lava_burst single 13";
			end
		end
		if (((2173 + 1664) >= (2800 - (957 + 273))) and v102.LightningBolt:IsReady() and v47 and ((v13:BuffStack(v102.MaelstromWeaponBuff) >= (3 + 5)) or (v102.StaticAccumulation:IsAvailable() and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (3 + 2)))) and v13:BuffDown(v102.PrimordialWaveBuff)) then
			if (v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt)) or ((11240 - 8290) == (10045 - 6233))) then
				return "lightning_bolt single 14";
			end
		end
		if (((14426 - 9703) >= (11477 - 9159)) and v102.CrashLightning:IsReady() and v39 and v102.AlphaWolf:IsAvailable() and v13:BuffUp(v102.FeralSpiritBuff) and (v124() == (1780 - (389 + 1391)))) then
			if (v23(v102.CrashLightning, not v14:IsInMeleeRange(6 + 2)) or ((211 + 1816) > (6492 - 3640))) then
				return "crash_lightning single 15";
			end
		end
		if ((v102.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v117)) or ((2087 - (783 + 168)) > (14488 - 10171))) then
			if (((4671 + 77) == (5059 - (309 + 2))) and v23(v102.PrimordialWave, not v14:IsSpellInRange(v102.PrimordialWave))) then
				return "primordial_wave single 16";
			end
		end
		if (((11472 - 7736) <= (5952 - (1090 + 122))) and v102.FlameShock:IsReady() and v42 and (v14:DebuffDown(v102.FlameShockDebuff))) then
			if (v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock)) or ((1100 + 2290) <= (10276 - 7216))) then
				return "flame_shock single 17";
			end
		end
		if ((v102.IceStrike:IsReady() and v44 and v102.ElementalAssault:IsAvailable() and v102.SwirlingMaelstrom:IsAvailable()) or ((684 + 315) > (3811 - (628 + 490)))) then
			if (((84 + 379) < (1487 - 886)) and v23(v102.IceStrike, not v14:IsInMeleeRange(22 - 17))) then
				return "ice_strike single 18";
			end
		end
		if ((v102.LavaLash:IsReady() and v46 and (v102.LashingFlames:IsAvailable())) or ((2957 - (431 + 343)) < (1386 - 699))) then
			if (((13159 - 8610) == (3594 + 955)) and v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash))) then
				return "lava_lash single 19";
			end
		end
		if (((598 + 4074) == (6367 - (556 + 1139))) and v102.IceStrike:IsReady() and v44 and (v13:BuffDown(v102.IceStrikeBuff))) then
			if (v23(v102.IceStrike, not v14:IsInMeleeRange(20 - (6 + 9))) or ((672 + 2996) < (203 + 192))) then
				return "ice_strike single 20";
			end
		end
		if ((v102.FrostShock:IsReady() and v43 and (v13:BuffUp(v102.HailstormBuff))) or ((4335 - (28 + 141)) == (177 + 278))) then
			if (v23(v102.FrostShock, not v14:IsSpellInRange(v102.FrostShock)) or ((5490 - 1041) == (1887 + 776))) then
				return "frost_shock single 21";
			end
		end
		if ((v102.LavaLash:IsReady() and v46) or ((5594 - (486 + 831)) < (7777 - 4788))) then
			if (v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash)) or ((3062 - 2192) >= (785 + 3364))) then
				return "lava_lash single 22";
			end
		end
		if (((6994 - 4782) < (4446 - (668 + 595))) and v102.IceStrike:IsReady() and v44) then
			if (((4181 + 465) > (604 + 2388)) and v23(v102.IceStrike, not v14:IsInMeleeRange(13 - 8))) then
				return "ice_strike single 23";
			end
		end
		if (((1724 - (23 + 267)) < (5050 - (1129 + 815))) and v102.Windstrike:IsCastable() and v52) then
			if (((1173 - (371 + 16)) < (4773 - (1326 + 424))) and v23(v102.Windstrike, not v14:IsSpellInRange(v102.Windstrike))) then
				return "windstrike single 24";
			end
		end
		if ((v102.Stormstrike:IsReady() and v49) or ((4624 - 2182) < (270 - 196))) then
			if (((4653 - (88 + 30)) == (5306 - (720 + 51))) and v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike))) then
				return "stormstrike single 25";
			end
		end
		if ((v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v117)) or ((6693 - 3684) <= (3881 - (421 + 1355)))) then
			if (((3019 - 1189) < (1803 + 1866)) and v23(v102.Sundering, not v14:IsInRange(1091 - (286 + 797)))) then
				return "sundering single 26";
			end
		end
		if ((v102.BagofTricks:IsReady() and v58 and ((v65 and v35) or not v65)) or ((5227 - 3797) >= (5982 - 2370))) then
			if (((3122 - (397 + 42)) >= (769 + 1691)) and v23(v102.BagofTricks)) then
				return "bag_of_tricks single 27";
			end
		end
		if ((v102.FireNova:IsReady() and v41 and v102.SwirlingMaelstrom:IsAvailable() and v14:DebuffUp(v102.FlameShockDebuff) and (v13:BuffStack(v102.MaelstromWeaponBuff) < ((805 - (24 + 776)) + ((7 - 2) * v24(v102.OverflowingMaelstrom:IsAvailable()))))) or ((2589 - (222 + 563)) >= (7215 - 3940))) then
			if (v23(v102.FireNova) or ((1021 + 396) > (3819 - (23 + 167)))) then
				return "fire_nova single 28";
			end
		end
		if (((6593 - (690 + 1108)) > (146 + 256)) and v102.LightningBolt:IsReady() and v47 and v102.Hailstorm:IsAvailable() and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (5 + 0)) and v13:BuffDown(v102.PrimordialWaveBuff)) then
			if (((5661 - (40 + 808)) > (587 + 2978)) and v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt))) then
				return "lightning_bolt single 29";
			end
		end
		if (((14959 - 11047) == (3739 + 173)) and v102.FrostShock:IsReady() and v43) then
			if (((1493 + 1328) <= (2646 + 2178)) and v23(v102.FrostShock, not v14:IsSpellInRange(v102.FrostShock))) then
				return "frost_shock single 30";
			end
		end
		if (((2309 - (47 + 524)) <= (1425 + 770)) and v102.CrashLightning:IsReady() and v39) then
			if (((112 - 71) <= (4512 - 1494)) and v23(v102.CrashLightning, not v14:IsInMeleeRange(17 - 9))) then
				return "crash_lightning single 31";
			end
		end
		if (((3871 - (1165 + 561)) <= (122 + 3982)) and v102.FireNova:IsReady() and v41 and (v14:DebuffUp(v102.FlameShockDebuff))) then
			if (((8328 - 5639) < (1849 + 2996)) and v23(v102.FireNova)) then
				return "fire_nova single 32";
			end
		end
		if ((v102.FlameShock:IsReady() and v42) or ((2801 - (341 + 138)) > (708 + 1914))) then
			if (v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock)) or ((9356 - 4822) == (2408 - (89 + 237)))) then
				return "flame_shock single 34";
			end
		end
		if ((v102.ChainLightning:IsReady() and v38 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (16 - 11)) and v13:BuffUp(v102.CracklingThunderBuff) and v102.ElementalSpirits:IsAvailable()) or ((3307 - 1736) > (2748 - (581 + 300)))) then
			if (v23(v102.ChainLightning, not v14:IsSpellInRange(v102.ChainLightning)) or ((3874 - (855 + 365)) >= (7115 - 4119))) then
				return "chain_lightning single 35";
			end
		end
		if (((1299 + 2679) > (3339 - (1030 + 205))) and v102.LightningBolt:IsReady() and v47 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (5 + 0)) and v13:BuffDown(v102.PrimordialWaveBuff)) then
			if (((2787 + 208) > (1827 - (156 + 130))) and v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt))) then
				return "lightning_bolt single 36";
			end
		end
		if (((7382 - 4133) > (1606 - 653)) and v102.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (184 - 94)))) then
			if (v23(v102.WindfuryTotem) or ((863 + 2410) > (2667 + 1906))) then
				return "windfury_totem single 37";
			end
		end
	end
	local function v135()
		if ((v102.CrashLightning:IsReady() and v39 and v102.CrashingStorms:IsAvailable() and ((v102.UnrulyWinds:IsAvailable() and (v112 >= (79 - (10 + 59)))) or (v112 >= (5 + 10)))) or ((15517 - 12366) < (2447 - (671 + 492)))) then
			if (v23(v102.CrashLightning, not v14:IsInMeleeRange(7 + 1)) or ((3065 - (369 + 846)) == (405 + 1124))) then
				return "crash_lightning aoe 1";
			end
		end
		if (((701 + 120) < (4068 - (1036 + 909))) and v102.LightningBolt:IsReady() and v47 and ((v102.FlameShockDebuff:AuraActiveCount() >= v112) or (v13:BuffRemains(v102.PrimordialWaveBuff) < (v13:GCD() * (3 + 0))) or (v102.FlameShockDebuff:AuraActiveCount() >= (9 - 3))) and v13:BuffUp(v102.PrimordialWaveBuff) and (v13:BuffStack(v102.MaelstromWeaponBuff) == ((208 - (11 + 192)) + ((3 + 2) * v24(v102.OverflowingMaelstrom:IsAvailable())))) and (v13:BuffDown(v102.SplinteredElementsBuff) or (v117 <= (187 - (135 + 40))) or (v99 <= v13:GCD()))) then
			if (((2185 - 1283) < (1402 + 923)) and v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt))) then
				return "lightning_bolt aoe 2";
			end
		end
		if (((1890 - 1032) <= (4439 - 1477)) and v102.LavaLash:IsReady() and v46 and v102.MoltenAssault:IsAvailable() and (v102.PrimordialWave:IsAvailable() or v102.FireNova:IsAvailable()) and v14:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (182 - (50 + 126)))) then
			if (v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash)) or ((10987 - 7041) < (286 + 1002))) then
				return "lava_lash aoe 3";
			end
		end
		if ((v102.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v117) and (v13:BuffDown(v102.PrimordialWaveBuff))) or ((4655 - (1233 + 180)) == (1536 - (522 + 447)))) then
			local v174 = 1421 - (107 + 1314);
			while true do
				if ((v174 == (0 + 0)) or ((2580 - 1733) >= (537 + 726))) then
					if (v118.CastCycle(v102.PrimordialWave, v111, v125, not v14:IsSpellInRange(v102.PrimordialWave)) or ((4473 - 2220) == (7323 - 5472))) then
						return "primordial_wave aoe 4";
					end
					if (v23(v102.PrimordialWave, not v14:IsSpellInRange(v102.PrimordialWave)) or ((3997 - (716 + 1194)) > (41 + 2331))) then
						return "primordial_wave aoe no_cycle 4";
					end
					break;
				end
			end
		end
		if ((v102.FlameShock:IsReady() and v42 and (v102.PrimordialWave:IsAvailable() or v102.FireNova:IsAvailable()) and v14:DebuffDown(v102.FlameShockDebuff)) or ((477 + 3968) < (4652 - (74 + 429)))) then
			if (v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock)) or ((3506 - 1688) == (43 + 42))) then
				return "flame_shock aoe 5";
			end
		end
		if (((1442 - 812) < (1505 + 622)) and v102.ElementalBlast:IsReady() and v40 and (not v102.ElementalSpirits:IsAvailable() or (v102.ElementalSpirits:IsAvailable() and ((v102.ElementalBlast:Charges() == v114) or (v120.FeralSpiritCount >= (5 - 3))))) and (v13:BuffStack(v102.MaelstromWeaponBuff) == ((12 - 7) + ((438 - (279 + 154)) * v24(v102.OverflowingMaelstrom:IsAvailable())))) and (not v102.CrashingStorms:IsAvailable() or (v112 <= (781 - (454 + 324))))) then
			if (v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast)) or ((1525 + 413) == (2531 - (12 + 5)))) then
				return "elemental_blast aoe 6";
			end
		end
		if (((2295 + 1960) >= (139 - 84)) and v102.ChainLightning:IsReady() and v38 and (v13:BuffStack(v102.MaelstromWeaponBuff) == (2 + 3 + ((1098 - (277 + 816)) * v24(v102.OverflowingMaelstrom:IsAvailable()))))) then
			if (((12814 - 9815) > (2339 - (1058 + 125))) and v23(v102.ChainLightning, not v14:IsSpellInRange(v102.ChainLightning))) then
				return "chain_lightning aoe 7";
			end
		end
		if (((441 + 1909) > (2130 - (815 + 160))) and v102.CrashLightning:IsReady() and v39 and (v13:BuffUp(v102.DoomWindsBuff) or v13:BuffDown(v102.CrashLightningBuff) or (v102.AlphaWolf:IsAvailable() and v13:BuffUp(v102.FeralSpiritBuff) and (v124() == (0 - 0))))) then
			if (((9564 - 5535) <= (1158 + 3695)) and v23(v102.CrashLightning, not v14:IsInMeleeRange(23 - 15))) then
				return "crash_lightning aoe 8";
			end
		end
		if ((v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v117) and (v13:BuffUp(v102.DoomWindsBuff) or v13:HasTier(1928 - (41 + 1857), 1895 - (1222 + 671)))) or ((1333 - 817) > (4935 - 1501))) then
			if (((5228 - (229 + 953)) >= (4807 - (1111 + 663))) and v23(v102.Sundering, not v14:IsInRange(1587 - (874 + 705)))) then
				return "sundering aoe 9";
			end
		end
		if ((v102.FireNova:IsReady() and v41 and ((v102.FlameShockDebuff:AuraActiveCount() >= (1 + 5)) or ((v102.FlameShockDebuff:AuraActiveCount() >= (3 + 1)) and (v102.FlameShockDebuff:AuraActiveCount() >= v112)))) or ((5651 - 2932) <= (41 + 1406))) then
			if (v23(v102.FireNova) or ((4813 - (642 + 37)) < (896 + 3030))) then
				return "fire_nova aoe 10";
			end
		end
		if ((v102.LavaLash:IsReady() and v46 and (v102.LashingFlames:IsAvailable())) or ((27 + 137) >= (6992 - 4207))) then
			local v175 = 454 - (233 + 221);
			while true do
				if ((v175 == (0 - 0)) or ((463 + 62) == (3650 - (718 + 823)))) then
					if (((21 + 12) == (838 - (266 + 539))) and v118.CastCycle(v102.LavaLash, v111, v126, not v14:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash aoe 11";
					end
					if (((8646 - 5592) <= (5240 - (636 + 589))) and v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash aoe no_cycle 11";
					end
					break;
				end
			end
		end
		if (((4441 - 2570) < (6975 - 3593)) and v102.LavaLash:IsReady() and v46 and ((v102.MoltenAssault:IsAvailable() and v14:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (5 + 1))) or (v102.AshenCatalyst:IsAvailable() and (v13:BuffStack(v102.AshenCatalystBuff) == (2 + 3))))) then
			if (((2308 - (657 + 358)) <= (5734 - 3568)) and v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash))) then
				return "lava_lash aoe 12";
			end
		end
		if ((v102.IceStrike:IsReady() and v44 and (v102.Hailstorm:IsAvailable())) or ((5875 - 3296) < (1310 - (1151 + 36)))) then
			if (v23(v102.IceStrike, not v14:IsInMeleeRange(5 + 0)) or ((223 + 623) >= (7071 - 4703))) then
				return "ice_strike aoe 13";
			end
		end
		if ((v102.FrostShock:IsReady() and v43 and v102.Hailstorm:IsAvailable() and v13:BuffUp(v102.HailstormBuff)) or ((5844 - (1552 + 280)) <= (4192 - (64 + 770)))) then
			if (((1015 + 479) <= (6821 - 3816)) and v23(v102.FrostShock, not v14:IsSpellInRange(v102.FrostShock))) then
				return "frost_shock aoe 14";
			end
		end
		if ((v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v117)) or ((553 + 2558) == (3377 - (157 + 1086)))) then
			if (((4713 - 2358) == (10314 - 7959)) and v23(v102.Sundering, not v14:IsInRange(11 - 3))) then
				return "sundering aoe 15";
			end
		end
		if ((v102.FlameShock:IsReady() and v42 and v102.MoltenAssault:IsAvailable() and v14:DebuffDown(v102.FlameShockDebuff)) or ((802 - 214) <= (1251 - (599 + 220)))) then
			if (((9552 - 4755) >= (5826 - (1813 + 118))) and v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock))) then
				return "flame_shock aoe 16";
			end
		end
		if (((2615 + 962) == (4794 - (841 + 376))) and v102.FlameShock:IsReady() and v42 and v14:DebuffRefreshable(v102.FlameShockDebuff) and (v102.FireNova:IsAvailable() or v102.PrimordialWave:IsAvailable()) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (7 - 1))) then
			if (((882 + 2912) > (10080 - 6387)) and v118.CastCycle(v102.FlameShock, v111, v125, not v14:IsSpellInRange(v102.FlameShock))) then
				return "flame_shock aoe 17";
			end
			if (v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock)) or ((2134 - (464 + 395)) == (10522 - 6422))) then
				return "flame_shock aoe no_cycle 17";
			end
		end
		if ((v102.FireNova:IsReady() and v41 and (v102.FlameShockDebuff:AuraActiveCount() >= (2 + 1))) or ((2428 - (467 + 370)) >= (7398 - 3818))) then
			if (((722 + 261) <= (6197 - 4389)) and v23(v102.FireNova)) then
				return "fire_nova aoe 18";
			end
		end
		if ((v102.Stormstrike:IsReady() and v49 and v13:BuffUp(v102.CrashLightningBuff) and (v102.DeeplyRootedElements:IsAvailable() or (v13:BuffStack(v102.ConvergingStormsBuff) == (1 + 5)))) or ((5002 - 2852) <= (1717 - (150 + 370)))) then
			if (((5051 - (74 + 1208)) >= (2885 - 1712)) and v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike))) then
				return "stormstrike aoe 19";
			end
		end
		if (((7042 - 5557) == (1057 + 428)) and v102.CrashLightning:IsReady() and v39 and v102.CrashingStorms:IsAvailable() and v13:BuffUp(v102.CLCrashLightningBuff) and (v112 >= (394 - (14 + 376)))) then
			if (v23(v102.CrashLightning, not v14:IsInMeleeRange(13 - 5)) or ((2146 + 1169) <= (2444 + 338))) then
				return "crash_lightning aoe 20";
			end
		end
		if ((v102.Windstrike:IsCastable() and v52) or ((836 + 40) >= (8684 - 5720))) then
			if (v23(v102.Windstrike, not v14:IsSpellInRange(v102.Windstrike)) or ((1680 + 552) > (2575 - (23 + 55)))) then
				return "windstrike aoe 21";
			end
		end
		if ((v102.Stormstrike:IsReady() and v49) or ((5000 - 2890) <= (222 + 110))) then
			if (((3311 + 375) > (4917 - 1745)) and v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike))) then
				return "stormstrike aoe 22";
			end
		end
		if ((v102.IceStrike:IsReady() and v44) or ((1408 + 3066) < (1721 - (652 + 249)))) then
			if (((11451 - 7172) >= (4750 - (708 + 1160))) and v23(v102.IceStrike, not v14:IsInMeleeRange(13 - 8))) then
				return "ice_strike aoe 23";
			end
		end
		if ((v102.LavaLash:IsReady() and v46) or ((3698 - 1669) >= (3548 - (10 + 17)))) then
			if (v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash)) or ((458 + 1579) >= (6374 - (1400 + 332)))) then
				return "lava_lash aoe 24";
			end
		end
		if (((3299 - 1579) < (6366 - (242 + 1666))) and v102.CrashLightning:IsReady() and v39) then
			if (v23(v102.CrashLightning, not v14:IsInMeleeRange(4 + 4)) or ((160 + 276) > (2575 + 446))) then
				return "crash_lightning aoe 25";
			end
		end
		if (((1653 - (850 + 90)) <= (1483 - 636)) and v102.FireNova:IsReady() and v41 and (v102.FlameShockDebuff:AuraActiveCount() >= (1392 - (360 + 1030)))) then
			if (((1907 + 247) <= (11377 - 7346)) and v23(v102.FireNova)) then
				return "fire_nova aoe 26";
			end
		end
		if (((6349 - 1734) == (6276 - (909 + 752))) and v102.ElementalBlast:IsReady() and v40 and (not v102.ElementalSpirits:IsAvailable() or (v102.ElementalSpirits:IsAvailable() and ((v102.ElementalBlast:Charges() == v114) or (v120.FeralSpiritCount >= (1225 - (109 + 1114)))))) and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (9 - 4)) and (not v102.CrashingStorms:IsAvailable() or (v112 <= (2 + 1)))) then
			if (v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast)) or ((4032 - (6 + 236)) == (316 + 184))) then
				return "elemental_blast aoe 27";
			end
		end
		if (((72 + 17) < (520 - 299)) and v102.ChainLightning:IsReady() and v38 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (8 - 3))) then
			if (((3187 - (1076 + 57)) >= (234 + 1187)) and v23(v102.ChainLightning, not v14:IsSpellInRange(v102.ChainLightning))) then
				return "chain_lightning aoe 28";
			end
		end
		if (((1381 - (579 + 110)) < (242 + 2816)) and v102.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (80 + 10)))) then
			if (v23(v102.WindfuryTotem) or ((1727 + 1527) == (2062 - (174 + 233)))) then
				return "windfury_totem aoe 29";
			end
		end
		if ((v102.FlameShock:IsReady() and v42 and (v14:DebuffDown(v102.FlameShockDebuff))) or ((3620 - 2324) == (8617 - 3707))) then
			if (((1498 + 1870) == (4542 - (663 + 511))) and v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock))) then
				return "flame_shock aoe 30";
			end
		end
		if (((2358 + 285) < (829 + 2986)) and v102.FrostShock:IsReady() and v43 and not v102.Hailstorm:IsAvailable()) then
			if (((5897 - 3984) > (299 + 194)) and v23(v102.FrostShock, not v14:IsSpellInRange(v102.FrostShock))) then
				return "frost_shock aoe 31";
			end
		end
	end
	local function v136()
		local v150 = 0 - 0;
		while true do
			if (((11510 - 6755) > (1636 + 1792)) and (v150 == (3 - 1))) then
				if (((985 + 396) <= (217 + 2152)) and v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) then
					if (v23(v102.AncestralSpirit, nil, true) or ((5565 - (478 + 244)) == (4601 - (440 + 77)))) then
						return "resurrection";
					end
				end
				if (((2123 + 2546) > (1328 - 965)) and v118.TargetIsValid() and v33) then
					if (not v13:AffectingCombat() or ((3433 - (655 + 901)) >= (582 + 2556))) then
						v32 = v133();
						if (((3631 + 1111) >= (2449 + 1177)) and v32) then
							return v32;
						end
					end
				end
				break;
			end
			if ((v150 == (0 - 0)) or ((5985 - (695 + 750)) == (3127 - 2211))) then
				if ((v75 and v102.EarthShield:IsCastable() and v13:BuffDown(v102.EarthShieldBuff) and ((v76 == "Earth Shield") or (v102.ElementalOrbit:IsAvailable() and v13:BuffUp(v102.LightningShield)))) or ((1783 - 627) > (17474 - 13129))) then
					if (((2588 - (285 + 66)) < (9904 - 5655)) and v23(v102.EarthShield)) then
						return "earth_shield main 2";
					end
				elseif ((v75 and v102.LightningShield:IsCastable() and v13:BuffDown(v102.LightningShieldBuff) and ((v76 == "Lightning Shield") or (v102.ElementalOrbit:IsAvailable() and v13:BuffUp(v102.EarthShield)))) or ((3993 - (682 + 628)) < (4 + 19))) then
					if (((996 - (176 + 123)) <= (346 + 480)) and v23(v102.LightningShield)) then
						return "lightning_shield main 2";
					end
				end
				if (((802 + 303) <= (1445 - (239 + 30))) and (not v106 or (v108 < (163108 + 436892))) and v53 and v102.WindfuryWeapon:IsCastable()) then
					if (((3248 + 131) <= (6746 - 2934)) and v23(v102.WindfuryWeapon)) then
						return "windfury_weapon enchant";
					end
				end
				v150 = 2 - 1;
			end
			if ((v150 == (316 - (306 + 9))) or ((2749 - 1961) >= (282 + 1334))) then
				if (((1138 + 716) <= (1627 + 1752)) and (not v107 or (v109 < (1715769 - 1115769))) and v53 and v102.FlametongueWeapon:IsCastable()) then
					if (((5924 - (1140 + 235)) == (2895 + 1654)) and v23(v102.FlametongueWeapon)) then
						return "flametongue_weapon enchant";
					end
				end
				if (v85 or ((2772 + 250) >= (777 + 2247))) then
					local v230 = 52 - (33 + 19);
					while true do
						if (((1741 + 3079) > (6587 - 4389)) and (v230 == (0 + 0))) then
							v32 = v130();
							if (v32 or ((2080 - 1019) >= (4587 + 304))) then
								return v32;
							end
							break;
						end
					end
				end
				v150 = 691 - (586 + 103);
			end
		end
	end
	local function v137()
		v32 = v131();
		if (((125 + 1239) <= (13770 - 9297)) and v32) then
			return v32;
		end
		if (v93 or ((5083 - (1309 + 179)) <= (5 - 2))) then
			if (v87 or ((2034 + 2638) == (10344 - 6492))) then
				local v224 = 0 + 0;
				while true do
					if (((3311 - 1752) == (3106 - 1547)) and (v224 == (609 - (295 + 314)))) then
						v32 = v118.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 98 - 58);
						if (v32 or ((3714 - (1300 + 662)) <= (2474 - 1686))) then
							return v32;
						end
						break;
					end
				end
			end
			if (v88 or ((5662 - (1178 + 577)) == (92 + 85))) then
				local v225 = 0 - 0;
				while true do
					if (((4875 - (851 + 554)) > (491 + 64)) and ((0 - 0) == v225)) then
						v32 = v118.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 65 - 35);
						if (v32 or ((1274 - (115 + 187)) == (494 + 151))) then
							return v32;
						end
						break;
					end
				end
			end
			if (((3013 + 169) >= (8334 - 6219)) and v89) then
				local v226 = 1161 - (160 + 1001);
				while true do
					if (((3406 + 487) < (3056 + 1373)) and (v226 == (0 - 0))) then
						v32 = v118.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 388 - (237 + 121));
						if (v32 or ((3764 - (525 + 372)) < (3611 - 1706))) then
							return v32;
						end
						break;
					end
				end
			end
			if (((v13:BuffStack(v102.MaelstromWeaponBuff) >= (16 - 11)) and v90) or ((1938 - (96 + 46)) >= (4828 - (643 + 134)))) then
				local v227 = 0 + 0;
				while true do
					if (((3881 - 2262) <= (13944 - 10188)) and ((0 + 0) == v227)) then
						v32 = v118.HandleAfflicted(v102.HealingSurge, v104.HealingSurgeMouseover, 78 - 38, true);
						if (((1234 - 630) == (1323 - (316 + 403))) and v32) then
							return v32;
						end
						break;
					end
				end
			end
		end
		if (v94 or ((2981 + 1503) == (2474 - 1574))) then
			v32 = v118.HandleIncorporeal(v102.Hex, v104.HexMouseOver, 11 + 19, true);
			if (v32 or ((11229 - 6770) <= (789 + 324))) then
				return v32;
			end
		end
		if (((1171 + 2461) > (11773 - 8375)) and v15) then
			if (((19494 - 15412) <= (10214 - 5297)) and v92) then
				v32 = v128();
				if (((277 + 4555) >= (2728 - 1342)) and v32) then
					return v32;
				end
			end
		end
		if (((7 + 130) == (403 - 266)) and v102.GreaterPurge:IsAvailable() and v100 and v102.GreaterPurge:IsReady() and v37 and v91 and not v13:IsCasting() and not v13:IsChanneling() and v118.UnitHasMagicBuff(v14)) then
			if (v23(v102.GreaterPurge, not v14:IsSpellInRange(v102.GreaterPurge)) or ((1587 - (12 + 5)) >= (16825 - 12493))) then
				return "greater_purge damage";
			end
		end
		if ((v102.Purge:IsReady() and v100 and v37 and v91 and not v13:IsCasting() and not v13:IsChanneling() and v118.UnitHasMagicBuff(v14)) or ((8670 - 4606) <= (3866 - 2047))) then
			if (v23(v102.Purge, not v14:IsSpellInRange(v102.Purge)) or ((12364 - 7378) < (320 + 1254))) then
				return "purge damage";
			end
		end
		v32 = v129();
		if (((6399 - (1656 + 317)) > (154 + 18)) and v32) then
			return v32;
		end
		if (((470 + 116) > (1209 - 754)) and v118.TargetIsValid()) then
			local v176 = v118.HandleDPSPotion(v13:BuffUp(v102.FeralSpiritBuff));
			if (((4065 - 3239) == (1180 - (5 + 349))) and v176) then
				return v176;
			end
			if ((v99 < v117) or ((19089 - 15070) > (5712 - (266 + 1005)))) then
				if (((1330 + 687) < (14538 - 10277)) and v57 and ((v35 and v64) or not v64)) then
					local v234 = 0 - 0;
					while true do
						if (((6412 - (561 + 1135)) > (104 - 24)) and ((0 - 0) == v234)) then
							v32 = v132();
							if (v32 or ((4573 - (507 + 559)) == (8210 - 4938))) then
								return v32;
							end
							break;
						end
					end
				end
			end
			if (((v99 < v117) and v58 and ((v65 and v35) or not v65)) or ((2709 - 1833) >= (3463 - (212 + 176)))) then
				if (((5257 - (250 + 655)) > (6964 - 4410)) and v102.BloodFury:IsCastable() and (not v102.Ascendance:IsAvailable() or v13:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (87 - 37)))) then
					if (v23(v102.BloodFury) or ((6893 - 2487) < (5999 - (1869 + 87)))) then
						return "blood_fury racial";
					end
				end
				if ((v102.Berserking:IsCastable() and (not v102.Ascendance:IsAvailable() or v13:BuffUp(v102.AscendanceBuff))) or ((6551 - 4662) >= (5284 - (484 + 1417)))) then
					if (((4055 - 2163) <= (4581 - 1847)) and v23(v102.Berserking)) then
						return "berserking racial";
					end
				end
				if (((2696 - (48 + 725)) < (3622 - 1404)) and v102.Fireblood:IsCastable() and (not v102.Ascendance:IsAvailable() or v13:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (134 - 84)))) then
					if (((1263 + 910) > (1012 - 633)) and v23(v102.Fireblood)) then
						return "fireblood racial";
					end
				end
				if ((v102.AncestralCall:IsCastable() and (not v102.Ascendance:IsAvailable() or v13:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (14 + 36)))) or ((756 + 1835) == (4262 - (152 + 701)))) then
					if (((5825 - (430 + 881)) > (1273 + 2051)) and v23(v102.AncestralCall)) then
						return "ancestral_call racial";
					end
				end
			end
			if ((v102.TotemicProjection:IsCastable() and (v102.WindfuryTotem:TimeSinceLastCast() < (985 - (557 + 338))) and v13:BuffDown(v102.WindfuryTotemBuff, true)) or ((62 + 146) >= (13605 - 8777))) then
				if (v23(v104.TotemicProjectionPlayer) or ((5542 - 3959) > (9476 - 5909))) then
					return "totemic_projection wind_fury main 0";
				end
			end
			if ((v102.Windstrike:IsCastable() and v52) or ((2829 - 1516) == (1595 - (499 + 302)))) then
				if (((4040 - (39 + 827)) > (8010 - 5108)) and v23(v102.Windstrike, not v14:IsSpellInRange(v102.Windstrike))) then
					return "windstrike main 1";
				end
			end
			if (((9201 - 5081) <= (16920 - 12660)) and v102.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v117) and (v13:HasTier(47 - 16, 1 + 1))) then
				if (v23(v102.PrimordialWave, not v14:IsSpellInRange(v102.PrimordialWave)) or ((2584 - 1701) > (765 + 4013))) then
					return "primordial_wave main 2";
				end
			end
			if ((v102.FeralSpirit:IsCastable() and v55 and ((v60 and v35) or not v60) and (v99 < v117)) or ((5728 - 2108) >= (4995 - (103 + 1)))) then
				if (((4812 - (475 + 79)) > (2025 - 1088)) and v23(v102.FeralSpirit)) then
					return "feral_spirit main 3";
				end
			end
			if ((v102.Ascendance:IsCastable() and v54 and ((v59 and v35) or not v59) and (v99 < v117) and v14:DebuffUp(v102.FlameShockDebuff) and (((v115 == "Lightning Bolt") and (v112 == (3 - 2))) or ((v115 == "Chain Lightning") and (v112 > (1 + 0))))) or ((4286 + 583) < (2409 - (1395 + 108)))) then
				if (v23(v102.Ascendance) or ((3564 - 2339) > (5432 - (7 + 1197)))) then
					return "ascendance main 4";
				end
			end
			if (((1452 + 1876) > (781 + 1457)) and v102.DoomWinds:IsCastable() and v56 and ((v61 and v35) or not v61) and (v99 < v117)) then
				if (((4158 - (27 + 292)) > (4116 - 2711)) and v23(v102.DoomWinds, not v14:IsInMeleeRange(6 - 1))) then
					return "doom_winds main 5";
				end
			end
			if ((v112 == (4 - 3)) or ((2549 - 1256) <= (965 - 458))) then
				local v228 = 139 - (43 + 96);
				while true do
					if ((v228 == (0 - 0)) or ((6547 - 3651) < (668 + 137))) then
						v32 = v134();
						if (((654 + 1662) == (4577 - 2261)) and v32) then
							return v32;
						end
						break;
					end
				end
			end
			if ((v34 and (v112 > (1 + 0))) or ((4816 - 2246) == (483 + 1050))) then
				local v229 = 0 + 0;
				while true do
					if ((v229 == (1751 - (1414 + 337))) or ((2823 - (1642 + 298)) == (3806 - 2346))) then
						v32 = v135();
						if (v32 or ((13287 - 8668) <= (2964 - 1965))) then
							return v32;
						end
						break;
					end
				end
			end
		end
	end
	local function v138()
		local v151 = 0 + 0;
		while true do
			if ((v151 == (2 + 0)) or ((4382 - (357 + 615)) > (2890 + 1226))) then
				v43 = EpicSettings.Settings['useFrostShock'];
				v44 = EpicSettings.Settings['useIceStrike'];
				v45 = EpicSettings.Settings['useLavaBurst'];
				v46 = EpicSettings.Settings['useLavaLash'];
				v151 = 6 - 3;
			end
			if ((v151 == (0 + 0)) or ((1934 - 1031) >= (2447 + 612))) then
				v54 = EpicSettings.Settings['useAscendance'];
				v56 = EpicSettings.Settings['useDoomWinds'];
				v55 = EpicSettings.Settings['useFeralSpirit'];
				v38 = EpicSettings.Settings['useChainlightning'];
				v151 = 1 + 0;
			end
			if ((v151 == (3 + 1)) or ((5277 - (384 + 917)) < (3554 - (128 + 569)))) then
				v52 = EpicSettings.Settings['useWindstrike'];
				v51 = EpicSettings.Settings['useWindfuryTotem'];
				v53 = EpicSettings.Settings['useWeaponEnchant'];
				v101 = EpicSettings.Settings['useWeapon'];
				v151 = 1548 - (1407 + 136);
			end
			if (((6817 - (687 + 1200)) > (4017 - (556 + 1154))) and (v151 == (3 - 2))) then
				v39 = EpicSettings.Settings['useCrashLightning'];
				v40 = EpicSettings.Settings['useElementalBlast'];
				v41 = EpicSettings.Settings['useFireNova'];
				v42 = EpicSettings.Settings['useFlameShock'];
				v151 = 97 - (9 + 86);
			end
			if ((v151 == (426 - (275 + 146))) or ((658 + 3388) < (1355 - (29 + 35)))) then
				v59 = EpicSettings.Settings['ascendanceWithCD'];
				v61 = EpicSettings.Settings['doomWindsWithCD'];
				v60 = EpicSettings.Settings['feralSpiritWithCD'];
				v63 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v151 = 26 - 20;
			end
			if ((v151 == (8 - 5)) or ((18721 - 14480) == (2309 + 1236))) then
				v47 = EpicSettings.Settings['useLightningBolt'];
				v48 = EpicSettings.Settings['usePrimordialWave'];
				v49 = EpicSettings.Settings['useStormStrike'];
				v50 = EpicSettings.Settings['useSundering'];
				v151 = 1016 - (53 + 959);
			end
			if ((v151 == (414 - (312 + 96))) or ((7025 - 2977) > (4517 - (147 + 138)))) then
				v62 = EpicSettings.Settings['sunderingWithMiniCD'];
				break;
			end
		end
	end
	local function v139()
		local v152 = 899 - (813 + 86);
		while true do
			if ((v152 == (0 + 0)) or ((3242 - 1492) >= (3965 - (18 + 474)))) then
				v66 = EpicSettings.Settings['useWindShear'];
				v67 = EpicSettings.Settings['useCapacitorTotem'];
				v68 = EpicSettings.Settings['useThunderstorm'];
				v70 = EpicSettings.Settings['useAncestralGuidance'];
				v152 = 1 + 0;
			end
			if (((10333 - 7167) == (4252 - (860 + 226))) and (v152 == (305 - (121 + 182)))) then
				v79 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
				v77 = EpicSettings.Settings['astralShiftHP'] or (1240 - (988 + 252));
				v80 = EpicSettings.Settings['healingStreamTotemHP'] or (0 + 0);
				v81 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
				v152 = 1973 - (49 + 1921);
			end
			if (((2653 - (223 + 667)) < (3776 - (51 + 1))) and (v152 == (8 - 3))) then
				v89 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				v90 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
				break;
			end
			if (((121 - 64) <= (3848 - (146 + 979))) and (v152 == (2 + 2))) then
				v86 = EpicSettings.Settings['healOOCHP'] or (605 - (311 + 294));
				v100 = EpicSettings.Settings['usePurgeTarget'];
				v87 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v88 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v152 = 13 - 8;
			end
			if (((1 + 0) == v152) or ((3513 - (496 + 947)) == (1801 - (1233 + 125)))) then
				v69 = EpicSettings.Settings['useAstralShift'];
				v72 = EpicSettings.Settings['useMaelstromHealingSurge'];
				v71 = EpicSettings.Settings['useHealingStreamTotem'];
				v78 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 + 0);
				v152 = 2 + 0;
			end
			if ((v152 == (1 + 2)) or ((4350 - (963 + 682)) == (1163 + 230))) then
				v82 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (1504 - (504 + 1000));
				v75 = EpicSettings.Settings['autoShield'];
				v76 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v85 = EpicSettings.Settings['healOOC'];
				v152 = 3 + 1;
			end
		end
	end
	local function v140()
		v99 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v96 = EpicSettings.Settings['InterruptWithStun'];
		v97 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v98 = EpicSettings.Settings['InterruptThreshold'];
		v92 = EpicSettings.Settings['DispelDebuffs'];
		v91 = EpicSettings.Settings['DispelBuffs'];
		v57 = EpicSettings.Settings['useTrinkets'];
		v58 = EpicSettings.Settings['useRacials'];
		v64 = EpicSettings.Settings['trinketsWithCD'];
		v65 = EpicSettings.Settings['racialsWithCD'];
		v73 = EpicSettings.Settings['useHealthstone'];
		v74 = EpicSettings.Settings['useHealingPotion'];
		v83 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v84 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v95 = EpicSettings.Settings['HealingPotionName'] or "";
		v93 = EpicSettings.Settings['handleAfflicted'];
		v94 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v141()
		local v166 = 0 + 0;
		while true do
			if ((v166 == (0 + 0)) or ((4783 - (156 + 26)) < (36 + 25))) then
				v139();
				v138();
				v140();
				v166 = 1 - 0;
			end
			if (((169 - (149 + 15)) == v166) or ((2350 - (890 + 70)) >= (4861 - (39 + 78)))) then
				if (v13:AffectingCombat() or ((2485 - (14 + 468)) > (8430 - 4596))) then
					if (v13:PrevGCD(2 - 1, v102.ChainLightning) or ((81 + 75) > (2350 + 1563))) then
						v115 = "Chain Lightning";
					elseif (((42 + 153) == (89 + 106)) and v13:PrevGCD(1 + 0, v102.LightningBolt)) then
						v115 = "Lightning Bolt";
					end
				end
				if (((5943 - 2838) >= (1776 + 20)) and not v13:IsChanneling() and not v13:IsChanneling()) then
					if (((15387 - 11008) >= (54 + 2077)) and v93) then
						local v235 = 51 - (12 + 39);
						while true do
							if (((3577 + 267) >= (6323 - 4280)) and (v235 == (0 - 0))) then
								if (v87 or ((959 + 2273) <= (1438 + 1293))) then
									local v238 = 0 - 0;
									while true do
										if (((3268 + 1637) == (23704 - 18799)) and (v238 == (1710 - (1596 + 114)))) then
											v32 = v118.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 104 - 64);
											if (v32 or ((4849 - (164 + 549)) >= (5849 - (1059 + 379)))) then
												return v32;
											end
											break;
										end
									end
								end
								if (v88 or ((3672 - 714) == (2082 + 1935))) then
									v32 = v118.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 6 + 24);
									if (((1620 - (145 + 247)) >= (668 + 145)) and v32) then
										return v32;
									end
								end
								v235 = 1 + 0;
							end
							if ((v235 == (2 - 1)) or ((663 + 2792) > (3489 + 561))) then
								if (((393 - 150) == (963 - (254 + 466))) and v89) then
									local v239 = 560 - (544 + 16);
									while true do
										if ((v239 == (0 - 0)) or ((899 - (294 + 334)) > (1825 - (236 + 17)))) then
											v32 = v118.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 13 + 17);
											if (((2133 + 606) < (12401 - 9108)) and v32) then
												return v32;
											end
											break;
										end
									end
								end
								if (((v13:BuffStack(v102.MaelstromWeaponBuff) >= (23 - 18)) and v90) or ((2030 + 1912) < (934 + 200))) then
									v32 = v118.HandleAfflicted(v102.HealingSurge, v104.HealingSurgeMouseover, 834 - (413 + 381), true);
									if (v32 or ((114 + 2579) == (10576 - 5603))) then
										return v32;
									end
								end
								break;
							end
						end
					end
					if (((5574 - 3428) == (4116 - (582 + 1388))) and v13:AffectingCombat()) then
						local v236 = 0 - 0;
						while true do
							if ((v236 == (0 + 0)) or ((2608 - (326 + 38)) == (9537 - 6313))) then
								v32 = v137();
								if (v32 or ((7000 - 2096) <= (2536 - (47 + 573)))) then
									return v32;
								end
								break;
							end
						end
					else
						v32 = v136();
						if (((32 + 58) <= (4523 - 3458)) and v32) then
							return v32;
						end
					end
				end
				break;
			end
			if (((7793 - 2991) == (6466 - (1269 + 395))) and ((496 - (76 + 416)) == v166)) then
				if (v34 or ((2723 - (319 + 124)) <= (1167 - 656))) then
					local v231 = 1007 - (564 + 443);
					while true do
						if ((v231 == (0 - 0)) or ((2134 - (337 + 121)) <= (1356 - 893))) then
							v113 = #v110;
							v112 = #v111;
							break;
						end
					end
				else
					v113 = 3 - 2;
					v112 = 1912 - (1261 + 650);
				end
				if (((1637 + 2232) == (6165 - 2296)) and v37 and v92) then
					local v232 = 1817 - (772 + 1045);
					while true do
						if (((164 + 994) <= (2757 - (102 + 42))) and (v232 == (1844 - (1524 + 320)))) then
							if ((v13:AffectingCombat() and v102.CleanseSpirit:IsAvailable()) or ((3634 - (1049 + 221)) <= (2155 - (18 + 138)))) then
								local v237 = v92 and v102.CleanseSpirit:IsReady() and v37;
								v32 = v118.FocusUnit(v237, nil, 48 - 28, nil, 1127 - (67 + 1035), v102.HealingSurge);
								if (v32 or ((5270 - (136 + 212)) < (824 - 630))) then
									return v32;
								end
							end
							if (v102.CleanseSpirit:IsAvailable() or ((1676 + 415) < (29 + 2))) then
								if ((v16 and v16:Exists() and v16:IsAPlayer() and v118.UnitHasCurseDebuff(v16)) or ((4034 - (240 + 1364)) >= (5954 - (1050 + 32)))) then
									if (v102.CleanseSpirit:IsReady() or ((17031 - 12261) < (1027 + 708))) then
										if (v23(v104.CleanseSpiritMouseover) or ((5494 - (331 + 724)) <= (190 + 2160))) then
											return "cleanse_spirit mouseover";
										end
									end
								end
							end
							break;
						end
					end
				end
				if (v118.TargetIsValid() or v13:AffectingCombat() or ((5123 - (269 + 375)) < (5191 - (267 + 458)))) then
					local v233 = 0 + 0;
					while true do
						if (((4897 - 2350) > (2043 - (667 + 151))) and (v233 == (1498 - (1410 + 87)))) then
							if (((6568 - (1504 + 393)) > (7227 - 4553)) and (v117 == (28826 - 17715))) then
								v117 = v9.FightRemains(v111, false);
							end
							break;
						end
						if ((v233 == (796 - (461 + 335))) or ((473 + 3223) < (5088 - (1730 + 31)))) then
							v116 = v9.BossFightRemains(nil, true);
							v117 = v116;
							v233 = 1668 - (728 + 939);
						end
					end
				end
				v166 = 17 - 12;
			end
			if (((3 - 1) == v166) or ((10406 - 5864) == (4038 - (138 + 930)))) then
				v37 = EpicSettings.Toggles['dispel'];
				v36 = EpicSettings.Toggles['minicds'];
				if (((231 + 21) <= (1546 + 431)) and v13:IsDeadOrGhost()) then
					return v32;
				end
				v166 = 3 + 0;
			end
			if ((v166 == (4 - 3)) or ((3202 - (459 + 1307)) == (5645 - (474 + 1396)))) then
				v33 = EpicSettings.Toggles['ooc'];
				v34 = EpicSettings.Toggles['aoe'];
				v35 = EpicSettings.Toggles['cds'];
				v166 = 2 - 0;
			end
			if (((3 + 0) == v166) or ((6 + 1612) < (2663 - 1733))) then
				v106, v108, _, _, v107, v109 = v26();
				v110 = v13:GetEnemiesInRange(6 + 34);
				v111 = v13:GetEnemiesInMeleeRange(33 - 23);
				v166 = 17 - 13;
			end
		end
	end
	local function v142()
		local v167 = 591 - (562 + 29);
		while true do
			if (((4027 + 696) > (5572 - (374 + 1045))) and (v167 == (1 + 0))) then
				v20.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
				break;
			end
			if ((v167 == (0 - 0)) or ((4292 - (448 + 190)) >= (1503 + 3151))) then
				v102.FlameShockDebuff:RegisterAuraTracking();
				v122();
				v167 = 1 + 0;
			end
		end
	end
	v20.SetAPL(172 + 91, v141, v142);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

