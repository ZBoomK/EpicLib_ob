local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((7796 - 5546) > (16323 - 12905))) then
			v6 = v0[v4];
			if (not v6 or ((6547 - 3395) == (159 + 2602))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if ((v5 == (1 + 0)) or ((3339 - 2204) >= (2595 - (12 + 5)))) then
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
		if (v101.CleanseSpirit:IsAvailable() or ((2334 - 1733) < (987 - 524))) then
			v105.DispellableDebuffs = v105.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v107();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v10:RegisterForEvent(function()
		v101.PrimordialWave:RegisterInFlightEffect(695449 - 368287);
		v101.PrimordialWave:RegisterInFlight();
		v101.LavaBurst:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v101.PrimordialWave:RegisterInFlightEffect(811327 - 484165);
	v101.PrimordialWave:RegisterInFlight();
	v101.LavaBurst:RegisterInFlight();
	local v108 = 2256 + 8855;
	local v109 = 13084 - (1656 + 317);
	local v110, v111;
	local v112, v113;
	local v114 = 0 + 0;
	local v115 = 0 + 0;
	local v116 = 0 - 0;
	local v117 = 0 - 0;
	local v118 = 354 - (5 + 349);
	local function v119()
		return (189 - 149) - (v29() - v116);
	end
	v10:RegisterForSelfCombatEvent(function(...)
		local v147, v148, v148, v148, v149 = select(1279 - (266 + 1005), ...);
		if (((v147 == v14:GUID()) and (v149 == (126281 + 65353))) or ((7448 - 5265) < (904 - 217))) then
			local v193 = 1696 - (561 + 1135);
			while true do
				if (((5927 - 1378) == (14952 - 10403)) and ((1066 - (507 + 559)) == v193)) then
					v117 = v29();
					C_Timer.After(0.1 - 0, function()
						if (((14448 - 9776) == (5060 - (212 + 176))) and (v117 ~= v118)) then
							v116 = v117;
						end
					end);
					break;
				end
			end
		end
	end, "SPELL_AURA_APPLIED");
	local function v120(v150)
		return (v150:DebuffRefreshable(v101.FlameShockDebuff));
	end
	local function v121(v151)
		return v151:DebuffRefreshable(v101.FlameShockDebuff) and (v151:DebuffRemains(v101.FlameShockDebuff) < (v151:TimeToDie() - (910 - (250 + 655))));
	end
	local function v122(v152)
		return v152:DebuffRefreshable(v101.FlameShockDebuff) and (v152:DebuffRemains(v101.FlameShockDebuff) < (v152:TimeToDie() - (13 - 8))) and (v152:DebuffRemains(v101.FlameShockDebuff) > (0 - 0));
	end
	local function v123(v153)
		return (v153:DebuffRemains(v101.FlameShockDebuff));
	end
	local function v124(v154)
		return v154:DebuffRemains(v101.FlameShockDebuff) > (2 - 0);
	end
	local function v125(v155)
		return (v155:DebuffRemains(v101.LightningRodDebuff));
	end
	local function v126()
		local v156 = v14:Maelstrom();
		if (not v14:IsCasting() or ((5624 - (1869 + 87)) < (1370 - 975))) then
			return v156;
		elseif (v14:IsCasting(v101.ElementalBlast) or ((6067 - (484 + 1417)) == (975 - 520))) then
			return v156 - (125 - 50);
		elseif (v14:IsCasting(v101.Icefury) or ((5222 - (48 + 725)) == (4349 - 1686))) then
			return v156 + (66 - 41);
		elseif (v14:IsCasting(v101.LightningBolt) or ((2486 + 1791) < (7987 - 4998))) then
			return v156 + 3 + 7;
		elseif (v14:IsCasting(v101.LavaBurst) or ((254 + 616) >= (5002 - (152 + 701)))) then
			return v156 + (1323 - (430 + 881));
		elseif (((848 + 1364) < (4078 - (557 + 338))) and v14:IsCasting(v101.ChainLightning)) then
			return v156 + ((2 + 2) * v115);
		else
			return v156;
		end
	end
	local function v127(v157)
		local v158 = 0 - 0;
		local v159;
		while true do
			if (((16268 - 11622) > (7948 - 4956)) and (v158 == (0 - 0))) then
				v159 = v157:IsReady();
				if (((2235 - (499 + 302)) < (3972 - (39 + 827))) and ((v157 == v101.Stormkeeper) or (v157 == v101.ElementalBlast) or (v157 == v101.Icefury))) then
					local v239 = v14:BuffUp(v101.SpiritwalkersGraceBuff) or not v14:IsMoving();
					return v159 and v239 and not v14:IsCasting(v157);
				elseif (((2169 - 1383) < (6751 - 3728)) and (v157 == v101.LavaBeam)) then
					local v269 = 0 - 0;
					local v270;
					while true do
						if ((v269 == (0 - 0)) or ((210 + 2232) < (216 - 142))) then
							v270 = v14:BuffUp(v101.SpiritwalkersGraceBuff) or not v14:IsMoving();
							return v159 and v270;
						end
					end
				elseif (((726 + 3809) == (7176 - 2641)) and ((v157 == v101.LightningBolt) or (v157 == v101.ChainLightning))) then
					local v274 = 104 - (103 + 1);
					local v275;
					while true do
						if ((v274 == (554 - (475 + 79))) or ((6504 - 3495) <= (6736 - 4631))) then
							v275 = v14:BuffUp(v101.SpiritwalkersGraceBuff) or v14:BuffUp(v101.StormkeeperBuff) or not v14:IsMoving();
							return v159 and v275;
						end
					end
				elseif (((237 + 1593) < (3229 + 440)) and (v157 == v101.LavaBurst)) then
					local v290 = 1503 - (1395 + 108);
					local v291;
					local v292;
					local v293;
					local v294;
					while true do
						if (((2 - 1) == v290) or ((2634 - (7 + 1197)) >= (1575 + 2037))) then
							v293 = (v101.LavaBurst:Charges() >= (1 + 0)) and not v14:IsCasting(v101.LavaBurst);
							v294 = (v101.LavaBurst:Charges() == (321 - (27 + 292))) and v14:IsCasting(v101.LavaBurst);
							v290 = 5 - 3;
						end
						if (((3420 - 737) >= (10316 - 7856)) and (v290 == (0 - 0))) then
							v291 = v14:BuffUp(v101.SpiritwalkersGraceBuff) or v14:BuffUp(v101.LavaSurgeBuff) or not v14:IsMoving();
							v292 = v14:BuffUp(v101.LavaSurgeBuff);
							v290 = 1 - 0;
						end
						if ((v290 == (141 - (43 + 96))) or ((7358 - 5554) >= (7404 - 4129))) then
							return v159 and v291 and (v292 or v293 or v294);
						end
					end
				elseif ((v157 == v101.PrimordialWave) or ((1176 + 241) > (1025 + 2604))) then
					return v159 and v34 and v14:BuffDown(v101.PrimordialWaveBuff) and v14:BuffDown(v101.LavaSurgeBuff);
				else
					return v159;
				end
				break;
			end
		end
	end
	local function v128()
		if (((9477 - 4682) > (155 + 247)) and not v101.MasteroftheElements:IsAvailable()) then
			return false;
		end
		local v160 = v14:BuffUp(v101.MasteroftheElementsBuff);
		if (((9019 - 4206) > (1123 + 2442)) and not v14:IsCasting()) then
			return v160;
		elseif (((287 + 3625) == (5663 - (1414 + 337))) and v14:IsCasting(v106.LavaBurst)) then
			return true;
		elseif (((4761 - (1642 + 298)) <= (12575 - 7751)) and (v14:IsCasting(v106.ElementalBlast) or v14:IsCasting(v101.Icefury) or v14:IsCasting(v101.LightningBolt) or v14:IsCasting(v101.ChainLightning))) then
			return false;
		else
			return v160;
		end
	end
	local function v129()
		local v161 = 0 - 0;
		local v162;
		while true do
			if (((5157 - 3419) <= (723 + 1472)) and ((0 + 0) == v161)) then
				if (((1013 - (357 + 615)) <= (2119 + 899)) and not v101.PoweroftheMaelstrom:IsAvailable()) then
					return false;
				end
				v162 = v14:BuffStack(v101.PoweroftheMaelstromBuff);
				v161 = 2 - 1;
			end
			if (((1838 + 307) <= (8794 - 4690)) and (v161 == (1 + 0))) then
				if (((183 + 2506) < (3046 + 1799)) and not v14:IsCasting()) then
					return v162 > (1301 - (384 + 917));
				elseif (((v162 == (698 - (128 + 569))) and (v14:IsCasting(v101.LightningBolt) or v14:IsCasting(v101.ChainLightning))) or ((3865 - (1407 + 136)) > (4509 - (687 + 1200)))) then
					return false;
				else
					return v162 > (1710 - (556 + 1154));
				end
				break;
			end
		end
	end
	local function v130()
		local v163 = 0 - 0;
		local v164;
		while true do
			if ((v163 == (95 - (9 + 86))) or ((4955 - (275 + 146)) == (339 + 1743))) then
				if (not v101.Stormkeeper:IsAvailable() or ((1635 - (29 + 35)) > (8274 - 6407))) then
					return false;
				end
				v164 = v14:BuffUp(v101.StormkeeperBuff);
				v163 = 2 - 1;
			end
			if (((4 - 3) == v163) or ((1729 + 925) >= (4008 - (53 + 959)))) then
				if (((4386 - (312 + 96)) > (3651 - 1547)) and not v14:IsCasting()) then
					return v164;
				elseif (((3280 - (147 + 138)) > (2440 - (813 + 86))) and v14:IsCasting(v101.Stormkeeper)) then
					return true;
				else
					return v164;
				end
				break;
			end
		end
	end
	local function v131()
		local v165 = 0 + 0;
		local v166;
		while true do
			if (((6019 - 2770) > (1445 - (18 + 474))) and (v165 == (0 + 0))) then
				if (not v101.Icefury:IsAvailable() or ((10682 - 7409) > (5659 - (860 + 226)))) then
					return false;
				end
				v166 = v14:BuffUp(v101.IcefuryBuff);
				v165 = 304 - (121 + 182);
			end
			if ((v165 == (1 + 0)) or ((4391 - (988 + 252)) < (146 + 1138))) then
				if (not v14:IsCasting() or ((580 + 1270) == (3499 - (49 + 1921)))) then
					return v166;
				elseif (((1711 - (223 + 667)) < (2175 - (51 + 1))) and v14:IsCasting(v101.Icefury)) then
					return true;
				else
					return v166;
				end
				break;
			end
		end
	end
	local v132 = 0 - 0;
	local function v133()
		if (((1931 - 1029) < (3450 - (146 + 979))) and v101.CleanseSpirit:IsReady() and v36 and (v105.UnitHasDispellableDebuffByPlayer(v18) or v105.DispellableFriendlyUnit(6 + 14) or v105.UnitHasCurseDebuff(v18))) then
			local v194 = 605 - (311 + 294);
			while true do
				if (((2392 - 1534) <= (1255 + 1707)) and (v194 == (1443 - (496 + 947)))) then
					if ((v132 == (1358 - (1233 + 125))) or ((1602 + 2344) < (1156 + 132))) then
						v132 = v29();
					end
					if (v105.Wait(95 + 405, v132) or ((4887 - (963 + 682)) == (474 + 93))) then
						local v271 = 1504 - (504 + 1000);
						while true do
							if ((v271 == (0 + 0)) or ((772 + 75) >= (120 + 1143))) then
								if (v25(v103.CleanseSpiritFocus) or ((3322 - 1069) == (1582 + 269))) then
									return "cleanse_spirit dispel";
								end
								v132 = 0 + 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v134()
		if ((v99 and (v14:HealthPercentage() <= v100)) or ((2269 - (156 + 26)) > (1367 + 1005))) then
			if (v101.HealingSurge:IsReady() or ((6954 - 2509) < (4313 - (149 + 15)))) then
				if (v25(v101.HealingSurge) or ((2778 - (890 + 70)) == (202 - (39 + 78)))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v135()
		local v167 = 482 - (14 + 468);
		while true do
			if (((1385 - 755) < (5945 - 3818)) and ((2 + 0) == v167)) then
				if ((v93 and (v14:HealthPercentage() <= v95)) or ((1164 + 774) == (535 + 1979))) then
					local v240 = 0 + 0;
					while true do
						if (((1115 + 3140) >= (105 - 50)) and ((1 + 0) == v240)) then
							if (((10538 - 7539) > (30 + 1126)) and (v97 == "Potion of Withering Dreams")) then
								if (((2401 - (12 + 39)) > (1075 + 80)) and v102.PotionOfWitheringDreams:IsReady()) then
									if (((12470 - 8441) <= (17283 - 12430)) and v25(v103.RefreshingHealingPotion)) then
										return "potion of withering dreams defensive";
									end
								end
							end
							break;
						end
						if ((v240 == (0 + 0)) or ((272 + 244) > (8707 - 5273))) then
							if (((2695 + 1351) >= (14657 - 11624)) and (v97 == "Refreshing Healing Potion")) then
								if (v102.RefreshingHealingPotion:IsReady() or ((4429 - (1596 + 114)) <= (3777 - 2330))) then
									if (v25(v103.RefreshingHealingPotion) or ((4847 - (164 + 549)) < (5364 - (1059 + 379)))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v97 == "Dreamwalker's Healing Potion") or ((202 - 38) >= (1444 + 1341))) then
								if (v102.DreamwalkersHealingPotion:IsReady() or ((89 + 436) == (2501 - (145 + 247)))) then
									if (((28 + 5) == (16 + 17)) and v25(v103.RefreshingHealingPotion)) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							v240 = 2 - 1;
						end
					end
				end
				break;
			end
			if (((586 + 2468) <= (3459 + 556)) and ((0 - 0) == v167)) then
				if (((2591 - (254 + 466)) < (3942 - (544 + 16))) and v101.AstralShift:IsReady() and v72 and (v14:HealthPercentage() <= v78)) then
					if (((4109 - 2816) <= (2794 - (294 + 334))) and v25(v101.AstralShift)) then
						return "astral_shift defensive 1";
					end
				end
				if ((v101.AncestralGuidance:IsReady() and v71 and v105.AreUnitsBelowHealthPercentage(v76, v77, v101.HealingSurge)) or ((2832 - (236 + 17)) < (54 + 69))) then
					if (v25(v101.AncestralGuidance) or ((659 + 187) >= (8918 - 6550))) then
						return "ancestral_guidance defensive 2";
					end
				end
				v167 = 4 - 3;
			end
			if ((v167 == (1 + 0)) or ((3305 + 707) <= (4152 - (413 + 381)))) then
				if (((63 + 1431) <= (6390 - 3385)) and v101.HealingStreamTotem:IsReady() and v73 and v105.AreUnitsBelowHealthPercentage(v79, v80, v101.HealingSurge)) then
					if (v25(v101.HealingStreamTotem) or ((8081 - 4970) == (4104 - (582 + 1388)))) then
						return "healing_stream_totem defensive 3";
					end
				end
				if (((4012 - 1657) == (1686 + 669)) and v102.Healthstone:IsReady() and v94 and (v14:HealthPercentage() <= v96)) then
					if (v25(v103.Healthstone) or ((952 - (326 + 38)) <= (1277 - 845))) then
						return "healthstone defensive 3";
					end
				end
				v167 = 2 - 0;
			end
		end
	end
	local function v136()
		local v168 = 620 - (47 + 573);
		while true do
			if (((1691 + 3106) >= (16542 - 12647)) and (v168 == (0 - 0))) then
				v31 = v105.HandleTopTrinket(v104, v34, 1704 - (1269 + 395), nil);
				if (((4069 - (76 + 416)) == (4020 - (319 + 124))) and v31) then
					return v31;
				end
				v168 = 2 - 1;
			end
			if (((4801 - (564 + 443)) > (10223 - 6530)) and (v168 == (459 - (337 + 121)))) then
				v31 = v105.HandleBottomTrinket(v104, v34, 117 - 77, nil);
				if (v31 or ((4246 - 2971) == (6011 - (1261 + 650)))) then
					return v31;
				end
				break;
			end
		end
	end
	local function v137()
		local v169 = 0 + 0;
		while true do
			if (((0 - 0) == v169) or ((3408 - (772 + 1045)) >= (505 + 3075))) then
				if (((1127 - (102 + 42)) <= (3652 - (1524 + 320))) and v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (1270 - (1049 + 221))) and not v14:BuffUp(v101.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v109)) then
					if (v25(v101.Stormkeeper) or ((2306 - (18 + 138)) <= (2929 - 1732))) then
						return "stormkeeper precombat 2";
					end
				end
				if (((4871 - (67 + 1035)) >= (1521 - (136 + 212))) and v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (0 - 0)) and v43) then
					if (((1190 + 295) == (1369 + 116)) and v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury))) then
						return "icefury precombat 4";
					end
				end
				v169 = 1605 - (240 + 1364);
			end
			if ((v169 == (1085 - (1050 + 32))) or ((11836 - 8521) <= (1646 + 1136))) then
				if ((v14:IsCasting(v101.LavaBurst) and v41 and v101.FlameShock:IsReady()) or ((1931 - (331 + 724)) >= (240 + 2724))) then
					if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((2876 - (269 + 375)) > (3222 - (267 + 458)))) then
						return "flameshock precombat 14";
					end
				end
				if ((v14:IsCasting(v101.LavaBurst) and v48 and ((v65 and v35) or not v65) and v127(v101.PrimordialWave)) or ((657 + 1453) <= (637 - 305))) then
					if (((4504 - (667 + 151)) > (4669 - (1410 + 87))) and v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave))) then
						return "primordial_wave precombat 16";
					end
				end
				break;
			end
			if ((v169 == (1899 - (1504 + 393))) or ((12093 - 7619) < (2127 - 1307))) then
				if (((5075 - (461 + 335)) >= (369 + 2513)) and v14:IsCasting(v101.ElementalBlast) and v41 and not v101.PrimordialWave:IsAvailable() and v101.FlameShock:IsCastable()) then
					if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((3790 - (1730 + 31)) >= (5188 - (728 + 939)))) then
						return "flameshock precombat 10";
					end
				end
				if ((v127(v101.LavaBurst) and v45 and not v14:IsCasting(v101.LavaBurst) and (not v101.ElementalBlast:IsAvailable() or (v101.ElementalBlast:IsAvailable() and not v127(v101.ElementalBlast)))) or ((7214 - 5177) >= (9415 - 4773))) then
					if (((3940 - 2220) < (5526 - (138 + 930))) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lavaburst precombat 12";
					end
				end
				v169 = 3 + 0;
			end
			if ((v169 == (1 + 0)) or ((374 + 62) > (12335 - 9314))) then
				if (((2479 - (459 + 1307)) <= (2717 - (474 + 1396))) and v127(v101.ElementalBlast) and v40) then
					if (((3760 - 1606) <= (3778 + 253)) and v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast precombat 6";
					end
				end
				if (((16 + 4599) == (13219 - 8604)) and v14:IsCasting(v101.ElementalBlast) and v48 and ((v65 and v35) or not v65) and v127(v101.PrimordialWave)) then
					if (v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave)) or ((481 + 3309) == (1669 - 1169))) then
						return "primordial_wave precombat 8";
					end
				end
				v169 = 8 - 6;
			end
		end
	end
	local function v138()
		local v170 = 591 - (562 + 29);
		while true do
			if (((76 + 13) < (1640 - (374 + 1045))) and (v170 == (8 + 1))) then
				if (((6377 - 4323) >= (2059 - (448 + 190))) and v127(v101.LavaBurst) and (v115 == (1 + 2)) and v101.MasteroftheElements:IsAvailable()) then
					local v241 = 0 + 0;
					while true do
						if (((451 + 241) < (11757 - 8699)) and (v241 == (0 - 0))) then
							if (v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst)) or ((4748 - (1307 + 187)) == (6562 - 4907))) then
								return "lava_burst aoe 84";
							end
							if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((3034 - 1738) == (15055 - 10145))) then
								return "lava_burst aoe 84";
							end
							break;
						end
					end
				end
				if (((4051 - (232 + 451)) == (3217 + 151)) and v127(v101.LavaBurst) and v14:BuffUp(v101.LavaSurgeBuff) and v101.DeeplyRootedElements:IsAvailable()) then
					local v242 = 0 + 0;
					while true do
						if (((3207 - (510 + 54)) < (7686 - 3871)) and (v242 == (36 - (13 + 23)))) then
							if (((3728 - 1815) > (707 - 214)) and v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst aoe 86";
							end
							if (((8638 - 3883) > (4516 - (830 + 258))) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst aoe 86";
							end
							break;
						end
					end
				end
				if (((4871 - 3490) <= (1483 + 886)) and v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (0 + 0)) and v43 and v101.ElectrifiedShocks:IsAvailable() and (v115 < (1446 - (860 + 581)))) then
					if (v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury)) or ((17863 - 13020) == (3242 + 842))) then
						return "icefury aoe 88";
					end
				end
				if (((4910 - (237 + 4)) > (852 - 489)) and v127(v101.FrostShock) and v42 and v14:BuffUp(v101.IcefuryBuff) and v101.ElectrifiedShocks:IsAvailable() and not v17:DebuffUp(v101.ElectrifiedShocksDebuff) and (v115 < (12 - 7)) and v101.UnrelentingCalamity:IsAvailable()) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((3558 - 1681) >= (2569 + 569))) then
						return "frost_shock aoe 90";
					end
				end
				v170 = 6 + 4;
			end
			if (((17902 - 13160) >= (1556 + 2070)) and (v170 == (0 + 0))) then
				if ((v101.FireElemental:IsReady() and v54 and ((v60 and v34) or not v60) and (v91 < v109)) or ((5966 - (85 + 1341)) == (1562 - 646))) then
					if (v25(v101.FireElemental) or ((3264 - 2108) > (4717 - (45 + 327)))) then
						return "fire_elemental aoe 2";
					end
				end
				if (((4220 - 1983) < (4751 - (444 + 58))) and v101.StormElemental:IsReady() and v56 and ((v61 and v34) or not v61) and (v91 < v109)) then
					if (v25(v101.StormElemental) or ((1166 + 1517) < (4 + 19))) then
						return "storm_elemental aoe 4";
					end
				end
				if (((341 + 356) <= (2393 - 1567)) and v127(v101.Stormkeeper) and not v130() and v49 and ((v66 and v35) or not v66) and (v91 < v109)) then
					if (((2837 - (64 + 1668)) <= (3149 - (1227 + 746))) and v25(v101.Stormkeeper)) then
						return "stormkeeper aoe 7";
					end
				end
				if (((10385 - 7006) <= (7074 - 3262)) and v101.TotemicRecall:IsCastable() and (v101.LiquidMagmaTotem:CooldownRemains() > (539 - (415 + 79))) and v50) then
					if (v25(v101.TotemicRecall) or ((21 + 767) >= (2107 - (142 + 349)))) then
						return "totemic_recall aoe 8";
					end
				end
				v170 = 1 + 0;
			end
			if (((2549 - 695) <= (1680 + 1699)) and (v170 == (1 + 0))) then
				if (((12388 - 7839) == (6413 - (1710 + 154))) and v101.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v34) or not v62) and (v91 < v109) and (v67 == "cursor")) then
					if (v25(v103.LiquidMagmaTotemCursor, not v17:IsInRange(358 - (200 + 118))) or ((1198 + 1824) >= (5286 - 2262))) then
						return "liquid_magma_totem aoe cursor 10";
					end
				end
				if (((7149 - 2329) > (1953 + 245)) and v101.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v34) or not v62) and (v91 < v109) and (v67 == "player")) then
					if (v25(v103.LiquidMagmaTotemPlayer, not v17:IsInRange(40 + 0)) or ((570 + 491) >= (782 + 4109))) then
						return "liquid_magma_totem aoe player 11";
					end
				end
				if (((2954 - 1590) <= (5723 - (363 + 887))) and v127(v101.PrimordialWave) and v14:BuffDown(v101.PrimordialWaveBuff) and v14:BuffUp(v101.SurgeofPowerBuff) and v14:BuffDown(v101.SplinteredElementsBuff)) then
					if (v105.CastTargetIf(v101.PrimordialWave, v113, "min", v123, nil, not v17:IsSpellInRange(v101.PrimordialWave), nil, nil) or ((6277 - 2682) <= (14 - 11))) then
						return "primordial_wave aoe 12";
					end
					if (v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave)) or ((722 + 3950) == (9012 - 5160))) then
						return "primordial_wave aoe 12";
					end
				end
				if (((1066 + 493) == (3223 - (674 + 990))) and v127(v101.PrimordialWave) and v14:BuffDown(v101.PrimordialWaveBuff) and v101.DeeplyRootedElements:IsAvailable() and not v101.SurgeofPower:IsAvailable() and v14:BuffDown(v101.SplinteredElementsBuff)) then
					local v243 = 0 + 0;
					while true do
						if ((v243 == (0 + 0)) or ((2776 - 1024) <= (1843 - (507 + 548)))) then
							if (v105.CastTargetIf(v101.PrimordialWave, v113, "min", v123, nil, not v17:IsSpellInRange(v101.PrimordialWave), nil, nil) or ((4744 - (289 + 548)) == (1995 - (821 + 997)))) then
								return "primordial_wave aoe 14";
							end
							if (((3725 - (195 + 60)) > (150 + 405)) and v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave))) then
								return "primordial_wave aoe 14";
							end
							break;
						end
					end
				end
				v170 = 1503 - (251 + 1250);
			end
			if ((v170 == (14 - 9)) or ((668 + 304) == (1677 - (809 + 223)))) then
				if (((4643 - 1461) >= (6351 - 4236)) and v127(v101.ElementalBlast) and v40 and v101.EchoesofGreatSundering:IsAvailable()) then
					local v244 = 0 - 0;
					while true do
						if (((2867 + 1026) < (2320 + 2109)) and (v244 == (617 - (14 + 603)))) then
							if (v105.CastTargetIf(v101.ElementalBlast, v113, "min", v125, nil, not v17:IsSpellInRange(v101.ElementalBlast), nil, nil) or ((2996 - (118 + 11)) < (309 + 1596))) then
								return "elemental_blast aoe 52";
							end
							if (v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast)) or ((1496 + 300) >= (11805 - 7754))) then
								return "elemental_blast aoe 52";
							end
							break;
						end
					end
				end
				if (((2568 - (551 + 398)) <= (2374 + 1382)) and v127(v101.ElementalBlast) and v40 and v101.EchoesofGreatSundering:IsAvailable()) then
					if (((215 + 389) == (491 + 113)) and v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast aoe 54";
					end
				end
				if ((v127(v101.ElementalBlast) and v40 and (v115 == (11 - 8)) and not v101.EchoesofGreatSundering:IsAvailable()) or ((10331 - 5847) == (292 + 608))) then
					if (v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast)) or ((17701 - 13242) <= (308 + 805))) then
						return "elemental_blast aoe 56";
					end
				end
				if (((3721 - (40 + 49)) > (12940 - 9542)) and v101.EarthShock:IsCastable() and v39 and v101.EchoesofGreatSundering:IsAvailable()) then
					if (((4572 - (99 + 391)) <= (4068 + 849)) and v105.CastTargetIf(v101.EarthShock, v113, "min", v125, nil, not v17:IsSpellInRange(v101.EarthShock), nil, nil)) then
						return "earth_shock aoe 58";
					end
					if (((21241 - 16409) >= (3432 - 2046)) and v25(v101.EarthShock, not v17:IsSpellInRange(v101.EarthShock))) then
						return "earth_shock aoe 58";
					end
				end
				v170 = 6 + 0;
			end
			if (((360 - 223) == (1741 - (1032 + 572))) and (v170 == (421 - (203 + 214)))) then
				if ((v127(v101.LavaBurst) and v14:BuffUp(v101.LavaSurgeBuff) and v101.MasteroftheElements:IsAvailable() and not v128() and (v126() >= (((1877 - (568 + 1249)) - ((4 + 1) * v101.EyeoftheStorm:TalentRank())) - ((4 - 2) * v26(v101.FlowofPower:IsAvailable())))) and ((not v101.EchoesofGreatSundering:IsAvailable() and not v101.LightningRod:IsAvailable()) or v14:BuffUp(v101.EchoesofGreatSunderingBuff)) and ((not v14:BuffUp(v101.AscendanceBuff) and (v115 > (11 - 8)) and v101.UnrelentingCalamity:IsAvailable()) or ((v115 > (1309 - (913 + 393))) and not v101.UnrelentingCalamity:IsAvailable()) or (v115 == (8 - 5)))) or ((2218 - 648) >= (4742 - (269 + 141)))) then
					if (v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst)) or ((9038 - 4974) <= (3800 - (362 + 1619)))) then
						return "lava_burst aoe 44";
					end
					if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((6611 - (950 + 675)) < (607 + 967))) then
						return "lava_burst aoe 44";
					end
				end
				if (((5605 - (216 + 963)) > (1459 - (485 + 802))) and v38 and v101.Earthquake:IsReady() and not v101.EchoesofGreatSundering:IsAvailable() and (v115 > (562 - (432 + 127))) and ((v115 > (1076 - (1065 + 8))) or (v114 > (2 + 1)))) then
					if (((2187 - (635 + 966)) > (328 + 127)) and (v52 == "cursor")) then
						if (((868 - (5 + 37)) == (2054 - 1228)) and v25(v103.EarthquakeCursor, not v17:IsInRange(17 + 23))) then
							return "earthquake aoe 46";
						end
					end
					if ((v52 == "player") or ((6360 - 2341) > (2078 + 2363))) then
						if (((4191 - 2174) < (16154 - 11893)) and v25(v103.EarthquakePlayer, not v17:IsInRange(75 - 35))) then
							return "earthquake aoe 46";
						end
					end
				end
				if (((11275 - 6559) > (58 + 22)) and v38 and v101.Earthquake:IsReady() and not v101.EchoesofGreatSundering:IsAvailable() and not v101.ElementalBlast:IsAvailable() and (v115 == (532 - (318 + 211))) and ((v115 == (14 - 11)) or (v114 == (1590 - (963 + 624))))) then
					local v245 = 0 + 0;
					while true do
						if ((v245 == (846 - (518 + 328))) or ((8175 - 4668) == (5229 - 1957))) then
							if ((v52 == "cursor") or ((1193 - (301 + 16)) >= (9012 - 5937))) then
								if (((12222 - 7870) > (6664 - 4110)) and v25(v103.EarthquakeCursor, not v17:IsInRange(37 + 3))) then
									return "earthquake aoe 48";
								end
							end
							if ((v52 == "player") or ((2502 + 1904) < (8631 - 4588))) then
								if (v25(v103.EarthquakePlayer, not v17:IsInRange(25 + 15)) or ((180 + 1709) >= (10755 - 7372))) then
									return "earthquake aoe 48";
								end
							end
							break;
						end
					end
				end
				if (((611 + 1281) <= (3753 - (829 + 190))) and v38 and v101.Earthquake:IsReady() and (v14:BuffUp(v101.EchoesofGreatSunderingBuff))) then
					local v246 = 0 - 0;
					while true do
						if (((2432 - 509) < (3065 - 847)) and (v246 == (0 - 0))) then
							if (((515 + 1658) > (124 + 255)) and (v52 == "cursor")) then
								if (v25(v103.EarthquakeCursor, not v17:IsInRange(121 - 81)) or ((2445 + 146) == (4022 - (520 + 93)))) then
									return "earthquake aoe 50";
								end
							end
							if (((4790 - (259 + 17)) > (192 + 3132)) and (v52 == "player")) then
								if (v25(v103.EarthquakePlayer, not v17:IsInRange(15 + 25)) or ((704 - 496) >= (5419 - (396 + 195)))) then
									return "earthquake aoe 50";
								end
							end
							break;
						end
					end
				end
				v170 = 14 - 9;
			end
			if ((v170 == (1767 - (440 + 1321))) or ((3412 - (1059 + 770)) > (16494 - 12927))) then
				if ((v101.EarthShock:IsCastable() and v39 and v101.EchoesofGreatSundering:IsAvailable()) or ((1858 - (424 + 121)) == (145 + 649))) then
					if (((4521 - (641 + 706)) > (1150 + 1752)) and v25(v101.EarthShock, not v17:IsSpellInRange(v101.EarthShock))) then
						return "earth_shock aoe 60";
					end
				end
				if (((4560 - (249 + 191)) <= (18557 - 14297)) and v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (0 + 0)) and v43 and not v14:BuffUp(v101.AscendanceBuff) and v101.ElectrifiedShocks:IsAvailable() and ((v101.LightningRod:IsAvailable() and (v115 < (19 - 14)) and not v128()) or (v101.DeeplyRootedElements:IsAvailable() and (v115 == (430 - (183 + 244)))))) then
					if (v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury)) or ((44 + 839) > (5508 - (434 + 296)))) then
						return "icefury aoe 62";
					end
				end
				if ((v101.FrostShock:IsCastable() and v42 and not v14:BuffUp(v101.AscendanceBuff) and v14:BuffUp(v101.IcefuryBuff) and v101.ElectrifiedShocks:IsAvailable() and (not v17:DebuffUp(v101.ElectrifiedShocksDebuff) or (v14:BuffRemains(v101.IcefuryBuff) < v14:GCD())) and ((v101.LightningRod:IsAvailable() and (v115 < (15 - 10)) and not v128()) or (v101.DeeplyRootedElements:IsAvailable() and (v115 == (515 - (169 + 343)))))) or ((3174 + 446) >= (8605 - 3714))) then
					if (((12497 - 8239) > (768 + 169)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock aoe 64";
					end
				end
				if ((v127(v101.LavaBurst) and v101.MasteroftheElements:IsAvailable() and not v128() and (v130() or ((v119() < (8 - 5)) and v14:HasTier(1153 - (651 + 472), 2 + 0))) and (v126() < ((((26 + 34) - ((6 - 1) * v101.EyeoftheStorm:TalentRank())) - ((485 - (397 + 86)) * v26(v101.FlowofPower:IsAvailable()))) - (886 - (423 + 453)))) and (v115 < (1 + 4))) or ((642 + 4227) < (791 + 115))) then
					local v247 = 0 + 0;
					while true do
						if ((v247 == (0 + 0)) or ((2415 - (50 + 1140)) > (3655 + 573))) then
							if (((1965 + 1363) > (140 + 2098)) and v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst aoe 66";
							end
							if (((5512 - 1673) > (1017 + 388)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst aoe 66";
							end
							break;
						end
					end
				end
				v170 = 603 - (157 + 439);
			end
			if ((v170 == (2 - 0)) or ((4296 - 3003) <= (1499 - 992))) then
				if ((v127(v101.PrimordialWave) and v14:BuffDown(v101.PrimordialWaveBuff) and v101.MasteroftheElements:IsAvailable() and not v101.LightningRod:IsAvailable()) or ((3814 - (782 + 136)) < (1660 - (112 + 743)))) then
					local v248 = 1171 - (1026 + 145);
					while true do
						if (((398 + 1918) == (3034 - (493 + 225))) and (v248 == (0 - 0))) then
							if (v105.CastTargetIf(v101.PrimordialWave, v113, "min", v123, nil, not v17:IsSpellInRange(v101.PrimordialWave), nil, nil) or ((1564 + 1006) == (4109 - 2576))) then
								return "primordial_wave aoe 16";
							end
							if (v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave)) or ((17 + 866) == (4172 - 2712))) then
								return "primordial_wave aoe 16";
							end
							break;
						end
					end
				end
				if (v101.FlameShock:IsCastable() or ((1345 + 3274) <= (1668 - 669))) then
					local v249 = 1595 - (210 + 1385);
					while true do
						if ((v249 == (1689 - (1201 + 488))) or ((2114 + 1296) > (7320 - 3204))) then
							if ((v14:BuffUp(v101.SurgeofPowerBuff) and v41 and v101.LightningRod:IsAvailable() and v101.WindspeakersLavaResurgence:IsAvailable() and (v17:DebuffRemains(v101.FlameShockDebuff) < (v17:TimeToDie() - (28 - 12))) and (v112 < (590 - (352 + 233)))) or ((2182 - 1279) >= (1665 + 1394))) then
								local v276 = 0 - 0;
								while true do
									if (((574 - (489 + 85)) == v276) or ((5477 - (277 + 1224)) < (4350 - (663 + 830)))) then
										if (((4331 + 599) > (5649 - 3342)) and v105.CastCycle(v101.FlameShock, v113, v121, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 18";
										end
										if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((4921 - (461 + 414)) < (217 + 1074))) then
											return "flame_shock aoe 18";
										end
										break;
									end
								end
							end
							if ((v14:BuffUp(v101.SurgeofPowerBuff) and v41 and (not v101.LightningRod:IsAvailable() or v101.SkybreakersFieryDemise:IsAvailable()) and (v101.FlameShockDebuff:AuraActiveCount() < (3 + 3))) or ((405 + 3836) == (3495 + 50))) then
								local v277 = 250 - (172 + 78);
								while true do
									if (((0 - 0) == v277) or ((1490 + 2558) > (6106 - 1874))) then
										if (v105.CastCycle(v101.FlameShock, v113, v121, not v17:IsSpellInRange(v101.FlameShock)) or ((478 + 1272) >= (1161 + 2312))) then
											return "flame_shock aoe 20";
										end
										if (((5304 - 2138) == (3985 - 819)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 20";
										end
										break;
									end
								end
							end
							v249 = 1 + 0;
						end
						if (((975 + 788) < (1326 + 2398)) and ((11 - 8) == v249)) then
							if (((132 - 75) <= (835 + 1888)) and v101.DeeplyRootedElements:IsAvailable() and v41 and not v101.SurgeofPower:IsAvailable()) then
								local v278 = 0 + 0;
								while true do
									if ((v278 == (447 - (133 + 314))) or ((360 + 1710) == (656 - (199 + 14)))) then
										if (v105.CastCycle(v101.FlameShock, v113, v122, not v17:IsSpellInRange(v101.FlameShock)) or ((9683 - 6978) == (2942 - (647 + 902)))) then
											return "flame_shock aoe 30";
										end
										if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((13834 - 9233) < (294 - (85 + 148)))) then
											return "flame_shock aoe 30";
										end
										break;
									end
								end
							end
							break;
						end
						if ((v249 == (1290 - (426 + 863))) or ((6505 - 5115) >= (6398 - (873 + 781)))) then
							if ((v101.MasteroftheElements:IsAvailable() and v41 and not v101.LightningRod:IsAvailable() and not v101.SurgeofPower:IsAvailable() and (v101.FlameShockDebuff:AuraActiveCount() < (7 - 1))) or ((5409 - 3406) > (1589 + 2245))) then
								local v279 = 0 - 0;
								while true do
									if ((v279 == (0 - 0)) or ((463 - 307) > (5860 - (414 + 1533)))) then
										if (((170 + 25) == (750 - (443 + 112))) and v105.CastCycle(v101.FlameShock, v113, v121, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 22";
										end
										if (((4584 - (888 + 591)) >= (4640 - 2844)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 22";
										end
										break;
									end
								end
							end
							if (((250 + 4129) >= (8026 - 5895)) and v101.DeeplyRootedElements:IsAvailable() and v41 and not v101.SurgeofPower:IsAvailable() and (v101.FlameShockDebuff:AuraActiveCount() < (3 + 3))) then
								local v280 = 0 + 0;
								while true do
									if (((411 + 3433) >= (3893 - 1850)) and (v280 == (0 - 0))) then
										if (v105.CastCycle(v101.FlameShock, v113, v121, not v17:IsSpellInRange(v101.FlameShock)) or ((4910 - (136 + 1542)) <= (8955 - 6224))) then
											return "flame_shock aoe 24";
										end
										if (((4869 + 36) == (7799 - 2894)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 24";
										end
										break;
									end
								end
							end
							v249 = 2 + 0;
						end
						if (((488 - (68 + 418)) == v249) or ((11211 - 7075) >= (8002 - 3591))) then
							if ((v14:BuffUp(v101.SurgeofPowerBuff) and v41 and (not v101.LightningRod:IsAvailable() or v101.SkybreakersFieryDemise:IsAvailable())) or ((2554 + 404) == (5109 - (770 + 322)))) then
								local v281 = 0 + 0;
								while true do
									if (((356 + 872) >= (111 + 702)) and (v281 == (0 - 0))) then
										if (v105.CastCycle(v101.FlameShock, v113, v122, not v17:IsSpellInRange(v101.FlameShock)) or ((6698 - 3243) > (11030 - 6980))) then
											return "flame_shock aoe 26";
										end
										if (((893 - 650) == (136 + 107)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 26";
										end
										break;
									end
								end
							end
							if ((v101.MasteroftheElements:IsAvailable() and v41 and not v101.LightningRod:IsAvailable() and not v101.SurgeofPower:IsAvailable()) or ((405 - 134) > (755 + 817))) then
								local v282 = 0 + 0;
								while true do
									if (((2147 + 592) < (12400 - 9107)) and ((0 - 0) == v282)) then
										if (v105.CastCycle(v101.FlameShock, v113, v122, not v17:IsSpellInRange(v101.FlameShock)) or ((1333 + 2609) < (5223 - 4089))) then
											return "flame_shock aoe 28";
										end
										if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((8901 - 6208) == (2046 + 2927))) then
											return "flame_shock aoe 28";
										end
										break;
									end
								end
							end
							v249 = 14 - 11;
						end
					end
				end
				if (((2977 - (762 + 69)) == (6948 - 4802)) and v101.Ascendance:IsCastable() and v53 and ((v59 and v34) or not v59) and (v91 < v109)) then
					if (v25(v101.Ascendance) or ((1934 + 310) == (2088 + 1136))) then
						return "ascendance aoe 32";
					end
				end
				if ((v127(v101.LavaBurst) and (v115 == (7 - 4)) and not v101.LightningRod:IsAvailable() and v14:HasTier(10 + 21, 1 + 3)) or ((19106 - 14202) <= (2073 - (8 + 149)))) then
					if (((1410 - (1199 + 121)) <= (1802 - 737)) and v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 34";
					end
					if (((10840 - 6038) == (1978 + 2824)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 34";
					end
				end
				v170 = 10 - 7;
			end
			if ((v170 == (16 - 9)) or ((2018 + 262) <= (2318 - (518 + 1289)))) then
				if ((v127(v101.LavaBeam) and v44 and (v130())) or ((2873 - 1197) <= (62 + 401))) then
					if (((5650 - 1781) == (2850 + 1019)) and v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam))) then
						return "lava_beam aoe 68";
					end
				end
				if (((1627 - (304 + 165)) <= (2467 + 146)) and v127(v101.ChainLightning) and v37 and (v130())) then
					if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((2524 - (54 + 106)) <= (3968 - (1618 + 351)))) then
						return "chain_lightning aoe 70";
					end
				end
				if ((v127(v101.LavaBeam) and v44 and v129() and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) or ((3472 + 1450) < (1210 - (10 + 1006)))) then
					if (v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam)) or ((525 + 1566) < (5 + 26))) then
						return "lava_beam aoe 72";
					end
				end
				if ((v127(v101.ChainLightning) and v37 and v129()) or ((7878 - 5448) >= (5905 - (912 + 121)))) then
					if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((2255 + 2515) < (3024 - (1140 + 149)))) then
						return "chain_lightning aoe 74";
					end
				end
				v170 = 6 + 2;
			end
			if ((v170 == (13 - 3)) or ((826 + 3613) <= (8042 - 5692))) then
				if ((v127(v101.LavaBeam) and v44 and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) or ((8400 - 3921) < (771 + 3695))) then
					if (((8838 - 6291) > (1411 - (165 + 21))) and v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam))) then
						return "lava_beam aoe 92";
					end
				end
				if (((4782 - (61 + 50)) > (1102 + 1572)) and v127(v101.ChainLightning) and v37) then
					if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((17616 - 13920) < (6704 - 3377))) then
						return "chain_lightning aoe 94";
					end
				end
				if ((v101.FlameShock:IsCastable() and v41 and v14:IsMoving() and v17:DebuffRefreshable(v101.FlameShockDebuff)) or ((1785 + 2757) == (4430 - (1295 + 165)))) then
					if (((58 + 194) <= (795 + 1182)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock aoe 96";
					end
				end
				if ((v101.FrostShock:IsCastable() and v42 and v14:IsMoving()) or ((2833 - (819 + 578)) == (5177 - (331 + 1071)))) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((2361 - (588 + 155)) < (2212 - (546 + 736)))) then
						return "frost_shock aoe 98";
					end
				end
				break;
			end
			if (((6660 - (1834 + 103)) > (2555 + 1598)) and (v170 == (8 - 5))) then
				if ((v38 and v101.Earthquake:IsReady() and v128() and (((v14:BuffStack(v101.MagmaChamberBuff) > (1781 - (1536 + 230))) and (v115 >= ((498 - (128 + 363)) - v26(v101.UnrelentingCalamity:IsAvailable())))) or (v101.SplinteredElements:IsAvailable() and (v115 >= ((3 + 7) - v26(v101.UnrelentingCalamity:IsAvailable())))) or (v101.MountainsWillFall:IsAvailable() and (v115 >= (21 - 12)))) and not v101.LightningRod:IsAvailable() and v14:HasTier(9 + 22, 6 - 2)) or ((10757 - 7103) >= (11303 - 6649))) then
					if (((653 + 298) <= (2505 - (615 + 394))) and (v52 == "cursor")) then
						if (v25(v103.EarthquakeCursor, not v17:IsInRange(37 + 3)) or ((1655 + 81) == (1740 - 1169))) then
							return "earthquake aoe 36";
						end
					end
					if ((v52 == "player") or ((4064 - 3168) > (5420 - (59 + 592)))) then
						if (v25(v103.EarthquakePlayer, not v17:IsInRange(88 - 48)) or ((1923 - 878) <= (719 + 301))) then
							return "earthquake aoe 36";
						end
					end
				end
				if ((v127(v101.LavaBeam) and v44 and v130() and ((v14:BuffUp(v101.SurgeofPowerBuff) and (v115 >= (177 - (70 + 101)))) or (v128() and ((v115 < (14 - 8)) or not v101.SurgeofPower:IsAvailable()))) and not v101.LightningRod:IsAvailable() and v14:HasTier(22 + 9, 9 - 5)) or ((1401 - (123 + 118)) <= (80 + 248))) then
					if (((48 + 3760) > (4323 - (653 + 746))) and v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam))) then
						return "lava_beam aoe 38";
					end
				end
				if (((7277 - 3386) < (7086 - 2167)) and v127(v101.ChainLightning) and v37 and v130() and ((v14:BuffUp(v101.SurgeofPowerBuff) and (v115 >= (15 - 9))) or (v128() and ((v115 < (3 + 3)) or not v101.SurgeofPower:IsAvailable()))) and not v101.LightningRod:IsAvailable() and v14:HasTier(20 + 11, 4 + 0)) then
					if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((274 + 1960) <= (235 + 1267))) then
						return "chain_lightning aoe 40";
					end
				end
				if ((v127(v101.LavaBurst) and v14:BuffUp(v101.LavaSurgeBuff) and not v101.LightningRod:IsAvailable() and v14:HasTier(75 - 44, 4 + 0)) or ((4640 - 2128) < (1666 - (885 + 349)))) then
					local v250 = 0 + 0;
					while true do
						if ((v250 == (0 - 0)) or ((5375 - 3527) == (1833 - (915 + 53)))) then
							if (v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst)) or ((5483 - (768 + 33)) <= (17387 - 12846))) then
								return "lava_burst aoe 42";
							end
							if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((5326 - 2300) >= (4374 - (287 + 41)))) then
								return "lava_burst aoe 42";
							end
							break;
						end
					end
				end
				v170 = 851 - (638 + 209);
			end
			if (((1044 + 964) > (2324 - (96 + 1590))) and (v170 == (1680 - (741 + 931)))) then
				if (((872 + 903) <= (9210 - 5977)) and v127(v101.LavaBeam) and v44 and (v115 >= (27 - 21)) and v14:BuffUp(v101.SurgeofPowerBuff) and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) then
					if (v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam)) or ((1950 + 2593) == (859 + 1138))) then
						return "lava_beam aoe 76";
					end
				end
				if ((v127(v101.ChainLightning) and v37 and (v115 >= (2 + 4)) and v14:BuffUp(v101.SurgeofPowerBuff)) or ((11771 - 8669) < (237 + 491))) then
					if (((169 + 176) == (1407 - 1062)) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning aoe 78";
					end
				end
				if ((v127(v101.LavaBurst) and v14:BuffUp(v101.LavaSurgeBuff) and v101.DeeplyRootedElements:IsAvailable() and v14:BuffUp(v101.WindspeakersLavaResurgenceBuff)) or ((2537 + 290) < (872 - (64 + 430)))) then
					local v251 = 0 + 0;
					while true do
						if ((v251 == (363 - (106 + 257))) or ((2465 + 1011) < (3318 - (496 + 225)))) then
							if (((6295 - 3216) < (23352 - 18558)) and v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst aoe 80";
							end
							if (((6512 - (256 + 1402)) > (6363 - (30 + 1869))) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst aoe 80";
							end
							break;
						end
					end
				end
				if ((v127(v101.LavaBeam) and v44 and v128() and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) or ((6281 - (213 + 1156)) == (3946 - (96 + 92)))) then
					if (((22 + 104) <= (4381 - (142 + 757))) and v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam))) then
						return "lava_beam aoe 82";
					end
				end
				v170 = 8 + 1;
			end
		end
	end
	local function v139()
		local v171 = 0 + 0;
		while true do
			if ((v171 == (88 - (32 + 47))) or ((4351 - (1053 + 924)) == (4285 + 89))) then
				if (((2712 - 1137) == (3223 - (685 + 963))) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46) then
					if (v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt)) or ((4542 - 2308) == (2268 - 813))) then
						return "lightning_bolt single_target 110";
					end
				end
				if ((v101.FlameShock:IsCastable() and v41 and (v14:IsMoving())) or ((2776 - (541 + 1168)) > (3376 - (645 + 952)))) then
					if (((2999 - (669 + 169)) >= (3235 - 2301)) and v105.CastCycle(v101.FlameShock, v113, v120, not v17:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock single_target 112";
					end
					if (((3500 - 1888) == (545 + 1067)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock single_target 112";
					end
				end
				if (((960 + 3392) >= (3598 - (181 + 584))) and v101.FlameShock:IsCastable() and v41) then
					if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((4617 - (665 + 730)) < (8856 - 5783))) then
						return "flame_shock single_target 114";
					end
				end
				if (((1516 - 772) <= (4292 - (540 + 810))) and v101.FrostShock:IsCastable() and v42) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((7328 - 5495) <= (3634 - 2312))) then
						return "frost_shock single_target 116";
					end
				end
				break;
			end
			if ((v171 == (6 + 1)) or ((3670 - (166 + 37)) <= (2936 - (22 + 1859)))) then
				if (((5313 - (843 + 929)) == (3803 - (30 + 232))) and v127(v101.ElementalBlast) and v101.ElementalBlast:IsCastable() and v40) then
					if (v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast)) or ((10159 - 6602) >= (4780 - (55 + 722)))) then
						return "elemental_blast single_target 86";
					end
				end
				if ((v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and v129() and v101.UnrelentingCalamity:IsAvailable() and (v114 > (1 - 0)) and (v115 > (1676 - (78 + 1597)))) or ((145 + 512) >= (1518 + 150))) then
					if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((860 + 167) > (4407 - (305 + 244)))) then
						return "chain_lightning single_target 88";
					end
				end
				if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v129() and v101.UnrelentingCalamity:IsAvailable()) or ((3390 + 264) < (555 - (95 + 10)))) then
					if (((1340 + 551) < (14111 - 9658)) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
						return "lightning_bolt single_target 90";
					end
				end
				if ((v127(v101.Icefury) and v101.Icefury:IsCastable() and v43) or ((4295 - 1155) < (2891 - (592 + 170)))) then
					if (v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury)) or ((8911 - 6356) < (3114 - 1874))) then
						return "icefury single_target 92";
					end
				end
				if ((v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v101.LightningRodDebuff) and (v17:DebuffUp(v101.ElectrifiedShocksDebuff) or v129()) and (v114 > (1 + 0)) and (v115 > (1 + 0))) or ((11414 - 6687) <= (766 + 3956))) then
					if (((1371 - 631) < (5444 - (353 + 154))) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning single_target 94";
					end
				end
				if (((4868 - 1210) >= (382 - 102)) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v101.LightningRodDebuff) and (v17:DebuffUp(v101.ElectrifiedShocksDebuff) or v129())) then
					if (v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt)) or ((611 + 274) >= (808 + 223))) then
						return "lightning_bolt single_target 96";
					end
				end
				v171 = 6 + 2;
			end
			if (((5135 - 1581) >= (993 - 468)) and (v171 == (11 - 6))) then
				if (((2500 - (7 + 79)) <= (1391 + 1581)) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v101.MasteroftheElements:IsAvailable() and not v128() and ((v126() >= (256 - (24 + 157))) or ((v126() >= (99 - 49)) and not v101.ElementalBlast:IsAvailable())) and v101.SwellingMaelstrom:IsAvailable() and (v126() <= (277 - 147))) then
					if (((1003 + 2526) <= (9530 - 5992)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst single_target 62";
					end
				end
				if ((v101.Earthquake:IsReady() and v38 and v14:BuffUp(v101.EchoesofGreatSunderingBuff) and ((not v101.ElementalBlast:IsAvailable() and (v114 < (382 - (262 + 118)))) or (v114 > (1084 - (1038 + 45))))) or ((6187 - 3326) < (688 - (19 + 211)))) then
					local v252 = 113 - (88 + 25);
					while true do
						if (((4371 - 2654) <= (2246 + 2279)) and (v252 == (0 + 0))) then
							if ((v52 == "cursor") or ((4214 - (1007 + 29)) <= (411 + 1113))) then
								if (((10398 - 6144) > (1749 - 1379)) and v25(v103.EarthquakeCursor, not v17:IsInRange(9 + 31))) then
									return "earthquake single_target 64";
								end
							end
							if ((v52 == "player") or ((2446 - (340 + 471)) == (4475 - 2698))) then
								if (v25(v103.EarthquakePlayer, not v17:IsInRange(629 - (276 + 313))) or ((8148 - 4810) >= (3681 + 312))) then
									return "earthquake single_target 64";
								end
							end
							break;
						end
					end
				end
				if (((490 + 664) <= (139 + 1336)) and v101.Earthquake:IsReady() and v38 and (v114 > (1973 - (495 + 1477))) and (v115 > (2 - 1)) and not v101.EchoesofGreatSundering:IsAvailable() and not v101.ElementalBlast:IsAvailable()) then
					local v253 = 0 + 0;
					while true do
						if ((v253 == (403 - (342 + 61))) or ((1142 + 1468) < (1395 - (4 + 161)))) then
							if ((v52 == "cursor") or ((887 + 561) == (9677 - 6594))) then
								if (((8250 - 5111) > (1413 - (322 + 175))) and v25(v103.EarthquakeCursor, not v17:IsInRange(603 - (173 + 390)))) then
									return "earthquake single_target 66";
								end
							end
							if (((729 + 2225) == (3268 - (203 + 111))) and (v52 == "player")) then
								if (((8 + 109) <= (2040 + 852)) and v25(v103.EarthquakePlayer, not v17:IsInRange(116 - 76))) then
									return "earthquake single_target 66";
								end
							end
							break;
						end
					end
				end
				if ((v127(v101.ElementalBlast) and v101.ElementalBlast:IsCastable() and v40 and (not v101.MasteroftheElements:IsAvailable() or (v128() and v17:DebuffUp(v101.ElectrifiedShocksDebuff)))) or ((410 + 43) > (5368 - (57 + 649)))) then
					if (((1704 - (328 + 56)) > (191 + 404)) and v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast single_target 68";
					end
				end
				if ((v127(v101.FrostShock) and v42 and v131() and v128() and (v126() < (622 - (433 + 79))) and (v101.LavaBurst:ChargesFractional() < (1 + 0)) and v101.ElectrifiedShocks:IsAvailable() and v101.ElementalBlast:IsAvailable() and not v101.LightningRod:IsAvailable()) or ((2583 + 616) < (1984 - 1394))) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((22665 - 17872) < (22 + 8))) then
						return "frost_shock single_target 70";
					end
				end
				if ((v127(v101.ElementalBlast) and v101.ElementalBlast:IsCastable() and v40 and (v128() or v101.LightningRod:IsAvailable())) or ((1511 + 185) <= (2095 - (562 + 474)))) then
					if (((5465 - 3122) == (4773 - 2430)) and v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast single_target 72";
					end
				end
				v171 = 911 - (76 + 829);
			end
			if ((v171 == (1674 - (1506 + 167))) or ((1958 - 915) > (3857 - (58 + 208)))) then
				if ((v101.FlameShock:IsCastable() and v41 and (v101.FlameShockDebuff:AuraActiveCount() == (0 + 0)) and (v114 > (1 + 0)) and (v115 > (1 + 0)) and (v101.DeeplyRootedElements:IsAvailable() or v101.Ascendance:IsAvailable() or v101.PrimordialWave:IsAvailable() or v101.SearingFlames:IsAvailable() or v101.MagmaChamber:IsAvailable()) and ((not v128() and (v130() or (v101.Stormkeeper:CooldownRemains() > (0 - 0)))) or not v101.SurgeofPower:IsAvailable())) or ((3227 - (258 + 79)) >= (518 + 3561))) then
					local v254 = 0 - 0;
					while true do
						if (((5944 - (1219 + 251)) <= (6441 - (1231 + 440))) and (v254 == (58 - (34 + 24)))) then
							if (v105.CastTargetIf(v101.FlameShock, v113, "min", v123, nil, not v17:IsSpellInRange(v101.FlameShock)) or ((2867 + 2075) == (7285 - 3382))) then
								return "flame_shock single_target 14";
							end
							if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((109 + 139) > (14715 - 9870))) then
								return "flame_shock single_target 14";
							end
							break;
						end
					end
				end
				if (((5029 - 3460) == (4124 - 2555)) and v101.FlameShock:IsCastable() and v41 and (v114 > (3 - 2)) and (v115 > (2 - 1)) and (v101.DeeplyRootedElements:IsAvailable() or v101.Ascendance:IsAvailable() or v101.PrimordialWave:IsAvailable() or v101.SearingFlames:IsAvailable() or v101.MagmaChamber:IsAvailable()) and ((v14:BuffUp(v101.SurgeofPowerBuff) and not v130() and v101.Stormkeeper:CooldownDown()) or not v101.SurgeofPower:IsAvailable())) then
					local v255 = 1589 - (877 + 712);
					while true do
						if ((v255 == (0 + 0)) or ((5681 - (242 + 512)) <= (6731 - 3510))) then
							if (v105.CastTargetIf(v101.FlameShock, v113, "min", v123, v120, not v17:IsSpellInRange(v101.FlameShock)) or ((2407 - (92 + 535)) > (2195 + 592))) then
								return "flame_shock single_target 16";
							end
							if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((8109 - 4172) <= (77 + 1153))) then
								return "flame_shock single_target 16";
							end
							break;
						end
					end
				end
				if ((v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v101.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v109) and v14:BuffDown(v101.AscendanceBuff) and not v130() and (v126() >= (114 + 2)) and v101.ElementalBlast:IsAvailable() and v101.SurgeofPower:IsAvailable() and v101.SwellingMaelstrom:IsAvailable() and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.PrimordialSurge:IsAvailable()) or ((1826 + 811) < (240 + 1466))) then
					if (v25(v101.Stormkeeper) or ((5318 - 2649) <= (3671 - 1262))) then
						return "stormkeeper single_target 18";
					end
				end
				if ((v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (1785 - (1476 + 309))) and not v14:BuffUp(v101.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v109) and v14:BuffDown(v101.AscendanceBuff) and not v130() and v14:BuffUp(v101.SurgeofPowerBuff) and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.PrimordialSurge:IsAvailable()) or ((2685 - (299 + 985)) > (1116 + 3580))) then
					if (v25(v101.Stormkeeper) or ((10752 - 7472) < (1414 - (86 + 7)))) then
						return "stormkeeper single_target 20";
					end
				end
				if (((20135 - 15208) >= (219 + 2084)) and v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (880 - (672 + 208))) and not v14:BuffUp(v101.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v109) and v14:BuffDown(v101.AscendanceBuff) and not v130() and (not v101.SurgeofPower:IsAvailable() or not v101.ElementalBlast:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.EchooftheElements:IsAvailable() or v101.PrimordialSurge:IsAvailable())) then
					if (((1484 + 1978) >= (1164 - (14 + 118))) and v25(v101.Stormkeeper)) then
						return "stormkeeper single_target 22";
					end
				end
				if ((v101.Ascendance:IsCastable() and v53 and ((v59 and v34) or not v59) and (v91 < v109) and not v130()) or ((1522 - (339 + 106)) >= (1600 + 411))) then
					if (((777 + 766) < (3810 - (440 + 955))) and v25(v101.Ascendance)) then
						return "ascendance single_target 24";
					end
				end
				v171 = 2 + 0;
			end
			if ((v171 == (0 - 0)) or ((1475 + 2969) < (5016 - 3001))) then
				if ((v101.FireElemental:IsCastable() and v54 and ((v60 and v34) or not v60) and (v91 < v109)) or ((2877 + 1323) == (2685 - (260 + 93)))) then
					if (v25(v101.FireElemental) or ((1198 + 80) >= (3010 - 1694))) then
						return "fire_elemental single_target 2";
					end
				end
				if (((1953 - 871) == (3056 - (1181 + 793))) and v101.StormElemental:IsCastable() and v56 and ((v61 and v34) or not v61) and (v91 < v109)) then
					if (((339 + 989) <= (5185 - (105 + 202))) and v25(v101.StormElemental)) then
						return "storm_elemental single_target 4";
					end
				end
				if (((3277 + 810) >= (2165 - (352 + 458))) and v101.TotemicRecall:IsCastable() and v50 and (v101.LiquidMagmaTotem:CooldownRemains() > (181 - 136)) and ((v101.LavaSurge:IsAvailable() and v101.SplinteredElements:IsAvailable()) or ((v114 > (2 - 1)) and (v115 > (1 + 0))))) then
					if (v25(v101.TotemicRecall) or ((1724 - 1134) > (5599 - (438 + 511)))) then
						return "totemic_recall single_target 6";
					end
				end
				if ((v101.LiquidMagmaTotem:IsCastable() and v55 and ((v62 and v34) or not v62) and (v91 < v109) and ((v101.LavaSurge:IsAvailable() and v101.SplinteredElements:IsAvailable()) or (v101.FlameShockDebuff:AuraActiveCount() == (1383 - (1262 + 121))) or (v17:DebuffRemains(v101.FlameShockDebuff) < (1074 - (728 + 340))) or ((v114 > (1791 - (816 + 974))) and (v115 > (2 - 1))))) or ((13581 - 9807) <= (4006 - (163 + 176)))) then
					local v256 = 0 - 0;
					while true do
						if (((5836 - 4566) < (649 + 1497)) and ((1810 - (1564 + 246)) == v256)) then
							if (((4908 - (124 + 221)) >= (39 + 17)) and (v67 == "cursor")) then
								if (v25(v103.LiquidMagmaTotemCursor, not v17:IsInRange(491 - (115 + 336))) or ((981 - 535) == (129 + 493))) then
									return "liquid_magma_totem single_target cursor 8";
								end
							end
							if (((2115 - (45 + 1)) > (55 + 954)) and (v67 == "player")) then
								if (((2002 - (1282 + 708)) < (5420 - (583 + 629))) and v25(v103.LiquidMagmaTotemPlayer, not v17:IsInRange(7 + 33))) then
									return "liquid_magma_totem single_target player 8";
								end
							end
							break;
						end
					end
				end
				if ((v127(v101.PrimordialWave) and v101.PrimordialWave:IsCastable() and v48 and ((v65 and v35) or not v65) and not v14:BuffUp(v101.PrimordialWaveBuff) and not v14:BuffUp(v101.SplinteredElementsBuff)) or ((7735 - 4745) <= (1563 + 1417))) then
					local v257 = 1170 - (943 + 227);
					while true do
						if ((v257 == (0 + 0)) or ((4206 - (1539 + 92)) >= (6221 - (706 + 1240)))) then
							if (v105.CastCycle(v101.PrimordialWave, v113, v123, not v17:IsSpellInRange(v101.PrimordialWave)) or ((3884 - (81 + 177)) <= (3689 - 2383))) then
								return "primordial_wave single_target 10";
							end
							if (((1625 - (212 + 45)) < (12644 - 8864)) and v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave))) then
								return "primordial_wave single_target 10";
							end
							break;
						end
					end
				end
				if ((v101.FlameShock:IsCastable() and v41 and (v114 == (1947 - (708 + 1238))) and v17:DebuffRefreshable(v101.FlameShockDebuff) and ((v17:DebuffRemains(v101.FlameShockDebuff) < v101.PrimordialWave:CooldownRemains()) or not v101.PrimordialWave:IsAvailable()) and v14:BuffDown(v101.SurgeofPowerBuff) and (not v128() or (not v130() and ((v101.ElementalBlast:IsAvailable() and (v126() < ((8 + 82) - ((3 + 5) * v101.EyeoftheStorm:TalentRank())))) or (v126() < ((1727 - (586 + 1081)) - ((516 - (348 + 163)) * v101.EyeoftheStorm:TalentRank()))))))) or ((2847 + 322) == (2553 - (215 + 65)))) then
					if (((6321 - 3840) <= (5138 - (1541 + 318))) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock single_target 12";
					end
				end
				v171 = 1 + 0;
			end
			if ((v171 == (4 + 2)) or ((802 + 261) <= (2627 - (1036 + 714)))) then
				if (((1525 + 789) == (1278 + 1036)) and v101.EarthShock:IsCastable() and v39) then
					if (((2204 - (883 + 397)) >= (1067 - (563 + 27))) and v25(v101.EarthShock, not v17:IsSpellInRange(v101.EarthShock))) then
						return "earth_shock single_target 74";
					end
				end
				if (((7093 - 5280) <= (5764 - (1369 + 617))) and v127(v101.FrostShock) and v42 and v131() and v101.ElectrifiedShocks:IsAvailable() and v128() and not v101.LightningRod:IsAvailable() and (v114 > (1488 - (85 + 1402))) and (v115 > (1 + 0))) then
					if (((10712 - 6562) == (4553 - (274 + 129))) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single_target 76";
					end
				end
				if (((649 - (12 + 205)) <= (2744 + 263)) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and (v101.DeeplyRootedElements:IsAvailable())) then
					local v258 = 0 - 0;
					while true do
						if ((v258 == (0 + 0)) or ((792 - (27 + 357)) > (3201 - (91 + 389)))) then
							if (v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst)) or ((3715 - (90 + 207)) < (97 + 2400))) then
								return "lava_burst single_target 78";
							end
							if (((2596 - (706 + 155)) < (3964 - (730 + 1065))) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst single_target 78";
							end
							break;
						end
					end
				end
				if (((5453 - (1339 + 224)) >= (1660 + 1602)) and v101.FrostShock:IsCastable() and v42 and v131() and v101.FluxMelting:IsAvailable() and v14:BuffDown(v101.FluxMeltingBuff)) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((3878 + 478) >= (6920 - 2271))) then
						return "frost_shock single_target 80";
					end
				end
				if (((4747 - (268 + 575)) == (5198 - (919 + 375))) and v101.FrostShock:IsCastable() and v42 and v131() and ((v101.ElectrifiedShocks:IsAvailable() and (v17:DebuffRemains(v101.ElectrifiedShocksDebuff) < (5 - 3))) or (v14:BuffRemains(v101.IcefuryBuff) < (977 - (180 + 791))))) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((4665 - (323 + 1482)) >= (5707 - (1177 + 741)))) then
						return "frost_shock single_target 82";
					end
				end
				if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and (v101.EchooftheElements:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.PrimordialSurge:IsAvailable() or not v101.ElementalBlast:IsAvailable() or not v101.MasteroftheElements:IsAvailable() or v130())) or ((72 + 1014) > (16683 - 12234))) then
					local v259 = 0 + 0;
					while true do
						if (((11125 - 6144) > (46 + 500)) and (v259 == (109 - (96 + 13)))) then
							if (v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst)) or ((4287 - (962 + 959)) <= (19 - 11))) then
								return "lava_burst single_target 84";
							end
							if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((459 + 2131) == (4215 - (461 + 890)))) then
								return "lava_burst single_target 84";
							end
							break;
						end
					end
				end
				v171 = 6 + 1;
			end
			if (((15 - 11) == v171) or ((2867 - (19 + 224)) > (3761 + 388))) then
				if ((v101.FrostShock:IsCastable() and v42 and v131() and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.ElementalBlast:IsAvailable() and (((v126() >= (234 - (37 + 161))) and (v126() < (19 + 31)) and (v101.LavaBurst:CooldownRemains() > v14:GCD())) or ((v126() >= (10 + 14)) and (v126() < (38 + 0)) and v101.LavaBurst:CooldownUp()))) or ((2679 - (60 + 1)) >= (5418 - (826 + 97)))) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((2407 + 78) >= (11254 - 8123))) then
						return "frost_shock single_target 50";
					end
				end
				if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v14:BuffUp(v101.WindspeakersLavaResurgenceBuff) and (v101.EchooftheElements:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.PrimordialSurge:IsAvailable() or ((v126() >= (129 - 66)) and v101.MasteroftheElements:IsAvailable()) or ((v126() >= (723 - (375 + 310))) and v14:BuffUp(v101.EchoesofGreatSunderingBuff) and (v114 > (2000 - (1864 + 135))) and (v115 > (2 - 1))) or not v101.ElementalBlast:IsAvailable())) or ((621 + 2183) <= (932 + 1853))) then
					if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((11230 - 6659) == (4546 - (314 + 817)))) then
						return "lava_burst single_target 52";
					end
				end
				if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v14:BuffUp(v101.LavaSurgeBuff) and (v101.EchooftheElements:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.PrimordialSurge:IsAvailable() or not v101.MasteroftheElements:IsAvailable() or not v101.ElementalBlast:IsAvailable())) or ((2519 + 1922) > (5001 - (32 + 182)))) then
					if (((1419 + 501) == (6710 - 4790)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst single_target 54";
					end
				end
				if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v14:BuffUp(v101.AscendanceBuff) and (v14:HasTier(96 - (39 + 26), 148 - (54 + 90)) or not v101.ElementalBlast:IsAvailable())) or ((845 - (45 + 153)) == (2717 + 1760))) then
					if (((4371 - (457 + 95)) == (3795 + 24)) and v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst single_target 56";
					end
					if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((3059 - 1593) > (10537 - 6177))) then
						return "lava_burst single_target 56";
					end
				end
				if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v14:BuffDown(v101.AscendanceBuff) and (not v101.ElementalBlast:IsAvailable() or not v101.MountainsWillFall:IsAvailable()) and not v101.LightningRod:IsAvailable() and v14:HasTier(112 - 81, 2 + 2)) or ((48 - 34) > (3000 - 2006))) then
					local v260 = 748 - (485 + 263);
					while true do
						if (((1108 - (575 + 132)) <= (1595 - (750 + 111))) and (v260 == (1010 - (445 + 565)))) then
							if (v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst)) or ((1744 + 423) >= (492 + 2934))) then
								return "lava_burst single_target 58";
							end
							if (((1349 - 585) < (1097 + 2188)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst single_target 58";
							end
							break;
						end
					end
				end
				if (((2809 - (189 + 121)) == (619 + 1880)) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v101.MasteroftheElements:IsAvailable() and not v128() and not v101.LightningRod:IsAvailable()) then
					local v261 = 1347 - (634 + 713);
					while true do
						if ((v261 == (538 - (493 + 45))) or ((1660 - (493 + 475)) >= (1261 + 3672))) then
							if (v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst)) or ((3938 - (158 + 626)) <= (1063 + 1197))) then
								return "lava_burst single_target 60";
							end
							if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((4360 - 1723) > (701 + 2448))) then
								return "lava_burst single_target 60";
							end
							break;
						end
					end
				end
				v171 = 1 + 4;
			end
			if (((1094 - (1035 + 56)) == v171) or ((4951 - (114 + 845)) < (938 + 1469))) then
				if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v14:BuffUp(v101.SurgeofPowerBuff) and v101.LightningRod:IsAvailable()) or ((7428 - 4526) > (4085 + 774))) then
					if (((2728 - (179 + 870)) < (6113 - 1754)) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
						return "lightning_bolt single_target 38";
					end
				end
				if (((2791 - (827 + 51)) < (12349 - 7679)) and v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (0 + 0)) and v43 and v101.ElectrifiedShocks:IsAvailable() and v101.LightningRod:IsAvailable() and v101.LightningRod:IsAvailable()) then
					if (v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury)) or ((3319 - (95 + 378)) < (64 + 815))) then
						return "icefury single_target 40";
					end
				end
				if (((6501 - 1913) == (4030 + 558)) and v101.FrostShock:IsCastable() and v42 and v131() and v101.ElectrifiedShocks:IsAvailable() and ((v17:DebuffRemains(v101.ElectrifiedShocksDebuff) < (1013 - (334 + 677))) or (v14:BuffRemains(v101.IcefuryBuff) <= v14:GCD())) and v101.LightningRod:IsAvailable()) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((1298 - 951) == (3121 - (1049 + 7)))) then
						return "frost_shock single_target 42";
					end
				end
				if ((v101.FrostShock:IsCastable() and v42 and v131() and v101.ElectrifiedShocks:IsAvailable() and (v126() >= (218 - 168)) and (v17:DebuffRemains(v101.ElectrifiedShocksDebuff) < ((3 - 1) * v14:GCD())) and v130() and v101.LightningRod:IsAvailable()) or ((409 + 902) > (7230 - 4533))) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((5442 - 2725) > (1690 + 2105))) then
						return "frost_shock single_target 44";
					end
				end
				if ((v101.LavaBeam:IsCastable() and v44 and (v114 > (1421 - (1004 + 416))) and (v115 > (1958 - (1621 + 336))) and v129() and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime()) and not v14:HasTier(1970 - (337 + 1602), 1521 - (1014 + 503))) or ((2096 - (446 + 569)) < (17 + 374))) then
					if (v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam)) or ((354 - 233) > (1155 + 2283))) then
						return "lava_beam single_target 46";
					end
				end
				if (((147 - 76) < (40 + 1909)) and v101.FrostShock:IsCastable() and v42 and v131() and v130() and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.PrimordialSurge:IsAvailable() and v101.ElementalBlast:IsAvailable() and (((v126() >= (566 - (223 + 282))) and (v126() < (3 + 72)) and (v101.LavaBurst:CooldownRemains() > v14:GCD())) or ((v126() >= (77 - 28)) and (v126() < (91 - 28)) and (v101.LavaBurst:CooldownRemains() > (670 - (623 + 47)))))) then
					if (((4299 - (32 + 13)) == (2385 + 1869)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single_target 48";
					end
				end
				v171 = 4 + 0;
			end
			if (((4997 - (1070 + 731)) >= (2437 + 113)) and (v171 == (1406 - (1257 + 147)))) then
				if (((974 + 1482) < (7986 - 3810)) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v130() and v14:BuffUp(v101.SurgeofPowerBuff)) then
					if (v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt)) or ((1283 - (98 + 35)) == (1448 + 2004))) then
						return "lightning_bolt single_target 26";
					end
				end
				if (((6640 - 4765) < (7598 - 5340)) and v101.LavaBeam:IsCastable() and v44 and (v114 > (1 + 0)) and (v115 > (1 + 0)) and v130() and not v101.SurgeofPower:IsAvailable()) then
					if (((514 + 659) > (598 - (395 + 162))) and v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam))) then
						return "lava_beam single_target 28";
					end
				end
				if ((v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and (v114 > (1 + 0)) and (v115 > (1942 - (816 + 1125))) and v130() and not v101.SurgeofPower:IsAvailable()) or ((79 - 23) >= (4356 - (701 + 447)))) then
					if (((6643 - 2330) > (5895 - 2522)) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning single_target 30";
					end
				end
				if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v130() and not v128() and not v101.SurgeofPower:IsAvailable() and v101.MasteroftheElements:IsAvailable()) or ((5834 - (391 + 950)) == (5996 - 3771))) then
					if (((7779 - 4675) >= (7618 - 4526)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst single_target 32";
					end
				end
				if (((2489 + 1059) > (1803 + 1295)) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v130() and not v101.SurgeofPower:IsAvailable() and v128()) then
					if (v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt)) or ((11890 - 8638) == (2025 - (251 + 1271)))) then
						return "lightning_bolt single_target 34";
					end
				end
				if (((4214 + 519) > (5531 - 3465)) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v130() and not v101.SurgeofPower:IsAvailable() and not v101.MasteroftheElements:IsAvailable()) then
					if (((8886 - 5337) >= (1516 - 600)) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
						return "lightning_bolt single_target 36";
					end
				end
				v171 = 1262 - (1147 + 112);
			end
			if (((2 + 6) == v171) or ((4445 - 2256) <= (64 + 181))) then
				if ((v101.FrostShock:IsCastable() and v42 and v131() and v128() and v14:BuffDown(v101.LavaSurgeBuff) and not v101.ElectrifiedShocks:IsAvailable() and not v101.FluxMelting:IsAvailable() and (v101.LavaBurst:ChargesFractional() < (698 - (335 + 362))) and v101.EchooftheElements:IsAvailable()) or ((1302 + 87) > (5908 - 1983))) then
					if (((11378 - 7209) >= (11448 - 8367)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single_target 98";
					end
				end
				if (((1699 - 1350) <= (2537 - 1643)) and v101.FrostShock:IsCastable() and v42 and v131() and (v101.FluxMelting:IsAvailable() or (v101.ElectrifiedShocks:IsAvailable() and not v101.LightningRod:IsAvailable()))) then
					if (((1297 - (237 + 329)) <= (10665 - 7687)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock single_target 100";
					end
				end
				if ((v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and v128() and v14:BuffDown(v101.LavaSurgeBuff) and (v101.LavaBurst:ChargesFractional() < (1 + 0)) and v101.EchooftheElements:IsAvailable() and (v114 > (1 + 0)) and (v115 > (1125 - (408 + 716)))) or ((3388 - 2496) > (4713 - (344 + 477)))) then
					if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((761 + 3705) == (2661 - (1188 + 573)))) then
						return "chain_lightning single_target 102";
					end
				end
				if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v128() and v14:BuffDown(v101.LavaSurgeBuff) and (v101.LavaBurst:ChargesFractional() < (2 - 1)) and v101.EchooftheElements:IsAvailable()) or ((2031 + 53) >= (9369 - 6481))) then
					if (((739 - 260) < (4607 - 2744)) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
						return "lightning_bolt single_target 104";
					end
				end
				if ((v101.FrostShock:IsCastable() and v42 and v131() and not v101.ElectrifiedShocks:IsAvailable() and not v101.FluxMelting:IsAvailable()) or ((3957 - (508 + 1021)) >= (3795 + 243))) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((4044 - (228 + 938)) > (3582 - (332 + 353)))) then
						return "frost_shock single_target 106";
					end
				end
				if ((v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and (v114 > (1 - 0)) and (v115 > (2 - 1))) or ((2340 + 129) > (1844 + 1832))) then
					if (((931 - 698) < (910 - (18 + 405))) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning single_target 108";
					end
				end
				v171 = 5 + 4;
			end
		end
	end
	local function v140()
		local v172 = 0 + 0;
		while true do
			if (((3768 - 1295) >= (1179 - (194 + 784))) and ((1771 - (694 + 1076)) == v172)) then
				if (((6024 - (122 + 1782)) >= (126 + 7)) and v31) then
					return v31;
				end
				if (((2871 + 209) >= (1788 + 198)) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v14:CanAttack(v17)) then
					if (v25(v101.AncestralSpirit, nil, true) or ((1033 + 406) > (10364 - 6826))) then
						return "ancestral_spirit";
					end
				end
				v172 = 2 + 0;
			end
			if ((v172 == (1973 - (214 + 1756))) or ((2025 - 1606) < (1 + 6))) then
				if (((156 + 2664) == (3405 - (217 + 368))) and v101.ImprovedFlametongueWeapon:IsAvailable() and v101.FlametongueWeapon:IsCastable() and v51 and (not v110 or (v111 < (1812724 - 1212724))) and v101.FlametongueWeapon:IsAvailable()) then
					if (v25(v101.FlametongueWeapon) or ((2873 + 1489) <= (2617 + 910))) then
						return "flametongue_weapon enchant";
					end
				end
				if (((89 + 2524) <= (3569 - (844 + 45))) and not v14:AffectingCombat() and v32 and v105.TargetIsValid()) then
					local v262 = 284 - (242 + 42);
					while true do
						if ((v262 == (0 - 0)) or ((3444 - 1962) >= (5488 - (132 + 1068)))) then
							v31 = v137();
							if (v31 or ((3930 - 1468) > (6049 - (214 + 1409)))) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if (((3693 + 1081) == (6408 - (497 + 1137))) and ((942 - (9 + 931)) == v172)) then
				if (((855 - (181 + 108)) <= (572 + 388)) and v101.AncestralSpirit:IsCastable() and v101.AncestralSpirit:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
					if (v25(v103.AncestralSpiritMouseover) or ((7176 - 4266) <= (5731 - 3801))) then
						return "ancestral_spirit mouseover";
					end
				end
				v110, v111 = v30();
				v172 = 1 + 2;
			end
			if ((v172 == (0 + 0)) or ((495 - (296 + 180)) > (1855 - (1183 + 220)))) then
				if ((v74 and v101.EarthShield:IsCastable() and v14:BuffDown(v101.EarthShieldBuff) and ((v75 == "Earth Shield") or (v101.ElementalOrbit:IsAvailable() and v14:BuffUp(v101.LightningShield)))) or ((2172 - (1037 + 228)) > (5101 - 1949))) then
					if (v25(v101.EarthShield) or ((7219 - 4714) > (15273 - 10803))) then
						return "earth_shield main 2";
					end
				elseif ((v74 and v101.LightningShield:IsCastable() and v14:BuffDown(v101.LightningShieldBuff) and ((v75 == "Lightning Shield") or (v101.ElementalOrbit:IsAvailable() and v14:BuffUp(v101.EarthShield)))) or ((4445 - (527 + 207)) > (4589 - (187 + 340)))) then
					if (((2290 - (1298 + 572)) == (1044 - 624)) and v25(v101.LightningShield)) then
						return "lightning_shield main 2";
					end
				end
				v31 = v134();
				v172 = 171 - (144 + 26);
			end
		end
	end
	local function v141()
		local v173 = 0 - 0;
		while true do
			if ((v173 == (6 - 3)) or ((12 + 21) >= (9523 - 6029))) then
				if ((v101.Purge:IsReady() and v98 and v36 and v84 and not v14:IsCasting() and not v14:IsChanneling() and v105.UnitHasMagicBuff(v17)) or ((2941 - 1674) == (22997 - 18253))) then
					if (((1234 + 1194) < (5127 - 1349)) and v25(v101.Purge, not v17:IsSpellInRange(v101.Purge))) then
						return "purge damage";
					end
				end
				if ((v105.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((2751 + 195) <= (598 + 998))) then
					local v263 = 202 - (5 + 197);
					local v264;
					while true do
						if (((5119 - (339 + 347)) > (7086 - 3959)) and (v263 == (0 - 0))) then
							if (((4676 - (365 + 11)) >= (2590 + 143)) and (v91 < v109) and v58 and ((v64 and v34) or not v64)) then
								local v283 = 0 - 0;
								while true do
									if (((11333 - 6504) == (5753 - (837 + 87))) and (v283 == (3 - 1))) then
										if (((3353 - (837 + 833)) <= (1009 + 3717)) and v101.BagofTricks:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff))) then
											if (((6222 - (356 + 1031)) >= (1669 + 2000)) and v25(v101.BagofTricks)) then
												return "bag_of_tricks main 10";
											end
										end
										break;
									end
									if (((4497 - (73 + 1573)) > (3247 - (1307 + 81))) and (v283 == (234 - (7 + 227)))) then
										if (((6320 - 2472) > (2489 - (90 + 76))) and v101.BloodFury:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (156 - 106)))) then
											if (((1390 + 1446) > (388 + 81)) and v25(v101.BloodFury)) then
												return "blood_fury main 2";
											end
										end
										if ((v101.Berserking:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff))) or ((1743 + 353) <= (2115 - 1575))) then
											if (v25(v101.Berserking) or ((3443 - (197 + 63)) < (559 + 2086))) then
												return "berserking main 4";
											end
										end
										v283 = 1 + 0;
									end
									if (((1686 + 1544) <= (618 + 3142)) and ((1 - 0) == v283)) then
										if (((5197 - (618 + 751)) == (2864 + 964)) and v101.Fireblood:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (1960 - (206 + 1704))))) then
											if (((933 - 379) == (1105 - 551)) and v25(v101.Fireblood)) then
												return "fireblood main 6";
											end
										end
										if ((v101.AncestralCall:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (22 + 28)))) or ((3838 - (155 + 1120)) == (1678 - (396 + 1110)))) then
											if (((8783 - 4894) >= (43 + 88)) and v25(v101.AncestralCall)) then
												return "ancestral_call main 8";
											end
										end
										v283 = 2 + 0;
									end
								end
							end
							if ((v91 < v109) or ((422 + 70) == (5554 - (230 + 746)))) then
								if ((v57 and ((v34 and v63) or not v63)) or ((4713 - (473 + 128)) < (1864 - (39 + 9)))) then
									v31 = v136();
									if (((4791 - (38 + 228)) >= (2221 - 998)) and v31) then
										return v31;
									end
								end
							end
							v263 = 474 - (106 + 367);
						end
						if (((97 + 993) <= (6689 - (354 + 1508))) and (v263 == (9 - 6))) then
							if (true or ((175 + 64) > (789 + 556))) then
								local v284 = 0 - 0;
								while true do
									if ((v284 == (1244 - (334 + 910))) or ((4605 - (92 + 803)) >= (2060 + 1678))) then
										v31 = v139();
										if (v31 or ((5019 - (1035 + 146)) < (2677 - (230 + 386)))) then
											return v31;
										end
										v284 = 1 + 0;
									end
									if ((v284 == (1511 - (353 + 1157))) or ((1804 - (53 + 1061)) > (2807 - (1568 + 67)))) then
										if (v25(v101.Pool) or ((727 + 865) > (372 + 2227))) then
											return "Pool for SingleTarget()";
										end
										break;
									end
								end
							end
							break;
						end
						if (((9047 - 5473) <= (12937 - 8540)) and (v263 == (4 - 2))) then
							if (((2959 + 176) > (2542 - (615 + 597))) and v264) then
								return v264;
							end
							if ((v33 and (v114 > (2 + 0)) and (v115 > (2 - 0))) or ((3207 + 693) <= (73 + 3568))) then
								local v285 = 0 + 0;
								while true do
									if (((3623 - (1056 + 843)) == (3759 - 2035)) and (v285 == (1 - 0))) then
										if (((1305 - 850) <= (750 + 532)) and v25(v101.Pool)) then
											return "Pool for Aoe()";
										end
										break;
									end
									if (((6582 - (286 + 1690)) < (5787 - (98 + 813))) and ((0 + 0) == v285)) then
										v31 = v138();
										if (v31 or ((3497 - 2055) > (1498 + 1142))) then
											return v31;
										end
										v285 = 508 - (263 + 244);
									end
								end
							end
							v263 = 3 + 0;
						end
						if (((1823 - (1502 + 185)) < (700 + 2968)) and (v263 == (4 - 3))) then
							if ((v101.NaturesSwiftness:IsCastable() and v47) or ((4732 - 2948) > (6308 - (629 + 898)))) then
								if (((12486 - 7901) > (8477 - 5179)) and v25(v101.NaturesSwiftness)) then
									return "natures_swiftness main 12";
								end
							end
							v264 = v105.HandleDPSPotion(v14:BuffUp(v101.AscendanceBuff));
							v263 = 367 - (12 + 353);
						end
					end
				end
				break;
			end
			if ((v173 == (1913 - (1680 + 231))) or ((106 + 1558) > (1040 + 658))) then
				if (v85 or ((4576 - (212 + 937)) < (1899 + 950))) then
					local v265 = 1062 - (111 + 951);
					while true do
						if (((735 + 2881) <= (4456 - (18 + 9))) and (v265 == (0 + 0))) then
							if (((4522 - (31 + 503)) >= (1698 - (595 + 1037))) and v18) then
								local v286 = 1444 - (189 + 1255);
								while true do
									if ((v286 == (0 + 0)) or ((1333 - 471) > (5923 - (1170 + 109)))) then
										v31 = v133();
										if (((3038 - (348 + 1469)) == (2510 - (1115 + 174))) and v31) then
											return v31;
										end
										break;
									end
								end
							end
							if ((v15 and v15:Exists() and not v14:CanAttack(v15) and (v105.UnitHasDispellableDebuffByPlayer(v15) or v105.UnitHasCurseDebuff(v15))) or ((109 - 64) > (2285 - (85 + 929)))) then
								if (((2275 + 1602) > (3397 - (1151 + 716))) and v101.CleanseSpirit:IsCastable()) then
									if (v25(v103.CleanseSpiritMouseover, not v15:IsSpellInRange(v101.PurifySpirit)) or ((1646 + 3152) == (1225 + 30))) then
										return "purify_spirit dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				if ((v101.GreaterPurge:IsAvailable() and v98 and v101.GreaterPurge:IsReady() and v36 and v84 and not v14:IsCasting() and not v14:IsChanneling() and v105.UnitHasMagicBuff(v17)) or ((4245 - (95 + 1609)) > (10323 - 7463))) then
					if (v25(v101.GreaterPurge, not v17:IsSpellInRange(v101.GreaterPurge)) or ((3660 - (364 + 394)) > (3289 + 340))) then
						return "greater_purge damage";
					end
				end
				v173 = 1 + 2;
			end
			if (((88 + 339) < (2821 + 647)) and (v173 == (0 + 0))) then
				v31 = v135();
				if (((2137 + 2053) >= (1055 + 1749)) and v31) then
					return v31;
				end
				v173 = 1 + 0;
			end
			if (((659 + 1427) == (3042 - (719 + 237))) and ((2 - 1) == v173)) then
				if (((3425 + 723) > (6774 - 4041)) and v86) then
					local v266 = 0 - 0;
					while true do
						if (((7257 - 4203) >= (3596 - (761 + 1230))) and ((194 - (80 + 113)) == v266)) then
							if (((568 + 476) < (1019 + 500)) and v83) then
								local v287 = 0 + 0;
								while true do
									if (((6851 - 5144) <= (972 + 3228)) and (v287 == (0 + 0))) then
										v31 = v105.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 1273 - (965 + 278));
										if (((2309 - (1391 + 338)) == (1481 - 901)) and v31) then
											return v31;
										end
										break;
									end
								end
							end
							break;
						end
						if (((585 + 16) <= (2165 - 1166)) and (v266 == (0 + 0))) then
							if (((5378 - (496 + 912)) == (13071 - 9101)) and v81) then
								v31 = v105.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 10 + 30);
								if (v31 or ((185 - 87) == (1538 - (1190 + 140)))) then
									return v31;
								end
							end
							if (((965 + 1041) <= (4632 - (317 + 401))) and v82) then
								local v288 = 949 - (303 + 646);
								while true do
									if ((v288 == (0 - 0)) or ((4833 - (1675 + 57)) <= (1914 + 1057))) then
										v31 = v105.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 78 - 48);
										if (v31 or ((259 + 1814) <= (1648 - (338 + 639)))) then
											return v31;
										end
										break;
									end
								end
							end
							v266 = 380 - (320 + 59);
						end
					end
				end
				if (((1689 + 1616) > (827 - (628 + 104))) and v87) then
					v31 = v105.HandleIncorporeal(v101.Hex, v103.HexMouseOver, 37 - 7, true);
					if (((4618 - (439 + 1452)) == (4674 - (105 + 1842))) and v31) then
						return v31;
					end
				end
				v173 = 9 - 7;
			end
		end
	end
	local function v142()
		local v174 = 0 - 0;
		while true do
			if ((v174 == (19 - 15)) or ((126 + 2844) >= (6987 - 2915))) then
				v53 = EpicSettings.Settings['useAscendance'];
				v55 = EpicSettings.Settings['useLiquidMagmaTotem'];
				v54 = EpicSettings.Settings['useFireElemental'];
				v56 = EpicSettings.Settings['useStormElemental'];
				v174 = 3 + 2;
			end
			if (((5045 - (274 + 890)) > (708 + 106)) and (v174 == (0 + 0))) then
				v37 = EpicSettings.Settings['useChainlightning'];
				v38 = EpicSettings.Settings['useEarthquake'];
				v39 = EpicSettings.Settings['useEarthShock'];
				v40 = EpicSettings.Settings['useElementalBlast'];
				v174 = 1 + 0;
			end
			if ((v174 == (4 + 2)) or ((2880 + 2052) < (6881 - 2013))) then
				v65 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v66 = EpicSettings.Settings['stormkeeperWithMiniCD'];
				break;
			end
			if (((4486 - (731 + 88)) <= (3840 + 962)) and (v174 == (2 + 0))) then
				v45 = EpicSettings.Settings['useLavaBurst'];
				v46 = EpicSettings.Settings['useLightningBolt'];
				v47 = EpicSettings.Settings['useNaturesSwiftness'];
				v48 = EpicSettings.Settings['usePrimordialWave'];
				v174 = 1 + 2;
			end
			if (((1840 - 580) >= (2674 - 1816)) and ((2 - 1) == v174)) then
				v41 = EpicSettings.Settings['useFlameShock'];
				v42 = EpicSettings.Settings['useFrostShock'];
				v43 = EpicSettings.Settings['useIceFury'];
				v44 = EpicSettings.Settings['useLavaBeam'];
				v174 = 3 - 1;
			end
			if ((v174 == (3 + 0)) or ((17 + 3894) == (845 + 3855))) then
				v49 = EpicSettings.Settings['useStormkeeper'];
				v50 = EpicSettings.Settings['useTotemicRecall'];
				v51 = EpicSettings.Settings['useWeaponEnchant'];
				v92 = EpicSettings.Settings['useWeapon'];
				v174 = 3 + 1;
			end
			if (((3158 - (139 + 19)) < (748 + 3446)) and (v174 == (1998 - (1687 + 306)))) then
				v59 = EpicSettings.Settings['ascendanceWithCD'];
				v62 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
				v60 = EpicSettings.Settings['fireElementalWithCD'];
				v61 = EpicSettings.Settings['stormElementalWithCD'];
				v174 = 21 - 15;
			end
		end
	end
	local function v143()
		v68 = EpicSettings.Settings['useWindShear'];
		v69 = EpicSettings.Settings['useCapacitorTotem'];
		v70 = EpicSettings.Settings['useThunderstorm'];
		v71 = EpicSettings.Settings['useAncestralGuidance'];
		v72 = EpicSettings.Settings['useAstralShift'];
		v73 = EpicSettings.Settings['useHealingStreamTotem'];
		v76 = EpicSettings.Settings['ancestralGuidanceHP'] or (1154 - (1018 + 136));
		v77 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
		v78 = EpicSettings.Settings['astralShiftHP'] or (0 - 0);
		v79 = EpicSettings.Settings['healingStreamTotemHP'] or (815 - (117 + 698));
		v80 = EpicSettings.Settings['healingStreamTotemGroup'] or (481 - (305 + 176));
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
		local v187 = 0 + 0;
		while true do
			if (((1128 - 477) < (4159 + 283)) and ((0 - 0) == v187)) then
				v91 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v88 = EpicSettings.Settings['InterruptWithStun'];
				v89 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v187 = 1 - 0;
			end
			if ((v187 == (264 - (159 + 101))) or ((940 - 745) >= (6248 - 4444))) then
				v96 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v95 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v97 = EpicSettings.Settings['HealingPotionName'] or "";
				v187 = 9 - 4;
			end
			if ((v187 == (1 + 4)) or ((1648 - (112 + 154)) > (5139 - 2923))) then
				v86 = EpicSettings.Settings['handleAfflicted'];
				v87 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v187 == (33 - (21 + 10))) or ((4580 - (531 + 1188)) == (2102 + 357))) then
				v57 = EpicSettings.Settings['useTrinkets'];
				v58 = EpicSettings.Settings['useRacials'];
				v63 = EpicSettings.Settings['trinketsWithCD'];
				v187 = 666 - (96 + 567);
			end
			if (((2747 - 844) < (1663 + 2358)) and ((3 - 2) == v187)) then
				v90 = EpicSettings.Settings['InterruptThreshold'];
				v85 = EpicSettings.Settings['DispelDebuffs'];
				v84 = EpicSettings.Settings['DispelBuffs'];
				v187 = 1697 - (867 + 828);
			end
			if (((6 - 3) == v187) or ((8231 - 5961) >= (9222 - 5092))) then
				v64 = EpicSettings.Settings['racialsWithCD'];
				v94 = EpicSettings.Settings['useHealthstone'];
				v93 = EpicSettings.Settings['useHealingPotion'];
				v187 = 5 - 1;
			end
		end
	end
	local function v145()
		local v188 = 0 + 0;
		while true do
			if (((4622 - 2029) <= (4729 - (134 + 637))) and (v188 == (1 + 1))) then
				if (((2333 - (775 + 382)) == (1683 - 507)) and v14:IsDeadOrGhost()) then
					return v31;
				end
				v112 = v14:GetEnemiesInRange(647 - (45 + 562));
				v113 = v17:GetEnemiesInSplashRange(867 - (545 + 317));
				if (v33 or ((4548 - 1486) == (2844 - (763 + 263)))) then
					v114 = #v112;
					v115 = v28(v17:GetEnemiesInSplashRangeCount(2 + 3), v114);
				else
					local v267 = 1750 - (512 + 1238);
					while true do
						if ((v267 == (1594 - (272 + 1322))) or ((6962 - 3245) < (4395 - (533 + 713)))) then
							v114 = 29 - (14 + 14);
							v115 = 826 - (499 + 326);
							break;
						end
					end
				end
				v188 = 4 - 1;
			end
			if (((3619 - (104 + 320)) < (5727 - (1929 + 68))) and (v188 == (1323 - (1206 + 117)))) then
				v143();
				v142();
				v144();
				v32 = EpicSettings.Toggles['ooc'];
				v188 = 1 + 0;
			end
			if (((4389 - (683 + 909)) <= (12207 - 8227)) and (v188 == (1 - 0))) then
				v33 = EpicSettings.Toggles['aoe'];
				v34 = EpicSettings.Toggles['cds'];
				v36 = EpicSettings.Toggles['dispel'];
				v35 = EpicSettings.Toggles['minicds'];
				v188 = 779 - (772 + 5);
			end
			if (((3371 - (19 + 1408)) <= (2656 - (134 + 154))) and ((4 - 1) == v188)) then
				if (((5301 - 3592) < (1444 + 2804)) and v36 and v85) then
					if ((v14:AffectingCombat() and v101.CleanseSpirit:IsAvailable()) or ((3370 + 600) == (3404 - (10 + 192)))) then
						local v272 = 47 - (13 + 34);
						local v273;
						while true do
							if ((v272 == (1290 - (342 + 947))) or ((16163 - 12245) >= (6105 - (119 + 1589)))) then
								if (v31 or ((1720 - 940) == (4409 - 1224))) then
									return v31;
								end
								break;
							end
							if ((v272 == (552 - (545 + 7))) or ((9077 - 5875) >= (1683 + 2392))) then
								v273 = v85 and v101.CleanseSpirit:IsReady() and v36;
								v31 = v105.FocusUnit(v273, nil, 1723 - (494 + 1209), nil, 66 - 41, v101.HealingSurge);
								v272 = 999 - (197 + 801);
							end
						end
					end
				end
				if (((128 - 64) == (309 - 245)) and (v105.TargetIsValid() or v14:AffectingCombat())) then
					v108 = v10.BossFightRemains();
					v109 = v108;
					if (((3156 - (919 + 35)) >= (588 + 106)) and (v109 == (44834 - 33723))) then
						v109 = v10.FightRemains(v112, false);
					end
				end
				if (((4173 - (369 + 98)) <= (5015 - (400 + 715))) and not v14:IsChanneling() and not v14:IsCasting()) then
					local v268 = 0 + 0;
					while true do
						if (((1258 + 1632) > (3942 - (744 + 581))) and ((0 + 0) == v268)) then
							if (v86 or ((4977 - (653 + 969)) > (8569 - 4184))) then
								if (v81 or ((4698 - (12 + 1619)) <= (2358 - (103 + 60)))) then
									local v295 = 0 - 0;
									while true do
										if (((13216 - 10191) >= (13406 - 10593)) and (v295 == (1662 - (710 + 952)))) then
											v31 = v105.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 1908 - (555 + 1313));
											if (((2208 + 204) >= (319 + 37)) and v31) then
												return v31;
											end
											break;
										end
									end
								end
								if (((1436 + 634) > (2639 - (1261 + 207))) and v82) then
									local v296 = 252 - (245 + 7);
									while true do
										if ((v296 == (747 - (212 + 535))) or ((20297 - 16189) < (5410 - (905 + 571)))) then
											v31 = v105.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 140 - 110);
											if (((4952 - 1453) >= (13601 - 10162)) and v31) then
												return v31;
											end
											break;
										end
									end
								end
								if (((7 + 869) < (4766 - (522 + 941))) and v83) then
									local v297 = 1511 - (292 + 1219);
									while true do
										if (((4034 - (787 + 325)) <= (10824 - 7262)) and (v297 == (0 + 0))) then
											v31 = v105.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 68 - 38);
											if (((3153 - (424 + 110)) >= (759 + 563)) and v31) then
												return v31;
											end
											break;
										end
									end
								end
							end
							if (((2451 + 1682) >= (476 + 1928)) and v14:AffectingCombat()) then
								local v289 = 312 - (33 + 279);
								while true do
									if ((v289 == (1 + 0)) or ((2786 - (1338 + 15)) == (4109 - (528 + 895)))) then
										if (v31 or ((1963 + 2160) == (6381 - (1606 + 318)))) then
											return v31;
										end
										break;
									end
									if ((v289 == (1819 - (298 + 1521))) or ((17074 - 13102) <= (515 - (154 + 156)))) then
										if ((v34 and v92 and (v102.Dreambinder:IsEquippedAndReady() or v102.Iridal:IsEquippedAndReady())) or ((14314 - 10548) < (2081 - 1077))) then
											if (((2899 - (712 + 403)) < (2634 - (168 + 282))) and v25(v103.UseWeapon, nil)) then
												return "Using Weapon Macro";
											end
										end
										v31 = v141();
										v289 = 1 - 0;
									end
								end
							else
								v31 = v140();
								if (v31 or ((1627 + 22) > (17 + 4214))) then
									return v31;
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
	local function v146()
		local v189 = 0 - 0;
		while true do
			if (((4644 - (1242 + 209)) == (3872 - (20 + 659))) and (v189 == (1 + 0))) then
				v22.Print("Elemental Shaman by Epic. Supported by xKaneto.");
				break;
			end
			if ((v189 == (0 + 0)) or ((5094 - 1599) > (8830 - 4524))) then
				v101.FlameShockDebuff:RegisterAuraTracking();
				v107();
				v189 = 620 - (427 + 192);
			end
		end
	end
	v22.SetAPL(588 - 326, v145, v146);
end;
return v0["Epix_Shaman_Elemental.lua"]();

