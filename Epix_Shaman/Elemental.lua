local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1444 + 144) >= (1907 - (89 + 486))) and not v5) then
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
	local v17 = v11.Focus;
	local v18 = v9.Spell;
	local v19 = v9.MultiSpell;
	local v20 = v9.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Macro;
	local v24 = v21.Press;
	local v25 = v21.Commons.Everyone.num;
	local v26 = v21.Commons.Everyone.bool;
	local v27 = math.max;
	local v28 = GetTime;
	local v29 = GetWeaponEnchantInfo;
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
	local v101 = v18.Shaman.Elemental;
	local v102 = v20.Shaman.Elemental;
	local v103 = v23.Shaman.Elemental;
	local v104 = {};
	local v105 = v21.Commons.Everyone;
	local v106 = v21.Commons.Shaman;
	local function v107()
		if (v101.CleanseSpirit:IsAvailable() or ((3944 + 230) > (10448 - 6200))) then
			v105.DispellableDebuffs = v105.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v107();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v9:RegisterForEvent(function()
		local v147 = 0 - 0;
		while true do
			if ((v147 == (0 + 0)) or ((4976 - (14 + 376)) <= (141 - 59))) then
				v101.PrimordialWave:RegisterInFlightEffect(211696 + 115466);
				v101.PrimordialWave:RegisterInFlight();
				v147 = 1 + 0;
			end
			if (((3685 + 178) == (11319 - 7456)) and (v147 == (1 + 0))) then
				v101.LavaBurst:RegisterInFlight();
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v101.PrimordialWave:RegisterInFlightEffect(327240 - (23 + 55));
	v101.PrimordialWave:RegisterInFlight();
	v101.LavaBurst:RegisterInFlight();
	local v108 = 26332 - 15221;
	local v109 = 7415 + 3696;
	local v110, v111;
	local v112, v113;
	local v114 = 0 + 0;
	local v115 = 0 - 0;
	local v116 = 0 + 0;
	local v117 = 901 - (652 + 249);
	local v118 = 0 - 0;
	local function v119()
		return (1908 - (708 + 1160)) - (v28() - v116);
	end
	v9:RegisterForSelfCombatEvent(function(...)
		local v148, v149, v149, v149, v150 = select(21 - 13, ...);
		if (((v148 == v13:GUID()) and (v150 == (349389 - 157755))) or ((309 - (10 + 17)) <= (10 + 32))) then
			local v216 = 1732 - (1400 + 332);
			while true do
				if (((8840 - 4231) >= (2674 - (242 + 1666))) and (v216 == (0 + 0))) then
					v117 = v28();
					C_Timer.After(0.1 + 0, function()
						if ((v117 ~= v118) or ((982 + 170) == (3428 - (850 + 90)))) then
							v116 = v117;
						end
					end);
					break;
				end
			end
		end
	end, "SPELL_AURA_APPLIED");
	local function v120(v151)
		return (v151:DebuffRefreshable(v101.FlameShockDebuff));
	end
	local function v121(v152)
		return v152:DebuffRefreshable(v101.FlameShockDebuff) and (v152:DebuffRemains(v101.FlameShockDebuff) < (v152:TimeToDie() - (8 - 3)));
	end
	local function v122(v153)
		return v153:DebuffRefreshable(v101.FlameShockDebuff) and (v153:DebuffRemains(v101.FlameShockDebuff) < (v153:TimeToDie() - (1395 - (360 + 1030)))) and (v153:DebuffRemains(v101.FlameShockDebuff) > (0 + 0));
	end
	local function v123(v154)
		return (v154:DebuffRemains(v101.FlameShockDebuff));
	end
	local function v124(v155)
		return v155:DebuffRemains(v101.FlameShockDebuff) > (5 - 3);
	end
	local function v125(v156)
		return (v156:DebuffRemains(v101.LightningRodDebuff));
	end
	local function v126()
		local v157 = 0 - 0;
		local v158;
		while true do
			if (((5083 - (909 + 752)) > (4573 - (109 + 1114))) and (v157 == (0 - 0))) then
				v158 = v13:Maelstrom();
				if (((342 + 535) > (618 - (6 + 236))) and not v13:IsCasting()) then
					return v158;
				elseif (v13:IsCasting(v101.ElementalBlast) or ((1965 + 1153) <= (1490 + 361))) then
					return v158 - (176 - 101);
				elseif (v13:IsCasting(v101.Icefury) or ((288 - 123) >= (4625 - (1076 + 57)))) then
					return v158 + 5 + 20;
				elseif (((4638 - (579 + 110)) < (384 + 4472)) and v13:IsCasting(v101.LightningBolt)) then
					return v158 + 9 + 1;
				elseif (v13:IsCasting(v101.LavaBurst) or ((2270 + 2006) < (3423 - (174 + 233)))) then
					return v158 + (33 - 21);
				elseif (((8231 - 3541) > (1835 + 2290)) and v13:IsCasting(v101.ChainLightning)) then
					return v158 + ((1178 - (663 + 511)) * v115);
				else
					return v158;
				end
				break;
			end
		end
	end
	local function v127(v159)
		local v160 = v159:IsReady();
		if ((v159 == v101.Stormkeeper) or (v159 == v101.ElementalBlast) or (v159 == v101.Icefury) or ((45 + 5) >= (195 + 701))) then
			local v217 = 0 - 0;
			local v218;
			while true do
				if ((v217 == (0 + 0)) or ((4035 - 2321) >= (7160 - 4202))) then
					v218 = v13:BuffUp(v101.SpiritwalkersGraceBuff) or not v13:IsMoving();
					return v160 and v218 and not v13:IsCasting(v159);
				end
			end
		elseif ((v159 == v101.LavaBeam) or ((712 + 779) < (1252 - 608))) then
			local v251 = v13:BuffUp(v101.SpiritwalkersGraceBuff) or not v13:IsMoving();
			return v160 and v251;
		elseif (((502 + 202) < (91 + 896)) and ((v159 == v101.LightningBolt) or (v159 == v101.ChainLightning))) then
			local v275 = 722 - (478 + 244);
			local v276;
			while true do
				if (((4235 - (440 + 77)) > (867 + 1039)) and (v275 == (0 - 0))) then
					v276 = v13:BuffUp(v101.SpiritwalkersGraceBuff) or v13:BuffUp(v101.StormkeeperBuff) or not v13:IsMoving();
					return v160 and v276;
				end
			end
		elseif ((v159 == v101.LavaBurst) or ((2514 - (655 + 901)) > (675 + 2960))) then
			local v279 = 0 + 0;
			local v280;
			local v281;
			local v282;
			local v283;
			while true do
				if (((2364 + 1137) <= (18096 - 13604)) and (v279 == (1445 - (695 + 750)))) then
					v280 = v13:BuffUp(v101.SpiritwalkersGraceBuff) or v13:BuffUp(v101.LavaSurgeBuff) or not v13:IsMoving();
					v281 = v13:BuffUp(v101.LavaSurgeBuff);
					v279 = 3 - 2;
				end
				if ((v279 == (1 - 0)) or ((13842 - 10400) < (2899 - (285 + 66)))) then
					v282 = (v101.LavaBurst:Charges() >= (2 - 1)) and not v13:IsCasting(v101.LavaBurst);
					v283 = (v101.LavaBurst:Charges() == (1312 - (682 + 628))) and v13:IsCasting(v101.LavaBurst);
					v279 = 1 + 1;
				end
				if (((3174 - (176 + 123)) >= (613 + 851)) and (v279 == (2 + 0))) then
					return v160 and v280 and (v281 or v282 or v283);
				end
			end
		elseif ((v159 == v101.PrimordialWave) or ((5066 - (239 + 30)) >= (1331 + 3562))) then
			return v160 and v33 and v13:BuffDown(v101.PrimordialWaveBuff) and v13:BuffDown(v101.LavaSurgeBuff);
		else
			return v160;
		end
	end
	local function v128()
		local v161 = 0 + 0;
		local v162;
		while true do
			if ((v161 == (0 - 0)) or ((1718 - 1167) > (2383 - (306 + 9)))) then
				if (((7376 - 5262) > (165 + 779)) and not v101.MasteroftheElements:IsAvailable()) then
					return false;
				end
				v162 = v13:BuffUp(v101.MasteroftheElementsBuff);
				v161 = 1 + 0;
			end
			if (((1 + 0) == v161) or ((6468 - 4206) >= (4471 - (1140 + 235)))) then
				if (not v13:IsCasting() or ((1436 + 819) >= (3244 + 293))) then
					return v162;
				elseif (v13:IsCasting(v106.LavaBurst) or ((985 + 2852) < (1358 - (33 + 19)))) then
					return true;
				elseif (((1066 + 1884) == (8841 - 5891)) and (v13:IsCasting(v106.ElementalBlast) or v13:IsCasting(v101.Icefury) or v13:IsCasting(v101.LightningBolt) or v13:IsCasting(v101.ChainLightning))) then
					return false;
				else
					return v162;
				end
				break;
			end
		end
	end
	local function v129()
		if (not v101.PoweroftheMaelstrom:IsAvailable() or ((2081 + 2642) < (6467 - 3169))) then
			return false;
		end
		local v163 = v13:BuffStack(v101.PoweroftheMaelstromBuff);
		if (((1066 + 70) >= (843 - (586 + 103))) and not v13:IsCasting()) then
			return v163 > (0 + 0);
		elseif (((v163 == (2 - 1)) and (v13:IsCasting(v101.LightningBolt) or v13:IsCasting(v101.ChainLightning))) or ((1759 - (1309 + 179)) > (8571 - 3823))) then
			return false;
		else
			return v163 > (0 + 0);
		end
	end
	local function v130()
		local v164 = 0 - 0;
		local v165;
		while true do
			if (((3581 + 1159) >= (6696 - 3544)) and (v164 == (1 - 0))) then
				if (not v13:IsCasting() or ((3187 - (295 + 314)) >= (8326 - 4936))) then
					return v165;
				elseif (((2003 - (1300 + 662)) <= (5215 - 3554)) and v13:IsCasting(v101.Stormkeeper)) then
					return true;
				else
					return v165;
				end
				break;
			end
			if (((2356 - (1178 + 577)) < (1849 + 1711)) and (v164 == (0 - 0))) then
				if (((1640 - (851 + 554)) < (608 + 79)) and not v101.Stormkeeper:IsAvailable()) then
					return false;
				end
				v165 = v13:BuffUp(v101.StormkeeperBuff);
				v164 = 2 - 1;
			end
		end
	end
	local function v131()
		if (((9879 - 5330) > (1455 - (115 + 187))) and not v101.Icefury:IsAvailable()) then
			return false;
		end
		local v166 = v13:BuffUp(v101.IcefuryBuff);
		if (not v13:IsCasting() or ((3580 + 1094) < (4423 + 249))) then
			return v166;
		elseif (((14454 - 10786) < (5722 - (160 + 1001))) and v13:IsCasting(v101.Icefury)) then
			return true;
		else
			return v166;
		end
	end
	local v132 = 0 + 0;
	local function v133()
		if ((v101.CleanseSpirit:IsReady() and v35 and (v105.UnitHasDispellableDebuffByPlayer(v17) or v105.DispellableFriendlyUnit(14 + 6) or v105.UnitHasCurseDebuff(v17))) or ((931 - 476) == (3963 - (237 + 121)))) then
			if ((v132 == (897 - (525 + 372))) or ((5048 - 2385) == (10881 - 7569))) then
				v132 = v28();
			end
			if (((4419 - (96 + 46)) <= (5252 - (643 + 134))) and v105.Wait(181 + 319, v132)) then
				if (v24(v103.CleanseSpiritFocus) or ((2086 - 1216) == (4414 - 3225))) then
					return "cleanse_spirit dispel";
				end
				v132 = 0 + 0;
			end
		end
	end
	local function v134()
		if (((3047 - 1494) <= (6403 - 3270)) and v99 and (v13:HealthPercentage() <= v100)) then
			if (v101.HealingSurge:IsReady() or ((2956 - (316 + 403)) >= (2334 + 1177))) then
				if (v24(v101.HealingSurge) or ((3640 - 2316) > (1092 + 1928))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v135()
		if ((v101.AstralShift:IsReady() and v72 and (v13:HealthPercentage() <= v78)) or ((7534 - 4542) == (1333 + 548))) then
			if (((1002 + 2104) > (5287 - 3761)) and v24(v101.AstralShift)) then
				return "astral_shift defensive 1";
			end
		end
		if (((14437 - 11414) < (8039 - 4169)) and v101.AncestralGuidance:IsReady() and v71 and v105.AreUnitsBelowHealthPercentage(v76, v77, v101.HealingSurge)) then
			if (((9 + 134) > (145 - 71)) and v24(v101.AncestralGuidance)) then
				return "ancestral_guidance defensive 2";
			end
		end
		if (((1 + 17) < (6213 - 4101)) and v101.HealingStreamTotem:IsReady() and v73 and v105.AreUnitsBelowHealthPercentage(v79, v80, v101.HealingSurge)) then
			if (((1114 - (12 + 5)) <= (6323 - 4695)) and v24(v101.HealingStreamTotem)) then
				return "healing_stream_totem defensive 3";
			end
		end
		if (((9878 - 5248) == (9842 - 5212)) and v102.Healthstone:IsReady() and v94 and (v13:HealthPercentage() <= v96)) then
			if (((8778 - 5238) > (545 + 2138)) and v24(v103.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if (((6767 - (1656 + 317)) >= (2919 + 356)) and v93 and (v13:HealthPercentage() <= v95)) then
			if (((1190 + 294) == (3945 - 2461)) and (v97 == "Refreshing Healing Potion")) then
				if (((7047 - 5615) < (3909 - (5 + 349))) and v102.RefreshingHealingPotion:IsReady()) then
					if (v24(v103.RefreshingHealingPotion) or ((5058 - 3993) > (4849 - (266 + 1005)))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if ((v97 == "Dreamwalker's Healing Potion") or ((3160 + 1635) < (4800 - 3393))) then
				if (((2439 - 586) < (6509 - (561 + 1135))) and v102.DreamwalkersHealingPotion:IsReady()) then
					if (v24(v103.RefreshingHealingPotion) or ((3675 - 854) < (7990 - 5559))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
			if ((v97 == "Potion of Withering Dreams") or ((3940 - (507 + 559)) < (5472 - 3291))) then
				if (v102.PotionOfWitheringDreams:IsReady() or ((8315 - 5626) <= (731 - (212 + 176)))) then
					if (v24(v103.RefreshingHealingPotion) or ((2774 - (250 + 655)) == (5478 - 3469))) then
						return "potion of withering dreams defensive";
					end
				end
			end
		end
	end
	local function v136()
		local v167 = 0 - 0;
		while true do
			if ((v167 == (0 - 0)) or ((5502 - (1869 + 87)) < (8053 - 5731))) then
				v30 = v105.HandleTopTrinket(v104, v33, 1941 - (484 + 1417), nil);
				if (v30 or ((4462 - 2380) == (7998 - 3225))) then
					return v30;
				end
				v167 = 774 - (48 + 725);
			end
			if (((5298 - 2054) > (2830 - 1775)) and ((1 + 0) == v167)) then
				v30 = v105.HandleBottomTrinket(v104, v33, 106 - 66, nil);
				if (v30 or ((928 + 2385) <= (519 + 1259))) then
					return v30;
				end
				break;
			end
		end
	end
	local function v137()
		local v168 = 853 - (152 + 701);
		while true do
			if ((v168 == (1313 - (430 + 881))) or ((545 + 876) >= (2999 - (557 + 338)))) then
				if (((536 + 1276) <= (9155 - 5906)) and v13:IsCasting(v101.ElementalBlast) and v40 and not v101.PrimordialWave:IsAvailable() and v101.FlameShock:IsCastable()) then
					if (((5683 - 4060) <= (5198 - 3241)) and v24(v101.FlameShock, not v16:IsSpellInRange(v101.FlameShock))) then
						return "flameshock precombat 10";
					end
				end
				if (((9508 - 5096) == (5213 - (499 + 302))) and v127(v101.LavaBurst) and v44 and not v13:IsCasting(v101.LavaBurst) and (not v101.ElementalBlast:IsAvailable() or (v101.ElementalBlast:IsAvailable() and not v127(v101.ElementalBlast)))) then
					if (((2616 - (39 + 827)) >= (2324 - 1482)) and v24(v101.LavaBurst, not v16:IsSpellInRange(v101.LavaBurst))) then
						return "lavaburst precombat 12";
					end
				end
				v168 = 6 - 3;
			end
			if (((17364 - 12992) > (2840 - 990)) and (v168 == (1 + 0))) then
				if (((679 - 447) < (132 + 689)) and v127(v101.ElementalBlast) and v39) then
					if (((819 - 301) < (1006 - (103 + 1))) and v24(v101.ElementalBlast, not v16:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast precombat 6";
					end
				end
				if (((3548 - (475 + 79)) > (1854 - 996)) and v13:IsCasting(v101.ElementalBlast) and v47 and ((v65 and v34) or not v65) and v127(v101.PrimordialWave)) then
					if (v24(v101.PrimordialWave, not v16:IsSpellInRange(v101.PrimordialWave)) or ((12016 - 8261) <= (119 + 796))) then
						return "primordial_wave precombat 8";
					end
				end
				v168 = 2 + 0;
			end
			if (((5449 - (1395 + 108)) > (10892 - 7149)) and (v168 == (1204 - (7 + 1197)))) then
				if ((v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (0 + 0)) and not v13:BuffUp(v101.StormkeeperBuff) and v48 and ((v66 and v34) or not v66) and (v91 < v109)) or ((466 + 869) >= (3625 - (27 + 292)))) then
					if (((14194 - 9350) > (2872 - 619)) and v24(v101.Stormkeeper)) then
						return "stormkeeper precombat 2";
					end
				end
				if (((1895 - 1443) == (890 - 438)) and v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (0 - 0)) and v42) then
					if (v24(v101.Icefury, not v16:IsSpellInRange(v101.Icefury)) or ((4696 - (43 + 96)) < (8513 - 6426))) then
						return "icefury precombat 4";
					end
				end
				v168 = 1 - 0;
			end
			if (((3215 + 659) == (1094 + 2780)) and (v168 == (5 - 2))) then
				if ((v13:IsCasting(v101.LavaBurst) and v40 and v101.FlameShock:IsReady()) or ((743 + 1195) > (9248 - 4313))) then
					if (v24(v101.FlameShock, not v16:IsSpellInRange(v101.FlameShock)) or ((1340 + 2915) < (252 + 3171))) then
						return "flameshock precombat 14";
					end
				end
				if (((3205 - (1414 + 337)) <= (4431 - (1642 + 298))) and v13:IsCasting(v101.LavaBurst) and v47 and ((v65 and v34) or not v65) and v127(v101.PrimordialWave)) then
					if (v24(v101.PrimordialWave, not v16:IsSpellInRange(v101.PrimordialWave)) or ((10836 - 6679) <= (8063 - 5260))) then
						return "primordial_wave precombat 16";
					end
				end
				break;
			end
		end
	end
	local function v138()
		if (((14401 - 9548) >= (982 + 2000)) and v101.FireElemental:IsReady() and v54 and ((v60 and v33) or not v60) and (v91 < v109)) then
			if (((3217 + 917) > (4329 - (357 + 615))) and v24(v101.FireElemental)) then
				return "fire_elemental aoe 2";
			end
		end
		if ((v101.StormElemental:IsReady() and v56 and ((v61 and v33) or not v61) and (v91 < v109)) or ((2399 + 1018) < (6217 - 3683))) then
			if (v24(v101.StormElemental) or ((2333 + 389) <= (351 - 187))) then
				return "storm_elemental aoe 4";
			end
		end
		if ((v127(v101.Stormkeeper) and not v130() and v48 and ((v66 and v34) or not v66) and (v91 < v109)) or ((1926 + 482) < (144 + 1965))) then
			if (v24(v101.Stormkeeper) or ((21 + 12) == (2756 - (384 + 917)))) then
				return "stormkeeper aoe 7";
			end
		end
		if ((v101.TotemicRecall:IsCastable() and (v101.LiquidMagmaTotem:CooldownRemains() > (742 - (128 + 569))) and v49) or ((1986 - (1407 + 136)) >= (5902 - (687 + 1200)))) then
			if (((5092 - (556 + 1154)) > (583 - 417)) and v24(v101.TotemicRecall)) then
				return "totemic_recall aoe 8";
			end
		end
		if ((v101.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v33) or not v62) and (v91 < v109) and (v67 == "cursor")) or ((375 - (9 + 86)) == (3480 - (275 + 146)))) then
			if (((306 + 1575) > (1357 - (29 + 35))) and v24(v103.LiquidMagmaTotemCursor, not v16:IsInRange(177 - 137))) then
				return "liquid_magma_totem aoe cursor 10";
			end
		end
		if (((7039 - 4682) == (10405 - 8048)) and v101.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v33) or not v62) and (v91 < v109) and (v67 == "player")) then
			if (((81 + 42) == (1135 - (53 + 959))) and v24(v103.LiquidMagmaTotemPlayer, not v16:IsInRange(448 - (312 + 96)))) then
				return "liquid_magma_totem aoe player 11";
			end
		end
		if ((v127(v101.PrimordialWave) and v13:BuffDown(v101.PrimordialWaveBuff) and v13:BuffUp(v101.SurgeofPowerBuff) and v13:BuffDown(v101.SplinteredElementsBuff)) or ((1832 - 776) >= (3677 - (147 + 138)))) then
			local v219 = 899 - (813 + 86);
			while true do
				if (((0 + 0) == v219) or ((2002 - 921) < (1567 - (18 + 474)))) then
					if (v105.CastTargetIf(v101.PrimordialWave, v113, "min", v123, nil, not v16:IsSpellInRange(v101.PrimordialWave), nil, nil) or ((354 + 695) >= (14465 - 10033))) then
						return "primordial_wave aoe 12";
					end
					if (v24(v101.PrimordialWave, not v16:IsSpellInRange(v101.PrimordialWave)) or ((5854 - (860 + 226)) <= (1149 - (121 + 182)))) then
						return "primordial_wave aoe 12";
					end
					break;
				end
			end
		end
		if ((v127(v101.PrimordialWave) and v13:BuffDown(v101.PrimordialWaveBuff) and v101.DeeplyRootedElements:IsAvailable() and not v101.SurgeofPower:IsAvailable() and v13:BuffDown(v101.SplinteredElementsBuff)) or ((414 + 2944) <= (2660 - (988 + 252)))) then
			local v220 = 0 + 0;
			while true do
				if ((v220 == (0 + 0)) or ((5709 - (49 + 1921)) <= (3895 - (223 + 667)))) then
					if (v105.CastTargetIf(v101.PrimordialWave, v113, "min", v123, nil, not v16:IsSpellInRange(v101.PrimordialWave), nil, nil) or ((1711 - (51 + 1)) >= (3672 - 1538))) then
						return "primordial_wave aoe 14";
					end
					if (v24(v101.PrimordialWave, not v16:IsSpellInRange(v101.PrimordialWave)) or ((6980 - 3720) < (3480 - (146 + 979)))) then
						return "primordial_wave aoe 14";
					end
					break;
				end
			end
		end
		if ((v127(v101.PrimordialWave) and v13:BuffDown(v101.PrimordialWaveBuff) and v101.MasteroftheElements:IsAvailable() and not v101.LightningRod:IsAvailable()) or ((189 + 480) == (4828 - (311 + 294)))) then
			local v221 = 0 - 0;
			while true do
				if ((v221 == (0 + 0)) or ((3135 - (496 + 947)) < (1946 - (1233 + 125)))) then
					if (v105.CastTargetIf(v101.PrimordialWave, v113, "min", v123, nil, not v16:IsSpellInRange(v101.PrimordialWave), nil, nil) or ((1947 + 2850) < (3276 + 375))) then
						return "primordial_wave aoe 16";
					end
					if (v24(v101.PrimordialWave, not v16:IsSpellInRange(v101.PrimordialWave)) or ((794 + 3383) > (6495 - (963 + 682)))) then
						return "primordial_wave aoe 16";
					end
					break;
				end
			end
		end
		if (v101.FlameShock:IsCastable() or ((334 + 66) > (2615 - (504 + 1000)))) then
			if (((2055 + 996) > (916 + 89)) and v13:BuffUp(v101.SurgeofPowerBuff) and v40 and v101.LightningRod:IsAvailable() and v101.WindspeakersLavaResurgence:IsAvailable() and (v16:DebuffRemains(v101.FlameShockDebuff) < (v16:TimeToDie() - (2 + 14))) and (v112 < (7 - 2))) then
				if (((3156 + 537) <= (2549 + 1833)) and v105.CastCycle(v101.FlameShock, v113, v121, not v16:IsSpellInRange(v101.FlameShock))) then
					return "flame_shock aoe 18";
				end
				if (v24(v101.FlameShock, not v16:IsSpellInRange(v101.FlameShock)) or ((3464 - (156 + 26)) > (2362 + 1738))) then
					return "flame_shock aoe 18";
				end
			end
			if ((v13:BuffUp(v101.SurgeofPowerBuff) and v40 and (not v101.LightningRod:IsAvailable() or v101.SkybreakersFieryDemise:IsAvailable()) and (v101.FlameShockDebuff:AuraActiveCount() < (8 - 2))) or ((3744 - (149 + 15)) < (3804 - (890 + 70)))) then
				local v252 = 117 - (39 + 78);
				while true do
					if (((571 - (14 + 468)) < (9873 - 5383)) and (v252 == (0 - 0))) then
						if (v105.CastCycle(v101.FlameShock, v113, v121, not v16:IsSpellInRange(v101.FlameShock)) or ((2571 + 2412) < (1086 + 722))) then
							return "flame_shock aoe 20";
						end
						if (((814 + 3015) > (1703 + 2066)) and v24(v101.FlameShock, not v16:IsSpellInRange(v101.FlameShock))) then
							return "flame_shock aoe 20";
						end
						break;
					end
				end
			end
			if (((390 + 1095) <= (5558 - 2654)) and v101.MasteroftheElements:IsAvailable() and v40 and not v101.LightningRod:IsAvailable() and not v101.SurgeofPower:IsAvailable() and (v101.FlameShockDebuff:AuraActiveCount() < (6 + 0))) then
				local v253 = 0 - 0;
				while true do
					if (((108 + 4161) == (4320 - (12 + 39))) and (v253 == (0 + 0))) then
						if (((1197 - 810) <= (9908 - 7126)) and v105.CastCycle(v101.FlameShock, v113, v121, not v16:IsSpellInRange(v101.FlameShock))) then
							return "flame_shock aoe 22";
						end
						if (v24(v101.FlameShock, not v16:IsSpellInRange(v101.FlameShock)) or ((563 + 1336) <= (483 + 434))) then
							return "flame_shock aoe 22";
						end
						break;
					end
				end
			end
			if ((v101.DeeplyRootedElements:IsAvailable() and v40 and not v101.SurgeofPower:IsAvailable() and (v101.FlameShockDebuff:AuraActiveCount() < (14 - 8))) or ((2873 + 1439) <= (4233 - 3357))) then
				local v254 = 1710 - (1596 + 114);
				while true do
					if (((5827 - 3595) <= (3309 - (164 + 549))) and (v254 == (1438 - (1059 + 379)))) then
						if (((2601 - 506) < (1911 + 1775)) and v105.CastCycle(v101.FlameShock, v113, v121, not v16:IsSpellInRange(v101.FlameShock))) then
							return "flame_shock aoe 24";
						end
						if (v24(v101.FlameShock, not v16:IsSpellInRange(v101.FlameShock)) or ((269 + 1326) >= (4866 - (145 + 247)))) then
							return "flame_shock aoe 24";
						end
						break;
					end
				end
			end
			if ((v13:BuffUp(v101.SurgeofPowerBuff) and v40 and (not v101.LightningRod:IsAvailable() or v101.SkybreakersFieryDemise:IsAvailable())) or ((3791 + 828) < (1332 + 1550))) then
				if (v105.CastCycle(v101.FlameShock, v113, v122, not v16:IsSpellInRange(v101.FlameShock)) or ((871 - 577) >= (927 + 3904))) then
					return "flame_shock aoe 26";
				end
				if (((1748 + 281) <= (5007 - 1923)) and v24(v101.FlameShock, not v16:IsSpellInRange(v101.FlameShock))) then
					return "flame_shock aoe 26";
				end
			end
			if ((v101.MasteroftheElements:IsAvailable() and v40 and not v101.LightningRod:IsAvailable() and not v101.SurgeofPower:IsAvailable()) or ((2757 - (254 + 466)) == (2980 - (544 + 16)))) then
				local v255 = 0 - 0;
				while true do
					if (((5086 - (294 + 334)) > (4157 - (236 + 17))) and ((0 + 0) == v255)) then
						if (((340 + 96) >= (462 - 339)) and v105.CastCycle(v101.FlameShock, v113, v122, not v16:IsSpellInRange(v101.FlameShock))) then
							return "flame_shock aoe 28";
						end
						if (((2367 - 1867) < (936 + 880)) and v24(v101.FlameShock, not v16:IsSpellInRange(v101.FlameShock))) then
							return "flame_shock aoe 28";
						end
						break;
					end
				end
			end
			if (((2944 + 630) == (4368 - (413 + 381))) and v101.DeeplyRootedElements:IsAvailable() and v40 and not v101.SurgeofPower:IsAvailable()) then
				local v256 = 0 + 0;
				while true do
					if (((469 - 248) < (1013 - 623)) and ((1970 - (582 + 1388)) == v256)) then
						if (v105.CastCycle(v101.FlameShock, v113, v122, not v16:IsSpellInRange(v101.FlameShock)) or ((3769 - 1556) <= (1018 + 403))) then
							return "flame_shock aoe 30";
						end
						if (((3422 - (326 + 38)) < (14376 - 9516)) and v24(v101.FlameShock, not v16:IsSpellInRange(v101.FlameShock))) then
							return "flame_shock aoe 30";
						end
						break;
					end
				end
			end
		end
		if ((v101.Ascendance:IsCastable() and v53 and ((v59 and v33) or not v59) and (v91 < v109)) or ((1849 - 553) >= (5066 - (47 + 573)))) then
			if (v24(v101.Ascendance) or ((492 + 901) > (19065 - 14576))) then
				return "ascendance aoe 32";
			end
		end
		if ((v127(v101.LavaBurst) and (v115 == (4 - 1)) and not v101.LightningRod:IsAvailable() and v13:HasTier(1695 - (1269 + 395), 496 - (76 + 416))) or ((4867 - (319 + 124)) < (61 - 34))) then
			local v222 = 1007 - (564 + 443);
			while true do
				if ((v222 == (0 - 0)) or ((2455 - (337 + 121)) > (11178 - 7363))) then
					if (((11542 - 8077) > (3824 - (1261 + 650))) and v105.CastCycle(v101.LavaBurst, v113, v123, not v16:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 34";
					end
					if (((311 + 422) < (2898 - 1079)) and v24(v101.LavaBurst, not v16:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 34";
					end
					break;
				end
			end
		end
		if ((v37 and v101.Earthquake:IsReady() and v128() and (((v13:BuffStack(v101.MagmaChamberBuff) > (1832 - (772 + 1045))) and (v115 >= ((1 + 6) - v25(v101.UnrelentingCalamity:IsAvailable())))) or (v101.SplinteredElements:IsAvailable() and (v115 >= ((154 - (102 + 42)) - v25(v101.UnrelentingCalamity:IsAvailable())))) or (v101.MountainsWillFall:IsAvailable() and (v115 >= (1853 - (1524 + 320))))) and not v101.LightningRod:IsAvailable() and v13:HasTier(1301 - (1049 + 221), 160 - (18 + 138))) or ((10757 - 6362) == (5857 - (67 + 1035)))) then
			local v223 = 348 - (136 + 212);
			while true do
				if ((v223 == (0 - 0)) or ((3039 + 754) < (2184 + 185))) then
					if ((v52 == "cursor") or ((5688 - (240 + 1364)) == (1347 - (1050 + 32)))) then
						if (((15560 - 11202) == (2578 + 1780)) and v24(v103.EarthquakeCursor, not v16:IsInRange(1095 - (331 + 724)))) then
							return "earthquake aoe 36";
						end
					end
					if ((v52 == "player") or ((254 + 2884) < (1637 - (269 + 375)))) then
						if (((4055 - (267 + 458)) > (723 + 1600)) and v24(v103.EarthquakePlayer, not v16:IsInRange(76 - 36))) then
							return "earthquake aoe 36";
						end
					end
					break;
				end
			end
		end
		if ((v127(v101.LavaBeam) and v43 and v130() and ((v13:BuffUp(v101.SurgeofPowerBuff) and (v115 >= (824 - (667 + 151)))) or (v128() and ((v115 < (1503 - (1410 + 87))) or not v101.SurgeofPower:IsAvailable()))) and not v101.LightningRod:IsAvailable() and v13:HasTier(1928 - (1504 + 393), 10 - 6)) or ((9407 - 5781) == (4785 - (461 + 335)))) then
			if (v24(v101.LavaBeam, not v16:IsSpellInRange(v101.LavaBeam)) or ((118 + 798) == (4432 - (1730 + 31)))) then
				return "lava_beam aoe 38";
			end
		end
		if (((1939 - (728 + 939)) == (963 - 691)) and v127(v101.ChainLightning) and v36 and v130() and ((v13:BuffUp(v101.SurgeofPowerBuff) and (v115 >= (11 - 5))) or (v128() and ((v115 < (13 - 7)) or not v101.SurgeofPower:IsAvailable()))) and not v101.LightningRod:IsAvailable() and v13:HasTier(1099 - (138 + 930), 4 + 0)) then
			if (((3322 + 927) <= (4148 + 691)) and v24(v101.ChainLightning, not v16:IsSpellInRange(v101.ChainLightning))) then
				return "chain_lightning aoe 40";
			end
		end
		if (((11339 - 8562) < (4966 - (459 + 1307))) and v127(v101.LavaBurst) and v13:BuffUp(v101.LavaSurgeBuff) and not v101.LightningRod:IsAvailable() and v13:HasTier(1901 - (474 + 1396), 6 - 2)) then
			local v224 = 0 + 0;
			while true do
				if (((1 + 94) < (5605 - 3648)) and (v224 == (0 + 0))) then
					if (((2757 - 1931) < (7488 - 5771)) and v105.CastCycle(v101.LavaBurst, v113, v123, not v16:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 42";
					end
					if (((2017 - (562 + 29)) >= (943 + 162)) and v24(v101.LavaBurst, not v16:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 42";
					end
					break;
				end
			end
		end
		if (((4173 - (374 + 1045)) <= (2675 + 704)) and v127(v101.LavaBurst) and v13:BuffUp(v101.LavaSurgeBuff) and v101.MasteroftheElements:IsAvailable() and not v128() and (v126() >= (((186 - 126) - ((643 - (448 + 190)) * v101.EyeoftheStorm:TalentRank())) - ((1 + 1) * v25(v101.FlowofPower:IsAvailable())))) and ((not v101.EchoesofGreatSundering:IsAvailable() and not v101.LightningRod:IsAvailable()) or v13:BuffUp(v101.EchoesofGreatSunderingBuff)) and ((not v13:BuffUp(v101.AscendanceBuff) and (v115 > (2 + 1)) and v101.UnrelentingCalamity:IsAvailable()) or ((v115 > (2 + 1)) and not v101.UnrelentingCalamity:IsAvailable()) or (v115 == (11 - 8)))) then
			local v225 = 0 - 0;
			while true do
				if ((v225 == (1494 - (1307 + 187))) or ((15572 - 11645) == (3308 - 1895))) then
					if (v105.CastCycle(v101.LavaBurst, v113, v123, not v16:IsSpellInRange(v101.LavaBurst)) or ((3538 - 2384) <= (1471 - (232 + 451)))) then
						return "lava_burst aoe 44";
					end
					if (v24(v101.LavaBurst, not v16:IsSpellInRange(v101.LavaBurst)) or ((1569 + 74) > (2985 + 394))) then
						return "lava_burst aoe 44";
					end
					break;
				end
			end
		end
		if ((v37 and v101.Earthquake:IsReady() and not v101.EchoesofGreatSundering:IsAvailable() and (v115 > (567 - (510 + 54))) and ((v115 > (5 - 2)) or (v114 > (39 - (13 + 23))))) or ((5463 - 2660) > (6535 - 1986))) then
			if ((v52 == "cursor") or ((399 - 179) >= (4110 - (830 + 258)))) then
				if (((9954 - 7132) == (1766 + 1056)) and v24(v103.EarthquakeCursor, not v16:IsInRange(35 + 5))) then
					return "earthquake aoe 46";
				end
			end
			if ((v52 == "player") or ((2502 - (860 + 581)) == (6849 - 4992))) then
				if (((2191 + 569) > (1605 - (237 + 4))) and v24(v103.EarthquakePlayer, not v16:IsInRange(94 - 54))) then
					return "earthquake aoe 46";
				end
			end
		end
		if ((v37 and v101.Earthquake:IsReady() and not v101.EchoesofGreatSundering:IsAvailable() and not v101.ElementalBlast:IsAvailable() and (v115 == (6 - 3)) and ((v115 == (5 - 2)) or (v114 == (3 + 0)))) or ((2816 + 2086) <= (13572 - 9977))) then
			local v226 = 0 + 0;
			while true do
				if ((v226 == (0 + 0)) or ((5278 - (85 + 1341)) == (499 - 206))) then
					if ((v52 == "cursor") or ((4402 - 2843) == (4960 - (45 + 327)))) then
						if (v24(v103.EarthquakeCursor, not v16:IsInRange(75 - 35)) or ((4986 - (444 + 58)) == (343 + 445))) then
							return "earthquake aoe 48";
						end
					end
					if (((786 + 3782) >= (1911 + 1996)) and (v52 == "player")) then
						if (((3610 - 2364) < (5202 - (64 + 1668))) and v24(v103.EarthquakePlayer, not v16:IsInRange(2013 - (1227 + 746)))) then
							return "earthquake aoe 48";
						end
					end
					break;
				end
			end
		end
		if (((12503 - 8435) >= (1803 - 831)) and v37 and v101.Earthquake:IsReady() and (v13:BuffUp(v101.EchoesofGreatSunderingBuff))) then
			local v227 = 494 - (415 + 79);
			while true do
				if (((13 + 480) < (4384 - (142 + 349))) and (v227 == (0 + 0))) then
					if ((v52 == "cursor") or ((2024 - 551) >= (1656 + 1676))) then
						if (v24(v103.EarthquakeCursor, not v16:IsInRange(29 + 11)) or ((11032 - 6981) <= (3021 - (1710 + 154)))) then
							return "earthquake aoe 50";
						end
					end
					if (((922 - (200 + 118)) < (1142 + 1739)) and (v52 == "player")) then
						if (v24(v103.EarthquakePlayer, not v16:IsInRange(69 - 29)) or ((1334 - 434) == (3001 + 376))) then
							return "earthquake aoe 50";
						end
					end
					break;
				end
			end
		end
		if (((4411 + 48) > (318 + 273)) and v127(v101.ElementalBlast) and v39 and v101.EchoesofGreatSundering:IsAvailable()) then
			local v228 = 0 + 0;
			while true do
				if (((7361 - 3963) >= (3645 - (363 + 887))) and (v228 == (0 - 0))) then
					if (v105.CastTargetIf(v101.ElementalBlast, v113, "min", v125, nil, not v16:IsSpellInRange(v101.ElementalBlast), nil, nil) or ((10390 - 8207) >= (436 + 2388))) then
						return "elemental_blast aoe 52";
					end
					if (((4529 - 2593) == (1323 + 613)) and v24(v101.ElementalBlast, not v16:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast aoe 52";
					end
					break;
				end
			end
		end
		if ((v127(v101.ElementalBlast) and v39 and v101.EchoesofGreatSundering:IsAvailable()) or ((6496 - (674 + 990)) < (1237 + 3076))) then
			if (((1674 + 2414) > (6140 - 2266)) and v24(v101.ElementalBlast, not v16:IsSpellInRange(v101.ElementalBlast))) then
				return "elemental_blast aoe 54";
			end
		end
		if (((5387 - (507 + 548)) == (5169 - (289 + 548))) and v127(v101.ElementalBlast) and v39 and (v115 == (1821 - (821 + 997))) and not v101.EchoesofGreatSundering:IsAvailable()) then
			if (((4254 - (195 + 60)) >= (780 + 2120)) and v24(v101.ElementalBlast, not v16:IsSpellInRange(v101.ElementalBlast))) then
				return "elemental_blast aoe 56";
			end
		end
		if ((v101.EarthShock:IsCastable() and v38 and v101.EchoesofGreatSundering:IsAvailable()) or ((4026 - (251 + 1250)) > (11905 - 7841))) then
			local v229 = 0 + 0;
			while true do
				if (((5403 - (809 + 223)) == (6378 - 2007)) and ((0 - 0) == v229)) then
					if (v105.CastTargetIf(v101.EarthShock, v113, "min", v125, nil, not v16:IsSpellInRange(v101.EarthShock), nil, nil) or ((879 - 613) > (3672 + 1314))) then
						return "earth_shock aoe 58";
					end
					if (((1043 + 948) >= (1542 - (14 + 603))) and v24(v101.EarthShock, not v16:IsSpellInRange(v101.EarthShock))) then
						return "earth_shock aoe 58";
					end
					break;
				end
			end
		end
		if (((584 - (118 + 11)) < (333 + 1720)) and v101.EarthShock:IsCastable() and v38 and v101.EchoesofGreatSundering:IsAvailable()) then
			if (v24(v101.EarthShock, not v16:IsSpellInRange(v101.EarthShock)) or ((688 + 138) == (14137 - 9286))) then
				return "earth_shock aoe 60";
			end
		end
		if (((1132 - (551 + 398)) == (116 + 67)) and v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (0 + 0)) and v42 and not v13:BuffUp(v101.AscendanceBuff) and v101.ElectrifiedShocks:IsAvailable() and ((v101.LightningRod:IsAvailable() and (v115 < (5 + 0)) and not v128()) or (v101.DeeplyRootedElements:IsAvailable() and (v115 == (11 - 8))))) then
			if (((2670 - 1511) <= (580 + 1208)) and v24(v101.Icefury, not v16:IsSpellInRange(v101.Icefury))) then
				return "icefury aoe 62";
			end
		end
		if ((v101.FrostShock:IsCastable() and v41 and not v13:BuffUp(v101.AscendanceBuff) and v13:BuffUp(v101.IcefuryBuff) and v101.ElectrifiedShocks:IsAvailable() and (not v16:DebuffUp(v101.ElectrifiedShocksDebuff) or (v13:BuffRemains(v101.IcefuryBuff) < v13:GCD())) and ((v101.LightningRod:IsAvailable() and (v115 < (19 - 14)) and not v128()) or (v101.DeeplyRootedElements:IsAvailable() and (v115 == (1 + 2))))) or ((3596 - (40 + 49)) > (16443 - 12125))) then
			if (v24(v101.FrostShock, not v16:IsSpellInRange(v101.FrostShock)) or ((3565 - (99 + 391)) <= (2453 + 512))) then
				return "frost_shock aoe 64";
			end
		end
		if (((6000 - 4635) <= (4979 - 2968)) and v127(v101.LavaBurst) and v101.MasteroftheElements:IsAvailable() and not v128() and (v130() or ((v119() < (3 + 0)) and v13:HasTier(78 - 48, 1606 - (1032 + 572)))) and (v126() < ((((477 - (203 + 214)) - ((1822 - (568 + 1249)) * v101.EyeoftheStorm:TalentRank())) - ((2 + 0) * v25(v101.FlowofPower:IsAvailable()))) - (24 - 14))) and (v115 < (19 - 14))) then
			if (v105.CastCycle(v101.LavaBurst, v113, v123, not v16:IsSpellInRange(v101.LavaBurst)) or ((4082 - (913 + 393)) > (10095 - 6520))) then
				return "lava_burst aoe 66";
			end
			if (v24(v101.LavaBurst, not v16:IsSpellInRange(v101.LavaBurst)) or ((3608 - 1054) == (5214 - (269 + 141)))) then
				return "lava_burst aoe 66";
			end
		end
		if (((5731 - 3154) == (4558 - (362 + 1619))) and v127(v101.LavaBeam) and v43 and (v130())) then
			if (v24(v101.LavaBeam, not v16:IsSpellInRange(v101.LavaBeam)) or ((1631 - (950 + 675)) >= (729 + 1160))) then
				return "lava_beam aoe 68";
			end
		end
		if (((1685 - (216 + 963)) <= (3179 - (485 + 802))) and v127(v101.ChainLightning) and v36 and (v130())) then
			if (v24(v101.ChainLightning, not v16:IsSpellInRange(v101.ChainLightning)) or ((2567 - (432 + 127)) > (3291 - (1065 + 8)))) then
				return "chain_lightning aoe 70";
			end
		end
		if (((211 + 168) <= (5748 - (635 + 966))) and v127(v101.LavaBeam) and v43 and v129() and (v13:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) then
			if (v24(v101.LavaBeam, not v16:IsSpellInRange(v101.LavaBeam)) or ((3246 + 1268) <= (1051 - (5 + 37)))) then
				return "lava_beam aoe 72";
			end
		end
		if ((v127(v101.ChainLightning) and v36 and v129()) or ((8694 - 5198) == (496 + 696))) then
			if (v24(v101.ChainLightning, not v16:IsSpellInRange(v101.ChainLightning)) or ((329 - 121) == (1385 + 1574))) then
				return "chain_lightning aoe 74";
			end
		end
		if (((8887 - 4610) >= (4977 - 3664)) and v127(v101.LavaBeam) and v43 and (v115 >= (10 - 4)) and v13:BuffUp(v101.SurgeofPowerBuff) and (v13:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) then
			if (((6184 - 3597) < (2283 + 891)) and v24(v101.LavaBeam, not v16:IsSpellInRange(v101.LavaBeam))) then
				return "lava_beam aoe 76";
			end
		end
		if ((v127(v101.ChainLightning) and v36 and (v115 >= (535 - (318 + 211))) and v13:BuffUp(v101.SurgeofPowerBuff)) or ((20272 - 16152) <= (3785 - (963 + 624)))) then
			if (v24(v101.ChainLightning, not v16:IsSpellInRange(v101.ChainLightning)) or ((683 + 913) == (1704 - (518 + 328)))) then
				return "chain_lightning aoe 78";
			end
		end
		if (((7506 - 4286) == (5146 - 1926)) and v127(v101.LavaBurst) and v13:BuffUp(v101.LavaSurgeBuff) and v101.DeeplyRootedElements:IsAvailable() and v13:BuffUp(v101.WindspeakersLavaResurgenceBuff)) then
			local v230 = 317 - (301 + 16);
			while true do
				if (((0 - 0) == v230) or ((3937 - 2535) > (9446 - 5826))) then
					if (((2332 + 242) == (1462 + 1112)) and v105.CastCycle(v101.LavaBurst, v113, v123, not v16:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 80";
					end
					if (((3838 - 2040) < (1659 + 1098)) and v24(v101.LavaBurst, not v16:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 80";
					end
					break;
				end
			end
		end
		if ((v127(v101.LavaBeam) and v43 and v128() and (v13:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) or ((36 + 341) > (8278 - 5674))) then
			if (((184 + 384) < (1930 - (829 + 190))) and v24(v101.LavaBeam, not v16:IsSpellInRange(v101.LavaBeam))) then
				return "lava_beam aoe 82";
			end
		end
		if (((11720 - 8435) < (5349 - 1121)) and v127(v101.LavaBurst) and (v115 == (3 - 0)) and v101.MasteroftheElements:IsAvailable()) then
			local v231 = 0 - 0;
			while true do
				if (((929 + 2987) > (1088 + 2240)) and (v231 == (0 - 0))) then
					if (((2359 + 141) < (4452 - (520 + 93))) and v105.CastCycle(v101.LavaBurst, v113, v123, not v16:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 84";
					end
					if (((783 - (259 + 17)) == (30 + 477)) and v24(v101.LavaBurst, not v16:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 84";
					end
					break;
				end
			end
		end
		if (((87 + 153) <= (10715 - 7550)) and v127(v101.LavaBurst) and v13:BuffUp(v101.LavaSurgeBuff) and v101.DeeplyRootedElements:IsAvailable()) then
			local v232 = 591 - (396 + 195);
			while true do
				if (((2419 - 1585) >= (2566 - (440 + 1321))) and (v232 == (1829 - (1059 + 770)))) then
					if (v105.CastCycle(v101.LavaBurst, v113, v123, not v16:IsSpellInRange(v101.LavaBurst)) or ((17627 - 13815) < (2861 - (424 + 121)))) then
						return "lava_burst aoe 86";
					end
					if (v24(v101.LavaBurst, not v16:IsSpellInRange(v101.LavaBurst)) or ((484 + 2168) <= (2880 - (641 + 706)))) then
						return "lava_burst aoe 86";
					end
					break;
				end
			end
		end
		if ((v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (0 + 0)) and v42 and v101.ElectrifiedShocks:IsAvailable() and (v115 < (445 - (249 + 191)))) or ((15674 - 12076) < (653 + 807))) then
			if (v24(v101.Icefury, not v16:IsSpellInRange(v101.Icefury)) or ((15863 - 11747) < (1619 - (183 + 244)))) then
				return "icefury aoe 88";
			end
		end
		if ((v127(v101.FrostShock) and v41 and v13:BuffUp(v101.IcefuryBuff) and v101.ElectrifiedShocks:IsAvailable() and not v16:DebuffUp(v101.ElectrifiedShocksDebuff) and (v115 < (1 + 4)) and v101.UnrelentingCalamity:IsAvailable()) or ((4107 - (434 + 296)) <= (2881 - 1978))) then
			if (((4488 - (169 + 343)) >= (385 + 54)) and v24(v101.FrostShock, not v16:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock aoe 90";
			end
		end
		if (((6601 - 2849) == (11012 - 7260)) and v127(v101.LavaBeam) and v43 and (v13:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) then
			if (((3315 + 731) > (7643 - 4948)) and v24(v101.LavaBeam, not v16:IsSpellInRange(v101.LavaBeam))) then
				return "lava_beam aoe 92";
			end
		end
		if ((v127(v101.ChainLightning) and v36) or ((4668 - (651 + 472)) == (2417 + 780))) then
			if (((1033 + 1361) > (454 - 81)) and v24(v101.ChainLightning, not v16:IsSpellInRange(v101.ChainLightning))) then
				return "chain_lightning aoe 94";
			end
		end
		if (((4638 - (397 + 86)) <= (5108 - (423 + 453))) and v101.FlameShock:IsCastable() and v40 and v13:IsMoving() and v16:DebuffRefreshable(v101.FlameShockDebuff)) then
			if (v24(v101.FlameShock, not v16:IsSpellInRange(v101.FlameShock)) or ((365 + 3216) == (458 + 3015))) then
				return "flame_shock aoe 96";
			end
		end
		if (((4361 + 634) > (2672 + 676)) and v101.FrostShock:IsCastable() and v41 and v13:IsMoving()) then
			if (v24(v101.FrostShock, not v16:IsSpellInRange(v101.FrostShock)) or ((674 + 80) > (4914 - (50 + 1140)))) then
				return "frost_shock aoe 98";
			end
		end
	end
	local function v139()
		local v169 = 0 + 0;
		while true do
			if (((129 + 88) >= (4 + 53)) and (v169 == (12 - 3))) then
				if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v45) or ((1498 + 572) >= (4633 - (157 + 439)))) then
					if (((4703 - 1998) == (8988 - 6283)) and v24(v101.LightningBolt, not v16:IsSpellInRange(v101.LightningBolt))) then
						return "lightning_bolt single_target 110";
					end
				end
				if (((180 - 119) == (979 - (782 + 136))) and v101.FlameShock:IsCastable() and v40 and (v13:IsMoving())) then
					local v257 = 855 - (112 + 743);
					while true do
						if ((v257 == (1171 - (1026 + 145))) or ((120 + 579) >= (2014 - (493 + 225)))) then
							if (v105.CastCycle(v101.FlameShock, v113, v120, not v16:IsSpellInRange(v101.FlameShock)) or ((6553 - 4770) >= (2200 + 1416))) then
								return "flame_shock single_target 112";
							end
							if (v24(v101.FlameShock, not v16:IsSpellInRange(v101.FlameShock)) or ((10491 - 6578) > (87 + 4440))) then
								return "flame_shock single_target 112";
							end
							break;
						end
					end
				end
				if (((12505 - 8129) > (238 + 579)) and v101.FlameShock:IsCastable() and v40) then
					if (((8121 - 3260) > (2419 - (210 + 1385))) and v24(v101.FlameShock, not v16:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock single_target 114";
					end
				end
				if ((v101.FrostShock:IsCastable() and v41) or ((3072 - (1201 + 488)) >= (1321 + 810))) then
					if (v24(v101.FrostShock, not v16:IsSpellInRange(v101.FrostShock)) or ((3336 - 1460) >= (4556 - 2015))) then
						return "frost_shock single_target 116";
					end
				end
				break;
			end
			if (((2367 - (352 + 233)) <= (9115 - 5343)) and (v169 == (3 + 1))) then
				if ((v101.FrostShock:IsCastable() and v41 and v131() and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.ElementalBlast:IsAvailable() and (((v126() >= (102 - 66)) and (v126() < (624 - (489 + 85))) and (v101.LavaBurst:CooldownRemains() > v13:GCD())) or ((v126() >= (1525 - (277 + 1224))) and (v126() < (1531 - (663 + 830))) and v101.LavaBurst:CooldownUp()))) or ((4129 + 571) < (1990 - 1177))) then
					if (((4074 - (461 + 414)) < (679 + 3371)) and v24(v101.FrostShock, not v16:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single_target 50";
					end
				end
				if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v44 and v13:BuffUp(v101.WindspeakersLavaResurgenceBuff) and (v101.EchooftheElements:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.PrimordialSurge:IsAvailable() or ((v126() >= (26 + 37)) and v101.MasteroftheElements:IsAvailable()) or ((v126() >= (4 + 34)) and v13:BuffUp(v101.EchoesofGreatSunderingBuff) and (v114 > (1 + 0)) and (v115 > (251 - (172 + 78)))) or not v101.ElementalBlast:IsAvailable())) or ((7982 - 3031) < (1631 + 2799))) then
					if (((138 - 42) == (27 + 69)) and v24(v101.LavaBurst, not v16:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst single_target 52";
					end
				end
				if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v44 and v13:BuffUp(v101.LavaSurgeBuff) and (v101.EchooftheElements:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.PrimordialSurge:IsAvailable() or not v101.MasteroftheElements:IsAvailable() or not v101.ElementalBlast:IsAvailable())) or ((915 + 1824) > (6714 - 2706))) then
					if (v24(v101.LavaBurst, not v16:IsSpellInRange(v101.LavaBurst)) or ((28 - 5) == (286 + 848))) then
						return "lava_burst single_target 54";
					end
				end
				if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v44 and v13:BuffUp(v101.AscendanceBuff) and (v13:HasTier(18 + 13, 2 + 2) or not v101.ElementalBlast:IsAvailable())) or ((10719 - 8026) >= (9577 - 5466))) then
					local v258 = 0 + 0;
					while true do
						if ((v258 == (0 + 0)) or ((4763 - (133 + 314)) <= (374 + 1772))) then
							if (v105.CastCycle(v101.LavaBurst, v113, v124, not v16:IsSpellInRange(v101.LavaBurst)) or ((3759 - (199 + 14)) <= (10055 - 7246))) then
								return "lava_burst single_target 56";
							end
							if (((6453 - (647 + 902)) > (6512 - 4346)) and v24(v101.LavaBurst, not v16:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst single_target 56";
							end
							break;
						end
					end
				end
				if (((342 - (85 + 148)) >= (1379 - (426 + 863))) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v44 and v13:BuffDown(v101.AscendanceBuff) and (not v101.ElementalBlast:IsAvailable() or not v101.MountainsWillFall:IsAvailable()) and not v101.LightningRod:IsAvailable() and v13:HasTier(145 - 114, 1658 - (873 + 781))) then
					if (((6665 - 1687) > (7845 - 4940)) and v105.CastCycle(v101.LavaBurst, v113, v124, not v16:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst single_target 58";
					end
					if (v24(v101.LavaBurst, not v16:IsSpellInRange(v101.LavaBurst)) or ((1254 + 1772) <= (8422 - 6142))) then
						return "lava_burst single_target 58";
					end
				end
				if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v44 and v101.MasteroftheElements:IsAvailable() and not v128() and not v101.LightningRod:IsAvailable()) or ((2368 - 715) <= (3289 - 2181))) then
					local v259 = 1947 - (414 + 1533);
					while true do
						if (((2523 + 386) > (3164 - (443 + 112))) and (v259 == (1479 - (888 + 591)))) then
							if (((1955 - 1198) > (12 + 182)) and v105.CastCycle(v101.LavaBurst, v113, v124, not v16:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst single_target 60";
							end
							if (v24(v101.LavaBurst, not v16:IsSpellInRange(v101.LavaBurst)) or ((116 - 85) >= (546 + 852))) then
								return "lava_burst single_target 60";
							end
							break;
						end
					end
				end
				v169 = 3 + 2;
			end
			if (((342 + 2854) <= (9283 - 4411)) and (v169 == (3 - 1))) then
				if (((5004 - (136 + 1542)) == (10906 - 7580)) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v45 and v130() and v13:BuffUp(v101.SurgeofPowerBuff)) then
					if (((1423 + 10) <= (6166 - 2288)) and v24(v101.LightningBolt, not v16:IsSpellInRange(v101.LightningBolt))) then
						return "lightning_bolt single_target 26";
					end
				end
				if ((v101.LavaBeam:IsCastable() and v43 and (v114 > (1 + 0)) and (v115 > (487 - (68 + 418))) and v130() and not v101.SurgeofPower:IsAvailable()) or ((4291 - 2708) == (3147 - 1412))) then
					if (v24(v101.LavaBeam, not v16:IsSpellInRange(v101.LavaBeam)) or ((2574 + 407) == (3442 - (770 + 322)))) then
						return "lava_beam single_target 28";
					end
				end
				if ((v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v36 and (v114 > (1 + 0)) and (v115 > (1 + 0)) and v130() and not v101.SurgeofPower:IsAvailable()) or ((610 + 3856) <= (704 - 211))) then
					if (v24(v101.ChainLightning, not v16:IsSpellInRange(v101.ChainLightning)) or ((4938 - 2391) <= (5411 - 3424))) then
						return "chain_lightning single_target 30";
					end
				end
				if (((10891 - 7930) > (1527 + 1213)) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v44 and v130() and not v128() and not v101.SurgeofPower:IsAvailable() and v101.MasteroftheElements:IsAvailable()) then
					if (((5537 - 1841) >= (1733 + 1879)) and v24(v101.LavaBurst, not v16:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst single_target 32";
					end
				end
				if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v45 and v130() and not v101.SurgeofPower:IsAvailable() and v128()) or ((1821 + 1149) == (1472 + 406))) then
					if (v24(v101.LightningBolt, not v16:IsSpellInRange(v101.LightningBolt)) or ((13906 - 10213) < (2745 - 768))) then
						return "lightning_bolt single_target 34";
					end
				end
				if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v45 and v130() and not v101.SurgeofPower:IsAvailable() and not v101.MasteroftheElements:IsAvailable()) or ((315 + 615) > (9678 - 7577))) then
					if (((13728 - 9575) > (1270 + 1816)) and v24(v101.LightningBolt, not v16:IsSpellInRange(v101.LightningBolt))) then
						return "lightning_bolt single_target 36";
					end
				end
				v169 = 14 - 11;
			end
			if ((v169 == (837 - (762 + 69))) or ((15070 - 10416) <= (3490 + 560))) then
				if ((v101.EarthShock:IsCastable() and v38) or ((1685 + 917) < (3618 - 2122))) then
					if (v24(v101.EarthShock, not v16:IsSpellInRange(v101.EarthShock)) or ((321 + 699) > (37 + 2251))) then
						return "earth_shock single_target 74";
					end
				end
				if (((1277 - 949) == (485 - (8 + 149))) and v127(v101.FrostShock) and v41 and v131() and v101.ElectrifiedShocks:IsAvailable() and v128() and not v101.LightningRod:IsAvailable() and (v114 > (1321 - (1199 + 121))) and (v115 > (1 - 0))) then
					if (((3411 - 1900) < (1568 + 2240)) and v24(v101.FrostShock, not v16:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single_target 76";
					end
				end
				if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v44 and (v101.DeeplyRootedElements:IsAvailable())) or ((8959 - 6449) > (11413 - 6494))) then
					local v260 = 0 + 0;
					while true do
						if (((6570 - (518 + 1289)) == (8167 - 3404)) and (v260 == (0 + 0))) then
							if (((6042 - 1905) > (1362 + 486)) and v105.CastCycle(v101.LavaBurst, v113, v124, not v16:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst single_target 78";
							end
							if (((2905 - (304 + 165)) <= (2959 + 175)) and v24(v101.LavaBurst, not v16:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst single_target 78";
							end
							break;
						end
					end
				end
				if (((3883 - (54 + 106)) == (5692 - (1618 + 351))) and v101.FrostShock:IsCastable() and v41 and v131() and v101.FluxMelting:IsAvailable() and v13:BuffDown(v101.FluxMeltingBuff)) then
					if (v24(v101.FrostShock, not v16:IsSpellInRange(v101.FrostShock)) or ((2854 + 1192) >= (5332 - (10 + 1006)))) then
						return "frost_shock single_target 80";
					end
				end
				if ((v101.FrostShock:IsCastable() and v41 and v131() and ((v101.ElectrifiedShocks:IsAvailable() and (v16:DebuffRemains(v101.ElectrifiedShocksDebuff) < (1 + 1))) or (v13:BuffRemains(v101.IcefuryBuff) < (1 + 5)))) or ((6509 - 4501) < (2962 - (912 + 121)))) then
					if (((1127 + 1257) > (3064 - (1140 + 149))) and v24(v101.FrostShock, not v16:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single_target 82";
					end
				end
				if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v44 and (v101.EchooftheElements:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.PrimordialSurge:IsAvailable() or not v101.ElementalBlast:IsAvailable() or not v101.MasteroftheElements:IsAvailable() or v130())) or ((2908 + 1635) <= (5832 - 1456))) then
					local v261 = 0 + 0;
					while true do
						if (((2491 - 1763) == (1365 - 637)) and ((0 + 0) == v261)) then
							if (v105.CastCycle(v101.LavaBurst, v113, v124, not v16:IsSpellInRange(v101.LavaBurst)) or ((3733 - 2657) > (4857 - (165 + 21)))) then
								return "lava_burst single_target 84";
							end
							if (((1962 - (61 + 50)) >= (156 + 222)) and v24(v101.LavaBurst, not v16:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst single_target 84";
							end
							break;
						end
					end
				end
				v169 = 33 - 26;
			end
			if ((v169 == (9 - 4)) or ((766 + 1182) >= (4936 - (1295 + 165)))) then
				if (((1094 + 3700) >= (335 + 498)) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v44 and v101.MasteroftheElements:IsAvailable() and not v128() and ((v126() >= (1472 - (819 + 578))) or ((v126() >= (1452 - (331 + 1071))) and not v101.ElementalBlast:IsAvailable())) and v101.SwellingMaelstrom:IsAvailable() and (v126() <= (873 - (588 + 155)))) then
					if (((5372 - (546 + 736)) == (6027 - (1834 + 103))) and v24(v101.LavaBurst, not v16:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst single_target 62";
					end
				end
				if ((v101.Earthquake:IsReady() and v37 and v13:BuffUp(v101.EchoesofGreatSunderingBuff) and ((not v101.ElementalBlast:IsAvailable() and (v114 < (2 + 0))) or (v114 > (2 - 1)))) or ((5524 - (1536 + 230)) == (2989 - (128 + 363)))) then
					local v262 = 0 + 0;
					while true do
						if ((v262 == (0 - 0)) or ((691 + 1982) < (2608 - 1033))) then
							if ((v52 == "cursor") or ((10954 - 7233) <= (3534 - 2079))) then
								if (((641 + 293) < (3279 - (615 + 394))) and v24(v103.EarthquakeCursor, not v16:IsInRange(37 + 3))) then
									return "earthquake single_target 64";
								end
							end
							if ((v52 == "player") or ((1537 + 75) == (3825 - 2570))) then
								if (v24(v103.EarthquakePlayer, not v16:IsInRange(181 - 141)) or ((5003 - (59 + 592)) < (9311 - 5105))) then
									return "earthquake single_target 64";
								end
							end
							break;
						end
					end
				end
				if ((v101.Earthquake:IsReady() and v37 and (v114 > (1 - 0)) and (v115 > (1 + 0)) and not v101.EchoesofGreatSundering:IsAvailable() and not v101.ElementalBlast:IsAvailable()) or ((3031 - (70 + 101)) <= (447 - 266))) then
					local v263 = 0 + 0;
					while true do
						if (((8092 - 4870) >= (1768 - (123 + 118))) and (v263 == (0 + 0))) then
							if (((19 + 1486) <= (3520 - (653 + 746))) and (v52 == "cursor")) then
								if (((1391 - 647) == (1071 - 327)) and v24(v103.EarthquakeCursor, not v16:IsInRange(107 - 67))) then
									return "earthquake single_target 66";
								end
							end
							if ((v52 == "player") or ((874 + 1105) >= (1815 + 1021))) then
								if (((1601 + 232) <= (327 + 2341)) and v24(v103.EarthquakePlayer, not v16:IsInRange(7 + 33))) then
									return "earthquake single_target 66";
								end
							end
							break;
						end
					end
				end
				if (((9036 - 5350) == (3509 + 177)) and v127(v101.ElementalBlast) and v101.ElementalBlast:IsCastable() and v39 and (not v101.MasteroftheElements:IsAvailable() or (v128() and v16:DebuffUp(v101.ElectrifiedShocksDebuff)))) then
					if (((6405 - 2938) > (1711 - (885 + 349))) and v24(v101.ElementalBlast, not v16:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast single_target 68";
					end
				end
				if ((v127(v101.FrostShock) and v41 and v131() and v128() and (v126() < (88 + 22)) and (v101.LavaBurst:ChargesFractional() < (2 - 1)) and v101.ElectrifiedShocks:IsAvailable() and v101.ElementalBlast:IsAvailable() and not v101.LightningRod:IsAvailable()) or ((9564 - 6276) >= (4509 - (915 + 53)))) then
					if (v24(v101.FrostShock, not v16:IsSpellInRange(v101.FrostShock)) or ((4358 - (768 + 33)) == (17383 - 12843))) then
						return "frost_shock single_target 70";
					end
				end
				if ((v127(v101.ElementalBlast) and v101.ElementalBlast:IsCastable() and v39 and (v128() or v101.LightningRod:IsAvailable())) or ((459 - 198) > (1595 - (287 + 41)))) then
					if (((2119 - (638 + 209)) < (2005 + 1853)) and v24(v101.ElementalBlast, not v16:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast single_target 72";
					end
				end
				v169 = 1692 - (96 + 1590);
			end
			if (((5336 - (741 + 931)) == (1800 + 1864)) and (v169 == (0 - 0))) then
				if (((9068 - 7127) >= (194 + 256)) and v101.FireElemental:IsCastable() and v54 and ((v60 and v33) or not v60) and (v91 < v109)) then
					if (v24(v101.FireElemental) or ((1997 + 2649) < (104 + 220))) then
						return "fire_elemental single_target 2";
					end
				end
				if (((14545 - 10712) == (1246 + 2587)) and v101.StormElemental:IsCastable() and v56 and ((v61 and v33) or not v61) and (v91 < v109)) then
					if (v24(v101.StormElemental) or ((606 + 634) > (13746 - 10376))) then
						return "storm_elemental single_target 4";
					end
				end
				if ((v101.TotemicRecall:IsCastable() and v49 and (v101.LiquidMagmaTotem:CooldownRemains() > (41 + 4)) and ((v101.LavaSurge:IsAvailable() and v101.SplinteredElements:IsAvailable()) or ((v114 > (495 - (64 + 430))) and (v115 > (1 + 0))))) or ((2844 - (106 + 257)) == (3320 + 1362))) then
					if (((5448 - (496 + 225)) >= (425 - 217)) and v24(v101.TotemicRecall)) then
						return "totemic_recall single_target 6";
					end
				end
				if (((1363 - 1083) < (5509 - (256 + 1402))) and v101.LiquidMagmaTotem:IsCastable() and v55 and ((v62 and v33) or not v62) and (v91 < v109) and ((v101.LavaSurge:IsAvailable() and v101.SplinteredElements:IsAvailable()) or (v101.FlameShockDebuff:AuraActiveCount() == (1899 - (30 + 1869))) or (v16:DebuffRemains(v101.FlameShockDebuff) < (1375 - (213 + 1156))) or ((v114 > (189 - (96 + 92))) and (v115 > (1 + 0))))) then
					local v264 = 899 - (142 + 757);
					while true do
						if ((v264 == (0 + 0)) or ((1229 + 1778) > (3273 - (32 + 47)))) then
							if ((v67 == "cursor") or ((4113 - (1053 + 924)) >= (2886 + 60))) then
								if (((3728 - 1563) <= (4169 - (685 + 963))) and v24(v103.LiquidMagmaTotemCursor, not v16:IsInRange(81 - 41))) then
									return "liquid_magma_totem single_target cursor 8";
								end
							end
							if (((4461 - 1600) > (2370 - (541 + 1168))) and (v67 == "player")) then
								if (((6122 - (645 + 952)) > (5357 - (669 + 169))) and v24(v103.LiquidMagmaTotemPlayer, not v16:IsInRange(138 - 98))) then
									return "liquid_magma_totem single_target player 8";
								end
							end
							break;
						end
					end
				end
				if (((6901 - 3723) > (329 + 643)) and v127(v101.PrimordialWave) and v101.PrimordialWave:IsCastable() and v47 and ((v65 and v34) or not v65) and not v13:BuffUp(v101.PrimordialWaveBuff) and not v13:BuffUp(v101.SplinteredElementsBuff)) then
					local v265 = 0 + 0;
					while true do
						if (((5531 - (181 + 584)) == (6161 - (665 + 730))) and (v265 == (0 - 0))) then
							if (v105.CastCycle(v101.PrimordialWave, v113, v123, not v16:IsSpellInRange(v101.PrimordialWave)) or ((5598 - 2853) > (4478 - (540 + 810)))) then
								return "primordial_wave single_target 10";
							end
							if (v24(v101.PrimordialWave, not v16:IsSpellInRange(v101.PrimordialWave)) or ((4573 - 3429) >= (12663 - 8057))) then
								return "primordial_wave single_target 10";
							end
							break;
						end
					end
				end
				if (((2657 + 681) >= (480 - (166 + 37))) and v101.FlameShock:IsCastable() and v40 and (v114 == (1882 - (22 + 1859))) and v16:DebuffRefreshable(v101.FlameShockDebuff) and ((v16:DebuffRemains(v101.FlameShockDebuff) < v101.PrimordialWave:CooldownRemains()) or not v101.PrimordialWave:IsAvailable()) and v13:BuffDown(v101.SurgeofPowerBuff) and (not v128() or (not v130() and ((v101.ElementalBlast:IsAvailable() and (v126() < ((1862 - (843 + 929)) - ((270 - (30 + 232)) * v101.EyeoftheStorm:TalentRank())))) or (v126() < ((171 - 111) - ((782 - (55 + 722)) * v101.EyeoftheStorm:TalentRank()))))))) then
					if (((5602 - 2992) > (4235 - (78 + 1597))) and v24(v101.FlameShock, not v16:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock single_target 12";
					end
				end
				v169 = 1 + 0;
			end
			if (((3 + 0) == v169) or ((1000 + 194) > (3632 - (305 + 244)))) then
				if (((850 + 66) >= (852 - (95 + 10))) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v45 and v13:BuffUp(v101.SurgeofPowerBuff) and v101.LightningRod:IsAvailable()) then
					if (v24(v101.LightningBolt, not v16:IsSpellInRange(v101.LightningBolt)) or ((1731 + 713) > (9361 - 6407))) then
						return "lightning_bolt single_target 38";
					end
				end
				if (((3956 - 1064) < (4276 - (592 + 170))) and v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (0 - 0)) and v42 and v101.ElectrifiedShocks:IsAvailable() and v101.LightningRod:IsAvailable() and v101.LightningRod:IsAvailable()) then
					if (((1338 - 805) == (249 + 284)) and v24(v101.Icefury, not v16:IsSpellInRange(v101.Icefury))) then
						return "icefury single_target 40";
					end
				end
				if (((232 + 363) <= (8241 - 4828)) and v101.FrostShock:IsCastable() and v41 and v131() and v101.ElectrifiedShocks:IsAvailable() and ((v16:DebuffRemains(v101.ElectrifiedShocksDebuff) < (1 + 1)) or (v13:BuffRemains(v101.IcefuryBuff) <= v13:GCD())) and v101.LightningRod:IsAvailable()) then
					if (((5704 - 2626) >= (3098 - (353 + 154))) and v24(v101.FrostShock, not v16:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single_target 42";
					end
				end
				if (((4257 - 1058) < (5505 - 1475)) and v101.FrostShock:IsCastable() and v41 and v131() and v101.ElectrifiedShocks:IsAvailable() and (v126() >= (35 + 15)) and (v16:DebuffRemains(v101.ElectrifiedShocksDebuff) < ((2 + 0) * v13:GCD())) and v130() and v101.LightningRod:IsAvailable()) then
					if (((513 + 264) < (3002 - 924)) and v24(v101.FrostShock, not v16:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single_target 44";
					end
				end
				if (((3210 - 1514) <= (5319 - 3037)) and v101.LavaBeam:IsCastable() and v43 and (v114 > (87 - (7 + 79))) and (v115 > (1 + 0)) and v129() and (v13:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime()) and not v13:HasTier(212 - (24 + 157), 7 - 3)) then
					if (v24(v101.LavaBeam, not v16:IsSpellInRange(v101.LavaBeam)) or ((3756 - 1995) >= (700 + 1762))) then
						return "lava_beam single_target 46";
					end
				end
				if (((12259 - 7708) > (2708 - (262 + 118))) and v101.FrostShock:IsCastable() and v41 and v131() and v130() and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.PrimordialSurge:IsAvailable() and v101.ElementalBlast:IsAvailable() and (((v126() >= (1144 - (1038 + 45))) and (v126() < (161 - 86)) and (v101.LavaBurst:CooldownRemains() > v13:GCD())) or ((v126() >= (279 - (19 + 211))) and (v126() < (176 - (88 + 25))) and (v101.LavaBurst:CooldownRemains() > (0 - 0))))) then
					if (((1899 + 1926) >= (436 + 31)) and v24(v101.FrostShock, not v16:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single_target 48";
					end
				end
				v169 = 1040 - (1007 + 29);
			end
			if ((v169 == (1 + 0)) or ((7064 - 4174) == (2634 - 2077))) then
				if ((v101.FlameShock:IsCastable() and v40 and (v101.FlameShockDebuff:AuraActiveCount() == (0 + 0)) and (v114 > (812 - (340 + 471))) and (v115 > (2 - 1)) and (v101.DeeplyRootedElements:IsAvailable() or v101.Ascendance:IsAvailable() or v101.PrimordialWave:IsAvailable() or v101.SearingFlames:IsAvailable() or v101.MagmaChamber:IsAvailable()) and ((not v128() and (v130() or (v101.Stormkeeper:CooldownRemains() > (589 - (276 + 313))))) or not v101.SurgeofPower:IsAvailable())) or ((11644 - 6874) == (2677 + 227))) then
					if (v105.CastTargetIf(v101.FlameShock, v113, "min", v123, nil, not v16:IsSpellInRange(v101.FlameShock)) or ((1656 + 2247) == (426 + 4110))) then
						return "flame_shock single_target 14";
					end
					if (((6065 - (495 + 1477)) <= (14506 - 9661)) and v24(v101.FlameShock, not v16:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock single_target 14";
					end
				end
				if (((1028 + 541) <= (4050 - (342 + 61))) and v101.FlameShock:IsCastable() and v40 and (v114 > (1 + 0)) and (v115 > (166 - (4 + 161))) and (v101.DeeplyRootedElements:IsAvailable() or v101.Ascendance:IsAvailable() or v101.PrimordialWave:IsAvailable() or v101.SearingFlames:IsAvailable() or v101.MagmaChamber:IsAvailable()) and ((v13:BuffUp(v101.SurgeofPowerBuff) and not v130() and v101.Stormkeeper:CooldownDown()) or not v101.SurgeofPower:IsAvailable())) then
					if (v105.CastTargetIf(v101.FlameShock, v113, "min", v123, v120, not v16:IsSpellInRange(v101.FlameShock)) or ((2478 + 1568) >= (15465 - 10538))) then
						return "flame_shock single_target 16";
					end
					if (((12150 - 7527) >= (3284 - (322 + 175))) and v24(v101.FlameShock, not v16:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock single_target 16";
					end
				end
				if (((2797 - (173 + 390)) >= (304 + 926)) and v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (314 - (203 + 111))) and not v13:BuffUp(v101.StormkeeperBuff) and v48 and ((v66 and v34) or not v66) and (v91 < v109) and v13:BuffDown(v101.AscendanceBuff) and not v130() and (v126() >= (8 + 108)) and v101.ElementalBlast:IsAvailable() and v101.SurgeofPower:IsAvailable() and v101.SwellingMaelstrom:IsAvailable() and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.PrimordialSurge:IsAvailable()) then
					if (v24(v101.Stormkeeper) or ((242 + 101) == (5212 - 3426))) then
						return "stormkeeper single_target 18";
					end
				end
				if (((2322 + 248) > (3115 - (57 + 649))) and v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (384 - (328 + 56))) and not v13:BuffUp(v101.StormkeeperBuff) and v48 and ((v66 and v34) or not v66) and (v91 < v109) and v13:BuffDown(v101.AscendanceBuff) and not v130() and v13:BuffUp(v101.SurgeofPowerBuff) and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.PrimordialSurge:IsAvailable()) then
					if (v24(v101.Stormkeeper) or ((835 + 1774) >= (3746 - (433 + 79)))) then
						return "stormkeeper single_target 20";
					end
				end
				if ((v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (0 + 0)) and not v13:BuffUp(v101.StormkeeperBuff) and v48 and ((v66 and v34) or not v66) and (v91 < v109) and v13:BuffDown(v101.AscendanceBuff) and not v130() and (not v101.SurgeofPower:IsAvailable() or not v101.ElementalBlast:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.EchooftheElements:IsAvailable() or v101.PrimordialSurge:IsAvailable())) or ((2449 + 584) >= (13554 - 9523))) then
					if (v24(v101.Stormkeeper) or ((6625 - 5224) == (3404 + 1264))) then
						return "stormkeeper single_target 22";
					end
				end
				if (((2474 + 302) >= (2357 - (562 + 474))) and v101.Ascendance:IsCastable() and v53 and ((v59 and v33) or not v59) and (v91 < v109) and not v130()) then
					if (v24(v101.Ascendance) or ((1136 - 649) > (4691 - 2388))) then
						return "ascendance single_target 24";
					end
				end
				v169 = 907 - (76 + 829);
			end
			if ((v169 == (1681 - (1506 + 167))) or ((8458 - 3955) == (3728 - (58 + 208)))) then
				if (((327 + 226) <= (1100 + 443)) and v101.FrostShock:IsCastable() and v41 and v131() and v128() and v13:BuffDown(v101.LavaSurgeBuff) and not v101.ElectrifiedShocks:IsAvailable() and not v101.FluxMelting:IsAvailable() and (v101.LavaBurst:ChargesFractional() < (1 + 0)) and v101.EchooftheElements:IsAvailable()) then
					if (((8220 - 6205) == (2352 - (258 + 79))) and v24(v101.FrostShock, not v16:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single_target 98";
					end
				end
				if ((v101.FrostShock:IsCastable() and v41 and v131() and (v101.FluxMelting:IsAvailable() or (v101.ElectrifiedShocks:IsAvailable() and not v101.LightningRod:IsAvailable()))) or ((539 + 3702) <= (4905 - 2573))) then
					if (v24(v101.FrostShock, not v16:IsSpellInRange(v101.FrostShock)) or ((3834 - (1219 + 251)) < (2828 - (1231 + 440)))) then
						return "frost_shock single_target 100";
					end
				end
				if ((v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v36 and v128() and v13:BuffDown(v101.LavaSurgeBuff) and (v101.LavaBurst:ChargesFractional() < (59 - (34 + 24))) and v101.EchooftheElements:IsAvailable() and (v114 > (1 + 0)) and (v115 > (1 - 0))) or ((510 + 657) > (3881 - 2603))) then
					if (v24(v101.ChainLightning, not v16:IsSpellInRange(v101.ChainLightning)) or ((3670 - 2525) <= (2844 - 1762))) then
						return "chain_lightning single_target 102";
					end
				end
				if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v45 and v128() and v13:BuffDown(v101.LavaSurgeBuff) and (v101.LavaBurst:ChargesFractional() < (3 - 2)) and v101.EchooftheElements:IsAvailable()) or ((6779 - 3674) == (6470 - (877 + 712)))) then
					if (v24(v101.LightningBolt, not v16:IsSpellInRange(v101.LightningBolt)) or ((1130 + 757) > (5632 - (242 + 512)))) then
						return "lightning_bolt single_target 104";
					end
				end
				if ((v101.FrostShock:IsCastable() and v41 and v131() and not v101.ElectrifiedShocks:IsAvailable() and not v101.FluxMelting:IsAvailable()) or ((8540 - 4453) > (4743 - (92 + 535)))) then
					if (((871 + 235) <= (2607 - 1341)) and v24(v101.FrostShock, not v16:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single_target 106";
					end
				end
				if (((198 + 2957) < (16900 - 12250)) and v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v36 and (v114 > (1 + 0)) and (v115 > (1 + 0))) then
					if (((530 + 3244) >= (3664 - 1825)) and v24(v101.ChainLightning, not v16:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning single_target 108";
					end
				end
				v169 = 13 - 4;
			end
			if (((4596 - (1476 + 309)) == (4095 - (299 + 985))) and (v169 == (2 + 5))) then
				if (((7034 - 4888) > (1215 - (86 + 7))) and v127(v101.ElementalBlast) and v101.ElementalBlast:IsCastable() and v39) then
					if (v24(v101.ElementalBlast, not v16:IsSpellInRange(v101.ElementalBlast)) or ((228 - 172) == (344 + 3272))) then
						return "elemental_blast single_target 86";
					end
				end
				if ((v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v36 and v129() and v101.UnrelentingCalamity:IsAvailable() and (v114 > (881 - (672 + 208))) and (v115 > (1 + 0))) or ((2553 - (14 + 118)) < (1067 - (339 + 106)))) then
					if (((803 + 206) <= (569 + 561)) and v24(v101.ChainLightning, not v16:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning single_target 88";
					end
				end
				if (((4153 - (440 + 955)) < (2937 + 43)) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v45 and v129() and v101.UnrelentingCalamity:IsAvailable()) then
					if (v24(v101.LightningBolt, not v16:IsSpellInRange(v101.LightningBolt)) or ((154 - 68) >= (1204 + 2422))) then
						return "lightning_bolt single_target 90";
					end
				end
				if (((5962 - 3567) == (1641 + 754)) and v127(v101.Icefury) and v101.Icefury:IsCastable() and v42) then
					if (((4133 - (260 + 93)) > (2538 + 171)) and v24(v101.Icefury, not v16:IsSpellInRange(v101.Icefury))) then
						return "icefury single_target 92";
					end
				end
				if ((v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v36 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v101.LightningRodDebuff) and (v16:DebuffUp(v101.ElectrifiedShocksDebuff) or v129()) and (v114 > (2 - 1)) and (v115 > (1 - 0))) or ((2211 - (1181 + 793)) >= (579 + 1694))) then
					if (v24(v101.ChainLightning, not v16:IsSpellInRange(v101.ChainLightning)) or ((2347 - (105 + 202)) <= (564 + 139))) then
						return "chain_lightning single_target 94";
					end
				end
				if (((4089 - (352 + 458)) <= (15994 - 12027)) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v45 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v101.LightningRodDebuff) and (v16:DebuffUp(v101.ElectrifiedShocksDebuff) or v129())) then
					if (v24(v101.LightningBolt, not v16:IsSpellInRange(v101.LightningBolt)) or ((5082 - 3094) == (849 + 28))) then
						return "lightning_bolt single_target 96";
					end
				end
				v169 = 23 - 15;
			end
		end
	end
	local function v140()
		local v170 = 949 - (438 + 511);
		while true do
			if (((5674 - (1262 + 121)) > (2980 - (728 + 340))) and (v170 == (1790 - (816 + 974)))) then
				if (((6136 - 4133) < (8417 - 6078)) and v74 and v101.EarthShield:IsCastable() and v13:BuffDown(v101.EarthShieldBuff) and ((v75 == "Earth Shield") or (v101.ElementalOrbit:IsAvailable() and v13:BuffUp(v101.LightningShield)))) then
					if (((771 - (163 + 176)) == (1229 - 797)) and v24(v101.EarthShield)) then
						return "earth_shield main 2";
					end
				elseif ((v74 and v101.LightningShield:IsCastable() and v13:BuffDown(v101.LightningShieldBuff) and ((v75 == "Lightning Shield") or (v101.ElementalOrbit:IsAvailable() and v13:BuffUp(v101.EarthShield)))) or ((5261 - 4116) >= (379 + 874))) then
					if (((5228 - (1564 + 246)) > (2463 - (124 + 221))) and v24(v101.LightningShield)) then
						return "lightning_shield main 2";
					end
				end
				v30 = v134();
				v170 = 1 + 0;
			end
			if (((3517 - (115 + 336)) <= (8567 - 4677)) and (v170 == (1 + 1))) then
				if ((v101.AncestralSpirit:IsCastable() and v101.AncestralSpirit:IsReady() and not v13:AffectingCombat() and v14:Exists() and v14:IsDeadOrGhost() and v14:IsAPlayer() and not v13:CanAttack(v14)) or ((3044 - (45 + 1)) >= (178 + 3103))) then
					if (v24(v103.AncestralSpiritMouseover) or ((6639 - (1282 + 708)) <= (3844 - (583 + 629)))) then
						return "ancestral_spirit mouseover";
					end
				end
				v110, v111 = v29();
				v170 = 1 + 2;
			end
			if ((v170 == (2 - 1)) or ((2024 + 1836) > (6042 - (943 + 227)))) then
				if (v30 or ((1748 + 2250) == (3929 - (1539 + 92)))) then
					return v30;
				end
				if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((1954 - (706 + 1240)) >= (2997 - (81 + 177)))) then
					if (((7317 - 4727) == (2847 - (212 + 45))) and v24(v101.AncestralSpirit, nil, true)) then
						return "ancestral_spirit";
					end
				end
				v170 = 6 - 4;
			end
			if ((v170 == (1949 - (708 + 1238))) or ((7 + 75) >= (612 + 1258))) then
				if (((4291 - (586 + 1081)) < (5068 - (348 + 163))) and v101.ImprovedFlametongueWeapon:IsAvailable() and v101.FlametongueWeapon:IsCastable() and v50 and (not v110 or (v111 < (538874 + 61126))) and v101.FlametongueWeapon:IsAvailable()) then
					if (v24(v101.FlametongueWeapon) or ((3411 - (215 + 65)) > (9024 - 5482))) then
						return "flametongue_weapon enchant";
					end
				end
				if (((4436 - (1541 + 318)) >= (1400 + 178)) and not v13:AffectingCombat() and v31 and v105.TargetIsValid()) then
					local v266 = 0 + 0;
					while true do
						if (((3092 + 1011) <= (6321 - (1036 + 714))) and (v266 == (0 + 0))) then
							v30 = v137();
							if (v30 or ((826 + 669) == (6067 - (883 + 397)))) then
								return v30;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v141()
		local v171 = 590 - (563 + 27);
		while true do
			if ((v171 == (7 - 5)) or ((2296 - (1369 + 617)) > (5921 - (85 + 1402)))) then
				if (((748 + 1420) <= (11254 - 6894)) and v85) then
					local v267 = 403 - (274 + 129);
					while true do
						if (((1211 - (12 + 205)) == (908 + 86)) and (v267 == (0 - 0))) then
							if (((1602 + 53) > (785 - (27 + 357))) and v17) then
								local v284 = 480 - (91 + 389);
								while true do
									if (((3360 - (90 + 207)) <= (132 + 3294)) and (v284 == (861 - (706 + 155)))) then
										v30 = v133();
										if (((3254 - (730 + 1065)) > (2327 - (1339 + 224))) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							if ((v14 and v14:Exists() and not v13:CanAttack(v14) and (v105.UnitHasDispellableDebuffByPlayer(v14) or v105.UnitHasCurseDebuff(v14))) or ((327 + 314) > (3859 + 475))) then
								if (((5059 - 1660) >= (3103 - (268 + 575))) and v101.CleanseSpirit:IsCastable()) then
									if (v24(v103.CleanseSpiritMouseover, not v14:IsSpellInRange(v101.PurifySpirit)) or ((1687 - (919 + 375)) >= (11664 - 7422))) then
										return "purify_spirit dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				if (((1960 - (180 + 791)) < (6664 - (323 + 1482))) and v101.GreaterPurge:IsAvailable() and v98 and v101.GreaterPurge:IsReady() and v35 and v84 and not v13:IsCasting() and not v13:IsChanneling() and v105.UnitHasMagicBuff(v16)) then
					if (v24(v101.GreaterPurge, not v16:IsSpellInRange(v101.GreaterPurge)) or ((6713 - (1177 + 741)) < (63 + 886))) then
						return "greater_purge damage";
					end
				end
				v171 = 11 - 8;
			end
			if (((1479 + 2363) == (8581 - 4739)) and (v171 == (1 + 0))) then
				if (((1856 - (96 + 13)) <= (5522 - (962 + 959))) and v86) then
					local v268 = 0 - 0;
					while true do
						if ((v268 == (1 + 0)) or ((2155 - (461 + 890)) > (3198 + 1161))) then
							if (((18195 - 13525) >= (3866 - (19 + 224))) and v83) then
								local v285 = 0 + 0;
								while true do
									if (((2263 - (37 + 161)) < (918 + 1626)) and (v285 == (0 + 0))) then
										v30 = v105.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 30 + 0);
										if (((1372 - (60 + 1)) <= (4282 - (826 + 97))) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							break;
						end
						if (((2632 + 85) <= (11344 - 8188)) and (v268 == (0 - 0))) then
							if (((1766 - (375 + 310)) < (6523 - (1864 + 135))) and v81) then
								local v286 = 0 - 0;
								while true do
									if (((98 + 342) >= (24 + 47)) and (v286 == (0 - 0))) then
										v30 = v105.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 1171 - (314 + 817));
										if (((2799 + 2135) > (2821 - (32 + 182))) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							if (v82 or ((1035 + 365) > (10890 - 7774))) then
								v30 = v105.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 95 - (39 + 26));
								if (((669 - (54 + 90)) < (1860 - (45 + 153))) and v30) then
									return v30;
								end
							end
							v268 = 1 + 0;
						end
					end
				end
				if (v87 or ((1428 - (457 + 95)) > (2534 + 16))) then
					local v269 = 0 - 0;
					while true do
						if (((528 - 309) <= (8880 - 6424)) and (v269 == (0 + 0))) then
							v30 = v105.HandleIncorporeal(v101.Hex, v103.HexMouseOver, 103 - 73, true);
							if (v30 or ((12737 - 8518) == (1898 - (485 + 263)))) then
								return v30;
							end
							break;
						end
					end
				end
				v171 = 709 - (575 + 132);
			end
			if ((v171 == (864 - (750 + 111))) or ((3999 - (445 + 565)) <= (179 + 43))) then
				if (((324 + 1934) > (2192 - 951)) and v101.Purge:IsReady() and v98 and v35 and v84 and not v13:IsCasting() and not v13:IsChanneling() and v105.UnitHasMagicBuff(v16)) then
					if (((14 + 27) < (4569 - (189 + 121))) and v24(v101.Purge, not v16:IsSpellInRange(v101.Purge))) then
						return "purge damage";
					end
				end
				if ((v105.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) or ((478 + 1452) < (1403 - (634 + 713)))) then
					local v270 = 538 - (493 + 45);
					local v271;
					while true do
						if (((4301 - (493 + 475)) == (852 + 2481)) and (v270 == (787 - (158 + 626)))) then
							if ((v32 and (v114 > (1 + 1)) and (v115 > (2 - 0))) or ((496 + 1729) == (2 + 18))) then
								local v287 = 1091 - (1035 + 56);
								while true do
									if ((v287 == (959 - (114 + 845))) or ((340 + 532) >= (7914 - 4822))) then
										v30 = v138();
										if (((3703 + 701) >= (4301 - (179 + 870))) and v30) then
											return v30;
										end
										v287 = 1 - 0;
									end
									if (((1985 - (827 + 51)) > (2104 - 1308)) and (v287 == (1 + 0))) then
										if (((1432 - (95 + 378)) == (70 + 889)) and v24(v101.Pool)) then
											return "Pool for Aoe()";
										end
										break;
									end
								end
							end
							if (true or ((347 - 102) >= (1936 + 268))) then
								local v288 = 1011 - (334 + 677);
								while true do
									if (((11837 - 8675) >= (3125 - (1049 + 7))) and (v288 == (4 - 3))) then
										if (v24(v101.Pool) or ((575 - 269) > (961 + 2120))) then
											return "Pool for SingleTarget()";
										end
										break;
									end
									if ((v288 == (0 - 0)) or ((7037 - 3524) < (1205 + 1501))) then
										v30 = v139();
										if (((4398 - (1004 + 416)) < (5596 - (1621 + 336))) and v30) then
											return v30;
										end
										v288 = 1940 - (337 + 1602);
									end
								end
							end
							break;
						end
						if (((5199 - (1014 + 503)) >= (3903 - (446 + 569))) and (v270 == (1 + 0))) then
							if (((437 - 288) < (161 + 318)) and (v91 < v109)) then
								if (((2118 - 1098) >= (12 + 555)) and v57 and ((v33 and v63) or not v63)) then
									v30 = v136();
									if (v30 or ((1238 - (223 + 282)) > (72 + 2397))) then
										return v30;
									end
								end
							end
							if (((3975 - 1478) == (3642 - 1145)) and v101.NaturesSwiftness:IsCastable() and v46) then
								if (((4571 - (623 + 47)) == (3946 - (32 + 13))) and v24(v101.NaturesSwiftness)) then
									return "natures_swiftness main 12";
								end
							end
							v270 = 2 + 0;
						end
						if (((164 + 37) < (2216 - (1070 + 731))) and (v270 == (0 + 0))) then
							if ((v101.SpiritwalkersGrace:IsCastable() and v51 and v13:IsMoving()) or ((1537 - (1257 + 147)) == (708 + 1076))) then
								if (v24(v101.SpiritwalkersGrace) or ((12 - 5) >= (443 - (98 + 35)))) then
									return "spiritwalkers_grace main 0";
								end
							end
							if (((2094 + 2898) > (1012 - 726)) and (v91 < v109) and v58 and ((v64 and v33) or not v64)) then
								if ((v101.BloodFury:IsCastable() and (not v101.Ascendance:IsAvailable() or v13:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (168 - 118)))) or ((2395 + 166) == (3426 + 467))) then
									if (((1911 + 2451) >= (1978 - (395 + 162))) and v24(v101.BloodFury)) then
										return "blood_fury main 2";
									end
								end
								if (((66 + 9) <= (5487 - (816 + 1125))) and v101.Berserking:IsCastable() and (not v101.Ascendance:IsAvailable() or v13:BuffUp(v101.AscendanceBuff))) then
									if (((3824 - 1144) <= (4566 - (701 + 447))) and v24(v101.Berserking)) then
										return "berserking main 4";
									end
								end
								if ((v101.Fireblood:IsCastable() and (not v101.Ascendance:IsAvailable() or v13:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (77 - 27)))) or ((7495 - 3207) < (4217 - (391 + 950)))) then
									if (((6634 - 4172) >= (2874 - 1727)) and v24(v101.Fireblood)) then
										return "fireblood main 6";
									end
								end
								if ((v101.AncestralCall:IsCastable() and (not v101.Ascendance:IsAvailable() or v13:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (123 - 73)))) or ((3447 + 1467) < (1443 + 1037))) then
									if (v24(v101.AncestralCall) or ((5700 - 4141) == (2762 - (251 + 1271)))) then
										return "ancestral_call main 8";
									end
								end
								if (((504 + 62) == (1515 - 949)) and v101.BagofTricks:IsCastable() and (not v101.Ascendance:IsAvailable() or v13:BuffUp(v101.AscendanceBuff))) then
									if (((9818 - 5897) >= (4982 - 1973)) and v24(v101.BagofTricks)) then
										return "bag_of_tricks main 10";
									end
								end
							end
							v270 = 1260 - (1147 + 112);
						end
						if (((516 + 1547) >= (3346 - 1698)) and (v270 == (1 + 1))) then
							v271 = v105.HandleDPSPotion(v13:BuffUp(v101.AscendanceBuff));
							if (((1763 - (335 + 362)) >= (424 + 28)) and v271) then
								return v271;
							end
							v270 = 4 - 1;
						end
					end
				end
				break;
			end
			if (((13575 - 8601) >= (9865 - 7210)) and (v171 == (0 - 0))) then
				v30 = v135();
				if (v30 or ((7722 - 5001) <= (1473 - (237 + 329)))) then
					return v30;
				end
				v171 = 3 - 2;
			end
		end
	end
	local function v142()
		v36 = EpicSettings.Settings['useChainlightning'];
		v37 = EpicSettings.Settings['useEarthquake'];
		v38 = EpicSettings.Settings['useEarthShock'];
		v39 = EpicSettings.Settings['useElementalBlast'];
		v40 = EpicSettings.Settings['useFlameShock'];
		v41 = EpicSettings.Settings['useFrostShock'];
		v42 = EpicSettings.Settings['useIceFury'];
		v43 = EpicSettings.Settings['useLavaBeam'];
		v44 = EpicSettings.Settings['useLavaBurst'];
		v45 = EpicSettings.Settings['useLightningBolt'];
		v46 = EpicSettings.Settings['useNaturesSwiftness'];
		v47 = EpicSettings.Settings['usePrimordialWave'];
		v48 = EpicSettings.Settings['useStormkeeper'];
		v49 = EpicSettings.Settings['useTotemicRecall'];
		v50 = EpicSettings.Settings['useWeaponEnchant'];
		v51 = EpicSettings.Settings['UseSpiritwalkersGrace'];
		v92 = EpicSettings.Settings['useWeapon'];
		v53 = EpicSettings.Settings['useAscendance'];
		v55 = EpicSettings.Settings['useLiquidMagmaTotem'];
		v54 = EpicSettings.Settings['useFireElemental'];
		v56 = EpicSettings.Settings['useStormElemental'];
		v59 = EpicSettings.Settings['ascendanceWithCD'];
		v62 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
		v60 = EpicSettings.Settings['fireElementalWithCD'];
		v61 = EpicSettings.Settings['stormElementalWithCD'];
		v65 = EpicSettings.Settings['primordialWaveWithMiniCD'];
		v66 = EpicSettings.Settings['stormkeeperWithMiniCD'];
	end
	local function v143()
		v68 = EpicSettings.Settings['useWindShear'];
		v69 = EpicSettings.Settings['useCapacitorTotem'];
		v70 = EpicSettings.Settings['useThunderstorm'];
		v71 = EpicSettings.Settings['useAncestralGuidance'];
		v72 = EpicSettings.Settings['useAstralShift'];
		v73 = EpicSettings.Settings['useHealingStreamTotem'];
		v76 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 + 0);
		v77 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
		v78 = EpicSettings.Settings['astralShiftHP'] or (1124 - (408 + 716));
		v79 = EpicSettings.Settings['healingStreamTotemHP'] or (0 - 0);
		v80 = EpicSettings.Settings['healingStreamTotemGroup'] or (821 - (344 + 477));
		v52 = EpicSettings.Settings['earthquakeSetting'] or "";
		v67 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
		v74 = EpicSettings.Settings['autoShield'];
		v75 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
		v99 = EpicSettings.Settings['healOOC'];
		v100 = EpicSettings.Settings['healOOCHP'] or (0 + 0);
		v98 = EpicSettings.Settings['usePurgeTarget'];
		v81 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
		v82 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v83 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
	end
	local function v144()
		local v211 = 1761 - (1188 + 573);
		while true do
			if (((11627 - 7190) >= (2953 + 78)) and (v211 == (9 - 6))) then
				v64 = EpicSettings.Settings['racialsWithCD'];
				v94 = EpicSettings.Settings['useHealthstone'];
				v93 = EpicSettings.Settings['useHealingPotion'];
				v211 = 6 - 2;
			end
			if ((v211 == (0 - 0)) or ((5999 - (508 + 1021)) < (2772 + 177))) then
				v91 = EpicSettings.Settings['fightRemainsCheck'] or (1166 - (228 + 938));
				v88 = EpicSettings.Settings['InterruptWithStun'];
				v89 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v211 = 686 - (332 + 353);
			end
			if ((v211 == (1 - 0)) or ((4136 - 2556) == (2299 + 127))) then
				v90 = EpicSettings.Settings['InterruptThreshold'];
				v85 = EpicSettings.Settings['DispelDebuffs'];
				v84 = EpicSettings.Settings['DispelBuffs'];
				v211 = 2 + 0;
			end
			if (((15 - 11) == v211) or ((4134 - (18 + 405)) == (231 + 272))) then
				v96 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v95 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v97 = EpicSettings.Settings['HealingPotionName'] or "";
				v211 = 983 - (194 + 784);
			end
			if (((1775 - (694 + 1076)) == v211) or ((2324 - (122 + 1782)) == (4064 + 254))) then
				v86 = EpicSettings.Settings['handleAfflicted'];
				v87 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v211 == (2 + 0)) or ((3743 + 415) <= (24 + 9))) then
				v57 = EpicSettings.Settings['useTrinkets'];
				v58 = EpicSettings.Settings['useRacials'];
				v63 = EpicSettings.Settings['trinketsWithCD'];
				v211 = 8 - 5;
			end
		end
	end
	local function v145()
		local v212 = 0 + 0;
		while true do
			if (((1970 - (214 + 1756)) == v212) or ((478 - 379) > (524 + 4220))) then
				v143();
				v142();
				v144();
				v31 = EpicSettings.Toggles['ooc'];
				v212 = 1 + 0;
			end
			if (((4926 - (217 + 368)) == (13114 - 8773)) and (v212 == (2 + 1))) then
				if (((190 + 65) <= (54 + 1542)) and v35 and v85) then
					if ((v13:AffectingCombat() and v101.CleanseSpirit:IsAvailable()) or ((5322 - (844 + 45)) < (1919 - (242 + 42)))) then
						local v277 = 0 - 0;
						local v278;
						while true do
							if ((v277 == (0 - 0)) or ((5500 - (132 + 1068)) < (5179 - 1935))) then
								v278 = v85 and v101.CleanseSpirit:IsReady() and v35;
								v30 = v105.FocusUnit(v278, nil, 1643 - (214 + 1409), nil, 20 + 5, v101.HealingSurge);
								v277 = 1635 - (497 + 1137);
							end
							if ((v277 == (941 - (9 + 931))) or ((3823 - (181 + 108)) > (2786 + 1891))) then
								if (v30 or ((11982 - 7123) < (8906 - 5907))) then
									return v30;
								end
								break;
							end
						end
					end
				end
				if (((1116 + 3610) > (1501 + 906)) and (v105.TargetIsValid() or v13:AffectingCombat())) then
					v108 = v9.BossFightRemains();
					v109 = v108;
					if ((v109 == (11587 - (296 + 180))) or ((2687 - (1183 + 220)) > (4934 - (1037 + 228)))) then
						v109 = v9.FightRemains(v112, false);
					end
				end
				if (((1807 - 690) < (7346 - 4797)) and not v13:IsChanneling() and not v13:IsCasting()) then
					local v272 = 0 - 0;
					while true do
						if ((v272 == (734 - (527 + 207))) or ((3378 - (187 + 340)) > (6644 - (1298 + 572)))) then
							if (((2563 - 1532) < (4018 - (144 + 26))) and v86) then
								local v289 = 0 - 0;
								while true do
									if (((4323 - 2469) > (323 + 580)) and (v289 == (0 - 0))) then
										if (((10824 - 6161) > (9016 - 7156)) and v81) then
											local v291 = 0 + 0;
											while true do
												if ((v291 == (0 - 0)) or ((2851 + 202) <= (176 + 293))) then
													v30 = v105.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 242 - (5 + 197));
													if (v30 or ((1226 - (339 + 347)) >= (4235 - 2366))) then
														return v30;
													end
													break;
												end
											end
										end
										if (((11593 - 8301) == (3668 - (365 + 11))) and v82) then
											local v292 = 0 + 0;
											while true do
												if (((3992 - 2954) <= (6208 - 3563)) and (v292 == (924 - (837 + 87)))) then
													v30 = v105.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 50 - 20);
													if (v30 or ((4900 - (837 + 833)) < (539 + 1986))) then
														return v30;
													end
													break;
												end
											end
										end
										v289 = 1388 - (356 + 1031);
									end
									if (((1 + 0) == v289) or ((4046 - (73 + 1573)) > (5471 - (1307 + 81)))) then
										if (v83 or ((2979 - (7 + 227)) > (7159 - 2800))) then
											local v293 = 166 - (90 + 76);
											while true do
												if (((539 - 367) <= (887 + 923)) and (v293 == (0 + 0))) then
													v30 = v105.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 25 + 5);
													if (v30 or ((1927 - 1435) >= (5219 - (197 + 63)))) then
														return v30;
													end
													break;
												end
											end
										end
										break;
									end
								end
							end
							if (v13:AffectingCombat() or ((160 + 596) == (491 + 1581))) then
								if (((838 + 767) <= (766 + 3898)) and v33 and v92 and (v102.Dreambinder:IsEquippedAndReady() or v102.Iridal:IsEquippedAndReady())) then
									if (((2279 - 463) == (3185 - (618 + 751))) and v24(v103.UseWeapon, nil)) then
										return "Using Weapon Macro";
									end
								end
								v30 = v141();
								if (v30 or ((465 + 156) > (5010 - (206 + 1704)))) then
									return v30;
								end
							else
								local v290 = 0 - 0;
								while true do
									if (((0 - 0) == v290) or ((505 + 652) >= (5500 - (155 + 1120)))) then
										v30 = v140();
										if (v30 or ((6492 - (396 + 1110)) == (9346 - 5208))) then
											return v30;
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
			if ((v212 == (1 + 1)) or ((1533 + 500) <= (192 + 32))) then
				if (v13:IsDeadOrGhost() or ((2199 - (230 + 746)) == (2612 - (473 + 128)))) then
					return v30;
				end
				v112 = v13:GetEnemiesInRange(88 - (39 + 9));
				v113 = v16:GetEnemiesInSplashRange(271 - (38 + 228));
				if (((8767 - 3940) > (5168 - (106 + 367))) and v32) then
					local v273 = 0 + 0;
					while true do
						if (((5572 - (354 + 1508)) > (9836 - 6771)) and (v273 == (0 + 0))) then
							v114 = #v112;
							v115 = v27(v16:GetEnemiesInSplashRangeCount(3 + 2), v114);
							break;
						end
					end
				else
					local v274 = 0 - 0;
					while true do
						if (((3379 - (334 + 910)) <= (3591 - (92 + 803))) and (v274 == (0 + 0))) then
							v114 = 1182 - (1035 + 146);
							v115 = 617 - (230 + 386);
							break;
						end
					end
				end
				v212 = 2 + 1;
			end
			if ((v212 == (1511 - (353 + 1157))) or ((2856 - (53 + 1061)) > (6032 - (1568 + 67)))) then
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				v34 = EpicSettings.Toggles['minicds'];
				v212 = 1 + 1;
			end
		end
	end
	local function v146()
		local v213 = 0 + 0;
		while true do
			if (((9873 - 5973) >= (5602 - 3698)) and (v213 == (0 - 0))) then
				v101.FlameShockDebuff:RegisterAuraTracking();
				v107();
				v213 = 1 + 0;
			end
			if ((v213 == (1213 - (615 + 597))) or ((1543 + 181) == (1359 - 450))) then
				v21.Print("Elemental Shaman by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(216 + 46, v145, v146);
end;
return v0["Epix_Shaman_Elemental.lua"]();

