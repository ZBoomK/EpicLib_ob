local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1011 - 679) >= (1701 + 2302))) then
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
	local v100 = v18.Shaman.Elemental;
	local v101 = v20.Shaman.Elemental;
	local v102 = v23.Shaman.Elemental;
	local v103 = {};
	local v104 = v21.Commons.Everyone;
	local v105 = v21.Commons.Shaman;
	local function v106()
		if (v100.CleanseSpirit:IsAvailable() or ((6535 - 3244) <= (12977 - 9697))) then
			v104.DispellableDebuffs = v104.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v106();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v9:RegisterForEvent(function()
		local v146 = 1910 - (716 + 1194);
		while true do
			if (((75 + 4311) >= (94 + 779)) and (v146 == (503 - (74 + 429)))) then
				v100.PrimordialWave:RegisterInFlightEffect(631125 - 303963);
				v100.PrimordialWave:RegisterInFlight();
				v146 = 1 + 0;
			end
			if (((2107 - 1186) <= (780 + 322)) and (v146 == (2 - 1))) then
				v100.LavaBurst:RegisterInFlight();
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v100.PrimordialWave:RegisterInFlightEffect(808934 - 481772);
	v100.PrimordialWave:RegisterInFlight();
	v100.LavaBurst:RegisterInFlight();
	local v107 = 11544 - (279 + 154);
	local v108 = 11889 - (454 + 324);
	local v109, v110;
	local v111, v112;
	local v113 = 0 + 0;
	local v114 = 17 - (12 + 5);
	local v115 = 0 + 0;
	local v116 = 0 - 0;
	local v117 = 0 + 0;
	local function v118()
		return (1133 - (277 + 816)) - (v28() - v115);
	end
	v9:RegisterForSelfCombatEvent(function(...)
		local v147 = 0 - 0;
		local v148;
		local v149;
		local v150;
		while true do
			if (((5889 - (1058 + 125)) >= (181 + 782)) and (v147 == (975 - (815 + 160)))) then
				v148, v149, v149, v149, v150 = select(34 - 26, ...);
				if (((v148 == v13:GUID()) and (v150 == (454911 - 263277))) or ((230 + 730) <= (2560 - 1684))) then
					v116 = v28();
					C_Timer.After(1898.1 - (41 + 1857), function()
						if ((v116 ~= v117) or ((3959 - (1222 + 671)) == (2408 - 1476))) then
							v115 = v116;
						end
					end);
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED");
	local function v119(v151)
		return (v151:DebuffRefreshable(v100.FlameShockDebuff));
	end
	local function v120(v152)
		return v152:DebuffRefreshable(v100.FlameShockDebuff) and (v152:DebuffRemains(v100.FlameShockDebuff) < (v152:TimeToDie() - (6 - 1)));
	end
	local function v121(v153)
		return v153:DebuffRefreshable(v100.FlameShockDebuff) and (v153:DebuffRemains(v100.FlameShockDebuff) < (v153:TimeToDie() - (1187 - (229 + 953)))) and (v153:DebuffRemains(v100.FlameShockDebuff) > (1774 - (1111 + 663)));
	end
	local function v122(v154)
		return (v154:DebuffRemains(v100.FlameShockDebuff));
	end
	local function v123(v155)
		return v155:DebuffRemains(v100.FlameShockDebuff) > (1581 - (874 + 705));
	end
	local function v124(v156)
		return (v156:DebuffRemains(v100.LightningRodDebuff));
	end
	local function v125()
		local v157 = 0 + 0;
		local v158;
		while true do
			if (((3292 + 1533) < (10066 - 5223)) and (v157 == (0 + 0))) then
				v158 = v13:Maelstrom();
				if (not v13:IsCasting() or ((4556 - (642 + 37)) >= (1035 + 3502))) then
					return v158;
				elseif (v13:IsCasting(v100.ElementalBlast) or ((691 + 3624) < (4333 - 2607))) then
					return v158 - (529 - (233 + 221));
				elseif (v13:IsCasting(v100.Icefury) or ((8507 - 4828) < (551 + 74))) then
					return v158 + (1566 - (718 + 823));
				elseif (v13:IsCasting(v100.LightningBolt) or ((2911 + 1714) < (1437 - (266 + 539)))) then
					return v158 + (28 - 18);
				elseif (v13:IsCasting(v100.LavaBurst) or ((1308 - (636 + 589)) > (4225 - 2445))) then
					return v158 + (24 - 12);
				elseif (((433 + 113) <= (392 + 685)) and v13:IsCasting(v100.ChainLightning)) then
					return v158 + ((1019 - (657 + 358)) * v114);
				else
					return v158;
				end
				break;
			end
		end
	end
	local function v126(v159)
		local v160 = 0 - 0;
		local v161;
		while true do
			if ((v160 == (0 - 0)) or ((2183 - (1151 + 36)) > (4154 + 147))) then
				v161 = v159:IsReady();
				if (((1071 + 2999) > (2051 - 1364)) and ((v159 == v100.Stormkeeper) or (v159 == v100.ElementalBlast) or (v159 == v100.Icefury))) then
					local v254 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or not v13:IsMoving();
					return v161 and v254 and not v13:IsCasting(v159);
				elseif ((v159 == v100.LavaBeam) or ((2488 - (1552 + 280)) >= (4164 - (64 + 770)))) then
					local v261 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or not v13:IsMoving();
					return v161 and v261;
				elseif ((v159 == v100.LightningBolt) or (v159 == v100.ChainLightning) or ((1692 + 800) <= (760 - 425))) then
					local v264 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or v13:BuffUp(v100.StormkeeperBuff) or not v13:IsMoving();
					return v161 and v264;
				elseif (((768 + 3554) >= (3805 - (157 + 1086))) and (v159 == v100.LavaBurst)) then
					local v269 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or v13:BuffUp(v100.LavaSurgeBuff) or not v13:IsMoving();
					local v270 = v13:BuffUp(v100.LavaSurgeBuff);
					local v271 = (v100.LavaBurst:Charges() >= (1 - 0)) and not v13:IsCasting(v100.LavaBurst);
					local v272 = (v100.LavaBurst:Charges() == (8 - 6)) and v13:IsCasting(v100.LavaBurst);
					return v161 and v269 and (v270 or v271 or v272);
				elseif ((v159 == v100.PrimordialWave) or ((5579 - 1942) >= (5145 - 1375))) then
					return v161 and v33 and v13:BuffDown(v100.PrimordialWaveBuff) and v13:BuffDown(v100.LavaSurgeBuff);
				else
					return v161;
				end
				break;
			end
		end
	end
	local function v127()
		if (not v100.MasteroftheElements:IsAvailable() or ((3198 - (599 + 220)) > (9116 - 4538))) then
			return false;
		end
		local v162 = v13:BuffUp(v100.MasteroftheElementsBuff);
		if (not v13:IsCasting() or ((2414 - (1813 + 118)) > (544 + 199))) then
			return v162;
		elseif (((3671 - (841 + 376)) > (809 - 231)) and v13:IsCasting(v105.LavaBurst)) then
			return true;
		elseif (((217 + 713) < (12168 - 7710)) and (v13:IsCasting(v105.ElementalBlast) or v13:IsCasting(v100.Icefury) or v13:IsCasting(v100.LightningBolt) or v13:IsCasting(v100.ChainLightning))) then
			return false;
		else
			return v162;
		end
	end
	local function v128()
		local v163 = 859 - (464 + 395);
		local v164;
		while true do
			if (((1698 - 1036) <= (467 + 505)) and (v163 == (838 - (467 + 370)))) then
				if (((9030 - 4660) == (3208 + 1162)) and not v13:IsCasting()) then
					return v164 > (0 - 0);
				elseif (((v164 == (1 + 0)) and (v13:IsCasting(v100.LightningBolt) or v13:IsCasting(v100.ChainLightning))) or ((11078 - 6316) <= (1381 - (150 + 370)))) then
					return false;
				else
					return v164 > (1282 - (74 + 1208));
				end
				break;
			end
			if ((v163 == (0 - 0)) or ((6696 - 5284) == (3035 + 1229))) then
				if (not v100.PoweroftheMaelstrom:IsAvailable() or ((3558 - (14 + 376)) < (3733 - 1580))) then
					return false;
				end
				v164 = v13:BuffStack(v100.PoweroftheMaelstromBuff);
				v163 = 1 + 0;
			end
		end
	end
	local function v129()
		if (not v100.Stormkeeper:IsAvailable() or ((4372 + 604) < (1271 + 61))) then
			return false;
		end
		local v165 = v13:BuffUp(v100.StormkeeperBuff);
		if (((13560 - 8932) == (3482 + 1146)) and not v13:IsCasting()) then
			return v165;
		elseif (v13:IsCasting(v100.Stormkeeper) or ((132 - (23 + 55)) == (936 - 541))) then
			return true;
		else
			return v165;
		end
	end
	local function v130()
		if (((55 + 27) == (74 + 8)) and not v100.Icefury:IsAvailable()) then
			return false;
		end
		local v166 = v13:BuffUp(v100.IcefuryBuff);
		if (not v13:IsCasting() or ((900 - 319) < (89 + 193))) then
			return v166;
		elseif (v13:IsCasting(v100.Icefury) or ((5510 - (652 + 249)) < (6676 - 4181))) then
			return true;
		else
			return v166;
		end
	end
	local v131 = 1868 - (708 + 1160);
	local function v132()
		if (((3126 - 1974) == (2099 - 947)) and v100.CleanseSpirit:IsReady() and v35 and (v104.UnitHasDispellableDebuffByPlayer(v17) or v104.DispellableFriendlyUnit(52 - (10 + 17)) or v104.UnitHasCurseDebuff(v17))) then
			if (((426 + 1470) <= (5154 - (1400 + 332))) and (v131 == (0 - 0))) then
				v131 = v28();
			end
			if (v104.Wait(2408 - (242 + 1666), v131) or ((424 + 566) > (594 + 1026))) then
				local v248 = 0 + 0;
				while true do
					if (((940 - (850 + 90)) == v248) or ((1535 - 658) > (6085 - (360 + 1030)))) then
						if (((2382 + 309) >= (5224 - 3373)) and v24(v102.CleanseSpiritFocus)) then
							return "cleanse_spirit dispel";
						end
						v131 = 0 - 0;
						break;
					end
				end
			end
		end
	end
	local function v133()
		if ((v98 and (v13:HealthPercentage() <= v99)) or ((4646 - (909 + 752)) >= (6079 - (109 + 1114)))) then
			if (((7828 - 3552) >= (466 + 729)) and v100.HealingSurge:IsReady()) then
				if (((3474 - (6 + 236)) <= (2955 + 1735)) and v24(v100.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v134()
		local v167 = 0 + 0;
		while true do
			if ((v167 == (2 - 1)) or ((1564 - 668) >= (4279 - (1076 + 57)))) then
				if (((504 + 2557) >= (3647 - (579 + 110))) and v100.HealingStreamTotem:IsReady() and v72 and v104.AreUnitsBelowHealthPercentage(v78, v79, v100.HealingSurge)) then
					if (((252 + 2935) >= (570 + 74)) and v24(v100.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if (((342 + 302) <= (1111 - (174 + 233))) and v101.Healthstone:IsReady() and v93 and (v13:HealthPercentage() <= v95)) then
					if (((2675 - 1717) > (1661 - 714)) and v24(v102.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				v167 = 1 + 1;
			end
			if (((5666 - (663 + 511)) >= (2368 + 286)) and ((0 + 0) == v167)) then
				if (((10611 - 7169) >= (911 + 592)) and v100.AstralShift:IsReady() and v71 and (v13:HealthPercentage() <= v77)) then
					if (v24(v100.AstralShift) or ((7463 - 4293) <= (3543 - 2079))) then
						return "astral_shift defensive 1";
					end
				end
				if ((v100.AncestralGuidance:IsReady() and v70 and v104.AreUnitsBelowHealthPercentage(v75, v76, v100.HealingSurge)) or ((2290 + 2507) == (8540 - 4152))) then
					if (((393 + 158) <= (63 + 618)) and v24(v100.AncestralGuidance)) then
						return "ancestral_guidance defensive 2";
					end
				end
				v167 = 723 - (478 + 244);
			end
			if (((3794 - (440 + 77)) > (186 + 221)) and (v167 == (7 - 5))) then
				if (((6251 - (655 + 901)) >= (263 + 1152)) and v92 and (v13:HealthPercentage() <= v94)) then
					if ((v96 == "Refreshing Healing Potion") or ((2459 + 753) <= (638 + 306))) then
						if (v101.RefreshingHealingPotion:IsReady() or ((12472 - 9376) <= (3243 - (695 + 750)))) then
							if (((12077 - 8540) == (5458 - 1921)) and v24(v102.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((15431 - 11594) >= (1921 - (285 + 66))) and (v96 == "Dreamwalker's Healing Potion")) then
						if (v101.DreamwalkersHealingPotion:IsReady() or ((6876 - 3926) == (5122 - (682 + 628)))) then
							if (((762 + 3961) >= (2617 - (176 + 123))) and v24(v102.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v135()
		local v168 = 0 + 0;
		while true do
			if ((v168 == (0 + 0)) or ((2296 - (239 + 30)) > (776 + 2076))) then
				v30 = v104.HandleTopTrinket(v103, v33, 39 + 1, nil);
				if (v30 or ((2010 - 874) > (13468 - 9151))) then
					return v30;
				end
				v168 = 316 - (306 + 9);
			end
			if (((16568 - 11820) == (826 + 3922)) and (v168 == (1 + 0))) then
				v30 = v104.HandleBottomTrinket(v103, v33, 20 + 20, nil);
				if (((10683 - 6947) <= (6115 - (1140 + 235))) and v30) then
					return v30;
				end
				break;
			end
		end
	end
	local function v136()
		if ((v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 + 0)) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108)) or ((3109 + 281) <= (786 + 2274))) then
			if (v24(v100.Stormkeeper) or ((1051 - (33 + 19)) > (973 + 1720))) then
				return "stormkeeper precombat 2";
			end
		end
		if (((1387 - 924) < (265 + 336)) and v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 - 0)) and v42) then
			if (v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury)) or ((2047 + 136) < (1376 - (586 + 103)))) then
				return "icefury precombat 4";
			end
		end
		if (((415 + 4134) == (14004 - 9455)) and v126(v100.ElementalBlast) and v39) then
			if (((6160 - (1309 + 179)) == (8433 - 3761)) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast precombat 6";
			end
		end
		if ((v13:IsCasting(v100.ElementalBlast) and v47 and ((v64 and v34) or not v64) and v126(v100.PrimordialWave)) or ((1597 + 2071) < (1060 - 665))) then
			if (v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave)) or ((3147 + 1019) == (966 - 511))) then
				return "primordial_wave precombat 8";
			end
		end
		if ((v13:IsCasting(v100.ElementalBlast) and v40 and not v100.PrimordialWave:IsAvailable() and v100.FlameShock:IsCastable()) or ((8864 - 4415) == (3272 - (295 + 314)))) then
			if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((10504 - 6227) < (4951 - (1300 + 662)))) then
				return "flameshock precombat 10";
			end
		end
		if ((v126(v100.LavaBurst) and v44 and not v13:IsCasting(v100.LavaBurst) and (not v100.ElementalBlast:IsAvailable() or (v100.ElementalBlast:IsAvailable() and not v126(v100.ElementalBlast)))) or ((2731 - 1861) >= (5904 - (1178 + 577)))) then
			if (((1149 + 1063) < (9409 - 6226)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lavaburst precombat 12";
			end
		end
		if (((6051 - (851 + 554)) > (2646 + 346)) and v13:IsCasting(v100.LavaBurst) and v40 and v100.FlameShock:IsReady()) then
			if (((3976 - 2542) < (6745 - 3639)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
				return "flameshock precombat 14";
			end
		end
		if (((1088 - (115 + 187)) < (2316 + 707)) and v13:IsCasting(v100.LavaBurst) and v47 and ((v64 and v34) or not v64) and v126(v100.PrimordialWave)) then
			if (v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave)) or ((2312 + 130) < (291 - 217))) then
				return "primordial_wave precombat 16";
			end
		end
	end
	local function v137()
		if (((5696 - (160 + 1001)) == (3968 + 567)) and v100.FireElemental:IsReady() and v53 and ((v59 and v33) or not v59) and (v90 < v108)) then
			if (v24(v100.FireElemental) or ((2077 + 932) <= (4309 - 2204))) then
				return "fire_elemental aoe 2";
			end
		end
		if (((2188 - (237 + 121)) < (4566 - (525 + 372))) and v100.StormElemental:IsReady() and v55 and ((v60 and v33) or not v60) and (v90 < v108)) then
			if (v24(v100.StormElemental) or ((2711 - 1281) >= (11867 - 8255))) then
				return "storm_elemental aoe 4";
			end
		end
		if (((2825 - (96 + 46)) >= (3237 - (643 + 134))) and v126(v100.Stormkeeper) and not v129() and v48 and ((v65 and v34) or not v65) and (v90 < v108)) then
			if (v24(v100.Stormkeeper) or ((652 + 1152) >= (7852 - 4577))) then
				return "stormkeeper aoe 7";
			end
		end
		if ((v100.TotemicRecall:IsCastable() and (v100.LiquidMagmaTotem:CooldownRemains() > (167 - 122)) and v49) or ((1359 + 58) > (7121 - 3492))) then
			if (((9801 - 5006) > (1121 - (316 + 403))) and v24(v100.TotemicRecall)) then
				return "totemic_recall aoe 8";
			end
		end
		if (((3200 + 1613) > (9801 - 6236)) and v100.LiquidMagmaTotem:IsReady() and v54 and ((v61 and v33) or not v61) and (v90 < v108) and (v66 == "cursor")) then
			if (((1414 + 2498) == (9851 - 5939)) and v24(v102.LiquidMagmaTotemCursor, not v16:IsInRange(29 + 11))) then
				return "liquid_magma_totem aoe cursor 10";
			end
		end
		if (((910 + 1911) <= (16714 - 11890)) and v100.LiquidMagmaTotem:IsReady() and v54 and ((v61 and v33) or not v61) and (v90 < v108) and (v66 == "player")) then
			if (((8300 - 6562) <= (4559 - 2364)) and v24(v102.LiquidMagmaTotemPlayer, not v16:IsInRange(3 + 37))) then
				return "liquid_magma_totem aoe player 11";
			end
		end
		if (((80 - 39) <= (148 + 2870)) and v126(v100.PrimordialWave) and v13:BuffDown(v100.PrimordialWaveBuff) and v13:BuffUp(v100.SurgeofPowerBuff) and v13:BuffDown(v100.SplinteredElementsBuff)) then
			local v189 = 0 - 0;
			while true do
				if (((2162 - (12 + 5)) <= (15939 - 11835)) and (v189 == (0 - 0))) then
					if (((5715 - 3026) < (12015 - 7170)) and v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v16:IsSpellInRange(v100.PrimordialWave), nil, nil)) then
						return "primordial_wave aoe 12";
					end
					if (v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave)) or ((472 + 1850) > (4595 - (1656 + 317)))) then
						return "primordial_wave aoe 12";
					end
					break;
				end
			end
		end
		if ((v126(v100.PrimordialWave) and v13:BuffDown(v100.PrimordialWaveBuff) and v100.DeeplyRootedElements:IsAvailable() and not v100.SurgeofPower:IsAvailable() and v13:BuffDown(v100.SplinteredElementsBuff)) or ((4041 + 493) == (1669 + 413))) then
			if (v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v16:IsSpellInRange(v100.PrimordialWave), nil, nil) or ((4177 - 2606) > (9188 - 7321))) then
				return "primordial_wave aoe 14";
			end
			if (v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave)) or ((3008 - (5 + 349)) >= (14230 - 11234))) then
				return "primordial_wave aoe 14";
			end
		end
		if (((5249 - (266 + 1005)) > (1387 + 717)) and v126(v100.PrimordialWave) and v13:BuffDown(v100.PrimordialWaveBuff) and v100.MasteroftheElements:IsAvailable() and not v100.LightningRod:IsAvailable()) then
			if (((10219 - 7224) > (2028 - 487)) and v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v16:IsSpellInRange(v100.PrimordialWave), nil, nil)) then
				return "primordial_wave aoe 16";
			end
			if (((4945 - (561 + 1135)) > (1241 - 288)) and v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave))) then
				return "primordial_wave aoe 16";
			end
		end
		if (v100.FlameShock:IsCastable() or ((10758 - 7485) > (5639 - (507 + 559)))) then
			if ((v13:BuffUp(v100.SurgeofPowerBuff) and v40 and v100.LightningRod:IsAvailable() and v100.WindspeakersLavaResurgence:IsAvailable() and (v16:DebuffRemains(v100.FlameShockDebuff) < (v16:TimeToDie() - (40 - 24))) and (v111 < (15 - 10))) or ((3539 - (212 + 176)) < (2189 - (250 + 655)))) then
				if (v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock)) or ((5044 - 3194) == (2671 - 1142))) then
					return "flame_shock aoe 18";
				end
				if (((1284 - 463) < (4079 - (1869 + 87))) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
					return "flame_shock aoe 18";
				end
			end
			if (((3128 - 2226) < (4226 - (484 + 1417))) and v13:BuffUp(v100.SurgeofPowerBuff) and v40 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable()) and (v100.FlameShockDebuff:AuraActiveCount() < (12 - 6))) then
				local v249 = 0 - 0;
				while true do
					if (((1631 - (48 + 725)) <= (4838 - 1876)) and (v249 == (0 - 0))) then
						if (v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock)) or ((2294 + 1652) < (3442 - 2154))) then
							return "flame_shock aoe 20";
						end
						if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((908 + 2334) == (166 + 401))) then
							return "flame_shock aoe 20";
						end
						break;
					end
				end
			end
			if ((v100.MasteroftheElements:IsAvailable() and v40 and not v100.LightningRod:IsAvailable() and not v100.SurgeofPower:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (859 - (152 + 701)))) or ((2158 - (430 + 881)) >= (484 + 779))) then
				local v250 = 895 - (557 + 338);
				while true do
					if ((v250 == (0 + 0)) or ((6348 - 4095) == (6481 - 4630))) then
						if (v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock)) or ((5544 - 3457) > (5111 - 2739))) then
							return "flame_shock aoe 22";
						end
						if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((5246 - (499 + 302)) < (5015 - (39 + 827)))) then
							return "flame_shock aoe 22";
						end
						break;
					end
				end
			end
			if ((v100.DeeplyRootedElements:IsAvailable() and v40 and not v100.SurgeofPower:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (16 - 10))) or ((4059 - 2241) == (337 - 252))) then
				if (((967 - 337) < (183 + 1944)) and v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock))) then
					return "flame_shock aoe 24";
				end
				if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((5672 - 3734) == (403 + 2111))) then
					return "flame_shock aoe 24";
				end
			end
			if (((6733 - 2478) >= (159 - (103 + 1))) and v13:BuffUp(v100.SurgeofPowerBuff) and v40 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable())) then
				local v251 = 554 - (475 + 79);
				while true do
					if (((6482 - 3483) > (3699 - 2543)) and (v251 == (0 + 0))) then
						if (((2069 + 281) > (2658 - (1395 + 108))) and v104.CastCycle(v100.FlameShock, v112, v121, not v16:IsSpellInRange(v100.FlameShock))) then
							return "flame_shock aoe 26";
						end
						if (((11724 - 7695) <= (6057 - (7 + 1197))) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
							return "flame_shock aoe 26";
						end
						break;
					end
				end
			end
			if ((v100.MasteroftheElements:IsAvailable() and v40 and not v100.LightningRod:IsAvailable() and not v100.SurgeofPower:IsAvailable()) or ((225 + 291) > (1199 + 2235))) then
				local v252 = 319 - (27 + 292);
				while true do
					if (((11855 - 7809) >= (3867 - 834)) and (v252 == (0 - 0))) then
						if (v104.CastCycle(v100.FlameShock, v112, v121, not v16:IsSpellInRange(v100.FlameShock)) or ((5361 - 2642) <= (2755 - 1308))) then
							return "flame_shock aoe 28";
						end
						if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((4273 - (43 + 96)) < (16014 - 12088))) then
							return "flame_shock aoe 28";
						end
						break;
					end
				end
			end
			if ((v100.DeeplyRootedElements:IsAvailable() and v40 and not v100.SurgeofPower:IsAvailable()) or ((370 - 206) >= (2311 + 474))) then
				local v253 = 0 + 0;
				while true do
					if ((v253 == (0 - 0)) or ((202 + 323) == (3952 - 1843))) then
						if (((11 + 22) == (3 + 30)) and v104.CastCycle(v100.FlameShock, v112, v121, not v16:IsSpellInRange(v100.FlameShock))) then
							return "flame_shock aoe 30";
						end
						if (((4805 - (1414 + 337)) <= (5955 - (1642 + 298))) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
							return "flame_shock aoe 30";
						end
						break;
					end
				end
			end
		end
		if (((4877 - 3006) < (9729 - 6347)) and v100.Ascendance:IsCastable() and v52 and ((v58 and v33) or not v58) and (v90 < v108)) then
			if (((3836 - 2543) <= (713 + 1453)) and v24(v100.Ascendance)) then
				return "ascendance aoe 32";
			end
		end
		if ((v126(v100.LavaBurst) and (v114 == (3 + 0)) and not v100.LightningRod:IsAvailable() and v13:HasTier(1003 - (357 + 615), 3 + 1)) or ((6327 - 3748) < (106 + 17))) then
			local v190 = 0 - 0;
			while true do
				if ((v190 == (0 + 0)) or ((58 + 788) >= (1489 + 879))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((5313 - (384 + 917)) <= (4055 - (128 + 569)))) then
						return "lava_burst aoe 34";
					end
					if (((3037 - (1407 + 136)) <= (4892 - (687 + 1200))) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 34";
					end
					break;
				end
			end
		end
		if ((v37 and v100.Earthquake:IsReady() and v127() and (((v13:BuffStack(v100.MagmaChamberBuff) > (1725 - (556 + 1154))) and (v114 >= ((24 - 17) - v25(v100.UnrelentingCalamity:IsAvailable())))) or (v100.SplinteredElements:IsAvailable() and (v114 >= ((105 - (9 + 86)) - v25(v100.UnrelentingCalamity:IsAvailable())))) or (v100.MountainsWillFall:IsAvailable() and (v114 >= (430 - (275 + 146))))) and not v100.LightningRod:IsAvailable() and v13:HasTier(6 + 25, 68 - (29 + 35))) or ((13787 - 10676) == (6373 - 4239))) then
			local v191 = 0 - 0;
			while true do
				if (((1534 + 821) == (3367 - (53 + 959))) and (v191 == (408 - (312 + 96)))) then
					if ((v51 == "cursor") or ((1020 - 432) <= (717 - (147 + 138)))) then
						if (((5696 - (813 + 86)) >= (3520 + 375)) and v24(v102.EarthquakeCursor, not v16:IsInRange(74 - 34))) then
							return "earthquake aoe 36";
						end
					end
					if (((4069 - (18 + 474)) == (1207 + 2370)) and (v51 == "player")) then
						if (((12382 - 8588) > (4779 - (860 + 226))) and v24(v102.EarthquakePlayer, not v16:IsInRange(343 - (121 + 182)))) then
							return "earthquake aoe 36";
						end
					end
					break;
				end
			end
		end
		if ((v126(v100.LavaBeam) and v43 and v129() and ((v13:BuffUp(v100.SurgeofPowerBuff) and (v114 >= (1 + 5))) or (v127() and ((v114 < (1246 - (988 + 252))) or not v100.SurgeofPower:IsAvailable()))) and not v100.LightningRod:IsAvailable() and v13:HasTier(4 + 27, 2 + 2)) or ((3245 - (49 + 1921)) == (4990 - (223 + 667)))) then
			if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((1643 - (51 + 1)) >= (6161 - 2581))) then
				return "lava_beam aoe 38";
			end
		end
		if (((2104 - 1121) <= (2933 - (146 + 979))) and v126(v100.ChainLightning) and v36 and v129() and ((v13:BuffUp(v100.SurgeofPowerBuff) and (v114 >= (2 + 4))) or (v127() and ((v114 < (611 - (311 + 294))) or not v100.SurgeofPower:IsAvailable()))) and not v100.LightningRod:IsAvailable() and v13:HasTier(86 - 55, 2 + 2)) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((3593 - (496 + 947)) <= (2555 - (1233 + 125)))) then
				return "chain_lightning aoe 40";
			end
		end
		if (((1530 + 2239) >= (1053 + 120)) and v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and not v100.LightningRod:IsAvailable() and v13:HasTier(6 + 25, 1649 - (963 + 682))) then
			local v192 = 0 + 0;
			while true do
				if (((2989 - (504 + 1000)) == (1001 + 484)) and (v192 == (0 + 0))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((313 + 3002) <= (4101 - 1319))) then
						return "lava_burst aoe 42";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((749 + 127) >= (1724 + 1240))) then
						return "lava_burst aoe 42";
					end
					break;
				end
			end
		end
		if ((v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and v100.MasteroftheElements:IsAvailable() and not v127() and (v125() >= (((242 - (156 + 26)) - ((3 + 2) * v100.EyeoftheStorm:TalentRank())) - ((2 - 0) * v25(v100.FlowofPower:IsAvailable())))) and ((not v100.EchoesofGreatSundering:IsAvailable() and not v100.LightningRod:IsAvailable()) or v13:BuffUp(v100.EchoesofGreatSunderingBuff)) and ((not v13:BuffUp(v100.AscendanceBuff) and (v114 > (167 - (149 + 15))) and v100.UnrelentingCalamity:IsAvailable()) or ((v114 > (963 - (890 + 70))) and not v100.UnrelentingCalamity:IsAvailable()) or (v114 == (120 - (39 + 78))))) or ((2714 - (14 + 468)) > (5490 - 2993))) then
			local v193 = 0 - 0;
			while true do
				if ((v193 == (0 + 0)) or ((1268 + 842) <= (71 + 261))) then
					if (((1665 + 2021) > (832 + 2340)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 44";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((8563 - 4089) < (811 + 9))) then
						return "lava_burst aoe 44";
					end
					break;
				end
			end
		end
		if (((15036 - 10757) >= (73 + 2809)) and v37 and v100.Earthquake:IsReady() and not v100.EchoesofGreatSundering:IsAvailable() and (v114 > (54 - (12 + 39))) and ((v114 > (3 + 0)) or (v113 > (9 - 6)))) then
			local v194 = 0 - 0;
			while true do
				if (((0 + 0) == v194) or ((1069 + 960) >= (8928 - 5407))) then
					if ((v51 == "cursor") or ((1357 + 680) >= (22433 - 17791))) then
						if (((3430 - (1596 + 114)) < (11639 - 7181)) and v24(v102.EarthquakeCursor, not v16:IsInRange(753 - (164 + 549)))) then
							return "earthquake aoe 46";
						end
					end
					if ((v51 == "player") or ((1874 - (1059 + 379)) > (3751 - 730))) then
						if (((370 + 343) <= (143 + 704)) and v24(v102.EarthquakePlayer, not v16:IsInRange(432 - (145 + 247)))) then
							return "earthquake aoe 46";
						end
					end
					break;
				end
			end
		end
		if (((1768 + 386) <= (1863 + 2168)) and v37 and v100.Earthquake:IsReady() and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (v114 == (8 - 5)) and ((v114 == (1 + 2)) or (v113 == (3 + 0)))) then
			local v195 = 0 - 0;
			while true do
				if (((5335 - (254 + 466)) == (5175 - (544 + 16))) and ((0 - 0) == v195)) then
					if ((v51 == "cursor") or ((4418 - (294 + 334)) == (753 - (236 + 17)))) then
						if (((39 + 50) < (173 + 48)) and v24(v102.EarthquakeCursor, not v16:IsInRange(150 - 110))) then
							return "earthquake aoe 48";
						end
					end
					if (((9724 - 7670) >= (732 + 689)) and (v51 == "player")) then
						if (((570 + 122) < (3852 - (413 + 381))) and v24(v102.EarthquakePlayer, not v16:IsInRange(2 + 38))) then
							return "earthquake aoe 48";
						end
					end
					break;
				end
			end
		end
		if ((v37 and v100.Earthquake:IsReady() and (v13:BuffUp(v100.EchoesofGreatSunderingBuff))) or ((6920 - 3666) == (4299 - 2644))) then
			if ((v51 == "cursor") or ((3266 - (582 + 1388)) == (8365 - 3455))) then
				if (((2411 + 957) == (3732 - (326 + 38))) and v24(v102.EarthquakeCursor, not v16:IsInRange(118 - 78))) then
					return "earthquake aoe 50";
				end
			end
			if (((3772 - 1129) < (4435 - (47 + 573))) and (v51 == "player")) then
				if (((675 + 1238) > (2093 - 1600)) and v24(v102.EarthquakePlayer, not v16:IsInRange(64 - 24))) then
					return "earthquake aoe 50";
				end
			end
		end
		if (((6419 - (1269 + 395)) > (3920 - (76 + 416))) and v126(v100.ElementalBlast) and v39 and v100.EchoesofGreatSundering:IsAvailable()) then
			local v196 = 443 - (319 + 124);
			while true do
				if (((3156 - 1775) <= (3376 - (564 + 443))) and (v196 == (0 - 0))) then
					if (v104.CastTargetIf(v100.ElementalBlast, v112, "min", v124, nil, not v16:IsSpellInRange(v100.ElementalBlast), nil, nil) or ((5301 - (337 + 121)) == (11965 - 7881))) then
						return "elemental_blast aoe 52";
					end
					if (((15552 - 10883) > (2274 - (1261 + 650))) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast aoe 52";
					end
					break;
				end
			end
		end
		if ((v126(v100.ElementalBlast) and v39 and v100.EchoesofGreatSundering:IsAvailable()) or ((795 + 1082) >= (5000 - 1862))) then
			if (((6559 - (772 + 1045)) >= (512 + 3114)) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast aoe 54";
			end
		end
		if ((v126(v100.ElementalBlast) and v39 and (v114 == (147 - (102 + 42))) and not v100.EchoesofGreatSundering:IsAvailable()) or ((6384 - (1524 + 320)) == (2186 - (1049 + 221)))) then
			if (v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast)) or ((1312 - (18 + 138)) > (10635 - 6290))) then
				return "elemental_blast aoe 56";
			end
		end
		if (((3339 - (67 + 1035)) < (4597 - (136 + 212))) and v100.EarthShock:IsCastable() and v38 and v100.EchoesofGreatSundering:IsAvailable()) then
			local v197 = 0 - 0;
			while true do
				if ((v197 == (0 + 0)) or ((2474 + 209) < (1627 - (240 + 1364)))) then
					if (((1779 - (1050 + 32)) <= (2949 - 2123)) and v104.CastTargetIf(v100.EarthShock, v112, "min", v124, nil, not v16:IsSpellInRange(v100.EarthShock), nil, nil)) then
						return "earth_shock aoe 58";
					end
					if (((654 + 451) <= (2231 - (331 + 724))) and v24(v100.EarthShock, not v16:IsSpellInRange(v100.EarthShock))) then
						return "earth_shock aoe 58";
					end
					break;
				end
			end
		end
		if (((273 + 3106) <= (4456 - (269 + 375))) and v100.EarthShock:IsCastable() and v38 and v100.EchoesofGreatSundering:IsAvailable()) then
			if (v24(v100.EarthShock, not v16:IsSpellInRange(v100.EarthShock)) or ((1513 - (267 + 458)) >= (503 + 1113))) then
				return "earth_shock aoe 60";
			end
		end
		if (((3564 - 1710) <= (4197 - (667 + 151))) and v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (1497 - (1410 + 87))) and v42 and not v13:BuffUp(v100.AscendanceBuff) and v100.ElectrifiedShocks:IsAvailable() and ((v100.LightningRod:IsAvailable() and (v114 < (1902 - (1504 + 393))) and not v127()) or (v100.DeeplyRootedElements:IsAvailable() and (v114 == (8 - 5))))) then
			if (((11801 - 7252) == (5345 - (461 + 335))) and v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury))) then
				return "icefury aoe 62";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and not v13:BuffUp(v100.AscendanceBuff) and v13:BuffUp(v100.IcefuryBuff) and v100.ElectrifiedShocks:IsAvailable() and (not v16:DebuffUp(v100.ElectrifiedShocksDebuff) or (v13:BuffRemains(v100.IcefuryBuff) < v13:GCD())) and ((v100.LightningRod:IsAvailable() and (v114 < (1 + 4)) and not v127()) or (v100.DeeplyRootedElements:IsAvailable() and (v114 == (1764 - (1730 + 31)))))) or ((4689 - (728 + 939)) >= (10709 - 7685))) then
			if (((9776 - 4956) > (5036 - 2838)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock aoe 64";
			end
		end
		if ((v126(v100.LavaBurst) and v100.MasteroftheElements:IsAvailable() and not v127() and (v129() or ((v118() < (1071 - (138 + 930))) and v13:HasTier(28 + 2, 2 + 0))) and (v125() < ((((52 + 8) - ((20 - 15) * v100.EyeoftheStorm:TalentRank())) - ((1768 - (459 + 1307)) * v25(v100.FlowofPower:IsAvailable()))) - (1880 - (474 + 1396)))) and (v114 < (8 - 3))) or ((995 + 66) >= (16 + 4875))) then
			local v198 = 0 - 0;
			while true do
				if (((173 + 1191) <= (14932 - 10459)) and (v198 == (0 - 0))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((4186 - (562 + 29)) <= (3 + 0))) then
						return "lava_burst aoe 66";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((6091 - (374 + 1045)) == (3049 + 803))) then
						return "lava_burst aoe 66";
					end
					break;
				end
			end
		end
		if (((4840 - 3281) == (2197 - (448 + 190))) and v126(v100.LavaBeam) and v43 and (v129())) then
			if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((566 + 1186) <= (356 + 432))) then
				return "lava_beam aoe 68";
			end
		end
		if ((v126(v100.ChainLightning) and v36 and (v129())) or ((2546 + 1361) == (680 - 503))) then
			if (((10782 - 7312) > (2049 - (1307 + 187))) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning aoe 70";
			end
		end
		if ((v126(v100.LavaBeam) and v43 and v128() and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((3854 - 2882) == (1510 - 865))) then
			if (((9756 - 6574) >= (2798 - (232 + 451))) and v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam aoe 72";
			end
		end
		if (((3718 + 175) < (3913 + 516)) and v126(v100.ChainLightning) and v36 and v128()) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((3431 - (510 + 54)) < (3838 - 1933))) then
				return "chain_lightning aoe 74";
			end
		end
		if ((v126(v100.LavaBeam) and v43 and (v114 >= (42 - (13 + 23))) and v13:BuffUp(v100.SurgeofPowerBuff) and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((3500 - 1704) >= (5820 - 1769))) then
			if (((2941 - 1322) <= (4844 - (830 + 258))) and v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam aoe 76";
			end
		end
		if (((2130 - 1526) == (378 + 226)) and v126(v100.ChainLightning) and v36 and (v114 >= (6 + 0)) and v13:BuffUp(v100.SurgeofPowerBuff)) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((5925 - (860 + 581)) == (3319 - 2419))) then
				return "chain_lightning aoe 78";
			end
		end
		if ((v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable() and v13:BuffUp(v100.WindspeakersLavaResurgenceBuff)) or ((3539 + 920) <= (1354 - (237 + 4)))) then
			if (((8535 - 4903) > (8596 - 5198)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst aoe 80";
			end
			if (((7738 - 3656) <= (4025 + 892)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst aoe 80";
			end
		end
		if (((2776 + 2056) >= (5232 - 3846)) and v126(v100.LavaBeam) and v43 and v127() and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) then
			if (((59 + 78) == (75 + 62)) and v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam aoe 82";
			end
		end
		if ((v126(v100.LavaBurst) and (v114 == (1429 - (85 + 1341))) and v100.MasteroftheElements:IsAvailable()) or ((2678 - 1108) >= (12234 - 7902))) then
			local v199 = 372 - (45 + 327);
			while true do
				if ((v199 == (0 - 0)) or ((4566 - (444 + 58)) <= (791 + 1028))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((858 + 4128) < (770 + 804))) then
						return "lava_burst aoe 84";
					end
					if (((12826 - 8400) > (1904 - (64 + 1668))) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 84";
					end
					break;
				end
			end
		end
		if (((2559 - (1227 + 746)) > (1398 - 943)) and v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable()) then
			local v200 = 0 - 0;
			while true do
				if (((1320 - (415 + 79)) == (22 + 804)) and (v200 == (491 - (142 + 349)))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((1722 + 2297) > (6106 - 1665))) then
						return "lava_burst aoe 86";
					end
					if (((1003 + 1014) < (3003 + 1258)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 86";
					end
					break;
				end
			end
		end
		if (((12842 - 8126) > (1944 - (1710 + 154))) and v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (318 - (200 + 118))) and v42 and v100.ElectrifiedShocks:IsAvailable() and (v114 < (2 + 3))) then
			if (v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury)) or ((6131 - 2624) == (4852 - 1580))) then
				return "icefury aoe 88";
			end
		end
		if ((v126(v100.FrostShock) and v41 and v13:BuffUp(v100.IcefuryBuff) and v100.ElectrifiedShocks:IsAvailable() and not v16:DebuffUp(v100.ElectrifiedShocksDebuff) and (v114 < (5 + 0)) and v100.UnrelentingCalamity:IsAvailable()) or ((867 + 9) >= (1651 + 1424))) then
			if (((695 + 3657) > (5532 - 2978)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock aoe 90";
			end
		end
		if ((v126(v100.LavaBeam) and v43 and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((5656 - (363 + 887)) < (7059 - 3016))) then
			if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((8991 - 7102) >= (523 + 2860))) then
				return "lava_beam aoe 92";
			end
		end
		if (((4426 - 2534) <= (1869 + 865)) and v126(v100.ChainLightning) and v36) then
			if (((3587 - (674 + 990)) < (636 + 1582)) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning aoe 94";
			end
		end
		if (((890 + 1283) > (600 - 221)) and v100.FlameShock:IsCastable() and v40 and v13:IsMoving() and v16:DebuffRefreshable(v100.FlameShockDebuff)) then
			if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((3646 - (507 + 548)) == (4246 - (289 + 548)))) then
				return "flame_shock aoe 96";
			end
		end
		if (((6332 - (821 + 997)) > (3579 - (195 + 60))) and v100.FrostShock:IsCastable() and v41 and v13:IsMoving()) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((56 + 152) >= (6329 - (251 + 1250)))) then
				return "frost_shock aoe 98";
			end
		end
	end
	local function v138()
		if ((v100.FireElemental:IsCastable() and v53 and ((v59 and v33) or not v59) and (v90 < v108)) or ((4637 - 3054) > (2451 + 1116))) then
			if (v24(v100.FireElemental) or ((2345 - (809 + 223)) == (1157 - 363))) then
				return "fire_elemental single_target 2";
			end
		end
		if (((9531 - 6357) > (9595 - 6693)) and v100.StormElemental:IsCastable() and v55 and ((v60 and v33) or not v60) and (v90 < v108)) then
			if (((3035 + 1085) <= (2231 + 2029)) and v24(v100.StormElemental)) then
				return "storm_elemental single_target 4";
			end
		end
		if ((v100.TotemicRecall:IsCastable() and v49 and (v100.LiquidMagmaTotem:CooldownRemains() > (662 - (14 + 603))) and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or ((v113 > (130 - (118 + 11))) and (v114 > (1 + 0))))) or ((736 + 147) > (13924 - 9146))) then
			if (v24(v100.TotemicRecall) or ((4569 - (551 + 398)) >= (3091 + 1800))) then
				return "totemic_recall single_target 6";
			end
		end
		if (((1516 + 2742) > (762 + 175)) and v100.LiquidMagmaTotem:IsCastable() and v54 and ((v61 and v33) or not v61) and (v90 < v108) and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or (v100.FlameShockDebuff:AuraActiveCount() == (0 - 0)) or (v16:DebuffRemains(v100.FlameShockDebuff) < (13 - 7)) or ((v113 > (1 + 0)) and (v114 > (3 - 2))))) then
			local v201 = 0 + 0;
			while true do
				if (((89 - (40 + 49)) == v201) or ((18541 - 13672) < (1396 - (99 + 391)))) then
					if ((v66 == "cursor") or ((1014 + 211) > (18586 - 14358))) then
						if (((8241 - 4913) > (2180 + 58)) and v24(v102.LiquidMagmaTotemCursor, not v16:IsInRange(105 - 65))) then
							return "liquid_magma_totem single_target cursor 8";
						end
					end
					if (((5443 - (1032 + 572)) > (1822 - (203 + 214))) and (v66 == "player")) then
						if (v24(v102.LiquidMagmaTotemPlayer, not v16:IsInRange(1857 - (568 + 1249))) or ((1012 + 281) <= (1217 - 710))) then
							return "liquid_magma_totem single_target player 8";
						end
					end
					break;
				end
			end
		end
		if ((v126(v100.PrimordialWave) and v100.PrimordialWave:IsCastable() and v47 and ((v64 and v34) or not v64) and not v13:BuffUp(v100.PrimordialWaveBuff) and not v13:BuffUp(v100.SplinteredElementsBuff)) or ((11185 - 8289) < (2111 - (913 + 393)))) then
			if (((6540 - 4224) == (3271 - 955)) and v104.CastCycle(v100.PrimordialWave, v112, v122, not v16:IsSpellInRange(v100.PrimordialWave))) then
				return "primordial_wave single_target 10";
			end
			if (v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave)) or ((2980 - (269 + 141)) == (3409 - 1876))) then
				return "primordial_wave single_target 10";
			end
		end
		if ((v100.FlameShock:IsCastable() and v40 and (v113 == (1982 - (362 + 1619))) and v16:DebuffRefreshable(v100.FlameShockDebuff) and ((v16:DebuffRemains(v100.FlameShockDebuff) < v100.PrimordialWave:CooldownRemains()) or not v100.PrimordialWave:IsAvailable()) and v13:BuffDown(v100.SurgeofPowerBuff) and (not v127() or (not v129() and ((v100.ElementalBlast:IsAvailable() and (v125() < ((1715 - (950 + 675)) - ((4 + 4) * v100.EyeoftheStorm:TalentRank())))) or (v125() < ((1239 - (216 + 963)) - ((1292 - (485 + 802)) * v100.EyeoftheStorm:TalentRank()))))))) or ((1442 - (432 + 127)) == (2533 - (1065 + 8)))) then
			if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((2566 + 2053) <= (2600 - (635 + 966)))) then
				return "flame_shock single_target 12";
			end
		end
		if ((v100.FlameShock:IsCastable() and v40 and (v100.FlameShockDebuff:AuraActiveCount() == (0 + 0)) and (v113 > (43 - (5 + 37))) and (v114 > (2 - 1)) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((not v127() and (v129() or (v100.Stormkeeper:CooldownRemains() > (0 + 0)))) or not v100.SurgeofPower:IsAvailable())) or ((5397 - 1987) > (1926 + 2190))) then
			if (v104.CastTargetIf(v100.FlameShock, v112, "min", v122, nil, not v16:IsSpellInRange(v100.FlameShock)) or ((1875 - 972) >= (11597 - 8538))) then
				return "flame_shock single_target 14";
			end
			if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((7498 - 3522) < (6830 - 3973))) then
				return "flame_shock single_target 14";
			end
		end
		if (((3545 + 1385) > (2836 - (318 + 211))) and v100.FlameShock:IsCastable() and v40 and (v113 > (4 - 3)) and (v114 > (1588 - (963 + 624))) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((v13:BuffUp(v100.SurgeofPowerBuff) and not v129() and v100.Stormkeeper:CooldownDown()) or not v100.SurgeofPower:IsAvailable())) then
			if (v104.CastTargetIf(v100.FlameShock, v112, "min", v122, v119, not v16:IsSpellInRange(v100.FlameShock)) or ((1730 + 2316) < (2137 - (518 + 328)))) then
				return "flame_shock single_target 16";
			end
			if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((9886 - 5645) == (5665 - 2120))) then
				return "flame_shock single_target 16";
			end
		end
		if ((v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (317 - (301 + 16))) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108) and v13:BuffDown(v100.AscendanceBuff) and not v129() and (v125() >= (339 - 223)) and v100.ElementalBlast:IsAvailable() and v100.SurgeofPower:IsAvailable() and v100.SwellingMaelstrom:IsAvailable() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) or ((11368 - 7320) > (11042 - 6810))) then
			if (v24(v100.Stormkeeper) or ((1586 + 164) >= (1972 + 1501))) then
				return "stormkeeper single_target 18";
			end
		end
		if (((6758 - 3592) == (1905 + 1261)) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 + 0)) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108) and v13:BuffDown(v100.AscendanceBuff) and not v129() and v13:BuffUp(v100.SurgeofPowerBuff) and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) then
			if (((5605 - 3842) < (1202 + 2522)) and v24(v100.Stormkeeper)) then
				return "stormkeeper single_target 20";
			end
		end
		if (((1076 - (829 + 190)) <= (9715 - 6992)) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 - 0)) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108) and v13:BuffDown(v100.AscendanceBuff) and not v129() and (not v100.SurgeofPower:IsAvailable() or not v100.ElementalBlast:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.EchooftheElements:IsAvailable() or v100.PrimordialSurge:IsAvailable())) then
			if (v24(v100.Stormkeeper) or ((2861 - 791) == (1100 - 657))) then
				return "stormkeeper single_target 22";
			end
		end
		if ((v100.Ascendance:IsCastable() and v52 and ((v58 and v33) or not v58) and (v90 < v108) and not v129()) or ((642 + 2063) == (456 + 937))) then
			if (v24(v100.Ascendance) or ((13965 - 9364) < (58 + 3))) then
				return "ascendance single_target 24";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v129() and v13:BuffUp(v100.SurgeofPowerBuff)) or ((2003 - (520 + 93)) >= (5020 - (259 + 17)))) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((116 + 1887) > (1380 + 2454))) then
				return "lightning_bolt single_target 26";
			end
		end
		if ((v100.LavaBeam:IsCastable() and v43 and (v113 > (3 - 2)) and (v114 > (592 - (396 + 195))) and v129() and not v100.SurgeofPower:IsAvailable()) or ((452 - 296) > (5674 - (440 + 1321)))) then
			if (((2024 - (1059 + 770)) == (901 - 706)) and v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam single_target 28";
			end
		end
		if (((3650 - (424 + 121)) >= (328 + 1468)) and v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and (v113 > (1348 - (641 + 706))) and (v114 > (1 + 0)) and v129() and not v100.SurgeofPower:IsAvailable()) then
			if (((4819 - (249 + 191)) >= (9283 - 7152)) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 30";
			end
		end
		if (((1717 + 2127) >= (7873 - 5830)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v129() and not v127() and not v100.SurgeofPower:IsAvailable() and v100.MasteroftheElements:IsAvailable()) then
			if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((3659 - (183 + 244)) <= (135 + 2596))) then
				return "lava_burst single_target 32";
			end
		end
		if (((5635 - (434 + 296)) == (15652 - 10747)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v129() and not v100.SurgeofPower:IsAvailable() and v127()) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((4648 - (169 + 343)) >= (3867 + 544))) then
				return "lightning_bolt single_target 34";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v129() and not v100.SurgeofPower:IsAvailable() and not v100.MasteroftheElements:IsAvailable()) or ((5204 - 2246) == (11790 - 7773))) then
			if (((1007 + 221) >= (2305 - 1492)) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 36";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v13:BuffUp(v100.SurgeofPowerBuff) and v100.LightningRod:IsAvailable()) or ((4578 - (651 + 472)) > (3061 + 989))) then
			if (((105 + 138) == (295 - 52)) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 38";
			end
		end
		if ((v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (483 - (397 + 86))) and v42 and v100.ElectrifiedShocks:IsAvailable() and v100.LightningRod:IsAvailable() and v100.LightningRod:IsAvailable()) or ((1147 - (423 + 453)) > (160 + 1412))) then
			if (((362 + 2377) < (2875 + 418)) and v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury))) then
				return "icefury single_target 40";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and v100.ElectrifiedShocks:IsAvailable() and ((v16:DebuffRemains(v100.ElectrifiedShocksDebuff) < (2 + 0)) or (v13:BuffRemains(v100.IcefuryBuff) <= v13:GCD())) and v100.LightningRod:IsAvailable()) or ((3522 + 420) < (2324 - (50 + 1140)))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((2328 + 365) == (2937 + 2036))) then
				return "frost_shock single_target 42";
			end
		end
		if (((134 + 2012) == (3081 - 935)) and v100.FrostShock:IsCastable() and v41 and v130() and v100.ElectrifiedShocks:IsAvailable() and (v125() >= (37 + 13)) and (v16:DebuffRemains(v100.ElectrifiedShocksDebuff) < ((598 - (157 + 439)) * v13:GCD())) and v129() and v100.LightningRod:IsAvailable()) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((3901 - 1657) == (10712 - 7488))) then
				return "frost_shock single_target 44";
			end
		end
		if ((v100.LavaBeam:IsCastable() and v43 and (v113 > (2 - 1)) and (v114 > (919 - (782 + 136))) and v128() and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime()) and not v13:HasTier(886 - (112 + 743), 1175 - (1026 + 145))) or ((842 + 4062) <= (2634 - (493 + 225)))) then
			if (((330 - 240) <= (648 + 417)) and v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam single_target 46";
			end
		end
		if (((12874 - 8072) == (92 + 4710)) and v100.FrostShock:IsCastable() and v41 and v130() and v129() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable() and v100.ElementalBlast:IsAvailable() and (((v125() >= (174 - 113)) and (v125() < (22 + 53)) and (v100.LavaBurst:CooldownRemains() > v13:GCD())) or ((v125() >= (81 - 32)) and (v125() < (1658 - (210 + 1385))) and (v100.LavaBurst:CooldownRemains() > (1689 - (1201 + 488)))))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((1414 + 866) <= (908 - 397))) then
				return "frost_shock single_target 48";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (((v125() >= (64 - 28)) and (v125() < (635 - (352 + 233))) and (v100.LavaBurst:CooldownRemains() > v13:GCD())) or ((v125() >= (57 - 33)) and (v125() < (21 + 17)) and v100.LavaBurst:CooldownUp()))) or ((4765 - 3089) <= (1037 - (489 + 85)))) then
			if (((5370 - (277 + 1224)) == (5362 - (663 + 830))) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 50";
			end
		end
		if (((1018 + 140) <= (6398 - 3785)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffUp(v100.WindspeakersLavaResurgenceBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or ((v125() >= (938 - (461 + 414))) and v100.MasteroftheElements:IsAvailable()) or ((v125() >= (7 + 31)) and v13:BuffUp(v100.EchoesofGreatSunderingBuff) and (v113 > (1 + 0)) and (v114 > (1 + 0))) or not v100.ElementalBlast:IsAvailable())) then
			if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((2331 + 33) <= (2249 - (172 + 78)))) then
				return "lava_burst single_target 52";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffUp(v100.LavaSurgeBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or not v100.ElementalBlast:IsAvailable())) or ((7935 - 3013) < (72 + 122))) then
			if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((3017 - 926) < (9 + 22))) then
				return "lava_burst single_target 54";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffUp(v100.AscendanceBuff) and (v13:HasTier(11 + 20, 6 - 2) or not v100.ElementalBlast:IsAvailable())) or ((3058 - 628) >= (1225 + 3647))) then
			if (v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst)) or ((2638 + 2132) < (618 + 1117))) then
				return "lava_burst single_target 56";
			end
			if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((17670 - 13231) <= (5475 - 3125))) then
				return "lava_burst single_target 56";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffDown(v100.AscendanceBuff) and (not v100.ElementalBlast:IsAvailable() or not v100.MountainsWillFall:IsAvailable()) and not v100.LightningRod:IsAvailable() and v13:HasTier(10 + 21, 3 + 1)) or ((4926 - (133 + 314)) < (777 + 3689))) then
			if (((2760 - (199 + 14)) > (4385 - 3160)) and v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 58";
			end
			if (((6220 - (647 + 902)) > (8040 - 5366)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 58";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v100.MasteroftheElements:IsAvailable() and not v127() and not v100.LightningRod:IsAvailable()) or ((3929 - (85 + 148)) < (4616 - (426 + 863)))) then
			if (v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst)) or ((21257 - 16715) == (4624 - (873 + 781)))) then
				return "lava_burst single_target 60";
			end
			if (((337 - 85) <= (5338 - 3361)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 60";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v100.MasteroftheElements:IsAvailable() and not v127() and ((v125() >= (32 + 43)) or ((v125() >= (184 - 134)) and not v100.ElementalBlast:IsAvailable())) and v100.SwellingMaelstrom:IsAvailable() and (v125() <= (186 - 56))) or ((4263 - 2827) == (5722 - (414 + 1533)))) then
			if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((1403 + 215) < (1485 - (443 + 112)))) then
				return "lava_burst single_target 62";
			end
		end
		if (((6202 - (888 + 591)) > (10730 - 6577)) and v100.Earthquake:IsReady() and v37 and v13:BuffUp(v100.EchoesofGreatSunderingBuff) and ((not v100.ElementalBlast:IsAvailable() and (v113 < (1 + 1))) or (v113 > (3 - 2)))) then
			local v202 = 0 + 0;
			while true do
				if (((0 + 0) == v202) or ((391 + 3263) >= (8868 - 4214))) then
					if (((1761 - 810) <= (3174 - (136 + 1542))) and (v51 == "cursor")) then
						if (v24(v102.EarthquakeCursor, not v16:IsInRange(131 - 91)) or ((1723 + 13) == (907 - 336))) then
							return "earthquake single_target 64";
						end
					end
					if ((v51 == "player") or ((649 + 247) > (5255 - (68 + 418)))) then
						if (v24(v102.EarthquakePlayer, not v16:IsInRange(108 - 68)) or ((1896 - 851) <= (881 + 139))) then
							return "earthquake single_target 64";
						end
					end
					break;
				end
			end
		end
		if ((v100.Earthquake:IsReady() and v37 and (v113 > (1093 - (770 + 322))) and (v114 > (1 + 0)) and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable()) or ((336 + 824) <= (45 + 283))) then
			if (((5447 - 1639) > (5669 - 2745)) and (v51 == "cursor")) then
				if (((10597 - 6706) < (18093 - 13174)) and v24(v102.EarthquakeCursor, not v16:IsInRange(23 + 17))) then
					return "earthquake single_target 66";
				end
			end
			if ((v51 == "player") or ((3346 - 1112) <= (721 + 781))) then
				if (v24(v102.EarthquakePlayer, not v16:IsInRange(25 + 15)) or ((1969 + 543) < (1626 - 1194))) then
					return "earthquake single_target 66";
				end
			end
		end
		if ((v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v39 and (not v100.MasteroftheElements:IsAvailable() or (v127() and v16:DebuffUp(v100.ElectrifiedShocksDebuff)))) or ((2566 - 718) == (293 + 572))) then
			if (v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast)) or ((21567 - 16885) <= (15010 - 10469))) then
				return "elemental_blast single_target 68";
			end
		end
		if ((v126(v100.FrostShock) and v41 and v130() and v127() and (v125() < (46 + 64)) and (v100.LavaBurst:ChargesFractional() < (4 - 3)) and v100.ElectrifiedShocks:IsAvailable() and v100.ElementalBlast:IsAvailable() and not v100.LightningRod:IsAvailable()) or ((3857 - (762 + 69)) >= (13101 - 9055))) then
			if (((1730 + 278) > (414 + 224)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 70";
			end
		end
		if (((4293 - 2518) <= (1018 + 2215)) and v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v39 and (v127() or v100.LightningRod:IsAvailable())) then
			if (v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast)) or ((73 + 4470) == (7780 - 5783))) then
				return "elemental_blast single_target 72";
			end
		end
		if ((v100.EarthShock:IsCastable() and v38) or ((3259 - (8 + 149)) < (2048 - (1199 + 121)))) then
			if (((583 - 238) == (778 - 433)) and v24(v100.EarthShock, not v16:IsSpellInRange(v100.EarthShock))) then
				return "earth_shock single_target 74";
			end
		end
		if ((v126(v100.FrostShock) and v41 and v130() and v100.ElectrifiedShocks:IsAvailable() and v127() and not v100.LightningRod:IsAvailable() and (v113 > (1 + 0)) and (v114 > (3 - 2))) or ((6559 - 3732) < (335 + 43))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((5283 - (518 + 1289)) < (4453 - 1856))) then
				return "frost_shock single_target 76";
			end
		end
		if (((409 + 2670) < (7001 - 2207)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and (v100.DeeplyRootedElements:IsAvailable())) then
			if (((3576 + 1278) > (4933 - (304 + 165))) and v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 78";
			end
			if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((4638 + 274) == (3918 - (54 + 106)))) then
				return "lava_burst single_target 78";
			end
		end
		if (((2095 - (1618 + 351)) <= (2456 + 1026)) and v100.FrostShock:IsCastable() and v41 and v130() and v100.FluxMelting:IsAvailable() and v13:BuffDown(v100.FluxMeltingBuff)) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((3390 - (10 + 1006)) == (1098 + 3276))) then
				return "frost_shock single_target 80";
			end
		end
		if (((221 + 1354) == (5105 - 3530)) and v100.FrostShock:IsCastable() and v41 and v130() and ((v100.ElectrifiedShocks:IsAvailable() and (v16:DebuffRemains(v100.ElectrifiedShocksDebuff) < (1035 - (912 + 121)))) or (v13:BuffRemains(v100.IcefuryBuff) < (3 + 3)))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((3523 - (1140 + 149)) == (932 + 523))) then
				return "frost_shock single_target 82";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.ElementalBlast:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or v129())) or ((1422 - 355) > (331 + 1448))) then
			local v203 = 0 - 0;
			while true do
				if (((4052 - 1891) >= (162 + 772)) and (v203 == (0 - 0))) then
					if (((1798 - (165 + 21)) == (1723 - (61 + 50))) and v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 84";
					end
					if (((1793 + 2559) >= (13503 - 10670)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 84";
					end
					break;
				end
			end
		end
		if ((v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v39) or ((6492 - 3270) < (1208 + 1865))) then
			if (((2204 - (1295 + 165)) <= (672 + 2270)) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast single_target 86";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and v128() and v100.UnrelentingCalamity:IsAvailable() and (v113 > (1 + 0)) and (v114 > (1398 - (819 + 578)))) or ((3235 - (331 + 1071)) <= (2065 - (588 + 155)))) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((4749 - (546 + 736)) <= (2992 - (1834 + 103)))) then
				return "chain_lightning single_target 88";
			end
		end
		if (((2179 + 1362) == (10563 - 7022)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v128() and v100.UnrelentingCalamity:IsAvailable()) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((5323 - (1536 + 230)) >= (4494 - (128 + 363)))) then
				return "lightning_bolt single_target 90";
			end
		end
		if ((v126(v100.Icefury) and v100.Icefury:IsCastable() and v42) or ((140 + 517) >= (4149 - 2481))) then
			if (v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury)) or ((266 + 761) > (6391 - 2533))) then
				return "icefury single_target 92";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v100.LightningRodDebuff) and (v16:DebuffUp(v100.ElectrifiedShocksDebuff) or v128()) and (v113 > (2 - 1)) and (v114 > (2 - 1))) or ((2508 + 1146) < (1459 - (615 + 394)))) then
			if (((1708 + 183) < (4244 + 209)) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 94";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v100.LightningRodDebuff) and (v16:DebuffUp(v100.ElectrifiedShocksDebuff) or v128())) or ((9572 - 6432) < (9656 - 7527))) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((3206 - (59 + 592)) < (2745 - 1505))) then
				return "lightning_bolt single_target 96";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and v127() and v13:BuffDown(v100.LavaSurgeBuff) and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable() and (v100.LavaBurst:ChargesFractional() < (1 - 0)) and v100.EchooftheElements:IsAvailable()) or ((3332 + 1395) <= (4893 - (70 + 101)))) then
			if (((1829 - 1089) < (3501 + 1436)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 98";
			end
		end
		if (((9187 - 5529) >= (521 - (123 + 118))) and v100.FrostShock:IsCastable() and v41 and v130() and (v100.FluxMelting:IsAvailable() or (v100.ElectrifiedShocks:IsAvailable() and not v100.LightningRod:IsAvailable()))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((215 + 670) >= (13 + 1018))) then
				return "frost_shock single_target 100";
			end
		end
		if (((4953 - (653 + 746)) >= (981 - 456)) and v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and v127() and v13:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (1 - 0)) and v100.EchooftheElements:IsAvailable() and (v113 > (2 - 1)) and (v114 > (1 + 0))) then
			if (((1545 + 869) <= (2596 + 376)) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 102";
			end
		end
		if (((433 + 3096) <= (553 + 2985)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v127() and v13:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (2 - 1)) and v100.EchooftheElements:IsAvailable()) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((2724 + 137) < (845 - 387))) then
				return "lightning_bolt single_target 104";
			end
		end
		if (((2951 - (885 + 349)) <= (3594 + 931)) and v100.FrostShock:IsCastable() and v41 and v130() and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable()) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((8666 - 5488) <= (4432 - 2908))) then
				return "frost_shock single_target 106";
			end
		end
		if (((5222 - (915 + 53)) > (1171 - (768 + 33))) and v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and (v113 > (3 - 2)) and (v114 > (1 - 0))) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((1963 - (287 + 41)) == (2624 - (638 + 209)))) then
				return "chain_lightning single_target 108";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45) or ((1735 + 1603) >= (5679 - (96 + 1590)))) then
			if (((2826 - (741 + 931)) <= (725 + 750)) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 110";
			end
		end
		if ((v100.FlameShock:IsCastable() and v40 and (v13:IsMoving())) or ((7436 - 4826) < (5746 - 4516))) then
			if (v104.CastCycle(v100.FlameShock, v112, v119, not v16:IsSpellInRange(v100.FlameShock)) or ((622 + 826) == (1325 + 1758))) then
				return "flame_shock single_target 112";
			end
			if (((1001 + 2138) > (3475 - 2559)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 112";
			end
		end
		if (((960 + 1994) == (1443 + 1511)) and v100.FlameShock:IsCastable() and v40) then
			if (((477 - 360) <= (2596 + 296)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 114";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41) or ((947 - (64 + 430)) > (4626 + 36))) then
			if (((1683 - (106 + 257)) > (422 + 173)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 116";
			end
		end
	end
	local function v139()
		if ((v73 and v100.EarthShield:IsCastable() and v13:BuffDown(v100.EarthShieldBuff) and ((v74 == "Earth Shield") or (v100.ElementalOrbit:IsAvailable() and v13:BuffUp(v100.LightningShield)))) or ((3920 - (496 + 225)) < (1206 - 616))) then
			if (v24(v100.EarthShield) or ((23348 - 18555) < (1688 - (256 + 1402)))) then
				return "earth_shield main 2";
			end
		elseif ((v73 and v100.LightningShield:IsCastable() and v13:BuffDown(v100.LightningShieldBuff) and ((v74 == "Lightning Shield") or (v100.ElementalOrbit:IsAvailable() and v13:BuffUp(v100.EarthShield)))) or ((3595 - (30 + 1869)) <= (2428 - (213 + 1156)))) then
			if (((2531 - (96 + 92)) == (400 + 1943)) and v24(v100.LightningShield)) then
				return "lightning_shield main 2";
			end
		end
		v30 = v133();
		if (v30 or ((1942 - (142 + 757)) > (2926 + 665))) then
			return v30;
		end
		if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((1182 + 1708) >= (4158 - (32 + 47)))) then
			if (((6451 - (1053 + 924)) <= (4673 + 97)) and v24(v100.AncestralSpirit, nil, true)) then
				return "ancestral_spirit";
			end
		end
		if ((v100.AncestralSpirit:IsCastable() and v100.AncestralSpirit:IsReady() and not v13:AffectingCombat() and v14:Exists() and v14:IsDeadOrGhost() and v14:IsAPlayer() and not v13:CanAttack(v14)) or ((8510 - 3568) == (5551 - (685 + 963)))) then
			if (v24(v102.AncestralSpiritMouseover) or ((503 - 255) > (7555 - 2710))) then
				return "ancestral_spirit mouseover";
			end
		end
		v109, v110 = v29();
		if (((3278 - (541 + 1168)) == (3166 - (645 + 952))) and v100.ImprovedFlametongueWeapon:IsAvailable() and v100.FlametongueWeapon:IsCastable() and v50 and (not v109 or (v110 < (600838 - (669 + 169)))) and v100.FlametongueWeapon:IsAvailable()) then
			if (v24(v100.FlametongueWeapon) or ((17067 - 12140) <= (6994 - 3773))) then
				return "flametongue_weapon enchant";
			end
		end
		if ((not v13:AffectingCombat() and v31 and v104.TargetIsValid()) or ((601 + 1179) > (615 + 2172))) then
			local v204 = 765 - (181 + 584);
			while true do
				if ((v204 == (1395 - (665 + 730))) or ((11346 - 7409) <= (2508 - 1278))) then
					v30 = v136();
					if (v30 or ((3987 - (540 + 810)) < (6820 - 5114))) then
						return v30;
					end
					break;
				end
			end
		end
	end
	local function v140()
		local v169 = 0 - 0;
		while true do
			if ((v169 == (0 + 0)) or ((2872 - (166 + 37)) <= (4290 - (22 + 1859)))) then
				v30 = v134();
				if (v30 or ((3173 - (843 + 929)) > (4958 - (30 + 232)))) then
					return v30;
				end
				v169 = 2 - 1;
			end
			if ((v169 == (779 - (55 + 722))) or ((7040 - 3760) < (2996 - (78 + 1597)))) then
				if (((1084 + 3843) >= (2096 + 207)) and v84) then
					local v255 = 0 + 0;
					while true do
						if (((4011 - (305 + 244)) >= (958 + 74)) and (v255 == (105 - (95 + 10)))) then
							if (v17 or ((763 + 314) >= (6372 - 4361))) then
								local v265 = 0 - 0;
								while true do
									if (((2305 - (592 + 170)) < (8422 - 6007)) and (v265 == (0 - 0))) then
										v30 = v132();
										if (v30 or ((2072 + 2372) < (785 + 1230))) then
											return v30;
										end
										break;
									end
								end
							end
							if ((v14 and v14:Exists() and not v13:CanAttack(v14) and (v104.UnitHasDispellableDebuffByPlayer(v14) or v104.UnitHasCurseDebuff(v14))) or ((10142 - 5942) == (379 + 1953))) then
								if (v100.CleanseSpirit:IsCastable() or ((2368 - 1090) >= (1823 - (353 + 154)))) then
									if (((1439 - 357) == (1477 - 395)) and v24(v102.CleanseSpiritMouseover, not v14:IsSpellInRange(v100.PurifySpirit))) then
										return "purify_spirit dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				if (((917 + 411) <= (3821 + 1057)) and v100.GreaterPurge:IsAvailable() and v97 and v100.GreaterPurge:IsReady() and v35 and v83 and not v13:IsCasting() and not v13:IsChanneling() and v104.UnitHasMagicBuff(v16)) then
					if (((2697 + 1390) >= (1957 - 602)) and v24(v100.GreaterPurge, not v16:IsSpellInRange(v100.GreaterPurge))) then
						return "greater_purge damage";
					end
				end
				v169 = 5 - 2;
			end
			if (((6 - 3) == v169) or ((676 - (7 + 79)) > (2176 + 2474))) then
				if ((v100.Purge:IsReady() and v97 and v35 and v83 and not v13:IsCasting() and not v13:IsChanneling() and v104.UnitHasMagicBuff(v16)) or ((3955 - (24 + 157)) <= (7317 - 3650))) then
					if (((2709 - 1439) < (610 + 1536)) and v24(v100.Purge, not v16:IsSpellInRange(v100.Purge))) then
						return "purge damage";
					end
				end
				if (((12291 - 7728) >= (436 - (262 + 118))) and v104.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) then
					local v256 = 1083 - (1038 + 45);
					local v257;
					while true do
						if ((v256 == (5 - 2)) or ((676 - (19 + 211)) == (735 - (88 + 25)))) then
							if (((5267 - 3198) > (501 + 508)) and true) then
								local v266 = 0 + 0;
								while true do
									if (((1048 - (1007 + 29)) < (1134 + 3074)) and (v266 == (0 - 0))) then
										v30 = v138();
										if (v30 or ((14141 - 11151) <= (665 + 2315))) then
											return v30;
										end
										v266 = 812 - (340 + 471);
									end
									if ((v266 == (2 - 1)) or ((3164 - (276 + 313)) >= (10435 - 6160))) then
										if (v24(v100.Pool) or ((3343 + 283) <= (554 + 752))) then
											return "Pool for SingleTarget()";
										end
										break;
									end
								end
							end
							break;
						end
						if (((129 + 1239) < (5752 - (495 + 1477))) and (v256 == (2 - 1))) then
							if ((v100.NaturesSwiftness:IsCastable() and v46) or ((2077 + 1092) == (2676 - (342 + 61)))) then
								if (((1085 + 1396) <= (3444 - (4 + 161))) and v24(v100.NaturesSwiftness)) then
									return "natures_swiftness main 12";
								end
							end
							v257 = v104.HandleDPSPotion(v13:BuffUp(v100.AscendanceBuff));
							v256 = 2 + 0;
						end
						if ((v256 == (6 - 4)) or ((2793 - 1730) <= (1374 - (322 + 175)))) then
							if (((2877 - (173 + 390)) == (571 + 1743)) and v257) then
								return v257;
							end
							if (((1238 - (203 + 111)) >= (30 + 447)) and v32 and (v113 > (2 + 0)) and (v114 > (5 - 3))) then
								v30 = v137();
								if (((1638 + 175) <= (4484 - (57 + 649))) and v30) then
									return v30;
								end
								if (((4534 - (328 + 56)) == (1327 + 2823)) and v24(v100.Pool)) then
									return "Pool for Aoe()";
								end
							end
							v256 = 515 - (433 + 79);
						end
						if (((40 + 392) <= (2428 + 579)) and (v256 == (0 - 0))) then
							if (((v90 < v108) and v57 and ((v63 and v33) or not v63)) or ((1929 - 1521) > (1984 + 737))) then
								local v267 = 0 + 0;
								while true do
									if ((v267 == (1038 - (562 + 474))) or ((7974 - 4556) < (5087 - 2590))) then
										if (((2640 - (76 + 829)) < (3842 - (1506 + 167))) and v100.BagofTricks:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff))) then
											if (((7307 - 3417) >= (3528 - (58 + 208))) and v24(v100.BagofTricks)) then
												return "bag_of_tricks main 10";
											end
										end
										break;
									end
									if ((v267 == (0 + 0)) or ((3104 + 1252) >= (2672 + 1977))) then
										if (((15927 - 12023) == (4241 - (258 + 79))) and v100.BloodFury:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (7 + 43)))) then
											if (v24(v100.BloodFury) or ((6017 - 3157) >= (5259 - (1219 + 251)))) then
												return "blood_fury main 2";
											end
										end
										if ((v100.Berserking:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff))) or ((2757 - (1231 + 440)) > (4507 - (34 + 24)))) then
											if (((2889 + 2092) > (1018 - 472)) and v24(v100.Berserking)) then
												return "berserking main 4";
											end
										end
										v267 = 1 + 0;
									end
									if ((v267 == (2 - 1)) or ((7584 - 5218) <= (20 - 12))) then
										if ((v100.Fireblood:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (167 - 117)))) or ((5655 - 3065) == (4453 - (877 + 712)))) then
											if (v24(v100.Fireblood) or ((1572 + 1052) > (4903 - (242 + 512)))) then
												return "fireblood main 6";
											end
										end
										if ((v100.AncestralCall:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (104 - 54)))) or ((3245 - (92 + 535)) >= (3539 + 956))) then
											if (v24(v100.AncestralCall) or ((5118 - 2633) >= (196 + 2935))) then
												return "ancestral_call main 8";
											end
										end
										v267 = 7 - 5;
									end
								end
							end
							if ((v90 < v108) or ((2750 + 54) <= (1929 + 856))) then
								if ((v56 and ((v33 and v62) or not v62)) or ((642 + 3929) == (6805 - 3390))) then
									v30 = v135();
									if (v30 or ((6768 - 2327) > (6572 - (1476 + 309)))) then
										return v30;
									end
								end
							end
							v256 = 1285 - (299 + 985);
						end
					end
				end
				break;
			end
			if (((457 + 1463) == (6293 - 4373)) and ((94 - (86 + 7)) == v169)) then
				if (v85 or ((2644 - 1997) == (426 + 4051))) then
					if (((4699 - (672 + 208)) == (1637 + 2182)) and v80) then
						v30 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 172 - (14 + 118));
						if (v30 or ((1911 - (339 + 106)) > (3469 + 891))) then
							return v30;
						end
					end
					if (v81 or ((8 + 6) > (2389 - (440 + 955)))) then
						v30 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 30 + 0);
						if (((720 - 319) <= (244 + 490)) and v30) then
							return v30;
						end
					end
					if (v82 or ((5395 - 3228) >= (2347 + 1079))) then
						local v262 = 353 - (260 + 93);
						while true do
							if (((716 + 48) < (7514 - 4229)) and ((0 - 0) == v262)) then
								v30 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 2004 - (1181 + 793));
								if (((637 + 1862) == (2806 - (105 + 202))) and v30) then
									return v30;
								end
								break;
							end
						end
					end
				end
				if (v86 or ((555 + 137) >= (5743 - (352 + 458)))) then
					local v258 = 0 - 0;
					while true do
						if ((v258 == (0 - 0)) or ((3054 + 100) <= (6605 - 4345))) then
							v30 = v104.HandleIncorporeal(v100.Hex, v102.HexMouseOver, 979 - (438 + 511), true);
							if (v30 or ((4020 - (1262 + 121)) > (4217 - (728 + 340)))) then
								return v30;
							end
							break;
						end
					end
				end
				v169 = 1792 - (816 + 974);
			end
		end
	end
	local function v141()
		local v170 = 0 - 0;
		while true do
			if ((v170 == (10 - 7)) or ((4331 - (163 + 176)) < (6851 - 4444))) then
				v48 = EpicSettings.Settings['useStormkeeper'];
				v49 = EpicSettings.Settings['useTotemicRecall'];
				v50 = EpicSettings.Settings['useWeaponEnchant'];
				v91 = EpicSettings.Settings['useWeapon'];
				v170 = 18 - 14;
			end
			if ((v170 == (0 + 0)) or ((4712 - (1564 + 246)) > (5204 - (124 + 221)))) then
				v36 = EpicSettings.Settings['useChainlightning'];
				v37 = EpicSettings.Settings['useEarthquake'];
				v38 = EpicSettings.Settings['useEarthShock'];
				v39 = EpicSettings.Settings['useElementalBlast'];
				v170 = 1 + 0;
			end
			if (((2130 - (115 + 336)) < (9599 - 5240)) and (v170 == (2 + 4))) then
				v64 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v65 = EpicSettings.Settings['stormkeeperWithMiniCD'];
				break;
			end
			if (((1959 - (45 + 1)) < (253 + 4417)) and (v170 == (1995 - (1282 + 708)))) then
				v58 = EpicSettings.Settings['ascendanceWithCD'];
				v61 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
				v59 = EpicSettings.Settings['fireElementalWithCD'];
				v60 = EpicSettings.Settings['stormElementalWithCD'];
				v170 = 1218 - (583 + 629);
			end
			if ((v170 == (1 + 1)) or ((7362 - 4516) < (461 + 418))) then
				v44 = EpicSettings.Settings['useLavaBurst'];
				v45 = EpicSettings.Settings['useLightningBolt'];
				v46 = EpicSettings.Settings['useNaturesSwiftness'];
				v47 = EpicSettings.Settings['usePrimordialWave'];
				v170 = 1173 - (943 + 227);
			end
			if (((2006 + 2582) == (6219 - (1539 + 92))) and ((1947 - (706 + 1240)) == v170)) then
				v40 = EpicSettings.Settings['useFlameShock'];
				v41 = EpicSettings.Settings['useFrostShock'];
				v42 = EpicSettings.Settings['useIceFury'];
				v43 = EpicSettings.Settings['useLavaBeam'];
				v170 = 260 - (81 + 177);
			end
			if ((v170 == (10 - 6)) or ((604 - (212 + 45)) == (6907 - 4842))) then
				v52 = EpicSettings.Settings['useAscendance'];
				v54 = EpicSettings.Settings['useLiquidMagmaTotem'];
				v53 = EpicSettings.Settings['useFireElemental'];
				v55 = EpicSettings.Settings['useStormElemental'];
				v170 = 1951 - (708 + 1238);
			end
		end
	end
	local function v142()
		local v171 = 0 + 0;
		while true do
			if ((v171 == (1 + 1)) or ((2978 - (586 + 1081)) > (3208 - (348 + 163)))) then
				v75 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 + 0);
				v76 = EpicSettings.Settings['ancestralGuidanceGroup'] or (280 - (215 + 65));
				v77 = EpicSettings.Settings['astralShiftHP'] or (0 - 0);
				v171 = 1862 - (1541 + 318);
			end
			if ((v171 == (0 + 0)) or ((1374 + 1343) > (2860 + 935))) then
				v67 = EpicSettings.Settings['useWindShear'];
				v68 = EpicSettings.Settings['useCapacitorTotem'];
				v69 = EpicSettings.Settings['useThunderstorm'];
				v171 = 1751 - (1036 + 714);
			end
			if ((v171 == (4 + 2)) or ((598 + 483) < (1671 - (883 + 397)))) then
				v80 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v81 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v82 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if ((v171 == (591 - (563 + 27))) or ((473 - 352) > (5424 - (1369 + 617)))) then
				v70 = EpicSettings.Settings['useAncestralGuidance'];
				v71 = EpicSettings.Settings['useAstralShift'];
				v72 = EpicSettings.Settings['useHealingStreamTotem'];
				v171 = 1489 - (85 + 1402);
			end
			if (((25 + 46) < (5030 - 3081)) and (v171 == (406 - (274 + 129)))) then
				v78 = EpicSettings.Settings['healingStreamTotemHP'] or (217 - (12 + 205));
				v79 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
				v51 = EpicSettings.Settings['earthquakeSetting'] or "";
				v171 = 15 - 11;
			end
			if (((4117 + 137) == (4638 - (27 + 357))) and ((485 - (91 + 389)) == v171)) then
				v98 = EpicSettings.Settings['healOOC'];
				v99 = EpicSettings.Settings['healOOCHP'] or (297 - (90 + 207));
				v97 = EpicSettings.Settings['usePurgeTarget'];
				v171 = 1 + 5;
			end
			if (((4057 - (706 + 155)) >= (4345 - (730 + 1065))) and ((1567 - (1339 + 224)) == v171)) then
				v66 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
				v73 = EpicSettings.Settings['autoShield'];
				v74 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v171 = 3 + 2;
			end
		end
	end
	local function v143()
		v90 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v87 = EpicSettings.Settings['InterruptWithStun'];
		v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v89 = EpicSettings.Settings['InterruptThreshold'];
		v84 = EpicSettings.Settings['DispelDebuffs'];
		v83 = EpicSettings.Settings['DispelBuffs'];
		v56 = EpicSettings.Settings['useTrinkets'];
		v57 = EpicSettings.Settings['useRacials'];
		v62 = EpicSettings.Settings['trinketsWithCD'];
		v63 = EpicSettings.Settings['racialsWithCD'];
		v93 = EpicSettings.Settings['useHealthstone'];
		v92 = EpicSettings.Settings['useHealingPotion'];
		v95 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v94 = EpicSettings.Settings['healingPotionHP'] or (843 - (268 + 575));
		v96 = EpicSettings.Settings['HealingPotionName'] or "";
		v85 = EpicSettings.Settings['handleAfflicted'];
		v86 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v144()
		local v185 = 1294 - (919 + 375);
		while true do
			if (((6753 - 4297) < (5147 - (180 + 791))) and (v185 == (1809 - (323 + 1482)))) then
				if ((v35 and v84) or ((3068 - (1177 + 741)) == (227 + 3225))) then
					if (((7031 - 5156) < (869 + 1389)) and v13:AffectingCombat() and v100.CleanseSpirit:IsAvailable()) then
						local v263 = v84 and v100.CleanseSpirit:IsReady() and v35;
						v30 = v104.FocusUnit(v263, nil, 44 - 24, nil, 3 + 22, v100.HealingSurge);
						if (((1282 - (96 + 13)) > (1962 - (962 + 959))) and v30) then
							return v30;
						end
					end
				end
				if (v104.TargetIsValid() or v13:AffectingCombat() or ((139 - 83) >= (568 + 2640))) then
					v107 = v9.BossFightRemains();
					v108 = v107;
					if (((5664 - (461 + 890)) > (2475 + 898)) and (v108 == (43290 - 32179))) then
						v108 = v9.FightRemains(v111, false);
					end
				end
				if ((not v13:IsChanneling() and not v13:IsCasting()) or ((4736 - (19 + 224)) == (2017 + 208))) then
					local v259 = 198 - (37 + 161);
					while true do
						if (((1120 + 1984) >= (1199 + 1893)) and ((0 + 0) == v259)) then
							if (((3609 - (60 + 1)) > (4021 - (826 + 97))) and v85) then
								if (v80 or ((3150 + 102) == (1808 - 1305))) then
									v30 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 82 - 42);
									if (((5418 - (375 + 310)) > (4065 - (1864 + 135))) and v30) then
										return v30;
									end
								end
								if (((9157 - 5608) >= (203 + 713)) and v81) then
									local v273 = 0 + 0;
									while true do
										if (((0 - 0) == v273) or ((3320 - (314 + 817)) <= (139 + 106))) then
											v30 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 244 - (32 + 182));
											if (v30 or ((1027 + 362) > (13718 - 9793))) then
												return v30;
											end
											break;
										end
									end
								end
								if (((4234 - (39 + 26)) >= (3225 - (54 + 90))) and v82) then
									local v274 = 198 - (45 + 153);
									while true do
										if (((212 + 137) <= (1446 - (457 + 95))) and (v274 == (0 + 0))) then
											v30 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 62 - 32);
											if (((1766 - 1035) <= (10767 - 7789)) and v30) then
												return v30;
											end
											break;
										end
									end
								end
							end
							if (v13:AffectingCombat() or ((400 + 492) > (13422 - 9530))) then
								local v268 = 0 - 0;
								while true do
									if ((v268 == (749 - (485 + 263))) or ((5173 - (575 + 132)) == (1761 - (750 + 111)))) then
										if (v30 or ((3094 - (445 + 565)) >= (2325 + 563))) then
											return v30;
										end
										break;
									end
									if (((69 + 410) < (3291 - 1428)) and (v268 == (0 + 0))) then
										if ((v33 and v91 and (v101.Dreambinder:IsEquippedAndReady() or v101.Iridal:IsEquippedAndReady())) or ((2738 - (189 + 121)) >= (1000 + 3038))) then
											if (v24(v102.UseWeapon, nil) or ((4225 - (634 + 713)) > (3435 - (493 + 45)))) then
												return "Using Weapon Macro";
											end
										end
										v30 = v140();
										v268 = 969 - (493 + 475);
									end
								end
							else
								v30 = v139();
								if (v30 or ((631 + 1838) > (4460 - (158 + 626)))) then
									return v30;
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((110 + 123) < (805 - 318)) and (v185 == (0 + 0))) then
				v142();
				v141();
				v143();
				v185 = 1 + 0;
			end
			if (((3564 - (1035 + 56)) >= (1160 - (114 + 845))) and (v185 == (2 + 1))) then
				v111 = v13:GetEnemiesInRange(102 - 62);
				v112 = v16:GetEnemiesInSplashRange(5 + 0);
				if (((5169 - (179 + 870)) >= (186 - 53)) and v32) then
					local v260 = 878 - (827 + 51);
					while true do
						if (((8144 - 5064) >= (995 + 991)) and (v260 == (473 - (95 + 378)))) then
							v113 = #v111;
							v114 = v27(v16:GetEnemiesInSplashRangeCount(1 + 4), v113);
							break;
						end
					end
				else
					v113 = 1 - 0;
					v114 = 1 + 0;
				end
				v185 = 1015 - (334 + 677);
			end
			if ((v185 == (7 - 5)) or ((2495 - (1049 + 7)) > (15449 - 11911))) then
				v35 = EpicSettings.Toggles['dispel'];
				v34 = EpicSettings.Toggles['minicds'];
				if (v13:IsDeadOrGhost() or ((787 - 368) < (3 + 4))) then
					return v30;
				end
				v185 = 7 - 4;
			end
			if (((5649 - 2829) == (1256 + 1564)) and (v185 == (1421 - (1004 + 416)))) then
				v31 = EpicSettings.Toggles['ooc'];
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v185 = 1959 - (1621 + 336);
			end
		end
	end
	local function v145()
		local v186 = 1939 - (337 + 1602);
		while true do
			if ((v186 == (1518 - (1014 + 503))) or ((5377 - (446 + 569)) <= (148 + 3379))) then
				v21.Print("Elemental Shaman by Epic. Supported by xKaneto.");
				break;
			end
			if (((7666 - 5053) <= (901 + 1779)) and ((0 - 0) == v186)) then
				v100.FlameShockDebuff:RegisterAuraTracking();
				v106();
				v186 = 1 + 0;
			end
		end
	end
	v21.SetAPL(767 - (223 + 282), v144, v145);
end;
return v0["Epix_Shaman_Elemental.lua"]();

