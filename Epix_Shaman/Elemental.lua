local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 165 - (38 + 127);
	local v6;
	while true do
		if ((v5 == (1 - 0)) or ((1997 + 51) == (4669 - 1638))) then
			return v6(...);
		end
		if ((v5 == (785 - (222 + 563))) or ((2641 - 1442) >= (1562 + 607))) then
			v6 = v0[v4];
			if (not v6 or ((826 - (23 + 167)) == (3700 - (690 + 1108)))) then
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
	local v100 = v19.Shaman.Elemental;
	local v101 = v21.Shaman.Elemental;
	local v102 = v24.Shaman.Elemental;
	local v103 = {};
	local v104 = v22.Commons.Everyone;
	local v105 = v22.Commons.Shaman;
	local function v106()
		if (v100.CleanseSpirit:IsAvailable() or ((3992 + 847) <= (4128 - (40 + 808)))) then
			v104.DispellableDebuffs = v104.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v106();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v10:RegisterForEvent(function()
		v100.PrimordialWave:RegisterInFlightEffect(53866 + 273296);
		v100.PrimordialWave:RegisterInFlight();
		v100.LavaBurst:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v100.PrimordialWave:RegisterInFlightEffect(1251069 - 923907);
	v100.PrimordialWave:RegisterInFlight();
	v100.LavaBurst:RegisterInFlight();
	local v107 = 10620 + 491;
	local v108 = 5878 + 5233;
	local v109, v110;
	local v111, v112;
	local v113 = 0 + 0;
	local v114 = 571 - (47 + 524);
	local v115 = 0 + 0;
	local v116 = 0 - 0;
	local v117 = 0 - 0;
	local function v118()
		return (91 - 51) - (v29() - v115);
	end
	v10:RegisterForSelfCombatEvent(function(...)
		local v146, v147, v147, v147, v148 = select(1734 - (1165 + 561), ...);
		if (((v146 == v14:GUID()) and (v148 == (5693 + 185941))) or ((11378 - 7704) <= (749 + 1213))) then
			v116 = v29();
			C_Timer.After(479.1 - (341 + 138), function()
				if ((v116 ~= v117) or ((512 + 1382) < (2901 - 1495))) then
					v115 = v116;
				end
			end);
		end
	end, "SPELL_AURA_APPLIED");
	local function v119(v149)
		return (v149:DebuffRefreshable(v100.FlameShockDebuff));
	end
	local function v120(v150)
		return v150:DebuffRefreshable(v100.FlameShockDebuff) and (v150:DebuffRemains(v100.FlameShockDebuff) < (v150:TimeToDie() - (331 - (89 + 237))));
	end
	local function v121(v151)
		return v151:DebuffRefreshable(v100.FlameShockDebuff) and (v151:DebuffRemains(v100.FlameShockDebuff) < (v151:TimeToDie() - (16 - 11))) and (v151:DebuffRemains(v100.FlameShockDebuff) > (0 - 0));
	end
	local function v122(v152)
		return (v152:DebuffRemains(v100.FlameShockDebuff));
	end
	local function v123(v153)
		return v153:DebuffRemains(v100.FlameShockDebuff) > (883 - (581 + 300));
	end
	local function v124(v154)
		return (v154:DebuffRemains(v100.LightningRodDebuff));
	end
	local function v125()
		local v155 = v14:Maelstrom();
		if (((2792 - (855 + 365)) >= (3636 - 2105)) and not v14:IsCasting()) then
			return v155;
		elseif (v14:IsCasting(v100.ElementalBlast) or ((1531 + 3156) < (5777 - (1030 + 205)))) then
			return v155 - (71 + 4);
		elseif (((3062 + 229) > (1953 - (156 + 130))) and v14:IsCasting(v100.Icefury)) then
			return v155 + (56 - 31);
		elseif (v14:IsCasting(v100.LightningBolt) or ((1471 - 598) == (4165 - 2131))) then
			return v155 + 3 + 7;
		elseif (v14:IsCasting(v100.LavaBurst) or ((1643 + 1173) < (80 - (10 + 59)))) then
			return v155 + 4 + 8;
		elseif (((18216 - 14517) < (5869 - (671 + 492))) and v14:IsCasting(v100.ChainLightning)) then
			return v155 + ((4 + 0) * v114);
		else
			return v155;
		end
	end
	local function v126(v156)
		local v157 = 1215 - (369 + 846);
		local v158;
		while true do
			if (((701 + 1945) >= (748 + 128)) and (v157 == (1945 - (1036 + 909)))) then
				v158 = v156:IsReady();
				if (((489 + 125) <= (5345 - 2161)) and ((v156 == v100.Stormkeeper) or (v156 == v100.ElementalBlast) or (v156 == v100.Icefury))) then
					local v243 = 203 - (11 + 192);
					local v244;
					while true do
						if (((1580 + 1546) == (3301 - (135 + 40))) and (v243 == (0 - 0))) then
							v244 = v14:BuffUp(v100.SpiritwalkersGraceBuff) or not v14:IsMoving();
							return v158 and v244 and not v14:IsCasting(v156);
						end
					end
				elseif ((v156 == v100.LavaBeam) or ((1319 + 868) >= (10913 - 5959))) then
					local v249 = 0 - 0;
					local v250;
					while true do
						if ((v249 == (176 - (50 + 126))) or ((10795 - 6918) == (792 + 2783))) then
							v250 = v14:BuffUp(v100.SpiritwalkersGraceBuff) or not v14:IsMoving();
							return v158 and v250;
						end
					end
				elseif (((2120 - (1233 + 180)) > (1601 - (522 + 447))) and ((v156 == v100.LightningBolt) or (v156 == v100.ChainLightning))) then
					local v257 = 1421 - (107 + 1314);
					local v258;
					while true do
						if ((v257 == (0 + 0)) or ((1663 - 1117) >= (1140 + 1544))) then
							v258 = v14:BuffUp(v100.SpiritwalkersGraceBuff) or v14:BuffUp(v100.StormkeeperBuff) or not v14:IsMoving();
							return v158 and v258;
						end
					end
				elseif (((2909 - 1444) <= (17017 - 12716)) and (v156 == v100.LavaBurst)) then
					local v262 = v14:BuffUp(v100.SpiritwalkersGraceBuff) or v14:BuffUp(v100.LavaSurgeBuff) or not v14:IsMoving();
					local v263 = v14:BuffUp(v100.LavaSurgeBuff);
					local v264 = (v100.LavaBurst:Charges() >= (1911 - (716 + 1194))) and not v14:IsCasting(v100.LavaBurst);
					local v265 = (v100.LavaBurst:Charges() == (1 + 1)) and v14:IsCasting(v100.LavaBurst);
					return v158 and v262 and (v263 or v264 or v265);
				elseif (((183 + 1521) > (1928 - (74 + 429))) and (v156 == v100.PrimordialWave)) then
					return v158 and v34 and v14:BuffDown(v100.PrimordialWaveBuff) and v14:BuffDown(v100.LavaSurgeBuff);
				else
					return v158;
				end
				break;
			end
		end
	end
	local function v127()
		local v159 = 0 - 0;
		local v160;
		while true do
			if ((v159 == (1 + 0)) or ((1572 - 885) == (2996 + 1238))) then
				if (not v14:IsCasting() or ((10266 - 6936) < (3532 - 2103))) then
					return v160;
				elseif (((1580 - (279 + 154)) >= (1113 - (454 + 324))) and v14:IsCasting(v105.LavaBurst)) then
					return true;
				elseif (((2703 + 732) > (2114 - (12 + 5))) and (v14:IsCasting(v105.ElementalBlast) or v14:IsCasting(v100.Icefury) or v14:IsCasting(v100.LightningBolt) or v14:IsCasting(v100.ChainLightning))) then
					return false;
				else
					return v160;
				end
				break;
			end
			if ((v159 == (0 + 0)) or ((9606 - 5836) >= (1494 + 2547))) then
				if (not v100.MasteroftheElements:IsAvailable() or ((4884 - (277 + 816)) <= (6883 - 5272))) then
					return false;
				end
				v160 = v14:BuffUp(v100.MasteroftheElementsBuff);
				v159 = 1184 - (1058 + 125);
			end
		end
	end
	local function v128()
		local v161 = 0 + 0;
		local v162;
		while true do
			if ((v161 == (976 - (815 + 160))) or ((19642 - 15064) <= (4766 - 2758))) then
				if (((269 + 856) <= (6068 - 3992)) and not v14:IsCasting()) then
					return v162 > (1898 - (41 + 1857));
				elseif (((v162 == (1894 - (1222 + 671))) and (v14:IsCasting(v100.LightningBolt) or v14:IsCasting(v100.ChainLightning))) or ((1920 - 1177) >= (6322 - 1923))) then
					return false;
				else
					return v162 > (1182 - (229 + 953));
				end
				break;
			end
			if (((2929 - (1111 + 663)) < (3252 - (874 + 705))) and (v161 == (0 + 0))) then
				if (not v100.PoweroftheMaelstrom:IsAvailable() or ((1586 + 738) <= (1201 - 623))) then
					return false;
				end
				v162 = v14:BuffStack(v100.PoweroftheMaelstromBuff);
				v161 = 1 + 0;
			end
		end
	end
	local function v129()
		if (((4446 - (642 + 37)) == (859 + 2908)) and not v100.Stormkeeper:IsAvailable()) then
			return false;
		end
		local v163 = v14:BuffUp(v100.StormkeeperBuff);
		if (((655 + 3434) == (10266 - 6177)) and not v14:IsCasting()) then
			return v163;
		elseif (((4912 - (233 + 221)) >= (3870 - 2196)) and v14:IsCasting(v100.Stormkeeper)) then
			return true;
		else
			return v163;
		end
	end
	local function v130()
		if (((856 + 116) <= (2959 - (718 + 823))) and not v100.Icefury:IsAvailable()) then
			return false;
		end
		local v164 = v14:BuffUp(v100.IcefuryBuff);
		if (not v14:IsCasting() or ((3108 + 1830) < (5567 - (266 + 539)))) then
			return v164;
		elseif (v14:IsCasting(v100.Icefury) or ((7089 - 4585) > (5489 - (636 + 589)))) then
			return true;
		else
			return v164;
		end
	end
	local v131 = 0 - 0;
	local function v132()
		if (((4440 - 2287) == (1707 + 446)) and v100.CleanseSpirit:IsReady() and v36 and v104.DispellableFriendlyUnit(10 + 15)) then
			if ((v131 == (1015 - (657 + 358))) or ((1342 - 835) >= (5902 - 3311))) then
				v131 = v29();
			end
			if (((5668 - (1151 + 36)) == (4328 + 153)) and v104.Wait(132 + 368, v131)) then
				local v241 = 0 - 0;
				while true do
					if ((v241 == (1832 - (1552 + 280))) or ((3162 - (64 + 770)) < (471 + 222))) then
						if (((9824 - 5496) == (769 + 3559)) and v25(v102.CleanseSpiritFocus)) then
							return "cleanse_spirit dispel";
						end
						v131 = 1243 - (157 + 1086);
						break;
					end
				end
			end
		end
	end
	local function v133()
		if (((3178 - 1590) >= (5833 - 4501)) and v98 and (v14:HealthPercentage() <= v99)) then
			if (v100.HealingSurge:IsReady() or ((6402 - 2228) > (5797 - 1549))) then
				if (v25(v100.HealingSurge) or ((5405 - (599 + 220)) <= (162 - 80))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v134()
		local v165 = 1931 - (1813 + 118);
		while true do
			if (((2824 + 1039) == (5080 - (841 + 376))) and (v165 == (2 - 0))) then
				if ((v92 and (v14:HealthPercentage() <= v94)) or ((66 + 216) <= (114 - 72))) then
					local v245 = 859 - (464 + 395);
					while true do
						if (((11828 - 7219) >= (368 + 398)) and (v245 == (837 - (467 + 370)))) then
							if ((v96 == "Refreshing Healing Potion") or ((2380 - 1228) == (1827 + 661))) then
								if (((11730 - 8308) > (523 + 2827)) and v101.RefreshingHealingPotion:IsReady()) then
									if (((2040 - 1163) > (896 - (150 + 370))) and v25(v102.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v96 == "Dreamwalker's Healing Potion") or ((4400 - (74 + 1208)) <= (4552 - 2701))) then
								if (v101.DreamwalkersHealingPotion:IsReady() or ((782 - 617) >= (2485 + 1007))) then
									if (((4339 - (14 + 376)) < (8422 - 3566)) and v25(v102.RefreshingHealingPotion)) then
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
			if (((0 + 0) == v165) or ((3757 + 519) < (2877 + 139))) then
				if (((13742 - 9052) > (3104 + 1021)) and v100.AstralShift:IsReady() and v72 and (v14:HealthPercentage() <= v78)) then
					if (v25(v100.AstralShift) or ((128 - (23 + 55)) >= (2123 - 1227))) then
						return "astral_shift defensive 1";
					end
				end
				if ((v100.AncestralGuidance:IsReady() and v71 and v104.AreUnitsBelowHealthPercentage(v76, v77)) or ((1144 + 570) >= (2657 + 301))) then
					if (v25(v100.AncestralGuidance) or ((2311 - 820) < (203 + 441))) then
						return "ancestral_guidance defensive 2";
					end
				end
				v165 = 902 - (652 + 249);
			end
			if (((1883 - 1179) < (2855 - (708 + 1160))) and (v165 == (2 - 1))) then
				if (((6778 - 3060) > (1933 - (10 + 17))) and v100.HealingStreamTotem:IsReady() and v73 and v104.AreUnitsBelowHealthPercentage(v79, v80)) then
					if (v25(v100.HealingStreamTotem) or ((216 + 742) > (5367 - (1400 + 332)))) then
						return "healing_stream_totem defensive 3";
					end
				end
				if (((6714 - 3213) <= (6400 - (242 + 1666))) and v101.Healthstone:IsReady() and v93 and (v14:HealthPercentage() <= v95)) then
					if (v25(v102.Healthstone) or ((1473 + 1969) < (934 + 1614))) then
						return "healthstone defensive 3";
					end
				end
				v165 = 2 + 0;
			end
		end
	end
	local function v135()
		v31 = v104.HandleTopTrinket(v103, v34, 980 - (850 + 90), nil);
		if (((5035 - 2160) >= (2854 - (360 + 1030))) and v31) then
			return v31;
		end
		v31 = v104.HandleBottomTrinket(v103, v34, 36 + 4, nil);
		if (v31 or ((13539 - 8742) >= (6731 - 1838))) then
			return v31;
		end
	end
	local function v136()
		if ((v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (1661 - (909 + 752))) and not v14:BuffUp(v100.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v108)) or ((1774 - (109 + 1114)) > (3786 - 1718))) then
			if (((823 + 1291) > (1186 - (6 + 236))) and v25(v100.Stormkeeper)) then
				return "stormkeeper precombat 2";
			end
		end
		if ((v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 + 0)) and v43) or ((1821 + 441) >= (7301 - 4205))) then
			if (v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury)) or ((3938 - 1683) >= (4670 - (1076 + 57)))) then
				return "icefury precombat 4";
			end
		end
		if ((v126(v100.ElementalBlast) and v40) or ((631 + 3206) < (1995 - (579 + 110)))) then
			if (((233 + 2717) == (2609 + 341)) and v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast precombat 6";
			end
		end
		if ((v14:IsCasting(v100.ElementalBlast) and v48 and ((v65 and v35) or not v65) and v126(v100.PrimordialWave)) or ((2507 + 2216) < (3705 - (174 + 233)))) then
			if (((3173 - 2037) >= (269 - 115)) and v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave))) then
				return "primordial_wave precombat 8";
			end
		end
		if ((v14:IsCasting(v100.ElementalBlast) and v41 and not v100.PrimordialWave:IsAvailable() and v100.FlameShock:IsViable()) or ((121 + 150) > (5922 - (663 + 511)))) then
			if (((4229 + 511) >= (685 + 2467)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
				return "flameshock precombat 10";
			end
		end
		if ((v126(v100.LavaBurst) and v45 and not v14:IsCasting(v100.LavaBurst) and (not v100.ElementalBlast:IsAvailable() or (v100.ElementalBlast:IsAvailable() and not v100.ElementalBlast:IsAvailable()))) or ((7947 - 5369) >= (2053 + 1337))) then
			if (((96 - 55) <= (4020 - 2359)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lavaburst precombat 12";
			end
		end
		if (((287 + 314) < (6929 - 3369)) and v14:IsCasting(v100.LavaBurst) and v41 and v100.FlameShock:IsReady()) then
			if (((168 + 67) < (63 + 624)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
				return "flameshock precombat 14";
			end
		end
		if (((5271 - (478 + 244)) > (1670 - (440 + 77))) and v14:IsCasting(v100.LavaBurst) and v48 and ((v65 and v35) or not v65) and v126(v100.PrimordialWave)) then
			if (v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave)) or ((2126 + 2548) < (17099 - 12427))) then
				return "primordial_wave precombat 16";
			end
		end
	end
	local function v137()
		if (((5224 - (655 + 901)) < (846 + 3715)) and v100.FireElemental:IsReady() and v54 and ((v60 and v34) or not v60) and (v91 < v108)) then
			if (v25(v100.FireElemental) or ((349 + 106) == (2435 + 1170))) then
				return "fire_elemental aoe 2";
			end
		end
		if ((v100.StormElemental:IsReady() and v56 and ((v61 and v34) or not v61) and (v91 < v108)) or ((10728 - 8065) == (4757 - (695 + 750)))) then
			if (((14604 - 10327) <= (6905 - 2430)) and v25(v100.StormElemental)) then
				return "storm_elemental aoe 4";
			end
		end
		if ((v126(v100.Stormkeeper) and not v129() and v49 and ((v66 and v35) or not v66) and (v91 < v108)) or ((3498 - 2628) == (1540 - (285 + 66)))) then
			if (((3620 - 2067) <= (4443 - (682 + 628))) and v25(v100.Stormkeeper)) then
				return "stormkeeper aoe 7";
			end
		end
		if ((v100.TotemicRecall:IsCastable() and (v100.LiquidMagmaTotem:CooldownRemains() > (8 + 37)) and v50) or ((2536 - (176 + 123)) >= (1469 + 2042))) then
			if (v25(v100.TotemicRecall) or ((961 + 363) > (3289 - (239 + 30)))) then
				return "totemic_recall aoe 8";
			end
		end
		if ((v100.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v34) or not v62) and (v91 < v108) and (v67 == "cursor")) or ((814 + 2178) == (1808 + 73))) then
			if (((5496 - 2390) > (4760 - 3234)) and v25(v102.LiquidMagmaTotemCursor, not v17:IsInRange(355 - (306 + 9)))) then
				return "liquid_magma_totem aoe cursor 10";
			end
		end
		if (((10549 - 7526) < (674 + 3196)) and v100.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v34) or not v62) and (v91 < v108) and (v67 == "player")) then
			if (((88 + 55) > (36 + 38)) and v25(v102.LiquidMagmaTotemPlayer, not v17:IsInRange(114 - 74))) then
				return "liquid_magma_totem aoe player 11";
			end
		end
		if (((1393 - (1140 + 235)) < (1345 + 767)) and v126(v100.PrimordialWave) and v14:BuffDown(v100.PrimordialWaveBuff) and v14:BuffUp(v100.SurgeofPowerBuff) and v14:BuffDown(v100.SplinteredElementsBuff)) then
			local v202 = 0 + 0;
			while true do
				if (((282 + 815) <= (1680 - (33 + 19))) and (v202 == (0 + 0))) then
					if (((13877 - 9247) == (2040 + 2590)) and v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v17:IsSpellInRange(v100.PrimordialWave), nil, nil)) then
						return "primordial_wave aoe 12";
					end
					if (((6942 - 3402) > (2516 + 167)) and v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave aoe 12";
					end
					break;
				end
			end
		end
		if (((5483 - (586 + 103)) >= (299 + 2976)) and v126(v100.PrimordialWave) and v14:BuffDown(v100.PrimordialWaveBuff) and v100.DeeplyRootedElements:IsAvailable() and not v100.SurgeofPower:IsAvailable() and v14:BuffDown(v100.SplinteredElementsBuff)) then
			local v203 = 0 - 0;
			while true do
				if (((2972 - (1309 + 179)) == (2678 - 1194)) and (v203 == (0 + 0))) then
					if (((3845 - 2413) < (2686 + 869)) and v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v17:IsSpellInRange(v100.PrimordialWave), nil, nil)) then
						return "primordial_wave aoe 14";
					end
					if (v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave)) or ((2262 - 1197) > (7129 - 3551))) then
						return "primordial_wave aoe 14";
					end
					break;
				end
			end
		end
		if ((v126(v100.PrimordialWave) and v14:BuffDown(v100.PrimordialWaveBuff) and v100.MasteroftheElements:IsAvailable() and not v100.LightningRod:IsAvailable()) or ((5404 - (295 + 314)) < (3455 - 2048))) then
			if (((3815 - (1300 + 662)) < (15113 - 10300)) and v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v17:IsSpellInRange(v100.PrimordialWave), nil, nil)) then
				return "primordial_wave aoe 16";
			end
			if (v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave)) or ((4576 - (1178 + 577)) < (1263 + 1168))) then
				return "primordial_wave aoe 16";
			end
		end
		if (v100.FlameShock:IsCastable() or ((8496 - 5622) < (3586 - (851 + 554)))) then
			local v204 = 0 + 0;
			while true do
				if ((v204 == (2 - 1)) or ((5839 - 3150) <= (645 - (115 + 187)))) then
					if ((v100.MasteroftheElements:IsAvailable() and v41 and not v100.LightningRod:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (5 + 1))) or ((1770 + 99) == (7916 - 5907))) then
						local v251 = 1161 - (160 + 1001);
						while true do
							if ((v251 == (0 + 0)) or ((2447 + 1099) < (4752 - 2430))) then
								if (v104.CastCycle(v100.FlameShock, v112, v120, not v17:IsSpellInRange(v100.FlameShock)) or ((2440 - (237 + 121)) == (5670 - (525 + 372)))) then
									return "flame_shock aoe 22";
								end
								if (((6150 - 2906) > (3466 - 2411)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 22";
								end
								break;
							end
						end
					end
					if ((v100.DeeplyRootedElements:IsAvailable() and v41 and not v100.SurgeofPower:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (148 - (96 + 46)))) or ((4090 - (643 + 134)) <= (642 + 1136))) then
						local v252 = 0 - 0;
						while true do
							if ((v252 == (0 - 0)) or ((1363 + 58) >= (4128 - 2024))) then
								if (((3703 - 1891) <= (3968 - (316 + 403))) and v104.CastCycle(v100.FlameShock, v112, v120, not v17:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 24";
								end
								if (((1079 + 544) <= (5380 - 3423)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 24";
								end
								break;
							end
						end
					end
					v204 = 1 + 1;
				end
				if (((11110 - 6698) == (3127 + 1285)) and (v204 == (0 + 0))) then
					if (((6063 - 4313) >= (4021 - 3179)) and v14:BuffUp(v100.SurgeofPowerBuff) and v41 and v100.LightningRod:IsAvailable() and v100.WindspeakersLavaResurgence:IsAvailable() and (v17:DebuffRemains(v100.FlameShockDebuff) < (v17:TimeToDie() - (33 - 17))) and (v111 < (1 + 4))) then
						if (((8606 - 4234) > (91 + 1759)) and v104.CastCycle(v100.FlameShock, v112, v120, not v17:IsSpellInRange(v100.FlameShock))) then
							return "flame_shock aoe 18";
						end
						if (((682 - 450) < (838 - (12 + 5))) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
							return "flame_shock aoe 18";
						end
					end
					if (((2011 - 1493) < (1924 - 1022)) and v14:BuffUp(v100.SurgeofPowerBuff) and v41 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable()) and (v100.FlameShockDebuff:AuraActiveCount() < (12 - 6))) then
						if (((7424 - 4430) > (175 + 683)) and v104.CastCycle(v100.FlameShock, v112, v120, not v17:IsSpellInRange(v100.FlameShock))) then
							return "flame_shock aoe 20";
						end
						if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((5728 - (1656 + 317)) <= (816 + 99))) then
							return "flame_shock aoe 20";
						end
					end
					v204 = 1 + 0;
				end
				if (((10492 - 6546) > (18421 - 14678)) and (v204 == (357 - (5 + 349)))) then
					if ((v100.DeeplyRootedElements:IsAvailable() and v41 and not v100.SurgeofPower:IsAvailable()) or ((6341 - 5006) >= (4577 - (266 + 1005)))) then
						local v253 = 0 + 0;
						while true do
							if (((16528 - 11684) > (2965 - 712)) and (v253 == (1696 - (561 + 1135)))) then
								if (((588 - 136) == (1485 - 1033)) and v104.CastCycle(v100.FlameShock, v112, v121, not v17:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 30";
								end
								if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((5623 - (507 + 559)) < (5236 - 3149))) then
									return "flame_shock aoe 30";
								end
								break;
							end
						end
					end
					break;
				end
				if (((11980 - 8106) == (4262 - (212 + 176))) and (v204 == (907 - (250 + 655)))) then
					if ((v14:BuffUp(v100.SurgeofPowerBuff) and v41 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable())) or ((5284 - 3346) > (8623 - 3688))) then
						if (v104.CastCycle(v100.FlameShock, v112, v121, not v17:IsSpellInRange(v100.FlameShock)) or ((6657 - 2402) < (5379 - (1869 + 87)))) then
							return "flame_shock aoe 26";
						end
						if (((5042 - 3588) <= (4392 - (484 + 1417))) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
							return "flame_shock aoe 26";
						end
					end
					if ((v100.MasteroftheElements:IsAvailable() and v41 and not v100.LightningRod:IsAvailable() and not v100.SurgeofPower:IsAvailable()) or ((8909 - 4752) <= (4696 - 1893))) then
						local v254 = 773 - (48 + 725);
						while true do
							if (((7927 - 3074) >= (8000 - 5018)) and (v254 == (0 + 0))) then
								if (((11047 - 6913) > (940 + 2417)) and v104.CastCycle(v100.FlameShock, v112, v121, not v17:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 28";
								end
								if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((996 + 2421) < (3387 - (152 + 701)))) then
									return "flame_shock aoe 28";
								end
								break;
							end
						end
					end
					v204 = 1314 - (430 + 881);
				end
			end
		end
		if ((v100.Ascendance:IsCastable() and v53 and ((v59 and v34) or not v59) and (v91 < v108)) or ((1043 + 1679) <= (1059 - (557 + 338)))) then
			if (v25(v100.Ascendance) or ((712 + 1696) < (5942 - 3833))) then
				return "ascendance aoe 32";
			end
		end
		if ((v126(v100.LavaBurst) and (v114 == (10 - 7)) and not v100.LightningRod:IsAvailable() and v14:HasTier(82 - 51, 8 - 4)) or ((834 - (499 + 302)) == (2321 - (39 + 827)))) then
			if (v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst)) or ((1222 - 779) >= (8967 - 4952))) then
				return "lava_burst aoe 34";
			end
			if (((13432 - 10050) > (254 - 88)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst aoe 34";
			end
		end
		if ((v38 and v100.Earthquake:IsReady() and v127() and (((v14:BuffStack(v100.MagmaChamberBuff) > (2 + 13)) and (v114 >= ((20 - 13) - v26(v100.UnrelentingCalamity:IsAvailable())))) or (v100.SplinteredElements:IsAvailable() and (v114 >= ((2 + 8) - v26(v100.UnrelentingCalamity:IsAvailable())))) or (v100.MountainsWillFall:IsAvailable() and (v114 >= (13 - 4)))) and not v100.LightningRod:IsAvailable() and v14:HasTier(135 - (103 + 1), 558 - (475 + 79))) or ((605 - 325) == (9788 - 6729))) then
			if (((244 + 1637) > (1138 + 155)) and (v52 == "cursor")) then
				if (((3860 - (1395 + 108)) == (6858 - 4501)) and v25(v102.EarthquakeCursor, not v17:IsInRange(1244 - (7 + 1197)))) then
					return "earthquake aoe 36";
				end
			end
			if (((54 + 69) == (43 + 80)) and (v52 == "player")) then
				if (v25(v102.EarthquakePlayer, not v17:IsInRange(359 - (27 + 292))) or ((3094 - 2038) >= (4325 - 933))) then
					return "earthquake aoe 36";
				end
			end
		end
		if ((v126(v100.LavaBeam) and v44 and v129() and ((v14:BuffUp(v100.SurgeofPowerBuff) and (v114 >= (25 - 19))) or (v127() and ((v114 < (11 - 5)) or not v100.SurgeofPower:IsAvailable()))) and not v100.LightningRod:IsAvailable() and v14:HasTier(58 - 27, 143 - (43 + 96))) or ((4409 - 3328) < (2430 - 1355))) then
			if (v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam)) or ((871 + 178) >= (1252 + 3180))) then
				return "lava_beam aoe 38";
			end
		end
		if ((v126(v100.ChainLightning) and v37 and v129() and ((v14:BuffUp(v100.SurgeofPowerBuff) and (v114 >= (11 - 5))) or (v127() and ((v114 < (3 + 3)) or not v100.SurgeofPower:IsAvailable()))) and not v100.LightningRod:IsAvailable() and v14:HasTier(57 - 26, 2 + 2)) or ((350 + 4418) <= (2597 - (1414 + 337)))) then
			if (v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning)) or ((5298 - (1642 + 298)) <= (3701 - 2281))) then
				return "chain_lightning aoe 40";
			end
		end
		if ((v126(v100.LavaBurst) and v14:BuffUp(v100.LavaSurgeBuff) and not v100.LightningRod:IsAvailable() and v14:HasTier(89 - 58, 11 - 7)) or ((1231 + 2508) <= (2339 + 666))) then
			if (v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst)) or ((2631 - (357 + 615)) >= (1498 + 636))) then
				return "lava_burst aoe 42";
			end
			if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((7999 - 4739) < (2018 + 337))) then
				return "lava_burst aoe 42";
			end
		end
		if ((v126(v100.LavaBurst) and v14:BuffUp(v100.LavaSurgeBuff) and v100.MasteroftheElements:IsAvailable() and not v127() and (v125() >= (((128 - 68) - ((4 + 1) * v100.EyeoftheStorm:TalentRank())) - ((1 + 1) * v26(v100.FlowofPower:IsAvailable())))) and ((not v100.EchoesofGreatSundering:IsAvailable() and not v100.LightningRod:IsAvailable()) or v14:BuffUp(v100.EchoesofGreatSunderingBuff)) and ((not v14:BuffUp(v100.AscendanceBuff) and (v114 > (2 + 1)) and v100.UnrelentingCalamity:IsAvailable()) or ((v114 > (1304 - (384 + 917))) and not v100.UnrelentingCalamity:IsAvailable()) or (v114 == (700 - (128 + 569))))) or ((2212 - (1407 + 136)) == (6110 - (687 + 1200)))) then
			if (v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst)) or ((3402 - (556 + 1154)) < (2068 - 1480))) then
				return "lava_burst aoe 44";
			end
			if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((4892 - (9 + 86)) < (4072 - (275 + 146)))) then
				return "lava_burst aoe 44";
			end
		end
		if ((v38 and v100.Earthquake:IsReady() and not v100.EchoesofGreatSundering:IsAvailable() and (v114 > (1 + 2)) and ((v114 > (67 - (29 + 35))) or (v113 > (13 - 10)))) or ((12476 - 8299) > (21410 - 16560))) then
			local v205 = 0 + 0;
			while true do
				if ((v205 == (1012 - (53 + 959))) or ((808 - (312 + 96)) > (1928 - 817))) then
					if (((3336 - (147 + 138)) > (1904 - (813 + 86))) and (v52 == "cursor")) then
						if (((3338 + 355) <= (8118 - 3736)) and v25(v102.EarthquakeCursor, not v17:IsInRange(532 - (18 + 474)))) then
							return "earthquake aoe 46";
						end
					end
					if ((v52 == "player") or ((1108 + 2174) > (13381 - 9281))) then
						if (v25(v102.EarthquakePlayer, not v17:IsInRange(1126 - (860 + 226))) or ((3883 - (121 + 182)) < (351 + 2493))) then
							return "earthquake aoe 46";
						end
					end
					break;
				end
			end
		end
		if (((1329 - (988 + 252)) < (508 + 3982)) and v38 and v100.Earthquake:IsReady() and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (v114 == (1 + 2)) and ((v114 == (1973 - (49 + 1921))) or (v113 == (893 - (223 + 667))))) then
			if ((v52 == "cursor") or ((5035 - (51 + 1)) < (3111 - 1303))) then
				if (((8198 - 4369) > (4894 - (146 + 979))) and v25(v102.EarthquakeCursor, not v17:IsInRange(12 + 28))) then
					return "earthquake aoe 48";
				end
			end
			if (((2090 - (311 + 294)) <= (8098 - 5194)) and (v52 == "player")) then
				if (((1809 + 2460) == (5712 - (496 + 947))) and v25(v102.EarthquakePlayer, not v17:IsInRange(1398 - (1233 + 125)))) then
					return "earthquake aoe 48";
				end
			end
		end
		if (((158 + 229) <= (2496 + 286)) and v38 and v100.Earthquake:IsReady() and (v14:BuffUp(v100.EchoesofGreatSunderingBuff))) then
			if ((v52 == "cursor") or ((361 + 1538) <= (2562 - (963 + 682)))) then
				if (v25(v102.EarthquakeCursor, not v17:IsInRange(34 + 6)) or ((5816 - (504 + 1000)) <= (590 + 286))) then
					return "earthquake aoe 50";
				end
			end
			if (((2033 + 199) <= (245 + 2351)) and (v52 == "player")) then
				if (((3089 - 994) < (3150 + 536)) and v25(v102.EarthquakePlayer, not v17:IsInRange(24 + 16))) then
					return "earthquake aoe 50";
				end
			end
		end
		if ((v126(v100.ElementalBlast) and v40 and v100.EchoesofGreatSundering:IsAvailable()) or ((1777 - (156 + 26)) >= (2578 + 1896))) then
			local v206 = 0 - 0;
			while true do
				if ((v206 == (164 - (149 + 15))) or ((5579 - (890 + 70)) < (2999 - (39 + 78)))) then
					if (v104.CastTargetIf(v100.ElementalBlast, v112, "min", v124, nil, not v17:IsSpellInRange(v100.ElementalBlast), nil, nil) or ((776 - (14 + 468)) >= (10623 - 5792))) then
						return "elemental_blast aoe 52";
					end
					if (((5671 - 3642) <= (1592 + 1492)) and v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast aoe 52";
					end
					break;
				end
			end
		end
		if ((v126(v100.ElementalBlast) and v40 and v100.EchoesofGreatSundering:IsAvailable()) or ((1224 + 813) == (515 + 1905))) then
			if (((2014 + 2444) > (1023 + 2881)) and v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast aoe 54";
			end
		end
		if (((834 - 398) >= (122 + 1)) and v126(v100.ElementalBlast) and v40 and (v114 == (10 - 7)) and not v100.EchoesofGreatSundering:IsAvailable()) then
			if (((13 + 487) < (1867 - (12 + 39))) and v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast aoe 56";
			end
		end
		if (((3326 + 248) == (11062 - 7488)) and v126(v100.EarthShock) and v39 and v100.EchoesofGreatSundering:IsAvailable()) then
			if (((786 - 565) < (116 + 274)) and v104.CastTargetIf(v100.EarthShock, v112, "min", v124, nil, not v17:IsSpellInRange(v100.EarthShock), nil, nil)) then
				return "earth_shock aoe 58";
			end
			if (v25(v100.EarthShock, not v17:IsSpellInRange(v100.EarthShock)) or ((1165 + 1048) <= (3603 - 2182))) then
				return "earth_shock aoe 58";
			end
		end
		if (((2037 + 1021) < (23487 - 18627)) and v126(v100.EarthShock) and v39 and v100.EchoesofGreatSundering:IsAvailable()) then
			if (v25(v100.EarthShock, not v17:IsSpellInRange(v100.EarthShock)) or ((3006 - (1596 + 114)) >= (11607 - 7161))) then
				return "earth_shock aoe 60";
			end
		end
		if ((v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (713 - (164 + 549))) and v43 and not v14:BuffUp(v100.AscendanceBuff) and v100.ElectrifiedShocks:IsAvailable() and ((v100.LightningRod:IsAvailable() and (v114 < (1443 - (1059 + 379))) and not v127()) or (v100.DeeplyRootedElements:IsAvailable() and (v114 == (3 - 0))))) or ((722 + 671) > (757 + 3732))) then
			if (v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury)) or ((4816 - (145 + 247)) < (23 + 4))) then
				return "icefury aoe 62";
			end
		end
		if ((v126(v100.FrostShock) and v42 and not v14:BuffUp(v100.AscendanceBuff) and v14:BuffUp(v100.IcefuryBuff) and v100.ElectrifiedShocks:IsAvailable() and (not v17:DebuffUp(v100.ElectrifiedShocksDebuff) or (v14:BuffRemains(v100.IcefuryBuff) < v14:GCD())) and ((v100.LightningRod:IsAvailable() and (v114 < (3 + 2)) and not v127()) or (v100.DeeplyRootedElements:IsAvailable() and (v114 == (8 - 5))))) or ((384 + 1613) > (3287 + 528))) then
			if (((5625 - 2160) > (2633 - (254 + 466))) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock aoe 64";
			end
		end
		if (((1293 - (544 + 16)) < (5780 - 3961)) and v126(v100.LavaBurst) and v100.MasteroftheElements:IsAvailable() and not v127() and (v129() or ((v118() < (631 - (294 + 334))) and v14:HasTier(283 - (236 + 17), 1 + 1))) and (v125() < ((((47 + 13) - ((18 - 13) * v100.EyeoftheStorm:TalentRank())) - ((9 - 7) * v26(v100.FlowofPower:IsAvailable()))) - (6 + 4))) and (v114 < (5 + 0))) then
			local v207 = 794 - (413 + 381);
			while true do
				if ((v207 == (0 + 0)) or ((9347 - 4952) == (12351 - 7596))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst)) or ((5763 - (582 + 1388)) < (4035 - 1666))) then
						return "lava_burst aoe 66";
					end
					if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((2924 + 1160) == (629 - (326 + 38)))) then
						return "lava_burst aoe 66";
					end
					break;
				end
			end
		end
		if (((12891 - 8533) == (6220 - 1862)) and v126(v100.LavaBeam) and v44 and (v129())) then
			if (v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam)) or ((3758 - (47 + 573)) < (351 + 642))) then
				return "lava_beam aoe 68";
			end
		end
		if (((14142 - 10812) > (3769 - 1446)) and v126(v100.ChainLightning) and v37 and (v129())) then
			if (v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning)) or ((5290 - (1269 + 395)) == (4481 - (76 + 416)))) then
				return "chain_lightning aoe 70";
			end
		end
		if ((v126(v100.LavaBeam) and v44 and v128() and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((1359 - (319 + 124)) == (6105 - 3434))) then
			if (((1279 - (564 + 443)) == (752 - 480)) and v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam aoe 72";
			end
		end
		if (((4707 - (337 + 121)) <= (14178 - 9339)) and v126(v100.ChainLightning) and v37 and v128()) then
			if (((9250 - 6473) < (5111 - (1261 + 650))) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning aoe 74";
			end
		end
		if (((41 + 54) < (3118 - 1161)) and v126(v100.LavaBeam) and v44 and (v114 >= (1823 - (772 + 1045))) and v14:BuffUp(v100.SurgeofPowerBuff) and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) then
			if (((117 + 709) < (1861 - (102 + 42))) and v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam aoe 76";
			end
		end
		if (((3270 - (1524 + 320)) >= (2375 - (1049 + 221))) and v126(v100.ChainLightning) and v37 and (v114 >= (162 - (18 + 138))) and v14:BuffUp(v100.SurgeofPowerBuff)) then
			if (((6740 - 3986) <= (4481 - (67 + 1035))) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning aoe 78";
			end
		end
		if ((v126(v100.LavaBurst) and v14:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable() and v14:BuffUp(v100.WindspeakersLavaResurgenceBuff)) or ((4275 - (136 + 212)) == (6004 - 4591))) then
			local v208 = 0 + 0;
			while true do
				if ((v208 == (0 + 0)) or ((2758 - (240 + 1364)) <= (1870 - (1050 + 32)))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst)) or ((5866 - 4223) > (1999 + 1380))) then
						return "lava_burst aoe 80";
					end
					if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((3858 - (331 + 724)) > (368 + 4181))) then
						return "lava_burst aoe 80";
					end
					break;
				end
			end
		end
		if ((v126(v100.LavaBeam) and v44 and v127() and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((864 - (269 + 375)) >= (3747 - (267 + 458)))) then
			if (((878 + 1944) == (5426 - 2604)) and v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam aoe 82";
			end
		end
		if ((v126(v100.LavaBurst) and (v114 == (821 - (667 + 151))) and v100.MasteroftheElements:IsAvailable()) or ((2558 - (1410 + 87)) == (3754 - (1504 + 393)))) then
			if (((7460 - 4700) > (3538 - 2174)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst aoe 84";
			end
			if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((5698 - (461 + 335)) <= (460 + 3135))) then
				return "lava_burst aoe 84";
			end
		end
		if ((v126(v100.LavaBurst) and v14:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable()) or ((5613 - (1730 + 31)) == (1960 - (728 + 939)))) then
			local v209 = 0 - 0;
			while true do
				if ((v209 == (0 - 0)) or ((3571 - 2012) == (5656 - (138 + 930)))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst)) or ((4098 + 386) == (617 + 171))) then
						return "lava_burst aoe 86";
					end
					if (((3915 + 653) >= (15953 - 12046)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 86";
					end
					break;
				end
			end
		end
		if (((3012 - (459 + 1307)) < (5340 - (474 + 1396))) and v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 - 0)) and v43 and v100.ElectrifiedShocks:IsAvailable() and (v114 < (5 + 0))) then
			if (((14 + 4054) >= (2784 - 1812)) and v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury))) then
				return "icefury aoe 88";
			end
		end
		if (((63 + 430) < (12995 - 9102)) and v126(v100.FrostShock) and v42 and v14:BuffUp(v100.IcefuryBuff) and v100.ElectrifiedShocks:IsAvailable() and not v17:DebuffUp(v100.ElectrifiedShocksDebuff) and (v114 < (21 - 16)) and v100.UnrelentingCalamity:IsAvailable()) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((2064 - (562 + 29)) >= (2841 + 491))) then
				return "frost_shock aoe 90";
			end
		end
		if ((v126(v100.LavaBeam) and v44 and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((5470 - (374 + 1045)) <= (916 + 241))) then
			if (((1875 - 1271) < (3519 - (448 + 190))) and v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam aoe 92";
			end
		end
		if ((v126(v100.ChainLightning) and v37) or ((291 + 609) == (1525 + 1852))) then
			if (((2906 + 1553) > (2272 - 1681)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning aoe 94";
			end
		end
		if (((10558 - 7160) >= (3889 - (1307 + 187))) and v100.FlameShock:IsCastable() and v41 and v14:IsMoving() and v17:DebuffRefreshable(v100.FlameShockDebuff)) then
			if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((8656 - 6473) >= (6611 - 3787))) then
				return "flame_shock aoe 96";
			end
		end
		if (((5936 - 4000) == (2619 - (232 + 451))) and v100.FrostShock:IsCastable() and v42 and v14:IsMoving()) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((4614 + 218) < (3811 + 502))) then
				return "frost_shock aoe 98";
			end
		end
	end
	local function v138()
		if (((4652 - (510 + 54)) > (7804 - 3930)) and v100.FireElemental:IsCastable() and v54 and ((v60 and v34) or not v60) and (v91 < v108)) then
			if (((4368 - (13 + 23)) == (8444 - 4112)) and v25(v100.FireElemental)) then
				return "fire_elemental single_target 2";
			end
		end
		if (((5745 - 1746) >= (5269 - 2369)) and v100.StormElemental:IsCastable() and v56 and ((v61 and v34) or not v61) and (v91 < v108)) then
			if (v25(v100.StormElemental) or ((3613 - (830 + 258)) > (14336 - 10272))) then
				return "storm_elemental single_target 4";
			end
		end
		if (((2735 + 1636) == (3719 + 652)) and v100.TotemicRecall:IsCastable() and v50 and (v100.LiquidMagmaTotem:CooldownRemains() > (1486 - (860 + 581))) and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or ((v113 > (3 - 2)) and (v114 > (1 + 0))))) then
			if (v25(v100.TotemicRecall) or ((507 - (237 + 4)) > (11717 - 6731))) then
				return "totemic_recall single_target 6";
			end
		end
		if (((5037 - 3046) >= (1753 - 828)) and v100.LiquidMagmaTotem:IsCastable() and v55 and ((v62 and v34) or not v62) and (v91 < v108) and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or (v100.FlameShockDebuff:AuraActiveCount() == (0 + 0)) or (v17:DebuffRemains(v100.FlameShockDebuff) < (4 + 2)) or ((v113 > (3 - 2)) and (v114 > (1 + 0))))) then
			local v210 = 0 + 0;
			while true do
				if (((1881 - (85 + 1341)) < (3502 - 1449)) and (v210 == (0 - 0))) then
					if ((v67 == "cursor") or ((1198 - (45 + 327)) == (9153 - 4302))) then
						if (((685 - (444 + 58)) == (80 + 103)) and v25(v102.LiquidMagmaTotemCursor, not v17:IsInRange(7 + 33))) then
							return "liquid_magma_totem single_target cursor 8";
						end
					end
					if (((567 + 592) <= (5181 - 3393)) and (v67 == "player")) then
						if (v25(v102.LiquidMagmaTotemPlayer, not v17:IsInRange(1772 - (64 + 1668))) or ((5480 - (1227 + 746)) > (13272 - 8954))) then
							return "liquid_magma_totem single_target player 8";
						end
					end
					break;
				end
			end
		end
		if ((v126(v100.PrimordialWave) and v100.PrimordialWave:IsCastable() and v48 and ((v65 and v35) or not v65) and not v14:BuffUp(v100.PrimordialWaveBuff) and not v14:BuffUp(v100.SplinteredElementsBuff)) or ((5706 - 2631) <= (3459 - (415 + 79)))) then
			if (((36 + 1329) <= (2502 - (142 + 349))) and v104.CastCycle(v100.PrimordialWave, v112, v122, not v17:IsSpellInRange(v100.PrimordialWave))) then
				return "primordial_wave single_target 10";
			end
			if (v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave)) or ((1190 + 1586) > (4915 - 1340))) then
				return "primordial_wave single_target 10";
			end
		end
		if ((v100.FlameShock:IsCastable() and v41 and (v113 == (1 + 0)) and v17:DebuffRefreshable(v100.FlameShockDebuff) and ((v17:DebuffRemains(v100.FlameShockDebuff) < v100.PrimordialWave:CooldownRemains()) or not v100.PrimordialWave:IsAvailable()) and v14:BuffDown(v100.SurgeofPowerBuff) and (not v127() or (not v129() and ((v100.ElementalBlast:IsAvailable() and (v125() < ((64 + 26) - ((21 - 13) * v100.EyeoftheStorm:TalentRank())))) or (v125() < ((1924 - (1710 + 154)) - ((323 - (200 + 118)) * v100.EyeoftheStorm:TalentRank()))))))) or ((1012 + 1542) == (8398 - 3594))) then
			if (((3821 - 1244) == (2290 + 287)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 12";
			end
		end
		if ((v100.FlameShock:IsCastable() and v41 and (v100.FlameShockDebuff:AuraActiveCount() == (0 + 0)) and (v113 > (1 + 0)) and (v114 > (1 + 0)) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((not v127() and (v129() or (v100.Stormkeeper:CooldownRemains() > (0 - 0)))) or not v100.SurgeofPower:IsAvailable())) or ((1256 - (363 + 887)) >= (3298 - 1409))) then
			if (((2408 - 1902) <= (293 + 1599)) and v104.CastTargetIf(v100.FlameShock, v112, "min", v122, nil, not v17:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 14";
			end
			if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((4698 - 2690) > (1516 + 702))) then
				return "flame_shock single_target 14";
			end
		end
		if (((2043 - (674 + 990)) <= (1189 + 2958)) and v100.FlameShock:IsCastable() and v41 and (v113 > (1 + 0)) and (v114 > (1 - 0)) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((v14:BuffUp(v100.SurgeofPowerBuff) and not v129() and v100.Stormkeeper:IsAvailable()) or not v100.SurgeofPower:IsAvailable())) then
			local v211 = 1055 - (507 + 548);
			while true do
				if (((837 - (289 + 548)) == v211) or ((6332 - (821 + 997)) <= (1264 - (195 + 60)))) then
					if (v104.CastTargetIf(v100.FlameShock, v112, "min", v122, v119, not v17:IsSpellInRange(v100.FlameShock)) or ((941 + 2555) == (2693 - (251 + 1250)))) then
						return "flame_shock single_target 16";
					end
					if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((609 - 401) == (2034 + 925))) then
						return "flame_shock single_target 16";
					end
					break;
				end
			end
		end
		if (((5309 - (809 + 223)) >= (1915 - 602)) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v100.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v108) and v14:BuffDown(v100.AscendanceBuff) and not v129() and (v125() >= (383 - 267)) and v100.ElementalBlast:IsAvailable() and v100.SurgeofPower:IsAvailable() and v100.SwellingMaelstrom:IsAvailable() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) then
			if (((1906 + 681) < (1663 + 1511)) and v25(v100.Stormkeeper)) then
				return "stormkeeper single_target 18";
			end
		end
		if ((v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (617 - (14 + 603))) and not v14:BuffUp(v100.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v108) and v14:BuffDown(v100.AscendanceBuff) and not v129() and v14:BuffUp(v100.SurgeofPowerBuff) and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) or ((4249 - (118 + 11)) <= (356 + 1842))) then
			if (v25(v100.Stormkeeper) or ((1330 + 266) == (2500 - 1642))) then
				return "stormkeeper single_target 20";
			end
		end
		if (((4169 - (551 + 398)) == (2035 + 1185)) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 + 0)) and not v14:BuffUp(v100.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v108) and v14:BuffDown(v100.AscendanceBuff) and not v129() and (not v100.SurgeofPower:IsAvailable() or not v100.ElementalBlast:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.EchooftheElements:IsAvailable() or v100.PrimordialSurge:IsAvailable())) then
			if (v25(v100.Stormkeeper) or ((1140 + 262) > (13462 - 9842))) then
				return "stormkeeper single_target 22";
			end
		end
		if (((5930 - 3356) == (835 + 1739)) and v100.Ascendance:IsCastable() and v53 and ((v59 and v34) or not v59) and (v91 < v108) and not v129()) then
			if (((7137 - 5339) < (762 + 1995)) and v25(v100.Ascendance)) then
				return "ascendance single_target 24";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v129() and v14:BuffUp(v100.SurgeofPowerBuff)) or ((466 - (40 + 49)) > (9916 - 7312))) then
			if (((1058 - (99 + 391)) < (754 + 157)) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 26";
			end
		end
		if (((14440 - 11155) < (10469 - 6241)) and v126(v100.LavaBeam) and v44 and (v113 > (1 + 0)) and (v114 > (2 - 1)) and v129() and not v100.SurgeofPower:IsAvailable()) then
			if (((5520 - (1032 + 572)) > (3745 - (203 + 214))) and v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam single_target 28";
			end
		end
		if (((4317 - (568 + 1249)) < (3004 + 835)) and v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v37 and (v113 > (2 - 1)) and (v114 > (3 - 2)) and v129() and not v100.SurgeofPower:IsAvailable()) then
			if (((1813 - (913 + 393)) == (1431 - 924)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 30";
			end
		end
		if (((339 - 99) <= (3575 - (269 + 141))) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v129() and not v127() and not v100.SurgeofPower:IsAvailable() and v100.MasteroftheElements:IsAvailable()) then
			if (((1854 - 1020) >= (2786 - (362 + 1619))) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 32";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v129() and not v100.SurgeofPower:IsAvailable() and v127()) or ((5437 - (950 + 675)) < (893 + 1423))) then
			if (v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt)) or ((3831 - (216 + 963)) <= (2820 - (485 + 802)))) then
				return "lightning_bolt single_target 34";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v129() and not v100.SurgeofPower:IsAvailable() and not v100.MasteroftheElements:IsAvailable()) or ((4157 - (432 + 127)) < (2533 - (1065 + 8)))) then
			if (v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt)) or ((2287 + 1829) < (2793 - (635 + 966)))) then
				return "lightning_bolt single_target 36";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v14:BuffUp(v100.SurgeofPowerBuff) and v100.LightningRod:IsAvailable()) or ((2429 + 948) <= (945 - (5 + 37)))) then
			if (((9888 - 5912) >= (183 + 256)) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 38";
			end
		end
		if (((5938 - 2186) == (1756 + 1996)) and v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 - 0)) and v43 and v100.ElectrifiedShocks:IsAvailable() and v100.LightningRod:IsAvailable() and v100.LightningRod:IsAvailable()) then
			if (((15339 - 11293) > (5082 - 2387)) and v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury))) then
				return "icefury single_target 40";
			end
		end
		if ((v100.FrostShock:IsCastable() and v42 and v130() and v100.ElectrifiedShocks:IsAvailable() and ((v17:DebuffRemains(v100.ElectrifiedShocksDebuff) < (4 - 2)) or (v14:BuffRemains(v100.IcefuryBuff) <= v14:GCD())) and v100.LightningRod:IsAvailable()) or ((2549 + 996) == (3726 - (318 + 211)))) then
			if (((11779 - 9385) > (1960 - (963 + 624))) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 42";
			end
		end
		if (((1776 + 2379) <= (5078 - (518 + 328))) and v100.FrostShock:IsCastable() and v42 and v130() and v100.ElectrifiedShocks:IsAvailable() and (v125() >= (116 - 66)) and (v17:DebuffRemains(v100.ElectrifiedShocksDebuff) < ((2 - 0) * v14:GCD())) and v129() and v100.LightningRod:IsAvailable()) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((3898 - (301 + 16)) == (10178 - 6705))) then
				return "frost_shock single_target 44";
			end
		end
		if (((14028 - 9033) > (8736 - 5388)) and v100.LavaBeam:IsCastable() and v44 and (v113 > (1 + 0)) and (v114 > (1 + 0)) and v128() and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime()) and not v14:HasTier(65 - 34, 3 + 1)) then
			if (v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam)) or ((72 + 682) > (11839 - 8115))) then
				return "lava_beam single_target 46";
			end
		end
		if (((71 + 146) >= (1076 - (829 + 190))) and v100.FrostShock:IsCastable() and v42 and v130() and v129() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable() and v100.ElementalBlast:IsAvailable() and (((v125() >= (217 - 156)) and (v125() < (94 - 19)) and (v100.LavaBurst:CooldownRemains() > v14:GCD())) or ((v125() >= (67 - 18)) and (v125() < (156 - 93)) and (v100.LavaBurst:CooldownRemains() > (0 + 0))))) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((677 + 1393) >= (12253 - 8216))) then
				return "frost_shock single_target 48";
			end
		end
		if (((2553 + 152) == (3318 - (520 + 93))) and v100.FrostShock:IsCastable() and v42 and v130() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (((v125() >= (312 - (259 + 17))) and (v125() < (3 + 47)) and (v100.LavaBurst:CooldownRemains() > v14:GCD())) or ((v125() >= (9 + 15)) and (v125() < (128 - 90)) and (v100.LavaBurst:CooldownRemains() > (591 - (396 + 195)))))) then
			if (((176 - 115) == (1822 - (440 + 1321))) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 50";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v14:BuffUp(v100.WindspeakersLavaResurgenceBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or ((v125() >= (1892 - (1059 + 770))) and v100.MasteroftheElements:IsAvailable()) or ((v125() >= (175 - 137)) and v14:BuffUp(v100.EchoesofGreatSunderingBuff) and (v113 > (546 - (424 + 121))) and (v114 > (1 + 0))) or not v100.ElementalBlast:IsAvailable())) or ((2046 - (641 + 706)) >= (514 + 782))) then
			if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((2223 - (249 + 191)) >= (15752 - 12136))) then
				return "lava_burst single_target 52";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v14:BuffUp(v100.LavaSurgeBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or not v100.ElementalBlast:IsAvailable())) or ((1748 + 2165) > (17447 - 12920))) then
			if (((4803 - (183 + 244)) > (41 + 776)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 54";
			end
		end
		if (((5591 - (434 + 296)) > (2629 - 1805)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v14:BuffUp(v100.AscendanceBuff) and (v14:HasTier(543 - (169 + 343), 4 + 0) or not v100.ElementalBlast:IsAvailable())) then
			if (v104.CastCycle(v100.LavaBurst, v112, v123, not v17:IsSpellInRange(v100.LavaBurst)) or ((2432 - 1049) >= (6254 - 4123))) then
				return "lava_burst single_target 56";
			end
			if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((1537 + 339) >= (7206 - 4665))) then
				return "lava_burst single_target 56";
			end
		end
		if (((2905 - (651 + 472)) <= (2851 + 921)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v14:BuffDown(v100.AscendanceBuff) and (not v100.ElementalBlast:IsAvailable() or not v100.MountainsWillFall:IsAvailable()) and not v100.LightningRod:IsAvailable() and v14:HasTier(14 + 17, 4 - 0)) then
			if (v104.CastCycle(v100.LavaBurst, v112, v123, not v17:IsSpellInRange(v100.LavaBurst)) or ((5183 - (397 + 86)) < (1689 - (423 + 453)))) then
				return "lava_burst single_target 58";
			end
			if (((326 + 2873) < (534 + 3516)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 58";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v100.MasteroftheElements:IsAvailable() and not v127() and not v100.LightningRod:IsAvailable()) or ((4323 + 628) < (3536 + 894))) then
			if (((86 + 10) == (1286 - (50 + 1140))) and v104.CastCycle(v100.LavaBurst, v112, v123, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 60";
			end
			if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((2368 + 371) > (2367 + 1641))) then
				return "lava_burst single_target 60";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v100.MasteroftheElements:IsAvailable() and not v127() and ((v125() >= (5 + 70)) or ((v125() >= (71 - 21)) and not v100.ElementalBlast:IsAvailable())) and v100.SwellingMaelstrom:IsAvailable() and (v125() <= (95 + 35))) or ((619 - (157 + 439)) == (1971 - 837))) then
			if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((8948 - 6255) >= (12160 - 8049))) then
				return "lava_burst single_target 62";
			end
		end
		if ((v100.Earthquake:IsReady() and v38 and v14:BuffUp(v100.EchoesofGreatSunderingBuff) and ((not v100.ElementalBlast:IsAvailable() and (v113 < (920 - (782 + 136)))) or (v113 > (856 - (112 + 743))))) or ((5487 - (1026 + 145)) <= (369 + 1777))) then
			if ((v52 == "cursor") or ((4264 - (493 + 225)) <= (10324 - 7515))) then
				if (((2983 + 1921) > (5807 - 3641)) and v25(v102.EarthquakeCursor, not v17:IsInRange(1 + 39))) then
					return "earthquake single_target 64";
				end
			end
			if (((311 - 202) >= (27 + 63)) and (v52 == "player")) then
				if (((8316 - 3338) > (4500 - (210 + 1385))) and v25(v102.EarthquakePlayer, not v17:IsInRange(1729 - (1201 + 488)))) then
					return "earthquake single_target 64";
				end
			end
		end
		if ((v100.Earthquake:IsReady() and v38 and (v113 > (1 + 0)) and (v114 > (1 - 0)) and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable()) or ((5426 - 2400) <= (2865 - (352 + 233)))) then
			local v212 = 0 - 0;
			while true do
				if (((0 + 0) == v212) or ((4699 - 3046) <= (1682 - (489 + 85)))) then
					if (((4410 - (277 + 1224)) > (4102 - (663 + 830))) and (v52 == "cursor")) then
						if (((665 + 92) > (474 - 280)) and v25(v102.EarthquakeCursor, not v17:IsInRange(915 - (461 + 414)))) then
							return "earthquake single_target 66";
						end
					end
					if ((v52 == "player") or ((6 + 25) >= (560 + 838))) then
						if (((305 + 2891) <= (4803 + 69)) and v25(v102.EarthquakePlayer, not v17:IsInRange(290 - (172 + 78)))) then
							return "earthquake single_target 66";
						end
					end
					break;
				end
			end
		end
		if (((5362 - 2036) == (1225 + 2101)) and v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v40 and (not v100.MasteroftheElements:IsAvailable() or (v127() and v17:DebuffUp(v100.ElectrifiedShocksDebuff)))) then
			if (((2067 - 634) <= (1058 + 2820)) and v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast single_target 68";
			end
		end
		if ((v126(v100.FrostShock) and v42 and v130() and v127() and (v125() < (37 + 73)) and (v100.LavaBurst:ChargesFractional() < (1 - 0)) and v100.ElectrifiedShocks:IsAvailable() and v100.ElementalBlast:IsAvailable() and not v100.LightningRod:IsAvailable()) or ((1992 - 409) == (437 + 1298))) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((1649 + 1332) == (837 + 1513))) then
				return "frost_shock single_target 70";
			end
		end
		if ((v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v40 and (v127() or v100.LightningRod:IsAvailable())) or ((17777 - 13311) <= (1148 - 655))) then
			if (v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast)) or ((782 + 1765) <= (1135 + 852))) then
				return "elemental_blast single_target 72";
			end
		end
		if (((3408 - (133 + 314)) > (477 + 2263)) and v100.EarthShock:IsReady() and v39) then
			if (((3909 - (199 + 14)) >= (12930 - 9318)) and v25(v100.EarthShock, not v17:IsSpellInRange(v100.EarthShock))) then
				return "earth_shock single_target 74";
			end
		end
		if ((v126(v100.FrostShock) and v42 and v130() and v100.ElectrifiedShocks:IsAvailable() and v127() and not v100.LightningRod:IsAvailable() and (v113 > (1550 - (647 + 902))) and (v114 > (2 - 1))) or ((3203 - (85 + 148)) == (3167 - (426 + 863)))) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((17283 - 13590) < (3631 - (873 + 781)))) then
				return "frost_shock single_target 76";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and (v100.DeeplyRootedElements:IsAvailable())) or ((1245 - 315) > (5673 - 3572))) then
			if (((1721 + 2432) > (11400 - 8314)) and v104.CastCycle(v100.LavaBurst, v112, v123, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 78";
			end
			if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((6670 - 2016) <= (12025 - 7975))) then
				return "lava_burst single_target 78";
			end
		end
		if ((v100.FrostShock:IsCastable() and v42 and v130() and v100.FluxMelting:IsAvailable() and v14:BuffDown(v100.FluxMeltingBuff)) or ((4549 - (414 + 1533)) < (1298 + 198))) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((1575 - (443 + 112)) > (3767 - (888 + 591)))) then
				return "frost_shock single_target 80";
			end
		end
		if (((847 - 519) == (19 + 309)) and v100.FrostShock:IsCastable() and v42 and v130() and ((v100.ElectrifiedShocks:IsAvailable() and (v17:DebuffRemains(v100.ElectrifiedShocksDebuff) < (7 - 5))) or (v14:BuffRemains(v100.IcefuryBuff) < (3 + 3)))) then
			if (((731 + 780) < (407 + 3401)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 82";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.ElementalBlast:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or v129())) or ((4783 - 2273) > (9111 - 4192))) then
			local v213 = 1678 - (136 + 1542);
			while true do
				if (((15618 - 10855) == (4728 + 35)) and (v213 == (0 - 0))) then
					if (((2994 + 1143) > (2334 - (68 + 418))) and v104.CastCycle(v100.LavaBurst, v112, v123, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 84";
					end
					if (((6603 - 4167) <= (5685 - 2551)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 84";
					end
					break;
				end
			end
		end
		if (((3214 + 509) == (4815 - (770 + 322))) and v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v40) then
			if (v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast)) or ((234 + 3812) >= (1249 + 3067))) then
				return "elemental_blast single_target 86";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v37 and v128() and v100.UnrelentingCalamity:IsAvailable() and (v113 > (1 + 0)) and (v114 > (1 - 0))) or ((3893 - 1885) < (5253 - 3324))) then
			if (((8768 - 6384) > (989 + 786)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 88";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v128() and v100.UnrelentingCalamity:IsAvailable()) or ((6806 - 2263) <= (2100 + 2276))) then
			if (((447 + 281) == (571 + 157)) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 90";
			end
		end
		if ((v126(v100.Icefury) and v100.Icefury:IsCastable() and v43) or ((4051 - 2975) > (6487 - 1816))) then
			if (((626 + 1225) >= (1741 - 1363)) and v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury))) then
				return "icefury single_target 92";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v37 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v100.LightningRodDebuff) and (v17:DebuffUp(v100.ElectrifiedShocksDebuff) or v128()) and (v113 > (3 - 2)) and (v114 > (1 + 0))) or ((9639 - 7691) >= (4307 - (762 + 69)))) then
			if (((15523 - 10729) >= (718 + 115)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 94";
			end
		end
		if (((2648 + 1442) == (9892 - 5802)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v100.LightningRodDebuff) and (v17:DebuffUp(v100.ElectrifiedShocksDebuff) or v128())) then
			if (v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt)) or ((1183 + 2575) == (40 + 2458))) then
				return "lightning_bolt single_target 96";
			end
		end
		if ((v100.FrostShock:IsCastable() and v42 and v130() and v127() and v14:BuffDown(v100.LavaSurgeBuff) and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable() and (v100.LavaBurst:ChargesFractional() < (3 - 2)) and v100.EchooftheElements:IsAvailable()) or ((2830 - (8 + 149)) < (2895 - (1199 + 121)))) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((6296 - 2575) <= (3284 - 1829))) then
				return "frost_shock single_target 98";
			end
		end
		if (((385 + 549) < (8102 - 5832)) and v100.FrostShock:IsCastable() and v42 and v130() and (v100.FluxMelting:IsAvailable() or (v100.ElectrifiedShocks:IsAvailable() and not v100.LightningRod:IsAvailable()))) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((3740 - 2128) == (1111 + 144))) then
				return "frost_shock single_target 100";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v37 and v127() and v14:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (1808 - (518 + 1289))) and v100.EchooftheElements:IsAvailable() and (v113 > (1 - 0)) and (v114 > (1 + 0))) or ((6355 - 2003) < (3098 + 1108))) then
			if (v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning)) or ((3329 - (304 + 165)) <= (171 + 10))) then
				return "chain_lightning single_target 102";
			end
		end
		if (((3382 - (54 + 106)) >= (3496 - (1618 + 351))) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v127() and v14:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (1 + 0)) and v100.EchooftheElements:IsAvailable()) then
			if (((2521 - (10 + 1006)) <= (533 + 1588)) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 104";
			end
		end
		if (((105 + 639) == (2411 - 1667)) and v100.FrostShock:IsCastable() and v42 and v130() and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable()) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((3012 - (912 + 121)) >= (1341 + 1495))) then
				return "frost_shock single_target 106";
			end
		end
		if (((3122 - (1140 + 149)) <= (1708 + 960)) and v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v37 and (v113 > (1 - 0)) and (v114 > (1 + 0))) then
			if (((12614 - 8928) == (6912 - 3226)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 108";
			end
		end
		if (((599 + 2868) > (1655 - 1178)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46) then
			if (v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt)) or ((3474 - (165 + 21)) >= (3652 - (61 + 50)))) then
				return "lightning_bolt single_target 110";
			end
		end
		if ((v100.FlameShock:IsCastable() and v41 and (v14:IsMoving())) or ((1466 + 2091) == (21639 - 17099))) then
			if (v104.CastCycle(v100.FlameShock, v112, v119, not v17:IsSpellInRange(v100.FlameShock)) or ((525 - 264) > (498 + 769))) then
				return "flame_shock single_target 112";
			end
			if (((2732 - (1295 + 165)) < (881 + 2977)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 112";
			end
		end
		if (((1474 + 2190) == (5061 - (819 + 578))) and v100.FlameShock:IsCastable() and v41) then
			if (((3343 - (331 + 1071)) >= (1193 - (588 + 155))) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 114";
			end
		end
		if ((v100.FrostShock:IsCastable() and v42) or ((5928 - (546 + 736)) < (2261 - (1834 + 103)))) then
			if (((2358 + 1475) == (11434 - 7601)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 116";
			end
		end
	end
	local function v139()
		if ((v74 and v100.EarthShield:IsCastable() and v14:BuffDown(v100.EarthShieldBuff) and ((v75 == "Earth Shield") or (v100.ElementalOrbit:IsAvailable() and v14:BuffUp(v100.LightningShield)))) or ((3006 - (1536 + 230)) > (3861 - (128 + 363)))) then
			if (v25(v100.EarthShield) or ((528 + 1953) == (11648 - 6966))) then
				return "earth_shield main 2";
			end
		elseif (((1221 + 3506) >= (344 - 136)) and v74 and v100.LightningShield:IsCastable() and v14:BuffDown(v100.LightningShieldBuff) and ((v75 == "Lightning Shield") or (v100.ElementalOrbit:IsAvailable() and v14:BuffUp(v100.EarthShield)))) then
			if (((824 - 544) < (9353 - 5502)) and v25(v100.LightningShield)) then
				return "lightning_shield main 2";
			end
		end
		v31 = v133();
		if (v31 or ((2064 + 943) > (4203 - (615 + 394)))) then
			return v31;
		end
		if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v14:CanAttack(v17)) or ((1929 + 207) >= (2808 + 138))) then
			if (((6599 - 4434) <= (11434 - 8913)) and v25(v100.AncestralSpirit, nil, true)) then
				return "ancestral_spirit";
			end
		end
		if (((3512 - (59 + 592)) > (1463 - 802)) and v100.AncestralSpirit:IsCastable() and v100.AncestralSpirit:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
			if (((8332 - 3807) > (3185 + 1334)) and v25(v102.AncestralSpiritMouseover)) then
				return "ancestral_spirit mouseover";
			end
		end
		v109, v110 = v30();
		if (((3349 - (70 + 101)) > (2402 - 1430)) and v100.ImprovedFlametongueWeapon:IsAvailable() and v100.FlametongueWeapon:IsCastable() and v51 and (not v109 or (v110 < (425479 + 174521))) and v100.FlametongueWeapon:IsAvailable()) then
			if (((11969 - 7203) == (5007 - (123 + 118))) and v25(v100.FlametongueWeapon)) then
				return "flametongue_weapon enchant";
			end
		end
		if ((not v14:AffectingCombat() and v32 and v104.TargetIsValid()) or ((665 + 2080) > (39 + 3089))) then
			v31 = v136();
			if (v31 or ((2543 - (653 + 746)) >= (8614 - 4008))) then
				return v31;
			end
		end
	end
	local function v140()
		local v166 = 0 - 0;
		while true do
			if (((8936 - 5598) >= (123 + 154)) and (v166 == (1 + 0))) then
				if (((2280 + 330) > (314 + 2246)) and v86) then
					local v246 = 0 + 0;
					while true do
						if ((v246 == (2 - 1)) or ((1137 + 57) > (5695 - 2612))) then
							if (((2150 - (885 + 349)) >= (594 + 153)) and v83) then
								v31 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 81 - 51);
								if (v31 or ((7109 - 4665) > (3922 - (915 + 53)))) then
									return v31;
								end
							end
							break;
						end
						if (((3693 - (768 + 33)) < (13454 - 9940)) and (v246 == (0 - 0))) then
							if (((861 - (287 + 41)) == (1380 - (638 + 209))) and v81) then
								local v259 = 0 + 0;
								while true do
									if (((2281 - (96 + 1590)) <= (5085 - (741 + 931))) and (v259 == (0 + 0))) then
										v31 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 113 - 73);
										if (((14379 - 11301) >= (1112 + 1479)) and v31) then
											return v31;
										end
										break;
									end
								end
							end
							if (((1375 + 1824) < (1285 + 2745)) and v82) then
								v31 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 113 - 83);
								if (((253 + 524) < (1015 + 1063)) and v31) then
									return v31;
								end
							end
							v246 = 4 - 3;
						end
					end
				end
				if (((1522 + 174) <= (2776 - (64 + 430))) and v87) then
					v31 = v104.HandleIncorporeal(v100.Hex, v102.HexMouseOver, 30 + 0, true);
					if (v31 or ((2124 - (106 + 257)) >= (1746 + 716))) then
						return v31;
					end
				end
				v166 = 723 - (496 + 225);
			end
			if (((9306 - 4755) > (11340 - 9012)) and (v166 == (1661 - (256 + 1402)))) then
				if (((5724 - (30 + 1869)) >= (1836 - (213 + 1156))) and v100.Purge:IsReady() and v97 and v36 and v84 and not v14:IsCasting() and not v14:IsChanneling() and v104.UnitHasMagicBuff(v17)) then
					if (v25(v100.Purge, not v17:IsSpellInRange(v100.Purge)) or ((3078 - (96 + 92)) == (95 + 462))) then
						return "purge damage";
					end
				end
				if ((v104.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((5669 - (142 + 757)) == (2366 + 538))) then
					local v247 = 0 + 0;
					local v248;
					while true do
						if ((v247 == (80 - (32 + 47))) or ((5880 - (1053 + 924)) == (4443 + 93))) then
							if (((7049 - 2956) <= (6493 - (685 + 963))) and v100.NaturesSwiftness:IsCastable() and v47) then
								if (((3189 - 1620) <= (5687 - 2040)) and v25(v100.NaturesSwiftness)) then
									return "natures_swiftness main 12";
								end
							end
							v248 = v104.HandleDPSPotion(v14:BuffUp(v100.AscendanceBuff));
							v247 = 1711 - (541 + 1168);
						end
						if ((v247 == (1599 - (645 + 952))) or ((4884 - (669 + 169)) >= (17067 - 12140))) then
							if (((10039 - 5416) >= (941 + 1846)) and v248) then
								return v248;
							end
							if (((493 + 1741) >= (1995 - (181 + 584))) and v33 and (v113 > (1397 - (665 + 730))) and (v114 > (5 - 3))) then
								local v260 = 0 - 0;
								while true do
									if ((v260 == (1351 - (540 + 810))) or ((1371 - 1028) == (4910 - 3124))) then
										if (((2046 + 524) > (2612 - (166 + 37))) and v25(v100.Pool)) then
											return "Pool for Aoe()";
										end
										break;
									end
									if ((v260 == (1881 - (22 + 1859))) or ((4381 - (843 + 929)) >= (3496 - (30 + 232)))) then
										v31 = v137();
										if (v31 or ((8662 - 5629) >= (4808 - (55 + 722)))) then
											return v31;
										end
										v260 = 1 - 0;
									end
								end
							end
							v247 = 1678 - (78 + 1597);
						end
						if ((v247 == (1 + 2)) or ((1275 + 126) == (3908 + 760))) then
							if (((3325 - (305 + 244)) >= (1226 + 95)) and true) then
								local v261 = 105 - (95 + 10);
								while true do
									if ((v261 == (0 + 0)) or ((1543 - 1056) > (3150 - 847))) then
										v31 = v138();
										if (v31 or ((5265 - (592 + 170)) == (12074 - 8612))) then
											return v31;
										end
										v261 = 2 - 1;
									end
									if (((258 + 295) <= (601 + 942)) and (v261 == (2 - 1))) then
										if (((327 + 1688) == (3734 - 1719)) and v25(v100.Pool)) then
											return "Pool for SingleTarget()";
										end
										break;
									end
								end
							end
							break;
						end
						if ((v247 == (507 - (353 + 154))) or ((5644 - 1403) <= (3185 - 853))) then
							if (((v91 < v108) and v58 and ((v64 and v34) or not v64)) or ((1632 + 732) < (907 + 250))) then
								if ((v100.BloodFury:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (33 + 17)))) or ((1686 - 519) > (2419 - 1141))) then
									if (v25(v100.BloodFury) or ((2669 - 1524) <= (1168 - (7 + 79)))) then
										return "blood_fury main 2";
									end
								end
								if ((v100.Berserking:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff))) or ((1453 + 1652) == (5062 - (24 + 157)))) then
									if (v25(v100.Berserking) or ((3765 - 1878) > (10405 - 5527))) then
										return "berserking main 4";
									end
								end
								if ((v100.Fireblood:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (15 + 35)))) or ((11009 - 6922) > (4496 - (262 + 118)))) then
									if (((2189 - (1038 + 45)) <= (2737 - 1471)) and v25(v100.Fireblood)) then
										return "fireblood main 6";
									end
								end
								if (((3385 - (19 + 211)) < (4763 - (88 + 25))) and v100.AncestralCall:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (127 - 77)))) then
									if (((1874 + 1900) >= (1717 + 122)) and v25(v100.AncestralCall)) then
										return "ancestral_call main 8";
									end
								end
								if (((3847 - (1007 + 29)) == (758 + 2053)) and v100.BagofTricks:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff))) then
									if (((5245 - 3099) > (5306 - 4184)) and v25(v100.BagofTricks)) then
										return "bag_of_tricks main 10";
									end
								end
							end
							if ((v91 < v108) or ((13 + 43) == (4427 - (340 + 471)))) then
								if ((v57 and ((v34 and v63) or not v63)) or ((6097 - 3676) < (1211 - (276 + 313)))) then
									local v266 = 0 - 0;
									while true do
										if (((931 + 78) <= (480 + 650)) and (v266 == (0 + 0))) then
											v31 = v135();
											if (((4730 - (495 + 1477)) < (8922 - 5942)) and v31) then
												return v31;
											end
											break;
										end
									end
								end
							end
							v247 = 1 + 0;
						end
					end
				end
				break;
			end
			if ((v166 == (403 - (342 + 61))) or ((38 + 48) >= (3791 - (4 + 161)))) then
				v31 = v134();
				if (((1467 + 928) == (7517 - 5122)) and v31) then
					return v31;
				end
				v166 = 2 - 1;
			end
			if (((4277 - (322 + 175)) > (3272 - (173 + 390))) and (v166 == (1 + 1))) then
				if (v18 or ((551 - (203 + 111)) >= (141 + 2132))) then
					if (v85 or ((1439 + 601) <= (2051 - 1348))) then
						local v255 = 0 + 0;
						while true do
							if (((3985 - (57 + 649)) <= (4351 - (328 + 56))) and (v255 == (0 + 0))) then
								v31 = v132();
								if (v31 or ((2500 - (433 + 79)) == (81 + 796))) then
									return v31;
								end
								break;
							end
						end
					end
				end
				if (((3465 + 826) > (6429 - 4517)) and v100.GreaterPurge:IsAvailable() and v97 and v100.GreaterPurge:IsReady() and v36 and v84 and not v14:IsCasting() and not v14:IsChanneling() and v104.UnitHasMagicBuff(v17)) then
					if (((9471 - 7468) < (1706 + 633)) and v25(v100.GreaterPurge, not v17:IsSpellInRange(v100.GreaterPurge))) then
						return "greater_purge damage";
					end
				end
				v166 = 3 + 0;
			end
		end
	end
	local function v141()
		local v167 = 1036 - (562 + 474);
		while true do
			if (((1007 - 575) == (879 - 447)) and (v167 == (905 - (76 + 829)))) then
				v37 = EpicSettings.Settings['useChainlightning'];
				v38 = EpicSettings.Settings['useEarthquake'];
				v39 = EpicSettings.Settings['UseEarthShock'];
				v40 = EpicSettings.Settings['useElementalBlast'];
				v167 = 1674 - (1506 + 167);
			end
			if ((v167 == (9 - 4)) or ((1411 - (58 + 208)) >= (741 + 512))) then
				v62 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
				v60 = EpicSettings.Settings['fireElementalWithCD'];
				v61 = EpicSettings.Settings['stormElementalWithCD'];
				v65 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v167 = 5 + 1;
			end
			if (((1964 + 1454) > (8640 - 6522)) and ((339 - (258 + 79)) == v167)) then
				v45 = EpicSettings.Settings['useLavaBurst'];
				v46 = EpicSettings.Settings['useLightningBolt'];
				v47 = EpicSettings.Settings['useNaturesSwiftness'];
				v48 = EpicSettings.Settings['usePrimordialWave'];
				v167 = 1 + 2;
			end
			if (((6449 - 3383) <= (5360 - (1219 + 251))) and (v167 == (1677 - (1231 + 440)))) then
				v66 = EpicSettings.Settings['stormkeeperWithMiniCD'];
				break;
			end
			if ((v167 == (61 - (34 + 24))) or ((1739 + 1259) >= (6124 - 2843))) then
				v49 = EpicSettings.Settings['useStormkeeper'];
				v50 = EpicSettings.Settings['useTotemicRecall'];
				v51 = EpicSettings.Settings['useWeaponEnchant'];
				v53 = EpicSettings.Settings['useAscendance'];
				v167 = 2 + 2;
			end
			if (((12 - 8) == v167) or ((14903 - 10254) <= (6919 - 4287))) then
				v55 = EpicSettings.Settings['useLiquidMagmaTotem'];
				v54 = EpicSettings.Settings['useFireElemental'];
				v56 = EpicSettings.Settings['useStormElemental'];
				v59 = EpicSettings.Settings['ascendanceWithCD'];
				v167 = 16 - 11;
			end
			if ((v167 == (2 - 1)) or ((5449 - (877 + 712)) > (2918 + 1954))) then
				v41 = EpicSettings.Settings['useFlameShock'];
				v42 = EpicSettings.Settings['useFrostShock'];
				v43 = EpicSettings.Settings['useIceFury'];
				v44 = EpicSettings.Settings['useLavaBeam'];
				v167 = 756 - (242 + 512);
			end
		end
	end
	local function v142()
		v68 = EpicSettings.Settings['useWindShear'];
		v69 = EpicSettings.Settings['useCapacitorTotem'];
		v70 = EpicSettings.Settings['useThunderstorm'];
		v71 = EpicSettings.Settings['useAncestralGuidance'];
		v72 = EpicSettings.Settings['useAstralShift'];
		v73 = EpicSettings.Settings['useHealingStreamTotem'];
		v76 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 - 0);
		v77 = EpicSettings.Settings['ancestralGuidanceGroup'] or (627 - (92 + 535));
		v78 = EpicSettings.Settings['astralShiftHP'] or (0 + 0);
		v79 = EpicSettings.Settings['healingStreamTotemHP'] or (0 - 0);
		v80 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
		v52 = EpicSettings.Settings['earthquakeSetting'] or "";
		v67 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
		v74 = EpicSettings.Settings['autoShield'];
		v75 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
		v98 = EpicSettings.Settings['healOOC'];
		v99 = EpicSettings.Settings['healOOCHP'] or (0 - 0);
		v97 = EpicSettings.Settings['usePurgeTarget'];
		v81 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
		v82 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v83 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
	end
	local function v143()
		v91 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
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
		v95 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v94 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
		v96 = EpicSettings.Settings['HealingPotionName'] or "";
		v86 = EpicSettings.Settings['handleAfflicted'];
		v87 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v144()
		v142();
		v141();
		v143();
		v32 = EpicSettings.Toggles['ooc'];
		v33 = EpicSettings.Toggles['aoe'];
		v34 = EpicSettings.Toggles['cds'];
		v36 = EpicSettings.Toggles['dispel'];
		v35 = EpicSettings.Toggles['minicds'];
		if (v14:IsDeadOrGhost() or ((7966 - 3968) == (3502 - 1204))) then
			return v31;
		end
		v111 = v14:GetEnemiesInRange(1825 - (1476 + 309));
		v112 = v17:GetEnemiesInSplashRange(1289 - (299 + 985));
		if (v33 or ((2 + 6) >= (8978 - 6239))) then
			local v214 = 93 - (86 + 7);
			while true do
				if (((10584 - 7994) == (247 + 2343)) and (v214 == (880 - (672 + 208)))) then
					v113 = #v111;
					v114 = v28(v17:GetEnemiesInSplashRangeCount(3 + 2), v113);
					break;
				end
			end
		else
			v113 = 133 - (14 + 118);
			v114 = 446 - (339 + 106);
		end
		if ((v36 and v85) or ((66 + 16) >= (941 + 929))) then
			local v215 = 1395 - (440 + 955);
			while true do
				if (((2586 + 38) < (8186 - 3629)) and (v215 == (0 + 0))) then
					if ((v14:AffectingCombat() and v100.CleanseSpirit:IsAvailable()) or ((7795 - 4664) > (2426 + 1116))) then
						local v256 = v85 and v100.CleanseSpirit:IsReady() and v36;
						v31 = v104.FocusUnit(v256, v102, 373 - (260 + 93), nil, 24 + 1);
						if (((5894 - 3317) >= (2848 - 1270)) and v31) then
							return v31;
						end
					end
					if (((6077 - (1181 + 793)) <= (1164 + 3407)) and v100.CleanseSpirit:IsAvailable()) then
						if ((v15 and v15:Exists() and v15:IsAPlayer() and v104.UnitHasCurseDebuff(v15)) or ((1802 - (105 + 202)) == (3838 + 949))) then
							if (v100.CleanseSpirit:IsReady() or ((1120 - (352 + 458)) > (17877 - 13443))) then
								if (((5542 - 3374) <= (4221 + 139)) and v25(v102.CleanseSpiritMouseover)) then
									return "cleanse_spirit mouseover";
								end
							end
						end
					end
					break;
				end
			end
		end
		if (((2905 - 1911) == (1943 - (438 + 511))) and (v104.TargetIsValid() or v14:AffectingCombat())) then
			v107 = v10.BossFightRemains();
			v108 = v107;
			if (((3038 - (1262 + 121)) > (1469 - (728 + 340))) and (v108 == (12901 - (816 + 974)))) then
				v108 = v10.FightRemains(v111, false);
			end
		end
		if (((9383 - 6320) <= (12329 - 8903)) and not v14:IsChanneling() and not v14:IsCasting()) then
			if (((1798 - (163 + 176)) > (2174 - 1410)) and v86) then
				if (v81 or ((2945 - 2304) > (1309 + 3025))) then
					v31 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 1850 - (1564 + 246));
					if (((3744 - (124 + 221)) >= (1544 + 716)) and v31) then
						return v31;
					end
				end
				if (v82 or ((844 - (115 + 336)) >= (9342 - 5100))) then
					v31 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 7 + 23);
					if (((1035 - (45 + 1)) < (263 + 4596)) and v31) then
						return v31;
					end
				end
				if (v83 or ((6785 - (1282 + 708)) < (2161 - (583 + 629)))) then
					v31 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 5 + 25);
					if (((9939 - 6097) == (2014 + 1828)) and v31) then
						return v31;
					end
				end
			end
			if (((2917 - (943 + 227)) <= (1575 + 2026)) and v14:AffectingCombat()) then
				local v242 = 1631 - (1539 + 92);
				while true do
					if ((v242 == (1946 - (706 + 1240))) or ((1062 - (81 + 177)) > (12315 - 7956))) then
						v31 = v140();
						if (((4927 - (212 + 45)) >= (12119 - 8496)) and v31) then
							return v31;
						end
						break;
					end
				end
			else
				v31 = v139();
				if (((4011 - (708 + 1238)) < (212 + 2332)) and v31) then
					return v31;
				end
			end
		end
	end
	local function v145()
		local v198 = 0 + 0;
		while true do
			if (((2978 - (586 + 1081)) <= (3870 - (348 + 163))) and (v198 == (0 + 0))) then
				v100.FlameShockDebuff:RegisterAuraTracking();
				v106();
				v198 = 281 - (215 + 65);
			end
			if (((6922 - 4205) <= (5015 - (1541 + 318))) and (v198 == (1 + 0))) then
				v22.Print("Elemental Shaman by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(133 + 129, v144, v145);
end;
return v0["Epix_Shaman_Elemental.lua"]();

