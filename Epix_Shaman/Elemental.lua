local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((4529 - 2862) >= (3090 + 201))) then
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
	local v99 = v18.Shaman.Elemental;
	local v100 = v20.Shaman.Elemental;
	local v101 = v23.Shaman.Elemental;
	local v102 = {};
	local v103 = v21.Commons.Everyone;
	local v104 = v21.Commons.Shaman;
	local function v105()
		if (v99.CleanseSpirit:IsAvailable() or ((813 + 60) == (2320 - (156 + 130)))) then
			v103.DispellableDebuffs = v103.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v105();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v9:RegisterForEvent(function()
		local v144 = 0 - 0;
		while true do
			if ((v144 == (1 - 0)) or ((5767 - 2951) < (3 + 8))) then
				v99.LavaBurst:RegisterInFlight();
				break;
			end
			if (((2157 + 1542) < (4775 - (10 + 59))) and (v144 == (0 + 0))) then
				v99.PrimordialWave:RegisterInFlightEffect(1611198 - 1284036);
				v99.PrimordialWave:RegisterInFlight();
				v144 = 1164 - (671 + 492);
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v99.PrimordialWave:RegisterInFlightEffect(260439 + 66723);
	v99.PrimordialWave:RegisterInFlight();
	v99.LavaBurst:RegisterInFlight();
	local v106 = 12326 - (369 + 846);
	local v107 = 2942 + 8169;
	local v108, v109;
	local v110, v111;
	local v112 = 0 + 0;
	local v113 = 1945 - (1036 + 909);
	local v114 = 0 + 0;
	local v115 = 0 - 0;
	local v116 = 203 - (11 + 192);
	local function v117()
		return (21 + 19) - (v28() - v114);
	end
	v9:RegisterForSelfCombatEvent(function(...)
		local v145, v146, v146, v146, v147 = select(183 - (135 + 40), ...);
		if (((6410 - 3764) >= (529 + 347)) and (v145 == v13:GUID()) and (v147 == (422177 - 230543))) then
			local v213 = 0 - 0;
			while true do
				if (((790 - (50 + 126)) <= (8865 - 5681)) and (v213 == (0 + 0))) then
					v115 = v28();
					C_Timer.After(1413.1 - (1233 + 180), function()
						if (((4095 - (522 + 447)) == (4547 - (107 + 1314))) and (v115 ~= v116)) then
							v114 = v115;
						end
					end);
					break;
				end
			end
		end
	end, "SPELL_AURA_APPLIED");
	local function v118(v148)
		return (v148:DebuffRefreshable(v99.FlameShockDebuff));
	end
	local function v119(v149)
		return v149:DebuffRefreshable(v99.FlameShockDebuff) and (v149:DebuffRemains(v99.FlameShockDebuff) < (v149:TimeToDie() - (3 + 2)));
	end
	local function v120(v150)
		return v150:DebuffRefreshable(v99.FlameShockDebuff) and (v150:DebuffRemains(v99.FlameShockDebuff) < (v150:TimeToDie() - (15 - 10))) and (v150:DebuffRemains(v99.FlameShockDebuff) > (0 + 0));
	end
	local function v121(v151)
		return (v151:DebuffRemains(v99.FlameShockDebuff));
	end
	local function v122(v152)
		return v152:DebuffRemains(v99.FlameShockDebuff) > (3 - 1);
	end
	local function v123(v153)
		return (v153:DebuffRemains(v99.LightningRodDebuff));
	end
	local function v124()
		local v154 = 0 - 0;
		local v155;
		while true do
			if ((v154 == (1910 - (716 + 1194))) or ((38 + 2149) >= (531 + 4423))) then
				v155 = v13:Maelstrom();
				if (not v13:IsCasting() or ((4380 - (74 + 429)) == (6896 - 3321))) then
					return v155;
				elseif (((351 + 356) > (1446 - 814)) and v13:IsCasting(v99.ElementalBlast)) then
					return v155 - (54 + 21);
				elseif (v13:IsCasting(v99.Icefury) or ((1682 - 1136) >= (6636 - 3952))) then
					return v155 + (458 - (279 + 154));
				elseif (((2243 - (454 + 324)) <= (3384 + 917)) and v13:IsCasting(v99.LightningBolt)) then
					return v155 + (27 - (12 + 5));
				elseif (((919 + 785) > (3630 - 2205)) and v13:IsCasting(v99.LavaBurst)) then
					return v155 + 5 + 7;
				elseif (v13:IsCasting(v99.ChainLightning) or ((1780 - (277 + 816)) == (18092 - 13858))) then
					return v155 + ((1187 - (1058 + 125)) * v113);
				else
					return v155;
				end
				break;
			end
		end
	end
	local function v125(v156)
		local v157 = 0 + 0;
		local v158;
		while true do
			if ((v157 == (975 - (815 + 160))) or ((14287 - 10957) < (3392 - 1963))) then
				v158 = v156:IsReady();
				if (((274 + 873) >= (979 - 644)) and ((v156 == v99.Stormkeeper) or (v156 == v99.ElementalBlast) or (v156 == v99.Icefury))) then
					local v256 = v13:BuffUp(v99.SpiritwalkersGraceBuff) or not v13:IsMoving();
					return v158 and v256 and not v13:IsCasting(v156);
				elseif (((5333 - (41 + 1857)) > (3990 - (1222 + 671))) and (v156 == v99.LavaBeam)) then
					local v261 = 0 - 0;
					local v262;
					while true do
						if ((v261 == (0 - 0)) or ((4952 - (229 + 953)) >= (5815 - (1111 + 663)))) then
							v262 = v13:BuffUp(v99.SpiritwalkersGraceBuff) or not v13:IsMoving();
							return v158 and v262;
						end
					end
				elseif ((v156 == v99.LightningBolt) or (v156 == v99.ChainLightning) or ((5370 - (874 + 705)) <= (226 + 1385))) then
					local v267 = 0 + 0;
					local v268;
					while true do
						if ((v267 == (0 - 0)) or ((129 + 4449) <= (2687 - (642 + 37)))) then
							v268 = v13:BuffUp(v99.SpiritwalkersGraceBuff) or v13:BuffUp(v99.StormkeeperBuff) or not v13:IsMoving();
							return v158 and v268;
						end
					end
				elseif (((257 + 868) <= (333 + 1743)) and (v156 == v99.LavaBurst)) then
					local v270 = 0 - 0;
					local v271;
					local v272;
					local v273;
					local v274;
					while true do
						if ((v270 == (456 - (233 + 221))) or ((1718 - 975) >= (3872 + 527))) then
							return v158 and v271 and (v272 or v273 or v274);
						end
						if (((2696 - (718 + 823)) < (1053 + 620)) and (v270 == (805 - (266 + 539)))) then
							v271 = v13:BuffUp(v99.SpiritwalkersGraceBuff) or v13:BuffUp(v99.LavaSurgeBuff) or not v13:IsMoving();
							v272 = v13:BuffUp(v99.LavaSurgeBuff);
							v270 = 2 - 1;
						end
						if (((1226 - (636 + 589)) == v270) or ((5516 - 3192) <= (1191 - 613))) then
							v273 = (v99.LavaBurst:Charges() >= (1 + 0)) and not v13:IsCasting(v99.LavaBurst);
							v274 = (v99.LavaBurst:Charges() == (1 + 1)) and v13:IsCasting(v99.LavaBurst);
							v270 = 1017 - (657 + 358);
						end
					end
				elseif (((9973 - 6206) == (8581 - 4814)) and (v156 == v99.PrimordialWave)) then
					return v158 and v33 and v13:BuffDown(v99.PrimordialWaveBuff) and v13:BuffDown(v99.LavaSurgeBuff);
				else
					return v158;
				end
				break;
			end
		end
	end
	local function v126()
		local v159 = 1187 - (1151 + 36);
		local v160;
		while true do
			if (((3949 + 140) == (1076 + 3013)) and (v159 == (2 - 1))) then
				if (((6290 - (1552 + 280)) >= (2508 - (64 + 770))) and not v13:IsCasting()) then
					return v160;
				elseif (((660 + 312) <= (3218 - 1800)) and v13:IsCasting(v104.LavaBurst)) then
					return true;
				elseif (v13:IsCasting(v104.ElementalBlast) or v13:IsCasting(v99.Icefury) or v13:IsCasting(v99.LightningBolt) or v13:IsCasting(v99.ChainLightning) or ((877 + 4061) < (6005 - (157 + 1086)))) then
					return false;
				else
					return v160;
				end
				break;
			end
			if (((0 - 0) == v159) or ((10966 - 8462) > (6540 - 2276))) then
				if (((2937 - 784) == (2972 - (599 + 220))) and not v99.MasteroftheElements:IsAvailable()) then
					return false;
				end
				v160 = v13:BuffUp(v99.MasteroftheElementsBuff);
				v159 = 1 - 0;
			end
		end
	end
	local function v127()
		local v161 = 1931 - (1813 + 118);
		local v162;
		while true do
			if ((v161 == (0 + 0)) or ((1724 - (841 + 376)) >= (3630 - 1039))) then
				if (((1041 + 3440) == (12230 - 7749)) and not v99.PoweroftheMaelstrom:IsAvailable()) then
					return false;
				end
				v162 = v13:BuffStack(v99.PoweroftheMaelstromBuff);
				v161 = 860 - (464 + 395);
			end
			if ((v161 == (2 - 1)) or ((1118 + 1210) < (1530 - (467 + 370)))) then
				if (((8943 - 4615) == (3177 + 1151)) and not v13:IsCasting()) then
					return v162 > (0 - 0);
				elseif (((248 + 1340) >= (3098 - 1766)) and (v162 == (521 - (150 + 370))) and (v13:IsCasting(v99.LightningBolt) or v13:IsCasting(v99.ChainLightning))) then
					return false;
				else
					return v162 > (1282 - (74 + 1208));
				end
				break;
			end
		end
	end
	local function v128()
		if (not v99.Stormkeeper:IsAvailable() or ((10266 - 6092) > (20146 - 15898))) then
			return false;
		end
		local v163 = v13:BuffUp(v99.StormkeeperBuff);
		if (not v13:IsCasting() or ((3264 + 1322) <= (472 - (14 + 376)))) then
			return v163;
		elseif (((6699 - 2836) == (2500 + 1363)) and v13:IsCasting(v99.Stormkeeper)) then
			return true;
		else
			return v163;
		end
	end
	local function v129()
		if (not v99.Icefury:IsAvailable() or ((248 + 34) <= (41 + 1))) then
			return false;
		end
		local v164 = v13:BuffUp(v99.IcefuryBuff);
		if (((13504 - 8895) >= (577 + 189)) and not v13:IsCasting()) then
			return v164;
		elseif (v13:IsCasting(v99.Icefury) or ((1230 - (23 + 55)) == (5896 - 3408))) then
			return true;
		else
			return v164;
		end
	end
	local function v130()
		if (((2284 + 1138) > (3009 + 341)) and v99.CleanseSpirit:IsReady() and v35 and v103.DispellableFriendlyUnit(38 - 13)) then
			v103.Wait(1 + 0);
			if (((1778 - (652 + 249)) > (1006 - 630)) and v24(v101.CleanseSpiritFocus)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v131()
		if ((v97 and (v13:HealthPercentage() <= v98)) or ((4986 - (708 + 1160)) <= (5024 - 3173))) then
			if (v99.HealingSurge:IsReady() or ((300 - 135) >= (3519 - (10 + 17)))) then
				if (((887 + 3062) < (6588 - (1400 + 332))) and v24(v99.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v132()
		local v165 = 0 - 0;
		while true do
			if ((v165 == (1908 - (242 + 1666))) or ((1830 + 2446) < (1106 + 1910))) then
				if (((3998 + 692) > (5065 - (850 + 90))) and v99.AstralShift:IsReady() and v71 and (v13:HealthPercentage() <= v77)) then
					if (v24(v99.AstralShift) or ((87 - 37) >= (2286 - (360 + 1030)))) then
						return "astral_shift defensive 1";
					end
				end
				if ((v99.AncestralGuidance:IsReady() and v70 and v103.AreUnitsBelowHealthPercentage(v75, v76)) or ((1517 + 197) >= (8348 - 5390))) then
					if (v24(v99.AncestralGuidance) or ((2051 - 560) < (2305 - (909 + 752)))) then
						return "ancestral_guidance defensive 2";
					end
				end
				v165 = 1224 - (109 + 1114);
			end
			if (((1288 - 584) < (385 + 602)) and (v165 == (244 - (6 + 236)))) then
				if (((2343 + 1375) > (1535 + 371)) and v91 and (v13:HealthPercentage() <= v93)) then
					if ((v95 == "Refreshing Healing Potion") or ((2259 - 1301) > (6349 - 2714))) then
						if (((4634 - (1076 + 57)) <= (739 + 3753)) and v100.RefreshingHealingPotion:IsReady()) then
							if (v24(v101.RefreshingHealingPotion) or ((4131 - (579 + 110)) < (202 + 2346))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((2542 + 333) >= (777 + 687)) and (v95 == "Dreamwalker's Healing Potion")) then
						if (v100.DreamwalkersHealingPotion:IsReady() or ((5204 - (174 + 233)) >= (13667 - 8774))) then
							if (v24(v101.RefreshingHealingPotion) or ((966 - 415) > (920 + 1148))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((3288 - (663 + 511)) > (843 + 101)) and (v165 == (1 + 0))) then
				if ((v99.HealingStreamTotem:IsReady() and v72 and v103.AreUnitsBelowHealthPercentage(v78, v79)) or ((6973 - 4711) >= (1875 + 1221))) then
					if (v24(v99.HealingStreamTotem) or ((5308 - 3053) >= (8561 - 5024))) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v100.Healthstone:IsReady() and v92 and (v13:HealthPercentage() <= v94)) or ((1831 + 2006) < (2541 - 1235))) then
					if (((2103 + 847) == (270 + 2680)) and v24(v101.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				v165 = 724 - (478 + 244);
			end
		end
	end
	local function v133()
		v30 = v103.HandleTopTrinket(v102, v33, 557 - (440 + 77), nil);
		if (v30 or ((2148 + 2575) < (12070 - 8772))) then
			return v30;
		end
		v30 = v103.HandleBottomTrinket(v102, v33, 1596 - (655 + 901), nil);
		if (((211 + 925) >= (118 + 36)) and v30) then
			return v30;
		end
	end
	local function v134()
		local v166 = 0 + 0;
		while true do
			if ((v166 == (11 - 8)) or ((1716 - (695 + 750)) > (16212 - 11464))) then
				if (((7315 - 2575) >= (12676 - 9524)) and v13:IsCasting(v99.LavaBurst) and v40 and v99.FlameShock:IsReady()) then
					if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((2929 - (285 + 66)) >= (7902 - 4512))) then
						return "flameshock precombat 14";
					end
				end
				if (((1351 - (682 + 628)) <= (268 + 1393)) and v13:IsCasting(v99.LavaBurst) and v47 and ((v64 and v34) or not v64) and v125(v99.PrimordialWave)) then
					if (((900 - (176 + 123)) < (1490 + 2070)) and v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave))) then
						return "primordial_wave precombat 16";
					end
				end
				break;
			end
			if (((171 + 64) < (956 - (239 + 30))) and (v166 == (1 + 1))) then
				if (((4373 + 176) > (2040 - 887)) and v13:IsCasting(v99.ElementalBlast) and v40 and not v99.PrimordialWave:IsAvailable() and v99.FlameShock:IsViable()) then
					if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((14582 - 9908) < (4987 - (306 + 9)))) then
						return "flameshock precombat 10";
					end
				end
				if (((12799 - 9131) < (794 + 3767)) and v125(v99.LavaBurst) and v44 and not v13:IsCasting(v99.LavaBurst) and (not v99.ElementalBlast:IsAvailable() or (v99.ElementalBlast:IsAvailable() and not v99.ElementalBlast:IsAvailable()))) then
					if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((280 + 175) == (1736 + 1869))) then
						return "lavaburst precombat 12";
					end
				end
				v166 = 8 - 5;
			end
			if ((v166 == (1375 - (1140 + 235))) or ((1695 + 968) == (3038 + 274))) then
				if (((1098 + 3179) <= (4527 - (33 + 19))) and v125(v99.Stormkeeper) and (v99.Stormkeeper:CooldownRemains() == (0 + 0)) and not v13:BuffUp(v99.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v107)) then
					if (v24(v99.Stormkeeper) or ((2607 - 1737) == (524 + 665))) then
						return "stormkeeper precombat 2";
					end
				end
				if (((3045 - 1492) <= (2938 + 195)) and v125(v99.Icefury) and (v99.Icefury:CooldownRemains() == (689 - (586 + 103))) and v42) then
					if (v24(v99.Icefury, not v16:IsSpellInRange(v99.Icefury)) or ((204 + 2033) >= (10809 - 7298))) then
						return "icefury precombat 4";
					end
				end
				v166 = 1489 - (1309 + 179);
			end
			if ((v166 == (1 - 0)) or ((577 + 747) > (8110 - 5090))) then
				if ((v125(v99.ElementalBlast) and v39) or ((2260 + 732) == (3996 - 2115))) then
					if (((6189 - 3083) > (2135 - (295 + 314))) and v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast))) then
						return "elemental_blast precombat 6";
					end
				end
				if (((7424 - 4401) < (5832 - (1300 + 662))) and v13:IsCasting(v99.ElementalBlast) and v47 and ((v64 and v34) or not v64) and v125(v99.PrimordialWave)) then
					if (((448 - 305) > (1829 - (1178 + 577))) and v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave))) then
						return "primordial_wave precombat 8";
					end
				end
				v166 = 2 + 0;
			end
		end
	end
	local function v135()
		if (((53 - 35) < (3517 - (851 + 554))) and v99.FireElemental:IsReady() and v53 and ((v59 and v33) or not v59) and (v90 < v107)) then
			if (((971 + 126) <= (4514 - 2886)) and v24(v99.FireElemental)) then
				return "fire_elemental aoe 2";
			end
		end
		if (((10055 - 5425) == (4932 - (115 + 187))) and v99.StormElemental:IsReady() and v55 and ((v60 and v33) or not v60) and (v90 < v107)) then
			if (((2712 + 828) > (2540 + 143)) and v24(v99.StormElemental)) then
				return "storm_elemental aoe 4";
			end
		end
		if (((18891 - 14097) >= (4436 - (160 + 1001))) and v125(v99.Stormkeeper) and not v128() and v48 and ((v65 and v34) or not v65) and (v90 < v107)) then
			if (((1299 + 185) == (1024 + 460)) and v24(v99.Stormkeeper)) then
				return "stormkeeper aoe 7";
			end
		end
		if (((2930 - 1498) < (3913 - (237 + 121))) and v99.TotemicRecall:IsCastable() and (v99.LiquidMagmaTotem:CooldownRemains() > (942 - (525 + 372))) and v49) then
			if (v24(v99.TotemicRecall) or ((2018 - 953) > (11755 - 8177))) then
				return "totemic_recall aoe 8";
			end
		end
		if ((v99.LiquidMagmaTotem:IsReady() and v54 and ((v61 and v33) or not v61) and (v90 < v107) and (v66 == "cursor")) or ((4937 - (96 + 46)) < (2184 - (643 + 134)))) then
			if (((669 + 1184) < (11540 - 6727)) and v24(v101.LiquidMagmaTotemCursor, not v16:IsInRange(148 - 108))) then
				return "liquid_magma_totem aoe cursor 10";
			end
		end
		if ((v99.LiquidMagmaTotem:IsReady() and v54 and ((v61 and v33) or not v61) and (v90 < v107) and (v66 == "player")) or ((2706 + 115) < (4770 - 2339))) then
			if (v24(v101.LiquidMagmaTotemPlayer, not v16:IsInRange(81 - 41)) or ((3593 - (316 + 403)) < (1450 + 731))) then
				return "liquid_magma_totem aoe player 11";
			end
		end
		if ((v125(v99.PrimordialWave) and v13:BuffDown(v99.PrimordialWaveBuff) and v13:BuffUp(v99.SurgeofPowerBuff) and v13:BuffDown(v99.SplinteredElementsBuff)) or ((7392 - 4703) <= (124 + 219))) then
			local v214 = 0 - 0;
			while true do
				if ((v214 == (0 + 0)) or ((603 + 1266) == (6960 - 4951))) then
					if (v103.CastTargetIf(v99.PrimordialWave, v111, "min", v121, nil, not v16:IsSpellInRange(v99.PrimordialWave), nil, nil) or ((16935 - 13389) < (4823 - 2501))) then
						return "primordial_wave aoe 12";
					end
					if (v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave)) or ((120 + 1962) == (9395 - 4622))) then
						return "primordial_wave aoe 12";
					end
					break;
				end
			end
		end
		if (((159 + 3085) > (3103 - 2048)) and v125(v99.PrimordialWave) and v13:BuffDown(v99.PrimordialWaveBuff) and v99.DeeplyRootedElements:IsAvailable() and not v99.SurgeofPower:IsAvailable() and v13:BuffDown(v99.SplinteredElementsBuff)) then
			local v215 = 17 - (12 + 5);
			while true do
				if ((v215 == (0 - 0)) or ((7068 - 3755) <= (3779 - 2001))) then
					if (v103.CastTargetIf(v99.PrimordialWave, v111, "min", v121, nil, not v16:IsSpellInRange(v99.PrimordialWave), nil, nil) or ((3523 - 2102) >= (428 + 1676))) then
						return "primordial_wave aoe 14";
					end
					if (((3785 - (1656 + 317)) <= (2896 + 353)) and v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave))) then
						return "primordial_wave aoe 14";
					end
					break;
				end
			end
		end
		if (((1301 + 322) <= (5203 - 3246)) and v125(v99.PrimordialWave) and v13:BuffDown(v99.PrimordialWaveBuff) and v99.MasteroftheElements:IsAvailable() and not v99.LightningRod:IsAvailable()) then
			local v216 = 0 - 0;
			while true do
				if (((4766 - (5 + 349)) == (20956 - 16544)) and (v216 == (1271 - (266 + 1005)))) then
					if (((1154 + 596) >= (2872 - 2030)) and v103.CastTargetIf(v99.PrimordialWave, v111, "min", v121, nil, not v16:IsSpellInRange(v99.PrimordialWave), nil, nil)) then
						return "primordial_wave aoe 16";
					end
					if (((5755 - 1383) > (3546 - (561 + 1135))) and v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave))) then
						return "primordial_wave aoe 16";
					end
					break;
				end
			end
		end
		if (((301 - 69) < (2698 - 1877)) and v99.FlameShock:IsCastable()) then
			local v217 = 1066 - (507 + 559);
			while true do
				if (((1299 - 781) < (2789 - 1887)) and ((388 - (212 + 176)) == v217)) then
					if (((3899 - (250 + 655)) > (2339 - 1481)) and v13:BuffUp(v99.SurgeofPowerBuff) and v40 and v99.LightningRod:IsAvailable() and v99.WindspeakersLavaResurgence:IsAvailable() and (v16:DebuffRemains(v99.FlameShockDebuff) < (v16:TimeToDie() - (27 - 11))) and (v110 < (7 - 2))) then
						if (v103.CastCycle(v99.FlameShock, v111, v119, not v16:IsSpellInRange(v99.FlameShock)) or ((5711 - (1869 + 87)) <= (3173 - 2258))) then
							return "flame_shock aoe 18";
						end
						if (((5847 - (484 + 1417)) > (8022 - 4279)) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
							return "flame_shock aoe 18";
						end
					end
					if ((v13:BuffUp(v99.SurgeofPowerBuff) and v40 and (not v99.LightningRod:IsAvailable() or v99.SkybreakersFieryDemise:IsAvailable()) and (v99.FlameShockDebuff:AuraActiveCount() < (9 - 3))) or ((2108 - (48 + 725)) >= (5400 - 2094))) then
						if (((12995 - 8151) > (1310 + 943)) and v103.CastCycle(v99.FlameShock, v111, v119, not v16:IsSpellInRange(v99.FlameShock))) then
							return "flame_shock aoe 20";
						end
						if (((1207 - 755) == (127 + 325)) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
							return "flame_shock aoe 20";
						end
					end
					v217 = 1 + 0;
				end
				if (((855 - (152 + 701)) == v217) or ((5868 - (430 + 881)) < (800 + 1287))) then
					if (((4769 - (557 + 338)) == (1146 + 2728)) and v13:BuffUp(v99.SurgeofPowerBuff) and v40 and (not v99.LightningRod:IsAvailable() or v99.SkybreakersFieryDemise:IsAvailable())) then
						if (v103.CastCycle(v99.FlameShock, v111, v120, not v16:IsSpellInRange(v99.FlameShock)) or ((5461 - 3523) > (17281 - 12346))) then
							return "flame_shock aoe 26";
						end
						if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((11304 - 7049) < (7376 - 3953))) then
							return "flame_shock aoe 26";
						end
					end
					if (((2255 - (499 + 302)) <= (3357 - (39 + 827))) and v99.MasteroftheElements:IsAvailable() and v40 and not v99.LightningRod:IsAvailable() and not v99.SurgeofPower:IsAvailable()) then
						local v263 = 0 - 0;
						while true do
							if ((v263 == (0 - 0)) or ((16510 - 12353) <= (4302 - 1499))) then
								if (((416 + 4437) >= (8727 - 5745)) and v103.CastCycle(v99.FlameShock, v111, v120, not v16:IsSpellInRange(v99.FlameShock))) then
									return "flame_shock aoe 28";
								end
								if (((662 + 3472) > (5311 - 1954)) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
									return "flame_shock aoe 28";
								end
								break;
							end
						end
					end
					v217 = 107 - (103 + 1);
				end
				if ((v217 == (557 - (475 + 79))) or ((7386 - 3969) < (8108 - 5574))) then
					if ((v99.DeeplyRootedElements:IsAvailable() and v40 and not v99.SurgeofPower:IsAvailable()) or ((352 + 2370) <= (145 + 19))) then
						if (v103.CastCycle(v99.FlameShock, v111, v120, not v16:IsSpellInRange(v99.FlameShock)) or ((3911 - (1395 + 108)) < (6136 - 4027))) then
							return "flame_shock aoe 30";
						end
						if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((1237 - (7 + 1197)) == (635 + 820))) then
							return "flame_shock aoe 30";
						end
					end
					break;
				end
				if ((v217 == (1 + 0)) or ((762 - (27 + 292)) >= (11765 - 7750))) then
					if (((4312 - 930) > (696 - 530)) and v99.MasteroftheElements:IsAvailable() and v40 and not v99.LightningRod:IsAvailable() and (v99.FlameShockDebuff:AuraActiveCount() < (11 - 5))) then
						local v264 = 0 - 0;
						while true do
							if ((v264 == (139 - (43 + 96))) or ((1142 - 862) == (6915 - 3856))) then
								if (((1561 + 320) > (366 + 927)) and v103.CastCycle(v99.FlameShock, v111, v119, not v16:IsSpellInRange(v99.FlameShock))) then
									return "flame_shock aoe 22";
								end
								if (((4658 - 2301) == (904 + 1453)) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
									return "flame_shock aoe 22";
								end
								break;
							end
						end
					end
					if (((230 - 107) == (39 + 84)) and v99.DeeplyRootedElements:IsAvailable() and v40 and not v99.SurgeofPower:IsAvailable() and (v99.FlameShockDebuff:AuraActiveCount() < (1 + 5))) then
						if (v103.CastCycle(v99.FlameShock, v111, v119, not v16:IsSpellInRange(v99.FlameShock)) or ((2807 - (1414 + 337)) >= (5332 - (1642 + 298)))) then
							return "flame_shock aoe 24";
						end
						if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((2817 - 1736) < (3092 - 2017))) then
							return "flame_shock aoe 24";
						end
					end
					v217 = 5 - 3;
				end
			end
		end
		if ((v99.Ascendance:IsCastable() and v52 and ((v58 and v33) or not v58) and (v90 < v107)) or ((346 + 703) >= (3449 + 983))) then
			if (v24(v99.Ascendance) or ((5740 - (357 + 615)) <= (594 + 252))) then
				return "ascendance aoe 32";
			end
		end
		if ((v125(v99.LavaBurst) and (v113 == (6 - 3)) and not v99.LightningRod:IsAvailable() and v13:HasTier(27 + 4, 8 - 4)) or ((2686 + 672) <= (97 + 1323))) then
			if (v103.CastCycle(v99.LavaBurst, v111, v121, not v16:IsSpellInRange(v99.LavaBurst)) or ((2351 + 1388) <= (4306 - (384 + 917)))) then
				return "lava_burst aoe 34";
			end
			if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((2356 - (128 + 569)) >= (3677 - (1407 + 136)))) then
				return "lava_burst aoe 34";
			end
		end
		if ((v37 and v99.Earthquake:IsReady() and v126() and (((v13:BuffStack(v99.MagmaChamberBuff) > (1902 - (687 + 1200))) and (v113 >= ((1717 - (556 + 1154)) - v25(v99.UnrelentingCalamity:IsAvailable())))) or (v99.SplinteredElements:IsAvailable() and (v113 >= ((35 - 25) - v25(v99.UnrelentingCalamity:IsAvailable())))) or (v99.MountainsWillFall:IsAvailable() and (v113 >= (104 - (9 + 86))))) and not v99.LightningRod:IsAvailable() and v13:HasTier(452 - (275 + 146), 1 + 3)) or ((3324 - (29 + 35)) < (10437 - 8082))) then
			if ((v51 == "cursor") or ((1997 - 1328) == (18642 - 14419))) then
				if (v24(v101.EarthquakeCursor, not v16:IsInRange(27 + 13)) or ((2704 - (53 + 959)) < (996 - (312 + 96)))) then
					return "earthquake aoe 36";
				end
			end
			if ((v51 == "player") or ((8325 - 3528) < (3936 - (147 + 138)))) then
				if (v24(v101.EarthquakePlayer, not v16:IsInRange(939 - (813 + 86))) or ((3775 + 402) > (8985 - 4135))) then
					return "earthquake aoe 36";
				end
			end
		end
		if ((v125(v99.LavaBeam) and v43 and v128() and ((v13:BuffUp(v99.SurgeofPowerBuff) and (v113 >= (498 - (18 + 474)))) or (v126() and ((v113 < (3 + 3)) or not v99.SurgeofPower:IsAvailable()))) and not v99.LightningRod:IsAvailable() and v13:HasTier(101 - 70, 1090 - (860 + 226))) or ((703 - (121 + 182)) > (137 + 974))) then
			if (((4291 - (988 + 252)) > (114 + 891)) and v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam))) then
				return "lava_beam aoe 38";
			end
		end
		if (((1157 + 2536) <= (6352 - (49 + 1921))) and v125(v99.ChainLightning) and v36 and v128() and ((v13:BuffUp(v99.SurgeofPowerBuff) and (v113 >= (896 - (223 + 667)))) or (v126() and ((v113 < (58 - (51 + 1))) or not v99.SurgeofPower:IsAvailable()))) and not v99.LightningRod:IsAvailable() and v13:HasTier(53 - 22, 8 - 4)) then
			if (v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning)) or ((4407 - (146 + 979)) > (1158 + 2942))) then
				return "chain_lightning aoe 40";
			end
		end
		if ((v125(v99.LavaBurst) and v13:BuffUp(v99.LavaSurgeBuff) and not v99.LightningRod:IsAvailable() and v13:HasTier(636 - (311 + 294), 11 - 7)) or ((1517 + 2063) < (4287 - (496 + 947)))) then
			local v218 = 1358 - (1233 + 125);
			while true do
				if (((37 + 52) < (4029 + 461)) and ((0 + 0) == v218)) then
					if (v103.CastCycle(v99.LavaBurst, v111, v121, not v16:IsSpellInRange(v99.LavaBurst)) or ((6628 - (963 + 682)) < (1509 + 299))) then
						return "lava_burst aoe 42";
					end
					if (((5333 - (504 + 1000)) > (2539 + 1230)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst aoe 42";
					end
					break;
				end
			end
		end
		if (((1353 + 132) <= (275 + 2629)) and v125(v99.LavaBurst) and v13:BuffUp(v99.LavaSurgeBuff) and v99.MasteroftheElements:IsAvailable() and not v126() and (v124() >= (((88 - 28) - ((5 + 0) * v99.EyeoftheStorm:TalentRank())) - ((2 + 0) * v25(v99.FlowofPower:IsAvailable())))) and ((not v99.EchoesofGreatSundering:IsAvailable() and not v99.LightningRod:IsAvailable()) or v13:BuffUp(v99.EchoesofGreatSunderingBuff)) and ((not v13:BuffUp(v99.AscendanceBuff) and (v113 > (185 - (156 + 26))) and v99.UnrelentingCalamity:IsAvailable()) or ((v113 > (2 + 1)) and not v99.UnrelentingCalamity:IsAvailable()) or (v113 == (3 - 0)))) then
			if (((4433 - (149 + 15)) == (5229 - (890 + 70))) and v103.CastCycle(v99.LavaBurst, v111, v121, not v16:IsSpellInRange(v99.LavaBurst))) then
				return "lava_burst aoe 44";
			end
			if (((504 - (39 + 78)) <= (3264 - (14 + 468))) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
				return "lava_burst aoe 44";
			end
		end
		if ((v37 and v99.Earthquake:IsReady() and not v99.EchoesofGreatSundering:IsAvailable() and (v113 > (6 - 3)) and ((v113 > (8 - 5)) or (v112 > (2 + 1)))) or ((1141 + 758) <= (195 + 722))) then
			local v219 = 0 + 0;
			while true do
				if ((v219 == (0 + 0)) or ((8253 - 3941) <= (866 + 10))) then
					if (((7843 - 5611) <= (66 + 2530)) and (v51 == "cursor")) then
						if (((2146 - (12 + 39)) < (3430 + 256)) and v24(v101.EarthquakeCursor, not v16:IsInRange(123 - 83))) then
							return "earthquake aoe 46";
						end
					end
					if ((v51 == "player") or ((5680 - 4085) >= (1327 + 3147))) then
						if (v24(v101.EarthquakePlayer, not v16:IsInRange(22 + 18)) or ((11712 - 7093) < (1920 + 962))) then
							return "earthquake aoe 46";
						end
					end
					break;
				end
			end
		end
		if ((v37 and v99.Earthquake:IsReady() and not v99.EchoesofGreatSundering:IsAvailable() and not v99.ElementalBlast:IsAvailable() and (v113 == (14 - 11)) and ((v113 == (1713 - (1596 + 114))) or (v112 == (7 - 4)))) or ((1007 - (164 + 549)) >= (6269 - (1059 + 379)))) then
			if (((2518 - 489) <= (1599 + 1485)) and (v51 == "cursor")) then
				if (v24(v101.EarthquakeCursor, not v16:IsInRange(7 + 33)) or ((2429 - (145 + 247)) == (1986 + 434))) then
					return "earthquake aoe 48";
				end
			end
			if (((2060 + 2398) > (11574 - 7670)) and (v51 == "player")) then
				if (((84 + 352) >= (106 + 17)) and v24(v101.EarthquakePlayer, not v16:IsInRange(64 - 24))) then
					return "earthquake aoe 48";
				end
			end
		end
		if (((1220 - (254 + 466)) < (2376 - (544 + 16))) and v37 and v99.Earthquake:IsReady() and (v13:BuffUp(v99.EchoesofGreatSunderingBuff))) then
			if (((11358 - 7784) == (4202 - (294 + 334))) and (v51 == "cursor")) then
				if (((474 - (236 + 17)) < (169 + 221)) and v24(v101.EarthquakeCursor, not v16:IsInRange(32 + 8))) then
					return "earthquake aoe 50";
				end
			end
			if ((v51 == "player") or ((8334 - 6121) <= (6727 - 5306))) then
				if (((1575 + 1483) < (4003 + 857)) and v24(v101.EarthquakePlayer, not v16:IsInRange(834 - (413 + 381)))) then
					return "earthquake aoe 50";
				end
			end
		end
		if ((v125(v99.ElementalBlast) and v39 and v99.EchoesofGreatSundering:IsAvailable()) or ((55 + 1241) >= (9455 - 5009))) then
			local v220 = 0 - 0;
			while true do
				if ((v220 == (1970 - (582 + 1388))) or ((2372 - 979) > (3214 + 1275))) then
					if (v103.CastTargetIf(v99.ElementalBlast, v111, "min", v123, nil, not v16:IsSpellInRange(v99.ElementalBlast), nil, nil) or ((4788 - (326 + 38)) < (79 - 52))) then
						return "elemental_blast aoe 52";
					end
					if (v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast)) or ((2850 - 853) > (4435 - (47 + 573)))) then
						return "elemental_blast aoe 52";
					end
					break;
				end
			end
		end
		if (((1222 + 2243) > (8124 - 6211)) and v125(v99.ElementalBlast) and v39 and v99.EchoesofGreatSundering:IsAvailable()) then
			if (((1189 - 456) < (3483 - (1269 + 395))) and v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast))) then
				return "elemental_blast aoe 54";
			end
		end
		if ((v125(v99.ElementalBlast) and v39 and (v113 == (495 - (76 + 416))) and not v99.EchoesofGreatSundering:IsAvailable()) or ((4838 - (319 + 124)) == (10869 - 6114))) then
			if (v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast)) or ((4800 - (564 + 443)) < (6557 - 4188))) then
				return "elemental_blast aoe 56";
			end
		end
		if ((v125(v99.EarthShock) and v38 and v99.EchoesofGreatSundering:IsAvailable()) or ((4542 - (337 + 121)) == (776 - 511))) then
			local v221 = 0 - 0;
			while true do
				if (((6269 - (1261 + 650)) == (1844 + 2514)) and (v221 == (0 - 0))) then
					if (v103.CastTargetIf(v99.EarthShock, v111, "min", v123, nil, not v16:IsSpellInRange(v99.EarthShock), nil, nil) or ((4955 - (772 + 1045)) < (141 + 852))) then
						return "earth_shock aoe 58";
					end
					if (((3474 - (102 + 42)) > (4167 - (1524 + 320))) and v24(v99.EarthShock, not v16:IsSpellInRange(v99.EarthShock))) then
						return "earth_shock aoe 58";
					end
					break;
				end
			end
		end
		if ((v125(v99.EarthShock) and v38 and v99.EchoesofGreatSundering:IsAvailable()) or ((4896 - (1049 + 221)) == (4145 - (18 + 138)))) then
			if (v24(v99.EarthShock, not v16:IsSpellInRange(v99.EarthShock)) or ((2242 - 1326) == (3773 - (67 + 1035)))) then
				return "earth_shock aoe 60";
			end
		end
		if (((620 - (136 + 212)) == (1155 - 883)) and v125(v99.Icefury) and (v99.Icefury:CooldownRemains() == (0 + 0)) and v42 and not v13:BuffUp(v99.AscendanceBuff) and v99.ElectrifiedShocks:IsAvailable() and ((v99.LightningRod:IsAvailable() and (v113 < (5 + 0)) and not v126()) or (v99.DeeplyRootedElements:IsAvailable() and (v113 == (1607 - (240 + 1364)))))) then
			if (((5331 - (1050 + 32)) <= (17277 - 12438)) and v24(v99.Icefury, not v16:IsSpellInRange(v99.Icefury))) then
				return "icefury aoe 62";
			end
		end
		if (((1643 + 1134) < (4255 - (331 + 724))) and v125(v99.FrostShock) and v41 and not v13:BuffUp(v99.AscendanceBuff) and v13:BuffUp(v99.IcefuryBuff) and v99.ElectrifiedShocks:IsAvailable() and (not v16:DebuffUp(v99.ElectrifiedShocksDebuff) or (v13:BuffRemains(v99.IcefuryBuff) < v13:GCD())) and ((v99.LightningRod:IsAvailable() and (v113 < (1 + 4)) and not v126()) or (v99.DeeplyRootedElements:IsAvailable() and (v113 == (647 - (269 + 375)))))) then
			if (((820 - (267 + 458)) < (609 + 1348)) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
				return "frost_shock aoe 64";
			end
		end
		if (((1588 - 762) < (2535 - (667 + 151))) and v125(v99.LavaBurst) and v99.MasteroftheElements:IsAvailable() and not v126() and (v128() or ((v117() < (1500 - (1410 + 87))) and v13:HasTier(1927 - (1504 + 393), 5 - 3))) and (v124() < ((((155 - 95) - ((801 - (461 + 335)) * v99.EyeoftheStorm:TalentRank())) - ((1 + 1) * v25(v99.FlowofPower:IsAvailable()))) - (1771 - (1730 + 31)))) and (v113 < (1672 - (728 + 939)))) then
			if (((5050 - 3624) >= (2241 - 1136)) and v103.CastCycle(v99.LavaBurst, v111, v121, not v16:IsSpellInRange(v99.LavaBurst))) then
				return "lava_burst aoe 66";
			end
			if (((6310 - 3556) <= (4447 - (138 + 930))) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
				return "lava_burst aoe 66";
			end
		end
		if ((v125(v99.LavaBeam) and v43 and (v128())) or ((3589 + 338) == (1105 + 308))) then
			if (v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam)) or ((990 + 164) <= (3217 - 2429))) then
				return "lava_beam aoe 68";
			end
		end
		if ((v125(v99.ChainLightning) and v36 and (v128())) or ((3409 - (459 + 1307)) > (5249 - (474 + 1396)))) then
			if (v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning)) or ((4894 - 2091) > (4264 + 285))) then
				return "chain_lightning aoe 70";
			end
		end
		if ((v125(v99.LavaBeam) and v43 and v127() and (v13:BuffRemains(v99.AscendanceBuff) > v99.LavaBeam:CastTime())) or ((1 + 219) >= (8656 - 5634))) then
			if (((358 + 2464) == (9420 - 6598)) and v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam))) then
				return "lava_beam aoe 72";
			end
		end
		if ((v125(v99.ChainLightning) and v36 and v127()) or ((4627 - 3566) == (2448 - (562 + 29)))) then
			if (((2353 + 407) > (2783 - (374 + 1045))) and v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning))) then
				return "chain_lightning aoe 74";
			end
		end
		if ((v125(v99.LavaBeam) and v43 and (v113 >= (5 + 1)) and v13:BuffUp(v99.SurgeofPowerBuff) and (v13:BuffRemains(v99.AscendanceBuff) > v99.LavaBeam:CastTime())) or ((15221 - 10319) <= (4233 - (448 + 190)))) then
			if (v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam)) or ((1244 + 2608) == (133 + 160))) then
				return "lava_beam aoe 76";
			end
		end
		if ((v125(v99.ChainLightning) and v36 and (v113 >= (4 + 2)) and v13:BuffUp(v99.SurgeofPowerBuff)) or ((5994 - 4435) == (14256 - 9668))) then
			if (v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning)) or ((5978 - (1307 + 187)) == (3124 - 2336))) then
				return "chain_lightning aoe 78";
			end
		end
		if (((10695 - 6127) >= (11979 - 8072)) and v125(v99.LavaBurst) and v13:BuffUp(v99.LavaSurgeBuff) and v99.DeeplyRootedElements:IsAvailable() and v13:BuffUp(v99.WindspeakersLavaResurgenceBuff)) then
			local v222 = 683 - (232 + 451);
			while true do
				if (((1190 + 56) < (3066 + 404)) and ((564 - (510 + 54)) == v222)) then
					if (((8195 - 4127) >= (1008 - (13 + 23))) and v103.CastCycle(v99.LavaBurst, v111, v121, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst aoe 80";
					end
					if (((960 - 467) < (5593 - 1700)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst aoe 80";
					end
					break;
				end
			end
		end
		if ((v125(v99.LavaBeam) and v43 and v126() and (v13:BuffRemains(v99.AscendanceBuff) > v99.LavaBeam:CastTime())) or ((2675 - 1202) >= (4420 - (830 + 258)))) then
			if (v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam)) or ((14290 - 10239) <= (724 + 433))) then
				return "lava_beam aoe 82";
			end
		end
		if (((514 + 90) < (4322 - (860 + 581))) and v125(v99.LavaBurst) and (v113 == (10 - 7)) and v99.MasteroftheElements:IsAvailable()) then
			local v223 = 0 + 0;
			while true do
				if ((v223 == (241 - (237 + 4))) or ((2115 - 1215) == (8543 - 5166))) then
					if (((8453 - 3994) > (484 + 107)) and v103.CastCycle(v99.LavaBurst, v111, v121, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst aoe 84";
					end
					if (((1952 + 1446) >= (9042 - 6647)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst aoe 84";
					end
					break;
				end
			end
		end
		if ((v125(v99.LavaBurst) and v13:BuffUp(v99.LavaSurgeBuff) and v99.DeeplyRootedElements:IsAvailable()) or ((937 + 1246) >= (1537 + 1287))) then
			if (((3362 - (85 + 1341)) == (3303 - 1367)) and v103.CastCycle(v99.LavaBurst, v111, v121, not v16:IsSpellInRange(v99.LavaBurst))) then
				return "lava_burst aoe 86";
			end
			if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((13646 - 8814) < (4685 - (45 + 327)))) then
				return "lava_burst aoe 86";
			end
		end
		if (((7714 - 3626) > (4376 - (444 + 58))) and v125(v99.Icefury) and (v99.Icefury:CooldownRemains() == (0 + 0)) and v42 and v99.ElectrifiedShocks:IsAvailable() and (v113 < (1 + 4))) then
			if (((2118 + 2214) == (12553 - 8221)) and v24(v99.Icefury, not v16:IsSpellInRange(v99.Icefury))) then
				return "icefury aoe 88";
			end
		end
		if (((5731 - (64 + 1668)) >= (4873 - (1227 + 746))) and v125(v99.FrostShock) and v41 and v13:BuffUp(v99.IcefuryBuff) and v99.ElectrifiedShocks:IsAvailable() and not v16:DebuffUp(v99.ElectrifiedShocksDebuff) and (v113 < (15 - 10)) and v99.UnrelentingCalamity:IsAvailable()) then
			if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((4686 - 2161) > (4558 - (415 + 79)))) then
				return "frost_shock aoe 90";
			end
		end
		if (((113 + 4258) == (4862 - (142 + 349))) and v125(v99.LavaBeam) and v43 and (v13:BuffRemains(v99.AscendanceBuff) > v99.LavaBeam:CastTime())) then
			if (v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam)) or ((114 + 152) > (6854 - 1868))) then
				return "lava_beam aoe 92";
			end
		end
		if (((990 + 1001) >= (652 + 273)) and v125(v99.ChainLightning) and v36) then
			if (((1238 - 783) < (3917 - (1710 + 154))) and v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning))) then
				return "chain_lightning aoe 94";
			end
		end
		if ((v99.FlameShock:IsCastable() and v40 and v13:IsMoving() and v16:DebuffRefreshable(v99.FlameShockDebuff)) or ((1144 - (200 + 118)) == (1923 + 2928))) then
			if (((319 - 136) == (271 - 88)) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
				return "flame_shock aoe 96";
			end
		end
		if (((1030 + 129) <= (1769 + 19)) and v99.FrostShock:IsCastable() and v41 and v13:IsMoving()) then
			if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((1883 + 1624) > (690 + 3628))) then
				return "frost_shock aoe 98";
			end
		end
	end
	local function v136()
		if ((v99.FireElemental:IsCastable() and v53 and ((v59 and v33) or not v59) and (v90 < v107)) or ((6662 - 3587) <= (4215 - (363 + 887)))) then
			if (((2383 - 1018) <= (9572 - 7561)) and v24(v99.FireElemental)) then
				return "fire_elemental single_target 2";
			end
		end
		if ((v99.StormElemental:IsCastable() and v55 and ((v60 and v33) or not v60) and (v90 < v107)) or ((429 + 2347) > (8364 - 4789))) then
			if (v24(v99.StormElemental) or ((1746 + 808) == (6468 - (674 + 990)))) then
				return "storm_elemental single_target 4";
			end
		end
		if (((739 + 1838) == (1055 + 1522)) and v99.TotemicRecall:IsCastable() and v49 and (v99.LiquidMagmaTotem:CooldownRemains() > (70 - 25)) and ((v99.LavaSurge:IsAvailable() and v99.SplinteredElements:IsAvailable()) or ((v112 > (1056 - (507 + 548))) and (v113 > (838 - (289 + 548)))))) then
			if (v24(v99.TotemicRecall) or ((1824 - (821 + 997)) >= (2144 - (195 + 60)))) then
				return "totemic_recall single_target 6";
			end
		end
		if (((137 + 369) <= (3393 - (251 + 1250))) and v99.LiquidMagmaTotem:IsCastable() and v54 and ((v61 and v33) or not v61) and (v90 < v107) and ((v99.LavaSurge:IsAvailable() and v99.SplinteredElements:IsAvailable()) or (v99.FlameShockDebuff:AuraActiveCount() == (0 - 0)) or (v16:DebuffRemains(v99.FlameShockDebuff) < (5 + 1)) or ((v112 > (1033 - (809 + 223))) and (v113 > (1 - 0))))) then
			local v224 = 0 - 0;
			while true do
				if ((v224 == (0 - 0)) or ((1479 + 529) > (1162 + 1056))) then
					if (((996 - (14 + 603)) <= (4276 - (118 + 11))) and (v66 == "cursor")) then
						if (v24(v101.LiquidMagmaTotemCursor, not v16:IsInRange(7 + 33)) or ((3760 + 754) <= (2940 - 1931))) then
							return "liquid_magma_totem single_target cursor 8";
						end
					end
					if ((v66 == "player") or ((4445 - (551 + 398)) == (754 + 438))) then
						if (v24(v101.LiquidMagmaTotemPlayer, not v16:IsInRange(15 + 25)) or ((170 + 38) == (11004 - 8045))) then
							return "liquid_magma_totem single_target player 8";
						end
					end
					break;
				end
			end
		end
		if (((9854 - 5577) >= (426 + 887)) and v125(v99.PrimordialWave) and v99.PrimordialWave:IsCastable() and v47 and ((v64 and v34) or not v64) and not v13:BuffUp(v99.PrimordialWaveBuff) and not v13:BuffUp(v99.SplinteredElementsBuff)) then
			if (((10269 - 7682) < (877 + 2297)) and v103.CastCycle(v99.PrimordialWave, v111, v121, not v16:IsSpellInRange(v99.PrimordialWave))) then
				return "primordial_wave single_target 10";
			end
			if (v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave)) or ((4209 - (40 + 49)) <= (8370 - 6172))) then
				return "primordial_wave single_target 10";
			end
		end
		if ((v99.FlameShock:IsCastable() and v40 and (v112 == (491 - (99 + 391))) and v16:DebuffRefreshable(v99.FlameShockDebuff) and ((v16:DebuffRemains(v99.FlameShockDebuff) < v99.PrimordialWave:CooldownRemains()) or not v99.PrimordialWave:IsAvailable()) and v13:BuffDown(v99.SurgeofPowerBuff) and (not v126() or (not v128() and ((v99.ElementalBlast:IsAvailable() and (v124() < ((75 + 15) - ((35 - 27) * v99.EyeoftheStorm:TalentRank())))) or (v124() < ((148 - 88) - ((5 + 0) * v99.EyeoftheStorm:TalentRank()))))))) or ((4199 - 2603) == (2462 - (1032 + 572)))) then
			if (((3637 - (203 + 214)) == (5037 - (568 + 1249))) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
				return "flame_shock single_target 12";
			end
		end
		if ((v99.FlameShock:IsCastable() and v40 and (v99.FlameShockDebuff:AuraActiveCount() == (0 + 0)) and (v112 > (2 - 1)) and (v113 > (3 - 2)) and (v99.DeeplyRootedElements:IsAvailable() or v99.Ascendance:IsAvailable() or v99.PrimordialWave:IsAvailable() or v99.SearingFlames:IsAvailable() or v99.MagmaChamber:IsAvailable()) and ((not v126() and (v128() or (v99.Stormkeeper:CooldownRemains() > (1306 - (913 + 393))))) or not v99.SurgeofPower:IsAvailable())) or ((3959 - 2557) > (5115 - 1495))) then
			local v225 = 410 - (269 + 141);
			while true do
				if (((5724 - 3150) == (4555 - (362 + 1619))) and (v225 == (1625 - (950 + 675)))) then
					if (((694 + 1104) < (3936 - (216 + 963))) and v103.CastTargetIf(v99.FlameShock, v111, "min", v121, nil, not v16:IsSpellInRange(v99.FlameShock))) then
						return "flame_shock single_target 14";
					end
					if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((1664 - (485 + 802)) > (3163 - (432 + 127)))) then
						return "flame_shock single_target 14";
					end
					break;
				end
			end
		end
		if (((1641 - (1065 + 8)) < (507 + 404)) and v99.FlameShock:IsCastable() and v40 and (v112 > (1602 - (635 + 966))) and (v113 > (1 + 0)) and (v99.DeeplyRootedElements:IsAvailable() or v99.Ascendance:IsAvailable() or v99.PrimordialWave:IsAvailable() or v99.SearingFlames:IsAvailable() or v99.MagmaChamber:IsAvailable()) and ((v13:BuffUp(v99.SurgeofPowerBuff) and not v128() and v99.Stormkeeper:IsAvailable()) or not v99.SurgeofPower:IsAvailable())) then
			local v226 = 42 - (5 + 37);
			while true do
				if (((8170 - 4885) < (1760 + 2468)) and (v226 == (0 - 0))) then
					if (((1833 + 2083) > (6915 - 3587)) and v103.CastTargetIf(v99.FlameShock, v111, "min", v121, v118, not v16:IsSpellInRange(v99.FlameShock))) then
						return "flame_shock single_target 16";
					end
					if (((9478 - 6978) < (7239 - 3400)) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
						return "flame_shock single_target 16";
					end
					break;
				end
			end
		end
		if (((1211 - 704) == (365 + 142)) and v125(v99.Stormkeeper) and (v99.Stormkeeper:CooldownRemains() == (529 - (318 + 211))) and not v13:BuffUp(v99.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v107) and v13:BuffDown(v99.AscendanceBuff) and not v128() and (v124() >= (570 - 454)) and v99.ElementalBlast:IsAvailable() and v99.SurgeofPower:IsAvailable() and v99.SwellingMaelstrom:IsAvailable() and not v99.LavaSurge:IsAvailable() and not v99.EchooftheElements:IsAvailable() and not v99.PrimordialSurge:IsAvailable()) then
			if (((1827 - (963 + 624)) <= (1353 + 1812)) and v24(v99.Stormkeeper)) then
				return "stormkeeper single_target 18";
			end
		end
		if (((1680 - (518 + 328)) >= (1876 - 1071)) and v125(v99.Stormkeeper) and (v99.Stormkeeper:CooldownRemains() == (0 - 0)) and not v13:BuffUp(v99.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v107) and v13:BuffDown(v99.AscendanceBuff) and not v128() and v13:BuffUp(v99.SurgeofPowerBuff) and not v99.LavaSurge:IsAvailable() and not v99.EchooftheElements:IsAvailable() and not v99.PrimordialSurge:IsAvailable()) then
			if (v24(v99.Stormkeeper) or ((4129 - (301 + 16)) < (6787 - 4471))) then
				return "stormkeeper single_target 20";
			end
		end
		if ((v125(v99.Stormkeeper) and (v99.Stormkeeper:CooldownRemains() == (0 - 0)) and not v13:BuffUp(v99.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v107) and v13:BuffDown(v99.AscendanceBuff) and not v128() and (not v99.SurgeofPower:IsAvailable() or not v99.ElementalBlast:IsAvailable() or v99.LavaSurge:IsAvailable() or v99.EchooftheElements:IsAvailable() or v99.PrimordialSurge:IsAvailable())) or ((6919 - 4267) <= (1389 + 144))) then
			if (v24(v99.Stormkeeper) or ((2043 + 1555) < (3117 - 1657))) then
				return "stormkeeper single_target 22";
			end
		end
		if ((v99.Ascendance:IsCastable() and v52 and ((v58 and v33) or not v58) and (v90 < v107) and not v128()) or ((2477 + 1639) < (114 + 1078))) then
			if (v24(v99.Ascendance) or ((10736 - 7359) <= (292 + 611))) then
				return "ascendance single_target 24";
			end
		end
		if (((4995 - (829 + 190)) >= (1566 - 1127)) and v125(v99.LightningBolt) and v99.LightningBolt:IsCastable() and v45 and v128() and v13:BuffUp(v99.SurgeofPowerBuff)) then
			if (((4747 - 995) == (5186 - 1434)) and v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt))) then
				return "lightning_bolt single_target 26";
			end
		end
		if (((10050 - 6004) > (639 + 2056)) and v125(v99.LavaBeam) and v43 and (v112 > (1 + 0)) and (v113 > (2 - 1)) and v128() and not v99.SurgeofPower:IsAvailable()) then
			if (v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam)) or ((3345 + 200) == (3810 - (520 + 93)))) then
				return "lava_beam single_target 28";
			end
		end
		if (((2670 - (259 + 17)) > (22 + 351)) and v125(v99.ChainLightning) and v99.ChainLightning:IsCastable() and v36 and (v112 > (1 + 0)) and (v113 > (3 - 2)) and v128() and not v99.SurgeofPower:IsAvailable()) then
			if (((4746 - (396 + 195)) <= (12278 - 8046)) and v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning))) then
				return "chain_lightning single_target 30";
			end
		end
		if ((v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and v128() and not v126() and not v99.SurgeofPower:IsAvailable() and v99.MasteroftheElements:IsAvailable()) or ((5342 - (440 + 1321)) == (5302 - (1059 + 770)))) then
			if (((23097 - 18102) > (3893 - (424 + 121))) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
				return "lava_burst single_target 32";
			end
		end
		if ((v125(v99.LightningBolt) and v99.LightningBolt:IsCastable() and v45 and v128() and not v99.SurgeofPower:IsAvailable() and v126()) or ((138 + 616) > (5071 - (641 + 706)))) then
			if (((86 + 131) >= (497 - (249 + 191))) and v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt))) then
				return "lightning_bolt single_target 34";
			end
		end
		if ((v125(v99.LightningBolt) and v99.LightningBolt:IsCastable() and v45 and v128() and not v99.SurgeofPower:IsAvailable() and not v99.MasteroftheElements:IsAvailable()) or ((9017 - 6947) >= (1803 + 2234))) then
			if (((10425 - 7720) == (3132 - (183 + 244))) and v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt))) then
				return "lightning_bolt single_target 36";
			end
		end
		if (((3 + 58) == (791 - (434 + 296))) and v125(v99.LightningBolt) and v99.LightningBolt:IsCastable() and v45 and v13:BuffUp(v99.SurgeofPowerBuff) and v99.LightningRod:IsAvailable()) then
			if (v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt)) or ((2230 - 1531) >= (1808 - (169 + 343)))) then
				return "lightning_bolt single_target 38";
			end
		end
		if ((v125(v99.Icefury) and (v99.Icefury:CooldownRemains() == (0 + 0)) and v42 and v99.ElectrifiedShocks:IsAvailable() and v99.LightningRod:IsAvailable() and v99.LightningRod:IsAvailable()) or ((3136 - 1353) >= (10613 - 6997))) then
			if (v24(v99.Icefury, not v16:IsSpellInRange(v99.Icefury)) or ((3206 + 707) > (12838 - 8311))) then
				return "icefury single_target 40";
			end
		end
		if (((5499 - (651 + 472)) > (618 + 199)) and v99.FrostShock:IsCastable() and v41 and v129() and v99.ElectrifiedShocks:IsAvailable() and ((v16:DebuffRemains(v99.ElectrifiedShocksDebuff) < (1 + 1)) or (v13:BuffRemains(v99.IcefuryBuff) <= v13:GCD())) and v99.LightningRod:IsAvailable()) then
			if (((5932 - 1071) > (1307 - (397 + 86))) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
				return "frost_shock single_target 42";
			end
		end
		if ((v99.FrostShock:IsCastable() and v41 and v129() and v99.ElectrifiedShocks:IsAvailable() and (v124() >= (926 - (423 + 453))) and (v16:DebuffRemains(v99.ElectrifiedShocksDebuff) < ((1 + 1) * v13:GCD())) and v128() and v99.LightningRod:IsAvailable()) or ((183 + 1200) >= (1861 + 270))) then
			if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((1498 + 378) >= (2270 + 271))) then
				return "frost_shock single_target 44";
			end
		end
		if (((2972 - (50 + 1140)) <= (3261 + 511)) and v99.LavaBeam:IsCastable() and v43 and (v112 > (1 + 0)) and (v113 > (1 + 0)) and v127() and (v13:BuffRemains(v99.AscendanceBuff) > v99.LavaBeam:CastTime()) and not v13:HasTier(44 - 13, 3 + 1)) then
			if (v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam)) or ((5296 - (157 + 439)) < (1412 - 599))) then
				return "lava_beam single_target 46";
			end
		end
		if (((10629 - 7430) < (11979 - 7929)) and v99.FrostShock:IsCastable() and v41 and v129() and v128() and not v99.LavaSurge:IsAvailable() and not v99.EchooftheElements:IsAvailable() and not v99.PrimordialSurge:IsAvailable() and v99.ElementalBlast:IsAvailable() and (((v124() >= (979 - (782 + 136))) and (v124() < (930 - (112 + 743))) and (v99.LavaBurst:CooldownRemains() > v13:GCD())) or ((v124() >= (1220 - (1026 + 145))) and (v124() < (11 + 52)) and (v99.LavaBurst:CooldownRemains() > (718 - (493 + 225)))))) then
			if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((18198 - 13247) < (2695 + 1735))) then
				return "frost_shock single_target 48";
			end
		end
		if (((257 - 161) == (2 + 94)) and v99.FrostShock:IsCastable() and v41 and v129() and not v99.LavaSurge:IsAvailable() and not v99.EchooftheElements:IsAvailable() and not v99.ElementalBlast:IsAvailable() and (((v124() >= (102 - 66)) and (v124() < (15 + 35)) and (v99.LavaBurst:CooldownRemains() > v13:GCD())) or ((v124() >= (39 - 15)) and (v124() < (1633 - (210 + 1385))) and (v99.LavaBurst:CooldownRemains() > (1689 - (1201 + 488)))))) then
			if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((1698 + 1041) > (7128 - 3120))) then
				return "frost_shock single_target 50";
			end
		end
		if ((v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and v13:BuffUp(v99.WindspeakersLavaResurgenceBuff) and (v99.EchooftheElements:IsAvailable() or v99.LavaSurge:IsAvailable() or v99.PrimordialSurge:IsAvailable() or ((v124() >= (112 - 49)) and v99.MasteroftheElements:IsAvailable()) or ((v124() >= (623 - (352 + 233))) and v13:BuffUp(v99.EchoesofGreatSunderingBuff) and (v112 > (2 - 1)) and (v113 > (1 + 0))) or not v99.ElementalBlast:IsAvailable())) or ((65 - 42) == (1708 - (489 + 85)))) then
			if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((4194 - (277 + 1224)) >= (5604 - (663 + 830)))) then
				return "lava_burst single_target 52";
			end
		end
		if ((v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and v13:BuffUp(v99.LavaSurgeBuff) and (v99.EchooftheElements:IsAvailable() or v99.LavaSurge:IsAvailable() or v99.PrimordialSurge:IsAvailable() or not v99.MasteroftheElements:IsAvailable() or not v99.ElementalBlast:IsAvailable())) or ((3792 + 524) <= (5254 - 3108))) then
			if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((4421 - (461 + 414)) <= (471 + 2338))) then
				return "lava_burst single_target 54";
			end
		end
		if (((1963 + 2941) > (207 + 1959)) and v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and v13:BuffUp(v99.AscendanceBuff) and (v13:HasTier(31 + 0, 254 - (172 + 78)) or not v99.ElementalBlast:IsAvailable())) then
			local v227 = 0 - 0;
			while true do
				if (((41 + 68) >= (129 - 39)) and ((0 + 0) == v227)) then
					if (((1663 + 3315) > (4867 - 1962)) and v103.CastCycle(v99.LavaBurst, v111, v122, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst single_target 56";
					end
					if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((3808 - 782) <= (574 + 1706))) then
						return "lava_burst single_target 56";
					end
					break;
				end
			end
		end
		if ((v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and v13:BuffDown(v99.AscendanceBuff) and (not v99.ElementalBlast:IsAvailable() or not v99.MountainsWillFall:IsAvailable()) and not v99.LightningRod:IsAvailable() and v13:HasTier(18 + 13, 2 + 2)) or ((6580 - 4927) <= (2581 - 1473))) then
			local v228 = 0 + 0;
			while true do
				if (((1661 + 1248) > (3056 - (133 + 314))) and (v228 == (0 + 0))) then
					if (((970 - (199 + 14)) > (694 - 500)) and v103.CastCycle(v99.LavaBurst, v111, v122, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst single_target 58";
					end
					if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((1580 - (647 + 902)) >= (4203 - 2805))) then
						return "lava_burst single_target 58";
					end
					break;
				end
			end
		end
		if (((3429 - (85 + 148)) <= (6161 - (426 + 863))) and v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and v99.MasteroftheElements:IsAvailable() and not v126() and not v99.LightningRod:IsAvailable()) then
			local v229 = 0 - 0;
			while true do
				if (((4980 - (873 + 781)) == (4453 - 1127)) and (v229 == (0 - 0))) then
					if (((594 + 839) <= (14326 - 10448)) and v103.CastCycle(v99.LavaBurst, v111, v122, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst single_target 60";
					end
					if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((2267 - 684) == (5151 - 3416))) then
						return "lava_burst single_target 60";
					end
					break;
				end
			end
		end
		if ((v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and v99.MasteroftheElements:IsAvailable() and not v126() and ((v124() >= (2022 - (414 + 1533))) or ((v124() >= (44 + 6)) and not v99.ElementalBlast:IsAvailable())) and v99.SwellingMaelstrom:IsAvailable() and (v124() <= (685 - (443 + 112)))) or ((4460 - (888 + 591)) == (6072 - 3722))) then
			if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((255 + 4211) <= (1856 - 1363))) then
				return "lava_burst single_target 62";
			end
		end
		if ((v99.Earthquake:IsReady() and v37 and v13:BuffUp(v99.EchoesofGreatSunderingBuff) and ((not v99.ElementalBlast:IsAvailable() and (v112 < (1 + 1))) or (v112 > (1 + 0)))) or ((273 + 2274) <= (3785 - 1798))) then
			local v230 = 0 - 0;
			while true do
				if (((4639 - (136 + 1542)) > (8985 - 6245)) and (v230 == (0 + 0))) then
					if (((5876 - 2180) >= (2615 + 997)) and (v51 == "cursor")) then
						if (v24(v101.EarthquakeCursor, not v16:IsInRange(526 - (68 + 418))) or ((8051 - 5081) == (3407 - 1529))) then
							return "earthquake single_target 64";
						end
					end
					if ((v51 == "player") or ((3188 + 505) < (3069 - (770 + 322)))) then
						if (v24(v101.EarthquakePlayer, not v16:IsInRange(3 + 37)) or ((269 + 661) > (287 + 1814))) then
							return "earthquake single_target 64";
						end
					end
					break;
				end
			end
		end
		if (((5941 - 1788) > (5983 - 2897)) and v99.Earthquake:IsReady() and v37 and (v112 > (2 - 1)) and (v113 > (3 - 2)) and not v99.EchoesofGreatSundering:IsAvailable() and not v99.ElementalBlast:IsAvailable()) then
			local v231 = 0 + 0;
			while true do
				if ((v231 == (0 - 0)) or ((2233 + 2421) <= (2483 + 1567))) then
					if ((v51 == "cursor") or ((2040 + 562) < (5633 - 4137))) then
						if (v24(v101.EarthquakeCursor, not v16:IsInRange(55 - 15)) or ((345 + 675) > (10539 - 8251))) then
							return "earthquake single_target 66";
						end
					end
					if (((1084 - 756) == (135 + 193)) and (v51 == "player")) then
						if (((7476 - 5965) < (4639 - (762 + 69))) and v24(v101.EarthquakePlayer, not v16:IsInRange(129 - 89))) then
							return "earthquake single_target 66";
						end
					end
					break;
				end
			end
		end
		if ((v125(v99.ElementalBlast) and v99.ElementalBlast:IsCastable() and v39 and (not v99.MasteroftheElements:IsAvailable() or (v126() and v16:DebuffUp(v99.ElectrifiedShocksDebuff)))) or ((2163 + 347) > (3185 + 1734))) then
			if (((11520 - 6757) == (1499 + 3264)) and v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast))) then
				return "elemental_blast single_target 68";
			end
		end
		if (((66 + 4071) > (7200 - 5352)) and v125(v99.FrostShock) and v41 and v129() and v126() and (v124() < (267 - (8 + 149))) and (v99.LavaBurst:ChargesFractional() < (1321 - (1199 + 121))) and v99.ElectrifiedShocks:IsAvailable() and v99.ElementalBlast:IsAvailable() and not v99.LightningRod:IsAvailable()) then
			if (((4121 - 1685) <= (7075 - 3941)) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
				return "frost_shock single_target 70";
			end
		end
		if (((1533 + 2190) == (13288 - 9565)) and v125(v99.ElementalBlast) and v99.ElementalBlast:IsCastable() and v39 and (v126() or v99.LightningRod:IsAvailable())) then
			if (v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast)) or ((9388 - 5342) >= (3819 + 497))) then
				return "elemental_blast single_target 72";
			end
		end
		if ((v99.EarthShock:IsReady() and v38) or ((3815 - (518 + 1289)) < (3307 - 1378))) then
			if (((317 + 2067) > (2591 - 816)) and v24(v99.EarthShock, not v16:IsSpellInRange(v99.EarthShock))) then
				return "earth_shock single_target 74";
			end
		end
		if ((v125(v99.FrostShock) and v41 and v129() and v99.ElectrifiedShocks:IsAvailable() and v126() and not v99.LightningRod:IsAvailable() and (v112 > (1 + 0)) and (v113 > (470 - (304 + 165)))) or ((4289 + 254) <= (4536 - (54 + 106)))) then
			if (((2697 - (1618 + 351)) == (514 + 214)) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
				return "frost_shock single_target 76";
			end
		end
		if ((v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and (v99.DeeplyRootedElements:IsAvailable())) or ((2092 - (10 + 1006)) > (1173 + 3498))) then
			local v232 = 0 + 0;
			while true do
				if (((6000 - 4149) >= (1411 - (912 + 121))) and (v232 == (0 + 0))) then
					if (v103.CastCycle(v99.LavaBurst, v111, v122, not v16:IsSpellInRange(v99.LavaBurst)) or ((3237 - (1140 + 149)) >= (2225 + 1251))) then
						return "lava_burst single_target 78";
					end
					if (((6389 - 1595) >= (155 + 678)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst single_target 78";
					end
					break;
				end
			end
		end
		if (((13997 - 9907) == (7670 - 3580)) and v99.FrostShock:IsCastable() and v41 and v129() and v99.FluxMelting:IsAvailable() and v13:BuffDown(v99.FluxMeltingBuff)) then
			if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((649 + 3109) == (8668 - 6170))) then
				return "frost_shock single_target 80";
			end
		end
		if ((v99.FrostShock:IsCastable() and v41 and v129() and ((v99.ElectrifiedShocks:IsAvailable() and (v16:DebuffRemains(v99.ElectrifiedShocksDebuff) < (188 - (165 + 21)))) or (v13:BuffRemains(v99.IcefuryBuff) < (117 - (61 + 50))))) or ((1102 + 1571) < (7507 - 5932))) then
			if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((7497 - 3776) <= (572 + 883))) then
				return "frost_shock single_target 82";
			end
		end
		if (((2394 - (1295 + 165)) < (518 + 1752)) and v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and (v99.EchooftheElements:IsAvailable() or v99.LavaSurge:IsAvailable() or v99.PrimordialSurge:IsAvailable() or not v99.ElementalBlast:IsAvailable() or not v99.MasteroftheElements:IsAvailable() or v128())) then
			local v233 = 0 + 0;
			while true do
				if ((v233 == (1397 - (819 + 578))) or ((3014 - (331 + 1071)) == (1998 - (588 + 155)))) then
					if (v103.CastCycle(v99.LavaBurst, v111, v122, not v16:IsSpellInRange(v99.LavaBurst)) or ((5634 - (546 + 736)) < (6143 - (1834 + 103)))) then
						return "lava_burst single_target 84";
					end
					if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((1760 + 1100) <= (539 - 358))) then
						return "lava_burst single_target 84";
					end
					break;
				end
			end
		end
		if (((4988 - (1536 + 230)) >= (2018 - (128 + 363))) and v125(v99.ElementalBlast) and v99.ElementalBlast:IsCastable() and v39) then
			if (((320 + 1185) <= (5276 - 3155)) and v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast))) then
				return "elemental_blast single_target 86";
			end
		end
		if (((193 + 551) == (1232 - 488)) and v125(v99.ChainLightning) and v99.ChainLightning:IsCastable() and v36 and v127() and v99.UnrelentingCalamity:IsAvailable() and (v112 > (2 - 1)) and (v113 > (2 - 1))) then
			if (v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning)) or ((1359 + 620) >= (3845 - (615 + 394)))) then
				return "chain_lightning single_target 88";
			end
		end
		if (((1655 + 178) <= (2543 + 125)) and v125(v99.LightningBolt) and v99.LightningBolt:IsCastable() and v45 and v127() and v99.UnrelentingCalamity:IsAvailable()) then
			if (((11236 - 7550) == (16718 - 13032)) and v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt))) then
				return "lightning_bolt single_target 90";
			end
		end
		if (((4118 - (59 + 592)) > (1055 - 578)) and v125(v99.Icefury) and v99.Icefury:IsCastable() and v42) then
			if (v24(v99.Icefury, not v16:IsSpellInRange(v99.Icefury)) or ((6054 - 2766) >= (2496 + 1045))) then
				return "icefury single_target 92";
			end
		end
		if ((v125(v99.ChainLightning) and v99.ChainLightning:IsCastable() and v36 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v99.LightningRodDebuff) and (v16:DebuffUp(v99.ElectrifiedShocksDebuff) or v127()) and (v112 > (172 - (70 + 101))) and (v113 > (2 - 1))) or ((2523 + 1034) == (11402 - 6862))) then
			if (v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning)) or ((502 - (123 + 118)) > (307 + 960))) then
				return "chain_lightning single_target 94";
			end
		end
		if (((16 + 1256) < (5257 - (653 + 746))) and v125(v99.LightningBolt) and v99.LightningBolt:IsCastable() and v45 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v99.LightningRodDebuff) and (v16:DebuffUp(v99.ElectrifiedShocksDebuff) or v127())) then
			if (((6852 - 3188) == (5278 - 1614)) and v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt))) then
				return "lightning_bolt single_target 96";
			end
		end
		if (((5196 - 3255) >= (199 + 251)) and v99.FrostShock:IsCastable() and v41 and v129() and v126() and v13:BuffDown(v99.LavaSurgeBuff) and not v99.ElectrifiedShocks:IsAvailable() and not v99.FluxMelting:IsAvailable() and (v99.LavaBurst:ChargesFractional() < (1 + 0)) and v99.EchooftheElements:IsAvailable()) then
			if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((4058 + 588) < (40 + 284))) then
				return "frost_shock single_target 98";
			end
		end
		if (((599 + 3234) == (9396 - 5563)) and v99.FrostShock:IsCastable() and v41 and v129() and (v99.FluxMelting:IsAvailable() or (v99.ElectrifiedShocks:IsAvailable() and not v99.LightningRod:IsAvailable()))) then
			if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((1181 + 59) > (6226 - 2856))) then
				return "frost_shock single_target 100";
			end
		end
		if ((v125(v99.ChainLightning) and v99.ChainLightning:IsCastable() and v36 and v126() and v13:BuffDown(v99.LavaSurgeBuff) and (v99.LavaBurst:ChargesFractional() < (1235 - (885 + 349))) and v99.EchooftheElements:IsAvailable() and (v112 > (1 + 0)) and (v113 > (2 - 1))) or ((7216 - 4735) == (5650 - (915 + 53)))) then
			if (((5528 - (768 + 33)) >= (796 - 588)) and v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning))) then
				return "chain_lightning single_target 102";
			end
		end
		if (((492 - 212) < (4179 - (287 + 41))) and v125(v99.LightningBolt) and v99.LightningBolt:IsCastable() and v45 and v126() and v13:BuffDown(v99.LavaSurgeBuff) and (v99.LavaBurst:ChargesFractional() < (848 - (638 + 209))) and v99.EchooftheElements:IsAvailable()) then
			if (v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt)) or ((1563 + 1444) > (4880 - (96 + 1590)))) then
				return "lightning_bolt single_target 104";
			end
		end
		if ((v99.FrostShock:IsCastable() and v41 and v129() and not v99.ElectrifiedShocks:IsAvailable() and not v99.FluxMelting:IsAvailable()) or ((3808 - (741 + 931)) >= (1447 + 1499))) then
			if (((6168 - 4003) <= (11777 - 9256)) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
				return "frost_shock single_target 106";
			end
		end
		if (((1228 + 1633) > (285 + 376)) and v125(v99.ChainLightning) and v99.ChainLightning:IsCastable() and v36 and (v112 > (1 + 0)) and (v113 > (3 - 2))) then
			if (((1471 + 3054) > (2207 + 2312)) and v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning))) then
				return "chain_lightning single_target 108";
			end
		end
		if (((12963 - 9785) > (873 + 99)) and v125(v99.LightningBolt) and v99.LightningBolt:IsCastable() and v45) then
			if (((5260 - (64 + 430)) == (4729 + 37)) and v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt))) then
				return "lightning_bolt single_target 110";
			end
		end
		if ((v99.FlameShock:IsCastable() and v40 and (v13:IsMoving())) or ((3108 - (106 + 257)) > (2218 + 910))) then
			if (v103.CastCycle(v99.FlameShock, v111, v118, not v16:IsSpellInRange(v99.FlameShock)) or ((1865 - (496 + 225)) >= (9418 - 4812))) then
				return "flame_shock single_target 112";
			end
			if (((16260 - 12922) >= (1935 - (256 + 1402))) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
				return "flame_shock single_target 112";
			end
		end
		if (((4509 - (30 + 1869)) > (3929 - (213 + 1156))) and v99.FlameShock:IsCastable() and v40) then
			if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((1382 - (96 + 92)) > (526 + 2557))) then
				return "flame_shock single_target 114";
			end
		end
		if (((1815 - (142 + 757)) >= (609 + 138)) and v99.FrostShock:IsCastable() and v41) then
			if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((999 + 1445) > (3033 - (32 + 47)))) then
				return "frost_shock single_target 116";
			end
		end
	end
	local function v137()
		local v167 = 1977 - (1053 + 924);
		while true do
			if (((2833 + 59) < (6051 - 2537)) and (v167 == (1651 - (685 + 963)))) then
				if (((1083 - 550) == (830 - 297)) and v99.ImprovedFlametongueWeapon:IsAvailable() and v99.FlametongueWeapon:IsCastable() and v50 and (not v108 or (v109 < (601709 - (541 + 1168)))) and v99.FlametongueWeapon:IsAvailable()) then
					if (((2192 - (645 + 952)) <= (4251 - (669 + 169))) and v24(v99.FlametongueWeapon)) then
						return "flametongue_weapon enchant";
					end
				end
				if (((10662 - 7584) >= (5626 - 3035)) and not v13:AffectingCombat() and v31 and v103.TargetIsValid()) then
					local v257 = 0 + 0;
					while true do
						if (((706 + 2493) < (4795 - (181 + 584))) and (v257 == (1395 - (665 + 730)))) then
							v30 = v134();
							if (((2239 - 1462) < (4237 - 2159)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				break;
			end
			if (((3046 - (540 + 810)) <= (9123 - 6841)) and (v167 == (2 - 1))) then
				if (v30 or ((1402 + 359) >= (2665 - (166 + 37)))) then
					return v30;
				end
				if (((6432 - (22 + 1859)) > (4100 - (843 + 929))) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
					if (((4087 - (30 + 232)) >= (1333 - 866)) and v24(v99.AncestralSpirit, nil, true)) then
						return "ancestral_spirit";
					end
				end
				v167 = 779 - (55 + 722);
			end
			if ((v167 == (3 - 1)) or ((4565 - (78 + 1597)) == (123 + 434))) then
				if ((v99.AncestralSpirit:IsCastable() and v99.AncestralSpirit:IsReady() and not v13:AffectingCombat() and v14:Exists() and v14:IsDeadOrGhost() and v14:IsAPlayer() and not v13:CanAttack(v14)) or ((4340 + 430) == (2432 + 472))) then
					if (v24(v101.AncestralSpiritMouseover) or ((4452 - (305 + 244)) == (4209 + 327))) then
						return "ancestral_spirit mouseover";
					end
				end
				v108, v109 = v29();
				v167 = 108 - (95 + 10);
			end
			if (((2899 + 1194) <= (15353 - 10508)) and (v167 == (0 - 0))) then
				if (((2331 - (592 + 170)) <= (12719 - 9072)) and v73 and v99.EarthShield:IsCastable() and v13:BuffDown(v99.EarthShieldBuff) and ((v74 == "Earth Shield") or (v99.ElementalOrbit:IsAvailable() and v13:BuffUp(v99.LightningShield)))) then
					if (v24(v99.EarthShield) or ((10160 - 6114) >= (2297 + 2630))) then
						return "earth_shield main 2";
					end
				elseif (((1800 + 2823) >= (6730 - 3943)) and v73 and v99.LightningShield:IsCastable() and v13:BuffDown(v99.LightningShieldBuff) and ((v74 == "Lightning Shield") or (v99.ElementalOrbit:IsAvailable() and v13:BuffUp(v99.EarthShield)))) then
					if (((363 + 1871) >= (2279 - 1049)) and v24(v99.LightningShield)) then
						return "lightning_shield main 2";
					end
				end
				v30 = v131();
				v167 = 508 - (353 + 154);
			end
		end
	end
	local function v138()
		v30 = v132();
		if (v30 or ((455 - 112) == (2439 - 653))) then
			return v30;
		end
		if (((1774 + 796) > (1887 + 522)) and v85) then
			if (v80 or ((1722 + 887) >= (4673 - 1439))) then
				v30 = v103.HandleAfflicted(v99.CleanseSpirit, v101.CleanseSpiritMouseover, 75 - 35);
				if (v30 or ((7070 - 4037) >= (4117 - (7 + 79)))) then
					return v30;
				end
			end
			if (v81 or ((656 + 745) == (4849 - (24 + 157)))) then
				v30 = v103.HandleAfflicted(v99.TremorTotem, v99.TremorTotem, 59 - 29);
				if (((5921 - 3145) >= (376 + 945)) and v30) then
					return v30;
				end
			end
			if (v82 or ((1311 - 824) > (2683 - (262 + 118)))) then
				local v252 = 1083 - (1038 + 45);
				while true do
					if (((0 - 0) == v252) or ((4733 - (19 + 211)) == (3575 - (88 + 25)))) then
						v30 = v103.HandleAfflicted(v99.PoisonCleansingTotem, v99.PoisonCleansingTotem, 76 - 46);
						if (((275 + 278) <= (1441 + 102)) and v30) then
							return v30;
						end
						break;
					end
				end
			end
		end
		if (((3051 - (1007 + 29)) == (543 + 1472)) and v86) then
			local v234 = 0 - 0;
			while true do
				if (((0 - 0) == v234) or ((946 + 3295) <= (3143 - (340 + 471)))) then
					v30 = v103.HandleIncorporeal(v99.Hex, v101.HexMouseOver, 75 - 45, true);
					if (v30 or ((2953 - (276 + 313)) < (2824 - 1667))) then
						return v30;
					end
					break;
				end
			end
		end
		if (v17 or ((1076 + 91) > (542 + 736))) then
			if (v84 or ((108 + 1037) <= (3054 - (495 + 1477)))) then
				v30 = v130();
				if (v30 or ((9296 - 6191) == (3198 + 1683))) then
					return v30;
				end
			end
		end
		if ((v99.GreaterPurge:IsAvailable() and v96 and v99.GreaterPurge:IsReady() and v35 and v83 and not v13:IsCasting() and not v13:IsChanneling() and v103.UnitHasMagicBuff(v16)) or ((2290 - (342 + 61)) > (2134 + 2744))) then
			if (v24(v99.GreaterPurge, not v16:IsSpellInRange(v99.GreaterPurge)) or ((4252 - (4 + 161)) > (2521 + 1595))) then
				return "greater_purge damage";
			end
		end
		if (((3471 - 2365) <= (3327 - 2061)) and v99.Purge:IsReady() and v96 and v35 and v83 and not v13:IsCasting() and not v13:IsChanneling() and v103.UnitHasMagicBuff(v16)) then
			if (((3652 - (322 + 175)) < (5213 - (173 + 390))) and v24(v99.Purge, not v16:IsSpellInRange(v99.Purge))) then
				return "purge damage";
			end
		end
		if (((931 + 2843) >= (2153 - (203 + 111))) and v103.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) then
			local v235 = 0 + 0;
			local v236;
			while true do
				if (((1983 + 828) == (8203 - 5392)) and (v235 == (1 + 0))) then
					if (((2852 - (57 + 649)) > (1506 - (328 + 56))) and v99.NaturesSwiftness:IsCastable() and v46) then
						if (v24(v99.NaturesSwiftness) or ((18 + 38) == (4128 - (433 + 79)))) then
							return "natures_swiftness main 12";
						end
					end
					v236 = v103.HandleDPSPotion(v13:BuffUp(v99.AscendanceBuff));
					v235 = 1 + 1;
				end
				if ((v235 == (3 + 0)) or ((8140 - 5719) < (2941 - 2319))) then
					if (((736 + 273) <= (1007 + 123)) and true) then
						v30 = v136();
						if (((3794 - (562 + 474)) < (6952 - 3972)) and v30) then
							return v30;
						end
						if (v24(v99.Pool) or ((174 - 88) >= (4531 - (76 + 829)))) then
							return "Pool for SingleTarget()";
						end
					end
					break;
				end
				if (((4068 - (1506 + 167)) == (4499 - 2104)) and (v235 == (266 - (58 + 208)))) then
					if (((2233 + 1547) > (1931 + 778)) and (v90 < v107) and v57 and ((v63 and v33) or not v63)) then
						local v265 = 0 + 0;
						while true do
							if ((v265 == (7 - 5)) or ((574 - (258 + 79)) >= (289 + 1984))) then
								if ((v99.BagofTricks:IsCastable() and (not v99.Ascendance:IsAvailable() or v13:BuffUp(v99.AscendanceBuff))) or ((4291 - 2251) <= (2173 - (1219 + 251)))) then
									if (((4950 - (1231 + 440)) <= (4025 - (34 + 24))) and v24(v99.BagofTricks)) then
										return "bag_of_tricks main 10";
									end
								end
								break;
							end
							if ((v265 == (1 + 0)) or ((3710 - 1722) == (384 + 493))) then
								if (((13032 - 8741) > (6129 - 4217)) and v99.Fireblood:IsCastable() and (not v99.Ascendance:IsAvailable() or v13:BuffUp(v99.AscendanceBuff) or (v99.Ascendance:CooldownRemains() > (131 - 81)))) then
									if (((6710 - 4707) < (5107 - 2768)) and v24(v99.Fireblood)) then
										return "fireblood main 6";
									end
								end
								if (((2021 - (877 + 712)) == (259 + 173)) and v99.AncestralCall:IsCastable() and (not v99.Ascendance:IsAvailable() or v13:BuffUp(v99.AscendanceBuff) or (v99.Ascendance:CooldownRemains() > (804 - (242 + 512))))) then
									if (v24(v99.AncestralCall) or ((2392 - 1247) >= (1880 - (92 + 535)))) then
										return "ancestral_call main 8";
									end
								end
								v265 = 2 + 0;
							end
							if (((7040 - 3622) > (133 + 1985)) and (v265 == (0 - 0))) then
								if (((3007 + 59) <= (2694 + 1196)) and v99.BloodFury:IsCastable() and (not v99.Ascendance:IsAvailable() or v13:BuffUp(v99.AscendanceBuff) or (v99.Ascendance:CooldownRemains() > (8 + 42)))) then
									if (v24(v99.BloodFury) or ((5974 - 2976) >= (5000 - 1719))) then
										return "blood_fury main 2";
									end
								end
								if ((v99.Berserking:IsCastable() and (not v99.Ascendance:IsAvailable() or v13:BuffUp(v99.AscendanceBuff))) or ((6434 - (1476 + 309)) <= (3916 - (299 + 985)))) then
									if (v24(v99.Berserking) or ((918 + 2942) > (15970 - 11098))) then
										return "berserking main 4";
									end
								end
								v265 = 94 - (86 + 7);
							end
						end
					end
					if ((v90 < v107) or ((16338 - 12340) == (219 + 2079))) then
						if ((v56 and ((v33 and v62) or not v62)) or ((888 - (672 + 208)) >= (1174 + 1565))) then
							local v269 = 132 - (14 + 118);
							while true do
								if (((3035 - (339 + 106)) == (2061 + 529)) and (v269 == (0 + 0))) then
									v30 = v133();
									if (v30 or ((1477 - (440 + 955)) >= (1843 + 27))) then
										return v30;
									end
									break;
								end
							end
						end
					end
					v235 = 1 - 0;
				end
				if (((871 + 1753) < (11345 - 6788)) and (v235 == (2 + 0))) then
					if (v236 or ((3484 - (260 + 93)) > (3318 + 224))) then
						return v236;
					end
					if (((5894 - 3317) >= (2848 - 1270)) and v32 and (v112 > (1976 - (1181 + 793))) and (v113 > (1 + 1))) then
						local v266 = 307 - (105 + 202);
						while true do
							if (((3290 + 813) <= (5381 - (352 + 458))) and ((0 - 0) == v266)) then
								v30 = v135();
								if (v30 or ((3822 - 2327) == (4634 + 153))) then
									return v30;
								end
								v266 = 2 - 1;
							end
							if ((v266 == (950 - (438 + 511))) or ((1693 - (1262 + 121)) > (5502 - (728 + 340)))) then
								if (((3958 - (816 + 974)) <= (13356 - 8996)) and v24(v99.Pool)) then
									return "Pool for Aoe()";
								end
								break;
							end
						end
					end
					v235 = 10 - 7;
				end
			end
		end
	end
	local function v139()
		v36 = EpicSettings.Settings['useChainlightning'];
		v37 = EpicSettings.Settings['useEarthquake'];
		v38 = EpicSettings.Settings['UseEarthShock'];
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
		v52 = EpicSettings.Settings['useAscendance'];
		v54 = EpicSettings.Settings['useLiquidMagmaTotem'];
		v53 = EpicSettings.Settings['useFireElemental'];
		v55 = EpicSettings.Settings['useStormElemental'];
		v58 = EpicSettings.Settings['ascendanceWithCD'];
		v61 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
		v59 = EpicSettings.Settings['fireElementalWithCD'];
		v60 = EpicSettings.Settings['stormElementalWithCD'];
		v64 = EpicSettings.Settings['primordialWaveWithMiniCD'];
		v65 = EpicSettings.Settings['stormkeeperWithMiniCD'];
	end
	local function v140()
		v67 = EpicSettings.Settings['useWindShear'];
		v68 = EpicSettings.Settings['useCapacitorTotem'];
		v69 = EpicSettings.Settings['useThunderstorm'];
		v70 = EpicSettings.Settings['useAncestralGuidance'];
		v71 = EpicSettings.Settings['useAstralShift'];
		v72 = EpicSettings.Settings['useHealingStreamTotem'];
		v75 = EpicSettings.Settings['ancestralGuidanceHP'] or (339 - (163 + 176));
		v76 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 - 0);
		v77 = EpicSettings.Settings['astralShiftHP'] or (0 - 0);
		v78 = EpicSettings.Settings['healingStreamTotemHP'] or (0 + 0);
		v79 = EpicSettings.Settings['healingStreamTotemGroup'] or (1810 - (1564 + 246));
		v51 = EpicSettings.Settings['earthquakeSetting'] or "";
		v66 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
		v73 = EpicSettings.Settings['autoShield'];
		v74 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
		v97 = EpicSettings.Settings['healOOC'];
		v98 = EpicSettings.Settings['healOOCHP'] or (345 - (124 + 221));
		v96 = EpicSettings.Settings['usePurgeTarget'];
		v80 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
		v81 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v82 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
	end
	local function v141()
		local v205 = 0 + 0;
		while true do
			if (((1445 - (115 + 336)) == (2188 - 1194)) and ((0 + 0) == v205)) then
				v90 = EpicSettings.Settings['fightRemainsCheck'] or (46 - (45 + 1));
				v87 = EpicSettings.Settings['InterruptWithStun'];
				v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v205 = 1 + 0;
			end
			if (((3645 - (1282 + 708)) > (1613 - (583 + 629))) and (v205 == (1 + 3))) then
				v94 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v93 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v205 = 1175 - (943 + 227);
			end
			if (((1340 + 1723) <= (5057 - (1539 + 92))) and (v205 == (1947 - (706 + 1240)))) then
				v89 = EpicSettings.Settings['InterruptThreshold'];
				v84 = EpicSettings.Settings['DispelDebuffs'];
				v83 = EpicSettings.Settings['DispelBuffs'];
				v205 = 260 - (81 + 177);
			end
			if (((4121 - 2662) > (1021 - (212 + 45))) and (v205 == (6 - 4))) then
				v56 = EpicSettings.Settings['useTrinkets'];
				v57 = EpicSettings.Settings['useRacials'];
				v62 = EpicSettings.Settings['trinketsWithCD'];
				v205 = 1949 - (708 + 1238);
			end
			if ((v205 == (1 + 2)) or ((210 + 431) > (6001 - (586 + 1081)))) then
				v63 = EpicSettings.Settings['racialsWithCD'];
				v92 = EpicSettings.Settings['useHealthstone'];
				v91 = EpicSettings.Settings['useHealingPotion'];
				v205 = 515 - (348 + 163);
			end
			if (((3053 + 346) >= (2540 - (215 + 65))) and (v205 == (12 - 7))) then
				v85 = EpicSettings.Settings['handleAfflicted'];
				v86 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v142()
		v140();
		v139();
		v141();
		v31 = EpicSettings.Toggles['ooc'];
		v32 = EpicSettings.Toggles['aoe'];
		v33 = EpicSettings.Toggles['cds'];
		v35 = EpicSettings.Toggles['dispel'];
		v34 = EpicSettings.Toggles['minicds'];
		if (v13:IsDeadOrGhost() or ((2252 - (1541 + 318)) >= (3763 + 479))) then
			return v30;
		end
		v110 = v13:GetEnemiesInRange(21 + 19);
		v111 = v16:GetEnemiesInSplashRange(4 + 1);
		if (((2739 - (1036 + 714)) < (3203 + 1656)) and v32) then
			local v237 = 0 + 0;
			while true do
				if ((v237 == (1280 - (883 + 397))) or ((5385 - (563 + 27)) < (3712 - 2763))) then
					v112 = #v110;
					v113 = v27(v16:GetEnemiesInSplashRangeCount(1991 - (1369 + 617)), v112);
					break;
				end
			end
		else
			local v238 = 1487 - (85 + 1402);
			while true do
				if (((1325 + 2517) == (9916 - 6074)) and (v238 == (403 - (274 + 129)))) then
					v112 = 218 - (12 + 205);
					v113 = 1 + 0;
					break;
				end
			end
		end
		if (((6773 - 5026) <= (3485 + 116)) and v35 and v84) then
			if ((v13:AffectingCombat() and v99.CleanseSpirit:IsAvailable()) or ((1188 - (27 + 357)) > (4839 - (91 + 389)))) then
				local v253 = 297 - (90 + 207);
				local v254;
				while true do
					if (((180 + 4490) >= (4484 - (706 + 155))) and ((1796 - (730 + 1065)) == v253)) then
						if (((3628 - (1339 + 224)) < (1294 + 1250)) and v30) then
							return v30;
						end
						break;
					end
					if (((1168 + 143) <= (5000 - 1641)) and (v253 == (843 - (268 + 575)))) then
						v254 = v84 and v99.CleanseSpirit:IsReady() and v35;
						v30 = v103.FocusUnit(v254, v101, 1314 - (919 + 375), nil, 68 - 43);
						v253 = 972 - (180 + 791);
					end
				end
			end
			if (((4522 - (323 + 1482)) <= (5074 - (1177 + 741))) and v99.CleanseSpirit:IsAvailable()) then
				if (((71 + 1010) < (16964 - 12440)) and v14 and v14:Exists() and v14:IsAPlayer() and v103.UnitHasCurseDebuff(v14)) then
					if (((170 + 270) >= (158 - 87)) and v99.CleanseSpirit:IsReady()) then
						if (((413 + 4521) > (2716 - (96 + 13))) and v24(v101.CleanseSpiritMouseover)) then
							return "cleanse_spirit mouseover";
						end
					end
				end
			end
		end
		if (v103.TargetIsValid() or v13:AffectingCombat() or ((3321 - (962 + 959)) > (7782 - 4666))) then
			v106 = v9.BossFightRemains();
			v107 = v106;
			if (((93 + 432) < (3013 - (461 + 890))) and (v107 == (8150 + 2961))) then
				v107 = v9.FightRemains(v110, false);
			end
		end
		if ((not v13:IsChanneling() and not v13:IsCasting()) or ((3413 - 2537) > (2793 - (19 + 224)))) then
			if (((199 + 20) <= (2654 - (37 + 161))) and v85) then
				if (v80 or ((1522 + 2697) == (446 + 704))) then
					local v258 = 0 + 0;
					while true do
						if ((v258 == (61 - (60 + 1))) or ((3912 - (826 + 97)) <= (215 + 7))) then
							v30 = v103.HandleAfflicted(v99.CleanseSpirit, v101.CleanseSpiritMouseover, 143 - 103);
							if (((4651 - 2393) > (1926 - (375 + 310))) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if (((2040 - (1864 + 135)) < (10989 - 6730)) and v81) then
					local v259 = 0 + 0;
					while true do
						if ((v259 == (0 + 0)) or ((4741 - 2811) < (1187 - (314 + 817)))) then
							v30 = v103.HandleAfflicted(v99.TremorTotem, v99.TremorTotem, 18 + 12);
							if (((3547 - (32 + 182)) == (2464 + 869)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if (v82 or ((7776 - 5551) == (85 - (39 + 26)))) then
					local v260 = 144 - (54 + 90);
					while true do
						if (((198 - (45 + 153)) == v260) or ((530 + 342) >= (3644 - (457 + 95)))) then
							v30 = v103.HandleAfflicted(v99.PoisonCleansingTotem, v99.PoisonCleansingTotem, 30 + 0);
							if (((9192 - 4788) >= (7859 - 4607)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
			end
			if (((4002 - 2895) > (357 + 439)) and v13:AffectingCombat()) then
				v30 = v138();
				if (((3307 - 2348) == (2894 - 1935)) and v30) then
					return v30;
				end
			else
				local v255 = 748 - (485 + 263);
				while true do
					if ((v255 == (707 - (575 + 132))) or ((1106 - (750 + 111)) >= (3214 - (445 + 565)))) then
						v30 = v137();
						if (((2545 + 617) >= (297 + 1772)) and v30) then
							return v30;
						end
						break;
					end
				end
			end
		end
	end
	local function v143()
		v99.FlameShockDebuff:RegisterAuraTracking();
		v105();
		v21.Print("Elemental Shaman by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(462 - 200, v142, v143);
end;
return v0["Epix_Shaman_Elemental.lua"]();

