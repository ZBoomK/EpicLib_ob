local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1259 - (233 + 1026);
	local v6;
	while true do
		if (((2821 - (636 + 1030)) < (856 + 817)) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((158 + 2166) <= (799 - (55 + 166)))) then
			v6 = v0[v4];
			if (((731 + 3036) == (379 + 3388)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
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
	local v114 = (v102.LavaBurst:IsAvailable() and (299 - (36 + 261))) or (1 - 0);
	local v115 = "Lightning Bolt";
	local v116 = 12479 - (34 + 1334);
	local v117 = 4272 + 6839;
	local v118 = v21.Commons.Everyone;
	v21.Commons.Shaman = {};
	local v120 = v21.Commons.Shaman;
	v120.FeralSpiritCount = 0 + 0;
	v10:RegisterForEvent(function()
		v114 = (v102.LavaBurst:IsAvailable() and (1285 - (1035 + 248))) or (22 - (20 + 1));
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		local v147 = 0 + 0;
		while true do
			if (((4408 - (134 + 185)) == (5222 - (549 + 584))) and (v147 == (686 - (314 + 371)))) then
				v117 = 38143 - 27032;
				break;
			end
			if (((5426 - (478 + 490)) >= (887 + 787)) and (v147 == (1172 - (786 + 386)))) then
				v115 = "Lightning Bolt";
				v116 = 35988 - 24877;
				v147 = 1380 - (1055 + 324);
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForSelfCombatEvent(function(...)
		local v148, v149, v149, v149, v149, v149, v149, v149, v150 = select(1344 - (1093 + 247), ...);
		if (((864 + 108) <= (150 + 1268)) and (v148 == v14:GUID()) and (v150 == (760821 - 569187))) then
			v120.LastSKCast = v31();
		end
		if ((v14:HasTier(105 - 74, 5 - 3) and (v148 == v14:GUID()) and (v150 == (944809 - 568827))) or ((1757 + 3181) < (18345 - 13583))) then
			v120.FeralSpiritCount = v120.FeralSpiritCount + (3 - 2);
			v32.After(12 + 3, function()
				v120.FeralSpiritCount = v120.FeralSpiritCount - (2 - 1);
			end);
		end
		if (((v148 == v14:GUID()) and (v150 == (52221 - (364 + 324)))) or ((6864 - 4360) > (10231 - 5967))) then
			v120.FeralSpiritCount = v120.FeralSpiritCount + 1 + 1;
			v32.After(62 - 47, function()
				v120.FeralSpiritCount = v120.FeralSpiritCount - (2 - 0);
			end);
		end
	end, "SPELL_CAST_SUCCESS");
	local function v122()
		if (((6538 - 4385) == (3421 - (1249 + 19))) and v102.CleanseSpirit:IsAvailable()) then
			v118.DispellableDebuffs = v118.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123()
		for v175 = 1 + 0, 23 - 17, 1087 - (686 + 400) do
			if (v30(v14:TotemName(v175), "Totem") or ((398 + 109) >= (2820 - (73 + 156)))) then
				return v175;
			end
		end
	end
	local function v124()
		if (((22 + 4459) == (5292 - (721 + 90))) and (not v102.AlphaWolf:IsAvailable() or v14:BuffDown(v102.FeralSpiritBuff))) then
			return 0 + 0;
		end
		local v151 = v29(v102.CrashLightning:TimeSinceLastCast(), v102.ChainLightning:TimeSinceLastCast());
		if ((v151 > (25 - 17)) or (v151 > v102.FeralSpirit:TimeSinceLastCast()) or ((2798 - (224 + 246)) < (1122 - 429))) then
			return 0 - 0;
		end
		return (2 + 6) - v151;
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
		return v158:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (1 + 5));
	end
	local function v132()
		if (((3179 + 1149) == (8604 - 4276)) and v102.CleanseSpirit:IsReady() and v38 and v118.DispellableFriendlyUnit(83 - 58)) then
			if (((2101 - (203 + 310)) >= (3325 - (1238 + 755))) and v24(v104.CleanseSpiritFocus)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v133()
		local v159 = 0 + 0;
		while true do
			if ((v159 == (1534 - (709 + 825))) or ((7691 - 3517) > (6187 - 1939))) then
				if (not v16 or not v16:Exists() or not v16:IsInRange(904 - (196 + 668)) or ((18106 - 13520) <= (169 - 87))) then
					return;
				end
				if (((4696 - (171 + 662)) == (3956 - (4 + 89))) and v16) then
					if (((v16:HealthPercentage() <= v83) and v73 and v102.HealingSurge:IsReady() and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (17 - 12))) or ((103 + 179) <= (184 - 142))) then
						if (((1808 + 2801) >= (2252 - (35 + 1451))) and v24(v104.HealingSurgeFocus)) then
							return "healing_surge heal focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v134()
		if ((v14:HealthPercentage() <= v87) or ((2605 - (28 + 1425)) == (4481 - (941 + 1052)))) then
			if (((3282 + 140) > (4864 - (822 + 692))) and v102.HealingSurge:IsReady()) then
				if (((1251 - 374) > (178 + 198)) and v24(v102.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v135()
		local v160 = 297 - (45 + 252);
		while true do
			if ((v160 == (0 + 0)) or ((1074 + 2044) <= (4504 - 2653))) then
				if ((v102.AstralShift:IsReady() and v70 and (v14:HealthPercentage() <= v78)) or ((598 - (114 + 319)) >= (5013 - 1521))) then
					if (((5059 - 1110) < (3096 + 1760)) and v24(v102.AstralShift)) then
						return "astral_shift defensive 1";
					end
				end
				if ((v102.AncestralGuidance:IsReady() and v71 and v118.AreUnitsBelowHealthPercentage(v79, v80)) or ((6370 - 2094) < (6318 - 3302))) then
					if (((6653 - (556 + 1407)) > (5331 - (741 + 465))) and v24(v102.AncestralGuidance)) then
						return "ancestral_guidance defensive 2";
					end
				end
				v160 = 466 - (170 + 295);
			end
			if ((v160 == (1 + 0)) or ((46 + 4) >= (2205 - 1309))) then
				if ((v102.HealingStreamTotem:IsReady() and v72 and v118.AreUnitsBelowHealthPercentage(v81, v82)) or ((1421 + 293) >= (1897 + 1061))) then
					if (v24(v102.HealingStreamTotem) or ((845 + 646) < (1874 - (957 + 273)))) then
						return "healing_stream_totem defensive 3";
					end
				end
				if (((189 + 515) < (396 + 591)) and v102.HealingSurge:IsReady() and v73 and (v14:HealthPercentage() <= v83) and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (19 - 14))) then
					if (((9797 - 6079) > (5821 - 3915)) and v24(v102.HealingSurge)) then
						return "healing_surge defensive 4";
					end
				end
				v160 = 9 - 7;
			end
			if ((v160 == (1782 - (389 + 1391))) or ((602 + 356) > (379 + 3256))) then
				if (((7970 - 4469) <= (5443 - (783 + 168))) and v103.Healthstone:IsReady() and v74 and (v14:HealthPercentage() <= v84)) then
					if (v24(v104.Healthstone) or ((11551 - 8109) < (2507 + 41))) then
						return "healthstone defensive 3";
					end
				end
				if (((3186 - (309 + 2)) >= (4495 - 3031)) and v75 and (v14:HealthPercentage() <= v85)) then
					if ((v96 == "Refreshing Healing Potion") or ((6009 - (1090 + 122)) >= (1587 + 3306))) then
						if (v103.RefreshingHealingPotion:IsReady() or ((1850 - 1299) > (1416 + 652))) then
							if (((3232 - (628 + 490)) > (170 + 774)) and v24(v104.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v96 == "Dreamwalker's Healing Potion") or ((5599 - 3337) >= (14148 - 11052))) then
						if (v103.DreamwalkersHealingPotion:IsReady() or ((3029 - (431 + 343)) >= (7142 - 3605))) then
							if (v24(v104.RefreshingHealingPotion) or ((11099 - 7262) < (1032 + 274))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v136()
		local v161 = 0 + 0;
		while true do
			if (((4645 - (556 + 1139)) == (2965 - (6 + 9))) and (v161 == (1 + 0))) then
				v33 = v118.HandleBottomTrinket(v105, v36, 21 + 19, nil);
				if (v33 or ((4892 - (28 + 141)) < (1278 + 2020))) then
					return v33;
				end
				break;
			end
			if (((1402 - 266) >= (110 + 44)) and (v161 == (1317 - (486 + 831)))) then
				v33 = v118.HandleTopTrinket(v105, v36, 104 - 64, nil);
				if (v33 or ((954 - 683) > (898 + 3850))) then
					return v33;
				end
				v161 = 3 - 2;
			end
		end
	end
	local function v137()
		local v162 = 1263 - (668 + 595);
		while true do
			if (((4266 + 474) >= (636 + 2516)) and ((0 - 0) == v162)) then
				if ((v102.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (380 - (23 + 267))))) or ((4522 - (1129 + 815)) >= (3777 - (371 + 16)))) then
					if (((1791 - (1326 + 424)) <= (3145 - 1484)) and v24(v102.WindfuryTotem)) then
						return "windfury_totem precombat 4";
					end
				end
				if (((2196 - 1595) < (3678 - (88 + 30))) and v102.FeralSpirit:IsCastable() and v56 and ((v61 and v36) or not v61)) then
					if (((1006 - (720 + 51)) < (1528 - 841)) and v24(v102.FeralSpirit)) then
						return "feral_spirit precombat 6";
					end
				end
				v162 = 1777 - (421 + 1355);
			end
			if (((7504 - 2955) > (567 + 586)) and (v162 == (1084 - (286 + 797)))) then
				if ((v102.DoomWinds:IsCastable() and v57 and ((v62 and v36) or not v62)) or ((17086 - 12412) < (7738 - 3066))) then
					if (((4107 - (397 + 42)) < (1425 + 3136)) and v24(v102.DoomWinds, not v15:IsSpellInRange(v102.DoomWinds))) then
						return "doom_winds precombat 8";
					end
				end
				if ((v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63)) or ((1255 - (24 + 776)) == (5553 - 1948))) then
					if (v24(v102.Sundering, not v15:IsInRange(790 - (222 + 563))) or ((5867 - 3204) == (2385 + 927))) then
						return "sundering precombat 10";
					end
				end
				v162 = 192 - (23 + 167);
			end
			if (((6075 - (690 + 1108)) <= (1615 + 2860)) and ((2 + 0) == v162)) then
				if ((v102.Stormstrike:IsReady() and v50) or ((1718 - (40 + 808)) == (196 + 993))) then
					if (((5938 - 4385) <= (2995 + 138)) and v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike))) then
						return "stormstrike precombat 12";
					end
				end
				break;
			end
		end
	end
	local function v138()
		if ((v102.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v117) and v15:DebuffDown(v102.FlameShockDebuff) and v102.LashingFlames:IsAvailable()) or ((1184 + 1053) >= (1926 + 1585))) then
			if (v24(v102.PrimordialWave, not v15:IsSpellInRange(v102.PrimordialWave)) or ((1895 - (47 + 524)) > (1960 + 1060))) then
				return "primordial_wave single 1";
			end
		end
		if ((v102.FlameShock:IsReady() and v43 and v15:DebuffDown(v102.FlameShockDebuff) and v102.LashingFlames:IsAvailable()) or ((8178 - 5186) == (2812 - 931))) then
			if (((7083 - 3977) > (3252 - (1165 + 561))) and v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock))) then
				return "flame_shock single 2";
			end
		end
		if (((90 + 2933) < (11986 - 8116)) and v102.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (2 + 3)) and v102.ElementalSpirits:IsAvailable() and (v120.FeralSpiritCount >= (483 - (341 + 138)))) then
			if (((39 + 104) > (152 - 78)) and v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast))) then
				return "elemental_blast single 3";
			end
		end
		if (((344 - (89 + 237)) < (6794 - 4682)) and v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v117) and (v14:HasTier(63 - 33, 883 - (581 + 300)))) then
			if (((2317 - (855 + 365)) <= (3866 - 2238)) and v24(v102.Sundering, not v15:IsInRange(3 + 5))) then
				return "sundering single 4";
			end
		end
		if (((5865 - (1030 + 205)) == (4347 + 283)) and v102.LightningBolt:IsReady() and v48 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (5 + 0)) and v14:BuffDown(v102.CracklingThunderBuff) and v14:BuffUp(v102.AscendanceBuff) and (v115 == "Chain Lightning") and (v14:BuffRemains(v102.AscendanceBuff) > (v102.ChainLightning:CooldownRemains() + v14:GCD()))) then
			if (((3826 - (156 + 130)) > (6096 - 3413)) and v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt))) then
				return "lightning_bolt single 5";
			end
		end
		if (((8079 - 3285) >= (6707 - 3432)) and v102.Stormstrike:IsReady() and v50 and (v14:BuffUp(v102.DoomWindsBuff) or v102.DeeplyRootedElements:IsAvailable() or (v102.Stormblast:IsAvailable() and v14:BuffUp(v102.StormbringerBuff)))) then
			if (((392 + 1092) == (866 + 618)) and v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike))) then
				return "stormstrike single 6";
			end
		end
		if (((1501 - (10 + 59)) < (1006 + 2549)) and v102.LavaLash:IsReady() and v47 and (v14:BuffUp(v102.HotHandBuff))) then
			if (v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash)) or ((5244 - 4179) > (4741 - (671 + 492)))) then
				return "lava_lash single 7";
			end
		end
		if ((v102.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v102.WindfuryTotemBuff, true))) or ((3818 + 977) < (2622 - (369 + 846)))) then
			if (((491 + 1362) < (4108 + 705)) and v24(v102.WindfuryTotem)) then
				return "windfury_totem single 8";
			end
		end
		if ((v102.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (1950 - (1036 + 909))) and (v102.ElementalBlast:Charges() == v114)) or ((2243 + 578) < (4081 - 1650))) then
			if (v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast)) or ((3077 - (11 + 192)) < (1103 + 1078))) then
				return "elemental_blast single 9";
			end
		end
		if ((v102.LightningBolt:IsReady() and v48 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (183 - (135 + 40))) and v14:BuffUp(v102.PrimordialWaveBuff) and (v14:BuffDown(v102.SplinteredElementsBuff) or (v117 <= (28 - 16)))) or ((1621 + 1068) <= (755 - 412))) then
			if (v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt)) or ((2801 - 932) == (2185 - (50 + 126)))) then
				return "lightning_bolt single 10";
			end
		end
		if ((v102.ChainLightning:IsReady() and v39 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (22 - 14)) and v14:BuffUp(v102.CracklingThunderBuff) and v102.ElementalSpirits:IsAvailable()) or ((785 + 2761) < (3735 - (1233 + 180)))) then
			if (v24(v102.ChainLightning, not v15:IsSpellInRange(v102.ChainLightning)) or ((3051 - (522 + 447)) == (6194 - (107 + 1314)))) then
				return "chain_lightning single 11";
			end
		end
		if (((1506 + 1738) > (3214 - 2159)) and v102.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (4 + 4)) and ((v120.FeralSpiritCount >= (3 - 1)) or not v102.ElementalSpirits:IsAvailable())) then
			if (v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast)) or ((13108 - 9795) <= (3688 - (716 + 1194)))) then
				return "elemental_blast single 12";
			end
		end
		if ((v102.LavaBurst:IsReady() and v46 and not v102.ThorimsInvocation:IsAvailable() and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (1 + 4))) or ((153 + 1268) >= (2607 - (74 + 429)))) then
			if (((3495 - 1683) <= (1611 + 1638)) and v24(v102.LavaBurst, not v15:IsSpellInRange(v102.LavaBurst))) then
				return "lava_burst single 13";
			end
		end
		if (((3715 - 2092) <= (1385 + 572)) and v102.LightningBolt:IsReady() and v48 and ((v14:BuffStack(v102.MaelstromWeaponBuff) >= (24 - 16)) or (v102.StaticAccumulation:IsAvailable() and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (12 - 7)))) and v14:BuffDown(v102.PrimordialWaveBuff)) then
			if (((4845 - (279 + 154)) == (5190 - (454 + 324))) and v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt))) then
				return "lightning_bolt single 14";
			end
		end
		if (((1377 + 373) >= (859 - (12 + 5))) and v102.CrashLightning:IsReady() and v40 and v102.AlphaWolf:IsAvailable() and v14:BuffUp(v102.FeralSpiritBuff) and (v124() == (0 + 0))) then
			if (((11139 - 6767) > (684 + 1166)) and v24(v102.CrashLightning, not v15:IsInMeleeRange(1101 - (277 + 816)))) then
				return "crash_lightning single 15";
			end
		end
		if (((991 - 759) < (2004 - (1058 + 125))) and v102.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v117)) then
			if (((98 + 420) < (1877 - (815 + 160))) and v24(v102.PrimordialWave, not v15:IsSpellInRange(v102.PrimordialWave))) then
				return "primordial_wave single 16";
			end
		end
		if (((12846 - 9852) > (2036 - 1178)) and v102.FlameShock:IsReady() and v43 and (v15:DebuffDown(v102.FlameShockDebuff))) then
			if (v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock)) or ((896 + 2859) <= (2674 - 1759))) then
				return "flame_shock single 17";
			end
		end
		if (((5844 - (41 + 1857)) > (5636 - (1222 + 671))) and v102.IceStrike:IsReady() and v45 and v102.ElementalAssault:IsAvailable() and v102.SwirlingMaelstrom:IsAvailable()) then
			if (v24(v102.IceStrike, not v15:IsInMeleeRange(12 - 7)) or ((1918 - 583) >= (4488 - (229 + 953)))) then
				return "ice_strike single 18";
			end
		end
		if (((6618 - (1111 + 663)) > (3832 - (874 + 705))) and v102.LavaLash:IsReady() and v47 and (v102.LashingFlames:IsAvailable())) then
			if (((64 + 388) == (309 + 143)) and v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash))) then
				return "lava_lash single 19";
			end
		end
		if ((v102.IceStrike:IsReady() and v45 and (v14:BuffDown(v102.IceStrikeBuff))) or ((9471 - 4914) < (59 + 2028))) then
			if (((4553 - (642 + 37)) == (884 + 2990)) and v24(v102.IceStrike, not v15:IsInMeleeRange(1 + 4))) then
				return "ice_strike single 20";
			end
		end
		if ((v102.FrostShock:IsReady() and v44 and (v14:BuffUp(v102.HailstormBuff))) or ((4865 - 2927) > (5389 - (233 + 221)))) then
			if (v24(v102.FrostShock, not v15:IsSpellInRange(v102.FrostShock)) or ((9839 - 5584) < (3013 + 410))) then
				return "frost_shock single 21";
			end
		end
		if (((2995 - (718 + 823)) <= (1568 + 923)) and v102.LavaLash:IsReady() and v47) then
			if (v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash)) or ((4962 - (266 + 539)) <= (7935 - 5132))) then
				return "lava_lash single 22";
			end
		end
		if (((6078 - (636 + 589)) >= (7078 - 4096)) and v102.IceStrike:IsReady() and v45) then
			if (((8526 - 4392) > (2661 + 696)) and v24(v102.IceStrike, not v15:IsInMeleeRange(2 + 3))) then
				return "ice_strike single 23";
			end
		end
		if ((v102.Windstrike:IsCastable() and v53) or ((4432 - (657 + 358)) < (6709 - 4175))) then
			if (v24(v102.Windstrike, not v15:IsSpellInRange(v102.Windstrike)) or ((6201 - 3479) <= (1351 - (1151 + 36)))) then
				return "windstrike single 24";
			end
		end
		if ((v102.Stormstrike:IsReady() and v50) or ((2326 + 82) < (555 + 1554))) then
			if (v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike)) or ((98 - 65) == (3287 - (1552 + 280)))) then
				return "stormstrike single 25";
			end
		end
		if ((v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v117)) or ((1277 - (64 + 770)) >= (2726 + 1289))) then
			if (((7677 - 4295) > (30 + 136)) and v24(v102.Sundering, not v15:IsInRange(1251 - (157 + 1086)))) then
				return "sundering single 26";
			end
		end
		if ((v102.BagofTricks:IsReady() and v59 and ((v66 and v36) or not v66)) or ((560 - 280) == (13397 - 10338))) then
			if (((2885 - 1004) > (1763 - 470)) and v24(v102.BagofTricks)) then
				return "bag_of_tricks single 27";
			end
		end
		if (((3176 - (599 + 220)) == (4693 - 2336)) and v102.FireNova:IsReady() and v42 and v102.SwirlingMaelstrom:IsAvailable() and v15:DebuffUp(v102.FlameShockDebuff) and (v14:BuffStack(v102.MaelstromWeaponBuff) < ((1936 - (1813 + 118)) + ((4 + 1) * v25(v102.OverflowingMaelstrom:IsAvailable()))))) then
			if (((1340 - (841 + 376)) == (171 - 48)) and v24(v102.FireNova)) then
				return "fire_nova single 28";
			end
		end
		if ((v102.LightningBolt:IsReady() and v48 and v102.Hailstorm:IsAvailable() and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (2 + 3)) and v14:BuffDown(v102.PrimordialWaveBuff)) or ((2882 - 1826) >= (4251 - (464 + 395)))) then
			if (v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt)) or ((2774 - 1693) < (517 + 558))) then
				return "lightning_bolt single 29";
			end
		end
		if ((v102.FrostShock:IsReady() and v44) or ((1886 - (467 + 370)) >= (9158 - 4726))) then
			if (v24(v102.FrostShock, not v15:IsSpellInRange(v102.FrostShock)) or ((3500 + 1268) <= (2900 - 2054))) then
				return "frost_shock single 30";
			end
		end
		if ((v102.CrashLightning:IsReady() and v40) or ((524 + 2834) <= (3303 - 1883))) then
			if (v24(v102.CrashLightning, not v15:IsInMeleeRange(528 - (150 + 370))) or ((5021 - (74 + 1208)) <= (7391 - 4386))) then
				return "crash_lightning single 31";
			end
		end
		if ((v102.FireNova:IsReady() and v42 and (v15:DebuffUp(v102.FlameShockDebuff))) or ((7867 - 6208) >= (1519 + 615))) then
			if (v24(v102.FireNova) or ((3650 - (14 + 376)) < (4084 - 1729))) then
				return "fire_nova single 32";
			end
		end
		if ((v102.FlameShock:IsReady() and v43) or ((433 + 236) == (3710 + 513))) then
			if (v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock)) or ((1614 + 78) < (1722 - 1134))) then
				return "flame_shock single 34";
			end
		end
		if ((v102.ChainLightning:IsReady() and v39 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (4 + 1)) and v14:BuffUp(v102.CracklingThunderBuff) and v102.ElementalSpirits:IsAvailable()) or ((4875 - (23 + 55)) < (8652 - 5001))) then
			if (v24(v102.ChainLightning, not v15:IsSpellInRange(v102.ChainLightning)) or ((2788 + 1389) > (4356 + 494))) then
				return "chain_lightning single 35";
			end
		end
		if ((v102.LightningBolt:IsReady() and v48 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (7 - 2)) and v14:BuffDown(v102.PrimordialWaveBuff)) or ((126 + 274) > (2012 - (652 + 249)))) then
			if (((8164 - 5113) > (2873 - (708 + 1160))) and v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt))) then
				return "lightning_bolt single 36";
			end
		end
		if (((10024 - 6331) <= (7988 - 3606)) and v102.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (117 - (10 + 17))))) then
			if (v24(v102.WindfuryTotem) or ((738 + 2544) > (5832 - (1400 + 332)))) then
				return "windfury_totem single 37";
			end
		end
	end
	local function v139()
		local v163 = 0 - 0;
		while true do
			if (((1909 - (242 + 1666)) == v163) or ((1532 + 2048) < (1043 + 1801))) then
				if (((76 + 13) < (5430 - (850 + 90))) and v102.ChainLightning:IsReady() and v39 and (v14:BuffStack(v102.MaelstromWeaponBuff) == ((8 - 3) + ((1395 - (360 + 1030)) * v25(v102.OverflowingMaelstrom:IsAvailable()))))) then
					if (v24(v102.ChainLightning, not v15:IsSpellInRange(v102.ChainLightning)) or ((4410 + 573) < (5102 - 3294))) then
						return "chain_lightning aoe 7";
					end
				end
				if (((5267 - 1438) > (5430 - (909 + 752))) and v102.CrashLightning:IsReady() and v40 and (v14:BuffUp(v102.DoomWindsBuff) or v14:BuffDown(v102.CrashLightningBuff) or (v102.AlphaWolf:IsAvailable() and v14:BuffUp(v102.FeralSpiritBuff) and (v124() == (1223 - (109 + 1114)))))) then
					if (((2718 - 1233) <= (1131 + 1773)) and v24(v102.CrashLightning, not v15:IsInMeleeRange(250 - (6 + 236)))) then
						return "crash_lightning aoe 8";
					end
				end
				if (((2690 + 1579) == (3437 + 832)) and v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v117) and (v14:BuffUp(v102.DoomWindsBuff) or v14:HasTier(70 - 40, 3 - 1))) then
					if (((1520 - (1076 + 57)) <= (458 + 2324)) and v24(v102.Sundering, not v15:IsInRange(697 - (579 + 110)))) then
						return "sundering aoe 9";
					end
				end
				if ((v102.FireNova:IsReady() and v42 and ((v102.FlameShockDebuff:AuraActiveCount() >= (1 + 5)) or ((v102.FlameShockDebuff:AuraActiveCount() >= (4 + 0)) and (v102.FlameShockDebuff:AuraActiveCount() >= v112)))) or ((1008 + 891) <= (1324 - (174 + 233)))) then
					if (v24(v102.FireNova) or ((12044 - 7732) <= (1537 - 661))) then
						return "fire_nova aoe 10";
					end
				end
				if (((993 + 1239) <= (3770 - (663 + 511))) and v102.LavaLash:IsReady() and v47 and (v102.LashingFlames:IsAvailable())) then
					local v240 = 0 + 0;
					while true do
						if (((455 + 1640) < (11363 - 7677)) and (v240 == (0 + 0))) then
							if (v118.CastCycle(v102.LavaLash, v111, v126, not v15:IsSpellInRange(v102.LavaLash)) or ((3754 - 2159) >= (10830 - 6356))) then
								return "lava_lash aoe 11";
							end
							if (v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash)) or ((2205 + 2414) < (5609 - 2727))) then
								return "lava_lash aoe no_cycle 11";
							end
							break;
						end
					end
				end
				if ((v102.LavaLash:IsReady() and v47 and ((v102.MoltenAssault:IsAvailable() and v15:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (5 + 1))) or (v102.AshenCatalyst:IsAvailable() and (v14:BuffStack(v102.AshenCatalystBuff) == (1 + 4))))) or ((1016 - (478 + 244)) >= (5348 - (440 + 77)))) then
					if (((923 + 1106) <= (11287 - 8203)) and v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash aoe 12";
					end
				end
				v163 = 1558 - (655 + 901);
			end
			if (((1 + 1) == v163) or ((1560 + 477) == (1635 + 785))) then
				if (((17959 - 13501) > (5349 - (695 + 750))) and v102.IceStrike:IsReady() and v45 and (v102.Hailstorm:IsAvailable())) then
					if (((1488 - 1052) >= (189 - 66)) and v24(v102.IceStrike, not v15:IsInMeleeRange(20 - 15))) then
						return "ice_strike aoe 13";
					end
				end
				if (((851 - (285 + 66)) < (4232 - 2416)) and v102.FrostShock:IsReady() and v44 and v102.Hailstorm:IsAvailable() and v14:BuffUp(v102.HailstormBuff)) then
					if (((4884 - (682 + 628)) == (577 + 2997)) and v24(v102.FrostShock, not v15:IsSpellInRange(v102.FrostShock))) then
						return "frost_shock aoe 14";
					end
				end
				if (((520 - (176 + 123)) < (164 + 226)) and v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v117)) then
					if (v24(v102.Sundering, not v15:IsInRange(6 + 2)) or ((2482 - (239 + 30)) <= (387 + 1034))) then
						return "sundering aoe 15";
					end
				end
				if (((2940 + 118) < (8601 - 3741)) and v102.FlameShock:IsReady() and v43 and v102.MoltenAssault:IsAvailable() and v15:DebuffDown(v102.FlameShockDebuff)) then
					if (v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock)) or ((4042 - 2746) >= (4761 - (306 + 9)))) then
						return "flame_shock aoe 16";
					end
				end
				if ((v102.FlameShock:IsReady() and v43 and v15:DebuffRefreshable(v102.FlameShockDebuff) and (v102.FireNova:IsAvailable() or v102.PrimordialWave:IsAvailable()) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (20 - 14))) or ((243 + 1150) > (2755 + 1734))) then
					local v241 = 0 + 0;
					while true do
						if ((v241 == (0 - 0)) or ((5799 - (1140 + 235)) < (18 + 9))) then
							if (v118.CastCycle(v102.FlameShock, v111, v125, not v15:IsSpellInRange(v102.FlameShock)) or ((1832 + 165) > (980 + 2835))) then
								return "flame_shock aoe 17";
							end
							if (((3517 - (33 + 19)) > (691 + 1222)) and v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock))) then
								return "flame_shock aoe no_cycle 17";
							end
							break;
						end
					end
				end
				if (((2196 - 1463) < (802 + 1017)) and v102.FireNova:IsReady() and v42 and (v102.FlameShockDebuff:AuraActiveCount() >= (5 - 2))) then
					if (v24(v102.FireNova) or ((4122 + 273) == (5444 - (586 + 103)))) then
						return "fire_nova aoe 18";
					end
				end
				v163 = 1 + 2;
			end
			if ((v163 == (9 - 6)) or ((5281 - (1309 + 179)) < (4276 - 1907))) then
				if ((v102.Stormstrike:IsReady() and v50 and v14:BuffUp(v102.CrashLightningBuff) and (v102.DeeplyRootedElements:IsAvailable() or (v14:BuffStack(v102.ConvergingStormsBuff) == (3 + 3)))) or ((10967 - 6883) == (201 + 64))) then
					if (((9258 - 4900) == (8683 - 4325)) and v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike))) then
						return "stormstrike aoe 19";
					end
				end
				if ((v102.CrashLightning:IsReady() and v40 and v102.CrashingStorms:IsAvailable() and v14:BuffUp(v102.CLCrashLightningBuff) and (v112 >= (613 - (295 + 314)))) or ((7707 - 4569) < (2955 - (1300 + 662)))) then
					if (((10456 - 7126) > (4078 - (1178 + 577))) and v24(v102.CrashLightning, not v15:IsInMeleeRange(5 + 3))) then
						return "crash_lightning aoe 20";
					end
				end
				if ((v102.Windstrike:IsCastable() and v53) or ((10718 - 7092) == (5394 - (851 + 554)))) then
					if (v24(v102.Windstrike, not v15:IsSpellInRange(v102.Windstrike)) or ((811 + 105) == (7407 - 4736))) then
						return "windstrike aoe 21";
					end
				end
				if (((590 - 318) == (574 - (115 + 187))) and v102.Stormstrike:IsReady() and v50) then
					if (((3255 + 994) <= (4582 + 257)) and v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike))) then
						return "stormstrike aoe 22";
					end
				end
				if (((10943 - 8166) < (4361 - (160 + 1001))) and v102.IceStrike:IsReady() and v45) then
					if (((84 + 11) < (1351 + 606)) and v24(v102.IceStrike, not v15:IsInMeleeRange(10 - 5))) then
						return "ice_strike aoe 23";
					end
				end
				if (((1184 - (237 + 121)) < (2614 - (525 + 372))) and v102.LavaLash:IsReady() and v47) then
					if (((2702 - 1276) >= (3630 - 2525)) and v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash aoe 24";
					end
				end
				v163 = 146 - (96 + 46);
			end
			if (((3531 - (643 + 134)) <= (1220 + 2159)) and (v163 == (11 - 6))) then
				if ((v102.FrostShock:IsReady() and v44 and not v102.Hailstorm:IsAvailable()) or ((14579 - 10652) == (1356 + 57))) then
					if (v24(v102.FrostShock, not v15:IsSpellInRange(v102.FrostShock)) or ((2264 - 1110) <= (1610 - 822))) then
						return "frost_shock aoe 31";
					end
				end
				break;
			end
			if ((v163 == (719 - (316 + 403))) or ((1093 + 550) > (9290 - 5911))) then
				if ((v102.CrashLightning:IsReady() and v40 and v102.CrashingStorms:IsAvailable() and ((v102.UnrulyWinds:IsAvailable() and (v112 >= (4 + 6))) or (v112 >= (37 - 22)))) or ((1987 + 816) > (1467 + 3082))) then
					if (v24(v102.CrashLightning, not v15:IsInMeleeRange(27 - 19)) or ((1050 - 830) >= (6277 - 3255))) then
						return "crash_lightning aoe 1";
					end
				end
				if (((162 + 2660) == (5555 - 2733)) and v102.LightningBolt:IsReady() and v48 and ((v102.FlameShockDebuff:AuraActiveCount() >= v112) or (v14:BuffRemains(v102.PrimordialWaveBuff) < (v14:GCD() * (1 + 2))) or (v102.FlameShockDebuff:AuraActiveCount() >= (17 - 11))) and v14:BuffUp(v102.PrimordialWaveBuff) and (v14:BuffStack(v102.MaelstromWeaponBuff) == ((22 - (12 + 5)) + ((19 - 14) * v25(v102.OverflowingMaelstrom:IsAvailable())))) and (v14:BuffDown(v102.SplinteredElementsBuff) or (v117 <= (25 - 13)) or (v100 <= v14:GCD()))) then
					if (v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt)) or ((2255 - 1194) == (4604 - 2747))) then
						return "lightning_bolt aoe 2";
					end
				end
				if (((561 + 2199) > (3337 - (1656 + 317))) and v102.LavaLash:IsReady() and v47 and v102.MoltenAssault:IsAvailable() and (v102.PrimordialWave:IsAvailable() or v102.FireNova:IsAvailable()) and v15:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (6 + 0))) then
					if (v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash)) or ((3929 + 973) <= (9559 - 5964))) then
						return "lava_lash aoe 3";
					end
				end
				if ((v102.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v117) and (v14:BuffDown(v102.PrimordialWaveBuff))) or ((18957 - 15105) == (647 - (5 + 349)))) then
					local v242 = 0 - 0;
					while true do
						if ((v242 == (1271 - (266 + 1005))) or ((1028 + 531) == (15654 - 11066))) then
							if (v118.CastCycle(v102.PrimordialWave, v111, v125, not v15:IsSpellInRange(v102.PrimordialWave)) or ((5902 - 1418) == (2484 - (561 + 1135)))) then
								return "primordial_wave aoe 4";
							end
							if (((5952 - 1384) >= (12842 - 8935)) and v24(v102.PrimordialWave, not v15:IsSpellInRange(v102.PrimordialWave))) then
								return "primordial_wave aoe no_cycle 4";
							end
							break;
						end
					end
				end
				if (((2312 - (507 + 559)) < (8707 - 5237)) and v102.FlameShock:IsReady() and v43 and (v102.PrimordialWave:IsAvailable() or v102.FireNova:IsAvailable()) and v15:DebuffDown(v102.FlameShockDebuff)) then
					if (((12580 - 8512) >= (1360 - (212 + 176))) and v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock aoe 5";
					end
				end
				if (((1398 - (250 + 655)) < (10615 - 6722)) and v102.ElementalBlast:IsReady() and v41 and (not v102.ElementalSpirits:IsAvailable() or (v102.ElementalSpirits:IsAvailable() and ((v102.ElementalBlast:Charges() == v114) or (v120.FeralSpiritCount >= (2 - 0))))) and (v14:BuffStack(v102.MaelstromWeaponBuff) == ((7 - 2) + ((1961 - (1869 + 87)) * v25(v102.OverflowingMaelstrom:IsAvailable())))) and (not v102.CrashingStorms:IsAvailable() or (v112 <= (10 - 7)))) then
					if (v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast)) or ((3374 - (484 + 1417)) >= (7141 - 3809))) then
						return "elemental_blast aoe 6";
					end
				end
				v163 = 1 - 0;
			end
			if ((v163 == (777 - (48 + 725))) or ((6617 - 2566) <= (3104 - 1947))) then
				if (((352 + 252) < (7699 - 4818)) and v102.CrashLightning:IsReady() and v40) then
					if (v24(v102.CrashLightning, not v15:IsInMeleeRange(3 + 5)) or ((263 + 637) == (4230 - (152 + 701)))) then
						return "crash_lightning aoe 25";
					end
				end
				if (((5770 - (430 + 881)) > (227 + 364)) and v102.FireNova:IsReady() and v42 and (v102.FlameShockDebuff:AuraActiveCount() >= (897 - (557 + 338)))) then
					if (((1005 + 2393) >= (6749 - 4354)) and v24(v102.FireNova)) then
						return "fire_nova aoe 26";
					end
				end
				if ((v102.ElementalBlast:IsReady() and v41 and (not v102.ElementalSpirits:IsAvailable() or (v102.ElementalSpirits:IsAvailable() and ((v102.ElementalBlast:Charges() == v114) or (v120.FeralSpiritCount >= (6 - 4))))) and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (13 - 8)) and (not v102.CrashingStorms:IsAvailable() or (v112 <= (6 - 3)))) or ((2984 - (499 + 302)) >= (3690 - (39 + 827)))) then
					if (((5343 - 3407) == (4323 - 2387)) and v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast))) then
						return "elemental_blast aoe 27";
					end
				end
				if ((v102.ChainLightning:IsReady() and v39 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (19 - 14))) or ((7418 - 2586) < (370 + 3943))) then
					if (((11965 - 7877) > (620 + 3254)) and v24(v102.ChainLightning, not v15:IsSpellInRange(v102.ChainLightning))) then
						return "chain_lightning aoe 28";
					end
				end
				if (((6854 - 2522) == (4436 - (103 + 1))) and v102.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (644 - (475 + 79))))) then
					if (((8644 - 4645) >= (9280 - 6380)) and v24(v102.WindfuryTotem)) then
						return "windfury_totem aoe 29";
					end
				end
				if ((v102.FlameShock:IsReady() and v43 and (v15:DebuffDown(v102.FlameShockDebuff))) or ((327 + 2198) > (3577 + 487))) then
					if (((5874 - (1395 + 108)) == (12719 - 8348)) and v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock aoe 30";
					end
				end
				v163 = 1209 - (7 + 1197);
			end
		end
	end
	local function v140()
		local v164 = 0 + 0;
		while true do
			if ((v164 == (1 + 0)) or ((585 - (27 + 292)) > (14610 - 9624))) then
				if (((2538 - 547) >= (3879 - 2954)) and (not v107 or (v109 < (1183240 - 583240))) and v54 and v102.FlamentongueWeapon:IsCastable()) then
					if (((866 - 411) < (2192 - (43 + 96))) and v24(v102.FlamentongueWeapon)) then
						return "flametongue_weapon enchant";
					end
				end
				if (v86 or ((3369 - 2543) == (10967 - 6116))) then
					local v243 = 0 + 0;
					while true do
						if (((52 + 131) == (361 - 178)) and (v243 == (0 + 0))) then
							v33 = v134();
							if (((2171 - 1012) <= (563 + 1225)) and v33) then
								return v33;
							end
							break;
						end
					end
				end
				v164 = 1 + 1;
			end
			if ((v164 == (1751 - (1414 + 337))) or ((5447 - (1642 + 298)) > (11256 - 6938))) then
				if ((v76 and v102.EarthShield:IsCastable() and v14:BuffDown(v102.EarthShieldBuff) and ((v77 == "Earth Shield") or (v102.ElementalOrbit:IsAvailable() and v14:BuffUp(v102.LightningShield)))) or ((8846 - 5771) <= (8798 - 5833))) then
					if (((450 + 915) <= (1565 + 446)) and v24(v102.EarthShield)) then
						return "earth_shield main 2";
					end
				elseif ((v76 and v102.LightningShield:IsCastable() and v14:BuffDown(v102.LightningShieldBuff) and ((v77 == "Lightning Shield") or (v102.ElementalOrbit:IsAvailable() and v14:BuffUp(v102.EarthShield)))) or ((3748 - (357 + 615)) > (2510 + 1065))) then
					if (v24(v102.LightningShield) or ((6266 - 3712) == (4117 + 687))) then
						return "lightning_shield main 2";
					end
				end
				if (((5522 - 2945) == (2062 + 515)) and (not v106 or (v108 < (40770 + 559230))) and v54 and v102.WindfuryWeapon:IsCastable()) then
					if (v24(v102.WindfuryWeapon) or ((4 + 2) >= (3190 - (384 + 917)))) then
						return "windfury_weapon enchant";
					end
				end
				v164 = 698 - (128 + 569);
			end
			if (((2049 - (1407 + 136)) <= (3779 - (687 + 1200))) and (v164 == (1712 - (556 + 1154)))) then
				if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) or ((7064 - 5056) > (2313 - (9 + 86)))) then
					if (((800 - (275 + 146)) <= (675 + 3472)) and v24(v102.AncestralSpirit, nil, true)) then
						return "resurrection";
					end
				end
				if ((v118.TargetIsValid() and v34) or ((4578 - (29 + 35)) <= (4471 - 3462))) then
					if (not v14:AffectingCombat() or ((10442 - 6946) == (5262 - 4070))) then
						local v248 = 0 + 0;
						while true do
							if ((v248 == (1012 - (53 + 959))) or ((616 - (312 + 96)) == (5135 - 2176))) then
								v33 = v137();
								if (((4562 - (147 + 138)) >= (2212 - (813 + 86))) and v33) then
									return v33;
								end
								break;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v141()
		local v165 = 0 + 0;
		while true do
			if (((4793 - 2206) < (3666 - (18 + 474))) and (v165 == (1 + 0))) then
				if (v94 or ((13447 - 9327) <= (3284 - (860 + 226)))) then
					local v244 = 303 - (121 + 182);
					while true do
						if ((v244 == (1 + 0)) or ((2836 - (988 + 252)) == (97 + 761))) then
							if (((1009 + 2211) == (5190 - (49 + 1921))) and v90) then
								v33 = v118.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 920 - (223 + 667));
								if (v33 or ((1454 - (51 + 1)) > (6230 - 2610))) then
									return v33;
								end
							end
							if (((5511 - 2937) == (3699 - (146 + 979))) and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (2 + 3)) and v91) then
								local v253 = 605 - (311 + 294);
								while true do
									if (((5014 - 3216) < (1168 + 1589)) and (v253 == (1443 - (496 + 947)))) then
										v33 = v118.HandleAfflicted(v102.HealingSurge, v104.HealingSurgeMouseover, 1398 - (1233 + 125), true);
										if (v33 or ((153 + 224) > (2337 + 267))) then
											return v33;
										end
										break;
									end
								end
							end
							break;
						end
						if (((108 + 460) < (2556 - (963 + 682))) and (v244 == (0 + 0))) then
							if (((4789 - (504 + 1000)) < (2848 + 1380)) and v88) then
								local v254 = 0 + 0;
								while true do
									if (((370 + 3546) > (4907 - 1579)) and (v254 == (0 + 0))) then
										v33 = v118.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 24 + 16);
										if (((2682 - (156 + 26)) < (2212 + 1627)) and v33) then
											return v33;
										end
										break;
									end
								end
							end
							if (((793 - 286) == (671 - (149 + 15))) and v89) then
								local v255 = 960 - (890 + 70);
								while true do
									if (((357 - (39 + 78)) <= (3647 - (14 + 468))) and (v255 == (0 - 0))) then
										v33 = v118.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 83 - 53);
										if (((431 + 403) >= (484 + 321)) and v33) then
											return v33;
										end
										break;
									end
								end
							end
							v244 = 1 + 0;
						end
					end
				end
				if (v95 or ((1722 + 2090) < (607 + 1709))) then
					local v245 = 0 - 0;
					while true do
						if (((0 + 0) == v245) or ((9319 - 6667) <= (39 + 1494))) then
							v33 = v118.HandleIncorporeal(v102.Hex, v104.HexMouseOver, 81 - (12 + 39), true);
							if (v33 or ((3348 + 250) < (4519 - 3059))) then
								return v33;
							end
							break;
						end
					end
				end
				v165 = 6 - 4;
			end
			if ((v165 == (1 + 1)) or ((2167 + 1949) < (3022 - 1830))) then
				if (v16 or ((2250 + 1127) <= (4363 - 3460))) then
					if (((5686 - (1596 + 114)) >= (1145 - 706)) and v93) then
						v33 = v132();
						if (((4465 - (164 + 549)) == (5190 - (1059 + 379))) and v33) then
							return v33;
						end
					end
				end
				if (((5023 - 977) > (1397 + 1298)) and v102.GreaterPurge:IsAvailable() and v101 and v102.GreaterPurge:IsReady() and v38 and v92 and not v14:IsCasting() and not v14:IsChanneling() and v118.UnitHasMagicBuff(v15)) then
					if (v24(v102.GreaterPurge, not v15:IsSpellInRange(v102.GreaterPurge)) or ((598 + 2947) == (3589 - (145 + 247)))) then
						return "greater_purge damage";
					end
				end
				v165 = 3 + 0;
			end
			if (((1107 + 1287) > (1105 - 732)) and (v165 == (0 + 0))) then
				v33 = v135();
				if (((3580 + 575) <= (6871 - 2639)) and v33) then
					return v33;
				end
				v165 = 721 - (254 + 466);
			end
			if ((v165 == (563 - (544 + 16))) or ((11380 - 7799) == (4101 - (294 + 334)))) then
				if (((5248 - (236 + 17)) > (1444 + 1904)) and v102.Purge:IsReady() and v101 and v38 and v92 and not v14:IsCasting() and not v14:IsChanneling() and v118.UnitHasMagicBuff(v15)) then
					if (v24(v102.Purge, not v15:IsSpellInRange(v102.Purge)) or ((587 + 167) > (14024 - 10300))) then
						return "purge damage";
					end
				end
				v33 = v133();
				v165 = 18 - 14;
			end
			if (((112 + 105) >= (47 + 10)) and (v165 == (798 - (413 + 381)))) then
				if (v33 or ((88 + 1982) >= (8585 - 4548))) then
					return v33;
				end
				if (((7026 - 4321) == (4675 - (582 + 1388))) and v118.TargetIsValid()) then
					local v246 = 0 - 0;
					local v247;
					while true do
						if (((44 + 17) == (425 - (326 + 38))) and (v246 == (8 - 5))) then
							if ((v102.DoomWinds:IsCastable() and v57 and ((v62 and v36) or not v62) and (v100 < v117)) or ((997 - 298) >= (1916 - (47 + 573)))) then
								if (v24(v102.DoomWinds, not v15:IsInMeleeRange(2 + 3)) or ((7572 - 5789) >= (5868 - 2252))) then
									return "doom_winds main 5";
								end
							end
							if ((v112 == (1665 - (1269 + 395))) or ((4405 - (76 + 416)) > (4970 - (319 + 124)))) then
								local v256 = 0 - 0;
								while true do
									if (((5383 - (564 + 443)) > (2261 - 1444)) and (v256 == (458 - (337 + 121)))) then
										v33 = v138();
										if (((14242 - 9381) > (2744 - 1920)) and v33) then
											return v33;
										end
										break;
									end
								end
							end
							if ((v35 and (v112 > (1912 - (1261 + 650)))) or ((586 + 797) >= (3395 - 1264))) then
								local v257 = 1817 - (772 + 1045);
								while true do
									if ((v257 == (0 + 0)) or ((2020 - (102 + 42)) >= (4385 - (1524 + 320)))) then
										v33 = v139();
										if (((3052 - (1049 + 221)) <= (3928 - (18 + 138))) and v33) then
											return v33;
										end
										break;
									end
								end
							end
							break;
						end
						if ((v246 == (2 - 1)) or ((5802 - (67 + 1035)) < (1161 - (136 + 212)))) then
							if (((13593 - 10394) < (3245 + 805)) and (v100 < v117) and v59 and ((v66 and v36) or not v66)) then
								if ((v102.BloodFury:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (47 + 3)))) or ((6555 - (240 + 1364)) < (5512 - (1050 + 32)))) then
									if (((342 - 246) == (57 + 39)) and v24(v102.BloodFury)) then
										return "blood_fury racial";
									end
								end
								if ((v102.Berserking:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff))) or ((3794 - (331 + 724)) > (324 + 3684))) then
									if (v24(v102.Berserking) or ((667 - (269 + 375)) == (1859 - (267 + 458)))) then
										return "berserking racial";
									end
								end
								if ((v102.Fireblood:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (16 + 34)))) or ((5178 - 2485) >= (4929 - (667 + 151)))) then
									if (v24(v102.Fireblood) or ((5813 - (1410 + 87)) <= (4043 - (1504 + 393)))) then
										return "fireblood racial";
									end
								end
								if ((v102.AncestralCall:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (135 - 85)))) or ((9199 - 5653) <= (3605 - (461 + 335)))) then
									if (((627 + 4277) > (3927 - (1730 + 31))) and v24(v102.AncestralCall)) then
										return "ancestral_call racial";
									end
								end
							end
							if (((1776 - (728 + 939)) >= (318 - 228)) and v102.TotemicProjection:IsCastable() and (v102.WindfuryTotem:TimeSinceLastCast() < (182 - 92)) and v14:BuffDown(v102.WindfuryTotemBuff, true)) then
								if (((11405 - 6427) > (3973 - (138 + 930))) and v24(v104.TotemicProjectionPlayer)) then
									return "totemic_projection wind_fury main 0";
								end
							end
							if ((v102.Windstrike:IsCastable() and v53) or ((2766 + 260) <= (1783 + 497))) then
								if (v24(v102.Windstrike, not v15:IsSpellInRange(v102.Windstrike)) or ((1417 + 236) <= (4524 - 3416))) then
									return "windstrike main 1";
								end
							end
							v246 = 1768 - (459 + 1307);
						end
						if (((4779 - (474 + 1396)) > (4555 - 1946)) and (v246 == (2 + 0))) then
							if (((3 + 754) > (555 - 361)) and v102.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v117) and (v14:HasTier(4 + 27, 6 - 4))) then
								if (v24(v102.PrimordialWave, not v15:IsSpellInRange(v102.PrimordialWave)) or ((135 - 104) >= (1989 - (562 + 29)))) then
									return "primordial_wave main 2";
								end
							end
							if (((2725 + 471) <= (6291 - (374 + 1045))) and v102.FeralSpirit:IsCastable() and v56 and ((v61 and v36) or not v61) and (v100 < v117)) then
								if (((2633 + 693) == (10327 - 7001)) and v24(v102.FeralSpirit)) then
									return "feral_spirit main 3";
								end
							end
							if (((2071 - (448 + 190)) <= (1252 + 2626)) and v102.Ascendance:IsCastable() and v55 and ((v60 and v36) or not v60) and (v100 < v117) and v15:DebuffUp(v102.FlameShockDebuff) and (((v115 == "Lightning Bolt") and (v112 == (1 + 0))) or ((v115 == "Chain Lightning") and (v112 > (1 + 0))))) then
								if (v24(v102.Ascendance) or ((6086 - 4503) == (5390 - 3655))) then
									return "ascendance main 4";
								end
							end
							v246 = 1497 - (1307 + 187);
						end
						if ((v246 == (0 - 0)) or ((6979 - 3998) == (7205 - 4855))) then
							v247 = v118.HandleDPSPotion(v14:BuffUp(v102.FeralSpiritBuff));
							if (v247 or ((5149 - (232 + 451)) <= (471 + 22))) then
								return v247;
							end
							if ((v100 < v117) or ((2250 + 297) <= (2551 - (510 + 54)))) then
								if (((5965 - 3004) > (2776 - (13 + 23))) and v58 and ((v36 and v65) or not v65)) then
									local v258 = 0 - 0;
									while true do
										if (((5310 - 1614) >= (6562 - 2950)) and ((1088 - (830 + 258)) == v258)) then
											v33 = v136();
											if (v33 or ((10476 - 7506) == (1175 + 703))) then
												return v33;
											end
											break;
										end
									end
								end
							end
							v246 = 1 + 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v142()
		local v166 = 1441 - (860 + 581);
		while true do
			if ((v166 == (14 - 10)) or ((2931 + 762) < (2218 - (237 + 4)))) then
				v53 = EpicSettings.Settings['useWindstrike'];
				v52 = EpicSettings.Settings['useWindfuryTotem'];
				v54 = EpicSettings.Settings['useWeaponEnchant'];
				v60 = EpicSettings.Settings['ascendanceWithCD'];
				v166 = 11 - 6;
			end
			if ((v166 == (0 - 0)) or ((1763 - 833) > (1720 + 381))) then
				v55 = EpicSettings.Settings['useAscendance'];
				v57 = EpicSettings.Settings['useDoomWinds'];
				v56 = EpicSettings.Settings['useFeralSpirit'];
				v39 = EpicSettings.Settings['useChainlightning'];
				v166 = 1 + 0;
			end
			if (((15679 - 11526) > (1325 + 1761)) and (v166 == (3 + 2))) then
				v62 = EpicSettings.Settings['doomWindsWithCD'];
				v61 = EpicSettings.Settings['feralSpiritWithCD'];
				v64 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v63 = EpicSettings.Settings['sunderingWithMiniCD'];
				break;
			end
			if ((v166 == (1429 - (85 + 1341))) or ((7940 - 3286) <= (11437 - 7387))) then
				v48 = EpicSettings.Settings['useLightningBolt'];
				v49 = EpicSettings.Settings['usePrimordialWave'];
				v50 = EpicSettings.Settings['useStormStrike'];
				v51 = EpicSettings.Settings['useSundering'];
				v166 = 376 - (45 + 327);
			end
			if ((v166 == (3 - 1)) or ((3104 - (444 + 58)) < (651 + 845))) then
				v44 = EpicSettings.Settings['useFrostShock'];
				v45 = EpicSettings.Settings['useIceStrike'];
				v46 = EpicSettings.Settings['useLavaBurst'];
				v47 = EpicSettings.Settings['useLavaLash'];
				v166 = 1 + 2;
			end
			if (((1 + 0) == v166) or ((2955 - 1935) > (4020 - (64 + 1668)))) then
				v40 = EpicSettings.Settings['useCrashLightning'];
				v41 = EpicSettings.Settings['useElementalBlast'];
				v42 = EpicSettings.Settings['useFireNova'];
				v43 = EpicSettings.Settings['useFlameShock'];
				v166 = 1975 - (1227 + 746);
			end
		end
	end
	local function v143()
		local v167 = 0 - 0;
		while true do
			if (((608 - 280) == (822 - (415 + 79))) and ((1 + 3) == v167)) then
				v87 = EpicSettings.Settings['healOOCHP'] or (491 - (142 + 349));
				v101 = EpicSettings.Settings['usePurgeTarget'];
				v88 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v89 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v167 = 3 + 2;
			end
			if (((2077 - 566) < (1893 + 1915)) and (v167 == (4 + 1))) then
				v90 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				v91 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
				break;
			end
			if ((v167 == (5 - 3)) or ((4374 - (1710 + 154)) > (5237 - (200 + 118)))) then
				v80 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
				v78 = EpicSettings.Settings['astralShiftHP'] or (0 - 0);
				v81 = EpicSettings.Settings['healingStreamTotemHP'] or (0 - 0);
				v82 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
				v167 = 3 + 0;
			end
			if (((2557 + 2206) == (761 + 4002)) and (v167 == (6 - 3))) then
				v83 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (1250 - (363 + 887));
				v76 = EpicSettings.Settings['autoShield'];
				v77 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v86 = EpicSettings.Settings['healOOC'];
				v167 = 6 - 2;
			end
			if (((19691 - 15554) > (286 + 1562)) and (v167 == (2 - 1))) then
				v70 = EpicSettings.Settings['useAstralShift'];
				v73 = EpicSettings.Settings['useMaelstromHealingSurge'];
				v72 = EpicSettings.Settings['useHealingStreamTotem'];
				v79 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 + 0);
				v167 = 1666 - (674 + 990);
			end
			if (((699 + 1737) <= (1283 + 1851)) and (v167 == (0 - 0))) then
				v67 = EpicSettings.Settings['useWindShear'];
				v68 = EpicSettings.Settings['useCapacitorTotem'];
				v69 = EpicSettings.Settings['useThunderstorm'];
				v71 = EpicSettings.Settings['useAncestralGuidance'];
				v167 = 1056 - (507 + 548);
			end
		end
	end
	local function v144()
		local v168 = 837 - (289 + 548);
		while true do
			if (((5541 - (821 + 997)) == (3978 - (195 + 60))) and (v168 == (1 + 2))) then
				v84 = EpicSettings.Settings['healthstoneHP'] or (1501 - (251 + 1250));
				v85 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v96 = EpicSettings.Settings['HealingPotionName'] or "";
				v94 = EpicSettings.Settings['handleAfflicted'];
				v168 = 3 + 1;
			end
			if ((v168 == (1034 - (809 + 223))) or ((5904 - 1858) >= (12961 - 8645))) then
				v65 = EpicSettings.Settings['trinketsWithCD'];
				v66 = EpicSettings.Settings['racialsWithCD'];
				v74 = EpicSettings.Settings['useHealthstone'];
				v75 = EpicSettings.Settings['useHealingPotion'];
				v168 = 9 - 6;
			end
			if ((v168 == (0 + 0)) or ((1052 + 956) < (2546 - (14 + 603)))) then
				v100 = EpicSettings.Settings['fightRemainsCheck'] or (129 - (118 + 11));
				v97 = EpicSettings.Settings['InterruptWithStun'];
				v98 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v99 = EpicSettings.Settings['InterruptThreshold'];
				v168 = 1 + 0;
			end
			if (((1986 + 398) > (5172 - 3397)) and (v168 == (953 - (551 + 398)))) then
				v95 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((1 + 0) == v168) or ((1617 + 2926) <= (3557 + 819))) then
				v93 = EpicSettings.Settings['DispelDebuffs'];
				v92 = EpicSettings.Settings['DispelBuffs'];
				v58 = EpicSettings.Settings['useTrinkets'];
				v59 = EpicSettings.Settings['useRacials'];
				v168 = 7 - 5;
			end
		end
	end
	local function v145()
		v143();
		v142();
		v144();
		v34 = EpicSettings.Toggles['ooc'];
		v35 = EpicSettings.Toggles['aoe'];
		v36 = EpicSettings.Toggles['cds'];
		v38 = EpicSettings.Toggles['dispel'];
		v37 = EpicSettings.Toggles['minicds'];
		if (((1677 - 949) == (236 + 492)) and v14:IsDeadOrGhost()) then
			return v33;
		end
		v106, v108, _, _, v107, v109 = v27();
		v110 = v14:GetEnemiesInRange(158 - 118);
		v111 = v14:GetEnemiesInMeleeRange(3 + 7);
		if (v35 or ((1165 - (40 + 49)) > (17787 - 13116))) then
			local v182 = 490 - (99 + 391);
			while true do
				if (((1532 + 319) >= (1661 - 1283)) and (v182 == (0 - 0))) then
					v113 = #v110;
					v112 = #v111;
					break;
				end
			end
		else
			local v183 = 0 + 0;
			while true do
				if ((v183 == (0 - 0)) or ((3552 - (1032 + 572)) >= (3893 - (203 + 214)))) then
					v113 = 1818 - (568 + 1249);
					v112 = 1 + 0;
					break;
				end
			end
		end
		if (((11513 - 6719) >= (3217 - 2384)) and v38 and v93) then
			local v184 = 1306 - (913 + 393);
			while true do
				if (((11549 - 7459) == (5779 - 1689)) and (v184 == (410 - (269 + 141)))) then
					if ((v14:AffectingCombat() and v102.CleanseSpirit:IsAvailable()) or ((8358 - 4600) == (4479 - (362 + 1619)))) then
						local v249 = 1625 - (950 + 675);
						local v250;
						while true do
							if ((v249 == (1 + 0)) or ((3852 - (216 + 963)) < (2862 - (485 + 802)))) then
								if (v33 or ((4280 - (432 + 127)) <= (2528 - (1065 + 8)))) then
									return v33;
								end
								break;
							end
							if (((519 + 415) < (3871 - (635 + 966))) and ((0 + 0) == v249)) then
								v250 = v93 and v102.CleanseSpirit:IsReady() and v38;
								v33 = v118.FocusUnit(v250, v104, 62 - (5 + 37), nil, 62 - 37);
								v249 = 1 + 0;
							end
						end
					end
					if (v102.CleanseSpirit:IsAvailable() or ((2550 - 938) == (588 + 667))) then
						if ((v17 and v17:Exists() and v17:IsAPlayer() and v118.UnitHasCurseDebuff(v17)) or ((9042 - 4690) < (15946 - 11740))) then
							if (v102.CleanseSpirit:IsReady() or ((5393 - 2533) <= (432 - 251))) then
								if (((2317 + 905) >= (2056 - (318 + 211))) and v24(v104.CleanseSpiritMouseover)) then
									return "cleanse_spirit mouseover";
								end
							end
						end
					end
					break;
				end
			end
		end
		if (((7405 - 5900) <= (3708 - (963 + 624))) and (v118.TargetIsValid() or v14:AffectingCombat())) then
			local v185 = 0 + 0;
			while true do
				if (((1590 - (518 + 328)) == (1733 - 989)) and (v185 == (1 - 0))) then
					if ((v117 == (11428 - (301 + 16))) or ((5800 - 3821) >= (7964 - 5128))) then
						v117 = v10.FightRemains(v111, false);
					end
					break;
				end
				if (((4783 - 2950) <= (2417 + 251)) and (v185 == (0 + 0))) then
					v116 = v10.BossFightRemains(nil, true);
					v117 = v116;
					v185 = 1 - 0;
				end
			end
		end
		if (((2218 + 1468) == (351 + 3335)) and v14:AffectingCombat()) then
			if (((11022 - 7555) > (154 + 323)) and v14:PrevGCD(1020 - (829 + 190), v102.ChainLightning)) then
				v115 = "Chain Lightning";
			elseif (v14:PrevGCD(3 - 2, v102.LightningBolt) or ((4159 - 871) >= (4894 - 1353))) then
				v115 = "Lightning Bolt";
			end
		end
		if ((not v14:IsChanneling() and not v14:IsChanneling()) or ((8835 - 5278) == (1076 + 3464))) then
			local v186 = 0 + 0;
			while true do
				if (((0 - 0) == v186) or ((247 + 14) > (1880 - (520 + 93)))) then
					if (((1548 - (259 + 17)) < (223 + 3635)) and v94) then
						local v251 = 0 + 0;
						while true do
							if (((12404 - 8740) == (4255 - (396 + 195))) and (v251 == (0 - 0))) then
								if (((3702 - (440 + 1321)) >= (2279 - (1059 + 770))) and v88) then
									local v259 = 0 - 0;
									while true do
										if (((545 - (424 + 121)) == v259) or ((847 + 3799) < (1671 - (641 + 706)))) then
											v33 = v118.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 16 + 24);
											if (((4273 - (249 + 191)) == (16697 - 12864)) and v33) then
												return v33;
											end
											break;
										end
									end
								end
								if (v89 or ((554 + 686) > (12988 - 9618))) then
									local v260 = 427 - (183 + 244);
									while true do
										if ((v260 == (0 + 0)) or ((3211 - (434 + 296)) == (14940 - 10258))) then
											v33 = v118.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 542 - (169 + 343));
											if (((4144 + 583) >= (365 - 157)) and v33) then
												return v33;
											end
											break;
										end
									end
								end
								v251 = 2 - 1;
							end
							if (((230 + 50) < (10921 - 7070)) and (v251 == (1124 - (651 + 472)))) then
								if (v90 or ((2273 + 734) > (1379 + 1815))) then
									local v261 = 0 - 0;
									while true do
										if ((v261 == (483 - (397 + 86))) or ((3012 - (423 + 453)) >= (300 + 2646))) then
											v33 = v118.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 4 + 26);
											if (((1891 + 274) <= (2012 + 509)) and v33) then
												return v33;
											end
											break;
										end
									end
								end
								if (((2556 + 305) > (1851 - (50 + 1140))) and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (5 + 0)) and v91) then
									local v262 = 0 + 0;
									while true do
										if (((282 + 4243) > (6489 - 1970)) and (v262 == (0 + 0))) then
											v33 = v118.HandleAfflicted(v102.HealingSurge, v104.HealingSurgeMouseover, 636 - (157 + 439), true);
											if (((5525 - 2347) > (3229 - 2257)) and v33) then
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
					if (((14097 - 9331) == (5684 - (782 + 136))) and v14:AffectingCombat()) then
						local v252 = 855 - (112 + 743);
						while true do
							if ((v252 == (1171 - (1026 + 145))) or ((472 + 2273) > (3846 - (493 + 225)))) then
								v33 = v141();
								if (v33 or ((4204 - 3060) >= (2802 + 1804))) then
									return v33;
								end
								break;
							end
						end
					else
						v33 = v140();
						if (((8949 - 5611) >= (6 + 271)) and v33) then
							return v33;
						end
					end
					break;
				end
			end
		end
	end
	local function v146()
		local v174 = 0 - 0;
		while true do
			if (((760 + 1850) > (4277 - 1717)) and (v174 == (1595 - (210 + 1385)))) then
				v102.FlameShockDebuff:RegisterAuraTracking();
				v122();
				v174 = 1690 - (1201 + 488);
			end
			if ((v174 == (1 + 0)) or ((2123 - 929) > (5529 - 2446))) then
				v21.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(848 - (352 + 233), v145, v146);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

