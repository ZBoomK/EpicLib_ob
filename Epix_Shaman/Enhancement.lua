local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((4068 - 2869) >= (6171 - 4002))) then
			v6 = v0[v4];
			if (not v6 or ((1598 - 962) == (677 + 1225))) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
		end
		if ((v5 == (3 - 2)) or ((3649 + 1190) <= (8388 - 5108))) then
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
	local v16 = v10.Spell;
	local v17 = v10.MultiSpell;
	local v18 = v10.Item;
	local v19 = EpicLib;
	local v20 = v19.Cast;
	local v21 = v19.Macro;
	local v22 = v19.Press;
	local v23 = v19.Commons.Everyone.num;
	local v24 = v19.Commons.Everyone.bool;
	local v25 = GetWeaponEnchantInfo;
	local v26 = math.max;
	local v27 = string.match;
	local v28;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34;
	local v35;
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
	local v34;
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
	local v98 = v16.Shaman.Enhancement;
	local v99 = v18.Shaman.Enhancement;
	local v100 = v21.Shaman.Enhancement;
	local v101 = {};
	local v102, v103;
	local v104, v105;
	local v106, v107, v108, v109;
	local v110 = (v98.LavaBurst:IsAvailable() and (690 - (364 + 324))) or (2 - 1);
	local v111 = "Lightning Bolt";
	local v112 = 26662 - 15551;
	local v113 = 3683 + 7428;
	v10:RegisterForEvent(function()
		v110 = (v98.LavaBurst:IsAvailable() and (8 - 6)) or (1 - 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		local v141 = 0 - 0;
		while true do
			if (((1269 - (1249 + 19)) == v141) or ((3317 + 357) <= (7636 - 5674))) then
				v113 = 12197 - (686 + 400);
				break;
			end
			if ((v141 == (0 + 0)) or ((2123 - (73 + 156)) < (7 + 1399))) then
				v111 = "Lightning Bolt";
				v112 = 11922 - (721 + 90);
				v141 = 1 + 0;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v114 = v19.Commons.Everyone;
	local function v115()
		if (((5103 - 3531) >= (2001 - (224 + 246))) and v98.CleanseSpirit:IsAvailable()) then
			v114.DispellableDebuffs = v114.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v115();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v116()
		for v197 = 1 - 0, 10 - 4, 1 + 0 do
			if (v27(v14:TotemName(v197), "Totem") or ((112 + 4575) < (3336 + 1206))) then
				return v197;
			end
		end
	end
	local function v117()
		local v142 = 0 - 0;
		local v143;
		while true do
			if (((10951 - 7660) > (2180 - (203 + 310))) and (v142 == (1994 - (1238 + 755)))) then
				if ((v143 > (1 + 7)) or (v143 > v98.FeralSpirit:TimeSinceLastCast()) or ((2407 - (709 + 825)) == (3748 - 1714))) then
					return 0 - 0;
				end
				return (872 - (196 + 668)) - v143;
			end
			if ((v142 == (0 - 0)) or ((5833 - 3017) < (844 - (171 + 662)))) then
				if (((3792 - (4 + 89)) < (16494 - 11788)) and (not v98.AlphaWolf:IsAvailable() or v14:BuffDown(v98.FeralSpiritBuff))) then
					return 0 + 0;
				end
				v143 = mathmin(v98.CrashLightning:TimeSinceLastCast(), v98.ChainLightning:TimeSinceLastCast());
				v142 = 4 - 3;
			end
		end
	end
	local function v118(v144)
		return (v144:DebuffRefreshable(v98.FlameShockDebuff));
	end
	local function v119(v145)
		return (v145:DebuffRefreshable(v98.LashingFlamesDebuff));
	end
	local function v120(v146)
		return (v146:DebuffRemains(v98.FlameShockDebuff));
	end
	local function v121(v147)
		return (v14:BuffDown(v98.PrimordialWaveBuff));
	end
	local function v122(v148)
		return (v15:DebuffRemains(v98.LashingFlamesDebuff));
	end
	local function v123(v149)
		return (v98.LashingFlames:IsAvailable());
	end
	local function v124(v150)
		return v150:DebuffUp(v98.FlameShockDebuff) and (v98.FlameShockDebuff:AuraActiveCount() < v108) and (v98.FlameShockDebuff:AuraActiveCount() < (3 + 3));
	end
	local function v125()
		if (((4132 - (35 + 1451)) >= (2329 - (28 + 1425))) and v98.CleanseSpirit:IsReady() and v33 and v114.DispellableFriendlyUnit(2018 - (941 + 1052))) then
			if (((589 + 25) <= (4698 - (822 + 692))) and v22(v100.CleanseSpiritFocus)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v126()
		if (((4462 - 1336) == (1473 + 1653)) and (not Focus or not Focus:Exists() or not Focus:IsInRange(337 - (45 + 252)))) then
			return;
		end
		if (Focus or ((2164 + 23) >= (1705 + 3249))) then
			if (((Focus:HealthPercentage() <= v79) and v69 and v98.HealingSurge:IsReady() and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (12 - 7))) or ((4310 - (114 + 319)) == (5132 - 1557))) then
				if (((905 - 198) > (403 + 229)) and v22(v100.HealingSurgeFocus)) then
					return "healing_surge heal focus";
				end
			end
		end
	end
	local function v127()
		if ((v14:HealthPercentage() <= v83) or ((813 - 267) >= (5623 - 2939))) then
			if (((3428 - (556 + 1407)) <= (5507 - (741 + 465))) and v98.HealingSurge:IsReady()) then
				if (((2169 - (170 + 295)) > (751 + 674)) and v22(v98.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v128()
		local v151 = 0 + 0;
		while true do
			if ((v151 == (4 - 2)) or ((570 + 117) == (2716 + 1518))) then
				if ((v99.Healthstone:IsReady() and v70 and (v14:HealthPercentage() <= v80)) or ((1886 + 1444) < (2659 - (957 + 273)))) then
					if (((307 + 840) >= (135 + 200)) and v22(v100.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if (((13088 - 9653) > (5525 - 3428)) and v71 and (v14:HealthPercentage() <= v81)) then
					local v220 = 0 - 0;
					while true do
						if ((v220 == (0 - 0)) or ((5550 - (389 + 1391)) >= (2536 + 1505))) then
							if ((v92 == "Refreshing Healing Potion") or ((395 + 3396) <= (3667 - 2056))) then
								if (v99.RefreshingHealingPotion:IsReady() or ((5529 - (783 + 168)) <= (6739 - 4731))) then
									if (((1107 + 18) <= (2387 - (309 + 2))) and v22(v100.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v92 == "Dreamwalker's Healing Potion") or ((2281 - 1538) >= (5611 - (1090 + 122)))) then
								if (((375 + 780) < (5618 - 3945)) and v99.DreamwalkersHealingPotion:IsReady()) then
									if (v22(v100.RefreshingHealingPotion) or ((1591 + 733) <= (1696 - (628 + 490)))) then
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
			if (((676 + 3091) == (9326 - 5559)) and (v151 == (4 - 3))) then
				if (((4863 - (431 + 343)) == (8257 - 4168)) and v98.HealingStreamTotem:IsReady() and v68 and v114.AreUnitsBelowHealthPercentage(v77, v78)) then
					if (((12896 - 8438) >= (1323 + 351)) and v22(v98.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if (((125 + 847) <= (3113 - (556 + 1139))) and v98.HealingSurge:IsReady() and v69 and (v14:HealthPercentage() <= v79) and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (20 - (6 + 9)))) then
					if (v22(v98.HealingSurge) or ((905 + 4033) < (2440 + 2322))) then
						return "healing_surge defensive 4";
					end
				end
				v151 = 171 - (28 + 141);
			end
			if ((v151 == (0 + 0)) or ((3090 - 586) > (3020 + 1244))) then
				if (((3470 - (486 + 831)) == (5602 - 3449)) and v98.AstralShift:IsReady() and v66 and (v14:HealthPercentage() <= v74)) then
					if (v22(v98.AstralShift) or ((1784 - 1277) >= (490 + 2101))) then
						return "astral_shift defensive 1";
					end
				end
				if (((14168 - 9687) == (5744 - (668 + 595))) and v98.AncestralGuidance:IsReady() and v67 and v114.AreUnitsBelowHealthPercentage(v75, v76)) then
					if (v22(v98.AncestralGuidance) or ((2095 + 233) < (140 + 553))) then
						return "ancestral_guidance defensive 2";
					end
				end
				v151 = 2 - 1;
			end
		end
	end
	local function v129()
		local v152 = 290 - (23 + 267);
		while true do
			if (((6272 - (1129 + 815)) == (4715 - (371 + 16))) and ((1751 - (1326 + 424)) == v152)) then
				v28 = v114.HandleBottomTrinket(v101, v31, 75 - 35, nil);
				if (((5802 - 4214) >= (1450 - (88 + 30))) and v28) then
					return v28;
				end
				break;
			end
			if (((771 - (720 + 51)) == v152) or ((9284 - 5110) > (6024 - (421 + 1355)))) then
				v28 = v114.HandleTopTrinket(v101, v31, 65 - 25, nil);
				if (v28 or ((2253 + 2333) <= (1165 - (286 + 797)))) then
					return v28;
				end
				v152 = 3 - 2;
			end
		end
	end
	local function v130()
		if (((6397 - 2534) == (4302 - (397 + 42))) and v98.WindfuryTotem:IsReady() and v48 and (v14:BuffDown(v98.WindfuryTotemBuff, true) or (v98.WindfuryTotem:TimeSinceLastCast() > (29 + 61)))) then
			if (v22(v98.WindfuryTotem) or ((1082 - (24 + 776)) <= (63 - 21))) then
				return "windfury_totem precombat 4";
			end
		end
		if (((5394 - (222 + 563)) >= (1687 - 921)) and v98.FeralSpirit:IsCastable() and v52 and ((v57 and v31) or not v57)) then
			if (v22(v98.FeralSpirit) or ((830 + 322) == (2678 - (23 + 167)))) then
				return "feral_spirit precombat 6";
			end
		end
		if (((5220 - (690 + 1108)) > (1209 + 2141)) and v98.DoomWinds:IsCastable() and v53 and ((v58 and v31) or not v58)) then
			if (((724 + 153) > (1224 - (40 + 808))) and v22(v98.DoomWinds, not v15:IsSpellInRange(v98.DoomWinds))) then
				return "doom_winds precombat 8";
			end
		end
		if ((v98.Sundering:IsReady() and v47 and ((v59 and v32) or not v59)) or ((514 + 2604) <= (7078 - 5227))) then
			if (v22(v98.Sundering, not v15:IsInRange(5 + 0)) or ((88 + 77) >= (1915 + 1577))) then
				return "sundering precombat 10";
			end
		end
		if (((4520 - (47 + 524)) < (3152 + 1704)) and v98.Stormstrike:IsReady() and v46) then
			if (v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike)) or ((11688 - 7412) < (4509 - 1493))) then
				return "stormstrike precombat 12";
			end
		end
	end
	local function v131()
		local v153 = 0 - 0;
		while true do
			if (((6416 - (1165 + 561)) > (123 + 4002)) and ((3 - 2) == v153)) then
				if ((v98.LavaLash:IsReady() and v43 and (v14:BuffUp(v98.HotHandBuff))) or ((20 + 30) >= (1375 - (341 + 138)))) then
					if (v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash)) or ((463 + 1251) >= (6104 - 3146))) then
						return "lava_lash single 7";
					end
				end
				if ((v98.WindfuryTotem:IsReady() and v48 and (v14:BuffDown(v98.WindfuryTotemBuff, true))) or ((1817 - (89 + 237)) < (2071 - 1427))) then
					if (((1481 - 777) < (1868 - (581 + 300))) and v22(v98.WindfuryTotem)) then
						return "windfury_totem single 8";
					end
				end
				if (((4938 - (855 + 365)) > (4526 - 2620)) and v98.ElementalBlast:IsReady() and v37 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (2 + 3)) and (v98.ElementalBlast:Charges() == v110)) then
					if (v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast)) or ((2193 - (1030 + 205)) > (3413 + 222))) then
						return "elemental_blast single 9";
					end
				end
				if (((3257 + 244) <= (4778 - (156 + 130))) and v98.LightningBolt:IsReady() and v44 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (17 - 9)) and v14:BuffUp(v98.PrimordialWaveBuff) and (v14:BuffDown(v98.SplinteredElementsBuff) or (v113 <= (19 - 7)))) then
					if (v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt)) or ((7048 - 3606) < (672 + 1876))) then
						return "lightning_bolt single 10";
					end
				end
				if (((1677 + 1198) >= (1533 - (10 + 59))) and v98.ChainLightning:IsReady() and v35 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (3 + 5)) and v14:BuffUp(v98.CracklingThunderBuff) and v98.ElementalSpirits:IsAvailable()) then
					if (v22(v98.ChainLightning, not v15:IsSpellInRange(v98.ChainLightning)) or ((23624 - 18827) >= (6056 - (671 + 492)))) then
						return "chain_lightning single 11";
					end
				end
				if ((v98.ElementalBlast:IsReady() and v37 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (7 + 1)) and (v14:BuffUp(v98.FeralSpiritBuff) or not v98.ElementalSpirits:IsAvailable())) or ((1766 - (369 + 846)) > (548 + 1520))) then
					if (((1805 + 309) > (2889 - (1036 + 909))) and v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast))) then
						return "elemental_blast single 12";
					end
				end
				v153 = 2 + 0;
			end
			if ((v153 == (0 - 0)) or ((2465 - (11 + 192)) >= (1565 + 1531))) then
				if ((v98.PrimordialWave:IsCastable() and v45 and ((v60 and v32) or not v60) and (v96 < v113) and v15:DebuffDown(v98.FlameShockDebuff) and v98.LashingFlames:IsAvailable()) or ((2430 - (135 + 40)) >= (8569 - 5032))) then
					if (v22(v98.PrimordialWave, not v15:IsSpellInRange(v98.PrimordialWave)) or ((2313 + 1524) < (2876 - 1570))) then
						return "primordial_wave single 1";
					end
				end
				if (((4422 - 1472) == (3126 - (50 + 126))) and v98.FlameShock:IsReady() and v39 and v15:DebuffDown(v98.FlameShockDebuff) and v98.LashingFlames:IsAvailable()) then
					if (v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock)) or ((13151 - 8428) < (730 + 2568))) then
						return "flame_shock single 2";
					end
				end
				if (((2549 - (1233 + 180)) >= (1123 - (522 + 447))) and v98.ElementalBlast:IsReady() and v37 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (1426 - (107 + 1314))) and v98.ElementalSpirits:IsAvailable() and v14:BuffUp(v98.FeralSpiritBuff)) then
					if (v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast)) or ((126 + 145) > (14467 - 9719))) then
						return "elemental_blast single 3";
					end
				end
				if (((2014 + 2726) >= (6258 - 3106)) and v98.Sundering:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113) and (v14:HasTier(118 - 88, 1912 - (716 + 1194)))) then
					if (v22(v98.Sundering, not v15:IsInRange(1 + 4)) or ((277 + 2301) >= (3893 - (74 + 429)))) then
						return "sundering single 4";
					end
				end
				if (((78 - 37) <= (824 + 837)) and v98.LightningBolt:IsReady() and v44 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (11 - 6)) and v14:BuffDown(v98.CracklingThunderBuff) and v14:BuffUp(v98.AscendanceBuff) and (v111 == "Chain Lightning") and (v14:BuffRemains(v98.AscendanceBuff) > (v98.ChainLightning:CooldownRemains() + v14:GCD()))) then
					if (((426 + 175) < (10975 - 7415)) and v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt))) then
						return "lightning_bolt single 5";
					end
				end
				if (((581 - 346) < (1120 - (279 + 154))) and v98.Stormstrike:IsReady() and v46 and (v14:BuffUp(v98.DoomWindsBuff) or v98.DeeplyRootedElements:IsAvailable() or (v98.Stormblast:IsAvailable() and v14:BuffUp(v98.StormbringerBuff)))) then
					if (((5327 - (454 + 324)) > (908 + 245)) and v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike))) then
						return "stormstrike single 6";
					end
				end
				v153 = 18 - (12 + 5);
			end
			if ((v153 == (2 + 0)) or ((11909 - 7235) < (1727 + 2945))) then
				if (((4761 - (277 + 816)) < (19489 - 14928)) and v98.LavaBurst:IsReady() and v42 and not v98.ThorimsInvocation:IsAvailable() and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (1188 - (1058 + 125)))) then
					if (v22(v98.LavaBurst, not v15:IsSpellInRange(v98.LavaBurst)) or ((86 + 369) == (4580 - (815 + 160)))) then
						return "lava_burst single 13";
					end
				end
				if ((v98.LightningBolt:IsReady() and v44 and ((v14:BuffStack(v98.MaelstromWeaponBuff) >= (34 - 26)) or (v98.StaticAccumulation:IsAvailable() and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (11 - 6)))) and v14:BuffDown(v98.PrimordialWaveBuff)) or ((636 + 2027) == (9681 - 6369))) then
					if (((6175 - (41 + 1857)) <= (6368 - (1222 + 671))) and v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt))) then
						return "lightning_bolt single 14";
					end
				end
				if ((v98.CrashLightning:IsReady() and v36 and v98.AlphaWolf:IsAvailable() and v14:BuffUp(v98.FeralSpiritBuff) and (v117() == (0 - 0))) or ((1250 - 380) == (2371 - (229 + 953)))) then
					if (((3327 - (1111 + 663)) <= (4712 - (874 + 705))) and v22(v98.CrashLightning, not v15:IsInMeleeRange(1 + 4))) then
						return "crash_lightning single 15";
					end
				end
				if ((v98.PrimordialWave:IsCastable() and v45 and ((v60 and v32) or not v60) and (v96 < v113)) or ((1527 + 710) >= (7297 - 3786))) then
					if (v22(v98.PrimordialWave, not v15:IsSpellInRange(v98.PrimordialWave)) or ((38 + 1286) > (3699 - (642 + 37)))) then
						return "primordial_wave single 16";
					end
				end
				if ((v98.FlameShock:IsReady() and v39 and (v15:DebuffDown(v98.FlameShockDebuff))) or ((683 + 2309) == (301 + 1580))) then
					if (((7798 - 4692) > (1980 - (233 + 221))) and v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock))) then
						return "flame_shock single 17";
					end
				end
				if (((6990 - 3967) < (3407 + 463)) and v98.IceStrike:IsReady() and v41 and v98.ElementalAssault:IsAvailable() and v98.SwirlingMaelstrom:IsAvailable()) then
					if (((1684 - (718 + 823)) > (47 + 27)) and v22(v98.IceStrike, not v15:IsInMeleeRange(810 - (266 + 539)))) then
						return "ice_strike single 18";
					end
				end
				v153 = 8 - 5;
			end
			if (((1243 - (636 + 589)) < (5013 - 2901)) and (v153 == (8 - 4))) then
				if (((870 + 227) <= (592 + 1036)) and v98.Stormstrike:IsReady() and v46) then
					if (((5645 - (657 + 358)) == (12259 - 7629)) and v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike))) then
						return "stormstrike single 25";
					end
				end
				if (((8065 - 4525) > (3870 - (1151 + 36))) and v98.Sundering:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113)) then
					if (((4630 + 164) >= (862 + 2413)) and v22(v98.Sundering, not v15:IsInRange(14 - 9))) then
						return "sundering single 26";
					end
				end
				if (((3316 - (1552 + 280)) == (2318 - (64 + 770))) and v98.BagofTricks:IsReady() and v55 and ((v62 and v31) or not v62)) then
					if (((973 + 459) < (8070 - 4515)) and v22(v98.BagofTricks)) then
						return "bag_of_tricks single 27";
					end
				end
				if ((v98.FireNova:IsReady() and v38 and v98.SwirlingMaelstrom:IsAvailable() and v15:DebuffUp(v98.FlameShockDebuff) and (v14:BuffStack(v98.MaelstromWeaponBuff) < (1 + 4 + ((1248 - (157 + 1086)) * v23(v98.OverflowingMaelstrom:IsAvailable()))))) or ((2131 - 1066) > (15670 - 12092))) then
					if (v22(v98.FireNova) or ((7354 - 2559) < (1920 - 513))) then
						return "fire_nova single 28";
					end
				end
				if (((2672 - (599 + 220)) < (9583 - 4770)) and v98.LightningBolt:IsReady() and v44 and v98.Hailstorm:IsAvailable() and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (1936 - (1813 + 118))) and v14:BuffDown(v98.PrimordialWaveBuff)) then
					if (v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt)) or ((2063 + 758) < (3648 - (841 + 376)))) then
						return "lightning_bolt single 29";
					end
				end
				if ((v98.FrostShock:IsReady() and v40) or ((4026 - 1152) < (507 + 1674))) then
					if (v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock)) or ((7339 - 4650) <= (1202 - (464 + 395)))) then
						return "frost_shock single 30";
					end
				end
				v153 = 12 - 7;
			end
			if (((2 + 1) == v153) or ((2706 - (467 + 370)) == (4151 - 2142))) then
				if ((v98.LavaLash:IsReady() and v43 and (v98.LashingFlames:IsAvailable())) or ((2603 + 943) < (7959 - 5637))) then
					if (v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash)) or ((325 + 1757) == (11104 - 6331))) then
						return "lava_lash single 19";
					end
				end
				if (((3764 - (150 + 370)) > (2337 - (74 + 1208))) and v98.IceStrike:IsReady() and v41 and (v14:BuffDown(v98.IceStrikeBuff))) then
					if (v22(v98.IceStrike, not v15:IsInMeleeRange(12 - 7)) or ((15712 - 12399) <= (1266 + 512))) then
						return "ice_strike single 20";
					end
				end
				if ((v98.FrostShock:IsReady() and v40 and (v14:BuffUp(v98.HailstormBuff))) or ((1811 - (14 + 376)) >= (3648 - 1544))) then
					if (((1173 + 639) <= (2855 + 394)) and v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock))) then
						return "frost_shock single 21";
					end
				end
				if (((1548 + 75) <= (5734 - 3777)) and v98.LavaLash:IsReady() and v43) then
					if (((3320 + 1092) == (4490 - (23 + 55))) and v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash))) then
						return "lava_lash single 22";
					end
				end
				if (((4147 - 2397) >= (562 + 280)) and v98.IceStrike:IsReady() and v41) then
					if (((3927 + 445) > (2868 - 1018)) and v22(v98.IceStrike, not v15:IsInMeleeRange(2 + 3))) then
						return "ice_strike single 23";
					end
				end
				if (((1133 - (652 + 249)) < (2197 - 1376)) and v98.Windstrike:IsCastable() and v49) then
					if (((2386 - (708 + 1160)) < (2448 - 1546)) and v22(v98.Windstrike, not v15:IsSpellInRange(v98.Windstrike))) then
						return "windstrike single 24";
					end
				end
				v153 = 6 - 2;
			end
			if (((3021 - (10 + 17)) > (193 + 665)) and (v153 == (1737 - (1400 + 332)))) then
				if ((v98.CrashLightning:IsReady() and v36) or ((7202 - 3447) <= (2823 - (242 + 1666)))) then
					if (((1689 + 2257) > (1372 + 2371)) and v22(v98.CrashLightning, not v15:IsInMeleeRange(5 + 0))) then
						return "crash_lightning single 31";
					end
				end
				if ((v98.FireNova:IsReady() and v38 and (v15:DebuffUp(v98.FlameShockDebuff))) or ((2275 - (850 + 90)) >= (5789 - 2483))) then
					if (((6234 - (360 + 1030)) > (1994 + 259)) and v22(v98.FireNova)) then
						return "fire_nova single 32";
					end
				end
				if (((1275 - 823) == (621 - 169)) and v98.FlameShock:IsReady() and v39) then
					if (v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock)) or ((6218 - (909 + 752)) < (3310 - (109 + 1114)))) then
						return "flame_shock single 33";
					end
				end
				if (((7092 - 3218) == (1509 + 2365)) and v98.ChainLightning:IsReady() and v35 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (247 - (6 + 236))) and v14:BuffUp(v98.CracklingThunderBuff) and v98.ElementalSpirits:IsAvailable()) then
					if (v22(v98.ChainLightning, not v15:IsSpellInRange(v98.ChainLightning)) or ((1222 + 716) > (3973 + 962))) then
						return "chain_lightning single 34";
					end
				end
				if ((v98.LightningBolt:IsReady() and v44 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (11 - 6)) and v14:BuffDown(v98.PrimordialWaveBuff)) or ((7432 - 3177) < (4556 - (1076 + 57)))) then
					if (((240 + 1214) <= (3180 - (579 + 110))) and v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt))) then
						return "lightning_bolt single 35";
					end
				end
				if ((v98.WindfuryTotem:IsReady() and v48 and (v14:BuffDown(v98.WindfuryTotemBuff, true) or (v98.WindfuryTotem:TimeSinceLastCast() > (8 + 82)))) or ((3676 + 481) <= (1488 + 1315))) then
					if (((5260 - (174 + 233)) >= (8329 - 5347)) and v22(v98.WindfuryTotem)) then
						return "windfury_totem single 36";
					end
				end
				break;
			end
		end
	end
	local function v132()
		local v154 = 0 - 0;
		while true do
			if (((1839 + 2295) > (4531 - (663 + 511))) and (v154 == (5 + 0))) then
				if ((v98.FrostShock:IsReady() and v40 and not v98.Hailstorm:IsAvailable()) or ((742 + 2675) < (7812 - 5278))) then
					if (v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock)) or ((1649 + 1073) <= (386 - 222))) then
						return "frost_shock aoe 31";
					end
				end
				break;
			end
			if ((v154 == (0 - 0)) or ((1150 + 1258) < (4104 - 1995))) then
				if ((v98.CrashLightning:IsReady() and v36 and v98.CrashingStorms:IsAvailable() and ((v98.UnrulyWinds:IsAvailable() and (v108 >= (8 + 2))) or (v108 >= (2 + 13)))) or ((755 - (478 + 244)) == (1972 - (440 + 77)))) then
					if (v22(v98.CrashLightning, not v15:IsInMeleeRange(3 + 2)) or ((1621 - 1178) >= (5571 - (655 + 901)))) then
						return "crash_lightning aoe 1";
					end
				end
				if (((628 + 2754) > (128 + 38)) and v98.LightningBolt:IsReady() and v44 and ((v15:DebuffStack(v98.FlameShockDebuff) >= v108) or (v15:DebuffStack(v98.FlameShockDebuff) >= (5 + 1))) and v14:BuffUp(v98.PrimordialWaveBuff) and (v14:BuffStack(v98.MaelstromWeaponBuff) == ((20 - 15) + ((1450 - (695 + 750)) * v23(v98.OverflowingMaelstrom:IsAvailable())))) and (v14:BuffDown(v98.SplinteredElementsBuff) or (v113 <= (40 - 28)) or (v96 <= v14:GCD()))) then
					if (v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt)) or ((432 - 152) == (12302 - 9243))) then
						return "lightning_bolt aoe 2";
					end
				end
				if (((2232 - (285 + 66)) > (3013 - 1720)) and v98.LavaLash:IsReady() and v43 and v98.MoltenAssault:IsAvailable() and (v98.PrimordialWave:IsAvailable() or v98.FireNova:IsAvailable()) and v15:DebuffUp(v98.FlameShockDebuff) and (v98.FlameShockDebuff:AuraActiveCount() < v108) and (v98.FlameShockDebuff:AuraActiveCount() < (1316 - (682 + 628)))) then
					if (((380 + 1977) == (2656 - (176 + 123))) and v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash))) then
						return "lava_lash aoe 3";
					end
				end
				if (((52 + 71) == (90 + 33)) and v98.PrimordialWave:IsCastable() and v45 and ((v60 and v32) or not v60) and (v96 < v113) and (v14:BuffDown(v98.PrimordialWaveBuff))) then
					if (v114.CastCycle(v98.PrimordialWave, v107, v118, not v15:IsSpellInRange(v98.PrimordialWave)) or ((1325 - (239 + 30)) >= (923 + 2469))) then
						return "primordial_wave aoe 4";
					end
				end
				if ((v98.FlameShock:IsReady() and v39 and (v98.PrimordialWave:IsAvailable() or v98.FireNova:IsAvailable()) and v15:DebuffDown(v98.FlameShockDebuff)) or ((1039 + 42) < (1902 - 827))) then
					if (v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock)) or ((3272 - 2223) >= (4747 - (306 + 9)))) then
						return "flame_shock aoe 5";
					end
				end
				if ((v98.ElementalBlast:IsReady() and v37 and (not v98.ElementalSpirits:IsAvailable() or (v98.ElementalSpirits:IsAvailable() and ((v98.ElementalBlast:Charges() == v110) or v14:BuffUp(v98.FeralSpiritBuff))))) or ((16638 - 11870) <= (148 + 698))) then
					if (v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast)) or ((2061 + 1297) <= (684 + 736))) then
						return "elemental_blast aoe 6";
					end
				end
				v154 = 2 - 1;
			end
			if ((v154 == (1378 - (1140 + 235))) or ((2380 + 1359) <= (2756 + 249))) then
				if ((v98.Stormstrike:IsReady() and v46 and v14:BuffUp(v98.CrashLightningBuff) and (v98.DeeplyRootedElements:IsAvailable() or (v14:BuffStack(v98.ConvergingStormsBuff) == (2 + 4)))) or ((1711 - (33 + 19)) >= (771 + 1363))) then
					if (v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike)) or ((9770 - 6510) < (1038 + 1317))) then
						return "stormstrike aoe 19";
					end
				end
				if ((v98.CrashLightning:IsReady() and v36 and v98.CrashingStorms:IsAvailable() and v14:BuffUp(v98.CLCrashLightningBuff) and (v108 >= (7 - 3))) or ((628 + 41) == (4912 - (586 + 103)))) then
					if (v22(v98.CrashLightning, not v15:IsInMeleeRange(1 + 4)) or ((5208 - 3516) < (2076 - (1309 + 179)))) then
						return "crash_lightning aoe 20";
					end
				end
				if ((v98.Windstrike:IsCastable() and v49) or ((8659 - 3862) < (1590 + 2061))) then
					if (v22(v98.Windstrike, not v15:IsSpellInRange(v98.Windstrike)) or ((11217 - 7040) > (3664 + 1186))) then
						return "windstrike aoe 21";
					end
				end
				if ((v98.Stormstrike:IsReady() and v46) or ((849 - 449) > (2213 - 1102))) then
					if (((3660 - (295 + 314)) > (2468 - 1463)) and v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike))) then
						return "stormstrike aoe 22";
					end
				end
				if (((5655 - (1300 + 662)) <= (13760 - 9378)) and v98.IceStrike:IsReady() and v41) then
					if (v22(v98.IceStrike, not v15:IsInMeleeRange(1760 - (1178 + 577))) or ((1705 + 1577) > (12120 - 8020))) then
						return "ice_strike aoe 23";
					end
				end
				if ((v98.LavaLash:IsReady() and v43) or ((4985 - (851 + 554)) < (2515 + 329))) then
					if (((246 - 157) < (9751 - 5261)) and v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash))) then
						return "lava_lash aoe 24";
					end
				end
				v154 = 306 - (115 + 187);
			end
			if ((v154 == (2 + 0)) or ((4718 + 265) < (7124 - 5316))) then
				if (((4990 - (160 + 1001)) > (3298 + 471)) and v98.IceStrike:IsReady() and v41 and (v98.Hailstorm:IsAvailable())) then
					if (((1025 + 460) <= (5944 - 3040)) and v22(v98.IceStrike, not v15:IsInMeleeRange(363 - (237 + 121)))) then
						return "ice_strike aoe 13";
					end
				end
				if (((5166 - (525 + 372)) == (8092 - 3823)) and v98.FrostShock:IsReady() and v40 and v98.Hailstorm:IsAvailable() and v14:BuffUp(v98.HailstormBuff)) then
					if (((1271 - 884) <= (2924 - (96 + 46))) and v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock))) then
						return "frost_shock aoe 14";
					end
				end
				if ((v98.Sundering:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113)) or ((2676 - (643 + 134)) <= (332 + 585))) then
					if (v22(v98.Sundering, not v15:IsInRange(11 - 6)) or ((16008 - 11696) <= (841 + 35))) then
						return "sundering aoe 15";
					end
				end
				if (((4380 - 2148) <= (5306 - 2710)) and v98.FlameShock:IsReady() and v39 and v98.MoltenAssault:IsAvailable() and v15:DebuffDown(v98.FlameShockDebuff)) then
					if (((2814 - (316 + 403)) < (2451 + 1235)) and v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock))) then
						return "flame_shock aoe 16";
					end
				end
				if ((v98.FlameShock:IsReady() and v39 and v15:DebuffRefreshable(v98.FlameShockDebuff) and (v98.FireNova:IsAvailable() or v98.PrimordialWave:IsAvailable()) and (v98.FlameShockDebuff:AuraActiveCount() < v108) and (v98.FlameShockDebuff:AuraActiveCount() < (16 - 10))) or ((577 + 1018) >= (11266 - 6792))) then
					if (v114.CastCycle(v98.FlameShock, v107, v118, not v15:IsSpellInRange(v98.FlameShock)) or ((3274 + 1345) < (929 + 1953))) then
						return "flame_shock aoe 17";
					end
				end
				if ((v98.FireNova:IsReady() and v38 and (v98.FlameShockDebuff:AuraActiveCount() >= (10 - 7))) or ((1404 - 1110) >= (10035 - 5204))) then
					if (((117 + 1912) <= (6070 - 2986)) and v22(v98.FireNova)) then
						return "fire_nova aoe 18";
					end
				end
				v154 = 1 + 2;
			end
			if ((v154 == (11 - 7)) or ((2054 - (12 + 5)) == (9399 - 6979))) then
				if (((9511 - 5053) > (8298 - 4394)) and v98.CrashLightning:IsReady() and v36) then
					if (((1081 - 645) >= (25 + 98)) and v22(v98.CrashLightning, not v15:IsInMeleeRange(1978 - (1656 + 317)))) then
						return "crash_lightning aoe 25";
					end
				end
				if (((446 + 54) < (1456 + 360)) and v98.FireNova:IsReady() and v38 and (v98.FlameShockDebuff:AuraActiveCount() >= (4 - 2))) then
					if (((17589 - 14015) == (3928 - (5 + 349))) and v22(v98.FireNova)) then
						return "fire_nova aoe 26";
					end
				end
				if (((1049 - 828) < (1661 - (266 + 1005))) and v98.ElementalBlast:IsReady() and v37 and (not v98.ElementalSpirits:IsAvailable() or (v98.ElementalSpirits:IsAvailable() and ((v98.ElementalBlast:Charges() == v110) or v14:BuffUp(v98.FeralSpiritBuff))))) then
					if (v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast)) or ((1459 + 754) <= (4848 - 3427))) then
						return "elemental_blast aoe 27";
					end
				end
				if (((4025 - 967) < (6556 - (561 + 1135))) and v98.ChainLightning:IsReady() and v35 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (6 - 1))) then
					if (v22(v98.ChainLightning, not v15:IsSpellInRange(v98.ChainLightning)) or ((4260 - 2964) >= (5512 - (507 + 559)))) then
						return "chain_lightning aoe 28";
					end
				end
				if ((v98.WindfuryTotem:IsReady() and v48 and (v14:BuffDown(v98.WindfuryTotemBuff, true) or (v98.WindfuryTotem:TimeSinceLastCast() > (225 - 135)))) or ((4307 - 2914) > (4877 - (212 + 176)))) then
					if (v22(v98.WindfuryTotem) or ((5329 - (250 + 655)) < (73 - 46))) then
						return "windfury_totem aoe 29";
					end
				end
				if ((v98.FlameShock:IsReady() and v39 and (v15:DebuffDown(v98.FlameShockDebuff))) or ((3488 - 1491) > (5968 - 2153))) then
					if (((5421 - (1869 + 87)) > (6634 - 4721)) and v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock))) then
						return "flame_shock aoe 30";
					end
				end
				v154 = 1906 - (484 + 1417);
			end
			if (((1570 - 837) < (3047 - 1228)) and (v154 == (774 - (48 + 725)))) then
				if ((v98.ChainLightning:IsReady() and v35 and (v14:BuffStack(v98.MaelstromWeaponBuff) == ((8 - 3) + ((13 - 8) * v23(v98.OverflowingMaelstrom:IsAvailable()))))) or ((2555 + 1840) == (12707 - 7952))) then
					if (v22(v98.ChainLightning, not v15:IsSpellInRange(v98.ChainLightning)) or ((1062 + 2731) < (691 + 1678))) then
						return "chain_lightning aoe 7";
					end
				end
				if ((v98.CrashLightning:IsReady() and v36 and (v14:BuffUp(v98.DoomWindsBuff) or v14:BuffDown(v98.CrashLightningBuff) or (v98.AlphaWolf:IsAvailable() and v14:BuffUp(v98.FeralSpiritBuff) and (v117() == (853 - (152 + 701)))))) or ((5395 - (430 + 881)) == (102 + 163))) then
					if (((5253 - (557 + 338)) == (1289 + 3069)) and v22(v98.CrashLightning, not v15:IsInMeleeRange(14 - 9))) then
						return "crash_lightning aoe 8";
					end
				end
				if ((v98.Sundering:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113) and (v14:BuffUp(v98.DoomWindsBuff) or v14:HasTier(105 - 75, 4 - 2))) or ((6762 - 3624) < (1794 - (499 + 302)))) then
					if (((4196 - (39 + 827)) > (6412 - 4089)) and v22(v98.Sundering, not v15:IsInRange(11 - 6))) then
						return "sundering aoe 9";
					end
				end
				if ((v98.FireNova:IsReady() and v38 and ((v98.FlameShockDebuff:AuraActiveCount() >= (23 - 17)) or ((v98.FlameShockDebuff:AuraActiveCount() >= (5 - 1)) and (v98.FlameShockDebuff:AuraActiveCount() >= v108)))) or ((311 + 3315) == (11675 - 7686))) then
					if (v22(v98.FireNova) or ((147 + 769) == (4226 - 1555))) then
						return "fire_nova aoe 10";
					end
				end
				if (((376 - (103 + 1)) == (826 - (475 + 79))) and v98.LavaLash:IsReady() and v43 and (v98.LashingFlames:IsAvailable())) then
					if (((9185 - 4936) <= (15484 - 10645)) and v114.CastCycle(v98.LavaLash, v107, v119, not v15:IsSpellInRange(v98.LavaLash))) then
						return "lava_lash aoe 11";
					end
				end
				if (((359 + 2418) < (2817 + 383)) and v98.LavaLash:IsReady() and v43 and ((v98.MoltenAssault:IsAvailable() and v15:DebuffUp(v98.FlameShockDebuff) and (v98.FlameShockDebuff:AuraActiveCount() < v108) and (v98.FlameShockDebuff:AuraActiveCount() < (1509 - (1395 + 108)))) or (v98.AshenCatalyst:IsAvailable() and (v14:BuffStack(v98.AshenCatalystBuff) == (14 - 9))))) then
					if (((1299 - (7 + 1197)) < (854 + 1103)) and v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash))) then
						return "lava_lash aoe 12";
					end
				end
				v154 = 1 + 1;
			end
		end
	end
	local function v133()
		if (((1145 - (27 + 292)) < (5031 - 3314)) and v98.LightningBolt:IsReady() and v44 and ((v15:DebuffStack(v98.FlameShockDebuff) >= v108) or (v15:DebuffStack(v98.FlameShockDebuff) == (7 - 1))) and v14:BuffUp(v98.PrimordialWaveBuff) and (v14:BuffStack(v98.MaelstromWeaponBuff) == ((20 - 15) + ((9 - 4) * v23(v98.OverflowingMaelstrom:IsAvailable())))) and (v14:BuffDown(v98.SplinteredElementsBuff) or (v113 <= (22 - 10)) or (v96 <= v14:GCD()))) then
			if (((1565 - (43 + 96)) >= (4507 - 3402)) and v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt))) then
				return "lightning_bolt funnel 1";
			end
		end
		if (((6226 - 3472) <= (2804 + 575)) and v98.LavaLash:IsReady() and v43 and ((v98.MoltenAssault:IsAvailable() and v15:DebuffUp(v98.FlameShockDebuff) and (v98.FlameShockDebuff:AuraActiveCount() < v108) and (v98.FlameShockDebuff:AuraActiveCount() < (2 + 4))) or (v98.AshenCatalyst:IsAvailable() and (v14:BuffStack(v98.AshenCatalystBuff) == (9 - 4))))) then
			if (v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash)) or ((1506 + 2421) == (2647 - 1234))) then
				return "lava_lash funnel 2";
			end
		end
		if ((v98.PrimordialWave:IsCastable() and v45 and ((v60 and v32) or not v60) and (v96 < v113) and (v14:BuffDown(v98.PrimordialWaveBuff))) or ((364 + 790) <= (58 + 730))) then
			if (v114.CastCycle(v98.PrimordialWave, v107, v118, not v15:IsSpellInRange(v98.PrimordialWave)) or ((3394 - (1414 + 337)) > (5319 - (1642 + 298)))) then
				return "primordial_wave funnel 3";
			end
		end
		if ((v98.FlameShock:IsReady() and v39 and (v98.PrimordialWave:IsAvailable() or v98.FireNova:IsAvailable()) and v15:DebuffDown(v98.FlameShockDebuff)) or ((7306 - 4503) > (13086 - 8537))) then
			if (v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock)) or ((652 - 432) >= (995 + 2027))) then
				return "flame_shock funnel 4";
			end
		end
		if (((2196 + 626) == (3794 - (357 + 615))) and v98.ElementalBlast:IsReady() and v37 and (not v98.ElementalSpirits:IsAvailable() or (v98.ElementalSpirits:IsAvailable() and ((v98.ElementalBlast:Charges() == v110) or v14:BuffUp(v98.FeralSpiritBuff))))) then
			if (v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast)) or ((745 + 316) == (4556 - 2699))) then
				return "elemental_blast funnel 5";
			end
		end
		if (((2365 + 395) > (2922 - 1558)) and v98.Windstrike:IsCastable() and v49 and ((v98.ThorimsInvocation:IsAvailable() and (v14:BuffStack(v98.MaelstromWeaponBuff) > (1 + 0))) or (v14:BuffStack(v98.ConvergingStormsBuff) == (1 + 5)))) then
			if (v22(v98.Windstrike, not v15:IsSpellInRange(v98.Windstrike)) or ((3082 + 1820) <= (4896 - (384 + 917)))) then
				return "windstrike funnel 6";
			end
		end
		if ((v98.Stormstrike:IsReady() and v46 and (v14:BuffStack(v98.ConvergingStormsBuff) == (703 - (128 + 569)))) or ((5395 - (1407 + 136)) == (2180 - (687 + 1200)))) then
			if (v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike)) or ((3269 - (556 + 1154)) == (16140 - 11552))) then
				return "stormstrike funnel 7";
			end
		end
		if ((v98.ChainLightning:IsReady() and v35 and (v14:BuffStack(v98.MaelstromWeaponBuff) == ((100 - (9 + 86)) + ((426 - (275 + 146)) * v23(v98.OverflowingMaelstrom:IsAvailable())))) and v14:BuffUp(v98.CracklingThunderBuff)) or ((730 + 3754) == (852 - (29 + 35)))) then
			if (((20245 - 15677) >= (11669 - 7762)) and v22(v98.ChainLightning, not v15:IsSpellInRange(v98.ChainLightning))) then
				return "chain_lightning funnel 8";
			end
		end
		if (((5500 - 4254) < (2261 + 1209)) and v98.LavaBurst:IsReady() and v42 and ((v14:BuffStack(v98.MoltenWeaponBuff) + v23(v14:BuffUp(v98.VolcanicStrengthBuff))) > v14:BuffStack(v98.CracklingSurgeBuff)) and (v14:BuffStack(v98.MaelstromWeaponBuff) == ((1017 - (53 + 959)) + ((413 - (312 + 96)) * v23(v98.OverflowingMaelstrom:IsAvailable()))))) then
			if (((7060 - 2992) >= (1257 - (147 + 138))) and v22(v98.LavaBurst, not v15:IsSpellInRange(v98.LavaBurst))) then
				return "lava_burst funnel 9";
			end
		end
		if (((1392 - (813 + 86)) < (3519 + 374)) and v98.LightningBolt:IsReady() and v44 and (v14:BuffStack(v98.MaelstromWeaponBuff) == ((8 - 3) + ((497 - (18 + 474)) * v23(v98.OverflowingMaelstrom:IsAvailable()))))) then
			if (v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt)) or ((497 + 976) >= (10875 - 7543))) then
				return "lightning_bolt funnel 10";
			end
		end
		if ((v98.CrashLightning:IsReady() and v36 and (v14:BuffUp(v98.DoomWindsBuff) or v14:BuffDown(v98.CrashLightningBuff) or (v98.AlphaWolf:IsAvailable() and v14:BuffUp(v98.FeralSpiritBuff) and (v117() == (1086 - (860 + 226)))) or (v98.ConvergingStorms:IsAvailable() and (v14:BuffStack(v98.ConvergingStormsBuff) < (309 - (121 + 182)))))) or ((499 + 3552) <= (2397 - (988 + 252)))) then
			if (((69 + 535) < (903 + 1978)) and v22(v98.CrashLightning, not v15:IsInMeleeRange(1975 - (49 + 1921)))) then
				return "crash_lightning funnel 11";
			end
		end
		if ((v98.Sundering:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113) and (v14:BuffUp(v98.DoomWindsBuff) or v14:HasTier(920 - (223 + 667), 54 - (51 + 1)))) or ((1549 - 649) == (7230 - 3853))) then
			if (((5584 - (146 + 979)) > (167 + 424)) and v22(v98.Sundering, not v15:IsInRange(610 - (311 + 294)))) then
				return "sundering funnel 12";
			end
		end
		if (((9475 - 6077) >= (1015 + 1380)) and v98.FireNova:IsReady() and v38 and ((v98.FlameShockDebuff:AuraActiveCount() == (1449 - (496 + 947))) or ((v98.FlameShockDebuff:AuraActiveCount() >= (1362 - (1233 + 125))) and (v98.FlameShockDebuff:AuraActiveCount() >= v108)))) then
			if (v22(v98.FireNova) or ((886 + 1297) >= (2534 + 290))) then
				return "fire_nova funnel 13";
			end
		end
		if (((368 + 1568) == (3581 - (963 + 682))) and v98.IceStrike:IsReady() and v41 and v98.Hailstorm:IsAvailable() and v14:BuffDown(v98.IceStrikeBuff)) then
			if (v22(v98.IceStrike, not v15:IsInMeleeRange(5 + 0)) or ((6336 - (504 + 1000)) < (2905 + 1408))) then
				return "ice_strike funnel 14";
			end
		end
		if (((3723 + 365) > (366 + 3508)) and v98.FrostShock:IsReady() and v40 and v98.Hailstorm:IsAvailable() and v14:BuffUp(v98.HailstormBuff)) then
			if (((6387 - 2055) == (3702 + 630)) and v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock))) then
				return "frost_shock funnel 15";
			end
		end
		if (((2326 + 1673) >= (3082 - (156 + 26))) and v98.Sundering:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113)) then
			if (v22(v98.Sundering, not v15:IsInRange(3 + 2)) or ((3950 - 1425) > (4228 - (149 + 15)))) then
				return "sundering funnel 16";
			end
		end
		if (((5331 - (890 + 70)) == (4488 - (39 + 78))) and v98.FlameShock:IsReady() and v39 and v98.MoltenAssault:IsAvailable() and v15:DebuffDown(v98.FlameShockDebuff)) then
			if (v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock)) or ((748 - (14 + 468)) > (10964 - 5978))) then
				return "flame_shock funnel 17";
			end
		end
		if (((5564 - 3573) >= (478 + 447)) and v98.FlameShock:IsReady() and v39 and (v98.FireNova:IsAvailable() or v98.PrimordialWave:IsAvailable()) and (v98.FlameShockDebuff:AuraActiveCount() < v108) and (v98.FlameShockDebuff:AuraActiveCount() < (4 + 2))) then
			if (((97 + 358) < (928 + 1125)) and v114.CastCycle(v98.FlameShock, v107, v118, not v15:IsSpellInRange(v98.FlameShock))) then
				return "flame_shock funnel 18";
			end
		end
		if ((v98.FireNova:IsReady() and v38 and (v98.FlameShockDebuff:AuraActiveCount() >= (1 + 2))) or ((1580 - 754) == (4795 + 56))) then
			if (((642 - 459) == (5 + 178)) and v22(v98.FireNova)) then
				return "fire_nova funnel 19";
			end
		end
		if (((1210 - (12 + 39)) <= (1664 + 124)) and v98.Stormstrike:IsReady() and v46 and v14:BuffUp(v98.CrashLightningBuff) and v98.DeeplyRootedElements:IsAvailable()) then
			if (v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike)) or ((10855 - 7348) > (15378 - 11060))) then
				return "stormstrike funnel 20";
			end
		end
		if ((v98.CrashLightning:IsReady() and v36 and v98.CrashingStorms:IsAvailable() and v14:BuffUp(v98.CLCrashLightningBuff) and (v108 >= (2 + 2))) or ((1619 + 1456) <= (7518 - 4553))) then
			if (((910 + 455) <= (9718 - 7707)) and v22(v98.CrashLightning, not v15:IsInMeleeRange(1715 - (1596 + 114)))) then
				return "crash_lightning funnel 21";
			end
		end
		if ((v98.Windstrike:IsCastable() and v49) or ((7247 - 4471) > (4288 - (164 + 549)))) then
			if (v22(v98.Windstrike, not v15:IsSpellInRange(v98.Windstrike)) or ((3992 - (1059 + 379)) == (5964 - 1160))) then
				return "windstrike funnel 22";
			end
		end
		if (((1336 + 1241) == (435 + 2142)) and v98.Stormstrike:IsReady() and v46) then
			if (v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike)) or ((398 - (145 + 247)) >= (1550 + 339))) then
				return "stormstrike funnel 23";
			end
		end
		if (((234 + 272) <= (5608 - 3716)) and v98.IceStrike:IsReady() and v41) then
			if (v22(v98.IceStrike, not v15:IsInMeleeRange(1 + 4)) or ((1730 + 278) > (3601 - 1383))) then
				return "ice_strike funnel 24";
			end
		end
		if (((1099 - (254 + 466)) <= (4707 - (544 + 16))) and v98.LavaLash:IsReady() and v43) then
			if (v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash)) or ((14345 - 9831) <= (1637 - (294 + 334)))) then
				return "lava_lash funnel 25";
			end
		end
		if ((v98.CrashLightning:IsReady() and v36) or ((3749 - (236 + 17)) == (514 + 678))) then
			if (v22(v98.CrashLightning, not v15:IsInMeleeRange(4 + 1)) or ((783 - 575) == (14009 - 11050))) then
				return "crash_lightning funnel 26";
			end
		end
		if (((2203 + 2074) >= (1082 + 231)) and v98.FireNova:IsReady() and v38 and (v98.FlameShockDebuff:AuraActiveCount() >= (796 - (413 + 381)))) then
			if (((109 + 2478) < (6750 - 3576)) and v22(v98.FireNova)) then
				return "fire_nova funnel 27";
			end
		end
		if ((v98.ElementalBlast:IsReady() and v37 and (not v98.ElementalSpirits:IsAvailable() or (v98.ElementalSpirits:IsAvailable() and ((v98.ElementalBlast:Charges() == v110) or v14:BuffUp(v98.FeralSpiritBuff))))) or ((10702 - 6582) <= (4168 - (582 + 1388)))) then
			if (v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast)) or ((2718 - 1122) == (615 + 243))) then
				return "elemental_blast funnel 28";
			end
		end
		if (((3584 - (326 + 38)) == (9525 - 6305)) and v98.LavaBurst:IsReady() and v42 and ((v14:BuffStack(v98.MoltenWeaponBuff) + v23(v14:BuffUp(v98.VolcanicStrengthBuff))) > v14:BuffStack(v98.CracklingSurgeBuff)) and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (7 - 2))) then
			if (v22(v98.LavaBurst, not v15:IsSpellInRange(v98.LavaBurst)) or ((2022 - (47 + 573)) > (1277 + 2343))) then
				return "lava_burst funnel 29";
			end
		end
		if (((10931 - 8357) == (4177 - 1603)) and v98.LightningBolt:IsReady() and v44 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (1669 - (1269 + 395)))) then
			if (((2290 - (76 + 416)) < (3200 - (319 + 124))) and v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt))) then
				return "lightning_bolt funnel 30";
			end
		end
		if ((v98.WindfuryTotem:IsReady() and v48 and (v14:BuffDown(v98.WindfuryTotemBuff, true) or (v98.WindfuryTotem:TimeSinceLastCast() > (205 - 115)))) or ((1384 - (564 + 443)) > (7208 - 4604))) then
			if (((1026 - (337 + 121)) < (2669 - 1758)) and v22(v98.WindfuryTotem)) then
				return "windfury_totem funnel 31";
			end
		end
		if (((10942 - 7657) < (6139 - (1261 + 650))) and v98.FlameShock:IsReady() and v39 and (v15:DebuffDown(v98.FlameShockDebuff))) then
			if (((1657 + 2259) > (5303 - 1975)) and v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock))) then
				return "flame_shock funnel 32";
			end
		end
		if (((4317 - (772 + 1045)) < (542 + 3297)) and v98.FrostShock:IsReady() and v40 and not v98.Hailstorm:IsAvailable()) then
			if (((651 - (102 + 42)) == (2351 - (1524 + 320))) and v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock))) then
				return "frost_shock funnel 33";
			end
		end
	end
	local function v134()
		if (((1510 - (1049 + 221)) <= (3321 - (18 + 138))) and v72 and v98.EarthShield:IsCastable() and v14:BuffDown(v98.EarthShieldBuff) and ((v73 == "Earth Shield") or (v98.ElementalOrbit:IsAvailable() and v14:BuffUp(v98.LightningShield)))) then
			if (((2041 - 1207) >= (1907 - (67 + 1035))) and v22(v98.EarthShield)) then
				return "earth_shield main 2";
			end
		elseif ((v72 and v98.LightningShield:IsCastable() and v14:BuffDown(v98.LightningShieldBuff) and ((v73 == "Lightning Shield") or (v98.ElementalOrbit:IsAvailable() and v14:BuffUp(v98.EarthShield)))) or ((4160 - (136 + 212)) < (9841 - 7525))) then
			if (v22(v98.LightningShield) or ((2125 + 527) <= (1414 + 119))) then
				return "lightning_shield main 2";
			end
		end
		if (((not v102 or (v104 < (601604 - (240 + 1364)))) and v50 and v98.WindfuryWeapon:IsCastable()) or ((4680 - (1050 + 32)) < (5213 - 3753))) then
			if (v22(v98.WindfuryWeapon) or ((2435 + 1681) < (2247 - (331 + 724)))) then
				return "windfury_weapon enchant";
			end
		end
		if (((not v103 or (v105 < (48418 + 551582))) and v50 and v98.FlamentongueWeapon:IsCastable()) or ((4021 - (269 + 375)) <= (1628 - (267 + 458)))) then
			if (((1237 + 2739) >= (843 - 404)) and v22(v98.FlamentongueWeapon)) then
				return "flametongue_weapon enchant";
			end
		end
		if (((4570 - (667 + 151)) == (5249 - (1410 + 87))) and v82) then
			v28 = v127();
			if (((5943 - (1504 + 393)) > (7284 - 4589)) and v28) then
				return v28;
			end
		end
		if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) or ((9197 - 5652) == (3993 - (461 + 335)))) then
			if (((306 + 2088) > (2134 - (1730 + 31))) and v22(v98.AncestralSpirit, nil, true)) then
				return "resurrection";
			end
		end
		if (((5822 - (728 + 939)) <= (14988 - 10756)) and v114.TargetIsValid() and v29) then
			if (not v14:AffectingCombat() or ((7263 - 3682) == (7957 - 4484))) then
				local v219 = v130();
				if (((6063 - (138 + 930)) > (3060 + 288)) and v219) then
					return v219;
				end
			end
		end
	end
	local function v135()
		local v155 = 0 + 0;
		while true do
			if ((v155 == (4 + 0)) or ((3078 - 2324) > (5490 - (459 + 1307)))) then
				if (((2087 - (474 + 1396)) >= (98 - 41)) and v28) then
					return v28;
				end
				if (v114.TargetIsValid() or ((1940 + 130) >= (14 + 4023))) then
					local v221 = 0 - 0;
					local v222;
					while true do
						if (((343 + 2362) == (9030 - 6325)) and (v221 == (0 - 0))) then
							v222 = v114.HandleDPSPotion(v14:BuffUp(v98.FeralSpiritBuff));
							if (((652 - (562 + 29)) == (53 + 8)) and v222) then
								return v222;
							end
							if ((v96 < v113) or ((2118 - (374 + 1045)) >= (1026 + 270))) then
								if ((v54 and ((v31 and v61) or not v61)) or ((5536 - 3753) >= (4254 - (448 + 190)))) then
									local v241 = 0 + 0;
									while true do
										if (((0 + 0) == v241) or ((2550 + 1363) > (17405 - 12878))) then
											v28 = v129();
											if (((13597 - 9221) > (2311 - (1307 + 187))) and v28) then
												return v28;
											end
											break;
										end
									end
								end
							end
							if (((19276 - 14415) > (1928 - 1104)) and (v96 < v113) and v55 and ((v62 and v31) or not v62)) then
								if ((v98.BloodFury:IsCastable() and (not v98.Ascendance:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98.Ascendance:CooldownRemains() > (153 - 103)))) or ((2066 - (232 + 451)) >= (2035 + 96))) then
									if (v22(v98.BloodFury) or ((1658 + 218) >= (3105 - (510 + 54)))) then
										return "blood_fury racial";
									end
								end
								if (((3590 - 1808) <= (3808 - (13 + 23))) and v98.Berserking:IsCastable() and (not v98.Ascendance:IsAvailable() or v14:BuffUp(v98.AscendanceBuff))) then
									if (v22(v98.Berserking) or ((9161 - 4461) < (1167 - 354))) then
										return "berserking racial";
									end
								end
								if (((5811 - 2612) < (5138 - (830 + 258))) and v98.Fireblood:IsCastable() and (not v98.Ascendance:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98.Ascendance:CooldownRemains() > (176 - 126)))) then
									if (v22(v98.Fireblood) or ((3098 + 1853) < (3770 + 660))) then
										return "fireblood racial";
									end
								end
								if (((1537 - (860 + 581)) == (354 - 258)) and v98.AncestralCall:IsCastable() and (not v98.Ascendance:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98.Ascendance:CooldownRemains() > (40 + 10)))) then
									if (v22(v98.AncestralCall) or ((2980 - (237 + 4)) > (9419 - 5411))) then
										return "ancestral_call racial";
									end
								end
							end
							v221 = 2 - 1;
						end
						if ((v221 == (3 - 1)) or ((19 + 4) == (652 + 482))) then
							if ((v98.DoomWinds:IsCastable() and v53 and ((v58 and v31) or not v58) and (v96 < v113)) or ((10167 - 7474) >= (1765 + 2346))) then
								if (v22(v98.DoomWinds, not v15:IsInMeleeRange(3 + 2)) or ((5742 - (85 + 1341)) <= (3661 - 1515))) then
									return "doom_winds main 5";
								end
							end
							if ((v108 == (2 - 1)) or ((3918 - (45 + 327)) <= (5300 - 2491))) then
								local v233 = 502 - (444 + 58);
								local v234;
								while true do
									if (((2132 + 2772) > (373 + 1793)) and (v233 == (0 + 0))) then
										v234 = v131();
										if (((315 - 206) >= (1822 - (64 + 1668))) and v234) then
											return v234;
										end
										break;
									end
								end
							end
							if (((6951 - (1227 + 746)) > (8929 - 6024)) and v30 and (v108 > (1 - 0))) then
								local v235 = 494 - (415 + 79);
								local v236;
								while true do
									if ((v235 == (0 + 0)) or ((3517 - (142 + 349)) <= (977 + 1303))) then
										v236 = v132();
										if (v236 or ((2271 - 618) <= (551 + 557))) then
											return v236;
										end
										break;
									end
								end
							end
							if (((2050 + 859) > (7104 - 4495)) and v19.CastAnnotated(v98.Pool, false, "WAIT")) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((2621 - (1710 + 154)) > (512 - (200 + 118))) and (v221 == (1 + 0))) then
							if ((v98.Windstrike:IsCastable() and v49) or ((53 - 22) >= (2073 - 675))) then
								if (((2840 + 356) <= (4820 + 52)) and v22(v98.Windstrike, not v15:IsSpellInRange(v98.Windstrike))) then
									return "windstrike main 1";
								end
							end
							if (((1785 + 1541) == (532 + 2794)) and v98.PrimordialWave:IsCastable() and v45 and ((v60 and v32) or not v60) and (v96 < v113) and (v14:HasTier(67 - 36, 1252 - (363 + 887)))) then
								if (((2502 - 1069) <= (18458 - 14580)) and v22(v98.PrimordialWave, not v15:IsSpellInRange(v98.PrimordialWave))) then
									return "primordial_wave main 2";
								end
							end
							if ((v98.FeralSpirit:IsCastable() and v52 and ((v57 and v31) or not v57) and (v96 < v113)) or ((245 + 1338) == (4059 - 2324))) then
								if (v22(v98.FeralSpirit) or ((2037 + 944) == (4014 - (674 + 990)))) then
									return "feral_spirit main 3";
								end
							end
							if ((v98.Ascendance:IsCastable() and v51 and ((v56 and v31) or not v56) and (v96 < v113) and v15:DebuffUp(v98.FlameShockDebuff) and (((v111 == "Lightning Bolt") and (v108 == (1 + 0))) or ((v111 == "Chain Lightning") and (v108 > (1 + 0))))) or ((7078 - 2612) <= (1548 - (507 + 548)))) then
								if (v22(v98.Ascendance) or ((3384 - (289 + 548)) <= (3805 - (821 + 997)))) then
									return "ascendance main 4";
								end
							end
							v221 = 257 - (195 + 60);
						end
					end
				end
				break;
			end
			if (((797 + 2164) > (4241 - (251 + 1250))) and (v155 == (2 - 1))) then
				if (((2540 + 1156) >= (4644 - (809 + 223))) and v90) then
					local v223 = 0 - 0;
					while true do
						if ((v223 == (0 - 0)) or ((9820 - 6850) == (1384 + 494))) then
							if (v84 or ((1934 + 1759) < (2594 - (14 + 603)))) then
								local v237 = 129 - (118 + 11);
								while true do
									if ((v237 == (0 + 0)) or ((775 + 155) > (6122 - 4021))) then
										v28 = v114.HandleAfflicted(v98.CleanseSpirit, v100.CleanseSpiritMouseover, 989 - (551 + 398));
										if (((2625 + 1528) > (1099 + 1987)) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							if (v85 or ((3783 + 871) <= (15062 - 11012))) then
								local v238 = 0 - 0;
								while true do
									if (((0 + 0) == v238) or ((10329 - 7727) < (414 + 1082))) then
										v28 = v114.HandleAfflicted(v98.TremorTotem, v98.TremorTotem, 119 - (40 + 49));
										if (v28 or ((3884 - 2864) > (2778 - (99 + 391)))) then
											return v28;
										end
										break;
									end
								end
							end
							v223 = 1 + 0;
						end
						if (((1441 - 1113) == (812 - 484)) and (v223 == (1 + 0))) then
							if (((3975 - 2464) < (5412 - (1032 + 572))) and v86) then
								local v239 = 417 - (203 + 214);
								while true do
									if (((1817 - (568 + 1249)) == v239) or ((1964 + 546) > (11814 - 6895))) then
										v28 = v114.HandleAfflicted(v98.PoisonCleansingTotem, v98.PoisonCleansingTotem, 115 - 85);
										if (((6069 - (913 + 393)) == (13450 - 8687)) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							if (((5845 - 1708) > (2258 - (269 + 141))) and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (11 - 6)) and v87) then
								local v240 = 1981 - (362 + 1619);
								while true do
									if (((4061 - (950 + 675)) <= (1209 + 1925)) and (v240 == (1179 - (216 + 963)))) then
										v28 = v114.HandleAfflicted(v98.HealingSurge, v100.HealingSurgeMouseover, 1327 - (485 + 802), true);
										if (((4282 - (432 + 127)) == (4796 - (1065 + 8))) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (v91 or ((2248 + 1798) >= (5917 - (635 + 966)))) then
					local v224 = 0 + 0;
					while true do
						if ((v224 == (42 - (5 + 37))) or ((4993 - 2985) < (803 + 1126))) then
							v28 = v114.HandleIncorporeal(v98.Hex, v100.HexMouseOver, 47 - 17, true);
							if (((1116 + 1268) > (3688 - 1913)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				v155 = 7 - 5;
			end
			if ((v155 == (0 - 0)) or ((10861 - 6318) <= (3147 + 1229))) then
				v28 = v128();
				if (((1257 - (318 + 211)) == (3582 - 2854)) and v28) then
					return v28;
				end
				v155 = 1588 - (963 + 624);
			end
			if ((v155 == (2 + 1)) or ((1922 - (518 + 328)) > (10888 - 6217))) then
				if (((2958 - 1107) >= (695 - (301 + 16))) and v98.Purge:IsReady() and v97 and v33 and v88 and not v14:IsCasting() and not v14:IsChanneling() and v114.UnitHasMagicBuff(v15)) then
					if (v22(v98.Purge, not v15:IsSpellInRange(v98.Purge)) or ((5709 - 3761) >= (9762 - 6286))) then
						return "purge damage";
					end
				end
				v28 = v126();
				v155 = 10 - 6;
			end
			if (((4343 + 451) >= (473 + 360)) and (v155 == (3 - 1))) then
				if (((2461 + 1629) == (390 + 3700)) and Focus) then
					if (v89 or ((11947 - 8189) == (807 + 1691))) then
						local v228 = 1019 - (829 + 190);
						while true do
							if ((v228 == (0 - 0)) or ((3381 - 708) < (2176 - 601))) then
								v28 = v125();
								if (v28 or ((9243 - 5522) <= (345 + 1110))) then
									return v28;
								end
								break;
							end
						end
					end
				end
				if (((306 + 628) < (6890 - 4620)) and v98.GreaterPurge:IsAvailable() and v97 and v98.GreaterPurge:IsReady() and v33 and v88 and not v14:IsCasting() and not v14:IsChanneling() and v114.UnitHasMagicBuff(v15)) then
					if (v22(v98.GreaterPurge, not v15:IsSpellInRange(v98.GreaterPurge)) or ((1522 + 90) == (1868 - (520 + 93)))) then
						return "greater_purge damage";
					end
				end
				v155 = 279 - (259 + 17);
			end
		end
	end
	local function v136()
		v51 = EpicSettings.Settings['useAscendance'];
		v53 = EpicSettings.Settings['useDoomWinds'];
		v52 = EpicSettings.Settings['useFeralSpirit'];
		v35 = EpicSettings.Settings['useChainlightning'];
		v36 = EpicSettings.Settings['useCrashLightning'];
		v37 = EpicSettings.Settings['useElementalBlast'];
		v38 = EpicSettings.Settings['useFireNova'];
		v39 = EpicSettings.Settings['useFlameShock'];
		v40 = EpicSettings.Settings['useFrostShock'];
		v41 = EpicSettings.Settings['useIceStrike'];
		v42 = EpicSettings.Settings['useLavaBurst'];
		v43 = EpicSettings.Settings['useLavaLash'];
		v44 = EpicSettings.Settings['useLightningBolt'];
		v45 = EpicSettings.Settings['usePrimordialWave'];
		v46 = EpicSettings.Settings['useStormStrike'];
		v47 = EpicSettings.Settings['useSundering'];
		v49 = EpicSettings.Settings['useWindstrike'];
		v48 = EpicSettings.Settings['useWindfuryTotem'];
		v50 = EpicSettings.Settings['useWeaponEnchant'];
		v56 = EpicSettings.Settings['ascendanceWithCD'];
		v58 = EpicSettings.Settings['doomWindsWithCD'];
		v57 = EpicSettings.Settings['feralSpiritWithCD'];
		v60 = EpicSettings.Settings['primordialWaveWithMiniCD'];
		v59 = EpicSettings.Settings['sunderingWithMiniCD'];
	end
	local function v137()
		v63 = EpicSettings.Settings['useWindShear'];
		v34 = EpicSettings.Settings['useCapacitorTotem'];
		v64 = EpicSettings.Settings['useThunderstorm'];
		v67 = EpicSettings.Settings['useAncestralGuidance'];
		v66 = EpicSettings.Settings['useAstralShift'];
		v69 = EpicSettings.Settings['useMaelstromHealingSurge'];
		v68 = EpicSettings.Settings['useHealingStreamTotem'];
		v75 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 + 0);
		v76 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
		v74 = EpicSettings.Settings['astralShiftHP'] or (0 - 0);
		v77 = EpicSettings.Settings['healingStreamTotemHP'] or (591 - (396 + 195));
		v78 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 - 0);
		v79 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (1761 - (440 + 1321));
		v72 = EpicSettings.Settings['autoShield'];
		v73 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
		v82 = EpicSettings.Settings['healOOC'];
		v83 = EpicSettings.Settings['healOOCHP'] or (1829 - (1059 + 770));
		v97 = EpicSettings.Settings['usePurgeTarget'];
		v84 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
		v85 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v86 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
		v87 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
	end
	local function v138()
		local v194 = 0 - 0;
		while true do
			if ((v194 == (546 - (424 + 121))) or ((794 + 3558) < (5553 - (641 + 706)))) then
				v95 = EpicSettings.Settings['InterruptThreshold'];
				v89 = EpicSettings.Settings['DispelDebuffs'];
				v88 = EpicSettings.Settings['DispelBuffs'];
				v194 = 1 + 1;
			end
			if ((v194 == (440 - (249 + 191))) or ((12459 - 9599) <= (81 + 100))) then
				v96 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v93 = EpicSettings.Settings['InterruptWithStun'];
				v94 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v194 = 428 - (183 + 244);
			end
			if (((159 + 3063) >= (2257 - (434 + 296))) and (v194 == (15 - 10))) then
				v90 = EpicSettings.Settings['handleAfflicted'];
				v91 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((2017 - (169 + 343)) <= (1860 + 261)) and (v194 == (3 - 1))) then
				v54 = EpicSettings.Settings['useTrinkets'];
				v55 = EpicSettings.Settings['useRacials'];
				v61 = EpicSettings.Settings['trinketsWithCD'];
				v194 = 8 - 5;
			end
			if (((610 + 134) == (2109 - 1365)) and (v194 == (1126 - (651 + 472)))) then
				v62 = EpicSettings.Settings['racialsWithCD'];
				v70 = EpicSettings.Settings['useHealthstone'];
				v71 = EpicSettings.Settings['useHealingPotion'];
				v194 = 4 + 0;
			end
			if ((v194 == (2 + 2)) or ((2414 - 435) >= (3319 - (397 + 86)))) then
				v80 = EpicSettings.Settings['healthstoneHP'] or (876 - (423 + 453));
				v81 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v92 = EpicSettings.Settings['HealingPotionName'] or "";
				v194 = 1 + 4;
			end
		end
	end
	local function v139()
		local v195 = 0 + 0;
		while true do
			if (((1463 + 370) <= (2384 + 284)) and ((1192 - (50 + 1140)) == v195)) then
				v33 = EpicSettings.Toggles['dispel'];
				v32 = EpicSettings.Toggles['minicds'];
				if (((3187 + 499) == (2177 + 1509)) and v14:IsDeadOrGhost()) then
					return;
				end
				v195 = 1 + 2;
			end
			if (((4978 - 1511) > (346 + 131)) and (v195 == (596 - (157 + 439)))) then
				v137();
				v136();
				v138();
				v195 = 1 - 0;
			end
			if ((v195 == (16 - 11)) or ((9725 - 6437) >= (4459 - (782 + 136)))) then
				if (v14:AffectingCombat() or ((4412 - (112 + 743)) == (5711 - (1026 + 145)))) then
					if (v14:PrevGCD(1 + 0, v98.ChainLightning) or ((979 - (493 + 225)) > (4656 - 3389))) then
						v111 = "Chain Lightning";
					elseif (((774 + 498) < (10343 - 6485)) and v14:PrevGCD(1 + 0, v98.LightningBolt)) then
						v111 = "Lightning Bolt";
					end
				end
				if (((10471 - 6807) == (1067 + 2597)) and not v14:IsChanneling() and not v14:IsChanneling()) then
					if (((3242 - 1301) >= (2045 - (210 + 1385))) and Focus) then
						if (v89 or ((6335 - (1201 + 488)) < (201 + 123))) then
							local v230 = 0 - 0;
							while true do
								if (((6874 - 3041) == (4418 - (352 + 233))) and (v230 == (0 - 0))) then
									v28 = v125();
									if (v28 or ((675 + 565) > (9581 - 6211))) then
										return v28;
									end
									break;
								end
							end
						end
					end
					if (v90 or ((3055 - (489 + 85)) == (6183 - (277 + 1224)))) then
						if (((6220 - (663 + 830)) >= (183 + 25)) and v84) then
							v28 = v114.HandleAfflicted(v98.CleanseSpirit, v100.CleanseSpiritMouseover, 97 - 57);
							if (((1155 - (461 + 414)) < (646 + 3205)) and v28) then
								return v28;
							end
						end
						if (v85 or ((1204 + 1803) > (305 + 2889))) then
							local v231 = 0 + 0;
							while true do
								if ((v231 == (250 - (172 + 78))) or ((3443 - 1307) >= (1085 + 1861))) then
									v28 = v114.HandleAfflicted(v98.TremorTotem, v98.TremorTotem, 43 - 13);
									if (((591 + 1574) <= (843 + 1678)) and v28) then
										return v28;
									end
									break;
								end
							end
						end
						if (((4793 - 1932) > (831 - 170)) and v86) then
							local v232 = 0 + 0;
							while true do
								if (((2503 + 2022) > (1609 + 2910)) and (v232 == (0 - 0))) then
									v28 = v114.HandleAfflicted(v98.PoisonCleansingTotem, v98.PoisonCleansingTotem, 69 - 39);
									if (((975 + 2203) > (555 + 417)) and v28) then
										return v28;
									end
									break;
								end
							end
						end
						if (((5213 - (133 + 314)) == (829 + 3937)) and (v14:BuffStack(v98.MaelstromWeaponBuff) >= (218 - (199 + 14))) and v87) then
							v28 = v114.HandleAfflicted(v98.HealingSurge, v100.HealingSurgeMouseover, 143 - 103, true);
							if (v28 or ((4294 - (647 + 902)) > (9405 - 6277))) then
								return v28;
							end
						end
					end
					if (v14:AffectingCombat() or ((1377 - (85 + 148)) >= (5895 - (426 + 863)))) then
						local v229 = 0 - 0;
						while true do
							if (((4992 - (873 + 781)) >= (370 - 93)) and (v229 == (0 - 0))) then
								v28 = v135();
								if (((1082 + 1528) > (9457 - 6897)) and v28) then
									return v28;
								end
								break;
							end
						end
					else
						v28 = v134();
						if (v28 or ((1711 - 517) > (9154 - 6071))) then
							return v28;
						end
					end
				end
				break;
			end
			if (((2863 - (414 + 1533)) >= (648 + 99)) and (v195 == (558 - (443 + 112)))) then
				v102, v104, _, _, v103, v105 = v25();
				v106 = v14:GetEnemiesInRange(1519 - (888 + 591));
				v107 = v14:GetEnemiesInMeleeRange(12 - 7);
				v195 = 1 + 3;
			end
			if ((v195 == (14 - 10)) or ((955 + 1489) > (1429 + 1525))) then
				if (((310 + 2582) < (6695 - 3181)) and v30) then
					local v225 = 0 - 0;
					while true do
						if (((2211 - (136 + 1542)) == (1747 - 1214)) and (v225 == (0 + 0))) then
							v109 = #v106;
							v108 = #v107;
							break;
						end
					end
				else
					v109 = 1 - 0;
					v108 = 1 + 0;
				end
				if (((1081 - (68 + 418)) <= (9252 - 5839)) and (v14:AffectingCombat() or v89)) then
					local v226 = 0 - 0;
					local v227;
					while true do
						if (((2658 + 420) >= (3683 - (770 + 322))) and (v226 == (0 + 0))) then
							v227 = v89 and v98.CleanseSpirit:IsReady() and v33;
							v28 = v114.FocusUnit(v227, v100, 6 + 14, nil, 4 + 21);
							v226 = 1 - 0;
						end
						if (((6202 - 3003) < (10976 - 6946)) and (v226 == (3 - 2))) then
							if (((433 + 344) < (3113 - 1035)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (((814 + 882) <= (1399 + 883)) and (v114.TargetIsValid() or v14:AffectingCombat())) then
					v112 = v10.BossFightRemains(nil, true);
					v113 = v112;
					if ((v113 == (8707 + 2404)) or ((6631 - 4870) >= (3419 - 957))) then
						v113 = v10.FightRemains(v107, false);
					end
				end
				v195 = 2 + 3;
			end
			if (((20964 - 16413) > (7695 - 5367)) and (v195 == (1 + 0))) then
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v195 = 9 - 7;
			end
		end
	end
	local function v140()
		local v196 = 831 - (762 + 69);
		while true do
			if (((12385 - 8560) >= (403 + 64)) and (v196 == (1 + 0))) then
				v19.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
				break;
			end
			if (((0 - 0) == v196) or ((910 + 1980) == (9 + 548))) then
				v98.FlameShockDebuff:RegisterAuraTracking();
				v115();
				v196 = 3 - 2;
			end
		end
	end
	v19.SetAPL(420 - (8 + 149), v139, v140);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

