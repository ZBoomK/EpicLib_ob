local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 0 - 0;
	local v7;
	while true do
		if (((3049 - (400 + 150)) <= (10462 - 7050)) and (v6 == (1 + 0))) then
			return v7(v0, ...);
		end
		if (((3889 - (1607 + 27)) < (1303 + 3225)) and (v6 == (1726 - (1668 + 58)))) then
			v7 = v1[v5];
			if (not v7 or ((2031 - (512 + 114)) >= (8971 - 5530))) then
				return v2(v5, v0, ...);
			end
			v6 = 1 - 0;
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
	local v21 = EpicLib;
	local v22 = v21.Bind;
	local v23 = v21.Macro;
	local v24 = v21.AoEON;
	local v25 = v21.CDsON;
	local v26 = v21.Cast;
	local v27 = v21.Press;
	local v28 = v21.Commons.Everyone.num;
	local v29 = v21.Commons.Everyone.bool;
	local v30 = math.max;
	local v31 = false;
	local v32 = false;
	local v33 = false;
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
	local v49;
	local function v50()
		v35 = EpicSettings.Settings['UseTrinkets'];
		v34 = EpicSettings.Settings['UseRacials'];
		v36 = EpicSettings.Settings['UseHealingPotion'];
		v37 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
		v38 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v39 = EpicSettings.Settings['UseHealthstone'];
		v40 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v41 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
		v42 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
		v43 = EpicSettings.Settings['InterruptThreshold'] or (1994 - (109 + 1885));
		v45 = EpicSettings.Settings['SummonPet'];
		v46 = EpicSettings.Settings['DarkPactHP'] or (1469 - (1269 + 200));
		v47 = EpicSettings.Settings['VileTaint'];
		v48 = EpicSettings.Settings['PhantomSingularity'];
		v49 = EpicSettings.Settings['SummonDarkglare'];
	end
	local v51 = v21.Commons.Everyone;
	local v52 = v21.Commons.Warlock;
	local v53 = v19.Warlock.Affliction;
	local v54 = v20.Warlock.Affliction;
	local v55 = {v54.ConjuredChillglobe:ID(),v54.DesperateInvokersCodex:ID(),v54.BelorrelostheSuncaller:ID(),v54.TimeThiefsGambit:ID()};
	local v56 = v14:GetEquipment();
	local v57 = (v56[15 - 2] and v20(v56[2 + 11])) or v20(0 + 0);
	local v58 = (v56[3 + 11] and v20(v56[4 + 10])) or v20(0 - 0);
	local v59 = v23.Warlock.Affliction;
	local v60, v61, v62;
	local v63, v64, v65, v66, v67, v68, v69;
	local v70, v71, v72, v73;
	local v74 = ((v14:HasTier(103 - 72, 1 + 1)) and (5 + 7)) or (7 + 1);
	local v75 = ((v53.DrainSoul:IsAvailable()) and v53.DrainSoul) or v53.ShadowBolt;
	local v76 = 0 + 0;
	local v77 = 5188 + 5923;
	local v78 = 12544 - (797 + 636);
	local v79;
	local v80 = v57:ID();
	local v81 = v58:ID();
	local v82 = v57:HasUseBuff();
	local v83 = v58:HasUseBuff();
	local v84 = (v82 and (((v57:Cooldown() % (145 - 115)) == (1619 - (1427 + 192))) or (((11 + 19) % v57:Cooldown()) == (0 - 0))) and (1 + 0)) or (0.5 + 0);
	local v85 = (v83 and (((v58:Cooldown() % (356 - (192 + 134))) == (1276 - (316 + 960))) or (((17 + 13) % v58:Cooldown()) == (0 + 0))) and (1 + 0)) or (0.5 - 0);
	local v86 = (v80 == v54.BelorrelostheSuncaller:ID()) or (v80 == v54.TimeThiefsGambit:ID());
	local v87 = (v81 == v54.BelorrelostheSuncaller:ID()) or (v81 == v54.TimeThiefsGambit:ID());
	local v88 = (v80 == v54.RubyWhelpShell:ID()) or (v80 == v54.WhisperingIncarnateIcon:ID());
	local v89 = (v81 == v54.RubyWhelpShell:ID()) or (v81 == v54.WhisperingIncarnateIcon:ID());
	local v90 = v57:BuffDuration() + (v28(v80 == v54.MirrorofFracturedTomorrows:ID()) * (571 - (83 + 468))) + (v28(v80 == v54.NymuesUnravelingSpindle:ID()) * (1808 - (1202 + 604)));
	local v91 = v58:BuffDuration() + (v28(v81 == v54.MirrorofFracturedTomorrows:ID()) * (93 - 73)) + (v28(v81 == v54.NymuesUnravelingSpindle:ID()) * (2 - 0));
	local v92 = (((not v82 and v83) or (v83 and (((v58:Cooldown() / v91) * v85 * ((2 - 1) - ((325.5 - (45 + 280)) * v28((v81 == v54.MirrorofFracturedTomorrows:ID()) or (v81 == v54.AshesoftheEmbersoul:ID()))))) > ((v57:Cooldown() / v90) * v84 * ((1 + 0) - ((0.5 + 0) * v28((v80 == v54.MirrorofFracturedTomorrows:ID()) or (v80 == v54.AshesoftheEmbersoul:ID())))))))) and (1 + 1)) or (1 + 0);
	v11:RegisterForEvent(function()
		local v134 = 0 + 0;
		while true do
			if (((4386 - 2017) == (4280 - (340 + 1571))) and (v134 == (0 + 0))) then
				v53.SeedofCorruption:RegisterInFlight();
				v53.ShadowBolt:RegisterInFlight();
				v134 = 1773 - (1733 + 39);
			end
			if (((11252 - 7157) >= (4217 - (125 + 909))) and (v134 == (1949 - (1096 + 852)))) then
				v53.Haunt:RegisterInFlight();
				v75 = ((v53.DrainSoul:IsAvailable()) and v53.DrainSoul) or v53.ShadowBolt;
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v53.SeedofCorruption:RegisterInFlight();
	v53.ShadowBolt:RegisterInFlight();
	v53.Haunt:RegisterInFlight();
	v11:RegisterForEvent(function()
		v56 = v14:GetEquipment();
		v57 = (v56[6 + 7] and v20(v56[17 - 4])) or v20(0 + 0);
		v58 = (v56[526 - (409 + 103)] and v20(v56[250 - (46 + 190)])) or v20(95 - (51 + 44));
		v74 = ((v14:HasTier(9 + 22, 1319 - (1114 + 203))) and (738 - (228 + 498))) or (2 + 6);
		v80 = v57:ID();
		v81 = v58:ID();
		v82 = v57:HasUseBuff();
		v83 = v58:HasUseBuff();
		v84 = (v82 and (((v57:Cooldown() % (17 + 13)) == (663 - (174 + 489))) or (((78 - 48) % v57:Cooldown()) == (1905 - (830 + 1075)))) and (525 - (303 + 221))) or (1269.5 - (231 + 1038));
		v85 = (v83 and (((v58:Cooldown() % (25 + 5)) == (1162 - (171 + 991))) or (((123 - 93) % v58:Cooldown()) == (0 - 0))) and (2 - 1)) or (0.5 + 0);
		v86 = (v80 == v54.BelorrelostheSuncaller:ID()) or (v80 == v54.TimeThiefsGambit:ID());
		v87 = (v81 == v54.BelorrelostheSuncaller:ID()) or (v81 == v54.TimeThiefsGambit:ID());
		v88 = (v80 == v54.RubyWhelpShell:ID()) or (v80 == v54.WhisperingIncarnateIcon:ID());
		v89 = (v81 == v54.RubyWhelpShell:ID()) or (v81 == v54.WhisperingIncarnateIcon:ID());
		v90 = v57:BuffDuration() + (v28(v80 == v54.MirrorofFracturedTomorrows:ID()) * (70 - 50)) + (v28(v80 == v54.NymuesUnravelingSpindle:ID()) * (5 - 3));
		v91 = v58:BuffDuration() + (v28(v81 == v54.MirrorofFracturedTomorrows:ID()) * (32 - 12)) + (v28(v81 == v54.NymuesUnravelingSpindle:ID()) * (6 - 4));
		v92 = (((not v82 and v83) or (v83 and (((v58:Cooldown() / v91) * v85 * ((1249 - (111 + 1137)) - ((158.5 - (91 + 67)) * v28((v81 == v54.MirrorofFracturedTomorrows:ID()) or (v81 == v54.AshesoftheEmbersoul:ID()))))) > ((v57:Cooldown() / v90) * v84 * ((2 - 1) - ((0.5 + 0) * v28((v80 == v54.MirrorofFracturedTomorrows:ID()) or (v80 == v54.AshesoftheEmbersoul:ID())))))))) and (525 - (423 + 100))) or (1 + 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v11:RegisterForEvent(function()
		v77 = 30764 - 19653;
		v78 = 5792 + 5319;
	end, "PLAYER_REGEN_ENABLED");
	local function v93(v135, v136)
		local v137 = 771 - (326 + 445);
		local v138;
		while true do
			if (((4 - 3) == v137) or ((8267 - 4556) < (2352 - 1344))) then
				for v179, v180 in pairs(v135) do
					local v181 = v180:DebuffRemains(v136) + ((810 - (530 + 181)) * v28(v180:DebuffDown(v136)));
					if ((v138 == nil) or (v181 < v138) or ((1930 - (614 + 267)) <= (938 - (19 + 13)))) then
						v138 = v181;
					end
				end
				return v138 or (0 - 0);
			end
			if (((10516 - 6003) > (7787 - 5061)) and (v137 == (0 + 0))) then
				if (not v135 or not v136 or ((2604 - 1123) >= (5512 - 2854))) then
					return 1812 - (1293 + 519);
				end
				v138 = nil;
				v137 = 1 - 0;
			end
		end
	end
	local function v94(v139)
		local v140 = 0 - 0;
		local v141;
		local v142;
		while true do
			if ((v140 == (0 - 0)) or ((13884 - 10664) == (3213 - 1849))) then
				if (not v139 or (#v139 == (0 + 0)) or ((216 + 838) > (7880 - 4488))) then
					return false;
				end
				if (v53.SeedofCorruption:InFlight() or v14:PrevGCDP(1 + 0, v53.SeedofCorruption) or ((225 + 451) >= (1027 + 615))) then
					return false;
				end
				v140 = 1097 - (709 + 387);
			end
			if (((5994 - (673 + 1185)) > (6951 - 4554)) and (v140 == (6 - 4))) then
				for v182, v183 in pairs(v139) do
					local v184 = 0 - 0;
					while true do
						if ((v184 == (0 + 0)) or ((3239 + 1095) == (5730 - 1485))) then
							v141 = v141 + 1 + 0;
							if (v183:DebuffUp(v53.SeedofCorruptionDebuff) or ((8525 - 4249) <= (5949 - 2918))) then
								v142 = v142 + (1881 - (446 + 1434));
							end
							break;
						end
					end
				end
				return v141 == v142;
			end
			if ((v140 == (1284 - (1040 + 243))) or ((14272 - 9490) <= (3046 - (559 + 1288)))) then
				v141 = 1931 - (609 + 1322);
				v142 = 454 - (13 + 441);
				v140 = 7 - 5;
			end
		end
	end
	local function v95()
		return v52.GuardiansTable.DarkglareDuration > (0 - 0);
	end
	local function v96()
		return v52.GuardiansTable.DarkglareDuration;
	end
	local function v97(v143)
		return (v143:DebuffRemains(v53.AgonyDebuff));
	end
	local function v98(v144)
		return (v144:DebuffRemains(v53.CorruptionDebuff));
	end
	local function v99(v145)
		return (v145:DebuffRemains(v53.ShadowEmbraceDebuff));
	end
	local function v100(v146)
		return (v146:DebuffRemains(v53.SiphonLifeDebuff));
	end
	local function v101(v147)
		return (v147:DebuffRemains(v53.SoulRotDebuff));
	end
	local function v102(v148)
		return (v148:DebuffRemains(v53.AgonyDebuff) < (v148:DebuffRemains(v53.VileTaintDebuff) + v53.VileTaint:CastTime())) and (v148:DebuffRemains(v53.AgonyDebuff) < (24 - 19));
	end
	local function v103(v149)
		return v149:DebuffRemains(v53.AgonyDebuff) < (1 + 4);
	end
	local function v104(v150)
		return ((v150:DebuffRemains(v53.AgonyDebuff) < (v53.VileTaint:CooldownRemains() + v53.VileTaint:CastTime())) or not v53.VileTaint:IsAvailable()) and (v150:DebuffRemains(v53.AgonyDebuff) < (18 - 13));
	end
	local function v105(v151)
		return ((v151:DebuffRemains(v53.AgonyDebuff) < (v53.VileTaint:CooldownRemains() + v53.VileTaint:CastTime())) or not v53.VileTaint:IsAvailable()) and (v151:DebuffRemains(v53.AgonyDebuff) < (2 + 3)) and (v78 > (3 + 2));
	end
	local function v106(v152)
		return v152:DebuffRemains(v53.CorruptionDebuff) < (14 - 9);
	end
	local function v107(v153)
		return (v53.ShadowEmbrace:IsAvailable() and ((v153:DebuffStack(v53.ShadowEmbraceDebuff) < (2 + 1)) or (v153:DebuffRemains(v53.ShadowEmbraceDebuff) < (4 - 1)))) or not v53.ShadowEmbrace:IsAvailable();
	end
	local function v108(v154)
		return (v154:DebuffRefreshable(v53.SiphonLifeDebuff));
	end
	local function v109(v155)
		return v155:DebuffRemains(v53.AgonyDebuff) < (4 + 1);
	end
	local function v110(v156)
		return (v156:DebuffRefreshable(v53.AgonyDebuff));
	end
	local function v111(v157)
		return v157:DebuffRemains(v53.CorruptionDebuff) < (3 + 2);
	end
	local function v112(v158)
		return (v158:DebuffRefreshable(v53.CorruptionDebuff));
	end
	local function v113(v159)
		return (v159:DebuffStack(v53.ShadowEmbraceDebuff) < (3 + 0)) or (v159:DebuffRemains(v53.ShadowEmbraceDebuff) < (3 + 0));
	end
	local function v114(v160)
		return (v53.ShadowEmbrace:IsAvailable() and ((v160:DebuffStack(v53.ShadowEmbraceDebuff) < (3 + 0)) or (v160:DebuffRemains(v53.ShadowEmbraceDebuff) < (436 - (153 + 280))))) or not v53.ShadowEmbrace:IsAvailable();
	end
	local function v115(v161)
		return v161:DebuffRemains(v53.SiphonLifeDebuff) < (14 - 9);
	end
	local function v116(v162)
		return (v162:DebuffRemains(v53.SiphonLifeDebuff) < (5 + 0)) and v162:DebuffUp(v53.AgonyDebuff);
	end
	local function v117()
		local v163 = 0 + 0;
		while true do
			if ((v163 == (0 + 0)) or ((4414 + 450) < (1379 + 523))) then
				if (((7367 - 2528) >= (2287 + 1413)) and v53.GrimoireofSacrifice:IsCastable()) then
					if (v27(v53.GrimoireofSacrifice) or ((1742 - (89 + 578)) > (1371 + 547))) then
						return "grimoire_of_sacrifice precombat 2";
					end
				end
				if (((822 - 426) <= (4853 - (572 + 477))) and v53.Haunt:IsReady()) then
					if (v27(v53.Haunt, not v18:IsSpellInRange(v53.Haunt), true) or ((563 + 3606) == (1313 + 874))) then
						return "haunt precombat 6";
					end
				end
				v163 = 1 + 0;
			end
			if (((1492 - (84 + 2)) == (2316 - 910)) and (v163 == (1 + 0))) then
				if (((2373 - (497 + 345)) < (110 + 4161)) and v53.UnstableAffliction:IsReady() and not v53.SoulSwap:IsAvailable()) then
					if (((108 + 527) == (1968 - (605 + 728))) and v27(v53.UnstableAffliction, not v18:IsSpellInRange(v53.UnstableAffliction), true)) then
						return "unstable_affliction precombat 8";
					end
				end
				if (((2407 + 966) <= (7905 - 4349)) and v53.ShadowBolt:IsReady()) then
					if (v27(v53.ShadowBolt, not v18:IsSpellInRange(v53.ShadowBolt), true) or ((151 + 3140) < (12126 - 8846))) then
						return "shadow_bolt precombat 10";
					end
				end
				break;
			end
		end
	end
	local function v118()
		v63 = v18:DebuffUp(v53.PhantomSingularityDebuff) or not v53.PhantomSingularity:IsAvailable();
		v64 = v18:DebuffUp(v53.VileTaintDebuff) or not v53.VileTaint:IsAvailable();
		v65 = v18:DebuffUp(v53.VileTaintDebuff) or v18:DebuffUp(v53.PhantomSingularityDebuff) or (not v53.VileTaint:IsAvailable() and not v53.PhantomSingularity:IsAvailable());
		v66 = v18:DebuffUp(v53.SoulRotDebuff) or not v53.SoulRot:IsAvailable();
		v67 = v63 and v64 and v66;
		v68 = v53.PhantomSingularity:IsAvailable() or v53.VileTaint:IsAvailable() or v53.SoulRot:IsAvailable() or v53.SummonDarkglare:IsAvailable();
		v69 = not v68 or (v67 and ((v53.SummonDarkglare:CooldownRemains() > (19 + 1)) or not v53.SummonDarkglare:IsAvailable()));
	end
	local function v119()
		local v164 = 0 - 0;
		local v165;
		while true do
			if (((3312 + 1074) >= (1362 - (457 + 32))) and ((1 + 0) == v164)) then
				v165 = v51.HandleBottomTrinket(v55, v33, 1442 - (832 + 570), nil);
				if (((868 + 53) <= (288 + 814)) and v165) then
					return v165;
				end
				break;
			end
			if (((16653 - 11947) >= (464 + 499)) and ((796 - (588 + 208)) == v164)) then
				v165 = v51.HandleTopTrinket(v55, v33, 107 - 67, nil);
				if (v165 or ((2760 - (884 + 916)) <= (1833 - 957))) then
					return v165;
				end
				v164 = 1 + 0;
			end
		end
	end
	local function v120()
		local v166 = 653 - (232 + 421);
		local v167;
		while true do
			if ((v166 == (1890 - (1569 + 320))) or ((507 + 1559) == (178 + 754))) then
				if (((16259 - 11434) < (5448 - (316 + 289))) and v54.DesperateInvokersCodex:IsEquippedAndReady()) then
					if (v27(v59.DesperateInvokersCodex, not v18:IsInRange(117 - 72)) or ((180 + 3697) >= (5990 - (666 + 787)))) then
						return "desperate_invokers_codex items 2";
					end
				end
				if (v54.ConjuredChillglobe:IsEquippedAndReady() or ((4740 - (360 + 65)) < (1614 + 112))) then
					if (v27(v59.ConjuredChillglobe) or ((3933 - (79 + 175)) < (985 - 360))) then
						return "conjured_chillglobe items 4";
					end
				end
				break;
			end
			if ((v166 == (0 + 0)) or ((14176 - 9551) < (1216 - 584))) then
				v167 = v119();
				if (v167 or ((982 - (503 + 396)) > (1961 - (92 + 89)))) then
					return v167;
				end
				v166 = 1 - 0;
			end
		end
	end
	local function v121()
		if (((281 + 265) <= (638 + 439)) and v69) then
			local v174 = 0 - 0;
			local v175;
			while true do
				if (((0 + 0) == v174) or ((2270 - 1274) > (3753 + 548))) then
					v175 = v51.HandleDPSPotion();
					if (((1944 + 2126) > (2092 - 1405)) and v175) then
						return v175;
					end
					v174 = 1 + 0;
				end
				if ((v174 == (1 - 0)) or ((1900 - (485 + 759)) >= (7705 - 4375))) then
					if (v53.Berserking:IsCastable() or ((3681 - (442 + 747)) <= (1470 - (832 + 303)))) then
						if (((5268 - (88 + 858)) >= (781 + 1781)) and v27(v53.Berserking)) then
							return "berserking ogcd 4";
						end
					end
					if (v53.BloodFury:IsCastable() or ((3010 + 627) >= (156 + 3614))) then
						if (v27(v53.BloodFury) or ((3168 - (766 + 23)) > (22600 - 18022))) then
							return "blood_fury ogcd 6";
						end
					end
					v174 = 2 - 0;
				end
				if ((v174 == (4 - 2)) or ((1639 - 1156) > (1816 - (1036 + 37)))) then
					if (((1740 + 714) > (1125 - 547)) and v53.Fireblood:IsCastable()) then
						if (((732 + 198) < (5938 - (641 + 839))) and v27(v53.Fireblood)) then
							return "fireblood ogcd 8";
						end
					end
					break;
				end
			end
		end
	end
	local function v122()
		local v168 = 913 - (910 + 3);
		local v169;
		while true do
			if (((1687 - 1025) <= (2656 - (1466 + 218))) and (v168 == (3 + 2))) then
				if (((5518 - (556 + 592)) == (1554 + 2816)) and v53.SeedofCorruption:IsReady() and v53.SowTheSeeds:IsAvailable()) then
					if (v26(v53.SeedofCorruption, nil, nil, not v18:IsSpellInRange(v53.SeedofCorruption)) or ((5570 - (329 + 479)) <= (1715 - (174 + 680)))) then
						return "seed_of_corruption aoe 22";
					end
				end
				if ((v53.MaleficRapture:IsReady() and ((((v53.SummonDarkglare:CooldownRemains() > (51 - 36)) or (v76 > (5 - 2))) and not v53.SowTheSeeds:IsAvailable()) or v14:BuffUp(v53.TormentedCrescendoBuff))) or ((1009 + 403) == (5003 - (396 + 343)))) then
					if (v26(v53.MaleficRapture, nil, nil, not v18:IsInRange(9 + 91)) or ((4645 - (29 + 1448)) < (3542 - (135 + 1254)))) then
						return "malefic_rapture aoe 24";
					end
				end
				if ((v53.DrainLife:IsReady() and (v18:DebuffUp(v53.SoulRotDebuff) or not v53.SoulRot:IsAvailable()) and (v14:BuffStack(v53.InevitableDemiseBuff) > (37 - 27))) or ((23233 - 18257) < (888 + 444))) then
					if (((6155 - (389 + 1138)) == (5202 - (102 + 472))) and v26(v53.DrainLife, nil, nil, not v18:IsSpellInRange(v53.DrainLife))) then
						return "drain_life aoe 26";
					end
				end
				v168 = 6 + 0;
			end
			if ((v168 == (2 + 1)) or ((51 + 3) == (1940 - (320 + 1225)))) then
				if (((145 - 63) == (51 + 31)) and v53.SoulRot:IsReady() and v64 and (v63 or (v53.SouleatersGluttony:TalentRank() ~= (1465 - (157 + 1307)))) and v18:DebuffUp(v53.AgonyDebuff)) then
					if (v26(v53.SoulRot, nil, nil, not v18:IsSpellInRange(v53.SoulRot)) or ((2440 - (821 + 1038)) < (703 - 421))) then
						return "soul_rot aoe 12";
					end
				end
				if ((v53.SeedofCorruption:IsReady() and (v18:DebuffRemains(v53.CorruptionDebuff) < (1 + 4)) and not (v53.SeedofCorruption:InFlight() or v18:DebuffUp(v53.SeedofCorruptionDebuff))) or ((8186 - 3577) < (929 + 1566))) then
					if (((2855 - 1703) == (2178 - (834 + 192))) and v26(v53.SeedofCorruption, nil, nil, not v18:IsSpellInRange(v53.SeedofCorruption))) then
						return "seed_of_corruption aoe 14";
					end
				end
				if (((121 + 1775) <= (879 + 2543)) and v53.Corruption:IsReady() and not v53.SeedofCorruption:IsAvailable()) then
					if (v51.CastTargetIf(v53.Corruption, v60, "min", v98, v106, not v18:IsSpellInRange(v53.Corruption)) or ((22 + 968) > (2509 - 889))) then
						return "corruption aoe 15";
					end
				end
				v168 = 308 - (300 + 4);
			end
			if ((v168 == (0 + 0)) or ((2295 - 1418) > (5057 - (112 + 250)))) then
				if (((1073 + 1618) >= (4637 - 2786)) and v33) then
					local v185 = v121();
					if (v185 or ((1711 + 1274) >= (2512 + 2344))) then
						return v185;
					end
				end
				v169 = v120();
				if (((3198 + 1078) >= (593 + 602)) and v169) then
					return v169;
				end
				v168 = 1 + 0;
			end
			if (((4646 - (1001 + 413)) <= (10458 - 5768)) and (v168 == (883 - (244 + 638)))) then
				if ((v53.Haunt:IsReady() and (v18:DebuffRemains(v53.HauntDebuff) < (696 - (627 + 66)))) or ((2669 - 1773) >= (3748 - (512 + 90)))) then
					if (((4967 - (1665 + 241)) >= (3675 - (373 + 344))) and v26(v53.Haunt, nil, nil, not v18:IsSpellInRange(v53.Haunt))) then
						return "haunt aoe 2";
					end
				end
				if (((1438 + 1749) >= (171 + 473)) and v53.VileTaint:IsReady() and (((v53.SouleatersGluttony:TalentRank() == (5 - 3)) and ((v70 < (1.5 - 0)) or (v53.SoulRot:CooldownRemains() <= v53.VileTaint:ExecuteTime()))) or ((v53.SouleatersGluttony:TalentRank() == (1100 - (35 + 1064))) and (v53.SoulRot:CooldownRemains() <= v53.VileTaint:ExecuteTime())) or (not v53.SouleatersGluttony:IsAvailable() and ((v53.SoulRot:CooldownRemains() <= v53.VileTaint:ExecuteTime()) or (v53.VileTaint:CooldownRemains() > (19 + 6)))))) then
					if (((1377 - 733) <= (3 + 701)) and v26(v59.VileTaintCursor, nil, nil, not v18:IsInRange(1276 - (298 + 938)))) then
						return "vile_taint aoe 4";
					end
				end
				if (((2217 - (233 + 1026)) > (2613 - (636 + 1030))) and v53.PhantomSingularity:IsCastable() and ((v53.SoulRot:IsAvailable() and (v53.SoulRot:CooldownRemains() <= v53.PhantomSingularity:ExecuteTime())) or (not v53.SouleatersGluttony:IsAvailable() and (not v53.SoulRot:IsAvailable() or (v53.SoulRot:CooldownRemains() <= v53.PhantomSingularity:ExecuteTime()) or (v53.SoulRot:CooldownRemains() >= (13 + 12))))) and v18:DebuffUp(v53.AgonyDebuff)) then
					if (((4388 + 104) >= (789 + 1865)) and v26(v53.PhantomSingularity, v48, nil, not v18:IsSpellInRange(v53.PhantomSingularity))) then
						return "phantom_singularity aoe 6";
					end
				end
				v168 = 1 + 1;
			end
			if (((3663 - (55 + 166)) >= (292 + 1211)) and (v168 == (1 + 1))) then
				if ((v53.UnstableAffliction:IsReady() and (v18:DebuffRemains(v53.UnstableAfflictionDebuff) < (18 - 13))) or ((3467 - (36 + 261)) <= (2560 - 1096))) then
					if (v26(v53.UnstableAffliction, nil, nil, not v18:IsSpellInRange(v53.UnstableAffliction)) or ((6165 - (34 + 1334)) == (1687 + 2701))) then
						return "unstable_affliction aoe 8";
					end
				end
				if (((429 + 122) <= (1964 - (1035 + 248))) and v53.Agony:IsReady() and (v53.AgonyDebuff:AuraActiveCount() < (29 - (20 + 1))) and (((v79 * (2 + 0)) + v53.SoulRot:CastTime()) < v73)) then
					if (((3596 - (134 + 185)) > (1540 - (549 + 584))) and v51.CastTargetIf(v53.Agony, v60, "min", v97, v104, not v18:IsSpellInRange(v53.Agony))) then
						return "agony aoe 9";
					end
				end
				if (((5380 - (314 + 371)) >= (4857 - 3442)) and v53.SiphonLife:IsReady() and (v53.SiphonLifeDebuff:AuraActiveCount() < (974 - (478 + 490))) and v53.SummonDarkglare:CooldownUp() and (HL.CombatTime() < (11 + 9)) and (((v79 * (1174 - (786 + 386))) + v53.SoulRot:CastTime()) < v73)) then
					if (v51.CastCycle(v53.SiphonLife, v60, v116, not v18:IsSpellInRange(v53.SiphonLife)) or ((10403 - 7191) <= (2323 - (1055 + 324)))) then
						return "siphon_life aoe 10";
					end
				end
				v168 = 1343 - (1093 + 247);
			end
			if ((v168 == (6 + 0)) or ((326 + 2770) <= (7138 - 5340))) then
				if (((12003 - 8466) == (10064 - 6527)) and v53.DrainSoul:IsReady() and v14:BuffUp(v53.NightfallBuff) and v53.ShadowEmbrace:IsAvailable()) then
					if (((9641 - 5804) >= (559 + 1011)) and v51.CastCycle(v53.DrainSoul, v60, v113, not v18:IsSpellInRange(v53.DrainSoul))) then
						return "drain_soul aoe 28";
					end
				end
				if ((v53.DrainSoul:IsReady() and (v14:BuffUp(v53.NightfallBuff))) or ((11364 - 8414) == (13139 - 9327))) then
					if (((3562 + 1161) >= (5927 - 3609)) and v26(v53.DrainSoul, nil, nil, not v18:IsSpellInRange(v53.DrainSoul))) then
						return "drain_soul aoe 30";
					end
				end
				if ((v53.SummonSoulkeeper:IsReady() and ((v53.SummonSoulkeeper:Count() == (698 - (364 + 324))) or ((v53.SummonSoulkeeper:Count() > (7 - 4)) and (v78 < (23 - 13))))) or ((672 + 1355) > (11933 - 9081))) then
					if (v26(v53.SummonSoulkeeper) or ((1819 - 683) > (13111 - 8794))) then
						return "soul_strike aoe 32";
					end
				end
				v168 = 1275 - (1249 + 19);
			end
			if (((4286 + 462) == (18481 - 13733)) and (v168 == (1090 - (686 + 400)))) then
				if (((2932 + 804) <= (4969 - (73 + 156))) and v33 and v53.SummonDarkglare:IsCastable() and v63 and v64 and v66) then
					if (v26(v53.SummonDarkglare, v49) or ((17 + 3373) <= (3871 - (721 + 90)))) then
						return "summon_darkglare aoe 18";
					end
				end
				if ((v53.DrainLife:IsReady() and (v14:BuffStack(v53.InevitableDemiseBuff) > (1 + 29)) and v14:BuffUp(v53.SoulRot) and (v14:BuffRemains(v53.SoulRot) <= v79) and (v62 > (9 - 6))) or ((1469 - (224 + 246)) > (4362 - 1669))) then
					if (((852 - 389) < (110 + 491)) and v51.CastTargetIf(v53.DrainLife, v60, "min", v101, nil, not v18:IsSpellInRange(v53.DrainLife))) then
						return "drain_life aoe 19";
					end
				end
				if ((v53.MaleficRapture:IsReady() and v14:BuffUp(v53.UmbrafireKindlingBuff) and ((((v62 < (1 + 5)) or (HL.CombatTime() < (23 + 7))) and v95()) or not v53.DoomBlossom:IsAvailable())) or ((4339 - 2156) < (2286 - 1599))) then
					if (((5062 - (203 + 310)) == (6542 - (1238 + 755))) and v26(v53.MaleficRapture, nil, nil, not v18:IsInRange(7 + 93))) then
						return "malefic_rapture aoe 20";
					end
				end
				v168 = 1539 - (709 + 825);
			end
			if (((8608 - 3936) == (6805 - 2133)) and (v168 == (871 - (196 + 668)))) then
				if ((v53.SiphonLife:IsReady() and (v53.SiphonLifeDebuff:AuraActiveCount() < (19 - 14)) and ((v62 < (16 - 8)) or not v53.DoomBlossom:IsAvailable())) or ((4501 - (171 + 662)) < (488 - (4 + 89)))) then
					if (v51.CastCycle(v53.SiphonLife, v60, v115, not v18:IsSpellInRange(v53.SiphonLife)) or ((14601 - 10435) == (166 + 289))) then
						return "siphon_life aoe 34";
					end
				end
				if (v53.DrainSoul:IsReady() or ((19540 - 15091) == (1045 + 1618))) then
					if (v51.CastCycle(v53.DrainSoul, v60, v114, not v18:IsSpellInRange(v53.DrainSoul)) or ((5763 - (35 + 1451)) < (4442 - (28 + 1425)))) then
						return "drain_soul aoe 36";
					end
				end
				if (v53.ShadowBolt:IsReady() or ((2863 - (941 + 1052)) >= (3979 + 170))) then
					if (((3726 - (822 + 692)) < (4543 - 1360)) and v26(v53.ShadowBolt, nil, nil, not v18:IsSpellInRange(v53.ShadowBolt))) then
						return "shadow_bolt aoe 38";
					end
				end
				break;
			end
		end
	end
	local function v123()
		local v170 = 0 + 0;
		local v171;
		while true do
			if (((4943 - (45 + 252)) > (2961 + 31)) and (v170 == (1 + 1))) then
				if (((3489 - 2055) < (3539 - (114 + 319))) and v53.Agony:IsReady()) then
					if (((1127 - 341) < (3873 - 850)) and v51.CastTargetIf(v53.Agony, v60, "min", v97, v105, not v18:IsSpellInRange(v53.Agony))) then
						return "agony cleave 10";
					end
				end
				if ((v53.UnstableAffliction:IsReady() and (v18:DebuffRemains(v53.UnstableAfflictionDebuff) < (4 + 1)) and (v78 > (4 - 1))) or ((5116 - 2674) < (2037 - (556 + 1407)))) then
					if (((5741 - (741 + 465)) == (5000 - (170 + 295))) and v26(v53.UnstableAffliction, nil, nil, not v18:IsSpellInRange(v53.UnstableAffliction))) then
						return "unstable_affliction cleave 12";
					end
				end
				if ((v53.SeedofCorruption:IsReady() and not v53.AbsoluteCorruption:IsAvailable() and (v18:DebuffRemains(v53.CorruptionDebuff) < (3 + 2)) and v53.SowTheSeeds:IsAvailable() and v94(v60)) or ((2764 + 245) <= (5182 - 3077))) then
					if (((1518 + 312) < (2353 + 1316)) and v26(v53.SeedofCorruption, nil, nil, not v18:IsSpellInRange(v53.SeedofCorruption))) then
						return "seed_of_corruption cleave 14";
					end
				end
				if ((v53.Haunt:IsReady() and (v18:DebuffRemains(v53.HauntDebuff) < (2 + 1))) or ((2660 - (957 + 273)) >= (967 + 2645))) then
					if (((1075 + 1608) >= (9373 - 6913)) and v26(v53.Haunt, nil, nil, not v18:IsSpellInRange(v53.Haunt))) then
						return "haunt cleave 16";
					end
				end
				v170 = 7 - 4;
			end
			if ((v170 == (2 - 1)) or ((8932 - 7128) >= (5055 - (389 + 1391)))) then
				if ((v53.MaleficRapture:IsReady() and ((v53.DreadTouch:IsAvailable() and (v18:DebuffRemains(v53.DreadTouchDebuff) < (2 + 0)) and (v18:DebuffRemains(v53.AgonyDebuff) > v79) and v18:DebuffUp(v53.CorruptionDebuff) and (not v53.SiphonLife:IsAvailable() or v18:DebuffUp(v53.SiphonLifeDebuff)) and v18:DebuffUp(v53.UnstableAfflictionDebuff) and (not v53.PhantomSingularity:IsAvailable() or v53.PhantomSingularity:CooldownDown()) and (not v53.VileTaint:IsAvailable() or v53.VileTaint:CooldownDown()) and (not v53.SoulRot:IsAvailable() or v53.SoulRot:CooldownDown())) or (v76 > (1 + 3)))) or ((3225 - 1808) > (4580 - (783 + 168)))) then
					if (((16092 - 11297) > (396 + 6)) and v26(v53.MaleficRapture, nil, nil, not v18:IsInRange(411 - (309 + 2)))) then
						return "malefic_rapture cleave 2";
					end
				end
				if (((14780 - 9967) > (4777 - (1090 + 122))) and v53.VileTaint:IsReady() and (not v53.SoulRot:IsAvailable() or (v70 < (1.5 + 0)) or (v53.SoulRot:CooldownRemains() <= (v53.VileTaint:ExecuteTime() + v79)) or (not v53.SouleatersGluttony:IsAvailable() and (v53.SoulRot:CooldownRemains() >= (40 - 28))))) then
					if (((2678 + 1234) == (5030 - (628 + 490))) and v26(v53.VileTaint, nil, nil, not v18:IsInRange(8 + 32))) then
						return "vile_taint cleave 4";
					end
				end
				if (((6984 - 4163) <= (22045 - 17221)) and v53.VileTaint:IsReady() and (v53.AgonyDebuff:AuraActiveCount() == (776 - (431 + 343))) and (v53.CorruptionDebuff:AuraActiveCount() == (3 - 1)) and (not v53.SiphonLife:IsAvailable() or (v53.SiphonLifeDebuff:AuraActiveCount() == (5 - 3))) and (not v53.SoulRot:IsAvailable() or (v53.SoulRot:CooldownRemains() <= v53.VileTaint:ExecuteTime()) or (not v53.SouleatersGluttony:IsAvailable() and (v53.SoulRot:CooldownRemains() >= (10 + 2))))) then
					if (((223 + 1515) <= (3890 - (556 + 1139))) and v26(v59.VileTaintCursor, nil, nil, not v18:IsSpellInRange(v53.VileTaint))) then
						return "vile_taint cleave 10";
					end
				end
				if (((56 - (6 + 9)) <= (553 + 2465)) and v53.SoulRot:IsReady() and v64 and (v63 or (v53.SouleatersGluttony:TalentRank() ~= (1 + 0))) and (v53.AgonyDebuff:AuraActiveCount() >= (171 - (28 + 141)))) then
					if (((831 + 1314) <= (5065 - 961)) and v26(v53.SoulRot, nil, nil, not v18:IsSpellInRange(v53.SoulRot))) then
						return "soul_rot cleave 8";
					end
				end
				v170 = 2 + 0;
			end
			if (((4006 - (486 + 831)) < (12607 - 7762)) and (v170 == (13 - 9))) then
				if ((v53.DrainSoul:IsReady() and v53.ShadowEmbrace:IsAvailable() and ((v18:DebuffStack(v53.ShadowEmbraceDebuff) < (1 + 2)) or (v18:DebuffRemains(v53.ShadowEmbraceDebuff) < (9 - 6)))) or ((3585 - (668 + 595)) > (2360 + 262))) then
					if (v26(v53.DrainSoul, nil, nil, not v18:IsSpellInRange(v53.DrainSoul)) or ((915 + 3619) == (5677 - 3595))) then
						return "drain_soul cleave 26";
					end
				end
				if ((v75:IsReady() and (v14:BuffUp(v53.NightfallBuff))) or ((1861 - (23 + 267)) > (3811 - (1129 + 815)))) then
					if (v51.CastTargetIf(v75, v60, "min", v99, v107, not v18:IsSpellInRange(v75)) or ((3041 - (371 + 16)) >= (4746 - (1326 + 424)))) then
						return "drain_soul/shadow_bolt cleave 28";
					end
				end
				if (((7533 - 3555) > (7688 - 5584)) and v53.MaleficRapture:IsReady() and not v53.DreadTouch:IsAvailable() and v14:BuffUp(v53.TormentedCrescendoBuff)) then
					if (((3113 - (88 + 30)) > (2312 - (720 + 51))) and v26(v53.MaleficRapture, nil, nil, not v18:IsInRange(222 - 122))) then
						return "malefic_rapture cleave 30";
					end
				end
				if (((5025 - (421 + 1355)) > (1572 - 619)) and v53.MaleficRapture:IsReady() and (v67 or v65)) then
					if (v26(v53.MaleficRapture, nil, nil, not v18:IsInRange(50 + 50)) or ((4356 - (286 + 797)) > (16717 - 12144))) then
						return "malefic_rapture cleave 32";
					end
				end
				v170 = 7 - 2;
			end
			if ((v170 == (439 - (397 + 42))) or ((985 + 2166) < (2084 - (24 + 776)))) then
				if (v33 or ((2850 - 1000) == (2314 - (222 + 563)))) then
					local v186 = v121();
					if (((1808 - 987) < (1529 + 594)) and v186) then
						return v186;
					end
				end
				v171 = v120();
				if (((1092 - (23 + 167)) < (4123 - (690 + 1108))) and v171) then
					return v171;
				end
				if (((310 + 548) <= (2444 + 518)) and v33 and v53.SummonDarkglare:IsCastable() and v63 and v64 and v66) then
					if (v26(v53.SummonDarkglare, v49) or ((4794 - (40 + 808)) < (213 + 1075))) then
						return "summon_darkglare cleave 2";
					end
				end
				v170 = 3 - 2;
			end
			if ((v170 == (6 + 0)) or ((1716 + 1526) == (311 + 256))) then
				if (v53.Corruption:IsCastable() or ((1418 - (47 + 524)) >= (820 + 443))) then
					if (v51.CastCycle(v53.Corruption, v60, v112, not v18:IsSpellInRange(v53.Corruption)) or ((6158 - 3905) == (2767 - 916))) then
						return "corruption cleave 42";
					end
				end
				if ((v53.MaleficRapture:IsReady() and (v76 > (2 - 1))) or ((3813 - (1165 + 561)) > (71 + 2301))) then
					if (v26(v53.MaleficRapture, nil, nil, not v18:IsInRange(309 - 209)) or ((1697 + 2748) < (4628 - (341 + 138)))) then
						return "malefic_rapture cleave 44";
					end
				end
				if (v53.DrainSoul:IsReady() or ((491 + 1327) == (175 - 90))) then
					if (((956 - (89 + 237)) < (6842 - 4715)) and v26(v53.DrainSoul, nil, nil, not v18:IsSpellInRange(v53.DrainSoul))) then
						return "drain_soul cleave 54";
					end
				end
				if (v75:IsReady() or ((4080 - 2142) == (3395 - (581 + 300)))) then
					if (((5475 - (855 + 365)) >= (130 - 75)) and v26(v75, nil, nil, not v18:IsSpellInRange(v75))) then
						return "drain_soul/shadow_bolt cleave 46";
					end
				end
				break;
			end
			if (((980 + 2019) > (2391 - (1030 + 205))) and (v170 == (5 + 0))) then
				if (((2187 + 163) > (1441 - (156 + 130))) and v53.MaleficRapture:IsReady() and (v76 > (6 - 3))) then
					if (((6789 - 2760) <= (9939 - 5086)) and v26(v53.MaleficRapture, nil, nil, not v18:IsInRange(27 + 73))) then
						return "malefic_rapture cleave 34";
					end
				end
				if ((v53.DrainLife:IsReady() and ((v14:BuffStack(v53.InevitableDemiseBuff) > (28 + 20)) or ((v14:BuffStack(v53.InevitableDemiseBuff) > (89 - (10 + 59))) and (v78 < (2 + 2))))) or ((2541 - 2025) > (4597 - (671 + 492)))) then
					if (((3221 + 825) >= (4248 - (369 + 846))) and v26(v53.DrainLife, nil, nil, not v18:IsSpellInRange(v53.DrainLife))) then
						return "drain_life cleave 36";
					end
				end
				if ((v53.DrainLife:IsReady() and v14:BuffUp(v53.SoulRot) and (v14:BuffStack(v53.InevitableDemiseBuff) > (8 + 22))) or ((2321 + 398) <= (3392 - (1036 + 909)))) then
					if (v26(v53.DrainLife, nil, nil, not v18:IsSpellInRange(v53.DrainLife)) or ((3287 + 847) < (6591 - 2665))) then
						return "drain_life cleave 38";
					end
				end
				if (v53.Agony:IsReady() or ((367 - (11 + 192)) >= (1408 + 1377))) then
					if (v51.CastCycle(v53.Agony, v60, v110, not v18:IsSpellInRange(v53.Agony)) or ((700 - (135 + 40)) == (5109 - 3000))) then
						return "agony cleave 40";
					end
				end
				v170 = 4 + 2;
			end
			if (((72 - 39) == (49 - 16)) and (v170 == (179 - (50 + 126)))) then
				if (((8503 - 5449) <= (889 + 3126)) and v53.Corruption:IsReady() and not (v53.SeedofCorruption:InFlight() or (v18:DebuffRemains(v53.SeedofCorruptionDebuff) > (1413 - (1233 + 180)))) and (v78 > (974 - (522 + 447)))) then
					if (((3292 - (107 + 1314)) < (1570 + 1812)) and v51.CastTargetIf(v53.Corruption, v60, "min", v98, v106, not v18:IsSpellInRange(v53.Corruption))) then
						return "corruption cleave 18";
					end
				end
				if (((3939 - 2646) <= (920 + 1246)) and v53.SiphonLife:IsReady() and (v78 > (9 - 4))) then
					if (v51.CastTargetIf(v53.SiphonLife, v60, "min", v100, v108, not v18:IsSpellInRange(v53.SiphonLife)) or ((10204 - 7625) < (2033 - (716 + 1194)))) then
						return "siphon_life cleave 20";
					end
				end
				if ((v53.SummonDarkglare:IsReady() and (not v53.ShadowEmbrace:IsAvailable() or (v18:DebuffStack(v53.ShadowEmbraceDebuff) == (1 + 2))) and v63 and v64 and v66) or ((91 + 755) >= (2871 - (74 + 429)))) then
					if (v26(v53.SummonDarkglare, v49) or ((7739 - 3727) <= (1665 + 1693))) then
						return "summon_darkglare cleave 22";
					end
				end
				if (((3419 - 1925) <= (2126 + 879)) and v53.MaleficRapture:IsReady() and v53.TormentedCrescendo:IsAvailable() and (v14:BuffStack(v53.TormentedCrescendoBuff) == (2 - 1)) and (v76 > (7 - 4))) then
					if (v26(v53.MaleficRapture, nil, nil, not v18:IsInRange(533 - (279 + 154))) or ((3889 - (454 + 324)) == (1679 + 455))) then
						return "malefic_rapture cleave 24";
					end
				end
				v170 = 21 - (12 + 5);
			end
		end
	end
	local function v124()
		local v172 = 0 + 0;
		while true do
			if (((6000 - 3645) == (871 + 1484)) and ((1096 - (277 + 816)) == v172)) then
				v73 = v30(v71 * v28(v53.VileTaint:IsAvailable()), v72 * v28(v53.PhantomSingularity:IsAvailable()));
				v79 = v14:GCD() + (0.25 - 0);
				if ((v53.SummonPet:IsCastable() and v45 and not v17:IsActive()) or ((1771 - (1058 + 125)) <= (81 + 351))) then
					if (((5772 - (815 + 160)) >= (16712 - 12817)) and v27(v53.SummonPet)) then
						return "summon_pet ooc";
					end
				end
				if (((8490 - 4913) == (854 + 2723)) and v51.TargetIsValid()) then
					if (((11090 - 7296) > (5591 - (41 + 1857))) and not v14:AffectingCombat() and v31) then
						local v188 = 1893 - (1222 + 671);
						local v189;
						while true do
							if (((0 - 0) == v188) or ((1832 - 557) == (5282 - (229 + 953)))) then
								v189 = v117();
								if (v189 or ((3365 - (1111 + 663)) >= (5159 - (874 + 705)))) then
									return v189;
								end
								break;
							end
						end
					end
					if (((138 + 845) <= (1234 + 574)) and not v14:IsCasting() and not v14:IsChanneling()) then
						local v190 = v51.Interrupt(v53.SpellLock, 83 - 43, true);
						if (v190 or ((61 + 2089) <= (1876 - (642 + 37)))) then
							return v190;
						end
						v190 = v51.Interrupt(v53.SpellLock, 10 + 30, true, v16, v59.SpellLockMouseover);
						if (((603 + 3166) >= (2944 - 1771)) and v190) then
							return v190;
						end
						v190 = v51.Interrupt(v53.AxeToss, 494 - (233 + 221), true);
						if (((3433 - 1948) == (1308 + 177)) and v190) then
							return v190;
						end
						v190 = v51.Interrupt(v53.AxeToss, 1581 - (718 + 823), true, v16, v59.AxeTossMouseover);
						if (v190 or ((2087 + 1228) <= (3587 - (266 + 539)))) then
							return v190;
						end
						v190 = v51.InterruptWithStun(v53.AxeToss, 113 - 73, true);
						if (v190 or ((2101 - (636 + 589)) >= (7035 - 4071))) then
							return v190;
						end
						v190 = v51.InterruptWithStun(v53.AxeToss, 82 - 42, true, v16, v59.AxeTossMouseover);
						if (v190 or ((1769 + 463) > (908 + 1589))) then
							return v190;
						end
					end
					v118();
					if (((v62 > (1016 - (657 + 358))) and (v62 < (7 - 4))) or ((4807 - 2697) <= (1519 - (1151 + 36)))) then
						local v191 = v123();
						if (((3560 + 126) > (834 + 2338)) and v191) then
							return v191;
						end
					end
					if ((v62 > (5 - 3)) or ((6306 - (1552 + 280)) < (1654 - (64 + 770)))) then
						local v192 = v122();
						if (((2906 + 1373) >= (6541 - 3659)) and v192) then
							return v192;
						end
					end
					if (v25() or ((361 + 1668) >= (4764 - (157 + 1086)))) then
						local v193 = v121();
						if (v193 or ((4076 - 2039) >= (20330 - 15688))) then
							return v193;
						end
					end
					if (((2638 - 918) < (6084 - 1626)) and v35) then
						local v194 = v120();
						if (v194 or ((1255 - (599 + 220)) > (6015 - 2994))) then
							return v194;
						end
					end
					if (((2644 - (1813 + 118)) <= (620 + 227)) and v53.MaleficRapture:IsReady() and v53.DreadTouch:IsAvailable() and (v18:DebuffRemains(v53.DreadTouchDebuff) < (1219 - (841 + 376))) and (v18:DebuffRemains(v53.AgonyDebuff) > v79) and v18:DebuffUp(v53.CorruptionDebuff) and (not v53.SiphonLife:IsAvailable() or v18:DebuffUp(v53.SiphonLifeDebuff)) and v18:DebuffUp(v53.UnstableAfflictionDebuff) and (not v53.PhantomSingularity:IsAvailable() or v53.PhantomSingularity:CooldownDown()) and (not v53.VileTaint:IsAvailable() or v53.VileTaint:CooldownDown()) and (not v53.SoulRot:IsAvailable() or v53.SoulRot:CooldownDown())) then
						if (((3018 - 864) <= (937 + 3094)) and v26(v53.MaleficRapture, nil, nil, not v18:IsInRange(272 - 172))) then
							return "malefic_rapture main 2";
						end
					end
					if (((5474 - (464 + 395)) == (11843 - 7228)) and v53.MaleficRapture:IsReady() and (v78 < (2 + 2))) then
						if (v26(v53.MaleficRapture, nil, nil, not v18:IsInRange(937 - (467 + 370))) or ((7832 - 4042) == (368 + 132))) then
							return "malefic_rapture main 4";
						end
					end
					if (((304 - 215) < (35 + 186)) and v53.VileTaint:IsReady() and (not v53.SoulRot:IsAvailable() or (v70 < (2.5 - 1)) or (v53.SoulRot:CooldownRemains() <= (v53.VileTaint:ExecuteTime() + v79)) or (not v53.SouleatersGluttony:IsAvailable() and (v53.SoulRot:CooldownRemains() >= (532 - (150 + 370)))))) then
						if (((3336 - (74 + 1208)) >= (3494 - 2073)) and v26(v53.VileTaint, v47, nil, not v18:IsInRange(189 - 149))) then
							return "vile_taint main 6";
						end
					end
					if (((493 + 199) < (3448 - (14 + 376))) and v53.PhantomSingularity:IsCastable() and ((v53.SoulRot:CooldownRemains() <= v53.PhantomSingularity:ExecuteTime()) or (not v53.SouleatersGluttony:IsAvailable() and (not v53.SoulRot:IsAvailable() or (v53.SoulRot:CooldownRemains() <= v53.PhantomSingularity:ExecuteTime()) or (v53.SoulRot:CooldownRemains() >= (43 - 18))))) and v18:DebuffUp(v53.AgonyDebuff)) then
						if (v26(v53.PhantomSingularity, v48, nil, not v18:IsSpellInRange(v53.PhantomSingularity)) or ((2106 + 1148) == (1454 + 201))) then
							return "phantom_singularity main 8";
						end
					end
					if ((v53.SoulRot:IsReady() and v64 and (v63 or (v53.SouleatersGluttony:TalentRank() ~= (1 + 0))) and v18:DebuffUp(v53.AgonyDebuff)) or ((3797 - 2501) == (3694 + 1216))) then
						if (((3446 - (23 + 55)) == (7981 - 4613)) and v26(v53.SoulRot, nil, nil, not v18:IsSpellInRange(v53.SoulRot))) then
							return "soul_rot main 10";
						end
					end
					if (((1764 + 879) < (3426 + 389)) and v53.Agony:IsCastable() and (not v53.VileTaint:IsAvailable() or (v18:DebuffRemains(v53.AgonyDebuff) < (v53.VileTaint:CooldownRemains() + v53.VileTaint:CastTime()))) and (v18:DebuffRemains(v53.AgonyDebuff) < (7 - 2)) and (v78 > (2 + 3))) then
						if (((2814 - (652 + 249)) > (1319 - 826)) and v26(v53.Agony, nil, nil, not v18:IsSpellInRange(v53.Agony))) then
							return "agony main 12";
						end
					end
					if (((6623 - (708 + 1160)) > (9304 - 5876)) and v53.UnstableAffliction:IsReady() and (v18:DebuffRemains(v53.UnstableAfflictionDebuff) < (9 - 4)) and (v78 > (30 - (10 + 17)))) then
						if (((311 + 1070) <= (4101 - (1400 + 332))) and v26(v53.UnstableAffliction, nil, nil, not v18:IsSpellInRange(v53.UnstableAffliction))) then
							return "unstable_affliction main 14";
						end
					end
					if ((v53.Haunt:IsReady() and (v18:DebuffRemains(v53.HauntDebuff) < (9 - 4))) or ((6751 - (242 + 1666)) == (1748 + 2336))) then
						if (((1712 + 2957) > (310 + 53)) and v26(v53.Haunt, nil, nil, not v18:IsSpellInRange(v53.Haunt))) then
							return "haunt main 16";
						end
					end
					if ((v53.Corruption:IsCastable() and v18:DebuffRefreshable(v53.CorruptionDebuff) and (v78 > (945 - (850 + 90)))) or ((3287 - 1410) >= (4528 - (360 + 1030)))) then
						if (((4197 + 545) >= (10234 - 6608)) and v26(v53.Corruption, nil, nil, not v18:IsSpellInRange(v53.Corruption))) then
							return "corruption main 18";
						end
					end
					if ((v53.SiphonLife:IsCastable() and v18:DebuffRefreshable(v53.SiphonLifeDebuff) and (v78 > (6 - 1))) or ((6201 - (909 + 752)) == (2139 - (109 + 1114)))) then
						if (v26(v53.SiphonLife, nil, nil, not v18:IsSpellInRange(v53.SiphonLife)) or ((2116 - 960) > (1692 + 2653))) then
							return "siphon_life main 20";
						end
					end
					if (((2479 - (6 + 236)) < (2678 + 1571)) and v53.SummonDarkglare:IsReady() and (not v53.ShadowEmbrace:IsAvailable() or (v18:DebuffStack(v53.ShadowEmbraceDebuff) == (3 + 0))) and v63 and v64 and v66) then
						if (v26(v53.SummonDarkglare, v49) or ((6327 - 3644) < (39 - 16))) then
							return "summon_darkglare main 22";
						end
					end
					if (((1830 - (1076 + 57)) <= (136 + 690)) and v53.DrainSoul:IsReady() and v53.ShadowEmbrace:IsAvailable() and ((v18:DebuffStack(v53.ShadowEmbraceDebuff) < (692 - (579 + 110))) or (v18:DebuffRemains(v53.ShadowEmbraceDebuff) < (1 + 2)))) then
						if (((977 + 128) <= (625 + 551)) and v26(v53.DrainSoul, nil, nil, not v18:IsSpellInRange(v53.DrainSoul))) then
							return "drain_soul main 24";
						end
					end
					if (((3786 - (174 + 233)) <= (10647 - 6835)) and v53.ShadowBolt:IsReady() and v53.ShadowEmbrace:IsAvailable() and ((v18:DebuffStack(v53.ShadowEmbraceDebuff) < (4 - 1)) or (v18:DebuffRemains(v53.ShadowEmbraceDebuff) < (2 + 1)))) then
						if (v26(v53.ShadowBolt, nil, nil, not v18:IsSpellInRange(v53.ShadowBolt)) or ((1962 - (663 + 511)) >= (1442 + 174))) then
							return "shadow_bolt main 26";
						end
					end
					if (((403 + 1451) <= (10417 - 7038)) and v53.MaleficRapture:IsReady() and ((v76 > (3 + 1)) or (v53.TormentedCrescendo:IsAvailable() and (v14:BuffStack(v53.TormentedCrescendoBuff) == (2 - 1)) and (v76 > (7 - 4))) or (v53.TormentedCrescendo:IsAvailable() and v14:BuffUp(v53.TormentedCrescendoBuff) and v18:DebuffDown(v53.DreadTouchDebuff)) or (v53.TormentedCrescendo:IsAvailable() and (v14:BuffStack(v53.TormentedCrescendoBuff) == (1 + 1))) or v67 or (v65 and (v76 > (1 - 0))) or (v53.TormentedCrescendo:IsAvailable() and v53.Nightfall:IsAvailable() and v14:BuffUp(v53.TormentedCrescendoBuff) and v14:BuffUp(v53.NightfallBuff)))) then
						if (((3242 + 1307) == (416 + 4133)) and v26(v53.MaleficRapture, nil, nil, not v18:IsInRange(822 - (478 + 244)))) then
							return "malefic_rapture main 28";
						end
					end
					if ((v53.DrainLife:IsReady() and ((v14:BuffStack(v53.InevitableDemiseBuff) > (565 - (440 + 77))) or ((v14:BuffStack(v53.InevitableDemiseBuff) > (10 + 10)) and (v78 < (14 - 10))))) or ((4578 - (655 + 901)) >= (561 + 2463))) then
						if (((3691 + 1129) > (1485 + 713)) and v26(v53.DrainLife, nil, nil, not v18:IsSpellInRange(v53.DrainLife))) then
							return "drain_life main 30";
						end
					end
					if ((v53.DrainSoul:IsReady() and (v14:BuffUp(v53.NightfallBuff))) or ((4274 - 3213) >= (6336 - (695 + 750)))) then
						if (((4657 - 3293) <= (6902 - 2429)) and v26(v53.DrainSoul, nil, nil, not v18:IsSpellInRange(v53.DrainSoul))) then
							return "drain_soul main 32";
						end
					end
					if ((v53.ShadowBolt:IsReady() and (v14:BuffUp(v53.NightfallBuff))) or ((14458 - 10863) <= (354 - (285 + 66)))) then
						if (v26(v53.ShadowBolt, nil, nil, not v18:IsSpellInRange(v53.ShadowBolt)) or ((10890 - 6218) == (5162 - (682 + 628)))) then
							return "shadow_bolt main 34";
						end
					end
					if (((252 + 1307) == (1858 - (176 + 123))) and v53.DrainSoul:IsReady()) then
						if (v26(v53.DrainSoul, nil, nil, not v18:IsSpellInRange(v53.DrainSoul)) or ((733 + 1019) <= (572 + 216))) then
							return "drain_soul main 36";
						end
					end
					if (v53.ShadowBolt:IsReady() or ((4176 - (239 + 30)) == (49 + 128))) then
						if (((3336 + 134) > (981 - 426)) and v26(v53.ShadowBolt, nil, nil, not v18:IsSpellInRange(v53.ShadowBolt))) then
							return "shadow_bolt main 38";
						end
					end
				end
				break;
			end
			if (((2 - 1) == v172) or ((1287 - (306 + 9)) == (2250 - 1605))) then
				v60 = v14:GetEnemiesInRange(7 + 33);
				v61 = v18:GetEnemiesInSplashRange(7 + 3);
				if (((1532 + 1650) >= (6048 - 3933)) and v32) then
					v62 = v18:GetEnemiesInSplashRangeCount(1385 - (1140 + 235));
				else
					v62 = 1 + 0;
				end
				if (((3570 + 323) < (1137 + 3292)) and (v51.TargetIsValid() or v14:AffectingCombat())) then
					local v187 = 52 - (33 + 19);
					while true do
						if ((v187 == (0 + 0)) or ((8593 - 5726) < (840 + 1065))) then
							v77 = v11.BossFightRemains(nil, true);
							v78 = v77;
							v187 = 1 - 0;
						end
						if ((v187 == (1 + 0)) or ((2485 - (586 + 103)) >= (369 + 3682))) then
							if (((4984 - 3365) <= (5244 - (1309 + 179))) and (v78 == (20058 - 8947))) then
								v78 = v11.FightRemains(v61, false);
							end
							break;
						end
					end
				end
				v172 = 1 + 1;
			end
			if (((1622 - 1018) == (457 + 147)) and ((0 - 0) == v172)) then
				v50();
				v31 = EpicSettings.Toggles['ooc'];
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v172 = 1 - 0;
			end
			if (((611 - (295 + 314)) == v172) or ((11013 - 6529) == (2862 - (1300 + 662)))) then
				v76 = v14:SoulShardsP();
				v70 = v93(v61, v53.AgonyDebuff);
				v71 = v93(v61, v53.VileTaintDebuff);
				v72 = v93(v61, v53.PhantomSingularityDebuff);
				v172 = 9 - 6;
			end
		end
	end
	local function v125()
		v21.Print("Affliction Warlock rotation by Epic. Supported by Gojira");
		v53.AgonyDebuff:RegisterAuraTracking();
		v53.SiphonLifeDebuff:RegisterAuraTracking();
		v53.CorruptionDebuff:RegisterAuraTracking();
		v53.UnstableAfflictionDebuff:RegisterAuraTracking();
		v21.Print("Affliction Warlock rotation has been updated");
	end
	v21.SetAPL(2020 - (1178 + 577), v124, v125);
end;
return v1["Epix_Warlock_Affliction.lua"](...);

