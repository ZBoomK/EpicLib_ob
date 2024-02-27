local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((9984 - 5406) <= (906 + 1102))) then
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
	local v114 = (v102.LavaBurst:IsAvailable() and (1 + 1)) or (2 - 1);
	local v115 = "Lightning Bolt";
	local v116 = 18802 - 7691;
	local v117 = 12210 - (35 + 1064);
	local v118 = v20.Commons.Everyone;
	v20.Commons.Shaman = {};
	local v120 = v20.Commons.Shaman;
	v120.FeralSpiritCount = 0 + 0;
	v9:RegisterForEvent(function()
		v114 = (v102.LavaBurst:IsAvailable() and (4 - 2)) or (1 + 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v9:RegisterForEvent(function()
		v115 = "Lightning Bolt";
		v116 = 12347 - (298 + 938);
		v117 = 12370 - (233 + 1026);
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForSelfCombatEvent(function(...)
		local v143 = 1666 - (636 + 1030);
		local v144;
		local v145;
		local v146;
		while true do
			if (((576 + 549) <= (2028 + 48)) and (v143 == (1 + 0))) then
				if ((v13:HasTier(3 + 28, 223 - (55 + 166)) and (v144 == v13:GUID()) and (v146 == (72863 + 303119))) or ((75 + 668) >= (16799 - 12400))) then
					v120.FeralSpiritCount = v120.FeralSpiritCount + (298 - (36 + 261));
					v31.After(25 - 10, function()
						v120.FeralSpiritCount = v120.FeralSpiritCount - (1369 - (34 + 1334));
					end);
				end
				if (((445 + 710) < (1300 + 373)) and (v144 == v13:GUID()) and (v146 == (52816 - (1035 + 248)))) then
					local v230 = 21 - (20 + 1);
					while true do
						if ((v230 == (0 + 0)) or ((2643 - (134 + 185)) <= (1711 - (549 + 584)))) then
							v120.FeralSpiritCount = v120.FeralSpiritCount + (687 - (314 + 371));
							v31.After(51 - 36, function()
								v120.FeralSpiritCount = v120.FeralSpiritCount - (970 - (478 + 490));
							end);
							break;
						end
					end
				end
				break;
			end
			if (((1996 + 1771) == (4939 - (786 + 386))) and (v143 == (0 - 0))) then
				v144, v145, v145, v145, v145, v145, v145, v145, v146 = select(1383 - (1055 + 324), ...);
				if (((5429 - (1093 + 247)) == (3634 + 455)) and (v144 == v13:GUID()) and (v146 == (20153 + 171481))) then
					v120.LastSKCast = v30();
				end
				v143 = 3 - 2;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	local function v122()
		if (((15129 - 10671) >= (4762 - 3088)) and v102.CleanseSpirit:IsAvailable()) then
			v118.DispellableDebuffs = v118.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123()
		for v175 = 2 - 1, 3 + 3, 3 - 2 do
			if (((3350 - 2378) <= (1070 + 348)) and v29(v13:TotemName(v175), "Totem")) then
				return v175;
			end
		end
	end
	local function v124()
		local v147 = 0 - 0;
		local v148;
		while true do
			if ((v147 == (689 - (364 + 324))) or ((13536 - 8598) < (11426 - 6664))) then
				if ((v148 > (3 + 5)) or (v148 > v102.FeralSpirit:TimeSinceLastCast()) or ((10477 - 7973) > (6828 - 2564))) then
					return 0 - 0;
				end
				return (1276 - (1249 + 19)) - v148;
			end
			if (((1944 + 209) == (8380 - 6227)) and (v147 == (1086 - (686 + 400)))) then
				if (not v102.AlphaWolf:IsAvailable() or v13:BuffDown(v102.FeralSpiritBuff) or ((398 + 109) >= (2820 - (73 + 156)))) then
					return 0 + 0;
				end
				v148 = v28(v102.CrashLightning:TimeSinceLastCast(), v102.ChainLightning:TimeSinceLastCast());
				v147 = 812 - (721 + 90);
			end
		end
	end
	local function v125(v149)
		return (v149:DebuffRefreshable(v102.FlameShockDebuff));
	end
	local function v126(v150)
		return (v150:DebuffRefreshable(v102.LashingFlamesDebuff));
	end
	local v127 = 0 + 0;
	local function v128()
		if (((14549 - 10068) == (4951 - (224 + 246))) and v102.CleanseSpirit:IsReady() and v37 and v118.DispellableFriendlyUnit(40 - 15)) then
			if ((v127 == (0 - 0)) or ((423 + 1905) < (17 + 676))) then
				v127 = v30();
			end
			if (((3179 + 1149) == (8604 - 4276)) and v118.Wait(1663 - 1163, v127)) then
				local v225 = 513 - (203 + 310);
				while true do
					if (((3581 - (1238 + 755)) >= (94 + 1238)) and (v225 == (1534 - (709 + 825)))) then
						if (v23(v104.CleanseSpiritFocus) or ((7691 - 3517) > (6187 - 1939))) then
							return "cleanse_spirit dispel";
						end
						v127 = 864 - (196 + 668);
						break;
					end
				end
			end
		end
	end
	local function v129()
		local v151 = 0 - 0;
		while true do
			if ((v151 == (0 - 0)) or ((5419 - (171 + 662)) <= (175 - (4 + 89)))) then
				if (((13539 - 9676) == (1407 + 2456)) and (not v15 or not v15:Exists() or not v15:IsInRange(175 - 135))) then
					return;
				end
				if (v15 or ((111 + 171) <= (1528 - (35 + 1451)))) then
					if (((6062 - (28 + 1425)) >= (2759 - (941 + 1052))) and (v15:HealthPercentage() <= v82) and v72 and v102.HealingSurge:IsReady() and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (5 + 0))) then
						if (v23(v104.HealingSurgeFocus) or ((2666 - (822 + 692)) == (3551 - 1063))) then
							return "healing_surge heal focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v130()
		if (((1612 + 1810) > (3647 - (45 + 252))) and (v13:HealthPercentage() <= v86)) then
			if (((868 + 9) > (130 + 246)) and v102.HealingSurge:IsReady()) then
				if (v23(v102.HealingSurge) or ((7588 - 4470) <= (2284 - (114 + 319)))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v131()
		if ((v102.AstralShift:IsReady() and v69 and (v13:HealthPercentage() <= v77)) or ((236 - 71) >= (4474 - 982))) then
			if (((2518 + 1431) < (7234 - 2378)) and v23(v102.AstralShift)) then
				return "astral_shift defensive 1";
			end
		end
		if ((v102.AncestralGuidance:IsReady() and v70 and v118.AreUnitsBelowHealthPercentage(v78, v79)) or ((8958 - 4682) < (4979 - (556 + 1407)))) then
			if (((5896 - (741 + 465)) > (4590 - (170 + 295))) and v23(v102.AncestralGuidance)) then
				return "ancestral_guidance defensive 2";
			end
		end
		if ((v102.HealingStreamTotem:IsReady() and v71 and v118.AreUnitsBelowHealthPercentage(v80, v81)) or ((27 + 23) >= (824 + 72))) then
			if (v23(v102.HealingStreamTotem) or ((4219 - 2505) >= (2453 + 505))) then
				return "healing_stream_totem defensive 3";
			end
		end
		if ((v102.HealingSurge:IsReady() and v72 and (v13:HealthPercentage() <= v82) and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (4 + 1))) or ((845 + 646) < (1874 - (957 + 273)))) then
			if (((189 + 515) < (396 + 591)) and v23(v102.HealingSurge)) then
				return "healing_surge defensive 4";
			end
		end
		if (((14167 - 10449) > (5022 - 3116)) and v103.Healthstone:IsReady() and v73 and (v13:HealthPercentage() <= v83)) then
			if (v23(v104.Healthstone) or ((2926 - 1968) > (17999 - 14364))) then
				return "healthstone defensive 3";
			end
		end
		if (((5281 - (389 + 1391)) <= (2819 + 1673)) and v74 and (v13:HealthPercentage() <= v84)) then
			local v178 = 0 + 0;
			while true do
				if ((v178 == (0 - 0)) or ((4393 - (783 + 168)) < (8551 - 6003))) then
					if (((2828 + 47) >= (1775 - (309 + 2))) and (v95 == "Refreshing Healing Potion")) then
						if (v103.RefreshingHealingPotion:IsReady() or ((14730 - 9933) >= (6105 - (1090 + 122)))) then
							if (v23(v104.RefreshingHealingPotion) or ((179 + 372) > (6945 - 4877))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((1447 + 667) > (2062 - (628 + 490))) and (v95 == "Dreamwalker's Healing Potion")) then
						if (v103.DreamwalkersHealingPotion:IsReady() or ((406 + 1856) >= (7665 - 4569))) then
							if (v23(v104.RefreshingHealingPotion) or ((10305 - 8050) >= (4311 - (431 + 343)))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v132()
		local v152 = 0 - 0;
		while true do
			if ((v152 == (2 - 1)) or ((3032 + 805) < (168 + 1138))) then
				v32 = v118.HandleBottomTrinket(v105, v35, 1735 - (556 + 1139), nil);
				if (((2965 - (6 + 9)) == (541 + 2409)) and v32) then
					return v32;
				end
				break;
			end
			if ((v152 == (0 + 0)) or ((4892 - (28 + 141)) < (1278 + 2020))) then
				v32 = v118.HandleTopTrinket(v105, v35, 49 - 9, nil);
				if (((805 + 331) >= (1471 - (486 + 831))) and v32) then
					return v32;
				end
				v152 = 2 - 1;
			end
		end
	end
	local function v133()
		local v153 = 0 - 0;
		while true do
			if ((v153 == (1 + 1)) or ((856 - 585) > (6011 - (668 + 595)))) then
				if (((4266 + 474) >= (636 + 2516)) and v102.Stormstrike:IsReady() and v49) then
					if (v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike)) or ((7030 - 4452) >= (3680 - (23 + 267)))) then
						return "stormstrike precombat 12";
					end
				end
				break;
			end
			if (((1985 - (1129 + 815)) <= (2048 - (371 + 16))) and ((1750 - (1326 + 424)) == v153)) then
				if (((1138 - 537) < (13009 - 9449)) and v102.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (208 - (88 + 30))))) then
					if (((1006 - (720 + 51)) < (1528 - 841)) and v23(v102.WindfuryTotem)) then
						return "windfury_totem precombat 4";
					end
				end
				if (((6325 - (421 + 1355)) > (1901 - 748)) and v102.FeralSpirit:IsCastable() and v55 and ((v60 and v35) or not v60)) then
					if (v23(v102.FeralSpirit) or ((2296 + 2378) < (5755 - (286 + 797)))) then
						return "feral_spirit precombat 6";
					end
				end
				v153 = 3 - 2;
			end
			if (((6075 - 2407) < (5000 - (397 + 42))) and (v153 == (1 + 0))) then
				if ((v102.DoomWinds:IsCastable() and v56 and ((v61 and v35) or not v61)) or ((1255 - (24 + 776)) == (5553 - 1948))) then
					if (v23(v102.DoomWinds, not v14:IsSpellInRange(v102.DoomWinds)) or ((3448 - (222 + 563)) == (7296 - 3984))) then
						return "doom_winds precombat 8";
					end
				end
				if (((3080 + 1197) <= (4665 - (23 + 167))) and v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62)) then
					if (v23(v102.Sundering, not v14:IsInRange(1803 - (690 + 1108))) or ((314 + 556) == (981 + 208))) then
						return "sundering precombat 10";
					end
				end
				v153 = 850 - (40 + 808);
			end
		end
	end
	local function v134()
		local v154 = 0 + 0;
		while true do
			if (((5938 - 4385) <= (2995 + 138)) and (v154 == (2 + 1))) then
				if ((v102.LavaBurst:IsReady() and v45 and not v102.ThorimsInvocation:IsAvailable() and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (3 + 2))) or ((2808 - (47 + 524)) >= (2279 + 1232))) then
					if (v23(v102.LavaBurst, not v14:IsSpellInRange(v102.LavaBurst)) or ((3619 - 2295) > (4515 - 1495))) then
						return "lava_burst single 13";
					end
				end
				if ((v102.LightningBolt:IsReady() and v47 and ((v13:BuffStack(v102.MaelstromWeaponBuff) >= (17 - 9)) or (v102.StaticAccumulation:IsAvailable() and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (1731 - (1165 + 561))))) and v13:BuffDown(v102.PrimordialWaveBuff)) or ((89 + 2903) == (5825 - 3944))) then
					if (((1186 + 1920) > (2005 - (341 + 138))) and v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt))) then
						return "lightning_bolt single 14";
					end
				end
				if (((817 + 2206) < (7986 - 4116)) and v102.CrashLightning:IsReady() and v39 and v102.AlphaWolf:IsAvailable() and v13:BuffUp(v102.FeralSpiritBuff) and (v124() == (326 - (89 + 237)))) then
					if (((459 - 316) > (155 - 81)) and v23(v102.CrashLightning, not v14:IsInMeleeRange(889 - (581 + 300)))) then
						return "crash_lightning single 15";
					end
				end
				if (((1238 - (855 + 365)) < (5016 - 2904)) and v102.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v117)) then
					if (((359 + 738) <= (2863 - (1030 + 205))) and v23(v102.PrimordialWave, not v14:IsSpellInRange(v102.PrimordialWave))) then
						return "primordial_wave single 16";
					end
				end
				v154 = 4 + 0;
			end
			if (((4308 + 322) == (4916 - (156 + 130))) and (v154 == (13 - 7))) then
				if (((5966 - 2426) > (5494 - 2811)) and v102.Stormstrike:IsReady() and v49) then
					if (((1264 + 3530) >= (1910 + 1365)) and v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike))) then
						return "stormstrike single 25";
					end
				end
				if (((1553 - (10 + 59)) == (420 + 1064)) and v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v117)) then
					if (((7052 - 5620) < (4718 - (671 + 492))) and v23(v102.Sundering, not v14:IsInRange(7 + 1))) then
						return "sundering single 26";
					end
				end
				if ((v102.BagofTricks:IsReady() and v58 and ((v65 and v35) or not v65)) or ((2280 - (369 + 846)) > (948 + 2630))) then
					if (v23(v102.BagofTricks) or ((4093 + 702) < (3352 - (1036 + 909)))) then
						return "bag_of_tricks single 27";
					end
				end
				if (((1474 + 379) < (8080 - 3267)) and v102.FireNova:IsReady() and v41 and v102.SwirlingMaelstrom:IsAvailable() and v14:DebuffUp(v102.FlameShockDebuff) and (v13:BuffStack(v102.MaelstromWeaponBuff) < ((208 - (11 + 192)) + ((3 + 2) * v24(v102.OverflowingMaelstrom:IsAvailable()))))) then
					if (v23(v102.FireNova) or ((2996 - (135 + 40)) < (5889 - 3458))) then
						return "fire_nova single 28";
					end
				end
				v154 = 5 + 2;
			end
			if ((v154 == (8 - 4)) or ((4307 - 1433) < (2357 - (50 + 126)))) then
				if ((v102.FlameShock:IsReady() and v42 and (v14:DebuffDown(v102.FlameShockDebuff))) or ((7487 - 4798) <= (76 + 267))) then
					if (v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock)) or ((3282 - (1233 + 180)) == (2978 - (522 + 447)))) then
						return "flame_shock single 17";
					end
				end
				if ((v102.IceStrike:IsReady() and v44 and v102.ElementalAssault:IsAvailable() and v102.SwirlingMaelstrom:IsAvailable()) or ((4967 - (107 + 1314)) < (1078 + 1244))) then
					if (v23(v102.IceStrike, not v14:IsInMeleeRange(15 - 10)) or ((885 + 1197) == (9478 - 4705))) then
						return "ice_strike single 18";
					end
				end
				if (((12835 - 9591) > (2965 - (716 + 1194))) and v102.LavaLash:IsReady() and v46 and (v102.LashingFlames:IsAvailable())) then
					if (v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash)) or ((57 + 3256) <= (191 + 1587))) then
						return "lava_lash single 19";
					end
				end
				if ((v102.IceStrike:IsReady() and v44 and (v13:BuffDown(v102.IceStrikeBuff))) or ((1924 - (74 + 429)) >= (4058 - 1954))) then
					if (((899 + 913) <= (7436 - 4187)) and v23(v102.IceStrike, not v14:IsInMeleeRange(4 + 1))) then
						return "ice_strike single 20";
					end
				end
				v154 = 15 - 10;
			end
			if (((4012 - 2389) <= (2390 - (279 + 154))) and (v154 == (786 - (454 + 324)))) then
				if (((3472 + 940) == (4429 - (12 + 5))) and v102.FlameShock:IsReady() and v42) then
					if (((944 + 806) >= (2145 - 1303)) and v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock single 34";
					end
				end
				if (((1616 + 2756) > (2943 - (277 + 816))) and v102.ChainLightning:IsReady() and v38 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (21 - 16)) and v13:BuffUp(v102.CracklingThunderBuff) and v102.ElementalSpirits:IsAvailable()) then
					if (((1415 - (1058 + 125)) < (154 + 667)) and v23(v102.ChainLightning, not v14:IsSpellInRange(v102.ChainLightning))) then
						return "chain_lightning single 35";
					end
				end
				if (((1493 - (815 + 160)) < (3870 - 2968)) and v102.LightningBolt:IsReady() and v47 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (11 - 6)) and v13:BuffDown(v102.PrimordialWaveBuff)) then
					if (((715 + 2279) > (2508 - 1650)) and v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt))) then
						return "lightning_bolt single 36";
					end
				end
				if ((v102.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (1988 - (41 + 1857))))) or ((5648 - (1222 + 671)) <= (2364 - 1449))) then
					if (((5671 - 1725) > (4925 - (229 + 953))) and v23(v102.WindfuryTotem)) then
						return "windfury_totem single 37";
					end
				end
				break;
			end
			if (((1774 - (1111 + 663)) == v154) or ((2914 - (874 + 705)) >= (463 + 2843))) then
				if (((3305 + 1539) > (4683 - 2430)) and v102.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v117) and v14:DebuffDown(v102.FlameShockDebuff) and v102.LashingFlames:IsAvailable()) then
					if (((13 + 439) == (1131 - (642 + 37))) and v23(v102.PrimordialWave, not v14:IsSpellInRange(v102.PrimordialWave))) then
						return "primordial_wave single 1";
					end
				end
				if ((v102.FlameShock:IsReady() and v42 and v14:DebuffDown(v102.FlameShockDebuff) and v102.LashingFlames:IsAvailable()) or ((1040 + 3517) < (334 + 1753))) then
					if (((9726 - 5852) == (4328 - (233 + 221))) and v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock single 2";
					end
				end
				if ((v102.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (11 - 6)) and v102.ElementalSpirits:IsAvailable() and (v120.FeralSpiritCount >= (4 + 0))) or ((3479 - (718 + 823)) > (3106 + 1829))) then
					if (v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast)) or ((5060 - (266 + 539)) < (9690 - 6267))) then
						return "elemental_blast single 3";
					end
				end
				if (((2679 - (636 + 589)) <= (5912 - 3421)) and v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v117) and (v13:HasTier(61 - 31, 2 + 0))) then
					if (v23(v102.Sundering, not v14:IsInRange(3 + 5)) or ((5172 - (657 + 358)) <= (7421 - 4618))) then
						return "sundering single 4";
					end
				end
				v154 = 2 - 1;
			end
			if (((6040 - (1151 + 36)) >= (2880 + 102)) and ((1 + 1) == v154)) then
				if (((12345 - 8211) > (5189 - (1552 + 280))) and v102.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (839 - (64 + 770))) and (v102.ElementalBlast:Charges() == v114)) then
					if (v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast)) or ((2320 + 1097) < (5752 - 3218))) then
						return "elemental_blast single 9";
					end
				end
				if ((v102.LightningBolt:IsReady() and v47 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (2 + 6)) and v13:BuffUp(v102.PrimordialWaveBuff) and (v13:BuffDown(v102.SplinteredElementsBuff) or (v117 <= (1255 - (157 + 1086))))) or ((5447 - 2725) <= (718 - 554))) then
					if (v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt)) or ((3693 - 1285) < (2877 - 768))) then
						return "lightning_bolt single 10";
					end
				end
				if ((v102.ChainLightning:IsReady() and v38 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (827 - (599 + 220))) and v13:BuffUp(v102.CracklingThunderBuff) and v102.ElementalSpirits:IsAvailable()) or ((65 - 32) == (3386 - (1813 + 118)))) then
					if (v23(v102.ChainLightning, not v14:IsSpellInRange(v102.ChainLightning)) or ((324 + 119) >= (5232 - (841 + 376)))) then
						return "chain_lightning single 11";
					end
				end
				if (((4738 - 1356) > (39 + 127)) and v102.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (21 - 13)) and ((v120.FeralSpiritCount >= (861 - (464 + 395))) or not v102.ElementalSpirits:IsAvailable())) then
					if (v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast)) or ((718 - 438) == (1470 + 1589))) then
						return "elemental_blast single 12";
					end
				end
				v154 = 840 - (467 + 370);
			end
			if (((3886 - 2005) > (950 + 343)) and (v154 == (23 - 16))) then
				if (((368 + 1989) == (5483 - 3126)) and v102.LightningBolt:IsReady() and v47 and v102.Hailstorm:IsAvailable() and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (525 - (150 + 370))) and v13:BuffDown(v102.PrimordialWaveBuff)) then
					if (((1405 - (74 + 1208)) == (302 - 179)) and v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt))) then
						return "lightning_bolt single 29";
					end
				end
				if ((v102.FrostShock:IsReady() and v43) or ((5008 - 3952) >= (2414 + 978))) then
					if (v23(v102.FrostShock, not v14:IsSpellInRange(v102.FrostShock)) or ((1471 - (14 + 376)) < (1864 - 789))) then
						return "frost_shock single 30";
					end
				end
				if ((v102.CrashLightning:IsReady() and v39) or ((679 + 370) >= (3894 + 538))) then
					if (v23(v102.CrashLightning, not v14:IsInMeleeRange(8 + 0)) or ((13970 - 9202) <= (637 + 209))) then
						return "crash_lightning single 31";
					end
				end
				if ((v102.FireNova:IsReady() and v41 and (v14:DebuffUp(v102.FlameShockDebuff))) or ((3436 - (23 + 55)) <= (3365 - 1945))) then
					if (v23(v102.FireNova) or ((2496 + 1243) <= (2699 + 306))) then
						return "fire_nova single 32";
					end
				end
				v154 = 11 - 3;
			end
			if ((v154 == (2 + 3)) or ((2560 - (652 + 249)) >= (5710 - 3576))) then
				if ((v102.FrostShock:IsReady() and v43 and (v13:BuffUp(v102.HailstormBuff))) or ((5128 - (708 + 1160)) < (6392 - 4037))) then
					if (v23(v102.FrostShock, not v14:IsSpellInRange(v102.FrostShock)) or ((1219 - 550) == (4250 - (10 + 17)))) then
						return "frost_shock single 21";
					end
				end
				if ((v102.LavaLash:IsReady() and v46) or ((381 + 1311) < (2320 - (1400 + 332)))) then
					if (v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash)) or ((9200 - 4403) < (5559 - (242 + 1666)))) then
						return "lava_lash single 22";
					end
				end
				if ((v102.IceStrike:IsReady() and v44) or ((1788 + 2389) > (1778 + 3072))) then
					if (v23(v102.IceStrike, not v14:IsInMeleeRange(5 + 0)) or ((1340 - (850 + 90)) > (1945 - 834))) then
						return "ice_strike single 23";
					end
				end
				if (((4441 - (360 + 1030)) > (890 + 115)) and v102.Windstrike:IsCastable() and v52) then
					if (((10423 - 6730) <= (6028 - 1646)) and v23(v102.Windstrike, not v14:IsSpellInRange(v102.Windstrike))) then
						return "windstrike single 24";
					end
				end
				v154 = 1667 - (909 + 752);
			end
			if ((v154 == (1224 - (109 + 1114))) or ((6008 - 2726) > (1596 + 2504))) then
				if ((v102.LightningBolt:IsReady() and v47 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (247 - (6 + 236))) and v13:BuffDown(v102.CracklingThunderBuff) and v13:BuffUp(v102.AscendanceBuff) and (v115 == "Chain Lightning") and (v13:BuffRemains(v102.AscendanceBuff) > (v102.ChainLightning:CooldownRemains() + v13:GCD()))) or ((2256 + 1324) < (2290 + 554))) then
					if (((209 - 120) < (7842 - 3352)) and v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt))) then
						return "lightning_bolt single 5";
					end
				end
				if ((v102.Stormstrike:IsReady() and v49 and (v13:BuffUp(v102.DoomWindsBuff) or v102.DeeplyRootedElements:IsAvailable() or (v102.Stormblast:IsAvailable() and v13:BuffUp(v102.StormbringerBuff)))) or ((6116 - (1076 + 57)) < (298 + 1510))) then
					if (((4518 - (579 + 110)) > (298 + 3471)) and v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike))) then
						return "stormstrike single 6";
					end
				end
				if (((1313 + 172) <= (1542 + 1362)) and v102.LavaLash:IsReady() and v46 and (v13:BuffUp(v102.HotHandBuff))) then
					if (((4676 - (174 + 233)) == (11924 - 7655)) and v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash single 7";
					end
				end
				if (((678 - 291) <= (1238 + 1544)) and v102.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v102.WindfuryTotemBuff, true))) then
					if (v23(v102.WindfuryTotem) or ((3073 - (663 + 511)) <= (819 + 98))) then
						return "windfury_totem single 8";
					end
				end
				v154 = 1 + 1;
			end
		end
	end
	local function v135()
		local v155 = 0 - 0;
		while true do
			if ((v155 == (0 + 0)) or ((10151 - 5839) <= (2120 - 1244))) then
				if (((1066 + 1166) <= (5052 - 2456)) and v102.CrashLightning:IsReady() and v39 and v102.CrashingStorms:IsAvailable() and ((v102.UnrulyWinds:IsAvailable() and (v112 >= (8 + 2))) or (v112 >= (2 + 13)))) then
					if (((2817 - (478 + 244)) < (4203 - (440 + 77))) and v23(v102.CrashLightning, not v14:IsInMeleeRange(4 + 4))) then
						return "crash_lightning aoe 1";
					end
				end
				if ((v102.LightningBolt:IsReady() and v47 and ((v102.FlameShockDebuff:AuraActiveCount() >= v112) or (v13:BuffRemains(v102.PrimordialWaveBuff) < (v13:GCD() * (10 - 7))) or (v102.FlameShockDebuff:AuraActiveCount() >= (1562 - (655 + 901)))) and v13:BuffUp(v102.PrimordialWaveBuff) and (v13:BuffStack(v102.MaelstromWeaponBuff) == (1 + 4 + ((4 + 1) * v24(v102.OverflowingMaelstrom:IsAvailable())))) and (v13:BuffDown(v102.SplinteredElementsBuff) or (v117 <= (9 + 3)) or (v99 <= v13:GCD()))) or ((6425 - 4830) >= (5919 - (695 + 750)))) then
					if (v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt)) or ((15772 - 11153) < (4447 - 1565))) then
						return "lightning_bolt aoe 2";
					end
				end
				if ((v102.LavaLash:IsReady() and v46 and v102.MoltenAssault:IsAvailable() and (v102.PrimordialWave:IsAvailable() or v102.FireNova:IsAvailable()) and v14:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (24 - 18))) or ((645 - (285 + 66)) >= (11261 - 6430))) then
					if (((3339 - (682 + 628)) <= (498 + 2586)) and v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash aoe 3";
					end
				end
				if ((v102.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v117) and (v13:BuffDown(v102.PrimordialWaveBuff))) or ((2336 - (176 + 123)) == (1013 + 1407))) then
					if (((3234 + 1224) > (4173 - (239 + 30))) and v118.CastCycle(v102.PrimordialWave, v111, v125, not v14:IsSpellInRange(v102.PrimordialWave))) then
						return "primordial_wave aoe 4";
					end
					if (((119 + 317) >= (119 + 4)) and v23(v102.PrimordialWave, not v14:IsSpellInRange(v102.PrimordialWave))) then
						return "primordial_wave aoe no_cycle 4";
					end
				end
				if (((884 - 384) < (5665 - 3849)) and v102.FlameShock:IsReady() and v42 and (v102.PrimordialWave:IsAvailable() or v102.FireNova:IsAvailable()) and v14:DebuffDown(v102.FlameShockDebuff)) then
					if (((3889 - (306 + 9)) == (12471 - 8897)) and v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock aoe 5";
					end
				end
				v155 = 1 + 0;
			end
			if (((136 + 85) < (188 + 202)) and (v155 == (5 - 3))) then
				if ((v102.LavaLash:IsReady() and v46 and (v102.LashingFlames:IsAvailable())) or ((3588 - (1140 + 235)) <= (905 + 516))) then
					local v232 = 0 + 0;
					while true do
						if (((785 + 2273) < (4912 - (33 + 19))) and (v232 == (0 + 0))) then
							if (v118.CastCycle(v102.LavaLash, v111, v126, not v14:IsSpellInRange(v102.LavaLash)) or ((3884 - 2588) >= (1959 + 2487))) then
								return "lava_lash aoe 11";
							end
							if (v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash)) or ((2731 - 1338) > (4210 + 279))) then
								return "lava_lash aoe no_cycle 11";
							end
							break;
						end
					end
				end
				if ((v102.LavaLash:IsReady() and v46 and ((v102.MoltenAssault:IsAvailable() and v14:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (695 - (586 + 103)))) or (v102.AshenCatalyst:IsAvailable() and (v13:BuffStack(v102.AshenCatalystBuff) == (1 + 4))))) or ((13619 - 9195) < (1515 - (1309 + 179)))) then
					if (v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash)) or ((3604 - 1607) > (1661 + 2154))) then
						return "lava_lash aoe 12";
					end
				end
				if (((9305 - 5840) > (1445 + 468)) and v102.IceStrike:IsReady() and v44 and (v102.Hailstorm:IsAvailable())) then
					if (((1556 - 823) < (3624 - 1805)) and v23(v102.IceStrike, not v14:IsInMeleeRange(614 - (295 + 314)))) then
						return "ice_strike aoe 13";
					end
				end
				if ((v102.FrostShock:IsReady() and v43 and v102.Hailstorm:IsAvailable() and v13:BuffUp(v102.HailstormBuff)) or ((10795 - 6400) == (6717 - (1300 + 662)))) then
					if (v23(v102.FrostShock, not v14:IsSpellInRange(v102.FrostShock)) or ((11910 - 8117) < (4124 - (1178 + 577)))) then
						return "frost_shock aoe 14";
					end
				end
				if ((v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v117)) or ((2121 + 1963) == (783 - 518))) then
					if (((5763 - (851 + 554)) == (3854 + 504)) and v23(v102.Sundering, not v14:IsInRange(22 - 14))) then
						return "sundering aoe 15";
					end
				end
				v155 = 6 - 3;
			end
			if ((v155 == (305 - (115 + 187))) or ((2404 + 734) < (941 + 52))) then
				if (((13122 - 9792) > (3484 - (160 + 1001))) and v102.FlameShock:IsReady() and v42 and v102.MoltenAssault:IsAvailable() and v14:DebuffDown(v102.FlameShockDebuff)) then
					if (v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock)) or ((3173 + 453) == (2753 + 1236))) then
						return "flame_shock aoe 16";
					end
				end
				if ((v102.FlameShock:IsReady() and v42 and v14:DebuffRefreshable(v102.FlameShockDebuff) and (v102.FireNova:IsAvailable() or v102.PrimordialWave:IsAvailable()) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (11 - 5))) or ((1274 - (237 + 121)) == (3568 - (525 + 372)))) then
					if (((515 - 243) == (893 - 621)) and v118.CastCycle(v102.FlameShock, v111, v125, not v14:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock aoe 17";
					end
					if (((4391 - (96 + 46)) <= (5616 - (643 + 134))) and v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock aoe no_cycle 17";
					end
				end
				if (((1003 + 1774) < (7672 - 4472)) and v102.FireNova:IsReady() and v41 and (v102.FlameShockDebuff:AuraActiveCount() >= (11 - 8))) then
					if (((92 + 3) < (3840 - 1883)) and v23(v102.FireNova)) then
						return "fire_nova aoe 18";
					end
				end
				if (((1688 - 862) < (2436 - (316 + 403))) and v102.Stormstrike:IsReady() and v49 and v13:BuffUp(v102.CrashLightningBuff) and (v102.DeeplyRootedElements:IsAvailable() or (v13:BuffStack(v102.ConvergingStormsBuff) == (4 + 2)))) then
					if (((3920 - 2494) >= (400 + 705)) and v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike))) then
						return "stormstrike aoe 19";
					end
				end
				if (((6935 - 4181) <= (2395 + 984)) and v102.CrashLightning:IsReady() and v39 and v102.CrashingStorms:IsAvailable() and v13:BuffUp(v102.CLCrashLightningBuff) and (v112 >= (2 + 2))) then
					if (v23(v102.CrashLightning, not v14:IsInMeleeRange(27 - 19)) or ((18754 - 14827) == (2935 - 1522))) then
						return "crash_lightning aoe 20";
					end
				end
				v155 = 1 + 3;
			end
			if ((v155 == (11 - 5)) or ((57 + 1097) <= (2318 - 1530))) then
				if ((v102.FrostShock:IsReady() and v43 and not v102.Hailstorm:IsAvailable()) or ((1660 - (12 + 5)) > (13123 - 9744))) then
					if (v23(v102.FrostShock, not v14:IsSpellInRange(v102.FrostShock)) or ((5979 - 3176) > (9669 - 5120))) then
						return "frost_shock aoe 31";
					end
				end
				break;
			end
			if ((v155 == (2 - 1)) or ((45 + 175) >= (4995 - (1656 + 317)))) then
				if (((2515 + 307) == (2262 + 560)) and v102.ElementalBlast:IsReady() and v40 and (not v102.ElementalSpirits:IsAvailable() or (v102.ElementalSpirits:IsAvailable() and ((v102.ElementalBlast:Charges() == v114) or (v120.FeralSpiritCount >= (4 - 2))))) and (v13:BuffStack(v102.MaelstromWeaponBuff) == ((24 - 19) + ((359 - (5 + 349)) * v24(v102.OverflowingMaelstrom:IsAvailable())))) and (not v102.CrashingStorms:IsAvailable() or (v112 <= (14 - 11)))) then
					if (v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast)) or ((2332 - (266 + 1005)) == (1224 + 633))) then
						return "elemental_blast aoe 6";
					end
				end
				if (((9417 - 6657) > (1795 - 431)) and v102.ChainLightning:IsReady() and v38 and (v13:BuffStack(v102.MaelstromWeaponBuff) == ((1701 - (561 + 1135)) + ((6 - 1) * v24(v102.OverflowingMaelstrom:IsAvailable()))))) then
					if (v23(v102.ChainLightning, not v14:IsSpellInRange(v102.ChainLightning)) or ((16113 - 11211) <= (4661 - (507 + 559)))) then
						return "chain_lightning aoe 7";
					end
				end
				if ((v102.CrashLightning:IsReady() and v39 and (v13:BuffUp(v102.DoomWindsBuff) or v13:BuffDown(v102.CrashLightningBuff) or (v102.AlphaWolf:IsAvailable() and v13:BuffUp(v102.FeralSpiritBuff) and (v124() == (0 - 0))))) or ((11912 - 8060) == (681 - (212 + 176)))) then
					if (v23(v102.CrashLightning, not v14:IsInMeleeRange(913 - (250 + 655))) or ((4251 - 2692) == (8016 - 3428))) then
						return "crash_lightning aoe 8";
					end
				end
				if ((v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v117) and (v13:BuffUp(v102.DoomWindsBuff) or v13:HasTier(46 - 16, 1958 - (1869 + 87)))) or ((15552 - 11068) == (2689 - (484 + 1417)))) then
					if (((9790 - 5222) >= (6547 - 2640)) and v23(v102.Sundering, not v14:IsInRange(781 - (48 + 725)))) then
						return "sundering aoe 9";
					end
				end
				if (((2035 - 789) < (9309 - 5839)) and v102.FireNova:IsReady() and v41 and ((v102.FlameShockDebuff:AuraActiveCount() >= (4 + 2)) or ((v102.FlameShockDebuff:AuraActiveCount() >= (10 - 6)) and (v102.FlameShockDebuff:AuraActiveCount() >= v112)))) then
					if (((1139 + 2929) >= (284 + 688)) and v23(v102.FireNova)) then
						return "fire_nova aoe 10";
					end
				end
				v155 = 855 - (152 + 701);
			end
			if (((1804 - (430 + 881)) < (1491 + 2402)) and (v155 == (899 - (557 + 338)))) then
				if ((v102.Windstrike:IsCastable() and v52) or ((436 + 1037) >= (9389 - 6057))) then
					if (v23(v102.Windstrike, not v14:IsSpellInRange(v102.Windstrike)) or ((14185 - 10134) <= (3073 - 1916))) then
						return "windstrike aoe 21";
					end
				end
				if (((1301 - 697) < (3682 - (499 + 302))) and v102.Stormstrike:IsReady() and v49) then
					if (v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike)) or ((1766 - (39 + 827)) == (9322 - 5945))) then
						return "stormstrike aoe 22";
					end
				end
				if (((9958 - 5499) > (2347 - 1756)) and v102.IceStrike:IsReady() and v44) then
					if (((5216 - 1818) >= (206 + 2189)) and v23(v102.IceStrike, not v14:IsInMeleeRange(14 - 9))) then
						return "ice_strike aoe 23";
					end
				end
				if ((v102.LavaLash:IsReady() and v46) or ((350 + 1833) >= (4468 - 1644))) then
					if (((2040 - (103 + 1)) == (2490 - (475 + 79))) and v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash aoe 24";
					end
				end
				if ((v102.CrashLightning:IsReady() and v39) or ((10445 - 5613) < (13801 - 9488))) then
					if (((529 + 3559) > (3410 + 464)) and v23(v102.CrashLightning, not v14:IsInMeleeRange(1511 - (1395 + 108)))) then
						return "crash_lightning aoe 25";
					end
				end
				v155 = 14 - 9;
			end
			if (((5536 - (7 + 1197)) == (1889 + 2443)) and (v155 == (2 + 3))) then
				if (((4318 - (27 + 292)) >= (8498 - 5598)) and v102.FireNova:IsReady() and v41 and (v102.FlameShockDebuff:AuraActiveCount() >= (2 - 0))) then
					if (v23(v102.FireNova) or ((10589 - 8064) > (8014 - 3950))) then
						return "fire_nova aoe 26";
					end
				end
				if (((8324 - 3953) == (4510 - (43 + 96))) and v102.ElementalBlast:IsReady() and v40 and (not v102.ElementalSpirits:IsAvailable() or (v102.ElementalSpirits:IsAvailable() and ((v102.ElementalBlast:Charges() == v114) or (v120.FeralSpiritCount >= (8 - 6))))) and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (11 - 6)) and (not v102.CrashingStorms:IsAvailable() or (v112 <= (3 + 0)))) then
					if (v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast)) or ((76 + 190) > (9854 - 4868))) then
						return "elemental_blast aoe 27";
					end
				end
				if (((764 + 1227) >= (1733 - 808)) and v102.ChainLightning:IsReady() and v38 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (2 + 3))) then
					if (((34 + 421) < (3804 - (1414 + 337))) and v23(v102.ChainLightning, not v14:IsSpellInRange(v102.ChainLightning))) then
						return "chain_lightning aoe 28";
					end
				end
				if ((v102.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (2030 - (1642 + 298))))) or ((2152 - 1326) == (13955 - 9104))) then
					if (((542 - 359) == (61 + 122)) and v23(v102.WindfuryTotem)) then
						return "windfury_totem aoe 29";
					end
				end
				if (((902 + 257) <= (2760 - (357 + 615))) and v102.FlameShock:IsReady() and v42 and (v14:DebuffDown(v102.FlameShockDebuff))) then
					if (v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock)) or ((2462 + 1045) > (10594 - 6276))) then
						return "flame_shock aoe 30";
					end
				end
				v155 = 6 + 0;
			end
		end
	end
	local function v136()
		local v156 = 0 - 0;
		while true do
			if (((2 + 0) == v156) or ((209 + 2866) <= (1864 + 1101))) then
				if (((2666 - (384 + 917)) <= (2708 - (128 + 569))) and v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) then
					if (v23(v102.AncestralSpirit, nil, true) or ((4319 - (1407 + 136)) > (5462 - (687 + 1200)))) then
						return "resurrection";
					end
				end
				if ((v118.TargetIsValid() and v33) or ((4264 - (556 + 1154)) == (16900 - 12096))) then
					if (((2672 - (9 + 86)) == (2998 - (275 + 146))) and not v13:AffectingCombat()) then
						v32 = v133();
						if (v32 or ((1 + 5) >= (1953 - (29 + 35)))) then
							return v32;
						end
					end
				end
				break;
			end
			if (((2242 - 1736) <= (5651 - 3759)) and (v156 == (0 - 0))) then
				if ((v75 and v102.EarthShield:IsCastable() and v13:BuffDown(v102.EarthShieldBuff) and ((v76 == "Earth Shield") or (v102.ElementalOrbit:IsAvailable() and v13:BuffUp(v102.LightningShield)))) or ((1308 + 700) > (3230 - (53 + 959)))) then
					if (((787 - (312 + 96)) <= (7197 - 3050)) and v23(v102.EarthShield)) then
						return "earth_shield main 2";
					end
				elseif ((v75 and v102.LightningShield:IsCastable() and v13:BuffDown(v102.LightningShieldBuff) and ((v76 == "Lightning Shield") or (v102.ElementalOrbit:IsAvailable() and v13:BuffUp(v102.EarthShield)))) or ((4799 - (147 + 138)) <= (1908 - (813 + 86)))) then
					if (v23(v102.LightningShield) or ((3160 + 336) == (2208 - 1016))) then
						return "lightning_shield main 2";
					end
				end
				if (((not v106 or (v108 < (600492 - (18 + 474)))) and v53 and v102.WindfuryWeapon:IsCastable()) or ((71 + 137) == (9657 - 6698))) then
					if (((5363 - (860 + 226)) >= (1616 - (121 + 182))) and v23(v102.WindfuryWeapon)) then
						return "windfury_weapon enchant";
					end
				end
				v156 = 1 + 0;
			end
			if (((3827 - (988 + 252)) < (359 + 2815)) and ((1 + 0) == v156)) then
				if (((not v107 or (v109 < (601970 - (49 + 1921)))) and v53 and v102.FlametongueWeapon:IsCastable()) or ((5010 - (223 + 667)) <= (2250 - (51 + 1)))) then
					if (v23(v102.FlametongueWeapon) or ((2746 - 1150) == (1837 - 979))) then
						return "flametongue_weapon enchant";
					end
				end
				if (((4345 - (146 + 979)) == (909 + 2311)) and v85) then
					local v233 = 605 - (311 + 294);
					while true do
						if (((0 - 0) == v233) or ((594 + 808) > (5063 - (496 + 947)))) then
							v32 = v130();
							if (((3932 - (1233 + 125)) == (1045 + 1529)) and v32) then
								return v32;
							end
							break;
						end
					end
				end
				v156 = 2 + 0;
			end
		end
	end
	local function v137()
		v32 = v131();
		if (((342 + 1456) < (4402 - (963 + 682))) and v32) then
			return v32;
		end
		if (v93 or ((315 + 62) > (4108 - (504 + 1000)))) then
			local v179 = 0 + 0;
			while true do
				if (((518 + 50) < (86 + 825)) and ((0 - 0) == v179)) then
					if (((2807 + 478) < (2459 + 1769)) and v87) then
						v32 = v118.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 222 - (156 + 26));
						if (((2256 + 1660) > (5206 - 1878)) and v32) then
							return v32;
						end
					end
					if (((2664 - (149 + 15)) < (4799 - (890 + 70))) and v88) then
						v32 = v118.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 147 - (39 + 78));
						if (((989 - (14 + 468)) == (1114 - 607)) and v32) then
							return v32;
						end
					end
					v179 = 2 - 1;
				end
				if (((124 + 116) <= (1901 + 1264)) and (v179 == (1 + 0))) then
					if (((377 + 457) >= (211 + 594)) and v89) then
						local v239 = 0 - 0;
						while true do
							if ((v239 == (0 + 0)) or ((13395 - 9583) < (59 + 2257))) then
								v32 = v118.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 81 - (12 + 39));
								if (v32 or ((2468 + 184) <= (4745 - 3212))) then
									return v32;
								end
								break;
							end
						end
					end
					if (((v13:BuffStack(v102.MaelstromWeaponBuff) >= (17 - 12)) and v90) or ((1067 + 2531) < (769 + 691))) then
						local v240 = 0 - 0;
						while true do
							if ((v240 == (0 + 0)) or ((19891 - 15775) < (2902 - (1596 + 114)))) then
								v32 = v118.HandleAfflicted(v102.HealingSurge, v104.HealingSurgeMouseover, 104 - 64, true);
								if (v32 or ((4090 - (164 + 549)) <= (2341 - (1059 + 379)))) then
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
		if (((4936 - 960) >= (228 + 211)) and v94) then
			local v180 = 0 + 0;
			while true do
				if (((4144 - (145 + 247)) == (3079 + 673)) and ((0 + 0) == v180)) then
					v32 = v118.HandleIncorporeal(v102.Hex, v104.HexMouseOver, 88 - 58, true);
					if (((777 + 3269) > (2322 + 373)) and v32) then
						return v32;
					end
					break;
				end
			end
		end
		if (v15 or ((5755 - 2210) == (3917 - (254 + 466)))) then
			if (((2954 - (544 + 16)) > (1185 - 812)) and v92) then
				local v226 = 628 - (294 + 334);
				while true do
					if (((4408 - (236 + 17)) <= (1825 + 2407)) and (v226 == (0 + 0))) then
						v32 = v128();
						if (v32 or ((13486 - 9905) == (16442 - 12969))) then
							return v32;
						end
						break;
					end
				end
			end
		end
		if (((2572 + 2423) > (2758 + 590)) and v102.GreaterPurge:IsAvailable() and v100 and v102.GreaterPurge:IsReady() and v37 and v91 and not v13:IsCasting() and not v13:IsChanneling() and v118.UnitHasMagicBuff(v14)) then
			if (v23(v102.GreaterPurge, not v14:IsSpellInRange(v102.GreaterPurge)) or ((1548 - (413 + 381)) > (157 + 3567))) then
				return "greater_purge damage";
			end
		end
		if (((461 - 244) >= (147 - 90)) and v102.Purge:IsReady() and v100 and v37 and v91 and not v13:IsCasting() and not v13:IsChanneling() and v118.UnitHasMagicBuff(v14)) then
			if (v23(v102.Purge, not v14:IsSpellInRange(v102.Purge)) or ((4040 - (582 + 1388)) >= (6878 - 2841))) then
				return "purge damage";
			end
		end
		v32 = v129();
		if (((1937 + 768) == (3069 - (326 + 38))) and v32) then
			return v32;
		end
		if (((180 - 119) == (86 - 25)) and v118.TargetIsValid()) then
			local v181 = v118.HandleDPSPotion(v13:BuffUp(v102.FeralSpiritBuff));
			if (v181 or ((1319 - (47 + 573)) >= (457 + 839))) then
				return v181;
			end
			if ((v99 < v117) or ((7572 - 5789) >= (5868 - 2252))) then
				if ((v57 and ((v35 and v64) or not v64)) or ((5577 - (1269 + 395)) > (5019 - (76 + 416)))) then
					local v238 = 443 - (319 + 124);
					while true do
						if (((10002 - 5626) > (1824 - (564 + 443))) and ((0 - 0) == v238)) then
							v32 = v132();
							if (((5319 - (337 + 121)) > (2413 - 1589)) and v32) then
								return v32;
							end
							break;
						end
					end
				end
			end
			if (((v99 < v117) and v58 and ((v65 and v35) or not v65)) or ((4606 - 3223) >= (4042 - (1261 + 650)))) then
				local v227 = 0 + 0;
				while true do
					if ((v227 == (0 - 0)) or ((3693 - (772 + 1045)) >= (359 + 2182))) then
						if (((1926 - (102 + 42)) <= (5616 - (1524 + 320))) and v102.BloodFury:IsCastable() and (not v102.Ascendance:IsAvailable() or v13:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (1320 - (1049 + 221))))) then
							if (v23(v102.BloodFury) or ((4856 - (18 + 138)) < (1989 - 1176))) then
								return "blood_fury racial";
							end
						end
						if (((4301 - (67 + 1035)) < (4398 - (136 + 212))) and v102.Berserking:IsCastable() and (not v102.Ascendance:IsAvailable() or v13:BuffUp(v102.AscendanceBuff))) then
							if (v23(v102.Berserking) or ((21038 - 16087) < (3549 + 881))) then
								return "berserking racial";
							end
						end
						v227 = 1 + 0;
					end
					if (((1700 - (240 + 1364)) == (1178 - (1050 + 32))) and (v227 == (3 - 2))) then
						if ((v102.Fireblood:IsCastable() and (not v102.Ascendance:IsAvailable() or v13:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (30 + 20)))) or ((3794 - (331 + 724)) > (324 + 3684))) then
							if (v23(v102.Fireblood) or ((667 - (269 + 375)) == (1859 - (267 + 458)))) then
								return "fireblood racial";
							end
						end
						if ((v102.AncestralCall:IsCastable() and (not v102.Ascendance:IsAvailable() or v13:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (16 + 34)))) or ((5178 - 2485) >= (4929 - (667 + 151)))) then
							if (v23(v102.AncestralCall) or ((5813 - (1410 + 87)) <= (4043 - (1504 + 393)))) then
								return "ancestral_call racial";
							end
						end
						break;
					end
				end
			end
			if ((v102.TotemicProjection:IsCastable() and (v102.WindfuryTotem:TimeSinceLastCast() < (243 - 153)) and v13:BuffDown(v102.WindfuryTotemBuff, true)) or ((9199 - 5653) <= (3605 - (461 + 335)))) then
				if (((627 + 4277) > (3927 - (1730 + 31))) and v23(v104.TotemicProjectionPlayer)) then
					return "totemic_projection wind_fury main 0";
				end
			end
			if (((1776 - (728 + 939)) >= (318 - 228)) and v102.Windstrike:IsCastable() and v52) then
				if (((10097 - 5119) > (6655 - 3750)) and v23(v102.Windstrike, not v14:IsSpellInRange(v102.Windstrike))) then
					return "windstrike main 1";
				end
			end
			if ((v102.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v117) and (v13:HasTier(1099 - (138 + 930), 2 + 0))) or ((2366 + 660) <= (1955 + 325))) then
				if (v23(v102.PrimordialWave, not v14:IsSpellInRange(v102.PrimordialWave)) or ((6749 - 5096) <= (2874 - (459 + 1307)))) then
					return "primordial_wave main 2";
				end
			end
			if (((4779 - (474 + 1396)) > (4555 - 1946)) and v102.FeralSpirit:IsCastable() and v55 and ((v60 and v35) or not v60) and (v99 < v117)) then
				if (((710 + 47) > (1 + 193)) and v23(v102.FeralSpirit)) then
					return "feral_spirit main 3";
				end
			end
			if ((v102.Ascendance:IsCastable() and v54 and ((v59 and v35) or not v59) and (v99 < v117) and v14:DebuffUp(v102.FlameShockDebuff) and (((v115 == "Lightning Bolt") and (v112 == (2 - 1))) or ((v115 == "Chain Lightning") and (v112 > (1 + 0))))) or ((103 - 72) >= (6096 - 4698))) then
				if (((3787 - (562 + 29)) <= (4154 + 718)) and v23(v102.Ascendance)) then
					return "ascendance main 4";
				end
			end
			if (((4745 - (374 + 1045)) == (2633 + 693)) and v102.DoomWinds:IsCastable() and v56 and ((v61 and v35) or not v61) and (v99 < v117)) then
				if (((4449 - 3016) <= (4516 - (448 + 190))) and v23(v102.DoomWinds, not v14:IsInMeleeRange(2 + 3))) then
					return "doom_winds main 5";
				end
			end
			if ((v112 == (1 + 0)) or ((1032 + 551) == (6670 - 4935))) then
				local v228 = 0 - 0;
				while true do
					if ((v228 == (1494 - (1307 + 187))) or ((11821 - 8840) == (5502 - 3152))) then
						v32 = v134();
						if (v32 or ((13693 - 9227) <= (1176 - (232 + 451)))) then
							return v32;
						end
						break;
					end
				end
			end
			if ((v34 and (v112 > (1 + 0))) or ((2250 + 297) <= (2551 - (510 + 54)))) then
				v32 = v135();
				if (((5965 - 3004) > (2776 - (13 + 23))) and v32) then
					return v32;
				end
			end
		end
	end
	local function v138()
		local v157 = 0 - 0;
		while true do
			if (((5310 - 1614) >= (6562 - 2950)) and (v157 == (1090 - (830 + 258)))) then
				v43 = EpicSettings.Settings['useFrostShock'];
				v44 = EpicSettings.Settings['useIceStrike'];
				v45 = EpicSettings.Settings['useLavaBurst'];
				v46 = EpicSettings.Settings['useLavaLash'];
				v157 = 10 - 7;
			end
			if ((v157 == (4 + 1)) or ((2527 + 443) == (3319 - (860 + 581)))) then
				v59 = EpicSettings.Settings['ascendanceWithCD'];
				v61 = EpicSettings.Settings['doomWindsWithCD'];
				v60 = EpicSettings.Settings['feralSpiritWithCD'];
				v63 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v157 = 22 - 16;
			end
			if ((v157 == (0 + 0)) or ((3934 - (237 + 4)) < (4646 - 2669))) then
				v54 = EpicSettings.Settings['useAscendance'];
				v56 = EpicSettings.Settings['useDoomWinds'];
				v55 = EpicSettings.Settings['useFeralSpirit'];
				v38 = EpicSettings.Settings['useChainlightning'];
				v157 = 2 - 1;
			end
			if (((11 - 5) == v157) or ((762 + 168) > (1207 + 894))) then
				v62 = EpicSettings.Settings['sunderingWithMiniCD'];
				break;
			end
			if (((15679 - 11526) > (1325 + 1761)) and (v157 == (2 + 1))) then
				v47 = EpicSettings.Settings['useLightningBolt'];
				v48 = EpicSettings.Settings['usePrimordialWave'];
				v49 = EpicSettings.Settings['useStormStrike'];
				v50 = EpicSettings.Settings['useSundering'];
				v157 = 1430 - (85 + 1341);
			end
			if (((1 - 0) == v157) or ((13143 - 8489) <= (4422 - (45 + 327)))) then
				v39 = EpicSettings.Settings['useCrashLightning'];
				v40 = EpicSettings.Settings['useElementalBlast'];
				v41 = EpicSettings.Settings['useFireNova'];
				v42 = EpicSettings.Settings['useFlameShock'];
				v157 = 3 - 1;
			end
			if ((v157 == (506 - (444 + 58))) or ((1131 + 1471) < (258 + 1238))) then
				v52 = EpicSettings.Settings['useWindstrike'];
				v51 = EpicSettings.Settings['useWindfuryTotem'];
				v53 = EpicSettings.Settings['useWeaponEnchant'];
				v101 = EpicSettings.Settings['useWeapon'];
				v157 = 3 + 2;
			end
		end
	end
	local function v139()
		v66 = EpicSettings.Settings['useWindShear'];
		v67 = EpicSettings.Settings['useCapacitorTotem'];
		v68 = EpicSettings.Settings['useThunderstorm'];
		v70 = EpicSettings.Settings['useAncestralGuidance'];
		v69 = EpicSettings.Settings['useAstralShift'];
		v72 = EpicSettings.Settings['useMaelstromHealingSurge'];
		v71 = EpicSettings.Settings['useHealingStreamTotem'];
		v78 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 - 0);
		v79 = EpicSettings.Settings['ancestralGuidanceGroup'] or (1732 - (64 + 1668));
		v77 = EpicSettings.Settings['astralShiftHP'] or (1973 - (1227 + 746));
		v80 = EpicSettings.Settings['healingStreamTotemHP'] or (0 - 0);
		v81 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 - 0);
		v82 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (494 - (415 + 79));
		v75 = EpicSettings.Settings['autoShield'];
		v76 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
		v85 = EpicSettings.Settings['healOOC'];
		v86 = EpicSettings.Settings['healOOCHP'] or (0 + 0);
		v100 = EpicSettings.Settings['usePurgeTarget'];
		v87 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
		v88 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v89 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
		v90 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
	end
	local function v140()
		local v172 = 491 - (142 + 349);
		while true do
			if ((v172 == (2 + 2)) or ((1402 - 382) > (1138 + 1150))) then
				v83 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v84 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v172 = 1869 - (1710 + 154);
			end
			if (((646 - (200 + 118)) == (130 + 198)) and (v172 == (5 - 2))) then
				v65 = EpicSettings.Settings['racialsWithCD'];
				v73 = EpicSettings.Settings['useHealthstone'];
				v74 = EpicSettings.Settings['useHealingPotion'];
				v172 = 5 - 1;
			end
			if (((1343 + 168) < (3767 + 41)) and (v172 == (1 + 0))) then
				v98 = EpicSettings.Settings['InterruptThreshold'];
				v92 = EpicSettings.Settings['DispelDebuffs'];
				v91 = EpicSettings.Settings['DispelBuffs'];
				v172 = 1 + 1;
			end
			if (((10 - 5) == v172) or ((3760 - (363 + 887)) > (8589 - 3670))) then
				v93 = EpicSettings.Settings['handleAfflicted'];
				v94 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((22671 - 17908) == (736 + 4027)) and (v172 == (0 - 0))) then
				v99 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v96 = EpicSettings.Settings['InterruptWithStun'];
				v97 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v172 = 1665 - (674 + 990);
			end
			if (((1187 + 2950) > (757 + 1091)) and (v172 == (2 - 0))) then
				v57 = EpicSettings.Settings['useTrinkets'];
				v58 = EpicSettings.Settings['useRacials'];
				v64 = EpicSettings.Settings['trinketsWithCD'];
				v172 = 1058 - (507 + 548);
			end
		end
	end
	local function v141()
		local v173 = 837 - (289 + 548);
		while true do
			if (((4254 - (821 + 997)) <= (3389 - (195 + 60))) and (v173 == (1 + 2))) then
				if (((5224 - (251 + 1250)) == (10906 - 7183)) and v34) then
					local v234 = 0 + 0;
					while true do
						if ((v234 == (1032 - (809 + 223))) or ((5904 - 1858) >= (12961 - 8645))) then
							v113 = #v110;
							v112 = #v111;
							break;
						end
					end
				else
					v113 = 3 - 2;
					v112 = 1 + 0;
				end
				if ((v37 and v92) or ((1052 + 956) < (2546 - (14 + 603)))) then
					local v235 = 129 - (118 + 11);
					while true do
						if (((386 + 1998) > (1479 + 296)) and (v235 == (0 - 0))) then
							if ((v13:AffectingCombat() and v102.CleanseSpirit:IsAvailable()) or ((5492 - (551 + 398)) <= (2766 + 1610))) then
								local v248 = 0 + 0;
								local v249;
								while true do
									if (((592 + 136) == (2707 - 1979)) and ((0 - 0) == v248)) then
										v249 = v92 and v102.CleanseSpirit:IsReady() and v37;
										v32 = v118.FocusUnit(v249, v104, 7 + 13, nil, 99 - 74);
										v248 = 1 + 0;
									end
									if ((v248 == (90 - (40 + 49))) or ((4097 - 3021) > (5161 - (99 + 391)))) then
										if (((1532 + 319) >= (1661 - 1283)) and v32) then
											return v32;
										end
										break;
									end
								end
							end
							if (v102.CleanseSpirit:IsAvailable() or ((4823 - 2875) >= (3386 + 90))) then
								if (((12614 - 7820) >= (2437 - (1032 + 572))) and v16 and v16:Exists() and v16:IsAPlayer() and v118.UnitHasCurseDebuff(v16)) then
									if (((4507 - (203 + 214)) == (5907 - (568 + 1249))) and v102.CleanseSpirit:IsReady()) then
										if (v23(v104.CleanseSpiritMouseover) or ((2940 + 818) == (5999 - 3501))) then
											return "cleanse_spirit mouseover";
										end
									end
								end
							end
							break;
						end
					end
				end
				if (v118.TargetIsValid() or v13:AffectingCombat() or ((10324 - 7651) < (2881 - (913 + 393)))) then
					local v236 = 0 - 0;
					while true do
						if ((v236 == (0 - 0)) or ((4131 - (269 + 141)) <= (3236 - 1781))) then
							v116 = v9.BossFightRemains(nil, true);
							v117 = v116;
							v236 = 1982 - (362 + 1619);
						end
						if (((2559 - (950 + 675)) < (876 + 1394)) and (v236 == (1180 - (216 + 963)))) then
							if ((v117 == (12398 - (485 + 802))) or ((2171 - (432 + 127)) == (2328 - (1065 + 8)))) then
								v117 = v9.FightRemains(v111, false);
							end
							break;
						end
					end
				end
				if (v13:AffectingCombat() or ((2418 + 1934) < (5807 - (635 + 966)))) then
					if (v13:PrevGCD(1 + 0, v102.ChainLightning) or ((2902 - (5 + 37)) <= (450 - 269))) then
						v115 = "Chain Lightning";
					elseif (((1341 + 1881) >= (2416 - 889)) and v13:PrevGCD(1 + 0, v102.LightningBolt)) then
						v115 = "Lightning Bolt";
					end
				end
				v173 = 8 - 4;
			end
			if (((5705 - 4200) <= (3999 - 1878)) and (v173 == (0 - 0))) then
				v139();
				v138();
				v140();
				v33 = EpicSettings.Toggles['ooc'];
				v173 = 1 + 0;
			end
			if (((1273 - (318 + 211)) == (3660 - 2916)) and (v173 == (1588 - (963 + 624)))) then
				v34 = EpicSettings.Toggles['aoe'];
				v35 = EpicSettings.Toggles['cds'];
				v37 = EpicSettings.Toggles['dispel'];
				v36 = EpicSettings.Toggles['minicds'];
				v173 = 1 + 1;
			end
			if ((v173 == (850 - (518 + 328))) or ((4612 - 2633) >= (4532 - 1696))) then
				if (((2150 - (301 + 16)) <= (7819 - 5151)) and not v13:IsChanneling() and not v13:IsChanneling()) then
					if (((10351 - 6665) == (9618 - 5932)) and v93) then
						if (((3141 + 326) > (271 + 206)) and v87) then
							local v245 = 0 - 0;
							while true do
								if ((v245 == (0 + 0)) or ((313 + 2975) >= (11258 - 7717))) then
									v32 = v118.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 13 + 27);
									if (v32 or ((4576 - (829 + 190)) == (16198 - 11658))) then
										return v32;
									end
									break;
								end
							end
						end
						if (v88 or ((330 - 69) > (1751 - 484))) then
							local v246 = 0 - 0;
							while true do
								if (((302 + 970) < (1261 + 2597)) and (v246 == (0 - 0))) then
									v32 = v118.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 29 + 1);
									if (((4277 - (520 + 93)) == (3940 - (259 + 17))) and v32) then
										return v32;
									end
									break;
								end
							end
						end
						if (((112 + 1829) >= (162 + 288)) and v89) then
							v32 = v118.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 101 - 71);
							if (v32 or ((5237 - (396 + 195)) < (939 - 615))) then
								return v32;
							end
						end
						if (((5594 - (440 + 1321)) == (5662 - (1059 + 770))) and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (23 - 18)) and v90) then
							local v247 = 545 - (424 + 121);
							while true do
								if ((v247 == (0 + 0)) or ((2587 - (641 + 706)) > (1335 + 2035))) then
									v32 = v118.HandleAfflicted(v102.HealingSurge, v104.HealingSurgeMouseover, 480 - (249 + 191), true);
									if (v32 or ((10807 - 8326) == (2091 + 2591))) then
										return v32;
									end
									break;
								end
							end
						end
					end
					if (((18218 - 13491) >= (635 - (183 + 244))) and v13:AffectingCombat()) then
						local v241 = 0 + 0;
						while true do
							if (((1010 - (434 + 296)) < (12289 - 8438)) and (v241 == (512 - (169 + 343)))) then
								v32 = v137();
								if (v32 or ((2637 + 370) > (5619 - 2425))) then
									return v32;
								end
								break;
							end
						end
					else
						local v242 = 0 - 0;
						while true do
							if ((v242 == (0 + 0)) or ((6057 - 3921) >= (4069 - (651 + 472)))) then
								v32 = v136();
								if (((1637 + 528) <= (1088 + 1433)) and v32) then
									return v32;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((3491 - 630) > (1144 - (397 + 86))) and (v173 == (878 - (423 + 453)))) then
				if (((460 + 4065) > (596 + 3923)) and v13:IsDeadOrGhost()) then
					return v32;
				end
				v106, v108, _, _, v107, v109 = v26();
				v110 = v13:GetEnemiesInRange(35 + 5);
				v111 = v13:GetEnemiesInMeleeRange(8 + 2);
				v173 = 3 + 0;
			end
		end
	end
	local function v142()
		local v174 = 1190 - (50 + 1140);
		while true do
			if (((2748 + 430) > (574 + 398)) and (v174 == (1 + 0))) then
				v20.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
				break;
			end
			if (((6844 - 2078) == (3449 + 1317)) and (v174 == (596 - (157 + 439)))) then
				v102.FlameShockDebuff:RegisterAuraTracking();
				v122();
				v174 = 1 - 0;
			end
		end
	end
	v20.SetAPL(873 - 610, v141, v142);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

