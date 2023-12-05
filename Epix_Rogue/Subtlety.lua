local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1128 - (307 + 821))) or ((3324 - 1721) <= (2488 - (1293 + 519)))) then
			v6 = v0[v4];
			if (((7004 - 3571) <= (10798 - 6662)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if (((18304 - 14059) <= (10909 - 6278)) and (v5 == (1 + 0))) then
			return v6(...);
		end
	end
end
v0["Epix_Rogue_Subtlety.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v12.Focus;
	local v16 = v12.MouseOver;
	local v17 = v10.Spell;
	local v18 = v10.MultiSpell;
	local v19 = v10.Item;
	local v20 = v10.Utils;
	local v21 = v10.Utils.BoolToInt;
	local v22 = v10.AoEON;
	local v23 = v10.CDsON;
	local v24 = v10.Bind;
	local v25 = v10.Macro;
	local v26 = v10.Press;
	local v27 = v10.CastQueue;
	local v28 = v10.CastQueuePooling;
	local v29 = v10.Commons.Everyone.num;
	local v30 = v10.Commons.Everyone.bool;
	local v31 = pairs;
	local v32 = table.insert;
	local v33 = math.min;
	local v34 = math.max;
	local v35 = math.abs;
	local v36 = false;
	local v37 = false;
	local v38 = false;
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
	local function v85()
		local v139 = 0 + 0;
		while true do
			if (((9934 - 5658) >= (905 + 3009)) and (v139 == (3 + 5))) then
				v76 = EpicSettings.Settings['BurnShadowDance'];
				v77 = EpicSettings.Settings['PotionTypeSelectedSubtlety'];
				v78 = EpicSettings.Settings['ShurikenTornadoGCD'];
				v79 = EpicSettings.Settings['SymbolsofDeathOffGCD'];
				v139 = 6 + 3;
			end
			if (((1294 - (709 + 387)) <= (6223 - (673 + 1185))) and (v139 == (2 - 1))) then
				v42 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v43 = EpicSettings.Settings['UseHealthstone'];
				v44 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v45 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v139 = 2 + 0;
			end
			if (((6455 - 1673) > (1149 + 3527)) and (v139 == (11 - 5))) then
				v68 = EpicSettings.Settings['FeintHP'];
				v69 = EpicSettings.Settings['StealthOOC'];
				v70 = EpicSettings.Settings['CrimsonVialGCD'];
				v71 = EpicSettings.Settings['FeintGCD'];
				v139 = 13 - 6;
			end
			if (((6744 - (446 + 1434)) > (3480 - (1040 + 243))) and (v139 == (20 - 13))) then
				v72 = EpicSettings.Settings['KickOffGCD'];
				v73 = EpicSettings.Settings['StealthOffGCD'];
				v74 = EpicSettings.Settings['EviscerateDMGOffset'] or true;
				v75 = EpicSettings.Settings['ShDEcoCharge'];
				v139 = 1855 - (559 + 1288);
			end
			if ((v139 == (1936 - (609 + 1322))) or ((4154 - (13 + 441)) == (9368 - 6861))) then
				v64 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v65 = EpicSettings.Settings['ColdBloodOffGCD'];
				v66 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v67 = EpicSettings.Settings['CrimsonVialHP'];
				v139 = 15 - 9;
			end
			if (((22282 - 17808) >= (11 + 263)) and (v139 == (14 - 10))) then
				v60 = EpicSettings.Settings['RacialsGCD'];
				v61 = EpicSettings.Settings['RacialsOffGCD'];
				v62 = EpicSettings.Settings['VanishOffGCD'];
				v63 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v139 = 2 + 3;
			end
			if ((v139 == (0 + 0)) or ((5620 - 3726) <= (770 + 636))) then
				v39 = EpicSettings.Settings['UseRacials'];
				v53 = EpicSettings.Settings['UseTrinkets'];
				v40 = EpicSettings.Settings['UseHealingPotion'];
				v41 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
				v139 = 1 + 0;
			end
			if (((875 + 697) >= (1101 + 430)) and ((8 + 1) == v139)) then
				v80 = EpicSettings.Settings['ShadowBladesOffGCD'];
				v81 = EpicSettings.Settings['VanishStealthMacro'];
				v82 = EpicSettings.Settings['ShadowmeldStealthMacro'];
				v83 = EpicSettings.Settings['ShadowDanceStealthMacro'];
				break;
			end
			if ((v139 == (3 + 0)) or ((5120 - (153 + 280)) < (13115 - 8573))) then
				v51 = EpicSettings.Settings['RangedMultiDoT'];
				v52 = EpicSettings.Settings['UsePriorityRotation'];
				v58 = EpicSettings.Settings['STMfDAsDPSCD'];
				v59 = EpicSettings.Settings['KidneyShotInterrupt'];
				v139 = 4 + 0;
			end
			if (((1300 + 1991) > (873 + 794)) and (v139 == (2 + 0))) then
				v46 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 + 0);
				v47 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v49 = EpicSettings.Settings['PoisonRefresh'];
				v50 = EpicSettings.Settings['PoisonRefreshCombat'];
				v139 = 2 + 1;
			end
		end
	end
	local v86 = v10.Commons.Everyone;
	v10.Commons.Rogue = {};
	local v88 = v10.Commons.Rogue;
	local v89 = v17.Rogue.Subtlety;
	local v90 = v19.Rogue.Subtlety;
	local v91 = v25.Rogue.Subtlety;
	local v92 = {v90.ManicGrieftorch:ID(),v90.BeaconToTheBeyond:ID(),v90.Mirror:ID()};
	local v93, v94, v95, v96;
	local v97, v98, v99, v100, v101;
	local v102;
	local v103, v104, v105;
	local v106, v107;
	local v108, v109, v110, v111;
	local v112;
	v89.Eviscerate:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v108 * (1049.176 - (572 + 477)) * (1.21 + 0) * ((v89.Nightstalker:IsAvailable() and v13:StealthUp(true, false) and (1.08 + 0)) or (1 + 0)) * ((v89.DeeperStratagem:IsAvailable() and (87.05 - (84 + 2))) or (1 - 0)) * ((v89.DarkShadow:IsAvailable() and v13:BuffUp(v89.ShadowDanceBuff) and (1.3 + 0)) or (843 - (497 + 345))) * ((v13:BuffUp(v89.SymbolsofDeath) and (1.1 + 0)) or (1 + 0)) * ((v13:BuffUp(v89.FinalityEviscerateBuff) and (1334.3 - (605 + 728))) or (1 + 0)) * ((1 - 0) + (v13:MasteryPct() / (5 + 95))) * ((3 - 2) + (v13:VersatilityDmgPct() / (91 + 9))) * ((v14:DebuffUp(v89.FindWeaknessDebuff) and (2.5 - 1)) or (1 + 0));
	end);
	v89.Rupture:RegisterPMultiplier(function()
		return (v13:BuffUp(v89.FinalityRuptureBuff) and (490.3 - (457 + 32))) or (1 + 0);
	end);
	local function v113(v140, v141)
		if (not v103 or ((2275 - (832 + 570)) == (1917 + 117))) then
			v103 = v140;
			v104 = v141 or (0 + 0);
		end
	end
	local function v114(v142)
		if (not v105 or ((9965 - 7149) < (6 + 5))) then
			v105 = v142;
		end
	end
	local function v115()
		if (((4495 - (588 + 208)) < (12683 - 7977)) and (v76 == "On Bosses not in Dungeons") and v13:IsInDungeonArea()) then
			return false;
		elseif (((4446 - (884 + 916)) >= (1833 - 957)) and (v76 ~= "Always") and not v14:IsInBossList()) then
			return false;
		else
			return true;
		end
	end
	local function v116()
		if (((357 + 257) <= (3837 - (232 + 421))) and (v99 < (1891 - (1569 + 320)))) then
			return false;
		elseif (((767 + 2359) == (594 + 2532)) and (v52 == "Always")) then
			return true;
		elseif (((v52 == "On Bosses") and v14:IsInBossList()) or ((7369 - 5182) >= (5559 - (316 + 289)))) then
			return true;
		elseif ((v52 == "Auto") or ((10148 - 6271) == (166 + 3409))) then
			if (((2160 - (666 + 787)) > (1057 - (360 + 65))) and (v13:InstanceDifficulty() == (15 + 1)) and (v14:NPCID() == (139221 - (79 + 175)))) then
				return true;
			elseif ((v14:NPCID() == (263281 - 96312)) or (v14:NPCID() == (130295 + 36676)) or (v14:NPCID() == (511809 - 344839)) or ((1051 - 505) >= (3583 - (503 + 396)))) then
				return true;
			elseif (((1646 - (92 + 89)) <= (8343 - 4042)) and ((v14:NPCID() == (94088 + 89375)) or (v14:NPCID() == (108706 + 74965)))) then
				return true;
			end
		end
		return false;
	end
	local function v117(v143, v144, v145, v146, v147)
		local v148 = 0 - 0;
		local v149;
		local v150;
		local v151;
		while true do
			if (((234 + 1470) > (3249 - 1824)) and ((1 + 0) == v148)) then
				for v233, v234 in v31(v146) do
					if (((v234:GUID() ~= v151) and v86.UnitIsCycleValid(v234, v150, -v234:DebuffRemains(v143)) and v144(v234)) or ((329 + 358) == (12895 - 8661))) then
						v149, v150 = v234, v234:TimeToDie();
					end
				end
				if (v149 or ((416 + 2914) < (2178 - 749))) then
					v10.Press(v149, v143);
				elseif (((2391 - (485 + 759)) >= (775 - 440)) and v51) then
					v149, v150 = nil, v145;
					for v250, v251 in v31(v98) do
						if (((4624 - (442 + 747)) > (3232 - (832 + 303))) and (v251:GUID() ~= v151) and v86.UnitIsCycleValid(v251, v150, -v251:DebuffRemains(v143)) and v144(v251)) then
							v149, v150 = v251, v251:TimeToDie();
						end
					end
					if (v149 or ((4716 - (88 + 858)) >= (1232 + 2809))) then
						v10.Press(v149, v143);
					end
				end
				break;
			end
			if (((0 + 0) == v148) or ((157 + 3634) <= (2400 - (766 + 23)))) then
				v149, v150 = nil, v145;
				v151 = v14:GUID();
				v148 = 4 - 3;
			end
		end
	end
	local function v118()
		return (27 - 7) + (v89.Vigor:TalentRank() * (65 - 40)) + (v29(v89.ThistleTea:IsAvailable()) * (67 - 47)) + (v29(v89.Shadowcraft:IsAvailable()) * (1093 - (1036 + 37)));
	end
	local function v119()
		return v89.ShadowDance:ChargesFractional() >= (0.75 + 0 + v21(v89.ShadowDanceTalent:IsAvailable()));
	end
	local function v120()
		return v110 >= (5 - 2);
	end
	local function v121()
		return v13:BuffUp(v89.SliceandDice) or (v99 >= v88.CPMaxSpend());
	end
	local function v122()
		return v89.Premeditation:IsAvailable() and (v99 < (4 + 1));
	end
	local function v123(v152)
		return (v13:BuffUp(v89.ThistleTea) and (v99 == (1481 - (641 + 839)))) or (v152 and ((v99 == (914 - (910 + 3))) or (v14:DebuffUp(v89.Rupture) and (v99 >= (4 - 2)))));
	end
	local function v124()
		return (not v13:BuffUp(v89.Premeditation) and (v99 == (1685 - (1466 + 218)))) or not v89.TheRotten:IsAvailable() or (v99 > (1 + 0));
	end
	local function v125()
		return v13:BuffDown(v89.PremeditationBuff) or (v99 > (1149 - (556 + 592))) or ((v109 <= (1 + 1)) and v13:BuffUp(v89.TheRottenBuff) and not v13:HasTier(838 - (329 + 479), 856 - (174 + 680)));
	end
	local function v126(v153, v154)
		return v153 and ((v13:BuffStack(v89.DanseMacabreBuff) >= (10 - 7)) or not v89.DanseMacabre:IsAvailable()) and (not v154 or (v99 ~= (3 - 1)));
	end
	local function v127()
		return (not v13:BuffUp(v89.TheRotten) or not v13:HasTier(22 + 8, 741 - (396 + 343))) and (not v89.ColdBlood:IsAvailable() or (v89.ColdBlood:CooldownRemains() < (1 + 3)) or (v89.ColdBlood:CooldownRemains() > (1487 - (29 + 1448))));
	end
	local function v128(v155)
		return v13:BuffUp(v89.ShadowDanceBuff) and (v155:TimeSinceLastCast() < v89.ShadowDance:TimeSinceLastCast());
	end
	local function v126()
		return ((v128(v89.Shadowstrike) or v128(v89.ShurikenStorm)) and (v128(v89.Eviscerate) or v128(v89.BlackPowder) or v128(v89.Rupture))) or not v89.DanseMacabre:IsAvailable();
	end
	local function v129()
		return (not v90.WitherbarksBranch:IsEquipped() and not v90.AshesoftheEmbersoul:IsEquipped()) or (not v90.WitherbarksBranch:IsEquipped() and (v90.WitherbarksBranch:CooldownRemains() <= (1397 - (135 + 1254)))) or (v90.WitherbarksBranch:IsEquipped() and (v90.WitherbarksBranch:CooldownRemains() <= (30 - 22))) or v90.BandolierOfTwistedBlades:IsEquipped() or v89.InvigoratingShadowdust:IsAvailable();
	end
	local function v130(v156, v157)
		local v158 = v13:BuffUp(v89.ShadowDanceBuff);
		local v159 = v13:BuffRemains(v89.ShadowDanceBuff);
		local v160 = v13:BuffRemains(v89.SymbolsofDeath);
		local v161 = v109;
		local v162 = v89.ColdBlood:CooldownRemains();
		local v163 = v89.SymbolsofDeath:CooldownRemains();
		local v164 = v13:BuffUp(v89.PremeditationBuff) or (v157 and v89.Premeditation:IsAvailable());
		if ((v157 and (v157:ID() == v89.ShadowDance:ID())) or ((21375 - 16797) <= (1339 + 669))) then
			v158 = true;
			v159 = (1535 - (389 + 1138)) + v89.ImprovedShadowDance:TalentRank();
			if (((1699 - (102 + 472)) <= (1960 + 116)) and v89.TheFirstDance:IsAvailable()) then
				v161 = v33(v13:ComboPointsMax(), v109 + 3 + 1);
			end
			if (v13:HasTier(28 + 2, 1547 - (320 + 1225)) or ((1322 - 579) >= (2692 + 1707))) then
				v160 = v34(v160, 1470 - (157 + 1307));
			end
		end
		if (((3014 - (821 + 1038)) < (4174 - 2501)) and v157 and (v157:ID() == v89.Vanish:ID())) then
			v162 = v33(0 + 0, v89.ColdBlood:CooldownRemains() - ((26 - 11) * v89.InvigoratingShadowdust:TalentRank()));
			v163 = v33(0 + 0, v89.SymbolsofDeath:CooldownRemains() - ((37 - 22) * v89.InvigoratingShadowdust:TalentRank()));
		end
		if ((v89.Rupture:IsCastable() and v89.Rupture:IsReady()) or ((3350 - (834 + 192)) <= (37 + 541))) then
			if (((967 + 2800) == (81 + 3686)) and v14:DebuffDown(v89.Rupture) and (v14:TimeToDie() > (8 - 2))) then
				if (((4393 - (300 + 4)) == (1093 + 2996)) and v156) then
					return v89.Rupture;
				else
					local v242 = 0 - 0;
					while true do
						if (((4820 - (112 + 250)) >= (668 + 1006)) and (v242 == (0 - 0))) then
							if (((557 + 415) <= (734 + 684)) and v89.Rupture:IsReady() and v10.Press(v89.Rupture)) then
								return "Cast Rupture";
							end
							v114(v89.Rupture);
							break;
						end
					end
				end
			end
		end
		if ((not v13:StealthUp(true, true) and not v122() and (v99 < (5 + 1)) and not v158 and v10.BossFilteredFightRemains(">", v13:BuffRemains(v89.SliceandDice)) and (v13:BuffRemains(v89.SliceandDice) < ((1 + 0 + v13:ComboPoints()) * (1.8 + 0)))) or ((6352 - (1001 + 413)) < (10619 - 5857))) then
			if (v156 or ((3386 - (244 + 638)) > (4957 - (627 + 66)))) then
				return v89.SliceandDice;
			else
				if (((6414 - 4261) == (2755 - (512 + 90))) and v89.SliceandDice:IsReady() and v10.Press(v89.SliceandDice)) then
					return "Cast Slice and Dice Premed";
				end
				v114(v89.SliceandDice);
			end
		end
		if (((not v123(v158) or v112) and (v14:TimeToDie() > (1912 - (1665 + 241))) and v14:DebuffRefreshable(v89.Rupture, v106)) or ((1224 - (373 + 344)) >= (1169 + 1422))) then
			if (((1186 + 3295) == (11819 - 7338)) and v156) then
				return v89.Rupture;
			else
				local v235 = 0 - 0;
				while true do
					if (((1099 - (35 + 1064)) == v235) or ((1694 + 634) < (1482 - 789))) then
						if (((18 + 4310) == (5564 - (298 + 938))) and v89.Rupture:IsReady() and v10.Press(v89.Rupture)) then
							return "Cast Rupture";
						end
						v114(v89.Rupture);
						break;
					end
				end
			end
		end
		if (((2847 - (233 + 1026)) >= (2998 - (636 + 1030))) and v13:BuffUp(v89.FinalityRuptureBuff) and v158 and (v99 <= (3 + 1)) and not v128(v89.Rupture)) then
			if (v156 or ((4078 + 96) > (1262 + 2986))) then
				return v89.Rupture;
			else
				local v236 = 0 + 0;
				while true do
					if ((v236 == (221 - (55 + 166))) or ((889 + 3697) <= (9 + 73))) then
						if (((14752 - 10889) == (4160 - (36 + 261))) and v89.Rupture:IsReady() and v10.Press(v89.Rupture)) then
							return "Cast Rupture Finality";
						end
						v114(v89.Rupture);
						break;
					end
				end
			end
		end
		if ((v89.ColdBlood:IsReady() and v126(v158, v164) and v89.SecretTechnique:IsReady()) or ((492 - 210) <= (1410 - (34 + 1334)))) then
			if (((1772 + 2837) >= (596 + 170)) and v65) then
				v10.Press(v89.ColdBlood);
			else
				if (v156 or ((2435 - (1035 + 248)) == (2509 - (20 + 1)))) then
					return v89.ColdBlood;
				end
				if (((1783 + 1639) > (3669 - (134 + 185))) and v10.Press(v89.ColdBlood)) then
					return "Cast Cold Blood (SecTec)";
				end
			end
		end
		if (((2010 - (549 + 584)) > (1061 - (314 + 371))) and v89.SecretTechnique:IsReady()) then
			if ((v126(v158, v164) and (not v89.ColdBlood:IsAvailable() or (v65 and v89.ColdBlood:IsReady()) or v13:BuffUp(v89.ColdBlood) or (v162 > (v159 - (6 - 4))) or not v89.ImprovedShadowDance:IsAvailable())) or ((4086 - (478 + 490)) <= (981 + 870))) then
				if (v156 or ((1337 - (786 + 386)) >= (11310 - 7818))) then
					return v89.SecretTechnique;
				end
				if (((5328 - (1055 + 324)) < (6196 - (1093 + 247))) and v10.Press(v89.SecretTechnique)) then
					return "Cast Secret Technique";
				end
			end
		end
		if ((not v123(v158) and v89.Rupture:IsCastable()) or ((3800 + 476) < (318 + 2698))) then
			local v192 = 0 - 0;
			while true do
				if (((15916 - 11226) > (11737 - 7612)) and (v192 == (0 - 0))) then
					if ((not v156 and v37 and not v112 and (v99 >= (1 + 1))) or ((192 - 142) >= (3088 - 2192))) then
						local v243 = 0 + 0;
						local v244;
						while true do
							if ((v243 == (0 - 0)) or ((2402 - (364 + 324)) >= (8108 - 5150))) then
								v244 = nil;
								function v244(v253)
									return v86.CanDoTUnit(v253, v107) and v253:DebuffRefreshable(v89.Rupture, v106);
								end
								v243 = 2 - 1;
							end
							if ((v243 == (1 + 0)) or ((6238 - 4747) < (1030 - 386))) then
								v117(v89.Rupture, v244, (5 - 3) * v161, v100);
								break;
							end
						end
					end
					if (((1972 - (1249 + 19)) < (891 + 96)) and v95 and (v14:DebuffRemains(v89.Rupture) < (v89.SymbolsofDeath:CooldownRemains() + (38 - 28))) and (v109 > (1086 - (686 + 400))) and (v89.SymbolsofDeath:CooldownRemains() <= (4 + 1)) and v88.CanDoTUnit(v14, v107) and v14:FilteredTimeToDie(">", (234 - (73 + 156)) + v89.SymbolsofDeath:CooldownRemains(), -v14:DebuffRemains(v89.Rupture))) then
						if (((18 + 3700) > (2717 - (721 + 90))) and v156) then
							return v89.Rupture;
						else
							if ((v89.Rupture:IsReady() and v10.Cast(v89.Rupture)) or ((11 + 947) > (11802 - 8167))) then
								return "Cast Rupture 2";
							end
							v114(v89.Rupture);
						end
					end
					break;
				end
			end
		end
		if (((3971 - (224 + 246)) <= (7276 - 2784)) and v89.BlackPowder:IsCastable() and not v112 and (v99 >= (5 - 2))) then
			if (v156 or ((625 + 2817) < (61 + 2487))) then
				return v89.BlackPowder;
			else
				local v237 = 0 + 0;
				while true do
					if (((5715 - 2840) >= (4871 - 3407)) and (v237 == (513 - (203 + 310)))) then
						if ((v89.BlackPowder:IsReady() and v26(v89.BlackPowder)) or ((6790 - (1238 + 755)) >= (342 + 4551))) then
							return "Cast Black Powder";
						end
						v114(v89.BlackPowder);
						break;
					end
				end
			end
		end
		if ((v89.Eviscerate:IsCastable() and v95 and (v109 > (1535 - (709 + 825)))) or ((1015 - 464) > (3012 - 944))) then
			if (((2978 - (196 + 668)) > (3726 - 2782)) and v156) then
				return v89.Eviscerate;
			else
				if ((v89.Eviscerate:IsReady() and v26(v89.Eviscerate)) or ((4685 - 2423) >= (3929 - (171 + 662)))) then
					return "Cast Eviscerate";
				end
				v114(v89.Eviscerate);
			end
		end
		return false;
	end
	local function v131(v165, v166)
		local v167 = v13:BuffUp(v89.ShadowDanceBuff);
		local v168 = v13:BuffRemains(v89.ShadowDanceBuff);
		local v169 = v13:BuffUp(v89.TheRottenBuff);
		local v170, v171 = v109, v110;
		local v172 = v13:BuffUp(v89.PremeditationBuff) or (v166 and v89.Premeditation:IsAvailable());
		local v173 = v13:BuffUp(v88.StealthSpell()) or (v166 and (v166:ID() == v88.StealthSpell():ID()));
		local v174 = v13:BuffUp(v88.VanishBuffSpell()) or (v166 and (v166:ID() == v89.Vanish:ID()));
		if ((v166 and (v166:ID() == v89.ShadowDance:ID())) or ((2348 - (4 + 89)) >= (12397 - 8860))) then
			v167 = true;
			v168 = 3 + 5 + v89.ImprovedShadowDance:TalentRank();
			if ((v89.TheRotten:IsAvailable() and v13:HasTier(131 - 101, 1 + 1)) or ((5323 - (35 + 1451)) < (2759 - (28 + 1425)))) then
				v169 = true;
			end
			if (((4943 - (941 + 1052)) == (2829 + 121)) and v89.TheFirstDance:IsAvailable()) then
				v170 = v33(v13:ComboPointsMax(), v109 + (1518 - (822 + 692)));
				v171 = v13:ComboPointsMax() - v170;
			end
		end
		local v175 = v88.EffectiveComboPoints(v170);
		local v176 = v89.Shadowstrike:IsCastable() or v173 or v174 or v167 or v13:BuffUp(v89.SepsisBuff);
		if (v173 or v174 or ((6742 - 2019) < (1554 + 1744))) then
			v176 = v176 and v14:IsInRange(322 - (45 + 252));
		else
			v176 = v176 and v95;
		end
		if (((1124 + 12) >= (53 + 101)) and v176 and v173 and ((v99 < (9 - 5)) or v112)) then
			if (v165 or ((704 - (114 + 319)) > (6816 - 2068))) then
				return v89.Shadowstrike;
			elseif (((6073 - 1333) >= (2010 + 1142)) and v26(v89.Shadowstrike)) then
				return "Cast Shadowstrike (Stealth)";
			end
		end
		if ((v175 >= v88.CPMaxSpend()) or ((3840 - 1262) >= (7102 - 3712))) then
			return v130(v165, v166);
		end
		if (((2004 - (556 + 1407)) <= (2867 - (741 + 465))) and v13:BuffUp(v89.ShurikenTornado) and (v171 <= (467 - (170 + 295)))) then
			return v130(v165, v166);
		end
		if (((317 + 284) < (3270 + 290)) and (v110 <= ((2 - 1) + v29(v89.DeeperStratagem:IsAvailable() or v89.SecretStratagem:IsAvailable())))) then
			return v130(v165, v166);
		end
		if (((195 + 40) < (441 + 246)) and v89.Backstab:IsCastable() and not v172 and (v168 >= (2 + 1)) and v13:BuffUp(v89.ShadowBlades) and not v128(v89.Backstab) and v89.DanseMacabre:IsAvailable() and (v99 <= (1233 - (957 + 273))) and not v169) then
			if (((1217 + 3332) > (462 + 691)) and v165) then
				if (v166 or ((17809 - 13135) < (12311 - 7639))) then
					return v89.Backstab;
				else
					return {v89.Backstab,v89.Stealth};
				end
			elseif (((5448 - (389 + 1391)) < (2862 + 1699)) and v26(v89.Backstab, v89.Stealth)) then
				return "Cast Backstab (Stealth)";
			end
		end
		if (v89.Gloomblade:IsAvailable() or ((48 + 407) == (8207 - 4602))) then
			if ((not v172 and (v168 >= (954 - (783 + 168))) and v13:BuffUp(v89.ShadowBlades) and not v128(v89.Gloomblade) and v89.DanseMacabre:IsAvailable() and (v99 <= (13 - 9))) or ((2620 + 43) == (3623 - (309 + 2)))) then
				if (((13133 - 8856) <= (5687 - (1090 + 122))) and v165) then
					if (v166 or ((283 + 587) == (3993 - 2804))) then
						return v89.Gloomblade;
					else
						return {v89.Gloomblade,v89.Stealth};
					end
				elseif (((279 + 1274) <= (7756 - 4623)) and v27(v89.Gloomblade, v89.Stealth)) then
					return "Cast Gloomblade (Danse)";
				end
			end
		end
		if ((not v128(v89.Shadowstrike) and v13:BuffUp(v89.ShadowBlades)) or ((10223 - 7986) >= (4285 - (431 + 343)))) then
			if (v165 or ((2673 - 1349) > (8736 - 5716))) then
				return v89.Shadowstrike;
			elseif (v26(v89.Shadowstrike) or ((2364 + 628) == (241 + 1640))) then
				return "Cast Shadowstrike (Danse)";
			end
		end
		if (((4801 - (556 + 1139)) > (1541 - (6 + 9))) and not v172 and (v99 >= (1 + 3))) then
			if (((1549 + 1474) < (4039 - (28 + 141))) and v165) then
				return v89.ShurikenStorm;
			elseif (((56 + 87) > (90 - 16)) and v26(v89.ShurikenStorm)) then
				return "Cast Shuriken Storm";
			end
		end
		if (((13 + 5) < (3429 - (486 + 831))) and v176) then
			if (((2854 - 1757) <= (5731 - 4103)) and v165) then
				return v89.Shadowstrike;
			elseif (((875 + 3755) == (14639 - 10009)) and v26(v89.Shadowstrike)) then
				return "Cast Shadowstrike";
			end
		end
		return false;
	end
	local function v132(v177, v178)
		local v179 = v131(true, v177);
		if (((4803 - (668 + 595)) > (2415 + 268)) and (v177:ID() == v89.Vanish:ID())) then
			if (((967 + 3827) >= (8931 - 5656)) and v26(v89.Vanish, v62)) then
				return "Cast Vanish";
			end
			return false;
		elseif (((1774 - (23 + 267)) == (3428 - (1129 + 815))) and (v177:ID() == v89.Shadowmeld:ID())) then
			local v238 = 387 - (371 + 16);
			while true do
				if (((3182 - (1326 + 424)) < (6732 - 3177)) and (v238 == (0 - 0))) then
					if (v26(v89.Shadowmeld, v39) or ((1183 - (88 + 30)) > (4349 - (720 + 51)))) then
						return "Cast Shadowmeld";
					end
					return false;
				end
			end
		elseif ((v177:ID() == v89.ShadowDance:ID()) or ((10666 - 5871) < (3183 - (421 + 1355)))) then
			if (((3056 - 1203) < (2365 + 2448)) and v26(v89.ShadowDance, v63)) then
				return "Cast Shadow Dance";
			end
			return false;
		end
		local v180 = {v177,v179};
		if ((v178 and (v13:EnergyPredicted() < v178)) or ((4672 - 1851) < (2870 - (397 + 42)))) then
			local v193 = 0 + 0;
			while true do
				if ((v193 == (800 - (24 + 776))) or ((4427 - 1553) < (2966 - (222 + 563)))) then
					v113(v180, v178);
					return false;
				end
			end
		end
		v102 = v27(unpack(v180));
		if (v102 or ((5924 - 3235) <= (247 + 96))) then
			return "| " .. v180[192 - (23 + 167)]:Name();
		end
		return false;
	end
	local function v133()
		local v181 = 1798 - (690 + 1108);
		while true do
			if ((v181 == (1 + 0)) or ((1542 + 327) == (2857 - (40 + 808)))) then
				v102 = v86.HandleBottomTrinket(v92, v38, 7 + 33, nil);
				if (v102 or ((13559 - 10013) < (2220 + 102))) then
					return v102;
				end
				break;
			end
			if ((v181 == (0 + 0)) or ((1142 + 940) == (5344 - (47 + 524)))) then
				v102 = v86.HandleTopTrinket(v92, v38, 26 + 14, nil);
				if (((8867 - 5623) > (1577 - 522)) and v102) then
					return v102;
				end
				v181 = 2 - 1;
			end
		end
	end
	local function v134()
		if ((v10.CD and v89.ColdBlood:IsReady() and not v89.SecretTechnique:IsAvailable() and (v109 >= (1731 - (1165 + 561)))) or ((99 + 3214) <= (5506 - 3728))) then
			if (v26(v89.ColdBlood, v65) or ((543 + 878) >= (2583 - (341 + 138)))) then
				return "Cast Cold Blood";
			end
		end
		if (((490 + 1322) <= (6704 - 3455)) and v10.CD and v89.Sepsis:IsAvailable() and v89.Sepsis:IsReady()) then
			if (((1949 - (89 + 237)) <= (6295 - 4338)) and v121() and v14:FilteredTimeToDie(">=", 33 - 17) and (v13:BuffUp(v89.PerforatedVeins) or not v89.PerforatedVeins:IsAvailable())) then
				if (((5293 - (581 + 300)) == (5632 - (855 + 365))) and v26(v89.Sepsis)) then
					return "Cast Sepsis";
				end
			end
		end
		if (((4156 - 2406) >= (275 + 567)) and v38 and v89.Flagellation:IsAvailable() and v89.Flagellation:IsReady()) then
			if (((5607 - (1030 + 205)) > (1737 + 113)) and v121() and (v108 >= (5 + 0)) and (v14:TimeToDie() > (296 - (156 + 130))) and ((v129() and (v89.ShadowBlades:CooldownRemains() <= (6 - 3))) or v10.BossFilteredFightRemains("<=", 47 - 19) or ((v89.ShadowBlades:CooldownRemains() >= (28 - 14)) and v89.InvigoratingShadowdust:IsAvailable() and v89.ShadowDance:IsAvailable())) and (not v89.InvigoratingShadowdust:IsAvailable() or v89.Sepsis:IsAvailable() or not v89.ShadowDance:IsAvailable() or ((v89.InvigoratingShadowdust:TalentRank() == (1 + 1)) and (v99 >= (2 + 0))) or (v89.SymbolsofDeath:CooldownRemains() <= (72 - (10 + 59))) or (v13:BuffRemains(v89.SymbolsofDeath) > (1 + 2)))) then
				if (((1142 - 910) < (1984 - (671 + 492))) and v26(v89.Flagellation)) then
					return "Cast Flagellation";
				end
			end
		end
		if (((413 + 105) < (2117 - (369 + 846))) and v38 and v89.SymbolsofDeath:IsReady()) then
			if (((793 + 2201) > (733 + 125)) and v121() and (not v13:BuffUp(v89.TheRotten) or not v13:HasTier(1975 - (1036 + 909), 2 + 0)) and (v13:BuffRemains(v89.SymbolsofDeath) <= (4 - 1)) and (not v89.Flagellation:IsAvailable() or (v89.Flagellation:CooldownRemains() > (213 - (11 + 192))) or ((v13:BuffRemains(v89.ShadowDance) >= (2 + 0)) and v89.InvigoratingShadowdust:IsAvailable()) or (v89.Flagellation:IsReady() and (v108 >= (180 - (135 + 40))) and not v89.InvigoratingShadowdust:IsAvailable()))) then
				if (v26(v89.SymbolsofDeath) or ((9097 - 5342) <= (552 + 363))) then
					return "Cast Symbols of Death";
				end
			end
		end
		if (((8692 - 4746) > (5610 - 1867)) and v10.CD and v89.ShadowBlades:IsReady()) then
			if ((v121() and ((v108 <= (177 - (50 + 126))) or v13:HasTier(86 - 55, 1 + 3)) and (v13:BuffUp(v89.Flagellation) or v13:BuffUp(v89.FlagellationPersistBuff) or not v89.Flagellation:IsAvailable())) or ((2748 - (1233 + 180)) >= (4275 - (522 + 447)))) then
				if (((6265 - (107 + 1314)) > (1046 + 1207)) and v26(v89.ShadowBlades)) then
					return "Cast Shadow Blades";
				end
			end
		end
		if (((1377 - 925) == (192 + 260)) and v10.CD and v89.EchoingReprimand:IsCastable() and v89.EchoingReprimand:IsAvailable()) then
			if ((v121() and (v110 >= (5 - 2))) or ((18030 - 13473) < (3997 - (716 + 1194)))) then
				if (((67 + 3807) == (415 + 3459)) and v26(v89.EchoingReprimand)) then
					return "Cast Echoing Reprimand";
				end
			end
		end
		if ((v10.CD and v89.ShurikenTornado:IsAvailable() and v89.ShurikenTornado:IsReady()) or ((2441 - (74 + 429)) > (9520 - 4585))) then
			if ((v121() and v13:BuffUp(v89.SymbolsofDeath) and (v108 <= (1 + 1)) and not v13:BuffUp(v89.Premeditation) and (not v89.Flagellation:IsAvailable() or (v89.Flagellation:CooldownRemains() > (45 - 25))) and (v99 >= (3 + 0))) or ((13117 - 8862) < (8463 - 5040))) then
				if (((1887 - (279 + 154)) <= (3269 - (454 + 324))) and v26(v89.ShurikenTornado)) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if ((v10.CD and v89.ShurikenTornado:IsAvailable() and v89.ShurikenTornado:IsReady()) or ((3271 + 886) <= (2820 - (12 + 5)))) then
			if (((2617 + 2236) >= (7597 - 4615)) and v121() and not v13:BuffUp(v89.ShadowDance) and not v13:BuffUp(v89.Flagellation) and not v13:BuffUp(v89.FlagellationPersistBuff) and not v13:BuffUp(v89.ShadowBlades) and (v99 <= (1 + 1))) then
				if (((5227 - (277 + 816)) > (14344 - 10987)) and v26(v89.ShurikenTornado)) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if ((v10.CD and v89.ShadowDance:IsAvailable() and v115() and v89.ShadowDance:IsReady()) or ((4600 - (1058 + 125)) < (476 + 2058))) then
			if ((not v13:BuffUp(v89.ShadowDance) and HL.BossFilteredFightRemains("<=", (983 - (815 + 160)) + ((12 - 9) * v29(v89.Subterfuge:IsAvailable())))) or ((6461 - 3739) <= (40 + 124))) then
				if (v26(v89.ShadowDance) or ((7038 - 4630) < (4007 - (41 + 1857)))) then
					return "Cast Shadow Dance";
				end
			end
		end
		if ((v10.CD and v89.GoremawsBite:IsAvailable() and v89.GoremawsBite:IsReady()) or ((1926 - (1222 + 671)) == (3760 - 2305))) then
			if ((v121() and (v110 >= (3 - 0)) and (not v89.ShadowDance:IsReady() or (v89.ShadowDance:IsAvailable() and v13:BuffUp(v89.ShadowDance) and not v89.InvigoratingShadowdust:IsAvailable()) or ((v99 < (1186 - (229 + 953))) and not v89.InvigoratingShadowdust:IsAvailable()) or v89.TheRotten:IsAvailable())) or ((2217 - (1111 + 663)) >= (5594 - (874 + 705)))) then
				if (((474 + 2908) > (114 + 52)) and v26(v89.GoremawsBite)) then
					return "Cast Goremaw's Bite";
				end
			end
		end
		if (v89.ThistleTea:IsReady() or ((582 - 302) == (87 + 2972))) then
			if (((2560 - (642 + 37)) > (295 + 998)) and ((((v89.SymbolsofDeath:CooldownRemains() >= (1 + 2)) or v13:BuffUp(v89.SymbolsofDeath)) and not v13:BuffUp(v89.ThistleTea) and (((v13:EnergyDeficitPredicted() >= (251 - 151)) and ((v110 >= (456 - (233 + 221))) or (v99 >= (6 - 3)))) or ((v89.ThistleTea:ChargesFractional() >= ((2.75 + 0) - ((1541.15 - (718 + 823)) * v89.InvigoratingShadowdust:TalentRank()))) and v89.Vanish:IsReady() and v13:BuffUp(v89.ShadowDance) and v14:DebuffUp(v89.Rupture) and (v99 < (2 + 1))))) or ((v13:BuffRemains(v89.ShadowDance) >= (809 - (266 + 539))) and not v13:BuffUp(v89.ThistleTea) and (v99 >= (8 - 5))) or (not v13:BuffUp(v89.ThistleTea) and HL.BossFilteredFightRemains("<=", (1231 - (636 + 589)) * v89.ThistleTea:Charges())))) then
				if (((5594 - 3237) == (4861 - 2504)) and v26(v89.ThistleTea)) then
					return "Thistle Tea";
				end
			end
		end
		local v182 = v13:BuffUp(v89.ShadowBlades) or (not v89.ShadowBlades:IsAvailable() and v13:BuffUp(v89.SymbolsofDeath)) or HL.BossFilteredFightRemains("<", 16 + 4);
		if (((45 + 78) == (1138 - (657 + 358))) and v89.BloodFury:IsCastable() and v182) then
			if (v26(v89.BloodFury, v61) or ((2795 - 1739) >= (7727 - 4335))) then
				return "Cast Blood Fury";
			end
		end
		if (v89.Berserking:IsCastable() or ((2268 - (1151 + 36)) < (1039 + 36))) then
			if (v10.Cast(v89.Berserking, v61) or ((276 + 773) >= (13235 - 8803))) then
				return "Cast Berserking";
			end
		end
		if (v89.Fireblood:IsCastable() or ((6600 - (1552 + 280)) <= (1680 - (64 + 770)))) then
			if (v10.Cast(v89.Fireblood, v61) or ((2280 + 1078) <= (3223 - 1803))) then
				return "Cast Fireblood";
			end
		end
		if (v89.AncestralCall:IsCastable() or ((664 + 3075) <= (4248 - (157 + 1086)))) then
			if (v10.Cast(v89.AncestralCall, v61) or ((3320 - 1661) >= (9346 - 7212))) then
				return "Cast Ancestral Call";
			end
		end
		if ((v53 and v38) or ((5000 - 1740) < (3213 - 858))) then
			v102 = v133();
			if (v102 or ((1488 - (599 + 220)) == (8409 - 4186))) then
				return v102;
			end
		end
		return false;
	end
	local function v135(v183)
		local v184 = 1931 - (1813 + 118);
		while true do
			if ((v184 == (0 + 0)) or ((2909 - (841 + 376)) < (823 - 235))) then
				if ((v10.CD and not (v86.IsSoloMode() and v13:IsTanking(v14))) or ((1115 + 3682) < (9965 - 6314))) then
					local v241 = 859 - (464 + 395);
					while true do
						if ((v241 == (0 - 0)) or ((2006 + 2171) > (5687 - (467 + 370)))) then
							if (v89.Vanish:IsCastable() or ((826 - 426) > (816 + 295))) then
								if (((10458 - 7407) > (157 + 848)) and ((v110 > (2 - 1)) or (v13:BuffUp(v89.ShadowBlades) and v89.InvigoratingShadowdust:IsAvailable())) and not v119() and ((v89.Flagellation:CooldownRemains() >= (580 - (150 + 370))) or not v89.Flagellation:IsAvailable() or v10.BossFilteredFightRemains("<=", (1312 - (74 + 1208)) * v89.Vanish:Charges())) and ((v89.SymbolsofDeath:CooldownRemains() > (7 - 4)) or not v13:HasTier(142 - 112, 2 + 0)) and ((v89.SecretTechnique:CooldownRemains() >= (400 - (14 + 376))) or not v89.SecretTechnique:IsAvailable() or ((v89.Vanish:Charges() >= (3 - 1)) and v89.InvigoratingShadowdust:IsAvailable() and (v13:BuffUp(v89.TheRotten) or not v89.TheRotten:IsAvailable())))) then
									v102 = v132(v89.Vanish, v183);
									if (((2390 + 1303) <= (3850 + 532)) and v102) then
										return "Vanish Macro " .. v102;
									end
								end
							end
							if (((v13:Energy() < (39 + 1)) and v89.Shadowmeld:IsCastable()) or ((9616 - 6334) > (3085 + 1015))) then
								if (v26(v89.Shadowmeld, v13:EnergyTimeToX(118 - (23 + 55))) or ((8484 - 4904) < (1898 + 946))) then
									return "Pool for Shadowmeld";
								end
							end
							v241 = 1 + 0;
						end
						if (((137 - 48) < (1413 + 3077)) and (v241 == (902 - (652 + 249)))) then
							if ((v89.Shadowmeld:IsCastable() and v95 and not v13:IsMoving() and (v13:EnergyPredicted() >= (107 - 67)) and (v13:EnergyDeficitPredicted() >= (1878 - (708 + 1160))) and not v119() and (v110 > (10 - 6))) or ((9084 - 4101) < (1835 - (10 + 17)))) then
								local v252 = 0 + 0;
								while true do
									if (((5561 - (1400 + 332)) > (7228 - 3459)) and (v252 == (1908 - (242 + 1666)))) then
										v102 = v132(v89.Shadowmeld, v183);
										if (((636 + 849) <= (1065 + 1839)) and v102) then
											return "Shadowmeld Macro " .. v102;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (((3639 + 630) == (5209 - (850 + 90))) and v95 and v89.ShadowDance:IsCastable()) then
					if (((677 - 290) <= (4172 - (360 + 1030))) and (v14:DebuffUp(v89.Rupture) or v89.InvigoratingShadowdust:IsAvailable()) and v127() and (not v89.TheFirstDance:IsAvailable() or (v110 >= (4 + 0)) or v13:BuffUp(v89.ShadowBlades)) and ((v120() and v119()) or ((v13:BuffUp(v89.ShadowBlades) or (v13:BuffUp(v89.SymbolsofDeath) and not v89.Sepsis:IsAvailable()) or ((v13:BuffRemains(v89.SymbolsofDeath) >= (11 - 7)) and not v13:HasTier(41 - 11, 1663 - (909 + 752))) or (not v13:BuffUp(v89.SymbolsofDeath) and v13:HasTier(1253 - (109 + 1114), 3 - 1))) and (v89.SecretTechnique:CooldownRemains() < (4 + 6 + ((254 - (6 + 236)) * v29(not v89.InvigoratingShadowdust:IsAvailable() or v13:HasTier(19 + 11, 2 + 0)))))))) then
						local v245 = 0 - 0;
						while true do
							if (((0 - 0) == v245) or ((3032 - (1076 + 57)) <= (151 + 766))) then
								v102 = v132(v89.ShadowDance, v183);
								if (v102 or ((5001 - (579 + 110)) <= (70 + 806))) then
									return "ShadowDance Macro 1 " .. v102;
								end
								break;
							end
						end
					end
				end
				v184 = 1 + 0;
			end
			if (((1185 + 1047) <= (3003 - (174 + 233))) and (v184 == (2 - 1))) then
				return false;
			end
		end
	end
	local function v136(v185)
		local v186 = not v185 or (v13:EnergyPredicted() >= v185);
		if (((3677 - 1582) < (1640 + 2046)) and v37 and v89.ShurikenStorm:IsCastable() and (v99 >= ((1176 - (663 + 511)) + v21((v89.Gloomblade:IsAvailable() and (v13:BuffRemains(v89.LingeringShadowBuff) >= (6 + 0))) or v13:BuffUp(v89.PerforatedVeinsBuff))))) then
			local v194 = 0 + 0;
			while true do
				if ((v194 == (0 - 0)) or ((966 + 629) >= (10533 - 6059))) then
					if ((v186 and v10.Cast(v89.ShurikenStorm)) or ((11181 - 6562) < (1376 + 1506))) then
						return "Cast Shuriken Storm";
					end
					v113(v89.ShurikenStorm, v185);
					break;
				end
			end
		end
		if (v95 or ((571 - 277) >= (3443 + 1388))) then
			if (((186 + 1843) <= (3806 - (478 + 244))) and v89.Gloomblade:IsCastable()) then
				local v239 = 517 - (440 + 77);
				while true do
					if (((0 + 0) == v239) or ((7455 - 5418) == (3976 - (655 + 901)))) then
						if (((827 + 3631) > (2989 + 915)) and v186 and v26(v89.Gloomblade)) then
							return "Cast Gloomblade";
						end
						v113(v89.Gloomblade, v185);
						break;
					end
				end
			elseif (((295 + 141) >= (495 - 372)) and v89.Backstab:IsCastable()) then
				if (((1945 - (695 + 750)) < (6200 - 4384)) and v186 and v26(v89.Backstab)) then
					return "Cast Backstab";
				end
				v113(v89.Backstab, v185);
			end
		end
		return false;
	end
	local function v137()
		v85();
		v36 = EpicSettings.Toggles['ooc'];
		v37 = EpicSettings.Toggles['aoe'];
		v38 = EpicSettings.Toggles['cds'];
		ToggleMain = EpicSettings.Toggles['toggle'];
		v103 = nil;
		v105 = nil;
		v104 = 0 - 0;
		v93 = (v89.AcrobaticStrikes:IsAvailable() and (32 - 24)) or (356 - (285 + 66));
		v94 = (v89.AcrobaticStrikes:IsAvailable() and (30 - 17)) or (1320 - (682 + 628));
		v95 = v14:IsInMeleeRange(v93);
		v96 = v14:IsInMeleeRange(v94);
		if (((577 + 2997) == (3873 - (176 + 123))) and v37) then
			v97 = v13:GetEnemiesInRange(13 + 17);
			v98 = v13:GetEnemiesInMeleeRange(v94);
			v99 = #v98;
			v100 = v13:GetEnemiesInMeleeRange(v93);
		else
			local v195 = 0 + 0;
			while true do
				if (((490 - (239 + 30)) < (107 + 283)) and (v195 == (1 + 0))) then
					v99 = 1 - 0;
					v100 = {};
					break;
				end
				if ((v195 == (0 - 0)) or ((2528 - (306 + 9)) <= (4958 - 3537))) then
					v97 = {};
					v98 = {};
					v195 = 1 + 0;
				end
			end
		end
		v109 = v13:ComboPoints();
		v108 = v88.EffectiveComboPoints(v109);
		v110 = v13:ComboPointsDeficit();
		v112 = v116();
		v111 = v13:EnergyMax() - v118();
		if (((1877 + 1181) < (2340 + 2520)) and (v108 > v109) and (v110 > (5 - 3)) and v13:AffectingCombat()) then
			if (((v109 == (1377 - (1140 + 235))) and not v13:BuffUp(v89.EchoingReprimand3)) or ((v109 == (2 + 1)) and not v13:BuffUp(v89.EchoingReprimand4)) or ((v109 == (4 + 0)) and not v13:BuffUp(v89.EchoingReprimand5)) or ((333 + 963) >= (4498 - (33 + 19)))) then
				local v240 = v88.TimeToSht(2 + 2);
				if ((v240 == (0 - 0)) or ((614 + 779) > (8802 - 4313))) then
					v240 = v88.TimeToSht(5 + 0);
				end
				if ((v240 < (v34(v13:EnergyTimeToX(724 - (586 + 103)), v13:GCDRemains()) + 0.5 + 0)) or ((13619 - 9195) < (1515 - (1309 + 179)))) then
					v108 = v109;
				end
			end
		end
		if ((v13:BuffUp(v89.ShurikenTornado, nil, true) and (v109 < v88.CPMaxSpend())) or ((3604 - 1607) > (1661 + 2154))) then
			local v196 = 0 - 0;
			local v197;
			while true do
				if (((2618 + 847) > (4064 - 2151)) and (v196 == (0 - 0))) then
					v197 = v88.TimeToNextTornado();
					if (((1342 - (295 + 314)) < (4467 - 2648)) and ((v197 <= v13:GCDRemains()) or (v35(v13:GCDRemains() - v197) < (1962.25 - (1300 + 662))))) then
						local v246 = 0 - 0;
						local v247;
						while true do
							if ((v246 == (1755 - (1178 + 577))) or ((2283 + 2112) == (14056 - 9301))) then
								v247 = v99 + v29(v13:BuffUp(v89.ShadowBlades));
								v109 = v33(v109 + v247, v88.CPMaxSpend());
								v246 = 1406 - (851 + 554);
							end
							if ((v246 == (1 + 0)) or ((10519 - 6726) < (5144 - 2775))) then
								v110 = v34(v110 - v247, 302 - (115 + 187));
								if ((v108 < v88.CPMaxSpend()) or ((3128 + 956) == (251 + 14))) then
									v108 = v109;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
		v106 = ((15 - 11) + (v108 * (1165 - (160 + 1001)))) * (0.3 + 0);
		v107 = v89.Eviscerate:Damage() * v74;
		if (((3007 + 1351) == (8921 - 4563)) and v90.Healthstone:IsReady() and (v13:HealthPercentage() < v44) and not (v13:IsChanneling() or v13:IsCasting())) then
			if (v10.Cast(v91.Healthstone) or ((3496 - (237 + 121)) < (1890 - (525 + 372)))) then
				return "Healthstone ";
			end
		end
		if (((6313 - 2983) > (7632 - 5309)) and v90.RefreshingHealingPotion:IsReady() and (v13:HealthPercentage() < v42) and not (v13:IsChanneling() or v13:IsCasting())) then
			if (v10.Cast(v91.RefreshingHealingPotion) or ((3768 - (96 + 46)) == (4766 - (643 + 134)))) then
				return "RefreshingHealingPotion ";
			end
		end
		v102 = v88.CrimsonVial();
		if (v102 or ((331 + 585) == (6404 - 3733))) then
			return v102;
		end
		v88.Poisons();
		if (((1009 - 737) == (261 + 11)) and not v13:AffectingCombat()) then
			local v198 = 0 - 0;
			while true do
				if (((8685 - 4436) <= (5558 - (316 + 403))) and (v198 == (1 + 0))) then
					if (((7634 - 4857) < (1157 + 2043)) and v86.TargetIsValid()) then
						if (((239 - 144) < (1387 + 570)) and v15:Exists() and v89.TricksoftheTrade:IsReady()) then
							if (((267 + 559) < (5949 - 4232)) and v26(v91.TricksoftheTradeFocus)) then
								return "precombat tricks_of_the_trade";
							end
						end
					end
					break;
				end
				if (((6810 - 5384) >= (2295 - 1190)) and (v198 == (0 + 0))) then
					v102 = v88.Poisons();
					if (((5420 - 2666) <= (166 + 3213)) and v102) then
						return v102;
					end
					v198 = 2 - 1;
				end
			end
		end
		if ((not v13:AffectingCombat() and not v13:IsMounted() and v86.TargetIsValid()) or ((3944 - (12 + 5)) == (5487 - 4074))) then
			v102 = v88.Stealth(v89.Stealth2, nil);
			if (v102 or ((2462 - 1308) <= (1674 - 886))) then
				return "Stealth (OOC): " .. v102;
			end
		end
		if ((not v13:IsChanneling() and ToggleMain) or ((4074 - 2431) > (686 + 2693))) then
			local v199 = 1973 - (1656 + 317);
			while true do
				if ((v199 == (0 + 0)) or ((2247 + 556) > (12095 - 7546))) then
					if ((not v13:AffectingCombat() and v14:AffectingCombat() and (v89.Vanish:TimeSinceLastCast() > (4 - 3))) or ((574 - (5 + 349)) >= (14354 - 11332))) then
						if (((4093 - (266 + 1005)) == (1860 + 962)) and v86.TargetIsValid() and (v14:IsSpellInRange(v89.Shadowstrike) or v95)) then
							if (v13:StealthUp(true, true) or ((3620 - 2559) == (2444 - 587))) then
								v103 = v131(true);
								if (((4456 - (561 + 1135)) > (1777 - 413)) and v103) then
									if (((type(v103) == "table") and (#v103 > (3 - 2))) or ((5968 - (507 + 559)) <= (9021 - 5426))) then
										if (v26(nil, unpack(v103)) or ((11912 - 8060) == (681 - (212 + 176)))) then
											return "Stealthed Macro Cast or Pool (OOC): " .. v103[906 - (250 + 655)]:Name();
										end
									elseif (v26(v103) or ((4251 - 2692) == (8016 - 3428))) then
										return "Stealthed Cast or Pool (OOC): " .. v103:Name();
									end
								end
							elseif ((v109 >= (7 - 2)) or ((6440 - (1869 + 87)) == (2733 - 1945))) then
								local v258 = 1901 - (484 + 1417);
								while true do
									if (((9790 - 5222) >= (6547 - 2640)) and (v258 == (773 - (48 + 725)))) then
										v102 = v130();
										if (((2035 - 789) < (9309 - 5839)) and v102) then
											return v102 .. " (OOC)";
										end
										break;
									end
								end
							end
						end
						return;
					end
					if (((2365 + 1703) >= (2597 - 1625)) and v86.TargetIsValid() and (v36 or v13:AffectingCombat())) then
						local v248 = 0 + 0;
						local v249;
						while true do
							if (((144 + 349) < (4746 - (152 + 701))) and (v248 == (1316 - (430 + 881)))) then
								if (v105 or ((565 + 908) >= (4227 - (557 + 338)))) then
									v113(v105);
								end
								if ((v103 and v95) or ((1198 + 2853) <= (3260 - 2103))) then
									if (((2115 - 1511) < (7653 - 4772)) and (type(v103) == "table") and (#v103 > (2 - 1))) then
										if (v28(v13:EnergyTimeToX(v104), unpack(v103)) or ((1701 - (499 + 302)) == (4243 - (39 + 827)))) then
											return "Macro pool towards " .. v103[2 - 1]:Name() .. " at " .. v104;
										end
									elseif (((9958 - 5499) > (2347 - 1756)) and v103:IsCastable()) then
										v104 = v34(v104, v103:Cost());
										if (((5216 - 1818) >= (206 + 2189)) and v26(v103, v13:EnergyTimeToX(v104))) then
											return "Pool towards: " .. v103:Name() .. " at " .. v104;
										end
									end
								end
								break;
							end
							if ((v248 == (11 - 7)) or ((350 + 1833) >= (4468 - 1644))) then
								v102 = v136(v111);
								if (((2040 - (103 + 1)) == (2490 - (475 + 79))) and v102) then
									return "Build: " .. v102;
								end
								if (v10.CD or ((10445 - 5613) < (13801 - 9488))) then
									local v254 = 0 + 0;
									while true do
										if (((3598 + 490) > (5377 - (1395 + 108))) and (v254 == (2 - 1))) then
											if (((5536 - (7 + 1197)) == (1889 + 2443)) and v89.LightsJudgment:IsReady()) then
												if (((1396 + 2603) >= (3219 - (27 + 292))) and v26(v89.LightsJudgment, v39)) then
													return "Cast Lights Judgment";
												end
											end
											if (v89.BagofTricks:IsReady() or ((7398 - 4873) > (5181 - 1117))) then
												if (((18331 - 13960) == (8619 - 4248)) and v26(v89.BagofTricks, v39)) then
													return "Cast Bag of Tricks";
												end
											end
											break;
										end
										if ((v254 == (0 - 0)) or ((405 - (43 + 96)) > (20338 - 15352))) then
											if (((4501 - 2510) >= (768 + 157)) and v89.ArcaneTorrent:IsReady() and v95 and (v13:EnergyDeficitPredicted() >= (5 + 10 + v13:EnergyRegen()))) then
												if (((899 - 444) < (787 + 1266)) and v26(v89.ArcaneTorrent, v39)) then
													return "Cast Arcane Torrent";
												end
											end
											if ((v89.ArcanePulse:IsReady() and v95) or ((1547 - 721) == (1528 + 3323))) then
												if (((14 + 169) == (1934 - (1414 + 337))) and v26(v89.ArcanePulse, v39)) then
													return "Cast Arcane Pulse";
												end
											end
											v254 = 1941 - (1642 + 298);
										end
									end
								end
								v248 = 12 - 7;
							end
							if (((3333 - 2174) <= (5305 - 3517)) and (v248 == (1 + 2))) then
								if ((v108 >= v88.CPMaxSpend()) or ((2729 + 778) > (5290 - (357 + 615)))) then
									local v255 = 0 + 0;
									while true do
										if ((v255 == (0 - 0)) or ((2635 + 440) <= (6354 - 3389))) then
											v102 = v130();
											if (((1092 + 273) <= (137 + 1874)) and v102) then
												return "Finish: " .. v102;
											end
											break;
										end
									end
								end
								if ((v110 <= (1 + 0)) or (HL.BossFilteredFightRemains("<=", 1302 - (384 + 917)) and (v108 >= (700 - (128 + 569)))) or ((4319 - (1407 + 136)) > (5462 - (687 + 1200)))) then
									v102 = v130();
									if (v102 or ((4264 - (556 + 1154)) == (16900 - 12096))) then
										return "Finish: " .. v102;
									end
								end
								if (((2672 - (9 + 86)) == (2998 - (275 + 146))) and (v99 >= (1 + 3)) and (v108 >= (68 - (29 + 35)))) then
									v102 = v130();
									if (v102 or ((26 - 20) >= (5641 - 3752))) then
										return "Finish: " .. v102;
									end
								end
								v248 = 17 - 13;
							end
							if (((330 + 176) <= (2904 - (53 + 959))) and (v248 == (410 - (312 + 96)))) then
								v249 = nil;
								if (not v89.Vigor:IsAvailable() or v89.Shadowcraft:IsAvailable() or ((3484 - 1476) > (2503 - (147 + 138)))) then
									v249 = v13:EnergyDeficitPredicted() <= v118();
								else
									v249 = v13:EnergyPredicted() >= v118();
								end
								if (((1278 - (813 + 86)) <= (3748 + 399)) and (v249 or v89.InvigoratingShadowdust:IsAvailable())) then
									local v256 = 0 - 0;
									while true do
										if ((v256 == (492 - (18 + 474))) or ((1523 + 2991) <= (3293 - 2284))) then
											v102 = v135(v111);
											if (v102 or ((4582 - (860 + 226)) == (1495 - (121 + 182)))) then
												return "Stealth CDs: " .. v102;
											end
											break;
										end
									end
								end
								v248 = 1 + 2;
							end
							if ((v248 == (1241 - (988 + 252))) or ((24 + 184) == (927 + 2032))) then
								if (((6247 - (49 + 1921)) >= (2203 - (223 + 667))) and v102) then
									return "CDs: " .. v102;
								end
								if (((2639 - (51 + 1)) < (5462 - 2288)) and v89.SliceandDice:IsCastable() and (v99 < v88.CPMaxSpend()) and (v13:BuffRemains(v89.SliceandDice) < v13:GCD()) and v10.BossFilteredFightRemains(">", 12 - 6) and (v109 >= (1129 - (146 + 979)))) then
									if ((v89.SliceandDice:IsReady() and v26(v89.SliceandDice)) or ((1163 + 2957) <= (2803 - (311 + 294)))) then
										return "Cast Slice and Dice (Low Duration)";
									end
									v114(v89.SliceandDice);
								end
								if (v13:StealthUp(true, true) or ((4450 - 2854) == (364 + 494))) then
									v103 = v131(true);
									if (((4663 - (496 + 947)) == (4578 - (1233 + 125))) and v103) then
										if (((type(v103) == "table") and (#v103 > (1 + 0))) or ((1258 + 144) > (688 + 2932))) then
											if (((4219 - (963 + 682)) == (2149 + 425)) and v28(nil, unpack(v103))) then
												return "Stealthed Macro " .. v103[1505 - (504 + 1000)]:Name() .. "|" .. v103[2 + 0]:Name();
											end
										elseif (((1638 + 160) < (261 + 2496)) and v13:BuffUp(v89.ShurikenTornado) and (v109 ~= v13:ComboPoints()) and ((v103 == v89.BlackPowder) or (v103 == v89.Eviscerate) or (v103 == v89.Rupture) or (v103 == v89.SliceandDice))) then
											if (v28(nil, v89.ShurikenTornado, v103) or ((555 - 178) > (2225 + 379))) then
												return "Stealthed Tornado Cast  " .. v103:Name();
											end
										elseif (((331 + 237) < (1093 - (156 + 26))) and v26(v103)) then
											return "Stealthed Cast " .. v103:Name();
										end
									end
									v26(v89.PoolEnergy);
									return "Stealthed Pooling";
								end
								v248 = 2 + 0;
							end
							if (((5139 - 1854) < (4392 - (149 + 15))) and (v248 == (960 - (890 + 70)))) then
								if (((4033 - (39 + 78)) > (3810 - (14 + 468))) and v84 and v89.Shiv:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v86.UnitHasEnrageBuff(v14)) then
									if (((5497 - 2997) < (10730 - 6891)) and v26(v89.Shiv, not v95)) then
										return "dispel";
									end
								end
								if (((262 + 245) == (305 + 202)) and (v10.CombatTime() < (3 + 7)) and (v10.CombatTime() > (0 + 0)) and v89.ShadowDance:CooldownUp() and (v89.Vanish:TimeSinceLastCast() > (3 + 8))) then
									local v257 = 0 - 0;
									while true do
										if (((238 + 2) <= (11121 - 7956)) and (v257 == (0 + 0))) then
											if (((885 - (12 + 39)) >= (749 + 56)) and v13:StealthUp(true, true)) then
												if (v10.Cast(v89.Shadowstrike) or ((11799 - 7987) < (8248 - 5932))) then
													return "Opener SS";
												end
											end
											if ((v89.SymbolsofDeath:IsCastable() and v13:BuffDown(v89.SymbolsofDeath)) or ((787 + 1865) <= (807 + 726))) then
												if (v10.Cast(v89.SymbolsofDeath, true) or ((9123 - 5525) < (973 + 487))) then
													return "Opener SymbolsofDeath";
												end
											end
											v257 = 4 - 3;
										end
										if ((v257 == (1712 - (1596 + 114))) or ((10745 - 6629) < (1905 - (164 + 549)))) then
											if (((v89.Gloomblade:TimeSinceLastCast() > (1441 - (1059 + 379))) and (v99 <= (1 - 0))) or ((1751 + 1626) <= (153 + 750))) then
												if (((4368 - (145 + 247)) >= (361 + 78)) and v10.Cast(v89.Gloomblade)) then
													return "Opener Gloomblade";
												end
											end
											if (((1734 + 2018) == (11123 - 7371)) and v14:DebuffDown(v89.Rupture) and (v99 <= (1 + 0)) and (v109 > (0 + 0))) then
												if (((6568 - 2522) > (3415 - (254 + 466))) and v10.Cast(v89.Rupture)) then
													return "Opener Rupture";
												end
											end
											v257 = 563 - (544 + 16);
										end
										if ((v257 == (2 - 1)) or ((4173 - (294 + 334)) == (3450 - (236 + 17)))) then
											if (((1033 + 1361) > (291 + 82)) and v89.ShadowBlades:IsCastable() and v13:BuffDown(v89.ShadowBlades)) then
												if (((15648 - 11493) <= (20036 - 15804)) and v10.Cast(v89.ShadowBlades, true)) then
													return "Opener ShadowBlades";
												end
											end
											if ((v89.ShurikenStorm:IsCastable() and (v99 >= (2 + 0))) or ((2950 + 631) == (4267 - (413 + 381)))) then
												if (((211 + 4784) > (7120 - 3772)) and v10.Cast(v89.ShurikenStorm)) then
													return "Opener Shuriken Tornado";
												end
											end
											v257 = 4 - 2;
										end
										if ((v257 == (1973 - (582 + 1388))) or ((1284 - 530) > (2666 + 1058))) then
											if (((581 - (326 + 38)) >= (168 - 111)) and v89.ShadowDance:IsCastable() and v38 and v10.Cast(v91.ShadowDance, true)) then
												return "Opener ShadowDance";
											end
											break;
										end
									end
								end
								v102 = v134();
								v248 = 1 - 0;
							end
						end
					end
					v199 = 621 - (47 + 573);
				end
				if ((v199 == (1 + 0)) or ((8791 - 6721) >= (6551 - 2514))) then
					if (((4369 - (1269 + 395)) == (3197 - (76 + 416))) and v89.ShurikenToss:IsCastable() and v14:IsInRange(473 - (319 + 124)) and not v96 and not v13:StealthUp(true, true) and not v13:BuffUp(v89.Sprint) and (v13:EnergyDeficitPredicted() < (45 - 25)) and ((v110 >= (1008 - (564 + 443))) or (v13:EnergyTimeToMax() <= (2.2 - 1)))) then
						if (((519 - (337 + 121)) == (178 - 117)) and v26(v89.ShurikenToss)) then
							return "Cast Shuriken Toss";
						end
					end
					break;
				end
			end
		end
	end
	local function v138()
		v10.Print("Subtlety Rogue rotation has NOT been updated for patch 10.2.0. It is unlikely to work properly at this time.");
	end
	v10.SetAPL(869 - 608, v137, v138);
end;
return v0["Epix_Rogue_Subtlety.lua"]();

