local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((1748 - (134 + 185)) < (1181 - (549 + 584)))) then
			return v6(...);
		end
		if ((v5 == (685 - (314 + 371))) or ((8554 - 6062) < (1303 - (478 + 490)))) then
			v6 = v0[v4];
			if (((2290 + 2032) >= (3734 - (786 + 386))) and not v6) then
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
	local v102;
	local v103 = v18.Shaman.Enhancement;
	local v104 = v20.Shaman.Enhancement;
	local v105 = v23.Shaman.Enhancement;
	local v106 = {};
	local v107, v108;
	local v109, v110;
	local v111;
	local v112 = 1389 - (1055 + 324);
	local v113 = 1348 - (1093 + 247);
	local v114 = 6 + 0;
	local v115 = 106 + 894;
	local v116, v117, v118, v119;
	local v120 = (v103.LavaBurst:IsAvailable() and (7 - 5)) or (3 - 2);
	local v121 = "Lightning Bolt";
	local v122 = 31616 - 20505;
	local v123 = 27920 - 16809;
	local v124 = v21.Commons.Everyone;
	v21.Commons.Shaman = {};
	local v126 = v21.Commons.Shaman;
	v126.FeralSpiritCount = 0 + 0;
	v10:RegisterForEvent(function()
		v120 = (v103.LavaBurst:IsAvailable() and (7 - 5)) or (3 - 2);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		local v151 = 0 + 0;
		while true do
			if ((v151 == (0 - 0)) or ((4325 - (364 + 324)) >= (10334 - 6564))) then
				v121 = "Lightning Bolt";
				v122 = 26662 - 15551;
				v151 = 1 + 0;
			end
			if ((v151 == (4 - 3)) or ((3809 - 1430) > (13903 - 9325))) then
				v123 = 12379 - (1249 + 19);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v128(v152)
		local v153 = 0 + 0;
		local v154;
		local v155;
		while true do
			if ((v153 == (0 - 0)) or ((1569 - (686 + 400)) > (583 + 160))) then
				v154 = v14:GetEnemiesInRange(v152);
				v155 = 230 - (73 + 156);
				v153 = 1 + 0;
			end
			if (((3265 - (721 + 90)) > (7 + 571)) and (v153 == (3 - 2))) then
				for v236, v237 in pairs(v154) do
					if (((1400 - (224 + 246)) < (7221 - 2763)) and (v237:GUID() ~= v15:GUID()) and (v237:AffectingCombat() or v237:IsDummy())) then
						v155 = v155 + (1 - 0);
					end
				end
				return v155;
			end
		end
	end
	v10:RegisterForSelfCombatEvent(function(...)
		local v156 = 0 + 0;
		local v157;
		local v158;
		local v159;
		while true do
			if (((16 + 646) <= (714 + 258)) and (v156 == (0 - 0))) then
				v157, v158, v158, v158, v158, v158, v158, v158, v159 = select(12 - 8, ...);
				if (((4883 - (203 + 310)) == (6363 - (1238 + 755))) and (v157 == v14:GUID()) and (v159 == (13389 + 178245))) then
					v126.LastSKCast = v31();
				end
				v156 = 1535 - (709 + 825);
			end
			if ((v156 == (1 - 0)) or ((6936 - 2174) <= (1725 - (196 + 668)))) then
				if ((v14:HasTier(122 - 91, 3 - 1) and (v157 == v14:GUID()) and (v159 == (376815 - (171 + 662)))) or ((1505 - (4 + 89)) == (14945 - 10681))) then
					v126.FeralSpiritCount = v126.FeralSpiritCount + 1 + 0;
					v32.After(65 - 50, function()
						v126.FeralSpiritCount = v126.FeralSpiritCount - (1 + 0);
					end);
				end
				if (((v157 == v14:GUID()) and (v159 == (53019 - (35 + 1451)))) or ((4621 - (28 + 1425)) < (4146 - (941 + 1052)))) then
					v126.FeralSpiritCount = v126.FeralSpiritCount + 2 + 0;
					v32.After(1529 - (822 + 692), function()
						v126.FeralSpiritCount = v126.FeralSpiritCount - (2 - 0);
					end);
				end
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	local function v129()
		if (v103.CleanseSpirit:IsAvailable() or ((2344 + 2632) < (1629 - (45 + 252)))) then
			v124.DispellableDebuffs = v124.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v129();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v130()
		local v160 = 0 + 0;
		local v161;
		while true do
			if (((1593 + 3035) == (11263 - 6635)) and (v160 == (434 - (114 + 319)))) then
				if ((v161 > (11 - 3)) or (v161 > v103.FeralSpirit:TimeSinceLastCast()) or ((68 - 14) == (252 + 143))) then
					return 0 - 0;
				end
				return (16 - 8) - v161;
			end
			if (((2045 - (556 + 1407)) == (1288 - (741 + 465))) and (v160 == (465 - (170 + 295)))) then
				if (not v103.AlphaWolf:IsAvailable() or v14:BuffDown(v103.FeralSpiritBuff) or ((307 + 274) < (260 + 22))) then
					return 0 - 0;
				end
				v161 = v29(v103.CrashLightning:TimeSinceLastCast(), v103.ChainLightning:TimeSinceLastCast());
				v160 = 1 + 0;
			end
		end
	end
	local function v131(v162)
		return (v162:DebuffRefreshable(v103.FlameShockDebuff));
	end
	local function v132(v163)
		return v163:DebuffRemains(v103.FlameShockDebuff);
	end
	local function v133(v164)
		return v14:BuffDown(v103.PrimordialWaveBuff);
	end
	local function v134(v165)
		return v165:DebuffRemains(v103.LashingFlamesDebuff);
	end
	local v135 = 0 + 0;
	local function v136()
		if ((v103.CleanseSpirit:IsReady() and v38 and (v124.UnitHasDispellableDebuffByPlayer(v16) or v124.DispellableFriendlyUnit(15 + 10) or v124.UnitHasCurseDebuff(v16))) or ((5839 - (957 + 273)) < (668 + 1827))) then
			local v191 = 0 + 0;
			while true do
				if (((4389 - 3237) == (3035 - 1883)) and (v191 == (0 - 0))) then
					if (((9388 - 7492) <= (5202 - (389 + 1391))) and (v135 == (0 + 0))) then
						v135 = v31();
					end
					if (v124.Wait(53 + 447, v135) or ((2253 - 1263) > (2571 - (783 + 168)))) then
						local v254 = 0 - 0;
						while true do
							if (((0 + 0) == v254) or ((1188 - (309 + 2)) > (14417 - 9722))) then
								if (((3903 - (1090 + 122)) >= (601 + 1250)) and v24(v105.CleanseSpiritFocus)) then
									return "cleanse_spirit dispel";
								end
								v135 = 0 - 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v137()
		if (not v16 or not v16:Exists() or not v16:IsInRange(28 + 12) or ((4103 - (628 + 490)) >= (871 + 3985))) then
			return;
		end
		if (((10586 - 6310) >= (5461 - 4266)) and v16) then
			if (((4006 - (431 + 343)) <= (9471 - 4781)) and (v16:HealthPercentage() <= v83) and v73 and v103.HealingSurge:IsReady() and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (14 - 9))) then
				if (v24(v105.HealingSurgeFocus) or ((708 + 188) >= (403 + 2743))) then
					return "healing_surge heal focus";
				end
			end
		end
	end
	local function v138()
		if (((4756 - (556 + 1139)) >= (2973 - (6 + 9))) and (v14:HealthPercentage() <= v87)) then
			if (((584 + 2603) >= (330 + 314)) and v103.HealingSurge:IsReady()) then
				if (((813 - (28 + 141)) <= (273 + 431)) and v24(v103.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v139()
		local v166 = 0 - 0;
		while true do
			if (((679 + 279) > (2264 - (486 + 831))) and (v166 == (5 - 3))) then
				if (((15814 - 11322) >= (502 + 2152)) and v104.Healthstone:IsReady() and v74 and (v14:HealthPercentage() <= v84)) then
					if (((10883 - 7441) >= (2766 - (668 + 595))) and v24(v105.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if ((v75 and (v14:HealthPercentage() <= v85)) or ((2853 + 317) <= (296 + 1168))) then
					local v241 = 0 - 0;
					while true do
						if ((v241 == (290 - (23 + 267))) or ((6741 - (1129 + 815)) == (4775 - (371 + 16)))) then
							if (((2301 - (1326 + 424)) <= (1289 - 608)) and (v96 == "Refreshing Healing Potion")) then
								if (((11974 - 8697) > (525 - (88 + 30))) and v104.RefreshingHealingPotion:IsReady()) then
									if (((5466 - (720 + 51)) >= (3147 - 1732)) and v24(v105.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v96 == "Dreamwalker's Healing Potion") or ((4988 - (421 + 1355)) <= (1556 - 612))) then
								if (v104.DreamwalkersHealingPotion:IsReady() or ((1521 + 1575) <= (2881 - (286 + 797)))) then
									if (((12929 - 9392) == (5858 - 2321)) and v24(v105.RefreshingHealingPotion)) then
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
			if (((4276 - (397 + 42)) >= (491 + 1079)) and (v166 == (801 - (24 + 776)))) then
				if ((v103.HealingStreamTotem:IsReady() and v72 and v124.AreUnitsBelowHealthPercentage(v81, v82, v103.HealingSurge)) or ((4544 - 1594) == (4597 - (222 + 563)))) then
					if (((10406 - 5683) >= (1669 + 649)) and v24(v103.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v103.HealingSurge:IsReady() and v73 and (v14:HealthPercentage() <= v83) and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (195 - (23 + 167)))) or ((3825 - (690 + 1108)) > (1029 + 1823))) then
					if (v24(v103.HealingSurge) or ((938 + 198) > (5165 - (40 + 808)))) then
						return "healing_surge defensive 4";
					end
				end
				v166 = 1 + 1;
			end
			if (((18156 - 13408) == (4539 + 209)) and (v166 == (0 + 0))) then
				if (((2049 + 1687) <= (5311 - (47 + 524))) and v103.AstralShift:IsReady() and v70 and (v14:HealthPercentage() <= v78)) then
					if (v24(v103.AstralShift) or ((2200 + 1190) <= (8364 - 5304))) then
						return "astral_shift defensive 1";
					end
				end
				if ((v103.AncestralGuidance:IsReady() and v71 and v124.AreUnitsBelowHealthPercentage(v79, v80, v103.HealingSurge)) or ((1493 - 494) > (6141 - 3448))) then
					if (((2189 - (1165 + 561)) < (18 + 583)) and v24(v103.AncestralGuidance)) then
						return "ancestral_guidance defensive 2";
					end
				end
				v166 = 3 - 2;
			end
		end
	end
	local function v140()
		local v167 = 0 + 0;
		while true do
			if (((480 - (341 + 138)) == v167) or ((590 + 1593) < (1417 - 730))) then
				v33 = v124.HandleBottomTrinket(v106, v36, 366 - (89 + 237), nil);
				if (((14633 - 10084) == (9576 - 5027)) and v33) then
					return v33;
				end
				break;
			end
			if (((5553 - (581 + 300)) == (5892 - (855 + 365))) and ((0 - 0) == v167)) then
				v33 = v124.HandleTopTrinket(v106, v36, 14 + 26, nil);
				if (v33 or ((4903 - (1030 + 205)) < (371 + 24))) then
					return v33;
				end
				v167 = 1 + 0;
			end
		end
	end
	local function v141()
		local v168 = 286 - (156 + 130);
		while true do
			if ((v168 == (2 - 1)) or ((7021 - 2855) == (931 - 476))) then
				if ((v103.FeralSpirit:IsCastable() and v56 and ((v61 and v36) or not v61)) or ((1173 + 3276) == (1553 + 1110))) then
					if (v24(v103.FeralSpirit) or ((4346 - (10 + 59)) < (846 + 2143))) then
						return "feral_spirit precombat 6";
					end
				end
				if ((v103.FlameShock:IsReady() and v43) or ((4284 - 3414) >= (5312 - (671 + 492)))) then
					if (((1761 + 451) < (4398 - (369 + 846))) and v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock))) then
						return "flame_shock precombat 8";
					end
				end
				break;
			end
			if (((1230 + 3416) > (2554 + 438)) and (v168 == (1945 - (1036 + 909)))) then
				if (((1141 + 293) < (5214 - 2108)) and v103.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v103.WindfuryTotemBuff, true) or (v103.WindfuryTotem:TimeSinceLastCast() > (293 - (11 + 192))))) then
					if (((398 + 388) < (3198 - (135 + 40))) and v24(v103.WindfuryTotem)) then
						return "windfury_totem precombat 2";
					end
				end
				if ((v103.PrimordialWave:IsReady() and v49 and ((v64 and v37) or not v64)) or ((5916 - 3474) < (45 + 29))) then
					if (((9990 - 5455) == (6798 - 2263)) and v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave))) then
						return "primordial_wave precombat 4";
					end
				end
				v168 = 177 - (50 + 126);
			end
		end
	end
	local function v142()
		if ((v103.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v123) and v15:DebuffDown(v103.FlameShockDebuff) and v103.LashingFlames:IsAvailable()) or ((8378 - 5369) <= (466 + 1639))) then
			if (((3243 - (1233 + 180)) < (4638 - (522 + 447))) and v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave))) then
				return "primordial_wave single 1";
			end
		end
		if ((v103.FlameShock:IsReady() and v43 and v15:DebuffDown(v103.FlameShockDebuff) and v103.LashingFlames:IsAvailable()) or ((2851 - (107 + 1314)) >= (1677 + 1935))) then
			if (((8175 - 5492) >= (1045 + 1415)) and v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock))) then
				return "flame_shock single 2";
			end
		end
		if ((v103.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (9 - 4)) and v103.ElementalSpirits:IsAvailable() and (v126.FeralSpiritCount >= (15 - 11))) or ((3714 - (716 + 1194)) >= (56 + 3219))) then
			if (v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast)) or ((152 + 1265) > (4132 - (74 + 429)))) then
				return "elemental_blast single 3";
			end
		end
		if (((9250 - 4455) > (200 + 202)) and v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v123) and (v14:HasTier(68 - 38, 2 + 0))) then
			if (((14837 - 10024) > (8814 - 5249)) and v24(v103.Sundering, not v15:IsInRange(441 - (279 + 154)))) then
				return "sundering single 4";
			end
		end
		if (((4690 - (454 + 324)) == (3078 + 834)) and v103.LightningBolt:IsCastable() and v48 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (22 - (12 + 5))) and v14:BuffDown(v103.CracklingThunderBuff) and v14:BuffUp(v103.AscendanceBuff) and (v121 == "Chain Lightning") and (v14:BuffRemains(v103.AscendanceBuff) > (v103.ChainLightning:CooldownRemains() + v14:GCD()))) then
			if (((1521 + 1300) <= (12291 - 7467)) and v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt))) then
				return "lightning_bolt single 5";
			end
		end
		if (((643 + 1095) <= (3288 - (277 + 816))) and v103.Stormstrike:IsReady() and v50 and (v14:BuffUp(v103.DoomWindsBuff) or v103.DeeplyRootedElements:IsAvailable() or (v103.Stormblast:IsAvailable() and v14:BuffUp(v103.StormbringerBuff)))) then
			if (((175 - 134) <= (4201 - (1058 + 125))) and v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike))) then
				return "stormstrike single 6";
			end
		end
		if (((403 + 1742) <= (5079 - (815 + 160))) and v103.LavaLash:IsReady() and v47 and (v14:BuffUp(v103.HotHandBuff))) then
			if (((11537 - 8848) < (11501 - 6656)) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
				return "lava_lash single 7";
			end
		end
		if ((v103.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v103.WindfuryTotemBuff, true))) or ((554 + 1768) > (7664 - 5042))) then
			if (v24(v103.WindfuryTotem) or ((6432 - (41 + 1857)) == (3975 - (1222 + 671)))) then
				return "windfury_totem single 8";
			end
		end
		if ((v103.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (12 - 7)) and (v103.ElementalBlast:Charges() == v120)) or ((2257 - 686) > (3049 - (229 + 953)))) then
			if (v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast)) or ((4428 - (1111 + 663)) >= (4575 - (874 + 705)))) then
				return "elemental_blast single 9";
			end
		end
		if (((557 + 3421) > (1436 + 668)) and v103.LightningBolt:IsReady() and v48 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (16 - 8)) and v14:BuffUp(v103.PrimordialWaveBuff) and (v14:BuffDown(v103.SplinteredElementsBuff) or (v123 <= (1 + 11)))) then
			if (((3674 - (642 + 37)) > (352 + 1189)) and v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt))) then
				return "lightning_bolt single 10";
			end
		end
		if (((520 + 2729) > (2392 - 1439)) and v103.ChainLightning:IsReady() and v39 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (462 - (233 + 221))) and v14:BuffUp(v103.CracklingThunderBuff) and v103.ElementalSpirits:IsAvailable()) then
			if (v24(v103.ChainLightning, not v15:IsSpellInRange(v103.ChainLightning)) or ((7568 - 4295) > (4026 + 547))) then
				return "chain_lightning single 11";
			end
		end
		if ((v103.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (1549 - (718 + 823))) and ((v126.FeralSpiritCount >= (2 + 0)) or not v103.ElementalSpirits:IsAvailable())) or ((3956 - (266 + 539)) < (3635 - 2351))) then
			if (v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast)) or ((3075 - (636 + 589)) == (3629 - 2100))) then
				return "elemental_blast single 12";
			end
		end
		if (((1693 - 872) < (1683 + 440)) and v103.LavaBurst:IsReady() and v46 and not v103.ThorimsInvocation:IsAvailable() and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (2 + 3))) then
			if (((1917 - (657 + 358)) < (6156 - 3831)) and v24(v103.LavaBurst, not v15:IsSpellInRange(v103.LavaBurst))) then
				return "lava_burst single 13";
			end
		end
		if (((1954 - 1096) <= (4149 - (1151 + 36))) and v103.LightningBolt:IsReady() and v48 and ((v14:BuffStack(v103.MaelstromWeaponBuff) >= (8 + 0)) or (v103.StaticAccumulation:IsAvailable() and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (2 + 3)))) and v14:BuffDown(v103.PrimordialWaveBuff)) then
			if (v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt)) or ((11784 - 7838) < (3120 - (1552 + 280)))) then
				return "lightning_bolt single 14";
			end
		end
		if ((v103.CrashLightning:IsReady() and v40 and v103.AlphaWolf:IsAvailable() and v14:BuffUp(v103.FeralSpiritBuff) and (v130() == (834 - (64 + 770)))) or ((2202 + 1040) == (1286 - 719))) then
			if (v24(v103.CrashLightning, not v15:IsInMeleeRange(2 + 6)) or ((2090 - (157 + 1086)) >= (2527 - 1264))) then
				return "crash_lightning single 15";
			end
		end
		if ((v103.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v123)) or ((9867 - 7614) == (2839 - 988))) then
			if (v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave)) or ((2848 - 761) > (3191 - (599 + 220)))) then
				return "primordial_wave single 16";
			end
		end
		if ((v103.FlameShock:IsReady() and v43 and (v15:DebuffDown(v103.FlameShockDebuff))) or ((8851 - 4406) < (6080 - (1813 + 118)))) then
			if (v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock)) or ((1329 + 489) == (1302 - (841 + 376)))) then
				return "flame_shock single 17";
			end
		end
		if (((882 - 252) < (495 + 1632)) and v103.IceStrike:IsReady() and v45 and v103.ElementalAssault:IsAvailable() and v103.SwirlingMaelstrom:IsAvailable()) then
			if (v24(v103.IceStrike, not v15:IsInMeleeRange(13 - 8)) or ((2797 - (464 + 395)) == (6451 - 3937))) then
				return "ice_strike single 18";
			end
		end
		if (((2044 + 2211) >= (892 - (467 + 370))) and v103.LavaLash:IsReady() and v47 and (v103.LashingFlames:IsAvailable())) then
			if (((6196 - 3197) > (849 + 307)) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
				return "lava_lash single 19";
			end
		end
		if (((8055 - 5705) > (181 + 974)) and v103.IceStrike:IsReady() and v45 and (v14:BuffDown(v103.IceStrikeBuff))) then
			if (((9373 - 5344) <= (5373 - (150 + 370))) and v24(v103.IceStrike, not v15:IsInMeleeRange(1287 - (74 + 1208)))) then
				return "ice_strike single 20";
			end
		end
		if ((v103.FrostShock:IsReady() and v44 and (v14:BuffUp(v103.HailstormBuff))) or ((1268 - 752) > (16286 - 12852))) then
			if (((2879 + 1167) >= (3423 - (14 + 376))) and v24(v103.FrostShock, not v15:IsSpellInRange(v103.FrostShock))) then
				return "frost_shock single 21";
			end
		end
		if ((v103.LavaLash:IsReady() and v47) or ((4715 - 1996) <= (937 + 510))) then
			if (v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash)) or ((3632 + 502) < (3745 + 181))) then
				return "lava_lash single 22";
			end
		end
		if ((v103.IceStrike:IsReady() and v45) or ((480 - 316) >= (2096 + 689))) then
			if (v24(v103.IceStrike, not v15:IsInMeleeRange(83 - (23 + 55))) or ((1244 - 719) == (1408 + 701))) then
				return "ice_strike single 23";
			end
		end
		if (((30 + 3) == (50 - 17)) and v103.Windstrike:IsCastable() and v53) then
			if (((961 + 2093) <= (4916 - (652 + 249))) and v24(v103.Windstrike, not v15:IsSpellInRange(v103.Windstrike))) then
				return "windstrike single 24";
			end
		end
		if (((5006 - 3135) < (5250 - (708 + 1160))) and v103.Stormstrike:IsReady() and v50) then
			if (((3509 - 2216) <= (3948 - 1782)) and v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike))) then
				return "stormstrike single 25";
			end
		end
		if ((v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v123)) or ((2606 - (10 + 17)) < (28 + 95))) then
			if (v24(v103.Sundering, not v15:IsInRange(1740 - (1400 + 332))) or ((1622 - 776) >= (4276 - (242 + 1666)))) then
				return "sundering single 26";
			end
		end
		if ((v103.BagofTricks:IsReady() and v59 and ((v66 and v36) or not v66)) or ((1717 + 2295) <= (1231 + 2127))) then
			if (((1274 + 220) <= (3945 - (850 + 90))) and v24(v103.BagofTricks)) then
				return "bag_of_tricks single 27";
			end
		end
		if ((v103.FireNova:IsReady() and v42 and v103.SwirlingMaelstrom:IsAvailable() and (v103.FlameShockDebuff:AuraActiveCount() > (0 - 0)) and (v14:BuffStack(v103.MaelstromWeaponBuff) < ((1395 - (360 + 1030)) + ((5 + 0) * v25(v103.OverflowingMaelstrom:IsAvailable()))))) or ((8780 - 5669) == (2935 - 801))) then
			if (((4016 - (909 + 752)) == (3578 - (109 + 1114))) and v24(v103.FireNova)) then
				return "fire_nova single 28";
			end
		end
		if ((v103.LightningBolt:IsReady() and v48 and v103.Hailstorm:IsAvailable() and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (9 - 4)) and v14:BuffDown(v103.PrimordialWaveBuff)) or ((229 + 359) <= (674 - (6 + 236)))) then
			if (((3023 + 1774) >= (3136 + 759)) and v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt))) then
				return "lightning_bolt single 29";
			end
		end
		if (((8435 - 4858) == (6247 - 2670)) and v103.FrostShock:IsReady() and v44) then
			if (((4927 - (1076 + 57)) > (608 + 3085)) and v24(v103.FrostShock, not v15:IsSpellInRange(v103.FrostShock))) then
				return "frost_shock single 30";
			end
		end
		if ((v103.CrashLightning:IsReady() and v40) or ((1964 - (579 + 110)) == (324 + 3776))) then
			if (v24(v103.CrashLightning, not v15:IsInMeleeRange(8 + 0)) or ((845 + 746) >= (3987 - (174 + 233)))) then
				return "crash_lightning single 31";
			end
		end
		if (((2745 - 1762) <= (3172 - 1364)) and v103.FireNova:IsReady() and v42 and (v15:DebuffUp(v103.FlameShockDebuff))) then
			if (v24(v103.FireNova) or ((957 + 1193) <= (2371 - (663 + 511)))) then
				return "fire_nova single 32";
			end
		end
		if (((3363 + 406) >= (255 + 918)) and v103.FlameShock:IsReady() and v43) then
			if (((4578 - 3093) == (900 + 585)) and v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock))) then
				return "flame_shock single 34";
			end
		end
		if ((v103.ChainLightning:IsReady() and v39 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (11 - 6)) and v14:BuffUp(v103.CracklingThunderBuff) and v103.ElementalSpirits:IsAvailable()) or ((8025 - 4710) <= (1328 + 1454))) then
			if (v24(v103.ChainLightning, not v15:IsSpellInRange(v103.ChainLightning)) or ((1704 - 828) >= (2113 + 851))) then
				return "chain_lightning single 35";
			end
		end
		if ((v103.LightningBolt:IsReady() and v48 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (1 + 4)) and v14:BuffDown(v103.PrimordialWaveBuff)) or ((2954 - (478 + 244)) > (3014 - (440 + 77)))) then
			if (v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt)) or ((960 + 1150) <= (1214 - 882))) then
				return "lightning_bolt single 36";
			end
		end
		if (((5242 - (655 + 901)) > (589 + 2583)) and v103.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v103.WindfuryTotemBuff, true) or (v103.WindfuryTotem:TimeSinceLastCast() > (69 + 21)))) then
			if (v24(v103.WindfuryTotem) or ((3021 + 1453) < (3303 - 2483))) then
				return "windfury_totem single 37";
			end
		end
	end
	local function v143()
		local v169 = 1445 - (695 + 750);
		while true do
			if (((14611 - 10332) >= (4447 - 1565)) and (v169 == (20 - 15))) then
				if ((v103.FireNova:IsReady() and v42 and (v103.FlameShockDebuff:AuraActiveCount() >= (353 - (285 + 66)))) or ((4729 - 2700) >= (4831 - (682 + 628)))) then
					if (v24(v103.FireNova) or ((329 + 1708) >= (4941 - (176 + 123)))) then
						return "fire_nova aoe 26";
					end
				end
				if (((720 + 1000) < (3234 + 1224)) and v103.ElementalBlast:IsReady() and v41 and (not v103.ElementalSpirits:IsAvailable() or (v103.ElementalSpirits:IsAvailable() and ((v103.ElementalBlast:Charges() == v120) or (v126.FeralSpiritCount >= (271 - (239 + 30)))))) and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (2 + 3)) and (not v103.CrashingStorms:IsAvailable() or (v118 <= (3 + 0)))) then
					if (v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast)) or ((771 - 335) > (9425 - 6404))) then
						return "elemental_blast aoe 27";
					end
				end
				if (((1028 - (306 + 9)) <= (2955 - 2108)) and v103.ChainLightning:IsReady() and v39 and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (1 + 4))) then
					if (((1322 + 832) <= (1941 + 2090)) and v24(v103.ChainLightning, not v15:IsSpellInRange(v103.ChainLightning))) then
						return "chain_lightning aoe 28";
					end
				end
				if (((13197 - 8582) == (5990 - (1140 + 235))) and v103.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v103.WindfuryTotemBuff, true) or (v103.WindfuryTotem:TimeSinceLastCast() > (58 + 32)))) then
					if (v24(v103.WindfuryTotem) or ((3476 + 314) == (129 + 371))) then
						return "windfury_totem aoe 29";
					end
				end
				if (((141 - (33 + 19)) < (80 + 141)) and v103.FlameShock:IsReady() and v43 and (v15:DebuffDown(v103.FlameShockDebuff))) then
					if (((6156 - 4102) >= (626 + 795)) and v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock))) then
						return "flame_shock aoe 30";
					end
				end
				v169 = 11 - 5;
			end
			if (((649 + 43) < (3747 - (586 + 103))) and (v169 == (1 + 1))) then
				if ((v103.LavaLash:IsReady() and v47 and (v103.LashingFlames:IsAvailable())) or ((10017 - 6763) == (3143 - (1309 + 179)))) then
					local v242 = 0 - 0;
					while true do
						if ((v242 == (0 + 0)) or ((3480 - 2184) == (3709 + 1201))) then
							if (((7155 - 3787) == (6710 - 3342)) and v124.CastCycle(v103.LavaLash, v117, v134, not v15:IsSpellInRange(v103.LavaLash))) then
								return "lava_lash aoe 11";
							end
							if (((3252 - (295 + 314)) < (9370 - 5555)) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
								return "lava_lash aoe no_cycle 11";
							end
							break;
						end
					end
				end
				if (((3875 - (1300 + 662)) > (1547 - 1054)) and v103.LavaLash:IsReady() and v47 and ((v103.MoltenAssault:IsAvailable() and v15:DebuffUp(v103.FlameShockDebuff) and (v103.FlameShockDebuff:AuraActiveCount() < v118) and (v103.FlameShockDebuff:AuraActiveCount() < (1761 - (1178 + 577)))) or (v103.AshenCatalyst:IsAvailable() and (v14:BuffStack(v103.AshenCatalystBuff) >= (3 + 2))))) then
					if (((14056 - 9301) > (4833 - (851 + 554))) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
						return "lava_lash aoe 12";
					end
				end
				if (((1222 + 159) <= (6569 - 4200)) and v103.IceStrike:IsReady() and v45 and v103.Hailstorm:IsAvailable() and v14:BuffDown(v103.IceStrikeBuff)) then
					if (v24(v103.IceStrike, not v15:IsInMeleeRange(10 - 5)) or ((5145 - (115 + 187)) == (3128 + 956))) then
						return "ice_strike aoe 13";
					end
				end
				if (((4421 + 248) > (1430 - 1067)) and v103.FrostShock:IsReady() and v44 and v103.Hailstorm:IsAvailable() and v14:BuffUp(v103.HailstormBuff)) then
					if (v24(v103.FrostShock, not v15:IsSpellInRange(v103.FrostShock)) or ((3038 - (160 + 1001)) >= (2746 + 392))) then
						return "frost_shock aoe 14";
					end
				end
				if (((3272 + 1470) >= (7422 - 3796)) and v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v123)) then
					if (v24(v103.Sundering, not v15:IsInRange(366 - (237 + 121))) or ((5437 - (525 + 372)) == (1736 - 820))) then
						return "sundering aoe 15";
					end
				end
				v169 = 9 - 6;
			end
			if ((v169 == (145 - (96 + 46))) or ((1933 - (643 + 134)) > (1569 + 2776))) then
				if (((5363 - 3126) < (15775 - 11526)) and v103.FlameShock:IsReady() and v43 and v103.MoltenAssault:IsAvailable() and v15:DebuffDown(v103.FlameShockDebuff)) then
					if (v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock)) or ((2574 + 109) < (44 - 21))) then
						return "flame_shock aoe 16";
					end
				end
				if (((1424 - 727) <= (1545 - (316 + 403))) and v103.FlameShock:IsReady() and v43 and (v103.FireNova:IsAvailable() or v103.PrimordialWave:IsAvailable()) and (v103.FlameShockDebuff:AuraActiveCount() < v118) and (v103.FlameShockDebuff:AuraActiveCount() < (4 + 2))) then
					local v243 = 0 - 0;
					while true do
						if (((400 + 705) <= (2961 - 1785)) and (v243 == (0 + 0))) then
							if (((1089 + 2290) <= (13208 - 9396)) and v124.CastCycle(v103.FlameShock, v117, v131, not v15:IsSpellInRange(v103.FlameShock))) then
								return "flame_shock aoe 17";
							end
							if (v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock)) or ((3763 - 2975) >= (3356 - 1740))) then
								return "flame_shock aoe no_cycle 17";
							end
							break;
						end
					end
				end
				if (((107 + 1747) <= (6651 - 3272)) and v103.FireNova:IsReady() and v42 and (v103.FlameShockDebuff:AuraActiveCount() >= (1 + 2))) then
					if (((13383 - 8834) == (4566 - (12 + 5))) and v24(v103.FireNova)) then
						return "fire_nova aoe 18";
					end
				end
				if ((v103.Stormstrike:IsReady() and v50 and v14:BuffUp(v103.CrashLightningBuff) and (v103.DeeplyRootedElements:IsAvailable() or (v14:BuffStack(v103.ConvergingStormsBuff) == (23 - 17)))) or ((6447 - 3425) >= (6427 - 3403))) then
					if (((11953 - 7133) > (447 + 1751)) and v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike))) then
						return "stormstrike aoe 19";
					end
				end
				if ((v103.CrashLightning:IsReady() and v40 and v103.CrashingStorms:IsAvailable() and v14:BuffUp(v103.CLCrashLightningBuff) and (v118 >= (1977 - (1656 + 317)))) or ((946 + 115) >= (3920 + 971))) then
					if (((3626 - 2262) <= (22014 - 17541)) and v24(v103.CrashLightning, not v15:IsInMeleeRange(362 - (5 + 349)))) then
						return "crash_lightning aoe 20";
					end
				end
				v169 = 18 - 14;
			end
			if ((v169 == (1271 - (266 + 1005))) or ((2369 + 1226) <= (10 - 7))) then
				if ((v103.CrashLightning:IsReady() and v40 and v103.CrashingStorms:IsAvailable() and ((v103.UnrulyWinds:IsAvailable() and (v118 >= (13 - 3))) or (v118 >= (1711 - (561 + 1135))))) or ((6087 - 1415) == (12661 - 8809))) then
					if (((2625 - (507 + 559)) == (3911 - 2352)) and v24(v103.CrashLightning, not v15:IsInMeleeRange(24 - 16))) then
						return "crash_lightning aoe 1";
					end
				end
				if ((v103.LightningBolt:IsReady() and v48 and ((v103.FlameShockDebuff:AuraActiveCount() >= v118) or (v103.FlameShockDebuff:AuraActiveCount() >= (394 - (212 + 176)))) and v14:BuffUp(v103.PrimordialWaveBuff) and (v111 == v112) and (v14:BuffDown(v103.SplinteredElementsBuff) or (v123 <= (917 - (250 + 655))))) or ((4777 - 3025) <= (1376 - 588))) then
					if (v24(v103.LightningBolt, not v15:IsSpellInRange(v103.LightningBolt)) or ((6112 - 2205) == (2133 - (1869 + 87)))) then
						return "lightning_bolt aoe 2";
					end
				end
				if (((12035 - 8565) > (2456 - (484 + 1417))) and v103.LavaLash:IsReady() and v47 and v103.MoltenAssault:IsAvailable() and (v103.PrimordialWave:IsAvailable() or v103.FireNova:IsAvailable()) and v15:DebuffUp(v103.FlameShockDebuff) and (v103.FlameShockDebuff:AuraActiveCount() < v118) and (v103.FlameShockDebuff:AuraActiveCount() < (12 - 6))) then
					if (v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash)) or ((1628 - 656) == (1418 - (48 + 725)))) then
						return "lava_lash aoe 3";
					end
				end
				if (((5197 - 2015) >= (5674 - 3559)) and v103.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v123) and (v14:BuffDown(v103.PrimordialWaveBuff))) then
					local v244 = 0 + 0;
					while true do
						if (((10403 - 6510) < (1240 + 3189)) and (v244 == (0 + 0))) then
							if (v124.CastCycle(v103.PrimordialWave, v117, v131, not v15:IsSpellInRange(v103.PrimordialWave)) or ((3720 - (152 + 701)) < (3216 - (430 + 881)))) then
								return "primordial_wave aoe 4";
							end
							if (v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave)) or ((688 + 1108) >= (4946 - (557 + 338)))) then
								return "primordial_wave aoe no_cycle 4";
							end
							break;
						end
					end
				end
				if (((479 + 1140) <= (10584 - 6828)) and v103.FlameShock:IsReady() and v43 and (v103.PrimordialWave:IsAvailable() or v103.FireNova:IsAvailable()) and v15:DebuffDown(v103.FlameShockDebuff)) then
					if (((2115 - 1511) == (1604 - 1000)) and v24(v103.FlameShock, not v15:IsSpellInRange(v103.FlameShock))) then
						return "flame_shock aoe 5";
					end
				end
				v169 = 2 - 1;
			end
			if ((v169 == (802 - (499 + 302))) or ((5350 - (39 + 827)) == (2484 - 1584))) then
				if ((v103.ElementalBlast:IsReady() and v41 and (not v103.ElementalSpirits:IsAvailable() or (v103.ElementalSpirits:IsAvailable() and ((v103.ElementalBlast:Charges() == v120) or (v126.FeralSpiritCount >= (4 - 2))))) and (v14:BuffStack(v103.MaelstromWeaponBuff) == ((19 - 14) + ((7 - 2) * v25(v103.OverflowingMaelstrom:IsAvailable())))) and (not v103.CrashingStorms:IsAvailable() or (v118 <= (1 + 2)))) or ((13050 - 8591) <= (179 + 934))) then
					if (((5746 - 2114) > (3502 - (103 + 1))) and v24(v103.ElementalBlast, not v15:IsSpellInRange(v103.ElementalBlast))) then
						return "elemental_blast aoe 6";
					end
				end
				if (((4636 - (475 + 79)) <= (10629 - 5712)) and v103.ChainLightning:IsReady() and v39 and (v14:BuffStack(v103.MaelstromWeaponBuff) == ((16 - 11) + ((1 + 4) * v25(v103.OverflowingMaelstrom:IsAvailable()))))) then
					if (((4253 + 579) >= (2889 - (1395 + 108))) and v24(v103.ChainLightning, not v15:IsSpellInRange(v103.ChainLightning))) then
						return "chain_lightning aoe 7";
					end
				end
				if (((398 - 261) == (1341 - (7 + 1197))) and v103.CrashLightning:IsReady() and v40 and (v14:BuffUp(v103.DoomWindsBuff) or v14:BuffDown(v103.CrashLightningBuff) or (v103.AlphaWolf:IsAvailable() and v14:BuffUp(v103.FeralSpiritBuff) and (v130() == (0 + 0))))) then
					if (v24(v103.CrashLightning, not v15:IsInMeleeRange(3 + 5)) or ((1889 - (27 + 292)) >= (12693 - 8361))) then
						return "crash_lightning aoe 8";
					end
				end
				if ((v103.Sundering:IsReady() and v51 and ((v63 and v37) or not v63) and (v100 < v123) and (v14:BuffUp(v103.DoomWindsBuff) or v14:HasTier(38 - 8, 8 - 6))) or ((8014 - 3950) <= (3463 - 1644))) then
					if (v24(v103.Sundering, not v15:IsInRange(147 - (43 + 96))) or ((20338 - 15352) < (3558 - 1984))) then
						return "sundering aoe 9";
					end
				end
				if (((3673 + 753) > (49 + 123)) and v103.FireNova:IsReady() and v42 and ((v103.FlameShockDebuff:AuraActiveCount() >= (11 - 5)) or ((v103.FlameShockDebuff:AuraActiveCount() >= (2 + 2)) and (v103.FlameShockDebuff:AuraActiveCount() >= v118)))) then
					if (((1097 - 511) > (144 + 311)) and v24(v103.FireNova)) then
						return "fire_nova aoe 10";
					end
				end
				v169 = 1 + 1;
			end
			if (((2577 - (1414 + 337)) == (2766 - (1642 + 298))) and (v169 == (15 - 9))) then
				if ((v103.FrostShock:IsReady() and v44 and not v103.Hailstorm:IsAvailable()) or ((11561 - 7542) > (13178 - 8737))) then
					if (((664 + 1353) < (3316 + 945)) and v24(v103.FrostShock, not v15:IsSpellInRange(v103.FrostShock))) then
						return "frost_shock aoe 31";
					end
				end
				break;
			end
			if (((5688 - (357 + 615)) > (57 + 23)) and (v169 == (9 - 5))) then
				if ((v103.Windstrike:IsCastable() and v53) or ((3005 + 502) == (7011 - 3739))) then
					if (v24(v103.Windstrike, not v15:IsSpellInRange(v103.Windstrike)) or ((701 + 175) >= (209 + 2866))) then
						return "windstrike aoe 21";
					end
				end
				if (((2736 + 1616) > (3855 - (384 + 917))) and v103.Stormstrike:IsReady() and v50) then
					if (v24(v103.Stormstrike, not v15:IsSpellInRange(v103.Stormstrike)) or ((5103 - (128 + 569)) < (5586 - (1407 + 136)))) then
						return "stormstrike aoe 22";
					end
				end
				if ((v103.IceStrike:IsReady() and v45) or ((3776 - (687 + 1200)) >= (5093 - (556 + 1154)))) then
					if (((6656 - 4764) <= (2829 - (9 + 86))) and v24(v103.IceStrike, not v15:IsInMeleeRange(426 - (275 + 146)))) then
						return "ice_strike aoe 23";
					end
				end
				if (((313 + 1610) < (2282 - (29 + 35))) and v103.LavaLash:IsReady() and v47) then
					if (((9630 - 7457) > (1131 - 752)) and v24(v103.LavaLash, not v15:IsSpellInRange(v103.LavaLash))) then
						return "lava_lash aoe 24";
					end
				end
				if ((v103.CrashLightning:IsReady() and v40) or ((11437 - 8846) == (2221 + 1188))) then
					if (((5526 - (53 + 959)) > (3732 - (312 + 96))) and v24(v103.CrashLightning, not v15:IsInMeleeRange(13 - 5))) then
						return "crash_lightning aoe 25";
					end
				end
				v169 = 290 - (147 + 138);
			end
		end
	end
	local function v144()
		local v170 = 899 - (813 + 86);
		while true do
			if ((v170 == (1 + 0)) or ((385 - 177) >= (5320 - (18 + 474)))) then
				if (((not v108 or (v110 < (202418 + 397582))) and v54 and v103.FlametongueWeapon:IsCastable()) or ((5166 - 3583) > (4653 - (860 + 226)))) then
					if (v24(v103.FlametongueWeapon) or ((1616 - (121 + 182)) == (98 + 696))) then
						return "flametongue_weapon enchant";
					end
				end
				if (((4414 - (988 + 252)) > (328 + 2574)) and v86) then
					local v245 = 0 + 0;
					while true do
						if (((6090 - (49 + 1921)) <= (5150 - (223 + 667))) and ((52 - (51 + 1)) == v245)) then
							v33 = v138();
							if (v33 or ((1519 - 636) > (10231 - 5453))) then
								return v33;
							end
							break;
						end
					end
				end
				v170 = 1127 - (146 + 979);
			end
			if ((v170 == (1 + 1)) or ((4225 - (311 + 294)) >= (13639 - 8748))) then
				if (((1804 + 2454) > (2380 - (496 + 947))) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) then
					if (v24(v103.AncestralSpirit, nil, true) or ((6227 - (1233 + 125)) < (368 + 538))) then
						return "resurrection";
					end
				end
				if ((v124.TargetIsValid() and v34) or ((1100 + 125) > (804 + 3424))) then
					if (((4973 - (963 + 682)) > (1868 + 370)) and not v14:AffectingCombat()) then
						local v255 = 1504 - (504 + 1000);
						while true do
							if (((2586 + 1253) > (1280 + 125)) and (v255 == (0 + 0))) then
								v33 = v141();
								if (v33 or ((1906 - 613) <= (434 + 73))) then
									return v33;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v170 == (0 + 0)) or ((3078 - (156 + 26)) < (464 + 341))) then
				if (((3622 - 1306) == (2480 - (149 + 15))) and v76 and v103.EarthShield:IsCastable() and v14:BuffDown(v103.EarthShieldBuff) and ((v77 == "Earth Shield") or (v103.ElementalOrbit:IsAvailable() and v14:BuffUp(v103.LightningShield)))) then
					if (v24(v103.EarthShield) or ((3530 - (890 + 70)) == (1650 - (39 + 78)))) then
						return "earth_shield main 2";
					end
				elseif ((v76 and v103.LightningShield:IsCastable() and v14:BuffDown(v103.LightningShieldBuff) and ((v77 == "Lightning Shield") or (v103.ElementalOrbit:IsAvailable() and v14:BuffUp(v103.EarthShield)))) or ((1365 - (14 + 468)) == (3210 - 1750))) then
					if (v24(v103.LightningShield) or ((12910 - 8291) <= (516 + 483))) then
						return "lightning_shield main 2";
					end
				end
				if (((not v107 or (v109 < (360303 + 239697))) and v54 and v103.WindfuryWeapon:IsCastable()) or ((725 + 2685) > (1859 + 2257))) then
					if (v24(v103.WindfuryWeapon) or ((237 + 666) >= (5854 - 2795))) then
						return "windfury_weapon enchant";
					end
				end
				v170 = 1 + 0;
			end
		end
	end
	local function v145()
		local v171 = 0 - 0;
		while true do
			if ((v171 == (1 + 0)) or ((4027 - (12 + 39)) < (2658 + 199))) then
				if (((15260 - 10330) > (8216 - 5909)) and v94) then
					local v246 = 0 + 0;
					while true do
						if ((v246 == (1 + 0)) or ((10259 - 6213) < (860 + 431))) then
							if (v90 or ((20495 - 16254) == (5255 - (1596 + 114)))) then
								local v258 = 0 - 0;
								while true do
									if ((v258 == (713 - (164 + 549))) or ((5486 - (1059 + 379)) > (5254 - 1022))) then
										v33 = v124.HandleAfflicted(v103.PoisonCleansingTotem, v103.PoisonCleansingTotem, 16 + 14);
										if (v33 or ((295 + 1455) >= (3865 - (145 + 247)))) then
											return v33;
										end
										break;
									end
								end
							end
							if (((2598 + 568) == (1463 + 1703)) and (v14:BuffStack(v103.MaelstromWeaponBuff) >= (14 - 9)) and v91) then
								local v259 = 0 + 0;
								while true do
									if (((1519 + 244) < (6046 - 2322)) and (v259 == (720 - (254 + 466)))) then
										v33 = v124.HandleAfflicted(v103.HealingSurge, v105.HealingSurgeMouseover, 600 - (544 + 16), true);
										if (((180 - 123) <= (3351 - (294 + 334))) and v33) then
											return v33;
										end
										break;
									end
								end
							end
							break;
						end
						if ((v246 == (253 - (236 + 17))) or ((893 + 1177) == (345 + 98))) then
							if (v88 or ((10187 - 7482) == (6595 - 5202))) then
								local v260 = 0 + 0;
								while true do
									if (((0 + 0) == v260) or ((5395 - (413 + 381)) < (3 + 58))) then
										v33 = v124.HandleAfflicted(v103.CleanseSpirit, v105.CleanseSpiritMouseover, 85 - 45);
										if (v33 or ((3610 - 2220) >= (6714 - (582 + 1388)))) then
											return v33;
										end
										break;
									end
								end
							end
							if (v89 or ((3412 - 1409) > (2745 + 1089))) then
								local v261 = 364 - (326 + 38);
								while true do
									if (((0 - 0) == v261) or ((222 - 66) > (4533 - (47 + 573)))) then
										v33 = v124.HandleAfflicted(v103.TremorTotem, v103.TremorTotem, 11 + 19);
										if (((828 - 633) == (316 - 121)) and v33) then
											return v33;
										end
										break;
									end
								end
							end
							v246 = 1665 - (1269 + 395);
						end
					end
				end
				if (((3597 - (76 + 416)) >= (2239 - (319 + 124))) and v95) then
					v33 = v124.HandleIncorporeal(v103.Hex, v105.HexMouseOver, 68 - 38, true);
					if (((5386 - (564 + 443)) >= (5899 - 3768)) and v33) then
						return v33;
					end
				end
				v171 = 460 - (337 + 121);
			end
			if (((11262 - 7418) >= (6805 - 4762)) and (v171 == (1911 - (1261 + 650)))) then
				v33 = v139();
				if (v33 or ((1368 + 1864) <= (4352 - 1621))) then
					return v33;
				end
				v171 = 1818 - (772 + 1045);
			end
			if (((692 + 4213) == (5049 - (102 + 42))) and (v171 == (1848 - (1524 + 320)))) then
				if (v33 or ((5406 - (1049 + 221)) >= (4567 - (18 + 138)))) then
					return v33;
				end
				if (v124.TargetIsValid() or ((7240 - 4282) == (5119 - (67 + 1035)))) then
					local v247 = 348 - (136 + 212);
					local v248;
					while true do
						if (((5218 - 3990) >= (652 + 161)) and (v247 == (2 + 0))) then
							if ((v103.Ascendance:IsCastable() and v55 and ((v60 and v36) or not v60) and (v100 < v123) and v15:DebuffUp(v103.FlameShockDebuff) and (((v121 == "Lightning Bolt") and (v118 == (1605 - (240 + 1364)))) or ((v121 == "Chain Lightning") and (v118 > (1083 - (1050 + 32)))))) or ((12336 - 8881) > (2396 + 1654))) then
								if (((1298 - (331 + 724)) == (20 + 223)) and v24(v103.Ascendance)) then
									return "ascendance main 4";
								end
							end
							if ((v103.DoomWinds:IsCastable() and v57 and ((v62 and v36) or not v62) and (v100 < v123)) or ((915 - (269 + 375)) > (2297 - (267 + 458)))) then
								if (((852 + 1887) < (6332 - 3039)) and v24(v103.DoomWinds, not v15:IsInMeleeRange(823 - (667 + 151)))) then
									return "doom_winds main 5";
								end
							end
							if ((v118 == (1498 - (1410 + 87))) or ((5839 - (1504 + 393)) < (3065 - 1931))) then
								local v262 = 0 - 0;
								while true do
									if ((v262 == (796 - (461 + 335))) or ((345 + 2348) == (6734 - (1730 + 31)))) then
										v33 = v142();
										if (((3813 - (728 + 939)) == (7600 - 5454)) and v33) then
											return v33;
										end
										break;
									end
								end
							end
							if ((v35 and (v118 > (1 - 0))) or ((5141 - 2897) == (4292 - (138 + 930)))) then
								local v263 = 0 + 0;
								while true do
									if (((0 + 0) == v263) or ((4203 + 701) <= (7823 - 5907))) then
										v33 = v143();
										if (((1856 - (459 + 1307)) <= (2935 - (474 + 1396))) and v33) then
											return v33;
										end
										break;
									end
								end
							end
							break;
						end
						if (((8384 - 3582) == (4501 + 301)) and (v247 == (0 + 0))) then
							v248 = v124.HandleDPSPotion(v14:BuffUp(v103.FeralSpiritBuff));
							if (v248 or ((6530 - 4250) <= (65 + 446))) then
								return v248;
							end
							if ((v100 < v123) or ((5594 - 3918) <= (2019 - 1556))) then
								if (((4460 - (562 + 29)) == (3299 + 570)) and v58 and ((v36 and v65) or not v65)) then
									local v265 = 1419 - (374 + 1045);
									while true do
										if (((917 + 241) <= (8113 - 5500)) and (v265 == (638 - (448 + 190)))) then
											v33 = v140();
											if (v33 or ((764 + 1600) <= (903 + 1096))) then
												return v33;
											end
											break;
										end
									end
								end
							end
							if (((v100 < v123) and v59 and ((v66 and v36) or not v66)) or ((3207 + 1715) < (745 - 551))) then
								if ((v103.BloodFury:IsCastable() and (not v103.Ascendance:IsAvailable() or v14:BuffUp(v103.AscendanceBuff) or (v103.Ascendance:CooldownRemains() > (155 - 105)))) or ((3585 - (1307 + 187)) < (122 - 91))) then
									if (v24(v103.BloodFury) or ((5689 - 3259) >= (14938 - 10066))) then
										return "blood_fury racial";
									end
								end
								if ((v103.Berserking:IsCastable() and (not v103.Ascendance:IsAvailable() or v14:BuffUp(v103.AscendanceBuff))) or ((5453 - (232 + 451)) < (1657 + 78))) then
									if (v24(v103.Berserking) or ((3922 + 517) <= (2914 - (510 + 54)))) then
										return "berserking racial";
									end
								end
								if ((v103.Fireblood:IsCastable() and (not v103.Ascendance:IsAvailable() or v14:BuffUp(v103.AscendanceBuff) or (v103.Ascendance:CooldownRemains() > (100 - 50)))) or ((4515 - (13 + 23)) < (8705 - 4239))) then
									if (((3659 - 1112) > (2225 - 1000)) and v24(v103.Fireblood)) then
										return "fireblood racial";
									end
								end
								if (((5759 - (830 + 258)) > (9432 - 6758)) and v103.AncestralCall:IsCastable() and (not v103.Ascendance:IsAvailable() or v14:BuffUp(v103.AscendanceBuff) or (v103.Ascendance:CooldownRemains() > (32 + 18)))) then
									if (v24(v103.AncestralCall) or ((3145 + 551) < (4768 - (860 + 581)))) then
										return "ancestral_call racial";
									end
								end
							end
							v247 = 3 - 2;
						end
						if ((v247 == (1 + 0)) or ((4783 - (237 + 4)) == (6980 - 4010))) then
							if (((637 - 385) <= (3747 - 1770)) and v103.TotemicProjection:IsCastable() and (v103.WindfuryTotem:TimeSinceLastCast() < (74 + 16)) and v14:BuffDown(v103.WindfuryTotemBuff, true)) then
								if (v24(v105.TotemicProjectionPlayer) or ((825 + 611) == (14252 - 10477))) then
									return "totemic_projection wind_fury main 0";
								end
							end
							if ((v103.Windstrike:IsCastable() and v53) or ((695 + 923) < (506 + 424))) then
								if (((6149 - (85 + 1341)) > (7086 - 2933)) and v24(v103.Windstrike, not v15:IsSpellInRange(v103.Windstrike))) then
									return "windstrike main 1";
								end
							end
							if ((v103.PrimordialWave:IsCastable() and v49 and ((v64 and v37) or not v64) and (v100 < v123) and (v14:HasTier(87 - 56, 374 - (45 + 327)))) or ((6894 - 3240) >= (5156 - (444 + 58)))) then
								if (((414 + 537) <= (258 + 1238)) and v24(v103.PrimordialWave, not v15:IsSpellInRange(v103.PrimordialWave))) then
									return "primordial_wave main 2";
								end
							end
							if ((v103.FeralSpirit:IsCastable() and v56 and ((v61 and v36) or not v61) and (v100 < v123)) or ((849 + 887) == (1654 - 1083))) then
								if (v24(v103.FeralSpirit) or ((2628 - (64 + 1668)) > (6742 - (1227 + 746)))) then
									return "feral_spirit main 3";
								end
							end
							v247 = 5 - 3;
						end
					end
				end
				break;
			end
			if ((v171 == (5 - 2)) or ((1539 - (415 + 79)) <= (27 + 993))) then
				if ((v103.Purge:IsReady() and v101 and v38 and v92 and not v14:IsCasting() and not v14:IsChanneling() and v124.UnitHasMagicBuff(v15)) or ((1651 - (142 + 349)) <= (141 + 187))) then
					if (((5235 - 1427) > (1454 + 1470)) and v24(v103.Purge, not v15:IsSpellInRange(v103.Purge))) then
						return "purge damage";
					end
				end
				v33 = v137();
				v171 = 3 + 1;
			end
			if (((10596 - 6705) < (6783 - (1710 + 154))) and (v171 == (320 - (200 + 118)))) then
				if (v93 or ((886 + 1348) <= (2625 - 1123))) then
					if (v16 or ((3725 - 1213) < (384 + 48))) then
						local v256 = 0 + 0;
						while true do
							if (((0 + 0) == v256) or ((296 + 1552) == (1874 - 1009))) then
								v33 = v136();
								if (v33 or ((5932 - (363 + 887)) <= (7929 - 3388))) then
									return v33;
								end
								break;
							end
						end
					end
					if ((v17 and v17:Exists() and not v14:CanAttack(v17) and (v124.UnitHasDispellableDebuffByPlayer(v17) or v124.UnitHasCurseDebuff(v17))) or ((14403 - 11377) >= (625 + 3421))) then
						if (((4698 - 2690) > (436 + 202)) and v103.CleanseSpirit:IsCastable()) then
							if (((3439 - (674 + 990)) <= (927 + 2306)) and v24(v105.CleanseSpiritMouseover, not v17:IsSpellInRange(v103.PurifySpirit))) then
								return "purify_spirit dispel mouseover";
							end
						end
					end
				end
				if ((v103.GreaterPurge:IsAvailable() and v101 and v103.GreaterPurge:IsReady() and v38 and v92 and not v14:IsCasting() and not v14:IsChanneling() and v124.UnitHasMagicBuff(v15)) or ((1860 + 2683) == (3165 - 1168))) then
					if (v24(v103.GreaterPurge, not v15:IsSpellInRange(v103.GreaterPurge)) or ((4157 - (507 + 548)) < (1565 - (289 + 548)))) then
						return "greater_purge damage";
					end
				end
				v171 = 1821 - (821 + 997);
			end
		end
	end
	local function v146()
		local v172 = 255 - (195 + 60);
		while true do
			if (((93 + 252) == (1846 - (251 + 1250))) and (v172 == (11 - 7))) then
				v53 = EpicSettings.Settings['useWindstrike'];
				v52 = EpicSettings.Settings['useWindfuryTotem'];
				v54 = EpicSettings.Settings['useWeaponEnchant'];
				v102 = EpicSettings.Settings['useWeapon'];
				v172 = 4 + 1;
			end
			if ((v172 == (1034 - (809 + 223))) or ((4125 - 1298) < (1135 - 757))) then
				v44 = EpicSettings.Settings['useFrostShock'];
				v45 = EpicSettings.Settings['useIceStrike'];
				v46 = EpicSettings.Settings['useLavaBurst'];
				v47 = EpicSettings.Settings['useLavaLash'];
				v172 = 9 - 6;
			end
			if ((v172 == (3 + 0)) or ((1821 + 1655) < (3214 - (14 + 603)))) then
				v48 = EpicSettings.Settings['useLightningBolt'];
				v49 = EpicSettings.Settings['usePrimordialWave'];
				v50 = EpicSettings.Settings['useStormStrike'];
				v51 = EpicSettings.Settings['useSundering'];
				v172 = 133 - (118 + 11);
			end
			if (((499 + 2580) < (3993 + 801)) and (v172 == (0 - 0))) then
				v55 = EpicSettings.Settings['useAscendance'];
				v57 = EpicSettings.Settings['useDoomWinds'];
				v56 = EpicSettings.Settings['useFeralSpirit'];
				v39 = EpicSettings.Settings['useChainlightning'];
				v172 = 950 - (551 + 398);
			end
			if (((3068 + 1786) > (1589 + 2875)) and (v172 == (5 + 0))) then
				v60 = EpicSettings.Settings['ascendanceWithCD'];
				v62 = EpicSettings.Settings['doomWindsWithCD'];
				v61 = EpicSettings.Settings['feralSpiritWithCD'];
				v64 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v172 = 22 - 16;
			end
			if ((v172 == (13 - 7)) or ((1593 + 3319) == (14918 - 11160))) then
				v63 = EpicSettings.Settings['sunderingWithMiniCD'];
				break;
			end
			if (((35 + 91) <= (3571 - (40 + 49))) and ((3 - 2) == v172)) then
				v40 = EpicSettings.Settings['useCrashLightning'];
				v41 = EpicSettings.Settings['useElementalBlast'];
				v42 = EpicSettings.Settings['useFireNova'];
				v43 = EpicSettings.Settings['useFlameShock'];
				v172 = 492 - (99 + 391);
			end
		end
	end
	local function v147()
		local v173 = 0 + 0;
		while true do
			if ((v173 == (13 - 10)) or ((5878 - 3504) == (4261 + 113))) then
				v83 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (0 - 0);
				v76 = EpicSettings.Settings['autoShield'];
				v77 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v86 = EpicSettings.Settings['healOOC'];
				v173 = 1608 - (1032 + 572);
			end
			if (((1992 - (203 + 214)) == (3392 - (568 + 1249))) and (v173 == (1 + 0))) then
				v70 = EpicSettings.Settings['useAstralShift'];
				v73 = EpicSettings.Settings['useMaelstromHealingSurge'];
				v72 = EpicSettings.Settings['useHealingStreamTotem'];
				v79 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 - 0);
				v173 = 7 - 5;
			end
			if (((1310 - (913 + 393)) == v173) or ((6308 - 4074) == (2055 - 600))) then
				v87 = EpicSettings.Settings['healOOCHP'] or (410 - (269 + 141));
				v101 = EpicSettings.Settings['usePurgeTarget'];
				v88 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v89 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v173 = 11 - 6;
			end
			if ((v173 == (1983 - (362 + 1619))) or ((2692 - (950 + 675)) > (686 + 1093))) then
				v80 = EpicSettings.Settings['ancestralGuidanceGroup'] or (1179 - (216 + 963));
				v78 = EpicSettings.Settings['astralShiftHP'] or (1287 - (485 + 802));
				v81 = EpicSettings.Settings['healingStreamTotemHP'] or (559 - (432 + 127));
				v82 = EpicSettings.Settings['healingStreamTotemGroup'] or (1073 - (1065 + 8));
				v173 = 2 + 1;
			end
			if (((3762 - (635 + 966)) >= (672 + 262)) and (v173 == (42 - (5 + 37)))) then
				v67 = EpicSettings.Settings['useWindShear'];
				v68 = EpicSettings.Settings['useCapacitorTotem'];
				v69 = EpicSettings.Settings['useThunderstorm'];
				v71 = EpicSettings.Settings['useAncestralGuidance'];
				v173 = 2 - 1;
			end
			if (((671 + 941) == (2550 - 938)) and ((3 + 2) == v173)) then
				v90 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				v91 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
				break;
			end
		end
	end
	local function v148()
		v100 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
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
		v85 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v96 = EpicSettings.Settings['HealingPotionName'] or "";
		v94 = EpicSettings.Settings['handleAfflicted'];
		v95 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v149()
		local v187 = 0 - 0;
		while true do
			if (((3130 + 1222) >= (3362 - (318 + 211))) and (v187 == (0 - 0))) then
				v147();
				v146();
				v148();
				v34 = EpicSettings.Toggles['ooc'];
				v187 = 1588 - (963 + 624);
			end
			if ((v187 == (1 + 0)) or ((4068 - (518 + 328)) < (7163 - 4090))) then
				v35 = EpicSettings.Toggles['aoe'];
				v36 = EpicSettings.Toggles['cds'];
				v38 = EpicSettings.Toggles['dispel'];
				v37 = EpicSettings.Toggles['minicds'];
				v187 = 2 - 0;
			end
			if (((1061 - (301 + 16)) <= (8622 - 5680)) and (v187 == (8 - 5))) then
				if (v35 or ((4783 - 2950) <= (1198 + 124))) then
					local v249 = 0 + 0;
					while true do
						if (((0 - 0) == v249) or ((2086 + 1381) <= (101 + 954))) then
							v119 = v128(127 - 87);
							v118 = #v117;
							break;
						end
					end
				else
					local v250 = 0 + 0;
					while true do
						if (((4560 - (829 + 190)) == (12633 - 9092)) and (v250 == (0 - 0))) then
							v119 = 1 - 0;
							v118 = 2 - 1;
							break;
						end
					end
				end
				if ((v38 and v93) or ((843 + 2714) >= (1308 + 2695))) then
					if ((v14:AffectingCombat() and v103.CleanseSpirit:IsAvailable()) or ((1994 - 1337) >= (1574 + 94))) then
						local v257 = v93 and v103.CleanseSpirit:IsReady() and v38;
						v33 = v124.FocusUnit(v257, nil, 633 - (520 + 93), nil, 301 - (259 + 17), v103.HealingSurge);
						if (v33 or ((60 + 967) > (1389 + 2469))) then
							return v33;
						end
					end
				end
				if (v124.TargetIsValid() or v14:AffectingCombat() or ((12370 - 8716) < (1041 - (396 + 195)))) then
					v122 = v10.BossFightRemains(nil, true);
					v123 = v122;
					if (((5486 - 3595) < (6214 - (440 + 1321))) and (v123 == (12940 - (1059 + 770)))) then
						v123 = v10.FightRemains(v117, false);
					end
				end
				if (v14:AffectingCombat() or ((14519 - 11379) < (2674 - (424 + 121)))) then
					if (v14:PrevGCD(1 + 0, v103.ChainLightning) or ((3902 - (641 + 706)) < (492 + 748))) then
						v121 = "Chain Lightning";
					elseif (v14:PrevGCD(441 - (249 + 191), v103.LightningBolt) or ((20592 - 15865) <= (2109 + 2613))) then
						v121 = "Lightning Bolt";
					end
				end
				v187 = 15 - 11;
			end
			if (((1167 - (183 + 244)) < (243 + 4694)) and (v187 == (732 - (434 + 296)))) then
				if (((11673 - 8015) >= (792 - (169 + 343))) and v14:IsDeadOrGhost()) then
					return v33;
				end
				v107, v109, _, _, v108, v110 = v27();
				v116 = v14:GetEnemiesInRange(36 + 4);
				v117 = v14:GetEnemiesInMeleeRange(17 - 7);
				v187 = 8 - 5;
			end
			if ((v187 == (4 + 0)) or ((2509 - 1624) >= (2154 - (651 + 472)))) then
				if (((2686 + 868) >= (227 + 298)) and not v14:IsChanneling() and not v14:IsChanneling()) then
					local v251 = 0 - 0;
					while true do
						if (((2897 - (397 + 86)) <= (3848 - (423 + 453))) and (v251 == (0 + 0))) then
							if (((466 + 3063) <= (3089 + 449)) and v94) then
								if (v88 or ((2284 + 577) < (410 + 48))) then
									local v266 = 1190 - (50 + 1140);
									while true do
										if (((1485 + 232) <= (2672 + 1853)) and (v266 == (0 + 0))) then
											v33 = v124.HandleAfflicted(v103.CleanseSpirit, v105.CleanseSpiritMouseover, 57 - 17);
											if (v33 or ((2300 + 878) <= (2120 - (157 + 439)))) then
												return v33;
											end
											break;
										end
									end
								end
								if (((7397 - 3143) > (1229 - 859)) and v89) then
									local v267 = 0 - 0;
									while true do
										if ((v267 == (918 - (782 + 136))) or ((2490 - (112 + 743)) == (2948 - (1026 + 145)))) then
											v33 = v124.HandleAfflicted(v103.TremorTotem, v103.TremorTotem, 6 + 24);
											if (v33 or ((4056 - (493 + 225)) >= (14676 - 10683))) then
												return v33;
											end
											break;
										end
									end
								end
								if (((702 + 452) <= (3954 - 2479)) and v90) then
									v33 = v124.HandleAfflicted(v103.PoisonCleansingTotem, v103.PoisonCleansingTotem, 1 + 29);
									if (v33 or ((7459 - 4849) < (359 + 871))) then
										return v33;
									end
								end
								if (((v14:BuffStack(v103.MaelstromWeaponBuff) >= (7 - 2)) and v91) or ((3043 - (210 + 1385)) == (4772 - (1201 + 488)))) then
									local v268 = 0 + 0;
									while true do
										if (((5582 - 2443) > (1642 - 726)) and ((585 - (352 + 233)) == v268)) then
											v33 = v124.HandleAfflicted(v103.HealingSurge, v105.HealingSurgeMouseover, 96 - 56, true);
											if (((1607 + 1347) == (8398 - 5444)) and v33) then
												return v33;
											end
											break;
										end
									end
								end
							end
							if (((691 - (489 + 85)) <= (4393 - (277 + 1224))) and v14:AffectingCombat()) then
								v33 = v145();
								if (v33 or ((1946 - (663 + 830)) > (4095 + 567))) then
									return v33;
								end
							else
								local v264 = 0 - 0;
								while true do
									if (((2195 - (461 + 414)) > (100 + 495)) and (v264 == (0 + 0))) then
										v33 = v144();
										if (v33 or ((305 + 2894) < (582 + 8))) then
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
				break;
			end
		end
	end
	local function v150()
		v103.FlameShockDebuff:RegisterAuraTracking();
		v129();
		v21.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(513 - (172 + 78), v149, v150);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

