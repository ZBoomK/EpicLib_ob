local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((12594 - 9035) <= (206 + 220))) then
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
	local v101 = v17.Shaman.Enhancement;
	local v102 = v19.Shaman.Enhancement;
	local v103 = v22.Shaman.Enhancement;
	local v104 = {};
	local v105, v106;
	local v107, v108;
	local v109, v110, v111, v112;
	local v113 = (v101.LavaBurst:IsAvailable() and (798 - (588 + 208))) or (2 - 1);
	local v114 = "Lightning Bolt";
	local v115 = 12911 - (884 + 916);
	local v116 = 23261 - 12150;
	local v117 = v20.Commons.Everyone;
	v20.Commons.Shaman = {};
	local v119 = v20.Commons.Shaman;
	v119.FeralSpiritCount = 0 + 0;
	v9:RegisterForEvent(function()
		v113 = (v101.LavaBurst:IsAvailable() and (655 - (232 + 421))) or (1890 - (1569 + 320));
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v9:RegisterForEvent(function()
		v114 = "Lightning Bolt";
		v115 = 2727 + 8384;
		v116 = 2111 + 9000;
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForSelfCombatEvent(function(...)
		local v142 = 0 - 0;
		local v143;
		local v144;
		local v145;
		while true do
			if (((1613 - (316 + 289)) <= (9714 - 6003)) and (v142 == (0 + 0))) then
				v143, v144, v144, v144, v144, v144, v144, v144, v145 = select(1457 - (666 + 787), ...);
				if (((v143 == v13:GUID()) and (v145 == (192059 - (360 + 65)))) or ((981 + 68) <= (1160 - (79 + 175)))) then
					v119.LastSKCast = v30();
				end
				v142 = 1 - 0;
			end
			if (((3522 + 991) > (8355 - 5629)) and (v142 == (1 - 0))) then
				if ((v13:HasTier(930 - (503 + 396), 183 - (92 + 89)) and (v143 == v13:GUID()) and (v145 == (729389 - 353407))) or ((760 + 721) >= (1574 + 1084))) then
					local v218 = 0 - 0;
					while true do
						if ((v218 == (0 + 0)) or ((7342 - 4122) == (1191 + 173))) then
							v119.FeralSpiritCount = v119.FeralSpiritCount + 1 + 0;
							v31.After(45 - 30, function()
								v119.FeralSpiritCount = v119.FeralSpiritCount - (1 + 0);
							end);
							break;
						end
					end
				end
				if (((v143 == v13:GUID()) and (v145 == (78588 - 27055))) or ((2298 - (485 + 759)) > (7848 - 4456))) then
					local v219 = 1189 - (442 + 747);
					while true do
						if ((v219 == (1135 - (832 + 303))) or ((1622 - (88 + 858)) >= (501 + 1141))) then
							v119.FeralSpiritCount = v119.FeralSpiritCount + 2 + 0;
							v31.After(1 + 14, function()
								v119.FeralSpiritCount = v119.FeralSpiritCount - (791 - (766 + 23));
							end);
							break;
						end
					end
				end
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	local function v121()
		if (((20418 - 16282) > (3278 - 881)) and v101.CleanseSpirit:IsAvailable()) then
			v117.DispellableDebuffs = v117.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v121();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v122()
		for v196 = 2 - 1, 20 - 14, 1074 - (1036 + 37) do
			if (v29(v13:TotemName(v196), "Totem") or ((3073 + 1261) == (8266 - 4021))) then
				return v196;
			end
		end
	end
	local function v123()
		local v146 = 0 + 0;
		local v147;
		while true do
			if ((v146 == (1481 - (641 + 839))) or ((5189 - (910 + 3)) <= (7726 - 4695))) then
				if ((v147 > (1692 - (1466 + 218))) or (v147 > v101.FeralSpirit:TimeSinceLastCast()) or ((2198 + 2584) <= (2347 - (556 + 592)))) then
					return 0 + 0;
				end
				return (816 - (329 + 479)) - v147;
			end
			if ((v146 == (854 - (174 + 680))) or ((16713 - 11849) < (3941 - 2039))) then
				if (((3455 + 1384) >= (4439 - (396 + 343))) and (not v101.AlphaWolf:IsAvailable() or v13:BuffDown(v101.FeralSpiritBuff))) then
					return 0 + 0;
				end
				v147 = v28(v101.CrashLightning:TimeSinceLastCast(), v101.ChainLightning:TimeSinceLastCast());
				v146 = 1478 - (29 + 1448);
			end
		end
	end
	local function v124(v148)
		return (v148:DebuffRefreshable(v101.FlameShockDebuff));
	end
	local function v125(v149)
		return (v149:DebuffRefreshable(v101.LashingFlamesDebuff));
	end
	local v126 = 1389 - (135 + 1254);
	local function v127()
		if ((v101.CleanseSpirit:IsReady() and v37 and v117.DispellableFriendlyUnit(94 - 69)) or ((5019 - 3944) > (1279 + 639))) then
			if (((1923 - (389 + 1138)) <= (4378 - (102 + 472))) and (v126 == (0 + 0))) then
				v126 = v30();
			end
			if (v117.Wait(278 + 222, v126) or ((3888 + 281) == (3732 - (320 + 1225)))) then
				if (((2502 - 1096) == (861 + 545)) and v23(v103.CleanseSpiritFocus)) then
					return "cleanse_spirit dispel";
				end
				v126 = 1464 - (157 + 1307);
			end
		end
	end
	local function v128()
		if (((3390 - (821 + 1038)) < (10655 - 6384)) and (not v15 or not v15:Exists() or not v15:IsInRange(5 + 35))) then
			return;
		end
		if (((1127 - 492) == (237 + 398)) and v15) then
			if (((8360 - 4987) <= (4582 - (834 + 192))) and (v15:HealthPercentage() <= v82) and v72 and v101.HealingSurge:IsReady() and (v13:BuffStack(v101.MaelstromWeaponBuff) >= (1 + 4))) then
				if (v23(v103.HealingSurgeFocus) or ((845 + 2446) < (71 + 3209))) then
					return "healing_surge heal focus";
				end
			end
		end
	end
	local function v129()
		if (((6794 - 2408) >= (1177 - (300 + 4))) and (v13:HealthPercentage() <= v86)) then
			if (((246 + 675) <= (2884 - 1782)) and v101.HealingSurge:IsReady()) then
				if (((5068 - (112 + 250)) >= (384 + 579)) and v23(v101.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v130()
		if ((v101.AstralShift:IsReady() and v69 and (v13:HealthPercentage() <= v77)) or ((2405 - 1445) <= (502 + 374))) then
			if (v23(v101.AstralShift) or ((1069 + 997) == (698 + 234))) then
				return "astral_shift defensive 1";
			end
		end
		if (((2393 + 2432) < (3598 + 1245)) and v101.AncestralGuidance:IsReady() and v70 and v117.AreUnitsBelowHealthPercentage(v78, v79)) then
			if (v23(v101.AncestralGuidance) or ((5291 - (1001 + 413)) >= (10117 - 5580))) then
				return "ancestral_guidance defensive 2";
			end
		end
		if ((v101.HealingStreamTotem:IsReady() and v71 and v117.AreUnitsBelowHealthPercentage(v80, v81)) or ((5197 - (244 + 638)) < (2419 - (627 + 66)))) then
			if (v23(v101.HealingStreamTotem) or ((10961 - 7282) < (1227 - (512 + 90)))) then
				return "healing_stream_totem defensive 3";
			end
		end
		if ((v101.HealingSurge:IsReady() and v72 and (v13:HealthPercentage() <= v82) and (v13:BuffStack(v101.MaelstromWeaponBuff) >= (1911 - (1665 + 241)))) or ((5342 - (373 + 344)) < (286 + 346))) then
			if (v23(v101.HealingSurge) or ((22 + 61) > (4695 - 2915))) then
				return "healing_surge defensive 4";
			end
		end
		if (((923 - 377) <= (2176 - (35 + 1064))) and v102.Healthstone:IsReady() and v73 and (v13:HealthPercentage() <= v83)) then
			if (v23(v103.Healthstone) or ((725 + 271) > (9202 - 4901))) then
				return "healthstone defensive 3";
			end
		end
		if (((17 + 4053) > (1923 - (298 + 938))) and v74 and (v13:HealthPercentage() <= v84)) then
			if ((v95 == "Refreshing Healing Potion") or ((1915 - (233 + 1026)) >= (4996 - (636 + 1030)))) then
				if (v102.RefreshingHealingPotion:IsReady() or ((1275 + 1217) <= (328 + 7))) then
					if (((1284 + 3038) >= (174 + 2388)) and v23(v103.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if ((v95 == "Dreamwalker's Healing Potion") or ((3858 - (55 + 166)) >= (731 + 3039))) then
				if (v102.DreamwalkersHealingPotion:IsReady() or ((240 + 2139) > (17483 - 12905))) then
					if (v23(v103.RefreshingHealingPotion) or ((780 - (36 + 261)) > (1298 - 555))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v131()
		v32 = v117.HandleTopTrinket(v104, v35, 1408 - (34 + 1334), nil);
		if (((944 + 1510) > (450 + 128)) and v32) then
			return v32;
		end
		v32 = v117.HandleBottomTrinket(v104, v35, 1323 - (1035 + 248), nil);
		if (((951 - (20 + 1)) < (2323 + 2135)) and v32) then
			return v32;
		end
	end
	local function v132()
		if (((981 - (134 + 185)) <= (2105 - (549 + 584))) and v101.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v101.WindfuryTotemBuff, true) or (v101.WindfuryTotem:TimeSinceLastCast() > (775 - (314 + 371))))) then
			if (((15002 - 10632) == (5338 - (478 + 490))) and v23(v101.WindfuryTotem)) then
				return "windfury_totem precombat 4";
			end
		end
		if ((v101.FeralSpirit:IsCastable() and v55 and ((v60 and v35) or not v60)) or ((2523 + 2239) <= (2033 - (786 + 386)))) then
			if (v23(v101.FeralSpirit) or ((4573 - 3161) == (5643 - (1055 + 324)))) then
				return "feral_spirit precombat 6";
			end
		end
		if ((v101.DoomWinds:IsCastable() and v56 and ((v61 and v35) or not v61)) or ((4508 - (1093 + 247)) < (1914 + 239))) then
			if (v23(v101.DoomWinds, not v14:IsSpellInRange(v101.DoomWinds)) or ((524 + 4452) < (5288 - 3956))) then
				return "doom_winds precombat 8";
			end
		end
		if (((15706 - 11078) == (13168 - 8540)) and v101.Sundering:IsReady() and v50 and ((v62 and v36) or not v62)) then
			if (v23(v101.Sundering, not v14:IsInRange(12 - 7)) or ((20 + 34) == (1521 - 1126))) then
				return "sundering precombat 10";
			end
		end
		if (((282 - 200) == (62 + 20)) and v101.Stormstrike:IsReady() and v49) then
			if (v23(v101.Stormstrike, not v14:IsSpellInRange(v101.Stormstrike)) or ((1485 - 904) < (970 - (364 + 324)))) then
				return "stormstrike precombat 12";
			end
		end
	end
	local function v133()
		if ((v101.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v116) and v14:DebuffDown(v101.FlameShockDebuff) and v101.LashingFlames:IsAvailable()) or ((12634 - 8025) < (5986 - 3491))) then
			if (((382 + 770) == (4820 - 3668)) and v23(v101.PrimordialWave, not v14:IsSpellInRange(v101.PrimordialWave))) then
				return "primordial_wave single 1";
			end
		end
		if (((3036 - 1140) <= (10392 - 6970)) and v101.FlameShock:IsReady() and v42 and v14:DebuffDown(v101.FlameShockDebuff) and v101.LashingFlames:IsAvailable()) then
			if (v23(v101.FlameShock, not v14:IsSpellInRange(v101.FlameShock)) or ((2258 - (1249 + 19)) > (1463 + 157))) then
				return "flame_shock single 2";
			end
		end
		if ((v101.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v101.MaelstromWeaponBuff) >= (19 - 14)) and v101.ElementalSpirits:IsAvailable() and (v119.FeralSpiritCount >= (1090 - (686 + 400)))) or ((689 + 188) > (4924 - (73 + 156)))) then
			if (((13 + 2678) >= (2662 - (721 + 90))) and v23(v101.ElementalBlast, not v14:IsSpellInRange(v101.ElementalBlast))) then
				return "elemental_blast single 3";
			end
		end
		if ((v101.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v116) and (v13:HasTier(1 + 29, 6 - 4))) or ((3455 - (224 + 246)) >= (7866 - 3010))) then
			if (((7872 - 3596) >= (217 + 978)) and v23(v101.Sundering, not v14:IsInRange(1 + 7))) then
				return "sundering single 4";
			end
		end
		if (((2374 + 858) <= (9324 - 4634)) and v101.LightningBolt:IsReady() and v47 and (v13:BuffStack(v101.MaelstromWeaponBuff) >= (16 - 11)) and v13:BuffDown(v101.CracklingThunderBuff) and v13:BuffUp(v101.AscendanceBuff) and (v114 == "Chain Lightning") and (v13:BuffRemains(v101.AscendanceBuff) > (v101.ChainLightning:CooldownRemains() + v13:GCD()))) then
			if (v23(v101.LightningBolt, not v14:IsSpellInRange(v101.LightningBolt)) or ((1409 - (203 + 310)) >= (5139 - (1238 + 755)))) then
				return "lightning_bolt single 5";
			end
		end
		if (((214 + 2847) >= (4492 - (709 + 825))) and v101.Stormstrike:IsReady() and v49 and (v13:BuffUp(v101.DoomWindsBuff) or v101.DeeplyRootedElements:IsAvailable() or (v101.Stormblast:IsAvailable() and v13:BuffUp(v101.StormbringerBuff)))) then
			if (((5872 - 2685) >= (937 - 293)) and v23(v101.Stormstrike, not v14:IsSpellInRange(v101.Stormstrike))) then
				return "stormstrike single 6";
			end
		end
		if (((1508 - (196 + 668)) <= (2779 - 2075)) and v101.LavaLash:IsReady() and v46 and (v13:BuffUp(v101.HotHandBuff))) then
			if (((1984 - 1026) > (1780 - (171 + 662))) and v23(v101.LavaLash, not v14:IsSpellInRange(v101.LavaLash))) then
				return "lava_lash single 7";
			end
		end
		if (((4585 - (4 + 89)) >= (9302 - 6648)) and v101.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v101.WindfuryTotemBuff, true))) then
			if (((1254 + 2188) >= (6601 - 5098)) and v23(v101.WindfuryTotem)) then
				return "windfury_totem single 8";
			end
		end
		if ((v101.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v101.MaelstromWeaponBuff) >= (2 + 3)) and (v101.ElementalBlast:Charges() == v113)) or ((4656 - (35 + 1451)) <= (2917 - (28 + 1425)))) then
			if (v23(v101.ElementalBlast, not v14:IsSpellInRange(v101.ElementalBlast)) or ((6790 - (941 + 1052)) == (4208 + 180))) then
				return "elemental_blast single 9";
			end
		end
		if (((2065 - (822 + 692)) <= (971 - 290)) and v101.LightningBolt:IsReady() and v47 and (v13:BuffStack(v101.MaelstromWeaponBuff) >= (4 + 4)) and v13:BuffUp(v101.PrimordialWaveBuff) and (v13:BuffDown(v101.SplinteredElementsBuff) or (v116 <= (309 - (45 + 252))))) then
			if (((3243 + 34) > (141 + 266)) and v23(v101.LightningBolt, not v14:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single 10";
			end
		end
		if (((11426 - 6731) >= (1848 - (114 + 319))) and v101.ChainLightning:IsReady() and v38 and (v13:BuffStack(v101.MaelstromWeaponBuff) >= (11 - 3)) and v13:BuffUp(v101.CracklingThunderBuff) and v101.ElementalSpirits:IsAvailable()) then
			if (v23(v101.ChainLightning, not v14:IsSpellInRange(v101.ChainLightning)) or ((4115 - 903) <= (602 + 342))) then
				return "chain_lightning single 11";
			end
		end
		if ((v101.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v101.MaelstromWeaponBuff) >= (11 - 3)) and ((v119.FeralSpiritCount >= (3 - 1)) or not v101.ElementalSpirits:IsAvailable())) or ((5059 - (556 + 1407)) <= (3004 - (741 + 465)))) then
			if (((4002 - (170 + 295)) == (1864 + 1673)) and v23(v101.ElementalBlast, not v14:IsSpellInRange(v101.ElementalBlast))) then
				return "elemental_blast single 12";
			end
		end
		if (((3525 + 312) >= (3865 - 2295)) and v101.LavaBurst:IsReady() and v45 and not v101.ThorimsInvocation:IsAvailable() and (v13:BuffStack(v101.MaelstromWeaponBuff) >= (5 + 0))) then
			if (v23(v101.LavaBurst, not v14:IsSpellInRange(v101.LavaBurst)) or ((1892 + 1058) == (2159 + 1653))) then
				return "lava_burst single 13";
			end
		end
		if (((5953 - (957 + 273)) >= (620 + 1698)) and v101.LightningBolt:IsReady() and v47 and ((v13:BuffStack(v101.MaelstromWeaponBuff) >= (4 + 4)) or (v101.StaticAccumulation:IsAvailable() and (v13:BuffStack(v101.MaelstromWeaponBuff) >= (19 - 14)))) and v13:BuffDown(v101.PrimordialWaveBuff)) then
			if (v23(v101.LightningBolt, not v14:IsSpellInRange(v101.LightningBolt)) or ((5341 - 3314) > (8711 - 5859))) then
				return "lightning_bolt single 14";
			end
		end
		if ((v101.CrashLightning:IsReady() and v39 and v101.AlphaWolf:IsAvailable() and v13:BuffUp(v101.FeralSpiritBuff) and (v123() == (0 - 0))) or ((2916 - (389 + 1391)) > (2709 + 1608))) then
			if (((495 + 4253) == (10809 - 6061)) and v23(v101.CrashLightning, not v14:IsInMeleeRange(959 - (783 + 168)))) then
				return "crash_lightning single 15";
			end
		end
		if (((12538 - 8802) <= (4663 + 77)) and v101.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v116)) then
			if (v23(v101.PrimordialWave, not v14:IsSpellInRange(v101.PrimordialWave)) or ((3701 - (309 + 2)) <= (9396 - 6336))) then
				return "primordial_wave single 16";
			end
		end
		if ((v101.FlameShock:IsReady() and v42 and (v14:DebuffDown(v101.FlameShockDebuff))) or ((2211 - (1090 + 122)) > (874 + 1819))) then
			if (((1554 - 1091) < (412 + 189)) and v23(v101.FlameShock, not v14:IsSpellInRange(v101.FlameShock))) then
				return "flame_shock single 17";
			end
		end
		if ((v101.IceStrike:IsReady() and v44 and v101.ElementalAssault:IsAvailable() and v101.SwirlingMaelstrom:IsAvailable()) or ((3301 - (628 + 490)) < (124 + 563))) then
			if (((11262 - 6713) == (20788 - 16239)) and v23(v101.IceStrike, not v14:IsInMeleeRange(779 - (431 + 343)))) then
				return "ice_strike single 18";
			end
		end
		if (((9435 - 4763) == (13515 - 8843)) and v101.LavaLash:IsReady() and v46 and (v101.LashingFlames:IsAvailable())) then
			if (v23(v101.LavaLash, not v14:IsSpellInRange(v101.LavaLash)) or ((2898 + 770) < (51 + 344))) then
				return "lava_lash single 19";
			end
		end
		if ((v101.IceStrike:IsReady() and v44 and (v13:BuffDown(v101.IceStrikeBuff))) or ((5861 - (556 + 1139)) == (470 - (6 + 9)))) then
			if (v23(v101.IceStrike, not v14:IsInMeleeRange(1 + 4)) or ((2280 + 2169) == (2832 - (28 + 141)))) then
				return "ice_strike single 20";
			end
		end
		if ((v101.FrostShock:IsReady() and v43 and (v13:BuffUp(v101.HailstormBuff))) or ((1657 + 2620) < (3688 - 699))) then
			if (v23(v101.FrostShock, not v14:IsSpellInRange(v101.FrostShock)) or ((617 + 253) >= (5466 - (486 + 831)))) then
				return "frost_shock single 21";
			end
		end
		if (((5756 - 3544) < (11205 - 8022)) and v101.LavaLash:IsReady() and v46) then
			if (((878 + 3768) > (9460 - 6468)) and v23(v101.LavaLash, not v14:IsSpellInRange(v101.LavaLash))) then
				return "lava_lash single 22";
			end
		end
		if (((2697 - (668 + 595)) < (2795 + 311)) and v101.IceStrike:IsReady() and v44) then
			if (((159 + 627) < (8243 - 5220)) and v23(v101.IceStrike, not v14:IsInMeleeRange(295 - (23 + 267)))) then
				return "ice_strike single 23";
			end
		end
		if ((v101.Windstrike:IsCastable() and v52) or ((4386 - (1129 + 815)) < (461 - (371 + 16)))) then
			if (((6285 - (1326 + 424)) == (8588 - 4053)) and v23(v101.Windstrike, not v14:IsSpellInRange(v101.Windstrike))) then
				return "windstrike single 24";
			end
		end
		if ((v101.Stormstrike:IsReady() and v49) or ((10995 - 7986) <= (2223 - (88 + 30)))) then
			if (((2601 - (720 + 51)) < (8161 - 4492)) and v23(v101.Stormstrike, not v14:IsSpellInRange(v101.Stormstrike))) then
				return "stormstrike single 25";
			end
		end
		if ((v101.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v116)) or ((3206 - (421 + 1355)) >= (5958 - 2346))) then
			if (((1318 + 1365) >= (3543 - (286 + 797))) and v23(v101.Sundering, not v14:IsInRange(29 - 21))) then
				return "sundering single 26";
			end
		end
		if ((v101.BagofTricks:IsReady() and v58 and ((v65 and v35) or not v65)) or ((2987 - 1183) >= (3714 - (397 + 42)))) then
			if (v23(v101.BagofTricks) or ((443 + 974) > (4429 - (24 + 776)))) then
				return "bag_of_tricks single 27";
			end
		end
		if (((7387 - 2592) > (1187 - (222 + 563))) and v101.FireNova:IsReady() and v41 and v101.SwirlingMaelstrom:IsAvailable() and v14:DebuffUp(v101.FlameShockDebuff) and (v13:BuffStack(v101.MaelstromWeaponBuff) < ((11 - 6) + ((4 + 1) * v24(v101.OverflowingMaelstrom:IsAvailable()))))) then
			if (((5003 - (23 + 167)) > (5363 - (690 + 1108))) and v23(v101.FireNova)) then
				return "fire_nova single 28";
			end
		end
		if (((1412 + 2500) == (3227 + 685)) and v101.LightningBolt:IsReady() and v47 and v101.Hailstorm:IsAvailable() and (v13:BuffStack(v101.MaelstromWeaponBuff) >= (853 - (40 + 808))) and v13:BuffDown(v101.PrimordialWaveBuff)) then
			if (((465 + 2356) <= (18446 - 13622)) and v23(v101.LightningBolt, not v14:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single 29";
			end
		end
		if (((1662 + 76) <= (1162 + 1033)) and v101.FrostShock:IsReady() and v43) then
			if (((23 + 18) <= (3589 - (47 + 524))) and v23(v101.FrostShock, not v14:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock single 30";
			end
		end
		if (((1393 + 752) <= (11218 - 7114)) and v101.CrashLightning:IsReady() and v39) then
			if (((4020 - 1331) < (11049 - 6204)) and v23(v101.CrashLightning, not v14:IsInMeleeRange(1734 - (1165 + 561)))) then
				return "crash_lightning single 31";
			end
		end
		if ((v101.FireNova:IsReady() and v41 and (v14:DebuffUp(v101.FlameShockDebuff))) or ((69 + 2253) > (8120 - 5498))) then
			if (v23(v101.FireNova) or ((1730 + 2804) == (2561 - (341 + 138)))) then
				return "fire_nova single 32";
			end
		end
		if ((v101.FlameShock:IsReady() and v42) or ((425 + 1146) > (3852 - 1985))) then
			if (v23(v101.FlameShock, not v14:IsSpellInRange(v101.FlameShock)) or ((2980 - (89 + 237)) >= (9638 - 6642))) then
				return "flame_shock single 34";
			end
		end
		if (((8374 - 4396) > (2985 - (581 + 300))) and v101.ChainLightning:IsReady() and v38 and (v13:BuffStack(v101.MaelstromWeaponBuff) >= (1225 - (855 + 365))) and v13:BuffUp(v101.CracklingThunderBuff) and v101.ElementalSpirits:IsAvailable()) then
			if (((7113 - 4118) > (504 + 1037)) and v23(v101.ChainLightning, not v14:IsSpellInRange(v101.ChainLightning))) then
				return "chain_lightning single 35";
			end
		end
		if (((4484 - (1030 + 205)) > (895 + 58)) and v101.LightningBolt:IsReady() and v47 and (v13:BuffStack(v101.MaelstromWeaponBuff) >= (5 + 0)) and v13:BuffDown(v101.PrimordialWaveBuff)) then
			if (v23(v101.LightningBolt, not v14:IsSpellInRange(v101.LightningBolt)) or ((3559 - (156 + 130)) > (10390 - 5817))) then
				return "lightning_bolt single 36";
			end
		end
		if ((v101.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v101.WindfuryTotemBuff, true) or (v101.WindfuryTotem:TimeSinceLastCast() > (151 - 61)))) or ((6453 - 3302) < (339 + 945))) then
			if (v23(v101.WindfuryTotem) or ((1079 + 771) == (1598 - (10 + 59)))) then
				return "windfury_totem single 37";
			end
		end
	end
	local function v134()
		if (((233 + 588) < (10455 - 8332)) and v101.CrashLightning:IsReady() and v39 and v101.CrashingStorms:IsAvailable() and ((v101.UnrulyWinds:IsAvailable() and (v111 >= (1173 - (671 + 492)))) or (v111 >= (12 + 3)))) then
			if (((2117 - (369 + 846)) < (616 + 1709)) and v23(v101.CrashLightning, not v14:IsInMeleeRange(7 + 1))) then
				return "crash_lightning aoe 1";
			end
		end
		if (((2803 - (1036 + 909)) <= (2356 + 606)) and v101.LightningBolt:IsReady() and v47 and ((v101.FlameShockDebuff:AuraActiveCount() >= v111) or (v13:BuffRemains(v101.PrimordialWaveBuff) < (v13:GCD() * (4 - 1))) or (v101.FlameShockDebuff:AuraActiveCount() >= (209 - (11 + 192)))) and v13:BuffUp(v101.PrimordialWaveBuff) and (v13:BuffStack(v101.MaelstromWeaponBuff) == (3 + 2 + ((180 - (135 + 40)) * v24(v101.OverflowingMaelstrom:IsAvailable())))) and (v13:BuffDown(v101.SplinteredElementsBuff) or (v116 <= (28 - 16)) or (v99 <= v13:GCD()))) then
			if (v23(v101.LightningBolt, not v14:IsSpellInRange(v101.LightningBolt)) or ((2379 + 1567) < (2837 - 1549))) then
				return "lightning_bolt aoe 2";
			end
		end
		if ((v101.LavaLash:IsReady() and v46 and v101.MoltenAssault:IsAvailable() and (v101.PrimordialWave:IsAvailable() or v101.FireNova:IsAvailable()) and v14:DebuffUp(v101.FlameShockDebuff) and (v101.FlameShockDebuff:AuraActiveCount() < v111) and (v101.FlameShockDebuff:AuraActiveCount() < (8 - 2))) or ((3418 - (50 + 126)) == (1578 - 1011))) then
			if (v23(v101.LavaLash, not v14:IsSpellInRange(v101.LavaLash)) or ((188 + 659) >= (2676 - (1233 + 180)))) then
				return "lava_lash aoe 3";
			end
		end
		if ((v101.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v116) and (v13:BuffDown(v101.PrimordialWaveBuff))) or ((3222 - (522 + 447)) == (3272 - (107 + 1314)))) then
			local v199 = 0 + 0;
			while true do
				if (((0 - 0) == v199) or ((887 + 1200) > (4709 - 2337))) then
					if (v117.CastCycle(v101.PrimordialWave, v110, v124, not v14:IsSpellInRange(v101.PrimordialWave)) or ((17587 - 13142) < (6059 - (716 + 1194)))) then
						return "primordial_wave aoe 4";
					end
					if (v23(v101.PrimordialWave, not v14:IsSpellInRange(v101.PrimordialWave)) or ((32 + 1786) == (10 + 75))) then
						return "primordial_wave aoe no_cycle 4";
					end
					break;
				end
			end
		end
		if (((1133 - (74 + 429)) < (4102 - 1975)) and v101.FlameShock:IsReady() and v42 and (v101.PrimordialWave:IsAvailable() or v101.FireNova:IsAvailable()) and v14:DebuffDown(v101.FlameShockDebuff)) then
			if (v23(v101.FlameShock, not v14:IsSpellInRange(v101.FlameShock)) or ((961 + 977) == (5754 - 3240))) then
				return "flame_shock aoe 5";
			end
		end
		if (((3011 + 1244) >= (169 - 114)) and v101.ElementalBlast:IsReady() and v40 and (not v101.ElementalSpirits:IsAvailable() or (v101.ElementalSpirits:IsAvailable() and ((v101.ElementalBlast:Charges() == v113) or (v119.FeralSpiritCount >= (4 - 2))))) and (v13:BuffStack(v101.MaelstromWeaponBuff) == ((438 - (279 + 154)) + ((783 - (454 + 324)) * v24(v101.OverflowingMaelstrom:IsAvailable())))) and (not v101.CrashingStorms:IsAvailable() or (v111 <= (3 + 0)))) then
			if (((3016 - (12 + 5)) > (624 + 532)) and v23(v101.ElementalBlast, not v14:IsSpellInRange(v101.ElementalBlast))) then
				return "elemental_blast aoe 6";
			end
		end
		if (((5987 - 3637) > (427 + 728)) and v101.ChainLightning:IsReady() and v38 and (v13:BuffStack(v101.MaelstromWeaponBuff) == ((1098 - (277 + 816)) + ((21 - 16) * v24(v101.OverflowingMaelstrom:IsAvailable()))))) then
			if (((5212 - (1058 + 125)) <= (910 + 3943)) and v23(v101.ChainLightning, not v14:IsSpellInRange(v101.ChainLightning))) then
				return "chain_lightning aoe 7";
			end
		end
		if ((v101.CrashLightning:IsReady() and v39 and (v13:BuffUp(v101.DoomWindsBuff) or v13:BuffDown(v101.CrashLightningBuff) or (v101.AlphaWolf:IsAvailable() and v13:BuffUp(v101.FeralSpiritBuff) and (v123() == (975 - (815 + 160)))))) or ((2213 - 1697) > (8151 - 4717))) then
			if (((966 + 3080) >= (8865 - 5832)) and v23(v101.CrashLightning, not v14:IsInMeleeRange(1906 - (41 + 1857)))) then
				return "crash_lightning aoe 8";
			end
		end
		if ((v101.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v116) and (v13:BuffUp(v101.DoomWindsBuff) or v13:HasTier(1923 - (1222 + 671), 5 - 3))) or ((3907 - 1188) <= (2629 - (229 + 953)))) then
			if (v23(v101.Sundering, not v14:IsInRange(1782 - (1111 + 663))) or ((5713 - (874 + 705)) < (550 + 3376))) then
				return "sundering aoe 9";
			end
		end
		if ((v101.FireNova:IsReady() and v41 and ((v101.FlameShockDebuff:AuraActiveCount() >= (5 + 1)) or ((v101.FlameShockDebuff:AuraActiveCount() >= (7 - 3)) and (v101.FlameShockDebuff:AuraActiveCount() >= v111)))) or ((5 + 159) >= (3464 - (642 + 37)))) then
			if (v23(v101.FireNova) or ((120 + 405) == (338 + 1771))) then
				return "fire_nova aoe 10";
			end
		end
		if (((82 - 49) == (487 - (233 + 221))) and v101.LavaLash:IsReady() and v46 and (v101.LashingFlames:IsAvailable())) then
			local v200 = 0 - 0;
			while true do
				if (((2689 + 365) <= (5556 - (718 + 823))) and ((0 + 0) == v200)) then
					if (((2676 - (266 + 539)) < (9574 - 6192)) and v117.CastCycle(v101.LavaLash, v110, v125, not v14:IsSpellInRange(v101.LavaLash))) then
						return "lava_lash aoe 11";
					end
					if (((2518 - (636 + 589)) <= (5141 - 2975)) and v23(v101.LavaLash, not v14:IsSpellInRange(v101.LavaLash))) then
						return "lava_lash aoe no_cycle 11";
					end
					break;
				end
			end
		end
		if ((v101.LavaLash:IsReady() and v46 and ((v101.MoltenAssault:IsAvailable() and v14:DebuffUp(v101.FlameShockDebuff) and (v101.FlameShockDebuff:AuraActiveCount() < v111) and (v101.FlameShockDebuff:AuraActiveCount() < (11 - 5))) or (v101.AshenCatalyst:IsAvailable() and (v13:BuffStack(v101.AshenCatalystBuff) == (4 + 1))))) or ((937 + 1642) < (1138 - (657 + 358)))) then
			if (v23(v101.LavaLash, not v14:IsSpellInRange(v101.LavaLash)) or ((2239 - 1393) >= (5394 - 3026))) then
				return "lava_lash aoe 12";
			end
		end
		if ((v101.IceStrike:IsReady() and v44 and (v101.Hailstorm:IsAvailable())) or ((5199 - (1151 + 36)) <= (3243 + 115))) then
			if (((393 + 1101) <= (8974 - 5969)) and v23(v101.IceStrike, not v14:IsInMeleeRange(1837 - (1552 + 280)))) then
				return "ice_strike aoe 13";
			end
		end
		if ((v101.FrostShock:IsReady() and v43 and v101.Hailstorm:IsAvailable() and v13:BuffUp(v101.HailstormBuff)) or ((3945 - (64 + 770)) == (1449 + 685))) then
			if (((5346 - 2991) == (419 + 1936)) and v23(v101.FrostShock, not v14:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock aoe 14";
			end
		end
		if ((v101.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v116)) or ((1831 - (157 + 1086)) <= (864 - 432))) then
			if (((21009 - 16212) >= (5974 - 2079)) and v23(v101.Sundering, not v14:IsInRange(10 - 2))) then
				return "sundering aoe 15";
			end
		end
		if (((4396 - (599 + 220)) == (7123 - 3546)) and v101.FlameShock:IsReady() and v42 and v101.MoltenAssault:IsAvailable() and v14:DebuffDown(v101.FlameShockDebuff)) then
			if (((5725 - (1813 + 118)) > (2700 + 993)) and v23(v101.FlameShock, not v14:IsSpellInRange(v101.FlameShock))) then
				return "flame_shock aoe 16";
			end
		end
		if ((v101.FlameShock:IsReady() and v42 and v14:DebuffRefreshable(v101.FlameShockDebuff) and (v101.FireNova:IsAvailable() or v101.PrimordialWave:IsAvailable()) and (v101.FlameShockDebuff:AuraActiveCount() < v111) and (v101.FlameShockDebuff:AuraActiveCount() < (1223 - (841 + 376)))) or ((1786 - 511) == (953 + 3147))) then
			if (v117.CastCycle(v101.FlameShock, v110, v124, not v14:IsSpellInRange(v101.FlameShock)) or ((4342 - 2751) >= (4439 - (464 + 395)))) then
				return "flame_shock aoe 17";
			end
			if (((2522 - 1539) <= (869 + 939)) and v23(v101.FlameShock, not v14:IsSpellInRange(v101.FlameShock))) then
				return "flame_shock aoe no_cycle 17";
			end
		end
		if ((v101.FireNova:IsReady() and v41 and (v101.FlameShockDebuff:AuraActiveCount() >= (840 - (467 + 370)))) or ((4443 - 2293) <= (879 + 318))) then
			if (((12920 - 9151) >= (184 + 989)) and v23(v101.FireNova)) then
				return "fire_nova aoe 18";
			end
		end
		if (((3454 - 1969) == (2005 - (150 + 370))) and v101.Stormstrike:IsReady() and v49 and v13:BuffUp(v101.CrashLightningBuff) and (v101.DeeplyRootedElements:IsAvailable() or (v13:BuffStack(v101.ConvergingStormsBuff) == (1288 - (74 + 1208))))) then
			if (v23(v101.Stormstrike, not v14:IsSpellInRange(v101.Stormstrike)) or ((8153 - 4838) <= (13193 - 10411))) then
				return "stormstrike aoe 19";
			end
		end
		if ((v101.CrashLightning:IsReady() and v39 and v101.CrashingStorms:IsAvailable() and v13:BuffUp(v101.CLCrashLightningBuff) and (v111 >= (3 + 1))) or ((1266 - (14 + 376)) >= (5140 - 2176))) then
			if (v23(v101.CrashLightning, not v14:IsInMeleeRange(6 + 2)) or ((1961 + 271) > (2382 + 115))) then
				return "crash_lightning aoe 20";
			end
		end
		if ((v101.Windstrike:IsCastable() and v52) or ((6182 - 4072) <= (250 + 82))) then
			if (((3764 - (23 + 55)) > (7516 - 4344)) and v23(v101.Windstrike, not v14:IsSpellInRange(v101.Windstrike))) then
				return "windstrike aoe 21";
			end
		end
		if ((v101.Stormstrike:IsReady() and v49) or ((2986 + 1488) < (737 + 83))) then
			if (((6633 - 2354) >= (907 + 1975)) and v23(v101.Stormstrike, not v14:IsSpellInRange(v101.Stormstrike))) then
				return "stormstrike aoe 22";
			end
		end
		if ((v101.IceStrike:IsReady() and v44) or ((2930 - (652 + 249)) >= (9422 - 5901))) then
			if (v23(v101.IceStrike, not v14:IsInMeleeRange(1873 - (708 + 1160))) or ((5529 - 3492) >= (8462 - 3820))) then
				return "ice_strike aoe 23";
			end
		end
		if (((1747 - (10 + 17)) < (1002 + 3456)) and v101.LavaLash:IsReady() and v46) then
			if (v23(v101.LavaLash, not v14:IsSpellInRange(v101.LavaLash)) or ((2168 - (1400 + 332)) > (5794 - 2773))) then
				return "lava_lash aoe 24";
			end
		end
		if (((2621 - (242 + 1666)) <= (363 + 484)) and v101.CrashLightning:IsReady() and v39) then
			if (((790 + 1364) <= (3436 + 595)) and v23(v101.CrashLightning, not v14:IsInMeleeRange(948 - (850 + 90)))) then
				return "crash_lightning aoe 25";
			end
		end
		if (((8082 - 3467) == (6005 - (360 + 1030))) and v101.FireNova:IsReady() and v41 and (v101.FlameShockDebuff:AuraActiveCount() >= (2 + 0))) then
			if (v23(v101.FireNova) or ((10697 - 6907) == (687 - 187))) then
				return "fire_nova aoe 26";
			end
		end
		if (((1750 - (909 + 752)) < (1444 - (109 + 1114))) and v101.ElementalBlast:IsReady() and v40 and (not v101.ElementalSpirits:IsAvailable() or (v101.ElementalSpirits:IsAvailable() and ((v101.ElementalBlast:Charges() == v113) or (v119.FeralSpiritCount >= (3 - 1))))) and (v13:BuffStack(v101.MaelstromWeaponBuff) >= (2 + 3)) and (not v101.CrashingStorms:IsAvailable() or (v111 <= (245 - (6 + 236))))) then
			if (((1295 + 759) >= (1144 + 277)) and v23(v101.ElementalBlast, not v14:IsSpellInRange(v101.ElementalBlast))) then
				return "elemental_blast aoe 27";
			end
		end
		if (((1631 - 939) < (5340 - 2282)) and v101.ChainLightning:IsReady() and v38 and (v13:BuffStack(v101.MaelstromWeaponBuff) >= (1138 - (1076 + 57)))) then
			if (v23(v101.ChainLightning, not v14:IsSpellInRange(v101.ChainLightning)) or ((536 + 2718) == (2344 - (579 + 110)))) then
				return "chain_lightning aoe 28";
			end
		end
		if ((v101.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v101.WindfuryTotemBuff, true) or (v101.WindfuryTotem:TimeSinceLastCast() > (8 + 82)))) or ((1146 + 150) == (2606 + 2304))) then
			if (((3775 - (174 + 233)) == (9407 - 6039)) and v23(v101.WindfuryTotem)) then
				return "windfury_totem aoe 29";
			end
		end
		if (((4638 - 1995) < (1697 + 2118)) and v101.FlameShock:IsReady() and v42 and (v14:DebuffDown(v101.FlameShockDebuff))) then
			if (((3087 - (663 + 511)) > (440 + 53)) and v23(v101.FlameShock, not v14:IsSpellInRange(v101.FlameShock))) then
				return "flame_shock aoe 30";
			end
		end
		if (((1033 + 3722) > (10568 - 7140)) and v101.FrostShock:IsReady() and v43 and not v101.Hailstorm:IsAvailable()) then
			if (((837 + 544) <= (5577 - 3208)) and v23(v101.FrostShock, not v14:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock aoe 31";
			end
		end
	end
	local function v135()
		local v150 = 0 - 0;
		while true do
			if (((1 + 1) == v150) or ((9425 - 4582) == (2911 + 1173))) then
				if (((427 + 4242) > (1085 - (478 + 244))) and v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) then
					if (v23(v101.AncestralSpirit, nil, true) or ((2394 - (440 + 77)) >= (1427 + 1711))) then
						return "resurrection";
					end
				end
				if (((17355 - 12613) >= (5182 - (655 + 901))) and v117.TargetIsValid() and v33) then
					if (not v13:AffectingCombat() or ((842 + 3698) == (702 + 214))) then
						local v224 = 0 + 0;
						while true do
							if ((v224 == (0 - 0)) or ((2601 - (695 + 750)) > (14836 - 10491))) then
								v32 = v132();
								if (((3452 - 1215) < (17088 - 12839)) and v32) then
									return v32;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v150 == (352 - (285 + 66))) or ((6254 - 3571) < (1333 - (682 + 628)))) then
				if (((113 + 584) <= (1125 - (176 + 123))) and (not v106 or (v108 < (250974 + 349026))) and v53 and v101.FlametongueWeapon:IsCastable()) then
					if (((802 + 303) <= (1445 - (239 + 30))) and v23(v101.FlametongueWeapon)) then
						return "flametongue_weapon enchant";
					end
				end
				if (((919 + 2460) <= (3664 + 148)) and v85) then
					local v220 = 0 - 0;
					while true do
						if ((v220 == (0 - 0)) or ((1103 - (306 + 9)) >= (5639 - 4023))) then
							v32 = v129();
							if (((323 + 1531) <= (2074 + 1305)) and v32) then
								return v32;
							end
							break;
						end
					end
				end
				v150 = 1 + 1;
			end
			if (((13008 - 8459) == (5924 - (1140 + 235))) and (v150 == (0 + 0))) then
				if ((v75 and v101.EarthShield:IsCastable() and v13:BuffDown(v101.EarthShieldBuff) and ((v76 == "Earth Shield") or (v101.ElementalOrbit:IsAvailable() and v13:BuffUp(v101.LightningShield)))) or ((2772 + 250) >= (777 + 2247))) then
					if (((4872 - (33 + 19)) > (794 + 1404)) and v23(v101.EarthShield)) then
						return "earth_shield main 2";
					end
				elseif ((v75 and v101.LightningShield:IsCastable() and v13:BuffDown(v101.LightningShieldBuff) and ((v76 == "Lightning Shield") or (v101.ElementalOrbit:IsAvailable() and v13:BuffUp(v101.EarthShield)))) or ((3180 - 2119) >= (2155 + 2736))) then
					if (((2674 - 1310) <= (4195 + 278)) and v23(v101.LightningShield)) then
						return "lightning_shield main 2";
					end
				end
				if (((not v105 or (v107 < (600689 - (586 + 103)))) and v53 and v101.WindfuryWeapon:IsCastable()) or ((328 + 3267) <= (9 - 6))) then
					if (v23(v101.WindfuryWeapon) or ((6160 - (1309 + 179)) == (6953 - 3101))) then
						return "windfury_weapon enchant";
					end
				end
				v150 = 1 + 0;
			end
		end
	end
	local function v136()
		local v151 = 0 - 0;
		while true do
			if (((1178 + 381) == (3311 - 1752)) and (v151 == (0 - 0))) then
				v32 = v130();
				if (v32 or ((2361 - (295 + 314)) <= (1935 - 1147))) then
					return v32;
				end
				v151 = 1963 - (1300 + 662);
			end
			if ((v151 == (9 - 6)) or ((5662 - (1178 + 577)) == (92 + 85))) then
				if (((10258 - 6788) > (1960 - (851 + 554))) and v101.Purge:IsReady() and v100 and v37 and v91 and not v13:IsCasting() and not v13:IsChanneling() and v117.UnitHasMagicBuff(v14)) then
					if (v23(v101.Purge, not v14:IsSpellInRange(v101.Purge)) or ((860 + 112) == (1788 - 1143))) then
						return "purge damage";
					end
				end
				v32 = v128();
				v151 = 8 - 4;
			end
			if (((3484 - (115 + 187)) >= (1620 + 495)) and (v151 == (2 + 0))) then
				if (((15340 - 11447) < (5590 - (160 + 1001))) and v15) then
					if (v92 or ((2509 + 358) < (1315 + 590))) then
						local v225 = 0 - 0;
						while true do
							if (((358 - (237 + 121)) == v225) or ((2693 - (525 + 372)) >= (7680 - 3629))) then
								v32 = v127();
								if (((5319 - 3700) <= (3898 - (96 + 46))) and v32) then
									return v32;
								end
								break;
							end
						end
					end
				end
				if (((1381 - (643 + 134)) == (219 + 385)) and v101.GreaterPurge:IsAvailable() and v100 and v101.GreaterPurge:IsReady() and v37 and v91 and not v13:IsCasting() and not v13:IsChanneling() and v117.UnitHasMagicBuff(v14)) then
					if (v23(v101.GreaterPurge, not v14:IsSpellInRange(v101.GreaterPurge)) or ((10751 - 6267) == (3341 - 2441))) then
						return "greater_purge damage";
					end
				end
				v151 = 3 + 0;
			end
			if ((v151 == (1 - 0)) or ((9114 - 4655) <= (1832 - (316 + 403)))) then
				if (((2415 + 1217) > (9342 - 5944)) and v93) then
					local v221 = 0 + 0;
					while true do
						if (((10279 - 6197) <= (3485 + 1432)) and (v221 == (1 + 0))) then
							if (((16742 - 11910) >= (6619 - 5233)) and v89) then
								v32 = v117.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 62 - 32);
								if (((8 + 129) == (269 - 132)) and v32) then
									return v32;
								end
							end
							if (((v13:BuffStack(v101.MaelstromWeaponBuff) >= (1 + 4)) and v90) or ((4619 - 3049) >= (4349 - (12 + 5)))) then
								local v232 = 0 - 0;
								while true do
									if ((v232 == (0 - 0)) or ((8638 - 4574) <= (4510 - 2691))) then
										v32 = v117.HandleAfflicted(v101.HealingSurge, v103.HealingSurgeMouseover, 9 + 31, true);
										if (v32 or ((6959 - (1656 + 317)) < (1403 + 171))) then
											return v32;
										end
										break;
									end
								end
							end
							break;
						end
						if (((3547 + 879) > (456 - 284)) and (v221 == (0 - 0))) then
							if (((940 - (5 + 349)) > (2161 - 1706)) and v87) then
								local v233 = 1271 - (266 + 1005);
								while true do
									if (((545 + 281) == (2818 - 1992)) and (v233 == (0 - 0))) then
										v32 = v117.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 1736 - (561 + 1135));
										if (v32 or ((5236 - 1217) > (14598 - 10157))) then
											return v32;
										end
										break;
									end
								end
							end
							if (((3083 - (507 + 559)) < (10692 - 6431)) and v88) then
								local v234 = 0 - 0;
								while true do
									if (((5104 - (212 + 176)) > (985 - (250 + 655))) and (v234 == (0 - 0))) then
										v32 = v117.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 52 - 22);
										if (v32 or ((5486 - 1979) == (5228 - (1869 + 87)))) then
											return v32;
										end
										break;
									end
								end
							end
							v221 = 3 - 2;
						end
					end
				end
				if (v94 or ((2777 - (484 + 1417)) >= (6590 - 3515))) then
					v32 = v117.HandleIncorporeal(v101.Hex, v103.HexMouseOver, 50 - 20, true);
					if (((5125 - (48 + 725)) > (4171 - 1617)) and v32) then
						return v32;
					end
				end
				v151 = 5 - 3;
			end
			if ((v151 == (3 + 1)) or ((11774 - 7368) < (1132 + 2911))) then
				if (v32 or ((551 + 1338) >= (4236 - (152 + 701)))) then
					return v32;
				end
				if (((3203 - (430 + 881)) <= (1048 + 1686)) and v117.TargetIsValid()) then
					local v222 = 895 - (557 + 338);
					local v223;
					while true do
						if (((569 + 1354) < (6250 - 4032)) and (v222 == (6 - 4))) then
							if (((5773 - 3600) > (816 - 437)) and v101.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v116) and (v13:HasTier(832 - (499 + 302), 868 - (39 + 827)))) then
								if (v23(v101.PrimordialWave, not v14:IsSpellInRange(v101.PrimordialWave)) or ((7152 - 4561) == (7613 - 4204))) then
									return "primordial_wave main 2";
								end
							end
							if (((17928 - 13414) > (5103 - 1779)) and v101.FeralSpirit:IsCastable() and v55 and ((v60 and v35) or not v60) and (v99 < v116)) then
								if (v23(v101.FeralSpirit) or ((18 + 190) >= (14130 - 9302))) then
									return "feral_spirit main 3";
								end
							end
							if ((v101.Ascendance:IsCastable() and v54 and ((v59 and v35) or not v59) and (v99 < v116) and v14:DebuffUp(v101.FlameShockDebuff) and (((v114 == "Lightning Bolt") and (v111 == (1 + 0))) or ((v114 == "Chain Lightning") and (v111 > (1 - 0))))) or ((1687 - (103 + 1)) > (4121 - (475 + 79)))) then
								if (v23(v101.Ascendance) or ((2838 - 1525) == (2540 - 1746))) then
									return "ascendance main 4";
								end
							end
							v222 = 1 + 2;
						end
						if (((2794 + 380) > (4405 - (1395 + 108))) and (v222 == (0 - 0))) then
							v223 = v117.HandleDPSPotion(v13:BuffUp(v101.FeralSpiritBuff));
							if (((5324 - (7 + 1197)) <= (1858 + 2402)) and v223) then
								return v223;
							end
							if ((v99 < v116) or ((309 + 574) > (5097 - (27 + 292)))) then
								if ((v57 and ((v35 and v64) or not v64)) or ((10607 - 6987) >= (6237 - 1346))) then
									v32 = v131();
									if (((17857 - 13599) > (1847 - 910)) and v32) then
										return v32;
									end
								end
							end
							v222 = 1 - 0;
						end
						if ((v222 == (142 - (43 + 96))) or ((19861 - 14992) < (2048 - 1142))) then
							if ((v101.DoomWinds:IsCastable() and v56 and ((v61 and v35) or not v61) and (v99 < v116)) or ((1017 + 208) > (1194 + 3034))) then
								if (((6577 - 3249) > (858 + 1380)) and v23(v101.DoomWinds, not v14:IsInMeleeRange(9 - 4))) then
									return "doom_winds main 5";
								end
							end
							if (((1209 + 2630) > (104 + 1301)) and (v111 == (1752 - (1414 + 337)))) then
								local v235 = 1940 - (1642 + 298);
								while true do
									if ((v235 == (0 - 0)) or ((3719 - 2426) <= (1504 - 997))) then
										v32 = v133();
										if (v32 or ((954 + 1942) < (627 + 178))) then
											return v32;
										end
										break;
									end
								end
							end
							if (((3288 - (357 + 615)) == (1626 + 690)) and v34 and (v111 > (2 - 1))) then
								v32 = v134();
								if (v32 or ((2203 + 367) == (3285 - 1752))) then
									return v32;
								end
							end
							break;
						end
						if ((v222 == (1 + 0)) or ((60 + 823) == (918 + 542))) then
							if (((v99 < v116) and v58 and ((v65 and v35) or not v65)) or ((5920 - (384 + 917)) <= (1696 - (128 + 569)))) then
								if ((v101.BloodFury:IsCastable() and (not v101.Ascendance:IsAvailable() or v13:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (1593 - (1407 + 136))))) or ((5297 - (687 + 1200)) > (5826 - (556 + 1154)))) then
									if (v23(v101.BloodFury) or ((3176 - 2273) >= (3154 - (9 + 86)))) then
										return "blood_fury racial";
									end
								end
								if ((v101.Berserking:IsCastable() and (not v101.Ascendance:IsAvailable() or v13:BuffUp(v101.AscendanceBuff))) or ((4397 - (275 + 146)) < (465 + 2392))) then
									if (((4994 - (29 + 35)) > (10224 - 7917)) and v23(v101.Berserking)) then
										return "berserking racial";
									end
								end
								if ((v101.Fireblood:IsCastable() and (not v101.Ascendance:IsAvailable() or v13:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (149 - 99)))) or ((17861 - 13815) < (841 + 450))) then
									if (v23(v101.Fireblood) or ((5253 - (53 + 959)) == (3953 - (312 + 96)))) then
										return "fireblood racial";
									end
								end
								if ((v101.AncestralCall:IsCastable() and (not v101.Ascendance:IsAvailable() or v13:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (86 - 36)))) or ((4333 - (147 + 138)) > (5131 - (813 + 86)))) then
									if (v23(v101.AncestralCall) or ((1582 + 168) >= (6433 - 2960))) then
										return "ancestral_call racial";
									end
								end
							end
							if (((3658 - (18 + 474)) == (1069 + 2097)) and v101.TotemicProjection:IsCastable() and (v101.WindfuryTotem:TimeSinceLastCast() < (293 - 203)) and v13:BuffDown(v101.WindfuryTotemBuff, true)) then
								if (((2849 - (860 + 226)) < (4027 - (121 + 182))) and v23(v103.TotemicProjectionPlayer)) then
									return "totemic_projection wind_fury main 0";
								end
							end
							if (((8 + 49) <= (3963 - (988 + 252))) and v101.Windstrike:IsCastable() and v52) then
								if (v23(v101.Windstrike, not v14:IsSpellInRange(v101.Windstrike)) or ((234 + 1836) == (139 + 304))) then
									return "windstrike main 1";
								end
							end
							v222 = 1972 - (49 + 1921);
						end
					end
				end
				break;
			end
		end
	end
	local function v137()
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
	local function v138()
		v66 = EpicSettings.Settings['useWindShear'];
		v67 = EpicSettings.Settings['useCapacitorTotem'];
		v68 = EpicSettings.Settings['useThunderstorm'];
		v70 = EpicSettings.Settings['useAncestralGuidance'];
		v69 = EpicSettings.Settings['useAstralShift'];
		v72 = EpicSettings.Settings['useMaelstromHealingSurge'];
		v71 = EpicSettings.Settings['useHealingStreamTotem'];
		v78 = EpicSettings.Settings['ancestralGuidanceHP'] or (890 - (223 + 667));
		v79 = EpicSettings.Settings['ancestralGuidanceGroup'] or (52 - (51 + 1));
		v77 = EpicSettings.Settings['astralShiftHP'] or (0 - 0);
		v80 = EpicSettings.Settings['healingStreamTotemHP'] or (0 - 0);
		v81 = EpicSettings.Settings['healingStreamTotemGroup'] or (1125 - (146 + 979));
		v82 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (0 + 0);
		v75 = EpicSettings.Settings['autoShield'];
		v76 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
		v85 = EpicSettings.Settings['healOOC'];
		v86 = EpicSettings.Settings['healOOCHP'] or (605 - (311 + 294));
		v100 = EpicSettings.Settings['usePurgeTarget'];
		v87 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
		v88 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v89 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
		v90 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
	end
	local function v139()
		local v190 = 0 - 0;
		while true do
			if ((v190 == (2 + 1)) or ((4148 - (496 + 947)) == (2751 - (1233 + 125)))) then
				v83 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v84 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v93 = EpicSettings.Settings['handleAfflicted'];
				v190 = 1 + 3;
			end
			if ((v190 == (1646 - (963 + 682))) or ((3840 + 761) < (1565 - (504 + 1000)))) then
				v92 = EpicSettings.Settings['DispelDebuffs'];
				v91 = EpicSettings.Settings['DispelBuffs'];
				v57 = EpicSettings.Settings['useTrinkets'];
				v58 = EpicSettings.Settings['useRacials'];
				v190 = 2 + 0;
			end
			if ((v190 == (0 + 0)) or ((132 + 1258) >= (6995 - 2251))) then
				v99 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v96 = EpicSettings.Settings['InterruptWithStun'];
				v97 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v98 = EpicSettings.Settings['InterruptThreshold'];
				v190 = 1 + 0;
			end
			if (((184 - (156 + 26)) == v190) or ((1154 + 849) > (5998 - 2164))) then
				v64 = EpicSettings.Settings['trinketsWithCD'];
				v65 = EpicSettings.Settings['racialsWithCD'];
				v73 = EpicSettings.Settings['useHealthstone'];
				v74 = EpicSettings.Settings['useHealingPotion'];
				v190 = 167 - (149 + 15);
			end
			if ((v190 == (964 - (890 + 70))) or ((273 - (39 + 78)) > (4395 - (14 + 468)))) then
				v94 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v140()
		v138();
		v137();
		v139();
		v33 = EpicSettings.Toggles['ooc'];
		v34 = EpicSettings.Toggles['aoe'];
		v35 = EpicSettings.Toggles['cds'];
		v37 = EpicSettings.Toggles['dispel'];
		v36 = EpicSettings.Toggles['minicds'];
		if (((428 - 233) == (545 - 350)) and v13:IsDeadOrGhost()) then
			return v32;
		end
		v105, v107, _, _, v106, v108 = v26();
		v109 = v13:GetEnemiesInRange(21 + 19);
		v110 = v13:GetEnemiesInMeleeRange(7 + 3);
		if (((660 + 2445) >= (812 + 984)) and v34) then
			v112 = #v109;
			v111 = #v110;
		else
			local v201 = 0 + 0;
			while true do
				if (((8381 - 4002) >= (2107 + 24)) and (v201 == (0 - 0))) then
					v112 = 1 + 0;
					v111 = 52 - (12 + 39);
					break;
				end
			end
		end
		if (((3577 + 267) >= (6323 - 4280)) and v37 and v92) then
			local v202 = 0 - 0;
			while true do
				if ((v202 == (0 + 0)) or ((1702 + 1530) <= (6924 - 4193))) then
					if (((3268 + 1637) == (23704 - 18799)) and v13:AffectingCombat() and v101.CleanseSpirit:IsAvailable()) then
						local v226 = v92 and v101.CleanseSpirit:IsReady() and v37;
						v32 = v117.FocusUnit(v226, v103, 1730 - (1596 + 114), nil, 65 - 40);
						if (v32 or ((4849 - (164 + 549)) >= (5849 - (1059 + 379)))) then
							return v32;
						end
					end
					if (v101.CleanseSpirit:IsAvailable() or ((3672 - 714) == (2082 + 1935))) then
						if (((208 + 1020) >= (1205 - (145 + 247))) and v16 and v16:Exists() and v16:IsAPlayer() and v117.UnitHasCurseDebuff(v16)) then
							if (v101.CleanseSpirit:IsReady() or ((2835 + 620) > (1872 + 2178))) then
								if (((719 - 476) == (47 + 196)) and v23(v103.CleanseSpiritMouseover)) then
									return "cleanse_spirit mouseover";
								end
							end
						end
					end
					break;
				end
			end
		end
		if (v117.TargetIsValid() or v13:AffectingCombat() or ((234 + 37) > (2551 - 979))) then
			v115 = v9.BossFightRemains(nil, true);
			v116 = v115;
			if (((3459 - (254 + 466)) < (3853 - (544 + 16))) and (v116 == (35311 - 24200))) then
				v116 = v9.FightRemains(v110, false);
			end
		end
		if (v13:AffectingCombat() or ((4570 - (294 + 334)) < (1387 - (236 + 17)))) then
			if (v13:PrevGCD(1 + 0, v101.ChainLightning) or ((2097 + 596) == (18728 - 13755))) then
				v114 = "Chain Lightning";
			elseif (((10160 - 8014) == (1105 + 1041)) and v13:PrevGCD(1 + 0, v101.LightningBolt)) then
				v114 = "Lightning Bolt";
			end
		end
		if ((not v13:IsChanneling() and not v13:IsChanneling()) or ((3038 - (413 + 381)) == (136 + 3088))) then
			local v203 = 0 - 0;
			while true do
				if ((v203 == (0 - 0)) or ((6874 - (582 + 1388)) <= (3263 - 1347))) then
					if (((65 + 25) <= (1429 - (326 + 38))) and v93) then
						local v227 = 0 - 0;
						while true do
							if (((6854 - 2052) == (5422 - (47 + 573))) and (v227 == (1 + 0))) then
								if (v89 or ((9683 - 7403) <= (829 - 318))) then
									v32 = v117.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 1694 - (1269 + 395));
									if (v32 or ((2168 - (76 + 416)) <= (906 - (319 + 124)))) then
										return v32;
									end
								end
								if (((8843 - 4974) == (4876 - (564 + 443))) and (v13:BuffStack(v101.MaelstromWeaponBuff) >= (13 - 8)) and v90) then
									local v236 = 458 - (337 + 121);
									while true do
										if (((3392 - 2234) <= (8703 - 6090)) and (v236 == (1911 - (1261 + 650)))) then
											v32 = v117.HandleAfflicted(v101.HealingSurge, v103.HealingSurgeMouseover, 17 + 23, true);
											if (v32 or ((3767 - 1403) <= (3816 - (772 + 1045)))) then
												return v32;
											end
											break;
										end
									end
								end
								break;
							end
							if ((v227 == (0 + 0)) or ((5066 - (102 + 42)) < (2038 - (1524 + 320)))) then
								if (v87 or ((3361 - (1049 + 221)) < (187 - (18 + 138)))) then
									local v237 = 0 - 0;
									while true do
										if ((v237 == (1102 - (67 + 1035))) or ((2778 - (136 + 212)) >= (20702 - 15830))) then
											v32 = v117.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 33 + 7);
											if (v32 or ((4398 + 372) < (3339 - (240 + 1364)))) then
												return v32;
											end
											break;
										end
									end
								end
								if (v88 or ((5521 - (1050 + 32)) <= (8390 - 6040))) then
									v32 = v117.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 18 + 12);
									if (v32 or ((5534 - (331 + 724)) < (361 + 4105))) then
										return v32;
									end
								end
								v227 = 645 - (269 + 375);
							end
						end
					end
					if (((3272 - (267 + 458)) > (381 + 844)) and v13:AffectingCombat()) then
						v32 = v136();
						if (((8982 - 4311) > (3492 - (667 + 151))) and v32) then
							return v32;
						end
					else
						v32 = v135();
						if (v32 or ((5193 - (1410 + 87)) < (5224 - (1504 + 393)))) then
							return v32;
						end
					end
					break;
				end
			end
		end
	end
	local function v141()
		v101.FlameShockDebuff:RegisterAuraTracking();
		v121();
		v20.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(710 - 447, v140, v141);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

