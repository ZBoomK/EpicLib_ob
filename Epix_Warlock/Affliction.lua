local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = v1[v5];
	if (not v6 or ((3513 - (1427 + 192)) < (488 + 918))) then
		return v2(v5, v0, ...);
	end
	return v6(v0, ...);
end
v1["Epix_Warlock_Affliction.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Focus;
	local v15 = v12.MouseOver;
	local v16 = v12.Pet;
	local v17 = v12.Target;
	local v18 = v10.Spell;
	local v19 = v10.Item;
	local v20 = EpicLib;
	local v21 = v20.Bind;
	local v22 = v20.Macro;
	local v23 = v20.AoEON;
	local v24 = v20.CDsON;
	local v25 = v20.Cast;
	local v26 = v20.Press;
	local v27 = v20.Commons.Everyone.num;
	local v28 = v20.Commons.Everyone.bool;
	local v29 = math.max;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33;
	local v34;
	local v35;
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
	local function v49()
		local v125 = 0 - 0;
		while true do
			if (((1414 + 158) >= (694 + 837)) and ((328 - (192 + 134)) == v125)) then
				v39 = EpicSettings.Settings['HealthstoneHP'] or (1276 - (316 + 960));
				v40 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v41 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v125 = 3 + 0;
			end
			if ((v125 == (15 - 11)) or ((5238 - (83 + 468)) < (6348 - (1202 + 604)))) then
				v46 = EpicSettings.Settings['VileTaint'];
				v47 = EpicSettings.Settings['PhantomSingularity'];
				v48 = EpicSettings.Settings['SummonDarkglare'];
				break;
			end
			if (((15363 - 12072) > (2774 - 1107)) and (v125 == (0 - 0))) then
				v34 = EpicSettings.Settings['UseTrinkets'];
				v33 = EpicSettings.Settings['UseRacials'];
				v35 = EpicSettings.Settings['UseHealingPotion'];
				v125 = 326 - (45 + 280);
			end
			if ((v125 == (1 + 0)) or ((763 + 110) == (743 + 1291))) then
				v36 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v37 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v38 = EpicSettings.Settings['UseHealthstone'];
				v125 = 3 - 1;
			end
			if (((1914 - (340 + 1571)) == v125) or ((1111 + 1705) < (1783 - (1733 + 39)))) then
				v42 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v44 = EpicSettings.Settings['SummonPet'];
				v45 = EpicSettings.Settings['DarkPactHP'] or (1034 - (125 + 909));
				v125 = 1952 - (1096 + 852);
			end
		end
	end
	local v50 = v20.Commons.Everyone;
	local v51 = v20.Commons.Warlock;
	local v52 = v18.Warlock.Affliction;
	local v53 = v19.Warlock.Affliction;
	local v54 = {v53.ConjuredChillglobe:ID(),v53.DesperateInvokersCodex:ID(),v53.BelorrelostheSuncaller:ID(),v53.TimeThiefsGambit:ID()};
	local v55 = v13:GetEquipment();
	local v56 = (v55[249 - (46 + 190)] and v19(v55[108 - (51 + 44)])) or v19(0 + 0);
	local v57 = (v55[1331 - (1114 + 203)] and v19(v55[740 - (228 + 498)])) or v19(0 + 0);
	local v58 = v22.Warlock.Affliction;
	local v59, v60, v61;
	local v62, v63, v64, v65, v66, v67, v68;
	local v69, v70, v71, v72;
	local v73 = ((v13:HasTier(18 + 13, 665 - (174 + 489))) and (31 - 19)) or (1913 - (830 + 1075));
	local v74 = ((v52.DrainSoul:IsAvailable()) and v52.DrainSoul) or v52.ShadowBolt;
	local v75 = 524 - (303 + 221);
	local v76 = 12380 - (231 + 1038);
	local v77 = 9259 + 1852;
	local v78;
	local v79 = v56:ID();
	local v80 = v57:ID();
	local v81 = v56:HasUseBuff();
	local v82 = v57:HasUseBuff();
	local v83 = (v81 and (((v56:Cooldown() % (1192 - (171 + 991))) == (0 - 0)) or (((80 - 50) % v56:Cooldown()) == (0 - 0))) and (1 + 0)) or (0.5 - 0);
	local v84 = (v82 and (((v57:Cooldown() % (86 - 56)) == (0 - 0)) or (((92 - 62) % v57:Cooldown()) == (1248 - (111 + 1137)))) and (159 - (91 + 67))) or (0.5 - 0);
	local v85 = (v79 == v53.BelorrelostheSuncaller:ID()) or (v79 == v53.TimeThiefsGambit:ID());
	local v86 = (v80 == v53.BelorrelostheSuncaller:ID()) or (v80 == v53.TimeThiefsGambit:ID());
	local v87 = (v79 == v53.RubyWhelpShell:ID()) or (v79 == v53.WhisperingIncarnateIcon:ID());
	local v88 = (v80 == v53.RubyWhelpShell:ID()) or (v80 == v53.WhisperingIncarnateIcon:ID());
	local v89 = v56:BuffDuration() + (v27(v79 == v53.MirrorofFracturedTomorrows:ID()) * (5 + 15)) + (v27(v79 == v53.NymuesUnravelingSpindle:ID()) * (525 - (423 + 100)));
	local v90 = v57:BuffDuration() + (v27(v80 == v53.MirrorofFracturedTomorrows:ID()) * (1 + 19)) + (v27(v80 == v53.NymuesUnravelingSpindle:ID()) * (5 - 3));
	local v91 = (((not v81 and v82) or (v82 and (((v57:Cooldown() / v90) * v84 * ((1 + 0) - ((771.5 - (326 + 445)) * v27((v80 == v53.MirrorofFracturedTomorrows:ID()) or (v80 == v53.AshesoftheEmbersoul:ID()))))) > ((v56:Cooldown() / v89) * v83 * ((4 - 3) - ((0.5 - 0) * v27((v79 == v53.MirrorofFracturedTomorrows:ID()) or (v79 == v53.AshesoftheEmbersoul:ID())))))))) and (4 - 2)) or (712 - (530 + 181));
	v10:RegisterForEvent(function()
		v52.SeedofCorruption:RegisterInFlight();
		v52.ShadowBolt:RegisterInFlight();
		v52.Haunt:RegisterInFlight();
		v74 = ((v52.DrainSoul:IsAvailable()) and v52.DrainSoul) or v52.ShadowBolt;
	end, "LEARNED_SPELL_IN_TAB");
	v52.SeedofCorruption:RegisterInFlight();
	v52.ShadowBolt:RegisterInFlight();
	v52.Haunt:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v126 = 881 - (614 + 267);
		while true do
			if (((3731 - (19 + 13)) < (7658 - 2952)) and (v126 == (4 - 2))) then
				v81 = v56:HasUseBuff();
				v82 = v57:HasUseBuff();
				v83 = (v81 and (((v56:Cooldown() % (85 - 55)) == (0 + 0)) or (((52 - 22) % v56:Cooldown()) == (0 - 0))) and (1813 - (1293 + 519))) or (0.5 - 0);
				v126 = 7 - 4;
			end
			if (((5059 - 2413) >= (3777 - 2901)) and (v126 == (2 - 1))) then
				v73 = ((v13:HasTier(17 + 14, 1 + 1)) and (27 - 15)) or (2 + 6);
				v79 = v56:ID();
				v80 = v57:ID();
				v126 = 1 + 1;
			end
			if (((384 + 230) <= (4280 - (709 + 387))) and (v126 == (1863 - (673 + 1185)))) then
				v90 = v57:BuffDuration() + (v27(v80 == v53.MirrorofFracturedTomorrows:ID()) * (58 - 38)) + (v27(v80 == v53.NymuesUnravelingSpindle:ID()) * (6 - 4));
				v91 = (((not v81 and v82) or (v82 and (((v57:Cooldown() / v90) * v84 * ((1 - 0) - ((0.5 + 0) * v27((v80 == v53.MirrorofFracturedTomorrows:ID()) or (v80 == v53.AshesoftheEmbersoul:ID()))))) > ((v56:Cooldown() / v89) * v83 * ((1 + 0) - ((0.5 - 0) * v27((v79 == v53.MirrorofFracturedTomorrows:ID()) or (v79 == v53.AshesoftheEmbersoul:ID())))))))) and (1 + 1)) or (1 - 0);
				break;
			end
			if (((6135 - 3009) == (5006 - (446 + 1434))) and (v126 == (1283 - (1040 + 243)))) then
				v55 = v13:GetEquipment();
				v56 = (v55[38 - 25] and v19(v55[1860 - (559 + 1288)])) or v19(1931 - (609 + 1322));
				v57 = (v55[468 - (13 + 441)] and v19(v55[52 - 38])) or v19(0 - 0);
				v126 = 4 - 3;
			end
			if ((v126 == (1 + 2)) or ((7942 - 5755) >= (1760 + 3194))) then
				v84 = (v82 and (((v57:Cooldown() % (14 + 16)) == (0 - 0)) or (((17 + 13) % v57:Cooldown()) == (0 - 0))) and (1 + 0)) or (0.5 + 0);
				v85 = (v79 == v53.BelorrelostheSuncaller:ID()) or (v79 == v53.TimeThiefsGambit:ID());
				v86 = (v80 == v53.BelorrelostheSuncaller:ID()) or (v80 == v53.TimeThiefsGambit:ID());
				v126 = 3 + 1;
			end
			if ((v126 == (4 + 0)) or ((3794 + 83) == (4008 - (153 + 280)))) then
				v87 = (v79 == v53.RubyWhelpShell:ID()) or (v79 == v53.WhisperingIncarnateIcon:ID());
				v88 = (v80 == v53.RubyWhelpShell:ID()) or (v80 == v53.WhisperingIncarnateIcon:ID());
				v89 = v56:BuffDuration() + (v27(v79 == v53.MirrorofFracturedTomorrows:ID()) * (57 - 37)) + (v27(v79 == v53.NymuesUnravelingSpindle:ID()) * (2 + 0));
				v126 = 2 + 3;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v127 = 0 + 0;
		while true do
			if (((642 + 65) > (458 + 174)) and (v127 == (0 - 0))) then
				v76 = 6868 + 4243;
				v77 = 11778 - (89 + 578);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v92(v128, v129)
		local v130 = 0 + 0;
		local v131;
		while true do
			if ((v130 == (1 - 0)) or ((1595 - (572 + 477)) >= (362 + 2322))) then
				for v179, v180 in pairs(v128) do
					local v181 = 0 + 0;
					local v182;
					while true do
						if (((175 + 1290) <= (4387 - (84 + 2))) and (v181 == (0 - 0))) then
							v182 = v180:DebuffRemains(v129) + ((72 + 27) * v27(v180:DebuffDown(v129)));
							if (((2546 - (497 + 345)) > (37 + 1388)) and ((v131 == nil) or (v182 < v131))) then
								v131 = v182;
							end
							break;
						end
					end
				end
				return v131 or (0 + 0);
			end
			if ((v130 == (1333 - (605 + 728))) or ((491 + 196) == (9412 - 5178))) then
				if (not v128 or not v129 or ((153 + 3177) < (5283 - 3854))) then
					return 0 + 0;
				end
				v131 = nil;
				v130 = 2 - 1;
			end
		end
	end
	local function v93(v132)
		local v133 = 0 + 0;
		local v134;
		local v135;
		while true do
			if (((1636 - (457 + 32)) >= (143 + 192)) and (v133 == (1403 - (832 + 570)))) then
				v134 = 0 + 0;
				v135 = 0 + 0;
				v133 = 6 - 4;
			end
			if (((1655 + 1780) > (2893 - (588 + 208))) and (v133 == (0 - 0))) then
				if (not v132 or (#v132 == (1800 - (884 + 916))) or ((7892 - 4122) >= (2344 + 1697))) then
					return false;
				end
				if (v52.SeedofCorruption:InFlight() or v13:PrevGCDP(654 - (232 + 421), v52.SeedofCorruption) or ((5680 - (1569 + 320)) <= (396 + 1215))) then
					return false;
				end
				v133 = 1 + 0;
			end
			if ((v133 == (6 - 4)) or ((5183 - (316 + 289)) <= (5256 - 3248))) then
				for v183, v184 in pairs(v132) do
					local v185 = 0 + 0;
					while true do
						if (((2578 - (666 + 787)) <= (2501 - (360 + 65))) and (v185 == (0 + 0))) then
							v134 = v134 + (255 - (79 + 175));
							if (v184:DebuffUp(v52.SeedofCorruptionDebuff) or ((1171 - 428) >= (3433 + 966))) then
								v135 = v135 + (2 - 1);
							end
							break;
						end
					end
				end
				return v134 == v135;
			end
		end
	end
	local function v94()
		return v51.GuardiansTable.DarkglareDuration > (0 - 0);
	end
	local function v95()
		return v51.GuardiansTable.DarkglareDuration;
	end
	local function v96(v136)
		return (v136:DebuffRemains(v52.AgonyDebuff));
	end
	local function v97(v137)
		return (v137:DebuffRemains(v52.CorruptionDebuff));
	end
	local function v98(v138)
		return (v138:DebuffRemains(v52.ShadowEmbraceDebuff));
	end
	local function v99(v139)
		return (v139:DebuffRemains(v52.SiphonLifeDebuff));
	end
	local function v100(v140)
		return (v140:DebuffRemains(v52.SoulRotDebuff));
	end
	local function v101(v141)
		return (v141:DebuffRemains(v52.AgonyDebuff) < (v141:DebuffRemains(v52.VileTaintDebuff) + v52.VileTaint:CastTime())) and (v141:DebuffRemains(v52.AgonyDebuff) < (904 - (503 + 396)));
	end
	local function v102(v142)
		return v142:DebuffRemains(v52.AgonyDebuff) < (186 - (92 + 89));
	end
	local function v103(v143)
		return ((v143:DebuffRemains(v52.AgonyDebuff) < (v52.VileTaint:CooldownRemains() + v52.VileTaint:CastTime())) or not v52.VileTaint:IsAvailable()) and (v143:DebuffRemains(v52.AgonyDebuff) < (9 - 4));
	end
	local function v104(v144)
		return ((v144:DebuffRemains(v52.AgonyDebuff) < (v52.VileTaint:CooldownRemains() + v52.VileTaint:CastTime())) or not v52.VileTaint:IsAvailable()) and (v144:DebuffRemains(v52.AgonyDebuff) < (3 + 2)) and (v77 > (3 + 2));
	end
	local function v105(v145)
		return v145:DebuffRemains(v52.CorruptionDebuff) < (19 - 14);
	end
	local function v106(v146)
		return (v52.ShadowEmbrace:IsAvailable() and ((v146:DebuffStack(v52.ShadowEmbraceDebuff) < (1 + 2)) or (v146:DebuffRemains(v52.ShadowEmbraceDebuff) < (6 - 3)))) or not v52.ShadowEmbrace:IsAvailable();
	end
	local function v107(v147)
		return (v147:DebuffRefreshable(v52.SiphonLifeDebuff));
	end
	local function v108(v148)
		return v148:DebuffRemains(v52.AgonyDebuff) < (5 + 0);
	end
	local function v109(v149)
		return (v149:DebuffRefreshable(v52.AgonyDebuff));
	end
	local function v110(v150)
		return v150:DebuffRemains(v52.CorruptionDebuff) < (3 + 2);
	end
	local function v111(v151)
		return (v151:DebuffRefreshable(v52.CorruptionDebuff));
	end
	local function v112(v152)
		return (v152:DebuffStack(v52.ShadowEmbraceDebuff) < (8 - 5)) or (v152:DebuffRemains(v52.ShadowEmbraceDebuff) < (1 + 2));
	end
	local function v113(v153)
		return (v52.ShadowEmbrace:IsAvailable() and ((v153:DebuffStack(v52.ShadowEmbraceDebuff) < (4 - 1)) or (v153:DebuffRemains(v52.ShadowEmbraceDebuff) < (1247 - (485 + 759))))) or not v52.ShadowEmbrace:IsAvailable();
	end
	local function v114(v154)
		return v154:DebuffRemains(v52.SiphonLifeDebuff) < (11 - 6);
	end
	local function v115(v155)
		return (v155:DebuffRemains(v52.SiphonLifeDebuff) < (1194 - (442 + 747))) and v155:DebuffUp(v52.AgonyDebuff);
	end
	local function v116()
		local v156 = 1135 - (832 + 303);
		while true do
			if (((2101 - (88 + 858)) < (510 + 1163)) and (v156 == (1 + 0))) then
				if ((v52.UnstableAffliction:IsReady() and not v52.SoulSwap:IsAvailable()) or ((96 + 2228) <= (1367 - (766 + 23)))) then
					if (((18596 - 14829) == (5151 - 1384)) and v26(v52.UnstableAffliction, not v17:IsSpellInRange(v52.UnstableAffliction), true)) then
						return "unstable_affliction precombat 8";
					end
				end
				if (((10773 - 6684) == (13878 - 9789)) and v52.ShadowBolt:IsReady()) then
					if (((5531 - (1036 + 37)) >= (1187 + 487)) and v26(v52.ShadowBolt, not v17:IsSpellInRange(v52.ShadowBolt), true)) then
						return "shadow_bolt precombat 10";
					end
				end
				break;
			end
			if (((1892 - 920) <= (1116 + 302)) and (v156 == (1480 - (641 + 839)))) then
				if (v52.GrimoireofSacrifice:IsCastable() or ((5851 - (910 + 3)) < (12139 - 7377))) then
					if (v26(v52.GrimoireofSacrifice) or ((4188 - (1466 + 218)) > (1960 + 2304))) then
						return "grimoire_of_sacrifice precombat 2";
					end
				end
				if (((3301 - (556 + 592)) == (766 + 1387)) and v52.Haunt:IsReady()) then
					if (v26(v52.Haunt, not v17:IsSpellInRange(v52.Haunt), true) or ((1315 - (329 + 479)) >= (3445 - (174 + 680)))) then
						return "haunt precombat 6";
					end
				end
				v156 = 3 - 2;
			end
		end
	end
	local function v117()
		local v157 = 0 - 0;
		while true do
			if (((3200 + 1281) == (5220 - (396 + 343))) and (v157 == (1 + 0))) then
				v64 = v17:DebuffUp(v52.VileTaintDebuff) or v17:DebuffUp(v52.PhantomSingularityDebuff) or (not v52.VileTaint:IsAvailable() and not v52.PhantomSingularity:IsAvailable());
				v65 = v17:DebuffUp(v52.SoulRotDebuff) or not v52.SoulRot:IsAvailable();
				v157 = 1479 - (29 + 1448);
			end
			if ((v157 == (1391 - (135 + 1254))) or ((8770 - 6442) < (3235 - 2542))) then
				v66 = v62 and v63 and v65;
				v67 = v52.PhantomSingularity:IsAvailable() or v52.VileTaint:IsAvailable() or v52.SoulRot:IsAvailable() or v52.SummonDarkglare:IsAvailable();
				v157 = 2 + 1;
			end
			if (((5855 - (389 + 1138)) == (4902 - (102 + 472))) and (v157 == (3 + 0))) then
				v68 = not v67 or (v66 and ((v52.SummonDarkglare:CooldownRemains() > (12 + 8)) or not v52.SummonDarkglare:IsAvailable()));
				break;
			end
			if (((1481 + 107) >= (2877 - (320 + 1225))) and (v157 == (0 - 0))) then
				v62 = v17:DebuffUp(v52.PhantomSingularityDebuff) or not v52.PhantomSingularity:IsAvailable();
				v63 = v17:DebuffUp(v52.VileTaintDebuff) or not v52.VileTaint:IsAvailable();
				v157 = 1 + 0;
			end
		end
	end
	local function v118()
		local v158 = 1464 - (157 + 1307);
		local v159;
		while true do
			if ((v158 == (1859 - (821 + 1038))) or ((10413 - 6239) > (465 + 3783))) then
				v159 = v50.HandleTopTrinket(v54, v32, 71 - 31, nil);
				if (v159 or ((1707 + 2879) <= (202 - 120))) then
					return v159;
				end
				v158 = 1027 - (834 + 192);
			end
			if (((246 + 3617) == (992 + 2871)) and (v158 == (1 + 0))) then
				v159 = v50.HandleBottomTrinket(v54, v32, 61 - 21, nil);
				if (v159 or ((586 - (300 + 4)) <= (12 + 30))) then
					return v159;
				end
				break;
			end
		end
	end
	local function v119()
		local v160 = v118();
		if (((12065 - 7456) >= (1128 - (112 + 250))) and v160) then
			return v160;
		end
		if (v53.DesperateInvokersCodex:IsEquippedAndReady() or ((460 + 692) == (6232 - 3744))) then
			if (((1961 + 1461) > (1733 + 1617)) and v26(v58.DesperateInvokersCodex, not v17:IsInRange(34 + 11))) then
				return "desperate_invokers_codex items 2";
			end
		end
		if (((435 + 442) > (280 + 96)) and v53.ConjuredChillglobe:IsEquippedAndReady()) then
			if (v26(v58.ConjuredChillglobe) or ((4532 - (1001 + 413)) <= (4127 - 2276))) then
				return "conjured_chillglobe items 4";
			end
		end
	end
	local function v120()
		if (v68 or ((1047 - (244 + 638)) >= (4185 - (627 + 66)))) then
			local v168 = 0 - 0;
			local v169;
			while true do
				if (((4551 - (512 + 90)) < (6762 - (1665 + 241))) and (v168 == (719 - (373 + 344)))) then
					if (v52.Fireblood:IsCastable() or ((1929 + 2347) < (799 + 2217))) then
						if (((12370 - 7680) > (6980 - 2855)) and v26(v52.Fireblood)) then
							return "fireblood ogcd 8";
						end
					end
					break;
				end
				if ((v168 == (1099 - (35 + 1064))) or ((37 + 13) >= (1916 - 1020))) then
					v169 = v50.HandleDPSPotion();
					if (v169 or ((7 + 1707) >= (4194 - (298 + 938)))) then
						return v169;
					end
					v168 = 1260 - (233 + 1026);
				end
				if ((v168 == (1667 - (636 + 1030))) or ((763 + 728) < (630 + 14))) then
					if (((210 + 494) < (67 + 920)) and v52.Berserking:IsCastable()) then
						if (((3939 - (55 + 166)) > (370 + 1536)) and v26(v52.Berserking)) then
							return "berserking ogcd 4";
						end
					end
					if (v52.BloodFury:IsCastable() or ((97 + 861) > (13882 - 10247))) then
						if (((3798 - (36 + 261)) <= (7855 - 3363)) and v26(v52.BloodFury)) then
							return "blood_fury ogcd 6";
						end
					end
					v168 = 1370 - (34 + 1334);
				end
			end
		end
	end
	local function v121()
		local v161 = 0 + 0;
		local v162;
		while true do
			if ((v161 == (2 + 0)) or ((4725 - (1035 + 248)) < (2569 - (20 + 1)))) then
				if (((1498 + 1377) >= (1783 - (134 + 185))) and v52.SiphonLife:IsReady() and (v52.SiphonLifeDebuff:AuraActiveCount() < (1139 - (549 + 584))) and v52.SummonDarkglare:CooldownUp() and (HL.CombatTime() < (705 - (314 + 371))) and (((v78 * (6 - 4)) + v52.SoulRot:CastTime()) < v72)) then
					if (v50.CastCycle(v52.SiphonLife, v59, v115, not v17:IsSpellInRange(v52.SiphonLife)) or ((5765 - (478 + 490)) >= (2592 + 2301))) then
						return "siphon_life aoe 10";
					end
				end
				if ((v52.SoulRot:IsReady() and v63 and (v62 or (v52.SouleatersGluttony:TalentRank() ~= (1173 - (786 + 386)))) and v17:DebuffUp(v52.AgonyDebuff)) or ((1784 - 1233) > (3447 - (1055 + 324)))) then
					if (((3454 - (1093 + 247)) > (839 + 105)) and v25(v52.SoulRot, nil, nil, not v17:IsSpellInRange(v52.SoulRot))) then
						return "soul_rot aoe 12";
					end
				end
				if ((v52.SeedofCorruption:IsReady() and (v17:DebuffRemains(v52.CorruptionDebuff) < (1 + 4)) and not (v52.SeedofCorruption:InFlight() or v17:DebuffUp(v52.SeedofCorruptionDebuff))) or ((8980 - 6718) >= (10506 - 7410))) then
					if (v25(v52.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v52.SeedofCorruption)) or ((6416 - 4161) >= (8888 - 5351))) then
						return "seed_of_corruption aoe 14";
					end
				end
				if ((v52.Corruption:IsReady() and not v52.SeedofCorruption:IsAvailable()) or ((1365 + 2472) < (5031 - 3725))) then
					if (((10168 - 7218) == (2225 + 725)) and v50.CastTargetIf(v52.Corruption, v59, "min", v97, v105, not v17:IsSpellInRange(v52.Corruption))) then
						return "corruption aoe 15";
					end
				end
				v161 = 7 - 4;
			end
			if ((v161 == (692 - (364 + 324))) or ((12947 - 8224) < (7913 - 4615))) then
				if (((377 + 759) >= (644 - 490)) and v52.MaleficRapture:IsReady() and ((((v52.SummonDarkglare:CooldownRemains() > (24 - 9)) or (v75 > (8 - 5))) and not v52.SowTheSeeds:IsAvailable()) or v13:BuffUp(v52.TormentedCrescendoBuff))) then
					if (v25(v52.MaleficRapture, nil, nil, not v17:IsInRange(1368 - (1249 + 19))) or ((245 + 26) > (18481 - 13733))) then
						return "malefic_rapture aoe 24";
					end
				end
				if (((5826 - (686 + 400)) >= (2474 + 678)) and v52.DrainLife:IsReady() and (v17:DebuffUp(v52.SoulRotDebuff) or not v52.SoulRot:IsAvailable()) and (v13:BuffStack(v52.InevitableDemiseBuff) > (239 - (73 + 156)))) then
					if (v25(v52.DrainLife, nil, nil, not v17:IsSpellInRange(v52.DrainLife)) or ((13 + 2565) >= (4201 - (721 + 90)))) then
						return "drain_life aoe 26";
					end
				end
				if (((1 + 40) <= (5392 - 3731)) and v52.DrainSoul:IsReady() and v13:BuffUp(v52.NightfallBuff) and v52.ShadowEmbrace:IsAvailable()) then
					if (((1071 - (224 + 246)) < (5767 - 2207)) and v50.CastCycle(v52.DrainSoul, v59, v112, not v17:IsSpellInRange(v52.DrainSoul))) then
						return "drain_soul aoe 28";
					end
				end
				if (((432 - 197) < (125 + 562)) and v52.DrainSoul:IsReady() and (v13:BuffUp(v52.NightfallBuff))) then
					if (((109 + 4440) > (847 + 306)) and v25(v52.DrainSoul, nil, nil, not v17:IsSpellInRange(v52.DrainSoul))) then
						return "drain_soul aoe 30";
					end
				end
				v161 = 9 - 4;
			end
			if ((v161 == (9 - 6)) or ((5187 - (203 + 310)) < (6665 - (1238 + 755)))) then
				if (((257 + 3411) < (6095 - (709 + 825))) and v32 and v52.SummonDarkglare:IsCastable() and v62 and v63 and v65) then
					if (v25(v52.SummonDarkglare, v48) or ((838 - 383) == (5250 - 1645))) then
						return "summon_darkglare aoe 18";
					end
				end
				if ((v52.DrainLife:IsReady() and (v13:BuffStack(v52.InevitableDemiseBuff) > (894 - (196 + 668))) and v13:BuffUp(v52.SoulRot) and (v13:BuffRemains(v52.SoulRot) <= v78) and (v61 > (11 - 8))) or ((5515 - 2852) == (4145 - (171 + 662)))) then
					if (((4370 - (4 + 89)) <= (15684 - 11209)) and v50.CastTargetIf(v52.DrainLife, v59, "min", v100, nil, not v17:IsSpellInRange(v52.DrainLife))) then
						return "drain_life aoe 19";
					end
				end
				if ((v52.MaleficRapture:IsReady() and v13:BuffUp(v52.UmbrafireKindlingBuff) and ((((v61 < (3 + 3)) or (HL.CombatTime() < (131 - 101))) and v94()) or not v52.DoomBlossom:IsAvailable())) or ((342 + 528) == (2675 - (35 + 1451)))) then
					if (((3006 - (28 + 1425)) <= (5126 - (941 + 1052))) and v25(v52.MaleficRapture, nil, nil, not v17:IsInRange(96 + 4))) then
						return "malefic_rapture aoe 20";
					end
				end
				if ((v52.SeedofCorruption:IsReady() and v52.SowTheSeeds:IsAvailable()) or ((3751 - (822 + 692)) >= (5012 - 1501))) then
					if (v25(v52.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v52.SeedofCorruption)) or ((624 + 700) > (3317 - (45 + 252)))) then
						return "seed_of_corruption aoe 22";
					end
				end
				v161 = 4 + 0;
			end
			if ((v161 == (1 + 0)) or ((7281 - 4289) == (2314 - (114 + 319)))) then
				if (((4458 - 1352) > (1955 - 429)) and v52.VileTaint:IsReady() and (((v52.SouleatersGluttony:TalentRank() == (2 + 0)) and ((v69 < (1.5 - 0)) or (v52.SoulRot:CooldownRemains() <= v52.VileTaint:ExecuteTime()))) or ((v52.SouleatersGluttony:TalentRank() == (1 - 0)) and (v52.SoulRot:CooldownRemains() <= v52.VileTaint:ExecuteTime())) or (not v52.SouleatersGluttony:IsAvailable() and ((v52.SoulRot:CooldownRemains() <= v52.VileTaint:ExecuteTime()) or (v52.VileTaint:CooldownRemains() > (1988 - (556 + 1407))))))) then
					if (((4229 - (741 + 465)) < (4335 - (170 + 295))) and v25(v58.VileTaintCursor, nil, nil, not v17:IsInRange(22 + 18))) then
						return "vile_taint aoe 4";
					end
				end
				if (((132 + 11) > (182 - 108)) and v52.PhantomSingularity:IsCastable() and ((v52.SoulRot:IsAvailable() and (v52.SoulRot:CooldownRemains() <= v52.PhantomSingularity:ExecuteTime())) or (not v52.SouleatersGluttony:IsAvailable() and (not v52.SoulRot:IsAvailable() or (v52.SoulRot:CooldownRemains() <= v52.PhantomSingularity:ExecuteTime()) or (v52.SoulRot:CooldownRemains() >= (21 + 4))))) and v17:DebuffUp(v52.AgonyDebuff)) then
					if (((12 + 6) < (1196 + 916)) and v25(v52.PhantomSingularity, v47, nil, not v17:IsSpellInRange(v52.PhantomSingularity))) then
						return "phantom_singularity aoe 6";
					end
				end
				if (((2327 - (957 + 273)) <= (436 + 1192)) and v52.UnstableAffliction:IsReady() and (v17:DebuffRemains(v52.UnstableAfflictionDebuff) < (3 + 2))) then
					if (((17642 - 13012) == (12201 - 7571)) and v25(v52.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v52.UnstableAffliction))) then
						return "unstable_affliction aoe 8";
					end
				end
				if (((10812 - 7272) > (13285 - 10602)) and v52.Agony:IsReady() and (v52.AgonyDebuff:AuraActiveCount() < (1788 - (389 + 1391))) and (((v78 * (2 + 0)) + v52.SoulRot:CastTime()) < v72)) then
					if (((499 + 4295) >= (7455 - 4180)) and v50.CastTargetIf(v52.Agony, v59, "min", v96, v103, not v17:IsSpellInRange(v52.Agony))) then
						return "agony aoe 9";
					end
				end
				v161 = 953 - (783 + 168);
			end
			if (((4980 - 3496) == (1460 + 24)) and (v161 == (316 - (309 + 2)))) then
				if (((4397 - 2965) < (4767 - (1090 + 122))) and v52.SummonSoulkeeper:IsReady() and ((v52.SummonSoulkeeper:Count() == (4 + 6)) or ((v52.SummonSoulkeeper:Count() > (9 - 6)) and (v77 < (7 + 3))))) then
					if (v25(v52.SummonSoulkeeper) or ((2183 - (628 + 490)) > (642 + 2936))) then
						return "soul_strike aoe 32";
					end
				end
				if ((v52.SiphonLife:IsReady() and (v52.SiphonLifeDebuff:AuraActiveCount() < (12 - 7)) and ((v61 < (36 - 28)) or not v52.DoomBlossom:IsAvailable())) or ((5569 - (431 + 343)) < (2841 - 1434))) then
					if (((5360 - 3507) < (3803 + 1010)) and v50.CastCycle(v52.SiphonLife, v59, v114, not v17:IsSpellInRange(v52.SiphonLife))) then
						return "siphon_life aoe 34";
					end
				end
				if (v52.DrainSoul:IsReady() or ((361 + 2460) < (4126 - (556 + 1139)))) then
					if (v50.CastCycle(v52.DrainSoul, v59, v113, not v17:IsSpellInRange(v52.DrainSoul)) or ((2889 - (6 + 9)) < (400 + 1781))) then
						return "drain_soul aoe 36";
					end
				end
				if (v52.ShadowBolt:IsReady() or ((1378 + 1311) <= (512 - (28 + 141)))) then
					if (v25(v52.ShadowBolt, nil, nil, not v17:IsSpellInRange(v52.ShadowBolt)) or ((724 + 1145) == (2479 - 470))) then
						return "shadow_bolt aoe 38";
					end
				end
				break;
			end
			if ((v161 == (0 + 0)) or ((4863 - (486 + 831)) < (6042 - 3720))) then
				if (v32 or ((7329 - 5247) == (902 + 3871))) then
					local v196 = 0 - 0;
					local v197;
					while true do
						if (((4507 - (668 + 595)) > (950 + 105)) and (v196 == (0 + 0))) then
							v197 = v120();
							if (v197 or ((9034 - 5721) <= (2068 - (23 + 267)))) then
								return v197;
							end
							break;
						end
					end
				end
				v162 = v119();
				if (v162 or ((3365 - (1129 + 815)) >= (2491 - (371 + 16)))) then
					return v162;
				end
				if (((3562 - (1326 + 424)) <= (6153 - 2904)) and v52.Haunt:IsReady() and (v17:DebuffRemains(v52.HauntDebuff) < (10 - 7))) then
					if (((1741 - (88 + 30)) <= (2728 - (720 + 51))) and v25(v52.Haunt, nil, nil, not v17:IsSpellInRange(v52.Haunt))) then
						return "haunt aoe 2";
					end
				end
				v161 = 2 - 1;
			end
		end
	end
	local function v122()
		local v163 = 1776 - (421 + 1355);
		local v164;
		while true do
			if (((7277 - 2865) == (2168 + 2244)) and ((1083 - (286 + 797)) == v163)) then
				if (((6397 - 4647) >= (1394 - 552)) and v32) then
					local v198 = 439 - (397 + 42);
					local v199;
					while true do
						if (((1366 + 3006) > (2650 - (24 + 776))) and (v198 == (0 - 0))) then
							v199 = v120();
							if (((1017 - (222 + 563)) < (1808 - 987)) and v199) then
								return v199;
							end
							break;
						end
					end
				end
				v164 = v119();
				if (((373 + 145) < (1092 - (23 + 167))) and v164) then
					return v164;
				end
				if (((4792 - (690 + 1108)) > (310 + 548)) and v32 and v52.SummonDarkglare:IsCastable() and v62 and v63 and v65) then
					if (v25(v52.SummonDarkglare, v48) or ((3098 + 657) <= (1763 - (40 + 808)))) then
						return "summon_darkglare cleave 2";
					end
				end
				v163 = 1 + 0;
			end
			if (((15089 - 11143) > (3578 + 165)) and (v163 == (2 + 1))) then
				if ((v52.Corruption:IsReady() and not (v52.SeedofCorruption:InFlight() or (v17:DebuffRemains(v52.SeedofCorruptionDebuff) > (0 + 0))) and (v77 > (576 - (47 + 524)))) or ((867 + 468) >= (9037 - 5731))) then
					if (((7242 - 2398) > (5137 - 2884)) and v50.CastTargetIf(v52.Corruption, v59, "min", v97, v105, not v17:IsSpellInRange(v52.Corruption))) then
						return "corruption cleave 18";
					end
				end
				if (((2178 - (1165 + 561)) == (14 + 438)) and v52.SiphonLife:IsReady() and (v77 > (15 - 10))) then
					if (v50.CastTargetIf(v52.SiphonLife, v59, "min", v99, v107, not v17:IsSpellInRange(v52.SiphonLife)) or ((1739 + 2818) < (2566 - (341 + 138)))) then
						return "siphon_life cleave 20";
					end
				end
				if (((1046 + 2828) == (7994 - 4120)) and v52.SummonDarkglare:IsReady() and (not v52.ShadowEmbrace:IsAvailable() or (v17:DebuffStack(v52.ShadowEmbraceDebuff) == (329 - (89 + 237)))) and v62 and v63 and v65) then
					if (v25(v52.SummonDarkglare, v48) or ((6234 - 4296) > (10389 - 5454))) then
						return "summon_darkglare cleave 22";
					end
				end
				if ((v52.MaleficRapture:IsReady() and v52.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v52.TormentedCrescendoBuff) == (882 - (581 + 300))) and (v75 > (1223 - (855 + 365)))) or ((10106 - 5851) < (1118 + 2305))) then
					if (((2689 - (1030 + 205)) <= (2339 + 152)) and v25(v52.MaleficRapture, nil, nil, not v17:IsInRange(94 + 6))) then
						return "malefic_rapture cleave 24";
					end
				end
				v163 = 290 - (156 + 130);
			end
			if (((4 - 2) == v163) or ((7005 - 2848) <= (5740 - 2937))) then
				if (((1279 + 3574) >= (1739 + 1243)) and v52.Agony:IsReady()) then
					if (((4203 - (10 + 59)) > (950 + 2407)) and v50.CastTargetIf(v52.Agony, v59, "min", v96, v104, not v17:IsSpellInRange(v52.Agony))) then
						return "agony cleave 10";
					end
				end
				if ((v52.UnstableAffliction:IsReady() and (v17:DebuffRemains(v52.UnstableAfflictionDebuff) < (24 - 19)) and (v77 > (1166 - (671 + 492)))) or ((2721 + 696) < (3749 - (369 + 846)))) then
					if (v25(v52.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v52.UnstableAffliction)) or ((721 + 2001) <= (140 + 24))) then
						return "unstable_affliction cleave 12";
					end
				end
				if ((v52.SeedofCorruption:IsReady() and not v52.AbsoluteCorruption:IsAvailable() and (v17:DebuffRemains(v52.CorruptionDebuff) < (1950 - (1036 + 909))) and v52.SowTheSeeds:IsAvailable() and v93(v59)) or ((1915 + 493) < (3540 - 1431))) then
					if (v25(v52.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v52.SeedofCorruption)) or ((236 - (11 + 192)) == (736 + 719))) then
						return "seed_of_corruption cleave 14";
					end
				end
				if ((v52.Haunt:IsReady() and (v17:DebuffRemains(v52.HauntDebuff) < (178 - (135 + 40)))) or ((1073 - 630) >= (2421 + 1594))) then
					if (((7450 - 4068) > (248 - 82)) and v25(v52.Haunt, nil, nil, not v17:IsSpellInRange(v52.Haunt))) then
						return "haunt cleave 16";
					end
				end
				v163 = 179 - (50 + 126);
			end
			if ((v163 == (16 - 10)) or ((62 + 218) == (4472 - (1233 + 180)))) then
				if (((2850 - (522 + 447)) > (2714 - (107 + 1314))) and v52.Corruption:IsCastable()) then
					if (((1094 + 1263) == (7181 - 4824)) and v50.CastCycle(v52.Corruption, v59, v111, not v17:IsSpellInRange(v52.Corruption))) then
						return "corruption cleave 42";
					end
				end
				if (((53 + 70) == (244 - 121)) and v52.MaleficRapture:IsReady() and (v75 > (3 - 2))) then
					if (v25(v52.MaleficRapture, nil, nil, not v17:IsInRange(2010 - (716 + 1194))) or ((19 + 1037) >= (364 + 3028))) then
						return "malefic_rapture cleave 44";
					end
				end
				if (v52.DrainSoul:IsReady() or ((1584 - (74 + 429)) < (2073 - 998))) then
					if (v25(v52.DrainSoul, nil, nil, not v17:IsSpellInRange(v52.DrainSoul)) or ((520 + 529) >= (10144 - 5712))) then
						return "drain_soul cleave 54";
					end
				end
				if (v74:IsReady() or ((3374 + 1394) <= (2607 - 1761))) then
					if (v25(v74, nil, nil, not v17:IsSpellInRange(v74)) or ((8302 - 4944) <= (1853 - (279 + 154)))) then
						return "drain_soul/shadow_bolt cleave 46";
					end
				end
				break;
			end
			if ((v163 == (783 - (454 + 324))) or ((2942 + 797) <= (3022 - (12 + 5)))) then
				if ((v52.MaleficRapture:IsReady() and (v75 > (2 + 1))) or ((4226 - 2567) >= (789 + 1345))) then
					if (v25(v52.MaleficRapture, nil, nil, not v17:IsInRange(1193 - (277 + 816))) or ((13930 - 10670) < (3538 - (1058 + 125)))) then
						return "malefic_rapture cleave 34";
					end
				end
				if ((v52.DrainLife:IsReady() and ((v13:BuffStack(v52.InevitableDemiseBuff) > (9 + 39)) or ((v13:BuffStack(v52.InevitableDemiseBuff) > (995 - (815 + 160))) and (v77 < (17 - 13))))) or ((1587 - 918) == (1008 + 3215))) then
					if (v25(v52.DrainLife, nil, nil, not v17:IsSpellInRange(v52.DrainLife)) or ((4945 - 3253) < (2486 - (41 + 1857)))) then
						return "drain_life cleave 36";
					end
				end
				if ((v52.DrainLife:IsReady() and v13:BuffUp(v52.SoulRot) and (v13:BuffStack(v52.InevitableDemiseBuff) > (1923 - (1222 + 671)))) or ((12398 - 7601) < (5247 - 1596))) then
					if (v25(v52.DrainLife, nil, nil, not v17:IsSpellInRange(v52.DrainLife)) or ((5359 - (229 + 953)) > (6624 - (1111 + 663)))) then
						return "drain_life cleave 38";
					end
				end
				if (v52.Agony:IsReady() or ((1979 - (874 + 705)) > (156 + 955))) then
					if (((2082 + 969) > (2089 - 1084)) and v50.CastCycle(v52.Agony, v59, v109, not v17:IsSpellInRange(v52.Agony))) then
						return "agony cleave 40";
					end
				end
				v163 = 1 + 5;
			end
			if (((4372 - (642 + 37)) <= (1000 + 3382)) and (v163 == (1 + 0))) then
				if ((v52.MaleficRapture:IsReady() and ((v52.DreadTouch:IsAvailable() and (v17:DebuffRemains(v52.DreadTouchDebuff) < (4 - 2)) and (v17:DebuffRemains(v52.AgonyDebuff) > v78) and v17:DebuffUp(v52.CorruptionDebuff) and (not v52.SiphonLife:IsAvailable() or v17:DebuffUp(v52.SiphonLifeDebuff)) and v17:DebuffUp(v52.UnstableAfflictionDebuff) and (not v52.PhantomSingularity:IsAvailable() or v52.PhantomSingularity:CooldownDown()) and (not v52.VileTaint:IsAvailable() or v52.VileTaint:CooldownDown()) and (not v52.SoulRot:IsAvailable() or v52.SoulRot:CooldownDown())) or (v75 > (458 - (233 + 221))))) or ((7588 - 4306) > (3609 + 491))) then
					if (v25(v52.MaleficRapture, nil, nil, not v17:IsInRange(1641 - (718 + 823))) or ((2253 + 1327) < (3649 - (266 + 539)))) then
						return "malefic_rapture cleave 2";
					end
				end
				if (((251 - 162) < (5715 - (636 + 589))) and v52.VileTaint:IsReady() and (not v52.SoulRot:IsAvailable() or (v69 < (2.5 - 1)) or (v52.SoulRot:CooldownRemains() <= (v52.VileTaint:ExecuteTime() + v78)) or (not v52.SouleatersGluttony:IsAvailable() and (v52.SoulRot:CooldownRemains() >= (24 - 12))))) then
					if (v25(v52.VileTaint, nil, nil, not v17:IsInRange(32 + 8)) or ((1811 + 3172) < (2823 - (657 + 358)))) then
						return "vile_taint cleave 4";
					end
				end
				if (((10137 - 6308) > (8586 - 4817)) and v52.VileTaint:IsReady() and (v52.AgonyDebuff:AuraActiveCount() == (1189 - (1151 + 36))) and (v52.CorruptionDebuff:AuraActiveCount() == (2 + 0)) and (not v52.SiphonLife:IsAvailable() or (v52.SiphonLifeDebuff:AuraActiveCount() == (1 + 1))) and (not v52.SoulRot:IsAvailable() or (v52.SoulRot:CooldownRemains() <= v52.VileTaint:ExecuteTime()) or (not v52.SouleatersGluttony:IsAvailable() and (v52.SoulRot:CooldownRemains() >= (35 - 23))))) then
					if (((3317 - (1552 + 280)) <= (3738 - (64 + 770))) and v25(v58.VileTaintCursor, nil, nil, not v17:IsSpellInRange(v52.VileTaint))) then
						return "vile_taint cleave 10";
					end
				end
				if (((2899 + 1370) == (9690 - 5421)) and v52.SoulRot:IsReady() and v63 and (v62 or (v52.SouleatersGluttony:TalentRank() ~= (1 + 0))) and (v52.AgonyDebuff:AuraActiveCount() >= (1245 - (157 + 1086)))) then
					if (((774 - 387) <= (12184 - 9402)) and v25(v52.SoulRot, nil, nil, not v17:IsSpellInRange(v52.SoulRot))) then
						return "soul_rot cleave 8";
					end
				end
				v163 = 2 - 0;
			end
			if ((v163 == (5 - 1)) or ((2718 - (599 + 220)) <= (1826 - 909))) then
				if ((v52.DrainSoul:IsReady() and v52.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v52.ShadowEmbraceDebuff) < (1934 - (1813 + 118))) or (v17:DebuffRemains(v52.ShadowEmbraceDebuff) < (3 + 0)))) or ((5529 - (841 + 376)) <= (1226 - 350))) then
					if (((519 + 1713) <= (7085 - 4489)) and v25(v52.DrainSoul, nil, nil, not v17:IsSpellInRange(v52.DrainSoul))) then
						return "drain_soul cleave 26";
					end
				end
				if (((2954 - (464 + 395)) < (9459 - 5773)) and v74:IsReady() and (v13:BuffUp(v52.NightfallBuff))) then
					if (v50.CastTargetIf(v74, v59, "min", v98, v106, not v17:IsSpellInRange(v74)) or ((766 + 829) >= (5311 - (467 + 370)))) then
						return "drain_soul/shadow_bolt cleave 28";
					end
				end
				if ((v52.MaleficRapture:IsReady() and not v52.DreadTouch:IsAvailable() and v13:BuffUp(v52.TormentedCrescendoBuff)) or ((9544 - 4925) < (2116 + 766))) then
					if (v25(v52.MaleficRapture, nil, nil, not v17:IsInRange(342 - 242)) or ((46 + 248) >= (11239 - 6408))) then
						return "malefic_rapture cleave 30";
					end
				end
				if (((2549 - (150 + 370)) <= (4366 - (74 + 1208))) and v52.MaleficRapture:IsReady() and (v66 or v64)) then
					if (v25(v52.MaleficRapture, nil, nil, not v17:IsInRange(245 - 145)) or ((9660 - 7623) == (1722 + 698))) then
						return "malefic_rapture cleave 32";
					end
				end
				v163 = 395 - (14 + 376);
			end
		end
	end
	local function v123()
		v49();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v59 = v13:GetEnemiesInRange(69 - 29);
		v60 = v17:GetEnemiesInSplashRange(7 + 3);
		if (((3917 + 541) > (3724 + 180)) and v31) then
			v61 = v17:GetEnemiesInSplashRangeCount(29 - 19);
		else
			v61 = 1 + 0;
		end
		if (((514 - (23 + 55)) >= (291 - 168)) and (v50.TargetIsValid() or v13:AffectingCombat())) then
			local v170 = 0 + 0;
			while true do
				if (((449 + 51) < (2815 - 999)) and (v170 == (1 + 0))) then
					if (((4475 - (652 + 249)) == (9564 - 5990)) and (v77 == (12979 - (708 + 1160)))) then
						v77 = v10.FightRemains(v60, false);
					end
					break;
				end
				if (((599 - 378) < (711 - 321)) and (v170 == (27 - (10 + 17)))) then
					v76 = v10.BossFightRemains(nil, true);
					v77 = v76;
					v170 = 1 + 0;
				end
			end
		end
		v75 = v13:SoulShardsP();
		v69 = v92(v60, v52.AgonyDebuff);
		v70 = v92(v60, v52.VileTaintDebuff);
		v71 = v92(v60, v52.PhantomSingularityDebuff);
		v72 = v29(v70 * v27(v52.VileTaint:IsAvailable()), v71 * v27(v52.PhantomSingularity:IsAvailable()));
		v78 = v13:GCD() + (1732.25 - (1400 + 332));
		if ((v52.SummonPet:IsCastable() and v44 and not v16:IsActive()) or ((4244 - 2031) <= (3329 - (242 + 1666)))) then
			if (((1309 + 1749) < (1782 + 3078)) and v26(v52.SummonPet)) then
				return "summon_pet ooc";
			end
		end
		if (v50.TargetIsValid() or ((1105 + 191) >= (5386 - (850 + 90)))) then
			if ((not v13:AffectingCombat() and v30) or ((2439 - 1046) > (5879 - (360 + 1030)))) then
				local v186 = v116();
				if (v186 or ((3916 + 508) < (76 - 49))) then
					return v186;
				end
			end
			if ((not v13:IsCasting() and not v13:IsChanneling()) or ((2747 - 750) > (5476 - (909 + 752)))) then
				local v187 = 1223 - (109 + 1114);
				local v188;
				while true do
					if (((6343 - 2878) > (745 + 1168)) and ((244 - (6 + 236)) == v187)) then
						v188 = v50.InterruptWithStun(v52.AxeToss, 26 + 14, true);
						if (((591 + 142) < (4289 - 2470)) and v188) then
							return v188;
						end
						v188 = v50.InterruptWithStun(v52.AxeToss, 69 - 29, true, v15, v58.AxeTossMouseover);
						if (v188 or ((5528 - (1076 + 57)) == (782 + 3973))) then
							return v188;
						end
						break;
					end
					if ((v187 == (690 - (579 + 110))) or ((300 + 3493) < (2095 + 274))) then
						v188 = v50.Interrupt(v52.AxeToss, 22 + 18, true);
						if (v188 or ((4491 - (174 + 233)) == (740 - 475))) then
							return v188;
						end
						v188 = v50.Interrupt(v52.AxeToss, 70 - 30, true, v15, v58.AxeTossMouseover);
						if (((1938 + 2420) == (5532 - (663 + 511))) and v188) then
							return v188;
						end
						v187 = 2 + 0;
					end
					if ((v187 == (0 + 0)) or ((9674 - 6536) < (602 + 391))) then
						v188 = v50.Interrupt(v52.SpellLock, 94 - 54, true);
						if (((8061 - 4731) > (1109 + 1214)) and v188) then
							return v188;
						end
						v188 = v50.Interrupt(v52.SpellLock, 77 - 37, true, v15, v58.SpellLockMouseover);
						if (v188 or ((2585 + 1041) == (365 + 3624))) then
							return v188;
						end
						v187 = 723 - (478 + 244);
					end
				end
			end
			v117();
			if (((v61 > (518 - (440 + 77))) and (v61 < (2 + 1))) or ((3352 - 2436) == (4227 - (655 + 901)))) then
				local v189 = 0 + 0;
				local v190;
				while true do
					if (((209 + 63) == (184 + 88)) and (v189 == (0 - 0))) then
						v190 = v122();
						if (((5694 - (695 + 750)) <= (16523 - 11684)) and v190) then
							return v190;
						end
						break;
					end
				end
			end
			if (((4285 - 1508) < (12869 - 9669)) and (v61 > (353 - (285 + 66)))) then
				local v191 = v121();
				if (((221 - 126) < (3267 - (682 + 628))) and v191) then
					return v191;
				end
			end
			if (((134 + 692) < (2016 - (176 + 123))) and v24()) then
				local v192 = 0 + 0;
				local v193;
				while true do
					if (((1035 + 391) >= (1374 - (239 + 30))) and (v192 == (0 + 0))) then
						v193 = v120();
						if (((2647 + 107) <= (5980 - 2601)) and v193) then
							return v193;
						end
						break;
					end
				end
			end
			if (v34 or ((12251 - 8324) == (1728 - (306 + 9)))) then
				local v194 = 0 - 0;
				local v195;
				while true do
					if (((0 + 0) == v194) or ((709 + 445) <= (380 + 408))) then
						v195 = v119();
						if (v195 or ((4698 - 3055) > (4754 - (1140 + 235)))) then
							return v195;
						end
						break;
					end
				end
			end
			if ((v52.MaleficRapture:IsReady() and v52.DreadTouch:IsAvailable() and (v17:DebuffRemains(v52.DreadTouchDebuff) < (2 + 0)) and (v17:DebuffRemains(v52.AgonyDebuff) > v78) and v17:DebuffUp(v52.CorruptionDebuff) and (not v52.SiphonLife:IsAvailable() or v17:DebuffUp(v52.SiphonLifeDebuff)) and v17:DebuffUp(v52.UnstableAfflictionDebuff) and (not v52.PhantomSingularity:IsAvailable() or v52.PhantomSingularity:CooldownDown()) and (not v52.VileTaint:IsAvailable() or v52.VileTaint:CooldownDown()) and (not v52.SoulRot:IsAvailable() or v52.SoulRot:CooldownDown())) or ((2571 + 232) > (1168 + 3381))) then
				if (v25(v52.MaleficRapture, nil, nil, not v17:IsInRange(152 - (33 + 19))) or ((80 + 140) >= (9057 - 6035))) then
					return "malefic_rapture main 2";
				end
			end
			if (((1244 + 1578) == (5533 - 2711)) and v52.MaleficRapture:IsReady() and (v77 < (4 + 0))) then
				if (v25(v52.MaleficRapture, nil, nil, not v17:IsInRange(789 - (586 + 103))) or ((97 + 964) == (5716 - 3859))) then
					return "malefic_rapture main 4";
				end
			end
			if (((4248 - (1309 + 179)) > (2461 - 1097)) and v52.VileTaint:IsReady() and (not v52.SoulRot:IsAvailable() or (v69 < (1.5 + 0)) or (v52.SoulRot:CooldownRemains() <= (v52.VileTaint:ExecuteTime() + v78)) or (not v52.SouleatersGluttony:IsAvailable() and (v52.SoulRot:CooldownRemains() >= (32 - 20))))) then
				if (v25(v52.VileTaint, v46, nil, not v17:IsInRange(31 + 9)) or ((10414 - 5512) <= (7163 - 3568))) then
					return "vile_taint main 6";
				end
			end
			if ((v52.PhantomSingularity:IsCastable() and ((v52.SoulRot:CooldownRemains() <= v52.PhantomSingularity:ExecuteTime()) or (not v52.SouleatersGluttony:IsAvailable() and (not v52.SoulRot:IsAvailable() or (v52.SoulRot:CooldownRemains() <= v52.PhantomSingularity:ExecuteTime()) or (v52.SoulRot:CooldownRemains() >= (634 - (295 + 314)))))) and v17:DebuffUp(v52.AgonyDebuff)) or ((9461 - 5609) == (2255 - (1300 + 662)))) then
				if (v25(v52.PhantomSingularity, v47, nil, not v17:IsSpellInRange(v52.PhantomSingularity)) or ((4895 - 3336) == (6343 - (1178 + 577)))) then
					return "phantom_singularity main 8";
				end
			end
			if ((v52.SoulRot:IsReady() and v63 and (v62 or (v52.SouleatersGluttony:TalentRank() ~= (1 + 0))) and v17:DebuffUp(v52.AgonyDebuff)) or ((13255 - 8771) == (2193 - (851 + 554)))) then
				if (((4040 + 528) >= (10835 - 6928)) and v25(v52.SoulRot, nil, nil, not v17:IsSpellInRange(v52.SoulRot))) then
					return "soul_rot main 10";
				end
			end
			if (((2705 - 1459) < (3772 - (115 + 187))) and v52.Agony:IsCastable() and (not v52.VileTaint:IsAvailable() or (v17:DebuffRemains(v52.AgonyDebuff) < (v52.VileTaint:CooldownRemains() + v52.VileTaint:CastTime()))) and (v17:DebuffRemains(v52.AgonyDebuff) < (4 + 1)) and (v77 > (5 + 0))) then
				if (((16030 - 11962) >= (2133 - (160 + 1001))) and v25(v52.Agony, nil, nil, not v17:IsSpellInRange(v52.Agony))) then
					return "agony main 12";
				end
			end
			if (((432 + 61) < (2687 + 1206)) and v52.UnstableAffliction:IsReady() and (v17:DebuffRemains(v52.UnstableAfflictionDebuff) < (10 - 5)) and (v77 > (361 - (237 + 121)))) then
				if (v25(v52.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v52.UnstableAffliction)) or ((2370 - (525 + 372)) >= (6316 - 2984))) then
					return "unstable_affliction main 14";
				end
			end
			if ((v52.Haunt:IsReady() and (v17:DebuffRemains(v52.HauntDebuff) < (16 - 11))) or ((4193 - (96 + 46)) <= (1934 - (643 + 134)))) then
				if (((219 + 385) < (6907 - 4026)) and v25(v52.Haunt, nil, nil, not v17:IsSpellInRange(v52.Haunt))) then
					return "haunt main 16";
				end
			end
			if ((v52.Corruption:IsCastable() and v17:DebuffRefreshable(v52.CorruptionDebuff) and (v77 > (18 - 13))) or ((864 + 36) == (6627 - 3250))) then
				if (((9114 - 4655) > (1310 - (316 + 403))) and v25(v52.Corruption, nil, nil, not v17:IsSpellInRange(v52.Corruption))) then
					return "corruption main 18";
				end
			end
			if (((2259 + 1139) >= (6584 - 4189)) and v52.SiphonLife:IsCastable() and v17:DebuffRefreshable(v52.SiphonLifeDebuff) and (v77 > (2 + 3))) then
				if (v25(v52.SiphonLife, nil, nil, not v17:IsSpellInRange(v52.SiphonLife)) or ((5497 - 3314) >= (2002 + 822))) then
					return "siphon_life main 20";
				end
			end
			if (((624 + 1312) == (6708 - 4772)) and v52.SummonDarkglare:IsReady() and (not v52.ShadowEmbrace:IsAvailable() or (v17:DebuffStack(v52.ShadowEmbraceDebuff) == (14 - 11))) and v62 and v63 and v65) then
				if (v25(v52.SummonDarkglare, v48) or ((10037 - 5205) < (247 + 4066))) then
					return "summon_darkglare main 22";
				end
			end
			if (((8047 - 3959) > (190 + 3684)) and v52.DrainSoul:IsReady() and v52.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v52.ShadowEmbraceDebuff) < (8 - 5)) or (v17:DebuffRemains(v52.ShadowEmbraceDebuff) < (20 - (12 + 5))))) then
				if (((16825 - 12493) == (9242 - 4910)) and v25(v52.DrainSoul, nil, nil, not v17:IsSpellInRange(v52.DrainSoul))) then
					return "drain_soul main 24";
				end
			end
			if (((8500 - 4501) >= (7191 - 4291)) and v52.ShadowBolt:IsReady() and v52.ShadowEmbrace:IsAvailable() and ((v17:DebuffStack(v52.ShadowEmbraceDebuff) < (1 + 2)) or (v17:DebuffRemains(v52.ShadowEmbraceDebuff) < (1976 - (1656 + 317))))) then
				if (v25(v52.ShadowBolt, nil, nil, not v17:IsSpellInRange(v52.ShadowBolt)) or ((2251 + 274) > (3257 + 807))) then
					return "shadow_bolt main 26";
				end
			end
			if (((11622 - 7251) == (21512 - 17141)) and v52.MaleficRapture:IsReady() and ((v75 > (358 - (5 + 349))) or (v52.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v52.TormentedCrescendoBuff) == (4 - 3)) and (v75 > (1274 - (266 + 1005)))) or (v52.TormentedCrescendo:IsAvailable() and v13:BuffUp(v52.TormentedCrescendoBuff) and v17:DebuffDown(v52.DreadTouchDebuff)) or (v52.TormentedCrescendo:IsAvailable() and (v13:BuffStack(v52.TormentedCrescendoBuff) == (2 + 0))) or v66 or (v64 and (v75 > (3 - 2))) or (v52.TormentedCrescendo:IsAvailable() and v52.Nightfall:IsAvailable() and v13:BuffUp(v52.TormentedCrescendoBuff) and v13:BuffUp(v52.NightfallBuff)))) then
				if (v25(v52.MaleficRapture, nil, nil, not v17:IsInRange(131 - 31)) or ((1962 - (561 + 1135)) > (6496 - 1510))) then
					return "malefic_rapture main 28";
				end
			end
			if (((6544 - 4553) >= (1991 - (507 + 559))) and v52.DrainLife:IsReady() and ((v13:BuffStack(v52.InevitableDemiseBuff) > (120 - 72)) or ((v13:BuffStack(v52.InevitableDemiseBuff) > (61 - 41)) and (v77 < (392 - (212 + 176)))))) then
				if (((1360 - (250 + 655)) < (5598 - 3545)) and v25(v52.DrainLife, nil, nil, not v17:IsSpellInRange(v52.DrainLife))) then
					return "drain_life main 30";
				end
			end
			if ((v52.DrainSoul:IsReady() and (v13:BuffUp(v52.NightfallBuff))) or ((1443 - 617) == (7589 - 2738))) then
				if (((2139 - (1869 + 87)) == (634 - 451)) and v25(v52.DrainSoul, nil, nil, not v17:IsSpellInRange(v52.DrainSoul))) then
					return "drain_soul main 32";
				end
			end
			if (((3060 - (484 + 1417)) <= (3832 - 2044)) and v52.ShadowBolt:IsReady() and (v13:BuffUp(v52.NightfallBuff))) then
				if (v25(v52.ShadowBolt, nil, nil, not v17:IsSpellInRange(v52.ShadowBolt)) or ((5877 - 2370) > (5091 - (48 + 725)))) then
					return "shadow_bolt main 34";
				end
			end
			if (v52.DrainSoul:IsReady() or ((5023 - 1948) <= (7954 - 4989))) then
				if (((794 + 571) <= (5374 - 3363)) and v25(v52.DrainSoul, nil, nil, not v17:IsSpellInRange(v52.DrainSoul))) then
					return "drain_soul main 36";
				end
			end
			if (v52.ShadowBolt:IsReady() or ((777 + 1999) > (1042 + 2533))) then
				if (v25(v52.ShadowBolt, nil, nil, not v17:IsSpellInRange(v52.ShadowBolt)) or ((3407 - (152 + 701)) == (6115 - (430 + 881)))) then
					return "shadow_bolt main 38";
				end
			end
		end
	end
	local function v124()
		v20.Print("Affliction Warlock rotation by Epic. Supported by Gojira");
		v52.AgonyDebuff:RegisterAuraTracking();
		v52.SiphonLifeDebuff:RegisterAuraTracking();
		v52.CorruptionDebuff:RegisterAuraTracking();
		v52.SiphonLifeDebuff:RegisterAuraTracking();
		v52.UnstableAfflictionDebuff:RegisterAuraTracking();
		v20.Print("Affliction Warlock rotation has been updated");
	end
	v20.SetAPL(102 + 163, v123, v124);
end;
return v1["Epix_Warlock_Affliction.lua"](...);

