local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((8754 - 4241) >= (1399 + 1327)) and not v5) then
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
	local v114 = (v102.LavaBurst:IsAvailable() and (2 + 0)) or (3 - 2);
	local v115 = "Lightning Bolt";
	local v116 = 1520 + 9591;
	local v117 = 25334 - 14223;
	local v118 = v20.Commons.Everyone;
	v20.Commons.Shaman = {};
	local v120 = v20.Commons.Shaman;
	v120.FeralSpiritCount = 0 + 0;
	v9:RegisterForEvent(function()
		v114 = (v102.LavaBurst:IsAvailable() and (1 + 1)) or (2 - 1);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v9:RegisterForEvent(function()
		local v143 = 0 + 0;
		while true do
			if ((v143 == (0 - 0)) or ((2725 - (485 + 759)) >= (6150 - 3492))) then
				v115 = "Lightning Bolt";
				v116 = 12300 - (442 + 747);
				v143 = 1136 - (832 + 303);
			end
			if ((v143 == (947 - (88 + 858))) or ((982 + 2238) == (1129 + 235))) then
				v117 = 458 + 10653;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForSelfCombatEvent(function(...)
		local v144 = 789 - (766 + 23);
		local v145;
		local v146;
		local v147;
		while true do
			if ((v144 == (0 - 0)) or ((1441 - 387) > (8936 - 5544))) then
				v145, v146, v146, v146, v146, v146, v146, v146, v147 = select(13 - 9, ...);
				if (((v145 == v13:GUID()) and (v147 == (192707 - (1036 + 37)))) or ((480 + 196) >= (3197 - 1555))) then
					v120.LastSKCast = v30();
				end
				v144 = 1 + 0;
			end
			if (((5616 - (641 + 839)) > (3310 - (910 + 3))) and (v144 == (2 - 1))) then
				if ((v13:HasTier(1715 - (1466 + 218), 1 + 1) and (v145 == v13:GUID()) and (v147 == (377130 - (556 + 592)))) or ((1542 + 2792) == (5053 - (329 + 479)))) then
					local v231 = 854 - (174 + 680);
					while true do
						if ((v231 == (0 - 0)) or ((8862 - 4586) <= (2165 + 866))) then
							v120.FeralSpiritCount = v120.FeralSpiritCount + (740 - (396 + 343));
							v31.After(2 + 13, function()
								v120.FeralSpiritCount = v120.FeralSpiritCount - (1478 - (29 + 1448));
							end);
							break;
						end
					end
				end
				if (((v145 == v13:GUID()) and (v147 == (52922 - (135 + 1254)))) or ((18014 - 13232) <= (5598 - 4399))) then
					local v232 = 0 + 0;
					while true do
						if ((v232 == (1527 - (389 + 1138))) or ((5438 - (102 + 472)) < (1795 + 107))) then
							v120.FeralSpiritCount = v120.FeralSpiritCount + 2 + 0;
							v31.After(14 + 1, function()
								v120.FeralSpiritCount = v120.FeralSpiritCount - (1547 - (320 + 1225));
							end);
							break;
						end
					end
				end
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	local function v122()
		if (((8613 - 3774) >= (2264 + 1436)) and v102.CleanseSpirit:IsAvailable()) then
			v118.DispellableDebuffs = v118.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123()
		for v190 = 1465 - (157 + 1307), 1865 - (821 + 1038), 2 - 1 do
			if (v29(v13:TotemName(v190), "Totem") or ((118 + 957) > (3406 - 1488))) then
				return v190;
			end
		end
	end
	local function v124()
		local v148 = 0 + 0;
		local v149;
		while true do
			if (((981 - 585) <= (4830 - (834 + 192))) and (v148 == (0 + 0))) then
				if (not v102.AlphaWolf:IsAvailable() or v13:BuffDown(v102.FeralSpiritBuff) or ((1071 + 3098) == (47 + 2140))) then
					return 0 - 0;
				end
				v149 = v28(v102.CrashLightning:TimeSinceLastCast(), v102.ChainLightning:TimeSinceLastCast());
				v148 = 305 - (300 + 4);
			end
			if (((376 + 1030) == (3680 - 2274)) and (v148 == (363 - (112 + 250)))) then
				if (((611 + 920) < (10699 - 6428)) and ((v149 > (5 + 3)) or (v149 > v102.FeralSpirit:TimeSinceLastCast()))) then
					return 0 + 0;
				end
				return (6 + 2) - v149;
			end
		end
	end
	local function v125(v150)
		return (v150:DebuffRefreshable(v102.FlameShockDebuff));
	end
	local function v126(v151)
		return (v151:DebuffRefreshable(v102.LashingFlamesDebuff));
	end
	local v127 = 0 + 0;
	local function v128()
		if (((472 + 163) == (2049 - (1001 + 413))) and v102.CleanseSpirit:IsReady() and v37 and (v118.UnitHasDispellableDebuffByPlayer(v15) or v118.DispellableFriendlyUnit(55 - 30))) then
			local v193 = 882 - (244 + 638);
			while true do
				if (((4066 - (627 + 66)) <= (10595 - 7039)) and (v193 == (602 - (512 + 90)))) then
					if ((v127 == (1906 - (1665 + 241))) or ((4008 - (373 + 344)) < (1480 + 1800))) then
						v127 = v30();
					end
					if (((1161 + 3225) >= (2302 - 1429)) and v118.Wait(846 - 346, v127)) then
						local v234 = 1099 - (35 + 1064);
						while true do
							if (((671 + 250) <= (2357 - 1255)) and (v234 == (0 + 0))) then
								if (((5942 - (298 + 938)) >= (2222 - (233 + 1026))) and v23(v104.CleanseSpiritFocus)) then
									return "cleanse_spirit dispel";
								end
								v127 = 1666 - (636 + 1030);
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v129()
		local v152 = 0 + 0;
		while true do
			if ((v152 == (0 + 0)) or ((286 + 674) <= (60 + 816))) then
				if (not v15 or not v15:Exists() or not v15:IsInRange(261 - (55 + 166)) or ((401 + 1665) == (94 + 838))) then
					return;
				end
				if (((18426 - 13601) < (5140 - (36 + 261))) and v15) then
					if (((v15:HealthPercentage() <= v82) and v72 and v102.HealingSurge:IsReady() and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (8 - 3))) or ((5245 - (34 + 1334)) >= (1745 + 2792))) then
						if (v23(v104.HealingSurgeFocus) or ((3353 + 962) < (3009 - (1035 + 248)))) then
							return "healing_surge heal focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v130()
		if ((v13:HealthPercentage() <= v86) or ((3700 - (20 + 1)) < (326 + 299))) then
			if (v102.HealingSurge:IsReady() or ((4944 - (134 + 185)) < (1765 - (549 + 584)))) then
				if (v23(v102.HealingSurge) or ((768 - (314 + 371)) > (6110 - 4330))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v131()
		local v153 = 968 - (478 + 490);
		while true do
			if (((290 + 256) <= (2249 - (786 + 386))) and (v153 == (3 - 2))) then
				if ((v102.HealingStreamTotem:IsReady() and v71 and v118.AreUnitsBelowHealthPercentage(v80, v81, v102.HealingSurge)) or ((2375 - (1055 + 324)) > (5641 - (1093 + 247)))) then
					if (((3617 + 453) > (73 + 614)) and v23(v102.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v102.HealingSurge:IsReady() and v72 and (v13:HealthPercentage() <= v82) and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (19 - 14))) or ((2225 - 1569) >= (9475 - 6145))) then
					if (v23(v102.HealingSurge) or ((6262 - 3770) <= (120 + 215))) then
						return "healing_surge defensive 4";
					end
				end
				v153 = 7 - 5;
			end
			if (((14896 - 10574) >= (1932 + 630)) and ((0 - 0) == v153)) then
				if ((v102.AstralShift:IsReady() and v69 and (v13:HealthPercentage() <= v77)) or ((4325 - (364 + 324)) >= (10334 - 6564))) then
					if (v23(v102.AstralShift) or ((5708 - 3329) > (1518 + 3060))) then
						return "astral_shift defensive 1";
					end
				end
				if ((v102.AncestralGuidance:IsReady() and v70 and v118.AreUnitsBelowHealthPercentage(v78, v79, v102.HealingSurge)) or ((2020 - 1537) > (1189 - 446))) then
					if (((7452 - 4998) > (1846 - (1249 + 19))) and v23(v102.AncestralGuidance)) then
						return "ancestral_guidance defensive 2";
					end
				end
				v153 = 1 + 0;
			end
			if (((3620 - 2690) < (5544 - (686 + 400))) and (v153 == (2 + 0))) then
				if (((891 - (73 + 156)) <= (5 + 967)) and v103.Healthstone:IsReady() and v73 and (v13:HealthPercentage() <= v83)) then
					if (((5181 - (721 + 90)) == (50 + 4320)) and v23(v104.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if ((v74 and (v13:HealthPercentage() <= v84)) or ((15461 - 10699) <= (1331 - (224 + 246)))) then
					if ((v95 == "Refreshing Healing Potion") or ((2287 - 875) == (7850 - 3586))) then
						if (v103.RefreshingHealingPotion:IsReady() or ((575 + 2593) < (52 + 2101))) then
							if (v23(v104.RefreshingHealingPotion) or ((3655 + 1321) < (2647 - 1315))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((15400 - 10772) == (5141 - (203 + 310))) and (v95 == "Dreamwalker's Healing Potion")) then
						if (v103.DreamwalkersHealingPotion:IsReady() or ((2047 - (1238 + 755)) == (28 + 367))) then
							if (((1616 - (709 + 825)) == (150 - 68)) and v23(v104.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v132()
		v32 = v118.HandleTopTrinket(v105, v35, 58 - 18, nil);
		if (v32 or ((1445 - (196 + 668)) < (1113 - 831))) then
			return v32;
		end
		v32 = v118.HandleBottomTrinket(v105, v35, 82 - 42, nil);
		if (v32 or ((5442 - (171 + 662)) < (2588 - (4 + 89)))) then
			return v32;
		end
	end
	local function v133()
		local v154 = 0 - 0;
		while true do
			if (((420 + 732) == (5059 - 3907)) and ((1 + 0) == v154)) then
				if (((3382 - (35 + 1451)) <= (4875 - (28 + 1425))) and v102.DoomWinds:IsCastable() and v56 and ((v61 and v35) or not v61)) then
					if (v23(v102.DoomWinds, not v14:IsSpellInRange(v102.DoomWinds)) or ((2983 - (941 + 1052)) > (1554 + 66))) then
						return "doom_winds precombat 8";
					end
				end
				if ((v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62)) or ((2391 - (822 + 692)) > (6702 - 2007))) then
					if (((1268 + 1423) >= (2148 - (45 + 252))) and v23(v102.Sundering, not v14:IsInRange(5 + 0))) then
						return "sundering precombat 10";
					end
				end
				v154 = 1 + 1;
			end
			if ((v154 == (4 - 2)) or ((3418 - (114 + 319)) >= (6971 - 2115))) then
				if (((5479 - 1203) >= (762 + 433)) and v102.Stormstrike:IsReady() and v49) then
					if (((4814 - 1582) <= (9826 - 5136)) and v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike))) then
						return "stormstrike precombat 12";
					end
				end
				break;
			end
			if ((v154 == (1963 - (556 + 1407))) or ((2102 - (741 + 465)) >= (3611 - (170 + 295)))) then
				if (((1613 + 1448) >= (2718 + 240)) and v102.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (221 - 131)))) then
					if (((2642 + 545) >= (413 + 231)) and v23(v102.WindfuryTotem)) then
						return "windfury_totem precombat 4";
					end
				end
				if (((365 + 279) <= (1934 - (957 + 273))) and v102.FeralSpirit:IsCastable() and v55 and ((v60 and v35) or not v60)) then
					if (((257 + 701) > (380 + 567)) and v23(v102.FeralSpirit)) then
						return "feral_spirit precombat 6";
					end
				end
				v154 = 3 - 2;
			end
		end
	end
	local function v134()
		if (((11837 - 7345) >= (8106 - 5452)) and v102.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v117) and v14:DebuffDown(v102.FlameShockDebuff) and v102.LashingFlames:IsAvailable()) then
			if (((17043 - 13601) >= (3283 - (389 + 1391))) and v23(v102.PrimordialWave, not v14:IsSpellInRange(v102.PrimordialWave))) then
				return "primordial_wave single 1";
			end
		end
		if ((v102.FlameShock:IsReady() and v42 and v14:DebuffDown(v102.FlameShockDebuff) and v102.LashingFlames:IsAvailable()) or ((1989 + 1181) <= (153 + 1311))) then
			if (v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock)) or ((10920 - 6123) == (5339 - (783 + 168)))) then
				return "flame_shock single 2";
			end
		end
		if (((1849 - 1298) <= (670 + 11)) and v102.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (316 - (309 + 2))) and v102.ElementalSpirits:IsAvailable() and (v120.FeralSpiritCount >= (12 - 8))) then
			if (((4489 - (1090 + 122)) > (132 + 275)) and v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast))) then
				return "elemental_blast single 3";
			end
		end
		if (((15768 - 11073) >= (969 + 446)) and v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v117) and (v13:HasTier(1148 - (628 + 490), 1 + 1))) then
			if (v23(v102.Sundering, not v14:IsInRange(19 - 11)) or ((14678 - 11466) <= (1718 - (431 + 343)))) then
				return "sundering single 4";
			end
		end
		if ((v102.LightningBolt:IsReady() and v47 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (10 - 5)) and v13:BuffDown(v102.CracklingThunderBuff) and v13:BuffUp(v102.AscendanceBuff) and (v115 == "Chain Lightning") and (v13:BuffRemains(v102.AscendanceBuff) > (v102.ChainLightning:CooldownRemains() + v13:GCD()))) or ((8956 - 5860) <= (1421 + 377))) then
			if (((453 + 3084) == (5232 - (556 + 1139))) and v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt))) then
				return "lightning_bolt single 5";
			end
		end
		if (((3852 - (6 + 9)) >= (288 + 1282)) and v102.Stormstrike:IsReady() and v49 and (v13:BuffUp(v102.DoomWindsBuff) or v102.DeeplyRootedElements:IsAvailable() or (v102.Stormblast:IsAvailable() and v13:BuffUp(v102.StormbringerBuff)))) then
			if (v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike)) or ((1512 + 1438) == (3981 - (28 + 141)))) then
				return "stormstrike single 6";
			end
		end
		if (((1830 + 2893) >= (2860 - 542)) and v102.LavaLash:IsReady() and v46 and (v13:BuffUp(v102.HotHandBuff))) then
			if (v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash)) or ((1436 + 591) > (4169 - (486 + 831)))) then
				return "lava_lash single 7";
			end
		end
		if ((v102.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v102.WindfuryTotemBuff, true))) or ((2955 - 1819) > (15198 - 10881))) then
			if (((898 + 3850) == (15012 - 10264)) and v23(v102.WindfuryTotem)) then
				return "windfury_totem single 8";
			end
		end
		if (((4999 - (668 + 595)) <= (4266 + 474)) and v102.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (2 + 3)) and (v102.ElementalBlast:Charges() == v114)) then
			if (v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast)) or ((9244 - 5854) <= (3350 - (23 + 267)))) then
				return "elemental_blast single 9";
			end
		end
		if ((v102.LightningBolt:IsReady() and v47 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (1952 - (1129 + 815))) and v13:BuffUp(v102.PrimordialWaveBuff) and (v13:BuffDown(v102.SplinteredElementsBuff) or (v117 <= (399 - (371 + 16))))) or ((2749 - (1326 + 424)) > (5099 - 2406))) then
			if (((1691 - 1228) < (719 - (88 + 30))) and v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt))) then
				return "lightning_bolt single 10";
			end
		end
		if ((v102.ChainLightning:IsReady() and v38 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (779 - (720 + 51))) and v13:BuffUp(v102.CracklingThunderBuff) and v102.ElementalSpirits:IsAvailable()) or ((4855 - 2672) < (2463 - (421 + 1355)))) then
			if (((7504 - 2955) == (2235 + 2314)) and v23(v102.ChainLightning, not v14:IsSpellInRange(v102.ChainLightning))) then
				return "chain_lightning single 11";
			end
		end
		if (((5755 - (286 + 797)) == (17079 - 12407)) and v102.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (12 - 4)) and ((v120.FeralSpiritCount >= (441 - (397 + 42))) or not v102.ElementalSpirits:IsAvailable())) then
			if (v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast)) or ((1146 + 2522) < (1195 - (24 + 776)))) then
				return "elemental_blast single 12";
			end
		end
		if ((v102.LavaBurst:IsReady() and v45 and not v102.ThorimsInvocation:IsAvailable() and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (7 - 2))) or ((4951 - (222 + 563)) == (1002 - 547))) then
			if (v23(v102.LavaBurst, not v14:IsSpellInRange(v102.LavaBurst)) or ((3204 + 1245) == (2853 - (23 + 167)))) then
				return "lava_burst single 13";
			end
		end
		if ((v102.LightningBolt:IsReady() and v47 and ((v13:BuffStack(v102.MaelstromWeaponBuff) >= (1806 - (690 + 1108))) or (v102.StaticAccumulation:IsAvailable() and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (2 + 3)))) and v13:BuffDown(v102.PrimordialWaveBuff)) or ((3528 + 749) < (3837 - (40 + 808)))) then
			if (v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt)) or ((144 + 726) >= (15865 - 11716))) then
				return "lightning_bolt single 14";
			end
		end
		if (((2115 + 97) < (1684 + 1499)) and v102.CrashLightning:IsReady() and v39 and v102.AlphaWolf:IsAvailable() and v13:BuffUp(v102.FeralSpiritBuff) and (v124() == (0 + 0))) then
			if (((5217 - (47 + 524)) > (1942 + 1050)) and v23(v102.CrashLightning, not v14:IsInMeleeRange(21 - 13))) then
				return "crash_lightning single 15";
			end
		end
		if (((2143 - 709) < (7083 - 3977)) and v102.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v117)) then
			if (((2512 - (1165 + 561)) < (90 + 2933)) and v23(v102.PrimordialWave, not v14:IsSpellInRange(v102.PrimordialWave))) then
				return "primordial_wave single 16";
			end
		end
		if ((v102.FlameShock:IsReady() and v42 and (v14:DebuffDown(v102.FlameShockDebuff))) or ((7563 - 5121) < (29 + 45))) then
			if (((5014 - (341 + 138)) == (1225 + 3310)) and v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock))) then
				return "flame_shock single 17";
			end
		end
		if ((v102.IceStrike:IsReady() and v44 and v102.ElementalAssault:IsAvailable() and v102.SwirlingMaelstrom:IsAvailable()) or ((6209 - 3200) <= (2431 - (89 + 237)))) then
			if (((5887 - 4057) < (7724 - 4055)) and v23(v102.IceStrike, not v14:IsInMeleeRange(886 - (581 + 300)))) then
				return "ice_strike single 18";
			end
		end
		if ((v102.LavaLash:IsReady() and v46 and (v102.LashingFlames:IsAvailable())) or ((2650 - (855 + 365)) >= (8579 - 4967))) then
			if (((877 + 1806) >= (3695 - (1030 + 205))) and v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash))) then
				return "lava_lash single 19";
			end
		end
		if ((v102.IceStrike:IsReady() and v44 and (v13:BuffDown(v102.IceStrikeBuff))) or ((1694 + 110) >= (3047 + 228))) then
			if (v23(v102.IceStrike, not v14:IsInMeleeRange(291 - (156 + 130))) or ((3219 - 1802) > (6115 - 2486))) then
				return "ice_strike single 20";
			end
		end
		if (((9820 - 5025) > (106 + 296)) and v102.FrostShock:IsReady() and v43 and (v13:BuffUp(v102.HailstormBuff))) then
			if (((2807 + 2006) > (3634 - (10 + 59))) and v23(v102.FrostShock, not v14:IsSpellInRange(v102.FrostShock))) then
				return "frost_shock single 21";
			end
		end
		if (((1107 + 2805) == (19265 - 15353)) and v102.LavaLash:IsReady() and v46) then
			if (((3984 - (671 + 492)) <= (3841 + 983)) and v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash))) then
				return "lava_lash single 22";
			end
		end
		if (((2953 - (369 + 846)) <= (582 + 1613)) and v102.IceStrike:IsReady() and v44) then
			if (((35 + 6) <= (4963 - (1036 + 909))) and v23(v102.IceStrike, not v14:IsInMeleeRange(4 + 1))) then
				return "ice_strike single 23";
			end
		end
		if (((3601 - 1456) <= (4307 - (11 + 192))) and v102.Windstrike:IsCastable() and v52) then
			if (((1359 + 1330) < (5020 - (135 + 40))) and v23(v102.Windstrike, not v14:IsSpellInRange(v102.Windstrike))) then
				return "windstrike single 24";
			end
		end
		if ((v102.Stormstrike:IsReady() and v49) or ((5625 - 3303) > (1581 + 1041))) then
			if (v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike)) or ((9988 - 5454) == (3120 - 1038))) then
				return "stormstrike single 25";
			end
		end
		if ((v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v117)) or ((1747 - (50 + 126)) > (5198 - 3331))) then
			if (v23(v102.Sundering, not v14:IsInRange(2 + 6)) or ((4067 - (1233 + 180)) >= (3965 - (522 + 447)))) then
				return "sundering single 26";
			end
		end
		if (((5399 - (107 + 1314)) > (977 + 1127)) and v102.BagofTricks:IsReady() and v58 and ((v65 and v35) or not v65)) then
			if (((9126 - 6131) > (655 + 886)) and v23(v102.BagofTricks)) then
				return "bag_of_tricks single 27";
			end
		end
		if (((6451 - 3202) > (3770 - 2817)) and v102.FireNova:IsReady() and v41 and v102.SwirlingMaelstrom:IsAvailable() and v14:DebuffUp(v102.FlameShockDebuff) and (v13:BuffStack(v102.MaelstromWeaponBuff) < ((1915 - (716 + 1194)) + ((1 + 4) * v24(v102.OverflowingMaelstrom:IsAvailable()))))) then
			if (v23(v102.FireNova) or ((351 + 2922) > (5076 - (74 + 429)))) then
				return "fire_nova single 28";
			end
		end
		if ((v102.LightningBolt:IsReady() and v47 and v102.Hailstorm:IsAvailable() and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (9 - 4)) and v13:BuffDown(v102.PrimordialWaveBuff)) or ((1562 + 1589) < (2938 - 1654))) then
			if (v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt)) or ((1309 + 541) == (4713 - 3184))) then
				return "lightning_bolt single 29";
			end
		end
		if (((2029 - 1208) < (2556 - (279 + 154))) and v102.FrostShock:IsReady() and v43) then
			if (((1680 - (454 + 324)) < (1830 + 495)) and v23(v102.FrostShock, not v14:IsSpellInRange(v102.FrostShock))) then
				return "frost_shock single 30";
			end
		end
		if (((875 - (12 + 5)) <= (1597 + 1365)) and v102.CrashLightning:IsReady() and v39) then
			if (v23(v102.CrashLightning, not v14:IsInMeleeRange(20 - 12)) or ((1459 + 2487) < (2381 - (277 + 816)))) then
				return "crash_lightning single 31";
			end
		end
		if ((v102.FireNova:IsReady() and v41 and (v14:DebuffUp(v102.FlameShockDebuff))) or ((13853 - 10611) == (1750 - (1058 + 125)))) then
			if (v23(v102.FireNova) or ((159 + 688) >= (2238 - (815 + 160)))) then
				return "fire_nova single 32";
			end
		end
		if ((v102.FlameShock:IsReady() and v42) or ((9666 - 7413) == (4393 - 2542))) then
			if (v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock)) or ((498 + 1589) > (6933 - 4561))) then
				return "flame_shock single 34";
			end
		end
		if ((v102.ChainLightning:IsReady() and v38 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (1903 - (41 + 1857))) and v13:BuffUp(v102.CracklingThunderBuff) and v102.ElementalSpirits:IsAvailable()) or ((6338 - (1222 + 671)) < (10723 - 6574))) then
			if (v23(v102.ChainLightning, not v14:IsSpellInRange(v102.ChainLightning)) or ((2612 - 794) == (1267 - (229 + 953)))) then
				return "chain_lightning single 35";
			end
		end
		if (((2404 - (1111 + 663)) < (3706 - (874 + 705))) and v102.LightningBolt:IsReady() and v47 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (1 + 4)) and v13:BuffDown(v102.PrimordialWaveBuff)) then
			if (v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt)) or ((1323 + 615) == (5225 - 2711))) then
				return "lightning_bolt single 36";
			end
		end
		if (((120 + 4135) >= (734 - (642 + 37))) and v102.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (21 + 69)))) then
			if (((480 + 2519) > (2902 - 1746)) and v23(v102.WindfuryTotem)) then
				return "windfury_totem single 37";
			end
		end
	end
	local function v135()
		if (((2804 - (233 + 221)) > (2670 - 1515)) and v102.CrashLightning:IsReady() and v39 and v102.CrashingStorms:IsAvailable() and ((v102.UnrulyWinds:IsAvailable() and (v112 >= (9 + 1))) or (v112 >= (1556 - (718 + 823))))) then
			if (((2536 + 1493) <= (5658 - (266 + 539))) and v23(v102.CrashLightning, not v14:IsInMeleeRange(22 - 14))) then
				return "crash_lightning aoe 1";
			end
		end
		if ((v102.LightningBolt:IsReady() and v47 and ((v102.FlameShockDebuff:AuraActiveCount() >= v112) or (v13:BuffRemains(v102.PrimordialWaveBuff) < (v13:GCD() * (1228 - (636 + 589)))) or (v102.FlameShockDebuff:AuraActiveCount() >= (14 - 8))) and v13:BuffUp(v102.PrimordialWaveBuff) and (v13:BuffStack(v102.MaelstromWeaponBuff) == ((10 - 5) + ((4 + 1) * v24(v102.OverflowingMaelstrom:IsAvailable())))) and (v13:BuffDown(v102.SplinteredElementsBuff) or (v117 <= (5 + 7)) or (v99 <= v13:GCD()))) or ((1531 - (657 + 358)) > (9092 - 5658))) then
			if (((9217 - 5171) >= (4220 - (1151 + 36))) and v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt))) then
				return "lightning_bolt aoe 2";
			end
		end
		if ((v102.LavaLash:IsReady() and v46 and v102.MoltenAssault:IsAvailable() and (v102.PrimordialWave:IsAvailable() or v102.FireNova:IsAvailable()) and v14:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (6 + 0))) or ((715 + 2004) <= (4321 - 2874))) then
			if (v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash)) or ((5966 - (1552 + 280)) < (4760 - (64 + 770)))) then
				return "lava_lash aoe 3";
			end
		end
		if ((v102.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v117) and (v13:BuffDown(v102.PrimordialWaveBuff))) or ((112 + 52) >= (6322 - 3537))) then
			local v194 = 0 + 0;
			while true do
				if ((v194 == (1243 - (157 + 1086))) or ((1050 - 525) == (9236 - 7127))) then
					if (((49 - 16) == (44 - 11)) and v118.CastCycle(v102.PrimordialWave, v111, v125, not v14:IsSpellInRange(v102.PrimordialWave))) then
						return "primordial_wave aoe 4";
					end
					if (((3873 - (599 + 220)) <= (7995 - 3980)) and v23(v102.PrimordialWave, not v14:IsSpellInRange(v102.PrimordialWave))) then
						return "primordial_wave aoe no_cycle 4";
					end
					break;
				end
			end
		end
		if (((3802 - (1813 + 118)) < (2473 + 909)) and v102.FlameShock:IsReady() and v42 and (v102.PrimordialWave:IsAvailable() or v102.FireNova:IsAvailable()) and v14:DebuffDown(v102.FlameShockDebuff)) then
			if (((2510 - (841 + 376)) <= (3034 - 868)) and v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock))) then
				return "flame_shock aoe 5";
			end
		end
		if ((v102.ElementalBlast:IsReady() and v40 and (not v102.ElementalSpirits:IsAvailable() or (v102.ElementalSpirits:IsAvailable() and ((v102.ElementalBlast:Charges() == v114) or (v120.FeralSpiritCount >= (1 + 1))))) and (v13:BuffStack(v102.MaelstromWeaponBuff) == ((13 - 8) + ((864 - (464 + 395)) * v24(v102.OverflowingMaelstrom:IsAvailable())))) and (not v102.CrashingStorms:IsAvailable() or (v112 <= (7 - 4)))) or ((1239 + 1340) < (960 - (467 + 370)))) then
			if (v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast)) or ((1747 - 901) >= (1739 + 629))) then
				return "elemental_blast aoe 6";
			end
		end
		if ((v102.ChainLightning:IsReady() and v38 and (v13:BuffStack(v102.MaelstromWeaponBuff) == ((17 - 12) + ((1 + 4) * v24(v102.OverflowingMaelstrom:IsAvailable()))))) or ((9333 - 5321) <= (3878 - (150 + 370)))) then
			if (((2776 - (74 + 1208)) <= (7391 - 4386)) and v23(v102.ChainLightning, not v14:IsSpellInRange(v102.ChainLightning))) then
				return "chain_lightning aoe 7";
			end
		end
		if ((v102.CrashLightning:IsReady() and v39 and (v13:BuffUp(v102.DoomWindsBuff) or v13:BuffDown(v102.CrashLightningBuff) or (v102.AlphaWolf:IsAvailable() and v13:BuffUp(v102.FeralSpiritBuff) and (v124() == (0 - 0))))) or ((2214 + 897) == (2524 - (14 + 376)))) then
			if (((4084 - 1729) == (1524 + 831)) and v23(v102.CrashLightning, not v14:IsInMeleeRange(8 + 0))) then
				return "crash_lightning aoe 8";
			end
		end
		if ((v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v117) and (v13:BuffUp(v102.DoomWindsBuff) or v13:HasTier(29 + 1, 5 - 3))) or ((443 + 145) <= (510 - (23 + 55)))) then
			if (((11368 - 6571) >= (2600 + 1295)) and v23(v102.Sundering, not v14:IsInRange(8 + 0))) then
				return "sundering aoe 9";
			end
		end
		if (((5545 - 1968) == (1126 + 2451)) and v102.FireNova:IsReady() and v41 and ((v102.FlameShockDebuff:AuraActiveCount() >= (907 - (652 + 249))) or ((v102.FlameShockDebuff:AuraActiveCount() >= (10 - 6)) and (v102.FlameShockDebuff:AuraActiveCount() >= v112)))) then
			if (((5662 - (708 + 1160)) > (10024 - 6331)) and v23(v102.FireNova)) then
				return "fire_nova aoe 10";
			end
		end
		if ((v102.LavaLash:IsReady() and v46 and (v102.LashingFlames:IsAvailable())) or ((2324 - 1049) == (4127 - (10 + 17)))) then
			if (v118.CastCycle(v102.LavaLash, v111, v126, not v14:IsSpellInRange(v102.LavaLash)) or ((358 + 1233) >= (5312 - (1400 + 332)))) then
				return "lava_lash aoe 11";
			end
			if (((1885 - 902) <= (3716 - (242 + 1666))) and v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash))) then
				return "lava_lash aoe no_cycle 11";
			end
		end
		if ((v102.LavaLash:IsReady() and v46 and ((v102.MoltenAssault:IsAvailable() and v14:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (3 + 3))) or (v102.AshenCatalyst:IsAvailable() and (v13:BuffStack(v102.AshenCatalystBuff) == (2 + 3))))) or ((1833 + 317) <= (2137 - (850 + 90)))) then
			if (((6600 - 2831) >= (2563 - (360 + 1030))) and v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash))) then
				return "lava_lash aoe 12";
			end
		end
		if (((1315 + 170) == (4191 - 2706)) and v102.IceStrike:IsReady() and v44 and (v102.Hailstorm:IsAvailable())) then
			if (v23(v102.IceStrike, not v14:IsInMeleeRange(6 - 1)) or ((4976 - (909 + 752)) <= (4005 - (109 + 1114)))) then
				return "ice_strike aoe 13";
			end
		end
		if ((v102.FrostShock:IsReady() and v43 and v102.Hailstorm:IsAvailable() and v13:BuffUp(v102.HailstormBuff)) or ((1603 - 727) >= (1154 + 1810))) then
			if (v23(v102.FrostShock, not v14:IsSpellInRange(v102.FrostShock)) or ((2474 - (6 + 236)) > (1574 + 923))) then
				return "frost_shock aoe 14";
			end
		end
		if ((v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v117)) or ((1699 + 411) <= (782 - 450))) then
			if (((6438 - 2752) > (4305 - (1076 + 57))) and v23(v102.Sundering, not v14:IsInRange(2 + 6))) then
				return "sundering aoe 15";
			end
		end
		if ((v102.FlameShock:IsReady() and v42 and v102.MoltenAssault:IsAvailable() and v14:DebuffDown(v102.FlameShockDebuff)) or ((5163 - (579 + 110)) < (65 + 755))) then
			if (((3784 + 495) >= (1530 + 1352)) and v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock))) then
				return "flame_shock aoe 16";
			end
		end
		if ((v102.FlameShock:IsReady() and v42 and v14:DebuffRefreshable(v102.FlameShockDebuff) and (v102.FireNova:IsAvailable() or v102.PrimordialWave:IsAvailable()) and (v102.FlameShockDebuff:AuraActiveCount() < v112) and (v102.FlameShockDebuff:AuraActiveCount() < (413 - (174 + 233)))) or ((5667 - 3638) >= (6179 - 2658))) then
			if (v118.CastCycle(v102.FlameShock, v111, v125, not v14:IsSpellInRange(v102.FlameShock)) or ((906 + 1131) >= (5816 - (663 + 511)))) then
				return "flame_shock aoe 17";
			end
			if (((1535 + 185) < (968 + 3490)) and v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock))) then
				return "flame_shock aoe no_cycle 17";
			end
		end
		if ((v102.FireNova:IsReady() and v41 and (v102.FlameShockDebuff:AuraActiveCount() >= (9 - 6))) or ((265 + 171) > (7112 - 4091))) then
			if (((1725 - 1012) <= (405 + 442)) and v23(v102.FireNova)) then
				return "fire_nova aoe 18";
			end
		end
		if (((4191 - 2037) <= (2873 + 1158)) and v102.Stormstrike:IsReady() and v49 and v13:BuffUp(v102.CrashLightningBuff) and (v102.DeeplyRootedElements:IsAvailable() or (v13:BuffStack(v102.ConvergingStormsBuff) == (1 + 5)))) then
			if (((5337 - (478 + 244)) == (5132 - (440 + 77))) and v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike))) then
				return "stormstrike aoe 19";
			end
		end
		if ((v102.CrashLightning:IsReady() and v39 and v102.CrashingStorms:IsAvailable() and v13:BuffUp(v102.CLCrashLightningBuff) and (v112 >= (2 + 2))) or ((13871 - 10081) == (2056 - (655 + 901)))) then
			if (((17 + 72) < (170 + 51)) and v23(v102.CrashLightning, not v14:IsInMeleeRange(6 + 2))) then
				return "crash_lightning aoe 20";
			end
		end
		if (((8274 - 6220) >= (2866 - (695 + 750))) and v102.Windstrike:IsCastable() and v52) then
			if (((2362 - 1670) < (4718 - 1660)) and v23(v102.Windstrike, not v14:IsSpellInRange(v102.Windstrike))) then
				return "windstrike aoe 21";
			end
		end
		if ((v102.Stormstrike:IsReady() and v49) or ((13086 - 9832) == (2006 - (285 + 66)))) then
			if (v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike)) or ((3020 - 1724) == (6220 - (682 + 628)))) then
				return "stormstrike aoe 22";
			end
		end
		if (((543 + 2825) == (3667 - (176 + 123))) and v102.IceStrike:IsReady() and v44) then
			if (((1106 + 1537) < (2768 + 1047)) and v23(v102.IceStrike, not v14:IsInMeleeRange(274 - (239 + 30)))) then
				return "ice_strike aoe 23";
			end
		end
		if (((521 + 1392) > (474 + 19)) and v102.LavaLash:IsReady() and v46) then
			if (((8415 - 3660) > (10694 - 7266)) and v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash))) then
				return "lava_lash aoe 24";
			end
		end
		if (((1696 - (306 + 9)) <= (8266 - 5897)) and v102.CrashLightning:IsReady() and v39) then
			if (v23(v102.CrashLightning, not v14:IsInMeleeRange(2 + 6)) or ((2972 + 1871) == (1966 + 2118))) then
				return "crash_lightning aoe 25";
			end
		end
		if (((13351 - 8682) > (1738 - (1140 + 235))) and v102.FireNova:IsReady() and v41 and (v102.FlameShockDebuff:AuraActiveCount() >= (2 + 0))) then
			if (v23(v102.FireNova) or ((1722 + 155) >= (806 + 2332))) then
				return "fire_nova aoe 26";
			end
		end
		if (((4794 - (33 + 19)) >= (1310 + 2316)) and v102.ElementalBlast:IsReady() and v40 and (not v102.ElementalSpirits:IsAvailable() or (v102.ElementalSpirits:IsAvailable() and ((v102.ElementalBlast:Charges() == v114) or (v120.FeralSpiritCount >= (5 - 3))))) and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (3 + 2)) and (not v102.CrashingStorms:IsAvailable() or (v112 <= (5 - 2)))) then
			if (v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast)) or ((4258 + 282) == (1605 - (586 + 103)))) then
				return "elemental_blast aoe 27";
			end
		end
		if ((v102.ChainLightning:IsReady() and v38 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (1 + 4))) or ((3558 - 2402) > (5833 - (1309 + 179)))) then
			if (((4037 - 1800) < (1850 + 2399)) and v23(v102.ChainLightning, not v14:IsSpellInRange(v102.ChainLightning))) then
				return "chain_lightning aoe 28";
			end
		end
		if ((v102.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (241 - 151)))) or ((2027 + 656) < (48 - 25))) then
			if (((1388 - 691) <= (1435 - (295 + 314))) and v23(v102.WindfuryTotem)) then
				return "windfury_totem aoe 29";
			end
		end
		if (((2714 - 1609) <= (3138 - (1300 + 662))) and v102.FlameShock:IsReady() and v42 and (v14:DebuffDown(v102.FlameShockDebuff))) then
			if (((10610 - 7231) <= (5567 - (1178 + 577))) and v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock))) then
				return "flame_shock aoe 30";
			end
		end
		if ((v102.FrostShock:IsReady() and v43 and not v102.Hailstorm:IsAvailable()) or ((410 + 378) >= (4776 - 3160))) then
			if (((3259 - (851 + 554)) <= (2988 + 391)) and v23(v102.FrostShock, not v14:IsSpellInRange(v102.FrostShock))) then
				return "frost_shock aoe 31";
			end
		end
	end
	local function v136()
		local v155 = 0 - 0;
		while true do
			if (((9879 - 5330) == (4851 - (115 + 187))) and (v155 == (1 + 0))) then
				if (((not v107 or (v109 < (568011 + 31989))) and v53 and v102.FlametongueWeapon:IsCastable()) or ((11908 - 8886) >= (4185 - (160 + 1001)))) then
					if (((4217 + 603) > (1517 + 681)) and v23(v102.FlametongueWeapon)) then
						return "flametongue_weapon enchant";
					end
				end
				if (v85 or ((2171 - 1110) >= (5249 - (237 + 121)))) then
					v32 = v130();
					if (((2261 - (525 + 372)) <= (8479 - 4006)) and v32) then
						return v32;
					end
				end
				v155 = 6 - 4;
			end
			if ((v155 == (144 - (96 + 46))) or ((4372 - (643 + 134)) <= (2 + 1))) then
				if ((v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) or ((11202 - 6530) == (14301 - 10449))) then
					if (((1496 + 63) == (3058 - 1499)) and v23(v102.AncestralSpirit, nil, true)) then
						return "resurrection";
					end
				end
				if ((v118.TargetIsValid() and v33) or ((3581 - 1829) <= (1507 - (316 + 403)))) then
					if (not v13:AffectingCombat() or ((2597 + 1310) == (486 - 309))) then
						local v235 = 0 + 0;
						while true do
							if (((8738 - 5268) > (394 + 161)) and (v235 == (0 + 0))) then
								v32 = v133();
								if (v32 or ((3367 - 2395) == (3080 - 2435))) then
									return v32;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((6610 - 3428) >= (122 + 1993)) and (v155 == (0 - 0))) then
				if (((191 + 3702) < (13030 - 8601)) and v75 and v102.EarthShield:IsCastable() and v13:BuffDown(v102.EarthShieldBuff) and ((v76 == "Earth Shield") or (v102.ElementalOrbit:IsAvailable() and v13:BuffUp(v102.LightningShield)))) then
					if (v23(v102.EarthShield) or ((2884 - (12 + 5)) < (7399 - 5494))) then
						return "earth_shield main 2";
					end
				elseif ((v75 and v102.LightningShield:IsCastable() and v13:BuffDown(v102.LightningShieldBuff) and ((v76 == "Lightning Shield") or (v102.ElementalOrbit:IsAvailable() and v13:BuffUp(v102.EarthShield)))) or ((3831 - 2035) >= (8611 - 4560))) then
					if (((4014 - 2395) <= (763 + 2993)) and v23(v102.LightningShield)) then
						return "lightning_shield main 2";
					end
				end
				if (((2577 - (1656 + 317)) == (539 + 65)) and (not v106 or (v108 < (480802 + 119198))) and v53 and v102.WindfuryWeapon:IsCastable()) then
					if (v23(v102.WindfuryWeapon) or ((11922 - 7438) == (4429 - 3529))) then
						return "windfury_weapon enchant";
					end
				end
				v155 = 355 - (5 + 349);
			end
		end
	end
	local function v137()
		v32 = v131();
		if (v32 or ((21179 - 16720) <= (2384 - (266 + 1005)))) then
			return v32;
		end
		if (((2394 + 1238) > (11594 - 8196)) and v93) then
			local v195 = 0 - 0;
			while true do
				if (((5778 - (561 + 1135)) <= (6407 - 1490)) and (v195 == (3 - 2))) then
					if (((5898 - (507 + 559)) >= (3477 - 2091)) and v89) then
						local v236 = 0 - 0;
						while true do
							if (((525 - (212 + 176)) == (1042 - (250 + 655))) and (v236 == (0 - 0))) then
								v32 = v118.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 52 - 22);
								if (v32 or ((2456 - 886) >= (6288 - (1869 + 87)))) then
									return v32;
								end
								break;
							end
						end
					end
					if (((v13:BuffStack(v102.MaelstromWeaponBuff) >= (17 - 12)) and v90) or ((5965 - (484 + 1417)) <= (3898 - 2079))) then
						v32 = v118.HandleAfflicted(v102.HealingSurge, v104.HealingSurgeMouseover, 67 - 27, true);
						if (v32 or ((5759 - (48 + 725)) < (2570 - 996))) then
							return v32;
						end
					end
					break;
				end
				if (((11874 - 7448) > (100 + 72)) and (v195 == (0 - 0))) then
					if (((164 + 422) > (133 + 322)) and v87) then
						local v237 = 853 - (152 + 701);
						while true do
							if (((2137 - (430 + 881)) == (317 + 509)) and (v237 == (895 - (557 + 338)))) then
								v32 = v118.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 12 + 28);
								if (v32 or ((11325 - 7306) > (15551 - 11110))) then
									return v32;
								end
								break;
							end
						end
					end
					if (((5358 - 3341) < (9183 - 4922)) and v88) then
						v32 = v118.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 831 - (499 + 302));
						if (((5582 - (39 + 827)) > (220 - 140)) and v32) then
							return v32;
						end
					end
					v195 = 2 - 1;
				end
			end
		end
		if (v94 or ((13929 - 10422) == (5022 - 1750))) then
			local v196 = 0 + 0;
			while true do
				if ((v196 == (0 - 0)) or ((141 + 735) >= (4865 - 1790))) then
					v32 = v118.HandleIncorporeal(v102.Hex, v104.HexMouseOver, 134 - (103 + 1), true);
					if (((4906 - (475 + 79)) > (5520 - 2966)) and v32) then
						return v32;
					end
					break;
				end
			end
		end
		if (v15 or ((14099 - 9693) < (523 + 3520))) then
			if (v92 or ((1663 + 226) >= (4886 - (1395 + 108)))) then
				local v225 = 0 - 0;
				while true do
					if (((3096 - (7 + 1197)) <= (1193 + 1541)) and (v225 == (1 + 0))) then
						if (((2242 - (27 + 292)) < (6499 - 4281)) and v16 and v16:Exists() and not v13:CanAttack(v16) and v118.UnitHasDispellableDebuffByPlayer(v16)) then
							if (((2770 - 597) > (1589 - 1210)) and v102.CleanseSpirit:IsCastable()) then
								if (v23(v104.CleanseSpiritMouseover, not v16:IsSpellInRange(v102.PurifySpirit)) or ((5109 - 2518) == (6491 - 3082))) then
									return "purify_spirit dispel mouseover";
								end
							end
						end
						break;
					end
					if (((4653 - (43 + 96)) > (13558 - 10234)) and (v225 == (0 - 0))) then
						v32 = v128();
						if (v32 or ((173 + 35) >= (1364 + 3464))) then
							return v32;
						end
						v225 = 1 - 0;
					end
				end
			end
		end
		if ((v102.GreaterPurge:IsAvailable() and v100 and v102.GreaterPurge:IsReady() and v37 and v91 and not v13:IsCasting() and not v13:IsChanneling() and v118.UnitHasMagicBuff(v14)) or ((607 + 976) > (6684 - 3117))) then
			if (v23(v102.GreaterPurge, not v14:IsSpellInRange(v102.GreaterPurge)) or ((414 + 899) == (59 + 735))) then
				return "greater_purge damage";
			end
		end
		if (((4925 - (1414 + 337)) > (4842 - (1642 + 298))) and v102.Purge:IsReady() and v100 and v37 and v91 and not v13:IsCasting() and not v13:IsChanneling() and v118.UnitHasMagicBuff(v14)) then
			if (((10740 - 6620) <= (12255 - 7995)) and v23(v102.Purge, not v14:IsSpellInRange(v102.Purge))) then
				return "purge damage";
			end
		end
		v32 = v129();
		if (v32 or ((2620 - 1737) > (1573 + 3205))) then
			return v32;
		end
		if (v118.TargetIsValid() or ((2817 + 803) >= (5863 - (357 + 615)))) then
			local v197 = v118.HandleDPSPotion(v13:BuffUp(v102.FeralSpiritBuff));
			if (((2989 + 1269) > (2299 - 1362)) and v197) then
				return v197;
			end
			if ((v99 < v117) or ((4172 + 697) < (1941 - 1035))) then
				if ((v57 and ((v35 and v64) or not v64)) or ((980 + 245) > (288 + 3940))) then
					local v233 = 0 + 0;
					while true do
						if (((4629 - (384 + 917)) > (2935 - (128 + 569))) and (v233 == (1543 - (1407 + 136)))) then
							v32 = v132();
							if (((5726 - (687 + 1200)) > (3115 - (556 + 1154))) and v32) then
								return v32;
							end
							break;
						end
					end
				end
			end
			if (((v99 < v117) and v58 and ((v65 and v35) or not v65)) or ((4548 - 3255) <= (602 - (9 + 86)))) then
				local v226 = 421 - (275 + 146);
				while true do
					if ((v226 == (1 + 0)) or ((2960 - (29 + 35)) < (3567 - 2762))) then
						if (((6917 - 4601) == (10223 - 7907)) and v102.Fireblood:IsCastable() and (not v102.Ascendance:IsAvailable() or v13:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (33 + 17)))) then
							if (v23(v102.Fireblood) or ((3582 - (53 + 959)) == (1941 - (312 + 96)))) then
								return "fireblood racial";
							end
						end
						if ((v102.AncestralCall:IsCastable() and (not v102.Ascendance:IsAvailable() or v13:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (86 - 36)))) or ((1168 - (147 + 138)) == (2359 - (813 + 86)))) then
							if (v23(v102.AncestralCall) or ((4175 + 444) <= (1850 - 851))) then
								return "ancestral_call racial";
							end
						end
						break;
					end
					if ((v226 == (492 - (18 + 474))) or ((1151 + 2259) > (13434 - 9318))) then
						if ((v102.BloodFury:IsCastable() and (not v102.Ascendance:IsAvailable() or v13:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (1136 - (860 + 226))))) or ((1206 - (121 + 182)) >= (377 + 2682))) then
							if (v23(v102.BloodFury) or ((5216 - (988 + 252)) < (323 + 2534))) then
								return "blood_fury racial";
							end
						end
						if (((1545 + 3385) > (4277 - (49 + 1921))) and v102.Berserking:IsCastable() and (not v102.Ascendance:IsAvailable() or v13:BuffUp(v102.AscendanceBuff))) then
							if (v23(v102.Berserking) or ((4936 - (223 + 667)) < (1343 - (51 + 1)))) then
								return "berserking racial";
							end
						end
						v226 = 1 - 0;
					end
				end
			end
			if ((v102.TotemicProjection:IsCastable() and (v102.WindfuryTotem:TimeSinceLastCast() < (192 - 102)) and v13:BuffDown(v102.WindfuryTotemBuff, true)) or ((5366 - (146 + 979)) == (1001 + 2544))) then
				if (v23(v104.TotemicProjectionPlayer) or ((4653 - (311 + 294)) > (11801 - 7569))) then
					return "totemic_projection wind_fury main 0";
				end
			end
			if ((v102.Windstrike:IsCastable() and v52) or ((742 + 1008) >= (4916 - (496 + 947)))) then
				if (((4524 - (1233 + 125)) == (1285 + 1881)) and v23(v102.Windstrike, not v14:IsSpellInRange(v102.Windstrike))) then
					return "windstrike main 1";
				end
			end
			if (((1582 + 181) < (708 + 3016)) and v102.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v117) and (v13:HasTier(1676 - (963 + 682), 2 + 0))) then
				if (((1561 - (504 + 1000)) <= (1834 + 889)) and v23(v102.PrimordialWave, not v14:IsSpellInRange(v102.PrimordialWave))) then
					return "primordial_wave main 2";
				end
			end
			if ((v102.FeralSpirit:IsCastable() and v55 and ((v60 and v35) or not v60) and (v99 < v117)) or ((1886 + 184) == (42 + 401))) then
				if (v23(v102.FeralSpirit) or ((3988 - 1283) == (1191 + 202))) then
					return "feral_spirit main 3";
				end
			end
			if ((v102.Ascendance:IsCastable() and v54 and ((v59 and v35) or not v59) and (v99 < v117) and v14:DebuffUp(v102.FlameShockDebuff) and (((v115 == "Lightning Bolt") and (v112 == (1 + 0))) or ((v115 == "Chain Lightning") and (v112 > (183 - (156 + 26)))))) or ((2651 + 1950) < (95 - 34))) then
				if (v23(v102.Ascendance) or ((1554 - (149 + 15)) >= (5704 - (890 + 70)))) then
					return "ascendance main 4";
				end
			end
			if ((v102.DoomWinds:IsCastable() and v56 and ((v61 and v35) or not v61) and (v99 < v117)) or ((2120 - (39 + 78)) > (4316 - (14 + 468)))) then
				if (v23(v102.DoomWinds, not v14:IsInMeleeRange(10 - 5)) or ((436 - 280) > (2019 + 1894))) then
					return "doom_winds main 5";
				end
			end
			if (((118 + 77) == (42 + 153)) and (v112 == (1 + 0))) then
				v32 = v134();
				if (((814 + 2291) >= (3437 - 1641)) and v32) then
					return v32;
				end
			end
			if (((4328 + 51) >= (7488 - 5357)) and v34 and (v112 > (1 + 0))) then
				local v227 = 51 - (12 + 39);
				while true do
					if (((3577 + 267) >= (6323 - 4280)) and (v227 == (0 - 0))) then
						v32 = v135();
						if (v32 or ((959 + 2273) <= (1438 + 1293))) then
							return v32;
						end
						break;
					end
				end
			end
		end
	end
	local function v138()
		local v156 = 0 - 0;
		while true do
			if (((3268 + 1637) == (23704 - 18799)) and (v156 == (1714 - (1596 + 114)))) then
				v52 = EpicSettings.Settings['useWindstrike'];
				v51 = EpicSettings.Settings['useWindfuryTotem'];
				v53 = EpicSettings.Settings['useWeaponEnchant'];
				v101 = EpicSettings.Settings['useWeapon'];
				v156 = 12 - 7;
			end
			if ((v156 == (713 - (164 + 549))) or ((5574 - (1059 + 379)) >= (5477 - 1066))) then
				v54 = EpicSettings.Settings['useAscendance'];
				v56 = EpicSettings.Settings['useDoomWinds'];
				v55 = EpicSettings.Settings['useFeralSpirit'];
				v38 = EpicSettings.Settings['useChainlightning'];
				v156 = 1 + 0;
			end
			if (((2 + 4) == v156) or ((3350 - (145 + 247)) == (3297 + 720))) then
				v62 = EpicSettings.Settings['sunderingWithMiniCD'];
				break;
			end
			if (((568 + 660) >= (2409 - 1596)) and (v156 == (1 + 2))) then
				v47 = EpicSettings.Settings['useLightningBolt'];
				v48 = EpicSettings.Settings['usePrimordialWave'];
				v49 = EpicSettings.Settings['useStormStrike'];
				v50 = EpicSettings.Settings['useSundering'];
				v156 = 4 + 0;
			end
			if ((v156 == (7 - 2)) or ((4175 - (254 + 466)) > (4610 - (544 + 16)))) then
				v59 = EpicSettings.Settings['ascendanceWithCD'];
				v61 = EpicSettings.Settings['doomWindsWithCD'];
				v60 = EpicSettings.Settings['feralSpiritWithCD'];
				v63 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v156 = 18 - 12;
			end
			if (((871 - (294 + 334)) == (496 - (236 + 17))) and (v156 == (1 + 1))) then
				v43 = EpicSettings.Settings['useFrostShock'];
				v44 = EpicSettings.Settings['useIceStrike'];
				v45 = EpicSettings.Settings['useLavaBurst'];
				v46 = EpicSettings.Settings['useLavaLash'];
				v156 = 3 + 0;
			end
			if ((v156 == (3 - 2)) or ((1283 - 1012) > (810 + 762))) then
				v39 = EpicSettings.Settings['useCrashLightning'];
				v40 = EpicSettings.Settings['useElementalBlast'];
				v41 = EpicSettings.Settings['useFireNova'];
				v42 = EpicSettings.Settings['useFlameShock'];
				v156 = 2 + 0;
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
		v78 = EpicSettings.Settings['ancestralGuidanceHP'] or (794 - (413 + 381));
		v79 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
		v77 = EpicSettings.Settings['astralShiftHP'] or (0 - 0);
		v80 = EpicSettings.Settings['healingStreamTotemHP'] or (0 - 0);
		v81 = EpicSettings.Settings['healingStreamTotemGroup'] or (1970 - (582 + 1388));
		v82 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (0 - 0);
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
		v99 = EpicSettings.Settings['fightRemainsCheck'] or (364 - (326 + 38));
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
		v83 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v84 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v95 = EpicSettings.Settings['HealingPotionName'] or "";
		v93 = EpicSettings.Settings['handleAfflicted'];
		v94 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v141()
		v139();
		v138();
		v140();
		v33 = EpicSettings.Toggles['ooc'];
		v34 = EpicSettings.Toggles['aoe'];
		v35 = EpicSettings.Toggles['cds'];
		v37 = EpicSettings.Toggles['dispel'];
		v36 = EpicSettings.Toggles['minicds'];
		if (((3359 - (47 + 573)) < (1161 + 2132)) and v13:IsDeadOrGhost()) then
			return v32;
		end
		v106, v108, _, _, v107, v109 = v26();
		v110 = v13:GetEnemiesInRange(169 - 129);
		v111 = v13:GetEnemiesInMeleeRange(16 - 6);
		if (v34 or ((5606 - (1269 + 395)) < (1626 - (76 + 416)))) then
			local v198 = 443 - (319 + 124);
			while true do
				if ((v198 == (0 - 0)) or ((3700 - (564 + 443)) == (13766 - 8793))) then
					v113 = #v110;
					v112 = #v111;
					break;
				end
			end
		else
			v113 = 459 - (337 + 121);
			v112 = 2 - 1;
		end
		if (((7148 - 5002) == (4057 - (1261 + 650))) and v37 and v92) then
			local v199 = 0 + 0;
			while true do
				if ((v199 == (0 - 0)) or ((4061 - (772 + 1045)) == (455 + 2769))) then
					if ((v13:AffectingCombat() and v102.CleanseSpirit:IsAvailable()) or ((5048 - (102 + 42)) <= (3760 - (1524 + 320)))) then
						local v238 = v92 and v102.CleanseSpirit:IsReady() and v37;
						v32 = v118.FocusUnit(v238, nil, 1290 - (1049 + 221), nil, 181 - (18 + 138), v102.HealingSurge);
						if (((220 - 130) <= (2167 - (67 + 1035))) and v32) then
							return v32;
						end
					end
					if (((5150 - (136 + 212)) == (20405 - 15603)) and v102.CleanseSpirit:IsAvailable()) then
						if ((v16 and v16:Exists() and v16:IsAPlayer() and v118.UnitHasCurseDebuff(v16)) or ((1827 + 453) <= (472 + 39))) then
							if (v102.CleanseSpirit:IsReady() or ((3280 - (240 + 1364)) <= (1545 - (1050 + 32)))) then
								if (((13814 - 9945) == (2289 + 1580)) and v23(v104.CleanseSpiritMouseover)) then
									return "cleanse_spirit mouseover";
								end
							end
						end
					end
					break;
				end
			end
		end
		if (((2213 - (331 + 724)) <= (211 + 2402)) and (v118.TargetIsValid() or v13:AffectingCombat())) then
			v116 = v9.BossFightRemains(nil, true);
			v117 = v116;
			if ((v117 == (11755 - (269 + 375))) or ((3089 - (267 + 458)) <= (622 + 1377))) then
				v117 = v9.FightRemains(v111, false);
			end
		end
		if (v13:AffectingCombat() or ((9464 - 4542) < (1012 - (667 + 151)))) then
			if (v13:PrevGCD(1498 - (1410 + 87), v102.ChainLightning) or ((3988 - (1504 + 393)) < (83 - 52))) then
				v115 = "Chain Lightning";
			elseif (v13:PrevGCD(2 - 1, v102.LightningBolt) or ((3226 - (461 + 335)) >= (623 + 4249))) then
				v115 = "Lightning Bolt";
			end
		end
		if ((not v13:IsChanneling() and not v13:IsChanneling()) or ((6531 - (1730 + 31)) < (3402 - (728 + 939)))) then
			if (v93 or ((15721 - 11282) <= (4766 - 2416))) then
				local v228 = 0 - 0;
				while true do
					if (((1068 - (138 + 930)) == v228) or ((4093 + 386) < (3492 + 974))) then
						if (((2183 + 364) > (5001 - 3776)) and v87) then
							local v243 = 1766 - (459 + 1307);
							while true do
								if (((6541 - (474 + 1396)) > (4668 - 1994)) and (v243 == (0 + 0))) then
									v32 = v118.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 1 + 39);
									if (v32 or ((10586 - 6890) < (422 + 2905))) then
										return v32;
									end
									break;
								end
							end
						end
						if (v88 or ((15162 - 10620) == (12952 - 9982))) then
							local v244 = 591 - (562 + 29);
							while true do
								if (((215 + 37) <= (3396 - (374 + 1045))) and (v244 == (0 + 0))) then
									v32 = v118.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 93 - 63);
									if (v32 or ((2074 - (448 + 190)) == (1219 + 2556))) then
										return v32;
									end
									break;
								end
							end
						end
						v228 = 1 + 0;
					end
					if ((v228 == (1 + 0)) or ((6220 - 4602) < (2889 - 1959))) then
						if (((6217 - (1307 + 187)) > (16468 - 12315)) and v89) then
							local v245 = 0 - 0;
							while true do
								if ((v245 == (0 - 0)) or ((4337 - (232 + 451)) >= (4444 + 210))) then
									v32 = v118.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 27 + 3);
									if (((1515 - (510 + 54)) <= (3014 - 1518)) and v32) then
										return v32;
									end
									break;
								end
							end
						end
						if (((v13:BuffStack(v102.MaelstromWeaponBuff) >= (41 - (13 + 23))) and v90) or ((3383 - 1647) == (820 - 249))) then
							v32 = v118.HandleAfflicted(v102.HealingSurge, v104.HealingSurgeMouseover, 72 - 32, true);
							if (v32 or ((1984 - (830 + 258)) > (16822 - 12053))) then
								return v32;
							end
						end
						break;
					end
				end
			end
			if (v13:AffectingCombat() or ((654 + 391) <= (868 + 152))) then
				v32 = v137();
				if (v32 or ((2601 - (860 + 581)) <= (1209 - 881))) then
					return v32;
				end
			else
				local v229 = 0 + 0;
				while true do
					if (((4049 - (237 + 4)) > (6871 - 3947)) and (v229 == (0 - 0))) then
						v32 = v136();
						if (((7377 - 3486) < (4027 + 892)) and v32) then
							return v32;
						end
						break;
					end
				end
			end
		end
	end
	local function v142()
		local v189 = 0 + 0;
		while true do
			if ((v189 == (3 - 2)) or ((959 + 1275) <= (818 + 684))) then
				v20.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
				break;
			end
			if ((v189 == (1426 - (85 + 1341))) or ((4286 - 1774) < (1219 - 787))) then
				v102.FlameShockDebuff:RegisterAuraTracking();
				v122();
				v189 = 373 - (45 + 327);
			end
		end
	end
	v20.SetAPL(496 - 233, v141, v142);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

