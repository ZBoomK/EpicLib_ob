local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((956 + 3180) <= (1141 + 2292))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Rogue_Subtlety.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Target;
	local v14 = v11.Focus;
	local v15 = v11.MouseOver;
	local v16 = v9.Spell;
	local v17 = v9.MultiSpell;
	local v18 = v9.Item;
	local v19 = v9.Utils;
	local v20 = v9.Utils.BoolToInt;
	local v21 = v9.AoEON;
	local v22 = v9.CDsON;
	local v23 = v9.Bind;
	local v24 = v9.Macro;
	local v25 = v9.Press;
	local v26 = v9.CastQueue;
	local v27 = v9.CastQueuePooling;
	local v28 = v9.Commons.Everyone.num;
	local v29 = v9.Commons.Everyone.bool;
	local v30 = pairs;
	local v31 = table.insert;
	local v32 = math.min;
	local v33 = math.max;
	local v34 = math.abs;
	local v35 = false;
	local v36 = false;
	local v37 = false;
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
	local function v84()
		local v137 = 0 + 0;
		while true do
			if (((5341 - (709 + 387)) <= (6489 - (673 + 1185))) and (v137 == (14 - 9))) then
				v68 = EpicSettings.Settings['StealthOOC'];
				v69 = EpicSettings.Settings['CrimsonVialGCD'];
				v70 = EpicSettings.Settings['FeintGCD'];
				v71 = EpicSettings.Settings['KickOffGCD'];
				v72 = EpicSettings.Settings['StealthOffGCD'];
				v137 = 19 - 13;
			end
			if (((7035 - 2759) >= (2800 + 1114)) and (v137 == (1 + 0))) then
				v42 = EpicSettings.Settings['UseHealthstone'];
				v43 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v44 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v45 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v46 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v137 = 1882 - (446 + 1434);
			end
			if (((1481 - (1040 + 243)) <= (13027 - 8662)) and (v137 == (1850 - (559 + 1288)))) then
				v58 = EpicSettings.Settings['KidneyShotInterrupt'];
				v59 = EpicSettings.Settings['RacialsGCD'];
				v60 = EpicSettings.Settings['RacialsOffGCD'];
				v61 = EpicSettings.Settings['VanishOffGCD'];
				v62 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v137 = 1935 - (609 + 1322);
			end
			if (((5236 - (13 + 441)) > (17473 - 12797)) and (v137 == (15 - 9))) then
				v73 = EpicSettings.Settings['EviscerateDMGOffset'] or true;
				v74 = EpicSettings.Settings['ShDEcoCharge'];
				v75 = EpicSettings.Settings['BurnShadowDance'];
				v76 = EpicSettings.Settings['PotionTypeSelectedSubtlety'];
				v77 = EpicSettings.Settings['ShurikenTornadoGCD'];
				v137 = 34 - 27;
			end
			if (((182 + 4682) > (7978 - 5781)) and (v137 == (2 + 2))) then
				v63 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v64 = EpicSettings.Settings['ColdBloodOffGCD'];
				v65 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v66 = EpicSettings.Settings['CrimsonVialHP'];
				v67 = EpicSettings.Settings['FeintHP'];
				v137 = 3 + 2;
			end
			if ((v137 == (5 - 3)) or ((2025 + 1675) == (4610 - 2103))) then
				v48 = EpicSettings.Settings['PoisonRefresh'];
				v49 = EpicSettings.Settings['PoisonRefreshCombat'];
				v50 = EpicSettings.Settings['RangedMultiDoT'];
				v51 = EpicSettings.Settings['UsePriorityRotation'];
				v57 = EpicSettings.Settings['STMfDAsDPSCD'];
				v137 = 2 + 1;
			end
			if (((2489 + 1985) >= (197 + 77)) and (v137 == (0 + 0))) then
				v38 = EpicSettings.Settings['UseRacials'];
				v52 = EpicSettings.Settings['UseTrinkets'];
				v39 = EpicSettings.Settings['UseHealingPotion'];
				v40 = EpicSettings.Settings['HealingPotionName'] or (0 + 0);
				v41 = EpicSettings.Settings['HealingPotionHP'] or (433 - (153 + 280));
				v137 = 2 - 1;
			end
			if ((v137 == (7 + 0)) or ((748 + 1146) <= (736 + 670))) then
				v78 = EpicSettings.Settings['SymbolsofDeathOffGCD'];
				v79 = EpicSettings.Settings['ShadowBladesOffGCD'];
				v80 = EpicSettings.Settings['VanishStealthMacro'];
				v81 = EpicSettings.Settings['ShadowmeldStealthMacro'];
				v82 = EpicSettings.Settings['ShadowDanceStealthMacro'];
				break;
			end
		end
	end
	local v85 = v9.Commons.Everyone;
	local v86 = v9.Commons.Rogue;
	local v87 = v16.Rogue.Subtlety;
	local v88 = v18.Rogue.Subtlety;
	local v89 = v24.Rogue.Subtlety;
	local v90 = {v88.ManicGrieftorch:ID(),v88.BeaconToTheBeyond:ID(),v88.Mirror:ID()};
	local v91, v92, v93, v94;
	local v95, v96, v97, v98, v99;
	local v100;
	local v101, v102, v103;
	local v104, v105;
	local v106, v107, v108, v109;
	local v110;
	v87.Eviscerate:RegisterDamageFormula(function()
		return v12:AttackPowerDamageMod() * v106 * (0.176 + 0) * (668.21 - (89 + 578)) * ((v87.Nightstalker:IsAvailable() and v12:StealthUp(true, false) and (1.08 + 0)) or (1 - 0)) * ((v87.DeeperStratagem:IsAvailable() and (1050.05 - (572 + 477))) or (1 + 0)) * ((v87.DarkShadow:IsAvailable() and v12:BuffUp(v87.ShadowDanceBuff) and (1.3 + 0)) or (1 + 0)) * ((v12:BuffUp(v87.SymbolsofDeath) and (87.1 - (84 + 2))) or (1 - 0)) * ((v12:BuffUp(v87.FinalityEviscerateBuff) and (1.3 + 0)) or (843 - (497 + 345))) * (1 + 0 + (v12:MasteryPct() / (17 + 83))) * ((1334 - (605 + 728)) + (v12:VersatilityDmgPct() / (72 + 28))) * ((v13:DebuffUp(v87.FindWeaknessDebuff) and (1.5 - 0)) or (1 + 0));
	end);
	v87.Rupture:RegisterPMultiplier(function()
		return (v12:BuffUp(v87.FinalityRuptureBuff) and (3.3 - 2)) or (1 + 0);
	end);
	local function v111(v138, v139)
		if (((4355 - 2783) >= (1156 + 375)) and not v101) then
			local v191 = 489 - (457 + 32);
			while true do
				if ((v191 == (0 + 0)) or ((6089 - (832 + 570)) < (4279 + 263))) then
					v101 = v138;
					v102 = v139 or (0 + 0);
					break;
				end
			end
		end
	end
	local function v112(v140)
		if (((11646 - 8355) > (803 + 864)) and not v103) then
			v103 = v140;
		end
	end
	local function v113()
		if (((v75 == "On Bosses not in Dungeons") and v12:IsInDungeonArea()) or ((1669 - (588 + 208)) == (5481 - 3447))) then
			return false;
		elseif (((v75 ~= "Always") and not v13:IsInBossList()) or ((4616 - (884 + 916)) < (22 - 11))) then
			return false;
		else
			return true;
		end
	end
	local function v114()
		local v141 = 0 + 0;
		while true do
			if (((4352 - (232 + 421)) < (6595 - (1569 + 320))) and (v141 == (0 + 0))) then
				if (((503 + 2143) >= (2951 - 2075)) and (v97 < (607 - (316 + 289)))) then
					return false;
				elseif (((1606 - 992) <= (148 + 3036)) and (v51 == "Always")) then
					return true;
				elseif (((4579 - (666 + 787)) == (3551 - (360 + 65))) and (v51 == "On Bosses") and v13:IsInBossList()) then
					return true;
				elseif ((v51 == "Auto") or ((2044 + 143) >= (5208 - (79 + 175)))) then
					if (((v12:InstanceDifficulty() == (25 - 9)) and (v13:NPCID() == (108443 + 30524))) or ((11884 - 8007) == (6884 - 3309))) then
						return true;
					elseif (((1606 - (503 + 396)) > (813 - (92 + 89))) and ((v13:NPCID() == (323912 - 156943)) or (v13:NPCID() == (85630 + 81341)) or (v13:NPCID() == (98821 + 68149)))) then
						return true;
					elseif ((v13:NPCID() == (718467 - 535004)) or (v13:NPCID() == (25118 + 158553)) or ((1244 - 698) >= (2342 + 342))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v115(v142, v143, v144, v145, v146)
		local v147 = 0 + 0;
		local v148;
		local v149;
		local v150;
		while true do
			if (((4461 - 2996) <= (537 + 3764)) and (v147 == (1 - 0))) then
				for v233, v234 in v30(v145) do
					if (((2948 - (485 + 759)) > (3297 - 1872)) and (v234:GUID() ~= v150) and v85.UnitIsCycleValid(v234, v149, -v234:DebuffRemains(v142)) and v143(v234)) then
						v148, v149 = v234, v234:TimeToDie();
					end
				end
				if (v148 or ((1876 - (442 + 747)) == (5369 - (832 + 303)))) then
					v9.Press(v148, v142);
				elseif (v50 or ((4276 - (88 + 858)) < (436 + 993))) then
					local v248 = 0 + 0;
					while true do
						if (((48 + 1099) >= (1124 - (766 + 23))) and (v248 == (4 - 3))) then
							if (((4697 - 1262) > (5524 - 3427)) and v148) then
								v9.Press(v148, v142);
							end
							break;
						end
						if (((0 - 0) == v248) or ((4843 - (1036 + 37)) >= (2865 + 1176))) then
							v148, v149 = nil, v144;
							for v258, v259 in v30(v96) do
								if (((v259:GUID() ~= v150) and v85.UnitIsCycleValid(v259, v149, -v259:DebuffRemains(v142)) and v143(v259)) or ((7382 - 3591) <= (1268 + 343))) then
									v148, v149 = v259, v259:TimeToDie();
								end
							end
							v248 = 1481 - (641 + 839);
						end
					end
				end
				break;
			end
			if ((v147 == (913 - (910 + 3))) or ((11670 - 7092) <= (3692 - (1466 + 218)))) then
				v148, v149 = nil, v144;
				v150 = v13:GUID();
				v147 = 1 + 0;
			end
		end
	end
	local function v116()
		return (1168 - (556 + 592)) + (v87.Vigor:TalentRank() * (9 + 16)) + (v28(v87.ThistleTea:IsAvailable()) * (828 - (329 + 479))) + (v28(v87.Shadowcraft:IsAvailable()) * (874 - (174 + 680)));
	end
	local function v117()
		return v87.ShadowDance:ChargesFractional() >= ((0.75 - 0) + v20(v87.ShadowDanceTalent:IsAvailable()));
	end
	local function v118()
		return v108 >= (5 - 2);
	end
	local function v119()
		return v12:BuffUp(v87.SliceandDice) or (v97 >= v86.CPMaxSpend());
	end
	local function v120()
		return v87.Premeditation:IsAvailable() and (v97 < (4 + 1));
	end
	local function v121(v151)
		return (v12:BuffUp(v87.ThistleTea) and (v97 == (740 - (396 + 343)))) or (v151 and ((v97 == (1 + 0)) or (v13:DebuffUp(v87.Rupture) and (v97 >= (1479 - (29 + 1448))))));
	end
	local function v122()
		return (not v12:BuffUp(v87.Premeditation) and (v97 == (1390 - (135 + 1254)))) or not v87.TheRotten:IsAvailable() or (v97 > (3 - 2));
	end
	local function v123()
		return v12:BuffDown(v87.PremeditationBuff) or (v97 > (4 - 3)) or ((v107 <= (2 + 0)) and v12:BuffUp(v87.TheRottenBuff) and not v12:HasTier(1557 - (389 + 1138), 576 - (102 + 472)));
	end
	local function v124(v152, v153)
		return v152 and ((v12:BuffStack(v87.DanseMacabreBuff) >= (3 + 0)) or not v87.DanseMacabre:IsAvailable()) and (not v153 or (v97 ~= (2 + 0)));
	end
	local function v125()
		return (not v12:BuffUp(v87.TheRotten) or not v12:HasTier(28 + 2, 1547 - (320 + 1225))) and (not v87.ColdBlood:IsAvailable() or (v87.ColdBlood:CooldownRemains() < (6 - 2)) or (v87.ColdBlood:CooldownRemains() > (7 + 3)));
	end
	local function v126(v154)
		return v12:BuffUp(v87.ShadowDanceBuff) and (v154:TimeSinceLastCast() < v87.ShadowDance:TimeSinceLastCast());
	end
	local function v124()
		return ((v126(v87.Shadowstrike) or v126(v87.ShurikenStorm)) and (v126(v87.Eviscerate) or v126(v87.BlackPowder) or v126(v87.Rupture))) or not v87.DanseMacabre:IsAvailable();
	end
	local function v127()
		return (not v88.WitherbarksBranch:IsEquipped() and not v88.AshesoftheEmbersoul:IsEquipped()) or (not v88.WitherbarksBranch:IsEquipped() and (v88.WitherbarksBranch:CooldownRemains() <= (1472 - (157 + 1307)))) or (v88.WitherbarksBranch:IsEquipped() and (v88.WitherbarksBranch:CooldownRemains() <= (1867 - (821 + 1038)))) or v88.BandolierOfTwistedBlades:IsEquipped() or v87.InvigoratingShadowdust:IsAvailable();
	end
	local function v128(v155, v156)
		local v157 = v12:BuffUp(v87.ShadowDanceBuff);
		local v158 = v12:BuffRemains(v87.ShadowDanceBuff);
		local v159 = v12:BuffRemains(v87.SymbolsofDeath);
		local v160 = v107;
		local v161 = v87.ColdBlood:CooldownRemains();
		local v162 = v87.SymbolsofDeath:CooldownRemains();
		local v163 = v12:BuffUp(v87.PremeditationBuff) or (v156 and v87.Premeditation:IsAvailable());
		if (((2806 - 1681) <= (228 + 1848)) and v156 and (v156:ID() == v87.ShadowDance:ID())) then
			local v192 = 0 - 0;
			while true do
				if ((v192 == (0 + 0)) or ((1841 - 1098) >= (5425 - (834 + 192)))) then
					v157 = true;
					v158 = 1 + 7 + v87.ImprovedShadowDance:TalentRank();
					v192 = 1 + 0;
				end
				if (((25 + 1130) < (2591 - 918)) and (v192 == (305 - (300 + 4)))) then
					if (v87.TheFirstDance:IsAvailable() or ((621 + 1703) <= (1513 - 935))) then
						v160 = v32(v12:ComboPointsMax(), v107 + (366 - (112 + 250)));
					end
					if (((1502 + 2265) == (9437 - 5670)) and v12:HasTier(18 + 12, 2 + 0)) then
						v159 = v33(v159, 5 + 1);
					end
					break;
				end
			end
		end
		if (((2028 + 2061) == (3038 + 1051)) and v156 and (v156:ID() == v87.Vanish:ID())) then
			local v193 = 1414 - (1001 + 413);
			while true do
				if (((9941 - 5483) >= (2556 - (244 + 638))) and (v193 == (693 - (627 + 66)))) then
					v161 = v32(0 - 0, v87.ColdBlood:CooldownRemains() - ((617 - (512 + 90)) * v87.InvigoratingShadowdust:TalentRank()));
					v162 = v32(1906 - (1665 + 241), v87.SymbolsofDeath:CooldownRemains() - ((732 - (373 + 344)) * v87.InvigoratingShadowdust:TalentRank()));
					break;
				end
			end
		end
		if (((439 + 533) <= (376 + 1042)) and v87.Rupture:IsCastable() and v87.Rupture:IsReady()) then
			if ((v13:DebuffDown(v87.Rupture) and (v13:TimeToDie() > (15 - 9))) or ((8356 - 3418) < (5861 - (35 + 1064)))) then
				if (v155 or ((1822 + 682) > (9122 - 4858))) then
					return v87.Rupture;
				else
					local v246 = 0 + 0;
					while true do
						if (((3389 - (298 + 938)) == (3412 - (233 + 1026))) and (v246 == (1666 - (636 + 1030)))) then
							if ((v87.Rupture:IsReady() and v9.Press(v87.Rupture)) or ((260 + 247) >= (2531 + 60))) then
								return "Cast Rupture";
							end
							v112(v87.Rupture);
							break;
						end
					end
				end
			end
		end
		if (((1332 + 3149) == (303 + 4178)) and not v12:StealthUp(true, true) and not v120() and (v97 < (227 - (55 + 166))) and not v157 and v9.BossFilteredFightRemains(">", v12:BuffRemains(v87.SliceandDice)) and (v12:BuffRemains(v87.SliceandDice) < ((1 + 0 + v12:ComboPoints()) * (1.8 + 0)))) then
			if (v155 or ((8890 - 6562) < (990 - (36 + 261)))) then
				return v87.SliceandDice;
			else
				local v235 = 0 - 0;
				while true do
					if (((5696 - (34 + 1334)) == (1664 + 2664)) and (v235 == (0 + 0))) then
						if (((2871 - (1035 + 248)) >= (1353 - (20 + 1))) and v87.SliceandDice:IsReady() and v9.Press(v87.SliceandDice)) then
							return "Cast Slice and Dice Premed";
						end
						v112(v87.SliceandDice);
						break;
					end
				end
			end
		end
		if (((not v121(v157) or v110) and (v13:TimeToDie() > (4 + 2)) and v13:DebuffRefreshable(v87.Rupture, v104)) or ((4493 - (134 + 185)) > (5381 - (549 + 584)))) then
			if (v155 or ((5271 - (314 + 371)) <= (281 - 199))) then
				return v87.Rupture;
			else
				if (((4831 - (478 + 490)) == (2047 + 1816)) and v87.Rupture:IsReady() and v9.Press(v87.Rupture)) then
					return "Cast Rupture";
				end
				v112(v87.Rupture);
			end
		end
		if ((v12:BuffUp(v87.FinalityRuptureBuff) and v157 and (v97 <= (1176 - (786 + 386))) and not v126(v87.Rupture)) or ((913 - 631) <= (1421 - (1055 + 324)))) then
			if (((5949 - (1093 + 247)) >= (681 + 85)) and v155) then
				return v87.Rupture;
			else
				local v236 = 0 + 0;
				while true do
					if ((v236 == (0 - 0)) or ((3909 - 2757) == (7079 - 4591))) then
						if (((8599 - 5177) > (1192 + 2158)) and v87.Rupture:IsReady() and v9.Press(v87.Rupture)) then
							return "Cast Rupture Finality";
						end
						v112(v87.Rupture);
						break;
					end
				end
			end
		end
		if (((3378 - 2501) > (1295 - 919)) and v87.ColdBlood:IsReady() and v124(v157, v163) and v87.SecretTechnique:IsReady()) then
			if (v64 or ((2352 + 766) <= (4733 - 2882))) then
				v9.Press(v87.ColdBlood);
			else
				if (v155 or ((853 - (364 + 324)) >= (9572 - 6080))) then
					return v87.ColdBlood;
				end
				if (((9475 - 5526) < (1610 + 3246)) and v9.Press(v87.ColdBlood)) then
					return "Cast Cold Blood (SecTec)";
				end
			end
		end
		if (v87.SecretTechnique:IsReady() or ((17892 - 13616) < (4829 - 1813))) then
			if (((14244 - 9554) > (5393 - (1249 + 19))) and v124(v157, v163) and (not v87.ColdBlood:IsAvailable() or (v64 and v87.ColdBlood:IsReady()) or v12:BuffUp(v87.ColdBlood) or (v161 > (v158 - (2 + 0))) or not v87.ImprovedShadowDance:IsAvailable())) then
				local v237 = 0 - 0;
				while true do
					if ((v237 == (1086 - (686 + 400))) or ((40 + 10) >= (1125 - (73 + 156)))) then
						if (v155 or ((9 + 1705) >= (3769 - (721 + 90)))) then
							return v87.SecretTechnique;
						end
						if (v9.Press(v87.SecretTechnique) or ((17 + 1474) < (2090 - 1446))) then
							return "Cast Secret Technique";
						end
						break;
					end
				end
			end
		end
		if (((1174 - (224 + 246)) < (1598 - 611)) and not v121(v157) and v87.Rupture:IsCastable()) then
			local v194 = 0 - 0;
			while true do
				if (((675 + 3043) > (46 + 1860)) and (v194 == (0 + 0))) then
					if ((not v155 and v36 and not v110 and (v97 >= (3 - 1))) or ((3187 - 2229) > (4148 - (203 + 310)))) then
						local function v249(v253)
							return v85.CanDoTUnit(v253, v105) and v253:DebuffRefreshable(v87.Rupture, v104);
						end
						v115(v87.Rupture, v249, (1995 - (1238 + 755)) * v160, v98);
					end
					if (((245 + 3256) <= (6026 - (709 + 825))) and v93 and (v13:DebuffRemains(v87.Rupture) < (v87.SymbolsofDeath:CooldownRemains() + (18 - 8))) and (v107 > (0 - 0)) and (v87.SymbolsofDeath:CooldownRemains() <= (869 - (196 + 668))) and v86.CanDoTUnit(v13, v105) and v13:FilteredTimeToDie(">", (19 - 14) + v87.SymbolsofDeath:CooldownRemains(), -v13:DebuffRemains(v87.Rupture))) then
						if (v155 or ((7129 - 3687) < (3381 - (171 + 662)))) then
							return v87.Rupture;
						else
							if (((2968 - (4 + 89)) >= (5131 - 3667)) and v87.Rupture:IsReady() and v9.Cast(v87.Rupture)) then
								return "Cast Rupture 2";
							end
							v112(v87.Rupture);
						end
					end
					break;
				end
			end
		end
		if ((v87.BlackPowder:IsCastable() and not v110 and (v97 >= (2 + 1))) or ((21069 - 16272) >= (1919 + 2974))) then
			if (v155 or ((2037 - (35 + 1451)) > (3521 - (28 + 1425)))) then
				return v87.BlackPowder;
			else
				if (((4107 - (941 + 1052)) > (906 + 38)) and v87.BlackPowder:IsReady() and v25(v87.BlackPowder)) then
					return "Cast Black Powder";
				end
				v112(v87.BlackPowder);
			end
		end
		if ((v87.Eviscerate:IsCastable() and v93 and (v107 > (1515 - (822 + 692)))) or ((3228 - 966) >= (1459 + 1637))) then
			if (v155 or ((2552 - (45 + 252)) >= (3500 + 37))) then
				return v87.Eviscerate;
			else
				if ((v87.Eviscerate:IsReady() and v25(v87.Eviscerate)) or ((1321 + 2516) < (3178 - 1872))) then
					return "Cast Eviscerate";
				end
				v112(v87.Eviscerate);
			end
		end
		return false;
	end
	local function v129(v164, v165)
		local v166 = 433 - (114 + 319);
		local v167;
		local v168;
		local v169;
		local v170;
		local v171;
		local v172;
		local v173;
		local v174;
		local v175;
		local v176;
		while true do
			if (((4235 - 1285) == (3780 - 830)) and (v166 == (2 + 0))) then
				v174 = v12:BuffUp(v86.VanishBuffSpell()) or (v165 and (v165:ID() == v87.Vanish:ID()));
				if ((v165 and (v165:ID() == v87.ShadowDance:ID())) or ((7036 - 2313) < (6909 - 3611))) then
					local v243 = 1963 - (556 + 1407);
					while true do
						if (((2342 - (741 + 465)) >= (619 - (170 + 295))) and (v243 == (1 + 0))) then
							if ((v87.TheRotten:IsAvailable() and v12:HasTier(28 + 2, 4 - 2)) or ((225 + 46) > (3045 + 1703))) then
								v169 = true;
							end
							if (((2685 + 2055) >= (4382 - (957 + 273))) and v87.TheFirstDance:IsAvailable()) then
								v170 = v32(v12:ComboPointsMax(), v107 + 2 + 2);
								v171 = v12:ComboPointsMax() - v170;
							end
							break;
						end
						if ((v243 == (0 + 0)) or ((9823 - 7245) >= (8933 - 5543))) then
							v167 = true;
							v168 = (24 - 16) + v87.ImprovedShadowDance:TalentRank();
							v243 = 4 - 3;
						end
					end
				end
				v175 = v86.EffectiveComboPoints(v170);
				v166 = 1783 - (389 + 1391);
			end
			if (((26 + 15) <= (173 + 1488)) and (v166 == (8 - 4))) then
				if (((1552 - (783 + 168)) < (11948 - 8388)) and (v175 >= v86.CPMaxSpend())) then
					return v128(v164, v165);
				end
				if (((232 + 3) < (998 - (309 + 2))) and v12:BuffUp(v87.ShurikenTornado) and (v171 <= (5 - 3))) then
					return v128(v164, v165);
				end
				if (((5761 - (1090 + 122)) > (374 + 779)) and (v108 <= ((3 - 2) + v28(v87.DeeperStratagem:IsAvailable() or v87.SecretStratagem:IsAvailable())))) then
					return v128(v164, v165);
				end
				v166 = 4 + 1;
			end
			if ((v166 == (1118 - (628 + 490))) or ((839 + 3835) < (11566 - 6894))) then
				v167 = v12:BuffUp(v87.ShadowDanceBuff);
				v168 = v12:BuffRemains(v87.ShadowDanceBuff);
				v169 = v12:BuffUp(v87.TheRottenBuff);
				v166 = 4 - 3;
			end
			if (((4442 - (431 + 343)) < (9211 - 4650)) and (v166 == (2 - 1))) then
				v170, v171 = v107, v108;
				v172 = v12:BuffUp(v87.PremeditationBuff) or (v165 and v87.Premeditation:IsAvailable());
				v173 = v12:BuffUp(v86.StealthSpell()) or (v165 and (v165:ID() == v86.StealthSpell():ID()));
				v166 = 2 + 0;
			end
			if ((v166 == (1 + 5)) or ((2150 - (556 + 1139)) == (3620 - (6 + 9)))) then
				if ((not v172 and (v97 >= (1 + 3))) or ((1365 + 1298) == (3481 - (28 + 141)))) then
					if (((1657 + 2620) <= (5523 - 1048)) and v164) then
						return v87.ShurikenStorm;
					elseif (v25(v87.ShurikenStorm) or ((617 + 253) == (2506 - (486 + 831)))) then
						return "Cast Shuriken Storm";
					end
				end
				if (((4041 - 2488) <= (11029 - 7896)) and v176) then
					if (v164 or ((423 + 1814) >= (11101 - 7590))) then
						return v87.Shadowstrike;
					elseif (v25(v87.Shadowstrike) or ((2587 - (668 + 595)) > (2718 + 302))) then
						return "Cast Shadowstrike";
					end
				end
				return false;
			end
			if (((2 + 3) == v166) or ((8159 - 5167) == (2171 - (23 + 267)))) then
				if (((5050 - (1129 + 815)) > (1913 - (371 + 16))) and v87.Backstab:IsCastable() and not v172 and (v168 >= (1753 - (1326 + 424))) and v12:BuffUp(v87.ShadowBlades) and not v126(v87.Backstab) and v87.DanseMacabre:IsAvailable() and (v97 <= (5 - 2)) and not v169) then
					if (((11046 - 8023) < (3988 - (88 + 30))) and v164) then
						if (((914 - (720 + 51)) > (164 - 90)) and v165) then
							return v87.Backstab;
						else
							return {v87.Backstab,v87.Stealth};
						end
					elseif (((9 + 9) < (3195 - (286 + 797))) and v25(v87.Backstab, v87.Stealth)) then
						return "Cast Backstab (Stealth)";
					end
				end
				if (((4010 - 2913) <= (2696 - 1068)) and v87.Gloomblade:IsAvailable()) then
					if (((5069 - (397 + 42)) == (1447 + 3183)) and not v172 and (v168 >= (803 - (24 + 776))) and v12:BuffUp(v87.ShadowBlades) and not v126(v87.Gloomblade) and v87.DanseMacabre:IsAvailable() and (v97 <= (5 - 1))) then
						if (((4325 - (222 + 563)) > (5911 - 3228)) and v164) then
							if (((3452 + 1342) >= (3465 - (23 + 167))) and v165) then
								return v87.Gloomblade;
							else
								return {v87.Gloomblade,v87.Stealth};
							end
						elseif (((1225 + 259) == (2332 - (40 + 808))) and v26(v87.Gloomblade, v87.Stealth)) then
							return "Cast Gloomblade (Danse)";
						end
					end
				end
				if (((236 + 1196) < (13594 - 10039)) and not v126(v87.Shadowstrike) and v12:BuffUp(v87.ShadowBlades)) then
					if (v164 or ((1018 + 47) > (1893 + 1685))) then
						return v87.Shadowstrike;
					elseif (v25(v87.Shadowstrike) or ((2630 + 2165) < (1978 - (47 + 524)))) then
						return "Cast Shadowstrike (Danse)";
					end
				end
				v166 = 4 + 2;
			end
			if (((5065 - 3212) < (7196 - 2383)) and (v166 == (6 - 3))) then
				v176 = v87.Shadowstrike:IsCastable() or v173 or v174 or v167 or v12:BuffUp(v87.SepsisBuff);
				if (v173 or v174 or ((4547 - (1165 + 561)) < (73 + 2358))) then
					v176 = v176 and v13:IsInRange(77 - 52);
				else
					v176 = v176 and v93;
				end
				if ((v176 and v173 and ((v97 < (2 + 2)) or v110)) or ((3353 - (341 + 138)) < (589 + 1592))) then
					if (v164 or ((5548 - 2859) <= (669 - (89 + 237)))) then
						return v87.Shadowstrike;
					elseif (v25(v87.Shadowstrike) or ((6012 - 4143) == (4229 - 2220))) then
						return "Cast Shadowstrike (Stealth)";
					end
				end
				v166 = 885 - (581 + 300);
			end
		end
	end
	local function v130(v177, v178)
		local v179 = 1220 - (855 + 365);
		local v180;
		local v181;
		while true do
			if (((2 - 1) == v179) or ((1158 + 2388) < (3557 - (1030 + 205)))) then
				v181 = {v177,v180};
				if ((v178 and (v12:EnergyPredicted() < v178)) or ((2368 - (156 + 130)) == (10844 - 6071))) then
					local v244 = 0 - 0;
					while true do
						if (((6643 - 3399) > (278 + 777)) and (v244 == (0 + 0))) then
							v111(v181, v178);
							return false;
						end
					end
				end
				v179 = 71 - (10 + 59);
			end
			if ((v179 == (1 + 1)) or ((16315 - 13002) <= (2941 - (671 + 492)))) then
				v100 = v26(unpack(v181));
				if (v100 or ((1132 + 289) >= (3319 - (369 + 846)))) then
					return "| " .. v181[1 + 1]:Name();
				end
				v179 = 3 + 0;
			end
			if (((3757 - (1036 + 909)) <= (2584 + 665)) and (v179 == (4 - 1))) then
				return false;
			end
			if (((1826 - (11 + 192)) <= (989 + 968)) and ((175 - (135 + 40)) == v179)) then
				v180 = v129(true, v177);
				if (((10689 - 6277) == (2660 + 1752)) and (v177:ID() == v87.Vanish:ID())) then
					local v245 = 0 - 0;
					while true do
						if (((2623 - 873) >= (1018 - (50 + 126))) and ((0 - 0) == v245)) then
							if (((968 + 3404) > (3263 - (1233 + 180))) and v25(v87.Vanish, v61)) then
								return "Cast Vanish";
							end
							return false;
						end
					end
				elseif (((1201 - (522 + 447)) < (2242 - (107 + 1314))) and (v177:ID() == v87.Shadowmeld:ID())) then
					local v250 = 0 + 0;
					while true do
						if (((1578 - 1060) < (384 + 518)) and (v250 == (0 - 0))) then
							if (((11846 - 8852) > (2768 - (716 + 1194))) and v25(v87.Shadowmeld, v38)) then
								return "Cast Shadowmeld";
							end
							return false;
						end
					end
				elseif ((v177:ID() == v87.ShadowDance:ID()) or ((65 + 3690) <= (99 + 816))) then
					local v254 = 503 - (74 + 429);
					while true do
						if (((7612 - 3666) > (1856 + 1887)) and (v254 == (0 - 0))) then
							if (v25(v87.ShadowDance, v62) or ((945 + 390) >= (10191 - 6885))) then
								return "Cast Shadow Dance";
							end
							return false;
						end
					end
				end
				v179 = 2 - 1;
			end
		end
	end
	local function v131()
		local v182 = 433 - (279 + 154);
		while true do
			if (((5622 - (454 + 324)) > (1773 + 480)) and ((18 - (12 + 5)) == v182)) then
				v100 = v85.HandleBottomTrinket(v90, v37, 22 + 18, nil);
				if (((1151 - 699) == (168 + 284)) and v100) then
					return v100;
				end
				break;
			end
			if ((v182 == (1093 - (277 + 816))) or ((19472 - 14915) < (3270 - (1058 + 125)))) then
				v100 = v85.HandleTopTrinket(v90, v37, 8 + 32, nil);
				if (((4849 - (815 + 160)) == (16621 - 12747)) and v100) then
					return v100;
				end
				v182 = 2 - 1;
			end
		end
	end
	local function v132()
		if ((v9.CD and v87.ColdBlood:IsReady() and not v87.SecretTechnique:IsAvailable() and (v107 >= (2 + 3))) or ((5665 - 3727) > (6833 - (41 + 1857)))) then
			if (v25(v87.ColdBlood, v64) or ((6148 - (1222 + 671)) < (8846 - 5423))) then
				return "Cast Cold Blood";
			end
		end
		if (((2089 - 635) <= (3673 - (229 + 953))) and v9.CD and v87.Sepsis:IsAvailable() and v87.Sepsis:IsReady()) then
			if ((v119() and v13:FilteredTimeToDie(">=", 1790 - (1111 + 663)) and (v12:BuffUp(v87.PerforatedVeins) or not v87.PerforatedVeins:IsAvailable())) or ((5736 - (874 + 705)) <= (393 + 2410))) then
				if (((3312 + 1541) >= (6197 - 3215)) and v25(v87.Sepsis)) then
					return "Cast Sepsis";
				end
			end
		end
		if (((117 + 4017) > (4036 - (642 + 37))) and v37 and v87.Flagellation:IsAvailable() and v87.Flagellation:IsReady()) then
			if ((v119() and (v106 >= (2 + 3)) and (v13:TimeToDie() > (2 + 8)) and ((v127() and (v87.ShadowBlades:CooldownRemains() <= (7 - 4))) or v9.BossFilteredFightRemains("<=", 482 - (233 + 221)) or ((v87.ShadowBlades:CooldownRemains() >= (32 - 18)) and v87.InvigoratingShadowdust:IsAvailable() and v87.ShadowDance:IsAvailable())) and (not v87.InvigoratingShadowdust:IsAvailable() or v87.Sepsis:IsAvailable() or not v87.ShadowDance:IsAvailable() or ((v87.InvigoratingShadowdust:TalentRank() == (2 + 0)) and (v97 >= (1543 - (718 + 823)))) or (v87.SymbolsofDeath:CooldownRemains() <= (2 + 1)) or (v12:BuffRemains(v87.SymbolsofDeath) > (808 - (266 + 539))))) or ((9674 - 6257) < (3759 - (636 + 589)))) then
				if (v25(v87.Flagellation) or ((6461 - 3739) <= (338 - 174))) then
					return "Cast Flagellation";
				end
			end
		end
		if ((v37 and v87.SymbolsofDeath:IsReady()) or ((1909 + 499) < (767 + 1342))) then
			if ((v119() and (not v12:BuffUp(v87.TheRotten) or not v12:HasTier(1045 - (657 + 358), 4 - 2)) and (v12:BuffRemains(v87.SymbolsofDeath) <= (6 - 3)) and (not v87.Flagellation:IsAvailable() or (v87.Flagellation:CooldownRemains() > (1197 - (1151 + 36))) or ((v12:BuffRemains(v87.ShadowDance) >= (2 + 0)) and v87.InvigoratingShadowdust:IsAvailable()) or (v87.Flagellation:IsReady() and (v106 >= (2 + 3)) and not v87.InvigoratingShadowdust:IsAvailable()))) or ((98 - 65) == (3287 - (1552 + 280)))) then
				if (v25(v87.SymbolsofDeath) or ((1277 - (64 + 770)) >= (2726 + 1289))) then
					return "Cast Symbols of Death";
				end
			end
		end
		if (((7677 - 4295) > (30 + 136)) and v9.CD and v87.ShadowBlades:IsReady()) then
			if ((v119() and ((v106 <= (1244 - (157 + 1086))) or v12:HasTier(61 - 30, 17 - 13)) and (v12:BuffUp(v87.Flagellation) or v12:BuffUp(v87.FlagellationPersistBuff) or not v87.Flagellation:IsAvailable())) or ((429 - 149) == (4174 - 1115))) then
				if (((2700 - (599 + 220)) > (2574 - 1281)) and v25(v87.ShadowBlades)) then
					return "Cast Shadow Blades";
				end
			end
		end
		if (((4288 - (1813 + 118)) == (1723 + 634)) and v9.CD and v87.EchoingReprimand:IsCastable() and v87.EchoingReprimand:IsAvailable()) then
			if (((1340 - (841 + 376)) == (171 - 48)) and v119() and (v108 >= (1 + 2))) then
				if (v25(v87.EchoingReprimand) or ((2882 - 1826) >= (4251 - (464 + 395)))) then
					return "Cast Echoing Reprimand";
				end
			end
		end
		if ((v9.CD and v87.ShurikenTornado:IsAvailable() and v87.ShurikenTornado:IsReady()) or ((2774 - 1693) < (517 + 558))) then
			if ((v119() and v12:BuffUp(v87.SymbolsofDeath) and (v106 <= (839 - (467 + 370))) and not v12:BuffUp(v87.Premeditation) and (not v87.Flagellation:IsAvailable() or (v87.Flagellation:CooldownRemains() > (41 - 21))) and (v97 >= (3 + 0))) or ((3595 - 2546) >= (692 + 3740))) then
				if (v25(v87.ShurikenTornado) or ((11092 - 6324) <= (1366 - (150 + 370)))) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if ((v9.CD and v87.ShurikenTornado:IsAvailable() and v87.ShurikenTornado:IsReady()) or ((4640 - (74 + 1208)) <= (3492 - 2072))) then
			if ((v119() and not v12:BuffUp(v87.ShadowDance) and not v12:BuffUp(v87.Flagellation) and not v12:BuffUp(v87.FlagellationPersistBuff) and not v12:BuffUp(v87.ShadowBlades) and (v97 <= (9 - 7))) or ((2661 + 1078) <= (3395 - (14 + 376)))) then
				if (v25(v87.ShurikenTornado) or ((2876 - 1217) >= (1381 + 753))) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if ((v9.CD and v87.ShadowDance:IsAvailable() and v113() and v87.ShadowDance:IsReady()) or ((2864 + 396) < (2246 + 109))) then
			if ((not v12:BuffUp(v87.ShadowDance) and HL.BossFilteredFightRemains("<=", (23 - 15) + ((3 + 0) * v28(v87.Subterfuge:IsAvailable())))) or ((747 - (23 + 55)) == (10008 - 5785))) then
				if (v25(v87.ShadowDance) or ((1130 + 562) < (529 + 59))) then
					return "Cast Shadow Dance";
				end
			end
		end
		if ((v9.CD and v87.GoremawsBite:IsAvailable() and v87.GoremawsBite:IsReady()) or ((7437 - 2640) < (1149 + 2502))) then
			if ((v119() and (v108 >= (904 - (652 + 249))) and (not v87.ShadowDance:IsReady() or (v87.ShadowDance:IsAvailable() and v12:BuffUp(v87.ShadowDance) and not v87.InvigoratingShadowdust:IsAvailable()) or ((v97 < (10 - 6)) and not v87.InvigoratingShadowdust:IsAvailable()) or v87.TheRotten:IsAvailable())) or ((6045 - (708 + 1160)) > (13165 - 8315))) then
				if (v25(v87.GoremawsBite) or ((729 - 329) > (1138 - (10 + 17)))) then
					return "Cast Goremaw's Bite";
				end
			end
		end
		if (((686 + 2365) > (2737 - (1400 + 332))) and v87.ThistleTea:IsReady()) then
			if (((7083 - 3390) <= (6290 - (242 + 1666))) and ((((v87.SymbolsofDeath:CooldownRemains() >= (2 + 1)) or v12:BuffUp(v87.SymbolsofDeath)) and not v12:BuffUp(v87.ThistleTea) and (((v12:EnergyDeficitPredicted() >= (37 + 63)) and ((v108 >= (2 + 0)) or (v97 >= (943 - (850 + 90))))) or ((v87.ThistleTea:ChargesFractional() >= ((3.75 - 1) - ((1390.15 - (360 + 1030)) * v87.InvigoratingShadowdust:TalentRank()))) and v87.Vanish:IsReady() and v12:BuffUp(v87.ShadowDance) and v13:DebuffUp(v87.Rupture) and (v97 < (3 + 0))))) or ((v12:BuffRemains(v87.ShadowDance) >= (11 - 7)) and not v12:BuffUp(v87.ThistleTea) and (v97 >= (3 - 0))) or (not v12:BuffUp(v87.ThistleTea) and HL.BossFilteredFightRemains("<=", (1667 - (909 + 752)) * v87.ThistleTea:Charges())))) then
				if (v25(v87.ThistleTea) or ((4505 - (109 + 1114)) > (7506 - 3406))) then
					return "Thistle Tea";
				end
			end
		end
		local v183 = v12:BuffUp(v87.ShadowBlades) or (not v87.ShadowBlades:IsAvailable() and v12:BuffUp(v87.SymbolsofDeath)) or HL.BossFilteredFightRemains("<", 8 + 12);
		if ((v87.BloodFury:IsCastable() and v183) or ((3822 - (6 + 236)) < (1792 + 1052))) then
			if (((72 + 17) < (10589 - 6099)) and v25(v87.BloodFury, v60)) then
				return "Cast Blood Fury";
			end
		end
		if (v87.Berserking:IsCastable() or ((8703 - 3720) < (2941 - (1076 + 57)))) then
			if (((630 + 3199) > (4458 - (579 + 110))) and v9.Cast(v87.Berserking, v60)) then
				return "Cast Berserking";
			end
		end
		if (((118 + 1367) <= (2568 + 336)) and v87.Fireblood:IsCastable()) then
			if (((2266 + 2003) == (4676 - (174 + 233))) and v9.Cast(v87.Fireblood, v60)) then
				return "Cast Fireblood";
			end
		end
		if (((1080 - 693) <= (4882 - 2100)) and v87.AncestralCall:IsCastable()) then
			if (v9.Cast(v87.AncestralCall, v60) or ((845 + 1054) <= (2091 - (663 + 511)))) then
				return "Cast Ancestral Call";
			end
		end
		if ((v52 and v37) or ((3847 + 465) <= (191 + 685))) then
			v100 = v131();
			if (((6880 - 4648) <= (1573 + 1023)) and v100) then
				return v100;
			end
		end
		return false;
	end
	local function v133(v184)
		if (((4932 - 2837) < (8922 - 5236)) and v9.CD and not (v85.IsSoloMode() and v12:IsTanking(v13))) then
			if (v87.Vanish:IsCastable() or ((762 + 833) >= (8707 - 4233))) then
				if ((((v108 > (1 + 0)) or (v12:BuffUp(v87.ShadowBlades) and v87.InvigoratingShadowdust:IsAvailable())) and not v117() and ((v87.Flagellation:CooldownRemains() >= (6 + 54)) or not v87.Flagellation:IsAvailable() or v9.BossFilteredFightRemains("<=", (752 - (478 + 244)) * v87.Vanish:Charges())) and ((v87.SymbolsofDeath:CooldownRemains() > (520 - (440 + 77))) or not v12:HasTier(14 + 16, 7 - 5)) and ((v87.SecretTechnique:CooldownRemains() >= (1566 - (655 + 901))) or not v87.SecretTechnique:IsAvailable() or ((v87.Vanish:Charges() >= (1 + 1)) and v87.InvigoratingShadowdust:IsAvailable() and (v12:BuffUp(v87.TheRotten) or not v87.TheRotten:IsAvailable())))) or ((3537 + 1082) < (1947 + 935))) then
					local v247 = 0 - 0;
					while true do
						if (((1445 - (695 + 750)) == v247) or ((1003 - 709) >= (7455 - 2624))) then
							v100 = v130(v87.Vanish, v184);
							if (((8159 - 6130) <= (3435 - (285 + 66))) and v100) then
								return "Vanish Macro " .. v100;
							end
							break;
						end
					end
				end
			end
			if (((v12:Energy() < (93 - 53)) and v87.Shadowmeld:IsCastable()) or ((3347 - (682 + 628)) == (391 + 2029))) then
				if (((4757 - (176 + 123)) > (1634 + 2270)) and v25(v87.Shadowmeld, v12:EnergyTimeToX(30 + 10))) then
					return "Pool for Shadowmeld";
				end
			end
			if (((705 - (239 + 30)) >= (34 + 89)) and v87.Shadowmeld:IsCastable() and v93 and not v12:IsMoving() and (v12:EnergyPredicted() >= (39 + 1)) and (v12:EnergyDeficitPredicted() >= (17 - 7)) and not v117() and (v108 > (12 - 8))) then
				local v238 = 315 - (306 + 9);
				while true do
					if (((1744 - 1244) < (316 + 1500)) and (v238 == (0 + 0))) then
						v100 = v130(v87.Shadowmeld, v184);
						if (((1721 + 1853) == (10220 - 6646)) and v100) then
							return "Shadowmeld Macro " .. v100;
						end
						break;
					end
				end
			end
		end
		if (((1596 - (1140 + 235)) < (249 + 141)) and v93 and v87.ShadowDance:IsCastable()) then
			if (((v13:DebuffUp(v87.Rupture) or v87.InvigoratingShadowdust:IsAvailable()) and v125() and (not v87.TheFirstDance:IsAvailable() or (v108 >= (4 + 0)) or v12:BuffUp(v87.ShadowBlades)) and ((v118() and v117()) or ((v12:BuffUp(v87.ShadowBlades) or (v12:BuffUp(v87.SymbolsofDeath) and not v87.Sepsis:IsAvailable()) or ((v12:BuffRemains(v87.SymbolsofDeath) >= (2 + 2)) and not v12:HasTier(82 - (33 + 19), 1 + 1)) or (not v12:BuffUp(v87.SymbolsofDeath) and v12:HasTier(89 - 59, 1 + 1))) and (v87.SecretTechnique:CooldownRemains() < ((19 - 9) + ((12 + 0) * v28(not v87.InvigoratingShadowdust:IsAvailable() or v12:HasTier(719 - (586 + 103), 1 + 1)))))))) or ((6813 - 4600) <= (2909 - (1309 + 179)))) then
				v100 = v130(v87.ShadowDance, v184);
				if (((5520 - 2462) < (2116 + 2744)) and v100) then
					return "ShadowDance Macro 1 " .. v100;
				end
			end
		end
		return false;
	end
	local function v134(v185)
		local v186 = not v185 or (v12:EnergyPredicted() >= v185);
		if ((v36 and v87.ShurikenStorm:IsCastable() and (v97 >= ((5 - 3) + v20((v87.Gloomblade:IsAvailable() and (v12:BuffRemains(v87.LingeringShadowBuff) >= (5 + 1))) or v12:BuffUp(v87.PerforatedVeinsBuff))))) or ((2753 - 1457) >= (8859 - 4413))) then
			if ((v186 and v9.Cast(v87.ShurikenStorm)) or ((2002 - (295 + 314)) > (11025 - 6536))) then
				return "Cast Shuriken Storm";
			end
			v111(v87.ShurikenStorm, v185);
		end
		if (v93 or ((6386 - (1300 + 662)) < (84 - 57))) then
			if (v87.Gloomblade:IsCastable() or ((3752 - (1178 + 577)) > (1982 + 1833))) then
				local v239 = 0 - 0;
				while true do
					if (((4870 - (851 + 554)) > (1692 + 221)) and (v239 == (0 - 0))) then
						if (((1591 - 858) < (2121 - (115 + 187))) and v186 and v25(v87.Gloomblade)) then
							return "Cast Gloomblade";
						end
						v111(v87.Gloomblade, v185);
						break;
					end
				end
			elseif (v87.Backstab:IsCastable() or ((3366 + 1029) == (4502 + 253))) then
				if ((v186 and v25(v87.Backstab)) or ((14946 - 11153) < (3530 - (160 + 1001)))) then
					return "Cast Backstab";
				end
				v111(v87.Backstab, v185);
			end
		end
		return false;
	end
	local function v135()
		v84();
		v35 = EpicSettings.Toggles['ooc'];
		v36 = EpicSettings.Toggles['aoe'];
		v37 = EpicSettings.Toggles['cds'];
		ToggleMain = EpicSettings.Toggles['toggle'];
		v101 = nil;
		v103 = nil;
		v102 = 0 + 0;
		v91 = (v87.AcrobaticStrikes:IsAvailable() and (6 + 2)) or (10 - 5);
		v92 = (v87.AcrobaticStrikes:IsAvailable() and (371 - (237 + 121))) or (907 - (525 + 372));
		v93 = v13:IsInMeleeRange(v91);
		v94 = v13:IsInMeleeRange(v92);
		if (v36 or ((7742 - 3658) == (870 - 605))) then
			local v195 = 142 - (96 + 46);
			while true do
				if (((5135 - (643 + 134)) == (1574 + 2784)) and (v195 == (0 - 0))) then
					v95 = v12:GetEnemiesInRange(111 - 81);
					v96 = v12:GetEnemiesInMeleeRange(v92);
					v195 = 1 + 0;
				end
				if ((v195 == (1 - 0)) or ((6414 - 3276) < (1712 - (316 + 403)))) then
					v97 = #v96;
					v98 = v12:GetEnemiesInMeleeRange(v91);
					break;
				end
			end
		else
			v95 = {};
			v96 = {};
			v97 = 1 + 0;
			v98 = {};
		end
		v107 = v12:ComboPoints();
		v106 = v86.EffectiveComboPoints(v107);
		v108 = v12:ComboPointsDeficit();
		v110 = v114();
		v109 = v12:EnergyMax() - v116();
		if (((9155 - 5825) > (840 + 1483)) and (v106 > v107) and (v108 > (4 - 2)) and v12:AffectingCombat()) then
			if (((v107 == (2 + 0)) and not v12:BuffUp(v87.EchoingReprimand3)) or ((v107 == (1 + 2)) and not v12:BuffUp(v87.EchoingReprimand4)) or ((v107 == (13 - 9)) and not v12:BuffUp(v87.EchoingReprimand5)) or ((17317 - 13691) == (8286 - 4297))) then
				local v240 = v86.TimeToSht(1 + 3);
				if ((v240 == (0 - 0)) or ((45 + 871) == (7858 - 5187))) then
					v240 = v86.TimeToSht(22 - (12 + 5));
				end
				if (((1056 - 784) == (579 - 307)) and (v240 < (v33(v12:EnergyTimeToX(74 - 39), v12:GCDRemains()) + (0.5 - 0)))) then
					v106 = v107;
				end
			end
		end
		if (((863 + 3386) <= (6812 - (1656 + 317))) and v12:BuffUp(v87.ShurikenTornado, nil, true) and (v107 < v86.CPMaxSpend())) then
			local v196 = v86.TimeToNextTornado();
			if (((2475 + 302) < (2565 + 635)) and ((v196 <= v12:GCDRemains()) or (v34(v12:GCDRemains() - v196) < (0.25 - 0)))) then
				local v241 = 0 - 0;
				local v242;
				while true do
					if (((449 - (5 + 349)) < (9295 - 7338)) and (v241 == (1272 - (266 + 1005)))) then
						v108 = v33(v108 - v242, 0 + 0);
						if (((2818 - 1992) < (2260 - 543)) and (v106 < v86.CPMaxSpend())) then
							v106 = v107;
						end
						break;
					end
					if (((3122 - (561 + 1135)) >= (1439 - 334)) and (v241 == (0 - 0))) then
						v242 = v97 + v28(v12:BuffUp(v87.ShadowBlades));
						v107 = v32(v107 + v242, v86.CPMaxSpend());
						v241 = 1067 - (507 + 559);
					end
				end
			end
		end
		v104 = ((9 - 5) + (v106 * (12 - 8))) * (388.3 - (212 + 176));
		v105 = v87.Eviscerate:Damage() * v73;
		if (((3659 - (250 + 655)) <= (9214 - 5835)) and v88.Healthstone:IsReady() and (v12:HealthPercentage() < v43) and not (v12:IsChanneling() or v12:IsCasting())) then
			if (v9.Cast(v89.Healthstone) or ((6861 - 2934) == (2210 - 797))) then
				return "Healthstone ";
			end
		end
		if ((v88.RefreshingHealingPotion:IsReady() and (v12:HealthPercentage() < v41) and not (v12:IsChanneling() or v12:IsCasting())) or ((3110 - (1869 + 87)) <= (2733 - 1945))) then
			if (v9.Cast(v89.RefreshingHealingPotion) or ((3544 - (484 + 1417)) > (7242 - 3863))) then
				return "RefreshingHealingPotion ";
			end
		end
		v100 = v86.CrimsonVial();
		if (v100 or ((4696 - 1893) > (5322 - (48 + 725)))) then
			return v100;
		end
		v86.Poisons();
		if (not v12:AffectingCombat() or ((359 - 139) >= (8107 - 5085))) then
			local v197 = 0 + 0;
			while true do
				if (((7541 - 4719) == (790 + 2032)) and (v197 == (0 + 0))) then
					v100 = v86.Poisons();
					if (v100 or ((1914 - (152 + 701)) == (3168 - (430 + 881)))) then
						return v100;
					end
					v197 = 1 + 0;
				end
				if (((3655 - (557 + 338)) > (404 + 960)) and (v197 == (2 - 1))) then
					if (v85.TargetIsValid() or ((17165 - 12263) <= (9551 - 5956))) then
						if ((v14:Exists() and v87.TricksoftheTrade:IsReady()) or ((8301 - 4449) == (1094 - (499 + 302)))) then
							if (v25(v89.TricksoftheTradeFocus) or ((2425 - (39 + 827)) == (12665 - 8077))) then
								return "precombat tricks_of_the_trade";
							end
						end
					end
					break;
				end
			end
		end
		if ((not v12:AffectingCombat() and not v12:IsMounted() and v85.TargetIsValid()) or ((10013 - 5529) == (3129 - 2341))) then
			local v198 = 0 - 0;
			while true do
				if (((392 + 4176) >= (11435 - 7528)) and (v198 == (0 + 0))) then
					v100 = v86.Stealth(v87.Stealth2, nil);
					if (((1971 - 725) < (3574 - (103 + 1))) and v100) then
						return "Stealth (OOC): " .. v100;
					end
					break;
				end
			end
		end
		if (((4622 - (475 + 79)) >= (2101 - 1129)) and not v12:IsChanneling() and ToggleMain) then
			local v199 = 0 - 0;
			while true do
				if (((64 + 429) < (3427 + 466)) and (v199 == (1503 - (1395 + 108)))) then
					if ((not v12:AffectingCombat() and v13:AffectingCombat() and (v87.Vanish:TimeSinceLastCast() > (2 - 1))) or ((2677 - (7 + 1197)) >= (1453 + 1879))) then
						local v251 = 0 + 0;
						while true do
							if ((v251 == (319 - (27 + 292))) or ((11870 - 7819) <= (1475 - 318))) then
								if (((2532 - 1928) < (5681 - 2800)) and v85.TargetIsValid() and (v13:IsSpellInRange(v87.Shadowstrike) or v93)) then
									if (v12:StealthUp(true, true) or ((1714 - 814) == (3516 - (43 + 96)))) then
										v101 = v129(true);
										if (((18188 - 13729) > (1335 - 744)) and v101) then
											if (((2820 + 578) >= (677 + 1718)) and (type(v101) == "table") and (#v101 > (1 - 0))) then
												if (v25(nil, unpack(v101)) or ((837 + 1346) >= (5292 - 2468))) then
													return "Stealthed Macro Cast or Pool (OOC): " .. v101[1 + 0]:Name();
												end
											elseif (((142 + 1794) == (3687 - (1414 + 337))) and v25(v101)) then
												return "Stealthed Cast or Pool (OOC): " .. v101:Name();
											end
										end
									elseif ((v107 >= (1945 - (1642 + 298))) or ((12596 - 7764) < (12407 - 8094))) then
										v100 = v128();
										if (((12131 - 8043) > (1275 + 2599)) and v100) then
											return v100 .. " (OOC)";
										end
									end
								end
								return;
							end
						end
					end
					if (((3371 + 961) == (5304 - (357 + 615))) and v85.TargetIsValid() and (v35 or v12:AffectingCombat())) then
						if (((2808 + 1191) >= (7115 - 4215)) and v83 and v87.Shiv:IsReady() and not v12:IsCasting() and not v12:IsChanneling() and v85.UnitHasEnrageBuff(v13)) then
							if (v25(v87.Shiv, not v93) or ((2164 + 361) > (8708 - 4644))) then
								return "dispel";
							end
						end
						if (((3496 + 875) == (298 + 4073)) and (v9.CombatTime() < (7 + 3)) and (v9.CombatTime() > (1301 - (384 + 917))) and v87.ShadowDance:CooldownUp() and (v87.Vanish:TimeSinceLastCast() > (708 - (128 + 569)))) then
							local v255 = 1543 - (1407 + 136);
							while true do
								if ((v255 == (1890 - (687 + 1200))) or ((1976 - (556 + 1154)) > (17540 - 12554))) then
									if (((2086 - (9 + 86)) >= (1346 - (275 + 146))) and v87.ShadowDance:IsCastable() and v37 and v9.Cast(v89.ShadowDance, true)) then
										return "Opener ShadowDance";
									end
									break;
								end
								if (((74 + 381) < (2117 - (29 + 35))) and (v255 == (4 - 3))) then
									if ((v87.ShadowBlades:IsCastable() and v12:BuffDown(v87.ShadowBlades)) or ((2467 - 1641) == (21414 - 16563))) then
										if (((120 + 63) == (1195 - (53 + 959))) and v9.Cast(v87.ShadowBlades, true)) then
											return "Opener ShadowBlades";
										end
									end
									if (((1567 - (312 + 96)) <= (3102 - 1314)) and v87.ShurikenStorm:IsCastable() and (v97 >= (287 - (147 + 138)))) then
										if (v9.Cast(v87.ShurikenStorm) or ((4406 - (813 + 86)) > (3903 + 415))) then
											return "Opener Shuriken Tornado";
										end
									end
									v255 = 3 - 1;
								end
								if ((v255 == (492 - (18 + 474))) or ((1038 + 2037) <= (9677 - 6712))) then
									if (((2451 - (860 + 226)) <= (2314 - (121 + 182))) and v12:StealthUp(true, true)) then
										if (v9.Cast(v87.Shadowstrike) or ((342 + 2434) > (4815 - (988 + 252)))) then
											return "Opener SS";
										end
									end
									if ((v87.SymbolsofDeath:IsCastable() and v12:BuffDown(v87.SymbolsofDeath)) or ((289 + 2265) == (1505 + 3299))) then
										if (((4547 - (49 + 1921)) == (3467 - (223 + 667))) and v9.Cast(v87.SymbolsofDeath, true)) then
											return "Opener SymbolsofDeath";
										end
									end
									v255 = 53 - (51 + 1);
								end
								if ((v255 == (2 - 0)) or ((12 - 6) >= (3014 - (146 + 979)))) then
									if (((143 + 363) <= (2497 - (311 + 294))) and (v87.Gloomblade:TimeSinceLastCast() > (8 - 5)) and (v97 <= (1 + 0))) then
										if (v9.Cast(v87.Gloomblade) or ((3451 - (496 + 947)) > (3576 - (1233 + 125)))) then
											return "Opener Gloomblade";
										end
									end
									if (((154 + 225) <= (3721 + 426)) and v13:DebuffDown(v87.Rupture) and (v97 <= (1 + 0)) and (v107 > (1645 - (963 + 682)))) then
										if (v9.Cast(v87.Rupture) or ((3768 + 746) <= (2513 - (504 + 1000)))) then
											return "Opener Rupture";
										end
									end
									v255 = 3 + 0;
								end
							end
						end
						v100 = v132();
						if (v100 or ((3184 + 312) == (113 + 1079))) then
							return "CDs: " .. v100;
						end
						if ((v87.SliceandDice:IsCastable() and (v97 < v86.CPMaxSpend()) and (v12:BuffRemains(v87.SliceandDice) < v12:GCD()) and v9.BossFilteredFightRemains(">", 8 - 2) and (v107 >= (4 + 0))) or ((121 + 87) == (3141 - (156 + 26)))) then
							if (((2464 + 1813) >= (2053 - 740)) and v87.SliceandDice:IsReady() and v25(v87.SliceandDice)) then
								return "Cast Slice and Dice (Low Duration)";
							end
							v112(v87.SliceandDice);
						end
						if (((2751 - (149 + 15)) < (4134 - (890 + 70))) and v12:StealthUp(true, true)) then
							v101 = v129(true);
							if (v101 or ((4237 - (39 + 78)) <= (2680 - (14 + 468)))) then
								if (((type(v101) == "table") and (#v101 > (2 - 1))) or ((4460 - 2864) == (443 + 415))) then
									if (((1934 + 1286) == (685 + 2535)) and v27(nil, unpack(v101))) then
										return "Stealthed Macro " .. v101[1 + 0]:Name() .. "|" .. v101[1 + 1]:Name();
									end
								elseif ((v12:BuffUp(v87.ShurikenTornado) and (v107 ~= v12:ComboPoints()) and ((v101 == v87.BlackPowder) or (v101 == v87.Eviscerate) or (v101 == v87.Rupture) or (v101 == v87.SliceandDice))) or ((2683 - 1281) > (3578 + 42))) then
									if (((9044 - 6470) == (65 + 2509)) and v27(nil, v87.ShurikenTornado, v101)) then
										return "Stealthed Tornado Cast  " .. v101:Name();
									end
								elseif (((1849 - (12 + 39)) < (2565 + 192)) and v25(v101)) then
									return "Stealthed Cast " .. v101:Name();
								end
							end
							v25(v87.PoolEnergy);
							return "Stealthed Pooling";
						end
						local v252;
						if (not v87.Vigor:IsAvailable() or v87.Shadowcraft:IsAvailable() or ((1166 - 789) > (9274 - 6670))) then
							v252 = v12:EnergyDeficitPredicted() <= v116();
						else
							v252 = v12:EnergyPredicted() >= v116();
						end
						if (((169 + 399) < (480 + 431)) and (v252 or v87.InvigoratingShadowdust:IsAvailable())) then
							v100 = v133(v109);
							if (((8330 - 5045) < (2817 + 1411)) and v100) then
								return "Stealth CDs: " .. v100;
							end
						end
						if (((18925 - 15009) > (5038 - (1596 + 114))) and (v106 >= v86.CPMaxSpend())) then
							local v256 = 0 - 0;
							while true do
								if (((3213 - (164 + 549)) < (5277 - (1059 + 379))) and (v256 == (0 - 0))) then
									v100 = v128();
									if (((263 + 244) == (86 + 421)) and v100) then
										return "Finish: " .. v100;
									end
									break;
								end
							end
						end
						if (((632 - (145 + 247)) <= (2598 + 567)) and ((v108 <= (1 + 0)) or (HL.BossFilteredFightRemains("<=", 2 - 1) and (v106 >= (1 + 2))))) then
							v100 = v128();
							if (((719 + 115) >= (1306 - 501)) and v100) then
								return "Finish: " .. v100;
							end
						end
						if (((v97 >= (724 - (254 + 466))) and (v106 >= (564 - (544 + 16)))) or ((12114 - 8302) < (2944 - (294 + 334)))) then
							v100 = v128();
							if (v100 or ((2905 - (236 + 17)) <= (661 + 872))) then
								return "Finish: " .. v100;
							end
						end
						v100 = v134(v109);
						if (v100 or ((2801 + 797) < (5498 - 4038))) then
							return "Build: " .. v100;
						end
						if (v9.CD or ((19487 - 15371) < (614 + 578))) then
							local v257 = 0 + 0;
							while true do
								if ((v257 == (795 - (413 + 381))) or ((143 + 3234) <= (1920 - 1017))) then
									if (((10328 - 6352) >= (2409 - (582 + 1388))) and v87.LightsJudgment:IsReady()) then
										if (((6392 - 2640) == (2686 + 1066)) and v25(v87.LightsJudgment, v38)) then
											return "Cast Lights Judgment";
										end
									end
									if (((4410 - (326 + 38)) > (7972 - 5277)) and v87.BagofTricks:IsReady()) then
										if (v25(v87.BagofTricks, v38) or ((5060 - 1515) == (3817 - (47 + 573)))) then
											return "Cast Bag of Tricks";
										end
									end
									break;
								end
								if (((844 + 1550) > (1583 - 1210)) and (v257 == (0 - 0))) then
									if (((5819 - (1269 + 395)) <= (4724 - (76 + 416))) and v87.ArcaneTorrent:IsReady() and v93 and (v12:EnergyDeficitPredicted() >= ((458 - (319 + 124)) + v12:EnergyRegen()))) then
										if (v25(v87.ArcaneTorrent, v38) or ((8185 - 4604) == (4480 - (564 + 443)))) then
											return "Cast Arcane Torrent";
										end
									end
									if (((13828 - 8833) > (3806 - (337 + 121))) and v87.ArcanePulse:IsReady() and v93) then
										if (v25(v87.ArcanePulse, v38) or ((2208 - 1454) > (12405 - 8681))) then
											return "Cast Arcane Pulse";
										end
									end
									v257 = 1912 - (1261 + 650);
								end
							end
						end
						if (((92 + 125) >= (90 - 33)) and v103) then
							v111(v103);
						end
						if ((v101 and v93) or ((3887 - (772 + 1045)) >= (570 + 3467))) then
							if (((2849 - (102 + 42)) == (4549 - (1524 + 320))) and (type(v101) == "table") and (#v101 > (1271 - (1049 + 221)))) then
								if (((217 - (18 + 138)) == (149 - 88)) and v27(v12:EnergyTimeToX(v102), unpack(v101))) then
									return "Macro pool towards " .. v101[1103 - (67 + 1035)]:Name() .. " at " .. v102;
								end
							elseif (v101:IsCastable() or ((1047 - (136 + 212)) >= (5507 - 4211))) then
								local v260 = 0 + 0;
								while true do
									if ((v260 == (0 + 0)) or ((3387 - (240 + 1364)) >= (4698 - (1050 + 32)))) then
										v102 = v33(v102, v101:Cost());
										if (v25(v101, v12:EnergyTimeToX(v102)) or ((13971 - 10058) > (2678 + 1849))) then
											return "Pool towards: " .. v101:Name() .. " at " .. v102;
										end
										break;
									end
								end
							end
						end
					end
					v199 = 1056 - (331 + 724);
				end
				if (((354 + 4022) > (1461 - (269 + 375))) and ((726 - (267 + 458)) == v199)) then
					if (((1512 + 3349) > (1584 - 760)) and v87.ShurikenToss:IsCastable() and v13:IsInRange(848 - (667 + 151)) and not v94 and not v12:StealthUp(true, true) and not v12:BuffUp(v87.Sprint) and (v12:EnergyDeficitPredicted() < (1517 - (1410 + 87))) and ((v108 >= (1898 - (1504 + 393))) or (v12:EnergyTimeToMax() <= (2.2 - 1)))) then
						if (v25(v87.ShurikenToss) or ((3587 - 2204) >= (2927 - (461 + 335)))) then
							return "Cast Shuriken Toss";
						end
					end
					break;
				end
			end
		end
	end
	local function v136()
		v9.Print("Subtlety Rogue rotation has NOT been updated for patch 10.2.0. It is unlikely to work properly at this time.");
	end
	v9.SetAPL(34 + 227, v135, v136);
end;
return v0["Epix_Rogue_Subtlety.lua"]();

