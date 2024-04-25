local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1 - 0)) or ((3199 - (1019 + 26)) >= (2946 + 379))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((2760 - 1465) >= (3658 - (360 + 65)))) then
			v6 = v0[v4];
			if (((4091 + 286) > (1896 - (79 + 175))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
	end
end
v0["Epix_Shaman_Enhancement.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Player;
	local v15 = v12.Target;
	local v16 = v12.Focus;
	local v17 = v12.Mouseover;
	local v18 = v10.Spell;
	local v19 = v10.MultiSpell;
	local v20 = v10.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Macro;
	local v24 = v21.Press;
	local v25 = v21.Commons.Everyone.num;
	local v26 = v21.Commons.Everyone.bool;
	local v27 = GetWeaponEnchantInfo;
	local v28 = math.max;
	local v29 = math.min;
	local v30 = string.match;
	local v31 = GetTime;
	local v32 = C_Timer;
	local v33;
	local v34 = false;
	local v35 = false;
	local v36 = false;
	local v37 = false;
	local v38 = false;
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
	local v102;
	local v103 = v18.Shaman.Enhancement;
	local v104 = v20.Shaman.Enhancement;
	local v105 = v23.Shaman.Enhancement;
	local v106 = {};
	local v107, v108;
	local v109, v110;
	local v111, v112, v113, v114;
	local v115 = (v103.LavaBurst:IsAvailable() and (2 + 0)) or (2 - 1);
	local v116 = "Lightning Bolt";
	local v117 = 21397 - 10286;
	local v118 = 12010 - (503 + 396);
	local v119 = v21.Commons.Everyone;
	v21.Commons.Shaman = {};
	local v121 = v21.Commons.Shaman;
	v121.FeralSpiritCount = 181 - (92 + 89);
	v10:RegisterForEvent(function()
		v115 = (v103.LavaBurst:IsAvailable() and (3 - 1)) or (1 + 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		local v144 = 0 + 0;
		while true do
			if (((18495 - 13772) > (186 + 1170)) and (v144 == (0 - 0))) then
				v116 = "Lightning Bolt";
				v117 = 9695 + 1416;
				v144 = 1 + 0;
			end
			if ((v144 == (2 - 1)) or ((517 + 3619) <= (5235 - 1802))) then
				v118 = 12355 - (485 + 759);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForSelfCombatEvent(function(...)
		local v145, v146, v146, v146, v146, v146, v146, v146, v147 = select(8 - 4, ...);
		if (((5434 - (442 + 747)) <= (5766 - (832 + 303))) and (v145 == v14:GUID()) and (v147 == (192580 - (88 + 858)))) then
			v121.LastSKCast = v31();
		end
		if (((1304 + 2972) >= (3240 + 674)) and v14:HasTier(2 + 29, 791 - (766 + 23)) and (v145 == v14:GUID()) and (v147 == (1856124 - 1480142))) then
			v121.FeralSpiritCount = v121.FeralSpiritCount + (1 - 0);
			v32.After(39 - 24, function()
				v121.FeralSpiritCount = v121.FeralSpiritCount - (3 - 2);
			end);
		end
		if (((1271 - (1036 + 37)) <= (3095 + 1270)) and (v145 == v14:GUID()) and (v147 == (100354 - 48821))) then
			local v212 = 0 + 0;
			while true do
				if (((6262 - (641 + 839)) > (5589 - (910 + 3))) and (v212 == (0 - 0))) then
					v121.FeralSpiritCount = v121.FeralSpiritCount + (1686 - (1466 + 218));
					v32.After(7 + 8, function()
						v121.FeralSpiritCount = v121.FeralSpiritCount - (1150 - (556 + 592));
					end);
					break;
				end
			end
		end
	end, "SPELL_CAST_SUCCESS");
	local function v123()
		if (((1730 + 3134) > (3005 - (329 + 479))) and v103.CleanseSpirit:IsAvailable()) then
			v119.DispellableDebuffs = v119.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v123();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v124()
		for v208 = 855 - (174 + 680), 20 - 14, 1 - 0 do
			if (v30(v14:TotemName(v208), "Totem") or ((2642 + 1058) == (3246 - (396 + 343)))) then
				return v208;
			end
		end
	end
	local function v125()
		if (((396 + 4078) >= (1751 - (29 + 1448))) and (not v103.AlphaWolf:IsAvailable() or v14:BuffDown(v103.FeralSpiritBuff))) then
			return 1389 - (135 + 1254);
		end
		local v148 = v29(v103.CrashLightning:TimeSinceLastCast(), v103.ChainLightning:TimeSinceLastCast());
		if ((v148 > (30 - 22)) or (v148 > v103.FeralSpirit:TimeSinceLastCast()) or ((8843 - 6949) <= (938 + 468))) then
			return 1527 - (389 + 1138);
		end
		return (582 - (102 + 472)) - v148;
	end
	local function v126(v149)
		return (v149:DebuffRefreshable(v103.FlameShockDebuff));
	end
	local function v127(v150)
		return (v150:DebuffRefreshable(v103.LashingFlamesDebuff));
	end
	local v128 = 0 + 0;
	local function v129()
		if (((872 + 700) >= (1428 + 103)) and v103.CleanseSpirit:IsReady() and v38 and (v119.UnitHasDispellableDebuffByPlayer(v16) or v119.DispellableFriendlyUnit(1570 - (320 + 1225)) or v119.UnitHasCurseDebuff(v16))) then
			local v215 = 0 - 0;
			while true do
				if ((v215 == (0 + 0)) or ((6151 - (157 + 1307)) < (6401 - (821 + 1038)))) then
					if (((8210 - 4919) > (183 + 1484)) and (v128 == (0 - 0))) then
						v128 = v31();
					end
					if (v119.Wait(187 + 313, v128) or ((2163 - 1290) == (3060 - (834 + 192)))) then
						if (v24(v105.CleanseSpiritFocus) or ((180 + 2636) < (3 + 8))) then
							return "cleanse_spirit dispel";
						end
						v128 = 0 + 0;
					end
					break;
				end
			end
		end
	end
	local function v130()
		if (((5729 - 2030) < (5010 - (300 + 4))) and (not v16 or not v16:Exists() or not v16:IsInRange(11 + 29))) then
			return;
		end
		if (((6926 - 4280) >= (1238 - (112 + 250))) and v16) then
			if (((245 + 369) <= (7976 - 4792)) and (v16:HealthPercentage() <= v83) and v73 and v103.HealingSurge:IsReady() and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (3 + 2))) then
				if (((1617 + 1509) == (2338 + 788)) and v24(v105.HealingSurgeFocus)) then
					return "healing_surge heal focus";
				end
			end
		end
	end
	local function v131()
		if ((v14:HealthPercentage() <= v87) or ((1085 + 1102) >= (3681 + 1273))) then
			if (v103.HealingSurge:IsReady() or ((5291 - (1001 + 413)) == (7972 - 4397))) then
				if (((1589 - (244 + 638)) > (1325 - (627 + 66))) and v24(v103.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v132()
		if ((v103.AstralShift:IsReady() and v70 and (v14:HealthPercentage() <= v78)) or ((1626 - 1080) >= (3286 - (512 + 90)))) then
			if (((3371 - (1665 + 241)) <= (5018 - (373 + 344))) and v24(v103.AstralShift)) then
				return "astral_shift defensive 1";
			end
		end
		if (((769 + 935) > (378 + 1047)) and v103.AncestralGuidance:IsReady() and v71 and v119.AreUnitsBelowHealthPercentage(v79, v80, v103.HealingSurge)) then
			if (v24(v103.AncestralGuidance) or ((1812 - 1125) == (7164 - 2930))) then
				return "ancestral_guidance defensive 2";
			end
		end
		if ((v103.HealingStreamTotem:IsReady() and v72 and v119.AreUnitsBelowHealthPercentage(v81, v82, v103.HealingSurge)) or ((4429 - (35 + 1064)) < (1040 + 389))) then
			if (((2453 - 1306) >= (2 + 333)) and v24(v103.HealingStreamTotem)) then
				return "healing_stream_totem defensive 3";
			end
		end
		if (((4671 - (298 + 938)) > (3356 - (233 + 1026))) and v103.HealingSurge:IsReady() and v73 and (v14:HealthPercentage() <= v83) and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (1671 - (636 + 1030)))) then
			if (v24(v103.HealingSurge) or ((1928 + 1842) >= (3948 + 93))) then
				return "healing_surge defensive 4";
			end
		end
		if ((v104.Healthstone:IsReady() and v74 and (v14:HealthPercentage() <= v84)) or ((1127 + 2664) <= (109 + 1502))) then
			if (v24(v105.Healthstone) or ((4799 - (55 + 166)) <= (390 + 1618))) then
				return "healthstone defensive 3";
			end
		end
		if (((114 + 1011) <= (7928 - 5852)) and v75 and (v14:HealthPercentage() <= v85)) then
			if ((v96 == "Refreshing Healing Potion") or ((1040 - (36 + 261)) >= (7692 - 3293))) then
				if (((2523 - (34 + 1334)) < (644 + 1029)) and v104.RefreshingHealingPotion:IsReady()) then
					if (v24(v105.RefreshingHealingPotion) or ((1806 + 518) <= (1861 - (1035 + 248)))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if (((3788 - (20 + 1)) == (1963 + 1804)) and (v96 == "Dreamwalker's Healing Potion")) then
				if (((4408 - (134 + 185)) == (5222 - (549 + 584))) and v104.DreamwalkersHealingPotion:IsReady()) then
					if (((5143 - (314 + 371)) >= (5746 - 4072)) and v24(v105.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v133()
		local v151 = 968 - (478 + 490);
		while true do
			if (((515 + 457) <= (2590 - (786 + 386))) and (v151 == (3 - 2))) then
				v33 = v119.HandleBottomTrinket(v106, v36, 1419 - (1055 + 324), nil);
				if (v33 or ((6278 - (1093 + 247)) < (4232 + 530))) then
					return v33;
				end
				break;
			end
			if ((v151 == (0 + 0)) or ((9941 - 7437) > (14471 - 10207))) then
				v33 = v119.HandleTopTrinket(v106, v36, 113 - 73, nil);
				if (((5410 - 3257) == (766 + 1387)) and v33) then
					return v33;
				end
				v151 = 3 - 2;
			end
		end
	end
	local function v134()
		if ((v103.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v103.WindfuryTotemBuff, true) or (v103.WindfuryTotem:TimeSinceLastCast() > (310 - 220)))) or ((383 + 124) >= (6626 - 4035))) then
			if (((5169 - (364 + 324)) == (12283 - 7802)) and v24(v103.WindfuryTotem)) then
				return "windfury_totem precombat 4";
			end
		end
		if ((v103.FeralSpirit:IsCastable() and v56 and ((v61 and v36) or not v61)) or ((5586 - 3258) < (230 + 463))) then
			if (((18109 - 13781) == (6931 - 2603)) and v24(v103.FeralSpirit)) then
				return "feral_spirit precombat 6";
			end
		end
		if (((4822 - 3234) >= (2600 - (1249 + 19))) and v103.DoomWinds:IsCastable() and v57 and ((v62 and v36) or not v62)) then
			if (v24(v103.DoomWinds, not v15:IsSpellInRange(v103.DoomWinds)) or ((3768 + 406) > (16535 - 12287))) then
				return "doom_winds precombat 8";
			end
		end
		if ((v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63)) or ((5672 - (686 + 400)) <= (65 + 17))) then
			if (((4092 - (73 + 156)) == (19 + 3844)) and v24(v103.Sundering, not v15:IsInRange(816 - (721 + 90)))) then
				return "sundering precombat 10";
			end
		end
		if ((v103.Stormstrike:IsReady() and v50) or ((4 + 278) <= (136 - 94))) then
			if (((5079 - (224 + 246)) >= (1240 - 474)) and v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike))) then
				return "stormstrike precombat 12";
			end
		end
	end
	local function v135()
		local v152 = 0 - 0;
		while true do
			if ((v152 == (1 + 1)) or ((28 + 1124) == (1828 + 660))) then
				if (((6802 - 3380) > (11148 - 7798)) and v103.ChainLightning:IsReady() and v39 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (521 - (203 + 310))) and v14:BuffUp(v103.CracklingThunderBuff) and v103.ElementalSpirits:IsAvailable()) then
					if (((2870 - (1238 + 755)) > (27 + 349)) and v24(v103.ChainLightning, not v15:IsSpellInRange(v103.ChainLightning))) then
						return "chain_lightning single 11";
					end
				end
				if ((v103.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (1542 - (709 + 825))) and ((v121.FeralSpiritCount >= (3 - 1)) or not v103.ElementalSpirits:IsAvailable())) or ((4541 - 1423) <= (2715 - (196 + 668)))) then
					if (v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast)) or ((651 - 486) >= (7233 - 3741))) then
						return "elemental_blast single 12";
					end
				end
				if (((4782 - (171 + 662)) < (4949 - (4 + 89))) and v103.LavaBurst:IsReady() and v46 and not v103.ThorimsInvocation:IsAvailable() and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (17 - 12))) then
					if (v24(v103.LavaBurst, not v15:IsSpellInRange(v103.LavaBurst)) or ((1558 + 2718) < (13246 - 10230))) then
						return "lava_burst single 13";
					end
				end
				if (((1840 + 2850) > (5611 - (35 + 1451))) and v103.LightningBolt:IsReady() and v48 and ((v14:BuffStack(v103.MaelstromWeaponBuff) >= (1461 - (28 + 1425))) or (v103.StaticAccumulation:IsAvailable() and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (1998 - (941 + 1052))))) and v14:BuffDown(v103.PrimordialWaveBuff)) then
					if (v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt)) or ((48 + 2) >= (2410 - (822 + 692)))) then
						return "lightning_bolt single 14";
					end
				end
				if ((v103.CrashLightning:IsReady() and v40 and v103.AlphaWolf:IsAvailable() and v14:BuffUp(v103.FeralSpiritBuff) and (v125() == (0 - 0))) or ((808 + 906) >= (3255 - (45 + 252)))) then
					if (v24(v103.CrashLightning, not v15:IsInMeleeRange(8 + 0)) or ((514 + 977) < (1566 - 922))) then
						return "crash_lightning single 15";
					end
				end
				v152 = 436 - (114 + 319);
			end
			if (((1010 - 306) < (1264 - 277)) and (v152 == (4 + 1))) then
				if (((5539 - 1821) > (3993 - 2087)) and v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v118)) then
					if (v24(v103.Sundering, not v15:IsInRange(1971 - (556 + 1407))) or ((2164 - (741 + 465)) > (4100 - (170 + 295)))) then
						return "sundering single 26";
					end
				end
				if (((1845 + 1656) <= (4127 + 365)) and v103.BagofTricks:IsReady() and v59 and ((v66 and v36) or not v66)) then
					if (v24(v103.BagofTricks) or ((8474 - 5032) < (2113 + 435))) then
						return "bag_of_tricks single 27";
					end
				end
				if (((1844 + 1031) >= (830 + 634)) and v103.FireNova:IsReady() and v42 and v103.SwirlingMaelstrom:IsAvailable() and v15:DebuffUp(v103.FlameShockDebuff) and (v14:BuffStack(v103.MaelstromWeaponBuff) < ((1235 - (957 + 273)) + ((2 + 3) * v25(v103.OverflowingMaelstrom:IsAvailable()))))) then
					if (v24(v103.FireNova) or ((1921 + 2876) >= (18644 - 13751))) then
						return "fire_nova single 28";
					end
				end
				if ((v103.LightningBolt:IsReady() and v48 and v103.Hailstorm:IsAvailable() and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (13 - 8)) and v14:BuffDown(v103.PrimordialWaveBuff)) or ((1682 - 1131) > (10240 - 8172))) then
					if (((3894 - (389 + 1391)) > (593 + 351)) and v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt))) then
						return "lightning_bolt single 29";
					end
				end
				if ((v103.FrostShock:IsReady() and v44) or ((236 + 2026) >= (7048 - 3952))) then
					if (v24(v103.FrostShock, not v15:IsSpellInRange(v103.FrostShock)) or ((3206 - (783 + 168)) >= (11870 - 8333))) then
						return "frost_shock single 30";
					end
				end
				v152 = 6 + 0;
			end
			if (((318 - (309 + 2)) == v152) or ((11782 - 7945) < (2518 - (1090 + 122)))) then
				if (((957 + 1993) == (9907 - 6957)) and v103.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v103.WindfuryTotemBuff, true) or (v103.WindfuryTotem:TimeSinceLastCast() > (62 + 28)))) then
					if (v24(v103.WindfuryTotem) or ((5841 - (628 + 490)) < (592 + 2706))) then
						return "windfury_totem single 37";
					end
				end
				break;
			end
			if (((2812 - 1676) >= (703 - 549)) and (v152 == (777 - (431 + 343)))) then
				if ((v103.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v118)) or ((547 - 276) > (13735 - 8987))) then
					if (((3745 + 995) >= (404 + 2748)) and v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave))) then
						return "primordial_wave single 16";
					end
				end
				if ((v103.FlameShock:IsReady() and v43 and (v15:DebuffDown(v103.FlameShockDebuff))) or ((4273 - (556 + 1139)) >= (3405 - (6 + 9)))) then
					if (((8 + 33) <= (851 + 810)) and v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock))) then
						return "flame_shock single 17";
					end
				end
				if (((770 - (28 + 141)) < (1379 + 2181)) and v103.IceStrike:IsReady() and v45 and v103.ElementalAssault:IsAvailable() and v103.SwirlingMaelstrom:IsAvailable()) then
					if (((290 - 55) < (487 + 200)) and v24(v103.IceStrike, not v15:IsInMeleeRange(1322 - (486 + 831)))) then
						return "ice_strike single 18";
					end
				end
				if (((11837 - 7288) > (4059 - 2906)) and v103.LavaLash:IsReady() and v47 and (v103.LashingFlames:IsAvailable())) then
					if (v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash)) or ((884 + 3790) < (14772 - 10100))) then
						return "lava_lash single 19";
					end
				end
				if (((4931 - (668 + 595)) < (4105 + 456)) and v103.IceStrike:IsReady() and v45 and (v14:BuffDown(v103.IceStrikeBuff))) then
					if (v24(v103.IceStrike, not v15:IsInMeleeRange(2 + 3)) or ((1240 - 785) == (3895 - (23 + 267)))) then
						return "ice_strike single 20";
					end
				end
				v152 = 1948 - (1129 + 815);
			end
			if (((393 - (371 + 16)) == v152) or ((4413 - (1326 + 424)) == (6272 - 2960))) then
				if (((15629 - 11352) <= (4593 - (88 + 30))) and v103.CrashLightning:IsReady() and v40) then
					if (v24(v103.CrashLightning, not v15:IsInMeleeRange(779 - (720 + 51))) or ((1935 - 1065) == (2965 - (421 + 1355)))) then
						return "crash_lightning single 31";
					end
				end
				if (((2561 - 1008) <= (1539 + 1594)) and v103.FireNova:IsReady() and v42 and (v15:DebuffUp(v103.FlameShockDebuff))) then
					if (v24(v103.FireNova) or ((3320 - (286 + 797)) >= (12834 - 9323))) then
						return "fire_nova single 32";
					end
				end
				if ((v103.FlameShock:IsReady() and v43) or ((2192 - 868) > (3459 - (397 + 42)))) then
					if (v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock)) or ((935 + 2057) == (2681 - (24 + 776)))) then
						return "flame_shock single 34";
					end
				end
				if (((4784 - 1678) > (2311 - (222 + 563))) and v103.ChainLightning:IsReady() and v39 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (11 - 6)) and v14:BuffUp(v103.CracklingThunderBuff) and v103.ElementalSpirits:IsAvailable()) then
					if (((2177 + 846) < (4060 - (23 + 167))) and v24(v103.ChainLightning, not v15:IsSpellInRange(v103.ChainLightning))) then
						return "chain_lightning single 35";
					end
				end
				if (((1941 - (690 + 1108)) > (27 + 47)) and v103.LightningBolt:IsReady() and v48 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (5 + 0)) and v14:BuffDown(v103.PrimordialWaveBuff)) then
					if (((866 - (40 + 808)) < (348 + 1764)) and v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt))) then
						return "lightning_bolt single 36";
					end
				end
				v152 = 26 - 19;
			end
			if (((1049 + 48) <= (862 + 766)) and (v152 == (1 + 0))) then
				if (((5201 - (47 + 524)) == (3005 + 1625)) and v103.Stormstrike:IsReady() and v50 and (v14:BuffUp(v103.DoomWindsBuff) or v103.DeeplyRootedElements:IsAvailable() or (v103.Stormblast:IsAvailable() and v14:BuffUp(v103.StormbringerBuff)))) then
					if (((9676 - 6136) > (4011 - 1328)) and v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike))) then
						return "stormstrike single 6";
					end
				end
				if (((10932 - 6138) >= (5001 - (1165 + 561))) and v103.LavaLash:IsReady() and v47 and (v14:BuffUp(v103.HotHandBuff))) then
					if (((45 + 1439) == (4595 - 3111)) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
						return "lava_lash single 7";
					end
				end
				if (((547 + 885) < (4034 - (341 + 138))) and v103.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v103.WindfuryTotemBuff, true))) then
					if (v24(v103.WindfuryTotem) or ((288 + 777) > (7383 - 3805))) then
						return "windfury_totem single 8";
					end
				end
				if ((v103.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (331 - (89 + 237))) and (v103.ElementalBlast:Charges() == v115)) or ((15425 - 10630) < (2961 - 1554))) then
					if (((2734 - (581 + 300)) < (6033 - (855 + 365))) and v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast))) then
						return "elemental_blast single 9";
					end
				end
				if ((v103.LightningBolt:IsReady() and v48 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (18 - 10)) and v14:BuffUp(v103.PrimordialWaveBuff) and (v14:BuffDown(v103.SplinteredElementsBuff) or (v118 <= (4 + 8)))) or ((4056 - (1030 + 205)) < (2283 + 148))) then
					if (v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt)) or ((2674 + 200) < (2467 - (156 + 130)))) then
						return "lightning_bolt single 10";
					end
				end
				v152 = 4 - 2;
			end
			if ((v152 == (6 - 2)) or ((5506 - 2817) <= (91 + 252))) then
				if ((v103.FrostShock:IsReady() and v44 and (v14:BuffUp(v103.HailstormBuff))) or ((1090 + 779) == (2078 - (10 + 59)))) then
					if (v24(v103.FrostShock, not v15:IsSpellInRange(v103.FrostShock)) or ((1003 + 2543) < (11435 - 9113))) then
						return "frost_shock single 21";
					end
				end
				if ((v103.LavaLash:IsReady() and v47) or ((3245 - (671 + 492)) == (3800 + 973))) then
					if (((4459 - (369 + 846)) > (280 + 775)) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
						return "lava_lash single 22";
					end
				end
				if ((v103.IceStrike:IsReady() and v45) or ((2828 + 485) <= (3723 - (1036 + 909)))) then
					if (v24(v103.IceStrike, not v15:IsInMeleeRange(4 + 1)) or ((2385 - 964) >= (2307 - (11 + 192)))) then
						return "ice_strike single 23";
					end
				end
				if (((916 + 896) <= (3424 - (135 + 40))) and v103.Windstrike:IsCastable() and v53) then
					if (((3932 - 2309) <= (1180 + 777)) and v24(v103.Windstrike, not v15:IsSpellInRange(v103.Windstrike))) then
						return "windstrike single 24";
					end
				end
				if (((9719 - 5307) == (6613 - 2201)) and v103.Stormstrike:IsReady() and v50) then
					if (((1926 - (50 + 126)) >= (2344 - 1502)) and v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike))) then
						return "stormstrike single 25";
					end
				end
				v152 = 2 + 3;
			end
			if (((5785 - (1233 + 180)) > (2819 - (522 + 447))) and (v152 == (1421 - (107 + 1314)))) then
				if (((108 + 124) < (2501 - 1680)) and v103.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v118) and v15:DebuffDown(v103.FlameShockDebuff) and v103.LashingFlames:IsAvailable()) then
					if (((221 + 297) < (1790 - 888)) and v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave))) then
						return "primordial_wave single 1";
					end
				end
				if (((11846 - 8852) > (2768 - (716 + 1194))) and v103.FlameShock:IsReady() and v43 and v15:DebuffDown(v103.FlameShockDebuff) and v103.LashingFlames:IsAvailable()) then
					if (v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock)) or ((65 + 3690) <= (99 + 816))) then
						return "flame_shock single 2";
					end
				end
				if (((4449 - (74 + 429)) > (7220 - 3477)) and v103.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (3 + 2)) and v103.ElementalSpirits:IsAvailable() and (v121.FeralSpiritCount >= (8 - 4))) then
					if (v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast)) or ((945 + 390) >= (10191 - 6885))) then
						return "elemental_blast single 3";
					end
				end
				if (((11976 - 7132) > (2686 - (279 + 154))) and v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v118) and (v14:HasTier(808 - (454 + 324), 2 + 0))) then
					if (((469 - (12 + 5)) == (244 + 208)) and v24(v103.Sundering, not v15:IsInRange(20 - 12))) then
						return "sundering single 4";
					end
				end
				if ((v103.LightningBolt:IsReady() and v48 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (2 + 3)) and v14:BuffDown(v103.CracklingThunderBuff) and v14:BuffUp(v103.AscendanceBuff) and (v116 == "Chain Lightning") and (v14:BuffRemains(v103.AscendanceBuff) > (v103.ChainLightning:CooldownRemains() + v14:GCD()))) or ((5650 - (277 + 816)) < (8917 - 6830))) then
					if (((5057 - (1058 + 125)) == (727 + 3147)) and v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt))) then
						return "lightning_bolt single 5";
					end
				end
				v152 = 976 - (815 + 160);
			end
		end
	end
	local function v136()
		local v153 = 0 - 0;
		while true do
			if ((v153 == (9 - 5)) or ((463 + 1475) > (14425 - 9490))) then
				if ((v103.FlameShock:IsReady() and v43 and v15:DebuffRefreshable(v103.FlameShockDebuff) and (v103.FireNova:IsAvailable() or v103.PrimordialWave:IsAvailable()) and (v103.FlameShockDebuff:AuraActiveCount() < v113) and (v103.FlameShockDebuff:AuraActiveCount() < (1904 - (41 + 1857)))) or ((6148 - (1222 + 671)) < (8846 - 5423))) then
					local v224 = 0 - 0;
					while true do
						if (((2636 - (229 + 953)) <= (4265 - (1111 + 663))) and (v224 == (1579 - (874 + 705)))) then
							if (v119.CastCycle(v103.FlameShock, v112, v126, not v15:IsSpellInRange(v103.FlameShock)) or ((582 + 3575) <= (1913 + 890))) then
								return "flame_shock aoe 17";
							end
							if (((10087 - 5234) >= (84 + 2898)) and v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock))) then
								return "flame_shock aoe no_cycle 17";
							end
							break;
						end
					end
				end
				if (((4813 - (642 + 37)) > (766 + 2591)) and v103.FireNova:IsReady() and v42 and (v103.FlameShockDebuff:AuraActiveCount() >= (1 + 2))) then
					if (v24(v103.FireNova) or ((8579 - 5162) < (2988 - (233 + 221)))) then
						return "fire_nova aoe 18";
					end
				end
				if ((v103.Stormstrike:IsReady() and v50 and v14:BuffUp(v103.CrashLightningBuff) and (v103.DeeplyRootedElements:IsAvailable() or (v14:BuffStack(v103.ConvergingStormsBuff) == (13 - 7)))) or ((2396 + 326) <= (1705 - (718 + 823)))) then
					if (v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike)) or ((1516 + 892) < (2914 - (266 + 539)))) then
						return "stormstrike aoe 19";
					end
				end
				if ((v103.CrashLightning:IsReady() and v40 and v103.CrashingStorms:IsAvailable() and v14:BuffUp(v103.CLCrashLightningBuff) and (v113 >= (11 - 7))) or ((1258 - (636 + 589)) == (3453 - 1998))) then
					if (v24(v103.CrashLightning, not v15:IsInMeleeRange(16 - 8)) or ((352 + 91) >= (1459 + 2556))) then
						return "crash_lightning aoe 20";
					end
				end
				v153 = 1020 - (657 + 358);
			end
			if (((8954 - 5572) > (378 - 212)) and (v153 == (1194 - (1151 + 36)))) then
				if ((v103.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v103.WindfuryTotemBuff, true) or (v103.WindfuryTotem:TimeSinceLastCast() > (87 + 3)))) or ((74 + 206) == (9135 - 6076))) then
					if (((3713 - (1552 + 280)) > (2127 - (64 + 770))) and v24(v103.WindfuryTotem)) then
						return "windfury_totem aoe 29";
					end
				end
				if (((1601 + 756) == (5350 - 2993)) and v103.FlameShock:IsReady() and v43 and (v15:DebuffDown(v103.FlameShockDebuff))) then
					if (((22 + 101) == (1366 - (157 + 1086))) and v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock))) then
						return "flame_shock aoe 30";
					end
				end
				if ((v103.FrostShock:IsReady() and v44 and not v103.Hailstorm:IsAvailable()) or ((2113 - 1057) >= (14855 - 11463))) then
					if (v24(v103.FrostShock, not v15:IsSpellInRange(v103.FrostShock)) or ((1657 - 576) < (1466 - 391))) then
						return "frost_shock aoe 31";
					end
				end
				break;
			end
			if ((v153 == (822 - (599 + 220))) or ((2088 - 1039) >= (6363 - (1813 + 118)))) then
				if ((v103.IceStrike:IsReady() and v45 and (v103.Hailstorm:IsAvailable())) or ((3486 + 1282) <= (2063 - (841 + 376)))) then
					if (v24(v103.IceStrike, not v15:IsInMeleeRange(6 - 1)) or ((781 + 2577) <= (3875 - 2455))) then
						return "ice_strike aoe 13";
					end
				end
				if ((v103.FrostShock:IsReady() and v44 and v103.Hailstorm:IsAvailable() and v14:BuffUp(v103.HailstormBuff)) or ((4598 - (464 + 395)) <= (7712 - 4707))) then
					if (v24(v103.FrostShock, not v15:IsSpellInRange(v103.FrostShock)) or ((797 + 862) >= (2971 - (467 + 370)))) then
						return "frost_shock aoe 14";
					end
				end
				if ((v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v118)) or ((6736 - 3476) < (1729 + 626))) then
					if (v24(v103.Sundering, not v15:IsInRange(27 - 19)) or ((105 + 564) == (9824 - 5601))) then
						return "sundering aoe 15";
					end
				end
				if ((v103.FlameShock:IsReady() and v43 and v103.MoltenAssault:IsAvailable() and v15:DebuffDown(v103.FlameShockDebuff)) or ((2212 - (150 + 370)) < (1870 - (74 + 1208)))) then
					if (v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock)) or ((11798 - 7001) < (17315 - 13664))) then
						return "flame_shock aoe 16";
					end
				end
				v153 = 3 + 1;
			end
			if ((v153 == (395 - (14 + 376))) or ((7244 - 3067) > (3139 + 1711))) then
				if ((v103.Windstrike:IsCastable() and v53) or ((352 + 48) > (1060 + 51))) then
					if (((8939 - 5888) > (757 + 248)) and v24(v103.Windstrike, not v15:IsSpellInRange(v103.Windstrike))) then
						return "windstrike aoe 21";
					end
				end
				if (((3771 - (23 + 55)) <= (10384 - 6002)) and v103.Stormstrike:IsReady() and v50) then
					if (v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike)) or ((2191 + 1091) > (3682 + 418))) then
						return "stormstrike aoe 22";
					end
				end
				if ((v103.IceStrike:IsReady() and v45) or ((5550 - 1970) < (895 + 1949))) then
					if (((990 - (652 + 249)) < (12015 - 7525)) and v24(v103.IceStrike, not v15:IsInMeleeRange(1873 - (708 + 1160)))) then
						return "ice_strike aoe 23";
					end
				end
				if ((v103.LavaLash:IsReady() and v47) or ((13525 - 8542) < (3296 - 1488))) then
					if (((3856 - (10 + 17)) > (847 + 2922)) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
						return "lava_lash aoe 24";
					end
				end
				v153 = 1738 - (1400 + 332);
			end
			if (((2848 - 1363) <= (4812 - (242 + 1666))) and (v153 == (1 + 0))) then
				if (((1565 + 2704) == (3639 + 630)) and v103.FlameShock:IsReady() and v43 and (v103.PrimordialWave:IsAvailable() or v103.FireNova:IsAvailable()) and v15:DebuffDown(v103.FlameShockDebuff)) then
					if (((1327 - (850 + 90)) <= (4872 - 2090)) and v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock))) then
						return "flame_shock aoe 5";
					end
				end
				if ((v103.ElementalBlast:IsReady() and v41 and (not v103.ElementalSpirits:IsAvailable() or (v103.ElementalSpirits:IsAvailable() and ((v103.ElementalBlast:Charges() == v115) or (v121.FeralSpiritCount >= (1392 - (360 + 1030)))))) and (v14:BuffStack(v103.MaelstromWeaponBuff) == (5 + 0 + ((13 - 8) * v25(v103.OverflowingMaelstrom:IsAvailable())))) and (not v103.CrashingStorms:IsAvailable() or (v113 <= (3 - 0)))) or ((3560 - (909 + 752)) <= (2140 - (109 + 1114)))) then
					if (v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast)) or ((7893 - 3581) <= (341 + 535))) then
						return "elemental_blast aoe 6";
					end
				end
				if (((2474 - (6 + 236)) <= (1636 + 960)) and v103.ChainLightning:IsReady() and v39 and (v14:BuffStack(v103.MaelstromWeaponBuff) == (5 + 0 + ((11 - 6) * v25(v103.OverflowingMaelstrom:IsAvailable()))))) then
					if (((3659 - 1564) < (4819 - (1076 + 57))) and v24(v103.ChainLightning, not v15:IsSpellInRange(v103.ChainLightning))) then
						return "chain_lightning aoe 7";
					end
				end
				if ((v103.CrashLightning:IsReady() and v40 and (v14:BuffUp(v103.DoomWindsBuff) or v14:BuffDown(v103.CrashLightningBuff) or (v103.AlphaWolf:IsAvailable() and v14:BuffUp(v103.FeralSpiritBuff) and (v125() == (0 + 0))))) or ((2284 - (579 + 110)) >= (354 + 4120))) then
					if (v24(v103.CrashLightning, not v15:IsInMeleeRange(8 + 0)) or ((2452 + 2167) < (3289 - (174 + 233)))) then
						return "crash_lightning aoe 8";
					end
				end
				v153 = 5 - 3;
			end
			if (((0 - 0) == v153) or ((131 + 163) >= (6005 - (663 + 511)))) then
				if (((1811 + 218) <= (670 + 2414)) and v103.CrashLightning:IsReady() and v40 and v103.CrashingStorms:IsAvailable() and ((v103.UnrulyWinds:IsAvailable() and (v113 >= (30 - 20))) or (v113 >= (10 + 5)))) then
					if (v24(v103.CrashLightning, not v15:IsInMeleeRange(18 - 10)) or ((4930 - 2893) == (1155 + 1265))) then
						return "crash_lightning aoe 1";
					end
				end
				if (((8676 - 4218) > (2783 + 1121)) and v103.LightningBolt:IsReady() and v48 and ((v103.FlameShockDebuff:AuraActiveCount() >= v113) or (v14:BuffRemains(v103.PrimordialWaveBuff) < (v14:GCD() * (1 + 2))) or (v103.FlameShockDebuff:AuraActiveCount() >= (728 - (478 + 244)))) and v14:BuffUp(v103.PrimordialWaveBuff) and (v14:BuffStack(v103.MaelstromWeaponBuff) == ((522 - (440 + 77)) + ((3 + 2) * v25(v103.OverflowingMaelstrom:IsAvailable())))) and (v14:BuffDown(v103.SplinteredElementsBuff) or (v118 <= (43 - 31)) or (v100 <= v14:GCD()))) then
					if (((1992 - (655 + 901)) >= (23 + 100)) and v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt))) then
						return "lightning_bolt aoe 2";
					end
				end
				if (((383 + 117) < (1227 + 589)) and v103.LavaLash:IsReady() and v47 and v103.MoltenAssault:IsAvailable() and (v103.PrimordialWave:IsAvailable() or v103.FireNova:IsAvailable()) and v15:DebuffUp(v103.FlameShockDebuff) and (v103.FlameShockDebuff:AuraActiveCount() < v113) and (v103.FlameShockDebuff:AuraActiveCount() < (24 - 18))) then
					if (((5019 - (695 + 750)) == (12204 - 8630)) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
						return "lava_lash aoe 3";
					end
				end
				if (((340 - 119) < (1568 - 1178)) and v103.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v118) and (v14:BuffDown(v103.PrimordialWaveBuff))) then
					local v225 = 351 - (285 + 66);
					while true do
						if ((v225 == (0 - 0)) or ((3523 - (682 + 628)) <= (230 + 1191))) then
							if (((3357 - (176 + 123)) < (2033 + 2827)) and v119.CastCycle(v103.PrimordialWave, v112, v126, not v15:IsSpellInRange(v103.PrimordialWave))) then
								return "primordial_wave aoe 4";
							end
							if (v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave)) or ((941 + 355) >= (4715 - (239 + 30)))) then
								return "primordial_wave aoe no_cycle 4";
							end
							break;
						end
					end
				end
				v153 = 1 + 0;
			end
			if ((v153 == (2 + 0)) or ((2464 - 1071) > (14004 - 9515))) then
				if ((v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v118) and (v14:BuffUp(v103.DoomWindsBuff) or v14:HasTier(345 - (306 + 9), 6 - 4))) or ((770 + 3654) < (17 + 10))) then
					if (v24(v103.Sundering, not v15:IsInRange(4 + 4)) or ((5710 - 3713) > (5190 - (1140 + 235)))) then
						return "sundering aoe 9";
					end
				end
				if (((2206 + 1259) > (1755 + 158)) and v103.FireNova:IsReady() and v42 and ((v103.FlameShockDebuff:AuraActiveCount() >= (2 + 4)) or ((v103.FlameShockDebuff:AuraActiveCount() >= (56 - (33 + 19))) and (v103.FlameShockDebuff:AuraActiveCount() >= v113)))) then
					if (((265 + 468) < (5451 - 3632)) and v24(v103.FireNova)) then
						return "fire_nova aoe 10";
					end
				end
				if ((v103.LavaLash:IsReady() and v47 and (v103.LashingFlames:IsAvailable())) or ((1937 + 2458) == (9324 - 4569))) then
					if (v119.CastCycle(v103.LavaLash, v112, v127, not v15:IsSpellInRange(v103.LavaLash)) or ((3557 + 236) < (3058 - (586 + 103)))) then
						return "lava_lash aoe 11";
					end
					if (v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash)) or ((372 + 3712) == (815 - 550))) then
						return "lava_lash aoe no_cycle 11";
					end
				end
				if (((5846 - (1309 + 179)) == (7867 - 3509)) and v103.LavaLash:IsReady() and v47 and ((v103.MoltenAssault:IsAvailable() and v15:DebuffUp(v103.FlameShockDebuff) and (v103.FlameShockDebuff:AuraActiveCount() < v113) and (v103.FlameShockDebuff:AuraActiveCount() < (3 + 3))) or (v103.AshenCatalyst:IsAvailable() and (v14:BuffStack(v103.AshenCatalystBuff) == (13 - 8))))) then
					if (v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash)) or ((2371 + 767) < (2109 - 1116))) then
						return "lava_lash aoe 12";
					end
				end
				v153 = 5 - 2;
			end
			if (((3939 - (295 + 314)) > (5705 - 3382)) and (v153 == (1968 - (1300 + 662)))) then
				if ((v103.CrashLightning:IsReady() and v40) or ((11385 - 7759) == (5744 - (1178 + 577)))) then
					if (v24(v103.CrashLightning, not v15:IsInMeleeRange(5 + 3)) or ((2707 - 1791) == (4076 - (851 + 554)))) then
						return "crash_lightning aoe 25";
					end
				end
				if (((241 + 31) == (753 - 481)) and v103.FireNova:IsReady() and v42 and (v103.FlameShockDebuff:AuraActiveCount() >= (3 - 1))) then
					if (((4551 - (115 + 187)) <= (3706 + 1133)) and v24(v103.FireNova)) then
						return "fire_nova aoe 26";
					end
				end
				if (((2629 + 148) < (12610 - 9410)) and v103.ElementalBlast:IsReady() and v41 and (not v103.ElementalSpirits:IsAvailable() or (v103.ElementalSpirits:IsAvailable() and ((v103.ElementalBlast:Charges() == v115) or (v121.FeralSpiritCount >= (1163 - (160 + 1001)))))) and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (5 + 0)) and (not v103.CrashingStorms:IsAvailable() or (v113 <= (3 + 0)))) then
					if (((194 - 99) < (2315 - (237 + 121))) and v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast))) then
						return "elemental_blast aoe 27";
					end
				end
				if (((1723 - (525 + 372)) < (3255 - 1538)) and v103.ChainLightning:IsReady() and v39 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (16 - 11))) then
					if (((1568 - (96 + 46)) >= (1882 - (643 + 134))) and v24(v103.ChainLightning, not v15:IsSpellInRange(v103.ChainLightning))) then
						return "chain_lightning aoe 28";
					end
				end
				v153 = 3 + 4;
			end
		end
	end
	local function v137()
		if (((6603 - 3849) <= (12545 - 9166)) and v76 and v103.EarthShield:IsCastable() and v14:BuffDown(v103.EarthShieldBuff) and ((v77 == "Earth Shield") or (v103.ElementalOrbit:IsAvailable() and v14:BuffUp(v103.LightningShield)))) then
			if (v24(v103.EarthShield) or ((3767 + 160) == (2772 - 1359))) then
				return "earth_shield main 2";
			end
		elseif ((v76 and v103.LightningShield:IsCastable() and v14:BuffDown(v103.LightningShieldBuff) and ((v77 == "Lightning Shield") or (v103.ElementalOrbit:IsAvailable() and v14:BuffUp(v103.EarthShield)))) or ((2358 - 1204) <= (1507 - (316 + 403)))) then
			if (v24(v103.LightningShield) or ((1093 + 550) > (9290 - 5911))) then
				return "lightning_shield main 2";
			end
		end
		if (((not v107 or (v109 < (216839 + 383161))) and v54 and v103.WindfuryWeapon:IsCastable()) or ((7058 - 4255) > (3224 + 1325))) then
			if (v24(v103.WindfuryWeapon) or ((71 + 149) >= (10470 - 7448))) then
				return "windfury_weapon enchant";
			end
		end
		if (((13477 - 10655) == (5862 - 3040)) and (not v108 or (v110 < (34348 + 565652))) and v54 and v103.FlametongueWeapon:IsCastable()) then
			if (v24(v103.FlametongueWeapon) or ((2088 - 1027) == (91 + 1766))) then
				return "flametongue_weapon enchant";
			end
		end
		if (((8120 - 5360) > (1381 - (12 + 5))) and v86) then
			local v216 = 0 - 0;
			while true do
				if ((v216 == (0 - 0)) or ((10419 - 5517) <= (8915 - 5320))) then
					v33 = v131();
					if (v33 or ((782 + 3070) == (2266 - (1656 + 317)))) then
						return v33;
					end
					break;
				end
			end
		end
		if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) or ((1390 + 169) == (3677 + 911))) then
			if (v24(v103.AncestralSpirit, nil, true) or ((11922 - 7438) == (3878 - 3090))) then
				return "resurrection";
			end
		end
		if (((4922 - (5 + 349)) >= (18557 - 14650)) and v119.TargetIsValid() and v34) then
			if (((2517 - (266 + 1005)) < (2287 + 1183)) and not v14:AffectingCombat()) then
				v33 = v134();
				if (((13880 - 9812) >= (1279 - 307)) and v33) then
					return v33;
				end
			end
		end
	end
	local function v138()
		local v154 = 1696 - (561 + 1135);
		while true do
			if (((641 - 148) < (12796 - 8903)) and (v154 == (1070 - (507 + 559)))) then
				if (v33 or ((3696 - 2223) >= (10304 - 6972))) then
					return v33;
				end
				if (v119.TargetIsValid() or ((4439 - (212 + 176)) <= (2062 - (250 + 655)))) then
					local v226 = 0 - 0;
					local v227;
					while true do
						if (((1054 - 450) < (4507 - 1626)) and (v226 == (1956 - (1869 + 87)))) then
							v227 = v119.HandleDPSPotion(v14:BuffUp(v103.FeralSpiritBuff));
							if (v227 or ((3121 - 2221) == (5278 - (484 + 1417)))) then
								return v227;
							end
							if (((9557 - 5098) > (990 - 399)) and (v100 < v118)) then
								if (((4171 - (48 + 725)) >= (3912 - 1517)) and v58 and ((v36 and v65) or not v65)) then
									v33 = v133();
									if (v33 or ((5856 - 3673) >= (1642 + 1182))) then
										return v33;
									end
								end
							end
							if (((5173 - 3237) == (542 + 1394)) and (v100 < v118) and v59 and ((v66 and v36) or not v66)) then
								if ((v103.BloodFury:IsCastable() and (not v103.Ascendance:IsAvailable() or v14:BuffUp(v103.AscendanceBuff) or (v103.Ascendance:CooldownRemains() > (15 + 35)))) or ((5685 - (152 + 701)) < (5624 - (430 + 881)))) then
									if (((1566 + 2522) > (4769 - (557 + 338))) and v24(v103.BloodFury)) then
										return "blood_fury racial";
									end
								end
								if (((1281 + 3051) == (12207 - 7875)) and v103.Berserking:IsCastable() and (not v103.Ascendance:IsAvailable() or v14:BuffUp(v103.AscendanceBuff))) then
									if (((14003 - 10004) >= (7704 - 4804)) and v24(v103.Berserking)) then
										return "berserking racial";
									end
								end
								if ((v103.Fireblood:IsCastable() and (not v103.Ascendance:IsAvailable() or v14:BuffUp(v103.AscendanceBuff) or (v103.Ascendance:CooldownRemains() > (107 - 57)))) or ((3326 - (499 + 302)) > (4930 - (39 + 827)))) then
									if (((12066 - 7695) == (9761 - 5390)) and v24(v103.Fireblood)) then
										return "fireblood racial";
									end
								end
								if ((v103.AncestralCall:IsCastable() and (not v103.Ascendance:IsAvailable() or v14:BuffUp(v103.AscendanceBuff) or (v103.Ascendance:CooldownRemains() > (198 - 148)))) or ((407 - 141) > (427 + 4559))) then
									if (((5827 - 3836) >= (148 + 777)) and v24(v103.AncestralCall)) then
										return "ancestral_call racial";
									end
								end
							end
							v226 = 1 - 0;
						end
						if (((559 - (103 + 1)) < (2607 - (475 + 79))) and ((2 - 1) == v226)) then
							if ((v103.TotemicProjection:IsCastable() and (v103.WindfuryTotem:TimeSinceLastCast() < (288 - 198)) and v14:BuffDown(v103.WindfuryTotemBuff, true)) or ((107 + 719) == (4270 + 581))) then
								if (((1686 - (1395 + 108)) == (532 - 349)) and v24(v105.TotemicProjectionPlayer)) then
									return "totemic_projection wind_fury main 0";
								end
							end
							if (((2363 - (7 + 1197)) <= (780 + 1008)) and v103.Windstrike:IsCastable() and v53) then
								if (v24(v103.Windstrike, not v15:IsSpellInRange(v103.Windstrike)) or ((1224 + 2283) > (4637 - (27 + 292)))) then
									return "windstrike main 1";
								end
							end
							if ((v103.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v118) and (v14:HasTier(90 - 59, 2 - 0))) or ((12895 - 9820) <= (5846 - 2881))) then
								if (((2599 - 1234) <= (2150 - (43 + 96))) and v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave))) then
									return "primordial_wave main 2";
								end
							end
							if ((v103.FeralSpirit:IsCastable() and v56 and ((v61 and v36) or not v61) and (v100 < v118)) or ((11323 - 8547) > (8082 - 4507))) then
								if (v24(v103.FeralSpirit) or ((2120 + 434) == (1357 + 3447))) then
									return "feral_spirit main 3";
								end
							end
							v226 = 3 - 1;
						end
						if (((988 + 1589) == (4829 - 2252)) and (v226 == (1 + 1))) then
							if ((v103.Ascendance:IsCastable() and v55 and ((v60 and v36) or not v60) and (v100 < v118) and v15:DebuffUp(v103.FlameShockDebuff) and (((v116 == "Lightning Bolt") and (v113 == (1 + 0))) or ((v116 == "Chain Lightning") and (v113 > (1752 - (1414 + 337)))))) or ((1946 - (1642 + 298)) >= (4923 - 3034))) then
								if (((1455 - 949) <= (5614 - 3722)) and v24(v103.Ascendance)) then
									return "ascendance main 4";
								end
							end
							if ((v103.DoomWinds:IsCastable() and v57 and ((v62 and v36) or not v62) and (v100 < v118)) or ((661 + 1347) > (1726 + 492))) then
								if (((1351 - (357 + 615)) <= (2911 + 1236)) and v24(v103.DoomWinds, not v15:IsInMeleeRange(11 - 6))) then
									return "doom_winds main 5";
								end
							end
							if ((v113 == (1 + 0)) or ((9673 - 5159) <= (807 + 202))) then
								v33 = v135();
								if (v33 or ((238 + 3258) == (750 + 442))) then
									return v33;
								end
							end
							if ((v35 and (v113 > (1302 - (384 + 917)))) or ((905 - (128 + 569)) == (4502 - (1407 + 136)))) then
								local v236 = 1887 - (687 + 1200);
								while true do
									if (((5987 - (556 + 1154)) >= (4619 - 3306)) and (v236 == (95 - (9 + 86)))) then
										v33 = v136();
										if (((3008 - (275 + 146)) < (517 + 2657)) and v33) then
											return v33;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v154 == (67 - (29 + 35))) or ((18259 - 14139) <= (6564 - 4366))) then
				if ((v103.Purge:IsReady() and v101 and v38 and v92 and not v14:IsCasting() and not v14:IsChanneling() and v119.UnitHasMagicBuff(v15)) or ((7045 - 5449) == (559 + 299))) then
					if (((4232 - (53 + 959)) == (3628 - (312 + 96))) and v24(v103.Purge, not v15:IsSpellInRange(v103.Purge))) then
						return "purge damage";
					end
				end
				v33 = v130();
				v154 = 6 - 2;
			end
			if ((v154 == (285 - (147 + 138))) or ((2301 - (813 + 86)) > (3272 + 348))) then
				v33 = v132();
				if (((4768 - 2194) == (3066 - (18 + 474))) and v33) then
					return v33;
				end
				v154 = 1 + 0;
			end
			if (((5868 - 4070) < (3843 - (860 + 226))) and (v154 == (305 - (121 + 182)))) then
				if (v93 or ((47 + 330) > (3844 - (988 + 252)))) then
					local v228 = 0 + 0;
					while true do
						if (((178 + 390) < (2881 - (49 + 1921))) and ((890 - (223 + 667)) == v228)) then
							if (((3337 - (51 + 1)) < (7277 - 3049)) and v16) then
								v33 = v129();
								if (((8385 - 4469) > (4453 - (146 + 979))) and v33) then
									return v33;
								end
							end
							if (((706 + 1794) < (4444 - (311 + 294))) and v17 and v17:Exists() and not v14:CanAttack(v17) and (v119.UnitHasDispellableDebuffByPlayer(v17) or v119.UnitHasCurseDebuff(v17))) then
								if (((1413 - 906) == (215 + 292)) and v103.CleanseSpirit:IsCastable()) then
									if (((1683 - (496 + 947)) <= (4523 - (1233 + 125))) and v24(v105.CleanseSpiritMouseover, not v17:IsSpellInRange(v103.PurifySpirit))) then
										return "purify_spirit dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				if (((339 + 495) >= (723 + 82)) and v103.GreaterPurge:IsAvailable() and v101 and v103.GreaterPurge:IsReady() and v38 and v92 and not v14:IsCasting() and not v14:IsChanneling() and v119.UnitHasMagicBuff(v15)) then
					if (v24(v103.GreaterPurge, not v15:IsSpellInRange(v103.GreaterPurge)) or ((725 + 3087) < (3961 - (963 + 682)))) then
						return "greater_purge damage";
					end
				end
				v154 = 3 + 0;
			end
			if ((v154 == (1505 - (504 + 1000))) or ((1786 + 866) <= (1397 + 136))) then
				if (v94 or ((340 + 3258) < (2152 - 692))) then
					local v229 = 0 + 0;
					while true do
						if (((0 + 0) == v229) or ((4298 - (156 + 26)) < (687 + 505))) then
							if (v88 or ((5283 - 1906) <= (1067 - (149 + 15)))) then
								v33 = v119.HandleAfflicted(v103.CleanseSpirit, v105.CleanseSpiritMouseover, 1000 - (890 + 70));
								if (((4093 - (39 + 78)) >= (921 - (14 + 468))) and v33) then
									return v33;
								end
							end
							if (((8250 - 4498) == (10486 - 6734)) and v89) then
								v33 = v119.HandleAfflicted(v103.TremorTotem, v103.TremorTotem, 16 + 14);
								if (((2430 + 1616) > (573 + 2122)) and v33) then
									return v33;
								end
							end
							v229 = 1 + 0;
						end
						if (((1 + 0) == v229) or ((6785 - 3240) == (3160 + 37))) then
							if (((8412 - 6018) > (10 + 363)) and v90) then
								v33 = v119.HandleAfflicted(v103.PoisonCleansingTotem, v103.PoisonCleansingTotem, 81 - (12 + 39));
								if (((3866 + 289) <= (13099 - 8867)) and v33) then
									return v33;
								end
							end
							if (((v14:BuffStack(v103.MaelstromWeaponBuff) >= (17 - 12)) and v91) or ((1062 + 2519) == (1829 + 1644))) then
								local v237 = 0 - 0;
								while true do
									if (((3327 + 1668) > (16180 - 12832)) and ((1710 - (1596 + 114)) == v237)) then
										v33 = v119.HandleAfflicted(v103.HealingSurge, v105.HealingSurgeMouseover, 104 - 64, true);
										if (v33 or ((1467 - (164 + 549)) > (5162 - (1059 + 379)))) then
											return v33;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (((269 - 52) >= (30 + 27)) and v95) then
					v33 = v119.HandleIncorporeal(v103.Hex, v105.HexMouseOver, 6 + 24, true);
					if (v33 or ((2462 - (145 + 247)) >= (3313 + 724))) then
						return v33;
					end
				end
				v154 = 1 + 1;
			end
		end
	end
	local function v139()
		v55 = EpicSettings.Settings['useAscendance'];
		v57 = EpicSettings.Settings['useDoomWinds'];
		v56 = EpicSettings.Settings['useFeralSpirit'];
		v39 = EpicSettings.Settings['useChainlightning'];
		v40 = EpicSettings.Settings['useCrashLightning'];
		v41 = EpicSettings.Settings['useElementalBlast'];
		v42 = EpicSettings.Settings['useFireNova'];
		v43 = EpicSettings.Settings['useFlameShock'];
		v44 = EpicSettings.Settings['useFrostShock'];
		v45 = EpicSettings.Settings['useIceStrike'];
		v46 = EpicSettings.Settings['useLavaBurst'];
		v47 = EpicSettings.Settings['useLavaLash'];
		v48 = EpicSettings.Settings['useLightningBolt'];
		v49 = EpicSettings.Settings['usePrimordialWave'];
		v50 = EpicSettings.Settings['useStormStrike'];
		v51 = EpicSettings.Settings['useSundering'];
		v53 = EpicSettings.Settings['useWindstrike'];
		v52 = EpicSettings.Settings['useWindfuryTotem'];
		v54 = EpicSettings.Settings['useWeaponEnchant'];
		v102 = EpicSettings.Settings['useWeapon'];
		v60 = EpicSettings.Settings['ascendanceWithCD'];
		v62 = EpicSettings.Settings['doomWindsWithCD'];
		v61 = EpicSettings.Settings['feralSpiritWithCD'];
		v64 = EpicSettings.Settings['primordialWaveWithMiniCD'];
		v63 = EpicSettings.Settings['sunderingWithMiniCD'];
	end
	local function v140()
		v67 = EpicSettings.Settings['useWindShear'];
		v68 = EpicSettings.Settings['useCapacitorTotem'];
		v69 = EpicSettings.Settings['useThunderstorm'];
		v71 = EpicSettings.Settings['useAncestralGuidance'];
		v70 = EpicSettings.Settings['useAstralShift'];
		v73 = EpicSettings.Settings['useMaelstromHealingSurge'];
		v72 = EpicSettings.Settings['useHealingStreamTotem'];
		v79 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 - 0);
		v80 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
		v78 = EpicSettings.Settings['astralShiftHP'] or (0 + 0);
		v81 = EpicSettings.Settings['healingStreamTotemHP'] or (0 - 0);
		v82 = EpicSettings.Settings['healingStreamTotemGroup'] or (720 - (254 + 466));
		v83 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (560 - (544 + 16));
		v76 = EpicSettings.Settings['autoShield'];
		v77 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
		v86 = EpicSettings.Settings['healOOC'];
		v87 = EpicSettings.Settings['healOOCHP'] or (0 - 0);
		v101 = EpicSettings.Settings['usePurgeTarget'];
		v88 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
		v89 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v90 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
		v91 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
	end
	local function v141()
		v100 = EpicSettings.Settings['fightRemainsCheck'] or (628 - (294 + 334));
		v97 = EpicSettings.Settings['InterruptWithStun'];
		v98 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v99 = EpicSettings.Settings['InterruptThreshold'];
		v93 = EpicSettings.Settings['DispelDebuffs'];
		v92 = EpicSettings.Settings['DispelBuffs'];
		v58 = EpicSettings.Settings['useTrinkets'];
		v59 = EpicSettings.Settings['useRacials'];
		v65 = EpicSettings.Settings['trinketsWithCD'];
		v66 = EpicSettings.Settings['racialsWithCD'];
		v74 = EpicSettings.Settings['useHealthstone'];
		v75 = EpicSettings.Settings['useHealingPotion'];
		v84 = EpicSettings.Settings['healthstoneHP'] or (253 - (236 + 17));
		v85 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
		v96 = EpicSettings.Settings['HealingPotionName'] or "";
		v94 = EpicSettings.Settings['handleAfflicted'];
		v95 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v142()
		local v207 = 0 + 0;
		while true do
			if (((10187 - 7482) == (12806 - 10101)) and (v207 == (3 + 1))) then
				if (((51 + 10) == (855 - (413 + 381))) and v35) then
					local v230 = 0 + 0;
					while true do
						if ((v230 == (0 - 0)) or ((1815 - 1116) >= (3266 - (582 + 1388)))) then
							v114 = #v111;
							v113 = #v112;
							break;
						end
					end
				else
					v114 = 1 - 0;
					v113 = 1 + 0;
				end
				if ((v38 and v93) or ((2147 - (326 + 38)) >= (10696 - 7080))) then
					if ((v14:AffectingCombat() and v103.CleanseSpirit:IsAvailable()) or ((5585 - 1672) > (5147 - (47 + 573)))) then
						local v234 = 0 + 0;
						local v235;
						while true do
							if (((18585 - 14209) > (1325 - 508)) and (v234 == (1665 - (1269 + 395)))) then
								if (((5353 - (76 + 416)) > (1267 - (319 + 124))) and v33) then
									return v33;
								end
								break;
							end
							if ((v234 == (0 - 0)) or ((2390 - (564 + 443)) >= (5899 - 3768))) then
								v235 = v93 and v103.CleanseSpirit:IsReady() and v38;
								v33 = v119.FocusUnit(v235, nil, 478 - (337 + 121), nil, 73 - 48, v103.HealingSurge);
								v234 = 3 - 2;
							end
						end
					end
				end
				if (v119.TargetIsValid() or v14:AffectingCombat() or ((3787 - (1261 + 650)) >= (1076 + 1465))) then
					local v231 = 0 - 0;
					while true do
						if (((3599 - (772 + 1045)) <= (533 + 3239)) and (v231 == (144 - (102 + 42)))) then
							v117 = v10.BossFightRemains(nil, true);
							v118 = v117;
							v231 = 1845 - (1524 + 320);
						end
						if ((v231 == (1271 - (1049 + 221))) or ((4856 - (18 + 138)) < (1989 - 1176))) then
							if (((4301 - (67 + 1035)) < (4398 - (136 + 212))) and (v118 == (47215 - 36104))) then
								v118 = v10.FightRemains(v112, false);
							end
							break;
						end
					end
				end
				v207 = 5 + 0;
			end
			if (((0 + 0) == v207) or ((6555 - (240 + 1364)) < (5512 - (1050 + 32)))) then
				v140();
				v139();
				v141();
				v207 = 3 - 2;
			end
			if (((57 + 39) == (1151 - (331 + 724))) and (v207 == (1 + 1))) then
				v38 = EpicSettings.Toggles['dispel'];
				v37 = EpicSettings.Toggles['minicds'];
				if (v14:IsDeadOrGhost() or ((3383 - (269 + 375)) > (4733 - (267 + 458)))) then
					return v33;
				end
				v207 = 1 + 2;
			end
			if ((v207 == (5 - 2)) or ((841 - (667 + 151)) == (2631 - (1410 + 87)))) then
				v107, v109, _, _, v108, v110 = v27();
				v111 = v14:GetEnemiesInRange(1937 - (1504 + 393));
				v112 = v14:GetEnemiesInMeleeRange(27 - 17);
				v207 = 10 - 6;
			end
			if ((v207 == (801 - (461 + 335))) or ((345 + 2348) >= (5872 - (1730 + 31)))) then
				if (v14:AffectingCombat() or ((5983 - (728 + 939)) <= (7600 - 5454))) then
					if (v14:PrevGCD(1 - 0, v103.ChainLightning) or ((8124 - 4578) <= (3877 - (138 + 930)))) then
						v116 = "Chain Lightning";
					elseif (((4482 + 422) > (1694 + 472)) and v14:PrevGCD(1 + 0, v103.LightningBolt)) then
						v116 = "Lightning Bolt";
					end
				end
				if (((444 - 335) >= (1856 - (459 + 1307))) and not v14:IsChanneling() and not v14:IsChanneling()) then
					local v232 = 1870 - (474 + 1396);
					while true do
						if (((8692 - 3714) > (2723 + 182)) and (v232 == (0 + 0))) then
							if (v94 or ((8667 - 5641) <= (289 + 1991))) then
								if (v88 or ((5518 - 3865) <= (4832 - 3724))) then
									local v239 = 591 - (562 + 29);
									while true do
										if (((2481 + 428) > (4028 - (374 + 1045))) and (v239 == (0 + 0))) then
											v33 = v119.HandleAfflicted(v103.CleanseSpirit, v105.CleanseSpiritMouseover, 124 - 84);
											if (((1395 - (448 + 190)) > (63 + 131)) and v33) then
												return v33;
											end
											break;
										end
									end
								end
								if (v89 or ((14 + 17) >= (911 + 487))) then
									local v240 = 0 - 0;
									while true do
										if (((9930 - 6734) <= (6366 - (1307 + 187))) and (v240 == (0 - 0))) then
											v33 = v119.HandleAfflicted(v103.TremorTotem, v103.TremorTotem, 70 - 40);
											if (((10198 - 6872) == (4009 - (232 + 451))) and v33) then
												return v33;
											end
											break;
										end
									end
								end
								if (((1369 + 64) <= (3426 + 452)) and v90) then
									local v241 = 564 - (510 + 54);
									while true do
										if ((v241 == (0 - 0)) or ((1619 - (13 + 23)) == (3381 - 1646))) then
											v33 = v119.HandleAfflicted(v103.PoisonCleansingTotem, v103.PoisonCleansingTotem, 43 - 13);
											if (v33 or ((5415 - 2434) == (3438 - (830 + 258)))) then
												return v33;
											end
											break;
										end
									end
								end
								if (((v14:BuffStack(v103.MaelstromWeaponBuff) >= (17 - 12)) and v91) or ((2795 + 1671) <= (420 + 73))) then
									local v242 = 1441 - (860 + 581);
									while true do
										if ((v242 == (0 - 0)) or ((2022 + 525) <= (2228 - (237 + 4)))) then
											v33 = v119.HandleAfflicted(v103.HealingSurge, v105.HealingSurgeMouseover, 94 - 54, true);
											if (((7491 - 4530) > (5195 - 2455)) and v33) then
												return v33;
											end
											break;
										end
									end
								end
							end
							if (((3026 + 670) >= (2075 + 1537)) and v14:AffectingCombat()) then
								local v238 = 0 - 0;
								while true do
									if ((v238 == (0 + 0)) or ((1616 + 1354) == (3304 - (85 + 1341)))) then
										v33 = v138();
										if (v33 or ((6301 - 2608) < (5583 - 3606))) then
											return v33;
										end
										break;
									end
								end
							else
								v33 = v137();
								if (v33 or ((1302 - (45 + 327)) > (3964 - 1863))) then
									return v33;
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((4655 - (444 + 58)) > (1342 + 1744)) and (v207 == (1 + 0))) then
				v34 = EpicSettings.Toggles['ooc'];
				v35 = EpicSettings.Toggles['aoe'];
				v36 = EpicSettings.Toggles['cds'];
				v207 = 1 + 1;
			end
		end
	end
	local function v143()
		v103.FlameShockDebuff:RegisterAuraTracking();
		v123();
		v21.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(761 - 498, v142, v143);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

