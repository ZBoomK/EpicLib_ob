local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 540 - (133 + 407);
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((6372 - 1996) <= (387 + 1094))) then
			v6 = v0[v4];
			if (not v6 or ((12003 - 8611) >= (2284 + 2457))) then
				return v1(v4, ...);
			end
			v5 = 797 - (588 + 208);
		end
		if (((8961 - 5636) >= (3954 - (884 + 916))) and (v5 == (1 - 0))) then
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
	local v102;
	local v103 = v18.Shaman.Enhancement;
	local v104 = v20.Shaman.Enhancement;
	local v105 = v23.Shaman.Enhancement;
	local v106 = {};
	local v107, v108;
	local v109, v110;
	local v111, v112, v113, v114;
	local v115 = (v103.LavaBurst:IsAvailable() and (2 + 0)) or (654 - (232 + 421));
	local v116 = "Lightning Bolt";
	local v117 = 13000 - (1569 + 320);
	local v118 = 2727 + 8384;
	local v119 = v21.Commons.Everyone;
	v21.Commons.Shaman = {};
	local v121 = v21.Commons.Shaman;
	v121.FeralSpiritCount = 0 + 0;
	v10:RegisterForEvent(function()
		v115 = (v103.LavaBurst:IsAvailable() and (6 - 4)) or (606 - (316 + 289));
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		local v144 = 0 - 0;
		while true do
			if ((v144 == (0 + 0)) or ((2748 - (666 + 787)) >= (3658 - (360 + 65)))) then
				v116 = "Lightning Bolt";
				v117 = 10384 + 727;
				v144 = 255 - (79 + 175);
			end
			if (((6901 - 2524) > (1282 + 360)) and (v144 == (2 - 1))) then
				v118 = 21397 - 10286;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForSelfCombatEvent(function(...)
		local v145, v146, v146, v146, v146, v146, v146, v146, v147 = select(903 - (503 + 396), ...);
		if (((4904 - (92 + 89)) > (2629 - 1273)) and (v145 == v14:GUID()) and (v147 == (98278 + 93356))) then
			v121.LastSKCast = v31();
		end
		if ((v14:HasTier(19 + 12, 7 - 5) and (v145 == v14:GUID()) and (v147 == (51417 + 324565))) or ((9430 - 5294) <= (2996 + 437))) then
			local v217 = 0 + 0;
			while true do
				if (((12928 - 8683) <= (578 + 4053)) and (v217 == (0 - 0))) then
					v121.FeralSpiritCount = v121.FeralSpiritCount + (1245 - (485 + 759));
					v32.After(34 - 19, function()
						v121.FeralSpiritCount = v121.FeralSpiritCount - (1190 - (442 + 747));
					end);
					break;
				end
			end
		end
		if (((5411 - (832 + 303)) >= (4860 - (88 + 858))) and (v145 == v14:GUID()) and (v147 == (15707 + 35826))) then
			local v218 = 0 + 0;
			while true do
				if (((9 + 189) <= (5154 - (766 + 23))) and (v218 == (0 - 0))) then
					v121.FeralSpiritCount = v121.FeralSpiritCount + (2 - 0);
					v32.After(39 - 24, function()
						v121.FeralSpiritCount = v121.FeralSpiritCount - (6 - 4);
					end);
					break;
				end
			end
		end
	end, "SPELL_CAST_SUCCESS");
	local function v123()
		if (((5855 - (1036 + 37)) > (3316 + 1360)) and v103.CleanseSpirit:IsAvailable()) then
			v119.DispellableDebuffs = v119.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v123();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v124()
		for v214 = 1 - 0, 5 + 1, 1481 - (641 + 839) do
			if (((5777 - (910 + 3)) > (5600 - 3403)) and v30(v14:TotemName(v214), "Totem")) then
				return v214;
			end
		end
	end
	local function v125()
		local v148 = 1684 - (1466 + 218);
		local v149;
		while true do
			if ((v148 == (0 + 0)) or ((4848 - (556 + 592)) == (892 + 1615))) then
				if (((5282 - (329 + 479)) >= (1128 - (174 + 680))) and (not v103.AlphaWolf:IsAvailable() or v14:BuffDown(v103.FeralSpiritBuff))) then
					return 0 - 0;
				end
				v149 = v29(v103.CrashLightning:TimeSinceLastCast(), v103.ChainLightning:TimeSinceLastCast());
				v148 = 1 - 0;
			end
			if ((v148 == (1 + 0)) or ((2633 - (396 + 343)) <= (125 + 1281))) then
				if (((3049 - (29 + 1448)) >= (2920 - (135 + 1254))) and ((v149 > (30 - 22)) or (v149 > v103.FeralSpirit:TimeSinceLastCast()))) then
					return 0 - 0;
				end
				return (6 + 2) - v149;
			end
		end
	end
	local function v126(v150)
		return (v150:DebuffRefreshable(v103.FlameShockDebuff));
	end
	local function v127(v151)
		return (v151:DebuffRefreshable(v103.LashingFlamesDebuff));
	end
	local v128 = 1527 - (389 + 1138);
	local function v129()
		if ((v103.CleanseSpirit:IsReady() and v38 and v119.UnitHasDispellableDebuffByPlayer(v16)) or ((5261 - (102 + 472)) < (4287 + 255))) then
			local v221 = 0 + 0;
			while true do
				if (((3069 + 222) > (3212 - (320 + 1225))) and (v221 == (0 - 0))) then
					if ((v128 == (0 + 0)) or ((2337 - (157 + 1307)) == (3893 - (821 + 1038)))) then
						v128 = v31();
					end
					if (v119.Wait(1247 - 747, v128) or ((308 + 2508) < (19 - 8))) then
						local v235 = 0 + 0;
						while true do
							if (((9168 - 5469) < (5732 - (834 + 192))) and (v235 == (0 + 0))) then
								if (((680 + 1966) >= (19 + 857)) and v24(v105.CleanseSpiritFocus)) then
									return "cleanse_spirit dispel";
								end
								v128 = 0 - 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v130()
		if (((918 - (300 + 4)) <= (851 + 2333)) and (not v16 or not v16:Exists() or not v16:IsInRange(104 - 64))) then
			return;
		end
		if (((3488 - (112 + 250)) == (1247 + 1879)) and v16) then
			if (((v16:HealthPercentage() <= v83) and v73 and v103.HealingSurge:IsReady() and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (12 - 7))) or ((1253 + 934) >= (2563 + 2391))) then
				if (v24(v105.HealingSurgeFocus) or ((2900 + 977) == (1773 + 1802))) then
					return "healing_surge heal focus";
				end
			end
		end
	end
	local function v131()
		if (((526 + 181) > (2046 - (1001 + 413))) and (v14:HealthPercentage() <= v87)) then
			if (v103.HealingSurge:IsReady() or ((1217 - 671) >= (3566 - (244 + 638)))) then
				if (((2158 - (627 + 66)) <= (12815 - 8514)) and v24(v103.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v132()
		local v152 = 602 - (512 + 90);
		while true do
			if (((3610 - (1665 + 241)) > (2142 - (373 + 344))) and ((1 + 1) == v152)) then
				if ((v104.Healthstone:IsReady() and v74 and (v14:HealthPercentage() <= v84)) or ((182 + 505) == (11167 - 6933))) then
					if (v24(v105.Healthstone) or ((5635 - 2305) < (2528 - (35 + 1064)))) then
						return "healthstone defensive 3";
					end
				end
				if (((835 + 312) >= (716 - 381)) and v75 and (v14:HealthPercentage() <= v85)) then
					if (((14 + 3421) > (3333 - (298 + 938))) and (v96 == "Refreshing Healing Potion")) then
						if (v104.RefreshingHealingPotion:IsReady() or ((5029 - (233 + 1026)) >= (5707 - (636 + 1030)))) then
							if (v24(v105.RefreshingHealingPotion) or ((1939 + 1852) <= (1574 + 37))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v96 == "Dreamwalker's Healing Potion") or ((1360 + 3218) <= (136 + 1872))) then
						if (((1346 - (55 + 166)) <= (403 + 1673)) and v104.DreamwalkersHealingPotion:IsReady()) then
							if (v24(v105.RefreshingHealingPotion) or ((75 + 668) >= (16799 - 12400))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((1452 - (36 + 261)) < (2925 - 1252)) and ((1369 - (34 + 1334)) == v152)) then
				if ((v103.HealingStreamTotem:IsReady() and v72 and v119.AreUnitsBelowHealthPercentage(v81, v82, v103.HealingSurge)) or ((894 + 1430) <= (450 + 128))) then
					if (((5050 - (1035 + 248)) == (3788 - (20 + 1))) and v24(v103.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if (((2131 + 1958) == (4408 - (134 + 185))) and v103.HealingSurge:IsReady() and v73 and (v14:HealthPercentage() <= v83) and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (1138 - (549 + 584)))) then
					if (((5143 - (314 + 371)) >= (5746 - 4072)) and v24(v103.HealingSurge)) then
						return "healing_surge defensive 4";
					end
				end
				v152 = 970 - (478 + 490);
			end
			if (((515 + 457) <= (2590 - (786 + 386))) and (v152 == (0 - 0))) then
				if ((v103.AstralShift:IsReady() and v70 and (v14:HealthPercentage() <= v78)) or ((6317 - (1055 + 324)) < (6102 - (1093 + 247)))) then
					if (v24(v103.AstralShift) or ((2226 + 278) > (449 + 3815))) then
						return "astral_shift defensive 1";
					end
				end
				if (((8547 - 6394) == (7306 - 5153)) and v103.AncestralGuidance:IsReady() and v71 and v119.AreUnitsBelowHealthPercentage(v79, v80, v103.HealingSurge)) then
					if (v24(v103.AncestralGuidance) or ((1442 - 935) >= (6510 - 3919))) then
						return "ancestral_guidance defensive 2";
					end
				end
				v152 = 1 + 0;
			end
		end
	end
	local function v133()
		local v153 = 0 - 0;
		while true do
			if (((15444 - 10963) == (3379 + 1102)) and ((2 - 1) == v153)) then
				v33 = v119.HandleBottomTrinket(v106, v36, 728 - (364 + 324), nil);
				if (v33 or ((6381 - 4053) < (1662 - 969))) then
					return v33;
				end
				break;
			end
			if (((1435 + 2893) == (18109 - 13781)) and (v153 == (0 - 0))) then
				v33 = v119.HandleTopTrinket(v106, v36, 121 - 81, nil);
				if (((2856 - (1249 + 19)) >= (1203 + 129)) and v33) then
					return v33;
				end
				v153 = 3 - 2;
			end
		end
	end
	local function v134()
		local v154 = 1086 - (686 + 400);
		while true do
			if ((v154 == (0 + 0)) or ((4403 - (73 + 156)) > (21 + 4227))) then
				if ((v103.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v103.WindfuryTotemBuff, true) or (v103.WindfuryTotem:TimeSinceLastCast() > (901 - (721 + 90))))) or ((52 + 4534) <= (266 - 184))) then
					if (((4333 - (224 + 246)) == (6257 - 2394)) and v24(v103.WindfuryTotem)) then
						return "windfury_totem precombat 4";
					end
				end
				if ((v103.FeralSpirit:IsCastable() and v56 and ((v61 and v36) or not v61)) or ((518 - 236) <= (8 + 34))) then
					if (((110 + 4499) >= (563 + 203)) and v24(v103.FeralSpirit)) then
						return "feral_spirit precombat 6";
					end
				end
				v154 = 1 - 0;
			end
			if ((v154 == (3 - 2)) or ((1665 - (203 + 310)) == (4481 - (1238 + 755)))) then
				if (((240 + 3182) > (4884 - (709 + 825))) and v103.DoomWinds:IsCastable() and v57 and ((v62 and v36) or not v62)) then
					if (((1616 - 739) > (546 - 170)) and v24(v103.DoomWinds, not v15:IsSpellInRange(v103.DoomWinds))) then
						return "doom_winds precombat 8";
					end
				end
				if ((v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63)) or ((3982 - (196 + 668)) <= (7308 - 5457))) then
					if (v24(v103.Sundering, not v15:IsInRange(10 - 5)) or ((998 - (171 + 662)) >= (3585 - (4 + 89)))) then
						return "sundering precombat 10";
					end
				end
				v154 = 6 - 4;
			end
			if (((1438 + 2511) < (21328 - 16472)) and (v154 == (1 + 1))) then
				if ((v103.Stormstrike:IsReady() and v50) or ((5762 - (35 + 1451)) < (4469 - (28 + 1425)))) then
					if (((6683 - (941 + 1052)) > (3956 + 169)) and v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike))) then
						return "stormstrike precombat 12";
					end
				end
				break;
			end
		end
	end
	local function v135()
		local v155 = 1514 - (822 + 692);
		while true do
			if ((v155 == (0 - 0)) or ((24 + 26) >= (1193 - (45 + 252)))) then
				if ((v103.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v118) and v15:DebuffDown(v103.FlameShockDebuff) and v103.LashingFlames:IsAvailable()) or ((1696 + 18) >= (1019 + 1939))) then
					if (v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave)) or ((3628 - 2137) < (1077 - (114 + 319)))) then
						return "primordial_wave single 1";
					end
				end
				if (((1010 - 306) < (1264 - 277)) and v103.FlameShock:IsReady() and v43 and v15:DebuffDown(v103.FlameShockDebuff) and v103.LashingFlames:IsAvailable()) then
					if (((2371 + 1347) > (2839 - 933)) and v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock))) then
						return "flame_shock single 2";
					end
				end
				if ((v103.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (10 - 5)) and v103.ElementalSpirits:IsAvailable() and (v121.FeralSpiritCount >= (1967 - (556 + 1407)))) or ((2164 - (741 + 465)) > (4100 - (170 + 295)))) then
					if (((1845 + 1656) <= (4127 + 365)) and v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast))) then
						return "elemental_blast single 3";
					end
				end
				if ((v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v118) and (v14:HasTier(73 - 43, 2 + 0))) or ((2208 + 1234) < (1443 + 1105))) then
					if (((4105 - (957 + 273)) >= (392 + 1072)) and v24(v103.Sundering, not v15:IsInRange(4 + 4))) then
						return "sundering single 4";
					end
				end
				if ((v103.LightningBolt:IsReady() and v48 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (19 - 14)) and v14:BuffDown(v103.CracklingThunderBuff) and v14:BuffUp(v103.AscendanceBuff) and (v116 == "Chain Lightning") and (v14:BuffRemains(v103.AscendanceBuff) > (v103.ChainLightning:CooldownRemains() + v14:GCD()))) or ((12641 - 7844) >= (14945 - 10052))) then
					if (v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt)) or ((2728 - 2177) > (3848 - (389 + 1391)))) then
						return "lightning_bolt single 5";
					end
				end
				if (((1327 + 787) > (99 + 845)) and v103.Stormstrike:IsReady() and v50 and (v14:BuffUp(v103.DoomWindsBuff) or v103.DeeplyRootedElements:IsAvailable() or (v103.Stormblast:IsAvailable() and v14:BuffUp(v103.StormbringerBuff)))) then
					if (v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike)) or ((5149 - 2887) >= (4047 - (783 + 168)))) then
						return "stormstrike single 6";
					end
				end
				v155 = 3 - 2;
			end
			if ((v155 == (3 + 0)) or ((2566 - (309 + 2)) >= (10861 - 7324))) then
				if ((v103.LavaLash:IsReady() and v47 and (v103.LashingFlames:IsAvailable())) or ((5049 - (1090 + 122)) < (424 + 882))) then
					if (((9907 - 6957) == (2019 + 931)) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
						return "lava_lash single 19";
					end
				end
				if ((v103.IceStrike:IsReady() and v45 and (v14:BuffDown(v103.IceStrikeBuff))) or ((5841 - (628 + 490)) < (592 + 2706))) then
					if (((2812 - 1676) >= (703 - 549)) and v24(v103.IceStrike, not v15:IsInMeleeRange(779 - (431 + 343)))) then
						return "ice_strike single 20";
					end
				end
				if ((v103.FrostShock:IsReady() and v44 and (v14:BuffUp(v103.HailstormBuff))) or ((547 - 276) > (13735 - 8987))) then
					if (((3745 + 995) >= (404 + 2748)) and v24(v103.FrostShock, not v15:IsSpellInRange(v103.FrostShock))) then
						return "frost_shock single 21";
					end
				end
				if ((v103.LavaLash:IsReady() and v47) or ((4273 - (556 + 1139)) >= (3405 - (6 + 9)))) then
					if (((8 + 33) <= (851 + 810)) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
						return "lava_lash single 22";
					end
				end
				if (((770 - (28 + 141)) < (1379 + 2181)) and v103.IceStrike:IsReady() and v45) then
					if (((290 - 55) < (487 + 200)) and v24(v103.IceStrike, not v15:IsInMeleeRange(1322 - (486 + 831)))) then
						return "ice_strike single 23";
					end
				end
				if (((11837 - 7288) > (4059 - 2906)) and v103.Windstrike:IsCastable() and v53) then
					if (v24(v103.Windstrike, not v15:IsSpellInRange(v103.Windstrike)) or ((884 + 3790) < (14772 - 10100))) then
						return "windstrike single 24";
					end
				end
				v155 = 1267 - (668 + 595);
			end
			if (((3301 + 367) < (920 + 3641)) and (v155 == (10 - 6))) then
				if ((v103.Stormstrike:IsReady() and v50) or ((745 - (23 + 267)) == (5549 - (1129 + 815)))) then
					if (v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike)) or ((3050 - (371 + 16)) == (5062 - (1326 + 424)))) then
						return "stormstrike single 25";
					end
				end
				if (((8100 - 3823) <= (16352 - 11877)) and v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v118)) then
					if (v24(v103.Sundering, not v15:IsInRange(126 - (88 + 30))) or ((1641 - (720 + 51)) == (2644 - 1455))) then
						return "sundering single 26";
					end
				end
				if (((3329 - (421 + 1355)) <= (5168 - 2035)) and v103.BagofTricks:IsReady() and v59 and ((v66 and v36) or not v66)) then
					if (v24(v103.BagofTricks) or ((1099 + 1138) >= (4594 - (286 + 797)))) then
						return "bag_of_tricks single 27";
					end
				end
				if ((v103.FireNova:IsReady() and v42 and v103.SwirlingMaelstrom:IsAvailable() and v15:DebuffUp(v103.FlameShockDebuff) and (v14:BuffStack(v103.MaelstromWeaponBuff) < ((18 - 13) + ((7 - 2) * v25(v103.OverflowingMaelstrom:IsAvailable()))))) or ((1763 - (397 + 42)) > (944 + 2076))) then
					if (v24(v103.FireNova) or ((3792 - (24 + 776)) == (2897 - 1016))) then
						return "fire_nova single 28";
					end
				end
				if (((3891 - (222 + 563)) > (3362 - 1836)) and v103.LightningBolt:IsReady() and v48 and v103.Hailstorm:IsAvailable() and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (4 + 1)) and v14:BuffDown(v103.PrimordialWaveBuff)) then
					if (((3213 - (23 + 167)) < (5668 - (690 + 1108))) and v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt))) then
						return "lightning_bolt single 29";
					end
				end
				if (((52 + 91) > (62 + 12)) and v103.FrostShock:IsReady() and v44) then
					if (((866 - (40 + 808)) < (348 + 1764)) and v24(v103.FrostShock, not v15:IsSpellInRange(v103.FrostShock))) then
						return "frost_shock single 30";
					end
				end
				v155 = 19 - 14;
			end
			if (((1049 + 48) <= (862 + 766)) and (v155 == (1 + 0))) then
				if (((5201 - (47 + 524)) == (3005 + 1625)) and v103.LavaLash:IsReady() and v47 and (v14:BuffUp(v103.HotHandBuff))) then
					if (((9676 - 6136) > (4011 - 1328)) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
						return "lava_lash single 7";
					end
				end
				if (((10932 - 6138) >= (5001 - (1165 + 561))) and v103.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v103.WindfuryTotemBuff, true))) then
					if (((45 + 1439) == (4595 - 3111)) and v24(v103.WindfuryTotem)) then
						return "windfury_totem single 8";
					end
				end
				if (((547 + 885) < (4034 - (341 + 138))) and v103.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (2 + 3)) and (v103.ElementalBlast:Charges() == v115)) then
					if (v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast)) or ((2197 - 1132) > (3904 - (89 + 237)))) then
						return "elemental_blast single 9";
					end
				end
				if ((v103.LightningBolt:IsReady() and v48 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (25 - 17)) and v14:BuffUp(v103.PrimordialWaveBuff) and (v14:BuffDown(v103.SplinteredElementsBuff) or (v118 <= (24 - 12)))) or ((5676 - (581 + 300)) < (2627 - (855 + 365)))) then
					if (((4400 - 2547) < (1572 + 3241)) and v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt))) then
						return "lightning_bolt single 10";
					end
				end
				if ((v103.ChainLightning:IsReady() and v39 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (1243 - (1030 + 205))) and v14:BuffUp(v103.CracklingThunderBuff) and v103.ElementalSpirits:IsAvailable()) or ((2649 + 172) < (2262 + 169))) then
					if (v24(v103.ChainLightning, not v15:IsSpellInRange(v103.ChainLightning)) or ((3160 - (156 + 130)) < (4955 - 2774))) then
						return "chain_lightning single 11";
					end
				end
				if ((v103.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (13 - 5)) and ((v121.FeralSpiritCount >= (3 - 1)) or not v103.ElementalSpirits:IsAvailable())) or ((709 + 1980) <= (201 + 142))) then
					if (v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast)) or ((1938 - (10 + 59)) == (569 + 1440))) then
						return "elemental_blast single 12";
					end
				end
				v155 = 9 - 7;
			end
			if ((v155 == (1168 - (671 + 492))) or ((2823 + 723) < (3537 - (369 + 846)))) then
				if ((v103.CrashLightning:IsReady() and v40) or ((552 + 1530) == (4074 + 699))) then
					if (((5189 - (1036 + 909)) > (839 + 216)) and v24(v103.CrashLightning, not v15:IsInMeleeRange(13 - 5))) then
						return "crash_lightning single 31";
					end
				end
				if ((v103.FireNova:IsReady() and v42 and (v15:DebuffUp(v103.FlameShockDebuff))) or ((3516 - (11 + 192)) <= (899 + 879))) then
					if (v24(v103.FireNova) or ((1596 - (135 + 40)) >= (5097 - 2993))) then
						return "fire_nova single 32";
					end
				end
				if (((1093 + 719) <= (7157 - 3908)) and v103.FlameShock:IsReady() and v43) then
					if (((2432 - 809) <= (2133 - (50 + 126))) and v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock))) then
						return "flame_shock single 34";
					end
				end
				if (((12285 - 7873) == (977 + 3435)) and v103.ChainLightning:IsReady() and v39 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (1418 - (1233 + 180))) and v14:BuffUp(v103.CracklingThunderBuff) and v103.ElementalSpirits:IsAvailable()) then
					if (((2719 - (522 + 447)) >= (2263 - (107 + 1314))) and v24(v103.ChainLightning, not v15:IsSpellInRange(v103.ChainLightning))) then
						return "chain_lightning single 35";
					end
				end
				if (((2029 + 2343) > (5637 - 3787)) and v103.LightningBolt:IsReady() and v48 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (3 + 2)) and v14:BuffDown(v103.PrimordialWaveBuff)) then
					if (((460 - 228) < (3248 - 2427)) and v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt))) then
						return "lightning_bolt single 36";
					end
				end
				if (((2428 - (716 + 1194)) < (16 + 886)) and v103.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v103.WindfuryTotemBuff, true) or (v103.WindfuryTotem:TimeSinceLastCast() > (10 + 80)))) then
					if (((3497 - (74 + 429)) > (1654 - 796)) and v24(v103.WindfuryTotem)) then
						return "windfury_totem single 37";
					end
				end
				break;
			end
			if ((v155 == (1 + 1)) or ((8595 - 4840) <= (648 + 267))) then
				if (((12164 - 8218) > (9254 - 5511)) and v103.LavaBurst:IsReady() and v46 and not v103.ThorimsInvocation:IsAvailable() and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (438 - (279 + 154)))) then
					if (v24(v103.LavaBurst, not v15:IsSpellInRange(v103.LavaBurst)) or ((2113 - (454 + 324)) >= (2602 + 704))) then
						return "lava_burst single 13";
					end
				end
				if (((4861 - (12 + 5)) > (1215 + 1038)) and v103.LightningBolt:IsReady() and v48 and ((v14:BuffStack(v103.MaelstromWeaponBuff) >= (20 - 12)) or (v103.StaticAccumulation:IsAvailable() and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (2 + 3)))) and v14:BuffDown(v103.PrimordialWaveBuff)) then
					if (((1545 - (277 + 816)) == (1931 - 1479)) and v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt))) then
						return "lightning_bolt single 14";
					end
				end
				if ((v103.CrashLightning:IsReady() and v40 and v103.AlphaWolf:IsAvailable() and v14:BuffUp(v103.FeralSpiritBuff) and (v125() == (1183 - (1058 + 125)))) or ((855 + 3702) < (3062 - (815 + 160)))) then
					if (((16621 - 12747) == (9196 - 5322)) and v24(v103.CrashLightning, not v15:IsInMeleeRange(2 + 6))) then
						return "crash_lightning single 15";
					end
				end
				if ((v103.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v118)) or ((5665 - 3727) > (6833 - (41 + 1857)))) then
					if (v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave)) or ((6148 - (1222 + 671)) < (8846 - 5423))) then
						return "primordial_wave single 16";
					end
				end
				if (((2089 - 635) <= (3673 - (229 + 953))) and v103.FlameShock:IsReady() and v43 and (v15:DebuffDown(v103.FlameShockDebuff))) then
					if (v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock)) or ((5931 - (1111 + 663)) <= (4382 - (874 + 705)))) then
						return "flame_shock single 17";
					end
				end
				if (((680 + 4173) >= (2035 + 947)) and v103.IceStrike:IsReady() and v45 and v103.ElementalAssault:IsAvailable() and v103.SwirlingMaelstrom:IsAvailable()) then
					if (((8592 - 4458) > (95 + 3262)) and v24(v103.IceStrike, not v15:IsInMeleeRange(684 - (642 + 37)))) then
						return "ice_strike single 18";
					end
				end
				v155 = 1 + 2;
			end
		end
	end
	local function v136()
		if ((v103.CrashLightning:IsReady() and v40 and v103.CrashingStorms:IsAvailable() and ((v103.UnrulyWinds:IsAvailable() and (v113 >= (2 + 8))) or (v113 >= (37 - 22)))) or ((3871 - (233 + 221)) < (5859 - 3325))) then
			if (v24(v103.CrashLightning, not v15:IsInMeleeRange(8 + 0)) or ((4263 - (718 + 823)) <= (104 + 60))) then
				return "crash_lightning aoe 1";
			end
		end
		if ((v103.LightningBolt:IsReady() and v48 and ((v103.FlameShockDebuff:AuraActiveCount() >= v113) or (v14:BuffRemains(v103.PrimordialWaveBuff) < (v14:GCD() * (808 - (266 + 539)))) or (v103.FlameShockDebuff:AuraActiveCount() >= (16 - 10))) and v14:BuffUp(v103.PrimordialWaveBuff) and (v14:BuffStack(v103.MaelstromWeaponBuff) == ((1230 - (636 + 589)) + ((11 - 6) * v25(v103.OverflowingMaelstrom:IsAvailable())))) and (v14:BuffDown(v103.SplinteredElementsBuff) or (v118 <= (24 - 12)) or (v100 <= v14:GCD()))) or ((1909 + 499) < (767 + 1342))) then
			if (v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt)) or ((1048 - (657 + 358)) == (3852 - 2397))) then
				return "lightning_bolt aoe 2";
			end
		end
		if ((v103.LavaLash:IsReady() and v47 and v103.MoltenAssault:IsAvailable() and (v103.PrimordialWave:IsAvailable() or v103.FireNova:IsAvailable()) and v15:DebuffUp(v103.FlameShockDebuff) and (v103.FlameShockDebuff:AuraActiveCount() < v113) and (v103.FlameShockDebuff:AuraActiveCount() < (13 - 7))) or ((1630 - (1151 + 36)) >= (3878 + 137))) then
			if (((890 + 2492) > (495 - 329)) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
				return "lava_lash aoe 3";
			end
		end
		if ((v103.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v118) and (v14:BuffDown(v103.PrimordialWaveBuff))) or ((2112 - (1552 + 280)) == (3893 - (64 + 770)))) then
			local v222 = 0 + 0;
			while true do
				if (((4269 - 2388) > (230 + 1063)) and (v222 == (1243 - (157 + 1086)))) then
					if (((4717 - 2360) == (10322 - 7965)) and v119.CastCycle(v103.PrimordialWave, v112, v126, not v15:IsSpellInRange(v103.PrimordialWave))) then
						return "primordial_wave aoe 4";
					end
					if (((187 - 64) == (167 - 44)) and v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave))) then
						return "primordial_wave aoe no_cycle 4";
					end
					break;
				end
			end
		end
		if ((v103.FlameShock:IsReady() and v43 and (v103.PrimordialWave:IsAvailable() or v103.FireNova:IsAvailable()) and v15:DebuffDown(v103.FlameShockDebuff)) or ((1875 - (599 + 220)) >= (6754 - 3362))) then
			if (v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock)) or ((3012 - (1813 + 118)) < (786 + 289))) then
				return "flame_shock aoe 5";
			end
		end
		if ((v103.ElementalBlast:IsReady() and v41 and (not v103.ElementalSpirits:IsAvailable() or (v103.ElementalSpirits:IsAvailable() and ((v103.ElementalBlast:Charges() == v115) or (v121.FeralSpiritCount >= (1219 - (841 + 376)))))) and (v14:BuffStack(v103.MaelstromWeaponBuff) == ((6 - 1) + ((2 + 3) * v25(v103.OverflowingMaelstrom:IsAvailable())))) and (not v103.CrashingStorms:IsAvailable() or (v113 <= (8 - 5)))) or ((1908 - (464 + 395)) >= (11374 - 6942))) then
			if (v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast)) or ((2290 + 2478) <= (1683 - (467 + 370)))) then
				return "elemental_blast aoe 6";
			end
		end
		if ((v103.ChainLightning:IsReady() and v39 and (v14:BuffStack(v103.MaelstromWeaponBuff) == ((9 - 4) + ((4 + 1) * v25(v103.OverflowingMaelstrom:IsAvailable()))))) or ((11511 - 8153) <= (222 + 1198))) then
			if (v24(v103.ChainLightning, not v15:IsSpellInRange(v103.ChainLightning)) or ((8698 - 4959) <= (3525 - (150 + 370)))) then
				return "chain_lightning aoe 7";
			end
		end
		if ((v103.CrashLightning:IsReady() and v40 and (v14:BuffUp(v103.DoomWindsBuff) or v14:BuffDown(v103.CrashLightningBuff) or (v103.AlphaWolf:IsAvailable() and v14:BuffUp(v103.FeralSpiritBuff) and (v125() == (1282 - (74 + 1208)))))) or ((4080 - 2421) >= (10120 - 7986))) then
			if (v24(v103.CrashLightning, not v15:IsInMeleeRange(6 + 2)) or ((3650 - (14 + 376)) < (4084 - 1729))) then
				return "crash_lightning aoe 8";
			end
		end
		if ((v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v118) and (v14:BuffUp(v103.DoomWindsBuff) or v14:HasTier(20 + 10, 2 + 0))) or ((639 + 30) == (12373 - 8150))) then
			if (v24(v103.Sundering, not v15:IsInRange(7 + 1)) or ((1770 - (23 + 55)) < (1393 - 805))) then
				return "sundering aoe 9";
			end
		end
		if ((v103.FireNova:IsReady() and v42 and ((v103.FlameShockDebuff:AuraActiveCount() >= (5 + 1)) or ((v103.FlameShockDebuff:AuraActiveCount() >= (4 + 0)) and (v103.FlameShockDebuff:AuraActiveCount() >= v113)))) or ((7437 - 2640) < (1149 + 2502))) then
			if (v24(v103.FireNova) or ((5078 - (652 + 249)) > (12979 - 8129))) then
				return "fire_nova aoe 10";
			end
		end
		if ((v103.LavaLash:IsReady() and v47 and (v103.LashingFlames:IsAvailable())) or ((2268 - (708 + 1160)) > (3015 - 1904))) then
			if (((5562 - 2511) > (1032 - (10 + 17))) and v119.CastCycle(v103.LavaLash, v112, v127, not v15:IsSpellInRange(v103.LavaLash))) then
				return "lava_lash aoe 11";
			end
			if (((830 + 2863) <= (6114 - (1400 + 332))) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
				return "lava_lash aoe no_cycle 11";
			end
		end
		if ((v103.LavaLash:IsReady() and v47 and ((v103.MoltenAssault:IsAvailable() and v15:DebuffUp(v103.FlameShockDebuff) and (v103.FlameShockDebuff:AuraActiveCount() < v113) and (v103.FlameShockDebuff:AuraActiveCount() < (11 - 5))) or (v103.AshenCatalyst:IsAvailable() and (v14:BuffStack(v103.AshenCatalystBuff) == (1913 - (242 + 1666)))))) or ((1405 + 1877) > (1503 + 2597))) then
			if (v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash)) or ((3052 + 528) < (3784 - (850 + 90)))) then
				return "lava_lash aoe 12";
			end
		end
		if (((155 - 66) < (5880 - (360 + 1030))) and v103.IceStrike:IsReady() and v45 and (v103.Hailstorm:IsAvailable())) then
			if (v24(v103.IceStrike, not v15:IsInMeleeRange(5 + 0)) or ((14064 - 9081) < (2487 - 679))) then
				return "ice_strike aoe 13";
			end
		end
		if (((5490 - (909 + 752)) > (4992 - (109 + 1114))) and v103.FrostShock:IsReady() and v44 and v103.Hailstorm:IsAvailable() and v14:BuffUp(v103.HailstormBuff)) then
			if (((2718 - 1233) <= (1131 + 1773)) and v24(v103.FrostShock, not v15:IsSpellInRange(v103.FrostShock))) then
				return "frost_shock aoe 14";
			end
		end
		if (((4511 - (6 + 236)) == (2690 + 1579)) and v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v118)) then
			if (((312 + 75) <= (6560 - 3778)) and v24(v103.Sundering, not v15:IsInRange(13 - 5))) then
				return "sundering aoe 15";
			end
		end
		if ((v103.FlameShock:IsReady() and v43 and v103.MoltenAssault:IsAvailable() and v15:DebuffDown(v103.FlameShockDebuff)) or ((3032 - (1076 + 57)) <= (151 + 766))) then
			if (v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock)) or ((5001 - (579 + 110)) <= (70 + 806))) then
				return "flame_shock aoe 16";
			end
		end
		if (((1974 + 258) <= (1378 + 1218)) and v103.FlameShock:IsReady() and v43 and v15:DebuffRefreshable(v103.FlameShockDebuff) and (v103.FireNova:IsAvailable() or v103.PrimordialWave:IsAvailable()) and (v103.FlameShockDebuff:AuraActiveCount() < v113) and (v103.FlameShockDebuff:AuraActiveCount() < (413 - (174 + 233)))) then
			if (((5851 - 3756) < (6469 - 2783)) and v119.CastCycle(v103.FlameShock, v112, v126, not v15:IsSpellInRange(v103.FlameShock))) then
				return "flame_shock aoe 17";
			end
			if (v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock)) or ((710 + 885) >= (5648 - (663 + 511)))) then
				return "flame_shock aoe no_cycle 17";
			end
		end
		if ((v103.FireNova:IsReady() and v42 and (v103.FlameShockDebuff:AuraActiveCount() >= (3 + 0))) or ((1003 + 3616) < (8884 - 6002))) then
			if (v24(v103.FireNova) or ((179 + 115) >= (11373 - 6542))) then
				return "fire_nova aoe 18";
			end
		end
		if (((4911 - 2882) <= (1472 + 1612)) and v103.Stormstrike:IsReady() and v50 and v14:BuffUp(v103.CrashLightningBuff) and (v103.DeeplyRootedElements:IsAvailable() or (v14:BuffStack(v103.ConvergingStormsBuff) == (11 - 5)))) then
			if (v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike)) or ((1452 + 585) == (222 + 2198))) then
				return "stormstrike aoe 19";
			end
		end
		if (((5180 - (478 + 244)) > (4421 - (440 + 77))) and v103.CrashLightning:IsReady() and v40 and v103.CrashingStorms:IsAvailable() and v14:BuffUp(v103.CLCrashLightningBuff) and (v113 >= (2 + 2))) then
			if (((1595 - 1159) >= (1679 - (655 + 901))) and v24(v103.CrashLightning, not v15:IsInMeleeRange(2 + 6))) then
				return "crash_lightning aoe 20";
			end
		end
		if (((383 + 117) < (1227 + 589)) and v103.Windstrike:IsCastable() and v53) then
			if (((14398 - 10824) == (5019 - (695 + 750))) and v24(v103.Windstrike, not v15:IsSpellInRange(v103.Windstrike))) then
				return "windstrike aoe 21";
			end
		end
		if (((754 - 533) < (601 - 211)) and v103.Stormstrike:IsReady() and v50) then
			if (v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike)) or ((8899 - 6686) <= (1772 - (285 + 66)))) then
				return "stormstrike aoe 22";
			end
		end
		if (((7128 - 4070) < (6170 - (682 + 628))) and v103.IceStrike:IsReady() and v45) then
			if (v24(v103.IceStrike, not v15:IsInMeleeRange(1 + 4)) or ((1595 - (176 + 123)) >= (1860 + 2586))) then
				return "ice_strike aoe 23";
			end
		end
		if ((v103.LavaLash:IsReady() and v47) or ((1011 + 382) > (4758 - (239 + 30)))) then
			if (v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash)) or ((1203 + 3221) < (26 + 1))) then
				return "lava_lash aoe 24";
			end
		end
		if ((v103.CrashLightning:IsReady() and v40) or ((3534 - 1537) > (11902 - 8087))) then
			if (((3780 - (306 + 9)) > (6675 - 4762)) and v24(v103.CrashLightning, not v15:IsInMeleeRange(2 + 6))) then
				return "crash_lightning aoe 25";
			end
		end
		if (((450 + 283) < (876 + 943)) and v103.FireNova:IsReady() and v42 and (v103.FlameShockDebuff:AuraActiveCount() >= (5 - 3))) then
			if (v24(v103.FireNova) or ((5770 - (1140 + 235)) == (3026 + 1729))) then
				return "fire_nova aoe 26";
			end
		end
		if ((v103.ElementalBlast:IsReady() and v41 and (not v103.ElementalSpirits:IsAvailable() or (v103.ElementalSpirits:IsAvailable() and ((v103.ElementalBlast:Charges() == v115) or (v121.FeralSpiritCount >= (2 + 0))))) and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (2 + 3)) and (not v103.CrashingStorms:IsAvailable() or (v113 <= (55 - (33 + 19))))) or ((1370 + 2423) < (7100 - 4731))) then
			if (v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast)) or ((1800 + 2284) == (519 - 254))) then
				return "elemental_blast aoe 27";
			end
		end
		if (((4087 + 271) == (5047 - (586 + 103))) and v103.ChainLightning:IsReady() and v39 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (1 + 4))) then
			if (v24(v103.ChainLightning, not v15:IsSpellInRange(v103.ChainLightning)) or ((9660 - 6522) < (2481 - (1309 + 179)))) then
				return "chain_lightning aoe 28";
			end
		end
		if (((6011 - 2681) > (1012 + 1311)) and v103.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v103.WindfuryTotemBuff, true) or (v103.WindfuryTotem:TimeSinceLastCast() > (241 - 151)))) then
			if (v24(v103.WindfuryTotem) or ((2739 + 887) == (8474 - 4485))) then
				return "windfury_totem aoe 29";
			end
		end
		if ((v103.FlameShock:IsReady() and v43 and (v15:DebuffDown(v103.FlameShockDebuff))) or ((1825 - 909) == (3280 - (295 + 314)))) then
			if (((667 - 395) == (2234 - (1300 + 662))) and v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock))) then
				return "flame_shock aoe 30";
			end
		end
		if (((13342 - 9093) <= (6594 - (1178 + 577))) and v103.FrostShock:IsReady() and v44 and not v103.Hailstorm:IsAvailable()) then
			if (((1443 + 1334) < (9459 - 6259)) and v24(v103.FrostShock, not v15:IsSpellInRange(v103.FrostShock))) then
				return "frost_shock aoe 31";
			end
		end
	end
	local function v137()
		if (((1500 - (851 + 554)) < (1731 + 226)) and v76 and v103.EarthShield:IsCastable() and v14:BuffDown(v103.EarthShieldBuff) and ((v77 == "Earth Shield") or (v103.ElementalOrbit:IsAvailable() and v14:BuffUp(v103.LightningShield)))) then
			if (((2290 - 1464) < (3728 - 2011)) and v24(v103.EarthShield)) then
				return "earth_shield main 2";
			end
		elseif (((1728 - (115 + 187)) >= (847 + 258)) and v76 and v103.LightningShield:IsCastable() and v14:BuffDown(v103.LightningShieldBuff) and ((v77 == "Lightning Shield") or (v103.ElementalOrbit:IsAvailable() and v14:BuffUp(v103.EarthShield)))) then
			if (((2608 + 146) <= (13315 - 9936)) and v24(v103.LightningShield)) then
				return "lightning_shield main 2";
			end
		end
		if (((not v107 or (v109 < (601161 - (160 + 1001)))) and v54 and v103.WindfuryWeapon:IsCastable()) or ((3436 + 491) == (975 + 438))) then
			if (v24(v103.WindfuryWeapon) or ((2361 - 1207) <= (1146 - (237 + 121)))) then
				return "windfury_weapon enchant";
			end
		end
		if (((not v108 or (v110 < (600897 - (525 + 372)))) and v54 and v103.FlametongueWeapon:IsCastable()) or ((3114 - 1471) > (11101 - 7722))) then
			if (v24(v103.FlametongueWeapon) or ((2945 - (96 + 46)) > (5326 - (643 + 134)))) then
				return "flametongue_weapon enchant";
			end
		end
		if (v86 or ((80 + 140) >= (7245 - 4223))) then
			v33 = v131();
			if (((10477 - 7655) == (2707 + 115)) and v33) then
				return v33;
			end
		end
		if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) or ((2082 - 1021) == (3795 - 1938))) then
			if (((3479 - (316 + 403)) > (907 + 457)) and v24(v103.AncestralSpirit, nil, true)) then
				return "resurrection";
			end
		end
		if ((v119.TargetIsValid() and v34) or ((13477 - 8575) <= (1300 + 2295))) then
			if (not v14:AffectingCombat() or ((9700 - 5848) == (208 + 85))) then
				v33 = v134();
				if (v33 or ((503 + 1056) == (15897 - 11309))) then
					return v33;
				end
			end
		end
	end
	local function v138()
		local v156 = 0 - 0;
		while true do
			if ((v156 == (3 - 1)) or ((257 + 4227) == (1550 - 762))) then
				if (((224 + 4344) >= (11494 - 7587)) and v16) then
					if (((1263 - (12 + 5)) < (13477 - 10007)) and v93) then
						v33 = v129();
						if (((8679 - 4611) >= (2065 - 1093)) and v33) then
							return v33;
						end
					end
				end
				if (((1222 - 729) < (791 + 3102)) and v103.GreaterPurge:IsAvailable() and v101 and v103.GreaterPurge:IsReady() and v38 and v92 and not v14:IsCasting() and not v14:IsChanneling() and v119.UnitHasMagicBuff(v15)) then
					if (v24(v103.GreaterPurge, not v15:IsSpellInRange(v103.GreaterPurge)) or ((3446 - (1656 + 317)) >= (2970 + 362))) then
						return "greater_purge damage";
					end
				end
				v156 = 3 + 0;
			end
			if ((v156 == (2 - 1)) or ((19937 - 15886) <= (1511 - (5 + 349)))) then
				if (((2868 - 2264) < (4152 - (266 + 1005))) and v94) then
					local v230 = 0 + 0;
					while true do
						if (((3 - 2) == v230) or ((1184 - 284) == (5073 - (561 + 1135)))) then
							if (((5810 - 1351) > (1942 - 1351)) and v90) then
								local v239 = 1066 - (507 + 559);
								while true do
									if (((8526 - 5128) >= (7407 - 5012)) and ((388 - (212 + 176)) == v239)) then
										v33 = v119.HandleAfflicted(v103.PoisonCleansingTotem, v103.PoisonCleansingTotem, 935 - (250 + 655));
										if (v33 or ((5952 - 3769) >= (4934 - 2110))) then
											return v33;
										end
										break;
									end
								end
							end
							if (((3028 - 1092) == (3892 - (1869 + 87))) and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (17 - 12)) and v91) then
								v33 = v119.HandleAfflicted(v103.HealingSurge, v105.HealingSurgeMouseover, 1941 - (484 + 1417), true);
								if (v33 or ((10356 - 5524) < (7227 - 2914))) then
									return v33;
								end
							end
							break;
						end
						if (((4861 - (48 + 725)) > (6327 - 2453)) and (v230 == (0 - 0))) then
							if (((2518 + 1814) == (11576 - 7244)) and v88) then
								local v240 = 0 + 0;
								while true do
									if (((1166 + 2833) >= (3753 - (152 + 701))) and (v240 == (1311 - (430 + 881)))) then
										v33 = v119.HandleAfflicted(v103.CleanseSpirit, v105.CleanseSpiritMouseover, 16 + 24);
										if (v33 or ((3420 - (557 + 338)) > (1202 + 2862))) then
											return v33;
										end
										break;
									end
								end
							end
							if (((12317 - 7946) == (15306 - 10935)) and v89) then
								local v241 = 0 - 0;
								while true do
									if (((0 - 0) == v241) or ((1067 - (499 + 302)) > (5852 - (39 + 827)))) then
										v33 = v119.HandleAfflicted(v103.TremorTotem, v103.TremorTotem, 82 - 52);
										if (((4446 - 2455) >= (3673 - 2748)) and v33) then
											return v33;
										end
										break;
									end
								end
							end
							v230 = 1 - 0;
						end
					end
				end
				if (((39 + 416) < (6008 - 3955)) and v95) then
					v33 = v119.HandleIncorporeal(v103.Hex, v105.HexMouseOver, 5 + 25, true);
					if (v33 or ((1306 - 480) == (4955 - (103 + 1)))) then
						return v33;
					end
				end
				v156 = 556 - (475 + 79);
			end
			if (((395 - 212) == (585 - 402)) and (v156 == (1 + 3))) then
				if (((1021 + 138) <= (3291 - (1395 + 108))) and v33) then
					return v33;
				end
				if (v119.TargetIsValid() or ((10204 - 6697) > (5522 - (7 + 1197)))) then
					local v231 = 0 + 0;
					local v232;
					while true do
						if ((v231 == (1 + 1)) or ((3394 - (27 + 292)) <= (8688 - 5723))) then
							if (((1740 - 375) <= (8433 - 6422)) and v103.Ascendance:IsCastable() and v55 and ((v60 and v36) or not v60) and (v100 < v118) and v15:DebuffUp(v103.FlameShockDebuff) and (((v116 == "Lightning Bolt") and (v113 == (1 - 0))) or ((v116 == "Chain Lightning") and (v113 > (1 - 0))))) then
								if (v24(v103.Ascendance) or ((2915 - (43 + 96)) > (14582 - 11007))) then
									return "ascendance main 4";
								end
							end
							if ((v103.DoomWinds:IsCastable() and v57 and ((v62 and v36) or not v62) and (v100 < v118)) or ((5773 - 3219) == (3987 + 817))) then
								if (((728 + 1849) == (5092 - 2515)) and v24(v103.DoomWinds, not v15:IsInMeleeRange(2 + 3))) then
									return "doom_winds main 5";
								end
							end
							if ((v113 == (1 - 0)) or ((2 + 4) >= (139 + 1750))) then
								local v242 = 1751 - (1414 + 337);
								while true do
									if (((2446 - (1642 + 298)) <= (4931 - 3039)) and (v242 == (0 - 0))) then
										v33 = v135();
										if (v33 or ((5958 - 3950) > (730 + 1488))) then
											return v33;
										end
										break;
									end
								end
							end
							if (((295 + 84) <= (5119 - (357 + 615))) and v35 and (v113 > (1 + 0))) then
								local v243 = 0 - 0;
								while true do
									if (((0 + 0) == v243) or ((9673 - 5159) <= (807 + 202))) then
										v33 = v136();
										if (v33 or ((238 + 3258) == (750 + 442))) then
											return v33;
										end
										break;
									end
								end
							end
							break;
						end
						if (((1301 - (384 + 917)) == v231) or ((905 - (128 + 569)) == (4502 - (1407 + 136)))) then
							v232 = v119.HandleDPSPotion(v14:BuffUp(v103.FeralSpiritBuff));
							if (((6164 - (687 + 1200)) >= (3023 - (556 + 1154))) and v232) then
								return v232;
							end
							if (((9101 - 6514) < (3269 - (9 + 86))) and (v100 < v118)) then
								if ((v58 and ((v36 and v65) or not v65)) or ((4541 - (275 + 146)) <= (358 + 1840))) then
									local v244 = 64 - (29 + 35);
									while true do
										if ((v244 == (0 - 0)) or ((4767 - 3171) == (3787 - 2929))) then
											v33 = v133();
											if (((2098 + 1122) == (4232 - (53 + 959))) and v33) then
												return v33;
											end
											break;
										end
									end
								end
							end
							if (((v100 < v118) and v59 and ((v66 and v36) or not v66)) or ((1810 - (312 + 96)) > (6283 - 2663))) then
								if (((2859 - (147 + 138)) == (3473 - (813 + 86))) and v103.BloodFury:IsCastable() and (not v103.Ascendance:IsAvailable() or v14:BuffUp(v103.AscendanceBuff) or (v103.Ascendance:CooldownRemains() > (46 + 4)))) then
									if (((3330 - 1532) < (3249 - (18 + 474))) and v24(v103.BloodFury)) then
										return "blood_fury racial";
									end
								end
								if ((v103.Berserking:IsCastable() and (not v103.Ascendance:IsAvailable() or v14:BuffUp(v103.AscendanceBuff))) or ((128 + 249) > (8498 - 5894))) then
									if (((1654 - (860 + 226)) < (1214 - (121 + 182))) and v24(v103.Berserking)) then
										return "berserking racial";
									end
								end
								if (((405 + 2880) < (5468 - (988 + 252))) and v103.Fireblood:IsCastable() and (not v103.Ascendance:IsAvailable() or v14:BuffUp(v103.AscendanceBuff) or (v103.Ascendance:CooldownRemains() > (6 + 44)))) then
									if (((1227 + 2689) > (5298 - (49 + 1921))) and v24(v103.Fireblood)) then
										return "fireblood racial";
									end
								end
								if (((3390 - (223 + 667)) < (3891 - (51 + 1))) and v103.AncestralCall:IsCastable() and (not v103.Ascendance:IsAvailable() or v14:BuffUp(v103.AscendanceBuff) or (v103.Ascendance:CooldownRemains() > (86 - 36)))) then
									if (((1085 - 578) == (1632 - (146 + 979))) and v24(v103.AncestralCall)) then
										return "ancestral_call racial";
									end
								end
							end
							v231 = 1 + 0;
						end
						if (((845 - (311 + 294)) <= (8826 - 5661)) and (v231 == (1 + 0))) then
							if (((2277 - (496 + 947)) >= (2163 - (1233 + 125))) and v103.TotemicProjection:IsCastable() and (v103.WindfuryTotem:TimeSinceLastCast() < (37 + 53)) and v14:BuffDown(v103.WindfuryTotemBuff, true)) then
								if (v24(v105.TotemicProjectionPlayer) or ((3421 + 391) < (441 + 1875))) then
									return "totemic_projection wind_fury main 0";
								end
							end
							if ((v103.Windstrike:IsCastable() and v53) or ((4297 - (963 + 682)) <= (1280 + 253))) then
								if (v24(v103.Windstrike, not v15:IsSpellInRange(v103.Windstrike)) or ((5102 - (504 + 1000)) < (984 + 476))) then
									return "windstrike main 1";
								end
							end
							if ((v103.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v118) and (v14:HasTier(29 + 2, 1 + 1))) or ((6069 - 1953) < (1019 + 173))) then
								if (v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave)) or ((1964 + 1413) <= (1085 - (156 + 26)))) then
									return "primordial_wave main 2";
								end
							end
							if (((2291 + 1685) >= (686 - 247)) and v103.FeralSpirit:IsCastable() and v56 and ((v61 and v36) or not v61) and (v100 < v118)) then
								if (((3916 - (149 + 15)) == (4712 - (890 + 70))) and v24(v103.FeralSpirit)) then
									return "feral_spirit main 3";
								end
							end
							v231 = 119 - (39 + 78);
						end
					end
				end
				break;
			end
			if (((4528 - (14 + 468)) > (5926 - 3231)) and (v156 == (8 - 5))) then
				if ((v103.Purge:IsReady() and v101 and v38 and v92 and not v14:IsCasting() and not v14:IsChanneling() and v119.UnitHasMagicBuff(v15)) or ((1830 + 1715) == (1920 + 1277))) then
					if (((509 + 1885) > (169 + 204)) and v24(v103.Purge, not v15:IsSpellInRange(v103.Purge))) then
						return "purge damage";
					end
				end
				v33 = v130();
				v156 = 2 + 2;
			end
			if (((7953 - 3798) <= (4183 + 49)) and (v156 == (0 - 0))) then
				v33 = v132();
				if (v33 or ((91 + 3490) == (3524 - (12 + 39)))) then
					return v33;
				end
				v156 = 1 + 0;
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
		v80 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 - 0);
		v78 = EpicSettings.Settings['astralShiftHP'] or (0 + 0);
		v81 = EpicSettings.Settings['healingStreamTotemHP'] or (0 + 0);
		v82 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 - 0);
		v83 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (0 + 0);
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
		v100 = EpicSettings.Settings['fightRemainsCheck'] or (1710 - (1596 + 114));
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
		v84 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v85 = EpicSettings.Settings['healingPotionHP'] or (713 - (164 + 549));
		v96 = EpicSettings.Settings['HealingPotionName'] or "";
		v94 = EpicSettings.Settings['handleAfflicted'];
		v95 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v142()
		v140();
		v139();
		v141();
		v34 = EpicSettings.Toggles['ooc'];
		v35 = EpicSettings.Toggles['aoe'];
		v36 = EpicSettings.Toggles['cds'];
		v38 = EpicSettings.Toggles['dispel'];
		v37 = EpicSettings.Toggles['minicds'];
		if (((6433 - (1059 + 379)) > (4156 - 808)) and v14:IsDeadOrGhost()) then
			return v33;
		end
		v107, v109, _, _, v108, v110 = v27();
		v111 = v14:GetEnemiesInRange(21 + 19);
		v112 = v14:GetEnemiesInMeleeRange(2 + 8);
		if (v35 or ((1146 - (145 + 247)) > (3056 + 668))) then
			local v223 = 0 + 0;
			while true do
				if (((643 - 426) >= (11 + 46)) and (v223 == (0 + 0))) then
					v114 = #v111;
					v113 = #v112;
					break;
				end
			end
		else
			local v224 = 0 - 0;
			while true do
				if ((v224 == (720 - (254 + 466))) or ((2630 - (544 + 16)) >= (12829 - 8792))) then
					v114 = 629 - (294 + 334);
					v113 = 254 - (236 + 17);
					break;
				end
			end
		end
		if (((1167 + 1538) == (2106 + 599)) and v38 and v93) then
			local v225 = 0 - 0;
			while true do
				if (((288 - 227) == (32 + 29)) and (v225 == (0 + 0))) then
					if ((v14:AffectingCombat() and v103.CleanseSpirit:IsAvailable()) or ((1493 - (413 + 381)) >= (55 + 1241))) then
						local v236 = v93 and v103.CleanseSpirit:IsReady() and v38;
						v33 = v119.FocusUnit(v236, nil, 42 - 22, nil, 64 - 39, v103.HealingSurge);
						if (v33 or ((3753 - (582 + 1388)) >= (6160 - 2544))) then
							return v33;
						end
					end
					if (v103.CleanseSpirit:IsAvailable() or ((2801 + 1112) > (4891 - (326 + 38)))) then
						if (((12944 - 8568) > (1165 - 348)) and v17 and v17:Exists() and v17:IsAPlayer() and v119.UnitHasCurseDebuff(v17)) then
							if (((5481 - (47 + 573)) > (291 + 533)) and v103.CleanseSpirit:IsReady()) then
								if (v24(v105.CleanseSpiritMouseover) or ((5873 - 4490) >= (3458 - 1327))) then
									return "cleanse_spirit mouseover";
								end
							end
						end
					end
					break;
				end
			end
		end
		if (v119.TargetIsValid() or v14:AffectingCombat() or ((3540 - (1269 + 395)) >= (3033 - (76 + 416)))) then
			local v226 = 443 - (319 + 124);
			while true do
				if (((4073 - 2291) <= (4779 - (564 + 443))) and (v226 == (2 - 1))) then
					if ((v118 == (11569 - (337 + 121))) or ((13771 - 9071) < (2707 - 1894))) then
						v118 = v10.FightRemains(v112, false);
					end
					break;
				end
				if (((5110 - (1261 + 650)) < (1714 + 2336)) and (v226 == (0 - 0))) then
					v117 = v10.BossFightRemains(nil, true);
					v118 = v117;
					v226 = 1818 - (772 + 1045);
				end
			end
		end
		if (v14:AffectingCombat() or ((699 + 4252) < (4574 - (102 + 42)))) then
			if (((1940 - (1524 + 320)) == (1366 - (1049 + 221))) and v14:PrevGCD(157 - (18 + 138), v103.ChainLightning)) then
				v116 = "Chain Lightning";
			elseif (v14:PrevGCD(2 - 1, v103.LightningBolt) or ((3841 - (67 + 1035)) > (4356 - (136 + 212)))) then
				v116 = "Lightning Bolt";
			end
		end
		if ((not v14:IsChanneling() and not v14:IsChanneling()) or ((97 - 74) == (909 + 225))) then
			local v227 = 0 + 0;
			while true do
				if ((v227 == (1604 - (240 + 1364))) or ((3775 - (1050 + 32)) >= (14678 - 10567))) then
					if (v94 or ((2553 + 1763) <= (3201 - (331 + 724)))) then
						local v237 = 0 + 0;
						while true do
							if ((v237 == (645 - (269 + 375))) or ((4271 - (267 + 458)) <= (874 + 1935))) then
								if (((9430 - 4526) > (2984 - (667 + 151))) and v90) then
									local v245 = 1497 - (1410 + 87);
									while true do
										if (((2006 - (1504 + 393)) >= (243 - 153)) and (v245 == (0 - 0))) then
											v33 = v119.HandleAfflicted(v103.PoisonCleansingTotem, v103.PoisonCleansingTotem, 826 - (461 + 335));
											if (((637 + 4341) > (4666 - (1730 + 31))) and v33) then
												return v33;
											end
											break;
										end
									end
								end
								if (((v14:BuffStack(v103.MaelstromWeaponBuff) >= (1672 - (728 + 939))) and v91) or ((10717 - 7691) <= (4624 - 2344))) then
									v33 = v119.HandleAfflicted(v103.HealingSurge, v105.HealingSurgeMouseover, 91 - 51, true);
									if (v33 or ((2721 - (138 + 930)) <= (1013 + 95))) then
										return v33;
									end
								end
								break;
							end
							if (((2275 + 634) > (2236 + 373)) and (v237 == (0 - 0))) then
								if (((2523 - (459 + 1307)) > (2064 - (474 + 1396))) and v88) then
									local v246 = 0 - 0;
									while true do
										if ((v246 == (0 + 0)) or ((1 + 30) >= (4004 - 2606))) then
											v33 = v119.HandleAfflicted(v103.CleanseSpirit, v105.CleanseSpiritMouseover, 6 + 34);
											if (((10669 - 7473) <= (21247 - 16375)) and v33) then
												return v33;
											end
											break;
										end
									end
								end
								if (((3917 - (562 + 29)) == (2836 + 490)) and v89) then
									v33 = v119.HandleAfflicted(v103.TremorTotem, v103.TremorTotem, 1449 - (374 + 1045));
									if (((1135 + 298) <= (12041 - 8163)) and v33) then
										return v33;
									end
								end
								v237 = 639 - (448 + 190);
							end
						end
					end
					if (v14:AffectingCombat() or ((512 + 1071) == (784 + 951))) then
						v33 = v138();
						if (v33 or ((1943 + 1038) == (9035 - 6685))) then
							return v33;
						end
					else
						local v238 = 0 - 0;
						while true do
							if ((v238 == (1494 - (1307 + 187))) or ((17710 - 13244) <= (1153 - 660))) then
								v33 = v137();
								if (v33 or ((7809 - 5262) <= (2670 - (232 + 451)))) then
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
	end
	local function v143()
		v103.FlameShockDebuff:RegisterAuraTracking();
		v123();
		v21.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(252 + 11, v142, v143);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

