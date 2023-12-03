local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((430 + 1939) > (12398 - 7969))) then
			v6 = v0[v4];
			if (((4729 - (463 + 171)) >= (1133 + 2050)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
		end
		if ((v5 == (3 - 2)) or ((2799 + 912) < (2577 - 1569))) then
			return v6(...);
		end
	end
end
v0["Epix_Shaman_Elemental.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Player;
	local v15 = v12.MouseOver;
	local v16 = v12.Pet;
	local v17 = v12.Target;
	local v18 = v10.Spell;
	local v19 = v10.MultiSpell;
	local v20 = v10.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Macro;
	local v24 = v21.Press;
	local v25 = v21.Commons.Everyone.num;
	local v26 = v21.Commons.Everyone.bool;
	local v27 = GetTimelocal;
	local v28 = GetWeaponEnchantInfo;
	local v29;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
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
	local v97;
	local v98 = v18.Shaman.Elemental;
	local v99 = v20.Shaman.Elemental;
	local v100 = v23.Shaman.Elemental;
	local v101 = {};
	local v102 = v21.Commons.Everyone;
	local function v103()
		if (v98.CleanseSpirit:IsAvailable() or ((1737 - (364 + 324)) <= (2483 - 1577))) then
			v102.DispellableDebuffs = v102.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v103();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v10:RegisterForEvent(function()
		v98.PrimordialWave:RegisterInFlightEffect(785067 - 457905);
		v98.PrimordialWave:RegisterInFlight();
		v98.LavaBurst:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v98.PrimordialWave:RegisterInFlightEffect(108432 + 218730);
	v98.PrimordialWave:RegisterInFlight();
	v98.LavaBurst:RegisterInFlight();
	local v104 = 46492 - 35381;
	local v105 = 17794 - 6683;
	local v106, v107;
	local v108, v109;
	local v110 = 0 - 0;
	local v111 = 1268 - (1249 + 19);
	local function v112()
		return (37 + 3) - (v27() - Shaman.LastT302pcBuff);
	end
	local function v113(v137)
		return (v137:DebuffRefreshable(v98.FlameShockDebuff));
	end
	local function v114(v138)
		return v138:DebuffRefreshable(v98.FlameShockDebuff) and (v138:DebuffRemains(v98.FlameShockDebuff) < (v138:TimeToDie() - (19 - 14)));
	end
	local function v115(v139)
		return v139:DebuffRefreshable(v98.FlameShockDebuff) and (v139:DebuffRemains(v98.FlameShockDebuff) < (v139:TimeToDie() - (1091 - (686 + 400)))) and (v139:DebuffRemains(v98.FlameShockDebuff) > (0 + 0));
	end
	local function v116(v140)
		return (v140:DebuffRemains(v98.FlameShockDebuff));
	end
	local function v117(v141)
		return v141:DebuffRemains(v98.FlameShockDebuff) > (231 - (73 + 156));
	end
	local function v118(v142)
		return (v142:DebuffRemains(v98.LightningRodDebuff));
	end
	local function v119()
		local v143 = 0 + 0;
		local v144;
		while true do
			if (((5324 - (721 + 90)) > (31 + 2695)) and (v143 == (0 - 0))) then
				v144 = v14:Maelstrom();
				if (not v14:IsCasting() or ((1951 - (224 + 246)) >= (4305 - 1647))) then
					return v144;
				elseif (v14:IsCasting(v98.ElementalBlast) or ((5928 - 2708) == (248 + 1116))) then
					return v144 - (2 + 73);
				elseif (v14:IsCasting(v98.Icefury) or ((775 + 279) > (6743 - 3351))) then
					return v144 + (83 - 58);
				elseif (v14:IsCasting(v98.LightningBolt) or ((1189 - (203 + 310)) >= (3635 - (1238 + 755)))) then
					return v144 + 1 + 9;
				elseif (((5670 - (709 + 825)) > (4417 - 2020)) and v14:IsCasting(v98.LavaBurst)) then
					return v144 + (16 - 4);
				elseif (v14:IsCasting(v98.ChainLightning) or ((5198 - (196 + 668)) == (16760 - 12515))) then
					return v144 + ((7 - 3) * v111);
				else
					return v144;
				end
				break;
			end
		end
	end
	local function v120()
		if (not v98.MasteroftheElements:IsAvailable() or ((5109 - (171 + 662)) <= (3124 - (4 + 89)))) then
			return false;
		end
		local v145 = v14:BuffUp(v98.MasteroftheElementsBuff);
		if (not v14:IsCasting() or ((16760 - 11978) <= (437 + 762))) then
			return v145;
		elseif (v14:IsCasting(v98.LavaBurst) or ((21363 - 16499) < (746 + 1156))) then
			return true;
		elseif (((6325 - (35 + 1451)) >= (5153 - (28 + 1425))) and v14:IsCasting(v98.ElementalBlast)) then
			return false;
		elseif (v14:IsCasting(v98.Icefury) or ((3068 - (941 + 1052)) > (1840 + 78))) then
			return false;
		elseif (((1910 - (822 + 692)) <= (5430 - 1626)) and v14:IsCasting(v98.LightningBolt)) then
			return false;
		elseif (v14:IsCasting(v98.ChainLightning) or ((1964 + 2205) == (2484 - (45 + 252)))) then
			return false;
		else
			return v145;
		end
	end
	local function v121()
		if (((1392 + 14) == (484 + 922)) and not v98.Stormkeeper:IsAvailable()) then
			return false;
		end
		local v146 = v14:BuffUp(v98.StormkeeperBuff);
		if (((3725 - 2194) < (4704 - (114 + 319))) and not v14:IsCasting()) then
			return v146;
		elseif (((911 - 276) == (813 - 178)) and v14:IsCasting(v98.Stormkeeper)) then
			return true;
		else
			return v146;
		end
	end
	local function v122()
		if (((2151 + 1222) <= (5297 - 1741)) and not v98.Icefury:IsAvailable()) then
			return false;
		end
		local v147 = v14:BuffUp(v98.IcefuryBuff);
		if (not v14:IsCasting() or ((6895 - 3604) < (5243 - (556 + 1407)))) then
			return v147;
		elseif (((5592 - (741 + 465)) >= (1338 - (170 + 295))) and v14:IsCasting(v98.Icefury)) then
			return true;
		else
			return v147;
		end
	end
	local function v123()
		if (((486 + 435) <= (1013 + 89)) and v98.CleanseSpirit:IsReady() and v34 and v102.DispellableFriendlyUnit(61 - 36)) then
			if (((3902 + 804) >= (618 + 345)) and v24(v100.CleanseSpiritFocus)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v124()
		if ((v96 and (v14:HealthPercentage() <= v97)) or ((544 + 416) <= (2106 - (957 + 273)))) then
			if (v98.HealingSurge:IsReady() or ((553 + 1513) == (374 + 558))) then
				if (((18385 - 13560) < (12762 - 7919)) and v24(v98.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v125()
		if ((v98.AstralShift:IsReady() and v70 and (v14:HealthPercentage() <= v76)) or ((11841 - 7964) >= (22465 - 17928))) then
			if (v24(v98.AstralShift) or ((6095 - (389 + 1391)) < (1083 + 643))) then
				return "astral_shift defensive 1";
			end
		end
		if ((v98.AncestralGuidance:IsReady() and v69 and v102.AreUnitsBelowHealthPercentage(v74, v75)) or ((383 + 3296) < (1422 - 797))) then
			if (v24(v98.AncestralGuidance) or ((5576 - (783 + 168)) < (2120 - 1488))) then
				return "ancestral_guidance defensive 2";
			end
		end
		if ((v98.HealingStreamTotem:IsReady() and v71 and v102.AreUnitsBelowHealthPercentage(v77, v78)) or ((82 + 1) > (2091 - (309 + 2)))) then
			if (((1676 - 1130) <= (2289 - (1090 + 122))) and v24(v98.HealingStreamTotem)) then
				return "healing_stream_totem defensive 3";
			end
		end
		if ((v99.Healthstone:IsReady() and v91 and (v14:HealthPercentage() <= v93)) or ((323 + 673) > (14444 - 10143))) then
			if (((2786 + 1284) > (1805 - (628 + 490))) and v24(v100.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if ((v90 and (v14:HealthPercentage() <= v92)) or ((118 + 538) >= (8244 - 4914))) then
			if ((v94 == "Refreshing Healing Potion") or ((11388 - 8896) <= (1109 - (431 + 343)))) then
				if (((8728 - 4406) >= (7411 - 4849)) and v99.RefreshingHealingPotion:IsReady()) then
					if (v24(v100.RefreshingHealingPotion) or ((2874 + 763) >= (483 + 3287))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if ((v94 == "Dreamwalker's Healing Potion") or ((4074 - (556 + 1139)) > (4593 - (6 + 9)))) then
				if (v99.DreamwalkersHealingPotion:IsReady() or ((89 + 394) > (381 + 362))) then
					if (((2623 - (28 + 141)) > (224 + 354)) and v24(v100.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v126()
		v29 = v102.HandleTopTrinket(v101, v32, 49 - 9, nil);
		if (((659 + 271) < (5775 - (486 + 831))) and v29) then
			return v29;
		end
		v29 = v102.HandleBottomTrinket(v101, v32, 104 - 64, nil);
		if (((2330 - 1668) <= (184 + 788)) and v29) then
			return v29;
		end
	end
	local function v127()
		if (((13817 - 9447) == (5633 - (668 + 595))) and v98.Stormkeeper:IsCastable() and (v98.Stormkeeper:CooldownRemains() == (0 + 0)) and not v14:BuffUp(v98.StormkeeperBuff) and v47 and ((v64 and v33) or not v64) and (v89 < v105)) then
			if (v24(v98.Stormkeeper) or ((961 + 3801) <= (2348 - 1487))) then
				return "stormkeeper precombat 2";
			end
		end
		if ((v98.Icefury:IsCastable() and (v98.Icefury:CooldownRemains() == (290 - (23 + 267))) and v41) or ((3356 - (1129 + 815)) == (4651 - (371 + 16)))) then
			if (v24(v98.Icefury, not v17:IsSpellInRange(v98.Icefury)) or ((4918 - (1326 + 424)) < (4077 - 1924))) then
				return "icefury precombat 4";
			end
		end
		if ((v98.ElementalBlast:IsCastable() and v38) or ((18183 - 13207) < (1450 - (88 + 30)))) then
			if (((5399 - (720 + 51)) == (10294 - 5666)) and v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast))) then
				return "elemental_blast precombat 6";
			end
		end
		if ((v14:IsCasting(v98.ElementalBlast) and v46 and ((v63 and v33) or not v63) and v98.PrimordialWave:IsAvailable()) or ((1830 - (421 + 1355)) == (651 - 256))) then
			if (((41 + 41) == (1165 - (286 + 797))) and v24(v98.PrimordialWave, not v17:IsSpellInRange(v98.PrimordialWave))) then
				return "primordial_wave precombat 8";
			end
		end
		if ((v14:IsCasting(v98.ElementalBlast) and UseFlameShock and not v98.PrimordialWave:IsAvailable() and v98.FlameShock:IsReady()) or ((2123 - 1542) < (466 - 184))) then
			if (v24(v98.FlameShock, not v17:IsSpellInRange(v98.FlameShock)) or ((5048 - (397 + 42)) < (780 + 1715))) then
				return "flameshock precombat 10";
			end
		end
		if (((1952 - (24 + 776)) == (1774 - 622)) and v98.LavaBurst:IsCastable() and v43 and not v14:IsCasting(v98.LavaBurst) and (not v98.ElementalBlast:IsAvailable() or (v98.ElementalBlast:IsAvailable() and not v98.ElementalBlast:IsAvailable()))) then
			if (((2681 - (222 + 563)) <= (7539 - 4117)) and v24(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst))) then
				return "lavaburst precombat 12";
			end
		end
		if ((v14:IsCasting(v98.LavaBurst) and UseFlameShock and v98.FlameShock:IsReady()) or ((713 + 277) > (1810 - (23 + 167)))) then
			if (v24(v98.FlameShock, not v17:IsSpellInRange(v98.FlameShock)) or ((2675 - (690 + 1108)) > (1694 + 3001))) then
				return "flameshock precombat 14";
			end
		end
		if (((2220 + 471) >= (2699 - (40 + 808))) and v14:IsCasting(v98.LavaBurst) and v46 and ((v63 and v33) or not v63) and v98.PrimordialWave:IsAvailable()) then
			if (v24(v98.PrimordialWave, not v17:IsSpellInRange(v98.PrimordialWave)) or ((492 + 2493) >= (18569 - 13713))) then
				return "primordial_wave precombat 16";
			end
		end
	end
	local function v128()
		if (((4087 + 189) >= (633 + 562)) and v98.FireElemental:IsReady() and v52 and ((v58 and v32) or not v58) and (v89 < v105)) then
			if (((1773 + 1459) <= (5261 - (47 + 524))) and v24(v98.FireElemental)) then
				return "fire_elemental aoe 2";
			end
		end
		if ((v98.StormElemental:IsReady() and v54 and ((v59 and v32) or not v59) and (v89 < v105)) or ((582 + 314) >= (8599 - 5453))) then
			if (((4576 - 1515) >= (6745 - 3787)) and v24(v98.StormElemental)) then
				return "storm_elemental aoe 4";
			end
		end
		if (((4913 - (1165 + 561)) >= (20 + 624)) and v98.Stormkeeper:IsAvailable() and (v98.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v98.StormkeeperBuff) and v47 and ((v64 and v33) or not v64) and (v89 < v105) and not v121()) then
			if (((246 + 398) <= (1183 - (341 + 138))) and v24(v98.Stormkeeper)) then
				return "stormkeeper aoe 7";
			end
		end
		if (((259 + 699) > (1954 - 1007)) and v98.TotemicRecall:IsCastable() and (v98.LiquidMagmaTotem:CooldownRemains() > (371 - (89 + 237))) and v48) then
			if (((14450 - 9958) >= (5587 - 2933)) and v24(v98.TotemicRecall)) then
				return "totemic_recall aoe 8";
			end
		end
		if (((4323 - (581 + 300)) >= (2723 - (855 + 365))) and v98.LiquidMagmaTotem:IsReady() and v53 and ((v60 and v32) or not v60) and (v89 < v105) and (v65 == "cursor")) then
			if (v24(v100.LiquidMagmaTotemCursor, not v17:IsInRange(95 - 55)) or ((1036 + 2134) <= (2699 - (1030 + 205)))) then
				return "liquid_magma_totem aoe 10";
			end
		end
		if ((v98.LiquidMagmaTotem:IsReady() and v53 and ((v60 and v32) or not v60) and (v89 < v105) and (v65 == "player")) or ((4504 + 293) == (4082 + 306))) then
			if (((837 - (156 + 130)) <= (1547 - 866)) and v24(v100.LiquidMagmaTotemPlayer, not v17:IsInRange(67 - 27))) then
				return "liquid_magma_totem aoe 11";
			end
		end
		if (((6711 - 3434) > (108 + 299)) and v98.PrimordialWave:IsAvailable() and v46 and ((v63 and v33) or not v63) and v14:BuffDown(v98.PrimordialWaveBuff) and v14:BuffUp(v98.SurgeofPowerBuff) and v14:BuffDown(v98.SplinteredElementsBuff)) then
			if (((2738 + 1957) >= (1484 - (10 + 59))) and v102.CastTargetIf(v98.PrimordialWave, v109, "min", v116, nil, not v17:IsSpellInRange(v98.PrimordialWave), nil, Settings.Commons.DisplayStyle.Signature)) then
				return "primordial_wave aoe 12";
			end
		end
		if ((v98.PrimordialWave:IsAvailable() and v46 and ((v63 and v33) or not v63) and v14:BuffDown(v98.PrimordialWaveBuff) and v98.DeeplyRootedElements:IsAvailable() and not v98.SurgeofPower:IsAvailable() and v14:BuffDown(v98.SplinteredElementsBuff)) or ((909 + 2303) <= (4648 - 3704))) then
			if (v102.CastTargetIf(v98.PrimordialWave, v109, "min", v116, nil, not v17:IsSpellInRange(v98.PrimordialWave), nil, Settings.Commons.DisplayStyle.Signature) or ((4259 - (671 + 492)) <= (1432 + 366))) then
				return "primordial_wave aoe 14";
			end
		end
		if (((4752 - (369 + 846)) == (937 + 2600)) and v98.PrimordialWave:IsAvailable() and v46 and ((v63 and v33) or not v63) and v14:BuffDown(v98.PrimordialWaveBuff) and v98.MasteroftheElements:IsAvailable() and not v98.LightningRod:IsAvailable()) then
			if (((3275 + 562) >= (3515 - (1036 + 909))) and v102.CastTargetIf(v98.PrimordialWave, v109, "min", v116, nil, not v17:IsSpellInRange(v98.PrimordialWave), nil, Settings.Commons.DisplayStyle.Signature)) then
				return "primordial_wave aoe 16";
			end
		end
		if (v98.FlameShock:IsCastable() or ((2346 + 604) == (6399 - 2587))) then
			local v193 = 203 - (11 + 192);
			while true do
				if (((2387 + 2336) >= (2493 - (135 + 40))) and (v193 == (4 - 2))) then
					if ((v14:BuffUp(v98.SurgeofPowerBuff) and v39 and (not v98.LightningRod:IsAvailable() or v98.SkybreakersFieryDemise:IsAvailable())) or ((1222 + 805) > (6282 - 3430))) then
						if (v102.CastCycle(v98.FlameShock, v109, v115, not v17:IsSpellInRange(v98.FlameShock)) or ((1702 - 566) > (4493 - (50 + 126)))) then
							return "flame_shock aoe 26";
						end
					end
					if (((13220 - 8472) == (1051 + 3697)) and v98.MasteroftheElements:IsAvailable() and v39 and not v98.LightningRod:IsAvailable()) then
						if (((5149 - (1233 + 180)) <= (5709 - (522 + 447))) and v102.CastCycle(v98.FlameShock, v109, v115, not v17:IsSpellInRange(v98.FlameShock))) then
							return "flame_shock aoe 28";
						end
					end
					v193 = 1424 - (107 + 1314);
				end
				if ((v193 == (0 + 0)) or ((10329 - 6939) <= (1300 + 1760))) then
					if ((v14:BuffUp(v98.SurgeofPowerBuff) and v39 and v98.LightningRod:IsAvailable() and v98.WindspeakersLavaResurgence:IsAvailable() and (v17:DebuffRemains(v98.FlameShockDebuff) < (v17:TimeToDie() - (1 - 0)))) or ((3952 - 2953) > (4603 - (716 + 1194)))) then
						if (((8 + 455) < (65 + 536)) and v102.CastCycle(v98.FlameShock, v109, v114, not v17:IsSpellInRange(v98.FlameShock))) then
							return "flame_shock aoe 18";
						end
					end
					if ((v14:BuffUp(v98.SurgeofPowerBuff) and v39 and (not v98.LightningRod:IsAvailable() or v98.SkybreakersFieryDemise:IsAvailable()) and (v98.FlameShockDebuff:AuraActiveCount() < (509 - (74 + 429)))) or ((4210 - 2027) < (341 + 346))) then
						if (((10412 - 5863) == (3219 + 1330)) and v102.CastCycle(v98.FlameShock, v109, v114, not v17:IsSpellInRange(v98.FlameShock))) then
							return "flame_shock aoe 20";
						end
					end
					v193 = 2 - 1;
				end
				if (((11551 - 6879) == (5105 - (279 + 154))) and (v193 == (781 - (454 + 324)))) then
					if ((v98.DeeplyRootedElements:IsAvailable() and v39 and not v98.SurgeofPower:IsAvailable()) or ((2886 + 782) < (412 - (12 + 5)))) then
						if (v102.CastCycle(v98.FlameShock, v109, v115, not v17:IsSpellInRange(v98.FlameShock)) or ((2247 + 1919) == (1159 - 704))) then
							return "flame_shock aoe 30";
						end
					end
					break;
				end
				if (((1 + 0) == v193) or ((5542 - (277 + 816)) == (11379 - 8716))) then
					if ((v98.MasteroftheElements:IsAvailable() and v39 and not v98.LightningRod:IsAvailable() and (v98.FlameShockDebuff:AuraActiveCount() < (1189 - (1058 + 125)))) or ((802 + 3475) < (3964 - (815 + 160)))) then
						if (v102.CastCycle(v98.FlameShock, v109, v114, not v17:IsSpellInRange(v98.FlameShock)) or ((3732 - 2862) >= (9848 - 5699))) then
							return "flame_shock aoe 22";
						end
					end
					if (((528 + 1684) < (9304 - 6121)) and v98.DeeplyRootedElements:IsAvailable() and v39 and not v98.SurgeofPower:IsAvailable() and (v98.FlameShockDebuff:AuraActiveCount() < (1904 - (41 + 1857)))) then
						if (((6539 - (1222 + 671)) > (7732 - 4740)) and v102.CastCycle(v98.FlameShock, v109, v114, not v17:IsSpellInRange(v98.FlameShock))) then
							return "flame_shock aoe 24";
						end
					end
					v193 = 2 - 0;
				end
			end
		end
		if (((2616 - (229 + 953)) < (4880 - (1111 + 663))) and v98.Ascendance:IsCastable() and v51 and ((v57 and v32) or not v57) and (v89 < v105)) then
			if (((2365 - (874 + 705)) < (424 + 2599)) and v24(v98.Ascendance)) then
				return "ascendance aoe 32";
			end
		end
		if ((v98.LavaBurst:IsAvailable() and v43 and v14:BuffUp(v98.LavaSurgeBuff) and v98.MasteroftheElements:IsAvailable() and not v120() and (v119() >= (((41 + 19) - ((10 - 5) * v98.EyeoftheStorm:TalentRank())) - ((1 + 1) * v25(v98.FlowofPower:IsAvailable())))) and ((not v98.EchoesofGreatSundering:IsAvailable() and not v98.LightningRod:IsAvailable()) or v14:BuffUp(v98.EchoesofGreatSunderingBuff)) and ((v14:BuffDown(v98.AscendanceBuff) and (v110 > (682 - (642 + 37))) and not v98.UnrelentingCalamity:IsAvailable()) or (v111 == (1 + 2)))) or ((391 + 2051) < (185 - 111))) then
			if (((4989 - (233 + 221)) == (10486 - 5951)) and v102.CastCycle(v98.LavaBurst, v109, v116, not v17:IsSpellInRange(v98.LavaBurst))) then
				return "lava_burst aoe 34";
			end
		end
		if ((v98.Earthquake:IsReady() and v36 and (v50 == "cursor") and not v98.EchoesofGreatSundering:IsAvailable() and (v110 > (3 + 0)) and (v111 > (1544 - (718 + 823)))) or ((1894 + 1115) <= (2910 - (266 + 539)))) then
			if (((5181 - 3351) < (4894 - (636 + 589))) and v24(v100.EarthquakeCursor, not v17:IsInRange(94 - 54))) then
				return "earthquake aoe 36";
			end
		end
		if ((v98.Earthquake:IsReady() and v36 and (v50 == "player") and not v98.EchoesofGreatSundering:IsAvailable() and (v110 > (5 - 2)) and (v111 > (3 + 0))) or ((520 + 910) >= (4627 - (657 + 358)))) then
			if (((7103 - 4420) >= (5604 - 3144)) and v24(v100.EarthquakePlayer, not v17:IsInRange(1227 - (1151 + 36)))) then
				return "earthquake aoe 36";
			end
		end
		if ((v98.Earthquake:IsReady() and v36 and (v50 == "cursor") and not v98.EchoesofGreatSundering:IsAvailable() and not v98.ElementalBlast:IsAvailable() and (v110 == (3 + 0)) and (v111 == (1 + 2))) or ((5387 - 3583) >= (5107 - (1552 + 280)))) then
			if (v24(v100.EarthquakeCursor, not v17:IsInRange(874 - (64 + 770))) or ((963 + 454) > (8237 - 4608))) then
				return "earthquake aoe 38";
			end
		end
		if (((852 + 3943) > (1645 - (157 + 1086))) and v98.Earthquake:IsReady() and v36 and (v50 == "player") and not v98.EchoesofGreatSundering:IsAvailable() and not v98.ElementalBlast:IsAvailable() and (v110 == (5 - 2)) and (v111 == (13 - 10))) then
			if (((7382 - 2569) > (4865 - 1300)) and v24(v100.EarthquakePlayer, not v17:IsInRange(859 - (599 + 220)))) then
				return "earthquake aoe 38";
			end
		end
		if (((7789 - 3877) == (5843 - (1813 + 118))) and v98.Earthquake:IsReady() and v36 and (v50 == "cursor") and (v14:BuffUp(v98.EchoesofGreatSunderingBuff))) then
			if (((2063 + 758) <= (6041 - (841 + 376))) and v24(v100.EarthquakeCursor, not v17:IsInRange(56 - 16))) then
				return "earthquake aoe 40";
			end
		end
		if (((404 + 1334) <= (5991 - 3796)) and v98.Earthquake:IsReady() and v36 and (v50 == "player") and (v14:BuffUp(v98.EchoesofGreatSunderingBuff))) then
			if (((900 - (464 + 395)) <= (7745 - 4727)) and v24(v100.EarthquakePlayer, not v17:IsInRange(20 + 20))) then
				return "earthquake aoe 40";
			end
		end
		if (((2982 - (467 + 370)) <= (8480 - 4376)) and v98.ElementalBlast:IsAvailable() and v38 and (v98.EchoesofGreatSundering:IsAvailable())) then
			if (((1974 + 715) < (16608 - 11763)) and v102.CastTargetIf(v98.ElementalBlast, v109, "min", v118, nil, not v17:IsSpellInRange(v98.ElementalBlast))) then
				return "elemental_blast aoe 42";
			end
		end
		if ((v98.ElementalBlast:IsAvailable() and v38 and (v98.EchoesofGreatSundering:IsAvailable())) or ((363 + 1959) > (6100 - 3478))) then
			if (v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast)) or ((5054 - (150 + 370)) == (3364 - (74 + 1208)))) then
				return "elemental_blast aoe 44";
			end
		end
		if ((v98.ElementalBlast:IsAvailable() and v38 and (v110 == (7 - 4)) and not v98.EchoesofGreatSundering:IsAvailable()) or ((7450 - 5879) > (1329 + 538))) then
			if (v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast)) or ((3044 - (14 + 376)) >= (5196 - 2200))) then
				return "elemental_blast aoe 46";
			end
		end
		if (((2575 + 1403) > (1849 + 255)) and v98.EarthShock:IsReady() and v37 and (v98.EchoesofGreatSundering:IsAvailable())) then
			if (((2857 + 138) > (4515 - 2974)) and v102.CastTargetIf(v98.EarthShock, v109, "min", v118, nil, not v17:IsSpellInRange(v98.EarthShock))) then
				return "earth_shock aoe 48";
			end
		end
		if (((2445 + 804) > (1031 - (23 + 55))) and v98.EarthShock:IsReady() and v37 and (v98.EchoesofGreatSundering:IsAvailable())) then
			if (v24(v98.EarthShock, not v17:IsSpellInRange(v98.EarthShock)) or ((7756 - 4483) > (3052 + 1521))) then
				return "earth_shock aoe 50";
			end
		end
		if ((v98.Icefury:IsAvailable() and (v98.Icefury:CooldownRemains() == (0 + 0)) and v41 and v14:BuffDown(v98.AscendanceBuff) and v98.ElectrifiedShocks:IsAvailable() and ((v98.LightningRod:IsAvailable() and (v110 < (7 - 2)) and not v120()) or (v98.DeeplyRootedElements:IsAvailable() and (v110 == (1 + 2))))) or ((4052 - (652 + 249)) < (3436 - 2152))) then
			if (v24(v98.Icefury, not v17:IsSpellInRange(v98.Icefury)) or ((3718 - (708 + 1160)) == (4150 - 2621))) then
				return "icefury aoe 52";
			end
		end
		if (((1496 - 675) < (2150 - (10 + 17))) and v98.FrostShock:IsCastable() and v40 and v14:BuffDown(v98.AscendanceBuff) and v122() and v98.ElectrifiedShocks:IsAvailable() and (v17:DebuffDown(v98.ElectrifiedShocksDebuff) or (v14:BuffRemains(v98.IcefuryBuff) < v14:GCD())) and ((v98.LightningRod:IsAvailable() and (v110 < (2 + 3)) and not v120()) or (v98.DeeplyRootedElements:IsAvailable() and (v110 == (1735 - (1400 + 332)))))) then
			if (((1729 - 827) < (4233 - (242 + 1666))) and v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock))) then
				return "frost_shock moving aoe 54";
			end
		end
		if (((368 + 490) <= (1086 + 1876)) and v98.LavaBurst:IsAvailable() and v43 and v98.MasteroftheElements:IsAvailable() and not v120() and (v121() or (v14:HasTier(26 + 4, 942 - (850 + 90)) and (v112() < (4 - 1)))) and (v119() < ((((1450 - (360 + 1030)) - ((5 + 0) * v98.EyeoftheStorm:TalentRank())) - ((5 - 3) * v25(v98.FlowofPower:IsAvailable()))) - (13 - 3))) and (v110 < (1666 - (909 + 752)))) then
			if (v102.CastCycle(v98.LavaBurst, v109, v116, not v17:IsSpellInRange(v98.LavaBurst)) or ((5169 - (109 + 1114)) < (2357 - 1069))) then
				return "lava_burst aoe 56";
			end
		end
		if ((v98.LavaBeam:IsAvailable() and v42 and (v121())) or ((1263 + 1979) == (809 - (6 + 236)))) then
			if (v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam)) or ((534 + 313) >= (1017 + 246))) then
				return "lava_beam aoe 58";
			end
		end
		if ((v98.ChainLightning:IsAvailable() and v35 and (v121())) or ((5313 - 3060) == (3233 - 1382))) then
			if (v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning)) or ((3220 - (1076 + 57)) > (391 + 1981))) then
				return "chain_lightning aoe 60";
			end
		end
		if ((v98.LavaBeam:IsAvailable() and v42 and v14:BuffUp(v98.Power) and (v14:BuffRemains(v98.AscendanceBuff) > v98.LavaBeam:CastTime())) or ((5134 - (579 + 110)) < (328 + 3821))) then
			if (v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam)) or ((1608 + 210) == (46 + 39))) then
				return "lava_beam aoe 62";
			end
		end
		if (((1037 - (174 + 233)) < (5941 - 3814)) and v98.ChainLightning:IsAvailable() and v35 and (v120())) then
			if (v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning)) or ((3401 - 1463) == (1118 + 1396))) then
				return "chain_lightning aoe 64";
			end
		end
		if (((5429 - (663 + 511)) >= (50 + 5)) and v98.LavaBeam:IsAvailable() and v42 and (v110 >= (2 + 4)) and v14:BuffUp(v98.SurgeofPowerBuff) and (v14:BuffRemains(v98.AscendanceBuff) > v98.LavaBeam:CastTime())) then
			if (((9245 - 6246) > (701 + 455)) and v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam))) then
				return "lava_beam aoe 66";
			end
		end
		if (((5532 - 3182) > (2796 - 1641)) and v98.ChainLightning:IsAvailable() and v35 and (v110 >= (3 + 3)) and v14:BuffUp(v98.SurgeofPowerBuff)) then
			if (((7841 - 3812) <= (3459 + 1394)) and v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning))) then
				return "chain_lightning aoe 68";
			end
		end
		if ((v98.LavaBurst:IsAvailable() and v43 and v14:BuffUp(v98.LavaSurgeBuff) and v98.DeeplyRootedElements:IsAvailable() and v14:BuffUp(v98.WindspeakersLavaResurgenceBuff)) or ((48 + 468) > (4156 - (478 + 244)))) then
			if (((4563 - (440 + 77)) >= (1380 + 1653)) and v24(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst))) then
				return "lava_burst aoe 70";
			end
		end
		if ((v98.LavaBeam:IsAvailable() and v42 and v120() and (v14:BuffRemains(v98.AscendanceBuff) > v98.LavaBeam:CastTime())) or ((9951 - 7232) <= (3003 - (655 + 901)))) then
			if (v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam)) or ((767 + 3367) < (3006 + 920))) then
				return "lava_beam aoe 72";
			end
		end
		if ((v98.LavaBurst:IsAvailable() and v43 and (v110 == (3 + 0)) and v98.MasteroftheElements:IsAvailable()) or ((660 - 496) >= (4230 - (695 + 750)))) then
			if (v102.CastCycle(v98.LavaBurst, v109, v116, not v17:IsSpellInRange(v98.LavaBurst)) or ((1792 - 1267) == (3254 - 1145))) then
				return "lava_burst aoe 74";
			end
		end
		if (((132 - 99) == (384 - (285 + 66))) and v98.LavaBurst:IsAvailable() and v43 and v14:BuffUp(v98.LavaSurgeBuff) and v98.DeeplyRootedElements:IsAvailable()) then
			if (((7118 - 4064) <= (5325 - (682 + 628))) and v102.CastCycle(v98.LavaBurst, v109, v116, not v17:IsSpellInRange(v98.LavaBurst))) then
				return "lava_burst aoe 76";
			end
		end
		if (((302 + 1569) < (3681 - (176 + 123))) and v98.Icefury:IsAvailable() and (v98.Icefury:CooldownRemains() == (0 + 0)) and v41 and v98.ElectrifiedShocks:IsAvailable() and (v111 < (4 + 1))) then
			if (((1562 - (239 + 30)) <= (589 + 1577)) and v24(v98.Icefury, not v17:IsSpellInRange(v98.Icefury))) then
				return "icefury aoe 78";
			end
		end
		if ((v98.FrostShock:IsCastable() and v40 and v122() and v98.ElectrifiedShocks:IsAvailable() and v17:DebuffDown(v98.ElectrifiedShocksDebuff) and (v110 < (5 + 0)) and v98.UnrelentingCalamity:IsAvailable()) or ((4564 - 1985) < (383 - 260))) then
			if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or ((1161 - (306 + 9)) >= (8263 - 5895))) then
				return "frost_shock aoe 80";
			end
		end
		if ((v98.LavaBeam:IsAvailable() and v42 and (v14:BuffRemains(v98.AscendanceBuff) > v98.LavaBeam:CastTime())) or ((698 + 3314) <= (2061 + 1297))) then
			if (((720 + 774) <= (8593 - 5588)) and v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam))) then
				return "lava_beam aoe 82";
			end
		end
		if ((v98.ChainLightning:IsAvailable() and v35) or ((4486 - (1140 + 235)) == (1359 + 775))) then
			if (((2160 + 195) == (605 + 1750)) and v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning))) then
				return "chain_lightning aoe 84";
			end
		end
		if ((v98.FlameShock:IsCastable() and UseFlameShock) or ((640 - (33 + 19)) <= (156 + 276))) then
			if (((14377 - 9580) >= (1716 + 2179)) and v102.CastCycle(v98.FlameShock, v109, v113, not v17:IsSpellInRange(v98.FlameShock))) then
				return "flame_shock moving aoe 86";
			end
		end
		if (((7014 - 3437) == (3355 + 222)) and v98.FrostShock:IsCastable() and v40) then
			if (((4483 - (586 + 103)) > (337 + 3356)) and v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock))) then
				return "frost_shock moving aoe 88";
			end
		end
	end
	local function v129()
		if ((v98.FireElemental:IsCastable() and v52 and ((v58 and v32) or not v58) and (v89 < v105)) or ((3925 - 2650) == (5588 - (1309 + 179)))) then
			if (v24(v98.FireElemental) or ((2871 - 1280) >= (1559 + 2021))) then
				return "fire_elemental single_target 2";
			end
		end
		if (((2639 - 1656) <= (1366 + 442)) and v98.StormElemental:IsCastable() and v54 and ((v59 and v32) or not v59) and (v89 < v105)) then
			if (v24(v98.StormElemental) or ((4568 - 2418) <= (2384 - 1187))) then
				return "storm_elemental single_target 4";
			end
		end
		if (((4378 - (295 + 314)) >= (2880 - 1707)) and v98.TotemicRecall:IsCastable() and v48 and (v98.LiquidMagmaTotem:CooldownRemains() > (2007 - (1300 + 662))) and ((v98.LavaSurge:IsAvailable() and v98.SplinteredElements:IsAvailable()) or ((v110 > (3 - 2)) and (v111 > (1756 - (1178 + 577)))))) then
			if (((772 + 713) == (4389 - 2904)) and v24(v98.TotemicRecall)) then
				return "totemic_recall single_target 7";
			end
		end
		if ((v98.LiquidMagmaTotem:IsCastable() and v53 and ((v60 and v32) or not v60) and (v89 < v105) and (v65 == "cursor") and ((v98.LavaSurge:IsAvailable() and v98.SplinteredElements:IsAvailable()) or (v98.FlameShockDebuff:AuraActiveCount() == (1405 - (851 + 554))) or (v17:DebuffRemains(v98.FlameShockDebuff) < (6 + 0)) or ((v110 > (2 - 1)) and (v111 > (1 - 0))))) or ((3617 - (115 + 187)) <= (2131 + 651))) then
			if (v24(v100.LiquidMagmaTotemCursor, not v17:IsInRange(38 + 2)) or ((3451 - 2575) >= (4125 - (160 + 1001)))) then
				return "liquid_magma_totem single_target 8";
			end
		end
		if ((v98.LiquidMagmaTotem:IsCastable() and v53 and ((v60 and v32) or not v60) and (v89 < v105) and (v65 == "player") and ((v98.LavaSurge:IsAvailable() and v98.SplinteredElements:IsAvailable()) or (v98.FlameShockDebuff:AuraActiveCount() == (0 + 0)) or (v17:DebuffRemains(v98.FlameShockDebuff) < (5 + 1)) or ((v110 > (1 - 0)) and (v111 > (359 - (237 + 121)))))) or ((3129 - (525 + 372)) > (4733 - 2236))) then
			if (v24(v100.LiquidMagmaTotemPlayer, not v17:IsInRange(131 - 91)) or ((2252 - (96 + 46)) <= (1109 - (643 + 134)))) then
				return "liquid_magma_totem single_target 8";
			end
		end
		if (((1331 + 2355) > (7605 - 4433)) and v98.PrimordialWave:IsAvailable() and v46 and v63 and (v89 < v105) and v33 and v14:BuffDown(v98.PrimordialWaveBuff) and v14:BuffDown(v98.SplinteredElementsBuff)) then
			if (v102.CastTargetIf(v98.PrimordialWave, v109, "min", v116, nil, not v17:IsSpellInRange(v98.PrimordialWave), nil, Settings.Commons.DisplayStyle.Signature) or ((16610 - 12136) < (787 + 33))) then
				return "primordial_wave single_target 10";
			end
		end
		if (((8397 - 4118) >= (5890 - 3008)) and v98.FlameShock:IsCastable() and UseFlameShock and (v110 == (720 - (316 + 403))) and v17:DebuffRefreshable(v98.FlameShockDebuff) and v14:BuffDown(v98.SurgeofPowerBuff) and (not v120() or (not v121() and ((v98.ElementalBlast:IsAvailable() and (v119() < ((60 + 30) - ((21 - 13) * v98.EyeoftheStorm:TalentRank())))) or (v119() < ((22 + 38) - ((12 - 7) * v98.EyeoftheStorm:TalentRank()))))))) then
			if (v24(v98.FlameShock, not v17:IsSpellInRange(v98.FlameShock)) or ((1438 + 591) >= (1135 + 2386))) then
				return "flame_shock single_target 12";
			end
		end
		if ((v98.FlameShock:IsCastable() and UseFlameShock and (v98.FlameShockDebuff:AuraActiveCount() == (0 - 0)) and (v110 > (4 - 3)) and (v111 > (1 - 0)) and (v98.DeeplyRootedElements:IsAvailable() or v98.Ascendance:IsAvailable() or v98.PrimordialWave:IsAvailable() or v98.SearingFlames:IsAvailable() or v98.MagmaChamber:IsAvailable()) and ((not v120() and (v121() or (v98.Stormkeeper:CooldownRemains() > (0 + 0)))) or not v98.SurgeofPower:IsAvailable())) or ((4009 - 1972) >= (227 + 4415))) then
			if (((5060 - 3340) < (4475 - (12 + 5))) and v102.CastTargetIf(v98.FlameShock, v109, "min", v116, nil, not v17:IsSpellInRange(v98.FlameShock))) then
				return "flame_shock single_target 14";
			end
		end
		if ((v98.FlameShock:IsCastable() and UseFlameShock and (v110 > (3 - 2)) and (v111 > (1 - 0)) and (v98.DeeplyRootedElements:IsAvailable() or v98.Ascendance:IsAvailable() or v98.PrimordialWave:IsAvailable() or v98.SearingFlames:IsAvailable() or v98.MagmaChamber:IsAvailable()) and ((v14:BuffUp(v98.SurgeofPowerBuff) and not v121() and v98.Stormkeeper:IsAvailable()) or not v98.SurgeofPower:IsAvailable())) or ((926 - 490) > (7491 - 4470))) then
			if (((145 + 568) <= (2820 - (1656 + 317))) and v102.CastTargetIf(v98.FlameShock, v109, "min", v116, v113, not v17:IsSpellInRange(v98.FlameShock))) then
				return "flame_shock single_target 16";
			end
		end
		if (((1920 + 234) <= (3231 + 800)) and v98.Stormkeeper:IsAvailable() and (v98.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v98.StormkeeperBuff) and v47 and ((v64 and v33) or not v64) and (v89 < v105) and v14:BuffDown(v98.AscendanceBuff) and not v121() and (v119() >= (570 - 454)) and v98.ElementalBlast:IsAvailable() and v98.SurgeofPower:IsAvailable() and v98.SwellingMaelstrom:IsAvailable() and not v98.LavaSurge:IsAvailable() and not v98.EchooftheElements:IsAvailable() and not v98.PrimordialSurge:IsAvailable()) then
			if (((4969 - (5 + 349)) == (21920 - 17305)) and v24(v98.Stormkeeper)) then
				return "stormkeeper single_target 18";
			end
		end
		if ((v98.Stormkeeper:IsAvailable() and (v98.Stormkeeper:CooldownRemains() == (1271 - (266 + 1005))) and not v14:BuffUp(v98.StormkeeperBuff) and v47 and ((v64 and v33) or not v64) and (v89 < v105) and v14:BuffDown(v98.AscendanceBuff) and not v121() and v14:BuffUp(v98.SurgeofPowerBuff) and not v98.LavaSurge:IsAvailable() and not v98.EchooftheElements:IsAvailable() and not v98.PrimordialSurge:IsAvailable()) or ((2498 + 1292) == (1706 - 1206))) then
			if (((116 - 27) < (1917 - (561 + 1135))) and v24(v98.Stormkeeper)) then
				return "stormkeeper single_target 20";
			end
		end
		if (((2676 - 622) >= (4670 - 3249)) and v98.Stormkeeper:IsAvailable() and (v98.Stormkeeper:CooldownRemains() == (1066 - (507 + 559))) and not v14:BuffUp(v98.StormkeeperBuff) and v47 and ((v64 and v33) or not v64) and (v89 < v105) and v14:BuffDown(v98.AscendanceBuff) and not v121() and (not v98.SurgeofPower:IsAvailable() or not v98.ElementalBlast:IsAvailable() or v98.LavaSurge:IsAvailable() or v98.EchooftheElements:IsAvailable() or v98.PrimordialSurge:IsAvailable())) then
			if (((1736 - 1044) < (9457 - 6399)) and v24(v98.Stormkeeper)) then
				return "stormkeeper single_target 22";
			end
		end
		if ((v98.Ascendance:IsCastable() and v51 and ((v57 and v32) or not v57) and (v89 < v105) and not v121()) or ((3642 - (212 + 176)) == (2560 - (250 + 655)))) then
			if (v24(v98.Ascendance) or ((3533 - 2237) == (8579 - 3669))) then
				return "ascendance single_target 24";
			end
		end
		if (((5268 - 1900) == (5324 - (1869 + 87))) and v98.LightningBolt:IsAvailable() and v44 and v121() and v14:BuffUp(v98.SurgeofPowerBuff)) then
			if (((9166 - 6523) < (5716 - (484 + 1417))) and v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt))) then
				return "lightning_bolt single_target 26";
			end
		end
		if (((4100 - 2187) > (825 - 332)) and v98.LavaBeam:IsCastable() and v42 and (v110 > (774 - (48 + 725))) and (v111 > (1 - 0)) and v121() and not v98.SurgeofPower:IsAvailable()) then
			if (((12757 - 8002) > (1993 + 1435)) and v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam))) then
				return "lava_beam single_target 28";
			end
		end
		if (((3690 - 2309) <= (663 + 1706)) and v98.ChainLightning:IsAvailable() and v35 and (v110 > (1 + 0)) and (v111 > (854 - (152 + 701))) and v121() and not v98.SurgeofPower:IsAvailable()) then
			if (v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning)) or ((6154 - (430 + 881)) == (1565 + 2519))) then
				return "chain_lightning single_target 30";
			end
		end
		if (((5564 - (557 + 338)) > (108 + 255)) and v98.LavaBurst:IsAvailable() and v43 and v121() and not v120() and not v98.SurgeofPower:IsAvailable() and v98.MasteroftheElements:IsAvailable()) then
			if (v24(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst)) or ((5289 - 3412) >= (10988 - 7850))) then
				return "lava_burst single_target 32";
			end
		end
		if (((12598 - 7856) >= (7814 - 4188)) and v98.LightningBolt:IsAvailable() and v44 and v121() and not v98.SurgeofPower:IsAvailable() and v120()) then
			if (v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt)) or ((5341 - (499 + 302)) == (1782 - (39 + 827)))) then
				return "lightning_bolt single_target 34";
			end
		end
		if ((v98.LightningBolt:IsAvailable() and v44 and v121() and not v98.SurgeofPower:IsAvailable() and not v98.MasteroftheElements:IsAvailable()) or ((3190 - 2034) > (9704 - 5359))) then
			if (((8884 - 6647) < (6522 - 2273)) and v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt))) then
				return "lightning_bolt single_target 36";
			end
		end
		if ((v98.LightningBolt:IsAvailable() and v44 and v14:BuffUp(v98.SurgeofPowerBuff) and v98.LightningRod:IsAvailable()) or ((230 + 2453) < (67 - 44))) then
			if (((112 + 585) <= (1306 - 480)) and v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt))) then
				return "lightning_bolt single_target 38";
			end
		end
		if (((1209 - (103 + 1)) <= (1730 - (475 + 79))) and v98.Icefury:IsAvailable() and (v98.Icefury:CooldownRemains() == (0 - 0)) and v41 and v98.ElectrifiedShocks:IsAvailable() and v98.LightningRod:IsAvailable() and v98.LightningRod:IsAvailable()) then
			if (((10812 - 7433) <= (493 + 3319)) and v24(v98.Icefury, not v17:IsSpellInRange(v98.Icefury))) then
				return "icefury single_target 40";
			end
		end
		if ((v98.FrostShock:IsCastable() and v40 and v122() and v98.ElectrifiedShocks:IsAvailable() and ((v17:DebuffRemains(v98.ElectrifiedShocksDebuff) < (2 + 0)) or (v14:BuffRemains(v98.IcefuryBuff) <= v14:GCD())) and v98.LightningRod:IsAvailable()) or ((2291 - (1395 + 108)) >= (4702 - 3086))) then
			if (((3058 - (7 + 1197)) <= (1474 + 1905)) and v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock))) then
				return "frost_shock single_target 42";
			end
		end
		if (((1588 + 2961) == (4868 - (27 + 292))) and v98.FrostShock:IsCastable() and v40 and v122() and v98.ElectrifiedShocks:IsAvailable() and (v119() >= (146 - 96)) and (v17:DebuffRemains(v98.ElectrifiedShocksDebuff) < ((2 - 0) * v14:GCD())) and v121() and v98.LightningRod:IsAvailable()) then
			if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or ((12673 - 9651) >= (5963 - 2939))) then
				return "frost_shock single_target 44";
			end
		end
		if (((9179 - 4359) > (2337 - (43 + 96))) and v98.LavaBeam:IsCastable() and v42 and (v110 > (4 - 3)) and (v111 > (1 - 0)) and v120() and (v14:BuffRemains(v98.AscendanceBuff) > v98.LavaBeam:CastTime()) and not v14:HasTier(26 + 5, 2 + 2)) then
			if (v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam)) or ((2096 - 1035) >= (1875 + 3016))) then
				return "lava_beam single_target 46";
			end
		end
		if (((2555 - 1191) <= (1409 + 3064)) and v98.FrostShock:IsCastable() and v40 and v122() and v121() and not v98.LavaSurge:IsAvailable() and not v98.EchooftheElements:IsAvailable() and not v98.PrimordialSurge:IsAvailable() and v98.ElementalBlast:IsAvailable() and (((v119() >= (5 + 56)) and (v119() < (1826 - (1414 + 337))) and (v98.LavaBurst:CooldownRemains() > v14:GCD())) or ((v119() >= (1989 - (1642 + 298))) and (v119() < (163 - 100)) and (v98.LavaBurst:CooldownRemains() > (0 - 0))))) then
			if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or ((10668 - 7073) <= (1 + 2))) then
				return "frost_shock single_target 48";
			end
		end
		if ((v98.FrostShock:IsCastable() and v40 and v122() and not v98.LavaSurge:IsAvailable() and not v98.EchooftheElements:IsAvailable() and not v98.ElementalBlast:IsAvailable() and (((v119() >= (29 + 7)) and (v119() < (1022 - (357 + 615))) and (v98.LavaBurst:CooldownRemains() > v14:GCD())) or ((v119() >= (17 + 7)) and (v119() < (93 - 55)) and (v98.LavaBurst:CooldownRemains() > (0 + 0))))) or ((10012 - 5340) == (3081 + 771))) then
			if (((106 + 1453) == (980 + 579)) and v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock))) then
				return "frost_shock single_target 50";
			end
		end
		if ((v98.LavaBurst:IsAvailable() and v43 and v14:BuffUp(v98.WindspeakersLavaResurgenceBuff) and (v98.EchooftheElements:IsAvailable() or v98.LavaSurge:IsAvailable() or v98.PrimordialSurge:IsAvailable() or ((v119() >= (1364 - (384 + 917))) and v98.MasteroftheElements:IsAvailable()) or ((v119() >= (735 - (128 + 569))) and v14:BuffUp(v98.EchoesofGreatSunderingBuff) and (v110 > (1544 - (1407 + 136))) and (v111 > (1888 - (687 + 1200)))) or not v98.ElementalBlast:IsAvailable())) or ((3462 - (556 + 1154)) <= (2772 - 1984))) then
			if (v24(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst)) or ((4002 - (9 + 86)) == (598 - (275 + 146)))) then
				return "lava_burst single_target 52";
			end
		end
		if (((565 + 2905) > (619 - (29 + 35))) and v98.LavaBurst:IsAvailable() and v43 and v14:BuffUp(v98.LavaSurgeBuff) and (v98.EchooftheElements:IsAvailable() or v98.LavaSurge:IsAvailable() or v98.PrimordialSurge:IsAvailable() or not v98.MasteroftheElements:IsAvailable() or not v98.ElementalBlast:IsAvailable())) then
			if (v24(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst)) or ((4307 - 3335) == (1926 - 1281))) then
				return "lava_burst single_target 54";
			end
		end
		if (((14046 - 10864) >= (1378 + 737)) and v98.LavaBurst:IsAvailable() and v43 and v14:BuffUp(v98.AscendanceBuff) and (v14:HasTier(1043 - (53 + 959), 412 - (312 + 96)) or not v98.ElementalBlast:IsAvailable())) then
			if (((6756 - 2863) < (4714 - (147 + 138))) and v102.CastCycle(v98.LavaBurst, v109, v117, not v17:IsSpellInRange(v98.LavaBurst))) then
				return "lava_burst single_target 56";
			end
		end
		if ((v98.LavaBurst:IsAvailable() and v43 and v14:BuffDown(v98.AscendanceBuff) and (not v98.ElementalBlast:IsAvailable() or not v98.MountainsWillFall:IsAvailable()) and not v98.LightningRod:IsAvailable() and v14:HasTier(930 - (813 + 86), 4 + 0)) or ((5311 - 2444) < (2397 - (18 + 474)))) then
			if (v102.CastCycle(v98.LavaBurst, v109, v117, not v17:IsSpellInRange(v98.LavaBurst)) or ((606 + 1190) >= (13221 - 9170))) then
				return "lava_burst single_target 58";
			end
		end
		if (((2705 - (860 + 226)) <= (4059 - (121 + 182))) and v98.LavaBurst:IsAvailable() and v43 and v98.MasteroftheElements:IsAvailable() and not v120() and not v98.LightningRod:IsAvailable()) then
			if (((75 + 529) == (1844 - (988 + 252))) and v102.CastCycle(v98.LavaBurst, v109, v117, not v17:IsSpellInRange(v98.LavaBurst))) then
				return "lava_burst single_target 60";
			end
		end
		if ((v98.LavaBurst:IsAvailable() and v43 and v98.MasteroftheElements:IsAvailable() and not v120() and ((v119() >= (9 + 66)) or ((v119() >= (16 + 34)) and not v98.ElementalBlast:IsAvailable())) and v98.SwellingMaelstrom:IsAvailable() and (v119() <= (2100 - (49 + 1921)))) or ((5374 - (223 + 667)) == (952 - (51 + 1)))) then
			if (v22(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst)) or ((7674 - 3215) <= (2383 - 1270))) then
				return "lava_burst single_target 62";
			end
		end
		if (((4757 - (146 + 979)) > (960 + 2438)) and v98.Earthquake:IsReady() and v36 and (v50 == "cursor") and v14:BuffUp(v98.EchoesofGreatSunderingBuff) and ((not v98.ElementalBlast:IsAvailable() and (v110 < (607 - (311 + 294)))) or (v110 > (2 - 1)))) then
			if (((1730 + 2352) <= (6360 - (496 + 947))) and v24(v100.EarthquakeCursor, not v17:IsInRange(1398 - (1233 + 125)))) then
				return "earthquake single_target 64";
			end
		end
		if (((1961 + 2871) >= (1244 + 142)) and v98.Earthquake:IsReady() and v36 and (v50 == "player") and v14:BuffUp(v98.EchoesofGreatSunderingBuff) and ((not v98.ElementalBlast:IsAvailable() and (v110 < (1 + 1))) or (v110 > (1646 - (963 + 682))))) then
			if (((115 + 22) == (1641 - (504 + 1000))) and v24(v100.EarthquakePlayer, not v17:IsInRange(27 + 13))) then
				return "earthquake single_target 64";
			end
		end
		if ((v98.Earthquake:IsReady() and v36 and (v50 == "cursor") and (v110 > (1 + 0)) and (v111 > (1 + 0)) and not v98.EchoesofGreatSundering:IsAvailable() and not v98.ElementalBlast:IsAvailable()) or ((2315 - 745) >= (3702 + 630))) then
			if (v24(v100.EarthquakeCursor, not v17:IsInRange(24 + 16)) or ((4246 - (156 + 26)) <= (1048 + 771))) then
				return "earthquake single_target 66";
			end
		end
		if ((v98.Earthquake:IsReady() and v36 and (v50 == "player") and (v110 > (1 - 0)) and (v111 > (165 - (149 + 15))) and not v98.EchoesofGreatSundering:IsAvailable() and not v98.ElementalBlast:IsAvailable()) or ((5946 - (890 + 70)) < (1691 - (39 + 78)))) then
			if (((4908 - (14 + 468)) > (378 - 206)) and v24(v100.EarthquakePlayer, not v17:IsInRange(111 - 71))) then
				return "earthquake single_target 66";
			end
		end
		if (((303 + 283) > (274 + 181)) and v98.ElementalBlast:IsAvailable() and v38 and (not v98.MasteroftheElements:IsAvailable() or (v120() and v17:DebuffUp(v98.ElectrifiedShocksDebuff)))) then
			if (((176 + 650) == (374 + 452)) and v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast))) then
				return "elemental_blast single_target 68";
			end
		end
		if ((v98.FrostShock:IsCastable() and v40 and v122() and v120() and (v119() < (29 + 81)) and (v98.LavaBurst:ChargesFractional() < (1 - 0)) and v98.ElectrifiedShocks:IsAvailable() and v98.ElementalBlast:IsAvailable() and not v98.LightningRod:IsAvailable()) or ((3973 + 46) > (15605 - 11164))) then
			if (((51 + 1966) < (4312 - (12 + 39))) and v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock))) then
				return "frost_shock single_target 70";
			end
		end
		if (((4388 + 328) > (247 - 167)) and v98.ElementalBlast:IsAvailable() and v38 and (v120() or v98.LightningRod:IsAvailable())) then
			if (v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast)) or ((12490 - 8983) == (971 + 2301))) then
				return "elemental_blast single_target 72";
			end
		end
		if ((v98.EarthShock:IsReady() and v37) or ((462 + 414) >= (7797 - 4722))) then
			if (((2899 + 1453) > (12342 - 9788)) and v24(v98.EarthShock, not v17:IsSpellInRange(v98.EarthShock))) then
				return "earth_shock single_target 74";
			end
		end
		if ((v98.FrostShock:IsCastable() and v40 and v122() and v98.ElectrifiedShocks:IsAvailable() and v120() and not v98.LightningRod:IsAvailable() and (v110 > (1711 - (1596 + 114))) and (v111 > (2 - 1))) or ((5119 - (164 + 549)) < (5481 - (1059 + 379)))) then
			if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or ((2344 - 455) >= (1754 + 1629))) then
				return "frost_shock single_target 76";
			end
		end
		if (((319 + 1573) <= (3126 - (145 + 247))) and v98.LavaBurst:IsAvailable() and v43 and v14:BuffUp(v98.FluxMeltingBuff) and (v110 > (1 + 0))) then
			if (((889 + 1034) < (6575 - 4357)) and v102.CastCycle(v98.LavaBurst, v109, v117, not v17:IsSpellInRange(v98.LavaBurst))) then
				return "lava_burst single_target 78";
			end
		end
		if (((417 + 1756) > (327 + 52)) and v98.FrostShock:IsCastable() and v40 and v122() and v98.FluxMelting:IsAvailable() and v14:BuffDown(v98.FluxMeltingBuff)) then
			if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or ((4206 - 1615) == (4129 - (254 + 466)))) then
				return "frost_shock single_target 80";
			end
		end
		if (((5074 - (544 + 16)) > (10563 - 7239)) and v98.FrostShock:IsCastable() and v40 and v122() and ((v98.ElectrifiedShocks:IsAvailable() and (v17:DebuffRemains(v98.ElectrifiedShocksDebuff) < (630 - (294 + 334)))) or (v14:BuffRemains(v98.IcefuryBuff) < (259 - (236 + 17))))) then
			if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or ((90 + 118) >= (3759 + 1069))) then
				return "frost_shock single_target 82";
			end
		end
		if ((v98.LavaBurst:IsAvailable() and v43 and (v98.EchooftheElements:IsAvailable() or v98.LavaSurge:IsAvailable() or v98.PrimordialSurge:IsAvailable() or not v98.ElementalBlast:IsAvailable() or not v98.MasteroftheElements:IsAvailable() or v121())) or ((5961 - 4378) > (16888 - 13321))) then
			if (v102.CastCycle(v98.LavaBurst, v109, v117, not v17:IsSpellInRange(v98.LavaBurst)) or ((677 + 636) == (654 + 140))) then
				return "lava_burst single_target 84";
			end
		end
		if (((3968 - (413 + 381)) > (123 + 2779)) and v98.ElementalBlast:IsAvailable() and v38) then
			if (((8762 - 4642) <= (11065 - 6805)) and v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast))) then
				return "elemental_blast single_target 86";
			end
		end
		if ((v98.ChainLightning:IsAvailable() and v35 and v120() and v98.UnrelentingCalamity:IsAvailable() and (v110 > (1971 - (582 + 1388))) and (v111 > (1 - 0))) or ((633 + 250) > (5142 - (326 + 38)))) then
			if (v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning)) or ((10708 - 7088) >= (6982 - 2091))) then
				return "chain_lightning single_target 88";
			end
		end
		if (((4878 - (47 + 573)) > (331 + 606)) and v98.LightningBolt:IsAvailable() and v44 and v120() and v98.UnrelentingCalamity:IsAvailable()) then
			if (v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt)) or ((20678 - 15809) < (1470 - 564))) then
				return "lightning_bolt single_target 90";
			end
		end
		if ((v98.Icefury:IsAvailable() and (v98.Icefury:CooldownRemains() == (1664 - (1269 + 395))) and v41) or ((1717 - (76 + 416)) > (4671 - (319 + 124)))) then
			if (((7607 - 4279) > (3245 - (564 + 443))) and v24(v98.Icefury, not v17:IsSpellInRange(v98.Icefury))) then
				return "icefury single_target 92";
			end
		end
		if (((10627 - 6788) > (1863 - (337 + 121))) and v98.ChainLightning:IsAvailable() and v35 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v98.LightningRodDebuff) and (v17:DebuffUp(v98.ElectrifiedShocksDebuff) or v120()) and (v110 > (2 - 1)) and (v111 > (3 - 2))) then
			if (v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning)) or ((3204 - (1261 + 650)) <= (215 + 292))) then
				return "chain_lightning single_target 94";
			end
		end
		if ((v98.LightningBolt:IsAvailable() and v44 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v98.LightningRodDebuff) and (v17:DebuffUp(v98.ElectrifiedShocksDebuff) or v120())) or ((4614 - 1718) < (2622 - (772 + 1045)))) then
			if (((327 + 1989) == (2460 - (102 + 42))) and v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt))) then
				return "lightning_bolt single_target 96";
			end
		end
		if ((v98.FrostShock:IsCastable() and v40 and v122() and v120() and v14:BuffDown(v98.LavaSurgeBuff) and not v98.ElectrifiedShocks:IsAvailable() and not v98.FluxMelting:IsAvailable() and (v98.LavaBurst:ChargesFractional() < (1845 - (1524 + 320))) and v98.EchooftheElements:IsAvailable()) or ((3840 - (1049 + 221)) == (1689 - (18 + 138)))) then
			if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or ((2161 - 1278) == (2562 - (67 + 1035)))) then
				return "frost_shock single_target 98";
			end
		end
		if ((v98.FrostShock:IsCastable() and v40 and v122() and (v98.FluxMelting:IsAvailable() or (v98.ElectrifiedShocks:IsAvailable() and not v98.LightningRod:IsAvailable()))) or ((4967 - (136 + 212)) <= (4245 - 3246))) then
			if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or ((2732 + 678) > (3795 + 321))) then
				return "frost_shock single_target 100";
			end
		end
		if ((v98.ChainLightning:IsAvailable() and v35 and v120() and v14:BuffDown(v98.LavaSurgeBuff) and (v98.LavaBurst:ChargesFractional() < (1605 - (240 + 1364))) and v98.EchooftheElements:IsAvailable() and (v110 > (1083 - (1050 + 32))) and (v111 > (3 - 2))) or ((535 + 368) >= (4114 - (331 + 724)))) then
			if (v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning)) or ((321 + 3655) < (3501 - (269 + 375)))) then
				return "chain_lightning single_target 102";
			end
		end
		if (((5655 - (267 + 458)) > (718 + 1589)) and v98.LightningBolt:IsAvailable() and v44 and v120() and v14:BuffDown(v98.LavaSurgeBuff) and (v98.LavaBurst:ChargesFractional() < (1 - 0)) and v98.EchooftheElements:IsAvailable()) then
			if (v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt)) or ((4864 - (667 + 151)) < (2788 - (1410 + 87)))) then
				return "lightning_bolt single_target 104";
			end
		end
		if ((v98.FrostShock:IsCastable() and v40 and v122() and not v98.ElectrifiedShocks:IsAvailable() and not v98.FluxMelting:IsAvailable()) or ((6138 - (1504 + 393)) == (9582 - 6037))) then
			if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or ((10502 - 6454) > (5028 - (461 + 335)))) then
				return "frost_shock single_target 106";
			end
		end
		if ((v98.ChainLightning:IsAvailable() and v35 and (v110 > (1 + 0)) and (v111 > (1762 - (1730 + 31)))) or ((3417 - (728 + 939)) >= (12300 - 8827))) then
			if (((6421 - 3255) == (7253 - 4087)) and v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning))) then
				return "chain_lightning single_target 108";
			end
		end
		if (((2831 - (138 + 930)) < (3404 + 320)) and v98.LightningBolt:IsAvailable() and v44) then
			if (((45 + 12) <= (2334 + 389)) and v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt))) then
				return "lightning_bolt single_target 110";
			end
		end
		if ((v98.FlameShock:IsCastable() and UseFlameShock and (v14:IsMoving())) or ((8452 - 6382) == (2209 - (459 + 1307)))) then
			if (v102.CastCycle(v98.FlameShock, v109, v113, not v17:IsSpellInRange(v98.FlameShock)) or ((4575 - (474 + 1396)) == (2432 - 1039))) then
				return "flame_shock single_target 112";
			end
		end
		if ((v98.FlameShock:IsCastable() and UseFlameShock) or ((4313 + 288) < (1 + 60))) then
			if (v24(v98.FlameShock, not v17:IsSpellInRange(v98.FlameShock)) or ((3981 - 2591) >= (602 + 4142))) then
				return "flame_shock single_target 114";
			end
		end
		if ((v98.FrostShock:IsCastable() and v40) or ((6686 - 4683) > (16720 - 12886))) then
			if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or ((747 - (562 + 29)) > (3336 + 577))) then
				return "frost_shock single_target 116";
			end
		end
	end
	local function v130()
		local v148 = 1419 - (374 + 1045);
		while true do
			if (((155 + 40) == (605 - 410)) and (v148 == (638 - (448 + 190)))) then
				if (((1003 + 2102) >= (811 + 985)) and v72 and v98.EarthShield:IsCastable() and v14:BuffDown(v98.EarthShieldBuff) and ((v73 == "Earth Shield") or (v98.ElementalOrbit:IsAvailable() and v14:BuffUp(v98.LightningShield)))) then
					if (((2854 + 1525) >= (8193 - 6062)) and v24(v98.EarthShield)) then
						return "earth_shield main 2";
					end
				elseif (((11944 - 8100) >= (3537 - (1307 + 187))) and v72 and v98.LightningShield:IsCastable() and v14:BuffDown(v98.LightningShieldBuff) and ((v73 == "Lightning Shield") or (v98.ElementalOrbit:IsAvailable() and v14:BuffUp(v98.EarthShield)))) then
					if (v24(v98.LightningShield) or ((12816 - 9584) <= (6394 - 3663))) then
						return "lightning_shield main 2";
					end
				end
				v29 = v124();
				v148 = 2 - 1;
			end
			if (((5588 - (232 + 451)) == (4684 + 221)) and ((1 + 0) == v148)) then
				if (v29 or ((4700 - (510 + 54)) >= (8887 - 4476))) then
					return v29;
				end
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v14:CanAttack(v17)) or ((2994 - (13 + 23)) == (7830 - 3813))) then
					if (((1764 - 536) >= (1476 - 663)) and v24(v98.AncestralSpirit, nil, true)) then
						return "ancestral_spirit";
					end
				end
				v148 = 1090 - (830 + 258);
			end
			if ((v148 == (6 - 4)) or ((2162 + 1293) > (3446 + 604))) then
				if (((1684 - (860 + 581)) == (896 - 653)) and v98.AncestralSpirit:IsCastable() and v98.AncestralSpirit:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
					if (v24(v100.AncestralSpiritMouseover) or ((216 + 55) > (1813 - (237 + 4)))) then
						return "ancestral_spirit mouseover";
					end
				end
				v106, v107 = v28();
				v148 = 6 - 3;
			end
			if (((6929 - 4190) < (6243 - 2950)) and ((3 + 0) == v148)) then
				if ((v98.ImprovedFlametongueWeapon:IsAvailable() and v49 and (not v106 or (v107 < (344605 + 255395))) and v98.FlametongueWeapon:IsAvailable()) or ((14882 - 10940) < (487 + 647))) then
					if (v24(v98.FlamentongueWeapon) or ((1465 + 1228) == (6399 - (85 + 1341)))) then
						return "flametongue_weapon enchant";
					end
				end
				if (((3661 - 1515) == (6060 - 3914)) and not v14:AffectingCombat() and v30 and v102.TargetIsValid()) then
					v29 = v127();
					if (v29 or ((2616 - (45 + 327)) == (6083 - 2859))) then
						return v29;
					end
				end
				break;
			end
		end
	end
	local function v131()
		local v149 = 502 - (444 + 58);
		while true do
			if ((v149 == (2 + 1)) or ((844 + 4060) <= (937 + 979))) then
				if (((260 - 170) <= (2797 - (64 + 1668))) and v98.Purge:IsReady() and v95 and v34 and v82 and not v14:IsCasting() and not v14:IsChanneling() and v102.UnitHasMagicBuff(v17)) then
					if (((6775 - (1227 + 746)) == (14759 - 9957)) and v24(v98.Purge, not v17:IsSpellInRange(v98.Purge))) then
						return "purge damage";
					end
				end
				if ((v102.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((4231 - 1951) <= (1005 - (415 + 79)))) then
					if (((v89 < v105) and v56 and ((v62 and v32) or not v62)) or ((44 + 1632) <= (954 - (142 + 349)))) then
						local v218 = 0 + 0;
						while true do
							if (((5319 - 1450) == (1923 + 1946)) and (v218 == (2 + 0))) then
								if (((3153 - 1995) <= (4477 - (1710 + 154))) and v98.BagofTricks:IsCastable() and (not v98.Ascendance:IsAvailable() or v14:BuffUp(v98.AscendanceBuff))) then
									if (v24(v98.BagofTricks) or ((2682 - (200 + 118)) <= (793 + 1206))) then
										return "bag_of_tricks main 10";
									end
								end
								break;
							end
							if ((v218 == (1 - 0)) or ((7299 - 2377) < (173 + 21))) then
								if ((v98.Fireblood:IsCastable() and (not v98.Ascendance:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98.Ascendance:CooldownRemains() > (50 + 0)))) or ((1123 + 968) < (5 + 26))) then
									if (v24(v98.Fireblood) or ((5264 - 2834) >= (6122 - (363 + 887)))) then
										return "fireblood main 6";
									end
								end
								if ((v98.AncestralCall:IsCastable() and (not v98.Ascendance:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98.Ascendance:CooldownRemains() > (87 - 37)))) or ((22704 - 17934) < (268 + 1467))) then
									if (v24(v98.AncestralCall) or ((10386 - 5947) <= (1606 + 744))) then
										return "ancestral_call main 8";
									end
								end
								v218 = 1666 - (674 + 990);
							end
							if ((v218 == (0 + 0)) or ((1834 + 2645) < (7078 - 2612))) then
								if (((3602 - (507 + 548)) > (2062 - (289 + 548))) and v98.BloodFury:IsCastable() and (not v98.Ascendance:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98.Ascendance:CooldownRemains() > (1868 - (821 + 997))))) then
									if (((4926 - (195 + 60)) > (720 + 1954)) and v24(v98.BloodFury)) then
										return "blood_fury main 2";
									end
								end
								if ((v98.Berserking:IsCastable() and (not v98.Ascendance:IsAvailable() or v14:BuffUp(v98.AscendanceBuff))) or ((5197 - (251 + 1250)) < (9746 - 6419))) then
									if (v24(v98.Berserking) or ((3121 + 1421) == (4002 - (809 + 223)))) then
										return "berserking main 4";
									end
								end
								v218 = 1 - 0;
							end
						end
					end
					if (((756 - 504) <= (6536 - 4559)) and (v89 < v105)) then
						if ((v55 and ((v32 and v61) or not v61)) or ((1058 + 378) == (1977 + 1798))) then
							local v221 = 617 - (14 + 603);
							while true do
								if ((v221 == (129 - (118 + 11))) or ((262 + 1356) < (775 + 155))) then
									v29 = v126();
									if (((13763 - 9040) > (5102 - (551 + 398))) and v29) then
										return v29;
									end
									break;
								end
							end
						end
					end
					if ((v98.NaturesSwiftness:IsCastable() and v45) or ((2310 + 1344) >= (1657 + 2997))) then
						if (((773 + 178) <= (5563 - 4067)) and v24(v98.NaturesSwiftness)) then
							return "natures_swiftness main 12";
						end
					end
					local v211 = v102.HandleDPSPotion(v14:BuffUp(v98.AscendanceBuff));
					if (v211 or ((3999 - 2263) == (186 + 385))) then
						return v211;
					end
					if ((v31 and (v110 > (7 - 5)) and (v111 > (1 + 1))) or ((985 - (40 + 49)) > (18160 - 13391))) then
						v29 = v128();
						if (v29 or ((1535 - (99 + 391)) <= (844 + 176))) then
							return v29;
						end
						if (v24(v98.Pool) or ((5099 - 3939) <= (812 - 484))) then
							return "Pool for Aoe()";
						end
					end
					if (((3710 + 98) > (7693 - 4769)) and true) then
						local v219 = 1604 - (1032 + 572);
						while true do
							if (((4308 - (203 + 214)) < (6736 - (568 + 1249))) and (v219 == (1 + 0))) then
								if (v24(v98.Pool) or ((5365 - 3131) <= (5801 - 4299))) then
									return "Pool for SingleTarget()";
								end
								break;
							end
							if ((v219 == (1306 - (913 + 393))) or ((7093 - 4581) < (609 - 177))) then
								v29 = v129();
								if (v29 or ((2258 - (269 + 141)) == (1923 - 1058))) then
									return v29;
								end
								v219 = 1982 - (362 + 1619);
							end
						end
					end
				end
				break;
			end
			if (((1626 - (950 + 675)) == v149) or ((1805 + 2877) <= (5720 - (216 + 963)))) then
				if (v84 or ((4313 - (485 + 802)) >= (4605 - (432 + 127)))) then
					local v212 = 1073 - (1065 + 8);
					while true do
						if (((1116 + 892) > (2239 - (635 + 966))) and (v212 == (1 + 0))) then
							if (((1817 - (5 + 37)) <= (8040 - 4807)) and v81) then
								v29 = v102.HandleAfflicted(v98.PoisonCleansingTotem, v98.PoisonCleansingTotem, 13 + 17);
								if (v29 or ((7190 - 2647) == (935 + 1062))) then
									return v29;
								end
							end
							break;
						end
						if (((0 - 0) == v212) or ((11760 - 8658) < (1372 - 644))) then
							if (((824 - 479) == (249 + 96)) and v79) then
								v29 = v102.HandleAfflicted(v98.CleanseSpirit, v100.CleanseSpiritMouseover, 569 - (318 + 211));
								if (v29 or ((13910 - 11083) < (1965 - (963 + 624)))) then
									return v29;
								end
							end
							if (v80 or ((1486 + 1990) < (3443 - (518 + 328)))) then
								v29 = v102.HandleAfflicted(v98.TremorTotem, v98.TremorTotem, 69 - 39);
								if (((4920 - 1841) < (5111 - (301 + 16))) and v29) then
									return v29;
								end
							end
							v212 = 2 - 1;
						end
					end
				end
				if (((13632 - 8778) > (11648 - 7184)) and v85) then
					v29 = v102.HandleIncorporeal(v98.Hex, v100.HexMouseOver, 28 + 2, true);
					if (v29 or ((2789 + 2123) == (8022 - 4264))) then
						return v29;
					end
				end
				v149 = 2 + 0;
			end
			if (((12 + 114) <= (11070 - 7588)) and ((1 + 1) == v149)) then
				if (Focus or ((3393 - (829 + 190)) == (15605 - 11231))) then
					if (((1992 - 417) == (2176 - 601)) and v83) then
						local v220 = 0 - 0;
						while true do
							if ((v220 == (0 + 0)) or ((730 + 1504) == (4416 - 2961))) then
								v29 = v123();
								if (v29 or ((1007 + 60) > (2392 - (520 + 93)))) then
									return v29;
								end
								break;
							end
						end
					end
				end
				if (((2437 - (259 + 17)) >= (54 + 880)) and v98.GreaterPurge:IsAvailable() and v95 and v98.GreaterPurge:IsReady() and v34 and v82 and not v14:IsCasting() and not v14:IsChanneling() and v102.UnitHasMagicBuff(v17)) then
					if (((581 + 1031) == (5457 - 3845)) and v24(v98.GreaterPurge, not v17:IsSpellInRange(v98.GreaterPurge))) then
						return "greater_purge damage";
					end
				end
				v149 = 594 - (396 + 195);
			end
			if (((12626 - 8274) >= (4594 - (440 + 1321))) and (v149 == (1829 - (1059 + 770)))) then
				v29 = v125();
				if (v29 or ((14898 - 11676) < (3618 - (424 + 121)))) then
					return v29;
				end
				v149 = 1 + 0;
			end
		end
	end
	local function v132()
		v35 = EpicSettings.Settings['useChainlightning'];
		v36 = EpicSettings.Settings['useEarthquake'];
		v37 = EpicSettings.Settings['useEarthshock'];
		v38 = EpicSettings.Settings['useElementalBlast'];
		UseFlameShock = EpicSettings.Settings['useFlameShock'];
		v40 = EpicSettings.Settings['useFrostShock'];
		v41 = EpicSettings.Settings['useIceFury'];
		v42 = EpicSettings.Settings['useLavaBeam'];
		v43 = EpicSettings.Settings['useLavaBurst'];
		v44 = EpicSettings.Settings['useLightningBolt'];
		v45 = EpicSettings.Settings['useNaturesSwiftness'];
		v46 = EpicSettings.Settings['usePrimordialWave'];
		v47 = EpicSettings.Settings['useStormkeeper'];
		v48 = EpicSettings.Settings['useTotemicRecall'];
		v49 = EpicSettings.Settings['useWeaponEnchant'];
		v51 = EpicSettings.Settings['useAscendance'];
		v53 = EpicSettings.Settings['useLiquidMagmaTotem'];
		v52 = EpicSettings.Settings['useFireElemental'];
		v54 = EpicSettings.Settings['useStormElemental'];
		v57 = EpicSettings.Settings['ascendanceWithCD'];
		v60 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
		v58 = EpicSettings.Settings['fireElementalWithCD'];
		v59 = EpicSettings.Settings['stormElementalWithCD'];
		v63 = EpicSettings.Settings['primordialWaveWithMiniCD'];
		v64 = EpicSettings.Settings['stormkeeperWithMiniCD'];
	end
	local function v133()
		local v175 = 1347 - (641 + 706);
		while true do
			if (((295 + 449) <= (3382 - (249 + 191))) and ((17 - 13) == v175)) then
				v97 = EpicSettings.Settings['healOOCHP'] or (0 + 0);
				v95 = EpicSettings.Settings['usePurgeTarget'];
				v79 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v80 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v175 = 19 - 14;
			end
			if ((v175 == (432 - (183 + 244))) or ((91 + 1742) <= (2052 - (434 + 296)))) then
				v81 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if ((v175 == (0 - 0)) or ((3979 - (169 + 343)) <= (925 + 130))) then
				v66 = EpicSettings.Settings['useWindShear'];
				v67 = EpicSettings.Settings['useCapacitorTotem'];
				v68 = EpicSettings.Settings['useThunderstorm'];
				v69 = EpicSettings.Settings['useAncestralGuidance'];
				v175 = 1 - 0;
			end
			if (((10393 - 6852) == (2901 + 640)) and (v175 == (8 - 5))) then
				v65 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
				v72 = EpicSettings.Settings['autoShield'];
				v73 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v96 = EpicSettings.Settings['healOOC'];
				v175 = 1127 - (651 + 472);
			end
			if (((2 + 0) == v175) or ((1535 + 2022) >= (4884 - 881))) then
				v76 = EpicSettings.Settings['astralShiftHP'] or (483 - (397 + 86));
				v77 = EpicSettings.Settings['healingStreamTotemHP'] or (876 - (423 + 453));
				v78 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
				v50 = EpicSettings.Settings['earthquakeSetting'] or "";
				v175 = 1 + 2;
			end
			if ((v175 == (1 + 0)) or ((525 + 132) >= (1490 + 178))) then
				v70 = EpicSettings.Settings['useAstralShift'];
				v71 = EpicSettings.Settings['useHealingStreamTotem'];
				v74 = EpicSettings.Settings['ancestralGuidanceHP'] or (1190 - (50 + 1140));
				v75 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
				v175 = 2 + 0;
			end
		end
	end
	local function v134()
		v89 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v86 = EpicSettings.Settings['InterruptWithStun'];
		v87 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v88 = EpicSettings.Settings['InterruptThreshold'];
		v83 = EpicSettings.Settings['DispelDebuffs'];
		v82 = EpicSettings.Settings['DispelBuffs'];
		v55 = EpicSettings.Settings['useTrinkets'];
		v56 = EpicSettings.Settings['useRacials'];
		v61 = EpicSettings.Settings['trinketsWithCD'];
		v62 = EpicSettings.Settings['racialsWithCD'];
		v91 = EpicSettings.Settings['useHealthstone'];
		v90 = EpicSettings.Settings['useHealingPotion'];
		v93 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v92 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
		v94 = EpicSettings.Settings['HealingPotionName'] or "";
		v84 = EpicSettings.Settings['handleAfflicted'];
		v85 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v135()
		local v189 = 596 - (157 + 439);
		while true do
			if ((v189 == (6 - 2)) or ((3412 - 2385) > (11411 - 7553))) then
				if (v14:AffectingCombat() or v83 or ((4572 - (782 + 136)) < (1305 - (112 + 743)))) then
					local v213 = v83 and v98.CleanseSpirit:IsReady() and v34;
					v29 = v102.FocusUnit(v213, v100, 1191 - (1026 + 145), nil, 5 + 20);
					if (((2609 - (493 + 225)) < (16367 - 11914)) and v29) then
						return v29;
					end
				end
				if (v102.TargetIsValid() or v14:AffectingCombat() or ((1910 + 1230) < (5707 - 3578))) then
					local v214 = 0 + 0;
					while true do
						if ((v214 == (2 - 1)) or ((744 + 1811) < (2071 - 831))) then
							if ((v105 == (12706 - (210 + 1385))) or ((6416 - (1201 + 488)) <= (2927 + 1795))) then
								v105 = v10.FightRemains(v108, false);
							end
							break;
						end
						if (((1316 - 576) < (8853 - 3916)) and (v214 == (585 - (352 + 233)))) then
							v104 = v10.BossFightRemains();
							v105 = v104;
							v214 = 2 - 1;
						end
					end
				end
				if (((1990 + 1668) >= (796 - 516)) and not v14:IsChanneling() and not v14:IsChanneling()) then
					local v215 = 574 - (489 + 85);
					while true do
						if ((v215 == (1501 - (277 + 1224))) or ((2378 - (663 + 830)) >= (906 + 125))) then
							if (((8702 - 5148) >= (1400 - (461 + 414))) and Focus) then
								if (((405 + 2009) <= (1190 + 1782)) and v83) then
									v29 = v123();
									if (((337 + 3192) <= (3488 + 50)) and v29) then
										return v29;
									end
								end
							end
							if (v84 or ((3111 - (172 + 78)) < (738 - 280))) then
								if (((632 + 1085) <= (6529 - 2004)) and v79) then
									v29 = v102.HandleAfflicted(v98.CleanseSpirit, v100.CleanseSpiritMouseover, 11 + 29);
									if (v29 or ((1062 + 2116) <= (2552 - 1028))) then
										return v29;
									end
								end
								if (((5354 - 1100) > (94 + 276)) and v80) then
									local v222 = 0 + 0;
									while true do
										if ((v222 == (0 + 0)) or ((6508 - 4873) == (4139 - 2362))) then
											v29 = v102.HandleAfflicted(v98.TremorTotem, v98.TremorTotem, 10 + 20);
											if (v29 or ((1906 + 1432) >= (4440 - (133 + 314)))) then
												return v29;
											end
											break;
										end
									end
								end
								if (((201 + 953) <= (1688 - (199 + 14))) and v81) then
									local v223 = 0 - 0;
									while true do
										if ((v223 == (1549 - (647 + 902))) or ((7848 - 5238) < (1463 - (85 + 148)))) then
											v29 = v102.HandleAfflicted(v98.PoisonCleansingTotem, v98.PoisonCleansingTotem, 1319 - (426 + 863));
											if (v29 or ((6776 - 5328) == (4737 - (873 + 781)))) then
												return v29;
											end
											break;
										end
									end
								end
							end
							v215 = 1 - 0;
						end
						if (((8477 - 5338) > (380 + 536)) and (v215 == (3 - 2))) then
							if (((4233 - 1279) == (8771 - 5817)) and v14:AffectingCombat()) then
								v29 = v131();
								if (((2064 - (414 + 1533)) <= (2508 + 384)) and v29) then
									return v29;
								end
							else
								v29 = v130();
								if (v29 or ((1008 - (443 + 112)) > (6141 - (888 + 591)))) then
									return v29;
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((3410 - 2090) > (34 + 561)) and (v189 == (7 - 5))) then
				v34 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['minicds'];
				if (v14:IsDeadOrGhost() or ((1249 + 1950) < (286 + 304))) then
					return;
				end
				v189 = 1 + 2;
			end
			if ((v189 == (5 - 2)) or ((8877 - 4084) < (1708 - (136 + 1542)))) then
				v108 = v14:GetEnemiesInRange(131 - 91);
				v109 = v17:GetEnemiesInSplashRange(5 + 0);
				if (v31 or ((2696 - 1000) <= (767 + 292))) then
					local v216 = 486 - (68 + 418);
					while true do
						if (((6351 - 4008) == (4250 - 1907)) and ((0 + 0) == v216)) then
							v110 = #v108;
							v111 = max(v17:GetEnemiesInSplashRangeCount(1097 - (770 + 322)), v110);
							break;
						end
					end
				else
					local v217 = 0 + 0;
					while true do
						if ((v217 == (0 + 0)) or ((143 + 900) > (5137 - 1546))) then
							v110 = 1 - 0;
							v111 = 2 - 1;
							break;
						end
					end
				end
				v189 = 14 - 10;
			end
			if ((v189 == (0 + 0)) or ((4330 - 1440) >= (1957 + 2122))) then
				v133();
				v132();
				v134();
				v189 = 1 + 0;
			end
			if (((3506 + 968) <= (17962 - 13192)) and (v189 == (1 - 0))) then
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v189 = 1 + 1;
			end
		end
	end
	local function v136()
		v98.FlameShockDebuff:RegisterAuraTracking();
		v103();
		v21.Print("Elemental Shaman by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(1206 - 944, v135, v136);
end;
return v0["Epix_Shaman_Elemental.lua"]();

