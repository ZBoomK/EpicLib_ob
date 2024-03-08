local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (461 - (364 + 97))) or ((21141 - 16896) == (173 + 4458))) then
			v6 = v0[v4];
			if (((15529 - 11253) >= (1391 + 2523)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((587 - 389) <= (2389 + 1976)) and (v5 == (1 - 0))) then
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
	local v15 = v10.Spell;
	local v16 = v10.MultiSpell;
	local v17 = v10.Item;
	local v18 = v10.Utils.BoolToInt;
	local v19 = v10.Cast;
	local v20 = v10.CastLeftNameplate;
	local v21 = v10.CastPooling;
	local v22 = v10.CastQueue;
	local v23 = v12.Focus;
	local v24 = v10.Press;
	local v25 = v10.CastQueuePooling;
	local v26 = v10.Commons.Everyone.num;
	local v27 = v10.Commons.Everyone.bool;
	local v28 = pairs;
	local v29 = table.insert;
	local v30 = math.min;
	local v31 = math.max;
	local v32 = math.abs;
	local v33 = v10.Commons.Everyone;
	local v34 = v10.Commons.Rogue;
	local v35 = v10.Macro;
	local v36 = v15.Rogue.Subtlety;
	local v37 = v17.Rogue.Subtlety;
	local v38 = v35.Rogue.Subtlety;
	local v39 = false;
	local v40 = false;
	local v41 = false;
	local v42 = false;
	local v43 = false;
	local v44 = false;
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
	local v68 = {v37.Mirror:ID(),v37.WitherbarksBranch:ID(),v37.AshesoftheEmbersoul:ID()};
	local v69, v70, v71, v72;
	local v73, v74, v75, v76;
	local v77;
	local v78, v79, v80;
	local v81, v82;
	local v83, v84, v85, v86;
	local v87;
	v36.Eviscerate:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v83 * (0.176 + 0) * (1.21 + 0) * ((v36.Nightstalker:IsAvailable() and v13:StealthUp(true, false) and (434.08 - (153 + 280))) or (2 - 1)) * ((v36.DeeperStratagem:IsAvailable() and (1.05 + 0)) or (1 + 0)) * ((v36.DarkShadow:IsAvailable() and v13:BuffUp(v36.ShadowDanceBuff) and (1.3 + 0)) or (1 + 0)) * ((v13:BuffUp(v36.SymbolsofDeath) and (1.1 + 0)) or (1 - 0)) * ((v13:BuffUp(v36.FinalityEviscerateBuff) and (1.3 + 0)) or (668 - (89 + 578))) * (1 + 0 + (v13:MasteryPct() / (207 - 107))) * ((1050 - (572 + 477)) + (v13:VersatilityDmgPct() / (14 + 86))) * ((v14:DebuffUp(v36.FindWeaknessDebuff) and (1.5 + 0)) or (1 + 0));
	end);
	local function v88(v119, v120)
		if (((4868 - (84 + 2)) > (7706 - 3030)) and not v78) then
			v78 = v119;
			v79 = v120 or (0 + 0);
		end
	end
	local function v89(v121)
		if (((5706 - (497 + 345)) > (57 + 2140)) and not v80) then
			v80 = v121;
		end
	end
	local function v90()
		if (((v45 == "On Bosses not in Dungeons") and v13:IsInDungeonArea()) or ((626 + 3074) == (3840 - (605 + 728)))) then
			return false;
		elseif (((3193 + 1281) >= (608 - 334)) and (v45 ~= "Always") and not v14:IsInBossList()) then
			return false;
		else
			return true;
		end
	end
	local function v91()
		local v122 = 0 + 0;
		while true do
			if ((v122 == (0 - 0)) or ((1708 + 186) <= (3895 - 2489))) then
				if (((1187 + 385) >= (2020 - (457 + 32))) and (v75 < (1 + 1))) then
					return false;
				elseif ((v46 == "Always") or ((6089 - (832 + 570)) < (4279 + 263))) then
					return true;
				elseif (((859 + 2432) > (5898 - 4231)) and (v46 == "On Bosses") and v14:IsInBossList()) then
					return true;
				elseif ((v46 == "Auto") or ((421 + 452) == (2830 - (588 + 208)))) then
					if (((v13:InstanceDifficulty() == (43 - 27)) and (v14:NPCID() == (140767 - (884 + 916)))) or ((5895 - 3079) < (7 + 4))) then
						return true;
					elseif (((4352 - (232 + 421)) < (6595 - (1569 + 320))) and ((v14:NPCID() == (40965 + 126004)) or (v14:NPCID() == (31722 + 135249)) or (v14:NPCID() == (562658 - 395688)))) then
						return true;
					elseif (((3251 - (316 + 289)) >= (2293 - 1417)) and ((v14:NPCID() == (8473 + 174990)) or (v14:NPCID() == (185124 - (666 + 787))))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v92(v123, v124, v125, v126)
		local v127 = 425 - (360 + 65);
		local v128;
		local v129;
		local v130;
		while true do
			if (((574 + 40) <= (3438 - (79 + 175))) and ((1 - 0) == v127)) then
				for v200, v201 in v28(v126) do
					if (((2440 + 686) == (9581 - 6455)) and (v201:GUID() ~= v130) and v33.UnitIsCycleValid(v201, v129, -v201:DebuffRemains(v123)) and v124(v201)) then
						v128, v129 = v201, v201:TimeToDie();
					end
				end
				if ((v128 and (v14:GUID() == v128:GUID())) or ((4211 - 2024) >= (5853 - (503 + 396)))) then
					v10.Press(v123);
				elseif (v47 or ((4058 - (92 + 89)) == (6934 - 3359))) then
					v128, v129 = nil, v125;
					for v222, v223 in v28(v74) do
						if (((363 + 344) > (375 + 257)) and (v223:GUID() ~= v130) and v33.UnitIsCycleValid(v223, v129, -v223:DebuffRemains(v123)) and v124(v223)) then
							v128, v129 = v223, v223:TimeToDie();
						end
					end
					if ((v128 and (v14:GUID() == v128:GUID())) or ((2138 - 1592) >= (368 + 2316))) then
						v10.Press(v123);
					end
				end
				break;
			end
			if (((3340 - 1875) <= (3753 + 548)) and (v127 == (0 + 0))) then
				v128, v129 = nil, v125;
				v130 = v14:GUID();
				v127 = 2 - 1;
			end
		end
	end
	local function v93()
		return 3 + 17 + (v36.Vigor:TalentRank() * (38 - 13)) + (v26(v36.ThistleTea:IsAvailable()) * (1264 - (485 + 759))) + (v26(v36.Shadowcraft:IsAvailable()) * (46 - 26));
	end
	local function v94()
		return v36.ShadowDance:ChargesFractional() >= ((1189.75 - (442 + 747)) + v18(v36.ShadowDanceTalent:IsAvailable()));
	end
	local function v95()
		return v85 >= (1138 - (832 + 303));
	end
	local function v96()
		return v13:BuffUp(v36.SliceandDice) or (v75 >= v34.CPMaxSpend());
	end
	local function v97()
		return v36.Premeditation:IsAvailable() and (v75 < (951 - (88 + 858)));
	end
	local function v98(v131)
		return (v13:BuffUp(v36.ThistleTea) and (v75 == (1 + 0))) or (v131 and ((v75 == (1 + 0)) or (v14:DebuffUp(v36.Rupture) and (v75 >= (1 + 1)))));
	end
	local function v99()
		return (not v13:BuffUp(v36.TheRotten) or not v13:HasTier(819 - (766 + 23), 9 - 7)) and (not v36.ColdBlood:IsAvailable() or (v36.ColdBlood:CooldownRemains() < (5 - 1)) or (v36.ColdBlood:CooldownRemains() > (26 - 16)));
	end
	local function v100(v132)
		return v13:BuffUp(v36.ShadowDanceBuff) and (v132:TimeSinceLastCast() < v36.ShadowDance:TimeSinceLastCast());
	end
	local function v101()
		return ((v100(v36.Shadowstrike) or v100(v36.ShurikenStorm)) and (v100(v36.Eviscerate) or v100(v36.BlackPowder) or v100(v36.Rupture))) or not v36.DanseMacabre:IsAvailable();
	end
	local function v102()
		return (not v37.WitherbarksBranch:IsEquipped() and not v37.AshesoftheEmbersoul:IsEquipped()) or (not v37.WitherbarksBranch:IsEquipped() and (v37.WitherbarksBranch:CooldownRemains() <= (27 - 19))) or (v37.WitherbarksBranch:IsEquipped() and (v37.WitherbarksBranch:CooldownRemains() <= (1081 - (1036 + 37)))) or v37.BandolierOfTwistedBlades:IsEquipped() or v36.InvigoratingShadowdust:IsAvailable();
	end
	local function v103(v133, v134)
		local v135 = 0 + 0;
		local v136;
		local v137;
		local v138;
		local v139;
		local v140;
		local v141;
		local v142;
		while true do
			if (((3317 - 1613) > (1121 + 304)) and (v135 == (1482 - (641 + 839)))) then
				v142 = v13:BuffUp(v36.PremeditationBuff) or (v134 and v36.Premeditation:IsAvailable());
				if ((v134 and (v134:ID() == v36.ShadowDance:ID())) or ((1600 - (910 + 3)) == (10793 - 6559))) then
					v136 = true;
					v137 = (1692 - (1466 + 218)) + v36.ImprovedShadowDance:TalentRank();
					if (v36.TheFirstDance:IsAvailable() or ((1531 + 1799) < (2577 - (556 + 592)))) then
						v139 = v30(v13:ComboPointsMax(), v84 + 2 + 2);
					end
					if (((1955 - (329 + 479)) >= (1189 - (174 + 680))) and v13:HasTier(103 - 73, 3 - 1)) then
						v138 = v31(v138, 5 + 1);
					end
				end
				if (((4174 - (396 + 343)) > (186 + 1911)) and v134 and (v134:ID() == v36.Vanish:ID())) then
					v140 = v30(1477 - (29 + 1448), v36.ColdBlood:CooldownRemains() - ((1404 - (135 + 1254)) * v36.InvigoratingShadowdust:TalentRank()));
					v141 = v30(0 - 0, v36.SymbolsofDeath:CooldownRemains() - ((70 - 55) * v36.InvigoratingShadowdust:TalentRank()));
				end
				v135 = 2 + 1;
			end
			if ((v135 == (1528 - (389 + 1138))) or ((4344 - (102 + 472)) >= (3814 + 227))) then
				v139 = v84;
				v140 = v36.ColdBlood:CooldownRemains();
				v141 = v36.SymbolsofDeath:CooldownRemains();
				v135 = 2 + 0;
			end
			if ((v135 == (4 + 0)) or ((5336 - (320 + 1225)) <= (2867 - 1256))) then
				if ((v13:BuffUp(v36.FinalityRuptureBuff) and v136 and (v75 <= (3 + 1)) and not v100(v36.Rupture)) or ((6042 - (157 + 1307)) <= (3867 - (821 + 1038)))) then
					if (((2806 - 1681) <= (228 + 1848)) and v133) then
						return v36.Rupture;
					else
						if ((v36.Rupture:IsReady() and v19(v36.Rupture)) or ((1319 - 576) >= (1637 + 2762))) then
							return "Cast Rupture Finality";
						end
						v89(v36.Rupture);
					end
				end
				if (((2862 - 1707) < (2699 - (834 + 192))) and v36.ColdBlood:IsReady() and v101(v136, v142) and v36.SecretTechnique:IsReady() and (v84 >= (1 + 4))) then
					local v206 = 0 + 0;
					while true do
						if ((v206 == (0 + 0)) or ((3599 - 1275) <= (882 - (300 + 4)))) then
							if (((1007 + 2760) == (9860 - 6093)) and v133) then
								return v36.ColdBlood;
							end
							if (((4451 - (112 + 250)) == (1631 + 2458)) and v24(v38.ColdBloodTechnique, nil, nil, true)) then
								return "Cast Cold Blood (SecTec)";
							end
							break;
						end
					end
				end
				if (((11168 - 6710) >= (960 + 714)) and v36.SecretTechnique:IsReady()) then
					if (((503 + 469) <= (1061 + 357)) and v101(v136, v142) and (not v36.ColdBlood:IsAvailable() or v13:BuffUp(v36.ColdBlood) or (v140 > (v137 - (1 + 1))) or not v36.ImprovedShadowDance:IsAvailable())) then
						local v213 = 0 + 0;
						while true do
							if (((1414 - (1001 + 413)) == v213) or ((11011 - 6073) < (5644 - (244 + 638)))) then
								if (v133 or ((3197 - (627 + 66)) > (12704 - 8440))) then
									return v36.SecretTechnique;
								end
								if (((2755 - (512 + 90)) == (4059 - (1665 + 241))) and v19(v36.SecretTechnique)) then
									return "Cast Secret Technique";
								end
								break;
							end
						end
					end
				end
				v135 = 722 - (373 + 344);
			end
			if ((v135 == (3 + 2)) or ((135 + 372) >= (6834 - 4243))) then
				if (((7582 - 3101) == (5580 - (35 + 1064))) and not v98(v136) and v36.Rupture:IsCastable()) then
					local v207 = 0 + 0;
					while true do
						if (((0 - 0) == v207) or ((10 + 2318) < (1929 - (298 + 938)))) then
							if (((5587 - (233 + 1026)) == (5994 - (636 + 1030))) and not v133 and v40 and not v87 and (v75 >= (2 + 0))) then
								local function v227(v228)
									return v33.CanDoTUnit(v228, v82) and v228:DebuffRefreshable(v36.Rupture, v81);
								end
								v92(v36.Rupture, v227, (2 + 0) * v139, v76);
							end
							if (((472 + 1116) >= (90 + 1242)) and v71 and (v14:DebuffRemains(v36.Rupture) < (v141 + (231 - (55 + 166)))) and (v141 <= (1 + 4)) and v34.CanDoTUnit(v14, v82) and v14:FilteredTimeToDie(">", 1 + 4 + v141, -v14:DebuffRemains(v36.Rupture))) then
								if (v133 or ((15940 - 11766) > (4545 - (36 + 261)))) then
									return v36.Rupture;
								else
									if ((v36.Rupture:IsReady() and v19(v36.Rupture)) or ((8019 - 3433) <= (1450 - (34 + 1334)))) then
										return "Cast Rupture 2";
									end
									v89(v36.Rupture);
								end
							end
							break;
						end
					end
				end
				if (((1486 + 2377) == (3002 + 861)) and v36.BlackPowder:IsCastable() and not v87 and (v75 >= (1286 - (1035 + 248))) and not v44) then
					if (v133 or ((303 - (20 + 1)) <= (22 + 20))) then
						return v36.BlackPowder;
					else
						local v214 = 319 - (134 + 185);
						while true do
							if (((5742 - (549 + 584)) >= (1451 - (314 + 371))) and (v214 == (0 - 0))) then
								if ((v36.BlackPowder:IsReady() and v19(v36.BlackPowder)) or ((2120 - (478 + 490)) == (1318 + 1170))) then
									return "Cast Black Powder";
								end
								v89(v36.BlackPowder);
								break;
							end
						end
					end
				end
				if (((4594 - (786 + 386)) > (10850 - 7500)) and v36.Eviscerate:IsCastable() and v71) then
					if (((2256 - (1055 + 324)) > (1716 - (1093 + 247))) and v133) then
						return v36.Eviscerate;
					else
						local v215 = 0 + 0;
						while true do
							if ((v215 == (0 + 0)) or ((12379 - 9261) <= (6281 - 4430))) then
								if ((v36.Eviscerate:IsReady() and v19(v36.Eviscerate)) or ((469 - 304) >= (8774 - 5282))) then
									return "Cast Eviscerate";
								end
								v89(v36.Eviscerate);
								break;
							end
						end
					end
				end
				v135 = 3 + 3;
			end
			if (((15213 - 11264) < (16737 - 11881)) and (v135 == (0 + 0))) then
				v136 = v13:BuffUp(v36.ShadowDanceBuff);
				v137 = v13:BuffRemains(v36.ShadowDanceBuff);
				v138 = v13:BuffRemains(v36.SymbolsofDeath);
				v135 = 2 - 1;
			end
			if ((v135 == (691 - (364 + 324))) or ((11721 - 7445) < (7237 - 4221))) then
				if (((1555 + 3135) > (17260 - 13135)) and v36.Rupture:IsCastable() and v36.Rupture:IsReady()) then
					if ((v14:DebuffDown(v36.Rupture) and (v14:TimeToDie() > (9 - 3))) or ((151 - 101) >= (2164 - (1249 + 19)))) then
						if (v133 or ((1548 + 166) >= (11513 - 8555))) then
							return v36.Rupture;
						else
							local v225 = 1086 - (686 + 400);
							while true do
								if (((0 + 0) == v225) or ((1720 - (73 + 156)) < (4 + 640))) then
									if (((1515 - (721 + 90)) < (12 + 975)) and v36.Rupture:IsReady() and v19(v36.Rupture)) then
										return "Cast Rupture";
									end
									v89(v36.Rupture);
									break;
								end
							end
						end
					end
				end
				if (((12071 - 8353) > (2376 - (224 + 246))) and not v13:StealthUp(true, true) and not v97() and (v75 < (9 - 3)) and not v136 and v10.BossFilteredFightRemains(">", v13:BuffRemains(v36.SliceandDice)) and (v13:BuffRemains(v36.SliceandDice) < (((1 - 0) + v13:ComboPoints()) * (1.8 + 0)))) then
					if (v133 or ((23 + 935) > (2670 + 965))) then
						return v36.SliceandDice;
					else
						if (((6960 - 3459) <= (14948 - 10456)) and v36.SliceandDice:IsReady() and v19(v36.SliceandDice)) then
							return "Cast Slice and Dice Premed";
						end
						v89(v36.SliceandDice);
					end
				end
				if (((not v98(v136) or v87) and (v14:TimeToDie() > (519 - (203 + 310))) and v14:DebuffRefreshable(v36.Rupture, v81)) or ((5435 - (1238 + 755)) < (179 + 2369))) then
					if (((4409 - (709 + 825)) >= (2697 - 1233)) and v133) then
						return v36.Rupture;
					else
						if ((v36.Rupture:IsReady() and v19(v36.Rupture)) or ((6987 - 2190) >= (5757 - (196 + 668)))) then
							return "Cast Rupture";
						end
						v89(v36.Rupture);
					end
				end
				v135 = 15 - 11;
			end
			if ((v135 == (12 - 6)) or ((1384 - (171 + 662)) > (2161 - (4 + 89)))) then
				return false;
			end
		end
	end
	local function v104(v143, v144)
		local v145 = v13:BuffUp(v36.ShadowDanceBuff);
		local v146 = v13:BuffRemains(v36.ShadowDanceBuff);
		local v147 = v13:BuffUp(v36.TheRottenBuff);
		local v148, v149 = v84, v85;
		local v150 = v13:BuffUp(v36.PremeditationBuff) or (v144 and v36.Premeditation:IsAvailable());
		local v151 = v13:BuffUp(v34.StealthSpell()) or (v144 and (v144:ID() == v34.StealthSpell():ID()));
		local v152 = v13:BuffUp(v34.VanishBuffSpell()) or (v144 and (v144:ID() == v36.Vanish:ID()));
		if (((7409 - 5295) > (344 + 600)) and v144 and (v144:ID() == v36.ShadowDance:ID())) then
			v145 = true;
			v146 = (35 - 27) + v36.ImprovedShadowDance:TalentRank();
			if ((v36.TheRotten:IsAvailable() and v13:HasTier(12 + 18, 1488 - (35 + 1451))) or ((3715 - (28 + 1425)) >= (5089 - (941 + 1052)))) then
				v147 = true;
			end
			if (v36.TheFirstDance:IsAvailable() or ((2163 + 92) >= (5051 - (822 + 692)))) then
				local v202 = 0 - 0;
				while true do
					if ((v202 == (0 + 0)) or ((4134 - (45 + 252)) < (1293 + 13))) then
						v148 = v30(v13:ComboPointsMax(), v84 + 2 + 2);
						v149 = v13:ComboPointsMax() - v148;
						break;
					end
				end
			end
		end
		local v153 = v34.EffectiveComboPoints(v148);
		local v154 = v36.Shadowstrike:IsCastable() or v151 or v152 or v145 or v13:BuffUp(v36.SepsisBuff);
		if (((7179 - 4229) == (3383 - (114 + 319))) and (v151 or v152)) then
			v154 = v154 and v14:IsInRange(35 - 10);
		else
			v154 = v154 and v71;
		end
		if ((v154 and v151 and ((v75 < (4 - 0)) or v87)) or ((3011 + 1712) < (4913 - 1615))) then
			if (((2379 - 1243) >= (2117 - (556 + 1407))) and v143) then
				return v36.Shadowstrike;
			elseif (v19(v36.Shadowstrike) or ((1477 - (741 + 465)) > (5213 - (170 + 295)))) then
				return "Cast Shadowstrike (Stealth)";
			end
		end
		if (((2498 + 2242) >= (2896 + 256)) and (v153 >= v34.CPMaxSpend())) then
			return v103(v143, v144);
		end
		if ((v13:BuffUp(v36.ShurikenTornado) and (v149 <= (4 - 2))) or ((2138 + 440) >= (2175 + 1215))) then
			return v103(v143, v144);
		end
		if (((24 + 17) <= (2891 - (957 + 273))) and (v85 <= (1 + 0 + v26(v36.DeeperStratagem:IsAvailable() or v36.SecretStratagem:IsAvailable())))) then
			return v103(v143, v144);
		end
		if (((241 + 360) < (13565 - 10005)) and v36.Backstab:IsCastable() and not v150 and (v146 >= (7 - 4)) and v13:BuffUp(v36.ShadowBlades) and not v100(v36.Backstab) and v36.DanseMacabre:IsAvailable() and (v75 <= (9 - 6)) and not v147) then
			if (((1163 - 928) < (2467 - (389 + 1391))) and v143) then
				if (((2855 + 1694) > (121 + 1032)) and v144) then
					return v36.Backstab;
				else
					return {v36.Backstab,v36.Stealth};
				end
			elseif (v22(v36.Backstab, v36.Stealth) or ((15686 - 11012) < (4596 + 76))) then
				return "Cast Backstab (Stealth)";
			end
		end
		if (((3979 - (309 + 2)) < (14006 - 9445)) and v36.Gloomblade:IsAvailable()) then
			if ((not v150 and (v146 >= (1215 - (1090 + 122))) and v13:BuffUp(v36.ShadowBlades) and not v100(v36.Gloomblade) and v36.DanseMacabre:IsAvailable() and (v75 <= (2 + 2))) or ((1527 - 1072) == (2468 + 1137))) then
				if (v143 or ((3781 - (628 + 490)) == (594 + 2718))) then
					if (((10588 - 6311) <= (20450 - 15975)) and v144) then
						return v36.Gloomblade;
					else
						return {v36.Gloomblade,v36.Stealth};
					end
				elseif (v22(v36.Gloomblade, v36.Stealth) or ((2516 - 1646) == (940 + 249))) then
					return "Cast Gloomblade (Danse)";
				end
			end
		end
		if (((199 + 1354) <= (4828 - (556 + 1139))) and not v100(v36.Shadowstrike) and v13:BuffUp(v36.ShadowBlades)) then
			if (v143 or ((2252 - (6 + 9)) >= (643 + 2868))) then
				return v36.Shadowstrike;
			elseif (v19(v36.Shadowstrike) or ((679 + 645) > (3189 - (28 + 141)))) then
				return "Cast Shadowstrike (Danse)";
			end
		end
		if ((not v150 and (v75 >= (2 + 2))) or ((3692 - 700) == (1333 + 548))) then
			if (((4423 - (486 + 831)) > (3970 - 2444)) and v143) then
				return v36.ShurikenStorm;
			elseif (((10642 - 7619) < (732 + 3138)) and v19(v36.ShurikenStorm)) then
				return "Cast Shuriken Storm";
			end
		end
		if (((451 - 308) > (1337 - (668 + 595))) and v154) then
			if (((17 + 1) < (426 + 1686)) and v143) then
				return v36.Shadowstrike;
			elseif (((2991 - 1894) <= (1918 - (23 + 267))) and v19(v36.Shadowstrike)) then
				return "Cast Shadowstrike";
			end
		end
		return false;
	end
	local function v105(v155, v156)
		local v157 = v104(true, v155);
		if (((6574 - (1129 + 815)) == (5017 - (371 + 16))) and v43 and (v155:ID() == v36.Vanish:ID()) and (not v48 or not v157)) then
			local v175 = 1750 - (1326 + 424);
			while true do
				if (((6704 - 3164) > (9804 - 7121)) and (v175 == (118 - (88 + 30)))) then
					if (((5565 - (720 + 51)) >= (7285 - 4010)) and v19(v36.Vanish, nil)) then
						return "Cast Vanish";
					end
					return false;
				end
			end
		elseif (((3260 - (421 + 1355)) == (2447 - 963)) and (v155:ID() == v36.Shadowmeld:ID()) and (not v49 or not v157)) then
			local v203 = 0 + 0;
			while true do
				if (((2515 - (286 + 797)) < (12995 - 9440)) and (v203 == (0 - 0))) then
					if (v19(v36.Shadowmeld, nil) or ((1504 - (397 + 42)) > (1118 + 2460))) then
						return "Cast Shadowmeld";
					end
					return false;
				end
			end
		elseif (((v155:ID() == v36.ShadowDance:ID()) and (not v50 or not v157)) or ((5595 - (24 + 776)) < (2166 - 759))) then
			if (((2638 - (222 + 563)) < (10604 - 5791)) and v19(v36.ShadowDance, nil)) then
				return "Cast Shadow Dance";
			end
			return false;
		end
		local v158 = {v155,v157};
		if ((v156 and (v13:EnergyPredicted() < v156)) or ((4619 - (690 + 1108)) < (878 + 1553))) then
			v88(v158, v156);
			return false;
		end
		v77 = v22(unpack(v158));
		if (v77 or ((2371 + 503) < (3029 - (40 + 808)))) then
			return "| " .. v158[1 + 1]:Name();
		end
		return false;
	end
	local function v106()
		if ((not v13:IsCasting() and not v13:IsChanneling()) or ((10282 - 7593) <= (328 + 15))) then
			local v176 = 0 + 0;
			local v177;
			while true do
				if ((v176 == (0 + 0)) or ((2440 - (47 + 524)) == (1304 + 705))) then
					v177 = v33.Interrupt(v36.Kick, 21 - 13, true);
					if (v177 or ((5301 - 1755) < (5295 - 2973))) then
						return v177;
					end
					v177 = v33.Interrupt(v36.Kick, 1734 - (1165 + 561), true, MouseOver, v38.KickMouseover);
					v176 = 1 + 0;
				end
				if ((v176 == (6 - 4)) or ((795 + 1287) == (5252 - (341 + 138)))) then
					v177 = v33.Interrupt(v36.Blind, 5 + 10, BlindInterrupt, MouseOver, v38.BlindMouseover);
					if (((6694 - 3450) > (1381 - (89 + 237))) and v177) then
						return v177;
					end
					v177 = v33.InterruptWithStun(v36.CheapShot, 25 - 17, v13:StealthUp(false, false));
					v176 = 6 - 3;
				end
				if ((v176 == (882 - (581 + 300))) or ((4533 - (855 + 365)) <= (4222 - 2444))) then
					if (v177 or ((464 + 957) >= (3339 - (1030 + 205)))) then
						return v177;
					end
					v177 = v33.Interrupt(v36.Blind, 15 + 0, BlindInterrupt);
					if (((1686 + 126) <= (3535 - (156 + 130))) and v177) then
						return v177;
					end
					v176 = 4 - 2;
				end
				if (((2735 - 1112) <= (4007 - 2050)) and (v176 == (1 + 2))) then
					if (((2573 + 1839) == (4481 - (10 + 59))) and v177) then
						return v177;
					end
					v177 = v33.InterruptWithStun(v36.KidneyShot, 3 + 5, v13:ComboPoints() > (0 - 0));
					if (((2913 - (671 + 492)) >= (671 + 171)) and v177) then
						return v177;
					end
					break;
				end
			end
		end
		return false;
	end
	local function v107()
		local v159 = v33.HandleTopTrinket(v68, v41, 1255 - (369 + 846), nil);
		if (((1158 + 3214) > (1579 + 271)) and v159) then
			return v159;
		end
		local v159 = v33.HandleBottomTrinket(v68, v41, 1985 - (1036 + 909), nil);
		if (((185 + 47) < (1378 - 557)) and v159) then
			return v159;
		end
		return false;
	end
	local function v108()
		if (((721 - (11 + 192)) < (456 + 446)) and v41) then
			local v178 = 175 - (135 + 40);
			local v179;
			while true do
				if (((7254 - 4260) > (518 + 340)) and ((0 - 0) == v178)) then
					v179 = v33.HandleDPSPotion(v10.BossFilteredFightRemains("<", 44 - 14) or (v13:BuffUp(v36.SymbolsofDeath) and (v13:BuffUp(v36.ShadowBlades) or (v36.ShadowBlades:CooldownRemains() <= (186 - (50 + 126))))));
					if (v179 or ((10455 - 6700) <= (203 + 712))) then
						return v179;
					end
					break;
				end
			end
		end
		return false;
	end
	local function v109()
		if (((5359 - (1233 + 180)) > (4712 - (522 + 447))) and v41) then
			if ((v36.ArcaneTorrent:IsReady() and v71 and (v13:EnergyDeficitPredicted() >= ((1436 - (107 + 1314)) + v13:EnergyRegen())) and v53) or ((620 + 715) >= (10073 - 6767))) then
				if (((2058 + 2786) > (4473 - 2220)) and v19(v36.ArcaneTorrent, nil)) then
					return "Cast Arcane Torrent";
				end
			end
			if (((1788 - 1336) == (2362 - (716 + 1194))) and v36.ArcanePulse:IsReady() and v71 and v53) then
				if (v19(v36.ArcanePulse, nil) or ((78 + 4479) < (224 + 1863))) then
					return "Cast Arcane Pulse";
				end
			end
			if (((4377 - (74 + 429)) == (7472 - 3598)) and v36.BagofTricks:IsReady() and v53) then
				if (v19(v36.BagofTricks, nil) or ((961 + 977) > (11296 - 6361))) then
					return "Cast Bag of Tricks";
				end
			end
		end
		if ((v41 and v36.ColdBlood:IsReady() and not v36.SecretTechnique:IsAvailable() and (v84 >= (4 + 1))) or ((13117 - 8862) < (8463 - 5040))) then
			if (((1887 - (279 + 154)) <= (3269 - (454 + 324))) and v19(v36.ColdBlood, nil)) then
				return "Cast Cold Blood";
			end
		end
		if ((v41 and v36.Sepsis:IsAvailable() and v36.Sepsis:IsReady()) or ((3271 + 886) <= (2820 - (12 + 5)))) then
			if (((2617 + 2236) >= (7597 - 4615)) and v96() and v14:FilteredTimeToDie(">=", 6 + 10) and (v13:BuffUp(v36.PerforatedVeins) or not v36.PerforatedVeins:IsAvailable())) then
				if (((5227 - (277 + 816)) > (14344 - 10987)) and v19(v36.Sepsis, nil, nil)) then
					return "Cast Sepsis";
				end
			end
		end
		if ((v41 and v36.Flagellation:IsAvailable() and v36.Flagellation:IsReady()) or ((4600 - (1058 + 125)) < (476 + 2058))) then
			if ((v96() and (v83 >= (980 - (815 + 160))) and (v14:TimeToDie() > (42 - 32)) and ((v102() and (v36.ShadowBlades:CooldownRemains() <= (7 - 4))) or v10.BossFilteredFightRemains("<=", 7 + 21) or ((v36.ShadowBlades:CooldownRemains() >= (40 - 26)) and v36.InvigoratingShadowdust:IsAvailable() and v36.ShadowDance:IsAvailable())) and (not v36.InvigoratingShadowdust:IsAvailable() or v36.Sepsis:IsAvailable() or not v36.ShadowDance:IsAvailable() or ((v36.InvigoratingShadowdust:TalentRank() == (1900 - (41 + 1857))) and (v75 >= (1895 - (1222 + 671)))) or (v36.SymbolsofDeath:CooldownRemains() <= (7 - 4)) or (v13:BuffRemains(v36.SymbolsofDeath) > (3 - 0)))) or ((3904 - (229 + 953)) <= (1938 - (1111 + 663)))) then
				if (v19(v36.Flagellation, nil, nil) or ((3987 - (874 + 705)) < (296 + 1813))) then
					return "Cast Flagellation";
				end
			end
		end
		if ((v41 and v36.SymbolsofDeath:IsReady()) or ((23 + 10) == (3024 - 1569))) then
			if ((v96() and (not v13:BuffUp(v36.TheRotten) or not v13:HasTier(1 + 29, 681 - (642 + 37))) and (v13:BuffRemains(v36.SymbolsofDeath) <= (1 + 2)) and (not v36.Flagellation:IsAvailable() or (v36.Flagellation:CooldownRemains() > (2 + 8)) or ((v13:BuffRemains(v36.ShadowDance) >= (4 - 2)) and v36.InvigoratingShadowdust:IsAvailable()) or (v36.Flagellation:IsReady() and (v83 >= (459 - (233 + 221))) and not v36.InvigoratingShadowdust:IsAvailable()))) or ((1024 - 581) >= (3534 + 481))) then
				if (((4923 - (718 + 823)) > (105 + 61)) and v19(v36.SymbolsofDeath, nil)) then
					return "Cast Symbols of Death";
				end
			end
		end
		if ((v41 and v36.ShadowBlades:IsReady()) or ((1085 - (266 + 539)) == (8660 - 5601))) then
			if (((3106 - (636 + 589)) > (3068 - 1775)) and v96() and ((v83 <= (1 - 0)) or v13:HasTier(25 + 6, 2 + 2)) and (v13:BuffUp(v36.Flagellation) or v13:BuffUp(v36.FlagellationPersistBuff) or not v36.Flagellation:IsAvailable())) then
				if (((3372 - (657 + 358)) == (6240 - 3883)) and v19(v36.ShadowBlades, nil)) then
					return "Cast Shadow Blades";
				end
			end
		end
		if (((280 - 157) == (1310 - (1151 + 36))) and v41 and v36.EchoingReprimand:IsCastable() and v36.EchoingReprimand:IsAvailable()) then
			if ((v96() and (v85 >= (3 + 0))) or ((278 + 778) >= (10129 - 6737))) then
				if (v19(v36.EchoingReprimand, nil, nil) or ((2913 - (1552 + 280)) < (1909 - (64 + 770)))) then
					return "Cast Echoing Reprimand";
				end
			end
		end
		if ((v41 and v67 and v36.ShurikenTornado:IsAvailable() and v36.ShurikenTornado:IsReady()) or ((713 + 336) >= (10060 - 5628))) then
			if ((v96() and v13:BuffUp(v36.SymbolsofDeath) and (v83 <= (1 + 1)) and not v13:BuffUp(v36.Premeditation) and (not v36.Flagellation:IsAvailable() or (v36.Flagellation:CooldownRemains() > (1263 - (157 + 1086)))) and (v75 >= (5 - 2))) or ((20882 - 16114) <= (1297 - 451))) then
				if (v19(v36.ShurikenTornado, nil) or ((4582 - 1224) <= (2239 - (599 + 220)))) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if ((v41 and v67 and v36.ShurikenTornado:IsAvailable() and v36.ShurikenTornado:IsReady()) or ((7445 - 3706) <= (4936 - (1813 + 118)))) then
			if ((v96() and not v13:BuffUp(v36.ShadowDance) and not v13:BuffUp(v36.Flagellation) and not v13:BuffUp(v36.FlagellationPersistBuff) and not v13:BuffUp(v36.ShadowBlades) and (v75 <= (2 + 0))) or ((2876 - (841 + 376)) >= (2990 - 856))) then
				if (v19(v36.ShurikenTornado, nil) or ((758 + 2502) < (6428 - 4073))) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if ((v41 and v36.ShadowDance:IsAvailable() and v90() and v36.ShadowDance:IsReady()) or ((1528 - (464 + 395)) == (10837 - 6614))) then
			if ((not v13:BuffUp(v36.ShadowDance) and v10.BossFilteredFightRemains("<=", 4 + 4 + ((840 - (467 + 370)) * v26(v36.Subterfuge:IsAvailable())))) or ((3496 - 1804) < (432 + 156))) then
				if (v19(v36.ShadowDance) or ((16443 - 11646) < (570 + 3081))) then
					return "Cast Shadow Dance";
				end
			end
		end
		if ((v41 and v36.GoremawsBite:IsAvailable() and v36.GoremawsBite:IsReady()) or ((9717 - 5540) > (5370 - (150 + 370)))) then
			if ((v96() and (v85 >= (1285 - (74 + 1208))) and (not v36.ShadowDance:IsReady() or (v36.ShadowDance:IsAvailable() and v13:BuffUp(v36.ShadowDance) and not v36.InvigoratingShadowdust:IsAvailable()) or ((v75 < (9 - 5)) and not v36.InvigoratingShadowdust:IsAvailable()) or v36.TheRotten:IsAvailable())) or ((1897 - 1497) > (791 + 320))) then
				if (((3441 - (14 + 376)) > (1743 - 738)) and v19(v36.GoremawsBite)) then
					return "Cast Goremaw's Bite";
				end
			end
		end
		if (((2390 + 1303) <= (3850 + 532)) and v36.ThistleTea:IsReady()) then
			if ((((v36.SymbolsofDeath:CooldownRemains() >= (3 + 0)) or v13:BuffUp(v36.SymbolsofDeath)) and not v13:BuffUp(v36.ThistleTea) and (((v13:EnergyDeficitPredicted() >= (293 - 193)) and ((v85 >= (2 + 0)) or (v75 >= (81 - (23 + 55))))) or ((v36.ThistleTea:ChargesFractional() >= ((4.75 - 2) - ((0.15 + 0) * v36.InvigoratingShadowdust:TalentRank()))) and (v36.Vanish:IsReady() or not v43) and v13:BuffUp(v36.ShadowDance) and v14:DebuffUp(v36.Rupture) and (v75 < (3 + 0))))) or ((v13:BuffRemains(v36.ShadowDance) >= (5 - 1)) and not v13:BuffUp(v36.ThistleTea) and (v75 >= (1 + 2))) or (not v13:BuffUp(v36.ThistleTea) and v10.BossFilteredFightRemains("<=", (907 - (652 + 249)) * v36.ThistleTea:Charges())) or ((8782 - 5500) > (5968 - (708 + 1160)))) then
				if (v19(v36.ThistleTea, nil, nil) or ((9717 - 6137) < (5184 - 2340))) then
					return "Thistle Tea";
				end
			end
		end
		local v160 = v13:BuffUp(v36.ShadowBlades) or (not v36.ShadowBlades:IsAvailable() and v13:BuffUp(v36.SymbolsofDeath)) or v10.BossFilteredFightRemains("<", 47 - (10 + 17));
		if (((20 + 69) < (6222 - (1400 + 332))) and v36.BloodFury:IsCastable() and v160 and v53) then
			if (v19(v36.BloodFury, nil) or ((9557 - 4574) < (3716 - (242 + 1666)))) then
				return "Cast Blood Fury";
			end
		end
		if (((1639 + 2190) > (1382 + 2387)) and v36.Berserking:IsCastable() and v160 and v53) then
			if (((1266 + 219) <= (3844 - (850 + 90))) and v19(v36.Berserking, nil)) then
				return "Cast Berserking";
			end
		end
		if (((7476 - 3207) == (5659 - (360 + 1030))) and v36.Fireblood:IsCastable() and v160 and v53) then
			if (((343 + 44) <= (7851 - 5069)) and v19(v36.Fireblood, nil)) then
				return "Cast Fireblood";
			end
		end
		if ((v36.AncestralCall:IsCastable() and v160 and v53) or ((2612 - 713) <= (2578 - (909 + 752)))) then
			if (v19(v36.AncestralCall, nil) or ((5535 - (109 + 1114)) <= (1603 - 727))) then
				return "Cast Ancestral Call";
			end
		end
		if (((869 + 1363) <= (2838 - (6 + 236))) and v36.ThistleTea:IsReady()) then
			if (((1320 + 775) < (2967 + 719)) and ((((v36.SymbolsofDeath:CooldownRemains() >= (6 - 3)) or v13:BuffUp(v36.SymbolsofDeath)) and not v13:BuffUp(v36.ThistleTea) and (((v13:EnergyDeficitPredicted() >= (174 - 74)) and ((v13:ComboPointsDeficit() >= (1135 - (1076 + 57))) or (v75 >= (1 + 2)))) or ((v36.ThistleTea:ChargesFractional() >= (691.75 - (579 + 110))) and v13:BuffUp(v36.ShadowDanceBuff)))) or ((v13:BuffRemains(v36.ShadowDanceBuff) >= (1 + 3)) and not v13:BuffUp(v36.ThistleTea) and (v75 >= (3 + 0))) or (not v13:BuffUp(v36.ThistleTea) and v10.BossFilteredFightRemains("<=", (4 + 2) * v36.ThistleTea:Charges())))) then
				if (v19(v36.ThistleTea, nil, nil) or ((2002 - (174 + 233)) >= (12497 - 8023))) then
					return "Thistle Tea";
				end
			end
		end
		return false;
	end
	local function v110(v161)
		if ((v41 and not (v33.IsSoloMode() and v13:IsTanking(v14))) or ((8106 - 3487) < (1282 + 1600))) then
			local v180 = 1174 - (663 + 511);
			while true do
				if ((v180 == (0 + 0)) or ((64 + 230) >= (14893 - 10062))) then
					if (((1229 + 800) <= (7260 - 4176)) and v43 and v36.Vanish:IsCastable()) then
						if ((((v85 > (2 - 1)) or (v13:BuffUp(v36.ShadowBlades) and v36.InvigoratingShadowdust:IsAvailable())) and not v94() and ((v36.Flagellation:CooldownRemains() >= (29 + 31)) or not v36.Flagellation:IsAvailable() or v10.BossFilteredFightRemains("<=", (58 - 28) * v36.Vanish:Charges())) and ((v36.SymbolsofDeath:CooldownRemains() > (3 + 0)) or not v13:HasTier(3 + 27, 724 - (478 + 244))) and ((v36.SecretTechnique:CooldownRemains() >= (527 - (440 + 77))) or not v36.SecretTechnique:IsAvailable() or ((v36.Vanish:Charges() >= (1 + 1)) and v36.InvigoratingShadowdust:IsAvailable() and (v13:BuffUp(v36.TheRotten) or not v36.TheRotten:IsAvailable())))) or ((7455 - 5418) == (3976 - (655 + 901)))) then
							local v226 = 0 + 0;
							while true do
								if (((3413 + 1045) > (2637 + 1267)) and (v226 == (0 - 0))) then
									v77 = v105(v36.Vanish, v161);
									if (((1881 - (695 + 750)) >= (419 - 296)) and v77) then
										return "Vanish Macro " .. v77;
									end
									break;
								end
							end
						end
					end
					if (((771 - 271) < (7303 - 5487)) and v53 and v51 and (v13:Energy() < (391 - (285 + 66))) and v36.Shadowmeld:IsCastable()) then
						if (((8330 - 4756) == (4884 - (682 + 628))) and v21(v36.Shadowmeld, v13:EnergyTimeToX(7 + 33))) then
							return "Pool for Shadowmeld";
						end
					end
					v180 = 300 - (176 + 123);
				end
				if (((93 + 128) < (283 + 107)) and (v180 == (270 - (239 + 30)))) then
					if ((v53 and v36.Shadowmeld:IsCastable() and v71 and not v13:IsMoving() and (v13:EnergyPredicted() >= (11 + 29)) and (v13:EnergyDeficitPredicted() >= (10 + 0)) and not v94() and (v85 > (6 - 2))) or ((6903 - 4690) <= (1736 - (306 + 9)))) then
						local v216 = 0 - 0;
						while true do
							if (((532 + 2526) < (2982 + 1878)) and ((0 + 0) == v216)) then
								v77 = v105(v36.Shadowmeld, v161);
								if (v77 or ((3705 - 2409) >= (5821 - (1140 + 235)))) then
									return "Shadowmeld Macro " .. v77;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
		if ((v71 and v36.ShadowDance:IsCastable()) or ((887 + 506) > (4117 + 372))) then
			if (((v14:DebuffUp(v36.Rupture) or v36.InvigoratingShadowdust:IsAvailable()) and v99() and (not v36.TheFirstDance:IsAvailable() or (v85 >= (2 + 2)) or v13:BuffUp(v36.ShadowBlades)) and ((v95() and v94()) or ((v13:BuffUp(v36.ShadowBlades) or (v13:BuffUp(v36.SymbolsofDeath) and not v36.Sepsis:IsAvailable()) or ((v13:BuffRemains(v36.SymbolsofDeath) >= (56 - (33 + 19))) and not v13:HasTier(11 + 19, 5 - 3)) or (not v13:BuffUp(v36.SymbolsofDeath) and v13:HasTier(14 + 16, 3 - 1))) and (v36.SecretTechnique:CooldownRemains() < (10 + 0 + ((701 - (586 + 103)) * v26(not v36.InvigoratingShadowdust:IsAvailable() or v13:HasTier(3 + 27, 5 - 3)))))))) or ((5912 - (1309 + 179)) < (48 - 21))) then
				local v204 = 0 + 0;
				while true do
					if ((v204 == (0 - 0)) or ((1509 + 488) > (8105 - 4290))) then
						v77 = v105(v36.ShadowDance, v161);
						if (((6904 - 3439) > (2522 - (295 + 314))) and v77) then
							return "ShadowDance Macro 1 " .. v77;
						end
						break;
					end
				end
			end
		end
		return false;
	end
	local function v111(v162)
		local v163 = 0 - 0;
		local v164;
		while true do
			if (((2695 - (1300 + 662)) < (5711 - 3892)) and ((1755 - (1178 + 577)) == v163)) then
				v164 = not v162 or (v13:EnergyPredicted() >= v162);
				if ((v40 and v36.ShurikenStorm:IsCastable() and (v75 >= (2 + 0 + v18((v36.Gloomblade:IsAvailable() and (v13:BuffRemains(v36.LingeringShadowBuff) >= (17 - 11))) or v13:BuffUp(v36.PerforatedVeinsBuff))))) or ((5800 - (851 + 554)) == (4205 + 550))) then
					local v208 = 0 - 0;
					while true do
						if ((v208 == (0 - 0)) or ((4095 - (115 + 187)) < (1815 + 554))) then
							if ((v164 and v19(v36.ShurikenStorm)) or ((3867 + 217) == (1044 - 779))) then
								return "Cast Shuriken Storm";
							end
							v88(v36.ShurikenStorm, v162);
							break;
						end
					end
				end
				v163 = 1162 - (160 + 1001);
			end
			if (((3813 + 545) == (3007 + 1351)) and (v163 == (1 - 0))) then
				if (v71 or ((3496 - (237 + 121)) < (1890 - (525 + 372)))) then
					if (((6313 - 2983) > (7632 - 5309)) and v36.Gloomblade:IsCastable()) then
						if ((v164 and v19(v36.Gloomblade)) or ((3768 - (96 + 46)) == (4766 - (643 + 134)))) then
							return "Cast Gloomblade";
						end
						v88(v36.Gloomblade, v162);
					elseif (v36.Backstab:IsCastable() or ((331 + 585) == (6404 - 3733))) then
						if (((1009 - 737) == (261 + 11)) and v164 and v19(v36.Backstab)) then
							return "Cast Backstab";
						end
						v88(v36.Backstab, v162);
					end
				end
				return false;
			end
		end
	end
	local function v112()
		local v165 = 0 - 0;
		while true do
			if (((8685 - 4436) <= (5558 - (316 + 403))) and (v165 == (0 + 0))) then
				if (((7634 - 4857) < (1157 + 2043)) and v57 and v42 and v36.Shiv:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v33.UnitHasEnrageBuff(v14)) then
					if (((239 - 144) < (1387 + 570)) and v24(v36.Shiv, not IsInMeleeRange)) then
						return "shiv dispel enrage";
					end
				end
				if (((267 + 559) < (5949 - 4232)) and v37.Healthstone:IsReady() and v58 and (v13:HealthPercentage() <= v59)) then
					if (((6810 - 5384) >= (2295 - 1190)) and v24(v38.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				v165 = 1 + 0;
			end
			if (((5420 - 2666) <= (166 + 3213)) and (v165 == (2 - 1))) then
				if ((v54 and (v13:HealthPercentage() <= v56)) or ((3944 - (12 + 5)) == (5487 - 4074))) then
					if ((v55 == "Refreshing Healing Potion") or ((2462 - 1308) <= (1674 - 886))) then
						if (v37.RefreshingHealingPotion:IsReady() or ((4074 - 2431) > (686 + 2693))) then
							if (v24(v38.RefreshingHealingPotion, nil, nil, true) or ((4776 - (1656 + 317)) > (4054 + 495))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v55 == "Dreamwalker's Healing Potion") or ((177 + 43) >= (8035 - 5013))) then
						if (((13888 - 11066) == (3176 - (5 + 349))) and v37.DreamwalkersHealingPotion:IsReady()) then
							if (v24(v38.RefreshingHealingPotion, nil, nil, true) or ((5039 - 3978) == (3128 - (266 + 1005)))) then
								return "dreamwalker's healing potion defensive 4";
							end
						end
					end
				end
				return false;
			end
		end
	end
	local function v113()
		if (((1819 + 941) > (4654 - 3290)) and not v13:AffectingCombat() and v39) then
			if ((v36.Stealth:IsCastable() and (v65 == "Always")) or ((6453 - 1551) <= (5291 - (561 + 1135)))) then
				local v205 = 0 - 0;
				while true do
					if ((v205 == (0 - 0)) or ((4918 - (507 + 559)) == (735 - 442))) then
						v77 = v34.Stealth(v34.StealthSpell());
						if (v77 or ((4821 - 3262) == (4976 - (212 + 176)))) then
							return v77;
						end
						break;
					end
				end
			elseif ((v36.Stealth:IsCastable() and (v65 == "Distance") and v14:IsInRange(v66)) or ((5389 - (250 + 655)) == (2148 - 1360))) then
				v77 = v34.Stealth(v34.StealthSpell());
				if (((7981 - 3413) >= (6112 - 2205)) and v77) then
					return v77;
				end
			end
			if (((3202 - (1869 + 87)) < (12035 - 8565)) and not v13:BuffUp(v36.ShadowDanceBuff) and not v13:BuffUp(v34.VanishBuffSpell())) then
				v77 = v34.Stealth(v34.StealthSpell());
				if (((5969 - (484 + 1417)) >= (2083 - 1111)) and v77) then
					return v77;
				end
			end
			if (((825 - 332) < (4666 - (48 + 725))) and v33.TargetIsValid() and (v14:IsSpellInRange(v36.Shadowstrike) or v71)) then
				if (v13:StealthUp(true, true) or ((2405 - 932) >= (8939 - 5607))) then
					v78 = v104(true);
					if (v78 or ((2355 + 1696) <= (3091 - 1934))) then
						if (((170 + 434) < (840 + 2041)) and (type(v78) == "table") and (#v78 > (854 - (152 + 701)))) then
							if (v25(nil, unpack(v78)) or ((2211 - (430 + 881)) == (1294 + 2083))) then
								return "Stealthed Macro Cast or Pool (OOC): " .. v78[896 - (557 + 338)]:Name();
							end
						elseif (((1318 + 3141) > (1665 - 1074)) and v21(v78)) then
							return "Stealthed Cast or Pool (OOC): " .. v78:Name();
						end
					end
				elseif (((11898 - 8500) >= (6362 - 3967)) and (v84 >= (10 - 5))) then
					local v224 = 801 - (499 + 302);
					while true do
						if ((v224 == (866 - (39 + 827))) or ((6025 - 3842) >= (6306 - 3482))) then
							v77 = v103();
							if (((7689 - 5753) == (2971 - 1035)) and v77) then
								return v77 .. " (OOC)";
							end
							break;
						end
					end
				elseif (v36.Backstab:IsCastable() or ((414 + 4418) < (12623 - 8310))) then
					if (((654 + 3434) > (6129 - 2255)) and v19(v36.Backstab)) then
						return "Cast Backstab (OOC)";
					end
				end
			end
			return;
		end
	end
	local v114 = {{v36.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v36.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v84 > (1204 - (7 + 1197));
	end},{v36.CheapShot,"Cast Cheap Shot (Interrupt)",function()
		return v13:StealthUp(true, true);
	end}};
	local function v115()
		v39 = EpicSettings.Toggles['ooc'];
		v40 = EpicSettings.Toggles['aoe'];
		v41 = EpicSettings.Toggles['cds'];
		v42 = EpicSettings.Toggles['dispel'];
		v43 = EpicSettings.Toggles['vanish'];
		v44 = EpicSettings.Toggles['funnel'];
	end
	local function v116()
		local v172 = 0 - 0;
		while true do
			if (((18167 - 13835) == (8542 - 4210)) and (v172 == (1 - 0))) then
				v48 = EpicSettings.Settings['StealthMacroVanish'];
				v49 = EpicSettings.Settings['StealthMacroShadowmeld'];
				v50 = EpicSettings.Settings['StealthMacroShadowDance'];
				v172 = 141 - (43 + 96);
			end
			if (((16312 - 12313) >= (6556 - 3656)) and (v172 == (2 + 0))) then
				v51 = EpicSettings.Settings['PoolForShadowmeld'];
				v52 = EpicSettings.Settings['EviscerateDMGOffset'] or (1 + 0);
				v53 = EpicSettings.Settings['UseRacials'];
				v172 = 5 - 2;
			end
			if ((v172 == (3 + 4)) or ((4732 - 2207) > (1280 + 2784))) then
				v65 = EpicSettings.Settings['UsageStealthOOC'];
				v66 = EpicSettings.Settings['StealthRange'] or (0 + 0);
				break;
			end
			if (((6122 - (1414 + 337)) == (6311 - (1642 + 298))) and (v172 == (0 - 0))) then
				v45 = EpicSettings.Settings['BurnShadowDance'];
				v46 = EpicSettings.Settings['UsePriorityRotation'];
				v47 = EpicSettings.Settings['RangedMultiDoT'];
				v172 = 2 - 1;
			end
			if ((v172 == (17 - 11)) or ((88 + 178) > (3880 + 1106))) then
				v63 = EpicSettings.Settings['AutoFocusTank'];
				v64 = EpicSettings.Settings['AutoTricksTank'];
				v67 = EpicSettings.Settings['UseShurikenTornado'];
				v172 = 979 - (357 + 615);
			end
			if (((1398 + 593) >= (2269 - 1344)) and (v172 == (3 + 0))) then
				v54 = EpicSettings.Settings['UseHealingPotion'];
				v55 = EpicSettings.Settings['HealingPotionName'];
				v56 = EpicSettings.Settings['HealingPotionHP'] or (2 - 1);
				v172 = 4 + 0;
			end
			if (((31 + 424) < (1291 + 762)) and ((1306 - (384 + 917)) == v172)) then
				v60 = EpicSettings.Settings['InterruptWithStun'];
				v61 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v62 = EpicSettings.Settings['InterruptThreshold'];
				v172 = 703 - (128 + 569);
			end
			if ((v172 == (1547 - (1407 + 136))) or ((2713 - (687 + 1200)) == (6561 - (556 + 1154)))) then
				v57 = EpicSettings.Settings['DispelBuffs'];
				v58 = EpicSettings.Settings['UseHealthstone'];
				v59 = EpicSettings.Settings['HealthstoneHP'] or (3 - 2);
				v172 = 100 - (9 + 86);
			end
		end
	end
	local function v117()
		local v173 = 421 - (275 + 146);
		while true do
			if (((30 + 153) == (247 - (29 + 35))) and (v173 == (22 - 17))) then
				if (((3461 - 2302) <= (7893 - 6105)) and v13:BuffUp(v36.ShurikenTornado, nil, true) and (v84 < v34.CPMaxSpend())) then
					local v209 = v34.TimeToNextTornado();
					if ((v209 <= v13:GCDRemains()) or (v32(v13:GCDRemains() - v209) < (0.25 + 0)) or ((4519 - (53 + 959)) > (4726 - (312 + 96)))) then
						local v217 = 0 - 0;
						local v218;
						while true do
							if ((v217 == (285 - (147 + 138))) or ((3974 - (813 + 86)) <= (2680 + 285))) then
								v218 = v75 + v26(v13:BuffUp(v36.ShadowBlades));
								v84 = v30(v84 + v218, v34.CPMaxSpend());
								v217 = 1 - 0;
							end
							if (((1857 - (18 + 474)) <= (679 + 1332)) and (v217 == (3 - 2))) then
								v85 = v31(v85 - v218, 1086 - (860 + 226));
								if ((v83 < v34.CPMaxSpend()) or ((3079 - (121 + 182)) > (441 + 3134))) then
									v83 = v84;
								end
								break;
							end
						end
					end
				end
				v81 = ((1244 - (988 + 252)) + (v83 * (1 + 3))) * (0.3 + 0);
				v82 = v36.Eviscerate:Damage() * v52;
				v173 = 1976 - (49 + 1921);
			end
			if ((v173 == (890 - (223 + 667))) or ((2606 - (51 + 1)) == (8268 - 3464))) then
				v116();
				v115();
				v78 = nil;
				v173 = 1 - 0;
			end
			if (((3702 - (146 + 979)) == (728 + 1849)) and (v173 == (614 - (311 + 294)))) then
				if (v33.TargetIsValid() or ((16 - 10) >= (801 + 1088))) then
					v77 = v106();
					if (((1949 - (496 + 947)) <= (3250 - (1233 + 125))) and ShoulReturn) then
						return "Interrupts " .. v77;
					end
					v77 = v112();
					if (ShoulReturn or ((815 + 1193) > (1990 + 228))) then
						return v77;
					end
					v77 = v109();
					if (((73 + 306) <= (5792 - (963 + 682))) and v77) then
						return "CDs: " .. v77;
					end
					v77 = v107();
					if (v77 or ((3768 + 746) <= (2513 - (504 + 1000)))) then
						return "Trinkets";
					end
					v77 = v108();
					if (v77 or ((2355 + 1141) == (1086 + 106))) then
						return "DPS Potion";
					end
					if ((v36.SliceandDice:IsCastable() and (v75 < v34.CPMaxSpend()) and (v13:BuffRemains(v36.SliceandDice) < v13:GCD()) and v10.BossFilteredFightRemains(">", 1 + 5) and (v84 >= (5 - 1))) or ((178 + 30) == (1721 + 1238))) then
						if (((4459 - (156 + 26)) >= (757 + 556)) and v36.SliceandDice:IsReady() and v19(v36.SliceandDice)) then
							return "Cast Slice and Dice (Low Duration)";
						end
						v89(v36.SliceandDice);
					end
					if (((4047 - 1460) < (3338 - (149 + 15))) and v13:StealthUp(true, true)) then
						v78 = v104(true);
						if (v78 or ((5080 - (890 + 70)) <= (2315 - (39 + 78)))) then
							if (((type(v78) == "table") and (#v78 > (483 - (14 + 468)))) or ((3509 - 1913) == (2398 - 1540))) then
								if (((1662 + 1558) == (1934 + 1286)) and v25(nil, unpack(v78))) then
									return "Stealthed Macro " .. v78[1 + 0]:Name() .. "|" .. v78[1 + 1]:Name();
								end
							elseif ((v67 and v13:BuffUp(v36.ShurikenTornado) and (v84 ~= v13:ComboPoints()) and ((v78 == v36.BlackPowder) or (v78 == v36.Eviscerate) or (v78 == v36.Rupture) or (v78 == v36.SliceandDice))) or ((368 + 1034) > (6929 - 3309))) then
								if (((2545 + 29) == (9044 - 6470)) and v25(nil, v36.ShurikenTornado, v78)) then
									return "Stealthed Tornado Cast  " .. v78:Name();
								end
							elseif (((46 + 1752) < (2808 - (12 + 39))) and (type(v78) ~= "boolean")) then
								if (v21(v78) or ((351 + 26) > (8060 - 5456))) then
									return "Stealthed Cast " .. v78:Name();
								end
							end
						end
						v19(v36.PoolEnergy);
						return "Stealthed Pooling";
					end
					local v210;
					if (((2022 - 1454) < (271 + 640)) and (not v36.Vigor:IsAvailable() or v36.Shadowcraft:IsAvailable())) then
						v210 = v13:EnergyDeficitPredicted() <= v93();
					else
						v210 = v13:EnergyPredicted() >= v93();
					end
					if (((1730 + 1555) < (10721 - 6493)) and (v210 or v36.InvigoratingShadowdust:IsAvailable())) then
						local v219 = 0 + 0;
						while true do
							if (((18925 - 15009) > (5038 - (1596 + 114))) and (v219 == (0 - 0))) then
								v77 = v110(v86);
								if (((3213 - (164 + 549)) < (5277 - (1059 + 379))) and v77) then
									return "Stealth CDs: " .. v77;
								end
								break;
							end
						end
					end
					if (((629 - 122) == (263 + 244)) and (v83 >= v34.CPMaxSpend())) then
						local v220 = 0 + 0;
						while true do
							if (((632 - (145 + 247)) <= (2598 + 567)) and (v220 == (0 + 0))) then
								v77 = v103();
								if (((2472 - 1638) >= (155 + 650)) and v77) then
									return "Finish: " .. v77;
								end
								break;
							end
						end
					end
					if ((v85 <= (1 + 0)) or (v10.BossFilteredFightRemains("<=", 1 - 0) and (v83 >= (723 - (254 + 466)))) or ((4372 - (544 + 16)) < (7360 - 5044))) then
						local v221 = 628 - (294 + 334);
						while true do
							if ((v221 == (253 - (236 + 17))) or ((1144 + 1508) <= (1194 + 339))) then
								v77 = v103();
								if (v77 or ((13550 - 9952) < (6912 - 5452))) then
									return "Finish: " .. v77;
								end
								break;
							end
						end
					end
					if (((v75 >= (3 + 1)) and (v83 >= (4 + 0))) or ((4910 - (413 + 381)) < (51 + 1141))) then
						v77 = v103();
						if (v77 or ((7182 - 3805) <= (2345 - 1442))) then
							return "Finish: " .. v77;
						end
					end
					if (((5946 - (582 + 1388)) >= (747 - 308)) and v80) then
						v88(v80);
					end
					v77 = v111(v86);
					if (((2686 + 1066) == (4116 - (326 + 38))) and v77) then
						return "Build: " .. v77;
					end
					if (((11968 - 7922) > (3847 - 1152)) and v78 and v71) then
						if (((type(v78) == "table") and (#v78 > (621 - (47 + 573)))) or ((1250 + 2295) == (13577 - 10380))) then
							if (((3884 - 1490) > (2037 - (1269 + 395))) and v25(v13:EnergyTimeToX(v79), unpack(v78))) then
								return "Macro pool towards " .. v78[493 - (76 + 416)]:Name() .. " at " .. v79;
							end
						elseif (((4598 - (319 + 124)) <= (9673 - 5441)) and v78:IsCastable()) then
							v79 = v31(v79, v78:Cost());
							if (v21(v78, v13:EnergyTimeToX(v79)) or ((4588 - (564 + 443)) == (9614 - 6141))) then
								return "Pool towards: " .. v78:Name() .. " at " .. v79;
							end
						end
					end
					if (((5453 - (337 + 121)) > (9809 - 6461)) and v36.ShurikenToss:IsCastable() and v14:IsInRange(99 - 69) and not v72 and not v13:StealthUp(true, true) and not v13:BuffUp(v36.Sprint) and (v13:EnergyDeficitPredicted() < (1931 - (1261 + 650))) and ((v85 >= (1 + 0)) or (v13:EnergyTimeToMax() <= (1.2 - 0)))) then
						if (v21(v36.ShurikenToss) or ((2571 - (772 + 1045)) > (526 + 3198))) then
							return "Cast Shuriken Toss";
						end
					end
				end
				break;
			end
			if (((361 - (102 + 42)) >= (1901 - (1524 + 320))) and (v173 == (1271 - (1049 + 221)))) then
				v80 = nil;
				v79 = 156 - (18 + 138);
				v69 = (v36.AcrobaticStrikes:IsAvailable() and (19 - 11)) or (1107 - (67 + 1035));
				v173 = 350 - (136 + 212);
			end
			if ((v173 == (12 - 9)) or ((1659 + 411) >= (3722 + 315))) then
				if (((4309 - (240 + 1364)) == (3787 - (1050 + 32))) and v40) then
					local v211 = 0 - 0;
					while true do
						if (((37 + 24) == (1116 - (331 + 724))) and (v211 == (1 + 0))) then
							v75 = #v74;
							v76 = v13:GetEnemiesInMeleeRange(v69);
							break;
						end
						if ((v211 == (644 - (269 + 375))) or ((1424 - (267 + 458)) >= (404 + 892))) then
							v73 = v13:GetEnemiesInRange(57 - 27);
							v74 = v13:GetEnemiesInMeleeRange(v70);
							v211 = 819 - (667 + 151);
						end
					end
				else
					v73 = {};
					v74 = {};
					v75 = 1498 - (1410 + 87);
					v76 = {};
				end
				v84 = v13:ComboPoints();
				v83 = v34.EffectiveComboPoints(v84);
				v173 = 1901 - (1504 + 393);
			end
			if ((v173 == (21 - 13)) or ((4625 - 2842) >= (4412 - (461 + 335)))) then
				v34.Poisons();
				v77 = v113();
				if (v77 or ((501 + 3412) > (6288 - (1730 + 31)))) then
					return v77;
				end
				v173 = 1676 - (728 + 939);
			end
			if (((15498 - 11122) > (1657 - 840)) and (v173 == (13 - 7))) then
				if (((5929 - (138 + 930)) > (753 + 71)) and not v13:AffectingCombat() and v63) then
					local v212 = v33.FocusUnit(false, nil, nil, "TANK", 16 + 4);
					if (v212 or ((1186 + 197) >= (8701 - 6570))) then
						return v212;
					end
				end
				if ((v23 and v64 and (v33.UnitGroupRole(v23) == "TANK") and v36.TricksoftheTrade:IsCastable()) or ((3642 - (459 + 1307)) >= (4411 - (474 + 1396)))) then
					if (((3111 - 1329) <= (3536 + 236)) and v24(v38.TricksoftheTradeFocus)) then
						return "tricks of the trade tank";
					end
				end
				v77 = v34.CrimsonVial();
				v173 = 1 + 6;
			end
			if ((v173 == (5 - 3)) or ((596 + 4104) < (2713 - 1900))) then
				v70 = (v36.AcrobaticStrikes:IsAvailable() and (56 - 43)) or (601 - (562 + 29));
				v71 = v14:IsInMeleeRange(v69);
				v72 = v14:IsInMeleeRange(v70);
				v173 = 3 + 0;
			end
			if (((4618 - (374 + 1045)) < (3206 + 844)) and (v173 == (12 - 8))) then
				v85 = v13:ComboPointsDeficit();
				v87 = v91();
				v86 = v13:EnergyMax() - v93();
				v173 = 643 - (448 + 190);
			end
			if (((3 + 4) == v173) or ((2235 + 2716) < (2887 + 1543))) then
				if (((369 - 273) == (297 - 201)) and v77) then
					return v77;
				end
				v77 = v34.Feint();
				if (v77 or ((4233 - (1307 + 187)) > (15893 - 11885))) then
					return v77;
				end
				v173 = 18 - 10;
			end
		end
	end
	local function v118()
		v10.Print("Subtlety Rogue by Epic BoomK");
		EpicSettings.SetupVersion("Subtlety Rogue  X v 10.2.5.04 By BoomK");
	end
	v10.SetAPL(800 - 539, v117, v118);
end;
return v0["Epix_Rogue_Subtlety.lua"]();

