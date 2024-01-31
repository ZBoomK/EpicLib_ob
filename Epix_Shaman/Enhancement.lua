local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((457 - 259) <= (5554 - (442 + 747))) and (v5 == (1135 - (832 + 303)))) then
			v6 = v0[v4];
			if (((5728 - (88 + 858)) > (1426 + 3250)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((201 + 4663) > (2986 - (766 + 23))) and (v5 == (4 - 3))) then
			return v6(...);
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
	local v102 = v18.Shaman.Enhancement;
	local v103 = v20.Shaman.Enhancement;
	local v104 = v23.Shaman.Enhancement;
	local v105 = {};
	local v106, v107;
	local v108, v109;
	local v110, v111, v112, v113;
	local v114 = (v102.LavaBurst:IsAvailable() and (2 - 0)) or (2 - 1);
	local v115 = "Lightning Bolt";
	local v116 = 37711 - 26600;
	local v117 = 12184 - (1036 + 37);
	local v118 = v21.Commons.Everyone;
	v21.Commons.Shaman = {};
	local v120 = v21.Commons.Shaman;
	v120.FeralSpiritCount = 0 + 0;
	v10:RegisterForEvent(function()
		v114 = (v102.LavaBurst:IsAvailable() and (3 - 1)) or (1 + 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		v115 = "Lightning Bolt";
		v116 = 12591 - (641 + 839);
		v117 = 12024 - (910 + 3);
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForSelfCombatEvent(function(...)
		local v147, v148, v148, v148, v148, v148, v148, v148, v149 = select(9 - 5, ...);
		if (((v147 == v14:GUID()) and (v149 == (193318 - (1466 + 218)))) or ((1701 + 1999) == (3655 - (556 + 592)))) then
			v120.LastSKCast = v31();
		end
		if (((1591 + 2883) >= (1082 - (329 + 479))) and v14:HasTier(885 - (174 + 680), 6 - 4) and (v147 == v14:GUID()) and (v149 == (779310 - 403328))) then
			v120.FeralSpiritCount = v120.FeralSpiritCount + 1 + 0;
			v32.After(754 - (396 + 343), function()
				v120.FeralSpiritCount = v120.FeralSpiritCount - (1 + 0);
			end);
		end
		if (((v147 == v14:GUID()) and (v149 == (53010 - (29 + 1448)))) or ((3283 - (135 + 1254)) <= (5296 - 3890))) then
			local v198 = 0 - 0;
			while true do
				if (((1048 + 524) >= (3058 - (389 + 1138))) and (v198 == (574 - (102 + 472)))) then
					v120.FeralSpiritCount = v120.FeralSpiritCount + 2 + 0;
					v32.After(9 + 6, function()
						v120.FeralSpiritCount = v120.FeralSpiritCount - (2 + 0);
					end);
					break;
				end
			end
		end
	end, "SPELL_CAST_SUCCESS");
	local function v122()
		if (v102.CleanseSpirit:IsAvailable() or ((6232 - (320 + 1225)) < (8085 - 3543))) then
			v118.DispellableDebuffs = v118.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123()
		for v194 = 1 + 0, 1470 - (157 + 1307), 1860 - (821 + 1038) do
			if (((8210 - 4919) > (183 + 1484)) and v30(v14:TotemName(v194), "Totem")) then
				return v194;
			end
		end
	end
	local function v124()
		local v150 = 0 - 0;
		local v151;
		while true do
			if (((1 + 0) == v150) or ((2163 - 1290) == (3060 - (834 + 192)))) then
				if ((v151 > (1 + 7)) or (v151 > v102.FeralSpirit:TimeSinceLastCast()) or ((723 + 2093) < (1 + 10))) then
					return 0 - 0;
				end
				return (312 - (300 + 4)) - v151;
			end
			if (((988 + 2711) < (12319 - 7613)) and (v150 == (362 - (112 + 250)))) then
				if (((1055 + 1591) >= (2194 - 1318)) and (not v102.AlphaWolf:IsAvailable() or v14:BuffDown(v102.FeralSpiritBuff))) then
					return 0 + 0;
				end
				v151 = v29(v102.CrashLightning:TimeSinceLastCast(), v102.ChainLightning:TimeSinceLastCast());
				v150 = 1 + 0;
			end
		end
	end
	local function v125(v152)
		return (v152:DebuffRefreshable(v102.FlameShockDebuff));
	end
	local function v126(v153)
		return (v153:DebuffRefreshable(v102.LashingFlamesDebuff));
	end
	local function v127(v154)
		return (v154:DebuffRemains(v102.FlameShockDebuff));
	end
	local function v128(v155)
		return (v14:BuffDown(v102.PrimordialWaveBuff));
	end
	local function v129(v156)
		return (v15:DebuffRemains(v102.LashingFlamesDebuff));
	end
	local function v130(v157)
		return (v102.LashingFlames:IsAvailable());
	end
	local function v131(v158)
		return v158:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (5 + 1));
	end
	local function v132()
		if (((305 + 309) <= (2366 + 818)) and v102.CleanseSpirit:IsReady() and v38 and v118.DispellableFriendlyUnit(1439 - (1001 + 413))) then
			v118.Wait(2 - 1);
			if (((4008 - (244 + 638)) == (3819 - (627 + 66))) and v24(v104.CleanseSpiritFocus)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v133()
		if (not v16 or not v16:Exists() or not v16:IsInRange(119 - 79) or ((2789 - (512 + 90)) >= (6860 - (1665 + 241)))) then
			return;
		end
		if (v16 or ((4594 - (373 + 344)) == (1613 + 1962))) then
			if (((188 + 519) > (1666 - 1034)) and (v16:HealthPercentage() <= v83) and v73 and v102.HealingSurge:IsReady() and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (8 - 3))) then
				if (v24(v104.HealingSurgeFocus) or ((1645 - (35 + 1064)) >= (1953 + 731))) then
					return "healing_surge heal focus";
				end
			end
		end
	end
	local function v134()
		if (((3134 - 1669) <= (18 + 4283)) and (v14:HealthPercentage() <= v87)) then
			if (((2940 - (298 + 938)) > (2684 - (233 + 1026))) and v102.HealingSurge:IsReady()) then
				if (v24(v102.HealingSurge) or ((2353 - (636 + 1030)) == (2165 + 2069))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v135()
		local v159 = 0 + 0;
		while true do
			if ((v159 == (0 + 0)) or ((225 + 3105) < (1650 - (55 + 166)))) then
				if (((223 + 924) >= (34 + 301)) and v102.AstralShift:IsReady() and v70 and (v14:HealthPercentage() <= v78)) then
					if (((13118 - 9683) > (2394 - (36 + 261))) and v24(v102.AstralShift)) then
						return "astral_shift defensive 1";
					end
				end
				if ((v102.AncestralGuidance:IsReady() and v71 and v118.AreUnitsBelowHealthPercentage(v79, v80)) or ((6593 - 2823) >= (5409 - (34 + 1334)))) then
					if (v24(v102.AncestralGuidance) or ((1458 + 2333) <= (1252 + 359))) then
						return "ancestral_guidance defensive 2";
					end
				end
				v159 = 1284 - (1035 + 248);
			end
			if ((v159 == (23 - (20 + 1))) or ((2386 + 2192) <= (2327 - (134 + 185)))) then
				if (((2258 - (549 + 584)) <= (2761 - (314 + 371))) and v103.Healthstone:IsReady() and v74 and (v14:HealthPercentage() <= v84)) then
					if (v24(v104.Healthstone) or ((2550 - 1807) >= (5367 - (478 + 490)))) then
						return "healthstone defensive 3";
					end
				end
				if (((612 + 543) < (2845 - (786 + 386))) and v75 and (v14:HealthPercentage() <= v85)) then
					local v234 = 0 - 0;
					while true do
						if ((v234 == (1379 - (1055 + 324))) or ((3664 - (1093 + 247)) <= (514 + 64))) then
							if (((397 + 3370) == (14955 - 11188)) and (v96 == "Refreshing Healing Potion")) then
								if (((13876 - 9787) == (11634 - 7545)) and v103.RefreshingHealingPotion:IsReady()) then
									if (((11202 - 6744) >= (596 + 1078)) and v24(v104.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((3744 - 2772) <= (4887 - 3469)) and (v96 == "Dreamwalker's Healing Potion")) then
								if (v103.DreamwalkersHealingPotion:IsReady() or ((3724 + 1214) < (12178 - 7416))) then
									if (v24(v104.RefreshingHealingPotion) or ((3192 - (364 + 324)) > (11689 - 7425))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((5166 - 3013) == (714 + 1439)) and (v159 == (4 - 3))) then
				if ((v102.HealingStreamTotem:IsReady() and v72 and v118.AreUnitsBelowHealthPercentage(v81, v82)) or ((811 - 304) >= (7869 - 5278))) then
					if (((5749 - (1249 + 19)) == (4045 + 436)) and v24(v102.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v102.HealingSurge:IsReady() and v73 and (v14:HealthPercentage() <= v83) and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (19 - 14))) or ((3414 - (686 + 400)) < (544 + 149))) then
					if (((4557 - (73 + 156)) == (21 + 4307)) and v24(v102.HealingSurge)) then
						return "healing_surge defensive 4";
					end
				end
				v159 = 813 - (721 + 90);
			end
		end
	end
	local function v136()
		local v160 = 0 + 0;
		while true do
			if (((5155 - 3567) >= (1802 - (224 + 246))) and (v160 == (0 - 0))) then
				v33 = v118.HandleTopTrinket(v105, v36, 73 - 33, nil);
				if (v33 or ((758 + 3416) > (102 + 4146))) then
					return v33;
				end
				v160 = 1 + 0;
			end
			if ((v160 == (1 - 0)) or ((15261 - 10675) <= (595 - (203 + 310)))) then
				v33 = v118.HandleBottomTrinket(v105, v36, 2033 - (1238 + 755), nil);
				if (((270 + 3593) == (5397 - (709 + 825))) and v33) then
					return v33;
				end
				break;
			end
		end
	end
	local function v137()
		if ((v102.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (165 - 75)))) or ((410 - 128) <= (906 - (196 + 668)))) then
			if (((18197 - 13588) >= (1586 - 820)) and v24(v102.WindfuryTotem)) then
				return "windfury_totem precombat 4";
			end
		end
		if ((v102.FeralSpirit:IsCastable() and v56 and ((v61 and v36) or not v61)) or ((1985 - (171 + 662)) == (2581 - (4 + 89)))) then
			if (((11993 - 8571) > (1220 + 2130)) and v24(v102.FeralSpirit)) then
				return "feral_spirit precombat 6";
			end
		end
		if (((3851 - 2974) > (148 + 228)) and v102.DoomWinds:IsCastable() and v57 and ((v62 and v36) or not v62)) then
			if (v24(v102.DoomWinds, not v15:IsSpellInRange(v102.DoomWinds)) or ((4604 - (35 + 1451)) <= (3304 - (28 + 1425)))) then
				return "doom_winds precombat 8";
			end
		end
		if ((v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63)) or ((2158 - (941 + 1052)) >= (3349 + 143))) then
			if (((5463 - (822 + 692)) < (6932 - 2076)) and v24(v102.Sundering, not v15:IsInRange(3 + 2))) then
				return "sundering precombat 10";
			end
		end
		if ((v102.Stormstrike:IsReady() and v50) or ((4573 - (45 + 252)) < (2985 + 31))) then
			if (((1615 + 3075) > (10039 - 5914)) and v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike))) then
				return "stormstrike precombat 12";
			end
		end
	end
	local function v138()
		local v161 = 433 - (114 + 319);
		while true do
			if ((v161 == (0 - 0)) or ((64 - 14) >= (572 + 324))) then
				if ((v102.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v117) and v15:DebuffDown(v102.FlameShockDebuff) and v102.LashingFlames:IsAvailable()) or ((2553 - 839) >= (6197 - 3239))) then
					if (v24(v102.PrimordialWave, not v15:IsSpellInRange(v102.PrimordialWave)) or ((3454 - (556 + 1407)) < (1850 - (741 + 465)))) then
						return "primordial_wave single 1";
					end
				end
				if (((1169 - (170 + 295)) < (521 + 466)) and v102.FlameShock:IsReady() and v43 and v15:DebuffDown(v102.FlameShockDebuff) and v102.LashingFlames:IsAvailable()) then
					if (((3416 + 302) > (4692 - 2786)) and v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock single 2";
					end
				end
				if ((v102.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (5 + 0)) and v102.ElementalSpirits:IsAvailable() and (v120.FeralSpiritCount >= (3 + 1))) or ((543 + 415) > (4865 - (957 + 273)))) then
					if (((937 + 2564) <= (1799 + 2693)) and v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast))) then
						return "elemental_blast single 3";
					end
				end
				if ((v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v117) and (v14:HasTier(114 - 84, 5 - 3))) or ((10513 - 7071) < (12616 - 10068))) then
					if (((4655 - (389 + 1391)) >= (919 + 545)) and v24(v102.Sundering, not v15:IsInRange(1 + 7))) then
						return "sundering single 4";
					end
				end
				v161 = 2 - 1;
			end
			if ((v161 == (954 - (783 + 168))) or ((16099 - 11302) >= (4813 + 80))) then
				if ((v102.LavaBurst:IsReady() and v46 and not v102.ThorimsInvocation:IsAvailable() and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (316 - (309 + 2)))) or ((1691 - 1140) > (3280 - (1090 + 122)))) then
					if (((686 + 1428) > (3170 - 2226)) and v24(v102.LavaBurst, not v15:IsSpellInRange(v102.LavaBurst))) then
						return "lava_burst single 13";
					end
				end
				if ((v102.LightningBolt:IsReady() and v48 and ((v14:BuffStack(v102.MaelstromWeaponBuff) >= (6 + 2)) or (v102.StaticAccumulation:IsAvailable() and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (1123 - (628 + 490))))) and v14:BuffDown(v102.PrimordialWaveBuff)) or ((406 + 1856) >= (7665 - 4569))) then
					if (v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt)) or ((10305 - 8050) >= (4311 - (431 + 343)))) then
						return "lightning_bolt single 14";
					end
				end
				if ((v102.CrashLightning:IsReady() and v40 and v102.AlphaWolf:IsAvailable() and v14:BuffUp(v102.FeralSpiritBuff) and (v124() == (0 - 0))) or ((11099 - 7262) < (1032 + 274))) then
					if (((378 + 2572) == (4645 - (556 + 1139))) and v24(v102.CrashLightning, not v15:IsInMeleeRange(23 - (6 + 9)))) then
						return "crash_lightning single 15";
					end
				end
				if ((v102.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v117)) or ((865 + 3858) < (1690 + 1608))) then
					if (((1305 - (28 + 141)) >= (60 + 94)) and v24(v102.PrimordialWave, not v15:IsSpellInRange(v102.PrimordialWave))) then
						return "primordial_wave single 16";
					end
				end
				v161 = 4 - 0;
			end
			if ((v161 == (2 + 0)) or ((1588 - (486 + 831)) > (12355 - 7607))) then
				if (((16687 - 11947) >= (596 + 2556)) and v102.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (15 - 10)) and (v102.ElementalBlast:Charges() == v114)) then
					if (v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast)) or ((3841 - (668 + 595)) >= (3051 + 339))) then
						return "elemental_blast single 9";
					end
				end
				if (((9 + 32) <= (4529 - 2868)) and v102.LightningBolt:IsReady() and v48 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (298 - (23 + 267))) and v14:BuffUp(v102.PrimordialWaveBuff) and (v14:BuffDown(v102.SplinteredElementsBuff) or (v117 <= (1956 - (1129 + 815))))) then
					if (((988 - (371 + 16)) < (5310 - (1326 + 424))) and v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt))) then
						return "lightning_bolt single 10";
					end
				end
				if (((444 - 209) < (2510 - 1823)) and v102.ChainLightning:IsReady() and v39 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (126 - (88 + 30))) and v14:BuffUp(v102.CracklingThunderBuff) and v102.ElementalSpirits:IsAvailable()) then
					if (((5320 - (720 + 51)) > (2564 - 1411)) and v24(v102.ChainLightning, not v15:IsSpellInRange(v102.ChainLightning))) then
						return "chain_lightning single 11";
					end
				end
				if ((v102.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (1784 - (421 + 1355))) and ((v120.FeralSpiritCount >= (2 - 0)) or not v102.ElementalSpirits:IsAvailable())) or ((2296 + 2378) < (5755 - (286 + 797)))) then
					if (((13408 - 9740) < (7554 - 2993)) and v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast))) then
						return "elemental_blast single 12";
					end
				end
				v161 = 442 - (397 + 42);
			end
			if ((v161 == (1 + 0)) or ((1255 - (24 + 776)) == (5553 - 1948))) then
				if ((v102.LightningBolt:IsReady() and v48 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (790 - (222 + 563))) and v14:BuffDown(v102.CracklingThunderBuff) and v14:BuffUp(v102.AscendanceBuff) and (v115 == "Chain Lightning") and (v14:BuffRemains(v102.AscendanceBuff) > (v102.ChainLightning:CooldownRemains() + v14:GCD()))) or ((5867 - 3204) == (2385 + 927))) then
					if (((4467 - (23 + 167)) <= (6273 - (690 + 1108))) and v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt))) then
						return "lightning_bolt single 5";
					end
				end
				if ((v102.Stormstrike:IsReady() and v50 and (v14:BuffUp(v102.DoomWindsBuff) or v102.DeeplyRootedElements:IsAvailable() or (v102.Stormblast:IsAvailable() and v14:BuffUp(v102.StormbringerBuff)))) or ((314 + 556) == (981 + 208))) then
					if (((2401 - (40 + 808)) <= (516 + 2617)) and v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike))) then
						return "stormstrike single 6";
					end
				end
				if ((v102.LavaLash:IsReady() and v47 and (v14:BuffUp(v102.HotHandBuff))) or ((8554 - 6317) >= (3356 + 155))) then
					if (v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash)) or ((701 + 623) > (1657 + 1363))) then
						return "lava_lash single 7";
					end
				end
				if ((v102.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v102.WindfuryTotemBuff, true))) or ((3563 - (47 + 524)) == (1221 + 660))) then
					if (((8490 - 5384) > (2281 - 755)) and v24(v102.WindfuryTotem)) then
						return "windfury_totem single 8";
					end
				end
				v161 = 4 - 2;
			end
			if (((4749 - (1165 + 561)) < (115 + 3755)) and (v161 == (18 - 12))) then
				if (((55 + 88) > (553 - (341 + 138))) and v102.Stormstrike:IsReady() and v50) then
					if (((5 + 13) < (4358 - 2246)) and v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike))) then
						return "stormstrike single 25";
					end
				end
				if (((1423 - (89 + 237)) <= (5237 - 3609)) and v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v117)) then
					if (((9747 - 5117) == (5511 - (581 + 300))) and v24(v102.Sundering, not v15:IsInRange(1228 - (855 + 365)))) then
						return "sundering single 26";
					end
				end
				if (((8408 - 4868) > (877 + 1806)) and v102.BagofTricks:IsReady() and v59 and ((v66 and v36) or not v66)) then
					if (((6029 - (1030 + 205)) >= (3075 + 200)) and v24(v102.BagofTricks)) then
						return "bag_of_tricks single 27";
					end
				end
				if (((1381 + 103) == (1770 - (156 + 130))) and v102.FireNova:IsReady() and v42 and v102.SwirlingMaelstrom:IsAvailable() and v15:DebuffUp(v102.FlameShockDebuff) and (v14:BuffStack(v102.MaelstromWeaponBuff) < ((11 - 6) + ((8 - 3) * v25(v102.OverflowingMaelstrom:IsAvailable()))))) then
					if (((2932 - 1500) < (937 + 2618)) and v24(v102.FireNova)) then
						return "fire_nova single 28";
					end
				end
				v161 = 5 + 2;
			end
			if ((v161 == (77 - (10 + 59))) or ((302 + 763) > (17620 - 14042))) then
				if ((v102.FlameShock:IsReady() and v43) or ((5958 - (671 + 492)) < (1121 + 286))) then
					if (((3068 - (369 + 846)) < (1275 + 3538)) and v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock single 34";
					end
				end
				if ((v102.ChainLightning:IsReady() and v39 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (5 + 0)) and v14:BuffUp(v102.CracklingThunderBuff) and v102.ElementalSpirits:IsAvailable()) or ((4766 - (1036 + 909)) < (1933 + 498))) then
					if (v24(v102.ChainLightning, not v15:IsSpellInRange(v102.ChainLightning)) or ((4824 - 1950) < (2384 - (11 + 192)))) then
						return "chain_lightning single 35";
					end
				end
				if ((v102.LightningBolt:IsReady() and v48 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (3 + 2)) and v14:BuffDown(v102.PrimordialWaveBuff)) or ((2864 - (135 + 40)) <= (830 - 487))) then
					if (v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt)) or ((1127 + 742) == (4425 - 2416))) then
						return "lightning_bolt single 36";
					end
				end
				if ((v102.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (134 - 44)))) or ((3722 - (50 + 126)) < (6465 - 4143))) then
					if (v24(v102.WindfuryTotem) or ((461 + 1621) == (6186 - (1233 + 180)))) then
						return "windfury_totem single 37";
					end
				end
				break;
			end
			if (((4213 - (522 + 447)) > (2476 - (107 + 1314))) and ((3 + 2) == v161)) then
				if ((v102.FrostShock:IsReady() and v44 and (v14:BuffUp(v102.HailstormBuff))) or ((10094 - 6781) <= (756 + 1022))) then
					if (v24(v102.FrostShock, not v15:IsSpellInRange(v102.FrostShock)) or ((2821 - 1400) >= (8324 - 6220))) then
						return "frost_shock single 21";
					end
				end
				if (((3722 - (716 + 1194)) <= (56 + 3193)) and v102.LavaLash:IsReady() and v47) then
					if (((174 + 1449) <= (2460 - (74 + 429))) and v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash single 22";
					end
				end
				if (((8510 - 4098) == (2187 + 2225)) and v102.IceStrike:IsReady() and v45) then
					if (((4005 - 2255) >= (596 + 246)) and v24(v102.IceStrike, not v15:IsInMeleeRange(15 - 10))) then
						return "ice_strike single 23";
					end
				end
				if (((10809 - 6437) > (2283 - (279 + 154))) and v102.Windstrike:IsCastable() and v53) then
					if (((1010 - (454 + 324)) < (646 + 175)) and v24(v102.Windstrike, not v15:IsSpellInRange(v102.Windstrike))) then
						return "windstrike single 24";
					end
				end
				v161 = 23 - (12 + 5);
			end
			if (((280 + 238) < (2298 - 1396)) and (v161 == (3 + 4))) then
				if (((4087 - (277 + 816)) > (3666 - 2808)) and v102.LightningBolt:IsReady() and v48 and v102.Hailstorm:IsAvailable() and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (1188 - (1058 + 125))) and v14:BuffDown(v102.PrimordialWaveBuff)) then
					if (v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt)) or ((705 + 3050) <= (1890 - (815 + 160)))) then
						return "lightning_bolt single 29";
					end
				end
				if (((16930 - 12984) > (8885 - 5142)) and v102.FrostShock:IsReady() and v44) then
					if (v24(v102.FrostShock, not v15:IsSpellInRange(v102.FrostShock)) or ((319 + 1016) >= (9663 - 6357))) then
						return "frost_shock single 30";
					end
				end
				if (((6742 - (41 + 1857)) > (4146 - (1222 + 671))) and v102.CrashLightning:IsReady() and v40) then
					if (((1168 - 716) == (649 - 197)) and v24(v102.CrashLightning, not v15:IsInMeleeRange(1190 - (229 + 953)))) then
						return "crash_lightning single 31";
					end
				end
				if ((v102.FireNova:IsReady() and v42 and (v15:DebuffUp(v102.FlameShockDebuff))) or ((6331 - (1111 + 663)) < (3666 - (874 + 705)))) then
					if (((543 + 3331) == (2644 + 1230)) and v24(v102.FireNova)) then
						return "fire_nova single 32";
					end
				end
				v161 = 16 - 8;
			end
			if ((v161 == (1 + 3)) or ((2617 - (642 + 37)) > (1126 + 3809))) then
				if ((v102.FlameShock:IsReady() and v43 and (v15:DebuffDown(v102.FlameShockDebuff))) or ((681 + 3574) < (8594 - 5171))) then
					if (((1908 - (233 + 221)) <= (5760 - 3269)) and v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock single 17";
					end
				end
				if ((v102.IceStrike:IsReady() and v45 and v102.ElementalAssault:IsAvailable() and v102.SwirlingMaelstrom:IsAvailable()) or ((3659 + 498) <= (4344 - (718 + 823)))) then
					if (((3054 + 1799) >= (3787 - (266 + 539))) and v24(v102.IceStrike, not v15:IsInMeleeRange(13 - 8))) then
						return "ice_strike single 18";
					end
				end
				if (((5359 - (636 + 589)) > (7968 - 4611)) and v102.LavaLash:IsReady() and v47 and (v102.LashingFlames:IsAvailable())) then
					if (v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash)) or ((7047 - 3630) < (2009 + 525))) then
						return "lava_lash single 19";
					end
				end
				if ((v102.IceStrike:IsReady() and v45 and (v14:BuffDown(v102.IceStrikeBuff))) or ((989 + 1733) <= (1179 - (657 + 358)))) then
					if (v24(v102.IceStrike, not v15:IsInMeleeRange(13 - 8)) or ((5486 - 3078) < (3296 - (1151 + 36)))) then
						return "ice_strike single 20";
					end
				end
				v161 = 5 + 0;
			end
		end
	end
	local function v139()
		local v162 = 0 + 0;
		while true do
			if ((v162 == (5 - 3)) or ((1865 - (1552 + 280)) == (2289 - (64 + 770)))) then
				if ((v102.IceStrike:IsReady() and v45 and (v102.Hailstorm:IsAvailable())) or ((301 + 142) >= (9114 - 5099))) then
					if (((601 + 2781) > (1409 - (157 + 1086))) and v24(v102.IceStrike, not v15:IsInMeleeRange(10 - 5))) then
						return "ice_strike aoe 13";
					end
				end
				if ((v102.FrostShock:IsReady() and v44 and v102.Hailstorm:IsAvailable() and v14:BuffUp(v102.HailstormBuff)) or ((1226 - 946) == (4691 - 1632))) then
					if (((2567 - 686) > (2112 - (599 + 220))) and v24(v102.FrostShock, not v15:IsSpellInRange(v102.FrostShock))) then
						return "frost_shock aoe 14";
					end
				end
				if (((4693 - 2336) == (4288 - (1813 + 118))) and v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v117)) then
					if (((90 + 33) == (1340 - (841 + 376))) and v24(v102.Sundering, not v15:IsInRange(10 - 2))) then
						return "sundering aoe 15";
					end
				end
				if ((v102.FlameShock:IsReady() and v43 and v102.MoltenAssault:IsAvailable() and v15:DebuffDown(v102.FlameShockDebuff)) or ((246 + 810) >= (9258 - 5866))) then
					if (v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock)) or ((1940 - (464 + 395)) < (2758 - 1683))) then
						return "flame_shock aoe 16";
					end
				end
				if ((v102.FlameShock:IsReady() and v43 and v15:DebuffRefreshable(v102.FlameShockDebuff) and (v102.FireNova:IsAvailable() or v102.PrimordialWave:IsAvailable()) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (3 + 3))) or ((1886 - (467 + 370)) >= (9158 - 4726))) then
					local v235 = 0 + 0;
					while true do
						if ((v235 == (0 - 0)) or ((744 + 4024) <= (1968 - 1122))) then
							if (v118.CastCycle(v102.FlameShock, v111, v125, not v15:IsSpellInRange(v102.FlameShock)) or ((3878 - (150 + 370)) <= (2702 - (74 + 1208)))) then
								return "flame_shock aoe 17";
							end
							if (v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock)) or ((9196 - 5457) <= (14251 - 11246))) then
								return "flame_shock aoe no_cycle 17";
							end
							break;
						end
					end
				end
				if ((v102.FireNova:IsReady() and v42 and (v102.FlameShockDebuff:AuraActiveCount() >= (3 + 0))) or ((2049 - (14 + 376)) >= (3700 - 1566))) then
					if (v24(v102.FireNova) or ((2110 + 1150) < (2069 + 286))) then
						return "fire_nova aoe 18";
					end
				end
				v162 = 3 + 0;
			end
			if ((v162 == (0 - 0)) or ((504 + 165) == (4301 - (23 + 55)))) then
				if ((v102.CrashLightning:IsReady() and v40 and v102.CrashingStorms:IsAvailable() and ((v102.UnrulyWinds:IsAvailable() and (v112 >= (23 - 13))) or (v112 >= (11 + 4)))) or ((1520 + 172) < (911 - 323))) then
					if (v24(v102.CrashLightning, not v15:IsInMeleeRange(3 + 5)) or ((5698 - (652 + 249)) < (9770 - 6119))) then
						return "crash_lightning aoe 1";
					end
				end
				if ((v102.LightningBolt:IsReady() and v48 and ((v102.FlameShockDebuff:AuraActiveCount() >= v112) or (v14:BuffRemains(v102.PrimordialWaveBuff) < (v14:GCD() * (1871 - (708 + 1160)))) or (v102.FlameShockDebuff:AuraActiveCount() >= (16 - 10))) and v14:BuffUp(v102.PrimordialWaveBuff) and (v14:BuffStack(v102.MaelstromWeaponBuff) == ((9 - 4) + ((32 - (10 + 17)) * v25(v102.OverflowingMaelstrom:IsAvailable())))) and (v14:BuffDown(v102.SplinteredElementsBuff) or (v117 <= (3 + 9)) or (v100 <= v14:GCD()))) or ((5909 - (1400 + 332)) > (9302 - 4452))) then
					if (v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt)) or ((2308 - (242 + 1666)) > (476 + 635))) then
						return "lightning_bolt aoe 2";
					end
				end
				if (((1119 + 1932) > (857 + 148)) and v102.LavaLash:IsReady() and v47 and v102.MoltenAssault:IsAvailable() and (v102.PrimordialWave:IsAvailable() or v102.FireNova:IsAvailable()) and v15:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (946 - (850 + 90)))) then
					if (((6467 - 2774) <= (5772 - (360 + 1030))) and v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash aoe 3";
					end
				end
				if ((v102.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v117) and (v14:BuffDown(v102.PrimordialWaveBuff))) or ((2905 + 377) > (11572 - 7472))) then
					if (v118.CastCycle(v102.PrimordialWave, v111, v125, not v15:IsSpellInRange(v102.PrimordialWave)) or ((4925 - 1345) < (4505 - (909 + 752)))) then
						return "primordial_wave aoe 4";
					end
					if (((1312 - (109 + 1114)) < (8220 - 3730)) and v24(v102.PrimordialWave, not v15:IsSpellInRange(v102.PrimordialWave))) then
						return "primordial_wave aoe no_cycle 4";
					end
				end
				if ((v102.FlameShock:IsReady() and v43 and (v102.PrimordialWave:IsAvailable() or v102.FireNova:IsAvailable()) and v15:DebuffDown(v102.FlameShockDebuff)) or ((1940 + 3043) < (2050 - (6 + 236)))) then
					if (((2413 + 1416) > (3034 + 735)) and v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock aoe 5";
					end
				end
				if (((3502 - 2017) <= (5071 - 2167)) and v102.ElementalBlast:IsReady() and v41 and (not v102.ElementalSpirits:IsAvailable() or (v102.ElementalSpirits:IsAvailable() and ((v102.ElementalBlast:Charges() == v114) or (v120.FeralSpiritCount >= (1135 - (1076 + 57)))))) and (v14:BuffStack(v102.MaelstromWeaponBuff) == (1 + 4 + ((694 - (579 + 110)) * v25(v102.OverflowingMaelstrom:IsAvailable())))) and (not v102.CrashingStorms:IsAvailable() or (v112 <= (1 + 2)))) then
					if (((3775 + 494) == (2266 + 2003)) and v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast))) then
						return "elemental_blast aoe 6";
					end
				end
				v162 = 408 - (174 + 233);
			end
			if (((1080 - 693) <= (4882 - 2100)) and (v162 == (2 + 2))) then
				if ((v102.CrashLightning:IsReady() and v40) or ((3073 - (663 + 511)) <= (819 + 98))) then
					if (v24(v102.CrashLightning, not v15:IsInMeleeRange(2 + 6)) or ((13293 - 8981) <= (531 + 345))) then
						return "crash_lightning aoe 25";
					end
				end
				if (((5254 - 3022) <= (6284 - 3688)) and v102.FireNova:IsReady() and v42 and (v102.FlameShockDebuff:AuraActiveCount() >= (1 + 1))) then
					if (((4077 - 1982) < (2627 + 1059)) and v24(v102.FireNova)) then
						return "fire_nova aoe 26";
					end
				end
				if ((v102.ElementalBlast:IsReady() and v41 and (not v102.ElementalSpirits:IsAvailable() or (v102.ElementalSpirits:IsAvailable() and ((v102.ElementalBlast:Charges() == v114) or (v120.FeralSpiritCount >= (1 + 1))))) and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (727 - (478 + 244))) and (not v102.CrashingStorms:IsAvailable() or (v112 <= (520 - (440 + 77))))) or ((726 + 869) >= (16375 - 11901))) then
					if (v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast)) or ((6175 - (655 + 901)) < (535 + 2347))) then
						return "elemental_blast aoe 27";
					end
				end
				if ((v102.ChainLightning:IsReady() and v39 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (4 + 1))) or ((199 + 95) >= (19462 - 14631))) then
					if (((3474 - (695 + 750)) <= (10530 - 7446)) and v24(v102.ChainLightning, not v15:IsSpellInRange(v102.ChainLightning))) then
						return "chain_lightning aoe 28";
					end
				end
				if ((v102.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (138 - 48)))) or ((8192 - 6155) == (2771 - (285 + 66)))) then
					if (((10391 - 5933) > (5214 - (682 + 628))) and v24(v102.WindfuryTotem)) then
						return "windfury_totem aoe 29";
					end
				end
				if (((71 + 365) >= (422 - (176 + 123))) and v102.FlameShock:IsReady() and v43 and (v15:DebuffDown(v102.FlameShockDebuff))) then
					if (((210 + 290) < (1318 + 498)) and v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock aoe 30";
					end
				end
				v162 = 274 - (239 + 30);
			end
			if (((972 + 2602) == (3436 + 138)) and (v162 == (1 - 0))) then
				if (((689 - 468) < (705 - (306 + 9))) and v102.ChainLightning:IsReady() and v39 and (v14:BuffStack(v102.MaelstromWeaponBuff) == ((17 - 12) + ((1 + 4) * v25(v102.OverflowingMaelstrom:IsAvailable()))))) then
					if (v24(v102.ChainLightning, not v15:IsSpellInRange(v102.ChainLightning)) or ((1358 + 855) <= (684 + 737))) then
						return "chain_lightning aoe 7";
					end
				end
				if (((8744 - 5686) < (6235 - (1140 + 235))) and v102.CrashLightning:IsReady() and v40 and (v14:BuffUp(v102.DoomWindsBuff) or v14:BuffDown(v102.CrashLightningBuff) or (v102.AlphaWolf:IsAvailable() and v14:BuffUp(v102.FeralSpiritBuff) and (v124() == (0 + 0))))) then
					if (v24(v102.CrashLightning, not v15:IsInMeleeRange(8 + 0)) or ((333 + 963) >= (4498 - (33 + 19)))) then
						return "crash_lightning aoe 8";
					end
				end
				if ((v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v117) and (v14:BuffUp(v102.DoomWindsBuff) or v14:HasTier(11 + 19, 5 - 3))) or ((614 + 779) > (8802 - 4313))) then
					if (v24(v102.Sundering, not v15:IsInRange(8 + 0)) or ((5113 - (586 + 103)) < (3 + 24))) then
						return "sundering aoe 9";
					end
				end
				if ((v102.FireNova:IsReady() and v42 and ((v102.FlameShockDebuff:AuraActiveCount() >= (18 - 12)) or ((v102.FlameShockDebuff:AuraActiveCount() >= (1492 - (1309 + 179))) and (v102.FlameShockDebuff:AuraActiveCount() >= v112)))) or ((3604 - 1607) > (1661 + 2154))) then
					if (((9305 - 5840) > (1445 + 468)) and v24(v102.FireNova)) then
						return "fire_nova aoe 10";
					end
				end
				if (((1556 - 823) < (3624 - 1805)) and v102.LavaLash:IsReady() and v47 and (v102.LashingFlames:IsAvailable())) then
					local v236 = 609 - (295 + 314);
					while true do
						if ((v236 == (0 - 0)) or ((6357 - (1300 + 662)) == (14931 - 10176))) then
							if (v118.CastCycle(v102.LavaLash, v111, v126, not v15:IsSpellInRange(v102.LavaLash)) or ((5548 - (1178 + 577)) < (1231 + 1138))) then
								return "lava_lash aoe 11";
							end
							if (v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash)) or ((12073 - 7989) == (1670 - (851 + 554)))) then
								return "lava_lash aoe no_cycle 11";
							end
							break;
						end
					end
				end
				if (((3854 + 504) == (12086 - 7728)) and v102.LavaLash:IsReady() and v47 and ((v102.MoltenAssault:IsAvailable() and v15:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (12 - 6))) or (v102.AshenCatalyst:IsAvailable() and (v14:BuffStack(v102.AshenCatalystBuff) == (307 - (115 + 187)))))) then
					if (v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash)) or ((2404 + 734) < (941 + 52))) then
						return "lava_lash aoe 12";
					end
				end
				v162 = 7 - 5;
			end
			if (((4491 - (160 + 1001)) > (2033 + 290)) and (v162 == (4 + 1))) then
				if ((v102.FrostShock:IsReady() and v44 and not v102.Hailstorm:IsAvailable()) or ((7422 - 3796) == (4347 - (237 + 121)))) then
					if (v24(v102.FrostShock, not v15:IsSpellInRange(v102.FrostShock)) or ((1813 - (525 + 372)) == (5063 - 2392))) then
						return "frost_shock aoe 31";
					end
				end
				break;
			end
			if (((893 - 621) == (414 - (96 + 46))) and (v162 == (780 - (643 + 134)))) then
				if (((1534 + 2715) <= (11602 - 6763)) and v102.Stormstrike:IsReady() and v50 and v14:BuffUp(v102.CrashLightningBuff) and (v102.DeeplyRootedElements:IsAvailable() or (v14:BuffStack(v102.ConvergingStormsBuff) == (22 - 16)))) then
					if (((2664 + 113) < (6280 - 3080)) and v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike))) then
						return "stormstrike aoe 19";
					end
				end
				if (((194 - 99) < (2676 - (316 + 403))) and v102.CrashLightning:IsReady() and v40 and v102.CrashingStorms:IsAvailable() and v14:BuffUp(v102.CLCrashLightningBuff) and (v112 >= (3 + 1))) then
					if (((2270 - 1444) < (621 + 1096)) and v24(v102.CrashLightning, not v15:IsInMeleeRange(20 - 12))) then
						return "crash_lightning aoe 20";
					end
				end
				if (((1011 + 415) >= (357 + 748)) and v102.Windstrike:IsCastable() and v53) then
					if (((9542 - 6788) <= (16137 - 12758)) and v24(v102.Windstrike, not v15:IsSpellInRange(v102.Windstrike))) then
						return "windstrike aoe 21";
					end
				end
				if ((v102.Stormstrike:IsReady() and v50) or ((8157 - 4230) == (81 + 1332))) then
					if (v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike)) or ((2271 - 1117) <= (39 + 749))) then
						return "stormstrike aoe 22";
					end
				end
				if ((v102.IceStrike:IsReady() and v45) or ((4833 - 3190) > (3396 - (12 + 5)))) then
					if (v24(v102.IceStrike, not v15:IsInMeleeRange(19 - 14)) or ((5979 - 3176) > (9669 - 5120))) then
						return "ice_strike aoe 23";
					end
				end
				if ((v102.LavaLash:IsReady() and v47) or ((545 - 325) >= (614 + 2408))) then
					if (((4795 - (1656 + 317)) == (2515 + 307)) and v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash aoe 24";
					end
				end
				v162 = 4 + 0;
			end
		end
	end
	local function v140()
		if ((v76 and v102.EarthShield:IsCastable() and v14:BuffDown(v102.EarthShieldBuff) and ((v77 == "Earth Shield") or (v102.ElementalOrbit:IsAvailable() and v14:BuffUp(v102.LightningShield)))) or ((2821 - 1760) == (9139 - 7282))) then
			if (((3114 - (5 + 349)) > (6478 - 5114)) and v24(v102.EarthShield)) then
				return "earth_shield main 2";
			end
		elseif ((v76 and v102.LightningShield:IsCastable() and v14:BuffDown(v102.LightningShieldBuff) and ((v77 == "Lightning Shield") or (v102.ElementalOrbit:IsAvailable() and v14:BuffUp(v102.EarthShield)))) or ((6173 - (266 + 1005)) <= (2369 + 1226))) then
			if (v24(v102.LightningShield) or ((13143 - 9291) == (385 - 92))) then
				return "lightning_shield main 2";
			end
		end
		if (((not v106 or (v108 < (601696 - (561 + 1135)))) and v54 and v102.WindfuryWeapon:IsCastable()) or ((2030 - 471) == (15081 - 10493))) then
			if (v24(v102.WindfuryWeapon) or ((5550 - (507 + 559)) == (1977 - 1189))) then
				return "windfury_weapon enchant";
			end
		end
		if (((14127 - 9559) >= (4295 - (212 + 176))) and (not v107 or (v109 < (600905 - (250 + 655)))) and v54 and v102.FlametongueWeapon:IsCastable()) then
			if (((3397 - 2151) < (6063 - 2593)) and v24(v102.FlametongueWeapon)) then
				return "flametongue_weapon enchant";
			end
		end
		if (((6364 - 2296) >= (2928 - (1869 + 87))) and v86) then
			local v201 = 0 - 0;
			while true do
				if (((2394 - (484 + 1417)) < (8344 - 4451)) and (v201 == (0 - 0))) then
					v33 = v134();
					if (v33 or ((2246 - (48 + 725)) >= (5442 - 2110))) then
						return v33;
					end
					break;
				end
			end
		end
		if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) or ((10868 - 6817) <= (673 + 484))) then
			if (((1613 - 1009) < (807 + 2074)) and v24(v102.AncestralSpirit, nil, true)) then
				return "resurrection";
			end
		end
		if ((v118.TargetIsValid() and v34) or ((263 + 637) == (4230 - (152 + 701)))) then
			if (((5770 - (430 + 881)) > (227 + 364)) and not v14:AffectingCombat()) then
				local v232 = 895 - (557 + 338);
				while true do
					if (((1005 + 2393) >= (6749 - 4354)) and (v232 == (0 - 0))) then
						v33 = v137();
						if (v33 or ((5799 - 3616) >= (6086 - 3262))) then
							return v33;
						end
						break;
					end
				end
			end
		end
	end
	local function v141()
		local v163 = 801 - (499 + 302);
		while true do
			if (((2802 - (39 + 827)) == (5343 - 3407)) and ((4 - 2) == v163)) then
				if (v16 or ((19191 - 14359) < (6620 - 2307))) then
					if (((350 + 3738) > (11338 - 7464)) and v93) then
						v33 = v132();
						if (((693 + 3639) == (6854 - 2522)) and v33) then
							return v33;
						end
					end
				end
				if (((4103 - (103 + 1)) >= (3454 - (475 + 79))) and v102.GreaterPurge:IsAvailable() and v101 and v102.GreaterPurge:IsReady() and v38 and v92 and not v14:IsCasting() and not v14:IsChanneling() and v118.UnitHasMagicBuff(v15)) then
					if (v24(v102.GreaterPurge, not v15:IsSpellInRange(v102.GreaterPurge)) or ((5458 - 2933) > (13004 - 8940))) then
						return "greater_purge damage";
					end
				end
				v163 = 1 + 2;
			end
			if (((3847 + 524) == (5874 - (1395 + 108))) and ((2 - 1) == v163)) then
				if (v94 or ((1470 - (7 + 1197)) > (2174 + 2812))) then
					if (((695 + 1296) >= (1244 - (27 + 292))) and v88) then
						v33 = v118.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 117 - 77);
						if (((580 - 125) < (8609 - 6556)) and v33) then
							return v33;
						end
					end
					if (v89 or ((1628 - 802) == (9238 - 4387))) then
						local v243 = 139 - (43 + 96);
						while true do
							if (((746 - 563) == (413 - 230)) and (v243 == (0 + 0))) then
								v33 = v118.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 9 + 21);
								if (((2290 - 1131) <= (686 + 1102)) and v33) then
									return v33;
								end
								break;
							end
						end
					end
					if (v90 or ((6571 - 3064) > (1360 + 2958))) then
						local v244 = 0 + 0;
						while true do
							if (((1751 - (1414 + 337)) == v244) or ((5015 - (1642 + 298)) <= (7729 - 4764))) then
								v33 = v118.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 86 - 56);
								if (((4050 - 2685) <= (662 + 1349)) and v33) then
									return v33;
								end
								break;
							end
						end
					end
					if (((v14:BuffStack(v102.MaelstromWeaponBuff) >= (4 + 1)) and v91) or ((3748 - (357 + 615)) > (2510 + 1065))) then
						local v245 = 0 - 0;
						while true do
							if ((v245 == (0 + 0)) or ((5472 - 2918) == (3843 + 961))) then
								v33 = v118.HandleAfflicted(v102.HealingSurge, v104.HealingSurgeMouseover, 3 + 37, true);
								if (((1620 + 957) == (3878 - (384 + 917))) and v33) then
									return v33;
								end
								break;
							end
						end
					end
				end
				if (v95 or ((703 - (128 + 569)) >= (3432 - (1407 + 136)))) then
					local v237 = 1887 - (687 + 1200);
					while true do
						if (((2216 - (556 + 1154)) <= (6656 - 4764)) and (v237 == (95 - (9 + 86)))) then
							v33 = v118.HandleIncorporeal(v102.Hex, v104.HexMouseOver, 451 - (275 + 146), true);
							if (v33 or ((327 + 1681) > (2282 - (29 + 35)))) then
								return v33;
							end
							break;
						end
					end
				end
				v163 = 8 - 6;
			end
			if (((1131 - 752) <= (18306 - 14159)) and (v163 == (2 + 1))) then
				if ((v102.Purge:IsReady() and v101 and v38 and v92 and not v14:IsCasting() and not v14:IsChanneling() and v118.UnitHasMagicBuff(v15)) or ((5526 - (53 + 959)) <= (1417 - (312 + 96)))) then
					if (v24(v102.Purge, not v15:IsSpellInRange(v102.Purge)) or ((6067 - 2571) == (1477 - (147 + 138)))) then
						return "purge damage";
					end
				end
				v33 = v133();
				v163 = 903 - (813 + 86);
			end
			if ((v163 == (4 + 0)) or ((385 - 177) == (3451 - (18 + 474)))) then
				if (((1443 + 2834) >= (4285 - 2972)) and v33) then
					return v33;
				end
				if (((3673 - (860 + 226)) < (3477 - (121 + 182))) and v118.TargetIsValid()) then
					local v238 = v118.HandleDPSPotion(v14:BuffUp(v102.FeralSpiritBuff));
					if (v238 or ((508 + 3612) <= (3438 - (988 + 252)))) then
						return v238;
					end
					if ((v100 < v117) or ((181 + 1415) == (269 + 589))) then
						if (((5190 - (49 + 1921)) == (4110 - (223 + 667))) and v58 and ((v36 and v65) or not v65)) then
							local v251 = 52 - (51 + 1);
							while true do
								if ((v251 == (0 - 0)) or ((3001 - 1599) > (4745 - (146 + 979)))) then
									v33 = v136();
									if (((727 + 1847) == (3179 - (311 + 294))) and v33) then
										return v33;
									end
									break;
								end
							end
						end
					end
					if (((5014 - 3216) < (1168 + 1589)) and (v100 < v117) and v59 and ((v66 and v36) or not v66)) then
						if ((v102.BloodFury:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (1493 - (496 + 947))))) or ((1735 - (1233 + 125)) > (1057 + 1547))) then
							if (((510 + 58) < (174 + 737)) and v24(v102.BloodFury)) then
								return "blood_fury racial";
							end
						end
						if (((4930 - (963 + 682)) < (3529 + 699)) and v102.Berserking:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff))) then
							if (((5420 - (504 + 1000)) > (2242 + 1086)) and v24(v102.Berserking)) then
								return "berserking racial";
							end
						end
						if (((2277 + 223) < (363 + 3476)) and v102.Fireblood:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (73 - 23)))) then
							if (((434 + 73) == (295 + 212)) and v24(v102.Fireblood)) then
								return "fireblood racial";
							end
						end
						if (((422 - (156 + 26)) <= (1824 + 1341)) and v102.AncestralCall:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (78 - 28)))) then
							if (((998 - (149 + 15)) >= (1765 - (890 + 70))) and v24(v102.AncestralCall)) then
								return "ancestral_call racial";
							end
						end
					end
					if ((v102.TotemicProjection:IsCastable() and (v102.WindfuryTotem:TimeSinceLastCast() < (207 - (39 + 78))) and v14:BuffDown(v102.WindfuryTotemBuff, true)) or ((4294 - (14 + 468)) < (5092 - 2776))) then
						if (v24(v104.TotemicProjectionPlayer) or ((7412 - 4760) <= (791 + 742))) then
							return "totemic_projection wind_fury main 0";
						end
					end
					if ((v102.Windstrike:IsCastable() and v53) or ((2161 + 1437) < (311 + 1149))) then
						if (v24(v102.Windstrike, not v15:IsSpellInRange(v102.Windstrike)) or ((1859 + 2257) < (313 + 879))) then
							return "windstrike main 1";
						end
					end
					if ((v102.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v117) and (v14:HasTier(59 - 28, 2 + 0))) or ((11866 - 8489) <= (23 + 880))) then
						if (((4027 - (12 + 39)) >= (409 + 30)) and v24(v102.PrimordialWave, not v15:IsSpellInRange(v102.PrimordialWave))) then
							return "primordial_wave main 2";
						end
					end
					if (((11613 - 7861) == (13362 - 9610)) and v102.FeralSpirit:IsCastable() and v56 and ((v61 and v36) or not v61) and (v100 < v117)) then
						if (((1200 + 2846) > (1419 + 1276)) and v24(v102.FeralSpirit)) then
							return "feral_spirit main 3";
						end
					end
					if ((v102.Ascendance:IsCastable() and v55 and ((v60 and v36) or not v60) and (v100 < v117) and v15:DebuffUp(v102.FlameShockDebuff) and (((v115 == "Lightning Bolt") and (v112 == (2 - 1))) or ((v115 == "Chain Lightning") and (v112 > (1 + 0))))) or ((17132 - 13587) == (4907 - (1596 + 114)))) then
						if (((6250 - 3856) > (1086 - (164 + 549))) and v24(v102.Ascendance)) then
							return "ascendance main 4";
						end
					end
					if (((5593 - (1059 + 379)) <= (5254 - 1022)) and v102.DoomWinds:IsCastable() and v57 and ((v62 and v36) or not v62) and (v100 < v117)) then
						if (v24(v102.DoomWinds, not v15:IsInMeleeRange(3 + 2)) or ((604 + 2977) == (3865 - (145 + 247)))) then
							return "doom_winds main 5";
						end
					end
					if (((4099 + 896) > (1548 + 1800)) and (v112 == (2 - 1))) then
						v33 = v138();
						if (v33 or ((145 + 609) > (3208 + 516))) then
							return v33;
						end
					end
					if (((352 - 135) >= (777 - (254 + 466))) and v35 and (v112 > (561 - (544 + 16)))) then
						local v246 = 0 - 0;
						while true do
							if ((v246 == (628 - (294 + 334))) or ((2323 - (236 + 17)) >= (1741 + 2296))) then
								v33 = v139();
								if (((2106 + 599) == (10187 - 7482)) and v33) then
									return v33;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((288 - 227) == (32 + 29)) and (v163 == (0 + 0))) then
				v33 = v135();
				if (v33 or ((1493 - (413 + 381)) >= (55 + 1241))) then
					return v33;
				end
				v163 = 1 - 0;
			end
		end
	end
	local function v142()
		local v164 = 0 - 0;
		while true do
			if ((v164 == (1974 - (582 + 1388))) or ((3037 - 1254) >= (2589 + 1027))) then
				v48 = EpicSettings.Settings['useLightningBolt'];
				v49 = EpicSettings.Settings['usePrimordialWave'];
				v50 = EpicSettings.Settings['useStormStrike'];
				v164 = 369 - (326 + 38);
			end
			if ((v164 == (5 - 3)) or ((5585 - 1672) > (5147 - (47 + 573)))) then
				v42 = EpicSettings.Settings['useFireNova'];
				v43 = EpicSettings.Settings['useFlameShock'];
				v44 = EpicSettings.Settings['useFrostShock'];
				v164 = 2 + 1;
			end
			if (((18585 - 14209) > (1325 - 508)) and ((1667 - (1269 + 395)) == v164)) then
				v45 = EpicSettings.Settings['useIceStrike'];
				v46 = EpicSettings.Settings['useLavaBurst'];
				v47 = EpicSettings.Settings['useLavaLash'];
				v164 = 496 - (76 + 416);
			end
			if (((5304 - (319 + 124)) > (1883 - 1059)) and (v164 == (1007 - (564 + 443)))) then
				v55 = EpicSettings.Settings['useAscendance'];
				v57 = EpicSettings.Settings['useDoomWinds'];
				v56 = EpicSettings.Settings['useFeralSpirit'];
				v164 = 2 - 1;
			end
			if ((v164 == (463 - (337 + 121))) or ((4051 - 2668) >= (7098 - 4967))) then
				v51 = EpicSettings.Settings['useSundering'];
				v53 = EpicSettings.Settings['useWindstrike'];
				v52 = EpicSettings.Settings['useWindfuryTotem'];
				v164 = 1917 - (1261 + 650);
			end
			if ((v164 == (3 + 3)) or ((2989 - 1113) >= (4358 - (772 + 1045)))) then
				v54 = EpicSettings.Settings['useWeaponEnchant'];
				v60 = EpicSettings.Settings['ascendanceWithCD'];
				v62 = EpicSettings.Settings['doomWindsWithCD'];
				v164 = 1 + 6;
			end
			if (((1926 - (102 + 42)) <= (5616 - (1524 + 320))) and (v164 == (1277 - (1049 + 221)))) then
				v61 = EpicSettings.Settings['feralSpiritWithCD'];
				v64 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v63 = EpicSettings.Settings['sunderingWithMiniCD'];
				break;
			end
			if ((v164 == (157 - (18 + 138))) or ((11504 - 6804) < (1915 - (67 + 1035)))) then
				v39 = EpicSettings.Settings['useChainlightning'];
				v40 = EpicSettings.Settings['useCrashLightning'];
				v41 = EpicSettings.Settings['useElementalBlast'];
				v164 = 350 - (136 + 212);
			end
		end
	end
	local function v143()
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
		v81 = EpicSettings.Settings['healingStreamTotemHP'] or (1604 - (240 + 1364));
		v82 = EpicSettings.Settings['healingStreamTotemGroup'] or (1082 - (1050 + 32));
		v83 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (0 - 0);
		v76 = EpicSettings.Settings['autoShield'];
		v77 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
		v86 = EpicSettings.Settings['healOOC'];
		v87 = EpicSettings.Settings['healOOCHP'] or (0 + 0);
		v101 = EpicSettings.Settings['usePurgeTarget'];
		v88 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
		v89 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v90 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
		v91 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
	end
	local function v144()
		v100 = EpicSettings.Settings['fightRemainsCheck'] or (1055 - (331 + 724));
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
		v84 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v85 = EpicSettings.Settings['healingPotionHP'] or (644 - (269 + 375));
		v96 = EpicSettings.Settings['HealingPotionName'] or "";
		v94 = EpicSettings.Settings['handleAfflicted'];
		v95 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v145()
		local v192 = 725 - (267 + 458);
		while true do
			if (((995 + 2204) < (7788 - 3738)) and (v192 == (818 - (667 + 151)))) then
				v143();
				v142();
				v144();
				v34 = EpicSettings.Toggles['ooc'];
				v192 = 1498 - (1410 + 87);
			end
			if ((v192 == (1899 - (1504 + 393))) or ((13382 - 8431) < (11493 - 7063))) then
				if (((892 - (461 + 335)) == (13 + 83)) and v14:IsDeadOrGhost()) then
					return v33;
				end
				v106, v108, _, _, v107, v109 = v27();
				v110 = v14:GetEnemiesInRange(1801 - (1730 + 31));
				v111 = v14:GetEnemiesInMeleeRange(1677 - (728 + 939));
				v192 = 10 - 7;
			end
			if ((v192 == (1 - 0)) or ((6275 - 3536) > (5076 - (138 + 930)))) then
				v35 = EpicSettings.Toggles['aoe'];
				v36 = EpicSettings.Toggles['cds'];
				v38 = EpicSettings.Toggles['dispel'];
				v37 = EpicSettings.Toggles['minicds'];
				v192 = 2 + 0;
			end
			if ((v192 == (4 + 0)) or ((20 + 3) == (4630 - 3496))) then
				if ((not v14:IsChanneling() and not v14:IsChanneling()) or ((4459 - (459 + 1307)) >= (5981 - (474 + 1396)))) then
					if (v94 or ((7536 - 3220) <= (2012 + 134))) then
						local v247 = 0 + 0;
						while true do
							if ((v247 == (2 - 1)) or ((450 + 3096) <= (9377 - 6568))) then
								if (((21387 - 16483) > (2757 - (562 + 29))) and v90) then
									local v252 = 0 + 0;
									while true do
										if (((1528 - (374 + 1045)) >= (72 + 18)) and (v252 == (0 - 0))) then
											v33 = v118.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 668 - (448 + 190));
											if (((1608 + 3370) > (1312 + 1593)) and v33) then
												return v33;
											end
											break;
										end
									end
								end
								if (((v14:BuffStack(v102.MaelstromWeaponBuff) >= (4 + 1)) and v91) or ((11634 - 8608) <= (7084 - 4804))) then
									local v253 = 1494 - (1307 + 187);
									while true do
										if ((v253 == (0 - 0)) or ((3870 - 2217) <= (3397 - 2289))) then
											v33 = v118.HandleAfflicted(v102.HealingSurge, v104.HealingSurgeMouseover, 723 - (232 + 451), true);
											if (((2778 + 131) > (2305 + 304)) and v33) then
												return v33;
											end
											break;
										end
									end
								end
								break;
							end
							if (((1321 - (510 + 54)) > (390 - 196)) and (v247 == (36 - (13 + 23)))) then
								if (v88 or ((60 - 29) >= (2008 - 610))) then
									v33 = v118.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 72 - 32);
									if (((4284 - (830 + 258)) <= (17186 - 12314)) and v33) then
										return v33;
									end
								end
								if (((2081 + 1245) == (2830 + 496)) and v89) then
									v33 = v118.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 1471 - (860 + 581));
									if (((5285 - 3852) <= (3078 + 800)) and v33) then
										return v33;
									end
								end
								v247 = 242 - (237 + 4);
							end
						end
					end
					if (v14:AffectingCombat() or ((3719 - 2136) == (4389 - 2654))) then
						local v248 = 0 - 0;
						while true do
							if ((v248 == (0 + 0)) or ((1713 + 1268) == (8872 - 6522))) then
								v33 = v141();
								if (v33 or ((1917 + 2549) <= (269 + 224))) then
									return v33;
								end
								break;
							end
						end
					else
						local v249 = 1426 - (85 + 1341);
						while true do
							if ((v249 == (0 - 0)) or ((7193 - 4646) <= (2359 - (45 + 327)))) then
								v33 = v140();
								if (((5587 - 2626) > (3242 - (444 + 58))) and v33) then
									return v33;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((1607 + 2089) >= (622 + 2990)) and (v192 == (2 + 1))) then
				if (v35 or ((8607 - 5637) == (3610 - (64 + 1668)))) then
					local v239 = 1973 - (1227 + 746);
					while true do
						if ((v239 == (0 - 0)) or ((6853 - 3160) < (2471 - (415 + 79)))) then
							v113 = #v110;
							v112 = #v111;
							break;
						end
					end
				else
					local v240 = 0 + 0;
					while true do
						if ((v240 == (491 - (142 + 349))) or ((399 + 531) > (2888 - 787))) then
							v113 = 1 + 0;
							v112 = 1 + 0;
							break;
						end
					end
				end
				if (((11309 - 7156) > (4950 - (1710 + 154))) and v38 and v93) then
					if ((v14:AffectingCombat() and v102.CleanseSpirit:IsAvailable()) or ((4972 - (200 + 118)) <= (1605 + 2445))) then
						local v250 = v93 and v102.CleanseSpirit:IsReady() and v38;
						v33 = v118.FocusUnit(v250, v104, 34 - 14, nil, 37 - 12);
						if (v33 or ((2312 + 290) < (1480 + 16))) then
							return v33;
						end
					end
					if (v102.CleanseSpirit:IsAvailable() or ((548 + 472) > (366 + 1922))) then
						if (((710 - 382) == (1578 - (363 + 887))) and v17 and v17:Exists() and v17:IsAPlayer() and v118.UnitHasCurseDebuff(v17)) then
							if (((2638 - 1127) < (18125 - 14317)) and v102.CleanseSpirit:IsReady()) then
								if (v24(v104.CleanseSpiritMouseover) or ((388 + 2122) > (11509 - 6590))) then
									return "cleanse_spirit mouseover";
								end
							end
						end
					end
				end
				if (((3255 + 1508) == (6427 - (674 + 990))) and (v118.TargetIsValid() or v14:AffectingCombat())) then
					local v241 = 0 + 0;
					while true do
						if (((1694 + 2443) > (2928 - 1080)) and (v241 == (1056 - (507 + 548)))) then
							if (((3273 - (289 + 548)) <= (4952 - (821 + 997))) and (v117 == (11366 - (195 + 60)))) then
								v117 = v10.FightRemains(v111, false);
							end
							break;
						end
						if (((1002 + 2721) == (5224 - (251 + 1250))) and (v241 == (0 - 0))) then
							v116 = v10.BossFightRemains(nil, true);
							v117 = v116;
							v241 = 1 + 0;
						end
					end
				end
				if (v14:AffectingCombat() or ((5078 - (809 + 223)) >= (6298 - 1982))) then
					if (v14:PrevGCD(2 - 1, v102.ChainLightning) or ((6639 - 4631) < (1421 + 508))) then
						v115 = "Chain Lightning";
					elseif (((1249 + 1135) > (2392 - (14 + 603))) and v14:PrevGCD(130 - (118 + 11), v102.LightningBolt)) then
						v115 = "Lightning Bolt";
					end
				end
				v192 = 1 + 3;
			end
		end
	end
	local function v146()
		local v193 = 0 + 0;
		while true do
			if ((v193 == (0 - 0)) or ((5492 - (551 + 398)) <= (2766 + 1610))) then
				v102.FlameShockDebuff:RegisterAuraTracking();
				v122();
				v193 = 1 + 0;
			end
			if (((592 + 136) == (2707 - 1979)) and (v193 == (2 - 1))) then
				v21.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(86 + 177, v145, v146);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

