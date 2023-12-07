local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((103 + 767) >= (3710 - (463 + 171)))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Shaman_Elemental.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Player;
	local v14 = v11.MouseOver;
	local v15 = v11.Pet;
	local v16 = v11.Target;
	local v17 = v9.Spell;
	local v18 = v9.MultiSpell;
	local v19 = v9.Item;
	local v20 = EpicLib;
	local v21 = v20.Cast;
	local v22 = v20.Macro;
	local v23 = v20.Press;
	local v24 = v20.Commons.Everyone.num;
	local v25 = v20.Commons.Everyone.bool;
	local v26 = GetTimelocal;
	local v27 = GetWeaponEnchantInfo;
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
	local v97 = v17.Shaman.Elemental;
	local v98 = v19.Shaman.Elemental;
	local v99 = v22.Shaman.Elemental;
	local v100 = {};
	local v101 = v20.Commons.Everyone;
	local function v102()
		if (((580 + 1049) > (4630 - 3428)) and v97.CleanseSpirit:IsAvailable()) then
			v101.DispellableDebuffs = v101.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v102();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v9:RegisterForEvent(function()
		local v136 = 0 - 0;
		while true do
			if (((761 + 247) < (9490 - 5779)) and (v136 == (689 - (364 + 324)))) then
				v97.LavaBurst:RegisterInFlight();
				break;
			end
			if ((v136 == (0 - 0)) or ((2516 - 1467) <= (301 + 605))) then
				v97.PrimordialWave:RegisterInFlightEffect(1368953 - 1041791);
				v97.PrimordialWave:RegisterInFlight();
				v136 = 1 - 0;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v97.PrimordialWave:RegisterInFlightEffect(993630 - 666468);
	v97.PrimordialWave:RegisterInFlight();
	v97.LavaBurst:RegisterInFlight();
	local v103 = 12379 - (1249 + 19);
	local v104 = 10030 + 1081;
	local v105, v106;
	local v107, v108;
	local v109 = 0 - 0;
	local v110 = 1086 - (686 + 400);
	local function v111()
		return (32 + 8) - (v26() - Shaman.LastT302pcBuff);
	end
	local function v112(v137)
		return (v137:DebuffRefreshable(v97.FlameShockDebuff));
	end
	local function v113(v138)
		return v138:DebuffRefreshable(v97.FlameShockDebuff) and (v138:DebuffRemains(v97.FlameShockDebuff) < (v138:TimeToDie() - (234 - (73 + 156))));
	end
	local function v114(v139)
		return v139:DebuffRefreshable(v97.FlameShockDebuff) and (v139:DebuffRemains(v97.FlameShockDebuff) < (v139:TimeToDie() - (1 + 4))) and (v139:DebuffRemains(v97.FlameShockDebuff) > (811 - (721 + 90)));
	end
	local function v115(v140)
		return (v140:DebuffRemains(v97.FlameShockDebuff));
	end
	local function v116(v141)
		return v141:DebuffRemains(v97.FlameShockDebuff) > (1 + 1);
	end
	local function v117(v142)
		return (v142:DebuffRemains(v97.LightningRodDebuff));
	end
	local function v118()
		local v143 = v13:Maelstrom();
		if (((14653 - 10140) > (3196 - (224 + 246))) and not v13:IsCasting()) then
			return v143;
		elseif (v13:IsCasting(v97.ElementalBlast) or ((2399 - 918) >= (4893 - 2235))) then
			return v143 - (14 + 61);
		elseif (v13:IsCasting(v97.Icefury) or ((77 + 3143) == (1002 + 362))) then
			return v143 + (49 - 24);
		elseif (v13:IsCasting(v97.LightningBolt) or ((3507 - 2453) > (3905 - (203 + 310)))) then
			return v143 + (2003 - (1238 + 755));
		elseif (v13:IsCasting(v97.LavaBurst) or ((48 + 628) >= (3176 - (709 + 825)))) then
			return v143 + (21 - 9);
		elseif (((6024 - 1888) > (3261 - (196 + 668))) and v13:IsCasting(v97.ChainLightning)) then
			return v143 + ((15 - 11) * v110);
		else
			return v143;
		end
	end
	local function v119()
		if (not v97.MasteroftheElements:IsAvailable() or ((8977 - 4643) == (5078 - (171 + 662)))) then
			return false;
		end
		local v144 = v13:BuffUp(v97.MasteroftheElementsBuff);
		if (not v13:IsCasting() or ((4369 - (4 + 89)) <= (10623 - 7592))) then
			return v144;
		elseif (v13:IsCasting(v97.LavaBurst) or ((1742 + 3040) <= (5266 - 4067))) then
			return true;
		elseif (v13:IsCasting(v97.ElementalBlast) or ((1908 + 2956) < (3388 - (35 + 1451)))) then
			return false;
		elseif (((6292 - (28 + 1425)) >= (5693 - (941 + 1052))) and v13:IsCasting(v97.Icefury)) then
			return false;
		elseif (v13:IsCasting(v97.LightningBolt) or ((1031 + 44) > (3432 - (822 + 692)))) then
			return false;
		elseif (((564 - 168) <= (1792 + 2012)) and v13:IsCasting(v97.ChainLightning)) then
			return false;
		else
			return v144;
		end
	end
	local function v120()
		local v145 = 297 - (45 + 252);
		local v146;
		while true do
			if ((v145 == (1 + 0)) or ((1435 + 2734) == (5322 - 3135))) then
				if (((1839 - (114 + 319)) == (2017 - 611)) and not v13:IsCasting()) then
					return v146;
				elseif (((1961 - 430) < (2723 + 1548)) and v13:IsCasting(v97.Stormkeeper)) then
					return true;
				else
					return v146;
				end
				break;
			end
			if (((946 - 311) == (1330 - 695)) and (v145 == (1963 - (556 + 1407)))) then
				if (((4579 - (741 + 465)) <= (4021 - (170 + 295))) and not v97.Stormkeeper:IsAvailable()) then
					return false;
				end
				v146 = v13:BuffUp(v97.StormkeeperBuff);
				v145 = 1 + 0;
			end
		end
	end
	local function v121()
		if (not v97.Icefury:IsAvailable() or ((3023 + 268) < (8075 - 4795))) then
			return false;
		end
		local v147 = v13:BuffUp(v97.IcefuryBuff);
		if (((3636 + 750) >= (560 + 313)) and not v13:IsCasting()) then
			return v147;
		elseif (((522 + 399) <= (2332 - (957 + 273))) and v13:IsCasting(v97.Icefury)) then
			return true;
		else
			return v147;
		end
	end
	local function v122()
		if (((1259 + 3447) >= (386 + 577)) and v97.CleanseSpirit:IsReady() and v33 and v101.DispellableFriendlyUnit(95 - 70)) then
			if (v23(v99.CleanseSpiritFocus) or ((2529 - 1569) <= (2675 - 1799))) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v123()
		if ((v95 and (v13:HealthPercentage() <= v96)) or ((10230 - 8164) == (2712 - (389 + 1391)))) then
			if (((3028 + 1797) < (505 + 4338)) and v97.HealingSurge:IsReady()) then
				if (v23(v97.HealingSurge) or ((8826 - 4949) >= (5488 - (783 + 168)))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v124()
		local v148 = 0 - 0;
		while true do
			if ((v148 == (1 + 0)) or ((4626 - (309 + 2)) < (5300 - 3574))) then
				if ((v97.HealingStreamTotem:IsReady() and v70 and v101.AreUnitsBelowHealthPercentage(v76, v77)) or ((4891 - (1090 + 122)) < (203 + 422))) then
					if (v23(v97.HealingStreamTotem) or ((15532 - 10907) < (433 + 199))) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v98.Healthstone:IsReady() and v90 and (v13:HealthPercentage() <= v92)) or ((1201 - (628 + 490)) > (320 + 1460))) then
					if (((1351 - 805) <= (4921 - 3844)) and v23(v99.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				v148 = 776 - (431 + 343);
			end
			if ((v148 == (3 - 1)) or ((2881 - 1885) > (3398 + 903))) then
				if (((521 + 3549) > (2382 - (556 + 1139))) and v89 and (v13:HealthPercentage() <= v91)) then
					local v212 = 15 - (6 + 9);
					while true do
						if ((v212 == (0 + 0)) or ((337 + 319) >= (3499 - (28 + 141)))) then
							if ((v93 == "Refreshing Healing Potion") or ((966 + 1526) <= (413 - 78))) then
								if (((3062 + 1260) >= (3879 - (486 + 831))) and v98.RefreshingHealingPotion:IsReady()) then
									if (v23(v99.RefreshingHealingPotion) or ((9464 - 5827) >= (13272 - 9502))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v93 == "Dreamwalker's Healing Potion") or ((450 + 1929) > (14475 - 9897))) then
								if (v98.DreamwalkersHealingPotion:IsReady() or ((1746 - (668 + 595)) > (669 + 74))) then
									if (((495 + 1959) > (1576 - 998)) and v23(v99.RefreshingHealingPotion)) then
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
			if (((1220 - (23 + 267)) < (6402 - (1129 + 815))) and (v148 == (387 - (371 + 16)))) then
				if (((2412 - (1326 + 424)) <= (1840 - 868)) and v97.AstralShift:IsReady() and v69 and (v13:HealthPercentage() <= v75)) then
					if (((15969 - 11599) == (4488 - (88 + 30))) and v23(v97.AstralShift)) then
						return "astral_shift defensive 1";
					end
				end
				if ((v97.AncestralGuidance:IsReady() and v68 and v101.AreUnitsBelowHealthPercentage(v73, v74)) or ((5533 - (720 + 51)) <= (1915 - 1054))) then
					if (v23(v97.AncestralGuidance) or ((3188 - (421 + 1355)) == (7034 - 2770))) then
						return "ancestral_guidance defensive 2";
					end
				end
				v148 = 1 + 0;
			end
		end
	end
	local function v125()
		local v149 = 1083 - (286 + 797);
		while true do
			if ((v149 == (0 - 0)) or ((5247 - 2079) < (2592 - (397 + 42)))) then
				v28 = v101.HandleTopTrinket(v100, v31, 13 + 27, nil);
				if (v28 or ((5776 - (24 + 776)) < (2051 - 719))) then
					return v28;
				end
				v149 = 786 - (222 + 563);
			end
			if (((10196 - 5568) == (3333 + 1295)) and (v149 == (191 - (23 + 167)))) then
				v28 = v101.HandleBottomTrinket(v100, v31, 1838 - (690 + 1108), nil);
				if (v28 or ((20 + 34) == (326 + 69))) then
					return v28;
				end
				break;
			end
		end
	end
	local function v126()
		if (((930 - (40 + 808)) == (14 + 68)) and v97.Stormkeeper:IsCastable() and (v97.Stormkeeper:CooldownRemains() == (0 - 0)) and not v13:BuffUp(v97.StormkeeperBuff) and v46 and ((v63 and v32) or not v63) and (v88 < v104)) then
			if (v23(v97.Stormkeeper) or ((556 + 25) < (150 + 132))) then
				return "stormkeeper precombat 2";
			end
		end
		if ((v97.Icefury:IsCastable() and (v97.Icefury:CooldownRemains() == (0 + 0)) and v40) or ((5180 - (47 + 524)) < (1620 + 875))) then
			if (((3148 - 1996) == (1721 - 569)) and v23(v97.Icefury, not v16:IsSpellInRange(v97.Icefury))) then
				return "icefury precombat 4";
			end
		end
		if (((4323 - 2427) <= (5148 - (1165 + 561))) and v97.ElementalBlast:IsCastable() and v37) then
			if (v23(v97.ElementalBlast, not v16:IsSpellInRange(v97.ElementalBlast)) or ((30 + 960) > (5017 - 3397))) then
				return "elemental_blast precombat 6";
			end
		end
		if ((v13:IsCasting(v97.ElementalBlast) and v45 and ((v62 and v32) or not v62) and v97.PrimordialWave:IsAvailable()) or ((335 + 542) > (5174 - (341 + 138)))) then
			if (((727 + 1964) >= (3819 - 1968)) and v23(v97.PrimordialWave, not v16:IsSpellInRange(v97.PrimordialWave))) then
				return "primordial_wave precombat 8";
			end
		end
		if ((v13:IsCasting(v97.ElementalBlast) and UseFlameShock and not v97.PrimordialWave:IsAvailable() and v97.FlameShock:IsReady()) or ((3311 - (89 + 237)) >= (15621 - 10765))) then
			if (((9002 - 4726) >= (2076 - (581 + 300))) and v23(v97.FlameShock, not v16:IsSpellInRange(v97.FlameShock))) then
				return "flameshock precombat 10";
			end
		end
		if (((4452 - (855 + 365)) <= (11139 - 6449)) and v97.LavaBurst:IsCastable() and v42 and not v13:IsCasting(v97.LavaBurst) and (not v97.ElementalBlast:IsAvailable() or (v97.ElementalBlast:IsAvailable() and not v97.ElementalBlast:IsAvailable()))) then
			if (v23(v97.LavaBurst, not v16:IsSpellInRange(v97.LavaBurst)) or ((293 + 603) >= (4381 - (1030 + 205)))) then
				return "lavaburst precombat 12";
			end
		end
		if (((2874 + 187) >= (2752 + 206)) and v13:IsCasting(v97.LavaBurst) and UseFlameShock and v97.FlameShock:IsReady()) then
			if (((3473 - (156 + 130)) >= (1462 - 818)) and v23(v97.FlameShock, not v16:IsSpellInRange(v97.FlameShock))) then
				return "flameshock precombat 14";
			end
		end
		if (((1084 - 440) <= (1441 - 737)) and v13:IsCasting(v97.LavaBurst) and v45 and ((v62 and v32) or not v62) and v97.PrimordialWave:IsAvailable()) then
			if (((253 + 705) > (553 + 394)) and v23(v97.PrimordialWave, not v16:IsSpellInRange(v97.PrimordialWave))) then
				return "primordial_wave precombat 16";
			end
		end
	end
	local function v127()
		local v150 = 69 - (10 + 59);
		while true do
			if (((1271 + 3221) >= (13070 - 10416)) and (v150 == (1166 - (671 + 492)))) then
				if (((2741 + 701) >= (2718 - (369 + 846))) and v97.ElementalBlast:IsAvailable() and v37 and (v97.EchoesofGreatSundering:IsAvailable())) then
					if (v101.CastTargetIf(v97.ElementalBlast, v108, "min", v117, nil, not v16:IsSpellInRange(v97.ElementalBlast)) or ((840 + 2330) <= (1250 + 214))) then
						return "elemental_blast aoe 42";
					end
				end
				if ((v97.ElementalBlast:IsAvailable() and v37 and (v97.EchoesofGreatSundering:IsAvailable())) or ((6742 - (1036 + 909)) == (3489 + 899))) then
					if (((924 - 373) <= (884 - (11 + 192))) and v23(v97.ElementalBlast, not v16:IsSpellInRange(v97.ElementalBlast))) then
						return "elemental_blast aoe 44";
					end
				end
				if (((1657 + 1620) > (582 - (135 + 40))) and v97.ElementalBlast:IsAvailable() and v37 and (v109 == (6 - 3)) and not v97.EchoesofGreatSundering:IsAvailable()) then
					if (((2830 + 1865) >= (3117 - 1702)) and v23(v97.ElementalBlast, not v16:IsSpellInRange(v97.ElementalBlast))) then
						return "elemental_blast aoe 46";
					end
				end
				if ((v97.EarthShock:IsReady() and v36 and (v97.EchoesofGreatSundering:IsAvailable())) or ((4814 - 1602) <= (1120 - (50 + 126)))) then
					if (v101.CastTargetIf(v97.EarthShock, v108, "min", v117, nil, not v16:IsSpellInRange(v97.EarthShock)) or ((8620 - 5524) <= (398 + 1400))) then
						return "earth_shock aoe 48";
					end
				end
				if (((4950 - (1233 + 180)) == (4506 - (522 + 447))) and v97.EarthShock:IsReady() and v36 and (v97.EchoesofGreatSundering:IsAvailable())) then
					if (((5258 - (107 + 1314)) >= (729 + 841)) and v23(v97.EarthShock, not v16:IsSpellInRange(v97.EarthShock))) then
						return "earth_shock aoe 50";
					end
				end
				if ((v97.Icefury:IsAvailable() and (v97.Icefury:CooldownRemains() == (0 - 0)) and v40 and v13:BuffDown(v97.AscendanceBuff) and v97.ElectrifiedShocks:IsAvailable() and ((v97.LightningRod:IsAvailable() and (v109 < (3 + 2)) and not v119()) or (v97.DeeplyRootedElements:IsAvailable() and (v109 == (5 - 2))))) or ((11671 - 8721) == (5722 - (716 + 1194)))) then
					if (((81 + 4642) >= (249 + 2069)) and v23(v97.Icefury, not v16:IsSpellInRange(v97.Icefury))) then
						return "icefury aoe 52";
					end
				end
				v150 = 507 - (74 + 429);
			end
			if ((v150 == (7 - 3)) or ((1005 + 1022) > (6527 - 3675))) then
				if ((v97.FrostShock:IsCastable() and v39 and v13:BuffDown(v97.AscendanceBuff) and v121() and v97.ElectrifiedShocks:IsAvailable() and (v16:DebuffDown(v97.ElectrifiedShocksDebuff) or (v13:BuffRemains(v97.IcefuryBuff) < v13:GCD())) and ((v97.LightningRod:IsAvailable() and (v109 < (4 + 1)) and not v119()) or (v97.DeeplyRootedElements:IsAvailable() and (v109 == (8 - 5))))) or ((2808 - 1672) > (4750 - (279 + 154)))) then
					if (((5526 - (454 + 324)) == (3736 + 1012)) and v23(v97.FrostShock, not v16:IsSpellInRange(v97.FrostShock))) then
						return "frost_shock moving aoe 54";
					end
				end
				if (((3753 - (12 + 5)) <= (2556 + 2184)) and v97.LavaBurst:IsAvailable() and v42 and v97.MasteroftheElements:IsAvailable() and not v119() and (v120() or (v13:HasTier(76 - 46, 1 + 1) and (v111() < (1096 - (277 + 816))))) and (v118() < ((((256 - 196) - ((1188 - (1058 + 125)) * v97.EyeoftheStorm:TalentRank())) - ((1 + 1) * v24(v97.FlowofPower:IsAvailable()))) - (985 - (815 + 160)))) and (v109 < (21 - 16))) then
					if (v101.CastCycle(v97.LavaBurst, v108, v115, not v16:IsSpellInRange(v97.LavaBurst)) or ((8047 - 4657) <= (730 + 2330))) then
						return "lava_burst aoe 56";
					end
				end
				if ((v97.LavaBeam:IsAvailable() and v41 and (v120())) or ((2920 - 1921) > (4591 - (41 + 1857)))) then
					if (((2356 - (1222 + 671)) < (1553 - 952)) and v23(v97.LavaBeam, not v16:IsSpellInRange(v97.LavaBeam))) then
						return "lava_beam aoe 58";
					end
				end
				if ((v97.ChainLightning:IsAvailable() and v34 and (v120())) or ((3137 - 954) < (1869 - (229 + 953)))) then
					if (((6323 - (1111 + 663)) == (6128 - (874 + 705))) and v23(v97.ChainLightning, not v16:IsSpellInRange(v97.ChainLightning))) then
						return "chain_lightning aoe 60";
					end
				end
				if (((654 + 4018) == (3188 + 1484)) and v97.LavaBeam:IsAvailable() and v41 and v13:BuffUp(v97.Power) and (v13:BuffRemains(v97.AscendanceBuff) > v97.LavaBeam:CastTime())) then
					if (v23(v97.LavaBeam, not v16:IsSpellInRange(v97.LavaBeam)) or ((7624 - 3956) < (12 + 383))) then
						return "lava_beam aoe 62";
					end
				end
				if ((v97.ChainLightning:IsAvailable() and v34 and (v119())) or ((4845 - (642 + 37)) == (104 + 351))) then
					if (v23(v97.ChainLightning, not v16:IsSpellInRange(v97.ChainLightning)) or ((712 + 3737) == (6685 - 4022))) then
						return "chain_lightning aoe 64";
					end
				end
				v150 = 459 - (233 + 221);
			end
			if ((v150 == (11 - 6)) or ((3765 + 512) < (4530 - (718 + 823)))) then
				if ((v97.LavaBeam:IsAvailable() and v41 and (v109 >= (4 + 2)) and v13:BuffUp(v97.SurgeofPowerBuff) and (v13:BuffRemains(v97.AscendanceBuff) > v97.LavaBeam:CastTime())) or ((1675 - (266 + 539)) >= (11746 - 7597))) then
					if (((3437 - (636 + 589)) < (7555 - 4372)) and v23(v97.LavaBeam, not v16:IsSpellInRange(v97.LavaBeam))) then
						return "lava_beam aoe 66";
					end
				end
				if (((9582 - 4936) > (2372 + 620)) and v97.ChainLightning:IsAvailable() and v34 and (v109 >= (3 + 3)) and v13:BuffUp(v97.SurgeofPowerBuff)) then
					if (((2449 - (657 + 358)) < (8223 - 5117)) and v23(v97.ChainLightning, not v16:IsSpellInRange(v97.ChainLightning))) then
						return "chain_lightning aoe 68";
					end
				end
				if (((1790 - 1004) < (4210 - (1151 + 36))) and v97.LavaBurst:IsAvailable() and v42 and v13:BuffUp(v97.LavaSurgeBuff) and v97.DeeplyRootedElements:IsAvailable() and v13:BuffUp(v97.WindspeakersLavaResurgenceBuff)) then
					if (v23(v97.LavaBurst, not v16:IsSpellInRange(v97.LavaBurst)) or ((2359 + 83) < (20 + 54))) then
						return "lava_burst aoe 70";
					end
				end
				if (((13543 - 9008) == (6367 - (1552 + 280))) and v97.LavaBeam:IsAvailable() and v41 and v119() and (v13:BuffRemains(v97.AscendanceBuff) > v97.LavaBeam:CastTime())) then
					if (v23(v97.LavaBeam, not v16:IsSpellInRange(v97.LavaBeam)) or ((3843 - (64 + 770)) <= (1430 + 675))) then
						return "lava_beam aoe 72";
					end
				end
				if (((4154 - 2324) < (652 + 3017)) and v97.LavaBurst:IsAvailable() and v42 and (v109 == (1246 - (157 + 1086))) and v97.MasteroftheElements:IsAvailable()) then
					if (v101.CastCycle(v97.LavaBurst, v108, v115, not v16:IsSpellInRange(v97.LavaBurst)) or ((2862 - 1432) >= (15819 - 12207))) then
						return "lava_burst aoe 74";
					end
				end
				if (((4114 - 1431) >= (3357 - 897)) and v97.LavaBurst:IsAvailable() and v42 and v13:BuffUp(v97.LavaSurgeBuff) and v97.DeeplyRootedElements:IsAvailable()) then
					if (v101.CastCycle(v97.LavaBurst, v108, v115, not v16:IsSpellInRange(v97.LavaBurst)) or ((2623 - (599 + 220)) >= (6521 - 3246))) then
						return "lava_burst aoe 76";
					end
				end
				v150 = 1937 - (1813 + 118);
			end
			if (((5 + 1) == v150) or ((2634 - (841 + 376)) > (5084 - 1455))) then
				if (((1114 + 3681) > (1097 - 695)) and v97.Icefury:IsAvailable() and (v97.Icefury:CooldownRemains() == (859 - (464 + 395))) and v40 and v97.ElectrifiedShocks:IsAvailable() and (v110 < (12 - 7))) then
					if (((2312 + 2501) > (4402 - (467 + 370))) and v23(v97.Icefury, not v16:IsSpellInRange(v97.Icefury))) then
						return "icefury aoe 78";
					end
				end
				if (((8083 - 4171) == (2872 + 1040)) and v97.FrostShock:IsCastable() and v39 and v121() and v97.ElectrifiedShocks:IsAvailable() and v16:DebuffDown(v97.ElectrifiedShocksDebuff) and (v109 < (17 - 12)) and v97.UnrelentingCalamity:IsAvailable()) then
					if (((441 + 2380) <= (11222 - 6398)) and v23(v97.FrostShock, not v16:IsSpellInRange(v97.FrostShock))) then
						return "frost_shock aoe 80";
					end
				end
				if (((2258 - (150 + 370)) <= (3477 - (74 + 1208))) and v97.LavaBeam:IsAvailable() and v41 and (v13:BuffRemains(v97.AscendanceBuff) > v97.LavaBeam:CastTime())) then
					if (((100 - 59) <= (14313 - 11295)) and v23(v97.LavaBeam, not v16:IsSpellInRange(v97.LavaBeam))) then
						return "lava_beam aoe 82";
					end
				end
				if (((1527 + 618) <= (4494 - (14 + 376))) and v97.ChainLightning:IsAvailable() and v34) then
					if (((4663 - 1974) < (3136 + 1709)) and v23(v97.ChainLightning, not v16:IsSpellInRange(v97.ChainLightning))) then
						return "chain_lightning aoe 84";
					end
				end
				if ((v97.FlameShock:IsCastable() and UseFlameShock) or ((2040 + 282) > (2501 + 121))) then
					if (v101.CastCycle(v97.FlameShock, v108, v112, not v16:IsSpellInRange(v97.FlameShock)) or ((13285 - 8751) == (1567 + 515))) then
						return "flame_shock moving aoe 86";
					end
				end
				if ((v97.FrostShock:IsCastable() and v39) or ((1649 - (23 + 55)) > (4424 - 2557))) then
					if (v23(v97.FrostShock, not v16:IsSpellInRange(v97.FrostShock)) or ((1772 + 882) >= (2691 + 305))) then
						return "frost_shock moving aoe 88";
					end
				end
				break;
			end
			if (((6167 - 2189) > (662 + 1442)) and ((903 - (652 + 249)) == v150)) then
				if (((8015 - 5020) > (3409 - (708 + 1160))) and v97.Earthquake:IsReady() and v35 and (v49 == "cursor") and not v97.EchoesofGreatSundering:IsAvailable() and (v109 > (8 - 5)) and (v110 > (5 - 2))) then
					if (((3276 - (10 + 17)) > (215 + 738)) and v23(v99.EarthquakeCursor, not v16:IsInRange(1772 - (1400 + 332)))) then
						return "earthquake aoe 36";
					end
				end
				if ((v97.Earthquake:IsReady() and v35 and (v49 == "player") and not v97.EchoesofGreatSundering:IsAvailable() and (v109 > (5 - 2)) and (v110 > (1911 - (242 + 1666)))) or ((1401 + 1872) > (1676 + 2897))) then
					if (v23(v99.EarthquakePlayer, not v16:IsInRange(35 + 5)) or ((4091 - (850 + 90)) < (2248 - 964))) then
						return "earthquake aoe 36";
					end
				end
				if ((v97.Earthquake:IsReady() and v35 and (v49 == "cursor") and not v97.EchoesofGreatSundering:IsAvailable() and not v97.ElementalBlast:IsAvailable() and (v109 == (1393 - (360 + 1030))) and (v110 == (3 + 0))) or ((5221 - 3371) == (2102 - 573))) then
					if (((2482 - (909 + 752)) < (3346 - (109 + 1114))) and v23(v99.EarthquakeCursor, not v16:IsInRange(73 - 33))) then
						return "earthquake aoe 38";
					end
				end
				if (((352 + 550) < (2567 - (6 + 236))) and v97.Earthquake:IsReady() and v35 and (v49 == "player") and not v97.EchoesofGreatSundering:IsAvailable() and not v97.ElementalBlast:IsAvailable() and (v109 == (2 + 1)) and (v110 == (3 + 0))) then
					if (((2023 - 1165) <= (5173 - 2211)) and v23(v99.EarthquakePlayer, not v16:IsInRange(1173 - (1076 + 57)))) then
						return "earthquake aoe 38";
					end
				end
				if ((v97.Earthquake:IsReady() and v35 and (v49 == "cursor") and (v13:BuffUp(v97.EchoesofGreatSunderingBuff))) or ((649 + 3297) < (1977 - (579 + 110)))) then
					if (v23(v99.EarthquakeCursor, not v16:IsInRange(4 + 36)) or ((2867 + 375) == (301 + 266))) then
						return "earthquake aoe 40";
					end
				end
				if ((v97.Earthquake:IsReady() and v35 and (v49 == "player") and (v13:BuffUp(v97.EchoesofGreatSunderingBuff))) or ((1254 - (174 + 233)) >= (3527 - 2264))) then
					if (v23(v99.EarthquakePlayer, not v16:IsInRange(70 - 30)) or ((1002 + 1251) == (3025 - (663 + 511)))) then
						return "earthquake aoe 40";
					end
				end
				v150 = 3 + 0;
			end
			if (((1 + 0) == v150) or ((6433 - 4346) > (1437 + 935))) then
				if ((v97.PrimordialWave:IsAvailable() and v45 and ((v62 and v32) or not v62) and v13:BuffDown(v97.PrimordialWaveBuff) and v13:BuffUp(v97.SurgeofPowerBuff) and v13:BuffDown(v97.SplinteredElementsBuff)) or ((10464 - 6019) < (10043 - 5894))) then
					if (v101.CastTargetIf(v97.PrimordialWave, v108, "min", v115, nil, not v16:IsSpellInRange(v97.PrimordialWave), nil, Settings.Commons.DisplayStyle.Signature) or ((868 + 950) == (165 - 80))) then
						return "primordial_wave aoe 12";
					end
				end
				if (((449 + 181) < (195 + 1932)) and v97.PrimordialWave:IsAvailable() and v45 and ((v62 and v32) or not v62) and v13:BuffDown(v97.PrimordialWaveBuff) and v97.DeeplyRootedElements:IsAvailable() and not v97.SurgeofPower:IsAvailable() and v13:BuffDown(v97.SplinteredElementsBuff)) then
					if (v101.CastTargetIf(v97.PrimordialWave, v108, "min", v115, nil, not v16:IsSpellInRange(v97.PrimordialWave), nil, Settings.Commons.DisplayStyle.Signature) or ((2660 - (478 + 244)) == (3031 - (440 + 77)))) then
						return "primordial_wave aoe 14";
					end
				end
				if (((1935 + 2320) >= (201 - 146)) and v97.PrimordialWave:IsAvailable() and v45 and ((v62 and v32) or not v62) and v13:BuffDown(v97.PrimordialWaveBuff) and v97.MasteroftheElements:IsAvailable() and not v97.LightningRod:IsAvailable()) then
					if (((4555 - (655 + 901)) > (215 + 941)) and v101.CastTargetIf(v97.PrimordialWave, v108, "min", v115, nil, not v16:IsSpellInRange(v97.PrimordialWave), nil, Settings.Commons.DisplayStyle.Signature)) then
						return "primordial_wave aoe 16";
					end
				end
				if (((1800 + 550) > (780 + 375)) and v97.FlameShock:IsCastable()) then
					if (((16231 - 12202) <= (6298 - (695 + 750))) and v13:BuffUp(v97.SurgeofPowerBuff) and v38 and v97.LightningRod:IsAvailable() and v97.WindspeakersLavaResurgence:IsAvailable() and (v16:DebuffRemains(v97.FlameShockDebuff) < (v16:TimeToDie() - (3 - 2)))) then
						if (v101.CastCycle(v97.FlameShock, v108, v113, not v16:IsSpellInRange(v97.FlameShock)) or ((795 - 279) > (13810 - 10376))) then
							return "flame_shock aoe 18";
						end
					end
					if (((4397 - (285 + 66)) >= (7070 - 4037)) and v13:BuffUp(v97.SurgeofPowerBuff) and v38 and (not v97.LightningRod:IsAvailable() or v97.SkybreakersFieryDemise:IsAvailable()) and (v97.FlameShockDebuff:AuraActiveCount() < (1316 - (682 + 628)))) then
						if (v101.CastCycle(v97.FlameShock, v108, v113, not v16:IsSpellInRange(v97.FlameShock)) or ((439 + 2280) <= (1746 - (176 + 123)))) then
							return "flame_shock aoe 20";
						end
					end
					if ((v97.MasteroftheElements:IsAvailable() and v38 and not v97.LightningRod:IsAvailable() and (v97.FlameShockDebuff:AuraActiveCount() < (3 + 3))) or ((2999 + 1135) < (4195 - (239 + 30)))) then
						if (v101.CastCycle(v97.FlameShock, v108, v113, not v16:IsSpellInRange(v97.FlameShock)) or ((45 + 119) >= (2677 + 108))) then
							return "flame_shock aoe 22";
						end
					end
					if ((v97.DeeplyRootedElements:IsAvailable() and v38 and not v97.SurgeofPower:IsAvailable() and (v97.FlameShockDebuff:AuraActiveCount() < (10 - 4))) or ((1637 - 1112) == (2424 - (306 + 9)))) then
						if (((115 - 82) == (6 + 27)) and v101.CastCycle(v97.FlameShock, v108, v113, not v16:IsSpellInRange(v97.FlameShock))) then
							return "flame_shock aoe 24";
						end
					end
					if (((1874 + 1180) <= (1933 + 2082)) and v13:BuffUp(v97.SurgeofPowerBuff) and v38 and (not v97.LightningRod:IsAvailable() or v97.SkybreakersFieryDemise:IsAvailable())) then
						if (((5350 - 3479) < (4757 - (1140 + 235))) and v101.CastCycle(v97.FlameShock, v108, v114, not v16:IsSpellInRange(v97.FlameShock))) then
							return "flame_shock aoe 26";
						end
					end
					if (((823 + 470) <= (1987 + 179)) and v97.MasteroftheElements:IsAvailable() and v38 and not v97.LightningRod:IsAvailable()) then
						if (v101.CastCycle(v97.FlameShock, v108, v114, not v16:IsSpellInRange(v97.FlameShock)) or ((662 + 1917) < (175 - (33 + 19)))) then
							return "flame_shock aoe 28";
						end
					end
					if ((v97.DeeplyRootedElements:IsAvailable() and v38 and not v97.SurgeofPower:IsAvailable()) or ((306 + 540) >= (7097 - 4729))) then
						if (v101.CastCycle(v97.FlameShock, v108, v114, not v16:IsSpellInRange(v97.FlameShock)) or ((1768 + 2244) <= (6585 - 3227))) then
							return "flame_shock aoe 30";
						end
					end
				end
				if (((1401 + 93) <= (3694 - (586 + 103))) and v97.Ascendance:IsCastable() and v50 and ((v56 and v31) or not v56) and (v88 < v104)) then
					if (v23(v97.Ascendance) or ((284 + 2827) == (6569 - 4435))) then
						return "ascendance aoe 32";
					end
				end
				if (((3843 - (1309 + 179)) == (4251 - 1896)) and v97.LavaBurst:IsAvailable() and v42 and v13:BuffUp(v97.LavaSurgeBuff) and v97.MasteroftheElements:IsAvailable() and not v119() and (v118() >= (((27 + 33) - ((13 - 8) * v97.EyeoftheStorm:TalentRank())) - ((2 + 0) * v24(v97.FlowofPower:IsAvailable())))) and ((not v97.EchoesofGreatSundering:IsAvailable() and not v97.LightningRod:IsAvailable()) or v13:BuffUp(v97.EchoesofGreatSunderingBuff)) and ((v13:BuffDown(v97.AscendanceBuff) and (v109 > (5 - 2)) and not v97.UnrelentingCalamity:IsAvailable()) or (v110 == (5 - 2)))) then
					if (v101.CastCycle(v97.LavaBurst, v108, v115, not v16:IsSpellInRange(v97.LavaBurst)) or ((1197 - (295 + 314)) <= (1060 - 628))) then
						return "lava_burst aoe 34";
					end
				end
				v150 = 1964 - (1300 + 662);
			end
			if (((15063 - 10266) >= (5650 - (1178 + 577))) and (v150 == (0 + 0))) then
				if (((10574 - 6997) == (4982 - (851 + 554))) and v97.FireElemental:IsReady() and v51 and ((v57 and v31) or not v57) and (v88 < v104)) then
					if (((3355 + 439) > (10241 - 6548)) and v23(v97.FireElemental)) then
						return "fire_elemental aoe 2";
					end
				end
				if ((v97.StormElemental:IsReady() and v53 and ((v58 and v31) or not v58) and (v88 < v104)) or ((2769 - 1494) == (4402 - (115 + 187)))) then
					if (v23(v97.StormElemental) or ((1219 + 372) >= (3390 + 190))) then
						return "storm_elemental aoe 4";
					end
				end
				if (((3873 - 2890) <= (2969 - (160 + 1001))) and v97.Stormkeeper:IsAvailable() and (v97.Stormkeeper:CooldownRemains() == (0 + 0)) and not v13:BuffUp(v97.StormkeeperBuff) and v46 and ((v63 and v32) or not v63) and (v88 < v104) and not v120()) then
					if (v23(v97.Stormkeeper) or ((1484 + 666) <= (2449 - 1252))) then
						return "stormkeeper aoe 7";
					end
				end
				if (((4127 - (237 + 121)) >= (2070 - (525 + 372))) and v97.TotemicRecall:IsCastable() and (v97.LiquidMagmaTotem:CooldownRemains() > (84 - 39)) and v47) then
					if (((4879 - 3394) == (1627 - (96 + 46))) and v23(v97.TotemicRecall)) then
						return "totemic_recall aoe 8";
					end
				end
				if ((v97.LiquidMagmaTotem:IsReady() and v52 and ((v59 and v31) or not v59) and (v88 < v104) and (v64 == "cursor")) or ((4092 - (643 + 134)) <= (1005 + 1777))) then
					if (v23(v99.LiquidMagmaTotemCursor, not v16:IsInRange(95 - 55)) or ((3252 - 2376) >= (2843 + 121))) then
						return "liquid_magma_totem aoe 10";
					end
				end
				if ((v97.LiquidMagmaTotem:IsReady() and v52 and ((v59 and v31) or not v59) and (v88 < v104) and (v64 == "player")) or ((4380 - 2148) > (5103 - 2606))) then
					if (v23(v99.LiquidMagmaTotemPlayer, not v16:IsInRange(759 - (316 + 403))) or ((1403 + 707) <= (912 - 580))) then
						return "liquid_magma_totem aoe 11";
					end
				end
				v150 = 1 + 0;
			end
		end
	end
	local function v128()
		if (((9282 - 5596) > (2248 + 924)) and v97.FireElemental:IsCastable() and v51 and ((v57 and v31) or not v57) and (v88 < v104)) then
			if (v23(v97.FireElemental) or ((1442 + 3032) < (2841 - 2021))) then
				return "fire_elemental single_target 2";
			end
		end
		if (((20435 - 16156) >= (5986 - 3104)) and v97.StormElemental:IsCastable() and v53 and ((v58 and v31) or not v58) and (v88 < v104)) then
			if (v23(v97.StormElemental) or ((117 + 1912) >= (6931 - 3410))) then
				return "storm_elemental single_target 4";
			end
		end
		if ((v97.TotemicRecall:IsCastable() and v47 and (v97.LiquidMagmaTotem:CooldownRemains() > (3 + 42)) and ((v97.LavaSurge:IsAvailable() and v97.SplinteredElements:IsAvailable()) or ((v109 > (2 - 1)) and (v110 > (18 - (12 + 5)))))) or ((7911 - 5874) >= (9903 - 5261))) then
			if (((3656 - 1936) < (11055 - 6597)) and v23(v97.TotemicRecall)) then
				return "totemic_recall single_target 7";
			end
		end
		if ((v97.LiquidMagmaTotem:IsCastable() and v52 and ((v59 and v31) or not v59) and (v88 < v104) and (v64 == "cursor") and ((v97.LavaSurge:IsAvailable() and v97.SplinteredElements:IsAvailable()) or (v97.FlameShockDebuff:AuraActiveCount() == (0 + 0)) or (v16:DebuffRemains(v97.FlameShockDebuff) < (1979 - (1656 + 317))) or ((v109 > (1 + 0)) and (v110 > (1 + 0))))) or ((1159 - 723) > (14867 - 11846))) then
			if (((1067 - (5 + 349)) <= (4023 - 3176)) and v23(v99.LiquidMagmaTotemCursor, not v16:IsInRange(1311 - (266 + 1005)))) then
				return "liquid_magma_totem single_target 8";
			end
		end
		if (((1420 + 734) <= (13754 - 9723)) and v97.LiquidMagmaTotem:IsCastable() and v52 and ((v59 and v31) or not v59) and (v88 < v104) and (v64 == "player") and ((v97.LavaSurge:IsAvailable() and v97.SplinteredElements:IsAvailable()) or (v97.FlameShockDebuff:AuraActiveCount() == (0 - 0)) or (v16:DebuffRemains(v97.FlameShockDebuff) < (1702 - (561 + 1135))) or ((v109 > (1 - 0)) and (v110 > (3 - 2))))) then
			if (((5681 - (507 + 559)) == (11580 - 6965)) and v23(v99.LiquidMagmaTotemPlayer, not v16:IsInRange(123 - 83))) then
				return "liquid_magma_totem single_target 8";
			end
		end
		if ((v97.PrimordialWave:IsAvailable() and v45 and v62 and (v88 < v104) and v32 and v13:BuffDown(v97.PrimordialWaveBuff) and v13:BuffDown(v97.SplinteredElementsBuff)) or ((4178 - (212 + 176)) == (1405 - (250 + 655)))) then
			if (((242 - 153) < (385 - 164)) and v101.CastTargetIf(v97.PrimordialWave, v108, "min", v115, nil, not v16:IsSpellInRange(v97.PrimordialWave), nil, Settings.Commons.DisplayStyle.Signature)) then
				return "primordial_wave single_target 10";
			end
		end
		if (((3212 - 1158) >= (3377 - (1869 + 87))) and v97.FlameShock:IsCastable() and UseFlameShock and (v109 == (3 - 2)) and v16:DebuffRefreshable(v97.FlameShockDebuff) and v13:BuffDown(v97.SurgeofPowerBuff) and (not v119() or (not v120() and ((v97.ElementalBlast:IsAvailable() and (v118() < ((1991 - (484 + 1417)) - ((16 - 8) * v97.EyeoftheStorm:TalentRank())))) or (v118() < ((100 - 40) - ((778 - (48 + 725)) * v97.EyeoftheStorm:TalentRank()))))))) then
			if (((1130 - 438) < (8204 - 5146)) and v23(v97.FlameShock, not v16:IsSpellInRange(v97.FlameShock))) then
				return "flame_shock single_target 12";
			end
		end
		if ((v97.FlameShock:IsCastable() and UseFlameShock and (v97.FlameShockDebuff:AuraActiveCount() == (0 + 0)) and (v109 > (2 - 1)) and (v110 > (1 + 0)) and (v97.DeeplyRootedElements:IsAvailable() or v97.Ascendance:IsAvailable() or v97.PrimordialWave:IsAvailable() or v97.SearingFlames:IsAvailable() or v97.MagmaChamber:IsAvailable()) and ((not v119() and (v120() or (v97.Stormkeeper:CooldownRemains() > (0 + 0)))) or not v97.SurgeofPower:IsAvailable())) or ((4107 - (152 + 701)) == (2966 - (430 + 881)))) then
			if (v101.CastTargetIf(v97.FlameShock, v108, "min", v115, nil, not v16:IsSpellInRange(v97.FlameShock)) or ((497 + 799) == (5805 - (557 + 338)))) then
				return "flame_shock single_target 14";
			end
		end
		if (((996 + 2372) == (9490 - 6122)) and v97.FlameShock:IsCastable() and UseFlameShock and (v109 > (3 - 2)) and (v110 > (2 - 1)) and (v97.DeeplyRootedElements:IsAvailable() or v97.Ascendance:IsAvailable() or v97.PrimordialWave:IsAvailable() or v97.SearingFlames:IsAvailable() or v97.MagmaChamber:IsAvailable()) and ((v13:BuffUp(v97.SurgeofPowerBuff) and not v120() and v97.Stormkeeper:IsAvailable()) or not v97.SurgeofPower:IsAvailable())) then
			if (((5695 - 3052) < (4616 - (499 + 302))) and v101.CastTargetIf(v97.FlameShock, v108, "min", v115, v112, not v16:IsSpellInRange(v97.FlameShock))) then
				return "flame_shock single_target 16";
			end
		end
		if (((2779 - (39 + 827)) > (1360 - 867)) and v97.Stormkeeper:IsAvailable() and (v97.Stormkeeper:CooldownRemains() == (0 - 0)) and not v13:BuffUp(v97.StormkeeperBuff) and v46 and ((v63 and v32) or not v63) and (v88 < v104) and v13:BuffDown(v97.AscendanceBuff) and not v120() and (v118() >= (460 - 344)) and v97.ElementalBlast:IsAvailable() and v97.SurgeofPower:IsAvailable() and v97.SwellingMaelstrom:IsAvailable() and not v97.LavaSurge:IsAvailable() and not v97.EchooftheElements:IsAvailable() and not v97.PrimordialSurge:IsAvailable()) then
			if (((7299 - 2544) > (294 + 3134)) and v23(v97.Stormkeeper)) then
				return "stormkeeper single_target 18";
			end
		end
		if (((4042 - 2661) <= (379 + 1990)) and v97.Stormkeeper:IsAvailable() and (v97.Stormkeeper:CooldownRemains() == (0 - 0)) and not v13:BuffUp(v97.StormkeeperBuff) and v46 and ((v63 and v32) or not v63) and (v88 < v104) and v13:BuffDown(v97.AscendanceBuff) and not v120() and v13:BuffUp(v97.SurgeofPowerBuff) and not v97.LavaSurge:IsAvailable() and not v97.EchooftheElements:IsAvailable() and not v97.PrimordialSurge:IsAvailable()) then
			if (v23(v97.Stormkeeper) or ((4947 - (103 + 1)) == (4638 - (475 + 79)))) then
				return "stormkeeper single_target 20";
			end
		end
		if (((10093 - 5424) > (1161 - 798)) and v97.Stormkeeper:IsAvailable() and (v97.Stormkeeper:CooldownRemains() == (0 + 0)) and not v13:BuffUp(v97.StormkeeperBuff) and v46 and ((v63 and v32) or not v63) and (v88 < v104) and v13:BuffDown(v97.AscendanceBuff) and not v120() and (not v97.SurgeofPower:IsAvailable() or not v97.ElementalBlast:IsAvailable() or v97.LavaSurge:IsAvailable() or v97.EchooftheElements:IsAvailable() or v97.PrimordialSurge:IsAvailable())) then
			if (v23(v97.Stormkeeper) or ((1652 + 225) >= (4641 - (1395 + 108)))) then
				return "stormkeeper single_target 22";
			end
		end
		if (((13798 - 9056) >= (4830 - (7 + 1197))) and v97.Ascendance:IsCastable() and v50 and ((v56 and v31) or not v56) and (v88 < v104) and not v120()) then
			if (v23(v97.Ascendance) or ((1980 + 2560) == (320 + 596))) then
				return "ascendance single_target 24";
			end
		end
		if ((v97.LightningBolt:IsAvailable() and v43 and v120() and v13:BuffUp(v97.SurgeofPowerBuff)) or ((1475 - (27 + 292)) > (12732 - 8387))) then
			if (((2852 - 615) < (17819 - 13570)) and v23(v97.LightningBolt, not v16:IsSpellInRange(v97.LightningBolt))) then
				return "lightning_bolt single_target 26";
			end
		end
		if ((v97.LavaBeam:IsCastable() and v41 and (v109 > (1 - 0)) and (v110 > (1 - 0)) and v120() and not v97.SurgeofPower:IsAvailable()) or ((2822 - (43 + 96)) < (93 - 70))) then
			if (((1575 - 878) <= (686 + 140)) and v23(v97.LavaBeam, not v16:IsSpellInRange(v97.LavaBeam))) then
				return "lava_beam single_target 28";
			end
		end
		if (((313 + 792) <= (2324 - 1148)) and v97.ChainLightning:IsAvailable() and v34 and (v109 > (1 + 0)) and (v110 > (1 - 0)) and v120() and not v97.SurgeofPower:IsAvailable()) then
			if (((1064 + 2315) <= (280 + 3532)) and v23(v97.ChainLightning, not v16:IsSpellInRange(v97.ChainLightning))) then
				return "chain_lightning single_target 30";
			end
		end
		if ((v97.LavaBurst:IsAvailable() and v42 and v120() and not v119() and not v97.SurgeofPower:IsAvailable() and v97.MasteroftheElements:IsAvailable()) or ((2539 - (1414 + 337)) >= (3556 - (1642 + 298)))) then
			if (((4833 - 2979) <= (9720 - 6341)) and v23(v97.LavaBurst, not v16:IsSpellInRange(v97.LavaBurst))) then
				return "lava_burst single_target 32";
			end
		end
		if (((13499 - 8950) == (1498 + 3051)) and v97.LightningBolt:IsAvailable() and v43 and v120() and not v97.SurgeofPower:IsAvailable() and v119()) then
			if (v23(v97.LightningBolt, not v16:IsSpellInRange(v97.LightningBolt)) or ((2352 + 670) >= (3996 - (357 + 615)))) then
				return "lightning_bolt single_target 34";
			end
		end
		if (((3384 + 1436) > (5393 - 3195)) and v97.LightningBolt:IsAvailable() and v43 and v120() and not v97.SurgeofPower:IsAvailable() and not v97.MasteroftheElements:IsAvailable()) then
			if (v23(v97.LightningBolt, not v16:IsSpellInRange(v97.LightningBolt)) or ((910 + 151) >= (10481 - 5590))) then
				return "lightning_bolt single_target 36";
			end
		end
		if (((1091 + 273) <= (304 + 4169)) and v97.LightningBolt:IsAvailable() and v43 and v13:BuffUp(v97.SurgeofPowerBuff) and v97.LightningRod:IsAvailable()) then
			if (v23(v97.LightningBolt, not v16:IsSpellInRange(v97.LightningBolt)) or ((2260 + 1335) <= (1304 - (384 + 917)))) then
				return "lightning_bolt single_target 38";
			end
		end
		if ((v97.Icefury:IsAvailable() and (v97.Icefury:CooldownRemains() == (697 - (128 + 569))) and v40 and v97.ElectrifiedShocks:IsAvailable() and v97.LightningRod:IsAvailable() and v97.LightningRod:IsAvailable()) or ((6215 - (1407 + 136)) == (5739 - (687 + 1200)))) then
			if (((3269 - (556 + 1154)) == (5484 - 3925)) and v23(v97.Icefury, not v16:IsSpellInRange(v97.Icefury))) then
				return "icefury single_target 40";
			end
		end
		if ((v97.FrostShock:IsCastable() and v39 and v121() and v97.ElectrifiedShocks:IsAvailable() and ((v16:DebuffRemains(v97.ElectrifiedShocksDebuff) < (97 - (9 + 86))) or (v13:BuffRemains(v97.IcefuryBuff) <= v13:GCD())) and v97.LightningRod:IsAvailable()) or ((2173 - (275 + 146)) <= (129 + 659))) then
			if (v23(v97.FrostShock, not v16:IsSpellInRange(v97.FrostShock)) or ((3971 - (29 + 35)) == (784 - 607))) then
				return "frost_shock single_target 42";
			end
		end
		if (((10364 - 6894) > (2449 - 1894)) and v97.FrostShock:IsCastable() and v39 and v121() and v97.ElectrifiedShocks:IsAvailable() and (v118() >= (33 + 17)) and (v16:DebuffRemains(v97.ElectrifiedShocksDebuff) < ((1014 - (53 + 959)) * v13:GCD())) and v120() and v97.LightningRod:IsAvailable()) then
			if (v23(v97.FrostShock, not v16:IsSpellInRange(v97.FrostShock)) or ((1380 - (312 + 96)) == (1119 - 474))) then
				return "frost_shock single_target 44";
			end
		end
		if (((3467 - (147 + 138)) >= (3014 - (813 + 86))) and v97.LavaBeam:IsCastable() and v41 and (v109 > (1 + 0)) and (v110 > (1 - 0)) and v119() and (v13:BuffRemains(v97.AscendanceBuff) > v97.LavaBeam:CastTime()) and not v13:HasTier(523 - (18 + 474), 2 + 2)) then
			if (((12706 - 8813) < (5515 - (860 + 226))) and v23(v97.LavaBeam, not v16:IsSpellInRange(v97.LavaBeam))) then
				return "lava_beam single_target 46";
			end
		end
		if ((v97.FrostShock:IsCastable() and v39 and v121() and v120() and not v97.LavaSurge:IsAvailable() and not v97.EchooftheElements:IsAvailable() and not v97.PrimordialSurge:IsAvailable() and v97.ElementalBlast:IsAvailable() and (((v118() >= (364 - (121 + 182))) and (v118() < (10 + 65)) and (v97.LavaBurst:CooldownRemains() > v13:GCD())) or ((v118() >= (1289 - (988 + 252))) and (v118() < (8 + 55)) and (v97.LavaBurst:CooldownRemains() > (0 + 0))))) or ((4837 - (49 + 1921)) < (2795 - (223 + 667)))) then
			if (v23(v97.FrostShock, not v16:IsSpellInRange(v97.FrostShock)) or ((1848 - (51 + 1)) >= (6972 - 2921))) then
				return "frost_shock single_target 48";
			end
		end
		if (((3466 - 1847) <= (4881 - (146 + 979))) and v97.FrostShock:IsCastable() and v39 and v121() and not v97.LavaSurge:IsAvailable() and not v97.EchooftheElements:IsAvailable() and not v97.ElementalBlast:IsAvailable() and (((v118() >= (11 + 25)) and (v118() < (655 - (311 + 294))) and (v97.LavaBurst:CooldownRemains() > v13:GCD())) or ((v118() >= (66 - 42)) and (v118() < (17 + 21)) and (v97.LavaBurst:CooldownRemains() > (1443 - (496 + 947)))))) then
			if (((1962 - (1233 + 125)) == (246 + 358)) and v23(v97.FrostShock, not v16:IsSpellInRange(v97.FrostShock))) then
				return "frost_shock single_target 50";
			end
		end
		if ((v97.LavaBurst:IsAvailable() and v42 and v13:BuffUp(v97.WindspeakersLavaResurgenceBuff) and (v97.EchooftheElements:IsAvailable() or v97.LavaSurge:IsAvailable() or v97.PrimordialSurge:IsAvailable() or ((v118() >= (57 + 6)) and v97.MasteroftheElements:IsAvailable()) or ((v118() >= (8 + 30)) and v13:BuffUp(v97.EchoesofGreatSunderingBuff) and (v109 > (1646 - (963 + 682))) and (v110 > (1 + 0))) or not v97.ElementalBlast:IsAvailable())) or ((5988 - (504 + 1000)) == (607 + 293))) then
			if (v23(v97.LavaBurst, not v16:IsSpellInRange(v97.LavaBurst)) or ((4061 + 398) <= (106 + 1007))) then
				return "lava_burst single_target 52";
			end
		end
		if (((5355 - 1723) > (2904 + 494)) and v97.LavaBurst:IsAvailable() and v42 and v13:BuffUp(v97.LavaSurgeBuff) and (v97.EchooftheElements:IsAvailable() or v97.LavaSurge:IsAvailable() or v97.PrimordialSurge:IsAvailable() or not v97.MasteroftheElements:IsAvailable() or not v97.ElementalBlast:IsAvailable())) then
			if (((2374 + 1708) <= (5099 - (156 + 26))) and v23(v97.LavaBurst, not v16:IsSpellInRange(v97.LavaBurst))) then
				return "lava_burst single_target 54";
			end
		end
		if (((2784 + 2048) >= (2167 - 781)) and v97.LavaBurst:IsAvailable() and v42 and v13:BuffUp(v97.AscendanceBuff) and (v13:HasTier(195 - (149 + 15), 964 - (890 + 70)) or not v97.ElementalBlast:IsAvailable())) then
			if (((254 - (39 + 78)) == (619 - (14 + 468))) and v101.CastCycle(v97.LavaBurst, v108, v116, not v16:IsSpellInRange(v97.LavaBurst))) then
				return "lava_burst single_target 56";
			end
		end
		if ((v97.LavaBurst:IsAvailable() and v42 and v13:BuffDown(v97.AscendanceBuff) and (not v97.ElementalBlast:IsAvailable() or not v97.MountainsWillFall:IsAvailable()) and not v97.LightningRod:IsAvailable() and v13:HasTier(68 - 37, 11 - 7)) or ((811 + 759) >= (2602 + 1730))) then
			if (v101.CastCycle(v97.LavaBurst, v108, v116, not v16:IsSpellInRange(v97.LavaBurst)) or ((864 + 3200) <= (822 + 997))) then
				return "lava_burst single_target 58";
			end
		end
		if ((v97.LavaBurst:IsAvailable() and v42 and v97.MasteroftheElements:IsAvailable() and not v119() and not v97.LightningRod:IsAvailable()) or ((1307 + 3679) < (3012 - 1438))) then
			if (((4375 + 51) > (604 - 432)) and v101.CastCycle(v97.LavaBurst, v108, v116, not v16:IsSpellInRange(v97.LavaBurst))) then
				return "lava_burst single_target 60";
			end
		end
		if (((15 + 571) > (506 - (12 + 39))) and v97.LavaBurst:IsAvailable() and v42 and v97.MasteroftheElements:IsAvailable() and not v119() and ((v118() >= (70 + 5)) or ((v118() >= (154 - 104)) and not v97.ElementalBlast:IsAvailable())) and v97.SwellingMaelstrom:IsAvailable() and (v118() <= (463 - 333))) then
			if (((245 + 581) == (435 + 391)) and v23(v97.LavaBurst, not v16:IsSpellInRange(v97.LavaBurst))) then
				return "lava_burst single_target 62";
			end
		end
		if ((v97.Earthquake:IsReady() and v35 and (v49 == "cursor") and v13:BuffUp(v97.EchoesofGreatSunderingBuff) and ((not v97.ElementalBlast:IsAvailable() and (v109 < (4 - 2))) or (v109 > (1 + 0)))) or ((19422 - 15403) > (6151 - (1596 + 114)))) then
			if (((5266 - 3249) < (4974 - (164 + 549))) and v23(v99.EarthquakeCursor, not v16:IsInRange(1478 - (1059 + 379)))) then
				return "earthquake single_target 64";
			end
		end
		if (((5855 - 1139) > (42 + 38)) and v97.Earthquake:IsReady() and v35 and (v49 == "player") and v13:BuffUp(v97.EchoesofGreatSunderingBuff) and ((not v97.ElementalBlast:IsAvailable() and (v109 < (1 + 1))) or (v109 > (393 - (145 + 247))))) then
			if (v23(v99.EarthquakePlayer, not v16:IsInRange(33 + 7)) or ((1621 + 1886) == (9700 - 6428))) then
				return "earthquake single_target 64";
			end
		end
		if ((v97.Earthquake:IsReady() and v35 and (v49 == "cursor") and (v109 > (1 + 0)) and (v110 > (1 + 0)) and not v97.EchoesofGreatSundering:IsAvailable() and not v97.ElementalBlast:IsAvailable()) or ((1421 - 545) >= (3795 - (254 + 466)))) then
			if (((4912 - (544 + 16)) > (8116 - 5562)) and v23(v99.EarthquakeCursor, not v16:IsInRange(668 - (294 + 334)))) then
				return "earthquake single_target 66";
			end
		end
		if ((v97.Earthquake:IsReady() and v35 and (v49 == "player") and (v109 > (254 - (236 + 17))) and (v110 > (1 + 0)) and not v97.EchoesofGreatSundering:IsAvailable() and not v97.ElementalBlast:IsAvailable()) or ((3430 + 976) < (15226 - 11183))) then
			if (v23(v99.EarthquakePlayer, not v16:IsInRange(189 - 149)) or ((973 + 916) >= (2787 + 596))) then
				return "earthquake single_target 66";
			end
		end
		if (((2686 - (413 + 381)) <= (116 + 2618)) and v97.ElementalBlast:IsAvailable() and v37 and (not v97.MasteroftheElements:IsAvailable() or (v119() and v16:DebuffUp(v97.ElectrifiedShocksDebuff)))) then
			if (((4089 - 2166) < (5761 - 3543)) and v23(v97.ElementalBlast, not v16:IsSpellInRange(v97.ElementalBlast))) then
				return "elemental_blast single_target 68";
			end
		end
		if (((4143 - (582 + 1388)) > (645 - 266)) and v97.FrostShock:IsCastable() and v39 and v121() and v119() and (v118() < (79 + 31)) and (v97.LavaBurst:ChargesFractional() < (365 - (326 + 38))) and v97.ElectrifiedShocks:IsAvailable() and v97.ElementalBlast:IsAvailable() and not v97.LightningRod:IsAvailable()) then
			if (v23(v97.FrostShock, not v16:IsSpellInRange(v97.FrostShock)) or ((7664 - 5073) == (4865 - 1456))) then
				return "frost_shock single_target 70";
			end
		end
		if (((5134 - (47 + 573)) > (1172 + 2152)) and v97.ElementalBlast:IsAvailable() and v37 and (v119() or v97.LightningRod:IsAvailable())) then
			if (v23(v97.ElementalBlast, not v16:IsSpellInRange(v97.ElementalBlast)) or ((883 - 675) >= (7835 - 3007))) then
				return "elemental_blast single_target 72";
			end
		end
		if ((v97.EarthShock:IsReady() and v36) or ((3247 - (1269 + 395)) > (4059 - (76 + 416)))) then
			if (v23(v97.EarthShock, not v16:IsSpellInRange(v97.EarthShock)) or ((1756 - (319 + 124)) == (1814 - 1020))) then
				return "earth_shock single_target 74";
			end
		end
		if (((4181 - (564 + 443)) > (8033 - 5131)) and v97.FrostShock:IsCastable() and v39 and v121() and v97.ElectrifiedShocks:IsAvailable() and v119() and not v97.LightningRod:IsAvailable() and (v109 > (459 - (337 + 121))) and (v110 > (2 - 1))) then
			if (((13724 - 9604) <= (6171 - (1261 + 650))) and v23(v97.FrostShock, not v16:IsSpellInRange(v97.FrostShock))) then
				return "frost_shock single_target 76";
			end
		end
		if ((v97.LavaBurst:IsAvailable() and v42 and v13:BuffUp(v97.FluxMeltingBuff) and (v109 > (1 + 0))) or ((1406 - 523) > (6595 - (772 + 1045)))) then
			if (v101.CastCycle(v97.LavaBurst, v108, v116, not v16:IsSpellInRange(v97.LavaBurst)) or ((511 + 3109) >= (5035 - (102 + 42)))) then
				return "lava_burst single_target 78";
			end
		end
		if (((6102 - (1524 + 320)) > (2207 - (1049 + 221))) and v97.FrostShock:IsCastable() and v39 and v121() and v97.FluxMelting:IsAvailable() and v13:BuffDown(v97.FluxMeltingBuff)) then
			if (v23(v97.FrostShock, not v16:IsSpellInRange(v97.FrostShock)) or ((5025 - (18 + 138)) < (2217 - 1311))) then
				return "frost_shock single_target 80";
			end
		end
		if ((v97.FrostShock:IsCastable() and v39 and v121() and ((v97.ElectrifiedShocks:IsAvailable() and (v16:DebuffRemains(v97.ElectrifiedShocksDebuff) < (1104 - (67 + 1035)))) or (v13:BuffRemains(v97.IcefuryBuff) < (354 - (136 + 212))))) or ((5205 - 3980) > (3388 + 840))) then
			if (((3068 + 260) > (3842 - (240 + 1364))) and v23(v97.FrostShock, not v16:IsSpellInRange(v97.FrostShock))) then
				return "frost_shock single_target 82";
			end
		end
		if (((4921 - (1050 + 32)) > (5016 - 3611)) and v97.LavaBurst:IsAvailable() and v42 and (v97.EchooftheElements:IsAvailable() or v97.LavaSurge:IsAvailable() or v97.PrimordialSurge:IsAvailable() or not v97.ElementalBlast:IsAvailable() or not v97.MasteroftheElements:IsAvailable() or v120())) then
			if (v101.CastCycle(v97.LavaBurst, v108, v116, not v16:IsSpellInRange(v97.LavaBurst)) or ((765 + 528) <= (1562 - (331 + 724)))) then
				return "lava_burst single_target 84";
			end
		end
		if ((v97.ElementalBlast:IsAvailable() and v37) or ((234 + 2662) < (1449 - (269 + 375)))) then
			if (((3041 - (267 + 458)) == (721 + 1595)) and v23(v97.ElementalBlast, not v16:IsSpellInRange(v97.ElementalBlast))) then
				return "elemental_blast single_target 86";
			end
		end
		if ((v97.ChainLightning:IsAvailable() and v34 and v119() and v97.UnrelentingCalamity:IsAvailable() and (v109 > (1 - 0)) and (v110 > (819 - (667 + 151)))) or ((4067 - (1410 + 87)) == (3430 - (1504 + 393)))) then
			if (v23(v97.ChainLightning, not v16:IsSpellInRange(v97.ChainLightning)) or ((2386 - 1503) == (3787 - 2327))) then
				return "chain_lightning single_target 88";
			end
		end
		if ((v97.LightningBolt:IsAvailable() and v43 and v119() and v97.UnrelentingCalamity:IsAvailable()) or ((5415 - (461 + 335)) <= (128 + 871))) then
			if (v23(v97.LightningBolt, not v16:IsSpellInRange(v97.LightningBolt)) or ((5171 - (1730 + 31)) > (5783 - (728 + 939)))) then
				return "lightning_bolt single_target 90";
			end
		end
		if ((v97.Icefury:IsAvailable() and (v97.Icefury:CooldownRemains() == (0 - 0)) and v40) or ((1831 - 928) >= (7008 - 3949))) then
			if (v23(v97.Icefury, not v16:IsSpellInRange(v97.Icefury)) or ((5044 - (138 + 930)) < (2611 + 246))) then
				return "icefury single_target 92";
			end
		end
		if (((3855 + 1075) > (1978 + 329)) and v97.ChainLightning:IsAvailable() and v34 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v97.LightningRodDebuff) and (v16:DebuffUp(v97.ElectrifiedShocksDebuff) or v119()) and (v109 > (4 - 3)) and (v110 > (1767 - (459 + 1307)))) then
			if (v23(v97.ChainLightning, not v16:IsSpellInRange(v97.ChainLightning)) or ((5916 - (474 + 1396)) < (2254 - 963))) then
				return "chain_lightning single_target 94";
			end
		end
		if ((v97.LightningBolt:IsAvailable() and v43 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v97.LightningRodDebuff) and (v16:DebuffUp(v97.ElectrifiedShocksDebuff) or v119())) or ((3975 + 266) == (12 + 3533))) then
			if (v23(v97.LightningBolt, not v16:IsSpellInRange(v97.LightningBolt)) or ((11594 - 7546) > (537 + 3695))) then
				return "lightning_bolt single_target 96";
			end
		end
		if ((v97.FrostShock:IsCastable() and v39 and v121() and v119() and v13:BuffDown(v97.LavaSurgeBuff) and not v97.ElectrifiedShocks:IsAvailable() and not v97.FluxMelting:IsAvailable() and (v97.LavaBurst:ChargesFractional() < (3 - 2)) and v97.EchooftheElements:IsAvailable()) or ((7632 - 5882) >= (4064 - (562 + 29)))) then
			if (((2700 + 466) == (4585 - (374 + 1045))) and v23(v97.FrostShock, not v16:IsSpellInRange(v97.FrostShock))) then
				return "frost_shock single_target 98";
			end
		end
		if (((1396 + 367) < (11563 - 7839)) and v97.FrostShock:IsCastable() and v39 and v121() and (v97.FluxMelting:IsAvailable() or (v97.ElectrifiedShocks:IsAvailable() and not v97.LightningRod:IsAvailable()))) then
			if (((695 - (448 + 190)) <= (880 + 1843)) and v23(v97.FrostShock, not v16:IsSpellInRange(v97.FrostShock))) then
				return "frost_shock single_target 100";
			end
		end
		if ((v97.ChainLightning:IsAvailable() and v34 and v119() and v13:BuffDown(v97.LavaSurgeBuff) and (v97.LavaBurst:ChargesFractional() < (1 + 0)) and v97.EchooftheElements:IsAvailable() and (v109 > (1 + 0)) and (v110 > (3 - 2))) or ((6432 - 4362) == (1937 - (1307 + 187)))) then
			if (v23(v97.ChainLightning, not v16:IsSpellInRange(v97.ChainLightning)) or ((10726 - 8021) == (3261 - 1868))) then
				return "chain_lightning single_target 102";
			end
		end
		if ((v97.LightningBolt:IsAvailable() and v43 and v119() and v13:BuffDown(v97.LavaSurgeBuff) and (v97.LavaBurst:ChargesFractional() < (2 - 1)) and v97.EchooftheElements:IsAvailable()) or ((5284 - (232 + 451)) < (59 + 2))) then
			if (v23(v97.LightningBolt, not v16:IsSpellInRange(v97.LightningBolt)) or ((1228 + 162) >= (5308 - (510 + 54)))) then
				return "lightning_bolt single_target 104";
			end
		end
		if ((v97.FrostShock:IsCastable() and v39 and v121() and not v97.ElectrifiedShocks:IsAvailable() and not v97.FluxMelting:IsAvailable()) or ((4035 - 2032) > (3870 - (13 + 23)))) then
			if (v23(v97.FrostShock, not v16:IsSpellInRange(v97.FrostShock)) or ((303 - 147) > (5621 - 1708))) then
				return "frost_shock single_target 106";
			end
		end
		if (((353 - 158) == (1283 - (830 + 258))) and v97.ChainLightning:IsAvailable() and v34 and (v109 > (3 - 2)) and (v110 > (1 + 0))) then
			if (((2642 + 463) >= (3237 - (860 + 581))) and v23(v97.ChainLightning, not v16:IsSpellInRange(v97.ChainLightning))) then
				return "chain_lightning single_target 108";
			end
		end
		if (((16152 - 11773) >= (1692 + 439)) and v97.LightningBolt:IsAvailable() and v43) then
			if (((4085 - (237 + 4)) >= (4800 - 2757)) and v23(v97.LightningBolt, not v16:IsSpellInRange(v97.LightningBolt))) then
				return "lightning_bolt single_target 110";
			end
		end
		if ((v97.FlameShock:IsCastable() and UseFlameShock and (v13:IsMoving())) or ((8176 - 4944) <= (5177 - 2446))) then
			if (((4015 + 890) == (2818 + 2087)) and v101.CastCycle(v97.FlameShock, v108, v112, not v16:IsSpellInRange(v97.FlameShock))) then
				return "flame_shock single_target 112";
			end
		end
		if ((v97.FlameShock:IsCastable() and UseFlameShock) or ((15614 - 11478) >= (1893 + 2518))) then
			if (v23(v97.FlameShock, not v16:IsSpellInRange(v97.FlameShock)) or ((1609 + 1349) == (5443 - (85 + 1341)))) then
				return "flame_shock single_target 114";
			end
		end
		if (((2094 - 866) >= (2295 - 1482)) and v97.FrostShock:IsCastable() and v39) then
			if (v23(v97.FrostShock, not v16:IsSpellInRange(v97.FrostShock)) or ((3827 - (45 + 327)) > (7642 - 3592))) then
				return "frost_shock single_target 116";
			end
		end
	end
	local function v129()
		if (((745 - (444 + 58)) == (106 + 137)) and v71 and v97.EarthShield:IsCastable() and v13:BuffDown(v97.EarthShieldBuff) and ((v72 == "Earth Shield") or (v97.ElementalOrbit:IsAvailable() and v13:BuffUp(v97.LightningShield)))) then
			if (v23(v97.EarthShield) or ((47 + 224) > (769 + 803))) then
				return "earth_shield main 2";
			end
		elseif (((7937 - 5198) < (5025 - (64 + 1668))) and v71 and v97.LightningShield:IsCastable() and v13:BuffDown(v97.LightningShieldBuff) and ((v72 == "Lightning Shield") or (v97.ElementalOrbit:IsAvailable() and v13:BuffUp(v97.EarthShield)))) then
			if (v23(v97.LightningShield) or ((5915 - (1227 + 746)) < (3485 - 2351))) then
				return "lightning_shield main 2";
			end
		end
		v28 = v123();
		if (v28 or ((4997 - 2304) == (5467 - (415 + 79)))) then
			return v28;
		end
		if (((56 + 2090) == (2637 - (142 + 349))) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
			if (v23(v97.AncestralSpirit, nil, true) or ((962 + 1282) == (4432 - 1208))) then
				return "ancestral_spirit";
			end
		end
		if ((v97.AncestralSpirit:IsCastable() and v97.AncestralSpirit:IsReady() and not v13:AffectingCombat() and v14:Exists() and v14:IsDeadOrGhost() and v14:IsAPlayer() and not v13:CanAttack(v14)) or ((2438 + 2466) <= (1350 + 566))) then
			if (((245 - 155) <= (2929 - (1710 + 154))) and v23(v99.AncestralSpiritMouseover)) then
				return "ancestral_spirit mouseover";
			end
		end
		v105, v106 = v27();
		if (((5120 - (200 + 118)) == (1903 + 2899)) and v97.ImprovedFlametongueWeapon:IsAvailable() and v48 and (not v105 or (v106 < (1049061 - 449061))) and v97.FlametongueWeapon:IsAvailable()) then
			if (v23(v97.FlamentongueWeapon) or ((3381 - 1101) <= (455 + 56))) then
				return "flametongue_weapon enchant";
			end
		end
		if ((not v13:AffectingCombat() and v29 and v101.TargetIsValid()) or ((1658 + 18) <= (249 + 214))) then
			local v193 = 0 + 0;
			while true do
				if (((8381 - 4512) == (5119 - (363 + 887))) and (v193 == (0 - 0))) then
					v28 = v126();
					if (((5511 - 4353) <= (404 + 2209)) and v28) then
						return v28;
					end
					break;
				end
			end
		end
	end
	local function v130()
		local v151 = 0 - 0;
		while true do
			if ((v151 == (1 + 0)) or ((4028 - (674 + 990)) <= (574 + 1425))) then
				if (v83 or ((2015 + 2907) < (307 - 113))) then
					if (v78 or ((3146 - (507 + 548)) < (868 - (289 + 548)))) then
						v28 = v101.HandleAfflicted(v97.CleanseSpirit, v99.CleanseSpiritMouseover, 1858 - (821 + 997));
						if (v28 or ((2685 - (195 + 60)) >= (1311 + 3561))) then
							return v28;
						end
					end
					if (v79 or ((6271 - (251 + 1250)) < (5082 - 3347))) then
						v28 = v101.HandleAfflicted(v97.TremorTotem, v97.TremorTotem, 21 + 9);
						if (v28 or ((5471 - (809 + 223)) <= (3429 - 1079))) then
							return v28;
						end
					end
					if (v80 or ((13450 - 8971) < (14766 - 10300))) then
						local v218 = 0 + 0;
						while true do
							if (((1334 + 1213) > (1842 - (14 + 603))) and (v218 == (129 - (118 + 11)))) then
								v28 = v101.HandleAfflicted(v97.PoisonCleansingTotem, v97.PoisonCleansingTotem, 5 + 25);
								if (((3891 + 780) > (7792 - 5118)) and v28) then
									return v28;
								end
								break;
							end
						end
					end
				end
				if (v84 or ((4645 - (551 + 398)) < (2103 + 1224))) then
					local v213 = 0 + 0;
					while true do
						if ((v213 == (0 + 0)) or ((16891 - 12349) == (6843 - 3873))) then
							v28 = v101.HandleIncorporeal(v97.Hex, v99.HexMouseOver, 10 + 20, true);
							if (((1000 - 748) <= (546 + 1431)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				v151 = 91 - (40 + 49);
			end
			if ((v151 == (7 - 5)) or ((1926 - (99 + 391)) == (3123 + 652))) then
				if (Focus or ((7112 - 5494) < (2303 - 1373))) then
					if (((4601 + 122) > (10927 - 6774)) and v82) then
						v28 = v122();
						if (v28 or ((5258 - (1032 + 572)) >= (5071 - (203 + 214)))) then
							return v28;
						end
					end
				end
				if (((2768 - (568 + 1249)) <= (1171 + 325)) and v97.GreaterPurge:IsAvailable() and v94 and v97.GreaterPurge:IsReady() and v33 and v81 and not v13:IsCasting() and not v13:IsChanneling() and v101.UnitHasMagicBuff(v16)) then
					if (v23(v97.GreaterPurge, not v16:IsSpellInRange(v97.GreaterPurge)) or ((4169 - 2433) == (2205 - 1634))) then
						return "greater_purge damage";
					end
				end
				v151 = 1309 - (913 + 393);
			end
			if ((v151 == (8 - 5)) or ((1265 - 369) > (5179 - (269 + 141)))) then
				if ((v97.Purge:IsReady() and v94 and v33 and v81 and not v13:IsCasting() and not v13:IsChanneling() and v101.UnitHasMagicBuff(v16)) or ((2324 - 1279) <= (3001 - (362 + 1619)))) then
					if (v23(v97.Purge, not v16:IsSpellInRange(v97.Purge)) or ((2785 - (950 + 675)) <= (127 + 201))) then
						return "purge damage";
					end
				end
				if (((4987 - (216 + 963)) > (4211 - (485 + 802))) and v101.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) then
					if (((4450 - (432 + 127)) < (5992 - (1065 + 8))) and (v88 < v104) and v55 and ((v61 and v31) or not v61)) then
						if ((v97.BloodFury:IsCastable() and (not v97.Ascendance:IsAvailable() or v13:BuffUp(v97.AscendanceBuff) or (v97.Ascendance:CooldownRemains() > (28 + 22)))) or ((3835 - (635 + 966)) <= (1080 + 422))) then
							if (v23(v97.BloodFury) or ((2554 - (5 + 37)) < (1074 - 642))) then
								return "blood_fury main 2";
							end
						end
						if ((v97.Berserking:IsCastable() and (not v97.Ascendance:IsAvailable() or v13:BuffUp(v97.AscendanceBuff))) or ((769 + 1079) == (1369 - 504))) then
							if (v23(v97.Berserking) or ((2191 + 2491) <= (9435 - 4894))) then
								return "berserking main 4";
							end
						end
						if ((v97.Fireblood:IsCastable() and (not v97.Ascendance:IsAvailable() or v13:BuffUp(v97.AscendanceBuff) or (v97.Ascendance:CooldownRemains() > (189 - 139)))) or ((5706 - 2680) >= (9673 - 5627))) then
							if (((1444 + 564) > (1167 - (318 + 211))) and v23(v97.Fireblood)) then
								return "fireblood main 6";
							end
						end
						if (((8733 - 6958) <= (4820 - (963 + 624))) and v97.AncestralCall:IsCastable() and (not v97.Ascendance:IsAvailable() or v13:BuffUp(v97.AscendanceBuff) or (v97.Ascendance:CooldownRemains() > (22 + 28)))) then
							if (v23(v97.AncestralCall) or ((5389 - (518 + 328)) == (4655 - 2658))) then
								return "ancestral_call main 8";
							end
						end
						if ((v97.BagofTricks:IsCastable() and (not v97.Ascendance:IsAvailable() or v13:BuffUp(v97.AscendanceBuff))) or ((4957 - 1855) < (1045 - (301 + 16)))) then
							if (((1011 - 666) == (968 - 623)) and v23(v97.BagofTricks)) then
								return "bag_of_tricks main 10";
							end
						end
					end
					if ((v88 < v104) or ((7376 - 4549) < (343 + 35))) then
						if ((v54 and ((v31 and v60) or not v60)) or ((1974 + 1502) < (5544 - 2947))) then
							v28 = v125();
							if (((1853 + 1226) < (457 + 4337)) and v28) then
								return v28;
							end
						end
					end
					if (((15432 - 10578) > (1441 + 3023)) and v97.NaturesSwiftness:IsCastable() and v44) then
						if (v23(v97.NaturesSwiftness) or ((5931 - (829 + 190)) == (13408 - 9650))) then
							return "natures_swiftness main 12";
						end
					end
					local v214 = v101.HandleDPSPotion(v13:BuffUp(v97.AscendanceBuff));
					if (((159 - 33) <= (4813 - 1331)) and v214) then
						return v214;
					end
					if ((v30 and (v109 > (4 - 2)) and (v110 > (1 + 1))) or ((776 + 1598) == (13276 - 8902))) then
						local v219 = 0 + 0;
						while true do
							if (((2188 - (520 + 93)) == (1851 - (259 + 17))) and (v219 == (0 + 0))) then
								v28 = v127();
								if (v28 or ((804 + 1430) == (4925 - 3470))) then
									return v28;
								end
								v219 = 592 - (396 + 195);
							end
							if ((v219 == (2 - 1)) or ((2828 - (440 + 1321)) > (3608 - (1059 + 770)))) then
								if (((9992 - 7831) >= (1479 - (424 + 121))) and v23(v97.Pool)) then
									return "Pool for Aoe()";
								end
								break;
							end
						end
					end
					if (((294 + 1318) == (2959 - (641 + 706))) and true) then
						local v220 = 0 + 0;
						while true do
							if (((4792 - (249 + 191)) >= (12341 - 9508)) and (v220 == (1 + 0))) then
								if (v23(v97.Pool) or ((12418 - 9196) < (3500 - (183 + 244)))) then
									return "Pool for SingleTarget()";
								end
								break;
							end
							if (((37 + 707) <= (3672 - (434 + 296))) and ((0 - 0) == v220)) then
								v28 = v128();
								if (v28 or ((2345 - (169 + 343)) <= (1159 + 163))) then
									return v28;
								end
								v220 = 1 - 0;
							end
						end
					end
				end
				break;
			end
			if ((v151 == (0 - 0)) or ((2841 + 626) <= (2991 - 1936))) then
				v28 = v124();
				if (((4664 - (651 + 472)) == (2677 + 864)) and v28) then
					return v28;
				end
				v151 = 1 + 0;
			end
		end
	end
	local function v131()
		v34 = EpicSettings.Settings['useChainlightning'];
		v35 = EpicSettings.Settings['useEarthquake'];
		v36 = EpicSettings.Settings['useEarthshock'];
		v37 = EpicSettings.Settings['useElementalBlast'];
		UseFlameShock = EpicSettings.Settings['useFlameShock'];
		v39 = EpicSettings.Settings['useFrostShock'];
		v40 = EpicSettings.Settings['useIceFury'];
		v41 = EpicSettings.Settings['useLavaBeam'];
		v42 = EpicSettings.Settings['useLavaBurst'];
		v43 = EpicSettings.Settings['useLightningBolt'];
		v44 = EpicSettings.Settings['useNaturesSwiftness'];
		v45 = EpicSettings.Settings['usePrimordialWave'];
		v46 = EpicSettings.Settings['useStormkeeper'];
		v47 = EpicSettings.Settings['useTotemicRecall'];
		v48 = EpicSettings.Settings['useWeaponEnchant'];
		v50 = EpicSettings.Settings['useAscendance'];
		v52 = EpicSettings.Settings['useLiquidMagmaTotem'];
		v51 = EpicSettings.Settings['useFireElemental'];
		v53 = EpicSettings.Settings['useStormElemental'];
		v56 = EpicSettings.Settings['ascendanceWithCD'];
		v59 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
		v57 = EpicSettings.Settings['fireElementalWithCD'];
		v58 = EpicSettings.Settings['stormElementalWithCD'];
		v62 = EpicSettings.Settings['primordialWaveWithMiniCD'];
		v63 = EpicSettings.Settings['stormkeeperWithMiniCD'];
	end
	local function v132()
		v65 = EpicSettings.Settings['useWindShear'];
		v66 = EpicSettings.Settings['useCapacitorTotem'];
		v67 = EpicSettings.Settings['useThunderstorm'];
		v68 = EpicSettings.Settings['useAncestralGuidance'];
		v69 = EpicSettings.Settings['useAstralShift'];
		v70 = EpicSettings.Settings['useHealingStreamTotem'];
		v73 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 - 0);
		v74 = EpicSettings.Settings['ancestralGuidanceGroup'] or (483 - (397 + 86));
		v75 = EpicSettings.Settings['astralShiftHP'] or (876 - (423 + 453));
		v76 = EpicSettings.Settings['healingStreamTotemHP'] or (0 + 0);
		v77 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
		v49 = EpicSettings.Settings['earthquakeSetting'] or "";
		v64 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
		v71 = EpicSettings.Settings['autoShield'];
		v72 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
		v95 = EpicSettings.Settings['healOOC'];
		v96 = EpicSettings.Settings['healOOCHP'] or (0 + 0);
		v94 = EpicSettings.Settings['usePurgeTarget'];
		v78 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
		v79 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v80 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
	end
	local function v133()
		local v189 = 0 + 0;
		while true do
			if ((v189 == (1 + 0)) or ((4747 - (50 + 1140)) >= (3461 + 542))) then
				v87 = EpicSettings.Settings['InterruptThreshold'];
				v82 = EpicSettings.Settings['DispelDebuffs'];
				v81 = EpicSettings.Settings['DispelBuffs'];
				v189 = 2 + 0;
			end
			if ((v189 == (1 + 4)) or ((943 - 286) >= (1207 + 461))) then
				v83 = EpicSettings.Settings['handleAfflicted'];
				v84 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v189 == (600 - (157 + 439))) or ((1785 - 758) > (12819 - 8961))) then
				v92 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v91 = EpicSettings.Settings['healingPotionHP'] or (918 - (782 + 136));
				v93 = EpicSettings.Settings['HealingPotionName'] or "";
				v189 = 860 - (112 + 743);
			end
			if ((v189 == (1171 - (1026 + 145))) or ((628 + 3026) < (1168 - (493 + 225)))) then
				v88 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v85 = EpicSettings.Settings['InterruptWithStun'];
				v86 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v189 = 1 + 0;
			end
			if (((5069 - 3178) < (85 + 4368)) and (v189 == (8 - 5))) then
				v61 = EpicSettings.Settings['racialsWithCD'];
				v90 = EpicSettings.Settings['useHealthstone'];
				v89 = EpicSettings.Settings['useHealingPotion'];
				v189 = 2 + 2;
			end
			if ((v189 == (2 - 0)) or ((4735 - (210 + 1385)) < (3818 - (1201 + 488)))) then
				v54 = EpicSettings.Settings['useTrinkets'];
				v55 = EpicSettings.Settings['useRacials'];
				v60 = EpicSettings.Settings['trinketsWithCD'];
				v189 = 2 + 1;
			end
		end
	end
	local function v134()
		local v190 = 0 - 0;
		while true do
			if (((0 - 0) == v190) or ((3140 - (352 + 233)) < (2996 - 1756))) then
				v132();
				v131();
				v133();
				v29 = EpicSettings.Toggles['ooc'];
				v190 = 1 + 0;
			end
			if ((v190 == (2 - 1)) or ((5301 - (489 + 85)) <= (6223 - (277 + 1224)))) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v33 = EpicSettings.Toggles['dispel'];
				v32 = EpicSettings.Toggles['minicds'];
				v190 = 1495 - (663 + 830);
			end
			if (((650 + 90) < (12089 - 7152)) and (v190 == (878 - (461 + 414)))) then
				if (((614 + 3044) >= (113 + 167)) and (v13:AffectingCombat() or v82)) then
					local v215 = v82 and v97.CleanseSpirit:IsReady() and v33;
					v28 = v101.FocusUnit(v215, v99, 2 + 18, nil, 25 + 0);
					if (v28 or ((1135 - (172 + 78)) >= (1662 - 631))) then
						return v28;
					end
				end
				if (((1309 + 2245) >= (757 - 232)) and (v101.TargetIsValid() or v13:AffectingCombat())) then
					v103 = v9.BossFightRemains();
					v104 = v103;
					if (((659 + 1755) <= (993 + 1979)) and (v104 == (18615 - 7504))) then
						v104 = v9.FightRemains(v107, false);
					end
				end
				if (((4441 - 912) <= (890 + 2648)) and not v13:IsChanneling() and not v13:IsChanneling()) then
					local v216 = 0 + 0;
					while true do
						if ((v216 == (1 + 0)) or ((11388 - 8527) < (1066 - 608))) then
							if (((527 + 1190) <= (2584 + 1941)) and v13:AffectingCombat()) then
								local v221 = 447 - (133 + 314);
								while true do
									if (((0 + 0) == v221) or ((3391 - (199 + 14)) <= (5455 - 3931))) then
										v28 = v130();
										if (((5803 - (647 + 902)) > (1112 - 742)) and v28) then
											return v28;
										end
										break;
									end
								end
							else
								local v222 = 233 - (85 + 148);
								while true do
									if ((v222 == (1289 - (426 + 863))) or ((7652 - 6017) == (3431 - (873 + 781)))) then
										v28 = v129();
										if (v28 or ((4469 - 1131) >= (10783 - 6790))) then
											return v28;
										end
										break;
									end
								end
							end
							break;
						end
						if (((479 + 675) <= (5449 - 3974)) and (v216 == (0 - 0))) then
							if (Focus or ((7750 - 5140) < (3177 - (414 + 1533)))) then
								if (v82 or ((1256 + 192) == (3638 - (443 + 112)))) then
									local v223 = 1479 - (888 + 591);
									while true do
										if (((8110 - 4971) > (53 + 863)) and (v223 == (0 - 0))) then
											v28 = v122();
											if (((1154 + 1800) == (1429 + 1525)) and v28) then
												return v28;
											end
											break;
										end
									end
								end
							end
							if (((13 + 104) <= (5510 - 2618)) and v83) then
								if (v78 or ((838 - 385) > (6340 - (136 + 1542)))) then
									local v224 = 0 - 0;
									while true do
										if (((1311 + 9) > (946 - 351)) and (v224 == (0 + 0))) then
											v28 = v101.HandleAfflicted(v97.CleanseSpirit, v99.CleanseSpiritMouseover, 526 - (68 + 418));
											if (v28 or ((8671 - 5472) < (1070 - 480))) then
												return v28;
											end
											break;
										end
									end
								end
								if (v79 or ((4138 + 655) < (1122 - (770 + 322)))) then
									v28 = v101.HandleAfflicted(v97.TremorTotem, v97.TremorTotem, 2 + 28);
									if (v28 or ((491 + 1205) <= (145 + 914))) then
										return v28;
									end
								end
								if (((3351 - 1008) == (4542 - 2199)) and v80) then
									v28 = v101.HandleAfflicted(v97.PoisonCleansingTotem, v97.PoisonCleansingTotem, 81 - 51);
									if (v28 or ((3836 - 2793) > (2001 + 1590))) then
										return v28;
									end
								end
							end
							v216 = 1 - 0;
						end
					end
				end
				break;
			end
			if ((v190 == (1 + 1)) or ((1772 + 1118) >= (3197 + 882))) then
				if (((16847 - 12373) <= (6625 - 1855)) and v13:IsDeadOrGhost()) then
					return;
				end
				v107 = v13:GetEnemiesInRange(14 + 26);
				v108 = v16:GetEnemiesInSplashRange(23 - 18);
				if (v30 or ((16336 - 11394) == (1606 + 2297))) then
					v109 = #v107;
					v110 = max(v16:GetEnemiesInSplashRangeCount(24 - 19), v109);
				else
					local v217 = 831 - (762 + 69);
					while true do
						if ((v217 == (0 - 0)) or ((214 + 34) > (3137 + 1708))) then
							v109 = 2 - 1;
							v110 = 1 + 0;
							break;
						end
					end
				end
				v190 = 1 + 2;
			end
		end
	end
	local function v135()
		v97.FlameShockDebuff:RegisterAuraTracking();
		v102();
		v20.Print("Elemental Shaman by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(1020 - 758, v134, v135);
end;
return v0["Epix_Shaman_Elemental.lua"]();

