local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((5078 - (466 + 145)) <= (352 + 112))) then
			v6 = v0[v4];
			if (not v6 or ((1671 - (255 + 896)) > (5805 - 3911))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if ((v5 == (900 - (503 + 396))) or ((1753 - (92 + 89)) > (7516 - 3641))) then
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
	local v68 = {};
	local v69, v70, v71, v72, v73;
	local v74, v75, v76, v77;
	local v78;
	local v79, v80, v81;
	local v82, v83;
	local v84, v85, v86, v87;
	local v88;
	v36.Eviscerate:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v84 * (0.176 + 0) * (1.21 + 0) * ((v36.Nightstalker:IsAvailable() and v13:StealthUp(true, false) and (3.08 - 2)) or (1 + 0)) * ((v36.DeeperStratagem:IsAvailable() and (2.05 - 1)) or (1 + 0)) * ((v36.DarkShadow:IsAvailable() and v13:BuffUp(v36.ShadowDanceBuff) and (1.3 + 0)) or (2 - 1)) * ((v13:BuffUp(v36.SymbolsofDeath) and (1.1 + 0)) or (1 - 0)) * ((v13:BuffUp(v36.FinalityEviscerateBuff) and (1245.3 - (485 + 759))) or (2 - 1)) * ((1190 - (442 + 747)) + (v13:MasteryPct() / (1235 - (832 + 303)))) * ((947 - (88 + 858)) + (v13:VersatilityDmgPct() / (31 + 69))) * ((v14:DebuffUp(v36.FindWeaknessDebuff) and (1.5 + 0)) or (1 + 0));
	end);
	local function v89(v120, v121)
		if (((5331 - (766 + 23)) == (22422 - 17880)) and not v79) then
			local v193 = 0 - 0;
			while true do
				if ((v193 == (0 - 0)) or ((9062 - 6392) < (2812 - (1036 + 37)))) then
					v79 = v120;
					v80 = v121 or (0 + 0);
					break;
				end
			end
		end
	end
	local function v90(v122)
		if (not v81 or ((646 - 314) >= (3149 + 854))) then
			v81 = v122;
		end
	end
	local function v91()
		if (((v45 == "On Bosses not in Dungeons") and v13:IsInDungeonArea()) or ((4771 - (641 + 839)) <= (4193 - (910 + 3)))) then
			return false;
		elseif (((11181 - 6795) >= (2557 - (1466 + 218))) and (v45 ~= "Always") and not v14:IsInBossList()) then
			return false;
		else
			return true;
		end
	end
	local function v92()
		local v123 = 0 + 0;
		while true do
			if (((2069 - (556 + 592)) <= (392 + 710)) and (v123 == (808 - (329 + 479)))) then
				if (((5560 - (174 + 680)) >= (3308 - 2345)) and (v76 < (3 - 1))) then
					return false;
				elseif ((v46 == "Always") or ((686 + 274) <= (1615 - (396 + 343)))) then
					return true;
				elseif (((v46 == "On Bosses") and v14:IsInBossList()) or ((183 + 1883) == (2409 - (29 + 1448)))) then
					return true;
				elseif (((6214 - (135 + 1254)) < (18244 - 13401)) and (v46 == "Auto")) then
					if (((v13:InstanceDifficulty() == (74 - 58)) and (v14:NPCID() == (92613 + 46354))) or ((5404 - (389 + 1138)) >= (5111 - (102 + 472)))) then
						return true;
					elseif ((v14:NPCID() == (157568 + 9401)) or (v14:NPCID() == (92591 + 74380)) or (v14:NPCID() == (155688 + 11282)) or ((5860 - (320 + 1225)) < (3072 - 1346))) then
						return true;
					elseif ((v14:NPCID() == (112255 + 71208)) or (v14:NPCID() == (185135 - (157 + 1307))) or ((5538 - (821 + 1038)) < (1559 - 934))) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v93(v124, v125, v126, v127)
		local v128 = 0 + 0;
		local v129;
		local v130;
		local v131;
		while true do
			if ((v128 == (1 - 0)) or ((1721 + 2904) < (1566 - 934))) then
				for v207, v208 in v28(v127) do
					if (((v208:GUID() ~= v131) and v33.UnitIsCycleValid(v208, v130, -v208:DebuffRemains(v124)) and v125(v208)) or ((1109 - (834 + 192)) > (114 + 1666))) then
						v129, v130 = v208, v208:TimeToDie();
					end
				end
				if (((141 + 405) <= (24 + 1053)) and v129 and (v14:GUID() == v129:GUID())) then
					v10.Press(v124);
				elseif (v47 or ((1542 - 546) > (4605 - (300 + 4)))) then
					local v223 = 0 + 0;
					while true do
						if (((10654 - 6584) > (1049 - (112 + 250))) and (v223 == (1 + 0))) then
							if ((v129 and (v14:GUID() == v129:GUID())) or ((1643 - 987) >= (1908 + 1422))) then
								v10.Press(v124);
							end
							break;
						end
						if (((0 + 0) == v223) or ((1864 + 628) <= (167 + 168))) then
							v129, v130 = nil, v126;
							for v234, v235 in v28(v75) do
								if (((3211 + 1111) >= (3976 - (1001 + 413))) and (v235:GUID() ~= v131) and v33.UnitIsCycleValid(v235, v130, -v235:DebuffRemains(v124)) and v125(v235)) then
									v129, v130 = v235, v235:TimeToDie();
								end
							end
							v223 = 2 - 1;
						end
					end
				end
				break;
			end
			if ((v128 == (882 - (244 + 638))) or ((4330 - (627 + 66)) >= (11233 - 7463))) then
				v129, v130 = nil, v126;
				v131 = v14:GUID();
				v128 = 603 - (512 + 90);
			end
		end
	end
	local function v94()
		return (1926 - (1665 + 241)) + (v36.Vigor:TalentRank() * (742 - (373 + 344))) + (v26(v36.ThistleTea:IsAvailable()) * (10 + 10)) + (v26(v36.Shadowcraft:IsAvailable()) * (6 + 14));
	end
	local function v95()
		return v36.ShadowDance:ChargesFractional() >= ((0.75 - 0) + v18(v36.ShadowDanceTalent:IsAvailable()));
	end
	local function v96()
		return v86 >= (4 - 1);
	end
	local function v97()
		return v13:BuffUp(v36.SliceandDice) or (v76 >= v34.CPMaxSpend());
	end
	local function v98()
		return v36.Premeditation:IsAvailable() and (v76 < (1104 - (35 + 1064)));
	end
	local function v99(v132)
		return (v13:BuffUp(v36.ThistleTea) and (v76 == (1 + 0))) or (v132 and ((v76 == (2 - 1)) or (v14:DebuffUp(v36.Rupture) and (v76 >= (1 + 1)))));
	end
	local function v100()
		return (not v13:BuffUp(v36.TheRotten) or not v13:HasTier(1266 - (298 + 938), 1261 - (233 + 1026))) and (not v36.ColdBlood:IsAvailable() or (v36.ColdBlood:CooldownRemains() < (1670 - (636 + 1030))) or (v36.ColdBlood:CooldownRemains() > (6 + 4)));
	end
	local function v101(v133)
		return v13:BuffUp(v36.ShadowDanceBuff) and (v133:TimeSinceLastCast() < v36.ShadowDance:TimeSinceLastCast());
	end
	local function v102()
		return ((v101(v36.Shadowstrike) or v101(v36.ShurikenStorm)) and (v101(v36.Eviscerate) or v101(v36.BlackPowder) or v101(v36.Rupture))) or not v36.DanseMacabre:IsAvailable();
	end
	local function v103()
		return (not v37.WitherbarksBranch:IsEquipped() and not v37.AshesoftheEmbersoul:IsEquipped()) or (not v37.WitherbarksBranch:IsEquipped() and (v37.WitherbarksBranch:CooldownRemains() <= (8 + 0))) or (v37.WitherbarksBranch:IsEquipped() and (v37.WitherbarksBranch:CooldownRemains() <= (3 + 5))) or v37.BandolierOfTwistedBlades:IsEquipped() or v36.InvigoratingShadowdust:IsAvailable();
	end
	local function v104(v134, v135)
		local v136 = 0 + 0;
		local v137;
		local v138;
		local v139;
		local v140;
		local v141;
		local v142;
		local v143;
		while true do
			if ((v136 == (225 - (55 + 166))) or ((462 + 1917) > (461 + 4117))) then
				if ((v36.BlackPowder:IsCastable() and not v88 and (v76 >= (11 - 8)) and not v44) or ((780 - (36 + 261)) > (1298 - 555))) then
					if (((3822 - (34 + 1334)) > (223 + 355)) and v134) then
						return v36.BlackPowder;
					else
						if (((723 + 207) < (5741 - (1035 + 248))) and v36.BlackPowder:IsReady() and v19(v36.BlackPowder)) then
							return "Cast Black Powder";
						end
						v90(v36.BlackPowder);
					end
				end
				if (((683 - (20 + 1)) <= (507 + 465)) and v36.Eviscerate:IsCastable() and v71) then
					if (((4689 - (134 + 185)) == (5503 - (549 + 584))) and v134) then
						return v36.Eviscerate;
					else
						local v224 = 685 - (314 + 371);
						while true do
							if ((v224 == (0 - 0)) or ((5730 - (478 + 490)) <= (457 + 404))) then
								if ((v36.Eviscerate:IsReady() and v19(v36.Eviscerate)) or ((2584 - (786 + 386)) == (13811 - 9547))) then
									return "Cast Eviscerate";
								end
								v90(v36.Eviscerate);
								break;
							end
						end
					end
				end
				return false;
			end
			if ((v136 == (1380 - (1055 + 324))) or ((4508 - (1093 + 247)) < (1914 + 239))) then
				v141 = v36.ColdBlood:CooldownRemains();
				v142 = v36.SymbolsofDeath:CooldownRemains();
				v143 = v13:BuffUp(v36.PremeditationBuff) or (v135 and v36.Premeditation:IsAvailable());
				if ((v135 and (v135:ID() == v36.ShadowDance:ID())) or ((524 + 4452) < (5288 - 3956))) then
					local v216 = 0 - 0;
					while true do
						if (((13168 - 8540) == (11629 - 7001)) and (v216 == (1 + 0))) then
							if (v36.TheFirstDance:IsAvailable() or ((207 - 153) == (1361 - 966))) then
								v140 = v30(v13:ComboPointsMax(), v85 + 4 + 0);
							end
							if (((209 - 127) == (770 - (364 + 324))) and v13:HasTier(82 - 52, 4 - 2)) then
								v139 = v31(v139, 2 + 4);
							end
							break;
						end
						if (((0 - 0) == v216) or ((930 - 349) < (856 - 574))) then
							v137 = true;
							v138 = (1276 - (1249 + 19)) + v36.ImprovedShadowDance:TalentRank();
							v216 = 1 + 0;
						end
					end
				end
				v136 = 7 - 5;
			end
			if (((1088 - (686 + 400)) == v136) or ((3617 + 992) < (2724 - (73 + 156)))) then
				if (((6 + 1146) == (1963 - (721 + 90))) and v135 and (v135:ID() == v36.Vanish:ID())) then
					v141 = v30(0 + 0, v36.ColdBlood:CooldownRemains() - ((48 - 33) * v36.InvigoratingShadowdust:TalentRank()));
					v142 = v30(470 - (224 + 246), v36.SymbolsofDeath:CooldownRemains() - ((24 - 9) * v36.InvigoratingShadowdust:TalentRank()));
				end
				if (((3490 - 1594) <= (621 + 2801)) and v36.Rupture:IsCastable() and v36.Rupture:IsReady()) then
					if ((v14:DebuffDown(v36.Rupture) and (v14:TimeToDie() > (1 + 5))) or ((728 + 262) > (3220 - 1600))) then
						if (v134 or ((2918 - 2041) > (5208 - (203 + 310)))) then
							return v36.Rupture;
						else
							if (((4684 - (1238 + 755)) >= (130 + 1721)) and v36.Rupture:IsReady() and v19(v36.Rupture)) then
								return "Cast Rupture";
							end
							v90(v36.Rupture);
						end
					end
				end
				if ((not v13:StealthUp(true, true) and not v98() and (v76 < (1540 - (709 + 825))) and not v137 and v10.BossFilteredFightRemains(">", v13:BuffRemains(v36.SliceandDice)) and (v13:BuffRemains(v36.SliceandDice) < (((1 - 0) + v13:ComboPoints()) * (1.8 - 0)))) or ((3849 - (196 + 668)) >= (19172 - 14316))) then
					if (((8857 - 4581) >= (2028 - (171 + 662))) and v134) then
						return v36.SliceandDice;
					else
						if (((3325 - (4 + 89)) <= (16438 - 11748)) and v36.SliceandDice:IsReady() and v19(v36.SliceandDice)) then
							return "Cast Slice and Dice Premed";
						end
						v90(v36.SliceandDice);
					end
				end
				if (((not v99(v137) or v88) and (v14:TimeToDie() > (3 + 3)) and v14:DebuffRefreshable(v36.Rupture, v82)) or ((3935 - 3039) >= (1234 + 1912))) then
					if (((4547 - (35 + 1451)) >= (4411 - (28 + 1425))) and v134) then
						return v36.Rupture;
					else
						if (((5180 - (941 + 1052)) >= (618 + 26)) and v36.Rupture:IsReady() and v19(v36.Rupture)) then
							return "Cast Rupture";
						end
						v90(v36.Rupture);
					end
				end
				v136 = 1517 - (822 + 692);
			end
			if (((919 - 275) <= (332 + 372)) and (v136 == (297 - (45 + 252)))) then
				v137 = v13:BuffUp(v36.ShadowDanceBuff);
				v138 = v13:BuffRemains(v36.ShadowDanceBuff);
				v139 = v13:BuffRemains(v36.SymbolsofDeath);
				v140 = v85;
				v136 = 1 + 0;
			end
			if (((330 + 628) > (2304 - 1357)) and (v136 == (436 - (114 + 319)))) then
				if (((6449 - 1957) >= (3400 - 746)) and v13:BuffUp(v36.FinalityRuptureBuff) and v137 and (v76 <= (3 + 1)) and not v101(v36.Rupture)) then
					if (((5127 - 1685) >= (3148 - 1645)) and v134) then
						return v36.Rupture;
					else
						if ((v36.Rupture:IsReady() and v19(v36.Rupture)) or ((5133 - (556 + 1407)) <= (2670 - (741 + 465)))) then
							return "Cast Rupture Finality";
						end
						v90(v36.Rupture);
					end
				end
				if ((v36.ColdBlood:IsReady() and v102(v137, v143) and v36.SecretTechnique:IsReady() and (v85 >= (470 - (170 + 295)))) or ((2528 + 2269) == (4031 + 357))) then
					local v217 = 0 - 0;
					while true do
						if (((457 + 94) <= (437 + 244)) and (v217 == (0 + 0))) then
							if (((4507 - (957 + 273)) > (109 + 298)) and v134) then
								return v36.ColdBlood;
							end
							if (((1880 + 2815) >= (5391 - 3976)) and v24(v38.ColdBloodTechnique, nil, nil, true)) then
								return "Cast Cold Blood (SecTec)";
							end
							break;
						end
					end
				end
				if (v36.SecretTechnique:IsReady() or ((8464 - 5252) <= (2883 - 1939))) then
					if ((v102(v137, v143) and (not v36.ColdBlood:IsAvailable() or v13:BuffUp(v36.ColdBlood) or (v141 > (v138 - (9 - 7))) or not v36.ImprovedShadowDance:IsAvailable())) or ((4876 - (389 + 1391)) <= (1129 + 669))) then
						if (((369 + 3168) == (8052 - 4515)) and v134) then
							return v36.SecretTechnique;
						end
						if (((4788 - (783 + 168)) >= (5269 - 3699)) and v19(v36.SecretTechnique)) then
							return "Cast Secret Technique";
						end
					end
				end
				if ((not v99(v137) and v36.Rupture:IsCastable()) or ((2902 + 48) == (4123 - (309 + 2)))) then
					local v218 = 0 - 0;
					while true do
						if (((5935 - (1090 + 122)) >= (752 + 1566)) and (v218 == (0 - 0))) then
							if ((not v134 and v40 and not v88 and (v76 >= (2 + 0))) or ((3145 - (628 + 490)) > (512 + 2340))) then
								local function v233(v236)
									return v33.CanDoTUnit(v236, v83) and v236:DebuffRefreshable(v36.Rupture, v82);
								end
								v93(v36.Rupture, v233, (4 - 2) * v140, v77);
							end
							if ((v71 and (v14:DebuffRemains(v36.Rupture) < (v142 + (45 - 35))) and (v142 <= (779 - (431 + 343))) and v34.CanDoTUnit(v14, v83) and v14:FilteredTimeToDie(">", (10 - 5) + v142, -v14:DebuffRemains(v36.Rupture))) or ((3286 - 2150) > (3411 + 906))) then
								if (((608 + 4140) == (6443 - (556 + 1139))) and v134) then
									return v36.Rupture;
								else
									local v237 = 15 - (6 + 9);
									while true do
										if (((685 + 3051) <= (2429 + 2311)) and (v237 == (169 - (28 + 141)))) then
											if ((v36.Rupture:IsReady() and v19(v36.Rupture)) or ((1314 + 2076) <= (3777 - 717))) then
												return "Cast Rupture 2";
											end
											v90(v36.Rupture);
											break;
										end
									end
								end
							end
							break;
						end
					end
				end
				v136 = 3 + 1;
			end
		end
	end
	local function v105(v144, v145)
		local v146 = 1317 - (486 + 831);
		local v147;
		local v148;
		local v149;
		local v150;
		local v151;
		local v152;
		local v153;
		local v154;
		local v155;
		local v156;
		while true do
			if ((v146 == (0 - 0)) or ((3516 - 2517) > (509 + 2184))) then
				v147 = v13:BuffUp(v36.ShadowDanceBuff);
				v148 = v13:BuffRemains(v36.ShadowDanceBuff);
				v149 = v13:BuffUp(v36.TheRottenBuff);
				v146 = 3 - 2;
			end
			if (((1726 - (668 + 595)) < (541 + 60)) and (v146 == (1 + 2))) then
				v156 = v36.Shadowstrike:IsCastable() or v153 or v154 or v147 or v13:BuffUp(v36.SepsisBuff);
				if (v153 or v154 or ((5953 - 3770) < (977 - (23 + 267)))) then
					v156 = v156 and v14:IsInRange(1969 - (1129 + 815));
				else
					v156 = v156 and v71;
				end
				if (((4936 - (371 + 16)) == (6299 - (1326 + 424))) and v156 and v153 and ((v76 < (7 - 3)) or v88)) then
					if (((17072 - 12400) == (4790 - (88 + 30))) and v144) then
						return v36.Shadowstrike;
					elseif (v19(v36.Shadowstrike) or ((4439 - (720 + 51)) < (878 - 483))) then
						return "Cast Shadowstrike (Stealth)";
					end
				end
				v146 = 1780 - (421 + 1355);
			end
			if ((v146 == (2 - 0)) or ((2047 + 2119) == (1538 - (286 + 797)))) then
				v154 = v13:BuffUp(v34.VanishBuffSpell()) or (v145 and (v145:ID() == v36.Vanish:ID()));
				if ((v145 and (v145:ID() == v36.ShadowDance:ID())) or ((16263 - 11814) == (4410 - 1747))) then
					v147 = true;
					v148 = (447 - (397 + 42)) + v36.ImprovedShadowDance:TalentRank();
					if ((v36.TheRotten:IsAvailable() and v13:HasTier(10 + 20, 802 - (24 + 776))) or ((6588 - 2311) < (3774 - (222 + 563)))) then
						v149 = true;
					end
					if (v36.TheFirstDance:IsAvailable() or ((1916 - 1046) >= (2988 + 1161))) then
						local v225 = 190 - (23 + 167);
						while true do
							if (((4010 - (690 + 1108)) < (1149 + 2034)) and (v225 == (0 + 0))) then
								v150 = v30(v13:ComboPointsMax(), v85 + (852 - (40 + 808)));
								v151 = v13:ComboPointsMax() - v150;
								break;
							end
						end
					end
				end
				v155 = v34.EffectiveComboPoints(v150);
				v146 = 1 + 2;
			end
			if (((17766 - 13120) > (2860 + 132)) and (v146 == (3 + 1))) then
				if (((787 + 647) < (3677 - (47 + 524))) and (v155 >= v34.CPMaxSpend())) then
					return v104(v144, v145);
				end
				if (((511 + 275) < (8263 - 5240)) and v13:BuffUp(v36.ShurikenTornado) and (v151 <= (2 - 0))) then
					return v104(v144, v145);
				end
				if ((v86 <= ((2 - 1) + v26(v36.DeeperStratagem:IsAvailable() or v36.SecretStratagem:IsAvailable()))) or ((4168 - (1165 + 561)) < (3 + 71))) then
					return v104(v144, v145);
				end
				v146 = 15 - 10;
			end
			if (((1731 + 2804) == (5014 - (341 + 138))) and (v146 == (1 + 0))) then
				v150, v151 = v85, v86;
				v152 = v13:BuffUp(v36.PremeditationBuff) or (v145 and v36.Premeditation:IsAvailable());
				v153 = v13:BuffUp(v34.StealthSpell()) or (v145 and (v145:ID() == v34.StealthSpell():ID()));
				v146 = 3 - 1;
			end
			if ((v146 == (331 - (89 + 237))) or ((9679 - 6670) <= (4431 - 2326))) then
				if (((2711 - (581 + 300)) < (4889 - (855 + 365))) and v36.Backstab:IsCastable() and not v152 and (v148 >= (6 - 3)) and v13:BuffUp(v36.ShadowBlades) and not v101(v36.Backstab) and v36.DanseMacabre:IsAvailable() and (v76 <= (1 + 2)) and not v149) then
					if (v144 or ((2665 - (1030 + 205)) >= (3391 + 221))) then
						if (((2496 + 187) >= (2746 - (156 + 130))) and v145) then
							return v36.Backstab;
						else
							return {v36.Backstab,v36.Stealth};
						end
					elseif (v22(v36.Backstab, v36.Stealth) or ((3694 - 1890) >= (863 + 2412))) then
						return "Cast Backstab (Stealth)";
					end
				end
				if (v36.Gloomblade:IsAvailable() or ((827 + 590) > (3698 - (10 + 59)))) then
					if (((1357 + 3438) > (1979 - 1577)) and not v152 and (v148 >= (1166 - (671 + 492))) and v13:BuffUp(v36.ShadowBlades) and not v101(v36.Gloomblade) and v36.DanseMacabre:IsAvailable() and (v76 <= (4 + 0))) then
						if (((6028 - (369 + 846)) > (944 + 2621)) and v144) then
							if (((3339 + 573) == (5857 - (1036 + 909))) and v145) then
								return v36.Gloomblade;
							else
								return {v36.Gloomblade,v36.Stealth};
							end
						elseif (((3024 - (11 + 192)) <= (2438 + 2386)) and v22(v36.Gloomblade, v36.Stealth)) then
							return "Cast Gloomblade (Danse)";
						end
					end
				end
				if (((1913 - (135 + 40)) <= (5318 - 3123)) and not v101(v36.Shadowstrike) and v13:BuffUp(v36.ShadowBlades)) then
					if (((25 + 16) <= (6648 - 3630)) and v144) then
						return v36.Shadowstrike;
					elseif (((3215 - 1070) <= (4280 - (50 + 126))) and v19(v36.Shadowstrike)) then
						return "Cast Shadowstrike (Danse)";
					end
				end
				v146 = 16 - 10;
			end
			if (((596 + 2093) < (6258 - (1233 + 180))) and (v146 == (975 - (522 + 447)))) then
				if ((not v152 and (v76 >= (1425 - (107 + 1314)))) or ((1078 + 1244) > (7989 - 5367))) then
					if (v144 or ((1926 + 2608) == (4133 - 2051))) then
						return v36.ShurikenStorm;
					elseif (v19(v36.ShurikenStorm) or ((6215 - 4644) > (3777 - (716 + 1194)))) then
						return "Cast Shuriken Storm";
					end
				end
				if (v156 or ((46 + 2608) >= (321 + 2675))) then
					if (((4481 - (74 + 429)) > (4058 - 1954)) and v144) then
						return v36.Shadowstrike;
					elseif (((1485 + 1510) > (3527 - 1986)) and v19(v36.Shadowstrike)) then
						return "Cast Shadowstrike";
					end
				end
				return false;
			end
		end
	end
	local function v106(v157, v158)
		local v159 = v105(true, v157);
		if (((2299 + 950) > (2937 - 1984)) and v43 and (v157:ID() == v36.Vanish:ID()) and (not v48 or not v159)) then
			if (v19(v36.Vanish, nil) or ((8092 - 4819) > (5006 - (279 + 154)))) then
				return "Cast Vanish";
			end
			return false;
		elseif (((v157:ID() == v36.Shadowmeld:ID()) and (not v49 or not v159)) or ((3929 - (454 + 324)) < (1011 + 273))) then
			local v209 = 17 - (12 + 5);
			while true do
				if ((v209 == (0 + 0)) or ((4713 - 2863) == (566 + 963))) then
					if (((1914 - (277 + 816)) < (9071 - 6948)) and v19(v36.Shadowmeld, nil)) then
						return "Cast Shadowmeld";
					end
					return false;
				end
			end
		elseif (((2085 - (1058 + 125)) < (436 + 1889)) and (v157:ID() == v36.ShadowDance:ID()) and (not v50 or not v159)) then
			if (((1833 - (815 + 160)) <= (12708 - 9746)) and v19(v36.ShadowDance, nil)) then
				return "Cast Shadow Dance";
			end
			return false;
		end
		local v160 = {v157,v159};
		if ((v158 and (v13:EnergyPredicted() < v158)) or ((11534 - 7588) < (3186 - (41 + 1857)))) then
			v89(v160, v158);
			return false;
		end
		v78 = v22(unpack(v160));
		if (v78 or ((5135 - (1222 + 671)) == (1465 - 898))) then
			return "| " .. v160[2 - 0]:Name();
		end
		return false;
	end
	local function v107()
		if ((not v13:IsCasting() and not v13:IsChanneling()) or ((2029 - (229 + 953)) >= (3037 - (1111 + 663)))) then
			local v194 = 1579 - (874 + 705);
			local v195;
			while true do
				if ((v194 == (1 + 0)) or ((1538 + 715) == (3847 - 1996))) then
					if (v195 or ((59 + 2028) > (3051 - (642 + 37)))) then
						return v195;
					end
					v195 = v33.Interrupt(v36.Blind, 4 + 11, BlindInterrupt);
					if (v195 or ((712 + 3733) < (10416 - 6267))) then
						return v195;
					end
					v194 = 456 - (233 + 221);
				end
				if ((v194 == (4 - 2)) or ((1601 + 217) == (1626 - (718 + 823)))) then
					v195 = v33.Interrupt(v36.Blind, 10 + 5, BlindInterrupt, MouseOver, v38.BlindMouseover);
					if (((1435 - (266 + 539)) < (6021 - 3894)) and v195) then
						return v195;
					end
					v195 = v33.InterruptWithStun(v36.CheapShot, 1233 - (636 + 589), v13:StealthUp(false, false));
					v194 = 6 - 3;
				end
				if ((v194 == (5 - 2)) or ((1536 + 402) == (914 + 1600))) then
					if (((5270 - (657 + 358)) >= (145 - 90)) and v195) then
						return v195;
					end
					v195 = v33.InterruptWithStun(v36.KidneyShot, 18 - 10, v13:ComboPoints() > (1187 - (1151 + 36)));
					if (((2897 + 102) > (304 + 852)) and v195) then
						return v195;
					end
					break;
				end
				if (((7018 - 4668) > (2987 - (1552 + 280))) and (v194 == (834 - (64 + 770)))) then
					v195 = v33.Interrupt(v36.Kick, 6 + 2, true);
					if (((9145 - 5116) <= (862 + 3991)) and v195) then
						return v195;
					end
					v195 = v33.Interrupt(v36.Kick, 1251 - (157 + 1086), true, MouseOver, v38.KickMouseover);
					v194 = 1 - 0;
				end
			end
		end
		return false;
	end
	local function v108()
		local v161 = 0 - 0;
		local v162;
		while true do
			if ((v161 == (0 - 0)) or ((703 - 187) > (4253 - (599 + 220)))) then
				v162 = v33.HandleTopTrinket(v68, v41, 79 - 39, nil);
				if (((5977 - (1813 + 118)) >= (2218 + 815)) and v162) then
					return v162;
				end
				v161 = 1218 - (841 + 376);
			end
			if ((v161 == (2 - 0)) or ((632 + 2087) <= (3949 - 2502))) then
				return false;
			end
			if ((v161 == (860 - (464 + 395))) or ((10609 - 6475) < (1886 + 2040))) then
				v162 = v33.HandleBottomTrinket(v68, v41, 877 - (467 + 370), nil);
				if (v162 or ((338 - 174) >= (2045 + 740))) then
					return v162;
				end
				v161 = 6 - 4;
			end
		end
	end
	local function v109()
		local v163 = 0 + 0;
		while true do
			if ((v163 == (0 - 0)) or ((1045 - (150 + 370)) == (3391 - (74 + 1208)))) then
				if (((81 - 48) == (156 - 123)) and v41) then
					local v219 = 0 + 0;
					local v220;
					while true do
						if (((3444 - (14 + 376)) <= (6964 - 2949)) and (v219 == (0 + 0))) then
							v220 = v33.HandleDPSPotion(v10.BossFilteredFightRemains("<", 27 + 3) or (v13:BuffUp(v36.SymbolsofDeath) and (v13:BuffUp(v36.ShadowBlades) or (v36.ShadowBlades:CooldownRemains() <= (10 + 0)))));
							if (((5482 - 3611) < (2545 + 837)) and v220) then
								return v220;
							end
							break;
						end
					end
				end
				return false;
			end
		end
	end
	local function v110()
		local v164 = 78 - (23 + 55);
		local v165;
		while true do
			if (((3064 - 1771) <= (1446 + 720)) and (v164 == (1 + 0))) then
				if ((v41 and v36.Flagellation:IsAvailable() and v36.Flagellation:IsReady()) or ((3998 - 1419) < (39 + 84))) then
					if ((v97() and (v84 >= (906 - (652 + 249))) and (v14:TimeToDie() > (26 - 16)) and ((v103() and (v36.ShadowBlades:CooldownRemains() <= (1871 - (708 + 1160)))) or v10.BossFilteredFightRemains("<=", 75 - 47) or ((v36.ShadowBlades:CooldownRemains() >= (25 - 11)) and v36.InvigoratingShadowdust:IsAvailable() and v36.ShadowDance:IsAvailable())) and (not v36.InvigoratingShadowdust:IsAvailable() or v36.Sepsis:IsAvailable() or not v36.ShadowDance:IsAvailable() or ((v36.InvigoratingShadowdust:TalentRank() == (29 - (10 + 17))) and (v76 >= (1 + 1))) or (v36.SymbolsofDeath:CooldownRemains() <= (1735 - (1400 + 332))) or (v13:BuffRemains(v36.SymbolsofDeath) > (5 - 2)))) or ((2754 - (242 + 1666)) >= (1014 + 1354))) then
						if (v19(v36.Flagellation, nil, nil) or ((1471 + 2541) <= (2862 + 496))) then
							return "Cast Flagellation";
						end
					end
				end
				if (((2434 - (850 + 90)) <= (5262 - 2257)) and v41 and v36.SymbolsofDeath:IsReady()) then
					if ((v97() and (not v13:BuffUp(v36.TheRotten) or not v13:HasTier(1420 - (360 + 1030), 2 + 0)) and (v13:BuffRemains(v36.SymbolsofDeath) <= (7 - 4)) and (not v36.Flagellation:IsAvailable() or (v36.Flagellation:CooldownRemains() > (13 - 3)) or ((v13:BuffRemains(v36.ShadowDance) >= (1663 - (909 + 752))) and v36.InvigoratingShadowdust:IsAvailable()) or (v36.Flagellation:IsReady() and (v84 >= (1228 - (109 + 1114))) and not v36.InvigoratingShadowdust:IsAvailable()))) or ((5695 - 2584) == (831 + 1303))) then
						if (((2597 - (6 + 236)) == (1484 + 871)) and v19(v36.SymbolsofDeath, nil)) then
							return "Cast Symbols of Death";
						end
					end
				end
				if ((v41 and v36.ShadowBlades:IsReady()) or ((474 + 114) <= (1018 - 586))) then
					if (((8378 - 3581) >= (5028 - (1076 + 57))) and v97() and ((v84 <= (1 + 0)) or v13:HasTier(720 - (579 + 110), 1 + 3)) and (v13:BuffUp(v36.Flagellation) or v13:BuffUp(v36.FlagellationPersistBuff) or not v36.Flagellation:IsAvailable())) then
						if (((3163 + 414) == (1899 + 1678)) and v19(v36.ShadowBlades, nil)) then
							return "Cast Shadow Blades";
						end
					end
				end
				v164 = 409 - (174 + 233);
			end
			if (((10597 - 6803) > (6481 - 2788)) and (v164 == (2 + 1))) then
				if ((v41 and v36.ShadowDance:IsAvailable() and v91() and v36.ShadowDance:IsReady()) or ((2449 - (663 + 511)) == (3658 + 442))) then
					if ((not v13:BuffUp(v36.ShadowDance) and v10.BossFilteredFightRemains("<=", 2 + 6 + ((9 - 6) * v26(v36.Subterfuge:IsAvailable())))) or ((964 + 627) >= (8428 - 4848))) then
						if (((2379 - 1396) <= (863 + 945)) and v19(v36.ShadowDance)) then
							return "Cast Shadow Dance";
						end
					end
				end
				if ((v41 and v36.GoremawsBite:IsAvailable() and v36.GoremawsBite:IsReady()) or ((4184 - 2034) <= (854 + 343))) then
					if (((345 + 3424) >= (1895 - (478 + 244))) and v97() and (v86 >= (520 - (440 + 77))) and (not v36.ShadowDance:IsReady() or (v36.ShadowDance:IsAvailable() and v13:BuffUp(v36.ShadowDance) and not v36.InvigoratingShadowdust:IsAvailable()) or ((v76 < (2 + 2)) and not v36.InvigoratingShadowdust:IsAvailable()) or v36.TheRotten:IsAvailable())) then
						if (((5435 - 3950) == (3041 - (655 + 901))) and v19(v36.GoremawsBite)) then
							return "Cast Goremaw's Bite";
						end
					end
				end
				if (v36.ThistleTea:IsReady() or ((615 + 2700) <= (2130 + 652))) then
					if ((((v36.SymbolsofDeath:CooldownRemains() >= (3 + 0)) or v13:BuffUp(v36.SymbolsofDeath)) and not v13:BuffUp(v36.ThistleTea) and (((v13:EnergyDeficitPredicted() >= (402 - 302)) and ((v86 >= (1447 - (695 + 750))) or (v76 >= (9 - 6)))) or ((v36.ThistleTea:ChargesFractional() >= ((2.75 - 0) - ((0.15 - 0) * v36.InvigoratingShadowdust:TalentRank()))) and (v36.Vanish:IsReady() or not v43) and v13:BuffUp(v36.ShadowDance) and v14:DebuffUp(v36.Rupture) and (v76 < (354 - (285 + 66)))))) or ((v13:BuffRemains(v36.ShadowDance) >= (8 - 4)) and not v13:BuffUp(v36.ThistleTea) and (v76 >= (1313 - (682 + 628)))) or (not v13:BuffUp(v36.ThistleTea) and v10.BossFilteredFightRemains("<=", (1 + 5) * v36.ThistleTea:Charges())) or ((1175 - (176 + 123)) >= (1240 + 1724))) then
						if (v19(v36.ThistleTea, nil, nil) or ((1620 + 612) > (2766 - (239 + 30)))) then
							return "Thistle Tea";
						end
					end
				end
				v164 = 2 + 2;
			end
			if ((v164 == (4 + 0)) or ((3734 - 1624) <= (1035 - 703))) then
				v165 = v13:BuffUp(v36.ShadowBlades) or (not v36.ShadowBlades:IsAvailable() and v13:BuffUp(v36.SymbolsofDeath)) or v10.BossFilteredFightRemains("<", 335 - (306 + 9));
				if (((12862 - 9176) > (552 + 2620)) and v36.BloodFury:IsCastable() and v165 and v53) then
					if (v19(v36.BloodFury, nil) or ((2746 + 1728) < (395 + 425))) then
						return "Cast Blood Fury";
					end
				end
				if (((12236 - 7957) >= (4257 - (1140 + 235))) and v36.Berserking:IsCastable() and v165 and v53) then
					if (v19(v36.Berserking, nil) or ((1292 + 737) >= (3229 + 292))) then
						return "Cast Berserking";
					end
				end
				v164 = 2 + 3;
			end
			if (((52 - (33 + 19)) == v164) or ((736 + 1301) >= (13913 - 9271))) then
				if (((758 + 962) < (8742 - 4284)) and v41) then
					local v221 = 0 + 0;
					while true do
						if ((v221 == (690 - (586 + 103))) or ((40 + 396) > (9300 - 6279))) then
							if (((2201 - (1309 + 179)) <= (1528 - 681)) and v36.BagofTricks:IsReady() and v53) then
								if (((938 + 1216) <= (10825 - 6794)) and v19(v36.BagofTricks, nil)) then
									return "Cast Bag of Tricks";
								end
							end
							break;
						end
						if (((3486 + 1129) == (9805 - 5190)) and (v221 == (0 - 0))) then
							if ((v36.ArcaneTorrent:IsReady() and v71 and (v13:EnergyDeficitPredicted() >= ((624 - (295 + 314)) + v13:EnergyRegen())) and v53) or ((9309 - 5519) == (2462 - (1300 + 662)))) then
								if (((279 - 190) < (1976 - (1178 + 577))) and v19(v36.ArcaneTorrent, nil)) then
									return "Cast Arcane Torrent";
								end
							end
							if (((1067 + 987) >= (4200 - 2779)) and v36.ArcanePulse:IsReady() and v71 and v53) then
								if (((2097 - (851 + 554)) < (2705 + 353)) and v19(v36.ArcanePulse, nil)) then
									return "Cast Arcane Pulse";
								end
							end
							v221 = 2 - 1;
						end
					end
				end
				if ((v41 and v36.ColdBlood:IsReady() and not v36.SecretTechnique:IsAvailable() and (v85 >= (10 - 5))) or ((3556 - (115 + 187)) == (1268 + 387))) then
					if (v19(v36.ColdBlood, nil) or ((1227 + 69) == (19348 - 14438))) then
						return "Cast Cold Blood";
					end
				end
				if (((4529 - (160 + 1001)) == (2947 + 421)) and v41 and v36.Sepsis:IsAvailable() and v36.Sepsis:IsReady()) then
					if (((1824 + 819) < (7809 - 3994)) and v97() and v14:FilteredTimeToDie(">=", 374 - (237 + 121)) and (v13:BuffUp(v36.PerforatedVeins) or not v36.PerforatedVeins:IsAvailable())) then
						if (((2810 - (525 + 372)) > (933 - 440)) and v19(v36.Sepsis, nil, nil)) then
							return "Cast Sepsis";
						end
					end
				end
				v164 = 3 - 2;
			end
			if (((4897 - (96 + 46)) > (4205 - (643 + 134))) and (v164 == (1 + 1))) then
				if (((3311 - 1930) <= (8795 - 6426)) and v41 and v36.EchoingReprimand:IsCastable() and v36.EchoingReprimand:IsAvailable()) then
					if ((v97() and (v86 >= (3 + 0))) or ((9504 - 4661) == (8347 - 4263))) then
						if (((5388 - (316 + 403)) > (242 + 121)) and v19(v36.EchoingReprimand, nil, nil)) then
							return "Cast Echoing Reprimand";
						end
					end
				end
				if ((v41 and v67 and v36.ShurikenTornado:IsAvailable() and v36.ShurikenTornado:IsReady()) or ((5160 - 3283) >= (1135 + 2003))) then
					if (((11941 - 7199) >= (2570 + 1056)) and v97() and v13:BuffUp(v36.SymbolsofDeath) and (v84 <= (1 + 1)) and not v13:BuffUp(v36.Premeditation) and (not v36.Flagellation:IsAvailable() or (v36.Flagellation:CooldownRemains() > (69 - 49))) and (v76 >= (14 - 11))) then
						if (v19(v36.ShurikenTornado, nil) or ((9431 - 4891) == (53 + 863))) then
							return "Cast Shuriken Tornado";
						end
					end
				end
				if ((v41 and v67 and v36.ShurikenTornado:IsAvailable() and v36.ShurikenTornado:IsReady()) or ((2275 - 1119) > (213 + 4132))) then
					if (((6581 - 4344) < (4266 - (12 + 5))) and v97() and not v13:BuffUp(v36.ShadowDance) and not v13:BuffUp(v36.Flagellation) and not v13:BuffUp(v36.FlagellationPersistBuff) and not v13:BuffUp(v36.ShadowBlades) and (v76 <= (7 - 5))) then
						if (v19(v36.ShurikenTornado, nil) or ((5723 - 3040) < (48 - 25))) then
							return "Cast Shuriken Tornado";
						end
					end
				end
				v164 = 7 - 4;
			end
			if (((142 + 555) <= (2799 - (1656 + 317))) and (v164 == (5 + 0))) then
				if (((886 + 219) <= (3126 - 1950)) and v36.Fireblood:IsCastable() and v165 and v53) then
					if (((16629 - 13250) <= (4166 - (5 + 349))) and v19(v36.Fireblood, nil)) then
						return "Cast Fireblood";
					end
				end
				if ((v36.AncestralCall:IsCastable() and v165 and v53) or ((3742 - 2954) >= (2887 - (266 + 1005)))) then
					if (((1222 + 632) <= (11529 - 8150)) and v19(v36.AncestralCall, nil)) then
						return "Cast Ancestral Call";
					end
				end
				if (((5988 - 1439) == (6245 - (561 + 1135))) and v36.ThistleTea:IsReady()) then
					if ((((v36.SymbolsofDeath:CooldownRemains() >= (3 - 0)) or v13:BuffUp(v36.SymbolsofDeath)) and not v13:BuffUp(v36.ThistleTea) and (((v13:EnergyDeficitPredicted() >= (328 - 228)) and ((v13:ComboPointsDeficit() >= (1068 - (507 + 559))) or (v76 >= (7 - 4)))) or ((v36.ThistleTea:ChargesFractional() >= (6.75 - 4)) and v13:BuffUp(v36.ShadowDanceBuff)))) or ((v13:BuffRemains(v36.ShadowDanceBuff) >= (392 - (212 + 176))) and not v13:BuffUp(v36.ThistleTea) and (v76 >= (908 - (250 + 655)))) or (not v13:BuffUp(v36.ThistleTea) and v10.BossFilteredFightRemains("<=", (16 - 10) * v36.ThistleTea:Charges())) or ((5279 - 2257) >= (4730 - 1706))) then
						if (((6776 - (1869 + 87)) > (7623 - 5425)) and v19(v36.ThistleTea, nil, nil)) then
							return "Thistle Tea";
						end
					end
				end
				v164 = 1907 - (484 + 1417);
			end
			if ((v164 == (12 - 6)) or ((1777 - 716) >= (5664 - (48 + 725)))) then
				return false;
			end
		end
	end
	local function v111(v166)
		local v167 = 0 - 0;
		while true do
			if (((3659 - 2295) <= (2600 + 1873)) and (v167 == (0 - 0))) then
				if ((v41 and not (v33.IsSoloMode() and v13:IsTanking(v14))) or ((1007 + 2588) <= (1 + 2))) then
					if ((v43 and v36.Vanish:IsCastable()) or ((5525 - (152 + 701)) == (5163 - (430 + 881)))) then
						if (((598 + 961) == (2454 - (557 + 338))) and ((v86 > (1 + 0)) or (v13:BuffUp(v36.ShadowBlades) and v36.InvigoratingShadowdust:IsAvailable())) and not v95() and ((v36.Flagellation:CooldownRemains() >= (169 - 109)) or not v36.Flagellation:IsAvailable() or v10.BossFilteredFightRemains("<=", (105 - 75) * v36.Vanish:Charges())) and ((v36.SymbolsofDeath:CooldownRemains() > (7 - 4)) or not v13:HasTier(64 - 34, 803 - (499 + 302))) and ((v36.SecretTechnique:CooldownRemains() >= (876 - (39 + 827))) or not v36.SecretTechnique:IsAvailable() or ((v36.Vanish:Charges() >= (5 - 3)) and v36.InvigoratingShadowdust:IsAvailable() and (v13:BuffUp(v36.TheRotten) or not v36.TheRotten:IsAvailable())))) then
							local v231 = 0 - 0;
							while true do
								if ((v231 == (0 - 0)) or ((2689 - 937) <= (68 + 720))) then
									v78 = v106(v36.Vanish, v166);
									if (v78 or ((11435 - 7528) == (29 + 148))) then
										return "Vanish Macro " .. v78;
									end
									break;
								end
							end
						end
					end
					if (((5490 - 2020) > (659 - (103 + 1))) and v53 and v51 and (v13:Energy() < (594 - (475 + 79))) and v36.Shadowmeld:IsCastable()) then
						if (v21(v36.Shadowmeld, v13:EnergyTimeToX(86 - 46)) or ((3110 - 2138) == (84 + 561))) then
							return "Pool for Shadowmeld";
						end
					end
					if (((2801 + 381) >= (3618 - (1395 + 108))) and v53 and v36.Shadowmeld:IsCastable() and v71 and not v13:IsMoving() and (v13:EnergyPredicted() >= (116 - 76)) and (v13:EnergyDeficitPredicted() >= (1214 - (7 + 1197))) and not v95() and (v86 > (2 + 2))) then
						local v226 = 0 + 0;
						while true do
							if (((4212 - (27 + 292)) < (12978 - 8549)) and (v226 == (0 - 0))) then
								v78 = v106(v36.Shadowmeld, v166);
								if (v78 or ((12023 - 9156) < (3756 - 1851))) then
									return "Shadowmeld Macro " .. v78;
								end
								break;
							end
						end
					end
				end
				if ((v71 and v36.ShadowDance:IsCastable()) or ((3420 - 1624) >= (4190 - (43 + 96)))) then
					if (((6603 - 4984) <= (8491 - 4735)) and (v14:DebuffUp(v36.Rupture) or v36.InvigoratingShadowdust:IsAvailable()) and v100() and (not v36.TheFirstDance:IsAvailable() or (v86 >= (4 + 0)) or v13:BuffUp(v36.ShadowBlades)) and ((v96() and v95()) or ((v13:BuffUp(v36.ShadowBlades) or (v13:BuffUp(v36.SymbolsofDeath) and not v36.Sepsis:IsAvailable()) or ((v13:BuffRemains(v36.SymbolsofDeath) >= (2 + 2)) and not v13:HasTier(59 - 29, 1 + 1)) or (not v13:BuffUp(v36.SymbolsofDeath) and v13:HasTier(56 - 26, 1 + 1))) and (v36.SecretTechnique:CooldownRemains() < (1 + 9 + ((1763 - (1414 + 337)) * v26(not v36.InvigoratingShadowdust:IsAvailable() or v13:HasTier(1970 - (1642 + 298), 4 - 2)))))))) then
						local v227 = 0 - 0;
						while true do
							if (((1792 - 1188) == (199 + 405)) and ((0 + 0) == v227)) then
								v78 = v106(v36.ShadowDance, v166);
								if (v78 or ((5456 - (357 + 615)) == (632 + 268))) then
									return "ShadowDance Macro 1 " .. v78;
								end
								break;
							end
						end
					end
				end
				v167 = 2 - 1;
			end
			if ((v167 == (1 + 0)) or ((9555 - 5096) <= (891 + 222))) then
				return false;
			end
		end
	end
	local function v112(v168)
		local v169 = not v168 or (v13:EnergyPredicted() >= v168);
		if (((247 + 3385) > (2136 + 1262)) and v40 and v36.ShurikenStorm:IsCastable() and (v76 >= ((1303 - (384 + 917)) + v18((v36.Gloomblade:IsAvailable() and (v13:BuffRemains(v36.LingeringShadowBuff) >= (703 - (128 + 569)))) or v13:BuffUp(v36.PerforatedVeinsBuff))))) then
			local v196 = 1543 - (1407 + 136);
			while true do
				if (((5969 - (687 + 1200)) <= (6627 - (556 + 1154))) and (v196 == (0 - 0))) then
					if (((4927 - (9 + 86)) >= (1807 - (275 + 146))) and v169 and v19(v36.ShurikenStorm)) then
						return "Cast Shuriken Storm";
					end
					v89(v36.ShurikenStorm, v168);
					break;
				end
			end
		end
		if (((23 + 114) == (201 - (29 + 35))) and v71) then
			if (v36.Gloomblade:IsCastable() or ((6958 - 5388) >= (12939 - 8607))) then
				if ((v169 and v19(v36.Gloomblade)) or ((17940 - 13876) <= (1185 + 634))) then
					return "Cast Gloomblade";
				end
				v89(v36.Gloomblade, v168);
			elseif (v36.Backstab:IsCastable() or ((5998 - (53 + 959)) < (1982 - (312 + 96)))) then
				local v222 = 0 - 0;
				while true do
					if (((4711 - (147 + 138)) > (1071 - (813 + 86))) and ((0 + 0) == v222)) then
						if (((1085 - 499) > (947 - (18 + 474))) and v169 and v19(v36.Backstab)) then
							return "Cast Backstab";
						end
						v89(v36.Backstab, v168);
						break;
					end
				end
			end
		end
		return false;
	end
	local function v113()
		local v170 = 0 + 0;
		while true do
			if (((2695 - 1869) == (1912 - (860 + 226))) and ((303 - (121 + 182)) == v170)) then
				if ((v57 and v42 and v36.Shiv:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v33.UnitHasEnrageBuff(v14)) or ((495 + 3524) > (5681 - (988 + 252)))) then
					if (((228 + 1789) < (1335 + 2926)) and v24(v36.Shiv, not IsInMeleeRange)) then
						return "shiv dispel enrage";
					end
				end
				if (((6686 - (49 + 1921)) > (970 - (223 + 667))) and v37.Healthstone:IsReady() and v58 and (v13:HealthPercentage() <= v59)) then
					if (v24(v38.Healthstone, nil, nil, true) or ((3559 - (51 + 1)) == (5631 - 2359))) then
						return "healthstone defensive 3";
					end
				end
				v170 = 1 - 0;
			end
			if ((v170 == (1126 - (146 + 979))) or ((248 + 628) >= (3680 - (311 + 294)))) then
				if (((12136 - 7784) > (1082 + 1472)) and v54 and (v13:HealthPercentage() <= v56)) then
					if ((v55 == "Refreshing Healing Potion") or ((5849 - (496 + 947)) < (5401 - (1233 + 125)))) then
						if (v37.RefreshingHealingPotion:IsReady() or ((767 + 1122) >= (3036 + 347))) then
							if (((360 + 1532) <= (4379 - (963 + 682))) and v24(v38.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((1605 + 318) < (3722 - (504 + 1000))) and (v55 == "Dreamwalker's Healing Potion")) then
						if (((1464 + 709) > (346 + 33)) and v37.DreamwalkersHealingPotion:IsReady()) then
							if (v24(v38.RefreshingHealingPotion, nil, nil, true) or ((245 + 2346) == (5026 - 1617))) then
								return "dreamwalker's healing potion defensive 4";
							end
						end
					end
				end
				return false;
			end
		end
	end
	local function v114()
		if (((3857 + 657) > (1934 + 1390)) and not v13:AffectingCombat() and v39) then
			local v197 = 182 - (156 + 26);
			while true do
				if ((v197 == (0 + 0)) or ((325 - 117) >= (4992 - (149 + 15)))) then
					if ((v36.Stealth:IsCastable() and (v65 == "Always")) or ((2543 - (890 + 70)) > (3684 - (39 + 78)))) then
						local v228 = 482 - (14 + 468);
						while true do
							if ((v228 == (0 - 0)) or ((3669 - 2356) == (410 + 384))) then
								v78 = v34.Stealth(v34.StealthSpell());
								if (((1906 + 1268) > (617 + 2285)) and v78) then
									return v78;
								end
								break;
							end
						end
					elseif (((1861 + 2259) <= (1117 + 3143)) and v36.Stealth:IsCastable() and (v65 == "Distance") and v14:IsInRange(v66)) then
						v78 = v34.Stealth(v34.StealthSpell());
						if (v78 or ((1689 - 806) > (4723 + 55))) then
							return v78;
						end
					end
					if ((not v13:BuffUp(v36.ShadowDanceBuff) and not v13:BuffUp(v34.VanishBuffSpell())) or ((12720 - 9100) >= (124 + 4767))) then
						local v229 = 51 - (12 + 39);
						while true do
							if (((3962 + 296) > (2900 - 1963)) and (v229 == (0 - 0))) then
								v78 = v34.Stealth(v34.StealthSpell());
								if (v78 or ((1444 + 3425) < (477 + 429))) then
									return v78;
								end
								break;
							end
						end
					end
					v197 = 2 - 1;
				end
				if ((v197 == (1 + 0)) or ((5920 - 4695) > (5938 - (1596 + 114)))) then
					if (((8688 - 5360) > (2951 - (164 + 549))) and v33.TargetIsValid() and (v14:IsSpellInRange(v36.Shadowstrike) or v71)) then
						if (((5277 - (1059 + 379)) > (1744 - 339)) and v13:StealthUp(true, true)) then
							local v232 = 0 + 0;
							while true do
								if ((v232 == (0 + 0)) or ((1685 - (145 + 247)) <= (417 + 90))) then
									v79 = v105(true);
									if (v79 or ((1339 + 1557) < (2386 - 1581))) then
										if (((445 + 1871) == (1995 + 321)) and (type(v79) == "table") and (#v79 > (1 - 0))) then
											if (v25(nil, unpack(v79)) or ((3290 - (254 + 466)) == (2093 - (544 + 16)))) then
												return "Stealthed Macro Cast or Pool (OOC): " .. v79[2 - 1]:Name();
											end
										elseif (v21(v79) or ((1511 - (294 + 334)) == (1713 - (236 + 17)))) then
											return "Stealthed Cast or Pool (OOC): " .. v79:Name();
										end
									end
									break;
								end
							end
						elseif ((v85 >= (3 + 2)) or ((3596 + 1023) <= (3762 - 2763))) then
							v78 = v104();
							if (v78 or ((16144 - 12734) > (2120 + 1996))) then
								return v78 .. " (OOC)";
							end
						elseif (v36.Backstab:IsCastable() or ((744 + 159) >= (3853 - (413 + 381)))) then
							if (v19(v36.Backstab) or ((168 + 3808) < (6076 - 3219))) then
								return "Cast Backstab (OOC)";
							end
						end
					end
					return;
				end
			end
		end
	end
	local v115 = {{v36.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v36.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v85 > (0 + 0);
	end},{v36.CheapShot,"Cast Cheap Shot (Interrupt)",function()
		return v13:StealthUp(true, true);
	end}};
	local function v116()
		local v171 = 443 - (319 + 124);
		while true do
			if (((11269 - 6339) > (3314 - (564 + 443))) and (v171 == (0 - 0))) then
				v39 = EpicSettings.Toggles['ooc'];
				v40 = EpicSettings.Toggles['aoe'];
				v171 = 459 - (337 + 121);
			end
			if ((v171 == (2 - 1)) or ((13477 - 9431) < (3202 - (1261 + 650)))) then
				v41 = EpicSettings.Toggles['cds'];
				v42 = EpicSettings.Toggles['dispel'];
				v171 = 1 + 1;
			end
			if (((2 - 0) == v171) or ((6058 - (772 + 1045)) == (501 + 3044))) then
				v43 = EpicSettings.Toggles['vanish'];
				v44 = EpicSettings.Toggles['funnel'];
				break;
			end
		end
	end
	local function v117()
		v45 = EpicSettings.Settings['BurnShadowDance'];
		v46 = EpicSettings.Settings['UsePriorityRotation'];
		v47 = EpicSettings.Settings['RangedMultiDoT'];
		v48 = EpicSettings.Settings['StealthMacroVanish'];
		v49 = EpicSettings.Settings['StealthMacroShadowmeld'];
		v50 = EpicSettings.Settings['StealthMacroShadowDance'];
		v51 = EpicSettings.Settings['PoolForShadowmeld'];
		v52 = EpicSettings.Settings['EviscerateDMGOffset'] or (145 - (102 + 42));
		v53 = EpicSettings.Settings['UseRacials'];
		v54 = EpicSettings.Settings['UseHealingPotion'];
		v55 = EpicSettings.Settings['HealingPotionName'];
		v56 = EpicSettings.Settings['HealingPotionHP'] or (1845 - (1524 + 320));
		v57 = EpicSettings.Settings['DispelBuffs'];
		v58 = EpicSettings.Settings['UseHealthstone'];
		v59 = EpicSettings.Settings['HealthstoneHP'] or (1271 - (1049 + 221));
		v60 = EpicSettings.Settings['InterruptWithStun'];
		v61 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v62 = EpicSettings.Settings['InterruptThreshold'];
		v63 = EpicSettings.Settings['AutoFocusTank'];
		v64 = EpicSettings.Settings['AutoTricksTank'];
		v67 = EpicSettings.Settings['UseShurikenTornado'];
		v65 = EpicSettings.Settings['UsageStealthOOC'];
		v66 = EpicSettings.Settings['StealthRange'] or (156 - (18 + 138));
	end
	local function v118()
		v117();
		v116();
		v79 = nil;
		v81 = nil;
		v80 = 0 - 0;
		v69 = (v36.AcrobaticStrikes:IsAvailable() and (1110 - (67 + 1035))) or (353 - (136 + 212));
		v70 = (v36.AcrobaticStrikes:IsAvailable() and (55 - 42)) or (9 + 1);
		v71 = v14:IsInMeleeRange(v69);
		v72 = v14:IsInMeleeRange(v70);
		v73 = v14:IsInMeleeRange(14 + 1);
		if (v40 or ((5652 - (240 + 1364)) > (5314 - (1050 + 32)))) then
			v74 = v13:GetEnemiesInRange(107 - 77);
			v75 = v13:GetEnemiesInMeleeRange(v70);
			v76 = #v75;
			v77 = v13:GetEnemiesInMeleeRange(v69);
		else
			v74 = {};
			v75 = {};
			v76 = 1 + 0;
			v77 = {};
		end
		v85 = v13:ComboPoints();
		v84 = v34.EffectiveComboPoints(v85);
		v86 = v13:ComboPointsDeficit();
		v88 = v92();
		v87 = v13:EnergyMax() - v94();
		if ((v13:BuffUp(v36.ShurikenTornado, nil, true) and (v85 < v34.CPMaxSpend())) or ((2805 - (331 + 724)) >= (281 + 3192))) then
			local v198 = v34.TimeToNextTornado();
			if (((3810 - (269 + 375)) == (3891 - (267 + 458))) and ((v198 <= v13:GCDRemains()) or (v32(v13:GCDRemains() - v198) < (0.25 + 0)))) then
				local v210 = 0 - 0;
				local v211;
				while true do
					if (((2581 - (667 + 151)) < (5221 - (1410 + 87))) and (v210 == (1898 - (1504 + 393)))) then
						v86 = v31(v86 - v211, 0 - 0);
						if (((147 - 90) <= (3519 - (461 + 335))) and (v84 < v34.CPMaxSpend())) then
							v84 = v85;
						end
						break;
					end
					if ((v210 == (0 + 0)) or ((3831 - (1730 + 31)) == (2110 - (728 + 939)))) then
						v211 = v76 + v26(v13:BuffUp(v36.ShadowBlades));
						v85 = v30(v85 + v211, v34.CPMaxSpend());
						v210 = 3 - 2;
					end
				end
			end
		end
		v82 = ((7 - 3) + (v84 * (9 - 5))) * (1068.3 - (138 + 930));
		v83 = v36.Eviscerate:Damage() * v52;
		if ((not v13:AffectingCombat() and v63) or ((2472 + 233) == (1090 + 303))) then
			local v199 = v33.FocusUnitIgnoreRange(false, nil, "TANK", 18 + 2);
			if (v199 or ((18787 - 14186) < (1827 - (459 + 1307)))) then
				return v199;
			end
		end
		if ((v23 and v64 and (v33.UnitGroupRole(v23) == "TANK") and v36.TricksoftheTrade:IsCastable() and v73) or ((3260 - (474 + 1396)) >= (8283 - 3539))) then
			if (v24(v38.TricksoftheTradeFocus) or ((1878 + 125) > (13 + 3821))) then
				return "tricks of the trade tank";
			end
		end
		v78 = v34.CrimsonVial();
		if (v78 or ((446 - 290) > (496 + 3417))) then
			return v78;
		end
		v78 = v34.Feint();
		if (((650 - 455) == (850 - 655)) and v78) then
			return v78;
		end
		v34.Poisons();
		v78 = v114();
		if (((3696 - (562 + 29)) >= (1532 + 264)) and v78) then
			return v78;
		end
		if (((5798 - (374 + 1045)) >= (1687 + 444)) and v33.TargetIsValid()) then
			v78 = v107();
			if (((11936 - 8092) >= (2681 - (448 + 190))) and ShoulReturn) then
				return "Interrupts " .. v78;
			end
			v78 = v113();
			if (ShoulReturn or ((1044 + 2188) <= (1233 + 1498))) then
				return v78;
			end
			v78 = v110();
			if (((3196 + 1709) == (18858 - 13953)) and v78) then
				return "CDs: " .. v78;
			end
			v78 = v108();
			if (v78 or ((12851 - 8715) >= (5905 - (1307 + 187)))) then
				return "Trinkets";
			end
			v78 = v109();
			if (v78 or ((11730 - 8772) == (9405 - 5388))) then
				return "DPS Potion";
			end
			if (((3765 - 2537) >= (1496 - (232 + 451))) and v36.SliceandDice:IsCastable() and (v76 < v34.CPMaxSpend()) and (v13:BuffRemains(v36.SliceandDice) < v13:GCD()) and v10.BossFilteredFightRemains(">", 6 + 0) and (v85 >= (4 + 0))) then
				local v212 = 564 - (510 + 54);
				while true do
					if ((v212 == (0 - 0)) or ((3491 - (13 + 23)) > (7894 - 3844))) then
						if (((348 - 105) == (440 - 197)) and v36.SliceandDice:IsReady() and v19(v36.SliceandDice)) then
							return "Cast Slice and Dice (Low Duration)";
						end
						v90(v36.SliceandDice);
						break;
					end
				end
			end
			if (v13:StealthUp(true, true) or ((1359 - (830 + 258)) > (5545 - 3973))) then
				local v213 = 0 + 0;
				while true do
					if (((2331 + 408) < (4734 - (860 + 581))) and (v213 == (0 - 0))) then
						v79 = v105(true);
						if (v79 or ((3129 + 813) < (1375 - (237 + 4)))) then
							if (((type(v79) == "table") and (#v79 > (2 - 1))) or ((6812 - 4119) == (9428 - 4455))) then
								if (((1757 + 389) == (1233 + 913)) and v25(nil, unpack(v79))) then
									return "Stealthed Macro " .. v79[3 - 2]:Name() .. "|" .. v79[1 + 1]:Name();
								end
							elseif ((v67 and v13:BuffUp(v36.ShurikenTornado) and (v85 ~= v13:ComboPoints()) and ((v79 == v36.BlackPowder) or (v79 == v36.Eviscerate) or (v79 == v36.Rupture) or (v79 == v36.SliceandDice))) or ((1221 + 1023) == (4650 - (85 + 1341)))) then
								if (v25(nil, v36.ShurikenTornado, v79) or ((8367 - 3463) <= (5411 - 3495))) then
									return "Stealthed Tornado Cast  " .. v79:Name();
								end
							elseif (((462 - (45 + 327)) <= (2009 - 944)) and (type(v79) ~= "boolean")) then
								if (((5304 - (444 + 58)) == (2087 + 2715)) and v21(v79)) then
									return "Stealthed Cast " .. v79:Name();
								end
							end
						end
						v213 = 1 + 0;
					end
					if ((v213 == (1 + 0)) or ((6607 - 4327) <= (2243 - (64 + 1668)))) then
						v19(v36.PoolEnergy);
						return "Stealthed Pooling";
					end
				end
			end
			local v200;
			if (not v36.Vigor:IsAvailable() or v36.Shadowcraft:IsAvailable() or ((3649 - (1227 + 746)) <= (1423 - 960))) then
				v200 = v13:EnergyDeficitPredicted() <= v94();
			else
				v200 = v13:EnergyPredicted() >= v94();
			end
			if (((7180 - 3311) == (4363 - (415 + 79))) and (v200 or v36.InvigoratingShadowdust:IsAvailable())) then
				v78 = v111(v87);
				if (((30 + 1128) <= (3104 - (142 + 349))) and v78) then
					return "Stealth CDs: " .. v78;
				end
			end
			if ((v84 >= v34.CPMaxSpend()) or ((1013 + 1351) <= (2747 - 748))) then
				local v214 = 0 + 0;
				while true do
					if ((v214 == (0 + 0)) or ((13404 - 8482) < (2058 - (1710 + 154)))) then
						v78 = v104();
						if (v78 or ((2409 - (200 + 118)) < (13 + 18))) then
							return "Finish: " .. v78;
						end
						break;
					end
				end
			end
			if ((v86 <= (1 - 0)) or (v10.BossFilteredFightRemains("<=", 1 - 0) and (v84 >= (3 + 0))) or ((2404 + 26) >= (2615 + 2257))) then
				local v215 = 0 + 0;
				while true do
					if ((v215 == (0 - 0)) or ((6020 - (363 + 887)) < (3029 - 1294))) then
						v78 = v104();
						if (v78 or ((21128 - 16689) <= (363 + 1987))) then
							return "Finish: " .. v78;
						end
						break;
					end
				end
			end
			if (((v76 >= (9 - 5)) and (v84 >= (3 + 1))) or ((6143 - (674 + 990)) < (1281 + 3185))) then
				v78 = v104();
				if (((1043 + 1504) > (1941 - 716)) and v78) then
					return "Finish: " .. v78;
				end
			end
			if (((5726 - (507 + 548)) > (3511 - (289 + 548))) and v81) then
				v89(v81);
			end
			v78 = v112(v87);
			if (v78 or ((5514 - (821 + 997)) < (3582 - (195 + 60)))) then
				return "Build: " .. v78;
			end
			if ((v79 and v71) or ((1222 + 3320) == (4471 - (251 + 1250)))) then
				if (((738 - 486) <= (1359 + 618)) and (type(v79) == "table") and (#v79 > (1033 - (809 + 223)))) then
					if (v25(v13:EnergyTimeToX(v80), unpack(v79)) or ((2095 - 659) == (11336 - 7561))) then
						return "Macro pool towards " .. v79[3 - 2]:Name() .. " at " .. v80;
					end
				elseif (v79:IsCastable() or ((1192 + 426) < (487 + 443))) then
					local v230 = 617 - (14 + 603);
					while true do
						if (((4852 - (118 + 11)) > (672 + 3481)) and (v230 == (0 + 0))) then
							v80 = v31(v80, v79:Cost());
							if (v21(v79, v13:EnergyTimeToX(v80)) or ((10648 - 6994) >= (5603 - (551 + 398)))) then
								return "Pool towards: " .. v79:Name() .. " at " .. v80;
							end
							break;
						end
					end
				end
			end
			if (((602 + 349) <= (533 + 963)) and v36.ShurikenToss:IsCastable() and v14:IsInRange(25 + 5) and not v72 and not v13:StealthUp(true, true) and not v13:BuffUp(v36.Sprint) and (v13:EnergyDeficitPredicted() < (74 - 54)) and ((v86 >= (2 - 1)) or (v13:EnergyTimeToMax() <= (1.2 + 0)))) then
				if (v21(v36.ShurikenToss) or ((6891 - 5155) == (158 + 413))) then
					return "Cast Shuriken Toss";
				end
			end
		end
	end
	local function v119()
		local v191 = 89 - (40 + 49);
		while true do
			if ((v191 == (0 - 0)) or ((1386 - (99 + 391)) > (3945 + 824))) then
				v10.Print("Subtlety Rogue by Epic BoomK");
				EpicSettings.SetupVersion("Subtlety Rogue  X v 10.2.5.05 By BoomK");
				break;
			end
		end
	end
	v10.SetAPL(1147 - 886, v118, v119);
end;
return v0["Epix_Rogue_Subtlety.lua"]();

