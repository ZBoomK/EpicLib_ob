local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((5325 - (364 + 97)) > (10942 - 8745)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((13437 - 9737) == (891 + 1616))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((13276 - 8802) >= (150 + 124)) and (v5 == (1 - 0))) then
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
	local v23 = v10.CastQueuePooling;
	local v24 = v10.Commons.Everyone.num;
	local v25 = v10.Commons.Everyone.bool;
	local v26 = pairs;
	local v27 = table.insert;
	local v28 = math.min;
	local v29 = math.max;
	local v30 = math.abs;
	local v31 = v10.Commons.Everyone;
	local v32 = v10.Commons.Rogue;
	local v33 = v10.Macro;
	local v34 = v15.Rogue.Subtlety;
	local v35 = v17.Rogue.Subtlety;
	local v36 = v33.Rogue.Subtlety;
	local v37 = false;
	local v38 = false;
	local v39 = false;
	local v40 = false;
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
	local v63 = {v35.Mirror:ID(),v35.WitherbarksBranch:ID(),v35.AshesoftheEmbersoul:ID()};
	local v64, v65, v66, v67;
	local v68, v69, v70, v71;
	local v72;
	local v73, v74, v75;
	local v76, v77;
	local v78, v79, v80, v81;
	local v82;
	v34.Eviscerate:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v78 * (0.176 + 0) * (1.21 + 0) * ((v34.Nightstalker:IsAvailable() and v13:StealthUp(true, false) and (434.08 - (153 + 280))) or (2 - 1)) * ((v34.DeeperStratagem:IsAvailable() and (1.05 + 0)) or (1 + 0)) * ((v34.DarkShadow:IsAvailable() and v13:BuffUp(v34.ShadowDanceBuff) and (1.3 + 0)) or (1 + 0)) * ((v13:BuffUp(v34.SymbolsofDeath) and (1.1 + 0)) or (1 - 0)) * ((v13:BuffUp(v34.FinalityEviscerateBuff) and (1.3 + 0)) or (668 - (89 + 578))) * (1 + 0 + (v13:MasteryPct() / (207 - 107))) * ((1050 - (572 + 477)) + (v13:VersatilityDmgPct() / (14 + 86))) * ((v14:DebuffUp(v34.FindWeaknessDebuff) and (1.5 + 0)) or (1 + 0));
	end);
	local function v83(v108, v109)
		if (not v73 or ((1980 - (84 + 2)) <= (2316 - 910))) then
			v73 = v108;
			v74 = v109 or (0 + 0);
		end
	end
	local function v84(v110)
		if (((2414 - (497 + 345)) >= (40 + 1491)) and not v75) then
			v75 = v110;
		end
	end
	local function v85()
		if (((v41 == "On Bosses not in Dungeons") and v13:IsInDungeonArea()) or ((793 + 3894) < (5875 - (605 + 728)))) then
			return false;
		elseif (((2349 + 942) > (3705 - 2038)) and (v41 ~= "Always") and not v14:IsInBossList()) then
			return false;
		else
			return true;
		end
	end
	local function v86()
		local v111 = 0 + 0;
		while true do
			if ((v111 == (0 - 0)) or ((788 + 85) == (5635 - 3601))) then
				if ((v70 < (2 + 0)) or ((3305 - (457 + 32)) < (5 + 6))) then
					return false;
				elseif (((5101 - (832 + 570)) < (4434 + 272)) and (v42 == "Always")) then
					return true;
				elseif (((691 + 1955) >= (3099 - 2223)) and (v42 == "On Bosses") and v14:IsInBossList()) then
					return true;
				elseif (((296 + 318) <= (3980 - (588 + 208))) and (v42 == "Auto")) then
					if (((8425 - 5299) == (4926 - (884 + 916))) and (v13:InstanceDifficulty() == (33 - 17)) and (v14:NPCID() == (80576 + 58391))) then
						return true;
					elseif ((v14:NPCID() == (167622 - (232 + 421))) or (v14:NPCID() == (168860 - (1569 + 320))) or (v14:NPCID() == (40965 + 126005)) or ((416 + 1771) >= (16693 - 11739))) then
						return true;
					elseif ((v14:NPCID() == (184068 - (316 + 289))) or (v14:NPCID() == (480799 - 297128)) or ((180 + 3697) == (5028 - (666 + 787)))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v87(v112, v113, v114, v115)
		local v116 = 425 - (360 + 65);
		local v117;
		local v118;
		local v119;
		while true do
			if (((661 + 46) > (886 - (79 + 175))) and (v116 == (1 - 0))) then
				for v191, v192 in v26(v115) do
					if (((v192:GUID() ~= v119) and v31.UnitIsCycleValid(v192, v118, -v192:DebuffRemains(v112)) and v113(v192)) or ((427 + 119) >= (8227 - 5543))) then
						v117, v118 = v192, v192:TimeToDie();
					end
				end
				if (((2821 - 1356) <= (5200 - (503 + 396))) and v117 and (v14:GUID() == v117:GUID())) then
					v10.Press(v112);
				elseif (((1885 - (92 + 89)) > (2764 - 1339)) and v43) then
					v117, v118 = nil, v114;
					for v214, v215 in v26(v69) do
						if (((v215:GUID() ~= v119) and v31.UnitIsCycleValid(v215, v118, -v215:DebuffRemains(v112)) and v113(v215)) or ((353 + 334) == (2506 + 1728))) then
							v117, v118 = v215, v215:TimeToDie();
						end
					end
					if ((v117 and (v14:GUID() == v117:GUID())) or ((13040 - 9710) < (196 + 1233))) then
						v10.Press(v112);
					end
				end
				break;
			end
			if (((2615 - 1468) >= (293 + 42)) and (v116 == (0 + 0))) then
				v117, v118 = nil, v114;
				v119 = v14:GUID();
				v116 = 2 - 1;
			end
		end
	end
	local function v88()
		return 3 + 17 + (v34.Vigor:TalentRank() * (38 - 13)) + (v24(v34.ThistleTea:IsAvailable()) * (1264 - (485 + 759))) + (v24(v34.Shadowcraft:IsAvailable()) * (46 - 26));
	end
	local function v89()
		return v34.ShadowDance:ChargesFractional() >= ((1189.75 - (442 + 747)) + v18(v34.ShadowDanceTalent:IsAvailable()));
	end
	local function v90()
		return v80 >= (1138 - (832 + 303));
	end
	local function v91()
		return v13:BuffUp(v34.SliceandDice) or (v70 >= v32.CPMaxSpend());
	end
	local function v92()
		return v34.Premeditation:IsAvailable() and (v70 < (951 - (88 + 858)));
	end
	local function v93(v120)
		return (v13:BuffUp(v34.ThistleTea) and (v70 == (1 + 0))) or (v120 and ((v70 == (1 + 0)) or (v14:DebuffUp(v34.Rupture) and (v70 >= (1 + 1)))));
	end
	local function v94()
		return (not v13:BuffUp(v34.TheRotten) or not v13:HasTier(819 - (766 + 23), 9 - 7)) and (not v34.ColdBlood:IsAvailable() or (v34.ColdBlood:CooldownRemains() < (5 - 1)) or (v34.ColdBlood:CooldownRemains() > (26 - 16)));
	end
	local function v95(v121)
		return v13:BuffUp(v34.ShadowDanceBuff) and (v121:TimeSinceLastCast() < v34.ShadowDance:TimeSinceLastCast());
	end
	local function v96()
		return ((v95(v34.Shadowstrike) or v95(v34.ShurikenStorm)) and (v95(v34.Eviscerate) or v95(v34.BlackPowder) or v95(v34.Rupture))) or not v34.DanseMacabre:IsAvailable();
	end
	local function v97()
		return (not v35.WitherbarksBranch:IsEquipped() and not v35.AshesoftheEmbersoul:IsEquipped()) or (not v35.WitherbarksBranch:IsEquipped() and (v35.WitherbarksBranch:CooldownRemains() <= (27 - 19))) or (v35.WitherbarksBranch:IsEquipped() and (v35.WitherbarksBranch:CooldownRemains() <= (1081 - (1036 + 37)))) or v35.BandolierOfTwistedBlades:IsEquipped() or v34.InvigoratingShadowdust:IsAvailable();
	end
	local function v98(v122, v123)
		local v124 = v13:BuffUp(v34.ShadowDanceBuff);
		local v125 = v13:BuffRemains(v34.ShadowDanceBuff);
		local v126 = v13:BuffRemains(v34.SymbolsofDeath);
		local v127 = v79;
		local v128 = v34.ColdBlood:CooldownRemains();
		local v129 = v34.SymbolsofDeath:CooldownRemains();
		local v130 = v13:BuffUp(v34.PremeditationBuff) or (v123 and v34.Premeditation:IsAvailable());
		if (((2436 + 999) > (4083 - 1986)) and v123 and (v123:ID() == v34.ShadowDance:ID())) then
			local v163 = 0 + 0;
			while true do
				if ((v163 == (1480 - (641 + 839))) or ((4683 - (910 + 3)) >= (10301 - 6260))) then
					v124 = true;
					v125 = (1692 - (1466 + 218)) + v34.ImprovedShadowDance:TalentRank();
					v163 = 1 + 0;
				end
				if ((v163 == (1149 - (556 + 592))) or ((1349 + 2442) <= (2419 - (329 + 479)))) then
					if (v34.TheFirstDance:IsAvailable() or ((5432 - (174 + 680)) <= (6899 - 4891))) then
						v127 = v28(v13:ComboPointsMax(), v79 + (8 - 4));
					end
					if (((804 + 321) <= (2815 - (396 + 343))) and v13:HasTier(3 + 27, 1479 - (29 + 1448))) then
						v126 = v29(v126, 1395 - (135 + 1254));
					end
					break;
				end
			end
		end
		if ((v123 and (v123:ID() == v34.Vanish:ID())) or ((2798 - 2055) >= (20539 - 16140))) then
			local v164 = 0 + 0;
			while true do
				if (((2682 - (389 + 1138)) < (2247 - (102 + 472))) and (v164 == (0 + 0))) then
					v128 = v28(0 + 0, v34.ColdBlood:CooldownRemains() - ((14 + 1) * v34.InvigoratingShadowdust:TalentRank()));
					v129 = v28(1545 - (320 + 1225), v34.SymbolsofDeath:CooldownRemains() - ((26 - 11) * v34.InvigoratingShadowdust:TalentRank()));
					break;
				end
			end
		end
		if ((v34.Rupture:IsCastable() and v34.Rupture:IsReady()) or ((1422 + 902) <= (2042 - (157 + 1307)))) then
			if (((5626 - (821 + 1038)) == (9398 - 5631)) and v14:DebuffDown(v34.Rupture) and (v14:TimeToDie() > (1 + 5))) then
				if (((7262 - 3173) == (1522 + 2567)) and v122) then
					return v34.Rupture;
				else
					local v204 = 0 - 0;
					while true do
						if (((5484 - (834 + 192)) >= (107 + 1567)) and (v204 == (0 + 0))) then
							if (((21 + 951) <= (2196 - 778)) and v34.Rupture:IsReady() and v19(v34.Rupture)) then
								return "Cast Rupture";
							end
							v84(v34.Rupture);
							break;
						end
					end
				end
			end
		end
		if ((not v13:StealthUp(true, true) and not v92() and (v70 < (310 - (300 + 4))) and not v124 and v10.BossFilteredFightRemains(">", v13:BuffRemains(v34.SliceandDice)) and (v13:BuffRemains(v34.SliceandDice) < ((1 + 0 + v13:ComboPoints()) * (2.8 - 1)))) or ((5300 - (112 + 250)) < (1899 + 2863))) then
			if (v122 or ((6272 - 3768) > (2443 + 1821))) then
				return v34.SliceandDice;
			else
				if (((1114 + 1039) == (1611 + 542)) and v34.SliceandDice:IsReady() and v19(v34.SliceandDice)) then
					return "Cast Slice and Dice Premed";
				end
				v84(v34.SliceandDice);
			end
		end
		if (((not v93(v124) or v82) and (v14:TimeToDie() > (3 + 3)) and v14:DebuffRefreshable(v34.Rupture, v76)) or ((377 + 130) >= (4005 - (1001 + 413)))) then
			if (((9992 - 5511) == (5363 - (244 + 638))) and v122) then
				return v34.Rupture;
			else
				local v193 = 693 - (627 + 66);
				while true do
					if ((v193 == (0 - 0)) or ((2930 - (512 + 90)) < (2599 - (1665 + 241)))) then
						if (((5045 - (373 + 344)) == (1953 + 2375)) and v34.Rupture:IsReady() and v19(v34.Rupture)) then
							return "Cast Rupture";
						end
						v84(v34.Rupture);
						break;
					end
				end
			end
		end
		if (((421 + 1167) >= (3513 - 2181)) and v13:BuffUp(v34.FinalityRuptureBuff) and v124 and (v70 <= (6 - 2)) and not v95(v34.Rupture)) then
			if (v122 or ((5273 - (35 + 1064)) > (3091 + 1157))) then
				return v34.Rupture;
			else
				local v194 = 0 - 0;
				while true do
					if (((0 + 0) == v194) or ((5822 - (298 + 938)) <= (1341 - (233 + 1026)))) then
						if (((5529 - (636 + 1030)) == (1976 + 1887)) and v34.Rupture:IsReady() and v19(v34.Rupture)) then
							return "Cast Rupture Finality";
						end
						v84(v34.Rupture);
						break;
					end
				end
			end
		end
		if ((v34.ColdBlood:IsReady() and v96(v124, v130) and v34.SecretTechnique:IsReady()) or ((276 + 6) <= (13 + 29))) then
			local v165 = 0 + 0;
			while true do
				if (((4830 - (55 + 166)) >= (149 + 617)) and (v165 == (0 + 0))) then
					if (v122 or ((4399 - 3247) == (2785 - (36 + 261)))) then
						return v34.ColdBlood;
					end
					if (((5984 - 2562) > (4718 - (34 + 1334))) and v19(v34.ColdBlood)) then
						return "Cast Cold Blood (SecTec)";
					end
					break;
				end
			end
		end
		if (((338 + 539) > (293 + 83)) and v34.SecretTechnique:IsReady()) then
			if ((v96(v124, v130) and (not v34.ColdBlood:IsAvailable() or v13:BuffUp(v34.ColdBlood) or (v128 > (v125 - (1285 - (1035 + 248)))) or not v34.ImprovedShadowDance:IsAvailable())) or ((3139 - (20 + 1)) <= (965 + 886))) then
				local v195 = 319 - (134 + 185);
				while true do
					if (((1133 - (549 + 584)) == v195) or ((850 - (314 + 371)) >= (11987 - 8495))) then
						if (((4917 - (478 + 490)) < (2573 + 2283)) and v122) then
							return v34.SecretTechnique;
						end
						if (v19(v34.SecretTechnique) or ((5448 - (786 + 386)) < (9768 - 6752))) then
							return "Cast Secret Technique";
						end
						break;
					end
				end
			end
		end
		if (((6069 - (1055 + 324)) > (5465 - (1093 + 247))) and not v93(v124) and v34.Rupture:IsCastable()) then
			if ((not v122 and v38 and not v82 and (v70 >= (2 + 0))) or ((6 + 44) >= (3557 - 2661))) then
				local function v196(v200)
					return v31.CanDoTUnit(v200, v77) and v200:DebuffRefreshable(v34.Rupture, v76);
				end
				v87(v34.Rupture, v196, (6 - 4) * v127, v71);
			end
			if ((v66 and (v14:DebuffRemains(v34.Rupture) < (v129 + (28 - 18))) and (v129 <= (12 - 7)) and v32.CanDoTUnit(v14, v77) and v14:FilteredTimeToDie(">", 2 + 3 + v129, -v14:DebuffRemains(v34.Rupture))) or ((6603 - 4889) >= (10195 - 7237))) then
				if (v122 or ((1125 + 366) < (1646 - 1002))) then
					return v34.Rupture;
				else
					if (((1392 - (364 + 324)) < (2705 - 1718)) and v34.Rupture:IsReady() and v19(v34.Rupture)) then
						return "Cast Rupture 2";
					end
					v84(v34.Rupture);
				end
			end
		end
		if (((8921 - 5203) > (632 + 1274)) and v34.BlackPowder:IsCastable() and not v82 and (v70 >= (12 - 9))) then
			if (v122 or ((1534 - 576) > (11039 - 7404))) then
				return v34.BlackPowder;
			else
				if (((4769 - (1249 + 19)) <= (4055 + 437)) and v34.BlackPowder:IsReady() and v19(v34.BlackPowder)) then
					return "Cast Black Powder";
				end
				v84(v34.BlackPowder);
			end
		end
		if ((v34.Eviscerate:IsCastable() and v66) or ((13397 - 9955) < (3634 - (686 + 400)))) then
			if (((2256 + 619) >= (1693 - (73 + 156))) and v122) then
				return v34.Eviscerate;
			else
				local v197 = 0 + 0;
				while true do
					if (((811 - (721 + 90)) == v197) or ((54 + 4743) >= (15886 - 10993))) then
						if ((v34.Eviscerate:IsReady() and v19(v34.Eviscerate)) or ((1021 - (224 + 246)) > (3349 - 1281))) then
							return "Cast Eviscerate";
						end
						v84(v34.Eviscerate);
						break;
					end
				end
			end
		end
		return false;
	end
	local function v99(v131, v132)
		local v133 = 0 - 0;
		local v134;
		local v135;
		local v136;
		local v137;
		local v138;
		local v139;
		local v140;
		local v141;
		local v142;
		local v143;
		while true do
			if (((384 + 1730) > (23 + 921)) and (v133 == (3 + 1))) then
				if ((v142 >= v32.CPMaxSpend()) or ((4496 - 2234) >= (10302 - 7206))) then
					return v98(v131, v132);
				end
				if ((v13:BuffUp(v34.ShurikenTornado) and (v138 <= (515 - (203 + 310)))) or ((4248 - (1238 + 755)) >= (248 + 3289))) then
					return v98(v131, v132);
				end
				if ((v80 <= ((1535 - (709 + 825)) + v24(v34.DeeperStratagem:IsAvailable() or v34.SecretStratagem:IsAvailable()))) or ((7070 - 3233) < (1901 - 595))) then
					return v98(v131, v132);
				end
				v133 = 869 - (196 + 668);
			end
			if (((11647 - 8697) == (6110 - 3160)) and (v133 == (839 - (171 + 662)))) then
				if ((not v139 and (v70 >= (97 - (4 + 89)))) or ((16553 - 11830) < (1201 + 2097))) then
					if (((4989 - 3853) >= (61 + 93)) and v131) then
						return v34.ShurikenStorm;
					elseif (v19(v34.ShurikenStorm) or ((1757 - (35 + 1451)) > (6201 - (28 + 1425)))) then
						return "Cast Shuriken Storm";
					end
				end
				if (((6733 - (941 + 1052)) >= (3023 + 129)) and v143) then
					if (v131 or ((4092 - (822 + 692)) >= (4839 - 1449))) then
						return v34.Shadowstrike;
					elseif (((20 + 21) <= (1958 - (45 + 252))) and v19(v34.Shadowstrike)) then
						return "Cast Shadowstrike";
					end
				end
				return false;
			end
			if (((595 + 6) < (1226 + 2334)) and (v133 == (7 - 4))) then
				v143 = v34.Shadowstrike:IsCastable() or v140 or v141 or v134 or v13:BuffUp(v34.SepsisBuff);
				if (((668 - (114 + 319)) < (986 - 299)) and (v140 or v141)) then
					v143 = v143 and v14:IsInRange(32 - 7);
				else
					v143 = v143 and v66;
				end
				if (((2900 + 1649) > (1717 - 564)) and v143 and v140 and ((v70 < (8 - 4)) or v82)) then
					if (v131 or ((6637 - (556 + 1407)) < (5878 - (741 + 465)))) then
						return v34.Shadowstrike;
					elseif (((4133 - (170 + 295)) < (2404 + 2157)) and v19(v34.Shadowstrike)) then
						return "Cast Shadowstrike (Stealth)";
					end
				end
				v133 = 4 + 0;
			end
			if ((v133 == (0 - 0)) or ((378 + 77) == (2312 + 1293))) then
				v134 = v13:BuffUp(v34.ShadowDanceBuff);
				v135 = v13:BuffRemains(v34.ShadowDanceBuff);
				v136 = v13:BuffUp(v34.TheRottenBuff);
				v133 = 1 + 0;
			end
			if ((v133 == (1235 - (957 + 273))) or ((713 + 1950) == (1326 + 1986))) then
				if (((16297 - 12020) <= (11792 - 7317)) and v34.Backstab:IsCastable() and not v139 and (v135 >= (9 - 6)) and v13:BuffUp(v34.ShadowBlades) and not v95(v34.Backstab) and v34.DanseMacabre:IsAvailable() and (v70 <= (14 - 11)) and not v136) then
					if (v131 or ((2650 - (389 + 1391)) == (746 + 443))) then
						if (((162 + 1391) <= (7132 - 3999)) and v132) then
							return v34.Backstab;
						else
							return {v34.Backstab,v34.Stealth};
						end
					elseif (v22(v34.Backstab, v34.Stealth) or ((2201 + 36) >= (3822 - (309 + 2)))) then
						return "Cast Backstab (Stealth)";
					end
				end
				if (v34.Gloomblade:IsAvailable() or ((4065 - 2741) > (4232 - (1090 + 122)))) then
					if ((not v139 and (v135 >= (1 + 2)) and v13:BuffUp(v34.ShadowBlades) and not v95(v34.Gloomblade) and v34.DanseMacabre:IsAvailable() and (v70 <= (13 - 9))) or ((2048 + 944) == (2999 - (628 + 490)))) then
						if (((557 + 2549) > (3777 - 2251)) and v131) then
							if (((13815 - 10792) < (4644 - (431 + 343))) and v132) then
								return v34.Gloomblade;
							else
								return {v34.Gloomblade,v34.Stealth};
							end
						elseif (((113 + 30) > (10 + 64)) and v22(v34.Gloomblade, v34.Stealth)) then
							return "Cast Gloomblade (Danse)";
						end
					end
				end
				if (((1713 - (556 + 1139)) < (2127 - (6 + 9))) and not v95(v34.Shadowstrike) and v13:BuffUp(v34.ShadowBlades)) then
					if (((201 + 896) <= (834 + 794)) and v131) then
						return v34.Shadowstrike;
					elseif (((4799 - (28 + 141)) == (1794 + 2836)) and v19(v34.Shadowstrike)) then
						return "Cast Shadowstrike (Danse)";
					end
				end
				v133 = 7 - 1;
			end
			if (((2508 + 1032) > (4000 - (486 + 831))) and (v133 == (2 - 1))) then
				v137, v138 = v79, v80;
				v139 = v13:BuffUp(v34.PremeditationBuff) or (v132 and v34.Premeditation:IsAvailable());
				v140 = v13:BuffUp(v32.StealthSpell()) or (v132 and (v132:ID() == v32.StealthSpell():ID()));
				v133 = 6 - 4;
			end
			if (((906 + 3888) >= (10355 - 7080)) and (v133 == (1265 - (668 + 595)))) then
				v141 = v13:BuffUp(v32.VanishBuffSpell()) or (v132 and (v132:ID() == v34.Vanish:ID()));
				if (((1336 + 148) == (300 + 1184)) and v132 and (v132:ID() == v34.ShadowDance:ID())) then
					v134 = true;
					v135 = (21 - 13) + v34.ImprovedShadowDance:TalentRank();
					if (((1722 - (23 + 267)) < (5499 - (1129 + 815))) and v34.TheRotten:IsAvailable() and v13:HasTier(417 - (371 + 16), 1752 - (1326 + 424))) then
						v136 = true;
					end
					if (v34.TheFirstDance:IsAvailable() or ((2016 - 951) > (13074 - 9496))) then
						local v206 = 118 - (88 + 30);
						while true do
							if ((v206 == (771 - (720 + 51))) or ((10666 - 5871) < (3183 - (421 + 1355)))) then
								v137 = v28(v13:ComboPointsMax(), v79 + (6 - 2));
								v138 = v13:ComboPointsMax() - v137;
								break;
							end
						end
					end
				end
				v142 = v32.EffectiveComboPoints(v137);
				v133 = 2 + 1;
			end
		end
	end
	local function v100(v144, v145)
		local v146 = 1083 - (286 + 797);
		local v147;
		local v148;
		while true do
			if (((6773 - 4920) < (7971 - 3158)) and (v146 == (440 - (397 + 42)))) then
				v148 = {v144,v147};
				if ((v145 and (v13:EnergyPredicted() < v145)) or ((4345 - 1524) < (3216 - (222 + 563)))) then
					local v201 = 0 - 0;
					while true do
						if ((v201 == (0 + 0)) or ((3064 - (23 + 167)) < (3979 - (690 + 1108)))) then
							v83(v148, v145);
							return false;
						end
					end
				end
				v146 = 1 + 1;
			end
			if ((v146 == (0 + 0)) or ((3537 - (40 + 808)) <= (57 + 286))) then
				v147 = v99(true, v144);
				if (((v144:ID() == v34.Vanish:ID()) and (not v44 or not v147)) or ((7146 - 5277) == (1921 + 88))) then
					local v202 = 0 + 0;
					while true do
						if ((v202 == (0 + 0)) or ((4117 - (47 + 524)) < (1507 + 815))) then
							if (v19(v34.Vanish, nil) or ((5691 - 3609) == (7136 - 2363))) then
								return "Cast Vanish";
							end
							return false;
						end
					end
				elseif (((7397 - 4153) > (2781 - (1165 + 561))) and (v144:ID() == v34.Shadowmeld:ID()) and (not v45 or not v147)) then
					local v207 = 0 + 0;
					while true do
						if ((v207 == (0 - 0)) or ((1265 + 2048) <= (2257 - (341 + 138)))) then
							if (v19(v34.Shadowmeld, nil) or ((384 + 1037) >= (4341 - 2237))) then
								return "Cast Shadowmeld";
							end
							return false;
						end
					end
				elseif (((2138 - (89 + 237)) <= (10451 - 7202)) and (v144:ID() == v34.ShadowDance:ID()) and (not v46 or not v147)) then
					if (((3416 - 1793) <= (2838 - (581 + 300))) and v19(v34.ShadowDance, nil)) then
						return "Cast Shadow Dance";
					end
					return false;
				end
				v146 = 1221 - (855 + 365);
			end
			if (((10479 - 6067) == (1441 + 2971)) and (v146 == (1237 - (1030 + 205)))) then
				v72 = v22(unpack(v148));
				if (((1643 + 107) >= (784 + 58)) and v72) then
					return "| " .. v148[288 - (156 + 130)]:Name();
				end
				v146 = 6 - 3;
			end
			if (((7367 - 2995) > (3789 - 1939)) and (v146 == (1 + 2))) then
				return false;
			end
		end
	end
	local function v101()
		local v149 = 0 + 0;
		local v150;
		local v151;
		local v152;
		while true do
			if (((301 - (10 + 59)) < (233 + 588)) and (v149 == (19 - 15))) then
				if (((1681 - (671 + 492)) < (719 + 183)) and v34.Fireblood:IsCastable() and v151 and v49) then
					if (((4209 - (369 + 846)) > (228 + 630)) and v19(v34.Fireblood, nil)) then
						return "Cast Fireblood";
					end
				end
				if ((v34.AncestralCall:IsCastable() and v151 and v49) or ((3205 + 550) <= (2860 - (1036 + 909)))) then
					if (((3138 + 808) > (6284 - 2541)) and v19(v34.AncestralCall, nil)) then
						return "Cast Ancestral Call";
					end
				end
				v152 = v31.HandleTopTrinket(v63, v39, 243 - (11 + 192), nil);
				if (v152 or ((675 + 660) >= (3481 - (135 + 40)))) then
					return v152;
				end
				v149 = 11 - 6;
			end
			if (((2920 + 1924) > (4963 - 2710)) and (v149 == (0 - 0))) then
				if (((628 - (50 + 126)) == (1258 - 806)) and v39 and v34.ColdBlood:IsReady() and not v34.SecretTechnique:IsAvailable() and (v79 >= (2 + 3))) then
					if (v19(v34.ColdBlood, nil) or ((5970 - (1233 + 180)) < (3056 - (522 + 447)))) then
						return "Cast Cold Blood";
					end
				end
				if (((5295 - (107 + 1314)) == (1798 + 2076)) and v39 and v34.Sepsis:IsAvailable() and v34.Sepsis:IsReady()) then
					if ((v91() and v14:FilteredTimeToDie(">=", 48 - 32) and (v13:BuffUp(v34.PerforatedVeins) or not v34.PerforatedVeins:IsAvailable())) or ((824 + 1114) > (9799 - 4864))) then
						if (v19(v34.Sepsis, nil, nil) or ((16835 - 12580) < (5333 - (716 + 1194)))) then
							return "Cast Sepsis";
						end
					end
				end
				if (((25 + 1429) <= (267 + 2224)) and v39 and v34.Flagellation:IsAvailable() and v34.Flagellation:IsReady()) then
					if ((v91() and (v78 >= (508 - (74 + 429))) and (v14:TimeToDie() > (19 - 9)) and ((v97() and (v34.ShadowBlades:CooldownRemains() <= (2 + 1))) or v10.BossFilteredFightRemains("<=", 63 - 35) or ((v34.ShadowBlades:CooldownRemains() >= (10 + 4)) and v34.InvigoratingShadowdust:IsAvailable() and v34.ShadowDance:IsAvailable())) and (not v34.InvigoratingShadowdust:IsAvailable() or v34.Sepsis:IsAvailable() or not v34.ShadowDance:IsAvailable() or ((v34.InvigoratingShadowdust:TalentRank() == (5 - 3)) and (v70 >= (4 - 2))) or (v34.SymbolsofDeath:CooldownRemains() <= (436 - (279 + 154))) or (v13:BuffRemains(v34.SymbolsofDeath) > (781 - (454 + 324))))) or ((3271 + 886) <= (2820 - (12 + 5)))) then
						if (((2617 + 2236) >= (7597 - 4615)) and v19(v34.Flagellation, nil, nil)) then
							return "Cast Flagellation";
						end
					end
				end
				if (((1528 + 2606) > (4450 - (277 + 816))) and v39 and v34.SymbolsofDeath:IsReady()) then
					if ((v91() and (not v13:BuffUp(v34.TheRotten) or not v13:HasTier(128 - 98, 1185 - (1058 + 125))) and (v13:BuffRemains(v34.SymbolsofDeath) <= (1 + 2)) and (not v34.Flagellation:IsAvailable() or (v34.Flagellation:CooldownRemains() > (985 - (815 + 160))) or ((v13:BuffRemains(v34.ShadowDance) >= (8 - 6)) and v34.InvigoratingShadowdust:IsAvailable()) or (v34.Flagellation:IsReady() and (v78 >= (11 - 6)) and not v34.InvigoratingShadowdust:IsAvailable()))) or ((816 + 2601) < (7407 - 4873))) then
						if (v19(v34.SymbolsofDeath, nil) or ((4620 - (41 + 1857)) <= (2057 - (1222 + 671)))) then
							return "Cast Symbols of Death";
						end
					end
				end
				v149 = 2 - 1;
			end
			if (((2 - 0) == v149) or ((3590 - (229 + 953)) < (3883 - (1111 + 663)))) then
				if ((v39 and v34.ShadowDance:IsAvailable() and v85() and v34.ShadowDance:IsReady()) or ((1612 - (874 + 705)) == (204 + 1251))) then
					if ((not v13:BuffUp(v34.ShadowDance) and v10.BossFilteredFightRemains("<=", 6 + 2 + ((6 - 3) * v24(v34.Subterfuge:IsAvailable())))) or ((13 + 430) >= (4694 - (642 + 37)))) then
						if (((772 + 2610) > (27 + 139)) and v19(v34.ShadowDance)) then
							return "Cast Shadow Dance";
						end
					end
				end
				if ((v39 and v34.GoremawsBite:IsAvailable() and v34.GoremawsBite:IsReady()) or ((703 - 423) == (3513 - (233 + 221)))) then
					if (((4349 - 2468) > (1139 + 154)) and v91() and (v80 >= (1544 - (718 + 823))) and (not v34.ShadowDance:IsReady() or (v34.ShadowDance:IsAvailable() and v13:BuffUp(v34.ShadowDance) and not v34.InvigoratingShadowdust:IsAvailable()) or ((v70 < (3 + 1)) and not v34.InvigoratingShadowdust:IsAvailable()) or v34.TheRotten:IsAvailable())) then
						if (((3162 - (266 + 539)) == (6673 - 4316)) and v19(v34.GoremawsBite)) then
							return "Cast Goremaw's Bite";
						end
					end
				end
				if (((1348 - (636 + 589)) == (291 - 168)) and v34.ThistleTea:IsReady()) then
					if ((((v34.SymbolsofDeath:CooldownRemains() >= (5 - 2)) or v13:BuffUp(v34.SymbolsofDeath)) and not v13:BuffUp(v34.ThistleTea) and (((v13:EnergyDeficitPredicted() >= (80 + 20)) and ((v80 >= (1 + 1)) or (v70 >= (1018 - (657 + 358))))) or ((v34.ThistleTea:ChargesFractional() >= ((4.75 - 2) - ((0.15 - 0) * v34.InvigoratingShadowdust:TalentRank()))) and v34.Vanish:IsReady() and v13:BuffUp(v34.ShadowDance) and v14:DebuffUp(v34.Rupture) and (v70 < (1190 - (1151 + 36)))))) or ((v13:BuffRemains(v34.ShadowDance) >= (4 + 0)) and not v13:BuffUp(v34.ThistleTea) and (v70 >= (1 + 2))) or (not v13:BuffUp(v34.ThistleTea) and v10.BossFilteredFightRemains("<=", (17 - 11) * v34.ThistleTea:Charges())) or ((2888 - (1552 + 280)) >= (4226 - (64 + 770)))) then
						if (v19(v34.ThistleTea, nil, nil) or ((734 + 347) < (2440 - 1365))) then
							return "Thistle Tea";
						end
					end
				end
				v150 = v31.HandleDPSPotion(v10.BossFilteredFightRemains("<", 6 + 24) or (v13:BuffUp(v34.SymbolsofDeath) and (v13:BuffUp(v34.ShadowBlades) or (v34.ShadowBlades:CooldownRemains() <= (1253 - (157 + 1086))))));
				v149 = 5 - 2;
			end
			if ((v149 == (21 - 16)) or ((1608 - 559) >= (6048 - 1616))) then
				v152 = v31.HandleBottomTrinket(v63, v39, 859 - (599 + 220), nil);
				if (v152 or ((9494 - 4726) <= (2777 - (1813 + 118)))) then
					return v152;
				end
				if (v34.ThistleTea:IsReady() or ((2455 + 903) <= (2637 - (841 + 376)))) then
					if ((((v34.SymbolsofDeath:CooldownRemains() >= (3 - 0)) or v13:BuffUp(v34.SymbolsofDeath)) and not v13:BuffUp(v34.ThistleTea) and (((v13:EnergyDeficitPredicted() >= (24 + 76)) and ((v13:ComboPointsDeficit() >= (5 - 3)) or (v70 >= (862 - (464 + 395))))) or ((v34.ThistleTea:ChargesFractional() >= (5.75 - 3)) and v13:BuffUp(v34.ShadowDanceBuff)))) or ((v13:BuffRemains(v34.ShadowDanceBuff) >= (2 + 2)) and not v13:BuffUp(v34.ThistleTea) and (v70 >= (840 - (467 + 370)))) or (not v13:BuffUp(v34.ThistleTea) and v10.BossFilteredFightRemains("<=", (11 - 5) * v34.ThistleTea:Charges())) or ((2745 + 994) <= (10301 - 7296))) then
						if (v19(v34.ThistleTea, nil, nil) or ((259 + 1400) >= (4964 - 2830))) then
							return "Thistle Tea";
						end
					end
				end
				return false;
			end
			if ((v149 == (523 - (150 + 370))) or ((4542 - (74 + 1208)) < (5792 - 3437))) then
				if (v150 or ((3172 - 2503) == (3005 + 1218))) then
					return v150;
				end
				v151 = v13:BuffUp(v34.ShadowBlades) or (not v34.ShadowBlades:IsAvailable() and v13:BuffUp(v34.SymbolsofDeath)) or v10.BossFilteredFightRemains("<", 410 - (14 + 376));
				if ((v34.BloodFury:IsCastable() and v151 and v49) or ((2934 - 1242) < (381 + 207))) then
					if (v19(v34.BloodFury, nil) or ((4214 + 583) < (3482 + 169))) then
						return "Cast Blood Fury";
					end
				end
				if ((v34.Berserking:IsCastable() and v151 and v49) or ((12239 - 8062) > (3649 + 1201))) then
					if (v19(v34.Berserking, nil) or ((478 - (23 + 55)) > (2632 - 1521))) then
						return "Cast Berserking";
					end
				end
				v149 = 3 + 1;
			end
			if (((2740 + 311) > (1558 - 553)) and (v149 == (1 + 0))) then
				if (((4594 - (652 + 249)) <= (11726 - 7344)) and v39 and v34.ShadowBlades:IsReady()) then
					if ((v91() and ((v78 <= (1869 - (708 + 1160))) or v13:HasTier(84 - 53, 6 - 2)) and (v13:BuffUp(v34.Flagellation) or v13:BuffUp(v34.FlagellationPersistBuff) or not v34.Flagellation:IsAvailable())) or ((3309 - (10 + 17)) > (921 + 3179))) then
						if (v19(v34.ShadowBlades, nil) or ((5312 - (1400 + 332)) < (5454 - 2610))) then
							return "Cast Shadow Blades";
						end
					end
				end
				if (((1997 - (242 + 1666)) < (1922 + 2568)) and v39 and v34.EchoingReprimand:IsCastable() and v34.EchoingReprimand:IsAvailable()) then
					if ((v91() and (v80 >= (2 + 1))) or ((4247 + 736) < (2748 - (850 + 90)))) then
						if (((6705 - 2876) > (5159 - (360 + 1030))) and v19(v34.EchoingReprimand, nil, nil)) then
							return "Cast Echoing Reprimand";
						end
					end
				end
				if (((1315 + 170) <= (8196 - 5292)) and v39 and v34.ShurikenTornado:IsAvailable() and v34.ShurikenTornado:IsReady()) then
					if (((5872 - 1603) == (5930 - (909 + 752))) and v91() and v13:BuffUp(v34.SymbolsofDeath) and (v78 <= (1225 - (109 + 1114))) and not v13:BuffUp(v34.Premeditation) and (not v34.Flagellation:IsAvailable() or (v34.Flagellation:CooldownRemains() > (36 - 16))) and (v70 >= (2 + 1))) then
						if (((629 - (6 + 236)) <= (1753 + 1029)) and v19(v34.ShurikenTornado, nil)) then
							return "Cast Shuriken Tornado";
						end
					end
				end
				if ((v39 and v34.ShurikenTornado:IsAvailable() and v34.ShurikenTornado:IsReady()) or ((1529 + 370) <= (2162 - 1245))) then
					if ((v91() and not v13:BuffUp(v34.ShadowDance) and not v13:BuffUp(v34.Flagellation) and not v13:BuffUp(v34.FlagellationPersistBuff) and not v13:BuffUp(v34.ShadowBlades) and (v70 <= (3 - 1))) or ((5445 - (1076 + 57)) <= (145 + 731))) then
						if (((2921 - (579 + 110)) <= (205 + 2391)) and v19(v34.ShurikenTornado, nil)) then
							return "Cast Shuriken Tornado";
						end
					end
				end
				v149 = 2 + 0;
			end
		end
	end
	local function v102(v153)
		local v154 = 0 + 0;
		while true do
			if (((2502 - (174 + 233)) < (10295 - 6609)) and (v154 == (0 - 0))) then
				if ((v39 and not (v31.IsSoloMode() and v13:IsTanking(v14))) or ((710 + 885) >= (5648 - (663 + 511)))) then
					local v203 = 0 + 0;
					while true do
						if ((v203 == (1 + 0)) or ((14240 - 9621) < (1746 + 1136))) then
							if ((v49 and v34.Shadowmeld:IsCastable() and v66 and not v13:IsMoving() and (v13:EnergyPredicted() >= (94 - 54)) and (v13:EnergyDeficitPredicted() >= (24 - 14)) and not v89() and (v80 > (2 + 2))) or ((571 - 277) >= (3443 + 1388))) then
								v72 = v100(v34.Shadowmeld, v153);
								if (((186 + 1843) <= (3806 - (478 + 244))) and v72) then
									return "Shadowmeld Macro " .. v72;
								end
							end
							break;
						end
						if ((v203 == (517 - (440 + 77))) or ((927 + 1110) == (8857 - 6437))) then
							if (((6014 - (655 + 901)) > (724 + 3180)) and v34.Vanish:IsCastable()) then
								if (((334 + 102) >= (84 + 39)) and ((v80 > (3 - 2)) or (v13:BuffUp(v34.ShadowBlades) and v34.InvigoratingShadowdust:IsAvailable())) and not v89() and ((v34.Flagellation:CooldownRemains() >= (1505 - (695 + 750))) or not v34.Flagellation:IsAvailable() or v10.BossFilteredFightRemains("<=", (102 - 72) * v34.Vanish:Charges())) and ((v34.SymbolsofDeath:CooldownRemains() > (3 - 0)) or not v13:HasTier(120 - 90, 353 - (285 + 66))) and ((v34.SecretTechnique:CooldownRemains() >= (23 - 13)) or not v34.SecretTechnique:IsAvailable() or ((v34.Vanish:Charges() >= (1312 - (682 + 628))) and v34.InvigoratingShadowdust:IsAvailable() and (v13:BuffUp(v34.TheRotten) or not v34.TheRotten:IsAvailable())))) then
									v72 = v100(v34.Vanish, v153);
									if (((81 + 419) < (2115 - (176 + 123))) and v72) then
										return "Vanish Macro " .. v72;
									end
								end
							end
							if (((1495 + 2079) == (2593 + 981)) and v49 and v47 and (v13:Energy() < (309 - (239 + 30))) and v34.Shadowmeld:IsCastable()) then
								if (((61 + 160) < (375 + 15)) and v21(v34.Shadowmeld, v13:EnergyTimeToX(70 - 30))) then
									return "Pool for Shadowmeld";
								end
							end
							v203 = 2 - 1;
						end
					end
				end
				if ((v66 and v34.ShadowDance:IsCastable()) or ((2528 - (306 + 9)) <= (4958 - 3537))) then
					if (((532 + 2526) < (2982 + 1878)) and (v14:DebuffUp(v34.Rupture) or v34.InvigoratingShadowdust:IsAvailable()) and v94() and (not v34.TheFirstDance:IsAvailable() or (v80 >= (2 + 2)) or v13:BuffUp(v34.ShadowBlades)) and ((v90() and v89()) or ((v13:BuffUp(v34.ShadowBlades) or (v13:BuffUp(v34.SymbolsofDeath) and not v34.Sepsis:IsAvailable()) or ((v13:BuffRemains(v34.SymbolsofDeath) >= (11 - 7)) and not v13:HasTier(1405 - (1140 + 235), 2 + 0)) or (not v13:BuffUp(v34.SymbolsofDeath) and v13:HasTier(28 + 2, 1 + 1))) and (v34.SecretTechnique:CooldownRemains() < ((62 - (33 + 19)) + ((5 + 7) * v24(not v34.InvigoratingShadowdust:IsAvailable() or v13:HasTier(89 - 59, 1 + 1)))))))) then
						local v208 = 0 - 0;
						while true do
							if ((v208 == (0 + 0)) or ((1985 - (586 + 103)) >= (405 + 4041))) then
								v72 = v100(v34.ShadowDance, v153);
								if (v72 or ((4288 - 2895) > (5977 - (1309 + 179)))) then
									return "ShadowDance Macro 1 " .. v72;
								end
								break;
							end
						end
					end
				end
				v154 = 1 - 0;
			end
			if ((v154 == (1 + 0)) or ((11880 - 7456) < (21 + 6))) then
				return false;
			end
		end
	end
	local function v103(v155)
		local v156 = not v155 or (v13:EnergyPredicted() >= v155);
		if ((v38 and v34.ShurikenStorm:IsCastable() and (v70 >= ((3 - 1) + v18((v34.Gloomblade:IsAvailable() and (v13:BuffRemains(v34.LingeringShadowBuff) >= (11 - 5))) or v13:BuffUp(v34.PerforatedVeinsBuff))))) or ((2606 - (295 + 314)) > (9370 - 5555))) then
			if (((5427 - (1300 + 662)) > (6006 - 4093)) and v156 and v19(v34.ShurikenStorm)) then
				return "Cast Shuriken Storm";
			end
			v83(v34.ShurikenStorm, v155);
		end
		if (((2488 - (1178 + 577)) < (945 + 874)) and v66) then
			if (v34.Gloomblade:IsCastable() or ((12992 - 8597) == (6160 - (851 + 554)))) then
				local v198 = 0 + 0;
				while true do
					if ((v198 == (0 - 0)) or ((8237 - 4444) < (2671 - (115 + 187)))) then
						if ((v156 and v19(v34.Gloomblade)) or ((3128 + 956) == (251 + 14))) then
							return "Cast Gloomblade";
						end
						v83(v34.Gloomblade, v155);
						break;
					end
				end
			elseif (((17173 - 12815) == (5519 - (160 + 1001))) and v34.Backstab:IsCastable()) then
				local v205 = 0 + 0;
				while true do
					if (((0 + 0) == v205) or ((6423 - 3285) < (1351 - (237 + 121)))) then
						if (((4227 - (525 + 372)) > (4403 - 2080)) and v156 and v19(v34.Backstab)) then
							return "Cast Backstab";
						end
						v83(v34.Backstab, v155);
						break;
					end
				end
			end
		end
		return false;
	end
	local v104 = {{v34.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v34.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v79 > (0 - 0);
	end},{v34.CheapShot,"Cast Cheap Shot (Interrupt)",function()
		return v13:StealthUp(true, true);
	end}};
	local function v105()
		local v157 = 0 - 0;
		while true do
			if ((v157 == (0 + 0)) or ((1169 + 2457) == (13821 - 9832))) then
				v41 = EpicSettings.Settings['BurnShadowDance'];
				v42 = EpicSettings.Settings['UsePriorityRotation'];
				v43 = EpicSettings.Settings['RangedMultiDoT'];
				v44 = EpicSettings.Settings['StealthMacroVanish'];
				v157 = 4 - 3;
			end
			if ((v157 == (7 - 3)) or ((53 + 863) == (5258 - 2587))) then
				v57 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v58 = EpicSettings.Settings['InterruptThreshold'];
				v59 = EpicSettings.Settings['AutoFocusTank'];
				v60 = EpicSettings.Settings['AutoTricksTank'];
				v157 = 1 + 4;
			end
			if (((800 - 528) == (289 - (12 + 5))) and (v157 == (19 - 14))) then
				v61 = EpicSettings.Settings['UsageStealthOOC'];
				v62 = EpicSettings.Settings['StealthRange'] or (0 - 0);
				break;
			end
			if (((9031 - 4782) <= (11999 - 7160)) and (v157 == (1 + 1))) then
				v49 = EpicSettings.Settings['UseRacials'];
				v50 = EpicSettings.Settings['UseHealingPotion'];
				v51 = EpicSettings.Settings['HealingPotionName'];
				v52 = EpicSettings.Settings['HealingPotionHP'] or (1974 - (1656 + 317));
				v157 = 3 + 0;
			end
			if (((2226 + 551) < (8508 - 5308)) and (v157 == (14 - 11))) then
				v53 = EpicSettings.Settings['DispelBuffs'];
				v54 = EpicSettings.Settings['UseHealthstone'];
				v55 = EpicSettings.Settings['HealthstoneHP'] or (355 - (5 + 349));
				v56 = EpicSettings.Settings['InterruptWithStun'];
				v157 = 18 - 14;
			end
			if (((1366 - (266 + 1005)) < (1290 + 667)) and (v157 == (3 - 2))) then
				v45 = EpicSettings.Settings['StealthMacroShadowmeld'];
				v46 = EpicSettings.Settings['StealthMacroShadowDance'];
				v47 = EpicSettings.Settings['PoolForShadowmeld'];
				v48 = EpicSettings.Settings['EviscerateDMGOffset'] or (1 - 0);
				v157 = 1698 - (561 + 1135);
			end
		end
	end
	local function v106()
		v105();
		v37 = EpicSettings.Toggles['ooc'];
		v38 = EpicSettings.Toggles['aoe'];
		v39 = EpicSettings.Toggles['cds'];
		v40 = EpicSettings.Toggles['dispel'];
		v73 = nil;
		v75 = nil;
		v74 = 0 - 0;
		v64 = (v34.AcrobaticStrikes:IsAvailable() and (26 - 18)) or (1071 - (507 + 559));
		v65 = (v34.AcrobaticStrikes:IsAvailable() and (32 - 19)) or (30 - 20);
		v66 = v14:IsInMeleeRange(v64);
		v67 = v14:IsInMeleeRange(v65);
		if (((1214 - (212 + 176)) < (2622 - (250 + 655))) and v38) then
			v68 = v13:GetEnemiesInRange(81 - 51);
			v69 = v13:GetEnemiesInMeleeRange(v65);
			v70 = #v69;
			v71 = v13:GetEnemiesInMeleeRange(v64);
		else
			local v166 = 0 - 0;
			while true do
				if (((2230 - 804) >= (3061 - (1869 + 87))) and (v166 == (0 - 0))) then
					v68 = {};
					v69 = {};
					v166 = 1902 - (484 + 1417);
				end
				if (((5902 - 3148) <= (5662 - 2283)) and (v166 == (774 - (48 + 725)))) then
					v70 = 1 - 0;
					v71 = {};
					break;
				end
			end
		end
		v79 = v13:ComboPoints();
		v78 = v32.EffectiveComboPoints(v79);
		v80 = v13:ComboPointsDeficit();
		v82 = v86();
		v81 = v13:EnergyMax() - v88();
		if ((v13:BuffUp(v34.ShurikenTornado, nil, true) and (v79 < v32.CPMaxSpend())) or ((10535 - 6608) == (822 + 591))) then
			local v167 = v32.TimeToNextTornado();
			if ((v167 <= v13:GCDRemains()) or (v30(v13:GCDRemains() - v167) < (0.25 - 0)) or ((323 + 831) <= (230 + 558))) then
				local v199 = v70 + v24(v13:BuffUp(v34.ShadowBlades));
				v79 = v28(v79 + v199, v32.CPMaxSpend());
				v80 = v29(v80 - v199, 853 - (152 + 701));
				if ((v78 < v32.CPMaxSpend()) or ((2954 - (430 + 881)) > (1295 + 2084))) then
					v78 = v79;
				end
			end
		end
		v76 = ((899 - (557 + 338)) + (v78 * (2 + 2))) * (0.3 - 0);
		v77 = v34.Eviscerate:Damage() * v48;
		if ((not v13:AffectingCombat() and v59) or ((9815 - 7012) > (12085 - 7536))) then
			local v168 = 0 - 0;
			local v169;
			while true do
				if ((v168 == (801 - (499 + 302))) or ((1086 - (39 + 827)) >= (8341 - 5319))) then
					v169 = v31.FocusUnit(false, nil, nil, "TANK", 44 - 24);
					if (((11208 - 8386) == (4332 - 1510)) and v169) then
						return v169;
					end
					break;
				end
			end
		end
		if ((Focus and v60 and (v31.UnitGroupRole(Focus) == "TANK") and v34.TricksoftheTrade:IsCastable()) or ((91 + 970) == (5435 - 3578))) then
			if (((442 + 2318) > (2157 - 793)) and Press(v36.TricksoftheTradeFocus)) then
				return "tricks of the trade tank";
			end
		end
		v72 = v32.CrimsonVial();
		if (v72 or ((5006 - (103 + 1)) <= (4149 - (475 + 79)))) then
			return v72;
		end
		v72 = v32.Feint();
		if (v72 or ((8327 - 4475) == (937 - 644))) then
			return v72;
		end
		v32.Poisons();
		if ((not v13:AffectingCombat() and v37) or ((202 + 1357) == (4038 + 550))) then
			local v170 = 1503 - (1395 + 108);
			while true do
				if ((v170 == (0 - 0)) or ((5688 - (7 + 1197)) == (344 + 444))) then
					if (((1594 + 2974) >= (4226 - (27 + 292))) and v34.Stealth:IsCastable() and (v61 == "Always")) then
						v72 = v32.Stealth(v32.StealthSpell());
						if (((3650 - 2404) < (4425 - 955)) and v72) then
							return v72;
						end
					elseif (((17060 - 12992) >= (1916 - 944)) and v34.Stealth:IsCastable() and (v61 == "Distance") and v14:IsInRange(v62)) then
						v72 = v32.Stealth(v32.StealthSpell());
						if (((938 - 445) < (4032 - (43 + 96))) and v72) then
							return v72;
						end
					end
					if ((not v13:BuffUp(v34.ShadowDanceBuff) and not v13:BuffUp(v32.VanishBuffSpell())) or ((6008 - 4535) >= (7532 - 4200))) then
						local v209 = 0 + 0;
						while true do
							if (((0 + 0) == v209) or ((8006 - 3955) <= (444 + 713))) then
								v72 = v32.Stealth(v32.StealthSpell());
								if (((1131 - 527) < (907 + 1974)) and v72) then
									return v72;
								end
								break;
							end
						end
					end
					v170 = 1 + 0;
				end
				if ((v170 == (1752 - (1414 + 337))) or ((2840 - (1642 + 298)) == (8803 - 5426))) then
					if (((12827 - 8368) > (1753 - 1162)) and v31.TargetIsValid() and (v14:IsSpellInRange(v34.Shadowstrike) or v66)) then
						if (((1119 + 2279) >= (1864 + 531)) and v13:StealthUp(true, true)) then
							v73 = v99(true);
							if (v73 or ((3155 - (357 + 615)) >= (1983 + 841))) then
								if (((4749 - 2813) == (1659 + 277)) and (type(v73) == "table") and (#v73 > (2 - 1))) then
									if (v23(nil, unpack(v73)) or ((3865 + 967) < (294 + 4019))) then
										return "Stealthed Macro Cast or Pool (OOC): " .. v73[1 + 0]:Name();
									end
								elseif (((5389 - (384 + 917)) > (4571 - (128 + 569))) and v21(v73)) then
									return "Stealthed Cast or Pool (OOC): " .. v73:Name();
								end
							end
						elseif (((5875 - (1407 + 136)) == (6219 - (687 + 1200))) and (v79 >= (1715 - (556 + 1154)))) then
							local v216 = 0 - 0;
							while true do
								if (((4094 - (9 + 86)) >= (3321 - (275 + 146))) and (v216 == (0 + 0))) then
									v72 = v98();
									if (v72 or ((2589 - (29 + 35)) > (18011 - 13947))) then
										return v72 .. " (OOC)";
									end
									break;
								end
							end
						elseif (((13055 - 8684) == (19295 - 14924)) and v34.Backstab:IsCastable()) then
							if (v19(v34.Backstab) or ((174 + 92) > (5998 - (53 + 959)))) then
								return "Cast Backstab (OOC)";
							end
						end
					end
					return;
				end
			end
		end
		if (((2399 - (312 + 96)) >= (1605 - 680)) and v31.TargetIsValid()) then
			local v171 = 285 - (147 + 138);
			local v172;
			while true do
				if (((1354 - (813 + 86)) < (1856 + 197)) and (v171 == (0 - 0))) then
					if ((not v13:IsCasting() and not v13:IsChanneling()) or ((1318 - (18 + 474)) == (1637 + 3214))) then
						local v210 = 0 - 0;
						local v211;
						while true do
							if (((1269 - (860 + 226)) == (486 - (121 + 182))) and (v210 == (0 + 0))) then
								v211 = v31.Interrupt(v34.Kick, 1248 - (988 + 252), true);
								if (((131 + 1028) <= (561 + 1227)) and v211) then
									return v211;
								end
								v211 = v31.Interrupt(v34.Kick, 1978 - (49 + 1921), true, MouseOver, v36.KickMouseover);
								v210 = 891 - (223 + 667);
							end
							if (((54 - (51 + 1)) == v210) or ((6035 - 2528) > (9246 - 4928))) then
								v211 = v31.Interrupt(v34.Blind, 1140 - (146 + 979), BlindInterrupt, MouseOver, v36.BlindMouseover);
								if (v211 or ((868 + 2207) <= (3570 - (311 + 294)))) then
									return v211;
								end
								v211 = v31.InterruptWithStun(v34.CheapShot, 22 - 14, v13:StealthUp(false, false));
								v210 = 2 + 1;
							end
							if (((2808 - (496 + 947)) <= (3369 - (1233 + 125))) and (v210 == (2 + 1))) then
								if (v211 or ((2491 + 285) > (680 + 2895))) then
									return v211;
								end
								v211 = v31.InterruptWithStun(v34.KidneyShot, 1653 - (963 + 682), v13:ComboPoints() > (0 + 0));
								if (v211 or ((4058 - (504 + 1000)) == (3236 + 1568))) then
									return v211;
								end
								break;
							end
							if (((2347 + 230) == (244 + 2333)) and (v210 == (1 - 0))) then
								if (v211 or ((6 + 0) >= (1099 + 790))) then
									return v211;
								end
								v211 = v31.Interrupt(v34.Blind, 197 - (156 + 26), BlindInterrupt);
								if (((292 + 214) <= (2959 - 1067)) and v211) then
									return v211;
								end
								v210 = 166 - (149 + 15);
							end
						end
					end
					if ((v53 and v40 and v34.Shiv:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v31.UnitHasEnrageBuff(v14)) or ((2968 - (890 + 70)) > (2335 - (39 + 78)))) then
						if (((861 - (14 + 468)) <= (9119 - 4972)) and Press(v34.Shiv, not IsInMeleeRange)) then
							return "shiv dispel enrage";
						end
					end
					if ((v35.Healthstone:IsReady() and v54 and (v13:HealthPercentage() <= v55)) or ((12616 - 8102) <= (521 + 488))) then
						if (Press(v36.Healthstone, nil, nil, true) or ((2100 + 1396) == (254 + 938))) then
							return "healthstone defensive 3";
						end
					end
					if ((v50 and (v13:HealthPercentage() <= v52)) or ((94 + 114) == (776 + 2183))) then
						if (((8186 - 3909) >= (1298 + 15)) and (v51 == "Refreshing Healing Potion")) then
							if (((9090 - 6503) < (81 + 3093)) and v35.RefreshingHealingPotion:IsReady()) then
								if (Press(v36.RefreshingHealingPotion, nil, nil, true) or ((4171 - (12 + 39)) <= (2045 + 153))) then
									return "refreshing healing potion defensive 4";
								end
							end
						end
						if ((v51 == "Dreamwalker's Healing Potion") or ((4940 - 3344) == (3055 - 2197))) then
							if (((955 + 2265) == (1695 + 1525)) and v35.DreamwalkersHealingPotion:IsReady()) then
								if (Press(v36.RefreshingHealingPotion, nil, nil, true) or ((3554 - 2152) > (2412 + 1208))) then
									return "dreamwalker's healing potion defensive 4";
								end
							end
						end
					end
					v171 = 4 - 3;
				end
				if (((4284 - (1596 + 114)) == (6720 - 4146)) and (v171 == (715 - (164 + 549)))) then
					v172 = nil;
					if (((3236 - (1059 + 379)) < (3423 - 666)) and (not v34.Vigor:IsAvailable() or v34.Shadowcraft:IsAvailable())) then
						v172 = v13:EnergyDeficitPredicted() <= v88();
					else
						v172 = v13:EnergyPredicted() >= v88();
					end
					if (v172 or v34.InvigoratingShadowdust:IsAvailable() or ((196 + 181) > (439 + 2165))) then
						v72 = v102(v81);
						if (((960 - (145 + 247)) < (748 + 163)) and v72) then
							return "Stealth CDs: " .. v72;
						end
					end
					if (((1518 + 1767) < (12534 - 8306)) and (v78 >= v32.CPMaxSpend())) then
						v72 = v98();
						if (((752 + 3164) > (2867 + 461)) and v72) then
							return "Finish: " .. v72;
						end
					end
					v171 = 4 - 1;
				end
				if (((3220 - (254 + 466)) < (4399 - (544 + 16))) and ((9 - 6) == v171)) then
					if (((1135 - (294 + 334)) == (760 - (236 + 17))) and ((v80 <= (1 + 0)) or (v10.BossFilteredFightRemains("<=", 1 + 0) and (v78 >= (10 - 7))))) then
						local v212 = 0 - 0;
						while true do
							if (((124 + 116) <= (2607 + 558)) and (v212 == (794 - (413 + 381)))) then
								v72 = v98();
								if (((36 + 798) >= (1711 - 906)) and v72) then
									return "Finish: " .. v72;
								end
								break;
							end
						end
					end
					if (((v70 >= (9 - 5)) and (v78 >= (1974 - (582 + 1388)))) or ((6494 - 2682) < (1658 + 658))) then
						v72 = v98();
						if (v72 or ((3016 - (326 + 38)) <= (4534 - 3001))) then
							return "Finish: " .. v72;
						end
					end
					if (v75 or ((5135 - 1537) < (2080 - (47 + 573)))) then
						v83(v75);
					end
					v72 = v103(v81);
					v171 = 2 + 2;
				end
				if ((v171 == (16 - 12)) or ((6680 - 2564) < (2856 - (1269 + 395)))) then
					if (v72 or ((3869 - (76 + 416)) <= (1346 - (319 + 124)))) then
						return "Build: " .. v72;
					end
					if (((9088 - 5112) >= (1446 - (564 + 443))) and v39) then
						if (((10386 - 6634) == (4210 - (337 + 121))) and v34.ArcaneTorrent:IsReady() and v66 and (v13:EnergyDeficitPredicted() >= ((43 - 28) + v13:EnergyRegen())) and v49) then
							if (((13477 - 9431) > (4606 - (1261 + 650))) and v19(v34.ArcaneTorrent, nil)) then
								return "Cast Arcane Torrent";
							end
						end
						if ((v34.ArcanePulse:IsReady() and v66 and v49) or ((1500 + 2045) == (5095 - 1898))) then
							if (((4211 - (772 + 1045)) > (53 + 320)) and v19(v34.ArcanePulse, nil)) then
								return "Cast Arcane Pulse";
							end
						end
						if (((4299 - (102 + 42)) <= (6076 - (1524 + 320))) and v34.BagofTricks:IsReady() and v49) then
							if (v19(v34.BagofTricks, nil) or ((4851 - (1049 + 221)) == (3629 - (18 + 138)))) then
								return "Cast Bag of Tricks";
							end
						end
					end
					if (((12226 - 7231) > (4450 - (67 + 1035))) and v73 and v66) then
						if (((type(v73) == "table") and (#v73 > (349 - (136 + 212)))) or ((3203 - 2449) > (2984 + 740))) then
							if (((201 + 16) >= (1661 - (240 + 1364))) and v23(v13:EnergyTimeToX(v74), unpack(v73))) then
								return "Macro pool towards " .. v73[1083 - (1050 + 32)]:Name() .. " at " .. v74;
							end
						elseif (v73:IsCastable() or ((7391 - 5321) >= (2388 + 1649))) then
							v74 = v29(v74, v73:Cost());
							if (((3760 - (331 + 724)) == (219 + 2486)) and v21(v73, v13:EnergyTimeToX(v74))) then
								return "Pool towards: " .. v73:Name() .. " at " .. v74;
							end
						end
					end
					if (((705 - (269 + 375)) == (786 - (267 + 458))) and v34.ShurikenToss:IsCastable() and v14:IsInRange(10 + 20) and not v67 and not v13:StealthUp(true, true) and not v13:BuffUp(v34.Sprint) and (v13:EnergyDeficitPredicted() < (38 - 18)) and ((v80 >= (819 - (667 + 151))) or (v13:EnergyTimeToMax() <= (1498.2 - (1410 + 87))))) then
						if (v21(v34.ShurikenToss) or ((2596 - (1504 + 393)) >= (3503 - 2207))) then
							return "Cast Shuriken Toss";
						end
					end
					break;
				end
				if ((v171 == (2 - 1)) or ((2579 - (461 + 335)) >= (463 + 3153))) then
					v72 = v101();
					if (v72 or ((5674 - (1730 + 31)) > (6194 - (728 + 939)))) then
						return "CDs: " .. v72;
					end
					if (((15498 - 11122) > (1657 - 840)) and v34.SliceandDice:IsCastable() and (v70 < v32.CPMaxSpend()) and (v13:BuffRemains(v34.SliceandDice) < v13:GCD()) and v10.BossFilteredFightRemains(">", 13 - 7) and (v79 >= (1072 - (138 + 930)))) then
						local v213 = 0 + 0;
						while true do
							if (((3801 + 1060) > (707 + 117)) and ((0 - 0) == v213)) then
								if ((v34.SliceandDice:IsReady() and v19(v34.SliceandDice)) or ((3149 - (459 + 1307)) >= (4001 - (474 + 1396)))) then
									return "Cast Slice and Dice (Low Duration)";
								end
								v84(v34.SliceandDice);
								break;
							end
						end
					end
					if (v13:StealthUp(true, true) or ((3275 - 1399) >= (2382 + 159))) then
						v73 = v99(true);
						if (((6 + 1776) <= (10804 - 7032)) and v73) then
							if (((type(v73) == "table") and (#v73 > (1 + 0))) or ((15689 - 10989) < (3545 - 2732))) then
								if (((3790 - (562 + 29)) < (3453 + 597)) and v23(nil, unpack(v73))) then
									return "Stealthed Macro " .. v73[1420 - (374 + 1045)]:Name() .. "|" .. v73[2 + 0]:Name();
								end
							elseif ((v13:BuffUp(v34.ShurikenTornado) and (v79 ~= v13:ComboPoints()) and ((v73 == v34.BlackPowder) or (v73 == v34.Eviscerate) or (v73 == v34.Rupture) or (v73 == v34.SliceandDice))) or ((15373 - 10422) < (5068 - (448 + 190)))) then
								if (((31 + 65) == (44 + 52)) and v23(nil, v34.ShurikenTornado, v73)) then
									return "Stealthed Tornado Cast  " .. v73:Name();
								end
							elseif (v21(v73) or ((1785 + 954) > (15409 - 11401))) then
								return "Stealthed Cast " .. v73:Name();
							end
						end
						v19(v34.PoolEnergy);
						return "Stealthed Pooling";
					end
					v171 = 5 - 3;
				end
			end
		end
	end
	local function v107()
		v10.Print("Subtlety Rogue by Epic BoomK");
		EpicSettings.SetupVersion("Subtlety Rogue  X v 10.2.5.00 By BoomK");
	end
	v10.SetAPL(1755 - (1307 + 187), v106, v107);
end;
return v0["Epix_Rogue_Subtlety.lua"]();

