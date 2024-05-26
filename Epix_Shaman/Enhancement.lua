local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((5818 - (771 + 510)) >= (9712 - 5835)) and not v5) then
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
	local v102;
	local v103 = v17.Shaman.Enhancement;
	local v104 = v19.Shaman.Enhancement;
	local v105 = v22.Shaman.Enhancement;
	local v106 = {};
	local v107, v108;
	local v109, v110;
	local v111;
	local v112 = 6 + 4;
	local v113 = 5 + 3;
	local v114 = 5 + 1;
	local v115 = 496 + 504;
	local v116, v117, v118, v119;
	local v120 = (v103.LavaBurst:IsAvailable() and (2 + 0)) or (1415 - (1001 + 413));
	local v121 = "Lightning Bolt";
	local v122 = 24777 - 13666;
	local v123 = 11993 - (244 + 638);
	local v124 = v20.Commons.Everyone;
	v20.Commons.Shaman = {};
	local v126 = v20.Commons.Shaman;
	v126.FeralSpiritCount = 693 - (627 + 66);
	v9:RegisterForEvent(function()
		v120 = (v103.LavaBurst:IsAvailable() and (5 - 3)) or (603 - (512 + 90));
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v9:RegisterForEvent(function()
		local v151 = 1906 - (1665 + 241);
		while true do
			if ((v151 == (718 - (373 + 344))) or ((1947 + 2368) < (457 + 1269))) then
				v123 = 29307 - 18196;
				break;
			end
			if ((v151 == (0 - 0)) or ((4778 - (35 + 1064)) < (455 + 170))) then
				v121 = "Lightning Bolt";
				v122 = 23772 - 12661;
				v151 = 1 + 0;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v128(v152)
		local v153 = 1236 - (298 + 938);
		local v154;
		local v155;
		while true do
			if ((v153 == (1260 - (233 + 1026))) or ((6291 - (636 + 1030)) < (324 + 308))) then
				for v241, v242 in pairs(v154) do
					if (((v242:GUID() ~= v14:GUID()) and (v242:AffectingCombat() or v242:IsDummy())) or ((82 + 1) > (529 + 1251))) then
						v155 = v155 + 1 + 0;
					end
				end
				return v155;
			end
			if (((767 - (55 + 166)) <= (209 + 868)) and (v153 == (0 + 0))) then
				v154 = v13:GetEnemiesInRange(v152);
				v155 = 3 - 2;
				v153 = 298 - (36 + 261);
			end
		end
	end
	v9:RegisterForSelfCombatEvent(function(...)
		local v156, v157, v157, v157, v157, v157, v157, v157, v158 = select(6 - 2, ...);
		if (((v156 == v13:GUID()) and (v158 == (193002 - (34 + 1334)))) or ((383 + 613) > (3342 + 959))) then
			v126.LastSKCast = v30();
		end
		if (((5353 - (1035 + 248)) > (708 - (20 + 1))) and v13:HasTier(17 + 14, 321 - (134 + 185)) and (v156 == v13:GUID()) and (v158 == (377115 - (549 + 584)))) then
			v126.FeralSpiritCount = v126.FeralSpiritCount + (686 - (314 + 371));
			v31.After(51 - 36, function()
				v126.FeralSpiritCount = v126.FeralSpiritCount - (969 - (478 + 490));
			end);
		end
		if (((v156 == v13:GUID()) and (v158 == (27299 + 24234))) or ((1828 - (786 + 386)) >= (10785 - 7455))) then
			v126.FeralSpiritCount = v126.FeralSpiritCount + (1381 - (1055 + 324));
			v31.After(1355 - (1093 + 247), function()
				v126.FeralSpiritCount = v126.FeralSpiritCount - (2 + 0);
			end);
		end
	end, "SPELL_CAST_SUCCESS");
	local function v129()
		if (v103.CleanseSpirit:IsAvailable() or ((263 + 2229) <= (1330 - 995))) then
			v124.DispellableDebuffs = v124.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v129();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v130()
		local v159 = 0 - 0;
		local v160;
		while true do
			if (((12298 - 7976) >= (6437 - 3875)) and (v159 == (1 + 0))) then
				if ((v160 > (30 - 22)) or (v160 > v103.FeralSpirit:TimeSinceLastCast()) or ((12535 - 8898) >= (2843 + 927))) then
					return 0 - 0;
				end
				return (696 - (364 + 324)) - v160;
			end
			if ((v159 == (0 - 0)) or ((5708 - 3329) > (1518 + 3060))) then
				if (not v103.AlphaWolf:IsAvailable() or v13:BuffDown(v103.FeralSpiritBuff) or ((2020 - 1537) > (1189 - 446))) then
					return 0 - 0;
				end
				v160 = v28(v103.CrashLightning:TimeSinceLastCast(), v103.ChainLightning:TimeSinceLastCast());
				v159 = 1269 - (1249 + 19);
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
		return v13:BuffDown(v103.PrimordialWaveBuff);
	end
	local function v134(v164)
		return v164:DebuffRemains(v103.LashingFlamesDebuff);
	end
	local v135 = 0 + 0;
	local function v136()
		if (((9552 - 7098) > (1664 - (686 + 400))) and v103.CleanseSpirit:IsReady() and v37 and (v124.UnitHasDispellableDebuffByPlayer(v15) or v124.DispellableFriendlyUnit(16 + 4) or v124.UnitHasCurseDebuff(v15))) then
			local v222 = 229 - (73 + 156);
			while true do
				if (((5 + 925) < (5269 - (721 + 90))) and (v222 == (0 + 0))) then
					if (((2149 - 1487) <= (1442 - (224 + 246))) and (v135 == (0 - 0))) then
						v135 = v30();
					end
					if (((8046 - 3676) == (793 + 3577)) and v124.Wait(12 + 488, v135)) then
						local v254 = 0 + 0;
						while true do
							if ((v254 == (0 - 0)) or ((15846 - 11084) <= (1374 - (203 + 310)))) then
								if (v23(v105.CleanseSpiritFocus) or ((3405 - (1238 + 755)) == (298 + 3966))) then
									return "cleanse_spirit dispel";
								end
								v135 = 1534 - (709 + 825);
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
		local v165 = 0 - 0;
		while true do
			if ((v165 == (0 - 0)) or ((4032 - (196 + 668)) < (8500 - 6347))) then
				if (not v15 or not v15:Exists() or not v15:IsInRange(82 - 42) or ((5809 - (171 + 662)) < (1425 - (4 + 89)))) then
					return;
				end
				if (((16220 - 11592) == (1686 + 2942)) and v15) then
					if (((v15:HealthPercentage() <= v83) and v73 and v103.HealingSurge:IsReady() and (v13:BuffStack(v103.MaelstromWeaponBuff) >= (21 - 16))) or ((22 + 32) == (1881 - (35 + 1451)))) then
						if (((1535 - (28 + 1425)) == (2075 - (941 + 1052))) and v23(v105.HealingSurgeFocus)) then
							return "healing_surge heal focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v138()
		if ((v13:HealthPercentage() <= v87) or ((558 + 23) < (1796 - (822 + 692)))) then
			if (v103.HealingSurge:IsReady() or ((6579 - 1970) < (1176 + 1319))) then
				if (((1449 - (45 + 252)) == (1140 + 12)) and v23(v103.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v139()
		if (((653 + 1243) <= (8327 - 4905)) and v103.AstralShift:IsReady() and v70 and (v13:HealthPercentage() <= v78)) then
			if (v23(v103.AstralShift) or ((1423 - (114 + 319)) > (2325 - 705))) then
				return "astral_shift defensive 1";
			end
		end
		if ((v103.AncestralGuidance:IsReady() and v71 and v124.AreUnitsBelowHealthPercentage(v79, v80, v103.HealingSurge)) or ((1123 - 246) > (2993 + 1702))) then
			if (((4008 - 1317) >= (3878 - 2027)) and v23(v103.AncestralGuidance)) then
				return "ancestral_guidance defensive 2";
			end
		end
		if ((v103.HealingStreamTotem:IsReady() and v72 and v124.AreUnitsBelowHealthPercentage(v81, v82, v103.HealingSurge)) or ((4948 - (556 + 1407)) >= (6062 - (741 + 465)))) then
			if (((4741 - (170 + 295)) >= (630 + 565)) and v23(v103.HealingStreamTotem)) then
				return "healing_stream_totem defensive 3";
			end
		end
		if (((2969 + 263) <= (11547 - 6857)) and v103.HealingSurge:IsReady() and v73 and (v13:HealthPercentage() <= v83) and (v13:BuffStack(v103.MaelstromWeaponBuff) >= (5 + 0))) then
			if (v23(v103.HealingSurge) or ((575 + 321) >= (1782 + 1364))) then
				return "healing_surge defensive 4";
			end
		end
		if (((4291 - (957 + 273)) >= (792 + 2166)) and v104.Healthstone:IsReady() and v74 and (v13:HealthPercentage() <= v84)) then
			if (((1276 + 1911) >= (2453 - 1809)) and v23(v105.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if (((1696 - 1052) <= (2150 - 1446)) and v75 and (v13:HealthPercentage() <= v85)) then
			local v223 = 0 - 0;
			while true do
				if (((2738 - (389 + 1391)) > (595 + 352)) and (v223 == (1 + 0))) then
					if (((10226 - 5734) >= (3605 - (783 + 168))) and (v96 == "Potion of Withering Dreams")) then
						if (((11551 - 8109) >= (1479 + 24)) and v104.PotionOfWitheringDreams:IsReady()) then
							if (v23(v105.RefreshingHealingPotion) or ((3481 - (309 + 2)) <= (4495 - 3031))) then
								return "potion of withering dreams defensive";
							end
						end
					end
					break;
				end
				if ((v223 == (1212 - (1090 + 122))) or ((1556 + 3241) == (14736 - 10348))) then
					if (((378 + 173) <= (1799 - (628 + 490))) and (v96 == "Refreshing Healing Potion")) then
						if (((588 + 2689) > (1007 - 600)) and v104.RefreshingHealingPotion:IsReady()) then
							if (((21456 - 16761) >= (2189 - (431 + 343))) and v23(v105.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v96 == "Dreamwalker's Healing Potion") or ((6486 - 3274) <= (2730 - 1786))) then
						if (v104.DreamwalkersHealingPotion:IsReady() or ((2446 + 650) <= (230 + 1568))) then
							if (((5232 - (556 + 1139)) == (3552 - (6 + 9))) and v23(v105.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					v223 = 1 + 0;
				end
			end
		end
	end
	local function v140()
		v32 = v124.HandleTopTrinket(v106, v35, 21 + 19, nil);
		if (((4006 - (28 + 141)) >= (609 + 961)) and v32) then
			return v32;
		end
		v32 = v124.HandleBottomTrinket(v106, v35, 49 - 9, nil);
		if (v32 or ((2090 + 860) == (5129 - (486 + 831)))) then
			return v32;
		end
	end
	local function v141()
		local v166 = 0 - 0;
		while true do
			if (((16627 - 11904) >= (439 + 1879)) and (v166 == (3 - 2))) then
				if ((v103.FeralSpirit:IsCastable() and v56 and ((v61 and v35) or not v61)) or ((3290 - (668 + 595)) > (2567 + 285))) then
					if (v23(v103.FeralSpirit) or ((230 + 906) > (11772 - 7455))) then
						return "feral_spirit precombat 6";
					end
				end
				if (((5038 - (23 + 267)) == (6692 - (1129 + 815))) and v103.FlameShock:IsReady() and v42) then
					if (((4123 - (371 + 16)) <= (6490 - (1326 + 424))) and v23(v103.FlameShock, not v14:IsSpellInRange(v103.FlameShock))) then
						return "flame_shock precombat 8";
					end
				end
				break;
			end
			if ((v166 == (0 - 0)) or ((12387 - 8997) <= (3178 - (88 + 30)))) then
				if ((v103.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v103.WindfuryTotemBuff, true) or (v103.WindfuryTotem:TimeSinceLastCast() > (861 - (720 + 51))))) or ((2221 - 1222) > (4469 - (421 + 1355)))) then
					if (((763 - 300) < (296 + 305)) and v23(v103.WindfuryTotem)) then
						return "windfury_totem precombat 2";
					end
				end
				if ((v103.PrimordialWave:IsReady() and v48 and ((v64 and v36) or not v64)) or ((3266 - (286 + 797)) < (2511 - 1824))) then
					if (((7534 - 2985) == (4988 - (397 + 42))) and v23(v103.PrimordialWave, not v14:IsSpellInRange(v103.PrimordialWave))) then
						return "primordial_wave precombat 4";
					end
				end
				v166 = 1 + 0;
			end
		end
	end
	local function v142()
		local v167 = 800 - (24 + 776);
		while true do
			if (((7196 - 2524) == (5457 - (222 + 563))) and (v167 == (3 - 1))) then
				if ((v103.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v103.MaelstromWeaponBuff) >= (4 + 1)) and (v103.ElementalBlast:Charges() == v120)) or ((3858 - (23 + 167)) < (2193 - (690 + 1108)))) then
					if (v23(v103.ElementalBlast, not v14:IsSpellInRange(v103.ElementalBlast)) or ((1504 + 2662) == (376 + 79))) then
						return "elemental_blast single 9";
					end
				end
				if ((v103.LightningBolt:IsReady() and v47 and (v13:BuffStack(v103.MaelstromWeaponBuff) >= (856 - (40 + 808))) and v13:BuffUp(v103.PrimordialWaveBuff) and (v13:BuffDown(v103.SplinteredElementsBuff) or (v123 <= (2 + 10)))) or ((17012 - 12563) == (2546 + 117))) then
					if (v23(v103.LightningBolt, not v14:IsSpellInRange(v103.LightningBolt)) or ((2263 + 2014) < (1640 + 1349))) then
						return "lightning_bolt single 10";
					end
				end
				if ((v103.ChainLightning:IsReady() and v38 and (v13:BuffStack(v103.MaelstromWeaponBuff) >= (579 - (47 + 524))) and v13:BuffUp(v103.CracklingThunderBuff) and v103.ElementalSpirits:IsAvailable()) or ((565 + 305) >= (11341 - 7192))) then
					if (((3306 - 1094) < (7258 - 4075)) and v23(v103.ChainLightning, not v14:IsSpellInRange(v103.ChainLightning))) then
						return "chain_lightning single 11";
					end
				end
				if (((6372 - (1165 + 561)) > (89 + 2903)) and v103.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v103.MaelstromWeaponBuff) >= (24 - 16)) and ((v126.FeralSpiritCount >= (1 + 1)) or not v103.ElementalSpirits:IsAvailable())) then
					if (((1913 - (341 + 138)) < (839 + 2267)) and v23(v103.ElementalBlast, not v14:IsSpellInRange(v103.ElementalBlast))) then
						return "elemental_blast single 12";
					end
				end
				v167 = 5 - 2;
			end
			if (((1112 - (89 + 237)) < (9724 - 6701)) and (v167 == (10 - 5))) then
				if ((v103.FrostShock:IsReady() and v43 and (v13:BuffUp(v103.HailstormBuff))) or ((3323 - (581 + 300)) < (1294 - (855 + 365)))) then
					if (((10771 - 6236) == (1481 + 3054)) and v23(v103.FrostShock, not v14:IsSpellInRange(v103.FrostShock))) then
						return "frost_shock single 21";
					end
				end
				if ((v103.LavaLash:IsReady() and v46) or ((4244 - (1030 + 205)) <= (1977 + 128))) then
					if (((1703 + 127) < (3955 - (156 + 130))) and v23(v103.LavaLash, not v14:IsSpellInRange(v103.LavaLash))) then
						return "lava_lash single 22";
					end
				end
				if ((v103.IceStrike:IsReady() and v44) or ((3249 - 1819) >= (6086 - 2474))) then
					if (((5494 - 2811) >= (649 + 1811)) and v23(v103.IceStrike, not v14:IsInMeleeRange(3 + 2))) then
						return "ice_strike single 23";
					end
				end
				if ((v103.Windstrike:IsCastable() and v52) or ((1873 - (10 + 59)) >= (927 + 2348))) then
					if (v23(v103.Windstrike, not v14:IsSpellInRange(v103.Windstrike)) or ((6978 - 5561) > (4792 - (671 + 492)))) then
						return "windstrike single 24";
					end
				end
				v167 = 5 + 1;
			end
			if (((6010 - (369 + 846)) > (107 + 295)) and ((6 + 1) == v167)) then
				if (((6758 - (1036 + 909)) > (2835 + 730)) and v103.LightningBolt:IsReady() and v47 and v103.Hailstorm:IsAvailable() and (v13:BuffStack(v103.MaelstromWeaponBuff) >= (8 - 3)) and v13:BuffDown(v103.PrimordialWaveBuff)) then
					if (((4115 - (11 + 192)) == (1977 + 1935)) and v23(v103.LightningBolt, not v14:IsSpellInRange(v103.LightningBolt))) then
						return "lightning_bolt single 29";
					end
				end
				if (((2996 - (135 + 40)) <= (11687 - 6863)) and v103.FrostShock:IsReady() and v43) then
					if (((1048 + 690) <= (4835 - 2640)) and v23(v103.FrostShock, not v14:IsSpellInRange(v103.FrostShock))) then
						return "frost_shock single 30";
					end
				end
				if (((61 - 20) <= (3194 - (50 + 126))) and v103.CrashLightning:IsReady() and v39) then
					if (((5972 - 3827) <= (909 + 3195)) and v23(v103.CrashLightning, not v14:IsInMeleeRange(1421 - (1233 + 180)))) then
						return "crash_lightning single 31";
					end
				end
				if (((3658 - (522 + 447)) < (6266 - (107 + 1314))) and v103.FireNova:IsReady() and v41 and (v14:DebuffUp(v103.FlameShockDebuff))) then
					if (v23(v103.FireNova) or ((1078 + 1244) > (7989 - 5367))) then
						return "fire_nova single 32";
					end
				end
				v167 = 4 + 4;
			end
			if (((5 - 2) == v167) or ((17939 - 13405) == (3992 - (716 + 1194)))) then
				if ((v103.LavaBurst:IsReady() and v45 and not v103.ThorimsInvocation:IsAvailable() and (v13:BuffStack(v103.MaelstromWeaponBuff) >= (1 + 4))) or ((169 + 1402) > (2370 - (74 + 429)))) then
					if (v23(v103.LavaBurst, not v14:IsSpellInRange(v103.LavaBurst)) or ((5119 - 2465) >= (1485 + 1511))) then
						return "lava_burst single 13";
					end
				end
				if (((9105 - 5127) > (1489 + 615)) and v103.LightningBolt:IsReady() and v47 and ((v13:BuffStack(v103.MaelstromWeaponBuff) >= (24 - 16)) or (v103.StaticAccumulation:IsAvailable() and (v13:BuffStack(v103.MaelstromWeaponBuff) >= (12 - 7)))) and v13:BuffDown(v103.PrimordialWaveBuff)) then
					if (((3428 - (279 + 154)) > (2319 - (454 + 324))) and v23(v103.LightningBolt, not v14:IsSpellInRange(v103.LightningBolt))) then
						return "lightning_bolt single 14";
					end
				end
				if (((2557 + 692) > (970 - (12 + 5))) and v103.CrashLightning:IsReady() and v39 and v103.AlphaWolf:IsAvailable() and v13:BuffUp(v103.FeralSpiritBuff) and (v130() == (0 + 0))) then
					if (v23(v103.CrashLightning, not v14:IsInMeleeRange(20 - 12)) or ((1210 + 2063) > (5666 - (277 + 816)))) then
						return "crash_lightning single 15";
					end
				end
				if ((v103.PrimordialWave:IsCastable() and v48 and ((v64 and v36) or not v64) and (v100 < v123)) or ((13464 - 10313) < (2467 - (1058 + 125)))) then
					if (v23(v103.PrimordialWave, not v14:IsSpellInRange(v103.PrimordialWave)) or ((347 + 1503) == (2504 - (815 + 160)))) then
						return "primordial_wave single 16";
					end
				end
				v167 = 17 - 13;
			end
			if (((1948 - 1127) < (507 + 1616)) and (v167 == (17 - 11))) then
				if (((2800 - (41 + 1857)) < (4218 - (1222 + 671))) and v103.Stormstrike:IsReady() and v49) then
					if (((2217 - 1359) <= (4257 - 1295)) and v23(v103.Stormstrike, not v14:IsSpellInRange(v103.Stormstrike))) then
						return "stormstrike single 25";
					end
				end
				if ((v103.Sundering:IsReady() and v50 and ((v63 and v36) or not v63) and (v100 < v123)) or ((5128 - (229 + 953)) < (3062 - (1111 + 663)))) then
					if (v23(v103.Sundering, not v14:IsInRange(1587 - (874 + 705))) or ((454 + 2788) == (387 + 180))) then
						return "sundering single 26";
					end
				end
				if ((v103.BagofTricks:IsReady() and v59 and ((v66 and v35) or not v66)) or ((1759 - 912) >= (36 + 1227))) then
					if (v23(v103.BagofTricks) or ((2932 - (642 + 37)) == (423 + 1428))) then
						return "bag_of_tricks single 27";
					end
				end
				if ((v103.FireNova:IsReady() and v41 and v103.SwirlingMaelstrom:IsAvailable() and (v103.FlameShockDebuff:AuraActiveCount() > (0 + 0)) and (v13:BuffStack(v103.MaelstromWeaponBuff) < ((12 - 7) + ((459 - (233 + 221)) * v24(v103.OverflowingMaelstrom:IsAvailable()))))) or ((4825 - 2738) > (2088 + 284))) then
					if (v23(v103.FireNova) or ((5986 - (718 + 823)) < (2611 + 1538))) then
						return "fire_nova single 28";
					end
				end
				v167 = 812 - (266 + 539);
			end
			if (((2 - 1) == v167) or ((3043 - (636 + 589)) == (201 - 116))) then
				if (((1299 - 669) < (1686 + 441)) and v103.LightningBolt:IsCastable() and v47 and (v13:BuffStack(v103.MaelstromWeaponBuff) >= (2 + 3)) and v13:BuffDown(v103.CracklingThunderBuff) and v13:BuffUp(v103.AscendanceBuff) and (v121 == "Chain Lightning") and (v13:BuffRemains(v103.AscendanceBuff) > (v103.ChainLightning:CooldownRemains() + v13:GCD()))) then
					if (v23(v103.LightningBolt, not v14:IsSpellInRange(v103.LightningBolt)) or ((2953 - (657 + 358)) == (6656 - 4142))) then
						return "lightning_bolt single 5";
					end
				end
				if (((9694 - 5439) >= (1242 - (1151 + 36))) and v103.Stormstrike:IsReady() and v49 and (v13:BuffUp(v103.DoomWindsBuff) or v103.DeeplyRootedElements:IsAvailable() or (v103.Stormblast:IsAvailable() and v13:BuffUp(v103.StormbringerBuff)))) then
					if (((2897 + 102) > (304 + 852)) and v23(v103.Stormstrike, not v14:IsSpellInRange(v103.Stormstrike))) then
						return "stormstrike single 6";
					end
				end
				if (((7018 - 4668) > (2987 - (1552 + 280))) and v103.LavaLash:IsReady() and v46 and (v13:BuffUp(v103.HotHandBuff))) then
					if (((4863 - (64 + 770)) <= (3295 + 1558)) and v23(v103.LavaLash, not v14:IsSpellInRange(v103.LavaLash))) then
						return "lava_lash single 7";
					end
				end
				if ((v103.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v103.WindfuryTotemBuff, true))) or ((1171 - 655) > (610 + 2824))) then
					if (((5289 - (157 + 1086)) >= (6070 - 3037)) and v23(v103.WindfuryTotem)) then
						return "windfury_totem single 8";
					end
				end
				v167 = 8 - 6;
			end
			if ((v167 == (5 - 1)) or ((3710 - 991) <= (2266 - (599 + 220)))) then
				if ((v103.FlameShock:IsReady() and v42 and (v14:DebuffDown(v103.FlameShockDebuff))) or ((8232 - 4098) < (5857 - (1813 + 118)))) then
					if (v23(v103.FlameShock, not v14:IsSpellInRange(v103.FlameShock)) or ((120 + 44) >= (4002 - (841 + 376)))) then
						return "flame_shock single 17";
					end
				end
				if ((v103.IceStrike:IsReady() and v44 and v103.ElementalAssault:IsAvailable() and v103.SwirlingMaelstrom:IsAvailable()) or ((735 - 210) == (490 + 1619))) then
					if (((89 - 56) == (892 - (464 + 395))) and v23(v103.IceStrike, not v14:IsInMeleeRange(12 - 7))) then
						return "ice_strike single 18";
					end
				end
				if (((1467 + 1587) <= (4852 - (467 + 370))) and v103.LavaLash:IsReady() and v46 and (v103.LashingFlames:IsAvailable())) then
					if (((3866 - 1995) < (2483 + 899)) and v23(v103.LavaLash, not v14:IsSpellInRange(v103.LavaLash))) then
						return "lava_lash single 19";
					end
				end
				if (((4432 - 3139) <= (338 + 1828)) and v103.IceStrike:IsReady() and v44 and (v13:BuffDown(v103.IceStrikeBuff))) then
					if (v23(v103.IceStrike, not v14:IsInMeleeRange(11 - 6)) or ((3099 - (150 + 370)) < (1405 - (74 + 1208)))) then
						return "ice_strike single 20";
					end
				end
				v167 = 12 - 7;
			end
			if ((v167 == (37 - 29)) or ((602 + 244) >= (2758 - (14 + 376)))) then
				if ((v103.FlameShock:IsReady() and v42) or ((6958 - 2946) <= (2173 + 1185))) then
					if (((1313 + 181) <= (2866 + 139)) and v23(v103.FlameShock, not v14:IsSpellInRange(v103.FlameShock))) then
						return "flame_shock single 34";
					end
				end
				if ((v103.ChainLightning:IsReady() and v38 and (v13:BuffStack(v103.MaelstromWeaponBuff) >= (14 - 9)) and v13:BuffUp(v103.CracklingThunderBuff) and v103.ElementalSpirits:IsAvailable()) or ((2341 + 770) == (2212 - (23 + 55)))) then
					if (((5581 - 3226) == (1572 + 783)) and v23(v103.ChainLightning, not v14:IsSpellInRange(v103.ChainLightning))) then
						return "chain_lightning single 35";
					end
				end
				if ((v103.LightningBolt:IsReady() and v47 and (v13:BuffStack(v103.MaelstromWeaponBuff) >= (5 + 0)) and v13:BuffDown(v103.PrimordialWaveBuff)) or ((911 - 323) <= (136 + 296))) then
					if (((5698 - (652 + 249)) >= (10423 - 6528)) and v23(v103.LightningBolt, not v14:IsSpellInRange(v103.LightningBolt))) then
						return "lightning_bolt single 36";
					end
				end
				if (((5445 - (708 + 1160)) == (9709 - 6132)) and v103.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v103.WindfuryTotemBuff, true) or (v103.WindfuryTotem:TimeSinceLastCast() > (164 - 74)))) then
					if (((3821 - (10 + 17)) > (830 + 2863)) and v23(v103.WindfuryTotem)) then
						return "windfury_totem single 37";
					end
				end
				break;
			end
			if ((v167 == (1732 - (1400 + 332))) or ((2445 - 1170) == (6008 - (242 + 1666)))) then
				if ((v103.PrimordialWave:IsCastable() and v48 and ((v64 and v36) or not v64) and (v100 < v123) and v14:DebuffDown(v103.FlameShockDebuff) and v103.LashingFlames:IsAvailable()) or ((681 + 910) >= (1313 + 2267))) then
					if (((838 + 145) <= (2748 - (850 + 90))) and v23(v103.PrimordialWave, not v14:IsSpellInRange(v103.PrimordialWave))) then
						return "primordial_wave single 1";
					end
				end
				if ((v103.FlameShock:IsReady() and v42 and v14:DebuffDown(v103.FlameShockDebuff) and v103.LashingFlames:IsAvailable()) or ((3765 - 1615) <= (2587 - (360 + 1030)))) then
					if (((3336 + 433) >= (3310 - 2137)) and v23(v103.FlameShock, not v14:IsSpellInRange(v103.FlameShock))) then
						return "flame_shock single 2";
					end
				end
				if (((2042 - 557) == (3146 - (909 + 752))) and v103.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v103.MaelstromWeaponBuff) >= (1228 - (109 + 1114))) and v103.ElementalSpirits:IsAvailable() and (v126.FeralSpiritCount >= (6 - 2))) then
					if (v23(v103.ElementalBlast, not v14:IsSpellInRange(v103.ElementalBlast)) or ((1291 + 2024) <= (3024 - (6 + 236)))) then
						return "elemental_blast single 3";
					end
				end
				if ((v103.Sundering:IsReady() and v50 and ((v63 and v36) or not v63) and (v100 < v123) and (v13:HasTier(19 + 11, 2 + 0))) or ((2065 - 1189) >= (5176 - 2212))) then
					if (v23(v103.Sundering, not v14:IsInRange(1141 - (1076 + 57))) or ((368 + 1864) > (3186 - (579 + 110)))) then
						return "sundering single 4";
					end
				end
				v167 = 1 + 0;
			end
		end
	end
	local function v143()
		local v168 = 0 + 0;
		while true do
			if ((v168 == (3 + 1)) or ((2517 - (174 + 233)) <= (927 - 595))) then
				if (((6469 - 2783) > (1411 + 1761)) and v103.FlameShock:IsReady() and v42 and (v103.FireNova:IsAvailable() or v103.PrimordialWave:IsAvailable()) and (v103.FlameShockDebuff:AuraActiveCount() < v118) and (v103.FlameShockDebuff:AuraActiveCount() < (1180 - (663 + 511)))) then
					if (v124.CastCycle(v103.FlameShock, v117, v131, not v14:IsSpellInRange(v103.FlameShock)) or ((3992 + 482) < (179 + 641))) then
						return "flame_shock aoe 17";
					end
					if (((13191 - 8912) >= (1746 + 1136)) and v23(v103.FlameShock, not v14:IsSpellInRange(v103.FlameShock))) then
						return "flame_shock aoe no_cycle 17";
					end
				end
				if ((v103.FireNova:IsReady() and v41 and (v103.FlameShockDebuff:AuraActiveCount() >= (6 - 3))) or ((4911 - 2882) >= (1681 + 1840))) then
					if (v23(v103.FireNova) or ((3964 - 1927) >= (3309 + 1333))) then
						return "fire_nova aoe 18";
					end
				end
				if (((158 + 1562) < (5180 - (478 + 244))) and v103.Stormstrike:IsReady() and v49 and v13:BuffUp(v103.CrashLightningBuff) and (v103.DeeplyRootedElements:IsAvailable() or (v13:BuffStack(v103.ConvergingStormsBuff) == (523 - (440 + 77))))) then
					if (v23(v103.Stormstrike, not v14:IsSpellInRange(v103.Stormstrike)) or ((199 + 237) > (11056 - 8035))) then
						return "stormstrike aoe 19";
					end
				end
				if (((2269 - (655 + 901)) <= (158 + 689)) and v103.CrashLightning:IsReady() and v39 and v103.CrashingStorms:IsAvailable() and v13:BuffUp(v103.CLCrashLightningBuff) and (v118 >= (4 + 0))) then
					if (((1455 + 699) <= (16239 - 12208)) and v23(v103.CrashLightning, not v14:IsInMeleeRange(1453 - (695 + 750)))) then
						return "crash_lightning aoe 20";
					end
				end
				v168 = 16 - 11;
			end
			if (((7121 - 2506) == (18560 - 13945)) and (v168 == (358 - (285 + 66)))) then
				if ((v103.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v103.WindfuryTotemBuff, true) or (v103.WindfuryTotem:TimeSinceLastCast() > (209 - 119)))) or ((5100 - (682 + 628)) == (81 + 419))) then
					if (((388 - (176 + 123)) < (93 + 128)) and v23(v103.WindfuryTotem)) then
						return "windfury_totem aoe 29";
					end
				end
				if (((1490 + 564) >= (1690 - (239 + 30))) and v103.FlameShock:IsReady() and v42 and (v14:DebuffDown(v103.FlameShockDebuff))) then
					if (((189 + 503) < (2940 + 118)) and v23(v103.FlameShock, not v14:IsSpellInRange(v103.FlameShock))) then
						return "flame_shock aoe 30";
					end
				end
				if ((v103.FrostShock:IsReady() and v43 and not v103.Hailstorm:IsAvailable()) or ((5759 - 2505) == (5163 - 3508))) then
					if (v23(v103.FrostShock, not v14:IsSpellInRange(v103.FrostShock)) or ((1611 - (306 + 9)) == (17133 - 12223))) then
						return "frost_shock aoe 31";
					end
				end
				break;
			end
			if (((586 + 2782) == (2067 + 1301)) and (v168 == (2 + 1))) then
				if (((7557 - 4914) < (5190 - (1140 + 235))) and v103.IceStrike:IsReady() and v44 and v103.Hailstorm:IsAvailable() and v13:BuffDown(v103.IceStrikeBuff)) then
					if (((1218 + 695) > (453 + 40)) and v23(v103.IceStrike, not v14:IsInMeleeRange(2 + 3))) then
						return "ice_strike aoe 13";
					end
				end
				if (((4807 - (33 + 19)) > (1238 + 2190)) and v103.FrostShock:IsReady() and v43 and v103.Hailstorm:IsAvailable() and v13:BuffUp(v103.HailstormBuff)) then
					if (((4139 - 2758) <= (1044 + 1325)) and v23(v103.FrostShock, not v14:IsSpellInRange(v103.FrostShock))) then
						return "frost_shock aoe 14";
					end
				end
				if ((v103.Sundering:IsReady() and v50 and ((v63 and v36) or not v63) and (v100 < v123)) or ((9497 - 4654) == (3830 + 254))) then
					if (((5358 - (586 + 103)) > (34 + 329)) and v23(v103.Sundering, not v14:IsInRange(24 - 16))) then
						return "sundering aoe 15";
					end
				end
				if ((v103.FlameShock:IsReady() and v42 and v103.MoltenAssault:IsAvailable() and v14:DebuffDown(v103.FlameShockDebuff)) or ((3365 - (1309 + 179)) >= (5664 - 2526))) then
					if (((2064 + 2678) >= (9737 - 6111)) and v23(v103.FlameShock, not v14:IsSpellInRange(v103.FlameShock))) then
						return "flame_shock aoe 16";
					end
				end
				v168 = 4 + 0;
			end
			if ((v168 == (10 - 5)) or ((9046 - 4506) == (1525 - (295 + 314)))) then
				if ((v103.Windstrike:IsCastable() and v52) or ((2839 - 1683) > (6307 - (1300 + 662)))) then
					if (((7024 - 4787) < (6004 - (1178 + 577))) and v23(v103.Windstrike, not v14:IsSpellInRange(v103.Windstrike))) then
						return "windstrike aoe 21";
					end
				end
				if ((v103.Stormstrike:IsReady() and v49) or ((1394 + 1289) < (67 - 44))) then
					if (((2102 - (851 + 554)) <= (731 + 95)) and v23(v103.Stormstrike, not v14:IsSpellInRange(v103.Stormstrike))) then
						return "stormstrike aoe 22";
					end
				end
				if (((3064 - 1959) <= (2553 - 1377)) and v103.IceStrike:IsReady() and v44) then
					if (((3681 - (115 + 187)) <= (2920 + 892)) and v23(v103.IceStrike, not v14:IsInMeleeRange(5 + 0))) then
						return "ice_strike aoe 23";
					end
				end
				if ((v103.LavaLash:IsReady() and v46) or ((3105 - 2317) >= (2777 - (160 + 1001)))) then
					if (((1622 + 232) <= (2332 + 1047)) and v23(v103.LavaLash, not v14:IsSpellInRange(v103.LavaLash))) then
						return "lava_lash aoe 24";
					end
				end
				v168 = 11 - 5;
			end
			if (((4907 - (237 + 121)) == (5446 - (525 + 372))) and (v168 == (1 - 0))) then
				if ((v103.FlameShock:IsReady() and v42 and (v103.PrimordialWave:IsAvailable() or v103.FireNova:IsAvailable()) and v14:DebuffDown(v103.FlameShockDebuff)) or ((9928 - 6906) >= (3166 - (96 + 46)))) then
					if (((5597 - (643 + 134)) > (794 + 1404)) and v23(v103.FlameShock, not v14:IsSpellInRange(v103.FlameShock))) then
						return "flame_shock aoe 5";
					end
				end
				if ((v103.ElementalBlast:IsReady() and v40 and (not v103.ElementalSpirits:IsAvailable() or (v103.ElementalSpirits:IsAvailable() and ((v103.ElementalBlast:Charges() == v120) or (v126.FeralSpiritCount >= (4 - 2))))) and (v13:BuffStack(v103.MaelstromWeaponBuff) == ((18 - 13) + ((5 + 0) * v24(v103.OverflowingMaelstrom:IsAvailable())))) and (not v103.CrashingStorms:IsAvailable() or (v118 <= (5 - 2)))) or ((2168 - 1107) >= (5610 - (316 + 403)))) then
					if (((907 + 457) <= (12297 - 7824)) and v23(v103.ElementalBlast, not v14:IsSpellInRange(v103.ElementalBlast))) then
						return "elemental_blast aoe 6";
					end
				end
				if ((v103.ChainLightning:IsReady() and v38 and (v13:BuffStack(v103.MaelstromWeaponBuff) == (2 + 3 + ((12 - 7) * v24(v103.OverflowingMaelstrom:IsAvailable()))))) or ((2548 + 1047) <= (1 + 2))) then
					if (v23(v103.ChainLightning, not v14:IsSpellInRange(v103.ChainLightning)) or ((16188 - 11516) == (18396 - 14544))) then
						return "chain_lightning aoe 7";
					end
				end
				if (((3238 - 1679) == (90 + 1469)) and v103.CrashLightning:IsReady() and v39 and (v13:BuffUp(v103.DoomWindsBuff) or v13:BuffDown(v103.CrashLightningBuff) or (v103.AlphaWolf:IsAvailable() and v13:BuffUp(v103.FeralSpiritBuff) and (v130() == (0 - 0))))) then
					if (v23(v103.CrashLightning, not v14:IsInMeleeRange(1 + 7)) or ((5154 - 3402) <= (805 - (12 + 5)))) then
						return "crash_lightning aoe 8";
					end
				end
				v168 = 7 - 5;
			end
			if (((0 - 0) == v168) or ((8304 - 4397) == (438 - 261))) then
				if (((705 + 2765) > (2528 - (1656 + 317))) and v103.CrashLightning:IsReady() and v39 and v103.CrashingStorms:IsAvailable() and ((v103.UnrulyWinds:IsAvailable() and (v118 >= (9 + 1))) or (v118 >= (13 + 2)))) then
					if (v23(v103.CrashLightning, not v14:IsInMeleeRange(21 - 13)) or ((4783 - 3811) == (999 - (5 + 349)))) then
						return "crash_lightning aoe 1";
					end
				end
				if (((15113 - 11931) >= (3386 - (266 + 1005))) and v103.LightningBolt:IsReady() and v47 and ((v103.FlameShockDebuff:AuraActiveCount() >= v118) or (v103.FlameShockDebuff:AuraActiveCount() >= (4 + 2))) and v13:BuffUp(v103.PrimordialWaveBuff) and (v111 == v112) and (v13:BuffDown(v103.SplinteredElementsBuff) or (v123 <= (40 - 28)))) then
					if (((5124 - 1231) < (6125 - (561 + 1135))) and v23(v103.LightningBolt, not v14:IsSpellInRange(v103.LightningBolt))) then
						return "lightning_bolt aoe 2";
					end
				end
				if ((v103.LavaLash:IsReady() and v46 and v103.MoltenAssault:IsAvailable() and (v103.PrimordialWave:IsAvailable() or v103.FireNova:IsAvailable()) and v14:DebuffUp(v103.FlameShockDebuff) and (v103.FlameShockDebuff:AuraActiveCount() < v118) and (v103.FlameShockDebuff:AuraActiveCount() < (7 - 1))) or ((9423 - 6556) < (2971 - (507 + 559)))) then
					if (v23(v103.LavaLash, not v14:IsSpellInRange(v103.LavaLash)) or ((4506 - 2710) >= (12528 - 8477))) then
						return "lava_lash aoe 3";
					end
				end
				if (((2007 - (212 + 176)) <= (4661 - (250 + 655))) and v103.PrimordialWave:IsCastable() and v48 and ((v64 and v36) or not v64) and (v100 < v123) and (v13:BuffDown(v103.PrimordialWaveBuff))) then
					local v247 = 0 - 0;
					while true do
						if (((1054 - 450) == (944 - 340)) and (v247 == (1956 - (1869 + 87)))) then
							if (v124.CastCycle(v103.PrimordialWave, v117, v131, not v14:IsSpellInRange(v103.PrimordialWave)) or ((15552 - 11068) == (2801 - (484 + 1417)))) then
								return "primordial_wave aoe 4";
							end
							if (v23(v103.PrimordialWave, not v14:IsSpellInRange(v103.PrimordialWave)) or ((9557 - 5098) <= (1864 - 751))) then
								return "primordial_wave aoe no_cycle 4";
							end
							break;
						end
					end
				end
				v168 = 774 - (48 + 725);
			end
			if (((5932 - 2300) > (9116 - 5718)) and (v168 == (2 + 0))) then
				if (((10908 - 6826) <= (1377 + 3540)) and v103.Sundering:IsReady() and v50 and ((v63 and v36) or not v63) and (v100 < v123) and (v13:BuffUp(v103.DoomWindsBuff) or v13:HasTier(9 + 21, 855 - (152 + 701)))) then
					if (((6143 - (430 + 881)) >= (531 + 855)) and v23(v103.Sundering, not v14:IsInRange(903 - (557 + 338)))) then
						return "sundering aoe 9";
					end
				end
				if (((41 + 96) == (385 - 248)) and v103.FireNova:IsReady() and v41 and ((v103.FlameShockDebuff:AuraActiveCount() >= (20 - 14)) or ((v103.FlameShockDebuff:AuraActiveCount() >= (10 - 6)) and (v103.FlameShockDebuff:AuraActiveCount() >= v118)))) then
					if (v23(v103.FireNova) or ((3383 - 1813) >= (5133 - (499 + 302)))) then
						return "fire_nova aoe 10";
					end
				end
				if ((v103.LavaLash:IsReady() and v46 and (v103.LashingFlames:IsAvailable())) or ((4930 - (39 + 827)) <= (5020 - 3201))) then
					local v248 = 0 - 0;
					while true do
						if ((v248 == (0 - 0)) or ((7654 - 2668) < (135 + 1439))) then
							if (((12954 - 8528) > (28 + 144)) and v124.CastCycle(v103.LavaLash, v117, v134, not v14:IsSpellInRange(v103.LavaLash))) then
								return "lava_lash aoe 11";
							end
							if (((926 - 340) > (559 - (103 + 1))) and v23(v103.LavaLash, not v14:IsSpellInRange(v103.LavaLash))) then
								return "lava_lash aoe no_cycle 11";
							end
							break;
						end
					end
				end
				if (((1380 - (475 + 79)) == (1785 - 959)) and v103.LavaLash:IsReady() and v46 and ((v103.MoltenAssault:IsAvailable() and v14:DebuffUp(v103.FlameShockDebuff) and (v103.FlameShockDebuff:AuraActiveCount() < v118) and (v103.FlameShockDebuff:AuraActiveCount() < (19 - 13))) or (v103.AshenCatalyst:IsAvailable() and (v13:BuffStack(v103.AshenCatalystBuff) >= (1 + 4))))) then
					if (v23(v103.LavaLash, not v14:IsSpellInRange(v103.LavaLash)) or ((3538 + 481) > (5944 - (1395 + 108)))) then
						return "lava_lash aoe 12";
					end
				end
				v168 = 8 - 5;
			end
			if (((3221 - (7 + 1197)) < (1858 + 2403)) and (v168 == (3 + 3))) then
				if (((5035 - (27 + 292)) > (234 - 154)) and v103.CrashLightning:IsReady() and v39) then
					if (v23(v103.CrashLightning, not v14:IsInMeleeRange(9 - 1)) or ((14707 - 11200) == (6452 - 3180))) then
						return "crash_lightning aoe 25";
					end
				end
				if ((v103.FireNova:IsReady() and v41 and (v103.FlameShockDebuff:AuraActiveCount() >= (3 - 1))) or ((1015 - (43 + 96)) >= (12543 - 9468))) then
					if (((9838 - 5486) > (2120 + 434)) and v23(v103.FireNova)) then
						return "fire_nova aoe 26";
					end
				end
				if ((v103.ElementalBlast:IsReady() and v40 and (not v103.ElementalSpirits:IsAvailable() or (v103.ElementalSpirits:IsAvailable() and ((v103.ElementalBlast:Charges() == v120) or (v126.FeralSpiritCount >= (1 + 1))))) and (v13:BuffStack(v103.MaelstromWeaponBuff) >= (9 - 4)) and (not v103.CrashingStorms:IsAvailable() or (v118 <= (2 + 1)))) or ((8257 - 3851) < (1273 + 2770))) then
					if (v23(v103.ElementalBlast, not v14:IsSpellInRange(v103.ElementalBlast)) or ((139 + 1750) >= (5134 - (1414 + 337)))) then
						return "elemental_blast aoe 27";
					end
				end
				if (((3832 - (1642 + 298)) <= (7127 - 4393)) and v103.ChainLightning:IsReady() and v38 and (v13:BuffStack(v103.MaelstromWeaponBuff) >= (14 - 9))) then
					if (((5706 - 3783) < (730 + 1488)) and v23(v103.ChainLightning, not v14:IsSpellInRange(v103.ChainLightning))) then
						return "chain_lightning aoe 28";
					end
				end
				v168 = 6 + 1;
			end
		end
	end
	local function v144()
		if (((3145 - (357 + 615)) > (267 + 112)) and v76 and v103.EarthShield:IsCastable() and v13:BuffDown(v103.EarthShieldBuff) and ((v77 == "Earth Shield") or (v103.ElementalOrbit:IsAvailable() and v13:BuffUp(v103.LightningShield)))) then
			if (v23(v103.EarthShield) or ((6357 - 3766) == (2921 + 488))) then
				return "earth_shield main 2";
			end
		elseif (((9673 - 5159) > (2659 + 665)) and v76 and v103.LightningShield:IsCastable() and v13:BuffDown(v103.LightningShieldBuff) and ((v77 == "Lightning Shield") or (v103.ElementalOrbit:IsAvailable() and v13:BuffUp(v103.EarthShield)))) then
			if (v23(v103.LightningShield) or ((15 + 193) >= (3035 + 1793))) then
				return "lightning_shield main 2";
			end
		end
		if (((not v107 or (v109 < (601301 - (384 + 917)))) and v53 and v103.WindfuryWeapon:IsCastable()) or ((2280 - (128 + 569)) > (5110 - (1407 + 136)))) then
			if (v23(v103.WindfuryWeapon) or ((3200 - (687 + 1200)) == (2504 - (556 + 1154)))) then
				return "windfury_weapon enchant";
			end
		end
		if (((11166 - 7992) > (2997 - (9 + 86))) and (not v108 or (v110 < (600421 - (275 + 146)))) and v53 and v103.FlametongueWeapon:IsCastable()) then
			if (((671 + 3449) <= (4324 - (29 + 35))) and v23(v103.FlametongueWeapon)) then
				return "flametongue_weapon enchant";
			end
		end
		if (v86 or ((3913 - 3030) > (14271 - 9493))) then
			local v224 = 0 - 0;
			while true do
				if ((v224 == (0 + 0)) or ((4632 - (53 + 959)) >= (5299 - (312 + 96)))) then
					v32 = v138();
					if (((7389 - 3131) > (1222 - (147 + 138))) and v32) then
						return v32;
					end
					break;
				end
			end
		end
		if ((v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) or ((5768 - (813 + 86)) < (819 + 87))) then
			if (v23(v103.AncestralSpirit, nil, true) or ((2269 - 1044) > (4720 - (18 + 474)))) then
				return "resurrection";
			end
		end
		if (((1123 + 2205) > (7304 - 5066)) and v124.TargetIsValid() and v33) then
			if (((4925 - (860 + 226)) > (1708 - (121 + 182))) and not v13:AffectingCombat()) then
				local v243 = 0 + 0;
				while true do
					if ((v243 == (1240 - (988 + 252))) or ((147 + 1146) <= (159 + 348))) then
						v32 = v141();
						if (v32 or ((4866 - (49 + 1921)) < (1695 - (223 + 667)))) then
							return v32;
						end
						break;
					end
				end
			end
		end
	end
	local function v145()
		local v169 = 52 - (51 + 1);
		while true do
			if (((3985 - 1669) == (4959 - 2643)) and (v169 == (1129 - (146 + 979)))) then
				if (v32 or ((726 + 1844) == (2138 - (311 + 294)))) then
					return v32;
				end
				if (v124.TargetIsValid() or ((2462 - 1579) == (619 + 841))) then
					local v249 = v124.HandleDPSPotion(v13:BuffUp(v103.FeralSpiritBuff));
					if (v249 or ((6062 - (496 + 947)) <= (2357 - (1233 + 125)))) then
						return v249;
					end
					if ((v100 < v123) or ((1384 + 2026) > (3693 + 423))) then
						if ((v58 and ((v35 and v65) or not v65)) or ((172 + 731) >= (4704 - (963 + 682)))) then
							local v259 = 0 + 0;
							while true do
								if ((v259 == (1504 - (504 + 1000))) or ((2678 + 1298) < (2602 + 255))) then
									v32 = v140();
									if (((466 + 4464) > (3401 - 1094)) and v32) then
										return v32;
									end
									break;
								end
							end
						end
					end
					if (((v100 < v123) and v59 and ((v66 and v35) or not v66)) or ((3457 + 589) < (751 + 540))) then
						local v255 = 182 - (156 + 26);
						while true do
							if ((v255 == (0 + 0)) or ((6635 - 2394) == (3709 - (149 + 15)))) then
								if ((v103.BloodFury:IsCastable() and (not v103.Ascendance:IsAvailable() or v13:BuffUp(v103.AscendanceBuff) or (v103.Ascendance:CooldownRemains() > (1010 - (890 + 70))))) or ((4165 - (39 + 78)) > (4714 - (14 + 468)))) then
									if (v23(v103.BloodFury) or ((3848 - 2098) >= (9707 - 6234))) then
										return "blood_fury racial";
									end
								end
								if (((1634 + 1532) == (1902 + 1264)) and v103.Berserking:IsCastable() and (not v103.Ascendance:IsAvailable() or v13:BuffUp(v103.AscendanceBuff))) then
									if (((375 + 1388) < (1682 + 2042)) and v23(v103.Berserking)) then
										return "berserking racial";
									end
								end
								v255 = 1 + 0;
							end
							if (((108 - 51) <= (2692 + 31)) and (v255 == (3 - 2))) then
								if ((v103.Fireblood:IsCastable() and (not v103.Ascendance:IsAvailable() or v13:BuffUp(v103.AscendanceBuff) or (v103.Ascendance:CooldownRemains() > (2 + 48)))) or ((2121 - (12 + 39)) == (413 + 30))) then
									if (v23(v103.Fireblood) or ((8372 - 5667) == (4960 - 3567))) then
										return "fireblood racial";
									end
								end
								if ((v103.AncestralCall:IsCastable() and (not v103.Ascendance:IsAvailable() or v13:BuffUp(v103.AscendanceBuff) or (v103.Ascendance:CooldownRemains() > (15 + 35)))) or ((2422 + 2179) < (154 - 93))) then
									if (v23(v103.AncestralCall) or ((926 + 464) >= (22926 - 18182))) then
										return "ancestral_call racial";
									end
								end
								break;
							end
						end
					end
					if ((v103.SpiritWalkersGrace:IsCastable() and v54 and v13:IsMoving()) or ((3713 - (1596 + 114)) > (10009 - 6175))) then
						if (v23(v103.SpiritWalkersGrace) or ((869 - (164 + 549)) > (5351 - (1059 + 379)))) then
							return "spiritwalkers_grace main";
						end
					end
					if (((242 - 47) == (102 + 93)) and v103.TotemicProjection:IsCastable() and (v103.WindfuryTotem:TimeSinceLastCast() < (16 + 74)) and v13:BuffDown(v103.WindfuryTotemBuff, true)) then
						if (((3497 - (145 + 247)) >= (1474 + 322)) and v23(v105.TotemicProjectionPlayer)) then
							return "totemic_projection wind_fury main 0";
						end
					end
					if (((2024 + 2355) >= (6317 - 4186)) and v103.Windstrike:IsCastable() and v52) then
						if (((738 + 3106) >= (1760 + 283)) and v23(v103.Windstrike, not v14:IsSpellInRange(v103.Windstrike))) then
							return "windstrike main 1";
						end
					end
					if ((v103.PrimordialWave:IsCastable() and v48 and ((v64 and v36) or not v64) and (v100 < v123) and (v13:HasTier(50 - 19, 722 - (254 + 466)))) or ((3792 - (544 + 16)) <= (8679 - 5948))) then
						if (((5533 - (294 + 334)) == (5158 - (236 + 17))) and v23(v103.PrimordialWave, not v14:IsSpellInRange(v103.PrimordialWave))) then
							return "primordial_wave main 2";
						end
					end
					if ((v103.FeralSpirit:IsCastable() and v56 and ((v61 and v35) or not v61) and (v100 < v123)) or ((1783 + 2353) >= (3434 + 977))) then
						if (v23(v103.FeralSpirit) or ((11140 - 8182) == (19018 - 15001))) then
							return "feral_spirit main 3";
						end
					end
					if (((633 + 595) >= (670 + 143)) and v103.Ascendance:IsCastable() and v55 and ((v60 and v35) or not v60) and (v100 < v123) and v14:DebuffUp(v103.FlameShockDebuff) and (((v121 == "Lightning Bolt") and (v118 == (795 - (413 + 381)))) or ((v121 == "Chain Lightning") and (v118 > (1 + 0))))) then
						if (v23(v103.Ascendance) or ((7347 - 3892) > (10520 - 6470))) then
							return "ascendance main 4";
						end
					end
					if (((2213 - (582 + 1388)) == (413 - 170)) and v103.DoomWinds:IsCastable() and v57 and ((v62 and v35) or not v62) and (v100 < v123)) then
						if (v23(v103.DoomWinds, not v14:IsInMeleeRange(4 + 1)) or ((635 - (326 + 38)) > (4650 - 3078))) then
							return "doom_winds main 5";
						end
					end
					if (((3909 - 1170) < (3913 - (47 + 573))) and (v118 == (1 + 0))) then
						local v256 = 0 - 0;
						while true do
							if ((v256 == (0 - 0)) or ((5606 - (1269 + 395)) < (1626 - (76 + 416)))) then
								v32 = v142();
								if (v32 or ((3136 - (319 + 124)) == (11367 - 6394))) then
									return v32;
								end
								break;
							end
						end
					end
					if (((3153 - (564 + 443)) == (5940 - 3794)) and v34 and (v118 > (459 - (337 + 121)))) then
						local v257 = 0 - 0;
						while true do
							if ((v257 == (0 - 0)) or ((4155 - (1261 + 650)) == (1364 + 1860))) then
								v32 = v143();
								if (v32 or ((7815 - 2911) <= (3733 - (772 + 1045)))) then
									return v32;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((13 + 77) <= (1209 - (102 + 42))) and (v169 == (1847 - (1524 + 320)))) then
				if (((6072 - (1049 + 221)) == (4958 - (18 + 138))) and v103.Purge:IsReady() and v101 and v37 and v92 and not v13:IsCasting() and not v13:IsChanneling() and v124.UnitHasMagicBuff(v14)) then
					if (v23(v103.Purge, not v14:IsSpellInRange(v103.Purge)) or ((5580 - 3300) <= (1613 - (67 + 1035)))) then
						return "purge damage";
					end
				end
				v32 = v137();
				v169 = 352 - (136 + 212);
			end
			if ((v169 == (0 - 0)) or ((1343 + 333) <= (427 + 36))) then
				v32 = v139();
				if (((5473 - (240 + 1364)) == (4951 - (1050 + 32))) and v32) then
					return v32;
				end
				v169 = 3 - 2;
			end
			if (((685 + 473) <= (3668 - (331 + 724))) and (v169 == (1 + 1))) then
				if (v93 or ((3008 - (269 + 375)) <= (2724 - (267 + 458)))) then
					if (v15 or ((1531 + 3391) < (372 - 178))) then
						local v258 = 818 - (667 + 151);
						while true do
							if ((v258 == (1497 - (1410 + 87))) or ((3988 - (1504 + 393)) < (83 - 52))) then
								v32 = v136();
								if (v32 or ((6304 - 3874) >= (5668 - (461 + 335)))) then
									return v32;
								end
								break;
							end
						end
					end
					if ((v16 and v16:Exists() and not v13:CanAttack(v16) and (v124.UnitHasDispellableDebuffByPlayer(v16) or v124.UnitHasCurseDebuff(v16))) or ((610 + 4160) < (3496 - (1730 + 31)))) then
						if (v103.CleanseSpirit:IsCastable() or ((6106 - (728 + 939)) <= (8322 - 5972))) then
							if (v23(v105.CleanseSpiritMouseover, not v16:IsSpellInRange(v103.PurifySpirit)) or ((9084 - 4605) < (10232 - 5766))) then
								return "purify_spirit dispel mouseover";
							end
						end
					end
				end
				if (((3615 - (138 + 930)) > (1120 + 105)) and v103.GreaterPurge:IsAvailable() and v101 and v103.GreaterPurge:IsReady() and v37 and v92 and not v13:IsCasting() and not v13:IsChanneling() and v124.UnitHasMagicBuff(v14)) then
					if (((3652 + 1019) > (2292 + 382)) and v23(v103.GreaterPurge, not v14:IsSpellInRange(v103.GreaterPurge))) then
						return "greater_purge damage";
					end
				end
				v169 = 12 - 9;
			end
			if ((v169 == (1767 - (459 + 1307))) or ((5566 - (474 + 1396)) < (5809 - 2482))) then
				if (v94 or ((4257 + 285) == (10 + 2960))) then
					local v250 = 0 - 0;
					while true do
						if (((32 + 220) <= (6599 - 4622)) and ((0 - 0) == v250)) then
							if (v88 or ((2027 - (562 + 29)) == (3219 + 556))) then
								v32 = v124.HandleAfflicted(v103.CleanseSpirit, v105.CleanseSpiritMouseover, 1459 - (374 + 1045));
								if (v32 or ((1281 + 337) < (2887 - 1957))) then
									return v32;
								end
							end
							if (((5361 - (448 + 190)) > (1341 + 2812)) and v89) then
								v32 = v124.HandleAfflicted(v103.TremorTotem, v103.TremorTotem, 14 + 16);
								if (v32 or ((2381 + 1273) >= (17893 - 13239))) then
									return v32;
								end
							end
							v250 = 2 - 1;
						end
						if (((2445 - (1307 + 187)) <= (5932 - 4436)) and ((2 - 1) == v250)) then
							if (v90 or ((5322 - 3586) == (1254 - (232 + 451)))) then
								local v260 = 0 + 0;
								while true do
									if (((0 + 0) == v260) or ((1460 - (510 + 54)) > (9608 - 4839))) then
										v32 = v124.HandleAfflicted(v103.PoisonCleansingTotem, v103.PoisonCleansingTotem, 66 - (13 + 23));
										if (v32 or ((2036 - 991) <= (1465 - 445))) then
											return v32;
										end
										break;
									end
								end
							end
							if (((v13:BuffStack(v103.MaelstromWeaponBuff) >= (8 - 3)) and v91) or ((2248 - (830 + 258)) <= (1156 - 828))) then
								local v261 = 0 + 0;
								while true do
									if (((3240 + 568) > (4365 - (860 + 581))) and ((0 - 0) == v261)) then
										v32 = v124.HandleAfflicted(v103.HealingSurge, v105.HealingSurgeMouseover, 32 + 8, true);
										if (((4132 - (237 + 4)) < (11560 - 6641)) and v32) then
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
				if (v95 or ((5652 - 3418) <= (2847 - 1345))) then
					local v251 = 0 + 0;
					while true do
						if ((v251 == (0 + 0)) or ((9483 - 6971) < (186 + 246))) then
							v32 = v124.HandleIncorporeal(v103.Hex, v105.HexMouseOver, 17 + 13, true);
							if (v32 or ((3274 - (85 + 1341)) == (1476 - 611))) then
								return v32;
							end
							break;
						end
					end
				end
				v169 = 5 - 3;
			end
		end
	end
	local function v146()
		v55 = EpicSettings.Settings['useAscendance'];
		v57 = EpicSettings.Settings['useDoomWinds'];
		v56 = EpicSettings.Settings['useFeralSpirit'];
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
		v102 = EpicSettings.Settings['useWeapon'];
		v54 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v60 = EpicSettings.Settings['ascendanceWithCD'];
		v62 = EpicSettings.Settings['doomWindsWithCD'];
		v61 = EpicSettings.Settings['feralSpiritWithCD'];
		v64 = EpicSettings.Settings['primordialWaveWithMiniCD'];
		v63 = EpicSettings.Settings['sunderingWithMiniCD'];
	end
	local function v147()
		v67 = EpicSettings.Settings['useWindShear'];
		v68 = EpicSettings.Settings['useCapacitorTotem'];
		v69 = EpicSettings.Settings['useThunderstorm'];
		v71 = EpicSettings.Settings['useAncestralGuidance'];
		v70 = EpicSettings.Settings['useAstralShift'];
		v73 = EpicSettings.Settings['useMaelstromHealingSurge'];
		v72 = EpicSettings.Settings['useHealingStreamTotem'];
		v79 = EpicSettings.Settings['ancestralGuidanceHP'] or (372 - (45 + 327));
		v80 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 - 0);
		v78 = EpicSettings.Settings['astralShiftHP'] or (502 - (444 + 58));
		v81 = EpicSettings.Settings['healingStreamTotemHP'] or (0 + 0);
		v82 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
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
	local function v148()
		local v210 = 1732 - (64 + 1668);
		while true do
			if (((1977 - (1227 + 746)) == v210) or ((14390 - 9708) <= (8427 - 3886))) then
				v95 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v210 == (495 - (415 + 79))) or ((78 + 2948) >= (4537 - (142 + 349)))) then
				v93 = EpicSettings.Settings['DispelDebuffs'];
				v92 = EpicSettings.Settings['DispelBuffs'];
				v58 = EpicSettings.Settings['useTrinkets'];
				v59 = EpicSettings.Settings['useRacials'];
				v210 = 1 + 1;
			end
			if (((2760 - 752) > (318 + 320)) and (v210 == (2 + 0))) then
				v65 = EpicSettings.Settings['trinketsWithCD'];
				v66 = EpicSettings.Settings['racialsWithCD'];
				v74 = EpicSettings.Settings['useHealthstone'];
				v75 = EpicSettings.Settings['useHealingPotion'];
				v210 = 7 - 4;
			end
			if (((3639 - (1710 + 154)) <= (3551 - (200 + 118))) and (v210 == (0 + 0))) then
				v100 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v97 = EpicSettings.Settings['InterruptWithStun'];
				v98 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v99 = EpicSettings.Settings['InterruptThreshold'];
				v210 = 1 - 0;
			end
			if ((v210 == (3 + 0)) or ((4494 + 49) == (1072 + 925))) then
				v84 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v85 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v96 = EpicSettings.Settings['HealingPotionName'] or "";
				v94 = EpicSettings.Settings['handleAfflicted'];
				v210 = 1254 - (363 + 887);
			end
		end
	end
	local function v149()
		v147();
		v146();
		v148();
		v33 = EpicSettings.Toggles['ooc'];
		v34 = EpicSettings.Toggles['aoe'];
		v35 = EpicSettings.Toggles['cds'];
		v37 = EpicSettings.Toggles['dispel'];
		v36 = EpicSettings.Toggles['minicds'];
		if (v13:IsDeadOrGhost() or ((5416 - 2314) < (3465 - 2737))) then
			return v32;
		end
		v107, v109, _, _, v108, v110 = v26();
		v116 = v13:GetEnemiesInRange(7 + 33);
		v117 = v13:GetEnemiesInMeleeRange(23 - 13);
		if (((236 + 109) == (2009 - (674 + 990))) and v34) then
			v119 = v128(12 + 28);
			v118 = #v117;
		else
			local v225 = 0 + 0;
			while true do
				if ((v225 == (0 - 0)) or ((3882 - (507 + 548)) < (1215 - (289 + 548)))) then
					v119 = 1819 - (821 + 997);
					v118 = 256 - (195 + 60);
					break;
				end
			end
		end
		if ((v37 and v93) or ((935 + 2541) < (4098 - (251 + 1250)))) then
			if (((9019 - 5940) < (3295 + 1499)) and v13:AffectingCombat() and v103.CleanseSpirit:IsAvailable()) then
				local v244 = 1032 - (809 + 223);
				local v245;
				while true do
					if (((7082 - 2228) > (13405 - 8941)) and ((3 - 2) == v244)) then
						if (v32 or ((3618 + 1294) == (1968 + 1790))) then
							return v32;
						end
						break;
					end
					if (((743 - (14 + 603)) <= (3611 - (118 + 11))) and (v244 == (0 + 0))) then
						v245 = v93 and v103.CleanseSpirit:IsReady() and v37;
						v32 = v124.FocusUnit(v245, nil, 17 + 3, nil, 72 - 47, v103.HealingSurge);
						v244 = 950 - (551 + 398);
					end
				end
			end
		end
		if (v124.TargetIsValid() or v13:AffectingCombat() or ((1501 + 873) == (1557 + 2817))) then
			v122 = v9.BossFightRemains(nil, true);
			v123 = v122;
			if (((1280 + 295) == (5857 - 4282)) and (v123 == (25601 - 14490))) then
				v123 = v9.FightRemains(v117, false);
			end
		end
		if (v13:AffectingCombat() or ((725 + 1509) == (5776 - 4321))) then
			if (v13:PrevGCD(1 + 0, v103.ChainLightning) or ((1156 - (40 + 49)) > (6774 - 4995))) then
				v121 = "Chain Lightning";
			elseif (((2651 - (99 + 391)) >= (773 + 161)) and v13:PrevGCD(4 - 3, v103.LightningBolt)) then
				v121 = "Lightning Bolt";
			end
		end
		if (((3991 - 2379) == (1571 + 41)) and not v13:IsChanneling() and not v13:IsChanneling()) then
			if (((11451 - 7099) >= (4437 - (1032 + 572))) and v94) then
				if (v88 or ((3639 - (203 + 214)) < (4890 - (568 + 1249)))) then
					v32 = v124.HandleAfflicted(v103.CleanseSpirit, v105.CleanseSpiritMouseover, 32 + 8);
					if (((1786 - 1042) <= (11363 - 8421)) and v32) then
						return v32;
					end
				end
				if (v89 or ((3139 - (913 + 393)) <= (3733 - 2411))) then
					local v252 = 0 - 0;
					while true do
						if ((v252 == (410 - (269 + 141))) or ((7710 - 4243) <= (3036 - (362 + 1619)))) then
							v32 = v124.HandleAfflicted(v103.TremorTotem, v103.TremorTotem, 1655 - (950 + 675));
							if (((1366 + 2175) == (4720 - (216 + 963))) and v32) then
								return v32;
							end
							break;
						end
					end
				end
				if (v90 or ((4844 - (485 + 802)) >= (4562 - (432 + 127)))) then
					local v253 = 1073 - (1065 + 8);
					while true do
						if (((0 + 0) == v253) or ((2258 - (635 + 966)) >= (1200 + 468))) then
							v32 = v124.HandleAfflicted(v103.PoisonCleansingTotem, v103.PoisonCleansingTotem, 72 - (5 + 37));
							if (v32 or ((2553 - 1526) > (1606 + 2252))) then
								return v32;
							end
							break;
						end
					end
				end
				if (((v13:BuffStack(v103.MaelstromWeaponBuff) >= (7 - 2)) and v91) or ((1710 + 1944) < (935 - 485))) then
					v32 = v124.HandleAfflicted(v103.HealingSurge, v105.HealingSurgeMouseover, 151 - 111, true);
					if (((3565 - 1674) < (10646 - 6193)) and v32) then
						return v32;
					end
				end
			end
			if (v13:AffectingCombat() or ((2258 + 882) < (2658 - (318 + 211)))) then
				v32 = v145();
				if (v32 or ((12571 - 10016) < (2827 - (963 + 624)))) then
					return v32;
				end
			else
				local v246 = 0 + 0;
				while true do
					if ((v246 == (846 - (518 + 328))) or ((11019 - 6292) <= (7547 - 2825))) then
						v32 = v144();
						if (((1057 - (301 + 16)) < (14469 - 9532)) and v32) then
							return v32;
						end
						break;
					end
				end
			end
		end
	end
	local function v150()
		local v216 = 0 - 0;
		while true do
			if (((9545 - 5887) >= (254 + 26)) and (v216 == (1 + 0))) then
				v20.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
				break;
			end
			if ((v216 == (0 - 0)) or ((533 + 352) >= (99 + 932))) then
				v103.FlameShockDebuff:RegisterAuraTracking();
				v129();
				v216 = 3 - 2;
			end
		end
	end
	v20.SetAPL(85 + 178, v149, v150);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

