local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((3193 - (1051 + 786)) == (6923 - 3371))) then
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
	local v14 = v9.Spell;
	local v15 = v9.MultiSpell;
	local v16 = v9.Item;
	local v17 = v9.Utils.BoolToInt;
	local v18 = v9.Cast;
	local v19 = v9.CastLeftNameplate;
	local v20 = v9.CastPooling;
	local v21 = v9.CastQueue;
	local v22 = v11.Focus;
	local v23 = v9.Press;
	local v24 = v9.CastQueuePooling;
	local v25 = v9.Commons.Everyone.num;
	local v26 = v9.Commons.Everyone.bool;
	local v27 = pairs;
	local v28 = table.insert;
	local v29 = math.min;
	local v30 = math.max;
	local v31 = math.abs;
	local v32 = v9.Commons.Everyone;
	local v33 = v9.Commons.Rogue;
	local v34 = v9.Macro;
	local v35 = v14.Rogue.Subtlety;
	local v36 = v16.Rogue.Subtlety;
	local v37 = v34.Rogue.Subtlety;
	local v38 = false;
	local v39 = false;
	local v40 = false;
	local v41 = false;
	local v42 = false;
	local v43 = false;
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
	local v67 = {};
	local v68, v69, v70, v71;
	local v72, v73, v74, v75;
	local v76;
	local v77, v78, v79;
	local v80, v81;
	local v82, v83, v84, v85;
	local v86;
	v35.Eviscerate:RegisterDamageFormula(function()
		return v12:AttackPowerDamageMod() * v82 * (667.176 - (89 + 578)) * (1.21 + 0) * ((v35.Nightstalker:IsAvailable() and v12:StealthUp(true, false) and (1.08 - 0)) or (1050 - (572 + 477))) * ((v35.DeeperStratagem:IsAvailable() and (1.05 + 0)) or (1 + 0)) * ((v35.DarkShadow:IsAvailable() and v12:BuffUp(v35.ShadowDanceBuff) and (1.3 + 0)) or (87 - (84 + 2))) * ((v12:BuffUp(v35.SymbolsofDeath) and (1.1 - 0)) or (1 + 0)) * ((v12:BuffUp(v35.FinalityEviscerateBuff) and (843.3 - (497 + 345))) or (1 + 0)) * (1 + 0 + (v12:MasteryPct() / (1433 - (605 + 728)))) * (1 + 0 + (v12:VersatilityDmgPct() / (222 - 122))) * ((v13:DebuffUp(v35.FindWeaknessDebuff) and (1.5 + 0)) or (3 - 2));
	end);
	local function v87(v118, v119)
		if (((3729 + 407) >= (6641 - 4244)) and not v77) then
			local v174 = 0 + 0;
			while true do
				if ((v174 == (489 - (457 + 32))) or ((1839 + 2495) == (5647 - (832 + 570)))) then
					v77 = v118;
					v78 = v119 or (0 + 0);
					break;
				end
			end
		end
	end
	local function v88(v120)
		if (not v79 or ((1116 + 3160) <= (10725 - 7694))) then
			v79 = v120;
		end
	end
	local function v89()
		if (((v44 == "On Bosses not in Dungeons") and v12:IsInDungeonArea()) or ((2304 + 2478) <= (1995 - (588 + 208)))) then
			return false;
		elseif (((v44 ~= "Always") and not v13:IsInBossList()) or ((13109 - 8245) < (3702 - (884 + 916)))) then
			return false;
		else
			return true;
		end
	end
	local function v90()
		local v121 = 0 - 0;
		while true do
			if (((2806 + 2033) >= (4353 - (232 + 421))) and (v121 == (1889 - (1569 + 320)))) then
				if ((v74 < (1 + 1)) or ((205 + 870) > (6463 - 4545))) then
					return false;
				elseif (((1001 - (316 + 289)) <= (9957 - 6153)) and (v45 == "Always")) then
					return true;
				elseif (((v45 == "On Bosses") and v13:IsInBossList()) or ((193 + 3976) == (3640 - (666 + 787)))) then
					return true;
				elseif (((1831 - (360 + 65)) == (1314 + 92)) and (v45 == "Auto")) then
					if (((1785 - (79 + 175)) < (6734 - 2463)) and (v12:InstanceDifficulty() == (13 + 3)) and (v13:NPCID() == (425972 - 287005))) then
						return true;
					elseif (((1222 - 587) == (1534 - (503 + 396))) and ((v13:NPCID() == (167150 - (92 + 89))) or (v13:NPCID() == (323916 - 156945)) or (v13:NPCID() == (85629 + 81341)))) then
						return true;
					elseif (((1997 + 1376) <= (13925 - 10369)) and ((v13:NPCID() == (25089 + 158374)) or (v13:NPCID() == (418793 - 235122)))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v91(v122, v123, v124, v125)
		local v126 = 0 + 0;
		local v127;
		local v128;
		local v129;
		while true do
			if ((v126 == (1 + 0)) or ((10023 - 6732) < (410 + 2870))) then
				for v205, v206 in v27(v125) do
					if (((6688 - 2302) >= (2117 - (485 + 759))) and (v206:GUID() ~= v129) and v32.UnitIsCycleValid(v206, v128, -v206:DebuffRemains(v122)) and v123(v206)) then
						v127, v128 = v206, v206:TimeToDie();
					end
				end
				if (((2131 - 1210) <= (2291 - (442 + 747))) and v127 and (v13:GUID() == v127:GUID())) then
					v9.Press(v122);
				elseif (((5841 - (832 + 303)) >= (1909 - (88 + 858))) and v46) then
					local v214 = 0 + 0;
					while true do
						if ((v214 == (0 + 0)) or ((40 + 920) <= (1665 - (766 + 23)))) then
							v127, v128 = nil, v124;
							for v229, v230 in v27(v73) do
								if (((v230:GUID() ~= v129) and v32.UnitIsCycleValid(v230, v128, -v230:DebuffRemains(v122)) and v123(v230)) or ((10199 - 8133) == (1274 - 342))) then
									v127, v128 = v230, v230:TimeToDie();
								end
							end
							v214 = 2 - 1;
						end
						if (((16376 - 11551) < (5916 - (1036 + 37))) and (v214 == (1 + 0))) then
							if ((v127 and (v13:GUID() == v127:GUID())) or ((7549 - 3672) >= (3569 + 968))) then
								v9.Press(v122);
							end
							break;
						end
					end
				end
				break;
			end
			if ((v126 == (1480 - (641 + 839))) or ((5228 - (910 + 3)) < (4400 - 2674))) then
				v127, v128 = nil, v124;
				v129 = v13:GUID();
				v126 = 1685 - (1466 + 218);
			end
		end
	end
	local function v92()
		return 10 + 10 + (v35.Vigor:TalentRank() * (1173 - (556 + 592))) + (v25(v35.ThistleTea:IsAvailable()) * (8 + 12)) + (v25(v35.Shadowcraft:IsAvailable()) * (828 - (329 + 479)));
	end
	local function v93()
		return v35.ShadowDance:ChargesFractional() >= ((854.75 - (174 + 680)) + v17(v35.ShadowDanceTalent:IsAvailable()));
	end
	local function v94()
		return v84 >= (10 - 7);
	end
	local function v95()
		return v12:BuffUp(v35.SliceandDice) or (v74 >= v33.CPMaxSpend());
	end
	local function v96()
		return v35.Premeditation:IsAvailable() and (v74 < (10 - 5));
	end
	local function v97(v130)
		return (v12:BuffUp(v35.ThistleTea) and (v74 == (1 + 0))) or (v130 and ((v74 == (740 - (396 + 343))) or (v13:DebuffUp(v35.Rupture) and (v74 >= (1 + 1)))));
	end
	local function v98()
		return (not v12:BuffUp(v35.TheRotten) or not v12:HasTier(1507 - (29 + 1448), 1391 - (135 + 1254))) and (not v35.ColdBlood:IsAvailable() or (v35.ColdBlood:CooldownRemains() < (14 - 10)) or (v35.ColdBlood:CooldownRemains() > (46 - 36)));
	end
	local function v99(v131)
		return v12:BuffUp(v35.ShadowDanceBuff) and (v131:TimeSinceLastCast() < v35.ShadowDance:TimeSinceLastCast());
	end
	local function v100()
		return ((v99(v35.Shadowstrike) or v99(v35.ShurikenStorm)) and (v99(v35.Eviscerate) or v99(v35.BlackPowder) or v99(v35.Rupture))) or not v35.DanseMacabre:IsAvailable();
	end
	local function v101()
		return (not v36.WitherbarksBranch:IsEquipped() and not v36.AshesoftheEmbersoul:IsEquipped()) or (not v36.WitherbarksBranch:IsEquipped() and (v36.WitherbarksBranch:CooldownRemains() <= (6 + 2))) or (v36.WitherbarksBranch:IsEquipped() and (v36.WitherbarksBranch:CooldownRemains() <= (1535 - (389 + 1138)))) or v36.BandolierOfTwistedBlades:IsEquipped() or v35.InvigoratingShadowdust:IsAvailable();
	end
	local function v102(v132, v133)
		local v134 = 574 - (102 + 472);
		local v135;
		local v136;
		local v137;
		local v138;
		local v139;
		local v140;
		local v141;
		while true do
			if (((1 + 0) == v134) or ((2041 + 1638) < (583 + 42))) then
				v138 = v83;
				v139 = v35.ColdBlood:CooldownRemains();
				v140 = v35.SymbolsofDeath:CooldownRemains();
				v134 = 1547 - (320 + 1225);
			end
			if (((5 - 2) == v134) or ((2830 + 1795) < (2096 - (157 + 1307)))) then
				if ((v35.Rupture:IsCastable() and v35.Rupture:IsReady()) or ((1942 - (821 + 1038)) > (4441 - 2661))) then
					if (((60 + 486) <= (1912 - 835)) and v13:DebuffDown(v35.Rupture) and (v13:TimeToDie() > (3 + 3))) then
						if (v132 or ((2468 - 1472) > (5327 - (834 + 192)))) then
							return v35.Rupture;
						else
							if (((259 + 3811) > (177 + 510)) and v35.Rupture:IsReady() and v18(v35.Rupture)) then
								return "Cast Rupture";
							end
							v88(v35.Rupture);
						end
					end
				end
				if ((not v12:StealthUp(true, true) and not v96() and (v74 < (1 + 5)) and not v135 and v9.BossFilteredFightRemains(">", v12:BuffRemains(v35.SliceandDice)) and (v12:BuffRemains(v35.SliceandDice) < (((1 - 0) + v12:ComboPoints()) * (305.8 - (300 + 4))))) or ((176 + 480) >= (8717 - 5387))) then
					if (v132 or ((2854 - (112 + 250)) <= (134 + 201))) then
						return v35.SliceandDice;
					else
						if (((10827 - 6505) >= (1468 + 1094)) and v35.SliceandDice:IsReady() and v18(v35.SliceandDice)) then
							return "Cast Slice and Dice Premed";
						end
						v88(v35.SliceandDice);
					end
				end
				if (((not v97(v135) or v86) and (v13:TimeToDie() > (4 + 2)) and v13:DebuffRefreshable(v35.Rupture, v80)) or ((2721 + 916) >= (1870 + 1900))) then
					if (v132 or ((1768 + 611) > (5992 - (1001 + 413)))) then
						return v35.Rupture;
					else
						local v215 = 0 - 0;
						while true do
							if (((882 - (244 + 638)) == v215) or ((1176 - (627 + 66)) > (2213 - 1470))) then
								if (((3056 - (512 + 90)) > (2484 - (1665 + 241))) and v35.Rupture:IsReady() and v18(v35.Rupture)) then
									return "Cast Rupture";
								end
								v88(v35.Rupture);
								break;
							end
						end
					end
				end
				v134 = 721 - (373 + 344);
			end
			if (((420 + 510) < (1180 + 3278)) and (v134 == (15 - 9))) then
				return false;
			end
			if (((1119 - 457) <= (2071 - (35 + 1064))) and (v134 == (2 + 0))) then
				v141 = v12:BuffUp(v35.PremeditationBuff) or (v133 and v35.Premeditation:IsAvailable());
				if (((9349 - 4979) == (18 + 4352)) and v133 and (v133:ID() == v35.ShadowDance:ID())) then
					v135 = true;
					v136 = (1244 - (298 + 938)) + v35.ImprovedShadowDance:TalentRank();
					if (v35.TheFirstDance:IsAvailable() or ((6021 - (233 + 1026)) <= (2527 - (636 + 1030)))) then
						v138 = v29(v12:ComboPointsMax(), v83 + 3 + 1);
					end
					if (v12:HasTier(30 + 0, 1 + 1) or ((96 + 1316) == (4485 - (55 + 166)))) then
						v137 = v30(v137, 2 + 4);
					end
				end
				if ((v133 and (v133:ID() == v35.Vanish:ID())) or ((319 + 2849) < (8222 - 6069))) then
					local v208 = 297 - (36 + 261);
					while true do
						if ((v208 == (0 - 0)) or ((6344 - (34 + 1334)) < (513 + 819))) then
							v139 = v29(0 + 0, v35.ColdBlood:CooldownRemains() - ((1298 - (1035 + 248)) * v35.InvigoratingShadowdust:TalentRank()));
							v140 = v29(21 - (20 + 1), v35.SymbolsofDeath:CooldownRemains() - ((8 + 7) * v35.InvigoratingShadowdust:TalentRank()));
							break;
						end
					end
				end
				v134 = 322 - (134 + 185);
			end
			if (((5761 - (549 + 584)) == (5313 - (314 + 371))) and (v134 == (17 - 12))) then
				if ((not v97(v135) and v35.Rupture:IsCastable()) or ((1022 - (478 + 490)) == (210 + 185))) then
					if (((1254 - (786 + 386)) == (265 - 183)) and not v132 and v39 and not v86 and (v74 >= (1381 - (1055 + 324)))) then
						local function v216(v227)
							return v32.CanDoTUnit(v227, v81) and v227:DebuffRefreshable(v35.Rupture, v80);
						end
						v91(v35.Rupture, v216, (1342 - (1093 + 247)) * v138, v75);
					end
					if ((v70 and (v13:DebuffRemains(v35.Rupture) < (v140 + 9 + 1)) and (v140 <= (1 + 4)) and v33.CanDoTUnit(v13, v81) and v13:FilteredTimeToDie(">", (19 - 14) + v140, -v13:DebuffRemains(v35.Rupture))) or ((1971 - 1390) < (802 - 520))) then
						if (v132 or ((11581 - 6972) < (888 + 1607))) then
							return v35.Rupture;
						else
							if (((4437 - 3285) == (3970 - 2818)) and v35.Rupture:IsReady() and v18(v35.Rupture)) then
								return "Cast Rupture 2";
							end
							v88(v35.Rupture);
						end
					end
				end
				if (((1430 + 466) <= (8751 - 5329)) and v35.BlackPowder:IsCastable() and not v86 and (v74 >= (691 - (364 + 324))) and not v43) then
					if (v132 or ((2713 - 1723) > (3887 - 2267))) then
						return v35.BlackPowder;
					else
						local v217 = 0 + 0;
						while true do
							if ((v217 == (0 - 0)) or ((1403 - 526) > (14259 - 9564))) then
								if (((3959 - (1249 + 19)) >= (1671 + 180)) and v35.BlackPowder:IsReady() and v18(v35.BlackPowder)) then
									return "Cast Black Powder";
								end
								v88(v35.BlackPowder);
								break;
							end
						end
					end
				end
				if ((v35.Eviscerate:IsCastable() and v70) or ((11619 - 8634) >= (5942 - (686 + 400)))) then
					if (((3355 + 921) >= (1424 - (73 + 156))) and v132) then
						return v35.Eviscerate;
					else
						local v218 = 0 + 0;
						while true do
							if (((4043 - (721 + 90)) <= (53 + 4637)) and (v218 == (0 - 0))) then
								if ((v35.Eviscerate:IsReady() and v18(v35.Eviscerate)) or ((1366 - (224 + 246)) >= (5096 - 1950))) then
									return "Cast Eviscerate";
								end
								v88(v35.Eviscerate);
								break;
							end
						end
					end
				end
				v134 = 10 - 4;
			end
			if (((556 + 2505) >= (71 + 2887)) and (v134 == (0 + 0))) then
				v135 = v12:BuffUp(v35.ShadowDanceBuff);
				v136 = v12:BuffRemains(v35.ShadowDanceBuff);
				v137 = v12:BuffRemains(v35.SymbolsofDeath);
				v134 = 1 - 0;
			end
			if (((10605 - 7418) >= (1157 - (203 + 310))) and (v134 == (1997 - (1238 + 755)))) then
				if (((45 + 599) <= (2238 - (709 + 825))) and v12:BuffUp(v35.FinalityRuptureBuff) and v135 and (v74 <= (7 - 3)) and not v99(v35.Rupture)) then
					if (((1395 - 437) > (1811 - (196 + 668))) and v132) then
						return v35.Rupture;
					else
						if (((17735 - 13243) >= (5497 - 2843)) and v35.Rupture:IsReady() and v18(v35.Rupture)) then
							return "Cast Rupture Finality";
						end
						v88(v35.Rupture);
					end
				end
				if (((4275 - (171 + 662)) >= (1596 - (4 + 89))) and v35.ColdBlood:IsReady() and v100(v135, v141) and v35.SecretTechnique:IsReady() and (v83 >= (17 - 12))) then
					if (v132 or ((1155 + 2015) <= (6430 - 4966))) then
						return v35.ColdBlood;
					end
					if (v23(v37.ColdBloodTechnique, nil, nil, true) or ((1882 + 2915) == (5874 - (35 + 1451)))) then
						return "Cast Cold Blood (SecTec)";
					end
				end
				if (((2004 - (28 + 1425)) <= (2674 - (941 + 1052))) and v35.SecretTechnique:IsReady()) then
					if (((3143 + 134) > (1921 - (822 + 692))) and v100(v135, v141) and (not v35.ColdBlood:IsAvailable() or v12:BuffUp(v35.ColdBlood) or (v139 > (v136 - (2 - 0))) or not v35.ImprovedShadowDance:IsAvailable())) then
						if (((2212 + 2483) >= (1712 - (45 + 252))) and v132) then
							return v35.SecretTechnique;
						end
						if (v18(v35.SecretTechnique) or ((3179 + 33) <= (325 + 619))) then
							return "Cast Secret Technique";
						end
					end
				end
				v134 = 12 - 7;
			end
		end
	end
	local function v103(v142, v143)
		local v144 = v12:BuffUp(v35.ShadowDanceBuff);
		local v145 = v12:BuffRemains(v35.ShadowDanceBuff);
		local v146 = v12:BuffUp(v35.TheRottenBuff);
		local v147, v148 = v83, v84;
		local v149 = v12:BuffUp(v35.PremeditationBuff) or (v143 and v35.Premeditation:IsAvailable());
		local v150 = v12:BuffUp(v33.StealthSpell()) or (v143 and (v143:ID() == v33.StealthSpell():ID()));
		local v151 = v12:BuffUp(v33.VanishBuffSpell()) or (v143 and (v143:ID() == v35.Vanish:ID()));
		if ((v143 and (v143:ID() == v35.ShadowDance:ID())) or ((3529 - (114 + 319)) <= (2581 - 783))) then
			local v175 = 0 - 0;
			while true do
				if (((2255 + 1282) == (5268 - 1731)) and (v175 == (0 - 0))) then
					v144 = true;
					v145 = (1971 - (556 + 1407)) + v35.ImprovedShadowDance:TalentRank();
					v175 = 1207 - (741 + 465);
				end
				if (((4302 - (170 + 295)) >= (828 + 742)) and (v175 == (1 + 0))) then
					if ((v35.TheRotten:IsAvailable() and v12:HasTier(73 - 43, 2 + 0)) or ((1892 + 1058) == (2159 + 1653))) then
						v146 = true;
					end
					if (((5953 - (957 + 273)) >= (620 + 1698)) and v35.TheFirstDance:IsAvailable()) then
						v147 = v29(v12:ComboPointsMax(), v83 + 2 + 2);
						v148 = v12:ComboPointsMax() - v147;
					end
					break;
				end
			end
		end
		local v152 = v33.EffectiveComboPoints(v147);
		local v153 = v35.Shadowstrike:IsCastable() or v150 or v151 or v144 or v12:BuffUp(v35.SepsisBuff);
		if (v150 or v151 or ((7723 - 5696) > (7515 - 4663))) then
			v153 = v153 and v13:IsInRange(76 - 51);
		else
			v153 = v153 and v70;
		end
		if ((v153 and v150 and ((v74 < (19 - 15)) or v86)) or ((2916 - (389 + 1391)) > (2709 + 1608))) then
			if (((495 + 4253) == (10809 - 6061)) and v142) then
				return v35.Shadowstrike;
			elseif (((4687 - (783 + 168)) <= (15908 - 11168)) and v18(v35.Shadowstrike)) then
				return "Cast Shadowstrike (Stealth)";
			end
		end
		if ((v152 >= v33.CPMaxSpend()) or ((3335 + 55) <= (3371 - (309 + 2)))) then
			return v102(v142, v143);
		end
		if ((v12:BuffUp(v35.ShurikenTornado) and (v148 <= (5 - 3))) or ((2211 - (1090 + 122)) > (874 + 1819))) then
			return v102(v142, v143);
		end
		if (((1554 - 1091) < (412 + 189)) and (v84 <= ((1119 - (628 + 490)) + v25(v35.DeeperStratagem:IsAvailable() or v35.SecretStratagem:IsAvailable())))) then
			return v102(v142, v143);
		end
		if ((v35.Backstab:IsCastable() and not v149 and (v145 >= (1 + 2)) and v12:BuffUp(v35.ShadowBlades) and not v99(v35.Backstab) and v35.DanseMacabre:IsAvailable() and (v74 <= (7 - 4)) and not v146) or ((9976 - 7793) < (1461 - (431 + 343)))) then
			if (((9186 - 4637) == (13159 - 8610)) and v142) then
				if (((3691 + 981) == (598 + 4074)) and v143) then
					return v35.Backstab;
				else
					return {v35.Backstab,v35.Stealth};
				end
			elseif (v21(v35.Backstab, v35.Stealth) or ((672 + 2996) < (203 + 192))) then
				return "Cast Backstab (Stealth)";
			end
		end
		if (v35.Gloomblade:IsAvailable() or ((4335 - (28 + 141)) == (177 + 278))) then
			if ((not v149 and (v145 >= (3 - 0)) and v12:BuffUp(v35.ShadowBlades) and not v99(v35.Gloomblade) and v35.DanseMacabre:IsAvailable() and (v74 <= (3 + 1))) or ((5766 - (486 + 831)) == (6929 - 4266))) then
				if (v142 or ((15057 - 10780) < (565 + 2424))) then
					if (v143 or ((2750 - 1880) >= (5412 - (668 + 595)))) then
						return v35.Gloomblade;
					else
						return {v35.Gloomblade,v35.Stealth};
					end
				elseif (((6032 - 3820) < (3473 - (23 + 267))) and v21(v35.Gloomblade, v35.Stealth)) then
					return "Cast Gloomblade (Danse)";
				end
			end
		end
		if (((6590 - (1129 + 815)) > (3379 - (371 + 16))) and not v99(v35.Shadowstrike) and v12:BuffUp(v35.ShadowBlades)) then
			if (((3184 - (1326 + 424)) < (5882 - 2776)) and v142) then
				return v35.Shadowstrike;
			elseif (((2872 - 2086) < (3141 - (88 + 30))) and v18(v35.Shadowstrike)) then
				return "Cast Shadowstrike (Danse)";
			end
		end
		if ((not v149 and (v74 >= (775 - (720 + 51)))) or ((5432 - 2990) < (1850 - (421 + 1355)))) then
			if (((7481 - 2946) == (2228 + 2307)) and v142) then
				return v35.ShurikenStorm;
			elseif (v18(v35.ShurikenStorm) or ((4092 - (286 + 797)) <= (7695 - 5590))) then
				return "Cast Shuriken Storm";
			end
		end
		if (((3031 - 1201) < (4108 - (397 + 42))) and v153) then
			if (v142 or ((447 + 983) >= (4412 - (24 + 776)))) then
				return v35.Shadowstrike;
			elseif (((4133 - 1450) >= (3245 - (222 + 563))) and v18(v35.Shadowstrike)) then
				return "Cast Shadowstrike";
			end
		end
		return false;
	end
	local function v104(v154, v155)
		local v156 = v103(true, v154);
		if ((v42 and (v154:ID() == v35.Vanish:ID()) and (not v47 or not v156)) or ((3974 - 2170) >= (2358 + 917))) then
			local v176 = 190 - (23 + 167);
			while true do
				if ((v176 == (1798 - (690 + 1108))) or ((512 + 905) > (2994 + 635))) then
					if (((5643 - (40 + 808)) > (67 + 335)) and v18(v35.Vanish, nil)) then
						return "Cast Vanish";
					end
					return false;
				end
			end
		elseif (((18404 - 13591) > (3408 + 157)) and (v154:ID() == v35.Shadowmeld:ID()) and (not v48 or not v156)) then
			if (((2070 + 1842) == (2146 + 1766)) and v18(v35.Shadowmeld, nil)) then
				return "Cast Shadowmeld";
			end
			return false;
		elseif (((3392 - (47 + 524)) <= (3131 + 1693)) and (v154:ID() == v35.ShadowDance:ID()) and (not v49 or not v156)) then
			if (((4750 - 3012) <= (3282 - 1087)) and v18(v35.ShadowDance, nil)) then
				return "Cast Shadow Dance";
			end
			return false;
		end
		local v157 = {v154,v156};
		if (((2 + 39) <= (9347 - 6329)) and v155 and (v12:EnergyPredicted() < v155)) then
			v87(v157, v155);
			return false;
		end
		v76 = v21(unpack(v157));
		if (((819 + 1326) <= (4583 - (341 + 138))) and v76) then
			return "| " .. v157[1 + 1]:Name();
		end
		return false;
	end
	local function v105()
		local v158 = 0 - 0;
		while true do
			if (((3015 - (89 + 237)) < (15586 - 10741)) and (v158 == (0 - 0))) then
				if ((not v12:IsCasting() and not v12:IsChanneling()) or ((3203 - (581 + 300)) > (3842 - (855 + 365)))) then
					local v209 = v32.Interrupt(v35.Kick, 18 - 10, true);
					if (v209 or ((1481 + 3053) == (3317 - (1030 + 205)))) then
						return v209;
					end
					v209 = v32.Interrupt(v35.Kick, 8 + 0, true, MouseOver, v37.KickMouseover);
					if (v209 or ((1462 + 109) > (2153 - (156 + 130)))) then
						return v209;
					end
					v209 = v32.Interrupt(v35.Blind, 34 - 19, BlindInterrupt);
					if (v209 or ((4472 - 1818) >= (6135 - 3139))) then
						return v209;
					end
					v209 = v32.Interrupt(v35.Blind, 4 + 11, BlindInterrupt, MouseOver, v37.BlindMouseover);
					if (((2320 + 1658) > (2173 - (10 + 59))) and v209) then
						return v209;
					end
					v209 = v32.InterruptWithStun(v35.CheapShot, 3 + 5, v12:StealthUp(false, false));
					if (((14749 - 11754) > (2704 - (671 + 492))) and v209) then
						return v209;
					end
					v209 = v32.InterruptWithStun(v35.KidneyShot, 7 + 1, v12:ComboPoints() > (1215 - (369 + 846)));
					if (((861 + 2388) > (814 + 139)) and v209) then
						return v209;
					end
				end
				return false;
			end
		end
	end
	local function v106()
		local v159 = v32.HandleTopTrinket(v67, v40, 1985 - (1036 + 909), nil);
		if (v159 or ((2603 + 670) > (7677 - 3104))) then
			return v159;
		end
		local v159 = v32.HandleBottomTrinket(v67, v40, 243 - (11 + 192), nil);
		if (v159 or ((1593 + 1558) < (1459 - (135 + 40)))) then
			return v159;
		end
		return false;
	end
	local function v107()
		local v160 = 0 - 0;
		while true do
			if ((v160 == (0 + 0)) or ((4075 - 2225) == (2291 - 762))) then
				if (((997 - (50 + 126)) < (5911 - 3788)) and v40) then
					local v210 = 0 + 0;
					local v211;
					while true do
						if (((2315 - (1233 + 180)) < (3294 - (522 + 447))) and (v210 == (1421 - (107 + 1314)))) then
							v211 = v32.HandleDPSPotion(v9.BossFilteredFightRemains("<", 14 + 16) or (v12:BuffUp(v35.SymbolsofDeath) and (v12:BuffUp(v35.ShadowBlades) or (v35.ShadowBlades:CooldownRemains() <= (30 - 20)))));
							if (((365 + 493) <= (5881 - 2919)) and v211) then
								return v211;
							end
							break;
						end
					end
				end
				return false;
			end
		end
	end
	local function v108()
		if (v40 or ((15612 - 11666) < (3198 - (716 + 1194)))) then
			local v177 = 0 + 0;
			while true do
				if ((v177 == (0 + 0)) or ((3745 - (74 + 429)) == (1093 - 526))) then
					if ((v35.ArcaneTorrent:IsReady() and v70 and (v12:EnergyDeficitPredicted() >= (8 + 7 + v12:EnergyRegen())) and v52) or ((1938 - 1091) >= (894 + 369))) then
						if (v18(v35.ArcaneTorrent, nil) or ((6945 - 4692) == (4576 - 2725))) then
							return "Cast Arcane Torrent";
						end
					end
					if ((v35.ArcanePulse:IsReady() and v70 and v52) or ((2520 - (279 + 154)) > (3150 - (454 + 324)))) then
						if (v18(v35.ArcanePulse, nil) or ((3498 + 947) < (4166 - (12 + 5)))) then
							return "Cast Arcane Pulse";
						end
					end
					v177 = 1 + 0;
				end
				if (((2 - 1) == v177) or ((672 + 1146) == (1178 - (277 + 816)))) then
					if (((2692 - 2062) < (3310 - (1058 + 125))) and v35.BagofTricks:IsReady() and v52) then
						if (v18(v35.BagofTricks, nil) or ((364 + 1574) == (3489 - (815 + 160)))) then
							return "Cast Bag of Tricks";
						end
					end
					break;
				end
			end
		end
		if (((18256 - 14001) >= (130 - 75)) and v40 and v35.ColdBlood:IsReady() and not v35.SecretTechnique:IsAvailable() and (v83 >= (2 + 3))) then
			if (((8766 - 5767) > (3054 - (41 + 1857))) and v18(v35.ColdBlood, nil)) then
				return "Cast Cold Blood";
			end
		end
		if (((4243 - (1222 + 671)) > (2985 - 1830)) and v40 and v35.Sepsis:IsAvailable() and v35.Sepsis:IsReady()) then
			if (((5790 - 1761) <= (6035 - (229 + 953))) and v95() and v13:FilteredTimeToDie(">=", 1790 - (1111 + 663)) and (v12:BuffUp(v35.PerforatedVeins) or not v35.PerforatedVeins:IsAvailable())) then
				if (v18(v35.Sepsis, nil, nil) or ((2095 - (874 + 705)) > (481 + 2953))) then
					return "Cast Sepsis";
				end
			end
		end
		if (((2761 + 1285) >= (6304 - 3271)) and v40 and v35.Flagellation:IsAvailable() and v35.Flagellation:IsReady()) then
			if ((v95() and (v82 >= (1 + 4)) and (v13:TimeToDie() > (689 - (642 + 37))) and ((v101() and (v35.ShadowBlades:CooldownRemains() <= (1 + 2))) or v9.BossFilteredFightRemains("<=", 5 + 23) or ((v35.ShadowBlades:CooldownRemains() >= (34 - 20)) and v35.InvigoratingShadowdust:IsAvailable() and v35.ShadowDance:IsAvailable())) and (not v35.InvigoratingShadowdust:IsAvailable() or v35.Sepsis:IsAvailable() or not v35.ShadowDance:IsAvailable() or ((v35.InvigoratingShadowdust:TalentRank() == (456 - (233 + 221))) and (v74 >= (4 - 2))) or (v35.SymbolsofDeath:CooldownRemains() <= (3 + 0)) or (v12:BuffRemains(v35.SymbolsofDeath) > (1544 - (718 + 823))))) or ((1711 + 1008) <= (2252 - (266 + 539)))) then
				if (v18(v35.Flagellation, nil, nil) or ((11704 - 7570) < (5151 - (636 + 589)))) then
					return "Cast Flagellation";
				end
			end
		end
		if ((v40 and v35.SymbolsofDeath:IsReady()) or ((388 - 224) >= (5743 - 2958))) then
			if ((v95() and (not v12:BuffUp(v35.TheRotten) or not v12:HasTier(24 + 6, 1 + 1)) and (v12:BuffRemains(v35.SymbolsofDeath) <= (1018 - (657 + 358))) and (not v35.Flagellation:IsAvailable() or (v35.Flagellation:CooldownRemains() > (26 - 16)) or ((v12:BuffRemains(v35.ShadowDance) >= (4 - 2)) and v35.InvigoratingShadowdust:IsAvailable()) or (v35.Flagellation:IsReady() and (v82 >= (1192 - (1151 + 36))) and not v35.InvigoratingShadowdust:IsAvailable()))) or ((507 + 18) == (555 + 1554))) then
				if (((98 - 65) == (1865 - (1552 + 280))) and v18(v35.SymbolsofDeath, nil)) then
					return "Cast Symbols of Death";
				end
			end
		end
		if (((3888 - (64 + 770)) <= (2726 + 1289)) and v40 and v35.ShadowBlades:IsReady()) then
			if (((4247 - 2376) < (601 + 2781)) and v95() and ((v82 <= (1244 - (157 + 1086))) or v12:HasTier(61 - 30, 17 - 13)) and (v12:BuffUp(v35.Flagellation) or v12:BuffUp(v35.FlagellationPersistBuff) or not v35.Flagellation:IsAvailable())) then
				if (((1982 - 689) <= (2955 - 789)) and v18(v35.ShadowBlades, nil)) then
					return "Cast Shadow Blades";
				end
			end
		end
		if ((v40 and v35.EchoingReprimand:IsCastable() and v35.EchoingReprimand:IsAvailable()) or ((3398 - (599 + 220)) < (244 - 121))) then
			if ((v95() and (v84 >= (1934 - (1813 + 118)))) or ((619 + 227) >= (3585 - (841 + 376)))) then
				if (v18(v35.EchoingReprimand, nil, nil) or ((5621 - 1609) <= (781 + 2577))) then
					return "Cast Echoing Reprimand";
				end
			end
		end
		if (((4077 - 2583) <= (3864 - (464 + 395))) and v40 and v66 and v35.ShurikenTornado:IsAvailable() and v35.ShurikenTornado:IsReady()) then
			if ((v95() and v12:BuffUp(v35.SymbolsofDeath) and (v82 <= (5 - 3)) and not v12:BuffUp(v35.Premeditation) and (not v35.Flagellation:IsAvailable() or (v35.Flagellation:CooldownRemains() > (10 + 10))) and (v74 >= (840 - (467 + 370)))) or ((6428 - 3317) == (1567 + 567))) then
				if (((8072 - 5717) == (368 + 1987)) and v18(v35.ShurikenTornado, nil)) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if ((v40 and v66 and v35.ShurikenTornado:IsAvailable() and v35.ShurikenTornado:IsReady()) or ((1367 - 779) <= (952 - (150 + 370)))) then
			if (((6079 - (74 + 1208)) >= (9580 - 5685)) and v95() and not v12:BuffUp(v35.ShadowDance) and not v12:BuffUp(v35.Flagellation) and not v12:BuffUp(v35.FlagellationPersistBuff) and not v12:BuffUp(v35.ShadowBlades) and (v74 <= (9 - 7))) then
				if (((2546 + 1031) == (3967 - (14 + 376))) and v18(v35.ShurikenTornado, nil)) then
					return "Cast Shuriken Tornado";
				end
			end
		end
		if (((6580 - 2786) > (2390 + 1303)) and v40 and v35.ShadowDance:IsAvailable() and v89() and v35.ShadowDance:IsReady()) then
			if ((not v12:BuffUp(v35.ShadowDance) and v9.BossFilteredFightRemains("<=", 8 + 0 + ((3 + 0) * v25(v35.Subterfuge:IsAvailable())))) or ((3735 - 2460) == (3085 + 1015))) then
				if (v18(v35.ShadowDance) or ((1669 - (23 + 55)) >= (8484 - 4904))) then
					return "Cast Shadow Dance";
				end
			end
		end
		if (((656 + 327) <= (1624 + 184)) and v40 and v35.GoremawsBite:IsAvailable() and v35.GoremawsBite:IsReady()) then
			if ((v95() and (v84 >= (4 - 1)) and (not v35.ShadowDance:IsReady() or (v35.ShadowDance:IsAvailable() and v12:BuffUp(v35.ShadowDance) and not v35.InvigoratingShadowdust:IsAvailable()) or ((v74 < (2 + 2)) and not v35.InvigoratingShadowdust:IsAvailable()) or v35.TheRotten:IsAvailable())) or ((3051 - (652 + 249)) <= (3203 - 2006))) then
				if (((5637 - (708 + 1160)) >= (3183 - 2010)) and v18(v35.GoremawsBite)) then
					return "Cast Goremaw's Bite";
				end
			end
		end
		if (((2707 - 1222) == (1512 - (10 + 17))) and v35.ThistleTea:IsReady()) then
			if ((((v35.SymbolsofDeath:CooldownRemains() >= (1 + 2)) or v12:BuffUp(v35.SymbolsofDeath)) and not v12:BuffUp(v35.ThistleTea) and (((v12:EnergyDeficitPredicted() >= (1832 - (1400 + 332))) and ((v84 >= (3 - 1)) or (v74 >= (1911 - (242 + 1666))))) or ((v35.ThistleTea:ChargesFractional() >= ((1.75 + 1) - ((0.15 + 0) * v35.InvigoratingShadowdust:TalentRank()))) and (v35.Vanish:IsReady() or not v42) and v12:BuffUp(v35.ShadowDance) and v13:DebuffUp(v35.Rupture) and (v74 < (3 + 0))))) or ((v12:BuffRemains(v35.ShadowDance) >= (944 - (850 + 90))) and not v12:BuffUp(v35.ThistleTea) and (v74 >= (4 - 1))) or (not v12:BuffUp(v35.ThistleTea) and v9.BossFilteredFightRemains("<=", (1396 - (360 + 1030)) * v35.ThistleTea:Charges())) or ((2934 + 381) <= (7851 - 5069))) then
				if (v18(v35.ThistleTea, nil, nil) or ((1204 - 328) >= (4625 - (909 + 752)))) then
					return "Thistle Tea";
				end
			end
		end
		local v161 = v12:BuffUp(v35.ShadowBlades) or (not v35.ShadowBlades:IsAvailable() and v12:BuffUp(v35.SymbolsofDeath)) or v9.BossFilteredFightRemains("<", 1243 - (109 + 1114));
		if ((v35.BloodFury:IsCastable() and v161 and v52) or ((4085 - 1853) > (972 + 1525))) then
			if (v18(v35.BloodFury, nil) or ((2352 - (6 + 236)) <= (210 + 122))) then
				return "Cast Blood Fury";
			end
		end
		if (((2967 + 719) > (7480 - 4308)) and v35.Berserking:IsCastable() and v161 and v52) then
			if (v18(v35.Berserking, nil) or ((7814 - 3340) < (1953 - (1076 + 57)))) then
				return "Cast Berserking";
			end
		end
		if (((704 + 3575) >= (3571 - (579 + 110))) and v35.Fireblood:IsCastable() and v161 and v52) then
			if (v18(v35.Fireblood, nil) or ((161 + 1868) >= (3114 + 407))) then
				return "Cast Fireblood";
			end
		end
		if ((v35.AncestralCall:IsCastable() and v161 and v52) or ((1082 + 955) >= (5049 - (174 + 233)))) then
			if (((4804 - 3084) < (7824 - 3366)) and v18(v35.AncestralCall, nil)) then
				return "Cast Ancestral Call";
			end
		end
		if (v35.ThistleTea:IsReady() or ((194 + 242) > (4195 - (663 + 511)))) then
			if (((637 + 76) <= (184 + 663)) and ((((v35.SymbolsofDeath:CooldownRemains() >= (9 - 6)) or v12:BuffUp(v35.SymbolsofDeath)) and not v12:BuffUp(v35.ThistleTea) and (((v12:EnergyDeficitPredicted() >= (61 + 39)) and ((v12:ComboPointsDeficit() >= (4 - 2)) or (v74 >= (7 - 4)))) or ((v35.ThistleTea:ChargesFractional() >= (1.75 + 1)) and v12:BuffUp(v35.ShadowDanceBuff)))) or ((v12:BuffRemains(v35.ShadowDanceBuff) >= (7 - 3)) and not v12:BuffUp(v35.ThistleTea) and (v74 >= (3 + 0))) or (not v12:BuffUp(v35.ThistleTea) and v9.BossFilteredFightRemains("<=", (1 + 5) * v35.ThistleTea:Charges())))) then
				if (((2876 - (478 + 244)) <= (4548 - (440 + 77))) and v18(v35.ThistleTea, nil, nil)) then
					return "Thistle Tea";
				end
			end
		end
		return false;
	end
	local function v109(v162)
		local v163 = 0 + 0;
		while true do
			if (((16891 - 12276) == (6171 - (655 + 901))) and (v163 == (0 + 0))) then
				if ((v40 and not (v32.IsSoloMode() and v12:IsTanking(v13))) or ((2902 + 888) == (338 + 162))) then
					if (((358 - 269) < (1666 - (695 + 750))) and v42 and v35.Vanish:IsCastable()) then
						if (((7013 - 4959) >= (2192 - 771)) and ((v84 > (3 - 2)) or (v12:BuffUp(v35.ShadowBlades) and v35.InvigoratingShadowdust:IsAvailable())) and not v93() and ((v35.Flagellation:CooldownRemains() >= (411 - (285 + 66))) or not v35.Flagellation:IsAvailable() or v9.BossFilteredFightRemains("<=", (69 - 39) * v35.Vanish:Charges())) and ((v35.SymbolsofDeath:CooldownRemains() > (1313 - (682 + 628))) or not v12:HasTier(5 + 25, 301 - (176 + 123))) and ((v35.SecretTechnique:CooldownRemains() >= (5 + 5)) or not v35.SecretTechnique:IsAvailable() or ((v35.Vanish:Charges() >= (2 + 0)) and v35.InvigoratingShadowdust:IsAvailable() and (v12:BuffUp(v35.TheRotten) or not v35.TheRotten:IsAvailable())))) then
							local v228 = 269 - (239 + 30);
							while true do
								if (((189 + 503) < (2940 + 118)) and (v228 == (0 - 0))) then
									v76 = v104(v35.Vanish, v162);
									if (v76 or ((10152 - 6898) == (1970 - (306 + 9)))) then
										return "Vanish Macro " .. v76;
									end
									break;
								end
							end
						end
					end
					if ((v52 and v50 and (v12:Energy() < (139 - 99)) and v35.Shadowmeld:IsCastable()) or ((226 + 1070) == (3013 + 1897))) then
						if (((1622 + 1746) == (9631 - 6263)) and v20(v35.Shadowmeld, v12:EnergyTimeToX(1415 - (1140 + 235)))) then
							return "Pool for Shadowmeld";
						end
					end
					if (((1682 + 961) < (3499 + 316)) and v52 and v35.Shadowmeld:IsCastable() and v70 and not v12:IsMoving() and (v12:EnergyPredicted() >= (11 + 29)) and (v12:EnergyDeficitPredicted() >= (62 - (33 + 19))) and not v93() and (v84 > (2 + 2))) then
						v76 = v104(v35.Shadowmeld, v162);
						if (((5733 - 3820) > (218 + 275)) and v76) then
							return "Shadowmeld Macro " .. v76;
						end
					end
				end
				if (((9324 - 4569) > (3215 + 213)) and v70 and v35.ShadowDance:IsCastable()) then
					if (((2070 - (586 + 103)) <= (216 + 2153)) and (v13:DebuffUp(v35.Rupture) or v35.InvigoratingShadowdust:IsAvailable()) and v98() and (not v35.TheFirstDance:IsAvailable() or (v84 >= (12 - 8)) or v12:BuffUp(v35.ShadowBlades)) and ((v94() and v93()) or ((v12:BuffUp(v35.ShadowBlades) or (v12:BuffUp(v35.SymbolsofDeath) and not v35.Sepsis:IsAvailable()) or ((v12:BuffRemains(v35.SymbolsofDeath) >= (1492 - (1309 + 179))) and not v12:HasTier(54 - 24, 1 + 1)) or (not v12:BuffUp(v35.SymbolsofDeath) and v12:HasTier(80 - 50, 2 + 0))) and (v35.SecretTechnique:CooldownRemains() < ((21 - 11) + ((23 - 11) * v25(not v35.InvigoratingShadowdust:IsAvailable() or v12:HasTier(639 - (295 + 314), 4 - 2)))))))) then
						local v219 = 1962 - (1300 + 662);
						while true do
							if ((v219 == (0 - 0)) or ((6598 - (1178 + 577)) == (2121 + 1963))) then
								v76 = v104(v35.ShadowDance, v162);
								if (((13802 - 9133) > (1768 - (851 + 554))) and v76) then
									return "ShadowDance Macro 1 " .. v76;
								end
								break;
							end
						end
					end
				end
				v163 = 1 + 0;
			end
			if ((v163 == (2 - 1)) or ((4076 - 2199) >= (3440 - (115 + 187)))) then
				return false;
			end
		end
	end
	local function v110(v164)
		local v165 = 0 + 0;
		local v166;
		while true do
			if (((4490 + 252) >= (14288 - 10662)) and (v165 == (1162 - (160 + 1001)))) then
				if (v70 or ((3972 + 568) == (633 + 283))) then
					if (v35.Gloomblade:IsCastable() or ((2366 - 1210) > (4703 - (237 + 121)))) then
						if (((3134 - (525 + 372)) < (8055 - 3806)) and v166 and v18(v35.Gloomblade)) then
							return "Cast Gloomblade";
						end
						v87(v35.Gloomblade, v164);
					elseif (v35.Backstab:IsCastable() or ((8815 - 6132) < (165 - (96 + 46)))) then
						if (((1474 - (643 + 134)) <= (299 + 527)) and v166 and v18(v35.Backstab)) then
							return "Cast Backstab";
						end
						v87(v35.Backstab, v164);
					end
				end
				return false;
			end
			if (((2649 - 1544) <= (4366 - 3190)) and (v165 == (0 + 0))) then
				v166 = not v164 or (v12:EnergyPredicted() >= v164);
				if (((6630 - 3251) <= (7791 - 3979)) and v39 and v35.ShurikenStorm:IsCastable() and (v74 >= ((721 - (316 + 403)) + v17((v35.Gloomblade:IsAvailable() and (v12:BuffRemains(v35.LingeringShadowBuff) >= (4 + 2))) or v12:BuffUp(v35.PerforatedVeinsBuff))))) then
					local v212 = 0 - 0;
					while true do
						if (((0 + 0) == v212) or ((1984 - 1196) >= (1146 + 470))) then
							if (((598 + 1256) <= (11707 - 8328)) and v166 and v18(v35.ShurikenStorm)) then
								return "Cast Shuriken Storm";
							end
							v87(v35.ShurikenStorm, v164);
							break;
						end
					end
				end
				v165 = 4 - 3;
			end
		end
	end
	local function v111()
		if (((9449 - 4900) == (261 + 4288)) and v56 and v41 and v35.Shiv:IsReady() and not v12:IsCasting() and not v12:IsChanneling() and v32.UnitHasEnrageBuff(v13)) then
			if (v23(v35.Shiv, not IsInMeleeRange) or ((5948 - 2926) >= (148 + 2876))) then
				return "shiv dispel enrage";
			end
		end
		if (((14180 - 9360) > (2215 - (12 + 5))) and v36.Healthstone:IsReady() and v57 and (v12:HealthPercentage() <= v58)) then
			if (v23(v37.Healthstone, nil, nil, true) or ((4120 - 3059) >= (10435 - 5544))) then
				return "healthstone defensive 3";
			end
		end
		if (((2899 - 1535) <= (11092 - 6619)) and v53 and (v12:HealthPercentage() <= v55)) then
			local v178 = 0 + 0;
			while true do
				if ((v178 == (1973 - (1656 + 317))) or ((3204 + 391) <= (3 + 0))) then
					if ((v54 == "Refreshing Healing Potion") or ((12422 - 7750) == (18957 - 15105))) then
						if (((1913 - (5 + 349)) == (7404 - 5845)) and v36.RefreshingHealingPotion:IsReady()) then
							if (v23(v37.RefreshingHealingPotion, nil, nil, true) or ((3023 - (266 + 1005)) <= (520 + 268))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v54 == "Dreamwalker's Healing Potion") or ((13331 - 9424) == (232 - 55))) then
						if (((5166 - (561 + 1135)) > (722 - 167)) and v36.DreamwalkersHealingPotion:IsReady()) then
							if (v23(v37.RefreshingHealingPotion, nil, nil, true) or ((3194 - 2222) == (1711 - (507 + 559)))) then
								return "dreamwalker's healing potion defensive 4";
							end
						end
					end
					break;
				end
			end
		end
		return false;
	end
	local function v112()
		if (((7984 - 4802) >= (6541 - 4426)) and not v12:AffectingCombat() and v38) then
			if (((4281 - (212 + 176)) < (5334 - (250 + 655))) and v35.Stealth:IsCastable() and (v64 == "Always")) then
				v76 = v33.Stealth(v33.StealthSpell());
				if (v76 or ((7818 - 4951) < (3328 - 1423))) then
					return v76;
				end
			elseif ((v35.Stealth:IsCastable() and (v64 == "Distance") and v13:IsInRange(v65)) or ((2809 - 1013) >= (6007 - (1869 + 87)))) then
				local v213 = 0 - 0;
				while true do
					if (((3520 - (484 + 1417)) <= (8050 - 4294)) and (v213 == (0 - 0))) then
						v76 = v33.Stealth(v33.StealthSpell());
						if (((1377 - (48 + 725)) == (986 - 382)) and v76) then
							return v76;
						end
						break;
					end
				end
			end
			if ((not v12:BuffUp(v35.ShadowDanceBuff) and not v12:BuffUp(v33.VanishBuffSpell())) or ((12030 - 7546) == (524 + 376))) then
				local v207 = 0 - 0;
				while true do
					if ((v207 == (0 + 0)) or ((1300 + 3159) <= (1966 - (152 + 701)))) then
						v76 = v33.Stealth(v33.StealthSpell());
						if (((4943 - (430 + 881)) > (1302 + 2096)) and v76) then
							return v76;
						end
						break;
					end
				end
			end
			if (((4977 - (557 + 338)) <= (1454 + 3463)) and v32.TargetIsValid() and (v13:IsSpellInRange(v35.Shadowstrike) or v70)) then
				if (((13616 - 8784) >= (4853 - 3467)) and v12:StealthUp(true, true)) then
					v77 = v103(true);
					if (((363 - 226) == (295 - 158)) and v77) then
						if (((type(v77) == "table") and (#v77 > (802 - (499 + 302)))) or ((2436 - (39 + 827)) >= (11958 - 7626))) then
							if (v24(nil, unpack(v77)) or ((9075 - 5011) <= (7224 - 5405))) then
								return "Stealthed Macro Cast or Pool (OOC): " .. v77[1 - 0]:Name();
							end
						elseif (v20(v77) or ((427 + 4559) < (4606 - 3032))) then
							return "Stealthed Cast or Pool (OOC): " .. v77:Name();
						end
					end
				elseif (((709 + 3717) > (271 - 99)) and (v83 >= (109 - (103 + 1)))) then
					v76 = v102();
					if (((1140 - (475 + 79)) > (983 - 528)) and v76) then
						return v76 .. " (OOC)";
					end
				elseif (((2643 - 1817) == (107 + 719)) and v35.Backstab:IsCastable()) then
					if (v18(v35.Backstab) or ((3538 + 481) > (5944 - (1395 + 108)))) then
						return "Cast Backstab (OOC)";
					end
				end
			end
			return;
		end
	end
	local v113 = {{v35.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v35.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v83 > (0 - 0);
	end},{v35.CheapShot,"Cast Cheap Shot (Interrupt)",function()
		return v12:StealthUp(true, true);
	end}};
	local function v114()
		v38 = EpicSettings.Toggles['ooc'];
		v39 = EpicSettings.Toggles['aoe'];
		v40 = EpicSettings.Toggles['cds'];
		v41 = EpicSettings.Toggles['dispel'];
		v42 = EpicSettings.Toggles['vanish'];
		v43 = EpicSettings.Toggles['funnel'];
	end
	local function v115()
		local v173 = 0 + 0;
		while true do
			if (((570 + 1447) < (8421 - 4160)) and (v173 == (2 + 3))) then
				v66 = EpicSettings.Settings['UseShurikenTornado'];
				v64 = EpicSettings.Settings['UsageStealthOOC'];
				v65 = EpicSettings.Settings['StealthRange'] or (0 - 0);
				break;
			end
			if (((1485 + 3231) > (6 + 74)) and ((1752 - (1414 + 337)) == v173)) then
				v48 = EpicSettings.Settings['StealthMacroShadowmeld'];
				v49 = EpicSettings.Settings['StealthMacroShadowDance'];
				v50 = EpicSettings.Settings['PoolForShadowmeld'];
				v51 = EpicSettings.Settings['EviscerateDMGOffset'] or (1941 - (1642 + 298));
				v173 = 4 - 2;
			end
			if ((v173 == (11 - 7)) or ((10407 - 6900) == (1077 + 2195))) then
				v60 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v61 = EpicSettings.Settings['InterruptThreshold'];
				v62 = EpicSettings.Settings['AutoFocusTank'];
				v63 = EpicSettings.Settings['AutoTricksTank'];
				v173 = 4 + 1;
			end
			if (((975 - (357 + 615)) == v173) or ((615 + 261) >= (7544 - 4469))) then
				v56 = EpicSettings.Settings['DispelBuffs'];
				v57 = EpicSettings.Settings['UseHealthstone'];
				v58 = EpicSettings.Settings['HealthstoneHP'] or (1 + 0);
				v59 = EpicSettings.Settings['InterruptWithStun'];
				v173 = 8 - 4;
			end
			if (((3481 + 871) > (174 + 2380)) and (v173 == (2 + 0))) then
				v52 = EpicSettings.Settings['UseRacials'];
				v53 = EpicSettings.Settings['UseHealingPotion'];
				v54 = EpicSettings.Settings['HealingPotionName'];
				v55 = EpicSettings.Settings['HealingPotionHP'] or (1302 - (384 + 917));
				v173 = 700 - (128 + 569);
			end
			if ((v173 == (1543 - (1407 + 136))) or ((6293 - (687 + 1200)) < (5753 - (556 + 1154)))) then
				v44 = EpicSettings.Settings['BurnShadowDance'];
				v45 = EpicSettings.Settings['UsePriorityRotation'];
				v46 = EpicSettings.Settings['RangedMultiDoT'];
				v47 = EpicSettings.Settings['StealthMacroVanish'];
				v173 = 3 - 2;
			end
		end
	end
	local function v116()
		v115();
		v114();
		v77 = nil;
		v79 = nil;
		v78 = 95 - (9 + 86);
		v68 = (v35.AcrobaticStrikes:IsAvailable() and (429 - (275 + 146))) or (1 + 4);
		v69 = (v35.AcrobaticStrikes:IsAvailable() and (77 - (29 + 35))) or (44 - 34);
		v70 = v13:IsInMeleeRange(v68);
		v71 = v13:IsInMeleeRange(v69);
		if (v39 or ((5641 - 3752) >= (14934 - 11551))) then
			local v179 = 0 + 0;
			while true do
				if (((2904 - (53 + 959)) <= (3142 - (312 + 96))) and (v179 == (1 - 0))) then
					v74 = #v73;
					v75 = v12:GetEnemiesInMeleeRange(v68);
					break;
				end
				if (((2208 - (147 + 138)) < (3117 - (813 + 86))) and (v179 == (0 + 0))) then
					v72 = v12:GetEnemiesInRange(55 - 25);
					v73 = v12:GetEnemiesInMeleeRange(v69);
					v179 = 493 - (18 + 474);
				end
			end
		else
			v72 = {};
			v73 = {};
			v74 = 1 + 0;
			v75 = {};
		end
		v83 = v12:ComboPoints();
		v82 = v33.EffectiveComboPoints(v83);
		v84 = v12:ComboPointsDeficit();
		v86 = v90();
		v85 = v12:EnergyMax() - v92();
		if (((7092 - 4919) > (1465 - (860 + 226))) and v12:BuffUp(v35.ShurikenTornado, nil, true) and (v83 < v33.CPMaxSpend())) then
			local v180 = 303 - (121 + 182);
			local v181;
			while true do
				if ((v180 == (0 + 0)) or ((3831 - (988 + 252)) == (386 + 3023))) then
					v181 = v33.TimeToNextTornado();
					if (((1414 + 3100) > (5294 - (49 + 1921))) and ((v181 <= v12:GCDRemains()) or (v31(v12:GCDRemains() - v181) < (890.25 - (223 + 667))))) then
						local v220 = 52 - (51 + 1);
						local v221;
						while true do
							if ((v220 == (1 - 0)) or ((445 - 237) >= (5953 - (146 + 979)))) then
								v84 = v30(v84 - v221, 0 + 0);
								if ((v82 < v33.CPMaxSpend()) or ((2188 - (311 + 294)) > (9947 - 6380))) then
									v82 = v83;
								end
								break;
							end
							if ((v220 == (0 + 0)) or ((2756 - (496 + 947)) == (2152 - (1233 + 125)))) then
								v221 = v74 + v25(v12:BuffUp(v35.ShadowBlades));
								v83 = v29(v83 + v221, v33.CPMaxSpend());
								v220 = 1 + 0;
							end
						end
					end
					break;
				end
			end
		end
		v80 = (4 + 0 + (v82 * (1 + 3))) * (1645.3 - (963 + 682));
		v81 = v35.Eviscerate:Damage() * v51;
		if (((2649 + 525) > (4406 - (504 + 1000))) and not v12:AffectingCombat() and v62) then
			local v182 = 0 + 0;
			local v183;
			while true do
				if (((3752 + 368) <= (402 + 3858)) and (v182 == (0 - 0))) then
					v183 = v32.FocusUnit(false, nil, nil, "TANK", 18 + 2);
					if (v183 or ((514 + 369) > (4960 - (156 + 26)))) then
						return v183;
					end
					break;
				end
			end
		end
		if ((v22 and v63 and (v32.UnitGroupRole(v22) == "TANK") and v35.TricksoftheTrade:IsCastable()) or ((2086 + 1534) >= (7652 - 2761))) then
			if (((4422 - (149 + 15)) > (1897 - (890 + 70))) and v23(v37.TricksoftheTradeFocus)) then
				return "tricks of the trade tank";
			end
		end
		v76 = v33.CrimsonVial();
		if (v76 or ((4986 - (39 + 78)) < (1388 - (14 + 468)))) then
			return v76;
		end
		v76 = v33.Feint();
		if (v76 or ((2693 - 1468) > (11817 - 7589))) then
			return v76;
		end
		v33.Poisons();
		v76 = v112();
		if (((1718 + 1610) > (1344 + 894)) and v76) then
			return v76;
		end
		if (((816 + 3023) > (635 + 770)) and v32.TargetIsValid()) then
			local v184 = 0 + 0;
			local v185;
			while true do
				if ((v184 == (9 - 4)) or ((1278 + 15) <= (1781 - 1274))) then
					if (v76 or ((74 + 2822) < (856 - (12 + 39)))) then
						return "Build: " .. v76;
					end
					if (((2155 + 161) == (7168 - 4852)) and v77 and v70) then
						if (((type(v77) == "table") and (#v77 > (3 - 2))) or ((762 + 1808) == (807 + 726))) then
							if (v24(v12:EnergyTimeToX(v78), unpack(v77)) or ((2238 - 1355) == (973 + 487))) then
								return "Macro pool towards " .. v77[4 - 3]:Name() .. " at " .. v78;
							end
						elseif (v77:IsCastable() or ((6329 - (1596 + 114)) <= (2607 - 1608))) then
							v78 = v30(v78, v77:Cost());
							if (v20(v77, v12:EnergyTimeToX(v78)) or ((4123 - (164 + 549)) > (5554 - (1059 + 379)))) then
								return "Pool towards: " .. v77:Name() .. " at " .. v78;
							end
						end
					end
					if ((v35.ShurikenToss:IsCastable() and v13:IsInRange(37 - 7) and not v71 and not v12:StealthUp(true, true) and not v12:BuffUp(v35.Sprint) and (v12:EnergyDeficitPredicted() < (11 + 9)) and ((v84 >= (1 + 0)) or (v12:EnergyTimeToMax() <= (393.2 - (145 + 247))))) or ((741 + 162) >= (1414 + 1645))) then
						if (v20(v35.ShurikenToss) or ((11787 - 7811) < (549 + 2308))) then
							return "Cast Shuriken Toss";
						end
					end
					break;
				end
				if (((4247 + 683) > (3745 - 1438)) and (v184 == (720 - (254 + 466)))) then
					v76 = v105();
					if (ShoulReturn or ((4606 - (544 + 16)) < (4102 - 2811))) then
						return "Interrupts " .. v76;
					end
					v76 = v111();
					if (ShoulReturn or ((4869 - (294 + 334)) == (3798 - (236 + 17)))) then
						return v76;
					end
					v184 = 1 + 0;
				end
				if ((v184 == (1 + 0)) or ((15245 - 11197) > (20036 - 15804))) then
					v76 = v108();
					if (v76 or ((902 + 848) >= (2861 + 612))) then
						return "CDs: " .. v76;
					end
					v76 = v106();
					if (((3960 - (413 + 381)) == (134 + 3032)) and v76) then
						return "Trinkets";
					end
					v184 = 3 - 1;
				end
				if (((4579 - 2816) < (5694 - (582 + 1388))) and ((6 - 2) == v184)) then
					if (((41 + 16) <= (3087 - (326 + 38))) and ((v84 <= (2 - 1)) or (v9.BossFilteredFightRemains("<=", 1 - 0) and (v82 >= (623 - (47 + 573)))))) then
						v76 = v102();
						if (v76 or ((730 + 1340) == (1881 - 1438))) then
							return "Finish: " .. v76;
						end
					end
					if (((v74 >= (5 - 1)) and (v82 >= (1668 - (1269 + 395)))) or ((3197 - (76 + 416)) == (1836 - (319 + 124)))) then
						local v222 = 0 - 0;
						while true do
							if ((v222 == (1007 - (564 + 443))) or ((12737 - 8136) < (519 - (337 + 121)))) then
								v76 = v102();
								if (v76 or ((4072 - 2682) >= (15802 - 11058))) then
									return "Finish: " .. v76;
								end
								break;
							end
						end
					end
					if (v79 or ((3914 - (1261 + 650)) > (1623 + 2211))) then
						v87(v79);
					end
					v76 = v110(v85);
					v184 = 7 - 2;
				end
				if ((v184 == (1819 - (772 + 1045))) or ((23 + 133) > (4057 - (102 + 42)))) then
					v76 = v107();
					if (((2039 - (1524 + 320)) == (1465 - (1049 + 221))) and v76) then
						return "DPS Potion";
					end
					if (((3261 - (18 + 138)) >= (4396 - 2600)) and v35.SliceandDice:IsCastable() and (v74 < v33.CPMaxSpend()) and (v12:BuffRemains(v35.SliceandDice) < v12:GCD()) and v9.BossFilteredFightRemains(">", 1108 - (67 + 1035)) and (v83 >= (352 - (136 + 212)))) then
						local v223 = 0 - 0;
						while true do
							if (((3509 + 870) >= (1965 + 166)) and (v223 == (1604 - (240 + 1364)))) then
								if (((4926 - (1050 + 32)) >= (7294 - 5251)) and v35.SliceandDice:IsReady() and v18(v35.SliceandDice)) then
									return "Cast Slice and Dice (Low Duration)";
								end
								v88(v35.SliceandDice);
								break;
							end
						end
					end
					if (v12:StealthUp(true, true) or ((1912 + 1320) <= (3786 - (331 + 724)))) then
						local v224 = 0 + 0;
						while true do
							if (((5549 - (269 + 375)) == (5630 - (267 + 458))) and (v224 == (0 + 0))) then
								v77 = v103(true);
								if (v77 or ((7953 - 3817) >= (5229 - (667 + 151)))) then
									if (((type(v77) == "table") and (#v77 > (1498 - (1410 + 87)))) or ((4855 - (1504 + 393)) == (10857 - 6840))) then
										if (((3185 - 1957) >= (1609 - (461 + 335))) and v24(nil, unpack(v77))) then
											return "Stealthed Macro " .. v77[1 + 0]:Name() .. "|" .. v77[1763 - (1730 + 31)]:Name();
										end
									elseif ((v66 and v12:BuffUp(v35.ShurikenTornado) and (v83 ~= v12:ComboPoints()) and ((v77 == v35.BlackPowder) or (v77 == v35.Eviscerate) or (v77 == v35.Rupture) or (v77 == v35.SliceandDice))) or ((5122 - (728 + 939)) > (14343 - 10293))) then
										if (((492 - 249) == (556 - 313)) and v24(nil, v35.ShurikenTornado, v77)) then
											return "Stealthed Tornado Cast  " .. v77:Name();
										end
									elseif ((type(v77) ~= "boolean") or ((1339 - (138 + 930)) > (1437 + 135))) then
										if (((2142 + 597) < (2823 + 470)) and v20(v77)) then
											return "Stealthed Cast " .. v77:Name();
										end
									end
								end
								v224 = 4 - 3;
							end
							if ((v224 == (1767 - (459 + 1307))) or ((5812 - (474 + 1396)) < (1979 - 845))) then
								v18(v35.PoolEnergy);
								return "Stealthed Pooling";
							end
						end
					end
					v184 = 3 + 0;
				end
				if ((v184 == (1 + 2)) or ((7713 - 5020) == (631 + 4342))) then
					v185 = nil;
					if (((7163 - 5017) == (9358 - 7212)) and (not v35.Vigor:IsAvailable() or v35.Shadowcraft:IsAvailable())) then
						v185 = v12:EnergyDeficitPredicted() <= v92();
					else
						v185 = v12:EnergyPredicted() >= v92();
					end
					if (v185 or v35.InvigoratingShadowdust:IsAvailable() or ((2835 - (562 + 29)) == (2749 + 475))) then
						local v225 = 1419 - (374 + 1045);
						while true do
							if ((v225 == (0 + 0)) or ((15227 - 10323) <= (2554 - (448 + 190)))) then
								v76 = v109(v85);
								if (((30 + 60) <= (481 + 584)) and v76) then
									return "Stealth CDs: " .. v76;
								end
								break;
							end
						end
					end
					if (((3129 + 1673) == (18462 - 13660)) and (v82 >= v33.CPMaxSpend())) then
						local v226 = 0 - 0;
						while true do
							if ((v226 == (1494 - (1307 + 187))) or ((9041 - 6761) <= (1196 - 685))) then
								v76 = v102();
								if (v76 or ((5138 - 3462) <= (1146 - (232 + 451)))) then
									return "Finish: " .. v76;
								end
								break;
							end
						end
					end
					v184 = 4 + 0;
				end
			end
		end
	end
	local function v117()
		v9.Print("Subtlety Rogue by Epic BoomK");
		EpicSettings.SetupVersion("Subtlety Rogue  X v 10.2.5.05 By BoomK");
	end
	v9.SetAPL(231 + 30, v116, v117);
end;
return v0["Epix_Rogue_Subtlety.lua"]();

