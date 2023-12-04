local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((935 + 2986) >= (2218 + 36)) and not v5) then
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
	local v15 = v9.Spell;
	local v16 = v9.MultiSpell;
	local v17 = v9.Item;
	local v18 = EpicLib;
	local v19 = v18.Cast;
	local v20 = v18.Macro;
	local v21 = v18.Press;
	local v22 = v18.Commons.Everyone.num;
	local v23 = v18.Commons.Everyone.bool;
	local v24 = GetWeaponEnchantInfo;
	local v25 = math.max;
	local v26 = math.min;
	local v27 = string.match;
	local v28 = GetTime;
	local v29 = C_Timer;
	local v30;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
	local v36;
	local v37;
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
	local v36;
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
	local v100 = v15.Shaman.Enhancement;
	local v101 = v17.Shaman.Enhancement;
	local v102 = v20.Shaman.Enhancement;
	local v103 = {};
	local v104, v105;
	local v106, v107;
	local v108, v109, v110, v111;
	local v112 = (v100.LavaBurst:IsAvailable() and (313 - (309 + 2))) or (2 - 1);
	local v113 = "Lightning Bolt";
	local v114 = 12323 - (1090 + 122);
	local v115 = 3603 + 7508;
	local v116 = v18.Commons.Everyone;
	v18.Commons.Shaman = {};
	local v118 = v18.Commons.Shaman;
	v118.LastSKCast = 0 - 0;
	v118.LastSKBuff = 0 + 0;
	v118.LastT302pcBuff = 1118 - (628 + 490);
	v118.FeralSpiritCount = 0 + 0;
	v9:RegisterForEvent(function()
		v112 = (v100.LavaBurst:IsAvailable() and (4 - 2)) or (4 - 3);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v9:RegisterForEvent(function()
		local v149 = 774 - (431 + 343);
		while true do
			if ((v149 == (1 - 0)) or ((4261 - 2788) > (1366 + 363))) then
				v115 = 1422 + 9689;
				break;
			end
			if (((4468 - (556 + 1139)) == (2788 - (6 + 9))) and (v149 == (0 + 0))) then
				v113 = "Lightning Bolt";
				v114 = 5692 + 5419;
				v149 = 170 - (28 + 141);
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForSelfCombatEvent(function(...)
		local v150, v151, v151, v151, v151, v151, v151, v151, v152 = select(2 + 2, ...);
		if (((1425 - 270) <= (1185 + 488)) and (v150 == v13:GUID()) and (v152 == (192951 - (486 + 831)))) then
			v118.LastSKCast = v28();
		end
		if ((v13:HasTier(80 - 49, 6 - 4) and (v150 == v13:GUID()) and (v152 == (71047 + 304935))) or ((7348 - 5024) <= (1841 - (668 + 595)))) then
			local v198 = 0 + 0;
			while true do
				if (((760 + 3007) == (10272 - 6505)) and (v198 == (290 - (23 + 267)))) then
					v118.FeralSpiritCount = v118.FeralSpiritCount + (1945 - (1129 + 815));
					v29.After(402 - (371 + 16), function()
						v118.FeralSpiritCount = v118.FeralSpiritCount - (1751 - (1326 + 424));
					end);
					break;
				end
			end
		end
		if (((7744 - 3655) == (14942 - 10853)) and (v150 == v13:GUID()) and (v152 == (51651 - (88 + 30)))) then
			local v199 = 771 - (720 + 51);
			while true do
				if (((9916 - 5458) >= (3450 - (421 + 1355))) and (v199 == (0 - 0))) then
					v118.FeralSpiritCount = v118.FeralSpiritCount + 1 + 1;
					v29.After(1098 - (286 + 797), function()
						v118.FeralSpiritCount = v118.FeralSpiritCount - (7 - 5);
					end);
					break;
				end
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v9:RegisterForSelfCombatEvent(function(...)
		local v153 = 0 - 0;
		local v154;
		local v155;
		local v156;
		while true do
			if (((1411 - (397 + 42)) <= (443 + 975)) and (v153 == (800 - (24 + 776)))) then
				v154, v155, v155, v155, v156 = select(12 - 4, ...);
				if (((v154 == v13:GUID()) and (v156 == (192419 - (222 + 563)))) or ((10879 - 5941) < (3429 + 1333))) then
					v118.LastSKBuff = v28();
					v29.After(190.1 - (23 + 167), function()
						if ((v118.LastSKBuff ~= v118.LastSKCast) or ((4302 - (690 + 1108)) > (1539 + 2725))) then
							v118.LastT302pcBuff = v118.LastSKBuff;
						end
					end);
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED");
	local function v123()
		if (((1776 + 377) == (3001 - (40 + 808))) and v100.CleanseSpirit:IsAvailable()) then
			v116.DispellableDebuffs = v116.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v123();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v124()
		for v196 = 1 + 0, 22 - 16, 1 + 0 do
			if (v27(v13:TotemName(v196), "Totem") or ((269 + 238) >= (1421 + 1170))) then
				return v196;
			end
		end
	end
	local function v125()
		if (((5052 - (47 + 524)) == (2908 + 1573)) and (not v100.AlphaWolf:IsAvailable() or v13:BuffDown(v100.FeralSpiritBuff))) then
			return 0 - 0;
		end
		local v157 = v26(v100.CrashLightning:TimeSinceLastCast(), v100.ChainLightning:TimeSinceLastCast());
		if ((v157 > (11 - 3)) or (v157 > v100.FeralSpirit:TimeSinceLastCast()) or ((5308 - 2980) < (2419 - (1165 + 561)))) then
			return 0 + 0;
		end
		return (24 - 16) - v157;
	end
	local function v126(v158)
		return (v158:DebuffRefreshable(v100.FlameShockDebuff));
	end
	local function v127(v159)
		return (v159:DebuffRefreshable(v100.LashingFlamesDebuff));
	end
	local function v128(v160)
		return (v160:DebuffRemains(v100.FlameShockDebuff));
	end
	local function v129(v161)
		return (v13:BuffDown(v100.PrimordialWaveBuff));
	end
	local function v130(v162)
		return (v14:DebuffRemains(v100.LashingFlamesDebuff));
	end
	local function v131(v163)
		return (v100.LashingFlames:IsAvailable());
	end
	local function v132(v164)
		return v164:DebuffUp(v100.FlameShockDebuff) and (v100.FlameShockDebuff:AuraActiveCount() < v110) and (v100.FlameShockDebuff:AuraActiveCount() < (3 + 3));
	end
	local function v133()
		if (((4807 - (341 + 138)) == (1169 + 3159)) and v100.CleanseSpirit:IsReady() and v35 and v116.DispellableFriendlyUnit(51 - 26)) then
			if (((1914 - (89 + 237)) >= (4284 - 2952)) and v21(v102.CleanseSpiritFocus)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v134()
		local v165 = 0 - 0;
		while true do
			if ((v165 == (881 - (581 + 300))) or ((5394 - (855 + 365)) > (10089 - 5841))) then
				if (not Focus or not Focus:Exists() or not Focus:IsInRange(14 + 26) or ((5821 - (1030 + 205)) <= (77 + 5))) then
					return;
				end
				if (((3594 + 269) == (4149 - (156 + 130))) and Focus) then
					if (((Focus:HealthPercentage() <= v81) and v71 and v100.HealingSurge:IsReady() and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (11 - 6))) or ((474 - 192) <= (85 - 43))) then
						if (((1215 + 3394) >= (447 + 319)) and v21(v102.HealingSurgeFocus)) then
							return "healing_surge heal focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v135()
		if ((v13:HealthPercentage() <= v85) or ((1221 - (10 + 59)) == (704 + 1784))) then
			if (((16852 - 13430) > (4513 - (671 + 492))) and v100.HealingSurge:IsReady()) then
				if (((699 + 178) > (1591 - (369 + 846))) and v21(v100.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v136()
		local v166 = 0 + 0;
		while true do
			if ((v166 == (1 + 0)) or ((5063 - (1036 + 909)) <= (1472 + 379))) then
				if ((v100.HealingStreamTotem:IsReady() and v70 and v116.AreUnitsBelowHealthPercentage(v79, v80)) or ((277 - 112) >= (3695 - (11 + 192)))) then
					if (((1996 + 1953) < (5031 - (135 + 40))) and v21(v100.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v100.HealingSurge:IsReady() and v71 and (v13:HealthPercentage() <= v81) and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (11 - 6))) or ((2578 + 1698) < (6643 - 3627))) then
					if (((7030 - 2340) > (4301 - (50 + 126))) and v21(v100.HealingSurge)) then
						return "healing_surge defensive 4";
					end
				end
				v166 = 5 - 3;
			end
			if (((1 + 1) == v166) or ((1463 - (1233 + 180)) >= (1865 - (522 + 447)))) then
				if ((v101.Healthstone:IsReady() and v72 and (v13:HealthPercentage() <= v82)) or ((3135 - (107 + 1314)) >= (1373 + 1585))) then
					if (v21(v102.Healthstone) or ((4543 - 3052) < (274 + 370))) then
						return "healthstone defensive 3";
					end
				end
				if (((1397 - 693) < (3905 - 2918)) and v73 and (v13:HealthPercentage() <= v83)) then
					local v246 = 1910 - (716 + 1194);
					while true do
						if (((64 + 3654) > (205 + 1701)) and (v246 == (503 - (74 + 429)))) then
							if ((v94 == "Refreshing Healing Potion") or ((1847 - 889) > (1802 + 1833))) then
								if (((8013 - 4512) <= (3178 + 1314)) and v101.RefreshingHealingPotion:IsReady()) then
									if (v21(v102.RefreshingHealingPotion) or ((10611 - 7169) < (6300 - 3752))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((3308 - (279 + 154)) >= (2242 - (454 + 324))) and (v94 == "Dreamwalker's Healing Potion")) then
								if (v101.DreamwalkersHealingPotion:IsReady() or ((3775 + 1022) >= (4910 - (12 + 5)))) then
									if (v21(v102.RefreshingHealingPotion) or ((298 + 253) > (5269 - 3201))) then
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
			if (((782 + 1332) > (2037 - (277 + 816))) and (v166 == (0 - 0))) then
				if ((v100.AstralShift:IsReady() and v68 and (v13:HealthPercentage() <= v76)) or ((3445 - (1058 + 125)) >= (581 + 2515))) then
					if (v21(v100.AstralShift) or ((3230 - (815 + 160)) >= (15175 - 11638))) then
						return "astral_shift defensive 1";
					end
				end
				if ((v100.AncestralGuidance:IsReady() and v69 and v116.AreUnitsBelowHealthPercentage(v77, v78)) or ((9108 - 5271) < (312 + 994))) then
					if (((8623 - 5673) == (4848 - (41 + 1857))) and v21(v100.AncestralGuidance)) then
						return "ancestral_guidance defensive 2";
					end
				end
				v166 = 1894 - (1222 + 671);
			end
		end
	end
	local function v137()
		local v167 = 0 - 0;
		while true do
			if ((v167 == (1 - 0)) or ((5905 - (229 + 953)) < (5072 - (1111 + 663)))) then
				v30 = v116.HandleBottomTrinket(v103, v33, 1619 - (874 + 705), nil);
				if (((160 + 976) >= (106 + 48)) and v30) then
					return v30;
				end
				break;
			end
			if ((v167 == (0 - 0)) or ((8 + 263) > (5427 - (642 + 37)))) then
				v30 = v116.HandleTopTrinket(v103, v33, 10 + 30, nil);
				if (((759 + 3981) >= (7913 - 4761)) and v30) then
					return v30;
				end
				v167 = 455 - (233 + 221);
			end
		end
	end
	local function v138()
		local v168 = 0 - 0;
		while true do
			if (((0 + 0) == v168) or ((4119 - (718 + 823)) >= (2134 + 1256))) then
				if (((846 - (266 + 539)) <= (4702 - 3041)) and v100.WindfuryTotem:IsReady() and v50 and (v13:BuffDown(v100.WindfuryTotemBuff, true) or (v100.WindfuryTotem:TimeSinceLastCast() > (1315 - (636 + 589))))) then
					if (((1426 - 825) < (7342 - 3782)) and v21(v100.WindfuryTotem)) then
						return "windfury_totem precombat 4";
					end
				end
				if (((187 + 48) < (250 + 437)) and v100.FeralSpirit:IsCastable() and v54 and ((v59 and v33) or not v59)) then
					if (((5564 - (657 + 358)) > (3052 - 1899)) and v21(v100.FeralSpirit)) then
						return "feral_spirit precombat 6";
					end
				end
				v168 = 2 - 1;
			end
			if ((v168 == (1188 - (1151 + 36))) or ((4514 + 160) < (1229 + 3443))) then
				if (((10954 - 7286) < (6393 - (1552 + 280))) and v100.DoomWinds:IsCastable() and v55 and ((v60 and v33) or not v60)) then
					if (v21(v100.DoomWinds, not v14:IsSpellInRange(v100.DoomWinds)) or ((1289 - (64 + 770)) == (2448 + 1157))) then
						return "doom_winds precombat 8";
					end
				end
				if ((v100.Sundering:IsReady() and v49 and ((v61 and v34) or not v61)) or ((6045 - 3382) == (589 + 2723))) then
					if (((5520 - (157 + 1086)) <= (8957 - 4482)) and v21(v100.Sundering, not v14:IsInRange(21 - 16))) then
						return "sundering precombat 10";
					end
				end
				v168 = 2 - 0;
			end
			if (((2 - 0) == v168) or ((1689 - (599 + 220)) == (2367 - 1178))) then
				if (((3484 - (1813 + 118)) <= (2291 + 842)) and v100.Stormstrike:IsReady() and v48) then
					if (v21(v100.Stormstrike, not v14:IsSpellInRange(v100.Stormstrike)) or ((3454 - (841 + 376)) >= (4919 - 1408))) then
						return "stormstrike precombat 12";
					end
				end
				break;
			end
		end
	end
	local function v139()
		local v169 = 0 + 0;
		while true do
			if ((v169 == (5 - 3)) or ((2183 - (464 + 395)) > (7750 - 4730))) then
				if ((v100.ChainLightning:IsReady() and v37 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (4 + 4)) and v13:BuffUp(v100.CracklingThunderBuff) and v100.ElementalSpirits:IsAvailable()) or ((3829 - (467 + 370)) == (3886 - 2005))) then
					if (((2280 + 826) > (5231 - 3705)) and v21(v100.ChainLightning, not v14:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning single 11";
					end
				end
				if (((472 + 2551) < (9003 - 5133)) and v100.ElementalBlast:IsReady() and v39 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (528 - (150 + 370))) and ((v118.FeralSpiritCount >= (1284 - (74 + 1208))) or not v100.ElementalSpirits:IsAvailable())) then
					if (((351 - 208) > (350 - 276)) and v21(v100.ElementalBlast, not v14:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast single 12";
					end
				end
				if (((13 + 5) < (2502 - (14 + 376))) and v100.LavaBurst:IsReady() and v44 and not v100.ThorimsInvocation:IsAvailable() and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (8 - 3))) then
					if (((710 + 387) <= (1431 + 197)) and v21(v100.LavaBurst, not v14:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single 13";
					end
				end
				if (((4416 + 214) == (13566 - 8936)) and v100.LightningBolt:IsReady() and v46 and ((v13:BuffStack(v100.MaelstromWeaponBuff) >= (7 + 1)) or (v100.StaticAccumulation:IsAvailable() and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (83 - (23 + 55))))) and v13:BuffDown(v100.PrimordialWaveBuff)) then
					if (((8389 - 4849) > (1791 + 892)) and v21(v100.LightningBolt, not v14:IsSpellInRange(v100.LightningBolt))) then
						return "lightning_bolt single 14";
					end
				end
				if (((4306 + 488) >= (5077 - 1802)) and v100.CrashLightning:IsReady() and v38 and v100.AlphaWolf:IsAvailable() and v13:BuffUp(v100.FeralSpiritBuff) and (v125() == (0 + 0))) then
					if (((2385 - (652 + 249)) == (3971 - 2487)) and v21(v100.CrashLightning, not v14:IsInMeleeRange(1873 - (708 + 1160)))) then
						return "crash_lightning single 15";
					end
				end
				v169 = 8 - 5;
			end
			if (((2610 - 1178) < (3582 - (10 + 17))) and (v169 == (2 + 3))) then
				if ((v100.Sundering:IsReady() and v49 and ((v61 and v34) or not v61) and (v98 < v115)) or ((2797 - (1400 + 332)) > (6862 - 3284))) then
					if (v21(v100.Sundering, not v14:IsInRange(1916 - (242 + 1666))) or ((2052 + 2743) < (516 + 891))) then
						return "sundering single 26";
					end
				end
				if (((1580 + 273) < (5753 - (850 + 90))) and v100.BagofTricks:IsReady() and v57 and ((v64 and v33) or not v64)) then
					if (v21(v100.BagofTricks) or ((4940 - 2119) < (3821 - (360 + 1030)))) then
						return "bag_of_tricks single 27";
					end
				end
				if ((v100.FireNova:IsReady() and v40 and v100.SwirlingMaelstrom:IsAvailable() and v14:DebuffUp(v100.FlameShockDebuff) and (v13:BuffStack(v100.MaelstromWeaponBuff) < (5 + 0 + ((13 - 8) * v22(v100.OverflowingMaelstrom:IsAvailable()))))) or ((3953 - 1079) < (3842 - (909 + 752)))) then
					if (v21(v100.FireNova) or ((3912 - (109 + 1114)) <= (627 - 284))) then
						return "fire_nova single 28";
					end
				end
				if ((v100.LightningBolt:IsReady() and v46 and v100.Hailstorm:IsAvailable() and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (2 + 3)) and v13:BuffDown(v100.PrimordialWaveBuff)) or ((2111 - (6 + 236)) == (1266 + 743))) then
					if (v21(v100.LightningBolt, not v14:IsSpellInRange(v100.LightningBolt)) or ((2855 + 691) < (5475 - 3153))) then
						return "lightning_bolt single 29";
					end
				end
				if ((v100.FrostShock:IsReady() and v42) or ((3636 - 1554) == (5906 - (1076 + 57)))) then
					if (((534 + 2710) > (1744 - (579 + 110))) and v21(v100.FrostShock, not v14:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single 30";
					end
				end
				v169 = 1 + 5;
			end
			if ((v169 == (7 + 0)) or ((1759 + 1554) <= (2185 - (174 + 233)))) then
				if ((v100.WindfuryTotem:IsReady() and v50 and (v13:BuffDown(v100.WindfuryTotemBuff, true) or (v100.WindfuryTotem:TimeSinceLastCast() > (251 - 161)))) or ((2493 - 1072) >= (936 + 1168))) then
					if (((2986 - (663 + 511)) <= (2899 + 350)) and v21(v100.WindfuryTotem)) then
						return "windfury_totem single 36";
					end
				end
				break;
			end
			if (((353 + 1270) <= (6033 - 4076)) and (v169 == (3 + 1))) then
				if (((10387 - 5975) == (10680 - 6268)) and v100.FrostShock:IsReady() and v42 and (v13:BuffUp(v100.HailstormBuff))) then
					if (((836 + 914) >= (1638 - 796)) and v21(v100.FrostShock, not v14:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single 21";
					end
				end
				if (((3116 + 1256) > (170 + 1680)) and v100.LavaLash:IsReady() and v45) then
					if (((954 - (478 + 244)) < (1338 - (440 + 77))) and v21(v100.LavaLash, not v14:IsSpellInRange(v100.LavaLash))) then
						return "lava_lash single 22";
					end
				end
				if (((236 + 282) < (3301 - 2399)) and v100.IceStrike:IsReady() and v43) then
					if (((4550 - (655 + 901)) > (160 + 698)) and v21(v100.IceStrike, not v14:IsInMeleeRange(4 + 1))) then
						return "ice_strike single 23";
					end
				end
				if ((v100.Windstrike:IsCastable() and v51) or ((2536 + 1219) <= (3686 - 2771))) then
					if (((5391 - (695 + 750)) > (12780 - 9037)) and v21(v100.Windstrike, not v14:IsSpellInRange(v100.Windstrike))) then
						return "windstrike single 24";
					end
				end
				if ((v100.Stormstrike:IsReady() and v48) or ((2059 - 724) >= (13295 - 9989))) then
					if (((5195 - (285 + 66)) > (5251 - 2998)) and v21(v100.Stormstrike, not v14:IsSpellInRange(v100.Stormstrike))) then
						return "stormstrike single 25";
					end
				end
				v169 = 1315 - (682 + 628);
			end
			if (((73 + 379) == (751 - (176 + 123))) and (v169 == (1 + 0))) then
				if ((v100.Stormstrike:IsReady() and v48 and (v13:BuffUp(v100.DoomWindsBuff) or v100.DeeplyRootedElements:IsAvailable() or (v100.Stormblast:IsAvailable() and v13:BuffUp(v100.StormbringerBuff)))) or ((3306 + 1251) < (2356 - (239 + 30)))) then
					if (((1054 + 2820) == (3724 + 150)) and v21(v100.Stormstrike, not v14:IsSpellInRange(v100.Stormstrike))) then
						return "stormstrike single 6";
					end
				end
				if ((v100.LavaLash:IsReady() and v45 and (v13:BuffUp(v100.HotHandBuff))) or ((3429 - 1491) > (15396 - 10461))) then
					if (v21(v100.LavaLash, not v14:IsSpellInRange(v100.LavaLash)) or ((4570 - (306 + 9)) < (11944 - 8521))) then
						return "lava_lash single 7";
					end
				end
				if (((253 + 1201) <= (1529 + 962)) and v100.WindfuryTotem:IsReady() and v50 and (v13:BuffDown(v100.WindfuryTotemBuff, true))) then
					if (v21(v100.WindfuryTotem) or ((2001 + 2156) <= (8015 - 5212))) then
						return "windfury_totem single 8";
					end
				end
				if (((6228 - (1140 + 235)) >= (1898 + 1084)) and v100.ElementalBlast:IsReady() and v39 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (5 + 0)) and (v100.ElementalBlast:Charges() == v112)) then
					if (((1061 + 3073) > (3409 - (33 + 19))) and v21(v100.ElementalBlast, not v14:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast single 9";
					end
				end
				if ((v100.LightningBolt:IsReady() and v46 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (3 + 5)) and v13:BuffUp(v100.PrimordialWaveBuff) and (v13:BuffDown(v100.SplinteredElementsBuff) or (v115 <= (35 - 23)))) or ((1506 + 1911) < (4969 - 2435))) then
					if (v21(v100.LightningBolt, not v14:IsSpellInRange(v100.LightningBolt)) or ((2553 + 169) <= (853 - (586 + 103)))) then
						return "lightning_bolt single 10";
					end
				end
				v169 = 1 + 1;
			end
			if ((v169 == (9 - 6)) or ((3896 - (1309 + 179)) < (3806 - 1697))) then
				if ((v100.PrimordialWave:IsCastable() and v47 and ((v62 and v34) or not v62) and (v98 < v115)) or ((15 + 18) == (3907 - 2452))) then
					if (v21(v100.PrimordialWave, not v14:IsSpellInRange(v100.PrimordialWave)) or ((335 + 108) >= (8530 - 4515))) then
						return "primordial_wave single 16";
					end
				end
				if (((6738 - 3356) > (775 - (295 + 314))) and v100.FlameShock:IsReady() and v41 and (v14:DebuffDown(v100.FlameShockDebuff))) then
					if (v21(v100.FlameShock, not v14:IsSpellInRange(v100.FlameShock)) or ((687 - 407) == (5021 - (1300 + 662)))) then
						return "flame_shock single 17";
					end
				end
				if (((5906 - 4025) > (3048 - (1178 + 577))) and v100.IceStrike:IsReady() and v43 and v100.ElementalAssault:IsAvailable() and v100.SwirlingMaelstrom:IsAvailable()) then
					if (((1225 + 1132) == (6967 - 4610)) and v21(v100.IceStrike, not v14:IsInMeleeRange(1410 - (851 + 554)))) then
						return "ice_strike single 18";
					end
				end
				if (((109 + 14) == (341 - 218)) and v100.LavaLash:IsReady() and v45 and (v100.LashingFlames:IsAvailable())) then
					if (v21(v100.LavaLash, not v14:IsSpellInRange(v100.LavaLash)) or ((2293 - 1237) >= (3694 - (115 + 187)))) then
						return "lava_lash single 19";
					end
				end
				if ((v100.IceStrike:IsReady() and v43 and (v13:BuffDown(v100.IceStrikeBuff))) or ((828 + 253) < (1018 + 57))) then
					if (v21(v100.IceStrike, not v14:IsInMeleeRange(19 - 14)) or ((2210 - (160 + 1001)) >= (3878 + 554))) then
						return "ice_strike single 20";
					end
				end
				v169 = 3 + 1;
			end
			if (((11 - 5) == v169) or ((5126 - (237 + 121)) <= (1743 - (525 + 372)))) then
				if ((v100.CrashLightning:IsReady() and v38) or ((6366 - 3008) <= (4665 - 3245))) then
					if (v21(v100.CrashLightning, not v14:IsInMeleeRange(147 - (96 + 46))) or ((4516 - (643 + 134)) <= (1085 + 1920))) then
						return "crash_lightning single 31";
					end
				end
				if ((v100.FireNova:IsReady() and v40 and (v14:DebuffUp(v100.FlameShockDebuff))) or ((3977 - 2318) >= (7922 - 5788))) then
					if (v21(v100.FireNova) or ((3127 + 133) < (4621 - 2266))) then
						return "fire_nova single 32";
					end
				end
				if ((v100.FlameShock:IsReady() and v41) or ((1367 - 698) == (4942 - (316 + 403)))) then
					if (v21(v100.FlameShock, not v14:IsSpellInRange(v100.FlameShock)) or ((1125 + 567) < (1616 - 1028))) then
						return "flame_shock single 33";
					end
				end
				if ((v100.ChainLightning:IsReady() and v37 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (2 + 3)) and v13:BuffUp(v100.CracklingThunderBuff) and v100.ElementalSpirits:IsAvailable()) or ((12080 - 7283) < (2588 + 1063))) then
					if (v21(v100.ChainLightning, not v14:IsSpellInRange(v100.ChainLightning)) or ((1347 + 2830) > (16805 - 11955))) then
						return "chain_lightning single 34";
					end
				end
				if ((v100.LightningBolt:IsReady() and v46 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (23 - 18)) and v13:BuffDown(v100.PrimordialWaveBuff)) or ((830 - 430) > (64 + 1047))) then
					if (((6006 - 2955) > (50 + 955)) and v21(v100.LightningBolt, not v14:IsSpellInRange(v100.LightningBolt))) then
						return "lightning_bolt single 35";
					end
				end
				v169 = 20 - 13;
			end
			if (((3710 - (12 + 5)) <= (17019 - 12637)) and ((0 - 0) == v169)) then
				if ((v100.PrimordialWave:IsCastable() and v47 and ((v62 and v34) or not v62) and (v98 < v115) and v14:DebuffDown(v100.FlameShockDebuff) and v100.LashingFlames:IsAvailable()) or ((6976 - 3694) > (10167 - 6067))) then
					if (v21(v100.PrimordialWave, not v14:IsSpellInRange(v100.PrimordialWave)) or ((727 + 2853) < (4817 - (1656 + 317)))) then
						return "primordial_wave single 1";
					end
				end
				if (((80 + 9) < (3598 + 892)) and v100.FlameShock:IsReady() and v41 and v14:DebuffDown(v100.FlameShockDebuff) and v100.LashingFlames:IsAvailable()) then
					if (v21(v100.FlameShock, not v14:IsSpellInRange(v100.FlameShock)) or ((13249 - 8266) < (8898 - 7090))) then
						return "flame_shock single 2";
					end
				end
				if (((4183 - (5 + 349)) > (17902 - 14133)) and v100.ElementalBlast:IsReady() and v39 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (1276 - (266 + 1005))) and v100.ElementalSpirits:IsAvailable() and (v118.FeralSpiritCount >= (3 + 1))) then
					if (((5066 - 3581) <= (3822 - 918)) and v21(v100.ElementalBlast, not v14:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast single 3";
					end
				end
				if (((5965 - (561 + 1135)) == (5562 - 1293)) and v100.Sundering:IsReady() and v49 and ((v61 and v34) or not v61) and (v98 < v115) and (v13:HasTier(98 - 68, 1068 - (507 + 559)))) then
					if (((970 - 583) <= (8603 - 5821)) and v21(v100.Sundering, not v14:IsInRange(396 - (212 + 176)))) then
						return "sundering single 4";
					end
				end
				if ((v100.LightningBolt:IsReady() and v46 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (910 - (250 + 655))) and v13:BuffDown(v100.CracklingThunderBuff) and v13:BuffUp(v100.AscendanceBuff) and (v113 == "Chain Lightning") and (v13:BuffRemains(v100.AscendanceBuff) > (v100.ChainLightning:CooldownRemains() + v13:GCD()))) or ((5178 - 3279) <= (1601 - 684))) then
					if (v21(v100.LightningBolt, not v14:IsSpellInRange(v100.LightningBolt)) or ((6746 - 2434) <= (2832 - (1869 + 87)))) then
						return "lightning_bolt single 5";
					end
				end
				v169 = 3 - 2;
			end
		end
	end
	local function v140()
		local v170 = 1901 - (484 + 1417);
		while true do
			if (((4783 - 2551) <= (4349 - 1753)) and ((774 - (48 + 725)) == v170)) then
				if (((3422 - 1327) < (9888 - 6202)) and v100.ChainLightning:IsReady() and v37 and (v13:BuffStack(v100.MaelstromWeaponBuff) == (3 + 2 + ((13 - 8) * v22(v100.OverflowingMaelstrom:IsAvailable()))))) then
					if (v21(v100.ChainLightning, not v14:IsSpellInRange(v100.ChainLightning)) or ((447 + 1148) >= (1304 + 3170))) then
						return "chain_lightning aoe 7";
					end
				end
				if ((v100.CrashLightning:IsReady() and v38 and (v13:BuffUp(v100.DoomWindsBuff) or v13:BuffDown(v100.CrashLightningBuff) or (v100.AlphaWolf:IsAvailable() and v13:BuffUp(v100.FeralSpiritBuff) and (v125() == (853 - (152 + 701)))))) or ((5930 - (430 + 881)) < (1104 + 1778))) then
					if (v21(v100.CrashLightning, not v14:IsInMeleeRange(900 - (557 + 338))) or ((87 + 207) >= (13613 - 8782))) then
						return "crash_lightning aoe 8";
					end
				end
				if (((7104 - 5075) <= (8193 - 5109)) and v100.Sundering:IsReady() and v49 and ((v61 and v34) or not v61) and (v98 < v115) and (v13:BuffUp(v100.DoomWindsBuff) or v13:HasTier(64 - 34, 803 - (499 + 302)))) then
					if (v21(v100.Sundering, not v14:IsInRange(874 - (39 + 827))) or ((5623 - 3586) == (5404 - 2984))) then
						return "sundering aoe 9";
					end
				end
				if (((17706 - 13248) > (5993 - 2089)) and v100.FireNova:IsReady() and v40 and ((v100.FlameShockDebuff:AuraActiveCount() >= (1 + 5)) or ((v100.FlameShockDebuff:AuraActiveCount() >= (11 - 7)) and (v100.FlameShockDebuff:AuraActiveCount() >= v110)))) then
					if (((70 + 366) >= (194 - 71)) and v21(v100.FireNova)) then
						return "fire_nova aoe 10";
					end
				end
				if (((604 - (103 + 1)) < (2370 - (475 + 79))) and v100.LavaLash:IsReady() and v45 and (v100.LashingFlames:IsAvailable())) then
					if (((7725 - 4151) == (11436 - 7862)) and v116.CastCycle(v100.LavaLash, v109, v127, not v14:IsSpellInRange(v100.LavaLash))) then
						return "lava_lash aoe 11";
					end
				end
				if (((29 + 192) < (344 + 46)) and v100.LavaLash:IsReady() and v45 and ((v100.MoltenAssault:IsAvailable() and v14:DebuffUp(v100.FlameShockDebuff) and (v100.FlameShockDebuff:AuraActiveCount() < v110) and (v100.FlameShockDebuff:AuraActiveCount() < (1509 - (1395 + 108)))) or (v100.AshenCatalyst:IsAvailable() and (v13:BuffStack(v100.AshenCatalystBuff) == (14 - 9))))) then
					if (v21(v100.LavaLash, not v14:IsSpellInRange(v100.LavaLash)) or ((3417 - (7 + 1197)) <= (620 + 801))) then
						return "lava_lash aoe 12";
					end
				end
				v170 = 1 + 1;
			end
			if (((3377 - (27 + 292)) < (14241 - 9381)) and ((2 - 0) == v170)) then
				if ((v100.IceStrike:IsReady() and v43 and (v100.Hailstorm:IsAvailable())) or ((5435 - 4139) >= (8767 - 4321))) then
					if (v21(v100.IceStrike, not v14:IsInMeleeRange(9 - 4)) or ((1532 - (43 + 96)) > (18310 - 13821))) then
						return "ice_strike aoe 13";
					end
				end
				if ((v100.FrostShock:IsReady() and v42 and v100.Hailstorm:IsAvailable() and v13:BuffUp(v100.HailstormBuff)) or ((10001 - 5577) < (23 + 4))) then
					if (v21(v100.FrostShock, not v14:IsSpellInRange(v100.FrostShock)) or ((564 + 1433) > (7540 - 3725))) then
						return "frost_shock aoe 14";
					end
				end
				if (((1328 + 2137) > (3585 - 1672)) and v100.Sundering:IsReady() and v49 and ((v61 and v34) or not v61) and (v98 < v115)) then
					if (((231 + 502) < (134 + 1685)) and v21(v100.Sundering, not v14:IsInRange(1759 - (1414 + 337)))) then
						return "sundering aoe 15";
					end
				end
				if ((v100.FlameShock:IsReady() and v41 and v100.MoltenAssault:IsAvailable() and v14:DebuffDown(v100.FlameShockDebuff)) or ((6335 - (1642 + 298)) == (12395 - 7640))) then
					if (v21(v100.FlameShock, not v14:IsSpellInRange(v100.FlameShock)) or ((10911 - 7118) < (7029 - 4660))) then
						return "flame_shock aoe 16";
					end
				end
				if ((v100.FlameShock:IsReady() and v41 and v14:DebuffRefreshable(v100.FlameShockDebuff) and (v100.FireNova:IsAvailable() or v100.PrimordialWave:IsAvailable()) and (v100.FlameShockDebuff:AuraActiveCount() < v110) and (v100.FlameShockDebuff:AuraActiveCount() < (2 + 4))) or ((3178 + 906) == (1237 - (357 + 615)))) then
					if (((3060 + 1298) == (10693 - 6335)) and v116.CastCycle(v100.FlameShock, v109, v126, not v14:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock aoe 17";
					end
				end
				if ((v100.FireNova:IsReady() and v40 and (v100.FlameShockDebuff:AuraActiveCount() >= (3 + 0))) or ((6724 - 3586) < (795 + 198))) then
					if (((227 + 3103) > (1461 + 862)) and v21(v100.FireNova)) then
						return "fire_nova aoe 18";
					end
				end
				v170 = 1304 - (384 + 917);
			end
			if ((v170 == (700 - (128 + 569))) or ((5169 - (1407 + 136)) == (5876 - (687 + 1200)))) then
				if ((v100.Stormstrike:IsReady() and v48 and v13:BuffUp(v100.CrashLightningBuff) and (v100.DeeplyRootedElements:IsAvailable() or (v13:BuffStack(v100.ConvergingStormsBuff) == (1716 - (556 + 1154))))) or ((3222 - 2306) == (2766 - (9 + 86)))) then
					if (((693 - (275 + 146)) == (45 + 227)) and v21(v100.Stormstrike, not v14:IsSpellInRange(v100.Stormstrike))) then
						return "stormstrike aoe 19";
					end
				end
				if (((4313 - (29 + 35)) <= (21446 - 16607)) and v100.CrashLightning:IsReady() and v38 and v100.CrashingStorms:IsAvailable() and v13:BuffUp(v100.CLCrashLightningBuff) and (v110 >= (11 - 7))) then
					if (((12259 - 9482) < (2085 + 1115)) and v21(v100.CrashLightning, not v14:IsInMeleeRange(1017 - (53 + 959)))) then
						return "crash_lightning aoe 20";
					end
				end
				if (((503 - (312 + 96)) < (3396 - 1439)) and v100.Windstrike:IsCastable() and v51) then
					if (((1111 - (147 + 138)) < (2616 - (813 + 86))) and v21(v100.Windstrike, not v14:IsSpellInRange(v100.Windstrike))) then
						return "windstrike aoe 21";
					end
				end
				if (((1289 + 137) >= (2046 - 941)) and v100.Stormstrike:IsReady() and v48) then
					if (((3246 - (18 + 474)) <= (1140 + 2239)) and v21(v100.Stormstrike, not v14:IsSpellInRange(v100.Stormstrike))) then
						return "stormstrike aoe 22";
					end
				end
				if ((v100.IceStrike:IsReady() and v43) or ((12817 - 8890) == (2499 - (860 + 226)))) then
					if (v21(v100.IceStrike, not v14:IsInMeleeRange(308 - (121 + 182))) or ((143 + 1011) <= (2028 - (988 + 252)))) then
						return "ice_strike aoe 23";
					end
				end
				if ((v100.LavaLash:IsReady() and v45) or ((186 + 1457) > (1059 + 2320))) then
					if (v21(v100.LavaLash, not v14:IsSpellInRange(v100.LavaLash)) or ((4773 - (49 + 1921)) > (5439 - (223 + 667)))) then
						return "lava_lash aoe 24";
					end
				end
				v170 = 56 - (51 + 1);
			end
			if ((v170 == (8 - 3)) or ((471 - 251) >= (4147 - (146 + 979)))) then
				if (((797 + 2025) == (3427 - (311 + 294))) and v100.FrostShock:IsReady() and v42 and not v100.Hailstorm:IsAvailable()) then
					if (v21(v100.FrostShock, not v14:IsSpellInRange(v100.FrostShock)) or ((2958 - 1897) == (787 + 1070))) then
						return "frost_shock aoe 31";
					end
				end
				break;
			end
			if (((4203 - (496 + 947)) > (2722 - (1233 + 125))) and (v170 == (0 + 0))) then
				if ((v100.CrashLightning:IsReady() and v38 and v100.CrashingStorms:IsAvailable() and ((v100.UnrulyWinds:IsAvailable() and (v110 >= (9 + 1))) or (v110 >= (3 + 12)))) or ((6547 - (963 + 682)) <= (3001 + 594))) then
					if (v21(v100.CrashLightning, not v14:IsInMeleeRange(1509 - (504 + 1000))) or ((2595 + 1257) == (267 + 26))) then
						return "crash_lightning aoe 1";
					end
				end
				if ((v100.LightningBolt:IsReady() and v46 and ((v14:DebuffStack(v100.FlameShockDebuff) >= v110) or (v14:DebuffStack(v100.FlameShockDebuff) >= (1 + 5))) and v13:BuffUp(v100.PrimordialWaveBuff) and (v13:BuffStack(v100.MaelstromWeaponBuff) == ((7 - 2) + ((5 + 0) * v22(v100.OverflowingMaelstrom:IsAvailable())))) and (v13:BuffDown(v100.SplinteredElementsBuff) or (v115 <= (7 + 5)) or (v98 <= v13:GCD()))) or ((1741 - (156 + 26)) == (2644 + 1944))) then
					if (v21(v100.LightningBolt, not v14:IsSpellInRange(v100.LightningBolt)) or ((7015 - 2531) == (952 - (149 + 15)))) then
						return "lightning_bolt aoe 2";
					end
				end
				if (((5528 - (890 + 70)) >= (4024 - (39 + 78))) and v100.LavaLash:IsReady() and v45 and v100.MoltenAssault:IsAvailable() and (v100.PrimordialWave:IsAvailable() or v100.FireNova:IsAvailable()) and v14:DebuffUp(v100.FlameShockDebuff) and (v100.FlameShockDebuff:AuraActiveCount() < v110) and (v100.FlameShockDebuff:AuraActiveCount() < (488 - (14 + 468)))) then
					if (((2739 - 1493) < (9698 - 6228)) and v21(v100.LavaLash, not v14:IsSpellInRange(v100.LavaLash))) then
						return "lava_lash aoe 3";
					end
				end
				if (((2099 + 1969) >= (584 + 388)) and v100.PrimordialWave:IsCastable() and v47 and ((v62 and v34) or not v62) and (v98 < v115) and (v13:BuffDown(v100.PrimordialWaveBuff))) then
					if (((105 + 388) < (1759 + 2134)) and v116.CastCycle(v100.PrimordialWave, v109, v126, not v14:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave aoe 4";
					end
				end
				if ((v100.FlameShock:IsReady() and v41 and (v100.PrimordialWave:IsAvailable() or v100.FireNova:IsAvailable()) and v14:DebuffDown(v100.FlameShockDebuff)) or ((386 + 1087) >= (6377 - 3045))) then
					if (v21(v100.FlameShock, not v14:IsSpellInRange(v100.FlameShock)) or ((4004 + 47) <= (4065 - 2908))) then
						return "flame_shock aoe 5";
					end
				end
				if (((16 + 588) < (2932 - (12 + 39))) and v100.ElementalBlast:IsReady() and v39 and (not v100.ElementalSpirits:IsAvailable() or (v100.ElementalSpirits:IsAvailable() and ((v100.ElementalBlast:Charges() == v112) or (v118.FeralSpiritCount >= (2 + 0))))) and (v13:BuffStack(v100.MaelstromWeaponBuff) == ((15 - 10) + ((17 - 12) * v22(v100.OverflowingMaelstrom:IsAvailable())))) and (not v100.CrashingStorms:IsAvailable() or (v110 <= (1 + 2)))) then
					if (v21(v100.ElementalBlast, not v14:IsSpellInRange(v100.ElementalBlast)) or ((474 + 426) == (8562 - 5185))) then
						return "elemental_blast aoe 6";
					end
				end
				v170 = 1 + 0;
			end
			if (((21549 - 17090) > (2301 - (1596 + 114))) and (v170 == (10 - 6))) then
				if (((4111 - (164 + 549)) >= (3833 - (1059 + 379))) and v100.CrashLightning:IsReady() and v38) then
					if (v21(v100.CrashLightning, not v14:IsInMeleeRange(6 - 1)) or ((1132 + 1051) >= (477 + 2347))) then
						return "crash_lightning aoe 25";
					end
				end
				if (((2328 - (145 + 247)) == (1589 + 347)) and v100.FireNova:IsReady() and v40 and (v100.FlameShockDebuff:AuraActiveCount() >= (1 + 1))) then
					if (v21(v100.FireNova) or ((14325 - 9493) < (828 + 3485))) then
						return "fire_nova aoe 26";
					end
				end
				if (((3522 + 566) > (6290 - 2416)) and v100.ElementalBlast:IsReady() and v39 and (not v100.ElementalSpirits:IsAvailable() or (v100.ElementalSpirits:IsAvailable() and ((v100.ElementalBlast:Charges() == v112) or (v118.FeralSpiritCount >= (722 - (254 + 466)))))) and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (565 - (544 + 16))) and (not v100.CrashingStorms:IsAvailable() or (v110 <= (9 - 6)))) then
					if (((4960 - (294 + 334)) == (4585 - (236 + 17))) and v21(v100.ElementalBlast, not v14:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast aoe 27";
					end
				end
				if (((1724 + 2275) >= (2258 + 642)) and v100.ChainLightning:IsReady() and v37 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (18 - 13))) then
					if (v21(v100.ChainLightning, not v14:IsSpellInRange(v100.ChainLightning)) or ((11954 - 9429) > (2093 + 1971))) then
						return "chain_lightning aoe 28";
					end
				end
				if (((3601 + 770) == (5165 - (413 + 381))) and v100.WindfuryTotem:IsReady() and v50 and (v13:BuffDown(v100.WindfuryTotemBuff, true) or (v100.WindfuryTotem:TimeSinceLastCast() > (4 + 86)))) then
					if (v21(v100.WindfuryTotem) or ((565 - 299) > (12951 - 7965))) then
						return "windfury_totem aoe 29";
					end
				end
				if (((3961 - (582 + 1388)) >= (1575 - 650)) and v100.FlameShock:IsReady() and v41 and (v14:DebuffDown(v100.FlameShockDebuff))) then
					if (((326 + 129) < (2417 - (326 + 38))) and v21(v100.FlameShock, not v14:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock aoe 30";
					end
				end
				v170 = 14 - 9;
			end
		end
	end
	local function v141()
		local v171 = 0 - 0;
		while true do
			if ((v171 == (625 - (47 + 573))) or ((292 + 534) == (20602 - 15751))) then
				if (((296 - 113) == (1847 - (1269 + 395))) and v100.WindfuryTotem:IsReady() and v50 and (v13:BuffDown(v100.WindfuryTotemBuff, true) or (v100.WindfuryTotem:TimeSinceLastCast() > (582 - (76 + 416))))) then
					if (((1602 - (319 + 124)) <= (4087 - 2299)) and v21(v100.WindfuryTotem)) then
						return "windfury_totem funnel 31";
					end
				end
				if ((v100.FlameShock:IsReady() and v41 and (v14:DebuffDown(v100.FlameShockDebuff))) or ((4514 - (564 + 443)) > (11953 - 7635))) then
					if (v21(v100.FlameShock, not v14:IsSpellInRange(v100.FlameShock)) or ((3533 - (337 + 121)) <= (8687 - 5722))) then
						return "flame_shock funnel 32";
					end
				end
				if (((4546 - 3181) <= (3922 - (1261 + 650))) and v100.FrostShock:IsReady() and v42 and not v100.Hailstorm:IsAvailable()) then
					if (v21(v100.FrostShock, not v14:IsSpellInRange(v100.FrostShock)) or ((1175 + 1601) > (5697 - 2122))) then
						return "frost_shock funnel 33";
					end
				end
				break;
			end
			if ((v171 == (1819 - (772 + 1045))) or ((361 + 2193) == (4948 - (102 + 42)))) then
				if (((4421 - (1524 + 320)) == (3847 - (1049 + 221))) and v100.FireNova:IsReady() and v40 and ((v100.FlameShockDebuff:AuraActiveCount() == (162 - (18 + 138))) or ((v100.FlameShockDebuff:AuraActiveCount() >= (9 - 5)) and (v100.FlameShockDebuff:AuraActiveCount() >= v110)))) then
					if (v21(v100.FireNova) or ((1108 - (67 + 1035)) >= (2237 - (136 + 212)))) then
						return "fire_nova funnel 13";
					end
				end
				if (((2150 - 1644) <= (1516 + 376)) and v100.IceStrike:IsReady() and v43 and v100.Hailstorm:IsAvailable() and v13:BuffDown(v100.IceStrikeBuff)) then
					if (v21(v100.IceStrike, not v14:IsInMeleeRange(5 + 0)) or ((3612 - (240 + 1364)) > (3300 - (1050 + 32)))) then
						return "ice_strike funnel 14";
					end
				end
				if (((1353 - 974) <= (2453 + 1694)) and v100.FrostShock:IsReady() and v42 and v100.Hailstorm:IsAvailable() and v13:BuffUp(v100.HailstormBuff)) then
					if (v21(v100.FrostShock, not v14:IsSpellInRange(v100.FrostShock)) or ((5569 - (331 + 724)) <= (82 + 927))) then
						return "frost_shock funnel 15";
					end
				end
				if ((v100.Sundering:IsReady() and v49 and ((v61 and v34) or not v61) and (v98 < v115)) or ((4140 - (269 + 375)) == (1917 - (267 + 458)))) then
					if (v21(v100.Sundering, not v14:IsInRange(3 + 5)) or ((399 - 191) == (3777 - (667 + 151)))) then
						return "sundering funnel 16";
					end
				end
				if (((5774 - (1410 + 87)) >= (3210 - (1504 + 393))) and v100.FlameShock:IsReady() and v41 and v100.MoltenAssault:IsAvailable() and v14:DebuffDown(v100.FlameShockDebuff)) then
					if (((6992 - 4405) < (8234 - 5060)) and v21(v100.FlameShock, not v14:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock funnel 17";
					end
				end
				if ((v100.FlameShock:IsReady() and v41 and (v100.FireNova:IsAvailable() or v100.PrimordialWave:IsAvailable()) and (v100.FlameShockDebuff:AuraActiveCount() < v110) and (v100.FlameShockDebuff:AuraActiveCount() < (802 - (461 + 335)))) or ((527 + 3593) <= (3959 - (1730 + 31)))) then
					if (v116.CastCycle(v100.FlameShock, v109, v126, not v14:IsSpellInRange(v100.FlameShock)) or ((3263 - (728 + 939)) == (3038 - 2180))) then
						return "flame_shock funnel 18";
					end
				end
				v171 = 5 - 2;
			end
			if (((7377 - 4157) == (4288 - (138 + 930))) and (v171 == (3 + 0))) then
				if ((v100.FireNova:IsReady() and v40 and (v100.FlameShockDebuff:AuraActiveCount() >= (3 + 0))) or ((1202 + 200) > (14781 - 11161))) then
					if (((4340 - (459 + 1307)) == (4444 - (474 + 1396))) and v21(v100.FireNova)) then
						return "fire_nova funnel 19";
					end
				end
				if (((3139 - 1341) < (2584 + 173)) and v100.Stormstrike:IsReady() and v48 and v13:BuffUp(v100.CrashLightningBuff) and v100.DeeplyRootedElements:IsAvailable()) then
					if (v21(v100.Stormstrike, not v14:IsSpellInRange(v100.Stormstrike)) or ((2 + 375) > (7458 - 4854))) then
						return "stormstrike funnel 20";
					end
				end
				if (((72 + 496) < (3041 - 2130)) and v100.CrashLightning:IsReady() and v38 and v100.CrashingStorms:IsAvailable() and v13:BuffUp(v100.CLCrashLightningBuff) and (v110 >= (17 - 13))) then
					if (((3876 - (562 + 29)) < (3605 + 623)) and v21(v100.CrashLightning, not v14:IsInMeleeRange(1424 - (374 + 1045)))) then
						return "crash_lightning funnel 21";
					end
				end
				if (((3100 + 816) > (10334 - 7006)) and v100.Windstrike:IsCastable() and v51) then
					if (((3138 - (448 + 190)) < (1240 + 2599)) and v21(v100.Windstrike, not v14:IsSpellInRange(v100.Windstrike))) then
						return "windstrike funnel 22";
					end
				end
				if (((229 + 278) == (331 + 176)) and v100.Stormstrike:IsReady() and v48) then
					if (((922 - 682) <= (9834 - 6669)) and v21(v100.Stormstrike, not v14:IsSpellInRange(v100.Stormstrike))) then
						return "stormstrike funnel 23";
					end
				end
				if (((2328 - (1307 + 187)) >= (3192 - 2387)) and v100.IceStrike:IsReady() and v43) then
					if (v21(v100.IceStrike, not v14:IsInMeleeRange(11 - 6)) or ((11688 - 7876) < (2999 - (232 + 451)))) then
						return "ice_strike funnel 24";
					end
				end
				v171 = 4 + 0;
			end
			if ((v171 == (0 + 0)) or ((3216 - (510 + 54)) <= (3088 - 1555))) then
				if ((v100.LightningBolt:IsReady() and v46 and ((v14:DebuffStack(v100.FlameShockDebuff) >= v110) or (v14:DebuffStack(v100.FlameShockDebuff) == (42 - (13 + 23)))) and v13:BuffUp(v100.PrimordialWaveBuff) and (v13:BuffStack(v100.MaelstromWeaponBuff) == ((9 - 4) + ((6 - 1) * v22(v100.OverflowingMaelstrom:IsAvailable())))) and (v13:BuffDown(v100.SplinteredElementsBuff) or (v115 <= (21 - 9)) or (v98 <= v13:GCD()))) or ((4686 - (830 + 258)) < (5150 - 3690))) then
					if (v21(v100.LightningBolt, not v14:IsSpellInRange(v100.LightningBolt)) or ((2576 + 1540) < (1015 + 177))) then
						return "lightning_bolt funnel 1";
					end
				end
				if ((v100.LavaLash:IsReady() and v45 and ((v100.MoltenAssault:IsAvailable() and v14:DebuffUp(v100.FlameShockDebuff) and (v100.FlameShockDebuff:AuraActiveCount() < v110) and (v100.FlameShockDebuff:AuraActiveCount() < (1447 - (860 + 581)))) or (v100.AshenCatalyst:IsAvailable() and (v13:BuffStack(v100.AshenCatalystBuff) == (18 - 13))))) or ((2681 + 696) <= (1144 - (237 + 4)))) then
					if (((9344 - 5368) >= (1110 - 671)) and v21(v100.LavaLash, not v14:IsSpellInRange(v100.LavaLash))) then
						return "lava_lash funnel 2";
					end
				end
				if (((7113 - 3361) == (3071 + 681)) and v100.PrimordialWave:IsCastable() and v47 and ((v62 and v34) or not v62) and (v98 < v115) and (v13:BuffDown(v100.PrimordialWaveBuff))) then
					if (((2324 + 1722) > (10174 - 7479)) and v116.CastCycle(v100.PrimordialWave, v109, v126, not v14:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave funnel 3";
					end
				end
				if ((v100.FlameShock:IsReady() and v41 and (v100.PrimordialWave:IsAvailable() or v100.FireNova:IsAvailable()) and v14:DebuffDown(v100.FlameShockDebuff)) or ((1522 + 2023) == (1739 + 1458))) then
					if (((3820 - (85 + 1341)) > (635 - 262)) and v21(v100.FlameShock, not v14:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock funnel 4";
					end
				end
				if (((11734 - 7579) <= (4604 - (45 + 327))) and v100.ElementalBlast:IsReady() and v39 and (not v100.ElementalSpirits:IsAvailable() or (v100.ElementalSpirits:IsAvailable() and ((v100.ElementalBlast:Charges() == v112) or v13:BuffUp(v100.FeralSpiritBuff)))) and (v13:BuffStack(v100.MaelstromWeaponBuff) == ((9 - 4) + ((507 - (444 + 58)) * v22(v100.OverflowingMaelstrom:IsAvailable()))))) then
					if (v21(v100.ElementalBlast, not v14:IsSpellInRange(v100.ElementalBlast)) or ((1557 + 2024) == (598 + 2875))) then
						return "elemental_blast funnel 5";
					end
				end
				if (((2442 + 2553) > (9702 - 6354)) and v100.Windstrike:IsCastable() and v51 and ((v100.ThorimsInvocation:IsAvailable() and (v13:BuffStack(v100.MaelstromWeaponBuff) > (1733 - (64 + 1668)))) or (v13:BuffStack(v100.ConvergingStormsBuff) == (1979 - (1227 + 746))))) then
					if (v21(v100.Windstrike, not v14:IsSpellInRange(v100.Windstrike)) or ((2317 - 1563) > (6910 - 3186))) then
						return "windstrike funnel 6";
					end
				end
				v171 = 495 - (415 + 79);
			end
			if (((6 + 211) >= (548 - (142 + 349))) and (v171 == (1 + 0))) then
				if ((v100.Stormstrike:IsReady() and v48 and (v13:BuffStack(v100.ConvergingStormsBuff) == (7 - 1))) or ((1029 + 1041) >= (2845 + 1192))) then
					if (((7366 - 4661) == (4569 - (1710 + 154))) and v21(v100.Stormstrike, not v14:IsSpellInRange(v100.Stormstrike))) then
						return "stormstrike funnel 7";
					end
				end
				if (((379 - (200 + 118)) == (25 + 36)) and v100.ChainLightning:IsReady() and v37 and (v13:BuffStack(v100.MaelstromWeaponBuff) == ((8 - 3) + ((7 - 2) * v22(v100.OverflowingMaelstrom:IsAvailable())))) and v13:BuffUp(v100.CracklingThunderBuff)) then
					if (v21(v100.ChainLightning, not v14:IsSpellInRange(v100.ChainLightning)) or ((622 + 77) >= (1282 + 14))) then
						return "chain_lightning funnel 8";
					end
				end
				if ((v100.LavaBurst:IsReady() and v44 and ((v13:BuffStack(v100.MoltenWeaponBuff) + v22(v13:BuffUp(v100.VolcanicStrengthBuff))) > v13:BuffStack(v100.CracklingSurgeBuff)) and (v13:BuffStack(v100.MaelstromWeaponBuff) == (3 + 2 + ((1 + 4) * v22(v100.OverflowingMaelstrom:IsAvailable()))))) or ((3862 - 2079) >= (4866 - (363 + 887)))) then
					if (v21(v100.LavaBurst, not v14:IsSpellInRange(v100.LavaBurst)) or ((6832 - 2919) > (21547 - 17020))) then
						return "lava_burst funnel 9";
					end
				end
				if (((676 + 3700) > (1911 - 1094)) and v100.LightningBolt:IsReady() and v46 and (v13:BuffStack(v100.MaelstromWeaponBuff) == (4 + 1 + ((1669 - (674 + 990)) * v22(v100.OverflowingMaelstrom:IsAvailable()))))) then
					if (((1394 + 3467) > (338 + 486)) and v21(v100.LightningBolt, not v14:IsSpellInRange(v100.LightningBolt))) then
						return "lightning_bolt funnel 10";
					end
				end
				if ((v100.CrashLightning:IsReady() and v38 and (v13:BuffUp(v100.DoomWindsBuff) or v13:BuffDown(v100.CrashLightningBuff) or (v100.AlphaWolf:IsAvailable() and v13:BuffUp(v100.FeralSpiritBuff) and (v125() == (0 - 0))) or (v100.ConvergingStorms:IsAvailable() and (v13:BuffStack(v100.ConvergingStormsBuff) < (1061 - (507 + 548)))))) or ((2220 - (289 + 548)) >= (3949 - (821 + 997)))) then
					if (v21(v100.CrashLightning, not v14:IsInMeleeRange(260 - (195 + 60))) or ((505 + 1371) >= (4042 - (251 + 1250)))) then
						return "crash_lightning funnel 11";
					end
				end
				if (((5220 - 3438) <= (2592 + 1180)) and v100.Sundering:IsReady() and v49 and ((v61 and v34) or not v61) and (v98 < v115) and (v13:BuffUp(v100.DoomWindsBuff) or v13:HasTier(1062 - (809 + 223), 2 - 0))) then
					if (v21(v100.Sundering, not v14:IsInRange(23 - 15)) or ((15540 - 10840) < (599 + 214))) then
						return "sundering funnel 12";
					end
				end
				v171 = 2 + 0;
			end
			if (((3816 - (14 + 603)) < (4179 - (118 + 11))) and (v171 == (1 + 3))) then
				if ((v100.LavaLash:IsReady() and v45) or ((4124 + 827) < (12910 - 8480))) then
					if (((1045 - (551 + 398)) == (61 + 35)) and v21(v100.LavaLash, not v14:IsSpellInRange(v100.LavaLash))) then
						return "lava_lash funnel 25";
					end
				end
				if ((v100.CrashLightning:IsReady() and v38) or ((975 + 1764) > (3258 + 750))) then
					if (v21(v100.CrashLightning, not v14:IsInMeleeRange(18 - 13)) or ((52 - 29) == (368 + 766))) then
						return "crash_lightning funnel 26";
					end
				end
				if ((v100.FireNova:IsReady() and v40 and (v100.FlameShockDebuff:AuraActiveCount() >= (7 - 5))) or ((744 + 1949) >= (4200 - (40 + 49)))) then
					if (v21(v100.FireNova) or ((16435 - 12119) <= (2636 - (99 + 391)))) then
						return "fire_nova funnel 27";
					end
				end
				if ((v100.ElementalBlast:IsReady() and v39 and (not v100.ElementalSpirits:IsAvailable() or (v100.ElementalSpirits:IsAvailable() and ((v100.ElementalBlast:Charges() == v112) or v13:BuffUp(v100.FeralSpiritBuff)))) and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (5 + 0))) or ((15587 - 12041) <= (6955 - 4146))) then
					if (((4777 + 127) > (5699 - 3533)) and v21(v100.ElementalBlast, not v14:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast funnel 28";
					end
				end
				if (((1713 - (1032 + 572)) >= (507 - (203 + 214))) and v100.LavaBurst:IsReady() and v44 and ((v13:BuffStack(v100.MoltenWeaponBuff) + v22(v13:BuffUp(v100.VolcanicStrengthBuff))) > v13:BuffStack(v100.CracklingSurgeBuff)) and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (1822 - (568 + 1249)))) then
					if (((3895 + 1083) > (6977 - 4072)) and v21(v100.LavaBurst, not v14:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst funnel 29";
					end
				end
				if ((v100.LightningBolt:IsReady() and v46 and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (19 - 14))) or ((4332 - (913 + 393)) <= (6438 - 4158))) then
					if (v21(v100.LightningBolt, not v14:IsSpellInRange(v100.LightningBolt)) or ((2334 - 681) <= (1518 - (269 + 141)))) then
						return "lightning_bolt funnel 30";
					end
				end
				v171 = 11 - 6;
			end
		end
	end
	local function v142()
		local v172 = 1981 - (362 + 1619);
		while true do
			if (((4534 - (950 + 675)) > (1006 + 1603)) and (v172 == (1180 - (216 + 963)))) then
				if (((2044 - (485 + 802)) > (753 - (432 + 127))) and (not v105 or (v107 < (601073 - (1065 + 8)))) and v52 and v100.FlamentongueWeapon:IsCastable()) then
					if (v21(v100.FlamentongueWeapon) or ((18 + 13) >= (2999 - (635 + 966)))) then
						return "flametongue_weapon enchant";
					end
				end
				if (((2298 + 898) <= (4914 - (5 + 37))) and v84) then
					local v247 = 0 - 0;
					while true do
						if (((1384 + 1942) == (5264 - 1938)) and (v247 == (0 + 0))) then
							v30 = v135();
							if (((2977 - 1544) <= (14702 - 10824)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				v172 = 3 - 1;
			end
			if ((v172 == (0 - 0)) or ((1139 + 444) == (2264 - (318 + 211)))) then
				if ((v74 and v100.EarthShield:IsCastable() and v13:BuffDown(v100.EarthShieldBuff) and ((v75 == "Earth Shield") or (v100.ElementalOrbit:IsAvailable() and v13:BuffUp(v100.LightningShield)))) or ((14667 - 11686) == (3937 - (963 + 624)))) then
					if (v21(v100.EarthShield) or ((1909 + 2557) <= (1339 - (518 + 328)))) then
						return "earth_shield main 2";
					end
				elseif ((v74 and v100.LightningShield:IsCastable() and v13:BuffDown(v100.LightningShieldBuff) and ((v75 == "Lightning Shield") or (v100.ElementalOrbit:IsAvailable() and v13:BuffUp(v100.EarthShield)))) or ((5937 - 3390) <= (3175 - 1188))) then
					if (((3278 - (301 + 16)) > (8030 - 5290)) and v21(v100.LightningShield)) then
						return "lightning_shield main 2";
					end
				end
				if (((10379 - 6683) >= (9425 - 5813)) and (not v104 or (v106 < (543473 + 56527))) and v52 and v100.WindfuryWeapon:IsCastable()) then
					if (v21(v100.WindfuryWeapon) or ((1687 + 1283) == (4009 - 2131))) then
						return "windfury_weapon enchant";
					end
				end
				v172 = 1 + 0;
			end
			if ((v172 == (1 + 1)) or ((11741 - 8048) < (639 + 1338))) then
				if ((v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) or ((1949 - (829 + 190)) > (7496 - 5395))) then
					if (((5254 - 1101) > (4265 - 1179)) and v21(v100.AncestralSpirit, nil, true)) then
						return "resurrection";
					end
				end
				if ((v116.TargetIsValid() and v31) or ((11560 - 6906) <= (960 + 3090))) then
					if (not v13:AffectingCombat() or ((850 + 1752) < (4540 - 3044))) then
						local v253 = 0 + 0;
						local v254;
						while true do
							if ((v253 == (613 - (520 + 93))) or ((1296 - (259 + 17)) > (132 + 2156))) then
								v254 = v138();
								if (((119 + 209) == (1110 - 782)) and v254) then
									return v254;
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
	local function v143()
		local v173 = 591 - (396 + 195);
		while true do
			if (((4383 - 2872) < (5569 - (440 + 1321))) and (v173 == (1830 - (1059 + 770)))) then
				if (v92 or ((11606 - 9096) > (5464 - (424 + 121)))) then
					local v248 = 0 + 0;
					while true do
						if (((6110 - (641 + 706)) == (1887 + 2876)) and (v248 == (441 - (249 + 191)))) then
							if (((18022 - 13885) > (826 + 1022)) and v88) then
								local v260 = 0 - 0;
								while true do
									if (((2863 - (183 + 244)) <= (154 + 2980)) and (v260 == (730 - (434 + 296)))) then
										v30 = v116.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 95 - 65);
										if (((4235 - (169 + 343)) == (3264 + 459)) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							if (((v13:BuffStack(v100.MaelstromWeaponBuff) >= (8 - 3)) and v89) or ((11875 - 7829) >= (3536 + 780))) then
								local v261 = 0 - 0;
								while true do
									if ((v261 == (1123 - (651 + 472))) or ((1518 + 490) < (833 + 1096))) then
										v30 = v116.HandleAfflicted(v100.HealingSurge, v102.HealingSurgeMouseover, 48 - 8, true);
										if (((2867 - (397 + 86)) > (2651 - (423 + 453))) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							break;
						end
						if ((v248 == (0 + 0)) or ((599 + 3944) <= (3821 + 555))) then
							if (((581 + 147) == (651 + 77)) and v86) then
								local v262 = 1190 - (50 + 1140);
								while true do
									if (((0 + 0) == v262) or ((636 + 440) > (291 + 4380))) then
										v30 = v116.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 57 - 17);
										if (((1340 + 511) >= (974 - (157 + 439))) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							if (v87 or ((3387 - 1439) >= (11549 - 8073))) then
								local v263 = 0 - 0;
								while true do
									if (((5712 - (782 + 136)) >= (1688 - (112 + 743))) and (v263 == (1171 - (1026 + 145)))) then
										v30 = v116.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 6 + 24);
										if (((4808 - (493 + 225)) == (15033 - 10943)) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							v248 = 1 + 0;
						end
					end
				end
				if (v93 or ((10075 - 6317) == (48 + 2450))) then
					v30 = v116.HandleIncorporeal(v100.Hex, v102.HexMouseOver, 85 - 55, true);
					if (v30 or ((779 + 1894) < (2630 - 1055))) then
						return v30;
					end
				end
				v173 = 1597 - (210 + 1385);
			end
			if ((v173 == (1689 - (1201 + 488))) or ((2307 + 1414) <= (2587 - 1132))) then
				v30 = v136();
				if (((1674 - 740) < (2855 - (352 + 233))) and v30) then
					return v30;
				end
				v173 = 2 - 1;
			end
			if ((v173 == (3 + 1)) or ((4583 - 2971) == (1829 - (489 + 85)))) then
				if (v30 or ((5853 - (277 + 1224)) < (5699 - (663 + 830)))) then
					return v30;
				end
				if (v116.TargetIsValid() or ((2513 + 347) <= (443 - 262))) then
					local v249 = 875 - (461 + 414);
					local v250;
					while true do
						if (((541 + 2681) >= (611 + 916)) and ((1 + 1) == v249)) then
							if (((1484 + 21) <= (2371 - (172 + 78))) and v100.PrimordialWave:IsCastable() and v47 and ((v62 and v34) or not v62) and (v98 < v115) and (v13:HasTier(49 - 18, 1 + 1))) then
								if (((1072 - 328) == (203 + 541)) and v21(v100.PrimordialWave, not v14:IsSpellInRange(v100.PrimordialWave))) then
									return "primordial_wave main 2";
								end
							end
							if ((v100.FeralSpirit:IsCastable() and v54 and ((v59 and v33) or not v59) and (v98 < v115)) or ((662 + 1317) >= (4751 - 1915))) then
								if (((2306 - 473) <= (671 + 1997)) and v21(v100.FeralSpirit)) then
									return "feral_spirit main 3";
								end
							end
							if (((2039 + 1647) == (1312 + 2374)) and v100.Ascendance:IsCastable() and v53 and ((v58 and v33) or not v58) and (v98 < v115) and v14:DebuffUp(v100.FlameShockDebuff) and (((v113 == "Lightning Bolt") and (v110 == (3 - 2))) or ((v113 == "Chain Lightning") and (v110 > (2 - 1))))) then
								if (((1064 + 2403) > (273 + 204)) and v21(v100.Ascendance)) then
									return "ascendance main 4";
								end
							end
							v249 = 450 - (133 + 314);
						end
						if ((v249 == (1 + 3)) or ((3501 - (199 + 14)) >= (12676 - 9135))) then
							if (v18.CastAnnotated(v100.Pool, false, "WAIT") or ((5106 - (647 + 902)) == (13651 - 9111))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((v249 == (233 - (85 + 148))) or ((1550 - (426 + 863)) > (5929 - 4662))) then
							v250 = v116.HandleDPSPotion(v13:BuffUp(v100.FeralSpiritBuff));
							if (((2926 - (873 + 781)) < (5165 - 1307)) and v250) then
								return v250;
							end
							if (((9894 - 6230) == (1519 + 2145)) and (v98 < v115)) then
								if (((7170 - 5229) >= (644 - 194)) and v56 and ((v33 and v63) or not v63)) then
									local v266 = 0 - 0;
									while true do
										if ((v266 == (1947 - (414 + 1533))) or ((4029 + 617) < (879 - (443 + 112)))) then
											v30 = v137();
											if (((5312 - (888 + 591)) == (9903 - 6070)) and v30) then
												return v30;
											end
											break;
										end
									end
								end
							end
							v249 = 1 + 0;
						end
						if ((v249 == (3 - 2)) or ((485 + 755) > (1631 + 1739))) then
							if (((v98 < v115) and v57 and ((v64 and v33) or not v64)) or ((266 + 2215) == (8921 - 4239))) then
								if (((8755 - 4028) >= (1886 - (136 + 1542))) and v100.BloodFury:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (163 - 113)))) then
									if (((278 + 2) < (6123 - 2272)) and v21(v100.BloodFury)) then
										return "blood_fury racial";
									end
								end
								if ((v100.Berserking:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff))) or ((2177 + 830) > (3680 - (68 + 418)))) then
									if (v21(v100.Berserking) or ((5790 - 3654) >= (5344 - 2398))) then
										return "berserking racial";
									end
								end
								if (((1869 + 296) <= (3613 - (770 + 322))) and v100.Fireblood:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (3 + 47)))) then
									if (((828 + 2033) > (91 + 570)) and v21(v100.Fireblood)) then
										return "fireblood racial";
									end
								end
								if (((6474 - 1949) > (8761 - 4242)) and v100.AncestralCall:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (136 - 86)))) then
									if (((11689 - 8511) > (542 + 430)) and v21(v100.AncestralCall)) then
										return "ancestral_call racial";
									end
								end
							end
							if (((7140 - 2374) == (2287 + 2479)) and v100.TotemicProjection:IsCastable() and (v100.WindfuryTotem:TimeSinceLastCast() < (56 + 34)) and v13:BuffDown(v100.WindfuryTotemBuff, true)) then
								if (v21(v102.TotemicProjectionPlayer) or ((2152 + 593) > (11778 - 8650))) then
									return "totemic_projection wind_fury main 0";
								end
							end
							if ((v100.Windstrike:IsCastable() and v51) or ((1588 - 444) >= (1557 + 3049))) then
								if (((15376 - 12038) >= (915 - 638)) and v21(v100.Windstrike, not v14:IsSpellInRange(v100.Windstrike))) then
									return "windstrike main 1";
								end
							end
							v249 = 1 + 1;
						end
						if (((12915 - 10305) > (3391 - (762 + 69))) and ((9 - 6) == v249)) then
							if ((v100.DoomWinds:IsCastable() and v55 and ((v60 and v33) or not v60) and (v98 < v115)) or ((1029 + 165) > (1997 + 1086))) then
								if (((2215 - 1299) >= (236 + 511)) and v21(v100.DoomWinds, not v14:IsInMeleeRange(1 + 4))) then
									return "doom_winds main 5";
								end
							end
							if ((v110 == (3 - 2)) or ((2601 - (8 + 149)) > (4274 - (1199 + 121)))) then
								local v264 = v139();
								if (((4893 - 2001) < (7933 - 4419)) and v264) then
									return v264;
								end
							end
							if (((220 + 313) == (1902 - 1369)) and v32 and (v110 > (2 - 1))) then
								local v265 = v140();
								if (((527 + 68) <= (5220 - (518 + 1289))) and v265) then
									return v265;
								end
							end
							v249 = 6 - 2;
						end
					end
				end
				break;
			end
			if (((409 + 2669) >= (3783 - 1192)) and (v173 == (3 + 0))) then
				if (((3668 - (304 + 165)) < (3805 + 225)) and v100.Purge:IsReady() and v99 and v35 and v90 and not v13:IsCasting() and not v13:IsChanneling() and v116.UnitHasMagicBuff(v14)) then
					if (((937 - (54 + 106)) < (4047 - (1618 + 351))) and v21(v100.Purge, not v14:IsSpellInRange(v100.Purge))) then
						return "purge damage";
					end
				end
				v30 = v134();
				v173 = 3 + 1;
			end
			if (((2712 - (10 + 1006)) <= (573 + 1709)) and (v173 == (1 + 1))) then
				if (Focus or ((5708 - 3947) >= (3495 - (912 + 121)))) then
					if (((2151 + 2400) > (3617 - (1140 + 149))) and v91) then
						local v255 = 0 + 0;
						while true do
							if (((5097 - 1272) >= (87 + 380)) and ((0 - 0) == v255)) then
								v30 = v133();
								if (v30 or ((5420 - 2530) == (97 + 460))) then
									return v30;
								end
								break;
							end
						end
					end
				end
				if ((v100.GreaterPurge:IsAvailable() and v99 and v100.GreaterPurge:IsReady() and v35 and v90 and not v13:IsCasting() and not v13:IsChanneling() and v116.UnitHasMagicBuff(v14)) or ((16552 - 11782) == (3090 - (165 + 21)))) then
					if (v21(v100.GreaterPurge, not v14:IsSpellInRange(v100.GreaterPurge)) or ((4014 - (61 + 50)) == (1869 + 2667))) then
						return "greater_purge damage";
					end
				end
				v173 = 14 - 11;
			end
		end
	end
	local function v144()
		local v174 = 0 - 0;
		while true do
			if (((1609 + 2484) <= (6305 - (1295 + 165))) and (v174 == (1 + 3))) then
				v51 = EpicSettings.Settings['useWindstrike'];
				v50 = EpicSettings.Settings['useWindfuryTotem'];
				v52 = EpicSettings.Settings['useWeaponEnchant'];
				v58 = EpicSettings.Settings['ascendanceWithCD'];
				v174 = 3 + 2;
			end
			if (((2966 - (819 + 578)) <= (5049 - (331 + 1071))) and (v174 == (745 - (588 + 155)))) then
				v42 = EpicSettings.Settings['useFrostShock'];
				v43 = EpicSettings.Settings['useIceStrike'];
				v44 = EpicSettings.Settings['useLavaBurst'];
				v45 = EpicSettings.Settings['useLavaLash'];
				v174 = 1285 - (546 + 736);
			end
			if ((v174 == (1937 - (1834 + 103))) or ((2489 + 1557) >= (14697 - 9770))) then
				v53 = EpicSettings.Settings['useAscendance'];
				v55 = EpicSettings.Settings['useDoomWinds'];
				v54 = EpicSettings.Settings['useFeralSpirit'];
				v37 = EpicSettings.Settings['useChainlightning'];
				v174 = 1767 - (1536 + 230);
			end
			if (((5114 - (128 + 363)) >= (593 + 2194)) and (v174 == (2 - 1))) then
				v38 = EpicSettings.Settings['useCrashLightning'];
				v39 = EpicSettings.Settings['useElementalBlast'];
				v40 = EpicSettings.Settings['useFireNova'];
				v41 = EpicSettings.Settings['useFlameShock'];
				v174 = 1 + 1;
			end
			if (((3701 - 1467) >= (3621 - 2391)) and (v174 == (12 - 7))) then
				v60 = EpicSettings.Settings['doomWindsWithCD'];
				v59 = EpicSettings.Settings['feralSpiritWithCD'];
				v62 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v61 = EpicSettings.Settings['sunderingWithMiniCD'];
				break;
			end
			if ((v174 == (3 + 0)) or ((1352 - (615 + 394)) == (1613 + 173))) then
				v46 = EpicSettings.Settings['useLightningBolt'];
				v47 = EpicSettings.Settings['usePrimordialWave'];
				v48 = EpicSettings.Settings['useStormStrike'];
				v49 = EpicSettings.Settings['useSundering'];
				v174 = 4 + 0;
			end
		end
	end
	local function v145()
		v65 = EpicSettings.Settings['useWindShear'];
		v36 = EpicSettings.Settings['useCapacitorTotem'];
		v66 = EpicSettings.Settings['useThunderstorm'];
		v69 = EpicSettings.Settings['useAncestralGuidance'];
		v68 = EpicSettings.Settings['useAstralShift'];
		v71 = EpicSettings.Settings['useMaelstromHealingSurge'];
		v70 = EpicSettings.Settings['useHealingStreamTotem'];
		v77 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 - 0);
		v78 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 - 0);
		v76 = EpicSettings.Settings['astralShiftHP'] or (651 - (59 + 592));
		v79 = EpicSettings.Settings['healingStreamTotemHP'] or (0 - 0);
		v80 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 - 0);
		v81 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (0 + 0);
		v74 = EpicSettings.Settings['autoShield'];
		v75 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
		v84 = EpicSettings.Settings['healOOC'];
		v85 = EpicSettings.Settings['healOOCHP'] or (171 - (70 + 101));
		v99 = EpicSettings.Settings['usePurgeTarget'];
		v86 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
		v87 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v88 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
		v89 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
	end
	local function v146()
		local v189 = 0 - 0;
		while true do
			if (((1823 + 747) > (6050 - 3641)) and (v189 == (242 - (123 + 118)))) then
				v91 = EpicSettings.Settings['DispelDebuffs'];
				v90 = EpicSettings.Settings['DispelBuffs'];
				v56 = EpicSettings.Settings['useTrinkets'];
				v57 = EpicSettings.Settings['useRacials'];
				v189 = 1 + 1;
			end
			if (((1 + 1) == v189) or ((4008 - (653 + 746)) >= (6048 - 2814))) then
				v63 = EpicSettings.Settings['trinketsWithCD'];
				v64 = EpicSettings.Settings['racialsWithCD'];
				v72 = EpicSettings.Settings['useHealthstone'];
				v73 = EpicSettings.Settings['useHealingPotion'];
				v189 = 4 - 1;
			end
			if ((v189 == (0 - 0)) or ((1339 + 1694) >= (2579 + 1452))) then
				v98 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v95 = EpicSettings.Settings['InterruptWithStun'];
				v96 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v97 = EpicSettings.Settings['InterruptThreshold'];
				v189 = 1 + 0;
			end
			if ((v189 == (1 + 2)) or ((3434 - 2033) == (4444 + 224))) then
				v82 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v83 = EpicSettings.Settings['healingPotionHP'] or (1234 - (885 + 349));
				v94 = EpicSettings.Settings['HealingPotionName'] or "";
				v92 = EpicSettings.Settings['handleAfflicted'];
				v189 = 4 + 0;
			end
			if (((7570 - 4794) >= (3842 - 2521)) and (v189 == (972 - (915 + 53)))) then
				v93 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v147()
		v145();
		v144();
		v146();
		v31 = EpicSettings.Toggles['ooc'];
		v32 = EpicSettings.Toggles['aoe'];
		v33 = EpicSettings.Toggles['cds'];
		v35 = EpicSettings.Toggles['dispel'];
		v34 = EpicSettings.Toggles['minicds'];
		if (v13:IsDeadOrGhost() or ((1288 - (768 + 33)) > (8817 - 6514))) then
			return;
		end
		v104, v106, _, _, v105, v107 = v24();
		v108 = v13:GetEnemiesInRange(70 - 30);
		v109 = v13:GetEnemiesInMeleeRange(333 - (287 + 41));
		if (v32 or ((5350 - (638 + 209)) == (1799 + 1663))) then
			local v202 = 1686 - (96 + 1590);
			while true do
				if (((2225 - (741 + 931)) <= (758 + 785)) and (v202 == (0 - 0))) then
					v111 = #v108;
					v110 = #v109;
					break;
				end
			end
		else
			v111 = 4 - 3;
			v110 = 1 + 0;
		end
		if (((866 + 1149) == (643 + 1372)) and (v13:AffectingCombat() or v91)) then
			local v203 = v91 and v100.CleanseSpirit:IsReady() and v35;
			v30 = v116.FocusUnit(v203, v102, 75 - 55, nil, 9 + 16);
			if (v30 or ((2071 + 2170) <= (9512 - 7180))) then
				return v30;
			end
		end
		if (v116.TargetIsValid() or v13:AffectingCombat() or ((2122 + 242) < (1651 - (64 + 430)))) then
			local v204 = 0 + 0;
			while true do
				if ((v204 == (363 - (106 + 257))) or ((828 + 339) > (1999 - (496 + 225)))) then
					v114 = v9.BossFightRemains(nil, true);
					v115 = v114;
					v204 = 1 - 0;
				end
				if ((v204 == (4 - 3)) or ((2803 - (256 + 1402)) <= (2981 - (30 + 1869)))) then
					if ((v115 == (12480 - (213 + 1156))) or ((3293 - (96 + 92)) == (832 + 4049))) then
						v115 = v9.FightRemains(v109, false);
					end
					break;
				end
			end
		end
		if (v13:AffectingCombat() or ((2786 - (142 + 757)) > (3974 + 904))) then
			if (v13:PrevGCD(1 + 0, v100.ChainLightning) or ((4166 - (32 + 47)) > (6093 - (1053 + 924)))) then
				v113 = "Chain Lightning";
			elseif (((1084 + 22) <= (2180 - 914)) and v13:PrevGCD(1649 - (685 + 963), v100.LightningBolt)) then
				v113 = "Lightning Bolt";
			end
		end
		if (((6415 - 3260) < (7252 - 2602)) and not v13:IsChanneling() and not v13:IsChanneling()) then
			local v205 = 1709 - (541 + 1168);
			while true do
				if (((5371 - (645 + 952)) >= (2677 - (669 + 169))) and (v205 == (3 - 2))) then
					if (((6104 - 3293) == (949 + 1862)) and v13:AffectingCombat()) then
						v30 = v143();
						if (((474 + 1672) > (1887 - (181 + 584))) and v30) then
							return v30;
						end
					else
						v30 = v142();
						if (v30 or ((1451 - (665 + 730)) == (10421 - 6805))) then
							return v30;
						end
					end
					break;
				end
				if ((v205 == (0 - 0)) or ((3771 - (540 + 810)) < (2486 - 1864))) then
					if (((2774 - 1765) <= (900 + 230)) and Focus) then
						if (((2961 - (166 + 37)) < (4861 - (22 + 1859))) and v91) then
							local v259 = 1772 - (843 + 929);
							while true do
								if ((v259 == (262 - (30 + 232))) or ((245 - 159) >= (4403 - (55 + 722)))) then
									v30 = v133();
									if (((5141 - 2746) == (4070 - (78 + 1597))) and v30) then
										return v30;
									end
									break;
								end
							end
						end
					end
					if (((831 + 2949) > (2465 + 244)) and v92) then
						local v256 = 0 + 0;
						while true do
							if ((v256 == (550 - (305 + 244))) or ((220 + 17) >= (2378 - (95 + 10)))) then
								if (v88 or ((1445 + 595) <= (2227 - 1524))) then
									local v267 = 0 - 0;
									while true do
										if (((4041 - (592 + 170)) <= (13836 - 9869)) and ((0 - 0) == v267)) then
											v30 = v116.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 14 + 16);
											if (v30 or ((774 + 1214) == (2117 - 1240))) then
												return v30;
											end
											break;
										end
									end
								end
								if (((696 + 3595) > (3543 - 1631)) and (v13:BuffStack(v100.MaelstromWeaponBuff) >= (512 - (353 + 154))) and v89) then
									local v268 = 0 - 0;
									while true do
										if (((2735 - 732) < (1614 + 725)) and (v268 == (0 + 0))) then
											v30 = v116.HandleAfflicted(v100.HealingSurge, v102.HealingSurgeMouseover, 27 + 13, true);
											if (((623 - 191) == (817 - 385)) and v30) then
												return v30;
											end
											break;
										end
									end
								end
								break;
							end
							if (((0 - 0) == v256) or ((1231 - (7 + 79)) >= (587 + 666))) then
								if (((3599 - (24 + 157)) > (4226 - 2108)) and v86) then
									local v269 = 0 - 0;
									while true do
										if (((872 + 2194) <= (10478 - 6588)) and (v269 == (380 - (262 + 118)))) then
											v30 = v116.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 1123 - (1038 + 45));
											if (v30 or ((6483 - 3485) >= (3511 - (19 + 211)))) then
												return v30;
											end
											break;
										end
									end
								end
								if (v87 or ((4762 - (88 + 25)) <= (6701 - 4069))) then
									local v270 = 0 + 0;
									while true do
										if (((0 + 0) == v270) or ((4896 - (1007 + 29)) > (1313 + 3559))) then
											v30 = v116.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 73 - 43);
											if (v30 or ((18908 - 14910) == (513 + 1785))) then
												return v30;
											end
											break;
										end
									end
								end
								v256 = 812 - (340 + 471);
							end
						end
					end
					v205 = 2 - 1;
				end
			end
		end
	end
	local function v148()
		local v195 = 589 - (276 + 313);
		while true do
			if ((v195 == (2 - 1)) or ((8 + 0) >= (1162 + 1577))) then
				v18.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
				break;
			end
			if (((243 + 2347) == (4562 - (495 + 1477))) and (v195 == (0 - 0))) then
				v100.FlameShockDebuff:RegisterAuraTracking();
				v123();
				v195 = 1 + 0;
			end
		end
	end
	v18.SetAPL(666 - (342 + 61), v147, v148);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

