local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((10127 - 5189) < (7714 - 2952))) then
			v6 = v0[v4];
			if (not v6 or ((4609 - 2105) > (774 + 3490))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((1582 + 571) == (4280 - 2127)) and (v5 == (3 - 2))) then
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
	local v103;
	local v104 = v18.Shaman.Enhancement;
	local v105 = v20.Shaman.Enhancement;
	local v106 = v23.Shaman.Enhancement;
	local v107 = {};
	local v108, v109;
	local v110, v111;
	local v112;
	local v113 = 523 - (203 + 310);
	local v114 = 2001 - (1238 + 755);
	local v115 = 1 + 5;
	local v116 = 2534 - (709 + 825);
	local v117, v118, v119, v120;
	local v121 = (v104.LavaBurst:IsAvailable() and (3 - 1)) or (1 - 0);
	local v122 = "Lightning Bolt";
	local v123 = 11975 - (196 + 668);
	local v124 = 43869 - 32758;
	local v125 = v21.Commons.Everyone;
	v21.Commons.Shaman = {};
	local v127 = v21.Commons.Shaman;
	v127.FeralSpiritCount = 0 - 0;
	v10:RegisterForEvent(function()
		v121 = (v104.LavaBurst:IsAvailable() and (835 - (171 + 662))) or (94 - (4 + 89));
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		local v152 = 0 - 0;
		while true do
			if ((v152 == (0 + 0)) or ((2226 - 1719) >= (1017 + 1574))) then
				v122 = "Lightning Bolt";
				v123 = 12597 - (35 + 1451);
				v152 = 1454 - (28 + 1425);
			end
			if (((6474 - (941 + 1052)) == (4297 + 184)) and (v152 == (1515 - (822 + 692)))) then
				v124 = 15862 - 4751;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v129(v153)
		local v154 = 0 + 0;
		local v155;
		local v156;
		while true do
			if ((v154 == (297 - (45 + 252))) or ((2304 + 24) < (239 + 454))) then
				v155 = v14:GetEnemiesInRange(v153);
				v156 = 2 - 1;
				v154 = 434 - (114 + 319);
			end
			if (((6213 - 1885) == (5545 - 1217)) and (v154 == (1 + 0))) then
				for v241, v242 in pairs(v155) do
					if (((2365 - 777) >= (2790 - 1458)) and (v242:GUID() ~= v15:GUID()) and (v242:AffectingCombat() or v242:IsDummy())) then
						v156 = v156 + (1964 - (556 + 1407));
					end
				end
				return v156;
			end
		end
	end
	v10:RegisterForSelfCombatEvent(function(...)
		local v157 = 1206 - (741 + 465);
		local v158;
		local v159;
		local v160;
		while true do
			if ((v157 == (466 - (170 + 295))) or ((2200 + 1974) > (3902 + 346))) then
				if ((v14:HasTier(76 - 45, 2 + 0) and (v158 == v14:GUID()) and (v160 == (241118 + 134864))) or ((2597 + 1989) <= (1312 - (957 + 273)))) then
					local v243 = 0 + 0;
					while true do
						if (((1547 + 2316) == (14719 - 10856)) and (v243 == (0 - 0))) then
							v127.FeralSpiritCount = v127.FeralSpiritCount + (2 - 1);
							v32.After(74 - 59, function()
								v127.FeralSpiritCount = v127.FeralSpiritCount - (1781 - (389 + 1391));
							end);
							break;
						end
					end
				end
				if (((v158 == v14:GUID()) and (v160 == (32332 + 19201))) or ((30 + 252) <= (95 - 53))) then
					local v244 = 951 - (783 + 168);
					while true do
						if (((15468 - 10859) >= (754 + 12)) and (v244 == (311 - (309 + 2)))) then
							v127.FeralSpiritCount = v127.FeralSpiritCount + (5 - 3);
							v32.After(1227 - (1090 + 122), function()
								v127.FeralSpiritCount = v127.FeralSpiritCount - (1 + 1);
							end);
							break;
						end
					end
				end
				break;
			end
			if ((v157 == (0 - 0)) or ((789 + 363) == (3606 - (628 + 490)))) then
				v158, v159, v159, v159, v159, v159, v159, v159, v160 = select(1 + 3, ...);
				if (((8472 - 5050) > (15309 - 11959)) and (v158 == v14:GUID()) and (v160 == (192408 - (431 + 343)))) then
					v127.LastSKCast = v31();
				end
				v157 = 1 - 0;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	local function v130()
		if (((2536 - 1659) > (298 + 78)) and v104.CleanseSpirit:IsAvailable()) then
			v125.DispellableDebuffs = v125.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v130();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v131()
		local v161 = 0 + 0;
		local v162;
		while true do
			if ((v161 == (1695 - (556 + 1139))) or ((3133 - (6 + 9)) <= (339 + 1512))) then
				if (not v104.AlphaWolf:IsAvailable() or v14:BuffDown(v104.FeralSpiritBuff) or ((85 + 80) >= (3661 - (28 + 141)))) then
					return 0 + 0;
				end
				v162 = v29(v104.CrashLightning:TimeSinceLastCast(), v104.ChainLightning:TimeSinceLastCast());
				v161 = 1 - 0;
			end
			if (((2797 + 1152) < (6173 - (486 + 831))) and (v161 == (2 - 1))) then
				if ((v162 > (27 - 19)) or (v162 > v104.FeralSpirit:TimeSinceLastCast()) or ((809 + 3467) < (9536 - 6520))) then
					return 1263 - (668 + 595);
				end
				return (8 + 0) - v162;
			end
		end
	end
	local function v132(v163)
		return (v163:DebuffRefreshable(v104.FlameShockDebuff));
	end
	local function v133(v164)
		return v164:DebuffRemains(v104.FlameShockDebuff);
	end
	local function v134(v165)
		return v14:BuffDown(v104.PrimordialWaveBuff);
	end
	local function v135(v166)
		return v166:DebuffRemains(v104.LashingFlamesDebuff);
	end
	local v136 = 0 + 0;
	local function v137()
		if (((12790 - 8100) > (4415 - (23 + 267))) and v104.CleanseSpirit:IsReady() and v38 and (v125.UnitHasDispellableDebuffByPlayer(v16) or v125.DispellableFriendlyUnit(1964 - (1129 + 815)) or v125.UnitHasCurseDebuff(v16))) then
			local v196 = 387 - (371 + 16);
			while true do
				if ((v196 == (1750 - (1326 + 424))) or ((94 - 44) >= (3274 - 2378))) then
					if ((v136 == (118 - (88 + 30))) or ((2485 - (720 + 51)) >= (6579 - 3621))) then
						v136 = v31();
					end
					if (v125.Wait(2276 - (421 + 1355), v136) or ((2459 - 968) < (317 + 327))) then
						if (((1787 - (286 + 797)) < (3608 - 2621)) and v24(v106.CleanseSpiritFocus)) then
							return "cleanse_spirit dispel";
						end
						v136 = 0 - 0;
					end
					break;
				end
			end
		end
	end
	local function v138()
		local v167 = 439 - (397 + 42);
		while true do
			if (((1162 + 2556) > (2706 - (24 + 776))) and (v167 == (0 - 0))) then
				if (not v16 or not v16:Exists() or not v16:IsInRange(825 - (222 + 563)) or ((2110 - 1152) > (2618 + 1017))) then
					return;
				end
				if (((3691 - (23 + 167)) <= (6290 - (690 + 1108))) and v16) then
					if (((v16:HealthPercentage() <= v84) and v74 and v104.HealingSurge:IsReady() and (v14:BuffStack(v104.MaelstromWeaponBuff) >= (2 + 3))) or ((2840 + 602) < (3396 - (40 + 808)))) then
						if (((474 + 2401) >= (5598 - 4134)) and v24(v106.HealingSurgeFocus)) then
							return "healing_surge heal focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v139()
		if ((v14:HealthPercentage() <= v88) or ((4585 + 212) >= (2589 + 2304))) then
			if (v104.HealingSurge:IsReady() or ((303 + 248) > (2639 - (47 + 524)))) then
				if (((1372 + 742) > (2580 - 1636)) and v24(v104.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v140()
		local v168 = 0 - 0;
		while true do
			if ((v168 == (2 - 1)) or ((3988 - (1165 + 561)) >= (92 + 3004))) then
				if ((v104.HealingStreamTotem:IsReady() and v73 and v125.AreUnitsBelowHealthPercentage(v82, v83, v104.HealingSurge)) or ((6984 - 4729) >= (1350 + 2187))) then
					if (v24(v104.HealingStreamTotem) or ((4316 - (341 + 138)) < (353 + 953))) then
						return "healing_stream_totem defensive 3";
					end
				end
				if (((6088 - 3138) == (3276 - (89 + 237))) and v104.HealingSurge:IsReady() and v74 and (v14:HealthPercentage() <= v84) and (v14:BuffStack(v104.MaelstromWeaponBuff) >= (16 - 11))) then
					if (v24(v104.HealingSurge) or ((9943 - 5220) < (4179 - (581 + 300)))) then
						return "healing_surge defensive 4";
					end
				end
				v168 = 1222 - (855 + 365);
			end
			if (((2697 - 1561) >= (51 + 103)) and (v168 == (1237 - (1030 + 205)))) then
				if ((v105.Healthstone:IsReady() and v75 and (v14:HealthPercentage() <= v85)) or ((255 + 16) > (4417 + 331))) then
					if (((5026 - (156 + 130)) >= (7161 - 4009)) and v24(v106.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if ((v76 and (v14:HealthPercentage() <= v86)) or ((4344 - 1766) >= (6943 - 3553))) then
					local v246 = 0 + 0;
					while true do
						if (((24 + 17) <= (1730 - (10 + 59))) and (v246 == (1 + 0))) then
							if (((2959 - 2358) < (4723 - (671 + 492))) and (v97 == "Potion of Withering Dreams")) then
								if (((188 + 47) < (1902 - (369 + 846))) and v105.PotionOfWitheringDreams:IsReady()) then
									if (((1205 + 3344) > (984 + 169)) and v24(v106.RefreshingHealingPotion)) then
										return "potion of withering dreams defensive";
									end
								end
							end
							break;
						end
						if ((v246 == (1945 - (1036 + 909))) or ((3717 + 957) < (7843 - 3171))) then
							if (((3871 - (11 + 192)) < (2305 + 2256)) and (v97 == "Refreshing Healing Potion")) then
								if (v105.RefreshingHealingPotion:IsReady() or ((630 - (135 + 40)) == (8734 - 5129))) then
									if (v24(v106.RefreshingHealingPotion) or ((1606 + 1057) == (7296 - 3984))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((6410 - 2133) <= (4651 - (50 + 126))) and (v97 == "Dreamwalker's Healing Potion")) then
								if (v105.DreamwalkersHealingPotion:IsReady() or ((2422 - 1552) == (264 + 925))) then
									if (((2966 - (1233 + 180)) <= (4102 - (522 + 447))) and v24(v106.RefreshingHealingPotion)) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							v246 = 1422 - (107 + 1314);
						end
					end
				end
				break;
			end
			if ((v168 == (0 + 0)) or ((6816 - 4579) >= (1492 + 2019))) then
				if ((v104.AstralShift:IsReady() and v71 and (v14:HealthPercentage() <= v79)) or ((2628 - 1304) > (11948 - 8928))) then
					if (v24(v104.AstralShift) or ((4902 - (716 + 1194)) == (33 + 1848))) then
						return "astral_shift defensive 1";
					end
				end
				if (((333 + 2773) > (2029 - (74 + 429))) and v104.AncestralGuidance:IsReady() and v72 and v125.AreUnitsBelowHealthPercentage(v80, v81, v104.HealingSurge)) then
					if (((5831 - 2808) < (1919 + 1951)) and v24(v104.AncestralGuidance)) then
						return "ancestral_guidance defensive 2";
					end
				end
				v168 = 2 - 1;
			end
		end
	end
	local function v141()
		local v169 = 0 + 0;
		while true do
			if (((440 - 297) > (182 - 108)) and (v169 == (434 - (279 + 154)))) then
				v33 = v125.HandleBottomTrinket(v107, v36, 818 - (454 + 324), nil);
				if (((15 + 3) < (2129 - (12 + 5))) and v33) then
					return v33;
				end
				break;
			end
			if (((592 + 505) <= (4147 - 2519)) and (v169 == (0 + 0))) then
				v33 = v125.HandleTopTrinket(v107, v36, 1133 - (277 + 816), nil);
				if (((19784 - 15154) == (5813 - (1058 + 125))) and v33) then
					return v33;
				end
				v169 = 1 + 0;
			end
		end
	end
	local function v142()
		local v170 = 975 - (815 + 160);
		while true do
			if (((15188 - 11648) > (6368 - 3685)) and (v170 == (0 + 0))) then
				if (((14013 - 9219) >= (5173 - (41 + 1857))) and v104.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v104.WindfuryTotemBuff, true) or (v104.WindfuryTotem:TimeSinceLastCast() > (1983 - (1222 + 671))))) then
					if (((3835 - 2351) == (2132 - 648)) and v24(v104.WindfuryTotem)) then
						return "windfury_totem precombat 2";
					end
				end
				if (((2614 - (229 + 953)) < (5329 - (1111 + 663))) and v104.PrimordialWave:IsReady() and v49 and ((v65 and v37) or not v65)) then
					if (v24(v104.PrimordialWave, not v15:IsSpellInRange(v104.PrimordialWave)) or ((2644 - (874 + 705)) > (501 + 3077))) then
						return "primordial_wave precombat 4";
					end
				end
				v170 = 1 + 0;
			end
			if ((v170 == (1 - 0)) or ((135 + 4660) < (2086 - (642 + 37)))) then
				if (((423 + 1430) < (770 + 4043)) and v104.FeralSpirit:IsCastable() and v57 and ((v62 and v36) or not v62)) then
					if (v24(v104.FeralSpirit) or ((7082 - 4261) < (2885 - (233 + 221)))) then
						return "feral_spirit precombat 6";
					end
				end
				if ((v104.FlameShock:IsReady() and v43) or ((6645 - 3771) < (1920 + 261))) then
					if (v24(v104.FlameShock, not v15:IsSpellInRange(v104.FlameShock)) or ((4230 - (718 + 823)) <= (216 + 127))) then
						return "flame_shock precombat 8";
					end
				end
				break;
			end
		end
	end
	local function v143()
		local v171 = 805 - (266 + 539);
		while true do
			if ((v171 == (2 - 1)) or ((3094 - (636 + 589)) == (4768 - 2759))) then
				if ((v104.LavaLash:IsReady() and v47 and (v14:BuffUp(v104.HotHandBuff))) or ((7313 - 3767) < (1841 + 481))) then
					if (v24(v104.LavaLash, not v15:IsSpellInRange(v104.LavaLash)) or ((757 + 1325) == (5788 - (657 + 358)))) then
						return "lava_lash single 7";
					end
				end
				if (((8589 - 5345) > (2403 - 1348)) and v104.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v104.WindfuryTotemBuff, true))) then
					if (v24(v104.WindfuryTotem) or ((4500 - (1151 + 36)) <= (1717 + 61))) then
						return "windfury_totem single 8";
					end
				end
				if ((v104.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v104.MaelstromWeaponBuff) >= (2 + 3)) and (v104.ElementalBlast:Charges() == v121)) or ((4243 - 2822) >= (3936 - (1552 + 280)))) then
					if (((2646 - (64 + 770)) <= (2206 + 1043)) and v24(v104.ElementalBlast, not v15:IsSpellInRange(v104.ElementalBlast))) then
						return "elemental_blast single 9";
					end
				end
				if (((3684 - 2061) <= (348 + 1609)) and v104.LightningBolt:IsReady() and v48 and (v14:BuffStack(v104.MaelstromWeaponBuff) >= (1251 - (157 + 1086))) and v14:BuffUp(v104.PrimordialWaveBuff) and (v14:BuffDown(v104.SplinteredElementsBuff) or (v124 <= (23 - 11)))) then
					if (((19323 - 14911) == (6767 - 2355)) and v24(v104.LightningBolt, not v15:IsSpellInRange(v104.LightningBolt))) then
						return "lightning_bolt single 10";
					end
				end
				if (((2388 - 638) >= (1661 - (599 + 220))) and v104.ChainLightning:IsReady() and v39 and (v14:BuffStack(v104.MaelstromWeaponBuff) >= (15 - 7)) and v14:BuffUp(v104.CracklingThunderBuff) and v104.ElementalSpirits:IsAvailable()) then
					if (((6303 - (1813 + 118)) > (1353 + 497)) and v24(v104.ChainLightning, not v15:IsSpellInRange(v104.ChainLightning))) then
						return "chain_lightning single 11";
					end
				end
				if (((1449 - (841 + 376)) < (1150 - 329)) and v104.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v104.MaelstromWeaponBuff) >= (2 + 6)) and ((v127.FeralSpiritCount >= (5 - 3)) or not v104.ElementalSpirits:IsAvailable())) then
					if (((1377 - (464 + 395)) < (2314 - 1412)) and v24(v104.ElementalBlast, not v15:IsSpellInRange(v104.ElementalBlast))) then
						return "elemental_blast single 12";
					end
				end
				v171 = 1 + 1;
			end
			if (((3831 - (467 + 370)) > (1772 - 914)) and (v171 == (3 + 1))) then
				if ((v104.Stormstrike:IsReady() and v50) or ((12872 - 9117) <= (143 + 772))) then
					if (((9180 - 5234) > (4263 - (150 + 370))) and v24(v104.Stormstrike, not v15:IsSpellInRange(v104.Stormstrike))) then
						return "stormstrike single 25";
					end
				end
				if ((v104.Sundering:IsReady() and v51 and ((v64 and v37) or not v64) and (v101 < v124)) or ((2617 - (74 + 1208)) >= (8131 - 4825))) then
					if (((22973 - 18129) > (1604 + 649)) and v24(v104.Sundering, not v15:IsInRange(398 - (14 + 376)))) then
						return "sundering single 26";
					end
				end
				if (((783 - 331) == (293 + 159)) and v104.BagofTricks:IsReady() and v60 and ((v67 and v36) or not v67)) then
					if (v24(v104.BagofTricks) or ((4004 + 553) < (1991 + 96))) then
						return "bag_of_tricks single 27";
					end
				end
				if (((11351 - 7477) == (2915 + 959)) and v104.FireNova:IsReady() and v42 and v104.SwirlingMaelstrom:IsAvailable() and (v104.FlameShockDebuff:AuraActiveCount() > (78 - (23 + 55))) and (v14:BuffStack(v104.MaelstromWeaponBuff) < ((11 - 6) + ((4 + 1) * v25(v104.OverflowingMaelstrom:IsAvailable()))))) then
					if (v24(v104.FireNova) or ((1741 + 197) > (7651 - 2716))) then
						return "fire_nova single 28";
					end
				end
				if ((v104.LightningBolt:IsReady() and v48 and v104.Hailstorm:IsAvailable() and (v14:BuffStack(v104.MaelstromWeaponBuff) >= (2 + 3)) and v14:BuffDown(v104.PrimordialWaveBuff)) or ((5156 - (652 + 249)) < (9160 - 5737))) then
					if (((3322 - (708 + 1160)) <= (6761 - 4270)) and v24(v104.LightningBolt, not v15:IsSpellInRange(v104.LightningBolt))) then
						return "lightning_bolt single 29";
					end
				end
				if ((v104.FrostShock:IsReady() and v44) or ((7578 - 3421) <= (2830 - (10 + 17)))) then
					if (((1090 + 3763) >= (4714 - (1400 + 332))) and v24(v104.FrostShock, not v15:IsSpellInRange(v104.FrostShock))) then
						return "frost_shock single 30";
					end
				end
				v171 = 9 - 4;
			end
			if (((6042 - (242 + 1666)) > (1437 + 1920)) and ((2 + 1) == v171)) then
				if ((v104.LavaLash:IsReady() and v47 and (v104.LashingFlames:IsAvailable())) or ((2913 + 504) < (3474 - (850 + 90)))) then
					if (v24(v104.LavaLash, not v15:IsSpellInRange(v104.LavaLash)) or ((4767 - 2045) <= (1554 - (360 + 1030)))) then
						return "lava_lash single 19";
					end
				end
				if ((v104.IceStrike:IsReady() and v45 and (v14:BuffDown(v104.IceStrikeBuff))) or ((2132 + 276) < (5952 - 3843))) then
					if (v24(v104.IceStrike, not v15:IsInMeleeRange(6 - 1)) or ((1694 - (909 + 752)) == (2678 - (109 + 1114)))) then
						return "ice_strike single 20";
					end
				end
				if ((v104.FrostShock:IsReady() and v44 and (v14:BuffUp(v104.HailstormBuff))) or ((810 - 367) >= (1563 + 2452))) then
					if (((3624 - (6 + 236)) > (105 + 61)) and v24(v104.FrostShock, not v15:IsSpellInRange(v104.FrostShock))) then
						return "frost_shock single 21";
					end
				end
				if ((v104.LavaLash:IsReady() and v47) or ((226 + 54) == (7213 - 4154))) then
					if (((3285 - 1404) > (2426 - (1076 + 57))) and v24(v104.LavaLash, not v15:IsSpellInRange(v104.LavaLash))) then
						return "lava_lash single 22";
					end
				end
				if (((388 + 1969) == (3046 - (579 + 110))) and v104.IceStrike:IsReady() and v45) then
					if (((10 + 113) == (109 + 14)) and v24(v104.IceStrike, not v15:IsInMeleeRange(3 + 2))) then
						return "ice_strike single 23";
					end
				end
				if ((v104.Windstrike:IsCastable() and v53) or ((1463 - (174 + 233)) >= (9474 - 6082))) then
					if (v24(v104.Windstrike, not v15:IsSpellInRange(v104.Windstrike)) or ((1897 - 816) < (479 + 596))) then
						return "windstrike single 24";
					end
				end
				v171 = 1178 - (663 + 511);
			end
			if ((v171 == (5 + 0)) or ((228 + 821) >= (13663 - 9231))) then
				if ((v104.CrashLightning:IsReady() and v40) or ((2888 + 1880) <= (1991 - 1145))) then
					if (v24(v104.CrashLightning, not v15:IsInMeleeRange(19 - 11)) or ((1603 + 1755) <= (2763 - 1343))) then
						return "crash_lightning single 31";
					end
				end
				if ((v104.FireNova:IsReady() and v42 and (v15:DebuffUp(v104.FlameShockDebuff))) or ((2665 + 1074) <= (275 + 2730))) then
					if (v24(v104.FireNova) or ((2381 - (478 + 244)) >= (2651 - (440 + 77)))) then
						return "fire_nova single 32";
					end
				end
				if ((v104.FlameShock:IsReady() and v43) or ((1483 + 1777) < (8619 - 6264))) then
					if (v24(v104.FlameShock, not v15:IsSpellInRange(v104.FlameShock)) or ((2225 - (655 + 901)) == (784 + 3439))) then
						return "flame_shock single 34";
					end
				end
				if ((v104.ChainLightning:IsReady() and v39 and (v14:BuffStack(v104.MaelstromWeaponBuff) >= (4 + 1)) and v14:BuffUp(v104.CracklingThunderBuff) and v104.ElementalSpirits:IsAvailable()) or ((1143 + 549) < (2368 - 1780))) then
					if (v24(v104.ChainLightning, not v15:IsSpellInRange(v104.ChainLightning)) or ((6242 - (695 + 750)) < (12467 - 8816))) then
						return "chain_lightning single 35";
					end
				end
				if ((v104.LightningBolt:IsReady() and v48 and (v14:BuffStack(v104.MaelstromWeaponBuff) >= (7 - 2)) and v14:BuffDown(v104.PrimordialWaveBuff)) or ((16798 - 12621) > (5201 - (285 + 66)))) then
					if (v24(v104.LightningBolt, not v15:IsSpellInRange(v104.LightningBolt)) or ((932 - 532) > (2421 - (682 + 628)))) then
						return "lightning_bolt single 36";
					end
				end
				if (((492 + 2559) > (1304 - (176 + 123))) and v104.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v104.WindfuryTotemBuff, true) or (v104.WindfuryTotem:TimeSinceLastCast() > (38 + 52)))) then
					if (((2679 + 1014) <= (4651 - (239 + 30))) and v24(v104.WindfuryTotem)) then
						return "windfury_totem single 37";
					end
				end
				break;
			end
			if ((v171 == (1 + 1)) or ((3155 + 127) > (7256 - 3156))) then
				if ((v104.LavaBurst:IsReady() and v46 and not v104.ThorimsInvocation:IsAvailable() and (v14:BuffStack(v104.MaelstromWeaponBuff) >= (15 - 10))) or ((3895 - (306 + 9)) < (9924 - 7080))) then
					if (((16 + 73) < (2755 + 1735)) and v24(v104.LavaBurst, not v15:IsSpellInRange(v104.LavaBurst))) then
						return "lava_burst single 13";
					end
				end
				if ((v104.LightningBolt:IsReady() and v48 and ((v14:BuffStack(v104.MaelstromWeaponBuff) >= (4 + 4)) or (v104.StaticAccumulation:IsAvailable() and (v14:BuffStack(v104.MaelstromWeaponBuff) >= (14 - 9)))) and v14:BuffDown(v104.PrimordialWaveBuff)) or ((6358 - (1140 + 235)) < (1151 + 657))) then
					if (((3512 + 317) > (968 + 2801)) and v24(v104.LightningBolt, not v15:IsSpellInRange(v104.LightningBolt))) then
						return "lightning_bolt single 14";
					end
				end
				if (((1537 - (33 + 19)) <= (1049 + 1855)) and v104.CrashLightning:IsReady() and v40 and v104.AlphaWolf:IsAvailable() and v14:BuffUp(v104.FeralSpiritBuff) and (v131() == (0 - 0))) then
					if (((1881 + 2388) == (8371 - 4102)) and v24(v104.CrashLightning, not v15:IsInMeleeRange(8 + 0))) then
						return "crash_lightning single 15";
					end
				end
				if (((1076 - (586 + 103)) <= (254 + 2528)) and v104.PrimordialWave:IsCastable() and v49 and ((v65 and v37) or not v65) and (v101 < v124)) then
					if (v24(v104.PrimordialWave, not v15:IsSpellInRange(v104.PrimordialWave)) or ((5846 - 3947) <= (2405 - (1309 + 179)))) then
						return "primordial_wave single 16";
					end
				end
				if ((v104.FlameShock:IsReady() and v43 and (v15:DebuffDown(v104.FlameShockDebuff))) or ((7783 - 3471) <= (382 + 494))) then
					if (((5994 - 3762) <= (1961 + 635)) and v24(v104.FlameShock, not v15:IsSpellInRange(v104.FlameShock))) then
						return "flame_shock single 17";
					end
				end
				if (((4451 - 2356) < (7344 - 3658)) and v104.IceStrike:IsReady() and v45 and v104.ElementalAssault:IsAvailable() and v104.SwirlingMaelstrom:IsAvailable()) then
					if (v24(v104.IceStrike, not v15:IsInMeleeRange(614 - (295 + 314))) or ((3917 - 2322) >= (6436 - (1300 + 662)))) then
						return "ice_strike single 18";
					end
				end
				v171 = 9 - 6;
			end
			if ((v171 == (1755 - (1178 + 577))) or ((2399 + 2220) < (8519 - 5637))) then
				if ((v104.PrimordialWave:IsCastable() and v49 and ((v65 and v37) or not v65) and (v101 < v124) and v15:DebuffDown(v104.FlameShockDebuff) and v104.LashingFlames:IsAvailable()) or ((1699 - (851 + 554)) >= (4272 + 559))) then
					if (((5626 - 3597) <= (6697 - 3613)) and v24(v104.PrimordialWave, not v15:IsSpellInRange(v104.PrimordialWave))) then
						return "primordial_wave single 1";
					end
				end
				if ((v104.FlameShock:IsReady() and v43 and v15:DebuffDown(v104.FlameShockDebuff) and v104.LashingFlames:IsAvailable()) or ((2339 - (115 + 187)) == (1854 + 566))) then
					if (((4221 + 237) > (15384 - 11480)) and v24(v104.FlameShock, not v15:IsSpellInRange(v104.FlameShock))) then
						return "flame_shock single 2";
					end
				end
				if (((1597 - (160 + 1001)) >= (108 + 15)) and v104.ElementalBlast:IsReady() and v41 and (v14:BuffStack(v104.MaelstromWeaponBuff) >= (4 + 1)) and v104.ElementalSpirits:IsAvailable() and (v127.FeralSpiritCount >= (7 - 3))) then
					if (((858 - (237 + 121)) < (2713 - (525 + 372))) and v24(v104.ElementalBlast, not v15:IsSpellInRange(v104.ElementalBlast))) then
						return "elemental_blast single 3";
					end
				end
				if (((6775 - 3201) == (11742 - 8168)) and v104.Sundering:IsReady() and v51 and ((v64 and v37) or not v64) and (v101 < v124) and (v14:HasTier(172 - (96 + 46), 779 - (643 + 134)))) then
					if (((80 + 141) < (935 - 545)) and v24(v104.Sundering, not v15:IsInRange(29 - 21))) then
						return "sundering single 4";
					end
				end
				if ((v104.LightningBolt:IsCastable() and v48 and (v14:BuffStack(v104.MaelstromWeaponBuff) >= (5 + 0)) and v14:BuffDown(v104.CracklingThunderBuff) and v14:BuffUp(v104.AscendanceBuff) and (v122 == "Chain Lightning") and (v14:BuffRemains(v104.AscendanceBuff) > (v104.ChainLightning:CooldownRemains() + v14:GCD()))) or ((4342 - 2129) <= (2904 - 1483))) then
					if (((3777 - (316 + 403)) < (3231 + 1629)) and v24(v104.LightningBolt, not v15:IsSpellInRange(v104.LightningBolt))) then
						return "lightning_bolt single 5";
					end
				end
				if ((v104.Stormstrike:IsReady() and v50 and (v14:BuffUp(v104.DoomWindsBuff) or v104.DeeplyRootedElements:IsAvailable() or (v104.Stormblast:IsAvailable() and v14:BuffUp(v104.StormbringerBuff)))) or ((3563 - 2267) >= (1607 + 2839))) then
					if (v24(v104.Stormstrike, not v15:IsSpellInRange(v104.Stormstrike)) or ((3508 - 2115) > (3182 + 1307))) then
						return "stormstrike single 6";
					end
				end
				v171 = 1 + 0;
			end
		end
	end
	local function v144()
		local v172 = 0 - 0;
		while true do
			if ((v172 == (0 - 0)) or ((9190 - 4766) < (2 + 25))) then
				if ((v104.CrashLightning:IsReady() and v40 and v104.CrashingStorms:IsAvailable() and ((v104.UnrulyWinds:IsAvailable() and (v119 >= (19 - 9))) or (v119 >= (1 + 14)))) or ((5875 - 3878) > (3832 - (12 + 5)))) then
					if (((13458 - 9993) > (4080 - 2167)) and v24(v104.CrashLightning, not v15:IsInMeleeRange(16 - 8))) then
						return "crash_lightning aoe 1";
					end
				end
				if (((1817 - 1084) < (370 + 1449)) and v104.LightningBolt:IsReady() and v48 and ((v104.FlameShockDebuff:AuraActiveCount() >= v119) or (v104.FlameShockDebuff:AuraActiveCount() >= (1979 - (1656 + 317)))) and v14:BuffUp(v104.PrimordialWaveBuff) and (v112 == v113) and (v14:BuffDown(v104.SplinteredElementsBuff) or (v124 <= (11 + 1)))) then
					if (v24(v104.LightningBolt, not v15:IsSpellInRange(v104.LightningBolt)) or ((3522 + 873) == (12643 - 7888))) then
						return "lightning_bolt aoe 2";
					end
				end
				if ((v104.LavaLash:IsReady() and v47 and v104.MoltenAssault:IsAvailable() and (v104.PrimordialWave:IsAvailable() or v104.FireNova:IsAvailable()) and v15:DebuffUp(v104.FlameShockDebuff) and (v104.FlameShockDebuff:AuraActiveCount() < v119) and (v104.FlameShockDebuff:AuraActiveCount() < (29 - 23))) or ((4147 - (5 + 349)) < (11252 - 8883))) then
					if (v24(v104.LavaLash, not v15:IsSpellInRange(v104.LavaLash)) or ((5355 - (266 + 1005)) == (175 + 90))) then
						return "lava_lash aoe 3";
					end
				end
				if (((14869 - 10511) == (5736 - 1378)) and v104.PrimordialWave:IsCastable() and v49 and ((v65 and v37) or not v65) and (v101 < v124) and (v14:BuffDown(v104.PrimordialWaveBuff))) then
					local v247 = 1696 - (561 + 1135);
					while true do
						if (((0 - 0) == v247) or ((10314 - 7176) < (2059 - (507 + 559)))) then
							if (((8356 - 5026) > (7184 - 4861)) and v125.CastCycle(v104.PrimordialWave, v118, v132, not v15:IsSpellInRange(v104.PrimordialWave))) then
								return "primordial_wave aoe 4";
							end
							if (v24(v104.PrimordialWave, not v15:IsSpellInRange(v104.PrimordialWave)) or ((4014 - (212 + 176)) == (4894 - (250 + 655)))) then
								return "primordial_wave aoe no_cycle 4";
							end
							break;
						end
					end
				end
				v172 = 2 - 1;
			end
			if ((v172 == (2 - 0)) or ((1432 - 516) == (4627 - (1869 + 87)))) then
				if (((943 - 671) == (2173 - (484 + 1417))) and v104.Sundering:IsReady() and v51 and ((v64 and v37) or not v64) and (v101 < v124) and (v14:BuffUp(v104.DoomWindsBuff) or v14:HasTier(64 - 34, 2 - 0))) then
					if (((5022 - (48 + 725)) <= (7904 - 3065)) and v24(v104.Sundering, not v15:IsInRange(21 - 13))) then
						return "sundering aoe 9";
					end
				end
				if (((1614 + 1163) < (8551 - 5351)) and v104.FireNova:IsReady() and v42 and ((v104.FlameShockDebuff:AuraActiveCount() >= (2 + 4)) or ((v104.FlameShockDebuff:AuraActiveCount() >= (2 + 2)) and (v104.FlameShockDebuff:AuraActiveCount() >= v119)))) then
					if (((948 - (152 + 701)) < (3268 - (430 + 881))) and v24(v104.FireNova)) then
						return "fire_nova aoe 10";
					end
				end
				if (((317 + 509) < (2612 - (557 + 338))) and v104.LavaLash:IsReady() and v47 and (v104.LashingFlames:IsAvailable())) then
					local v248 = 0 + 0;
					while true do
						if (((4018 - 2592) >= (3869 - 2764)) and (v248 == (0 - 0))) then
							if (((5935 - 3181) <= (4180 - (499 + 302))) and v125.CastCycle(v104.LavaLash, v118, v135, not v15:IsSpellInRange(v104.LavaLash))) then
								return "lava_lash aoe 11";
							end
							if (v24(v104.LavaLash, not v15:IsSpellInRange(v104.LavaLash)) or ((4793 - (39 + 827)) == (3900 - 2487))) then
								return "lava_lash aoe no_cycle 11";
							end
							break;
						end
					end
				end
				if ((v104.LavaLash:IsReady() and v47 and ((v104.MoltenAssault:IsAvailable() and v15:DebuffUp(v104.FlameShockDebuff) and (v104.FlameShockDebuff:AuraActiveCount() < v119) and (v104.FlameShockDebuff:AuraActiveCount() < (13 - 7))) or (v104.AshenCatalyst:IsAvailable() and (v14:BuffStack(v104.AshenCatalystBuff) >= (19 - 14))))) or ((1771 - 617) <= (68 + 720))) then
					if (v24(v104.LavaLash, not v15:IsSpellInRange(v104.LavaLash)) or ((4808 - 3165) > (541 + 2838))) then
						return "lava_lash aoe 12";
					end
				end
				v172 = 4 - 1;
			end
			if ((v172 == (105 - (103 + 1))) or ((3357 - (475 + 79)) > (9833 - 5284))) then
				if ((v104.FlameShock:IsReady() and v43 and (v104.PrimordialWave:IsAvailable() or v104.FireNova:IsAvailable()) and v15:DebuffDown(v104.FlameShockDebuff)) or ((704 - 484) >= (391 + 2631))) then
					if (((2484 + 338) == (4325 - (1395 + 108))) and v24(v104.FlameShock, not v15:IsSpellInRange(v104.FlameShock))) then
						return "flame_shock aoe 5";
					end
				end
				if ((v104.ElementalBlast:IsReady() and v41 and (not v104.ElementalSpirits:IsAvailable() or (v104.ElementalSpirits:IsAvailable() and ((v104.ElementalBlast:Charges() == v121) or (v127.FeralSpiritCount >= (5 - 3))))) and (v14:BuffStack(v104.MaelstromWeaponBuff) == ((1209 - (7 + 1197)) + ((3 + 2) * v25(v104.OverflowingMaelstrom:IsAvailable())))) and (not v104.CrashingStorms:IsAvailable() or (v119 <= (2 + 1)))) or ((1380 - (27 + 292)) == (5441 - 3584))) then
					if (((3519 - 759) > (5720 - 4356)) and v24(v104.ElementalBlast, not v15:IsSpellInRange(v104.ElementalBlast))) then
						return "elemental_blast aoe 6";
					end
				end
				if ((v104.ChainLightning:IsReady() and v39 and (v14:BuffStack(v104.MaelstromWeaponBuff) == ((9 - 4) + ((9 - 4) * v25(v104.OverflowingMaelstrom:IsAvailable()))))) or ((5041 - (43 + 96)) <= (14664 - 11069))) then
					if (v24(v104.ChainLightning, not v15:IsSpellInRange(v104.ChainLightning)) or ((8708 - 4856) == (244 + 49))) then
						return "chain_lightning aoe 7";
					end
				end
				if ((v104.CrashLightning:IsReady() and v40 and (v14:BuffUp(v104.DoomWindsBuff) or v14:BuffDown(v104.CrashLightningBuff) or (v104.AlphaWolf:IsAvailable() and v14:BuffUp(v104.FeralSpiritBuff) and (v131() == (0 + 0))))) or ((3080 - 1521) == (1759 + 2829))) then
					if (v24(v104.CrashLightning, not v15:IsInMeleeRange(14 - 6)) or ((1412 + 3072) == (58 + 730))) then
						return "crash_lightning aoe 8";
					end
				end
				v172 = 1753 - (1414 + 337);
			end
			if (((6508 - (1642 + 298)) >= (10184 - 6277)) and (v172 == (14 - 9))) then
				if (((3697 - 2451) < (1142 + 2328)) and v104.Windstrike:IsCastable() and v53) then
					if (((3166 + 902) >= (1944 - (357 + 615))) and v24(v104.Windstrike, not v15:IsSpellInRange(v104.Windstrike))) then
						return "windstrike aoe 21";
					end
				end
				if (((347 + 146) < (9551 - 5658)) and v104.Stormstrike:IsReady() and v50) then
					if (v24(v104.Stormstrike, not v15:IsSpellInRange(v104.Stormstrike)) or ((1263 + 210) >= (7140 - 3808))) then
						return "stormstrike aoe 22";
					end
				end
				if ((v104.IceStrike:IsReady() and v45) or ((3240 + 811) <= (79 + 1078))) then
					if (((380 + 224) < (4182 - (384 + 917))) and v24(v104.IceStrike, not v15:IsInMeleeRange(702 - (128 + 569)))) then
						return "ice_strike aoe 23";
					end
				end
				if ((v104.LavaLash:IsReady() and v47) or ((2443 - (1407 + 136)) == (5264 - (687 + 1200)))) then
					if (((6169 - (556 + 1154)) > (2079 - 1488)) and v24(v104.LavaLash, not v15:IsSpellInRange(v104.LavaLash))) then
						return "lava_lash aoe 24";
					end
				end
				v172 = 101 - (9 + 86);
			end
			if (((3819 - (275 + 146)) >= (390 + 2005)) and (v172 == (67 - (29 + 35)))) then
				if ((v104.IceStrike:IsReady() and v45 and v104.Hailstorm:IsAvailable() and v14:BuffDown(v104.IceStrikeBuff)) or ((9674 - 7491) >= (8434 - 5610))) then
					if (((8546 - 6610) == (1261 + 675)) and v24(v104.IceStrike, not v15:IsInMeleeRange(1017 - (53 + 959)))) then
						return "ice_strike aoe 13";
					end
				end
				if ((v104.FrostShock:IsReady() and v44 and v104.Hailstorm:IsAvailable() and v14:BuffUp(v104.HailstormBuff)) or ((5240 - (312 + 96)) < (7485 - 3172))) then
					if (((4373 - (147 + 138)) > (4773 - (813 + 86))) and v24(v104.FrostShock, not v15:IsSpellInRange(v104.FrostShock))) then
						return "frost_shock aoe 14";
					end
				end
				if (((3915 + 417) == (8025 - 3693)) and v104.Sundering:IsReady() and v51 and ((v64 and v37) or not v64) and (v101 < v124)) then
					if (((4491 - (18 + 474)) >= (979 + 1921)) and v24(v104.Sundering, not v15:IsInRange(25 - 17))) then
						return "sundering aoe 15";
					end
				end
				if ((v104.FlameShock:IsReady() and v43 and v104.MoltenAssault:IsAvailable() and v15:DebuffDown(v104.FlameShockDebuff)) or ((3611 - (860 + 226)) > (4367 - (121 + 182)))) then
					if (((539 + 3832) == (5611 - (988 + 252))) and v24(v104.FlameShock, not v15:IsSpellInRange(v104.FlameShock))) then
						return "flame_shock aoe 16";
					end
				end
				v172 = 1 + 3;
			end
			if ((v172 == (2 + 4)) or ((2236 - (49 + 1921)) > (5876 - (223 + 667)))) then
				if (((2043 - (51 + 1)) >= (1592 - 667)) and v104.CrashLightning:IsReady() and v40) then
					if (((974 - 519) < (3178 - (146 + 979))) and v24(v104.CrashLightning, not v15:IsInMeleeRange(3 + 5))) then
						return "crash_lightning aoe 25";
					end
				end
				if ((v104.FireNova:IsReady() and v42 and (v104.FlameShockDebuff:AuraActiveCount() >= (607 - (311 + 294)))) or ((2303 - 1477) == (2055 + 2796))) then
					if (((1626 - (496 + 947)) == (1541 - (1233 + 125))) and v24(v104.FireNova)) then
						return "fire_nova aoe 26";
					end
				end
				if (((471 + 688) <= (1605 + 183)) and v104.ElementalBlast:IsReady() and v41 and (not v104.ElementalSpirits:IsAvailable() or (v104.ElementalSpirits:IsAvailable() and ((v104.ElementalBlast:Charges() == v121) or (v127.FeralSpiritCount >= (1 + 1))))) and (v14:BuffStack(v104.MaelstromWeaponBuff) >= (1650 - (963 + 682))) and (not v104.CrashingStorms:IsAvailable() or (v119 <= (3 + 0)))) then
					if (v24(v104.ElementalBlast, not v15:IsSpellInRange(v104.ElementalBlast)) or ((5011 - (504 + 1000)) > (2908 + 1410))) then
						return "elemental_blast aoe 27";
					end
				end
				if ((v104.ChainLightning:IsReady() and v39 and (v14:BuffStack(v104.MaelstromWeaponBuff) >= (5 + 0))) or ((291 + 2784) <= (4372 - 1407))) then
					if (((1167 + 198) <= (1170 + 841)) and v24(v104.ChainLightning, not v15:IsSpellInRange(v104.ChainLightning))) then
						return "chain_lightning aoe 28";
					end
				end
				v172 = 189 - (156 + 26);
			end
			if ((v172 == (3 + 1)) or ((4342 - 1566) > (3739 - (149 + 15)))) then
				if ((v104.FlameShock:IsReady() and v43 and (v104.FireNova:IsAvailable() or v104.PrimordialWave:IsAvailable()) and (v104.FlameShockDebuff:AuraActiveCount() < v119) and (v104.FlameShockDebuff:AuraActiveCount() < (966 - (890 + 70)))) or ((2671 - (39 + 78)) == (5286 - (14 + 468)))) then
					local v249 = 0 - 0;
					while true do
						if (((7202 - 4625) == (1330 + 1247)) and (v249 == (0 + 0))) then
							if (v125.CastCycle(v104.FlameShock, v118, v132, not v15:IsSpellInRange(v104.FlameShock)) or ((2 + 4) >= (854 + 1035))) then
								return "flame_shock aoe 17";
							end
							if (((133 + 373) <= (3621 - 1729)) and v24(v104.FlameShock, not v15:IsSpellInRange(v104.FlameShock))) then
								return "flame_shock aoe no_cycle 17";
							end
							break;
						end
					end
				end
				if ((v104.FireNova:IsReady() and v42 and (v104.FlameShockDebuff:AuraActiveCount() >= (3 + 0))) or ((7055 - 5047) > (56 + 2162))) then
					if (((430 - (12 + 39)) <= (3859 + 288)) and v24(v104.FireNova)) then
						return "fire_nova aoe 18";
					end
				end
				if ((v104.Stormstrike:IsReady() and v50 and v14:BuffUp(v104.CrashLightningBuff) and (v104.DeeplyRootedElements:IsAvailable() or (v14:BuffStack(v104.ConvergingStormsBuff) == (18 - 12)))) or ((16076 - 11562) <= (300 + 709))) then
					if (v24(v104.Stormstrike, not v15:IsSpellInRange(v104.Stormstrike)) or ((1841 + 1655) == (3022 - 1830))) then
						return "stormstrike aoe 19";
					end
				end
				if ((v104.CrashLightning:IsReady() and v40 and v104.CrashingStorms:IsAvailable() and v14:BuffUp(v104.CLCrashLightningBuff) and (v119 >= (3 + 1))) or ((1005 - 797) == (4669 - (1596 + 114)))) then
					if (((11166 - 6889) >= (2026 - (164 + 549))) and v24(v104.CrashLightning, not v15:IsInMeleeRange(1446 - (1059 + 379)))) then
						return "crash_lightning aoe 20";
					end
				end
				v172 = 6 - 1;
			end
			if (((1341 + 1246) < (536 + 2638)) and (v172 == (399 - (145 + 247)))) then
				if ((v104.WindfuryTotem:IsReady() and v52 and (v14:BuffDown(v104.WindfuryTotemBuff, true) or (v104.WindfuryTotem:TimeSinceLastCast() > (74 + 16)))) or ((1904 + 2216) <= (6516 - 4318))) then
					if (v24(v104.WindfuryTotem) or ((307 + 1289) == (740 + 118))) then
						return "windfury_totem aoe 29";
					end
				end
				if (((5228 - 2008) == (3940 - (254 + 466))) and v104.FlameShock:IsReady() and v43 and (v15:DebuffDown(v104.FlameShockDebuff))) then
					if (v24(v104.FlameShock, not v15:IsSpellInRange(v104.FlameShock)) or ((1962 - (544 + 16)) > (11504 - 7884))) then
						return "flame_shock aoe 30";
					end
				end
				if (((3202 - (294 + 334)) == (2827 - (236 + 17))) and v104.FrostShock:IsReady() and v44 and not v104.Hailstorm:IsAvailable()) then
					if (((776 + 1022) < (2147 + 610)) and v24(v104.FrostShock, not v15:IsSpellInRange(v104.FrostShock))) then
						return "frost_shock aoe 31";
					end
				end
				break;
			end
		end
	end
	local function v145()
		local v173 = 0 - 0;
		while true do
			if ((v173 == (4 - 3)) or ((195 + 182) > (2145 + 459))) then
				if (((1362 - (413 + 381)) < (39 + 872)) and (not v109 or (v111 < (1276087 - 676087))) and v54 and v104.FlametongueWeapon:IsCastable()) then
					if (((8533 - 5248) < (6198 - (582 + 1388))) and v24(v104.FlametongueWeapon)) then
						return "flametongue_weapon enchant";
					end
				end
				if (((6671 - 2755) > (2383 + 945)) and v87) then
					local v250 = 364 - (326 + 38);
					while true do
						if (((7395 - 4895) < (5479 - 1640)) and (v250 == (620 - (47 + 573)))) then
							v33 = v139();
							if (((179 + 328) == (2153 - 1646)) and v33) then
								return v33;
							end
							break;
						end
					end
				end
				v173 = 2 - 0;
			end
			if (((1904 - (1269 + 395)) <= (3657 - (76 + 416))) and (v173 == (443 - (319 + 124)))) then
				if (((1906 - 1072) >= (1812 - (564 + 443))) and v77 and v104.EarthShield:IsCastable() and v14:BuffDown(v104.EarthShieldBuff) and ((v78 == "Earth Shield") or (v104.ElementalOrbit:IsAvailable() and v14:BuffUp(v104.LightningShield)))) then
					if (v24(v104.EarthShield) or ((10552 - 6740) < (2774 - (337 + 121)))) then
						return "earth_shield main 2";
					end
				elseif ((v77 and v104.LightningShield:IsCastable() and v14:BuffDown(v104.LightningShieldBuff) and ((v78 == "Lightning Shield") or (v104.ElementalOrbit:IsAvailable() and v14:BuffUp(v104.EarthShield)))) or ((7770 - 5118) <= (5106 - 3573))) then
					if (v24(v104.LightningShield) or ((5509 - (1261 + 650)) < (618 + 842))) then
						return "lightning_shield main 2";
					end
				end
				if (((not v108 or (v110 < (956227 - 356227))) and v54 and v104.WindfuryWeapon:IsCastable()) or ((5933 - (772 + 1045)) < (169 + 1023))) then
					if (v24(v104.WindfuryWeapon) or ((3521 - (102 + 42)) <= (2747 - (1524 + 320)))) then
						return "windfury_weapon enchant";
					end
				end
				v173 = 1271 - (1049 + 221);
			end
			if (((4132 - (18 + 138)) >= (1074 - 635)) and (v173 == (1104 - (67 + 1035)))) then
				if (((4100 - (136 + 212)) == (15943 - 12191)) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) then
					if (((3242 + 804) > (2485 + 210)) and v24(v104.AncestralSpirit, nil, true)) then
						return "resurrection";
					end
				end
				if ((v125.TargetIsValid() and v34) or ((5149 - (240 + 1364)) == (4279 - (1050 + 32)))) then
					if (((8547 - 6153) > (221 + 152)) and not v14:AffectingCombat()) then
						local v259 = 1055 - (331 + 724);
						while true do
							if (((336 + 3819) <= (4876 - (269 + 375))) and (v259 == (725 - (267 + 458)))) then
								v33 = v142();
								if (v33 or ((1114 + 2467) == (6678 - 3205))) then
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
	local function v146()
		local v174 = 818 - (667 + 151);
		while true do
			if (((6492 - (1410 + 87)) > (5245 - (1504 + 393))) and (v174 == (10 - 6))) then
				if (v33 or ((1956 - 1202) > (4520 - (461 + 335)))) then
					return v33;
				end
				if (((28 + 189) >= (1818 - (1730 + 31))) and v125.TargetIsValid()) then
					local v251 = 1667 - (728 + 939);
					local v252;
					while true do
						if ((v251 == (10 - 7)) or ((4198 - 2128) >= (9249 - 5212))) then
							if (((3773 - (138 + 930)) == (2472 + 233)) and v35 and (v119 > (1 + 0))) then
								v33 = v144();
								if (((53 + 8) == (249 - 188)) and v33) then
									return v33;
								end
							end
							break;
						end
						if ((v251 == (1768 - (459 + 1307))) or ((2569 - (474 + 1396)) >= (2262 - 966))) then
							if ((v104.FeralSpirit:IsCastable() and v57 and ((v62 and v36) or not v62) and (v101 < v124)) or ((1672 + 111) >= (12 + 3604))) then
								if (v24(v104.FeralSpirit) or ((11208 - 7295) > (574 + 3953))) then
									return "feral_spirit main 3";
								end
							end
							if (((14608 - 10232) > (3563 - 2746)) and v104.Ascendance:IsCastable() and v56 and ((v61 and v36) or not v61) and (v101 < v124) and v15:DebuffUp(v104.FlameShockDebuff) and (((v122 == "Lightning Bolt") and (v119 == (592 - (562 + 29)))) or ((v122 == "Chain Lightning") and (v119 > (1 + 0))))) then
								if (((6280 - (374 + 1045)) > (653 + 171)) and v24(v104.Ascendance)) then
									return "ascendance main 4";
								end
							end
							if ((v104.DoomWinds:IsCastable() and v58 and ((v63 and v36) or not v63) and (v101 < v124)) or ((4294 - 2911) >= (2769 - (448 + 190)))) then
								if (v24(v104.DoomWinds, not v15:IsInMeleeRange(2 + 3)) or ((847 + 1029) >= (1656 + 885))) then
									return "doom_winds main 5";
								end
							end
							if (((6851 - 5069) <= (11720 - 7948)) and (v119 == (1495 - (1307 + 187)))) then
								v33 = v143();
								if (v33 or ((18637 - 13937) < (1903 - 1090))) then
									return v33;
								end
							end
							v251 = 8 - 5;
						end
						if (((3882 - (232 + 451)) < (3868 + 182)) and (v251 == (0 + 0))) then
							v252 = v125.HandleDPSPotion(v14:BuffUp(v104.FeralSpiritBuff));
							if (v252 or ((5515 - (510 + 54)) < (8925 - 4495))) then
								return v252;
							end
							if (((132 - (13 + 23)) == (186 - 90)) and (v101 < v124)) then
								if ((v59 and ((v36 and v66) or not v66)) or ((3935 - 1196) > (7281 - 3273))) then
									v33 = v141();
									if (v33 or ((1111 - (830 + 258)) == (4000 - 2866))) then
										return v33;
									end
								end
							end
							if (((v101 < v124) and v60 and ((v67 and v36) or not v67)) or ((1685 + 1008) >= (3498 + 613))) then
								local v269 = 1441 - (860 + 581);
								while true do
									if ((v269 == (3 - 2)) or ((3426 + 890) <= (2387 - (237 + 4)))) then
										if ((v104.Fireblood:IsCastable() and (not v104.Ascendance:IsAvailable() or v14:BuffUp(v104.AscendanceBuff) or (v104.Ascendance:CooldownRemains() > (117 - 67)))) or ((8971 - 5425) <= (5325 - 2516))) then
											if (((4014 + 890) > (1245 + 921)) and v24(v104.Fireblood)) then
												return "fireblood racial";
											end
										end
										if (((411 - 302) >= (39 + 51)) and v104.AncestralCall:IsCastable() and (not v104.Ascendance:IsAvailable() or v14:BuffUp(v104.AscendanceBuff) or (v104.Ascendance:CooldownRemains() > (28 + 22)))) then
											if (((6404 - (85 + 1341)) > (4956 - 2051)) and v24(v104.AncestralCall)) then
												return "ancestral_call racial";
											end
										end
										break;
									end
									if ((v269 == (0 - 0)) or ((3398 - (45 + 327)) <= (4302 - 2022))) then
										if ((v104.BloodFury:IsCastable() and (not v104.Ascendance:IsAvailable() or v14:BuffUp(v104.AscendanceBuff) or (v104.Ascendance:CooldownRemains() > (552 - (444 + 58))))) or ((719 + 934) <= (191 + 917))) then
											if (((1423 + 1486) > (7560 - 4951)) and v24(v104.BloodFury)) then
												return "blood_fury racial";
											end
										end
										if (((2489 - (64 + 1668)) > (2167 - (1227 + 746))) and v104.Berserking:IsCastable() and (not v104.Ascendance:IsAvailable() or v14:BuffUp(v104.AscendanceBuff))) then
											if (v24(v104.Berserking) or ((95 - 64) >= (2594 - 1196))) then
												return "berserking racial";
											end
										end
										v269 = 495 - (415 + 79);
									end
								end
							end
							v251 = 1 + 0;
						end
						if (((3687 - (142 + 349)) <= (2088 + 2784)) and (v251 == (1 - 0))) then
							if (((1653 + 1673) == (2344 + 982)) and v104.SpiritwalkersGrace:IsCastable() and v55 and v14:IsMoving()) then
								if (((3902 - 2469) <= (5742 - (1710 + 154))) and v24(v104.SpiritwalkersGrace)) then
									return "spiritwalkers_grace main";
								end
							end
							if ((v104.TotemicProjection:IsCastable() and (v104.WindfuryTotem:TimeSinceLastCast() < (408 - (200 + 118))) and v14:BuffDown(v104.WindfuryTotemBuff, true)) or ((628 + 955) == (3033 - 1298))) then
								if (v24(v106.TotemicProjectionPlayer) or ((4421 - 1440) == (2089 + 261))) then
									return "totemic_projection wind_fury main 0";
								end
							end
							if ((v104.Windstrike:IsCastable() and v53) or ((4418 + 48) <= (265 + 228))) then
								if (v24(v104.Windstrike, not v15:IsSpellInRange(v104.Windstrike)) or ((407 + 2140) <= (4304 - 2317))) then
									return "windstrike main 1";
								end
							end
							if (((4211 - (363 + 887)) > (4784 - 2044)) and v104.PrimordialWave:IsCastable() and v49 and ((v65 and v37) or not v65) and (v101 < v124) and (v14:HasTier(147 - 116, 1 + 1))) then
								if (((8647 - 4951) >= (2469 + 1143)) and v24(v104.PrimordialWave, not v15:IsSpellInRange(v104.PrimordialWave))) then
									return "primordial_wave main 2";
								end
							end
							v251 = 1666 - (674 + 990);
						end
					end
				end
				break;
			end
			if ((v174 == (1 + 1)) or ((1216 + 1754) == (2976 - 1098))) then
				if (v94 or ((4748 - (507 + 548)) < (2814 - (289 + 548)))) then
					local v253 = 1818 - (821 + 997);
					while true do
						if ((v253 == (255 - (195 + 60))) or ((251 + 679) > (3602 - (251 + 1250)))) then
							if (((12166 - 8013) > (2121 + 965)) and v16) then
								v33 = v137();
								if (v33 or ((5686 - (809 + 223)) <= (5910 - 1860))) then
									return v33;
								end
							end
							if ((v17 and v17:Exists() and not v14:CanAttack(v17) and (v125.UnitHasDispellableDebuffByPlayer(v17) or v125.UnitHasCurseDebuff(v17))) or ((7813 - 5211) < (4946 - 3450))) then
								if (v104.CleanseSpirit:IsCastable() or ((752 + 268) > (1199 + 1089))) then
									if (((945 - (14 + 603)) == (457 - (118 + 11))) and v24(v106.CleanseSpiritMouseover, not v17:IsSpellInRange(v104.PurifySpirit))) then
										return "purify_spirit dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				if (((245 + 1266) < (3172 + 636)) and v104.GreaterPurge:IsAvailable() and v102 and v104.GreaterPurge:IsReady() and v38 and v93 and not v14:IsCasting() and not v14:IsChanneling() and v125.UnitHasMagicBuff(v15)) then
					if (v24(v104.GreaterPurge, not v15:IsSpellInRange(v104.GreaterPurge)) or ((7314 - 4804) > (5868 - (551 + 398)))) then
						return "greater_purge damage";
					end
				end
				v174 = 2 + 1;
			end
			if (((1695 + 3068) == (3871 + 892)) and ((3 - 2) == v174)) then
				if (((9532 - 5395) > (599 + 1249)) and v95) then
					local v254 = 0 - 0;
					while true do
						if (((673 + 1763) <= (3223 - (40 + 49))) and (v254 == (0 - 0))) then
							if (((4213 - (99 + 391)) == (3080 + 643)) and v89) then
								local v270 = 0 - 0;
								while true do
									if ((v270 == (0 - 0)) or ((3942 + 104) >= (11356 - 7040))) then
										v33 = v125.HandleAfflicted(v104.CleanseSpirit, v106.CleanseSpiritMouseover, 1644 - (1032 + 572));
										if (v33 or ((2425 - (203 + 214)) < (3746 - (568 + 1249)))) then
											return v33;
										end
										break;
									end
								end
							end
							if (((1865 + 519) > (4263 - 2488)) and v90) then
								local v271 = 0 - 0;
								while true do
									if ((v271 == (1306 - (913 + 393))) or ((12829 - 8286) <= (6182 - 1806))) then
										v33 = v125.HandleAfflicted(v104.TremorTotem, v104.TremorTotem, 440 - (269 + 141));
										if (((1618 - 890) == (2709 - (362 + 1619))) and v33) then
											return v33;
										end
										break;
									end
								end
							end
							v254 = 1626 - (950 + 675);
						end
						if ((v254 == (1 + 0)) or ((2255 - (216 + 963)) > (5958 - (485 + 802)))) then
							if (((2410 - (432 + 127)) >= (1451 - (1065 + 8))) and v91) then
								local v272 = 0 + 0;
								while true do
									if ((v272 == (1601 - (635 + 966))) or ((1401 + 547) >= (3518 - (5 + 37)))) then
										v33 = v125.HandleAfflicted(v104.PoisonCleansingTotem, v104.PoisonCleansingTotem, 74 - 44);
										if (((1995 + 2799) >= (1318 - 485)) and v33) then
											return v33;
										end
										break;
									end
								end
							end
							if (((1914 + 2176) == (8498 - 4408)) and (v14:BuffStack(v104.MaelstromWeaponBuff) >= (18 - 13)) and v92) then
								local v273 = 0 - 0;
								while true do
									if ((v273 == (0 - 0)) or ((2703 + 1055) == (3027 - (318 + 211)))) then
										v33 = v125.HandleAfflicted(v104.HealingSurge, v106.HealingSurgeMouseover, 196 - 156, true);
										if (v33 or ((4260 - (963 + 624)) < (674 + 901))) then
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
				if (v96 or ((4567 - (518 + 328)) <= (3391 - 1936))) then
					local v255 = 0 - 0;
					while true do
						if (((1251 - (301 + 16)) < (6653 - 4383)) and (v255 == (0 - 0))) then
							v33 = v125.HandleIncorporeal(v104.Hex, v106.HexMouseOver, 78 - 48, true);
							if (v33 or ((1461 + 151) == (713 + 542))) then
								return v33;
							end
							break;
						end
					end
				end
				v174 = 3 - 1;
			end
			if ((v174 == (0 + 0)) or ((415 + 3937) < (13372 - 9166))) then
				v33 = v140();
				if (v33 or ((924 + 1936) <= (1200 - (829 + 190)))) then
					return v33;
				end
				v174 = 3 - 2;
			end
			if (((4076 - 854) >= (2110 - 583)) and (v174 == (7 - 4))) then
				if (((357 + 1148) <= (693 + 1428)) and v104.Purge:IsReady() and v102 and v38 and v93 and not v14:IsCasting() and not v14:IsChanneling() and v125.UnitHasMagicBuff(v15)) then
					if (((2258 - 1514) == (703 + 41)) and v24(v104.Purge, not v15:IsSpellInRange(v104.Purge))) then
						return "purge damage";
					end
				end
				v33 = v138();
				v174 = 617 - (520 + 93);
			end
		end
	end
	local function v147()
		local v175 = 276 - (259 + 17);
		while true do
			if ((v175 == (1 + 3)) or ((713 + 1266) >= (9601 - 6765))) then
				v48 = EpicSettings.Settings['useLightningBolt'];
				v49 = EpicSettings.Settings['usePrimordialWave'];
				v50 = EpicSettings.Settings['useStormStrike'];
				v175 = 596 - (396 + 195);
			end
			if (((5318 - 3485) <= (4429 - (440 + 1321))) and (v175 == (1836 - (1059 + 770)))) then
				v61 = EpicSettings.Settings['ascendanceWithCD'];
				v63 = EpicSettings.Settings['doomWindsWithCD'];
				v62 = EpicSettings.Settings['feralSpiritWithCD'];
				v175 = 36 - 28;
			end
			if (((4231 - (424 + 121)) == (672 + 3014)) and (v175 == (1353 - (641 + 706)))) then
				v54 = EpicSettings.Settings['useWeaponEnchant'];
				v103 = EpicSettings.Settings['useWeapon'];
				v55 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v175 = 3 + 4;
			end
			if (((3907 - (249 + 191)) > (2077 - 1600)) and (v175 == (2 + 1))) then
				v45 = EpicSettings.Settings['useIceStrike'];
				v46 = EpicSettings.Settings['useLavaBurst'];
				v47 = EpicSettings.Settings['useLavaLash'];
				v175 = 15 - 11;
			end
			if ((v175 == (435 - (183 + 244))) or ((162 + 3126) >= (4271 - (434 + 296)))) then
				v65 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v64 = EpicSettings.Settings['sunderingWithMiniCD'];
				break;
			end
			if (((5 - 3) == v175) or ((4069 - (169 + 343)) == (3981 + 559))) then
				v42 = EpicSettings.Settings['useFireNova'];
				v43 = EpicSettings.Settings['useFlameShock'];
				v44 = EpicSettings.Settings['useFrostShock'];
				v175 = 4 - 1;
			end
			if (((2 - 1) == v175) or ((214 + 47) > (3593 - 2326))) then
				v39 = EpicSettings.Settings['useChainlightning'];
				v40 = EpicSettings.Settings['useCrashLightning'];
				v41 = EpicSettings.Settings['useElementalBlast'];
				v175 = 1125 - (651 + 472);
			end
			if (((962 + 310) < (1665 + 2193)) and ((0 - 0) == v175)) then
				v56 = EpicSettings.Settings['useAscendance'];
				v58 = EpicSettings.Settings['useDoomWinds'];
				v57 = EpicSettings.Settings['useFeralSpirit'];
				v175 = 484 - (397 + 86);
			end
			if (((4540 - (423 + 453)) == (373 + 3291)) and (v175 == (1 + 4))) then
				v51 = EpicSettings.Settings['useSundering'];
				v53 = EpicSettings.Settings['useWindstrike'];
				v52 = EpicSettings.Settings['useWindfuryTotem'];
				v175 = 6 + 0;
			end
		end
	end
	local function v148()
		v68 = EpicSettings.Settings['useWindShear'];
		v69 = EpicSettings.Settings['useCapacitorTotem'];
		v70 = EpicSettings.Settings['useThunderstorm'];
		v72 = EpicSettings.Settings['useAncestralGuidance'];
		v71 = EpicSettings.Settings['useAstralShift'];
		v74 = EpicSettings.Settings['useMaelstromHealingSurge'];
		v73 = EpicSettings.Settings['useHealingStreamTotem'];
		v80 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 + 0);
		v81 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
		v79 = EpicSettings.Settings['astralShiftHP'] or (1190 - (50 + 1140));
		v82 = EpicSettings.Settings['healingStreamTotemHP'] or (0 + 0);
		v83 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
		v84 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (0 + 0);
		v77 = EpicSettings.Settings['autoShield'];
		v78 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
		v87 = EpicSettings.Settings['healOOC'];
		v88 = EpicSettings.Settings['healOOCHP'] or (0 - 0);
		v102 = EpicSettings.Settings['usePurgeTarget'];
		v89 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
		v90 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v91 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
		v92 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
	end
	local function v149()
		local v190 = 0 + 0;
		while true do
			if (((2537 - (157 + 439)) >= (782 - 332)) and ((0 - 0) == v190)) then
				v101 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v98 = EpicSettings.Settings['InterruptWithStun'];
				v99 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v190 = 919 - (782 + 136);
			end
			if ((v190 == (859 - (112 + 743))) or ((5817 - (1026 + 145)) < (56 + 268))) then
				v85 = EpicSettings.Settings['healthstoneHP'] or (718 - (493 + 225));
				v86 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v97 = EpicSettings.Settings['HealingPotionName'] or "";
				v190 = 4 + 1;
			end
			if (((10276 - 6443) == (73 + 3760)) and (v190 == (2 - 1))) then
				v100 = EpicSettings.Settings['InterruptThreshold'];
				v94 = EpicSettings.Settings['DispelDebuffs'];
				v93 = EpicSettings.Settings['DispelBuffs'];
				v190 = 1 + 1;
			end
			if ((v190 == (4 - 1)) or ((2835 - (210 + 1385)) > (5059 - (1201 + 488)))) then
				v67 = EpicSettings.Settings['racialsWithCD'];
				v75 = EpicSettings.Settings['useHealthstone'];
				v76 = EpicSettings.Settings['useHealingPotion'];
				v190 = 3 + 1;
			end
			if ((v190 == (8 - 3)) or ((4449 - 1968) == (5267 - (352 + 233)))) then
				v95 = EpicSettings.Settings['handleAfflicted'];
				v96 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((11423 - 6696) >= (114 + 94)) and (v190 == (5 - 3))) then
				v59 = EpicSettings.Settings['useTrinkets'];
				v60 = EpicSettings.Settings['useRacials'];
				v66 = EpicSettings.Settings['trinketsWithCD'];
				v190 = 577 - (489 + 85);
			end
		end
	end
	local function v150()
		local v191 = 1501 - (277 + 1224);
		while true do
			if (((1773 - (663 + 830)) < (3383 + 468)) and (v191 == (12 - 7))) then
				if (v14:AffectingCombat() or ((3882 - (461 + 414)) > (536 + 2658))) then
					if (v14:PrevGCD(1 + 0, v104.ChainLightning) or ((204 + 1932) >= (2905 + 41))) then
						v122 = "Chain Lightning";
					elseif (((2415 - (172 + 78)) <= (4064 - 1543)) and v14:PrevGCD(1 + 0, v104.LightningBolt)) then
						v122 = "Lightning Bolt";
					end
				end
				if (((4128 - 1267) > (181 + 480)) and not v14:IsChanneling() and not v14:IsChanneling()) then
					if (((1512 + 3013) > (7570 - 3051)) and v95) then
						local v260 = 0 - 0;
						while true do
							if (((799 + 2379) > (538 + 434)) and (v260 == (0 + 0))) then
								if (((18971 - 14205) == (11103 - 6337)) and v89) then
									local v274 = 0 + 0;
									while true do
										if ((v274 == (0 + 0)) or ((3192 - (133 + 314)) > (544 + 2584))) then
											v33 = v125.HandleAfflicted(v104.CleanseSpirit, v106.CleanseSpiritMouseover, 253 - (199 + 14));
											if (v33 or ((4095 - 2951) >= (6155 - (647 + 902)))) then
												return v33;
											end
											break;
										end
									end
								end
								if (((10037 - 6699) >= (510 - (85 + 148))) and v90) then
									v33 = v125.HandleAfflicted(v104.TremorTotem, v104.TremorTotem, 1319 - (426 + 863));
									if (((12215 - 9605) > (4214 - (873 + 781))) and v33) then
										return v33;
									end
								end
								v260 = 1 - 0;
							end
							if ((v260 == (2 - 1)) or ((495 + 699) > (11389 - 8306))) then
								if (((1312 - 396) >= (2217 - 1470)) and v91) then
									local v275 = 1947 - (414 + 1533);
									while true do
										if (((0 + 0) == v275) or ((2999 - (443 + 112)) > (4433 - (888 + 591)))) then
											v33 = v125.HandleAfflicted(v104.PoisonCleansingTotem, v104.PoisonCleansingTotem, 77 - 47);
											if (((165 + 2727) < (13234 - 9720)) and v33) then
												return v33;
											end
											break;
										end
									end
								end
								if (((209 + 324) == (258 + 275)) and (v14:BuffStack(v104.MaelstromWeaponBuff) >= (1 + 4)) and v92) then
									v33 = v125.HandleAfflicted(v104.HealingSurge, v106.HealingSurgeMouseover, 76 - 36, true);
									if (((1102 - 507) <= (5091 - (136 + 1542))) and v33) then
										return v33;
									end
								end
								break;
							end
						end
					end
					if (((10093 - 7015) >= (2572 + 19)) and v14:AffectingCombat()) then
						local v261 = 0 - 0;
						while true do
							if (((2316 + 883) < (4516 - (68 + 418))) and (v261 == (0 - 0))) then
								v33 = v146();
								if (((1409 - 632) < (1794 + 284)) and v33) then
									return v33;
								end
								break;
							end
						end
					else
						local v262 = 1092 - (770 + 322);
						while true do
							if (((98 + 1598) <= (660 + 1622)) and (v262 == (0 + 0))) then
								v33 = v145();
								if (v33 or ((2519 - 758) >= (4773 - 2311))) then
									return v33;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((12394 - 7843) > (8563 - 6235)) and (v191 == (0 + 0))) then
				v148();
				v147();
				v149();
				v191 = 1 - 0;
			end
			if (((1835 + 1990) >= (287 + 180)) and (v191 == (3 + 0))) then
				v108, v110, _, _, v109, v111 = v27();
				v117 = v14:GetEnemiesInRange(150 - 110);
				v118 = v14:GetEnemiesInMeleeRange(13 - 3);
				v191 = 2 + 2;
			end
			if ((v191 == (18 - 14)) or ((9553 - 6663) == (230 + 327))) then
				if (v35 or ((23603 - 18833) == (3735 - (762 + 69)))) then
					local v256 = 0 - 0;
					while true do
						if ((v256 == (0 + 0)) or ((2527 + 1376) == (10971 - 6435))) then
							v120 = v129(13 + 27);
							v119 = #v118;
							break;
						end
					end
				else
					local v257 = 0 + 0;
					while true do
						if (((15946 - 11853) <= (5002 - (8 + 149))) and (v257 == (1320 - (1199 + 121)))) then
							v120 = 1 - 0;
							v119 = 2 - 1;
							break;
						end
					end
				end
				if (((646 + 923) <= (13017 - 9370)) and v38 and v94) then
					if ((v14:AffectingCombat() and v104.CleanseSpirit:IsAvailable()) or ((9388 - 5342) >= (4359 + 568))) then
						local v263 = 1807 - (518 + 1289);
						local v264;
						while true do
							if (((7927 - 3304) >= (370 + 2417)) and (v263 == (0 - 0))) then
								v264 = v94 and v104.CleanseSpirit:IsReady() and v38;
								v33 = v125.FocusUnit(v264, nil, 15 + 5, nil, 494 - (304 + 165), v104.HealingSurge);
								v263 = 1 + 0;
							end
							if (((2394 - (54 + 106)) >= (3199 - (1618 + 351))) and ((1 + 0) == v263)) then
								if (v33 or ((1359 - (10 + 1006)) == (449 + 1337))) then
									return v33;
								end
								break;
							end
						end
					end
				end
				if (((360 + 2210) > (7809 - 5400)) and (v125.TargetIsValid() or v14:AffectingCombat())) then
					local v258 = 1033 - (912 + 121);
					while true do
						if ((v258 == (0 + 0)) or ((3898 - (1140 + 149)) >= (2070 + 1164))) then
							v123 = v10.BossFightRemains(nil, true);
							v124 = v123;
							v258 = 1 - 0;
						end
						if ((v258 == (1 + 0)) or ((10379 - 7346) >= (7559 - 3528))) then
							if ((v124 == (1917 + 9194)) or ((4861 - 3460) == (4854 - (165 + 21)))) then
								v124 = v10.FightRemains(v118, false);
							end
							break;
						end
					end
				end
				v191 = 116 - (61 + 50);
			end
			if (((1144 + 1632) >= (6296 - 4975)) and (v191 == (1 - 0))) then
				v34 = EpicSettings.Toggles['ooc'];
				v35 = EpicSettings.Toggles['aoe'];
				v36 = EpicSettings.Toggles['cds'];
				v191 = 1 + 1;
			end
			if ((v191 == (1462 - (1295 + 165))) or ((112 + 375) > (926 + 1377))) then
				v38 = EpicSettings.Toggles['dispel'];
				v37 = EpicSettings.Toggles['minicds'];
				if (v14:IsDeadOrGhost() or ((5900 - (819 + 578)) == (4864 - (331 + 1071)))) then
					return v33;
				end
				v191 = 746 - (588 + 155);
			end
		end
	end
	local function v151()
		local v192 = 1282 - (546 + 736);
		while true do
			if (((2490 - (1834 + 103)) <= (950 + 593)) and (v192 == (2 - 1))) then
				v21.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
				break;
			end
			if (((3781 - (1536 + 230)) == (2506 - (128 + 363))) and (v192 == (0 + 0))) then
				v104.FlameShockDebuff:RegisterAuraTracking();
				v130();
				v192 = 2 - 1;
			end
		end
	end
	v21.SetAPL(68 + 195, v150, v151);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

