local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((13672 - 10342) > (323 + 333)) and not v5) then
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
	local v22 = v9.CastQueuePooling;
	local v23 = v9.Commons.Everyone.num;
	local v24 = v9.Commons.Everyone.bool;
	local v25 = pairs;
	local v26 = table.insert;
	local v27 = math.min;
	local v28 = math.max;
	local v29 = math.abs;
	local v30 = v9.Commons.Everyone;
	local v31 = v9.Commons.Rogue;
	local v32 = v9.Macro;
	local v33 = v14.Rogue.Subtlety;
	local v34 = v16.Rogue.Subtlety;
	local v35 = v32.Rogue.Subtlety;
	local v36 = false;
	local v37 = false;
	local v38 = false;
	local v39 = false;
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
	local v62 = {v34.Mirror:ID(),v34.WitherbarksBranch:ID(),v34.AshesoftheEmbersoul:ID()};
	local v63, v64, v65, v66;
	local v67, v68, v69, v70;
	local v71;
	local v72, v73, v74;
	local v75, v76;
	local v77, v78, v79, v80;
	local v81;
	v33.Eviscerate:RegisterDamageFormula(function()
		return v12:AttackPowerDamageMod() * v77 * (0.176 - 0) * (361.21 - (151 + 209)) * ((v33.Nightstalker:IsAvailable() and v12:StealthUp(true, false) and (1.08 + 0)) or (1481 - (641 + 839))) * ((v33.DeeperStratagem:IsAvailable() and (914.05 - (910 + 3))) or (2 - 1)) * ((v33.DarkShadow:IsAvailable() and v12:BuffUp(v33.ShadowDanceBuff) and (1685.3 - (1466 + 218))) or (1 + 0)) * ((v12:BuffUp(v33.SymbolsofDeath) and (1149.1 - (556 + 592))) or (1 + 0)) * ((v12:BuffUp(v33.FinalityEviscerateBuff) and (809.3 - (329 + 479))) or (855 - (174 + 680))) * ((3 - 2) + (v12:MasteryPct() / (207 - 107))) * (1 + 0 + (v12:VersatilityDmgPct() / (839 - (396 + 343)))) * ((v13:DebuffUp(v33.FindWeaknessDebuff) and (1.5 + 0)) or (1478 - (29 + 1448)));
	end);
	local function v82(v107, v108)
		if (not v72 or ((3881 - (135 + 1254)) <= (1262 - 927))) then
			local v161 = 0 - 0;
			while true do
				if (((2881 + 1441) >= (4089 - (389 + 1138))) and (v161 == (574 - (102 + 472)))) then
					v72 = v107;
					v73 = v108 or (0 + 0);
					break;
				end
			end
		end
	end
	local function v83(v109)
		if (not v74 or ((2017 + 1620) >= (3516 + 254))) then
			v74 = v109;
		end
	end
	local function v84()
		if (((v40 == "On Bosses not in Dungeons") and v12:IsInDungeonArea()) or ((3924 - (320 + 1225)) > (8149 - 3571))) then
			return false;
		elseif (((v40 ~= "Always") and not v13:IsInBossList()) or ((296 + 187) > (2207 - (157 + 1307)))) then
			return false;
		else
			return true;
		end
	end
	local function v85()
		if (((4313 - (821 + 1038)) > (1442 - 864)) and (v69 < (1 + 1))) then
			return false;
		elseif (((1651 - 721) < (1659 + 2799)) and (v41 == "Always")) then
			return true;
		elseif (((1640 - 978) <= (1998 - (834 + 192))) and (v41 == "On Bosses") and v13:IsInBossList()) then
			return true;
		elseif (((278 + 4092) == (1122 + 3248)) and (v41 == "Auto")) then
			if (((v12:InstanceDifficulty() == (1 + 15)) and (v13:NPCID() == (215287 - 76320))) or ((5066 - (300 + 4)) <= (230 + 631))) then
				return true;
			elseif ((v13:NPCID() == (437084 - 270115)) or (v13:NPCID() == (167333 - (112 + 250))) or (v13:NPCID() == (66562 + 100408)) or ((3537 - 2125) == (2443 + 1821))) then
				return true;
			elseif ((v13:NPCID() == (94880 + 88583)) or (v13:NPCID() == (137366 + 46305)) or ((1571 + 1597) < (1600 + 553))) then
				return true;
			end
		end
		return false;
	end
	local function v86(v110, v111, v112, v113)
		local v114 = 1414 - (1001 + 413);
		local v115;
		local v116;
		local v117;
		while true do
			if ((v114 == (2 - 1)) or ((5858 - (244 + 638)) < (2025 - (627 + 66)))) then
				for v188, v189 in v25(v113) do
					if (((13789 - 9161) == (5230 - (512 + 90))) and (v189:GUID() ~= v117) and v30.UnitIsCycleValid(v189, v116, -v189:DebuffRemains(v110)) and v111(v189)) then
						v115, v116 = v189, v189:TimeToDie();
					end
				end
				if ((v115 and (v13:GUID() == v115:GUID())) or ((1960 - (1665 + 241)) == (1112 - (373 + 344)))) then
					v9.Press(v110);
				elseif (((37 + 45) == (22 + 60)) and v42) then
					local v208 = 0 - 0;
					while true do
						if ((v208 == (1 - 0)) or ((1680 - (35 + 1064)) < (206 + 76))) then
							if ((v115 and (v13:GUID() == v115:GUID())) or ((9860 - 5251) < (10 + 2485))) then
								v9.Press(v110);
							end
							break;
						end
						if (((2388 - (298 + 938)) == (2411 - (233 + 1026))) and (v208 == (1666 - (636 + 1030)))) then
							v115, v116 = nil, v112;
							for v224, v225 in v25(v68) do
								if (((970 + 926) <= (3343 + 79)) and (v225:GUID() ~= v117) and v30.UnitIsCycleValid(v225, v116, -v225:DebuffRemains(v110)) and v111(v225)) then
									v115, v116 = v225, v225:TimeToDie();
								end
							end
							v208 = 1 + 0;
						end
					end
				end
				break;
			end
			if ((v114 == (0 + 0)) or ((1211 - (55 + 166)) > (314 + 1306))) then
				v115, v116 = nil, v112;
				v117 = v13:GUID();
				v114 = 1 + 0;
			end
		end
	end
	local function v87()
		return (76 - 56) + (v33.Vigor:TalentRank() * (322 - (36 + 261))) + (v23(v33.ThistleTea:IsAvailable()) * (34 - 14)) + (v23(v33.Shadowcraft:IsAvailable()) * (1388 - (34 + 1334)));
	end
	local function v88()
		return v33.ShadowDance:ChargesFractional() >= (0.75 + 0 + v17(v33.ShadowDanceTalent:IsAvailable()));
	end
	local function v89()
		return v79 >= (3 + 0);
	end
	local function v90()
		return v12:BuffUp(v33.SliceandDice) or (v69 >= v31.CPMaxSpend());
	end
	local function v91()
		return v33.Premeditation:IsAvailable() and (v69 < (1288 - (1035 + 248)));
	end
	local function v92(v118)
		return (v12:BuffUp(v33.ThistleTea) and (v69 == (22 - (20 + 1)))) or (v118 and ((v69 == (1 + 0)) or (v13:DebuffUp(v33.Rupture) and (v69 >= (321 - (134 + 185))))));
	end
	local function v93()
		return (not v12:BuffUp(v33.TheRotten) or not v12:HasTier(1163 - (549 + 584), 687 - (314 + 371))) and (not v33.ColdBlood:IsAvailable() or (v33.ColdBlood:CooldownRemains() < (13 - 9)) or (v33.ColdBlood:CooldownRemains() > (978 - (478 + 490))));
	end
	local function v94(v119)
		return v12:BuffUp(v33.ShadowDanceBuff) and (v119:TimeSinceLastCast() < v33.ShadowDance:TimeSinceLastCast());
	end
	local function v95()
		return ((v94(v33.Shadowstrike) or v94(v33.ShurikenStorm)) and (v94(v33.Eviscerate) or v94(v33.BlackPowder) or v94(v33.Rupture))) or not v33.DanseMacabre:IsAvailable();
	end
	local function v96()
		return (not v34.WitherbarksBranch:IsEquipped() and not v34.AshesoftheEmbersoul:IsEquipped()) or (not v34.WitherbarksBranch:IsEquipped() and (v34.WitherbarksBranch:CooldownRemains() <= (5 + 3))) or (v34.WitherbarksBranch:IsEquipped() and (v34.WitherbarksBranch:CooldownRemains() <= (1180 - (786 + 386)))) or v34.BandolierOfTwistedBlades:IsEquipped() or v33.InvigoratingShadowdust:IsAvailable();
	end
	local function v97(v120, v121)
		local v122 = 0 - 0;
		local v123;
		local v124;
		local v125;
		local v126;
		local v127;
		local v128;
		local v129;
		while true do
			if ((v122 == (1381 - (1055 + 324))) or ((2217 - (1093 + 247)) > (4173 + 522))) then
				v129 = v12:BuffUp(v33.PremeditationBuff) or (v121 and v33.Premeditation:IsAvailable());
				if (((283 + 2408) >= (7348 - 5497)) and v121 and (v121:ID() == v33.ShadowDance:ID())) then
					v123 = true;
					v124 = (26 - 18) + v33.ImprovedShadowDance:TalentRank();
					if (v33.TheFirstDance:IsAvailable() or ((8493 - 5508) >= (12202 - 7346))) then
						v126 = v27(v12:ComboPointsMax(), v78 + 2 + 2);
					end
					if (((16472 - 12196) >= (4118 - 2923)) and v12:HasTier(23 + 7, 4 - 2)) then
						v125 = v28(v125, 694 - (364 + 324));
					end
				end
				if (((8859 - 5627) <= (11254 - 6564)) and v121 and (v121:ID() == v33.Vanish:ID())) then
					local v201 = 0 + 0;
					while true do
						if ((v201 == (0 - 0)) or ((1434 - 538) >= (9554 - 6408))) then
							v127 = v27(1268 - (1249 + 19), v33.ColdBlood:CooldownRemains() - ((14 + 1) * v33.InvigoratingShadowdust:TalentRank()));
							v128 = v27(0 - 0, v33.SymbolsofDeath:CooldownRemains() - ((1101 - (686 + 400)) * v33.InvigoratingShadowdust:TalentRank()));
							break;
						end
					end
				end
				v122 = 3 + 0;
			end
			if (((3290 - (73 + 156)) >= (14 + 2944)) and ((816 - (721 + 90)) == v122)) then
				if (((36 + 3151) >= (2090 - 1446)) and not v92(v123) and v33.Rupture:IsCastable()) then
					local v202 = 470 - (224 + 246);
					while true do
						if (((1042 - 398) <= (1295 - 591)) and (v202 == (0 + 0))) then
							if (((23 + 935) > (696 + 251)) and not v120 and v37 and not v81 and (v69 >= (3 - 1))) then
								local v222 = 0 - 0;
								local v223;
								while true do
									if (((5005 - (203 + 310)) >= (4647 - (1238 + 755))) and (v222 == (0 + 0))) then
										v223 = nil;
										function v223(v228)
											return v30.CanDoTUnit(v228, v76) and v228:DebuffRefreshable(v33.Rupture, v75);
										end
										v222 = 1535 - (709 + 825);
									end
									if (((6342 - 2900) >= (2188 - 685)) and (v222 == (865 - (196 + 668)))) then
										v86(v33.Rupture, v223, (7 - 5) * v126, v70);
										break;
									end
								end
							end
							if ((v65 and (v13:DebuffRemains(v33.Rupture) < (v128 + (20 - 10))) and (v128 <= (838 - (171 + 662))) and v31.CanDoTUnit(v13, v76) and v13:FilteredTimeToDie(">", (98 - (4 + 89)) + v128, -v13:DebuffRemains(v33.Rupture))) or ((11110 - 7940) <= (534 + 930))) then
								if (v120 or ((21069 - 16272) == (1721 + 2667))) then
									return v33.Rupture;
								else
									local v226 = 1486 - (35 + 1451);
									while true do
										if (((2004 - (28 + 1425)) <= (2674 - (941 + 1052))) and (v226 == (0 + 0))) then
											if (((4791 - (822 + 692)) > (580 - 173)) and v33.Rupture:IsReady() and v18(v33.Rupture)) then
												return "Cast Rupture 2";
											end
											v83(v33.Rupture);
											break;
										end
									end
								end
							end
							break;
						end
					end
				end
				if (((2212 + 2483) >= (1712 - (45 + 252))) and v33.BlackPowder:IsCastable() and not v81 and (v69 >= (3 + 0))) then
					if (v120 or ((1106 + 2106) <= (2297 - 1353))) then
						return v33.BlackPowder;
					else
						local v209 = 433 - (114 + 319);
						while true do
							if ((v209 == (0 - 0)) or ((3967 - 871) <= (1147 + 651))) then
								if (((5268 - 1731) == (7410 - 3873)) and v33.BlackPowder:IsReady() and v18(v33.BlackPowder)) then
									return "Cast Black Powder";
								end
								v83(v33.BlackPowder);
								break;
							end
						end
					end
				end
				if (((5800 - (556 + 1407)) >= (2776 - (741 + 465))) and v33.Eviscerate:IsCastable() and v65) then
					if (v120 or ((3415 - (170 + 295)) == (2009 + 1803))) then
						return v33.Eviscerate;
					else
						local v210 = 0 + 0;
						while true do
							if (((11627 - 6904) >= (1922 + 396)) and (v210 == (0 + 0))) then
								if ((v33.Eviscerate:IsReady() and v18(v33.Eviscerate)) or ((1148 + 879) > (4082 - (957 + 273)))) then
									return "Cast Eviscerate";
								end
								v83(v33.Eviscerate);
								break;
							end
						end
					end
				end
				v122 = 2 + 4;
			end
			if ((v122 == (3 + 3)) or ((4328 - 3192) > (11376 - 7059))) then
				return false;
			end
			if (((14502 - 9754) == (23510 - 18762)) and (v122 == (1781 - (389 + 1391)))) then
				v126 = v78;
				v127 = v33.ColdBlood:CooldownRemains();
				v128 = v33.SymbolsofDeath:CooldownRemains();
				v122 = 2 + 0;
			end
			if (((389 + 3347) <= (10791 - 6051)) and ((954 - (783 + 168)) == v122)) then
				if ((v33.Rupture:IsCastable() and v33.Rupture:IsReady()) or ((11377 - 7987) <= (3010 + 50))) then
					if ((v13:DebuffDown(v33.Rupture) and (v13:TimeToDie() > (317 - (309 + 2)))) or ((3067 - 2068) > (3905 - (1090 + 122)))) then
						if (((151 + 312) < (2018 - 1417)) and v120) then
							return v33.Rupture;
						else
							local v220 = 0 + 0;
							while true do
								if ((v220 == (1118 - (628 + 490))) or ((392 + 1791) < (1700 - 1013))) then
									if (((20788 - 16239) == (5323 - (431 + 343))) and v33.Rupture:IsReady() and v18(v33.Rupture)) then
										return "Cast Rupture";
									end
									v83(v33.Rupture);
									break;
								end
							end
						end
					end
				end
				if (((9435 - 4763) == (13515 - 8843)) and not v12:StealthUp(true, true) and not v91() and (v69 < (5 + 1)) and not v123 and v9.BossFilteredFightRemains(">", v12:BuffRemains(v33.SliceandDice)) and (v12:BuffRemains(v33.SliceandDice) < ((1 + 0 + v12:ComboPoints()) * (1696.8 - (556 + 1139))))) then
					if (v120 or ((3683 - (6 + 9)) < (73 + 322))) then
						return v33.SliceandDice;
					else
						local v211 = 0 + 0;
						while true do
							if ((v211 == (169 - (28 + 141))) or ((1614 + 2552) == (561 - 106))) then
								if ((v33.SliceandDice:IsReady() and v18(v33.SliceandDice)) or ((3152 + 1297) == (3980 - (486 + 831)))) then
									return "Cast Slice and Dice Premed";
								end
								v83(v33.SliceandDice);
								break;
							end
						end
					end
				end
				if (((not v92(v123) or v81) and (v13:TimeToDie() > (15 - 9)) and v13:DebuffRefreshable(v33.Rupture, v75)) or ((15057 - 10780) < (565 + 2424))) then
					if (v120 or ((2750 - 1880) >= (5412 - (668 + 595)))) then
						return v33.Rupture;
					else
						local v212 = 0 + 0;
						while true do
							if (((446 + 1766) < (8680 - 5497)) and ((290 - (23 + 267)) == v212)) then
								if (((6590 - (1129 + 815)) > (3379 - (371 + 16))) and v33.Rupture:IsReady() and v18(v33.Rupture)) then
									return "Cast Rupture";
								end
								v83(v33.Rupture);
								break;
							end
						end
					end
				end
				v122 = 1754 - (1326 + 424);
			end
			if (((2715 - 1281) < (11350 - 8244)) and (v122 == (118 - (88 + 30)))) then
				v123 = v12:BuffUp(v33.ShadowDanceBuff);
				v124 = v12:BuffRemains(v33.ShadowDanceBuff);
				v125 = v12:BuffRemains(v33.SymbolsofDeath);
				v122 = 772 - (720 + 51);
			end
			if (((1748 - 962) < (4799 - (421 + 1355))) and (v122 == (6 - 2))) then
				if ((v12:BuffUp(v33.FinalityRuptureBuff) and v123 and (v69 <= (2 + 2)) and not v94(v33.Rupture)) or ((3525 - (286 + 797)) < (270 - 196))) then
					if (((7511 - 2976) == (4974 - (397 + 42))) and v120) then
						return v33.Rupture;
					else
						local v213 = 0 + 0;
						while true do
							if ((v213 == (800 - (24 + 776))) or ((4635 - 1626) <= (2890 - (222 + 563)))) then
								if (((4032 - 2202) < (2642 + 1027)) and v33.Rupture:IsReady() and v18(v33.Rupture)) then
									return "Cast Rupture Finality";
								end
								v83(v33.Rupture);
								break;
							end
						end
					end
				end
				if ((v33.ColdBlood:IsReady() and v95(v123, v129) and v33.SecretTechnique:IsReady()) or ((1620 - (23 + 167)) >= (5410 - (690 + 1108)))) then
					if (((969 + 1714) >= (2030 + 430)) and v120) then
						return v33.ColdBlood;
					end
					if (v18(v33.ColdBlood) or ((2652 - (40 + 808)) >= (540 + 2735))) then
						return "Cast Cold Blood (SecTec)";
					end
				end
				if (v33.SecretTechnique:IsReady() or ((5418 - 4001) > (3469 + 160))) then
					if (((2537 + 2258) > (221 + 181)) and v95(v123, v129) and (not v33.ColdBlood:IsAvailable() or v12:BuffUp(v33.ColdBlood) or (v127 > (v124 - (573 - (47 + 524)))) or not v33.ImprovedShadowDance:IsAvailable())) then
						local v214 = 0 + 0;
						while true do
							if (((13156 - 8343) > (5330 - 1765)) and (v214 == (0 - 0))) then
								if (((5638 - (1165 + 561)) == (117 + 3795)) and v120) then
									return v33.SecretTechnique;
								end
								if (((8737 - 5916) <= (1841 + 2983)) and v18(v33.SecretTechnique)) then
									return "Cast Secret Technique";
								end
								break;
							end
						end
					end
				end
				v122 = 484 - (341 + 138);
			end
		end
	end
	local function v98(v130, v131)
		local v132 = v12:BuffUp(v33.ShadowDanceBuff);
		local v133 = v12:BuffRemains(v33.ShadowDanceBuff);
		local v134 = v12:BuffUp(v33.TheRottenBuff);
		local v135, v136 = v78, v79;
		local v137 = v12:BuffUp(v33.PremeditationBuff) or (v131 and v33.Premeditation:IsAvailable());
		local v138 = v12:BuffUp(v31.StealthSpell()) or (v131 and (v131:ID() == v31.StealthSpell():ID()));
		local v139 = v12:BuffUp(v31.VanishBuffSpell()) or (v131 and (v131:ID() == v33.Vanish:ID()));
		if (((470 + 1268) <= (4529 - 2334)) and v131 and (v131:ID() == v33.ShadowDance:ID())) then
			local v162 = 326 - (89 + 237);
			while true do
				if (((131 - 90) <= (6353 - 3335)) and (v162 == (882 - (581 + 300)))) then
					if (((3365 - (855 + 365)) <= (9747 - 5643)) and v33.TheRotten:IsAvailable() and v12:HasTier(10 + 20, 1237 - (1030 + 205))) then
						v134 = true;
					end
					if (((2525 + 164) < (4508 + 337)) and v33.TheFirstDance:IsAvailable()) then
						local v215 = 286 - (156 + 130);
						while true do
							if ((v215 == (0 - 0)) or ((3912 - 1590) > (5369 - 2747))) then
								v135 = v27(v12:ComboPointsMax(), v78 + 2 + 2);
								v136 = v12:ComboPointsMax() - v135;
								break;
							end
						end
					end
					break;
				end
				if ((v162 == (0 + 0)) or ((4603 - (10 + 59)) == (589 + 1493))) then
					v132 = true;
					v133 = (39 - 31) + v33.ImprovedShadowDance:TalentRank();
					v162 = 1164 - (671 + 492);
				end
			end
		end
		local v140 = v31.EffectiveComboPoints(v135);
		local v141 = v33.Shadowstrike:IsCastable() or v138 or v139 or v132 or v12:BuffUp(v33.SepsisBuff);
		if (v138 or v139 or ((1251 + 320) > (3082 - (369 + 846)))) then
			v141 = v141 and v13:IsInRange(7 + 18);
		else
			v141 = v141 and v65;
		end
		if ((v141 and v138 and ((v69 < (4 + 0)) or v81)) or ((4599 - (1036 + 909)) >= (2383 + 613))) then
			if (((6678 - 2700) > (2307 - (11 + 192))) and v130) then
				return v33.Shadowstrike;
			elseif (((1514 + 1481) > (1716 - (135 + 40))) and v18(v33.Shadowstrike)) then
				return "Cast Shadowstrike (Stealth)";
			end
		end
		if (((7871 - 4622) > (575 + 378)) and (v140 >= v31.CPMaxSpend())) then
			return v97(v130, v131);
		end
		if ((v12:BuffUp(v33.ShurikenTornado) and (v136 <= (4 - 2))) or ((4906 - 1633) > (4749 - (50 + 126)))) then
			return v97(v130, v131);
		end
		if ((v79 <= ((2 - 1) + v23(v33.DeeperStratagem:IsAvailable() or v33.SecretStratagem:IsAvailable()))) or ((698 + 2453) < (2697 - (1233 + 180)))) then
			return v97(v130, v131);
		end
		if ((v33.Backstab:IsCastable() and not v137 and (v133 >= (972 - (522 + 447))) and v12:BuffUp(v33.ShadowBlades) and not v94(v33.Backstab) and v33.DanseMacabre:IsAvailable() and (v69 <= (1424 - (107 + 1314))) and not v134) or ((859 + 991) == (4658 - 3129))) then
			if (((349 + 472) < (4215 - 2092)) and v130) then
				if (((3568 - 2666) < (4235 - (716 + 1194))) and v131) then
					return v33.Backstab;
				else
					return {v33.Backstab,v33.Stealth};
				end
			elseif (((1361 - (74 + 429)) <= (5713 - 2751)) and v21(v33.Backstab, v33.Stealth)) then
				return "Cast Backstab (Stealth)";
			end
		end
		if (v33.Gloomblade:IsAvailable() or ((1956 + 1990) < (2948 - 1660))) then
			if ((not v137 and (v133 >= (3 + 0)) and v12:BuffUp(v33.ShadowBlades) and not v94(v33.Gloomblade) and v33.DanseMacabre:IsAvailable() and (v69 <= (12 - 8))) or ((8015 - 4773) == (1000 - (279 + 154)))) then
				if (v130 or ((1625 - (454 + 324)) >= (994 + 269))) then
					if (v131 or ((2270 - (12 + 5)) == (998 + 853))) then
						return v33.Gloomblade;
					else
						return {v33.Gloomblade,v33.Stealth};
					end
				elseif (v21(v33.Gloomblade, v33.Stealth) or ((3180 - (277 + 816)) > (10135 - 7763))) then
					return "Cast Gloomblade (Danse)";
				end
			end
		end
		if ((not v94(v33.Shadowstrike) and v12:BuffUp(v33.ShadowBlades)) or ((5628 - (1058 + 125)) < (778 + 3371))) then
			if (v130 or ((2793 - (815 + 160)) == (364 - 279))) then
				return v33.Shadowstrike;
			elseif (((1495 - 865) < (508 + 1619)) and v18(v33.Shadowstrike)) then
				return "Cast Shadowstrike (Danse)";
			end
		end
		if ((not v137 and (v69 >= (11 - 7))) or ((3836 - (41 + 1857)) == (4407 - (1222 + 671)))) then
			if (((10997 - 6742) >= (78 - 23)) and v130) then
				return v33.ShurikenStorm;
			elseif (((4181 - (229 + 953)) > (2930 - (1111 + 663))) and v18(v33.ShurikenStorm)) then
				return "Cast Shuriken Storm";
			end
		end
		if (((3929 - (874 + 705)) > (162 + 993)) and v141) then
			if (((2749 + 1280) <= (10087 - 5234)) and v130) then
				return v33.Shadowstrike;
			elseif (v18(v33.Shadowstrike) or ((15 + 501) > (4113 - (642 + 37)))) then
				return "Cast Shadowstrike";
			end
		end
		return false;
	end
	local function v99(v142, v143)
		local v144 = 0 + 0;
		local v145;
		local v146;
		while true do
			if (((648 + 3398) >= (7614 - 4581)) and ((457 - (233 + 221)) == v144)) then
				return false;
			end
			if ((v144 == (0 - 0)) or ((2394 + 325) <= (2988 - (718 + 823)))) then
				v145 = v98(true, v142);
				if (((v142:ID() == v33.Vanish:ID()) and (not v43 or not v145)) or ((2602 + 1532) < (4731 - (266 + 539)))) then
					local v203 = 0 - 0;
					while true do
						if ((v203 == (1225 - (636 + 589))) or ((388 - 224) >= (5743 - 2958))) then
							if (v18(v33.Vanish, nil) or ((417 + 108) == (767 + 1342))) then
								return "Cast Vanish";
							end
							return false;
						end
					end
				elseif (((1048 - (657 + 358)) == (87 - 54)) and (v142:ID() == v33.Shadowmeld:ID()) and (not v44 or not v145)) then
					if (((6957 - 3903) <= (5202 - (1151 + 36))) and v18(v33.Shadowmeld, nil)) then
						return "Cast Shadowmeld";
					end
					return false;
				elseif (((1807 + 64) < (890 + 2492)) and (v142:ID() == v33.ShadowDance:ID()) and (not v45 or not v145)) then
					local v221 = 0 - 0;
					while true do
						if (((3125 - (1552 + 280)) <= (3000 - (64 + 770))) and (v221 == (0 + 0))) then
							if (v18(v33.ShadowDance, nil) or ((5854 - 3275) < (22 + 101))) then
								return "Cast Shadow Dance";
							end
							return false;
						end
					end
				end
				v144 = 1244 - (157 + 1086);
			end
			if (((1 - 0) == v144) or ((3705 - 2859) >= (3632 - 1264))) then
				v146 = {v142,v145};
				if ((v143 and (v12:EnergyPredicted() < v143)) or ((7989 - 3977) <= (5289 - (1813 + 118)))) then
					local v204 = 0 + 0;
					while true do
						if (((2711 - (841 + 376)) <= (4210 - 1205)) and ((0 + 0) == v204)) then
							v82(v146, v143);
							return false;
						end
					end
				end
				v144 = 5 - 3;
			end
			if ((v144 == (861 - (464 + 395))) or ((7984 - 4873) == (1025 + 1109))) then
				v71 = v21(unpack(v146));
				if (((3192 - (467 + 370)) == (4866 - 2511)) and v71) then
					return "| " .. v146[2 + 0]:Name();
				end
				v144 = 10 - 7;
			end
		end
	end
	local function v100()
		local v147 = 0 + 0;
		local v148;
		local v149;
		local v150;
		while true do
			if ((v147 == (4 - 2)) or ((1108 - (150 + 370)) <= (1714 - (74 + 1208)))) then
				if (((11798 - 7001) >= (18472 - 14577)) and v38 and v33.ShadowDance:IsAvailable() and v84() and v33.ShadowDance:IsReady()) then
					if (((2546 + 1031) == (3967 - (14 + 376))) and not v12:BuffUp(v33.ShadowDance) and v9.BossFilteredFightRemains("<=", (13 - 5) + ((2 + 1) * v23(v33.Subterfuge:IsAvailable())))) then
						if (((3333 + 461) > (3523 + 170)) and v18(v33.ShadowDance)) then
							return "Cast Shadow Dance";
						end
					end
				end
				if ((v38 and v33.GoremawsBite:IsAvailable() and v33.GoremawsBite:IsReady()) or ((3735 - 2460) == (3085 + 1015))) then
					if ((v90() and (v79 >= (81 - (23 + 55))) and (not v33.ShadowDance:IsReady() or (v33.ShadowDance:IsAvailable() and v12:BuffUp(v33.ShadowDance) and not v33.InvigoratingShadowdust:IsAvailable()) or ((v69 < (9 - 5)) and not v33.InvigoratingShadowdust:IsAvailable()) or v33.TheRotten:IsAvailable())) or ((1062 + 529) >= (3215 + 365))) then
						if (((1523 - 540) <= (569 + 1239)) and v18(v33.GoremawsBite)) then
							return "Cast Goremaw's Bite";
						end
					end
				end
				if (v33.ThistleTea:IsReady() or ((3051 - (652 + 249)) <= (3203 - 2006))) then
					if (((5637 - (708 + 1160)) >= (3183 - 2010)) and ((((v33.SymbolsofDeath:CooldownRemains() >= (5 - 2)) or v12:BuffUp(v33.SymbolsofDeath)) and not v12:BuffUp(v33.ThistleTea) and (((v12:EnergyDeficitPredicted() >= (127 - (10 + 17))) and ((v79 >= (1 + 1)) or (v69 >= (1735 - (1400 + 332))))) or ((v33.ThistleTea:ChargesFractional() >= ((3.75 - 1) - ((1908.15 - (242 + 1666)) * v33.InvigoratingShadowdust:TalentRank()))) and v33.Vanish:IsReady() and v12:BuffUp(v33.ShadowDance) and v13:DebuffUp(v33.Rupture) and (v69 < (2 + 1))))) or ((v12:BuffRemains(v33.ShadowDance) >= (2 + 2)) and not v12:BuffUp(v33.ThistleTea) and (v69 >= (3 + 0))) or (not v12:BuffUp(v33.ThistleTea) and v9.BossFilteredFightRemains("<=", (946 - (850 + 90)) * v33.ThistleTea:Charges())))) then
						if (((2600 - 1115) == (2875 - (360 + 1030))) and v18(v33.ThistleTea, nil, nil)) then
							return "Thistle Tea";
						end
					end
				end
				v148 = v30.HandleDPSPotion(v9.BossFilteredFightRemains("<", 27 + 3) or (v12:BuffUp(v33.SymbolsofDeath) and (v12:BuffUp(v33.ShadowBlades) or (v33.ShadowBlades:CooldownRemains() <= (28 - 18)))));
				v147 = 3 - 0;
			end
			if (((1666 - (909 + 752)) == v147) or ((4538 - (109 + 1114)) <= (5092 - 2310))) then
				v150 = v30.HandleBottomTrinket(v62, v38, 16 + 24, nil);
				if (v150 or ((1118 - (6 + 236)) >= (1868 + 1096))) then
					return v150;
				end
				if (v33.ThistleTea:IsReady() or ((1797 + 435) > (5888 - 3391))) then
					if ((((v33.SymbolsofDeath:CooldownRemains() >= (4 - 1)) or v12:BuffUp(v33.SymbolsofDeath)) and not v12:BuffUp(v33.ThistleTea) and (((v12:EnergyDeficitPredicted() >= (1233 - (1076 + 57))) and ((v12:ComboPointsDeficit() >= (1 + 1)) or (v69 >= (692 - (579 + 110))))) or ((v33.ThistleTea:ChargesFractional() >= (1.75 + 1)) and v12:BuffUp(v33.ShadowDanceBuff)))) or ((v12:BuffRemains(v33.ShadowDanceBuff) >= (4 + 0)) and not v12:BuffUp(v33.ThistleTea) and (v69 >= (2 + 1))) or (not v12:BuffUp(v33.ThistleTea) and v9.BossFilteredFightRemains("<=", (413 - (174 + 233)) * v33.ThistleTea:Charges())) or ((5893 - 3783) <= (582 - 250))) then
						if (((1640 + 2046) > (4346 - (663 + 511))) and v18(v33.ThistleTea, nil, nil)) then
							return "Thistle Tea";
						end
					end
				end
				return false;
			end
			if ((v147 == (0 + 0)) or ((972 + 3502) < (2528 - 1708))) then
				if (((2592 + 1687) >= (6784 - 3902)) and v38 and v33.ColdBlood:IsReady() and not v33.SecretTechnique:IsAvailable() and (v78 >= (12 - 7))) then
					if (v18(v33.ColdBlood, nil) or ((969 + 1060) >= (6853 - 3332))) then
						return "Cast Cold Blood";
					end
				end
				if ((v38 and v33.Sepsis:IsAvailable() and v33.Sepsis:IsReady()) or ((1452 + 585) >= (425 + 4217))) then
					if (((2442 - (478 + 244)) < (4975 - (440 + 77))) and v90() and v13:FilteredTimeToDie(">=", 8 + 8) and (v12:BuffUp(v33.PerforatedVeins) or not v33.PerforatedVeins:IsAvailable())) then
						if (v18(v33.Sepsis, nil, nil) or ((1595 - 1159) > (4577 - (655 + 901)))) then
							return "Cast Sepsis";
						end
					end
				end
				if (((133 + 580) <= (649 + 198)) and v38 and v33.Flagellation:IsAvailable() and v33.Flagellation:IsReady()) then
					if (((1455 + 699) <= (16239 - 12208)) and v90() and (v77 >= (1450 - (695 + 750))) and (v13:TimeToDie() > (34 - 24)) and ((v96() and (v33.ShadowBlades:CooldownRemains() <= (3 - 0))) or v9.BossFilteredFightRemains("<=", 112 - 84) or ((v33.ShadowBlades:CooldownRemains() >= (365 - (285 + 66))) and v33.InvigoratingShadowdust:IsAvailable() and v33.ShadowDance:IsAvailable())) and (not v33.InvigoratingShadowdust:IsAvailable() or v33.Sepsis:IsAvailable() or not v33.ShadowDance:IsAvailable() or ((v33.InvigoratingShadowdust:TalentRank() == (4 - 2)) and (v69 >= (1312 - (682 + 628)))) or (v33.SymbolsofDeath:CooldownRemains() <= (1 + 2)) or (v12:BuffRemains(v33.SymbolsofDeath) > (302 - (176 + 123))))) then
						if (((1931 + 2684) == (3348 + 1267)) and v18(v33.Flagellation, nil, nil)) then
							return "Cast Flagellation";
						end
					end
				end
				if ((v38 and v33.SymbolsofDeath:IsReady()) or ((4059 - (239 + 30)) == (136 + 364))) then
					if (((86 + 3) < (390 - 169)) and v90() and (not v12:BuffUp(v33.TheRotten) or not v12:HasTier(93 - 63, 317 - (306 + 9))) and (v12:BuffRemains(v33.SymbolsofDeath) <= (10 - 7)) and (not v33.Flagellation:IsAvailable() or (v33.Flagellation:CooldownRemains() > (2 + 8)) or ((v12:BuffRemains(v33.ShadowDance) >= (2 + 0)) and v33.InvigoratingShadowdust:IsAvailable()) or (v33.Flagellation:IsReady() and (v77 >= (3 + 2)) and not v33.InvigoratingShadowdust:IsAvailable()))) then
						if (((5873 - 3819) >= (2796 - (1140 + 235))) and v18(v33.SymbolsofDeath, nil)) then
							return "Cast Symbols of Death";
						end
					end
				end
				v147 = 1 + 0;
			end
			if (((635 + 57) < (785 + 2273)) and (v147 == (56 - (33 + 19)))) then
				if ((v33.Fireblood:IsCastable() and v149 and v48) or ((1175 + 2079) == (4960 - 3305))) then
					if (v18(v33.Fireblood, nil) or ((571 + 725) == (9628 - 4718))) then
						return "Cast Fireblood";
					end
				end
				if (((3159 + 209) == (4057 - (586 + 103))) and v33.AncestralCall:IsCastable() and v149 and v48) then
					if (((241 + 2402) < (11745 - 7930)) and v18(v33.AncestralCall, nil)) then
						return "Cast Ancestral Call";
					end
				end
				v150 = v30.HandleTopTrinket(v62, v38, 1528 - (1309 + 179), nil);
				if (((3453 - 1540) > (215 + 278)) and v150) then
					return v150;
				end
				v147 = 13 - 8;
			end
			if (((3592 + 1163) > (7282 - 3854)) and (v147 == (1 - 0))) then
				if (((1990 - (295 + 314)) <= (5818 - 3449)) and v38 and v33.ShadowBlades:IsReady()) then
					if ((v90() and ((v77 <= (1963 - (1300 + 662))) or v12:HasTier(97 - 66, 1759 - (1178 + 577))) and (v12:BuffUp(v33.Flagellation) or v12:BuffUp(v33.FlagellationPersistBuff) or not v33.Flagellation:IsAvailable())) or ((2516 + 2327) == (12073 - 7989))) then
						if (((6074 - (851 + 554)) > (321 + 42)) and v18(v33.ShadowBlades, nil)) then
							return "Cast Shadow Blades";
						end
					end
				end
				if ((v38 and v33.EchoingReprimand:IsCastable() and v33.EchoingReprimand:IsAvailable()) or ((5205 - 3328) >= (6815 - 3677))) then
					if (((5044 - (115 + 187)) >= (2777 + 849)) and v90() and (v79 >= (3 + 0))) then
						if (v18(v33.EchoingReprimand, nil, nil) or ((17890 - 13350) == (2077 - (160 + 1001)))) then
							return "Cast Echoing Reprimand";
						end
					end
				end
				if ((v38 and v33.ShurikenTornado:IsAvailable() and v33.ShurikenTornado:IsReady()) or ((1012 + 144) > (2998 + 1347))) then
					if (((4578 - 2341) < (4607 - (237 + 121))) and v90() and v12:BuffUp(v33.SymbolsofDeath) and (v77 <= (899 - (525 + 372))) and not v12:BuffUp(v33.Premeditation) and (not v33.Flagellation:IsAvailable() or (v33.Flagellation:CooldownRemains() > (37 - 17))) and (v69 >= (9 - 6))) then
						if (v18(v33.ShurikenTornado, nil) or ((2825 - (96 + 46)) < (800 - (643 + 134)))) then
							return "Cast Shuriken Tornado";
						end
					end
				end
				if (((252 + 445) <= (1980 - 1154)) and v38 and v33.ShurikenTornado:IsAvailable() and v33.ShurikenTornado:IsReady()) then
					if (((4102 - 2997) <= (1128 + 48)) and v90() and not v12:BuffUp(v33.ShadowDance) and not v12:BuffUp(v33.Flagellation) and not v12:BuffUp(v33.FlagellationPersistBuff) and not v12:BuffUp(v33.ShadowBlades) and (v69 <= (3 - 1))) then
						if (((6906 - 3527) <= (4531 - (316 + 403))) and v18(v33.ShurikenTornado, nil)) then
							return "Cast Shuriken Tornado";
						end
					end
				end
				v147 = 2 + 0;
			end
			if (((8 - 5) == v147) or ((285 + 503) >= (4069 - 2453))) then
				if (((1314 + 540) <= (1089 + 2290)) and v148) then
					return v148;
				end
				v149 = v12:BuffUp(v33.ShadowBlades) or (not v33.ShadowBlades:IsAvailable() and v12:BuffUp(v33.SymbolsofDeath)) or v9.BossFilteredFightRemains("<", 69 - 49);
				if (((21725 - 17176) == (9449 - 4900)) and v33.BloodFury:IsCastable() and v149 and v48) then
					if (v18(v33.BloodFury, nil) or ((173 + 2849) >= (5952 - 2928))) then
						return "Cast Blood Fury";
					end
				end
				if (((236 + 4584) > (6466 - 4268)) and v33.Berserking:IsCastable() and v149 and v48) then
					if (v18(v33.Berserking, nil) or ((1078 - (12 + 5)) >= (18996 - 14105))) then
						return "Cast Berserking";
					end
				end
				v147 = 8 - 4;
			end
		end
	end
	local function v101(v151)
		local v152 = 0 - 0;
		while true do
			if (((3382 - 2018) <= (908 + 3565)) and (v152 == (1974 - (1656 + 317)))) then
				return false;
			end
			if ((v152 == (0 + 0)) or ((2881 + 714) <= (7 - 4))) then
				if ((v38 and not (v30.IsSoloMode() and v12:IsTanking(v13))) or ((22993 - 18321) == (4206 - (5 + 349)))) then
					local v205 = 0 - 0;
					while true do
						if (((2830 - (266 + 1005)) == (1028 + 531)) and ((0 - 0) == v205)) then
							if (v33.Vanish:IsCastable() or ((2306 - 554) <= (2484 - (561 + 1135)))) then
								if ((((v79 > (1 - 0)) or (v12:BuffUp(v33.ShadowBlades) and v33.InvigoratingShadowdust:IsAvailable())) and not v88() and ((v33.Flagellation:CooldownRemains() >= (197 - 137)) or not v33.Flagellation:IsAvailable() or v9.BossFilteredFightRemains("<=", (1096 - (507 + 559)) * v33.Vanish:Charges())) and ((v33.SymbolsofDeath:CooldownRemains() > (7 - 4)) or not v12:HasTier(92 - 62, 390 - (212 + 176))) and ((v33.SecretTechnique:CooldownRemains() >= (915 - (250 + 655))) or not v33.SecretTechnique:IsAvailable() or ((v33.Vanish:Charges() >= (5 - 3)) and v33.InvigoratingShadowdust:IsAvailable() and (v12:BuffUp(v33.TheRotten) or not v33.TheRotten:IsAvailable())))) or ((6826 - 2919) == (276 - 99))) then
									local v227 = 1956 - (1869 + 87);
									while true do
										if (((12035 - 8565) > (2456 - (484 + 1417))) and ((0 - 0) == v227)) then
											v71 = v99(v33.Vanish, v151);
											if (v71 or ((1628 - 656) == (1418 - (48 + 725)))) then
												return "Vanish Macro " .. v71;
											end
											break;
										end
									end
								end
							end
							if (((5197 - 2015) >= (5674 - 3559)) and v48 and v46 and (v12:Energy() < (24 + 16)) and v33.Shadowmeld:IsCastable()) then
								if (((10403 - 6510) < (1240 + 3189)) and v20(v33.Shadowmeld, v12:EnergyTimeToX(12 + 28))) then
									return "Pool for Shadowmeld";
								end
							end
							v205 = 854 - (152 + 701);
						end
						if (((1312 - (430 + 881)) == v205) or ((1098 + 1769) < (2800 - (557 + 338)))) then
							if ((v48 and v33.Shadowmeld:IsCastable() and v65 and not v12:IsMoving() and (v12:EnergyPredicted() >= (12 + 28)) and (v12:EnergyDeficitPredicted() >= (28 - 18)) and not v88() and (v79 > (13 - 9))) or ((4771 - 2975) >= (8730 - 4679))) then
								v71 = v99(v33.Shadowmeld, v151);
								if (((2420 - (499 + 302)) <= (4622 - (39 + 827))) and v71) then
									return "Shadowmeld Macro " .. v71;
								end
							end
							break;
						end
					end
				end
				if (((1667 - 1063) == (1348 - 744)) and v65 and v33.ShadowDance:IsCastable()) then
					if (((v13:DebuffUp(v33.Rupture) or v33.InvigoratingShadowdust:IsAvailable()) and v93() and (not v33.TheFirstDance:IsAvailable() or (v79 >= (15 - 11)) or v12:BuffUp(v33.ShadowBlades)) and ((v89() and v88()) or ((v12:BuffUp(v33.ShadowBlades) or (v12:BuffUp(v33.SymbolsofDeath) and not v33.Sepsis:IsAvailable()) or ((v12:BuffRemains(v33.SymbolsofDeath) >= (5 - 1)) and not v12:HasTier(3 + 27, 5 - 3)) or (not v12:BuffUp(v33.SymbolsofDeath) and v12:HasTier(5 + 25, 2 - 0))) and (v33.SecretTechnique:CooldownRemains() < ((114 - (103 + 1)) + ((566 - (475 + 79)) * v23(not v33.InvigoratingShadowdust:IsAvailable() or v12:HasTier(64 - 34, 6 - 4)))))))) or ((580 + 3904) == (793 + 107))) then
						local v216 = 1503 - (1395 + 108);
						while true do
							if ((v216 == (0 - 0)) or ((5663 - (7 + 1197)) <= (486 + 627))) then
								v71 = v99(v33.ShadowDance, v151);
								if (((1268 + 2364) > (3717 - (27 + 292))) and v71) then
									return "ShadowDance Macro 1 " .. v71;
								end
								break;
							end
						end
					end
				end
				v152 = 2 - 1;
			end
		end
	end
	local function v102(v153)
		local v154 = not v153 or (v12:EnergyPredicted() >= v153);
		if (((5205 - 1123) <= (20620 - 15703)) and v37 and v33.ShurikenStorm:IsCastable() and (v69 >= ((3 - 1) + v17((v33.Gloomblade:IsAvailable() and (v12:BuffRemains(v33.LingeringShadowBuff) >= (11 - 5))) or v12:BuffUp(v33.PerforatedVeinsBuff))))) then
			local v163 = 139 - (43 + 96);
			while true do
				if (((19710 - 14878) >= (3133 - 1747)) and (v163 == (0 + 0))) then
					if (((39 + 98) == (270 - 133)) and v154 and v18(v33.ShurikenStorm)) then
						return "Cast Shuriken Storm";
					end
					v82(v33.ShurikenStorm, v153);
					break;
				end
			end
		end
		if (v65 or ((602 + 968) >= (8118 - 3786))) then
			if (v33.Gloomblade:IsCastable() or ((1280 + 2784) <= (134 + 1685))) then
				local v190 = 1751 - (1414 + 337);
				while true do
					if ((v190 == (1940 - (1642 + 298))) or ((12997 - 8011) < (4528 - 2954))) then
						if (((13134 - 8708) > (57 + 115)) and v154 and v18(v33.Gloomblade)) then
							return "Cast Gloomblade";
						end
						v82(v33.Gloomblade, v153);
						break;
					end
				end
			elseif (((456 + 130) > (1427 - (357 + 615))) and v33.Backstab:IsCastable()) then
				local v206 = 0 + 0;
				while true do
					if (((2026 - 1200) == (708 + 118)) and (v206 == (0 - 0))) then
						if ((v154 and v18(v33.Backstab)) or ((3215 + 804) > (302 + 4139))) then
							return "Cast Backstab";
						end
						v82(v33.Backstab, v153);
						break;
					end
				end
			end
		end
		return false;
	end
	local v103 = {{v33.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v33.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v78 > (421 - (275 + 146));
	end},{v33.CheapShot,"Cast Cheap Shot (Interrupt)",function()
		return v12:StealthUp(true, true);
	end}};
	local function v104()
		local v155 = 0 - 0;
		while true do
			if (((1314 + 703) < (5273 - (53 + 959))) and (v155 == (411 - (312 + 96)))) then
				v52 = EpicSettings.Settings['DispelBuffs'];
				v53 = EpicSettings.Settings['UseHealthstone'];
				v54 = EpicSettings.Settings['HealthstoneHP'] or (1 - 0);
				v55 = EpicSettings.Settings['InterruptWithStun'];
				v155 = 289 - (147 + 138);
			end
			if (((5615 - (813 + 86)) > (73 + 7)) and (v155 == (1 - 0))) then
				v44 = EpicSettings.Settings['StealthMacroShadowmeld'];
				v45 = EpicSettings.Settings['StealthMacroShadowDance'];
				v46 = EpicSettings.Settings['PoolForShadowmeld'];
				v47 = EpicSettings.Settings['EviscerateDMGOffset'] or (493 - (18 + 474));
				v155 = 1 + 1;
			end
			if ((v155 == (6 - 4)) or ((4593 - (860 + 226)) == (3575 - (121 + 182)))) then
				v48 = EpicSettings.Settings['UseRacials'];
				v49 = EpicSettings.Settings['UseHealingPotion'];
				v50 = EpicSettings.Settings['HealingPotionName'];
				v51 = EpicSettings.Settings['HealingPotionHP'] or (1 + 0);
				v155 = 1243 - (988 + 252);
			end
			if ((v155 == (0 + 0)) or ((275 + 601) >= (5045 - (49 + 1921)))) then
				v40 = EpicSettings.Settings['BurnShadowDance'];
				v41 = EpicSettings.Settings['UsePriorityRotation'];
				v42 = EpicSettings.Settings['RangedMultiDoT'];
				v43 = EpicSettings.Settings['StealthMacroVanish'];
				v155 = 891 - (223 + 667);
			end
			if (((4404 - (51 + 1)) > (4395 - 1841)) and (v155 == (10 - 5))) then
				v60 = EpicSettings.Settings['UsageStealthOOC'];
				v61 = EpicSettings.Settings['StealthRange'] or (1125 - (146 + 979));
				break;
			end
			if (((2 + 2) == v155) or ((5011 - (311 + 294)) < (11274 - 7231))) then
				v56 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v57 = EpicSettings.Settings['InterruptThreshold'];
				v58 = EpicSettings.Settings['AutoFocusTank'];
				v59 = EpicSettings.Settings['AutoTricksTank'];
				v155 = 3 + 2;
			end
		end
	end
	local function v105()
		v104();
		v36 = EpicSettings.Toggles['ooc'];
		v37 = EpicSettings.Toggles['aoe'];
		v38 = EpicSettings.Toggles['cds'];
		v39 = EpicSettings.Toggles['dispel'];
		v72 = nil;
		v74 = nil;
		v73 = 1443 - (496 + 947);
		v63 = (v33.AcrobaticStrikes:IsAvailable() and (1366 - (1233 + 125))) or (3 + 2);
		v64 = (v33.AcrobaticStrikes:IsAvailable() and (12 + 1)) or (2 + 8);
		v65 = v13:IsInMeleeRange(v63);
		v66 = v13:IsInMeleeRange(v64);
		if (v37 or ((3534 - (963 + 682)) >= (2824 + 559))) then
			v67 = v12:GetEnemiesInRange(1534 - (504 + 1000));
			v68 = v12:GetEnemiesInMeleeRange(v64);
			v69 = #v68;
			v70 = v12:GetEnemiesInMeleeRange(v63);
		else
			local v164 = 0 + 0;
			while true do
				if (((1723 + 169) <= (258 + 2476)) and (v164 == (1 - 0))) then
					v69 = 1 + 0;
					v70 = {};
					break;
				end
				if (((1119 + 804) < (2400 - (156 + 26))) and (v164 == (0 + 0))) then
					v67 = {};
					v68 = {};
					v164 = 1 - 0;
				end
			end
		end
		v78 = v12:ComboPoints();
		v77 = v31.EffectiveComboPoints(v78);
		v79 = v12:ComboPointsDeficit();
		v81 = v85();
		v80 = v12:EnergyMax() - v87();
		if (((2337 - (149 + 15)) > (1339 - (890 + 70))) and v12:BuffUp(v33.ShurikenTornado, nil, true) and (v78 < v31.CPMaxSpend())) then
			local v165 = 117 - (39 + 78);
			local v166;
			while true do
				if ((v165 == (482 - (14 + 468))) or ((5697 - 3106) == (9528 - 6119))) then
					v166 = v31.TimeToNextTornado();
					if (((2330 + 2184) > (1997 + 1327)) and ((v166 <= v12:GCDRemains()) or (v29(v12:GCDRemains() - v166) < (0.25 + 0)))) then
						local v217 = 0 + 0;
						local v218;
						while true do
							if (((0 + 0) == v217) or ((397 - 189) >= (4772 + 56))) then
								v218 = v69 + v23(v12:BuffUp(v33.ShadowBlades));
								v78 = v27(v78 + v218, v31.CPMaxSpend());
								v217 = 3 - 2;
							end
							if ((v217 == (1 + 0)) or ((1634 - (12 + 39)) > (3319 + 248))) then
								v79 = v28(v79 - v218, 0 - 0);
								if ((v77 < v31.CPMaxSpend()) or ((4675 - 3362) == (236 + 558))) then
									v77 = v78;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
		v75 = (3 + 1 + (v77 * (9 - 5))) * (0.3 + 0);
		v76 = v33.Eviscerate:Damage() * v47;
		if (((15339 - 12165) > (4612 - (1596 + 114))) and not v12:AffectingCombat() and v58) then
			local v167 = 0 - 0;
			local v168;
			while true do
				if (((4833 - (164 + 549)) <= (5698 - (1059 + 379))) and ((0 - 0) == v167)) then
					v168 = v30.FocusUnit(false, nil, nil, "TANK", 11 + 9);
					if (v168 or ((149 + 734) > (5170 - (145 + 247)))) then
						return v168;
					end
					break;
				end
			end
		end
		if ((Focus and v59 and (v30.UnitGroupRole(Focus) == "TANK") and v33.TricksoftheTrade:IsCastable()) or ((2971 + 649) >= (2261 + 2630))) then
			if (((12623 - 8365) > (180 + 757)) and Press(v35.TricksoftheTradeFocus)) then
				return "tricks of the trade tank";
			end
		end
		v71 = v31.CrimsonVial();
		if (v71 or ((4195 + 674) < (1470 - 564))) then
			return v71;
		end
		v71 = v31.Feint();
		if (v71 or ((1945 - (254 + 466)) > (4788 - (544 + 16)))) then
			return v71;
		end
		v31.Poisons();
		if (((10576 - 7248) > (2866 - (294 + 334))) and not v12:AffectingCombat() and v36) then
			if (((4092 - (236 + 17)) > (606 + 799)) and v33.Stealth:IsCastable() and (v60 == "Always")) then
				local v191 = 0 + 0;
				while true do
					if (((0 - 0) == v191) or ((6121 - 4828) <= (262 + 245))) then
						v71 = v31.Stealth(v31.StealthSpell());
						if (v71 or ((2386 + 510) < (1599 - (413 + 381)))) then
							return v71;
						end
						break;
					end
				end
			elseif (((98 + 2218) == (4925 - 2609)) and v33.Stealth:IsCastable() and (v60 == "Distance") and v13:IsInRange(v61)) then
				local v207 = 0 - 0;
				while true do
					if ((v207 == (1970 - (582 + 1388))) or ((4378 - 1808) == (1098 + 435))) then
						v71 = v31.Stealth(v31.StealthSpell());
						if (v71 or ((1247 - (326 + 38)) == (4319 - 2859))) then
							return v71;
						end
						break;
					end
				end
			end
			if ((not v12:BuffUp(v33.ShadowDanceBuff) and not v12:BuffUp(v31.VanishBuffSpell())) or ((6593 - 1974) <= (1619 - (47 + 573)))) then
				v71 = v31.Stealth(v31.StealthSpell());
				if (v71 or ((1203 + 2207) > (17480 - 13364))) then
					return v71;
				end
			end
			if ((v30.TargetIsValid() and (v13:IsSpellInRange(v33.Shadowstrike) or v65)) or ((1465 - 562) >= (4723 - (1269 + 395)))) then
				if (v12:StealthUp(true, true) or ((4468 - (76 + 416)) < (3300 - (319 + 124)))) then
					v72 = v98(true);
					if (((11269 - 6339) > (3314 - (564 + 443))) and v72) then
						if (((type(v72) == "table") and (#v72 > (2 - 1))) or ((4504 - (337 + 121)) < (3782 - 2491))) then
							if (v22(nil, unpack(v72)) or ((14127 - 9886) == (5456 - (1261 + 650)))) then
								return "Stealthed Macro Cast or Pool (OOC): " .. v72[1 + 0]:Name();
							end
						elseif (v20(v72) or ((6450 - 2402) > (6049 - (772 + 1045)))) then
							return "Stealthed Cast or Pool (OOC): " .. v72:Name();
						end
					end
				elseif ((v78 >= (1 + 4)) or ((1894 - (102 + 42)) >= (5317 - (1524 + 320)))) then
					local v219 = 1270 - (1049 + 221);
					while true do
						if (((3322 - (18 + 138)) == (7749 - 4583)) and (v219 == (1102 - (67 + 1035)))) then
							v71 = v97();
							if (((2111 - (136 + 212)) < (15824 - 12100)) and v71) then
								return v71 .. " (OOC)";
							end
							break;
						end
					end
				elseif (((46 + 11) <= (2511 + 212)) and v33.Backstab:IsCastable()) then
					if (v18(v33.Backstab) or ((3674 - (240 + 1364)) == (1525 - (1050 + 32)))) then
						return "Cast Backstab (OOC)";
					end
				end
			end
			return;
		end
		if (v30.TargetIsValid() or ((9658 - 6953) == (824 + 569))) then
			if ((not v12:IsCasting() and not v12:IsChanneling()) or ((5656 - (331 + 724)) < (5 + 56))) then
				local v192 = v30.Interrupt(v33.Kick, 652 - (269 + 375), true);
				if (v192 or ((2115 - (267 + 458)) >= (1476 + 3268))) then
					return v192;
				end
				v192 = v30.Interrupt(v33.Kick, 15 - 7, true, MouseOver, v35.KickMouseover);
				if (v192 or ((2821 - (667 + 151)) > (5331 - (1410 + 87)))) then
					return v192;
				end
				v192 = v30.Interrupt(v33.Blind, 1912 - (1504 + 393), BlindInterrupt);
				if (v192 or ((421 - 265) > (10151 - 6238))) then
					return v192;
				end
				v192 = v30.Interrupt(v33.Blind, 811 - (461 + 335), BlindInterrupt, MouseOver, v35.BlindMouseover);
				if (((25 + 170) == (1956 - (1730 + 31))) and v192) then
					return v192;
				end
				v192 = v30.InterruptWithStun(v33.CheapShot, 1675 - (728 + 939), v12:StealthUp(false, false));
				if (((10996 - 7891) >= (3642 - 1846)) and v192) then
					return v192;
				end
				v192 = v30.InterruptWithStun(v33.KidneyShot, 18 - 10, v12:ComboPoints() > (1068 - (138 + 930)));
				if (((4002 + 377) >= (1667 + 464)) and v192) then
					return v192;
				end
			end
			if (((3295 + 549) >= (8341 - 6298)) and v52 and v39 and v33.Shiv:IsReady() and not v12:IsCasting() and not v12:IsChanneling() and v30.UnitHasEnrageBuff(v13)) then
				if (Press(v33.Shiv, not IsInMeleeRange) or ((4998 - (459 + 1307)) <= (4601 - (474 + 1396)))) then
					return "shiv dispel enrage";
				end
			end
			if (((8565 - 3660) == (4597 + 308)) and v34.Healthstone:IsReady() and v53 and (v12:HealthPercentage() <= v54)) then
				if (Press(v35.Healthstone, nil, nil, true) or ((14 + 4122) >= (12634 - 8223))) then
					return "healthstone defensive 3";
				end
			end
			if ((v49 and (v12:HealthPercentage() <= v51)) or ((375 + 2583) == (13409 - 9392))) then
				local v193 = 0 - 0;
				while true do
					if (((1819 - (562 + 29)) >= (694 + 119)) and (v193 == (1419 - (374 + 1045)))) then
						if ((v50 == "Refreshing Healing Potion") or ((2735 + 720) > (12576 - 8526))) then
							if (((881 - (448 + 190)) == (79 + 164)) and v34.RefreshingHealingPotion:IsReady()) then
								if (Press(v35.RefreshingHealingPotion, nil, nil, true) or ((123 + 148) > (1025 + 547))) then
									return "refreshing healing potion defensive 4";
								end
							end
						end
						if (((10530 - 7791) < (10231 - 6938)) and (v50 == "Dreamwalker's Healing Potion")) then
							if (v34.DreamwalkersHealingPotion:IsReady() or ((5436 - (1307 + 187)) < (4496 - 3362))) then
								if (Press(v35.RefreshingHealingPotion, nil, nil, true) or ((6305 - 3612) == (15248 - 10275))) then
									return "dreamwalker's healing potion defensive 4";
								end
							end
						end
						break;
					end
				end
			end
			v71 = v100();
			if (((2829 - (232 + 451)) == (2050 + 96)) and v71) then
				return "CDs: " .. v71;
			end
			if ((v33.SliceandDice:IsCastable() and (v69 < v31.CPMaxSpend()) and (v12:BuffRemains(v33.SliceandDice) < v12:GCD()) and v9.BossFilteredFightRemains(">", 6 + 0) and (v78 >= (568 - (510 + 54)))) or ((4520 - 2276) == (3260 - (13 + 23)))) then
				local v194 = 0 - 0;
				while true do
					if ((v194 == (0 - 0)) or ((8909 - 4005) <= (3004 - (830 + 258)))) then
						if (((317 - 227) <= (667 + 398)) and v33.SliceandDice:IsReady() and v18(v33.SliceandDice)) then
							return "Cast Slice and Dice (Low Duration)";
						end
						v83(v33.SliceandDice);
						break;
					end
				end
			end
			if (((4086 + 716) == (6243 - (860 + 581))) and v12:StealthUp(true, true)) then
				local v195 = 0 - 0;
				while true do
					if ((v195 == (0 + 0)) or ((2521 - (237 + 4)) <= (1200 - 689))) then
						v72 = v98(true);
						if (v72 or ((4239 - 2563) <= (877 - 414))) then
							if (((3167 + 702) == (2223 + 1646)) and (type(v72) == "table") and (#v72 > (3 - 2))) then
								if (((497 + 661) <= (1422 + 1191)) and v22(nil, unpack(v72))) then
									return "Stealthed Macro " .. v72[1427 - (85 + 1341)]:Name() .. "|" .. v72[3 - 1]:Name();
								end
							elseif ((v12:BuffUp(v33.ShurikenTornado) and (v78 ~= v12:ComboPoints()) and ((v72 == v33.BlackPowder) or (v72 == v33.Eviscerate) or (v72 == v33.Rupture) or (v72 == v33.SliceandDice))) or ((6676 - 4312) <= (2371 - (45 + 327)))) then
								if (v22(nil, v33.ShurikenTornado, v72) or ((9287 - 4365) < (696 - (444 + 58)))) then
									return "Stealthed Tornado Cast  " .. v72:Name();
								end
							elseif ((type(v72) ~= "boolean") or ((909 + 1182) < (6 + 25))) then
								if (v20(v72) or ((1188 + 1242) >= (14118 - 9246))) then
									return "Stealthed Cast " .. v72:Name();
								end
							end
						end
						v195 = 1733 - (64 + 1668);
					end
					if ((v195 == (1974 - (1227 + 746))) or ((14661 - 9891) < (3219 - 1484))) then
						v18(v33.PoolEnergy);
						return "Stealthed Pooling";
					end
				end
			end
			local v169;
			if (not v33.Vigor:IsAvailable() or v33.Shadowcraft:IsAvailable() or ((4933 - (415 + 79)) <= (61 + 2289))) then
				v169 = v12:EnergyDeficitPredicted() <= v87();
			else
				v169 = v12:EnergyPredicted() >= v87();
			end
			if (v169 or v33.InvigoratingShadowdust:IsAvailable() or ((4970 - (142 + 349)) < (1914 + 2552))) then
				local v196 = 0 - 0;
				while true do
					if (((1266 + 1281) > (864 + 361)) and (v196 == (0 - 0))) then
						v71 = v101(v80);
						if (((6535 - (1710 + 154)) > (2992 - (200 + 118))) and v71) then
							return "Stealth CDs: " .. v71;
						end
						break;
					end
				end
			end
			if ((v77 >= v31.CPMaxSpend()) or ((1465 + 2231) < (5816 - 2489))) then
				local v197 = 0 - 0;
				while true do
					if ((v197 == (0 + 0)) or ((4493 + 49) == (1594 + 1376))) then
						v71 = v97();
						if (((41 + 211) <= (4283 - 2306)) and v71) then
							return "Finish: " .. v71;
						end
						break;
					end
				end
			end
			if ((v79 <= (1251 - (363 + 887))) or (v9.BossFilteredFightRemains("<=", 1 - 0) and (v77 >= (14 - 11))) or ((222 + 1214) == (8832 - 5057))) then
				local v198 = 0 + 0;
				while true do
					if (((1664 - (674 + 990)) == v198) or ((464 + 1154) < (381 + 549))) then
						v71 = v97();
						if (((7485 - 2762) > (5208 - (507 + 548))) and v71) then
							return "Finish: " .. v71;
						end
						break;
					end
				end
			end
			if (((v69 >= (841 - (289 + 548))) and (v77 >= (1822 - (821 + 997)))) or ((3909 - (195 + 60)) >= (1252 + 3402))) then
				local v199 = 1501 - (251 + 1250);
				while true do
					if (((2785 - 1834) <= (1028 + 468)) and (v199 == (1032 - (809 + 223)))) then
						v71 = v97();
						if (v71 or ((2533 - 797) == (1714 - 1143))) then
							return "Finish: " .. v71;
						end
						break;
					end
				end
			end
			if (v74 or ((2962 - 2066) > (3512 + 1257))) then
				v82(v74);
			end
			v71 = v102(v80);
			if (v71 or ((548 + 497) <= (1637 - (14 + 603)))) then
				return "Build: " .. v71;
			end
			if (v38 or ((1289 - (118 + 11)) <= (54 + 274))) then
				local v200 = 0 + 0;
				while true do
					if (((11097 - 7289) > (3873 - (551 + 398))) and (v200 == (1 + 0))) then
						if (((1385 + 2506) < (3998 + 921)) and v33.BagofTricks:IsReady() and v48) then
							if (v18(v33.BagofTricks, nil) or ((8308 - 6074) <= (3460 - 1958))) then
								return "Cast Bag of Tricks";
							end
						end
						break;
					end
					if ((v200 == (0 + 0)) or ((9972 - 7460) < (120 + 312))) then
						if ((v33.ArcaneTorrent:IsReady() and v65 and (v12:EnergyDeficitPredicted() >= ((104 - (40 + 49)) + v12:EnergyRegen())) and v48) or ((7037 - 5189) == (1355 - (99 + 391)))) then
							if (v18(v33.ArcaneTorrent, nil) or ((3873 + 809) <= (19961 - 15420))) then
								return "Cast Arcane Torrent";
							end
						end
						if ((v33.ArcanePulse:IsReady() and v65 and v48) or ((7493 - 4467) >= (3942 + 104))) then
							if (((5283 - 3275) > (2242 - (1032 + 572))) and v18(v33.ArcanePulse, nil)) then
								return "Cast Arcane Pulse";
							end
						end
						v200 = 418 - (203 + 214);
					end
				end
			end
			if (((3592 - (568 + 1249)) <= (2530 + 703)) and v72 and v65) then
				if (((type(v72) == "table") and (#v72 > (2 - 1))) or ((17547 - 13004) == (3303 - (913 + 393)))) then
					if (v22(v12:EnergyTimeToX(v73), unpack(v72)) or ((8759 - 5657) < (1028 - 300))) then
						return "Macro pool towards " .. v72[411 - (269 + 141)]:Name() .. " at " .. v73;
					end
				elseif (((767 - 422) == (2326 - (362 + 1619))) and v72:IsCastable()) then
					v73 = v28(v73, v72:Cost());
					if (v20(v72, v12:EnergyTimeToX(v73)) or ((4452 - (950 + 675)) < (146 + 232))) then
						return "Pool towards: " .. v72:Name() .. " at " .. v73;
					end
				end
			end
			if ((v33.ShurikenToss:IsCastable() and v13:IsInRange(1209 - (216 + 963)) and not v66 and not v12:StealthUp(true, true) and not v12:BuffUp(v33.Sprint) and (v12:EnergyDeficitPredicted() < (1307 - (485 + 802))) and ((v79 >= (560 - (432 + 127))) or (v12:EnergyTimeToMax() <= (1074.2 - (1065 + 8))))) or ((1931 + 1545) < (4198 - (635 + 966)))) then
				if (((2214 + 865) < (4836 - (5 + 37))) and v20(v33.ShurikenToss)) then
					return "Cast Shuriken Toss";
				end
			end
		end
	end
	local function v106()
		local v160 = 0 - 0;
		while true do
			if (((2020 + 2834) > (7065 - 2601)) and ((0 + 0) == v160)) then
				v9.Print("Subtlety Rogue by Epic BoomK");
				EpicSettings.SetupVersion("Subtlety Rogue  X v 10.2.5.00 By BoomK");
				break;
			end
		end
	end
	v9.SetAPL(542 - 281, v105, v106);
end;
return v0["Epix_Rogue_Subtlety.lua"]();

