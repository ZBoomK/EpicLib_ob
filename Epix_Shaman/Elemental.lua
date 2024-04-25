local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((1666 - 1065) < (7731 - 4171)) and (v5 == (302 - (115 + 187)))) then
			v6 = v0[v4];
			if (((180 + 55) < (651 + 36)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
		end
		if (((5710 - (160 + 1001)) > (1009 + 144)) and (v5 == (1 + 0))) then
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
	local v100;
	local v101 = v19.Shaman.Elemental;
	local v102 = v21.Shaman.Elemental;
	local v103 = v24.Shaman.Elemental;
	local v104 = {};
	local v105 = v22.Commons.Everyone;
	local v106 = v22.Commons.Shaman;
	local function v107()
		if (v101.CleanseSpirit:IsAvailable() or ((9567 - 4893) < (5030 - (237 + 121)))) then
			v105.DispellableDebuffs = v105.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v107();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v10:RegisterForEvent(function()
		v101.PrimordialWave:RegisterInFlightEffect(328059 - (525 + 372));
		v101.PrimordialWave:RegisterInFlight();
		v101.LavaBurst:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v101.PrimordialWave:RegisterInFlightEffect(620261 - 293099);
	v101.PrimordialWave:RegisterInFlight();
	v101.LavaBurst:RegisterInFlight();
	local v108 = 36506 - 25395;
	local v109 = 11253 - (96 + 46);
	local v110, v111;
	local v112, v113;
	local v114 = 777 - (643 + 134);
	local v115 = 0 + 0;
	local v116 = 0 - 0;
	local v117 = 0 - 0;
	local v118 = 0 + 0;
	local function v119()
		return (78 - 38) - (v29() - v116);
	end
	v10:RegisterForSelfCombatEvent(function(...)
		local v147, v148, v148, v148, v149 = select(16 - 8, ...);
		if (((4387 - (316 + 403)) < (3032 + 1529)) and (v147 == v14:GUID()) and (v149 == (526874 - 335240))) then
			v117 = v29();
			C_Timer.After(0.1 + 0, function()
				if ((v117 ~= v118) or ((1145 - 690) == (2555 + 1050))) then
					v116 = v117;
				end
			end);
		end
	end, "SPELL_AURA_APPLIED");
	local function v120(v150)
		return (v150:DebuffRefreshable(v101.FlameShockDebuff));
	end
	local function v121(v151)
		return v151:DebuffRefreshable(v101.FlameShockDebuff) and (v151:DebuffRemains(v101.FlameShockDebuff) < (v151:TimeToDie() - (2 + 3)));
	end
	local function v122(v152)
		return v152:DebuffRefreshable(v101.FlameShockDebuff) and (v152:DebuffRemains(v101.FlameShockDebuff) < (v152:TimeToDie() - (17 - 12))) and (v152:DebuffRemains(v101.FlameShockDebuff) > (0 - 0));
	end
	local function v123(v153)
		return (v153:DebuffRemains(v101.FlameShockDebuff));
	end
	local function v124(v154)
		return v154:DebuffRemains(v101.FlameShockDebuff) > (3 - 1);
	end
	local function v125(v155)
		return (v155:DebuffRemains(v101.LightningRodDebuff));
	end
	local function v126()
		local v156 = 0 + 0;
		local v157;
		while true do
			if ((v156 == (0 - 0)) or ((131 + 2532) == (9744 - 6432))) then
				v157 = v14:Maelstrom();
				if (((4294 - (12 + 5)) <= (17381 - 12906)) and not v14:IsCasting()) then
					return v157;
				elseif (v14:IsCasting(v101.ElementalBlast) or ((1856 - 986) == (2527 - 1338))) then
					return v157 - (185 - 110);
				elseif (((316 + 1237) <= (5106 - (1656 + 317))) and v14:IsCasting(v101.Icefury)) then
					return v157 + 23 + 2;
				elseif (v14:IsCasting(v101.LightningBolt) or ((1793 + 444) >= (9335 - 5824))) then
					return v157 + (49 - 39);
				elseif (v14:IsCasting(v101.LavaBurst) or ((1678 - (5 + 349)) > (14344 - 11324))) then
					return v157 + (1283 - (266 + 1005));
				elseif (v14:IsCasting(v101.ChainLightning) or ((1972 + 1020) == (6418 - 4537))) then
					return v157 + ((4 - 0) * v115);
				else
					return v157;
				end
				break;
			end
		end
	end
	local function v127(v158)
		local v159 = 1696 - (561 + 1135);
		local v160;
		while true do
			if (((4046 - 940) > (5016 - 3490)) and (v159 == (1066 - (507 + 559)))) then
				v160 = v158:IsReady();
				if (((7585 - 4562) < (11968 - 8098)) and ((v158 == v101.Stormkeeper) or (v158 == v101.ElementalBlast) or (v158 == v101.Icefury))) then
					local v245 = v14:BuffUp(v101.SpiritwalkersGraceBuff) or not v14:IsMoving();
					return v160 and v245 and not v14:IsCasting(v158);
				elseif (((531 - (212 + 176)) > (979 - (250 + 655))) and (v158 == v101.LavaBeam)) then
					local v273 = 0 - 0;
					local v274;
					while true do
						if (((31 - 13) < (3304 - 1192)) and (v273 == (1956 - (1869 + 87)))) then
							v274 = v14:BuffUp(v101.SpiritwalkersGraceBuff) or not v14:IsMoving();
							return v160 and v274;
						end
					end
				elseif (((3804 - 2707) <= (3529 - (484 + 1417))) and ((v158 == v101.LightningBolt) or (v158 == v101.ChainLightning))) then
					local v275 = 0 - 0;
					local v276;
					while true do
						if (((7759 - 3129) == (5403 - (48 + 725))) and (v275 == (0 - 0))) then
							v276 = v14:BuffUp(v101.SpiritwalkersGraceBuff) or v14:BuffUp(v101.StormkeeperBuff) or not v14:IsMoving();
							return v160 and v276;
						end
					end
				elseif (((9497 - 5957) > (1560 + 1123)) and (v158 == v101.LavaBurst)) then
					local v290 = 0 - 0;
					local v291;
					local v292;
					local v293;
					local v294;
					while true do
						if (((1342 + 3452) >= (955 + 2320)) and (v290 == (855 - (152 + 701)))) then
							return v160 and v291 and (v292 or v293 or v294);
						end
						if (((2795 - (430 + 881)) == (569 + 915)) and (v290 == (895 - (557 + 338)))) then
							v291 = v14:BuffUp(v101.SpiritwalkersGraceBuff) or v14:BuffUp(v101.LavaSurgeBuff) or not v14:IsMoving();
							v292 = v14:BuffUp(v101.LavaSurgeBuff);
							v290 = 1 + 0;
						end
						if (((4035 - 2603) < (12448 - 8893)) and (v290 == (2 - 1))) then
							v293 = (v101.LavaBurst:Charges() >= (2 - 1)) and not v14:IsCasting(v101.LavaBurst);
							v294 = (v101.LavaBurst:Charges() == (803 - (499 + 302))) and v14:IsCasting(v101.LavaBurst);
							v290 = 868 - (39 + 827);
						end
					end
				elseif ((v158 == v101.PrimordialWave) or ((2939 - 1874) > (7990 - 4412))) then
					return v160 and v34 and v14:BuffDown(v101.PrimordialWaveBuff) and v14:BuffDown(v101.LavaSurgeBuff);
				else
					return v160;
				end
				break;
			end
		end
	end
	local function v128()
		if (not v101.MasteroftheElements:IsAvailable() or ((19045 - 14250) < (2160 - 753))) then
			return false;
		end
		local v161 = v14:BuffUp(v101.MasteroftheElementsBuff);
		if (((159 + 1694) < (14087 - 9274)) and not v14:IsCasting()) then
			return v161;
		elseif (v14:IsCasting(v106.LavaBurst) or ((452 + 2369) < (3846 - 1415))) then
			return true;
		elseif (v14:IsCasting(v106.ElementalBlast) or v14:IsCasting(v101.Icefury) or v14:IsCasting(v101.LightningBolt) or v14:IsCasting(v101.ChainLightning) or ((2978 - (103 + 1)) < (2735 - (475 + 79)))) then
			return false;
		else
			return v161;
		end
	end
	local function v129()
		local v162 = 0 - 0;
		local v163;
		while true do
			if ((v162 == (3 - 2)) or ((348 + 2341) <= (302 + 41))) then
				if (not v14:IsCasting() or ((3372 - (1395 + 108)) == (5845 - 3836))) then
					return v163 > (1204 - (7 + 1197));
				elseif (((v163 == (1 + 0)) and (v14:IsCasting(v101.LightningBolt) or v14:IsCasting(v101.ChainLightning))) or ((1238 + 2308) < (2641 - (27 + 292)))) then
					return false;
				else
					return v163 > (0 - 0);
				end
				break;
			end
			if ((v162 == (0 - 0)) or ((8731 - 6649) == (9412 - 4639))) then
				if (((6177 - 2933) > (1194 - (43 + 96))) and not v101.PoweroftheMaelstrom:IsAvailable()) then
					return false;
				end
				v163 = v14:BuffStack(v101.PoweroftheMaelstromBuff);
				v162 = 4 - 3;
			end
		end
	end
	local function v130()
		local v164 = 0 - 0;
		local v165;
		while true do
			if ((v164 == (0 + 0)) or ((936 + 2377) <= (3514 - 1736))) then
				if (not v101.Stormkeeper:IsAvailable() or ((545 + 876) >= (3942 - 1838))) then
					return false;
				end
				v165 = v14:BuffUp(v101.StormkeeperBuff);
				v164 = 1 + 0;
			end
			if (((133 + 1679) <= (5000 - (1414 + 337))) and (v164 == (1941 - (1642 + 298)))) then
				if (((4230 - 2607) <= (5629 - 3672)) and not v14:IsCasting()) then
					return v165;
				elseif (((13092 - 8680) == (1452 + 2960)) and v14:IsCasting(v101.Stormkeeper)) then
					return true;
				else
					return v165;
				end
				break;
			end
		end
	end
	local function v131()
		local v166 = 0 + 0;
		local v167;
		while true do
			if (((2722 - (357 + 615)) >= (592 + 250)) and ((2 - 1) == v166)) then
				if (((3747 + 625) > (3964 - 2114)) and not v14:IsCasting()) then
					return v167;
				elseif (((186 + 46) < (56 + 765)) and v14:IsCasting(v101.Icefury)) then
					return true;
				else
					return v167;
				end
				break;
			end
			if (((326 + 192) < (2203 - (384 + 917))) and (v166 == (697 - (128 + 569)))) then
				if (((4537 - (1407 + 136)) > (2745 - (687 + 1200))) and not v101.Icefury:IsAvailable()) then
					return false;
				end
				v167 = v14:BuffUp(v101.IcefuryBuff);
				v166 = 1711 - (556 + 1154);
			end
		end
	end
	local v132 = 0 - 0;
	local function v133()
		if ((v101.CleanseSpirit:IsReady() and v36 and (v105.UnitHasDispellableDebuffByPlayer(v18) or v105.DispellableFriendlyUnit(120 - (9 + 86)) or v105.UnitHasCurseDebuff(v18))) or ((4176 - (275 + 146)) <= (149 + 766))) then
			if (((4010 - (29 + 35)) > (16588 - 12845)) and (v132 == (0 - 0))) then
				v132 = v29();
			end
			if (v105.Wait(2207 - 1707, v132) or ((870 + 465) >= (4318 - (53 + 959)))) then
				local v240 = 408 - (312 + 96);
				while true do
					if (((8406 - 3562) > (2538 - (147 + 138))) and (v240 == (899 - (813 + 86)))) then
						if (((409 + 43) == (836 - 384)) and v25(v103.CleanseSpiritFocus)) then
							return "cleanse_spirit dispel";
						end
						v132 = 492 - (18 + 474);
						break;
					end
				end
			end
		end
	end
	local function v134()
		if ((v99 and (v14:HealthPercentage() <= v100)) or ((1538 + 3019) < (6811 - 4724))) then
			if (((4960 - (860 + 226)) == (4177 - (121 + 182))) and v101.HealingSurge:IsReady()) then
				if (v25(v101.HealingSurge) or ((239 + 1699) > (6175 - (988 + 252)))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v135()
		local v168 = 0 + 0;
		while true do
			if ((v168 == (0 + 0)) or ((6225 - (49 + 1921)) < (4313 - (223 + 667)))) then
				if (((1506 - (51 + 1)) <= (4287 - 1796)) and v101.AstralShift:IsReady() and v72 and (v14:HealthPercentage() <= v78)) then
					if (v25(v101.AstralShift) or ((8901 - 4744) <= (3928 - (146 + 979)))) then
						return "astral_shift defensive 1";
					end
				end
				if (((1370 + 3483) >= (3587 - (311 + 294))) and v101.AncestralGuidance:IsReady() and v71 and v105.AreUnitsBelowHealthPercentage(v76, v77, v101.HealingSurge)) then
					if (((11528 - 7394) > (1422 + 1935)) and v25(v101.AncestralGuidance)) then
						return "ancestral_guidance defensive 2";
					end
				end
				v168 = 1444 - (496 + 947);
			end
			if ((v168 == (1359 - (1233 + 125))) or ((1387 + 2030) < (2274 + 260))) then
				if ((v101.HealingStreamTotem:IsReady() and v73 and v105.AreUnitsBelowHealthPercentage(v79, v80, v101.HealingSurge)) or ((518 + 2204) <= (1809 - (963 + 682)))) then
					if (v25(v101.HealingStreamTotem) or ((2010 + 398) < (3613 - (504 + 1000)))) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v102.Healthstone:IsReady() and v94 and (v14:HealthPercentage() <= v96)) or ((23 + 10) == (1326 + 129))) then
					if (v25(v103.Healthstone) or ((42 + 401) >= (5920 - 1905))) then
						return "healthstone defensive 3";
					end
				end
				v168 = 2 + 0;
			end
			if (((1967 + 1415) > (348 - (156 + 26))) and (v168 == (2 + 0))) then
				if ((v93 and (v14:HealthPercentage() <= v95)) or ((438 - 158) == (3223 - (149 + 15)))) then
					local v246 = 960 - (890 + 70);
					while true do
						if (((1998 - (39 + 78)) > (1775 - (14 + 468))) and (v246 == (0 - 0))) then
							if (((6587 - 4230) == (1217 + 1140)) and (v97 == "Refreshing Healing Potion")) then
								if (((74 + 49) == (27 + 96)) and v102.RefreshingHealingPotion:IsReady()) then
									if (v25(v103.RefreshingHealingPotion) or ((477 + 579) >= (889 + 2503))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v97 == "Dreamwalker's Healing Potion") or ((2069 - 988) < (1063 + 12))) then
								if (v102.DreamwalkersHealingPotion:IsReady() or ((3685 - 2636) >= (112 + 4320))) then
									if (v25(v103.RefreshingHealingPotion) or ((4819 - (12 + 39)) <= (788 + 58))) then
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
	local function v136()
		local v169 = 0 - 0;
		while true do
			if (((0 - 0) == v169) or ((996 + 2362) <= (748 + 672))) then
				v31 = v105.HandleTopTrinket(v104, v34, 101 - 61, nil);
				if (v31 or ((2491 + 1248) <= (14522 - 11517))) then
					return v31;
				end
				v169 = 1711 - (1596 + 114);
			end
			if ((v169 == (2 - 1)) or ((2372 - (164 + 549)) >= (3572 - (1059 + 379)))) then
				v31 = v105.HandleBottomTrinket(v104, v34, 49 - 9, nil);
				if (v31 or ((1690 + 1570) < (397 + 1958))) then
					return v31;
				end
				break;
			end
		end
	end
	local function v137()
		local v170 = 392 - (145 + 247);
		while true do
			if ((v170 == (3 + 0)) or ((310 + 359) == (12519 - 8296))) then
				if ((v14:IsCasting(v101.LavaBurst) and v41 and v101.FlameShock:IsReady()) or ((325 + 1367) < (507 + 81))) then
					if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((7789 - 2992) < (4371 - (254 + 466)))) then
						return "flameshock precombat 14";
					end
				end
				if ((v14:IsCasting(v101.LavaBurst) and v48 and ((v65 and v35) or not v65) and v127(v101.PrimordialWave)) or ((4737 - (544 + 16)) > (15413 - 10563))) then
					if (v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave)) or ((1028 - (294 + 334)) > (1364 - (236 + 17)))) then
						return "primordial_wave precombat 16";
					end
				end
				break;
			end
			if (((1316 + 1735) > (783 + 222)) and (v170 == (7 - 5))) then
				if (((17484 - 13791) <= (2257 + 2125)) and v14:IsCasting(v101.ElementalBlast) and v41 and not v101.PrimordialWave:IsAvailable() and v127(v101.FlameShock)) then
					if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((2704 + 578) > (4894 - (413 + 381)))) then
						return "flameshock precombat 10";
					end
				end
				if ((v127(v101.LavaBurst) and v45 and not v14:IsCasting(v101.LavaBurst) and (not v101.ElementalBlast:IsAvailable() or (v101.ElementalBlast:IsAvailable() and not v101.ElementalBlast:IsAvailable()))) or ((151 + 3429) < (6048 - 3204))) then
					if (((230 - 141) < (6460 - (582 + 1388))) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lavaburst precombat 12";
					end
				end
				v170 = 4 - 1;
			end
			if ((v170 == (1 + 0)) or ((5347 - (326 + 38)) < (5348 - 3540))) then
				if (((5465 - 1636) > (4389 - (47 + 573))) and v127(v101.ElementalBlast) and v40) then
					if (((524 + 961) <= (12333 - 9429)) and v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast precombat 6";
					end
				end
				if (((6928 - 2659) == (5933 - (1269 + 395))) and v14:IsCasting(v101.ElementalBlast) and v48 and ((v65 and v35) or not v65) and v127(v101.PrimordialWave)) then
					if (((879 - (76 + 416)) <= (3225 - (319 + 124))) and v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave))) then
						return "primordial_wave precombat 8";
					end
				end
				v170 = 4 - 2;
			end
			if ((v170 == (1007 - (564 + 443))) or ((5256 - 3357) <= (1375 - (337 + 121)))) then
				if ((v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v101.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v109)) or ((14363 - 10051) <= (2787 - (1261 + 650)))) then
					if (((945 + 1287) <= (4136 - 1540)) and v25(v101.Stormkeeper)) then
						return "stormkeeper precombat 2";
					end
				end
				if (((3912 - (772 + 1045)) < (520 + 3166)) and v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (144 - (102 + 42))) and v43) then
					if (v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury)) or ((3439 - (1524 + 320)) >= (5744 - (1049 + 221)))) then
						return "icefury precombat 4";
					end
				end
				v170 = 157 - (18 + 138);
			end
		end
	end
	local function v138()
		local v171 = 0 - 0;
		while true do
			if ((v171 == (1109 - (67 + 1035))) or ((4967 - (136 + 212)) < (12246 - 9364))) then
				if ((v127(v101.LavaBeam) and v44 and (v130())) or ((236 + 58) >= (4454 + 377))) then
					if (((3633 - (240 + 1364)) <= (4166 - (1050 + 32))) and v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam))) then
						return "lava_beam aoe 68";
					end
				end
				if ((v127(v101.ChainLightning) and v37 and (v130())) or ((7273 - 5236) == (1432 + 988))) then
					if (((5513 - (331 + 724)) > (316 + 3588)) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning aoe 70";
					end
				end
				if (((1080 - (269 + 375)) >= (848 - (267 + 458))) and v127(v101.LavaBeam) and v44 and v129() and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) then
					if (((156 + 344) < (3492 - 1676)) and v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam))) then
						return "lava_beam aoe 72";
					end
				end
				if (((4392 - (667 + 151)) == (5071 - (1410 + 87))) and v127(v101.ChainLightning) and v37 and v129()) then
					if (((2118 - (1504 + 393)) < (1054 - 664)) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning aoe 74";
					end
				end
				v171 = 20 - 12;
			end
			if ((v171 == (805 - (461 + 335))) or ((283 + 1930) <= (3182 - (1730 + 31)))) then
				if (((4725 - (728 + 939)) < (17212 - 12352)) and v127(v101.LavaBurst) and (v115 == (5 - 2)) and v101.MasteroftheElements:IsAvailable()) then
					if (v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst)) or ((2969 - 1673) >= (5514 - (138 + 930)))) then
						return "lava_burst aoe 84";
					end
					if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((1273 + 120) > (3510 + 979))) then
						return "lava_burst aoe 84";
					end
				end
				if ((v127(v101.LavaBurst) and v14:BuffUp(v101.LavaSurgeBuff) and v101.DeeplyRootedElements:IsAvailable()) or ((3792 + 632) < (110 - 83))) then
					local v247 = 1766 - (459 + 1307);
					while true do
						if ((v247 == (1870 - (474 + 1396))) or ((3486 - 1489) > (3576 + 239))) then
							if (((12 + 3453) > (5479 - 3566)) and v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst aoe 86";
							end
							if (((93 + 640) < (6072 - 4253)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst aoe 86";
							end
							break;
						end
					end
				end
				if ((v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (0 - 0)) and v43 and v101.ElectrifiedShocks:IsAvailable() and (v115 < (596 - (562 + 29)))) or ((3747 + 648) == (6174 - (374 + 1045)))) then
					if (v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury)) or ((3002 + 791) < (7355 - 4986))) then
						return "icefury aoe 88";
					end
				end
				if ((v127(v101.FrostShock) and v42 and v14:BuffUp(v101.IcefuryBuff) and v101.ElectrifiedShocks:IsAvailable() and not v17:DebuffUp(v101.ElectrifiedShocksDebuff) and (v115 < (643 - (448 + 190))) and v101.UnrelentingCalamity:IsAvailable()) or ((1319 + 2765) == (120 + 145))) then
					if (((2840 + 1518) == (16755 - 12397)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock aoe 90";
					end
				end
				v171 = 31 - 21;
			end
			if (((1502 - (1307 + 187)) == v171) or ((12443 - 9305) < (2324 - 1331))) then
				if (((10210 - 6880) > (3006 - (232 + 451))) and v127(v101.LavaBeam) and v44 and (v115 >= (6 + 0)) and v14:BuffUp(v101.SurgeofPowerBuff) and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) then
					if (v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam)) or ((3204 + 422) == (4553 - (510 + 54)))) then
						return "lava_beam aoe 76";
					end
				end
				if ((v127(v101.ChainLightning) and v37 and (v115 >= (11 - 5)) and v14:BuffUp(v101.SurgeofPowerBuff)) or ((952 - (13 + 23)) == (5206 - 2535))) then
					if (((390 - 118) == (493 - 221)) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning aoe 78";
					end
				end
				if (((5337 - (830 + 258)) <= (17069 - 12230)) and v127(v101.LavaBurst) and v14:BuffUp(v101.LavaSurgeBuff) and v101.DeeplyRootedElements:IsAvailable() and v14:BuffUp(v101.WindspeakersLavaResurgenceBuff)) then
					local v248 = 0 + 0;
					while true do
						if (((2363 + 414) < (4641 - (860 + 581))) and (v248 == (0 - 0))) then
							if (((76 + 19) < (2198 - (237 + 4))) and v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst aoe 80";
							end
							if (((1940 - 1114) < (4344 - 2627)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst aoe 80";
							end
							break;
						end
					end
				end
				if (((2703 - 1277) >= (905 + 200)) and v127(v101.LavaBeam) and v44 and v128() and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) then
					if (((1582 + 1172) <= (12756 - 9377)) and v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam))) then
						return "lava_beam aoe 82";
					end
				end
				v171 = 4 + 5;
			end
			if ((v171 == (6 + 4)) or ((5353 - (85 + 1341)) == (2410 - 997))) then
				if ((v127(v101.LavaBeam) and v44 and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) or ((3259 - 2105) <= (1160 - (45 + 327)))) then
					if (v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam)) or ((3100 - 1457) > (3881 - (444 + 58)))) then
						return "lava_beam aoe 92";
					end
				end
				if ((v127(v101.ChainLightning) and v37) or ((1219 + 1584) > (783 + 3766))) then
					if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((108 + 112) >= (8757 - 5735))) then
						return "chain_lightning aoe 94";
					end
				end
				if (((4554 - (64 + 1668)) == (4795 - (1227 + 746))) and v101.FlameShock:IsCastable() and v41 and v14:IsMoving() and v17:DebuffRefreshable(v101.FlameShockDebuff)) then
					if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((3261 - 2200) == (3445 - 1588))) then
						return "flame_shock aoe 96";
					end
				end
				if (((3254 - (415 + 79)) > (36 + 1328)) and v101.FrostShock:IsCastable() and v42 and v14:IsMoving()) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((5393 - (142 + 349)) <= (1541 + 2054))) then
						return "frost_shock aoe 98";
					end
				end
				break;
			end
			if ((v171 == (7 - 1)) or ((1915 + 1937) == (207 + 86))) then
				if ((v127(v101.EarthShock) and v39 and v101.EchoesofGreatSundering:IsAvailable()) or ((4245 - 2686) == (6452 - (1710 + 154)))) then
					if (v25(v101.EarthShock, not v17:IsSpellInRange(v101.EarthShock)) or ((4802 - (200 + 118)) == (313 + 475))) then
						return "earth_shock aoe 60";
					end
				end
				if (((7986 - 3418) >= (5794 - 1887)) and v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (0 + 0)) and v43 and not v14:BuffUp(v101.AscendanceBuff) and v101.ElectrifiedShocks:IsAvailable() and ((v101.LightningRod:IsAvailable() and (v115 < (5 + 0)) and not v128()) or (v101.DeeplyRootedElements:IsAvailable() and (v115 == (2 + 1))))) then
					if (((199 + 1047) < (7517 - 4047)) and v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury))) then
						return "icefury aoe 62";
					end
				end
				if (((5318 - (363 + 887)) >= (1696 - 724)) and v127(v101.FrostShock) and v42 and not v14:BuffUp(v101.AscendanceBuff) and v14:BuffUp(v101.IcefuryBuff) and v101.ElectrifiedShocks:IsAvailable() and (not v17:DebuffUp(v101.ElectrifiedShocksDebuff) or (v14:BuffRemains(v101.IcefuryBuff) < v14:GCD())) and ((v101.LightningRod:IsAvailable() and (v115 < (23 - 18)) and not v128()) or (v101.DeeplyRootedElements:IsAvailable() and (v115 == (1 + 2))))) then
					if (((1153 - 660) < (2661 + 1232)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock aoe 64";
					end
				end
				if ((v127(v101.LavaBurst) and v101.MasteroftheElements:IsAvailable() and not v128() and (v130() or ((v119() < (1667 - (674 + 990))) and v14:HasTier(9 + 21, 1 + 1))) and (v126() < ((((95 - 35) - ((1060 - (507 + 548)) * v101.EyeoftheStorm:TalentRank())) - ((839 - (289 + 548)) * v26(v101.FlowofPower:IsAvailable()))) - (1828 - (821 + 997)))) and (v115 < (260 - (195 + 60)))) or ((397 + 1076) >= (4833 - (251 + 1250)))) then
					if (v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst)) or ((11867 - 7816) <= (795 + 362))) then
						return "lava_burst aoe 66";
					end
					if (((1636 - (809 + 223)) < (4204 - 1323)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 66";
					end
				end
				v171 = 20 - 13;
			end
			if ((v171 == (9 - 6)) or ((663 + 237) == (1769 + 1608))) then
				if (((5076 - (14 + 603)) > (720 - (118 + 11))) and v38 and v101.Earthquake:IsReady() and v128() and (((v14:BuffStack(v101.MagmaChamberBuff) > (3 + 12)) and (v115 >= ((6 + 1) - v26(v101.UnrelentingCalamity:IsAvailable())))) or (v101.SplinteredElements:IsAvailable() and (v115 >= ((29 - 19) - v26(v101.UnrelentingCalamity:IsAvailable())))) or (v101.MountainsWillFall:IsAvailable() and (v115 >= (958 - (551 + 398))))) and not v101.LightningRod:IsAvailable() and v14:HasTier(20 + 11, 2 + 2)) then
					local v249 = 0 + 0;
					while true do
						if (((12637 - 9239) >= (5518 - 3123)) and (v249 == (0 + 0))) then
							if ((v52 == "cursor") or ((8666 - 6483) >= (780 + 2044))) then
								if (((2025 - (40 + 49)) == (7372 - 5436)) and v25(v103.EarthquakeCursor, not v17:IsInRange(530 - (99 + 391)))) then
									return "earthquake aoe 36";
								end
							end
							if ((v52 == "player") or ((3997 + 835) < (18959 - 14646))) then
								if (((10123 - 6035) > (3774 + 100)) and v25(v103.EarthquakePlayer, not v17:IsInRange(105 - 65))) then
									return "earthquake aoe 36";
								end
							end
							break;
						end
					end
				end
				if (((5936 - (1032 + 572)) == (4749 - (203 + 214))) and v127(v101.LavaBeam) and v44 and v130() and ((v14:BuffUp(v101.SurgeofPowerBuff) and (v115 >= (1823 - (568 + 1249)))) or (v128() and ((v115 < (5 + 1)) or not v101.SurgeofPower:IsAvailable()))) and not v101.LightningRod:IsAvailable() and v14:HasTier(74 - 43, 15 - 11)) then
					if (((5305 - (913 + 393)) >= (8189 - 5289)) and v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam))) then
						return "lava_beam aoe 38";
					end
				end
				if ((v127(v101.ChainLightning) and v37 and v130() and ((v14:BuffUp(v101.SurgeofPowerBuff) and (v115 >= (7 - 1))) or (v128() and ((v115 < (416 - (269 + 141))) or not v101.SurgeofPower:IsAvailable()))) and not v101.LightningRod:IsAvailable() and v14:HasTier(68 - 37, 1985 - (362 + 1619))) or ((4150 - (950 + 675)) > (1567 + 2497))) then
					if (((5550 - (216 + 963)) == (5658 - (485 + 802))) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning aoe 40";
					end
				end
				if ((v127(v101.LavaBurst) and v14:BuffUp(v101.LavaSurgeBuff) and not v101.LightningRod:IsAvailable() and v14:HasTier(590 - (432 + 127), 1077 - (1065 + 8))) or ((148 + 118) > (6587 - (635 + 966)))) then
					if (((1432 + 559) >= (967 - (5 + 37))) and v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 42";
					end
					if (((1131 - 676) < (855 + 1198)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 42";
					end
				end
				v171 = 5 - 1;
			end
			if ((v171 == (2 + 2)) or ((1715 - 889) == (18391 - 13540))) then
				if (((344 - 161) == (437 - 254)) and v127(v101.LavaBurst) and v14:BuffUp(v101.LavaSurgeBuff) and v101.MasteroftheElements:IsAvailable() and not v128() and (v126() >= (((44 + 16) - ((534 - (318 + 211)) * v101.EyeoftheStorm:TalentRank())) - ((9 - 7) * v26(v101.FlowofPower:IsAvailable())))) and ((not v101.EchoesofGreatSundering:IsAvailable() and not v101.LightningRod:IsAvailable()) or v14:BuffUp(v101.EchoesofGreatSunderingBuff)) and ((not v14:BuffUp(v101.AscendanceBuff) and (v115 > (1590 - (963 + 624))) and v101.UnrelentingCalamity:IsAvailable()) or ((v115 > (2 + 1)) and not v101.UnrelentingCalamity:IsAvailable()) or (v115 == (849 - (518 + 328))))) then
					local v250 = 0 - 0;
					while true do
						if (((1851 - 692) <= (2105 - (301 + 16))) and (v250 == (0 - 0))) then
							if (v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst)) or ((9849 - 6342) > (11267 - 6949))) then
								return "lava_burst aoe 44";
							end
							if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((2786 + 289) <= (1684 + 1281))) then
								return "lava_burst aoe 44";
							end
							break;
						end
					end
				end
				if (((2913 - 1548) <= (1210 + 801)) and v38 and v101.Earthquake:IsReady() and not v101.EchoesofGreatSundering:IsAvailable() and (v115 > (1 + 2)) and ((v115 > (9 - 6)) or (v114 > (1 + 2)))) then
					local v251 = 1019 - (829 + 190);
					while true do
						if (((0 - 0) == v251) or ((3512 - 736) > (4941 - 1366))) then
							if ((v52 == "cursor") or ((6344 - 3790) == (1139 + 3665))) then
								if (((842 + 1735) == (7821 - 5244)) and v25(v103.EarthquakeCursor, not v17:IsInRange(38 + 2))) then
									return "earthquake aoe 46";
								end
							end
							if ((v52 == "player") or ((619 - (520 + 93)) >= (2165 - (259 + 17)))) then
								if (((30 + 476) <= (681 + 1211)) and v25(v103.EarthquakePlayer, not v17:IsInRange(135 - 95))) then
									return "earthquake aoe 46";
								end
							end
							break;
						end
					end
				end
				if ((v38 and v101.Earthquake:IsReady() and not v101.EchoesofGreatSundering:IsAvailable() and not v101.ElementalBlast:IsAvailable() and (v115 == (594 - (396 + 195))) and ((v115 == (8 - 5)) or (v114 == (1764 - (440 + 1321))))) or ((3837 - (1059 + 770)) > (10256 - 8038))) then
					local v252 = 545 - (424 + 121);
					while true do
						if (((70 + 309) <= (5494 - (641 + 706))) and (v252 == (0 + 0))) then
							if ((v52 == "cursor") or ((4954 - (249 + 191)) <= (4395 - 3386))) then
								if (v25(v103.EarthquakeCursor, not v17:IsInRange(18 + 22)) or ((13474 - 9978) == (1619 - (183 + 244)))) then
									return "earthquake aoe 48";
								end
							end
							if ((v52 == "player") or ((11 + 197) == (3689 - (434 + 296)))) then
								if (((13648 - 9371) >= (1825 - (169 + 343))) and v25(v103.EarthquakePlayer, not v17:IsInRange(36 + 4))) then
									return "earthquake aoe 48";
								end
							end
							break;
						end
					end
				end
				if (((4551 - 1964) < (9316 - 6142)) and v38 and v101.Earthquake:IsReady() and (v14:BuffUp(v101.EchoesofGreatSunderingBuff))) then
					if ((v52 == "cursor") or ((3376 + 744) <= (6233 - 4035))) then
						if (v25(v103.EarthquakeCursor, not v17:IsInRange(1163 - (651 + 472))) or ((1207 + 389) == (371 + 487))) then
							return "earthquake aoe 50";
						end
					end
					if (((3929 - 709) == (3703 - (397 + 86))) and (v52 == "player")) then
						if (v25(v103.EarthquakePlayer, not v17:IsInRange(916 - (423 + 453))) or ((143 + 1259) > (478 + 3142))) then
							return "earthquake aoe 50";
						end
					end
				end
				v171 = 5 + 0;
			end
			if (((2055 + 519) == (2300 + 274)) and (v171 == (1191 - (50 + 1140)))) then
				if (((1555 + 243) < (1628 + 1129)) and v101.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v34) or not v62) and (v91 < v109) and (v67 == "cursor")) then
					if (v25(v103.LiquidMagmaTotemCursor, not v17:IsInRange(3 + 37)) or ((541 - 164) > (1885 + 719))) then
						return "liquid_magma_totem aoe cursor 10";
					end
				end
				if (((1164 - (157 + 439)) < (1583 - 672)) and v101.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v34) or not v62) and (v91 < v109) and (v67 == "player")) then
					if (((10915 - 7630) < (12506 - 8278)) and v25(v103.LiquidMagmaTotemPlayer, not v17:IsInRange(958 - (782 + 136)))) then
						return "liquid_magma_totem aoe player 11";
					end
				end
				if (((4771 - (112 + 743)) > (4499 - (1026 + 145))) and v127(v101.PrimordialWave) and v14:BuffDown(v101.PrimordialWaveBuff) and v14:BuffUp(v101.SurgeofPowerBuff) and v14:BuffDown(v101.SplinteredElementsBuff)) then
					local v253 = 0 + 0;
					while true do
						if (((3218 - (493 + 225)) < (14110 - 10271)) and (v253 == (0 + 0))) then
							if (((1359 - 852) == (10 + 497)) and v105.CastTargetIf(v101.PrimordialWave, v113, "min", v123, nil, not v17:IsSpellInRange(v101.PrimordialWave), nil, nil)) then
								return "primordial_wave aoe 12";
							end
							if (((685 - 445) <= (922 + 2243)) and v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave))) then
								return "primordial_wave aoe 12";
							end
							break;
						end
					end
				end
				if (((1393 - 559) >= (2400 - (210 + 1385))) and v127(v101.PrimordialWave) and v14:BuffDown(v101.PrimordialWaveBuff) and v101.DeeplyRootedElements:IsAvailable() and not v101.SurgeofPower:IsAvailable() and v14:BuffDown(v101.SplinteredElementsBuff)) then
					local v254 = 1689 - (1201 + 488);
					while true do
						if ((v254 == (0 + 0)) or ((6779 - 2967) < (4153 - 1837))) then
							if (v105.CastTargetIf(v101.PrimordialWave, v113, "min", v123, nil, not v17:IsSpellInRange(v101.PrimordialWave), nil, nil) or ((3237 - (352 + 233)) <= (3704 - 2171))) then
								return "primordial_wave aoe 14";
							end
							if (v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave)) or ((1958 + 1640) < (4151 - 2691))) then
								return "primordial_wave aoe 14";
							end
							break;
						end
					end
				end
				v171 = 576 - (489 + 85);
			end
			if ((v171 == (1506 - (277 + 1224))) or ((5609 - (663 + 830)) < (1048 + 144))) then
				if ((v127(v101.ElementalBlast) and v40 and v101.EchoesofGreatSundering:IsAvailable()) or ((8269 - 4892) <= (1778 - (461 + 414)))) then
					if (((667 + 3309) >= (176 + 263)) and v105.CastTargetIf(v101.ElementalBlast, v113, "min", v125, nil, not v17:IsSpellInRange(v101.ElementalBlast), nil, nil)) then
						return "elemental_blast aoe 52";
					end
					if (((358 + 3394) == (3699 + 53)) and v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast aoe 52";
					end
				end
				if (((4296 - (172 + 78)) > (4345 - 1650)) and v127(v101.ElementalBlast) and v40 and v101.EchoesofGreatSundering:IsAvailable()) then
					if (v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast)) or ((1305 + 2240) == (4613 - 1416))) then
						return "elemental_blast aoe 54";
					end
				end
				if (((653 + 1741) > (125 + 248)) and v127(v101.ElementalBlast) and v40 and (v115 == (4 - 1)) and not v101.EchoesofGreatSundering:IsAvailable()) then
					if (((5230 - 1075) <= (1064 + 3168)) and v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast aoe 56";
					end
				end
				if ((v127(v101.EarthShock) and v39 and v101.EchoesofGreatSundering:IsAvailable()) or ((1981 + 1600) == (1237 + 2236))) then
					local v255 = 0 - 0;
					while true do
						if (((11637 - 6642) > (1027 + 2321)) and ((0 + 0) == v255)) then
							if (v105.CastTargetIf(v101.EarthShock, v113, "min", v125, nil, not v17:IsSpellInRange(v101.EarthShock), nil, nil) or ((1201 - (133 + 314)) > (648 + 3076))) then
								return "earth_shock aoe 58";
							end
							if (((430 - (199 + 14)) >= (204 - 147)) and v25(v101.EarthShock, not v17:IsSpellInRange(v101.EarthShock))) then
								return "earth_shock aoe 58";
							end
							break;
						end
					end
				end
				v171 = 1555 - (647 + 902);
			end
			if (((5 - 3) == v171) or ((2303 - (85 + 148)) >= (5326 - (426 + 863)))) then
				if (((12659 - 9954) == (4359 - (873 + 781))) and v127(v101.PrimordialWave) and v14:BuffDown(v101.PrimordialWaveBuff) and v101.MasteroftheElements:IsAvailable() and not v101.LightningRod:IsAvailable()) then
					local v256 = 0 - 0;
					while true do
						if (((164 - 103) == (26 + 35)) and (v256 == (0 - 0))) then
							if (v105.CastTargetIf(v101.PrimordialWave, v113, "min", v123, nil, not v17:IsSpellInRange(v101.PrimordialWave), nil, nil) or ((1001 - 302) >= (3848 - 2552))) then
								return "primordial_wave aoe 16";
							end
							if (v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave)) or ((3730 - (414 + 1533)) >= (3136 + 480))) then
								return "primordial_wave aoe 16";
							end
							break;
						end
					end
				end
				if (v101.FlameShock:IsCastable() or ((4468 - (443 + 112)) > (6006 - (888 + 591)))) then
					local v257 = 0 - 0;
					while true do
						if (((250 + 4126) > (3077 - 2260)) and ((2 + 1) == v257)) then
							if (((2352 + 2509) > (89 + 735)) and v101.DeeplyRootedElements:IsAvailable() and v41 and not v101.SurgeofPower:IsAvailable()) then
								local v280 = 0 - 0;
								while true do
									if (((0 - 0) == v280) or ((3061 - (136 + 1542)) >= (6987 - 4856))) then
										if (v105.CastCycle(v101.FlameShock, v113, v122, not v17:IsSpellInRange(v101.FlameShock)) or ((1862 + 14) >= (4040 - 1499))) then
											return "flame_shock aoe 30";
										end
										if (((1290 + 492) <= (4258 - (68 + 418))) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 30";
										end
										break;
									end
								end
							end
							break;
						end
						if ((v257 == (0 - 0)) or ((8527 - 3827) < (702 + 111))) then
							if (((4291 - (770 + 322)) < (234 + 3816)) and v14:BuffUp(v101.SurgeofPowerBuff) and v41 and v101.LightningRod:IsAvailable() and v101.WindspeakersLavaResurgence:IsAvailable() and (v17:DebuffRemains(v101.FlameShockDebuff) < (v17:TimeToDie() - (5 + 11))) and (v112 < (1 + 4))) then
								if (v105.CastCycle(v101.FlameShock, v113, v121, not v17:IsSpellInRange(v101.FlameShock)) or ((7083 - 2132) < (8589 - 4159))) then
									return "flame_shock aoe 18";
								end
								if (((260 - 164) == (352 - 256)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
									return "flame_shock aoe 18";
								end
							end
							if ((v14:BuffUp(v101.SurgeofPowerBuff) and v41 and (not v101.LightningRod:IsAvailable() or v101.SkybreakersFieryDemise:IsAvailable()) and (v101.FlameShockDebuff:AuraActiveCount() < (4 + 2))) or ((4103 - 1364) > (1923 + 2085))) then
								local v281 = 0 + 0;
								while true do
									if ((v281 == (0 + 0)) or ((86 - 63) == (1574 - 440))) then
										if (v105.CastCycle(v101.FlameShock, v113, v121, not v17:IsSpellInRange(v101.FlameShock)) or ((911 + 1782) >= (18937 - 14826))) then
											return "flame_shock aoe 20";
										end
										if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((14267 - 9951) <= (883 + 1263))) then
											return "flame_shock aoe 20";
										end
										break;
									end
								end
							end
							v257 = 4 - 3;
						end
						if (((832 - (762 + 69)) == v257) or ((11482 - 7936) <= (2421 + 388))) then
							if (((3175 + 1729) > (5238 - 3072)) and v101.MasteroftheElements:IsAvailable() and v41 and not v101.LightningRod:IsAvailable() and (v101.FlameShockDebuff:AuraActiveCount() < (2 + 4))) then
								local v282 = 0 + 0;
								while true do
									if (((424 - 315) >= (247 - (8 + 149))) and (v282 == (1320 - (1199 + 121)))) then
										if (((8423 - 3445) > (6558 - 3653)) and v105.CastCycle(v101.FlameShock, v113, v121, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 22";
										end
										if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((1246 + 1780) <= (8138 - 5858))) then
											return "flame_shock aoe 22";
										end
										break;
									end
								end
							end
							if ((v101.DeeplyRootedElements:IsAvailable() and v41 and not v101.SurgeofPower:IsAvailable() and (v101.FlameShockDebuff:AuraActiveCount() < (13 - 7))) or ((1463 + 190) <= (2915 - (518 + 1289)))) then
								local v283 = 0 - 0;
								while true do
									if (((387 + 2522) > (3809 - 1200)) and (v283 == (0 + 0))) then
										if (((1226 - (304 + 165)) > (184 + 10)) and v105.CastCycle(v101.FlameShock, v113, v121, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 24";
										end
										if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((191 - (54 + 106)) >= (3367 - (1618 + 351)))) then
											return "flame_shock aoe 24";
										end
										break;
									end
								end
							end
							v257 = 2 + 0;
						end
						if (((4212 - (10 + 1006)) <= (1223 + 3649)) and (v257 == (1 + 1))) then
							if (((10782 - 7456) == (4359 - (912 + 121))) and v14:BuffUp(v101.SurgeofPowerBuff) and v41 and (not v101.LightningRod:IsAvailable() or v101.SkybreakersFieryDemise:IsAvailable())) then
								local v284 = 0 + 0;
								while true do
									if (((2722 - (1140 + 149)) <= (2482 + 1396)) and (v284 == (0 - 0))) then
										if (v105.CastCycle(v101.FlameShock, v113, v122, not v17:IsSpellInRange(v101.FlameShock)) or ((295 + 1288) == (5937 - 4202))) then
											return "flame_shock aoe 26";
										end
										if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((5590 - 2609) == (406 + 1944))) then
											return "flame_shock aoe 26";
										end
										break;
									end
								end
							end
							if ((v101.MasteroftheElements:IsAvailable() and v41 and not v101.LightningRod:IsAvailable() and not v101.SurgeofPower:IsAvailable()) or ((15497 - 11031) <= (679 - (165 + 21)))) then
								local v285 = 111 - (61 + 50);
								while true do
									if (((0 + 0) == v285) or ((12139 - 9592) <= (4003 - 2016))) then
										if (((1164 + 1797) > (4200 - (1295 + 165))) and v105.CastCycle(v101.FlameShock, v113, v122, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 28";
										end
										if (((844 + 2852) >= (1453 + 2159)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 28";
										end
										break;
									end
								end
							end
							v257 = 1400 - (819 + 578);
						end
					end
				end
				if ((v101.Ascendance:IsCastable() and v53 and ((v59 and v34) or not v59) and (v91 < v109)) or ((4372 - (331 + 1071)) == (2621 - (588 + 155)))) then
					if (v25(v101.Ascendance) or ((4975 - (546 + 736)) < (3914 - (1834 + 103)))) then
						return "ascendance aoe 32";
					end
				end
				if ((v127(v101.LavaBurst) and (v115 == (2 + 1)) and not v101.LightningRod:IsAvailable() and v14:HasTier(92 - 61, 1770 - (1536 + 230))) or ((1421 - (128 + 363)) > (447 + 1654))) then
					if (((10331 - 6178) > (798 + 2288)) and v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 34";
					end
					if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((7710 - 3056) <= (11922 - 7872))) then
						return "lava_burst aoe 34";
					end
				end
				v171 = 7 - 4;
			end
			if ((v171 == (0 + 0)) or ((3611 - (615 + 394)) < (1351 + 145))) then
				if ((v101.FireElemental:IsReady() and v54 and ((v60 and v34) or not v60) and (v91 < v109)) or ((973 + 47) > (6974 - 4686))) then
					if (((1487 - 1159) == (979 - (59 + 592))) and v25(v101.FireElemental)) then
						return "fire_elemental aoe 2";
					end
				end
				if (((3345 - 1834) < (7012 - 3204)) and v101.StormElemental:IsReady() and v56 and ((v61 and v34) or not v61) and (v91 < v109)) then
					if (v25(v101.StormElemental) or ((1769 + 741) > (5090 - (70 + 101)))) then
						return "storm_elemental aoe 4";
					end
				end
				if (((11774 - 7011) == (3378 + 1385)) and v127(v101.Stormkeeper) and not v130() and v49 and ((v66 and v35) or not v66) and (v91 < v109)) then
					if (((10390 - 6253) > (2089 - (123 + 118))) and v25(v101.Stormkeeper)) then
						return "stormkeeper aoe 7";
					end
				end
				if (((590 + 1846) <= (39 + 3095)) and v101.TotemicRecall:IsCastable() and (v101.LiquidMagmaTotem:CooldownRemains() > (1444 - (653 + 746))) and v50) then
					if (((6962 - 3239) == (5363 - 1640)) and v25(v101.TotemicRecall)) then
						return "totemic_recall aoe 8";
					end
				end
				v171 = 2 - 1;
			end
		end
	end
	local function v139()
		local v172 = 0 + 0;
		while true do
			if ((v172 == (8 + 3)) or ((3534 + 512) >= (529 + 3787))) then
				if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v129() and v101.UnrelentingCalamity:IsAvailable()) or ((314 + 1694) < (4728 - 2799))) then
					if (((2270 + 114) > (3278 - 1503)) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
						return "lightning_bolt single_target 90";
					end
				end
				if ((v127(v101.Icefury) and v101.Icefury:IsCastable() and v43) or ((5777 - (885 + 349)) <= (3476 + 900))) then
					if (((1985 - 1257) == (2117 - 1389)) and v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury))) then
						return "icefury single_target 92";
					end
				end
				if ((v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v101.LightningRodDebuff) and (v17:DebuffUp(v101.ElectrifiedShocksDebuff) or v129()) and (v114 > (969 - (915 + 53))) and (v115 > (802 - (768 + 33)))) or ((4119 - 3043) > (8222 - 3551))) then
					if (((2179 - (287 + 41)) >= (1225 - (638 + 209))) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning single_target 94";
					end
				end
				if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v101.LightningRodDebuff) and (v17:DebuffUp(v101.ElectrifiedShocksDebuff) or v129())) or ((1013 + 935) >= (5162 - (96 + 1590)))) then
					if (((6466 - (741 + 931)) >= (410 + 423)) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
						return "lightning_bolt single_target 96";
					end
				end
				v172 = 34 - 22;
			end
			if (((19107 - 15017) == (1755 + 2335)) and ((6 + 6) == v172)) then
				if ((v101.FrostShock:IsCastable() and v42 and v131() and v128() and v14:BuffDown(v101.LavaSurgeBuff) and not v101.ElectrifiedShocks:IsAvailable() and not v101.FluxMelting:IsAvailable() and (v101.LavaBurst:ChargesFractional() < (1 + 0)) and v101.EchooftheElements:IsAvailable()) or ((14260 - 10502) == (812 + 1686))) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((1306 + 1367) < (6424 - 4849))) then
						return "frost_shock single_target 98";
					end
				end
				if ((v101.FrostShock:IsCastable() and v42 and v131() and (v101.FluxMelting:IsAvailable() or (v101.ElectrifiedShocks:IsAvailable() and not v101.LightningRod:IsAvailable()))) or ((3340 + 381) <= (1949 - (64 + 430)))) then
					if (((927 + 7) < (2633 - (106 + 257))) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single_target 100";
					end
				end
				if ((v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and v128() and v14:BuffDown(v101.LavaSurgeBuff) and (v101.LavaBurst:ChargesFractional() < (1 + 0)) and v101.EchooftheElements:IsAvailable() and (v114 > (722 - (496 + 225))) and (v115 > (1 - 0))) or ((7852 - 6240) == (2913 - (256 + 1402)))) then
					if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((6251 - (30 + 1869)) < (5575 - (213 + 1156)))) then
						return "chain_lightning single_target 102";
					end
				end
				if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v128() and v14:BuffDown(v101.LavaSurgeBuff) and (v101.LavaBurst:ChargesFractional() < (189 - (96 + 92))) and v101.EchooftheElements:IsAvailable()) or ((488 + 2372) <= (1080 - (142 + 757)))) then
					if (((2625 + 597) >= (625 + 902)) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
						return "lightning_bolt single_target 104";
					end
				end
				v172 = 92 - (32 + 47);
			end
			if (((3482 - (1053 + 924)) <= (2078 + 43)) and (v172 == (17 - 7))) then
				if (((2392 - (685 + 963)) == (1512 - 768)) and v101.FrostShock:IsCastable() and v42 and v131() and ((v101.ElectrifiedShocks:IsAvailable() and (v17:DebuffRemains(v101.ElectrifiedShocksDebuff) < (2 - 0))) or (v14:BuffRemains(v101.IcefuryBuff) < (1715 - (541 + 1168))))) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((3576 - (645 + 952)) >= (3674 - (669 + 169)))) then
						return "frost_shock single_target 82";
					end
				end
				if (((6349 - 4516) <= (5793 - 3125)) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and (v101.EchooftheElements:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.PrimordialSurge:IsAvailable() or not v101.ElementalBlast:IsAvailable() or not v101.MasteroftheElements:IsAvailable() or v130())) then
					local v258 = 0 + 0;
					while true do
						if (((813 + 2873) == (4451 - (181 + 584))) and ((1395 - (665 + 730)) == v258)) then
							if (((9991 - 6524) > (972 - 495)) and v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst single_target 84";
							end
							if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((4638 - (540 + 810)) >= (14157 - 10616))) then
								return "lava_burst single_target 84";
							end
							break;
						end
					end
				end
				if ((v127(v101.ElementalBlast) and v101.ElementalBlast:IsCastable() and v40) or ((9779 - 6222) == (3613 + 927))) then
					if (v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast)) or ((464 - (166 + 37)) > (3148 - (22 + 1859)))) then
						return "elemental_blast single_target 86";
					end
				end
				if (((3044 - (843 + 929)) < (4120 - (30 + 232))) and v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and v129() and v101.UnrelentingCalamity:IsAvailable() and (v114 > (2 - 1)) and (v115 > (778 - (55 + 722)))) then
					if (((7864 - 4200) == (5339 - (78 + 1597))) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning single_target 88";
					end
				end
				v172 = 3 + 8;
			end
			if (((1766 + 175) >= (377 + 73)) and (v172 == (556 - (305 + 244)))) then
				if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v14:BuffDown(v101.AscendanceBuff) and (not v101.ElementalBlast:IsAvailable() or not v101.MountainsWillFall:IsAvailable()) and not v101.LightningRod:IsAvailable() and v14:HasTier(29 + 2, 109 - (95 + 10))) or ((3290 + 1356) < (1026 - 702))) then
					local v259 = 0 - 0;
					while true do
						if (((4595 - (592 + 170)) == (13368 - 9535)) and (v259 == (0 - 0))) then
							if (v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst)) or ((579 + 661) > (1312 + 2058))) then
								return "lava_burst single_target 58";
							end
							if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((5991 - 3510) == (760 + 3922))) then
								return "lava_burst single_target 58";
							end
							break;
						end
					end
				end
				if (((8760 - 4033) >= (715 - (353 + 154))) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v101.MasteroftheElements:IsAvailable() and not v128() and not v101.LightningRod:IsAvailable()) then
					local v260 = 0 - 0;
					while true do
						if (((382 - 102) < (2658 + 1193)) and (v260 == (0 + 0))) then
							if (v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst)) or ((1985 + 1022) > (4615 - 1421))) then
								return "lava_burst single_target 60";
							end
							if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((4043 - 1907) >= (6867 - 3921))) then
								return "lava_burst single_target 60";
							end
							break;
						end
					end
				end
				if (((2251 - (7 + 79)) <= (1180 + 1341)) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v101.MasteroftheElements:IsAvailable() and not v128() and ((v126() >= (256 - (24 + 157))) or ((v126() >= (99 - 49)) and not v101.ElementalBlast:IsAvailable())) and v101.SwellingMaelstrom:IsAvailable() and (v126() <= (277 - 147))) then
					if (((813 + 2048) > (1780 - 1119)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst single_target 62";
					end
				end
				if (((4905 - (262 + 118)) > (5602 - (1038 + 45))) and v101.Earthquake:IsReady() and v38 and v14:BuffUp(v101.EchoesofGreatSunderingBuff) and ((not v101.ElementalBlast:IsAvailable() and (v114 < (3 - 1))) or (v114 > (231 - (19 + 211))))) then
					if (((3291 - (88 + 25)) > (2474 - 1502)) and (v52 == "cursor")) then
						if (((2366 + 2400) == (4449 + 317)) and v25(v103.EarthquakeCursor, not v17:IsInRange(1076 - (1007 + 29)))) then
							return "earthquake single_target 64";
						end
					end
					if ((v52 == "player") or ((740 + 2005) > (7645 - 4517))) then
						if (v25(v103.EarthquakePlayer, not v17:IsInRange(189 - 149)) or ((255 + 889) >= (5417 - (340 + 471)))) then
							return "earthquake single_target 64";
						end
					end
				end
				v172 = 19 - 11;
			end
			if (((3927 - (276 + 313)) >= (676 - 399)) and (v172 == (4 + 0))) then
				if (((1107 + 1503) > (240 + 2320)) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v130() and not v101.SurgeofPower:IsAvailable() and v128()) then
					if (v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt)) or ((3166 - (495 + 1477)) > (9230 - 6147))) then
						return "lightning_bolt single_target 34";
					end
				end
				if (((601 + 315) >= (1150 - (342 + 61))) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v130() and not v101.SurgeofPower:IsAvailable() and not v101.MasteroftheElements:IsAvailable()) then
					if (v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt)) or ((1069 + 1375) > (3119 - (4 + 161)))) then
						return "lightning_bolt single_target 36";
					end
				end
				if (((1771 + 1121) < (11030 - 7516)) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v14:BuffUp(v101.SurgeofPowerBuff) and v101.LightningRod:IsAvailable()) then
					if (((1400 - 867) == (1030 - (322 + 175))) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
						return "lightning_bolt single_target 38";
					end
				end
				if (((1158 - (173 + 390)) <= (842 + 2571)) and v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (314 - (203 + 111))) and v43 and v101.ElectrifiedShocks:IsAvailable() and v101.LightningRod:IsAvailable() and v101.LightningRod:IsAvailable()) then
					if (((191 + 2887) >= (1828 + 763)) and v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury))) then
						return "icefury single_target 40";
					end
				end
				v172 = 14 - 9;
			end
			if (((2890 + 309) < (4736 - (57 + 649))) and (v172 == (385 - (328 + 56)))) then
				if (((249 + 528) < (2590 - (433 + 79))) and v127(v101.PrimordialWave) and v101.PrimordialWave:IsCastable() and v48 and ((v65 and v35) or not v65) and not v14:BuffUp(v101.PrimordialWaveBuff) and not v14:BuffUp(v101.SplinteredElementsBuff)) then
					if (((156 + 1540) <= (1843 + 439)) and v105.CastCycle(v101.PrimordialWave, v113, v123, not v17:IsSpellInRange(v101.PrimordialWave))) then
						return "primordial_wave single_target 10";
					end
					if (v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave)) or ((5921 - 4160) >= (11642 - 9180))) then
						return "primordial_wave single_target 10";
					end
				end
				if (((3319 + 1232) > (2074 + 254)) and v101.FlameShock:IsCastable() and v41 and (v114 == (1037 - (562 + 474))) and v17:DebuffRefreshable(v101.FlameShockDebuff) and ((v17:DebuffRemains(v101.FlameShockDebuff) < v101.PrimordialWave:CooldownRemains()) or not v101.PrimordialWave:IsAvailable()) and v14:BuffDown(v101.SurgeofPowerBuff) and (not v128() or (not v130() and ((v101.ElementalBlast:IsAvailable() and (v126() < ((209 - 119) - ((15 - 7) * v101.EyeoftheStorm:TalentRank())))) or (v126() < ((965 - (76 + 829)) - ((1678 - (1506 + 167)) * v101.EyeoftheStorm:TalentRank()))))))) then
					if (((7185 - 3360) >= (733 - (58 + 208))) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock single_target 12";
					end
				end
				if ((v101.FlameShock:IsCastable() and v41 and (v101.FlameShockDebuff:AuraActiveCount() == (0 + 0)) and (v114 > (1 + 0)) and (v115 > (1 + 0)) and (v101.DeeplyRootedElements:IsAvailable() or v101.Ascendance:IsAvailable() or v101.PrimordialWave:IsAvailable() or v101.SearingFlames:IsAvailable() or v101.MagmaChamber:IsAvailable()) and ((not v128() and (v130() or (v101.Stormkeeper:CooldownRemains() > (0 - 0)))) or not v101.SurgeofPower:IsAvailable())) or ((3227 - (258 + 79)) == (71 + 486))) then
					local v261 = 0 - 0;
					while true do
						if ((v261 == (1470 - (1219 + 251))) or ((6441 - (1231 + 440)) == (2962 - (34 + 24)))) then
							if (v105.CastTargetIf(v101.FlameShock, v113, "min", v123, nil, not v17:IsSpellInRange(v101.FlameShock)) or ((2264 + 1639) == (8466 - 3930))) then
								return "flame_shock single_target 14";
							end
							if (((1789 + 2304) <= (14715 - 9870)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
								return "flame_shock single_target 14";
							end
							break;
						end
					end
				end
				if (((5029 - 3460) <= (9588 - 5941)) and v101.FlameShock:IsCastable() and v41 and (v114 > (3 - 2)) and (v115 > (2 - 1)) and (v101.DeeplyRootedElements:IsAvailable() or v101.Ascendance:IsAvailable() or v101.PrimordialWave:IsAvailable() or v101.SearingFlames:IsAvailable() or v101.MagmaChamber:IsAvailable()) and ((v14:BuffUp(v101.SurgeofPowerBuff) and not v130() and v101.Stormkeeper:IsAvailable()) or not v101.SurgeofPower:IsAvailable())) then
					local v262 = 1589 - (877 + 712);
					while true do
						if ((v262 == (0 + 0)) or ((4800 - (242 + 512)) >= (10296 - 5369))) then
							if (((5250 - (92 + 535)) >= (2195 + 592)) and v105.CastTargetIf(v101.FlameShock, v113, "min", v123, v120, not v17:IsSpellInRange(v101.FlameShock))) then
								return "flame_shock single_target 16";
							end
							if (((4601 - 2367) >= (77 + 1153)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
								return "flame_shock single_target 16";
							end
							break;
						end
					end
				end
				v172 = 7 - 5;
			end
			if ((v172 == (14 + 0)) or ((238 + 105) == (251 + 1535))) then
				if (((5121 - 2551) > (3671 - 1262)) and v101.FlameShock:IsCastable() and v41) then
					if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((4394 - (1476 + 309)) >= (4518 - (299 + 985)))) then
						return "flame_shock single_target 114";
					end
				end
				if ((v101.FrostShock:IsCastable() and v42) or ((721 + 2312) >= (13213 - 9182))) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((1494 - (86 + 7)) == (19076 - 14408))) then
						return "frost_shock single_target 116";
					end
				end
				break;
			end
			if (((264 + 2512) >= (2201 - (672 + 208))) and (v172 == (3 + 2))) then
				if ((v101.FrostShock:IsCastable() and v42 and v131() and v101.ElectrifiedShocks:IsAvailable() and ((v17:DebuffRemains(v101.ElectrifiedShocksDebuff) < (134 - (14 + 118))) or (v14:BuffRemains(v101.IcefuryBuff) <= v14:GCD())) and v101.LightningRod:IsAvailable()) or ((932 - (339 + 106)) > (1832 + 471))) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((2265 + 2238) == (4857 - (440 + 955)))) then
						return "frost_shock single_target 42";
					end
				end
				if (((545 + 8) <= (2771 - 1228)) and v101.FrostShock:IsCastable() and v42 and v131() and v101.ElectrifiedShocks:IsAvailable() and (v126() >= (17 + 33)) and (v17:DebuffRemains(v101.ElectrifiedShocksDebuff) < ((4 - 2) * v14:GCD())) and v130() and v101.LightningRod:IsAvailable()) then
					if (((1381 + 634) == (2368 - (260 + 93))) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single_target 44";
					end
				end
				if ((v101.LavaBeam:IsCastable() and v44 and (v114 > (1 + 0)) and (v115 > (2 - 1)) and v129() and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime()) and not v14:HasTier(55 - 24, 1978 - (1181 + 793))) or ((1080 + 3161) <= (2639 - (105 + 202)))) then
					if (v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam)) or ((1896 + 468) < (1967 - (352 + 458)))) then
						return "lava_beam single_target 46";
					end
				end
				if ((v101.FrostShock:IsCastable() and v42 and v131() and v130() and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.PrimordialSurge:IsAvailable() and v101.ElementalBlast:IsAvailable() and (((v126() >= (245 - 184)) and (v126() < (191 - 116)) and (v101.LavaBurst:CooldownRemains() > v14:GCD())) or ((v126() >= (48 + 1)) and (v126() < (184 - 121)) and (v101.LavaBurst:CooldownRemains() > (949 - (438 + 511)))))) or ((2550 - (1262 + 121)) > (2346 - (728 + 340)))) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((2935 - (816 + 974)) <= (3314 - 2232))) then
						return "frost_shock single_target 48";
					end
				end
				v172 = 21 - 15;
			end
			if ((v172 == (339 - (163 + 176))) or ((8838 - 5733) == (22431 - 17550))) then
				if ((v101.FireElemental:IsCastable() and v54 and ((v60 and v34) or not v60) and (v91 < v109)) or ((570 + 1317) > (6688 - (1564 + 246)))) then
					if (v25(v101.FireElemental) or ((4432 - (124 + 221)) > (2812 + 1304))) then
						return "fire_elemental single_target 2";
					end
				end
				if (((1557 - (115 + 336)) <= (2787 - 1521)) and v101.StormElemental:IsCastable() and v56 and ((v61 and v34) or not v61) and (v91 < v109)) then
					if (((650 + 2505) < (4696 - (45 + 1))) and v25(v101.StormElemental)) then
						return "storm_elemental single_target 4";
					end
				end
				if (((205 + 3569) >= (3829 - (1282 + 708))) and v101.TotemicRecall:IsCastable() and v50 and (v101.LiquidMagmaTotem:CooldownRemains() > (1257 - (583 + 629))) and ((v101.LavaSurge:IsAvailable() and v101.SplinteredElements:IsAvailable()) or ((v114 > (1 + 0)) and (v115 > (2 - 1))))) then
					if (((1474 + 1337) == (3981 - (943 + 227))) and v25(v101.TotemicRecall)) then
						return "totemic_recall single_target 6";
					end
				end
				if (((939 + 1207) > (2753 - (1539 + 92))) and v101.LiquidMagmaTotem:IsCastable() and v55 and ((v62 and v34) or not v62) and (v91 < v109) and ((v101.LavaSurge:IsAvailable() and v101.SplinteredElements:IsAvailable()) or (v101.FlameShockDebuff:AuraActiveCount() == (1946 - (706 + 1240))) or (v17:DebuffRemains(v101.FlameShockDebuff) < (264 - (81 + 177))) or ((v114 > (2 - 1)) and (v115 > (258 - (212 + 45)))))) then
					local v263 = 0 - 0;
					while true do
						if (((1946 - (708 + 1238)) == v263) or ((5 + 51) == (1183 + 2433))) then
							if ((v67 == "cursor") or ((4088 - (586 + 1081)) < (1133 - (348 + 163)))) then
								if (((907 + 102) <= (1410 - (215 + 65))) and v25(v103.LiquidMagmaTotemCursor, not v17:IsInRange(101 - 61))) then
									return "liquid_magma_totem single_target cursor 8";
								end
							end
							if (((4617 - (1541 + 318)) < (2644 + 336)) and (v67 == "player")) then
								if (v25(v103.LiquidMagmaTotemPlayer, not v17:IsInRange(21 + 19)) or ((65 + 21) >= (5376 - (1036 + 714)))) then
									return "liquid_magma_totem single_target player 8";
								end
							end
							break;
						end
					end
				end
				v172 = 1 + 0;
			end
			if (((1323 + 1072) == (3675 - (883 + 397))) and (v172 == (598 - (563 + 27)))) then
				if (((14789 - 11009) > (4695 - (1369 + 617))) and v101.Earthquake:IsReady() and v38 and (v114 > (1488 - (85 + 1402))) and (v115 > (1 + 0)) and not v101.EchoesofGreatSundering:IsAvailable() and not v101.ElementalBlast:IsAvailable()) then
					local v264 = 0 - 0;
					while true do
						if ((v264 == (403 - (274 + 129))) or ((454 - (12 + 205)) >= (2075 + 198))) then
							if ((v52 == "cursor") or ((7909 - 5869) <= (681 + 22))) then
								if (((3663 - (27 + 357)) <= (4447 - (91 + 389))) and v25(v103.EarthquakeCursor, not v17:IsInRange(337 - (90 + 207)))) then
									return "earthquake single_target 66";
								end
							end
							if ((v52 == "player") or ((77 + 1911) == (1738 - (706 + 155)))) then
								if (((6086 - (730 + 1065)) > (3475 - (1339 + 224))) and v25(v103.EarthquakePlayer, not v17:IsInRange(21 + 19))) then
									return "earthquake single_target 66";
								end
							end
							break;
						end
					end
				end
				if (((1784 + 219) < (3481 - 1142)) and v127(v101.ElementalBlast) and v101.ElementalBlast:IsCastable() and v40 and (not v101.MasteroftheElements:IsAvailable() or (v128() and v17:DebuffUp(v101.ElectrifiedShocksDebuff)))) then
					if (((1275 - (268 + 575)) == (1726 - (919 + 375))) and v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast single_target 68";
					end
				end
				if ((v127(v101.FrostShock) and v42 and v131() and v128() and (v126() < (302 - 192)) and (v101.LavaBurst:ChargesFractional() < (972 - (180 + 791))) and v101.ElectrifiedShocks:IsAvailable() and v101.ElementalBlast:IsAvailable() and not v101.LightningRod:IsAvailable()) or ((2950 - (323 + 1482)) >= (3171 - (1177 + 741)))) then
					if (((225 + 3193) > (7942 - 5824)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single_target 70";
					end
				end
				if (((1180 + 1886) <= (8688 - 4798)) and v127(v101.ElementalBlast) and v101.ElementalBlast:IsCastable() and v40 and (v128() or v101.LightningRod:IsAvailable())) then
					if (v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast)) or ((251 + 2747) >= (3390 - (96 + 13)))) then
						return "elemental_blast single_target 72";
					end
				end
				v172 = 1930 - (962 + 959);
			end
			if (((32 - 19) == v172) or ((823 + 3826) <= (3983 - (461 + 890)))) then
				if ((v101.FrostShock:IsCastable() and v42 and v131() and not v101.ElectrifiedShocks:IsAvailable() and not v101.FluxMelting:IsAvailable()) or ((2832 + 1028) > (18982 - 14110))) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((4241 - (19 + 224)) == (2083 + 215))) then
						return "frost_shock single_target 106";
					end
				end
				if ((v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and (v114 > (199 - (37 + 161))) and (v115 > (1 + 0))) or ((4 + 4) >= (2702 + 37))) then
					if (((2651 - (60 + 1)) == (3513 - (826 + 97))) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning single_target 108";
					end
				end
				if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46) or ((80 + 2) >= (6722 - 4852))) then
					if (((5405 - 2781) < (5242 - (375 + 310))) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
						return "lightning_bolt single_target 110";
					end
				end
				if ((v101.FlameShock:IsCastable() and v41 and (v14:IsMoving())) or ((5130 - (1864 + 135)) > (9138 - 5596))) then
					local v265 = 0 + 0;
					while true do
						if (((862 + 1715) >= (3877 - 2299)) and (v265 == (1131 - (314 + 817)))) then
							if (((2327 + 1776) <= (4785 - (32 + 182))) and v105.CastCycle(v101.FlameShock, v113, v120, not v17:IsSpellInRange(v101.FlameShock))) then
								return "flame_shock single_target 112";
							end
							if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((1105 + 390) == (16730 - 11943))) then
								return "flame_shock single_target 112";
							end
							break;
						end
					end
				end
				v172 = 79 - (39 + 26);
			end
			if ((v172 == (153 - (54 + 90))) or ((508 - (45 + 153)) > (2691 + 1743))) then
				if (((2720 - (457 + 95)) <= (4332 + 28)) and v101.EarthShock:IsReady() and v39) then
					if (((2074 - 1080) == (2401 - 1407)) and v25(v101.EarthShock, not v17:IsSpellInRange(v101.EarthShock))) then
						return "earth_shock single_target 74";
					end
				end
				if (((5984 - 4329) > (180 + 221)) and v127(v101.FrostShock) and v42 and v131() and v101.ElectrifiedShocks:IsAvailable() and v128() and not v101.LightningRod:IsAvailable() and (v114 > (3 - 2)) and (v115 > (2 - 1))) then
					if (((3811 - (485 + 263)) <= (4133 - (575 + 132))) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single_target 76";
					end
				end
				if (((2320 - (750 + 111)) > (1774 - (445 + 565))) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and (v101.DeeplyRootedElements:IsAvailable())) then
					if (v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst)) or ((516 + 125) > (622 + 3712))) then
						return "lava_burst single_target 78";
					end
					if (((6004 - 2605) >= (755 + 1505)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst single_target 78";
					end
				end
				if ((v101.FrostShock:IsCastable() and v42 and v131() and v101.FluxMelting:IsAvailable() and v14:BuffDown(v101.FluxMeltingBuff)) or ((703 - (189 + 121)) >= (1051 + 3191))) then
					if (((2336 - (634 + 713)) < (5397 - (493 + 45))) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single_target 80";
					end
				end
				v172 = 978 - (493 + 475);
			end
			if ((v172 == (1 + 2)) or ((5579 - (158 + 626)) < (447 + 502))) then
				if (((6353 - 2511) == (856 + 2986)) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v130() and v14:BuffUp(v101.SurgeofPowerBuff)) then
					if (((95 + 1652) <= (4692 - (1035 + 56))) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
						return "lightning_bolt single_target 26";
					end
				end
				if ((v127(v101.LavaBeam) and v44 and (v114 > (960 - (114 + 845))) and (v115 > (1 + 0)) and v130() and not v101.SurgeofPower:IsAvailable()) or ((2057 - 1253) > (3665 + 694))) then
					if (((5719 - (179 + 870)) >= (5081 - 1458)) and v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam))) then
						return "lava_beam single_target 28";
					end
				end
				if (((2943 - (827 + 51)) < (6727 - 4183)) and v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and (v114 > (1 + 0)) and (v115 > (474 - (95 + 378))) and v130() and not v101.SurgeofPower:IsAvailable()) then
					if (((96 + 1215) <= (4759 - 1400)) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning single_target 30";
					end
				end
				if (((2387 + 330) <= (4167 - (334 + 677))) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v130() and not v128() and not v101.SurgeofPower:IsAvailable() and v101.MasteroftheElements:IsAvailable()) then
					if (((4047 - 2966) < (5580 - (1049 + 7))) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst single_target 32";
					end
				end
				v172 = 17 - 13;
			end
			if (((827 - 387) >= (23 + 48)) and ((16 - 10) == v172)) then
				if (((9884 - 4950) > (1161 + 1446)) and v101.FrostShock:IsCastable() and v42 and v131() and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.ElementalBlast:IsAvailable() and (((v126() >= (1456 - (1004 + 416))) and (v126() < (2007 - (1621 + 336))) and (v101.LavaBurst:CooldownRemains() > v14:GCD())) or ((v126() >= (1963 - (337 + 1602))) and (v126() < (1555 - (1014 + 503))) and (v101.LavaBurst:CooldownRemains() > (1015 - (446 + 569)))))) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((59 + 1341) > (9142 - 6026))) then
						return "frost_shock single_target 50";
					end
				end
				if (((177 + 348) < (3451 - 1789)) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v14:BuffUp(v101.WindspeakersLavaResurgenceBuff) and (v101.EchooftheElements:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.PrimordialSurge:IsAvailable() or ((v126() >= (2 + 61)) and v101.MasteroftheElements:IsAvailable()) or ((v126() >= (543 - (223 + 282))) and v14:BuffUp(v101.EchoesofGreatSunderingBuff) and (v114 > (1 + 0)) and (v115 > (1 - 0))) or not v101.ElementalBlast:IsAvailable())) then
					if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((1277 - 401) > (3220 - (623 + 47)))) then
						return "lava_burst single_target 52";
					end
				end
				if (((264 - (32 + 13)) <= (1377 + 1079)) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v14:BuffUp(v101.LavaSurgeBuff) and (v101.EchooftheElements:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.PrimordialSurge:IsAvailable() or not v101.MasteroftheElements:IsAvailable() or not v101.ElementalBlast:IsAvailable())) then
					if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((3423 + 796) == (2951 - (1070 + 731)))) then
						return "lava_burst single_target 54";
					end
				end
				if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v14:BuffUp(v101.AscendanceBuff) and (v14:HasTier(30 + 1, 1408 - (1257 + 147)) or not v101.ElementalBlast:IsAvailable())) or ((1185 + 1804) <= (424 - 202))) then
					local v266 = 133 - (98 + 35);
					while true do
						if (((948 + 1310) > (4395 - 3154)) and (v266 == (0 - 0))) then
							if (((39 + 2) < (3748 + 511)) and v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst single_target 56";
							end
							if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((846 + 1084) < (613 - (395 + 162)))) then
								return "lava_burst single_target 56";
							end
							break;
						end
					end
				end
				v172 = 7 + 0;
			end
			if (((5274 - (816 + 1125)) == (4754 - 1421)) and (v172 == (1150 - (701 + 447)))) then
				if ((v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v101.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v109) and v14:BuffDown(v101.AscendanceBuff) and not v130() and (v126() >= (202 - 86)) and v101.ElementalBlast:IsAvailable() and v101.SurgeofPower:IsAvailable() and v101.SwellingMaelstrom:IsAvailable() and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.PrimordialSurge:IsAvailable()) or ((3566 - (391 + 950)) == (53 - 33))) then
					if (v25(v101.Stormkeeper) or ((2185 - 1313) >= (7618 - 4526))) then
						return "stormkeeper single_target 18";
					end
				end
				if (((3090 + 1314) >= (1893 + 1359)) and v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v101.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v109) and v14:BuffDown(v101.AscendanceBuff) and not v130() and v14:BuffUp(v101.SurgeofPowerBuff) and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.PrimordialSurge:IsAvailable()) then
					if (((2629 - (251 + 1271)) > (709 + 87)) and v25(v101.Stormkeeper)) then
						return "stormkeeper single_target 20";
					end
				end
				if (((2567 - 1608) == (2401 - 1442)) and v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v101.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v109) and v14:BuffDown(v101.AscendanceBuff) and not v130() and (not v101.SurgeofPower:IsAvailable() or not v101.ElementalBlast:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.EchooftheElements:IsAvailable() or v101.PrimordialSurge:IsAvailable())) then
					if (v25(v101.Stormkeeper) or ((1504 - (1147 + 112)) >= (551 + 1653))) then
						return "stormkeeper single_target 22";
					end
				end
				if (((6421 - 3259) >= (538 + 1531)) and v101.Ascendance:IsCastable() and v53 and ((v59 and v34) or not v59) and (v91 < v109) and not v130()) then
					if (v25(v101.Ascendance) or ((1003 - (335 + 362)) > (2888 + 193))) then
						return "ascendance single_target 24";
					end
				end
				v172 = 4 - 1;
			end
		end
	end
	local function v140()
		local v173 = 0 - 0;
		while true do
			if ((v173 == (0 - 0)) or ((17104 - 13591) < (7680 - 4974))) then
				if (((3544 - (237 + 329)) < (13032 - 9393)) and v74 and v101.EarthShield:IsCastable() and v14:BuffDown(v101.EarthShieldBuff) and ((v75 == "Earth Shield") or (v101.ElementalOrbit:IsAvailable() and v14:BuffUp(v101.LightningShield)))) then
					if (((2428 + 1254) >= (1581 + 1307)) and v25(v101.EarthShield)) then
						return "earth_shield main 2";
					end
				elseif (((1273 - (408 + 716)) < (1819 - 1340)) and v74 and v101.LightningShield:IsCastable() and v14:BuffDown(v101.LightningShieldBuff) and ((v75 == "Lightning Shield") or (v101.ElementalOrbit:IsAvailable() and v14:BuffUp(v101.EarthShield)))) then
					if (((1841 - (344 + 477)) >= (97 + 470)) and v25(v101.LightningShield)) then
						return "lightning_shield main 2";
					end
				end
				v31 = v134();
				v173 = 1762 - (1188 + 573);
			end
			if ((v173 == (5 - 3)) or ((715 + 18) > (8009 - 5540))) then
				if (((3859 - 1362) == (6175 - 3678)) and v101.AncestralSpirit:IsCastable() and v101.AncestralSpirit:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
					if (((5430 - (508 + 1021)) == (3666 + 235)) and v25(v103.AncestralSpiritMouseover)) then
						return "ancestral_spirit mouseover";
					end
				end
				v110, v111 = v30();
				v173 = 1169 - (228 + 938);
			end
			if (((886 - (332 + 353)) < (505 - 90)) and (v173 == (2 - 1))) then
				if (v31 or ((127 + 6) == (895 + 889))) then
					return v31;
				end
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v14:CanAttack(v17)) or ((27 - 20) >= (733 - (18 + 405)))) then
					if (((2288 + 2704) > (145 + 141)) and v25(v101.AncestralSpirit, nil, true)) then
						return "ancestral_spirit";
					end
				end
				v173 = 2 - 0;
			end
			if ((v173 == (981 - (194 + 784))) or ((4331 - (694 + 1076)) == (5797 - (122 + 1782)))) then
				if (((4105 + 257) >= (1325 + 96)) and v101.ImprovedFlametongueWeapon:IsAvailable() and v101.FlametongueWeapon:IsCastable() and v51 and (not v110 or (v111 < (540041 + 59959))) and v101.FlametongueWeapon:IsAvailable()) then
					if (((54 + 21) <= (10388 - 6842)) and v25(v101.FlametongueWeapon)) then
						return "flametongue_weapon enchant";
					end
				end
				if (((2483 + 197) <= (5388 - (214 + 1756))) and not v14:AffectingCombat() and v32 and v105.TargetIsValid()) then
					local v267 = 0 - 0;
					while true do
						if ((v267 == (0 + 0)) or ((237 + 4051) < (3461 - (217 + 368)))) then
							v31 = v137();
							if (((7438 - 4976) >= (756 + 391)) and v31) then
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
	local function v141()
		local v174 = 0 + 0;
		while true do
			if ((v174 == (1 + 1)) or ((5803 - (844 + 45)) < (2764 - (242 + 42)))) then
				if (v85 or ((3120 - 1561) == (2882 - 1642))) then
					local v268 = 1200 - (132 + 1068);
					while true do
						if (((903 - 337) == (2189 - (214 + 1409))) and (v268 == (0 + 0))) then
							if (((5555 - (497 + 1137)) >= (3949 - (9 + 931))) and v18) then
								local v286 = 289 - (181 + 108);
								while true do
									if (((1229 + 834) >= (4063 - 2415)) and (v286 == (0 - 0))) then
										v31 = v133();
										if (((252 + 814) >= (282 + 170)) and v31) then
											return v31;
										end
										break;
									end
								end
							end
							if (((5450 - (296 + 180)) >= (4058 - (1183 + 220))) and v15 and v15:Exists() and not v14:CanAttack(v15) and (v105.UnitHasDispellableDebuffByPlayer(v15) or v105.UnitHasCurseDebuff(v15))) then
								if (v101.CleanseSpirit:IsCastable() or ((3986 - (1037 + 228)) <= (1467 - 560))) then
									if (((12787 - 8350) >= (10356 - 7325)) and v25(v103.CleanseSpiritMouseover, not v15:IsSpellInRange(v101.PurifySpirit))) then
										return "purify_spirit dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				if ((v101.GreaterPurge:IsAvailable() and v98 and v101.GreaterPurge:IsReady() and v36 and v84 and not v14:IsCasting() and not v14:IsChanneling() and v105.UnitHasMagicBuff(v17)) or ((5204 - (527 + 207)) < (3476 - (187 + 340)))) then
					if (v25(v101.GreaterPurge, not v17:IsSpellInRange(v101.GreaterPurge)) or ((3450 - (1298 + 572)) == (6032 - 3606))) then
						return "greater_purge damage";
					end
				end
				v174 = 173 - (144 + 26);
			end
			if ((v174 == (7 - 4)) or ((8654 - 4943) == (180 + 323))) then
				if ((v101.Purge:IsReady() and v98 and v36 and v84 and not v14:IsCasting() and not v14:IsChanneling() and v105.UnitHasMagicBuff(v17)) or ((1144 - 724) == (10023 - 5705))) then
					if (v25(v101.Purge, not v17:IsSpellInRange(v101.Purge)) or ((20156 - 15998) <= (17 + 16))) then
						return "purge damage";
					end
				end
				if ((v105.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((133 - 34) > (4430 + 314))) then
					local v269 = 0 + 0;
					local v270;
					while true do
						if (((4543 - (5 + 197)) == (5027 - (339 + 347))) and (v269 == (6 - 3))) then
							if (((897 - 642) <= (1972 - (365 + 11))) and true) then
								local v287 = 0 + 0;
								while true do
									if ((v287 == (3 - 2)) or ((10404 - 5971) < (2559 - (837 + 87)))) then
										if (v25(v101.Pool) or ((7291 - 2991) < (4914 - (837 + 833)))) then
											return "Pool for SingleTarget()";
										end
										break;
									end
									if ((v287 == (0 + 0)) or ((4921 - (356 + 1031)) > (2127 + 2550))) then
										v31 = v139();
										if (v31 or ((6505 - (73 + 1573)) < (4387 - (1307 + 81)))) then
											return v31;
										end
										v287 = 235 - (7 + 227);
									end
								end
							end
							break;
						end
						if (((7762 - 3036) > (2573 - (90 + 76))) and (v269 == (0 - 0))) then
							if (((v91 < v109) and v58 and ((v64 and v34) or not v64)) or ((630 + 654) > (3029 + 640))) then
								local v288 = 0 + 0;
								while true do
									if (((4375 - 3258) < (2809 - (197 + 63))) and (v288 == (1 + 0))) then
										if ((v101.Fireblood:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (12 + 38)))) or ((1488 + 1363) > (784 + 3990))) then
											if (((1293 - 262) < (5217 - (618 + 751))) and v25(v101.Fireblood)) then
												return "fireblood main 6";
											end
										end
										if (((1387 + 467) > (2813 - (206 + 1704))) and v101.AncestralCall:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (84 - 34)))) then
											if (((9308 - 4645) > (812 + 1048)) and v25(v101.AncestralCall)) then
												return "ancestral_call main 8";
											end
										end
										v288 = 1277 - (155 + 1120);
									end
									if ((v288 == (1508 - (396 + 1110))) or ((6895 - 3842) <= (153 + 316))) then
										if ((v101.BagofTricks:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff))) or ((407 + 133) >= (1600 + 269))) then
											if (((4268 - (230 + 746)) == (3893 - (473 + 128))) and v25(v101.BagofTricks)) then
												return "bag_of_tricks main 10";
											end
										end
										break;
									end
									if (((1086 - (39 + 9)) <= (2911 - (38 + 228))) and (v288 == (0 - 0))) then
										if ((v101.BloodFury:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (523 - (106 + 367))))) or ((286 + 2944) < (4387 - (354 + 1508)))) then
											if (v25(v101.BloodFury) or ((7702 - 5302) > (2983 + 1100))) then
												return "blood_fury main 2";
											end
										end
										if ((v101.Berserking:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff))) or ((1610 + 1135) > (5860 - 1501))) then
											if (((1416 - (334 + 910)) <= (2705 - (92 + 803))) and v25(v101.Berserking)) then
												return "berserking main 4";
											end
										end
										v288 = 1 + 0;
									end
								end
							end
							if ((v91 < v109) or ((1673 - (1035 + 146)) >= (5575 - (230 + 386)))) then
								if ((v57 and ((v34 and v63) or not v63)) or ((440 + 316) == (3582 - (353 + 1157)))) then
									local v295 = 1114 - (53 + 1061);
									while true do
										if (((3240 - (1568 + 67)) <= (2128 + 2536)) and (v295 == (0 + 0))) then
											v31 = v136();
											if (((4597 - 2781) == (5343 - 3527)) and v31) then
												return v31;
											end
											break;
										end
									end
								end
							end
							v269 = 2 - 1;
						end
						if ((v269 == (1 + 0)) or ((1833 - (615 + 597)) > (2774 + 326))) then
							if ((v101.NaturesSwiftness:IsCastable() and v47) or ((1730 - 573) >= (3475 + 750))) then
								if (v25(v101.NaturesSwiftness) or ((99 + 4887) == (2278 + 1860))) then
									return "natures_swiftness main 12";
								end
							end
							v270 = v105.HandleDPSPotion(v14:BuffUp(v101.AscendanceBuff));
							v269 = 1901 - (1056 + 843);
						end
						if ((v269 == (3 - 1)) or ((3381 - 1348) <= (642 - 418))) then
							if (v270 or ((716 + 507) == (3987 - (286 + 1690)))) then
								return v270;
							end
							if (((5738 - (98 + 813)) > (1242 + 3453)) and v33 and (v114 > (4 - 2)) and (v115 > (2 + 0))) then
								v31 = v138();
								if (((4217 - (263 + 244)) > (2426 + 639)) and v31) then
									return v31;
								end
								if (((3822 - (1502 + 185)) <= (514 + 2182)) and v25(v101.Pool)) then
									return "Pool for Aoe()";
								end
							end
							v269 = 14 - 11;
						end
					end
				end
				break;
			end
			if ((v174 == (2 - 1)) or ((3269 - (629 + 898)) > (11974 - 7577))) then
				if (((10024 - 6124) >= (2269 - (12 + 353))) and v86) then
					local v271 = 1911 - (1680 + 231);
					while true do
						if ((v271 == (0 + 0)) or ((1056 + 668) == (2058 - (212 + 937)))) then
							if (((855 + 427) < (2483 - (111 + 951))) and v81) then
								local v289 = 0 + 0;
								while true do
									if (((4903 - (18 + 9)) >= (869 + 3468)) and (v289 == (534 - (31 + 503)))) then
										v31 = v105.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 1672 - (595 + 1037));
										if (((5449 - (189 + 1255)) >= (1111 + 1894)) and v31) then
											return v31;
										end
										break;
									end
								end
							end
							if (v82 or ((7399 - 2618) <= (5727 - (1170 + 109)))) then
								v31 = v105.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 1847 - (348 + 1469));
								if (((2606 - (1115 + 174)) > (419 - 247)) and v31) then
									return v31;
								end
							end
							v271 = 1015 - (85 + 929);
						end
						if (((2811 + 1980) == (6658 - (1151 + 716))) and (v271 == (1 + 0))) then
							if (((3892 + 96) > (2965 - (95 + 1609))) and v83) then
								v31 = v105.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 108 - 78);
								if (((2998 - (364 + 394)) <= (3277 + 339)) and v31) then
									return v31;
								end
							end
							break;
						end
					end
				end
				if (v87 or ((1191 + 2797) < (812 + 3135))) then
					local v272 = 0 + 0;
					while true do
						if (((2333 + 2311) == (2368 + 2276)) and (v272 == (0 + 0))) then
							v31 = v105.HandleIncorporeal(v101.Hex, v103.HexMouseOver, 28 + 2, true);
							if (((418 + 905) > (2227 - (719 + 237))) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				v174 = 5 - 3;
			end
			if (((1337 + 282) > (3611 - 2154)) and (v174 == (0 - 0))) then
				v31 = v135();
				if (v31 or ((6796 - 3936) < (3799 - (761 + 1230)))) then
					return v31;
				end
				v174 = 194 - (80 + 113);
			end
		end
	end
	local function v142()
		local v175 = 0 + 0;
		while true do
			if (((3 + 1) == v175) or ((22 + 717) >= (7261 - 5452))) then
				v53 = EpicSettings.Settings['useAscendance'];
				v55 = EpicSettings.Settings['useLiquidMagmaTotem'];
				v54 = EpicSettings.Settings['useFireElemental'];
				v56 = EpicSettings.Settings['useStormElemental'];
				v175 = 2 + 3;
			end
			if (((282 + 1257) <= (5391 - (965 + 278))) and (v175 == (1729 - (1391 + 338)))) then
				v37 = EpicSettings.Settings['useChainlightning'];
				v38 = EpicSettings.Settings['useEarthquake'];
				v39 = EpicSettings.Settings['useEarthShock'];
				v40 = EpicSettings.Settings['useElementalBlast'];
				v175 = 2 - 1;
			end
			if ((v175 == (5 + 0)) or ((940 - 506) > (982 + 2068))) then
				v59 = EpicSettings.Settings['ascendanceWithCD'];
				v62 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
				v60 = EpicSettings.Settings['fireElementalWithCD'];
				v61 = EpicSettings.Settings['stormElementalWithCD'];
				v175 = 1414 - (496 + 912);
			end
			if ((v175 == (9 - 6)) or ((753 + 2301) < (3189 - 1506))) then
				v49 = EpicSettings.Settings['useStormkeeper'];
				v50 = EpicSettings.Settings['useTotemicRecall'];
				v51 = EpicSettings.Settings['useWeaponEnchant'];
				v92 = EpicSettings.Settings['useWeapon'];
				v175 = 1334 - (1190 + 140);
			end
			if (((23 + 24) < (3424 - (317 + 401))) and ((950 - (303 + 646)) == v175)) then
				v41 = EpicSettings.Settings['useFlameShock'];
				v42 = EpicSettings.Settings['useFrostShock'];
				v43 = EpicSettings.Settings['useIceFury'];
				v44 = EpicSettings.Settings['useLavaBeam'];
				v175 = 6 - 4;
			end
			if (((3251 - (1675 + 57)) >= (374 + 206)) and ((4 - 2) == v175)) then
				v45 = EpicSettings.Settings['useLavaBurst'];
				v46 = EpicSettings.Settings['useLightningBolt'];
				v47 = EpicSettings.Settings['useNaturesSwiftness'];
				v48 = EpicSettings.Settings['usePrimordialWave'];
				v175 = 1 + 2;
			end
			if (((983 - (338 + 639)) == v175) or ((3489 - (320 + 59)) == (2135 + 2042))) then
				v65 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v66 = EpicSettings.Settings['stormkeeperWithMiniCD'];
				break;
			end
		end
	end
	local function v143()
		local v176 = 732 - (628 + 104);
		while true do
			if (((5204 - 1004) > (3967 - (439 + 1452))) and (v176 == (1952 - (105 + 1842)))) then
				v99 = EpicSettings.Settings['healOOC'];
				v100 = EpicSettings.Settings['healOOCHP'] or (0 - 0);
				v98 = EpicSettings.Settings['usePurgeTarget'];
				v176 = 14 - 8;
			end
			if ((v176 == (4 - 3)) or ((26 + 575) >= (4025 - 1679))) then
				v71 = EpicSettings.Settings['useAncestralGuidance'];
				v72 = EpicSettings.Settings['useAstralShift'];
				v73 = EpicSettings.Settings['useHealingStreamTotem'];
				v176 = 2 + 0;
			end
			if (((5134 - (274 + 890)) <= (3787 + 567)) and (v176 == (4 + 0))) then
				v67 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
				v74 = EpicSettings.Settings['autoShield'];
				v75 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v176 = 2 + 3;
			end
			if ((v176 == (2 + 0)) or ((901 + 641) < (293 - 85))) then
				v76 = EpicSettings.Settings['ancestralGuidanceHP'] or (819 - (731 + 88));
				v77 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
				v78 = EpicSettings.Settings['astralShiftHP'] or (0 + 0);
				v176 = 1 + 2;
			end
			if (((2354 - 742) <= (9120 - 6194)) and (v176 == (17 - 11))) then
				v81 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v82 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v83 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if ((v176 == (0 - 0)) or ((1822 + 184) <= (3 + 537))) then
				v68 = EpicSettings.Settings['useWindShear'];
				v69 = EpicSettings.Settings['useCapacitorTotem'];
				v70 = EpicSettings.Settings['useThunderstorm'];
				v176 = 1 + 0;
			end
			if (((3 + 0) == v176) or ((2570 - (139 + 19)) == (835 + 3842))) then
				v79 = EpicSettings.Settings['healingStreamTotemHP'] or (1993 - (1687 + 306));
				v80 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 - 0);
				v52 = EpicSettings.Settings['earthquakeSetting'] or "";
				v176 = 1158 - (1018 + 136);
			end
		end
	end
	local function v144()
		local v177 = 0 + 0;
		while true do
			if (((0 - 0) == v177) or ((5712 - (117 + 698)) <= (2453 - (305 + 176)))) then
				v91 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v88 = EpicSettings.Settings['InterruptWithStun'];
				v89 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v90 = EpicSettings.Settings['InterruptThreshold'];
				v177 = 1 + 0;
			end
			if (((5375 - 2274) <= (3356 + 228)) and (v177 == (2 - 0))) then
				v63 = EpicSettings.Settings['trinketsWithCD'];
				v64 = EpicSettings.Settings['racialsWithCD'];
				v94 = EpicSettings.Settings['useHealthstone'];
				v93 = EpicSettings.Settings['useHealingPotion'];
				v177 = 6 - 3;
			end
			if ((v177 == (1 - 0)) or ((1828 - (159 + 101)) >= (21903 - 17360))) then
				v85 = EpicSettings.Settings['DispelDebuffs'];
				v84 = EpicSettings.Settings['DispelBuffs'];
				v57 = EpicSettings.Settings['useTrinkets'];
				v58 = EpicSettings.Settings['useRacials'];
				v177 = 6 - 4;
			end
			if (((2107 + 2151) >= (5868 - 4027)) and (v177 == (5 - 2))) then
				v96 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v95 = EpicSettings.Settings['healingPotionHP'] or (266 - (112 + 154));
				v97 = EpicSettings.Settings['HealingPotionName'] or "";
				v86 = EpicSettings.Settings['handleAfflicted'];
				v177 = 9 - 5;
			end
			if ((v177 == (35 - (21 + 10))) or ((4771 - (531 + 1188)) >= (3038 + 516))) then
				v87 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v145()
		v143();
		v142();
		v144();
		v32 = EpicSettings.Toggles['ooc'];
		v33 = EpicSettings.Toggles['aoe'];
		v34 = EpicSettings.Toggles['cds'];
		v36 = EpicSettings.Toggles['dispel'];
		v35 = EpicSettings.Toggles['minicds'];
		if (v14:IsDeadOrGhost() or ((2761 - (96 + 567)) > (5609 - 1724))) then
			return v31;
		end
		v112 = v14:GetEnemiesInRange(17 + 23);
		v113 = v17:GetEnemiesInSplashRange(17 - 12);
		if (v33 or ((4665 - (867 + 828)) == (2564 - 1392))) then
			local v186 = 0 - 0;
			while true do
				if (((8737 - 4824) > (5979 - 2098)) and (v186 == (0 + 0))) then
					v114 = #v112;
					v115 = v28(v17:GetEnemiesInSplashRangeCount(8 - 3), v114);
					break;
				end
			end
		else
			local v187 = 771 - (134 + 637);
			while true do
				if (((858 + 4074) >= (2907 - (775 + 382))) and (v187 == (0 - 0))) then
					v114 = 608 - (45 + 562);
					v115 = 863 - (545 + 317);
					break;
				end
			end
		end
		if ((v36 and v85) or ((200 - 65) == (2695 - (763 + 263)))) then
			if (((1146 + 3656) >= (1859 - (512 + 1238))) and v14:AffectingCombat() and v101.CleanseSpirit:IsAvailable()) then
				local v241 = 1594 - (272 + 1322);
				local v242;
				while true do
					if ((v241 == (1 - 0)) or ((5157 - (533 + 713)) > (4980 - (14 + 14)))) then
						if (v31 or ((1090 - (499 + 326)) > (7518 - 3324))) then
							return v31;
						end
						break;
					end
					if (((3079 - (104 + 320)) <= (4905 - (1929 + 68))) and (v241 == (1323 - (1206 + 117)))) then
						v242 = v85 and v101.CleanseSpirit:IsReady() and v36;
						v31 = v105.FocusUnit(v242, nil, 14 + 6, nil, 1617 - (683 + 909), v101.HealingSurge);
						v241 = 2 - 1;
					end
				end
			end
		end
		if (((1789 - 826) > (1428 - (772 + 5))) and (v105.TargetIsValid() or v14:AffectingCombat())) then
			local v188 = 1427 - (19 + 1408);
			while true do
				if ((v188 == (288 - (134 + 154))) or ((5773 - 2270) <= (604 - 409))) then
					v108 = v10.BossFightRemains();
					v109 = v108;
					v188 = 1 + 0;
				end
				if (((1174 + 208) <= (4606 - (10 + 192))) and ((48 - (13 + 34)) == v188)) then
					if ((v109 == (12400 - (342 + 947))) or ((20037 - 15180) <= (2475 - (119 + 1589)))) then
						v109 = v10.FightRemains(v112, false);
					end
					break;
				end
			end
		end
		if ((not v14:IsChanneling() and not v14:IsCasting()) or ((8863 - 4845) > (5567 - 1546))) then
			if (v86 or ((2822 - (545 + 7)) == (5476 - 3544))) then
				local v243 = 0 + 0;
				while true do
					if (((1703 - (494 + 1209)) == v243) or ((9170 - 5740) <= (2174 - (197 + 801)))) then
						if (v81 or ((2415 - 1217) >= (17971 - 14254))) then
							local v277 = 954 - (919 + 35);
							while true do
								if (((3160 + 570) >= (5378 - 4045)) and (v277 == (467 - (369 + 98)))) then
									v31 = v105.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 1155 - (400 + 715));
									if (v31 or ((958 + 1194) == (1218 + 1579))) then
										return v31;
									end
									break;
								end
							end
						end
						if (v82 or ((3034 - (744 + 581)) < (295 + 293))) then
							local v278 = 1622 - (653 + 969);
							while true do
								if ((v278 == (0 - 0)) or ((5206 - (12 + 1619)) <= (3365 - (103 + 60)))) then
									v31 = v105.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 147 - 117);
									if (v31 or ((19210 - 14813) < (17704 - 13989))) then
										return v31;
									end
									break;
								end
							end
						end
						v243 = 1663 - (710 + 952);
					end
					if ((v243 == (1869 - (555 + 1313))) or ((3730 + 345) <= (2010 + 235))) then
						if (v83 or ((2750 + 1216) > (6256 - (1261 + 207)))) then
							local v279 = 252 - (245 + 7);
							while true do
								if (((4573 - (212 + 535)) > (2905 - 2317)) and (v279 == (1476 - (905 + 571)))) then
									v31 = v105.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 140 - 110);
									if (((981 - 287) <= (5959 - 4452)) and v31) then
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
			if (((30 + 3870) >= (2579 - (522 + 941))) and v14:AffectingCombat()) then
				if (((6418 - (292 + 1219)) > (4423 - (787 + 325))) and v34 and v92 and (v102.Dreambinder:IsEquippedAndReady() or v102.Iridal:IsEquippedAndReady())) then
					if (v25(v103.UseWeapon, nil) or ((10356 - 6948) <= (2328 + 289))) then
						return "Using Weapon Macro";
					end
				end
				v31 = v141();
				if (((7343 - 4142) == (3735 - (424 + 110))) and v31) then
					return v31;
				end
			else
				local v244 = 0 + 0;
				while true do
					if (((1302 + 893) == (435 + 1760)) and (v244 == (312 - (33 + 279)))) then
						v31 = v140();
						if (v31 or ((486 + 2539) > (4859 - (1338 + 15)))) then
							return v31;
						end
						break;
					end
				end
			end
		end
	end
	local function v146()
		v101.FlameShockDebuff:RegisterAuraTracking();
		v107();
		v22.Print("Elemental Shaman by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(1685 - (528 + 895), v145, v146);
end;
return v0["Epix_Shaman_Elemental.lua"]();

