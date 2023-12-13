local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 777 - (314 + 463);
	local v6;
	while true do
		if ((v5 == (678 - (356 + 322))) or ((10126 - 6801) > (434 + 3037))) then
			v6 = v0[v4];
			if (((4930 - 1697) == (4477 - (485 + 759))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
		if (((2653 - (442 + 747)) <= (5512 - (832 + 303))) and (v5 == (947 - (88 + 858)))) then
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
	local v17 = v10.Spell;
	local v18 = v10.MultiSpell;
	local v19 = v10.Item;
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
	local v101 = v17.Shaman.Enhancement;
	local v102 = v19.Shaman.Enhancement;
	local v103 = v22.Shaman.Enhancement;
	local v104 = {};
	local v105, v106;
	local v107, v108;
	local v109, v110, v111, v112;
	local v113 = (v101.LavaBurst:IsAvailable() and (1 + 1)) or (1 + 0);
	local v114 = "Lightning Bolt";
	local v115 = 458 + 10653;
	local v116 = 11900 - (766 + 23);
	local v117 = v20.Commons.Everyone;
	v20.Commons.Shaman = {};
	local v119 = v20.Commons.Shaman;
	v119.LastSKCast = 0 - 0;
	v119.LastSKBuff = 0 - 0;
	v119.LastT302pcBuff = 0 - 0;
	v119.FeralSpiritCount = 0 - 0;
	v10:RegisterForEvent(function()
		v113 = (v101.LavaBurst:IsAvailable() and (1075 - (1036 + 37))) or (1 + 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		v114 = "Lightning Bolt";
		v115 = 21637 - 10526;
		v116 = 8741 + 2370;
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForSelfCombatEvent(function(...)
		local v149 = 1480 - (641 + 839);
		local v150;
		local v151;
		local v152;
		while true do
			if (((3602 - (910 + 3)) < (12040 - 7317)) and (v149 == (1684 - (1466 + 218)))) then
				v150, v151, v151, v151, v151, v151, v151, v151, v152 = select(2 + 2, ...);
				if (((5284 - (556 + 592)) >= (853 + 1544)) and (v150 == v14:GUID()) and (v152 == (192442 - (329 + 479)))) then
					v119.LastSKCast = v30();
				end
				v149 = 855 - (174 + 680);
			end
			if ((v149 == (3 - 2)) or ((8983 - 4649) == (3031 + 1214))) then
				if ((v14:HasTier(770 - (396 + 343), 1 + 1) and (v150 == v14:GUID()) and (v152 == (377459 - (29 + 1448)))) or ((5665 - (135 + 1254)) <= (11418 - 8387))) then
					v119.FeralSpiritCount = v119.FeralSpiritCount + (4 - 3);
					v31.After(10 + 5, function()
						v119.FeralSpiritCount = v119.FeralSpiritCount - (1528 - (389 + 1138));
					end);
				end
				if (((v150 == v14:GUID()) and (v152 == (52107 - (102 + 472)))) or ((4513 + 269) <= (665 + 534))) then
					v119.FeralSpiritCount = v119.FeralSpiritCount + 2 + 0;
					v31.After(1560 - (320 + 1225), function()
						v119.FeralSpiritCount = v119.FeralSpiritCount - (2 - 0);
					end);
				end
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v10:RegisterForSelfCombatEvent(function(...)
		local v153 = 0 + 0;
		local v154;
		local v155;
		local v156;
		while true do
			if ((v153 == (1464 - (157 + 1307))) or ((6723 - (821 + 1038)) < (4745 - 2843))) then
				v154, v155, v155, v155, v156 = select(1 + 7, ...);
				if (((8594 - 3755) >= (1377 + 2323)) and (v154 == v14:GUID()) and (v156 == (474978 - 283344))) then
					v119.LastSKBuff = v30();
					v31.After(1026.1 - (834 + 192), function()
						if ((v119.LastSKBuff ~= v119.LastSKCast) or ((69 + 1006) > (493 + 1425))) then
							v119.LastT302pcBuff = v119.LastSKBuff;
						end
					end);
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED");
	local function v124()
		if (((9 + 387) <= (5892 - 2088)) and v101.CleanseSpirit:IsAvailable()) then
			v117.DispellableDebuffs = v117.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v124();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v125()
		for v215 = 305 - (300 + 4), 2 + 4, 2 - 1 do
			if (v29(v14:TotemName(v215), "Totem") or ((4531 - (112 + 250)) == (872 + 1315))) then
				return v215;
			end
		end
	end
	local function v126()
		local v157 = 0 - 0;
		local v158;
		while true do
			if (((806 + 600) == (728 + 678)) and (v157 == (1 + 0))) then
				if (((760 + 771) < (3173 + 1098)) and ((v158 > (1422 - (1001 + 413))) or (v158 > v101.FeralSpirit:TimeSinceLastCast()))) then
					return 0 - 0;
				end
				return (890 - (244 + 638)) - v158;
			end
			if (((1328 - (627 + 66)) == (1892 - 1257)) and (v157 == (602 - (512 + 90)))) then
				if (((5279 - (1665 + 241)) <= (4273 - (373 + 344))) and (not v101.AlphaWolf:IsAvailable() or v14:BuffDown(v101.FeralSpiritBuff))) then
					return 0 + 0;
				end
				v158 = v28(v101.CrashLightning:TimeSinceLastCast(), v101.ChainLightning:TimeSinceLastCast());
				v157 = 1 + 0;
			end
		end
	end
	local function v127(v159)
		return (v159:DebuffRefreshable(v101.FlameShockDebuff));
	end
	local function v128(v160)
		return (v160:DebuffRefreshable(v101.LashingFlamesDebuff));
	end
	local function v129(v161)
		return (v161:DebuffRemains(v101.FlameShockDebuff));
	end
	local function v130(v162)
		return (v14:BuffDown(v101.PrimordialWaveBuff));
	end
	local function v131(v163)
		return (v15:DebuffRemains(v101.LashingFlamesDebuff));
	end
	local function v132(v164)
		return (v101.LashingFlames:IsAvailable());
	end
	local function v133(v165)
		return v165:DebuffUp(v101.FlameShockDebuff) and (v101.FlameShockDebuff:AuraActiveCount() < v111) and (v101.FlameShockDebuff:AuraActiveCount() < (15 - 9));
	end
	local function v134()
		if ((v101.CleanseSpirit:IsReady() and v37 and v117.DispellableFriendlyUnit(41 - 16)) or ((4390 - (35 + 1064)) < (2387 + 893))) then
			if (((9383 - 4997) >= (4 + 869)) and v23(v103.CleanseSpiritFocus)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v135()
		if (((2157 - (298 + 938)) <= (2361 - (233 + 1026))) and (not v16 or not v16:Exists() or not v16:IsInRange(1706 - (636 + 1030)))) then
			return;
		end
		if (((2407 + 2299) >= (941 + 22)) and v16) then
			if (((v16:HealthPercentage() <= v82) and v72 and v101.HealingSurge:IsReady() and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (2 + 3))) or ((65 + 895) <= (1097 - (55 + 166)))) then
				if (v23(v103.HealingSurgeFocus) or ((401 + 1665) == (94 + 838))) then
					return "healing_surge heal focus";
				end
			end
		end
	end
	local function v136()
		if (((18426 - 13601) < (5140 - (36 + 261))) and (v14:HealthPercentage() <= v86)) then
			if (v101.HealingSurge:IsReady() or ((6780 - 2903) >= (5905 - (34 + 1334)))) then
				if (v23(v101.HealingSurge) or ((1659 + 2656) < (1342 + 384))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v137()
		local v166 = 1283 - (1035 + 248);
		while true do
			if ((v166 == (23 - (20 + 1))) or ((1917 + 1762) < (944 - (134 + 185)))) then
				if ((v102.Healthstone:IsReady() and v73 and (v14:HealthPercentage() <= v83)) or ((5758 - (549 + 584)) < (1317 - (314 + 371)))) then
					if (v23(v103.Healthstone) or ((284 - 201) > (2748 - (478 + 490)))) then
						return "healthstone defensive 3";
					end
				end
				if (((290 + 256) <= (2249 - (786 + 386))) and v74 and (v14:HealthPercentage() <= v84)) then
					if ((v95 == "Refreshing Healing Potion") or ((3225 - 2229) > (5680 - (1055 + 324)))) then
						if (((5410 - (1093 + 247)) > (611 + 76)) and v102.RefreshingHealingPotion:IsReady()) then
							if (v23(v103.RefreshingHealingPotion) or ((69 + 587) >= (13220 - 9890))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v95 == "Dreamwalker's Healing Potion") or ((8457 - 5965) <= (953 - 618))) then
						if (((10860 - 6538) >= (912 + 1650)) and v102.DreamwalkersHealingPotion:IsReady()) then
							if (v23(v103.RefreshingHealingPotion) or ((14011 - 10374) >= (12994 - 9224))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if ((v166 == (1 + 0)) or ((6083 - 3704) > (5266 - (364 + 324)))) then
				if ((v101.HealingStreamTotem:IsReady() and v71 and v117.AreUnitsBelowHealthPercentage(v80, v81)) or ((1323 - 840) > (1782 - 1039))) then
					if (((814 + 1640) > (2418 - 1840)) and v23(v101.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if (((1489 - 559) < (13539 - 9081)) and v101.HealingSurge:IsReady() and v72 and (v14:HealthPercentage() <= v82) and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (1273 - (1249 + 19)))) then
					if (((598 + 64) <= (3783 - 2811)) and v23(v101.HealingSurge)) then
						return "healing_surge defensive 4";
					end
				end
				v166 = 1088 - (686 + 400);
			end
			if (((3429 + 941) == (4599 - (73 + 156))) and (v166 == (0 + 0))) then
				if ((v101.AstralShift:IsReady() and v69 and (v14:HealthPercentage() <= v77)) or ((5573 - (721 + 90)) <= (10 + 851))) then
					if (v23(v101.AstralShift) or ((4584 - 3172) == (4734 - (224 + 246)))) then
						return "astral_shift defensive 1";
					end
				end
				if ((v101.AncestralGuidance:IsReady() and v70 and v117.AreUnitsBelowHealthPercentage(v78, v79)) or ((5131 - 1963) < (3963 - 1810))) then
					if (v23(v101.AncestralGuidance) or ((903 + 4073) < (32 + 1300))) then
						return "ancestral_guidance defensive 2";
					end
				end
				v166 = 1 + 0;
			end
		end
	end
	local function v138()
		v32 = v117.HandleTopTrinket(v104, v35, 79 - 39, nil);
		if (((15400 - 10772) == (5141 - (203 + 310))) and v32) then
			return v32;
		end
		v32 = v117.HandleBottomTrinket(v104, v35, 2033 - (1238 + 755), nil);
		if (v32 or ((4 + 50) == (1929 - (709 + 825)))) then
			return v32;
		end
	end
	local function v139()
		if (((150 - 68) == (118 - 36)) and v101.WindfuryTotem:IsReady() and v51 and (v14:BuffDown(v101.WindfuryTotemBuff, true) or (v101.WindfuryTotem:TimeSinceLastCast() > (954 - (196 + 668))))) then
			if (v23(v101.WindfuryTotem) or ((2293 - 1712) < (583 - 301))) then
				return "windfury_totem precombat 4";
			end
		end
		if ((v101.FeralSpirit:IsCastable() and v55 and ((v60 and v35) or not v60)) or ((5442 - (171 + 662)) < (2588 - (4 + 89)))) then
			if (((4037 - 2885) == (420 + 732)) and v23(v101.FeralSpirit)) then
				return "feral_spirit precombat 6";
			end
		end
		if (((8327 - 6431) <= (1342 + 2080)) and v101.DoomWinds:IsCastable() and v56 and ((v61 and v35) or not v61)) then
			if (v23(v101.DoomWinds, not v15:IsSpellInRange(v101.DoomWinds)) or ((2476 - (35 + 1451)) > (3073 - (28 + 1425)))) then
				return "doom_winds precombat 8";
			end
		end
		if ((v101.Sundering:IsReady() and v50 and ((v62 and v36) or not v62)) or ((2870 - (941 + 1052)) > (4502 + 193))) then
			if (((4205 - (822 + 692)) >= (2642 - 791)) and v23(v101.Sundering, not v15:IsInRange(3 + 2))) then
				return "sundering precombat 10";
			end
		end
		if ((v101.Stormstrike:IsReady() and v49) or ((3282 - (45 + 252)) >= (4805 + 51))) then
			if (((1472 + 2804) >= (2908 - 1713)) and v23(v101.Stormstrike, not v15:IsSpellInRange(v101.Stormstrike))) then
				return "stormstrike precombat 12";
			end
		end
	end
	local function v140()
		local v167 = 433 - (114 + 319);
		while true do
			if (((4639 - 1407) <= (6009 - 1319)) and (v167 == (6 + 2))) then
				if ((v101.FlameShock:IsReady() and v42) or ((1334 - 438) >= (6591 - 3445))) then
					if (((5024 - (556 + 1407)) >= (4164 - (741 + 465))) and v23(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock single 34";
					end
				end
				if (((3652 - (170 + 295)) >= (340 + 304)) and v101.ChainLightning:IsReady() and v38 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (5 + 0)) and v14:BuffUp(v101.CracklingThunderBuff) and v101.ElementalSpirits:IsAvailable()) then
					if (((1585 - 941) <= (584 + 120)) and v23(v101.ChainLightning, not v15:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning single 35";
					end
				end
				if (((615 + 343) > (537 + 410)) and v101.LightningBolt:IsReady() and v47 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (1235 - (957 + 273))) and v14:BuffDown(v101.PrimordialWaveBuff)) then
					if (((1202 + 3290) >= (1063 + 1591)) and v23(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt))) then
						return "lightning_bolt single 36";
					end
				end
				if (((13115 - 9673) >= (3960 - 2457)) and v101.WindfuryTotem:IsReady() and v51 and (v14:BuffDown(v101.WindfuryTotemBuff, true) or (v101.WindfuryTotem:TimeSinceLastCast() > (274 - 184)))) then
					if (v23(v101.WindfuryTotem) or ((15696 - 12526) <= (3244 - (389 + 1391)))) then
						return "windfury_totem single 37";
					end
				end
				break;
			end
			if ((v167 == (4 + 2)) or ((500 + 4297) == (9989 - 5601))) then
				if (((1502 - (783 + 168)) <= (2285 - 1604)) and v101.Stormstrike:IsReady() and v49) then
					if (((3224 + 53) > (718 - (309 + 2))) and v23(v101.Stormstrike, not v15:IsSpellInRange(v101.Stormstrike))) then
						return "stormstrike single 25";
					end
				end
				if (((14417 - 9722) >= (2627 - (1090 + 122))) and v101.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v116)) then
					if (v23(v101.Sundering, not v15:IsInRange(3 + 5)) or ((10787 - 7575) <= (647 + 297))) then
						return "sundering single 26";
					end
				end
				if ((v101.BagofTricks:IsReady() and v58 and ((v65 and v35) or not v65)) or ((4214 - (628 + 490)) <= (323 + 1475))) then
					if (((8756 - 5219) == (16164 - 12627)) and v23(v101.BagofTricks)) then
						return "bag_of_tricks single 27";
					end
				end
				if (((4611 - (431 + 343)) >= (3170 - 1600)) and v101.FireNova:IsReady() and v41 and v101.SwirlingMaelstrom:IsAvailable() and v15:DebuffUp(v101.FlameShockDebuff) and (v14:BuffStack(v101.MaelstromWeaponBuff) < ((14 - 9) + ((4 + 1) * v24(v101.OverflowingMaelstrom:IsAvailable()))))) then
					if (v23(v101.FireNova) or ((378 + 2572) == (5507 - (556 + 1139)))) then
						return "fire_nova single 28";
					end
				end
				v167 = 22 - (6 + 9);
			end
			if (((865 + 3858) >= (1188 + 1130)) and ((176 - (28 + 141)) == v167)) then
				if ((v101.LightningBolt:IsReady() and v47 and v101.Hailstorm:IsAvailable() and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (2 + 3)) and v14:BuffDown(v101.PrimordialWaveBuff)) or ((2501 - 474) > (2020 + 832))) then
					if (v23(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt)) or ((2453 - (486 + 831)) > (11233 - 6916))) then
						return "lightning_bolt single 29";
					end
				end
				if (((16715 - 11967) == (898 + 3850)) and v101.FrostShock:IsReady() and v43) then
					if (((11812 - 8076) <= (6003 - (668 + 595))) and v23(v101.FrostShock, not v15:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single 30";
					end
				end
				if ((v101.CrashLightning:IsReady() and v39) or ((3051 + 339) <= (617 + 2443))) then
					if (v23(v101.CrashLightning, not v15:IsInMeleeRange(21 - 13)) or ((1289 - (23 + 267)) > (4637 - (1129 + 815)))) then
						return "crash_lightning single 31";
					end
				end
				if (((850 - (371 + 16)) < (2351 - (1326 + 424))) and v101.FireNova:IsReady() and v41 and (v15:DebuffUp(v101.FlameShockDebuff))) then
					if (v23(v101.FireNova) or ((4133 - 1950) < (2510 - 1823))) then
						return "fire_nova single 32";
					end
				end
				v167 = 126 - (88 + 30);
			end
			if (((5320 - (720 + 51)) == (10118 - 5569)) and (v167 == (1779 - (421 + 1355)))) then
				if (((7706 - 3034) == (2295 + 2377)) and v101.LavaBurst:IsReady() and v45 and not v101.ThorimsInvocation:IsAvailable() and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (1088 - (286 + 797)))) then
					if (v23(v101.LavaBurst, not v15:IsSpellInRange(v101.LavaBurst)) or ((13408 - 9740) < (653 - 258))) then
						return "lava_burst single 13";
					end
				end
				if ((v101.LightningBolt:IsReady() and v47 and ((v14:BuffStack(v101.MaelstromWeaponBuff) >= (447 - (397 + 42))) or (v101.StaticAccumulation:IsAvailable() and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (2 + 3)))) and v14:BuffDown(v101.PrimordialWaveBuff)) or ((4966 - (24 + 776)) == (700 - 245))) then
					if (v23(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt)) or ((5234 - (222 + 563)) == (5867 - 3204))) then
						return "lightning_bolt single 14";
					end
				end
				if ((v101.CrashLightning:IsReady() and v39 and v101.AlphaWolf:IsAvailable() and v14:BuffUp(v101.FeralSpiritBuff) and (v126() == (0 + 0))) or ((4467 - (23 + 167)) < (4787 - (690 + 1108)))) then
					if (v23(v101.CrashLightning, not v15:IsInMeleeRange(3 + 5)) or ((718 + 152) >= (4997 - (40 + 808)))) then
						return "crash_lightning single 15";
					end
				end
				if (((365 + 1847) < (12171 - 8988)) and v101.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v116)) then
					if (((4441 + 205) > (1583 + 1409)) and v23(v101.PrimordialWave, not v15:IsSpellInRange(v101.PrimordialWave))) then
						return "primordial_wave single 16";
					end
				end
				v167 = 3 + 1;
			end
			if (((2005 - (47 + 524)) < (2016 + 1090)) and (v167 == (5 - 3))) then
				if (((1174 - 388) < (6894 - 3871)) and v101.ElementalBlast:IsReady() and v40 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (1731 - (1165 + 561))) and (v101.ElementalBlast:Charges() == v113)) then
					if (v23(v101.ElementalBlast, not v15:IsSpellInRange(v101.ElementalBlast)) or ((73 + 2369) < (228 - 154))) then
						return "elemental_blast single 9";
					end
				end
				if (((1731 + 2804) == (5014 - (341 + 138))) and v101.LightningBolt:IsReady() and v47 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (3 + 5)) and v14:BuffUp(v101.PrimordialWaveBuff) and (v14:BuffDown(v101.SplinteredElementsBuff) or (v116 <= (24 - 12)))) then
					if (v23(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt)) or ((3335 - (89 + 237)) <= (6771 - 4666))) then
						return "lightning_bolt single 10";
					end
				end
				if (((3852 - 2022) < (4550 - (581 + 300))) and v101.ChainLightning:IsReady() and v38 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (1228 - (855 + 365))) and v14:BuffUp(v101.CracklingThunderBuff) and v101.ElementalSpirits:IsAvailable()) then
					if (v23(v101.ChainLightning, not v15:IsSpellInRange(v101.ChainLightning)) or ((3396 - 1966) >= (1180 + 2432))) then
						return "chain_lightning single 11";
					end
				end
				if (((3918 - (1030 + 205)) >= (2310 + 150)) and v101.ElementalBlast:IsReady() and v40 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (8 + 0)) and ((v119.FeralSpiritCount >= (288 - (156 + 130))) or not v101.ElementalSpirits:IsAvailable())) then
					if (v23(v101.ElementalBlast, not v15:IsSpellInRange(v101.ElementalBlast)) or ((4098 - 2294) >= (5519 - 2244))) then
						return "elemental_blast single 12";
					end
				end
				v167 = 5 - 2;
			end
			if (((1 + 0) == v167) or ((827 + 590) > (3698 - (10 + 59)))) then
				if (((1357 + 3438) > (1979 - 1577)) and v101.LightningBolt:IsReady() and v47 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (1168 - (671 + 492))) and v14:BuffDown(v101.CracklingThunderBuff) and v14:BuffUp(v101.AscendanceBuff) and (v114 == "Chain Lightning") and (v14:BuffRemains(v101.AscendanceBuff) > (v101.ChainLightning:CooldownRemains() + v14:GCD()))) then
					if (((3832 + 981) > (4780 - (369 + 846))) and v23(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt))) then
						return "lightning_bolt single 5";
					end
				end
				if (((1036 + 2876) == (3339 + 573)) and v101.Stormstrike:IsReady() and v49 and (v14:BuffUp(v101.DoomWindsBuff) or v101.DeeplyRootedElements:IsAvailable() or (v101.Stormblast:IsAvailable() and v14:BuffUp(v101.StormbringerBuff)))) then
					if (((4766 - (1036 + 909)) <= (3836 + 988)) and v23(v101.Stormstrike, not v15:IsSpellInRange(v101.Stormstrike))) then
						return "stormstrike single 6";
					end
				end
				if (((2917 - 1179) <= (2398 - (11 + 192))) and v101.LavaLash:IsReady() and v46 and (v14:BuffUp(v101.HotHandBuff))) then
					if (((21 + 20) <= (3193 - (135 + 40))) and v23(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash))) then
						return "lava_lash single 7";
					end
				end
				if (((5196 - 3051) <= (2474 + 1630)) and v101.WindfuryTotem:IsReady() and v51 and (v14:BuffDown(v101.WindfuryTotemBuff, true))) then
					if (((5923 - 3234) < (7263 - 2418)) and v23(v101.WindfuryTotem)) then
						return "windfury_totem single 8";
					end
				end
				v167 = 178 - (50 + 126);
			end
			if ((v167 == (13 - 8)) or ((514 + 1808) > (4035 - (1233 + 180)))) then
				if ((v101.FrostShock:IsReady() and v43 and (v14:BuffUp(v101.HailstormBuff))) or ((5503 - (522 + 447)) == (3503 - (107 + 1314)))) then
					if (v23(v101.FrostShock, not v15:IsSpellInRange(v101.FrostShock)) or ((730 + 841) > (5688 - 3821))) then
						return "frost_shock single 21";
					end
				end
				if ((v101.LavaLash:IsReady() and v46) or ((1128 + 1526) >= (5949 - 2953))) then
					if (((15739 - 11761) > (4014 - (716 + 1194))) and v23(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash))) then
						return "lava_lash single 22";
					end
				end
				if (((52 + 2943) > (166 + 1375)) and v101.IceStrike:IsReady() and v44) then
					if (((3752 - (74 + 429)) > (1837 - 884)) and v23(v101.IceStrike, not v15:IsInMeleeRange(3 + 2))) then
						return "ice_strike single 23";
					end
				end
				if ((v101.Windstrike:IsCastable() and v52) or ((7492 - 4219) > (3236 + 1337))) then
					if (v23(v101.Windstrike, not v15:IsSpellInRange(v101.Windstrike)) or ((9714 - 6563) < (3174 - 1890))) then
						return "windstrike single 24";
					end
				end
				v167 = 439 - (279 + 154);
			end
			if ((v167 == (782 - (454 + 324))) or ((1456 + 394) == (1546 - (12 + 5)))) then
				if (((443 + 378) < (5409 - 3286)) and v101.FlameShock:IsReady() and v42 and (v15:DebuffDown(v101.FlameShockDebuff))) then
					if (((334 + 568) < (3418 - (277 + 816))) and v23(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock single 17";
					end
				end
				if (((3666 - 2808) <= (4145 - (1058 + 125))) and v101.IceStrike:IsReady() and v44 and v101.ElementalAssault:IsAvailable() and v101.SwirlingMaelstrom:IsAvailable()) then
					if (v23(v101.IceStrike, not v15:IsInMeleeRange(1 + 4)) or ((4921 - (815 + 160)) < (5526 - 4238))) then
						return "ice_strike single 18";
					end
				end
				if ((v101.LavaLash:IsReady() and v46 and (v101.LashingFlames:IsAvailable())) or ((7695 - 4453) == (136 + 431))) then
					if (v23(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash)) or ((2475 - 1628) >= (3161 - (41 + 1857)))) then
						return "lava_lash single 19";
					end
				end
				if ((v101.IceStrike:IsReady() and v44 and (v14:BuffDown(v101.IceStrikeBuff))) or ((4146 - (1222 + 671)) == (4783 - 2932))) then
					if (v23(v101.IceStrike, not v15:IsInMeleeRange(6 - 1)) or ((3269 - (229 + 953)) > (4146 - (1111 + 663)))) then
						return "ice_strike single 20";
					end
				end
				v167 = 1584 - (874 + 705);
			end
			if ((v167 == (0 + 0)) or ((3033 + 1412) < (8623 - 4474))) then
				if ((v101.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v116) and v15:DebuffDown(v101.FlameShockDebuff) and v101.LashingFlames:IsAvailable()) or ((52 + 1766) == (764 - (642 + 37)))) then
					if (((144 + 486) < (341 + 1786)) and v23(v101.PrimordialWave, not v15:IsSpellInRange(v101.PrimordialWave))) then
						return "primordial_wave single 1";
					end
				end
				if ((v101.FlameShock:IsReady() and v42 and v15:DebuffDown(v101.FlameShockDebuff) and v101.LashingFlames:IsAvailable()) or ((4865 - 2927) == (2968 - (233 + 221)))) then
					if (((9839 - 5584) >= (49 + 6)) and v23(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock single 2";
					end
				end
				if (((4540 - (718 + 823)) > (728 + 428)) and v101.ElementalBlast:IsReady() and v40 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (810 - (266 + 539))) and v101.ElementalSpirits:IsAvailable() and (v119.FeralSpiritCount >= (11 - 7))) then
					if (((3575 - (636 + 589)) > (2741 - 1586)) and v23(v101.ElementalBlast, not v15:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast single 3";
					end
				end
				if (((8309 - 4280) <= (3846 + 1007)) and v101.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v116) and (v14:HasTier(11 + 19, 1017 - (657 + 358)))) then
					if (v23(v101.Sundering, not v15:IsInRange(21 - 13)) or ((1175 - 659) > (4621 - (1151 + 36)))) then
						return "sundering single 4";
					end
				end
				v167 = 1 + 0;
			end
		end
	end
	local function v141()
		local v168 = 0 + 0;
		while true do
			if (((12082 - 8036) >= (4865 - (1552 + 280))) and (v168 == (834 - (64 + 770)))) then
				if ((v101.CrashLightning:IsReady() and v39 and v101.CrashingStorms:IsAvailable() and ((v101.UnrulyWinds:IsAvailable() and (v111 >= (7 + 3))) or (v111 >= (34 - 19)))) or ((483 + 2236) <= (2690 - (157 + 1086)))) then
					if (v23(v101.CrashLightning, not v15:IsInMeleeRange(15 - 7)) or ((18105 - 13971) < (6021 - 2095))) then
						return "crash_lightning aoe 1";
					end
				end
				if ((v101.LightningBolt:IsReady() and v47 and ((v101.FlameShockDebuff:AuraActiveCount() >= v111) or (v14:BuffRemains(v101.PrimordialWaveBuff) < (v14:GCD() * (3 - 0))) or (v101.FlameShockDebuff:AuraActiveCount() >= (825 - (599 + 220)))) and v14:BuffUp(v101.PrimordialWaveBuff) and (v14:BuffStack(v101.MaelstromWeaponBuff) == ((9 - 4) + ((1936 - (1813 + 118)) * v24(v101.OverflowingMaelstrom:IsAvailable())))) and (v14:BuffDown(v101.SplinteredElementsBuff) or (v116 <= (9 + 3)) or (v99 <= v14:GCD()))) or ((1381 - (841 + 376)) >= (3901 - 1116))) then
					if (v23(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt)) or ((122 + 403) == (5756 - 3647))) then
						return "lightning_bolt aoe 2";
					end
				end
				if (((892 - (464 + 395)) == (84 - 51)) and v101.LavaLash:IsReady() and v46 and v101.MoltenAssault:IsAvailable() and (v101.PrimordialWave:IsAvailable() or v101.FireNova:IsAvailable()) and v15:DebuffUp(v101.FlameShockDebuff) and (v101.FlameShockDebuff:AuraActiveCount() < v111) and (v101.FlameShockDebuff:AuraActiveCount() < (3 + 3))) then
					if (((3891 - (467 + 370)) <= (8296 - 4281)) and v23(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash))) then
						return "lava_lash aoe 3";
					end
				end
				if (((1374 + 497) < (11593 - 8211)) and v101.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v116) and (v14:BuffDown(v101.PrimordialWaveBuff))) then
					local v239 = 0 + 0;
					while true do
						if (((3007 - 1714) <= (2686 - (150 + 370))) and (v239 == (1282 - (74 + 1208)))) then
							if (v117.CastCycle(v101.PrimordialWave, v110, v127, not v15:IsSpellInRange(v101.PrimordialWave)) or ((6342 - 3763) < (583 - 460))) then
								return "primordial_wave aoe 4";
							end
							if (v23(v101.PrimordialWave, not v15:IsSpellInRange(v101.PrimordialWave)) or ((602 + 244) >= (2758 - (14 + 376)))) then
								return "primordial_wave aoe no_cycle 4";
							end
							break;
						end
					end
				end
				if ((v101.FlameShock:IsReady() and v42 and (v101.PrimordialWave:IsAvailable() or v101.FireNova:IsAvailable()) and v15:DebuffDown(v101.FlameShockDebuff)) or ((6958 - 2946) <= (2173 + 1185))) then
					if (((1313 + 181) <= (2866 + 139)) and v23(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock aoe 5";
					end
				end
				if ((v101.ElementalBlast:IsReady() and v40 and (not v101.ElementalSpirits:IsAvailable() or (v101.ElementalSpirits:IsAvailable() and ((v101.ElementalBlast:Charges() == v113) or (v119.FeralSpiritCount >= (5 - 3))))) and (v14:BuffStack(v101.MaelstromWeaponBuff) == (4 + 1 + ((83 - (23 + 55)) * v24(v101.OverflowingMaelstrom:IsAvailable())))) and (not v101.CrashingStorms:IsAvailable() or (v111 <= (6 - 3)))) or ((2076 + 1035) == (1917 + 217))) then
					if (((3651 - 1296) == (741 + 1614)) and v23(v101.ElementalBlast, not v15:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast aoe 6";
					end
				end
				v168 = 902 - (652 + 249);
			end
			if ((v168 == (7 - 4)) or ((2456 - (708 + 1160)) <= (1172 - 740))) then
				if (((8745 - 3948) >= (3922 - (10 + 17))) and v101.Stormstrike:IsReady() and v49 and v14:BuffUp(v101.CrashLightningBuff) and (v101.DeeplyRootedElements:IsAvailable() or (v14:BuffStack(v101.ConvergingStormsBuff) == (2 + 4)))) then
					if (((5309 - (1400 + 332)) == (6860 - 3283)) and v23(v101.Stormstrike, not v15:IsSpellInRange(v101.Stormstrike))) then
						return "stormstrike aoe 19";
					end
				end
				if (((5702 - (242 + 1666)) > (1581 + 2112)) and v101.CrashLightning:IsReady() and v39 and v101.CrashingStorms:IsAvailable() and v14:BuffUp(v101.CLCrashLightningBuff) and (v111 >= (2 + 2))) then
					if (v23(v101.CrashLightning, not v15:IsInMeleeRange(7 + 1)) or ((2215 - (850 + 90)) == (7181 - 3081))) then
						return "crash_lightning aoe 20";
					end
				end
				if ((v101.Windstrike:IsCastable() and v52) or ((2981 - (360 + 1030)) >= (3169 + 411))) then
					if (((2774 - 1791) <= (2487 - 679)) and v23(v101.Windstrike, not v15:IsSpellInRange(v101.Windstrike))) then
						return "windstrike aoe 21";
					end
				end
				if ((v101.Stormstrike:IsReady() and v49) or ((3811 - (909 + 752)) <= (2420 - (109 + 1114)))) then
					if (((6899 - 3130) >= (457 + 716)) and v23(v101.Stormstrike, not v15:IsSpellInRange(v101.Stormstrike))) then
						return "stormstrike aoe 22";
					end
				end
				if (((1727 - (6 + 236)) == (936 + 549)) and v101.IceStrike:IsReady() and v44) then
					if (v23(v101.IceStrike, not v15:IsInMeleeRange(5 + 0)) or ((7818 - 4503) <= (4859 - 2077))) then
						return "ice_strike aoe 23";
					end
				end
				if ((v101.LavaLash:IsReady() and v46) or ((2009 - (1076 + 57)) >= (488 + 2476))) then
					if (v23(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash)) or ((2921 - (579 + 110)) > (198 + 2299))) then
						return "lava_lash aoe 24";
					end
				end
				v168 = 4 + 0;
			end
			if ((v168 == (3 + 1)) or ((2517 - (174 + 233)) <= (927 - 595))) then
				if (((6469 - 2783) > (1411 + 1761)) and v101.CrashLightning:IsReady() and v39) then
					if (v23(v101.CrashLightning, not v15:IsInMeleeRange(1182 - (663 + 511))) or ((3992 + 482) < (179 + 641))) then
						return "crash_lightning aoe 25";
					end
				end
				if (((13191 - 8912) >= (1746 + 1136)) and v101.FireNova:IsReady() and v41 and (v101.FlameShockDebuff:AuraActiveCount() >= (4 - 2))) then
					if (v23(v101.FireNova) or ((4911 - 2882) >= (1681 + 1840))) then
						return "fire_nova aoe 26";
					end
				end
				if ((v101.ElementalBlast:IsReady() and v40 and (not v101.ElementalSpirits:IsAvailable() or (v101.ElementalSpirits:IsAvailable() and ((v101.ElementalBlast:Charges() == v113) or (v119.FeralSpiritCount >= (3 - 1))))) and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (4 + 1)) and (not v101.CrashingStorms:IsAvailable() or (v111 <= (1 + 2)))) or ((2759 - (478 + 244)) >= (5159 - (440 + 77)))) then
					if (((783 + 937) < (16316 - 11858)) and v23(v101.ElementalBlast, not v15:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast aoe 27";
					end
				end
				if ((v101.ChainLightning:IsReady() and v38 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (1561 - (655 + 901)))) or ((81 + 355) > (2313 + 708))) then
					if (((482 + 231) <= (3412 - 2565)) and v23(v101.ChainLightning, not v15:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning aoe 28";
					end
				end
				if (((3599 - (695 + 750)) <= (13764 - 9733)) and v101.WindfuryTotem:IsReady() and v51 and (v14:BuffDown(v101.WindfuryTotemBuff, true) or (v101.WindfuryTotem:TimeSinceLastCast() > (138 - 48)))) then
					if (((18560 - 13945) == (4966 - (285 + 66))) and v23(v101.WindfuryTotem)) then
						return "windfury_totem aoe 29";
					end
				end
				if ((v101.FlameShock:IsReady() and v42 and (v15:DebuffDown(v101.FlameShockDebuff))) or ((8834 - 5044) == (1810 - (682 + 628)))) then
					if (((15 + 74) < (520 - (176 + 123))) and v23(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock aoe 30";
					end
				end
				v168 = 3 + 2;
			end
			if (((1490 + 564) >= (1690 - (239 + 30))) and (v168 == (1 + 0))) then
				if (((666 + 26) < (5412 - 2354)) and v101.ChainLightning:IsReady() and v38 and (v14:BuffStack(v101.MaelstromWeaponBuff) == ((15 - 10) + ((320 - (306 + 9)) * v24(v101.OverflowingMaelstrom:IsAvailable()))))) then
					if (v23(v101.ChainLightning, not v15:IsSpellInRange(v101.ChainLightning)) or ((11355 - 8101) == (288 + 1367))) then
						return "chain_lightning aoe 7";
					end
				end
				if ((v101.CrashLightning:IsReady() and v39 and (v14:BuffUp(v101.DoomWindsBuff) or v14:BuffDown(v101.CrashLightningBuff) or (v101.AlphaWolf:IsAvailable() and v14:BuffUp(v101.FeralSpiritBuff) and (v126() == (0 + 0))))) or ((624 + 672) == (14040 - 9130))) then
					if (((4743 - (1140 + 235)) == (2144 + 1224)) and v23(v101.CrashLightning, not v15:IsInMeleeRange(8 + 0))) then
						return "crash_lightning aoe 8";
					end
				end
				if (((679 + 1964) < (3867 - (33 + 19))) and v101.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v116) and (v14:BuffUp(v101.DoomWindsBuff) or v14:HasTier(11 + 19, 5 - 3))) then
					if (((843 + 1070) > (966 - 473)) and v23(v101.Sundering, not v15:IsInRange(8 + 0))) then
						return "sundering aoe 9";
					end
				end
				if (((5444 - (586 + 103)) > (313 + 3115)) and v101.FireNova:IsReady() and v41 and ((v101.FlameShockDebuff:AuraActiveCount() >= (18 - 12)) or ((v101.FlameShockDebuff:AuraActiveCount() >= (1492 - (1309 + 179))) and (v101.FlameShockDebuff:AuraActiveCount() >= v111)))) then
					if (((2492 - 1111) <= (1032 + 1337)) and v23(v101.FireNova)) then
						return "fire_nova aoe 10";
					end
				end
				if ((v101.LavaLash:IsReady() and v46 and (v101.LashingFlames:IsAvailable())) or ((13006 - 8163) == (3085 + 999))) then
					local v240 = 0 - 0;
					while true do
						if (((9303 - 4634) > (972 - (295 + 314))) and (v240 == (0 - 0))) then
							if (v117.CastCycle(v101.LavaLash, v110, v128, not v15:IsSpellInRange(v101.LavaLash)) or ((3839 - (1300 + 662)) >= (9853 - 6715))) then
								return "lava_lash aoe 11";
							end
							if (((6497 - (1178 + 577)) >= (1884 + 1742)) and v23(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash))) then
								return "lava_lash aoe no_cycle 11";
							end
							break;
						end
					end
				end
				if ((v101.LavaLash:IsReady() and v46 and ((v101.MoltenAssault:IsAvailable() and v15:DebuffUp(v101.FlameShockDebuff) and (v101.FlameShockDebuff:AuraActiveCount() < v111) and (v101.FlameShockDebuff:AuraActiveCount() < (17 - 11))) or (v101.AshenCatalyst:IsAvailable() and (v14:BuffStack(v101.AshenCatalystBuff) == (1410 - (851 + 554)))))) or ((4015 + 525) == (2540 - 1624))) then
					if (v23(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash)) or ((2510 - 1354) > (4647 - (115 + 187)))) then
						return "lava_lash aoe 12";
					end
				end
				v168 = 2 + 0;
			end
			if (((2118 + 119) < (16743 - 12494)) and (v168 == (1166 - (160 + 1001)))) then
				if ((v101.FrostShock:IsReady() and v43 and not v101.Hailstorm:IsAvailable()) or ((2348 + 335) < (16 + 7))) then
					if (((1426 - 729) <= (1184 - (237 + 121))) and v23(v101.FrostShock, not v15:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock aoe 31";
					end
				end
				break;
			end
			if (((2002 - (525 + 372)) <= (2228 - 1052)) and (v168 == (6 - 4))) then
				if (((3521 - (96 + 46)) <= (4589 - (643 + 134))) and v101.IceStrike:IsReady() and v44 and (v101.Hailstorm:IsAvailable())) then
					if (v23(v101.IceStrike, not v15:IsInMeleeRange(2 + 3)) or ((1889 - 1101) >= (5999 - 4383))) then
						return "ice_strike aoe 13";
					end
				end
				if (((1779 + 75) <= (6630 - 3251)) and v101.FrostShock:IsReady() and v43 and v101.Hailstorm:IsAvailable() and v14:BuffUp(v101.HailstormBuff)) then
					if (((9298 - 4749) == (5268 - (316 + 403))) and v23(v101.FrostShock, not v15:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock aoe 14";
					end
				end
				if ((v101.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v116)) or ((2009 + 1013) >= (8314 - 5290))) then
					if (((1742 + 3078) > (5535 - 3337)) and v23(v101.Sundering, not v15:IsInRange(6 + 2))) then
						return "sundering aoe 15";
					end
				end
				if ((v101.FlameShock:IsReady() and v42 and v101.MoltenAssault:IsAvailable() and v15:DebuffDown(v101.FlameShockDebuff)) or ((342 + 719) >= (16947 - 12056))) then
					if (((6514 - 5150) <= (9291 - 4818)) and v23(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock aoe 16";
					end
				end
				if ((v101.FlameShock:IsReady() and v42 and v15:DebuffRefreshable(v101.FlameShockDebuff) and (v101.FireNova:IsAvailable() or v101.PrimordialWave:IsAvailable()) and (v101.FlameShockDebuff:AuraActiveCount() < v111) and (v101.FlameShockDebuff:AuraActiveCount() < (1 + 5))) or ((7077 - 3482) <= (1 + 2))) then
					if (v117.CastCycle(v101.FlameShock, v110, v127, not v15:IsSpellInRange(v101.FlameShock)) or ((13745 - 9073) == (3869 - (12 + 5)))) then
						return "flame_shock aoe 17";
					end
					if (((6054 - 4495) == (3325 - 1766)) and v23(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock aoe no_cycle 17";
					end
				end
				if ((v101.FireNova:IsReady() and v41 and (v101.FlameShockDebuff:AuraActiveCount() >= (6 - 3))) or ((4344 - 2592) <= (160 + 628))) then
					if (v23(v101.FireNova) or ((5880 - (1656 + 317)) == (158 + 19))) then
						return "fire_nova aoe 18";
					end
				end
				v168 = 3 + 0;
			end
		end
	end
	local function v142()
		local v169 = 0 - 0;
		while true do
			if (((17077 - 13607) > (909 - (5 + 349))) and (v169 == (9 - 7))) then
				if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) or ((2243 - (266 + 1005)) == (426 + 219))) then
					if (((10857 - 7675) >= (2784 - 669)) and v23(v101.AncestralSpirit, nil, true)) then
						return "resurrection";
					end
				end
				if (((5589 - (561 + 1135)) < (5771 - 1342)) and v117.TargetIsValid() and v33) then
					if (not v14:AffectingCombat() or ((9423 - 6556) < (2971 - (507 + 559)))) then
						v32 = v139();
						if (v32 or ((4506 - 2710) >= (12528 - 8477))) then
							return v32;
						end
					end
				end
				break;
			end
			if (((2007 - (212 + 176)) <= (4661 - (250 + 655))) and (v169 == (2 - 1))) then
				if (((1054 - 450) == (944 - 340)) and (not v106 or (v108 < (601956 - (1869 + 87)))) and v53 and v101.FlamentongueWeapon:IsCastable()) then
					if (v23(v101.FlamentongueWeapon) or ((15552 - 11068) == (2801 - (484 + 1417)))) then
						return "flametongue_weapon enchant";
					end
				end
				if (v85 or ((9557 - 5098) <= (1864 - 751))) then
					v32 = v136();
					if (((4405 - (48 + 725)) > (5550 - 2152)) and v32) then
						return v32;
					end
				end
				v169 = 5 - 3;
			end
			if (((2373 + 1709) <= (13140 - 8223)) and (v169 == (0 + 0))) then
				if (((1409 + 3423) >= (2239 - (152 + 701))) and v75 and v101.EarthShield:IsCastable() and v14:BuffDown(v101.EarthShieldBuff) and ((v76 == "Earth Shield") or (v101.ElementalOrbit:IsAvailable() and v14:BuffUp(v101.LightningShield)))) then
					if (((1448 - (430 + 881)) == (53 + 84)) and v23(v101.EarthShield)) then
						return "earth_shield main 2";
					end
				elseif ((v75 and v101.LightningShield:IsCastable() and v14:BuffDown(v101.LightningShieldBuff) and ((v76 == "Lightning Shield") or (v101.ElementalOrbit:IsAvailable() and v14:BuffUp(v101.EarthShield)))) or ((2465 - (557 + 338)) >= (1281 + 3051))) then
					if (v23(v101.LightningShield) or ((11452 - 7388) <= (6369 - 4550))) then
						return "lightning_shield main 2";
					end
				end
				if (((not v105 or (v107 < (1594063 - 994063))) and v53 and v101.WindfuryWeapon:IsCastable()) or ((10745 - 5759) < (2375 - (499 + 302)))) then
					if (((5292 - (39 + 827)) > (474 - 302)) and v23(v101.WindfuryWeapon)) then
						return "windfury_weapon enchant";
					end
				end
				v169 = 2 - 1;
			end
		end
	end
	local function v143()
		local v170 = 0 - 0;
		while true do
			if (((898 - 312) > (39 + 416)) and (v170 == (2 - 1))) then
				if (((133 + 693) == (1306 - 480)) and v93) then
					if (v87 or ((4123 - (103 + 1)) > (4995 - (475 + 79)))) then
						local v245 = 0 - 0;
						while true do
							if (((6454 - 4437) < (551 + 3710)) and (v245 == (0 + 0))) then
								v32 = v117.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 1543 - (1395 + 108));
								if (((13723 - 9007) > (1284 - (7 + 1197))) and v32) then
									return v32;
								end
								break;
							end
						end
					end
					if (v88 or ((1530 + 1977) == (1142 + 2130))) then
						local v246 = 319 - (27 + 292);
						while true do
							if ((v246 == (0 - 0)) or ((1116 - 240) >= (12895 - 9820))) then
								v32 = v117.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 59 - 29);
								if (((8288 - 3936) > (2693 - (43 + 96))) and v32) then
									return v32;
								end
								break;
							end
						end
					end
					if (v89 or ((17972 - 13566) < (9140 - 5097))) then
						v32 = v117.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 25 + 5);
						if (v32 or ((534 + 1355) >= (6686 - 3303))) then
							return v32;
						end
					end
					if (((726 + 1166) <= (5123 - 2389)) and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (2 + 3)) and v90) then
						local v247 = 0 + 0;
						while true do
							if (((3674 - (1414 + 337)) < (4158 - (1642 + 298))) and (v247 == (0 - 0))) then
								v32 = v117.HandleAfflicted(v101.HealingSurge, v103.HealingSurgeMouseover, 115 - 75, true);
								if (((6448 - 4275) > (125 + 254)) and v32) then
									return v32;
								end
								break;
							end
						end
					end
				end
				if (v94 or ((2016 + 575) == (4381 - (357 + 615)))) then
					v32 = v117.HandleIncorporeal(v101.Hex, v103.HexMouseOver, 22 + 8, true);
					if (((11075 - 6561) > (2849 + 475)) and v32) then
						return v32;
					end
				end
				v170 = 4 - 2;
			end
			if (((2 + 0) == v170) or ((15 + 193) >= (3035 + 1793))) then
				if (v16 or ((2884 - (384 + 917)) > (4264 - (128 + 569)))) then
					if (v92 or ((2856 - (1407 + 136)) == (2681 - (687 + 1200)))) then
						local v248 = 1710 - (556 + 1154);
						while true do
							if (((11166 - 7992) > (2997 - (9 + 86))) and (v248 == (421 - (275 + 146)))) then
								v32 = v134();
								if (((671 + 3449) <= (4324 - (29 + 35))) and v32) then
									return v32;
								end
								break;
							end
						end
					end
				end
				if ((v101.GreaterPurge:IsAvailable() and v100 and v101.GreaterPurge:IsReady() and v37 and v91 and not v14:IsCasting() and not v14:IsChanneling() and v117.UnitHasMagicBuff(v15)) or ((3913 - 3030) > (14271 - 9493))) then
					if (v23(v101.GreaterPurge, not v15:IsSpellInRange(v101.GreaterPurge)) or ((15980 - 12360) >= (3186 + 1705))) then
						return "greater_purge damage";
					end
				end
				v170 = 1015 - (53 + 959);
			end
			if (((4666 - (312 + 96)) > (1626 - 689)) and (v170 == (289 - (147 + 138)))) then
				if (v32 or ((5768 - (813 + 86)) < (819 + 87))) then
					return v32;
				end
				if (v117.TargetIsValid() or ((2269 - 1044) > (4720 - (18 + 474)))) then
					local v241 = 0 + 0;
					local v242;
					while true do
						if (((10862 - 7534) > (3324 - (860 + 226))) and (v241 == (306 - (121 + 182)))) then
							if (((473 + 3366) > (2645 - (988 + 252))) and v101.DoomWinds:IsCastable() and v56 and ((v61 and v35) or not v61) and (v99 < v116)) then
								if (v23(v101.DoomWinds, not v15:IsInMeleeRange(1 + 4)) or ((406 + 887) <= (2477 - (49 + 1921)))) then
									return "doom_winds main 5";
								end
							end
							if ((v111 == (891 - (223 + 667))) or ((2948 - (51 + 1)) < (1385 - 580))) then
								v32 = v140();
								if (((4959 - 2643) == (3441 - (146 + 979))) and v32) then
									return v32;
								end
							end
							if ((v34 and (v111 > (1 + 0))) or ((3175 - (311 + 294)) == (4274 - 2741))) then
								local v254 = 0 + 0;
								while true do
									if ((v254 == (1443 - (496 + 947))) or ((2241 - (1233 + 125)) == (593 + 867))) then
										v32 = v141();
										if (v32 or ((4145 + 474) <= (190 + 809))) then
											return v32;
										end
										break;
									end
								end
							end
							break;
						end
						if ((v241 == (1647 - (963 + 682))) or ((2846 + 564) > (5620 - (504 + 1000)))) then
							if ((v101.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v116) and (v14:HasTier(21 + 10, 2 + 0))) or ((86 + 817) >= (4510 - 1451))) then
								if (v23(v101.PrimordialWave, not v15:IsSpellInRange(v101.PrimordialWave)) or ((3397 + 579) < (1662 + 1195))) then
									return "primordial_wave main 2";
								end
							end
							if (((5112 - (156 + 26)) > (1330 + 977)) and v101.FeralSpirit:IsCastable() and v55 and ((v60 and v35) or not v60) and (v99 < v116)) then
								if (v23(v101.FeralSpirit) or ((6329 - 2283) < (1455 - (149 + 15)))) then
									return "feral_spirit main 3";
								end
							end
							if ((v101.Ascendance:IsCastable() and v54 and ((v59 and v35) or not v59) and (v99 < v116) and v15:DebuffUp(v101.FlameShockDebuff) and (((v114 == "Lightning Bolt") and (v111 == (961 - (890 + 70)))) or ((v114 == "Chain Lightning") and (v111 > (118 - (39 + 78)))))) or ((4723 - (14 + 468)) == (7795 - 4250))) then
								if (v23(v101.Ascendance) or ((11314 - 7266) > (2184 + 2048))) then
									return "ascendance main 4";
								end
							end
							v241 = 2 + 1;
						end
						if (((1 + 0) == v241) or ((791 + 959) >= (910 + 2563))) then
							if (((6060 - 2894) == (3130 + 36)) and (v99 < v116) and v58 and ((v65 and v35) or not v65)) then
								if (((6194 - 4431) < (94 + 3630)) and v101.BloodFury:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (101 - (12 + 39))))) then
									if (((54 + 3) <= (8428 - 5705)) and v23(v101.BloodFury)) then
										return "blood_fury racial";
									end
								end
								if ((v101.Berserking:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff))) or ((7372 - 5302) == (132 + 311))) then
									if (v23(v101.Berserking) or ((1424 + 1281) == (3532 - 2139))) then
										return "berserking racial";
									end
								end
								if ((v101.Fireblood:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (34 + 16)))) or ((22235 - 17634) < (1771 - (1596 + 114)))) then
									if (v23(v101.Fireblood) or ((3629 - 2239) >= (5457 - (164 + 549)))) then
										return "fireblood racial";
									end
								end
								if ((v101.AncestralCall:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (1488 - (1059 + 379))))) or ((2486 - 483) > (1988 + 1846))) then
									if (v23(v101.AncestralCall) or ((27 + 129) > (4305 - (145 + 247)))) then
										return "ancestral_call racial";
									end
								end
							end
							if (((161 + 34) == (91 + 104)) and v101.TotemicProjection:IsCastable() and (v101.WindfuryTotem:TimeSinceLastCast() < (266 - 176)) and v14:BuffDown(v101.WindfuryTotemBuff, true)) then
								if (((596 + 2509) >= (1548 + 248)) and v23(v103.TotemicProjectionPlayer)) then
									return "totemic_projection wind_fury main 0";
								end
							end
							if (((7109 - 2730) >= (2851 - (254 + 466))) and v101.Windstrike:IsCastable() and v52) then
								if (((4404 - (544 + 16)) >= (6492 - 4449)) and v23(v101.Windstrike, not v15:IsSpellInRange(v101.Windstrike))) then
									return "windstrike main 1";
								end
							end
							v241 = 630 - (294 + 334);
						end
						if ((v241 == (253 - (236 + 17))) or ((1394 + 1838) <= (2126 + 605))) then
							v242 = v117.HandleDPSPotion(v14:BuffUp(v101.FeralSpiritBuff));
							if (((18472 - 13567) == (23222 - 18317)) and v242) then
								return v242;
							end
							if ((v99 < v116) or ((2130 + 2006) >= (3633 + 778))) then
								if ((v57 and ((v35 and v64) or not v64)) or ((3752 - (413 + 381)) == (170 + 3847))) then
									local v255 = 0 - 0;
									while true do
										if (((3189 - 1961) >= (2783 - (582 + 1388))) and (v255 == (0 - 0))) then
											v32 = v138();
											if (v32 or ((2474 + 981) > (4414 - (326 + 38)))) then
												return v32;
											end
											break;
										end
									end
								end
							end
							v241 = 2 - 1;
						end
					end
				end
				break;
			end
			if (((346 - 103) == (863 - (47 + 573))) and (v170 == (0 + 0))) then
				v32 = v137();
				if (v32 or ((1150 - 879) > (2551 - 979))) then
					return v32;
				end
				v170 = 1665 - (1269 + 395);
			end
			if (((3231 - (76 + 416)) < (3736 - (319 + 124))) and ((6 - 3) == v170)) then
				if ((v101.Purge:IsReady() and v100 and v37 and v91 and not v14:IsCasting() and not v14:IsChanneling() and v117.UnitHasMagicBuff(v15)) or ((4949 - (564 + 443)) < (3139 - 2005))) then
					if (v23(v101.Purge, not v15:IsSpellInRange(v101.Purge)) or ((3151 - (337 + 121)) == (14570 - 9597))) then
						return "purge damage";
					end
				end
				v32 = v135();
				v170 = 13 - 9;
			end
		end
	end
	local function v144()
		v54 = EpicSettings.Settings['useAscendance'];
		v56 = EpicSettings.Settings['useDoomWinds'];
		v55 = EpicSettings.Settings['useFeralSpirit'];
		v38 = EpicSettings.Settings['useChainlightning'];
		v39 = EpicSettings.Settings['useCrashLightning'];
		v40 = EpicSettings.Settings['useElementalBlast'];
		v41 = EpicSettings.Settings['useFireNova'];
		v42 = EpicSettings.Settings['useFlameShock'];
		v43 = EpicSettings.Settings['useFrostShock'];
		v44 = EpicSettings.Settings['useIceStrike'];
		v45 = EpicSettings.Settings['useLavaBurst'];
		v46 = EpicSettings.Settings['useLavaLash'];
		v47 = EpicSettings.Settings['useLightningBolt'];
		v48 = EpicSettings.Settings['usePrimordialWave'];
		v49 = EpicSettings.Settings['useStormStrike'];
		v50 = EpicSettings.Settings['useSundering'];
		v52 = EpicSettings.Settings['useWindstrike'];
		v51 = EpicSettings.Settings['useWindfuryTotem'];
		v53 = EpicSettings.Settings['useWeaponEnchant'];
		v59 = EpicSettings.Settings['ascendanceWithCD'];
		v61 = EpicSettings.Settings['doomWindsWithCD'];
		v60 = EpicSettings.Settings['feralSpiritWithCD'];
		v63 = EpicSettings.Settings['primordialWaveWithMiniCD'];
		v62 = EpicSettings.Settings['sunderingWithMiniCD'];
	end
	local function v145()
		v66 = EpicSettings.Settings['useWindShear'];
		v67 = EpicSettings.Settings['useCapacitorTotem'];
		v68 = EpicSettings.Settings['useThunderstorm'];
		v70 = EpicSettings.Settings['useAncestralGuidance'];
		v69 = EpicSettings.Settings['useAstralShift'];
		v72 = EpicSettings.Settings['useMaelstromHealingSurge'];
		v71 = EpicSettings.Settings['useHealingStreamTotem'];
		v78 = EpicSettings.Settings['ancestralGuidanceHP'] or (1911 - (1261 + 650));
		v79 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
		v77 = EpicSettings.Settings['astralShiftHP'] or (0 - 0);
		v80 = EpicSettings.Settings['healingStreamTotemHP'] or (1817 - (772 + 1045));
		v81 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
		v82 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (144 - (102 + 42));
		v75 = EpicSettings.Settings['autoShield'];
		v76 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
		v85 = EpicSettings.Settings['healOOC'];
		v86 = EpicSettings.Settings['healOOCHP'] or (1844 - (1524 + 320));
		v100 = EpicSettings.Settings['usePurgeTarget'];
		v87 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
		v88 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v89 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
		v90 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
	end
	local function v146()
		local v209 = 1270 - (1049 + 221);
		while true do
			if (((2302 - (18 + 138)) == (5252 - 3106)) and (v209 == (1103 - (67 + 1035)))) then
				v98 = EpicSettings.Settings['InterruptThreshold'];
				v92 = EpicSettings.Settings['DispelDebuffs'];
				v91 = EpicSettings.Settings['DispelBuffs'];
				v209 = 350 - (136 + 212);
			end
			if ((v209 == (0 - 0)) or ((1798 + 446) == (2973 + 251))) then
				v99 = EpicSettings.Settings['fightRemainsCheck'] or (1604 - (240 + 1364));
				v96 = EpicSettings.Settings['InterruptWithStun'];
				v97 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v209 = 1083 - (1050 + 32);
			end
			if ((v209 == (17 - 12)) or ((2901 + 2003) <= (2971 - (331 + 724)))) then
				v93 = EpicSettings.Settings['handleAfflicted'];
				v94 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((8 + 82) <= (1709 - (269 + 375))) and (v209 == (727 - (267 + 458)))) then
				v57 = EpicSettings.Settings['useTrinkets'];
				v58 = EpicSettings.Settings['useRacials'];
				v64 = EpicSettings.Settings['trinketsWithCD'];
				v209 = 1 + 2;
			end
			if (((9234 - 4432) == (5620 - (667 + 151))) and (v209 == (1500 - (1410 + 87)))) then
				v65 = EpicSettings.Settings['racialsWithCD'];
				v73 = EpicSettings.Settings['useHealthstone'];
				v74 = EpicSettings.Settings['useHealingPotion'];
				v209 = 1901 - (1504 + 393);
			end
			if ((v209 == (10 - 6)) or ((5915 - 3635) <= (1307 - (461 + 335)))) then
				v83 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v84 = EpicSettings.Settings['healingPotionHP'] or (1761 - (1730 + 31));
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v209 = 1672 - (728 + 939);
			end
		end
	end
	local function v147()
		v145();
		v144();
		v146();
		v33 = EpicSettings.Toggles['ooc'];
		v34 = EpicSettings.Toggles['aoe'];
		v35 = EpicSettings.Toggles['cds'];
		v37 = EpicSettings.Toggles['dispel'];
		v36 = EpicSettings.Toggles['minicds'];
		if (v14:IsDeadOrGhost() or ((5935 - 4259) <= (938 - 475))) then
			return v32;
		end
		v105, v107, _, _, v106, v108 = v26();
		v109 = v14:GetEnemiesInRange(91 - 51);
		v110 = v14:GetEnemiesInMeleeRange(1078 - (138 + 930));
		if (((3536 + 333) == (3025 + 844)) and v34) then
			local v219 = 0 + 0;
			while true do
				if (((4728 - 3570) <= (4379 - (459 + 1307))) and (v219 == (1870 - (474 + 1396)))) then
					v112 = #v109;
					v111 = #v110;
					break;
				end
			end
		else
			v112 = 1 - 0;
			v111 = 1 + 0;
		end
		if (v14:AffectingCombat() or v92 or ((8 + 2356) <= (5725 - 3726))) then
			local v220 = v92 and v101.CleanseSpirit:IsReady() and v37;
			v32 = v117.FocusUnit(v220, v103, 3 + 17, nil, 83 - 58);
			if (v32 or ((21465 - 16543) < (785 - (562 + 29)))) then
				return v32;
			end
		end
		if (v117.TargetIsValid() or v14:AffectingCombat() or ((1783 + 308) < (1450 - (374 + 1045)))) then
			v115 = v10.BossFightRemains(nil, true);
			v116 = v115;
			if ((v116 == (8794 + 2317)) or ((7545 - 5115) >= (5510 - (448 + 190)))) then
				v116 = v10.FightRemains(v110, false);
			end
		end
		if (v14:AffectingCombat() or ((1540 + 3230) < (784 + 951))) then
			if (v14:PrevGCD(1 + 0, v101.ChainLightning) or ((17067 - 12628) <= (7302 - 4952))) then
				v114 = "Chain Lightning";
			elseif (v14:PrevGCD(1495 - (1307 + 187), v101.LightningBolt) or ((17761 - 13282) < (10456 - 5990))) then
				v114 = "Lightning Bolt";
			end
		end
		if (((7809 - 5262) > (1908 - (232 + 451))) and not v14:IsChanneling() and not v14:IsChanneling()) then
			local v221 = 0 + 0;
			while true do
				if (((4127 + 544) > (3238 - (510 + 54))) and (v221 == (0 - 0))) then
					if (v16 or ((3732 - (13 + 23)) < (6485 - 3158))) then
						if (v92 or ((6525 - 1983) == (5396 - 2426))) then
							v32 = v134();
							if (((1340 - (830 + 258)) <= (6974 - 4997)) and v32) then
								return v32;
							end
						end
					end
					if (v93 or ((899 + 537) == (3212 + 563))) then
						if (v87 or ((3059 - (860 + 581)) < (3430 - 2500))) then
							local v252 = 0 + 0;
							while true do
								if (((4964 - (237 + 4)) > (9759 - 5606)) and (v252 == (0 - 0))) then
									v32 = v117.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 75 - 35);
									if (v32 or ((2991 + 663) >= (2673 + 1981))) then
										return v32;
									end
									break;
								end
							end
						end
						if (((3590 - 2639) <= (642 + 854)) and v88) then
							v32 = v117.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 17 + 13);
							if (v32 or ((3162 - (85 + 1341)) == (974 - 403))) then
								return v32;
							end
						end
						if (v89 or ((2530 - 1634) > (5141 - (45 + 327)))) then
							v32 = v117.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 56 - 26);
							if (v32 or ((1547 - (444 + 58)) <= (444 + 576))) then
								return v32;
							end
						end
						if (((v14:BuffStack(v101.MaelstromWeaponBuff) >= (1 + 4)) and v90) or ((568 + 592) <= (950 - 622))) then
							local v253 = 1732 - (64 + 1668);
							while true do
								if (((5781 - (1227 + 746)) > (8987 - 6063)) and (v253 == (0 - 0))) then
									v32 = v117.HandleAfflicted(v101.HealingSurge, v103.HealingSurgeMouseover, 534 - (415 + 79), true);
									if (((100 + 3791) < (5410 - (142 + 349))) and v32) then
										return v32;
									end
									break;
								end
							end
						end
					end
					v221 = 1 + 0;
				end
				if ((v221 == (1 - 0)) or ((1111 + 1123) <= (1059 + 443))) then
					if (v14:AffectingCombat() or ((6840 - 4328) < (2296 - (1710 + 154)))) then
						v32 = v143();
						if (v32 or ((2166 - (200 + 118)) == (343 + 522))) then
							return v32;
						end
					else
						local v249 = 0 - 0;
						while true do
							if ((v249 == (0 - 0)) or ((4161 + 521) <= (4492 + 49))) then
								v32 = v142();
								if (v32 or ((1624 + 1402) >= (647 + 3399))) then
									return v32;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v148()
		v101.FlameShockDebuff:RegisterAuraTracking();
		v124();
		v20.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(569 - 306, v147, v148);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

