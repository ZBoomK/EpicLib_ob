local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1101 + 3724) < (775 + 4068)) and not v5) then
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
		if (v100.CleanseSpirit:IsAvailable() or ((9734 - 5857) >= (4991 - (233 + 221)))) then
			v104.DispellableDebuffs = v104.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v106();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v9:RegisterForEvent(function()
		local v146 = 0 - 0;
		while true do
			if ((v146 == (1 + 0)) or ((5856 - (718 + 823)) < (1087 + 639))) then
				v100.LavaBurst:RegisterInFlight();
				break;
			end
			if ((v146 == (805 - (266 + 539))) or ((10415 - 6736) < (1850 - (636 + 589)))) then
				v100.PrimordialWave:RegisterInFlightEffect(776605 - 449443);
				v100.PrimordialWave:RegisterInFlight();
				v146 = 1 - 0;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v100.PrimordialWave:RegisterInFlightEffect(259264 + 67898);
	v100.PrimordialWave:RegisterInFlight();
	v100.LavaBurst:RegisterInFlight();
	local v107 = 4037 + 7074;
	local v108 = 12126 - (657 + 358);
	local v109, v110;
	local v111, v112;
	local v113 = 0 - 0;
	local v114 = 0 - 0;
	local v115 = 1187 - (1151 + 36);
	local v116 = 0 + 0;
	local v117 = 0 + 0;
	local function v118()
		return (119 - 79) - (v28() - v115);
	end
	v9:RegisterForSelfCombatEvent(function(...)
		local v147, v148, v148, v148, v149 = select(1840 - (1552 + 280), ...);
		if (((v147 == v13:GUID()) and (v149 == (192468 - (64 + 770)))) or ((3141 + 1484) < (1434 - 802))) then
			v116 = v28();
			C_Timer.After(0.1 + 0, function()
				if ((v116 ~= v117) or ((1326 - (157 + 1086)) > (3562 - 1782))) then
					v115 = v116;
				end
			end);
		end
	end, "SPELL_AURA_APPLIED");
	local function v119(v150)
		return (v150:DebuffRefreshable(v100.FlameShockDebuff));
	end
	local function v120(v151)
		return v151:DebuffRefreshable(v100.FlameShockDebuff) and (v151:DebuffRemains(v100.FlameShockDebuff) < (v151:TimeToDie() - (21 - 16)));
	end
	local function v121(v152)
		return v152:DebuffRefreshable(v100.FlameShockDebuff) and (v152:DebuffRemains(v100.FlameShockDebuff) < (v152:TimeToDie() - (7 - 2))) and (v152:DebuffRemains(v100.FlameShockDebuff) > (0 - 0));
	end
	local function v122(v153)
		return (v153:DebuffRemains(v100.FlameShockDebuff));
	end
	local function v123(v154)
		return v154:DebuffRemains(v100.FlameShockDebuff) > (821 - (599 + 220));
	end
	local function v124(v155)
		return (v155:DebuffRemains(v100.LightningRodDebuff));
	end
	local function v125()
		local v156 = 0 - 0;
		local v157;
		while true do
			if (((2477 - (1813 + 118)) <= (788 + 289)) and (v156 == (1217 - (841 + 376)))) then
				v157 = v13:Maelstrom();
				if (not v13:IsCasting() or ((1394 - 398) > (1000 + 3301))) then
					return v157;
				elseif (((11109 - 7039) > (1546 - (464 + 395))) and v13:IsCasting(v100.ElementalBlast)) then
					return v157 - (192 - 117);
				elseif (v13:IsCasting(v100.Icefury) or ((316 + 340) >= (4167 - (467 + 370)))) then
					return v157 + (51 - 26);
				elseif (v13:IsCasting(v100.LightningBolt) or ((1830 + 662) <= (1148 - 813))) then
					return v157 + 2 + 8;
				elseif (((10055 - 5733) >= (3082 - (150 + 370))) and v13:IsCasting(v100.LavaBurst)) then
					return v157 + (1294 - (74 + 1208));
				elseif (v13:IsCasting(v100.ChainLightning) or ((8945 - 5308) >= (17879 - 14109))) then
					return v157 + ((3 + 1) * v114);
				else
					return v157;
				end
				break;
			end
		end
	end
	local function v126(v158)
		local v159 = 390 - (14 + 376);
		local v160;
		while true do
			if ((v159 == (0 - 0)) or ((1540 + 839) > (4022 + 556))) then
				v160 = v158:IsReady();
				if ((v158 == v100.Stormkeeper) or (v158 == v100.ElementalBlast) or (v158 == v100.Icefury) or ((461 + 22) > (2177 - 1434))) then
					local v249 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or not v13:IsMoving();
					return v160 and v249 and not v13:IsCasting(v158);
				elseif (((1847 + 607) > (656 - (23 + 55))) and (v158 == v100.LavaBeam)) then
					local v256 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or not v13:IsMoving();
					return v160 and v256;
				elseif (((2204 - 1274) < (2975 + 1483)) and ((v158 == v100.LightningBolt) or (v158 == v100.ChainLightning))) then
					local v266 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or v13:BuffUp(v100.StormkeeperBuff) or not v13:IsMoving();
					return v160 and v266;
				elseif (((595 + 67) <= (1506 - 534)) and (v158 == v100.LavaBurst)) then
					local v269 = 0 + 0;
					local v270;
					local v271;
					local v272;
					local v273;
					while true do
						if (((5271 - (652 + 249)) == (11694 - 7324)) and (v269 == (1870 - (708 + 1160)))) then
							return v160 and v270 and (v271 or v272 or v273);
						end
						if ((v269 == (0 - 0)) or ((8681 - 3919) <= (888 - (10 + 17)))) then
							v270 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or v13:BuffUp(v100.LavaSurgeBuff) or not v13:IsMoving();
							v271 = v13:BuffUp(v100.LavaSurgeBuff);
							v269 = 1 + 0;
						end
						if ((v269 == (1733 - (1400 + 332))) or ((2707 - 1295) == (6172 - (242 + 1666)))) then
							v272 = (v100.LavaBurst:Charges() >= (1 + 0)) and not v13:IsCasting(v100.LavaBurst);
							v273 = (v100.LavaBurst:Charges() == (1 + 1)) and v13:IsCasting(v100.LavaBurst);
							v269 = 2 + 0;
						end
					end
				elseif ((v158 == v100.PrimordialWave) or ((4108 - (850 + 90)) < (3770 - 1617))) then
					return v160 and v33 and v13:BuffDown(v100.PrimordialWaveBuff) and v13:BuffDown(v100.LavaSurgeBuff);
				else
					return v160;
				end
				break;
			end
		end
	end
	local function v127()
		local v161 = 1390 - (360 + 1030);
		local v162;
		while true do
			if ((v161 == (1 + 0)) or ((14044 - 9068) < (1832 - 500))) then
				if (((6289 - (909 + 752)) == (5851 - (109 + 1114))) and not v13:IsCasting()) then
					return v162;
				elseif (v13:IsCasting(v105.LavaBurst) or ((98 - 44) == (154 + 241))) then
					return true;
				elseif (((324 - (6 + 236)) == (52 + 30)) and (v13:IsCasting(v105.ElementalBlast) or v13:IsCasting(v100.Icefury) or v13:IsCasting(v100.LightningBolt) or v13:IsCasting(v100.ChainLightning))) then
					return false;
				else
					return v162;
				end
				break;
			end
			if (((0 + 0) == v161) or ((1369 - 788) < (492 - 210))) then
				if (not v100.MasteroftheElements:IsAvailable() or ((5742 - (1076 + 57)) < (411 + 2084))) then
					return false;
				end
				v162 = v13:BuffUp(v100.MasteroftheElementsBuff);
				v161 = 690 - (579 + 110);
			end
		end
	end
	local function v128()
		if (((91 + 1061) == (1019 + 133)) and not v100.PoweroftheMaelstrom:IsAvailable()) then
			return false;
		end
		local v163 = v13:BuffStack(v100.PoweroftheMaelstromBuff);
		if (((1007 + 889) <= (3829 - (174 + 233))) and not v13:IsCasting()) then
			return v163 > (0 - 0);
		elseif (((v163 == (1 - 0)) and (v13:IsCasting(v100.LightningBolt) or v13:IsCasting(v100.ChainLightning))) or ((441 + 549) > (2794 - (663 + 511)))) then
			return false;
		else
			return v163 > (0 + 0);
		end
	end
	local function v129()
		if (not v100.Stormkeeper:IsAvailable() or ((191 + 686) > (14474 - 9779))) then
			return false;
		end
		local v164 = v13:BuffUp(v100.StormkeeperBuff);
		if (((1630 + 1061) >= (4357 - 2506)) and not v13:IsCasting()) then
			return v164;
		elseif (v13:IsCasting(v100.Stormkeeper) or ((7226 - 4241) >= (2318 + 2538))) then
			return true;
		else
			return v164;
		end
	end
	local function v130()
		local v165 = 0 - 0;
		local v166;
		while true do
			if (((3048 + 1228) >= (110 + 1085)) and (v165 == (723 - (478 + 244)))) then
				if (((3749 - (440 + 77)) <= (2133 + 2557)) and not v13:IsCasting()) then
					return v166;
				elseif (v13:IsCasting(v100.Icefury) or ((3279 - 2383) >= (4702 - (655 + 901)))) then
					return true;
				else
					return v166;
				end
				break;
			end
			if (((568 + 2493) >= (2265 + 693)) and (v165 == (0 + 0))) then
				if (((12839 - 9652) >= (2089 - (695 + 750))) and not v100.Icefury:IsAvailable()) then
					return false;
				end
				v166 = v13:BuffUp(v100.IcefuryBuff);
				v165 = 3 - 2;
			end
		end
	end
	local v131 = 0 - 0;
	local function v132()
		if (((2589 - 1945) <= (1055 - (285 + 66))) and v100.CleanseSpirit:IsReady() and v35 and (v104.UnitHasDispellableDebuffByPlayer(v17) or v104.DispellableFriendlyUnit(46 - 26) or v104.UnitHasCurseDebuff(v17))) then
			local v189 = 1310 - (682 + 628);
			while true do
				if (((155 + 803) > (1246 - (176 + 123))) and (v189 == (0 + 0))) then
					if (((3259 + 1233) >= (2923 - (239 + 30))) and (v131 == (0 + 0))) then
						v131 = v28();
					end
					if (((3309 + 133) >= (2659 - 1156)) and v104.Wait(1559 - 1059, v131)) then
						if (v24(v102.CleanseSpiritFocus) or ((3485 - (306 + 9)) <= (5108 - 3644))) then
							return "cleanse_spirit dispel";
						end
						v131 = 0 + 0;
					end
					break;
				end
			end
		end
	end
	local function v133()
		if ((v98 and (v13:HealthPercentage() <= v99)) or ((2944 + 1853) == (2113 + 2275))) then
			if (((1575 - 1024) <= (2056 - (1140 + 235))) and v100.HealingSurge:IsReady()) then
				if (((2086 + 1191) > (374 + 33)) and v24(v100.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v134()
		local v167 = 0 + 0;
		while true do
			if (((4747 - (33 + 19)) >= (511 + 904)) and (v167 == (2 - 1))) then
				if ((v100.HealingStreamTotem:IsReady() and v72 and v104.AreUnitsBelowHealthPercentage(v78, v79, v100.HealingSurge)) or ((1415 + 1797) <= (1851 - 907))) then
					if (v24(v100.HealingStreamTotem) or ((2904 + 192) <= (2487 - (586 + 103)))) then
						return "healing_stream_totem defensive 3";
					end
				end
				if (((323 + 3214) == (10888 - 7351)) and v101.Healthstone:IsReady() and v93 and (v13:HealthPercentage() <= v95)) then
					if (((5325 - (1309 + 179)) >= (2834 - 1264)) and v24(v102.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				v167 = 1 + 1;
			end
			if ((v167 == (5 - 3)) or ((2229 + 721) == (8098 - 4286))) then
				if (((9410 - 4687) >= (2927 - (295 + 314))) and v92 and (v13:HealthPercentage() <= v94)) then
					if ((v96 == "Refreshing Healing Potion") or ((4978 - 2951) > (4814 - (1300 + 662)))) then
						if (v101.RefreshingHealingPotion:IsReady() or ((3566 - 2430) > (6072 - (1178 + 577)))) then
							if (((2466 + 2282) == (14036 - 9288)) and v24(v102.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((5141 - (851 + 554)) <= (4192 + 548)) and (v96 == "Dreamwalker's Healing Potion")) then
						if (v101.DreamwalkersHealingPotion:IsReady() or ((9401 - 6011) <= (6645 - 3585))) then
							if (v24(v102.RefreshingHealingPotion) or ((1301 - (115 + 187)) > (2063 + 630))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((439 + 24) < (2368 - 1767)) and (v167 == (1161 - (160 + 1001)))) then
				if ((v100.AstralShift:IsReady() and v71 and (v13:HealthPercentage() <= v77)) or ((1910 + 273) < (475 + 212))) then
					if (((9311 - 4762) == (4907 - (237 + 121))) and v24(v100.AstralShift)) then
						return "astral_shift defensive 1";
					end
				end
				if (((5569 - (525 + 372)) == (8857 - 4185)) and v100.AncestralGuidance:IsReady() and v70 and v104.AreUnitsBelowHealthPercentage(v75, v76, v100.HealingSurge)) then
					if (v24(v100.AncestralGuidance) or ((12051 - 8383) < (537 - (96 + 46)))) then
						return "ancestral_guidance defensive 2";
					end
				end
				v167 = 778 - (643 + 134);
			end
		end
	end
	local function v135()
		v30 = v104.HandleTopTrinket(v103, v33, 15 + 25, nil);
		if (v30 or ((9988 - 5822) == (1689 - 1234))) then
			return v30;
		end
		v30 = v104.HandleBottomTrinket(v103, v33, 39 + 1, nil);
		if (v30 or ((8730 - 4281) == (5443 - 2780))) then
			return v30;
		end
	end
	local function v136()
		local v168 = 719 - (316 + 403);
		while true do
			if ((v168 == (2 + 0)) or ((11759 - 7482) < (1081 + 1908))) then
				if ((v13:IsCasting(v100.ElementalBlast) and v40 and not v100.PrimordialWave:IsAvailable() and v100.FlameShock:IsCastable()) or ((2190 - 1320) >= (2941 + 1208))) then
					if (((713 + 1499) < (11028 - 7845)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
						return "flameshock precombat 10";
					end
				end
				if (((22188 - 17542) > (6215 - 3223)) and v126(v100.LavaBurst) and v44 and not v13:IsCasting(v100.LavaBurst) and (not v100.ElementalBlast:IsAvailable() or (v100.ElementalBlast:IsAvailable() and not v126(v100.ElementalBlast)))) then
					if (((83 + 1351) < (6114 - 3008)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lavaburst precombat 12";
					end
				end
				v168 = 1 + 2;
			end
			if (((2312 - 1526) < (3040 - (12 + 5))) and (v168 == (3 - 2))) then
				if ((v126(v100.ElementalBlast) and v39) or ((5209 - 2767) < (156 - 82))) then
					if (((11246 - 6711) == (921 + 3614)) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast precombat 6";
					end
				end
				if ((v13:IsCasting(v100.ElementalBlast) and v47 and ((v64 and v34) or not v64) and v126(v100.PrimordialWave)) or ((4982 - (1656 + 317)) <= (1876 + 229))) then
					if (((1467 + 363) < (9755 - 6086)) and v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave precombat 8";
					end
				end
				v168 = 9 - 7;
			end
			if ((v168 == (354 - (5 + 349))) or ((6792 - 5362) >= (4883 - (266 + 1005)))) then
				if (((1769 + 914) >= (8393 - 5933)) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 - 0)) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108)) then
					if (v24(v100.Stormkeeper) or ((3500 - (561 + 1135)) >= (4267 - 992))) then
						return "stormkeeper precombat 2";
					end
				end
				if ((v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 - 0)) and v42) or ((2483 - (507 + 559)) > (9106 - 5477))) then
					if (((14829 - 10034) > (790 - (212 + 176))) and v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury))) then
						return "icefury precombat 4";
					end
				end
				v168 = 906 - (250 + 655);
			end
			if (((13124 - 8311) > (6229 - 2664)) and (v168 == (4 - 1))) then
				if (((5868 - (1869 + 87)) == (13568 - 9656)) and v13:IsCasting(v100.LavaBurst) and v40 and v100.FlameShock:IsReady()) then
					if (((4722 - (484 + 1417)) <= (10339 - 5515)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
						return "flameshock precombat 14";
					end
				end
				if (((2912 - 1174) <= (2968 - (48 + 725))) and v13:IsCasting(v100.LavaBurst) and v47 and ((v64 and v34) or not v64) and v126(v100.PrimordialWave)) then
					if (((66 - 25) <= (8096 - 5078)) and v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave precombat 16";
					end
				end
				break;
			end
		end
	end
	local function v137()
		if (((1247 + 898) <= (10967 - 6863)) and v100.FireElemental:IsReady() and v53 and ((v59 and v33) or not v59) and (v90 < v108)) then
			if (((753 + 1936) < (1412 + 3433)) and v24(v100.FireElemental)) then
				return "fire_elemental aoe 2";
			end
		end
		if ((v100.StormElemental:IsReady() and v55 and ((v60 and v33) or not v60) and (v90 < v108)) or ((3175 - (152 + 701)) > (3933 - (430 + 881)))) then
			if (v24(v100.StormElemental) or ((1737 + 2797) == (2977 - (557 + 338)))) then
				return "storm_elemental aoe 4";
			end
		end
		if ((v126(v100.Stormkeeper) and not v129() and v48 and ((v65 and v34) or not v65) and (v90 < v108)) or ((465 + 1106) > (5261 - 3394))) then
			if (v24(v100.Stormkeeper) or ((9293 - 6639) >= (7959 - 4963))) then
				return "stormkeeper aoe 7";
			end
		end
		if (((8573 - 4595) > (2905 - (499 + 302))) and v100.TotemicRecall:IsCastable() and (v100.LiquidMagmaTotem:CooldownRemains() > (911 - (39 + 827))) and v49) then
			if (((8267 - 5272) > (3441 - 1900)) and v24(v100.TotemicRecall)) then
				return "totemic_recall aoe 8";
			end
		end
		if (((12904 - 9655) > (1462 - 509)) and v100.LiquidMagmaTotem:IsReady() and v54 and ((v61 and v33) or not v61) and (v90 < v108) and (v66 == "cursor")) then
			if (v24(v102.LiquidMagmaTotemCursor, not v16:IsInRange(4 + 36)) or ((9579 - 6306) > (732 + 3841))) then
				return "liquid_magma_totem aoe cursor 10";
			end
		end
		if ((v100.LiquidMagmaTotem:IsReady() and v54 and ((v61 and v33) or not v61) and (v90 < v108) and (v66 == "player")) or ((4985 - 1834) < (1388 - (103 + 1)))) then
			if (v24(v102.LiquidMagmaTotemPlayer, not v16:IsInRange(594 - (475 + 79))) or ((3999 - 2149) == (4892 - 3363))) then
				return "liquid_magma_totem aoe player 11";
			end
		end
		if (((107 + 714) < (1869 + 254)) and v126(v100.PrimordialWave) and v13:BuffDown(v100.PrimordialWaveBuff) and v13:BuffUp(v100.SurgeofPowerBuff) and v13:BuffDown(v100.SplinteredElementsBuff)) then
			local v190 = 1503 - (1395 + 108);
			while true do
				if (((2624 - 1722) < (3529 - (7 + 1197))) and (v190 == (0 + 0))) then
					if (((300 + 558) <= (3281 - (27 + 292))) and v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v16:IsSpellInRange(v100.PrimordialWave), nil, nil)) then
						return "primordial_wave aoe 12";
					end
					if (v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave)) or ((11562 - 7616) < (1641 - 353))) then
						return "primordial_wave aoe 12";
					end
					break;
				end
			end
		end
		if ((v126(v100.PrimordialWave) and v13:BuffDown(v100.PrimordialWaveBuff) and v100.DeeplyRootedElements:IsAvailable() and not v100.SurgeofPower:IsAvailable() and v13:BuffDown(v100.SplinteredElementsBuff)) or ((13596 - 10354) == (1118 - 551))) then
			if (v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v16:IsSpellInRange(v100.PrimordialWave), nil, nil) or ((1612 - 765) >= (1402 - (43 + 96)))) then
				return "primordial_wave aoe 14";
			end
			if (v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave)) or ((9190 - 6937) == (4184 - 2333))) then
				return "primordial_wave aoe 14";
			end
		end
		if ((v126(v100.PrimordialWave) and v13:BuffDown(v100.PrimordialWaveBuff) and v100.MasteroftheElements:IsAvailable() and not v100.LightningRod:IsAvailable()) or ((1732 + 355) > (670 + 1702))) then
			local v191 = 0 - 0;
			while true do
				if ((v191 == (0 + 0)) or ((8330 - 3885) < (1307 + 2842))) then
					if (v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v16:IsSpellInRange(v100.PrimordialWave), nil, nil) or ((134 + 1684) == (1836 - (1414 + 337)))) then
						return "primordial_wave aoe 16";
					end
					if (((2570 - (1642 + 298)) < (5544 - 3417)) and v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave aoe 16";
					end
					break;
				end
			end
		end
		if (v100.FlameShock:IsCastable() or ((5575 - 3637) == (7460 - 4946))) then
			local v192 = 0 + 0;
			while true do
				if (((3311 + 944) >= (1027 - (357 + 615))) and (v192 == (2 + 0))) then
					if (((7358 - 4359) > (991 + 165)) and v13:BuffUp(v100.SurgeofPowerBuff) and v40 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable())) then
						if (((5036 - 2686) > (924 + 231)) and v104.CastCycle(v100.FlameShock, v112, v121, not v16:IsSpellInRange(v100.FlameShock))) then
							return "flame_shock aoe 26";
						end
						if (((274 + 3755) <= (3051 + 1802)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
							return "flame_shock aoe 26";
						end
					end
					if ((v100.MasteroftheElements:IsAvailable() and v40 and not v100.LightningRod:IsAvailable() and not v100.SurgeofPower:IsAvailable()) or ((1817 - (384 + 917)) > (4131 - (128 + 569)))) then
						if (((5589 - (1407 + 136)) >= (4920 - (687 + 1200))) and v104.CastCycle(v100.FlameShock, v112, v121, not v16:IsSpellInRange(v100.FlameShock))) then
							return "flame_shock aoe 28";
						end
						if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((4429 - (556 + 1154)) <= (5090 - 3643))) then
							return "flame_shock aoe 28";
						end
					end
					v192 = 98 - (9 + 86);
				end
				if ((v192 == (421 - (275 + 146))) or ((673 + 3461) < (3990 - (29 + 35)))) then
					if ((v13:BuffUp(v100.SurgeofPowerBuff) and v40 and v100.LightningRod:IsAvailable() and v100.WindspeakersLavaResurgence:IsAvailable() and (v16:DebuffRemains(v100.FlameShockDebuff) < (v16:TimeToDie() - (70 - 54))) and (v111 < (14 - 9))) or ((723 - 559) >= (1814 + 971))) then
						local v257 = 1012 - (53 + 959);
						while true do
							if ((v257 == (408 - (312 + 96))) or ((911 - 386) == (2394 - (147 + 138)))) then
								if (((932 - (813 + 86)) == (30 + 3)) and v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 18";
								end
								if (((5658 - 2604) <= (4507 - (18 + 474))) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 18";
								end
								break;
							end
						end
					end
					if (((632 + 1239) < (11038 - 7656)) and v13:BuffUp(v100.SurgeofPowerBuff) and v40 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable()) and (v100.FlameShockDebuff:AuraActiveCount() < (1092 - (860 + 226)))) then
						local v258 = 303 - (121 + 182);
						while true do
							if (((160 + 1133) <= (3406 - (988 + 252))) and (v258 == (0 + 0))) then
								if (v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock)) or ((808 + 1771) < (2093 - (49 + 1921)))) then
									return "flame_shock aoe 20";
								end
								if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((1736 - (223 + 667)) >= (2420 - (51 + 1)))) then
									return "flame_shock aoe 20";
								end
								break;
							end
						end
					end
					v192 = 1 - 0;
				end
				if ((v192 == (6 - 3)) or ((5137 - (146 + 979)) <= (948 + 2410))) then
					if (((2099 - (311 + 294)) <= (8379 - 5374)) and v100.DeeplyRootedElements:IsAvailable() and v40 and not v100.SurgeofPower:IsAvailable()) then
						local v259 = 0 + 0;
						while true do
							if ((v259 == (1443 - (496 + 947))) or ((4469 - (1233 + 125)) == (866 + 1268))) then
								if (((2113 + 242) == (448 + 1907)) and v104.CastCycle(v100.FlameShock, v112, v121, not v16:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 30";
								end
								if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((2233 - (963 + 682)) <= (361 + 71))) then
									return "flame_shock aoe 30";
								end
								break;
							end
						end
					end
					break;
				end
				if (((6301 - (504 + 1000)) >= (2624 + 1271)) and (v192 == (1 + 0))) then
					if (((338 + 3239) == (5273 - 1696)) and v100.MasteroftheElements:IsAvailable() and v40 and not v100.LightningRod:IsAvailable() and not v100.SurgeofPower:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (6 + 0))) then
						if (((2207 + 1587) > (3875 - (156 + 26))) and v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock))) then
							return "flame_shock aoe 22";
						end
						if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((735 + 540) == (6414 - 2314))) then
							return "flame_shock aoe 22";
						end
					end
					if ((v100.DeeplyRootedElements:IsAvailable() and v40 and not v100.SurgeofPower:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (170 - (149 + 15)))) or ((2551 - (890 + 70)) >= (3697 - (39 + 78)))) then
						local v260 = 482 - (14 + 468);
						while true do
							if (((2161 - 1178) <= (5053 - 3245)) and (v260 == (0 + 0))) then
								if (v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock)) or ((1292 + 858) <= (255 + 942))) then
									return "flame_shock aoe 24";
								end
								if (((1703 + 2066) >= (308 + 865)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 24";
								end
								break;
							end
						end
					end
					v192 = 3 - 1;
				end
			end
		end
		if (((1468 + 17) == (5218 - 3733)) and v100.Ascendance:IsCastable() and v52 and ((v58 and v33) or not v58) and (v90 < v108)) then
			if (v24(v100.Ascendance) or ((84 + 3231) <= (2833 - (12 + 39)))) then
				return "ascendance aoe 32";
			end
		end
		if ((v126(v100.LavaBurst) and (v114 == (3 + 0)) and not v100.LightningRod:IsAvailable() and v13:HasTier(95 - 64, 14 - 10)) or ((260 + 616) >= (1561 + 1403))) then
			if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((5659 - 3427) > (1664 + 833))) then
				return "lava_burst aoe 34";
			end
			if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((10197 - 8087) <= (2042 - (1596 + 114)))) then
				return "lava_burst aoe 34";
			end
		end
		if (((9623 - 5937) > (3885 - (164 + 549))) and v37 and v100.Earthquake:IsReady() and v127() and (((v13:BuffStack(v100.MagmaChamberBuff) > (1453 - (1059 + 379))) and (v114 >= ((8 - 1) - v25(v100.UnrelentingCalamity:IsAvailable())))) or (v100.SplinteredElements:IsAvailable() and (v114 >= ((6 + 4) - v25(v100.UnrelentingCalamity:IsAvailable())))) or (v100.MountainsWillFall:IsAvailable() and (v114 >= (2 + 7)))) and not v100.LightningRod:IsAvailable() and v13:HasTier(423 - (145 + 247), 4 + 0)) then
			if ((v51 == "cursor") or ((2068 + 2406) < (2431 - 1611))) then
				if (((821 + 3458) >= (2483 + 399)) and v24(v102.EarthquakeCursor, not v16:IsInRange(64 - 24))) then
					return "earthquake aoe 36";
				end
			end
			if ((v51 == "player") or ((2749 - (254 + 466)) >= (4081 - (544 + 16)))) then
				if (v24(v102.EarthquakePlayer, not v16:IsInRange(127 - 87)) or ((2665 - (294 + 334)) >= (4895 - (236 + 17)))) then
					return "earthquake aoe 36";
				end
			end
		end
		if (((742 + 978) < (3471 + 987)) and v126(v100.LavaBeam) and v43 and v129() and ((v13:BuffUp(v100.SurgeofPowerBuff) and (v114 >= (22 - 16))) or (v127() and ((v114 < (28 - 22)) or not v100.SurgeofPower:IsAvailable()))) and not v100.LightningRod:IsAvailable() and v13:HasTier(16 + 15, 4 + 0)) then
			if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((1230 - (413 + 381)) > (128 + 2893))) then
				return "lava_beam aoe 38";
			end
		end
		if (((1515 - 802) <= (2199 - 1352)) and v126(v100.ChainLightning) and v36 and v129() and ((v13:BuffUp(v100.SurgeofPowerBuff) and (v114 >= (1976 - (582 + 1388)))) or (v127() and ((v114 < (9 - 3)) or not v100.SurgeofPower:IsAvailable()))) and not v100.LightningRod:IsAvailable() and v13:HasTier(23 + 8, 368 - (326 + 38))) then
			if (((6371 - 4217) <= (5754 - 1723)) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning aoe 40";
			end
		end
		if (((5235 - (47 + 573)) == (1627 + 2988)) and v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and not v100.LightningRod:IsAvailable() and v13:HasTier(131 - 100, 5 - 1)) then
			if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((5454 - (1269 + 395)) == (992 - (76 + 416)))) then
				return "lava_burst aoe 42";
			end
			if (((532 - (319 + 124)) < (505 - 284)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst aoe 42";
			end
		end
		if (((3061 - (564 + 443)) >= (3933 - 2512)) and v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and v100.MasteroftheElements:IsAvailable() and not v127() and (v125() >= (((518 - (337 + 121)) - ((14 - 9) * v100.EyeoftheStorm:TalentRank())) - ((6 - 4) * v25(v100.FlowofPower:IsAvailable())))) and ((not v100.EchoesofGreatSundering:IsAvailable() and not v100.LightningRod:IsAvailable()) or v13:BuffUp(v100.EchoesofGreatSunderingBuff)) and ((not v13:BuffUp(v100.AscendanceBuff) and (v114 > (1914 - (1261 + 650))) and v100.UnrelentingCalamity:IsAvailable()) or ((v114 > (2 + 1)) and not v100.UnrelentingCalamity:IsAvailable()) or (v114 == (3 - 0)))) then
			local v193 = 1817 - (772 + 1045);
			while true do
				if (((98 + 594) < (3202 - (102 + 42))) and (v193 == (1844 - (1524 + 320)))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((4524 - (1049 + 221)) == (1811 - (18 + 138)))) then
						return "lava_burst aoe 44";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((3172 - 1876) == (6012 - (67 + 1035)))) then
						return "lava_burst aoe 44";
					end
					break;
				end
			end
		end
		if (((3716 - (136 + 212)) == (14311 - 10943)) and v37 and v100.Earthquake:IsReady() and not v100.EchoesofGreatSundering:IsAvailable() and (v114 > (3 + 0)) and ((v114 > (3 + 0)) or (v113 > (1607 - (240 + 1364))))) then
			if (((3725 - (1050 + 32)) < (13621 - 9806)) and (v51 == "cursor")) then
				if (((1132 + 781) > (1548 - (331 + 724))) and v24(v102.EarthquakeCursor, not v16:IsInRange(4 + 36))) then
					return "earthquake aoe 46";
				end
			end
			if (((5399 - (269 + 375)) > (4153 - (267 + 458))) and (v51 == "player")) then
				if (((430 + 951) <= (4555 - 2186)) and v24(v102.EarthquakePlayer, not v16:IsInRange(858 - (667 + 151)))) then
					return "earthquake aoe 46";
				end
			end
		end
		if ((v37 and v100.Earthquake:IsReady() and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (v114 == (1500 - (1410 + 87))) and ((v114 == (1900 - (1504 + 393))) or (v113 == (8 - 5)))) or ((12564 - 7721) == (4880 - (461 + 335)))) then
			if (((597 + 4072) > (2124 - (1730 + 31))) and (v51 == "cursor")) then
				if (v24(v102.EarthquakeCursor, not v16:IsInRange(1707 - (728 + 939))) or ((6647 - 4770) >= (6364 - 3226))) then
					return "earthquake aoe 48";
				end
			end
			if (((10864 - 6122) >= (4694 - (138 + 930))) and (v51 == "player")) then
				if (v24(v102.EarthquakePlayer, not v16:IsInRange(37 + 3)) or ((3550 + 990) == (786 + 130))) then
					return "earthquake aoe 48";
				end
			end
		end
		if ((v37 and v100.Earthquake:IsReady() and (v13:BuffUp(v100.EchoesofGreatSunderingBuff))) or ((4720 - 3564) > (6111 - (459 + 1307)))) then
			if (((4107 - (474 + 1396)) < (7419 - 3170)) and (v51 == "cursor")) then
				if (v24(v102.EarthquakeCursor, not v16:IsInRange(38 + 2)) or ((9 + 2674) < (65 - 42))) then
					return "earthquake aoe 50";
				end
			end
			if (((89 + 608) <= (2757 - 1931)) and (v51 == "player")) then
				if (((4818 - 3713) <= (1767 - (562 + 29))) and v24(v102.EarthquakePlayer, not v16:IsInRange(35 + 5))) then
					return "earthquake aoe 50";
				end
			end
		end
		if (((4798 - (374 + 1045)) <= (3018 + 794)) and v126(v100.ElementalBlast) and v39 and v100.EchoesofGreatSundering:IsAvailable()) then
			if (v104.CastTargetIf(v100.ElementalBlast, v112, "min", v124, nil, not v16:IsSpellInRange(v100.ElementalBlast), nil, nil) or ((2446 - 1658) >= (2254 - (448 + 190)))) then
				return "elemental_blast aoe 52";
			end
			if (((599 + 1255) <= (1526 + 1853)) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast aoe 52";
			end
		end
		if (((2964 + 1585) == (17489 - 12940)) and v126(v100.ElementalBlast) and v39 and v100.EchoesofGreatSundering:IsAvailable()) then
			if (v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast)) or ((9389 - 6367) >= (4518 - (1307 + 187)))) then
				return "elemental_blast aoe 54";
			end
		end
		if (((19113 - 14293) > (5146 - 2948)) and v126(v100.ElementalBlast) and v39 and (v114 == (8 - 5)) and not v100.EchoesofGreatSundering:IsAvailable()) then
			if (v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast)) or ((1744 - (232 + 451)) >= (4671 + 220))) then
				return "elemental_blast aoe 56";
			end
		end
		if (((1205 + 159) <= (5037 - (510 + 54))) and v100.EarthShock:IsCastable() and v38 and v100.EchoesofGreatSundering:IsAvailable()) then
			if (v104.CastTargetIf(v100.EarthShock, v112, "min", v124, nil, not v16:IsSpellInRange(v100.EarthShock), nil, nil) or ((7243 - 3648) <= (39 - (13 + 23)))) then
				return "earth_shock aoe 58";
			end
			if (v24(v100.EarthShock, not v16:IsSpellInRange(v100.EarthShock)) or ((9106 - 4434) == (5534 - 1682))) then
				return "earth_shock aoe 58";
			end
		end
		if (((2831 - 1272) == (2647 - (830 + 258))) and v100.EarthShock:IsCastable() and v38 and v100.EchoesofGreatSundering:IsAvailable()) then
			if (v24(v100.EarthShock, not v16:IsSpellInRange(v100.EarthShock)) or ((6180 - 4428) <= (494 + 294))) then
				return "earth_shock aoe 60";
			end
		end
		if ((v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 + 0)) and v42 and not v13:BuffUp(v100.AscendanceBuff) and v100.ElectrifiedShocks:IsAvailable() and ((v100.LightningRod:IsAvailable() and (v114 < (1446 - (860 + 581))) and not v127()) or (v100.DeeplyRootedElements:IsAvailable() and (v114 == (10 - 7))))) or ((3101 + 806) == (418 - (237 + 4)))) then
			if (((8155 - 4685) > (1403 - 848)) and v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury))) then
				return "icefury aoe 62";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and not v13:BuffUp(v100.AscendanceBuff) and v13:BuffUp(v100.IcefuryBuff) and v100.ElectrifiedShocks:IsAvailable() and (not v16:DebuffUp(v100.ElectrifiedShocksDebuff) or (v13:BuffRemains(v100.IcefuryBuff) < v13:GCD())) and ((v100.LightningRod:IsAvailable() and (v114 < (9 - 4)) and not v127()) or (v100.DeeplyRootedElements:IsAvailable() and (v114 == (3 + 0))))) or ((559 + 413) == (2435 - 1790))) then
			if (((1366 + 1816) >= (1151 + 964)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock aoe 64";
			end
		end
		if (((5319 - (85 + 1341)) < (7556 - 3127)) and v126(v100.LavaBurst) and v100.MasteroftheElements:IsAvailable() and not v127() and (v129() or ((v118() < (8 - 5)) and v13:HasTier(402 - (45 + 327), 3 - 1))) and (v125() < ((((562 - (444 + 58)) - ((3 + 2) * v100.EyeoftheStorm:TalentRank())) - ((1 + 1) * v25(v100.FlowofPower:IsAvailable()))) - (5 + 5))) and (v114 < (14 - 9))) then
			local v194 = 1732 - (64 + 1668);
			while true do
				if (((1973 - (1227 + 746)) == v194) or ((8812 - 5945) < (3535 - 1630))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((2290 - (415 + 79)) >= (105 + 3946))) then
						return "lava_burst aoe 66";
					end
					if (((2110 - (142 + 349)) <= (1610 + 2146)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 66";
					end
					break;
				end
			end
		end
		if (((830 - 226) == (301 + 303)) and v126(v100.LavaBeam) and v43 and (v129())) then
			if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((3160 + 1324) == (2451 - 1551))) then
				return "lava_beam aoe 68";
			end
		end
		if ((v126(v100.ChainLightning) and v36 and (v129())) or ((6323 - (1710 + 154)) <= (1431 - (200 + 118)))) then
			if (((1440 + 2192) > (5941 - 2543)) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning aoe 70";
			end
		end
		if (((6053 - 1971) <= (4369 + 548)) and v126(v100.LavaBeam) and v43 and v128() and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) then
			if (((4780 + 52) >= (744 + 642)) and v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam aoe 72";
			end
		end
		if (((22 + 115) == (296 - 159)) and v126(v100.ChainLightning) and v36 and v128()) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((2820 - (363 + 887)) >= (7563 - 3231))) then
				return "chain_lightning aoe 74";
			end
		end
		if ((v126(v100.LavaBeam) and v43 and (v114 >= (28 - 22)) and v13:BuffUp(v100.SurgeofPowerBuff) and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((628 + 3436) <= (4255 - 2436))) then
			if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((3407 + 1579) < (3238 - (674 + 990)))) then
				return "lava_beam aoe 76";
			end
		end
		if (((1269 + 3157) > (71 + 101)) and v126(v100.ChainLightning) and v36 and (v114 >= (8 - 2)) and v13:BuffUp(v100.SurgeofPowerBuff)) then
			if (((1641 - (507 + 548)) > (1292 - (289 + 548))) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning aoe 78";
			end
		end
		if (((2644 - (821 + 997)) == (1081 - (195 + 60))) and v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable() and v13:BuffUp(v100.WindspeakersLavaResurgenceBuff)) then
			if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((1081 + 2938) > (5942 - (251 + 1250)))) then
				return "lava_burst aoe 80";
			end
			if (((5908 - 3891) < (2928 + 1333)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst aoe 80";
			end
		end
		if (((5748 - (809 + 223)) > (116 - 36)) and v126(v100.LavaBeam) and v43 and v127() and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) then
			if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((10531 - 7024) == (10818 - 7546))) then
				return "lava_beam aoe 82";
			end
		end
		if ((v126(v100.LavaBurst) and (v114 == (3 + 0)) and v100.MasteroftheElements:IsAvailable()) or ((459 + 417) >= (3692 - (14 + 603)))) then
			if (((4481 - (118 + 11)) > (414 + 2140)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst aoe 84";
			end
			if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((3670 + 736) < (11782 - 7739))) then
				return "lava_burst aoe 84";
			end
		end
		if ((v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable()) or ((2838 - (551 + 398)) >= (2138 + 1245))) then
			local v195 = 0 + 0;
			while true do
				if (((1538 + 354) <= (10167 - 7433)) and (v195 == (0 - 0))) then
					if (((624 + 1299) < (8805 - 6587)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 86";
					end
					if (((600 + 1573) > (468 - (40 + 49))) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 86";
					end
					break;
				end
			end
		end
		if ((v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 - 0)) and v42 and v100.ElectrifiedShocks:IsAvailable() and (v114 < (495 - (99 + 391)))) or ((2144 + 447) == (14985 - 11576))) then
			if (((11178 - 6664) > (3238 + 86)) and v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury))) then
				return "icefury aoe 88";
			end
		end
		if ((v126(v100.FrostShock) and v41 and v13:BuffUp(v100.IcefuryBuff) and v100.ElectrifiedShocks:IsAvailable() and not v16:DebuffUp(v100.ElectrifiedShocksDebuff) and (v114 < (13 - 8)) and v100.UnrelentingCalamity:IsAvailable()) or ((1812 - (1032 + 572)) >= (5245 - (203 + 214)))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((3400 - (568 + 1249)) > (2791 + 776))) then
				return "frost_shock aoe 90";
			end
		end
		if ((v126(v100.LavaBeam) and v43 and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((3153 - 1840) == (3066 - 2272))) then
			if (((4480 - (913 + 393)) > (8195 - 5293)) and v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam aoe 92";
			end
		end
		if (((5821 - 1701) <= (4670 - (269 + 141))) and v126(v100.ChainLightning) and v36) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((1963 - 1080) > (6759 - (362 + 1619)))) then
				return "chain_lightning aoe 94";
			end
		end
		if ((v100.FlameShock:IsCastable() and v40 and v13:IsMoving() and v16:DebuffRefreshable(v100.FlameShockDebuff)) or ((5245 - (950 + 675)) >= (1886 + 3005))) then
			if (((5437 - (216 + 963)) > (2224 - (485 + 802))) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock aoe 96";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v13:IsMoving()) or ((5428 - (432 + 127)) < (1979 - (1065 + 8)))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((681 + 544) > (5829 - (635 + 966)))) then
				return "frost_shock aoe 98";
			end
		end
	end
	local function v138()
		if (((2393 + 935) > (2280 - (5 + 37))) and v100.FireElemental:IsCastable() and v53 and ((v59 and v33) or not v59) and (v90 < v108)) then
			if (((9547 - 5708) > (585 + 820)) and v24(v100.FireElemental)) then
				return "fire_elemental single_target 2";
			end
		end
		if ((v100.StormElemental:IsCastable() and v55 and ((v60 and v33) or not v60) and (v90 < v108)) or ((2046 - 753) <= (238 + 269))) then
			if (v24(v100.StormElemental) or ((6017 - 3121) < (3051 - 2246))) then
				return "storm_elemental single_target 4";
			end
		end
		if (((4367 - 2051) == (5537 - 3221)) and v100.TotemicRecall:IsCastable() and v49 and (v100.LiquidMagmaTotem:CooldownRemains() > (33 + 12)) and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or ((v113 > (530 - (318 + 211))) and (v114 > (4 - 3))))) then
			if (v24(v100.TotemicRecall) or ((4157 - (963 + 624)) == (656 + 877))) then
				return "totemic_recall single_target 6";
			end
		end
		if ((v100.LiquidMagmaTotem:IsCastable() and v54 and ((v61 and v33) or not v61) and (v90 < v108) and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or (v100.FlameShockDebuff:AuraActiveCount() == (846 - (518 + 328))) or (v16:DebuffRemains(v100.FlameShockDebuff) < (13 - 7)) or ((v113 > (1 - 0)) and (v114 > (318 - (301 + 16)))))) or ((2587 - 1704) == (4100 - 2640))) then
			local v196 = 0 - 0;
			while true do
				if ((v196 == (0 + 0)) or ((2623 + 1996) <= (2132 - 1133))) then
					if ((v66 == "cursor") or ((2052 + 1358) > (392 + 3724))) then
						if (v24(v102.LiquidMagmaTotemCursor, not v16:IsInRange(127 - 87)) or ((292 + 611) >= (4078 - (829 + 190)))) then
							return "liquid_magma_totem single_target cursor 8";
						end
					end
					if ((v66 == "player") or ((14185 - 10209) < (3614 - 757))) then
						if (((6815 - 1885) > (5730 - 3423)) and v24(v102.LiquidMagmaTotemPlayer, not v16:IsInRange(10 + 30))) then
							return "liquid_magma_totem single_target player 8";
						end
					end
					break;
				end
			end
		end
		if ((v126(v100.PrimordialWave) and v100.PrimordialWave:IsCastable() and v47 and ((v64 and v34) or not v64) and not v13:BuffUp(v100.PrimordialWaveBuff) and not v13:BuffUp(v100.SplinteredElementsBuff)) or ((1322 + 2724) < (3918 - 2627))) then
			local v197 = 0 + 0;
			while true do
				if ((v197 == (613 - (520 + 93))) or ((4517 - (259 + 17)) == (205 + 3340))) then
					if (v104.CastCycle(v100.PrimordialWave, v112, v122, not v16:IsSpellInRange(v100.PrimordialWave)) or ((1457 + 2591) > (14327 - 10095))) then
						return "primordial_wave single_target 10";
					end
					if (v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave)) or ((2341 - (396 + 195)) >= (10076 - 6603))) then
						return "primordial_wave single_target 10";
					end
					break;
				end
			end
		end
		if (((4927 - (440 + 1321)) == (4995 - (1059 + 770))) and v100.FlameShock:IsCastable() and v40 and (v113 == (4 - 3)) and v16:DebuffRefreshable(v100.FlameShockDebuff) and ((v16:DebuffRemains(v100.FlameShockDebuff) < v100.PrimordialWave:CooldownRemains()) or not v100.PrimordialWave:IsAvailable()) and v13:BuffDown(v100.SurgeofPowerBuff) and (not v127() or (not v129() and ((v100.ElementalBlast:IsAvailable() and (v125() < ((635 - (424 + 121)) - ((2 + 6) * v100.EyeoftheStorm:TalentRank())))) or (v125() < ((1407 - (641 + 706)) - ((2 + 3) * v100.EyeoftheStorm:TalentRank()))))))) then
			if (((2203 - (249 + 191)) < (16222 - 12498)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 12";
			end
		end
		if (((26 + 31) <= (10494 - 7771)) and v100.FlameShock:IsCastable() and v40 and (v100.FlameShockDebuff:AuraActiveCount() == (427 - (183 + 244))) and (v113 > (1 + 0)) and (v114 > (731 - (434 + 296))) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((not v127() and (v129() or (v100.Stormkeeper:CooldownRemains() > (0 - 0)))) or not v100.SurgeofPower:IsAvailable())) then
			if (v104.CastTargetIf(v100.FlameShock, v112, "min", v122, nil, not v16:IsSpellInRange(v100.FlameShock)) or ((2582 - (169 + 343)) == (389 + 54))) then
				return "flame_shock single_target 14";
			end
			if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((4759 - 2054) == (4088 - 2695))) then
				return "flame_shock single_target 14";
			end
		end
		if ((v100.FlameShock:IsCastable() and v40 and (v113 > (1 + 0)) and (v114 > (2 - 1)) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((v13:BuffUp(v100.SurgeofPowerBuff) and not v129() and v100.Stormkeeper:CooldownDown()) or not v100.SurgeofPower:IsAvailable())) or ((5724 - (651 + 472)) < (47 + 14))) then
			local v198 = 0 + 0;
			while true do
				if (((0 - 0) == v198) or ((1873 - (397 + 86)) >= (5620 - (423 + 453)))) then
					if (v104.CastTargetIf(v100.FlameShock, v112, "min", v122, v119, not v16:IsSpellInRange(v100.FlameShock)) or ((204 + 1799) > (506 + 3328))) then
						return "flame_shock single_target 16";
					end
					if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((137 + 19) > (3123 + 790))) then
						return "flame_shock single_target 16";
					end
					break;
				end
			end
		end
		if (((175 + 20) == (1385 - (50 + 1140))) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 + 0)) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108) and v13:BuffDown(v100.AscendanceBuff) and not v129() and (v125() >= (69 + 47)) and v100.ElementalBlast:IsAvailable() and v100.SurgeofPower:IsAvailable() and v100.SwellingMaelstrom:IsAvailable() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) then
			if (((194 + 2911) >= (2579 - 783)) and v24(v100.Stormkeeper)) then
				return "stormkeeper single_target 18";
			end
		end
		if (((3169 + 1210) >= (2727 - (157 + 439))) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 - 0)) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108) and v13:BuffDown(v100.AscendanceBuff) and not v129() and v13:BuffUp(v100.SurgeofPowerBuff) and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) then
			if (((12772 - 8928) >= (6043 - 4000)) and v24(v100.Stormkeeper)) then
				return "stormkeeper single_target 20";
			end
		end
		if ((v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (918 - (782 + 136))) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108) and v13:BuffDown(v100.AscendanceBuff) and not v129() and (not v100.SurgeofPower:IsAvailable() or not v100.ElementalBlast:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.EchooftheElements:IsAvailable() or v100.PrimordialSurge:IsAvailable())) or ((4087 - (112 + 743)) <= (3902 - (1026 + 145)))) then
			if (((842 + 4063) == (5623 - (493 + 225))) and v24(v100.Stormkeeper)) then
				return "stormkeeper single_target 22";
			end
		end
		if ((v100.Ascendance:IsCastable() and v52 and ((v58 and v33) or not v58) and (v90 < v108) and not v129()) or ((15202 - 11066) >= (2684 + 1727))) then
			if (v24(v100.Ascendance) or ((7930 - 4972) == (77 + 3940))) then
				return "ascendance single_target 24";
			end
		end
		if (((3509 - 2281) >= (237 + 576)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v129() and v13:BuffUp(v100.SurgeofPowerBuff)) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((5771 - 2316) > (5645 - (210 + 1385)))) then
				return "lightning_bolt single_target 26";
			end
		end
		if (((1932 - (1201 + 488)) == (151 + 92)) and v100.LavaBeam:IsCastable() and v43 and (v113 > (1 - 0)) and (v114 > (1 - 0)) and v129() and not v100.SurgeofPower:IsAvailable()) then
			if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((856 - (352 + 233)) > (3798 - 2226))) then
				return "lava_beam single_target 28";
			end
		end
		if (((1490 + 1249) < (9362 - 6069)) and v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and (v113 > (575 - (489 + 85))) and (v114 > (1502 - (277 + 1224))) and v129() and not v100.SurgeofPower:IsAvailable()) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((5435 - (663 + 830)) < (997 + 137))) then
				return "chain_lightning single_target 30";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v129() and not v127() and not v100.SurgeofPower:IsAvailable() and v100.MasteroftheElements:IsAvailable()) or ((6594 - 3901) == (5848 - (461 + 414)))) then
			if (((360 + 1786) == (859 + 1287)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 32";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v129() and not v100.SurgeofPower:IsAvailable() and v127()) or ((214 + 2030) == (3179 + 45))) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((5154 - (172 + 78)) <= (3088 - 1172))) then
				return "lightning_bolt single_target 34";
			end
		end
		if (((34 + 56) <= (1536 - 471)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v129() and not v100.SurgeofPower:IsAvailable() and not v100.MasteroftheElements:IsAvailable()) then
			if (((1310 + 3492) == (1604 + 3198)) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 36";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v13:BuffUp(v100.SurgeofPowerBuff) and v100.LightningRod:IsAvailable()) or ((3819 - 1539) <= (643 - 132))) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((422 + 1254) <= (257 + 206))) then
				return "lightning_bolt single_target 38";
			end
		end
		if (((1378 + 2491) == (15401 - 11532)) and v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 - 0)) and v42 and v100.ElectrifiedShocks:IsAvailable() and v100.LightningRod:IsAvailable() and v100.LightningRod:IsAvailable()) then
			if (((356 + 802) <= (1492 + 1121)) and v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury))) then
				return "icefury single_target 40";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and v100.ElectrifiedShocks:IsAvailable() and ((v16:DebuffRemains(v100.ElectrifiedShocksDebuff) < (449 - (133 + 314))) or (v13:BuffRemains(v100.IcefuryBuff) <= v13:GCD())) and v100.LightningRod:IsAvailable()) or ((411 + 1953) <= (2212 - (199 + 14)))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((17619 - 12697) < (1743 - (647 + 902)))) then
				return "frost_shock single_target 42";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and v100.ElectrifiedShocks:IsAvailable() and (v125() >= (150 - 100)) and (v16:DebuffRemains(v100.ElectrifiedShocksDebuff) < ((235 - (85 + 148)) * v13:GCD())) and v129() and v100.LightningRod:IsAvailable()) or ((3380 - (426 + 863)) < (145 - 114))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((4084 - (873 + 781)) >= (6523 - 1651))) then
				return "frost_shock single_target 44";
			end
		end
		if ((v100.LavaBeam:IsCastable() and v43 and (v113 > (2 - 1)) and (v114 > (1 + 0)) and v128() and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime()) and not v13:HasTier(114 - 83, 5 - 1)) or ((14163 - 9393) < (3682 - (414 + 1533)))) then
			if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((3849 + 590) <= (2905 - (443 + 112)))) then
				return "lava_beam single_target 46";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and v129() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable() and v100.ElementalBlast:IsAvailable() and (((v125() >= (1540 - (888 + 591))) and (v125() < (193 - 118)) and (v100.LavaBurst:CooldownRemains() > v13:GCD())) or ((v125() >= (3 + 46)) and (v125() < (237 - 174)) and (v100.LavaBurst:CooldownRemains() > (0 + 0))))) or ((2167 + 2312) < (478 + 3988))) then
			if (((4853 - 2306) > (2269 - 1044)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 48";
			end
		end
		if (((6349 - (136 + 1542)) > (8768 - 6094)) and v100.FrostShock:IsCastable() and v41 and v130() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (((v125() >= (36 + 0)) and (v125() < (79 - 29)) and (v100.LavaBurst:CooldownRemains() > v13:GCD())) or ((v125() >= (18 + 6)) and (v125() < (524 - (68 + 418))) and v100.LavaBurst:CooldownUp()))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((10019 - 6323) < (6035 - 2708))) then
				return "frost_shock single_target 50";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffUp(v100.WindspeakersLavaResurgenceBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or ((v125() >= (55 + 8)) and v100.MasteroftheElements:IsAvailable()) or ((v125() >= (1130 - (770 + 322))) and v13:BuffUp(v100.EchoesofGreatSunderingBuff) and (v113 > (1 + 0)) and (v114 > (1 + 0))) or not v100.ElementalBlast:IsAvailable())) or ((620 + 3922) == (4249 - 1279))) then
			if (((488 - 236) <= (5384 - 3407)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 52";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffUp(v100.LavaSurgeBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or not v100.ElementalBlast:IsAvailable())) or ((5281 - 3845) == (2103 + 1672))) then
			if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((2424 - 806) < (447 + 483))) then
				return "lava_burst single_target 54";
			end
		end
		if (((2896 + 1827) > (3255 + 898)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffUp(v100.AscendanceBuff) and (v13:HasTier(116 - 85, 4 - 0) or not v100.ElementalBlast:IsAvailable())) then
			local v199 = 0 + 0;
			while true do
				if ((v199 == (0 - 0)) or ((12078 - 8424) >= (1915 + 2739))) then
					if (((4705 - 3754) <= (2327 - (762 + 69))) and v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 56";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((5621 - 3885) == (492 + 79))) then
						return "lava_burst single_target 56";
					end
					break;
				end
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffDown(v100.AscendanceBuff) and (not v100.ElementalBlast:IsAvailable() or not v100.MountainsWillFall:IsAvailable()) and not v100.LightningRod:IsAvailable() and v13:HasTier(21 + 10, 9 - 5)) or ((282 + 614) > (76 + 4693))) then
			local v200 = 0 - 0;
			while true do
				if ((v200 == (157 - (8 + 149))) or ((2365 - (1199 + 121)) <= (1726 - 706))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst)) or ((2618 - 1458) <= (136 + 192))) then
						return "lava_burst single_target 58";
					end
					if (((13592 - 9784) > (6784 - 3860)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 58";
					end
					break;
				end
			end
		end
		if (((3443 + 448) < (6726 - (518 + 1289))) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v100.MasteroftheElements:IsAvailable() and not v127() and not v100.LightningRod:IsAvailable()) then
			local v201 = 0 - 0;
			while true do
				if ((v201 == (0 + 0)) or ((3262 - 1028) <= (1107 + 395))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst)) or ((2981 - (304 + 165)) < (408 + 24))) then
						return "lava_burst single_target 60";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((2008 - (54 + 106)) == (2834 - (1618 + 351)))) then
						return "lava_burst single_target 60";
					end
					break;
				end
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v100.MasteroftheElements:IsAvailable() and not v127() and ((v125() >= (53 + 22)) or ((v125() >= (1066 - (10 + 1006))) and not v100.ElementalBlast:IsAvailable())) and v100.SwellingMaelstrom:IsAvailable() and (v125() <= (33 + 97))) or ((656 + 4026) <= (14721 - 10180))) then
			if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((4059 - (912 + 121)) >= (1912 + 2134))) then
				return "lava_burst single_target 62";
			end
		end
		if (((3297 - (1140 + 149)) > (409 + 229)) and v100.Earthquake:IsReady() and v37 and v13:BuffUp(v100.EchoesofGreatSunderingBuff) and ((not v100.ElementalBlast:IsAvailable() and (v113 < (2 - 0))) or (v113 > (1 + 0)))) then
			local v202 = 0 - 0;
			while true do
				if (((3329 - 1554) <= (558 + 2675)) and (v202 == (0 - 0))) then
					if ((v51 == "cursor") or ((4729 - (165 + 21)) == (2108 - (61 + 50)))) then
						if (v24(v102.EarthquakeCursor, not v16:IsInRange(17 + 23)) or ((14785 - 11683) < (1466 - 738))) then
							return "earthquake single_target 64";
						end
					end
					if (((136 + 209) == (1805 - (1295 + 165))) and (v51 == "player")) then
						if (v24(v102.EarthquakePlayer, not v16:IsInRange(10 + 30)) or ((1137 + 1690) < (1775 - (819 + 578)))) then
							return "earthquake single_target 64";
						end
					end
					break;
				end
			end
		end
		if ((v100.Earthquake:IsReady() and v37 and (v113 > (1403 - (331 + 1071))) and (v114 > (744 - (588 + 155))) and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable()) or ((4758 - (546 + 736)) < (4534 - (1834 + 103)))) then
			local v203 = 0 + 0;
			while true do
				if (((9185 - 6106) < (6560 - (1536 + 230))) and ((491 - (128 + 363)) == v203)) then
					if (((1032 + 3822) > (11105 - 6641)) and (v51 == "cursor")) then
						if (v24(v102.EarthquakeCursor, not v16:IsInRange(11 + 29)) or ((8137 - 3225) == (11063 - 7305))) then
							return "earthquake single_target 66";
						end
					end
					if (((305 - 179) <= (2390 + 1092)) and (v51 == "player")) then
						if (v24(v102.EarthquakePlayer, not v16:IsInRange(1049 - (615 + 394))) or ((2144 + 230) == (4169 + 205))) then
							return "earthquake single_target 66";
						end
					end
					break;
				end
			end
		end
		if (((4801 - 3226) == (7143 - 5568)) and v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v39 and (not v100.MasteroftheElements:IsAvailable() or (v127() and v16:DebuffUp(v100.ElectrifiedShocksDebuff)))) then
			if (v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast)) or ((2885 - (59 + 592)) == (3221 - 1766))) then
				return "elemental_blast single_target 68";
			end
		end
		if ((v126(v100.FrostShock) and v41 and v130() and v127() and (v125() < (202 - 92)) and (v100.LavaBurst:ChargesFractional() < (1 + 0)) and v100.ElectrifiedShocks:IsAvailable() and v100.ElementalBlast:IsAvailable() and not v100.LightningRod:IsAvailable()) or ((1238 - (70 + 101)) > (4397 - 2618))) then
			if (((1533 + 628) >= (2345 - 1411)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 70";
			end
		end
		if (((1853 - (123 + 118)) == (391 + 1221)) and v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v39 and (v127() or v100.LightningRod:IsAvailable())) then
			if (((55 + 4297) >= (4232 - (653 + 746))) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast single_target 72";
			end
		end
		if ((v100.EarthShock:IsCastable() and v38) or ((6025 - 2803) < (4427 - 1354))) then
			if (((1991 - 1247) <= (1299 + 1643)) and v24(v100.EarthShock, not v16:IsSpellInRange(v100.EarthShock))) then
				return "earth_shock single_target 74";
			end
		end
		if ((v126(v100.FrostShock) and v41 and v130() and v100.ElectrifiedShocks:IsAvailable() and v127() and not v100.LightningRod:IsAvailable() and (v113 > (1 + 0)) and (v114 > (1 + 0))) or ((225 + 1608) <= (207 + 1115))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((8499 - 5032) <= (1005 + 50))) then
				return "frost_shock single_target 76";
			end
		end
		if (((6541 - 3000) == (4775 - (885 + 349))) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and (v100.DeeplyRootedElements:IsAvailable())) then
			local v204 = 0 + 0;
			while true do
				if ((v204 == (0 - 0)) or ((10346 - 6789) >= (4971 - (915 + 53)))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst)) or ((1458 - (768 + 33)) >= (6386 - 4718))) then
						return "lava_burst single_target 78";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((1807 - 780) > (4186 - (287 + 41)))) then
						return "lava_burst single_target 78";
					end
					break;
				end
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and v100.FluxMelting:IsAvailable() and v13:BuffDown(v100.FluxMeltingBuff)) or ((4501 - (638 + 209)) < (234 + 216))) then
			if (((3577 - (96 + 1590)) < (6125 - (741 + 931))) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 80";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and ((v100.ElectrifiedShocks:IsAvailable() and (v16:DebuffRemains(v100.ElectrifiedShocksDebuff) < (1 + 1))) or (v13:BuffRemains(v100.IcefuryBuff) < (17 - 11)))) or ((14669 - 11529) < (914 + 1215))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((1098 + 1457) < (396 + 844))) then
				return "frost_shock single_target 82";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.ElementalBlast:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or v129())) or ((17937 - 13210) <= (1535 + 3187))) then
			if (((362 + 378) < (20138 - 15201)) and v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 84";
			end
			if (((3283 + 375) >= (774 - (64 + 430))) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 84";
			end
		end
		if ((v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v39) or ((879 + 6) >= (1394 - (106 + 257)))) then
			if (((2520 + 1034) >= (1246 - (496 + 225))) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast single_target 86";
			end
		end
		if (((4935 - 2521) <= (14477 - 11505)) and v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and v128() and v100.UnrelentingCalamity:IsAvailable() and (v113 > (1659 - (256 + 1402))) and (v114 > (1900 - (30 + 1869)))) then
			if (((4898 - (213 + 1156)) <= (3726 - (96 + 92))) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 88";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v128() and v100.UnrelentingCalamity:IsAvailable()) or ((488 + 2373) < (1357 - (142 + 757)))) then
			if (((1399 + 318) <= (1850 + 2675)) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 90";
			end
		end
		if ((v126(v100.Icefury) and v100.Icefury:IsCastable() and v42) or ((3257 - (32 + 47)) <= (3501 - (1053 + 924)))) then
			if (((4167 + 87) > (637 - 267)) and v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury))) then
				return "icefury single_target 92";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v100.LightningRodDebuff) and (v16:DebuffUp(v100.ElectrifiedShocksDebuff) or v128()) and (v113 > (1649 - (685 + 963))) and (v114 > (1 - 0))) or ((2549 - 914) == (3486 - (541 + 1168)))) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((4935 - (645 + 952)) >= (4831 - (669 + 169)))) then
				return "chain_lightning single_target 94";
			end
		end
		if (((3997 - 2843) <= (3203 - 1728)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v100.LightningRodDebuff) and (v16:DebuffUp(v100.ElectrifiedShocksDebuff) or v128())) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((882 + 1728) < (272 + 958))) then
				return "lightning_bolt single_target 96";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and v127() and v13:BuffDown(v100.LavaSurgeBuff) and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable() and (v100.LavaBurst:ChargesFractional() < (766 - (181 + 584))) and v100.EchooftheElements:IsAvailable()) or ((2843 - (665 + 730)) == (8885 - 5802))) then
			if (((6401 - 3262) > (2266 - (540 + 810))) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 98";
			end
		end
		if (((11810 - 8856) == (8121 - 5167)) and v100.FrostShock:IsCastable() and v41 and v130() and (v100.FluxMelting:IsAvailable() or (v100.ElectrifiedShocks:IsAvailable() and not v100.LightningRod:IsAvailable()))) then
			if (((94 + 23) <= (3095 - (166 + 37))) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 100";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and v127() and v13:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (1882 - (22 + 1859))) and v100.EchooftheElements:IsAvailable() and (v113 > (1773 - (843 + 929))) and (v114 > (263 - (30 + 232)))) or ((1293 - 840) > (5439 - (55 + 722)))) then
			if (((2833 - 1513) > (2270 - (78 + 1597))) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 102";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v127() and v13:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (1 + 0)) and v100.EchooftheElements:IsAvailable()) or ((2911 + 288) < (494 + 96))) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((5342 - (305 + 244)) < (28 + 2))) then
				return "lightning_bolt single_target 104";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable()) or ((1801 - (95 + 10)) <= (750 + 309))) then
			if (((7424 - 5081) == (3204 - 861)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 106";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and (v113 > (763 - (592 + 170))) and (v114 > (3 - 2))) or ((2619 - 1576) > (1674 + 1917))) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((1125 + 1765) >= (9849 - 5770))) then
				return "chain_lightning single_target 108";
			end
		end
		if (((726 + 3748) <= (8840 - 4070)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((5449 - (353 + 154)) == (5194 - 1291))) then
				return "lightning_bolt single_target 110";
			end
		end
		if ((v100.FlameShock:IsCastable() and v40 and (v13:IsMoving())) or ((338 - 90) > (3343 + 1502))) then
			local v205 = 0 + 0;
			while true do
				if (((1036 + 533) == (2266 - 697)) and (v205 == (0 - 0))) then
					if (v104.CastCycle(v100.FlameShock, v112, v119, not v16:IsSpellInRange(v100.FlameShock)) or ((11485 - 6558) <= (3307 - (7 + 79)))) then
						return "flame_shock single_target 112";
					end
					if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((833 + 947) > (2968 - (24 + 157)))) then
						return "flame_shock single_target 112";
					end
					break;
				end
			end
		end
		if ((v100.FlameShock:IsCastable() and v40) or ((7856 - 3919) <= (2623 - 1393))) then
			if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((750 + 1887) < (4595 - 2889))) then
				return "flame_shock single_target 114";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41) or ((3049 - (262 + 118)) <= (3492 - (1038 + 45)))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((3029 - 1628) > (4926 - (19 + 211)))) then
				return "frost_shock single_target 116";
			end
		end
	end
	local function v139()
		local v169 = 113 - (88 + 25);
		while true do
			if ((v169 == (7 - 4)) or ((1628 + 1652) < (1233 + 88))) then
				if (((5963 - (1007 + 29)) >= (621 + 1682)) and v100.ImprovedFlametongueWeapon:IsAvailable() and v100.FlametongueWeapon:IsCastable() and v50 and (not v109 or (v110 < (1466620 - 866620))) and v100.FlametongueWeapon:IsAvailable()) then
					if (((16373 - 12911) >= (230 + 802)) and v24(v100.FlametongueWeapon)) then
						return "flametongue_weapon enchant";
					end
				end
				if ((not v13:AffectingCombat() and v31 and v104.TargetIsValid()) or ((1888 - (340 + 471)) >= (5065 - 3054))) then
					local v250 = 589 - (276 + 313);
					while true do
						if (((3766 - 2223) < (2227 + 188)) and (v250 == (0 + 0))) then
							v30 = v136();
							if (v30 or ((417 + 4027) < (3987 - (495 + 1477)))) then
								return v30;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v169 == (5 - 3)) or ((2752 + 1448) == (2735 - (342 + 61)))) then
				if ((v100.AncestralSpirit:IsCastable() and v100.AncestralSpirit:IsReady() and not v13:AffectingCombat() and v14:Exists() and v14:IsDeadOrGhost() and v14:IsAPlayer() and not v13:CanAttack(v14)) or ((559 + 719) >= (1481 - (4 + 161)))) then
					if (((663 + 419) == (3396 - 2314)) and v24(v102.AncestralSpiritMouseover)) then
						return "ancestral_spirit mouseover";
					end
				end
				v109, v110 = v29();
				v169 = 7 - 4;
			end
			if (((1825 - (322 + 175)) <= (5441 - (173 + 390))) and (v169 == (0 + 0))) then
				if (((4401 - (203 + 111)) >= (84 + 1271)) and v73 and v100.EarthShield:IsCastable() and v13:BuffDown(v100.EarthShieldBuff) and ((v74 == "Earth Shield") or (v100.ElementalOrbit:IsAvailable() and v13:BuffUp(v100.LightningShield)))) then
					if (v24(v100.EarthShield) or ((417 + 173) > (13570 - 8920))) then
						return "earth_shield main 2";
					end
				elseif ((v73 and v100.LightningShield:IsCastable() and v13:BuffDown(v100.LightningShieldBuff) and ((v74 == "Lightning Shield") or (v100.ElementalOrbit:IsAvailable() and v13:BuffUp(v100.EarthShield)))) or ((3410 + 364) <= (4373 - (57 + 649)))) then
					if (((1654 - (328 + 56)) < (687 + 1459)) and v24(v100.LightningShield)) then
						return "lightning_shield main 2";
					end
				end
				v30 = v133();
				v169 = 513 - (433 + 79);
			end
			if (((419 + 4144) >= (46 + 10)) and (v169 == (3 - 2))) then
				if (v30 or ((2109 - 1663) == (454 + 168))) then
					return v30;
				end
				if (((1844 + 225) > (2045 - (562 + 474))) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
					if (((27 - 15) < (8573 - 4365)) and v24(v100.AncestralSpirit, nil, true)) then
						return "ancestral_spirit";
					end
				end
				v169 = 907 - (76 + 829);
			end
		end
	end
	local function v140()
		local v170 = 1673 - (1506 + 167);
		while true do
			if ((v170 == (0 - 0)) or ((3256 - (58 + 208)) <= (1760 + 1220))) then
				v30 = v134();
				if (v30 or ((1835 + 740) >= (2457 + 1818))) then
					return v30;
				end
				v170 = 3 - 2;
			end
			if ((v170 == (338 - (258 + 79))) or ((461 + 3165) <= (2747 - 1441))) then
				if (((2838 - (1219 + 251)) < (5451 - (1231 + 440))) and v85) then
					if (v80 or ((3227 - (34 + 24)) == (1319 + 954))) then
						local v261 = 0 - 0;
						while true do
							if (((1085 + 1396) <= (9958 - 6679)) and (v261 == (0 - 0))) then
								v30 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 105 - 65);
								if (v30 or ((3560 - 2497) <= (1914 - 1037))) then
									return v30;
								end
								break;
							end
						end
					end
					if (((3903 - (877 + 712)) == (1386 + 928)) and v81) then
						v30 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 784 - (242 + 512));
						if (((1930 - 1006) >= (1104 - (92 + 535))) and v30) then
							return v30;
						end
					end
					if (((1428 + 385) <= (7781 - 4003)) and v82) then
						v30 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 2 + 28);
						if (((15083 - 10933) == (4069 + 81)) and v30) then
							return v30;
						end
					end
				end
				if (((300 + 132) <= (422 + 2585)) and v86) then
					local v251 = 0 - 0;
					while true do
						if ((v251 == (0 - 0)) or ((2193 - (1476 + 309)) > (4005 - (299 + 985)))) then
							v30 = v104.HandleIncorporeal(v100.Hex, v102.HexMouseOver, 8 + 22, true);
							if (v30 or ((11204 - 7786) < (2590 - (86 + 7)))) then
								return v30;
							end
							break;
						end
					end
				end
				v170 = 8 - 6;
			end
			if (((165 + 1570) < (3049 - (672 + 208))) and (v170 == (2 + 1))) then
				if (((4022 - (14 + 118)) >= (3707 - (339 + 106))) and v100.Purge:IsReady() and v97 and v35 and v83 and not v13:IsCasting() and not v13:IsChanneling() and v104.UnitHasMagicBuff(v16)) then
					if (v24(v100.Purge, not v16:IsSpellInRange(v100.Purge)) or ((3466 + 890) >= (2339 + 2310))) then
						return "purge damage";
					end
				end
				if (((5299 - (440 + 955)) == (3847 + 57)) and v104.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) then
					local v252 = 0 - 0;
					local v253;
					while true do
						if ((v252 == (1 + 1)) or ((7120 - 4260) >= (2596 + 1193))) then
							if (v253 or ((1439 - (260 + 93)) > (4168 + 281))) then
								return v253;
							end
							if (((11393 - 6412) > (985 - 439)) and v32 and (v113 > (1976 - (1181 + 793))) and (v114 > (1 + 1))) then
								local v267 = 307 - (105 + 202);
								while true do
									if ((v267 == (0 + 0)) or ((3176 - (352 + 458)) <= (32 - 24))) then
										v30 = v137();
										if (v30 or ((6621 - 4031) == (2773 + 91))) then
											return v30;
										end
										v267 = 2 - 1;
									end
									if ((v267 == (950 - (438 + 511))) or ((4007 - (1262 + 121)) > (5217 - (728 + 340)))) then
										if (v24(v100.Pool) or ((4408 - (816 + 974)) >= (13770 - 9275))) then
											return "Pool for Aoe()";
										end
										break;
									end
								end
							end
							v252 = 10 - 7;
						end
						if ((v252 == (339 - (163 + 176))) or ((7073 - 4588) >= (14388 - 11257))) then
							if (((v90 < v108) and v57 and ((v63 and v33) or not v63)) or ((847 + 1957) <= (4595 - (1564 + 246)))) then
								if ((v100.BloodFury:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (395 - (124 + 221))))) or ((3123 + 1448) == (3866 - (115 + 336)))) then
									if (v24(v100.BloodFury) or ((9780 - 5339) > (986 + 3801))) then
										return "blood_fury main 2";
									end
								end
								if (((1966 - (45 + 1)) == (104 + 1816)) and v100.Berserking:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff))) then
									if (v24(v100.Berserking) or ((2637 - (1282 + 708)) == (5689 - (583 + 629)))) then
										return "berserking main 4";
									end
								end
								if (((636 + 3183) == (9879 - 6060)) and v100.Fireblood:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (27 + 23)))) then
									if (v24(v100.Fireblood) or ((2636 - (943 + 227)) > (1907 + 2453))) then
										return "fireblood main 6";
									end
								end
								if ((v100.AncestralCall:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (1681 - (1539 + 92))))) or ((1960 - (706 + 1240)) > (1252 - (81 + 177)))) then
									if (((1132 - 731) <= (991 - (212 + 45))) and v24(v100.AncestralCall)) then
										return "ancestral_call main 8";
									end
								end
								if ((v100.BagofTricks:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff))) or ((7248 - 5081) >= (5372 - (708 + 1238)))) then
									if (((64 + 700) < (1075 + 2210)) and v24(v100.BagofTricks)) then
										return "bag_of_tricks main 10";
									end
								end
							end
							if (((4166 - (586 + 1081)) == (3010 - (348 + 163))) and (v90 < v108)) then
								if ((v56 and ((v33 and v62) or not v62)) or ((622 + 70) >= (5213 - (215 + 65)))) then
									v30 = v135();
									if (v30 or ((8036 - 4882) <= (4119 - (1541 + 318)))) then
										return v30;
									end
								end
							end
							v252 = 1 + 0;
						end
						if ((v252 == (2 + 1)) or ((1988 + 649) > (4899 - (1036 + 714)))) then
							if (true or ((2631 + 1361) < (1330 + 1077))) then
								local v268 = 1280 - (883 + 397);
								while true do
									if ((v268 == (590 - (563 + 27))) or ((11354 - 8452) > (6845 - (1369 + 617)))) then
										v30 = v138();
										if (((3166 - (85 + 1402)) < (1503 + 2856)) and v30) then
											return v30;
										end
										v268 = 2 - 1;
									end
									if (((2316 - (274 + 129)) < (4887 - (12 + 205))) and (v268 == (1 + 0))) then
										if (v24(v100.Pool) or ((11035 - 8189) < (851 + 28))) then
											return "Pool for SingleTarget()";
										end
										break;
									end
								end
							end
							break;
						end
						if (((4972 - (27 + 357)) == (5068 - (91 + 389))) and (v252 == (298 - (90 + 207)))) then
							if ((v100.NaturesSwiftness:IsCastable() and v46) or ((14 + 333) == (2926 - (706 + 155)))) then
								if (v24(v100.NaturesSwiftness) or ((3106 - (730 + 1065)) > (4260 - (1339 + 224)))) then
									return "natures_swiftness main 12";
								end
							end
							v253 = v104.HandleDPSPotion(v13:BuffUp(v100.AscendanceBuff));
							v252 = 2 + 0;
						end
					end
				end
				break;
			end
			if ((v170 == (2 + 0)) or ((4044 - 1327) > (4638 - (268 + 575)))) then
				if (v84 or ((2375 - (919 + 375)) < (1075 - 684))) then
					local v254 = 971 - (180 + 791);
					while true do
						if ((v254 == (1805 - (323 + 1482))) or ((2039 - (1177 + 741)) > (226 + 3212))) then
							if (((266 - 195) < (751 + 1198)) and v17) then
								v30 = v132();
								if (((9501 - 5247) == (356 + 3898)) and v30) then
									return v30;
								end
							end
							if (((3305 - (96 + 13)) >= (4471 - (962 + 959))) and v14 and v14:Exists() and not v13:CanAttack(v14) and (v104.UnitHasDispellableDebuffByPlayer(v14) or v104.UnitHasCurseDebuff(v14))) then
								if (((6134 - 3678) < (740 + 3436)) and v100.CleanseSpirit:IsCastable()) then
									if (v24(v102.CleanseSpiritMouseover, not v14:IsSpellInRange(v100.PurifySpirit)) or ((2501 - (461 + 890)) == (2533 + 919))) then
										return "purify_spirit dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				if (((7305 - 5430) < (2501 - (19 + 224))) and v100.GreaterPurge:IsAvailable() and v97 and v100.GreaterPurge:IsReady() and v35 and v83 and not v13:IsCasting() and not v13:IsChanneling() and v104.UnitHasMagicBuff(v16)) then
					if (((1064 + 109) > (239 - (37 + 161))) and v24(v100.GreaterPurge, not v16:IsSpellInRange(v100.GreaterPurge))) then
						return "greater_purge damage";
					end
				end
				v170 = 2 + 1;
			end
		end
	end
	local function v141()
		local v171 = 0 + 0;
		while true do
			if ((v171 == (0 + 0)) or ((117 - (60 + 1)) >= (4131 - (826 + 97)))) then
				v36 = EpicSettings.Settings['useChainlightning'];
				v37 = EpicSettings.Settings['useEarthquake'];
				v38 = EpicSettings.Settings['useEarthShock'];
				v39 = EpicSettings.Settings['useElementalBlast'];
				v171 = 1 + 0;
			end
			if (((15503 - 11190) > (6948 - 3575)) and ((686 - (375 + 310)) == v171)) then
				v40 = EpicSettings.Settings['useFlameShock'];
				v41 = EpicSettings.Settings['useFrostShock'];
				v42 = EpicSettings.Settings['useIceFury'];
				v43 = EpicSettings.Settings['useLavaBeam'];
				v171 = 2001 - (1864 + 135);
			end
			if (((7 - 4) == v171) or ((995 + 3498) == (745 + 1480))) then
				v48 = EpicSettings.Settings['useStormkeeper'];
				v49 = EpicSettings.Settings['useTotemicRecall'];
				v50 = EpicSettings.Settings['useWeaponEnchant'];
				v91 = EpicSettings.Settings['useWeapon'];
				v171 = 9 - 5;
			end
			if (((4235 - (314 + 817)) >= (1754 + 1338)) and (v171 == (218 - (32 + 182)))) then
				v52 = EpicSettings.Settings['useAscendance'];
				v54 = EpicSettings.Settings['useLiquidMagmaTotem'];
				v53 = EpicSettings.Settings['useFireElemental'];
				v55 = EpicSettings.Settings['useStormElemental'];
				v171 = 4 + 1;
			end
			if (((12400 - 8852) > (3163 - (39 + 26))) and (v171 == (150 - (54 + 90)))) then
				v64 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v65 = EpicSettings.Settings['stormkeeperWithMiniCD'];
				break;
			end
			if ((v171 == (203 - (45 + 153))) or ((1974 + 1278) == (1055 - (457 + 95)))) then
				v58 = EpicSettings.Settings['ascendanceWithCD'];
				v61 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
				v59 = EpicSettings.Settings['fireElementalWithCD'];
				v60 = EpicSettings.Settings['stormElementalWithCD'];
				v171 = 6 + 0;
			end
			if (((9879 - 5146) > (4993 - 2927)) and (v171 == (7 - 5))) then
				v44 = EpicSettings.Settings['useLavaBurst'];
				v45 = EpicSettings.Settings['useLightningBolt'];
				v46 = EpicSettings.Settings['useNaturesSwiftness'];
				v47 = EpicSettings.Settings['usePrimordialWave'];
				v171 = 2 + 1;
			end
		end
	end
	local function v142()
		local v172 = 0 - 0;
		while true do
			if (((10714 - 7165) >= (1664 - (485 + 263))) and (v172 == (709 - (575 + 132)))) then
				v77 = EpicSettings.Settings['astralShiftHP'] or (861 - (750 + 111));
				v78 = EpicSettings.Settings['healingStreamTotemHP'] or (1010 - (445 + 565));
				v79 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
				v51 = EpicSettings.Settings['earthquakeSetting'] or "";
				v172 = 1 + 2;
			end
			if ((v172 == (5 - 2)) or ((731 + 1458) <= (555 - (189 + 121)))) then
				v66 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
				v73 = EpicSettings.Settings['autoShield'];
				v74 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v98 = EpicSettings.Settings['healOOC'];
				v172 = 1 + 3;
			end
			if (((1347 - (634 + 713)) == v172) or ((1927 - (493 + 45)) > (4893 - (493 + 475)))) then
				v67 = EpicSettings.Settings['useWindShear'];
				v68 = EpicSettings.Settings['useCapacitorTotem'];
				v69 = EpicSettings.Settings['useThunderstorm'];
				v70 = EpicSettings.Settings['useAncestralGuidance'];
				v172 = 1 + 0;
			end
			if (((4953 - (158 + 626)) >= (1449 + 1632)) and (v172 == (1 - 0))) then
				v71 = EpicSettings.Settings['useAstralShift'];
				v72 = EpicSettings.Settings['useHealingStreamTotem'];
				v75 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 + 0);
				v76 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
				v172 = 1093 - (1035 + 56);
			end
			if (((1308 - (114 + 845)) <= (349 + 545)) and ((10 - 6) == v172)) then
				v99 = EpicSettings.Settings['healOOCHP'] or (0 + 0);
				v97 = EpicSettings.Settings['usePurgeTarget'];
				v80 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v81 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v172 = 1054 - (179 + 870);
			end
			if (((1025 - 294) <= (3856 - (827 + 51))) and (v172 == (13 - 8))) then
				v82 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
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
		v95 = EpicSettings.Settings['healthstoneHP'] or (473 - (95 + 378));
		v94 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
		v96 = EpicSettings.Settings['HealingPotionName'] or "";
		v85 = EpicSettings.Settings['handleAfflicted'];
		v86 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v144()
		local v186 = 0 - 0;
		while true do
			if ((v186 == (4 + 0)) or ((1903 - (334 + 677)) > (14570 - 10678))) then
				if ((v35 and v84) or ((5522 - (1049 + 7)) == (3930 - 3030))) then
					if ((v13:AffectingCombat() and v100.CleanseSpirit:IsAvailable()) or ((3919 - 1835) >= (901 + 1987))) then
						local v262 = 0 - 0;
						local v263;
						while true do
							if (((959 - 480) < (830 + 1033)) and (v262 == (1420 - (1004 + 416)))) then
								v263 = v84 and v100.CleanseSpirit:IsReady() and v35;
								v30 = v104.FocusUnit(v263, nil, 1977 - (1621 + 336), nil, 1964 - (337 + 1602), v100.HealingSurge);
								v262 = 1518 - (1014 + 503);
							end
							if ((v262 == (1016 - (446 + 569))) or ((102 + 2326) >= (11847 - 7809))) then
								if (v30 or ((967 + 1911) > (6016 - 3119))) then
									return v30;
								end
								break;
							end
						end
					end
				end
				if (v104.TargetIsValid() or v13:AffectingCombat() or ((50 + 2419) > (4181 - (223 + 282)))) then
					local v255 = 0 + 0;
					while true do
						if (((370 - 137) < (709 - 222)) and (v255 == (671 - (623 + 47)))) then
							if (((2518 - (32 + 13)) >= (113 + 88)) and (v108 == (9014 + 2097))) then
								v108 = v9.FightRemains(v111, false);
							end
							break;
						end
						if (((5921 - (1070 + 731)) >= (128 + 5)) and (v255 == (1404 - (1257 + 147)))) then
							v107 = v9.BossFightRemains();
							v108 = v107;
							v255 = 1 + 0;
						end
					end
				end
				if (((5890 - 2810) >= (2119 - (98 + 35))) and not v13:IsChanneling() and not v13:IsCasting()) then
					if (v85 or ((604 + 835) > (12529 - 8991))) then
						local v264 = 0 - 0;
						while true do
							if ((v264 == (0 + 0)) or ((369 + 50) < (4 + 3))) then
								if (((3377 - (395 + 162)) == (2481 + 339)) and v80) then
									v30 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 1981 - (816 + 1125));
									if (v30 or ((6223 - 1861) <= (4675 - (701 + 447)))) then
										return v30;
									end
								end
								if (((4024 - 1411) <= (4684 - 2004)) and v81) then
									local v274 = 1341 - (391 + 950);
									while true do
										if ((v274 == (0 - 0)) or ((3713 - 2231) >= (10565 - 6277))) then
											v30 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 22 + 8);
											if (v30 or ((1433 + 1029) > (16183 - 11757))) then
												return v30;
											end
											break;
										end
									end
								end
								v264 = 1523 - (251 + 1271);
							end
							if (((4251 + 523) == (12781 - 8007)) and ((2 - 1) == v264)) then
								if (((936 - 370) <= (2219 - (1147 + 112))) and v82) then
									v30 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 8 + 22);
									if (v30 or ((5910 - 3000) <= (502 + 1428))) then
										return v30;
									end
								end
								break;
							end
						end
					end
					if (v13:AffectingCombat() or ((716 - (335 + 362)) > (424 + 28))) then
						local v265 = 0 - 0;
						while true do
							if ((v265 == (2 - 1)) or ((3370 - 2463) > (15346 - 12194))) then
								if (v30 or ((7109 - 4604) > (5036 - (237 + 329)))) then
									return v30;
								end
								break;
							end
							if ((v265 == (0 - 0)) or ((2447 + 1264) > (2223 + 1839))) then
								if (((1544 - (408 + 716)) == (1595 - 1175)) and v33 and v91 and (v101.Dreambinder:IsEquippedAndReady() or v101.Iridal:IsEquippedAndReady())) then
									if (v24(v102.UseWeapon, nil) or ((854 - (344 + 477)) >= (595 + 2899))) then
										return "Using Weapon Macro";
									end
								end
								v30 = v140();
								v265 = 1762 - (1188 + 573);
							end
						end
					else
						v30 = v139();
						if (v30 or ((3320 - 2053) == (4622 + 122))) then
							return v30;
						end
					end
				end
				break;
			end
			if (((7877 - 5449) < (5839 - 2061)) and (v186 == (4 - 2))) then
				v35 = EpicSettings.Toggles['dispel'];
				v34 = EpicSettings.Toggles['minicds'];
				if (v13:IsDeadOrGhost() or ((4475 - (508 + 1021)) <= (1500 + 96))) then
					return v30;
				end
				v186 = 1169 - (228 + 938);
			end
			if (((5118 - (332 + 353)) > (3809 - 682)) and ((7 - 4) == v186)) then
				v111 = v13:GetEnemiesInRange(38 + 2);
				v112 = v16:GetEnemiesInSplashRange(3 + 2);
				if (((17196 - 12896) >= (3156 - (18 + 405))) and v32) then
					v113 = #v111;
					v114 = v27(v16:GetEnemiesInSplashRangeCount(3 + 2), v113);
				else
					v113 = 1 + 0;
					v114 = 1 - 0;
				end
				v186 = 982 - (194 + 784);
			end
			if (((6599 - (694 + 1076)) == (6733 - (122 + 1782))) and (v186 == (1 + 0))) then
				v31 = EpicSettings.Toggles['ooc'];
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v186 = 2 + 0;
			end
			if (((1515 + 168) <= (3391 + 1335)) and (v186 == (0 - 0))) then
				v142();
				v141();
				v143();
				v186 = 1 + 0;
			end
		end
	end
	local function v145()
		v100.FlameShockDebuff:RegisterAuraTracking();
		v106();
		v21.Print("Elemental Shaman by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(2232 - (214 + 1756), v144, v145);
end;
return v0["Epix_Shaman_Elemental.lua"]();

