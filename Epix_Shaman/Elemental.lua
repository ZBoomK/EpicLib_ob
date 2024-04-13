local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 102 - (13 + 89);
	local v6;
	while true do
		if ((v5 == (1292 - (641 + 651))) or ((871 - (135 + 40)) > (6430 - 3776))) then
			v6 = v0[v4];
			if (((225 + 147) <= (2028 - 1107)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if (((3875 - (50 + 126)) < (13103 - 8397)) and (v5 == (1 + 0))) then
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
		if (((4059 - (1233 + 180)) >= (1845 - (522 + 447))) and v101.CleanseSpirit:IsAvailable()) then
			v105.DispellableDebuffs = v105.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v107();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v10:RegisterForEvent(function()
		local v147 = 1421 - (107 + 1314);
		while true do
			if (((285 + 329) <= (9701 - 6517)) and ((1 + 0) == v147)) then
				v101.LavaBurst:RegisterInFlight();
				break;
			end
			if (((6207 - 3081) == (12368 - 9242)) and (v147 == (1910 - (716 + 1194)))) then
				v101.PrimordialWave:RegisterInFlightEffect(5587 + 321575);
				v101.PrimordialWave:RegisterInFlight();
				v147 = 1 + 0;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v101.PrimordialWave:RegisterInFlightEffect(327665 - (74 + 429));
	v101.PrimordialWave:RegisterInFlight();
	v101.LavaBurst:RegisterInFlight();
	local v108 = 21433 - 10322;
	local v109 = 5507 + 5604;
	local v110, v111;
	local v112, v113;
	local v114 = 0 - 0;
	local v115 = 0 + 0;
	local v116 = 0 - 0;
	local v117 = 0 - 0;
	local v118 = 433 - (279 + 154);
	local function v119()
		return (818 - (454 + 324)) - (v29() - v116);
	end
	v10:RegisterForSelfCombatEvent(function(...)
		local v148 = 0 + 0;
		local v149;
		local v150;
		local v151;
		while true do
			if ((v148 == (17 - (12 + 5))) or ((1180 + 1007) >= (12622 - 7668))) then
				v149, v150, v150, v150, v151 = select(3 + 5, ...);
				if (((v149 == v14:GUID()) and (v151 == (192727 - (277 + 816)))) or ((16566 - 12689) == (4758 - (1058 + 125)))) then
					local v261 = 0 + 0;
					while true do
						if (((1682 - (815 + 160)) > (2711 - 2079)) and (v261 == (0 - 0))) then
							v117 = v29();
							C_Timer.After(0.1 + 0, function()
								if ((v117 ~= v118) or ((1596 - 1050) >= (4582 - (41 + 1857)))) then
									v116 = v117;
								end
							end);
							break;
						end
					end
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED");
	local function v120(v152)
		return (v152:DebuffRefreshable(v101.FlameShockDebuff));
	end
	local function v121(v153)
		return v153:DebuffRefreshable(v101.FlameShockDebuff) and (v153:DebuffRemains(v101.FlameShockDebuff) < (v153:TimeToDie() - (1898 - (1222 + 671))));
	end
	local function v122(v154)
		return v154:DebuffRefreshable(v101.FlameShockDebuff) and (v154:DebuffRemains(v101.FlameShockDebuff) < (v154:TimeToDie() - (12 - 7))) and (v154:DebuffRemains(v101.FlameShockDebuff) > (0 - 0));
	end
	local function v123(v155)
		return (v155:DebuffRemains(v101.FlameShockDebuff));
	end
	local function v124(v156)
		return v156:DebuffRemains(v101.FlameShockDebuff) > (1184 - (229 + 953));
	end
	local function v125(v157)
		return (v157:DebuffRemains(v101.LightningRodDebuff));
	end
	local function v126()
		local v158 = 1774 - (1111 + 663);
		local v159;
		while true do
			if (((3044 - (874 + 705)) <= (603 + 3698)) and ((0 + 0) == v158)) then
				v159 = v14:Maelstrom();
				if (((3541 - 1837) > (41 + 1384)) and not v14:IsCasting()) then
					return v159;
				elseif (v14:IsCasting(v101.ElementalBlast) or ((1366 - (642 + 37)) == (966 + 3268))) then
					return v159 - (12 + 63);
				elseif (v14:IsCasting(v101.Icefury) or ((8360 - 5030) < (1883 - (233 + 221)))) then
					return v159 + (57 - 32);
				elseif (((1010 + 137) >= (1876 - (718 + 823))) and v14:IsCasting(v101.LightningBolt)) then
					return v159 + 7 + 3;
				elseif (((4240 - (266 + 539)) > (5937 - 3840)) and v14:IsCasting(v101.LavaBurst)) then
					return v159 + (1237 - (636 + 589));
				elseif (v14:IsCasting(v101.ChainLightning) or ((8949 - 5179) >= (8334 - 4293))) then
					return v159 + ((4 + 0) * v115);
				else
					return v159;
				end
				break;
			end
		end
	end
	local function v127(v160)
		local v161 = v160:IsReady();
		if ((v160 == v101.Stormkeeper) or (v160 == v101.ElementalBlast) or (v160 == v101.Icefury) or ((1378 + 2413) <= (2626 - (657 + 358)))) then
			local v193 = v14:BuffUp(v101.SpiritwalkersGraceBuff) or not v14:IsMoving();
			return v161 and v193 and not v14:IsCasting(v160);
		elseif ((v160 == v101.LavaBeam) or ((12121 - 7543) <= (4574 - 2566))) then
			local v254 = 1187 - (1151 + 36);
			local v255;
			while true do
				if (((1087 + 38) <= (546 + 1530)) and ((0 - 0) == v254)) then
					v255 = v14:BuffUp(v101.SpiritwalkersGraceBuff) or not v14:IsMoving();
					return v161 and v255;
				end
			end
		elseif ((v160 == v101.LightningBolt) or (v160 == v101.ChainLightning) or ((2575 - (1552 + 280)) >= (5233 - (64 + 770)))) then
			local v264 = v14:BuffUp(v101.SpiritwalkersGraceBuff) or v14:BuffUp(v101.StormkeeperBuff) or not v14:IsMoving();
			return v161 and v264;
		elseif (((785 + 370) < (3797 - 2124)) and (v160 == v101.LavaBurst)) then
			local v274 = v14:BuffUp(v101.SpiritwalkersGraceBuff) or v14:BuffUp(v101.LavaSurgeBuff) or not v14:IsMoving();
			local v275 = v14:BuffUp(v101.LavaSurgeBuff);
			local v276 = (v101.LavaBurst:Charges() >= (1 + 0)) and not v14:IsCasting(v101.LavaBurst);
			local v277 = (v101.LavaBurst:Charges() == (1245 - (157 + 1086))) and v14:IsCasting(v101.LavaBurst);
			return v161 and v274 and (v275 or v276 or v277);
		elseif ((v160 == v101.PrimordialWave) or ((4651 - 2327) <= (2531 - 1953))) then
			return v161 and v34 and v14:BuffDown(v101.PrimordialWaveBuff) and v14:BuffDown(v101.LavaSurgeBuff);
		else
			return v161;
		end
	end
	local function v128()
		local v162 = 0 - 0;
		local v163;
		while true do
			if (((5141 - 1374) == (4586 - (599 + 220))) and (v162 == (0 - 0))) then
				if (((6020 - (1813 + 118)) == (2989 + 1100)) and not v101.MasteroftheElements:IsAvailable()) then
					return false;
				end
				v163 = v14:BuffUp(v101.MasteroftheElementsBuff);
				v162 = 1218 - (841 + 376);
			end
			if (((6246 - 1788) >= (389 + 1285)) and (v162 == (2 - 1))) then
				if (((1831 - (464 + 395)) <= (3639 - 2221)) and not v14:IsCasting()) then
					return v163;
				elseif (v14:IsCasting(v106.LavaBurst) or ((2372 + 2566) < (5599 - (467 + 370)))) then
					return true;
				elseif (v14:IsCasting(v106.ElementalBlast) or v14:IsCasting(v101.Icefury) or v14:IsCasting(v101.LightningBolt) or v14:IsCasting(v101.ChainLightning) or ((5174 - 2670) > (3131 + 1133))) then
					return false;
				else
					return v163;
				end
				break;
			end
		end
	end
	local function v129()
		if (((7380 - 5227) == (336 + 1817)) and not v101.PoweroftheMaelstrom:IsAvailable()) then
			return false;
		end
		local v164 = v14:BuffStack(v101.PoweroftheMaelstromBuff);
		if (not v14:IsCasting() or ((1179 - 672) >= (3111 - (150 + 370)))) then
			return v164 > (1282 - (74 + 1208));
		elseif (((11021 - 6540) == (21251 - 16770)) and (v164 == (1 + 0)) and (v14:IsCasting(v101.LightningBolt) or v14:IsCasting(v101.ChainLightning))) then
			return false;
		else
			return v164 > (390 - (14 + 376));
		end
	end
	local function v130()
		local v165 = 0 - 0;
		local v166;
		while true do
			if ((v165 == (1 + 0)) or ((2046 + 282) < (661 + 32))) then
				if (((12681 - 8353) == (3256 + 1072)) and not v14:IsCasting()) then
					return v166;
				elseif (((1666 - (23 + 55)) >= (3156 - 1824)) and v14:IsCasting(v101.Stormkeeper)) then
					return true;
				else
					return v166;
				end
				break;
			end
			if (((0 + 0) == v165) or ((3749 + 425) > (6586 - 2338))) then
				if (not v101.Stormkeeper:IsAvailable() or ((1443 + 3143) <= (983 - (652 + 249)))) then
					return false;
				end
				v166 = v14:BuffUp(v101.StormkeeperBuff);
				v165 = 2 - 1;
			end
		end
	end
	local function v131()
		if (((5731 - (708 + 1160)) == (10485 - 6622)) and not v101.Icefury:IsAvailable()) then
			return false;
		end
		local v167 = v14:BuffUp(v101.IcefuryBuff);
		if (not v14:IsCasting() or ((513 - 231) <= (69 - (10 + 17)))) then
			return v167;
		elseif (((1036 + 3573) >= (2498 - (1400 + 332))) and v14:IsCasting(v101.Icefury)) then
			return true;
		else
			return v167;
		end
	end
	local v132 = 0 - 0;
	local function v133()
		if ((v101.CleanseSpirit:IsReady() and v36 and (v105.UnitHasDispellableDebuffByPlayer(v18) or v105.DispellableFriendlyUnit(1933 - (242 + 1666)))) or ((493 + 659) == (912 + 1576))) then
			local v194 = 0 + 0;
			while true do
				if (((4362 - (850 + 90)) > (5867 - 2517)) and (v194 == (1390 - (360 + 1030)))) then
					if (((777 + 100) > (1060 - 684)) and (v132 == (0 - 0))) then
						v132 = v29();
					end
					if (v105.Wait(2161 - (909 + 752), v132) or ((4341 - (109 + 1114)) <= (3388 - 1537))) then
						local v265 = 0 + 0;
						while true do
							if ((v265 == (242 - (6 + 236))) or ((104 + 61) >= (2811 + 681))) then
								if (((9312 - 5363) < (8481 - 3625)) and v25(v103.CleanseSpiritFocus)) then
									return "cleanse_spirit dispel";
								end
								v132 = 1133 - (1076 + 57);
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
		if ((v99 and (v14:HealthPercentage() <= v100)) or ((704 + 3572) < (3705 - (579 + 110)))) then
			if (((371 + 4319) > (3648 + 477)) and v101.HealingSurge:IsReady()) then
				if (v25(v101.HealingSurge) or ((27 + 23) >= (1303 - (174 + 233)))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v135()
		if ((v101.AstralShift:IsReady() and v72 and (v14:HealthPercentage() <= v78)) or ((4787 - 3073) >= (5191 - 2233))) then
			if (v25(v101.AstralShift) or ((664 + 827) < (1818 - (663 + 511)))) then
				return "astral_shift defensive 1";
			end
		end
		if (((629 + 75) < (215 + 772)) and v101.AncestralGuidance:IsReady() and v71 and v105.AreUnitsBelowHealthPercentage(v76, v77, v101.HealingSurge)) then
			if (((11462 - 7744) > (1155 + 751)) and v25(v101.AncestralGuidance)) then
				return "ancestral_guidance defensive 2";
			end
		end
		if ((v101.HealingStreamTotem:IsReady() and v73 and v105.AreUnitsBelowHealthPercentage(v79, v80, v101.HealingSurge)) or ((2255 - 1297) > (8799 - 5164))) then
			if (((1671 + 1830) <= (8742 - 4250)) and v25(v101.HealingStreamTotem)) then
				return "healing_stream_totem defensive 3";
			end
		end
		if ((v102.Healthstone:IsReady() and v94 and (v14:HealthPercentage() <= v96)) or ((2454 + 988) < (233 + 2315))) then
			if (((3597 - (478 + 244)) >= (1981 - (440 + 77))) and v25(v103.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if ((v93 and (v14:HealthPercentage() <= v95)) or ((2182 + 2615) >= (17908 - 13015))) then
			local v195 = 1556 - (655 + 901);
			while true do
				if ((v195 == (0 + 0)) or ((422 + 129) > (1397 + 671))) then
					if (((8516 - 6402) > (2389 - (695 + 750))) and (v97 == "Refreshing Healing Potion")) then
						if (v102.RefreshingHealingPotion:IsReady() or ((7723 - 5461) >= (4777 - 1681))) then
							if (v25(v103.RefreshingHealingPotion) or ((9069 - 6814) >= (3888 - (285 + 66)))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v97 == "Dreamwalker's Healing Potion") or ((8943 - 5106) < (2616 - (682 + 628)))) then
						if (((476 + 2474) == (3249 - (176 + 123))) and v102.DreamwalkersHealingPotion:IsReady()) then
							if (v25(v103.RefreshingHealingPotion) or ((1976 + 2747) < (2393 + 905))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v136()
		local v168 = 269 - (239 + 30);
		while true do
			if (((309 + 827) >= (149 + 5)) and (v168 == (0 - 0))) then
				v31 = v105.HandleTopTrinket(v104, v34, 124 - 84, nil);
				if (v31 or ((586 - (306 + 9)) > (16568 - 11820))) then
					return v31;
				end
				v168 = 1 + 0;
			end
			if (((2909 + 1831) >= (1518 + 1634)) and (v168 == (2 - 1))) then
				v31 = v105.HandleBottomTrinket(v104, v34, 1415 - (1140 + 235), nil);
				if (v31 or ((1641 + 937) >= (3109 + 281))) then
					return v31;
				end
				break;
			end
		end
	end
	local function v137()
		if (((11 + 30) <= (1713 - (33 + 19))) and v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (0 + 0)) and not v14:BuffUp(v101.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v109)) then
			if (((1801 - 1200) < (1569 + 1991)) and v25(v101.Stormkeeper)) then
				return "stormkeeper precombat 2";
			end
		end
		if (((460 - 225) < (645 + 42)) and v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (689 - (586 + 103))) and v43) then
			if (((415 + 4134) > (3549 - 2396)) and v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury))) then
				return "icefury precombat 4";
			end
		end
		if ((v127(v101.ElementalBlast) and v40) or ((6162 - (1309 + 179)) < (8433 - 3761))) then
			if (((1597 + 2071) < (12248 - 7687)) and v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast))) then
				return "elemental_blast precombat 6";
			end
		end
		if ((v14:IsCasting(v101.ElementalBlast) and v48 and ((v65 and v35) or not v65) and v127(v101.PrimordialWave)) or ((344 + 111) == (7659 - 4054))) then
			if (v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave)) or ((5306 - 2643) == (3921 - (295 + 314)))) then
				return "primordial_wave precombat 8";
			end
		end
		if (((10504 - 6227) <= (6437 - (1300 + 662))) and v14:IsCasting(v101.ElementalBlast) and v41 and not v101.PrimordialWave:IsAvailable() and v127(v101.FlameShock)) then
			if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((2731 - 1861) == (2944 - (1178 + 577)))) then
				return "flameshock precombat 10";
			end
		end
		if (((807 + 746) <= (9261 - 6128)) and v127(v101.LavaBurst) and v45 and not v14:IsCasting(v101.LavaBurst) and (not v101.ElementalBlast:IsAvailable() or (v101.ElementalBlast:IsAvailable() and not v101.ElementalBlast:IsAvailable()))) then
			if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((3642 - (851 + 554)) >= (3105 + 406))) then
				return "lavaburst precombat 12";
			end
		end
		if ((v14:IsCasting(v101.LavaBurst) and v41 and v101.FlameShock:IsReady()) or ((3671 - 2347) > (6558 - 3538))) then
			if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((3294 - (115 + 187)) == (1441 + 440))) then
				return "flameshock precombat 14";
			end
		end
		if (((2941 + 165) > (6013 - 4487)) and v14:IsCasting(v101.LavaBurst) and v48 and ((v65 and v35) or not v65) and v127(v101.PrimordialWave)) then
			if (((4184 - (160 + 1001)) < (3386 + 484)) and v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave))) then
				return "primordial_wave precombat 16";
			end
		end
	end
	local function v138()
		if (((99 + 44) > (150 - 76)) and v101.FireElemental:IsReady() and v54 and ((v60 and v34) or not v60) and (v91 < v109)) then
			if (((376 - (237 + 121)) < (3009 - (525 + 372))) and v25(v101.FireElemental)) then
				return "fire_elemental aoe 2";
			end
		end
		if (((2079 - 982) <= (5348 - 3720)) and v101.StormElemental:IsReady() and v56 and ((v61 and v34) or not v61) and (v91 < v109)) then
			if (((4772 - (96 + 46)) == (5407 - (643 + 134))) and v25(v101.StormElemental)) then
				return "storm_elemental aoe 4";
			end
		end
		if (((1278 + 2262) > (6432 - 3749)) and v127(v101.Stormkeeper) and not v130() and v49 and ((v66 and v35) or not v66) and (v91 < v109)) then
			if (((17798 - 13004) >= (3141 + 134)) and v25(v101.Stormkeeper)) then
				return "stormkeeper aoe 7";
			end
		end
		if (((2911 - 1427) == (3033 - 1549)) and v101.TotemicRecall:IsCastable() and (v101.LiquidMagmaTotem:CooldownRemains() > (764 - (316 + 403))) and v50) then
			if (((952 + 480) < (9774 - 6219)) and v25(v101.TotemicRecall)) then
				return "totemic_recall aoe 8";
			end
		end
		if ((v101.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v34) or not v62) and (v91 < v109) and (v67 == "cursor")) or ((385 + 680) > (9010 - 5432))) then
			if (v25(v103.LiquidMagmaTotemCursor, not v17:IsInRange(29 + 11)) or ((1546 + 3249) < (4874 - 3467))) then
				return "liquid_magma_totem aoe cursor 10";
			end
		end
		if (((8849 - 6996) < (9998 - 5185)) and v101.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v34) or not v62) and (v91 < v109) and (v67 == "player")) then
			if (v25(v103.LiquidMagmaTotemPlayer, not v17:IsInRange(3 + 37)) or ((5553 - 2732) < (119 + 2312))) then
				return "liquid_magma_totem aoe player 11";
			end
		end
		if ((v127(v101.PrimordialWave) and v14:BuffDown(v101.PrimordialWaveBuff) and v14:BuffUp(v101.SurgeofPowerBuff) and v14:BuffDown(v101.SplinteredElementsBuff)) or ((8455 - 5581) < (2198 - (12 + 5)))) then
			local v196 = 0 - 0;
			while true do
				if ((v196 == (0 - 0)) or ((5715 - 3026) <= (850 - 507))) then
					if (v105.CastTargetIf(v101.PrimordialWave, v113, "min", v123, nil, not v17:IsSpellInRange(v101.PrimordialWave), nil, nil) or ((380 + 1489) == (3982 - (1656 + 317)))) then
						return "primordial_wave aoe 12";
					end
					if (v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave)) or ((3160 + 386) < (1861 + 461))) then
						return "primordial_wave aoe 12";
					end
					break;
				end
			end
		end
		if ((v127(v101.PrimordialWave) and v14:BuffDown(v101.PrimordialWaveBuff) and v101.DeeplyRootedElements:IsAvailable() and not v101.SurgeofPower:IsAvailable() and v14:BuffDown(v101.SplinteredElementsBuff)) or ((5535 - 3453) == (23490 - 18717))) then
			if (((3598 - (5 + 349)) > (5011 - 3956)) and v105.CastTargetIf(v101.PrimordialWave, v113, "min", v123, nil, not v17:IsSpellInRange(v101.PrimordialWave), nil, nil)) then
				return "primordial_wave aoe 14";
			end
			if (v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave)) or ((4584 - (266 + 1005)) <= (1172 + 606))) then
				return "primordial_wave aoe 14";
			end
		end
		if ((v127(v101.PrimordialWave) and v14:BuffDown(v101.PrimordialWaveBuff) and v101.MasteroftheElements:IsAvailable() and not v101.LightningRod:IsAvailable()) or ((4848 - 3427) >= (2769 - 665))) then
			local v197 = 1696 - (561 + 1135);
			while true do
				if (((2360 - 548) <= (10679 - 7430)) and (v197 == (1066 - (507 + 559)))) then
					if (((4072 - 2449) <= (6052 - 4095)) and v105.CastTargetIf(v101.PrimordialWave, v113, "min", v123, nil, not v17:IsSpellInRange(v101.PrimordialWave), nil, nil)) then
						return "primordial_wave aoe 16";
					end
					if (((4800 - (212 + 176)) == (5317 - (250 + 655))) and v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave))) then
						return "primordial_wave aoe 16";
					end
					break;
				end
			end
		end
		if (((4772 - 3022) >= (1470 - 628)) and v101.FlameShock:IsCastable()) then
			if (((6839 - 2467) > (3806 - (1869 + 87))) and v14:BuffUp(v101.SurgeofPowerBuff) and v41 and v101.LightningRod:IsAvailable() and v101.WindspeakersLavaResurgence:IsAvailable() and (v17:DebuffRemains(v101.FlameShockDebuff) < (v17:TimeToDie() - (55 - 39))) and (v112 < (1906 - (484 + 1417)))) then
				if (((497 - 265) < (1375 - 554)) and v105.CastCycle(v101.FlameShock, v113, v121, not v17:IsSpellInRange(v101.FlameShock))) then
					return "flame_shock aoe 18";
				end
				if (((1291 - (48 + 725)) < (1473 - 571)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
					return "flame_shock aoe 18";
				end
			end
			if (((8032 - 5038) > (499 + 359)) and v14:BuffUp(v101.SurgeofPowerBuff) and v41 and (not v101.LightningRod:IsAvailable() or v101.SkybreakersFieryDemise:IsAvailable()) and (v101.FlameShockDebuff:AuraActiveCount() < (15 - 9))) then
				local v256 = 0 + 0;
				while true do
					if ((v256 == (0 + 0)) or ((4608 - (152 + 701)) <= (2226 - (430 + 881)))) then
						if (((1512 + 2434) > (4638 - (557 + 338))) and v105.CastCycle(v101.FlameShock, v113, v121, not v17:IsSpellInRange(v101.FlameShock))) then
							return "flame_shock aoe 20";
						end
						if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((395 + 940) >= (9316 - 6010))) then
							return "flame_shock aoe 20";
						end
						break;
					end
				end
			end
			if (((16962 - 12118) > (5985 - 3732)) and v101.MasteroftheElements:IsAvailable() and v41 and not v101.LightningRod:IsAvailable() and (v101.FlameShockDebuff:AuraActiveCount() < (12 - 6))) then
				local v257 = 801 - (499 + 302);
				while true do
					if (((1318 - (39 + 827)) == (1247 - 795)) and (v257 == (0 - 0))) then
						if (v105.CastCycle(v101.FlameShock, v113, v121, not v17:IsSpellInRange(v101.FlameShock)) or ((18099 - 13542) < (3204 - 1117))) then
							return "flame_shock aoe 22";
						end
						if (((332 + 3542) == (11338 - 7464)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
							return "flame_shock aoe 22";
						end
						break;
					end
				end
			end
			if ((v101.DeeplyRootedElements:IsAvailable() and v41 and not v101.SurgeofPower:IsAvailable() and (v101.FlameShockDebuff:AuraActiveCount() < (1 + 5))) or ((3066 - 1128) > (5039 - (103 + 1)))) then
				if (v105.CastCycle(v101.FlameShock, v113, v121, not v17:IsSpellInRange(v101.FlameShock)) or ((4809 - (475 + 79)) < (7399 - 3976))) then
					return "flame_shock aoe 24";
				end
				if (((4652 - 3198) <= (322 + 2169)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
					return "flame_shock aoe 24";
				end
			end
			if ((v14:BuffUp(v101.SurgeofPowerBuff) and v41 and (not v101.LightningRod:IsAvailable() or v101.SkybreakersFieryDemise:IsAvailable())) or ((3659 + 498) <= (4306 - (1395 + 108)))) then
				local v258 = 0 - 0;
				while true do
					if (((6057 - (7 + 1197)) >= (1301 + 1681)) and (v258 == (0 + 0))) then
						if (((4453 - (27 + 292)) > (9837 - 6480)) and v105.CastCycle(v101.FlameShock, v113, v122, not v17:IsSpellInRange(v101.FlameShock))) then
							return "flame_shock aoe 26";
						end
						if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((4357 - 940) < (10626 - 8092))) then
							return "flame_shock aoe 26";
						end
						break;
					end
				end
			end
			if ((v101.MasteroftheElements:IsAvailable() and v41 and not v101.LightningRod:IsAvailable() and not v101.SurgeofPower:IsAvailable()) or ((5367 - 2645) <= (311 - 147))) then
				local v259 = 139 - (43 + 96);
				while true do
					if (((0 - 0) == v259) or ((5444 - 3036) < (1751 + 358))) then
						if (v105.CastCycle(v101.FlameShock, v113, v122, not v17:IsSpellInRange(v101.FlameShock)) or ((10 + 23) == (2875 - 1420))) then
							return "flame_shock aoe 28";
						end
						if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((170 + 273) >= (7524 - 3509))) then
							return "flame_shock aoe 28";
						end
						break;
					end
				end
			end
			if (((1065 + 2317) > (13 + 153)) and v101.DeeplyRootedElements:IsAvailable() and v41 and not v101.SurgeofPower:IsAvailable()) then
				local v260 = 1751 - (1414 + 337);
				while true do
					if (((1940 - (1642 + 298)) == v260) or ((729 - 449) == (8800 - 5741))) then
						if (((5581 - 3700) > (426 + 867)) and v105.CastCycle(v101.FlameShock, v113, v122, not v17:IsSpellInRange(v101.FlameShock))) then
							return "flame_shock aoe 30";
						end
						if (((1834 + 523) == (3329 - (357 + 615))) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
							return "flame_shock aoe 30";
						end
						break;
					end
				end
			end
		end
		if (((87 + 36) == (301 - 178)) and v101.Ascendance:IsCastable() and v53 and ((v59 and v34) or not v59) and (v91 < v109)) then
			if (v25(v101.Ascendance) or ((905 + 151) >= (7269 - 3877))) then
				return "ascendance aoe 32";
			end
		end
		if ((v127(v101.LavaBurst) and (v115 == (3 + 0)) and not v101.LightningRod:IsAvailable() and v14:HasTier(3 + 28, 3 + 1)) or ((2382 - (384 + 917)) < (1772 - (128 + 569)))) then
			if (v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst)) or ((2592 - (1407 + 136)) >= (6319 - (687 + 1200)))) then
				return "lava_burst aoe 34";
			end
			if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((6478 - (556 + 1154)) <= (2976 - 2130))) then
				return "lava_burst aoe 34";
			end
		end
		if ((v38 and v101.Earthquake:IsReady() and v128() and (((v14:BuffStack(v101.MagmaChamberBuff) > (110 - (9 + 86))) and (v115 >= ((428 - (275 + 146)) - v26(v101.UnrelentingCalamity:IsAvailable())))) or (v101.SplinteredElements:IsAvailable() and (v115 >= ((2 + 8) - v26(v101.UnrelentingCalamity:IsAvailable())))) or (v101.MountainsWillFall:IsAvailable() and (v115 >= (73 - (29 + 35))))) and not v101.LightningRod:IsAvailable() and v14:HasTier(137 - 106, 11 - 7)) or ((14823 - 11465) <= (925 + 495))) then
			local v198 = 1012 - (53 + 959);
			while true do
				if ((v198 == (408 - (312 + 96))) or ((6488 - 2749) <= (3290 - (147 + 138)))) then
					if ((v52 == "cursor") or ((2558 - (813 + 86)) >= (1929 + 205))) then
						if (v25(v103.EarthquakeCursor, not v17:IsInRange(74 - 34)) or ((3752 - (18 + 474)) < (795 + 1560))) then
							return "earthquake aoe 36";
						end
					end
					if ((v52 == "player") or ((2183 - 1514) == (5309 - (860 + 226)))) then
						if (v25(v103.EarthquakePlayer, not v17:IsInRange(343 - (121 + 182))) or ((209 + 1483) < (1828 - (988 + 252)))) then
							return "earthquake aoe 36";
						end
					end
					break;
				end
			end
		end
		if ((v127(v101.LavaBeam) and v44 and v130() and ((v14:BuffUp(v101.SurgeofPowerBuff) and (v115 >= (1 + 5))) or (v128() and ((v115 < (2 + 4)) or not v101.SurgeofPower:IsAvailable()))) and not v101.LightningRod:IsAvailable() and v14:HasTier(2001 - (49 + 1921), 894 - (223 + 667))) or ((4849 - (51 + 1)) < (6283 - 2632))) then
			if (v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam)) or ((8944 - 4767) > (5975 - (146 + 979)))) then
				return "lava_beam aoe 38";
			end
		end
		if ((v127(v101.ChainLightning) and v37 and v130() and ((v14:BuffUp(v101.SurgeofPowerBuff) and (v115 >= (2 + 4))) or (v128() and ((v115 < (611 - (311 + 294))) or not v101.SurgeofPower:IsAvailable()))) and not v101.LightningRod:IsAvailable() and v14:HasTier(86 - 55, 2 + 2)) or ((1843 - (496 + 947)) > (2469 - (1233 + 125)))) then
			if (((1239 + 1812) > (902 + 103)) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
				return "chain_lightning aoe 40";
			end
		end
		if (((702 + 2991) <= (6027 - (963 + 682))) and v127(v101.LavaBurst) and v14:BuffUp(v101.LavaSurgeBuff) and not v101.LightningRod:IsAvailable() and v14:HasTier(26 + 5, 1508 - (504 + 1000))) then
			local v199 = 0 + 0;
			while true do
				if ((v199 == (0 + 0)) or ((310 + 2972) > (6045 - 1945))) then
					if (v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst)) or ((3059 + 521) < (1654 + 1190))) then
						return "lava_burst aoe 42";
					end
					if (((271 - (156 + 26)) < (2587 + 1903)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 42";
					end
					break;
				end
			end
		end
		if ((v127(v101.LavaBurst) and v14:BuffUp(v101.LavaSurgeBuff) and v101.MasteroftheElements:IsAvailable() and not v128() and (v126() >= (((93 - 33) - ((169 - (149 + 15)) * v101.EyeoftheStorm:TalentRank())) - ((962 - (890 + 70)) * v26(v101.FlowofPower:IsAvailable())))) and ((not v101.EchoesofGreatSundering:IsAvailable() and not v101.LightningRod:IsAvailable()) or v14:BuffUp(v101.EchoesofGreatSunderingBuff)) and ((not v14:BuffUp(v101.AscendanceBuff) and (v115 > (120 - (39 + 78))) and v101.UnrelentingCalamity:IsAvailable()) or ((v115 > (485 - (14 + 468))) and not v101.UnrelentingCalamity:IsAvailable()) or (v115 == (6 - 3)))) or ((13927 - 8944) < (933 + 875))) then
			local v200 = 0 + 0;
			while true do
				if (((814 + 3015) > (1703 + 2066)) and (v200 == (0 + 0))) then
					if (((2842 - 1357) <= (2871 + 33)) and v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 44";
					end
					if (((15001 - 10732) == (108 + 4161)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 44";
					end
					break;
				end
			end
		end
		if (((438 - (12 + 39)) <= (2589 + 193)) and v38 and v101.Earthquake:IsReady() and not v101.EchoesofGreatSundering:IsAvailable() and (v115 > (9 - 6)) and ((v115 > (10 - 7)) or (v114 > (1 + 2)))) then
			if ((v52 == "cursor") or ((1000 + 899) <= (2324 - 1407))) then
				if (v25(v103.EarthquakeCursor, not v17:IsInRange(27 + 13)) or ((20838 - 16526) <= (2586 - (1596 + 114)))) then
					return "earthquake aoe 46";
				end
			end
			if (((5827 - 3595) <= (3309 - (164 + 549))) and (v52 == "player")) then
				if (((3533 - (1059 + 379)) < (4576 - 890)) and v25(v103.EarthquakePlayer, not v17:IsInRange(21 + 19))) then
					return "earthquake aoe 46";
				end
			end
		end
		if ((v38 and v101.Earthquake:IsReady() and not v101.EchoesofGreatSundering:IsAvailable() and not v101.ElementalBlast:IsAvailable() and (v115 == (1 + 2)) and ((v115 == (395 - (145 + 247))) or (v114 == (3 + 0)))) or ((738 + 857) >= (13264 - 8790))) then
			if ((v52 == "cursor") or ((887 + 3732) < (2483 + 399))) then
				if (v25(v103.EarthquakeCursor, not v17:IsInRange(64 - 24)) or ((1014 - (254 + 466)) >= (5391 - (544 + 16)))) then
					return "earthquake aoe 48";
				end
			end
			if (((6448 - 4419) <= (3712 - (294 + 334))) and (v52 == "player")) then
				if (v25(v103.EarthquakePlayer, not v17:IsInRange(293 - (236 + 17))) or ((879 + 1158) == (1884 + 536))) then
					return "earthquake aoe 48";
				end
			end
		end
		if (((16789 - 12331) > (18483 - 14579)) and v38 and v101.Earthquake:IsReady() and (v14:BuffUp(v101.EchoesofGreatSunderingBuff))) then
			if (((225 + 211) >= (102 + 21)) and (v52 == "cursor")) then
				if (((1294 - (413 + 381)) < (77 + 1739)) and v25(v103.EarthquakeCursor, not v17:IsInRange(85 - 45))) then
					return "earthquake aoe 50";
				end
			end
			if (((9283 - 5709) == (5544 - (582 + 1388))) and (v52 == "player")) then
				if (((376 - 155) < (280 + 110)) and v25(v103.EarthquakePlayer, not v17:IsInRange(404 - (326 + 38)))) then
					return "earthquake aoe 50";
				end
			end
		end
		if ((v127(v101.ElementalBlast) and v40 and v101.EchoesofGreatSundering:IsAvailable()) or ((6546 - 4333) <= (2028 - 607))) then
			local v201 = 620 - (47 + 573);
			while true do
				if (((1078 + 1980) < (20640 - 15780)) and (v201 == (0 - 0))) then
					if (v105.CastTargetIf(v101.ElementalBlast, v113, "min", v125, nil, not v17:IsSpellInRange(v101.ElementalBlast), nil, nil) or ((2960 - (1269 + 395)) >= (4938 - (76 + 416)))) then
						return "elemental_blast aoe 52";
					end
					if (v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast)) or ((1836 - (319 + 124)) > (10261 - 5772))) then
						return "elemental_blast aoe 52";
					end
					break;
				end
			end
		end
		if ((v127(v101.ElementalBlast) and v40 and v101.EchoesofGreatSundering:IsAvailable()) or ((5431 - (564 + 443)) < (74 - 47))) then
			if (v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast)) or ((2455 - (337 + 121)) > (11178 - 7363))) then
				return "elemental_blast aoe 54";
			end
		end
		if (((11542 - 8077) > (3824 - (1261 + 650))) and v127(v101.ElementalBlast) and v40 and (v115 == (2 + 1)) and not v101.EchoesofGreatSundering:IsAvailable()) then
			if (((1167 - 434) < (3636 - (772 + 1045))) and v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast))) then
				return "elemental_blast aoe 56";
			end
		end
		if ((v127(v101.EarthShock) and v39 and v101.EchoesofGreatSundering:IsAvailable()) or ((620 + 3775) == (4899 - (102 + 42)))) then
			if (v105.CastTargetIf(v101.EarthShock, v113, "min", v125, nil, not v17:IsSpellInRange(v101.EarthShock), nil, nil) or ((5637 - (1524 + 320)) < (3639 - (1049 + 221)))) then
				return "earth_shock aoe 58";
			end
			if (v25(v101.EarthShock, not v17:IsSpellInRange(v101.EarthShock)) or ((4240 - (18 + 138)) == (648 - 383))) then
				return "earth_shock aoe 58";
			end
		end
		if (((5460 - (67 + 1035)) == (4706 - (136 + 212))) and v127(v101.EarthShock) and v39 and v101.EchoesofGreatSundering:IsAvailable()) then
			if (v25(v101.EarthShock, not v17:IsSpellInRange(v101.EarthShock)) or ((13334 - 10196) < (796 + 197))) then
				return "earth_shock aoe 60";
			end
		end
		if (((3070 + 260) > (3927 - (240 + 1364))) and v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (1082 - (1050 + 32))) and v43 and not v14:BuffUp(v101.AscendanceBuff) and v101.ElectrifiedShocks:IsAvailable() and ((v101.LightningRod:IsAvailable() and (v115 < (17 - 12)) and not v128()) or (v101.DeeplyRootedElements:IsAvailable() and (v115 == (2 + 1))))) then
			if (v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury)) or ((4681 - (331 + 724)) == (322 + 3667))) then
				return "icefury aoe 62";
			end
		end
		if ((v127(v101.FrostShock) and v42 and not v14:BuffUp(v101.AscendanceBuff) and v14:BuffUp(v101.IcefuryBuff) and v101.ElectrifiedShocks:IsAvailable() and (not v17:DebuffUp(v101.ElectrifiedShocksDebuff) or (v14:BuffRemains(v101.IcefuryBuff) < v14:GCD())) and ((v101.LightningRod:IsAvailable() and (v115 < (649 - (269 + 375))) and not v128()) or (v101.DeeplyRootedElements:IsAvailable() and (v115 == (728 - (267 + 458)))))) or ((285 + 631) == (5136 - 2465))) then
			if (((1090 - (667 + 151)) == (1769 - (1410 + 87))) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock aoe 64";
			end
		end
		if (((6146 - (1504 + 393)) <= (13079 - 8240)) and v127(v101.LavaBurst) and v101.MasteroftheElements:IsAvailable() and not v128() and (v130() or ((v119() < (7 - 4)) and v14:HasTier(826 - (461 + 335), 1 + 1))) and (v126() < ((((1821 - (1730 + 31)) - ((1672 - (728 + 939)) * v101.EyeoftheStorm:TalentRank())) - ((6 - 4) * v26(v101.FlowofPower:IsAvailable()))) - (20 - 10))) and (v115 < (11 - 6))) then
			if (((3845 - (138 + 930)) < (2925 + 275)) and v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst))) then
				return "lava_burst aoe 66";
			end
			if (((75 + 20) < (1678 + 279)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
				return "lava_burst aoe 66";
			end
		end
		if (((3372 - 2546) < (3483 - (459 + 1307))) and v127(v101.LavaBeam) and v44 and (v130())) then
			if (((3296 - (474 + 1396)) >= (1929 - 824)) and v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam))) then
				return "lava_beam aoe 68";
			end
		end
		if (((2582 + 172) <= (12 + 3367)) and v127(v101.ChainLightning) and v37 and (v130())) then
			if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((11248 - 7321) == (180 + 1233))) then
				return "chain_lightning aoe 70";
			end
		end
		if ((v127(v101.LavaBeam) and v44 and v129() and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) or ((3852 - 2698) <= (3436 - 2648))) then
			if (v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam)) or ((2234 - (562 + 29)) > (2881 + 498))) then
				return "lava_beam aoe 72";
			end
		end
		if ((v127(v101.ChainLightning) and v37 and v129()) or ((4222 - (374 + 1045)) > (3601 + 948))) then
			if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((683 - 463) >= (3660 - (448 + 190)))) then
				return "chain_lightning aoe 74";
			end
		end
		if (((912 + 1910) == (1274 + 1548)) and v127(v101.LavaBeam) and v44 and (v115 >= (4 + 2)) and v14:BuffUp(v101.SurgeofPowerBuff) and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) then
			if (v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam)) or ((4079 - 3018) == (5770 - 3913))) then
				return "lava_beam aoe 76";
			end
		end
		if (((4254 - (1307 + 187)) > (5408 - 4044)) and v127(v101.ChainLightning) and v37 and (v115 >= (13 - 7)) and v14:BuffUp(v101.SurgeofPowerBuff)) then
			if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((15030 - 10128) <= (4278 - (232 + 451)))) then
				return "chain_lightning aoe 78";
			end
		end
		if ((v127(v101.LavaBurst) and v14:BuffUp(v101.LavaSurgeBuff) and v101.DeeplyRootedElements:IsAvailable() and v14:BuffUp(v101.WindspeakersLavaResurgenceBuff)) or ((3679 + 173) == (259 + 34))) then
			if (v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst)) or ((2123 - (510 + 54)) == (9243 - 4655))) then
				return "lava_burst aoe 80";
			end
			if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((4520 - (13 + 23)) == (1535 - 747))) then
				return "lava_burst aoe 80";
			end
		end
		if (((6563 - 1995) >= (7098 - 3191)) and v127(v101.LavaBeam) and v44 and v128() and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) then
			if (((2334 - (830 + 258)) < (12240 - 8770)) and v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam))) then
				return "lava_beam aoe 82";
			end
		end
		if (((2546 + 1522) >= (827 + 145)) and v127(v101.LavaBurst) and (v115 == (1444 - (860 + 581))) and v101.MasteroftheElements:IsAvailable()) then
			if (((1818 - 1325) < (3090 + 803)) and v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst))) then
				return "lava_burst aoe 84";
			end
			if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((1714 - (237 + 4)) >= (7830 - 4498))) then
				return "lava_burst aoe 84";
			end
		end
		if ((v127(v101.LavaBurst) and v14:BuffUp(v101.LavaSurgeBuff) and v101.DeeplyRootedElements:IsAvailable()) or ((10249 - 6198) <= (2193 - 1036))) then
			if (((495 + 109) < (1655 + 1226)) and v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst))) then
				return "lava_burst aoe 86";
			end
			if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((3397 - 2497) == (1450 + 1927))) then
				return "lava_burst aoe 86";
			end
		end
		if (((2426 + 2033) > (2017 - (85 + 1341))) and v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (0 - 0)) and v43 and v101.ElectrifiedShocks:IsAvailable() and (v115 < (14 - 9))) then
			if (((3770 - (45 + 327)) >= (4519 - 2124)) and v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury))) then
				return "icefury aoe 88";
			end
		end
		if ((v127(v101.FrostShock) and v42 and v14:BuffUp(v101.IcefuryBuff) and v101.ElectrifiedShocks:IsAvailable() and not v17:DebuffUp(v101.ElectrifiedShocksDebuff) and (v115 < (507 - (444 + 58))) and v101.UnrelentingCalamity:IsAvailable()) or ((949 + 1234) >= (486 + 2338))) then
			if (((947 + 989) == (5610 - 3674)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock aoe 90";
			end
		end
		if ((v127(v101.LavaBeam) and v44 and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) or ((6564 - (64 + 1668)) < (6286 - (1227 + 746)))) then
			if (((12565 - 8477) > (7189 - 3315)) and v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam))) then
				return "lava_beam aoe 92";
			end
		end
		if (((4826 - (415 + 79)) == (112 + 4220)) and v127(v101.ChainLightning) and v37) then
			if (((4490 - (142 + 349)) >= (1243 + 1657)) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
				return "chain_lightning aoe 94";
			end
		end
		if ((v101.FlameShock:IsCastable() and v41 and v14:IsMoving() and v17:DebuffRefreshable(v101.FlameShockDebuff)) or ((3471 - 946) > (2020 + 2044))) then
			if (((3080 + 1291) == (11903 - 7532)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
				return "flame_shock aoe 96";
			end
		end
		if ((v101.FrostShock:IsCastable() and v42 and v14:IsMoving()) or ((2130 - (1710 + 154)) > (5304 - (200 + 118)))) then
			if (((789 + 1202) >= (1617 - 692)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock aoe 98";
			end
		end
	end
	local function v139()
		if (((674 - 219) < (1825 + 228)) and v101.FireElemental:IsCastable() and v54 and ((v60 and v34) or not v60) and (v91 < v109)) then
			if (v25(v101.FireElemental) or ((818 + 8) == (2604 + 2247))) then
				return "fire_elemental single_target 2";
			end
		end
		if (((30 + 153) == (396 - 213)) and v101.StormElemental:IsCastable() and v56 and ((v61 and v34) or not v61) and (v91 < v109)) then
			if (((2409 - (363 + 887)) <= (3122 - 1334)) and v25(v101.StormElemental)) then
				return "storm_elemental single_target 4";
			end
		end
		if ((v101.TotemicRecall:IsCastable() and v50 and (v101.LiquidMagmaTotem:CooldownRemains() > (214 - 169)) and ((v101.LavaSurge:IsAvailable() and v101.SplinteredElements:IsAvailable()) or ((v114 > (1 + 0)) and (v115 > (2 - 1))))) or ((2397 + 1110) > (5982 - (674 + 990)))) then
			if (v25(v101.TotemicRecall) or ((882 + 2193) <= (1214 + 1751))) then
				return "totemic_recall single_target 6";
			end
		end
		if (((2163 - 798) <= (3066 - (507 + 548))) and v101.LiquidMagmaTotem:IsCastable() and v55 and ((v62 and v34) or not v62) and (v91 < v109) and ((v101.LavaSurge:IsAvailable() and v101.SplinteredElements:IsAvailable()) or (v101.FlameShockDebuff:AuraActiveCount() == (837 - (289 + 548))) or (v17:DebuffRemains(v101.FlameShockDebuff) < (1824 - (821 + 997))) or ((v114 > (256 - (195 + 60))) and (v115 > (1 + 0))))) then
			if ((v67 == "cursor") or ((4277 - (251 + 1250)) > (10473 - 6898))) then
				if (v25(v103.LiquidMagmaTotemCursor, not v17:IsInRange(28 + 12)) or ((3586 - (809 + 223)) == (7009 - 2205))) then
					return "liquid_magma_totem single_target cursor 8";
				end
			end
			if (((7739 - 5162) == (8520 - 5943)) and (v67 == "player")) then
				if (v25(v103.LiquidMagmaTotemPlayer, not v17:IsInRange(30 + 10)) or ((4 + 2) >= (2506 - (14 + 603)))) then
					return "liquid_magma_totem single_target player 8";
				end
			end
		end
		if (((635 - (118 + 11)) <= (307 + 1585)) and v127(v101.PrimordialWave) and v101.PrimordialWave:IsCastable() and v48 and ((v65 and v35) or not v65) and not v14:BuffUp(v101.PrimordialWaveBuff) and not v14:BuffUp(v101.SplinteredElementsBuff)) then
			if (v105.CastCycle(v101.PrimordialWave, v113, v123, not v17:IsSpellInRange(v101.PrimordialWave)) or ((1673 + 335) > (6463 - 4245))) then
				return "primordial_wave single_target 10";
			end
			if (((1328 - (551 + 398)) <= (2621 + 1526)) and v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave))) then
				return "primordial_wave single_target 10";
			end
		end
		if ((v101.FlameShock:IsCastable() and v41 and (v114 == (1 + 0)) and v17:DebuffRefreshable(v101.FlameShockDebuff) and ((v17:DebuffRemains(v101.FlameShockDebuff) < v101.PrimordialWave:CooldownRemains()) or not v101.PrimordialWave:IsAvailable()) and v14:BuffDown(v101.SurgeofPowerBuff) and (not v128() or (not v130() and ((v101.ElementalBlast:IsAvailable() and (v126() < ((74 + 16) - ((29 - 21) * v101.EyeoftheStorm:TalentRank())))) or (v126() < ((138 - 78) - ((2 + 3) * v101.EyeoftheStorm:TalentRank()))))))) or ((17919 - 13405) <= (279 + 730))) then
			if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((3585 - (40 + 49)) == (4539 - 3347))) then
				return "flame_shock single_target 12";
			end
		end
		if ((v101.FlameShock:IsCastable() and v41 and (v101.FlameShockDebuff:AuraActiveCount() == (490 - (99 + 391))) and (v114 > (1 + 0)) and (v115 > (4 - 3)) and (v101.DeeplyRootedElements:IsAvailable() or v101.Ascendance:IsAvailable() or v101.PrimordialWave:IsAvailable() or v101.SearingFlames:IsAvailable() or v101.MagmaChamber:IsAvailable()) and ((not v128() and (v130() or (v101.Stormkeeper:CooldownRemains() > (0 - 0)))) or not v101.SurgeofPower:IsAvailable())) or ((203 + 5) == (7785 - 4826))) then
			local v202 = 1604 - (1032 + 572);
			while true do
				if (((4694 - (203 + 214)) >= (3130 - (568 + 1249))) and (v202 == (0 + 0))) then
					if (((6213 - 3626) < (12259 - 9085)) and v105.CastTargetIf(v101.FlameShock, v113, "min", v123, nil, not v17:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock single_target 14";
					end
					if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((5426 - (913 + 393)) <= (6207 - 4009))) then
						return "flame_shock single_target 14";
					end
					break;
				end
			end
		end
		if ((v101.FlameShock:IsCastable() and v41 and (v114 > (1 - 0)) and (v115 > (411 - (269 + 141))) and (v101.DeeplyRootedElements:IsAvailable() or v101.Ascendance:IsAvailable() or v101.PrimordialWave:IsAvailable() or v101.SearingFlames:IsAvailable() or v101.MagmaChamber:IsAvailable()) and ((v14:BuffUp(v101.SurgeofPowerBuff) and not v130() and v101.Stormkeeper:IsAvailable()) or not v101.SurgeofPower:IsAvailable())) or ((3549 - 1953) == (2839 - (362 + 1619)))) then
			if (((4845 - (950 + 675)) == (1242 + 1978)) and v105.CastTargetIf(v101.FlameShock, v113, "min", v123, v120, not v17:IsSpellInRange(v101.FlameShock))) then
				return "flame_shock single_target 16";
			end
			if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((2581 - (216 + 963)) > (4907 - (485 + 802)))) then
				return "flame_shock single_target 16";
			end
		end
		if (((3133 - (432 + 127)) == (3647 - (1065 + 8))) and v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (0 + 0)) and not v14:BuffUp(v101.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v109) and v14:BuffDown(v101.AscendanceBuff) and not v130() and (v126() >= (1717 - (635 + 966))) and v101.ElementalBlast:IsAvailable() and v101.SurgeofPower:IsAvailable() and v101.SwellingMaelstrom:IsAvailable() and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.PrimordialSurge:IsAvailable()) then
			if (((1293 + 505) < (2799 - (5 + 37))) and v25(v101.Stormkeeper)) then
				return "stormkeeper single_target 18";
			end
		end
		if ((v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v101.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v109) and v14:BuffDown(v101.AscendanceBuff) and not v130() and v14:BuffUp(v101.SurgeofPowerBuff) and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.PrimordialSurge:IsAvailable()) or ((157 + 220) > (4121 - 1517))) then
			if (((266 + 302) < (1892 - 981)) and v25(v101.Stormkeeper)) then
				return "stormkeeper single_target 20";
			end
		end
		if (((12454 - 9169) < (7973 - 3745)) and v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v101.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v109) and v14:BuffDown(v101.AscendanceBuff) and not v130() and (not v101.SurgeofPower:IsAvailable() or not v101.ElementalBlast:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.EchooftheElements:IsAvailable() or v101.PrimordialSurge:IsAvailable())) then
			if (((2816 + 1100) > (3857 - (318 + 211))) and v25(v101.Stormkeeper)) then
				return "stormkeeper single_target 22";
			end
		end
		if (((12301 - 9801) < (5426 - (963 + 624))) and v101.Ascendance:IsCastable() and v53 and ((v59 and v34) or not v59) and (v91 < v109) and not v130()) then
			if (((217 + 290) == (1353 - (518 + 328))) and v25(v101.Ascendance)) then
				return "ascendance single_target 24";
			end
		end
		if (((559 - 319) <= (5058 - 1893)) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v130() and v14:BuffUp(v101.SurgeofPowerBuff)) then
			if (((1151 - (301 + 16)) >= (2359 - 1554)) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single_target 26";
			end
		end
		if ((v127(v101.LavaBeam) and v44 and (v114 > (2 - 1)) and (v115 > (2 - 1)) and v130() and not v101.SurgeofPower:IsAvailable()) or ((3453 + 359) < (1315 + 1001))) then
			if (v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam)) or ((5661 - 3009) <= (923 + 610))) then
				return "lava_beam single_target 28";
			end
		end
		if ((v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and (v114 > (1 + 0)) and (v115 > (3 - 2)) and v130() and not v101.SurgeofPower:IsAvailable()) or ((1162 + 2436) < (2479 - (829 + 190)))) then
			if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((14685 - 10569) < (1507 - 315))) then
				return "chain_lightning single_target 30";
			end
		end
		if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v130() and not v128() and not v101.SurgeofPower:IsAvailable() and v101.MasteroftheElements:IsAvailable()) or ((4668 - 1291) <= (2242 - 1339))) then
			if (((943 + 3033) >= (144 + 295)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
				return "lava_burst single_target 32";
			end
		end
		if (((11388 - 7636) == (3541 + 211)) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v130() and not v101.SurgeofPower:IsAvailable() and v128()) then
			if (((4659 - (520 + 93)) > (2971 - (259 + 17))) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single_target 34";
			end
		end
		if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v130() and not v101.SurgeofPower:IsAvailable() and not v101.MasteroftheElements:IsAvailable()) or ((205 + 3340) == (1151 + 2046))) then
			if (((8104 - 5710) > (964 - (396 + 195))) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single_target 36";
			end
		end
		if (((12055 - 7900) <= (5993 - (440 + 1321))) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v14:BuffUp(v101.SurgeofPowerBuff) and v101.LightningRod:IsAvailable()) then
			if (v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt)) or ((5410 - (1059 + 770)) == (16059 - 12586))) then
				return "lightning_bolt single_target 38";
			end
		end
		if (((5540 - (424 + 121)) > (611 + 2737)) and v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (1347 - (641 + 706))) and v43 and v101.ElectrifiedShocks:IsAvailable() and v101.LightningRod:IsAvailable() and v101.LightningRod:IsAvailable()) then
			if (v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury)) or ((299 + 455) > (4164 - (249 + 191)))) then
				return "icefury single_target 40";
			end
		end
		if (((945 - 728) >= (26 + 31)) and v101.FrostShock:IsCastable() and v42 and v131() and v101.ElectrifiedShocks:IsAvailable() and ((v17:DebuffRemains(v101.ElectrifiedShocksDebuff) < (7 - 5)) or (v14:BuffRemains(v101.IcefuryBuff) <= v14:GCD())) and v101.LightningRod:IsAvailable()) then
			if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((2497 - (183 + 244)) >= (199 + 3838))) then
				return "frost_shock single_target 42";
			end
		end
		if (((3435 - (434 + 296)) == (8632 - 5927)) and v101.FrostShock:IsCastable() and v42 and v131() and v101.ElectrifiedShocks:IsAvailable() and (v126() >= (562 - (169 + 343))) and (v17:DebuffRemains(v101.ElectrifiedShocksDebuff) < ((2 + 0) * v14:GCD())) and v130() and v101.LightningRod:IsAvailable()) then
			if (((107 - 46) == (178 - 117)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock single_target 44";
			end
		end
		if ((v101.LavaBeam:IsCastable() and v44 and (v114 > (1 + 0)) and (v115 > (2 - 1)) and v129() and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime()) and not v14:HasTier(1154 - (651 + 472), 4 + 0)) or ((302 + 397) >= (1581 - 285))) then
			if (v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam)) or ((2266 - (397 + 86)) >= (4492 - (423 + 453)))) then
				return "lava_beam single_target 46";
			end
		end
		if ((v101.FrostShock:IsCastable() and v42 and v131() and v130() and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.PrimordialSurge:IsAvailable() and v101.ElementalBlast:IsAvailable() and (((v126() >= (7 + 54)) and (v126() < (10 + 65)) and (v101.LavaBurst:CooldownRemains() > v14:GCD())) or ((v126() >= (43 + 6)) and (v126() < (51 + 12)) and (v101.LavaBurst:CooldownRemains() > (0 + 0))))) or ((5103 - (50 + 1140)) > (3914 + 613))) then
			if (((2584 + 1792) > (51 + 766)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock single_target 48";
			end
		end
		if (((6980 - 2119) > (597 + 227)) and v101.FrostShock:IsCastable() and v42 and v131() and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.ElementalBlast:IsAvailable() and (((v126() >= (632 - (157 + 439))) and (v126() < (86 - 36)) and (v101.LavaBurst:CooldownRemains() > v14:GCD())) or ((v126() >= (79 - 55)) and (v126() < (112 - 74)) and (v101.LavaBurst:CooldownRemains() > (918 - (782 + 136)))))) then
			if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((2238 - (112 + 743)) >= (3302 - (1026 + 145)))) then
				return "frost_shock single_target 50";
			end
		end
		if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v14:BuffUp(v101.WindspeakersLavaResurgenceBuff) and (v101.EchooftheElements:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.PrimordialSurge:IsAvailable() or ((v126() >= (11 + 52)) and v101.MasteroftheElements:IsAvailable()) or ((v126() >= (756 - (493 + 225))) and v14:BuffUp(v101.EchoesofGreatSunderingBuff) and (v114 > (3 - 2)) and (v115 > (1 + 0))) or not v101.ElementalBlast:IsAvailable())) or ((5029 - 3153) >= (49 + 2492))) then
			if (((5092 - 3310) <= (1099 + 2673)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
				return "lava_burst single_target 52";
			end
		end
		if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v14:BuffUp(v101.LavaSurgeBuff) and (v101.EchooftheElements:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.PrimordialSurge:IsAvailable() or not v101.MasteroftheElements:IsAvailable() or not v101.ElementalBlast:IsAvailable())) or ((7852 - 3152) < (2408 - (210 + 1385)))) then
			if (((4888 - (1201 + 488)) < (2510 + 1540)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
				return "lava_burst single_target 54";
			end
		end
		if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v14:BuffUp(v101.AscendanceBuff) and (v14:HasTier(54 - 23, 6 - 2) or not v101.ElementalBlast:IsAvailable())) or ((5536 - (352 + 233)) < (10706 - 6276))) then
			local v203 = 0 + 0;
			while true do
				if (((272 - 176) == (670 - (489 + 85))) and ((1501 - (277 + 1224)) == v203)) then
					if (v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst)) or ((4232 - (663 + 830)) > (3521 + 487))) then
						return "lava_burst single_target 56";
					end
					if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((55 - 32) == (2009 - (461 + 414)))) then
						return "lava_burst single_target 56";
					end
					break;
				end
			end
		end
		if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v14:BuffDown(v101.AscendanceBuff) and (not v101.ElementalBlast:IsAvailable() or not v101.MountainsWillFall:IsAvailable()) and not v101.LightningRod:IsAvailable() and v14:HasTier(6 + 25, 2 + 2)) or ((257 + 2436) >= (4053 + 58))) then
			local v204 = 250 - (172 + 78);
			while true do
				if (((0 - 0) == v204) or ((1589 + 2727) <= (3096 - 950))) then
					if (v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst)) or ((967 + 2579) <= (939 + 1870))) then
						return "lava_burst single_target 58";
					end
					if (((8215 - 3311) > (2726 - 560)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst single_target 58";
					end
					break;
				end
			end
		end
		if (((28 + 81) >= (50 + 40)) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v101.MasteroftheElements:IsAvailable() and not v128() and not v101.LightningRod:IsAvailable()) then
			local v205 = 0 + 0;
			while true do
				if (((19815 - 14837) > (6768 - 3863)) and (v205 == (0 + 0))) then
					if (v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst)) or ((1728 + 1298) <= (2727 - (133 + 314)))) then
						return "lava_burst single_target 60";
					end
					if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((288 + 1365) <= (1321 - (199 + 14)))) then
						return "lava_burst single_target 60";
					end
					break;
				end
			end
		end
		if (((10413 - 7504) > (4158 - (647 + 902))) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v101.MasteroftheElements:IsAvailable() and not v128() and ((v126() >= (225 - 150)) or ((v126() >= (283 - (85 + 148))) and not v101.ElementalBlast:IsAvailable())) and v101.SwellingMaelstrom:IsAvailable() and (v126() <= (1419 - (426 + 863)))) then
			if (((3542 - 2785) > (1848 - (873 + 781))) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
				return "lava_burst single_target 62";
			end
		end
		if ((v101.Earthquake:IsReady() and v38 and v14:BuffUp(v101.EchoesofGreatSunderingBuff) and ((not v101.ElementalBlast:IsAvailable() and (v114 < (2 - 0))) or (v114 > (2 - 1)))) or ((13 + 18) >= (5164 - 3766))) then
			local v206 = 0 - 0;
			while true do
				if (((9489 - 6293) <= (6819 - (414 + 1533))) and (v206 == (0 + 0))) then
					if (((3881 - (443 + 112)) == (4805 - (888 + 591))) and (v52 == "cursor")) then
						if (((3702 - 2269) <= (222 + 3656)) and v25(v103.EarthquakeCursor, not v17:IsInRange(150 - 110))) then
							return "earthquake single_target 64";
						end
					end
					if ((v52 == "player") or ((618 + 965) == (840 + 895))) then
						if (v25(v103.EarthquakePlayer, not v17:IsInRange(5 + 35)) or ((5680 - 2699) == (4353 - 2003))) then
							return "earthquake single_target 64";
						end
					end
					break;
				end
			end
		end
		if ((v101.Earthquake:IsReady() and v38 and (v114 > (1679 - (136 + 1542))) and (v115 > (3 - 2)) and not v101.EchoesofGreatSundering:IsAvailable() and not v101.ElementalBlast:IsAvailable()) or ((4433 + 33) <= (783 - 290))) then
			local v207 = 0 + 0;
			while true do
				if ((v207 == (486 - (68 + 418))) or ((6904 - 4357) <= (3604 - 1617))) then
					if (((2557 + 404) > (3832 - (770 + 322))) and (v52 == "cursor")) then
						if (((213 + 3483) >= (1045 + 2567)) and v25(v103.EarthquakeCursor, not v17:IsInRange(6 + 34))) then
							return "earthquake single_target 66";
						end
					end
					if ((v52 == "player") or ((4249 - 1279) == (3641 - 1763))) then
						if (v25(v103.EarthquakePlayer, not v17:IsInRange(108 - 68)) or ((13583 - 9890) < (1102 + 875))) then
							return "earthquake single_target 66";
						end
					end
					break;
				end
			end
		end
		if ((v127(v101.ElementalBlast) and v101.ElementalBlast:IsCastable() and v40 and (not v101.MasteroftheElements:IsAvailable() or (v128() and v17:DebuffUp(v101.ElectrifiedShocksDebuff)))) or ((1393 - 463) > (1008 + 1093))) then
			if (((2546 + 1607) > (2419 + 667)) and v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast))) then
				return "elemental_blast single_target 68";
			end
		end
		if ((v127(v101.FrostShock) and v42 and v131() and v128() and (v126() < (414 - 304)) and (v101.LavaBurst:ChargesFractional() < (1 - 0)) and v101.ElectrifiedShocks:IsAvailable() and v101.ElementalBlast:IsAvailable() and not v101.LightningRod:IsAvailable()) or ((1573 + 3081) <= (18656 - 14606))) then
			if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((8601 - 5999) < (616 + 880))) then
				return "frost_shock single_target 70";
			end
		end
		if ((v127(v101.ElementalBlast) and v101.ElementalBlast:IsCastable() and v40 and (v128() or v101.LightningRod:IsAvailable())) or ((5047 - 4027) > (3119 - (762 + 69)))) then
			if (((1061 - 733) == (283 + 45)) and v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast))) then
				return "elemental_blast single_target 72";
			end
		end
		if (((979 + 532) < (9210 - 5402)) and v101.EarthShock:IsReady() and v39) then
			if (v25(v101.EarthShock, not v17:IsSpellInRange(v101.EarthShock)) or ((790 + 1720) > (79 + 4840))) then
				return "earth_shock single_target 74";
			end
		end
		if (((18557 - 13794) == (4920 - (8 + 149))) and v127(v101.FrostShock) and v42 and v131() and v101.ElectrifiedShocks:IsAvailable() and v128() and not v101.LightningRod:IsAvailable() and (v114 > (1321 - (1199 + 121))) and (v115 > (1 - 0))) then
			if (((9339 - 5202) > (761 + 1087)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock single_target 76";
			end
		end
		if (((8695 - 6259) <= (7271 - 4137)) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and (v101.DeeplyRootedElements:IsAvailable())) then
			local v208 = 0 + 0;
			while true do
				if (((5530 - (518 + 1289)) == (6384 - 2661)) and (v208 == (0 + 0))) then
					if (v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst)) or ((5908 - 1862) >= (3179 + 1137))) then
						return "lava_burst single_target 78";
					end
					if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((2477 - (304 + 165)) < (1822 + 107))) then
						return "lava_burst single_target 78";
					end
					break;
				end
			end
		end
		if (((2544 - (54 + 106)) > (3744 - (1618 + 351))) and v101.FrostShock:IsCastable() and v42 and v131() and v101.FluxMelting:IsAvailable() and v14:BuffDown(v101.FluxMeltingBuff)) then
			if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((3204 + 1339) <= (5392 - (10 + 1006)))) then
				return "frost_shock single_target 80";
			end
		end
		if (((183 + 545) == (102 + 626)) and v101.FrostShock:IsCastable() and v42 and v131() and ((v101.ElectrifiedShocks:IsAvailable() and (v17:DebuffRemains(v101.ElectrifiedShocksDebuff) < (6 - 4))) or (v14:BuffRemains(v101.IcefuryBuff) < (1039 - (912 + 121))))) then
			if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((509 + 567) > (5960 - (1140 + 149)))) then
				return "frost_shock single_target 82";
			end
		end
		if (((1185 + 666) >= (503 - 125)) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and (v101.EchooftheElements:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.PrimordialSurge:IsAvailable() or not v101.ElementalBlast:IsAvailable() or not v101.MasteroftheElements:IsAvailable() or v130())) then
			if (v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst)) or ((363 + 1585) >= (11896 - 8420))) then
				return "lava_burst single_target 84";
			end
			if (((8990 - 4196) >= (144 + 689)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
				return "lava_burst single_target 84";
			end
		end
		if (((14192 - 10102) == (4276 - (165 + 21))) and v127(v101.ElementalBlast) and v101.ElementalBlast:IsCastable() and v40) then
			if (v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast)) or ((3869 - (61 + 50)) == (1029 + 1469))) then
				return "elemental_blast single_target 86";
			end
		end
		if ((v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and v129() and v101.UnrelentingCalamity:IsAvailable() and (v114 > (4 - 3)) and (v115 > (1 - 0))) or ((1051 + 1622) < (3035 - (1295 + 165)))) then
			if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((850 + 2871) <= (586 + 869))) then
				return "chain_lightning single_target 88";
			end
		end
		if (((2331 - (819 + 578)) < (3672 - (331 + 1071))) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v129() and v101.UnrelentingCalamity:IsAvailable()) then
			if (v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt)) or ((2355 - (588 + 155)) == (2537 - (546 + 736)))) then
				return "lightning_bolt single_target 90";
			end
		end
		if ((v127(v101.Icefury) and v101.Icefury:IsCastable() and v43) or ((6289 - (1834 + 103)) < (2588 + 1618))) then
			if (v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury)) or ((8531 - 5671) <= (1947 - (1536 + 230)))) then
				return "icefury single_target 92";
			end
		end
		if (((3713 - (128 + 363)) >= (325 + 1202)) and v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v101.LightningRodDebuff) and (v17:DebuffUp(v101.ElectrifiedShocksDebuff) or v129()) and (v114 > (2 - 1)) and (v115 > (1 + 0))) then
			if (((2492 - 987) <= (6244 - 4123)) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
				return "chain_lightning single_target 94";
			end
		end
		if (((1806 - 1062) == (511 + 233)) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v101.LightningRodDebuff) and (v17:DebuffUp(v101.ElectrifiedShocksDebuff) or v129())) then
			if (v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt)) or ((2988 - (615 + 394)) >= (2561 + 275))) then
				return "lightning_bolt single_target 96";
			end
		end
		if (((1747 + 86) <= (8133 - 5465)) and v101.FrostShock:IsCastable() and v42 and v131() and v128() and v14:BuffDown(v101.LavaSurgeBuff) and not v101.ElectrifiedShocks:IsAvailable() and not v101.FluxMelting:IsAvailable() and (v101.LavaBurst:ChargesFractional() < (4 - 3)) and v101.EchooftheElements:IsAvailable()) then
			if (((4337 - (59 + 592)) == (8160 - 4474)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock single_target 98";
			end
		end
		if (((6384 - 2917) > (337 + 140)) and v101.FrostShock:IsCastable() and v42 and v131() and (v101.FluxMelting:IsAvailable() or (v101.ElectrifiedShocks:IsAvailable() and not v101.LightningRod:IsAvailable()))) then
			if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((3459 - (70 + 101)) >= (8753 - 5212))) then
				return "frost_shock single_target 100";
			end
		end
		if ((v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and v128() and v14:BuffDown(v101.LavaSurgeBuff) and (v101.LavaBurst:ChargesFractional() < (1 + 0)) and v101.EchooftheElements:IsAvailable() and (v114 > (2 - 1)) and (v115 > (242 - (123 + 118)))) or ((861 + 2696) == (57 + 4483))) then
			if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((1660 - (653 + 746)) > (2369 - 1102))) then
				return "chain_lightning single_target 102";
			end
		end
		if (((1831 - 559) < (10329 - 6471)) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v128() and v14:BuffDown(v101.LavaSurgeBuff) and (v101.LavaBurst:ChargesFractional() < (1 + 0)) and v101.EchooftheElements:IsAvailable()) then
			if (((2345 + 1319) == (3201 + 463)) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single_target 104";
			end
		end
		if (((238 + 1703) >= (71 + 379)) and v101.FrostShock:IsCastable() and v42 and v131() and not v101.ElectrifiedShocks:IsAvailable() and not v101.FluxMelting:IsAvailable()) then
			if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((11389 - 6743) < (309 + 15))) then
				return "frost_shock single_target 106";
			end
		end
		if (((7080 - 3247) == (5067 - (885 + 349))) and v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and (v114 > (1 + 0)) and (v115 > (2 - 1))) then
			if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((3606 - 2366) > (4338 - (915 + 53)))) then
				return "chain_lightning single_target 108";
			end
		end
		if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46) or ((3282 - (768 + 33)) == (17926 - 13244))) then
			if (((8320 - 3593) >= (536 - (287 + 41))) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single_target 110";
			end
		end
		if (((1127 - (638 + 209)) < (2001 + 1850)) and v101.FlameShock:IsCastable() and v41 and (v14:IsMoving())) then
			local v209 = 1686 - (96 + 1590);
			while true do
				if ((v209 == (1672 - (741 + 931))) or ((1477 + 1530) > (9099 - 5905))) then
					if (v105.CastCycle(v101.FlameShock, v113, v120, not v17:IsSpellInRange(v101.FlameShock)) or ((9979 - 7843) >= (1265 + 1681))) then
						return "flame_shock single_target 112";
					end
					if (((931 + 1234) <= (804 + 1717)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock single_target 112";
					end
					break;
				end
			end
		end
		if (((10856 - 7995) > (215 + 446)) and v101.FlameShock:IsCastable() and v41) then
			if (((2210 + 2315) > (18433 - 13914)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
				return "flame_shock single_target 114";
			end
		end
		if (((2852 + 326) > (1466 - (64 + 430))) and v101.FrostShock:IsCastable() and v42) then
			if (((4729 + 37) == (5129 - (106 + 257))) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock single_target 116";
			end
		end
	end
	local function v140()
		if ((v74 and v101.EarthShield:IsCastable() and v14:BuffDown(v101.EarthShieldBuff) and ((v75 == "Earth Shield") or (v101.ElementalOrbit:IsAvailable() and v14:BuffUp(v101.LightningShield)))) or ((1947 + 798) > (3849 - (496 + 225)))) then
			if (v25(v101.EarthShield) or ((2338 - 1194) >= (22437 - 17831))) then
				return "earth_shield main 2";
			end
		elseif (((4996 - (256 + 1402)) >= (2176 - (30 + 1869))) and v74 and v101.LightningShield:IsCastable() and v14:BuffDown(v101.LightningShieldBuff) and ((v75 == "Lightning Shield") or (v101.ElementalOrbit:IsAvailable() and v14:BuffUp(v101.EarthShield)))) then
			if (((3979 - (213 + 1156)) > (2748 - (96 + 92))) and v25(v101.LightningShield)) then
				return "lightning_shield main 2";
			end
		end
		v31 = v134();
		if (v31 or ((204 + 990) > (3982 - (142 + 757)))) then
			return v31;
		end
		if (((747 + 169) >= (306 + 441)) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v14:CanAttack(v17)) then
			if (v25(v101.AncestralSpirit, nil, true) or ((2523 - (32 + 47)) > (4931 - (1053 + 924)))) then
				return "ancestral_spirit";
			end
		end
		if (((2833 + 59) < (6051 - 2537)) and v101.AncestralSpirit:IsCastable() and v101.AncestralSpirit:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
			if (((2181 - (685 + 963)) == (1083 - 550)) and v25(v103.AncestralSpiritMouseover)) then
				return "ancestral_spirit mouseover";
			end
		end
		v110, v111 = v30();
		if (((927 - 332) <= (5122 - (541 + 1168))) and v101.ImprovedFlametongueWeapon:IsAvailable() and v101.FlametongueWeapon:IsCastable() and v51 and (not v110 or (v111 < (601597 - (645 + 952)))) and v101.FlametongueWeapon:IsAvailable()) then
			if (((3916 - (669 + 169)) >= (8975 - 6384)) and v25(v101.FlametongueWeapon)) then
				return "flametongue_weapon enchant";
			end
		end
		if (((6946 - 3747) < (1361 + 2669)) and not v14:AffectingCombat() and v32 and v105.TargetIsValid()) then
			local v210 = 0 + 0;
			while true do
				if (((1542 - (181 + 584)) < (3473 - (665 + 730))) and (v210 == (0 - 0))) then
					v31 = v137();
					if (((3458 - 1762) <= (3632 - (540 + 810))) and v31) then
						return v31;
					end
					break;
				end
			end
		end
	end
	local function v141()
		local v169 = 0 - 0;
		while true do
			if ((v169 == (0 - 0)) or ((1402 + 359) >= (2665 - (166 + 37)))) then
				v31 = v135();
				if (((6432 - (22 + 1859)) > (4100 - (843 + 929))) and v31) then
					return v31;
				end
				v169 = 263 - (30 + 232);
			end
			if (((10924 - 7099) >= (1244 - (55 + 722))) and (v169 == (6 - 3))) then
				if ((v101.Purge:IsReady() and v98 and v36 and v84 and not v14:IsCasting() and not v14:IsChanneling() and v105.UnitHasMagicBuff(v17)) or ((4565 - (78 + 1597)) == (123 + 434))) then
					if (v25(v101.Purge, not v17:IsSpellInRange(v101.Purge)) or ((4340 + 430) == (2432 + 472))) then
						return "purge damage";
					end
				end
				if ((v105.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((4452 - (305 + 244)) == (4209 + 327))) then
					local v262 = 105 - (95 + 10);
					local v263;
					while true do
						if (((2899 + 1194) <= (15353 - 10508)) and (v262 == (3 - 0))) then
							if (((2331 - (592 + 170)) <= (12719 - 9072)) and true) then
								v31 = v139();
								if (v31 or ((10160 - 6114) >= (2297 + 2630))) then
									return v31;
								end
								if (((1800 + 2823) >= (6730 - 3943)) and v25(v101.Pool)) then
									return "Pool for SingleTarget()";
								end
							end
							break;
						end
						if (((363 + 1871) >= (2279 - 1049)) and (v262 == (507 - (353 + 154)))) then
							if (((v91 < v109) and v58 and ((v64 and v34) or not v64)) or ((455 - 112) == (2439 - 653))) then
								local v278 = 0 + 0;
								while true do
									if (((2013 + 557) > (1590 + 819)) and (v278 == (1 - 0))) then
										if ((v101.Fireblood:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (94 - 44)))) or ((6081 - 3472) >= (3320 - (7 + 79)))) then
											if (v25(v101.Fireblood) or ((1419 + 1614) >= (4212 - (24 + 157)))) then
												return "fireblood main 6";
											end
										end
										if ((v101.AncestralCall:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (99 - 49)))) or ((2988 - 1587) == (1327 + 3341))) then
											if (((7477 - 4701) >= (1701 - (262 + 118))) and v25(v101.AncestralCall)) then
												return "ancestral_call main 8";
											end
										end
										v278 = 1085 - (1038 + 45);
									end
									if ((v278 == (0 - 0)) or ((717 - (19 + 211)) > (2416 - (88 + 25)))) then
										if ((v101.BloodFury:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (127 - 77)))) or ((2236 + 2267) == (3232 + 230))) then
											if (((1589 - (1007 + 29)) <= (416 + 1127)) and v25(v101.BloodFury)) then
												return "blood_fury main 2";
											end
										end
										if (((4925 - 2910) == (9530 - 7515)) and v101.Berserking:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff))) then
											if (v25(v101.Berserking) or ((946 + 3295) <= (3143 - (340 + 471)))) then
												return "berserking main 4";
											end
										end
										v278 = 2 - 1;
									end
									if ((v278 == (591 - (276 + 313))) or ((5770 - 3406) < (1067 + 90))) then
										if ((v101.BagofTricks:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff))) or ((495 + 672) > (120 + 1158))) then
											if (v25(v101.BagofTricks) or ((3117 - (495 + 1477)) <= (3239 - 2157))) then
												return "bag_of_tricks main 10";
											end
										end
										break;
									end
								end
							end
							if ((v91 < v109) or ((2035 + 1070) == (5284 - (342 + 61)))) then
								if ((v57 and ((v34 and v63) or not v63)) or ((826 + 1061) > (5043 - (4 + 161)))) then
									v31 = v136();
									if (v31 or ((2503 + 1584) > (12919 - 8803))) then
										return v31;
									end
								end
							end
							v262 = 2 - 1;
						end
						if (((1603 - (322 + 175)) <= (1829 - (173 + 390))) and ((1 + 0) == v262)) then
							if (((3469 - (203 + 111)) < (289 + 4361)) and v101.NaturesSwiftness:IsCastable() and v47) then
								if (((2662 + 1112) >= (5366 - 3527)) and v25(v101.NaturesSwiftness)) then
									return "natures_swiftness main 12";
								end
							end
							v263 = v105.HandleDPSPotion(v14:BuffUp(v101.AscendanceBuff));
							v262 = 2 + 0;
						end
						if (((3517 - (57 + 649)) == (3195 - (328 + 56))) and (v262 == (1 + 1))) then
							if (((2658 - (433 + 79)) > (103 + 1019)) and v263) then
								return v263;
							end
							if ((v33 and (v114 > (2 + 0)) and (v115 > (6 - 4))) or ((264 - 208) == (2637 + 979))) then
								local v279 = 0 + 0;
								while true do
									if ((v279 == (1037 - (562 + 474))) or ((5648 - 3227) < (1266 - 644))) then
										if (((1914 - (76 + 829)) <= (2803 - (1506 + 167))) and v25(v101.Pool)) then
											return "Pool for Aoe()";
										end
										break;
									end
									if (((5180 - 2422) < (3246 - (58 + 208))) and (v279 == (0 + 0))) then
										v31 = v138();
										if (v31 or ((62 + 24) >= (2084 + 1542))) then
											return v31;
										end
										v279 = 3 - 2;
									end
								end
							end
							v262 = 340 - (258 + 79);
						end
					end
				end
				break;
			end
			if (((304 + 2091) == (5038 - 2643)) and (v169 == (1471 - (1219 + 251)))) then
				if (((5451 - (1231 + 440)) > (2767 - (34 + 24))) and v86) then
					if (v81 or ((138 + 99) >= (4242 - 1969))) then
						local v266 = 0 + 0;
						while true do
							if ((v266 == (0 - 0)) or ((6539 - 4499) <= (1847 - 1144))) then
								v31 = v105.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 134 - 94);
								if (((7159 - 3880) <= (5556 - (877 + 712))) and v31) then
									return v31;
								end
								break;
							end
						end
					end
					if (v82 or ((1191 + 797) == (1631 - (242 + 512)))) then
						local v267 = 0 - 0;
						while true do
							if (((4918 - (92 + 535)) > (1506 + 406)) and (v267 == (0 - 0))) then
								v31 = v105.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 2 + 28);
								if (((7279 - 5276) < (2294 + 45)) and v31) then
									return v31;
								end
								break;
							end
						end
					end
					if (((300 + 132) == (61 + 371)) and v83) then
						local v268 = 0 - 0;
						while true do
							if ((v268 == (0 - 0)) or ((2930 - (1476 + 309)) >= (2537 - (299 + 985)))) then
								v31 = v105.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 8 + 22);
								if (((11204 - 7786) > (2211 - (86 + 7))) and v31) then
									return v31;
								end
								break;
							end
						end
					end
				end
				if (((12529 - 9463) <= (370 + 3520)) and v87) then
					v31 = v105.HandleIncorporeal(v101.Hex, v103.HexMouseOver, 910 - (672 + 208), true);
					if (v31 or ((1285 + 1713) >= (3413 - (14 + 118)))) then
						return v31;
					end
				end
				v169 = 447 - (339 + 106);
			end
			if (((2 + 0) == v169) or ((2339 + 2310) <= (4027 - (440 + 955)))) then
				if (v18 or ((3804 + 56) > (8752 - 3880))) then
					if (v85 or ((1327 + 2671) == (5721 - 3423))) then
						local v269 = 0 + 0;
						while true do
							if ((v269 == (354 - (260 + 93))) or ((8 + 0) >= (6265 - 3526))) then
								if (((4676 - 2086) == (4564 - (1181 + 793))) and v15 and v15:Exists() and not v14:CanAttack(v15) and v105.UnitHasDispellableDebuffByPlayer(v15)) then
									if (v101.CleanseSpirit:IsCastable() or ((21 + 61) >= (2177 - (105 + 202)))) then
										if (((2104 + 520) < (5367 - (352 + 458))) and v25(v103.CleanseSpiritMouseover, not v15:IsSpellInRange(v101.PurifySpirit))) then
											return "purify_spirit dispel mouseover";
										end
									end
								end
								break;
							end
							if ((v269 == (0 - 0)) or ((8004 - 4873) > (3429 + 113))) then
								v31 = v133();
								if (((7532 - 4955) >= (2527 - (438 + 511))) and v31) then
									return v31;
								end
								v269 = 1384 - (1262 + 121);
							end
						end
					end
				end
				if (((5171 - (728 + 340)) <= (6361 - (816 + 974))) and v101.GreaterPurge:IsAvailable() and v98 and v101.GreaterPurge:IsReady() and v36 and v84 and not v14:IsCasting() and not v14:IsChanneling() and v105.UnitHasMagicBuff(v17)) then
					if (v25(v101.GreaterPurge, not v17:IsSpellInRange(v101.GreaterPurge)) or ((4579 - 3084) == (17227 - 12440))) then
						return "greater_purge damage";
					end
				end
				v169 = 342 - (163 + 176);
			end
		end
	end
	local function v142()
		local v170 = 0 - 0;
		while true do
			if ((v170 == (0 - 0)) or ((94 + 216) > (6244 - (1564 + 246)))) then
				v37 = EpicSettings.Settings['useChainlightning'];
				v38 = EpicSettings.Settings['useEarthquake'];
				v39 = EpicSettings.Settings['useEarthShock'];
				v40 = EpicSettings.Settings['useElementalBlast'];
				v170 = 346 - (124 + 221);
			end
			if (((1481 + 687) <= (4811 - (115 + 336))) and (v170 == (3 - 1))) then
				v45 = EpicSettings.Settings['useLavaBurst'];
				v46 = EpicSettings.Settings['useLightningBolt'];
				v47 = EpicSettings.Settings['useNaturesSwiftness'];
				v48 = EpicSettings.Settings['usePrimordialWave'];
				v170 = 1 + 2;
			end
			if (((1040 - (45 + 1)) == (54 + 940)) and (v170 == (1993 - (1282 + 708)))) then
				v49 = EpicSettings.Settings['useStormkeeper'];
				v50 = EpicSettings.Settings['useTotemicRecall'];
				v51 = EpicSettings.Settings['useWeaponEnchant'];
				v92 = EpicSettings.Settings['useWeapon'];
				v170 = 1216 - (583 + 629);
			end
			if (((276 + 1379) > (1037 - 636)) and (v170 == (1 + 0))) then
				v41 = EpicSettings.Settings['useFlameShock'];
				v42 = EpicSettings.Settings['useFrostShock'];
				v43 = EpicSettings.Settings['useIceFury'];
				v44 = EpicSettings.Settings['useLavaBeam'];
				v170 = 1172 - (943 + 227);
			end
			if (((1340 + 1723) <= (5057 - (1539 + 92))) and (v170 == (1950 - (706 + 1240)))) then
				v53 = EpicSettings.Settings['useAscendance'];
				v55 = EpicSettings.Settings['useLiquidMagmaTotem'];
				v54 = EpicSettings.Settings['useFireElemental'];
				v56 = EpicSettings.Settings['useStormElemental'];
				v170 = 263 - (81 + 177);
			end
			if (((4121 - 2662) > (1021 - (212 + 45))) and (v170 == (16 - 11))) then
				v59 = EpicSettings.Settings['ascendanceWithCD'];
				v62 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
				v60 = EpicSettings.Settings['fireElementalWithCD'];
				v61 = EpicSettings.Settings['stormElementalWithCD'];
				v170 = 1952 - (708 + 1238);
			end
			if (((1 + 5) == v170) or ((210 + 431) > (6001 - (586 + 1081)))) then
				v65 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v66 = EpicSettings.Settings['stormkeeperWithMiniCD'];
				break;
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
		v76 = EpicSettings.Settings['ancestralGuidanceHP'] or (511 - (348 + 163));
		v77 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
		v78 = EpicSettings.Settings['astralShiftHP'] or (280 - (215 + 65));
		v79 = EpicSettings.Settings['healingStreamTotemHP'] or (0 - 0);
		v80 = EpicSettings.Settings['healingStreamTotemGroup'] or (1859 - (1541 + 318));
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
		local v183 = 0 + 0;
		while true do
			if (((2562 + 837) >= (4010 - (1036 + 714))) and ((0 + 0) == v183)) then
				v91 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v88 = EpicSettings.Settings['InterruptWithStun'];
				v89 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v90 = EpicSettings.Settings['InterruptThreshold'];
				v183 = 1281 - (883 + 397);
			end
			if ((v183 == (591 - (563 + 27))) or ((1537 - 1144) >= (6228 - (1369 + 617)))) then
				v85 = EpicSettings.Settings['DispelDebuffs'];
				v84 = EpicSettings.Settings['DispelBuffs'];
				v57 = EpicSettings.Settings['useTrinkets'];
				v58 = EpicSettings.Settings['useRacials'];
				v183 = 1489 - (85 + 1402);
			end
			if (((341 + 648) < (12541 - 7682)) and (v183 == (405 - (274 + 129)))) then
				v63 = EpicSettings.Settings['trinketsWithCD'];
				v64 = EpicSettings.Settings['racialsWithCD'];
				v94 = EpicSettings.Settings['useHealthstone'];
				v93 = EpicSettings.Settings['useHealingPotion'];
				v183 = 220 - (12 + 205);
			end
			if ((v183 == (4 + 0)) or ((18592 - 13797) < (919 + 30))) then
				v87 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((4226 - (27 + 357)) == (4322 - (91 + 389))) and (v183 == (300 - (90 + 207)))) then
				v96 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v95 = EpicSettings.Settings['healingPotionHP'] or (861 - (706 + 155));
				v97 = EpicSettings.Settings['HealingPotionName'] or "";
				v86 = EpicSettings.Settings['handleAfflicted'];
				v183 = 1799 - (730 + 1065);
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
		if (((3310 - (1339 + 224)) <= (1832 + 1769)) and v14:IsDeadOrGhost()) then
			return v31;
		end
		v112 = v14:GetEnemiesInRange(36 + 4);
		v113 = v17:GetEnemiesInSplashRange(7 - 2);
		if (v33 or ((1647 - (268 + 575)) > (5653 - (919 + 375)))) then
			local v211 = 0 - 0;
			while true do
				if (((5641 - (180 + 791)) >= (5428 - (323 + 1482))) and ((1918 - (1177 + 741)) == v211)) then
					v114 = #v112;
					v115 = v28(v17:GetEnemiesInSplashRangeCount(1 + 4), v114);
					break;
				end
			end
		else
			local v212 = 0 - 0;
			while true do
				if (((795 + 1270) < (5681 - 3137)) and (v212 == (0 + 0))) then
					v114 = 110 - (96 + 13);
					v115 = 1922 - (962 + 959);
					break;
				end
			end
		end
		if (((3274 - 1963) <= (595 + 2764)) and v36 and v85) then
			local v213 = 1351 - (461 + 890);
			while true do
				if (((1993 + 724) <= (12296 - 9140)) and ((243 - (19 + 224)) == v213)) then
					if (((980 + 101) < (4722 - (37 + 161))) and v14:AffectingCombat() and v101.CleanseSpirit:IsAvailable()) then
						local v270 = v85 and v101.CleanseSpirit:IsReady() and v36;
						v31 = v105.FocusUnit(v270, nil, 8 + 12, nil, 10 + 15, v101.HealingSurge);
						if (((434 + 6) >= (132 - (60 + 1))) and v31) then
							return v31;
						end
					end
					if (((5857 - (826 + 97)) > (2525 + 82)) and v101.CleanseSpirit:IsAvailable()) then
						if ((v15 and v15:Exists() and v15:IsAPlayer() and v105.UnitHasCurseDebuff(v15)) or ((5032 - 3632) > (6419 - 3303))) then
							if (((1210 - (375 + 310)) < (3661 - (1864 + 135))) and v101.CleanseSpirit:IsReady()) then
								if (v25(v103.CleanseSpiritMouseover) or ((2260 - 1384) > (565 + 1985))) then
									return "cleanse_spirit mouseover";
								end
							end
						end
					end
					break;
				end
			end
		end
		if (((74 + 145) <= (6034 - 3578)) and (v105.TargetIsValid() or v14:AffectingCombat())) then
			v108 = v10.BossFightRemains();
			v109 = v108;
			if ((v109 == (12242 - (314 + 817))) or ((2393 + 1826) == (1364 - (32 + 182)))) then
				v109 = v10.FightRemains(v112, false);
			end
		end
		if ((not v14:IsChanneling() and not v14:IsCasting()) or ((2209 + 780) <= (775 - 553))) then
			local v214 = 65 - (39 + 26);
			while true do
				if (((2402 - (54 + 90)) > (1439 - (45 + 153))) and ((0 + 0) == v214)) then
					if (((593 - (457 + 95)) < (4232 + 27)) and v86) then
						local v271 = 0 - 0;
						while true do
							if ((v271 == (2 - 1)) or ((6978 - 5048) < (26 + 30))) then
								if (((11494 - 8161) == (10062 - 6729)) and v83) then
									v31 = v105.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 778 - (485 + 263));
									if (v31 or ((2932 - (575 + 132)) == (881 - (750 + 111)))) then
										return v31;
									end
								end
								break;
							end
							if ((v271 == (1010 - (445 + 565))) or ((702 + 170) >= (444 + 2648))) then
								if (((7779 - 3375) >= (1086 + 2166)) and v81) then
									v31 = v105.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 350 - (189 + 121));
									if (((275 + 832) > (2143 - (634 + 713))) and v31) then
										return v31;
									end
								end
								if (((1497 - (493 + 45)) == (1927 - (493 + 475))) and v82) then
									v31 = v105.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 8 + 22);
									if (v31 or ((1029 - (158 + 626)) >= (1037 + 1167))) then
										return v31;
									end
								end
								v271 = 1 - 0;
							end
						end
					end
					if (((704 + 2458) >= (112 + 1957)) and v14:AffectingCombat()) then
						local v272 = 1091 - (1035 + 56);
						while true do
							if (((960 - (114 + 845)) == v272) or ((120 + 186) > (7886 - 4805))) then
								if (v31 or ((2954 + 559) < (3755 - (179 + 870)))) then
									return v31;
								end
								break;
							end
							if (((4176 - 1198) < (4517 - (827 + 51))) and (v272 == (0 - 0))) then
								if (((1845 + 1837) >= (3361 - (95 + 378))) and v34 and v92 and (v102.Dreambinder:IsEquippedAndReady() or v102.Iridal:IsEquippedAndReady())) then
									if (((11 + 138) < (678 - 199)) and v25(v103.UseWeapon, nil)) then
										return "Using Weapon Macro";
									end
								end
								v31 = v141();
								v272 = 1 + 0;
							end
						end
					else
						local v273 = 1011 - (334 + 677);
						while true do
							if (((3818 - 2798) >= (1623 - (1049 + 7))) and (v273 == (0 - 0))) then
								v31 = v140();
								if (v31 or ((1378 - 645) > (770 + 1699))) then
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
	end
	local function v146()
		local v189 = 0 - 0;
		while true do
			if (((5001 - 2504) == (1112 + 1385)) and (v189 == (1420 - (1004 + 416)))) then
				v101.FlameShockDebuff:RegisterAuraTracking();
				v107();
				v189 = 1958 - (1621 + 336);
			end
			if (((5840 - (337 + 1602)) == (5418 - (1014 + 503))) and (v189 == (1016 - (446 + 569)))) then
				v22.Print("Elemental Shaman by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(11 + 251, v145, v146);
end;
return v0["Epix_Shaman_Elemental.lua"]();

