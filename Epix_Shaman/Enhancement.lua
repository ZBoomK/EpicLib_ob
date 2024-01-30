local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((97 + 1367) <= (4524 - (92 + 55))) and (v5 == (1189 - (442 + 747)))) then
			v6 = v0[v4];
			if (((3824 - (832 + 303)) < (5669 - (88 + 858))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((3423 + 713) >= (99 + 2298)) and (v5 == (790 - (766 + 23)))) then
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
	local v114 = (v102.LavaBurst:IsAvailable() and (9 - 7)) or (1 - 0);
	local v115 = "Lightning Bolt";
	local v116 = 29274 - 18163;
	local v117 = 37711 - 26600;
	local v118 = v21.Commons.Everyone;
	v21.Commons.Shaman = {};
	local v120 = v21.Commons.Shaman;
	v120.FeralSpiritCount = 1073 - (1036 + 37);
	v10:RegisterForEvent(function()
		v114 = (v102.LavaBurst:IsAvailable() and (2 + 0)) or (1 - 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		v115 = "Lightning Bolt";
		v116 = 8741 + 2370;
		v117 = 12591 - (641 + 839);
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForSelfCombatEvent(function(...)
		local v147 = 913 - (910 + 3);
		local v148;
		local v149;
		local v150;
		while true do
			if (((2 - 1) == v147) or ((6018 - (1466 + 218)) == (1951 + 2294))) then
				if ((v14:HasTier(1179 - (556 + 592), 1 + 1) and (v148 == v14:GUID()) and (v150 == (376790 - (329 + 479)))) or ((5130 - (174 + 680)) <= (10414 - 7383))) then
					v120.FeralSpiritCount = v120.FeralSpiritCount + (1 - 0);
					v32.After(11 + 4, function()
						v120.FeralSpiritCount = v120.FeralSpiritCount - (740 - (396 + 343));
					end);
				end
				if (((v148 == v14:GUID()) and (v150 == (4560 + 46973))) or ((6259 - (29 + 1448)) <= (2588 - (135 + 1254)))) then
					v120.FeralSpiritCount = v120.FeralSpiritCount + (7 - 5);
					v32.After(70 - 55, function()
						v120.FeralSpiritCount = v120.FeralSpiritCount - (2 + 0);
					end);
				end
				break;
			end
			if ((v147 == (1527 - (389 + 1138))) or ((5438 - (102 + 472)) < (1795 + 107))) then
				v148, v149, v149, v149, v149, v149, v149, v149, v150 = select(3 + 1, ...);
				if (((4513 + 326) >= (5245 - (320 + 1225))) and (v148 == v14:GUID()) and (v150 == (341144 - 149510))) then
					v120.LastSKCast = v31();
				end
				v147 = 1 + 0;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	local function v122()
		if (v102.CleanseSpirit:IsAvailable() or ((2539 - (157 + 1307)) > (3777 - (821 + 1038)))) then
			v118.DispellableDebuffs = v118.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123()
		for v170 = 2 - 1, 1 + 5, 1 - 0 do
			if (((148 + 248) <= (9428 - 5624)) and v30(v14:TotemName(v170), "Totem")) then
				return v170;
			end
		end
	end
	local function v124()
		local v151 = 1026 - (834 + 192);
		local v152;
		while true do
			if ((v151 == (1 + 0)) or ((1071 + 3098) == (47 + 2140))) then
				if (((2177 - 771) == (1710 - (300 + 4))) and ((v152 > (3 + 5)) or (v152 > v102.FeralSpirit:TimeSinceLastCast()))) then
					return 0 - 0;
				end
				return (370 - (112 + 250)) - v152;
			end
			if (((611 + 920) < (10699 - 6428)) and (v151 == (0 + 0))) then
				if (((329 + 306) == (475 + 160)) and (not v102.AlphaWolf:IsAvailable() or v14:BuffDown(v102.FeralSpiritBuff))) then
					return 0 + 0;
				end
				v152 = v29(v102.CrashLightning:TimeSinceLastCast(), v102.ChainLightning:TimeSinceLastCast());
				v151 = 1 + 0;
			end
		end
	end
	local function v125(v153)
		return (v153:DebuffRefreshable(v102.FlameShockDebuff));
	end
	local function v126(v154)
		return (v154:DebuffRefreshable(v102.LashingFlamesDebuff));
	end
	local function v127(v155)
		return (v155:DebuffRemains(v102.FlameShockDebuff));
	end
	local function v128(v156)
		return (v14:BuffDown(v102.PrimordialWaveBuff));
	end
	local function v129(v157)
		return (v15:DebuffRemains(v102.LashingFlamesDebuff));
	end
	local function v130(v158)
		return (v102.LashingFlames:IsAvailable());
	end
	local function v131(v159)
		return v159:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (1420 - (1001 + 413)));
	end
	local function v132()
		if (((7521 - 4148) <= (4438 - (244 + 638))) and v102.CleanseSpirit:IsReady() and v38 and v118.DispellableFriendlyUnit(718 - (627 + 66))) then
			if (v24(v104.CleanseSpiritFocus) or ((9805 - 6514) < (3882 - (512 + 90)))) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v133()
		if (((6292 - (1665 + 241)) >= (1590 - (373 + 344))) and (not v16 or not v16:Exists() or not v16:IsInRange(19 + 21))) then
			return;
		end
		if (((244 + 677) <= (2906 - 1804)) and v16) then
			if (((7963 - 3257) >= (2062 - (35 + 1064))) and (v16:HealthPercentage() <= v83) and v73 and v102.HealingSurge:IsReady() and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (4 + 1))) then
				if (v24(v104.HealingSurgeFocus) or ((2053 - 1093) <= (4 + 872))) then
					return "healing_surge heal focus";
				end
			end
		end
	end
	local function v134()
		if ((v14:HealthPercentage() <= v87) or ((3302 - (298 + 938)) == (2191 - (233 + 1026)))) then
			if (((6491 - (636 + 1030)) < (2477 + 2366)) and v102.HealingSurge:IsReady()) then
				if (v24(v102.HealingSurge) or ((3787 + 90) >= (1348 + 3189))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v135()
		if ((v102.AstralShift:IsReady() and v70 and (v14:HealthPercentage() <= v78)) or ((292 + 4023) < (1947 - (55 + 166)))) then
			if (v24(v102.AstralShift) or ((713 + 2966) < (63 + 562))) then
				return "astral_shift defensive 1";
			end
		end
		if ((v102.AncestralGuidance:IsReady() and v71 and v118.AreUnitsBelowHealthPercentage(v79, v80)) or ((17663 - 13038) < (929 - (36 + 261)))) then
			if (v24(v102.AncestralGuidance) or ((144 - 61) > (3148 - (34 + 1334)))) then
				return "ancestral_guidance defensive 2";
			end
		end
		if (((210 + 336) <= (837 + 240)) and v102.HealingStreamTotem:IsReady() and v72 and v118.AreUnitsBelowHealthPercentage(v81, v82)) then
			if (v24(v102.HealingStreamTotem) or ((2279 - (1035 + 248)) > (4322 - (20 + 1)))) then
				return "healing_stream_totem defensive 3";
			end
		end
		if (((2121 + 1949) > (1006 - (134 + 185))) and v102.HealingSurge:IsReady() and v73 and (v14:HealthPercentage() <= v83) and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (1138 - (549 + 584)))) then
			if (v24(v102.HealingSurge) or ((1341 - (314 + 371)) >= (11431 - 8101))) then
				return "healing_surge defensive 4";
			end
		end
		if ((v103.Healthstone:IsReady() and v74 and (v14:HealthPercentage() <= v84)) or ((3460 - (478 + 490)) <= (178 + 157))) then
			if (((5494 - (786 + 386)) >= (8298 - 5736)) and v24(v104.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if ((v75 and (v14:HealthPercentage() <= v85)) or ((5016 - (1055 + 324)) >= (5110 - (1093 + 247)))) then
			local v174 = 0 + 0;
			while true do
				if ((v174 == (0 + 0)) or ((9445 - 7066) > (15536 - 10958))) then
					if ((v96 == "Refreshing Healing Potion") or ((1374 - 891) > (1866 - 1123))) then
						if (((873 + 1581) > (2226 - 1648)) and v103.RefreshingHealingPotion:IsReady()) then
							if (((3205 - 2275) < (3362 + 1096)) and v24(v104.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((1692 - 1030) <= (1660 - (364 + 324))) and (v96 == "Dreamwalker's Healing Potion")) then
						if (((11979 - 7609) == (10486 - 6116)) and v103.DreamwalkersHealingPotion:IsReady()) then
							if (v24(v104.RefreshingHealingPotion) or ((1579 + 3183) <= (3602 - 2741))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v136()
		v33 = v118.HandleTopTrinket(v105, v36, 64 - 24, nil);
		if (v33 or ((4288 - 2876) == (5532 - (1249 + 19)))) then
			return v33;
		end
		v33 = v118.HandleBottomTrinket(v105, v36, 37 + 3, nil);
		if (v33 or ((12331 - 9163) < (3239 - (686 + 400)))) then
			return v33;
		end
	end
	local function v137()
		local v160 = 0 + 0;
		while true do
			if ((v160 == (231 - (73 + 156))) or ((24 + 4952) < (2143 - (721 + 90)))) then
				if (((53 + 4575) == (15026 - 10398)) and v102.Stormstrike:IsReady() and v50) then
					if (v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike)) or ((524 - (224 + 246)) == (639 - 244))) then
						return "stormstrike precombat 12";
					end
				end
				break;
			end
			if (((150 - 68) == (15 + 67)) and (v160 == (1 + 0))) then
				if ((v102.DoomWinds:IsCastable() and v57 and ((v62 and v36) or not v62)) or ((427 + 154) < (560 - 278))) then
					if (v24(v102.DoomWinds, not v15:IsSpellInRange(v102.DoomWinds)) or ((15337 - 10728) < (3008 - (203 + 310)))) then
						return "doom_winds precombat 8";
					end
				end
				if (((3145 - (1238 + 755)) == (81 + 1071)) and v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63)) then
					if (((3430 - (709 + 825)) <= (6305 - 2883)) and v24(v102.Sundering, not v15:IsInRange(6 - 1))) then
						return "sundering precombat 10";
					end
				end
				v160 = 866 - (196 + 668);
			end
			if ((v160 == (0 - 0)) or ((2050 - 1060) > (2453 - (171 + 662)))) then
				if ((v102.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (183 - (4 + 89))))) or ((3073 - 2196) > (1710 + 2985))) then
					if (((11819 - 9128) >= (726 + 1125)) and v24(v102.WindfuryTotem)) then
						return "windfury_totem precombat 4";
					end
				end
				if ((v102.FeralSpirit:IsCastable() and v56 and ((v61 and v36) or not v61)) or ((4471 - (35 + 1451)) >= (6309 - (28 + 1425)))) then
					if (((6269 - (941 + 1052)) >= (1146 + 49)) and v24(v102.FeralSpirit)) then
						return "feral_spirit precombat 6";
					end
				end
				v160 = 1515 - (822 + 692);
			end
		end
	end
	local function v138()
		if (((4613 - 1381) <= (2210 + 2480)) and v102.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v117) and v15:DebuffDown(v102.FlameShockDebuff) and v102.LashingFlames:IsAvailable()) then
			if (v24(v102.PrimordialWave, not v15:IsSpellInRange(v102.PrimordialWave)) or ((1193 - (45 + 252)) >= (3113 + 33))) then
				return "primordial_wave single 1";
			end
		end
		if (((1054 + 2007) >= (7198 - 4240)) and v102.FlameShock:IsReady() and v43 and v15:DebuffDown(v102.FlameShockDebuff) and v102.LashingFlames:IsAvailable()) then
			if (((3620 - (114 + 319)) >= (924 - 280)) and v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock))) then
				return "flame_shock single 2";
			end
		end
		if (((824 - 180) <= (449 + 255)) and v102.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (7 - 2)) and v102.ElementalSpirits:IsAvailable() and (v120.FeralSpiritCount >= (8 - 4))) then
			if (((2921 - (556 + 1407)) > (2153 - (741 + 465))) and v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast))) then
				return "elemental_blast single 3";
			end
		end
		if (((4957 - (170 + 295)) >= (1399 + 1255)) and v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v117) and (v14:HasTier(28 + 2, 4 - 2))) then
			if (((2854 + 588) >= (964 + 539)) and v24(v102.Sundering, not v15:IsInRange(5 + 3))) then
				return "sundering single 4";
			end
		end
		if ((v102.LightningBolt:IsReady() and v48 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (1235 - (957 + 273))) and v14:BuffDown(v102.CracklingThunderBuff) and v14:BuffUp(v102.AscendanceBuff) and (v115 == "Chain Lightning") and (v14:BuffRemains(v102.AscendanceBuff) > (v102.ChainLightning:CooldownRemains() + v14:GCD()))) or ((848 + 2322) <= (587 + 877))) then
			if (v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt)) or ((18278 - 13481) == (11563 - 7175))) then
				return "lightning_bolt single 5";
			end
		end
		if (((1682 - 1131) <= (3372 - 2691)) and v102.Stormstrike:IsReady() and v50 and (v14:BuffUp(v102.DoomWindsBuff) or v102.DeeplyRootedElements:IsAvailable() or (v102.Stormblast:IsAvailable() and v14:BuffUp(v102.StormbringerBuff)))) then
			if (((5057 - (389 + 1391)) > (256 + 151)) and v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike))) then
				return "stormstrike single 6";
			end
		end
		if (((489 + 4206) >= (3221 - 1806)) and v102.LavaLash:IsReady() and v47 and (v14:BuffUp(v102.HotHandBuff))) then
			if (v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash)) or ((4163 - (783 + 168)) <= (3168 - 2224))) then
				return "lava_lash single 7";
			end
		end
		if ((v102.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v102.WindfuryTotemBuff, true))) or ((3046 + 50) <= (2109 - (309 + 2)))) then
			if (((10861 - 7324) == (4749 - (1090 + 122))) and v24(v102.WindfuryTotem)) then
				return "windfury_totem single 8";
			end
		end
		if (((1244 + 2593) >= (5272 - 3702)) and v102.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (4 + 1)) and (v102.ElementalBlast:Charges() == v114)) then
			if (v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast)) or ((4068 - (628 + 490)) == (684 + 3128))) then
				return "elemental_blast single 9";
			end
		end
		if (((11693 - 6970) >= (10593 - 8275)) and v102.LightningBolt:IsReady() and v48 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (782 - (431 + 343))) and v14:BuffUp(v102.PrimordialWaveBuff) and (v14:BuffDown(v102.SplinteredElementsBuff) or (v117 <= (23 - 11)))) then
			if (v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt)) or ((5863 - 3836) > (2254 + 598))) then
				return "lightning_bolt single 10";
			end
		end
		if ((v102.ChainLightning:IsReady() and v39 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (2 + 6)) and v14:BuffUp(v102.CracklingThunderBuff) and v102.ElementalSpirits:IsAvailable()) or ((2831 - (556 + 1139)) > (4332 - (6 + 9)))) then
			if (((870 + 3878) == (2433 + 2315)) and v24(v102.ChainLightning, not v15:IsSpellInRange(v102.ChainLightning))) then
				return "chain_lightning single 11";
			end
		end
		if (((3905 - (28 + 141)) <= (1836 + 2904)) and v102.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (9 - 1)) and ((v120.FeralSpiritCount >= (2 + 0)) or not v102.ElementalSpirits:IsAvailable())) then
			if (v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast)) or ((4707 - (486 + 831)) <= (7962 - 4902))) then
				return "elemental_blast single 12";
			end
		end
		if ((v102.LavaBurst:IsReady() and v46 and not v102.ThorimsInvocation:IsAvailable() and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (17 - 12))) or ((189 + 810) > (8514 - 5821))) then
			if (((1726 - (668 + 595)) < (541 + 60)) and v24(v102.LavaBurst, not v15:IsSpellInRange(v102.LavaBurst))) then
				return "lava_burst single 13";
			end
		end
		if ((v102.LightningBolt:IsReady() and v48 and ((v14:BuffStack(v102.MaelstromWeaponBuff) >= (2 + 6)) or (v102.StaticAccumulation:IsAvailable() and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (13 - 8)))) and v14:BuffDown(v102.PrimordialWaveBuff)) or ((2473 - (23 + 267)) < (2631 - (1129 + 815)))) then
			if (((4936 - (371 + 16)) == (6299 - (1326 + 424))) and v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt))) then
				return "lightning_bolt single 14";
			end
		end
		if (((8848 - 4176) == (17072 - 12400)) and v102.CrashLightning:IsReady() and v40 and v102.AlphaWolf:IsAvailable() and v14:BuffUp(v102.FeralSpiritBuff) and (v124() == (118 - (88 + 30)))) then
			if (v24(v102.CrashLightning, not v15:IsInMeleeRange(779 - (720 + 51))) or ((8159 - 4491) < (2171 - (421 + 1355)))) then
				return "crash_lightning single 15";
			end
		end
		if ((v102.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v117)) or ((6872 - 2706) == (224 + 231))) then
			if (v24(v102.PrimordialWave, not v15:IsSpellInRange(v102.PrimordialWave)) or ((5532 - (286 + 797)) == (9734 - 7071))) then
				return "primordial_wave single 16";
			end
		end
		if ((v102.FlameShock:IsReady() and v43 and (v15:DebuffDown(v102.FlameShockDebuff))) or ((7084 - 2807) < (3428 - (397 + 42)))) then
			if (v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock)) or ((272 + 598) >= (4949 - (24 + 776)))) then
				return "flame_shock single 17";
			end
		end
		if (((3407 - 1195) < (3968 - (222 + 563))) and v102.IceStrike:IsReady() and v45 and v102.ElementalAssault:IsAvailable() and v102.SwirlingMaelstrom:IsAvailable()) then
			if (((10236 - 5590) > (2155 + 837)) and v24(v102.IceStrike, not v15:IsInMeleeRange(195 - (23 + 167)))) then
				return "ice_strike single 18";
			end
		end
		if (((3232 - (690 + 1108)) < (1121 + 1985)) and v102.LavaLash:IsReady() and v47 and (v102.LashingFlames:IsAvailable())) then
			if (((649 + 137) < (3871 - (40 + 808))) and v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash))) then
				return "lava_lash single 19";
			end
		end
		if ((v102.IceStrike:IsReady() and v45 and (v14:BuffDown(v102.IceStrikeBuff))) or ((403 + 2039) < (282 - 208))) then
			if (((4335 + 200) == (2400 + 2135)) and v24(v102.IceStrike, not v15:IsInMeleeRange(3 + 2))) then
				return "ice_strike single 20";
			end
		end
		if ((v102.FrostShock:IsReady() and v44 and (v14:BuffUp(v102.HailstormBuff))) or ((3580 - (47 + 524)) <= (1367 + 738))) then
			if (((5002 - 3172) < (5485 - 1816)) and v24(v102.FrostShock, not v15:IsSpellInRange(v102.FrostShock))) then
				return "frost_shock single 21";
			end
		end
		if ((v102.LavaLash:IsReady() and v47) or ((3261 - 1831) >= (5338 - (1165 + 561)))) then
			if (((80 + 2603) >= (7619 - 5159)) and v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash))) then
				return "lava_lash single 22";
			end
		end
		if ((v102.IceStrike:IsReady() and v45) or ((689 + 1115) >= (3754 - (341 + 138)))) then
			if (v24(v102.IceStrike, not v15:IsInMeleeRange(2 + 3)) or ((2924 - 1507) > (3955 - (89 + 237)))) then
				return "ice_strike single 23";
			end
		end
		if (((15425 - 10630) > (845 - 443)) and v102.Windstrike:IsCastable() and v53) then
			if (((5694 - (581 + 300)) > (4785 - (855 + 365))) and v24(v102.Windstrike, not v15:IsSpellInRange(v102.Windstrike))) then
				return "windstrike single 24";
			end
		end
		if (((9291 - 5379) == (1278 + 2634)) and v102.Stormstrike:IsReady() and v50) then
			if (((4056 - (1030 + 205)) <= (4529 + 295)) and v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike))) then
				return "stormstrike single 25";
			end
		end
		if (((1617 + 121) <= (2481 - (156 + 130))) and v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v117)) then
			if (((93 - 52) <= (5086 - 2068)) and v24(v102.Sundering, not v15:IsInRange(16 - 8))) then
				return "sundering single 26";
			end
		end
		if (((566 + 1579) <= (2394 + 1710)) and v102.BagofTricks:IsReady() and v59 and ((v66 and v36) or not v66)) then
			if (((2758 - (10 + 59)) < (1371 + 3474)) and v24(v102.BagofTricks)) then
				return "bag_of_tricks single 27";
			end
		end
		if ((v102.FireNova:IsReady() and v42 and v102.SwirlingMaelstrom:IsAvailable() and v15:DebuffUp(v102.FlameShockDebuff) and (v14:BuffStack(v102.MaelstromWeaponBuff) < ((24 - 19) + ((1168 - (671 + 492)) * v25(v102.OverflowingMaelstrom:IsAvailable()))))) or ((1849 + 473) > (3837 - (369 + 846)))) then
			if (v24(v102.FireNova) or ((1201 + 3333) == (1777 + 305))) then
				return "fire_nova single 28";
			end
		end
		if ((v102.LightningBolt:IsReady() and v48 and v102.Hailstorm:IsAvailable() and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (1950 - (1036 + 909))) and v14:BuffDown(v102.PrimordialWaveBuff)) or ((1250 + 321) > (3133 - 1266))) then
			if (v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt)) or ((2857 - (11 + 192)) >= (1515 + 1481))) then
				return "lightning_bolt single 29";
			end
		end
		if (((4153 - (135 + 40)) > (5097 - 2993)) and v102.FrostShock:IsReady() and v44) then
			if (((1806 + 1189) > (3394 - 1853)) and v24(v102.FrostShock, not v15:IsSpellInRange(v102.FrostShock))) then
				return "frost_shock single 30";
			end
		end
		if (((4870 - 1621) > (1129 - (50 + 126))) and v102.CrashLightning:IsReady() and v40) then
			if (v24(v102.CrashLightning, not v15:IsInMeleeRange(22 - 14)) or ((725 + 2548) > (5986 - (1233 + 180)))) then
				return "crash_lightning single 31";
			end
		end
		if ((v102.FireNova:IsReady() and v42 and (v15:DebuffUp(v102.FlameShockDebuff))) or ((4120 - (522 + 447)) < (2705 - (107 + 1314)))) then
			if (v24(v102.FireNova) or ((859 + 991) == (4658 - 3129))) then
				return "fire_nova single 32";
			end
		end
		if (((349 + 472) < (4215 - 2092)) and v102.FlameShock:IsReady() and v43) then
			if (((3568 - 2666) < (4235 - (716 + 1194))) and v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock))) then
				return "flame_shock single 34";
			end
		end
		if (((15 + 843) <= (318 + 2644)) and v102.ChainLightning:IsReady() and v39 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (508 - (74 + 429))) and v14:BuffUp(v102.CracklingThunderBuff) and v102.ElementalSpirits:IsAvailable()) then
			if (v24(v102.ChainLightning, not v15:IsSpellInRange(v102.ChainLightning)) or ((7612 - 3666) < (639 + 649))) then
				return "chain_lightning single 35";
			end
		end
		if ((v102.LightningBolt:IsReady() and v48 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (11 - 6)) and v14:BuffDown(v102.PrimordialWaveBuff)) or ((2294 + 948) == (1747 - 1180))) then
			if (v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt)) or ((2093 - 1246) >= (1696 - (279 + 154)))) then
				return "lightning_bolt single 36";
			end
		end
		if ((v102.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (868 - (454 + 324))))) or ((1773 + 480) == (1868 - (12 + 5)))) then
			if (v24(v102.WindfuryTotem) or ((1126 + 961) > (6043 - 3671))) then
				return "windfury_totem single 37";
			end
		end
	end
	local function v139()
		local v161 = 0 + 0;
		while true do
			if ((v161 == (1093 - (277 + 816))) or ((18993 - 14548) < (5332 - (1058 + 125)))) then
				if ((v102.CrashLightning:IsReady() and v40 and v102.CrashingStorms:IsAvailable() and ((v102.UnrulyWinds:IsAvailable() and (v112 >= (2 + 8))) or (v112 >= (990 - (815 + 160))))) or ((7800 - 5982) == (201 - 116))) then
					if (((151 + 479) < (6217 - 4090)) and v24(v102.CrashLightning, not v15:IsInMeleeRange(1906 - (41 + 1857)))) then
						return "crash_lightning aoe 1";
					end
				end
				if ((v102.LightningBolt:IsReady() and v48 and ((v102.FlameShockDebuff:AuraActiveCount() >= v112) or (v14:BuffRemains(v102.PrimordialWaveBuff) < (v14:GCD() * (1896 - (1222 + 671)))) or (v102.FlameShockDebuff:AuraActiveCount() >= (15 - 9))) and v14:BuffUp(v102.PrimordialWaveBuff) and (v14:BuffStack(v102.MaelstromWeaponBuff) == ((6 - 1) + ((1187 - (229 + 953)) * v25(v102.OverflowingMaelstrom:IsAvailable())))) and (v14:BuffDown(v102.SplinteredElementsBuff) or (v117 <= (1786 - (1111 + 663))) or (v100 <= v14:GCD()))) or ((3517 - (874 + 705)) == (352 + 2162))) then
					if (((2904 + 1351) >= (114 - 59)) and v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt))) then
						return "lightning_bolt aoe 2";
					end
				end
				if (((85 + 2914) > (1835 - (642 + 37))) and v102.LavaLash:IsReady() and v47 and v102.MoltenAssault:IsAvailable() and (v102.PrimordialWave:IsAvailable() or v102.FireNova:IsAvailable()) and v15:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (2 + 4))) then
					if (((376 + 1974) > (2899 - 1744)) and v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash aoe 3";
					end
				end
				if (((4483 - (233 + 221)) <= (11222 - 6369)) and v102.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v117) and (v14:BuffDown(v102.PrimordialWaveBuff))) then
					local v244 = 0 + 0;
					while true do
						if ((v244 == (1541 - (718 + 823))) or ((325 + 191) > (4239 - (266 + 539)))) then
							if (((11454 - 7408) >= (4258 - (636 + 589))) and v118.CastCycle(v102.PrimordialWave, v111, v125, not v15:IsSpellInRange(v102.PrimordialWave))) then
								return "primordial_wave aoe 4";
							end
							if (v24(v102.PrimordialWave, not v15:IsSpellInRange(v102.PrimordialWave)) or ((6453 - 3734) <= (2984 - 1537))) then
								return "primordial_wave aoe no_cycle 4";
							end
							break;
						end
					end
				end
				v161 = 1 + 0;
			end
			if ((v161 == (1 + 0)) or ((5149 - (657 + 358)) < (10394 - 6468))) then
				if ((v102.FlameShock:IsReady() and v43 and (v102.PrimordialWave:IsAvailable() or v102.FireNova:IsAvailable()) and v15:DebuffDown(v102.FlameShockDebuff)) or ((373 - 209) >= (3972 - (1151 + 36)))) then
					if (v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock)) or ((507 + 18) == (555 + 1554))) then
						return "flame_shock aoe 5";
					end
				end
				if (((98 - 65) == (1865 - (1552 + 280))) and v102.ElementalBlast:IsReady() and v41 and (not v102.ElementalSpirits:IsAvailable() or (v102.ElementalSpirits:IsAvailable() and ((v102.ElementalBlast:Charges() == v114) or (v120.FeralSpiritCount >= (836 - (64 + 770)))))) and (v14:BuffStack(v102.MaelstromWeaponBuff) == (4 + 1 + ((11 - 6) * v25(v102.OverflowingMaelstrom:IsAvailable())))) and (not v102.CrashingStorms:IsAvailable() or (v112 <= (1 + 2)))) then
					if (((4297 - (157 + 1086)) <= (8036 - 4021)) and v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast))) then
						return "elemental_blast aoe 6";
					end
				end
				if (((8194 - 6323) < (5187 - 1805)) and v102.ChainLightning:IsReady() and v39 and (v14:BuffStack(v102.MaelstromWeaponBuff) == ((6 - 1) + ((824 - (599 + 220)) * v25(v102.OverflowingMaelstrom:IsAvailable()))))) then
					if (((2574 - 1281) <= (4097 - (1813 + 118))) and v24(v102.ChainLightning, not v15:IsSpellInRange(v102.ChainLightning))) then
						return "chain_lightning aoe 7";
					end
				end
				if ((v102.CrashLightning:IsReady() and v40 and (v14:BuffUp(v102.DoomWindsBuff) or v14:BuffDown(v102.CrashLightningBuff) or (v102.AlphaWolf:IsAvailable() and v14:BuffUp(v102.FeralSpiritBuff) and (v124() == (0 + 0))))) or ((3796 - (841 + 376)) < (171 - 48))) then
					if (v24(v102.CrashLightning, not v15:IsInMeleeRange(2 + 6)) or ((2309 - 1463) >= (3227 - (464 + 395)))) then
						return "crash_lightning aoe 8";
					end
				end
				v161 = 5 - 3;
			end
			if ((v161 == (2 + 1)) or ((4849 - (467 + 370)) <= (6939 - 3581))) then
				if (((1097 + 397) <= (10301 - 7296)) and v102.IceStrike:IsReady() and v45 and (v102.Hailstorm:IsAvailable())) then
					if (v24(v102.IceStrike, not v15:IsInMeleeRange(1 + 4)) or ((7237 - 4126) == (2654 - (150 + 370)))) then
						return "ice_strike aoe 13";
					end
				end
				if (((3637 - (74 + 1208)) == (5792 - 3437)) and v102.FrostShock:IsReady() and v44 and v102.Hailstorm:IsAvailable() and v14:BuffUp(v102.HailstormBuff)) then
					if (v24(v102.FrostShock, not v15:IsSpellInRange(v102.FrostShock)) or ((2788 - 2200) <= (308 + 124))) then
						return "frost_shock aoe 14";
					end
				end
				if (((5187 - (14 + 376)) >= (6755 - 2860)) and v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v117)) then
					if (((2315 + 1262) == (3143 + 434)) and v24(v102.Sundering, not v15:IsInRange(8 + 0))) then
						return "sundering aoe 15";
					end
				end
				if (((11116 - 7322) > (2779 + 914)) and v102.FlameShock:IsReady() and v43 and v102.MoltenAssault:IsAvailable() and v15:DebuffDown(v102.FlameShockDebuff)) then
					if (v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock)) or ((1353 - (23 + 55)) == (9716 - 5616))) then
						return "flame_shock aoe 16";
					end
				end
				v161 = 3 + 1;
			end
			if (((5 + 0) == v161) or ((2466 - 875) >= (1127 + 2453))) then
				if (((1884 - (652 + 249)) <= (4838 - 3030)) and v102.Windstrike:IsCastable() and v53) then
					if (v24(v102.Windstrike, not v15:IsSpellInRange(v102.Windstrike)) or ((4018 - (708 + 1160)) <= (3249 - 2052))) then
						return "windstrike aoe 21";
					end
				end
				if (((6871 - 3102) >= (1200 - (10 + 17))) and v102.Stormstrike:IsReady() and v50) then
					if (((334 + 1151) == (3217 - (1400 + 332))) and v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike))) then
						return "stormstrike aoe 22";
					end
				end
				if ((v102.IceStrike:IsReady() and v45) or ((6358 - 3043) <= (4690 - (242 + 1666)))) then
					if (v24(v102.IceStrike, not v15:IsInMeleeRange(3 + 2)) or ((322 + 554) >= (2527 + 437))) then
						return "ice_strike aoe 23";
					end
				end
				if ((v102.LavaLash:IsReady() and v47) or ((3172 - (850 + 90)) > (4373 - 1876))) then
					if (v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash)) or ((3500 - (360 + 1030)) <= (294 + 38))) then
						return "lava_lash aoe 24";
					end
				end
				v161 = 16 - 10;
			end
			if (((5070 - 1384) > (4833 - (909 + 752))) and (v161 == (1227 - (109 + 1114)))) then
				if ((v102.FlameShock:IsReady() and v43 and v15:DebuffRefreshable(v102.FlameShockDebuff) and (v102.FireNova:IsAvailable() or v102.PrimordialWave:IsAvailable()) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (10 - 4))) or ((1742 + 2732) < (1062 - (6 + 236)))) then
					local v245 = 0 + 0;
					while true do
						if (((3445 + 834) >= (6796 - 3914)) and (v245 == (0 - 0))) then
							if (v118.CastCycle(v102.FlameShock, v111, v125, not v15:IsSpellInRange(v102.FlameShock)) or ((3162 - (1076 + 57)) >= (580 + 2941))) then
								return "flame_shock aoe 17";
							end
							if (v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock)) or ((2726 - (579 + 110)) >= (367 + 4275))) then
								return "flame_shock aoe no_cycle 17";
							end
							break;
						end
					end
				end
				if (((1521 + 199) < (2366 + 2092)) and v102.FireNova:IsReady() and v42 and (v102.FlameShockDebuff:AuraActiveCount() >= (410 - (174 + 233)))) then
					if (v24(v102.FireNova) or ((1217 - 781) > (5302 - 2281))) then
						return "fire_nova aoe 18";
					end
				end
				if (((318 + 395) <= (2021 - (663 + 511))) and v102.Stormstrike:IsReady() and v50 and v14:BuffUp(v102.CrashLightningBuff) and (v102.DeeplyRootedElements:IsAvailable() or (v14:BuffStack(v102.ConvergingStormsBuff) == (6 + 0)))) then
					if (((468 + 1686) <= (12427 - 8396)) and v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike))) then
						return "stormstrike aoe 19";
					end
				end
				if (((2795 + 1820) == (10864 - 6249)) and v102.CrashLightning:IsReady() and v40 and v102.CrashingStorms:IsAvailable() and v14:BuffUp(v102.CLCrashLightningBuff) and (v112 >= (9 - 5))) then
					if (v24(v102.CrashLightning, not v15:IsInMeleeRange(4 + 4)) or ((7376 - 3586) == (357 + 143))) then
						return "crash_lightning aoe 20";
					end
				end
				v161 = 1 + 4;
			end
			if (((811 - (478 + 244)) < (738 - (440 + 77))) and (v161 == (4 + 3))) then
				if (((7517 - 5463) >= (2977 - (655 + 901))) and v102.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (17 + 73)))) then
					if (((530 + 162) < (2065 + 993)) and v24(v102.WindfuryTotem)) then
						return "windfury_totem aoe 29";
					end
				end
				if ((v102.FlameShock:IsReady() and v43 and (v15:DebuffDown(v102.FlameShockDebuff))) or ((13108 - 9854) == (3100 - (695 + 750)))) then
					if (v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock)) or ((4425 - 3129) == (7577 - 2667))) then
						return "flame_shock aoe 30";
					end
				end
				if (((13545 - 10177) == (3719 - (285 + 66))) and v102.FrostShock:IsReady() and v44 and not v102.Hailstorm:IsAvailable()) then
					if (((6160 - 3517) < (5125 - (682 + 628))) and v24(v102.FrostShock, not v15:IsSpellInRange(v102.FrostShock))) then
						return "frost_shock aoe 31";
					end
				end
				break;
			end
			if (((309 + 1604) > (792 - (176 + 123))) and (v161 == (1 + 1))) then
				if (((3450 + 1305) > (3697 - (239 + 30))) and v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v117) and (v14:BuffUp(v102.DoomWindsBuff) or v14:HasTier(9 + 21, 2 + 0))) then
					if (((2444 - 1063) <= (7390 - 5021)) and v24(v102.Sundering, not v15:IsInRange(323 - (306 + 9)))) then
						return "sundering aoe 9";
					end
				end
				if ((v102.FireNova:IsReady() and v42 and ((v102.FlameShockDebuff:AuraActiveCount() >= (20 - 14)) or ((v102.FlameShockDebuff:AuraActiveCount() >= (1 + 3)) and (v102.FlameShockDebuff:AuraActiveCount() >= v112)))) or ((2972 + 1871) == (1966 + 2118))) then
					if (((13351 - 8682) > (1738 - (1140 + 235))) and v24(v102.FireNova)) then
						return "fire_nova aoe 10";
					end
				end
				if ((v102.LavaLash:IsReady() and v47 and (v102.LashingFlames:IsAvailable())) or ((1195 + 682) >= (2878 + 260))) then
					if (((1217 + 3525) >= (3678 - (33 + 19))) and v118.CastCycle(v102.LavaLash, v111, v126, not v15:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash aoe 11";
					end
					if (v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash)) or ((1640 + 2900) == (2745 - 1829))) then
						return "lava_lash aoe no_cycle 11";
					end
				end
				if ((v102.LavaLash:IsReady() and v47 and ((v102.MoltenAssault:IsAvailable() and v15:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (3 + 3))) or (v102.AshenCatalyst:IsAvailable() and (v14:BuffStack(v102.AshenCatalystBuff) == (9 - 4))))) or ((1084 + 72) > (5034 - (586 + 103)))) then
					if (((204 + 2033) < (13081 - 8832)) and v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash aoe 12";
					end
				end
				v161 = 1491 - (1309 + 179);
			end
			if ((v161 == (10 - 4)) or ((1168 + 1515) < (61 - 38))) then
				if (((527 + 170) <= (1754 - 928)) and v102.CrashLightning:IsReady() and v40) then
					if (((2201 - 1096) <= (1785 - (295 + 314))) and v24(v102.CrashLightning, not v15:IsInMeleeRange(19 - 11))) then
						return "crash_lightning aoe 25";
					end
				end
				if (((5341 - (1300 + 662)) <= (11970 - 8158)) and v102.FireNova:IsReady() and v42 and (v102.FlameShockDebuff:AuraActiveCount() >= (1757 - (1178 + 577)))) then
					if (v24(v102.FireNova) or ((410 + 378) >= (4776 - 3160))) then
						return "fire_nova aoe 26";
					end
				end
				if (((3259 - (851 + 554)) <= (2988 + 391)) and v102.ElementalBlast:IsReady() and v41 and (not v102.ElementalSpirits:IsAvailable() or (v102.ElementalSpirits:IsAvailable() and ((v102.ElementalBlast:Charges() == v114) or (v120.FeralSpiritCount >= (5 - 3))))) and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (10 - 5)) and (not v102.CrashingStorms:IsAvailable() or (v112 <= (305 - (115 + 187))))) then
					if (((3484 + 1065) == (4307 + 242)) and v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast))) then
						return "elemental_blast aoe 27";
					end
				end
				if ((v102.ChainLightning:IsReady() and v39 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (19 - 14))) or ((4183 - (160 + 1001)) >= (2646 + 378))) then
					if (((3326 + 1494) > (4499 - 2301)) and v24(v102.ChainLightning, not v15:IsSpellInRange(v102.ChainLightning))) then
						return "chain_lightning aoe 28";
					end
				end
				v161 = 365 - (237 + 121);
			end
		end
	end
	local function v140()
		if ((v76 and v102.EarthShield:IsCastable() and v14:BuffDown(v102.EarthShieldBuff) and ((v77 == "Earth Shield") or (v102.ElementalOrbit:IsAvailable() and v14:BuffUp(v102.LightningShield)))) or ((1958 - (525 + 372)) >= (9272 - 4381))) then
			if (((4481 - 3117) <= (4615 - (96 + 46))) and v24(v102.EarthShield)) then
				return "earth_shield main 2";
			end
		elseif ((v76 and v102.LightningShield:IsCastable() and v14:BuffDown(v102.LightningShieldBuff) and ((v77 == "Lightning Shield") or (v102.ElementalOrbit:IsAvailable() and v14:BuffUp(v102.EarthShield)))) or ((4372 - (643 + 134)) <= (2 + 1))) then
			if (v24(v102.LightningShield) or ((11202 - 6530) == (14301 - 10449))) then
				return "lightning_shield main 2";
			end
		end
		if (((1496 + 63) == (3058 - 1499)) and (not v106 or (v108 < (1226475 - 626475))) and v54 and v102.WindfuryWeapon:IsCastable()) then
			if (v24(v102.WindfuryWeapon) or ((2471 - (316 + 403)) <= (524 + 264))) then
				return "windfury_weapon enchant";
			end
		end
		if (((not v107 or (v109 < (1649627 - 1049627))) and v54 and v102.FlametongueWeapon:IsCastable()) or ((1412 + 2495) == (445 - 268))) then
			if (((2459 + 1011) > (179 + 376)) and v24(v102.FlametongueWeapon)) then
				return "flametongue_weapon enchant";
			end
		end
		if (v86 or ((3367 - 2395) == (3080 - 2435))) then
			local v175 = 0 - 0;
			while true do
				if (((183 + 2999) >= (4163 - 2048)) and (v175 == (0 + 0))) then
					v33 = v134();
					if (((11453 - 7560) < (4446 - (12 + 5))) and v33) then
						return v33;
					end
					break;
				end
			end
		end
		if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) or ((11135 - 8268) < (4064 - 2159))) then
			if (v24(v102.AncestralSpirit, nil, true) or ((3817 - 2021) >= (10045 - 5994))) then
				return "resurrection";
			end
		end
		if (((329 + 1290) <= (5729 - (1656 + 317))) and v118.TargetIsValid() and v34) then
			if (((539 + 65) == (485 + 119)) and not v14:AffectingCombat()) then
				local v231 = 0 - 0;
				while true do
					if ((v231 == (0 - 0)) or ((4838 - (5 + 349)) == (4274 - 3374))) then
						v33 = v137();
						if (v33 or ((5730 - (266 + 1005)) <= (734 + 379))) then
							return v33;
						end
						break;
					end
				end
			end
		end
	end
	local function v141()
		v33 = v135();
		if (((12392 - 8760) > (4473 - 1075)) and v33) then
			return v33;
		end
		if (((5778 - (561 + 1135)) <= (6407 - 1490)) and v94) then
			if (((15883 - 11051) >= (2452 - (507 + 559))) and v88) then
				local v232 = 0 - 0;
				while true do
					if (((423 - 286) == (525 - (212 + 176))) and (v232 == (905 - (250 + 655)))) then
						v33 = v118.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 109 - 69);
						if (v33 or ((2743 - 1173) >= (6777 - 2445))) then
							return v33;
						end
						break;
					end
				end
			end
			if (v89 or ((6020 - (1869 + 87)) <= (6308 - 4489))) then
				local v233 = 1901 - (484 + 1417);
				while true do
					if ((v233 == (0 - 0)) or ((8355 - 3369) < (2347 - (48 + 725)))) then
						v33 = v118.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 49 - 19);
						if (((11874 - 7448) > (100 + 72)) and v33) then
							return v33;
						end
						break;
					end
				end
			end
			if (((1565 - 979) > (128 + 327)) and v90) then
				v33 = v118.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 9 + 21);
				if (((1679 - (152 + 701)) == (2137 - (430 + 881))) and v33) then
					return v33;
				end
			end
			if (((v14:BuffStack(v102.MaelstromWeaponBuff) >= (2 + 3)) and v91) or ((4914 - (557 + 338)) > (1313 + 3128))) then
				local v234 = 0 - 0;
				while true do
					if (((7063 - 5046) < (11320 - 7059)) and (v234 == (0 - 0))) then
						v33 = v118.HandleAfflicted(v102.HealingSurge, v104.HealingSurgeMouseover, 841 - (499 + 302), true);
						if (((5582 - (39 + 827)) > (220 - 140)) and v33) then
							return v33;
						end
						break;
					end
				end
			end
		end
		if (v95 or ((7832 - 4325) == (12995 - 9723))) then
			v33 = v118.HandleIncorporeal(v102.Hex, v104.HexMouseOver, 46 - 16, true);
			if (v33 or ((75 + 801) >= (9000 - 5925))) then
				return v33;
			end
		end
		if (((697 + 3655) > (4040 - 1486)) and v16) then
			if (v93 or ((4510 - (103 + 1)) < (4597 - (475 + 79)))) then
				local v235 = 0 - 0;
				while true do
					if ((v235 == (0 - 0)) or ((245 + 1644) >= (2978 + 405))) then
						v33 = v132();
						if (((3395 - (1395 + 108)) <= (7955 - 5221)) and v33) then
							return v33;
						end
						break;
					end
				end
			end
		end
		if (((3127 - (7 + 1197)) < (968 + 1250)) and v102.GreaterPurge:IsAvailable() and v101 and v102.GreaterPurge:IsReady() and v38 and v92 and not v14:IsCasting() and not v14:IsChanneling() and v118.UnitHasMagicBuff(v15)) then
			if (((759 + 1414) > (698 - (27 + 292))) and v24(v102.GreaterPurge, not v15:IsSpellInRange(v102.GreaterPurge))) then
				return "greater_purge damage";
			end
		end
		if ((v102.Purge:IsReady() and v101 and v38 and v92 and not v14:IsCasting() and not v14:IsChanneling() and v118.UnitHasMagicBuff(v15)) or ((7592 - 5001) == (4346 - 937))) then
			if (((18930 - 14416) > (6555 - 3231)) and v24(v102.Purge, not v15:IsSpellInRange(v102.Purge))) then
				return "purge damage";
			end
		end
		v33 = v133();
		if (v33 or ((395 - 187) >= (4967 - (43 + 96)))) then
			return v33;
		end
		if (v118.TargetIsValid() or ((6457 - 4874) > (8064 - 4497))) then
			local v176 = v118.HandleDPSPotion(v14:BuffUp(v102.FeralSpiritBuff));
			if (v176 or ((1090 + 223) == (225 + 569))) then
				return v176;
			end
			if (((6272 - 3098) > (1113 + 1789)) and (v100 < v117)) then
				if (((7721 - 3601) <= (1342 + 2918)) and v58 and ((v36 and v65) or not v65)) then
					v33 = v136();
					if (v33 or ((65 + 818) > (6529 - (1414 + 337)))) then
						return v33;
					end
				end
			end
			if (((v100 < v117) and v59 and ((v66 and v36) or not v66)) or ((5560 - (1642 + 298)) >= (12749 - 7858))) then
				local v236 = 0 - 0;
				while true do
					if (((12635 - 8377) > (309 + 628)) and (v236 == (0 + 0))) then
						if ((v102.BloodFury:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (1022 - (357 + 615))))) or ((3418 + 1451) < (2222 - 1316))) then
							if (v24(v102.BloodFury) or ((1050 + 175) > (9060 - 4832))) then
								return "blood_fury racial";
							end
						end
						if (((2662 + 666) > (153 + 2085)) and v102.Berserking:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff))) then
							if (((2414 + 1425) > (2706 - (384 + 917))) and v24(v102.Berserking)) then
								return "berserking racial";
							end
						end
						v236 = 698 - (128 + 569);
					end
					if ((v236 == (1544 - (1407 + 136))) or ((3180 - (687 + 1200)) <= (2217 - (556 + 1154)))) then
						if ((v102.Fireblood:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (175 - 125)))) or ((2991 - (9 + 86)) < (1226 - (275 + 146)))) then
							if (((377 + 1939) == (2380 - (29 + 35))) and v24(v102.Fireblood)) then
								return "fireblood racial";
							end
						end
						if ((v102.AncestralCall:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (221 - 171)))) or ((7676 - 5106) == (6767 - 5234))) then
							if (v24(v102.AncestralCall) or ((576 + 307) == (2472 - (53 + 959)))) then
								return "ancestral_call racial";
							end
						end
						break;
					end
				end
			end
			if ((v102.TotemicProjection:IsCastable() and (v102.WindfuryTotem:TimeSinceLastCast() < (498 - (312 + 96))) and v14:BuffDown(v102.WindfuryTotemBuff, true)) or ((8016 - 3397) <= (1284 - (147 + 138)))) then
				if (v24(v104.TotemicProjectionPlayer) or ((4309 - (813 + 86)) > (3720 + 396))) then
					return "totemic_projection wind_fury main 0";
				end
			end
			if ((v102.Windstrike:IsCastable() and v53) or ((1672 - 769) >= (3551 - (18 + 474)))) then
				if (v24(v102.Windstrike, not v15:IsSpellInRange(v102.Windstrike)) or ((1342 + 2634) < (9324 - 6467))) then
					return "windstrike main 1";
				end
			end
			if (((6016 - (860 + 226)) > (2610 - (121 + 182))) and v102.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v117) and (v14:HasTier(4 + 27, 1242 - (988 + 252)))) then
				if (v24(v102.PrimordialWave, not v15:IsSpellInRange(v102.PrimordialWave)) or ((458 + 3588) < (405 + 886))) then
					return "primordial_wave main 2";
				end
			end
			if ((v102.FeralSpirit:IsCastable() and v56 and ((v61 and v36) or not v61) and (v100 < v117)) or ((6211 - (49 + 1921)) == (4435 - (223 + 667)))) then
				if (v24(v102.FeralSpirit) or ((4100 - (51 + 1)) > (7283 - 3051))) then
					return "feral_spirit main 3";
				end
			end
			if ((v102.Ascendance:IsCastable() and v55 and ((v60 and v36) or not v60) and (v100 < v117) and v15:DebuffUp(v102.FlameShockDebuff) and (((v115 == "Lightning Bolt") and (v112 == (1 - 0))) or ((v115 == "Chain Lightning") and (v112 > (1126 - (146 + 979)))))) or ((494 + 1256) >= (4078 - (311 + 294)))) then
				if (((8828 - 5662) == (1342 + 1824)) and v24(v102.Ascendance)) then
					return "ascendance main 4";
				end
			end
			if (((3206 - (496 + 947)) < (5082 - (1233 + 125))) and v102.DoomWinds:IsCastable() and v57 and ((v62 and v36) or not v62) and (v100 < v117)) then
				if (((24 + 33) <= (2444 + 279)) and v24(v102.DoomWinds, not v15:IsInMeleeRange(1 + 4))) then
					return "doom_winds main 5";
				end
			end
			if ((v112 == (1646 - (963 + 682))) or ((1728 + 342) == (1947 - (504 + 1000)))) then
				v33 = v138();
				if (v33 or ((1822 + 883) == (1269 + 124))) then
					return v33;
				end
			end
			if ((v35 and (v112 > (1 + 0))) or ((6784 - 2183) < (53 + 8))) then
				local v237 = 0 + 0;
				while true do
					if ((v237 == (182 - (156 + 26))) or ((801 + 589) >= (7422 - 2678))) then
						v33 = v139();
						if (v33 or ((2167 - (149 + 15)) > (4794 - (890 + 70)))) then
							return v33;
						end
						break;
					end
				end
			end
		end
	end
	local function v142()
		local v162 = 117 - (39 + 78);
		while true do
			if ((v162 == (489 - (14 + 468))) or ((342 - 186) > (10936 - 7023))) then
				v61 = EpicSettings.Settings['feralSpiritWithCD'];
				v64 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v63 = EpicSettings.Settings['sunderingWithMiniCD'];
				break;
			end
			if (((101 + 94) == (118 + 77)) and (v162 == (0 + 0))) then
				v55 = EpicSettings.Settings['useAscendance'];
				v57 = EpicSettings.Settings['useDoomWinds'];
				v56 = EpicSettings.Settings['useFeralSpirit'];
				v162 = 1 + 0;
			end
			if (((814 + 2291) >= (3437 - 1641)) and (v162 == (1 + 0))) then
				v39 = EpicSettings.Settings['useChainlightning'];
				v40 = EpicSettings.Settings['useCrashLightning'];
				v41 = EpicSettings.Settings['useElementalBlast'];
				v162 = 6 - 4;
			end
			if (((111 + 4268) >= (2182 - (12 + 39))) and ((5 + 0) == v162)) then
				v51 = EpicSettings.Settings['useSundering'];
				v53 = EpicSettings.Settings['useWindstrike'];
				v52 = EpicSettings.Settings['useWindfuryTotem'];
				v162 = 18 - 12;
			end
			if (((13690 - 9846) >= (606 + 1437)) and ((3 + 1) == v162)) then
				v48 = EpicSettings.Settings['useLightningBolt'];
				v49 = EpicSettings.Settings['usePrimordialWave'];
				v50 = EpicSettings.Settings['useStormStrike'];
				v162 = 12 - 7;
			end
			if (((2 + 1) == v162) or ((15619 - 12387) <= (4441 - (1596 + 114)))) then
				v45 = EpicSettings.Settings['useIceStrike'];
				v46 = EpicSettings.Settings['useLavaBurst'];
				v47 = EpicSettings.Settings['useLavaLash'];
				v162 = 10 - 6;
			end
			if (((5618 - (164 + 549)) == (6343 - (1059 + 379))) and ((2 - 0) == v162)) then
				v42 = EpicSettings.Settings['useFireNova'];
				v43 = EpicSettings.Settings['useFlameShock'];
				v44 = EpicSettings.Settings['useFrostShock'];
				v162 = 2 + 1;
			end
			if ((v162 == (2 + 4)) or ((4528 - (145 + 247)) >= (3620 + 791))) then
				v54 = EpicSettings.Settings['useWeaponEnchant'];
				v60 = EpicSettings.Settings['ascendanceWithCD'];
				v62 = EpicSettings.Settings['doomWindsWithCD'];
				v162 = 4 + 3;
			end
		end
	end
	local function v143()
		local v163 = 0 - 0;
		while true do
			if ((v163 == (1 + 3)) or ((2548 + 410) == (6522 - 2505))) then
				v83 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (720 - (254 + 466));
				v76 = EpicSettings.Settings['autoShield'];
				v77 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v163 = 565 - (544 + 16);
			end
			if (((3902 - 2674) >= (1441 - (294 + 334))) and (v163 == (256 - (236 + 17)))) then
				v78 = EpicSettings.Settings['astralShiftHP'] or (0 + 0);
				v81 = EpicSettings.Settings['healingStreamTotemHP'] or (0 + 0);
				v82 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 - 0);
				v163 = 18 - 14;
			end
			if (((1 + 0) == v163) or ((2846 + 609) > (4844 - (413 + 381)))) then
				v71 = EpicSettings.Settings['useAncestralGuidance'];
				v70 = EpicSettings.Settings['useAstralShift'];
				v73 = EpicSettings.Settings['useMaelstromHealingSurge'];
				v163 = 1 + 1;
			end
			if (((516 - 273) == (630 - 387)) and (v163 == (1975 - (582 + 1388)))) then
				v86 = EpicSettings.Settings['healOOC'];
				v87 = EpicSettings.Settings['healOOCHP'] or (0 - 0);
				v101 = EpicSettings.Settings['usePurgeTarget'];
				v163 = 5 + 1;
			end
			if ((v163 == (364 - (326 + 38))) or ((801 - 530) > (2243 - 671))) then
				v67 = EpicSettings.Settings['useWindShear'];
				v68 = EpicSettings.Settings['useCapacitorTotem'];
				v69 = EpicSettings.Settings['useThunderstorm'];
				v163 = 621 - (47 + 573);
			end
			if (((966 + 1773) < (13985 - 10692)) and (v163 == (2 - 0))) then
				v72 = EpicSettings.Settings['useHealingStreamTotem'];
				v79 = EpicSettings.Settings['ancestralGuidanceHP'] or (1664 - (1269 + 395));
				v80 = EpicSettings.Settings['ancestralGuidanceGroup'] or (492 - (76 + 416));
				v163 = 446 - (319 + 124);
			end
			if ((v163 == (13 - 7)) or ((4949 - (564 + 443)) < (3139 - 2005))) then
				v88 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v89 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v90 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				v163 = 465 - (337 + 121);
			end
			if ((v163 == (20 - 13)) or ((8970 - 6277) == (6884 - (1261 + 650)))) then
				v91 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
				break;
			end
		end
	end
	local function v144()
		local v164 = 0 + 0;
		while true do
			if (((3419 - 1273) == (3963 - (772 + 1045))) and (v164 == (1 + 2))) then
				v84 = EpicSettings.Settings['healthstoneHP'] or (144 - (102 + 42));
				v85 = EpicSettings.Settings['healingPotionHP'] or (1844 - (1524 + 320));
				v96 = EpicSettings.Settings['HealingPotionName'] or "";
				v94 = EpicSettings.Settings['handleAfflicted'];
				v164 = 1274 - (1049 + 221);
			end
			if ((v164 == (156 - (18 + 138))) or ((5492 - 3248) == (4326 - (67 + 1035)))) then
				v100 = EpicSettings.Settings['fightRemainsCheck'] or (348 - (136 + 212));
				v97 = EpicSettings.Settings['InterruptWithStun'];
				v98 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v99 = EpicSettings.Settings['InterruptThreshold'];
				v164 = 4 - 3;
			end
			if ((v164 == (1 + 0)) or ((4521 + 383) <= (3520 - (240 + 1364)))) then
				v93 = EpicSettings.Settings['DispelDebuffs'];
				v92 = EpicSettings.Settings['DispelBuffs'];
				v58 = EpicSettings.Settings['useTrinkets'];
				v59 = EpicSettings.Settings['useRacials'];
				v164 = 1084 - (1050 + 32);
			end
			if (((321 - 231) <= (630 + 435)) and (v164 == (1059 - (331 + 724)))) then
				v95 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((388 + 4414) == (5446 - (269 + 375))) and (v164 == (727 - (267 + 458)))) then
				v65 = EpicSettings.Settings['trinketsWithCD'];
				v66 = EpicSettings.Settings['racialsWithCD'];
				v74 = EpicSettings.Settings['useHealthstone'];
				v75 = EpicSettings.Settings['useHealingPotion'];
				v164 = 1 + 2;
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
		if (v14:IsDeadOrGhost() or ((4384 - 2104) <= (1329 - (667 + 151)))) then
			return v33;
		end
		v106, v108, _, _, v107, v109 = v27();
		v110 = v14:GetEnemiesInRange(1537 - (1410 + 87));
		v111 = v14:GetEnemiesInMeleeRange(1907 - (1504 + 393));
		if (v35 or ((4530 - 2854) <= (1200 - 737))) then
			local v177 = 796 - (461 + 335);
			while true do
				if (((495 + 3374) == (5630 - (1730 + 31))) and (v177 == (1667 - (728 + 939)))) then
					v113 = #v110;
					v112 = #v111;
					break;
				end
			end
		else
			local v178 = 0 - 0;
			while true do
				if (((2348 - 1190) <= (5986 - 3373)) and ((1068 - (138 + 930)) == v178)) then
					v113 = 1 + 0;
					v112 = 1 + 0;
					break;
				end
			end
		end
		if ((v38 and v93) or ((2027 + 337) <= (8162 - 6163))) then
			if ((v14:AffectingCombat() and v102.CleanseSpirit:IsAvailable()) or ((6688 - (459 + 1307)) < (2064 - (474 + 1396)))) then
				local v238 = v93 and v102.CleanseSpirit:IsReady() and v38;
				v33 = v118.FocusUnit(v238, v104, 34 - 14, nil, 24 + 1);
				if (v33 or ((7 + 2084) < (88 - 57))) then
					return v33;
				end
			end
			if (v102.CleanseSpirit:IsAvailable() or ((308 + 2122) >= (16263 - 11391))) then
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v118.UnitHasCurseDebuff(v17)) or ((20802 - 16032) < (2326 - (562 + 29)))) then
					if (v102.CleanseSpirit:IsReady() or ((3785 + 654) <= (3769 - (374 + 1045)))) then
						if (v24(v104.CleanseSpiritMouseover) or ((3545 + 934) < (13867 - 9401))) then
							return "cleanse_spirit mouseover";
						end
					end
				end
			end
		end
		if (((3185 - (448 + 190)) > (396 + 829)) and (v118.TargetIsValid() or v14:AffectingCombat())) then
			local v179 = 0 + 0;
			while true do
				if (((3044 + 1627) > (10280 - 7606)) and (v179 == (2 - 1))) then
					if ((v117 == (12605 - (1307 + 187))) or ((14656 - 10960) < (7789 - 4462))) then
						v117 = v10.FightRemains(v111, false);
					end
					break;
				end
				if ((v179 == (0 - 0)) or ((5225 - (232 + 451)) == (2836 + 134))) then
					v116 = v10.BossFightRemains(nil, true);
					v117 = v116;
					v179 = 1 + 0;
				end
			end
		end
		if (((816 - (510 + 54)) <= (3983 - 2006)) and v14:AffectingCombat()) then
			if (v14:PrevGCD(37 - (13 + 23), v102.ChainLightning) or ((2798 - 1362) == (5423 - 1648))) then
				v115 = "Chain Lightning";
			elseif (v14:PrevGCD(1 - 0, v102.LightningBolt) or ((2706 - (830 + 258)) < (3280 - 2350))) then
				v115 = "Lightning Bolt";
			end
		end
		if (((2955 + 1768) > (3534 + 619)) and not v14:IsChanneling() and not v14:IsChanneling()) then
			if (v94 or ((5095 - (860 + 581)) >= (17166 - 12512))) then
				local v239 = 0 + 0;
				while true do
					if (((1192 - (237 + 4)) <= (3515 - 2019)) and (v239 == (2 - 1))) then
						if (v90 or ((3291 - 1555) == (468 + 103))) then
							v33 = v118.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 18 + 12);
							if (v33 or ((3382 - 2486) > (2047 + 2722))) then
								return v33;
							end
						end
						if (((v14:BuffStack(v102.MaelstromWeaponBuff) >= (3 + 2)) and v91) or ((2471 - (85 + 1341)) <= (1740 - 720))) then
							v33 = v118.HandleAfflicted(v102.HealingSurge, v104.HealingSurgeMouseover, 112 - 72, true);
							if (v33 or ((1532 - (45 + 327)) <= (618 - 290))) then
								return v33;
							end
						end
						break;
					end
					if (((4310 - (444 + 58)) > (1271 + 1653)) and (v239 == (0 + 0))) then
						if (((1903 + 1988) < (14254 - 9335)) and v88) then
							local v248 = 1732 - (64 + 1668);
							while true do
								if ((v248 == (1973 - (1227 + 746))) or ((6866 - 4632) <= (2786 - 1284))) then
									v33 = v118.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 534 - (415 + 79));
									if (v33 or ((65 + 2447) < (923 - (142 + 349)))) then
										return v33;
									end
									break;
								end
							end
						end
						if (v89 or ((792 + 1056) == (1188 - 323))) then
							v33 = v118.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 15 + 15);
							if (v33 or ((3299 + 1383) <= (12366 - 7825))) then
								return v33;
							end
						end
						v239 = 1865 - (1710 + 154);
					end
				end
			end
			if (v14:AffectingCombat() or ((3344 - (200 + 118)) >= (1604 + 2442))) then
				local v240 = 0 - 0;
				while true do
					if (((2978 - 970) > (567 + 71)) and (v240 == (0 + 0))) then
						v33 = v141();
						if (((953 + 822) <= (517 + 2716)) and v33) then
							return v33;
						end
						break;
					end
				end
			else
				v33 = v140();
				if (v33 or ((9842 - 5299) == (3247 - (363 + 887)))) then
					return v33;
				end
			end
		end
	end
	local function v146()
		v102.FlameShockDebuff:RegisterAuraTracking();
		v122();
		v21.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(459 - 196, v145, v146);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

