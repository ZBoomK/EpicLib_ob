local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1907 - (629 + 1277))) or ((2255 - (503 + 396)) > (4904 - (92 + 89)))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((2122 + 2014) <= (2032 + 1401))) then
			v6 = v0[v4];
			if (((16624 - 12379) <= (634 + 3997)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
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
	local v111;
	local v112 = 9 + 1;
	local v113 = 4 + 4;
	local v114 = 17 - 11;
	local v115 = 125 + 875;
	local v116, v117, v118, v119;
	local v120 = (v103.LavaBurst:IsAvailable() and (2 - 0)) or (1245 - (485 + 759));
	local v121 = "Lightning Bolt";
	local v122 = 25709 - 14598;
	local v123 = 12300 - (442 + 747);
	local v124 = v21.Commons.Everyone;
	v21.Commons.Shaman = {};
	local v126 = v21.Commons.Shaman;
	v126.FeralSpiritCount = 1135 - (832 + 303);
	v10:RegisterForEvent(function()
		v120 = (v103.LavaBurst:IsAvailable() and (948 - (88 + 858))) or (1 + 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		local v151 = 0 + 0;
		while true do
			if (((177 + 4099) >= (4703 - (766 + 23))) and (v151 == (4 - 3))) then
				v123 = 15195 - 4084;
				break;
			end
			if (((521 - 323) <= (14814 - 10449)) and (v151 == (1073 - (1036 + 37)))) then
				v121 = "Lightning Bolt";
				v122 = 7878 + 3233;
				v151 = 1 - 0;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v128(v152)
		local v153 = 0 + 0;
		local v154;
		local v155;
		while true do
			if (((6262 - (641 + 839)) > (5589 - (910 + 3))) and (v153 == (2 - 1))) then
				for v239, v240 in pairs(v154) do
					if (((6548 - (1466 + 218)) > (1010 + 1187)) and (v240:GUID() ~= v15:GUID()) and (v240:AffectingCombat() or v240:IsDummy())) then
						v155 = v155 + (1149 - (556 + 592));
					end
				end
				return v155;
			end
			if ((v153 == (0 + 0)) or ((4508 - (329 + 479)) == (3361 - (174 + 680)))) then
				v154 = v14:GetEnemiesInRange(v152);
				v155 = 3 - 2;
				v153 = 1 - 0;
			end
		end
	end
	v10:RegisterForSelfCombatEvent(function(...)
		local v156, v157, v157, v157, v157, v157, v157, v157, v158 = select(3 + 1, ...);
		if (((5213 - (396 + 343)) >= (25 + 249)) and (v156 == v14:GUID()) and (v158 == (193111 - (29 + 1448)))) then
			v126.LastSKCast = v31();
		end
		if ((v14:HasTier(1420 - (135 + 1254), 7 - 5) and (v156 == v14:GUID()) and (v158 == (1755506 - 1379524))) or ((1263 + 631) <= (2933 - (389 + 1138)))) then
			v126.FeralSpiritCount = v126.FeralSpiritCount + (575 - (102 + 472));
			v32.After(15 + 0, function()
				v126.FeralSpiritCount = v126.FeralSpiritCount - (1 + 0);
			end);
		end
		if (((1466 + 106) >= (3076 - (320 + 1225))) and (v156 == v14:GUID()) and (v158 == (91738 - 40205))) then
			v126.FeralSpiritCount = v126.FeralSpiritCount + 2 + 0;
			v32.After(1479 - (157 + 1307), function()
				v126.FeralSpiritCount = v126.FeralSpiritCount - (1861 - (821 + 1038));
			end);
		end
	end, "SPELL_CAST_SUCCESS");
	local function v129()
		if (v103.CleanseSpirit:IsAvailable() or ((11693 - 7006) < (497 + 4045))) then
			v124.DispellableDebuffs = v124.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v129();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v130()
		local v159 = 0 - 0;
		local v160;
		while true do
			if (((1225 + 2066) > (4131 - 2464)) and (v159 == (1026 - (834 + 192)))) then
				if (not v103.AlphaWolf:IsAvailable() or v14:BuffDown(v103.FeralSpiritBuff) or ((56 + 817) == (523 + 1511))) then
					return 0 + 0;
				end
				v160 = v29(v103.CrashLightning:TimeSinceLastCast(), v103.ChainLightning:TimeSinceLastCast());
				v159 = 1 - 0;
			end
			if ((v159 == (305 - (300 + 4))) or ((753 + 2063) < (28 - 17))) then
				if (((4061 - (112 + 250)) < (1877 + 2829)) and ((v160 > (19 - 11)) or (v160 > v103.FeralSpirit:TimeSinceLastCast()))) then
					return 0 + 0;
				end
				return (5 + 3) - v160;
			end
		end
	end
	local function v131(v161)
		return (v161:DebuffRefreshable(v103.FlameShockDebuff));
	end
	local function v132(v162)
		return v162:DebuffRemains(v103.FlameShockDebuff);
	end
	local function v133(v163)
		return v14:BuffDown(v103.PrimordialWaveBuff);
	end
	local function v134(v164)
		return v164:DebuffRemains(v103.LashingFlamesDebuff);
	end
	local v135 = 0 + 0;
	local function v136()
		if (((1312 + 1334) >= (651 + 225)) and v103.CleanseSpirit:IsReady() and v38 and (v124.UnitHasDispellableDebuffByPlayer(v16) or v124.DispellableFriendlyUnit(1434 - (1001 + 413)) or v124.UnitHasCurseDebuff(v16))) then
			if (((1368 - 754) <= (4066 - (244 + 638))) and (v135 == (693 - (627 + 66)))) then
				v135 = v31();
			end
			if (((9314 - 6188) == (3728 - (512 + 90))) and v124.Wait(2406 - (1665 + 241), v135)) then
				local v241 = 717 - (373 + 344);
				while true do
					if ((v241 == (0 + 0)) or ((579 + 1608) >= (13067 - 8113))) then
						if (v24(v105.CleanseSpiritFocus) or ((6560 - 2683) == (4674 - (35 + 1064)))) then
							return "cleanse_spirit dispel";
						end
						v135 = 0 + 0;
						break;
					end
				end
			end
		end
	end
	local function v137()
		if (((1512 - 805) > (3 + 629)) and (not v16 or not v16:Exists() or not v16:IsInRange(1276 - (298 + 938)))) then
			return;
		end
		if (v16 or ((1805 - (233 + 1026)) >= (4350 - (636 + 1030)))) then
			if (((750 + 715) <= (4202 + 99)) and (v16:HealthPercentage() <= v83) and v73 and v103.HealingSurge:IsReady() and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (2 + 3))) then
				if (((116 + 1588) > (1646 - (55 + 166))) and v24(v105.HealingSurgeFocus)) then
					return "healing_surge heal focus";
				end
			end
		end
	end
	local function v138()
		if ((v14:HealthPercentage() <= v87) or ((134 + 553) == (426 + 3808))) then
			if (v103.HealingSurge:IsReady() or ((12717 - 9387) < (1726 - (36 + 261)))) then
				if (((2005 - 858) >= (1703 - (34 + 1334))) and v24(v103.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v139()
		local v165 = 0 + 0;
		while true do
			if (((2669 + 766) > (3380 - (1035 + 248))) and (v165 == (22 - (20 + 1)))) then
				if ((v103.HealingStreamTotem:IsReady() and v72 and v124.AreUnitsBelowHealthPercentage(v81, v82, v103.HealingSurge)) or ((1965 + 1805) >= (4360 - (134 + 185)))) then
					if (v24(v103.HealingStreamTotem) or ((4924 - (549 + 584)) <= (2296 - (314 + 371)))) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v103.HealingSurge:IsReady() and v73 and (v14:HealthPercentage() <= v83) and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (17 - 12))) or ((5546 - (478 + 490)) <= (1064 + 944))) then
					if (((2297 - (786 + 386)) <= (6723 - 4647)) and v24(v103.HealingSurge)) then
						return "healing_surge defensive 4";
					end
				end
				v165 = 1381 - (1055 + 324);
			end
			if ((v165 == (1342 - (1093 + 247))) or ((661 + 82) >= (463 + 3936))) then
				if (((4585 - 3430) < (5677 - 4004)) and v104.Healthstone:IsReady() and v74 and (v14:HealthPercentage() <= v84)) then
					if (v24(v105.Healthstone) or ((6612 - 4288) <= (1452 - 874))) then
						return "healthstone defensive 3";
					end
				end
				if (((1341 + 2426) == (14512 - 10745)) and v75 and (v14:HealthPercentage() <= v85)) then
					local v244 = 0 - 0;
					while true do
						if (((3084 + 1005) == (10456 - 6367)) and (v244 == (688 - (364 + 324)))) then
							if (((12220 - 7762) >= (4016 - 2342)) and (v96 == "Refreshing Healing Potion")) then
								if (((323 + 649) <= (5933 - 4515)) and v104.RefreshingHealingPotion:IsReady()) then
									if (v24(v105.RefreshingHealingPotion) or ((7908 - 2970) < (14462 - 9700))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v96 == "Dreamwalker's Healing Potion") or ((3772 - (1249 + 19)) > (3849 + 415))) then
								if (((8380 - 6227) == (3239 - (686 + 400))) and v104.DreamwalkersHealingPotion:IsReady()) then
									if (v24(v105.RefreshingHealingPotion) or ((398 + 109) >= (2820 - (73 + 156)))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							v244 = 1 + 0;
						end
						if (((5292 - (721 + 90)) == (51 + 4430)) and (v244 == (3 - 2))) then
							if ((v96 == "Potion of Withering Dreams") or ((2798 - (224 + 246)) < (1122 - 429))) then
								if (((7968 - 3640) == (786 + 3542)) and v104.PotionOfWitheringDreams:IsReady()) then
									if (((38 + 1550) >= (979 + 353)) and v24(v105.RefreshingHealingPotion)) then
										return "potion of withering dreams defensive";
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v165 == (0 - 0)) or ((13889 - 9715) > (4761 - (203 + 310)))) then
				if ((v103.AstralShift:IsReady() and v70 and (v14:HealthPercentage() <= v78)) or ((6579 - (1238 + 755)) <= (6 + 76))) then
					if (((5397 - (709 + 825)) == (7117 - 3254)) and v24(v103.AstralShift)) then
						return "astral_shift defensive 1";
					end
				end
				if ((v103.AncestralGuidance:IsReady() and v71 and v124.AreUnitsBelowHealthPercentage(v79, v80, v103.HealingSurge)) or ((410 - 128) <= (906 - (196 + 668)))) then
					if (((18197 - 13588) >= (1586 - 820)) and v24(v103.AncestralGuidance)) then
						return "ancestral_guidance defensive 2";
					end
				end
				v165 = 834 - (171 + 662);
			end
		end
	end
	local function v140()
		local v166 = 93 - (4 + 89);
		while true do
			if ((v166 == (3 - 2)) or ((420 + 732) == (10927 - 8439))) then
				v33 = v124.HandleBottomTrinket(v106, v36, 16 + 24, nil);
				if (((4908 - (35 + 1451)) > (4803 - (28 + 1425))) and v33) then
					return v33;
				end
				break;
			end
			if (((2870 - (941 + 1052)) > (361 + 15)) and ((1514 - (822 + 692)) == v166)) then
				v33 = v124.HandleTopTrinket(v106, v36, 57 - 17, nil);
				if (v33 or ((1469 + 1649) <= (2148 - (45 + 252)))) then
					return v33;
				end
				v166 = 1 + 0;
			end
		end
	end
	local function v141()
		if ((v103.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v103.WindfuryTotemBuff, true) or (v103.WindfuryTotem:TimeSinceLastCast() > (31 + 59)))) or ((401 - 236) >= (3925 - (114 + 319)))) then
			if (((5669 - 1720) < (6222 - 1366)) and v24(v103.WindfuryTotem)) then
				return "windfury_totem precombat 2";
			end
		end
		if ((v103.PrimordialWave:IsReady() and v49 and ((v64 and v37) or not v64)) or ((2726 + 1550) < (4493 - 1477))) then
			if (((9826 - 5136) > (6088 - (556 + 1407))) and v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave))) then
				return "primordial_wave precombat 4";
			end
		end
		if ((v103.FeralSpirit:IsCastable() and v56 and ((v61 and v36) or not v61)) or ((1256 - (741 + 465)) >= (1361 - (170 + 295)))) then
			if (v24(v103.FeralSpirit) or ((904 + 810) >= (2718 + 240))) then
				return "feral_spirit precombat 6";
			end
		end
		if ((v103.FlameShock:IsReady() and v43) or ((3670 - 2179) < (534 + 110))) then
			if (((452 + 252) < (559 + 428)) and v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock))) then
				return "flame_shock precombat 8";
			end
		end
	end
	local function v142()
		if (((4948 - (957 + 273)) > (510 + 1396)) and v103.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v123) and v15:DebuffDown(v103.FlameShockDebuff) and v103.LashingFlames:IsAvailable()) then
			if (v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave)) or ((384 + 574) > (13850 - 10215))) then
				return "primordial_wave single 1";
			end
		end
		if (((9225 - 5724) <= (13720 - 9228)) and v103.FlameShock:IsReady() and v43 and v15:DebuffDown(v103.FlameShockDebuff) and v103.LashingFlames:IsAvailable()) then
			if (v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock)) or ((17043 - 13601) < (4328 - (389 + 1391)))) then
				return "flame_shock single 2";
			end
		end
		if (((1804 + 1071) >= (153 + 1311)) and v103.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (11 - 6)) and v103.ElementalSpirits:IsAvailable() and (v126.FeralSpiritCount >= (955 - (783 + 168)))) then
			if (v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast)) or ((16099 - 11302) >= (4813 + 80))) then
				return "elemental_blast single 3";
			end
		end
		if ((v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v123) and (v14:HasTier(341 - (309 + 2), 5 - 3))) or ((1763 - (1090 + 122)) > (671 + 1397))) then
			if (((7099 - 4985) > (647 + 297)) and v24(v103.Sundering, not v15:IsInRange(1126 - (628 + 490)))) then
				return "sundering single 4";
			end
		end
		if ((v103.LightningBolt:IsCastable() and v48 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (1 + 4)) and v14:BuffDown(v103.CracklingThunderBuff) and v14:BuffUp(v103.AscendanceBuff) and (v121 == "Chain Lightning") and (v14:BuffRemains(v103.AscendanceBuff) > (v103.ChainLightning:CooldownRemains() + v14:GCD()))) or ((5599 - 3337) >= (14148 - 11052))) then
			if (v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt)) or ((3029 - (431 + 343)) >= (7142 - 3605))) then
				return "lightning_bolt single 5";
			end
		end
		if ((v103.Stormstrike:IsReady() and v50 and (v14:BuffUp(v103.DoomWindsBuff) or v103.DeeplyRootedElements:IsAvailable() or (v103.Stormblast:IsAvailable() and v14:BuffUp(v103.StormbringerBuff)))) or ((11099 - 7262) < (1032 + 274))) then
			if (((378 + 2572) == (4645 - (556 + 1139))) and v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike))) then
				return "stormstrike single 6";
			end
		end
		if ((v103.LavaLash:IsReady() and v47 and (v14:BuffUp(v103.HotHandBuff))) or ((4738 - (6 + 9)) < (604 + 2694))) then
			if (((582 + 554) >= (323 - (28 + 141))) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
				return "lava_lash single 7";
			end
		end
		if ((v103.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v103.WindfuryTotemBuff, true))) or ((105 + 166) > (5860 - 1112))) then
			if (((3358 + 1382) >= (4469 - (486 + 831))) and v24(v103.WindfuryTotem)) then
				return "windfury_totem single 8";
			end
		end
		if ((v103.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (12 - 7)) and (v103.ElementalBlast:Charges() == v120)) or ((9075 - 6497) >= (641 + 2749))) then
			if (((129 - 88) <= (2924 - (668 + 595))) and v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast))) then
				return "elemental_blast single 9";
			end
		end
		if (((541 + 60) < (718 + 2842)) and v103.LightningBolt:IsReady() and v48 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (21 - 13)) and v14:BuffUp(v103.PrimordialWaveBuff) and (v14:BuffDown(v103.SplinteredElementsBuff) or (v123 <= (302 - (23 + 267))))) then
			if (((2179 - (1129 + 815)) < (1074 - (371 + 16))) and v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt))) then
				return "lightning_bolt single 10";
			end
		end
		if (((6299 - (1326 + 424)) > (2183 - 1030)) and v103.ChainLightning:IsReady() and v39 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (29 - 21)) and v14:BuffUp(v103.CracklingThunderBuff) and v103.ElementalSpirits:IsAvailable()) then
			if (v24(v103.ChainLightning, not v15:IsSpellInRange(v103.ChainLightning)) or ((4792 - (88 + 30)) < (5443 - (720 + 51)))) then
				return "chain_lightning single 11";
			end
		end
		if (((8159 - 4491) < (6337 - (421 + 1355))) and v103.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (13 - 5)) and ((v126.FeralSpiritCount >= (1 + 1)) or not v103.ElementalSpirits:IsAvailable())) then
			if (v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast)) or ((1538 - (286 + 797)) == (13178 - 9573))) then
				return "elemental_blast single 12";
			end
		end
		if ((v103.LavaBurst:IsReady() and v46 and not v103.ThorimsInvocation:IsAvailable() and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (7 - 2))) or ((3102 - (397 + 42)) == (1035 + 2277))) then
			if (((5077 - (24 + 776)) <= (6894 - 2419)) and v24(v103.LavaBurst, not v15:IsSpellInRange(v103.LavaBurst))) then
				return "lava_burst single 13";
			end
		end
		if ((v103.LightningBolt:IsReady() and v48 and ((v14:BuffStack(v103.MaelstromWeaponBuff) >= (793 - (222 + 563))) or (v103.StaticAccumulation:IsAvailable() and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (11 - 6)))) and v14:BuffDown(v103.PrimordialWaveBuff)) or ((627 + 243) == (1379 - (23 + 167)))) then
			if (((3351 - (690 + 1108)) <= (1131 + 2002)) and v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt))) then
				return "lightning_bolt single 14";
			end
		end
		if ((v103.CrashLightning:IsReady() and v40 and v103.AlphaWolf:IsAvailable() and v14:BuffUp(v103.FeralSpiritBuff) and (v130() == (0 + 0))) or ((3085 - (40 + 808)) >= (579 + 2932))) then
			if (v24(v103.CrashLightning, not v15:IsInMeleeRange(30 - 22)) or ((1266 + 58) > (1598 + 1422))) then
				return "crash_lightning single 15";
			end
		end
		if ((v103.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v123)) or ((1641 + 1351) == (2452 - (47 + 524)))) then
			if (((2016 + 1090) > (4171 - 2645)) and v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave))) then
				return "primordial_wave single 16";
			end
		end
		if (((4520 - 1497) < (8826 - 4956)) and v103.FlameShock:IsReady() and v43 and (v15:DebuffDown(v103.FlameShockDebuff))) then
			if (((1869 - (1165 + 561)) > (3 + 71)) and v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock))) then
				return "flame_shock single 17";
			end
		end
		if (((55 - 37) < (806 + 1306)) and v103.IceStrike:IsReady() and v45 and v103.ElementalAssault:IsAvailable() and v103.SwirlingMaelstrom:IsAvailable()) then
			if (((1576 - (341 + 138)) <= (440 + 1188)) and v24(v103.IceStrike, not v15:IsInMeleeRange(10 - 5))) then
				return "ice_strike single 18";
			end
		end
		if (((4956 - (89 + 237)) == (14894 - 10264)) and v103.LavaLash:IsReady() and v47 and (v103.LashingFlames:IsAvailable())) then
			if (((7452 - 3912) > (3564 - (581 + 300))) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
				return "lava_lash single 19";
			end
		end
		if (((6014 - (855 + 365)) >= (7778 - 4503)) and v103.IceStrike:IsReady() and v45 and (v14:BuffDown(v103.IceStrikeBuff))) then
			if (((485 + 999) == (2719 - (1030 + 205))) and v24(v103.IceStrike, not v15:IsInMeleeRange(5 + 0))) then
				return "ice_strike single 20";
			end
		end
		if (((1333 + 99) < (3841 - (156 + 130))) and v103.FrostShock:IsReady() and v44 and (v14:BuffUp(v103.HailstormBuff))) then
			if (v24(v103.FrostShock, not v15:IsSpellInRange(v103.FrostShock)) or ((2419 - 1354) > (6030 - 2452))) then
				return "frost_shock single 21";
			end
		end
		if ((v103.LavaLash:IsReady() and v47) or ((9820 - 5025) < (371 + 1036))) then
			if (((1081 + 772) < (4882 - (10 + 59))) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
				return "lava_lash single 22";
			end
		end
		if ((v103.IceStrike:IsReady() and v45) or ((798 + 2023) < (11972 - 9541))) then
			if (v24(v103.IceStrike, not v15:IsInMeleeRange(1168 - (671 + 492))) or ((2288 + 586) < (3396 - (369 + 846)))) then
				return "ice_strike single 23";
			end
		end
		if ((v103.Windstrike:IsCastable() and v53) or ((712 + 1977) <= (293 + 50))) then
			if (v24(v103.Windstrike, not v15:IsSpellInRange(v103.Windstrike)) or ((3814 - (1036 + 909)) == (1598 + 411))) then
				return "windstrike single 24";
			end
		end
		if ((v103.Stormstrike:IsReady() and v50) or ((5953 - 2407) < (2525 - (11 + 192)))) then
			if (v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike)) or ((1053 + 1029) == (4948 - (135 + 40)))) then
				return "stormstrike single 25";
			end
		end
		if (((7859 - 4615) > (636 + 419)) and v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v123)) then
			if (v24(v103.Sundering, not v15:IsInRange(17 - 9)) or ((4966 - 1653) <= (1954 - (50 + 126)))) then
				return "sundering single 26";
			end
		end
		if ((v103.BagofTricks:IsReady() and v59 and ((v66 and v36) or not v66)) or ((3956 - 2535) >= (466 + 1638))) then
			if (((3225 - (1233 + 180)) <= (4218 - (522 + 447))) and v24(v103.BagofTricks)) then
				return "bag_of_tricks single 27";
			end
		end
		if (((3044 - (107 + 1314)) <= (909 + 1048)) and v103.FireNova:IsReady() and v42 and v103.SwirlingMaelstrom:IsAvailable() and (v103.FlameShockDebuff:AuraActiveCount() > (0 - 0)) and (v14:BuffStack(v103.MaelstromWeaponBuff) < (3 + 2 + ((9 - 4) * v25(v103.OverflowingMaelstrom:IsAvailable()))))) then
			if (((17456 - 13044) == (6322 - (716 + 1194))) and v24(v103.FireNova)) then
				return "fire_nova single 28";
			end
		end
		if (((30 + 1720) >= (91 + 751)) and v103.LightningBolt:IsReady() and v48 and v103.Hailstorm:IsAvailable() and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (508 - (74 + 429))) and v14:BuffDown(v103.PrimordialWaveBuff)) then
			if (((8433 - 4061) > (917 + 933)) and v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt))) then
				return "lightning_bolt single 29";
			end
		end
		if (((530 - 298) < (581 + 240)) and v103.FrostShock:IsReady() and v44) then
			if (((1596 - 1078) < (2229 - 1327)) and v24(v103.FrostShock, not v15:IsSpellInRange(v103.FrostShock))) then
				return "frost_shock single 30";
			end
		end
		if (((3427 - (279 + 154)) > (1636 - (454 + 324))) and v103.CrashLightning:IsReady() and v40) then
			if (v24(v103.CrashLightning, not v15:IsInMeleeRange(7 + 1)) or ((3772 - (12 + 5)) <= (494 + 421))) then
				return "crash_lightning single 31";
			end
		end
		if (((10054 - 6108) > (1384 + 2359)) and v103.FireNova:IsReady() and v42 and (v15:DebuffUp(v103.FlameShockDebuff))) then
			if (v24(v103.FireNova) or ((2428 - (277 + 816)) >= (14126 - 10820))) then
				return "fire_nova single 32";
			end
		end
		if (((6027 - (1058 + 125)) > (423 + 1830)) and v103.FlameShock:IsReady() and v43) then
			if (((1427 - (815 + 160)) == (1939 - 1487)) and v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock))) then
				return "flame_shock single 34";
			end
		end
		if ((v103.ChainLightning:IsReady() and v39 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (11 - 6)) and v14:BuffUp(v103.CracklingThunderBuff) and v103.ElementalSpirits:IsAvailable()) or ((1088 + 3469) < (6100 - 4013))) then
			if (((5772 - (41 + 1857)) == (5767 - (1222 + 671))) and v24(v103.ChainLightning, not v15:IsSpellInRange(v103.ChainLightning))) then
				return "chain_lightning single 35";
			end
		end
		if ((v103.LightningBolt:IsReady() and v48 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (12 - 7)) and v14:BuffDown(v103.PrimordialWaveBuff)) or ((2785 - 847) > (6117 - (229 + 953)))) then
			if (v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt)) or ((6029 - (1111 + 663)) < (5002 - (874 + 705)))) then
				return "lightning_bolt single 36";
			end
		end
		if (((204 + 1250) <= (1700 + 791)) and v103.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v103.WindfuryTotemBuff, true) or (v103.WindfuryTotem:TimeSinceLastCast() > (187 - 97)))) then
			if (v24(v103.WindfuryTotem) or ((117 + 4040) <= (3482 - (642 + 37)))) then
				return "windfury_totem single 37";
			end
		end
	end
	local function v143()
		local v167 = 0 + 0;
		while true do
			if (((777 + 4076) >= (7486 - 4504)) and (v167 == (457 - (233 + 221)))) then
				if (((9559 - 5425) > (2955 + 402)) and v103.IceStrike:IsReady() and v45 and v103.Hailstorm:IsAvailable() and v14:BuffDown(v103.IceStrikeBuff)) then
					if (v24(v103.IceStrike, not v15:IsInMeleeRange(1546 - (718 + 823))) or ((2151 + 1266) < (3339 - (266 + 539)))) then
						return "ice_strike aoe 13";
					end
				end
				if ((v103.FrostShock:IsReady() and v44 and v103.Hailstorm:IsAvailable() and v14:BuffUp(v103.HailstormBuff)) or ((7706 - 4984) <= (1389 - (636 + 589)))) then
					if (v24(v103.FrostShock, not v15:IsSpellInRange(v103.FrostShock)) or ((5715 - 3307) < (4349 - 2240))) then
						return "frost_shock aoe 14";
					end
				end
				if ((v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v123)) or ((27 + 6) == (529 + 926))) then
					if (v24(v103.Sundering, not v15:IsInRange(1023 - (657 + 358))) or ((1172 - 729) >= (9147 - 5132))) then
						return "sundering aoe 15";
					end
				end
				if (((4569 - (1151 + 36)) > (161 + 5)) and v103.FlameShock:IsReady() and v43 and v103.MoltenAssault:IsAvailable() and v15:DebuffDown(v103.FlameShockDebuff)) then
					if (v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock)) or ((74 + 206) == (9135 - 6076))) then
						return "flame_shock aoe 16";
					end
				end
				v167 = 1836 - (1552 + 280);
			end
			if (((2715 - (64 + 770)) > (878 + 415)) and (v167 == (8 - 4))) then
				if (((419 + 1938) == (3600 - (157 + 1086))) and v103.FlameShock:IsReady() and v43 and (v103.FireNova:IsAvailable() or v103.PrimordialWave:IsAvailable()) and (v103.FlameShockDebuff:AuraActiveCount() < v118) and (v103.FlameShockDebuff:AuraActiveCount() < (11 - 5))) then
					local v245 = 0 - 0;
					while true do
						if (((187 - 64) == (167 - 44)) and (v245 == (819 - (599 + 220)))) then
							if (v124.CastCycle(v103.FlameShock, v117, v131, not v15:IsSpellInRange(v103.FlameShock)) or ((2102 - 1046) >= (5323 - (1813 + 118)))) then
								return "flame_shock aoe 17";
							end
							if (v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock)) or ((791 + 290) < (2292 - (841 + 376)))) then
								return "flame_shock aoe no_cycle 17";
							end
							break;
						end
					end
				end
				if ((v103.FireNova:IsReady() and v42 and (v103.FlameShockDebuff:AuraActiveCount() >= (3 - 0))) or ((244 + 805) >= (12097 - 7665))) then
					if (v24(v103.FireNova) or ((5627 - (464 + 395)) <= (2171 - 1325))) then
						return "fire_nova aoe 18";
					end
				end
				if ((v103.Stormstrike:IsReady() and v50 and v14:BuffUp(v103.CrashLightningBuff) and (v103.DeeplyRootedElements:IsAvailable() or (v14:BuffStack(v103.ConvergingStormsBuff) == (3 + 3)))) or ((4195 - (467 + 370)) <= (2934 - 1514))) then
					if (v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike)) or ((2745 + 994) <= (10301 - 7296))) then
						return "stormstrike aoe 19";
					end
				end
				if ((v103.CrashLightning:IsReady() and v40 and v103.CrashingStorms:IsAvailable() and v14:BuffUp(v103.CLCrashLightningBuff) and (v118 >= (1 + 3))) or ((3859 - 2200) >= (2654 - (150 + 370)))) then
					if (v24(v103.CrashLightning, not v15:IsInMeleeRange(1290 - (74 + 1208))) or ((8018 - 4758) < (11168 - 8813))) then
						return "crash_lightning aoe 20";
					end
				end
				v167 = 4 + 1;
			end
			if ((v167 == (395 - (14 + 376))) or ((1159 - 490) == (2733 + 1490))) then
				if ((v103.Windstrike:IsCastable() and v53) or ((1487 + 205) < (561 + 27))) then
					if (v24(v103.Windstrike, not v15:IsSpellInRange(v103.Windstrike)) or ((14055 - 9258) < (2747 + 904))) then
						return "windstrike aoe 21";
					end
				end
				if ((v103.Stormstrike:IsReady() and v50) or ((4255 - (23 + 55)) > (11494 - 6644))) then
					if (v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike)) or ((267 + 133) > (998 + 113))) then
						return "stormstrike aoe 22";
					end
				end
				if (((4730 - 1679) > (317 + 688)) and v103.IceStrike:IsReady() and v45) then
					if (((4594 - (652 + 249)) <= (11726 - 7344)) and v24(v103.IceStrike, not v15:IsInMeleeRange(1873 - (708 + 1160)))) then
						return "ice_strike aoe 23";
					end
				end
				if ((v103.LavaLash:IsReady() and v47) or ((8908 - 5626) > (7475 - 3375))) then
					if (v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash)) or ((3607 - (10 + 17)) < (639 + 2205))) then
						return "lava_lash aoe 24";
					end
				end
				v167 = 1738 - (1400 + 332);
			end
			if (((170 - 81) < (6398 - (242 + 1666))) and (v167 == (1 + 1))) then
				if ((v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v123) and (v14:BuffUp(v103.DoomWindsBuff) or v14:HasTier(11 + 19, 2 + 0))) or ((5923 - (850 + 90)) < (3166 - 1358))) then
					if (((5219 - (360 + 1030)) > (3336 + 433)) and v24(v103.Sundering, not v15:IsInRange(22 - 14))) then
						return "sundering aoe 9";
					end
				end
				if (((2042 - 557) <= (4565 - (909 + 752))) and v103.FireNova:IsReady() and v42 and ((v103.FlameShockDebuff:AuraActiveCount() >= (1229 - (109 + 1114))) or ((v103.FlameShockDebuff:AuraActiveCount() >= (6 - 2)) and (v103.FlameShockDebuff:AuraActiveCount() >= v118)))) then
					if (((1662 + 2607) == (4511 - (6 + 236))) and v24(v103.FireNova)) then
						return "fire_nova aoe 10";
					end
				end
				if (((244 + 143) <= (2240 + 542)) and v103.LavaLash:IsReady() and v47 and (v103.LashingFlames:IsAvailable())) then
					if (v124.CastCycle(v103.LavaLash, v117, v134, not v15:IsSpellInRange(v103.LavaLash)) or ((4478 - 2579) <= (1601 - 684))) then
						return "lava_lash aoe 11";
					end
					if (v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash)) or ((5445 - (1076 + 57)) <= (145 + 731))) then
						return "lava_lash aoe no_cycle 11";
					end
				end
				if (((2921 - (579 + 110)) <= (205 + 2391)) and v103.LavaLash:IsReady() and v47 and ((v103.MoltenAssault:IsAvailable() and v15:DebuffUp(v103.FlameShockDebuff) and (v103.FlameShockDebuff:AuraActiveCount() < v118) and (v103.FlameShockDebuff:AuraActiveCount() < (6 + 0))) or (v103.AshenCatalyst:IsAvailable() and (v14:BuffStack(v103.AshenCatalystBuff) >= (3 + 2))))) then
					if (((2502 - (174 + 233)) < (10295 - 6609)) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
						return "lava_lash aoe 12";
					end
				end
				v167 = 4 - 1;
			end
			if ((v167 == (4 + 3)) or ((2769 - (663 + 511)) >= (3992 + 482))) then
				if ((v103.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v103.WindfuryTotemBuff, true) or (v103.WindfuryTotem:TimeSinceLastCast() > (20 + 70)))) or ((14240 - 9621) < (1746 + 1136))) then
					if (v24(v103.WindfuryTotem) or ((692 - 398) >= (11694 - 6863))) then
						return "windfury_totem aoe 29";
					end
				end
				if (((969 + 1060) <= (6002 - 2918)) and v103.FlameShock:IsReady() and v43 and (v15:DebuffDown(v103.FlameShockDebuff))) then
					if (v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock)) or ((1452 + 585) == (222 + 2198))) then
						return "flame_shock aoe 30";
					end
				end
				if (((5180 - (478 + 244)) > (4421 - (440 + 77))) and v103.FrostShock:IsReady() and v44 and not v103.Hailstorm:IsAvailable()) then
					if (((199 + 237) >= (449 - 326)) and v24(v103.FrostShock, not v15:IsSpellInRange(v103.FrostShock))) then
						return "frost_shock aoe 31";
					end
				end
				break;
			end
			if (((2056 - (655 + 901)) < (337 + 1479)) and (v167 == (5 + 1))) then
				if (((2414 + 1160) == (14398 - 10824)) and v103.CrashLightning:IsReady() and v40) then
					if (((1666 - (695 + 750)) < (1331 - 941)) and v24(v103.CrashLightning, not v15:IsInMeleeRange(12 - 4))) then
						return "crash_lightning aoe 25";
					end
				end
				if ((v103.FireNova:IsReady() and v42 and (v103.FlameShockDebuff:AuraActiveCount() >= (7 - 5))) or ((2564 - (285 + 66)) <= (3312 - 1891))) then
					if (((4368 - (682 + 628)) < (784 + 4076)) and v24(v103.FireNova)) then
						return "fire_nova aoe 26";
					end
				end
				if ((v103.ElementalBlast:IsReady() and v41 and (not v103.ElementalSpirits:IsAvailable() or (v103.ElementalSpirits:IsAvailable() and ((v103.ElementalBlast:Charges() == v120) or (v126.FeralSpiritCount >= (301 - (176 + 123)))))) and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (3 + 2)) and (not v103.CrashingStorms:IsAvailable() or (v118 <= (3 + 0)))) or ((1565 - (239 + 30)) >= (1209 + 3237))) then
					if (v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast)) or ((1339 + 54) > (7944 - 3455))) then
						return "elemental_blast aoe 27";
					end
				end
				if ((v103.ChainLightning:IsReady() and v39 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (15 - 10))) or ((4739 - (306 + 9)) < (94 - 67))) then
					if (v24(v103.ChainLightning, not v15:IsSpellInRange(v103.ChainLightning)) or ((348 + 1649) > (2341 + 1474))) then
						return "chain_lightning aoe 28";
					end
				end
				v167 = 4 + 3;
			end
			if (((9908 - 6443) > (3288 - (1140 + 235))) and (v167 == (0 + 0))) then
				if (((673 + 60) < (467 + 1352)) and v103.CrashLightning:IsReady() and v40 and v103.CrashingStorms:IsAvailable() and ((v103.UnrulyWinds:IsAvailable() and (v118 >= (62 - (33 + 19)))) or (v118 >= (6 + 9)))) then
					if (v24(v103.CrashLightning, not v15:IsInMeleeRange(23 - 15)) or ((1937 + 2458) == (9324 - 4569))) then
						return "crash_lightning aoe 1";
					end
				end
				if ((v103.LightningBolt:IsReady() and v48 and ((v103.FlameShockDebuff:AuraActiveCount() >= v118) or (v103.FlameShockDebuff:AuraActiveCount() >= (6 + 0))) and v14:BuffUp(v103.PrimordialWaveBuff) and (v111 == v112) and (v14:BuffDown(v103.SplinteredElementsBuff) or (v123 <= (701 - (586 + 103))))) or ((346 + 3447) < (7293 - 4924))) then
					if (v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt)) or ((5572 - (1309 + 179)) == (478 - 213))) then
						return "lightning_bolt aoe 2";
					end
				end
				if (((1897 + 2461) == (11703 - 7345)) and v103.LavaLash:IsReady() and v47 and v103.MoltenAssault:IsAvailable() and (v103.PrimordialWave:IsAvailable() or v103.FireNova:IsAvailable()) and v15:DebuffUp(v103.FlameShockDebuff) and (v103.FlameShockDebuff:AuraActiveCount() < v118) and (v103.FlameShockDebuff:AuraActiveCount() < (5 + 1))) then
					if (v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash)) or ((6666 - 3528) < (1978 - 985))) then
						return "lava_lash aoe 3";
					end
				end
				if (((3939 - (295 + 314)) > (5705 - 3382)) and v103.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v123) and (v14:BuffDown(v103.PrimordialWaveBuff))) then
					if (v124.CastCycle(v103.PrimordialWave, v117, v131, not v15:IsSpellInRange(v103.PrimordialWave)) or ((5588 - (1300 + 662)) == (12525 - 8536))) then
						return "primordial_wave aoe 4";
					end
					if (v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave)) or ((2671 - (1178 + 577)) == (1388 + 1283))) then
						return "primordial_wave aoe no_cycle 4";
					end
				end
				v167 = 2 - 1;
			end
			if (((1677 - (851 + 554)) == (241 + 31)) and (v167 == (2 - 1))) then
				if (((9227 - 4978) <= (5141 - (115 + 187))) and v103.FlameShock:IsReady() and v43 and (v103.PrimordialWave:IsAvailable() or v103.FireNova:IsAvailable()) and v15:DebuffDown(v103.FlameShockDebuff)) then
					if (((2127 + 650) < (3030 + 170)) and v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock))) then
						return "flame_shock aoe 5";
					end
				end
				if (((374 - 279) < (3118 - (160 + 1001))) and v103.ElementalBlast:IsReady() and v41 and (not v103.ElementalSpirits:IsAvailable() or (v103.ElementalSpirits:IsAvailable() and ((v103.ElementalBlast:Charges() == v120) or (v126.FeralSpiritCount >= (2 + 0))))) and (v14:BuffStack(v103.MaelstromWeaponBuff) == (4 + 1 + ((10 - 5) * v25(v103.OverflowingMaelstrom:IsAvailable())))) and (not v103.CrashingStorms:IsAvailable() or (v118 <= (361 - (237 + 121))))) then
					if (((1723 - (525 + 372)) < (3255 - 1538)) and v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast))) then
						return "elemental_blast aoe 6";
					end
				end
				if (((4685 - 3259) >= (1247 - (96 + 46))) and v103.ChainLightning:IsReady() and v39 and (v14:BuffStack(v103.MaelstromWeaponBuff) == ((782 - (643 + 134)) + ((2 + 3) * v25(v103.OverflowingMaelstrom:IsAvailable()))))) then
					if (((6603 - 3849) <= (12545 - 9166)) and v24(v103.ChainLightning, not v15:IsSpellInRange(v103.ChainLightning))) then
						return "chain_lightning aoe 7";
					end
				end
				if ((v103.CrashLightning:IsReady() and v40 and (v14:BuffUp(v103.DoomWindsBuff) or v14:BuffDown(v103.CrashLightningBuff) or (v103.AlphaWolf:IsAvailable() and v14:BuffUp(v103.FeralSpiritBuff) and (v130() == (0 + 0))))) or ((7706 - 3779) == (2888 - 1475))) then
					if (v24(v103.CrashLightning, not v15:IsInMeleeRange(727 - (316 + 403))) or ((768 + 386) <= (2166 - 1378))) then
						return "crash_lightning aoe 8";
					end
				end
				v167 = 1 + 1;
			end
		end
	end
	local function v144()
		local v168 = 0 - 0;
		while true do
			if ((v168 == (1 + 0)) or ((530 + 1113) > (11707 - 8328))) then
				if (((not v108 or (v110 < (2865509 - 2265509))) and v54 and v103.FlametongueWeapon:IsCastable()) or ((5822 - 3019) > (261 + 4288))) then
					if (v24(v103.FlametongueWeapon) or ((433 - 213) >= (148 + 2874))) then
						return "flametongue_weapon enchant";
					end
				end
				if (((8302 - 5480) == (2839 - (12 + 5))) and v86) then
					local v246 = 0 - 0;
					while true do
						if ((v246 == (0 - 0)) or ((2255 - 1194) == (4604 - 2747))) then
							v33 = v138();
							if (((561 + 2199) > (3337 - (1656 + 317))) and v33) then
								return v33;
							end
							break;
						end
					end
				end
				v168 = 2 + 0;
			end
			if (((0 + 0) == v168) or ((13034 - 8132) <= (17692 - 14097))) then
				if ((v76 and v103.EarthShield:IsCastable() and v14:BuffDown(v103.EarthShieldBuff) and ((v77 == "Earth Shield") or (v103.ElementalOrbit:IsAvailable() and v14:BuffUp(v103.LightningShield)))) or ((4206 - (5 + 349)) == (1391 - 1098))) then
					if (v24(v103.EarthShield) or ((2830 - (266 + 1005)) == (3024 + 1564))) then
						return "earth_shield main 2";
					end
				elseif ((v76 and v103.LightningShield:IsCastable() and v14:BuffDown(v103.LightningShieldBuff) and ((v77 == "Lightning Shield") or (v103.ElementalOrbit:IsAvailable() and v14:BuffUp(v103.EarthShield)))) or ((15299 - 10815) == (1036 - 248))) then
					if (((6264 - (561 + 1135)) >= (5091 - 1184)) and v24(v103.LightningShield)) then
						return "lightning_shield main 2";
					end
				end
				if (((4095 - 2849) < (4536 - (507 + 559))) and (not v107 or (v109 < (1505595 - 905595))) and v54 and v103.WindfuryWeapon:IsCastable()) then
					if (((12580 - 8512) >= (1360 - (212 + 176))) and v24(v103.WindfuryWeapon)) then
						return "windfury_weapon enchant";
					end
				end
				v168 = 906 - (250 + 655);
			end
			if (((1344 - 851) < (6802 - 2909)) and ((2 - 0) == v168)) then
				if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) or ((3429 - (1869 + 87)) >= (11556 - 8224))) then
					if (v24(v103.AncestralSpirit, nil, true) or ((5952 - (484 + 1417)) <= (2479 - 1322))) then
						return "resurrection";
					end
				end
				if (((1012 - 408) < (3654 - (48 + 725))) and v124.TargetIsValid() and v34) then
					if (not v14:AffectingCombat() or ((1470 - 570) == (9060 - 5683))) then
						local v249 = 0 + 0;
						while true do
							if (((11916 - 7457) > (166 + 425)) and (v249 == (0 + 0))) then
								v33 = v141();
								if (((4251 - (152 + 701)) >= (3706 - (430 + 881))) and v33) then
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
	local function v145()
		v33 = v139();
		if (v33 or ((837 + 1346) >= (3719 - (557 + 338)))) then
			return v33;
		end
		if (((573 + 1363) == (5455 - 3519)) and v94) then
			local v215 = 0 - 0;
			while true do
				if ((v215 == (0 - 0)) or ((10413 - 5581) < (5114 - (499 + 302)))) then
					if (((4954 - (39 + 827)) > (10694 - 6820)) and v88) then
						local v250 = 0 - 0;
						while true do
							if (((17205 - 12873) == (6650 - 2318)) and (v250 == (0 + 0))) then
								v33 = v124.HandleAfflicted(v103.CleanseSpirit, v105.CleanseSpiritMouseover, 117 - 77);
								if (((640 + 3359) >= (4588 - 1688)) and v33) then
									return v33;
								end
								break;
							end
						end
					end
					if (v89 or ((2629 - (103 + 1)) > (4618 - (475 + 79)))) then
						local v251 = 0 - 0;
						while true do
							if (((13987 - 9616) == (565 + 3806)) and (v251 == (0 + 0))) then
								v33 = v124.HandleAfflicted(v103.TremorTotem, v103.TremorTotem, 1533 - (1395 + 108));
								if (v33 or ((773 - 507) > (6190 - (7 + 1197)))) then
									return v33;
								end
								break;
							end
						end
					end
					v215 = 1 + 0;
				end
				if (((695 + 1296) >= (1244 - (27 + 292))) and (v215 == (2 - 1))) then
					if (((580 - 125) < (8609 - 6556)) and v90) then
						local v252 = 0 - 0;
						while true do
							if ((v252 == (0 - 0)) or ((965 - (43 + 96)) == (19787 - 14936))) then
								v33 = v124.HandleAfflicted(v103.PoisonCleansingTotem, v103.PoisonCleansingTotem, 67 - 37);
								if (((152 + 31) == (52 + 131)) and v33) then
									return v33;
								end
								break;
							end
						end
					end
					if (((2290 - 1131) <= (686 + 1102)) and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (9 - 4)) and v91) then
						v33 = v124.HandleAfflicted(v103.HealingSurge, v105.HealingSurgeMouseover, 13 + 27, true);
						if (v33 or ((258 + 3249) > (6069 - (1414 + 337)))) then
							return v33;
						end
					end
					break;
				end
			end
		end
		if (v95 or ((5015 - (1642 + 298)) <= (7729 - 4764))) then
			local v216 = 0 - 0;
			while true do
				if (((4050 - 2685) <= (662 + 1349)) and ((0 + 0) == v216)) then
					v33 = v124.HandleIncorporeal(v103.Hex, v105.HexMouseOver, 1002 - (357 + 615), true);
					if (v33 or ((1949 + 827) > (8771 - 5196))) then
						return v33;
					end
					break;
				end
			end
		end
		if (v93 or ((2189 + 365) == (10294 - 5490))) then
			if (((2062 + 515) == (176 + 2401)) and v16) then
				local v242 = 0 + 0;
				while true do
					if ((v242 == (1301 - (384 + 917))) or ((703 - (128 + 569)) >= (3432 - (1407 + 136)))) then
						v33 = v136();
						if (((2393 - (687 + 1200)) <= (3602 - (556 + 1154))) and v33) then
							return v33;
						end
						break;
					end
				end
			end
			if ((v17 and v17:Exists() and not v14:CanAttack(v17) and (v124.UnitHasDispellableDebuffByPlayer(v17) or v124.UnitHasCurseDebuff(v17))) or ((7064 - 5056) > (2313 - (9 + 86)))) then
				if (((800 - (275 + 146)) <= (675 + 3472)) and v103.CleanseSpirit:IsCastable()) then
					if (v24(v105.CleanseSpiritMouseover, not v17:IsSpellInRange(v103.PurifySpirit)) or ((4578 - (29 + 35)) <= (4471 - 3462))) then
						return "purify_spirit dispel mouseover";
					end
				end
			end
		end
		if ((v103.GreaterPurge:IsAvailable() and v101 and v103.GreaterPurge:IsReady() and v38 and v92 and not v14:IsCasting() and not v14:IsChanneling() and v124.UnitHasMagicBuff(v15)) or ((10442 - 6946) == (5262 - 4070))) then
			if (v24(v103.GreaterPurge, not v15:IsSpellInRange(v103.GreaterPurge)) or ((136 + 72) == (3971 - (53 + 959)))) then
				return "greater_purge damage";
			end
		end
		if (((4685 - (312 + 96)) >= (2278 - 965)) and v103.Purge:IsReady() and v101 and v38 and v92 and not v14:IsCasting() and not v14:IsChanneling() and v124.UnitHasMagicBuff(v15)) then
			if (((2872 - (147 + 138)) < (4073 - (813 + 86))) and v24(v103.Purge, not v15:IsSpellInRange(v103.Purge))) then
				return "purge damage";
			end
		end
		v33 = v137();
		if (v33 or ((3724 + 396) <= (4072 - 1874))) then
			return v33;
		end
		if (v124.TargetIsValid() or ((2088 - (18 + 474)) == (290 + 568))) then
			local v217 = v124.HandleDPSPotion(v14:BuffUp(v103.FeralSpiritBuff));
			if (((10509 - 7289) == (4306 - (860 + 226))) and v217) then
				return v217;
			end
			if ((v100 < v123) or ((1705 - (121 + 182)) > (446 + 3174))) then
				if (((3814 - (988 + 252)) == (291 + 2283)) and v58 and ((v36 and v65) or not v65)) then
					v33 = v140();
					if (((564 + 1234) < (4727 - (49 + 1921))) and v33) then
						return v33;
					end
				end
			end
			if (((v100 < v123) and v59 and ((v66 and v36) or not v66)) or ((1267 - (223 + 667)) > (2656 - (51 + 1)))) then
				if (((977 - 409) < (1950 - 1039)) and v103.BloodFury:IsCastable() and (not v103.Ascendance:IsAvailable() or v14:BuffUp(v103.AscendanceBuff) or (v103.Ascendance:CooldownRemains() > (1175 - (146 + 979))))) then
					if (((928 + 2357) < (4833 - (311 + 294))) and v24(v103.BloodFury)) then
						return "blood_fury racial";
					end
				end
				if (((10920 - 7004) > (1410 + 1918)) and v103.Berserking:IsCastable() and (not v103.Ascendance:IsAvailable() or v14:BuffUp(v103.AscendanceBuff))) then
					if (((3943 - (496 + 947)) < (5197 - (1233 + 125))) and v24(v103.Berserking)) then
						return "berserking racial";
					end
				end
				if (((206 + 301) == (455 + 52)) and v103.Fireblood:IsCastable() and (not v103.Ascendance:IsAvailable() or v14:BuffUp(v103.AscendanceBuff) or (v103.Ascendance:CooldownRemains() > (10 + 40)))) then
					if (((1885 - (963 + 682)) <= (2642 + 523)) and v24(v103.Fireblood)) then
						return "fireblood racial";
					end
				end
				if (((2338 - (504 + 1000)) >= (543 + 262)) and v103.AncestralCall:IsCastable() and (not v103.Ascendance:IsAvailable() or v14:BuffUp(v103.AscendanceBuff) or (v103.Ascendance:CooldownRemains() > (46 + 4)))) then
					if (v24(v103.AncestralCall) or ((360 + 3452) < (3414 - 1098))) then
						return "ancestral_call racial";
					end
				end
			end
			if ((v103.TotemicProjection:IsCastable() and (v103.WindfuryTotem:TimeSinceLastCast() < (77 + 13)) and v14:BuffDown(v103.WindfuryTotemBuff, true)) or ((1543 + 1109) <= (1715 - (156 + 26)))) then
				if (v24(v105.TotemicProjectionPlayer) or ((2073 + 1525) < (2284 - 824))) then
					return "totemic_projection wind_fury main 0";
				end
			end
			if ((v103.Windstrike:IsCastable() and v53) or ((4280 - (149 + 15)) < (2152 - (890 + 70)))) then
				if (v24(v103.Windstrike, not v15:IsSpellInRange(v103.Windstrike)) or ((3494 - (39 + 78)) <= (1385 - (14 + 468)))) then
					return "windstrike main 1";
				end
			end
			if (((8743 - 4767) >= (1226 - 787)) and v103.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v123) and (v14:HasTier(16 + 15, 2 + 0))) then
				if (((798 + 2954) == (1695 + 2057)) and v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave))) then
					return "primordial_wave main 2";
				end
			end
			if (((1060 + 2986) > (5158 - 2463)) and v103.FeralSpirit:IsCastable() and v56 and ((v61 and v36) or not v61) and (v100 < v123)) then
				if (v24(v103.FeralSpirit) or ((3504 + 41) == (11234 - 8037))) then
					return "feral_spirit main 3";
				end
			end
			if (((61 + 2333) > (424 - (12 + 39))) and v103.Ascendance:IsCastable() and v55 and ((v60 and v36) or not v60) and (v100 < v123) and v15:DebuffUp(v103.FlameShockDebuff) and (((v121 == "Lightning Bolt") and (v118 == (1 + 0))) or ((v121 == "Chain Lightning") and (v118 > (2 - 1))))) then
				if (((14798 - 10643) <= (1255 + 2977)) and v24(v103.Ascendance)) then
					return "ascendance main 4";
				end
			end
			if ((v103.DoomWinds:IsCastable() and v57 and ((v62 and v36) or not v62) and (v100 < v123)) or ((1885 + 1696) == (8806 - 5333))) then
				if (((3327 + 1668) > (16180 - 12832)) and v24(v103.DoomWinds, not v15:IsInMeleeRange(1715 - (1596 + 114)))) then
					return "doom_winds main 5";
				end
			end
			if ((v118 == (2 - 1)) or ((1467 - (164 + 549)) > (5162 - (1059 + 379)))) then
				v33 = v142();
				if (((269 - 52) >= (30 + 27)) and v33) then
					return v33;
				end
			end
			if ((v35 and (v118 > (1 + 0))) or ((2462 - (145 + 247)) >= (3313 + 724))) then
				local v243 = 0 + 0;
				while true do
					if (((8019 - 5314) == (519 + 2186)) and (v243 == (0 + 0))) then
						v33 = v143();
						if (((98 - 37) == (781 - (254 + 466))) and v33) then
							return v33;
						end
						break;
					end
				end
			end
		end
	end
	local function v146()
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
	local function v147()
		local v194 = 560 - (544 + 16);
		while true do
			if ((v194 == (18 - 12)) or ((1327 - (294 + 334)) >= (1549 - (236 + 17)))) then
				v88 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v89 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v90 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				v194 = 4 + 3;
			end
			if ((v194 == (4 + 1)) or ((6714 - 4931) >= (17119 - 13503))) then
				v86 = EpicSettings.Settings['healOOC'];
				v87 = EpicSettings.Settings['healOOCHP'] or (0 + 0);
				v101 = EpicSettings.Settings['usePurgeTarget'];
				v194 = 5 + 1;
			end
			if (((801 - (413 + 381)) == v194) or ((165 + 3748) > (9628 - 5101))) then
				v91 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
				break;
			end
			if (((11367 - 6991) > (2787 - (582 + 1388))) and (v194 == (2 - 0))) then
				v72 = EpicSettings.Settings['useHealingStreamTotem'];
				v79 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 + 0);
				v80 = EpicSettings.Settings['ancestralGuidanceGroup'] or (364 - (326 + 38));
				v194 = 8 - 5;
			end
			if (((6939 - 2078) > (1444 - (47 + 573))) and (v194 == (1 + 0))) then
				v71 = EpicSettings.Settings['useAncestralGuidance'];
				v70 = EpicSettings.Settings['useAstralShift'];
				v73 = EpicSettings.Settings['useMaelstromHealingSurge'];
				v194 = 8 - 6;
			end
			if ((v194 == (5 - 1)) or ((3047 - (1269 + 395)) >= (2623 - (76 + 416)))) then
				v83 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (443 - (319 + 124));
				v76 = EpicSettings.Settings['autoShield'];
				v77 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v194 = 11 - 6;
			end
			if (((1007 - (564 + 443)) == v194) or ((5193 - 3317) >= (2999 - (337 + 121)))) then
				v67 = EpicSettings.Settings['useWindShear'];
				v68 = EpicSettings.Settings['useCapacitorTotem'];
				v69 = EpicSettings.Settings['useThunderstorm'];
				v194 = 2 - 1;
			end
			if (((5935 - 4153) <= (5683 - (1261 + 650))) and (v194 == (2 + 1))) then
				v78 = EpicSettings.Settings['astralShiftHP'] or (0 - 0);
				v81 = EpicSettings.Settings['healingStreamTotemHP'] or (1817 - (772 + 1045));
				v82 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
				v194 = 148 - (102 + 42);
			end
		end
	end
	local function v148()
		v100 = EpicSettings.Settings['fightRemainsCheck'] or (1844 - (1524 + 320));
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
		v84 = EpicSettings.Settings['healthstoneHP'] or (1270 - (1049 + 221));
		v85 = EpicSettings.Settings['healingPotionHP'] or (156 - (18 + 138));
		v96 = EpicSettings.Settings['HealingPotionName'] or "";
		v94 = EpicSettings.Settings['handleAfflicted'];
		v95 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v149()
		local v208 = 0 - 0;
		while true do
			if ((v208 == (1104 - (67 + 1035))) or ((5048 - (136 + 212)) < (3454 - 2641))) then
				v38 = EpicSettings.Toggles['dispel'];
				v37 = EpicSettings.Toggles['minicds'];
				if (((2563 + 636) < (3734 + 316)) and v14:IsDeadOrGhost()) then
					return v33;
				end
				v208 = 1607 - (240 + 1364);
			end
			if ((v208 == (1085 - (1050 + 32))) or ((17677 - 12726) < (2621 + 1809))) then
				v107, v109, _, _, v108, v110 = v27();
				v116 = v14:GetEnemiesInRange(1095 - (331 + 724));
				v117 = v14:GetEnemiesInMeleeRange(1 + 9);
				v208 = 648 - (269 + 375);
			end
			if (((821 - (267 + 458)) == (30 + 66)) and (v208 == (0 - 0))) then
				v147();
				v146();
				v148();
				v208 = 819 - (667 + 151);
			end
			if ((v208 == (1501 - (1410 + 87))) or ((4636 - (1504 + 393)) > (10833 - 6825))) then
				if (v35 or ((59 - 36) == (1930 - (461 + 335)))) then
					v119 = v128(6 + 34);
					v118 = #v117;
				else
					local v247 = 1761 - (1730 + 31);
					while true do
						if ((v247 == (1667 - (728 + 939))) or ((9537 - 6844) >= (8338 - 4227))) then
							v119 = 2 - 1;
							v118 = 1069 - (138 + 930);
							break;
						end
					end
				end
				if ((v38 and v93) or ((3945 + 371) <= (1678 + 468))) then
					if ((v14:AffectingCombat() and v103.CleanseSpirit:IsAvailable()) or ((3040 + 506) <= (11469 - 8660))) then
						local v253 = v93 and v103.CleanseSpirit:IsReady() and v38;
						v33 = v124.FocusUnit(v253, nil, 1786 - (459 + 1307), nil, 1895 - (474 + 1396), v103.HealingSurge);
						if (((8563 - 3659) > (2030 + 136)) and v33) then
							return v33;
						end
					end
				end
				if (((1 + 108) >= (257 - 167)) and (v124.TargetIsValid() or v14:AffectingCombat())) then
					v122 = v10.BossFightRemains(nil, true);
					v123 = v122;
					if (((631 + 4347) > (9697 - 6792)) and (v123 == (48456 - 37345))) then
						v123 = v10.FightRemains(v117, false);
					end
				end
				v208 = 596 - (562 + 29);
			end
			if ((v208 == (5 + 0)) or ((4445 - (374 + 1045)) <= (1805 + 475))) then
				if (v14:AffectingCombat() or ((5132 - 3479) <= (1746 - (448 + 190)))) then
					if (((940 + 1969) > (1178 + 1431)) and v14:PrevGCD(1 + 0, v103.ChainLightning)) then
						v121 = "Chain Lightning";
					elseif (((2910 - 2153) > (602 - 408)) and v14:PrevGCD(1495 - (1307 + 187), v103.LightningBolt)) then
						v121 = "Lightning Bolt";
					end
				end
				if ((not v14:IsChanneling() and not v14:IsChanneling()) or ((122 - 91) >= (3272 - 1874))) then
					local v248 = 0 - 0;
					while true do
						if (((3879 - (232 + 451)) <= (4653 + 219)) and (v248 == (0 + 0))) then
							if (((3890 - (510 + 54)) == (6701 - 3375)) and v94) then
								if (((1469 - (13 + 23)) <= (7559 - 3681)) and v88) then
									local v255 = 0 - 0;
									while true do
										if ((v255 == (0 - 0)) or ((2671 - (830 + 258)) == (6120 - 4385))) then
											v33 = v124.HandleAfflicted(v103.CleanseSpirit, v105.CleanseSpiritMouseover, 26 + 14);
											if (v33 or ((2537 + 444) == (3791 - (860 + 581)))) then
												return v33;
											end
											break;
										end
									end
								end
								if (v89 or ((16473 - 12007) <= (392 + 101))) then
									local v256 = 241 - (237 + 4);
									while true do
										if ((v256 == (0 - 0)) or ((6444 - 3897) <= (3766 - 1779))) then
											v33 = v124.HandleAfflicted(v103.TremorTotem, v103.TremorTotem, 25 + 5);
											if (((1701 + 1260) > (10344 - 7604)) and v33) then
												return v33;
											end
											break;
										end
									end
								end
								if (((1586 + 2110) >= (1965 + 1647)) and v90) then
									local v257 = 1426 - (85 + 1341);
									while true do
										if ((v257 == (0 - 0)) or ((8387 - 5417) == (2250 - (45 + 327)))) then
											v33 = v124.HandleAfflicted(v103.PoisonCleansingTotem, v103.PoisonCleansingTotem, 56 - 26);
											if (v33 or ((4195 - (444 + 58)) < (860 + 1117))) then
												return v33;
											end
											break;
										end
									end
								end
								if (((v14:BuffStack(v103.MaelstromWeaponBuff) >= (1 + 4)) and v91) or ((455 + 475) > (6088 - 3987))) then
									local v258 = 1732 - (64 + 1668);
									while true do
										if (((6126 - (1227 + 746)) > (9485 - 6399)) and (v258 == (0 - 0))) then
											v33 = v124.HandleAfflicted(v103.HealingSurge, v105.HealingSurgeMouseover, 534 - (415 + 79), true);
											if (v33 or ((120 + 4534) <= (4541 - (142 + 349)))) then
												return v33;
											end
											break;
										end
									end
								end
							end
							if (v14:AffectingCombat() or ((1115 + 1487) < (2056 - 560))) then
								local v254 = 0 + 0;
								while true do
									if ((v254 == (0 + 0)) or ((2777 - 1757) > (4152 - (1710 + 154)))) then
										v33 = v145();
										if (((646 - (200 + 118)) == (130 + 198)) and v33) then
											return v33;
										end
										break;
									end
								end
							else
								v33 = v144();
								if (((2641 - 1130) < (5647 - 1839)) and v33) then
									return v33;
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v208 == (1 + 0)) or ((2483 + 27) > (2640 + 2279))) then
				v34 = EpicSettings.Toggles['ooc'];
				v35 = EpicSettings.Toggles['aoe'];
				v36 = EpicSettings.Toggles['cds'];
				v208 = 1 + 1;
			end
		end
	end
	local function v150()
		v103.FlameShockDebuff:RegisterAuraTracking();
		v129();
		v21.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(569 - 306, v149, v150);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

