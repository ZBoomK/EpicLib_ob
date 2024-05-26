local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((1205 + 2531) <= (16424 - 11684)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((7042 - 3652) <= (176 + 2884))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if ((v5 == (1 + 0)) or ((2939 - 1940) > (2710 - (12 + 5)))) then
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
	local v101;
	local v102 = v19.Shaman.Elemental;
	local v103 = v21.Shaman.Elemental;
	local v104 = v24.Shaman.Elemental;
	local v105 = {};
	local v106 = v22.Commons.Everyone;
	local v107 = v22.Commons.Shaman;
	local function v108()
		if (((1798 - 1335) < (1282 - 681)) and v102.CleanseSpirit:IsAvailable()) then
			v106.DispellableDebuffs = v106.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v108();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v10:RegisterForEvent(function()
		local v148 = 0 - 0;
		while true do
			if ((v148 == (0 - 0)) or ((444 + 1739) < (2660 - (1656 + 317)))) then
				v102.PrimordialWave:RegisterInFlightEffect(291533 + 35629);
				v102.PrimordialWave:RegisterInFlight();
				v148 = 1 + 0;
			end
			if (((12095 - 7546) == (22388 - 17839)) and ((355 - (5 + 349)) == v148)) then
				v102.LavaBurst:RegisterInFlight();
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v102.PrimordialWave:RegisterInFlightEffect(1553969 - 1226807);
	v102.PrimordialWave:RegisterInFlight();
	v102.LavaBurst:RegisterInFlight();
	local v109 = 12382 - (266 + 1005);
	local v110 = 7322 + 3789;
	local v111, v112;
	local v113, v114;
	local v115 = 0 - 0;
	local v116 = 0 - 0;
	local v117 = 1696 - (561 + 1135);
	local v118 = 0 - 0;
	local v119 = 0 - 0;
	local function v120()
		return (1106 - (507 + 559)) - (v29() - v117);
	end
	v10:RegisterForSelfCombatEvent(function(...)
		local v149, v150, v150, v150, v151 = select(20 - 12, ...);
		if (((14448 - 9776) == (5060 - (212 + 176))) and (v149 == v14:GUID()) and (v151 == (192539 - (250 + 655)))) then
			v118 = v29();
			C_Timer.After(0.1 - 0, function()
				if ((v118 ~= v119) or ((6409 - 2741) < (618 - 223))) then
					v117 = v118;
				end
			end);
		end
	end, "SPELL_AURA_APPLIED");
	local function v121(v152)
		return (v152:DebuffRefreshable(v102.FlameShockDebuff));
	end
	local function v122(v153)
		return v153:DebuffRefreshable(v102.FlameShockDebuff) and (v153:DebuffRemains(v102.FlameShockDebuff) < (v153:TimeToDie() - (1961 - (1869 + 87))));
	end
	local function v123(v154)
		return v154:DebuffRefreshable(v102.FlameShockDebuff) and (v154:DebuffRemains(v102.FlameShockDebuff) < (v154:TimeToDie() - (17 - 12))) and (v154:DebuffRemains(v102.FlameShockDebuff) > (1901 - (484 + 1417)));
	end
	local function v124(v155)
		return (v155:DebuffRemains(v102.FlameShockDebuff));
	end
	local function v125(v156)
		return v156:DebuffRemains(v102.FlameShockDebuff) > (4 - 2);
	end
	local function v126(v157)
		return (v157:DebuffRemains(v102.LightningRodDebuff));
	end
	local function v127()
		local v158 = 0 - 0;
		local v159;
		while true do
			if ((v158 == (773 - (48 + 725))) or ((6805 - 2639) == (1220 - 765))) then
				v159 = v14:Maelstrom();
				if (not v14:IsCasting() or ((2586 + 1863) == (7116 - 4453))) then
					return v159;
				elseif (v14:IsCasting(v102.ElementalBlast) or ((1197 + 3080) < (872 + 2117))) then
					return v159 - (928 - (152 + 701));
				elseif (v14:IsCasting(v102.Icefury) or ((2181 - (430 + 881)) >= (1589 + 2560))) then
					return v159 + (920 - (557 + 338));
				elseif (((654 + 1558) < (8969 - 5786)) and v14:IsCasting(v102.LightningBolt)) then
					return v159 + (35 - 25);
				elseif (((12343 - 7697) > (6447 - 3455)) and v14:IsCasting(v102.LavaBurst)) then
					return v159 + (813 - (499 + 302));
				elseif (((2300 - (39 + 827)) < (8573 - 5467)) and v14:IsCasting(v102.ChainLightning)) then
					return v159 + ((8 - 4) * v116);
				else
					return v159;
				end
				break;
			end
		end
	end
	local function v128(v160)
		local v161 = 0 - 0;
		local v162;
		while true do
			if (((1206 - 420) < (259 + 2764)) and (v161 == (0 - 0))) then
				v162 = v160:IsReady();
				if ((v160 == v102.Stormkeeper) or (v160 == v102.ElementalBlast) or (v160 == v102.Icefury) or ((391 + 2051) < (116 - 42))) then
					local v246 = 104 - (103 + 1);
					local v247;
					while true do
						if (((5089 - (475 + 79)) == (9803 - 5268)) and (v246 == (0 - 0))) then
							v247 = v14:BuffUp(v102.SpiritwalkersGraceBuff) or not v14:IsMoving();
							return v162 and v247 and not v14:IsCasting(v160);
						end
					end
				elseif ((v160 == v102.LavaBeam) or ((389 + 2620) <= (1853 + 252))) then
					local v279 = 1503 - (1395 + 108);
					local v280;
					while true do
						if (((5325 - 3495) < (4873 - (7 + 1197))) and (v279 == (0 + 0))) then
							v280 = v14:BuffUp(v102.SpiritwalkersGraceBuff) or not v14:IsMoving();
							return v162 and v280;
						end
					end
				elseif ((v160 == v102.LightningBolt) or (v160 == v102.ChainLightning) or ((499 + 931) >= (3931 - (27 + 292)))) then
					local v282 = 0 - 0;
					local v283;
					while true do
						if (((3420 - 737) >= (10316 - 7856)) and (v282 == (0 - 0))) then
							v283 = v14:BuffUp(v102.SpiritwalkersGraceBuff) or v14:BuffUp(v102.StormkeeperBuff) or not v14:IsMoving();
							return v162 and v283;
						end
					end
				elseif ((v160 == v102.LavaBurst) or ((3435 - 1631) >= (3414 - (43 + 96)))) then
					local v295 = 0 - 0;
					local v296;
					local v297;
					local v298;
					local v299;
					while true do
						if ((v295 == (3 - 1)) or ((1176 + 241) > (1025 + 2604))) then
							return v162 and v296 and (v297 or v298 or v299);
						end
						if (((9477 - 4682) > (155 + 247)) and (v295 == (0 - 0))) then
							v296 = v14:BuffUp(v102.SpiritwalkersGraceBuff) or v14:BuffUp(v102.LavaSurgeBuff) or not v14:IsMoving();
							v297 = v14:BuffUp(v102.LavaSurgeBuff);
							v295 = 1 + 0;
						end
						if (((353 + 4460) > (5316 - (1414 + 337))) and (v295 == (1941 - (1642 + 298)))) then
							v298 = (v102.LavaBurst:Charges() >= (2 - 1)) and not v14:IsCasting(v102.LavaBurst);
							v299 = (v102.LavaBurst:Charges() == (5 - 3)) and v14:IsCasting(v102.LavaBurst);
							v295 = 5 - 3;
						end
					end
				elseif (((1288 + 2624) == (3044 + 868)) and (v160 == v102.PrimordialWave)) then
					return v162 and v34 and v14:BuffDown(v102.PrimordialWaveBuff) and v14:BuffDown(v102.LavaSurgeBuff);
				else
					return v162;
				end
				break;
			end
		end
	end
	local function v129()
		local v163 = 972 - (357 + 615);
		local v164;
		while true do
			if (((1981 + 840) <= (11836 - 7012)) and (v163 == (1 + 0))) then
				if (((3724 - 1986) <= (1756 + 439)) and not v14:IsCasting()) then
					return v164;
				elseif (((3 + 38) <= (1897 + 1121)) and v14:IsCasting(v107.LavaBurst)) then
					return true;
				elseif (((3446 - (384 + 917)) <= (4801 - (128 + 569))) and (v14:IsCasting(v107.ElementalBlast) or v14:IsCasting(v102.Icefury) or v14:IsCasting(v102.LightningBolt) or v14:IsCasting(v102.ChainLightning))) then
					return false;
				else
					return v164;
				end
				break;
			end
			if (((4232 - (1407 + 136)) < (6732 - (687 + 1200))) and (v163 == (1710 - (556 + 1154)))) then
				if (not v102.MasteroftheElements:IsAvailable() or ((8168 - 5846) > (2717 - (9 + 86)))) then
					return false;
				end
				v164 = v14:BuffUp(v102.MasteroftheElementsBuff);
				v163 = 422 - (275 + 146);
			end
		end
	end
	local function v130()
		local v165 = 0 + 0;
		local v166;
		while true do
			if ((v165 == (65 - (29 + 35))) or ((20094 - 15560) == (6218 - 4136))) then
				if (not v14:IsCasting() or ((6935 - 5364) > (1217 + 650))) then
					return v166 > (1012 - (53 + 959));
				elseif (((v166 == (409 - (312 + 96))) and (v14:IsCasting(v102.LightningBolt) or v14:IsCasting(v102.ChainLightning))) or ((4605 - 1951) >= (3281 - (147 + 138)))) then
					return false;
				else
					return v166 > (899 - (813 + 86));
				end
				break;
			end
			if (((3595 + 383) > (3898 - 1794)) and (v165 == (492 - (18 + 474)))) then
				if (((1011 + 1984) > (5029 - 3488)) and not v102.PoweroftheMaelstrom:IsAvailable()) then
					return false;
				end
				v166 = v14:BuffStack(v102.PoweroftheMaelstromBuff);
				v165 = 1087 - (860 + 226);
			end
		end
	end
	local function v131()
		local v167 = 303 - (121 + 182);
		local v168;
		while true do
			if (((400 + 2849) > (2193 - (988 + 252))) and (v167 == (0 + 0))) then
				if (not v102.Stormkeeper:IsAvailable() or ((1026 + 2247) > (6543 - (49 + 1921)))) then
					return false;
				end
				v168 = v14:BuffUp(v102.StormkeeperBuff);
				v167 = 891 - (223 + 667);
			end
			if ((v167 == (53 - (51 + 1))) or ((5423 - 2272) < (2749 - 1465))) then
				if (not v14:IsCasting() or ((2975 - (146 + 979)) == (432 + 1097))) then
					return v168;
				elseif (((1426 - (311 + 294)) < (5920 - 3797)) and v14:IsCasting(v102.Stormkeeper)) then
					return true;
				else
					return v168;
				end
				break;
			end
		end
	end
	local function v132()
		local v169 = 0 + 0;
		local v170;
		while true do
			if (((2345 - (496 + 947)) < (3683 - (1233 + 125))) and (v169 == (1 + 0))) then
				if (((770 + 88) <= (563 + 2399)) and not v14:IsCasting()) then
					return v170;
				elseif (v14:IsCasting(v102.Icefury) or ((5591 - (963 + 682)) < (1075 + 213))) then
					return true;
				else
					return v170;
				end
				break;
			end
			if ((v169 == (1504 - (504 + 1000))) or ((2184 + 1058) == (517 + 50))) then
				if (not v102.Icefury:IsAvailable() or ((80 + 767) >= (1862 - 599))) then
					return false;
				end
				v170 = v14:BuffUp(v102.IcefuryBuff);
				v169 = 1 + 0;
			end
		end
	end
	local v133 = 0 + 0;
	local function v134()
		if ((v102.CleanseSpirit:IsReady() and v36 and (v106.UnitHasDispellableDebuffByPlayer(v18) or v106.DispellableFriendlyUnit(202 - (156 + 26)) or v106.UnitHasCurseDebuff(v18))) or ((1298 + 955) == (2895 - 1044))) then
			local v189 = 164 - (149 + 15);
			while true do
				if ((v189 == (960 - (890 + 70))) or ((2204 - (39 + 78)) > (2854 - (14 + 468)))) then
					if ((v133 == (0 - 0)) or ((12423 - 7978) < (2141 + 2008))) then
						v133 = v29();
					end
					if (v106.Wait(301 + 199, v133) or ((387 + 1431) == (39 + 46))) then
						local v281 = 0 + 0;
						while true do
							if (((1205 - 575) < (2103 + 24)) and (v281 == (0 - 0))) then
								if (v25(v104.CleanseSpiritFocus) or ((49 + 1889) == (2565 - (12 + 39)))) then
									return "cleanse_spirit dispel";
								end
								v133 = 0 + 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v135()
		if (((13170 - 8915) >= (195 - 140)) and v100 and (v14:HealthPercentage() <= v101)) then
			if (((890 + 2109) > (609 + 547)) and v102.HealingSurge:IsReady()) then
				if (((5959 - 3609) > (770 + 385)) and v25(v102.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v136()
		local v171 = 0 - 0;
		while true do
			if (((5739 - (1596 + 114)) <= (12670 - 7817)) and (v171 == (715 - (164 + 549)))) then
				if ((v94 and (v14:HealthPercentage() <= v96)) or ((1954 - (1059 + 379)) > (4263 - 829))) then
					local v248 = 0 + 0;
					while true do
						if (((683 + 3363) >= (3425 - (145 + 247))) and (v248 == (0 + 0))) then
							if ((v98 == "Refreshing Healing Potion") or ((1257 + 1462) <= (4289 - 2842))) then
								if (v103.RefreshingHealingPotion:IsReady() or ((794 + 3340) < (3382 + 544))) then
									if (v25(v104.RefreshingHealingPotion) or ((266 - 102) >= (3505 - (254 + 466)))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v98 == "Dreamwalker's Healing Potion") or ((1085 - (544 + 16)) == (6702 - 4593))) then
								if (((661 - (294 + 334)) == (286 - (236 + 17))) and v103.DreamwalkersHealingPotion:IsReady()) then
									if (((1317 + 1737) <= (3126 + 889)) and v25(v104.RefreshingHealingPotion)) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							v248 = 3 - 2;
						end
						if (((8858 - 6987) < (1742 + 1640)) and (v248 == (1 + 0))) then
							if (((2087 - (413 + 381)) <= (92 + 2074)) and (v98 == "Potion of Withering Dreams")) then
								if (v103.PotionOfWitheringDreams:IsReady() or ((5484 - 2905) < (319 - 196))) then
									if (v25(v104.RefreshingHealingPotion) or ((2816 - (582 + 1388)) >= (4034 - 1666))) then
										return "potion of withering dreams defensive";
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v171 == (0 + 0)) or ((4376 - (326 + 38)) <= (9933 - 6575))) then
				if (((2132 - 638) <= (3625 - (47 + 573))) and v102.AstralShift:IsReady() and v73 and (v14:HealthPercentage() <= v79)) then
					if (v25(v102.AstralShift) or ((1097 + 2014) == (9063 - 6929))) then
						return "astral_shift defensive 1";
					end
				end
				if (((3822 - 1467) == (4019 - (1269 + 395))) and v102.AncestralGuidance:IsReady() and v72 and v106.AreUnitsBelowHealthPercentage(v77, v78, v102.HealingSurge)) then
					if (v25(v102.AncestralGuidance) or ((1080 - (76 + 416)) <= (875 - (319 + 124)))) then
						return "ancestral_guidance defensive 2";
					end
				end
				v171 = 2 - 1;
			end
			if (((5804 - (564 + 443)) >= (10782 - 6887)) and ((459 - (337 + 121)) == v171)) then
				if (((10480 - 6903) == (11915 - 8338)) and v102.HealingStreamTotem:IsReady() and v74 and v106.AreUnitsBelowHealthPercentage(v80, v81, v102.HealingSurge)) then
					if (((5705 - (1261 + 650)) > (1563 + 2130)) and v25(v102.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v103.Healthstone:IsReady() and v95 and (v14:HealthPercentage() <= v97)) or ((2031 - 756) == (5917 - (772 + 1045)))) then
					if (v25(v104.Healthstone) or ((225 + 1366) >= (3724 - (102 + 42)))) then
						return "healthstone defensive 3";
					end
				end
				v171 = 1846 - (1524 + 320);
			end
		end
	end
	local function v137()
		local v172 = 1270 - (1049 + 221);
		while true do
			if (((1139 - (18 + 138)) <= (4425 - 2617)) and (v172 == (1102 - (67 + 1035)))) then
				v31 = v106.HandleTopTrinket(v105, v34, 388 - (136 + 212), nil);
				if (v31 or ((9136 - 6986) <= (959 + 238))) then
					return v31;
				end
				v172 = 1 + 0;
			end
			if (((5373 - (240 + 1364)) >= (2255 - (1050 + 32))) and (v172 == (3 - 2))) then
				v31 = v106.HandleBottomTrinket(v105, v34, 24 + 16, nil);
				if (((2540 - (331 + 724)) == (120 + 1365)) and v31) then
					return v31;
				end
				break;
			end
		end
	end
	local function v138()
		if ((v128(v102.Stormkeeper) and (v102.Stormkeeper:CooldownRemains() == (644 - (269 + 375))) and not v14:BuffUp(v102.StormkeeperBuff) and v49 and ((v67 and v35) or not v67) and (v92 < v110)) or ((4040 - (267 + 458)) <= (866 + 1916))) then
			if (v25(v102.Stormkeeper) or ((1684 - 808) >= (3782 - (667 + 151)))) then
				return "stormkeeper precombat 2";
			end
		end
		if ((v128(v102.Icefury) and (v102.Icefury:CooldownRemains() == (1497 - (1410 + 87))) and v43) or ((4129 - (1504 + 393)) > (6749 - 4252))) then
			if (v25(v102.Icefury, not v17:IsSpellInRange(v102.Icefury)) or ((5474 - 3364) <= (1128 - (461 + 335)))) then
				return "icefury precombat 4";
			end
		end
		if (((472 + 3214) > (4933 - (1730 + 31))) and v128(v102.ElementalBlast) and v40) then
			if (v25(v102.ElementalBlast, not v17:IsSpellInRange(v102.ElementalBlast)) or ((6141 - (728 + 939)) < (2904 - 2084))) then
				return "elemental_blast precombat 6";
			end
		end
		if (((8679 - 4400) >= (6603 - 3721)) and v14:IsCasting(v102.ElementalBlast) and v48 and ((v66 and v35) or not v66) and v128(v102.PrimordialWave)) then
			if (v25(v102.PrimordialWave, not v17:IsSpellInRange(v102.PrimordialWave)) or ((3097 - (138 + 930)) >= (3218 + 303))) then
				return "primordial_wave precombat 8";
			end
		end
		if ((v14:IsCasting(v102.ElementalBlast) and v41 and not v102.PrimordialWave:IsAvailable() and v102.FlameShock:IsCastable()) or ((1593 + 444) >= (3979 + 663))) then
			if (((7023 - 5303) < (6224 - (459 + 1307))) and v25(v102.FlameShock, not v17:IsSpellInRange(v102.FlameShock))) then
				return "flameshock precombat 10";
			end
		end
		if ((v128(v102.LavaBurst) and v45 and not v14:IsCasting(v102.LavaBurst) and (not v102.ElementalBlast:IsAvailable() or (v102.ElementalBlast:IsAvailable() and not v128(v102.ElementalBlast)))) or ((2306 - (474 + 1396)) > (5275 - 2254))) then
			if (((669 + 44) <= (3 + 844)) and v25(v102.LavaBurst, not v17:IsSpellInRange(v102.LavaBurst))) then
				return "lavaburst precombat 12";
			end
		end
		if (((6169 - 4015) <= (511 + 3520)) and v14:IsCasting(v102.LavaBurst) and v41 and v102.FlameShock:IsReady()) then
			if (((15406 - 10791) == (20126 - 15511)) and v25(v102.FlameShock, not v17:IsSpellInRange(v102.FlameShock))) then
				return "flameshock precombat 14";
			end
		end
		if ((v14:IsCasting(v102.LavaBurst) and v48 and ((v66 and v35) or not v66) and v128(v102.PrimordialWave)) or ((4381 - (562 + 29)) == (427 + 73))) then
			if (((1508 - (374 + 1045)) < (175 + 46)) and v25(v102.PrimordialWave, not v17:IsSpellInRange(v102.PrimordialWave))) then
				return "primordial_wave precombat 16";
			end
		end
	end
	local function v139()
		local v173 = 0 - 0;
		while true do
			if (((2692 - (448 + 190)) >= (459 + 962)) and (v173 == (4 + 4))) then
				if (((451 + 241) < (11757 - 8699)) and v128(v102.LavaBeam) and v44 and (v116 >= (18 - 12)) and v14:BuffUp(v102.SurgeofPowerBuff) and (v14:BuffRemains(v102.AscendanceBuff) > v102.LavaBeam:CastTime())) then
					if (v25(v102.LavaBeam, not v17:IsSpellInRange(v102.LavaBeam)) or ((4748 - (1307 + 187)) == (6562 - 4907))) then
						return "lava_beam aoe 76";
					end
				end
				if ((v128(v102.ChainLightning) and v37 and (v116 >= (13 - 7)) and v14:BuffUp(v102.SurgeofPowerBuff)) or ((3973 - 2677) == (5593 - (232 + 451)))) then
					if (((3217 + 151) == (2976 + 392)) and v25(v102.ChainLightning, not v17:IsSpellInRange(v102.ChainLightning))) then
						return "chain_lightning aoe 78";
					end
				end
				if (((3207 - (510 + 54)) < (7686 - 3871)) and v128(v102.LavaBurst) and v14:BuffUp(v102.LavaSurgeBuff) and v102.DeeplyRootedElements:IsAvailable() and v14:BuffUp(v102.WindspeakersLavaResurgenceBuff)) then
					local v249 = 36 - (13 + 23);
					while true do
						if (((3728 - 1815) > (707 - 214)) and (v249 == (0 - 0))) then
							if (((5843 - (830 + 258)) > (12092 - 8664)) and v106.CastCycle(v102.LavaBurst, v114, v124, not v17:IsSpellInRange(v102.LavaBurst))) then
								return "lava_burst aoe 80";
							end
							if (((865 + 516) <= (2016 + 353)) and v25(v102.LavaBurst, not v17:IsSpellInRange(v102.LavaBurst))) then
								return "lava_burst aoe 80";
							end
							break;
						end
					end
				end
				if ((v128(v102.LavaBeam) and v44 and v129() and (v14:BuffRemains(v102.AscendanceBuff) > v102.LavaBeam:CastTime())) or ((6284 - (860 + 581)) == (15064 - 10980))) then
					if (((3706 + 963) > (604 - (237 + 4))) and v25(v102.LavaBeam, not v17:IsSpellInRange(v102.LavaBeam))) then
						return "lava_beam aoe 82";
					end
				end
				v173 = 20 - 11;
			end
			if ((v173 == (25 - 15)) or ((3558 - 1681) >= (2569 + 569))) then
				if (((2724 + 2018) >= (13689 - 10063)) and v128(v102.LavaBeam) and v44 and (v14:BuffRemains(v102.AscendanceBuff) > v102.LavaBeam:CastTime())) then
					if (v25(v102.LavaBeam, not v17:IsSpellInRange(v102.LavaBeam)) or ((1949 + 2591) == (499 + 417))) then
						return "lava_beam aoe 92";
					end
				end
				if ((v128(v102.ChainLightning) and v37) or ((2582 - (85 + 1341)) > (7414 - 3069))) then
					if (((6317 - 4080) < (4621 - (45 + 327))) and v25(v102.ChainLightning, not v17:IsSpellInRange(v102.ChainLightning))) then
						return "chain_lightning aoe 94";
					end
				end
				if ((v102.FlameShock:IsCastable() and v41 and v14:IsMoving() and v17:DebuffRefreshable(v102.FlameShockDebuff)) or ((5062 - 2379) < (525 - (444 + 58)))) then
					if (((303 + 394) <= (143 + 683)) and v25(v102.FlameShock, not v17:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock aoe 96";
					end
				end
				if (((541 + 564) <= (3407 - 2231)) and v102.FrostShock:IsCastable() and v42 and v14:IsMoving()) then
					if (((5111 - (64 + 1668)) <= (5785 - (1227 + 746))) and v25(v102.FrostShock, not v17:IsSpellInRange(v102.FrostShock))) then
						return "frost_shock aoe 98";
					end
				end
				break;
			end
			if ((v173 == (0 - 0)) or ((1462 - 674) >= (2110 - (415 + 79)))) then
				if (((48 + 1806) <= (3870 - (142 + 349))) and v102.FireElemental:IsReady() and v55 and ((v61 and v34) or not v61) and (v92 < v110)) then
					if (((1949 + 2600) == (6254 - 1705)) and v25(v102.FireElemental)) then
						return "fire_elemental aoe 2";
					end
				end
				if ((v102.StormElemental:IsReady() and v57 and ((v62 and v34) or not v62) and (v92 < v110)) or ((1502 + 1520) >= (2131 + 893))) then
					if (((13126 - 8306) > (4062 - (1710 + 154))) and v25(v102.StormElemental)) then
						return "storm_elemental aoe 4";
					end
				end
				if ((v128(v102.Stormkeeper) and not v131() and v49 and ((v67 and v35) or not v67) and (v92 < v110)) or ((1379 - (200 + 118)) >= (1938 + 2953))) then
					if (((2384 - 1020) <= (6634 - 2161)) and v25(v102.Stormkeeper)) then
						return "stormkeeper aoe 7";
					end
				end
				if ((v102.TotemicRecall:IsCastable() and (v102.LiquidMagmaTotem:CooldownRemains() > (40 + 5)) and v50) or ((3557 + 38) <= (2 + 1))) then
					if (v25(v102.TotemicRecall) or ((747 + 3925) == (8345 - 4493))) then
						return "totemic_recall aoe 8";
					end
				end
				v173 = 1251 - (363 + 887);
			end
			if (((2721 - 1162) == (7420 - 5861)) and (v173 == (2 + 7))) then
				if ((v128(v102.LavaBurst) and (v116 == (6 - 3)) and v102.MasteroftheElements:IsAvailable()) or ((1198 + 554) <= (2452 - (674 + 990)))) then
					local v250 = 0 + 0;
					while true do
						if ((v250 == (0 + 0)) or ((6193 - 2286) == (1232 - (507 + 548)))) then
							if (((4307 - (289 + 548)) > (2373 - (821 + 997))) and v106.CastCycle(v102.LavaBurst, v114, v124, not v17:IsSpellInRange(v102.LavaBurst))) then
								return "lava_burst aoe 84";
							end
							if (v25(v102.LavaBurst, not v17:IsSpellInRange(v102.LavaBurst)) or ((1227 - (195 + 60)) == (174 + 471))) then
								return "lava_burst aoe 84";
							end
							break;
						end
					end
				end
				if (((4683 - (251 + 1250)) >= (6196 - 4081)) and v128(v102.LavaBurst) and v14:BuffUp(v102.LavaSurgeBuff) and v102.DeeplyRootedElements:IsAvailable()) then
					local v251 = 0 + 0;
					while true do
						if (((4925 - (809 + 223)) < (6462 - 2033)) and ((0 - 0) == v251)) then
							if (v106.CastCycle(v102.LavaBurst, v114, v124, not v17:IsSpellInRange(v102.LavaBurst)) or ((9479 - 6612) < (1403 + 502))) then
								return "lava_burst aoe 86";
							end
							if (v25(v102.LavaBurst, not v17:IsSpellInRange(v102.LavaBurst)) or ((941 + 855) >= (4668 - (14 + 603)))) then
								return "lava_burst aoe 86";
							end
							break;
						end
					end
				end
				if (((1748 - (118 + 11)) <= (608 + 3148)) and v128(v102.Icefury) and (v102.Icefury:CooldownRemains() == (0 + 0)) and v43 and v102.ElectrifiedShocks:IsAvailable() and (v116 < (14 - 9))) then
					if (((1553 - (551 + 398)) == (382 + 222)) and v25(v102.Icefury, not v17:IsSpellInRange(v102.Icefury))) then
						return "icefury aoe 88";
					end
				end
				if ((v128(v102.FrostShock) and v42 and v14:BuffUp(v102.IcefuryBuff) and v102.ElectrifiedShocks:IsAvailable() and not v17:DebuffUp(v102.ElectrifiedShocksDebuff) and (v116 < (2 + 3)) and v102.UnrelentingCalamity:IsAvailable()) or ((3645 + 839) == (3347 - 2447))) then
					if (v25(v102.FrostShock, not v17:IsSpellInRange(v102.FrostShock)) or ((10273 - 5814) <= (361 + 752))) then
						return "frost_shock aoe 90";
					end
				end
				v173 = 39 - 29;
			end
			if (((1003 + 2629) > (3487 - (40 + 49))) and (v173 == (26 - 19))) then
				if (((4572 - (99 + 391)) <= (4068 + 849)) and v128(v102.LavaBeam) and v44 and (v131())) then
					if (((21241 - 16409) >= (3432 - 2046)) and v25(v102.LavaBeam, not v17:IsSpellInRange(v102.LavaBeam))) then
						return "lava_beam aoe 68";
					end
				end
				if (((134 + 3) == (360 - 223)) and v128(v102.ChainLightning) and v37 and (v131())) then
					if (v25(v102.ChainLightning, not v17:IsSpellInRange(v102.ChainLightning)) or ((3174 - (1032 + 572)) >= (4749 - (203 + 214)))) then
						return "chain_lightning aoe 70";
					end
				end
				if ((v128(v102.LavaBeam) and v44 and v130() and (v14:BuffRemains(v102.AscendanceBuff) > v102.LavaBeam:CastTime())) or ((5881 - (568 + 1249)) <= (1423 + 396))) then
					if (v25(v102.LavaBeam, not v17:IsSpellInRange(v102.LavaBeam)) or ((11975 - 6989) < (6079 - 4505))) then
						return "lava_beam aoe 72";
					end
				end
				if (((5732 - (913 + 393)) > (485 - 313)) and v128(v102.ChainLightning) and v37 and v130()) then
					if (((827 - 241) > (865 - (269 + 141))) and v25(v102.ChainLightning, not v17:IsSpellInRange(v102.ChainLightning))) then
						return "chain_lightning aoe 74";
					end
				end
				v173 = 17 - 9;
			end
			if (((2807 - (362 + 1619)) == (2451 - (950 + 675))) and (v173 == (2 + 3))) then
				if ((v128(v102.ElementalBlast) and v40 and v102.EchoesofGreatSundering:IsAvailable()) or ((5198 - (216 + 963)) > (5728 - (485 + 802)))) then
					local v252 = 559 - (432 + 127);
					while true do
						if (((3090 - (1065 + 8)) < (2367 + 1894)) and (v252 == (1601 - (635 + 966)))) then
							if (((3391 + 1325) > (122 - (5 + 37))) and v106.CastTargetIf(v102.ElementalBlast, v114, "min", v126, nil, not v17:IsSpellInRange(v102.ElementalBlast), nil, nil)) then
								return "elemental_blast aoe 52";
							end
							if (v25(v102.ElementalBlast, not v17:IsSpellInRange(v102.ElementalBlast)) or ((8722 - 5215) == (1362 + 1910))) then
								return "elemental_blast aoe 52";
							end
							break;
						end
					end
				end
				if ((v128(v102.ElementalBlast) and v40 and v102.EchoesofGreatSundering:IsAvailable()) or ((1386 - 510) >= (1439 + 1636))) then
					if (((9042 - 4690) > (9682 - 7128)) and v25(v102.ElementalBlast, not v17:IsSpellInRange(v102.ElementalBlast))) then
						return "elemental_blast aoe 54";
					end
				end
				if ((v128(v102.ElementalBlast) and v40 and (v116 == (5 - 2)) and not v102.EchoesofGreatSundering:IsAvailable()) or ((10534 - 6128) < (2907 + 1136))) then
					if (v25(v102.ElementalBlast, not v17:IsSpellInRange(v102.ElementalBlast)) or ((2418 - (318 + 211)) >= (16646 - 13263))) then
						return "elemental_blast aoe 56";
					end
				end
				if (((3479 - (963 + 624)) <= (1169 + 1565)) and v102.EarthShock:IsCastable() and v39 and v102.EchoesofGreatSundering:IsAvailable()) then
					local v253 = 846 - (518 + 328);
					while true do
						if (((4482 - 2559) < (3544 - 1326)) and (v253 == (317 - (301 + 16)))) then
							if (((6368 - 4195) > (1064 - 685)) and v106.CastTargetIf(v102.EarthShock, v114, "min", v126, nil, not v17:IsSpellInRange(v102.EarthShock), nil, nil)) then
								return "earth_shock aoe 58";
							end
							if (v25(v102.EarthShock, not v17:IsSpellInRange(v102.EarthShock)) or ((6760 - 4169) == (3088 + 321))) then
								return "earth_shock aoe 58";
							end
							break;
						end
					end
				end
				v173 = 4 + 2;
			end
			if (((9637 - 5123) > (2000 + 1324)) and (v173 == (1 + 0))) then
				if ((v102.LiquidMagmaTotem:IsReady() and v56 and ((v63 and v34) or not v63) and (v92 < v110) and (v68 == "cursor")) or ((661 - 453) >= (1559 + 3269))) then
					if (v25(v104.LiquidMagmaTotemCursor, not v17:IsInRange(1059 - (829 + 190))) or ((5647 - 4064) > (4513 - 946))) then
						return "liquid_magma_totem aoe cursor 10";
					end
				end
				if ((v102.LiquidMagmaTotem:IsReady() and v56 and ((v63 and v34) or not v63) and (v92 < v110) and (v68 == "player")) or ((1814 - 501) == (1971 - 1177))) then
					if (((753 + 2421) > (948 + 1954)) and v25(v104.LiquidMagmaTotemPlayer, not v17:IsInRange(121 - 81))) then
						return "liquid_magma_totem aoe player 11";
					end
				end
				if (((3888 + 232) <= (4873 - (520 + 93))) and v128(v102.PrimordialWave) and v14:BuffDown(v102.PrimordialWaveBuff) and v14:BuffUp(v102.SurgeofPowerBuff) and v14:BuffDown(v102.SplinteredElementsBuff)) then
					if (v106.CastTargetIf(v102.PrimordialWave, v114, "min", v124, nil, not v17:IsSpellInRange(v102.PrimordialWave), nil, nil) or ((1159 - (259 + 17)) > (276 + 4502))) then
						return "primordial_wave aoe 12";
					end
					if (v25(v102.PrimordialWave, not v17:IsSpellInRange(v102.PrimordialWave)) or ((1303 + 2317) >= (16558 - 11667))) then
						return "primordial_wave aoe 12";
					end
				end
				if (((4849 - (396 + 195)) > (2718 - 1781)) and v128(v102.PrimordialWave) and v14:BuffDown(v102.PrimordialWaveBuff) and v102.DeeplyRootedElements:IsAvailable() and not v102.SurgeofPower:IsAvailable() and v14:BuffDown(v102.SplinteredElementsBuff)) then
					local v254 = 1761 - (440 + 1321);
					while true do
						if ((v254 == (1829 - (1059 + 770))) or ((22514 - 17645) < (1451 - (424 + 121)))) then
							if (v106.CastTargetIf(v102.PrimordialWave, v114, "min", v124, nil, not v17:IsSpellInRange(v102.PrimordialWave), nil, nil) or ((224 + 1001) > (5575 - (641 + 706)))) then
								return "primordial_wave aoe 14";
							end
							if (((1319 + 2009) > (2678 - (249 + 191))) and v25(v102.PrimordialWave, not v17:IsSpellInRange(v102.PrimordialWave))) then
								return "primordial_wave aoe 14";
							end
							break;
						end
					end
				end
				v173 = 8 - 6;
			end
			if (((1715 + 2124) > (5414 - 4009)) and (v173 == (433 - (183 + 244)))) then
				if ((v102.EarthShock:IsCastable() and v39 and v102.EchoesofGreatSundering:IsAvailable()) or ((64 + 1229) <= (1237 - (434 + 296)))) then
					if (v25(v102.EarthShock, not v17:IsSpellInRange(v102.EarthShock)) or ((9241 - 6345) < (1317 - (169 + 343)))) then
						return "earth_shock aoe 60";
					end
				end
				if (((2031 + 285) == (4074 - 1758)) and v128(v102.Icefury) and (v102.Icefury:CooldownRemains() == (0 - 0)) and v43 and not v14:BuffUp(v102.AscendanceBuff) and v102.ElectrifiedShocks:IsAvailable() and ((v102.LightningRod:IsAvailable() and (v116 < (5 + 0)) and not v129()) or (v102.DeeplyRootedElements:IsAvailable() and (v116 == (8 - 5))))) then
					if (v25(v102.Icefury, not v17:IsSpellInRange(v102.Icefury)) or ((3693 - (651 + 472)) == (1159 + 374))) then
						return "icefury aoe 62";
					end
				end
				if ((v102.FrostShock:IsCastable() and v42 and not v14:BuffUp(v102.AscendanceBuff) and v14:BuffUp(v102.IcefuryBuff) and v102.ElectrifiedShocks:IsAvailable() and (not v17:DebuffUp(v102.ElectrifiedShocksDebuff) or (v14:BuffRemains(v102.IcefuryBuff) < v14:GCD())) and ((v102.LightningRod:IsAvailable() and (v116 < (3 + 2)) and not v129()) or (v102.DeeplyRootedElements:IsAvailable() and (v116 == (3 - 0))))) or ((1366 - (397 + 86)) == (2336 - (423 + 453)))) then
					if (v25(v102.FrostShock, not v17:IsSpellInRange(v102.FrostShock)) or ((470 + 4149) <= (132 + 867))) then
						return "frost_shock aoe 64";
					end
				end
				if ((v128(v102.LavaBurst) and v102.MasteroftheElements:IsAvailable() and not v129() and (v131() or ((v120() < (3 + 0)) and v14:HasTier(24 + 6, 2 + 0))) and (v127() < ((((1250 - (50 + 1140)) - ((5 + 0) * v102.EyeoftheStorm:TalentRank())) - ((2 + 0) * v26(v102.FlowofPower:IsAvailable()))) - (1 + 9))) and (v116 < (7 - 2))) or ((2468 + 942) > (4712 - (157 + 439)))) then
					if (v106.CastCycle(v102.LavaBurst, v114, v124, not v17:IsSpellInRange(v102.LavaBurst)) or ((1569 - 666) >= (10164 - 7105))) then
						return "lava_burst aoe 66";
					end
					if (v25(v102.LavaBurst, not v17:IsSpellInRange(v102.LavaBurst)) or ((11760 - 7784) < (3775 - (782 + 136)))) then
						return "lava_burst aoe 66";
					end
				end
				v173 = 862 - (112 + 743);
			end
			if (((6101 - (1026 + 145)) > (396 + 1911)) and (v173 == (722 - (493 + 225)))) then
				if ((v128(v102.LavaBurst) and v14:BuffUp(v102.LavaSurgeBuff) and v102.MasteroftheElements:IsAvailable() and not v129() and (v127() >= (((220 - 160) - ((4 + 1) * v102.EyeoftheStorm:TalentRank())) - ((5 - 3) * v26(v102.FlowofPower:IsAvailable())))) and ((not v102.EchoesofGreatSundering:IsAvailable() and not v102.LightningRod:IsAvailable()) or v14:BuffUp(v102.EchoesofGreatSunderingBuff)) and ((not v14:BuffUp(v102.AscendanceBuff) and (v116 > (1 + 2)) and v102.UnrelentingCalamity:IsAvailable()) or ((v116 > (8 - 5)) and not v102.UnrelentingCalamity:IsAvailable()) or (v116 == (1 + 2)))) or ((6759 - 2713) < (2886 - (210 + 1385)))) then
					local v255 = 1689 - (1201 + 488);
					while true do
						if ((v255 == (0 + 0)) or ((7542 - 3301) == (6357 - 2812))) then
							if (v106.CastCycle(v102.LavaBurst, v114, v124, not v17:IsSpellInRange(v102.LavaBurst)) or ((4633 - (352 + 233)) > (10227 - 5995))) then
								return "lava_burst aoe 44";
							end
							if (v25(v102.LavaBurst, not v17:IsSpellInRange(v102.LavaBurst)) or ((952 + 798) >= (9874 - 6401))) then
								return "lava_burst aoe 44";
							end
							break;
						end
					end
				end
				if (((3740 - (489 + 85)) == (4667 - (277 + 1224))) and v38 and v102.Earthquake:IsReady() and not v102.EchoesofGreatSundering:IsAvailable() and (v116 > (1496 - (663 + 830))) and ((v116 > (3 + 0)) or (v115 > (6 - 3)))) then
					local v256 = 875 - (461 + 414);
					while true do
						if (((296 + 1467) < (1490 + 2234)) and (v256 == (0 + 0))) then
							if (((57 + 0) <= (2973 - (172 + 78))) and (v53 == "cursor")) then
								if (v25(v104.EarthquakeCursor, not v17:IsInRange(64 - 24)) or ((762 + 1308) == (638 - 195))) then
									return "earthquake aoe 46";
								end
							end
							if ((v53 == "player") or ((738 + 1967) == (466 + 927))) then
								if (v25(v104.EarthquakePlayer, not v17:IsInRange(67 - 27)) or ((5791 - 1190) < (16 + 45))) then
									return "earthquake aoe 46";
								end
							end
							break;
						end
					end
				end
				if ((v38 and v102.Earthquake:IsReady() and not v102.EchoesofGreatSundering:IsAvailable() and not v102.ElementalBlast:IsAvailable() and (v116 == (2 + 1)) and ((v116 == (2 + 1)) or (v115 == (11 - 8)))) or ((3238 - 1848) >= (1455 + 3289))) then
					local v257 = 0 + 0;
					while true do
						if ((v257 == (447 - (133 + 314))) or ((349 + 1654) > (4047 - (199 + 14)))) then
							if ((v53 == "cursor") or ((558 - 402) > (5462 - (647 + 902)))) then
								if (((586 - 391) == (428 - (85 + 148))) and v25(v104.EarthquakeCursor, not v17:IsInRange(1329 - (426 + 863)))) then
									return "earthquake aoe 48";
								end
							end
							if (((14531 - 11426) >= (3450 - (873 + 781))) and (v53 == "player")) then
								if (((5862 - 1483) >= (5754 - 3623)) and v25(v104.EarthquakePlayer, not v17:IsInRange(17 + 23))) then
									return "earthquake aoe 48";
								end
							end
							break;
						end
					end
				end
				if (((14200 - 10356) >= (2927 - 884)) and v38 and v102.Earthquake:IsReady() and (v14:BuffUp(v102.EchoesofGreatSunderingBuff))) then
					local v258 = 0 - 0;
					while true do
						if ((v258 == (1947 - (414 + 1533))) or ((2803 + 429) <= (3286 - (443 + 112)))) then
							if (((6384 - (888 + 591)) == (12673 - 7768)) and (v53 == "cursor")) then
								if (v25(v104.EarthquakeCursor, not v17:IsInRange(3 + 37)) or ((15577 - 11441) >= (1722 + 2689))) then
									return "earthquake aoe 50";
								end
							end
							if ((v53 == "player") or ((1431 + 1527) == (430 + 3587))) then
								if (((2339 - 1111) >= (1505 - 692)) and v25(v104.EarthquakePlayer, not v17:IsInRange(1718 - (136 + 1542)))) then
									return "earthquake aoe 50";
								end
							end
							break;
						end
					end
				end
				v173 = 16 - 11;
			end
			if ((v173 == (2 + 0)) or ((5493 - 2038) > (2931 + 1119))) then
				if (((729 - (68 + 418)) == (658 - 415)) and v128(v102.PrimordialWave) and v14:BuffDown(v102.PrimordialWaveBuff) and v102.MasteroftheElements:IsAvailable() and not v102.LightningRod:IsAvailable()) then
					if (v106.CastTargetIf(v102.PrimordialWave, v114, "min", v124, nil, not v17:IsSpellInRange(v102.PrimordialWave), nil, nil) or ((491 - 220) > (1357 + 215))) then
						return "primordial_wave aoe 16";
					end
					if (((3831 - (770 + 322)) < (190 + 3103)) and v25(v102.PrimordialWave, not v17:IsSpellInRange(v102.PrimordialWave))) then
						return "primordial_wave aoe 16";
					end
				end
				if (v102.FlameShock:IsCastable() or ((1141 + 2801) < (155 + 979))) then
					local v259 = 0 - 0;
					while true do
						if (((1 - 0) == v259) or ((7334 - 4641) == (18292 - 13319))) then
							if (((1196 + 950) == (3215 - 1069)) and v102.MasteroftheElements:IsAvailable() and v41 and not v102.LightningRod:IsAvailable() and not v102.SurgeofPower:IsAvailable() and (v102.FlameShockDebuff:AuraActiveCount() < (3 + 3))) then
								if (v106.CastCycle(v102.FlameShock, v114, v122, not v17:IsSpellInRange(v102.FlameShock)) or ((1376 + 868) == (2527 + 697))) then
									return "flame_shock aoe 22";
								end
								if (v25(v102.FlameShock, not v17:IsSpellInRange(v102.FlameShock)) or ((18466 - 13562) <= (2661 - 745))) then
									return "flame_shock aoe 22";
								end
							end
							if (((31 + 59) <= (4905 - 3840)) and v102.DeeplyRootedElements:IsAvailable() and v41 and not v102.SurgeofPower:IsAvailable() and (v102.FlameShockDebuff:AuraActiveCount() < (19 - 13))) then
								local v284 = 0 + 0;
								while true do
									if (((23761 - 18959) == (5633 - (762 + 69))) and (v284 == (0 - 0))) then
										if (v106.CastCycle(v102.FlameShock, v114, v122, not v17:IsSpellInRange(v102.FlameShock)) or ((1965 + 315) <= (331 + 180))) then
											return "flame_shock aoe 24";
										end
										if (v25(v102.FlameShock, not v17:IsSpellInRange(v102.FlameShock)) or ((4053 - 2377) <= (146 + 317))) then
											return "flame_shock aoe 24";
										end
										break;
									end
								end
							end
							v259 = 1 + 1;
						end
						if (((15074 - 11205) == (4026 - (8 + 149))) and (v259 == (1322 - (1199 + 121)))) then
							if (((1959 - 801) <= (5898 - 3285)) and v14:BuffUp(v102.SurgeofPowerBuff) and v41 and (not v102.LightningRod:IsAvailable() or v102.SkybreakersFieryDemise:IsAvailable())) then
								local v285 = 0 + 0;
								while true do
									if ((v285 == (0 - 0)) or ((5485 - 3121) <= (1769 + 230))) then
										if (v106.CastCycle(v102.FlameShock, v114, v123, not v17:IsSpellInRange(v102.FlameShock)) or ((6729 - (518 + 1289)) < (332 - 138))) then
											return "flame_shock aoe 26";
										end
										if (v25(v102.FlameShock, not v17:IsSpellInRange(v102.FlameShock)) or ((278 + 1813) < (44 - 13))) then
											return "flame_shock aoe 26";
										end
										break;
									end
								end
							end
							if ((v102.MasteroftheElements:IsAvailable() and v41 and not v102.LightningRod:IsAvailable() and not v102.SurgeofPower:IsAvailable()) or ((1790 + 640) >= (5341 - (304 + 165)))) then
								local v286 = 0 + 0;
								while true do
									if ((v286 == (160 - (54 + 106))) or ((6739 - (1618 + 351)) < (1224 + 511))) then
										if (v106.CastCycle(v102.FlameShock, v114, v123, not v17:IsSpellInRange(v102.FlameShock)) or ((5455 - (10 + 1006)) <= (590 + 1760))) then
											return "flame_shock aoe 28";
										end
										if (v25(v102.FlameShock, not v17:IsSpellInRange(v102.FlameShock)) or ((628 + 3851) < (14478 - 10012))) then
											return "flame_shock aoe 28";
										end
										break;
									end
								end
							end
							v259 = 1036 - (912 + 121);
						end
						if (((1204 + 1343) > (2514 - (1140 + 149))) and (v259 == (2 + 1))) then
							if (((6225 - 1554) > (498 + 2176)) and v102.DeeplyRootedElements:IsAvailable() and v41 and not v102.SurgeofPower:IsAvailable()) then
								local v287 = 0 - 0;
								while true do
									if ((v287 == (0 - 0)) or ((638 + 3058) < (11545 - 8218))) then
										if (v106.CastCycle(v102.FlameShock, v114, v123, not v17:IsSpellInRange(v102.FlameShock)) or ((4728 - (165 + 21)) == (3081 - (61 + 50)))) then
											return "flame_shock aoe 30";
										end
										if (((104 + 148) <= (9423 - 7446)) and v25(v102.FlameShock, not v17:IsSpellInRange(v102.FlameShock))) then
											return "flame_shock aoe 30";
										end
										break;
									end
								end
							end
							break;
						end
						if (((0 - 0) == v259) or ((565 + 871) == (5235 - (1295 + 165)))) then
							if ((v14:BuffUp(v102.SurgeofPowerBuff) and v41 and v102.LightningRod:IsAvailable() and v102.WindspeakersLavaResurgence:IsAvailable() and (v17:DebuffRemains(v102.FlameShockDebuff) < (v17:TimeToDie() - (4 + 12))) and (v113 < (3 + 2))) or ((3015 - (819 + 578)) < (2332 - (331 + 1071)))) then
								if (((5466 - (588 + 155)) > (5435 - (546 + 736))) and v106.CastCycle(v102.FlameShock, v114, v122, not v17:IsSpellInRange(v102.FlameShock))) then
									return "flame_shock aoe 18";
								end
								if (v25(v102.FlameShock, not v17:IsSpellInRange(v102.FlameShock)) or ((5591 - (1834 + 103)) >= (2863 + 1791))) then
									return "flame_shock aoe 18";
								end
							end
							if (((2836 - 1885) <= (3262 - (1536 + 230))) and v14:BuffUp(v102.SurgeofPowerBuff) and v41 and (not v102.LightningRod:IsAvailable() or v102.SkybreakersFieryDemise:IsAvailable()) and (v102.FlameShockDebuff:AuraActiveCount() < (497 - (128 + 363)))) then
								local v288 = 0 + 0;
								while true do
									if (((0 - 0) == v288) or ((449 + 1287) == (945 - 374))) then
										if (v106.CastCycle(v102.FlameShock, v114, v122, not v17:IsSpellInRange(v102.FlameShock)) or ((2637 - 1741) > (11583 - 6814))) then
											return "flame_shock aoe 20";
										end
										if (v25(v102.FlameShock, not v17:IsSpellInRange(v102.FlameShock)) or ((718 + 327) <= (2029 - (615 + 394)))) then
											return "flame_shock aoe 20";
										end
										break;
									end
								end
							end
							v259 = 1 + 0;
						end
					end
				end
				if ((v102.Ascendance:IsCastable() and v54 and ((v60 and v34) or not v60) and (v92 < v110)) or ((1106 + 54) <= (999 - 671))) then
					if (((17272 - 13464) > (3575 - (59 + 592))) and v25(v102.Ascendance)) then
						return "ascendance aoe 32";
					end
				end
				if (((8614 - 4723) < (9057 - 4138)) and v128(v102.LavaBurst) and (v116 == (3 + 0)) and not v102.LightningRod:IsAvailable() and v14:HasTier(202 - (70 + 101), 9 - 5)) then
					local v260 = 0 + 0;
					while true do
						if ((v260 == (0 - 0)) or ((2475 - (123 + 118)) <= (364 + 1138))) then
							if (v106.CastCycle(v102.LavaBurst, v114, v124, not v17:IsSpellInRange(v102.LavaBurst)) or ((32 + 2480) < (1831 - (653 + 746)))) then
								return "lava_burst aoe 34";
							end
							if (v25(v102.LavaBurst, not v17:IsSpellInRange(v102.LavaBurst)) or ((3456 - 1608) == (1246 - 381))) then
								return "lava_burst aoe 34";
							end
							break;
						end
					end
				end
				v173 = 7 - 4;
			end
			if ((v173 == (2 + 1)) or ((2996 + 1686) <= (3967 + 574))) then
				if ((v38 and v102.Earthquake:IsReady() and v129() and (((v14:BuffStack(v102.MagmaChamberBuff) > (2 + 13)) and (v116 >= ((2 + 5) - v26(v102.UnrelentingCalamity:IsAvailable())))) or (v102.SplinteredElements:IsAvailable() and (v116 >= ((24 - 14) - v26(v102.UnrelentingCalamity:IsAvailable())))) or (v102.MountainsWillFall:IsAvailable() and (v116 >= (9 + 0)))) and not v102.LightningRod:IsAvailable() and v14:HasTier(57 - 26, 1238 - (885 + 349))) or ((2404 + 622) >= (11033 - 6987))) then
					local v261 = 0 - 0;
					while true do
						if (((2976 - (915 + 53)) > (1439 - (768 + 33))) and (v261 == (0 - 0))) then
							if (((3124 - 1349) <= (3561 - (287 + 41))) and (v53 == "cursor")) then
								if (v25(v104.EarthquakeCursor, not v17:IsInRange(887 - (638 + 209))) or ((2361 + 2182) == (3683 - (96 + 1590)))) then
									return "earthquake aoe 36";
								end
							end
							if ((v53 == "player") or ((4774 - (741 + 931)) < (358 + 370))) then
								if (((982 - 637) == (1611 - 1266)) and v25(v104.EarthquakePlayer, not v17:IsInRange(18 + 22))) then
									return "earthquake aoe 36";
								end
							end
							break;
						end
					end
				end
				if ((v128(v102.LavaBeam) and v44 and v131() and ((v14:BuffUp(v102.SurgeofPowerBuff) and (v116 >= (3 + 3))) or (v129() and ((v116 < (2 + 4)) or not v102.SurgeofPower:IsAvailable()))) and not v102.LightningRod:IsAvailable() and v14:HasTier(117 - 86, 2 + 2)) or ((1381 + 1446) < (1541 - 1163))) then
					if (v25(v102.LavaBeam, not v17:IsSpellInRange(v102.LavaBeam)) or ((3120 + 356) < (3091 - (64 + 430)))) then
						return "lava_beam aoe 38";
					end
				end
				if (((3055 + 24) < (5157 - (106 + 257))) and v128(v102.ChainLightning) and v37 and v131() and ((v14:BuffUp(v102.SurgeofPowerBuff) and (v116 >= (5 + 1))) or (v129() and ((v116 < (727 - (496 + 225))) or not v102.SurgeofPower:IsAvailable()))) and not v102.LightningRod:IsAvailable() and v14:HasTier(63 - 32, 19 - 15)) then
					if (((6512 - (256 + 1402)) > (6363 - (30 + 1869))) and v25(v102.ChainLightning, not v17:IsSpellInRange(v102.ChainLightning))) then
						return "chain_lightning aoe 40";
					end
				end
				if ((v128(v102.LavaBurst) and v14:BuffUp(v102.LavaSurgeBuff) and not v102.LightningRod:IsAvailable() and v14:HasTier(1400 - (213 + 1156), 192 - (96 + 92))) or ((837 + 4075) == (4657 - (142 + 757)))) then
					if (((103 + 23) <= (1423 + 2059)) and v106.CastCycle(v102.LavaBurst, v114, v124, not v17:IsSpellInRange(v102.LavaBurst))) then
						return "lava_burst aoe 42";
					end
					if (v25(v102.LavaBurst, not v17:IsSpellInRange(v102.LavaBurst)) or ((2453 - (32 + 47)) == (6351 - (1053 + 924)))) then
						return "lava_burst aoe 42";
					end
				end
				v173 = 4 + 0;
			end
		end
	end
	local function v140()
		local v174 = 0 - 0;
		while true do
			if (((3223 - (685 + 963)) == (3202 - 1627)) and (v174 == (7 - 2))) then
				if ((v128(v102.LavaBurst) and v102.LavaBurst:IsCastable() and v45 and v102.MasteroftheElements:IsAvailable() and not v129() and ((v127() >= (1784 - (541 + 1168))) or ((v127() >= (1647 - (645 + 952))) and not v102.ElementalBlast:IsAvailable())) and v102.SwellingMaelstrom:IsAvailable() and (v127() <= (968 - (669 + 169)))) or ((7738 - 5504) == (3159 - 1704))) then
					if (v25(v102.LavaBurst, not v17:IsSpellInRange(v102.LavaBurst)) or ((361 + 706) > (393 + 1386))) then
						return "lava_burst single_target 62";
					end
				end
				if (((2926 - (181 + 584)) >= (2329 - (665 + 730))) and v102.Earthquake:IsReady() and v38 and v14:BuffUp(v102.EchoesofGreatSunderingBuff) and ((not v102.ElementalBlast:IsAvailable() and (v115 < (5 - 3))) or (v115 > (1 - 0)))) then
					local v262 = 1350 - (540 + 810);
					while true do
						if (((6444 - 4832) == (4431 - 2819)) and (v262 == (0 + 0))) then
							if (((4555 - (166 + 37)) >= (4714 - (22 + 1859))) and (v53 == "cursor")) then
								if (v25(v104.EarthquakeCursor, not v17:IsInRange(1812 - (843 + 929))) or ((3484 - (30 + 232)) < (8776 - 5703))) then
									return "earthquake single_target 64";
								end
							end
							if (((1521 - (55 + 722)) <= (6314 - 3372)) and (v53 == "player")) then
								if (v25(v104.EarthquakePlayer, not v17:IsInRange(1715 - (78 + 1597))) or ((403 + 1430) <= (1203 + 119))) then
									return "earthquake single_target 64";
								end
							end
							break;
						end
					end
				end
				if ((v102.Earthquake:IsReady() and v38 and (v115 > (1 + 0)) and (v116 > (550 - (305 + 244))) and not v102.EchoesofGreatSundering:IsAvailable() and not v102.ElementalBlast:IsAvailable()) or ((3217 + 250) <= (1160 - (95 + 10)))) then
					if (((2508 + 1033) == (11221 - 7680)) and (v53 == "cursor")) then
						if (v25(v104.EarthquakeCursor, not v17:IsInRange(54 - 14)) or ((4319 - (592 + 170)) >= (13961 - 9958))) then
							return "earthquake single_target 66";
						end
					end
					if ((v53 == "player") or ((1649 - 992) >= (778 + 890))) then
						if (v25(v104.EarthquakePlayer, not v17:IsInRange(16 + 24)) or ((2479 - 1452) > (626 + 3232))) then
							return "earthquake single_target 66";
						end
					end
				end
				if ((v128(v102.ElementalBlast) and v102.ElementalBlast:IsCastable() and v40 and (not v102.MasteroftheElements:IsAvailable() or (v129() and v17:DebuffUp(v102.ElectrifiedShocksDebuff)))) or ((6771 - 3117) < (957 - (353 + 154)))) then
					if (((2516 - 625) < (6083 - 1630)) and v25(v102.ElementalBlast, not v17:IsSpellInRange(v102.ElementalBlast))) then
						return "elemental_blast single_target 68";
					end
				end
				if ((v128(v102.FrostShock) and v42 and v132() and v129() and (v127() < (76 + 34)) and (v102.LavaBurst:ChargesFractional() < (1 + 0)) and v102.ElectrifiedShocks:IsAvailable() and v102.ElementalBlast:IsAvailable() and not v102.LightningRod:IsAvailable()) or ((2072 + 1068) < (3075 - 946))) then
					if (v25(v102.FrostShock, not v17:IsSpellInRange(v102.FrostShock)) or ((4836 - 2281) < (2890 - 1650))) then
						return "frost_shock single_target 70";
					end
				end
				if ((v128(v102.ElementalBlast) and v102.ElementalBlast:IsCastable() and v40 and (v129() or v102.LightningRod:IsAvailable())) or ((4813 - (7 + 79)) <= (2209 + 2513))) then
					if (((921 - (24 + 157)) < (9852 - 4915)) and v25(v102.ElementalBlast, not v17:IsSpellInRange(v102.ElementalBlast))) then
						return "elemental_blast single_target 72";
					end
				end
				v174 = 12 - 6;
			end
			if (((1040 + 2618) >= (754 - 474)) and (v174 == (387 - (262 + 118)))) then
				if ((v128(v102.ElementalBlast) and v102.ElementalBlast:IsCastable() and v40) or ((1968 - (1038 + 45)) >= (2229 - 1198))) then
					if (((3784 - (19 + 211)) >= (638 - (88 + 25))) and v25(v102.ElementalBlast, not v17:IsSpellInRange(v102.ElementalBlast))) then
						return "elemental_blast single_target 86";
					end
				end
				if (((6145 - 3731) <= (1476 + 1496)) and v128(v102.ChainLightning) and v102.ChainLightning:IsCastable() and v37 and v130() and v102.UnrelentingCalamity:IsAvailable() and (v115 > (1 + 0)) and (v116 > (1037 - (1007 + 29)))) then
					if (((951 + 2578) <= (8648 - 5110)) and v25(v102.ChainLightning, not v17:IsSpellInRange(v102.ChainLightning))) then
						return "chain_lightning single_target 88";
					end
				end
				if ((v128(v102.LightningBolt) and v102.LightningBolt:IsCastable() and v46 and v130() and v102.UnrelentingCalamity:IsAvailable()) or ((13531 - 10670) < (103 + 355))) then
					if (((2528 - (340 + 471)) <= (11397 - 6872)) and v25(v102.LightningBolt, not v17:IsSpellInRange(v102.LightningBolt))) then
						return "lightning_bolt single_target 90";
					end
				end
				if ((v128(v102.Icefury) and v102.Icefury:IsCastable() and v43) or ((3767 - (276 + 313)) <= (3720 - 2196))) then
					if (((3922 + 332) > (157 + 213)) and v25(v102.Icefury, not v17:IsSpellInRange(v102.Icefury))) then
						return "icefury single_target 92";
					end
				end
				if ((v128(v102.ChainLightning) and v102.ChainLightning:IsCastable() and v37 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v102.LightningRodDebuff) and (v17:DebuffUp(v102.ElectrifiedShocksDebuff) or v130()) and (v115 > (1 + 0)) and (v116 > (1973 - (495 + 1477)))) or ((4895 - 3260) == (1165 + 612))) then
					if (v25(v102.ChainLightning, not v17:IsSpellInRange(v102.ChainLightning)) or ((3741 - (342 + 61)) >= (1747 + 2246))) then
						return "chain_lightning single_target 94";
					end
				end
				if (((1319 - (4 + 161)) <= (904 + 571)) and v128(v102.LightningBolt) and v102.LightningBolt:IsCastable() and v46 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v102.LightningRodDebuff) and (v17:DebuffUp(v102.ElectrifiedShocksDebuff) or v130())) then
					if (v25(v102.LightningBolt, not v17:IsSpellInRange(v102.LightningBolt)) or ((8192 - 5582) < (3232 - 2002))) then
						return "lightning_bolt single_target 96";
					end
				end
				v174 = 505 - (322 + 175);
			end
			if ((v174 == (564 - (173 + 390))) or ((358 + 1090) == (3397 - (203 + 111)))) then
				if (((195 + 2944) > (646 + 270)) and v102.FlameShock:IsCastable() and v41 and (v102.FlameShockDebuff:AuraActiveCount() == (0 - 0)) and (v115 > (1 + 0)) and (v116 > (707 - (57 + 649))) and (v102.DeeplyRootedElements:IsAvailable() or v102.Ascendance:IsAvailable() or v102.PrimordialWave:IsAvailable() or v102.SearingFlames:IsAvailable() or v102.MagmaChamber:IsAvailable()) and ((not v129() and (v131() or (v102.Stormkeeper:CooldownRemains() > (384 - (328 + 56))))) or not v102.SurgeofPower:IsAvailable())) then
					local v263 = 0 + 0;
					while true do
						if (((3466 - (433 + 79)) == (271 + 2683)) and (v263 == (0 + 0))) then
							if (((393 - 276) <= (13675 - 10783)) and v106.CastTargetIf(v102.FlameShock, v114, "min", v124, nil, not v17:IsSpellInRange(v102.FlameShock))) then
								return "flame_shock single_target 14";
							end
							if (v25(v102.FlameShock, not v17:IsSpellInRange(v102.FlameShock)) or ((331 + 122) > (4154 + 508))) then
								return "flame_shock single_target 14";
							end
							break;
						end
					end
				end
				if (((2356 - (562 + 474)) > (1387 - 792)) and v102.FlameShock:IsCastable() and v41 and (v115 > (1 - 0)) and (v116 > (906 - (76 + 829))) and (v102.DeeplyRootedElements:IsAvailable() or v102.Ascendance:IsAvailable() or v102.PrimordialWave:IsAvailable() or v102.SearingFlames:IsAvailable() or v102.MagmaChamber:IsAvailable()) and ((v14:BuffUp(v102.SurgeofPowerBuff) and not v131() and v102.Stormkeeper:CooldownDown()) or not v102.SurgeofPower:IsAvailable())) then
					if (v106.CastTargetIf(v102.FlameShock, v114, "min", v124, v121, not v17:IsSpellInRange(v102.FlameShock)) or ((4872 - (1506 + 167)) < (1108 - 518))) then
						return "flame_shock single_target 16";
					end
					if (v25(v102.FlameShock, not v17:IsSpellInRange(v102.FlameShock)) or ((5059 - (58 + 208)) < (18 + 12))) then
						return "flame_shock single_target 16";
					end
				end
				if ((v128(v102.Stormkeeper) and (v102.Stormkeeper:CooldownRemains() == (0 + 0)) and not v14:BuffUp(v102.StormkeeperBuff) and v49 and ((v67 and v35) or not v67) and (v92 < v110) and v14:BuffDown(v102.AscendanceBuff) and not v131() and (v127() >= (67 + 49)) and v102.ElementalBlast:IsAvailable() and v102.SurgeofPower:IsAvailable() and v102.SwellingMaelstrom:IsAvailable() and not v102.LavaSurge:IsAvailable() and not v102.EchooftheElements:IsAvailable() and not v102.PrimordialSurge:IsAvailable()) or ((6919 - 5223) <= (1396 - (258 + 79)))) then
					if (((298 + 2045) == (4928 - 2585)) and v25(v102.Stormkeeper)) then
						return "stormkeeper single_target 18";
					end
				end
				if ((v128(v102.Stormkeeper) and (v102.Stormkeeper:CooldownRemains() == (1470 - (1219 + 251))) and not v14:BuffUp(v102.StormkeeperBuff) and v49 and ((v67 and v35) or not v67) and (v92 < v110) and v14:BuffDown(v102.AscendanceBuff) and not v131() and v14:BuffUp(v102.SurgeofPowerBuff) and not v102.LavaSurge:IsAvailable() and not v102.EchooftheElements:IsAvailable() and not v102.PrimordialSurge:IsAvailable()) or ((2714 - (1231 + 440)) > (3649 - (34 + 24)))) then
					if (v25(v102.Stormkeeper) or ((1677 + 1213) >= (7613 - 3534))) then
						return "stormkeeper single_target 20";
					end
				end
				if (((1956 + 2518) <= (14487 - 9717)) and v128(v102.Stormkeeper) and (v102.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v102.StormkeeperBuff) and v49 and ((v67 and v35) or not v67) and (v92 < v110) and v14:BuffDown(v102.AscendanceBuff) and not v131() and (not v102.SurgeofPower:IsAvailable() or not v102.ElementalBlast:IsAvailable() or v102.LavaSurge:IsAvailable() or v102.EchooftheElements:IsAvailable() or v102.PrimordialSurge:IsAvailable())) then
					if (v25(v102.Stormkeeper) or ((12993 - 8051) == (13075 - 9172))) then
						return "stormkeeper single_target 22";
					end
				end
				if ((v102.Ascendance:IsCastable() and v54 and ((v60 and v34) or not v60) and (v92 < v110) and not v131()) or ((541 - 293) > (6434 - (877 + 712)))) then
					if (((940 + 629) == (2323 - (242 + 512))) and v25(v102.Ascendance)) then
						return "ascendance single_target 24";
					end
				end
				v174 = 3 - 1;
			end
			if ((v174 == (631 - (92 + 535))) or ((3879 + 1048) <= (6634 - 3413))) then
				if ((v102.FrostShock:IsCastable() and v42 and v132() and not v102.LavaSurge:IsAvailable() and not v102.EchooftheElements:IsAvailable() and not v102.ElementalBlast:IsAvailable() and (((v127() >= (3 + 33)) and (v127() < (181 - 131)) and (v102.LavaBurst:CooldownRemains() > v14:GCD())) or ((v127() >= (24 + 0)) and (v127() < (27 + 11)) and v102.LavaBurst:CooldownUp()))) or ((250 + 1530) > (5553 - 2766))) then
					if (v25(v102.FrostShock, not v17:IsSpellInRange(v102.FrostShock)) or ((5999 - 2062) <= (3015 - (1476 + 309)))) then
						return "frost_shock single_target 50";
					end
				end
				if ((v128(v102.LavaBurst) and v102.LavaBurst:IsCastable() and v45 and v14:BuffUp(v102.WindspeakersLavaResurgenceBuff) and (v102.EchooftheElements:IsAvailable() or v102.LavaSurge:IsAvailable() or v102.PrimordialSurge:IsAvailable() or ((v127() >= (1347 - (299 + 985))) and v102.MasteroftheElements:IsAvailable()) or ((v127() >= (10 + 28)) and v14:BuffUp(v102.EchoesofGreatSunderingBuff) and (v115 > (3 - 2)) and (v116 > (94 - (86 + 7)))) or not v102.ElementalBlast:IsAvailable())) or ((10776 - 8139) < (163 + 1543))) then
					if (v25(v102.LavaBurst, not v17:IsSpellInRange(v102.LavaBurst)) or ((3549 - (672 + 208)) <= (1033 + 1376))) then
						return "lava_burst single_target 52";
					end
				end
				if ((v128(v102.LavaBurst) and v102.LavaBurst:IsCastable() and v45 and v14:BuffUp(v102.LavaSurgeBuff) and (v102.EchooftheElements:IsAvailable() or v102.LavaSurge:IsAvailable() or v102.PrimordialSurge:IsAvailable() or not v102.MasteroftheElements:IsAvailable() or not v102.ElementalBlast:IsAvailable())) or ((1533 - (14 + 118)) > (5141 - (339 + 106)))) then
					if (v25(v102.LavaBurst, not v17:IsSpellInRange(v102.LavaBurst)) or ((2610 + 670) < (665 + 656))) then
						return "lava_burst single_target 54";
					end
				end
				if (((6322 - (440 + 955)) >= (2270 + 33)) and v128(v102.LavaBurst) and v102.LavaBurst:IsCastable() and v45 and v14:BuffUp(v102.AscendanceBuff) and (v14:HasTier(55 - 24, 2 + 2) or not v102.ElementalBlast:IsAvailable())) then
					local v264 = 0 - 0;
					while true do
						if (((2372 + 1090) >= (1385 - (260 + 93))) and (v264 == (0 + 0))) then
							if (v106.CastCycle(v102.LavaBurst, v114, v125, not v17:IsSpellInRange(v102.LavaBurst)) or ((2463 - 1386) >= (3631 - 1620))) then
								return "lava_burst single_target 56";
							end
							if (((3517 - (1181 + 793)) < (615 + 1800)) and v25(v102.LavaBurst, not v17:IsSpellInRange(v102.LavaBurst))) then
								return "lava_burst single_target 56";
							end
							break;
						end
					end
				end
				if ((v128(v102.LavaBurst) and v102.LavaBurst:IsCastable() and v45 and v14:BuffDown(v102.AscendanceBuff) and (not v102.ElementalBlast:IsAvailable() or not v102.MountainsWillFall:IsAvailable()) and not v102.LightningRod:IsAvailable() and v14:HasTier(338 - (105 + 202), 4 + 0)) or ((5254 - (352 + 458)) < (8124 - 6109))) then
					local v265 = 0 - 0;
					while true do
						if ((v265 == (0 + 0)) or ((12276 - 8076) == (3281 - (438 + 511)))) then
							if (v106.CastCycle(v102.LavaBurst, v114, v125, not v17:IsSpellInRange(v102.LavaBurst)) or ((2661 - (1262 + 121)) >= (2384 - (728 + 340)))) then
								return "lava_burst single_target 58";
							end
							if (((2872 - (816 + 974)) == (3314 - 2232)) and v25(v102.LavaBurst, not v17:IsSpellInRange(v102.LavaBurst))) then
								return "lava_burst single_target 58";
							end
							break;
						end
					end
				end
				if (((4779 - 3451) <= (5217 - (163 + 176))) and v128(v102.LavaBurst) and v102.LavaBurst:IsCastable() and v45 and v102.MasteroftheElements:IsAvailable() and not v129() and not v102.LightningRod:IsAvailable()) then
					local v266 = 0 - 0;
					while true do
						if (((18782 - 14695) >= (410 + 945)) and (v266 == (1810 - (1564 + 246)))) then
							if (v106.CastCycle(v102.LavaBurst, v114, v125, not v17:IsSpellInRange(v102.LavaBurst)) or ((935 - (124 + 221)) > (3177 + 1473))) then
								return "lava_burst single_target 60";
							end
							if (v25(v102.LavaBurst, not v17:IsSpellInRange(v102.LavaBurst)) or ((4225 - (115 + 336)) <= (8075 - 4408))) then
								return "lava_burst single_target 60";
							end
							break;
						end
					end
				end
				v174 = 2 + 3;
			end
			if (((1316 - (45 + 1)) < (117 + 2029)) and (v174 == (1996 - (1282 + 708)))) then
				if (((5775 - (583 + 629)) >= (10 + 46)) and v102.EarthShock:IsCastable() and v39) then
					if (v25(v102.EarthShock, not v17:IsSpellInRange(v102.EarthShock)) or ((1153 - 707) == (327 + 295))) then
						return "earth_shock single_target 74";
					end
				end
				if (((3239 - (943 + 227)) > (442 + 567)) and v128(v102.FrostShock) and v42 and v132() and v102.ElectrifiedShocks:IsAvailable() and v129() and not v102.LightningRod:IsAvailable() and (v115 > (1632 - (1539 + 92))) and (v116 > (1947 - (706 + 1240)))) then
					if (((270 - (81 + 177)) < (11888 - 7680)) and v25(v102.FrostShock, not v17:IsSpellInRange(v102.FrostShock))) then
						return "frost_shock single_target 76";
					end
				end
				if ((v128(v102.LavaBurst) and v102.LavaBurst:IsCastable() and v45 and (v102.DeeplyRootedElements:IsAvailable())) or ((3247 - (212 + 45)) <= (9968 - 6988))) then
					if (v106.CastCycle(v102.LavaBurst, v114, v125, not v17:IsSpellInRange(v102.LavaBurst)) or ((4521 - (708 + 1238)) >= (356 + 3919))) then
						return "lava_burst single_target 78";
					end
					if (v25(v102.LavaBurst, not v17:IsSpellInRange(v102.LavaBurst)) or ((1186 + 2440) <= (2973 - (586 + 1081)))) then
						return "lava_burst single_target 78";
					end
				end
				if (((1879 - (348 + 163)) < (3395 + 385)) and v102.FrostShock:IsCastable() and v42 and v132() and v102.FluxMelting:IsAvailable() and v14:BuffDown(v102.FluxMeltingBuff)) then
					if (v25(v102.FrostShock, not v17:IsSpellInRange(v102.FrostShock)) or ((3449 - (215 + 65)) == (5791 - 3518))) then
						return "frost_shock single_target 80";
					end
				end
				if (((4340 - (1541 + 318)) <= (2909 + 370)) and v102.FrostShock:IsCastable() and v42 and v132() and ((v102.ElectrifiedShocks:IsAvailable() and (v17:DebuffRemains(v102.ElectrifiedShocksDebuff) < (2 + 0))) or (v14:BuffRemains(v102.IcefuryBuff) < (5 + 1)))) then
					if (v25(v102.FrostShock, not v17:IsSpellInRange(v102.FrostShock)) or ((2813 - (1036 + 714)) <= (578 + 299))) then
						return "frost_shock single_target 82";
					end
				end
				if (((1278 + 1036) == (3594 - (883 + 397))) and v128(v102.LavaBurst) and v102.LavaBurst:IsCastable() and v45 and (v102.EchooftheElements:IsAvailable() or v102.LavaSurge:IsAvailable() or v102.PrimordialSurge:IsAvailable() or not v102.ElementalBlast:IsAvailable() or not v102.MasteroftheElements:IsAvailable() or v131())) then
					local v267 = 590 - (563 + 27);
					while true do
						if (((3615 - 2691) >= (2463 - (1369 + 617))) and (v267 == (1487 - (85 + 1402)))) then
							if (((625 + 1188) <= (9751 - 5973)) and v106.CastCycle(v102.LavaBurst, v114, v125, not v17:IsSpellInRange(v102.LavaBurst))) then
								return "lava_burst single_target 84";
							end
							if (((4553 - (274 + 129)) == (4367 - (12 + 205))) and v25(v102.LavaBurst, not v17:IsSpellInRange(v102.LavaBurst))) then
								return "lava_burst single_target 84";
							end
							break;
						end
					end
				end
				v174 = 7 + 0;
			end
			if (((1674 - 1242) <= (2911 + 96)) and (v174 == (384 - (27 + 357)))) then
				if ((v102.FireElemental:IsCastable() and v55 and ((v61 and v34) or not v61) and (v92 < v110)) or ((888 - (91 + 389)) > (3018 - (90 + 207)))) then
					if (v25(v102.FireElemental) or ((132 + 3286) < (3358 - (706 + 155)))) then
						return "fire_elemental single_target 2";
					end
				end
				if (((3530 - (730 + 1065)) < (3732 - (1339 + 224))) and v102.StormElemental:IsCastable() and v57 and ((v62 and v34) or not v62) and (v92 < v110)) then
					if (((1979 + 1911) >= (2904 + 358)) and v25(v102.StormElemental)) then
						return "storm_elemental single_target 4";
					end
				end
				if ((v102.TotemicRecall:IsCastable() and v50 and (v102.LiquidMagmaTotem:CooldownRemains() > (66 - 21)) and ((v102.LavaSurge:IsAvailable() and v102.SplinteredElements:IsAvailable()) or ((v115 > (844 - (268 + 575))) and (v116 > (1295 - (919 + 375)))))) or ((11978 - 7622) >= (5620 - (180 + 791)))) then
					if (((5709 - (323 + 1482)) == (5822 - (1177 + 741))) and v25(v102.TotemicRecall)) then
						return "totemic_recall single_target 6";
					end
				end
				if ((v102.LiquidMagmaTotem:IsCastable() and v56 and ((v63 and v34) or not v63) and (v92 < v110) and ((v102.LavaSurge:IsAvailable() and v102.SplinteredElements:IsAvailable()) or (v102.FlameShockDebuff:AuraActiveCount() == (0 + 0)) or (v17:DebuffRemains(v102.FlameShockDebuff) < (22 - 16)) or ((v115 > (1 + 0)) and (v116 > (1 - 0))))) or ((240 + 2620) >= (3898 - (96 + 13)))) then
					if ((v68 == "cursor") or ((3007 - (962 + 959)) > (11112 - 6663))) then
						if (((882 + 4099) > (1897 - (461 + 890))) and v25(v104.LiquidMagmaTotemCursor, not v17:IsInRange(30 + 10))) then
							return "liquid_magma_totem single_target cursor 8";
						end
					end
					if ((v68 == "player") or ((9218 - 6852) <= (251 - (19 + 224)))) then
						if (v25(v104.LiquidMagmaTotemPlayer, not v17:IsInRange(37 + 3)) or ((2788 - (37 + 161)) == (1033 + 1831))) then
							return "liquid_magma_totem single_target player 8";
						end
					end
				end
				if ((v128(v102.PrimordialWave) and v102.PrimordialWave:IsCastable() and v48 and ((v66 and v35) or not v66) and not v14:BuffUp(v102.PrimordialWaveBuff) and not v14:BuffUp(v102.SplinteredElementsBuff)) or ((1018 + 1606) > (4092 + 57))) then
					local v268 = 61 - (60 + 1);
					while true do
						if ((v268 == (923 - (826 + 97))) or ((2536 + 82) >= (16158 - 11663))) then
							if (v106.CastCycle(v102.PrimordialWave, v114, v124, not v17:IsSpellInRange(v102.PrimordialWave)) or ((5119 - 2634) >= (3816 - (375 + 310)))) then
								return "primordial_wave single_target 10";
							end
							if (v25(v102.PrimordialWave, not v17:IsSpellInRange(v102.PrimordialWave)) or ((4803 - (1864 + 135)) <= (7186 - 4401))) then
								return "primordial_wave single_target 10";
							end
							break;
						end
					end
				end
				if ((v102.FlameShock:IsCastable() and v41 and (v115 == (1 + 0)) and v17:DebuffRefreshable(v102.FlameShockDebuff) and ((v17:DebuffRemains(v102.FlameShockDebuff) < v102.PrimordialWave:CooldownRemains()) or not v102.PrimordialWave:IsAvailable()) and v14:BuffDown(v102.SurgeofPowerBuff) and (not v129() or (not v131() and ((v102.ElementalBlast:IsAvailable() and (v127() < ((31 + 59) - ((19 - 11) * v102.EyeoftheStorm:TalentRank())))) or (v127() < ((1191 - (314 + 817)) - ((3 + 2) * v102.EyeoftheStorm:TalentRank()))))))) or ((4785 - (32 + 182)) == (2524 + 891))) then
					if (v25(v102.FlameShock, not v17:IsSpellInRange(v102.FlameShock)) or ((15521 - 11080) > (4852 - (39 + 26)))) then
						return "flame_shock single_target 12";
					end
				end
				v174 = 145 - (54 + 90);
			end
			if (((2118 - (45 + 153)) == (1166 + 754)) and (v174 == (561 - (457 + 95)))) then
				if ((v128(v102.LightningBolt) and v102.LightningBolt:IsCastable() and v46) or ((643 + 4) == (9344 - 4867))) then
					if (((9229 - 5410) == (13808 - 9989)) and v25(v102.LightningBolt, not v17:IsSpellInRange(v102.LightningBolt))) then
						return "lightning_bolt single_target 110";
					end
				end
				if ((v102.FlameShock:IsCastable() and v41 and (v14:IsMoving())) or ((658 + 808) > (15037 - 10677))) then
					local v269 = 0 - 0;
					while true do
						if ((v269 == (748 - (485 + 263))) or ((721 - (575 + 132)) > (1855 - (750 + 111)))) then
							if (((1411 - (445 + 565)) <= (591 + 143)) and v106.CastCycle(v102.FlameShock, v114, v121, not v17:IsSpellInRange(v102.FlameShock))) then
								return "flame_shock single_target 112";
							end
							if (v25(v102.FlameShock, not v17:IsSpellInRange(v102.FlameShock)) or ((311 + 1856) >= (6052 - 2626))) then
								return "flame_shock single_target 112";
							end
							break;
						end
					end
				end
				if (((256 + 508) < (3595 - (189 + 121))) and v102.FlameShock:IsCastable() and v41) then
					if (((619 + 1880) == (3846 - (634 + 713))) and v25(v102.FlameShock, not v17:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock single_target 114";
					end
				end
				if ((v102.FrostShock:IsCastable() and v42) or ((1230 - (493 + 45)) >= (5901 - (493 + 475)))) then
					if (v25(v102.FrostShock, not v17:IsSpellInRange(v102.FrostShock)) or ((806 + 2348) <= (3044 - (158 + 626)))) then
						return "frost_shock single_target 116";
					end
				end
				break;
			end
			if ((v174 == (4 + 4)) or ((4360 - 1723) > (701 + 2448))) then
				if ((v102.FrostShock:IsCastable() and v42 and v132() and v129() and v14:BuffDown(v102.LavaSurgeBuff) and not v102.ElectrifiedShocks:IsAvailable() and not v102.FluxMelting:IsAvailable() and (v102.LavaBurst:ChargesFractional() < (1 + 0)) and v102.EchooftheElements:IsAvailable()) or ((5083 - (1035 + 56)) < (3366 - (114 + 845)))) then
					if (v25(v102.FrostShock, not v17:IsSpellInRange(v102.FrostShock)) or ((1131 + 1771) > (12438 - 7579))) then
						return "frost_shock single_target 98";
					end
				end
				if (((1412 + 267) < (5408 - (179 + 870))) and v102.FrostShock:IsCastable() and v42 and v132() and (v102.FluxMelting:IsAvailable() or (v102.ElectrifiedShocks:IsAvailable() and not v102.LightningRod:IsAvailable()))) then
					if (((2682 - 769) < (5548 - (827 + 51))) and v25(v102.FrostShock, not v17:IsSpellInRange(v102.FrostShock))) then
						return "frost_shock single_target 100";
					end
				end
				if ((v128(v102.ChainLightning) and v102.ChainLightning:IsCastable() and v37 and v129() and v14:BuffDown(v102.LavaSurgeBuff) and (v102.LavaBurst:ChargesFractional() < (2 - 1)) and v102.EchooftheElements:IsAvailable() and (v115 > (1 + 0)) and (v116 > (474 - (95 + 378)))) or ((207 + 2639) < (1245 - 366))) then
					if (((4030 + 558) == (5599 - (334 + 677))) and v25(v102.ChainLightning, not v17:IsSpellInRange(v102.ChainLightning))) then
						return "chain_lightning single_target 102";
					end
				end
				if ((v128(v102.LightningBolt) and v102.LightningBolt:IsCastable() and v46 and v129() and v14:BuffDown(v102.LavaSurgeBuff) and (v102.LavaBurst:ChargesFractional() < (3 - 2)) and v102.EchooftheElements:IsAvailable()) or ((1403 - (1049 + 7)) == (9017 - 6952))) then
					if (v25(v102.LightningBolt, not v17:IsSpellInRange(v102.LightningBolt)) or ((2466 - 1155) > (842 + 1855))) then
						return "lightning_bolt single_target 104";
					end
				end
				if ((v102.FrostShock:IsCastable() and v42 and v132() and not v102.ElectrifiedShocks:IsAvailable() and not v102.FluxMelting:IsAvailable()) or ((7284 - 4567) > (7602 - 3807))) then
					if (v25(v102.FrostShock, not v17:IsSpellInRange(v102.FrostShock)) or ((482 + 599) < (1811 - (1004 + 416)))) then
						return "frost_shock single_target 106";
					end
				end
				if ((v128(v102.ChainLightning) and v102.ChainLightning:IsCastable() and v37 and (v115 > (1958 - (1621 + 336))) and (v116 > (1940 - (337 + 1602)))) or ((1638 - (1014 + 503)) > (4453 - (446 + 569)))) then
					if (((3 + 68) < (5718 - 3769)) and v25(v102.ChainLightning, not v17:IsSpellInRange(v102.ChainLightning))) then
						return "chain_lightning single_target 108";
					end
				end
				v174 = 4 + 5;
			end
			if (((8834 - 4580) == (86 + 4168)) and (v174 == (507 - (223 + 282)))) then
				if (((93 + 3103) >= (4060 - 1510)) and v128(v102.LightningBolt) and v102.LightningBolt:IsCastable() and v46 and v131() and v14:BuffUp(v102.SurgeofPowerBuff)) then
					if (((3582 - 1126) < (4846 - (623 + 47))) and v25(v102.LightningBolt, not v17:IsSpellInRange(v102.LightningBolt))) then
						return "lightning_bolt single_target 26";
					end
				end
				if ((v102.LavaBeam:IsCastable() and v44 and (v115 > (46 - (32 + 13))) and (v116 > (1 + 0)) and v131() and not v102.SurgeofPower:IsAvailable()) or ((933 + 217) == (5253 - (1070 + 731)))) then
					if (((1792 + 83) < (3662 - (1257 + 147))) and v25(v102.LavaBeam, not v17:IsSpellInRange(v102.LavaBeam))) then
						return "lava_beam single_target 28";
					end
				end
				if (((465 + 708) > (78 - 37)) and v128(v102.ChainLightning) and v102.ChainLightning:IsCastable() and v37 and (v115 > (134 - (98 + 35))) and (v116 > (1 + 0)) and v131() and not v102.SurgeofPower:IsAvailable()) then
					if (v25(v102.ChainLightning, not v17:IsSpellInRange(v102.ChainLightning)) or ((198 - 142) >= (10795 - 7587))) then
						return "chain_lightning single_target 30";
					end
				end
				if (((4032 + 281) > (2969 + 404)) and v128(v102.LavaBurst) and v102.LavaBurst:IsCastable() and v45 and v131() and not v129() and not v102.SurgeofPower:IsAvailable() and v102.MasteroftheElements:IsAvailable()) then
					if (v25(v102.LavaBurst, not v17:IsSpellInRange(v102.LavaBurst)) or ((1968 + 2525) == (2782 - (395 + 162)))) then
						return "lava_burst single_target 32";
					end
				end
				if (((2730 + 374) >= (5033 - (816 + 1125))) and v128(v102.LightningBolt) and v102.LightningBolt:IsCastable() and v46 and v131() and not v102.SurgeofPower:IsAvailable() and v129()) then
					if (((5062 - 1514) > (4246 - (701 + 447))) and v25(v102.LightningBolt, not v17:IsSpellInRange(v102.LightningBolt))) then
						return "lightning_bolt single_target 34";
					end
				end
				if ((v128(v102.LightningBolt) and v102.LightningBolt:IsCastable() and v46 and v131() and not v102.SurgeofPower:IsAvailable() and not v102.MasteroftheElements:IsAvailable()) or ((5008 - 1756) == (878 - 375))) then
					if (((6074 - (391 + 950)) > (5567 - 3501)) and v25(v102.LightningBolt, not v17:IsSpellInRange(v102.LightningBolt))) then
						return "lightning_bolt single_target 36";
					end
				end
				v174 = 7 - 4;
			end
			if (((8744 - 5195) >= (643 + 273)) and (v174 == (2 + 1))) then
				if ((v128(v102.LightningBolt) and v102.LightningBolt:IsCastable() and v46 and v14:BuffUp(v102.SurgeofPowerBuff) and v102.LightningRod:IsAvailable()) or ((8003 - 5814) <= (1767 - (251 + 1271)))) then
					if (v25(v102.LightningBolt, not v17:IsSpellInRange(v102.LightningBolt)) or ((1237 + 152) > (10508 - 6583))) then
						return "lightning_bolt single_target 38";
					end
				end
				if (((10438 - 6269) >= (5101 - 2020)) and v128(v102.Icefury) and (v102.Icefury:CooldownRemains() == (1259 - (1147 + 112))) and v43 and v102.ElectrifiedShocks:IsAvailable() and v102.LightningRod:IsAvailable() and v102.LightningRod:IsAvailable()) then
					if (((88 + 261) <= (1815 - 921)) and v25(v102.Icefury, not v17:IsSpellInRange(v102.Icefury))) then
						return "icefury single_target 40";
					end
				end
				if (((190 + 541) <= (3675 - (335 + 362))) and v102.FrostShock:IsCastable() and v42 and v132() and v102.ElectrifiedShocks:IsAvailable() and ((v17:DebuffRemains(v102.ElectrifiedShocksDebuff) < (2 + 0)) or (v14:BuffRemains(v102.IcefuryBuff) <= v14:GCD())) and v102.LightningRod:IsAvailable()) then
					if (v25(v102.FrostShock, not v17:IsSpellInRange(v102.FrostShock)) or ((1342 - 450) > (10622 - 6730))) then
						return "frost_shock single_target 42";
					end
				end
				if ((v102.FrostShock:IsCastable() and v42 and v132() and v102.ElectrifiedShocks:IsAvailable() and (v127() >= (185 - 135)) and (v17:DebuffRemains(v102.ElectrifiedShocksDebuff) < ((9 - 7) * v14:GCD())) and v131() and v102.LightningRod:IsAvailable()) or ((12675 - 8209) == (1466 - (237 + 329)))) then
					if (v25(v102.FrostShock, not v17:IsSpellInRange(v102.FrostShock)) or ((7463 - 5379) >= (1905 + 983))) then
						return "frost_shock single_target 44";
					end
				end
				if (((263 + 216) < (2987 - (408 + 716))) and v102.LavaBeam:IsCastable() and v44 and (v115 > (3 - 2)) and (v116 > (822 - (344 + 477))) and v130() and (v14:BuffRemains(v102.AscendanceBuff) > v102.LavaBeam:CastTime()) and not v14:HasTier(6 + 25, 1765 - (1188 + 573))) then
					if (v25(v102.LavaBeam, not v17:IsSpellInRange(v102.LavaBeam)) or ((6362 - 3934) >= (3934 + 104))) then
						return "lava_beam single_target 46";
					end
				end
				if ((v102.FrostShock:IsCastable() and v42 and v132() and v131() and not v102.LavaSurge:IsAvailable() and not v102.EchooftheElements:IsAvailable() and not v102.PrimordialSurge:IsAvailable() and v102.ElementalBlast:IsAvailable() and (((v127() >= (197 - 136)) and (v127() < (115 - 40)) and (v102.LavaBurst:CooldownRemains() > v14:GCD())) or ((v127() >= (120 - 71)) and (v127() < (1592 - (508 + 1021))) and (v102.LavaBurst:CooldownRemains() > (0 + 0))))) or ((4044 - (228 + 938)) > (3582 - (332 + 353)))) then
					if (v25(v102.FrostShock, not v17:IsSpellInRange(v102.FrostShock)) or ((3007 - 538) > (9624 - 5948))) then
						return "frost_shock single_target 48";
					end
				end
				v174 = 4 + 0;
			end
		end
	end
	local function v141()
		local v175 = 0 + 0;
		while true do
			if (((931 - 698) < (910 - (18 + 405))) and (v175 == (0 + 0))) then
				if (((1250 + 1223) >= (306 - 105)) and v75 and v102.EarthShield:IsCastable() and v14:BuffDown(v102.EarthShieldBuff) and ((v76 == "Earth Shield") or (v102.ElementalOrbit:IsAvailable() and v14:BuffUp(v102.LightningShield)))) then
					if (((5098 - (194 + 784)) >= (1903 - (694 + 1076))) and v25(v102.EarthShield)) then
						return "earth_shield main 2";
					end
				elseif (((4984 - (122 + 1782)) >= (1869 + 117)) and v75 and v102.LightningShield:IsCastable() and v14:BuffDown(v102.LightningShieldBuff) and ((v76 == "Lightning Shield") or (v102.ElementalOrbit:IsAvailable() and v14:BuffUp(v102.EarthShield)))) then
					if (v25(v102.LightningShield) or ((1342 + 97) > (3185 + 353))) then
						return "lightning_shield main 2";
					end
				end
				v31 = v135();
				v175 = 1 + 0;
			end
			if (((5 - 3) == v175) or ((389 + 30) < (1977 - (214 + 1756)))) then
				if (((13632 - 10812) == (311 + 2509)) and v102.AncestralSpirit:IsCastable() and v102.AncestralSpirit:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
					if (v25(v104.AncestralSpiritMouseover) or ((241 + 4121) <= (4112 - (217 + 368)))) then
						return "ancestral_spirit mouseover";
					end
				end
				v111, v112 = v30();
				v175 = 8 - 5;
			end
			if (((1721 + 892) <= (1989 + 691)) and (v175 == (1 + 2))) then
				if ((v102.ImprovedFlametongueWeapon:IsAvailable() and v102.FlametongueWeapon:IsCastable() and v51 and (not v111 or (v112 < (600889 - (844 + 45)))) and v102.FlametongueWeapon:IsAvailable()) or ((1766 - (242 + 42)) >= (8583 - 4295))) then
					if (v25(v102.FlametongueWeapon) or ((5723 - 3261) > (5626 - (132 + 1068)))) then
						return "flametongue_weapon enchant";
					end
				end
				if (((7622 - 2848) == (6397 - (214 + 1409))) and not v14:AffectingCombat() and v32 and v106.TargetIsValid()) then
					local v270 = 0 + 0;
					while true do
						if (((2200 - (497 + 1137)) <= (1900 - (9 + 931))) and ((289 - (181 + 108)) == v270)) then
							v31 = v138();
							if (v31 or ((1733 + 1177) <= (4759 - 2829))) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v175 == (2 - 1)) or ((5 + 14) > (282 + 170))) then
				if (v31 or ((1383 - (296 + 180)) > (4555 - (1183 + 220)))) then
					return v31;
				end
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v14:CanAttack(v17)) or ((3770 - (1037 + 228)) > (7235 - 2765))) then
					if (v25(v102.AncestralSpirit, nil, true) or ((10694 - 6983) > (13879 - 9817))) then
						return "ancestral_spirit";
					end
				end
				v175 = 736 - (527 + 207);
			end
		end
	end
	local function v142()
		local v176 = 527 - (187 + 340);
		while true do
			if (((2290 - (1298 + 572)) == (1044 - 624)) and (v176 == (170 - (144 + 26)))) then
				v31 = v136();
				if (v31 or ((81 - 48) >= (8148 - 4654))) then
					return v31;
				end
				v176 = 1 + 0;
			end
			if ((v176 == (2 - 1)) or ((2941 - 1674) == (22997 - 18253))) then
				if (((1234 + 1194) < (5127 - 1349)) and v87) then
					local v271 = 0 + 0;
					while true do
						if (((0 + 0) == v271) or ((3148 - (5 + 197)) <= (2282 - (339 + 347)))) then
							if (((10046 - 5613) > (11012 - 7885)) and v82) then
								local v289 = 376 - (365 + 11);
								while true do
									if (((4075 + 225) >= (10511 - 7778)) and (v289 == (0 - 0))) then
										v31 = v106.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 964 - (837 + 87));
										if (((8188 - 3359) == (6499 - (837 + 833))) and v31) then
											return v31;
										end
										break;
									end
								end
							end
							if (((360 + 1323) <= (6113 - (356 + 1031))) and v83) then
								local v290 = 0 + 0;
								while true do
									if (((6481 - (73 + 1573)) >= (5057 - (1307 + 81))) and (v290 == (234 - (7 + 227)))) then
										v31 = v106.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 49 - 19);
										if (((3017 - (90 + 76)) > (5832 - 3973)) and v31) then
											return v31;
										end
										break;
									end
								end
							end
							v271 = 1 + 0;
						end
						if (((3177 + 671) > (1931 + 392)) and (v271 == (3 - 2))) then
							if (((3096 - (197 + 63)) > (99 + 370)) and v84) then
								local v291 = 0 + 0;
								while true do
									if (((0 + 0) == v291) or ((345 + 1751) <= (677 - 137))) then
										v31 = v106.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 1399 - (618 + 751));
										if (v31 or ((2382 + 801) < (4555 - (206 + 1704)))) then
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
				if (((5442 - 2212) <= (7506 - 3746)) and v88) then
					local v272 = 0 + 0;
					while true do
						if (((5103 - (155 + 1120)) == (5334 - (396 + 1110))) and ((0 - 0) == v272)) then
							v31 = v106.HandleIncorporeal(v102.Hex, v104.HexMouseOver, 10 + 20, true);
							if (((418 + 136) == (475 + 79)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				v176 = 978 - (230 + 746);
			end
			if ((v176 == (603 - (473 + 128))) or ((2611 - (39 + 9)) == (438 - (38 + 228)))) then
				if (((7063 - 3174) >= (604 - (106 + 367))) and v86) then
					local v273 = 0 + 0;
					while true do
						if ((v273 == (1862 - (354 + 1508))) or ((1578 - 1086) == (3344 + 1234))) then
							if (v18 or ((2411 + 1701) < (2441 - 625))) then
								local v292 = 1244 - (334 + 910);
								while true do
									if (((5420 - (92 + 803)) >= (674 + 549)) and (v292 == (1181 - (1035 + 146)))) then
										v31 = v134();
										if (((1706 - (230 + 386)) <= (2806 + 2021)) and v31) then
											return v31;
										end
										break;
									end
								end
							end
							if ((v15 and v15:Exists() and not v14:CanAttack(v15) and (v106.UnitHasDispellableDebuffByPlayer(v15) or v106.UnitHasCurseDebuff(v15))) or ((1749 - (353 + 1157)) > (2459 - (53 + 1061)))) then
								if (v102.CleanseSpirit:IsCastable() or ((5345 - (1568 + 67)) >= (1706 + 2032))) then
									if (v25(v104.CleanseSpiritMouseover, not v15:IsSpellInRange(v102.PurifySpirit)) or ((548 + 3290) < (5217 - 3156))) then
										return "purify_spirit dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				if ((v102.GreaterPurge:IsAvailable() and v99 and v102.GreaterPurge:IsReady() and v36 and v85 and not v14:IsCasting() and not v14:IsChanneling() and v106.UnitHasMagicBuff(v17)) or ((2030 - 1340) > (2954 - 1782))) then
					if (v25(v102.GreaterPurge, not v17:IsSpellInRange(v102.GreaterPurge)) or ((1503 + 89) > (3811 - (615 + 597)))) then
						return "greater_purge damage";
					end
				end
				v176 = 3 + 0;
			end
			if (((5345 - 1771) <= (3616 + 781)) and (v176 == (1 + 2))) then
				if (((1726 + 1409) > (3229 - (1056 + 843))) and v102.Purge:IsReady() and v99 and v36 and v85 and not v14:IsCasting() and not v14:IsChanneling() and v106.UnitHasMagicBuff(v17)) then
					if (v25(v102.Purge, not v17:IsSpellInRange(v102.Purge)) or ((8504 - 4604) <= (6056 - 2415))) then
						return "purge damage";
					end
				end
				if (((4946 - 3222) == (1008 + 716)) and v106.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
					local v274 = 1976 - (286 + 1690);
					local v275;
					while true do
						if (((1366 - (98 + 813)) <= (340 + 942)) and ((7 - 4) == v274)) then
							if (((2613 + 1993) < (5383 - (263 + 244))) and v33 and (v115 > (2 + 0)) and (v116 > (1689 - (1502 + 185)))) then
								local v293 = 0 + 0;
								while true do
									if ((v293 == (4 - 3)) or ((3825 - 2383) > (4167 - (629 + 898)))) then
										if (((370 - 234) < (9428 - 5760)) and v25(v102.Pool)) then
											return "Pool for Aoe()";
										end
										break;
									end
									if ((v293 == (365 - (12 + 353))) or ((3695 - (1680 + 231)) > (305 + 4476))) then
										v31 = v139();
										if (((2808 + 1777) > (4447 - (212 + 937))) and v31) then
											return v31;
										end
										v293 = 1 + 0;
									end
								end
							end
							if (true or ((2726 - (111 + 951)) > (345 + 1353))) then
								local v294 = 27 - (18 + 9);
								while true do
									if ((v294 == (0 + 0)) or ((3961 - (31 + 503)) < (4481 - (595 + 1037)))) then
										v31 = v140();
										if (((5060 - (189 + 1255)) <= (1637 + 2792)) and v31) then
											return v31;
										end
										v294 = 1 - 0;
									end
									if (((5267 - (1170 + 109)) >= (1883 - (348 + 1469))) and (v294 == (1290 - (1115 + 174)))) then
										if (v25(v102.Pool) or ((2102 - 1240) > (5658 - (85 + 929)))) then
											return "Pool for SingleTarget()";
										end
										break;
									end
								end
							end
							break;
						end
						if (((717 + 504) == (3088 - (1151 + 716))) and (v274 == (1 + 0))) then
							if ((v92 < v110) or ((44 + 1) > (2975 - (95 + 1609)))) then
								if (((13993 - 10116) > (2288 - (364 + 394))) and v58 and ((v34 and v64) or not v64)) then
									local v300 = 0 + 0;
									while true do
										if ((v300 == (0 + 0)) or ((987 + 3811) == (1021 + 234))) then
											v31 = v137();
											if (v31 or ((1277 + 1264) > (1459 + 1401))) then
												return v31;
											end
											break;
										end
									end
								end
							end
							if ((v102.NaturesSwiftness:IsCastable() and v47) or ((1092 + 1810) > (3339 + 290))) then
								if (((135 + 292) < (4424 - (719 + 237))) and v25(v102.NaturesSwiftness)) then
									return "natures_swiftness main 12";
								end
							end
							v274 = 5 - 3;
						end
						if (((3460 + 730) >= (6950 - 4146)) and (v274 == (5 - 3))) then
							v275 = v106.HandleDPSPotion(v14:BuffUp(v102.AscendanceBuff));
							if (((4957 - 2871) == (4077 - (761 + 1230))) and v275) then
								return v275;
							end
							v274 = 196 - (80 + 113);
						end
						if (((2256 + 1892) > (1834 + 899)) and (v274 == (0 + 0))) then
							if (((12259 - 9205) >= (372 + 1233)) and v102.SpiritWalkersGrace:IsCastable() and v52 and v14:IsMoving()) then
								if (((191 + 853) < (2762 - (965 + 278))) and v25(v102.SpiritWalkersGrace)) then
									return "spiritwalkers_grace main 0";
								end
							end
							if (((3436 - (1391 + 338)) <= (10725 - 6525)) and (v92 < v110) and v59 and ((v65 and v34) or not v65)) then
								if (((565 + 15) == (1257 - 677)) and v102.BloodFury:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (17 + 33)))) then
									if (((2009 - (496 + 912)) <= (3288 - 2289)) and v25(v102.BloodFury)) then
										return "blood_fury main 2";
									end
								end
								if (((978 + 2992) == (7525 - 3555)) and v102.Berserking:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff))) then
									if (v25(v102.Berserking) or ((1428 - (1190 + 140)) == (101 + 107))) then
										return "berserking main 4";
									end
								end
								if (((2724 - (317 + 401)) <= (4863 - (303 + 646))) and v102.Fireblood:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (177 - 127)))) then
									if (v25(v102.Fireblood) or ((4833 - (1675 + 57)) <= (1914 + 1057))) then
										return "fireblood main 6";
									end
								end
								if ((v102.AncestralCall:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (130 - 80)))) or ((259 + 1814) <= (1648 - (338 + 639)))) then
									if (((3684 - (320 + 59)) > (49 + 46)) and v25(v102.AncestralCall)) then
										return "ancestral_call main 8";
									end
								end
								if (((3459 - (628 + 104)) == (3378 - 651)) and v102.BagofTricks:IsCastable() and (not v102.Ascendance:IsAvailable() or v14:BuffUp(v102.AscendanceBuff))) then
									if (v25(v102.BagofTricks) or ((4861 - (439 + 1452)) >= (6019 - (105 + 1842)))) then
										return "bag_of_tricks main 10";
									end
								end
							end
							v274 = 4 - 3;
						end
					end
				end
				break;
			end
		end
	end
	local function v143()
		local v177 = 0 - 0;
		while true do
			if (((18677 - 14796) > (35 + 779)) and (v177 == (6 - 2))) then
				v93 = EpicSettings.Settings['useWeapon'];
				v54 = EpicSettings.Settings['useAscendance'];
				v56 = EpicSettings.Settings['useLiquidMagmaTotem'];
				v55 = EpicSettings.Settings['useFireElemental'];
				v177 = 3 + 2;
			end
			if (((1164 - (274 + 890)) == v177) or ((4290 + 642) < (4094 + 774))) then
				v37 = EpicSettings.Settings['useChainlightning'];
				v38 = EpicSettings.Settings['useEarthquake'];
				v39 = EpicSettings.Settings['useEarthShock'];
				v40 = EpicSettings.Settings['useElementalBlast'];
				v177 = 1 + 0;
			end
			if (((1994 + 1673) <= (2804 + 1998)) and (v177 == (6 - 1))) then
				v57 = EpicSettings.Settings['useStormElemental'];
				v60 = EpicSettings.Settings['ascendanceWithCD'];
				v63 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
				v61 = EpicSettings.Settings['fireElementalWithCD'];
				v177 = 825 - (731 + 88);
			end
			if (((1008 + 252) >= (527 + 331)) and (v177 == (1 + 2))) then
				v49 = EpicSettings.Settings['useStormkeeper'];
				v50 = EpicSettings.Settings['useTotemicRecall'];
				v51 = EpicSettings.Settings['useWeaponEnchant'];
				v52 = EpicSettings.Settings['UseSpiritWalkersGrace'];
				v177 = 5 - 1;
			end
			if ((v177 == (5 - 3)) or ((11366 - 7455) == (9766 - 5066))) then
				v45 = EpicSettings.Settings['useLavaBurst'];
				v46 = EpicSettings.Settings['useLightningBolt'];
				v47 = EpicSettings.Settings['useNaturesSwiftness'];
				v48 = EpicSettings.Settings['usePrimordialWave'];
				v177 = 3 + 0;
			end
			if (((13 + 2987) < (754 + 3440)) and (v177 == (5 + 1))) then
				v62 = EpicSettings.Settings['stormElementalWithCD'];
				v66 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v67 = EpicSettings.Settings['stormkeeperWithMiniCD'];
				break;
			end
			if (((809 - (139 + 19)) < (793 + 3649)) and ((1994 - (1687 + 306)) == v177)) then
				v41 = EpicSettings.Settings['useFlameShock'];
				v42 = EpicSettings.Settings['useFrostShock'];
				v43 = EpicSettings.Settings['useIceFury'];
				v44 = EpicSettings.Settings['useLavaBeam'];
				v177 = 7 - 5;
			end
		end
	end
	local function v144()
		local v178 = 1154 - (1018 + 136);
		while true do
			if (((1 + 3) == v178) or ((856 - 661) >= (2619 - (117 + 698)))) then
				v101 = EpicSettings.Settings['healOOCHP'] or (481 - (305 + 176));
				v99 = EpicSettings.Settings['usePurgeTarget'];
				v82 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v83 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v178 = 1 + 4;
			end
			if ((v178 == (4 + 1)) or ((2395 - 1013) > (2075 + 141))) then
				v84 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if ((v178 == (2 - 0)) or ((6469 - 3608) == (4268 - 1809))) then
				v79 = EpicSettings.Settings['astralShiftHP'] or (260 - (159 + 101));
				v80 = EpicSettings.Settings['healingStreamTotemHP'] or (0 - 0);
				v81 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 - 0);
				v53 = EpicSettings.Settings['earthquakeSetting'] or "";
				v178 = 2 + 1;
			end
			if (((6065 - 4162) < (7919 - 3898)) and (v178 == (1 + 2))) then
				v68 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
				v75 = EpicSettings.Settings['autoShield'];
				v76 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v100 = EpicSettings.Settings['healOOC'];
				v178 = 270 - (112 + 154);
			end
			if ((v178 == (2 - 1)) or ((2301 - (21 + 10)) >= (5849 - (531 + 1188)))) then
				v73 = EpicSettings.Settings['useAstralShift'];
				v74 = EpicSettings.Settings['useHealingStreamTotem'];
				v77 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 + 0);
				v78 = EpicSettings.Settings['ancestralGuidanceGroup'] or (663 - (96 + 567));
				v178 = 2 - 0;
			end
			if (((1073 + 1520) <= (14232 - 10274)) and (v178 == (1695 - (867 + 828)))) then
				v69 = EpicSettings.Settings['useWindShear'];
				v70 = EpicSettings.Settings['useCapacitorTotem'];
				v71 = EpicSettings.Settings['useThunderstorm'];
				v72 = EpicSettings.Settings['useAncestralGuidance'];
				v178 = 2 - 1;
			end
		end
	end
	local function v145()
		local v179 = 0 - 0;
		while true do
			if (((2625 - 1449) == (1811 - 635)) and (v179 == (1 + 1))) then
				v64 = EpicSettings.Settings['trinketsWithCD'];
				v65 = EpicSettings.Settings['racialsWithCD'];
				v95 = EpicSettings.Settings['useHealthstone'];
				v94 = EpicSettings.Settings['useHealingPotion'];
				v179 = 4 - 1;
			end
			if ((v179 == (771 - (134 + 637))) or ((533 + 2529) == (2975 - (775 + 382)))) then
				v92 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v89 = EpicSettings.Settings['InterruptWithStun'];
				v90 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v91 = EpicSettings.Settings['InterruptThreshold'];
				v179 = 608 - (45 + 562);
			end
			if ((v179 == (865 - (545 + 317))) or ((5521 - 1804) < (4175 - (763 + 263)))) then
				v97 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v96 = EpicSettings.Settings['healingPotionHP'] or (1750 - (512 + 1238));
				v98 = EpicSettings.Settings['HealingPotionName'] or "";
				v87 = EpicSettings.Settings['handleAfflicted'];
				v179 = 1598 - (272 + 1322);
			end
			if (((5985 - 2790) < (4976 - (533 + 713))) and (v179 == (32 - (14 + 14)))) then
				v88 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((3622 - (499 + 326)) <= (7135 - 3155)) and (v179 == (425 - (104 + 320)))) then
				v86 = EpicSettings.Settings['DispelDebuffs'];
				v85 = EpicSettings.Settings['DispelBuffs'];
				v58 = EpicSettings.Settings['useTrinkets'];
				v59 = EpicSettings.Settings['useRacials'];
				v179 = 1999 - (1929 + 68);
			end
		end
	end
	local function v146()
		v144();
		v143();
		v145();
		v32 = EpicSettings.Toggles['ooc'];
		v33 = EpicSettings.Toggles['aoe'];
		v34 = EpicSettings.Toggles['cds'];
		v36 = EpicSettings.Toggles['dispel'];
		v35 = EpicSettings.Toggles['minicds'];
		if (((3267 - (1206 + 117)) <= (1589 + 779)) and v14:IsDeadOrGhost()) then
			return v31;
		end
		v113 = v14:GetEnemiesInRange(1632 - (683 + 909));
		v114 = v17:GetEnemiesInSplashRange(15 - 10);
		if (((3176 - 1467) < (5025 - (772 + 5))) and v33) then
			local v190 = 1427 - (19 + 1408);
			while true do
				if ((v190 == (288 - (134 + 154))) or ((6543 - 2573) == (9932 - 6730))) then
					v115 = #v113;
					v116 = v28(v17:GetEnemiesInSplashRangeCount(2 + 3), v115);
					break;
				end
			end
		else
			v115 = 1 + 0;
			v116 = 203 - (10 + 192);
		end
		if ((v36 and v86) or ((3965 - (13 + 34)) >= (5686 - (342 + 947)))) then
			if ((v14:AffectingCombat() and v102.CleanseSpirit:IsAvailable()) or ((3217 - 2437) == (4893 - (119 + 1589)))) then
				local v244 = v86 and v102.CleanseSpirit:IsReady() and v36;
				v31 = v106.FocusUnit(v244, nil, 44 - 24, nil, 34 - 9, v102.HealingSurge);
				if (v31 or ((3754 - (545 + 7)) >= (11552 - 7477))) then
					return v31;
				end
			end
		end
		if (((27 + 37) == (1767 - (494 + 1209))) and (v106.TargetIsValid() or v14:AffectingCombat())) then
			local v191 = 0 - 0;
			while true do
				if (((3200 - (197 + 801)) >= (1399 - 705)) and ((0 - 0) == v191)) then
					v109 = v10.BossFightRemains();
					v110 = v109;
					v191 = 955 - (919 + 35);
				end
				if (((3140 + 566) <= (15737 - 11837)) and (v191 == (468 - (369 + 98)))) then
					if (((4005 - (400 + 715)) > (1165 + 1452)) and (v110 == (4837 + 6274))) then
						v110 = v10.FightRemains(v113, false);
					end
					break;
				end
			end
		end
		if ((not v14:IsChanneling() and not v14:IsCasting()) or ((4680 - (744 + 581)) > (2196 + 2189))) then
			if (v87 or ((4689 - (653 + 969)) <= (4289 - 2094))) then
				if (((4656 - (12 + 1619)) >= (2976 - (103 + 60))) and v82) then
					local v276 = 0 - 0;
					while true do
						if (((10537 - 8125) >= (1696 - 1340)) and (v276 == (1662 - (710 + 952)))) then
							v31 = v106.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 1908 - (555 + 1313));
							if (((1895 + 175) > (1048 + 123)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				if (v83 or ((2848 + 1260) < (5402 - (1261 + 207)))) then
					local v277 = 252 - (245 + 7);
					while true do
						if (((4246 - (212 + 535)) >= (16992 - 13553)) and (v277 == (1476 - (905 + 571)))) then
							v31 = v106.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 140 - 110);
							if (((1239 - 363) < (13063 - 9760)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				if (((22 + 2900) <= (5025 - (522 + 941))) and v84) then
					local v278 = 1511 - (292 + 1219);
					while true do
						if (((3731 - (787 + 325)) >= (4017 - 2695)) and (v278 == (0 + 0))) then
							v31 = v106.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 68 - 38);
							if (((4667 - (424 + 110)) >= (1379 + 1025)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
			end
			if (v14:AffectingCombat() or ((850 + 583) == (532 + 2154))) then
				if ((v34 and v93 and (v103.Dreambinder:IsEquippedAndReady() or v103.Iridal:IsEquippedAndReady())) or ((4435 - (33 + 279)) == (716 + 3741))) then
					if (v25(v104.UseWeapon, nil) or ((5325 - (1338 + 15)) <= (1628 - (528 + 895)))) then
						return "Using Weapon Macro";
					end
				end
				v31 = v142();
				if (v31 or ((1793 + 1973) < (2928 - (1606 + 318)))) then
					return v31;
				end
			else
				local v245 = 1819 - (298 + 1521);
				while true do
					if (((7668 - 5884) < (2494 - (154 + 156))) and (v245 == (0 - 0))) then
						v31 = v141();
						if (v31 or ((3418 - 1769) > (5346 - (712 + 403)))) then
							return v31;
						end
						break;
					end
				end
			end
		end
	end
	local function v147()
		local v185 = 450 - (168 + 282);
		while true do
			if (((6561 - 3368) == (3150 + 43)) and (v185 == (1 + 0))) then
				v22.Print("Elemental Shaman by Epic. Supported by xKaneto.");
				break;
			end
			if ((v185 == (0 - 0)) or ((4946 - (1242 + 209)) > (4985 - (20 + 659)))) then
				v102.FlameShockDebuff:RegisterAuraTracking();
				v108();
				v185 = 1 + 0;
			end
		end
	end
	v22.SetAPL(181 + 81, v146, v147);
end;
return v0["Epix_Shaman_Elemental.lua"]();

