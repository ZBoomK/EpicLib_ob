local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1599 - (1068 + 531);
	local v6;
	while true do
		if ((v5 == (1002 - (234 + 768))) or ((4429 - (35 + 1064)) < (1040 + 389))) then
			v6 = v0[v4];
			if (((2453 - 1306) >= (2 + 333)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1237 - (298 + 938);
		end
		if (((4694 - (233 + 1026)) > (3763 - (636 + 1030))) and (v5 == (1 + 0))) then
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
	local v114 = (v102.LavaBurst:IsAvailable() and (2 + 0)) or (1 + 0);
	local v115 = "Lightning Bolt";
	local v116 = 751 + 10360;
	local v117 = 11332 - (55 + 166);
	local v118 = v21.Commons.Everyone;
	v21.Commons.Shaman = {};
	local v120 = v21.Commons.Shaman;
	v120.FeralSpiritCount = 0 + 0;
	v10:RegisterForEvent(function()
		v114 = (v102.LavaBurst:IsAvailable() and (1 + 1)) or (3 - 2);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		v115 = "Lightning Bolt";
		v116 = 11408 - (36 + 261);
		v117 = 19431 - 8320;
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForSelfCombatEvent(function(...)
		local v147, v148, v148, v148, v148, v148, v148, v148, v149 = select(1372 - (34 + 1334), ...);
		if (((v147 == v14:GUID()) and (v149 == (73670 + 117964))) or ((2930 + 840) >= (5324 - (1035 + 248)))) then
			v120.LastSKCast = v31();
		end
		if ((v14:HasTier(52 - (20 + 1), 2 + 0) and (v147 == v14:GUID()) and (v149 == (376301 - (134 + 185)))) or ((4924 - (549 + 584)) <= (2296 - (314 + 371)))) then
			local v172 = 0 - 0;
			while true do
				if ((v172 == (968 - (478 + 490))) or ((2426 + 2152) <= (3180 - (786 + 386)))) then
					v120.FeralSpiritCount = v120.FeralSpiritCount + (3 - 2);
					v32.After(1394 - (1055 + 324), function()
						v120.FeralSpiritCount = v120.FeralSpiritCount - (1341 - (1093 + 247));
					end);
					break;
				end
			end
		end
		if (((1000 + 125) <= (219 + 1857)) and (v147 == v14:GUID()) and (v149 == (204595 - 153062))) then
			v120.FeralSpiritCount = v120.FeralSpiritCount + (6 - 4);
			v32.After(42 - 27, function()
				v120.FeralSpiritCount = v120.FeralSpiritCount - (4 - 2);
			end);
		end
	end, "SPELL_CAST_SUCCESS");
	local function v122()
		if (v102.CleanseSpirit:IsAvailable() or ((265 + 478) >= (16946 - 12547))) then
			v118.DispellableDebuffs = v118.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123()
		for v169 = 3 - 2, 5 + 1, 2 - 1 do
			if (((1843 - (364 + 324)) < (4585 - 2912)) and v30(v14:TotemName(v169), "Totem")) then
				return v169;
			end
		end
	end
	local function v124()
		local v150 = 0 - 0;
		local v151;
		while true do
			if ((v150 == (0 + 0)) or ((9724 - 7400) <= (925 - 347))) then
				if (((11440 - 7673) == (5035 - (1249 + 19))) and (not v102.AlphaWolf:IsAvailable() or v14:BuffDown(v102.FeralSpiritBuff))) then
					return 0 + 0;
				end
				v151 = v29(v102.CrashLightning:TimeSinceLastCast(), v102.ChainLightning:TimeSinceLastCast());
				v150 = 3 - 2;
			end
			if (((5175 - (686 + 400)) == (3209 + 880)) and (v150 == (230 - (73 + 156)))) then
				if (((22 + 4436) >= (2485 - (721 + 90))) and ((v151 > (1 + 7)) or (v151 > v102.FeralSpirit:TimeSinceLastCast()))) then
					return 0 - 0;
				end
				return (478 - (224 + 246)) - v151;
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
		return v158:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (9 - 3));
	end
	local function v132()
		if (((1789 - 817) <= (258 + 1160)) and v102.CleanseSpirit:IsReady() and v38 and v118.DispellableFriendlyUnit(1 + 24)) then
			if (v24(v104.CleanseSpiritFocus) or ((3627 + 1311) < (9466 - 4704))) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v133()
		local v159 = 0 - 0;
		while true do
			if ((v159 == (513 - (203 + 310))) or ((4497 - (1238 + 755)) > (298 + 3966))) then
				if (((3687 - (709 + 825)) == (3966 - 1813)) and (not v16 or not v16:Exists() or not v16:IsInRange(58 - 18))) then
					return;
				end
				if (v16 or ((1371 - (196 + 668)) >= (10229 - 7638))) then
					if (((9281 - 4800) == (5314 - (171 + 662))) and (v16:HealthPercentage() <= v83) and v73 and v102.HealingSurge:IsReady() and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (98 - (4 + 89)))) then
						if (v24(v104.HealingSurgeFocus) or ((8159 - 5831) < (253 + 440))) then
							return "healing_surge heal focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v134()
		if (((19009 - 14681) == (1698 + 2630)) and (v14:HealthPercentage() <= v87)) then
			if (((3074 - (35 + 1451)) >= (2785 - (28 + 1425))) and v102.HealingSurge:IsReady()) then
				if (v24(v102.HealingSurge) or ((6167 - (941 + 1052)) > (4074 + 174))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v135()
		local v160 = 1514 - (822 + 692);
		while true do
			if ((v160 == (2 - 0)) or ((2161 + 2425) <= (379 - (45 + 252)))) then
				if (((3823 + 40) == (1330 + 2533)) and v103.Healthstone:IsReady() and v74 and (v14:HealthPercentage() <= v84)) then
					if (v24(v104.Healthstone) or ((685 - 403) <= (475 - (114 + 319)))) then
						return "healthstone defensive 3";
					end
				end
				if (((6616 - 2007) >= (981 - 215)) and v75 and (v14:HealthPercentage() <= v85)) then
					local v237 = 0 + 0;
					while true do
						if ((v237 == (0 - 0)) or ((2413 - 1261) == (4451 - (556 + 1407)))) then
							if (((4628 - (741 + 465)) > (3815 - (170 + 295))) and (v96 == "Refreshing Healing Potion")) then
								if (((463 + 414) > (346 + 30)) and v103.RefreshingHealingPotion:IsReady()) then
									if (v24(v104.RefreshingHealingPotion) or ((7676 - 4558) <= (1535 + 316))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v96 == "Dreamwalker's Healing Potion") or ((106 + 59) >= (1978 + 1514))) then
								if (((5179 - (957 + 273)) < (1299 + 3557)) and v103.DreamwalkersHealingPotion:IsReady()) then
									if (v24(v104.RefreshingHealingPotion) or ((1712 + 2564) < (11492 - 8476))) then
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
			if (((12359 - 7669) > (12599 - 8474)) and (v160 == (0 - 0))) then
				if ((v102.AstralShift:IsReady() and v70 and (v14:HealthPercentage() <= v78)) or ((1830 - (389 + 1391)) >= (563 + 333))) then
					if (v24(v102.AstralShift) or ((179 + 1535) >= (6734 - 3776))) then
						return "astral_shift defensive 1";
					end
				end
				if ((v102.AncestralGuidance:IsReady() and v71 and v118.AreUnitsBelowHealthPercentage(v79, v80)) or ((2442 - (783 + 168)) < (2161 - 1517))) then
					if (((693 + 11) < (1298 - (309 + 2))) and v24(v102.AncestralGuidance)) then
						return "ancestral_guidance defensive 2";
					end
				end
				v160 = 2 - 1;
			end
			if (((4930 - (1090 + 122)) > (618 + 1288)) and (v160 == (3 - 2))) then
				if ((v102.HealingStreamTotem:IsReady() and v72 and v118.AreUnitsBelowHealthPercentage(v81, v82)) or ((656 + 302) > (4753 - (628 + 490)))) then
					if (((628 + 2873) <= (11121 - 6629)) and v24(v102.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v102.HealingSurge:IsReady() and v73 and (v14:HealthPercentage() <= v83) and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (22 - 17))) or ((4216 - (431 + 343)) < (5145 - 2597))) then
					if (((8317 - 5442) >= (1157 + 307)) and v24(v102.HealingSurge)) then
						return "healing_surge defensive 4";
					end
				end
				v160 = 1 + 1;
			end
		end
	end
	local function v136()
		v33 = v118.HandleTopTrinket(v105, v36, 1735 - (556 + 1139), nil);
		if (v33 or ((4812 - (6 + 9)) >= (896 + 3997))) then
			return v33;
		end
		v33 = v118.HandleBottomTrinket(v105, v36, 21 + 19, nil);
		if (v33 or ((720 - (28 + 141)) > (801 + 1267))) then
			return v33;
		end
	end
	local function v137()
		local v161 = 0 - 0;
		while true do
			if (((1498 + 616) > (2261 - (486 + 831))) and (v161 == (0 - 0))) then
				if ((v102.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (316 - 226)))) or ((428 + 1834) >= (9789 - 6693))) then
					if (v24(v102.WindfuryTotem) or ((3518 - (668 + 595)) >= (3183 + 354))) then
						return "windfury_totem precombat 4";
					end
				end
				if ((v102.FeralSpirit:IsCastable() and v56 and ((v61 and v36) or not v61)) or ((774 + 3063) < (3561 - 2255))) then
					if (((3240 - (23 + 267)) == (4894 - (1129 + 815))) and v24(v102.FeralSpirit)) then
						return "feral_spirit precombat 6";
					end
				end
				v161 = 388 - (371 + 16);
			end
			if ((v161 == (1752 - (1326 + 424))) or ((8944 - 4221) < (12051 - 8753))) then
				if (((1254 - (88 + 30)) >= (925 - (720 + 51))) and v102.Stormstrike:IsReady() and v50) then
					if (v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike)) or ((602 - 331) > (6524 - (421 + 1355)))) then
						return "stormstrike precombat 12";
					end
				end
				break;
			end
			if (((7819 - 3079) >= (1549 + 1603)) and (v161 == (1084 - (286 + 797)))) then
				if ((v102.DoomWinds:IsCastable() and v57 and ((v62 and v36) or not v62)) or ((9424 - 6846) >= (5615 - 2225))) then
					if (((480 - (397 + 42)) <= (519 + 1142)) and v24(v102.DoomWinds, not v15:IsSpellInRange(v102.DoomWinds))) then
						return "doom_winds precombat 8";
					end
				end
				if (((1401 - (24 + 776)) < (5484 - 1924)) and v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63)) then
					if (((1020 - (222 + 563)) < (1513 - 826)) and v24(v102.Sundering, not v15:IsInRange(4 + 1))) then
						return "sundering precombat 10";
					end
				end
				v161 = 192 - (23 + 167);
			end
		end
	end
	local function v138()
		local v162 = 1798 - (690 + 1108);
		while true do
			if (((1642 + 2907) > (952 + 201)) and ((851 - (40 + 808)) == v162)) then
				if ((v102.LavaLash:IsReady() and v47 and (v102.LashingFlames:IsAvailable())) or ((770 + 3904) < (17865 - 13193))) then
					if (((3506 + 162) < (2413 + 2148)) and v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash single 19";
					end
				end
				if ((v102.IceStrike:IsReady() and v45 and (v14:BuffDown(v102.IceStrikeBuff))) or ((250 + 205) == (4176 - (47 + 524)))) then
					if (v24(v102.IceStrike, not v15:IsInMeleeRange(4 + 1)) or ((7279 - 4616) == (4951 - 1639))) then
						return "ice_strike single 20";
					end
				end
				if (((9754 - 5477) <= (6201 - (1165 + 561))) and v102.FrostShock:IsReady() and v44 and (v14:BuffUp(v102.HailstormBuff))) then
					if (v24(v102.FrostShock, not v15:IsSpellInRange(v102.FrostShock)) or ((26 + 844) == (3682 - 2493))) then
						return "frost_shock single 21";
					end
				end
				if (((593 + 960) <= (3612 - (341 + 138))) and v102.LavaLash:IsReady() and v47) then
					if (v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash)) or ((604 + 1633) >= (7245 - 3734))) then
						return "lava_lash single 22";
					end
				end
				if ((v102.IceStrike:IsReady() and v45) or ((1650 - (89 + 237)) > (9715 - 6695))) then
					if (v24(v102.IceStrike, not v15:IsInMeleeRange(10 - 5)) or ((3873 - (581 + 300)) == (3101 - (855 + 365)))) then
						return "ice_strike single 23";
					end
				end
				if (((7377 - 4271) > (499 + 1027)) and v102.Windstrike:IsCastable() and v53) then
					if (((4258 - (1030 + 205)) < (3634 + 236)) and v24(v102.Windstrike, not v15:IsSpellInRange(v102.Windstrike))) then
						return "windstrike single 24";
					end
				end
				v162 = 4 + 0;
			end
			if (((429 - (156 + 130)) > (167 - 93)) and (v162 == (6 - 2))) then
				if (((36 - 18) < (557 + 1555)) and v102.Stormstrike:IsReady() and v50) then
					if (((640 + 457) <= (1697 - (10 + 59))) and v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike))) then
						return "stormstrike single 25";
					end
				end
				if (((1310 + 3320) == (22801 - 18171)) and v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v117)) then
					if (((4703 - (671 + 492)) > (2136 + 547)) and v24(v102.Sundering, not v15:IsInRange(1223 - (369 + 846)))) then
						return "sundering single 26";
					end
				end
				if (((1270 + 3524) >= (2795 + 480)) and v102.BagofTricks:IsReady() and v59 and ((v66 and v36) or not v66)) then
					if (((3429 - (1036 + 909)) == (1180 + 304)) and v24(v102.BagofTricks)) then
						return "bag_of_tricks single 27";
					end
				end
				if (((2403 - 971) < (3758 - (11 + 192))) and v102.FireNova:IsReady() and v42 and v102.SwirlingMaelstrom:IsAvailable() and v15:DebuffUp(v102.FlameShockDebuff) and (v14:BuffStack(v102.MaelstromWeaponBuff) < (3 + 2 + ((180 - (135 + 40)) * v25(v102.OverflowingMaelstrom:IsAvailable()))))) then
					if (v24(v102.FireNova) or ((2580 - 1515) > (2157 + 1421))) then
						return "fire_nova single 28";
					end
				end
				if ((v102.LightningBolt:IsReady() and v48 and v102.Hailstorm:IsAvailable() and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (10 - 5)) and v14:BuffDown(v102.PrimordialWaveBuff)) or ((7188 - 2393) < (1583 - (50 + 126)))) then
					if (((5159 - 3306) < (1066 + 3747)) and v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt))) then
						return "lightning_bolt single 29";
					end
				end
				if ((v102.FrostShock:IsReady() and v44) or ((4234 - (1233 + 180)) < (3400 - (522 + 447)))) then
					if (v24(v102.FrostShock, not v15:IsSpellInRange(v102.FrostShock)) or ((4295 - (107 + 1314)) < (1013 + 1168))) then
						return "frost_shock single 30";
					end
				end
				v162 = 15 - 10;
			end
			if ((v162 == (1 + 1)) or ((5339 - 2650) <= (1357 - 1014))) then
				if ((v102.LavaBurst:IsReady() and v46 and not v102.ThorimsInvocation:IsAvailable() and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (1915 - (716 + 1194)))) or ((32 + 1837) == (216 + 1793))) then
					if (v24(v102.LavaBurst, not v15:IsSpellInRange(v102.LavaBurst)) or ((4049 - (74 + 429)) < (4479 - 2157))) then
						return "lava_burst single 13";
					end
				end
				if ((v102.LightningBolt:IsReady() and v48 and ((v14:BuffStack(v102.MaelstromWeaponBuff) >= (4 + 4)) or (v102.StaticAccumulation:IsAvailable() and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (11 - 6)))) and v14:BuffDown(v102.PrimordialWaveBuff)) or ((1473 + 609) == (14714 - 9941))) then
					if (((8020 - 4776) > (1488 - (279 + 154))) and v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt))) then
						return "lightning_bolt single 14";
					end
				end
				if ((v102.CrashLightning:IsReady() and v40 and v102.AlphaWolf:IsAvailable() and v14:BuffUp(v102.FeralSpiritBuff) and (v124() == (778 - (454 + 324)))) or ((2607 + 706) <= (1795 - (12 + 5)))) then
					if (v24(v102.CrashLightning, not v15:IsInMeleeRange(5 + 3)) or ((3620 - 2199) >= (778 + 1326))) then
						return "crash_lightning single 15";
					end
				end
				if (((2905 - (277 + 816)) <= (13883 - 10634)) and v102.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v117)) then
					if (((2806 - (1058 + 125)) <= (367 + 1590)) and v24(v102.PrimordialWave, not v15:IsSpellInRange(v102.PrimordialWave))) then
						return "primordial_wave single 16";
					end
				end
				if (((5387 - (815 + 160)) == (18930 - 14518)) and v102.FlameShock:IsReady() and v43 and (v15:DebuffDown(v102.FlameShockDebuff))) then
					if (((4154 - 2404) >= (201 + 641)) and v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock single 17";
					end
				end
				if (((12779 - 8407) > (3748 - (41 + 1857))) and v102.IceStrike:IsReady() and v45 and v102.ElementalAssault:IsAvailable() and v102.SwirlingMaelstrom:IsAvailable()) then
					if (((2125 - (1222 + 671)) < (2121 - 1300)) and v24(v102.IceStrike, not v15:IsInMeleeRange(6 - 1))) then
						return "ice_strike single 18";
					end
				end
				v162 = 1185 - (229 + 953);
			end
			if (((2292 - (1111 + 663)) < (2481 - (874 + 705))) and ((1 + 0) == v162)) then
				if (((2043 + 951) > (1783 - 925)) and v102.LavaLash:IsReady() and v47 and (v14:BuffUp(v102.HotHandBuff))) then
					if (v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash)) or ((106 + 3649) <= (1594 - (642 + 37)))) then
						return "lava_lash single 7";
					end
				end
				if (((900 + 3046) > (599 + 3144)) and v102.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v102.WindfuryTotemBuff, true))) then
					if (v24(v102.WindfuryTotem) or ((3351 - 2016) >= (3760 - (233 + 221)))) then
						return "windfury_totem single 8";
					end
				end
				if (((11201 - 6357) > (1984 + 269)) and v102.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (1546 - (718 + 823))) and (v102.ElementalBlast:Charges() == v114)) then
					if (((285 + 167) == (1257 - (266 + 539))) and v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast))) then
						return "elemental_blast single 9";
					end
				end
				if ((v102.LightningBolt:IsReady() and v48 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (22 - 14)) and v14:BuffUp(v102.PrimordialWaveBuff) and (v14:BuffDown(v102.SplinteredElementsBuff) or (v117 <= (1237 - (636 + 589))))) or ((10817 - 6260) < (4304 - 2217))) then
					if (((3070 + 804) == (1408 + 2466)) and v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt))) then
						return "lightning_bolt single 10";
					end
				end
				if ((v102.ChainLightning:IsReady() and v39 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (1023 - (657 + 358))) and v14:BuffUp(v102.CracklingThunderBuff) and v102.ElementalSpirits:IsAvailable()) or ((5131 - 3193) > (11243 - 6308))) then
					if (v24(v102.ChainLightning, not v15:IsSpellInRange(v102.ChainLightning)) or ((5442 - (1151 + 36)) < (3306 + 117))) then
						return "chain_lightning single 11";
					end
				end
				if (((383 + 1071) <= (7439 - 4948)) and v102.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (1840 - (1552 + 280))) and ((v120.FeralSpiritCount >= (836 - (64 + 770))) or not v102.ElementalSpirits:IsAvailable())) then
					if (v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast)) or ((2823 + 1334) <= (6362 - 3559))) then
						return "elemental_blast single 12";
					end
				end
				v162 = 1 + 1;
			end
			if (((6096 - (157 + 1086)) >= (5968 - 2986)) and (v162 == (0 - 0))) then
				if (((6341 - 2207) > (4581 - 1224)) and v102.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v117) and v15:DebuffDown(v102.FlameShockDebuff) and v102.LashingFlames:IsAvailable()) then
					if (v24(v102.PrimordialWave, not v15:IsSpellInRange(v102.PrimordialWave)) or ((4236 - (599 + 220)) < (5046 - 2512))) then
						return "primordial_wave single 1";
					end
				end
				if ((v102.FlameShock:IsReady() and v43 and v15:DebuffDown(v102.FlameShockDebuff) and v102.LashingFlames:IsAvailable()) or ((4653 - (1813 + 118)) <= (120 + 44))) then
					if (v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock)) or ((3625 - (841 + 376)) < (2954 - 845))) then
						return "flame_shock single 2";
					end
				end
				if ((v102.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (2 + 3)) and v102.ElementalSpirits:IsAvailable() and (v120.FeralSpiritCount >= (10 - 6))) or ((892 - (464 + 395)) == (3734 - 2279))) then
					if (v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast)) or ((213 + 230) >= (4852 - (467 + 370)))) then
						return "elemental_blast single 3";
					end
				end
				if (((6988 - 3606) > (122 + 44)) and v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v117) and (v14:HasTier(102 - 72, 1 + 1))) then
					if (v24(v102.Sundering, not v15:IsInRange(18 - 10)) or ((800 - (150 + 370)) == (4341 - (74 + 1208)))) then
						return "sundering single 4";
					end
				end
				if (((4626 - 2745) > (6132 - 4839)) and v102.LightningBolt:IsReady() and v48 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (4 + 1)) and v14:BuffDown(v102.CracklingThunderBuff) and v14:BuffUp(v102.AscendanceBuff) and (v115 == "Chain Lightning") and (v14:BuffRemains(v102.AscendanceBuff) > (v102.ChainLightning:CooldownRemains() + v14:GCD()))) then
					if (((2747 - (14 + 376)) == (4087 - 1730)) and v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt))) then
						return "lightning_bolt single 5";
					end
				end
				if (((80 + 43) == (109 + 14)) and v102.Stormstrike:IsReady() and v50 and (v14:BuffUp(v102.DoomWindsBuff) or v102.DeeplyRootedElements:IsAvailable() or (v102.Stormblast:IsAvailable() and v14:BuffUp(v102.StormbringerBuff)))) then
					if (v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike)) or ((1008 + 48) >= (9938 - 6546))) then
						return "stormstrike single 6";
					end
				end
				v162 = 1 + 0;
			end
			if ((v162 == (83 - (23 + 55))) or ((2561 - 1480) < (718 + 357))) then
				if ((v102.CrashLightning:IsReady() and v40) or ((943 + 106) >= (6871 - 2439))) then
					if (v24(v102.CrashLightning, not v15:IsInMeleeRange(3 + 5)) or ((5669 - (652 + 249)) <= (2263 - 1417))) then
						return "crash_lightning single 31";
					end
				end
				if ((v102.FireNova:IsReady() and v42 and (v15:DebuffUp(v102.FlameShockDebuff))) or ((5226 - (708 + 1160)) <= (3854 - 2434))) then
					if (v24(v102.FireNova) or ((6816 - 3077) <= (3032 - (10 + 17)))) then
						return "fire_nova single 32";
					end
				end
				if ((v102.FlameShock:IsReady() and v43) or ((373 + 1286) >= (3866 - (1400 + 332)))) then
					if (v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock)) or ((6252 - 2992) < (4263 - (242 + 1666)))) then
						return "flame_shock single 34";
					end
				end
				if ((v102.ChainLightning:IsReady() and v39 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (3 + 2)) and v14:BuffUp(v102.CracklingThunderBuff) and v102.ElementalSpirits:IsAvailable()) or ((246 + 423) == (3600 + 623))) then
					if (v24(v102.ChainLightning, not v15:IsSpellInRange(v102.ChainLightning)) or ((2632 - (850 + 90)) < (1029 - 441))) then
						return "chain_lightning single 35";
					end
				end
				if ((v102.LightningBolt:IsReady() and v48 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (1395 - (360 + 1030))) and v14:BuffDown(v102.PrimordialWaveBuff)) or ((4246 + 551) < (10304 - 6653))) then
					if (v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt)) or ((5746 - 1569) > (6511 - (909 + 752)))) then
						return "lightning_bolt single 36";
					end
				end
				if ((v102.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (1313 - (109 + 1114))))) or ((732 - 332) > (433 + 678))) then
					if (((3293 - (6 + 236)) > (634 + 371)) and v24(v102.WindfuryTotem)) then
						return "windfury_totem single 37";
					end
				end
				break;
			end
		end
	end
	local function v139()
		local v163 = 0 + 0;
		while true do
			if (((8709 - 5016) <= (7653 - 3271)) and (v163 == (1136 - (1076 + 57)))) then
				if ((v102.FlameShock:IsReady() and v43 and v102.MoltenAssault:IsAvailable() and v15:DebuffDown(v102.FlameShockDebuff)) or ((540 + 2742) > (4789 - (579 + 110)))) then
					if (v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock)) or ((283 + 3297) < (2515 + 329))) then
						return "flame_shock aoe 16";
					end
				end
				if (((48 + 41) < (4897 - (174 + 233))) and v102.FlameShock:IsReady() and v43 and v15:DebuffRefreshable(v102.FlameShockDebuff) and (v102.FireNova:IsAvailable() or v102.PrimordialWave:IsAvailable()) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (16 - 10))) then
					if (v118.CastCycle(v102.FlameShock, v111, v125, not v15:IsSpellInRange(v102.FlameShock)) or ((8745 - 3762) < (804 + 1004))) then
						return "flame_shock aoe 17";
					end
					if (((5003 - (663 + 511)) > (3363 + 406)) and v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock aoe no_cycle 17";
					end
				end
				if (((323 + 1162) <= (8952 - 6048)) and v102.FireNova:IsReady() and v42 and (v102.FlameShockDebuff:AuraActiveCount() >= (2 + 1))) then
					if (((10050 - 5781) == (10334 - 6065)) and v24(v102.FireNova)) then
						return "fire_nova aoe 18";
					end
				end
				if (((185 + 202) <= (5414 - 2632)) and v102.Stormstrike:IsReady() and v50 and v14:BuffUp(v102.CrashLightningBuff) and (v102.DeeplyRootedElements:IsAvailable() or (v14:BuffStack(v102.ConvergingStormsBuff) == (5 + 1)))) then
					if (v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike)) or ((174 + 1725) <= (1639 - (478 + 244)))) then
						return "stormstrike aoe 19";
					end
				end
				if ((v102.CrashLightning:IsReady() and v40 and v102.CrashingStorms:IsAvailable() and v14:BuffUp(v102.CLCrashLightningBuff) and (v112 >= (521 - (440 + 77)))) or ((1961 + 2351) <= (3205 - 2329))) then
					if (((3788 - (655 + 901)) <= (482 + 2114)) and v24(v102.CrashLightning, not v15:IsInMeleeRange(7 + 1))) then
						return "crash_lightning aoe 20";
					end
				end
				v163 = 3 + 1;
			end
			if (((8439 - 6344) < (5131 - (695 + 750))) and (v163 == (20 - 14))) then
				if ((v102.FrostShock:IsReady() and v44 and not v102.Hailstorm:IsAvailable()) or ((2461 - 866) >= (17993 - 13519))) then
					if (v24(v102.FrostShock, not v15:IsSpellInRange(v102.FrostShock)) or ((4970 - (285 + 66)) < (6717 - 3835))) then
						return "frost_shock aoe 31";
					end
				end
				break;
			end
			if ((v163 == (1311 - (682 + 628))) or ((48 + 246) >= (5130 - (176 + 123)))) then
				if (((849 + 1180) <= (2238 + 846)) and v102.ElementalBlast:IsReady() and v41 and (not v102.ElementalSpirits:IsAvailable() or (v102.ElementalSpirits:IsAvailable() and ((v102.ElementalBlast:Charges() == v114) or (v120.FeralSpiritCount >= (271 - (239 + 30)))))) and (v14:BuffStack(v102.MaelstromWeaponBuff) == (2 + 3 + ((5 + 0) * v25(v102.OverflowingMaelstrom:IsAvailable())))) and (not v102.CrashingStorms:IsAvailable() or (v112 <= (4 - 1)))) then
					if (v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast)) or ((6355 - 4318) == (2735 - (306 + 9)))) then
						return "elemental_blast aoe 6";
					end
				end
				if (((15556 - 11098) > (679 + 3225)) and v102.ChainLightning:IsReady() and v39 and (v14:BuffStack(v102.MaelstromWeaponBuff) == (4 + 1 + ((3 + 2) * v25(v102.OverflowingMaelstrom:IsAvailable()))))) then
					if (((1246 - 810) >= (1498 - (1140 + 235))) and v24(v102.ChainLightning, not v15:IsSpellInRange(v102.ChainLightning))) then
						return "chain_lightning aoe 7";
					end
				end
				if (((319 + 181) < (1666 + 150)) and v102.CrashLightning:IsReady() and v40 and (v14:BuffUp(v102.DoomWindsBuff) or v14:BuffDown(v102.CrashLightningBuff) or (v102.AlphaWolf:IsAvailable() and v14:BuffUp(v102.FeralSpiritBuff) and (v124() == (0 + 0))))) then
					if (((3626 - (33 + 19)) == (1291 + 2283)) and v24(v102.CrashLightning, not v15:IsInMeleeRange(23 - 15))) then
						return "crash_lightning aoe 8";
					end
				end
				if (((98 + 123) < (764 - 374)) and v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v117) and (v14:BuffUp(v102.DoomWindsBuff) or v14:HasTier(29 + 1, 691 - (586 + 103)))) then
					if (v24(v102.Sundering, not v15:IsInRange(1 + 7)) or ((6813 - 4600) <= (2909 - (1309 + 179)))) then
						return "sundering aoe 9";
					end
				end
				if (((5520 - 2462) < (2116 + 2744)) and v102.FireNova:IsReady() and v42 and ((v102.FlameShockDebuff:AuraActiveCount() >= (15 - 9)) or ((v102.FlameShockDebuff:AuraActiveCount() >= (4 + 0)) and (v102.FlameShockDebuff:AuraActiveCount() >= v112)))) then
					if (v24(v102.FireNova) or ((2753 - 1457) >= (8859 - 4413))) then
						return "fire_nova aoe 10";
					end
				end
				v163 = 611 - (295 + 314);
			end
			if ((v163 == (12 - 7)) or ((3355 - (1300 + 662)) > (14095 - 9606))) then
				if ((v102.FireNova:IsReady() and v42 and (v102.FlameShockDebuff:AuraActiveCount() >= (1757 - (1178 + 577)))) or ((2298 + 2126) < (79 - 52))) then
					if (v24(v102.FireNova) or ((3402 - (851 + 554)) > (3374 + 441))) then
						return "fire_nova aoe 26";
					end
				end
				if (((9609 - 6144) > (4154 - 2241)) and v102.ElementalBlast:IsReady() and v41 and (not v102.ElementalSpirits:IsAvailable() or (v102.ElementalSpirits:IsAvailable() and ((v102.ElementalBlast:Charges() == v114) or (v120.FeralSpiritCount >= (304 - (115 + 187)))))) and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (4 + 1)) and (not v102.CrashingStorms:IsAvailable() or (v112 <= (3 + 0)))) then
					if (((2888 - 2155) < (2980 - (160 + 1001))) and v24(v102.ElementalBlast, not v15:IsSpellInRange(v102.ElementalBlast))) then
						return "elemental_blast aoe 27";
					end
				end
				if ((v102.ChainLightning:IsReady() and v39 and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (5 + 0))) or ((3033 + 1362) == (9734 - 4979))) then
					if (v24(v102.ChainLightning, not v15:IsSpellInRange(v102.ChainLightning)) or ((4151 - (237 + 121)) < (3266 - (525 + 372)))) then
						return "chain_lightning aoe 28";
					end
				end
				if ((v102.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (170 - 80)))) or ((13418 - 9334) == (407 - (96 + 46)))) then
					if (((5135 - (643 + 134)) == (1574 + 2784)) and v24(v102.WindfuryTotem)) then
						return "windfury_totem aoe 29";
					end
				end
				if ((v102.FlameShock:IsReady() and v43 and (v15:DebuffDown(v102.FlameShockDebuff))) or ((7524 - 4386) < (3686 - 2693))) then
					if (((3194 + 136) > (4558 - 2235)) and v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock aoe 30";
					end
				end
				v163 = 12 - 6;
			end
			if ((v163 == (721 - (316 + 403))) or ((2411 + 1215) == (10967 - 6978))) then
				if ((v102.LavaLash:IsReady() and v47 and (v102.LashingFlames:IsAvailable())) or ((332 + 584) == (6726 - 4055))) then
					local v238 = 0 + 0;
					while true do
						if (((88 + 184) == (942 - 670)) and (v238 == (0 - 0))) then
							if (((8826 - 4577) <= (278 + 4561)) and v118.CastCycle(v102.LavaLash, v111, v126, not v15:IsSpellInRange(v102.LavaLash))) then
								return "lava_lash aoe 11";
							end
							if (((5466 - 2689) < (157 + 3043)) and v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash))) then
								return "lava_lash aoe no_cycle 11";
							end
							break;
						end
					end
				end
				if (((279 - 184) < (1974 - (12 + 5))) and v102.LavaLash:IsReady() and v47 and ((v102.MoltenAssault:IsAvailable() and v15:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (23 - 17))) or (v102.AshenCatalyst:IsAvailable() and (v14:BuffStack(v102.AshenCatalystBuff) == (10 - 5))))) then
					if (((1755 - 929) < (4257 - 2540)) and v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash aoe 12";
					end
				end
				if (((290 + 1136) >= (3078 - (1656 + 317))) and v102.IceStrike:IsReady() and v45 and (v102.Hailstorm:IsAvailable())) then
					if (((2455 + 299) <= (2708 + 671)) and v24(v102.IceStrike, not v15:IsInMeleeRange(13 - 8))) then
						return "ice_strike aoe 13";
					end
				end
				if ((v102.FrostShock:IsReady() and v44 and v102.Hailstorm:IsAvailable() and v14:BuffUp(v102.HailstormBuff)) or ((19326 - 15399) == (1767 - (5 + 349)))) then
					if (v24(v102.FrostShock, not v15:IsSpellInRange(v102.FrostShock)) or ((5481 - 4327) <= (2059 - (266 + 1005)))) then
						return "frost_shock aoe 14";
					end
				end
				if ((v102.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v117)) or ((1083 + 560) > (11529 - 8150))) then
					if (v24(v102.Sundering, not v15:IsInRange(9 - 1)) or ((4499 - (561 + 1135)) > (5927 - 1378))) then
						return "sundering aoe 15";
					end
				end
				v163 = 9 - 6;
			end
			if ((v163 == (1066 - (507 + 559))) or ((552 - 332) >= (9345 - 6323))) then
				if (((3210 - (212 + 176)) == (3727 - (250 + 655))) and v102.CrashLightning:IsReady() and v40 and v102.CrashingStorms:IsAvailable() and ((v102.UnrulyWinds:IsAvailable() and (v112 >= (27 - 17))) or (v112 >= (26 - 11)))) then
					if (v24(v102.CrashLightning, not v15:IsInMeleeRange(12 - 4)) or ((3017 - (1869 + 87)) == (6440 - 4583))) then
						return "crash_lightning aoe 1";
					end
				end
				if (((4661 - (484 + 1417)) > (2923 - 1559)) and v102.LightningBolt:IsReady() and v48 and ((v102.FlameShockDebuff:AuraActiveCount() >= v112) or (v14:BuffRemains(v102.PrimordialWaveBuff) < (v14:GCD() * (4 - 1))) or (v102.FlameShockDebuff:AuraActiveCount() >= (779 - (48 + 725)))) and v14:BuffUp(v102.PrimordialWaveBuff) and (v14:BuffStack(v102.MaelstromWeaponBuff) == ((8 - 3) + ((13 - 8) * v25(v102.OverflowingMaelstrom:IsAvailable())))) and (v14:BuffDown(v102.SplinteredElementsBuff) or (v117 <= (7 + 5)) or (v100 <= v14:GCD()))) then
					if (v24(v102.LightningBolt, not v15:IsSpellInRange(v102.LightningBolt)) or ((13099 - 8197) <= (1007 + 2588))) then
						return "lightning_bolt aoe 2";
					end
				end
				if ((v102.LavaLash:IsReady() and v47 and v102.MoltenAssault:IsAvailable() and (v102.PrimordialWave:IsAvailable() or v102.FireNova:IsAvailable()) and v15:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (2 + 4))) or ((4705 - (152 + 701)) == (1604 - (430 + 881)))) then
					if (v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash)) or ((598 + 961) == (5483 - (557 + 338)))) then
						return "lava_lash aoe 3";
					end
				end
				if ((v102.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v117) and (v14:BuffDown(v102.PrimordialWaveBuff))) or ((1326 + 3158) == (2220 - 1432))) then
					local v239 = 0 - 0;
					while true do
						if (((12136 - 7568) >= (8420 - 4513)) and (v239 == (801 - (499 + 302)))) then
							if (((2112 - (39 + 827)) < (9579 - 6109)) and v118.CastCycle(v102.PrimordialWave, v111, v125, not v15:IsSpellInRange(v102.PrimordialWave))) then
								return "primordial_wave aoe 4";
							end
							if (((9084 - 5016) >= (3860 - 2888)) and v24(v102.PrimordialWave, not v15:IsSpellInRange(v102.PrimordialWave))) then
								return "primordial_wave aoe no_cycle 4";
							end
							break;
						end
					end
				end
				if (((756 - 263) < (334 + 3559)) and v102.FlameShock:IsReady() and v43 and (v102.PrimordialWave:IsAvailable() or v102.FireNova:IsAvailable()) and v15:DebuffDown(v102.FlameShockDebuff)) then
					if (v24(v102.FlameShock, not v15:IsSpellInRange(v102.FlameShock)) or ((4311 - 2838) >= (534 + 2798))) then
						return "flame_shock aoe 5";
					end
				end
				v163 = 1 - 0;
			end
			if ((v163 == (108 - (103 + 1))) or ((4605 - (475 + 79)) <= (2501 - 1344))) then
				if (((1932 - 1328) < (373 + 2508)) and v102.Windstrike:IsCastable() and v53) then
					if (v24(v102.Windstrike, not v15:IsSpellInRange(v102.Windstrike)) or ((793 + 107) == (4880 - (1395 + 108)))) then
						return "windstrike aoe 21";
					end
				end
				if (((12975 - 8516) > (1795 - (7 + 1197))) and v102.Stormstrike:IsReady() and v50) then
					if (((1482 + 1916) >= (836 + 1559)) and v24(v102.Stormstrike, not v15:IsSpellInRange(v102.Stormstrike))) then
						return "stormstrike aoe 22";
					end
				end
				if ((v102.IceStrike:IsReady() and v45) or ((2502 - (27 + 292)) >= (8275 - 5451))) then
					if (((2468 - 532) == (8119 - 6183)) and v24(v102.IceStrike, not v15:IsInMeleeRange(9 - 4))) then
						return "ice_strike aoe 23";
					end
				end
				if ((v102.LavaLash:IsReady() and v47) or ((9202 - 4370) < (4452 - (43 + 96)))) then
					if (((16675 - 12587) > (8758 - 4884)) and v24(v102.LavaLash, not v15:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash aoe 24";
					end
				end
				if (((3595 + 737) == (1224 + 3108)) and v102.CrashLightning:IsReady() and v40) then
					if (((7903 - 3904) >= (1112 + 1788)) and v24(v102.CrashLightning, not v15:IsInMeleeRange(14 - 6))) then
						return "crash_lightning aoe 25";
					end
				end
				v163 = 2 + 3;
			end
		end
	end
	local function v140()
		local v164 = 0 + 0;
		while true do
			if (((1752 - (1414 + 337)) == v164) or ((4465 - (1642 + 298)) > (10594 - 6530))) then
				if (((12574 - 8203) == (12971 - 8600)) and (not v107 or (v109 < (197455 + 402545))) and v54 and v102.FlametongueWeapon:IsCastable()) then
					if (v24(v102.FlametongueWeapon) or ((207 + 59) > (5958 - (357 + 615)))) then
						return "flametongue_weapon enchant";
					end
				end
				if (((1398 + 593) >= (2269 - 1344)) and v86) then
					v33 = v134();
					if (((390 + 65) < (4399 - 2346)) and v33) then
						return v33;
					end
				end
				v164 = 2 + 0;
			end
			if ((v164 == (1 + 1)) or ((520 + 306) == (6152 - (384 + 917)))) then
				if (((880 - (128 + 569)) == (1726 - (1407 + 136))) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) then
					if (((3046 - (687 + 1200)) <= (3498 - (556 + 1154))) and v24(v102.AncestralSpirit, nil, true)) then
						return "resurrection";
					end
				end
				if ((v118.TargetIsValid() and v34) or ((12337 - 8830) > (4413 - (9 + 86)))) then
					if (not v14:AffectingCombat() or ((3496 - (275 + 146)) <= (483 + 2482))) then
						local v246 = 64 - (29 + 35);
						while true do
							if (((6049 - 4684) <= (6006 - 3995)) and ((0 - 0) == v246)) then
								v33 = v137();
								if (v33 or ((1809 + 967) > (4587 - (53 + 959)))) then
									return v33;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v164 == (408 - (312 + 96))) or ((4432 - 1878) == (5089 - (147 + 138)))) then
				if (((3476 - (813 + 86)) == (2329 + 248)) and v76 and v102.EarthShield:IsCastable() and v14:BuffDown(v102.EarthShieldBuff) and ((v77 == "Earth Shield") or (v102.ElementalOrbit:IsAvailable() and v14:BuffUp(v102.LightningShield)))) then
					if (v24(v102.EarthShield) or ((10 - 4) >= (2381 - (18 + 474)))) then
						return "earth_shield main 2";
					end
				elseif (((171 + 335) <= (6175 - 4283)) and v76 and v102.LightningShield:IsCastable() and v14:BuffDown(v102.LightningShieldBuff) and ((v77 == "Lightning Shield") or (v102.ElementalOrbit:IsAvailable() and v14:BuffUp(v102.EarthShield)))) then
					if (v24(v102.LightningShield) or ((3094 - (860 + 226)) > (2521 - (121 + 182)))) then
						return "lightning_shield main 2";
					end
				end
				if (((47 + 332) <= (5387 - (988 + 252))) and (not v106 or (v108 < (67775 + 532225))) and v54 and v102.WindfuryWeapon:IsCastable()) then
					if (v24(v102.WindfuryWeapon) or ((1414 + 3100) <= (2979 - (49 + 1921)))) then
						return "windfury_weapon enchant";
					end
				end
				v164 = 891 - (223 + 667);
			end
		end
	end
	local function v141()
		v33 = v135();
		if (v33 or ((3548 - (51 + 1)) == (2051 - 859))) then
			return v33;
		end
		if (v94 or ((445 - 237) == (4084 - (146 + 979)))) then
			local v176 = 0 + 0;
			while true do
				if (((4882 - (311 + 294)) >= (3661 - 2348)) and (v176 == (1 + 0))) then
					if (((4030 - (496 + 947)) < (4532 - (1233 + 125))) and v90) then
						local v247 = 0 + 0;
						while true do
							if ((v247 == (0 + 0)) or ((783 + 3337) <= (3843 - (963 + 682)))) then
								v33 = v118.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 26 + 4);
								if (v33 or ((3100 - (504 + 1000)) == (578 + 280))) then
									return v33;
								end
								break;
							end
						end
					end
					if (((2933 + 287) == (304 + 2916)) and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (7 - 2)) and v91) then
						local v248 = 0 + 0;
						while true do
							if ((v248 == (0 + 0)) or ((1584 - (156 + 26)) > (2086 + 1534))) then
								v33 = v118.HandleAfflicted(v102.HealingSurge, v104.HealingSurgeMouseover, 62 - 22, true);
								if (((2738 - (149 + 15)) == (3534 - (890 + 70))) and v33) then
									return v33;
								end
								break;
							end
						end
					end
					break;
				end
				if (((1915 - (39 + 78)) < (3239 - (14 + 468))) and (v176 == (0 - 0))) then
					if (v88 or ((1053 - 676) > (1344 + 1260))) then
						v33 = v118.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 25 + 15);
						if (((121 + 447) < (412 + 499)) and v33) then
							return v33;
						end
					end
					if (((861 + 2424) < (8092 - 3864)) and v89) then
						local v249 = 0 + 0;
						while true do
							if (((13760 - 9844) > (85 + 3243)) and ((51 - (12 + 39)) == v249)) then
								v33 = v118.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 28 + 2);
								if (((7738 - 5238) < (13672 - 9833)) and v33) then
									return v33;
								end
								break;
							end
						end
					end
					v176 = 1 + 0;
				end
			end
		end
		if (((267 + 240) == (1285 - 778)) and v95) then
			v33 = v118.HandleIncorporeal(v102.Hex, v104.HexMouseOver, 20 + 10, true);
			if (((1159 - 919) <= (4875 - (1596 + 114))) and v33) then
				return v33;
			end
		end
		if (((2177 - 1343) >= (1518 - (164 + 549))) and v16) then
			if (v93 or ((5250 - (1059 + 379)) < (2875 - 559))) then
				v33 = v132();
				if (v33 or ((1375 + 1277) <= (259 + 1274))) then
					return v33;
				end
			end
		end
		if ((v102.GreaterPurge:IsAvailable() and v101 and v102.GreaterPurge:IsReady() and v38 and v92 and not v14:IsCasting() and not v14:IsChanneling() and v118.UnitHasMagicBuff(v15)) or ((3990 - (145 + 247)) < (1198 + 262))) then
			if (v24(v102.GreaterPurge, not v15:IsSpellInRange(v102.GreaterPurge)) or ((1902 + 2214) < (3533 - 2341))) then
				return "greater_purge damage";
			end
		end
		if ((v102.Purge:IsReady() and v101 and v38 and v92 and not v14:IsCasting() and not v14:IsChanneling() and v118.UnitHasMagicBuff(v15)) or ((648 + 2729) <= (778 + 125))) then
			if (((6455 - 2479) >= (1159 - (254 + 466))) and v24(v102.Purge, not v15:IsSpellInRange(v102.Purge))) then
				return "purge damage";
			end
		end
		v33 = v133();
		if (((4312 - (544 + 16)) == (11923 - 8171)) and v33) then
			return v33;
		end
		if (((4674 - (294 + 334)) > (2948 - (236 + 17))) and v118.TargetIsValid()) then
			local v177 = 0 + 0;
			local v178;
			while true do
				if ((v177 == (2 + 0)) or ((13350 - 9805) == (15136 - 11939))) then
					if (((1233 + 1161) > (308 + 65)) and v102.Ascendance:IsCastable() and v55 and ((v60 and v36) or not v60) and (v100 < v117) and v15:DebuffUp(v102.FlameShockDebuff) and (((v115 == "Lightning Bolt") and (v112 == (795 - (413 + 381)))) or ((v115 == "Chain Lightning") and (v112 > (1 + 0))))) then
						if (((8836 - 4681) <= (10992 - 6760)) and v24(v102.Ascendance)) then
							return "ascendance main 4";
						end
					end
					if ((v102.DoomWinds:IsCastable() and v57 and ((v62 and v36) or not v62) and (v100 < v117)) or ((5551 - (582 + 1388)) == (5916 - 2443))) then
						if (((3576 + 1419) > (3712 - (326 + 38))) and v24(v102.DoomWinds, not v15:IsInMeleeRange(14 - 9))) then
							return "doom_winds main 5";
						end
					end
					if ((v112 == (1 - 0)) or ((1374 - (47 + 573)) > (1313 + 2411))) then
						local v250 = 0 - 0;
						while true do
							if (((351 - 134) >= (1721 - (1269 + 395))) and (v250 == (492 - (76 + 416)))) then
								v33 = v138();
								if (v33 or ((2513 - (319 + 124)) >= (9228 - 5191))) then
									return v33;
								end
								break;
							end
						end
					end
					if (((3712 - (564 + 443)) == (7488 - 4783)) and v35 and (v112 > (459 - (337 + 121)))) then
						local v251 = 0 - 0;
						while true do
							if (((203 - 142) == (1972 - (1261 + 650))) and (v251 == (0 + 0))) then
								v33 = v139();
								if (v33 or ((1113 - 414) >= (3113 - (772 + 1045)))) then
									return v33;
								end
								break;
							end
						end
					end
					break;
				end
				if ((v177 == (0 + 0)) or ((1927 - (102 + 42)) >= (5460 - (1524 + 320)))) then
					v178 = v118.HandleDPSPotion(v14:BuffUp(v102.FeralSpiritBuff));
					if (v178 or ((5183 - (1049 + 221)) > (4683 - (18 + 138)))) then
						return v178;
					end
					if (((10711 - 6335) > (1919 - (67 + 1035))) and (v100 < v117)) then
						if (((5209 - (136 + 212)) > (3501 - 2677)) and v58 and ((v36 and v65) or not v65)) then
							local v253 = 0 + 0;
							while true do
								if ((v253 == (0 + 0)) or ((2987 - (240 + 1364)) >= (3213 - (1050 + 32)))) then
									v33 = v136();
									if (v33 or ((6698 - 4822) >= (1504 + 1037))) then
										return v33;
									end
									break;
								end
							end
						end
					end
					if (((2837 - (331 + 724)) <= (305 + 3467)) and (v100 < v117) and v59 and ((v66 and v36) or not v66)) then
						local v252 = 644 - (269 + 375);
						while true do
							if ((v252 == (725 - (267 + 458))) or ((1462 + 3238) < (1563 - 750))) then
								if (((4017 - (667 + 151)) < (5547 - (1410 + 87))) and v102.BloodFury:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (1947 - (1504 + 393))))) then
									if (v24(v102.BloodFury) or ((13382 - 8431) < (11493 - 7063))) then
										return "blood_fury racial";
									end
								end
								if (((892 - (461 + 335)) == (13 + 83)) and v102.Berserking:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff))) then
									if (v24(v102.Berserking) or ((4500 - (1730 + 31)) > (5675 - (728 + 939)))) then
										return "berserking racial";
									end
								end
								v252 = 3 - 2;
							end
							if ((v252 == (1 - 0)) or ((52 - 29) == (2202 - (138 + 930)))) then
								if ((v102.Fireblood:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (46 + 4)))) or ((2106 + 587) >= (3524 + 587))) then
									if (v24(v102.Fireblood) or ((17623 - 13307) <= (3912 - (459 + 1307)))) then
										return "fireblood racial";
									end
								end
								if ((v102.AncestralCall:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (1920 - (474 + 1396))))) or ((6191 - 2645) <= (2633 + 176))) then
									if (((17 + 4887) > (6204 - 4038)) and v24(v102.AncestralCall)) then
										return "ancestral_call racial";
									end
								end
								break;
							end
						end
					end
					v177 = 1 + 0;
				end
				if (((363 - 254) >= (392 - 302)) and ((592 - (562 + 29)) == v177)) then
					if (((4244 + 734) > (4324 - (374 + 1045))) and v102.TotemicProjection:IsCastable() and (v102.WindfuryTotem:TimeSinceLastCast() < (72 + 18)) and v14:BuffDown(v102.WindfuryTotemBuff, true)) then
						if (v24(v104.TotemicProjectionPlayer) or ((9396 - 6370) <= (2918 - (448 + 190)))) then
							return "totemic_projection wind_fury main 0";
						end
					end
					if ((v102.Windstrike:IsCastable() and v53) or ((534 + 1119) <= (501 + 607))) then
						if (((1896 + 1013) > (10031 - 7422)) and v24(v102.Windstrike, not v15:IsSpellInRange(v102.Windstrike))) then
							return "windstrike main 1";
						end
					end
					if (((2352 - 1595) > (1688 - (1307 + 187))) and v102.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v117) and (v14:HasTier(122 - 91, 4 - 2))) then
						if (v24(v102.PrimordialWave, not v15:IsSpellInRange(v102.PrimordialWave)) or ((94 - 63) >= (2081 - (232 + 451)))) then
							return "primordial_wave main 2";
						end
					end
					if (((3052 + 144) <= (4304 + 568)) and v102.FeralSpirit:IsCastable() and v56 and ((v61 and v36) or not v61) and (v100 < v117)) then
						if (((3890 - (510 + 54)) == (6701 - 3375)) and v24(v102.FeralSpirit)) then
							return "feral_spirit main 3";
						end
					end
					v177 = 38 - (13 + 23);
				end
			end
		end
	end
	local function v142()
		local v165 = 0 - 0;
		while true do
			if (((2058 - 625) <= (7045 - 3167)) and (v165 == (1092 - (830 + 258)))) then
				v48 = EpicSettings.Settings['useLightningBolt'];
				v49 = EpicSettings.Settings['usePrimordialWave'];
				v50 = EpicSettings.Settings['useStormStrike'];
				v165 = 17 - 12;
			end
			if (((5 + 2) == v165) or ((1347 + 236) == (3176 - (860 + 581)))) then
				v61 = EpicSettings.Settings['feralSpiritWithCD'];
				v64 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v63 = EpicSettings.Settings['sunderingWithMiniCD'];
				break;
			end
			if ((v165 == (0 - 0)) or ((2366 + 615) == (2591 - (237 + 4)))) then
				v55 = EpicSettings.Settings['useAscendance'];
				v57 = EpicSettings.Settings['useDoomWinds'];
				v56 = EpicSettings.Settings['useFeralSpirit'];
				v165 = 2 - 1;
			end
			if ((v165 == (6 - 3)) or ((8467 - 4001) <= (404 + 89))) then
				v45 = EpicSettings.Settings['useIceStrike'];
				v46 = EpicSettings.Settings['useLavaBurst'];
				v47 = EpicSettings.Settings['useLavaLash'];
				v165 = 3 + 1;
			end
			if ((v165 == (22 - 16)) or ((1093 + 1454) <= (1081 + 906))) then
				v54 = EpicSettings.Settings['useWeaponEnchant'];
				v60 = EpicSettings.Settings['ascendanceWithCD'];
				v62 = EpicSettings.Settings['doomWindsWithCD'];
				v165 = 1433 - (85 + 1341);
			end
			if (((5052 - 2091) > (7738 - 4998)) and (v165 == (373 - (45 + 327)))) then
				v39 = EpicSettings.Settings['useChainlightning'];
				v40 = EpicSettings.Settings['useCrashLightning'];
				v41 = EpicSettings.Settings['useElementalBlast'];
				v165 = 3 - 1;
			end
			if (((4198 - (444 + 58)) >= (1570 + 2042)) and (v165 == (1 + 1))) then
				v42 = EpicSettings.Settings['useFireNova'];
				v43 = EpicSettings.Settings['useFlameShock'];
				v44 = EpicSettings.Settings['useFrostShock'];
				v165 = 2 + 1;
			end
			if (((14 - 9) == v165) or ((4702 - (64 + 1668)) == (3851 - (1227 + 746)))) then
				v51 = EpicSettings.Settings['useSundering'];
				v53 = EpicSettings.Settings['useWindstrike'];
				v52 = EpicSettings.Settings['useWindfuryTotem'];
				v165 = 18 - 12;
			end
		end
	end
	local function v143()
		local v166 = 0 - 0;
		while true do
			if ((v166 == (494 - (415 + 79))) or ((95 + 3598) < (2468 - (142 + 349)))) then
				v67 = EpicSettings.Settings['useWindShear'];
				v68 = EpicSettings.Settings['useCapacitorTotem'];
				v69 = EpicSettings.Settings['useThunderstorm'];
				v166 = 1 + 0;
			end
			if (((9 - 2) == v166) or ((463 + 467) > (1481 + 620))) then
				v91 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
				break;
			end
			if (((11309 - 7156) > (4950 - (1710 + 154))) and (v166 == (322 - (200 + 118)))) then
				v83 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (0 + 0);
				v76 = EpicSettings.Settings['autoShield'];
				v77 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v166 = 8 - 3;
			end
			if ((v166 == (2 - 0)) or ((4136 + 518) <= (4007 + 43))) then
				v72 = EpicSettings.Settings['useHealingStreamTotem'];
				v79 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 + 0);
				v80 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
				v166 = 6 - 3;
			end
			if ((v166 == (1251 - (363 + 887))) or ((4542 - 1940) < (7120 - 5624))) then
				v71 = EpicSettings.Settings['useAncestralGuidance'];
				v70 = EpicSettings.Settings['useAstralShift'];
				v73 = EpicSettings.Settings['useMaelstromHealingSurge'];
				v166 = 1 + 1;
			end
			if ((v166 == (6 - 3)) or ((697 + 323) > (3952 - (674 + 990)))) then
				v78 = EpicSettings.Settings['astralShiftHP'] or (0 + 0);
				v81 = EpicSettings.Settings['healingStreamTotemHP'] or (0 + 0);
				v82 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 - 0);
				v166 = 1059 - (507 + 548);
			end
			if (((1165 - (289 + 548)) == (2146 - (821 + 997))) and ((261 - (195 + 60)) == v166)) then
				v88 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v89 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v90 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				v166 = 2 + 5;
			end
			if (((3012 - (251 + 1250)) < (11155 - 7347)) and ((4 + 1) == v166)) then
				v86 = EpicSettings.Settings['healOOC'];
				v87 = EpicSettings.Settings['healOOCHP'] or (1032 - (809 + 223));
				v101 = EpicSettings.Settings['usePurgeTarget'];
				v166 = 8 - 2;
			end
		end
	end
	local function v144()
		local v167 = 0 - 0;
		while true do
			if ((v167 == (9 - 6)) or ((1849 + 661) > (2576 + 2343))) then
				v84 = EpicSettings.Settings['healthstoneHP'] or (617 - (14 + 603));
				v85 = EpicSettings.Settings['healingPotionHP'] or (129 - (118 + 11));
				v96 = EpicSettings.Settings['HealingPotionName'] or "";
				v94 = EpicSettings.Settings['handleAfflicted'];
				v167 = 1 + 3;
			end
			if (((3968 + 795) == (13880 - 9117)) and (v167 == (949 - (551 + 398)))) then
				v100 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v97 = EpicSettings.Settings['InterruptWithStun'];
				v98 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v99 = EpicSettings.Settings['InterruptThreshold'];
				v167 = 1 + 0;
			end
			if (((3363 + 774) > (6872 - 5024)) and ((9 - 5) == v167)) then
				v95 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((790 + 1646) <= (12441 - 9307)) and (v167 == (1 + 0))) then
				v93 = EpicSettings.Settings['DispelDebuffs'];
				v92 = EpicSettings.Settings['DispelBuffs'];
				v58 = EpicSettings.Settings['useTrinkets'];
				v59 = EpicSettings.Settings['useRacials'];
				v167 = 91 - (40 + 49);
			end
			if (((14177 - 10454) == (4213 - (99 + 391))) and ((2 + 0) == v167)) then
				v65 = EpicSettings.Settings['trinketsWithCD'];
				v66 = EpicSettings.Settings['racialsWithCD'];
				v74 = EpicSettings.Settings['useHealthstone'];
				v75 = EpicSettings.Settings['useHealingPotion'];
				v167 = 13 - 10;
			end
		end
	end
	local function v145()
		local v168 = 0 - 0;
		while true do
			if ((v168 == (3 + 0)) or ((10646 - 6600) >= (5920 - (1032 + 572)))) then
				if (v35 or ((2425 - (203 + 214)) < (3746 - (568 + 1249)))) then
					local v240 = 0 + 0;
					while true do
						if (((5725 - 3341) > (6856 - 5081)) and ((1306 - (913 + 393)) == v240)) then
							v113 = #v110;
							v112 = #v111;
							break;
						end
					end
				else
					local v241 = 0 - 0;
					while true do
						if ((v241 == (0 - 0)) or ((4953 - (269 + 141)) <= (9732 - 5356))) then
							v113 = 1982 - (362 + 1619);
							v112 = 1626 - (950 + 675);
							break;
						end
					end
				end
				if (((281 + 447) == (1907 - (216 + 963))) and v38 and v93) then
					local v242 = 1287 - (485 + 802);
					while true do
						if ((v242 == (559 - (432 + 127))) or ((2149 - (1065 + 8)) > (2595 + 2076))) then
							if (((3452 - (635 + 966)) >= (272 + 106)) and v14:AffectingCombat() and v102.CleanseSpirit:IsAvailable()) then
								local v254 = 42 - (5 + 37);
								local v255;
								while true do
									if ((v254 == (0 - 0)) or ((811 + 1137) >= (5501 - 2025))) then
										v255 = v93 and v102.CleanseSpirit:IsReady() and v38;
										v33 = v118.FocusUnit(v255, v104, 10 + 10, nil, 51 - 26);
										v254 = 3 - 2;
									end
									if (((9040 - 4246) >= (1991 - 1158)) and (v254 == (1 + 0))) then
										if (((4619 - (318 + 211)) == (20124 - 16034)) and v33) then
											return v33;
										end
										break;
									end
								end
							end
							if (v102.CleanseSpirit:IsAvailable() or ((5345 - (963 + 624)) == (1068 + 1430))) then
								if ((v17 and v17:Exists() and v17:IsAPlayer() and v118.UnitHasCurseDebuff(v17)) or ((3519 - (518 + 328)) < (3671 - 2096))) then
									if (v102.CleanseSpirit:IsReady() or ((5947 - 2226) <= (1772 - (301 + 16)))) then
										if (((2737 - 1803) < (6375 - 4105)) and v24(v104.CleanseSpiritMouseover)) then
											return "cleanse_spirit mouseover";
										end
									end
								end
							end
							break;
						end
					end
				end
				if (v118.TargetIsValid() or v14:AffectingCombat() or ((4206 - 2594) == (1137 + 118))) then
					local v243 = 0 + 0;
					while true do
						if ((v243 == (1 - 0)) or ((2619 + 1733) < (401 + 3805))) then
							if ((v117 == (35325 - 24214)) or ((924 + 1936) <= (1200 - (829 + 190)))) then
								v117 = v10.FightRemains(v111, false);
							end
							break;
						end
						if (((11495 - 8273) >= (1931 - 404)) and (v243 == (0 - 0))) then
							v116 = v10.BossFightRemains(nil, true);
							v117 = v116;
							v243 = 2 - 1;
						end
					end
				end
				if (((357 + 1148) <= (693 + 1428)) and v14:AffectingCombat()) then
					if (((2258 - 1514) == (703 + 41)) and v14:PrevGCD(614 - (520 + 93), v102.ChainLightning)) then
						v115 = "Chain Lightning";
					elseif (v14:PrevGCD(277 - (259 + 17), v102.LightningBolt) or ((114 + 1865) >= (1021 + 1815))) then
						v115 = "Lightning Bolt";
					end
				end
				v168 = 13 - 9;
			end
			if (((2424 - (396 + 195)) <= (7740 - 5072)) and ((1762 - (440 + 1321)) == v168)) then
				v35 = EpicSettings.Toggles['aoe'];
				v36 = EpicSettings.Toggles['cds'];
				v38 = EpicSettings.Toggles['dispel'];
				v37 = EpicSettings.Toggles['minicds'];
				v168 = 1831 - (1059 + 770);
			end
			if (((17044 - 13358) == (4231 - (424 + 121))) and (v168 == (1 + 3))) then
				if (((4814 - (641 + 706)) > (189 + 288)) and not v14:IsChanneling() and not v14:IsChanneling()) then
					local v244 = 440 - (249 + 191);
					while true do
						if ((v244 == (0 - 0)) or ((1469 + 1819) >= (13647 - 10106))) then
							if (v94 or ((3984 - (183 + 244)) == (223 + 4317))) then
								if (v88 or ((991 - (434 + 296)) > (4042 - 2775))) then
									local v257 = 512 - (169 + 343);
									while true do
										if (((1116 + 156) < (6788 - 2930)) and (v257 == (0 - 0))) then
											v33 = v118.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 33 + 7);
											if (((10391 - 6727) == (4787 - (651 + 472))) and v33) then
												return v33;
											end
											break;
										end
									end
								end
								if (((1467 + 474) >= (195 + 255)) and v89) then
									local v258 = 0 - 0;
									while true do
										if ((v258 == (483 - (397 + 86))) or ((5522 - (423 + 453)) < (33 + 291))) then
											v33 = v118.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 4 + 26);
											if (((3347 + 486) == (3059 + 774)) and v33) then
												return v33;
											end
											break;
										end
									end
								end
								if (v90 or ((1108 + 132) > (4560 - (50 + 1140)))) then
									local v259 = 0 + 0;
									while true do
										if ((v259 == (0 + 0)) or ((155 + 2326) == (6723 - 2041))) then
											v33 = v118.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 22 + 8);
											if (((5323 - (157 + 439)) >= (361 - 153)) and v33) then
												return v33;
											end
											break;
										end
									end
								end
								if (((930 - 650) < (11391 - 7540)) and (v14:BuffStack(v102.MaelstromWeaponBuff) >= (923 - (782 + 136))) and v91) then
									local v260 = 855 - (112 + 743);
									while true do
										if ((v260 == (1171 - (1026 + 145))) or ((517 + 2490) > (3912 - (493 + 225)))) then
											v33 = v118.HandleAfflicted(v102.HealingSurge, v104.HealingSurgeMouseover, 147 - 107, true);
											if (v33 or ((1300 + 836) >= (7898 - 4952))) then
												return v33;
											end
											break;
										end
									end
								end
							end
							if (((42 + 2123) <= (7204 - 4683)) and v14:AffectingCombat()) then
								local v256 = 0 + 0;
								while true do
									if (((4779 - 1918) > (2256 - (210 + 1385))) and (v256 == (1689 - (1201 + 488)))) then
										v33 = v141();
										if (((2805 + 1720) > (8036 - 3517)) and v33) then
											return v33;
										end
										break;
									end
								end
							else
								v33 = v140();
								if (((5699 - 2521) > (1557 - (352 + 233))) and v33) then
									return v33;
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((11518 - 6752) == (2593 + 2173)) and (v168 == (5 - 3))) then
				if (v14:IsDeadOrGhost() or ((3319 - (489 + 85)) > (4629 - (277 + 1224)))) then
					return v33;
				end
				v106, v108, _, _, v107, v109 = v27();
				v110 = v14:GetEnemiesInRange(1533 - (663 + 830));
				v111 = v14:GetEnemiesInMeleeRange(9 + 1);
				v168 = 6 - 3;
			end
			if ((v168 == (875 - (461 + 414))) or ((192 + 952) >= (1843 + 2763))) then
				v143();
				v142();
				v144();
				v34 = EpicSettings.Toggles['ooc'];
				v168 = 1 + 0;
			end
		end
	end
	local function v146()
		v102.FlameShockDebuff:RegisterAuraTracking();
		v122();
		v21.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(260 + 3, v145, v146);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

