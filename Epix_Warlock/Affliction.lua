local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 0 - 0;
	local v7;
	while true do
		if ((v6 == (551 - (400 + 150))) or ((10462 - 7050) <= (1408 + 1091))) then
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
		local v125 = 0 - 0;
		while true do
			if (((1103 + 1266) == (444 + 1925)) and (v125 == (3 + 0))) then
				v46 = EpicSettings.Settings['VileTaint'];
				v47 = EpicSettings.Settings['PhantomSingularity'];
				v48 = EpicSettings.Settings['SummonDarkglare'];
				break;
			end
			if (((13812 - 9717) >= (5177 - (109 + 1885))) and (v125 == (1469 - (1269 + 200)))) then
				v34 = EpicSettings.Settings['UseTrinkets'];
				v33 = EpicSettings.Settings['UseRacials'];
				v35 = EpicSettings.Settings['UseHealingPotion'];
				v36 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v125 = 816 - (98 + 717);
			end
			if ((v125 == (828 - (802 + 24))) or ((6399 - 2688) < (1272 - 264))) then
				v41 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v42 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v44 = EpicSettings.Settings['SummonPet'];
				v45 = EpicSettings.Settings['DarkPactHP'] or (0 + 0);
				v125 = 1 + 2;
			end
			if ((v125 == (2 - 1)) or ((3497 - 2448) <= (325 + 581))) then
				v37 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v38 = EpicSettings.Settings['UseHealthstone'];
				v39 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v40 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v125 = 1 + 1;
			end
		end
	end
	local v50 = v11.Commons.Everyone;
	local v51 = v11.Commons.Warlock;
	local v52 = v19.Warlock.Affliction;
	local v53 = v20.Warlock.Affliction;
	local v54 = {v53.ConjuredChillglobe:ID(),v53.DesperateInvokersCodex:ID(),v53.BelorrelostheSuncaller:ID(),v53.TimeThiefsGambit:ID()};
	local v55 = v14:GetEquipment();
	local v56 = (v55[29 - 16] and v20(v55[12 + 1])) or v20(0 + 0);
	local v57 = (v55[340 - (192 + 134)] and v20(v55[1290 - (316 + 960)])) or v20(0 + 0);
	local v58 = v22.Warlock.Affliction;
	local v59, v60, v61;
	local v62, v63, v64, v65, v66, v67, v68;
	local v69, v70, v71, v72;
	local v73 = ((v14:HasTier(24 + 7, 2 + 0)) and (45 - 33)) or (559 - (83 + 468));
	local v74 = ((v52.DrainSoul:IsAvailable()) and v52.DrainSoul) or v52.ShadowBolt;
	local v75 = 1806 - (1202 + 604);
	local v76 = 51868 - 40757;
	local v77 = 18492 - 7381;
	local v78;
	local v79 = v56:ID();
	local v80 = v57:ID();
	local v81 = v56:HasUseBuff();
	local v82 = v57:HasUseBuff();
	local v83 = (v81 and (((v56:Cooldown() % (83 - 53)) == (325 - (45 + 280))) or (((29 + 1) % v56:Cooldown()) == (0 + 0))) and (1 + 0)) or (0.5 + 0);
	local v84 = (v82 and (((v57:Cooldown() % (6 + 24)) == (0 - 0)) or (((1941 - (340 + 1571)) % v57:Cooldown()) == (0 + 0))) and (1773 - (1733 + 39))) or (0.5 - 0);
	local v85 = (v79 == v53.BelorrelostheSuncaller:ID()) or (v79 == v53.TimeThiefsGambit:ID());
	local v86 = (v80 == v53.BelorrelostheSuncaller:ID()) or (v80 == v53.TimeThiefsGambit:ID());
	local v87 = (v79 == v53.RubyWhelpShell:ID()) or (v79 == v53.WhisperingIncarnateIcon:ID());
	local v88 = (v80 == v53.RubyWhelpShell:ID()) or (v80 == v53.WhisperingIncarnateIcon:ID());
	local v89 = v56:BuffDuration() + (v27(v79 == v53.MirrorofFracturedTomorrows:ID()) * (1054 - (125 + 909))) + (v27(v79 == v53.NymuesUnravelingSpindle:ID()) * (1950 - (1096 + 852)));
	local v90 = v57:BuffDuration() + (v27(v80 == v53.MirrorofFracturedTomorrows:ID()) * (9 + 11)) + (v27(v80 == v53.NymuesUnravelingSpindle:ID()) * (2 - 0));
	local v91 = (((not v81 and v82) or (v82 and (((v57:Cooldown() / v90) * v84 * ((1 + 0) - ((512.5 - (409 + 103)) * v27((v80 == v53.MirrorofFracturedTomorrows:ID()) or (v80 == v53.AshesoftheEmbersoul:ID()))))) > ((v56:Cooldown() / v89) * v83 * ((237 - (46 + 190)) - ((95.5 - (51 + 44)) * v27((v79 == v53.MirrorofFracturedTomorrows:ID()) or (v79 == v53.AshesoftheEmbersoul:ID())))))))) and (1 + 1)) or (1318 - (1114 + 203));
	v11:RegisterForEvent(function()
		v52.SeedofCorruption:RegisterInFlight();
		v52.ShadowBolt:RegisterInFlight();
		v52.Haunt:RegisterInFlight();
		v74 = ((v52.DrainSoul:IsAvailable()) and v52.DrainSoul) or v52.ShadowBolt;
	end, "LEARNED_SPELL_IN_TAB");
	v52.SeedofCorruption:RegisterInFlight();
	v52.ShadowBolt:RegisterInFlight();
	v52.Haunt:RegisterInFlight();
	v11:RegisterForEvent(function()
		v55 = v14:GetEquipment();
		v56 = (v55[739 - (228 + 498)] and v20(v55[3 + 10])) or v20(0 + 0);
		v57 = (v55[677 - (174 + 489)] and v20(v55[36 - 22])) or v20(1905 - (830 + 1075));
		v73 = ((v14:HasTier(555 - (303 + 221), 1271 - (231 + 1038))) and (10 + 2)) or (1170 - (171 + 991));
		v79 = v56:ID();
		v80 = v57:ID();
		v81 = v56:HasUseBuff();
		v82 = v57:HasUseBuff();
		v83 = (v81 and (((v56:Cooldown() % (123 - 93)) == (0 - 0)) or (((74 - 44) % v56:Cooldown()) == (0 + 0))) and (3 - 2)) or (0.5 - 0);
		v84 = (v82 and (((v57:Cooldown() % (48 - 18)) == (0 - 0)) or (((1278 - (111 + 1137)) % v57:Cooldown()) == (158 - (91 + 67)))) and (2 - 1)) or (0.5 + 0);
		v85 = (v79 == v53.BelorrelostheSuncaller:ID()) or (v79 == v53.TimeThiefsGambit:ID());
		v86 = (v80 == v53.BelorrelostheSuncaller:ID()) or (v80 == v53.TimeThiefsGambit:ID());
		v87 = (v79 == v53.RubyWhelpShell:ID()) or (v79 == v53.WhisperingIncarnateIcon:ID());
		v88 = (v80 == v53.RubyWhelpShell:ID()) or (v80 == v53.WhisperingIncarnateIcon:ID());
		v89 = v56:BuffDuration() + (v27(v79 == v53.MirrorofFracturedTomorrows:ID()) * (543 - (423 + 100))) + (v27(v79 == v53.NymuesUnravelingSpindle:ID()) * (1 + 1));
		v90 = v57:BuffDuration() + (v27(v80 == v53.MirrorofFracturedTomorrows:ID()) * (55 - 35)) + (v27(v80 == v53.NymuesUnravelingSpindle:ID()) * (2 + 0));
		v91 = (((not v81 and v82) or (v82 and (((v57:Cooldown() / v90) * v84 * ((772 - (326 + 445)) - ((0.5 - 0) * v27((v80 == v53.MirrorofFracturedTomorrows:ID()) or (v80 == v53.AshesoftheEmbersoul:ID()))))) > ((v56:Cooldown() / v89) * v83 * ((2 - 1) - ((0.5 - 0) * v27((v79 == v53.MirrorofFracturedTomorrows:ID()) or (v79 == v53.AshesoftheEmbersoul:ID())))))))) and (713 - (530 + 181))) or (882 - (614 + 267));
	end, "PLAYER_EQUIPMENT_CHANGED");
	v11:RegisterForEvent(function()
		v76 = 11143 - (19 + 13);
		v77 = 18084 - 6973;
	end, "PLAYER_REGEN_ENABLED");
	local function v92(v126, v127)
		local v128 = 0 - 0;
		local v129;
		while true do
			if (((12891 - 8378) > (708 + 2018)) and (v128 == (1 - 0))) then
				for v177, v178 in pairs(v126) do
					local v179 = 0 - 0;
					local v180;
					while true do
						if ((v179 == (1812 - (1293 + 519))) or ((3021 - 1540) >= (6939 - 4281))) then
							v180 = v178:DebuffRemains(v127) + ((188 - 89) * v27(v178:DebuffDown(v127)));
							if ((v129 == nil) or (v180 < v129) or ((13884 - 10664) == (3213 - 1849))) then
								v129 = v180;
							end
							break;
						end
					end
				end
				return v129 or (0 + 0);
			end
			if ((v128 == (0 + 0)) or ((2448 - 1394) > (784 + 2608))) then
				if (not v126 or not v127 or ((225 + 451) >= (1027 + 615))) then
					return 1096 - (709 + 387);
				end
				v129 = nil;
				v128 = 1859 - (673 + 1185);
			end
		end
	end
	local function v93(v130)
		local v131 = 0 - 0;
		local v132;
		local v133;
		while true do
			if (((13281 - 9145) > (3943 - 1546)) and (v131 == (2 + 0))) then
				for v181, v182 in pairs(v130) do
					v132 = v132 + 1 + 0;
					if (v182:DebuffUp(v52.SeedofCorruptionDebuff) or ((5851 - 1517) == (1043 + 3202))) then
						v133 = v133 + (1 - 0);
					end
				end
				return v132 == v133;
			end
			if ((v131 == (1 - 0)) or ((6156 - (446 + 1434)) <= (4314 - (1040 + 243)))) then
				v132 = 0 - 0;
				v133 = 1847 - (559 + 1288);
				v131 = 1933 - (609 + 1322);
			end
			if ((v131 == (454 - (13 + 441))) or ((17869 - 13087) <= (3140 - 1941))) then
				if (not v130 or (#v130 == (0 - 0)) or ((182 + 4682) < (6907 - 5005))) then
					return false;
				end
				if (((1719 + 3120) >= (1622 + 2078)) and (v52.SeedofCorruption:InFlight() or v14:PrevGCDP(2 - 1, v52.SeedofCorruption))) then
					return false;
				end
				v131 = 1 + 0;
			end
		end
	end
	local function v94()
		return v51.GuardiansTable.DarkglareDuration > (0 - 0);
	end
	local function v95()
		return v51.GuardiansTable.DarkglareDuration;
	end
	local function v96(v134)
		return (v134:DebuffRemains(v52.AgonyDebuff));
	end
	local function v97(v135)
		return (v135:DebuffRemains(v52.CorruptionDebuff));
	end
	local function v98(v136)
		return (v136:DebuffRemains(v52.ShadowEmbraceDebuff));
	end
	local function v99(v137)
		return (v137:DebuffRemains(v52.SiphonLifeDebuff));
	end
	local function v100(v138)
		return (v138:DebuffRemains(v52.SoulRotDebuff));
	end
	local function v101(v139)
		return (v139:DebuffRemains(v52.AgonyDebuff) < (v139:DebuffRemains(v52.VileTaintDebuff) + v52.VileTaint:CastTime())) and (v139:DebuffRemains(v52.AgonyDebuff) < (4 + 1));
	end
	local function v102(v140)
		return v140:DebuffRemains(v52.AgonyDebuff) < (3 + 2);
	end
	local function v103(v141)
		return ((v141:DebuffRemains(v52.AgonyDebuff) < (v52.VileTaint:CooldownRemains() + v52.VileTaint:CastTime())) or not v52.VileTaint:IsAvailable()) and (v141:DebuffRemains(v52.AgonyDebuff) < (4 + 1));
	end
	local function v104(v142)
		return ((v142:DebuffRemains(v52.AgonyDebuff) < (v52.VileTaint:CooldownRemains() + v52.VileTaint:CastTime())) or not v52.VileTaint:IsAvailable()) and (v142:DebuffRemains(v52.AgonyDebuff) < (5 + 0)) and (v77 > (5 + 0));
	end
	local function v105(v143)
		return v143:DebuffRemains(v52.CorruptionDebuff) < (438 - (153 + 280));
	end
	local function v106(v144)
		return (v52.ShadowEmbrace:IsAvailable() and ((v144:DebuffStack(v52.ShadowEmbraceDebuff) < (8 - 5)) or (v144:DebuffRemains(v52.ShadowEmbraceDebuff) < (3 + 0)))) or not v52.ShadowEmbrace:IsAvailable();
	end
	local function v107(v145)
		return (v145:DebuffRefreshable(v52.SiphonLifeDebuff));
	end
	local function v108(v146)
		return v146:DebuffRemains(v52.AgonyDebuff) < (2 + 3);
	end
	local function v109(v147)
		return (v147:DebuffRefreshable(v52.AgonyDebuff));
	end
	local function v110(v148)
		return v148:DebuffRemains(v52.CorruptionDebuff) < (3 + 2);
	end
	local function v111(v149)
		return (v149:DebuffRefreshable(v52.CorruptionDebuff));
	end
	local function v112(v150)
		return (v150:DebuffStack(v52.ShadowEmbraceDebuff) < (3 + 0)) or (v150:DebuffRemains(v52.ShadowEmbraceDebuff) < (3 + 0));
	end
	local function v113(v151)
		return (v52.ShadowEmbrace:IsAvailable() and ((v151:DebuffStack(v52.ShadowEmbraceDebuff) < (4 - 1)) or (v151:DebuffRemains(v52.ShadowEmbraceDebuff) < (2 + 1)))) or not v52.ShadowEmbrace:IsAvailable();
	end
	local function v114(v152)
		return v152:DebuffRemains(v52.SiphonLifeDebuff) < (672 - (89 + 578));
	end
	local function v115(v153)
		return (v153:DebuffRemains(v52.SiphonLifeDebuff) < (4 + 1)) and v153:DebuffUp(v52.AgonyDebuff);
	end
	local function v116()
		if (v52.GrimoireofSacrifice:IsCastable() or ((2234 - 1159) > (2967 - (572 + 477)))) then
			if (((54 + 342) <= (2283 + 1521)) and v26(v52.GrimoireofSacrifice)) then
				return "grimoire_of_sacrifice precombat 2";
			end
		end
		if (v52.Haunt:IsReady() or ((498 + 3671) == (2273 - (84 + 2)))) then
			if (((2316 - 910) == (1013 + 393)) and v26(v52.Haunt, not v18:IsSpellInRange(v52.Haunt), true)) then
				return "haunt precombat 6";
			end
		end
		if (((2373 - (497 + 345)) < (110 + 4161)) and v52.UnstableAffliction:IsReady() and not v52.SoulSwap:IsAvailable()) then
			if (((108 + 527) == (1968 - (605 + 728))) and v26(v52.UnstableAffliction, not v18:IsSpellInRange(v52.UnstableAffliction), true)) then
				return "unstable_affliction precombat 8";
			end
		end
		if (((2407 + 966) <= (7905 - 4349)) and v52.ShadowBolt:IsReady()) then
			if (v26(v52.ShadowBolt, not v18:IsSpellInRange(v52.ShadowBolt), true) or ((151 + 3140) < (12126 - 8846))) then
				return "shadow_bolt precombat 10";
			end
		end
	end
	local function v117()
		v62 = v18:DebuffUp(v52.PhantomSingularityDebuff) or not v52.PhantomSingularity:IsAvailable();
		v63 = v18:DebuffUp(v52.VileTaintDebuff) or not v52.VileTaint:IsAvailable();
		v64 = v18:DebuffUp(v52.VileTaintDebuff) or v18:DebuffUp(v52.PhantomSingularityDebuff) or (not v52.VileTaint:IsAvailable() and not v52.PhantomSingularity:IsAvailable());
		v65 = v18:DebuffUp(v52.SoulRotDebuff) or not v52.SoulRot:IsAvailable();
		v66 = v62 and v63 and v65;
		v67 = v52.PhantomSingularity:IsAvailable() or v52.VileTaint:IsAvailable() or v52.SoulRot:IsAvailable() or v52.SummonDarkglare:IsAvailable();
		v68 = not v67 or (v66 and ((v52.SummonDarkglare:CooldownRemains() > (19 + 1)) or not v52.SummonDarkglare:IsAvailable()));
	end
	local function v118()
		local v154 = v50.HandleTopTrinket(v54, v32, 110 - 70, nil);
		if (((3312 + 1074) >= (1362 - (457 + 32))) and v154) then
			return v154;
		end
		local v154 = v50.HandleBottomTrinket(v54, v32, 17 + 23, nil);
		if (((2323 - (832 + 570)) <= (1039 + 63)) and v154) then
			return v154;
		end
	end
	local function v119()
		local v155 = 0 + 0;
		local v156;
		while true do
			if (((16653 - 11947) >= (464 + 499)) and ((797 - (588 + 208)) == v155)) then
				if (v53.DesperateInvokersCodex:IsEquippedAndReady() or ((2587 - 1627) <= (2676 - (884 + 916)))) then
					if (v26(v58.DesperateInvokersCodex, not v18:IsInRange(94 - 49)) or ((1198 + 868) == (1585 - (232 + 421)))) then
						return "desperate_invokers_codex items 2";
					end
				end
				if (((6714 - (1569 + 320)) < (1189 + 3654)) and v53.ConjuredChillglobe:IsEquippedAndReady()) then
					if (v26(v58.ConjuredChillglobe) or ((737 + 3140) >= (15288 - 10751))) then
						return "conjured_chillglobe items 4";
					end
				end
				break;
			end
			if (((605 - (316 + 289)) == v155) or ((11295 - 6980) < (80 + 1646))) then
				v156 = v118();
				if (v156 or ((5132 - (666 + 787)) < (1050 - (360 + 65)))) then
					return v156;
				end
				v155 = 1 + 0;
			end
		end
	end
	local function v120()
		if (v68 or ((4879 - (79 + 175)) < (996 - 364))) then
			local v162 = 0 + 0;
			local v163;
			while true do
				if ((v162 == (2 - 1)) or ((159 - 76) > (2679 - (503 + 396)))) then
					if (((727 - (92 + 89)) <= (2089 - 1012)) and v52.Berserking:IsCastable()) then
						if (v26(v52.Berserking) or ((511 + 485) > (2546 + 1755))) then
							return "berserking ogcd 4";
						end
					end
					if (((15938 - 11868) > (94 + 593)) and v52.BloodFury:IsCastable()) then
						if (v26(v52.BloodFury) or ((1495 - 839) >= (2906 + 424))) then
							return "blood_fury ogcd 6";
						end
					end
					v162 = 1 + 1;
				end
				if (((5 - 3) == v162) or ((312 + 2180) <= (510 - 175))) then
					if (((5566 - (485 + 759)) >= (5928 - 3366)) and v52.Fireblood:IsCastable()) then
						if (v26(v52.Fireblood) or ((4826 - (442 + 747)) >= (4905 - (832 + 303)))) then
							return "fireblood ogcd 8";
						end
					end
					break;
				end
				if ((v162 == (946 - (88 + 858))) or ((726 + 1653) > (3789 + 789))) then
					v163 = v50.HandleDPSPotion();
					if (v163 or ((20 + 463) > (1532 - (766 + 23)))) then
						return v163;
					end
					v162 = 4 - 3;
				end
			end
		end
	end
	local function v121()
		if (((3356 - 902) > (1522 - 944)) and v32) then
			local v164 = v120();
			if (((3156 - 2226) < (5531 - (1036 + 37))) and v164) then
				return v164;
			end
		end
		local v157 = v119();
		if (((470 + 192) <= (1892 - 920)) and v157) then
			return v157;
		end
		if (((3438 + 932) == (5850 - (641 + 839))) and v52.Haunt:IsReady() and (v18:DebuffRemains(v52.HauntDebuff) < (916 - (910 + 3)))) then
			if (v25(v52.Haunt, nil, nil, not v18:IsSpellInRange(v52.Haunt)) or ((12139 - 7377) <= (2545 - (1466 + 218)))) then
				return "haunt aoe 2";
			end
		end
		if ((v52.VileTaint:IsReady() and (((v52.SouleatersGluttony:TalentRank() == (1 + 1)) and ((v69 < (1149.5 - (556 + 592))) or (v52.SoulRot:CooldownRemains() <= v52.VileTaint:ExecuteTime()))) or ((v52.SouleatersGluttony:TalentRank() == (1 + 0)) and (v52.SoulRot:CooldownRemains() <= v52.VileTaint:ExecuteTime())) or (not v52.SouleatersGluttony:IsAvailable() and ((v52.SoulRot:CooldownRemains() <= v52.VileTaint:ExecuteTime()) or (v52.VileTaint:CooldownRemains() > (833 - (329 + 479))))))) or ((2266 - (174 + 680)) == (14651 - 10387))) then
			if (v25(v58.VileTaintCursor, nil, nil, not v18:IsInRange(82 - 42)) or ((2262 + 906) < (2892 - (396 + 343)))) then
				return "vile_taint aoe 4";
			end
		end
		if ((v52.PhantomSingularity:IsCastable() and ((v52.SoulRot:IsAvailable() and (v52.SoulRot:CooldownRemains() <= v52.PhantomSingularity:ExecuteTime())) or (not v52.SouleatersGluttony:IsAvailable() and (not v52.SoulRot:IsAvailable() or (v52.SoulRot:CooldownRemains() <= v52.PhantomSingularity:ExecuteTime()) or (v52.SoulRot:CooldownRemains() >= (3 + 22))))) and v18:DebuffUp(v52.AgonyDebuff)) or ((6453 - (29 + 1448)) < (2721 - (135 + 1254)))) then
			if (((17434 - 12806) == (21608 - 16980)) and v25(v52.PhantomSingularity, v47, nil, not v18:IsSpellInRange(v52.PhantomSingularity))) then
				return "phantom_singularity aoe 6";
			end
		end
		if ((v52.UnstableAffliction:IsReady() and (v18:DebuffRemains(v52.UnstableAfflictionDebuff) < (4 + 1))) or ((1581 - (389 + 1138)) == (969 - (102 + 472)))) then
			if (((78 + 4) == (46 + 36)) and v25(v52.UnstableAffliction, nil, nil, not v18:IsSpellInRange(v52.UnstableAffliction))) then
				return "unstable_affliction aoe 8";
			end
		end
		if ((v52.Agony:IsReady() and (v52.AgonyDebuff:AuraActiveCount() < (8 + 0)) and (((v78 * (1547 - (320 + 1225))) + v52.SoulRot:CastTime()) < v72)) or ((1033 - 452) < (173 + 109))) then
			if (v50.CastTargetIf(v52.Agony, v59, "min", v96, v103, not v18:IsSpellInRange(v52.Agony)) or ((6073 - (157 + 1307)) < (4354 - (821 + 1038)))) then
				return "agony aoe 9";
			end
		end
		if (((2873 - 1721) == (126 + 1026)) and v52.SiphonLife:IsReady() and (v52.SiphonLifeDebuff:AuraActiveCount() < (10 - 4)) and v52.SummonDarkglare:CooldownUp() and (HL.CombatTime() < (8 + 12)) and (((v78 * (4 - 2)) + v52.SoulRot:CastTime()) < v72)) then
			if (((2922 - (834 + 192)) <= (218 + 3204)) and v50.CastCycle(v52.SiphonLife, v59, v115, not v18:IsSpellInRange(v52.SiphonLife))) then
				return "siphon_life aoe 10";
			end
		end
		if ((v52.SoulRot:IsReady() and v63 and (v62 or (v52.SouleatersGluttony:TalentRank() ~= (1 + 0))) and v18:DebuffUp(v52.AgonyDebuff)) or ((22 + 968) > (2509 - 889))) then
			if (v25(v52.SoulRot, nil, nil, not v18:IsSpellInRange(v52.SoulRot)) or ((1181 - (300 + 4)) > (1254 + 3441))) then
				return "soul_rot aoe 12";
			end
		end
		if (((7044 - 4353) >= (2213 - (112 + 250))) and v52.SeedofCorruption:IsReady() and (v18:DebuffRemains(v52.CorruptionDebuff) < (2 + 3)) and not (v52.SeedofCorruption:InFlight() or v18:DebuffUp(v52.SeedofCorruptionDebuff))) then
			if (v25(v52.SeedofCorruption, nil, nil, not v18:IsSpellInRange(v52.SeedofCorruption)) or ((7478 - 4493) >= (2782 + 2074))) then
				return "seed_of_corruption aoe 14";
			end
		end
		if (((2212 + 2064) >= (894 + 301)) and v52.Corruption:IsReady() and not v52.SeedofCorruption:IsAvailable()) then
			if (((1603 + 1629) <= (3485 + 1205)) and v50.CastTargetIf(v52.Corruption, v59, "min", v97, v105, not v18:IsSpellInRange(v52.Corruption))) then
				return "corruption aoe 15";
			end
		end
		if ((v32 and v52.SummonDarkglare:IsCastable() and v62 and v63 and v65) or ((2310 - (1001 + 413)) >= (7015 - 3869))) then
			if (((3943 - (244 + 638)) >= (3651 - (627 + 66))) and v25(v52.SummonDarkglare, v48)) then
				return "summon_darkglare aoe 18";
			end
		end
		if (((9495 - 6308) >= (1246 - (512 + 90))) and v52.DrainLife:IsReady() and (v14:BuffStack(v52.InevitableDemiseBuff) > (1936 - (1665 + 241))) and v14:BuffUp(v52.SoulRot) and (v14:BuffRemains(v52.SoulRot) <= v78) and (v61 > (720 - (373 + 344)))) then
			if (((291 + 353) <= (187 + 517)) and v50.CastTargetIf(v52.DrainLife, v59, "min", v100, nil, not v18:IsSpellInRange(v52.DrainLife))) then
				return "drain_life aoe 19";
			end
		end
		if (((2526 - 1568) > (1602 - 655)) and v52.MaleficRapture:IsReady() and v14:BuffUp(v52.UmbrafireKindlingBuff) and ((((v61 < (1105 - (35 + 1064))) or (HL.CombatTime() < (22 + 8))) and v94()) or not v52.DoomBlossom:IsAvailable())) then
			if (((9610 - 5118) >= (11 + 2643)) and v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(1336 - (298 + 938)))) then
				return "malefic_rapture aoe 20";
			end
		end
		if (((4701 - (233 + 1026)) >= (3169 - (636 + 1030))) and v52.SeedofCorruption:IsReady() and v52.SowTheSeeds:IsAvailable()) then
			if (v25(v52.SeedofCorruption, nil, nil, not v18:IsSpellInRange(v52.SeedofCorruption)) or ((1621 + 1549) <= (1430 + 34))) then
				return "seed_of_corruption aoe 22";
			end
		end
		if ((v52.MaleficRapture:IsReady() and ((((v52.SummonDarkglare:CooldownRemains() > (5 + 10)) or (v75 > (1 + 2))) and not v52.SowTheSeeds:IsAvailable()) or v14:BuffUp(v52.TormentedCrescendoBuff))) or ((5018 - (55 + 166)) == (851 + 3537))) then
			if (((56 + 495) <= (2600 - 1919)) and v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(397 - (36 + 261)))) then
				return "malefic_rapture aoe 24";
			end
		end
		if (((5730 - 2453) > (1775 - (34 + 1334))) and v52.DrainLife:IsReady() and (v18:DebuffUp(v52.SoulRotDebuff) or not v52.SoulRot:IsAvailable()) and (v14:BuffStack(v52.InevitableDemiseBuff) > (4 + 6))) then
			if (((3648 + 1047) >= (2698 - (1035 + 248))) and v25(v52.DrainLife, nil, nil, not v18:IsSpellInRange(v52.DrainLife))) then
				return "drain_life aoe 26";
			end
		end
		if ((v52.DrainSoul:IsReady() and v14:BuffUp(v52.NightfallBuff) and v52.ShadowEmbrace:IsAvailable()) or ((3233 - (20 + 1)) <= (492 + 452))) then
			if (v50.CastCycle(v52.DrainSoul, v59, v112, not v18:IsSpellInRange(v52.DrainSoul)) or ((3415 - (134 + 185)) <= (2931 - (549 + 584)))) then
				return "drain_soul aoe 28";
			end
		end
		if (((4222 - (314 + 371)) == (12142 - 8605)) and v52.DrainSoul:IsReady() and (v14:BuffUp(v52.NightfallBuff))) then
			if (((4805 - (478 + 490)) >= (832 + 738)) and v25(v52.DrainSoul, nil, nil, not v18:IsSpellInRange(v52.DrainSoul))) then
				return "drain_soul aoe 30";
			end
		end
		if ((v52.SummonSoulkeeper:IsReady() and ((v52.SummonSoulkeeper:Count() == (1182 - (786 + 386))) or ((v52.SummonSoulkeeper:Count() > (9 - 6)) and (v77 < (1389 - (1055 + 324)))))) or ((4290 - (1093 + 247)) == (3388 + 424))) then
			if (((497 + 4226) >= (9202 - 6884)) and v25(v52.SummonSoulkeeper)) then
				return "soul_strike aoe 32";
			end
		end
		if ((v52.SiphonLife:IsReady() and (v52.SiphonLifeDebuff:AuraActiveCount() < (16 - 11)) and ((v61 < (22 - 14)) or not v52.DoomBlossom:IsAvailable())) or ((5093 - 3066) > (1015 + 1837))) then
			if (v50.CastCycle(v52.SiphonLife, v59, v114, not v18:IsSpellInRange(v52.SiphonLife)) or ((4376 - 3240) > (14879 - 10562))) then
				return "siphon_life aoe 34";
			end
		end
		if (((3581 + 1167) == (12142 - 7394)) and v52.DrainSoul:IsReady()) then
			if (((4424 - (364 + 324)) <= (12994 - 8254)) and v50.CastCycle(v52.DrainSoul, v59, v113, not v18:IsSpellInRange(v52.DrainSoul))) then
				return "drain_soul aoe 36";
			end
		end
		if (v52.ShadowBolt:IsReady() or ((8134 - 4744) <= (1015 + 2045))) then
			if (v25(v52.ShadowBolt, nil, nil, not v18:IsSpellInRange(v52.ShadowBolt)) or ((4179 - 3180) > (4312 - 1619))) then
				return "shadow_bolt aoe 38";
			end
		end
	end
	local function v122()
		if (((1405 - 942) < (1869 - (1249 + 19))) and v32) then
			local v165 = v120();
			if (v165 or ((1971 + 212) < (2673 - 1986))) then
				return v165;
			end
		end
		local v158 = v119();
		if (((5635 - (686 + 400)) == (3570 + 979)) and v158) then
			return v158;
		end
		if (((4901 - (73 + 156)) == (23 + 4649)) and v32 and v52.SummonDarkglare:IsCastable() and v62 and v63 and v65) then
			if (v25(v52.SummonDarkglare, v48) or ((4479 - (721 + 90)) < (5 + 390))) then
				return "summon_darkglare cleave 2";
			end
		end
		if ((v52.MaleficRapture:IsReady() and ((v52.DreadTouch:IsAvailable() and (v18:DebuffRemains(v52.DreadTouchDebuff) < (6 - 4)) and (v18:DebuffRemains(v52.AgonyDebuff) > v78) and v18:DebuffUp(v52.CorruptionDebuff) and (not v52.SiphonLife:IsAvailable() or v18:DebuffUp(v52.SiphonLifeDebuff)) and v18:DebuffUp(v52.UnstableAfflictionDebuff) and (not v52.PhantomSingularity:IsAvailable() or v52.PhantomSingularity:CooldownDown()) and (not v52.VileTaint:IsAvailable() or v52.VileTaint:CooldownDown()) and (not v52.SoulRot:IsAvailable() or v52.SoulRot:CooldownDown())) or (v75 > (474 - (224 + 246))))) or ((6748 - 2582) == (837 - 382))) then
			if (v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(19 + 81)) or ((106 + 4343) == (1956 + 707))) then
				return "malefic_rapture cleave 2";
			end
		end
		if ((v52.VileTaint:IsReady() and (not v52.SoulRot:IsAvailable() or (v69 < (1.5 - 0)) or (v52.SoulRot:CooldownRemains() <= (v52.VileTaint:ExecuteTime() + v78)) or (not v52.SouleatersGluttony:IsAvailable() and (v52.SoulRot:CooldownRemains() >= (39 - 27))))) or ((4790 - (203 + 310)) < (4982 - (1238 + 755)))) then
			if (v25(v52.VileTaint, nil, nil, not v18:IsInRange(3 + 37)) or ((2404 - (709 + 825)) >= (7645 - 3496))) then
				return "vile_taint cleave 4";
			end
		end
		if (((3221 - 1009) < (4047 - (196 + 668))) and v52.VileTaint:IsReady() and (v52.AgonyDebuff:AuraActiveCount() == (7 - 5)) and (v52.CorruptionDebuff:AuraActiveCount() == (3 - 1)) and (not v52.SiphonLife:IsAvailable() or (v52.SiphonLifeDebuff:AuraActiveCount() == (835 - (171 + 662)))) and (not v52.SoulRot:IsAvailable() or (v52.SoulRot:CooldownRemains() <= v52.VileTaint:ExecuteTime()) or (not v52.SouleatersGluttony:IsAvailable() and (v52.SoulRot:CooldownRemains() >= (105 - (4 + 89)))))) then
			if (((16283 - 11637) > (1090 + 1902)) and v25(v58.VileTaintCursor, nil, nil, not v18:IsSpellInRange(v52.VileTaint))) then
				return "vile_taint cleave 10";
			end
		end
		if (((6298 - 4864) < (1219 + 1887)) and v52.SoulRot:IsReady() and v63 and (v62 or (v52.SouleatersGluttony:TalentRank() ~= (1487 - (35 + 1451)))) and (v52.AgonyDebuff:AuraActiveCount() >= (1455 - (28 + 1425)))) then
			if (((2779 - (941 + 1052)) < (2899 + 124)) and v25(v52.SoulRot, nil, nil, not v18:IsSpellInRange(v52.SoulRot))) then
				return "soul_rot cleave 8";
			end
		end
		if (v52.Agony:IsReady() or ((3956 - (822 + 692)) < (105 - 31))) then
			if (((2137 + 2398) == (4832 - (45 + 252))) and v50.CastTargetIf(v52.Agony, v59, "min", v96, v104, not v18:IsSpellInRange(v52.Agony))) then
				return "agony cleave 10";
			end
		end
		if ((v52.UnstableAffliction:IsReady() and (v18:DebuffRemains(v52.UnstableAfflictionDebuff) < (5 + 0)) and (v77 > (2 + 1))) or ((7322 - 4313) <= (2538 - (114 + 319)))) then
			if (((2627 - 797) < (4700 - 1031)) and v25(v52.UnstableAffliction, nil, nil, not v18:IsSpellInRange(v52.UnstableAffliction))) then
				return "unstable_affliction cleave 12";
			end
		end
		if ((v52.SeedofCorruption:IsReady() and not v52.AbsoluteCorruption:IsAvailable() and (v18:DebuffRemains(v52.CorruptionDebuff) < (4 + 1)) and v52.SowTheSeeds:IsAvailable() and v93(v59)) or ((2130 - 700) >= (7567 - 3955))) then
			if (((4646 - (556 + 1407)) >= (3666 - (741 + 465))) and v25(v52.SeedofCorruption, nil, nil, not v18:IsSpellInRange(v52.SeedofCorruption))) then
				return "seed_of_corruption cleave 14";
			end
		end
		if ((v52.Haunt:IsReady() and (v18:DebuffRemains(v52.HauntDebuff) < (468 - (170 + 295)))) or ((951 + 853) >= (3009 + 266))) then
			if (v25(v52.Haunt, nil, nil, not v18:IsSpellInRange(v52.Haunt)) or ((3488 - 2071) > (3009 + 620))) then
				return "haunt cleave 16";
			end
		end
		if (((3076 + 1719) > (228 + 174)) and v52.Corruption:IsReady() and not (v52.SeedofCorruption:InFlight() or (v18:DebuffRemains(v52.SeedofCorruptionDebuff) > (1230 - (957 + 273)))) and (v77 > (2 + 3))) then
			if (((1927 + 2886) > (13584 - 10019)) and v50.CastTargetIf(v52.Corruption, v59, "min", v97, v105, not v18:IsSpellInRange(v52.Corruption))) then
				return "corruption cleave 18";
			end
		end
		if (((10308 - 6396) == (11948 - 8036)) and v52.SiphonLife:IsReady() and (v77 > (24 - 19))) then
			if (((4601 - (389 + 1391)) <= (3027 + 1797)) and v50.CastTargetIf(v52.SiphonLife, v59, "min", v99, v107, not v18:IsSpellInRange(v52.SiphonLife))) then
				return "siphon_life cleave 20";
			end
		end
		if (((181 + 1557) <= (4997 - 2802)) and v52.SummonDarkglare:IsReady() and (not v52.ShadowEmbrace:IsAvailable() or (v18:DebuffStack(v52.ShadowEmbraceDebuff) == (954 - (783 + 168)))) and v62 and v63 and v65) then
			if (((137 - 96) <= (2969 + 49)) and v25(v52.SummonDarkglare, v48)) then
				return "summon_darkglare cleave 22";
			end
		end
		if (((2456 - (309 + 2)) <= (12602 - 8498)) and v52.MaleficRapture:IsReady() and v52.TormentedCrescendo:IsAvailable() and (v14:BuffStack(v52.TormentedCrescendoBuff) == (1213 - (1090 + 122))) and (v75 > (1 + 2))) then
			if (((9030 - 6341) < (3316 + 1529)) and v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(1218 - (628 + 490)))) then
				return "malefic_rapture cleave 24";
			end
		end
		if ((v52.DrainSoul:IsReady() and v52.ShadowEmbrace:IsAvailable() and ((v18:DebuffStack(v52.ShadowEmbraceDebuff) < (1 + 2)) or (v18:DebuffRemains(v52.ShadowEmbraceDebuff) < (7 - 4)))) or ((10611 - 8289) > (3396 - (431 + 343)))) then
			if (v25(v52.DrainSoul, nil, nil, not v18:IsSpellInRange(v52.DrainSoul)) or ((9156 - 4622) == (6022 - 3940))) then
				return "drain_soul cleave 26";
			end
		end
		if ((v74:IsReady() and (v14:BuffUp(v52.NightfallBuff))) or ((1242 + 329) > (239 + 1628))) then
			if (v50.CastTargetIf(v74, v59, "min", v98, v106, not v18:IsSpellInRange(v74)) or ((4349 - (556 + 1139)) >= (3011 - (6 + 9)))) then
				return "drain_soul/shadow_bolt cleave 28";
			end
		end
		if (((729 + 3249) > (1078 + 1026)) and v52.MaleficRapture:IsReady() and not v52.DreadTouch:IsAvailable() and v14:BuffUp(v52.TormentedCrescendoBuff)) then
			if (((3164 - (28 + 141)) > (597 + 944)) and v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(123 - 23))) then
				return "malefic_rapture cleave 30";
			end
		end
		if (((2302 + 947) > (2270 - (486 + 831))) and v52.MaleficRapture:IsReady() and (v66 or v64)) then
			if (v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(260 - 160)) or ((11522 - 8249) > (865 + 3708))) then
				return "malefic_rapture cleave 32";
			end
		end
		if ((v52.MaleficRapture:IsReady() and (v75 > (9 - 6))) or ((4414 - (668 + 595)) < (1156 + 128))) then
			if (v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(21 + 79)) or ((5045 - 3195) == (1819 - (23 + 267)))) then
				return "malefic_rapture cleave 34";
			end
		end
		if (((2765 - (1129 + 815)) < (2510 - (371 + 16))) and v52.DrainLife:IsReady() and ((v14:BuffStack(v52.InevitableDemiseBuff) > (1798 - (1326 + 424))) or ((v14:BuffStack(v52.InevitableDemiseBuff) > (37 - 17)) and (v77 < (14 - 10))))) then
			if (((1020 - (88 + 30)) < (3096 - (720 + 51))) and v25(v52.DrainLife, nil, nil, not v18:IsSpellInRange(v52.DrainLife))) then
				return "drain_life cleave 36";
			end
		end
		if (((1908 - 1050) <= (4738 - (421 + 1355))) and v52.DrainLife:IsReady() and v14:BuffUp(v52.SoulRot) and (v14:BuffStack(v52.InevitableDemiseBuff) > (49 - 19))) then
			if (v25(v52.DrainLife, nil, nil, not v18:IsSpellInRange(v52.DrainLife)) or ((1939 + 2007) < (2371 - (286 + 797)))) then
				return "drain_life cleave 38";
			end
		end
		if (v52.Agony:IsReady() or ((11851 - 8609) == (939 - 372))) then
			if (v50.CastCycle(v52.Agony, v59, v109, not v18:IsSpellInRange(v52.Agony)) or ((1286 - (397 + 42)) >= (395 + 868))) then
				return "agony cleave 40";
			end
		end
		if (v52.Corruption:IsCastable() or ((3053 - (24 + 776)) == (2851 - 1000))) then
			if (v50.CastCycle(v52.Corruption, v59, v111, not v18:IsSpellInRange(v52.Corruption)) or ((2872 - (222 + 563)) > (5225 - 2853))) then
				return "corruption cleave 42";
			end
		end
		if ((v52.MaleficRapture:IsReady() and (v75 > (1 + 0))) or ((4635 - (23 + 167)) < (5947 - (690 + 1108)))) then
			if (v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(37 + 63)) or ((1500 + 318) == (933 - (40 + 808)))) then
				return "malefic_rapture cleave 44";
			end
		end
		if (((104 + 526) < (8133 - 6006)) and v52.DrainSoul:IsReady()) then
			if (v25(v52.DrainSoul, nil, nil, not v18:IsSpellInRange(v52.DrainSoul)) or ((1853 + 85) == (1330 + 1184))) then
				return "drain_soul cleave 54";
			end
		end
		if (((2334 + 1921) >= (626 - (47 + 524))) and v74:IsReady()) then
			if (((1947 + 1052) > (3159 - 2003)) and v25(v74, nil, nil, not v18:IsSpellInRange(v74))) then
				return "drain_soul/shadow_bolt cleave 46";
			end
		end
	end
	local function v123()
		local v159 = 0 - 0;
		while true do
			if (((5359 - 3009) > (2881 - (1165 + 561))) and (v159 == (1 + 0))) then
				v59 = v14:GetEnemiesInRange(123 - 83);
				v60 = v18:GetEnemiesInSplashRange(4 + 6);
				if (((4508 - (341 + 138)) <= (1311 + 3542)) and v31) then
					v61 = v18:GetEnemiesInSplashRangeCount(20 - 10);
				else
					v61 = 327 - (89 + 237);
				end
				if (v50.TargetIsValid() or v14:AffectingCombat() or ((1659 - 1143) > (7229 - 3795))) then
					v76 = v11.BossFightRemains(nil, true);
					v77 = v76;
					if (((4927 - (581 + 300)) >= (4253 - (855 + 365))) and (v77 == (26390 - 15279))) then
						v77 = v11.FightRemains(v60, false);
					end
				end
				v159 = 1 + 1;
			end
			if ((v159 == (1235 - (1030 + 205))) or ((2553 + 166) <= (1347 + 100))) then
				v49();
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v159 = 287 - (156 + 130);
			end
			if ((v159 == (6 - 3)) or ((6966 - 2832) < (8040 - 4114))) then
				v72 = v29(v70 * v27(v52.VileTaint:IsAvailable()), v71 * v27(v52.PhantomSingularity:IsAvailable()));
				v78 = v14:GCD() + 0.25 + 0;
				if ((v52.SummonPet:IsCastable() and v44 and not v17:IsActive()) or ((96 + 68) >= (2854 - (10 + 59)))) then
					if (v26(v52.SummonPet) or ((149 + 376) == (10386 - 8277))) then
						return "summon_pet ooc";
					end
				end
				if (((1196 - (671 + 492)) == (27 + 6)) and v50.TargetIsValid()) then
					local v183 = 1215 - (369 + 846);
					while true do
						if (((809 + 2245) <= (3427 + 588)) and (v183 == (1952 - (1036 + 909)))) then
							if (((1488 + 383) < (5677 - 2295)) and v52.DrainLife:IsReady() and ((v14:BuffStack(v52.InevitableDemiseBuff) > (251 - (11 + 192))) or ((v14:BuffStack(v52.InevitableDemiseBuff) > (11 + 9)) and (v77 < (179 - (135 + 40)))))) then
								if (((3132 - 1839) <= (1306 + 860)) and v25(v52.DrainLife, nil, nil, not v18:IsSpellInRange(v52.DrainLife))) then
									return "drain_life main 30";
								end
							end
							if ((v52.DrainSoul:IsReady() and (v14:BuffUp(v52.NightfallBuff))) or ((5681 - 3102) < (184 - 61))) then
								if (v25(v52.DrainSoul, nil, nil, not v18:IsSpellInRange(v52.DrainSoul)) or ((1022 - (50 + 126)) >= (6593 - 4225))) then
									return "drain_soul main 32";
								end
							end
							if ((v52.ShadowBolt:IsReady() and (v14:BuffUp(v52.NightfallBuff))) or ((888 + 3124) <= (4771 - (1233 + 180)))) then
								if (((2463 - (522 + 447)) <= (4426 - (107 + 1314))) and v25(v52.ShadowBolt, nil, nil, not v18:IsSpellInRange(v52.ShadowBolt))) then
									return "shadow_bolt main 34";
								end
							end
							v183 = 4 + 4;
						end
						if ((v183 == (11 - 7)) or ((1322 + 1789) == (4237 - 2103))) then
							if (((9317 - 6962) == (4265 - (716 + 1194))) and v52.Agony:IsCastable() and (not v52.VileTaint:IsAvailable() or (v18:DebuffRemains(v52.AgonyDebuff) < (v52.VileTaint:CooldownRemains() + v52.VileTaint:CastTime()))) and (v18:DebuffRemains(v52.AgonyDebuff) < (1 + 4)) and (v77 > (1 + 4))) then
								if (v25(v52.Agony, nil, nil, not v18:IsSpellInRange(v52.Agony)) or ((1091 - (74 + 429)) <= (833 - 401))) then
									return "agony main 12";
								end
							end
							if (((2378 + 2419) >= (8916 - 5021)) and v52.UnstableAffliction:IsReady() and (v18:DebuffRemains(v52.UnstableAfflictionDebuff) < (4 + 1)) and (v77 > (8 - 5))) then
								if (((8843 - 5266) == (4010 - (279 + 154))) and v25(v52.UnstableAffliction, nil, nil, not v18:IsSpellInRange(v52.UnstableAffliction))) then
									return "unstable_affliction main 14";
								end
							end
							if (((4572 - (454 + 324)) > (2906 + 787)) and v52.Haunt:IsReady() and (v18:DebuffRemains(v52.HauntDebuff) < (22 - (12 + 5)))) then
								if (v25(v52.Haunt, nil, nil, not v18:IsSpellInRange(v52.Haunt)) or ((688 + 587) == (10446 - 6346))) then
									return "haunt main 16";
								end
							end
							v183 = 2 + 3;
						end
						if ((v183 == (1093 - (277 + 816))) or ((6798 - 5207) >= (4763 - (1058 + 125)))) then
							if (((185 + 798) <= (2783 - (815 + 160))) and not v14:AffectingCombat() and v30) then
								local v184 = 0 - 0;
								local v185;
								while true do
									if ((v184 == (0 - 0)) or ((513 + 1637) <= (3498 - 2301))) then
										v185 = v116();
										if (((5667 - (41 + 1857)) >= (3066 - (1222 + 671))) and v185) then
											return v185;
										end
										break;
									end
								end
							end
							if (((3837 - 2352) == (2134 - 649)) and not v14:IsCasting() and not v14:IsChanneling()) then
								local v186 = 1182 - (229 + 953);
								local v187;
								while true do
									if (((1775 - (1111 + 663)) == v186) or ((4894 - (874 + 705)) <= (390 + 2392))) then
										if (v187 or ((598 + 278) >= (6160 - 3196))) then
											return v187;
										end
										v187 = v50.Interrupt(v52.AxeToss, 2 + 38, true);
										if (v187 or ((2911 - (642 + 37)) > (570 + 1927))) then
											return v187;
										end
										v186 = 1 + 1;
									end
									if ((v186 == (7 - 4)) or ((2564 - (233 + 221)) <= (767 - 435))) then
										if (((3245 + 441) > (4713 - (718 + 823))) and v187) then
											return v187;
										end
										v187 = v50.InterruptWithStun(v52.AxeToss, 26 + 14, true, v16, v58.AxeTossMouseover);
										if (v187 or ((5279 - (266 + 539)) < (2321 - 1501))) then
											return v187;
										end
										break;
									end
									if (((5504 - (636 + 589)) >= (6840 - 3958)) and (v186 == (0 - 0))) then
										v187 = v50.Interrupt(v52.SpellLock, 32 + 8, true);
										if (v187 or ((738 + 1291) >= (4536 - (657 + 358)))) then
											return v187;
										end
										v187 = v50.Interrupt(v52.SpellLock, 105 - 65, true, v16, v58.SpellLockMouseover);
										v186 = 2 - 1;
									end
									if (((1189 - (1151 + 36)) == v186) or ((1968 + 69) >= (1221 + 3421))) then
										v187 = v50.Interrupt(v52.AxeToss, 119 - 79, true, v16, v58.AxeTossMouseover);
										if (((3552 - (1552 + 280)) < (5292 - (64 + 770))) and v187) then
											return v187;
										end
										v187 = v50.InterruptWithStun(v52.AxeToss, 28 + 12, true);
										v186 = 6 - 3;
									end
								end
							end
							v117();
							v183 = 1 + 0;
						end
						if ((v183 == (1244 - (157 + 1086))) or ((872 - 436) > (13231 - 10210))) then
							if (((1092 - 379) <= (1155 - 308)) and (v61 > (820 - (599 + 220))) and (v61 < (5 - 2))) then
								local v188 = v122();
								if (((4085 - (1813 + 118)) <= (2947 + 1084)) and v188) then
									return v188;
								end
							end
							if (((5832 - (841 + 376)) == (6466 - 1851)) and (v61 > (1 + 1))) then
								local v189 = 0 - 0;
								local v190;
								while true do
									if (((859 - (464 + 395)) == v189) or ((9726 - 5936) == (241 + 259))) then
										v190 = v121();
										if (((926 - (467 + 370)) < (456 - 235)) and v190) then
											return v190;
										end
										break;
									end
								end
							end
							if (((1508 + 546) >= (4871 - 3450)) and v24()) then
								local v191 = 0 + 0;
								local v192;
								while true do
									if (((1609 - 917) < (3578 - (150 + 370))) and (v191 == (1282 - (74 + 1208)))) then
										v192 = v120();
										if (v192 or ((8003 - 4749) == (7848 - 6193))) then
											return v192;
										end
										break;
									end
								end
							end
							v183 = 2 + 0;
						end
						if ((v183 == (396 - (14 + 376))) or ((2247 - 951) == (3178 + 1732))) then
							if (((2959 + 409) == (3213 + 155)) and v52.DrainSoul:IsReady() and v52.ShadowEmbrace:IsAvailable() and ((v18:DebuffStack(v52.ShadowEmbraceDebuff) < (8 - 5)) or (v18:DebuffRemains(v52.ShadowEmbraceDebuff) < (3 + 0)))) then
								if (((2721 - (23 + 55)) < (9041 - 5226)) and v25(v52.DrainSoul, nil, nil, not v18:IsSpellInRange(v52.DrainSoul))) then
									return "drain_soul main 24";
								end
							end
							if (((1277 + 636) > (443 + 50)) and v52.ShadowBolt:IsReady() and v52.ShadowEmbrace:IsAvailable() and ((v18:DebuffStack(v52.ShadowEmbraceDebuff) < (4 - 1)) or (v18:DebuffRemains(v52.ShadowEmbraceDebuff) < (1 + 2)))) then
								if (((5656 - (652 + 249)) > (9173 - 5745)) and v25(v52.ShadowBolt, nil, nil, not v18:IsSpellInRange(v52.ShadowBolt))) then
									return "shadow_bolt main 26";
								end
							end
							if (((3249 - (708 + 1160)) <= (6430 - 4061)) and v52.MaleficRapture:IsReady() and ((v75 > (6 - 2)) or (v52.TormentedCrescendo:IsAvailable() and (v14:BuffStack(v52.TormentedCrescendoBuff) == (28 - (10 + 17))) and (v75 > (1 + 2))) or (v52.TormentedCrescendo:IsAvailable() and v14:BuffUp(v52.TormentedCrescendoBuff) and v18:DebuffDown(v52.DreadTouchDebuff)) or (v52.TormentedCrescendo:IsAvailable() and (v14:BuffStack(v52.TormentedCrescendoBuff) == (1734 - (1400 + 332)))) or v66 or (v64 and (v75 > (1 - 0))) or (v52.TormentedCrescendo:IsAvailable() and v52.Nightfall:IsAvailable() and v14:BuffUp(v52.TormentedCrescendoBuff) and v14:BuffUp(v52.NightfallBuff)))) then
								if (v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(2008 - (242 + 1666))) or ((2073 + 2770) == (1497 + 2587))) then
									return "malefic_rapture main 28";
								end
							end
							v183 = 6 + 1;
						end
						if (((5609 - (850 + 90)) > (635 - 272)) and (v183 == (1395 - (360 + 1030)))) then
							if ((v52.Corruption:IsCastable() and v18:DebuffRefreshable(v52.CorruptionDebuff) and (v77 > (5 + 0))) or ((5297 - 3420) >= (4317 - 1179))) then
								if (((6403 - (909 + 752)) >= (4849 - (109 + 1114))) and v25(v52.Corruption, nil, nil, not v18:IsSpellInRange(v52.Corruption))) then
									return "corruption main 18";
								end
							end
							if ((v52.SiphonLife:IsCastable() and v18:DebuffRefreshable(v52.SiphonLifeDebuff) and (v77 > (9 - 4))) or ((1768 + 2772) == (1158 - (6 + 236)))) then
								if (v25(v52.SiphonLife, nil, nil, not v18:IsSpellInRange(v52.SiphonLife)) or ((729 + 427) > (3498 + 847))) then
									return "siphon_life main 20";
								end
							end
							if (((5275 - 3038) < (7421 - 3172)) and v52.SummonDarkglare:IsReady() and (not v52.ShadowEmbrace:IsAvailable() or (v18:DebuffStack(v52.ShadowEmbraceDebuff) == (1136 - (1076 + 57)))) and v62 and v63 and v65) then
								if (v25(v52.SummonDarkglare, v48) or ((442 + 2241) < (712 - (579 + 110)))) then
									return "summon_darkglare main 22";
								end
							end
							v183 = 1 + 5;
						end
						if (((617 + 80) <= (439 + 387)) and (v183 == (410 - (174 + 233)))) then
							if (((3086 - 1981) <= (2063 - 887)) and v52.VileTaint:IsReady() and (not v52.SoulRot:IsAvailable() or (v69 < (1.5 + 0)) or (v52.SoulRot:CooldownRemains() <= (v52.VileTaint:ExecuteTime() + v78)) or (not v52.SouleatersGluttony:IsAvailable() and (v52.SoulRot:CooldownRemains() >= (1186 - (663 + 511)))))) then
								if (((3015 + 364) <= (828 + 2984)) and v25(v52.VileTaint, v46, nil, not v18:IsInRange(123 - 83))) then
									return "vile_taint main 6";
								end
							end
							if ((v52.PhantomSingularity:IsCastable() and ((v52.SoulRot:CooldownRemains() <= v52.PhantomSingularity:ExecuteTime()) or (not v52.SouleatersGluttony:IsAvailable() and (not v52.SoulRot:IsAvailable() or (v52.SoulRot:CooldownRemains() <= v52.PhantomSingularity:ExecuteTime()) or (v52.SoulRot:CooldownRemains() >= (16 + 9))))) and v18:DebuffUp(v52.AgonyDebuff)) or ((1855 - 1067) >= (3911 - 2295))) then
								if (((885 + 969) <= (6576 - 3197)) and v25(v52.PhantomSingularity, v47, nil, not v18:IsSpellInRange(v52.PhantomSingularity))) then
									return "phantom_singularity main 8";
								end
							end
							if (((3242 + 1307) == (416 + 4133)) and v52.SoulRot:IsReady() and v63 and (v62 or (v52.SouleatersGluttony:TalentRank() ~= (723 - (478 + 244)))) and v18:DebuffUp(v52.AgonyDebuff)) then
								if (v25(v52.SoulRot, nil, nil, not v18:IsSpellInRange(v52.SoulRot)) or ((3539 - (440 + 77)) >= (1375 + 1649))) then
									return "soul_rot main 10";
								end
							end
							v183 = 14 - 10;
						end
						if (((6376 - (655 + 901)) > (408 + 1790)) and (v183 == (2 + 0))) then
							if (v34 or ((717 + 344) >= (19704 - 14813))) then
								local v193 = 1445 - (695 + 750);
								local v194;
								while true do
									if (((4657 - 3293) <= (6902 - 2429)) and (v193 == (0 - 0))) then
										v194 = v119();
										if (v194 or ((3946 - (285 + 66)) <= (6 - 3))) then
											return v194;
										end
										break;
									end
								end
							end
							if ((v52.MaleficRapture:IsReady() and v52.DreadTouch:IsAvailable() and (v18:DebuffRemains(v52.DreadTouchDebuff) < (1312 - (682 + 628))) and (v18:DebuffRemains(v52.AgonyDebuff) > v78) and v18:DebuffUp(v52.CorruptionDebuff) and (not v52.SiphonLife:IsAvailable() or v18:DebuffUp(v52.SiphonLifeDebuff)) and v18:DebuffUp(v52.UnstableAfflictionDebuff) and (not v52.PhantomSingularity:IsAvailable() or v52.PhantomSingularity:CooldownDown()) and (not v52.VileTaint:IsAvailable() or v52.VileTaint:CooldownDown()) and (not v52.SoulRot:IsAvailable() or v52.SoulRot:CooldownDown())) or ((754 + 3918) == (4151 - (176 + 123)))) then
								if (((653 + 906) == (1131 + 428)) and v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(369 - (239 + 30)))) then
									return "malefic_rapture main 2";
								end
							end
							if ((v52.MaleficRapture:IsReady() and (v77 < (2 + 2))) or ((1684 + 68) <= (1394 - 606))) then
								if (v25(v52.MaleficRapture, nil, nil, not v18:IsInRange(311 - 211)) or ((4222 - (306 + 9)) == (617 - 440))) then
									return "malefic_rapture main 4";
								end
							end
							v183 = 1 + 2;
						end
						if (((2130 + 1340) > (268 + 287)) and ((22 - 14) == v183)) then
							if (v52.DrainSoul:IsReady() or ((2347 - (1140 + 235)) == (411 + 234))) then
								if (((2918 + 264) >= (543 + 1572)) and v25(v52.DrainSoul, nil, nil, not v18:IsSpellInRange(v52.DrainSoul))) then
									return "drain_soul main 36";
								end
							end
							if (((3945 - (33 + 19)) < (1600 + 2829)) and v52.ShadowBolt:IsReady()) then
								if (v25(v52.ShadowBolt, nil, nil, not v18:IsSpellInRange(v52.ShadowBolt)) or ((8593 - 5726) < (840 + 1065))) then
									return "shadow_bolt main 38";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v159 == (3 - 1)) or ((1685 + 111) >= (4740 - (586 + 103)))) then
				v75 = v14:SoulShardsP();
				v69 = v92(v60, v52.AgonyDebuff);
				v70 = v92(v60, v52.VileTaintDebuff);
				v71 = v92(v60, v52.PhantomSingularityDebuff);
				v159 = 1 + 2;
			end
		end
	end
	local function v124()
		local v160 = 0 - 0;
		while true do
			if (((3107 - (1309 + 179)) <= (6780 - 3024)) and (v160 == (1 + 0))) then
				v52.SiphonLifeDebuff:RegisterAuraTracking();
				v52.CorruptionDebuff:RegisterAuraTracking();
				v160 = 5 - 3;
			end
			if (((457 + 147) == (1282 - 678)) and ((3 - 1) == v160)) then
				v52.UnstableAfflictionDebuff:RegisterAuraTracking();
				break;
			end
			if ((v160 == (609 - (295 + 314))) or ((11013 - 6529) == (2862 - (1300 + 662)))) then
				v11.Print("Affliction Warlock rotation by Epic. Supported by Gojira");
				v52.AgonyDebuff:RegisterAuraTracking();
				v160 = 3 - 2;
			end
		end
	end
	v11.SetAPL(2020 - (1178 + 577), v123, v124);
end;
return v1["Epix_Warlock_Affliction.lua"](...);

