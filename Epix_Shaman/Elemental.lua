local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 976 - (738 + 238);
	local v6;
	while true do
		if (((6551 - 1993) == (5740 - (229 + 953))) and (v5 == (1774 - (1111 + 663)))) then
			v6 = v0[v4];
			if (not v6 or ((2345 - (874 + 705)) >= (646 + 3963))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1 - 0)) or ((33 + 1119) == (3167 - (642 + 37)))) then
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
	local v18 = v12.Focus;
	local v19 = v10.Spell;
	local v20 = v10.MultiSpell;
	local v21 = v10.Item;
	local v22 = EpicLib;
	local v23 = v22.Cast;
	local v24 = v22.Macro;
	local v25 = v22.Press;
	local v26 = v22.Commons.Everyone.num;
	local v27 = v22.Commons.Everyone.bool;
	local v28 = math.max;
	local v29 = GetTime;
	local v30 = GetWeaponEnchantInfo;
	local v31;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
	local v36 = false;
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
	local v98;
	local v99;
	local v100 = v19.Shaman.Elemental;
	local v101 = v21.Shaman.Elemental;
	local v102 = v24.Shaman.Elemental;
	local v103 = {};
	local v104 = v22.Commons.Everyone;
	local v105 = v22.Commons.Shaman;
	local function v106()
		if (((781 + 2641) > (536 + 2814)) and v100.CleanseSpirit:IsAvailable()) then
			v104.DispellableDebuffs = v104.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v106();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v10:RegisterForEvent(function()
		local v140 = 0 - 0;
		while true do
			if (((1331 - (233 + 221)) > (869 - 493)) and (v140 == (1 + 0))) then
				v100.LavaBurst:RegisterInFlight();
				break;
			end
			if ((v140 == (1541 - (718 + 823))) or ((1963 + 1155) <= (2656 - (266 + 539)))) then
				v100.PrimordialWave:RegisterInFlightEffect(926271 - 599109);
				v100.PrimordialWave:RegisterInFlight();
				v140 = 1226 - (636 + 589);
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v100.PrimordialWave:RegisterInFlightEffect(776605 - 449443);
	v100.PrimordialWave:RegisterInFlight();
	v100.LavaBurst:RegisterInFlight();
	local v107 = 22916 - 11805;
	local v108 = 8806 + 2305;
	local v109, v110;
	local v111, v112;
	local v113 = 0 + 0;
	local v114 = 1015 - (657 + 358);
	local function v115()
		return (105 - 65) - (v29() - v105.LastT302pcBuff);
	end
	local function v116(v141)
		return (v141:DebuffRefreshable(v100.FlameShockDebuff));
	end
	local function v117(v142)
		return v142:DebuffRefreshable(v100.FlameShockDebuff) and (v142:DebuffRemains(v100.FlameShockDebuff) < (v142:TimeToDie() - (11 - 6)));
	end
	local function v118(v143)
		return v143:DebuffRefreshable(v100.FlameShockDebuff) and (v143:DebuffRemains(v100.FlameShockDebuff) < (v143:TimeToDie() - (1192 - (1151 + 36)))) and (v143:DebuffRemains(v100.FlameShockDebuff) > (0 + 0));
	end
	local function v119(v144)
		return (v144:DebuffRemains(v100.FlameShockDebuff));
	end
	local function v120(v145)
		return v145:DebuffRemains(v100.FlameShockDebuff) > (1 + 1);
	end
	local function v121(v146)
		return (v146:DebuffRemains(v100.LightningRodDebuff));
	end
	local function v122()
		local v147 = v14:Maelstrom();
		if (not v14:IsCasting() or ((492 - 327) >= (5324 - (1552 + 280)))) then
			return v147;
		elseif (((4783 - (64 + 770)) < (3297 + 1559)) and v14:IsCasting(v100.ElementalBlast)) then
			return v147 - (170 - 95);
		elseif (v14:IsCasting(v100.Icefury) or ((760 + 3516) < (4259 - (157 + 1086)))) then
			return v147 + (50 - 25);
		elseif (((20541 - 15851) > (6327 - 2202)) and v14:IsCasting(v100.LightningBolt)) then
			return v147 + (13 - 3);
		elseif (v14:IsCasting(v100.LavaBurst) or ((869 - (599 + 220)) >= (1783 - 887))) then
			return v147 + (1943 - (1813 + 118));
		elseif (v14:IsCasting(v100.ChainLightning) or ((1253 + 461) >= (4175 - (841 + 376)))) then
			return v147 + ((5 - 1) * v114);
		else
			return v147;
		end
	end
	local function v123()
		local v148 = 0 + 0;
		local v149;
		while true do
			if ((v148 == (0 - 0)) or ((2350 - (464 + 395)) < (1652 - 1008))) then
				if (((339 + 365) < (1824 - (467 + 370))) and not v100.MasteroftheElements:IsAvailable()) then
					return false;
				end
				v149 = v14:BuffUp(v100.MasteroftheElementsBuff);
				v148 = 1 - 0;
			end
			if (((2730 + 988) > (6533 - 4627)) and (v148 == (1 + 0))) then
				if (not v14:IsCasting() or ((2228 - 1270) > (4155 - (150 + 370)))) then
					return v149;
				elseif (((4783 - (74 + 1208)) <= (11048 - 6556)) and v14:IsCasting(v100.LavaBurst)) then
					return true;
				elseif (v14:IsCasting(v100.ElementalBlast) or ((16323 - 12881) < (1814 + 734))) then
					return false;
				elseif (((3265 - (14 + 376)) >= (2538 - 1074)) and v14:IsCasting(v100.Icefury)) then
					return false;
				elseif (v14:IsCasting(v100.LightningBolt) or ((3104 + 1693) >= (4299 + 594))) then
					return false;
				elseif (v14:IsCasting(v100.ChainLightning) or ((526 + 25) > (6059 - 3991))) then
					return false;
				else
					return v149;
				end
				break;
			end
		end
	end
	local function v124()
		local v150 = 0 + 0;
		local v151;
		while true do
			if (((2192 - (23 + 55)) > (2236 - 1292)) and ((1 + 0) == v150)) then
				if (not v14:IsCasting() or ((2032 + 230) >= (4800 - 1704))) then
					return v151;
				elseif (v14:IsCasting(v100.Stormkeeper) or ((710 + 1545) >= (4438 - (652 + 249)))) then
					return true;
				else
					return v151;
				end
				break;
			end
			if ((v150 == (0 - 0)) or ((5705 - (708 + 1160)) < (3545 - 2239))) then
				if (((5378 - 2428) == (2977 - (10 + 17))) and not v100.Stormkeeper:IsAvailable()) then
					return false;
				end
				v151 = v14:BuffUp(v100.StormkeeperBuff);
				v150 = 1 + 0;
			end
		end
	end
	local function v125()
		if (not v100.Icefury:IsAvailable() or ((6455 - (1400 + 332)) < (6325 - 3027))) then
			return false;
		end
		local v152 = v14:BuffUp(v100.IcefuryBuff);
		if (((3044 - (242 + 1666)) >= (66 + 88)) and not v14:IsCasting()) then
			return v152;
		elseif (v14:IsCasting(v100.Icefury) or ((100 + 171) > (4047 + 701))) then
			return true;
		else
			return v152;
		end
	end
	local function v126()
		if (((5680 - (850 + 90)) >= (5520 - 2368)) and v100.CleanseSpirit:IsReady() and v36 and v104.DispellableFriendlyUnit(1415 - (360 + 1030))) then
			if (v25(v102.CleanseSpiritFocus) or ((2282 + 296) >= (9568 - 6178))) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v127()
		if (((56 - 15) <= (3322 - (909 + 752))) and v98 and (v14:HealthPercentage() <= v99)) then
			if (((1824 - (109 + 1114)) < (6517 - 2957)) and v100.HealingSurge:IsReady()) then
				if (((92 + 143) < (929 - (6 + 236))) and v25(v100.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v128()
		local v153 = 0 + 0;
		while true do
			if (((3662 + 887) > (2719 - 1566)) and (v153 == (1 - 0))) then
				if ((v100.HealingStreamTotem:IsReady() and v73 and v104.AreUnitsBelowHealthPercentage(v79, v80)) or ((5807 - (1076 + 57)) < (769 + 3903))) then
					if (((4357 - (579 + 110)) < (361 + 4200)) and v25(v100.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v101.Healthstone:IsReady() and v93 and (v14:HealthPercentage() <= v95)) or ((403 + 52) == (1914 + 1691))) then
					if (v25(v102.Healthstone) or ((3070 - (174 + 233)) == (9251 - 5939))) then
						return "healthstone defensive 3";
					end
				end
				v153 = 3 - 1;
			end
			if (((1902 + 2375) <= (5649 - (663 + 511))) and (v153 == (0 + 0))) then
				if ((v100.AstralShift:IsReady() and v72 and (v14:HealthPercentage() <= v78)) or ((189 + 681) == (3665 - 2476))) then
					if (((941 + 612) <= (7375 - 4242)) and v25(v100.AstralShift)) then
						return "astral_shift defensive 1";
					end
				end
				if ((v100.AncestralGuidance:IsReady() and v71 and v104.AreUnitsBelowHealthPercentage(v76, v77)) or ((5414 - 3177) >= (1676 + 1835))) then
					if (v25(v100.AncestralGuidance) or ((2576 - 1252) > (2153 + 867))) then
						return "ancestral_guidance defensive 2";
					end
				end
				v153 = 1 + 0;
			end
			if ((v153 == (724 - (478 + 244))) or ((3509 - (440 + 77)) == (856 + 1025))) then
				if (((11367 - 8261) > (3082 - (655 + 901))) and v92 and (v14:HealthPercentage() <= v94)) then
					local v219 = 0 + 0;
					while true do
						if (((2315 + 708) < (2614 + 1256)) and (v219 == (0 - 0))) then
							if (((1588 - (695 + 750)) > (252 - 178)) and (v96 == "Refreshing Healing Potion")) then
								if (((27 - 9) < (8493 - 6381)) and v101.RefreshingHealingPotion:IsReady()) then
									if (((1448 - (285 + 66)) <= (3794 - 2166)) and v25(v102.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((5940 - (682 + 628)) == (747 + 3883)) and (v96 == "Dreamwalker's Healing Potion")) then
								if (((3839 - (176 + 123)) > (1123 + 1560)) and v101.DreamwalkersHealingPotion:IsReady()) then
									if (((3478 + 1316) >= (3544 - (239 + 30))) and v25(v102.RefreshingHealingPotion)) then
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
		end
	end
	local function v129()
		v31 = v104.HandleTopTrinket(v103, v34, 11 + 29, nil);
		if (((1427 + 57) == (2626 - 1142)) and v31) then
			return v31;
		end
		v31 = v104.HandleBottomTrinket(v103, v34, 124 - 84, nil);
		if (((1747 - (306 + 9)) < (12405 - 8850)) and v31) then
			return v31;
		end
	end
	local function v130()
		local v154 = 0 + 0;
		while true do
			if ((v154 == (1 + 0)) or ((513 + 552) > (10231 - 6653))) then
				if ((v100.ElementalBlast:IsCastable() and v40) or ((6170 - (1140 + 235)) < (896 + 511))) then
					if (((1700 + 153) < (1236 + 3577)) and v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast precombat 6";
					end
				end
				if ((v14:IsCasting(v100.ElementalBlast) and v48 and ((v65 and v35) or not v65) and v100.PrimordialWave:IsAvailable()) or ((2873 - (33 + 19)) < (878 + 1553))) then
					if (v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave)) or ((8614 - 5740) < (961 + 1220))) then
						return "primordial_wave precombat 8";
					end
				end
				v154 = 3 - 1;
			end
			if ((v154 == (3 + 0)) or ((3378 - (586 + 103)) <= (32 + 311))) then
				if ((v14:IsCasting(v100.LavaBurst) and v41 and v100.FlameShock:IsReady()) or ((5753 - 3884) == (3497 - (1309 + 179)))) then
					if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((6401 - 2855) < (1011 + 1311))) then
						return "flameshock precombat 14";
					end
				end
				if ((v14:IsCasting(v100.LavaBurst) and v48 and ((v65 and v35) or not v65) and v100.PrimordialWave:IsAvailable()) or ((5591 - 3509) == (3606 + 1167))) then
					if (((6891 - 3647) > (2102 - 1047)) and v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave precombat 16";
					end
				end
				break;
			end
			if ((v154 == (611 - (295 + 314))) or ((8137 - 4824) <= (3740 - (1300 + 662)))) then
				if ((v14:IsCasting(v100.ElementalBlast) and v41 and not v100.PrimordialWave:IsAvailable() and v100.FlameShock:IsReady()) or ((4462 - 3041) >= (3859 - (1178 + 577)))) then
					if (((942 + 870) <= (9604 - 6355)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
						return "flameshock precombat 10";
					end
				end
				if (((3028 - (851 + 554)) <= (1731 + 226)) and v100.LavaBurst:IsCastable() and v45 and not v14:IsCasting(v100.LavaBurst) and (not v100.ElementalBlast:IsAvailable() or (v100.ElementalBlast:IsAvailable() and not v100.ElementalBlast:IsAvailable()))) then
					if (((12235 - 7823) == (9581 - 5169)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lavaburst precombat 12";
					end
				end
				v154 = 305 - (115 + 187);
			end
			if (((1341 + 409) >= (798 + 44)) and (v154 == (0 - 0))) then
				if (((5533 - (160 + 1001)) > (1619 + 231)) and v100.Stormkeeper:IsCastable() and (v100.Stormkeeper:CooldownRemains() == (0 + 0)) and not v14:BuffUp(v100.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v108)) then
					if (((474 - 242) < (1179 - (237 + 121))) and v25(v100.Stormkeeper)) then
						return "stormkeeper precombat 2";
					end
				end
				if (((1415 - (525 + 372)) < (1709 - 807)) and v100.Icefury:IsCastable() and (v100.Icefury:CooldownRemains() == (0 - 0)) and v43) then
					if (((3136 - (96 + 46)) > (1635 - (643 + 134))) and v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury))) then
						return "icefury precombat 4";
					end
				end
				v154 = 1 + 0;
			end
		end
	end
	local function v131()
		local v155 = 0 - 0;
		while true do
			if (((18 - 13) == v155) or ((3602 + 153) <= (1795 - 880))) then
				if (((8066 - 4120) > (4462 - (316 + 403))) and v100.LavaBeam:IsAvailable() and v44 and (v113 >= (4 + 2)) and v14:BuffUp(v100.SurgeofPowerBuff) and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) then
					if (v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam)) or ((3670 - 2335) >= (1195 + 2111))) then
						return "lava_beam aoe 66";
					end
				end
				if (((12198 - 7354) > (1597 + 656)) and v100.ChainLightning:IsAvailable() and v37 and (v113 >= (2 + 4)) and v14:BuffUp(v100.SurgeofPowerBuff)) then
					if (((1565 - 1113) == (2158 - 1706)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning aoe 68";
					end
				end
				if ((v100.LavaBurst:IsAvailable() and v45 and v14:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable() and v14:BuffUp(v100.WindspeakersLavaResurgenceBuff)) or ((9466 - 4909) < (120 + 1967))) then
					if (((7625 - 3751) == (190 + 3684)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 70";
					end
				end
				if ((v100.LavaBeam:IsAvailable() and v44 and v123() and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((5701 - 3763) > (4952 - (12 + 5)))) then
					if (v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam)) or ((16526 - 12271) < (7302 - 3879))) then
						return "lava_beam aoe 72";
					end
				end
				if (((3090 - 1636) <= (6177 - 3686)) and v100.LavaBurst:IsAvailable() and v45 and (v113 == (1 + 2)) and v100.MasteroftheElements:IsAvailable()) then
					local v220 = 1973 - (1656 + 317);
					while true do
						if ((v220 == (0 + 0)) or ((3332 + 825) <= (7453 - 4650))) then
							if (((23884 - 19031) >= (3336 - (5 + 349))) and v104.CastCycle(v100.LavaBurst, v112, v119, not v17:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 74";
							end
							if (((19635 - 15501) > (4628 - (266 + 1005))) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 74";
							end
							break;
						end
					end
				end
				if ((v100.LavaBurst:IsAvailable() and v45 and v14:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable()) or ((2252 + 1165) < (8646 - 6112))) then
					local v221 = 0 - 0;
					while true do
						if ((v221 == (1696 - (561 + 1135))) or ((3546 - 824) <= (538 - 374))) then
							if (v104.CastCycle(v100.LavaBurst, v112, v119, not v17:IsSpellInRange(v100.LavaBurst)) or ((3474 - (507 + 559)) < (5291 - 3182))) then
								return "lava_burst aoe 76";
							end
							if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((101 - 68) == (1843 - (212 + 176)))) then
								return "lava_burst aoe 76";
							end
							break;
						end
					end
				end
				v155 = 911 - (250 + 655);
			end
			if ((v155 == (8 - 5)) or ((773 - 330) >= (6281 - 2266))) then
				if (((5338 - (1869 + 87)) > (575 - 409)) and v100.ElementalBlast:IsAvailable() and v40 and (v100.EchoesofGreatSundering:IsAvailable())) then
					local v222 = 1901 - (484 + 1417);
					while true do
						if (((0 - 0) == v222) or ((469 - 189) == (3832 - (48 + 725)))) then
							if (((3072 - 1191) > (3468 - 2175)) and v104.CastTargetIf(v100.ElementalBlast, v112, "min", v121, nil, not v17:IsSpellInRange(v100.ElementalBlast))) then
								return "elemental_blast aoe 42";
							end
							if (((1370 + 987) == (6298 - 3941)) and v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast))) then
								return "elemental_blast aoe 42";
							end
							break;
						end
					end
				end
				if (((35 + 88) == (36 + 87)) and v100.ElementalBlast:IsAvailable() and v40 and (v100.EchoesofGreatSundering:IsAvailable())) then
					if (v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast)) or ((1909 - (152 + 701)) >= (4703 - (430 + 881)))) then
						return "elemental_blast aoe 44";
					end
				end
				if ((v100.ElementalBlast:IsAvailable() and v40 and (v113 == (2 + 1)) and not v100.EchoesofGreatSundering:IsAvailable()) or ((1976 - (557 + 338)) < (318 + 757))) then
					if (v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast)) or ((2955 - 1906) >= (15519 - 11087))) then
						return "elemental_blast aoe 46";
					end
				end
				if ((v100.EarthShock:IsReady() and v39 and (v100.EchoesofGreatSundering:IsAvailable())) or ((12667 - 7899) <= (1822 - 976))) then
					local v223 = 801 - (499 + 302);
					while true do
						if ((v223 == (866 - (39 + 827))) or ((9269 - 5911) <= (3171 - 1751))) then
							if (v104.CastTargetIf(v100.EarthShock, v112, "min", v121, nil, not v17:IsSpellInRange(v100.EarthShock)) or ((14850 - 11111) <= (4613 - 1608))) then
								return "earth_shock aoe 48";
							end
							if (v25(v100.EarthShock, not v17:IsSpellInRange(v100.EarthShock)) or ((143 + 1516) >= (6245 - 4111))) then
								return "earth_shock aoe 48";
							end
							break;
						end
					end
				end
				if ((v100.EarthShock:IsReady() and v39 and (v100.EchoesofGreatSundering:IsAvailable())) or ((522 + 2738) < (3726 - 1371))) then
					if (v25(v100.EarthShock, not v17:IsSpellInRange(v100.EarthShock)) or ((773 - (103 + 1)) == (4777 - (475 + 79)))) then
						return "earth_shock aoe 50";
					end
				end
				if ((v100.Icefury:IsAvailable() and (v100.Icefury:CooldownRemains() == (0 - 0)) and v43 and v14:BuffDown(v100.AscendanceBuff) and v100.ElectrifiedShocks:IsAvailable() and ((v100.LightningRod:IsAvailable() and (v113 < (16 - 11)) and not v123()) or (v100.DeeplyRootedElements:IsAvailable() and (v113 == (1 + 2))))) or ((1490 + 202) < (2091 - (1395 + 108)))) then
					if (v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury)) or ((13958 - 9161) < (4855 - (7 + 1197)))) then
						return "icefury aoe 52";
					end
				end
				v155 = 2 + 2;
			end
			if ((v155 == (2 + 2)) or ((4496 - (27 + 292)) > (14212 - 9362))) then
				if ((v100.FrostShock:IsCastable() and v42 and v14:BuffDown(v100.AscendanceBuff) and v125() and v100.ElectrifiedShocks:IsAvailable() and (v17:DebuffDown(v100.ElectrifiedShocksDebuff) or (v14:BuffRemains(v100.IcefuryBuff) < v14:GCD())) and ((v100.LightningRod:IsAvailable() and (v113 < (6 - 1)) and not v123()) or (v100.DeeplyRootedElements:IsAvailable() and (v113 == (12 - 9))))) or ((788 - 388) > (2115 - 1004))) then
					if (((3190 - (43 + 96)) > (4099 - 3094)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock moving aoe 54";
					end
				end
				if (((8349 - 4656) <= (3637 + 745)) and v100.LavaBurst:IsAvailable() and v45 and v100.MasteroftheElements:IsAvailable() and not v123() and (v124() or (v14:HasTier(9 + 21, 3 - 1) and (v115() < (2 + 1)))) and (v122() < ((((112 - 52) - ((2 + 3) * v100.EyeoftheStorm:TalentRank())) - ((1 + 1) * v26(v100.FlowofPower:IsAvailable()))) - (1761 - (1414 + 337)))) and (v113 < (1945 - (1642 + 298)))) then
					local v224 = 0 - 0;
					while true do
						if (((0 - 0) == v224) or ((9739 - 6457) > (1350 + 2750))) then
							if (v104.CastCycle(v100.LavaBurst, v112, v119, not v17:IsSpellInRange(v100.LavaBurst)) or ((2786 + 794) < (3816 - (357 + 615)))) then
								return "lava_burst aoe 56";
							end
							if (((63 + 26) < (11017 - 6527)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 56";
							end
							break;
						end
					end
				end
				if ((v100.LavaBeam:IsAvailable() and v44 and (v124())) or ((4270 + 713) < (3874 - 2066))) then
					if (((3063 + 766) > (257 + 3512)) and v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam))) then
						return "lava_beam aoe 58";
					end
				end
				if (((934 + 551) <= (4205 - (384 + 917))) and v100.ChainLightning:IsAvailable() and v37 and (v124())) then
					if (((4966 - (128 + 569)) == (5812 - (1407 + 136))) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning aoe 60";
					end
				end
				if (((2274 - (687 + 1200)) <= (4492 - (556 + 1154))) and v100.LavaBeam:IsAvailable() and v44 and v14:BuffUp(v100.Power) and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) then
					if (v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam)) or ((6680 - 4781) <= (1012 - (9 + 86)))) then
						return "lava_beam aoe 62";
					end
				end
				if ((v100.ChainLightning:IsAvailable() and v37 and (v123())) or ((4733 - (275 + 146)) <= (143 + 733))) then
					if (((2296 - (29 + 35)) <= (11505 - 8909)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning aoe 64";
					end
				end
				v155 = 14 - 9;
			end
			if (((9248 - 7153) < (2401 + 1285)) and (v155 == (1012 - (53 + 959)))) then
				if ((v100.FireElemental:IsReady() and v54 and ((v60 and v34) or not v60) and (v91 < v108)) or ((2003 - (312 + 96)) >= (7764 - 3290))) then
					if (v25(v100.FireElemental) or ((4904 - (147 + 138)) < (3781 - (813 + 86)))) then
						return "fire_elemental aoe 2";
					end
				end
				if ((v100.StormElemental:IsReady() and v56 and ((v61 and v34) or not v61) and (v91 < v108)) or ((266 + 28) >= (8950 - 4119))) then
					if (((2521 - (18 + 474)) <= (1041 + 2043)) and v25(v100.StormElemental)) then
						return "storm_elemental aoe 4";
					end
				end
				if ((v100.Stormkeeper:IsAvailable() and (v100.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v100.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v108) and not v124()) or ((3123 - (860 + 226)) == (2723 - (121 + 182)))) then
					if (((549 + 3909) > (5144 - (988 + 252))) and v25(v100.Stormkeeper)) then
						return "stormkeeper aoe 7";
					end
				end
				if (((50 + 386) >= (39 + 84)) and v100.TotemicRecall:IsCastable() and (v100.LiquidMagmaTotem:CooldownRemains() > (2015 - (49 + 1921))) and v50) then
					if (((1390 - (223 + 667)) < (1868 - (51 + 1))) and v25(v100.TotemicRecall)) then
						return "totemic_recall aoe 8";
					end
				end
				if (((6151 - 2577) == (7652 - 4078)) and v100.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v34) or not v62) and (v91 < v108) and (v67 == "cursor")) then
					if (((1346 - (146 + 979)) < (111 + 279)) and v25(v102.LiquidMagmaTotemCursor, not v17:IsInRange(645 - (311 + 294)))) then
						return "liquid_magma_totem aoe 10";
					end
				end
				if ((v100.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v34) or not v62) and (v91 < v108) and (v67 == "player")) or ((6171 - 3958) <= (602 + 819))) then
					if (((4501 - (496 + 947)) < (6218 - (1233 + 125))) and v25(v102.LiquidMagmaTotemPlayer, not v17:IsInRange(17 + 23))) then
						return "liquid_magma_totem aoe 11";
					end
				end
				v155 = 1 + 0;
			end
			if ((v155 == (1 + 0)) or ((2941 - (963 + 682)) >= (3711 + 735))) then
				if ((v100.PrimordialWave:IsAvailable() and v48 and ((v65 and v35) or not v65) and v14:BuffDown(v100.PrimordialWaveBuff) and v14:BuffUp(v100.SurgeofPowerBuff) and v14:BuffDown(v100.SplinteredElementsBuff)) or ((2897 - (504 + 1000)) > (3024 + 1465))) then
					local v225 = 0 + 0;
					while true do
						if ((v225 == (0 + 0)) or ((6523 - 2099) < (24 + 3))) then
							if (v104.CastTargetIf(v100.PrimordialWave, v112, "min", v119, nil, not v17:IsSpellInRange(v100.PrimordialWave), nil, nil) or ((1162 + 835) > (3997 - (156 + 26)))) then
								return "primordial_wave aoe 12";
							end
							if (((1997 + 1468) > (2992 - 1079)) and v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave))) then
								return "primordial_wave aoe 12";
							end
							break;
						end
					end
				end
				if (((897 - (149 + 15)) < (2779 - (890 + 70))) and v100.PrimordialWave:IsAvailable() and v48 and ((v65 and v35) or not v65) and v14:BuffDown(v100.PrimordialWaveBuff) and v100.DeeplyRootedElements:IsAvailable() and not v100.SurgeofPower:IsAvailable() and v14:BuffDown(v100.SplinteredElementsBuff)) then
					local v226 = 117 - (39 + 78);
					while true do
						if (((482 - (14 + 468)) == v226) or ((9664 - 5269) == (13290 - 8535))) then
							if (v104.CastTargetIf(v100.PrimordialWave, v112, "min", v119, nil, not v17:IsSpellInRange(v100.PrimordialWave), nil, nil) or ((1958 + 1835) < (1423 + 946))) then
								return "primordial_wave aoe 14";
							end
							if (v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave)) or ((868 + 3216) == (120 + 145))) then
								return "primordial_wave aoe 14";
							end
							break;
						end
					end
				end
				if (((1142 + 3216) == (8341 - 3983)) and v100.PrimordialWave:IsAvailable() and v48 and ((v65 and v35) or not v65) and v14:BuffDown(v100.PrimordialWaveBuff) and v100.MasteroftheElements:IsAvailable() and not v100.LightningRod:IsAvailable()) then
					local v227 = 0 + 0;
					while true do
						if ((v227 == (0 - 0)) or ((80 + 3058) < (1044 - (12 + 39)))) then
							if (((3099 + 231) > (7190 - 4867)) and v104.CastTargetIf(v100.PrimordialWave, v112, "min", v119, nil, not v17:IsSpellInRange(v100.PrimordialWave), nil, nil)) then
								return "primordial_wave aoe 16";
							end
							if (v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave)) or ((12913 - 9287) == (1183 + 2806))) then
								return "primordial_wave aoe 16";
							end
							break;
						end
					end
				end
				if (v100.FlameShock:IsCastable() or ((483 + 433) == (6772 - 4101))) then
					local v228 = 0 + 0;
					while true do
						if (((1314 - 1042) == (1982 - (1596 + 114))) and (v228 == (2 - 1))) then
							if (((4962 - (164 + 549)) <= (6277 - (1059 + 379))) and v100.MasteroftheElements:IsAvailable() and v41 and not v100.LightningRod:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (7 - 1))) then
								local v251 = 0 + 0;
								while true do
									if (((469 + 2308) < (3592 - (145 + 247))) and (v251 == (0 + 0))) then
										if (((44 + 51) < (5801 - 3844)) and v104.CastCycle(v100.FlameShock, v112, v117, not v17:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 22";
										end
										if (((159 + 667) < (1479 + 238)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 22";
										end
										break;
									end
								end
							end
							if (((2314 - 888) >= (1825 - (254 + 466))) and v100.DeeplyRootedElements:IsAvailable() and v41 and not v100.SurgeofPower:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (566 - (544 + 16)))) then
								local v252 = 0 - 0;
								while true do
									if (((3382 - (294 + 334)) <= (3632 - (236 + 17))) and (v252 == (0 + 0))) then
										if (v104.CastCycle(v100.FlameShock, v112, v117, not v17:IsSpellInRange(v100.FlameShock)) or ((3057 + 870) == (5321 - 3908))) then
											return "flame_shock aoe 24";
										end
										if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((5463 - 4309) <= (406 + 382))) then
											return "flame_shock aoe 24";
										end
										break;
									end
								end
							end
							v228 = 2 + 0;
						end
						if ((v228 == (794 - (413 + 381))) or ((70 + 1573) > (7186 - 3807))) then
							if ((v14:BuffUp(v100.SurgeofPowerBuff) and v41 and v100.LightningRod:IsAvailable() and v100.WindspeakersLavaResurgence:IsAvailable() and (v17:DebuffRemains(v100.FlameShockDebuff) < (v17:TimeToDie() - (41 - 25))) and (v111 < (1975 - (582 + 1388)))) or ((4775 - 1972) > (3257 + 1292))) then
								if (v104.CastCycle(v100.FlameShock, v112, v117, not v17:IsSpellInRange(v100.FlameShock)) or ((584 - (326 + 38)) >= (8939 - 5917))) then
									return "flame_shock aoe 18";
								end
								if (((4028 - 1206) == (3442 - (47 + 573))) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 18";
								end
							end
							if ((v14:BuffUp(v100.SurgeofPowerBuff) and v41 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable()) and (v100.FlameShockDebuff:AuraActiveCount() < (3 + 3))) or ((4506 - 3445) == (3013 - 1156))) then
								local v253 = 1664 - (1269 + 395);
								while true do
									if (((3252 - (76 + 416)) > (1807 - (319 + 124))) and (v253 == (0 - 0))) then
										if (v104.CastCycle(v100.FlameShock, v112, v117, not v17:IsSpellInRange(v100.FlameShock)) or ((5909 - (564 + 443)) <= (9952 - 6357))) then
											return "flame_shock aoe 20";
										end
										if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((4310 - (337 + 121)) == (858 - 565))) then
											return "flame_shock aoe 20";
										end
										break;
									end
								end
							end
							v228 = 3 - 2;
						end
						if ((v228 == (1913 - (1261 + 650))) or ((660 + 899) == (7311 - 2723))) then
							if ((v14:BuffUp(v100.SurgeofPowerBuff) and v41 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable())) or ((6301 - (772 + 1045)) == (112 + 676))) then
								local v254 = 144 - (102 + 42);
								while true do
									if (((6412 - (1524 + 320)) >= (5177 - (1049 + 221))) and ((156 - (18 + 138)) == v254)) then
										if (((3049 - 1803) < (4572 - (67 + 1035))) and v104.CastCycle(v100.FlameShock, v112, v118, not v17:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 26";
										end
										if (((4416 - (136 + 212)) >= (4130 - 3158)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 26";
										end
										break;
									end
								end
							end
							if (((395 + 98) < (3589 + 304)) and v100.MasteroftheElements:IsAvailable() and v41 and not v100.LightningRod:IsAvailable()) then
								if (v104.CastCycle(v100.FlameShock, v112, v118, not v17:IsSpellInRange(v100.FlameShock)) or ((3077 - (240 + 1364)) >= (4414 - (1050 + 32)))) then
									return "flame_shock aoe 28";
								end
								if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((14464 - 10413) <= (685 + 472))) then
									return "flame_shock aoe 28";
								end
							end
							v228 = 1058 - (331 + 724);
						end
						if (((49 + 555) < (3525 - (269 + 375))) and ((728 - (267 + 458)) == v228)) then
							if ((v100.DeeplyRootedElements:IsAvailable() and v41 and not v100.SurgeofPower:IsAvailable()) or ((280 + 620) == (6493 - 3116))) then
								local v255 = 818 - (667 + 151);
								while true do
									if (((5956 - (1410 + 87)) > (2488 - (1504 + 393))) and ((0 - 0) == v255)) then
										if (((8815 - 5417) >= (3191 - (461 + 335))) and v104.CastCycle(v100.FlameShock, v112, v118, not v17:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 30";
										end
										if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((279 + 1904) >= (4585 - (1730 + 31)))) then
											return "flame_shock aoe 30";
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (((3603 - (728 + 939)) == (6856 - 4920)) and v100.Ascendance:IsCastable() and v53 and ((v59 and v34) or not v59) and (v91 < v108)) then
					if (v25(v100.Ascendance) or ((9800 - 4968) < (9881 - 5568))) then
						return "ascendance aoe 32";
					end
				end
				if (((5156 - (138 + 930)) > (3541 + 333)) and v100.LavaBurst:IsAvailable() and v45 and v14:BuffUp(v100.LavaSurgeBuff) and v100.MasteroftheElements:IsAvailable() and not v123() and (v122() >= (((47 + 13) - ((5 + 0) * v100.EyeoftheStorm:TalentRank())) - ((8 - 6) * v26(v100.FlowofPower:IsAvailable())))) and ((not v100.EchoesofGreatSundering:IsAvailable() and not v100.LightningRod:IsAvailable()) or v14:BuffUp(v100.EchoesofGreatSunderingBuff)) and ((v14:BuffDown(v100.AscendanceBuff) and (v113 > (1769 - (459 + 1307))) and not v100.UnrelentingCalamity:IsAvailable()) or (v114 == (1873 - (474 + 1396))))) then
					local v229 = 0 - 0;
					while true do
						if (((4060 + 272) == (15 + 4317)) and (v229 == (0 - 0))) then
							if (((507 + 3492) >= (9681 - 6781)) and v104.CastCycle(v100.LavaBurst, v112, v119, not v17:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 34";
							end
							if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((11011 - 8486) > (4655 - (562 + 29)))) then
								return "lava_burst aoe 34";
							end
							break;
						end
					end
				end
				v155 = 2 + 0;
			end
			if (((5790 - (374 + 1045)) == (3460 + 911)) and (v155 == (5 - 3))) then
				if ((v100.Earthquake:IsReady() and v38 and (v52 == "cursor") and not v100.EchoesofGreatSundering:IsAvailable() and (v113 > (641 - (448 + 190))) and (v114 > (1 + 2))) or ((121 + 145) > (3249 + 1737))) then
					if (((7654 - 5663) >= (2874 - 1949)) and v25(v102.EarthquakeCursor, not v17:IsInRange(1534 - (1307 + 187)))) then
						return "earthquake aoe 36";
					end
				end
				if (((1804 - 1349) < (4806 - 2753)) and v100.Earthquake:IsReady() and v38 and (v52 == "player") and not v100.EchoesofGreatSundering:IsAvailable() and (v113 > (8 - 5)) and (v114 > (686 - (232 + 451)))) then
					if (v25(v102.EarthquakePlayer, not v17:IsInRange(39 + 1)) or ((730 + 96) == (5415 - (510 + 54)))) then
						return "earthquake aoe 36";
					end
				end
				if (((368 - 185) == (219 - (13 + 23))) and v100.Earthquake:IsReady() and v38 and (v52 == "cursor") and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (v113 == (5 - 2)) and (v114 == (3 - 0))) then
					if (((2105 - 946) <= (2876 - (830 + 258))) and v25(v102.EarthquakeCursor, not v17:IsInRange(141 - 101))) then
						return "earthquake aoe 38";
					end
				end
				if ((v100.Earthquake:IsReady() and v38 and (v52 == "player") and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (v113 == (2 + 1)) and (v114 == (3 + 0))) or ((4948 - (860 + 581)) > (15927 - 11609))) then
					if (v25(v102.EarthquakePlayer, not v17:IsInRange(32 + 8)) or ((3316 - (237 + 4)) <= (6968 - 4003))) then
						return "earthquake aoe 38";
					end
				end
				if (((3453 - 2088) <= (3812 - 1801)) and v100.Earthquake:IsReady() and v38 and (v52 == "cursor") and (v14:BuffUp(v100.EchoesofGreatSunderingBuff))) then
					if (v25(v102.EarthquakeCursor, not v17:IsInRange(33 + 7)) or ((1595 + 1181) > (13496 - 9921))) then
						return "earthquake aoe 40";
					end
				end
				if ((v100.Earthquake:IsReady() and v38 and (v52 == "player") and (v14:BuffUp(v100.EchoesofGreatSunderingBuff))) or ((1096 + 1458) == (2614 + 2190))) then
					if (((4003 - (85 + 1341)) == (4396 - 1819)) and v25(v102.EarthquakePlayer, not v17:IsInRange(112 - 72))) then
						return "earthquake aoe 40";
					end
				end
				v155 = 375 - (45 + 327);
			end
			if ((v155 == (10 - 4)) or ((508 - (444 + 58)) >= (821 + 1068))) then
				if (((88 + 418) <= (925 + 967)) and v100.Icefury:IsAvailable() and (v100.Icefury:CooldownRemains() == (0 - 0)) and v43 and v100.ElectrifiedShocks:IsAvailable() and (v114 < (1737 - (64 + 1668)))) then
					if (v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury)) or ((3981 - (1227 + 746)) > (6817 - 4599))) then
						return "icefury aoe 78";
					end
				end
				if (((702 - 323) <= (4641 - (415 + 79))) and v100.FrostShock:IsCastable() and v42 and v125() and v100.ElectrifiedShocks:IsAvailable() and v17:DebuffDown(v100.ElectrifiedShocksDebuff) and (v113 < (1 + 4)) and v100.UnrelentingCalamity:IsAvailable()) then
					if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((5005 - (142 + 349)) <= (433 + 576))) then
						return "frost_shock aoe 80";
					end
				end
				if ((v100.LavaBeam:IsAvailable() and v44 and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((4806 - 1310) == (593 + 599))) then
					if (v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam)) or ((147 + 61) == (8058 - 5099))) then
						return "lava_beam aoe 82";
					end
				end
				if (((6141 - (1710 + 154)) >= (1631 - (200 + 118))) and v100.ChainLightning:IsAvailable() and v37) then
					if (((1026 + 1561) < (5549 - 2375)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning aoe 84";
					end
				end
				if ((v100.FlameShock:IsCastable() and v41) or ((6110 - 1990) <= (1953 + 245))) then
					local v230 = 0 + 0;
					while true do
						if (((0 + 0) == v230) or ((255 + 1341) == (1858 - 1000))) then
							if (((4470 - (363 + 887)) == (5622 - 2402)) and v104.CastCycle(v100.FlameShock, v112, v116, not v17:IsSpellInRange(v100.FlameShock))) then
								return "flame_shock moving aoe 86";
							end
							if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((6673 - 5271) > (559 + 3061))) then
								return "flame_shock moving aoe 86";
							end
							break;
						end
					end
				end
				if (((6022 - 3448) == (1759 + 815)) and v100.FrostShock:IsCastable() and v42) then
					if (((3462 - (674 + 990)) < (791 + 1966)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock moving aoe 88";
					end
				end
				break;
			end
		end
	end
	local function v132()
		local v156 = 0 + 0;
		while true do
			if ((v156 == (1 - 0)) or ((1432 - (507 + 548)) > (3441 - (289 + 548)))) then
				if (((2386 - (821 + 997)) < (1166 - (195 + 60))) and v100.FlameShock:IsCastable() and v41 and (v100.FlameShockDebuff:AuraActiveCount() == (0 + 0)) and (v113 > (1502 - (251 + 1250))) and (v114 > (2 - 1)) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((not v123() and (v124() or (v100.Stormkeeper:CooldownRemains() > (0 + 0)))) or not v100.SurgeofPower:IsAvailable())) then
					if (((4317 - (809 + 223)) < (6169 - 1941)) and v104.CastTargetIf(v100.FlameShock, v112, "min", v119, nil, not v17:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock single_target 14";
					end
					if (((11759 - 7843) > (11003 - 7675)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock single_target 14";
					end
				end
				if (((1842 + 658) < (2011 + 1828)) and v100.FlameShock:IsCastable() and v41 and (v113 > (618 - (14 + 603))) and (v114 > (130 - (118 + 11))) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((v14:BuffUp(v100.SurgeofPowerBuff) and not v124() and v100.Stormkeeper:IsAvailable()) or not v100.SurgeofPower:IsAvailable())) then
					local v231 = 0 + 0;
					while true do
						if (((423 + 84) == (1477 - 970)) and (v231 == (949 - (551 + 398)))) then
							if (((152 + 88) <= (1127 + 2038)) and v104.CastTargetIf(v100.FlameShock, v112, "min", v119, v116, not v17:IsSpellInRange(v100.FlameShock))) then
								return "flame_shock single_target 16";
							end
							if (((678 + 156) >= (2993 - 2188)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
								return "flame_shock single_target 16";
							end
							break;
						end
					end
				end
				if ((v100.Stormkeeper:IsAvailable() and (v100.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v100.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v108) and v14:BuffDown(v100.AscendanceBuff) and not v124() and (v122() >= (38 + 78)) and v100.ElementalBlast:IsAvailable() and v100.SurgeofPower:IsAvailable() and v100.SwellingMaelstrom:IsAvailable() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) or ((15132 - 11320) < (640 + 1676))) then
					if (v25(v100.Stormkeeper) or ((2741 - (40 + 49)) <= (5837 - 4304))) then
						return "stormkeeper single_target 18";
					end
				end
				if ((v100.Stormkeeper:IsAvailable() and (v100.Stormkeeper:CooldownRemains() == (490 - (99 + 391))) and not v14:BuffUp(v100.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v108) and v14:BuffDown(v100.AscendanceBuff) and not v124() and v14:BuffUp(v100.SurgeofPowerBuff) and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) or ((2977 + 621) < (6418 - 4958))) then
					if (v25(v100.Stormkeeper) or ((10192 - 6076) < (1162 + 30))) then
						return "stormkeeper single_target 20";
					end
				end
				if ((v100.Stormkeeper:IsAvailable() and (v100.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v100.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v108) and v14:BuffDown(v100.AscendanceBuff) and not v124() and (not v100.SurgeofPower:IsAvailable() or not v100.ElementalBlast:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.EchooftheElements:IsAvailable() or v100.PrimordialSurge:IsAvailable())) or ((4981 - (1032 + 572)) <= (1320 - (203 + 214)))) then
					if (((5793 - (568 + 1249)) >= (344 + 95)) and v25(v100.Stormkeeper)) then
						return "stormkeeper single_target 22";
					end
				end
				if (((9011 - 5259) == (14492 - 10740)) and v100.Ascendance:IsCastable() and v53 and ((v59 and v34) or not v59) and (v91 < v108) and not v124()) then
					if (((5352 - (913 + 393)) > (7610 - 4915)) and v25(v100.Ascendance)) then
						return "ascendance single_target 24";
					end
				end
				if ((v100.LightningBolt:IsAvailable() and v46 and v124() and v14:BuffUp(v100.SurgeofPowerBuff)) or ((5008 - 1463) == (3607 - (269 + 141)))) then
					if (((5324 - 2930) > (2354 - (362 + 1619))) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
						return "lightning_bolt single_target 26";
					end
				end
				v156 = 1627 - (950 + 675);
			end
			if (((1602 + 2553) <= (5411 - (216 + 963))) and (v156 == (1292 - (485 + 802)))) then
				if ((v100.Earthquake:IsReady() and v38 and (v52 == "player") and (v113 > (560 - (432 + 127))) and (v114 > (1074 - (1065 + 8))) and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable()) or ((1990 + 1591) == (5074 - (635 + 966)))) then
					if (((3592 + 1403) > (3390 - (5 + 37))) and v25(v102.EarthquakePlayer, not v17:IsInRange(99 - 59))) then
						return "earthquake single_target 66";
					end
				end
				if ((v100.ElementalBlast:IsAvailable() and v40 and (not v100.MasteroftheElements:IsAvailable() or (v123() and v17:DebuffUp(v100.ElectrifiedShocksDebuff)))) or ((314 + 440) > (5893 - 2169))) then
					if (((102 + 115) >= (118 - 61)) and v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast single_target 68";
					end
				end
				if ((v100.FrostShock:IsCastable() and v42 and v125() and v123() and (v122() < (417 - 307)) and (v100.LavaBurst:ChargesFractional() < (1 - 0)) and v100.ElectrifiedShocks:IsAvailable() and v100.ElementalBlast:IsAvailable() and not v100.LightningRod:IsAvailable()) or ((4949 - 2879) >= (2903 + 1134))) then
					if (((3234 - (318 + 211)) == (13309 - 10604)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single_target 70";
					end
				end
				if (((1648 - (963 + 624)) == (27 + 34)) and v100.ElementalBlast:IsAvailable() and v40 and (v123() or v100.LightningRod:IsAvailable())) then
					if (v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast)) or ((1545 - (518 + 328)) >= (3021 - 1725))) then
						return "elemental_blast single_target 72";
					end
				end
				if ((v100.EarthShock:IsReady() and v39) or ((2849 - 1066) >= (3933 - (301 + 16)))) then
					if (v25(v100.EarthShock, not v17:IsSpellInRange(v100.EarthShock)) or ((11468 - 7555) > (12714 - 8187))) then
						return "earth_shock single_target 74";
					end
				end
				if (((11418 - 7042) > (741 + 76)) and v100.FrostShock:IsCastable() and v42 and v125() and v100.ElectrifiedShocks:IsAvailable() and v123() and not v100.LightningRod:IsAvailable() and (v113 > (1 + 0)) and (v114 > (1 - 0))) then
					if (((2925 + 1936) > (79 + 745)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single_target 76";
					end
				end
				if ((v100.LavaBurst:IsAvailable() and v45 and v14:BuffUp(v100.FluxMeltingBuff) and (v113 > (3 - 2))) or ((447 + 936) >= (3150 - (829 + 190)))) then
					local v232 = 0 - 0;
					while true do
						if ((v232 == (0 - 0)) or ((2592 - 716) >= (6312 - 3771))) then
							if (((423 + 1359) <= (1233 + 2539)) and v104.CastCycle(v100.LavaBurst, v112, v120, not v17:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst single_target 78";
							end
							if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((14265 - 9565) < (768 + 45))) then
								return "lava_burst single_target 78";
							end
							break;
						end
					end
				end
				v156 = 619 - (520 + 93);
			end
			if (((3475 - (259 + 17)) < (234 + 3816)) and (v156 == (2 + 2))) then
				if ((v100.LavaBurst:IsAvailable() and v45 and v14:BuffUp(v100.AscendanceBuff) and (v14:HasTier(104 - 73, 595 - (396 + 195)) or not v100.ElementalBlast:IsAvailable())) or ((14364 - 9413) < (6191 - (440 + 1321)))) then
					local v233 = 1829 - (1059 + 770);
					while true do
						if (((443 - 347) == (641 - (424 + 121))) and (v233 == (0 + 0))) then
							if (v104.CastCycle(v100.LavaBurst, v112, v120, not v17:IsSpellInRange(v100.LavaBurst)) or ((4086 - (641 + 706)) > (1588 + 2420))) then
								return "lava_burst single_target 56";
							end
							if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((463 - (249 + 191)) == (4939 - 3805))) then
								return "lava_burst single_target 56";
							end
							break;
						end
					end
				end
				if ((v100.LavaBurst:IsAvailable() and v45 and v14:BuffDown(v100.AscendanceBuff) and (not v100.ElementalBlast:IsAvailable() or not v100.MountainsWillFall:IsAvailable()) and not v100.LightningRod:IsAvailable() and v14:HasTier(14 + 17, 15 - 11)) or ((3120 - (183 + 244)) >= (202 + 3909))) then
					local v234 = 730 - (434 + 296);
					while true do
						if ((v234 == (0 - 0)) or ((4828 - (169 + 343)) <= (1882 + 264))) then
							if (v104.CastCycle(v100.LavaBurst, v112, v120, not v17:IsSpellInRange(v100.LavaBurst)) or ((6238 - 2692) <= (8244 - 5435))) then
								return "lava_burst single_target 58";
							end
							if (((4018 + 886) > (6142 - 3976)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst single_target 58";
							end
							break;
						end
					end
				end
				if (((1232 - (651 + 472)) >= (69 + 21)) and v100.LavaBurst:IsAvailable() and v45 and v100.MasteroftheElements:IsAvailable() and not v123() and not v100.LightningRod:IsAvailable()) then
					if (((2148 + 2830) > (3545 - 640)) and v104.CastCycle(v100.LavaBurst, v112, v120, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 60";
					end
					if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((3509 - (397 + 86)) <= (3156 - (423 + 453)))) then
						return "lava_burst single_target 60";
					end
				end
				if ((v100.LavaBurst:IsAvailable() and v45 and v100.MasteroftheElements:IsAvailable() and not v123() and ((v122() >= (8 + 67)) or ((v122() >= (7 + 43)) and not v100.ElementalBlast:IsAvailable())) and v100.SwellingMaelstrom:IsAvailable() and (v122() <= (114 + 16))) or ((1320 + 333) <= (990 + 118))) then
					if (((4099 - (50 + 1140)) > (2256 + 353)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 62";
					end
				end
				if (((447 + 310) > (13 + 181)) and v100.Earthquake:IsReady() and v38 and (v52 == "cursor") and v14:BuffUp(v100.EchoesofGreatSunderingBuff) and ((not v100.ElementalBlast:IsAvailable() and (v113 < (2 - 0))) or (v113 > (1 + 0)))) then
					if (v25(v102.EarthquakeCursor, not v17:IsInRange(636 - (157 + 439))) or ((53 - 22) >= (4644 - 3246))) then
						return "earthquake single_target 64";
					end
				end
				if (((9453 - 6257) <= (5790 - (782 + 136))) and v100.Earthquake:IsReady() and v38 and (v52 == "player") and v14:BuffUp(v100.EchoesofGreatSunderingBuff) and ((not v100.ElementalBlast:IsAvailable() and (v113 < (857 - (112 + 743)))) or (v113 > (1172 - (1026 + 145))))) then
					if (((571 + 2755) == (4044 - (493 + 225))) and v25(v102.EarthquakePlayer, not v17:IsInRange(147 - 107))) then
						return "earthquake single_target 64";
					end
				end
				if (((872 + 561) <= (10397 - 6519)) and v100.Earthquake:IsReady() and v38 and (v52 == "cursor") and (v113 > (1 + 0)) and (v114 > (2 - 1)) and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable()) then
					if (v25(v102.EarthquakeCursor, not v17:IsInRange(12 + 28)) or ((2643 - 1060) == (3330 - (210 + 1385)))) then
						return "earthquake single_target 66";
					end
				end
				v156 = 1694 - (1201 + 488);
			end
			if ((v156 == (2 + 0)) or ((5301 - 2320) == (4214 - 1864))) then
				if ((v100.LavaBeam:IsCastable() and v44 and (v113 > (586 - (352 + 233))) and (v114 > (2 - 1)) and v124() and not v100.SurgeofPower:IsAvailable()) or ((2430 + 2036) <= (1401 - 908))) then
					if (v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam)) or ((3121 - (489 + 85)) <= (3488 - (277 + 1224)))) then
						return "lava_beam single_target 28";
					end
				end
				if (((4454 - (663 + 830)) > (2407 + 333)) and v100.ChainLightning:IsAvailable() and v37 and (v113 > (2 - 1)) and (v114 > (876 - (461 + 414))) and v124() and not v100.SurgeofPower:IsAvailable()) then
					if (((620 + 3076) >= (1446 + 2166)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning single_target 30";
					end
				end
				if ((v100.LavaBurst:IsAvailable() and v45 and v124() and not v123() and not v100.SurgeofPower:IsAvailable() and v100.MasteroftheElements:IsAvailable()) or ((283 + 2687) == (1852 + 26))) then
					if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((3943 - (172 + 78)) < (3187 - 1210))) then
						return "lava_burst single_target 32";
					end
				end
				if ((v100.LightningBolt:IsAvailable() and v46 and v124() and not v100.SurgeofPower:IsAvailable() and v123()) or ((343 + 587) > (3031 - 930))) then
					if (((1133 + 3020) > (1031 + 2055)) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
						return "lightning_bolt single_target 34";
					end
				end
				if ((v100.LightningBolt:IsAvailable() and v46 and v124() and not v100.SurgeofPower:IsAvailable() and not v100.MasteroftheElements:IsAvailable()) or ((7796 - 3142) <= (5098 - 1048))) then
					if (v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt)) or ((655 + 1947) < (828 + 668))) then
						return "lightning_bolt single_target 36";
					end
				end
				if ((v100.LightningBolt:IsAvailable() and v46 and v14:BuffUp(v100.SurgeofPowerBuff) and v100.LightningRod:IsAvailable()) or ((364 + 656) > (9107 - 6819))) then
					if (((764 - 436) == (101 + 227)) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
						return "lightning_bolt single_target 38";
					end
				end
				if (((863 + 648) < (4255 - (133 + 314))) and v100.Icefury:IsAvailable() and (v100.Icefury:CooldownRemains() == (0 + 0)) and v43 and v100.ElectrifiedShocks:IsAvailable() and v100.LightningRod:IsAvailable() and v100.LightningRod:IsAvailable()) then
					if (v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury)) or ((2723 - (199 + 14)) > (17609 - 12690))) then
						return "icefury single_target 40";
					end
				end
				v156 = 1552 - (647 + 902);
			end
			if (((14322 - 9559) == (4996 - (85 + 148))) and ((1295 - (426 + 863)) == v156)) then
				if (((19361 - 15224) > (3502 - (873 + 781))) and v100.FrostShock:IsCastable() and v42 and v125() and v100.FluxMelting:IsAvailable() and v14:BuffDown(v100.FluxMeltingBuff)) then
					if (((3261 - 825) <= (8463 - 5329)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single_target 80";
					end
				end
				if (((1543 + 2180) == (13753 - 10030)) and v100.FrostShock:IsCastable() and v42 and v125() and ((v100.ElectrifiedShocks:IsAvailable() and (v17:DebuffRemains(v100.ElectrifiedShocksDebuff) < (2 - 0))) or (v14:BuffRemains(v100.IcefuryBuff) < (17 - 11)))) then
					if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((5993 - (414 + 1533)) >= (3743 + 573))) then
						return "frost_shock single_target 82";
					end
				end
				if ((v100.LavaBurst:IsAvailable() and v45 and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.ElementalBlast:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or v124())) or ((2563 - (443 + 112)) < (3408 - (888 + 591)))) then
					local v235 = 0 - 0;
					while true do
						if (((136 + 2248) > (6685 - 4910)) and (v235 == (0 + 0))) then
							if (v104.CastCycle(v100.LavaBurst, v112, v120, not v17:IsSpellInRange(v100.LavaBurst)) or ((2198 + 2345) <= (468 + 3908))) then
								return "lava_burst single_target 84";
							end
							if (((1387 - 659) == (1348 - 620)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst single_target 84";
							end
							break;
						end
					end
				end
				if ((v100.ElementalBlast:IsAvailable() and v40) or ((2754 - (136 + 1542)) > (15317 - 10646))) then
					if (((1838 + 13) >= (600 - 222)) and v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast single_target 86";
					end
				end
				if ((v100.ChainLightning:IsAvailable() and v37 and v123() and v100.UnrelentingCalamity:IsAvailable() and (v113 > (1 + 0)) and (v114 > (487 - (68 + 418)))) or ((5280 - 3332) >= (6306 - 2830))) then
					if (((4139 + 655) >= (1925 - (770 + 322))) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning single_target 88";
					end
				end
				if (((236 + 3854) == (1183 + 2907)) and v100.LightningBolt:IsAvailable() and v46 and v123() and v100.UnrelentingCalamity:IsAvailable()) then
					if (v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt)) or ((513 + 3245) == (3573 - 1075))) then
						return "lightning_bolt single_target 90";
					end
				end
				if ((v100.Icefury:IsAvailable() and (v100.Icefury:CooldownRemains() == (0 - 0)) and v43) or ((7279 - 4606) < (5793 - 4218))) then
					if (v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury)) or ((2073 + 1648) <= (2180 - 725))) then
						return "icefury single_target 92";
					end
				end
				v156 = 4 + 3;
			end
			if (((573 + 361) < (1779 + 491)) and (v156 == (11 - 8))) then
				if ((v100.FrostShock:IsCastable() and v42 and v125() and v100.ElectrifiedShocks:IsAvailable() and ((v17:DebuffRemains(v100.ElectrifiedShocksDebuff) < (2 - 0)) or (v14:BuffRemains(v100.IcefuryBuff) <= v14:GCD())) and v100.LightningRod:IsAvailable()) or ((545 + 1067) == (5781 - 4526))) then
					if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((14386 - 10034) < (1730 + 2476))) then
						return "frost_shock single_target 42";
					end
				end
				if ((v100.FrostShock:IsCastable() and v42 and v125() and v100.ElectrifiedShocks:IsAvailable() and (v122() >= (247 - 197)) and (v17:DebuffRemains(v100.ElectrifiedShocksDebuff) < ((833 - (762 + 69)) * v14:GCD())) and v124() and v100.LightningRod:IsAvailable()) or ((9260 - 6400) <= (156 + 25))) then
					if (((2086 + 1136) >= (3693 - 2166)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single_target 44";
					end
				end
				if (((474 + 1031) <= (34 + 2087)) and v100.LavaBeam:IsCastable() and v44 and (v113 > (3 - 2)) and (v114 > (158 - (8 + 149))) and v123() and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime()) and not v14:HasTier(1351 - (1199 + 121), 6 - 2)) then
					if (((1679 - 935) == (307 + 437)) and v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam))) then
						return "lava_beam single_target 46";
					end
				end
				if ((v100.FrostShock:IsCastable() and v42 and v125() and v124() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable() and v100.ElementalBlast:IsAvailable() and (((v122() >= (217 - 156)) and (v122() < (174 - 99)) and (v100.LavaBurst:CooldownRemains() > v14:GCD())) or ((v122() >= (44 + 5)) and (v122() < (1870 - (518 + 1289))) and (v100.LavaBurst:CooldownRemains() > (0 - 0))))) or ((263 + 1716) >= (4141 - 1305))) then
					if (((1351 + 482) <= (3137 - (304 + 165))) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single_target 48";
					end
				end
				if (((3480 + 206) == (3846 - (54 + 106))) and v100.FrostShock:IsCastable() and v42 and v125() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (((v122() >= (2005 - (1618 + 351))) and (v122() < (36 + 14)) and (v100.LavaBurst:CooldownRemains() > v14:GCD())) or ((v122() >= (1040 - (10 + 1006))) and (v122() < (10 + 28)) and (v100.LavaBurst:CooldownRemains() > (0 + 0))))) then
					if (((11239 - 7772) > (1510 - (912 + 121))) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single_target 50";
					end
				end
				if ((v100.LavaBurst:IsAvailable() and v45 and v14:BuffUp(v100.WindspeakersLavaResurgenceBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or ((v122() >= (30 + 33)) and v100.MasteroftheElements:IsAvailable()) or ((v122() >= (1327 - (1140 + 149))) and v14:BuffUp(v100.EchoesofGreatSunderingBuff) and (v113 > (1 + 0)) and (v114 > (1 - 0))) or not v100.ElementalBlast:IsAvailable())) or ((612 + 2676) >= (12118 - 8577))) then
					if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((6670 - 3113) == (784 + 3756))) then
						return "lava_burst single_target 52";
					end
				end
				if ((v100.LavaBurst:IsAvailable() and v45 and v14:BuffUp(v100.LavaSurgeBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or not v100.ElementalBlast:IsAvailable())) or ((905 - 644) > (1453 - (165 + 21)))) then
					if (((1383 - (61 + 50)) < (1590 + 2268)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 54";
					end
				end
				v156 = 19 - 15;
			end
			if (((7383 - 3719) == (1440 + 2224)) and (v156 == (1460 - (1295 + 165)))) then
				if (((443 + 1498) >= (181 + 269)) and v100.FireElemental:IsCastable() and v54 and ((v60 and v34) or not v60) and (v91 < v108)) then
					if (v25(v100.FireElemental) or ((6043 - (819 + 578)) < (1726 - (331 + 1071)))) then
						return "fire_elemental single_target 2";
					end
				end
				if (((4576 - (588 + 155)) == (5115 - (546 + 736))) and v100.StormElemental:IsCastable() and v56 and ((v61 and v34) or not v61) and (v91 < v108)) then
					if (v25(v100.StormElemental) or ((3177 - (1834 + 103)) > (2074 + 1296))) then
						return "storm_elemental single_target 4";
					end
				end
				if ((v100.TotemicRecall:IsCastable() and v50 and (v100.LiquidMagmaTotem:CooldownRemains() > (134 - 89)) and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or ((v113 > (1767 - (1536 + 230))) and (v114 > (492 - (128 + 363)))))) or ((528 + 1953) == (11648 - 6966))) then
					if (((1221 + 3506) >= (344 - 136)) and v25(v100.TotemicRecall)) then
						return "totemic_recall single_target 7";
					end
				end
				if (((824 - 544) < (9353 - 5502)) and v100.LiquidMagmaTotem:IsCastable() and v55 and ((v62 and v34) or not v62) and (v91 < v108) and (v67 == "cursor") and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or (v100.FlameShockDebuff:AuraActiveCount() == (0 + 0)) or (v17:DebuffRemains(v100.FlameShockDebuff) < (1015 - (615 + 394))) or ((v113 > (1 + 0)) and (v114 > (1 + 0))))) then
					if (v25(v102.LiquidMagmaTotemCursor, not v17:IsInRange(121 - 81)) or ((13639 - 10632) > (3845 - (59 + 592)))) then
						return "liquid_magma_totem single_target 8";
					end
				end
				if ((v100.LiquidMagmaTotem:IsCastable() and v55 and ((v62 and v34) or not v62) and (v91 < v108) and (v67 == "player") and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or (v100.FlameShockDebuff:AuraActiveCount() == (0 - 0)) or (v17:DebuffRemains(v100.FlameShockDebuff) < (10 - 4)) or ((v113 > (1 + 0)) and (v114 > (172 - (70 + 101)))))) or ((5280 - 3144) >= (2090 + 856))) then
					if (((5437 - 3272) <= (2762 - (123 + 118))) and v25(v102.LiquidMagmaTotemPlayer, not v17:IsInRange(10 + 30))) then
						return "liquid_magma_totem single_target 8";
					end
				end
				if (((36 + 2825) > (2060 - (653 + 746))) and v100.PrimordialWave:IsAvailable() and v48 and v65 and (v91 < v108) and v35 and v14:BuffDown(v100.PrimordialWaveBuff) and v14:BuffDown(v100.SplinteredElementsBuff)) then
					local v236 = 0 - 0;
					while true do
						if (((6519 - 1994) > (12098 - 7579)) and (v236 == (0 + 0))) then
							if (((2034 + 1144) > (849 + 123)) and v104.CastTargetIf(v100.PrimordialWave, v112, "min", v119, nil, not v17:IsSpellInRange(v100.PrimordialWave), nil, nil)) then
								return "primordial_wave single_target 10";
							end
							if (((584 + 4182) == (744 + 4022)) and v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave))) then
								return "primordial_wave single_target 10";
							end
							break;
						end
					end
				end
				if ((v100.FlameShock:IsCastable() and v41 and (v113 == (2 - 1)) and v17:DebuffRefreshable(v100.FlameShockDebuff) and v14:BuffDown(v100.SurgeofPowerBuff) and (not v123() or (not v124() and ((v100.ElementalBlast:IsAvailable() and (v122() < ((86 + 4) - ((14 - 6) * v100.EyeoftheStorm:TalentRank())))) or (v122() < ((1294 - (885 + 349)) - ((4 + 1) * v100.EyeoftheStorm:TalentRank()))))))) or ((7486 - 4741) > (9098 - 5970))) then
					if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((2112 - (915 + 53)) >= (5407 - (768 + 33)))) then
						return "flame_shock single_target 12";
					end
				end
				v156 = 3 - 2;
			end
			if (((5876 - 2538) >= (605 - (287 + 41))) and (v156 == (855 - (638 + 209)))) then
				if (((1357 + 1253) > (4246 - (96 + 1590))) and v100.ChainLightning:IsAvailable() and v37 and (v113 > (1673 - (741 + 931))) and (v114 > (1 + 0))) then
					if (v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning)) or ((3401 - 2207) > (14403 - 11320))) then
						return "chain_lightning single_target 108";
					end
				end
				if (((394 + 522) >= (321 + 426)) and v100.LightningBolt:IsAvailable() and v46) then
					if (v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt)) or ((779 + 1665) > (11209 - 8255))) then
						return "lightning_bolt single_target 110";
					end
				end
				if (((940 + 1952) < (1716 + 1798)) and v100.FlameShock:IsCastable() and v41 and (v14:IsMoving())) then
					local v237 = 0 - 0;
					while true do
						if (((479 + 54) == (1027 - (64 + 430))) and (v237 == (0 + 0))) then
							if (((958 - (106 + 257)) <= (2420 + 993)) and v104.CastCycle(v100.FlameShock, v112, v116, not v17:IsSpellInRange(v100.FlameShock))) then
								return "flame_shock single_target 112";
							end
							if (((3799 - (496 + 225)) >= (5298 - 2707)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
								return "flame_shock single_target 112";
							end
							break;
						end
					end
				end
				if (((15583 - 12384) < (5688 - (256 + 1402))) and v100.FlameShock:IsCastable() and v41) then
					if (((2676 - (30 + 1869)) < (3447 - (213 + 1156))) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock single_target 114";
					end
				end
				if (((1884 - (96 + 92)) <= (389 + 1893)) and v100.FrostShock:IsCastable() and v42) then
					if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((2660 - (142 + 757)) >= (2006 + 456))) then
						return "frost_shock single_target 116";
					end
				end
				break;
			end
			if (((1860 + 2691) > (2407 - (32 + 47))) and (v156 == (1984 - (1053 + 924)))) then
				if (((3747 + 78) >= (803 - 336)) and v100.ChainLightning:IsAvailable() and v37 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v100.LightningRodDebuff) and (v17:DebuffUp(v100.ElectrifiedShocksDebuff) or v123()) and (v113 > (1649 - (685 + 963))) and (v114 > (1 - 0))) then
					if (v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning)) or ((4507 - 1617) == (2266 - (541 + 1168)))) then
						return "chain_lightning single_target 94";
					end
				end
				if ((v100.LightningBolt:IsAvailable() and v46 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v100.LightningRodDebuff) and (v17:DebuffUp(v100.ElectrifiedShocksDebuff) or v123())) or ((6367 - (645 + 952)) == (3742 - (669 + 169)))) then
					if (v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt)) or ((13519 - 9616) == (9850 - 5314))) then
						return "lightning_bolt single_target 96";
					end
				end
				if (((1382 + 2711) <= (1069 + 3776)) and v100.FrostShock:IsCastable() and v42 and v125() and v123() and v14:BuffDown(v100.LavaSurgeBuff) and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable() and (v100.LavaBurst:ChargesFractional() < (766 - (181 + 584))) and v100.EchooftheElements:IsAvailable()) then
					if (((2964 - (665 + 730)) <= (10510 - 6863)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single_target 98";
					end
				end
				if ((v100.FrostShock:IsCastable() and v42 and v125() and (v100.FluxMelting:IsAvailable() or (v100.ElectrifiedShocks:IsAvailable() and not v100.LightningRod:IsAvailable()))) or ((8250 - 4204) >= (6277 - (540 + 810)))) then
					if (((18483 - 13860) >= (7662 - 4875)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single_target 100";
					end
				end
				if (((1778 + 456) >= (1433 - (166 + 37))) and v100.ChainLightning:IsAvailable() and v37 and v123() and v14:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (1882 - (22 + 1859))) and v100.EchooftheElements:IsAvailable() and (v113 > (1773 - (843 + 929))) and (v114 > (263 - (30 + 232)))) then
					if (v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning)) or ((979 - 636) == (2563 - (55 + 722)))) then
						return "chain_lightning single_target 102";
					end
				end
				if (((5516 - 2946) > (4084 - (78 + 1597))) and v100.LightningBolt:IsAvailable() and v46 and v123() and v14:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (1 + 0)) and v100.EchooftheElements:IsAvailable()) then
					if (v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt)) or ((2374 + 235) >= (2708 + 526))) then
						return "lightning_bolt single_target 104";
					end
				end
				if ((v100.FrostShock:IsCastable() and v42 and v125() and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable()) or ((3582 - (305 + 244)) >= (3740 + 291))) then
					if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((1506 - (95 + 10)) == (3306 + 1362))) then
						return "frost_shock single_target 106";
					end
				end
				v156 = 25 - 17;
			end
		end
	end
	local function v133()
		local v157 = 0 - 0;
		while true do
			if (((3538 - (592 + 170)) >= (4607 - 3286)) and (v157 == (7 - 4))) then
				if ((v100.ImprovedFlametongueWeapon:IsAvailable() and v51 and (not v109 or (v110 < (279687 + 320313))) and v100.FlametongueWeapon:IsAvailable()) or ((190 + 297) > (5561 - 3258))) then
					if (v25(v100.FlamentongueWeapon) or ((731 + 3772) == (6416 - 2954))) then
						return "flametongue_weapon enchant";
					end
				end
				if (((1060 - (353 + 154)) <= (2052 - 509)) and not v14:AffectingCombat() and v32 and v104.TargetIsValid()) then
					local v238 = 0 - 0;
					while true do
						if (((1391 + 624) == (1579 + 436)) and (v238 == (0 + 0))) then
							v31 = v130();
							if (v31 or ((6128 - 1887) <= (4413 - 2081))) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if (((4 - 2) == v157) or ((2450 - (7 + 79)) < (542 + 615))) then
				if ((v100.AncestralSpirit:IsCastable() and v100.AncestralSpirit:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((1348 - (24 + 157)) > (2550 - 1272))) then
					if (v25(v102.AncestralSpiritMouseover) or ((2442 - 1297) <= (308 + 774))) then
						return "ancestral_spirit mouseover";
					end
				end
				v109, v110 = v30();
				v157 = 7 - 4;
			end
			if (((381 - (262 + 118)) == v157) or ((4188 - (1038 + 45)) == (10556 - 5675))) then
				if (v31 or ((2117 - (19 + 211)) > (4991 - (88 + 25)))) then
					return v31;
				end
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v14:CanAttack(v17)) or ((10405 - 6318) > (2043 + 2073))) then
					if (((1033 + 73) <= (2302 - (1007 + 29))) and v25(v100.AncestralSpirit, nil, true)) then
						return "ancestral_spirit";
					end
				end
				v157 = 1 + 1;
			end
			if (((7711 - 4556) < (21992 - 17342)) and (v157 == (0 + 0))) then
				if (((4585 - (340 + 471)) >= (4631 - 2792)) and v74 and v100.EarthShield:IsCastable() and v14:BuffDown(v100.EarthShieldBuff) and ((v75 == "Earth Shield") or (v100.ElementalOrbit:IsAvailable() and v14:BuffUp(v100.LightningShield)))) then
					if (((3400 - (276 + 313)) == (6862 - 4051)) and v25(v100.EarthShield)) then
						return "earth_shield main 2";
					end
				elseif (((1979 + 167) > (476 + 646)) and v74 and v100.LightningShield:IsCastable() and v14:BuffDown(v100.LightningShieldBuff) and ((v75 == "Lightning Shield") or (v100.ElementalOrbit:IsAvailable() and v14:BuffUp(v100.EarthShield)))) then
					if (v25(v100.LightningShield) or ((6 + 50) == (5588 - (495 + 1477)))) then
						return "lightning_shield main 2";
					end
				end
				v31 = v127();
				v157 = 2 - 1;
			end
		end
	end
	local function v134()
		local v158 = 0 + 0;
		while true do
			if ((v158 == (403 - (342 + 61))) or ((1059 + 1362) < (787 - (4 + 161)))) then
				v31 = v128();
				if (((618 + 391) <= (3547 - 2417)) and v31) then
					return v31;
				end
				v158 = 2 - 1;
			end
			if (((3255 - (322 + 175)) < (3543 - (173 + 390))) and (v158 == (1 + 0))) then
				if (v86 or ((400 - (203 + 111)) >= (225 + 3401))) then
					local v239 = 0 + 0;
					while true do
						if (((6989 - 4594) == (2164 + 231)) and (v239 == (706 - (57 + 649)))) then
							if (((4164 - (328 + 56)) > (867 + 1842)) and v81) then
								v31 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 552 - (433 + 79));
								if (v31 or ((22 + 215) >= (1835 + 438))) then
									return v31;
								end
							end
							if (v82 or ((6859 - 4819) <= (3324 - 2621))) then
								v31 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 22 + 8);
								if (((2922 + 357) <= (5003 - (562 + 474))) and v31) then
									return v31;
								end
							end
							v239 = 2 - 1;
						end
						if ((v239 == (1 - 0)) or ((2893 - (76 + 829)) == (2550 - (1506 + 167)))) then
							if (((8060 - 3769) > (2178 - (58 + 208))) and v83) then
								v31 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 18 + 12);
								if (((1428 + 575) < (1344 + 995)) and v31) then
									return v31;
								end
							end
							break;
						end
					end
				end
				if (((1762 - 1330) == (769 - (258 + 79))) and v87) then
					local v240 = 0 + 0;
					while true do
						if ((v240 == (0 - 0)) or ((2615 - (1219 + 251)) >= (2924 - (1231 + 440)))) then
							v31 = v104.HandleIncorporeal(v100.Hex, v102.HexMouseOver, 88 - (34 + 24), true);
							if (((1983 + 1435) > (3953 - 1835)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				v158 = 1 + 1;
			end
			if (((9311 - 6245) <= (12470 - 8580)) and (v158 == (5 - 3))) then
				if (v18 or ((10044 - 7046) >= (7164 - 3883))) then
					if (v85 or ((6238 - (877 + 712)) <= (1576 + 1056))) then
						v31 = v126();
						if (v31 or ((4614 - (242 + 512)) > (10181 - 5309))) then
							return v31;
						end
					end
				end
				if ((v100.GreaterPurge:IsAvailable() and v97 and v100.GreaterPurge:IsReady() and v36 and v84 and not v14:IsCasting() and not v14:IsChanneling() and v104.UnitHasMagicBuff(v17)) or ((4625 - (92 + 535)) == (1810 + 488))) then
					if (v25(v100.GreaterPurge, not v17:IsSpellInRange(v100.GreaterPurge)) or ((16 - 8) >= (172 + 2567))) then
						return "greater_purge damage";
					end
				end
				v158 = 10 - 7;
			end
			if (((2540 + 50) == (1794 + 796)) and (v158 == (1 + 2))) then
				if ((v100.Purge:IsReady() and v97 and v36 and v84 and not v14:IsCasting() and not v14:IsChanneling() and v104.UnitHasMagicBuff(v17)) or ((163 - 81) >= (2850 - 980))) then
					if (((4409 - (1476 + 309)) < (5841 - (299 + 985))) and v25(v100.Purge, not v17:IsSpellInRange(v100.Purge))) then
						return "purge damage";
					end
				end
				if ((v104.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((744 + 2387) > (11610 - 8068))) then
					if (((2670 - (86 + 7)) >= (6448 - 4870)) and (v91 < v108) and v58 and ((v64 and v34) or not v64)) then
						if (((390 + 3713) <= (5451 - (672 + 208))) and v100.BloodFury:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (22 + 28)))) then
							if (v25(v100.BloodFury) or ((1627 - (14 + 118)) == (5232 - (339 + 106)))) then
								return "blood_fury main 2";
							end
						end
						if ((v100.Berserking:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff))) or ((247 + 63) > (2231 + 2203))) then
							if (((3563 - (440 + 955)) <= (4296 + 64)) and v25(v100.Berserking)) then
								return "berserking main 4";
							end
						end
						if (((1785 - 791) == (330 + 664)) and v100.Fireblood:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (124 - 74)))) then
							if (((1134 + 521) > (754 - (260 + 93))) and v25(v100.Fireblood)) then
								return "fireblood main 6";
							end
						end
						if (((2870 + 193) <= (7836 - 4410)) and v100.AncestralCall:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (90 - 40)))) then
							if (((3433 - (1181 + 793)) > (195 + 569)) and v25(v100.AncestralCall)) then
								return "ancestral_call main 8";
							end
						end
						if ((v100.BagofTricks:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff))) or ((948 - (105 + 202)) > (3475 + 859))) then
							if (((4209 - (352 + 458)) >= (9111 - 6851)) and v25(v100.BagofTricks)) then
								return "bag_of_tricks main 10";
							end
						end
					end
					if ((v91 < v108) or ((1004 - 611) >= (4107 + 135))) then
						if (((2890 - 1901) < (5808 - (438 + 511))) and v57 and ((v34 and v63) or not v63)) then
							local v250 = 1383 - (1262 + 121);
							while true do
								if ((v250 == (1068 - (728 + 340))) or ((6585 - (816 + 974)) < (2907 - 1958))) then
									v31 = v129();
									if (((13826 - 9984) == (4181 - (163 + 176))) and v31) then
										return v31;
									end
									break;
								end
							end
						end
					end
					if (((4972 - 3225) <= (16548 - 12947)) and v100.NaturesSwiftness:IsCastable() and v47) then
						if (v25(v100.NaturesSwiftness) or ((243 + 561) > (6169 - (1564 + 246)))) then
							return "natures_swiftness main 12";
						end
					end
					local v241 = v104.HandleDPSPotion(v14:BuffUp(v100.AscendanceBuff));
					if (((5015 - (124 + 221)) >= (2475 + 1148)) and v241) then
						return v241;
					end
					if (((2516 - (115 + 336)) < (5602 - 3058)) and v33 and (v113 > (1 + 1)) and (v114 > (48 - (45 + 1)))) then
						local v248 = 0 + 0;
						while true do
							if (((3301 - (1282 + 708)) <= (4571 - (583 + 629))) and (v248 == (0 + 0))) then
								v31 = v131();
								if (((7028 - 4311) <= (1655 + 1501)) and v31) then
									return v31;
								end
								v248 = 1171 - (943 + 227);
							end
							if (((473 + 608) < (6155 - (1539 + 92))) and (v248 == (1947 - (706 + 1240)))) then
								if (((698 - (81 + 177)) >= (200 - 129)) and v25(v100.Pool)) then
									return "Pool for Aoe()";
								end
								break;
							end
						end
					end
					if (((5191 - (212 + 45)) > (8720 - 6113)) and true) then
						local v249 = 1946 - (708 + 1238);
						while true do
							if (((1 + 0) == v249) or ((458 + 942) > (4783 - (586 + 1081)))) then
								if (((1036 - (348 + 163)) < (1493 + 169)) and v25(v100.Pool)) then
									return "Pool for SingleTarget()";
								end
								break;
							end
							if ((v249 == (280 - (215 + 65))) or ((2231 - 1355) > (4409 - (1541 + 318)))) then
								v31 = v132();
								if (((195 + 24) <= (1242 + 1214)) and v31) then
									return v31;
								end
								v249 = 1 + 0;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v135()
		local v159 = 1750 - (1036 + 714);
		while true do
			if ((v159 == (5 + 2)) or ((2331 + 1888) == (2430 - (883 + 397)))) then
				v60 = EpicSettings.Settings['fireElementalWithCD'];
				v61 = EpicSettings.Settings['stormElementalWithCD'];
				v65 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v159 = 598 - (563 + 27);
			end
			if ((v159 == (15 - 11)) or ((4975 - (1369 + 617)) <= (1709 - (85 + 1402)))) then
				v49 = EpicSettings.Settings['useStormkeeper'];
				v50 = EpicSettings.Settings['useTotemicRecall'];
				v51 = EpicSettings.Settings['useWeaponEnchant'];
				v159 = 2 + 3;
			end
			if (((5828 - 3570) > (1644 - (274 + 129))) and (v159 == (225 - (12 + 205)))) then
				v66 = EpicSettings.Settings['stormkeeperWithMiniCD'];
				break;
			end
			if (((38 + 3) < (16513 - 12254)) and ((6 + 0) == v159)) then
				v56 = EpicSettings.Settings['useStormElemental'];
				v59 = EpicSettings.Settings['ascendanceWithCD'];
				v62 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
				v159 = 391 - (27 + 357);
			end
			if ((v159 == (480 - (91 + 389))) or ((2227 - (90 + 207)) < (3 + 53))) then
				v37 = EpicSettings.Settings['useChainlightning'];
				v38 = EpicSettings.Settings['useEarthquake'];
				v39 = EpicSettings.Settings['useEarthshock'];
				v159 = 862 - (706 + 155);
			end
			if (((5128 - (730 + 1065)) == (4896 - (1339 + 224))) and (v159 == (2 + 1))) then
				v46 = EpicSettings.Settings['useLightningBolt'];
				v47 = EpicSettings.Settings['useNaturesSwiftness'];
				v48 = EpicSettings.Settings['usePrimordialWave'];
				v159 = 4 + 0;
			end
			if (((1 - 0) == v159) or ((3068 - (268 + 575)) == (1314 - (919 + 375)))) then
				v40 = EpicSettings.Settings['useElementalBlast'];
				v41 = EpicSettings.Settings['useFlameShock'];
				v42 = EpicSettings.Settings['useFrostShock'];
				v159 = 5 - 3;
			end
			if ((v159 == (973 - (180 + 791))) or ((2677 - (323 + 1482)) >= (5010 - (1177 + 741)))) then
				v43 = EpicSettings.Settings['useIceFury'];
				v44 = EpicSettings.Settings['useLavaBeam'];
				v45 = EpicSettings.Settings['useLavaBurst'];
				v159 = 1 + 2;
			end
			if (((16514 - 12110) >= (1252 + 2000)) and (v159 == (11 - 6))) then
				v53 = EpicSettings.Settings['useAscendance'];
				v55 = EpicSettings.Settings['useLiquidMagmaTotem'];
				v54 = EpicSettings.Settings['useFireElemental'];
				v159 = 1 + 5;
			end
		end
	end
	local function v136()
		v68 = EpicSettings.Settings['useWindShear'];
		v69 = EpicSettings.Settings['useCapacitorTotem'];
		v70 = EpicSettings.Settings['useThunderstorm'];
		v71 = EpicSettings.Settings['useAncestralGuidance'];
		v72 = EpicSettings.Settings['useAstralShift'];
		v73 = EpicSettings.Settings['useHealingStreamTotem'];
		v76 = EpicSettings.Settings['ancestralGuidanceHP'] or (109 - (96 + 13));
		v77 = EpicSettings.Settings['ancestralGuidanceGroup'] or (1921 - (962 + 959));
		v78 = EpicSettings.Settings['astralShiftHP'] or (0 - 0);
		v79 = EpicSettings.Settings['healingStreamTotemHP'] or (0 + 0);
		v80 = EpicSettings.Settings['healingStreamTotemGroup'] or (1351 - (461 + 890));
		v52 = EpicSettings.Settings['earthquakeSetting'] or "";
		v67 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
		v74 = EpicSettings.Settings['autoShield'];
		v75 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
		v98 = EpicSettings.Settings['healOOC'];
		v99 = EpicSettings.Settings['healOOCHP'] or (0 + 0);
		v97 = EpicSettings.Settings['usePurgeTarget'];
		v81 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
		v82 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v83 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
	end
	local function v137()
		v91 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v88 = EpicSettings.Settings['InterruptWithStun'];
		v89 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v90 = EpicSettings.Settings['InterruptThreshold'];
		v85 = EpicSettings.Settings['DispelDebuffs'];
		v84 = EpicSettings.Settings['DispelBuffs'];
		v57 = EpicSettings.Settings['useTrinkets'];
		v58 = EpicSettings.Settings['useRacials'];
		v63 = EpicSettings.Settings['trinketsWithCD'];
		v64 = EpicSettings.Settings['racialsWithCD'];
		v93 = EpicSettings.Settings['useHealthstone'];
		v92 = EpicSettings.Settings['useHealingPotion'];
		v95 = EpicSettings.Settings['healthstoneHP'] or (243 - (19 + 224));
		v94 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
		v96 = EpicSettings.Settings['HealingPotionName'] or "";
		v86 = EpicSettings.Settings['handleAfflicted'];
		v87 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v138()
		local v185 = 198 - (37 + 161);
		while true do
			if (((400 + 707) > (309 + 487)) and (v185 == (2 + 0))) then
				v36 = EpicSettings.Toggles['dispel'];
				v35 = EpicSettings.Toggles['minicds'];
				if (((1020 - (60 + 1)) == (1882 - (826 + 97))) and v14:IsDeadOrGhost()) then
					return v31;
				end
				v185 = 3 + 0;
			end
			if ((v185 == (0 - 0)) or ((504 - 259) >= (2889 - (375 + 310)))) then
				v136();
				v135();
				v137();
				v185 = 2000 - (1864 + 135);
			end
			if (((8158 - 4996) >= (458 + 1611)) and (v185 == (1 + 0))) then
				v32 = EpicSettings.Toggles['ooc'];
				v33 = EpicSettings.Toggles['aoe'];
				v34 = EpicSettings.Toggles['cds'];
				v185 = 4 - 2;
			end
			if ((v185 == (1134 - (314 + 817))) or ((174 + 132) > (3295 - (32 + 182)))) then
				v111 = v14:GetEnemiesInRange(30 + 10);
				v112 = v17:GetEnemiesInSplashRange(17 - 12);
				if (v33 or ((3578 - (39 + 26)) < (2850 - (54 + 90)))) then
					local v242 = 198 - (45 + 153);
					while true do
						if (((1808 + 1170) < (4191 - (457 + 95))) and (v242 == (0 + 0))) then
							v113 = #v111;
							v114 = v28(v17:GetEnemiesInSplashRangeCount(10 - 5), v113);
							break;
						end
					end
				else
					local v243 = 0 - 0;
					while true do
						if (((13313 - 9631) >= (1295 + 1593)) and (v243 == (0 - 0))) then
							v113 = 2 - 1;
							v114 = 749 - (485 + 263);
							break;
						end
					end
				end
				v185 = 711 - (575 + 132);
			end
			if (((1010 - (750 + 111)) < (1489 - (445 + 565))) and (v185 == (4 + 0))) then
				if (((147 + 873) >= (1000 - 433)) and (v14:AffectingCombat() or v85)) then
					local v244 = 0 + 0;
					local v245;
					while true do
						if ((v244 == (310 - (189 + 121))) or ((182 + 551) > (3816 - (634 + 713)))) then
							v245 = v85 and v100.CleanseSpirit:IsReady() and v36;
							v31 = v104.FocusUnit(v245, v102, 558 - (493 + 45), nil, 993 - (493 + 475));
							v244 = 1 + 0;
						end
						if (((3281 - (158 + 626)) == (1175 + 1322)) and (v244 == (1 - 0))) then
							if (((869 + 3032) == (211 + 3690)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				if (((1292 - (1035 + 56)) < (1374 - (114 + 845))) and (v104.TargetIsValid() or v14:AffectingCombat())) then
					local v246 = 0 + 0;
					while true do
						if ((v246 == (2 - 1)) or ((112 + 21) == (2833 - (179 + 870)))) then
							if ((v108 == (15585 - 4474)) or ((885 - (827 + 51)) >= (819 - 509))) then
								v108 = v10.FightRemains(v111, false);
							end
							break;
						end
						if (((2501 + 2491) > (759 - (95 + 378))) and (v246 == (0 + 0))) then
							v107 = v10.BossFightRemains();
							v108 = v107;
							v246 = 1 - 0;
						end
					end
				end
				if ((not v14:IsChanneling() and not v14:IsChanneling()) or ((2250 + 311) == (4904 - (334 + 677)))) then
					local v247 = 0 - 0;
					while true do
						if (((5418 - (1049 + 7)) >= (6205 - 4784)) and (v247 == (1 - 0))) then
							if (((24 + 51) <= (9506 - 5960)) and v14:AffectingCombat()) then
								local v256 = 0 - 0;
								while true do
									if (((1194 + 1486) <= (4838 - (1004 + 416))) and (v256 == (1957 - (1621 + 336)))) then
										v31 = v134();
										if (v31 or ((6227 - (337 + 1602)) < (4393 - (1014 + 503)))) then
											return v31;
										end
										break;
									end
								end
							else
								v31 = v133();
								if (((3477 - (446 + 569)) >= (48 + 1099)) and v31) then
									return v31;
								end
							end
							break;
						end
						if ((v247 == (0 - 0)) or ((1651 + 3263) < (5150 - 2670))) then
							if (v18 or ((32 + 1527) == (1745 - (223 + 282)))) then
								if (((17 + 549) == (900 - 334)) and v85) then
									local v258 = 0 - 0;
									while true do
										if (((4591 - (623 + 47)) >= (3054 - (32 + 13))) and ((0 + 0) == v258)) then
											v31 = v126();
											if (((1674 + 389) >= (3449 - (1070 + 731))) and v31) then
												return v31;
											end
											break;
										end
									end
								end
							end
							if (((1019 + 47) >= (1856 - (1257 + 147))) and v86) then
								local v257 = 0 + 0;
								while true do
									if (((9512 - 4538) >= (2788 - (98 + 35))) and (v257 == (0 + 0))) then
										if (v81 or ((9636 - 6915) <= (3052 - 2145))) then
											local v259 = 0 + 0;
											while true do
												if (((3905 + 532) >= (1328 + 1703)) and (v259 == (557 - (395 + 162)))) then
													v31 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 36 + 4);
													if (v31 or ((6411 - (816 + 1125)) < (4207 - 1258))) then
														return v31;
													end
													break;
												end
											end
										end
										if (v82 or ((2728 - (701 + 447)) == (3736 - 1310))) then
											v31 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 52 - 22);
											if (v31 or ((5052 - (391 + 950)) == (1355 - 852))) then
												return v31;
											end
										end
										v257 = 2 - 1;
									end
									if (((2 - 1) == v257) or ((295 + 125) == (2513 + 1805))) then
										if (v83 or ((15203 - 11045) <= (1555 - (251 + 1271)))) then
											local v260 = 0 + 0;
											while true do
												if ((v260 == (0 - 0)) or ((247 - 148) > (7855 - 3111))) then
													v31 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 1289 - (1147 + 112));
													if (((1085 + 3256) == (8816 - 4475)) and v31) then
														return v31;
													end
													break;
												end
											end
										end
										break;
									end
								end
							end
							v247 = 1 + 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v139()
		v100.FlameShockDebuff:RegisterAuraTracking();
		v106();
		v22.Print("Elemental Shaman by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(959 - (335 + 362), v138, v139);
end;
return v0["Epix_Shaman_Elemental.lua"]();

