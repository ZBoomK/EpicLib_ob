local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 940 - (850 + 90);
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((2585 - (360 + 1030)) == (1226 + 159))) then
			v6 = v0[v4];
			if (not v6 or ((11642 - 7517) >= (6452 - 1762))) then
				return v1(v4, ...);
			end
			v5 = 1662 - (909 + 752);
		end
		if ((v5 == (1224 - (109 + 1114))) or ((91 - 41) >= (349 + 547))) then
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
		if (v100.CleanseSpirit:IsAvailable() or ((1956 - (6 + 236)) >= (1864 + 1094))) then
			v104.DispellableDebuffs = v104.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v106();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v10:RegisterForEvent(function()
		local v145 = 0 + 0;
		while true do
			if ((v145 == (0 - 0)) or ((2604 - 1113) < (1777 - (1076 + 57)))) then
				v100.PrimordialWave:RegisterInFlightEffect(53803 + 273359);
				v100.PrimordialWave:RegisterInFlight();
				v145 = 690 - (579 + 110);
			end
			if (((56 + 648) < (873 + 114)) and (v145 == (1 + 0))) then
				v100.LavaBurst:RegisterInFlight();
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v100.PrimordialWave:RegisterInFlightEffect(327569 - (174 + 233));
	v100.PrimordialWave:RegisterInFlight();
	v100.LavaBurst:RegisterInFlight();
	local v107 = 31036 - 19925;
	local v108 = 19501 - 8390;
	local v109, v110;
	local v111, v112;
	local v113 = 0 + 0;
	local v114 = 1174 - (663 + 511);
	local v115 = 0 + 0;
	local v116 = 0 + 0;
	local v117 = 0 - 0;
	local function v118()
		return (25 + 15) - (v29() - v115);
	end
	v10:RegisterForSelfCombatEvent(function(...)
		local v146, v147, v147, v147, v148 = select(18 - 10, ...);
		if (((9000 - 5282) > (910 + 996)) and (v146 == v14:GUID()) and (v148 == (372988 - 181354))) then
			local v208 = 0 + 0;
			while true do
				if ((v208 == (0 + 0)) or ((1680 - (478 + 244)) > (4152 - (440 + 77)))) then
					v116 = v29();
					C_Timer.After(0.1 + 0, function()
						if (((12813 - 9312) <= (6048 - (655 + 901))) and (v116 ~= v117)) then
							v115 = v116;
						end
					end);
					break;
				end
			end
		end
	end, "SPELL_AURA_APPLIED");
	local function v119(v149)
		return (v149:DebuffRefreshable(v100.FlameShockDebuff));
	end
	local function v120(v150)
		return v150:DebuffRefreshable(v100.FlameShockDebuff) and (v150:DebuffRemains(v100.FlameShockDebuff) < (v150:TimeToDie() - (1 + 4)));
	end
	local function v121(v151)
		return v151:DebuffRefreshable(v100.FlameShockDebuff) and (v151:DebuffRemains(v100.FlameShockDebuff) < (v151:TimeToDie() - (4 + 1))) and (v151:DebuffRemains(v100.FlameShockDebuff) > (0 + 0));
	end
	local function v122(v152)
		return (v152:DebuffRemains(v100.FlameShockDebuff));
	end
	local function v123(v153)
		return v153:DebuffRemains(v100.FlameShockDebuff) > (7 - 5);
	end
	local function v124(v154)
		return (v154:DebuffRemains(v100.LightningRodDebuff));
	end
	local function v125()
		local v155 = 1445 - (695 + 750);
		local v156;
		while true do
			if ((v155 == (0 - 0)) or ((5311 - 1869) < (10247 - 7699))) then
				v156 = v14:Maelstrom();
				if (((3226 - (285 + 66)) >= (3412 - 1948)) and not v14:IsCasting()) then
					return v156;
				elseif (v14:IsCasting(v100.ElementalBlast) or ((6107 - (682 + 628)) >= (789 + 4104))) then
					return v156 - (374 - (176 + 123));
				elseif (v14:IsCasting(v100.Icefury) or ((231 + 320) > (1501 + 567))) then
					return v156 + (294 - (239 + 30));
				elseif (((575 + 1539) > (908 + 36)) and v14:IsCasting(v100.LightningBolt)) then
					return v156 + (17 - 7);
				elseif (v14:IsCasting(v100.LavaBurst) or ((7056 - 4794) >= (3411 - (306 + 9)))) then
					return v156 + (41 - 29);
				elseif (v14:IsCasting(v100.ChainLightning) or ((393 + 1862) >= (2171 + 1366))) then
					return v156 + ((2 + 2) * v114);
				else
					return v156;
				end
				break;
			end
		end
	end
	local function v126(v157)
		local v158 = 0 - 0;
		local v159;
		while true do
			if ((v158 == (1375 - (1140 + 235))) or ((2442 + 1395) < (1198 + 108))) then
				v159 = v157:IsReady();
				if (((758 + 2192) == (3002 - (33 + 19))) and ((v157 == v100.Stormkeeper) or (v157 == v100.ElementalBlast) or (v157 == v100.Icefury))) then
					local v247 = 0 + 0;
					local v248;
					while true do
						if ((v247 == (0 - 0)) or ((2081 + 2642) < (6467 - 3169))) then
							v248 = v14:BuffUp(v100.SpiritwalkersGraceBuff) or not v14:IsMoving();
							return v159 and v248 and not v14:IsCasting(v157);
						end
					end
				elseif (((1066 + 70) >= (843 - (586 + 103))) and (v157 == v100.LavaBeam)) then
					local v266 = v14:BuffUp(v100.SpiritwalkersGraceBuff) or not v14:IsMoving();
					return v159 and v266;
				elseif ((v157 == v100.LightningBolt) or (v157 == v100.ChainLightning) or ((25 + 246) > (14617 - 9869))) then
					local v273 = 1488 - (1309 + 179);
					local v274;
					while true do
						if (((8557 - 3817) >= (1372 + 1780)) and ((0 - 0) == v273)) then
							v274 = v14:BuffUp(v100.SpiritwalkersGraceBuff) or v14:BuffUp(v100.StormkeeperBuff) or not v14:IsMoving();
							return v159 and v274;
						end
					end
				elseif ((v157 == v100.LavaBurst) or ((1948 + 630) >= (7202 - 3812))) then
					local v283 = 0 - 0;
					local v284;
					local v285;
					local v286;
					local v287;
					while true do
						if (((650 - (295 + 314)) <= (4079 - 2418)) and (v283 == (1963 - (1300 + 662)))) then
							v286 = (v100.LavaBurst:Charges() >= (3 - 2)) and not v14:IsCasting(v100.LavaBurst);
							v287 = (v100.LavaBurst:Charges() == (1757 - (1178 + 577))) and v14:IsCasting(v100.LavaBurst);
							v283 = 2 + 0;
						end
						if (((1776 - 1175) < (4965 - (851 + 554))) and ((0 + 0) == v283)) then
							v284 = v14:BuffUp(v100.SpiritwalkersGraceBuff) or v14:BuffUp(v100.LavaSurgeBuff) or not v14:IsMoving();
							v285 = v14:BuffUp(v100.LavaSurgeBuff);
							v283 = 2 - 1;
						end
						if (((510 - 275) < (989 - (115 + 187))) and (v283 == (2 + 0))) then
							return v159 and v284 and (v285 or v286 or v287);
						end
					end
				elseif (((4307 + 242) > (4543 - 3390)) and (v157 == v100.PrimordialWave)) then
					return v159 and v34 and v14:BuffDown(v100.PrimordialWaveBuff) and v14:BuffDown(v100.LavaSurgeBuff);
				else
					return v159;
				end
				break;
			end
		end
	end
	local function v127()
		local v160 = 1161 - (160 + 1001);
		local v161;
		while true do
			if ((v160 == (0 + 0)) or ((3225 + 1449) < (9563 - 4891))) then
				if (((4026 - (237 + 121)) < (5458 - (525 + 372))) and not v100.MasteroftheElements:IsAvailable()) then
					return false;
				end
				v161 = v14:BuffUp(v100.MasteroftheElementsBuff);
				v160 = 1 - 0;
			end
			if ((v160 == (3 - 2)) or ((597 - (96 + 46)) == (4382 - (643 + 134)))) then
				if (not v14:IsCasting() or ((962 + 1701) == (7941 - 4629))) then
					return v161;
				elseif (((15879 - 11602) <= (4292 + 183)) and v14:IsCasting(v105.LavaBurst)) then
					return true;
				elseif (v14:IsCasting(v105.ElementalBlast) or v14:IsCasting(v100.Icefury) or v14:IsCasting(v100.LightningBolt) or v14:IsCasting(v100.ChainLightning) or ((1707 - 837) == (2430 - 1241))) then
					return false;
				else
					return v161;
				end
				break;
			end
		end
	end
	local function v128()
		if (((2272 - (316 + 403)) <= (2083 + 1050)) and not v100.PoweroftheMaelstrom:IsAvailable()) then
			return false;
		end
		local v162 = v14:BuffStack(v100.PoweroftheMaelstromBuff);
		if (not v14:IsCasting() or ((6150 - 3913) >= (1269 + 2242))) then
			return v162 > (0 - 0);
		elseif (((v162 == (1 + 0)) and (v14:IsCasting(v100.LightningBolt) or v14:IsCasting(v100.ChainLightning))) or ((427 + 897) > (10464 - 7444))) then
			return false;
		else
			return v162 > (0 - 0);
		end
	end
	local function v129()
		local v163 = 0 - 0;
		local v164;
		while true do
			if ((v163 == (0 + 0)) or ((5889 - 2897) == (92 + 1789))) then
				if (((9138 - 6032) > (1543 - (12 + 5))) and not v100.Stormkeeper:IsAvailable()) then
					return false;
				end
				v164 = v14:BuffUp(v100.StormkeeperBuff);
				v163 = 3 - 2;
			end
			if (((6449 - 3426) < (8226 - 4356)) and (v163 == (2 - 1))) then
				if (((30 + 113) > (2047 - (1656 + 317))) and not v14:IsCasting()) then
					return v164;
				elseif (((17 + 1) < (1693 + 419)) and v14:IsCasting(v100.Stormkeeper)) then
					return true;
				else
					return v164;
				end
				break;
			end
		end
	end
	local function v130()
		local v165 = 0 - 0;
		local v166;
		while true do
			if (((5398 - 4301) <= (1982 - (5 + 349))) and (v165 == (0 - 0))) then
				if (((5901 - (266 + 1005)) == (3052 + 1578)) and not v100.Icefury:IsAvailable()) then
					return false;
				end
				v166 = v14:BuffUp(v100.IcefuryBuff);
				v165 = 3 - 2;
			end
			if (((4660 - 1120) > (4379 - (561 + 1135))) and (v165 == (1 - 0))) then
				if (((15758 - 10964) >= (4341 - (507 + 559))) and not v14:IsCasting()) then
					return v166;
				elseif (((3723 - 2239) == (4589 - 3105)) and v14:IsCasting(v100.Icefury)) then
					return true;
				else
					return v166;
				end
				break;
			end
		end
	end
	local function v131()
		if (((1820 - (212 + 176)) < (4460 - (250 + 655))) and v100.CleanseSpirit:IsReady() and v36 and v104.DispellableFriendlyUnit(68 - 43)) then
			if (v25(v102.CleanseSpiritFocus) or ((1860 - 795) > (5597 - 2019))) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v132()
		if ((v98 and (v14:HealthPercentage() <= v99)) or ((6751 - (1869 + 87)) < (4879 - 3472))) then
			if (((3754 - (484 + 1417)) < (10315 - 5502)) and v100.HealingSurge:IsReady()) then
				if (v25(v100.HealingSurge) or ((4727 - 1906) < (3204 - (48 + 725)))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v133()
		local v167 = 0 - 0;
		while true do
			if ((v167 == (5 - 3)) or ((1671 + 1203) < (5828 - 3647))) then
				if ((v92 and (v14:HealthPercentage() <= v94)) or ((753 + 1936) <= (100 + 243))) then
					local v249 = 853 - (152 + 701);
					while true do
						if ((v249 == (1311 - (430 + 881))) or ((716 + 1153) == (2904 - (557 + 338)))) then
							if ((v96 == "Refreshing Healing Potion") or ((1049 + 2497) < (6543 - 4221))) then
								if (v101.RefreshingHealingPotion:IsReady() or ((7290 - 5208) == (12680 - 7907))) then
									if (((6991 - 3747) > (1856 - (499 + 302))) and v25(v102.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v96 == "Dreamwalker's Healing Potion") or ((4179 - (39 + 827)) <= (4907 - 3129))) then
								if (v101.DreamwalkersHealingPotion:IsReady() or ((3173 - 1752) >= (8356 - 6252))) then
									if (((2781 - 969) <= (279 + 2970)) and v25(v102.RefreshingHealingPotion)) then
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
			if (((4750 - 3127) <= (314 + 1643)) and (v167 == (0 - 0))) then
				if (((4516 - (103 + 1)) == (4966 - (475 + 79))) and v100.AstralShift:IsReady() and v72 and (v14:HealthPercentage() <= v78)) then
					if (((3783 - 2033) >= (2694 - 1852)) and v25(v100.AstralShift)) then
						return "astral_shift defensive 1";
					end
				end
				if (((566 + 3806) > (1629 + 221)) and v100.AncestralGuidance:IsReady() and v71 and v104.AreUnitsBelowHealthPercentage(v76, v77)) then
					if (((1735 - (1395 + 108)) < (2388 - 1567)) and v25(v100.AncestralGuidance)) then
						return "ancestral_guidance defensive 2";
					end
				end
				v167 = 1205 - (7 + 1197);
			end
			if (((226 + 292) < (315 + 587)) and ((320 - (27 + 292)) == v167)) then
				if (((8773 - 5779) > (1093 - 235)) and v100.HealingStreamTotem:IsReady() and v73 and v104.AreUnitsBelowHealthPercentage(v79, v80)) then
					if (v25(v100.HealingStreamTotem) or ((15747 - 11992) <= (1804 - 889))) then
						return "healing_stream_totem defensive 3";
					end
				end
				if (((7515 - 3569) > (3882 - (43 + 96))) and v101.Healthstone:IsReady() and v93 and (v14:HealthPercentage() <= v95)) then
					if (v25(v102.Healthstone) or ((5445 - 4110) >= (7474 - 4168))) then
						return "healthstone defensive 3";
					end
				end
				v167 = 2 + 0;
			end
		end
	end
	local function v134()
		local v168 = 0 + 0;
		while true do
			if (((9573 - 4729) > (864 + 1389)) and (v168 == (1 - 0))) then
				v31 = v104.HandleBottomTrinket(v103, v34, 13 + 27, nil);
				if (((34 + 418) == (2203 - (1414 + 337))) and v31) then
					return v31;
				end
				break;
			end
			if ((v168 == (1940 - (1642 + 298))) or ((11879 - 7322) < (6003 - 3916))) then
				v31 = v104.HandleTopTrinket(v103, v34, 118 - 78, nil);
				if (((1275 + 2599) == (3015 + 859)) and v31) then
					return v31;
				end
				v168 = 973 - (357 + 615);
			end
		end
	end
	local function v135()
		local v169 = 0 + 0;
		while true do
			if ((v169 == (4 - 2)) or ((1661 + 277) > (10575 - 5640))) then
				if ((v14:IsCasting(v100.ElementalBlast) and v41 and not v100.PrimordialWave:IsAvailable() and v100.FlameShock:IsViable()) or ((3404 + 851) < (233 + 3190))) then
					if (((914 + 540) <= (3792 - (384 + 917))) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
						return "flameshock precombat 10";
					end
				end
				if ((v126(v100.LavaBurst) and v45 and not v14:IsCasting(v100.LavaBurst) and (not v100.ElementalBlast:IsAvailable() or (v100.ElementalBlast:IsAvailable() and not v100.ElementalBlast:IsAvailable()))) or ((4854 - (128 + 569)) <= (4346 - (1407 + 136)))) then
					if (((6740 - (687 + 1200)) >= (4692 - (556 + 1154))) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lavaburst precombat 12";
					end
				end
				v169 = 10 - 7;
			end
			if (((4229 - (9 + 86)) > (3778 - (275 + 146))) and (v169 == (0 + 0))) then
				if ((v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (64 - (29 + 35))) and not v14:BuffUp(v100.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v108)) or ((15143 - 11726) < (7568 - 5034))) then
					if (v25(v100.Stormkeeper) or ((12016 - 9294) <= (107 + 57))) then
						return "stormkeeper precombat 2";
					end
				end
				if ((v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (1012 - (53 + 959))) and v43) or ((2816 - (312 + 96)) < (3659 - 1550))) then
					if (v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury)) or ((318 - (147 + 138)) == (2354 - (813 + 86)))) then
						return "icefury precombat 4";
					end
				end
				v169 = 1 + 0;
			end
			if ((v169 == (1 - 0)) or ((935 - (18 + 474)) >= (1355 + 2660))) then
				if (((11038 - 7656) > (1252 - (860 + 226))) and v126(v100.ElementalBlast) and v40) then
					if (v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast)) or ((583 - (121 + 182)) == (377 + 2682))) then
						return "elemental_blast precombat 6";
					end
				end
				if (((3121 - (988 + 252)) > (147 + 1146)) and v14:IsCasting(v100.ElementalBlast) and v48 and ((v65 and v35) or not v65) and v126(v100.PrimordialWave)) then
					if (((739 + 1618) == (4327 - (49 + 1921))) and v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave precombat 8";
					end
				end
				v169 = 892 - (223 + 667);
			end
			if (((175 - (51 + 1)) == (211 - 88)) and (v169 == (6 - 3))) then
				if ((v14:IsCasting(v100.LavaBurst) and v41 and v100.FlameShock:IsReady()) or ((2181 - (146 + 979)) >= (958 + 2434))) then
					if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((1686 - (311 + 294)) < (2997 - 1922))) then
						return "flameshock precombat 14";
					end
				end
				if ((v14:IsCasting(v100.LavaBurst) and v48 and ((v65 and v35) or not v65) and v126(v100.PrimordialWave)) or ((445 + 604) >= (5875 - (496 + 947)))) then
					if (v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave)) or ((6126 - (1233 + 125)) <= (344 + 502))) then
						return "primordial_wave precombat 16";
					end
				end
				break;
			end
		end
	end
	local function v136()
		local v170 = 0 + 0;
		while true do
			if ((v170 == (1 + 3)) or ((5003 - (963 + 682)) <= (1186 + 234))) then
				if ((v126(v100.LavaBurst) and v14:BuffUp(v100.LavaSurgeBuff) and v100.MasteroftheElements:IsAvailable() and not v127() and (v125() >= (((1564 - (504 + 1000)) - ((4 + 1) * v100.EyeoftheStorm:TalentRank())) - ((2 + 0) * v26(v100.FlowofPower:IsAvailable())))) and ((not v100.EchoesofGreatSundering:IsAvailable() and not v100.LightningRod:IsAvailable()) or v14:BuffUp(v100.EchoesofGreatSunderingBuff)) and ((not v14:BuffUp(v100.AscendanceBuff) and (v114 > (1 + 2)) and v100.UnrelentingCalamity:IsAvailable()) or ((v114 > (4 - 1)) and not v100.UnrelentingCalamity:IsAvailable()) or (v114 == (3 + 0)))) or ((2175 + 1564) <= (3187 - (156 + 26)))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst)) or ((956 + 703) >= (3338 - 1204))) then
						return "lava_burst aoe 44";
					end
					if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((3424 - (149 + 15)) < (3315 - (890 + 70)))) then
						return "lava_burst aoe 44";
					end
				end
				if ((v38 and v100.Earthquake:IsReady() and not v100.EchoesofGreatSundering:IsAvailable() and (v114 > (120 - (39 + 78))) and ((v114 > (485 - (14 + 468))) or (v113 > (6 - 3)))) or ((1869 - 1200) == (2179 + 2044))) then
					if ((v52 == "cursor") or ((1017 + 675) < (125 + 463))) then
						if (v25(v102.EarthquakeCursor, not v17:IsInRange(19 + 21)) or ((1257 + 3540) < (6988 - 3337))) then
							return "earthquake aoe 46";
						end
					end
					if ((v52 == "player") or ((4129 + 48) > (17042 - 12192))) then
						if (v25(v102.EarthquakePlayer, not v17:IsInRange(2 + 38)) or ((451 - (12 + 39)) > (1034 + 77))) then
							return "earthquake aoe 46";
						end
					end
				end
				if (((9443 - 6392) > (3579 - 2574)) and v38 and v100.Earthquake:IsReady() and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (v114 == (1 + 2)) and ((v114 == (2 + 1)) or (v113 == (7 - 4)))) then
					local v250 = 0 + 0;
					while true do
						if (((17847 - 14154) <= (6092 - (1596 + 114))) and (v250 == (0 - 0))) then
							if ((v52 == "cursor") or ((3995 - (164 + 549)) > (5538 - (1059 + 379)))) then
								if (v25(v102.EarthquakeCursor, not v17:IsInRange(49 - 9)) or ((1856 + 1724) < (480 + 2364))) then
									return "earthquake aoe 48";
								end
							end
							if (((481 - (145 + 247)) < (3685 + 805)) and (v52 == "player")) then
								if (v25(v102.EarthquakePlayer, not v17:IsInRange(19 + 21)) or ((14772 - 9789) < (347 + 1461))) then
									return "earthquake aoe 48";
								end
							end
							break;
						end
					end
				end
				if (((3299 + 530) > (6119 - 2350)) and v38 and v100.Earthquake:IsReady() and (v14:BuffUp(v100.EchoesofGreatSunderingBuff))) then
					local v251 = 720 - (254 + 466);
					while true do
						if (((2045 - (544 + 16)) <= (9228 - 6324)) and (v251 == (628 - (294 + 334)))) then
							if (((4522 - (236 + 17)) == (1841 + 2428)) and (v52 == "cursor")) then
								if (((302 + 85) <= (10477 - 7695)) and v25(v102.EarthquakeCursor, not v17:IsInRange(189 - 149))) then
									return "earthquake aoe 50";
								end
							end
							if ((v52 == "player") or ((978 + 921) <= (756 + 161))) then
								if (v25(v102.EarthquakePlayer, not v17:IsInRange(834 - (413 + 381))) or ((182 + 4130) <= (1862 - 986))) then
									return "earthquake aoe 50";
								end
							end
							break;
						end
					end
				end
				v170 = 12 - 7;
			end
			if (((4202 - (582 + 1388)) <= (4422 - 1826)) and ((6 + 2) == v170)) then
				if (((2459 - (326 + 38)) < (10903 - 7217)) and v126(v100.LavaBeam) and v44 and (v114 >= (8 - 2)) and v14:BuffUp(v100.SurgeofPowerBuff) and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) then
					if (v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam)) or ((2215 - (47 + 573)) >= (1578 + 2896))) then
						return "lava_beam aoe 76";
					end
				end
				if ((v126(v100.ChainLightning) and v37 and (v114 >= (25 - 19)) and v14:BuffUp(v100.SurgeofPowerBuff)) or ((7496 - 2877) < (4546 - (1269 + 395)))) then
					if (v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning)) or ((786 - (76 + 416)) >= (5274 - (319 + 124)))) then
						return "chain_lightning aoe 78";
					end
				end
				if (((4637 - 2608) <= (4091 - (564 + 443))) and v126(v100.LavaBurst) and v14:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable() and v14:BuffUp(v100.WindspeakersLavaResurgenceBuff)) then
					local v252 = 0 - 0;
					while true do
						if ((v252 == (458 - (337 + 121))) or ((5968 - 3931) == (8061 - 5641))) then
							if (((6369 - (1261 + 650)) > (1652 + 2252)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 80";
							end
							if (((694 - 258) >= (1940 - (772 + 1045))) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 80";
							end
							break;
						end
					end
				end
				if (((71 + 429) < (1960 - (102 + 42))) and v126(v100.LavaBeam) and v44 and v127() and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) then
					if (((5418 - (1524 + 320)) == (4844 - (1049 + 221))) and v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam))) then
						return "lava_beam aoe 82";
					end
				end
				v170 = 165 - (18 + 138);
			end
			if (((540 - 319) < (1492 - (67 + 1035))) and (v170 == (351 - (136 + 212)))) then
				if ((v38 and v100.Earthquake:IsReady() and v127() and (((v14:BuffStack(v100.MagmaChamberBuff) > (63 - 48)) and (v114 >= ((6 + 1) - v26(v100.UnrelentingCalamity:IsAvailable())))) or (v100.SplinteredElements:IsAvailable() and (v114 >= ((10 + 0) - v26(v100.UnrelentingCalamity:IsAvailable())))) or (v100.MountainsWillFall:IsAvailable() and (v114 >= (1613 - (240 + 1364))))) and not v100.LightningRod:IsAvailable() and v14:HasTier(1113 - (1050 + 32), 14 - 10)) or ((1310 + 903) <= (2476 - (331 + 724)))) then
					local v253 = 0 + 0;
					while true do
						if (((3702 - (269 + 375)) < (5585 - (267 + 458))) and (v253 == (0 + 0))) then
							if ((v52 == "cursor") or ((2492 - 1196) >= (5264 - (667 + 151)))) then
								if (v25(v102.EarthquakeCursor, not v17:IsInRange(1537 - (1410 + 87))) or ((3290 - (1504 + 393)) > (12133 - 7644))) then
									return "earthquake aoe 36";
								end
							end
							if ((v52 == "player") or ((11477 - 7053) < (823 - (461 + 335)))) then
								if (v25(v102.EarthquakePlayer, not v17:IsInRange(6 + 34)) or ((3758 - (1730 + 31)) > (5482 - (728 + 939)))) then
									return "earthquake aoe 36";
								end
							end
							break;
						end
					end
				end
				if (((12271 - 8806) > (3879 - 1966)) and v126(v100.LavaBeam) and v44 and v129() and ((v14:BuffUp(v100.SurgeofPowerBuff) and (v114 >= (13 - 7))) or (v127() and ((v114 < (1074 - (138 + 930))) or not v100.SurgeofPower:IsAvailable()))) and not v100.LightningRod:IsAvailable() and v14:HasTier(29 + 2, 4 + 0)) then
					if (((629 + 104) < (7427 - 5608)) and v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam))) then
						return "lava_beam aoe 38";
					end
				end
				if ((v126(v100.ChainLightning) and v37 and v129() and ((v14:BuffUp(v100.SurgeofPowerBuff) and (v114 >= (1772 - (459 + 1307)))) or (v127() and ((v114 < (1876 - (474 + 1396))) or not v100.SurgeofPower:IsAvailable()))) and not v100.LightningRod:IsAvailable() and v14:HasTier(53 - 22, 4 + 0)) or ((15 + 4380) == (13620 - 8865))) then
					if (v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning)) or ((481 + 3312) < (7908 - 5539))) then
						return "chain_lightning aoe 40";
					end
				end
				if ((v126(v100.LavaBurst) and v14:BuffUp(v100.LavaSurgeBuff) and not v100.LightningRod:IsAvailable() and v14:HasTier(135 - 104, 595 - (562 + 29))) or ((3482 + 602) == (1684 - (374 + 1045)))) then
					local v254 = 0 + 0;
					while true do
						if (((13532 - 9174) == (4996 - (448 + 190))) and (v254 == (0 + 0))) then
							if (v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst)) or ((1417 + 1721) < (647 + 346))) then
								return "lava_burst aoe 42";
							end
							if (((12803 - 9473) > (7217 - 4894)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 42";
							end
							break;
						end
					end
				end
				v170 = 1498 - (1307 + 187);
			end
			if (((27 - 20) == v170) or ((8489 - 4863) == (12230 - 8241))) then
				if ((v126(v100.LavaBeam) and v44 and (v129())) or ((1599 - (232 + 451)) == (2551 + 120))) then
					if (((241 + 31) == (836 - (510 + 54))) and v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam))) then
						return "lava_beam aoe 68";
					end
				end
				if (((8560 - 4311) <= (4875 - (13 + 23))) and v126(v100.ChainLightning) and v37 and (v129())) then
					if (((5413 - 2636) < (4598 - 1398)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning aoe 70";
					end
				end
				if (((172 - 77) < (3045 - (830 + 258))) and v126(v100.LavaBeam) and v44 and v128() and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) then
					if (((2913 - 2087) < (1075 + 642)) and v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam))) then
						return "lava_beam aoe 72";
					end
				end
				if (((1214 + 212) >= (2546 - (860 + 581))) and v126(v100.ChainLightning) and v37 and v128()) then
					if (((10158 - 7404) <= (2682 + 697)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning aoe 74";
					end
				end
				v170 = 249 - (237 + 4);
			end
			if ((v170 == (4 - 2)) or ((9935 - 6008) == (2678 - 1265))) then
				if ((v126(v100.PrimordialWave) and v14:BuffDown(v100.PrimordialWaveBuff) and v100.MasteroftheElements:IsAvailable() and not v100.LightningRod:IsAvailable()) or ((945 + 209) <= (453 + 335))) then
					if (v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v17:IsSpellInRange(v100.PrimordialWave), nil, nil) or ((6202 - 4559) > (1450 + 1929))) then
						return "primordial_wave aoe 16";
					end
					if (v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave)) or ((1525 + 1278) > (5975 - (85 + 1341)))) then
						return "primordial_wave aoe 16";
					end
				end
				if (v100.FlameShock:IsCastable() or ((375 - 155) >= (8534 - 5512))) then
					local v255 = 372 - (45 + 327);
					while true do
						if (((5324 - 2502) == (3324 - (444 + 58))) and (v255 == (0 + 0))) then
							if ((v14:BuffUp(v100.SurgeofPowerBuff) and v41 and v100.LightningRod:IsAvailable() and v100.WindspeakersLavaResurgence:IsAvailable() and (v17:DebuffRemains(v100.FlameShockDebuff) < (v17:TimeToDie() - (3 + 13))) and (v111 < (3 + 2))) or ((3074 - 2013) == (3589 - (64 + 1668)))) then
								if (((4733 - (1227 + 746)) > (4192 - 2828)) and v104.CastCycle(v100.FlameShock, v112, v120, not v17:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 18";
								end
								if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((9097 - 4195) <= (4089 - (415 + 79)))) then
									return "flame_shock aoe 18";
								end
							end
							if ((v14:BuffUp(v100.SurgeofPowerBuff) and v41 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable()) and (v100.FlameShockDebuff:AuraActiveCount() < (1 + 5))) or ((4343 - (142 + 349)) == (126 + 167))) then
								local v275 = 0 - 0;
								while true do
									if ((v275 == (0 + 0)) or ((1099 + 460) == (12494 - 7906))) then
										if (v104.CastCycle(v100.FlameShock, v112, v120, not v17:IsSpellInRange(v100.FlameShock)) or ((6348 - (1710 + 154)) == (1106 - (200 + 118)))) then
											return "flame_shock aoe 20";
										end
										if (((1811 + 2757) >= (6830 - 2923)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 20";
										end
										break;
									end
								end
							end
							v255 = 1 - 0;
						end
						if (((1108 + 138) < (3433 + 37)) and (v255 == (2 + 1))) then
							if (((650 + 3418) >= (2105 - 1133)) and v100.DeeplyRootedElements:IsAvailable() and v41 and not v100.SurgeofPower:IsAvailable()) then
								if (((1743 - (363 + 887)) < (6797 - 2904)) and v104.CastCycle(v100.FlameShock, v112, v121, not v17:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 30";
								end
								if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((7011 - 5538) >= (515 + 2817))) then
									return "flame_shock aoe 30";
								end
							end
							break;
						end
						if ((v255 == (4 - 2)) or ((2769 + 1282) <= (2821 - (674 + 990)))) then
							if (((174 + 430) < (1180 + 1701)) and v14:BuffUp(v100.SurgeofPowerBuff) and v41 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable())) then
								if (v104.CastCycle(v100.FlameShock, v112, v121, not v17:IsSpellInRange(v100.FlameShock)) or ((1426 - 526) == (4432 - (507 + 548)))) then
									return "flame_shock aoe 26";
								end
								if (((5296 - (289 + 548)) > (2409 - (821 + 997))) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 26";
								end
							end
							if (((3653 - (195 + 60)) >= (644 + 1751)) and v100.MasteroftheElements:IsAvailable() and v41 and not v100.LightningRod:IsAvailable() and not v100.SurgeofPower:IsAvailable()) then
								if (v104.CastCycle(v100.FlameShock, v112, v121, not v17:IsSpellInRange(v100.FlameShock)) or ((3684 - (251 + 1250)) >= (8272 - 5448))) then
									return "flame_shock aoe 28";
								end
								if (((1331 + 605) == (2968 - (809 + 223))) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 28";
								end
							end
							v255 = 3 - 0;
						end
						if ((v255 == (2 - 1)) or ((15976 - 11144) < (3177 + 1136))) then
							if (((2141 + 1947) > (4491 - (14 + 603))) and v100.MasteroftheElements:IsAvailable() and v41 and not v100.LightningRod:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (135 - (118 + 11)))) then
								local v276 = 0 + 0;
								while true do
									if (((3609 + 723) == (12624 - 8292)) and (v276 == (949 - (551 + 398)))) then
										if (((2528 + 1471) >= (1032 + 1868)) and v104.CastCycle(v100.FlameShock, v112, v120, not v17:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 22";
										end
										if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((2053 + 472) > (15114 - 11050))) then
											return "flame_shock aoe 22";
										end
										break;
									end
								end
							end
							if (((10071 - 5700) == (1417 + 2954)) and v100.DeeplyRootedElements:IsAvailable() and v41 and not v100.SurgeofPower:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (23 - 17))) then
								local v277 = 0 + 0;
								while true do
									if (((89 - (40 + 49)) == v277) or ((1012 - 746) > (5476 - (99 + 391)))) then
										if (((1647 + 344) >= (4066 - 3141)) and v104.CastCycle(v100.FlameShock, v112, v120, not v17:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 24";
										end
										if (((1126 - 671) < (2000 + 53)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 24";
										end
										break;
									end
								end
							end
							v255 = 5 - 3;
						end
					end
				end
				if ((v100.Ascendance:IsCastable() and v53 and ((v59 and v34) or not v59) and (v91 < v108)) or ((2430 - (1032 + 572)) == (5268 - (203 + 214)))) then
					if (((2000 - (568 + 1249)) == (144 + 39)) and v25(v100.Ascendance)) then
						return "ascendance aoe 32";
					end
				end
				if (((2783 - 1624) <= (6906 - 5118)) and v126(v100.LavaBurst) and (v114 == (1309 - (913 + 393))) and not v100.LightningRod:IsAvailable() and v14:HasTier(87 - 56, 5 - 1)) then
					local v256 = 410 - (269 + 141);
					while true do
						if (((0 - 0) == v256) or ((5488 - (362 + 1619)) > (5943 - (950 + 675)))) then
							if (v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst)) or ((1186 + 1889) <= (4144 - (216 + 963)))) then
								return "lava_burst aoe 34";
							end
							if (((2652 - (485 + 802)) <= (2570 - (432 + 127))) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 34";
							end
							break;
						end
					end
				end
				v170 = 1076 - (1065 + 8);
			end
			if ((v170 == (5 + 4)) or ((4377 - (635 + 966)) > (2571 + 1004))) then
				if ((v126(v100.LavaBurst) and (v114 == (45 - (5 + 37))) and v100.MasteroftheElements:IsAvailable()) or ((6351 - 3797) == (1999 + 2805))) then
					if (((4078 - 1501) == (1206 + 1371)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 84";
					end
					if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((12 - 6) >= (7161 - 5272))) then
						return "lava_burst aoe 84";
					end
				end
				if (((953 - 447) <= (4523 - 2631)) and v126(v100.LavaBurst) and v14:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable()) then
					local v257 = 0 + 0;
					while true do
						if ((v257 == (529 - (318 + 211))) or ((9880 - 7872) > (3805 - (963 + 624)))) then
							if (((162 + 217) <= (4993 - (518 + 328))) and v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 86";
							end
							if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((10522 - 6008) <= (1612 - 603))) then
								return "lava_burst aoe 86";
							end
							break;
						end
					end
				end
				if ((v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (317 - (301 + 16))) and v43 and v100.ElectrifiedShocks:IsAvailable() and (v114 < (14 - 9))) or ((9818 - 6322) == (3110 - 1918))) then
					if (v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury)) or ((189 + 19) == (1681 + 1278))) then
						return "icefury aoe 88";
					end
				end
				if (((9131 - 4854) >= (790 + 523)) and v126(v100.FrostShock) and v42 and v14:BuffUp(v100.IcefuryBuff) and v100.ElectrifiedShocks:IsAvailable() and not v17:DebuffUp(v100.ElectrifiedShocksDebuff) and (v114 < (1 + 4)) and v100.UnrelentingCalamity:IsAvailable()) then
					if (((8224 - 5637) < (1025 + 2149)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock aoe 90";
					end
				end
				v170 = 1029 - (829 + 190);
			end
			if ((v170 == (21 - 15)) or ((5213 - 1093) <= (3038 - 840))) then
				if ((v126(v100.EarthShock) and v39 and v100.EchoesofGreatSundering:IsAvailable()) or ((3964 - 2368) == (204 + 654))) then
					if (((1052 + 2168) == (9773 - 6553)) and v25(v100.EarthShock, not v17:IsSpellInRange(v100.EarthShock))) then
						return "earth_shock aoe 60";
					end
				end
				if ((v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 + 0)) and v43 and not v14:BuffUp(v100.AscendanceBuff) and v100.ElectrifiedShocks:IsAvailable() and ((v100.LightningRod:IsAvailable() and (v114 < (618 - (520 + 93))) and not v127()) or (v100.DeeplyRootedElements:IsAvailable() and (v114 == (279 - (259 + 17)))))) or ((81 + 1321) > (1303 + 2317))) then
					if (((8714 - 6140) == (3165 - (396 + 195))) and v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury))) then
						return "icefury aoe 62";
					end
				end
				if (((5216 - 3418) < (4518 - (440 + 1321))) and v126(v100.FrostShock) and v42 and not v14:BuffUp(v100.AscendanceBuff) and v14:BuffUp(v100.IcefuryBuff) and v100.ElectrifiedShocks:IsAvailable() and (not v17:DebuffUp(v100.ElectrifiedShocksDebuff) or (v14:BuffRemains(v100.IcefuryBuff) < v14:GCD())) and ((v100.LightningRod:IsAvailable() and (v114 < (1834 - (1059 + 770))) and not v127()) or (v100.DeeplyRootedElements:IsAvailable() and (v114 == (13 - 10))))) then
					if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((922 - (424 + 121)) > (475 + 2129))) then
						return "frost_shock aoe 64";
					end
				end
				if (((1915 - (641 + 706)) < (361 + 550)) and v126(v100.LavaBurst) and v100.MasteroftheElements:IsAvailable() and not v127() and (v129() or ((v118() < (443 - (249 + 191))) and v14:HasTier(130 - 100, 1 + 1))) and (v125() < ((((231 - 171) - ((432 - (183 + 244)) * v100.EyeoftheStorm:TalentRank())) - ((1 + 1) * v26(v100.FlowofPower:IsAvailable()))) - (740 - (434 + 296)))) and (v114 < (15 - 10))) then
					local v258 = 512 - (169 + 343);
					while true do
						if (((2880 + 405) < (7439 - 3211)) and (v258 == (0 - 0))) then
							if (((3209 + 707) > (9438 - 6110)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 66";
							end
							if (((3623 - (651 + 472)) < (2902 + 937)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 66";
							end
							break;
						end
					end
				end
				v170 = 4 + 3;
			end
			if (((618 - 111) == (990 - (397 + 86))) and ((886 - (423 + 453)) == v170)) then
				if (((25 + 215) <= (418 + 2747)) and v126(v100.LavaBeam) and v44 and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) then
					if (((729 + 105) >= (643 + 162)) and v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam))) then
						return "lava_beam aoe 92";
					end
				end
				if ((v126(v100.ChainLightning) and v37) or ((3406 + 406) < (3506 - (50 + 1140)))) then
					if (v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning)) or ((2293 + 359) <= (906 + 627))) then
						return "chain_lightning aoe 94";
					end
				end
				if ((v100.FlameShock:IsCastable() and v41 and v14:IsMoving() and v17:DebuffRefreshable(v100.FlameShockDebuff)) or ((224 + 3374) < (2096 - 636))) then
					if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((2979 + 1137) < (1788 - (157 + 439)))) then
						return "flame_shock aoe 96";
					end
				end
				if ((v100.FrostShock:IsCastable() and v42 and v14:IsMoving()) or ((5872 - 2495) <= (3000 - 2097))) then
					if (((11760 - 7784) >= (1357 - (782 + 136))) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock aoe 98";
					end
				end
				break;
			end
			if (((4607 - (112 + 743)) == (4923 - (1026 + 145))) and ((1 + 0) == v170)) then
				if (((4764 - (493 + 225)) > (9905 - 7210)) and v100.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v34) or not v62) and (v91 < v108) and (v67 == "cursor")) then
					if (v25(v102.LiquidMagmaTotemCursor, not v17:IsInRange(25 + 15)) or ((9504 - 5959) == (61 + 3136))) then
						return "liquid_magma_totem aoe cursor 10";
					end
				end
				if (((6841 - 4447) > (109 + 264)) and v100.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v34) or not v62) and (v91 < v108) and (v67 == "player")) then
					if (((6941 - 2786) <= (5827 - (210 + 1385))) and v25(v102.LiquidMagmaTotemPlayer, not v17:IsInRange(1729 - (1201 + 488)))) then
						return "liquid_magma_totem aoe player 11";
					end
				end
				if ((v126(v100.PrimordialWave) and v14:BuffDown(v100.PrimordialWaveBuff) and v14:BuffUp(v100.SurgeofPowerBuff) and v14:BuffDown(v100.SplinteredElementsBuff)) or ((2220 + 1361) == (6176 - 2703))) then
					local v259 = 0 - 0;
					while true do
						if (((5580 - (352 + 233)) > (8091 - 4743)) and ((0 + 0) == v259)) then
							if (v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v17:IsSpellInRange(v100.PrimordialWave), nil, nil) or ((2143 - 1389) > (4298 - (489 + 85)))) then
								return "primordial_wave aoe 12";
							end
							if (((1718 - (277 + 1224)) >= (1550 - (663 + 830))) and v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave))) then
								return "primordial_wave aoe 12";
							end
							break;
						end
					end
				end
				if ((v126(v100.PrimordialWave) and v14:BuffDown(v100.PrimordialWaveBuff) and v100.DeeplyRootedElements:IsAvailable() and not v100.SurgeofPower:IsAvailable() and v14:BuffDown(v100.SplinteredElementsBuff)) or ((1819 + 251) >= (9885 - 5848))) then
					local v260 = 875 - (461 + 414);
					while true do
						if (((454 + 2251) == (1083 + 1622)) and (v260 == (0 + 0))) then
							if (((61 + 0) == (311 - (172 + 78))) and v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v17:IsSpellInRange(v100.PrimordialWave), nil, nil)) then
								return "primordial_wave aoe 14";
							end
							if (v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave)) or ((1126 - 427) >= (477 + 819))) then
								return "primordial_wave aoe 14";
							end
							break;
						end
					end
				end
				v170 = 2 - 0;
			end
			if ((v170 == (0 + 0)) or ((596 + 1187) >= (6058 - 2442))) then
				if ((v100.FireElemental:IsReady() and v54 and ((v60 and v34) or not v60) and (v91 < v108)) or ((4925 - 1012) > (1138 + 3389))) then
					if (((2420 + 1956) > (291 + 526)) and v25(v100.FireElemental)) then
						return "fire_elemental aoe 2";
					end
				end
				if (((19350 - 14489) > (1919 - 1095)) and v100.StormElemental:IsReady() and v56 and ((v61 and v34) or not v61) and (v91 < v108)) then
					if (v25(v100.StormElemental) or ((425 + 958) >= (1217 + 914))) then
						return "storm_elemental aoe 4";
					end
				end
				if ((v126(v100.Stormkeeper) and not v129() and v49 and ((v66 and v35) or not v66) and (v91 < v108)) or ((2323 - (133 + 314)) >= (442 + 2099))) then
					if (((1995 - (199 + 14)) <= (13503 - 9731)) and v25(v100.Stormkeeper)) then
						return "stormkeeper aoe 7";
					end
				end
				if ((v100.TotemicRecall:IsCastable() and (v100.LiquidMagmaTotem:CooldownRemains() > (1594 - (647 + 902))) and v50) or ((14132 - 9432) < (1046 - (85 + 148)))) then
					if (((4488 - (426 + 863)) < (18954 - 14904)) and v25(v100.TotemicRecall)) then
						return "totemic_recall aoe 8";
					end
				end
				v170 = 1655 - (873 + 781);
			end
			if ((v170 == (6 - 1)) or ((13370 - 8419) < (1836 + 2594))) then
				if (((354 - 258) == (136 - 40)) and v126(v100.ElementalBlast) and v40 and v100.EchoesofGreatSundering:IsAvailable()) then
					local v261 = 0 - 0;
					while true do
						if ((v261 == (1947 - (414 + 1533))) or ((2375 + 364) > (4563 - (443 + 112)))) then
							if (v104.CastTargetIf(v100.ElementalBlast, v112, "min", v124, nil, not v17:IsSpellInRange(v100.ElementalBlast), nil, nil) or ((1502 - (888 + 591)) == (2930 - 1796))) then
								return "elemental_blast aoe 52";
							end
							if (v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast)) or ((154 + 2539) >= (15483 - 11372))) then
								return "elemental_blast aoe 52";
							end
							break;
						end
					end
				end
				if ((v126(v100.ElementalBlast) and v40 and v100.EchoesofGreatSundering:IsAvailable()) or ((1685 + 2631) <= (1039 + 1107))) then
					if (v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast)) or ((379 + 3167) <= (5352 - 2543))) then
						return "elemental_blast aoe 54";
					end
				end
				if (((9083 - 4179) > (3844 - (136 + 1542))) and v126(v100.ElementalBlast) and v40 and (v114 == (9 - 6)) and not v100.EchoesofGreatSundering:IsAvailable()) then
					if (((109 + 0) >= (143 - 53)) and v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast aoe 56";
					end
				end
				if (((3603 + 1375) > (3391 - (68 + 418))) and v126(v100.EarthShock) and v39 and v100.EchoesofGreatSundering:IsAvailable()) then
					local v262 = 0 - 0;
					while true do
						if ((v262 == (0 - 0)) or ((2613 + 413) <= (3372 - (770 + 322)))) then
							if (v104.CastTargetIf(v100.EarthShock, v112, "min", v124, nil, not v17:IsSpellInRange(v100.EarthShock), nil, nil) or ((96 + 1557) <= (321 + 787))) then
								return "earth_shock aoe 58";
							end
							if (((398 + 2511) > (3732 - 1123)) and v25(v100.EarthShock, not v17:IsSpellInRange(v100.EarthShock))) then
								return "earth_shock aoe 58";
							end
							break;
						end
					end
				end
				v170 = 11 - 5;
			end
		end
	end
	local function v137()
		if (((2061 - 1304) > (713 - 519)) and v100.FireElemental:IsCastable() and v54 and ((v60 and v34) or not v60) and (v91 < v108)) then
			if (v25(v100.FireElemental) or ((18 + 13) >= (2094 - 696))) then
				return "fire_elemental single_target 2";
			end
		end
		if (((1534 + 1662) <= (2987 + 1885)) and v100.StormElemental:IsCastable() and v56 and ((v61 and v34) or not v61) and (v91 < v108)) then
			if (((2607 + 719) == (12524 - 9198)) and v25(v100.StormElemental)) then
				return "storm_elemental single_target 4";
			end
		end
		if (((1989 - 556) <= (1311 + 2567)) and v100.TotemicRecall:IsCastable() and v50 and (v100.LiquidMagmaTotem:CooldownRemains() > (207 - 162)) and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or ((v113 > (3 - 2)) and (v114 > (1 + 0))))) then
			if (v25(v100.TotemicRecall) or ((7833 - 6250) == (2566 - (762 + 69)))) then
				return "totemic_recall single_target 6";
			end
		end
		if ((v100.LiquidMagmaTotem:IsCastable() and v55 and ((v62 and v34) or not v62) and (v91 < v108) and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or (v100.FlameShockDebuff:AuraActiveCount() == (0 - 0)) or (v17:DebuffRemains(v100.FlameShockDebuff) < (6 + 0)) or ((v113 > (1 + 0)) and (v114 > (2 - 1))))) or ((938 + 2043) == (38 + 2312))) then
			local v209 = 0 - 0;
			while true do
				if ((v209 == (157 - (8 + 149))) or ((5786 - (1199 + 121)) <= (833 - 340))) then
					if ((v67 == "cursor") or ((5750 - 3203) <= (819 + 1168))) then
						if (((10569 - 7608) > (6357 - 3617)) and v25(v102.LiquidMagmaTotemCursor, not v17:IsInRange(36 + 4))) then
							return "liquid_magma_totem single_target cursor 8";
						end
					end
					if (((5503 - (518 + 1289)) >= (6193 - 2581)) and (v67 == "player")) then
						if (v25(v102.LiquidMagmaTotemPlayer, not v17:IsInRange(6 + 34)) or ((4337 - 1367) == (1384 + 494))) then
							return "liquid_magma_totem single_target player 8";
						end
					end
					break;
				end
			end
		end
		if ((v126(v100.PrimordialWave) and v100.PrimordialWave:IsCastable() and v48 and ((v65 and v35) or not v65) and not v14:BuffUp(v100.PrimordialWaveBuff) and not v14:BuffUp(v100.SplinteredElementsBuff)) or ((4162 - (304 + 165)) < (1867 + 110))) then
			if (v104.CastCycle(v100.PrimordialWave, v112, v122, not v17:IsSpellInRange(v100.PrimordialWave)) or ((1090 - (54 + 106)) > (4070 - (1618 + 351)))) then
				return "primordial_wave single_target 10";
			end
			if (((2929 + 1224) > (4102 - (10 + 1006))) and v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave))) then
				return "primordial_wave single_target 10";
			end
		end
		if ((v100.FlameShock:IsCastable() and v41 and (v113 == (1 + 0)) and v17:DebuffRefreshable(v100.FlameShockDebuff) and ((v17:DebuffRemains(v100.FlameShockDebuff) < v100.PrimordialWave:CooldownRemains()) or not v100.PrimordialWave:IsAvailable()) and v14:BuffDown(v100.SurgeofPowerBuff) and (not v127() or (not v129() and ((v100.ElementalBlast:IsAvailable() and (v125() < ((13 + 77) - ((25 - 17) * v100.EyeoftheStorm:TalentRank())))) or (v125() < ((1093 - (912 + 121)) - ((3 + 2) * v100.EyeoftheStorm:TalentRank()))))))) or ((5943 - (1140 + 149)) <= (2592 + 1458))) then
			if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((3467 - 865) < (279 + 1217))) then
				return "flame_shock single_target 12";
			end
		end
		if ((v100.FlameShock:IsCastable() and v41 and (v100.FlameShockDebuff:AuraActiveCount() == (0 - 0)) and (v113 > (1 - 0)) and (v114 > (1 + 0)) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((not v127() and (v129() or (v100.Stormkeeper:CooldownRemains() > (0 - 0)))) or not v100.SurgeofPower:IsAvailable())) or ((1206 - (165 + 21)) > (2399 - (61 + 50)))) then
			local v210 = 0 + 0;
			while true do
				if (((1563 - 1235) == (660 - 332)) and ((0 + 0) == v210)) then
					if (((2971 - (1295 + 165)) < (869 + 2939)) and v104.CastTargetIf(v100.FlameShock, v112, "min", v122, nil, not v17:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock single_target 14";
					end
					if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((1010 + 1500) > (6316 - (819 + 578)))) then
						return "flame_shock single_target 14";
					end
					break;
				end
			end
		end
		if (((6165 - (331 + 1071)) == (5506 - (588 + 155))) and v100.FlameShock:IsCastable() and v41 and (v113 > (1283 - (546 + 736))) and (v114 > (1938 - (1834 + 103))) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((v14:BuffUp(v100.SurgeofPowerBuff) and not v129() and v100.Stormkeeper:IsAvailable()) or not v100.SurgeofPower:IsAvailable())) then
			local v211 = 0 + 0;
			while true do
				if (((12341 - 8204) > (3614 - (1536 + 230))) and (v211 == (491 - (128 + 363)))) then
					if (((518 + 1918) <= (7796 - 4662)) and v104.CastTargetIf(v100.FlameShock, v112, "min", v122, v119, not v17:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock single_target 16";
					end
					if (((962 + 2761) == (6167 - 2444)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock single_target 16";
					end
					break;
				end
			end
		end
		if ((v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v100.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v108) and v14:BuffDown(v100.AscendanceBuff) and not v129() and (v125() >= (281 - 165)) and v100.ElementalBlast:IsAvailable() and v100.SurgeofPower:IsAvailable() and v100.SwellingMaelstrom:IsAvailable() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) or ((2777 + 1269) >= (5325 - (615 + 394)))) then
			if (v25(v100.Stormkeeper) or ((1813 + 195) < (1839 + 90))) then
				return "stormkeeper single_target 18";
			end
		end
		if (((7267 - 4883) > (8051 - 6276)) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (651 - (59 + 592))) and not v14:BuffUp(v100.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v108) and v14:BuffDown(v100.AscendanceBuff) and not v129() and v14:BuffUp(v100.SurgeofPowerBuff) and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) then
			if (v25(v100.Stormkeeper) or ((10057 - 5514) <= (8057 - 3681))) then
				return "stormkeeper single_target 20";
			end
		end
		if (((514 + 214) == (899 - (70 + 101))) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v100.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v108) and v14:BuffDown(v100.AscendanceBuff) and not v129() and (not v100.SurgeofPower:IsAvailable() or not v100.ElementalBlast:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.EchooftheElements:IsAvailable() or v100.PrimordialSurge:IsAvailable())) then
			if (v25(v100.Stormkeeper) or ((764 + 312) > (11731 - 7060))) then
				return "stormkeeper single_target 22";
			end
		end
		if (((2092 - (123 + 118)) >= (92 + 286)) and v100.Ascendance:IsCastable() and v53 and ((v59 and v34) or not v59) and (v91 < v108) and not v129()) then
			if (v25(v100.Ascendance) or ((25 + 1923) >= (4875 - (653 + 746)))) then
				return "ascendance single_target 24";
			end
		end
		if (((8966 - 4172) >= (1199 - 366)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v129() and v14:BuffUp(v100.SurgeofPowerBuff)) then
			if (((10950 - 6860) == (1805 + 2285)) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 26";
			end
		end
		if ((v126(v100.LavaBeam) and v44 and (v113 > (1 + 0)) and (v114 > (1 + 0)) and v129() and not v100.SurgeofPower:IsAvailable()) or ((461 + 3297) == (390 + 2108))) then
			if (v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam)) or ((6552 - 3879) < (1500 + 75))) then
				return "lava_beam single_target 28";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v37 and (v113 > (1 - 0)) and (v114 > (1235 - (885 + 349))) and v129() and not v100.SurgeofPower:IsAvailable()) or ((2956 + 765) <= (3968 - 2513))) then
			if (((2716 - 1782) < (3238 - (915 + 53))) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 30";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v129() and not v127() and not v100.SurgeofPower:IsAvailable() and v100.MasteroftheElements:IsAvailable()) or ((2413 - (768 + 33)) == (4805 - 3550))) then
			if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((7660 - 3308) < (4534 - (287 + 41)))) then
				return "lava_burst single_target 32";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v129() and not v100.SurgeofPower:IsAvailable() and v127()) or ((3707 - (638 + 209)) <= (95 + 86))) then
			if (((4908 - (96 + 1590)) >= (3199 - (741 + 931))) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 34";
			end
		end
		if (((740 + 765) <= (6042 - 3921)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v129() and not v100.SurgeofPower:IsAvailable() and not v100.MasteroftheElements:IsAvailable()) then
			if (((3475 - 2731) == (320 + 424)) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 36";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v14:BuffUp(v100.SurgeofPowerBuff) and v100.LightningRod:IsAvailable()) or ((851 + 1128) >= (904 + 1932))) then
			if (((6955 - 5122) <= (867 + 1801)) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 38";
			end
		end
		if (((1800 + 1886) == (15035 - 11349)) and v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 + 0)) and v43 and v100.ElectrifiedShocks:IsAvailable() and v100.LightningRod:IsAvailable() and v100.LightningRod:IsAvailable()) then
			if (((3961 - (64 + 430)) > (474 + 3)) and v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury))) then
				return "icefury single_target 40";
			end
		end
		if ((v100.FrostShock:IsCastable() and v42 and v130() and v100.ElectrifiedShocks:IsAvailable() and ((v17:DebuffRemains(v100.ElectrifiedShocksDebuff) < (365 - (106 + 257))) or (v14:BuffRemains(v100.IcefuryBuff) <= v14:GCD())) and v100.LightningRod:IsAvailable()) or ((2332 + 956) >= (4262 - (496 + 225)))) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((7273 - 3716) == (22115 - 17575))) then
				return "frost_shock single_target 42";
			end
		end
		if ((v100.FrostShock:IsCastable() and v42 and v130() and v100.ElectrifiedShocks:IsAvailable() and (v125() >= (1708 - (256 + 1402))) and (v17:DebuffRemains(v100.ElectrifiedShocksDebuff) < ((1901 - (30 + 1869)) * v14:GCD())) and v129() and v100.LightningRod:IsAvailable()) or ((1630 - (213 + 1156)) > (1455 - (96 + 92)))) then
			if (((217 + 1055) < (4757 - (142 + 757))) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 44";
			end
		end
		if (((2985 + 679) == (1498 + 2166)) and v100.LavaBeam:IsCastable() and v44 and (v113 > (80 - (32 + 47))) and (v114 > (1978 - (1053 + 924))) and v128() and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime()) and not v14:HasTier(31 + 0, 6 - 2)) then
			if (((3589 - (685 + 963)) >= (915 - 465)) and v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam single_target 46";
			end
		end
		if ((v100.FrostShock:IsCastable() and v42 and v130() and v129() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable() and v100.ElementalBlast:IsAvailable() and (((v125() >= (94 - 33)) and (v125() < (1784 - (541 + 1168))) and (v100.LavaBurst:CooldownRemains() > v14:GCD())) or ((v125() >= (1646 - (645 + 952))) and (v125() < (901 - (669 + 169))) and (v100.LavaBurst:CooldownRemains() > (0 - 0))))) or ((10088 - 5442) < (110 + 214))) then
			if (((846 + 2987) == (4598 - (181 + 584))) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 48";
			end
		end
		if ((v100.FrostShock:IsCastable() and v42 and v130() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (((v125() >= (1431 - (665 + 730))) and (v125() < (144 - 94)) and (v100.LavaBurst:CooldownRemains() > v14:GCD())) or ((v125() >= (48 - 24)) and (v125() < (1388 - (540 + 810))) and (v100.LavaBurst:CooldownRemains() > (0 - 0))))) or ((3409 - 2169) > (2682 + 688))) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((2684 - (166 + 37)) == (6563 - (22 + 1859)))) then
				return "frost_shock single_target 50";
			end
		end
		if (((6499 - (843 + 929)) >= (470 - (30 + 232))) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v14:BuffUp(v100.WindspeakersLavaResurgenceBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or ((v125() >= (179 - 116)) and v100.MasteroftheElements:IsAvailable()) or ((v125() >= (815 - (55 + 722))) and v14:BuffUp(v100.EchoesofGreatSunderingBuff) and (v113 > (1 - 0)) and (v114 > (1676 - (78 + 1597)))) or not v100.ElementalBlast:IsAvailable())) then
			if (((62 + 218) < (3504 + 347)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 52";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v14:BuffUp(v100.LavaSurgeBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or not v100.ElementalBlast:IsAvailable())) or ((2518 + 489) > (3743 - (305 + 244)))) then
			if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((1982 + 154) >= (3051 - (95 + 10)))) then
				return "lava_burst single_target 54";
			end
		end
		if (((1534 + 631) <= (7989 - 5468)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v14:BuffUp(v100.AscendanceBuff) and (v14:HasTier(42 - 11, 766 - (592 + 170)) or not v100.ElementalBlast:IsAvailable())) then
			if (((9978 - 7117) > (1659 - 998)) and v104.CastCycle(v100.LavaBurst, v112, v123, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 56";
			end
			if (((2110 + 2415) > (1759 + 2760)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 56";
			end
		end
		if (((7674 - 4496) > (158 + 814)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v14:BuffDown(v100.AscendanceBuff) and (not v100.ElementalBlast:IsAvailable() or not v100.MountainsWillFall:IsAvailable()) and not v100.LightningRod:IsAvailable() and v14:HasTier(57 - 26, 511 - (353 + 154))) then
			if (((6343 - 1577) == (6511 - 1745)) and v104.CastCycle(v100.LavaBurst, v112, v123, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 58";
			end
			if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((1894 + 851) > (2450 + 678))) then
				return "lava_burst single_target 58";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v100.MasteroftheElements:IsAvailable() and not v127() and not v100.LightningRod:IsAvailable()) or ((755 + 389) >= (6655 - 2049))) then
			if (((6318 - 2980) >= (645 - 368)) and v104.CastCycle(v100.LavaBurst, v112, v123, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 60";
			end
			if (((2696 - (7 + 79)) > (1198 + 1362)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 60";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v100.MasteroftheElements:IsAvailable() and not v127() and ((v125() >= (256 - (24 + 157))) or ((v125() >= (99 - 49)) and not v100.ElementalBlast:IsAvailable())) and v100.SwellingMaelstrom:IsAvailable() and (v125() <= (277 - 147))) or ((340 + 854) > (8304 - 5221))) then
			if (((1296 - (262 + 118)) >= (1830 - (1038 + 45))) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 62";
			end
		end
		if ((v100.Earthquake:IsReady() and v38 and v14:BuffUp(v100.EchoesofGreatSunderingBuff) and ((not v100.ElementalBlast:IsAvailable() and (v113 < (3 - 1))) or (v113 > (231 - (19 + 211))))) or ((2557 - (88 + 25)) > (7520 - 4566))) then
			local v212 = 0 + 0;
			while true do
				if (((2700 + 192) < (4550 - (1007 + 29))) and (v212 == (0 + 0))) then
					if (((1302 - 769) == (2520 - 1987)) and (v52 == "cursor")) then
						if (((133 + 462) <= (4224 - (340 + 471))) and v25(v102.EarthquakeCursor, not v17:IsInRange(100 - 60))) then
							return "earthquake single_target 64";
						end
					end
					if (((3667 - (276 + 313)) >= (6324 - 3733)) and (v52 == "player")) then
						if (((2949 + 250) < (1709 + 2321)) and v25(v102.EarthquakePlayer, not v17:IsInRange(4 + 36))) then
							return "earthquake single_target 64";
						end
					end
					break;
				end
			end
		end
		if (((2749 - (495 + 1477)) < (6221 - 4143)) and v100.Earthquake:IsReady() and v38 and (v113 > (1 + 0)) and (v114 > (404 - (342 + 61))) and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable()) then
			local v213 = 0 + 0;
			while true do
				if (((1861 - (4 + 161)) <= (1398 + 884)) and (v213 == (0 - 0))) then
					if ((v52 == "cursor") or ((4628 - 2867) >= (2959 - (322 + 175)))) then
						if (((5114 - (173 + 390)) > (575 + 1753)) and v25(v102.EarthquakeCursor, not v17:IsInRange(354 - (203 + 111)))) then
							return "earthquake single_target 66";
						end
					end
					if (((238 + 3587) >= (330 + 137)) and (v52 == "player")) then
						if (v25(v102.EarthquakePlayer, not v17:IsInRange(116 - 76)) or ((2611 + 279) == (1263 - (57 + 649)))) then
							return "earthquake single_target 66";
						end
					end
					break;
				end
			end
		end
		if ((v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v40 and (not v100.MasteroftheElements:IsAvailable() or (v127() and v17:DebuffUp(v100.ElectrifiedShocksDebuff)))) or ((5154 - (328 + 56)) == (929 + 1975))) then
			if (v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast)) or ((4415 - (433 + 79)) == (416 + 4120))) then
				return "elemental_blast single_target 68";
			end
		end
		if (((3305 + 788) <= (16292 - 11447)) and v126(v100.FrostShock) and v42 and v130() and v127() and (v125() < (520 - 410)) and (v100.LavaBurst:ChargesFractional() < (1 + 0)) and v100.ElectrifiedShocks:IsAvailable() and v100.ElementalBlast:IsAvailable() and not v100.LightningRod:IsAvailable()) then
			if (((1398 + 171) <= (4683 - (562 + 474))) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 70";
			end
		end
		if ((v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v40 and (v127() or v100.LightningRod:IsAvailable())) or ((9438 - 5392) >= (10038 - 5111))) then
			if (((5528 - (76 + 829)) >= (4460 - (1506 + 167))) and v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast single_target 72";
			end
		end
		if (((4196 - 1962) >= (1496 - (58 + 208))) and v100.EarthShock:IsReady() and v39) then
			if (v25(v100.EarthShock, not v17:IsSpellInRange(v100.EarthShock)) or ((203 + 140) == (1273 + 513))) then
				return "earth_shock single_target 74";
			end
		end
		if (((1477 + 1093) > (9828 - 7419)) and v126(v100.FrostShock) and v42 and v130() and v100.ElectrifiedShocks:IsAvailable() and v127() and not v100.LightningRod:IsAvailable() and (v113 > (338 - (258 + 79))) and (v114 > (1 + 0))) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((5488 - 2879) >= (4704 - (1219 + 251)))) then
				return "frost_shock single_target 76";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and (v100.DeeplyRootedElements:IsAvailable())) or ((4704 - (1231 + 440)) >= (4089 - (34 + 24)))) then
			local v214 = 0 + 0;
			while true do
				if ((v214 == (0 - 0)) or ((613 + 788) == (14177 - 9509))) then
					if (((8899 - 6123) >= (3473 - 2152)) and v104.CastCycle(v100.LavaBurst, v112, v123, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 78";
					end
					if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((1631 - 1144) > (5028 - 2725))) then
						return "lava_burst single_target 78";
					end
					break;
				end
			end
		end
		if ((v100.FrostShock:IsCastable() and v42 and v130() and v100.FluxMelting:IsAvailable() and v14:BuffDown(v100.FluxMeltingBuff)) or ((6092 - (877 + 712)) == (2073 + 1389))) then
			if (((1307 - (242 + 512)) <= (3224 - 1681)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 80";
			end
		end
		if (((2642 - (92 + 535)) == (1587 + 428)) and v100.FrostShock:IsCastable() and v42 and v130() and ((v100.ElectrifiedShocks:IsAvailable() and (v17:DebuffRemains(v100.ElectrifiedShocksDebuff) < (3 - 1))) or (v14:BuffRemains(v100.IcefuryBuff) < (1 + 5)))) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((15414 - 11173) <= (2287 + 45))) then
				return "frost_shock single_target 82";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.ElementalBlast:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or v129())) or ((1637 + 727) < (163 + 994))) then
			local v215 = 0 - 0;
			while true do
				if ((v215 == (0 - 0)) or ((2952 - (1476 + 309)) > (2562 - (299 + 985)))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v123, not v17:IsSpellInRange(v100.LavaBurst)) or ((273 + 872) <= (3546 - 2464))) then
						return "lava_burst single_target 84";
					end
					if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((3198 - (86 + 7)) == (19947 - 15066))) then
						return "lava_burst single_target 84";
					end
					break;
				end
			end
		end
		if ((v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v40) or ((180 + 1707) > (5758 - (672 + 208)))) then
			if (v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast)) or ((1752 + 2335) > (4248 - (14 + 118)))) then
				return "elemental_blast single_target 86";
			end
		end
		if (((1551 - (339 + 106)) <= (1008 + 258)) and v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v37 and v128() and v100.UnrelentingCalamity:IsAvailable() and (v113 > (1 + 0)) and (v114 > (1396 - (440 + 955)))) then
			if (((3109 + 46) < (8353 - 3703)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 88";
			end
		end
		if (((1253 + 2521) >= (4578 - 2739)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v128() and v100.UnrelentingCalamity:IsAvailable()) then
			if (((1926 + 885) == (3164 - (260 + 93))) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 90";
			end
		end
		if (((2011 + 135) > (2566 - 1444)) and v126(v100.Icefury) and v100.Icefury:IsCastable() and v43) then
			if (v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury)) or ((100 - 44) == (5590 - (1181 + 793)))) then
				return "icefury single_target 92";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v37 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v100.LightningRodDebuff) and (v17:DebuffUp(v100.ElectrifiedShocksDebuff) or v128()) and (v113 > (1 + 0)) and (v114 > (308 - (105 + 202)))) or ((1941 + 480) < (1432 - (352 + 458)))) then
			if (((4067 - 3058) <= (2888 - 1758)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 94";
			end
		end
		if (((2670 + 88) < (8710 - 5730)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v100.LightningRodDebuff) and (v17:DebuffUp(v100.ElectrifiedShocksDebuff) or v128())) then
			if (v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt)) or ((1035 - (438 + 511)) >= (5009 - (1262 + 121)))) then
				return "lightning_bolt single_target 96";
			end
		end
		if (((3463 - (728 + 340)) == (4185 - (816 + 974))) and v100.FrostShock:IsCastable() and v42 and v130() and v127() and v14:BuffDown(v100.LavaSurgeBuff) and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable() and (v100.LavaBurst:ChargesFractional() < (2 - 1)) and v100.EchooftheElements:IsAvailable()) then
			if (((13603 - 9823) > (3048 - (163 + 176))) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 98";
			end
		end
		if ((v100.FrostShock:IsCastable() and v42 and v130() and (v100.FluxMelting:IsAvailable() or (v100.ElectrifiedShocks:IsAvailable() and not v100.LightningRod:IsAvailable()))) or ((674 - 437) >= (10445 - 8172))) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((617 + 1423) <= (2513 - (1564 + 246)))) then
				return "frost_shock single_target 100";
			end
		end
		if (((3624 - (124 + 221)) <= (2710 + 1257)) and v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v37 and v127() and v14:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (452 - (115 + 336))) and v100.EchooftheElements:IsAvailable() and (v113 > (1 - 0)) and (v114 > (1 + 0))) then
			if (v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning)) or ((2034 - (45 + 1)) == (48 + 829))) then
				return "chain_lightning single_target 102";
			end
		end
		if (((6281 - (1282 + 708)) > (3124 - (583 + 629))) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v127() and v14:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (1 + 0)) and v100.EchooftheElements:IsAvailable()) then
			if (((5181 - 3178) < (1227 + 1112)) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 104";
			end
		end
		if (((1602 - (943 + 227)) == (189 + 243)) and v100.FrostShock:IsCastable() and v42 and v130() and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable()) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((2776 - (1539 + 92)) >= (3199 - (706 + 1240)))) then
				return "frost_shock single_target 106";
			end
		end
		if (((3676 - (81 + 177)) > (5983 - 3865)) and v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v37 and (v113 > (258 - (212 + 45))) and (v114 > (3 - 2))) then
			if (((5012 - (708 + 1238)) <= (324 + 3566)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 108";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46) or ((981 + 2017) >= (4948 - (586 + 1081)))) then
			if (v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt)) or ((5160 - (348 + 163)) <= (2364 + 268))) then
				return "lightning_bolt single_target 110";
			end
		end
		if ((v100.FlameShock:IsCastable() and v41 and (v14:IsMoving())) or ((4140 - (215 + 65)) > (12413 - 7541))) then
			if (v104.CastCycle(v100.FlameShock, v112, v119, not v17:IsSpellInRange(v100.FlameShock)) or ((5857 - (1541 + 318)) == (2039 + 259))) then
				return "flame_shock single_target 112";
			end
			if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((5 + 3) >= (2064 + 675))) then
				return "flame_shock single_target 112";
			end
		end
		if (((4340 - (1036 + 714)) == (1707 + 883)) and v100.FlameShock:IsCastable() and v41) then
			if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((46 + 36) >= (3150 - (883 + 397)))) then
				return "flame_shock single_target 114";
			end
		end
		if (((3214 - (563 + 27)) < (17829 - 13272)) and v100.FrostShock:IsCastable() and v42) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((5117 - (1369 + 617)) > (5029 - (85 + 1402)))) then
				return "frost_shock single_target 116";
			end
		end
	end
	local function v138()
		if (((889 + 1688) >= (4073 - 2495)) and v74 and v100.EarthShield:IsCastable() and v14:BuffDown(v100.EarthShieldBuff) and ((v75 == "Earth Shield") or (v100.ElementalOrbit:IsAvailable() and v14:BuffUp(v100.LightningShield)))) then
			if (((4506 - (274 + 129)) <= (4788 - (12 + 205))) and v25(v100.EarthShield)) then
				return "earth_shield main 2";
			end
		elseif ((v74 and v100.LightningShield:IsCastable() and v14:BuffDown(v100.LightningShieldBuff) and ((v75 == "Lightning Shield") or (v100.ElementalOrbit:IsAvailable() and v14:BuffUp(v100.EarthShield)))) or ((1365 + 130) == (18561 - 13774))) then
			if (v25(v100.LightningShield) or ((301 + 9) > (4818 - (27 + 357)))) then
				return "lightning_shield main 2";
			end
		end
		v31 = v132();
		if (((2648 - (91 + 389)) <= (4657 - (90 + 207))) and v31) then
			return v31;
		end
		if (((39 + 955) == (1855 - (706 + 155))) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v14:CanAttack(v17)) then
			if (((3450 - (730 + 1065)) > (1964 - (1339 + 224))) and v25(v100.AncestralSpirit, nil, true)) then
				return "ancestral_spirit";
			end
		end
		if (((1558 + 1505) <= (3050 + 376)) and v100.AncestralSpirit:IsCastable() and v100.AncestralSpirit:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
			if (((2171 - 712) > (1607 - (268 + 575))) and v25(v102.AncestralSpiritMouseover)) then
				return "ancestral_spirit mouseover";
			end
		end
		v109, v110 = v30();
		if ((v100.ImprovedFlametongueWeapon:IsAvailable() and v100.FlametongueWeapon:IsCastable() and v51 and (not v109 or (v110 < (601294 - (919 + 375)))) and v100.FlametongueWeapon:IsAvailable()) or ((1762 - 1121) > (5305 - (180 + 791)))) then
			if (((5204 - (323 + 1482)) >= (4178 - (1177 + 741))) and v25(v100.FlametongueWeapon)) then
				return "flametongue_weapon enchant";
			end
		end
		if ((not v14:AffectingCombat() and v32 and v104.TargetIsValid()) or ((26 + 367) >= (15907 - 11665))) then
			local v216 = 0 + 0;
			while true do
				if (((2208 - 1219) < (407 + 4452)) and (v216 == (109 - (96 + 13)))) then
					v31 = v135();
					if (v31 or ((6716 - (962 + 959)) < (2370 - 1421))) then
						return v31;
					end
					break;
				end
			end
		end
	end
	local function v139()
		local v171 = 0 + 0;
		while true do
			if (((5193 - (461 + 890)) == (2819 + 1023)) and (v171 == (0 - 0))) then
				v31 = v133();
				if (((1990 - (19 + 224)) <= (3264 + 337)) and v31) then
					return v31;
				end
				v171 = 199 - (37 + 161);
			end
			if ((v171 == (1 + 0)) or ((312 + 492) > (4300 + 59))) then
				if (((4731 - (60 + 1)) >= (4546 - (826 + 97))) and v86) then
					local v263 = 0 + 0;
					while true do
						if (((7423 - 5358) < (5240 - 2696)) and ((685 - (375 + 310)) == v263)) then
							if (((3310 - (1864 + 135)) <= (8666 - 5307)) and v81) then
								local v278 = 0 + 0;
								while true do
									if (((909 + 1808) <= (7754 - 4598)) and (v278 == (1131 - (314 + 817)))) then
										v31 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 23 + 17);
										if (((1295 - (32 + 182)) < (3344 + 1180)) and v31) then
											return v31;
										end
										break;
									end
								end
							end
							if (((1537 - 1097) >= (136 - (39 + 26))) and v82) then
								local v279 = 144 - (54 + 90);
								while true do
									if (((5132 - (45 + 153)) > (1583 + 1024)) and (v279 == (552 - (457 + 95)))) then
										v31 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 30 + 0);
										if (v31 or ((2922 - 1522) > (7530 - 4414))) then
											return v31;
										end
										break;
									end
								end
							end
							v263 = 3 - 2;
						end
						if (((236 + 289) < (5731 - 4069)) and (v263 == (2 - 1))) then
							if (v83 or ((1624 - (485 + 263)) > (3257 - (575 + 132)))) then
								v31 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 891 - (750 + 111));
								if (((1229 - (445 + 565)) <= (1977 + 479)) and v31) then
									return v31;
								end
							end
							break;
						end
					end
				end
				if (v87 or ((606 + 3613) == (2031 - 881))) then
					v31 = v104.HandleIncorporeal(v100.Hex, v102.HexMouseOver, 11 + 19, true);
					if (v31 or ((3299 - (189 + 121)) <= (55 + 167))) then
						return v31;
					end
				end
				v171 = 1349 - (634 + 713);
			end
			if (((2796 - (493 + 45)) > (2209 - (493 + 475))) and (v171 == (1 + 1))) then
				if (((825 - (158 + 626)) < (2003 + 2256)) and v18) then
					if (v85 or ((3191 - 1261) < (13 + 43))) then
						local v267 = 0 + 0;
						while true do
							if (((4424 - (1035 + 56)) == (4292 - (114 + 845))) and (v267 == (0 + 0))) then
								v31 = v131();
								if (v31 or ((5695 - 3470) == (17 + 3))) then
									return v31;
								end
								break;
							end
						end
					end
				end
				if ((v100.GreaterPurge:IsAvailable() and v97 and v100.GreaterPurge:IsReady() and v36 and v84 and not v14:IsCasting() and not v14:IsChanneling() and v104.UnitHasMagicBuff(v17)) or ((1921 - (179 + 870)) >= (4336 - 1244))) then
					if (((5282 - (827 + 51)) >= (8599 - 5347)) and v25(v100.GreaterPurge, not v17:IsSpellInRange(v100.GreaterPurge))) then
						return "greater_purge damage";
					end
				end
				v171 = 2 + 1;
			end
			if (((1580 - (95 + 378)) > (58 + 738)) and (v171 == (4 - 1))) then
				if (((843 + 116) == (1970 - (334 + 677))) and v100.Purge:IsReady() and v97 and v36 and v84 and not v14:IsCasting() and not v14:IsChanneling() and v104.UnitHasMagicBuff(v17)) then
					if (v25(v100.Purge, not v17:IsSpellInRange(v100.Purge)) or ((917 - 672) >= (3260 - (1049 + 7)))) then
						return "purge damage";
					end
				end
				if (((13808 - 10646) >= (3891 - 1822)) and v104.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
					local v264 = 0 + 0;
					local v265;
					while true do
						if ((v264 == (7 - 4)) or ((612 - 306) > (1372 + 1709))) then
							if (true or ((4933 - (1004 + 416)) < (4663 - (1621 + 336)))) then
								local v280 = 1939 - (337 + 1602);
								while true do
									if (((4495 - (1014 + 503)) < (4654 - (446 + 569))) and (v280 == (1 + 0))) then
										if (((10802 - 7120) >= (971 + 1917)) and v25(v100.Pool)) then
											return "Pool for SingleTarget()";
										end
										break;
									end
									if (((308 - 159) < (10 + 469)) and (v280 == (505 - (223 + 282)))) then
										v31 = v137();
										if (((30 + 990) >= (902 - 335)) and v31) then
											return v31;
										end
										v280 = 1 - 0;
									end
								end
							end
							break;
						end
						if ((v264 == (670 - (623 + 47))) or ((778 - (32 + 13)) > (1385 + 1084))) then
							if (((2026 + 471) == (4298 - (1070 + 731))) and (v91 < v108) and v58 and ((v64 and v34) or not v64)) then
								local v281 = 0 + 0;
								while true do
									if (((5305 - (1257 + 147)) == (1547 + 2354)) and ((1 - 0) == v281)) then
										if (((334 - (98 + 35)) < (175 + 240)) and v100.Fireblood:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (177 - 127)))) then
											if (v25(v100.Fireblood) or ((447 - 314) == (1668 + 116))) then
												return "fireblood main 6";
											end
										end
										if ((v100.AncestralCall:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (44 + 6)))) or ((4 + 3) >= (867 - (395 + 162)))) then
											if (((4391 + 601) > (2227 - (816 + 1125))) and v25(v100.AncestralCall)) then
												return "ancestral_call main 8";
											end
										end
										v281 = 2 - 0;
									end
									if (((1148 - (701 + 447)) == v281) or ((3944 - 1383) == (6804 - 2911))) then
										if (((5703 - (391 + 950)) >= (3829 - 2408)) and v100.BloodFury:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (125 - 75)))) then
											if (((184 - 109) <= (2488 + 1058)) and v25(v100.BloodFury)) then
												return "blood_fury main 2";
											end
										end
										if (((1560 + 1120) <= (12497 - 9079)) and v100.Berserking:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff))) then
											if (v25(v100.Berserking) or ((5810 - (251 + 1271)) < (2561 + 315))) then
												return "berserking main 4";
											end
										end
										v281 = 2 - 1;
									end
									if (((6164 - 3702) >= (1898 - 751)) and (v281 == (1261 - (1147 + 112)))) then
										if ((v100.BagofTricks:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff))) or ((1228 + 3686) < (5036 - 2556))) then
											if (v25(v100.BagofTricks) or ((405 + 1154) == (1937 - (335 + 362)))) then
												return "bag_of_tricks main 10";
											end
										end
										break;
									end
								end
							end
							if (((531 + 35) == (851 - 285)) and (v91 < v108)) then
								if (((10701 - 6780) >= (11180 - 8171)) and v57 and ((v34 and v63) or not v63)) then
									local v288 = 0 - 0;
									while true do
										if (((5855 - 3792) >= (2214 - (237 + 329))) and (v288 == (0 - 0))) then
											v31 = v134();
											if (((703 + 363) >= (248 + 204)) and v31) then
												return v31;
											end
											break;
										end
									end
								end
							end
							v264 = 1125 - (408 + 716);
						end
						if (((18898 - 13924) >= (3476 - (344 + 477))) and ((1 + 1) == v264)) then
							if (v265 or ((4482 - (1188 + 573)) <= (2376 - 1469))) then
								return v265;
							end
							if (((4323 + 114) >= (9833 - 6802)) and v33 and (v113 > (2 - 0)) and (v114 > (4 - 2))) then
								local v282 = 1529 - (508 + 1021);
								while true do
									if ((v282 == (0 + 0)) or ((5636 - (228 + 938)) < (3634 - (332 + 353)))) then
										v31 = v136();
										if (v31 or ((1924 - 344) == (6351 - 3925))) then
											return v31;
										end
										v282 = 1 + 0;
									end
									if ((v282 == (1 + 0)) or ((14840 - 11129) == (926 - (18 + 405)))) then
										if (v25(v100.Pool) or ((193 + 227) == (2182 + 2136))) then
											return "Pool for Aoe()";
										end
										break;
									end
								end
							end
							v264 = 3 - 0;
						end
						if ((v264 == (979 - (194 + 784))) or ((5928 - (694 + 1076)) <= (1937 - (122 + 1782)))) then
							if ((v100.NaturesSwiftness:IsCastable() and v47) or ((94 + 5) > (4422 + 322))) then
								if (((3908 + 433) == (3115 + 1226)) and v25(v100.NaturesSwiftness)) then
									return "natures_swiftness main 12";
								end
							end
							v265 = v104.HandleDPSPotion(v14:BuffUp(v100.AscendanceBuff));
							v264 = 5 - 3;
						end
					end
				end
				break;
			end
		end
	end
	local function v140()
		v37 = EpicSettings.Settings['useChainlightning'];
		v38 = EpicSettings.Settings['useEarthquake'];
		v39 = EpicSettings.Settings['UseEarthShock'];
		v40 = EpicSettings.Settings['useElementalBlast'];
		v41 = EpicSettings.Settings['useFlameShock'];
		v42 = EpicSettings.Settings['useFrostShock'];
		v43 = EpicSettings.Settings['useIceFury'];
		v44 = EpicSettings.Settings['useLavaBeam'];
		v45 = EpicSettings.Settings['useLavaBurst'];
		v46 = EpicSettings.Settings['useLightningBolt'];
		v47 = EpicSettings.Settings['useNaturesSwiftness'];
		v48 = EpicSettings.Settings['usePrimordialWave'];
		v49 = EpicSettings.Settings['useStormkeeper'];
		v50 = EpicSettings.Settings['useTotemicRecall'];
		v51 = EpicSettings.Settings['useWeaponEnchant'];
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
	local function v141()
		local v197 = 0 + 0;
		while true do
			if (((2225 - (214 + 1756)) <= (7715 - 6119)) and (v197 == (0 + 0))) then
				v68 = EpicSettings.Settings['useWindShear'];
				v69 = EpicSettings.Settings['useCapacitorTotem'];
				v70 = EpicSettings.Settings['useThunderstorm'];
				v71 = EpicSettings.Settings['useAncestralGuidance'];
				v197 = 1 + 0;
			end
			if ((v197 == (589 - (217 + 368))) or ((13392 - 8959) < (1077 + 558))) then
				v99 = EpicSettings.Settings['healOOCHP'] or (0 + 0);
				v97 = EpicSettings.Settings['usePurgeTarget'];
				v81 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v82 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v197 = 1 + 4;
			end
			if ((v197 == (890 - (844 + 45))) or ((4584 - (242 + 42)) < (6493 - 3249))) then
				v72 = EpicSettings.Settings['useAstralShift'];
				v73 = EpicSettings.Settings['useHealingStreamTotem'];
				v76 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 - 0);
				v77 = EpicSettings.Settings['ancestralGuidanceGroup'] or (1200 - (132 + 1068));
				v197 = 2 - 0;
			end
			if ((v197 == (1625 - (214 + 1409))) or ((2734 + 800) > (6311 - (497 + 1137)))) then
				v78 = EpicSettings.Settings['astralShiftHP'] or (940 - (9 + 931));
				v79 = EpicSettings.Settings['healingStreamTotemHP'] or (289 - (181 + 108));
				v80 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
				v52 = EpicSettings.Settings['earthquakeSetting'] or "";
				v197 = 7 - 4;
			end
			if (((14 - 9) == v197) or ((1147 + 3712) < (1870 + 1129))) then
				v83 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if (((5202 - (296 + 180)) > (3810 - (1183 + 220))) and (v197 == (1268 - (1037 + 228)))) then
				v67 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
				v74 = EpicSettings.Settings['autoShield'];
				v75 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v98 = EpicSettings.Settings['healOOC'];
				v197 = 5 - 1;
			end
		end
	end
	local function v142()
		local v198 = 0 - 0;
		while true do
			if ((v198 == (13 - 9)) or ((2018 - (527 + 207)) > (4196 - (187 + 340)))) then
				v87 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((2987 - (1298 + 572)) < (6338 - 3789)) and ((170 - (144 + 26)) == v198)) then
				v91 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v88 = EpicSettings.Settings['InterruptWithStun'];
				v89 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v90 = EpicSettings.Settings['InterruptThreshold'];
				v198 = 2 - 1;
			end
			if ((v198 == (1 + 0)) or ((7770 - 4919) > (11082 - 6308))) then
				v85 = EpicSettings.Settings['DispelDebuffs'];
				v84 = EpicSettings.Settings['DispelBuffs'];
				v57 = EpicSettings.Settings['useTrinkets'];
				v58 = EpicSettings.Settings['useRacials'];
				v198 = 9 - 7;
			end
			if (((524 + 507) < (5222 - 1374)) and ((2 + 0) == v198)) then
				v63 = EpicSettings.Settings['trinketsWithCD'];
				v64 = EpicSettings.Settings['racialsWithCD'];
				v93 = EpicSettings.Settings['useHealthstone'];
				v92 = EpicSettings.Settings['useHealingPotion'];
				v198 = 2 + 1;
			end
			if (((2056 - (5 + 197)) > (1589 - (339 + 347))) and (v198 == (6 - 3))) then
				v95 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v94 = EpicSettings.Settings['healingPotionHP'] or (376 - (365 + 11));
				v96 = EpicSettings.Settings['HealingPotionName'] or "";
				v86 = EpicSettings.Settings['handleAfflicted'];
				v198 = 4 + 0;
			end
		end
	end
	local function v143()
		v141();
		v140();
		v142();
		v32 = EpicSettings.Toggles['ooc'];
		v33 = EpicSettings.Toggles['aoe'];
		v34 = EpicSettings.Toggles['cds'];
		v36 = EpicSettings.Toggles['dispel'];
		v35 = EpicSettings.Toggles['minicds'];
		if (((17934 - 13271) > (4365 - 2505)) and v14:IsDeadOrGhost()) then
			return v31;
		end
		v111 = v14:GetEnemiesInRange(964 - (837 + 87));
		v112 = v17:GetEnemiesInSplashRange(8 - 3);
		if (v33 or ((4723 - (837 + 833)) <= (101 + 368))) then
			local v217 = 1387 - (356 + 1031);
			while true do
				if ((v217 == (0 + 0)) or ((2186 - (73 + 1573)) >= (3257 - (1307 + 81)))) then
					v113 = #v111;
					v114 = v28(v17:GetEnemiesInSplashRangeCount(239 - (7 + 227)), v113);
					break;
				end
			end
		else
			local v218 = 0 - 0;
			while true do
				if (((3458 - (90 + 76)) == (10328 - 7036)) and (v218 == (0 + 0))) then
					v113 = 1 + 0;
					v114 = 1 + 0;
					break;
				end
			end
		end
		if (((4065 - 3027) <= (2905 - (197 + 63))) and v36 and v85) then
			local v219 = 0 + 0;
			while true do
				if ((v219 == (0 + 0)) or ((1686 + 1544) < (415 + 2110))) then
					if ((v14:AffectingCombat() and v100.CleanseSpirit:IsAvailable()) or ((3012 - 612) > (5452 - (618 + 751)))) then
						local v268 = 0 + 0;
						local v269;
						while true do
							if ((v268 == (1910 - (206 + 1704))) or ((4624 - 1879) > (8701 - 4342))) then
								v269 = v85 and v100.CleanseSpirit:IsReady() and v36;
								v31 = v104.FocusUnit(v269, v102, 9 + 11, nil, 1300 - (155 + 1120));
								v268 = 1507 - (396 + 1110);
							end
							if (((388 - 216) <= (590 + 1220)) and (v268 == (1 + 0))) then
								if (v31 or ((422 + 70) >= (5935 - (230 + 746)))) then
									return v31;
								end
								break;
							end
						end
					end
					if (v100.CleanseSpirit:IsAvailable() or ((1357 - (473 + 128)) == (2120 - (39 + 9)))) then
						if (((1871 - (38 + 228)) <= (8471 - 3807)) and v15 and v15:Exists() and v15:IsAPlayer() and v104.UnitHasCurseDebuff(v15)) then
							if (((2289 - (106 + 367)) == (161 + 1655)) and v100.CleanseSpirit:IsReady()) then
								if (v25(v102.CleanseSpiritMouseover) or ((2483 - (354 + 1508)) > (9948 - 6848))) then
									return "cleanse_spirit mouseover";
								end
							end
						end
					end
					break;
				end
			end
		end
		if (v104.TargetIsValid() or v14:AffectingCombat() or ((846 + 311) >= (2477 + 1748))) then
			local v220 = 0 - 0;
			while true do
				if ((v220 == (1245 - (334 + 910))) or ((5881 - (92 + 803)) == (2280 + 1858))) then
					if ((v108 == (12292 - (1035 + 146))) or ((2649 - (230 + 386)) <= (131 + 93))) then
						v108 = v10.FightRemains(v111, false);
					end
					break;
				end
				if ((v220 == (1510 - (353 + 1157))) or ((2337 - (53 + 1061)) == (3646 - (1568 + 67)))) then
					v107 = v10.BossFightRemains();
					v108 = v107;
					v220 = 1 + 0;
				end
			end
		end
		if (((690 + 4137) > (11885 - 7190)) and not v14:IsChanneling() and not v14:IsCasting()) then
			local v221 = 0 - 0;
			while true do
				if (((9353 - 5643) > (2893 + 172)) and (v221 == (1212 - (615 + 597)))) then
					if (((1911 + 224) <= (4031 - 1335)) and v86) then
						local v270 = 0 + 0;
						while true do
							if ((v270 == (1 + 0)) or ((959 + 783) > (6296 - (1056 + 843)))) then
								if (((8504 - 4604) >= (3167 - 1263)) and v83) then
									local v289 = 0 - 0;
									while true do
										if ((v289 == (0 + 0)) or ((3700 - (286 + 1690)) == (1820 - (98 + 813)))) then
											v31 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 8 + 22);
											if (((3109 - 1827) < (806 + 615)) and v31) then
												return v31;
											end
											break;
										end
									end
								end
								break;
							end
							if (((5383 - (263 + 244)) >= (3433 + 904)) and (v270 == (1687 - (1502 + 185)))) then
								if (((764 + 3241) >= (14689 - 11684)) and v81) then
									v31 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 106 - 66);
									if (v31 or ((6308 - (629 + 898)) <= (12113 - 7665))) then
										return v31;
									end
								end
								if (((3385 - 2068) > (537 - (12 + 353))) and v82) then
									local v290 = 1911 - (1680 + 231);
									while true do
										if (((306 + 4485) == (2934 + 1857)) and (v290 == (1149 - (212 + 937)))) then
											v31 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 20 + 10);
											if (((5050 - (111 + 951)) > (257 + 1004)) and v31) then
												return v31;
											end
											break;
										end
									end
								end
								v270 = 28 - (18 + 9);
							end
						end
					end
					if (((449 + 1791) <= (4150 - (31 + 503))) and v14:AffectingCombat()) then
						local v271 = 1632 - (595 + 1037);
						while true do
							if ((v271 == (1444 - (189 + 1255))) or ((1474 + 2514) < (6108 - 2161))) then
								v31 = v139();
								if (((5923 - (1170 + 109)) == (6461 - (348 + 1469))) and v31) then
									return v31;
								end
								break;
							end
						end
					else
						local v272 = 1289 - (1115 + 174);
						while true do
							if (((3226 - 1903) > (2285 - (85 + 929))) and ((0 + 0) == v272)) then
								v31 = v138();
								if (((3486 - (1151 + 716)) > (500 + 957)) and v31) then
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
	local function v144()
		local v204 = 0 + 0;
		while true do
			if ((v204 == (1704 - (95 + 1609))) or ((10323 - 7463) < (2566 - (364 + 394)))) then
				v100.FlameShockDebuff:RegisterAuraTracking();
				v106();
				v204 = 1 + 0;
			end
			if ((v204 == (1 + 0)) or ((153 + 586) >= (1472 + 337))) then
				v22.Print("Elemental Shaman by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(132 + 130, v143, v144);
end;
return v0["Epix_Shaman_Elemental.lua"]();

