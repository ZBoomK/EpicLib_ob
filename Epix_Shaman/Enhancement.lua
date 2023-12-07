local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((5759 - (506 + 530)) > (803 + 553)) and not v5) then
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
	local v15 = v9.Spell;
	local v16 = v9.MultiSpell;
	local v17 = v9.Item;
	local v18 = EpicLib;
	local v19 = v18.Cast;
	local v20 = v18.Macro;
	local v21 = v18.Press;
	local v22 = v18.Commons.Everyone.num;
	local v23 = v18.Commons.Everyone.bool;
	local v24 = GetWeaponEnchantInfo;
	local v25 = math.max;
	local v26 = math.min;
	local v27 = string.match;
	local v28 = GetTime;
	local v29 = C_Timer;
	local v30;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
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
	local v36;
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
	local v100 = v15.Shaman.Enhancement;
	local v101 = v17.Shaman.Enhancement;
	local v102 = v20.Shaman.Enhancement;
	local v103 = {};
	local v104, v105;
	local v106, v107;
	local v108, v109, v110, v111;
	local v112 = (v100.LavaBurst:IsAvailable() and (7 - 5)) or (1 + 0);
	local v113 = "Lightning Bolt";
	local v114 = 25334 - 14223;
	local v115 = 9695 + 1416;
	local v116 = v18.Commons.Everyone;
	v18.Commons.Shaman = {};
	local v118 = v18.Commons.Shaman;
	v118.LastSKCast = 0 + 0;
	v118.LastSKBuff = 0 - 0;
	v118.LastT302pcBuff = 0 + 0;
	v118.FeralSpiritCount = 0 - 0;
	v9:RegisterForEvent(function()
		v112 = (v100.LavaBurst:IsAvailable() and (1246 - (485 + 759))) or (2 - 1);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v9:RegisterForEvent(function()
		v113 = "Lightning Bolt";
		v114 = 12300 - (442 + 747);
		v115 = 12246 - (832 + 303);
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForSelfCombatEvent(function(...)
		local v148 = 946 - (88 + 858);
		local v149;
		local v150;
		local v151;
		while true do
			if ((v148 == (1 + 0)) or ((3423 + 713) <= (142 + 3291))) then
				if (((5034 - (766 + 23)) <= (22862 - 18231)) and v13:HasTier(42 - 11, 4 - 2) and (v149 == v13:GUID()) and (v151 == (1276095 - 900113))) then
					v118.FeralSpiritCount = v118.FeralSpiritCount + (1074 - (1036 + 37));
					v29.After(11 + 4, function()
						v118.FeralSpiritCount = v118.FeralSpiritCount - (1 - 0);
					end);
				end
				if (((3364 + 912) >= (5394 - (641 + 839))) and (v149 == v13:GUID()) and (v151 == (52446 - (910 + 3)))) then
					local v232 = 0 - 0;
					while true do
						if (((1882 - (1466 + 218)) <= (2007 + 2358)) and (v232 == (1148 - (556 + 592)))) then
							v118.FeralSpiritCount = v118.FeralSpiritCount + 1 + 1;
							v29.After(823 - (329 + 479), function()
								v118.FeralSpiritCount = v118.FeralSpiritCount - (856 - (174 + 680));
							end);
							break;
						end
					end
				end
				break;
			end
			if (((16431 - 11649) > (9691 - 5015)) and (v148 == (0 + 0))) then
				v149, v150, v150, v150, v150, v150, v150, v150, v151 = select(743 - (396 + 343), ...);
				if (((431 + 4433) > (3674 - (29 + 1448))) and (v149 == v13:GUID()) and (v151 == (193023 - (135 + 1254)))) then
					v118.LastSKCast = v28();
				end
				v148 = 3 - 2;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v9:RegisterForSelfCombatEvent(function(...)
		local v152 = 0 - 0;
		local v153;
		local v154;
		local v155;
		while true do
			if ((v152 == (0 + 0)) or ((5227 - (389 + 1138)) == (3081 - (102 + 472)))) then
				v153, v154, v154, v154, v155 = select(8 + 0, ...);
				if (((2481 + 1993) >= (256 + 18)) and (v153 == v13:GUID()) and (v155 == (193179 - (320 + 1225)))) then
					v118.LastSKBuff = v28();
					v29.After(0.1 - 0, function()
						if ((v118.LastSKBuff ~= v118.LastSKCast) or ((1159 + 735) <= (2870 - (157 + 1307)))) then
							v118.LastT302pcBuff = v118.LastSKBuff;
						end
					end);
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED");
	local function v123()
		if (((3431 - (821 + 1038)) >= (3819 - 2288)) and v100.CleanseSpirit:IsAvailable()) then
			v116.DispellableDebuffs = v116.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v123();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v124()
		for v196 = 1 + 0, 10 - 4, 1 + 0 do
			if (v27(v13:TotemName(v196), "Totem") or ((11616 - 6929) < (5568 - (834 + 192)))) then
				return v196;
			end
		end
	end
	local function v125()
		if (((210 + 3081) > (428 + 1239)) and (not v100.AlphaWolf:IsAvailable() or v13:BuffDown(v100.FeralSpiritBuff))) then
			return 0 + 0;
		end
		local v156 = v26(v100.CrashLightning:TimeSinceLastCast(), v100.ChainLightning:TimeSinceLastCast());
		if ((v156 > (12 - 4)) or (v156 > v100.FeralSpirit:TimeSinceLastCast()) or ((1177 - (300 + 4)) == (544 + 1490))) then
			return 0 - 0;
		end
		return (370 - (112 + 250)) - v156;
	end
	local function v126(v157)
		return (v157:DebuffRefreshable(v100.FlameShockDebuff));
	end
	local function v127(v158)
		return (v158:DebuffRefreshable(v100.LashingFlamesDebuff));
	end
	local function v128(v159)
		return (v159:DebuffRemains(v100.FlameShockDebuff));
	end
	local function v129(v160)
		return (v13:BuffDown(v100.PrimordialWaveBuff));
	end
	local function v130(v161)
		return (v14:DebuffRemains(v100.LashingFlamesDebuff));
	end
	local function v131(v162)
		return (v100.LashingFlames:IsAvailable());
	end
	local function v132(v163)
		return v163:DebuffUp(v100.FlameShockDebuff) and (v100.FlameShockDebuff:AuraActiveCount() < v110) and (v100.FlameShockDebuff:AuraActiveCount() < (3 + 3));
	end
	local function v133()
		if ((v100.CleanseSpirit:IsReady() and v35 and v116.DispellableFriendlyUnit(62 - 37)) or ((1614 + 1202) < (6 + 5))) then
			if (((2767 + 932) < (2334 + 2372)) and v21(v102.CleanseSpiritFocus)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v134()
		if (((1966 + 680) >= (2290 - (1001 + 413))) and (not Focus or not Focus:Exists() or not Focus:IsInRange(89 - 49))) then
			return;
		end
		if (((1496 - (244 + 638)) <= (3877 - (627 + 66))) and Focus) then
			if (((9314 - 6188) == (3728 - (512 + 90))) and (Focus:HealthPercentage() <= v81) and v71 and v100.HealingSurge:IsReady() and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (1911 - (1665 + 241)))) then
				if (v21(v102.HealingSurgeFocus) or ((2904 - (373 + 344)) >= (2235 + 2719))) then
					return "healing_surge heal focus";
				end
			end
		end
	end
	local function v135()
		if ((v13:HealthPercentage() <= v85) or ((1026 + 2851) == (9429 - 5854))) then
			if (((1196 - 489) > (1731 - (35 + 1064))) and v100.HealingSurge:IsReady()) then
				if (v21(v100.HealingSurge) or ((398 + 148) >= (5742 - 3058))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v136()
		if (((6 + 1459) <= (5537 - (298 + 938))) and v100.AstralShift:IsReady() and v68 and (v13:HealthPercentage() <= v76)) then
			if (((2963 - (233 + 1026)) > (3091 - (636 + 1030))) and v21(v100.AstralShift)) then
				return "astral_shift defensive 1";
			end
		end
		if ((v100.AncestralGuidance:IsReady() and v69 and v116.AreUnitsBelowHealthPercentage(v77, v78)) or ((352 + 335) == (4136 + 98))) then
			if (v21(v100.AncestralGuidance) or ((990 + 2340) < (97 + 1332))) then
				return "ancestral_guidance defensive 2";
			end
		end
		if (((1368 - (55 + 166)) >= (65 + 270)) and v100.HealingStreamTotem:IsReady() and v70 and v116.AreUnitsBelowHealthPercentage(v79, v80)) then
			if (((346 + 3089) > (8008 - 5911)) and v21(v100.HealingStreamTotem)) then
				return "healing_stream_totem defensive 3";
			end
		end
		if ((v100.HealingSurge:IsReady() and v71 and (v13:HealthPercentage() <= v81) and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (302 - (36 + 261)))) or ((6593 - 2823) >= (5409 - (34 + 1334)))) then
			if (v21(v100.HealingSurge) or ((1458 + 2333) <= (1252 + 359))) then
				return "healing_surge defensive 4";
			end
		end
		if ((v101.Healthstone:IsReady() and v72 and (v13:HealthPercentage() <= v82)) or ((5861 - (1035 + 248)) <= (2029 - (20 + 1)))) then
			if (((587 + 538) <= (2395 - (134 + 185))) and v21(v102.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if ((v73 and (v13:HealthPercentage() <= v83)) or ((1876 - (549 + 584)) >= (5084 - (314 + 371)))) then
			if (((3964 - 2809) < (2641 - (478 + 490))) and (v94 == "Refreshing Healing Potion")) then
				if (v101.RefreshingHealingPotion:IsReady() or ((1232 + 1092) <= (1750 - (786 + 386)))) then
					if (((12201 - 8434) == (5146 - (1055 + 324))) and v21(v102.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if (((5429 - (1093 + 247)) == (3634 + 455)) and (v94 == "Dreamwalker's Healing Potion")) then
				if (((469 + 3989) >= (6646 - 4972)) and v101.DreamwalkersHealingPotion:IsReady()) then
					if (((3298 - 2326) <= (4034 - 2616)) and v21(v102.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v137()
		local v164 = 0 - 0;
		while true do
			if ((v164 == (0 + 0)) or ((19023 - 14085) < (16413 - 11651))) then
				v30 = v116.HandleTopTrinket(v103, v33, 31 + 9, nil);
				if (v30 or ((6403 - 3899) > (4952 - (364 + 324)))) then
					return v30;
				end
				v164 = 2 - 1;
			end
			if (((5166 - 3013) == (714 + 1439)) and (v164 == (4 - 3))) then
				v30 = v116.HandleBottomTrinket(v103, v33, 64 - 24, nil);
				if (v30 or ((1539 - 1032) >= (3859 - (1249 + 19)))) then
					return v30;
				end
				break;
			end
		end
	end
	local function v138()
		local v165 = 0 + 0;
		while true do
			if (((17442 - 12961) == (5567 - (686 + 400))) and (v165 == (2 + 0))) then
				if ((v100.Stormstrike:IsReady() and v48) or ((2557 - (73 + 156)) < (4 + 689))) then
					if (((5139 - (721 + 90)) == (49 + 4279)) and v21(v100.Stormstrike, not v14:IsSpellInRange(v100.Stormstrike))) then
						return "stormstrike precombat 12";
					end
				end
				break;
			end
			if (((5155 - 3567) >= (1802 - (224 + 246))) and (v165 == (0 - 0))) then
				if ((v100.WindfuryTotem:IsReady() and v50 and (v13:BuffDown(v100.WindfuryTotemBuff, true) or (v100.WindfuryTotem:TimeSinceLastCast() > (165 - 75)))) or ((758 + 3416) > (102 + 4146))) then
					if (v21(v100.WindfuryTotem) or ((3369 + 1217) <= (162 - 80))) then
						return "windfury_totem precombat 4";
					end
				end
				if (((12855 - 8992) == (4376 - (203 + 310))) and v100.FeralSpirit:IsCastable() and v54 and ((v59 and v33) or not v59)) then
					if (v21(v100.FeralSpirit) or ((2275 - (1238 + 755)) <= (3 + 39))) then
						return "feral_spirit precombat 6";
					end
				end
				v165 = 1535 - (709 + 825);
			end
			if (((8492 - 3883) >= (1115 - 349)) and (v165 == (865 - (196 + 668)))) then
				if ((v100.DoomWinds:IsCastable() and v55 and ((v60 and v33) or not v60)) or ((4548 - 3396) == (5153 - 2665))) then
					if (((4255 - (171 + 662)) > (3443 - (4 + 89))) and v21(v100.DoomWinds, not v14:IsSpellInRange(v100.DoomWinds))) then
						return "doom_winds precombat 8";
					end
				end
				if (((3073 - 2196) > (137 + 239)) and v100.Sundering:IsReady() and v49 and ((v61 and v34) or not v61)) then
					if (v21(v100.Sundering, not v14:IsInRange(21 - 16)) or ((1223 + 1895) <= (3337 - (35 + 1451)))) then
						return "sundering precombat 10";
					end
				end
				v165 = 1455 - (28 + 1425);
			end
		end
	end
	local function v139()
		if ((v100.PrimordialWave:IsCastable() and v47 and ((v62 and v34) or not v62) and (v98 < v115) and v14:DebuffDown(v100.FlameShockDebuff) and v100.LashingFlames:IsAvailable()) or ((2158 - (941 + 1052)) >= (3349 + 143))) then
			if (((5463 - (822 + 692)) < (6932 - 2076)) and v21(v100.PrimordialWave, not v14:IsSpellInRange(v100.PrimordialWave))) then
				return "primordial_wave single 1";
			end
		end
		if ((v100.FlameShock:IsReady() and v41 and v14:DebuffDown(v100.FlameShockDebuff) and v100.LashingFlames:IsAvailable()) or ((2015 + 2261) < (3313 - (45 + 252)))) then
			if (((4641 + 49) > (1420 + 2705)) and v21(v100.FlameShock, not v14:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single 2";
			end
		end
		if ((v100.ElementalBlast:IsReady() and v39 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (12 - 7)) and v100.ElementalSpirits:IsAvailable() and (v118.FeralSpiritCount >= (437 - (114 + 319)))) or ((71 - 21) >= (1147 - 251))) then
			if (v21(v100.ElementalBlast, not v14:IsSpellInRange(v100.ElementalBlast)) or ((1093 + 621) >= (4406 - 1448))) then
				return "elemental_blast single 3";
			end
		end
		if ((v100.Sundering:IsReady() and v49 and ((v61 and v34) or not v61) and (v98 < v115) and (v13:HasTier(62 - 32, 1965 - (556 + 1407)))) or ((2697 - (741 + 465)) < (1109 - (170 + 295)))) then
			if (((371 + 333) < (907 + 80)) and v21(v100.Sundering, not v14:IsInRange(19 - 11))) then
				return "sundering single 4";
			end
		end
		if (((3083 + 635) > (1223 + 683)) and v100.LightningBolt:IsReady() and v46 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (3 + 2)) and v13:BuffDown(v100.CracklingThunderBuff) and v13:BuffUp(v100.AscendanceBuff) and (v113 == "Chain Lightning") and (v13:BuffRemains(v100.AscendanceBuff) > (v100.ChainLightning:CooldownRemains() + v13:GCD()))) then
			if (v21(v100.LightningBolt, not v14:IsSpellInRange(v100.LightningBolt)) or ((2188 - (957 + 273)) > (973 + 2662))) then
				return "lightning_bolt single 5";
			end
		end
		if (((1402 + 2099) <= (17116 - 12624)) and v100.Stormstrike:IsReady() and v48 and (v13:BuffUp(v100.DoomWindsBuff) or v100.DeeplyRootedElements:IsAvailable() or (v100.Stormblast:IsAvailable() and v13:BuffUp(v100.StormbringerBuff)))) then
			if (v21(v100.Stormstrike, not v14:IsSpellInRange(v100.Stormstrike)) or ((9070 - 5628) < (7782 - 5234))) then
				return "stormstrike single 6";
			end
		end
		if (((14236 - 11361) >= (3244 - (389 + 1391))) and v100.LavaLash:IsReady() and v45 and (v13:BuffUp(v100.HotHandBuff))) then
			if (v21(v100.LavaLash, not v14:IsSpellInRange(v100.LavaLash)) or ((3010 + 1787) >= (510 + 4383))) then
				return "lava_lash single 7";
			end
		end
		if ((v100.WindfuryTotem:IsReady() and v50 and (v13:BuffDown(v100.WindfuryTotemBuff, true))) or ((1254 - 703) > (3019 - (783 + 168)))) then
			if (((7094 - 4980) > (929 + 15)) and v21(v100.WindfuryTotem)) then
				return "windfury_totem single 8";
			end
		end
		if ((v100.ElementalBlast:IsReady() and v39 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (316 - (309 + 2))) and (v100.ElementalBlast:Charges() == v112)) or ((6946 - 4684) >= (4308 - (1090 + 122)))) then
			if (v21(v100.ElementalBlast, not v14:IsSpellInRange(v100.ElementalBlast)) or ((732 + 1523) >= (11878 - 8341))) then
				return "elemental_blast single 9";
			end
		end
		if ((v100.LightningBolt:IsReady() and v46 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (6 + 2)) and v13:BuffUp(v100.PrimordialWaveBuff) and (v13:BuffDown(v100.SplinteredElementsBuff) or (v115 <= (1130 - (628 + 490))))) or ((689 + 3148) < (3233 - 1927))) then
			if (((13481 - 10531) == (3724 - (431 + 343))) and v21(v100.LightningBolt, not v14:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single 10";
			end
		end
		if ((v100.ChainLightning:IsReady() and v37 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (16 - 8)) and v13:BuffUp(v100.CracklingThunderBuff) and v100.ElementalSpirits:IsAvailable()) or ((13663 - 8940) < (2606 + 692))) then
			if (((146 + 990) >= (1849 - (556 + 1139))) and v21(v100.ChainLightning, not v14:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single 11";
			end
		end
		if ((v100.ElementalBlast:IsReady() and v39 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (23 - (6 + 9))) and ((v118.FeralSpiritCount >= (1 + 1)) or not v100.ElementalSpirits:IsAvailable())) or ((139 + 132) > (4917 - (28 + 141)))) then
			if (((1836 + 2904) >= (3890 - 738)) and v21(v100.ElementalBlast, not v14:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast single 12";
			end
		end
		if ((v100.LavaBurst:IsReady() and v44 and not v100.ThorimsInvocation:IsAvailable() and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (4 + 1))) or ((3895 - (486 + 831)) >= (8821 - 5431))) then
			if (((144 - 103) <= (314 + 1347)) and v21(v100.LavaBurst, not v14:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single 13";
			end
		end
		if (((1900 - 1299) < (4823 - (668 + 595))) and v100.LightningBolt:IsReady() and v46 and ((v13:BuffStack(v100.MaelstromWeaponBuff) >= (8 + 0)) or (v100.StaticAccumulation:IsAvailable() and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (2 + 3)))) and v13:BuffDown(v100.PrimordialWaveBuff)) then
			if (((640 - 405) < (977 - (23 + 267))) and v21(v100.LightningBolt, not v14:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single 14";
			end
		end
		if (((6493 - (1129 + 815)) > (1540 - (371 + 16))) and v100.CrashLightning:IsReady() and v38 and v100.AlphaWolf:IsAvailable() and v13:BuffUp(v100.FeralSpiritBuff) and (v125() == (1750 - (1326 + 424)))) then
			if (v21(v100.CrashLightning, not v14:IsInMeleeRange(14 - 6)) or ((17079 - 12405) < (4790 - (88 + 30)))) then
				return "crash_lightning single 15";
			end
		end
		if (((4439 - (720 + 51)) < (10145 - 5584)) and v100.PrimordialWave:IsCastable() and v47 and ((v62 and v34) or not v62) and (v98 < v115)) then
			if (v21(v100.PrimordialWave, not v14:IsSpellInRange(v100.PrimordialWave)) or ((2231 - (421 + 1355)) == (5947 - 2342))) then
				return "primordial_wave single 16";
			end
		end
		if ((v100.FlameShock:IsReady() and v41 and (v14:DebuffDown(v100.FlameShockDebuff))) or ((1309 + 1354) == (4395 - (286 + 797)))) then
			if (((15635 - 11358) <= (7411 - 2936)) and v21(v100.FlameShock, not v14:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single 17";
			end
		end
		if ((v100.IceStrike:IsReady() and v43 and v100.ElementalAssault:IsAvailable() and v100.SwirlingMaelstrom:IsAvailable()) or ((1309 - (397 + 42)) == (372 + 817))) then
			if (((2353 - (24 + 776)) <= (4826 - 1693)) and v21(v100.IceStrike, not v14:IsInMeleeRange(790 - (222 + 563)))) then
				return "ice_strike single 18";
			end
		end
		if ((v100.LavaLash:IsReady() and v45 and (v100.LashingFlames:IsAvailable())) or ((4928 - 2691) >= (2528 + 983))) then
			if (v21(v100.LavaLash, not v14:IsSpellInRange(v100.LavaLash)) or ((1514 - (23 + 167)) > (4818 - (690 + 1108)))) then
				return "lava_lash single 19";
			end
		end
		if ((v100.IceStrike:IsReady() and v43 and (v13:BuffDown(v100.IceStrikeBuff))) or ((1080 + 1912) == (1552 + 329))) then
			if (((3954 - (40 + 808)) > (252 + 1274)) and v21(v100.IceStrike, not v14:IsInMeleeRange(19 - 14))) then
				return "ice_strike single 20";
			end
		end
		if (((2890 + 133) < (2048 + 1822)) and v100.FrostShock:IsReady() and v42 and (v13:BuffUp(v100.HailstormBuff))) then
			if (((79 + 64) > (645 - (47 + 524))) and v21(v100.FrostShock, not v14:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single 21";
			end
		end
		if (((12 + 6) < (5773 - 3661)) and v100.LavaLash:IsReady() and v45) then
			if (((1639 - 542) <= (3712 - 2084)) and v21(v100.LavaLash, not v14:IsSpellInRange(v100.LavaLash))) then
				return "lava_lash single 22";
			end
		end
		if (((6356 - (1165 + 561)) == (138 + 4492)) and v100.IceStrike:IsReady() and v43) then
			if (((10963 - 7423) > (1024 + 1659)) and v21(v100.IceStrike, not v14:IsInMeleeRange(484 - (341 + 138)))) then
				return "ice_strike single 23";
			end
		end
		if (((1295 + 3499) >= (6758 - 3483)) and v100.Windstrike:IsCastable() and v51) then
			if (((1810 - (89 + 237)) == (4773 - 3289)) and v21(v100.Windstrike, not v14:IsSpellInRange(v100.Windstrike))) then
				return "windstrike single 24";
			end
		end
		if (((3014 - 1582) < (4436 - (581 + 300))) and v100.Stormstrike:IsReady() and v48) then
			if (v21(v100.Stormstrike, not v14:IsSpellInRange(v100.Stormstrike)) or ((2285 - (855 + 365)) > (8498 - 4920))) then
				return "stormstrike single 25";
			end
		end
		if ((v100.Sundering:IsReady() and v49 and ((v61 and v34) or not v61) and (v98 < v115)) or ((1566 + 3229) < (2642 - (1030 + 205)))) then
			if (((1740 + 113) < (4478 + 335)) and v21(v100.Sundering, not v14:IsInRange(294 - (156 + 130)))) then
				return "sundering single 26";
			end
		end
		if ((v100.BagofTricks:IsReady() and v57 and ((v64 and v33) or not v64)) or ((6409 - 3588) < (4096 - 1665))) then
			if (v21(v100.BagofTricks) or ((5885 - 3011) < (575 + 1606))) then
				return "bag_of_tricks single 27";
			end
		end
		if ((v100.FireNova:IsReady() and v40 and v100.SwirlingMaelstrom:IsAvailable() and v14:DebuffUp(v100.FlameShockDebuff) and (v13:BuffStack(v100.MaelstromWeaponBuff) < (3 + 2 + ((74 - (10 + 59)) * v22(v100.OverflowingMaelstrom:IsAvailable()))))) or ((761 + 1928) <= (1689 - 1346))) then
			if (v21(v100.FireNova) or ((3032 - (671 + 492)) == (1600 + 409))) then
				return "fire_nova single 28";
			end
		end
		if ((v100.LightningBolt:IsReady() and v46 and v100.Hailstorm:IsAvailable() and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (1220 - (369 + 846))) and v13:BuffDown(v100.PrimordialWaveBuff)) or ((939 + 2607) < (1982 + 340))) then
			if (v21(v100.LightningBolt, not v14:IsSpellInRange(v100.LightningBolt)) or ((4027 - (1036 + 909)) == (3795 + 978))) then
				return "lightning_bolt single 29";
			end
		end
		if (((5445 - 2201) > (1258 - (11 + 192))) and v100.FrostShock:IsReady() and v42) then
			if (v21(v100.FrostShock, not v14:IsSpellInRange(v100.FrostShock)) or ((1675 + 1638) <= (1953 - (135 + 40)))) then
				return "frost_shock single 30";
			end
		end
		if ((v100.CrashLightning:IsReady() and v38) or ((3442 - 2021) >= (1269 + 835))) then
			if (((3991 - 2179) <= (4870 - 1621)) and v21(v100.CrashLightning, not v14:IsInMeleeRange(184 - (50 + 126)))) then
				return "crash_lightning single 31";
			end
		end
		if (((4519 - 2896) <= (434 + 1523)) and v100.FireNova:IsReady() and v40 and (v14:DebuffUp(v100.FlameShockDebuff))) then
			if (((5825 - (1233 + 180)) == (5381 - (522 + 447))) and v21(v100.FireNova)) then
				return "fire_nova single 32";
			end
		end
		if (((3171 - (107 + 1314)) >= (391 + 451)) and v100.EarthElemental:IsCastable() and UseEarthElemental and ((EarthElementalWithCD and v33) or not EarthElementalWithCD)) then
			if (((13321 - 8949) > (786 + 1064)) and v21(v100.EarthElemental)) then
				return "earth_elemental single 33";
			end
		end
		if (((460 - 228) < (3248 - 2427)) and v100.FlameShock:IsReady() and v41) then
			if (((2428 - (716 + 1194)) < (16 + 886)) and v21(v100.FlameShock, not v14:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single 34";
			end
		end
		if (((321 + 2673) > (1361 - (74 + 429))) and v100.ChainLightning:IsReady() and v37 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (9 - 4)) and v13:BuffUp(v100.CracklingThunderBuff) and v100.ElementalSpirits:IsAvailable()) then
			if (v21(v100.ChainLightning, not v14:IsSpellInRange(v100.ChainLightning)) or ((1862 + 1893) <= (2094 - 1179))) then
				return "chain_lightning single 35";
			end
		end
		if (((2792 + 1154) > (11539 - 7796)) and v100.LightningBolt:IsReady() and v46 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (12 - 7)) and v13:BuffDown(v100.PrimordialWaveBuff)) then
			if (v21(v100.LightningBolt, not v14:IsSpellInRange(v100.LightningBolt)) or ((1768 - (279 + 154)) >= (4084 - (454 + 324)))) then
				return "lightning_bolt single 36";
			end
		end
		if (((3812 + 1032) > (2270 - (12 + 5))) and v100.WindfuryTotem:IsReady() and v50 and (v13:BuffDown(v100.WindfuryTotemBuff, true) or (v100.WindfuryTotem:TimeSinceLastCast() > (49 + 41)))) then
			if (((1151 - 699) == (168 + 284)) and v21(v100.WindfuryTotem)) then
				return "windfury_totem single 37";
			end
		end
	end
	local function v140()
		local v166 = 1093 - (277 + 816);
		while true do
			if ((v166 == (4 - 3)) or ((5740 - (1058 + 125)) < (392 + 1695))) then
				if (((4849 - (815 + 160)) == (16621 - 12747)) and v100.ChainLightning:IsReady() and v37 and (v13:BuffStack(v100.MaelstromWeaponBuff) == ((11 - 6) + ((2 + 3) * v22(v100.OverflowingMaelstrom:IsAvailable()))))) then
					if (v21(v100.ChainLightning, not v14:IsSpellInRange(v100.ChainLightning)) or ((5665 - 3727) > (6833 - (41 + 1857)))) then
						return "chain_lightning aoe 7";
					end
				end
				if ((v100.CrashLightning:IsReady() and v38 and (v13:BuffUp(v100.DoomWindsBuff) or v13:BuffDown(v100.CrashLightningBuff) or (v100.AlphaWolf:IsAvailable() and v13:BuffUp(v100.FeralSpiritBuff) and (v125() == (1893 - (1222 + 671)))))) or ((10997 - 6742) < (4919 - 1496))) then
					if (((2636 - (229 + 953)) <= (4265 - (1111 + 663))) and v21(v100.CrashLightning, not v14:IsInMeleeRange(1587 - (874 + 705)))) then
						return "crash_lightning aoe 8";
					end
				end
				if ((v100.Sundering:IsReady() and v49 and ((v61 and v34) or not v61) and (v98 < v115) and (v13:BuffUp(v100.DoomWindsBuff) or v13:HasTier(5 + 25, 2 + 0))) or ((8640 - 4483) <= (79 + 2724))) then
					if (((5532 - (642 + 37)) >= (680 + 2302)) and v21(v100.Sundering, not v14:IsInRange(2 + 6))) then
						return "sundering aoe 9";
					end
				end
				if (((10379 - 6245) > (3811 - (233 + 221))) and v100.FireNova:IsReady() and v40 and ((v100.FlameShockDebuff:AuraActiveCount() >= (13 - 7)) or ((v100.FlameShockDebuff:AuraActiveCount() >= (4 + 0)) and (v100.FlameShockDebuff:AuraActiveCount() >= v110)))) then
					if (v21(v100.FireNova) or ((4958 - (718 + 823)) < (1595 + 939))) then
						return "fire_nova aoe 10";
					end
				end
				if ((v100.LavaLash:IsReady() and v45 and (v100.LashingFlames:IsAvailable())) or ((3527 - (266 + 539)) <= (464 - 300))) then
					local v235 = 1225 - (636 + 589);
					while true do
						if (((0 - 0) == v235) or ((4966 - 2558) < (1672 + 437))) then
							if (v116.CastCycle(v100.LavaLash, v109, v127, not v14:IsSpellInRange(v100.LavaLash)) or ((12 + 21) == (2470 - (657 + 358)))) then
								return "lava_lash aoe 11";
							end
							if (v21(v100.LavaLash, not v14:IsSpellInRange(v100.LavaLash)) or ((1172 - 729) >= (9147 - 5132))) then
								return "lava_lash aoe no_cycle 11";
							end
							break;
						end
					end
				end
				if (((4569 - (1151 + 36)) > (161 + 5)) and v100.LavaLash:IsReady() and v45 and ((v100.MoltenAssault:IsAvailable() and v14:DebuffUp(v100.FlameShockDebuff) and (v100.FlameShockDebuff:AuraActiveCount() < v110) and (v100.FlameShockDebuff:AuraActiveCount() < (2 + 4))) or (v100.AshenCatalyst:IsAvailable() and (v13:BuffStack(v100.AshenCatalystBuff) == (14 - 9))))) then
					if (v21(v100.LavaLash, not v14:IsSpellInRange(v100.LavaLash)) or ((2112 - (1552 + 280)) == (3893 - (64 + 770)))) then
						return "lava_lash aoe 12";
					end
				end
				v166 = 2 + 0;
			end
			if (((4269 - 2388) > (230 + 1063)) and (v166 == (1246 - (157 + 1086)))) then
				if (((4717 - 2360) == (10322 - 7965)) and v100.Stormstrike:IsReady() and v48 and v13:BuffUp(v100.CrashLightningBuff) and (v100.DeeplyRootedElements:IsAvailable() or (v13:BuffStack(v100.ConvergingStormsBuff) == (8 - 2)))) then
					if (((167 - 44) == (942 - (599 + 220))) and v21(v100.Stormstrike, not v14:IsSpellInRange(v100.Stormstrike))) then
						return "stormstrike aoe 19";
					end
				end
				if ((v100.CrashLightning:IsReady() and v38 and v100.CrashingStorms:IsAvailable() and v13:BuffUp(v100.CLCrashLightningBuff) and (v110 >= (7 - 3))) or ((2987 - (1813 + 118)) >= (2480 + 912))) then
					if (v21(v100.CrashLightning, not v14:IsInMeleeRange(1225 - (841 + 376))) or ((1514 - 433) < (250 + 825))) then
						return "crash_lightning aoe 20";
					end
				end
				if ((v100.Windstrike:IsCastable() and v51) or ((2863 - 1814) >= (5291 - (464 + 395)))) then
					if (v21(v100.Windstrike, not v14:IsSpellInRange(v100.Windstrike)) or ((12236 - 7468) <= (407 + 439))) then
						return "windstrike aoe 21";
					end
				end
				if ((v100.Stormstrike:IsReady() and v48) or ((4195 - (467 + 370)) <= (2934 - 1514))) then
					if (v21(v100.Stormstrike, not v14:IsSpellInRange(v100.Stormstrike)) or ((2745 + 994) <= (10301 - 7296))) then
						return "stormstrike aoe 22";
					end
				end
				if ((v100.IceStrike:IsReady() and v43) or ((259 + 1400) >= (4964 - 2830))) then
					if (v21(v100.IceStrike, not v14:IsInMeleeRange(525 - (150 + 370))) or ((4542 - (74 + 1208)) < (5792 - 3437))) then
						return "ice_strike aoe 23";
					end
				end
				if ((v100.LavaLash:IsReady() and v45) or ((3172 - 2503) == (3005 + 1218))) then
					if (v21(v100.LavaLash, not v14:IsSpellInRange(v100.LavaLash)) or ((2082 - (14 + 376)) < (1019 - 431))) then
						return "lava_lash aoe 24";
					end
				end
				v166 = 3 + 1;
			end
			if (((2 + 0) == v166) or ((4575 + 222) < (10697 - 7046))) then
				if ((v100.IceStrike:IsReady() and v43 and (v100.Hailstorm:IsAvailable())) or ((3143 + 1034) > (4928 - (23 + 55)))) then
					if (v21(v100.IceStrike, not v14:IsInMeleeRange(11 - 6)) or ((267 + 133) > (998 + 113))) then
						return "ice_strike aoe 13";
					end
				end
				if (((4730 - 1679) > (317 + 688)) and v100.FrostShock:IsReady() and v42 and v100.Hailstorm:IsAvailable() and v13:BuffUp(v100.HailstormBuff)) then
					if (((4594 - (652 + 249)) <= (11726 - 7344)) and v21(v100.FrostShock, not v14:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock aoe 14";
					end
				end
				if ((v100.Sundering:IsReady() and v49 and ((v61 and v34) or not v61) and (v98 < v115)) or ((5150 - (708 + 1160)) > (11129 - 7029))) then
					if (v21(v100.Sundering, not v14:IsInRange(14 - 6)) or ((3607 - (10 + 17)) < (639 + 2205))) then
						return "sundering aoe 15";
					end
				end
				if (((1821 - (1400 + 332)) < (8612 - 4122)) and v100.FlameShock:IsReady() and v41 and v100.MoltenAssault:IsAvailable() and v14:DebuffDown(v100.FlameShockDebuff)) then
					if (v21(v100.FlameShock, not v14:IsSpellInRange(v100.FlameShock)) or ((6891 - (242 + 1666)) < (774 + 1034))) then
						return "flame_shock aoe 16";
					end
				end
				if (((1404 + 2425) > (3213 + 556)) and v100.FlameShock:IsReady() and v41 and v14:DebuffRefreshable(v100.FlameShockDebuff) and (v100.FireNova:IsAvailable() or v100.PrimordialWave:IsAvailable()) and (v100.FlameShockDebuff:AuraActiveCount() < v110) and (v100.FlameShockDebuff:AuraActiveCount() < (946 - (850 + 90)))) then
					local v236 = 0 - 0;
					while true do
						if (((2875 - (360 + 1030)) <= (2570 + 334)) and (v236 == (0 - 0))) then
							if (((5872 - 1603) == (5930 - (909 + 752))) and v116.CastCycle(v100.FlameShock, v109, v126, not v14:IsSpellInRange(v100.FlameShock))) then
								return "flame_shock aoe 17";
							end
							if (((1610 - (109 + 1114)) <= (5092 - 2310)) and v21(v100.FlameShock, not v14:IsSpellInRange(v100.FlameShock))) then
								return "flame_shock aoe no_cycle 17";
							end
							break;
						end
					end
				end
				if ((v100.FireNova:IsReady() and v40 and (v100.FlameShockDebuff:AuraActiveCount() >= (2 + 1))) or ((2141 - (6 + 236)) <= (578 + 339))) then
					if (v21(v100.FireNova) or ((3471 + 841) <= (2065 - 1189))) then
						return "fire_nova aoe 18";
					end
				end
				v166 = 4 - 1;
			end
			if (((3365 - (1076 + 57)) <= (427 + 2169)) and (v166 == (689 - (579 + 110)))) then
				if (((166 + 1929) < (3259 + 427)) and v100.CrashLightning:IsReady() and v38 and v100.CrashingStorms:IsAvailable() and ((v100.UnrulyWinds:IsAvailable() and (v110 >= (6 + 4))) or (v110 >= (422 - (174 + 233))))) then
					if (v21(v100.CrashLightning, not v14:IsInMeleeRange(22 - 14)) or ((2799 - 1204) >= (1990 + 2484))) then
						return "crash_lightning aoe 1";
					end
				end
				if ((v100.LightningBolt:IsReady() and v46 and ((v100.FlameShockDebuff:AuraActiveCount() >= v110) or (v13:BuffRemains(v100.PrimordialWaveBuff) < (v13:GCD() * (1177 - (663 + 511)))) or (v100.FlameShockDebuff:AuraActiveCount() >= (6 + 0))) and v13:BuffUp(v100.PrimordialWaveBuff) and (v13:BuffStack(v100.MaelstromWeaponBuff) == (2 + 3 + ((15 - 10) * v22(v100.OverflowingMaelstrom:IsAvailable())))) and (v13:BuffDown(v100.SplinteredElementsBuff) or (v115 <= (8 + 4)) or (v98 <= v13:GCD()))) or ((10874 - 6255) < (6976 - 4094))) then
					if (v21(v100.LightningBolt, not v14:IsSpellInRange(v100.LightningBolt)) or ((141 + 153) >= (9402 - 4571))) then
						return "lightning_bolt aoe 2";
					end
				end
				if (((1447 + 582) <= (282 + 2802)) and v100.LavaLash:IsReady() and v45 and v100.MoltenAssault:IsAvailable() and (v100.PrimordialWave:IsAvailable() or v100.FireNova:IsAvailable()) and v14:DebuffUp(v100.FlameShockDebuff) and (v100.FlameShockDebuff:AuraActiveCount() < v110) and (v100.FlameShockDebuff:AuraActiveCount() < (728 - (478 + 244)))) then
					if (v21(v100.LavaLash, not v14:IsSpellInRange(v100.LavaLash)) or ((2554 - (440 + 77)) == (1101 + 1319))) then
						return "lava_lash aoe 3";
					end
				end
				if (((16316 - 11858) > (5460 - (655 + 901))) and v100.PrimordialWave:IsCastable() and v47 and ((v62 and v34) or not v62) and (v98 < v115) and (v13:BuffDown(v100.PrimordialWaveBuff))) then
					if (((81 + 355) >= (95 + 28)) and v116.CastCycle(v100.PrimordialWave, v109, v126, not v14:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave aoe 4";
					end
					if (((338 + 162) < (7315 - 5499)) and v21(v100.PrimordialWave, not v14:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave aoe no_cycle 4";
					end
				end
				if (((5019 - (695 + 750)) == (12204 - 8630)) and v100.FlameShock:IsReady() and v41 and (v100.PrimordialWave:IsAvailable() or v100.FireNova:IsAvailable()) and v14:DebuffDown(v100.FlameShockDebuff)) then
					if (((340 - 119) < (1568 - 1178)) and v21(v100.FlameShock, not v14:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock aoe 5";
					end
				end
				if ((v100.ElementalBlast:IsReady() and v39 and (not v100.ElementalSpirits:IsAvailable() or (v100.ElementalSpirits:IsAvailable() and ((v100.ElementalBlast:Charges() == v112) or (v118.FeralSpiritCount >= (353 - (285 + 66)))))) and (v13:BuffStack(v100.MaelstromWeaponBuff) == ((11 - 6) + ((1315 - (682 + 628)) * v22(v100.OverflowingMaelstrom:IsAvailable())))) and (not v100.CrashingStorms:IsAvailable() or (v110 <= (1 + 2)))) or ((2512 - (176 + 123)) <= (595 + 826))) then
					if (((2219 + 839) < (5129 - (239 + 30))) and v21(v100.ElementalBlast, not v14:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast aoe 6";
					end
				end
				v166 = 1 + 0;
			end
			if ((v166 == (5 + 0)) or ((2293 - 997) >= (13870 - 9424))) then
				if ((v100.FrostShock:IsReady() and v42 and not v100.Hailstorm:IsAvailable()) or ((1708 - (306 + 9)) > (15664 - 11175))) then
					if (v21(v100.FrostShock, not v14:IsSpellInRange(v100.FrostShock)) or ((770 + 3654) < (17 + 10))) then
						return "frost_shock aoe 31";
					end
				end
				break;
			end
			if ((v166 == (2 + 2)) or ((5710 - 3713) > (5190 - (1140 + 235)))) then
				if (((2206 + 1259) > (1755 + 158)) and v100.CrashLightning:IsReady() and v38) then
					if (((189 + 544) < (1871 - (33 + 19))) and v21(v100.CrashLightning, not v14:IsInMeleeRange(3 + 5))) then
						return "crash_lightning aoe 25";
					end
				end
				if ((v100.FireNova:IsReady() and v40 and (v100.FlameShockDebuff:AuraActiveCount() >= (5 - 3))) or ((1937 + 2458) == (9324 - 4569))) then
					if (v21(v100.FireNova) or ((3557 + 236) < (3058 - (586 + 103)))) then
						return "fire_nova aoe 26";
					end
				end
				if ((v100.ElementalBlast:IsReady() and v39 and (not v100.ElementalSpirits:IsAvailable() or (v100.ElementalSpirits:IsAvailable() and ((v100.ElementalBlast:Charges() == v112) or (v118.FeralSpiritCount >= (1 + 1))))) and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (15 - 10)) and (not v100.CrashingStorms:IsAvailable() or (v110 <= (1491 - (1309 + 179))))) or ((7372 - 3288) == (116 + 149))) then
					if (((11703 - 7345) == (3292 + 1066)) and v21(v100.ElementalBlast, not v14:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast aoe 27";
					end
				end
				if ((v100.ChainLightning:IsReady() and v37 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (10 - 5))) or ((6252 - 3114) < (1602 - (295 + 314)))) then
					if (((8179 - 4849) > (4285 - (1300 + 662))) and v21(v100.ChainLightning, not v14:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning aoe 28";
					end
				end
				if ((v100.WindfuryTotem:IsReady() and v50 and (v13:BuffDown(v100.WindfuryTotemBuff, true) or (v100.WindfuryTotem:TimeSinceLastCast() > (282 - 192)))) or ((5381 - (1178 + 577)) == (2072 + 1917))) then
					if (v21(v100.WindfuryTotem) or ((2707 - 1791) == (4076 - (851 + 554)))) then
						return "windfury_totem aoe 29";
					end
				end
				if (((241 + 31) == (753 - 481)) and v100.FlameShock:IsReady() and v41 and (v14:DebuffDown(v100.FlameShockDebuff))) then
					if (((9227 - 4978) <= (5141 - (115 + 187))) and v21(v100.FlameShock, not v14:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock aoe 30";
					end
				end
				v166 = 4 + 1;
			end
		end
	end
	local function v141()
		local v167 = 0 + 0;
		while true do
			if (((10943 - 8166) < (4361 - (160 + 1001))) and (v167 == (2 + 0))) then
				if (((66 + 29) < (4005 - 2048)) and v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) then
					if (((1184 - (237 + 121)) < (2614 - (525 + 372))) and v21(v100.AncestralSpirit, nil, true)) then
						return "resurrection";
					end
				end
				if (((2702 - 1276) >= (3630 - 2525)) and v116.TargetIsValid() and v31) then
					if (((2896 - (96 + 46)) <= (4156 - (643 + 134))) and not v13:AffectingCombat()) then
						local v245 = v138();
						if (v245 or ((1418 + 2509) == (3387 - 1974))) then
							return v245;
						end
					end
				end
				break;
			end
			if ((v167 == (3 - 2)) or ((1107 + 47) <= (1546 - 758))) then
				if (((not v105 or (v107 < (1226475 - 626475))) and v52 and v100.FlamentongueWeapon:IsCastable()) or ((2362 - (316 + 403)) > (2247 + 1132))) then
					if (v21(v100.FlamentongueWeapon) or ((7706 - 4903) > (1644 + 2905))) then
						return "flametongue_weapon enchant";
					end
				end
				if (v84 or ((554 - 334) >= (2142 + 880))) then
					v30 = v135();
					if (((910 + 1912) == (9777 - 6955)) and v30) then
						return v30;
					end
				end
				v167 = 9 - 7;
			end
			if ((v167 == (0 - 0)) or ((61 + 1000) == (3655 - 1798))) then
				if (((135 + 2625) > (4012 - 2648)) and v74 and v100.EarthShield:IsCastable() and v13:BuffDown(v100.EarthShieldBuff) and ((v75 == "Earth Shield") or (v100.ElementalOrbit:IsAvailable() and v13:BuffUp(v100.LightningShield)))) then
					if (v21(v100.EarthShield) or ((4919 - (12 + 5)) <= (13963 - 10368))) then
						return "earth_shield main 2";
					end
				elseif ((v74 and v100.LightningShield:IsCastable() and v13:BuffDown(v100.LightningShieldBuff) and ((v75 == "Lightning Shield") or (v100.ElementalOrbit:IsAvailable() and v13:BuffUp(v100.EarthShield)))) or ((8218 - 4366) == (622 - 329))) then
					if (v21(v100.LightningShield) or ((3865 - 2306) == (932 + 3656))) then
						return "lightning_shield main 2";
					end
				end
				if (((not v104 or (v106 < (601973 - (1656 + 317)))) and v52 and v100.WindfuryWeapon:IsCastable()) or ((3996 + 488) == (632 + 156))) then
					if (((12146 - 7578) >= (19228 - 15321)) and v21(v100.WindfuryWeapon)) then
						return "windfury_weapon enchant";
					end
				end
				v167 = 355 - (5 + 349);
			end
		end
	end
	local function v142()
		local v168 = 0 - 0;
		while true do
			if (((2517 - (266 + 1005)) < (2287 + 1183)) and (v168 == (6 - 4))) then
				if (((5355 - 1287) >= (2668 - (561 + 1135))) and Focus) then
					if (((641 - 148) < (12796 - 8903)) and v91) then
						v30 = v133();
						if (v30 or ((2539 - (507 + 559)) >= (8360 - 5028))) then
							return v30;
						end
					end
				end
				if ((v100.GreaterPurge:IsAvailable() and v99 and v100.GreaterPurge:IsReady() and v35 and v90 and not v13:IsCasting() and not v13:IsChanneling() and v116.UnitHasMagicBuff(v14)) or ((12528 - 8477) <= (1545 - (212 + 176)))) then
					if (((1509 - (250 + 655)) < (7856 - 4975)) and v21(v100.GreaterPurge, not v14:IsSpellInRange(v100.GreaterPurge))) then
						return "greater_purge damage";
					end
				end
				v168 = 5 - 2;
			end
			if ((v168 == (0 - 0)) or ((2856 - (1869 + 87)) == (11712 - 8335))) then
				v30 = v136();
				if (((6360 - (484 + 1417)) > (1266 - 675)) and v30) then
					return v30;
				end
				v168 = 1 - 0;
			end
			if (((4171 - (48 + 725)) >= (3912 - 1517)) and (v168 == (2 - 1))) then
				if (v92 or ((1269 + 914) >= (7546 - 4722))) then
					local v237 = 0 + 0;
					while true do
						if (((565 + 1371) == (2789 - (152 + 701))) and (v237 == (1312 - (430 + 881)))) then
							if (v88 or ((1851 + 2981) < (5208 - (557 + 338)))) then
								local v253 = 0 + 0;
								while true do
									if (((11519 - 7431) > (13565 - 9691)) and (v253 == (0 - 0))) then
										v30 = v116.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 64 - 34);
										if (((5133 - (499 + 302)) == (5198 - (39 + 827))) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							if (((11038 - 7039) >= (6476 - 3576)) and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (19 - 14)) and v89) then
								local v254 = 0 - 0;
								while true do
									if ((v254 == (0 + 0)) or ((7390 - 4865) > (651 + 3413))) then
										v30 = v116.HandleAfflicted(v100.HealingSurge, v102.HealingSurgeMouseover, 63 - 23, true);
										if (((4475 - (103 + 1)) == (4925 - (475 + 79))) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							break;
						end
						if (((0 - 0) == v237) or ((851 - 585) > (645 + 4341))) then
							if (((1753 + 238) >= (2428 - (1395 + 108))) and v86) then
								v30 = v116.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 116 - 76);
								if (((1659 - (7 + 1197)) < (896 + 1157)) and v30) then
									return v30;
								end
							end
							if (v87 or ((289 + 537) == (5170 - (27 + 292)))) then
								v30 = v116.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 87 - 57);
								if (((232 - 49) == (767 - 584)) and v30) then
									return v30;
								end
							end
							v237 = 1 - 0;
						end
					end
				end
				if (((2206 - 1047) <= (1927 - (43 + 96))) and v93) then
					v30 = v116.HandleIncorporeal(v100.Hex, v102.HexMouseOver, 122 - 92, true);
					if (v30 or ((7928 - 4421) > (3583 + 735))) then
						return v30;
					end
				end
				v168 = 1 + 1;
			end
			if ((v168 == (7 - 3)) or ((1179 + 1896) <= (5556 - 2591))) then
				if (((430 + 935) <= (148 + 1863)) and v30) then
					return v30;
				end
				if (v116.TargetIsValid() or ((4527 - (1414 + 337)) > (5515 - (1642 + 298)))) then
					local v238 = v116.HandleDPSPotion(v13:BuffUp(v100.FeralSpiritBuff));
					if (v238 or ((6657 - 4103) == (13820 - 9016))) then
						return v238;
					end
					if (((7647 - 5070) == (849 + 1728)) and (v98 < v115)) then
						if ((v56 and ((v33 and v63) or not v63)) or ((5 + 1) >= (2861 - (357 + 615)))) then
							v30 = v137();
							if (((356 + 150) <= (4642 - 2750)) and v30) then
								return v30;
							end
						end
					end
					if (((v98 < v115) and v57 and ((v64 and v33) or not v64)) or ((1721 + 287) > (4752 - 2534))) then
						local v246 = 0 + 0;
						while true do
							if (((26 + 353) <= (2607 + 1540)) and (v246 == (1301 - (384 + 917)))) then
								if ((v100.BloodFury:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (747 - (128 + 569))))) or ((6057 - (1407 + 136)) <= (2896 - (687 + 1200)))) then
									if (v21(v100.BloodFury) or ((5206 - (556 + 1154)) == (4193 - 3001))) then
										return "blood_fury racial";
									end
								end
								if ((v100.Berserking:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff))) or ((303 - (9 + 86)) == (3380 - (275 + 146)))) then
									if (((696 + 3581) >= (1377 - (29 + 35))) and v21(v100.Berserking)) then
										return "berserking racial";
									end
								end
								v246 = 4 - 3;
							end
							if (((7726 - 5139) < (14011 - 10837)) and (v246 == (1 + 0))) then
								if ((v100.Fireblood:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (1062 - (53 + 959))))) or ((4528 - (312 + 96)) <= (3814 - 1616))) then
									if (v21(v100.Fireblood) or ((1881 - (147 + 138)) == (1757 - (813 + 86)))) then
										return "fireblood racial";
									end
								end
								if (((2910 + 310) == (5965 - 2745)) and v100.AncestralCall:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (542 - (18 + 474))))) then
									if (v21(v100.AncestralCall) or ((473 + 929) > (11815 - 8195))) then
										return "ancestral_call racial";
									end
								end
								break;
							end
						end
					end
					if (((3660 - (860 + 226)) == (2877 - (121 + 182))) and v100.TotemicProjection:IsCastable() and (v100.WindfuryTotem:TimeSinceLastCast() < (12 + 78)) and v13:BuffDown(v100.WindfuryTotemBuff, true)) then
						if (((3038 - (988 + 252)) < (312 + 2445)) and v21(v102.TotemicProjectionPlayer)) then
							return "totemic_projection wind_fury main 0";
						end
					end
					if ((v100.Windstrike:IsCastable() and v51) or ((119 + 258) > (4574 - (49 + 1921)))) then
						if (((1458 - (223 + 667)) < (963 - (51 + 1))) and v21(v100.Windstrike, not v14:IsSpellInRange(v100.Windstrike))) then
							return "windstrike main 1";
						end
					end
					if (((5654 - 2369) < (9053 - 4825)) and v100.PrimordialWave:IsCastable() and v47 and ((v62 and v34) or not v62) and (v98 < v115) and (v13:HasTier(1156 - (146 + 979), 1 + 1))) then
						if (((4521 - (311 + 294)) > (9280 - 5952)) and v21(v100.PrimordialWave, not v14:IsSpellInRange(v100.PrimordialWave))) then
							return "primordial_wave main 2";
						end
					end
					if (((1059 + 1441) < (5282 - (496 + 947))) and v100.FeralSpirit:IsCastable() and v54 and ((v59 and v33) or not v59) and (v98 < v115)) then
						if (((1865 - (1233 + 125)) == (206 + 301)) and v21(v100.FeralSpirit)) then
							return "feral_spirit main 3";
						end
					end
					if (((216 + 24) <= (602 + 2563)) and v100.Ascendance:IsCastable() and v53 and ((v58 and v33) or not v58) and (v98 < v115) and v14:DebuffUp(v100.FlameShockDebuff) and (((v113 == "Lightning Bolt") and (v110 == (1646 - (963 + 682)))) or ((v113 == "Chain Lightning") and (v110 > (1 + 0))))) then
						if (((2338 - (504 + 1000)) >= (543 + 262)) and v21(v100.Ascendance)) then
							return "ascendance main 4";
						end
					end
					if ((v100.DoomWinds:IsCastable() and v55 and ((v60 and v33) or not v60) and (v98 < v115)) or ((3472 + 340) < (219 + 2097))) then
						if (v21(v100.DoomWinds, not v14:IsInMeleeRange(7 - 2)) or ((2266 + 386) <= (892 + 641))) then
							return "doom_winds main 5";
						end
					end
					if ((v110 == (183 - (156 + 26))) or ((2073 + 1525) < (2284 - 824))) then
						local v247 = v139();
						if (v247 or ((4280 - (149 + 15)) < (2152 - (890 + 70)))) then
							return v247;
						end
					end
					if ((v32 and (v110 > (118 - (39 + 78)))) or ((3859 - (14 + 468)) <= (1985 - 1082))) then
						local v248 = v140();
						if (((11113 - 7137) >= (227 + 212)) and v248) then
							return v248;
						end
					end
					if (((2254 + 1498) == (798 + 2954)) and v18.CastAnnotated(v100.Pool, false, "WAIT")) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if (((1828 + 2218) > (707 + 1988)) and (v168 == (5 - 2))) then
				if ((v100.Purge:IsReady() and v99 and v35 and v90 and not v13:IsCasting() and not v13:IsChanneling() and v116.UnitHasMagicBuff(v14)) or ((3504 + 41) == (11234 - 8037))) then
					if (((61 + 2333) > (424 - (12 + 39))) and v21(v100.Purge, not v14:IsSpellInRange(v100.Purge))) then
						return "purge damage";
					end
				end
				v30 = v134();
				v168 = 4 + 0;
			end
		end
	end
	local function v143()
		v53 = EpicSettings.Settings['useAscendance'];
		v55 = EpicSettings.Settings['useDoomWinds'];
		v54 = EpicSettings.Settings['useFeralSpirit'];
		v37 = EpicSettings.Settings['useChainlightning'];
		v38 = EpicSettings.Settings['useCrashLightning'];
		v39 = EpicSettings.Settings['useElementalBlast'];
		v40 = EpicSettings.Settings['useFireNova'];
		v41 = EpicSettings.Settings['useFlameShock'];
		v42 = EpicSettings.Settings['useFrostShock'];
		v43 = EpicSettings.Settings['useIceStrike'];
		v44 = EpicSettings.Settings['useLavaBurst'];
		v45 = EpicSettings.Settings['useLavaLash'];
		v46 = EpicSettings.Settings['useLightningBolt'];
		v47 = EpicSettings.Settings['usePrimordialWave'];
		v48 = EpicSettings.Settings['useStormStrike'];
		v49 = EpicSettings.Settings['useSundering'];
		v51 = EpicSettings.Settings['useWindstrike'];
		v50 = EpicSettings.Settings['useWindfuryTotem'];
		v52 = EpicSettings.Settings['useWeaponEnchant'];
		v58 = EpicSettings.Settings['ascendanceWithCD'];
		v60 = EpicSettings.Settings['doomWindsWithCD'];
		v59 = EpicSettings.Settings['feralSpiritWithCD'];
		v62 = EpicSettings.Settings['primordialWaveWithMiniCD'];
		v61 = EpicSettings.Settings['sunderingWithMiniCD'];
	end
	local function v144()
		local v193 = 0 - 0;
		while true do
			if (((14798 - 10643) <= (1255 + 2977)) and (v193 == (3 + 1))) then
				v85 = EpicSettings.Settings['healOOCHP'] or (0 - 0);
				v99 = EpicSettings.Settings['usePurgeTarget'];
				v86 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v87 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v193 = 4 + 1;
			end
			if ((v193 == (0 - 0)) or ((5291 - (1596 + 114)) == (9067 - 5594))) then
				v65 = EpicSettings.Settings['useWindShear'];
				v36 = EpicSettings.Settings['useCapacitorTotem'];
				v66 = EpicSettings.Settings['useThunderstorm'];
				v69 = EpicSettings.Settings['useAncestralGuidance'];
				v193 = 714 - (164 + 549);
			end
			if (((6433 - (1059 + 379)) > (4156 - 808)) and ((2 + 0) == v193)) then
				v78 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
				v76 = EpicSettings.Settings['astralShiftHP'] or (392 - (145 + 247));
				v79 = EpicSettings.Settings['healingStreamTotemHP'] or (0 + 0);
				v80 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
				v193 = 8 - 5;
			end
			if ((v193 == (1 + 4)) or ((650 + 104) > (6046 - 2322))) then
				v88 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				v89 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
				break;
			end
			if (((937 - (254 + 466)) >= (617 - (544 + 16))) and (v193 == (9 - 6))) then
				v81 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (628 - (294 + 334));
				v74 = EpicSettings.Settings['autoShield'];
				v75 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v84 = EpicSettings.Settings['healOOC'];
				v193 = 257 - (236 + 17);
			end
			if ((v193 == (1 + 0)) or ((1612 + 458) >= (15203 - 11166))) then
				v68 = EpicSettings.Settings['useAstralShift'];
				v71 = EpicSettings.Settings['useMaelstromHealingSurge'];
				v70 = EpicSettings.Settings['useHealingStreamTotem'];
				v77 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 - 0);
				v193 = 2 + 0;
			end
		end
	end
	local function v145()
		local v194 = 0 + 0;
		while true do
			if (((3499 - (413 + 381)) == (114 + 2591)) and (v194 == (1 - 0))) then
				v91 = EpicSettings.Settings['DispelDebuffs'];
				v90 = EpicSettings.Settings['DispelBuffs'];
				v56 = EpicSettings.Settings['useTrinkets'];
				v57 = EpicSettings.Settings['useRacials'];
				v194 = 4 - 2;
			end
			if (((2031 - (582 + 1388)) == (103 - 42)) and (v194 == (3 + 0))) then
				v82 = EpicSettings.Settings['healthstoneHP'] or (364 - (326 + 38));
				v83 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v94 = EpicSettings.Settings['HealingPotionName'] or "";
				v92 = EpicSettings.Settings['handleAfflicted'];
				v194 = 5 - 1;
			end
			if ((v194 == (620 - (47 + 573))) or ((247 + 452) >= (5504 - 4208))) then
				v98 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v95 = EpicSettings.Settings['InterruptWithStun'];
				v96 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v97 = EpicSettings.Settings['InterruptThreshold'];
				v194 = 1665 - (1269 + 395);
			end
			if ((v194 == (496 - (76 + 416))) or ((2226 - (319 + 124)) >= (8265 - 4649))) then
				v93 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v194 == (1009 - (564 + 443))) or ((10832 - 6919) > (4985 - (337 + 121)))) then
				v63 = EpicSettings.Settings['trinketsWithCD'];
				v64 = EpicSettings.Settings['racialsWithCD'];
				v72 = EpicSettings.Settings['useHealthstone'];
				v73 = EpicSettings.Settings['useHealingPotion'];
				v194 = 8 - 5;
			end
		end
	end
	local function v146()
		local v195 = 0 - 0;
		while true do
			if (((6287 - (1261 + 650)) > (346 + 471)) and (v195 == (0 - 0))) then
				v144();
				v143();
				v145();
				v31 = EpicSettings.Toggles['ooc'];
				v195 = 1818 - (772 + 1045);
			end
			if (((686 + 4175) > (968 - (102 + 42))) and (v195 == (1848 - (1524 + 320)))) then
				if ((not v13:IsChanneling() and not v13:IsChanneling()) or ((2653 - (1049 + 221)) >= (2287 - (18 + 138)))) then
					local v239 = 0 - 0;
					while true do
						if ((v239 == (1102 - (67 + 1035))) or ((2224 - (136 + 212)) >= (10797 - 8256))) then
							if (((1428 + 354) <= (3478 + 294)) and Focus) then
								if (v91 or ((6304 - (240 + 1364)) < (1895 - (1050 + 32)))) then
									local v257 = 0 - 0;
									while true do
										if (((1893 + 1306) < (5105 - (331 + 724))) and (v257 == (0 + 0))) then
											v30 = v133();
											if (v30 or ((5595 - (269 + 375)) < (5155 - (267 + 458)))) then
												return v30;
											end
											break;
										end
									end
								end
							end
							if (((30 + 66) == (184 - 88)) and v92) then
								local v255 = 818 - (667 + 151);
								while true do
									if ((v255 == (1498 - (1410 + 87))) or ((4636 - (1504 + 393)) > (10833 - 6825))) then
										if (v88 or ((59 - 36) == (1930 - (461 + 335)))) then
											local v258 = 0 + 0;
											while true do
												if ((v258 == (1761 - (1730 + 31))) or ((4360 - (728 + 939)) >= (14559 - 10448))) then
													v30 = v116.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 60 - 30);
													if (v30 or ((9888 - 5572) <= (3214 - (138 + 930)))) then
														return v30;
													end
													break;
												end
											end
										end
										if (((v13:BuffStack(v100.MaelstromWeaponBuff) >= (5 + 0)) and v89) or ((2773 + 773) <= (2408 + 401))) then
											v30 = v116.HandleAfflicted(v100.HealingSurge, v102.HealingSurgeMouseover, 163 - 123, true);
											if (((6670 - (459 + 1307)) > (4036 - (474 + 1396))) and v30) then
												return v30;
											end
										end
										break;
									end
									if (((189 - 80) >= (85 + 5)) and ((0 + 0) == v255)) then
										if (((14258 - 9280) > (369 + 2536)) and v86) then
											local v259 = 0 - 0;
											while true do
												if ((v259 == (0 - 0)) or ((3617 - (562 + 29)) <= (1944 + 336))) then
													v30 = v116.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 1459 - (374 + 1045));
													if (v30 or ((1309 + 344) <= (3440 - 2332))) then
														return v30;
													end
													break;
												end
											end
										end
										if (((3547 - (448 + 190)) > (843 + 1766)) and v87) then
											local v260 = 0 + 0;
											while true do
												if (((494 + 263) > (745 - 551)) and (v260 == (0 - 0))) then
													v30 = v116.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 1524 - (1307 + 187));
													if (v30 or ((122 - 91) >= (3272 - 1874))) then
														return v30;
													end
													break;
												end
											end
										end
										v255 = 2 - 1;
									end
								end
							end
							v239 = 684 - (232 + 451);
						end
						if (((3052 + 144) <= (4304 + 568)) and (v239 == (565 - (510 + 54)))) then
							if (((6701 - 3375) == (3362 - (13 + 23))) and v13:AffectingCombat()) then
								v30 = v142();
								if (((2792 - 1359) <= (5572 - 1694)) and v30) then
									return v30;
								end
							else
								local v256 = 0 - 0;
								while true do
									if (((1088 - (830 + 258)) == v256) or ((5583 - 4000) == (1086 + 649))) then
										v30 = v141();
										if (v30 or ((2537 + 444) == (3791 - (860 + 581)))) then
											return v30;
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
			if ((v195 == (3 - 2)) or ((3545 + 921) <= (734 - (237 + 4)))) then
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				v34 = EpicSettings.Toggles['minicds'];
				v195 = 4 - 2;
			end
			if ((v195 == (6 - 3)) or ((4828 - 2281) <= (1627 + 360))) then
				if (((1701 + 1260) > (10344 - 7604)) and v32) then
					local v240 = 0 + 0;
					while true do
						if (((2011 + 1685) >= (5038 - (85 + 1341))) and (v240 == (0 - 0))) then
							v111 = #v108;
							v110 = #v109;
							break;
						end
					end
				else
					local v241 = 0 - 0;
					while true do
						if ((v241 == (372 - (45 + 327))) or ((5604 - 2634) == (2380 - (444 + 58)))) then
							v111 = 1 + 0;
							v110 = 1 + 0;
							break;
						end
					end
				end
				if (v13:AffectingCombat() or v91 or ((1806 + 1887) < (5729 - 3752))) then
					local v242 = 1732 - (64 + 1668);
					local v243;
					while true do
						if ((v242 == (1974 - (1227 + 746))) or ((2858 - 1928) > (3898 - 1797))) then
							if (((4647 - (415 + 79)) > (80 + 3006)) and v30) then
								return v30;
							end
							break;
						end
						if ((v242 == (491 - (142 + 349))) or ((1994 + 2660) <= (5568 - 1518))) then
							v243 = v91 and v100.CleanseSpirit:IsReady() and v35;
							v30 = v116.FocusUnit(v243, v102, 10 + 10, nil, 18 + 7);
							v242 = 2 - 1;
						end
					end
				end
				if (v116.TargetIsValid() or v13:AffectingCombat() or ((4466 - (1710 + 154)) < (1814 - (200 + 118)))) then
					v114 = v9.BossFightRemains(nil, true);
					v115 = v114;
					if ((v115 == (4403 + 6708)) or ((1783 - 763) > (3393 - 1105))) then
						v115 = v9.FightRemains(v109, false);
					end
				end
				if (((292 + 36) == (325 + 3)) and v13:AffectingCombat()) then
					if (((811 + 700) < (609 + 3199)) and v13:PrevGCD(2 - 1, v100.ChainLightning)) then
						v113 = "Chain Lightning";
					elseif (v13:PrevGCD(1251 - (363 + 887), v100.LightningBolt) or ((4382 - 1872) > (23413 - 18494))) then
						v113 = "Lightning Bolt";
					end
				end
				v195 = 1 + 3;
			end
			if (((11144 - 6381) == (3255 + 1508)) and ((1666 - (674 + 990)) == v195)) then
				if (((1187 + 2950) > (757 + 1091)) and v13:IsDeadOrGhost()) then
					return;
				end
				v104, v106, _, _, v105, v107 = v24();
				v108 = v13:GetEnemiesInRange(63 - 23);
				v109 = v13:GetEnemiesInMeleeRange(1065 - (507 + 548));
				v195 = 840 - (289 + 548);
			end
		end
	end
	local function v147()
		v100.FlameShockDebuff:RegisterAuraTracking();
		v123();
		v18.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
	end
	v18.SetAPL(2081 - (821 + 997), v146, v147);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

