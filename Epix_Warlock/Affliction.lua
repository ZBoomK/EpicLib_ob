local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 0 + 0;
	local v7;
	while true do
		if (((47 + 588) == (30 + 605)) and (v6 == (1598 - (978 + 619)))) then
			return v7(v0, ...);
		end
		if (((4727 - (243 + 1111)) <= (3249 + 307)) and (v6 == (158 - (91 + 67)))) then
			v7 = v1[v5];
			if (not v7 or ((9794 - 6503) < (819 + 2461))) then
				return v2(v5, v0, ...);
			end
			v6 = 524 - (423 + 100);
		end
	end
end
v1["Epix_Warlock_Affliction.lua"] = function(...)
	local v8, v9 = ...;
	local v10 = EpicDBC.DBC;
	local v11 = EpicLib;
	local v12 = EpicCache;
	local v13 = v11.Unit;
	local v14 = v13.Player;
	local v15 = v13.Focus;
	local v16 = v13.MouseOver;
	local v17 = v13.Pet;
	local v18 = v13.Target;
	local v19 = v11.Spell;
	local v20 = v11.Item;
	local v21 = v11.Bind;
	local v22 = v11.Macro;
	local v23 = v11.AoEON;
	local v24 = v11.CDsON;
	local v25 = v11.Cast;
	local v26 = v11.Press;
	local v27 = v11.Commons.Everyone.num;
	local v28 = v11.Commons.Everyone.bool;
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
		v34 = EpicSettings.Settings['UseTrinkets'];
		v33 = EpicSettings.Settings['UseRacials'];
		v35 = EpicSettings.Settings['UseHealingPotion'];
		v36 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
		v37 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v38 = EpicSettings.Settings['UseHealthstone'];
		v39 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v40 = EpicSettings.Settings['InterruptWithStun'] or (771 - (326 + 445));
		v41 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
		v42 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v44 = EpicSettings.Settings['SummonPet'];
		v45 = EpicSettings.Settings['DarkPactHP'] or (0 - 0);
		v46 = EpicSettings.Settings['VileTaint'];
		v47 = EpicSettings.Settings['PhantomSingularity'];
		v48 = EpicSettings.Settings['SummonDarkglare'];
	end
	local v50 = v11.Commons.Everyone;
	local v51 = v11.Commons.Warlock;
	local v52 = v19.Warlock.Affliction;
	local v53 = v20.Warlock.Affliction;
	local v54 = {v53.ConjuredChillglobe:ID(),v53.DesperateInvokersCodex:ID(),v53.BelorrelostheSuncaller:ID(),v53.TimeThiefsGambit:ID()};
	local v55 = v14:GetEquipment();
	local v56 = (v55[29 - 16] and v20(v55[37 - 24])) or v20(0 + 0);
	local v57 = (v55[24 - 10] and v20(v55[28 - 14])) or v20(1812 - (1293 + 519));
	local v58 = v22.Warlock.Affliction;
	local v59, v60, v61;
	local v62, v63, v64, v65, v66, v67, v68;
	local v69, v70, v71, v72;
	local v73 = ((v52.DrainSoul:IsAvailable()) and v52.DrainSoul) or v52.ShadowBolt;
	local v74 = 0 - 0;
	local v75 = 29010 - 17899;
	local v76 = 21247 - 10136;
	local v77;
	local v78 = v56:ID();
	local v79 = v57:ID();
	local v80 = v56:HasUseBuff();
	local v81 = v57:HasUseBuff();
	local v82 = (v80 and (((v56:Cooldown() % (129 - 99)) == (0 - 0)) or (((16 + 14) % v56:Cooldown()) == (0 + 0))) and (2 - 1)) or (0.5 + 0);
	local v83 = (v81 and (((v57:Cooldown() % (10 + 20)) == (0 + 0)) or (((1126 - (709 + 387)) % v57:Cooldown()) == (1858 - (673 + 1185)))) and (2 - 1)) or (0.5 - 0);
	local v84 = (v78 == v53.BelorrelostheSuncaller:ID()) or (v78 == v53.TimeThiefsGambit:ID());
	local v85 = (v79 == v53.BelorrelostheSuncaller:ID()) or (v79 == v53.TimeThiefsGambit:ID());
	local v86 = (v78 == v53.RubyWhelpShell:ID()) or (v78 == v53.WhisperingIncarnateIcon:ID());
	local v87 = (v79 == v53.RubyWhelpShell:ID()) or (v79 == v53.WhisperingIncarnateIcon:ID());
	local v88 = v56:BuffDuration() + (v27(v78 == v53.MirrorofFracturedTomorrows:ID()) * (32 - 12)) + (v27(v78 == v53.NymuesUnravelingSpindle:ID()) * (2 + 0));
	local v89 = v57:BuffDuration() + (v27(v79 == v53.MirrorofFracturedTomorrows:ID()) * (15 + 5)) + (v27(v79 == v53.NymuesUnravelingSpindle:ID()) * (2 - 0));
	local v90 = (((not v80 and v81) or (v81 and (((v57:Cooldown() / v89) * v83 * ((1 + 0) - ((0.5 - 0) * v27((v79 == v53.MirrorofFracturedTomorrows:ID()) or (v79 == v53.AshesoftheEmbersoul:ID()))))) > ((v56:Cooldown() / v88) * v82 * ((1 - 0) - ((1880.5 - (446 + 1434)) * v27((v78 == v53.MirrorofFracturedTomorrows:ID()) or (v78 == v53.AshesoftheEmbersoul:ID())))))))) and (1285 - (1040 + 243))) or (2 - 1);
	v11:RegisterForEvent(function()
		local v132 = 1847 - (559 + 1288);
		while true do
			if (((6317 - (609 + 1322)) >= (1327 - (13 + 441))) and (v132 == (3 - 2))) then
				v52.Haunt:RegisterInFlight();
				v73 = ((v52.DrainSoul:IsAvailable()) and v52.DrainSoul) or v52.ShadowBolt;
				break;
			end
			if (((2412 - 1491) <= (5488 - 4386)) and (v132 == (0 + 0))) then
				v52.SeedofCorruption:RegisterInFlight();
				v52.ShadowBolt:RegisterInFlight();
				v132 = 3 - 2;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v52.SeedofCorruption:RegisterInFlight();
	v52.ShadowBolt:RegisterInFlight();
	v52.Haunt:RegisterInFlight();
	v11:RegisterForEvent(function()
		local v133 = 0 + 0;
		while true do
			if (((2063 + 2643) >= (2857 - 1894)) and (v133 == (3 + 1))) then
				v87 = (v79 == v53.RubyWhelpShell:ID()) or (v79 == v53.WhisperingIncarnateIcon:ID());
				v88 = v56:BuffDuration() + (v27(v78 == v53.MirrorofFracturedTomorrows:ID()) * (36 - 16)) + (v27(v78 == v53.NymuesUnravelingSpindle:ID()) * (2 + 0));
				v89 = v57:BuffDuration() + (v27(v79 == v53.MirrorofFracturedTomorrows:ID()) * (12 + 8)) + (v27(v79 == v53.NymuesUnravelingSpindle:ID()) * (2 + 0));
				v133 = 5 + 0;
			end
			if ((v133 == (3 + 0)) or ((1393 - (153 + 280)) <= (2529 - 1653))) then
				v84 = (v78 == v53.BelorrelostheSuncaller:ID()) or (v78 == v53.TimeThiefsGambit:ID());
				v85 = (v79 == v53.BelorrelostheSuncaller:ID()) or (v79 == v53.TimeThiefsGambit:ID());
				v86 = (v78 == v53.RubyWhelpShell:ID()) or (v78 == v53.WhisperingIncarnateIcon:ID());
				v133 = 4 + 0;
			end
			if ((v133 == (0 + 0)) or ((1082 + 984) == (846 + 86))) then
				v55 = v14:GetEquipment();
				v56 = (v55[10 + 3] and v20(v55[19 - 6])) or v20(0 + 0);
				v57 = (v55[681 - (89 + 578)] and v20(v55[11 + 3])) or v20(0 - 0);
				v133 = 1050 - (572 + 477);
			end
			if (((651 + 4174) < (2907 + 1936)) and ((1 + 4) == v133)) then
				v90 = (((not v80 and v81) or (v81 and (((v57:Cooldown() / v89) * v83 * ((87 - (84 + 2)) - ((0.5 - 0) * v27((v79 == v53.MirrorofFracturedTomorrows:ID()) or (v79 == v53.AshesoftheEmbersoul:ID()))))) > ((v56:Cooldown() / v88) * v82 * ((1 + 0) - ((842.5 - (497 + 345)) * v27((v78 == v53.MirrorofFracturedTomorrows:ID()) or (v78 == v53.AshesoftheEmbersoul:ID())))))))) and (1 + 1)) or (1 + 0);
				break;
			end
			if ((v133 == (1335 - (605 + 728))) or ((2767 + 1110) >= (10086 - 5549))) then
				v81 = v57:HasUseBuff();
				v82 = (v80 and (((v56:Cooldown() % (2 + 28)) == (0 - 0)) or (((28 + 2) % v56:Cooldown()) == (0 - 0))) and (1 + 0)) or (489.5 - (457 + 32));
				v83 = (v81 and (((v57:Cooldown() % (13 + 17)) == (1402 - (832 + 570))) or (((29 + 1) % v57:Cooldown()) == (0 + 0))) and (3 - 2)) or (0.5 + 0);
				v133 = 799 - (588 + 208);
			end
			if ((v133 == (2 - 1)) or ((6115 - (884 + 916)) < (3613 - 1887))) then
				v78 = v56:ID();
				v79 = v57:ID();
				v80 = v56:HasUseBuff();
				v133 = 2 + 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v11:RegisterForEvent(function()
		local v134 = 653 - (232 + 421);
		while true do
			if ((v134 == (1889 - (1569 + 320))) or ((903 + 2776) < (119 + 506))) then
				v75 = 37441 - 26330;
				v76 = 11716 - (316 + 289);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v91(v135, v136)
		local v137 = 0 - 0;
		local v138;
		while true do
			if ((v137 == (0 + 0)) or ((6078 - (666 + 787)) < (1057 - (360 + 65)))) then
				if (not v135 or not v136 or ((78 + 5) > (2034 - (79 + 175)))) then
					return 0 - 0;
				end
				v138 = nil;
				v137 = 1 + 0;
			end
			if (((1673 - 1127) <= (2073 - 996)) and (v137 == (900 - (503 + 396)))) then
				for v180, v181 in pairs(v135) do
					local v182 = v181:DebuffRemains(v136) + ((280 - (92 + 89)) * v27(v181:DebuffDown(v136)));
					if ((v138 == nil) or (v182 < v138) or ((1931 - 935) > (2206 + 2095))) then
						v138 = v182;
					end
				end
				return v138 or (0 + 0);
			end
		end
	end
	local function v92(v139)
		if (((15938 - 11868) > (94 + 593)) and (not v139 or (#v139 == (0 - 0)))) then
			return false;
		end
		if (v52.SeedofCorruption:InFlight() or v14:PrevGCDP(1 + 0, v52.SeedofCorruption) or ((314 + 342) >= (10142 - 6812))) then
			return false;
		end
		local v140 = 0 + 0;
		local v141 = 0 - 0;
		for v171, v172 in pairs(v139) do
			local v173 = 1244 - (485 + 759);
			while true do
				if ((v173 == (0 - 0)) or ((3681 - (442 + 747)) <= (1470 - (832 + 303)))) then
					v140 = v140 + (947 - (88 + 858));
					if (((1318 + 3004) >= (2121 + 441)) and v172:DebuffUp(v52.SeedofCorruptionDebuff)) then
						v141 = v141 + 1 + 0;
					end
					break;
				end
			end
		end
		return v140 == v141;
	end
	local function v93()
		return v51.GuardiansTable.DarkglareDuration > (789 - (766 + 23));
	end
	local function v94()
		return v51.GuardiansTable.DarkglareDuration;
	end
	local function v95(v142)
		return (v142:DebuffRemains(v52.AgonyDebuff));
	end
	local function v96(v143)
		return (v143:DebuffRemains(v52.CorruptionDebuff));
	end
	local function v97(v144)
		return (v144:DebuffRemains(v52.ShadowEmbraceDebuff));
	end
	local function v98(v145)
		return (v145:DebuffRemains(v52.SiphonLifeDebuff));
	end
	local function v99(v146)
		return (v146:DebuffRemains(v52.SoulRotDebuff));
	end
	local function v100(v147)
		return (v147:DebuffRemains(v52.AgonyDebuff) < (v147:DebuffRemains(v52.VileTaintDebuff) + v52.VileTaint:CastTime())) and (v147:DebuffRemains(v52.AgonyDebuff) < (24 - 19));
	end
	local function v101(v148)
		return v148:DebuffRemains(v52.AgonyDebuff) < (6 - 1);
	end
	local function v102(v149)
		return ((v149:DebuffRemains(v52.AgonyDebuff) < (v52.VileTaint:CooldownRemains() + v52.VileTaint:CastTime())) or not v52.VileTaint:IsAvailable()) and (v149:DebuffRemains(v52.AgonyDebuff) < (13 - 8));
	end
	local function v103(v150)
		return ((v150:DebuffRemains(v52.AgonyDebuff) < (v52.VileTaint:CooldownRemains() + v52.VileTaint:CastTime())) or not v52.VileTaint:IsAvailable()) and (v150:DebuffRemains(v52.AgonyDebuff) < (16 - 11)) and (v76 > (1078 - (1036 + 37)));
	end
	local function v104(v151)
		return v151:DebuffRemains(v52.CorruptionDebuff) < (4 + 1);
	end
	local function v105(v152)
		return (v52.ShadowEmbrace:IsAvailable() and ((v152:DebuffStack(v52.ShadowEmbraceDebuff) < (5 - 2)) or (v152:DebuffRemains(v52.ShadowEmbraceDebuff) < (3 + 0)))) or not v52.ShadowEmbrace:IsAvailable();
	end
	local function v106(v153)
		return (v153:DebuffRefreshable(v52.SiphonLifeDebuff));
	end
	local function v107(v154)
		return v154:DebuffRemains(v52.AgonyDebuff) < (1485 - (641 + 839));
	end
	local function v108(v155)
		return (v155:DebuffRefreshable(v52.AgonyDebuff));
	end
	local function v109(v156)
		return v156:DebuffRemains(v52.CorruptionDebuff) < (918 - (910 + 3));
	end
	local function v110(v157)
		return (v157:DebuffRefreshable(v52.CorruptionDebuff));
	end
	local function v111(v158)
		return (v158:DebuffStack(v52.ShadowEmbraceDebuff) < (7 - 4)) or (v158:DebuffRemains(v52.ShadowEmbraceDebuff) < (1687 - (1466 + 218)));
	end
	local function v112(v159)
		return (v52.ShadowEmbrace:IsAvailable() and ((v159:DebuffStack(v52.ShadowEmbraceDebuff) < (2 + 1)) or (v159:DebuffRemains(v52.ShadowEmbraceDebuff) < (1151 - (556 + 592))))) or not v52.ShadowEmbrace:IsAvailable();
	end
	local function v113(v160)
		return v160:DebuffRemains(v52.SiphonLifeDebuff) < (2 + 3);
	end
	local function v114(v161)
		return (v161:DebuffRemains(v52.SiphonLifeDebuff) < (813 - (329 + 479))) and v161:DebuffUp(v52.AgonyDebuff);
	end
	local function v115()
		if (v52.GrimoireofSacrifice:IsCastable() or ((4491 - (174 + 680)) >= (12954 - 9184))) then
			if (v26(v52.GrimoireofSacrifice) or ((4930 - 2551) > (3269 + 1309))) then
				return "grimoire_of_sacrifice precombat 2";
			end
		end
		if (v52.Haunt:IsReady() or ((1222 - (396 + 343)) > (66 + 677))) then
			if (((3931 - (29 + 1448)) > (1967 - (135 + 1254))) and v26(v52.Haunt, not v18:IsSpellInRange(v52.Haunt), true)) then
				return "haunt precombat 6";
			end
		end
		if (((3503 - 2573) < (20814 - 16356)) and v52.UnstableAffliction:IsReady() and not v52.SoulSwap:IsAvailable()) then
			if (((442 + 220) <= (2499 - (389 + 1138))) and v26(v52.UnstableAffliction, not v18:IsSpellInRange(v52.UnstableAffliction), true)) then
				return "unstable_affliction precombat 8";
			end
		end
		if (((4944 - (102 + 472)) == (4124 + 246)) and v52.ShadowBolt:IsReady()) then
			if (v26(v52.ShadowBolt, not v18:IsSpellInRange(v52.ShadowBolt), true) or ((2641 + 2121) <= (803 + 58))) then
				return "shadow_bolt precombat 10";
			end
		end
	end
	local function v116()
		v62 = v18:DebuffUp(v52.PhantomSingularityDebuff) or not v52.PhantomSingularity:IsAvailable();
		v63 = v18:DebuffUp(v52.VileTaintDebuff) or not v52.VileTaint:IsAvailable();
		v64 = v18:DebuffUp(v52.VileTaintDebuff) or v18:DebuffUp(v52.PhantomSingularityDebuff) or (not v52.VileTaint:IsAvailable() and not v52.PhantomSingularity:IsAvailable());
		v65 = v18:DebuffUp(v52.SoulRotDebuff) or not v52.SoulRot:IsAvailable();
		v66 = v62 and v63 and v65;
		v67 = v52.PhantomSingularity:IsAvailable() or v52.VileTaint:IsAvailable() or v52.SoulRot:IsAvailable() or v52.SummonDarkglare:IsAvailable();
		v68 = not v67 or (v66 and ((v52.SummonDarkglare:CooldownRemains() > (1565 - (320 + 1225))) or not v52.SummonDarkglare:IsAvailable()));
	end
	local function v117()
		local v162 = v50.HandleTopTrinket(v54, v32, 71 - 31, nil);
		if (v162 or ((864 + 548) == (5728 - (157 + 1307)))) then
			return v162;
		end
		local v162 = v50.HandleBottomTrinket(v54, v32, 1899 - (821 + 1038), nil);
		if (v162 or ((7904 - 4736) < (236 + 1917))) then
			return v162;
		end
	end
	local function v118()
		local v163 = 0 - 0;
		local v164;
		while true do
			if (((1 + 0) == v163) or ((12333 - 7357) < (2358 - (834 + 192)))) then
				if (((295 + 4333) == (1188 + 3440)) and v53.DesperateInvokersCodex:IsEquippedAndReady()) then
					if (v26(v58.DesperateInvokersCodex, not v18:IsInRange(1 + 44)) or ((83 - 29) == (699 - (300 + 4)))) then
						return "desperate_invokers_codex items 2";
					end
				end
				if (((22 + 60) == (214 - 132)) and v53.ConjuredChillglobe:IsEquippedAndReady()) then
					if (v26(v58.ConjuredChillglobe) or ((943 - (112 + 250)) < (113 + 169))) then
						return "conjured_chillglobe items 4";
					end
				end
				break;
			end
			if (((0 - 0) == v163) or ((2641 + 1968) < (1291 + 1204))) then
				v164 = v117();
				if (((862 + 290) == (572 + 580)) and v164) then
					return v164;
				end
				v163 = 1 + 0;
			end
		end
	end
	local function v119()
		if (((3310 - (1001 + 413)) <= (7630 - 4208)) and v68) then
			local v175 = 882 - (244 + 638);
			local v176;
			while true do
				if ((v175 == (694 - (627 + 66))) or ((2949 - 1959) > (2222 - (512 + 90)))) then
					if (v52.Berserking:IsCastable() or ((2783 - (1665 + 241)) > (5412 - (373 + 344)))) then
						if (((1214 + 1477) >= (490 + 1361)) and v26(v52.Berserking)) then
							return "berserking ogcd 4";
						end
					end
					if (v52.BloodFury:IsCastable() or ((7873 - 4888) >= (8217 - 3361))) then
						if (((5375 - (35 + 1064)) >= (870 + 325)) and v26(v52.BloodFury)) then
							return "blood_fury ogcd 6";
						end
					end
					v175 = 4 - 2;
				end
				if (((13 + 3219) <= (5926 - (298 + 938))) and ((1261 - (233 + 1026)) == v175)) then
					if (v52.Fireblood:IsCastable() or ((2562 - (636 + 1030)) >= (1609 + 1537))) then
						if (((2990 + 71) >= (879 + 2079)) and v26(v52.Fireblood)) then
							return "fireblood ogcd 8";
						end
					end
					break;
				end
				if (((216 + 2971) >= (865 - (55 + 166))) and (v175 == (0 + 0))) then
					v176 = v50.HandleDPSPotion();
					if (((65 + 579) <= (2688 - 1984)) and v176) then
						return v176;
					end
					v175 = 298 - (36 + 261);
				end
			end
		end
	end
	local function v120()
		local v165 = 0 - 0;
		local v166;
		while true do
			if (((2326 - (34 + 1334)) > (365 + 582)) and (v165 == (4 + 1))) then
				if (((5775 - (1035 + 248)) >= (2675 - (20 + 1))) and v52.SummonSoulkeeper:IsReady() and ((v52.SummonSoulkeeper:Count() == (6 + 4)) or ((v52.SummonSoulkeeper:Count() > (322 - (134 + 185))) and (v76 < (1143 - (549 + 584)))))) then
					if (((4127 - (314 + 371)) >= (5159 - 3656)) and v25(v52.SummonSoulkeeper)) then
						return "soul_strike aoe 32";
					end
				end
				if ((v52.SiphonLife:IsReady() and (v52.SiphonLifeDebuff:AuraActiveCount() < (973 - (478 + 490))) and ((v61 < (5 + 3)) or not v52.DoomBlossom:IsAvailable())) or ((4342 - (786 + 386)) <= (4741 - 3277))) then
					if (v50.CastCycle(v52.SiphonLife, v59, v113, not v18:IsSpellInRange(v52.SiphonLife)) or ((6176 - (1055 + 324)) == (5728 - (1093 + 247)))) then
						return "siphon_life aoe 34";
					end
				end
				if (((490 + 61) <= (72 + 609)) and v52.DrainSoul:IsReady()) then
					if (((13010 - 9733) > (1381 - 974)) and v50.CastCycle(v52.DrainSoul, v59, v112, not v18:IsSpellInRange(v52.DrainSoul))) then
						return "drain_soul aoe 36";
					end
				end
				if (((13359 - 8664) >= (3555 - 2140)) and v52.ShadowBolt:IsReady()) then
					if (v25(v52.ShadowBolt, nil, nil, not v18:IsSpellInRange(v52.ShadowBolt)) or ((1143 + 2069) <= (3636 - 2692))) then
						return "shadow_bolt aoe 38";
					end
				end
				break;
			end
			if ((v165 == (6 - 4)) or ((2335 + 761) <= (4597 - 2799))) then
				if (((4225 - (364 + 324)) == (9696 - 6159)) and v52.SiphonLife:IsReady() and (v52.SiphonLifeDebuff:AuraActiveCount() < (14 - 8)) and v52.SummonDarkglare:CooldownUp() and (HL.CombatTime() < (7 + 13)) and (((v77 * (8 - 6)) + v52.SoulRot:CastTime()) < v72)) then
					if (((6144 - 2307) >= (4768 - 3198)) and v50.CastCycle(v52.SiphonLife, v59, v114, not v18:IsSpellInRange(v52.SiphonLife))) then
						return "siphon_life aoe 10";
					end
				end
				if ((v52.SoulRot:IsReady() and v63 and (v62 or (v52.SouleatersGluttony:TalentRank() ~= (1269 - (1249 + 19)))) and v18:DebuffUp(v52.AgonyDebuff)) or ((2663 + 287) == (14838 - 11026))) then
					if (((5809 - (686 + 400)) >= (1819 + 499)) and v25(v52.SoulRot, nil, nil, not v18:IsSpellInRange(v52.SoulRot))) then
						return "soul_rot aoe 12";
					end
				end
				if ((v52.SeedofCorruption:IsReady() and (v18:DebuffRemains(v52.CorruptionDebuff) < (234 - (73 + 156))) and not (v52.SeedofCorruption:InFlight() or v18:DebuffUp(v52.SeedofCorruptionDebuff))) or ((10 + 2017) > (3663 - (721 + 90)))) then
					if (v25(v52.SeedofCorruption, nil, nil, not v18:IsSpellInRange(v52.SeedofCorruption)) or ((13 + 1123) > (14016 - 9699))) then
						return "seed_of_corruption aoe 14";
					end
				end
				if (((5218 - (224 + 246)) == (7691 - 2943)) and v52.Corruption:IsReady() and not v52.SeedofCorruption:IsAvailable()) then
					if (((6878 - 3142) <= (860 + 3880)) and v50.CastTargetIf(v52.Corruption, v59, "min", v96, v104, not v18:IsSpellInRange(v52.Corruption))) then
						return "corruption aoe 15";
					end
				end
				v165 = 1 + 2;
			end
			if ((v165 == (3 + 0)) or ((6739 - 3349) <= (10183 - 7123))) then
				if ((v32 and v52.SummonDarkglare:IsCastable() and v62 and v63 and v65) or ((1512 - (203 + 310)) > (4686 - (1238 + 755)))) then
					if (((33 + 430) < (2135 - (709 + 825))) and v25(v52.SummonDarkglare, v48)) then
						return "summon_darkglare aoe 18";
					end
				end
				if ((v52.DrainLife:IsReady() and (v14:BuffStack(v52.InevitableDemiseBuff) > (55 - 25)) and v14:BuffUp(v52.SoulRot) and (v14:BuffRemains(v52.SoulRot) <= v77) and (v61 > (3 - 0))) or ((3047 - (196 + 668)) < (2712 - 2025))) then
					if (((9422 - 4873) == (5382 - (171 + 662))) and v50.CastTargetIf(v52.DrainLife, v59, "min", v99, nil, not v18:IsSpellInRange(v52.DrainLife))) then
						return "drain_life aoe 19";
					end
				end
				if (((4765 - (4 + 89)) == (16375 - 11703)) and v52.MaleficRapture:IsReady() and v14:BuffUp(v52.UmbrafireKindlingBuff) and ((((v61 < (3 + 3)) or (HL.CombatTime() < (131 - 101))) and v93()) or not v52.DoomBlossom:IsAvailable())) then
					if (v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(40 + 60)) or ((5154 - (35 + 1451)) < (1848 - (28 + 1425)))) then
						return "malefic_rapture aoe 20";
					end
				end
				if ((v52.SeedofCorruption:IsReady() and v52.SowTheSeeds:IsAvailable()) or ((6159 - (941 + 1052)) == (437 + 18))) then
					if (v25(v52.SeedofCorruption, nil, nil, not v18:IsSpellInRange(v52.SeedofCorruption)) or ((5963 - (822 + 692)) == (3801 - 1138))) then
						return "seed_of_corruption aoe 22";
					end
				end
				v165 = 2 + 2;
			end
			if ((v165 == (297 - (45 + 252))) or ((4232 + 45) < (1029 + 1960))) then
				if (v32 or ((2117 - 1247) >= (4582 - (114 + 319)))) then
					local v183 = v119();
					if (((3175 - 963) < (4078 - 895)) and v183) then
						return v183;
					end
				end
				v166 = v118();
				if (((2962 + 1684) > (4456 - 1464)) and v166) then
					return v166;
				end
				if (((3004 - 1570) < (5069 - (556 + 1407))) and v52.Haunt:IsReady() and (v18:DebuffRemains(v52.HauntDebuff) < (1209 - (741 + 465)))) then
					if (((1251 - (170 + 295)) < (1593 + 1430)) and v25(v52.Haunt, nil, nil, not v18:IsSpellInRange(v52.Haunt))) then
						return "haunt aoe 2";
					end
				end
				v165 = 1 + 0;
			end
			if ((v165 == (2 - 1)) or ((2025 + 417) < (48 + 26))) then
				if (((2569 + 1966) == (5765 - (957 + 273))) and v52.VileTaint:IsReady() and (((v52.SouleatersGluttony:TalentRank() == (1 + 1)) and ((v69 < (1.5 + 0)) or (v52.SoulRot:CooldownRemains() <= v52.VileTaint:ExecuteTime()))) or ((v52.SouleatersGluttony:TalentRank() == (3 - 2)) and (v52.SoulRot:CooldownRemains() <= v52.VileTaint:ExecuteTime())) or (not v52.SouleatersGluttony:IsAvailable() and ((v52.SoulRot:CooldownRemains() <= v52.VileTaint:ExecuteTime()) or (v52.VileTaint:CooldownRemains() > (65 - 40)))))) then
					if (v25(v58.VileTaintCursor, nil, nil, not v18:IsInRange(122 - 82)) or ((14899 - 11890) <= (3885 - (389 + 1391)))) then
						return "vile_taint aoe 4";
					end
				end
				if (((1149 + 681) < (382 + 3287)) and v52.PhantomSingularity:IsCastable() and ((v52.SoulRot:IsAvailable() and (v52.SoulRot:CooldownRemains() <= v52.PhantomSingularity:ExecuteTime())) or (not v52.SouleatersGluttony:IsAvailable() and (not v52.SoulRot:IsAvailable() or (v52.SoulRot:CooldownRemains() <= v52.PhantomSingularity:ExecuteTime()) or (v52.SoulRot:CooldownRemains() >= (56 - 31))))) and v18:DebuffUp(v52.AgonyDebuff)) then
					if (v25(v52.PhantomSingularity, v47, nil, not v18:IsSpellInRange(v52.PhantomSingularity)) or ((2381 - (783 + 168)) >= (12122 - 8510))) then
						return "phantom_singularity aoe 6";
					end
				end
				if (((2640 + 43) >= (2771 - (309 + 2))) and v52.UnstableAffliction:IsReady() and (v18:DebuffRemains(v52.UnstableAfflictionDebuff) < (15 - 10))) then
					if (v25(v52.UnstableAffliction, nil, nil, not v18:IsSpellInRange(v52.UnstableAffliction)) or ((3016 - (1090 + 122)) >= (1062 + 2213))) then
						return "unstable_affliction aoe 8";
					end
				end
				if ((v52.Agony:IsReady() and (v52.AgonyDebuff:AuraActiveCount() < (26 - 18)) and (((v77 * (2 + 0)) + v52.SoulRot:CastTime()) < v72)) or ((2535 - (628 + 490)) > (651 + 2978))) then
					if (((11872 - 7077) > (1837 - 1435)) and v50.CastTargetIf(v52.Agony, v59, "min", v95, v102, not v18:IsSpellInRange(v52.Agony))) then
						return "agony aoe 9";
					end
				end
				v165 = 776 - (431 + 343);
			end
			if (((9720 - 4907) > (10313 - 6748)) and (v165 == (4 + 0))) then
				if (((501 + 3411) == (5607 - (556 + 1139))) and v52.MaleficRapture:IsReady() and ((((v52.SummonDarkglare:CooldownRemains() > (30 - (6 + 9))) or (v74 > (1 + 2))) and not v52.SowTheSeeds:IsAvailable()) or v14:BuffUp(v52.TormentedCrescendoBuff))) then
					if (((1446 + 1375) <= (4993 - (28 + 141))) and v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(39 + 61))) then
						return "malefic_rapture aoe 24";
					end
				end
				if (((2144 - 406) <= (1555 + 640)) and v52.DrainLife:IsReady() and (v18:DebuffUp(v52.SoulRotDebuff) or not v52.SoulRot:IsAvailable()) and (v14:BuffStack(v52.InevitableDemiseBuff) > (1327 - (486 + 831)))) then
					if (((106 - 65) <= (10625 - 7607)) and v25(v52.DrainLife, nil, nil, not v18:IsSpellInRange(v52.DrainLife))) then
						return "drain_life aoe 26";
					end
				end
				if (((406 + 1739) <= (12976 - 8872)) and v52.DrainSoul:IsReady() and v14:BuffUp(v52.NightfallBuff) and v52.ShadowEmbrace:IsAvailable()) then
					if (((3952 - (668 + 595)) < (4360 + 485)) and v50.CastCycle(v52.DrainSoul, v59, v111, not v18:IsSpellInRange(v52.DrainSoul))) then
						return "drain_soul aoe 28";
					end
				end
				if ((v52.DrainSoul:IsReady() and (v14:BuffUp(v52.NightfallBuff))) or ((469 + 1853) > (7150 - 4528))) then
					if (v25(v52.DrainSoul, nil, nil, not v18:IsSpellInRange(v52.DrainSoul)) or ((4824 - (23 + 267)) == (4026 - (1129 + 815)))) then
						return "drain_soul aoe 30";
					end
				end
				v165 = 392 - (371 + 16);
			end
		end
	end
	local function v121()
		local v167 = 1750 - (1326 + 424);
		local v168;
		while true do
			if ((v167 == (0 - 0)) or ((5740 - 4169) > (1985 - (88 + 30)))) then
				if (v32 or ((3425 - (720 + 51)) >= (6664 - 3668))) then
					local v184 = 1776 - (421 + 1355);
					local v185;
					while true do
						if (((6562 - 2584) > (1034 + 1070)) and ((1083 - (286 + 797)) == v184)) then
							v185 = v119();
							if (((10948 - 7953) > (2552 - 1011)) and v185) then
								return v185;
							end
							break;
						end
					end
				end
				v168 = v118();
				if (((3688 - (397 + 42)) > (298 + 655)) and v168) then
					return v168;
				end
				v167 = 801 - (24 + 776);
			end
			if ((v167 == (2 - 0)) or ((4058 - (222 + 563)) > (10075 - 5502))) then
				if ((v52.VileTaint:IsReady() and (v52.AgonyDebuff:AuraActiveCount() == (2 + 0)) and (v52.CorruptionDebuff:AuraActiveCount() == (192 - (23 + 167))) and (not v52.SiphonLife:IsAvailable() or (v52.SiphonLifeDebuff:AuraActiveCount() == (1800 - (690 + 1108)))) and (not v52.SoulRot:IsAvailable() or (v52.SoulRot:CooldownRemains() <= v52.VileTaint:ExecuteTime()) or (not v52.SouleatersGluttony:IsAvailable() and (v52.SoulRot:CooldownRemains() >= (5 + 7))))) or ((2600 + 551) < (2132 - (40 + 808)))) then
					if (v25(v58.VileTaintCursor, nil, nil, not v18:IsSpellInRange(v52.VileTaint)) or ((305 + 1545) == (5846 - 4317))) then
						return "vile_taint cleave 10";
					end
				end
				if (((785 + 36) < (1124 + 999)) and v52.SoulRot:IsReady() and v63 and (v62 or (v52.SouleatersGluttony:TalentRank() ~= (1 + 0))) and (v52.AgonyDebuff:AuraActiveCount() >= (573 - (47 + 524)))) then
					if (((586 + 316) < (6355 - 4030)) and v25(v52.SoulRot, nil, nil, not v18:IsSpellInRange(v52.SoulRot))) then
						return "soul_rot cleave 8";
					end
				end
				if (((1282 - 424) <= (6755 - 3793)) and v52.Agony:IsReady()) then
					if (v50.CastTargetIf(v52.Agony, v59, "min", v95, v103, not v18:IsSpellInRange(v52.Agony)) or ((5672 - (1165 + 561)) < (39 + 1249))) then
						return "agony cleave 10";
					end
				end
				v167 = 9 - 6;
			end
			if (((2 + 3) == v167) or ((3721 - (341 + 138)) == (154 + 413))) then
				if ((v52.MaleficRapture:IsReady() and v52.TormentedCrescendo:IsAvailable() and (v14:BuffStack(v52.TormentedCrescendoBuff) == (1 - 0)) and (v74 > (329 - (89 + 237)))) or ((2724 - 1877) >= (2658 - 1395))) then
					if (v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(981 - (581 + 300))) or ((3473 - (855 + 365)) == (4396 - 2545))) then
						return "malefic_rapture cleave 24";
					end
				end
				if ((v52.DrainSoul:IsReady() and v52.ShadowEmbrace:IsAvailable() and ((v18:DebuffStack(v52.ShadowEmbraceDebuff) < (1 + 2)) or (v18:DebuffRemains(v52.ShadowEmbraceDebuff) < (1238 - (1030 + 205))))) or ((1960 + 127) > (2207 + 165))) then
					if (v25(v52.DrainSoul, nil, nil, not v18:IsSpellInRange(v52.DrainSoul)) or ((4731 - (156 + 130)) < (9427 - 5278))) then
						return "drain_soul cleave 26";
					end
				end
				if ((v73:IsReady() and (v14:BuffUp(v52.NightfallBuff))) or ((3063 - 1245) == (174 - 89))) then
					if (((167 + 463) < (1241 + 886)) and v50.CastTargetIf(v73, v59, "min", v97, v105, not v18:IsSpellInRange(v73))) then
						return "drain_soul/shadow_bolt cleave 28";
					end
				end
				v167 = 75 - (10 + 59);
			end
			if ((v167 == (2 + 2)) or ((9544 - 7606) == (3677 - (671 + 492)))) then
				if (((3388 + 867) >= (1270 - (369 + 846))) and v52.Corruption:IsReady() and not (v52.SeedofCorruption:InFlight() or (v18:DebuffRemains(v52.SeedofCorruptionDebuff) > (0 + 0))) and (v76 > (5 + 0))) then
					if (((4944 - (1036 + 909)) > (920 + 236)) and v50.CastTargetIf(v52.Corruption, v59, "min", v96, v104, not v18:IsSpellInRange(v52.Corruption))) then
						return "corruption cleave 18";
					end
				end
				if (((3945 - 1595) > (1358 - (11 + 192))) and v52.SiphonLife:IsReady() and (v76 > (3 + 2))) then
					if (((4204 - (135 + 40)) <= (11757 - 6904)) and v50.CastTargetIf(v52.SiphonLife, v59, "min", v98, v106, not v18:IsSpellInRange(v52.SiphonLife))) then
						return "siphon_life cleave 20";
					end
				end
				if ((v52.SummonDarkglare:IsReady() and (not v52.ShadowEmbrace:IsAvailable() or (v18:DebuffStack(v52.ShadowEmbraceDebuff) == (2 + 1))) and v62 and v63 and v65) or ((1136 - 620) > (5147 - 1713))) then
					if (((4222 - (50 + 126)) >= (8445 - 5412)) and v25(v52.SummonDarkglare, v48)) then
						return "summon_darkglare cleave 22";
					end
				end
				v167 = 2 + 3;
			end
			if ((v167 == (1419 - (1233 + 180))) or ((3688 - (522 + 447)) <= (2868 - (107 + 1314)))) then
				if ((v52.MaleficRapture:IsReady() and not v52.DreadTouch:IsAvailable() and v14:BuffUp(v52.TormentedCrescendoBuff)) or ((1919 + 2215) < (11962 - 8036))) then
					if (v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(43 + 57)) or ((325 - 161) >= (11019 - 8234))) then
						return "malefic_rapture cleave 30";
					end
				end
				if ((v52.MaleficRapture:IsReady() and (v66 or v64)) or ((2435 - (716 + 1194)) == (37 + 2072))) then
					if (((4 + 29) == (536 - (74 + 429))) and v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(192 - 92))) then
						return "malefic_rapture cleave 32";
					end
				end
				if (((1514 + 1540) <= (9190 - 5175)) and v52.MaleficRapture:IsReady() and (v74 > (3 + 0))) then
					if (((5768 - 3897) < (8361 - 4979)) and v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(533 - (279 + 154)))) then
						return "malefic_rapture cleave 34";
					end
				end
				v167 = 785 - (454 + 324);
			end
			if (((1018 + 275) <= (2183 - (12 + 5))) and (v167 == (2 + 1))) then
				if ((v52.UnstableAffliction:IsReady() and (v18:DebuffRemains(v52.UnstableAfflictionDebuff) < (12 - 7)) and (v76 > (2 + 1))) or ((3672 - (277 + 816)) < (525 - 402))) then
					if (v25(v52.UnstableAffliction, nil, nil, not v18:IsSpellInRange(v52.UnstableAffliction)) or ((2029 - (1058 + 125)) >= (444 + 1924))) then
						return "unstable_affliction cleave 12";
					end
				end
				if ((v52.SeedofCorruption:IsReady() and not v52.AbsoluteCorruption:IsAvailable() and (v18:DebuffRemains(v52.CorruptionDebuff) < (980 - (815 + 160))) and v52.SowTheSeeds:IsAvailable() and v92(v59)) or ((17214 - 13202) <= (7971 - 4613))) then
					if (((357 + 1137) <= (8784 - 5779)) and v25(v52.SeedofCorruption, nil, nil, not v18:IsSpellInRange(v52.SeedofCorruption))) then
						return "seed_of_corruption cleave 14";
					end
				end
				if ((v52.Haunt:IsReady() and (v18:DebuffRemains(v52.HauntDebuff) < (1901 - (41 + 1857)))) or ((5004 - (1222 + 671)) == (5515 - 3381))) then
					if (((3384 - 1029) == (3537 - (229 + 953))) and v25(v52.Haunt, nil, nil, not v18:IsSpellInRange(v52.Haunt))) then
						return "haunt cleave 16";
					end
				end
				v167 = 1778 - (1111 + 663);
			end
			if ((v167 == (1587 - (874 + 705))) or ((83 + 505) <= (295 + 137))) then
				if (((9970 - 5173) >= (110 + 3785)) and v52.Corruption:IsCastable()) then
					if (((4256 - (642 + 37)) == (816 + 2761)) and v50.CastCycle(v52.Corruption, v59, v110, not v18:IsSpellInRange(v52.Corruption))) then
						return "corruption cleave 42";
					end
				end
				if (((607 + 3187) > (9271 - 5578)) and v52.MaleficRapture:IsReady() and (v74 > (455 - (233 + 221)))) then
					if (v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(231 - 131)) or ((1123 + 152) == (5641 - (718 + 823)))) then
						return "malefic_rapture cleave 44";
					end
				end
				if (v52.DrainSoul:IsReady() or ((1002 + 589) >= (4385 - (266 + 539)))) then
					if (((2782 - 1799) <= (3033 - (636 + 589))) and v25(v52.DrainSoul, nil, nil, not v18:IsSpellInRange(v52.DrainSoul))) then
						return "drain_soul cleave 54";
					end
				end
				v167 = 20 - 11;
			end
			if ((v167 == (18 - 9)) or ((1704 + 446) <= (435 + 762))) then
				if (((4784 - (657 + 358)) >= (3105 - 1932)) and v73:IsReady()) then
					if (((3383 - 1898) == (2672 - (1151 + 36))) and v25(v73, nil, nil, not v18:IsSpellInRange(v73))) then
						return "drain_soul/shadow_bolt cleave 46";
					end
				end
				break;
			end
			if ((v167 == (1 + 0)) or ((872 + 2443) <= (8308 - 5526))) then
				if ((v32 and v52.SummonDarkglare:IsCastable() and v62 and v63 and v65) or ((2708 - (1552 + 280)) >= (3798 - (64 + 770)))) then
					if (v25(v52.SummonDarkglare, v48) or ((1516 + 716) > (5667 - 3170))) then
						return "summon_darkglare cleave 2";
					end
				end
				if ((v52.MaleficRapture:IsReady() and ((v52.DreadTouch:IsAvailable() and (v18:DebuffRemains(v52.DreadTouchDebuff) < (1 + 1)) and (v18:DebuffRemains(v52.AgonyDebuff) > v77) and v18:DebuffUp(v52.CorruptionDebuff) and (not v52.SiphonLife:IsAvailable() or v18:DebuffUp(v52.SiphonLifeDebuff)) and v18:DebuffUp(v52.UnstableAfflictionDebuff) and (not v52.PhantomSingularity:IsAvailable() or v52.PhantomSingularity:CooldownDown()) and (not v52.VileTaint:IsAvailable() or v52.VileTaint:CooldownDown()) and (not v52.SoulRot:IsAvailable() or v52.SoulRot:CooldownDown())) or (v74 > (1247 - (157 + 1086))))) or ((4223 - 2113) <= (1453 - 1121))) then
					if (((5653 - 1967) > (4328 - 1156)) and v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(919 - (599 + 220)))) then
						return "malefic_rapture cleave 2";
					end
				end
				if ((v52.VileTaint:IsReady() and (not v52.SoulRot:IsAvailable() or (v69 < (1.5 - 0)) or (v52.SoulRot:CooldownRemains() <= (v52.VileTaint:ExecuteTime() + v77)) or (not v52.SouleatersGluttony:IsAvailable() and (v52.SoulRot:CooldownRemains() >= (1943 - (1813 + 118)))))) or ((3271 + 1203) < (2037 - (841 + 376)))) then
					if (((5995 - 1716) >= (670 + 2212)) and v25(v52.VileTaint, nil, nil, not v18:IsInRange(109 - 69))) then
						return "vile_taint cleave 4";
					end
				end
				v167 = 861 - (464 + 395);
			end
			if (((17 - 10) == v167) or ((975 + 1054) >= (4358 - (467 + 370)))) then
				if ((v52.DrainLife:IsReady() and ((v14:BuffStack(v52.InevitableDemiseBuff) > (98 - 50)) or ((v14:BuffStack(v52.InevitableDemiseBuff) > (15 + 5)) and (v76 < (13 - 9))))) or ((318 + 1719) >= (10799 - 6157))) then
					if (((2240 - (150 + 370)) < (5740 - (74 + 1208))) and v25(v52.DrainLife, nil, nil, not v18:IsSpellInRange(v52.DrainLife))) then
						return "drain_life cleave 36";
					end
				end
				if ((v52.DrainLife:IsReady() and v14:BuffUp(v52.SoulRot) and (v14:BuffStack(v52.InevitableDemiseBuff) > (73 - 43))) or ((2067 - 1631) > (2150 + 871))) then
					if (((1103 - (14 + 376)) <= (1468 - 621)) and v25(v52.DrainLife, nil, nil, not v18:IsSpellInRange(v52.DrainLife))) then
						return "drain_life cleave 38";
					end
				end
				if (((1394 + 760) <= (3542 + 489)) and v52.Agony:IsReady()) then
					if (((4402 + 213) == (13522 - 8907)) and v50.CastCycle(v52.Agony, v59, v108, not v18:IsSpellInRange(v52.Agony))) then
						return "agony cleave 40";
					end
				end
				v167 = 7 + 1;
			end
		end
	end
	local function v122()
		local v169 = 78 - (23 + 55);
		while true do
			if (((6 - 3) == v169) or ((2530 + 1260) == (449 + 51))) then
				v72 = v29(v70 * v27(v52.VileTaint:IsAvailable()), v71 * v27(v52.PhantomSingularity:IsAvailable()));
				v77 = v14:GCD() + (0.25 - 0);
				if (((28 + 61) < (1122 - (652 + 249))) and v52.SummonPet:IsCastable() and v44 and not v17:IsActive()) then
					if (((5496 - 3442) >= (3289 - (708 + 1160))) and v26(v52.SummonPet)) then
						return "summon_pet ooc";
					end
				end
				if (((1878 - 1186) < (5575 - 2517)) and v50.TargetIsValid()) then
					local v186 = 27 - (10 + 17);
					while true do
						if (((1 + 2) == v186) or ((4986 - (1400 + 332)) == (3174 - 1519))) then
							if ((v52.VileTaint:IsReady() and (not v52.SoulRot:IsAvailable() or (v69 < (1909.5 - (242 + 1666))) or (v52.SoulRot:CooldownRemains() <= (v52.VileTaint:ExecuteTime() + v77)) or (not v52.SouleatersGluttony:IsAvailable() and (v52.SoulRot:CooldownRemains() >= (6 + 6))))) or ((475 + 821) == (4185 + 725))) then
								if (((4308 - (850 + 90)) == (5898 - 2530)) and v25(v52.VileTaint, v46, nil, not v18:IsInRange(1430 - (360 + 1030)))) then
									return "vile_taint main 6";
								end
							end
							if (((2339 + 304) < (10767 - 6952)) and v52.PhantomSingularity:IsCastable() and ((v52.SoulRot:CooldownRemains() <= v52.PhantomSingularity:ExecuteTime()) or (not v52.SouleatersGluttony:IsAvailable() and (not v52.SoulRot:IsAvailable() or (v52.SoulRot:CooldownRemains() <= v52.PhantomSingularity:ExecuteTime()) or (v52.SoulRot:CooldownRemains() >= (33 - 8))))) and v18:DebuffUp(v52.AgonyDebuff)) then
								if (((3574 - (909 + 752)) > (1716 - (109 + 1114))) and v25(v52.PhantomSingularity, v47, nil, not v18:IsSpellInRange(v52.PhantomSingularity))) then
									return "phantom_singularity main 8";
								end
							end
							if (((8705 - 3950) > (1335 + 2093)) and v52.SoulRot:IsReady() and v63 and (v62 or (v52.SouleatersGluttony:TalentRank() ~= (243 - (6 + 236)))) and v18:DebuffUp(v52.AgonyDebuff)) then
								if (((871 + 510) <= (1907 + 462)) and v25(v52.SoulRot, nil, nil, not v18:IsSpellInRange(v52.SoulRot))) then
									return "soul_rot main 10";
								end
							end
							v186 = 8 - 4;
						end
						if (((8 - 3) == v186) or ((5976 - (1076 + 57)) == (672 + 3412))) then
							if (((5358 - (579 + 110)) > (29 + 334)) and v52.Corruption:IsCastable() and v18:DebuffRefreshable(v52.CorruptionDebuff) and (v76 > (5 + 0))) then
								if (v25(v52.Corruption, nil, nil, not v18:IsSpellInRange(v52.Corruption)) or ((997 + 880) >= (3545 - (174 + 233)))) then
									return "corruption main 18";
								end
							end
							if (((13245 - 8503) >= (6364 - 2738)) and v52.SiphonLife:IsCastable() and v18:DebuffRefreshable(v52.SiphonLifeDebuff) and (v76 > (3 + 2))) then
								if (v25(v52.SiphonLife, nil, nil, not v18:IsSpellInRange(v52.SiphonLife)) or ((5714 - (663 + 511)) == (818 + 98))) then
									return "siphon_life main 20";
								end
							end
							if ((v52.SummonDarkglare:IsReady() and (not v52.ShadowEmbrace:IsAvailable() or (v18:DebuffStack(v52.ShadowEmbraceDebuff) == (1 + 2))) and v62 and v63 and v65) or ((3563 - 2407) > (2632 + 1713))) then
								if (((5266 - 3029) < (10285 - 6036)) and v25(v52.SummonDarkglare, v48)) then
									return "summon_darkglare main 22";
								end
							end
							v186 = 3 + 3;
						end
						if ((v186 == (3 - 1)) or ((1913 + 770) < (3 + 20))) then
							if (((1419 - (478 + 244)) <= (1343 - (440 + 77))) and v34) then
								local v188 = 0 + 0;
								local v189;
								while true do
									if (((4044 - 2939) <= (2732 - (655 + 901))) and (v188 == (0 + 0))) then
										v189 = v118();
										if (((2587 + 792) <= (2574 + 1238)) and v189) then
											return v189;
										end
										break;
									end
								end
							end
							if ((v52.MaleficRapture:IsReady() and v52.DreadTouch:IsAvailable() and (v18:DebuffRemains(v52.DreadTouchDebuff) < (7 - 5)) and (v18:DebuffRemains(v52.AgonyDebuff) > v77) and v18:DebuffUp(v52.CorruptionDebuff) and (not v52.SiphonLife:IsAvailable() or v18:DebuffUp(v52.SiphonLifeDebuff)) and v18:DebuffUp(v52.UnstableAfflictionDebuff) and (not v52.PhantomSingularity:IsAvailable() or v52.PhantomSingularity:CooldownDown()) and (not v52.VileTaint:IsAvailable() or v52.VileTaint:CooldownDown()) and (not v52.SoulRot:IsAvailable() or v52.SoulRot:CooldownDown())) or ((2233 - (695 + 750)) >= (5517 - 3901))) then
								if (((2861 - 1007) <= (13589 - 10210)) and v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(451 - (285 + 66)))) then
									return "malefic_rapture main 2";
								end
							end
							if (((10603 - 6054) == (5859 - (682 + 628))) and v52.MaleficRapture:IsReady() and (v76 < (1 + 3))) then
								if (v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(399 - (176 + 123))) or ((1265 + 1757) >= (2194 + 830))) then
									return "malefic_rapture main 4";
								end
							end
							v186 = 272 - (239 + 30);
						end
						if (((1311 + 3509) > (2113 + 85)) and (v186 == (0 - 0))) then
							if ((not v14:AffectingCombat() and v30) or ((3310 - 2249) >= (5206 - (306 + 9)))) then
								local v190 = v115();
								if (((4759 - 3395) <= (778 + 3695)) and v190) then
									return v190;
								end
							end
							if ((not v14:IsCasting() and not v14:IsChanneling()) or ((2206 + 1389) <= (2 + 1))) then
								local v191 = 0 - 0;
								local v192;
								while true do
									if ((v191 == (1376 - (1140 + 235))) or ((2974 + 1698) == (3533 + 319))) then
										v192 = v50.Interrupt(v52.AxeToss, 11 + 29, true);
										if (((1611 - (33 + 19)) == (563 + 996)) and v192) then
											return v192;
										end
										v192 = v50.Interrupt(v52.AxeToss, 119 - 79, true, v16, v58.AxeTossMouseover);
										if (v192 or ((772 + 980) <= (1545 - 757))) then
											return v192;
										end
										v191 = 2 + 0;
									end
									if ((v191 == (691 - (586 + 103))) or ((356 + 3551) == (544 - 367))) then
										v192 = v50.InterruptWithStun(v52.AxeToss, 1528 - (1309 + 179), true);
										if (((6264 - 2794) > (242 + 313)) and v192) then
											return v192;
										end
										v192 = v50.InterruptWithStun(v52.AxeToss, 107 - 67, true, v16, v58.AxeTossMouseover);
										if (v192 or ((735 + 237) == (1370 - 725))) then
											return v192;
										end
										break;
									end
									if (((6340 - 3158) >= (2724 - (295 + 314))) and (v191 == (0 - 0))) then
										v192 = v50.Interrupt(v52.SpellLock, 2002 - (1300 + 662), true);
										if (((12224 - 8331) < (6184 - (1178 + 577))) and v192) then
											return v192;
										end
										v192 = v50.Interrupt(v52.SpellLock, 21 + 19, true, v16, v58.SpellLockMouseover);
										if (v192 or ((8475 - 5608) < (3310 - (851 + 554)))) then
											return v192;
										end
										v191 = 1 + 0;
									end
								end
							end
							v116();
							v186 = 2 - 1;
						end
						if ((v186 == (1 - 0)) or ((2098 - (115 + 187)) >= (3103 + 948))) then
							if (((1533 + 86) <= (14801 - 11045)) and (v61 > (1162 - (160 + 1001))) and (v61 < (3 + 0))) then
								local v193 = 0 + 0;
								local v194;
								while true do
									if (((1235 - 631) == (962 - (237 + 121))) and (v193 == (897 - (525 + 372)))) then
										v194 = v121();
										if (v194 or ((8500 - 4016) == (2957 - 2057))) then
											return v194;
										end
										break;
									end
								end
							end
							if ((v61 > (144 - (96 + 46))) or ((5236 - (643 + 134)) <= (402 + 711))) then
								local v195 = 0 - 0;
								local v196;
								while true do
									if (((13484 - 9852) > (3259 + 139)) and (v195 == (0 - 0))) then
										v196 = v120();
										if (((8343 - 4261) <= (5636 - (316 + 403))) and v196) then
											return v196;
										end
										break;
									end
								end
							end
							if (((3212 + 1620) >= (3810 - 2424)) and v24()) then
								local v197 = 0 + 0;
								local v198;
								while true do
									if (((344 - 207) == (98 + 39)) and (v197 == (0 + 0))) then
										v198 = v119();
										if (v198 or ((5440 - 3870) >= (20688 - 16356))) then
											return v198;
										end
										break;
									end
								end
							end
							v186 = 3 - 1;
						end
						if ((v186 == (1 + 6)) or ((7999 - 3935) <= (89 + 1730))) then
							if ((v52.DrainLife:IsReady() and ((v14:BuffStack(v52.InevitableDemiseBuff) > (141 - 93)) or ((v14:BuffStack(v52.InevitableDemiseBuff) > (37 - (12 + 5))) and (v76 < (15 - 11))))) or ((10637 - 5651) < (3345 - 1771))) then
								if (((10975 - 6549) > (35 + 137)) and v25(v52.DrainLife, nil, nil, not v18:IsSpellInRange(v52.DrainLife))) then
									return "drain_life main 30";
								end
							end
							if (((2559 - (1656 + 317)) > (406 + 49)) and v52.DrainSoul:IsReady() and (v14:BuffUp(v52.NightfallBuff))) then
								if (((662 + 164) == (2196 - 1370)) and v25(v52.DrainSoul, nil, nil, not v18:IsSpellInRange(v52.DrainSoul))) then
									return "drain_soul main 32";
								end
							end
							if ((v52.ShadowBolt:IsReady() and (v14:BuffUp(v52.NightfallBuff))) or ((19779 - 15760) > (4795 - (5 + 349)))) then
								if (((9580 - 7563) < (5532 - (266 + 1005))) and v25(v52.ShadowBolt, nil, nil, not v18:IsSpellInRange(v52.ShadowBolt))) then
									return "shadow_bolt main 34";
								end
							end
							v186 = 6 + 2;
						end
						if (((16091 - 11375) > (105 - 25)) and (v186 == (1700 - (561 + 1135)))) then
							if ((v52.Agony:IsCastable() and (not v52.VileTaint:IsAvailable() or (v18:DebuffRemains(v52.AgonyDebuff) < (v52.VileTaint:CooldownRemains() + v52.VileTaint:CastTime()))) and (v18:DebuffRemains(v52.AgonyDebuff) < (6 - 1)) and (v76 > (16 - 11))) or ((4573 - (507 + 559)) == (8210 - 4938))) then
								if (v25(v52.Agony, nil, nil, not v18:IsSpellInRange(v52.Agony)) or ((2709 - 1833) >= (3463 - (212 + 176)))) then
									return "agony main 12";
								end
							end
							if (((5257 - (250 + 655)) > (6964 - 4410)) and v52.UnstableAffliction:IsReady() and (v18:DebuffRemains(v52.UnstableAfflictionDebuff) < (8 - 3)) and (v76 > (4 - 1))) then
								if (v25(v52.UnstableAffliction, nil, nil, not v18:IsSpellInRange(v52.UnstableAffliction)) or ((6362 - (1869 + 87)) < (14022 - 9979))) then
									return "unstable_affliction main 14";
								end
							end
							if ((v52.Haunt:IsReady() and (v18:DebuffRemains(v52.HauntDebuff) < (1906 - (484 + 1417)))) or ((4048 - 2159) >= (5668 - 2285))) then
								if (((2665 - (48 + 725)) <= (4465 - 1731)) and v25(v52.Haunt, nil, nil, not v18:IsSpellInRange(v52.Haunt))) then
									return "haunt main 16";
								end
							end
							v186 = 13 - 8;
						end
						if (((1118 + 805) < (5927 - 3709)) and (v186 == (2 + 4))) then
							if (((634 + 1539) > (1232 - (152 + 701))) and v52.DrainSoul:IsReady() and v52.ShadowEmbrace:IsAvailable() and ((v18:DebuffStack(v52.ShadowEmbraceDebuff) < (1314 - (430 + 881))) or (v18:DebuffRemains(v52.ShadowEmbraceDebuff) < (2 + 1)))) then
								if (v25(v52.DrainSoul, nil, nil, not v18:IsSpellInRange(v52.DrainSoul)) or ((3486 - (557 + 338)) == (1008 + 2401))) then
									return "drain_soul main 24";
								end
							end
							if (((12720 - 8206) > (11639 - 8315)) and v52.ShadowBolt:IsReady() and v52.ShadowEmbrace:IsAvailable() and ((v18:DebuffStack(v52.ShadowEmbraceDebuff) < (7 - 4)) or (v18:DebuffRemains(v52.ShadowEmbraceDebuff) < (6 - 3)))) then
								if (v25(v52.ShadowBolt, nil, nil, not v18:IsSpellInRange(v52.ShadowBolt)) or ((1009 - (499 + 302)) >= (5694 - (39 + 827)))) then
									return "shadow_bolt main 26";
								end
							end
							if ((v52.MaleficRapture:IsReady() and ((v74 > (10 - 6)) or (v52.TormentedCrescendo:IsAvailable() and (v14:BuffStack(v52.TormentedCrescendoBuff) == (2 - 1)) and (v74 > (11 - 8))) or (v52.TormentedCrescendo:IsAvailable() and v14:BuffUp(v52.TormentedCrescendoBuff) and v18:DebuffDown(v52.DreadTouchDebuff)) or (v52.TormentedCrescendo:IsAvailable() and (v14:BuffStack(v52.TormentedCrescendoBuff) == (2 - 0))) or v66 or (v64 and (v74 > (1 + 0))) or (v52.TormentedCrescendo:IsAvailable() and v52.Nightfall:IsAvailable() and v14:BuffUp(v52.TormentedCrescendoBuff) and v14:BuffUp(v52.NightfallBuff)))) or ((4633 - 3050) > (571 + 2996))) then
								if (v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(158 - 58)) or ((1417 - (103 + 1)) == (1348 - (475 + 79)))) then
									return "malefic_rapture main 28";
								end
							end
							v186 = 14 - 7;
						end
						if (((10156 - 6982) > (376 + 2526)) and (v186 == (8 + 0))) then
							if (((5623 - (1395 + 108)) <= (12396 - 8136)) and v52.DrainSoul:IsReady()) then
								if (v25(v52.DrainSoul, nil, nil, not v18:IsSpellInRange(v52.DrainSoul)) or ((2087 - (7 + 1197)) > (2084 + 2694))) then
									return "drain_soul main 36";
								end
							end
							if (v52.ShadowBolt:IsReady() or ((1264 + 2356) >= (5210 - (27 + 292)))) then
								if (((12477 - 8219) > (1194 - 257)) and v25(v52.ShadowBolt, nil, nil, not v18:IsSpellInRange(v52.ShadowBolt))) then
									return "shadow_bolt main 38";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((4 - 3) == v169) or ((9601 - 4732) < (1725 - 819))) then
				v59 = v14:GetEnemiesInRange(179 - (43 + 96));
				v60 = v18:GetEnemiesInSplashRange(40 - 30);
				if (v31 or ((2769 - 1544) > (3509 + 719))) then
					v61 = v18:GetEnemiesInSplashRangeCount(3 + 7);
				else
					v61 = 1 - 0;
				end
				if (((1276 + 2052) > (4194 - 1956)) and (v50.TargetIsValid() or v14:AffectingCombat())) then
					local v187 = 0 + 0;
					while true do
						if (((282 + 3557) > (3156 - (1414 + 337))) and (v187 == (1940 - (1642 + 298)))) then
							v75 = v11.BossFightRemains(nil, true);
							v76 = v75;
							v187 = 2 - 1;
						end
						if ((v187 == (2 - 1)) or ((3836 - 2543) <= (167 + 340))) then
							if ((v76 == (8645 + 2466)) or ((3868 - (357 + 615)) < (566 + 239))) then
								v76 = v11.FightRemains(v60, false);
							end
							break;
						end
					end
				end
				v169 = 4 - 2;
			end
			if (((1985 + 331) == (4963 - 2647)) and ((0 + 0) == v169)) then
				v49();
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v169 = 1 + 0;
			end
			if (((2 + 0) == v169) or ((3871 - (384 + 917)) == (2230 - (128 + 569)))) then
				v74 = v14:SoulShardsP();
				v69 = v91(v60, v52.AgonyDebuff);
				v70 = v91(v60, v52.VileTaintDebuff);
				v71 = v91(v60, v52.PhantomSingularityDebuff);
				v169 = 1546 - (1407 + 136);
			end
		end
	end
	local function v123()
		local v170 = 1887 - (687 + 1200);
		while true do
			if ((v170 == (1712 - (556 + 1154))) or ((3106 - 2223) == (1555 - (9 + 86)))) then
				v52.UnstableAfflictionDebuff:RegisterAuraTracking();
				break;
			end
			if ((v170 == (422 - (275 + 146))) or ((752 + 3867) <= (1063 - (29 + 35)))) then
				v52.SiphonLifeDebuff:RegisterAuraTracking();
				v52.CorruptionDebuff:RegisterAuraTracking();
				v170 = 8 - 6;
			end
			if ((v170 == (0 - 0)) or ((15053 - 11643) > (2681 + 1435))) then
				v11.Print("Affliction Warlock rotation by Epic. Supported by Gojira");
				v52.AgonyDebuff:RegisterAuraTracking();
				v170 = 1013 - (53 + 959);
			end
		end
	end
	v11.SetAPL(673 - (312 + 96), v122, v123);
end;
return v1["Epix_Warlock_Affliction.lua"](...);

