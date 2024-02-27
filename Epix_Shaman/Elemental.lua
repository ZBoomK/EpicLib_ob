local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1223 - (109 + 1114);
	local v6;
	while true do
		if ((v5 == (1 - 0)) or ((1795 + 2814) <= (2737 - (6 + 236)))) then
			return v6(...);
		end
		if (((726 + 426) == (928 + 224)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((3311 - 1415) <= (4555 - (1076 + 57))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
		if (v101.CleanseSpirit:IsAvailable() or ((1679 - (579 + 110)) > (128 + 1492))) then
			v105.DispellableDebuffs = v105.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v107();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v10:RegisterForEvent(function()
		v101.PrimordialWave:RegisterInFlightEffect(289256 + 37906);
		v101.PrimordialWave:RegisterInFlight();
		v101.LavaBurst:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v101.PrimordialWave:RegisterInFlightEffect(173634 + 153528);
	v101.PrimordialWave:RegisterInFlight();
	v101.LavaBurst:RegisterInFlight();
	local v108 = 11518 - (174 + 233);
	local v109 = 31036 - 19925;
	local v110, v111;
	local v112, v113;
	local v114 = 0 - 0;
	local v115 = 0 + 0;
	local v116 = 1174 - (663 + 511);
	local v117 = 0 + 0;
	local v118 = 0 + 0;
	local function v119()
		return (123 - 83) - (v29() - v116);
	end
	v10:RegisterForSelfCombatEvent(function(...)
		local v147 = 0 + 0;
		local v148;
		local v149;
		local v150;
		while true do
			if ((v147 == (0 - 0)) or ((2122 - 1245) > (2241 + 2454))) then
				v148, v149, v149, v149, v150 = select(15 - 7, ...);
				if (((1918 + 773) >= (170 + 1681)) and (v148 == v14:GUID()) and (v150 == (192356 - (478 + 244)))) then
					v117 = v29();
					C_Timer.After(517.1 - (440 + 77), function()
						if ((v117 ~= v118) or ((1358 + 1627) >= (17773 - 12917))) then
							v116 = v117;
						end
					end);
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED");
	local function v120(v151)
		return (v151:DebuffRefreshable(v101.FlameShockDebuff));
	end
	local function v121(v152)
		return v152:DebuffRefreshable(v101.FlameShockDebuff) and (v152:DebuffRemains(v101.FlameShockDebuff) < (v152:TimeToDie() - (1561 - (655 + 901))));
	end
	local function v122(v153)
		return v153:DebuffRefreshable(v101.FlameShockDebuff) and (v153:DebuffRemains(v101.FlameShockDebuff) < (v153:TimeToDie() - (1 + 4))) and (v153:DebuffRemains(v101.FlameShockDebuff) > (0 + 0));
	end
	local function v123(v154)
		return (v154:DebuffRemains(v101.FlameShockDebuff));
	end
	local function v124(v155)
		return v155:DebuffRemains(v101.FlameShockDebuff) > (2 + 0);
	end
	local function v125(v156)
		return (v156:DebuffRemains(v101.LightningRodDebuff));
	end
	local function v126()
		local v157 = 0 - 0;
		local v158;
		while true do
			if (((5721 - (695 + 750)) >= (4080 - 2885)) and (v157 == (0 - 0))) then
				v158 = v14:Maelstrom();
				if (((12998 - 9766) <= (5041 - (285 + 66))) and not v14:IsCasting()) then
					return v158;
				elseif (v14:IsCasting(v101.ElementalBlast) or ((2088 - 1192) >= (4456 - (682 + 628)))) then
					return v158 - (13 + 62);
				elseif (((3360 - (176 + 123)) >= (1238 + 1720)) and v14:IsCasting(v101.Icefury)) then
					return v158 + 19 + 6;
				elseif (((3456 - (239 + 30)) >= (176 + 468)) and v14:IsCasting(v101.LightningBolt)) then
					return v158 + 10 + 0;
				elseif (((1139 - 495) <= (2196 - 1492)) and v14:IsCasting(v101.LavaBurst)) then
					return v158 + (327 - (306 + 9));
				elseif (((3342 - 2384) > (165 + 782)) and v14:IsCasting(v101.ChainLightning)) then
					return v158 + ((3 + 1) * v115);
				else
					return v158;
				end
				break;
			end
		end
	end
	local function v127(v159)
		local v160 = 0 + 0;
		local v161;
		while true do
			if (((12845 - 8353) >= (4029 - (1140 + 235))) and (v160 == (0 + 0))) then
				v161 = v159:IsReady();
				if (((3157 + 285) >= (386 + 1117)) and ((v159 == v101.Stormkeeper) or (v159 == v101.ElementalBlast) or (v159 == v101.Icefury))) then
					local v254 = 52 - (33 + 19);
					local v255;
					while true do
						if (((0 + 0) == v254) or ((9501 - 6331) <= (645 + 819))) then
							v255 = v14:BuffUp(v101.SpiritwalkersGraceBuff) or not v14:IsMoving();
							return v161 and v255 and not v14:IsCasting(v159);
						end
					end
				elseif ((v159 == v101.LavaBeam) or ((9407 - 4610) == (4115 + 273))) then
					local v270 = 689 - (586 + 103);
					local v271;
					while true do
						if (((51 + 500) <= (2096 - 1415)) and (v270 == (1488 - (1309 + 179)))) then
							v271 = v14:BuffUp(v101.SpiritwalkersGraceBuff) or not v14:IsMoving();
							return v161 and v271;
						end
					end
				elseif (((5915 - 2638) > (178 + 229)) and ((v159 == v101.LightningBolt) or (v159 == v101.ChainLightning))) then
					local v279 = 0 - 0;
					local v280;
					while true do
						if (((3547 + 1148) >= (3006 - 1591)) and (v279 == (0 - 0))) then
							v280 = v14:BuffUp(v101.SpiritwalkersGraceBuff) or v14:BuffUp(v101.StormkeeperBuff) or not v14:IsMoving();
							return v161 and v280;
						end
					end
				elseif ((v159 == v101.LavaBurst) or ((3821 - (295 + 314)) <= (2318 - 1374))) then
					local v288 = 1962 - (1300 + 662);
					local v289;
					local v290;
					local v291;
					local v292;
					while true do
						if (((3 - 2) == v288) or ((4851 - (1178 + 577)) <= (934 + 864))) then
							v291 = (v101.LavaBurst:Charges() >= (2 - 1)) and not v14:IsCasting(v101.LavaBurst);
							v292 = (v101.LavaBurst:Charges() == (1407 - (851 + 554))) and v14:IsCasting(v101.LavaBurst);
							v288 = 2 + 0;
						end
						if (((9809 - 6272) == (7681 - 4144)) and (v288 == (304 - (115 + 187)))) then
							return v161 and v289 and (v290 or v291 or v292);
						end
						if (((2939 + 898) >= (1487 + 83)) and (v288 == (0 - 0))) then
							v289 = v14:BuffUp(v101.SpiritwalkersGraceBuff) or v14:BuffUp(v101.LavaSurgeBuff) or not v14:IsMoving();
							v290 = v14:BuffUp(v101.LavaSurgeBuff);
							v288 = 1162 - (160 + 1001);
						end
					end
				elseif ((v159 == v101.PrimordialWave) or ((2581 + 369) == (2631 + 1181))) then
					return v161 and v34 and v14:BuffDown(v101.PrimordialWaveBuff) and v14:BuffDown(v101.LavaSurgeBuff);
				else
					return v161;
				end
				break;
			end
		end
	end
	local function v128()
		local v162 = 0 - 0;
		local v163;
		while true do
			if (((5081 - (237 + 121)) >= (3215 - (525 + 372))) and (v162 == (0 - 0))) then
				if (not v101.MasteroftheElements:IsAvailable() or ((6659 - 4632) > (2994 - (96 + 46)))) then
					return false;
				end
				v163 = v14:BuffUp(v101.MasteroftheElementsBuff);
				v162 = 778 - (643 + 134);
			end
			if ((v162 == (1 + 0)) or ((2723 - 1587) > (16027 - 11710))) then
				if (((4554 + 194) == (9317 - 4569)) and not v14:IsCasting()) then
					return v163;
				elseif (((7636 - 3900) <= (5459 - (316 + 403))) and v14:IsCasting(v106.LavaBurst)) then
					return true;
				elseif (v14:IsCasting(v106.ElementalBlast) or v14:IsCasting(v101.Icefury) or v14:IsCasting(v101.LightningBolt) or v14:IsCasting(v101.ChainLightning) or ((2254 + 1136) <= (8413 - 5353))) then
					return false;
				else
					return v163;
				end
				break;
			end
		end
	end
	local function v129()
		if (not v101.PoweroftheMaelstrom:IsAvailable() or ((362 + 637) > (6781 - 4088))) then
			return false;
		end
		local v164 = v14:BuffStack(v101.PoweroftheMaelstromBuff);
		if (((329 + 134) < (194 + 407)) and not v14:IsCasting()) then
			return v164 > (0 - 0);
		elseif (((v164 == (4 - 3)) and (v14:IsCasting(v101.LightningBolt) or v14:IsCasting(v101.ChainLightning))) or ((4534 - 2351) < (40 + 647))) then
			return false;
		else
			return v164 > (0 - 0);
		end
	end
	local function v130()
		local v165 = 0 + 0;
		local v166;
		while true do
			if (((13383 - 8834) == (4566 - (12 + 5))) and (v165 == (0 - 0))) then
				if (((9967 - 5295) == (9930 - 5258)) and not v101.Stormkeeper:IsAvailable()) then
					return false;
				end
				v166 = v14:BuffUp(v101.StormkeeperBuff);
				v165 = 2 - 1;
			end
			if ((v165 == (1 + 0)) or ((5641 - (1656 + 317)) < (352 + 43))) then
				if (not v14:IsCasting() or ((3339 + 827) == (1209 - 754))) then
					return v166;
				elseif (v14:IsCasting(v101.Stormkeeper) or ((21895 - 17446) == (3017 - (5 + 349)))) then
					return true;
				else
					return v166;
				end
				break;
			end
		end
	end
	local function v131()
		local v167 = 0 - 0;
		local v168;
		while true do
			if ((v167 == (1272 - (266 + 1005))) or ((2819 + 1458) < (10198 - 7209))) then
				if (not v14:IsCasting() or ((1145 - 275) >= (5845 - (561 + 1135)))) then
					return v168;
				elseif (((2882 - 670) < (10462 - 7279)) and v14:IsCasting(v101.Icefury)) then
					return true;
				else
					return v168;
				end
				break;
			end
			if (((5712 - (507 + 559)) > (7507 - 4515)) and ((0 - 0) == v167)) then
				if (((1822 - (212 + 176)) < (4011 - (250 + 655))) and not v101.Icefury:IsAvailable()) then
					return false;
				end
				v168 = v14:BuffUp(v101.IcefuryBuff);
				v167 = 2 - 1;
			end
		end
	end
	local v132 = 0 - 0;
	local function v133()
		if (((1229 - 443) < (4979 - (1869 + 87))) and v101.CleanseSpirit:IsReady() and v36 and v105.DispellableFriendlyUnit(86 - 61)) then
			local v196 = 1901 - (484 + 1417);
			while true do
				if ((v196 == (0 - 0)) or ((4092 - 1650) < (847 - (48 + 725)))) then
					if (((7408 - 2873) == (12166 - 7631)) and (v132 == (0 + 0))) then
						v132 = v29();
					end
					if (v105.Wait(1336 - 836, v132) or ((843 + 2166) <= (614 + 1491))) then
						if (((2683 - (152 + 701)) < (4980 - (430 + 881))) and v25(v103.CleanseSpiritFocus)) then
							return "cleanse_spirit dispel";
						end
						v132 = 0 + 0;
					end
					break;
				end
			end
		end
	end
	local function v134()
		if ((v99 and (v14:HealthPercentage() <= v100)) or ((2325 - (557 + 338)) >= (1068 + 2544))) then
			if (((7560 - 4877) >= (8614 - 6154)) and v101.HealingSurge:IsReady()) then
				if (v25(v101.HealingSurge) or ((4792 - 2988) >= (7057 - 3782))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v135()
		local v169 = 801 - (499 + 302);
		while true do
			if ((v169 == (866 - (39 + 827))) or ((3911 - 2494) > (8104 - 4475))) then
				if (((19045 - 14250) > (616 - 214)) and v101.AstralShift:IsReady() and v72 and (v14:HealthPercentage() <= v78)) then
					if (((413 + 4400) > (10434 - 6869)) and v25(v101.AstralShift)) then
						return "astral_shift defensive 1";
					end
				end
				if (((626 + 3286) == (6189 - 2277)) and v101.AncestralGuidance:IsReady() and v71 and v105.AreUnitsBelowHealthPercentage(v76, v77)) then
					if (((2925 - (103 + 1)) <= (5378 - (475 + 79))) and v25(v101.AncestralGuidance)) then
						return "ancestral_guidance defensive 2";
					end
				end
				v169 = 2 - 1;
			end
			if (((5561 - 3823) <= (284 + 1911)) and (v169 == (2 + 0))) then
				if (((1544 - (1395 + 108)) <= (8782 - 5764)) and v93 and (v14:HealthPercentage() <= v95)) then
					if (((3349 - (7 + 1197)) <= (1790 + 2314)) and (v97 == "Refreshing Healing Potion")) then
						if (((939 + 1750) < (5164 - (27 + 292))) and v102.RefreshingHealingPotion:IsReady()) then
							if (v25(v103.RefreshingHealingPotion) or ((6803 - 4481) > (3343 - 721))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v97 == "Dreamwalker's Healing Potion") or ((19014 - 14480) == (4105 - 2023))) then
						if (v102.DreamwalkersHealingPotion:IsReady() or ((2991 - 1420) > (2006 - (43 + 96)))) then
							if (v25(v103.RefreshingHealingPotion) or ((10825 - 8171) >= (6773 - 3777))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((3301 + 677) > (595 + 1509)) and (v169 == (1 - 0))) then
				if (((1148 + 1847) > (2887 - 1346)) and v101.HealingStreamTotem:IsReady() and v73 and v105.AreUnitsBelowHealthPercentage(v79, v80)) then
					if (((1023 + 2226) > (70 + 883)) and v25(v101.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v102.Healthstone:IsReady() and v94 and (v14:HealthPercentage() <= v96)) or ((5024 - (1414 + 337)) > (6513 - (1642 + 298)))) then
					if (v25(v103.Healthstone) or ((8214 - 5063) < (3693 - 2409))) then
						return "healthstone defensive 3";
					end
				end
				v169 = 5 - 3;
			end
		end
	end
	local function v136()
		v31 = v105.HandleTopTrinket(v104, v34, 14 + 26, nil);
		if (v31 or ((1440 + 410) == (2501 - (357 + 615)))) then
			return v31;
		end
		v31 = v105.HandleBottomTrinket(v104, v34, 29 + 11, nil);
		if (((2014 - 1193) < (1820 + 303)) and v31) then
			return v31;
		end
	end
	local function v137()
		if (((1932 - 1030) < (1860 + 465)) and v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (0 + 0)) and not v14:BuffUp(v101.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v109)) then
			if (((540 + 318) <= (4263 - (384 + 917))) and v25(v101.Stormkeeper)) then
				return "stormkeeper precombat 2";
			end
		end
		if ((v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (697 - (128 + 569))) and v43) or ((5489 - (1407 + 136)) < (3175 - (687 + 1200)))) then
			if (v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury)) or ((4952 - (556 + 1154)) == (1994 - 1427))) then
				return "icefury precombat 4";
			end
		end
		if ((v127(v101.ElementalBlast) and v40) or ((942 - (9 + 86)) >= (1684 - (275 + 146)))) then
			if (v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast)) or ((367 + 1886) == (1915 - (29 + 35)))) then
				return "elemental_blast precombat 6";
			end
		end
		if ((v14:IsCasting(v101.ElementalBlast) and v48 and ((v65 and v35) or not v65) and v127(v101.PrimordialWave)) or ((9249 - 7162) > (7084 - 4712))) then
			if (v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave)) or ((19622 - 15177) < (2703 + 1446))) then
				return "primordial_wave precombat 8";
			end
		end
		if ((v14:IsCasting(v101.ElementalBlast) and v41 and not v101.PrimordialWave:IsAvailable() and v101.FlameShock:IsViable()) or ((2830 - (53 + 959)) == (493 - (312 + 96)))) then
			if (((1093 - 463) < (2412 - (147 + 138))) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
				return "flameshock precombat 10";
			end
		end
		if ((v127(v101.LavaBurst) and v45 and not v14:IsCasting(v101.LavaBurst) and (not v101.ElementalBlast:IsAvailable() or (v101.ElementalBlast:IsAvailable() and not v101.ElementalBlast:IsAvailable()))) or ((2837 - (813 + 86)) == (2272 + 242))) then
			if (((7883 - 3628) >= (547 - (18 + 474))) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
				return "lavaburst precombat 12";
			end
		end
		if (((1012 + 1987) > (3772 - 2616)) and v14:IsCasting(v101.LavaBurst) and v41 and v101.FlameShock:IsReady()) then
			if (((3436 - (860 + 226)) > (1458 - (121 + 182))) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
				return "flameshock precombat 14";
			end
		end
		if (((496 + 3533) <= (6093 - (988 + 252))) and v14:IsCasting(v101.LavaBurst) and v48 and ((v65 and v35) or not v65) and v127(v101.PrimordialWave)) then
			if (v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave)) or ((59 + 457) > (1076 + 2358))) then
				return "primordial_wave precombat 16";
			end
		end
	end
	local function v138()
		local v170 = 1970 - (49 + 1921);
		while true do
			if (((4936 - (223 + 667)) >= (3085 - (51 + 1))) and (v170 == (11 - 4))) then
				if ((v101.FlameShock:IsCastable() and v41 and v14:IsMoving() and v17:DebuffRefreshable(v101.FlameShockDebuff)) or ((5822 - 3103) <= (2572 - (146 + 979)))) then
					if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((1167 + 2967) < (4531 - (311 + 294)))) then
						return "flame_shock aoe 96";
					end
				end
				if ((v101.FrostShock:IsCastable() and v42 and v14:IsMoving()) or ((457 - 293) >= (1180 + 1605))) then
					if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((1968 - (496 + 947)) == (3467 - (1233 + 125)))) then
						return "frost_shock aoe 98";
					end
				end
				break;
			end
			if (((14 + 19) == (30 + 3)) and (v170 == (0 + 0))) then
				if (((4699 - (963 + 682)) <= (3351 + 664)) and v101.FireElemental:IsReady() and v54 and ((v60 and v34) or not v60) and (v91 < v109)) then
					if (((3375 - (504 + 1000)) < (2278 + 1104)) and v25(v101.FireElemental)) then
						return "fire_elemental aoe 2";
					end
				end
				if (((1178 + 115) <= (205 + 1961)) and v101.StormElemental:IsReady() and v56 and ((v61 and v34) or not v61) and (v91 < v109)) then
					if (v25(v101.StormElemental) or ((3802 - 1223) < (106 + 17))) then
						return "storm_elemental aoe 4";
					end
				end
				if ((v127(v101.Stormkeeper) and not v130() and v49 and ((v66 and v35) or not v66) and (v91 < v109)) or ((492 + 354) >= (2550 - (156 + 26)))) then
					if (v25(v101.Stormkeeper) or ((2312 + 1700) <= (5253 - 1895))) then
						return "stormkeeper aoe 7";
					end
				end
				if (((1658 - (149 + 15)) <= (3965 - (890 + 70))) and v101.TotemicRecall:IsCastable() and (v101.LiquidMagmaTotem:CooldownRemains() > (162 - (39 + 78))) and v50) then
					if (v25(v101.TotemicRecall) or ((3593 - (14 + 468)) == (4692 - 2558))) then
						return "totemic_recall aoe 8";
					end
				end
				if (((6582 - 4227) == (1216 + 1139)) and v101.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v34) or not v62) and (v91 < v109) and (v67 == "cursor")) then
					if (v25(v103.LiquidMagmaTotemCursor, not v17:IsInRange(25 + 15)) or ((125 + 463) <= (196 + 236))) then
						return "liquid_magma_totem aoe cursor 10";
					end
				end
				if (((1257 + 3540) >= (7455 - 3560)) and v101.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v34) or not v62) and (v91 < v109) and (v67 == "player")) then
					if (((3536 + 41) == (12569 - 8992)) and v25(v103.LiquidMagmaTotemPlayer, not v17:IsInRange(2 + 38))) then
						return "liquid_magma_totem aoe player 11";
					end
				end
				v170 = 52 - (12 + 39);
			end
			if (((3530 + 264) > (11431 - 7738)) and (v170 == (14 - 10))) then
				if ((v127(v101.EarthShock) and v39 and v101.EchoesofGreatSundering:IsAvailable()) or ((378 + 897) == (2159 + 1941))) then
					if (v25(v101.EarthShock, not v17:IsSpellInRange(v101.EarthShock)) or ((4034 - 2443) >= (2385 + 1195))) then
						return "earth_shock aoe 60";
					end
				end
				if (((4750 - 3767) <= (3518 - (1596 + 114))) and v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (0 - 0)) and v43 and not v14:BuffUp(v101.AscendanceBuff) and v101.ElectrifiedShocks:IsAvailable() and ((v101.LightningRod:IsAvailable() and (v115 < (718 - (164 + 549))) and not v128()) or (v101.DeeplyRootedElements:IsAvailable() and (v115 == (1441 - (1059 + 379)))))) then
					if (v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury)) or ((2669 - 519) <= (621 + 576))) then
						return "icefury aoe 62";
					end
				end
				if (((636 + 3133) >= (1565 - (145 + 247))) and v127(v101.FrostShock) and v42 and not v14:BuffUp(v101.AscendanceBuff) and v14:BuffUp(v101.IcefuryBuff) and v101.ElectrifiedShocks:IsAvailable() and (not v17:DebuffUp(v101.ElectrifiedShocksDebuff) or (v14:BuffRemains(v101.IcefuryBuff) < v14:GCD())) and ((v101.LightningRod:IsAvailable() and (v115 < (5 + 0)) and not v128()) or (v101.DeeplyRootedElements:IsAvailable() and (v115 == (2 + 1))))) then
					if (((4402 - 2917) == (285 + 1200)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock aoe 64";
					end
				end
				if ((v127(v101.LavaBurst) and v101.MasteroftheElements:IsAvailable() and not v128() and (v130() or ((v119() < (3 + 0)) and v14:HasTier(48 - 18, 722 - (254 + 466)))) and (v126() < ((((620 - (544 + 16)) - ((15 - 10) * v101.EyeoftheStorm:TalentRank())) - ((630 - (294 + 334)) * v26(v101.FlowofPower:IsAvailable()))) - (263 - (236 + 17)))) and (v115 < (3 + 2))) or ((2581 + 734) <= (10477 - 7695))) then
					if (v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst)) or ((4147 - 3271) >= (1527 + 1437))) then
						return "lava_burst aoe 66";
					end
					if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((1839 + 393) > (3291 - (413 + 381)))) then
						return "lava_burst aoe 66";
					end
				end
				if ((v127(v101.LavaBeam) and v44 and (v130())) or ((89 + 2021) <= (705 - 373))) then
					if (((9574 - 5888) > (5142 - (582 + 1388))) and v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam))) then
						return "lava_beam aoe 68";
					end
				end
				if ((v127(v101.ChainLightning) and v37 and (v130())) or ((7622 - 3148) < (587 + 233))) then
					if (((4643 - (326 + 38)) >= (8525 - 5643)) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning aoe 70";
					end
				end
				v170 = 7 - 2;
			end
			if ((v170 == (621 - (47 + 573))) or ((716 + 1313) >= (14953 - 11432))) then
				if ((v127(v101.PrimordialWave) and v14:BuffDown(v101.PrimordialWaveBuff) and v14:BuffUp(v101.SurgeofPowerBuff) and v14:BuffDown(v101.SplinteredElementsBuff)) or ((3305 - 1268) >= (6306 - (1269 + 395)))) then
					local v256 = 492 - (76 + 416);
					while true do
						if (((2163 - (319 + 124)) < (10190 - 5732)) and (v256 == (1007 - (564 + 443)))) then
							if (v105.CastTargetIf(v101.PrimordialWave, v113, "min", v123, nil, not v17:IsSpellInRange(v101.PrimordialWave), nil, nil) or ((1206 - 770) > (3479 - (337 + 121)))) then
								return "primordial_wave aoe 12";
							end
							if (((2088 - 1375) <= (2821 - 1974)) and v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave))) then
								return "primordial_wave aoe 12";
							end
							break;
						end
					end
				end
				if (((4065 - (1261 + 650)) <= (1706 + 2325)) and v127(v101.PrimordialWave) and v14:BuffDown(v101.PrimordialWaveBuff) and v101.DeeplyRootedElements:IsAvailable() and not v101.SurgeofPower:IsAvailable() and v14:BuffDown(v101.SplinteredElementsBuff)) then
					local v257 = 0 - 0;
					while true do
						if (((6432 - (772 + 1045)) == (651 + 3964)) and (v257 == (144 - (102 + 42)))) then
							if (v105.CastTargetIf(v101.PrimordialWave, v113, "min", v123, nil, not v17:IsSpellInRange(v101.PrimordialWave), nil, nil) or ((5634 - (1524 + 320)) == (1770 - (1049 + 221)))) then
								return "primordial_wave aoe 14";
							end
							if (((245 - (18 + 138)) < (540 - 319)) and v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave))) then
								return "primordial_wave aoe 14";
							end
							break;
						end
					end
				end
				if (((3156 - (67 + 1035)) >= (1769 - (136 + 212))) and v127(v101.PrimordialWave) and v14:BuffDown(v101.PrimordialWaveBuff) and v101.MasteroftheElements:IsAvailable() and not v101.LightningRod:IsAvailable()) then
					local v258 = 0 - 0;
					while true do
						if (((555 + 137) < (2820 + 238)) and (v258 == (1604 - (240 + 1364)))) then
							if (v105.CastTargetIf(v101.PrimordialWave, v113, "min", v123, nil, not v17:IsSpellInRange(v101.PrimordialWave), nil, nil) or ((4336 - (1050 + 32)) == (5909 - 4254))) then
								return "primordial_wave aoe 16";
							end
							if (v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave)) or ((767 + 529) == (5965 - (331 + 724)))) then
								return "primordial_wave aoe 16";
							end
							break;
						end
					end
				end
				if (((272 + 3096) == (4012 - (269 + 375))) and v101.FlameShock:IsCastable()) then
					local v259 = 725 - (267 + 458);
					while true do
						if (((822 + 1821) < (7336 - 3521)) and (v259 == (820 - (667 + 151)))) then
							if (((3410 - (1410 + 87)) > (2390 - (1504 + 393))) and v14:BuffUp(v101.SurgeofPowerBuff) and v41 and (not v101.LightningRod:IsAvailable() or v101.SkybreakersFieryDemise:IsAvailable())) then
								local v282 = 0 - 0;
								while true do
									if (((12336 - 7581) > (4224 - (461 + 335))) and ((0 + 0) == v282)) then
										if (((3142 - (1730 + 31)) <= (4036 - (728 + 939))) and v105.CastCycle(v101.FlameShock, v113, v122, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 26";
										end
										if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((17152 - 12309) == (8283 - 4199))) then
											return "flame_shock aoe 26";
										end
										break;
									end
								end
							end
							if (((10697 - 6028) > (1431 - (138 + 930))) and v101.MasteroftheElements:IsAvailable() and v41 and not v101.LightningRod:IsAvailable() and not v101.SurgeofPower:IsAvailable()) then
								local v283 = 0 + 0;
								while true do
									if (((0 + 0) == v283) or ((1609 + 268) >= (12813 - 9675))) then
										if (((6508 - (459 + 1307)) >= (5496 - (474 + 1396))) and v105.CastCycle(v101.FlameShock, v113, v122, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 28";
										end
										if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((7927 - 3387) == (859 + 57))) then
											return "flame_shock aoe 28";
										end
										break;
									end
								end
							end
							v259 = 1 + 2;
						end
						if ((v259 == (0 - 0)) or ((147 + 1009) > (14504 - 10159))) then
							if (((9755 - 7518) < (4840 - (562 + 29))) and v14:BuffUp(v101.SurgeofPowerBuff) and v41 and v101.LightningRod:IsAvailable() and v101.WindspeakersLavaResurgence:IsAvailable() and (v17:DebuffRemains(v101.FlameShockDebuff) < (v17:TimeToDie() - (14 + 2))) and (v112 < (1424 - (374 + 1045)))) then
								local v284 = 0 + 0;
								while true do
									if ((v284 == (0 - 0)) or ((3321 - (448 + 190)) < (8 + 15))) then
										if (((315 + 382) <= (539 + 287)) and v105.CastCycle(v101.FlameShock, v113, v121, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 18";
										end
										if (((4248 - 3143) <= (3653 - 2477)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 18";
										end
										break;
									end
								end
							end
							if (((4873 - (1307 + 187)) <= (15116 - 11304)) and v14:BuffUp(v101.SurgeofPowerBuff) and v41 and (not v101.LightningRod:IsAvailable() or v101.SkybreakersFieryDemise:IsAvailable()) and (v101.FlameShockDebuff:AuraActiveCount() < (13 - 7))) then
								local v285 = 0 - 0;
								while true do
									if ((v285 == (683 - (232 + 451))) or ((753 + 35) >= (1428 + 188))) then
										if (((2418 - (510 + 54)) <= (6807 - 3428)) and v105.CastCycle(v101.FlameShock, v113, v121, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 20";
										end
										if (((4585 - (13 + 23)) == (8866 - 4317)) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 20";
										end
										break;
									end
								end
							end
							v259 = 1 - 0;
						end
						if ((v259 == (4 - 1)) or ((4110 - (830 + 258)) >= (10667 - 7643))) then
							if (((3016 + 1804) > (1871 + 327)) and v101.DeeplyRootedElements:IsAvailable() and v41 and not v101.SurgeofPower:IsAvailable()) then
								local v286 = 1441 - (860 + 581);
								while true do
									if ((v286 == (0 - 0)) or ((843 + 218) >= (5132 - (237 + 4)))) then
										if (((3205 - 1841) <= (11316 - 6843)) and v105.CastCycle(v101.FlameShock, v113, v122, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 30";
										end
										if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((6816 - 3221) <= (3 + 0))) then
											return "flame_shock aoe 30";
										end
										break;
									end
								end
							end
							break;
						end
						if ((v259 == (1 + 0)) or ((17638 - 12966) == (1653 + 2199))) then
							if (((849 + 710) == (2985 - (85 + 1341))) and v101.MasteroftheElements:IsAvailable() and v41 and not v101.LightningRod:IsAvailable() and (v101.FlameShockDebuff:AuraActiveCount() < (10 - 4))) then
								if (v105.CastCycle(v101.FlameShock, v113, v121, not v17:IsSpellInRange(v101.FlameShock)) or ((4947 - 3195) <= (1160 - (45 + 327)))) then
									return "flame_shock aoe 22";
								end
								if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((7371 - 3464) == (679 - (444 + 58)))) then
									return "flame_shock aoe 22";
								end
							end
							if (((1508 + 1962) > (96 + 459)) and v101.DeeplyRootedElements:IsAvailable() and v41 and not v101.SurgeofPower:IsAvailable() and (v101.FlameShockDebuff:AuraActiveCount() < (3 + 3))) then
								local v287 = 0 - 0;
								while true do
									if (((1732 - (64 + 1668)) == v287) or ((2945 - (1227 + 746)) == (1982 - 1337))) then
										if (((5904 - 2722) >= (2609 - (415 + 79))) and v105.CastCycle(v101.FlameShock, v113, v121, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 24";
										end
										if (((101 + 3792) < (4920 - (142 + 349))) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
											return "flame_shock aoe 24";
										end
										break;
									end
								end
							end
							v259 = 1 + 1;
						end
					end
				end
				if ((v101.Ascendance:IsCastable() and v53 and ((v59 and v34) or not v59) and (v91 < v109)) or ((3941 - 1074) < (947 + 958))) then
					if (v25(v101.Ascendance) or ((1266 + 530) >= (11032 - 6981))) then
						return "ascendance aoe 32";
					end
				end
				if (((3483 - (1710 + 154)) <= (4074 - (200 + 118))) and v127(v101.LavaBurst) and (v115 == (2 + 1)) and not v101.LightningRod:IsAvailable() and v14:HasTier(53 - 22, 5 - 1)) then
					local v260 = 0 + 0;
					while true do
						if (((598 + 6) == (325 + 279)) and (v260 == (0 + 0))) then
							if (v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst)) or ((9714 - 5230) == (2150 - (363 + 887)))) then
								return "lava_burst aoe 34";
							end
							if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((7785 - 3326) <= (5297 - 4184))) then
								return "lava_burst aoe 34";
							end
							break;
						end
					end
				end
				v170 = 1 + 1;
			end
			if (((8498 - 4866) > (2322 + 1076)) and (v170 == (1669 - (674 + 990)))) then
				if (((1171 + 2911) <= (2013 + 2904)) and v127(v101.LavaBeam) and v44 and v129() and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) then
					if (((7658 - 2826) >= (2441 - (507 + 548))) and v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam))) then
						return "lava_beam aoe 72";
					end
				end
				if (((974 - (289 + 548)) == (1955 - (821 + 997))) and v127(v101.ChainLightning) and v37 and v129()) then
					if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((1825 - (195 + 60)) >= (1165 + 3167))) then
						return "chain_lightning aoe 74";
					end
				end
				if ((v127(v101.LavaBeam) and v44 and (v115 >= (1507 - (251 + 1250))) and v14:BuffUp(v101.SurgeofPowerBuff) and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) or ((11905 - 7841) <= (1250 + 569))) then
					if (v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam)) or ((6018 - (809 + 223)) < (2296 - 722))) then
						return "lava_beam aoe 76";
					end
				end
				if (((13291 - 8865) > (568 - 396)) and v127(v101.ChainLightning) and v37 and (v115 >= (5 + 1)) and v14:BuffUp(v101.SurgeofPowerBuff)) then
					if (((307 + 279) > (1072 - (14 + 603))) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
						return "chain_lightning aoe 78";
					end
				end
				if (((955 - (118 + 11)) == (134 + 692)) and v127(v101.LavaBurst) and v14:BuffUp(v101.LavaSurgeBuff) and v101.DeeplyRootedElements:IsAvailable() and v14:BuffUp(v101.WindspeakersLavaResurgenceBuff)) then
					local v261 = 0 + 0;
					while true do
						if ((v261 == (0 - 0)) or ((4968 - (551 + 398)) > (2807 + 1634))) then
							if (((718 + 1299) < (3463 + 798)) and v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst aoe 80";
							end
							if (((17538 - 12822) > (184 - 104)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
								return "lava_burst aoe 80";
							end
							break;
						end
					end
				end
				if ((v127(v101.LavaBeam) and v44 and v128() and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) or ((1137 + 2370) == (12989 - 9717))) then
					if (v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam)) or ((242 + 634) >= (3164 - (40 + 49)))) then
						return "lava_beam aoe 82";
					end
				end
				v170 = 22 - 16;
			end
			if (((4842 - (99 + 391)) > (2113 + 441)) and (v170 == (13 - 10))) then
				if ((v38 and v101.Earthquake:IsReady() and not v101.EchoesofGreatSundering:IsAvailable() and not v101.ElementalBlast:IsAvailable() and (v115 == (7 - 4)) and ((v115 == (3 + 0)) or (v114 == (7 - 4)))) or ((6010 - (1032 + 572)) < (4460 - (203 + 214)))) then
					local v262 = 1817 - (568 + 1249);
					while true do
						if (((0 + 0) == v262) or ((4536 - 2647) >= (13067 - 9684))) then
							if (((3198 - (913 + 393)) <= (7720 - 4986)) and (v52 == "cursor")) then
								if (((2716 - 793) < (2628 - (269 + 141))) and v25(v103.EarthquakeCursor, not v17:IsInRange(88 - 48))) then
									return "earthquake aoe 48";
								end
							end
							if (((4154 - (362 + 1619)) > (2004 - (950 + 675))) and (v52 == "player")) then
								if (v25(v103.EarthquakePlayer, not v17:IsInRange(16 + 24)) or ((3770 - (216 + 963)) == (4696 - (485 + 802)))) then
									return "earthquake aoe 48";
								end
							end
							break;
						end
					end
				end
				if (((5073 - (432 + 127)) > (4397 - (1065 + 8))) and v38 and v101.Earthquake:IsReady() and (v14:BuffUp(v101.EchoesofGreatSunderingBuff))) then
					local v263 = 0 + 0;
					while true do
						if (((1601 - (635 + 966)) == v263) or ((150 + 58) >= (4870 - (5 + 37)))) then
							if ((v52 == "cursor") or ((3936 - 2353) > (1485 + 2082))) then
								if (v25(v103.EarthquakeCursor, not v17:IsInRange(63 - 23)) or ((615 + 698) == (1649 - 855))) then
									return "earthquake aoe 50";
								end
							end
							if (((12033 - 8859) > (5472 - 2570)) and (v52 == "player")) then
								if (((9850 - 5730) <= (3063 + 1197)) and v25(v103.EarthquakePlayer, not v17:IsInRange(569 - (318 + 211)))) then
									return "earthquake aoe 50";
								end
							end
							break;
						end
					end
				end
				if ((v127(v101.ElementalBlast) and v40 and v101.EchoesofGreatSundering:IsAvailable()) or ((4344 - 3461) > (6365 - (963 + 624)))) then
					if (v105.CastTargetIf(v101.ElementalBlast, v113, "min", v125, nil, not v17:IsSpellInRange(v101.ElementalBlast), nil, nil) or ((1548 + 2072) >= (5737 - (518 + 328)))) then
						return "elemental_blast aoe 52";
					end
					if (((9925 - 5667) > (1497 - 560)) and v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast aoe 52";
					end
				end
				if ((v127(v101.ElementalBlast) and v40 and v101.EchoesofGreatSundering:IsAvailable()) or ((5186 - (301 + 16)) < (2655 - 1749))) then
					if (v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast)) or ((3440 - 2215) > (11032 - 6804))) then
						return "elemental_blast aoe 54";
					end
				end
				if (((3015 + 313) > (1271 + 967)) and v127(v101.ElementalBlast) and v40 and (v115 == (5 - 2)) and not v101.EchoesofGreatSundering:IsAvailable()) then
					if (((2310 + 1529) > (134 + 1271)) and v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast aoe 56";
					end
				end
				if ((v127(v101.EarthShock) and v39 and v101.EchoesofGreatSundering:IsAvailable()) or ((4110 - 2817) <= (164 + 343))) then
					if (v105.CastTargetIf(v101.EarthShock, v113, "min", v125, nil, not v17:IsSpellInRange(v101.EarthShock), nil, nil) or ((3915 - (829 + 190)) < (2872 - 2067))) then
						return "earth_shock aoe 58";
					end
					if (((2930 - 614) == (3200 - 884)) and v25(v101.EarthShock, not v17:IsSpellInRange(v101.EarthShock))) then
						return "earth_shock aoe 58";
					end
				end
				v170 = 9 - 5;
			end
			if ((v170 == (2 + 4)) or ((840 + 1730) == (4652 - 3119))) then
				if ((v127(v101.LavaBurst) and (v115 == (3 + 0)) and v101.MasteroftheElements:IsAvailable()) or ((1496 - (520 + 93)) == (1736 - (259 + 17)))) then
					local v264 = 0 + 0;
					while true do
						if (((0 + 0) == v264) or ((15637 - 11018) <= (1590 - (396 + 195)))) then
							if (v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst)) or ((9893 - 6483) > (5877 - (440 + 1321)))) then
								return "lava_burst aoe 84";
							end
							if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((2732 - (1059 + 770)) >= (14145 - 11086))) then
								return "lava_burst aoe 84";
							end
							break;
						end
					end
				end
				if ((v127(v101.LavaBurst) and v14:BuffUp(v101.LavaSurgeBuff) and v101.DeeplyRootedElements:IsAvailable()) or ((4521 - (424 + 121)) < (521 + 2336))) then
					local v265 = 1347 - (641 + 706);
					while true do
						if (((1953 + 2977) > (2747 - (249 + 191))) and (v265 == (0 - 0))) then
							if (v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst)) or ((1807 + 2239) < (4975 - 3684))) then
								return "lava_burst aoe 86";
							end
							if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((4668 - (183 + 244)) == (175 + 3370))) then
								return "lava_burst aoe 86";
							end
							break;
						end
					end
				end
				if ((v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (730 - (434 + 296))) and v43 and v101.ElectrifiedShocks:IsAvailable() and (v115 < (15 - 10))) or ((4560 - (169 + 343)) > (3711 + 521))) then
					if (v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury)) or ((3079 - 1329) >= (10193 - 6720))) then
						return "icefury aoe 88";
					end
				end
				if (((2594 + 572) == (8978 - 5812)) and v127(v101.FrostShock) and v42 and v14:BuffUp(v101.IcefuryBuff) and v101.ElectrifiedShocks:IsAvailable() and not v17:DebuffUp(v101.ElectrifiedShocksDebuff) and (v115 < (1128 - (651 + 472))) and v101.UnrelentingCalamity:IsAvailable()) then
					if (((1333 + 430) < (1607 + 2117)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock aoe 90";
					end
				end
				if (((69 - 12) <= (3206 - (397 + 86))) and v127(v101.LavaBeam) and v44 and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime())) then
					if (v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam)) or ((2946 - (423 + 453)) == (46 + 397))) then
						return "lava_beam aoe 92";
					end
				end
				if ((v127(v101.ChainLightning) and v37) or ((357 + 2348) == (1217 + 176))) then
					if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((3672 + 929) < (55 + 6))) then
						return "chain_lightning aoe 94";
					end
				end
				v170 = 1197 - (50 + 1140);
			end
			if ((v170 == (2 + 0)) or ((821 + 569) >= (295 + 4449))) then
				if ((v38 and v101.Earthquake:IsReady() and v128() and (((v14:BuffStack(v101.MagmaChamberBuff) > (21 - 6)) and (v115 >= ((6 + 1) - v26(v101.UnrelentingCalamity:IsAvailable())))) or (v101.SplinteredElements:IsAvailable() and (v115 >= ((606 - (157 + 439)) - v26(v101.UnrelentingCalamity:IsAvailable())))) or (v101.MountainsWillFall:IsAvailable() and (v115 >= (15 - 6)))) and not v101.LightningRod:IsAvailable() and v14:HasTier(102 - 71, 11 - 7)) or ((2921 - (782 + 136)) > (4689 - (112 + 743)))) then
					local v266 = 1171 - (1026 + 145);
					while true do
						if ((v266 == (0 + 0)) or ((874 - (493 + 225)) > (14382 - 10469))) then
							if (((119 + 76) == (522 - 327)) and (v52 == "cursor")) then
								if (((60 + 3045) >= (5132 - 3336)) and v25(v103.EarthquakeCursor, not v17:IsInRange(12 + 28))) then
									return "earthquake aoe 36";
								end
							end
							if (((7315 - 2936) >= (3726 - (210 + 1385))) and (v52 == "player")) then
								if (((5533 - (1201 + 488)) >= (1267 + 776)) and v25(v103.EarthquakePlayer, not v17:IsInRange(71 - 31))) then
									return "earthquake aoe 36";
								end
							end
							break;
						end
					end
				end
				if ((v127(v101.LavaBeam) and v44 and v130() and ((v14:BuffUp(v101.SurgeofPowerBuff) and (v115 >= (10 - 4))) or (v128() and ((v115 < (591 - (352 + 233))) or not v101.SurgeofPower:IsAvailable()))) and not v101.LightningRod:IsAvailable() and v14:HasTier(74 - 43, 3 + 1)) or ((9189 - 5957) <= (3305 - (489 + 85)))) then
					if (((6406 - (277 + 1224)) == (6398 - (663 + 830))) and v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam))) then
						return "lava_beam aoe 38";
					end
				end
				if ((v127(v101.ChainLightning) and v37 and v130() and ((v14:BuffUp(v101.SurgeofPowerBuff) and (v115 >= (6 + 0))) or (v128() and ((v115 < (14 - 8)) or not v101.SurgeofPower:IsAvailable()))) and not v101.LightningRod:IsAvailable() and v14:HasTier(906 - (461 + 414), 1 + 3)) or ((1655 + 2481) >= (421 + 3990))) then
					if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((2917 + 41) == (4267 - (172 + 78)))) then
						return "chain_lightning aoe 40";
					end
				end
				if (((1979 - 751) >= (300 + 513)) and v127(v101.LavaBurst) and v14:BuffUp(v101.LavaSurgeBuff) and not v101.LightningRod:IsAvailable() and v14:HasTier(44 - 13, 2 + 2)) then
					if (v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst)) or ((1154 + 2301) > (6785 - 2735))) then
						return "lava_burst aoe 42";
					end
					if (((305 - 62) == (62 + 181)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst aoe 42";
					end
				end
				if ((v127(v101.LavaBurst) and v14:BuffUp(v101.LavaSurgeBuff) and v101.MasteroftheElements:IsAvailable() and not v128() and (v126() >= (((34 + 26) - ((2 + 3) * v101.EyeoftheStorm:TalentRank())) - ((7 - 5) * v26(v101.FlowofPower:IsAvailable())))) and ((not v101.EchoesofGreatSundering:IsAvailable() and not v101.LightningRod:IsAvailable()) or v14:BuffUp(v101.EchoesofGreatSunderingBuff)) and ((not v14:BuffUp(v101.AscendanceBuff) and (v115 > (6 - 3)) and v101.UnrelentingCalamity:IsAvailable()) or ((v115 > (1 + 2)) and not v101.UnrelentingCalamity:IsAvailable()) or (v115 == (2 + 1)))) or ((718 - (133 + 314)) > (274 + 1298))) then
					local v267 = 213 - (199 + 14);
					while true do
						if (((9805 - 7066) < (4842 - (647 + 902))) and ((0 - 0) == v267)) then
							if (v105.CastCycle(v101.LavaBurst, v113, v123, not v17:IsSpellInRange(v101.LavaBurst)) or ((4175 - (85 + 148)) < (2423 - (426 + 863)))) then
								return "lava_burst aoe 44";
							end
							if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((12603 - 9910) == (6627 - (873 + 781)))) then
								return "lava_burst aoe 44";
							end
							break;
						end
					end
				end
				if (((2873 - 727) == (5795 - 3649)) and v38 and v101.Earthquake:IsReady() and not v101.EchoesofGreatSundering:IsAvailable() and (v115 > (2 + 1)) and ((v115 > (11 - 8)) or (v114 > (3 - 0)))) then
					local v268 = 0 - 0;
					while true do
						if ((v268 == (1947 - (414 + 1533))) or ((1946 + 298) == (3779 - (443 + 112)))) then
							if ((v52 == "cursor") or ((6383 - (888 + 591)) <= (4950 - 3034))) then
								if (((6 + 84) <= (4011 - 2946)) and v25(v103.EarthquakeCursor, not v17:IsInRange(16 + 24))) then
									return "earthquake aoe 46";
								end
							end
							if (((2323 + 2479) == (514 + 4288)) and (v52 == "player")) then
								if (v25(v103.EarthquakePlayer, not v17:IsInRange(76 - 36)) or ((4223 - 1943) <= (2189 - (136 + 1542)))) then
									return "earthquake aoe 46";
								end
							end
							break;
						end
					end
				end
				v170 = 9 - 6;
			end
		end
	end
	local function v139()
		if ((v101.FireElemental:IsCastable() and v54 and ((v60 and v34) or not v60) and (v91 < v109)) or ((1664 + 12) <= (736 - 273))) then
			if (((2801 + 1068) == (4355 - (68 + 418))) and v25(v101.FireElemental)) then
				return "fire_elemental single_target 2";
			end
		end
		if (((3139 - 1981) <= (4740 - 2127)) and v101.StormElemental:IsCastable() and v56 and ((v61 and v34) or not v61) and (v91 < v109)) then
			if (v25(v101.StormElemental) or ((2041 + 323) <= (3091 - (770 + 322)))) then
				return "storm_elemental single_target 4";
			end
		end
		if ((v101.TotemicRecall:IsCastable() and v50 and (v101.LiquidMagmaTotem:CooldownRemains() > (3 + 42)) and ((v101.LavaSurge:IsAvailable() and v101.SplinteredElements:IsAvailable()) or ((v114 > (1 + 0)) and (v115 > (1 + 0))))) or ((7041 - 2119) < (376 - 182))) then
			if (v25(v101.TotemicRecall) or ((5694 - 3603) < (113 - 82))) then
				return "totemic_recall single_target 6";
			end
		end
		if ((v101.LiquidMagmaTotem:IsCastable() and v55 and ((v62 and v34) or not v62) and (v91 < v109) and ((v101.LavaSurge:IsAvailable() and v101.SplinteredElements:IsAvailable()) or (v101.FlameShockDebuff:AuraActiveCount() == (0 + 0)) or (v17:DebuffRemains(v101.FlameShockDebuff) < (8 - 2)) or ((v114 > (1 + 0)) and (v115 > (1 + 0))))) or ((1905 + 525) >= (18345 - 13473))) then
			local v197 = 0 - 0;
			while true do
				if ((v197 == (0 + 0)) or ((21972 - 17202) < (5735 - 4000))) then
					if ((v67 == "cursor") or ((1826 + 2613) <= (11628 - 9278))) then
						if (v25(v103.LiquidMagmaTotemCursor, not v17:IsInRange(871 - (762 + 69))) or ((14503 - 10024) < (3848 + 618))) then
							return "liquid_magma_totem single_target cursor 8";
						end
					end
					if (((1649 + 898) > (2962 - 1737)) and (v67 == "player")) then
						if (((1470 + 3201) > (43 + 2631)) and v25(v103.LiquidMagmaTotemPlayer, not v17:IsInRange(155 - 115))) then
							return "liquid_magma_totem single_target player 8";
						end
					end
					break;
				end
			end
		end
		if ((v127(v101.PrimordialWave) and v101.PrimordialWave:IsCastable() and v48 and ((v65 and v35) or not v65) and not v14:BuffUp(v101.PrimordialWaveBuff) and not v14:BuffUp(v101.SplinteredElementsBuff)) or ((3853 - (8 + 149)) < (4647 - (1199 + 121)))) then
			local v198 = 0 - 0;
			while true do
				if ((v198 == (0 - 0)) or ((1871 + 2671) == (10601 - 7631))) then
					if (((584 - 332) <= (1750 + 227)) and v105.CastCycle(v101.PrimordialWave, v113, v123, not v17:IsSpellInRange(v101.PrimordialWave))) then
						return "primordial_wave single_target 10";
					end
					if (v25(v101.PrimordialWave, not v17:IsSpellInRange(v101.PrimordialWave)) or ((3243 - (518 + 1289)) == (6473 - 2698))) then
						return "primordial_wave single_target 10";
					end
					break;
				end
			end
		end
		if ((v101.FlameShock:IsCastable() and v41 and (v114 == (1 + 0)) and v17:DebuffRefreshable(v101.FlameShockDebuff) and ((v17:DebuffRemains(v101.FlameShockDebuff) < v101.PrimordialWave:CooldownRemains()) or not v101.PrimordialWave:IsAvailable()) and v14:BuffDown(v101.SurgeofPowerBuff) and (not v128() or (not v130() and ((v101.ElementalBlast:IsAvailable() and (v126() < ((131 - 41) - ((6 + 2) * v101.EyeoftheStorm:TalentRank())))) or (v126() < ((529 - (304 + 165)) - ((5 + 0) * v101.EyeoftheStorm:TalentRank()))))))) or ((1778 - (54 + 106)) < (2899 - (1618 + 351)))) then
			if (((3331 + 1392) > (5169 - (10 + 1006))) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
				return "flame_shock single_target 12";
			end
		end
		if ((v101.FlameShock:IsCastable() and v41 and (v101.FlameShockDebuff:AuraActiveCount() == (0 + 0)) and (v114 > (1 + 0)) and (v115 > (3 - 2)) and (v101.DeeplyRootedElements:IsAvailable() or v101.Ascendance:IsAvailable() or v101.PrimordialWave:IsAvailable() or v101.SearingFlames:IsAvailable() or v101.MagmaChamber:IsAvailable()) and ((not v128() and (v130() or (v101.Stormkeeper:CooldownRemains() > (1033 - (912 + 121))))) or not v101.SurgeofPower:IsAvailable())) or ((1727 + 1927) >= (5943 - (1140 + 149)))) then
			local v199 = 0 + 0;
			while true do
				if (((1267 - 316) <= (279 + 1217)) and ((0 - 0) == v199)) then
					if (v105.CastTargetIf(v101.FlameShock, v113, "min", v123, nil, not v17:IsSpellInRange(v101.FlameShock)) or ((3255 - 1519) == (99 + 472))) then
						return "flame_shock single_target 14";
					end
					if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((3109 - 2213) > (4955 - (165 + 21)))) then
						return "flame_shock single_target 14";
					end
					break;
				end
			end
		end
		if ((v101.FlameShock:IsCastable() and v41 and (v114 > (112 - (61 + 50))) and (v115 > (1 + 0)) and (v101.DeeplyRootedElements:IsAvailable() or v101.Ascendance:IsAvailable() or v101.PrimordialWave:IsAvailable() or v101.SearingFlames:IsAvailable() or v101.MagmaChamber:IsAvailable()) and ((v14:BuffUp(v101.SurgeofPowerBuff) and not v130() and v101.Stormkeeper:IsAvailable()) or not v101.SurgeofPower:IsAvailable())) or ((4980 - 3935) <= (2055 - 1035))) then
			local v200 = 0 + 0;
			while true do
				if ((v200 == (1460 - (1295 + 165))) or ((265 + 895) <= (132 + 196))) then
					if (((5205 - (819 + 578)) > (4326 - (331 + 1071))) and v105.CastTargetIf(v101.FlameShock, v113, "min", v123, v120, not v17:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock single_target 16";
					end
					if (((4634 - (588 + 155)) < (6201 - (546 + 736))) and v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock single_target 16";
					end
					break;
				end
			end
		end
		if ((v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (1937 - (1834 + 103))) and not v14:BuffUp(v101.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v109) and v14:BuffDown(v101.AscendanceBuff) and not v130() and (v126() >= (72 + 44)) and v101.ElementalBlast:IsAvailable() and v101.SurgeofPower:IsAvailable() and v101.SwellingMaelstrom:IsAvailable() and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.PrimordialSurge:IsAvailable()) or ((6664 - 4430) <= (3268 - (1536 + 230)))) then
			if (v25(v101.Stormkeeper) or ((3003 - (128 + 363)) < (92 + 340))) then
				return "stormkeeper single_target 18";
			end
		end
		if ((v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v101.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v109) and v14:BuffDown(v101.AscendanceBuff) and not v130() and v14:BuffUp(v101.SurgeofPowerBuff) and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.PrimordialSurge:IsAvailable()) or ((478 + 1370) == (1432 - 567))) then
			if (v25(v101.Stormkeeper) or ((13783 - 9101) <= (11029 - 6488))) then
				return "stormkeeper single_target 20";
			end
		end
		if ((v127(v101.Stormkeeper) and (v101.Stormkeeper:CooldownRemains() == (0 + 0)) and not v14:BuffUp(v101.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v109) and v14:BuffDown(v101.AscendanceBuff) and not v130() and (not v101.SurgeofPower:IsAvailable() or not v101.ElementalBlast:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.EchooftheElements:IsAvailable() or v101.PrimordialSurge:IsAvailable())) or ((4035 - (615 + 394)) >= (3653 + 393))) then
			if (((1914 + 94) > (1944 - 1306)) and v25(v101.Stormkeeper)) then
				return "stormkeeper single_target 22";
			end
		end
		if (((8051 - 6276) <= (3884 - (59 + 592))) and v101.Ascendance:IsCastable() and v53 and ((v59 and v34) or not v59) and (v91 < v109) and not v130()) then
			if (v25(v101.Ascendance) or ((10057 - 5514) == (3677 - 1680))) then
				return "ascendance single_target 24";
			end
		end
		if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v130() and v14:BuffUp(v101.SurgeofPowerBuff)) or ((2187 + 915) < (899 - (70 + 101)))) then
			if (((852 - 507) == (245 + 100)) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single_target 26";
			end
		end
		if ((v127(v101.LavaBeam) and v44 and (v114 > (2 - 1)) and (v115 > (242 - (123 + 118))) and v130() and not v101.SurgeofPower:IsAvailable()) or ((685 + 2142) < (5 + 373))) then
			if (v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam)) or ((4875 - (653 + 746)) < (4857 - 2260))) then
				return "lava_beam single_target 28";
			end
		end
		if (((4435 - 1356) < (12835 - 8041)) and v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and (v114 > (1 + 0)) and (v115 > (1 + 0)) and v130() and not v101.SurgeofPower:IsAvailable()) then
			if (((4240 + 614) > (547 + 3917)) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
				return "chain_lightning single_target 30";
			end
		end
		if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v130() and not v128() and not v101.SurgeofPower:IsAvailable() and v101.MasteroftheElements:IsAvailable()) or ((767 + 4145) == (9212 - 5454))) then
			if (((120 + 6) <= (6432 - 2950)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
				return "lava_burst single_target 32";
			end
		end
		if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v130() and not v101.SurgeofPower:IsAvailable() and v128()) or ((3608 - (885 + 349)) == (3474 + 900))) then
			if (((4295 - 2720) == (4581 - 3006)) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single_target 34";
			end
		end
		if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v130() and not v101.SurgeofPower:IsAvailable() and not v101.MasteroftheElements:IsAvailable()) or ((3202 - (915 + 53)) == (2256 - (768 + 33)))) then
			if (v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt)) or ((4085 - 3018) > (3131 - 1352))) then
				return "lightning_bolt single_target 36";
			end
		end
		if (((2489 - (287 + 41)) >= (1781 - (638 + 209))) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v14:BuffUp(v101.SurgeofPowerBuff) and v101.LightningRod:IsAvailable()) then
			if (((838 + 774) == (3298 - (96 + 1590))) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single_target 38";
			end
		end
		if (((6024 - (741 + 931)) >= (1392 + 1441)) and v127(v101.Icefury) and (v101.Icefury:CooldownRemains() == (0 - 0)) and v43 and v101.ElectrifiedShocks:IsAvailable() and v101.LightningRod:IsAvailable() and v101.LightningRod:IsAvailable()) then
			if (v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury)) or ((15052 - 11830) < (1319 + 1754))) then
				return "icefury single_target 40";
			end
		end
		if (((320 + 424) <= (938 + 2004)) and v101.FrostShock:IsCastable() and v42 and v131() and v101.ElectrifiedShocks:IsAvailable() and ((v17:DebuffRemains(v101.ElectrifiedShocksDebuff) < (7 - 5)) or (v14:BuffRemains(v101.IcefuryBuff) <= v14:GCD())) and v101.LightningRod:IsAvailable()) then
			if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((596 + 1237) <= (646 + 676))) then
				return "frost_shock single_target 42";
			end
		end
		if ((v101.FrostShock:IsCastable() and v42 and v131() and v101.ElectrifiedShocks:IsAvailable() and (v126() >= (203 - 153)) and (v17:DebuffRemains(v101.ElectrifiedShocksDebuff) < ((2 + 0) * v14:GCD())) and v130() and v101.LightningRod:IsAvailable()) or ((3961 - (64 + 430)) <= (1047 + 8))) then
			if (((3904 - (106 + 257)) == (2511 + 1030)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock single_target 44";
			end
		end
		if ((v101.LavaBeam:IsCastable() and v44 and (v114 > (722 - (496 + 225))) and (v115 > (1 - 0)) and v129() and (v14:BuffRemains(v101.AscendanceBuff) > v101.LavaBeam:CastTime()) and not v14:HasTier(150 - 119, 1662 - (256 + 1402))) or ((5456 - (30 + 1869)) >= (5372 - (213 + 1156)))) then
			if (v25(v101.LavaBeam, not v17:IsSpellInRange(v101.LavaBeam)) or ((845 - (96 + 92)) >= (285 + 1383))) then
				return "lava_beam single_target 46";
			end
		end
		if ((v101.FrostShock:IsCastable() and v42 and v131() and v130() and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.PrimordialSurge:IsAvailable() and v101.ElementalBlast:IsAvailable() and (((v126() >= (960 - (142 + 757))) and (v126() < (62 + 13)) and (v101.LavaBurst:CooldownRemains() > v14:GCD())) or ((v126() >= (21 + 28)) and (v126() < (142 - (32 + 47))) and (v101.LavaBurst:CooldownRemains() > (1977 - (1053 + 924)))))) or ((1006 + 21) > (6644 - 2786))) then
			if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((5302 - (685 + 963)) < (915 - 465))) then
				return "frost_shock single_target 48";
			end
		end
		if (((2948 - 1057) < (6162 - (541 + 1168))) and v101.FrostShock:IsCastable() and v42 and v131() and not v101.LavaSurge:IsAvailable() and not v101.EchooftheElements:IsAvailable() and not v101.ElementalBlast:IsAvailable() and (((v126() >= (1633 - (645 + 952))) and (v126() < (888 - (669 + 169))) and (v101.LavaBurst:CooldownRemains() > v14:GCD())) or ((v126() >= (83 - 59)) and (v126() < (82 - 44)) and (v101.LavaBurst:CooldownRemains() > (0 + 0))))) then
			if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((693 + 2447) < (2894 - (181 + 584)))) then
				return "frost_shock single_target 50";
			end
		end
		if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v14:BuffUp(v101.WindspeakersLavaResurgenceBuff) and (v101.EchooftheElements:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.PrimordialSurge:IsAvailable() or ((v126() >= (1458 - (665 + 730))) and v101.MasteroftheElements:IsAvailable()) or ((v126() >= (109 - 71)) and v14:BuffUp(v101.EchoesofGreatSunderingBuff) and (v114 > (1 - 0)) and (v115 > (1351 - (540 + 810)))) or not v101.ElementalBlast:IsAvailable())) or ((10215 - 7660) < (3409 - 2169))) then
			if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((3762 + 965) <= (4925 - (166 + 37)))) then
				return "lava_burst single_target 52";
			end
		end
		if (((2621 - (22 + 1859)) < (6709 - (843 + 929))) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v14:BuffUp(v101.LavaSurgeBuff) and (v101.EchooftheElements:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.PrimordialSurge:IsAvailable() or not v101.MasteroftheElements:IsAvailable() or not v101.ElementalBlast:IsAvailable())) then
			if (((3920 - (30 + 232)) >= (799 - 519)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
				return "lava_burst single_target 54";
			end
		end
		if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v14:BuffUp(v101.AscendanceBuff) and (v14:HasTier(808 - (55 + 722), 8 - 4) or not v101.ElementalBlast:IsAvailable())) or ((2560 - (78 + 1597)) >= (227 + 804))) then
			local v201 = 0 + 0;
			while true do
				if (((2976 + 578) >= (1074 - (305 + 244))) and (v201 == (0 + 0))) then
					if (((2519 - (95 + 10)) <= (2105 + 867)) and v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst single_target 56";
					end
					if (((11183 - 7654) <= (4839 - 1301)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst single_target 56";
					end
					break;
				end
			end
		end
		if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v14:BuffDown(v101.AscendanceBuff) and (not v101.ElementalBlast:IsAvailable() or not v101.MountainsWillFall:IsAvailable()) and not v101.LightningRod:IsAvailable() and v14:HasTier(793 - (592 + 170), 13 - 9)) or ((7184 - 4323) < (214 + 244))) then
			local v202 = 0 + 0;
			while true do
				if (((4146 - 2429) <= (734 + 3791)) and (v202 == (0 - 0))) then
					if (v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst)) or ((3685 - (353 + 154)) <= (2028 - 504))) then
						return "lava_burst single_target 58";
					end
					if (((5811 - 1557) > (256 + 114)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst single_target 58";
					end
					break;
				end
			end
		end
		if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v101.MasteroftheElements:IsAvailable() and not v128() and not v101.LightningRod:IsAvailable()) or ((1281 + 354) == (1173 + 604))) then
			if (v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst)) or ((4823 - 1485) >= (7558 - 3565))) then
				return "lava_burst single_target 60";
			end
			if (((2689 - 1535) <= (1561 - (7 + 79))) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
				return "lava_burst single_target 60";
			end
		end
		if ((v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and v101.MasteroftheElements:IsAvailable() and not v128() and ((v126() >= (36 + 39)) or ((v126() >= (231 - (24 + 157))) and not v101.ElementalBlast:IsAvailable())) and v101.SwellingMaelstrom:IsAvailable() and (v126() <= (259 - 129))) or ((5567 - 2957) < (350 + 880))) then
			if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((3900 - 2452) == (3463 - (262 + 118)))) then
				return "lava_burst single_target 62";
			end
		end
		if (((4222 - (1038 + 45)) > (1980 - 1064)) and v101.Earthquake:IsReady() and v38 and v14:BuffUp(v101.EchoesofGreatSunderingBuff) and ((not v101.ElementalBlast:IsAvailable() and (v114 < (232 - (19 + 211)))) or (v114 > (114 - (88 + 25))))) then
			local v203 = 0 - 0;
			while true do
				if (((1467 + 1487) == (2757 + 197)) and (v203 == (1036 - (1007 + 29)))) then
					if (((32 + 85) <= (7068 - 4176)) and (v52 == "cursor")) then
						if (v25(v103.EarthquakeCursor, not v17:IsInRange(189 - 149)) or ((101 + 352) > (5473 - (340 + 471)))) then
							return "earthquake single_target 64";
						end
					end
					if (((3324 - 2004) > (1184 - (276 + 313))) and (v52 == "player")) then
						if (v25(v103.EarthquakePlayer, not v17:IsInRange(97 - 57)) or ((2949 + 250) < (251 + 339))) then
							return "earthquake single_target 64";
						end
					end
					break;
				end
			end
		end
		if ((v101.Earthquake:IsReady() and v38 and (v114 > (1 + 0)) and (v115 > (1973 - (495 + 1477))) and not v101.EchoesofGreatSundering:IsAvailable() and not v101.ElementalBlast:IsAvailable()) or ((14350 - 9557) < (20 + 10))) then
			local v204 = 403 - (342 + 61);
			while true do
				if ((v204 == (0 + 0)) or ((1861 - (4 + 161)) <= (649 + 410))) then
					if (((7354 - 5011) == (6158 - 3815)) and (v52 == "cursor")) then
						if (v25(v103.EarthquakeCursor, not v17:IsInRange(537 - (322 + 175))) or ((1606 - (173 + 390)) > (886 + 2705))) then
							return "earthquake single_target 66";
						end
					end
					if ((v52 == "player") or ((3204 - (203 + 111)) >= (253 + 3826))) then
						if (((3155 + 1319) <= (13920 - 9150)) and v25(v103.EarthquakePlayer, not v17:IsInRange(37 + 3))) then
							return "earthquake single_target 66";
						end
					end
					break;
				end
			end
		end
		if ((v127(v101.ElementalBlast) and v101.ElementalBlast:IsCastable() and v40 and (not v101.MasteroftheElements:IsAvailable() or (v128() and v17:DebuffUp(v101.ElectrifiedShocksDebuff)))) or ((5648 - (57 + 649)) == (4287 - (328 + 56)))) then
			if (v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast)) or ((80 + 168) > (5357 - (433 + 79)))) then
				return "elemental_blast single_target 68";
			end
		end
		if (((144 + 1425) == (1267 + 302)) and v127(v101.FrostShock) and v42 and v131() and v128() and (v126() < (369 - 259)) and (v101.LavaBurst:ChargesFractional() < (4 - 3)) and v101.ElectrifiedShocks:IsAvailable() and v101.ElementalBlast:IsAvailable() and not v101.LightningRod:IsAvailable()) then
			if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((3593 + 1334) <= (2870 + 351))) then
				return "frost_shock single_target 70";
			end
		end
		if ((v127(v101.ElementalBlast) and v101.ElementalBlast:IsCastable() and v40 and (v128() or v101.LightningRod:IsAvailable())) or ((2816 - (562 + 474)) > (6502 - 3715))) then
			if (v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast)) or ((8021 - 4084) <= (2135 - (76 + 829)))) then
				return "elemental_blast single_target 72";
			end
		end
		if ((v101.EarthShock:IsReady() and v39) or ((4310 - (1506 + 167)) < (3204 - 1498))) then
			if (v25(v101.EarthShock, not v17:IsSpellInRange(v101.EarthShock)) or ((2935 - (58 + 208)) <= (1423 + 986))) then
				return "earth_shock single_target 74";
			end
		end
		if ((v127(v101.FrostShock) and v42 and v131() and v101.ElectrifiedShocks:IsAvailable() and v128() and not v101.LightningRod:IsAvailable() and (v114 > (1 + 0)) and (v115 > (1 + 0))) or ((5715 - 4314) > (5033 - (258 + 79)))) then
			if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((417 + 2863) < (2778 - 1457))) then
				return "frost_shock single_target 76";
			end
		end
		if (((6397 - (1219 + 251)) >= (3974 - (1231 + 440))) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and (v101.DeeplyRootedElements:IsAvailable())) then
			local v205 = 58 - (34 + 24);
			while true do
				if (((2008 + 1454) >= (1926 - 894)) and (v205 == (0 + 0))) then
					if (v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst)) or ((3271 - 2194) >= (6446 - 4435))) then
						return "lava_burst single_target 78";
					end
					if (((4056 - 2513) < (8090 - 5675)) and v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst))) then
						return "lava_burst single_target 78";
					end
					break;
				end
			end
		end
		if ((v101.FrostShock:IsCastable() and v42 and v131() and v101.FluxMelting:IsAvailable() and v14:BuffDown(v101.FluxMeltingBuff)) or ((9703 - 5259) < (3604 - (877 + 712)))) then
			if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((2515 + 1685) == (3086 - (242 + 512)))) then
				return "frost_shock single_target 80";
			end
		end
		if ((v101.FrostShock:IsCastable() and v42 and v131() and ((v101.ElectrifiedShocks:IsAvailable() and (v17:DebuffRemains(v101.ElectrifiedShocksDebuff) < (3 - 1))) or (v14:BuffRemains(v101.IcefuryBuff) < (633 - (92 + 535))))) or ((1007 + 271) >= (2710 - 1394))) then
			if (((68 + 1014) == (3932 - 2850)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock single_target 82";
			end
		end
		if (((1303 + 25) <= (3378 + 1500)) and v127(v101.LavaBurst) and v101.LavaBurst:IsCastable() and v45 and (v101.EchooftheElements:IsAvailable() or v101.LavaSurge:IsAvailable() or v101.PrimordialSurge:IsAvailable() or not v101.ElementalBlast:IsAvailable() or not v101.MasteroftheElements:IsAvailable() or v130())) then
			if (((574 + 3513) >= (2700 - 1345)) and v105.CastCycle(v101.LavaBurst, v113, v124, not v17:IsSpellInRange(v101.LavaBurst))) then
				return "lava_burst single_target 84";
			end
			if (v25(v101.LavaBurst, not v17:IsSpellInRange(v101.LavaBurst)) or ((899 - 309) > (6435 - (1476 + 309)))) then
				return "lava_burst single_target 84";
			end
		end
		if ((v127(v101.ElementalBlast) and v101.ElementalBlast:IsCastable() and v40) or ((5058 - (299 + 985)) <= (872 + 2795))) then
			if (((4163 - 2893) < (2239 - (86 + 7))) and v25(v101.ElementalBlast, not v17:IsSpellInRange(v101.ElementalBlast))) then
				return "elemental_blast single_target 86";
			end
		end
		if (((18647 - 14084) >= (6 + 50)) and v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and v129() and v101.UnrelentingCalamity:IsAvailable() and (v114 > (881 - (672 + 208))) and (v115 > (1 + 0))) then
			if (v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning)) or ((578 - (14 + 118)) == (1067 - (339 + 106)))) then
				return "chain_lightning single_target 88";
			end
		end
		if (((1646 + 423) > (508 + 501)) and v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v129() and v101.UnrelentingCalamity:IsAvailable()) then
			if (((1407 - (440 + 955)) < (4147 + 61)) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single_target 90";
			end
		end
		if ((v127(v101.Icefury) and v101.Icefury:IsCastable() and v43) or ((5371 - 2381) <= (989 + 1991))) then
			if (v25(v101.Icefury, not v17:IsSpellInRange(v101.Icefury)) or ((6411 - 3836) >= (2928 + 1347))) then
				return "icefury single_target 92";
			end
		end
		if ((v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v101.LightningRodDebuff) and (v17:DebuffUp(v101.ElectrifiedShocksDebuff) or v129()) and (v114 > (354 - (260 + 93))) and (v115 > (1 + 0))) or ((8294 - 4668) <= (2358 - 1052))) then
			if (((3342 - (1181 + 793)) < (963 + 2817)) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
				return "chain_lightning single_target 94";
			end
		end
		if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v101.LightningRodDebuff) and (v17:DebuffUp(v101.ElectrifiedShocksDebuff) or v129())) or ((3476 - (105 + 202)) == (1823 + 450))) then
			if (((3291 - (352 + 458)) <= (13220 - 9941)) and v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single_target 96";
			end
		end
		if ((v101.FrostShock:IsCastable() and v42 and v131() and v128() and v14:BuffDown(v101.LavaSurgeBuff) and not v101.ElectrifiedShocks:IsAvailable() and not v101.FluxMelting:IsAvailable() and (v101.LavaBurst:ChargesFractional() < (2 - 1)) and v101.EchooftheElements:IsAvailable()) or ((1030 + 33) <= (2563 - 1686))) then
			if (((3263 - (438 + 511)) == (3697 - (1262 + 121))) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock single_target 98";
			end
		end
		if (((1992 - (728 + 340)) >= (2267 - (816 + 974))) and v101.FrostShock:IsCastable() and v42 and v131() and (v101.FluxMelting:IsAvailable() or (v101.ElectrifiedShocks:IsAvailable() and not v101.LightningRod:IsAvailable()))) then
			if (((5554 - 3741) <= (13596 - 9818)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock single_target 100";
			end
		end
		if (((4489 - (163 + 176)) == (11813 - 7663)) and v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and v128() and v14:BuffDown(v101.LavaSurgeBuff) and (v101.LavaBurst:ChargesFractional() < (4 - 3)) and v101.EchooftheElements:IsAvailable() and (v114 > (1 + 0)) and (v115 > (1811 - (1564 + 246)))) then
			if (((777 - (124 + 221)) <= (2054 + 953)) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
				return "chain_lightning single_target 102";
			end
		end
		if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46 and v128() and v14:BuffDown(v101.LavaSurgeBuff) and (v101.LavaBurst:ChargesFractional() < (452 - (115 + 336))) and v101.EchooftheElements:IsAvailable()) or ((898 - 490) > (561 + 2160))) then
			if (v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt)) or ((3464 - (45 + 1)) < (135 + 2362))) then
				return "lightning_bolt single_target 104";
			end
		end
		if (((3725 - (1282 + 708)) < (3381 - (583 + 629))) and v101.FrostShock:IsCastable() and v42 and v131() and not v101.ElectrifiedShocks:IsAvailable() and not v101.FluxMelting:IsAvailable()) then
			if (((648 + 3242) >= (8438 - 5176)) and v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock single_target 106";
			end
		end
		if ((v127(v101.ChainLightning) and v101.ChainLightning:IsCastable() and v37 and (v114 > (1 + 0)) and (v115 > (1171 - (943 + 227)))) or ((1905 + 2451) >= (6280 - (1539 + 92)))) then
			if (((5850 - (706 + 1240)) == (4162 - (81 + 177))) and v25(v101.ChainLightning, not v17:IsSpellInRange(v101.ChainLightning))) then
				return "chain_lightning single_target 108";
			end
		end
		if ((v127(v101.LightningBolt) and v101.LightningBolt:IsCastable() and v46) or ((8080 - 5220) >= (4046 - (212 + 45)))) then
			if (v25(v101.LightningBolt, not v17:IsSpellInRange(v101.LightningBolt)) or ((3632 - 2546) > (6395 - (708 + 1238)))) then
				return "lightning_bolt single_target 110";
			end
		end
		if (((415 + 4566) > (179 + 367)) and v101.FlameShock:IsCastable() and v41 and (v14:IsMoving())) then
			local v206 = 1667 - (586 + 1081);
			while true do
				if ((v206 == (511 - (348 + 163))) or ((2125 + 241) <= (288 - (215 + 65)))) then
					if (v105.CastCycle(v101.FlameShock, v113, v120, not v17:IsSpellInRange(v101.FlameShock)) or ((6599 - 4009) == (4723 - (1541 + 318)))) then
						return "flame_shock single_target 112";
					end
					if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((2328 + 296) > (2098 + 2051))) then
						return "flame_shock single_target 112";
					end
					break;
				end
			end
		end
		if ((v101.FlameShock:IsCastable() and v41) or ((1973 + 645) >= (6245 - (1036 + 714)))) then
			if (v25(v101.FlameShock, not v17:IsSpellInRange(v101.FlameShock)) or ((1638 + 847) >= (1730 + 1401))) then
				return "flame_shock single_target 114";
			end
		end
		if ((v101.FrostShock:IsCastable() and v42) or ((4084 - (883 + 397)) <= (3375 - (563 + 27)))) then
			if (v25(v101.FrostShock, not v17:IsSpellInRange(v101.FrostShock)) or ((17884 - 13313) == (5401 - (1369 + 617)))) then
				return "frost_shock single_target 116";
			end
		end
	end
	local function v140()
		local v171 = 1487 - (85 + 1402);
		while true do
			if ((v171 == (2 + 1)) or ((11463 - 7022) > (5190 - (274 + 129)))) then
				if (((2137 - (12 + 205)) == (1753 + 167)) and v101.ImprovedFlametongueWeapon:IsAvailable() and v101.FlametongueWeapon:IsCastable() and v51 and (not v110 or (v111 < (2326466 - 1726466))) and v101.FlametongueWeapon:IsAvailable()) then
					if (v25(v101.FlametongueWeapon) or ((627 + 20) == (4861 - (27 + 357)))) then
						return "flametongue_weapon enchant";
					end
				end
				if (((4299 - (91 + 389)) == (4116 - (90 + 207))) and not v14:AffectingCombat() and v32 and v105.TargetIsValid()) then
					local v269 = 0 + 0;
					while true do
						if ((v269 == (861 - (706 + 155))) or ((3261 - (730 + 1065)) > (5923 - (1339 + 224)))) then
							v31 = v137();
							if (v31 or ((8 + 6) > (885 + 109))) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if (((596 - 195) <= (1577 - (268 + 575))) and (v171 == (1295 - (919 + 375)))) then
				if (v31 or ((5958 - 3791) >= (4397 - (180 + 791)))) then
					return v31;
				end
				if (((2569 - (323 + 1482)) < (5203 - (1177 + 741))) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v14:CanAttack(v17)) then
					if (((164 + 2335) == (9371 - 6872)) and v25(v101.AncestralSpirit, nil, true)) then
						return "ancestral_spirit";
					end
				end
				v171 = 1 + 1;
			end
			if (((0 - 0) == v171) or ((58 + 634) >= (5042 - (96 + 13)))) then
				if ((v74 and v101.EarthShield:IsCastable() and v14:BuffDown(v101.EarthShieldBuff) and ((v75 == "Earth Shield") or (v101.ElementalOrbit:IsAvailable() and v14:BuffUp(v101.LightningShield)))) or ((5075 - (962 + 959)) <= (5645 - 3385))) then
					if (v25(v101.EarthShield) or ((467 + 2170) > (4500 - (461 + 890)))) then
						return "earth_shield main 2";
					end
				elseif ((v74 and v101.LightningShield:IsCastable() and v14:BuffDown(v101.LightningShieldBuff) and ((v75 == "Lightning Shield") or (v101.ElementalOrbit:IsAvailable() and v14:BuffUp(v101.EarthShield)))) or ((2929 + 1063) < (9378 - 6971))) then
					if (v25(v101.LightningShield) or ((3145 - (19 + 224)) > (4405 + 454))) then
						return "lightning_shield main 2";
					end
				end
				v31 = v134();
				v171 = 199 - (37 + 161);
			end
			if (((606 + 1073) < (1690 + 2669)) and (v171 == (2 + 0))) then
				if (((1974 - (60 + 1)) < (5593 - (826 + 97))) and v101.AncestralSpirit:IsCastable() and v101.AncestralSpirit:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
					if (v25(v103.AncestralSpiritMouseover) or ((2757 + 89) < (3159 - 2280))) then
						return "ancestral_spirit mouseover";
					end
				end
				v110, v111 = v30();
				v171 = 5 - 2;
			end
		end
	end
	local function v141()
		v31 = v135();
		if (((5273 - (375 + 310)) == (6587 - (1864 + 135))) and v31) then
			return v31;
		end
		if (v86 or ((894 - 547) == (458 + 1607))) then
			local v207 = 0 + 0;
			while true do
				if (((0 - 0) == v207) or ((2442 - (314 + 817)) > (1530 + 1167))) then
					if (v81 or ((2931 - (32 + 182)) > (2805 + 990))) then
						local v272 = 0 - 0;
						while true do
							if (((65 - (39 + 26)) == v272) or ((1225 - (54 + 90)) < (589 - (45 + 153)))) then
								v31 = v105.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 25 + 15);
								if (v31 or ((673 - (457 + 95)) > (3416 + 22))) then
									return v31;
								end
								break;
							end
						end
					end
					if (((147 - 76) < (4710 - 2761)) and v82) then
						local v273 = 0 - 0;
						while true do
							if (((1907 + 2347) == (14671 - 10417)) and (v273 == (0 - 0))) then
								v31 = v105.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 778 - (485 + 263));
								if (((3903 - (575 + 132)) >= (3411 - (750 + 111))) and v31) then
									return v31;
								end
								break;
							end
						end
					end
					v207 = 1011 - (445 + 565);
				end
				if (((1977 + 479) < (600 + 3576)) and ((1 - 0) == v207)) then
					if (v83 or ((384 + 766) == (3762 - (189 + 121)))) then
						local v274 = 0 + 0;
						while true do
							if (((3222 - (634 + 713)) < (2796 - (493 + 45))) and (v274 == (968 - (493 + 475)))) then
								v31 = v105.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 8 + 22);
								if (((1957 - (158 + 626)) > (20 + 21)) and v31) then
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
		if (v87 or ((92 - 36) >= (714 + 2494))) then
			local v208 = 0 + 0;
			while true do
				if (((5404 - (1035 + 56)) > (4332 - (114 + 845))) and (v208 == (0 + 0))) then
					v31 = v105.HandleIncorporeal(v101.Hex, v103.HexMouseOver, 76 - 46, true);
					if (v31 or ((3778 + 715) == (3274 - (179 + 870)))) then
						return v31;
					end
					break;
				end
			end
		end
		if (((4353 - 1249) >= (3970 - (827 + 51))) and v18) then
			if (((9382 - 5834) > (1552 + 1546)) and v85) then
				local v253 = 473 - (95 + 378);
				while true do
					if ((v253 == (0 + 0)) or ((4607 - 1355) == (442 + 61))) then
						v31 = v133();
						if (((5744 - (334 + 677)) > (7734 - 5668)) and v31) then
							return v31;
						end
						break;
					end
				end
			end
		end
		if (((4605 - (1049 + 7)) >= (4000 - 3084)) and v101.GreaterPurge:IsAvailable() and v98 and v101.GreaterPurge:IsReady() and v36 and v84 and not v14:IsCasting() and not v14:IsChanneling() and v105.UnitHasMagicBuff(v17)) then
			if (v25(v101.GreaterPurge, not v17:IsSpellInRange(v101.GreaterPurge)) or ((4117 - 1928) <= (77 + 168))) then
				return "greater_purge damage";
			end
		end
		if ((v101.Purge:IsReady() and v98 and v36 and v84 and not v14:IsCasting() and not v14:IsChanneling() and v105.UnitHasMagicBuff(v17)) or ((3723 - 2334) > (7863 - 3938))) then
			if (((1857 + 2312) >= (4501 - (1004 + 416))) and v25(v101.Purge, not v17:IsSpellInRange(v101.Purge))) then
				return "purge damage";
			end
		end
		if (((2306 - (1621 + 336)) <= (2833 - (337 + 1602))) and v105.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
			local v209 = 1517 - (1014 + 503);
			local v210;
			while true do
				if (((1746 - (446 + 569)) <= (125 + 2853)) and (v209 == (2 - 1))) then
					if ((v101.NaturesSwiftness:IsCastable() and v47) or ((300 + 592) > (8082 - 4190))) then
						if (v25(v101.NaturesSwiftness) or ((91 + 4375) == (1405 - (223 + 282)))) then
							return "natures_swiftness main 12";
						end
					end
					v210 = v105.HandleDPSPotion(v14:BuffUp(v101.AscendanceBuff));
					v209 = 1 + 1;
				end
				if ((v209 == (2 - 0)) or ((3039 - 955) >= (3558 - (623 + 47)))) then
					if (((524 - (32 + 13)) < (1045 + 818)) and v210) then
						return v210;
					end
					if ((v33 and (v114 > (2 + 0)) and (v115 > (1803 - (1070 + 731)))) or ((2320 + 108) >= (5442 - (1257 + 147)))) then
						local v275 = 0 + 0;
						while true do
							if ((v275 == (1 - 0)) or ((3011 - (98 + 35)) > (1216 + 1681))) then
								if (v25(v101.Pool) or ((8743 - 6274) > (12370 - 8694))) then
									return "Pool for Aoe()";
								end
								break;
							end
							if (((218 + 15) < (429 + 58)) and ((0 + 0) == v275)) then
								v31 = v138();
								if (((3030 - (395 + 162)) >= (177 + 24)) and v31) then
									return v31;
								end
								v275 = 1942 - (816 + 1125);
							end
						end
					end
					v209 = 3 - 0;
				end
				if (((5268 - (701 + 447)) >= (204 - 71)) and ((4 - 1) == v209)) then
					if (((4421 - (391 + 950)) >= (5351 - 3365)) and true) then
						local v276 = 0 - 0;
						while true do
							if ((v276 == (0 - 0)) or ((1010 + 429) > (2059 + 1479))) then
								v31 = v139();
								if (v31 or ((1531 - 1112) < (1529 - (251 + 1271)))) then
									return v31;
								end
								v276 = 1 + 0;
							end
							if (((7550 - 4730) == (7061 - 4241)) and (v276 == (1 - 0))) then
								if (v25(v101.Pool) or ((5621 - (1147 + 112)) <= (882 + 2645))) then
									return "Pool for SingleTarget()";
								end
								break;
							end
						end
					end
					break;
				end
				if (((5306 - 2693) <= (696 + 1984)) and (v209 == (697 - (335 + 362)))) then
					if (((v91 < v109) and v58 and ((v64 and v34) or not v64)) or ((1389 + 93) >= (6454 - 2166))) then
						if ((v101.BloodFury:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (136 - 86)))) or ((9148 - 6686) > (21549 - 17123))) then
							if (((13549 - 8775) == (5340 - (237 + 329))) and v25(v101.BloodFury)) then
								return "blood_fury main 2";
							end
						end
						if (((2026 - 1460) <= (633 + 327)) and v101.Berserking:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff))) then
							if (v25(v101.Berserking) or ((1593 + 1317) <= (3054 - (408 + 716)))) then
								return "berserking main 4";
							end
						end
						if ((v101.Fireblood:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (189 - 139)))) or ((840 - (344 + 477)) > (77 + 375))) then
							if (v25(v101.Fireblood) or ((2668 - (1188 + 573)) > (8259 - 5107))) then
								return "fireblood main 6";
							end
						end
						if ((v101.AncestralCall:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (49 + 1)))) or ((8126 - 5621) > (6909 - 2439))) then
							if (v25(v101.AncestralCall) or ((9177 - 5466) > (5591 - (508 + 1021)))) then
								return "ancestral_call main 8";
							end
						end
						if (((395 + 25) == (1586 - (228 + 938))) and v101.BagofTricks:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff))) then
							if (v25(v101.BagofTricks) or ((718 - (332 + 353)) >= (4256 - 762))) then
								return "bag_of_tricks main 10";
							end
						end
					end
					if ((v91 < v109) or ((3317 - 2050) == (4495 + 249))) then
						if (((1218 + 1210) < (15108 - 11330)) and v57 and ((v34 and v63) or not v63)) then
							local v281 = 423 - (18 + 405);
							while true do
								if ((v281 == (0 + 0)) or ((1489 + 1457) <= (2431 - 835))) then
									v31 = v136();
									if (((5411 - (194 + 784)) > (4897 - (694 + 1076))) and v31) then
										return v31;
									end
									break;
								end
							end
						end
					end
					v209 = 1905 - (122 + 1782);
				end
			end
		end
	end
	local function v142()
		local v172 = 0 + 0;
		while true do
			if (((4009 + 291) >= (2460 + 273)) and (v172 == (0 + 0))) then
				v37 = EpicSettings.Settings['useChainlightning'];
				v38 = EpicSettings.Settings['useEarthquake'];
				v39 = EpicSettings.Settings['useEarthShock'];
				v40 = EpicSettings.Settings['useElementalBlast'];
				v172 = 2 - 1;
			end
			if (((4474 + 355) == (6799 - (214 + 1756))) and ((9 - 7) == v172)) then
				v45 = EpicSettings.Settings['useLavaBurst'];
				v46 = EpicSettings.Settings['useLightningBolt'];
				v47 = EpicSettings.Settings['useNaturesSwiftness'];
				v48 = EpicSettings.Settings['usePrimordialWave'];
				v172 = 1 + 2;
			end
			if (((93 + 1590) <= (5311 - (217 + 368))) and (v172 == (18 - 12))) then
				v65 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v66 = EpicSettings.Settings['stormkeeperWithMiniCD'];
				break;
			end
			if (((3184 + 1651) >= (2722 + 947)) and (v172 == (1 + 0))) then
				v41 = EpicSettings.Settings['useFlameShock'];
				v42 = EpicSettings.Settings['useFrostShock'];
				v43 = EpicSettings.Settings['useIceFury'];
				v44 = EpicSettings.Settings['useLavaBeam'];
				v172 = 891 - (844 + 45);
			end
			if (((3135 - (242 + 42)) > (3720 - 1861)) and (v172 == (11 - 6))) then
				v59 = EpicSettings.Settings['ascendanceWithCD'];
				v62 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
				v60 = EpicSettings.Settings['fireElementalWithCD'];
				v61 = EpicSettings.Settings['stormElementalWithCD'];
				v172 = 1206 - (132 + 1068);
			end
			if (((6143 - 2295) > (3946 - (214 + 1409))) and (v172 == (4 + 0))) then
				v53 = EpicSettings.Settings['useAscendance'];
				v55 = EpicSettings.Settings['useLiquidMagmaTotem'];
				v54 = EpicSettings.Settings['useFireElemental'];
				v56 = EpicSettings.Settings['useStormElemental'];
				v172 = 1639 - (497 + 1137);
			end
			if (((3776 - (9 + 931)) > (758 - (181 + 108))) and (v172 == (2 + 1))) then
				v49 = EpicSettings.Settings['useStormkeeper'];
				v50 = EpicSettings.Settings['useTotemicRecall'];
				v51 = EpicSettings.Settings['useWeaponEnchant'];
				v92 = EpicSettings.Settings['useWeapon'];
				v172 = 9 - 5;
			end
		end
	end
	local function v143()
		local v173 = 0 - 0;
		while true do
			if ((v173 == (2 + 4)) or ((1307 + 789) <= (1016 - (296 + 180)))) then
				v81 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v82 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v83 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if (((1408 - (1183 + 220)) == v173) or ((4448 - (1037 + 228)) < (4281 - 1636))) then
				v99 = EpicSettings.Settings['healOOC'];
				v100 = EpicSettings.Settings['healOOCHP'] or (0 - 0);
				v98 = EpicSettings.Settings['usePurgeTarget'];
				v173 = 20 - 14;
			end
			if (((3964 - (527 + 207)) <= (4287 - (187 + 340))) and ((1874 - (1298 + 572)) == v173)) then
				v67 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
				v74 = EpicSettings.Settings['autoShield'];
				v75 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v173 = 12 - 7;
			end
			if (((3998 - (144 + 26)) == (9538 - 5710)) and (v173 == (6 - 3))) then
				v79 = EpicSettings.Settings['healingStreamTotemHP'] or (0 + 0);
				v80 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 - 0);
				v52 = EpicSettings.Settings['earthquakeSetting'] or "";
				v173 = 9 - 5;
			end
			if (((2685 - 2131) == (282 + 272)) and (v173 == (1 - 0))) then
				v71 = EpicSettings.Settings['useAncestralGuidance'];
				v72 = EpicSettings.Settings['useAstralShift'];
				v73 = EpicSettings.Settings['useHealingStreamTotem'];
				v173 = 2 + 0;
			end
			if ((v173 == (1 + 1)) or ((2765 - (5 + 197)) == (858 - (339 + 347)))) then
				v76 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 - 0);
				v77 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 - 0);
				v78 = EpicSettings.Settings['astralShiftHP'] or (376 - (365 + 11));
				v173 = 3 + 0;
			end
			if (((14957 - 11068) >= (307 - 176)) and (v173 == (924 - (837 + 87)))) then
				v68 = EpicSettings.Settings['useWindShear'];
				v69 = EpicSettings.Settings['useCapacitorTotem'];
				v70 = EpicSettings.Settings['useThunderstorm'];
				v173 = 1 - 0;
			end
		end
	end
	local function v144()
		v91 = EpicSettings.Settings['fightRemainsCheck'] or (1670 - (837 + 833));
		v88 = EpicSettings.Settings['InterruptWithStun'];
		v89 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v90 = EpicSettings.Settings['InterruptThreshold'];
		v85 = EpicSettings.Settings['DispelDebuffs'];
		v84 = EpicSettings.Settings['DispelBuffs'];
		v57 = EpicSettings.Settings['useTrinkets'];
		v58 = EpicSettings.Settings['useRacials'];
		v63 = EpicSettings.Settings['trinketsWithCD'];
		v64 = EpicSettings.Settings['racialsWithCD'];
		v94 = EpicSettings.Settings['useHealthstone'];
		v93 = EpicSettings.Settings['useHealingPotion'];
		v96 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v95 = EpicSettings.Settings['healingPotionHP'] or (1387 - (356 + 1031));
		v97 = EpicSettings.Settings['HealingPotionName'] or "";
		v86 = EpicSettings.Settings['handleAfflicted'];
		v87 = EpicSettings.Settings['HandleIncorporeal'];
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
		if (v14:IsDeadOrGhost() or ((224 + 268) == (6224 - (73 + 1573)))) then
			return v31;
		end
		v112 = v14:GetEnemiesInRange(1428 - (1307 + 81));
		v113 = v17:GetEnemiesInSplashRange(239 - (7 + 227));
		if (v33 or ((6753 - 2641) < (1982 - (90 + 76)))) then
			local v211 = 0 - 0;
			while true do
				if (((2218 + 2307) >= (1010 + 213)) and (v211 == (0 + 0))) then
					v114 = #v112;
					v115 = v28(v17:GetEnemiesInSplashRangeCount(19 - 14), v114);
					break;
				end
			end
		else
			local v212 = 260 - (197 + 63);
			while true do
				if (((231 + 859) <= (1144 + 3683)) and ((0 + 0) == v212)) then
					v114 = 1 + 0;
					v115 = 1 - 0;
					break;
				end
			end
		end
		if ((v36 and v85) or ((1608 - (618 + 751)) > (1007 + 338))) then
			local v213 = 1910 - (206 + 1704);
			while true do
				if ((v213 == (0 - 0)) or ((7406 - 3696) >= (1631 + 2107))) then
					if ((v14:AffectingCombat() and v101.CleanseSpirit:IsAvailable()) or ((5113 - (155 + 1120)) < (3567 - (396 + 1110)))) then
						local v277 = v85 and v101.CleanseSpirit:IsReady() and v36;
						v31 = v105.FocusUnit(v277, v103, 45 - 25, nil, 9 + 16);
						if (v31 or ((521 + 169) > (1004 + 168))) then
							return v31;
						end
					end
					if (v101.CleanseSpirit:IsAvailable() or ((2568 - (230 + 746)) > (3200 - (473 + 128)))) then
						if (((3622 - (39 + 9)) <= (4663 - (38 + 228))) and v15 and v15:Exists() and v15:IsAPlayer() and v105.UnitHasCurseDebuff(v15)) then
							if (((5694 - 2559) > (1803 - (106 + 367))) and v101.CleanseSpirit:IsReady()) then
								if (v25(v103.CleanseSpiritMouseover) or ((345 + 3555) <= (5503 - (354 + 1508)))) then
									return "cleanse_spirit mouseover";
								end
							end
						end
					end
					break;
				end
			end
		end
		if (((5532 - 3808) == (1260 + 464)) and (v105.TargetIsValid() or v14:AffectingCombat())) then
			v108 = v10.BossFightRemains();
			v109 = v108;
			if (((267 + 188) <= (1723 - 441)) and (v109 == (12355 - (334 + 910)))) then
				v109 = v10.FightRemains(v112, false);
			end
		end
		if (((5501 - (92 + 803)) < (2687 + 2189)) and not v14:IsChanneling() and not v14:IsCasting()) then
			local v214 = 1181 - (1035 + 146);
			while true do
				if ((v214 == (616 - (230 + 386))) or ((839 + 603) > (4150 - (353 + 1157)))) then
					if (((1250 - (53 + 1061)) < (5303 - (1568 + 67))) and v86) then
						local v278 = 0 + 0;
						while true do
							if ((v278 == (1 + 0)) or ((4516 - 2732) > (14067 - 9286))) then
								if (((11559 - 6974) > (3112 + 186)) and v83) then
									local v293 = 1212 - (615 + 597);
									while true do
										if ((v293 == (0 + 0)) or ((2488 - 824) > (1397 + 301))) then
											v31 = v105.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 1 + 29);
											if (v31 or ((1886 + 1541) < (4748 - (1056 + 843)))) then
												return v31;
											end
											break;
										end
									end
								end
								break;
							end
							if (((7884 - 4268) <= (7367 - 2938)) and (v278 == (0 - 0))) then
								if (((2332 + 1656) >= (2042 - (286 + 1690))) and v81) then
									local v294 = 911 - (98 + 813);
									while true do
										if ((v294 == (0 + 0)) or ((2090 - 1228) > (2634 + 2010))) then
											v31 = v105.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 547 - (263 + 244));
											if (((967 + 254) == (2908 - (1502 + 185))) and v31) then
												return v31;
											end
											break;
										end
									end
								end
								if (v82 or ((9 + 36) > (6213 - 4942))) then
									v31 = v105.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 79 - 49);
									if (((5404 - (629 + 898)) > (4166 - 2636)) and v31) then
										return v31;
									end
								end
								v278 = 2 - 1;
							end
						end
					end
					if (v14:AffectingCombat() or ((5163 - (12 + 353)) == (3166 - (1680 + 231)))) then
						if ((v34 and v92 and (v102.Dreambinder:IsEquippedAndReady() or v102.Iridal:IsEquippedAndReady())) or ((162 + 2379) > (1752 + 1108))) then
							if (v25(v103.UseWeapon, nil) or ((4051 - (212 + 937)) > (2418 + 1211))) then
								return "Using Weapon Macro";
							end
						end
						v31 = v141();
						if (((1489 - (111 + 951)) < (705 + 2763)) and v31) then
							return v31;
						end
					else
						v31 = v140();
						if (((4217 - (18 + 9)) >= (562 + 2242)) and v31) then
							return v31;
						end
					end
					break;
				end
			end
		end
	end
	local function v146()
		local v192 = 534 - (31 + 503);
		while true do
			if (((3718 - (595 + 1037)) == (3530 - (189 + 1255))) and (v192 == (1 + 0))) then
				v22.Print("Elemental Shaman by Epic. Supported by xKaneto.");
				break;
			end
			if (((6419 - 2271) > (4012 - (1170 + 109))) and (v192 == (1817 - (348 + 1469)))) then
				v101.FlameShockDebuff:RegisterAuraTracking();
				v107();
				v192 = 1290 - (1115 + 174);
			end
		end
	end
	v22.SetAPL(638 - 376, v145, v146);
end;
return v0["Epix_Shaman_Elemental.lua"]();

